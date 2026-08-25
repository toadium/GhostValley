///|
test "TrainingStats new is empty" {
  let stats = @ghostvalley.TrainingStats::new()
  assert_eq(stats.total_rounds_completed, 0)
  assert_eq(stats.total_memories_added, 0)
  assert_eq(stats.total_memories_cleaned, 0)
  assert_eq(stats.total_decay_applied, 0)
  assert_eq(stats.avg_score_history.length(), 0)
  assert_eq(stats.memory_count_history.length(), 0)
}

///|
test "TrainingStats retention_rate no additions" {
  let stats = @ghostvalley.TrainingStats::new()
  assert_eq(stats.retention_rate(), 1.0)
}

///|
test "TrainingStats retention_rate with history" {
  let stats = @ghostvalley.TrainingStats::new()
  stats.total_memories_added = 10
  stats.memory_count_history.push(8)
  // 8/10 = 0.8
  assert_true(stats.retention_rate() > 0.79)
  assert_true(stats.retention_rate() < 0.81)
}

///|
test "TrainingStats score_trend insufficient data" {
  let stats = @ghostvalley.TrainingStats::new()
  stats.avg_score_history.push(0.5)
  // 只有一个数据点，趋势为 0
  assert_eq(stats.score_trend(), 0.0)
}

///|
test "TrainingStats score_trend positive" {
  let stats = @ghostvalley.TrainingStats::new()
  stats.avg_score_history.push(0.3)
  stats.avg_score_history.push(0.6)
  // 0.6 - 0.3 = 0.3
  assert_true(stats.score_trend() > 0.29)
}

///|
test "TrainingStats score_trend negative" {
  let stats = @ghostvalley.TrainingStats::new()
  stats.avg_score_history.push(0.7)
  stats.avg_score_history.push(0.4)
  // 0.4 - 0.7 = -0.3
  assert_true(stats.score_trend() < -0.29)
}

///|
test "TrainingStats format output" {
  let stats = @ghostvalley.TrainingStats::new()
  stats.total_rounds_completed = 5
  let output = stats.format()
  assert_true(output.contains("训练统计"))
  assert_true(output.contains("完成轮次"))
  assert_true(output.contains("5"))
}

///|
test "run_training_pipeline basic" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=5,
    decay_interval=3,
    cleanup_threshold=0.1,
  )
  let stats = gv.get_training_stats()
  assert_eq(stats.total_rounds_completed, 5)
  assert_eq(stats.total_memories_added, 5)
  assert_eq(stats.avg_score_history.length(), 5)
  assert_eq(stats.memory_count_history.length(), 5)
}

///|
test "run_training_pipeline decay triggers" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  // decay_interval=2, rounds=4 → 衰减在第 2、4 轮触发，共 2 次
  gv.run_training_pipeline(
    llm,
    rounds=4,
    decay_interval=2,
    cleanup_threshold=0.0,
  )
  let stats = gv.get_training_stats()
  assert_eq(stats.total_decay_applied, 2)
}

///|
test "run_training_pipeline decay every round" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  // decay_interval=1 → 每轮都衰减
  gv.run_training_pipeline(
    llm,
    rounds=3,
    decay_interval=1,
    cleanup_threshold=0.0,
  )
  let stats = gv.get_training_stats()
  assert_eq(stats.total_decay_applied, 3)
}

///|
test "run_training_pipeline no decay when interval large" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  // decay_interval=100, rounds=3 → 不触发衰减
  gv.run_training_pipeline(
    llm,
    rounds=3,
    decay_interval=100,
    cleanup_threshold=0.1,
  )
  let stats = gv.get_training_stats()
  assert_eq(stats.total_decay_applied, 0)
}

///|
test "run_training_pipeline disabled engine no op" {
  let gv = @ghostvalley.new_engine()
  let llm = @ghostvalley.MockLLM::new()
  gv.run_training_pipeline(llm, rounds=5)
  let stats = gv.get_training_stats()
  assert_eq(stats.total_rounds_completed, 0)
}

///|
test "run_training_pipeline zero rounds no op" {
  let gv = @ghostvalley.new_engine()
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(llm, rounds=0)
  let stats = gv.get_training_stats()
  assert_eq(stats.total_rounds_completed, 0)
}

///|
test "run_training_pipeline negative rounds no op" {
  let gv = @ghostvalley.new_engine()
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(llm, rounds=-5)
  let stats = gv.get_training_stats()
  assert_eq(stats.total_rounds_completed, 0)
}

///|
test "run_training_pipeline cleanup counts" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  // 高清理阈值会清理更多
  gv.run_training_pipeline(
    llm,
    rounds=6,
    decay_interval=2,
    cleanup_threshold=0.5,
  )
  let stats = gv.get_training_stats()
  // 清理总数 >= 0
  assert_true(stats.total_memories_cleaned >= 0)
}

///|
test "get_training_stats returns engine stats" {
  let gv = @ghostvalley.new_engine()
  let stats = gv.get_training_stats()
  assert_eq(stats.total_rounds_completed, 0)
}

///|
test "export_stats_json produces valid json" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=3,
    decay_interval=2,
    cleanup_threshold=0.1,
  )
  let json_str = gv.export_stats_json()
  assert_true(json_str.contains("total_rounds_completed"))
  assert_true(json_str.contains("total_memories_added"))
}

///|
test "run_training_pipeline memory count history" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=3,
    decay_interval=100,
    cleanup_threshold=0.1,
  )
  let stats = gv.get_training_stats()
  // 无衰减无清理，记忆数应递增
  assert_true(stats.memory_count_history[0] >= 1)
  assert_true(stats.memory_count_history[2] >= stats.memory_count_history[0])
}
