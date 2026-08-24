// ============================================================
// Phase 3: 可配置评分 + 可配置衰减
// ============================================================

///|
/// 评分配置
///
/// 自定义高/中/低价值关键词列表及对应加分/减分权重。
/// 默认值与 v1.0.0 硬编码一致，确保向后兼容。
///
/// # Example
/// ```mbt check
/// test {
///   let config = @ghostvalley.ScoringConfig::default()
///   let score = @ghostvalley.configurable_text_value_score("顿悟反思", config)
///   assert_true(score > 0.3)
/// }
/// ```
pub(all) struct ScoringConfig {
  high_value_words : Array[String]
  mid_value_words : Array[String]
  low_value_words : Array[String]
  high_value_bonus : Double
  mid_value_bonus : Double
  low_value_penalty : Double
  base_score : Double
  multi_high_bonus : Double
  multi_mid_bonus : Double
  multi_low_penalty : Double
} derive(Debug, ToJson, FromJson)

///|
pub extend ScoringConfig with @debug.Debug::{to_repr}

///|
pub extend ScoringConfig with ToJson::{to_json}

///|
pub extend ScoringConfig with FromJson::{from_json}

///|
/// 默认评分配置（与 v1.0.0 硬编码一致）
pub fn ScoringConfig::default() -> ScoringConfig {
  {
    high_value_words: [
      "顿悟", "反思", "改进", "修复", "迭代", "区分", "筛选", "推理",
      "冷静", "分析",
    ],
    mid_value_words: [
      "失败", "错误", "冲突", "推翻", "负面", "崩盘", "调整",
    ],
    low_value_words: ["普通", "日常", "随便", "应付"],
    high_value_bonus: 0.12,
    mid_value_bonus: 0.06,
    low_value_penalty: 0.08,
    base_score: 0.15,
    multi_high_bonus: 0.1,
    multi_mid_bonus: 0.05,
    multi_low_penalty: 0.1,
  }
}

///|
/// 按配置评分
///
/// 使用自定义关键词和权重计算文本价值分。
/// 返回值 clamp 到 [0.05, 0.95]。
pub fn configurable_text_value_score(
  content : String,
  config : ScoringConfig,
) -> Double {
  let mut score = config.base_score
  let mut high_count = 0
  let mut mid_count = 0
  let mut low_count = 0
  for w in config.high_value_words {
    if content.contains(w) {
      score = score + config.high_value_bonus
      high_count = high_count + 1
    }
  }
  for w in config.mid_value_words {
    if content.contains(w) {
      score = score + config.mid_value_bonus
      mid_count = mid_count + 1
    }
  }
  for w in config.low_value_words {
    if content.contains(w) {
      score = score - config.low_value_penalty
      low_count = low_count + 1
    }
  }
  if high_count >= 2 {
    score = score + config.multi_high_bonus
  }
  if mid_count >= 2 {
    score = score + config.multi_mid_bonus
  }
  if low_count >= 2 {
    score = score - config.multi_low_penalty
  }
  if score < 0.05 {
    0.05
  } else if score > 0.95 {
    0.95
  } else {
    score
  }
}

///|
/// 衰减模型
///
/// 支持三种衰减策略：
/// - Hyperbolic: score / (1 + elapsed / half_life)（默认，当前行为）
/// - Linear: score * max(0, 1 - elapsed * rate)
/// - Exponential: score * decay_base^elapsed
pub(all) enum DecayModel {
  Hyperbolic
  Linear
  Exponential
} derive(Debug, Eq, ToJson, FromJson)

///|
pub extend DecayModel with @debug.Debug::{to_repr}

///|
pub extend DecayModel with Eq::{equal, not_equal}

///|
pub extend DecayModel with ToJson::{to_json}

///|
pub extend DecayModel with FromJson::{from_json}

///|
/// 衰减参数
///
/// - `linear_rate`: Linear 模型的衰减率（默认 0.02）
/// - `exp_decay_base`: Exponential 模型的衰减基数（默认 0.95）
pub(all) struct DecayParams {
  linear_rate : Double
  exp_decay_base : Double
} derive(Debug, ToJson, FromJson)

///|
pub extend DecayParams with @debug.Debug::{to_repr}

///|
pub extend DecayParams with ToJson::{to_json}

///|
pub extend DecayParams with FromJson::{from_json}

///|
/// 默认衰减参数
pub fn DecayParams::default() -> DecayParams {
  { linear_rate: 0.02, exp_decay_base: 0.95 }
}

///|
/// 按模型计算衰减后的分数
///
/// `current_score` 是当前分数，`elapsed` 是经过的轮次。
pub fn apply_decay_model(
  model : DecayModel,
  params : DecayParams,
  current_score : Double,
  elapsed : Int,
) -> Double {
  if elapsed <= 0 {
    return current_score
  }
  match model {
    Hyperbolic => {
      // 与 v1.0.0 一致: half_life = score * 50.0
      let half_life = current_score * 50.0
      if half_life > 0.0 {
        let factor = 1.0 / (1.0 + elapsed.to_double() / half_life)
        current_score * factor
      } else {
        current_score
      }
    }
    Linear => {
      let factor = 1.0 - elapsed.to_double() * params.linear_rate
      if factor < 0.0 {
        0.0
      } else {
        current_score * factor
      }
    }
    Exponential => {
      // decay_base^elapsed
      let mut factor = 1.0
      for _ in 0..<elapsed {
        factor = factor * params.exp_decay_base
      }
      current_score * factor
    }
  }
}
