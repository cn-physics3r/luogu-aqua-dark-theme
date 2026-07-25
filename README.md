# Luogu Codex Dark

一个通过 Stylus 加载的洛谷暗色用户样式，视觉方向参考 Codex：近黑/深灰表面、低饱和边框、冷蓝青色交互强调，同时保留洛谷原有的赛事图片、头像和页面布局。

## 安装

1. 安装浏览器扩展 [Stylus](https://add0n.com/stylus.html)。
2. 打开 `luogu-codex-dark.user.css`，复制全部内容。
3. 在 Stylus 中新建样式，粘贴并保存。
4. 访问 [洛谷](https://www.luogu.com.cn/)，确认样式已启用。

## 当前覆盖

- 首页登录态旧组件：`.wrapper.wrapped.lfe-body.header-layout.tiny`、`.header-layout > .background`、`main.lfe-body.mobile-body`、`.lg-index-content`、`.lg-article`、`#lg-slider`、`.am-panel.lg-index-contest`、`.am-comment-bd`、`.highcharts-root`。
- 题目页登录态组件：`.top-bar`、`.sidebar.lside`、`.user-nav.rside`、`.columba-content-wrap.main-content`、`.l-card.header-card`、`.l-card.problem`、`.l-card::before`、`.sidebar-container.reverse.layout`、`.lfe-h2`、`.lfe-h3`。
- 跨页面组件：表单、按钮、表格、标签页、弹窗、Markdown、代码块、评测状态色和滚动条。

这些选择器是在 2026-07-25 通过已登录浏览器核实洛谷主页和 `P1000` 题目页后写入的；同时确认了登录态顶部栏、左右侧栏、首页 Highcharts 图表、评论流，以及题目卡片的白色 `::before` 覆盖层。题解、评测记录和个人页仍未把未经页面确认的专属类名写进主题。

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
- 不对洛谷赛事横幅、头像和其他图片施加滤镜；题目页装饰背景也不修改，只移除卡片自身的白色覆盖层。
- 不改变页面信息架构和主要布局，只调整表面颜色、层级、边框和交互状态。
- 顶栏使用独立的深蓝灰表面、底部边界和柔和阴影，与页面内容保持明确层级。
- 后续若要继续增强，优先在已登录状态下补充题解、评测记录和个人主页的专属组件细节。
