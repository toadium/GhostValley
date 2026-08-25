// ============================================================
// Phase 2: 记忆关联图谱 + 访问追踪测试
// ============================================================

///|
test "link_memories: 双向关联建立" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  gv.add_memory("记忆B", is_simulation=false)
  gv.link_memories(0, 1, strength=0.8)
  // 双向：A 关联 B，B 关联 A
  assert_eq(gv.memory_bank[0].linked_ids.length(), 1)
  assert_eq(gv.memory_bank[1].linked_ids.length(), 1)
  let (link_a, str_a) = gv.memory_bank[0].linked_ids[0]
  let (link_b, str_b) = gv.memory_bank[1].linked_ids[0]
  assert_eq(link_a, 1) // A 关联到 B (idx=1)
  assert_eq(link_b, 0) // B 关联到 A (idx=0)
  assert_true(str_a > 0.79 && str_a < 0.81)
  assert_true(str_b > 0.79 && str_b < 0.81)
}

///|
test "link_memories: 无效索引不操作" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  gv.link_memories(0, 5, strength=0.8) // idx 5 不存在
  assert_eq(gv.memory_bank[0].linked_ids.length(), 0)
  gv.link_memories(-1, 0, strength=0.8) // 负索引
  assert_eq(gv.memory_bank[0].linked_ids.length(), 0)
  gv.link_memories(0, 0, strength=0.8) // 相同索引
  assert_eq(gv.memory_bank[0].linked_ids.length(), 0)
}

///|
test "link_memories: strength 被 clamp 到 [0,1]" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  gv.add_memory("记忆B", is_simulation=false)
  gv.link_memories(0, 1, strength=1.5)
  let (_, s) = gv.memory_bank[0].linked_ids[0]
  assert_eq(s, 1.0)
  gv.add_memory("记忆C", is_simulation=false)
  gv.link_memories(0, 2, strength=-0.5)
  let (_, s2) = gv.memory_bank[0].linked_ids[1]
  assert_eq(s2, 0.0)
}

///|
test "associative_retrieve: BFS 深度 1" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  gv.add_memory("记忆B", is_simulation=false)
  gv.add_memory("记忆C", is_simulation=false)
  gv.link_memories(0, 1, strength=0.8)
  gv.link_memories(1, 2, strength=0.6)
  // depth=1: 只返回 A 的直接关联 (B)
  let chain = gv.associative_retrieve(0, depth=1)
  assert_eq(chain.length(), 1)
}

///|
test "associative_retrieve: BFS 深度 2" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  gv.add_memory("记忆B", is_simulation=false)
  gv.add_memory("记忆C", is_simulation=false)
  gv.link_memories(0, 1, strength=0.8)
  gv.link_memories(1, 2, strength=0.6)
  // depth=2: A→B→C，返回 B 和 C
  let chain = gv.associative_retrieve(0, depth=2)
  assert_eq(chain.length(), 2)
}

///|
test "associative_retrieve: 环形关联不重复" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("A", is_simulation=false)
  gv.add_memory("B", is_simulation=false)
  gv.add_memory("C", is_simulation=false)
  gv.link_memories(0, 1, strength=0.8)
  gv.link_memories(1, 2, strength=0.6)
  gv.link_memories(2, 0, strength=0.5) // 形成环
  let chain = gv.associative_retrieve(0, depth=5)
  // A→B→C，C→A(已访问)，应返回 2 条
  assert_eq(chain.length(), 2)
}

///|
test "associative_retrieve: 无关联返回空" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("孤立记忆", is_simulation=false)
  let chain = gv.associative_retrieve(0, depth=3)
  assert_eq(chain.length(), 0)
}

///|
test "associative_retrieve: 无效索引返回空" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  let chain = gv.associative_retrieve(0, depth=3)
  assert_eq(chain.length(), 0)
}

///|
test "reinforce_memory: access_count 递增" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  assert_eq(gv.memory_bank[0].access_count, 0)
  gv.reinforce_memory(0)
  assert_eq(gv.memory_bank[0].access_count, 1)
  gv.reinforce_memory(0)
  assert_eq(gv.memory_bank[0].access_count, 2)
}

