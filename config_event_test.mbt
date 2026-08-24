// ============================================================
// Phase 3: 可配置评分 + 事件系统 + 可配置衰减测试
// ============================================================

///|
test "ScoringConfig::default 与原硬编码一致" {
  // 默认配置应产生与原 text_value_score 相同的结果
  let config = @ghostvalley.ScoringConfig::default()
  let score1 = @ghostvalley.configurable_text_value_score(
    "顿悟反思改进", config,
  )
  let score2 = @ghostvalley.text_value_score("顿悟反思改进")
  assert_true(score1 - score2 < 0.0001 && score1 - score2 > -0.0001)
}

///|
test "configurable_text_value_score: 自定义高价值关键词" {
  let config : @ghostvalley.ScoringConfig = {
    high_value_words: ["勇气", "坚持"],
    mid_value_words: [],
    low_value_words: [],
    high_value_bonus: 0.3,
    mid_value_bonus: 0.0,
    low_value_penalty: 0.0,
    base_score: 0.1,
    multi_high_bonus: 0.0,
    multi_mid_bonus: 0.0,
    multi_low_penalty: 0.0,
  }
  let score = @ghostvalley.configurable_text_value_score(
    "勇气和坚持", config,
  )
  // base 0.1 + 0.3 + 0.3 = 0.7
  assert_true(score > 0.69 && score < 0.71)
}

///|
test "configurable_text_value_score: 自定义低价值关键词减分" {
  let config : @ghostvalley.ScoringConfig = {
    high_value_words: [],
    mid_value_words: [],
    low_value_words: ["废话", "无意义"],
    high_value_bonus: 0.0,
    mid_value_bonus: 0.0,
    low_value_penalty: 0.2,
    base_score: 0.5,
    multi_high_bonus: 0.0,
    multi_mid_bonus: 0.0,
    multi_low_penalty: 0.0,
  }
  let score = @ghostvalley.configurable_text_value_score(
    "废话无意义", config,
  )
  // base 0.5 - 0.2 - 0.2 - 0.0 (multi_low_penalty=0) = 0.1
  assert_true(score > 0.09 && score < 0.11)
}

///|
test "configurable_text_value_score: clamp 到 [0.05, 0.95]" {
  let config : @ghostvalley.ScoringConfig = {
    high_value_words: [],
    mid_value_words: [],
    low_value_words: ["降分"],
    high_value_bonus: 0.0,
    mid_value_bonus: 0.0,
    low_value_penalty: 1.0,
    base_score: 0.1,
    multi_high_bonus: 0.0,
    multi_mid_bonus: 0.0,
    multi_low_penalty: 0.0,
  }
  let score = @ghostvalley.configurable_text_value_score("降分", config)
  assert_eq(score, 0.05)
}

///|
test "引擎使用自定义评分配置" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  let config : @ghostvalley.ScoringConfig = {
    high_value_words: ["勇气"],
    mid_value_words: [],
    low_value_words: [],
    high_value_bonus: 0.5,
    mid_value_bonus: 0.0,
    low_value_penalty: 0.0,
    base_score: 0.1,
    multi_high_bonus: 0.0,
    multi_mid_bonus: 0.0,
    multi_low_penalty: 0.0,
  }
  gv.set_scoring_config(config)
  gv.add_memory("勇气可嘉", is_simulation=false)
  // base 0.1 + 0.5 = 0.6 + noise
  assert_true(gv.memory_bank[0].value_score > 0.5)
}

///|
test "DecayModel: Hyperbolic 与原行为一致" {
  let gv = @ghostvalley.new_engine()
  gv.add_memory("普通记忆", is_simulation=false)
  let score_before = gv.memory_bank[0].value_score
  gv.set_decay_model(@ghostvalley.Hyperbolic)
  gv.apply_decay(10)
  let score_after = gv.memory_bank[0].value_score
  assert_true(score_after < score_before)
}

///|
test "DecayModel: Linear 衰减" {
  let gv = @ghostvalley.new_engine()
  gv.add_memory("普通记忆", is_simulation=false)
  let score_before = gv.memory_bank[0].value_score
  gv.set_decay_model(@ghostvalley.Linear)
  gv.apply_decay(10)
  let score_after = gv.memory_bank[0].value_score
  // Linear: score * (1 - 10 * 0.02) = score * 0.8
  assert_true(score_after < score_before)
  let expected = score_before * 0.8
  assert_true(score_after - expected < 0.001 && score_after - expected > -0.001)
}

///|
test "DecayModel: Exponential 衰减" {
  let gv = @ghostvalley.new_engine()
  gv.add_memory("普通记忆", is_simulation=false)
  let score_before = gv.memory_bank[0].value_score
  gv.set_decay_model(@ghostvalley.Exponential)
  gv.apply_decay(10)
  let score_after = gv.memory_bank[0].value_score
  // Exponential: score * 0.95^10
  assert_true(score_after < score_before)
  // 0.95^10 ≈ 0.5987
  let expected = score_before * 0.5987
  assert_true(score_after - expected < 0.01 && score_after - expected > -0.01)
}

