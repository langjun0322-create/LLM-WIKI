---
name: second-brain-ingest
description: >
  将 raw 来源文档处理成 wiki 页面。当用户向 raw/ 添加文件并希望导入、
  说“处理这个来源”“导入这篇文章”“我往 raw/ 里加了东西”，或希望把新材料
  纳入知识库时使用。
allowed-tools: Bash Read Write Edit Glob Grep
---

# Second Brain — 导入

将原始来源文档处理为结构化、相互链接的 wiki 页面。

## 识别要处理的来源

确定哪些文件需要导入：

1. 若用户明确指定文件，按指定文件处理
2. 若用户说“处理新来源”之类，自动识别未处理文件：
   - 列出 `raw/` 中所有文件（排除 `raw/assets/`）
   - 读取 `wiki/log.md`，从 `ingest` 日志中提取已处理来源文件名
   - `raw/` 中未出现在日志里的文件即为未处理文件
3. 若没有未处理文件，明确告知用户

## 逐个处理来源

对每个来源文件，按以下流程执行：

### 1. 完整读取来源

读取整个文件。若文件包含图片引用，先记录；如图片含关键信息，需单独读取图片内容。

### 2. 与用户确认关键要点

在写入任何内容前，先给出该来源最重要的 3-5 条结论。询问用户是否要强调某些方面或跳过某些主题。收到确认后再继续。

### 3. 创建来源摘要页

在 `wiki/sources/` 下创建以来源命名（slug 化）的新文件，内容包含：

    ---
    tags: [relevant, tags]
    sources: [original-filename.md]
    created: YYYY-MM-DD
    updated: YYYY-MM-DD
    ---

    # Source Title

    **Source:** original-filename.md
    **Date ingested:** YYYY-MM-DD
    **Type:** article | paper | transcript | notes | etc.

    ## Summary

    Structured summary of the source content.

    ## Key Claims

    - Claim 1
    - Claim 2
    - ...

    ## Entities Mentioned

    - [[Entity Name]] — brief context
    - ...

    ## Concepts Covered

    - [[Concept Name]] — brief context
    - ...

### 4. 更新实体页与概念页

针对来源中提到的每个实体（人、组织、产品、工具）与概念（想法、框架、理论、模式）：

**若 wiki 页面已存在：**
- 读取现有页面
- 增补来自该来源的新信息
- 将该来源加入 frontmatter 的 `sources:` 列表
- 更新 `updated:` 日期
- 若与已有内容冲突，标注冲突并同时引用两方来源

**若页面不存在：**
- 在对应子目录新建页面：
  - `wiki/entities/` 用于人物、组织、产品、工具
  - `wiki/concepts/` 用于想法、框架、理论、模式
- 添加包含 tags、sources、created、updated 的 YAML frontmatter
- 基于该来源对主题的描述撰写聚焦摘要

### 5. 添加 wikilink

确保所有相关页面都通过 `[[wikilink]]` 相互连接。凡是有独立页面的实体或概念，其提及处都应加链接。

### 6. 更新 wiki/index.md

每创建一个新页面，就在对应分类标题下加入一条：

    - [[Page Name]] — one-line summary (under 120 characters)

### 7. 更新 wiki/log.md

追加：

    ## [YYYY-MM-DD] ingest | Source Title
    Processed source-filename.md. Created N new pages, updated M existing pages.
    New entities: [[Entity1]], [[Entity2]]. New concepts: [[Concept1]].

### 8. 汇报结果

告诉用户已完成内容：
- 新建页面（附链接）
- 更新页面（说明改动）
- 新识别的实体与概念
- 与既有内容的任何冲突

## 约定

- 来源摘要页应 **只写事实**。解释与综合应放到 concept/synthesis 页面。
- 单个来源通常会触达 **10-15 个 wiki 页面**，这是正常现象。
- 当新信息与现有内容冲突时，**必须更新页面并标注冲突**，同时引用双方来源。
- **优先更新已有页面**，仅当主题足够独立时才新建页面。
- 所有内部引用使用 `[[wikilinks]]`，不要使用原始文件路径。

## 下一步

完成导入后，用户可以：
- 通过 `/second-brain-query` **提问**，探索已导入内容
- 继续 **导入更多来源**（再剪藏一篇文章后运行 `/second-brain-ingest`）
- 每 10 次导入后运行 `/second-brain-lint` **健康检查**，及时发现缺口
