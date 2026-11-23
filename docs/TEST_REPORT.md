# GhostValley 测试与质量报告

- 版本：**0.4.0**
- 日期：2026-11-21
- 测试：**505 / 503 × 4 后端**（native / wasm / wasm-gc / js）
- 覆盖率：**91.6%**（1356 / 1480，核心库；排除 examples）
- 变异测试：**14 / 14 KILLED**
- 严格门禁：`moon check --target all --warn-list +73 --deny-warn` → 0 warning 0 error
- 格式：`moon fmt --check` 通过

## 测试矩阵

| 类型 | 文件数 | 说明 |
|---|---:|---|
| 单元/黑盒测试 | 25 | 引擎、记忆、检索、衰减、训练、多智能体、课程、检查点、统计、情绪、协议、仪表盘 |
| 示例程序 | 4 | demo / onboarding / team_stress / customer_service |
| 属性/模糊测试 | 3 | fuzz_property / boundary / invariant_property（100 组序列） |
| Qwen 回放/质量 | 3 | qwen_adapter（9）+ qwen_quality（9）+ qwen_curated（5） |
| CLI / bench | 2 | 6 命令 + 9 组基准（native） |

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

14/14 KILLED，运行前后工作区一致（脚本自动恢复）。

## Qwen 回放

- 12 条基础回放（9/12 达标）与 24 条精选回放（23/24 达标）；144 次大规模评测（782ms/36.7 字/稳定性 0.238）。
- 质量层：12 条中 9 条达门槛；严格模式自动回退低质量/安全词响应。
- 语料由 `scripts/qwen_generate.py` 生成，`qwen_corpus.mbt` 编译进包，四后端确定性回放。
- 详见 `docs/QWEN_EVAL.md`。

## 基准（native release）

| 操作 | 迭代 | 总耗时 | us/iter |
|---|---:|---:|---:|
| engine.new[200] | 2000 | 9 ms | 4.5 |
| add_memory[200] | 2000 | 2 ms | 1.0 |
| weighted_search[200] | 2000 | 356 ms | 178 |
| apply_decay[200] | 500 | 2 ms | 4 |
| cleanup_low_value[200] | 500 | 0 ms | 0 |
| save_engine_state[200] | 200 | 1 ms | 5 |
| qwen.generate[24] | 5000 | 153 ms | 30.6 |
| training_pipeline[8] | 100 | 22 ms | 220 |

## 复现

```bash
moon check --target all --warn-list +73 --deny-warn
moon test  --target all --warn-list +73 --deny-warn
node scripts/check_coverage.mjs --min 90
node scripts/mutation_test.mjs
node scripts/check_docs.mjs
```