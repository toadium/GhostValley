// ============================================================
// Phase 1: 多智能体对比训练测试
// ============================================================

///|
test "compare_responses: 相同文本相似度为 1" {
  let s = @ghostvalley.compare_responses(
    "顿悟反思改进", "顿悟反思改进",
  )
  assert_eq(s, 1.0)
}

///|
test "compare_responses: 完全不同文本相似度为 0" {
  let s = @ghostvalley.compare_responses("普通日常", "压力训练")
  assert_eq(s, 0.0)
}

///|
test "compare_responses: 部分重叠在 0-1 之间" {
  let s = @ghostvalley.compare_responses(
    "顿悟反思改进", "顿悟反思修复",
  )
  assert_true(s > 0.0 && s < 1.0)
}

///|
test "compare_responses: 空文本返回 0" {
  let s = @ghostvalley.compare_responses("", "顿悟反思")
  assert_eq(s, 0.0)
}

///|
test "ComparativeResult: run_comparative_round 基本功能" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let llm_a = @ghostvalley.MockLLM::new()
  let llm_b = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  let result = gv.run_comparative_round(llm_a, llm_b)
  assert_true(result.dilemma.length() > 0)
  assert_true(result.response_a.length() > 0)
  assert_true(result.response_b.length() > 0)
  assert_true(result.similarity_score >= 0.0 && result.similarity_score <= 1.0)
  assert_true(
    result.winner == "A" || result.winner == "B" || result.winner == "tie",
  )
}

///|
test "run_comparative_round: 存储两个响应到记忆库" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let llm_a = @ghostvalley.MockLLM::new()
  let llm_b = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  let count_before = gv.memory_count()
  ignore(gv.run_comparative_round(llm_a, llm_b))
  let count_after = gv.memory_count()
  assert_true(count_after >= count_before + 1)
}

///|
test "run_comparative_pipeline: 批量对比训练" {
  let gv = @ghostvalley.new_engine(max_memory_num=100)
  let llm_a = @ghostvalley.MockLLM::new()
  let llm_b = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  let results = gv.run_comparative_pipeline(llm_a, llm_b, rounds=5)
  assert_eq(results.length(), 5)
  for r in results {
    assert_true(r.dilemma.length() > 0)
  }
}

///|
test "run_comparative_pipeline: 未开启返回空" {
  let gv = @ghostvalley.new_engine()
  let llm_a = @ghostvalley.MockLLM::new()
  let llm_b = @ghostvalley.MockLLM::new()
  let results = gv.run_comparative_pipeline(llm_a, llm_b, rounds=5)
  assert_eq(results.length(), 0)
}

///|
test "cross_pollinate: 导入高价值记忆" {
  let source = @ghostvalley.new_engine(max_memory_num=20)
  source.add_memory("顿悟反思改进修复迭代", is_simulation=false)
  source.add_memory("普通日常随便", is_simulation=false)
  let target = @ghostvalley.new_engine(max_memory_num=20)
  let count = @ghostvalley.cross_pollinate(target, source, top_n=1)
  assert_eq(count, 1)
  assert_eq(target.memory_count(), 1)
}

///|
test "cross_pollinate: top_n=0 导入 0 条" {
  let source = @ghostvalley.new_engine(max_memory_num=20)
  source.add_memory("顿悟反思", is_simulation=false)
  let target = @ghostvalley.new_engine(max_memory_num=20)
  let count = @ghostvalley.cross_pollinate(target, source, top_n=0)
  assert_eq(count, 0)
}

///|
test "cross_pollinate: 源为空导入 0 条" {
  let source = @ghostvalley.new_engine(max_memory_num=20)
  let target = @ghostvalley.new_engine(max_memory_num=20)
  let count = @ghostvalley.cross_pollinate(target, source, top_n=5)
  assert_eq(count, 0)
}

///|
test "MultiAgentSession: 创建和添加智能体" {
  let session = @ghostvalley.MultiAgentSession::new()
  assert_eq(session.agent_count(), 0)
  session.add_agent("alpha", @ghostvalley.new_engine(max_memory_num=20))
  session.add_agent("beta", @ghostvalley.new_engine(max_memory_num=20))
  assert_eq(session.agent_count(), 2)
}

///|
test "MultiAgentSession: 获取智能体" {
  let session = @ghostvalley.MultiAgentSession::new()
  let engine = @ghostvalley.new_engine(max_memory_num=20)
  engine.add_memory("测试记忆", is_simulation=false)
  session.add_agent("alpha", engine)
  match session.get_agent("alpha") {
    Some(e) => assert_eq(e.memory_count(), 1)
    None => assert_true(false)
  }
}

///|
test "MultiAgentSession: 获取不存在的智能体返回 None" {
  let session = @ghostvalley.MultiAgentSession::new()
  match session.get_agent("nonexistent") {
    Some(_) => assert_true(false)
    None => assert_true(true)
  }
}

///|
test "MultiAgentSession: agent_names 列出所有名称" {
  let session = @ghostvalley.MultiAgentSession::new()
  session.add_agent("alpha", @ghostvalley.new_engine())
  session.add_agent("beta", @ghostvalley.new_engine())
  session.add_agent("gamma", @ghostvalley.new_engine())
  let names = session.agent_names()
  assert_eq(names.length(), 3)
  assert_eq(names[0], "alpha")
  assert_eq(names[1], "beta")
  assert_eq(names[2], "gamma")
}

///|
test "MultiAgentSession: cross_learn_all 交叉学习" {
  let session = @ghostvalley.MultiAgentSession::new()
  let engine_a = @ghostvalley.new_engine(max_memory_num=30)
  engine_a.add_memory("顿悟反思改进修复迭代", is_simulation=false)
  let engine_b = @ghostvalley.new_engine(max_memory_num=30)
  engine_b.add_memory("冷静分析推理区分筛选", is_simulation=false)
  session.add_agent("alpha", engine_a)
  session.add_agent("beta", engine_b)
  // 交叉学习前，每个引擎 1 条记忆
  let results = session.cross_learn_all(top_n=1)
  assert_eq(results.length(), 2)
  // 每个引擎应导入 1 条来自对方的记忆
  let (_, count_a) = results[0]
  let (_, count_b) = results[1]
  assert_true(count_a >= 1)
  assert_true(count_b >= 1)
}

///|
test "MultiAgentSession: 单智能体交叉学习导入 0" {
  let session = @ghostvalley.MultiAgentSession::new()
  let engine = @ghostvalley.new_engine(max_memory_num=20)
  engine.add_memory("顿悟反思", is_simulation=false)
  session.add_agent("solo", engine)
  let results = session.cross_learn_all(top_n=1)
  let (_, count) = results[0]
  assert_eq(count, 0)
}

///|
test "ComparativeResult::format 输出正确" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  let llm_a = @ghostvalley.MockLLM::new()
  let llm_b = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  let result = gv.run_comparative_round(llm_a, llm_b)
  let s = result.format()
  assert_true(s.contains("困境"))
  assert_true(s.contains("A 响应"))
  assert_true(s.contains("B 响应"))
  assert_true(s.contains("相似度"))
  assert_true(s.contains("胜者"))
}

///|
test "对比训练后记忆库增长" {
  let gv = @ghostvalley.new_engine(max_memory_num=100)
  let llm_a = @ghostvalley.MockLLM::new()
  let llm_b = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  let count_before = gv.memory_count()
  ignore(gv.run_comparative_pipeline(llm_a, llm_b, rounds=5))
  let count_after = gv.memory_count()
  assert_true(count_after > count_before)
}
