---
layout: default
title: GhostValley
description: AI 心理压力演练系统 — 在可控挫折中训练韧性
---

# GhostValley

**AI 心理压力演练系统**：困境 → Qwen 回放感悟 → 记忆 / 遗忘 → 评估 → 回放。

MoonBit 实现，四后端一致；**521 × 4** 测试、**97.5%** 覆盖率、**14 / 14** 变异 KILLED。

[交互 Demo](demo.html) · [GitHub](https://github.com/toadium/GhostValley) · [mooncakes](https://mooncakes.io/docs/walkzzz/ghostvalley) · [申报书](https://github.com/toadium/GhostValley/blob/main/申报书.md) · [测试报告](https://github.com/toadium/GhostValley/blob/main/docs/TEST_REPORT.md)

## 快速开始

```bash
moon add walkzzz/ghostvalley
moon run examples/qwen_curated --target native
moon run cli --target native -- help
```

> `0.4.0` 为季度赛提交版本；registry 0.3.0，发布后以最新版为准。

## 为什么值得用

- **不是通用 LLM 客户端**：它训练“AI 在模拟挫折中如何恢复”，而不是再包一层聊天 UI。
- **可复现**：Qwen2.5-0.5B 只离线生成语料；运行时确定性回放，四后端行为一致。
- **可审计**：训练协议、审计日志、模拟/真实记忆隔离、遗忘与衰减策略。
- **有质量门槛**：12 条基础 9/12、24 条精选 23/24 达门槛；严格模式自动回退。

## 能力

| 模块 | 说明 |
|---|---|
| 温石验证 | 知情同意与意愿分 |
| 防创伤安全气垫 | `is_simulation` 强制标记 |
| 主动式遗忘 | 阈值触发、非核心 30% 淘汰、核心保护 |
| 第八根空桩 | 结构化困境 4 类 × 3 难度 |
| 训练管道 | 多轮 + 衰减 + 清理 + 统计 |
| 评估 / 课程 / 检查点 | 韧性评分、课程进度、断点续训 |
| 多智能体 / 聚类 | 对比训练、自动关联 |
| Qwen 回放 / 质量层 | 12 基础 + 24 精选；严格回退 |
| MCP / CLI / bench | `moonmcp` 4 tools；6 命令；9 组基准 |

## API 速览

| API | 说明 |
|---|---|
| `new_engine(max_memory_num=12)` | 创建引擎 |
| `wen_shi_verify(text)` | 温石验证 |
| `add_memory(content, is_simulation=...)` | 写入记忆（自动遗忘） |
| `run_training_pipeline(llm, rounds=...)` | 训练管道 |
| `training_report()` | 训练报告 |
| `qwen_curated_quality_summary()` | 精选语料质量 |
| `QwenReplayLLM::new_curated()` | Qwen 回放适配器 |

## 模块文档

| 模块 | 用途 | 文档 |
|---|---|---|
| `playground` | 浏览器演示导出层 | [README](https://github.com/toadium/GhostValley/blob/main/playground/README.md) |
| `cli` | 命令行入口（6 命令） | [README](https://github.com/toadium/GhostValley/blob/main/cli/README.md) |
| `bench` | 性能基准（9 组） | [README](https://github.com/toadium/GhostValley/blob/main/bench/README.md) |
| `integrations/mcp` | MCP server（4 tools） | [README](https://github.com/toadium/GhostValley/blob/main/integrations/mcp/README.md) |
| `examples` | 5 个示例总览 | [README](https://github.com/toadium/GhostValley/blob/main/examples/README.md) |
| `examples/demo` | 完整工作流 | [README](https://github.com/toadium/GhostValley/blob/main/examples/demo/README.md) |
| `examples/onboarding` | 新员工入职 | [README](https://github.com/toadium/GhostValley/blob/main/examples/onboarding/README.md) |
| `examples/team_stress` | 技术团队压力 | [README](https://github.com/toadium/GhostValley/blob/main/examples/team_stress/README.md) |
| `examples/customer_service` | 客服危机 | [README](https://github.com/toadium/GhostValley/blob/main/examples/customer_service/README.md) |
| `examples/qwen_curated` | Qwen 精选回放 | [README](https://github.com/toadium/GhostValley/blob/main/examples/qwen_curated/README.md) |

## 质量证据

- 测试：521 × 4 后端（native / wasm / wasm-gc / js）
- 覆盖率：97.5%（1389 / 1424）
- 变异：14 / 14 KILLED
- 严格检查：`--warn-list +73 --deny-warn` 0/0
- Qwen：144 次真实推理；基础 9/12、精选 23/24 达质量门槛
- 文档：53+ 项一致性检查；Pages 自检 28+ 项

## 文档

- [README](https://github.com/toadium/GhostValley#readme)
- [架构](https://github.com/toadium/GhostValley/blob/main/ARCHITECTURE.md)
- [Qwen 评测](https://github.com/toadium/GhostValley/blob/main/docs/QWEN_EVAL.md)
- [技术攻关](https://github.com/toadium/GhostValley/blob/main/docs/TECH_CHALLENGES.md)
- [评分自证](https://github.com/toadium/GhostValley/blob/main/docs/FINAL_SCORECARD.md)
- [已知缺口](https://github.com/toadium/GhostValley/blob/main/docs/known-gaps.md)

## 生态集成

- MCP server：`integrations/mcp`，复用 `moonbitstack/moonmcp`，native-only，4 个工具。
- 实时 Qwen：`python scripts/qwen_live.py "困境"`（本机 llama-cpp-python）。
- CLI：`moon run cli --target native -- help`。
- 基准：`moon run bench --target native --release`。

<footer>
  <p>GhostValley · Apache-2.0 · MoonBit</p>
</footer>