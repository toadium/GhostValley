# 申报附件：技术细节与组委会关切回复

## 1. 组委会关切逐条回应

### 1.1 “T2 移植项目，原创性不足”

| 层级 | 内容 | 证据 |
|---|---|---|
| 上游 | Python 概念原型（作者本人提供，未公开发布，无第三方许可） | README 移植说明 |
| 移植 | 五大模块、记忆/困境/日志数据结构 | `ghost_valley.mbt`、`dilemma.mbt`、`training_log.mbt` |
| 原创 | 训练协议/审计、多智能体对比、课程/检查点回放、记忆聚类/关联、统计/可视化、Qwen 回放/质量层/评测 | `protocol.mbt`、`multi_agent.mbt`、`curriculum.mbt`、`checkpoint.mbt`、`qwen_*.mbt` |

立项不以“从零”为标准，而以“MoonBit 生态是否获得可运行、可验证、可复用的新能力”为标准。

### 1.2 “功能范围是否足够”

- 核心闭环：温石验证 → 困境 → LLM 响应 → 记忆 → 遗忘/衰减 → 评估 → 回放。
- 扩展：多智能体、课程、检查点、统计、可视化、CSV/JSON/Markdown 导出。
- 质量：503×4 测试、覆盖率 91.6%、变异 13/13、四后端零警告。
- 模型：Qwen2.5-0.5B 的真实评测与回放，而不是桩数据。

### 1.3 “与生态其他项目的差异”

- 生态 LLM/agent 包（mizchi/llm、moonmuse、posoco）聚焦“怎么问模型”；
  GhostValley 聚焦“模型/Agent 如何在模拟压力中训练与记忆”。
- 本项目提供可复现的实验台，而不是又一个通用 LLM 客户端。

## 2. 算法与复杂度

| 模块 | 算法 | 复杂度 |
|---|---|---|
| 温石验证 | 关键词加权态度分 | O(n) |
| 加权检索 | value/similarity/recency 复合分 | O(n log n) |
| 主动遗忘 | 阈值触发 + 非核心 30% 淘汰 | O(n log n) |
| 自适应困境 | 表现 → 难度映射 | O(1) |
| 训练管道 | 轮次循环 + 定期衰减/清理 | O(R·n log n) |
| Qwen 回放 | 精确/包含/相似度匹配 + 质量门槛 | O(k) |
| 质量层 | 长度/3-gram 重复/关键词/安全词 | O(n) |

## 3. 质量证据（2026-11-21）

- 四后端：503 / 503（native、wasm、wasm-gc、js）
- 覆盖率：1356 / 1480 = 91.6%（排除 examples，门槛 90%）
- 变异：13 / 13 KILLED（自动恢复，前后工作区一致）
- 严格：`moon check --target all --warn-list +73 --deny-warn` → 0/0
- 文档：`node scripts/check_docs.mjs` → 24/24
- Qwen：144 次真实推理；12 基础语料 9/12 达标；24 精选语料 23/24 达标

## 4. AI 使用与人工把控

- AI 用于：测试生成、文档草拟、部分实现与重构建议。
- 人工确认：算法选型、安全边界、移植边界、发布决策。
- 所有材料数字由 `scripts/check_docs.mjs`、覆盖率/变异脚本与四后端测试交叉校验。

## 5. 复现命令

```bash
moon check --target all --warn-list +73 --deny-warn
moon test  --target all --warn-list +73 --deny-warn
node scripts/check_coverage.mjs --min 90
node scripts/mutation_test.mjs
node scripts/check_docs.mjs
moon run examples/demo --target native
moon run examples/qwen_curated --target native
python scripts/qwen_generate.py          # 可选：重新生成 12 条基础语料
python scripts/qwen_benchmark.py         # 可选：144 次真实推理评测
python scripts/curate_qwen_corpus.py     # 可选：精选 24 条语料
```