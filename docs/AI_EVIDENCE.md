# AI 校验闭环：AI 生成/测试如何发现并防止错误

> 回应评分第④项“Harness、回归、基准、自动化及 AI 校验，并能展示实际发现和防止错误的效果”。

## 实例 1：144 次评测暴露“12 条语料只有 3 条可用”

- AI 生成 144 条响应后，质量统计发现：空 0、过短 4、过长 9、重复 2、跨 seed 相似度 0.238。
- 基础 12 条语料仅 **3/12** 达质量门槛（扩展词表后 9/12）。
- 行动：新增 `qwen_quality.mbt`、严格回退、从 144 条中精选 **23/24**。
- 防错：9 个质量测试 + 变异 M11/M12；`new_curated()` 默认门槛。

## 实例 2：M03 等价变异暴露“测试杀不死”

- 变异 `prompt == x || contains(x)` → `&&` 是等价变异（`==` 蕴含 `contains`），永远 SURVIVED。
- 行动：改为“移除 contains”，并补前缀 prompt 测试（`match_threshold=1.0` 禁用相似度回退）。
- 结果：M03 KILLED，13/13；避免门禁虚假通过。

## 实例 3：精选语料仍回落到原始语料

- `QwenReplayLLM::response_for` 曾调用全局 `qwen_response_for`（固定 12 条），忽略 `self.responses`。
- 运行 curated 测试发现 strict 回退约 14/24；修复为遍历 `self.responses`。
- 结果：curated 回退 1/24（仅 general/2 质量不合格），测试锁定。

## 实例 4：`var` 保留字让整包无法编译

- `dilemma_library.mbt` 使用 `let (var, val)`，MoonBit 解析失败（3002），native/wasm 0 测试。
- 行动：改 `name`；首次跑出真实 480 测试基线。
- 防错：四后端 CI + `--deny-warn`。

## 可复核

- 提交：`c236b91`（质量层/评测）、`43ffd29`（curated）、`133acdf`（立项材料）；
- 文件：`qwen_quality.mbt`、`qwen_adapter.mbt`、`qwen_quality_test.mbt`、`qwen_curated_test.mbt`、`scripts/mutation_test.mjs`；
- 命令：`moon test --target all`、`node scripts/mutation_test.mjs`、`python scripts/qwen_benchmark.py`。