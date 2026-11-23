# examples

GhostValley 的 5 个可运行业务示例。每个示例都是一个独立 MoonBit 可执行包，展示不同场景下的完整训练链路。

[← 返回总览](../README.md)

## 示例一览

| 示例 | 场景 | 展示重点 | 命令 |
|---|---|---|---|
| [demo](demo/README.md) | 完整工作流 | 温石验证 → LLM 训练 → 记忆 → 报告 → 持久化 | `moon run examples/demo --target native` |
| [onboarding](onboarding/README.md) | 新员工入职 | 课程驱动 + 情绪追踪 + 自适应难度 | `moon run examples/onboarding --target native` |
| [team_stress](team_stress/README.md) | 技术团队压力 | 多智能体对比 + 交叉学习 + 检查点 | `moon run examples/team_stress --target native` |
| [customer_service](customer_service/README.md) | 客服危机 | 训练管道 + 安全协议 + 审计日志 | `moon run examples/customer_service --target native` |
| [qwen_curated](qwen_curated/README.md) | Qwen 精选回放 | 质量门槛 + 8 轮训练报告 | `moon run examples/qwen_curated --target native` |

## 运行约定

- 全部仅依赖 `walkzzz/ghostvalley`，无外部服务。
- `demo` / `onboarding` / `team_stress` / `customer_service` 使用 `MockLLM`，输出确定。
- `qwen_curated` 使用 `QwenReplayLLM::new_curated()`（离线语料回放），输出确定。

## 相关

- [根 README](../README.md)
- [测试与质量报告](../docs/TEST_REPORT.md)
- [Qwen 评测](../docs/QWEN_EVAL.md)