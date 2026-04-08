# 工具参考

在 second-brain vault 中工作时，可扩展 LLM 能力的 CLI 工具。

## 必需

### Obsidian Web Clipper

浏览器扩展，可将网页文章直接保存为干净的 Markdown 文件到你的 vault `raw/` 目录。

- **安装：** Chrome Web Store — https://chromewebstore.google.com/detail/obsidian-web-clipper/cnjifjpddelmedmihgijeibhnjfabmlf
- **设置：** 安装后，将默认 vault 路径配置为你 vault 的 `raw/` 目录
- **为何必需：** 这是将来源材料导入 vault 的主要方式，无需手动复制粘贴

## 可选（推荐）

### summarize

Summarize 可以通过真实提取管线将链接、文件与媒体整理为高质量摘要。可使用 CLI 自动化，也可用 Chrome 侧边栏一键总结。

- **安装：** `npm i -g @steipete/summarize`
- **验证：** `summarize --version`
- **用法：** `summarize --help` 查看完整功能
- **使用场景：** 在导入前或导入过程中总结网页、PDF、视频或任意媒体

### qmd

QMD（Query Markup Documents）是面向 Markdown 的本地搜索引擎，结合 BM25/向量混合检索与 LLM 重排，全部在本机完成。

- **安装：** `npm i -g @tobilu/qmd`
- **验证：** `qmd --version`
- **用法：** `qmd --help` 查看完整功能
- **使用场景：** 当 wiki 规模超过 `wiki/index.md` 的高效导航范围（约 100+ 页面）时

### agent-browser

面向 AI agent 的浏览器自动化 CLI。基于高性能 Rust 原生实现。适用于内置 `web_search`、`web_fetch` 或计算机操作工具失效时的网页研究与抓取。

- **安装：** `npm i -g agent-browser && agent-browser install`
- **验证：** `agent-browser --version`
- **用法：** `agent-browser --help` 查看完整功能
- **使用场景：** 内置工具失败或返回不完整结果时的网页研究任务
