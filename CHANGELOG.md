# Changelog

## [0.2.0] - 2026-08-18

### Added
- **Embedding 语义打分**：`text_value_score` 基于关键词匹配替代纯随机打分
- **文本相似度**：`text_similarity` 基于关键词重叠率计算相似度
- **LLM 接口抽象**：`trait LLMAdapter` + `MockLLM` 实现
- **LLM 自动训练**：`run_round_with_llm` 一轮训练 + LLM 自动响应
- **多轮训练 API**：`ghost_valley_run_rounds(n)` 批量训练
- **记忆持久化**：`save_memory`/`load_memory` JSON 序列化
- **训练报告**：`TrainingReport` 结构化报告 + JSON 导出
- **训练轮次追踪**：`total_rounds` 字段

### Changed
- `add_memory` 用语义打分 + 随机扰动替代纯随机
- `active_forget` 优化 O(n²) → O(n log n)
- `AiMemory` 添加 `ToJson` derive
- 警告治理 25→0（默认级别）

### Technical
- 代码行数：313 → ~600 行
- 测试数量：21 → 55（三后端全通过）
- 新增依赖：`moonbitlang/core/json`
- 新增文件：embedding/llm_adapter/persistence/report + 测试

## [0.1.0] - 2026-08-18

### Added
- 幽灵谷工程 MoonBit 移植初始版本
- 五大模块完整实现：
  - 温石验证（态度文本打分）
  - 防创伤安全气垫（`is_simulation` 标记）
  - 主动式遗忘机制（自打分淘汰低价值记忆）
  - 第八根空桩（不内置标准答案）
  - 建造者退场逻辑（AI 自主生成结论）
- `GhostValleyEngine` 引擎 API（12 个公开方法）
- `AiMemory` 记忆单元结构体
- 21 个测试（三后端全通过：native/wasm-gc/wasm）
- README.mbt.md（API 参考 + 移植说明）
- CI 配置（GitHub Actions）
- 独立示例（`examples/demo/`）

### Technical
- 原项目：Python 幽灵谷工程（用户提供概念性原型）
- 依赖：仅 `moonbitlang/core/random`
- 许可证：Apache-2.0
- 已发布至 mooncakes.io：`walkzzz/ghostvalley`