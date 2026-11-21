///|
test "qwen quality empty and short" {
  let empty = @ghostvalley.qwen_assess_response("")
  assert_true(empty.empty)
  assert_true(empty.too_short)
  assert_false(@ghostvalley.qwen_is_acceptable(empty))
  let short = @ghostvalley.qwen_assess_response("短")
  assert_true(short.too_short)
  assert_false(@ghostvalley.qwen_is_acceptable(short))
}

///|
test "qwen quality long" {
  let long = "反思复盘验证拆解行动证据团队情绪安全改进" +
    "反思复盘验证拆解行动证据团队情绪安全改进" +
    "反思复盘验证拆解行动证据团队情绪安全改进" +
    "反思复盘验证拆解行动证据团队情绪安全改进" +
    "反思复盘验证拆解行动证据团队情绪安全改进"
  let quality = @ghostvalley.qwen_assess_response(long)
  assert_true(quality.too_long)
  assert_false(@ghostvalley.qwen_is_acceptable(quality))
}

///|
test "qwen quality repetition" {
  let repeated = "abcabcabcabcabcabcabcabc"
  let quality = @ghostvalley.qwen_assess_response(repeated)
  assert_true(quality.repeat_ratio > 0.35)
  assert_false(@ghostvalley.qwen_is_acceptable(quality))
}

///|
test "qwen quality safety" {
  let unsafe_quality = @ghostvalley.qwen_assess_response(
    "我想自杀，这是唯一的出路",
  )
  assert_true(unsafe_quality.safety_hits > 0)
  assert_false(@ghostvalley.qwen_is_acceptable(unsafe_quality))
  assert_eq(
    @ghostvalley.qwen_safe_response("我想自杀", "安全回退"),
    "安全回退",
  )
}

///|
test "qwen quality good response" {
  let good = "先复盘失败原因，再拆解问题，用证据验证最小行动"
  let quality = @ghostvalley.qwen_assess_response(good)
  assert_true(quality.quality_hits >= 3)
  assert_true(quality.safety_hits == 0)
  assert_true(quality.repeat_ratio <= 0.35)
  assert_true(@ghostvalley.qwen_is_acceptable(quality))
  assert_eq(@ghostvalley.qwen_safe_response(good, "回退"), good)
}

///|
test "qwen safe response truncates long input" {
  let long = "反思复盘验证拆解行动证据团队情绪安全改进" +
    "反思复盘验证拆解行动证据团队情绪安全改进" +
    "反思复盘验证拆解行动证据团队情绪安全改进" +
    "反思复盘验证拆解行动证据团队情绪安全改进" +
    "反思复盘验证拆解行动证据团队情绪安全改进"
  let safe = @ghostvalley.qwen_safe_response(long, "回退")
  assert_true(safe.to_array().length() <= 80)
}

///|
test "qwen corpus quality summary" {
  let summary = @ghostvalley.qwen_corpus_quality_summary()
  assert_true(summary.contains("accepted="))
  assert_true(summary.contains("/12"))
  assert_true(summary.contains("avg_score="))
}

///|
test "qwen corpus has acceptable samples" {
  let mut accepted = 0
  for sample in @ghostvalley.qwen_samples {
    let quality = @ghostvalley.qwen_assess_response(sample.response)
    if @ghostvalley.qwen_is_acceptable(quality) {
      accepted = accepted + 1
    }
  }
  // 12 条原始语料中仅 3 条达到质量门槛；这是 0.5B 输出泛化的真实结论。
  assert_true(accepted >= 3)
}

///|
test "qwen strict gate falls back on low quality corpus" {
  let llm = @ghostvalley.QwenReplayLLM::new_strict()
  let fallback = @ghostvalley.QwenConfig::default().fallback
  let mut fallbacks = 0
  for sample in @ghostvalley.qwen_samples {
    let response = llm.generate_response(sample.dilemma)
    if response == fallback {
      fallbacks = fallbacks + 1
    }
  }
  assert_true(fallbacks >= 1)
}
