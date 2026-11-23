# MCP server（integrations/mcp）

基于 **`moonbitstack/moonmcp`** 的 MCP stdio server，把 GhostValley 的训练/质量能力暴露为工具。

[← 返回总览](../../README.md)

## 运行

```bash
moon run integrations/mcp --target native
python scripts/check_mcp.py     # initialize / tools/list / tools/call 自检
```

## 工具

| 工具 | 参数 | 返回 |
|---|---|---|
| `version` | — | `0.4.0` |
| `quality` | — | 精选语料质量摘要 |
| `eval` | — | 144 次评测摘要 |
| `run_round` | `rounds`（默认 8） | 训练报告文本 |

## 依赖与边界

- 依赖 `moonbitstack/moonmcp 0.2.2` + `moonbitlang/async 0.22.5`，仅 native。
- 主库 `walkzzz/ghostvalley` 仍零外部依赖、四后端可用；集成层不进入主库。
- `run_round` 使用 Qwen 精选回放，无模型/网络依赖。

## 实时模型说明

`live_chat` 未内置：本机 Windows 上 `moonbitlang/async` 的 `@process` 启动子进程会卡死（桩脚本可复现）。实时 Qwen 请直接运行：

```bash
python scripts/qwen_live.py "你的工具突然不可用"
```

详见 [known-gaps](../../docs/known-gaps.md)。

## 相关

- [根 README](../../README.md)
- [Qwen 评测](../../docs/QWEN_EVAL.md)
- [MCP 自检脚本](../../scripts/check_mcp.py)