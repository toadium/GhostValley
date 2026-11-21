# 已知缺口（Known Gaps）

> 诚实披露当前不支持的边界，避免评审与使用者误解。

## 模型

- **无实时模型调用**：MoonBit 侧只有 `MockLLM` 与 `QwenReplayLLM`（离线语料回放）；实时推理需外部 Python/llama.cpp 或 future async provider。
- **0.5B 输出质量有限**：144 次评测中空响应 0、过短 4、过长 9、重复 2；跨 seed 稳定性 Jaccard 0.238；12 条基础语料仅 9/12 达质量门槛，24 条精选 23/24。
- **无 embedding**：检索使用关键词重叠 + 字符级 Jaccard，不是向量检索。

## 工程

- **无 MCP server / CLI 独立包**：目前通过 4 个 `examples/*` 可执行程序使用。
- **无独立 benchmark 包**：性能断言在测试内，未形成持续趋势。
- **无 GitHub Pages/在线演示**：Qwen 语料与 ASCII 仪表盘可静态化，尚未部署。
- **Gitlink 镜像待创建**：申报材料中留待提交前填写。
- **mooncakes 线上版本滞后**：registry 为 0.3.0；1.15.0 需发布后核对。

## 安全

- 内容安全仅覆盖规则/质量门槛/安全词回退，未接入外部 moderation。
- 审计日志为本地 CSV/JSON，未对接 OTel。