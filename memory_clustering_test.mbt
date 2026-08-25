// ============================================================
// Phase 2: 记忆聚类 + 自动关联 + 自适应强化测试
// ============================================================

///|
test "cluster_memories: 空记忆库返回空" {
  let gv = @ghostvalley.new_engine()
  let clusters = gv.cluster_memories(0.3)
  assert_eq(clusters.length(), 0)
}

///|
test "cluster_memories: 单条记忆一个簇" {
  let gv = @ghostvalley.new_engine(max_memory_num=10)
  gv.add_memory("顿悟反思", is_simulation=false)
  let clusters = gv.cluster_memories(0.3)
  assert_eq(clusters.length(), 1)
  assert_eq(clusters[0].length(), 1)
}

///|
test "cluster_memories: 相似记忆归入同簇" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("顿悟反思改进", is_simulation=false)
  gv.add_memory("顿悟反思修复", is_simulation=false)
  let clusters = gv.cluster_memories(0.3)
  assert_eq(clusters.length(), 1)
  assert_eq(clusters[0].length(), 2)
}

///|
test "cluster_memories: 不相似记忆分入不同簇" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("顿悟反思改进", is_simulation=false)
  gv.add_memory("普通日常随便", is_simulation=false)
  let clusters = gv.cluster_memories(0.3)
  assert_eq(clusters.length(), 2)
}

///|
test "cluster_memories: 高阈值导致更多簇" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("顿悟反思改进", is_simulation=false)
  gv.add_memory("顿悟反思修复", is_simulation=false)
  gv.add_memory("顿悟推理分析", is_simulation=false)
  let low_threshold = gv.cluster_memories(0.1)
  let high_threshold = gv.cluster_memories(0.9)
  assert_true(low_threshold.length() <= high_threshold.length())
}

///|
test "cluster_memories: 所有记忆索引被覆盖" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("顿悟反思", is_simulation=false)
  gv.add_memory("普通日常", is_simulation=false)
  gv.add_memory("压力训练", is_simulation=false)
  let clusters = gv.cluster_memories(0.3)
  let mut total = 0
  for c in clusters {
    total = total + c.length()
  }
  assert_eq(total, 3)
}

///|
test "auto_link: 相似记忆自动建链" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("顿悟反思改进", is_simulation=false)
  gv.add_memory("顿悟反思修复", is_simulation=false)
  let count = gv.auto_link(0.3, strength=0.5)
  assert_true(count >= 1)
  // 验证双向关联
  assert_true(gv.memory_bank[0].linked_ids.length() >= 1)
  assert_true(gv.memory_bank[1].linked_ids.length() >= 1)
}

///|
test "auto_link: 不相似记忆不建链" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("顿悟反思改进", is_simulation=false)
  gv.add_memory("普通日常随便", is_simulation=false)
  let count = gv.auto_link(0.9, strength=0.5)
  assert_eq(count, 0)
}

///|
test "auto_link: 重复调用不重复建链" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("顿悟反思改进", is_simulation=false)
  gv.add_memory("顿悟反思修复", is_simulation=false)
  let count1 = gv.auto_link(0.3, strength=0.5)
  let count2 = gv.auto_link(0.3, strength=0.5)
  assert_true(count1 >= 1)
  assert_eq(count2, 0)
}

///|
test "auto_link: 空记忆库返回 0" {
  let gv = @ghostvalley.new_engine()
  let count = gv.auto_link(0.3, strength=0.5)
  assert_eq(count, 0)
}

///|
test "ClusterSummary: cluster_statistics 基本功能" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("顿悟反思改进", is_simulation=false)
  gv.add_memory("顿悟反思修复", is_simulation=false)
  gv.add_memory("普通日常", is_simulation=false)
  let stats = gv.cluster_statistics(0.3)
  assert_true(stats.length() >= 2)
  for s in stats {
    assert_true(s.size > 0)
    assert_true(s.avg_score >= 0.0)
    assert_true(s.representative_content.length() > 0)
  }
}

///|
test "ClusterSummary: 簇大小正确" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("顿悟反思改进", is_simulation=false)
  gv.add_memory("顿悟反思修复", is_simulation=false)
  gv.add_memory("普通日常随便", is_simulation=false)
  let stats = gv.cluster_statistics(0.3)
  let mut total_size = 0
  for s in stats {
    total_size = total_size + s.size
  }
  assert_eq(total_size, 3)
}

///|
test "ClusterSummary::format 输出正确" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("顿悟反思改进", is_simulation=false)
  let stats = gv.cluster_statistics(0.3)
  let s = stats[0].format()
  assert_true(s.contains("簇"))
  assert_true(s.contains("条记忆"))
  assert_true(s.contains("代表"))
}

///|
test "adaptive_reinforce: 首次增量 0.02" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  let score_before = gv.memory_bank[0].value_score
  gv.adaptive_reinforce(0)
  let score_after = gv.memory_bank[0].value_score
  let increment = score_after - score_before
  // 首次: 0.02 / (1 + 1 * 0.1) = 0.02 / 1.1 ≈ 0.01818
  assert_true(increment > 0.017 && increment < 0.019)
}

///|
test "adaptive_reinforce: 增量随访问次数递减" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  let increments : Array[Double] = []
  let prev = gv.memory_bank[0].value_score
  gv.adaptive_reinforce(0)
  increments.push(gv.memory_bank[0].value_score - prev)
  let prev2 = gv.memory_bank[0].value_score
  gv.adaptive_reinforce(0)
  increments.push(gv.memory_bank[0].value_score - prev2)
  let prev3 = gv.memory_bank[0].value_score
  gv.adaptive_reinforce(0)
  increments.push(gv.memory_bank[0].value_score - prev3)
  // 递减: inc1 > inc2 > inc3
  assert_true(increments[0] > increments[1])
  assert_true(increments[1] > increments[2])
}

///|
test "adaptive_reinforce: access_count 递增" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  assert_eq(gv.memory_bank[0].access_count, 0)
  gv.adaptive_reinforce(0)
  assert_eq(gv.memory_bank[0].access_count, 1)
  gv.adaptive_reinforce(0)
  assert_eq(gv.memory_bank[0].access_count, 2)
}

///|
test "adaptive_reinforce: 分数不超 0.95" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  gv.memory_bank[0].value_score = 0.94
  for _ in 0..<20 {
    gv.adaptive_reinforce(0)
  }
  assert_true(gv.memory_bank[0].value_score <= 0.95)
}

///|
test "adaptive_reinforce: 无效索引不崩溃" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.adaptive_reinforce(-1)
  gv.adaptive_reinforce(100)
  assert_true(true)
}

///|
test "reinforce_memory: 使用自适应逻辑" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  let s0 = gv.memory_bank[0].value_score
  gv.reinforce_memory(0)
  let s1 = gv.memory_bank[0].value_score
  gv.reinforce_memory(0)
  let s2 = gv.memory_bank[0].value_score
  // 自适应: 第一次增量 > 第二次增量
  assert_true(s1 - s0 > s2 - s1)
}

///|
test "聚类后自动关联: 簇内记忆可关联检索" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("顿悟反思改进", is_simulation=false)
  gv.add_memory("顿悟反思修复", is_simulation=false)
  gv.add_memory("普通日常随便", is_simulation=false)
  // 自动建链
  ignore(gv.auto_link(0.3, strength=0.5))
  // 记忆 0 和 1 应已关联
  let related = gv.associative_retrieve(0, depth=1)
  assert_true(related.length() >= 1)
}
