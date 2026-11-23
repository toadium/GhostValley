# bench

GhostValley 的性能基准：引擎、记忆、检索、衰减、序列化、Qwen 回放与训练管道。

[← 返回总览](../README.md)

## 运行

```bash
moon run bench --target native --release
```

## 基准项

| 操作 | 迭代 | 说明 |
|---|---:|---|
| `engine.new[200]` | 2000 | 创建 200 容量引擎 |
| `add_memory[200]` | 2000 | 写入记忆（触发遗忘） |
| `weighted_search[200]` | 2000 | value/similarity/recency 加权检索 |
| `apply_decay[200]` | 500 | 双曲衰减 |
| `cleanup_low_value[200]` | 500 | 低价值清理 |
| `save_engine_state[200]` | 200 | 状态序列化 |
| `qwen.generate[24]` | 5000 | 精选语料回放 |
| `training_pipeline[8]` | 100 | 8 轮训练管道 |

（另有预热迭代，不计入结果。）

## 输出格式

```
operation | iterations | total_ms | us_per_iter
```

数值随机器而变，不写入文档作为固定承诺；CI 只做 smoke。

## 行为说明

- 仅 native release；使用 `@async.now()` 计时。
- 基准包不参与覆盖率统计（`check_coverage` 排除 `bench/`）。

## 相关

- [根 README](../README.md)
- [CLI](../cli/README.md)
- [测试与质量报告](../docs/TEST_REPORT.md)