---
name: second-brain-query
description: >
  基于知识库 wiki 回答问题。当用户就已收集知识提问、想探索主题间关联、
  说“我对 X 了解什么”、或希望搜索 wiki 时使用。
allowed-tools: Bash Read Write Edit Glob Grep
---

# Second Brain — 查询

通过搜索并综合 wiki 中的知识来回答问题。

## 搜索策略

### 1. 先看索引

读取 `wiki/index.md` 来定位相关页面。扫描所有分类区块（Sources、Entities、Concepts、Synthesis）中与问题相关的条目。

### 2. 大型 wiki 使用 qmd

如果已安装 `qmd`（通过 `command -v qmd` 检查），用它来搜索：

```bash
qmd search "query terms" --path wiki/
```

当 wiki 超过约 100 页、仅靠索引检索效率下降时，这尤其有用。

### 3. 读取相关页面

读取通过索引或搜索识别出的页面。沿着 `[[wikilinks]]` 补充相关上下文。读取足够多页面以给出完整答案，但不要通读整个 wiki。

### 4. 必要时检查原始来源

如果 wiki 页面不足以完整回答问题，查看 `wiki/sources/` 中相关来源摘要获取更多细节。仅在最后手段下才读取 `raw/` 中的文件。

## 综合答案

### 格式

根据问题匹配答案形式：
- **事实性问题** → 直接回答并附引用
- **对比问题** → 表格或结构化对比
- **探索性问题** → 叙述式说明并链接相关概念
- **列表/目录类问题** → 项目符号列表并附简短说明

### 引用

始终使用 `[[wikilink]]` 语法引用 wiki 页面。例如：

> 根据 [[Source - Article Title]]，关键发现是 X。这与 [[Concept Name]] 中描述的更广泛模式相关，而 [[Entity Name]] 也探索过该模式。

### 询问是否保存高价值答案

如果答案产出了值得沉淀的内容（如对比、分析、新连接或综合结论），应主动提议保存：

> "这份对比可能值得保存在你的 wiki 里。要我把它保存成一页 synthesis 页面吗？"

如果用户同意：
1. 在 `wiki/synthesis/` 创建新页面并写入规范 frontmatter
2. 在 `wiki/index.md` 的 Synthesis 分类下新增条目
3. 在 `wiki/log.md` 追加：`## [YYYY-MM-DD] query | Question summary`

## 约定

- **先搜 wiki。** 仅当 wiki 无法回答时才查看 raw 来源。
- **必须标注来源。** 每个事实性结论都应链接到其来源页面。
- **高价值答案要沉淀。** 鼓励将优质分析回写到 wiki。
- 所有内部引用都使用 `[[wikilinks]]`，不要使用原始文件路径。

## 相关技能

- `/second-brain-ingest` — 将新来源处理成 wiki 页面
- `/second-brain-lint` — 对 wiki 做健康检查
