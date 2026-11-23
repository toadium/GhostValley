# 示例：Qwen 精选回放

使用 24 条精选 Qwen2.5-0.5B-Instruct 语料跑 8 轮训练，并展示质量摘要。

[← 返回示例总览](../README.md) · [← 根 README](../../README.md)

## 运行

```bash
moon run examples/qwen_curated --target native
```

## 预期输出

```
=== GhostValley · Qwen 精选回放 ===
Qwen curated quality: accepted=23/24 ...
基础语料：Qwen corpus quality: accepted=9/12 ...
温石验证：true
...
训练轮次: 8
```

## 展示内容

- `QwenReplayLLM::new_curated()`：24 条精选语料，默认质量门槛
- 精选 23/24、基础 9/12 达质量门槛
- 8 轮训练 + 完整训练报告
- 无模型、无网络：语料编译进包，四后端一致

## 关键 API

```moonbit
let gv = @ghostvalley.new_engine(max_memory_num=40)
let llm = @ghostvalley.QwenReplayLLM::new_curated()
let ok = gv.wen_shi_verify("愿意接受挑战，接受压力训练")
gv.run_training_pipeline(llm, rounds=8, decay_interval=4, cleanup_threshold=0.1)
```

## 重新生成语料（可选）

```bash
python scripts/qwen_generate.py
python scripts/qwen_benchmark.py
python scripts/curate_qwen_corpus.py
```

## 相关

- [Qwen 评测](../../docs/QWEN_EVAL.md)
- [大规模评测](../../docs/QWEN_BENCHMARK.md)
- [模型卡](../../docs/MODEL_CARD.md)