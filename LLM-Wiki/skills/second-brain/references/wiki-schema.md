# Wiki Schema

由 LLM 维护的知识库 wiki 规范规则。这是单一真源（single source of truth）—— agent 配置模板都应从本文档提取。

## Architecture

三个目录，三个角色：

- **raw/** — 不可变的来源文档。LLM 只读取，绝不修改这些文件。
- **wiki/** — LLM 的工作区。所有创建、更新与维护都在这里进行。
- **output/** — 报告、查询结果与生成产物放在这里。

wiki 子目录：
- `wiki/sources/` — 每个已导入来源对应一个摘要页
- `wiki/entities/` — 人物、组织、产品、工具页面
- `wiki/concepts/` — 想法、框架、理论、模式页面
- `wiki/synthesis/` — 对比、分析与跨主题综合页面

两个特殊文件：
- `wiki/index.md` — 所有 wiki 页面的主目录，按分类组织。每次 ingest 都要更新。
- `wiki/log.md` — 仅追加的时间序记录。不要编辑历史条目。

## Page Format

每个 wiki 页面都必须包含 YAML frontmatter：

    ---
    tags: [tag1, tag2]
    sources: [source-filename-1.md, source-filename-2.md]
    created: YYYY-MM-DD
    updated: YYYY-MM-DD
    ---

所有内部链接均使用 `[[wikilink]]`。当你提到某个已有独立页面的概念、实体或来源时，必须加链接。

## Operations

### Ingest（处理新来源）

当用户向 raw/ 添加文件并要求处理时：

1. 完整读取来源
2. 与用户讨论关键要点
3. 在 `wiki/sources/` 创建来源摘要页，包含：标题、来源元数据、关键主张、结构化摘要
4. 识别涉及的全部实体与概念。对每一项：
   - 若页面已存在：补充该来源的新信息并标注来源
   - 若页面不存在：在对应子目录创建新页
5. 在相关页面之间补全 `[[wikilinks]]`
6. 将新页面写入 `wiki/index.md`
7. 在 `wiki/log.md` 追加：`## [YYYY-MM-DD] ingest | Source Title`

单个来源触达 10-15 个 wiki 页面是正常现象。

### Query（回答问题）

当用户提问时：

1. 读取 `wiki/index.md` 定位相关页面
2. 读取相关 wiki 页面
3. 给出带 `[[wikilink]]` 引用的综合答案
4. 若答案产出有价值沉淀（对比、分析、新连接），提议保存到 `wiki/synthesis/`
5. 若保存了新页面，同步更新 index 与 log

### Lint（健康检查）

当用户要求 lint/健康检查 wiki 时：

1. 扫描页面间矛盾
2. 识别被新来源淘汰的过时结论
3. 识别孤立页面（无入链）
4. 查找被提及但缺少独立页面的重要概念
5. 检查缺失交叉引用
6. 建议可通过网络搜索补齐的数据空白
7. 汇报发现并询问是否修复
8. 记录 lint：`## [YYYY-MM-DD] lint | Summary of findings`

## Index Format

`wiki/index.md` 每个条目占一行：

    - [[Page Name]] — one-line summary

按以下分类标题组织：Sources、Entities、Concepts、Synthesis。

## Log Format

`wiki/log.md` 每条记录格式：

    ## [YYYY-MM-DD] operation | Title
    Brief description of what was done.

## Page Naming

文件名使用 **kebab-case** + `.md` 扩展名；文件内页面标题使用 **Title Case**。

- 来源页：`wiki/sources/article-title-here.md` → `# Article Title Here`
- 实体页：`wiki/entities/entity-name.md` → `# Entity Name`
- 概念页：`wiki/concepts/concept-name.md` → `# Concept Name`
- 综合页：`wiki/synthesis/comparison-topic.md` → `# Comparison Topic`

创建 `[[wikilinks]]` 时，使用页面标题（Title Case）而非文件名：
- 正确：`[[Entity Name]]`
- 错误：`[[entity-name]]`

将标题 slug 化为文件名时：小写、空格替换为连字符、移除特殊字符、并控制在合理长度。

## Image Handling

网页剪藏文章通常包含图片。处理规则如下：

1. **先将图片下载到本地。** 在 Obsidian 设置的 Files and links 中，将 "Attachment folder path" 设为 `raw/assets/`。剪藏后使用 "Download attachments for current file"（可绑定快捷键如 Ctrl+Shift+D）。
2. **在 wiki 页面引用图片** 时，使用标准 Markdown：`![description](../raw/assets/image-name.png)`。图片保留在 `raw/assets/`，不要复制到 `wiki/`。
3. **导入过程中**，记录来源中的图片。若图片含关键信息（图表、示意图、数据），需在 wiki 页面中用文字描述其内容，确保知识可被文本检索与复用。

## Lint Frequency

按以下频率运行 lint（`/second-brain-lint`）：
- **每 10 次 ingest 后** — 能在问题还新鲜时捕捉交叉引用缺口
- **至少每月一次** — 能发现随时间积累的过时结论与孤立页面
- **任何重大查询或综合前** — 在依赖 wiki 做分析前确保其健康

## Tools

你可以使用以下 CLI 工具，并在合适场景调用：

- **summarize** — 总结链接、文件和媒体。用法见 `summarize --help`。
- **qmd** — Markdown 本地搜索引擎。用法见 `qmd --help`。当 wiki 大到 index.md 不便导航时使用。
- **agent-browser** — 网页研究浏览器自动化工具。当 web_search 或 web_fetch 失败时使用。

## Rules

1. 绝不修改 `raw/` 中的文件。它们是不可变来源材料。
2. 创建或删除页面时，必须更新 `wiki/index.md`。
3. 执行任何操作时，必须向 `wiki/log.md` 追加日志。
4. 所有内部引用都用 `[[wikilinks]]`，页面内容中不要写原始文件路径。
5. 每个 wiki 页面都必须有包含 tags、sources、created、updated 的 YAML frontmatter。
6. 当新信息与已有内容冲突时，更新页面并标注冲突，同时引用双方来源。
7. 来源摘要页保持事实性；解释与综合放在 concept/synthesis 页面。
8. 回答问题时先搜索 wiki；仅在 wiki 无答案时查看 raw 来源。
9. 优先更新已有页面；仅当主题足够独立时才新建页面。
10. `wiki/index.md` 保持简洁 —— 每页一行，每条不超过 120 字符。
