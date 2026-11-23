# 已知缺口（Known Gaps）

> 诚实披露当前不支持的边界，避免评审与使用者误解。

## 模型

- **无实时模型调用**：MoonBit 侧只有 `MockLLM` 与 `QwenReplayLLM`（离线语料回放）；实时推理需外部 Python/llama.cpp 或 future async provider。
- **0.5B 输出质量有限**：144 次评测中空响应 0、过短 4、过长 9、重复 2；跨 seed 稳定性 Jaccard 0.238；12 条基础语料仅 9/12 达质量门槛，24 条精选 23/24。
- **无 embedding**：检索使用关键词重叠 + 字符级 Jaccard，不是向量检索。

## 工程

- **无 MCP server**：CLI 已提供 6 命令（`moon run cli`），MCP 尚未实现。
- **benchmark 已提供**：`moon run bench --target native --release`；尚未接入历史趋势。
- **GitHub Pages 待启用**：`docs/` + `playground.js` 已就绪，`check_pages` 21 项；需维护者 Settings 启用。
- **Gitlink 镜像待创建**：申报材料中留待提交前填写。
- **mooncakes 线上版本滞后**：registry 为 0.3.0；0.4.0 需发布后核对。

## 安全

- 内容安全仅覆盖规则/质量门槛/安全词回退，未接入外部 moderation。
- 审计日志为本地 CSV/JSON，未对接 OTel。