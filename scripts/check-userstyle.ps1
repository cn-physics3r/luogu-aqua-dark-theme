Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$cssPath = Join-Path $repoRoot 'luogu-aqua-dark.user.css'
$readmePath = Join-Path $repoRoot 'README.md'

function Assert-Check {
  param(
    [Parameter(Mandatory)] [bool] $Condition,
    [Parameter(Mandatory)] [string] $Message
  )

  if (-not $Condition) {
    throw "UserStyle check failed: $Message"
  }
}

function Resolve-LctHex {
  param(
    [Parameter(Mandatory)] [string] $Token,
    [Parameter(Mandatory)] [hashtable] $Definitions,
    [Parameter(Mandatory)] [AllowEmptyCollection()] [System.Collections.Generic.HashSet[string]] $Visited
  )

  Assert-Check $Definitions.ContainsKey($Token) "missing definition for --$Token"
  Assert-Check $Visited.Add($Token) "circular token reference involving --$Token"

  $value = $Definitions[$Token].Trim()
  if ($value -match '^#[0-9a-fA-F]{6}$') {
    return $value
  }

  if ($value -match '^var\(--(?<token>lct-[a-z0-9-]+)\)$') {
    return Resolve-LctHex $Matches.token $Definitions $Visited
  }

  throw "UserStyle check failed: --$Token does not resolve to a six-digit hex color"
}

$css = Get-Content -Raw -LiteralPath $cssPath
$readme = Get-Content -Raw -LiteralPath $readmePath

$userStyles = @(Get-ChildItem -LiteralPath $repoRoot -Filter '*.user.css' -File)
Assert-Check ($userStyles.Count -eq 1) 'the repository must contain exactly one .user.css entry'
Assert-Check ($userStyles[0].Name -eq 'luogu-aqua-dark.user.css') 'the sole UserStyle entry has an unexpected name'

$metadata = [regex]::Match($css, '(?s)/\* ==UserStyle==(?<body>.*?)==/UserStyle== \*/')
Assert-Check $metadata.Success 'UserStyle metadata block is missing or malformed'

foreach ($key in @('name', 'namespace', 'version', 'description', 'author', 'homepageURL', 'supportURL', 'updateURL')) {
  Assert-Check ([regex]::IsMatch($metadata.Groups['body'].Value, "(?m)^@$key\s+\S")) "metadata @$key is missing"
}

$namespaceMatch = [regex]::Match($metadata.Groups['body'].Value, '(?m)^@namespace\s+(?<namespace>\S+)\s*$')
Assert-Check ($namespaceMatch.Groups['namespace'].Value -eq 'github.com/cn-physics3r/luogu-aqua-dark-theme') '@namespace differs from the current stable Stylus identity'

$cssVersionMatch = [regex]::Match($metadata.Groups['body'].Value, '(?m)^@version\s+(?<version>\d+\.\d+\.\d+)\s*$')
$readmeVersionMatch = [regex]::Match($readme, '当前版本为\s+`(?<version>\d+\.\d+\.\d+)`')
Assert-Check $cssVersionMatch.Success 'metadata @version must use three numeric parts'
Assert-Check $readmeVersionMatch.Success 'README current version is missing'
Assert-Check ($cssVersionMatch.Groups['version'].Value -eq $readmeVersionMatch.Groups['version'].Value) 'CSS and README versions differ'

$documentRules = [regex]::Matches($css, '@-moz-document\s+domain\("(?<domain>[^\"]+)"\)')
Assert-Check ($documentRules.Count -eq 1) 'expected exactly one @-moz-document domain rule'
Assert-Check ($documentRules[0].Groups['domain'].Value -eq 'www.luogu.com.cn') 'UserStyle scope must remain www.luogu.com.cn'
Assert-Check (-not [regex]::IsMatch($css, 'url\s*\(', 'IgnoreCase')) 'external url(...) resources are not allowed'

$openBraces = ([regex]::Matches($css, '\{')).Count
$closeBraces = ([regex]::Matches($css, '\}')).Count
Assert-Check ($openBraces -eq $closeBraces) "brace count differs ($openBraces open, $closeBraces close)"

$definitions = @{}
foreach ($match in [regex]::Matches($css, '(?m)^\s*--(?<name>lct-[a-z0-9-]+):\s*(?<value>[^;]+);')) {
  $definitions[$match.Groups['name'].Value] = $match.Groups['value'].Value
}

$references = [regex]::Matches($css, 'var\(--(?<name>lct-[a-z0-9-]+)') |
  ForEach-Object { $_.Groups['name'].Value } |
  Sort-Object -Unique
foreach ($reference in $references) {
  Assert-Check $definitions.ContainsKey($reference) "undefined theme token --$reference"
}

$hexMappings = @{}
foreach ($match in [regex]::Matches($css, '(?m)^\s*--lfe-color--(?<key>[a-z0-9-]+):\s*var\(--(?<token>lct-[a-z0-9-]+)\)\s*!important;')) {
  $hexMappings[$match.Groups['key'].Value] = $match.Groups['token'].Value
}

$rgbMappings = @{}
foreach ($match in [regex]::Matches($css, '(?m)^\s*--lcolor--(?<key>[a-z0-9-]+):\s*(?<r>\d+)\s*,\s*(?<g>\d+)\s*,\s*(?<b>\d+)\s*!important;')) {
  $rgbMappings[$match.Groups['key'].Value] = @(
    [int] $match.Groups['r'].Value,
    [int] $match.Groups['g'].Value,
    [int] $match.Groups['b'].Value
  )
}

Assert-Check ($hexMappings.Count -eq $rgbMappings.Count) 'hex and RGB Luogu palette mapping counts differ'
foreach ($key in $hexMappings.Keys) {
  Assert-Check $rgbMappings.ContainsKey($key) "missing RGB mapping for --lfe-color--$key"
  $visited = [System.Collections.Generic.HashSet[string]]::new()
  $hex = Resolve-LctHex $hexMappings[$key] $definitions $visited
  $expected = @(
    [Convert]::ToInt32($hex.Substring(1, 2), 16),
    [Convert]::ToInt32($hex.Substring(3, 2), 16),
    [Convert]::ToInt32($hex.Substring(5, 2), 16)
  )
  $actual = $rgbMappings[$key]
  Assert-Check (($expected -join ',') -eq ($actual -join ',')) "hex/RGB palette mismatch for $key"
}

Write-Host "UserStyle checks passed: version $($cssVersionMatch.Groups['version'].Value), $openBraces rule braces, $($definitions.Count) theme tokens, $($hexMappings.Count) paired Luogu palette mappings."
