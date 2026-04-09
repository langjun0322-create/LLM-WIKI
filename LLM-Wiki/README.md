# LLM-Wiki

基于 LLM Wiki 模式搭建个人 Obsidian 知识库。LLM 扮演图书管理员角色：读取原始来源、整理成结构化互链 wiki，并长期维护。

## 目录结构

```
LLM-Wiki/
├── setup.md                      # 初始化技能 (Agent-Wiki)
├── README.md                     # 本文件
├── second-brain/                 # 核心模块
│   ├── SKILL.md
│   ├── scripts/
│   │   └── onboarding.sh        # 初始化脚本
│   └── references/               # 配置文件
│       ├── agent-configs/        # Agent 配置模板
│       ├── tooling.md
│       └── wiki-schema.md        # Wiki 规范
├── second-brain-ingest/          # 导入技能 (Agent-Wiki-ingest)
├── second-brain-query/           # 查询技能 (Agent-Wiki-query)
└── second-brain-lint/            # 检查技能 (Agent-Wiki-lint)
```

## 工作流

```
┌─────────────────────────────────────────────────────────────┐
│                      完整工作流                              │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ /Agent-Wiki  │───▶│ 添加原始资料  │───▶│/Agent-Wiki-  │
│   初始化      │    │ 到 raw/      │    │   ingest     │
└──────────────┘    └──────────────┘    └──────────────┘
                                               │
                                               ▼
                    ┌──────────────┐    ┌──────────────┐
                    │/Agent-Wiki-  │◀───│   定期检查   │
                    │   query      │    │/Agent-Wiki-  │
                    └──────────────┘    │   lint       │
                                         └──────────────┘
```

### 1. 初始化 (`/Agent-Wiki`)

运行技能，按向导配置：
- Vault 名称
- Vault 位置（默认 `~/Documents/`）
- 领域/主题

初始化脚本会自动创建目录结构，并在根目录生成 `agent.md`。

### 2. 添加资料

将文章、笔记、网页内容放入 vault 的 `raw/` 目录。

### 3. 导入 (`/Agent-Wiki-ingest`)

将 `raw/` 中的原始资料解析、提取、生成 wiki 页面：
- `wiki/sources/` — 来源页面
- `wiki/entities/` — 实体页面
- `wiki/concepts/` — 概念页面
- `wiki/synthesis/` — 综合页面

### 4. 查询 (`/Agent-Wiki-query`)

在 wiki 中搜索与综合答案。

### 5. 健康检查 (`/Agent-Wiki-lint`)

每 10 次导入后或每月运行一次，检查链接完整性、孤立页面等。

## 安装方式

### 方式一：Claude Code Skills（推荐）

在 Claude Code 中直接使用技能：

```bash
/Agent-Wiki
```

### 方式二：手动克隆

```bash
git clone https://github.com/langjun0322-create/LLM-wiki-openclaw.git
cd LLM-wiki-openclaw
```

手动运行初始化脚本：

```bash
bash second-brain/scripts/onboarding.sh <vault-path>
```

## 依赖工具（可选）

| 工具 | 命令 | 说明 |
|------|------|------|
| summarize | `npm i -g @steipete/summarize` | 总结链接、文件和媒体 |
| qmd | `npm i -g @tobilu/qmd` | 本地搜索引擎 |
| agent-browser | `npm i -g agent-browser && agent-browser install` | 网页研究自动化 |

## 参考

- second-brain: https://github.com/NicholasSpisak/second-brain
- 原始理念: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
