///|
test "weighted_search empty bank" {
  let gv = @ghostvalley.new_engine()
  let results = gv.weighted_search("任意", 5)
  assert_eq(results.length(), 0)
}

///|
test "weighted_search zero top_n" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("顿悟反思", is_simulation=false)
  let results = gv.weighted_search("顿悟", 0)
  assert_eq(results.length(), 0)
}

///|
test "weighted_search negative top_n" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("顿悟反思", is_simulation=false)
  let results = gv.weighted_search("顿悟", -1)
  assert_eq(results.length(), 0)
}

///|
test "weighted_search returns sorted by composite" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("普通日常随便应付", is_simulation=false)
  gv.add_memory("顿悟反思改进修复迭代", is_simulation=false)
  let results = gv.weighted_search("顿悟反思改进", 2)
  assert_eq(results.length(), 2)
  // 高价值记忆应排在前面
  assert_true(results[0].value_score >= results[1].value_score)
}

///|
test "weighted_search top_n exceeds total" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  gv.add_memory("记忆B", is_simulation=false)
  let results = gv.weighted_search("记忆", 10)
  assert_eq(results.length(), 2)
}

///|
test "weighted_search single memory" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("顿悟反思改进", is_simulation=false)
  let results = gv.weighted_search("顿悟", 1)
  assert_eq(results.length(), 1)
}

///|
test "weighted_search similarity boosts relevant" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("普通日常记录", is_simulation=false)
  gv.add_memory("顿悟反思改进", is_simulation=false)
  // 查询与第二条更相似，应排第一
  let results = gv.weighted_search("顿悟反思", 2)
  assert_eq(results.length(), 2)
  assert_true(results[0].content.contains("顿悟"))
}

///|
test "add_memory_dedup creates new when dissimilar" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  let created = gv.add_memory_dedup("顿悟反思改进", is_simulation=false)
  assert_true(created)
  assert_eq(gv.memory_count(), 1)
}

///|
test "add_memory_dedup merges when similar" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  ignore(
    gv.add_memory_dedup("顿悟反思改进修复迭代", is_simulation=false),
  )
  let created = gv.add_memory_dedup(
    "顿悟反思改进修复迭代冷静分析",
    is_simulation=false,
  )
  // 高相似度（0.833），应合并
  assert_false(created)
  assert_eq(gv.memory_count(), 1)
}

///|
test "add_memory_dedup custom threshold" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  ignore(gv.add_memory_dedup("顿悟反思改进", is_simulation=false))
  // 用很低阈值，即使不太相似也合并
  let created = gv.add_memory_dedup(
    "失败错误冲突",
    is_simulation=false,
    similarity_threshold=0.0,
  )
  assert_false(created)
  assert_eq(gv.memory_count(), 1)
}

///|
test "add_memory_dedup preserves higher score" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  ignore(
    gv.add_memory_dedup(
      "顿悟反思改进修复迭代冷静分析",
      is_simulation=false,
    ),
  )
  let score_before = gv.memory_bank[0].value_score
  ignore(
    gv.add_memory_dedup("顿悟反思改进修复迭代", is_simulation=false),
  )
  let score_after = gv.memory_bank[0].value_score
  // 合并后分数应取较高值
  assert_true(score_after >= score_before - 0.001)
}

///|
test "add_memory_dedup merges core flag" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  ignore(
    gv.add_memory_dedup("顿悟反思改进修复迭代", is_simulation=false),
  )
  ignore(
    gv.add_memory_dedup(
      "顿悟反思改进修复迭代冷静分析",
      is_simulation=false,
      is_core=true,
    ),
  )
  // 合并后应为核心记忆
  assert_true(gv.memory_bank[0].is_core_memory)
}

///|
test "merge_memories basic" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  gv.add_memory("记忆B", is_simulation=false)
  let count_before = gv.memory_count()
  gv.merge_memories(0, 1)
  assert_eq(gv.memory_count(), count_before - 1)
}

///|
test "merge_memories preserves higher score" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("普通日常随便应付", is_simulation=false)
  gv.add_memory("顿悟反思改进修复迭代", is_simulation=false)
  gv.merge_memories(0, 1)
  assert_eq(gv.memory_count(), 1)
  // 合并后应保留较高分数
  assert_true(gv.memory_bank[0].value_score > 0.3)
}

///|
test "merge_memories same index no op" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  gv.merge_memories(0, 0)
  assert_eq(gv.memory_count(), 1)
}

///|
test "merge_memories invalid indices no op" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  gv.merge_memories(0, 5)
  assert_eq(gv.memory_count(), 1)
  gv.merge_memories(-1, 0)
  assert_eq(gv.memory_count(), 1)
}

///|
test "merge_memories merges core flag" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  gv.add_memory("记忆B", is_simulation=false, is_core=true)
  gv.merge_memories(0, 1)
  assert_true(gv.memory_bank[0].is_core_memory)
}

///|
test "merge_memories reversed indices" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  gv.add_memory("记忆B", is_simulation=false)
  // idx_a > idx_b 也应正常工作
  gv.merge_memories(1, 0)
  assert_eq(gv.memory_count(), 1)
}
