# Qwen2.5-0.5B-Instruct 本地评测

## 模型与运行环境

| 项 | 值 |
|---|---|
| 模型 | `Qwen2.5-0.5B-Instruct-GGUF`（`qwen2.5-0.5b-instruct-q4_k_m.gguf`） |
| 大小 | 469 MB |
| 来源 | ModelScope 缓存：`C:\Users\Administrator\.cache\modelscope\models\Qwen--Qwen2.5-0.5B-Instruct-GGUF` |
| 许可证 | Apache-2.0（模型）；llama-cpp-python 为 MIT |
| 推理 | llama-cpp-python 0.3.37（Windows CPU，n_threads=4） |
| 参数 | n_ctx=512，max_tokens=96，temperature=0.7，top_p=0.9，seed=42 |

模型权重不随仓库分发；`scripts/qwen_generate.py` 只生成本仓库使用的 12 条回放语料。

## 评测设置

- 数据：`Dilemma::default_pool()` 的 12 条困境，覆盖 cognitive / emotional / social / operational × 难度 1–3。
- Prompt：系统提示要求“用一句中文总结可执行经验，20–60 字，不提供标准答案”。
- 生成：Qwen chat template（`create_chat_completion`）。
- 落盘：`qwen_corpus.mbt`（编译进包，跨后端回放）+ `docs/qwen_eval.json`（机器可读）。

## 结果

| 指标 | 值 |
|---|---|
| 样本数 | 12 |
| 平均延迟 | 488 ms（288–964 ms） |
| 平均响应长度 | 26.8 字符 |
| 总 completion tokens | 191（9–27 / 条） |
| 回放命中率 | 12/12（精确/包含匹配） |
| 核心覆盖率 | 91.6%（1281/1399） |
| 测试 | 489 × 4 后端 |

### 样本摘录

| 分类/难度 | 响应 |
|---|---|
| cognitive/1 | 推理错误时，需要多次尝试以找到错误。 |
| cognitive/2 | 应先搜集完整的证据并进行判断。 |
| social/1 | 团队不信任时，先公开判断依据，再接受可验证的质疑。 |
| operational/1 | 工具不可用时，先用最小替代方案恢复关键路径。 |

（完整 12 条见 `qwen_corpus.mbt` 与 `docs/qwen_eval.json`。）

## 质量观察

- 0.5B 模型能给出“方向正确但偏泛化”的一句话经验，适合作为**压力训练回放样本**与风格基准。
- 存在重复表达、事实细节不稳定；不适合作为事实问答或最终决策来源。
- 因此设计为 `QwenReplayLLM`：离线真实语料 + 确定性回放，避免运行时依赖模型，也避免把 0.5B 的不稳定输出直接当结论。

## 精选回放语料（24 条）

- 从 144 次评测中为 24 个困境各选 1 条最佳响应（合格优先、质量词多、重复低、长度接近 35）。
- 精选后 **23/24** 达质量门槛（原始 12 条仅 9/12）。
- `QwenReplayLLM::new_curated()` 默认启用质量门槛；唯一不合格样本回退安全句。
- 生成：`python scripts/curate_qwen_corpus.py` → `qwen_curated.mbt`。

## 大规模评测（144 次）

- 24 条困境 × 3 温度（0.3/0.7/1.0）× 2 seed = 144 次真实推理。
- 平均延迟 782ms、平均 36.7 字、22.9 tokens；空响应 0、过短 4、过长 9、重复率高 2、安全词 0。
- 跨 seed/温度平均字符 Jaccard 仅 **0.238**，说明 0.5B 稳定性有限。
- 12 条原始回放语料中仅 **9/12** 达到质量门槛；`QwenReplayLLM::new_strict()` 会对低质量响应回退。
- 完整数据与报告：`docs/QWEN_BENCHMARK.md`、`docs/qwen_benchmark.json`。

## 复现

```bash
python scripts/qwen_generate.py
```

脚本会重新生成 `qwen_corpus.mbt` 与 `docs/qwen_eval.json`。若模型路径变化，使用 `--model` 指定。

## 回放用法

```moonbit
let gv = @ghostvalley.new_engine(max_memory_num=30)
let llm = @ghostvalley.QwenReplayLLM::new()
ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
gv.run_training_pipeline(llm, rounds=6, decay_interval=3, cleanup_threshold=0.1)
println(@ghostvalley.qwen_eval_summary())
```