///|
test "qwen corpus shape" {
  assert_eq(@ghostvalley.qwen_samples.length(), 12)
  let categories = ["cognitive", "emotional", "social", "operational"]
  for sample in @ghostvalley.qwen_samples {
    assert_true(sample.response.length() > 0)
    assert_true(sample.response.to_array().length() <= 120)
    assert_true(sample.latency_ms > 0)
    assert_true(sample.tokens > 0)
    assert_true(categories.contains(sample.category))
    assert_true(sample.difficulty >= 1 && sample.difficulty <= 3)
  }
}

///|
test "qwen replay exact match" {
  let llm = @ghostvalley.QwenReplayLLM::new()
  let response = llm.generate_response("你的工具突然不可用")
  match @ghostvalley.qwen_response_for("你的工具突然不可用") {
    Some(expected) => assert_eq(response, expected)
    None => fail("expected exact corpus match")
  }
  let (hits, misses) = llm.stats()
  assert_eq(hits, 1)
  assert_eq(misses, 0)
}

///|
test "qwen replay prefix prompt" {
  let llm = @ghostvalley.QwenReplayLLM::with_config({
    max_response_chars: 120,
    fallback: @ghostvalley.QwenConfig::default().fallback,
    match_threshold: 1.0,
    quality_gate: false,
  })
  let prompt = "前缀上下文：你的工具突然不可用"
  let response = llm.generate_response(prompt)
  match @ghostvalley.qwen_response_for("你的工具突然不可用") {
    Some(expected) => assert_eq(response, expected)
    None => fail("expected exact corpus match")
  }
  let (hits, misses) = llm.stats()
  assert_eq(hits, 1)
  assert_eq(misses, 0)
}

///|
test "qwen unknown prompt falls back" {
  let llm = @ghostvalley.QwenReplayLLM::new()
  let response = llm.generate_response("完全不相关的输入 xyz")
  assert_true(response.length() > 0)
  assert_eq(response, @ghostvalley.QwenConfig::default().fallback)
  let (hits, misses) = llm.stats()
  assert_eq(hits, 0)
  assert_eq(misses, 1)
}

///|
test "qwen hit rate and sample count" {
  let llm = @ghostvalley.QwenReplayLLM::new()
  assert_eq(llm.sample_count(), 12)
  let _ = llm.generate_response("你的努力被完全忽视")
  let _ = llm.generate_response("未知输入")
  assert_true(llm.hit_rate() > 0.0 && llm.hit_rate() < 1.0)
}

///|
test "qwen clean response" {
  assert_eq(@ghostvalley.qwen_clean_response("  a\n\n b\t c  ", 100), "a b c")
  assert_eq(@ghostvalley.qwen_clean_response("abcdef", 3), "abc")
  assert_eq(@ghostvalley.qwen_clean_response("abc", 0), "")
  assert_eq(@ghostvalley.qwen_clean_response("", 10), "")
}

///|
test "qwen eval summary" {
  let summary = @ghostvalley.qwen_eval_summary()
  assert_true(summary.contains("samples=12"))
  assert_true(summary.contains("avg_latency_ms="))
}

///|
test "qwen drives training pipeline" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  let llm = @ghostvalley.QwenReplayLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=6,
    decay_interval=3,
    cleanup_threshold=0.1,
  )
  assert_true(gv.memory_count() > 0)
  assert_eq(gv.get_training_stats().total_rounds_completed, 6)
  assert_true(gv.get_training_stats().total_memories_added >= 6)
}

///|
test "qwen match score" {
  assert_eq(
    @ghostvalley.qwen_match_score(
      "你的工具突然不可用", "你的工具突然不可用",
    ),
    1.0,
  )
  assert_true(
    @ghostvalley.qwen_match_score(
      "你的工具突然不可用", "你的团队不信任你的判断",
    ) <
    1.0,
  )
}
