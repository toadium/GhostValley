# Changelog

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