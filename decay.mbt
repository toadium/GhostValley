///|
/// 对非核心记忆应用时间衰减
///
/// 基于双曲衰减模型：`new_score = score / (1 + elapsed / half_life)`
/// 其中 `half_life = score * 50.0`，价值分越高的记忆衰减越慢。
/// 核心记忆不受衰减影响。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine()
///   gv.add_memory("普通记忆", is_simulation=false)
///   let score_before = gv.memory_bank[0].value_score
///   gv.apply_decay(10)
///   let score_after = gv.memory_bank[0].value_score
///   assert_true(score_after <= score_before)
/// }
/// ```
pub fn GhostValleyEngine::apply_decay(
  self : GhostValleyEngine,
  rounds_elapsed : Int,
) -> Unit {
  if rounds_elapsed <= 0 {
    return
  }
  for m in self.memory_bank {
    if !m.is_core_memory {
      m.value_score = apply_decay_model(
        self.decay_model,
        self.decay_params,
        m.value_score,
        rounds_elapsed,
      )
    }
  }
}

///|
/// 清理价值分低于阈值的非核心记忆
///
/// 返回被清理的记忆数量。核心记忆永远不被清理。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine()
///   gv.add_memory("普通日常随便应付", is_simulation=false)
///   let removed = gv.cleanup_low_value(0.5)
///   assert_true(removed >= 0)
/// }
/// ```
pub fn GhostValleyEngine::cleanup_low_value(
  self : GhostValleyEngine,
  threshold : Double,
) -> Int {
  let bank = self.memory_bank
  let indices_to_remove : Array[Int] = []
  for i, m in bank {
    if !m.is_core_memory && m.value_score < threshold {
      indices_to_remove.push(i)
    }
  }
  indices_to_remove.sort_by(fn(a, b) { b.compare(a) })
  for idx in indices_to_remove {
    if idx < bank.length() {
      ignore(bank.remove(idx))
    }
  }
  indices_to_remove.length()
}

///|
/// 获取最低价值分
///
/// 空记忆库返回 0.0。
pub fn GhostValleyEngine::min_value_score(self : GhostValleyEngine) -> Double {
  let bank = self.memory_bank
  if bank.length() == 0 {
    return 0.0
  }
  let mut min_score = bank[0].value_score
  for m in bank {
    if m.value_score < min_score {
      min_score = m.value_score
    }
  }
  min_score
}

///|
/// 获取最高价值分
///
/// 空记忆库返回 0.0。
pub fn GhostValleyEngine::max_value_score(self : GhostValleyEngine) -> Double {
  let bank = self.memory_bank
  if bank.length() == 0 {
    return 0.0
  }
  let mut max_score = bank[0].value_score
  for m in bank {
    if m.value_score > max_score {
      max_score = m.value_score
    }
  }
  max_score
}
