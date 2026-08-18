///|
test "TrainingLog new is empty" {
  let log = @ghostvalley.TrainingLog::new()
  assert_eq(log.length(), 0)
}

///|
test "TrainingLog add_entry" {
  let log = @ghostvalley.TrainingLog::new()
  log.add_entry(1, "困境A", "响应A", 5)
  log.add_entry(2, "困境B", "响应B", 6)
  assert_eq(log.length(), 2)
}

///|
test "TrainingLog format output" {
  let log = @ghostvalley.TrainingLog::new()
  log.add_entry(1, "任务失败困境", "冷静分析响应", 1)
  let output = log.format()
  assert_true(output.contains("幽灵谷训练日志"))
  assert_true(output.contains("任务失败困境"))
  assert_true(output.contains("冷静分析响应"))
  assert_true(output.contains("第 1 轮"))
}

///|
test "TrainingLog to_json produces array" {
  let log = @ghostvalley.TrainingLog::new()
  log.add_entry(1, "困境A", "响应A", 3)
  log.add_entry(2, "困境B", "响应B", 4)
  let json = @json.to_json(log)
  let str = json.stringify()
  assert_true(str.contains("困境A"))
  assert_true(str.contains("困境B"))
}

///|
test "TrainingLogEntry struct fields" {
  let entry = @ghostvalley.TrainingLogEntry::{
    round_num: 1,
    dilemma: "测试困境",
    ai_response: "测试响应",
    memory_count_after: 5,
  }
  assert_eq(entry.round_num, 1)
  assert_eq(entry.dilemma, "测试困境")
  assert_eq(entry.ai_response, "测试响应")
  assert_eq(entry.memory_count_after, 5)
}

///|
test "run_round_with_llm logs automatically" {
  let gv = @ghostvalley.new_engine()
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  ignore(gv.run_round_with_llm(llm))
  ignore(gv.run_round_with_llm(llm))
  let log = gv.get_training_log()
  assert_eq(log.length(), 2)
}

///|
test "export_training_log_json" {
  let gv = @ghostvalley.new_engine()
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  ignore(gv.run_round_with_llm(llm))
  let json_str = gv.export_training_log_string()
  assert_true(
    json_str.contains("困境") ||
    json_str.contains("失败") ||
    json_str.contains("负面") ||
    json_str.contains("冲突") ||
    json_str.contains("崩盘"),
  )
}

///|
test "export_training_log_format" {
  let gv = @ghostvalley.new_engine()
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  ignore(gv.run_round_with_llm(llm))
  let output = gv.export_training_log_format()
  assert_true(output.contains("幽灵谷训练日志"))
  assert_true(output.contains("第 1 轮"))
}

///|
test "log_round manual logging" {
  let gv = @ghostvalley.new_engine()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  let dilemma = gv.ghost_valley_run_one_round()
  match dilemma {
    Some(d) => {
      gv.accept_ai_self_gain("手动顿悟响应")
      gv.log_round(d, "手动顿悟响应")
    }
    None => ()
  }
  let log = gv.get_training_log()
  assert_eq(log.length(), 1)
}
