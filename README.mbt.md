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
  let gv = @ghostvalley.new_engine(max_memory_num=10)

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
  mut value_score : Double // 自打分 0~1（支持衰减修改）
  is_simulation : Bool // 安全气垫标记
  is_core_memory : Bool // 永久核心记忆
}
```

### GhostValleyEngine — 核心引擎

| 方法 | 说明 |
|------|------|
| `new_engine(max_memory_num?)` | 创建引擎实例 |
| `wen_shi_verify(attitude_text)` | 温石验证，返回是否通过 |
| `build_simulation_failure_case()` | 随机生成模拟困境 |
| `add_memory(content, is_simulation~, is_core?)` | 添加记忆，自动触发遗忘 |
| `ghost_valley_run_one_round()` | 一轮训练，返回困境或 None |
| `ghost_valley_run_rounds(n)` | 多轮训练，返回困境数组 |
| `accept_ai_self_gain(text)` | 接收 AI 自主顿悟的感悟 |
| `close_ghost_valley()` | 关闭训练场 |
| `show_all_memory()` | 格式化输出全部记忆 |
| `memory_count()` | 当前记忆数量 |
| `willing_score()` | 温石验证意愿分数 |
| `is_enabled()` | 训练场是否已开启 |

### GhostValleyEngine — 记忆检索

| 方法 | 说明 |
|------|------|
| `search_memories(keyword)` | 按关键词检索记忆 |
| `top_memories(n)` | 获取价值分最高的 N 条记忆 |
| `filter_memories(is_simulation?, is_core?)` | 按标记过滤记忆 |
| `average_value_score()` | 计算平均价值分 |
| `real_memories()` | 获取所有真实记忆 |
| `simulation_memories()` | 获取所有模拟记忆 |
| `core_memories()` | 获取所有核心记忆 |

### GhostValleyEngine — 记忆衰减

| 方法 | 说明 |
|------|------|
| `apply_decay(rounds_elapsed)` | 对非核心记忆应用时间衰减 |
| `cleanup_low_value(threshold)` | 清理低于阈值的非核心记忆，返回清理数 |
| `min_value_score()` | 获取最低价值分 |
| `max_value_score()` | 获取最高价值分 |

### GhostValleyEngine — 训练日志

| 方法 | 说明 |
|------|------|
| `get_training_log()` | 获取内置训练日志 |
| `log_round(dilemma, response)` | 手动记录训练日志 |
| `export_training_log_json()` | 导出日志为 JSON |
| `export_training_log_string()` | 导出日志为 JSON 字符串 |
| `export_training_log_format()` | 导出日志为格式化字符串 |

### GhostValleyEngine — 困境池配置

| 方法 | 说明 |
|------|------|
| `add_dilemma(dilemma)` | 添加自定义困境 |
| `set_dilemma_pool(pool)` | 替换整个困境池 |
| `dilemma_pool_size()` | 获取困境池大小 |

### GhostValleyEngine — 持久化与报告

| 方法 | 说明 |
|------|------|
| `save_memory()` / `save_memory_string()` | 序列化记忆库为 JSON |
| `load_memory(json)` / `load_memory_string(str)` | 从 JSON 加载记忆 |
| `training_report()` | 生成结构化训练报告 |
| `training_report_json()` | 训练报告转 JSON 字符串 |

### LLM 适配

```moonbit nocheck
///|
pub trait LLMAdapter {
  fn generate_response(Self, String) -> String
}
```

| 方法 | 说明 |
|------|------|
| `MockLLM::new()` | 创建模拟 LLM 适配器 |
| `run_round_with_llm(llm)` | 一轮训练 + LLM 自动响应 + 自动日志 |

### TrainingLog / TrainingLogEntry

```moonbit nocheck
///|
pub struct TrainingLogEntry {
  round_num : Int
  dilemma : String
  ai_response : String
  memory_count_after : Int
}

