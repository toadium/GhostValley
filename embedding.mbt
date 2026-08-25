///|
/// 文本价值评分器
///
/// 基于关键词匹配近似 Embedding 向量相似度，替代纯随机打分。
/// 高价值关键词代表深度思考和自我改进，
/// 中价值关键词代表问题暴露和经验积累，
/// 低价值关键词代表无实质内容。
///
/// # Example
/// ```mbt check
/// test {
///   let score = @ghostvalley.text_value_score("顿悟失败原因，反思改进")
///   assert_true(score > 0.5)
/// }
/// ```
pub fn text_value_score(content : String) -> Double {
  configurable_text_value_score(content, ScoringConfig::default())
}

///|
/// 计算两条文本的相似度（基于关键词重叠率）
///
/// 返回 [0, 1] 的相似度分数，1 表示完全相似。
pub fn text_similarity(a : String, b : String) -> Double {
  let words_a = extract_keywords(a)
  let words_b = extract_keywords(b)
  if words_a.length() == 0 || words_b.length() == 0 {
    return 0.0
  }
  let mut overlap = 0
  for w in words_a {
    if words_b.contains(w) {
      overlap = overlap + 1
    }
  }
  let total = words_a.length() + words_b.length()
  2.0 * overlap.to_double() / total.to_double()
}

///|
fn extract_keywords(text : String) -> Array[String] {
  let all_keywords = [
    "顿悟", "反思", "改进", "修复", "迭代", "区分", "筛选", "推理",
    "冷静", "分析", "失败", "错误", "冲突", "推翻", "负面", "崩盘",
    "调整", "记忆", "信息", "逻辑", "普通", "日常", "随便", "应付",
    "压力", "训练", "挑战",
  ]
  let result : Array[String] = []
  for w in all_keywords {
    if text.contains(w) {
      result.push(w)
    }
  }
  result
}
