///|
test "training_report initial" {
  let gv = @ghostvalley.new_engine()
  let report = gv.training_report()
  assert_eq(report.total_rounds, 0)
  assert_eq(report.total_memories, 0)
  assert_false(report.is_enabled)
}

///|
test "training_report after training" {
  let gv = @ghostvalley.new_engine()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.add_memory("顿悟", is_simulation=false)
  gv.add_memory("模拟", is_simulation=true)
  gv.add_memory("核心", is_simulation=false, is_core=true)
  ignore(gv.ghost_valley_run_one_round())
  let report = gv.training_report()
  assert_eq(report.total_rounds, 1)
  assert_eq(report.total_memories, 3)
  assert_eq(report.core_memories, 1)
  assert_eq(report.simulation_memories, 1)
  assert_eq(report.real_memories, 2)
  assert_true(report.is_enabled)
}

///|
test "training_report_json" {
  let gv = @ghostvalley.new_engine()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  let json_str = gv.training_report_json()
  assert_true(json_str.contains("total_rounds"))
  assert_true(json_str.contains("total_memories"))
}

///|
test "TrainingReport format" {
  let gv = @ghostvalley.new_engine()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.add_memory("测试", is_simulation=false)
  let report = gv.training_report()
  let output = report.format()
  assert_true(output.contains("幽灵谷训练报告"))
  assert_true(output.contains("训练轮次"))
  assert_true(output.contains("记忆总数"))
}

///|
test "training_report after rounds" {
  let gv = @ghostvalley.new_engine()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  let results = gv.ghost_valley_run_rounds(5)
  assert_eq(results.length(), 5)
  let report = gv.training_report()
  assert_eq(report.total_rounds, 5)
}
