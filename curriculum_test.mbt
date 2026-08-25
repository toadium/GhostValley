// ============================================================
// Phase 4: 训练课程体系测试
// ============================================================

///|
test "Curriculum::default: 12 个要求 4 分类" {
  let c = @ghostvalley.Curriculum::default()
  assert_eq(c.requirements.length(), 12)
  assert_eq(c.prerequisites.length(), 2)
}

///|
test "curriculum_progress: 无训练时全零" {
  let gv = @ghostvalley.new_engine()
  let c = @ghostvalley.Curriculum::default()
  let progress = gv.curriculum_progress(c)
  assert_eq(progress.overall_completion, 0.0)
  assert_true(progress.next_step.length() > 0)
}

///|
test "curriculum_progress: 部分训练后进度增加" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let llm = @ghostvalley.MockLLM::new()
  let c = @ghostvalley.Curriculum::default()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_curriculum_pipeline(
    llm,
    c,
    rounds=12,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let progress = gv.curriculum_progress(c)
  assert_true(progress.overall_completion > 0.0)
}

///|
test "curriculum_progress: 完成全部要求后 100%" {
  let gv = @ghostvalley.new_engine(max_memory_num=100)
  let llm = @ghostvalley.MockLLM::new()
  let c = @ghostvalley.Curriculum::default()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  // 12 要求 × 2 轮 = 24 轮足够完成
  gv.run_curriculum_pipeline(
    llm,
    c,
    rounds=30,
    decay_interval=10,
    cleanup_threshold=0.01,
  )
  let progress = gv.curriculum_progress(c)
  assert_true(progress.overall_completion > 0.9)
}

///|
test "curriculum_next_dilemma: 优先选未满足的分类" {
  let gv = @ghostvalley.new_engine()
  let c = @ghostvalley.Curriculum::default()
  // 无训练历史，应选第一个要求 (cognitive, difficulty=1)
  let d = gv.curriculum_next_dilemma(c, 0.0)
  // cognitive 难度 1 应被优先选择（无前置依赖）
  assert_eq(d.category, "cognitive")
  assert_eq(d.difficulty, 1)
}

///|
test "curriculum_next_dilemma: 前置依赖未满足时跳过" {
  let gv = @ghostvalley.new_engine()
  let c = @ghostvalley.Curriculum::default()
  // 手动添加一些 cognitive 训练（但不够）
  gv.training_stats.round_category_history.push("cognitive")
  gv.training_stats.round_difficulty_history.push(1)
  // cognitive 难度 1 已 1 轮，需 2 轮
  // 应继续选 cognitive 而非 emotional（因为 emotional 依赖 cognitive）
  let d = gv.curriculum_next_dilemma(c, 0.0)
  assert_eq(d.category, "cognitive")
}

///|
test "curriculum_next_dilemma: 所有要求满足后回退自适应" {
  let gv = @ghostvalley.new_engine(max_memory_num=100)
  let llm = @ghostvalley.MockLLM::new()
  let c = @ghostvalley.Curriculum::default()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_curriculum_pipeline(
    llm,
    c,
    rounds=30,
    decay_interval=10,
    cleanup_threshold=0.01,
  )
  // 所有要求应已满足，回退自适应
  let d = gv.curriculum_next_dilemma(c, 0.5)
  // 自适应 difficulty 2 (performance 0.5)
  assert_eq(d.difficulty, 2)
}

///|
test "run_curriculum_pipeline: 追踪分类和难度" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let llm = @ghostvalley.MockLLM::new()
  let c = @ghostvalley.Curriculum::default()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_curriculum_pipeline(
    llm,
    c,
    rounds=10,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let stats = gv.get_training_stats()
  assert_eq(stats.round_difficulty_history.length(), 10)
  assert_eq(stats.round_category_history.length(), 10)
}

///|
test "run_curriculum_pipeline: 触发事件" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let llm = @ghostvalley.MockLLM::new()
  let c = @ghostvalley.Curriculum::default()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_curriculum_pipeline(
    llm,
    c,
    rounds=5,
    decay_interval=2,
    cleanup_threshold=0.1,
  )
  assert_true(gv.event_count("MemoryAdded") == 5)
  assert_true(gv.event_count("RoundCompleted") == 5)
}

///|
test "run_curriculum_pipeline: 未开启时不执行" {
  let gv = @ghostvalley.new_engine()
  let llm = @ghostvalley.MockLLM::new()
  let c = @ghostvalley.Curriculum::default()
  gv.run_curriculum_pipeline(
    llm,
    c,
    rounds=5,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  assert_eq(gv.get_training_stats().total_rounds_completed, 0)
}

///|
test "CurriculumProgress::format 输出正确" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let llm = @ghostvalley.MockLLM::new()
  let c = @ghostvalley.Curriculum::default()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_curriculum_pipeline(
    llm,
    c,
    rounds=10,
    decay_interval=5,
    cleanup_threshold=0.1,
  )
  let progress = gv.curriculum_progress(c)
  let s = progress.format()
  assert_true(s.contains("课程进度"))
  assert_true(s.contains("总体完成率"))
  assert_true(s.contains("下一步"))
}

///|
test "课程驱动 vs 自适应: 课程优先补薄弱分类" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let llm = @ghostvalley.MockLLM::new()
  let c = @ghostvalley.Curriculum::default()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_curriculum_pipeline(
    llm,
    c,
    rounds=24,
    decay_interval=10,
    cleanup_threshold=0.01,
  )
  // 课程驱动应覆盖所有 4 个分类
  let coverages = gv.category_coverage()
  let mut covered = 0
  for c in coverages {
    if c.rounds > 0 {
      covered = covered + 1
    }
  }
  assert_eq(covered, 4)
}

///|
test "CurriculumRequirement: 创建和字段" {
  let req = @ghostvalley.CurriculumRequirement::{
    category: "cognitive",
    difficulty: 2,
    min_rounds: 3,
  }
  assert_eq(req.category, "cognitive")
  assert_eq(req.difficulty, 2)
  assert_eq(req.min_rounds, 3)
}

///|
test "课程进度项: unlocked 标记正确" {
  let gv = @ghostvalley.new_engine()
  let c = @ghostvalley.Curriculum::default()
  let progress = gv.curriculum_progress(c)
  // cognitive 无前置依赖，应 unlocked
  // emotional 依赖 cognitive，cognitive 未训练，应 locked
  let mut cognitive_unlocked = false
  let mut emotional_unlocked = true
  for item in progress.items {
    if item.category == "cognitive" && item.difficulty == 1 {
      cognitive_unlocked = item.unlocked
    }
    if item.category == "emotional" && item.difficulty == 1 {
      emotional_unlocked = item.unlocked
    }
  }
  assert_true(cognitive_unlocked)
  assert_false(emotional_unlocked)
}
