// ============================================================
// Phase 1 (v1.9.0): 情绪状态建模 + 记忆权重检索策略
// ============================================================

///|
/// 情绪状态
///
/// 追踪 AI 在训练过程中的心理状态变化。
/// - `stress_level`：压力水平 [0, 1]，困境难度越高压力越大
/// - `confidence`：信心水平 [0, 1]，高质量响应提升信心
/// - `resilience`：韧性水平 [0, 1]，长期训练中积累的抗压能力
/// - `mood_history`：每轮训练后的情绪快照
///
/// # Example
/// ```mbt check
/// test {
///   let es = @ghostvalley.EmotionState::initial()
///   assert_eq(es.stress_level, 0.0)
///   assert_eq(es.confidence, 0.5)
/// }
/// ```
pub(all) struct EmotionState {
  mut stress_level : Double
  mut confidence : Double
  mut resilience : Double
  mood_history : Array[MoodSnapshot]
} derive(Debug, ToJson, FromJson)

///|
pub extend EmotionState with @debug.Debug::{to_repr}

///|
pub extend EmotionState with ToJson::{to_json}

///|
pub extend EmotionState with FromJson::{from_json}

///|
/// 情绪快照
///
/// 记录某一轮训练结束时的情绪状态。
pub(all) struct MoodSnapshot {
  round : Int
  stress : Double
  confidence : Double
  resilience : Double
} derive(Debug, ToJson, FromJson)

///|
pub extend MoodSnapshot with @debug.Debug::{to_repr}

///|
pub extend MoodSnapshot with ToJson::{to_json}

///|
pub extend MoodSnapshot with FromJson::{from_json}

///|
/// 情绪画像
///
/// 训练全程的情绪变化轨迹统计。
pub(all) struct EmotionProfile {
  peak_stress : Double
  lowest_confidence : Double
  avg_stress : Double
  avg_confidence : Double
  stress_variance : Double
  breakdown_count : Int
  total_snapshots : Int
} derive(Debug, ToJson, FromJson)

///|
pub extend EmotionProfile with @debug.Debug::{to_repr}

///|
pub extend EmotionProfile with ToJson::{to_json}

///|
pub extend EmotionProfile with FromJson::{from_json}

///|
/// 检索权重策略
///
/// 控制记忆检索时不同因素的权重分配。
pub(all) enum WeightStrategy {
  Recency // 按时间近度加权（最近添加的记忆权重高）
  Frequency // 按访问频率加权（被检索次数多的权重高）
  Value // 按 value_score 加权（价值分高的权重高）
  Combined // 综合加权（value * 0.5 + frequency * 0.3 + recency * 0.2）
} derive(Debug, Eq, ToJson, FromJson)

///|
pub extend WeightStrategy with @debug.Debug::{to_repr}

///|
pub extend WeightStrategy with Eq::{equal, not_equal}

///|
pub extend WeightStrategy with ToJson::{to_json}

///|
pub extend WeightStrategy with FromJson::{from_json}

///|
/// 初始情绪状态
///
/// 训练开始时：无压力、中等信心、零韧性。
pub fn EmotionState::initial() -> EmotionState {
  { stress_level: 0.0, confidence: 0.5, resilience: 0.0, mood_history: [] }
}

///|
/// 更新情绪状态
///
/// 每轮训练后调用。困境难度提升压力，响应质量提升信心。
/// - `dilemma_difficulty`：1-3，难度越高压力增量越大
/// - `response_score`：0-1，响应质量越高信心增量越大
pub fn EmotionState::update(
  self : EmotionState,
  round~ : Int,
  dilemma_difficulty~ : Int,
  response_score~ : Double,
) -> Unit {
  // 压力增量：难度 1→+0.1, 2→+0.2, 3→+0.35
  let stress_delta = if dilemma_difficulty >= 3 {
    0.35
  } else if dilemma_difficulty >= 2 {
    0.2
  } else {
    0.1
  }
  // 信心增量：响应质量 > 0.5 时提升，否则下降
  let confidence_delta = (response_score - 0.5) * 0.3
  // 韧性：长期在高压下保持高信心，韧性增长
  let resilience_delta = if dilemma_difficulty >= 2 && response_score > 0.5 {
    0.02
  } else {
    0.0
  }
  self.stress_level = clamp(self.stress_level + stress_delta, 0.0, 1.0)
  self.confidence = clamp(self.confidence + confidence_delta, 0.0, 1.0)
  self.resilience = clamp(self.resilience + resilience_delta, 0.0, 1.0)
  // 记录快照
  self.mood_history.push(MoodSnapshot::{
    round,
    stress: self.stress_level,
    confidence: self.confidence,
    resilience: self.resilience,
  })
}

///|
/// 情绪自然恢复
///
/// 每轮训练间隔的恢复期：压力衰减 5%，信心向 0.5 回归 3%。
pub fn EmotionState::recover(self : EmotionState) -> Unit {
  // 压力衰减
  self.stress_level = clamp(self.stress_level * 0.95, 0.0, 1.0)
  // 信心向 0.5 回归（衰减 3%）
  self.confidence = clamp(
    self.confidence + (0.5 - self.confidence) * 0.03,
    0.0,
    1.0,
  )
}

///|
/// 压力崩溃检测
///
/// 当 stress > 0.9 且 confidence < 0.2 时，AI 处于崩溃边缘。
/// 返回 true 表示需要暂停训练。
///
/// # Example
/// ```mbt check
/// test {
///   let es = @ghostvalley.EmotionState::initial()
///   es.stress_level = 0.95
///   es.confidence = 0.1
///   assert_true(es.is_breakdown())
/// }
/// ```
pub fn EmotionState::is_breakdown(self : EmotionState) -> Bool {
  self.stress_level > 0.9 && self.confidence < 0.2
}

