///|
test "apply_decay reduces non_core scores" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("普通记忆", is_simulation=false)
  let score_before = gv.memory_bank[0].value_score
  gv.apply_decay(10)
  let score_after = gv.memory_bank[0].value_score
  assert_true(score_after < score_before)
}

///|
test "apply_decay preserves core memories" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("核心记忆", is_simulation=false, is_core=true)
  let score_before = gv.memory_bank[0].value_score
  gv.apply_decay(10)
  let score_after = gv.memory_bank[0].value_score
  assert_eq(score_before, score_after)
}

///|
test "apply_decay zero rounds no change" {
  let gv = @ghostvalley.new_engine()
  gv.add_memory("普通记忆", is_simulation=false)
  let score_before = gv.memory_bank[0].value_score
  gv.apply_decay(0)
  let score_after = gv.memory_bank[0].value_score
  assert_eq(score_before, score_after)
}

///|
test "apply_decay negative rounds no change" {
  let gv = @ghostvalley.new_engine()
  gv.add_memory("普通记忆", is_simulation=false)
  let score_before = gv.memory_bank[0].value_score
  gv.apply_decay(-5)
  let score_after = gv.memory_bank[0].value_score
  assert_eq(score_before, score_after)
}

///|
test "apply_decay more rounds more decay" {
  let gv1 = @ghostvalley.new_engine(max_memory_num=20)
  gv1.add_memory("普通记忆", is_simulation=false)
  gv1.apply_decay(5)
  let score_5 = gv1.memory_bank[0].value_score
  let gv2 = @ghostvalley.new_engine(max_memory_num=20)
  gv2.add_memory("普通记忆", is_simulation=false)
  gv2.apply_decay(50)
  let score_50 = gv2.memory_bank[0].value_score
  assert_true(score_50 < score_5)
}

///|
test "cleanup_low_value removes low scores" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("普通日常随便应付", is_simulation=false)
  gv.add_memory("顿悟反思改进修复迭代", is_simulation=false)
  let count_before = gv.memory_count()
  let removed = gv.cleanup_low_value(0.5)
  assert_true(removed >= 0)
  assert_eq(gv.memory_count(), count_before - removed)
}

///|
test "cleanup_low_value preserves core" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("核心低分", is_simulation=false, is_core=true)
  // 手动降低分数
  gv.memory_bank[0].value_score = 0.01
  let removed = gv.cleanup_low_value(0.5)
  assert_eq(removed, 0)
  assert_eq(gv.memory_count(), 1)
}

///|
test "cleanup_low_value high threshold removes all non_core" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("普通记忆A", is_simulation=false)
  gv.add_memory("普通记忆B", is_simulation=false)
  gv.add_memory("核心记忆", is_simulation=false, is_core=true)
  let removed = gv.cleanup_low_value(2.0)
  assert_eq(removed, 2)
  assert_eq(gv.memory_count(), 1)
}

///|
test "min_max_value_score empty bank" {
  let gv = @ghostvalley.new_engine()
  assert_eq(gv.min_value_score(), 0.0)
  assert_eq(gv.max_value_score(), 0.0)
}

///|
test "min_max_value_score with memories" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("普通日常随便", is_simulation=false)
  gv.add_memory(
    "顿悟反思改进修复迭代冷静分析",
    is_simulation=false,
  )
  let min_score = gv.min_value_score()
  let max_score = gv.max_value_score()
  assert_true(min_score <= max_score)
  assert_true(max_score > 0.0)
}
