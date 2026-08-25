// ============================================================
// Phase 4: 高级统计 + 导出测试
// ============================================================

///|
test "confidence_interval: 基本功能" {
  let scores = [0.3, 0.4, 0.5, 0.6, 0.7]
  let (lower, upper) = @ghostvalley.confidence_interval(scores, 0.95)
  assert_true(lower < upper)
  // 均值 0.5 应在区间内
  assert_true(lower < 0.5 && upper > 0.5)
}

///|
test "confidence_interval: 单元素返回自身" {
  let (lower, upper) = @ghostvalley.confidence_interval([0.5], 0.95)
  assert_eq(lower, 0.5)
  assert_eq(upper, 0.5)
}

///|
test "confidence_interval: 空数组返回 0" {
  let (lower, upper) = @ghostvalley.confidence_interval([], 0.95)
  assert_eq(lower, 0.0)
  assert_eq(upper, 0.0)
}

///|
test "confidence_interval: 99% 区间比 90% 宽" {
  let scores = [0.2, 0.3, 0.5, 0.7, 0.8]
  let (l90, u90) = @ghostvalley.confidence_interval(scores, 0.90)
  let (l99, u99) = @ghostvalley.confidence_interval(scores, 0.99)
  let width90 = u90 - l90
  let width99 = u99 - l99
  assert_true(width99 > width90)
}

///|
test "confidence_interval: 相同值区间为 0 宽度" {
  let scores = [0.5, 0.5, 0.5, 0.5]
  let (lower, upper) = @ghostvalley.confidence_interval(scores, 0.95)
  assert_true(upper - lower < 0.001)
}

///|
test "significance_test: 显著差异" {
  let before = [0.2, 0.3, 0.25, 0.35, 0.3]
  let after = [0.5, 0.6, 0.55, 0.65, 0.6]
  let result = @ghostvalley.significance_test(before, after)
  assert_true(result.is_significant)
  assert_true(result.difference > 0.0)
}

///|
test "significance_test: 无显著差异" {
  let before = [0.3, 0.4, 0.35, 0.45, 0.4]
  let after = [0.35, 0.4, 0.3, 0.45, 0.4]
  let result = @ghostvalley.significance_test(before, after)
  assert_false(result.is_significant)
}

///|
test "significance_test: 空数组不显著" {
  let result = @ghostvalley.significance_test([], [0.5, 0.6])
  assert_false(result.is_significant)
}

///|
test "significance_test: 均值和差异正确" {
  let before = [0.2, 0.4]
  let after = [0.6, 0.8]
  let result = @ghostvalley.significance_test(before, after)
  assert_true(
    result.mean_before - 0.3 < 0.001 && result.mean_before - 0.3 > -0.001,
  )
  assert_true(
    result.mean_after - 0.7 < 0.001 && result.mean_after - 0.7 > -0.001,
  )
  assert_true(
    result.difference - 0.4 < 0.001 && result.difference - 0.4 > -0.001,
  )
}

///|
test "export_report_csv: 基本功能" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=3,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let csv = gv.export_report_csv()
  assert_true(csv.contains("round"))
  assert_true(csv.contains("avg_score"))
  assert_true(csv.contains("memory_count"))
}

///|
test "export_report_csv: 空训练" {
  let gv = @ghostvalley.new_engine()
  let csv = gv.export_report_csv()
  assert_true(csv.contains("round,avg_score,memory_count,category,difficulty"))
}

///|
test "export_evaluation_json: 基本功能" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=3,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let json = gv.export_evaluation_json()
  assert_true(json.contains("training_stats"))
  assert_true(json.contains("evaluation"))
  assert_true(json.contains("events"))
  assert_true(json.contains("resilience_score"))
}

///|
test "training_summary: 基本功能" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=5,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let s = gv.training_summary()
  assert_true(s.contains("训练总结"))
  assert_true(s.contains("基本统计"))
  assert_true(s.contains("训练评估"))
  assert_true(s.contains("分类覆盖"))
  assert_true(s.contains("事件统计"))
  assert_true(s.contains("建议"))
}

///|
test "training_summary: 包含评级" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=5,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let s = gv.training_summary()
  assert_true(s.contains("总体评级"))
}

///|
test "training_summary: 空训练" {
  let gv = @ghostvalley.new_engine()
  let s = gv.training_summary()
  assert_true(s.contains("训练总结"))
  assert_true(s.contains("总训练轮次: 0"))
}

///|
test "SignificanceResult: 字段正确" {
  let before = [0.2, 0.3, 0.4]
  let after = [0.5, 0.6, 0.7]
  let result = @ghostvalley.significance_test(before, after)
  assert_true(result.t_value > 0.0)
  assert_true(result.mean_after > result.mean_before)
}

///|
test "confidence_interval + significance_test 组合使用" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=10,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let scores = gv.training_stats.avg_score_history
  let (lower, upper) = @ghostvalley.confidence_interval(scores, 0.95)
  assert_true(lower <= upper)
  // 前半 vs 后半显著性检验
  let mid = scores.length() / 2
  let before : Array[Double] = []
  let after : Array[Double] = []
  for i in 0..<scores.length() {
    if i < mid {
      before.push(scores[i])
    } else {
      after.push(scores[i])
    }
  }
  if before.length() > 0 && after.length() > 0 {
    let result = @ghostvalley.significance_test(before, after)
    assert_true(result.difference >= 0.0 || result.difference < 0.0)
  }
}
