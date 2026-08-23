// ============================================================
// Phase 1: 训练评估测试
// ============================================================

///|
test "resilience_score: 无训练数据返回 0" {
  let gv = @ghostvalley.new_engine()
  assert_eq(gv.resilience_score(), 0.0)
}

///|
test "resilience_score: 训练后返回有效值" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=20,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let r = gv.resilience_score()
  assert_true(r >= 0.0)
}

///|
test "resilience_score: 仅低难度训练返回 0" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  // 手动设置只有难度 1 的历史
  for _ in 0..<5 {
    gv.add_memory("顿悟反思改进", is_simulation=false)
    gv.training_stats.round_difficulty_history.push(1)
    gv.training_stats.round_category_history.push("cognitive")
    gv.training_stats.avg_score_history.push(gv.average_value_score())
  }
  // 无高难度数据，韧性分应为 0
  assert_eq(gv.resilience_score(), 0.0)
}

///|
test "category_coverage: 无训练返回全零" {
  let gv = @ghostvalley.new_engine()
  let coverages = gv.category_coverage()
  assert_eq(coverages.length(), 4)
  for c in coverages {
    assert_eq(c.rounds, 0)
    assert_eq(c.percentage, 0.0)
  }
}

///|
test "category_coverage: 训练后覆盖正确" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=20,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let coverages = gv.category_coverage()
  assert_eq(coverages.length(), 4)
  // 总轮次应等于 20
  let mut total = 0
  for c in coverages {
    total = total + c.rounds
  }
  assert_eq(total, 20)
  // 百分比之和应约为 1.0
  let mut pct_sum = 0.0
  for c in coverages {
    pct_sum = pct_sum + c.percentage
  }
  assert_true(pct_sum > 0.99 && pct_sum < 1.01)
}

///|
test "category_coverage: 分类名称正确" {
  let gv = @ghostvalley.new_engine()
  let coverages = gv.category_coverage()
  assert_eq(coverages[0].category, "cognitive")
  assert_eq(coverages[1].category, "emotional")
  assert_eq(coverages[2].category, "social")
  assert_eq(coverages[3].category, "operational")
}

///|
test "improvement_rate: 无数据返回 0" {
  let gv = @ghostvalley.new_engine()
  assert_eq(gv.improvement_rate(), 0.0)
}

///|
test "improvement_rate: 单轮数据返回 0" {
  let gv = @ghostvalley.new_engine()
  gv.training_stats.avg_score_history.push(0.5)
  assert_eq(gv.improvement_rate(), 0.0)
}

///|
test "improvement_rate: 上升趋势为正" {
  let gv = @ghostvalley.new_engine()
  // 模拟分数上升
  gv.training_stats.avg_score_history.push(0.1)
  gv.training_stats.avg_score_history.push(0.2)
  gv.training_stats.avg_score_history.push(0.3)
  gv.training_stats.avg_score_history.push(0.4)
  let rate = gv.improvement_rate()
  assert_true(rate > 0.0)
}

///|
test "improvement_rate: 下降趋势为负" {
  let gv = @ghostvalley.new_engine()
  gv.training_stats.avg_score_history.push(0.4)
  gv.training_stats.avg_score_history.push(0.3)
  gv.training_stats.avg_score_history.push(0.2)
  gv.training_stats.avg_score_history.push(0.1)
  let rate = gv.improvement_rate()
  assert_true(rate < 0.0)
}

///|
test "improvement_rate: 稳定趋势为 0" {
  let gv = @ghostvalley.new_engine()
  gv.training_stats.avg_score_history.push(0.5)
  gv.training_stats.avg_score_history.push(0.5)
  gv.training_stats.avg_score_history.push(0.5)
  let rate = gv.improvement_rate()
  assert_true(rate < 0.0001 && rate > -0.0001)
}

///|
test "evaluate_training: 无训练返回 D 级" {
  let gv = @ghostvalley.new_engine()
  let eval = gv.evaluate_training()
  assert_eq(eval.overall_grade, "D")
  assert_eq(eval.total_rounds, 0)
}

///|
test "evaluate_training: 训练后返回有效评估" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=20,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let eval = gv.evaluate_training()
  // 评级应为 S/A/B/C/D 之一
  assert_true(
    eval.overall_grade == "S" ||
    eval.overall_grade == "A" ||
    eval.overall_grade == "B" ||
    eval.overall_grade == "C" ||
    eval.overall_grade == "D",
  )
  assert_eq(eval.total_rounds, 20)
  assert_eq(eval.category_coverages.length(), 4)
}

///|
test "evaluate_training: 评级边界 S" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  // 手动构造满足 S 级条件的数据
  // 韧性 >= 0.9, 改善率 > 0, 4 分类全覆盖
  for i in 0..<4 {
    gv.add_memory("顿悟反思改进修复迭代", is_simulation=false)
    gv.training_stats.round_difficulty_history.push(if i < 2 { 1 } else { 3 })
    gv.training_stats.round_category_history.push(
      ["cognitive", "emotional", "social", "operational"][i],
    )
    gv.training_stats.avg_score_history.push(0.5 + i.to_double() * 0.05)
  }
  gv.training_stats.total_rounds_completed = 4
  let eval = gv.evaluate_training()
  // 韧性分 = 高难度平均 / 低难度平均
  // 高难度 (diff=3): score 0.6, 0.65 → avg = 0.625
  // 低难度 (diff=1): score 0.5, 0.55 → avg = 0.525
  // resilience = 0.625 / 0.525 ≈ 1.19 >= 0.9 ✓
  // improvement > 0 (上升趋势) ✓
  // 4 分类全覆盖 ✓
  assert_eq(eval.overall_grade, "S")
}

///|
test "evaluate_training: 评级边界 D" {
  let gv = @ghostvalley.new_engine()
  let eval = gv.evaluate_training()
  assert_eq(eval.overall_grade, "D")
}

///|
test "TrainingEvaluation::format 输出正确" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=10,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let eval = gv.evaluate_training()
  let s = eval.format()
  assert_true(s.contains("训练评估报告"))
  assert_true(s.contains("总体评级"))
  assert_true(s.contains("韧性分"))
  assert_true(s.contains("分类覆盖"))
}

///|
test "训练管道追踪困境分类和难度" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=10,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let stats = gv.get_training_stats()
  assert_eq(stats.round_difficulty_history.length(), 10)
  assert_eq(stats.round_category_history.length(), 10)
  // 每个难度应在 1-3 范围内
  for d in stats.round_difficulty_history {
    assert_true(d >= 1 && d <= 3)
  }
  // 每个分类应为有效分类
  let valid_cats = ["cognitive", "emotional", "social", "operational"]
  for c in stats.round_category_history {
    assert_true(valid_cats.contains(c))
  }
}

///|
test "引擎状态保存/恢复包含评估数据" {
  let gv1 = @ghostvalley.new_engine(max_memory_num=50)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv1.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv1.run_training_pipeline(
    llm,
    rounds=10,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let state = gv1.save_engine_state()
  let gv2 = @ghostvalley.new_engine()
  gv2.load_engine_state(state)
  // 恢复后评估数据应一致
  let eval1 = gv1.evaluate_training()
  let eval2 = gv2.evaluate_training()
  assert_eq(eval1.total_rounds, eval2.total_rounds)
  assert_eq(
    eval1.category_coverages.length(),
    eval2.category_coverages.length(),
  )
}
