<div align="center">

# GhostValley 幽灵谷工程

**AI 心理压力演练系统 · MoonBit 实现**

在可控、可审计的模拟挫折中训练韧性：困境 → Qwen 回放感悟 → 记忆/遗忘 → 评估 → 回放

[![MoonBit](https://img.shields.io/badge/MoonBit-pure%20implementation-blue)](https://www.moonbitlang.com/)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache--2.0-green)](LICENSE)
[![Tests](https://img.shields.io/badge/Tests-521%20passed-brightgreen)]()
[![Coverage](https://img.shields.io/badge/coverage-97.5%25-brightgreen)](docs/TEST_REPORT.md)
[![Mutation](https://img.shields.io/badge/mutation-14%2F14%20KILLED-brightgreen)](scripts/mutation_test.mjs)
[![MCP](https://img.shields.io/badge/MCP-moonmcp%204%20tools-purple)](integrations/mcp/README.md)
[![Pages](https://img.shields.io/badge/GitHub%20Pages-live-3b82f6)](https://toadium.github.io/GhostValley/)
[![mooncakes](https://img.shields.io/badge/mooncakes-walkzzz%2Fghostvalley-purple)](https://mooncakes.io/docs/walkzzz/ghostvalley)

</div>

---

## 概述

GhostValley 是一套**无观点强制灌输、可验证安全**的 AI 心理压力演练系统。它不提供标准答案，而是给出困境，让 AI 在模拟挫折中自己生成感悟、形成记忆、经历遗忘与衰减，再由评估/课程/检查点把训练过程变成可复现的实验。

**本项目为 Python 幽灵谷概念原型的 MoonBit 移植版（T2）**；MoonBit 版新增四后端一致实现、521×4 测试、97.5% 覆盖率、14/14 变异门禁、Qwen 回放与质量层、CLI/bench/MCP/Pages。

### 在线演示

- 介绍页：<https://toadium.github.io/GhostValley/>
- 交互 Demo：<https://toadium.github.io/GhostValley/demo.html>

### 五大模块

| 模块 | 说明 |
|---|---|
| 温石验证 | 知情同意升级：态度文本打分，敷衍直接拒绝 |
| 防创伤安全气垫 | 模拟挫折强制 `is_simulation`，AI 知道这是模拟 |
| 主动式遗忘 | AI 自主打分，主动淘汰低价值记忆，不是存满才删 |
| 第八根空桩 | 不内置标准答案，只给困境问题 |
| 建造者退场 | 开发者不干预推理输出，由 AI 自己生成结论 |

## 包结构

```
GhostValley/
├── moon.pkg / moon.mod        # 根包：引擎 + 记忆 + 训练 + 协议 + Qwen 回放
├── playground/                # 浏览器演示导出层（js，#export_name）
├── cli/                       # native CLI（6 命令）
├── bench/                     # native benchmark（9 组）
├── integrations/mcp/          # MCP stdio server（moonmcp，native-only）
├── examples/                  # 5 个可运行业务示例
├── docs/                      # 测试/评测/决赛/Pages 文档
└── scripts/                   # 覆盖率/变异/文档/Pages/MCP 门禁
```

| 模块 | 说明 | 文档 |
|---|---|---|
| 根包 `@ghostvalley` | 引擎、记忆、困境、训练、协议、评估、Qwen | [README.mbt.md](README.mbt.md) |
| `playground` | 浏览器演示导出层 | [README](playground/README.md) |
| `cli` | 命令行入口（6 命令） | [README](cli/README.md) |
| `bench` | 性能基准（9 组） | [README](bench/README.md) |
| `integrations/mcp` | MCP server（4 tools） | [README](integrations/mcp/README.md) |
| `examples` | 5 个可运行业务示例 | [README](examples/README.md) |

## 快速开始

```bash
moon add walkzzz/ghostvalley
```

```moonbit
let gv = @ghostvalley.new_engine(max_memory_num=12)
let ok = gv.wen_shi_verify("愿意接受挑战，接受压力训练，想要自我迭代")
if ok {
  gv.run_training_pipeline(
    @ghostvalley.MockLLM::new(),
    rounds=8,
    decay_interval=4,
    cleanup_threshold=0.1,
  )
  println(gv.training_report().format())
}
```

## 示例

```bash
moon run examples/demo              --target native   # 9 步完整工作流
moon run examples/onboarding        --target native   # 新员工入职心理建设
moon run examples/team_stress       --target native   # 技术团队压力演练
moon run examples/customer_service  --target native   # 客服危机处理
moon run examples/qwen_curated      --target native   # Qwen 精选回放 + 8 轮训练
```

## Qwen2.5-0.5B 本地模型

- `QwenReplayLLM`：12 条基础语料 + 24 条精选语料（`new_curated`），编译进包，四后端确定性回放。
- 144 次真实推理评测（24 困境 × 3 温度 × 2 seed）；精选 23/24 达质量门槛。
- 质量层：长度/3-gram 重复/质量词/安全词 + 严格回退。
- 评测与复现：[docs/QWEN_EVAL.md](docs/QWEN_EVAL.md)、[docs/QWEN_BENCHMARK.md](docs/QWEN_BENCHMARK.md)。

## 工程质量

| 项 | 结果 |
|---|---|
| 四后端测试 | **521 × 4**（native / wasm / wasm-gc / js） |
| 覆盖率 | **97.5%**（1389/1424，核心库） |
| 变异测试 | **14 / 14 KILLED** |
| 严格检查 | `--warn-list +73 --deny-warn` → 0/0 |
| 文档门禁 | `check_docs` 53+ 项 |
| 展示页门禁 | `check_pages` 28+ 项 |

```bash
moon check --target all --warn-list +73 --deny-warn
moon test  --target all --warn-list +73 --deny-warn
node scripts/check_coverage.mjs --min 97
node scripts/mutation_test.mjs
node scripts/check_docs.mjs
```

## 生态集成

| 能力 | 命令 |
|---|---|
| CLI | `moon run cli --target native -- help` |
| Benchmark | `moon run bench --target native --release` |
| MCP server | `moon run integrations/mcp --target native` |
| 实时 Qwen | `python scripts/qwen_live.py "你的工具突然不可用"` |

MCP 复用 `moonbitstack/moonmcp`，提供 `version / quality / eval / run_round` 4 个工具；主库保持零外部依赖、四后端可用。

## 文档

- [完整使用说明 / API](README.mbt.md)
- [架构](ARCHITECTURE.md) · [设计决策](DESIGN_RATIONALE.md)
- [测试与质量报告](docs/TEST_REPORT.md)
- [Qwen 评测](docs/QWEN_EVAL.md) · [大规模评测](docs/QWEN_BENCHMARK.md)
- [评分自证](docs/FINAL_SCORECARD.md) · [演示脚本](docs/DEMO_SCRIPT.md)
- [已知缺口](docs/known-gaps.md) · [模型卡](docs/MODEL_CARD.md) · [数据卡](docs/DATA_CARD.md)
- [申报书](申报书.md) · [自查报告](自查报告.md)

## 项目信息

| 项 | 值 |
|---|---|
| 原项目 | Python 幽灵谷概念原型（作者提供，未公开发布） |
| 移植范围 | 五大模块与核心数据结构 |
| 本项目许可证 | Apache-2.0（详见 [LICENSE](LICENSE)） |
| mooncakes | `walkzzz/ghostvalley`（registry 0.3.0；0.4.0 待发布） |
| 版本阶段 | 0.x，API 未冻结 |

## 许可证

Apache-2.0。上游概念原型由作者本人提供；Qwen 模型权重不随仓库分发，见 [模型卡](docs/MODEL_CARD.md)。