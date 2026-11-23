# 决赛评分自证表（四项各 25 分）

> 对齐季度赛评分准则：工程深度与实现强度 / 技术贡献与攻关 / 生态增量 / 开发与验证能力。
> 每条证据均可本地复现。

## 一、工程深度与实现强度

| 证据 | 数字/命令 |
|---|---|
| 四后端测试 | `moon test --target all` → 503 × 4，0 失败 |
| 覆盖率 | 1356 / 1480 = **91.6%**（`node scripts/check_coverage.mjs --min 90`） |
| 变异 | **13 / 13 KILLED**（`node scripts/mutation_test.mjs`） |
| 严格检查 | `moon check --target all --warn-list +73 --deny-warn` → 0/0 |
| 规模 | 25 源码文件 + 27 测试文件；训练/记忆/评估/多智能体/协议/审计/可视化全链路 |
| 零外部服务 | 仅 `@rand/@debug/@json`；Qwen 语料编译进包，四后端确定性回放 |

## 二、技术贡献与攻关

| 攻关点 | 做法 | 证据 |
|---|---|---|
| 确定性回放 | Qwen 真实响应 → `qwen_corpus.mbt` / `qwen_curated.mbt`，无运行时模型 | `QwenReplayLLM`，四后端 503 测试 |
| 质量门槛 | 长度/3-gram 重复/关键词/安全词 + 严格回退 | `qwen_quality.mbt`、9 个质量测试 |
| 训练安全 | 模拟标记、压力/信心边界、冷却期、审计 | `protocol.mbt`、`AuditLog` |
| 记忆系统 | 主动遗忘（30%）、双曲衰减、容量阈值、核心保护 | `ghost_valley.mbt`、`decay.mbt`、属性测试 |
| 真实评测 | 144 次推理（24 困境 × 3 温度 × 2 seed） | `docs/QWEN_BENCHMARK.md` |

## 三、生态增量

| 维度 | 证据 |
|---|---|
| 可运行示例 | 5 个：demo / onboarding / team_stress / customer_service / qwen_curated |
| 在线演示 | GitHub Pages（`docs/index.html` + `docs/playground.js`，`node scripts/check_pages.mjs` 21 项） |
| 可复用能力 | 记忆/遗忘/训练协议/Qwen 回放可被其他 agent 项目复用 |
| 诚实边界 | `docs/known-gaps.md`、`docs/MODEL_CARD.md`、`docs/DATA_CARD.md` |
| 发布 | `walkzzz/ghostvalley` 0.4.0（registry 0.3.0 → 0.4.0 待发布） |

## 四、开发与验证能力

| 证据 | 结果 |
|---|---|
| CI | quality（fmt/check/build/docs/示例 smoke） + test×4 + coverage + pages |
| 覆盖率门槛 | 90%（当前 91.6%） |
| 变异门禁 | 13/13，自动恢复，运行前后工作区一致 |
| 文档门禁 | `node scripts/check_docs.mjs` → 36 项 |
| AI 校验闭环 | `docs/AI_EVIDENCE.md`：3 个“AI 生成/测试发现错误 → 修复”实例 |
| 可复现 | `docs/DEMO_SCRIPT.md` 8 分钟离线演示 |

## 对应评分档位

- 工程深度：优秀档（四后端 + 硬门槛 + 全链路）
- 技术贡献：优秀档（确定性回放 + 质量层 + 安全协议）
- 生态增量：良好→优秀（Pages/示例/可复用层；仍缺下游采用）
- 开发验证：优秀档（覆盖率/变异/文档/AI 证据闭环）