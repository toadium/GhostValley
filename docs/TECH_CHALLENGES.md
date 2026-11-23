# 技术攻关三点

## 1. 确定性回放：让 0.5B 模型输出在四后端完全一致

**难在哪**
- 模型运行时依赖 native/Python/CPU，无法在 wasm/js 复用。
- LLM 输出随机，直接进训练会让测试不可重复。

**怎么解**
- Python 真实推理一次，生成 `qwen_corpus.mbt`（12 条）与 `qwen_curated.mbt`（24 条精选）。
- MoonBit `QwenReplayLLM` 做精确/包含/相似度匹配；无模型、无网络。
- 144 次评测报告记录温度/seed/延迟/token，可重放生成。

**证据**
- 四后端 503 测试；`QwenReplayLLM::new_curated()` 可运行示例；
- `scripts/qwen_benchmark.py`、`curate_qwen_corpus.py` 可复现。

## 2. 质量与安全层：不把 0.5B 输出当结论

**难在哪**
- 0.5B 会空话、循环、过长、跑题；直接作为“顿悟”会污染记忆。
- 心理压力场景对安全边界敏感。

**怎么解**
- `qwen_assess_response`：长度、3-gram 重复、质量关键词、安全词、综合分。
- `qwen_is_acceptable`：15–80 字、重复 ≤0.35、无安全词、≥1 质量词。
- `QwenReplayLLM::new_strict()` / `new_curated()`：不合格回退安全句。
- `TrainingProtocol`：压力/信心/连续无改善/冷却期；`AuditLog` 记录。

**证据**
- 12 条基础语料 9/12 达标，精选 23/24；严格模式回退数量受测试约束；
- 9 个质量测试 + 13 个变异点。

## 3. 记忆系统：遗忘不是“存满再删”

**难在哪**
- 记忆无限增长会拖垮检索；全删又会破坏训练连续性。
- 需要同时保证核心记忆、模拟/真实隔离、衰减与容量不变量。

**怎么解**
- 触发：`max_memory_num / 2`（至少 1）；淘汰非核心 30%（至少 1）。
- 双曲衰减：`score *= factor / (factor + elapsed)`；阈值清理。
- `is_simulation` 强制隔离；核心记忆永不淘汰。
- 加权检索：value 0.4 + similarity 0.4 + recency 0.2。

**证据**
- 属性/模糊/边界测试；变异 M02/M08/M10 覆盖遗忘/清理/容量；
- 训练报告与仪表盘可观察记忆数与分数趋势。