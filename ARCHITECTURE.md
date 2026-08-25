# GhostValley 架构文档

> AI 心理压力演练系统 — 架构设计原理与数据流

## 1. 系统概览

GhostValley 是一个 AI 心理压力演练系统，通过模拟困境训练 AI 的心理韧性。
系统由五大核心模块组成，围绕"记忆"这一中心数据结构运作。

```
┌─────────────────────────────────────────────────┐
│                 GhostValleyEngine                │
│                                                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │ 温石验证 │→│ 安全气垫 │→│ 主动遗忘 │      │
│  └──────────┘  └──────────┘  └──────────┘      │
│        ↓             ↓             ↓             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │  第八根  │→│ 建造者   │→│  记忆库   │      │
│  │  空桩    │  │  退场    │  │ (Array)  │      │
│  └──────────┘  └──────────┘  └──────────┘      │
│                                      ↓          │
│              ┌────────────────────────┤          │
│              │  衰减 / 清理 / 检索   │          │
│              └────────────────────────┘          │
└─────────────────────────────────────────────────┘
```

## 2. 五大模块

### 2.1 温石验证 (Wen Shi Verify)

**职责**：判断 AI 是否愿意接受心理压力训练。

**设计原理**：基于关键词匹配的态度评分。提取"愿意/接受/挑战"等正向关键词与
"拒绝/逃避/害怕"等负向关键词，计算 `正向分 - 负向分`，超过阈值 0.4 则通过。

**为什么不用 NLP 模型**：系统设计为零依赖纯 MoonBit 实现，不引入外部模型调用。
关键词匹配在训练场景下足够可靠——用户输入是明确的意愿表达，不是模糊的自然语言。

**扩展点**：`wen_shi_willing_score` 字段公开可读写，可替换为任意评分函数的输出。

### 2.2 防创伤安全气垫 (Simulation Safety)

**职责**：标记模拟记忆，防止 AI 将虚构挫折当作真实经历。

**设计原理**：`AiMemory.is_simulation` 布尔标记。模拟训练中产生的记忆标记为
`is_simulation=true`，与真实记忆隔离。`simulation_memories()` 专门检索模拟记忆。

**扩展点**：可扩展为枚举类型（如 `real/simulation/dream`），当前二元足够使用。

### 2.3 主动式遗忘 (Active Forget)

**职责**：AI 自主筛选，删除价值低、冗余的记忆。

**设计原理**：
- **触发条件**：记忆数 > `max_memory_num / 2`（至少为 1）
- **删除比例**：非核心记忆的 30%（至少 1 条）
- **保护机制**：核心记忆（`is_core_memory=true`）永不删除
- **排序依据**：按 `value_score` 升序排列，删除最低价值的

**为什么是 30%**：太低（如 10%）遗忘效率不够，记忆库膨胀；太高（如 50%）一次性丢失过多信息，
破坏训练连续性。30% 在保留 70% 信息的同时有效控制容量。参见 [DESIGN_RATIONALE.md](DESIGN_RATIONALE.md)。

**扩展点**：`max_memory_num` 可配置，遗忘比例硬编码 30% 可提取为参数。

### 2.4 第八根空桩 (Empty Stake Dilemma)

**职责**：提供困境池，随机选择困境挑战 AI。

**设计原理**：
- **字符串困境池**（v0.3.0）：`empty_stake_dilemma_pool: Array[String]`
- **结构化困境池**（v0.7.0）：`structured_dilemma_pool: Array[Dilemma]`
  - `Dilemma { content, category, difficulty }`
  - 4 分类 × 3 难度 = 12 默认困境
  - `adaptive_dilemma(performance)` 按表现自动选难度

**扩展点**：`set_dilemma_pool` / `set_structured_dilemma_pool` 可注入自定义困境。

### 2.5 建造者退场 (Builder Exit)

**职责**：AI 接受自身成长，将训练感悟存入记忆库。

**设计原理**：`LLMAdapter` trait 定义 LLM 接口，`MockLLM` 提供测试用实现。
`run_round_with_llm` 执行一轮完整训练：选困境 → LLM 响应 → 评分 → 存记忆 → 记日志。

**扩展点**：实现 `LLMAdapter` trait 即可接入任意 LLM（OpenAI、Claude、本地模型等）。

## 3. 辅助模块

### 3.1 记忆检索 (Retrieval)

| 方法 | 说明 | 复杂度 |
|------|------|--------|
| `search_memories(keyword)` | 子串匹配检索 | O(n) |
| `top_memories(n)` | 按 value_score 取 top-n | O(n×k) partial selection |
| `weighted_search(query, top_n)` | 加权综合检索 | O(n log n) |
| `filter_memories(...)` | 按标记过滤 | O(n) |

`weighted_search` 复合分 = `value_score×0.4 + text_similarity×0.4 + 近因×0.2`

### 3.2 衰减机制 (Decay)

双曲衰减模型：`score *= decay_factor / (decay_factor + elapsed_rounds)`

随时间推移，记忆价值自然衰减，模拟"遗忘曲线"。`cleanup_low_value(threshold)` 清理
低于阈值的非核心记忆。

### 3.3 训练日志 (Training Log)

`TrainingLogEntry` 记录每轮训练的困境、AI 响应、记忆数。`TrainingLog` 管理日志序列，
支持 JSON 导出和格式化输出。

### 3.4 统计追踪 (Training Stats)

`TrainingStats` 追踪跨轮次指标：
- `total_rounds_completed` / `total_memories_added` / `total_memories_cleaned` / `total_decay_applied`
- `avg_score_history` / `memory_count_history`
- `retention_rate()` / `score_trend()`

