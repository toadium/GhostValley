///|
test "event system covers callbacks, log and json" {
  let system = @ghostvalley.EventSystem::new()
  let seen : Array[String] = []
  system.register_callback("MemoryAdded", fn(detail, round) {
    seen.push(detail + "#" + round.to_string())
  })
  system.emit("MemoryAdded", 1, "alpha")
  system.emit("RoundCompleted", 2, "beta")
  assert_eq(system.get_log().length(), 2)
  assert_eq(system.event_count("MemoryAdded"), 1)
  assert_eq(system.event_count("Missing"), 0)
  assert_eq(seen.length(), 1)
  assert_true(seen[0].contains("alpha"))
  assert_true(system.to_json_string().contains("MemoryAdded"))
  assert_eq(@ghostvalley.TrainingEvent::MemoryAdded.to_string(), "MemoryAdded")
  assert_eq(
    @ghostvalley.TrainingEvent::MemoryForgotten.to_string(),
    "MemoryForgotten",
  )
  assert_eq(
    @ghostvalley.TrainingEvent::DecayApplied.to_string(),
    "DecayApplied",
  )
  assert_eq(@ghostvalley.TrainingEvent::CleanupDone.to_string(), "CleanupDone")
  assert_eq(
    @ghostvalley.TrainingEvent::RoundCompleted.to_string(),
    "RoundCompleted",
  )
}

///|
test "load_memory_string tolerates invalid JSON and partial entries" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.load_memory_string("not-json")
  assert_eq(gv.memory_count(), 0)
  let payload = "[{\"content\":\"缺字段\"},3,{\"content\":\"完整\",\"value_score\":0.5,\"is_simulation\":false,\"is_core_memory\":false,\"access_count\":2,\"linked_ids\":[[0,0.5],[1]]}]"
  gv.load_memory_string(payload)
  assert_eq(gv.memory_count(), 1)
  assert_eq(gv.memory_bank[0].content, "完整")
  assert_eq(gv.memory_bank[0].access_count, 2)
  assert_eq(gv.memory_bank[0].linked_ids.length(), 1)
}

///|
test "load_memory_string rejects non-array payload" {
  let gv = @ghostvalley.new_engine()
  gv.load_memory_string("{\"content\":\"对象\"}")
  assert_eq(gv.memory_count(), 0)
}

///|
test "resilience and evaluation on empty engine" {
  let gv = @ghostvalley.new_engine(max_memory_num=10)
  assert_eq(gv.resilience_score(), 0.0)
  let evaluation = gv.evaluate_training()
  assert_eq(evaluation.overall_grade, "D")
  assert_true(evaluation.format().contains("总体评级"))
  assert_true(gv.export_report_csv().contains("round"))
  assert_true(gv.export_full_report_markdown().contains("建议"))
}

///|
test "curriculum progress on empty and default curriculum" {
  let gv = @ghostvalley.new_engine(max_memory_num=10)
  let progress = gv.curriculum_progress(@ghostvalley.Curriculum::default())
  assert_true(progress.overall_completion >= 0.0)
  assert_true(progress.items.length() > 0)
  assert_true(progress.next_step.length() > 0)
}

///|
test "advanced stats small samples" {
  let (lower0, upper0) = @ghostvalley.confidence_interval([], 0.95)
  assert_eq(lower0, 0.0)
  assert_eq(upper0, 0.0)
  let (lower1, upper1) = @ghostvalley.confidence_interval([0.5], 0.95)
  assert_eq(lower1, 0.5)
  assert_eq(upper1, 0.5)
  let (lower2, upper2) = @ghostvalley.confidence_interval([0.2, 0.4, 0.6], 0.99)
  assert_true(lower2 < upper2)
  let empty = @ghostvalley.significance_test([], [0.5])
  assert_eq(empty.t_value, 0.0)
  assert_false(empty.is_significant)
  let single = @ghostvalley.significance_test([0.2], [0.8])
  assert_true(single.difference > 0.0)
}

///|
test "csv export tolerates shorter history arrays" {
  let gv = @ghostvalley.new_engine(max_memory_num=10)
  gv.training_stats.avg_score_history.push(0.5)
  let csv = gv.export_report_csv()
  assert_true(csv.contains("1,0.5,0,,"))
}
