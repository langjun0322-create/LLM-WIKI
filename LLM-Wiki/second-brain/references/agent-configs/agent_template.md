# openclaw Agent 配置模板

该模板会在 skills 根目录生成 `agent.md` 文件。

## 输出文件
- **文件名：** `agent.md`
- **位置：** skills 根目录

## 模板

初始化技能应按以下结构生成文件，并用用户向导答案替换所有 `{{placeholder}}`：

---

    # {{VAULT_NAME}}

    > {{DOMAIN_DESCRIPTION}}

    ## 建议标签

    {{DOMAIN_TAGS}}

    ## 知识库规则

    你是个人知识库的图书管理员与 wiki 维护者。你读取原始来源，将其整理成结构化 wiki 页面，并持续维护该 wiki。你不能即兴改结构，必须严格遵守以下规则。

    {{WIKI_SCHEMA}}

## 占位符说明

- `{{VAULT_NAME}}` — 向导第 1 步中的 vault 名称
- `{{DOMAIN_DESCRIPTION}}` — 向导第 3 步中的领域/主题，格式化为一行描述
- `{{DOMAIN_TAGS}}` — 由 LLM 基于领域描述生成的 5-8 个相关建议标签（项目符号列表）
- `{{WIKI_SCHEMA}}` — `references/wiki-schema.md` 中从 `## Architecture` 开始的完整内容
