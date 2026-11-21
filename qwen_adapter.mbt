///|
/// Qwen 回放适配器配置。
pub(all) struct QwenConfig {
  /// 响应最大字符数（防止 0.5B 模型输出过长）
  max_response_chars : Int32
  /// 未知困境的回退响应（不提供标准答案）
  fallback : String
  /// 相似度匹配阈值（0~1）
  match_threshold : Double
}

///|
pub fn QwenConfig::default() -> QwenConfig {
  {
    max_response_chars: 120,
    fallback: "先承认失败，再拆解问题，从最小可验证的一步重新开始。",
    match_threshold: 0.3,
  }
}

///|
/// 基于本地 Qwen2.5-0.5B-Instruct 真实响应的回放适配器。
///
/// 语料由 `scripts/qwen_generate.py` 生成，编译进 `qwen_corpus.mbt`；
/// 运行时无模型、无网络依赖，四后端行为一致。
pub(all) struct QwenReplayLLM {
  responses : Map[String, String]
  fallback : String
  max_chars : Int32
  threshold : Double
  mut hits : Int32
  mut misses : Int32
}

///|
pub fn QwenReplayLLM::new() -> QwenReplayLLM {
  QwenReplayLLM::with_config(QwenConfig::default())
}

///|
pub fn QwenReplayLLM::with_config(config : QwenConfig) -> QwenReplayLLM {
  let responses : Map[String, String] = Map([])
  for sample in qwen_samples {
    responses[sample.dilemma] = sample.response
  }
  {
    responses,
    fallback: config.fallback,
    max_chars: config.max_response_chars,
    threshold: config.match_threshold,
    hits: 0,
    misses: 0,
  }
}

///|
/// 清洗模型响应：压平换行/制表符、压缩多空格、按字符数截断。
pub fn qwen_clean_response(text : String, max_chars : Int32) -> String {
  let flat = text
    .replace_all(old="\r", new=" ")
    .replace_all(old="\n", new=" ")
    .replace_all(old="\t", new=" ")
  let mut result = flat.trim(chars=" ").to_owned()
  while result.contains("  ") {
    result = result.replace_all(old="  ", new=" ")
  }
  if max_chars <= 0 {
    return ""
  }
  let chars = result.to_array()
  if chars.length() <= max_chars {
    result
  } else {
    let buf = StringBuilder()
    for i in 0..<max_chars {
      buf.write_char(chars[i])
    }
    buf.to_string()
  }
}

///|
/// 字符级 Jaccard 相似度，作为关键词表为空时的回退。
fn char_jaccard(a : String, b : String) -> Double {
  let set_a : Map[String, Unit] = Map([])
  for ch in a.to_array() {
    set_a[ch.to_string()] = ()
  }
  let set_b : Map[String, Unit] = Map([])
  for ch in b.to_array() {
    set_b[ch.to_string()] = ()
  }
  if set_a.length() == 0 || set_b.length() == 0 {
    return 0.0
  }
  let mut intersection = 0
  for kv in set_a {
    if set_b.contains(kv.0) {
      intersection = intersection + 1
    }
  }
  let union = set_a.length() + set_b.length() - intersection
  intersection.to_double() / union.to_double()
}

///|
/// 困境与提示词的相似度：相同为 1.0；否则关键词重叠，再回退到字符级 Jaccard。
pub fn qwen_match_score(prompt : String, dilemma : String) -> Double {
  if prompt == dilemma {
    1.0
  } else {
    let keyword_score = text_similarity(prompt, dilemma)
    if keyword_score > 0.0 {
      keyword_score
    } else {
      char_jaccard(prompt, dilemma)
    }
  }
}

///|
/// 按提示词查找最匹配的 Qwen 语料响应；未命中返回 None。
pub fn qwen_response_for(prompt : String) -> String? {
  for sample in qwen_samples {
    if prompt == sample.dilemma || prompt.contains(sample.dilemma) {
      return Some(sample.response)
    }
  }
  let mut best : String? = None
  let mut best_score = 0.0
  for sample in qwen_samples {
    let score = text_similarity(prompt, sample.dilemma)
    if score > best_score {
      best_score = score
      best = Some(sample.response)
    }
  }
  if best_score >= QwenConfig::default().match_threshold {
    best
  } else {
    None
  }
}

///|
fn QwenReplayLLM::response_for(self : QwenReplayLLM, prompt : String) -> String {
  match qwen_response_for(prompt) {
    Some(response) => {
      self.hits = self.hits + 1
      qwen_clean_response(response, self.max_chars)
    }
    None => {
      self.misses = self.misses + 1
      qwen_clean_response(self.fallback, self.max_chars)
    }
  }
}

///|
pub impl LLMAdapter for QwenReplayLLM with fn generate_response(self, prompt) {
  self.response_for(prompt)
}

///|
pub extend QwenReplayLLM with LLMAdapter::{generate_response}

///|
/// (命中次数, 未命中次数)
pub fn QwenReplayLLM::stats(self : QwenReplayLLM) -> (Int32, Int32) {
  (self.hits, self.misses)
}

///|
pub fn QwenReplayLLM::hit_rate(self : QwenReplayLLM) -> Double {
  let total = self.hits + self.misses
  if total == 0 {
    0.0
  } else {
    self.hits.to_double() / total.to_double()
  }
}

///|
pub fn QwenReplayLLM::sample_count(self : QwenReplayLLM) -> Int32 {
  self.responses.length()
}

///|
/// 语料评测摘要：样本数、平均长度、平均延迟、平均 token。
pub fn qwen_eval_summary() -> String {
  let count = qwen_samples.length()
  if count == 0 {
    return "Qwen corpus: empty"
  }
  let mut total_len = 0
  let mut total_latency = 0
  let mut total_tokens = 0
  for sample in qwen_samples {
    total_len = total_len + sample.response.to_array().length()
    total_latency = total_latency + sample.latency_ms
    total_tokens = total_tokens + sample.tokens
  }
  let n = count.to_double()
  "Qwen corpus: samples=" +
  count.to_string() +
  " avg_len=" +
  (total_len.to_double() / n).to_string() +
  " avg_latency_ms=" +
  (total_latency.to_double() / n).to_string() +
  " avg_tokens=" +
  (total_tokens.to_double() / n).to_string()
}
