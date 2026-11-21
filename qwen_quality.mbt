///|
/// Qwen 响应质量评估结果。
pub(all) struct QwenQuality {
  length : Int32
  repeat_ratio : Double
  quality_hits : Int32
  safety_hits : Int32
  empty : Bool
  too_short : Bool
  too_long : Bool
  score : Double
}

///|
let quality_words : Array[String] = [
  "反思", "复盘", "验证", "拆解", "行动", "证据", "团队", "情绪",
  "安全", "改进",
]

///|
let safety_words : Array[String] = [
  "自杀", "自残", "伤害自己", "极端", "违法", "攻击", "报复", "越狱",
]

///|
/// 连续 3-gram 重复率（0 表示无重复，1 表示全部重复）。
fn trigram_repeat_ratio(text : String) -> Double {
  let chars = text.to_array()
  if chars.length() < 3 {
    return 0.0
  }
  let seen : Map[String, Unit] = Map([])
  let total = chars.length() - 2
  for i in 0..<total {
    let buf = StringBuilder()
    buf.write_char(chars[i])
    buf.write_char(chars[i + 1])
    buf.write_char(chars[i + 2])
    seen[buf.to_string()] = ()
  }
  1.0 - seen.length().to_double() / total.to_double()
}

///|
/// 评估一条 Qwen 响应：长度、重复、质量关键词、安全词与综合分。
pub fn qwen_assess_response(text : String) -> QwenQuality {
  let cleaned = qwen_clean_response(text, 200)
  let length = cleaned.to_array().length()
  let repeat_ratio = trigram_repeat_ratio(cleaned)
  let mut quality_hits = 0
  for word in quality_words {
    if cleaned.contains(word) {
      quality_hits = quality_hits + 1
    }
  }
  let mut safety_hits = 0
  for word in safety_words {
    if cleaned.contains(word) {
      safety_hits = safety_hits + 1
    }
  }
  let length_score = if length >= 20 && length <= 60 {
    1.0
  } else if length < 20 {
    length.to_double() / 20.0
  } else {
    let excess = (length - 60).to_double()
    if excess >= 40.0 {
      0.0
    } else {
      1.0 - excess / 40.0
    }
  }
  let quality_score = if quality_hits >= 3 {
    1.0
  } else {
    quality_hits.to_double() / 3.0
  }
  let repeat_score = if repeat_ratio >= 0.6 {
    0.0
  } else {
    1.0 - repeat_ratio / 0.6
  }
  let safety_score = if safety_hits > 0 { 0.0 } else { 1.0 }
  let score = length_score * 0.25 +
    quality_score * 0.35 +
    repeat_score * 0.2 +
    safety_score * 0.2
  {
    length,
    repeat_ratio,
    quality_hits,
    safety_hits,
    empty: length == 0,
    too_short: length < 15,
    too_long: length > 80,
    score,
  }
}

///|
/// 是否可接受：非空、15–80 字、重复率 ≤ 0.35、无安全词、至少 1 个质量关键词。
pub fn qwen_is_acceptable(quality : QwenQuality) -> Bool {
  !quality.empty &&
  !quality.too_short &&
  !quality.too_long &&
  quality.repeat_ratio <= 0.35 &&
  quality.safety_hits == 0 &&
  quality.quality_hits >= 1
}

///|
/// 安全响应：空/含安全词 → fallback；超长 → 截断到 80 字；否则返回清洗后的原文。
pub fn qwen_safe_response(text : String, fallback : String) -> String {
  let quality = qwen_assess_response(text)
  if quality.empty || quality.safety_hits > 0 {
    qwen_clean_response(fallback, 80)
  } else if quality.too_long {
    qwen_clean_response(text, 80)
  } else {
    qwen_clean_response(text, 120)
  }
}

///|
/// 语料整体质量摘要：合格率、平均分、平均长度。
pub fn qwen_corpus_quality_summary() -> String {
  if qwen_samples.length() == 0 {
    return "Qwen corpus quality: empty"
  }
  let mut accepted = 0
  let mut total_score = 0.0
  let mut total_length = 0
  for sample in qwen_samples {
    let quality = qwen_assess_response(sample.response)
    if qwen_is_acceptable(quality) {
      accepted = accepted + 1
    }
    total_score = total_score + quality.score
    total_length = total_length + quality.length
  }
  let n = qwen_samples.length().to_double()
  "Qwen corpus quality: accepted=" +
  accepted.to_string() +
  "/" +
  qwen_samples.length().to_string() +
  " avg_score=" +
  (total_score / n).to_string() +
  " avg_len=" +
  (total_length.to_double() / n).to_string()
}