///|
/// 生成情绪画像
///
/// 从 mood_history 计算训练全程的情绪统计。
pub fn EmotionState::profile(self : EmotionState) -> EmotionProfile {
  let history = self.mood_history
  if history.length() == 0 {
    return EmotionProfile::{
      peak_stress: 0.0,
      lowest_confidence: 0.0,
      avg_stress: 0.0,
      avg_confidence: 0.0,
      stress_variance: 0.0,
      breakdown_count: 0,
      total_snapshots: 0,
    }
  }
  let mut peak = 0.0
  let mut lowest = 1.0
  let mut stress_sum = 0.0
  let mut conf_sum = 0.0
  let mut breakdowns = 0
  for snap in history {
    if snap.stress > peak {
      peak = snap.stress
    }
    if snap.confidence < lowest {
      lowest = snap.confidence
    }
    stress_sum = stress_sum + snap.stress
    conf_sum = conf_sum + snap.confidence
    if snap.stress > 0.9 && snap.confidence < 0.2 {
      breakdowns = breakdowns + 1
    }
  }
  let n = history.length().to_double()
  let avg_s = stress_sum / n
  let avg_c = conf_sum / n
  // 方差
  let mut var_sum = 0.0
  for snap in history {
    let diff = snap.stress - avg_s
    var_sum = var_sum + diff * diff
  }
  let variance = var_sum / n
  EmotionProfile::{
    peak_stress: peak,
    lowest_confidence: lowest,
    avg_stress: avg_s,
    avg_confidence: avg_c,
    stress_variance: variance,
    breakdown_count: breakdowns,
    total_snapshots: history.length(),
  }
}

///|
/// 情绪轨迹
///
/// 返回训练全程的压力变化曲线（stress 序列）。
pub fn EmotionState::trajectory(self : EmotionState) -> Array[Double] {
  let result : Array[Double] = []
  for snap in self.mood_history {
    result.push(snap.stress)
  }
  result
}

///|
/// 信心轨迹
///
/// 返回训练全程的信心变化曲线。
pub fn EmotionState::confidence_trajectory(
  self : EmotionState,
) -> Array[Double] {
  let result : Array[Double] = []
  for snap in self.mood_history {
    result.push(snap.confidence)
  }
  result
}

///|
/// 格式化情绪状态为可读字符串
pub fn EmotionState::format(self : EmotionState) -> String {
  let buf = StringBuilder::new()
  buf.write_string("=== 情绪状态 ===\n")
  buf.write_string("压力水平: ")
  buf.write_string(self.stress_level.to_string())
  buf.write_string("\n")
  buf.write_string("信心水平: ")
  buf.write_string(self.confidence.to_string())
  buf.write_string("\n")
  buf.write_string("韧性水平: ")
  buf.write_string(self.resilience.to_string())
  buf.write_string("\n")
  buf.write_string("快照数量: ")
  buf.write_string(self.mood_history.length().to_string())
  buf.write_string("\n")
  if self.is_breakdown() {
    buf.write_string("⚠ 警告：压力崩溃风险！\n")
  }
  buf.to_string()
}

// ============================================================
// 记忆权重检索策略
// ============================================================

///|
/// 按策略加权检索记忆
///
/// 根据指定策略对记忆库排序，返回前 `n` 条。
/// - `Recency`：最近添加的优先（索引大的优先）
/// - `Frequency`：访问次数多的优先
/// - `Value`：value_score 高的优先
/// - `Combined`：value*0.5 + frequency_norm*0.3 + recency_norm*0.2
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=20)
///   gv.add_memory("顿悟反思改进", is_simulation=false)
///   gv.add_memory("普通日常随便", is_simulation=false)
///   let results = gv.weighted_retrieve(1, @ghostvalley.Combined)
///   assert_eq(results.length(), 1)
/// }
/// ```
pub fn GhostValleyEngine::weighted_retrieve(
  self : GhostValleyEngine,
  n : Int,
  strategy : WeightStrategy,
) -> Array[AiMemory] {
  let bank = self.memory_bank
  if n <= 0 || bank.length() == 0 {
    return []
  }
  let total = bank.length()
  // 构建 (memory, weight) 列表
  let weighted : Array[(AiMemory, Double)] = []
  for i, m in bank {
    let weight = match strategy {
      Recency => i.to_double() / total.to_double()
      Frequency =>
        m.access_count.to_double() / (m.access_count.to_double() + 1.0)
      Value => m.value_score
      Combined => {
        let v = m.value_score
        let f = m.access_count.to_double() / (m.access_count.to_double() + 1.0)
        let r = i.to_double() / total.to_double()
        v * 0.5 + f * 0.3 + r * 0.2
      }
    }
    weighted.push((m, weight))
  }
  // 按权重降序排序
  weighted.sort_by(fn(a, b) { b.1.compare(a.1) })
  // 取前 n 条
  let result : Array[AiMemory] = []
  let take = if n < weighted.length() { n } else { weighted.length() }
  for i in 0..<take {
    result.push(weighted[i].0)
  }
  result
}

///|
/// 辅助函数：clamp 到 [lo, hi]
fn clamp(val : Double, lo : Double, hi : Double) -> Double {
  if val < lo {
    lo
  } else if val > hi {
    hi
  } else {
    val
  }
}
