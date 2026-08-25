///|
/// 按关键词检索记忆
///
/// 返回内容包含指定关键词的所有记忆。关键词匹配为子串包含。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine()
///   gv.add_memory("顿悟失败原因", is_simulation=false)
///   gv.add_memory("普通日常记录", is_simulation=false)
///   let results = gv.search_memories("顿悟")
///   assert_eq(results.length(), 1)
/// }
/// ```
pub fn GhostValleyEngine::search_memories(
  self : GhostValleyEngine,
  keyword : String,
) -> Array[AiMemory] {
  let results : Array[AiMemory] = []
  for i, m in self.memory_bank {
    if m.content.contains(keyword) {
      self.reinforce_memory(i)
      results.push(m)
    }
  }
  results
}

///|
/// 获取价值分最高的 N 条记忆
///
/// 按 `value_score` 降序排列返回前 `n` 条。
/// 若 `n` 超过记忆总数，返回全部记忆。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine()
///   gv.add_memory("顿悟反思改进", is_simulation=false)
///   gv.add_memory("普通日常", is_simulation=false)
///   let top = gv.top_memories(1)
///   assert_eq(top.length(), 1)
/// }
/// ```
pub fn GhostValleyEngine::top_memories(
  self : GhostValleyEngine,
  n : Int,
) -> Array[AiMemory] {
  let bank = self.memory_bank
  if n <= 0 || bank.length() == 0 {
    return []
  }
  // Partial selection: maintain top-n with indices.
  // O(n * k) where k = top_n, better than O(n log n) when n >> k.
  let top : Array[(AiMemory, Int)] = []
  for i, m in bank {
    if top.length() < n {
      let mut inserted = false
      for j in 0..<top.length() {
        if m.value_score > top[j].0.value_score {
          top.insert(j, (m, i))
          inserted = true
          break
        }
      }
      if not(inserted) {
        top.push((m, i))
      }
    } else if m.value_score > top[top.length() - 1].0.value_score {
      top[top.length() - 1] = (m, i)
      let mut j = top.length() - 1
      while j > 0 && top[j].0.value_score > top[j - 1].0.value_score {
        let tmp = top[j]
        top[j] = top[j - 1]
        top[j - 1] = tmp
        j = j - 1
      }
    }
  }
  // Reinforce selected memories and return
  let result : Array[AiMemory] = []
  for i in 0..<top.length() {
    let (m, idx) = top[i]
    self.reinforce_memory(idx)
    result.push(m)
  }
  result
}

///|
/// 按标记过滤记忆
///
/// `is_simulation` 和 `is_core` 为 `None` 时不按该字段过滤。
/// 传 `Some(true)` 或 `Some(false)` 按对应值过滤。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine()
///   gv.add_memory("模拟挫折", is_simulation=true)
///   gv.add_memory("真实顿悟", is_simulation=false)
///   let sims = gv.filter_memories(is_simulation=Some(true))
///   assert_eq(sims.length(), 1)
/// }
/// ```
pub fn GhostValleyEngine::filter_memories(
  self : GhostValleyEngine,
  is_simulation? : Bool? = None,
  is_core? : Bool? = None,
) -> Array[AiMemory] {
  let results : Array[AiMemory] = []
  for m in self.memory_bank {
    let sim_ok = match is_simulation {
      Some(v) => m.is_simulation == v
      None => true
    }
    let core_ok = match is_core {
      Some(v) => m.is_core_memory == v
      None => true
    }
    if sim_ok && core_ok {
      results.push(m)
    }
  }
  results
}

///|
/// 计算全部记忆的平均价值分
///
/// 空记忆库返回 0.0。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine()
///   gv.add_memory("顿悟反思", is_simulation=false)
///   let avg = gv.average_value_score()
///   assert_true(avg > 0.0)
/// }
/// ```
pub fn GhostValleyEngine::average_value_score(
  self : GhostValleyEngine,
) -> Double {
  let bank = self.memory_bank
  if bank.length() == 0 {
    return 0.0
  }
  let mut total = 0.0
  for m in bank {
    total = total + m.value_score
  }
  total / bank.length().to_double()
}

///|
/// 获取所有真实记忆（非模拟）
pub fn GhostValleyEngine::real_memories(
  self : GhostValleyEngine,
) -> Array[AiMemory] {
  self.filter_memories(is_simulation=Some(false))
}

///|
/// 获取所有模拟记忆（安全气垫）
pub fn GhostValleyEngine::simulation_memories(
  self : GhostValleyEngine,
) -> Array[AiMemory] {
  self.filter_memories(is_simulation=Some(true))
}

///|
/// 获取所有核心记忆（永不被遗忘）
pub fn GhostValleyEngine::core_memories(
  self : GhostValleyEngine,
) -> Array[AiMemory] {
  self.filter_memories(is_core=Some(true))
}

///|
/// 加权综合检索
///
/// 将 value_score（权重 0.4）、text_similarity（权重 0.4）、时间近因（权重 0.2）
/// 合成复合分，按复合分降序返回 top_n 条记忆。
/// 近因分 = 记忆在库中的相对位置（越新越高），空库返回空数组。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=20)
///   gv.add_memory("顿悟反思改进", is_simulation=false)
///   gv.add_memory("普通日常", is_simulation=false)
///   let results = gv.weighted_search("顿悟反思", 2)
///   assert_true(results.length() <= 2)
/// }
/// ```
pub fn GhostValleyEngine::weighted_search(
  self : GhostValleyEngine,
  query : String,
  top_n : Int,
) -> Array[AiMemory] {
  let bank = self.memory_bank
  if bank.length() == 0 || top_n <= 0 {
    return []
  }
  // (composite_score, index)
  let scored : Array[(Double, Int)] = []
  let total = bank.length()
  for i, m in bank {
    let value_component = m.value_score * 0.4
    let sim_component = text_similarity(query, m.content) * 0.4
    let recency = if total > 1 {
      i.to_double() / (total - 1).to_double()
    } else {
      1.0
    }
    let recency_component = recency * 0.2
    let composite = value_component + sim_component + recency_component
    scored.push((composite, i))
  }
  scored.sort_by(fn(a, b) { b.0.compare(a.0) })
  let count = if top_n < scored.length() { top_n } else { scored.length() }
  let result : Array[AiMemory] = []
  for i in 0..<count {
    let idx = scored[i].1
    self.reinforce_memory(idx)
    result.push(bank[idx])
  }
  result
}
