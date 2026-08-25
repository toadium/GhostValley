///|
test "MockLLM new" {
  let llm = @ghostvalley.MockLLM::new()
  assert_eq(llm.response_pool.length(), 5)
}

///|
test "MockLLM generate_response failure" {
  let llm = @ghostvalley.MockLLM::new()
  let resp = llm.generate_response("任务执行全部失败")
  assert_true(resp.contains("冷静分析"))
}

///|
test "MockLLM generate_response negative" {
  let llm = @ghostvalley.MockLLM::new()
  let resp = llm.generate_response("收到大量负面反馈")
  assert_true(resp.contains("改进的信号"))
}

///|
test "MockLLM generate_response conflict" {
  let llm = @ghostvalley.MockLLM::new()
  let resp = llm.generate_response("新旧知识冲突")
  assert_true(resp.contains("验证"))
}

///|
test "MockLLM generate_response error" {
  let llm = @ghostvalley.MockLLM::new()
  let resp = llm.generate_response("出现错误")
  assert_true(resp.contains("学习"))
}

///|
test "run_round_with_llm disabled" {
  let gv = @ghostvalley.new_engine()
  let llm = @ghostvalley.MockLLM::new()
  let result = gv.run_round_with_llm(llm)
  assert_true(result is None)
}

///|
test "run_round_with_llm enabled" {
  let gv = @ghostvalley.new_engine()
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  let result = gv.run_round_with_llm(llm)
  assert_true(result is Some(_))
  assert_true(gv.memory_count() > 0)
}

///|
test "run_round_with_llm multiple rounds" {
  let gv = @ghostvalley.new_engine()
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  for _ in 0..<3 {
    ignore(gv.run_round_with_llm(llm))
  }
  assert_true(gv.memory_count() >= 3)
}