///|
pub struct TrainingLog {
  entries : Array[TrainingLogEntry]
}
```

| 方法 | 说明 |
|------|------|
| `TrainingLog::new()` | 创建空日志 |
| `TrainingLog::add_entry(...)` | 添加日志条目 |
| `TrainingLog::length()` | 日志条目数量 |
| `TrainingLog::to_json()` | 转 JSON 数组 |
| `TrainingLog::format()` | 格式化输出 |

## 移植说明

本项目为 **Python 幽灵谷工程** 的 MoonBit 移植版（T2 移植项目）。

| 项目 | 信息 |
|------|------|
| 原项目名称 | 幽灵谷工程（Python 原版） |
| 原项目语言 | Python |
| 原项目链接 | 由用户提供的概念性原型代码（未公开发布） |
| 原项目许可证 | 由用户授权移植（概念性代码，无明确开源声明） |
| 移植目标语言 | MoonBit |
| 移植范围 | 五大模块全部移植 + 记忆检索/衰减/日志/配置化扩展 |
| 移植状态 | 核心功能完整移植，389 个测试三后端全通过 |

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
├── moon.pkg              # 包配置（导入 @rand @debug @json）
├── ghost_valley.mbt      # 核心引擎 + 困境池配置
├── embedding.mbt         # 语义打分 + 文本相似度
├── llm_adapter.mbt       # LLM 接口 + MockLLM
├── persistence.mbt       # 记忆持久化
├── report.mbt            # 训练报告
├── retrieval.mbt         # 记忆检索 API
├── decay.mbt             # 记忆衰减机制
├── training_log.mbt      # 训练日志系统
├── *_test.mbt            # 测试文件（21 个，三后端全通过）
├── ARCHITECTURE.md       # 架构文档（五大模块/数据流/扩展点）
├── DESIGN_RATIONALE.md   # 设计决策记录（8 条关键决策）
├── README.mbt.md         # 本文档
├── CHANGELOG.md          # 变更日志
├── LICENSE               # Apache-2.0
└── .github/workflows/ci.yml  # CI 配置（四后端）
```

## v1.1.0 - v1.4.0 新增功能

### v1.1.0 训练评估 + 质量度量
- `resilience_score()`：韧性分（高难度/低难度响应分比值）
- `category_coverage()`：4 分类训练覆盖情况
- `improvement_rate()`：线性回归斜率量化进步速度
- `evaluate_training()`：综合评估 + S/A/B/C/D 评级

### v1.2.0 记忆关联图谱 + 访问追踪
- `link_memories(idx_a, idx_b, strength)`：记忆间双向关联
- `associative_retrieve(start_idx, depth)`：BFS 沿关联链检索
- `reinforce_memory(idx)`：间隔重复强化（类似 Anki）
- 检索方法命中时自动 reinforce

### v1.3.0 可配置评分 + 事件系统 + 可配置衰减
- `ScoringConfig`：自定义关键词/权重
- `DecayModel`：Hyperbolic/Linear/Exponential 三种衰减模型
- `EventSystem`：事件日志 + 回调注册

### v1.4.0 训练课程体系
- `Curriculum`：分类间前置依赖 + 每分类每难度最低轮次要求
- `curriculum_next_dilemma()`：按课程进度选困境
- `run_curriculum_pipeline()`：课程驱动训练管道

## v1.5.0 - v1.8.0 新增功能

### v1.5.0 多智能体对比训练
- `ComparativeResult`：同一困境下两个 LLM 响应对比
- `cross_pollinate(target, source, top_n)`：交叉学习
- `MultiAgentSession`：多引擎实例管理 + `cross_learn_all()`

### v1.6.0 记忆聚类 + 自动关联
- `cluster_memories(threshold)`：按文本相似度自动分组
- `auto_link(threshold, strength)`：自动为相似记忆建链
- `adaptive_reinforce(idx)`：自适应递减强化（边际递减）

### v1.7.0 训练检查点 + 回放
- `TrainingCheckpoint`：保存/恢复训练中间状态
- `resume_training(checkpoint, llm, additional_rounds)`：断点续训
- `replay_training(log, new_config?)`：换配置回放历史训练

### v1.8.0 高级统计 + 导出
- `confidence_interval(scores, level)`：置信区间
- `significance_test(before, after)`：简化 t 检验
- `export_report_csv()` / `export_evaluation_json()`：导出
- `training_summary()`：完整训练总结

## v1.9.0 - v1.12.0 新增功能

### v1.9.0 情绪状态建模 + 权重检索
- `EmotionState`：stress_level/confidence/resilience 情绪追踪
- `update()` / `recover()` / `is_breakdown()`：情绪更新与崩溃检测
- `EmotionProfile`：训练全程情绪统计画像
- `WeightStrategy`：Recency/Frequency/Value/Combined 加权检索

