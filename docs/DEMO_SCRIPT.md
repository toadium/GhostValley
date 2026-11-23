# 决赛 8 分钟演示脚本（全程离线）

> 目标：让评委在 8 分钟内看到“可运行、可验证、可复现”，而不是听架构。

## 0:00–0:40 定位

> GhostValley 不是通用 LLM 客户端，而是 AI 的“模拟压力训练场”：
> 困境 → 感悟 → 记忆/遗忘 → 评估 → 回放。重点是可控、可审计、可复现。

打开 `README.mbt.md` 顶部：五模块、503×4、91.6%、13/13、Qwen 精选 23/24。

## 0:40–1:20 温石验证与安全气垫

```bash
moon run examples/demo --target native
```

指出输出中的：
- 温石验证意愿分 / 通过；
- 模拟挫折标记 `is_simulation`；
- 训练报告与记忆数量。

## 1:20–2:40 真实模型回放（核心差异化）

```bash
moon run examples/qwen_curated --target native
```

预期：
```
Qwen curated quality: accepted=23/24 ...
基础语料：Qwen corpus quality: accepted=9/12 ...
温石验证：true
训练轮次: 8 ...
```

说明：
- Qwen2.5-0.5B 只离线生成语料；运行时确定性回放，四后端一致；
- 24 条精选来自 144 次真实评测；严格模式对低质量/安全词回退。

## 2:40–3:40 质量层与安全

展示 `qwen_quality.mbt` 与测试：
```bash
moon test --target native -f "qwen quality safety"
moon test --target native -f "qwen strict gate falls back on low quality corpus"
```

说明：0.5B 输出不可靠，所以系统不把模型输出当结论，而是做质量门槛与回退。

## 3:40–5:00 训练与记忆

在 `examples/demo` 输出中展示：
- 主动遗忘：阈值触发、30% 非核心淘汰、核心保护；
- 双曲衰减与清理；
- 训练报告/统计；
- 审计日志（如演示 `AuditLog`）。

## 5:00–6:20 验证门禁

```bash
moon test --target all --warn-list +73 --deny-warn
node scripts/check_coverage.mjs --min 90
node scripts/mutation_test.mjs
node scripts/check_docs.mjs
```

报数：503×4、91.6%、13/13、36 项。强调变异脚本会自动还原源码。

## 6:20–7:20 在线演示

打开 `https://toadium.github.io/GhostValley/`（需仓库启用 Pages）：
- 质量摘要（精选/基础/评测）；
- 输入轮次 → 浏览器内跑训练 → 报告；
- 全部由 MoonBit 编译到 JS，无后端。

## 7:20–8:00 生态与发布

- 5 个可运行示例；Qwen 语料/评测脚本可复现；
- `docs/known-gaps.md` 主动披露边界；
- 发布 `walkzzz/ghostvalley@0.4.0`（registry 0.3.0）；
- 下一步：CLI/MCP/benchmark（known-gaps 已列）。

## 备用（评委追问时）

- 为什么 0.5B：成本/离线/确定性；质量不足用门槛与回退，而不是假装可靠。
- 为什么移植也能立项：上游只是概念原型；MoonBit 版新增测试/门禁/回放/质量层/协议/审计。
- 与 agent 框架差异：它们解决“怎么问模型”，本项目解决“怎么训练与记忆”。