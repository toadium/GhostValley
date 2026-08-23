// ============================================================
// Phase 2: 记忆关联图谱 + 访问追踪
// ============================================================

///|
/// 记忆间双向关联
///
/// 建立两条记忆间的双向关联，strength ∈ [0,1] 表示关联强度。
/// 关联后可通过 associative_retrieve 沿关联链检索。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=20)
///   gv.add_memory("顿悟反思", is_simulation=false)
///   gv.add_memory("改进修复", is_simulation=false)
///   gv.link_memories(0, 1, strength=0.8)
///   assert_eq(gv.memory_bank[0].linked_ids.length(), 1)
///   assert_eq(gv.memory_bank[1].linked_ids.length(), 1)
/// }
/// ```
pub fn GhostValleyEngine::link_memories(
  self : GhostValleyEngine,
  idx_a : Int,
  idx_b : Int,
  strength~ : Double,
) -> Unit {
  let bank = self.memory_bank
  if idx_a < 0 || idx_b < 0 || idx_a == idx_b {
    return
  }
  if idx_a >= bank.length() || idx_b >= bank.length() {
    return
  }
  // clamp strength to [0, 1]
  let s = if strength < 0.0 {
    0.0
  } else if strength > 1.0 {
    1.0
  } else {
    strength
  }
  // 双向关联
  bank[idx_a].linked_ids.push((idx_b, s))
  bank[idx_b].linked_ids.push((idx_a, s))
}

///|
/// 间隔重复强化
///
/// 访问记忆时 access_count++ 且 value_score 微增（+0.02），
/// 模拟间隔重复效应（类似 Anki 的 spaced repetition）。
/// value_score 不超过上限 0.95。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=20)
///   gv.add_memory("顿悟反思", is_simulation=false)
///   let score_before = gv.memory_bank[0].value_score
///   gv.reinforce_memory(0)
///   assert_eq(gv.memory_bank[0].access_count, 1)
///   assert_true(gv.memory_bank[0].value_score > score_before)
/// }
/// ```
pub fn GhostValleyEngine::reinforce_memory(
  self : GhostValleyEngine,
  idx : Int,
) -> Unit {
  let bank = self.memory_bank
  if idx < 0 || idx >= bank.length() {
    return
  }
  bank[idx].access_count = bank[idx].access_count + 1
  let new_score = bank[idx].value_score + 0.02
  bank[idx].value_score = if new_score > 0.95 { 0.95 } else { new_score }
}

///|
/// 关联检索（BFS 遍历）
///
/// 从起始记忆出发沿关联链检索，返回 depth 层内的所有关联记忆。
/// 不包含起始记忆本身。返回结果按 BFS 顺序排列。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=20)
///   gv.add_memory("记忆A", is_simulation=false)
///   gv.add_memory("记忆B", is_simulation=false)
///   gv.add_memory("记忆C", is_simulation=false)
///   gv.link_memories(0, 1, strength=0.8)
///   gv.link_memories(1, 2, strength=0.6)
///   let chain = gv.associative_retrieve(0, depth=2)
///   assert_eq(chain.length(), 2)
/// }
/// ```
pub fn GhostValleyEngine::associative_retrieve(
  self : GhostValleyEngine,
  start_idx : Int,
  depth~ : Int,
) -> Array[AiMemory] {
  let bank = self.memory_bank
  if start_idx < 0 || start_idx >= bank.length() || depth <= 0 {
    return []
  }
  let result : Array[AiMemory] = []
  let visited : Array[Int] = [start_idx]
  // BFS: (index, current_depth)
  let queue : Array[(Int, Int)] = [(start_idx, 0)]
  while queue.length() > 0 {
    let (curr_idx, curr_depth) = queue.remove(0)
    if curr_depth >= depth {
      continue
    }
    let mem = bank[curr_idx]
    for link in mem.linked_ids {
      let (linked_idx, _) = link
      let mut already_visited = false
      for v in visited {
        if v == linked_idx {
          already_visited = true
          break
        }
      }
      if not(already_visited) && linked_idx >= 0 && linked_idx < bank.length() {
        visited.push(linked_idx)
        result.push(bank[linked_idx])
        queue.push((linked_idx, curr_depth + 1))
      }
    }
  }
  result
}

///|
/// 访问频率报告
///
/// 返回按访问频率降序排列的记忆列表（access_count > 0 的记忆）。
/// 频率相同的按 value_score 降序排列。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=20)
///   gv.add_memory("记忆A", is_simulation=false)
///   gv.add_memory("记忆B", is_simulation=false)
///   gv.reinforce_memory(0)
///   gv.reinforce_memory(0)
///   gv.reinforce_memory(1)
///   let report = gv.access_frequency_report()
///   assert_eq(report.length(), 2)
///   assert_true(report[0].access_count >= report[1].access_count)
/// }
/// ```
pub fn GhostValleyEngine::access_frequency_report(
  self : GhostValleyEngine,
) -> Array[AiMemory] {
  let bank = self.memory_bank
  let result : Array[AiMemory] = []
  for m in bank {
    if m.access_count > 0 {
      result.push(m)
    }
  }
  result.sort_by(fn(a, b) {
    if a.access_count != b.access_count {
      b.access_count.compare(a.access_count)
    } else {
      b.value_score.compare(a.value_score)
    }
  })
  result
}
