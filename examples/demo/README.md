# 示例：完整工作流 demo

9 步演示 GhostValley 的核心闭环：验证 → 训练 → 记忆 → 报告 → 持久化。

[← 返回示例总览](../README.md) · [← 根 README](../../README.md)

## 运行

```bash
moon run examples/demo --target native
```

## 展示内容

| 步骤 | 内容 |
|---|---|
| 1 | 温石验证（态度文本打分） |
| 2 | `MockLLM` 自动训练 3 轮 |
| 3 | `ghost_valley_run_rounds(2)` 批量训练 |
| 4 | 写入 3 条模拟挫折记忆（`is_simulation=true`） |
| 5 | `text_value_score` 高/低价值文本对比 |
| 6 | `training_report().format()` |
| 7 | `save_memory_string` / `load_memory_string` 持久化 |
| 8 | `show_all_memory` 查看记忆 |
| 9 | `close_ghost_valley` 关闭训练场 |

## 关键 API

```moonbit
let gv = @ghostvalley.new_engine(max_memory_num=10)
let ok = gv.wen_shi_verify("愿意接受挑战，接受压力训练，想要自我迭代")
let _ = gv.run_round_with_llm(@ghostvalley.MockLLM::new())
gv.add_memory("模拟失败经验", is_simulation=true)
println(gv.training_report().format())
```

## 相关

- [引擎与 API](../../README.mbt.md)
- [Qwen 精选示例](../qwen_curated/README.md)