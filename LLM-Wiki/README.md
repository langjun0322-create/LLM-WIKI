# Skills Workspace README

这个目录存放当前项目的 skills（`second-brain` 及其子技能）。

## 当前实现说明

- 本项目当前使用的是基于 `second-brain` 的定制版本（已按 openclaw 单 agent 场景调整）。
- 初始化流程会按模板生成并覆盖工作区 `skills/agent.md`。
- 多 agent 配置逻辑已裁剪为单 agent 流程。

## 重要提示

1. 本项目的实现参考并修改自 `second-brain` 仓库：  
   https://github.com/NicholasSpisak/second-brain
2. 原始理念来自 Andrej Karpathy 的 `llm-wiki` 想法文档：  
   https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f

## 推荐工作流

1. 运行初始化（`/Agent-Wiki`）
2. 将资料放入 `raw/`
3. 运行导入（`/Agent-Wiki-ingest`）
4. 运行查询（`/Agent-Wiki-query`）
5. 定期健康检查（`/Agent-Wiki-lint`）
