# Luogu Codex Dark

一个通过 Stylus 加载的洛谷暗色用户样式，视觉方向参考 Codex：近黑/深灰表面、低饱和边框、冷蓝青色交互强调，同时保留洛谷原有的赛事图片、头像和页面布局。

## 安装

1. 安装浏览器扩展 [Stylus](https://add0n.com/stylus.html)。
2. 打开 `luogu-codex-dark.user.css`，复制全部内容。
3. 在 Stylus 中新建样式，粘贴并保存。
4. 访问 [洛谷](https://www.luogu.com.cn/)，确认样式已启用。

## 当前覆盖

- 首页登录态旧组件：`.wrapper.wrapped.lfe-body.header-layout.tiny`、`.header-layout > .background`、`main.lfe-body.mobile-body`、`.lg-index-content`、`.lg-article`、`#lg-slider`、`.am-panel.lg-index-contest`、`.am-comment-hd`、`.am-comment-bd`、`.highcharts-root`。
- 题目列表/题目页登录态组件：`.filter-section .text.lform-size-middle`、`.filter-section .refined-input.search-text`、`.filter-section .filter-tags .tag-button`、`.bottom-wrap.float`、`.l-card .luogu` 题库标签、`.l-card .result .count` 结果统计、`.l-card .header-wrap` 表头分隔线、`.columba-content-wrap.main-content > .sidebar-container.layout > .main > .l-card .title`、`.progress-frame`、题目列表 `.row` 分隔线、`.top-bar`、`.sidebar.lside`、`.user-nav.rside`、`.theme-page.theme-frosted`、`.theme-page.theme-frosted::before`、`.columba-content-wrap.main-content`、`.l-card.header-card`、`.l-card.problem`、`.l-card::before`、`.sidebar-container.reverse.layout`、`.lfe-h2`、`.lfe-h3`。
- 跨页面组件：表单、按钮、表格、标签页、弹窗、Markdown、代码块、评测状态色和滚动条；题目列表的标签选择弹窗包含专属深色覆盖。

这些选择器是在 2026-07-25 通过已登录浏览器核实洛谷主页和 `P1000` 题目页后写入的；同时确认了登录态顶部栏、左右侧栏、首页 Highcharts 图表、评论流，以及题目卡片的白色 `::before` 覆盖层。题解、评测记录和个人页仍未把未经页面确认的专属类名写进主题。

## 文件结构与维护顺序

项目保持单个可直接复制到 Stylus 的 CSS 文件，不引入构建工具。样式文件按以下顺序组织：

1. UserStyle 元数据和 `luogu.com.cn` 作用域。
2. 主题颜色、阴影、控件和状态令牌。
3. 基础样式、导航和页面外壳。
4. 首页、题目列表和题目页的专属覆盖。
5. 跨页面控件、代码块、Markdown 和语义状态。
6. 移动端覆盖。

新增规则应优先放在对应的页面或组件区块中；只有确认会跨页面复用时，才放入通用组件区块。原生 `input`、`button`、`table` 和 `pre` 规则限制在已知的洛谷应用根节点内，避免影响站点外层结构。

## 配色令牌

| 用途 | 颜色 |
| --- | --- |
| 页面背景 | `#171819` |
| 顶栏 | `#20252b` |
| 侧栏 | `#20252b` |
| 卡片 | `#1f2124` |
| 提升层 | `#26292d` |
| 边框 | `#343940` |
| 主文字 | `#e5e7eb` |
| 冷蓝青强调 | `#63b7d9` |
| 成功 | `#79ba91` |
| 警告 | `#d4ae68` |
| 错误 | `#db7f85` |

## 设计约束

- 纯 CSS，无 JavaScript、外部字体或外部图片资源。
- 不对洛谷赛事横幅、头像和其他图片施加滤镜；题目页装饰背景保持不变，只移除卡片自身的白色覆盖层。
- 不改变页面信息架构和主要布局，只调整表面颜色、层级、边框和交互状态。
- 顶栏使用独立的深蓝灰表面、底部边界和柔和阴影，与页面内容保持明确层级。
- 后续若要继续增强，优先在已登录状态下补充题解、评测记录和个人主页的专属组件细节。

## 手动验证清单

修改后至少检查以下页面和组件：

- 首页登录态：顶栏、左右侧栏、轮播图、赛事面板、评论和图表。
- `/problem/list`：题库切换标签、筛选器、搜索框、结果统计、分页、题目卡片和进度条。
- `/problem/P1000`：题目卡片、题面、代码块、标签、按钮和分隔线。
- 移动端宽度：页面宽度、卡片圆角和代码块横向滚动。
- 图片资源：赛事图片、头像和轮播图不应被暗色滤镜处理。

题解、评测记录和个人主页仍属于未完成的专属覆盖范围，新增选择器前应先在浏览器中确认实际 DOM。