### v1.10.0 困境场景库 + 自定义模板
- `DilemmaTemplate`：支持 {var} 变量插值的困境模板
- `DilemmaLibrary`：多场景困境管理 + 5 个预置业务场景
- 预置场景：客服危机、项目延期、团队冲突、技术选型失误、安全事故复盘

### v1.11.0 训练协议 + 安全边界 + 审计日志
- `TrainingProtocol`：max_stress/min_confidence 安全边界
- `protocol_check()` / `enforce_protocol()`：协议检查与强制执行
- `AuditLog`：审计日志 + CSV 导出
- `cooldown_period()`：冷却期情绪恢复

### v1.12.0 可视化报告 + 导出增强
- `generate_ascii_chart()`：ASCII 折线图（分数趋势）
- `generate_ascii_bar()`：ASCII 柱状图（分类覆盖度）
- `render_dashboard()`：完整训练仪表盘
- `export_full_report_markdown()`：Markdown 完整报告

## 测试

```bash
moon check --target all     # 类型检查（四后端）
moon test --target all      # 运行测试（480 个，wasm-gc/js 后端全通过）
moon fmt                    # 格式化
```

## 完整使用教程

### 安装

```bash
moon add walkzzz/ghostvalley
```

### 快速开始

```moonbit nocheck
let gv = @ghostvalley.new_engine(max_memory_num=20)
let llm = @ghostvalley.MockLLM::new()

// 1. 温石验证：AI 是否愿意接受训练
ignore(gv.wen_shi_verify("我愿意接受挑战，接受压力训练"))

// 2. 自动化训练管道：10 轮训练，每 3 轮衰减+清理
gv.run_training_pipeline(llm, rounds=10, decay_interval=3, cleanup_threshold=0.1)

// 3. 查看训练统计
let stats = gv.get_training_stats()
println(stats.format())
// 保留率: 0.80  平均分趋势: +0.15

// 4. 加权检索：找最相关的高价值记忆
let top = gv.weighted_search("顿悟反思", 5)

// 5. 自适应困境：按当前表现选难度
let dilemma = gv.adaptive_dilemma(0.75)  // 高表现 → 难度 3
println(dilemma.content)

// 6. 保存完整引擎状态（跨会话恢复）
let state = gv.save_engine_state()
// 下次会话：
let gv2 = @ghostvalley.new_engine()
gv2.load_engine_state(state)
```

### 进阶用法

#### 去重添加记忆

```moonbit nocheck
let gv = @ghostvalley.new_engine(max_memory_num=20)
// 相似内容自动合并，不重复添加
ignore(gv.add_memory_dedup("顿悟反思改进修复迭代", is_simulation=false))
ignore(gv.add_memory_dedup("顿悟反思改进修复迭代冷静分析", is_simulation=false))
// 只有 1 条记忆（相似度 >= 0.8，合并）
```

#### 结构化困境池

```moonbit nocheck
let gv = @ghostvalley.new_engine()
// 按分类检索
let cognitive = gv.get_dilemma_by_category("cognitive")  // 3 条认知困境
let hard = gv.get_dilemma_by_difficulty(3)               // 4 条困难困境

// 自定义困境池
let custom = [
  @ghostvalley.Dilemma::new("自定义困境", category="emotional", difficulty=2),
]
gv.set_structured_dilemma_pool(custom)
```

#### 训练统计分析

```moonbit nocheck
let stats = gv.get_training_stats()
// 保留率：当前记忆数 / 总添加数
println("保留率: \{stats.retention_rate()}")
// 平均分趋势：末轮平均分 - 首轮平均分
println("趋势: \{stats.score_trend()}")
// 导出 JSON
let json = gv.export_stats_json()
```

### 深入阅读

- [架构文档](ARCHITECTURE.md) — 五大模块设计原理、数据流图、扩展点
- [设计决策](DESIGN_RATIONALE.md) — 为什么关键词匹配、为什么双曲衰减、为什么 30% 遗忘率

## 许可证

Apache-2.0（详见 [LICENSE](LICENSE)）

## 致谢

- 原项目：幽灵谷工程 Python 原版（用户提供）
- 移植实现：GhostValley Contributors