///|
test "reinforce_memory: value_score 微增" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  let score_before = gv.memory_bank[0].value_score
  gv.reinforce_memory(0)
  let score_after = gv.memory_bank[0].value_score
  assert_true(score_after > score_before)
  assert_true(score_after - score_before < 0.03) // 微增约 0.02
}

///|
test "reinforce_memory: 分数不超上限 0.95" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory(
    "顿悟反思改进修复迭代冷静分析",
    is_simulation=false,
  )
  // 多次 reinforce 直到封顶
  for _ in 0..<100 {
    gv.reinforce_memory(0)
  }
  assert_true(gv.memory_bank[0].value_score <= 0.95)
}

///|
test "reinforce_memory: 无效索引不操作" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  gv.reinforce_memory(5) // 无效索引
  assert_eq(gv.memory_bank[0].access_count, 0)
}

///|
test "search_memories 自动 reinforce" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("顿悟反思A", is_simulation=false)
  gv.add_memory("普通B", is_simulation=false)
  // 搜索前 access_count = 0
  assert_eq(gv.memory_bank[0].access_count, 0)
  ignore(gv.search_memories("顿悟"))
  // 搜索后应自动 reinforce
  assert_true(gv.memory_bank[0].access_count > 0)
}

///|
test "top_memories 自动 reinforce" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("顿悟反思改进", is_simulation=false)
  gv.add_memory("普通日常", is_simulation=false)
  assert_eq(gv.memory_bank[0].access_count, 0)
  ignore(gv.top_memories(1))
  // top_memories 命中后应自动 reinforce
  let mut reinforced = false
  for m in gv.memory_bank {
    if m.access_count > 0 {
      reinforced = true
    }
  }
  assert_true(reinforced)
}

///|
test "weighted_search 自动 reinforce" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("顿悟反思改进", is_simulation=false)
  gv.add_memory("普通日常", is_simulation=false)
  assert_eq(gv.memory_bank[0].access_count, 0)
  ignore(gv.weighted_search("顿悟", 2))
  assert_true(gv.memory_bank[0].access_count > 0)
}

///|
test "access_frequency_report: 按频率降序" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  gv.add_memory("记忆B", is_simulation=false)
  gv.add_memory("记忆C", is_simulation=false)
  // A 被访问 3 次，B 被访问 1 次，C 未被访问
  gv.reinforce_memory(0)
  gv.reinforce_memory(0)
  gv.reinforce_memory(0)
  gv.reinforce_memory(1)
  let report = gv.access_frequency_report()
  // 只有 A 和 B（C 未被访问）
  assert_eq(report.length(), 2)
  // A 在前（频率更高）
  assert_true(report[0].access_count >= report[1].access_count)
  assert_eq(report[0].access_count, 3)
  assert_eq(report[1].access_count, 1)
}

///|
test "access_frequency_report: 无访问返回空" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  gv.add_memory("记忆B", is_simulation=false)
  let report = gv.access_frequency_report()
  assert_eq(report.length(), 0)
}

///|
test "merge_memories: 合并后 access_count 叠加" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  gv.add_memory("记忆B", is_simulation=false)
  gv.reinforce_memory(0)
  gv.reinforce_memory(0)
  gv.reinforce_memory(1)
  // A: access_count=2, B: access_count=1
  gv.merge_memories(0, 1)
  // 合并后 access_count = 2 + 1 = 3
  assert_eq(gv.memory_bank[0].access_count, 3)
}

///|
test "引擎状态保存/恢复包含关联数据" {
  let gv1 = @ghostvalley.new_engine(max_memory_num=20)
  gv1.add_memory("记忆A", is_simulation=false)
  gv1.add_memory("记忆B", is_simulation=false)
  gv1.link_memories(0, 1, strength=0.8)
  gv1.reinforce_memory(0)
  gv1.reinforce_memory(0)
  let state = gv1.save_engine_state()
  let gv2 = @ghostvalley.new_engine()
  gv2.load_engine_state(state)
  assert_eq(gv2.memory_bank[0].access_count, 2)
  assert_eq(gv2.memory_bank[0].linked_ids.length(), 1)
  assert_eq(gv2.memory_bank[1].linked_ids.length(), 1)
}
