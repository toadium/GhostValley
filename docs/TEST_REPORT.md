# GhostValley 测试与质量报告

- 版本：**1.13.0**
- 日期：2026-11-21
- 测试：**489 / 489 × 4 后端**（native / wasm / wasm-gc / js）
- 覆盖率：**91.6%**（1281 / 1399，核心库；排除 examples）
- 变异测试：**10 / 10 KILLED**
- 严格门禁：`moon check --target all --warn-list +73 --deny-warn` → 0 warning 0 error
- 格式：`moon fmt --check` 通过

## 测试矩阵

| 类型 | 文件数 | 说明 |
|---|---:|---|
| 单元/黑盒测试 | 25 | 引擎、记忆、检索、衰减、训练、多智能体、课程、检查点、统计、情绪、协议、仪表盘 |
| 示例程序 | 4 | demo / onboarding / team_stress / customer_service |
| 属性/模糊测试 | 2 | fuzz_property / boundary |
| Qwen 回放 | 1 | qwen_adapter_test（9 项） |

## 覆盖率

```bash
moon coverage analyze -- -f summary
node scripts/check_coverage.mjs --min 90
```

- 核心库：1281 / 1399 = **91.6%**
- 最低文件：`event_system.mbt`（75.0%）、`persistence.mbt`（84.7%）
- 门槛：CI 要求 ≥ 90%；examples 不计入。

## 变异测试

```bash
node scripts/mutation_test.mjs
```

| ID | 变异 | 结果 |
|---|---|---|
| M01 | 温石阈值 0.4 → 0.9 | KILLED |
| M02 | 主动遗忘永不触发 | KILLED |
| M03 | Qwen 回放前缀匹配失效 | KILLED |
| M04 | Qwen 清洗多空格压缩失效 | KILLED |
| M05 | Qwen 相同困境相似度 1.0 → 0.99 | KILLED |
| M06 | 训练轮次少一轮 | KILLED |
| M07 | 权重检索降序 → 升序 | KILLED |
| M08 | 清理阈值方向反转 | KILLED |
| M09 | 对比平局胜者改 unknown | KILLED |
| M10 | 记忆容量触发阈值反转 | KILLED |

10/10 KILLED，运行前后工作区一致（脚本自动恢复）。

## Qwen 回放

- 12 条困境 × 真实 Qwen2.5-0.5B 响应；平均延迟 488 ms、平均长度 26.8 字、191 tokens。
- 语料由 `scripts/qwen_generate.py` 生成，`qwen_corpus.mbt` 编译进包，四后端确定性回放。
- 详见 `docs/QWEN_EVAL.md`。

## 复现

```bash
moon check --target all --warn-list +73 --deny-warn
moon test  --target all --warn-list +73 --deny-warn
node scripts/check_coverage.mjs --min 90
node scripts/mutation_test.mjs
node scripts/check_docs.mjs
```