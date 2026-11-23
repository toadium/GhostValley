///|
test "protocol medium/warning audit branches" {
  let log = @ghostvalley.AuditLog::new()
  log.add_entry(
    timestamp=1,
    action="manual",
    actor="tester",
    detail="medium",
    risk_level=Medium,
  )
  assert_true(log.export_csv().contains("Medium"))
  let protocol = @ghostvalley.TrainingProtocol::default()
  let stressed = @ghostvalley.EmotionState::initial()
  stressed.stress_level = 0.9
  stressed.confidence = 0.1
  assert_false(@ghostvalley.enforce_protocol(protocol, stressed, 0, log, 2))
  let warning = @ghostvalley.EmotionState::initial()
  let warning_log = @ghostvalley.AuditLog::new()
  assert_true(
    @ghostvalley.enforce_protocol(protocol, warning, 15, warning_log, 3),
  )
  assert_true(warning_log.export_csv().contains("High"))
}

///|
test "ghost valley caps getters and dedup clamps" {
  let gv = @ghostvalley.new_engine(max_memory_num=10)
  let score = gv.wen_shi_verify(
    "愿意接受挑战，接受压力训练，顿悟反思改进，修复迭代，冷静分析",
  )
  ignore(score)
  ignore(gv.get_scoring_config())
  ignore(gv.get_decay_model())
  ignore(gv.get_decay_params())
  ignore(gv.get_event_system())

  let low = @ghostvalley.new_engine(max_memory_num=10)
  low.add_memory("顿悟反思改进", is_simulation=false)
  low.memory_bank[0].value_score = 0.0
  assert_false(
    low.add_memory_dedup(
      "顿悟反思改进",
      is_simulation=false,
      similarity_threshold=0.1,
    ),
  )
  assert_true(low.memory_bank[0].value_score >= 0.05)

  let high = @ghostvalley.new_engine(max_memory_num=10)
  high.add_memory("顿悟反思改进", is_simulation=false)
  high.memory_bank[0].value_score = 1.0
  assert_false(
    high.add_memory_dedup(
      "顿悟反思改进",
      is_simulation=false,
      similarity_threshold=0.1,
    ),
  )
  assert_eq(high.memory_bank[0].value_score, 0.95)

  let merged = @ghostvalley.new_engine(max_memory_num=10)
  merged.add_memory("A", is_simulation=false)
  merged.add_memory("B", is_simulation=false)
  merged.memory_bank[0].linked_ids.push((1, 0.5))
  merged.memory_bank[1].linked_ids.push((0, 0.5))
  merged.merge_memories(0, 1)
  assert_true(merged.memory_bank[0].linked_ids.length() >= 1)
}

///|
test "dashboard bars and report branches" {
  let bars = @ghostvalley.generate_ascii_bar(
    [{ label: "负", value: -1.0, }, { label: "超", value: 2.0, }],
    title="边界",
  )
  assert_true(bars.contains("边界"))
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("核心", is_simulation=false, is_core=true)
  gv.add_memory("模拟", is_simulation=true)
  gv.training_stats.round_difficulty_history.push(1)
  gv.training_stats.round_difficulty_history.push(3)
  gv.training_stats.avg_score_history.push(0.4)
  gv.training_stats.avg_score_history.push(0.5)
  for category in ["cognitive", "emotional", "social", "operational"] {
    gv.training_stats.round_category_history.push(category)
  }
  let dashboard = gv.render_dashboard()
  assert_true(dashboard.format().contains("记忆分布"))
  let report = gv.export_full_report_markdown()
  assert_true(report.contains("[核心]"))
  assert_true(report.contains("[模拟]"))
  assert_true(report.contains("韧性分良好"))
  assert_true(report.contains("分类覆盖均衡"))
}
