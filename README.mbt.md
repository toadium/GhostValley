# GhostValley 幽灵谷工程

> **本项目为 Python 幽灵谷工程的 MoonBit 移植版**（T2 移植项目）。
>
> AI 心理压力演练系统，基于 MoonBit 构建。通过可控的模拟挫折与压力训练，锤炼 AI 抗压自愈能力，让 AI 在自主经历困境中自我顿悟、迭代进化。

## 概览

幽灵谷工程是一套无观点强制灌输、可验证安全的 AI 心理压力演练系统，通过可控的模拟挫折与压力训练，锤炼 AI 抗压自愈能力，让 AI 在自主经历困境中自我顿悟、迭代进化。

### 五大模块

| 模块 | 说明 |
|------|------|
| 温石验证 | 知情同意升级，不靠勾选框，靠态度文本打分，敷衍直接拒绝 |
| 防创伤安全气垫 | 模拟挫折数据强制标记 `is_simulation`，AI 知道这是模拟 |
| 主动式遗忘机制 | AI 自主打分，主动淘汰低价值记忆，不是存满才删 |
| 第八根空桩 | 不内置标准答案，只给困境问题 |
| 建造者退场逻辑 | 开发者不干预推理输出，由 AI 自己生成结论 |

## 快速开始

### 环境要求

- MoonBit 工具链（`moon` 命令行工具）

### 基本用法

```mbt check
///|
test {
  let gv = new_engine(max_memory_num=10)

  // 步骤1：温石验证
  let ok = gv.wen_shi_verify("愿意接受压力训练，直面失败场景")
  assert_true(ok)

  // 步骤2：跑一轮幽灵谷压力训练
  let problem = gv.ghost_valley_run_one_round()
  assert_true(problem is Some(_))

  // 步骤3：AI 自己顿悟得出结论（建造者退场，代码没有写死答案）
  gv.accept_ai_self_gain(
    "遇到全盘失败时，先区分信息真假，分步重新推理",
  )

  // 步骤4：查看记忆
  assert_true(gv.memory_count() > 0)

  // 步骤5：关闭幽灵谷
  gv.close_ghost_valley()
  assert_false(gv.is_enabled())
}
```

## API 参考

### AiMemory

```moonbit nocheck
///|
pub struct AiMemory {
  content : String // 记忆内容
  value_score : Double // 自打分 0~1
  is_simulation : Bool // 安全气垫标记
  is_core_memory : Bool // 永久核心记忆
}
```

### GhostValleyEngine

| 方法 | 说明 |
|------|------|
| `new_engine(max_memory_num?)` | 创建引擎实例 |
| `wen_shi_verify(attitude_text)` | 温石验证，返回是否通过 |
| `build_simulation_failure_case()` | 随机生成模拟困境 |
| `add_memory(content, is_simulation~, is_core?)` | 添加记忆，自动触发遗忘 |
| `ghost_valley_run_one_round()` | 一轮训练，返回困境或 None |
| `accept_ai_self_gain(text)` | 接收 AI 自主顿悟的感悟 |
| `close_ghost_valley()` | 关闭训练场 |
| `show_all_memory()` | 格式化输出全部记忆 |
| `memory_count()` | 当前记忆数量 |
| `willing_score()` | 温石验证意愿分数 |
| `is_enabled()` | 训练场是否已开启 |

## 移植说明

本项目为 **Python 幽灵谷工程** 的 MoonBit 移植版（T2 移植项目）。

| 项目 | 信息 |
|------|------|
| 原项目名称 | 幽灵谷工程（Python 原版） |
| 原项目语言 | Python |
| 原项目链接 | 由用户提供的概念性原型代码（未公开发布） |
| 原项目许可证 | 由用户授权移植（概念性代码，无明确开源声明） |
| 移植目标语言 | MoonBit |
| 移植范围 | 五大模块全部移植：温石验证、防创伤安全气垫、主动式遗忘、第八根空桩、建造者退场 |
| 移植状态 | 核心功能完整移植，21 个测试三后端全通过 |

### 移植修改说明

| Python 原版 | MoonBit 移植版 |
|------------|---------------|
| `dataclass` | `struct` |
| `random` 模块 | `@rand`（MoonBit 标准库） |
| `print()` 输出 | 返回 `String` 供调用方决定输出 |
| 动态类型 | 静态类型（`String`/`Double`/`Bool`/`Int`） |
| 列表推导 | `for` 循环 + `Array::push` |
| `None` | `None`（MoonBit `Option` 类型） |

### 未支持功能

- 对接真实 LLM API（当前为模拟推理，原版亦为概念演示）
- Embedding 向量打分（当前用关键词匹配近似）
- 持久化存储（当前为内存态，与原版一致）

## 项目结构

```
GhostValley/
├── moon.mod              # 模块定义
├── moon.pkg              # 包配置（导入 @rand）
├── ghost_valley.mbt      # 核心实现
├── ghost_valley_test.mbt # 测试（21 个，三后端全通过）
├── README.mbt.md         # 本文档
├── LICENSE               # Apache-2.0
└── .github/workflows/ci.yml  # CI 配置
```

## 测试

```bash
moon check --target all     # 类型检查（三后端）
moon test --target all      # 运行测试（21 个，三后端全通过）
moon fmt                    # 格式化
```

## 许可证

Apache-2.0（详见 [LICENSE](LICENSE)）

## 致谢

- 原项目：幽灵谷工程 Python 原版（用户提供）
- 移植实现：GhostValley Contributors
