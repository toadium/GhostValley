# Contributing to GhostValley

## 开发环境

- MoonBit 工具链：`moon version --all`（建议 0.1.20261117+）
- Node.js 22+（质量脚本）
- Python 3.11+（可选：Qwen 语料生成/评测）

## 本地门禁

```bash
moon fmt --check
moon check --target all --warn-list +73 --deny-warn
moon test  --target all --warn-list +73 --deny-warn
node scripts/check_coverage.mjs --min 90
node scripts/mutation_test.mjs
node scripts/check_docs.mjs
```

提交前必须全部通过；若改动 `qwen_*.mbt`，同时更新 `docs/QWEN_EVAL.md` / `docs/TEST_REPORT.md` 的数字。

## 代码约定

- 每块以 `///|` 分隔；函数 snake_case。
- `pub(all) struct/enum` 用于外部构造；测试文件用 `_test.mbt` / `_wbtest.mbt`。
- 新增公开 API 需补测试与 README 对应条目。
- `--warn-list +73 --deny-warn` 下保持 0 warning；`#derive(...)`、`StringBuilder()` 为当前推荐写法。

## 提交与评审

- 一个提交只做一件事；提交信息写“为什么”。
- 修改 LLM/安全相关逻辑时，说明对 Qwen 回放、质量门槛、安全回退的影响。
- 不提交模型权重、个人路径、临时产物；`_build/`、`.tmp/`、`coverage.txt` 已忽略。