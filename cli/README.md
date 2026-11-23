# cli

GhostValley 的原生命令行入口，基于 `@env.args()` 读取真实 argv。

[← 返回总览](../README.md)

## 运行

```bash
moon run cli --target native -- help
```

## 命令

| 命令 | 说明 |
|---|---|
| `help` | 显示帮助 |
| `version` | 版本号 |
| `quality` | 基础/精选语料质量摘要 |
| `eval` | 144 次评测摘要 |
| `run` | 8 轮训练（Qwen 精选回放） |
| `run20` | 20 轮训练（压力测试） |

## 退出码

| 码 | 含义 |
|---|---|
| 0 | 成功 |
| 1 | 未知命令（打印帮助） |
| 2 | 温石验证未通过 |

## 行为说明

- 仅 native（`supported_targets = "native"`）；不依赖外部模型或网络。
- `run` / `run20` 使用 `QwenReplayLLM::new_curated()`，输出确定。
- 真实 argv：CI 用 `moon run cli --target native -- help` 做 smoke。

## 示例

```bash
moon run cli --target native -- quality
moon run cli --target native -- run
```

## 相关

- [根 README](../README.md)
- [MCP server](../integrations/mcp/README.md)
- [测试与质量报告](../docs/TEST_REPORT.md)