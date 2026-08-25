// ============================================================
// Phase 3: 训练检查点 + 回放测试
// ============================================================

///|
test "TrainingCheckpoint: save_checkpoint 基本功能" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=5,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let cp = gv.save_checkpoint()
  assert_eq(cp.completed_rounds, 5)
  assert_true(cp.engine_state.length() > 0)
}

///|
test "TrainingCheckpoint: 空引擎检查点" {
  let gv = @ghostvalley.new_engine()
  let cp = gv.save_checkpoint()
  assert_eq(cp.completed_rounds, 0)
}

///|
test "load_checkpoint: 恢复引擎状态" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=3,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let memory_count = gv.memory_count()
  let cp = gv.save_checkpoint()
  let gv2 = @ghostvalley.new_engine(max_memory_num=50)
  gv2.load_checkpoint(cp)
  assert_eq(gv2.total_rounds, 3)
  assert_eq(gv2.memory_count(), memory_count)
}

///|
test "load_checkpoint: 恢复后记忆内容一致" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  gv.add_memory("顿悟反思改进", is_simulation=false)
  gv.add_memory("普通日常", is_simulation=false)
  let cp = gv.save_checkpoint()
  let gv2 = @ghostvalley.new_engine(max_memory_num=50)
  gv2.load_checkpoint(cp)
  assert_eq(gv2.memory_count(), 2)
  assert_eq(gv2.memory_bank[0].content, "顿悟反思改进")
  assert_eq(gv2.memory_bank[1].content, "普通日常")
}

///|
test "resume_training: 断点续训轮次正确" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=3,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let cp = gv.save_checkpoint()
  let gv2 = @ghostvalley.new_engine(max_memory_num=50)
  gv2.resume_training(
    cp,
    llm,
    additional_rounds=2,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  assert_eq(gv2.total_rounds, 5)
}

///|
test "resume_training: 续训后记忆增加" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=3,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let cp = gv.save_checkpoint()
  let count_before = cp.completed_rounds
  let gv2 = @ghostvalley.new_engine(max_memory_num=50)
  gv2.resume_training(
    cp,
    llm,
    additional_rounds=3,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  assert_true(gv2.total_rounds > count_before)
}

///|
test "resume_training: 续训 0 轮不改变状态" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=3,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let cp = gv.save_checkpoint()
  let gv2 = @ghostvalley.new_engine(max_memory_num=50)
  gv2.resume_training(
    cp,
    llm,
    additional_rounds=0,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  assert_eq(gv2.total_rounds, 3)
}

///|
test "replay_training: 基本回放" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=5,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let log = gv.training_log
  let gv2 = @ghostvalley.new_engine(max_memory_num=50)
  ignore(gv2.wen_shi_verify("愿意接受挑战，接受压力训练"))
  let result = gv2.replay_training(log, llm)
  assert_eq(result.original_rounds, 5)
  assert_eq(result.replayed_rounds, 5)
}

///|
test "replay_training: 回放后记忆增加" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=5,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let log = gv.training_log
  let gv2 = @ghostvalley.new_engine(max_memory_num=50)
  ignore(gv2.wen_shi_verify("愿意接受挑战，接受压力训练"))
  ignore(gv2.replay_training(log, llm))
  assert_true(gv2.memory_count() > 0)
}

///|
test "replay_training: 使用新评分配置" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=3,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let log = gv.training_log
  let gv2 = @ghostvalley.new_engine(max_memory_num=50)
  ignore(gv2.wen_shi_verify("愿意接受挑战，接受压力训练"))
  let new_config : @ghostvalley.ScoringConfig = {
    high_value_words: ["勇气", "坚持", "顿悟"],
    mid_value_words: ["反思"],
    low_value_words: [],
    high_value_bonus: 0.2,
    mid_value_bonus: 0.1,
    low_value_penalty: 0.0,
    base_score: 0.2,
    multi_high_bonus: 0.1,
    multi_mid_bonus: 0.05,
    multi_low_penalty: 0.0,
  }
  let result = gv2.replay_training(log, llm, new_scoring_config=new_config)
  assert_eq(result.replayed_rounds, 3)
  // 新配置应生效
  assert_true(gv2.scoring_config.high_value_words[0] == "勇气")
}

///|
test "replay_training: 使用新衰减模型" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=3,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let log = gv.training_log
  let gv2 = @ghostvalley.new_engine(max_memory_num=50)
  ignore(gv2.wen_shi_verify("愿意接受挑战，接受压力训练"))
  let result = gv2.replay_training(
    log,
    llm,
    new_decay_model=@ghostvalley.Linear,
  )
  assert_eq(result.replayed_rounds, 3)
  assert_eq(gv2.decay_model, @ghostvalley.Linear)
}

///|
test "replay_training: 空日志回放" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  let log = gv.training_log
  let result = gv.replay_training(log, llm)
  assert_eq(result.original_rounds, 0)
  assert_eq(result.replayed_rounds, 0)
}

///|
test "ReplayResult::format 输出正确" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=3,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let log = gv.training_log
  let gv2 = @ghostvalley.new_engine(max_memory_num=50)
  ignore(gv2.wen_shi_verify("愿意接受挑战，接受压力训练"))
  let result = gv2.replay_training(log, llm)
  let s = result.format()
  assert_true(s.contains("回放结果"))
  assert_true(s.contains("原训练轮次"))
  assert_true(s.contains("回放轮次"))
  assert_true(s.contains("分数差异"))
}

///|
test "检查点序列: 保存-恢复-再训练-再保存" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=2,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let cp1 = gv.save_checkpoint()
  let gv2 = @ghostvalley.new_engine(max_memory_num=50)
  gv2.resume_training(
    cp1,
    llm,
    additional_rounds=3,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let cp2 = gv2.save_checkpoint()
  assert_eq(cp2.completed_rounds, 5)
  let gv3 = @ghostvalley.new_engine(max_memory_num=50)
  gv3.resume_training(
    cp2,
    llm,
    additional_rounds=2,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  assert_eq(gv3.total_rounds, 7)
}

///|
test "TrainingCheckpoint: ToJson 序列化正确" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  gv.add_memory("顿悟反思", is_simulation=false)
  let cp = gv.save_checkpoint()
  let json = cp.to_json()
  assert_true(json.to_string().contains("completed_rounds"))
}
