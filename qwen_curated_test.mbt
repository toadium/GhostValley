///|
test "qwen curated corpus size and quality" {
  assert_eq(@ghostvalley.qwen_curated_samples.length(), 24)
  let mut accepted = 0
  for sample in @ghostvalley.qwen_curated_samples {
    assert_true(sample.response.length() > 0)
    let quality = @ghostvalley.qwen_assess_response(sample.response)
    if @ghostvalley.qwen_is_acceptable(quality) {
      accepted = accepted + 1
    }
  }
  // 从 144 次评测中筛选后，24 条中 23 条达到质量门槛（原始 12 条仅 3 条）。
  assert_true(accepted >= 20)
}

///|
test "qwen curated replay exact match" {
  let llm = @ghostvalley.QwenReplayLLM::new_curated()
  assert_eq(llm.sample_count(), 24)
  let sample = @ghostvalley.qwen_curated_samples[0]
  let response = llm.generate_response(sample.dilemma)
  assert_eq(response, sample.response)
}

///|
test "qwen curated strict fallbacks are low" {
  let llm = @ghostvalley.QwenReplayLLM::new_curated()
  let fallback = @ghostvalley.QwenConfig::default().fallback
  let mut fallbacks = 0
  for sample in @ghostvalley.qwen_curated_samples {
    if llm.generate_response(sample.dilemma) == fallback {
      fallbacks = fallbacks + 1
    }
  }
  assert_true(fallbacks <= 2)
}

///|
test "qwen curated quality summary" {
  let summary = @ghostvalley.qwen_curated_quality_summary()
  assert_true(summary.contains("accepted="))
  assert_true(summary.contains("/24"))
  assert_true(summary.contains("avg_score="))
}

///|
test "qwen curated drives training pipeline" {
  let gv = @ghostvalley.new_engine(max_memory_num=40)
  let llm = @ghostvalley.QwenReplayLLM::new_curated()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=8,
    decay_interval=4,
    cleanup_threshold=0.1,
  )
  assert_eq(gv.get_training_stats().total_rounds_completed, 8)
  assert_true(gv.memory_count() > 0)
}