///|
test "DecayModel: 不同模型产生不同结果" {
  let gv1 = @ghostvalley.new_engine()
  gv1.add_memory("普通记忆内容", is_simulation=false)
  let gv2 = @ghostvalley.new_engine()
  gv2.add_memory("普通记忆内容", is_simulation=false)
  let gv3 = @ghostvalley.new_engine()
  gv3.add_memory("普通记忆内容", is_simulation=false)
  // 确保初始分数一致
  gv1.memory_bank[0].value_score = 0.5
  gv2.memory_bank[0].value_score = 0.5
  gv3.memory_bank[0].value_score = 0.5
  gv1.set_decay_model(@ghostvalley.Hyperbolic)
  gv2.set_decay_model(@ghostvalley.Linear)
  gv3.set_decay_model(@ghostvalley.Exponential)
  gv1.apply_decay(20)
  gv2.apply_decay(20)
  gv3.apply_decay(20)
  let s1 = gv1.memory_bank[0].value_score
  let s2 = gv2.memory_bank[0].value_score
  let s3 = gv3.memory_bank[0].value_score
  // 三种模型应产生不同结果
  assert_true(s1 != s2 || s1 != s3)
}

///|
test "DecayModel: 核心记忆不受衰减影响" {
  let gv = @ghostvalley.new_engine()
  gv.add_memory("核心记忆", is_simulation=false, is_core=true)
  let score_before = gv.memory_bank[0].value_score
  gv.set_decay_model(@ghostvalley.Linear)
  gv.apply_decay(10)
  assert_eq(gv.memory_bank[0].value_score, score_before)
}

///|
test "事件系统: 训练管道触发 MemoryAdded 事件" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=5,
    decay_interval=2,
    cleanup_threshold=0.1,
  )
  assert_true(gv.event_count("MemoryAdded") == 5)
}

///|
test "事件系统: 训练管道触发 RoundCompleted 事件" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=5,
    decay_interval=2,
    cleanup_threshold=0.1,
  )
  assert_true(gv.event_count("RoundCompleted") == 5)
}

///|
test "事件系统: 训练管道触发 DecayApplied 事件" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=10,
    decay_interval=2,
    cleanup_threshold=0.1,
  )
  // 10 轮，每 2 轮衰减一次 = 5 次
  assert_true(gv.event_count("DecayApplied") == 5)
}

///|
test "事件系统: 回调被正确调用" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  // 注册回调，记录调用次数
  let mut call_count = 0
  gv.register_callback("MemoryAdded", fn(_detail, _round) {
    call_count = call_count + 1
  })
  gv.run_training_pipeline(
    llm,
    rounds=3,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  assert_true(call_count == 3)
}

///|
test "事件系统: 事件日志可获取" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=3,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let log = gv.get_event_log()
  assert_true(log.length() >= 6) // 3 MemoryAdded + 3 RoundCompleted
}

///|
test "事件系统: 无训练无事件" {
  let gv = @ghostvalley.new_engine()
  assert_eq(gv.get_event_log().length(), 0)
}

///|
test "事件系统: event_count 不存在的类型返回 0" {
  let gv = @ghostvalley.new_engine()
  assert_eq(gv.event_count("NonExistent"), 0)
}

///|
test "DecayParams: 自定义参数" {
  let gv = @ghostvalley.new_engine()
  gv.add_memory("普通记忆", is_simulation=false)
  let score_before = gv.memory_bank[0].value_score
  let params : @ghostvalley.DecayParams = {
    linear_rate: 0.05,
    exp_decay_base: 0.9,
  }
  gv.set_decay_params(params)
  gv.set_decay_model(@ghostvalley.Linear)
  gv.apply_decay(10)
  let score_after = gv.memory_bank[0].value_score
  // Linear: score * (1 - 10 * 0.05) = score * 0.5
  let expected = score_before * 0.5
  assert_true(score_after - expected < 0.001 && score_after - expected > -0.001)
}

///|
test "ScoringConfig: 空关键词列表" {
  let config : @ghostvalley.ScoringConfig = {
    high_value_words: [],
    mid_value_words: [],
    low_value_words: [],
    high_value_bonus: 0.12,
    mid_value_bonus: 0.06,
    low_value_penalty: 0.08,
    base_score: 0.3,
    multi_high_bonus: 0.1,
    multi_mid_bonus: 0.05,
    multi_low_penalty: 0.1,
  }
  let score = @ghostvalley.configurable_text_value_score("任意内容", config)
  assert_eq(score, 0.3)
}

///|
test "TrainingEvent::to_string 正确" {
  assert_eq(@ghostvalley.MemoryAdded.to_string(), "MemoryAdded")
  assert_eq(@ghostvalley.MemoryForgotten.to_string(), "MemoryForgotten")
  assert_eq(@ghostvalley.DecayApplied.to_string(), "DecayApplied")
  assert_eq(@ghostvalley.CleanupDone.to_string(), "CleanupDone")
  assert_eq(@ghostvalley.RoundCompleted.to_string(), "RoundCompleted")
}
