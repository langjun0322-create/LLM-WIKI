---
name: Agent-Wiki
description: >
  使用 LLM Wiki 模式初始化新的 Obsidian 知识库。当用户想创建 second brain、
  初始化 vault、搭建个人知识库，或说“onboard”时使用。通过交互式向导配置
  vault 名称、位置、领域、Agent 支持和工具。
allowed-tools: Bash Read Write Glob Grep
---

# Second Brain — 初始化向导

使用 LLM Wiki 模式搭建新的 Obsidian 知识库。LLM 扮演图书管理员角色：读取原始来源、整理成结构化互链 wiki，并长期维护。

## 向导流程

按以下 4 个步骤引导用户。一次只问一个问题。每一步都有默认值，用户可以直接接受或自行填写。

### 第 1 步：Vault 名称

提问：
> "你希望把知识库命名为什么？这会作为文件夹名称。"
> 默认值：`Vault`

接受用户提供的任意名称。该名称将用于文件夹名和 agent 配置标题。

### 第 2 步：Vault 位置

提问：
> "要把它创建在哪？给我一个路径，或使用默认路径。"
> 默认值：`~/Documents/`

接受绝对或相对路径。将 `~` 解析为用户主目录。最终 vault 路径为 `{location}/{vault-name}/`。

### 第 3 步：领域 / 主题

提问：
> "这个知识库主要关注什么？这有助于我生成相关标签并描述 vault 的用途。"
>
> 示例："AI research"、"competitive intelligence on fintech startups"、"personal health and fitness"

接受自由文本。并据此：
- 写出一行领域描述用于 agent 配置
- 生成 5-8 个领域相关建议标签

### 第 4 步：Agent 配置

直接在工作区 `@skills` 下生成 `agent.md`（不生成在知识库目录下）


### 备注：可选 CLI 工具

这些工具可扩展 LLM 对 vault 的能力，均为可选但推荐：

1. **summarize** — 在 CLI 中总结链接、文件和媒体
2. **qmd** — 你的 wiki 本地搜索引擎（规模变大后很有用）
3. **agent-browser** — 用于网页研究的浏览器自动化

默认作为备注提示，不作为向导必答步骤；仅在用户明确希望安装时再继续询问安装选项。

## 向导后：搭建 Vault 结构

收集完所有答案后，按顺序执行以下步骤：

### 1. 创建目录结构

运行初始化脚本，并传入完整 vault 路径：

```
bash <skill-directory>/scripts/onboarding.sh <vault-path>
```

该脚本会创建完整目录和初始 `wiki/index.md`、`wiki/log.md` 文件。

### 2. 生成 agent 配置文件

从 `<skill-directory>/references/agent-configs/agent.md` 读取模板

对每个模板替换占位符：

- `{{VAULT_NAME}}` → 第 1 步的 vault 名称
- `{{DOMAIN_DESCRIPTION}}` → 基于第 3 步生成的一行领域描述
- `{{DOMAIN_TAGS}}` → 基于第 3 步生成的 5-8 个领域标签（项目符号）
- `{{WIKI_SCHEMA}}` → 读取 `<skill-directory>/references/wiki-schema.md`，插入从 `## Architecture` 开始的全部内容

将生成后的配置直接写入并覆盖工作区 `skills/agent.md`。

### 3. 更新 wiki/log.md

追加初始化日志：

```
## [YYYY-MM-DD] setup | Vault initialized
Created vault "{{VAULT_NAME}}" for {{DOMAIN_DESCRIPTION}}.
Agent configs: {{list of generated config files}}.
```


### 4. 生成agent.md如果已经存在就覆盖输出结果摘要

向用户展示：

1. **已创建内容** — 目录树和配置文件
2. **必做下一步** — 安装 Obsidian Web Clipper 浏览器扩展：
   > 安装 Obsidian Web Clipper 以便将网页文章快速保存到你的 vault：
   > https://chromewebstore.google.com/detail/obsidian-web-clipper/cnjifjpddelmedmihgijeibhnjfabmlf
3. **开始方式** — 在 Obsidian 中打开该 vault 文件夹，将文章剪藏到 `raw/`，然后运行 `/Agent-Wiki-ingest`

## 参考文件

以下文件随技能提供，位于 `<skill-directory>/references/`：

- `wiki-schema.md` — 规范化 wiki 规则（所有 agent 配置的单一真源）
- `agent-configs/agent.md` — CLAUDE.md 模板
- `agent-configs/codex.md` — AGENTS.md 模板
- `agent-configs/cursor.md` — Cursor 规则模板
- `agent-configs/gemini.md` — GEMINI.md 模板

## 下一步

完成初始化后，用户工作流如下：

1. 用 Obsidian Web Clipper 将文章剪藏到 `raw/`
2. 运行 `/Agent-Wiki-ingest` 导入来源并生成 wiki 页面
3. 运行 `/Agent-Wiki-query` 在 wiki 中搜索与综合答案
4. 每 10 次导入后或每月运行 `/Agent-Wiki-lint` 做健康检查