### 3.5 持久化 (Persistence)

| 方法 | 说明 |
|------|------|
| `save_memory() / load_memory(json)` | 记忆库 JSON 序列化 |
| `save_engine_state() / load_engine_state(json)` | 完整引擎状态序列化 |

`EngineState` 包含 memory + stats + config + rounds，支持跨会话训练恢复。

### 3.6 训练评估 (Training Evaluator) [v1.1.0]

`TrainingEvaluation` 综合评估训练效果：
- `resilience_score`：高难度/低难度平均响应分比值，衡量能力保持率
- `category_coverage`：4 分类训练覆盖情况，识别薄弱分类
- `improvement_rate`：线性回归斜率，量化进步速度
- `overall_grade`：S/A/B/C/D 总体评级

### 3.7 记忆关联图谱 (Memory Association) [v1.2.0]

- `link_memories(idx_a, idx_b, strength)`：双向关联，strength ∈ [0,1]
- `associative_retrieve(start_idx, depth)`：BFS 沿关联链检索
- `reinforce_memory(idx)`：间隔重复强化（access_count++ + value_score 微增）
- 检索方法命中时自动 reinforce

### 3.8 可配置评分 + 衰减 (Config) [v1.3.0]

- `ScoringConfig`：自定义关键词/权重/奖励阈值
- `DecayModel`：Hyperbolic/Linear/Exponential 三种衰减模型
- `DecayParams`：衰减参数可调

### 3.9 事件系统 (Event System) [v1.3.0]

`TrainingEvent` 枚举 + `EventSystem` 事件日志 + 回调注册。
训练管道自动 emit MemoryAdded/DecayApplied/CleanupDone/RoundCompleted 事件。

### 3.10 训练课程 (Curriculum) [v1.4.0]

`Curriculum` 定义分类间前置依赖和每分类每难度最低轮次要求。
`run_curriculum_pipeline` 按课程进度选困境，优先补足薄弱分类。

## 4. 数据流

```
用户输入 "愿意接受挑战"
        ↓
[温石验证] willing_score = 0.6 > 0.4 → 通过
        ↓
[训练管道] run_training_pipeline(llm, rounds=10)
        ↓
  ┌──→ [选困境] adaptive_dilemma(performance) → Dilemma
  │       ↓
  │   [LLM 响应] llm.respond(dilemma) → response
  │       ↓
  │   [评分] text_value_score(response) → value_score
  │       ↓
  │   [存记忆] add_memory(response) → memory_bank
  │       ↓
  │   [定期衰减] apply_decay(interval) → 分数衰减
  │       ↓
  │   [定期清理] cleanup_low_value(threshold) → 删除低价值
  │       ↓
  │   [记统计] training_stats.update()
  │       ↓
  └── 重复 rounds 次
        ↓
[输出] training_report / training_stats / engine_state
```

## 5. 文件结构

```
ghost_valley.mbt            — 引擎主体 + 温石验证 + 安全气垫 + 主动遗忘 + 建造者退场
retrieval.mbt               — 记忆检索 (search/top/weighted_search/filter)
decay.mbt                   — 衰减机制 + 清理
embedding.mbt               — 关键词提取 + 语义打分 + 相似度
training_log.mbt            — 训练日志
training_stats.mbt          — 训练统计
dilemma.mbt                 — 结构化困境 + 分类 + 难度递进
persistence.mbt             — 持久化 (memory + engine state)
report.mbt                  — 训练报告
training_evaluator.mbt      — 训练评估 (韧性分/覆盖度/改善率/评级) [v1.1.0]
memory_association.mbt      — 记忆关联图谱 + 访问追踪 [v1.2.0]
config.mbt                  — 可配置评分 + 可配置衰减 [v1.3.0]
event_system.mbt            — 事件系统 [v1.3.0]
curriculum.mbt              — 训练课程体系 [v1.4.0]
```

## 6. API 稳定性

| API | 状态 | 版本 |
|-----|------|------|
| `new_engine` / `add_memory` / `active_forget` | stable | v0.1.0 |
| `wen_shi_verify` / `run_round_with_llm` | stable | v0.1.0 |
| `search_memories` / `top_memories` / `filter_memories` | stable | v0.3.0 |
| `apply_decay` / `cleanup_low_value` | stable | v0.3.0 |
| `save_memory` / `load_memory` | stable | v0.2.0 |
| `weighted_search` / `add_memory_dedup` / `merge_memories` | stable | v0.5.0 |
| `run_training_pipeline` / `get_training_stats` | stable | v0.6.0 |
| `Dilemma` / `adaptive_dilemma` / `get_dilemma_by_category` | stable | v0.7.0 |
| `save_engine_state` / `load_engine_state` | stable | v0.7.0 |
| `LLMAdapter` trait / `MockLLM` | stable | v0.2.0 |
| `resilience_score` / `category_coverage` / `improvement_rate` / `evaluate_training` | stable | v1.1.0 |
| `link_memories` / `associative_retrieve` / `reinforce_memory` / `access_frequency_report` | stable | v1.2.0 |
| `ScoringConfig` / `configurable_text_value_score` / `set_scoring_config` | stable | v1.3.0 |
| `DecayModel` / `DecayParams` / `set_decay_model` / `set_decay_params` | stable | v1.3.0 |
| `EventSystem` / `register_callback` / `get_event_log` / `event_count` | stable | v1.3.0 |
| `Curriculum` / `curriculum_next_dilemma` / `curriculum_progress` / `run_curriculum_pipeline` | stable | v1.4.0 |
