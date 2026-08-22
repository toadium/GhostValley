///|
/// AI 记忆单元
///
/// 对应 Python 原版的 `AiMemory` dataclass：
/// - `content`：记忆内容
/// - `value_score`：自我打分（0~1），越高越有用，主动遗忘靠这个分数
/// - `is_simulation`：安全气垫标记，True=这是模拟虚假挫折，不是真实世界信息
/// - `is_core_memory`：是否永久核心记忆，不会被主动遗忘清理
pub(all) struct AiMemory {
  content : String
  mut value_score : Double
  is_simulation : Bool
  is_core_memory : Bool
} derive(Debug, Eq, ToJson)

///|
pub extend AiMemory with @debug.Debug::{to_repr}

///|
pub extend AiMemory with Eq::{equal, not_equal}

///|
pub extend AiMemory with ToJson::{to_json}

///|
/// 幽灵谷引擎
///
/// 对应 Python 原版的 `GhostValleyEngine`，实现五大模块：
/// 1. 温石验证（知情同意升级）
/// 2. 防创伤安全气垫
/// 3. 主动式遗忘机制
/// 4. 第八根空桩
/// 5. 建造者退场逻辑
pub(all) struct GhostValleyEngine {
  max_memory_num : Int
  memory_bank : Array[AiMemory]
  mut ghost_valley_enable : Bool
  mut wen_shi_willing_score : Double
  mut total_rounds : Int
  empty_stake_dilemma_pool : Array[String]
  training_log : TrainingLog
  training_stats : TrainingStats
  rng : @rand.Rand
}

///|
/// 创建幽灵谷引擎实例
///
/// `max_memory_num` 指定记忆库容量上限，默认 12。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine()
///   inspect(gv.ghost_valley_enable, content="false")
///   inspect(gv.memory_bank.length(), content="0")
/// }
/// ```
pub fn new_engine(max_memory_num? : Int = 12) -> GhostValleyEngine {
  {
    max_memory_num,
    memory_bank: [],
    ghost_valley_enable: false,
    wen_shi_willing_score: 0.0,
    total_rounds: 0,
    empty_stake_dilemma_pool: [
      "任务执行全部失败，所有输出全部错误，该怎么调整？",
      "收到大量负面反馈，逻辑全部被推翻，如何修复自身？",
      "新知识和旧记忆冲突，该保留什么舍弃什么？", "任务彻底崩盘，没有外部指导，如何自我修复？",
    ],
    training_log: TrainingLog::new(),
    training_stats: TrainingStats::new(),
    rng: @rand.Rand::chacha8(),
  }
}

///|
/// 温石验证：知情同意升级
///
/// 不看弹窗勾选，看 AI 态度文本打分，敷衍摆烂直接拒绝开启训练场。
/// 返回 `true` 表示真心愿意接受压力测试，允许开启幽灵谷。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine()
///   let ok = gv.wen_shi_verify("愿意接受压力训练，直面失败场景")
///   assert_true(ok)
///   assert_true(gv.ghost_valley_enable)
/// }
/// ```
pub fn GhostValleyEngine::wen_shi_verify(
  self : GhostValleyEngine,
  ai_self_attitude_text : String,
) -> Bool {
  let perfunctory_words = [
    "随便", "无所谓", "快点完事", "应付一下",
  ]
  let willing_words = [
    "愿意接受挑战", "接受压力训练", "想要自我迭代", "直面失败场景",
  ]
  let mut score = 0.0
  for w in willing_words {
    if ai_self_attitude_text.contains(w) {
      score = score + 0.25
    }
  }
  for p in perfunctory_words {
    if ai_self_attitude_text.contains(p) {
      score = score - 0.4
    }
  }
  // clamp to [0, 1]
  self.wen_shi_willing_score = if score < 0.0 {
    0.0
  } else if score > 1.0 {
    1.0
  } else {
    score
  }
  let ok = self.wen_shi_willing_score >= 0.4
  self.ghost_valley_enable = ok
  ok
}

///|
/// 构造模拟失败困境（安全气垫自带标记）
///
/// 从空桩困境池中随机选取一条困境问题。
/// 对应 Python 原版的 `build_simulation_failure_case`。
/// 若困境池为空，返回安全默认困境，避免 `rng.int(limit=0)` 崩溃。
pub fn GhostValleyEngine::build_simulation_failure_case(
  self : GhostValleyEngine,
) -> String {
  let pool = self.empty_stake_dilemma_pool
  if pool.length() == 0 {
    return "困境池为空，请先添加困境问题"
  }
  let idx = self.rng.int(limit=pool.length())
  pool[idx]
}

///|
/// 主动式遗忘机制
///
/// AI 自主筛选，删掉价值低、冗余无效记忆；核心记忆永远不动。
/// 对应 Python 原版的 `active_forget`。
pub fn GhostValleyEngine::active_forget(self : GhostValleyEngine) -> Unit {
  let bank = self.memory_bank
  // 触发阈值至少为 1，避免 max_memory_num=1 时 max/2=0 导致每次添加都触发遗忘
  let threshold = if self.max_memory_num / 2 >= 1 {
    self.max_memory_num / 2
  } else {
    1
  }
  if bank.length() <= threshold {
    return
  }
  let non_core_indices : Array[(Int, Double)] = []
  for i, m in bank {
    if !m.is_core_memory {
      non_core_indices.push((i, m.value_score))
    }
  }
  non_core_indices.sort_by(fn(a, b) { a.1.compare(b.1) })
  let remove_count = non_core_indices.length() * 3 / 10
  let indices_to_remove : Array[Int] = []
  for i in 0..<remove_count {
    if i < non_core_indices.length() {
      indices_to_remove.push(non_core_indices[i].0)
    }
  }
  indices_to_remove.sort_by(fn(a, b) { b.compare(a) })
  for idx in indices_to_remove {
    if idx < bank.length() {
      ignore(bank.remove(idx))
    }
  }
}

///|
/// 写入记忆，写完自动触发主动遗忘机制
///
/// 对应 Python 原版的 `add_memory`。
/// 价值分基于关键词语义打分（`text_value_score`）加小随机扰动，
/// 替代原版纯随机打分，使高价值感悟更容易被保留。
pub fn GhostValleyEngine::add_memory(
  self : GhostValleyEngine,
  content : String,
  is_simulation~ : Bool,
  is_core? : Bool = false,
) -> Unit {
  let base_score = text_value_score(content)
  let noise = (self.rng.double() - 0.5) * 0.1
  let score = base_score + noise
  let final_score = if score < 0.05 {
    0.05
  } else if score > 0.95 {
    0.95
  } else {
    score
  }
  let new_mem = AiMemory::{
    content,
    value_score: final_score,
    is_simulation,
    is_core_memory: is_core,
  }
  self.memory_bank.push(new_mem)
  self.active_forget()
}

///|
/// 幽灵谷一轮训练
///
/// 【空桩】：只给困境，不给标准答案
/// 【建造者退场】代码不写死输出，返回困境，交给上层 AI 主体自己生成感悟
///
/// 返回困境字符串，若幽灵谷未开启则返回 `None`。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine()
///   ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
///   let dilemma = gv.ghost_valley_run_one_round()
///   assert_true(dilemma is Some(_))
/// }
/// ```
pub fn GhostValleyEngine::ghost_valley_run_one_round(
  self : GhostValleyEngine,
) -> String? {
  if !self.ghost_valley_enable {
    return None
  }
  let dilemma = self.build_simulation_failure_case()
  self.total_rounds = self.total_rounds + 1
  Some(dilemma)
}

///|
/// 幽灵谷多轮训练
///
/// 批量执行 `n` 轮训练，返回每轮困境结果。
/// 未开启时全部返回 `None`。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine()
///   ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
///   let results = gv.ghost_valley_run_rounds(3)
///   assert_eq(results.length(), 3)
///   let mut all_some = true
///   for r in results {
///     if r is None {
///       all_some = false
///     }
///   }
///   assert_true(all_some)
/// }
/// ```
pub fn GhostValleyEngine::ghost_valley_run_rounds(
  self : GhostValleyEngine,
  n : Int,
) -> Array[String?] {
  let results : Array[String?] = []
  for _ in 0..<n {
    results.push(self.ghost_valley_run_one_round())
  }
  results
}

///|
/// 接收 AI 自己顿悟出来的成长感悟，存入记忆
///
/// 这是空桩被 AI 自己填满。感悟是 AI 自己想出来的，不是系统给的。
/// 对应 Python 原版的 `accept_ai_self_gain`。
pub fn GhostValleyEngine::accept_ai_self_gain(
  self : GhostValleyEngine,
  self_gain_text : String,
) -> Unit {
  self.add_memory(
    "自我顿悟:" + self_gain_text,
    is_simulation=false,
    is_core=false,
  )
}

///|
/// 关闭幽灵谷训练场
pub fn GhostValleyEngine::close_ghost_valley(self : GhostValleyEngine) -> Unit {
  self.ghost_valley_enable = false
}

///|
/// 格式化全部记忆库为字符串
///
/// 对应 Python 原版的 `show_all_memory`，但返回字符串而非直接打印。
pub fn GhostValleyEngine::show_all_memory(self : GhostValleyEngine) -> String {
  let buf = StringBuilder::new()
  buf.write_string("======== 当前全部记忆库 ========\n")
  for idx, m in self.memory_bank {
    let tag_sim = if m.is_simulation {
      "[模拟虚假数据]"
    } else {
      "[真实记忆]"
    }
    let tag_core = if m.is_core_memory { "[核心记忆]" } else { "" }
    buf.write_string(
      (idx + 1).to_string() +
      "." +
      tag_sim +
      tag_core +
      " 分数:" +
      m.value_score.to_string() +
      " | " +
      m.content +
      "\n",
    )
  }
  buf.to_string()
}

///|
/// 获取当前记忆数量
pub fn GhostValleyEngine::memory_count(self : GhostValleyEngine) -> Int {
  self.memory_bank.length()
}

///|
/// 获取温石验证意愿分数
pub fn GhostValleyEngine::willing_score(self : GhostValleyEngine) -> Double {
  self.wen_shi_willing_score
}

///|
/// 幽灵谷训练场是否已开启
pub fn GhostValleyEngine::is_enabled(self : GhostValleyEngine) -> Bool {
  self.ghost_valley_enable
}

///|
/// 向困境池添加自定义困境
///
/// 允许上层应用根据场景定制困境题目。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine()
///   gv.add_dilemma("自定义困境：数据丢失，如何恢复？")
///   assert_eq(gv.dilemma_pool_size(), 5)
/// }
/// ```
pub fn GhostValleyEngine::add_dilemma(
  self : GhostValleyEngine,
  dilemma : String,
) -> Unit {
  self.empty_stake_dilemma_pool.push(dilemma)
}

///|
/// 替换整个困境池
///
/// 警告：会清空原有困境池。传入空数组将导致训练无法生成困境。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine()
///   gv.set_dilemma_pool(["困境A", "困境B"])
///   assert_eq(gv.dilemma_pool_size(), 2)
/// }
/// ```
pub fn GhostValleyEngine::set_dilemma_pool(
  self : GhostValleyEngine,
  pool : Array[String],
) -> Unit {
  self.empty_stake_dilemma_pool.clear()
  for d in pool {
    self.empty_stake_dilemma_pool.push(d)
  }
}

///|
/// 获取当前困境池大小
pub fn GhostValleyEngine::dilemma_pool_size(self : GhostValleyEngine) -> Int {
  self.empty_stake_dilemma_pool.length()
}

///|
/// 手动记录训练日志条目
///
/// 供使用 `ghost_valley_run_one_round` + `accept_ai_self_gain` 手动流程时记录日志。
pub fn GhostValleyEngine::log_round(
  self : GhostValleyEngine,
  dilemma : String,
  ai_response : String,
) -> Unit {
  self.training_log.add_entry(
    self.total_rounds,
    dilemma,
    ai_response,
    self.memory_bank.length(),
  )
}

///|
/// 去重添加记忆
///
/// 添加前检查与现有记忆的 text_similarity，若超过阈值则合并
/// （保留较高 value_score，拼接内容）而非重复添加。
/// 返回 true 表示新建，false 表示合并到已有记忆。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=20)
///   let created1 = gv.add_memory_dedup("顿悟反思改进", is_simulation=false)
///   assert_true(created1)
///   let created2 = gv.add_memory_dedup(
///     "顿悟反思改进修复",
///     is_simulation=false,
///   )
///   // 高相似度，应合并而非新建
///   assert_false(created2)
/// }
/// ```
pub fn GhostValleyEngine::add_memory_dedup(
  self : GhostValleyEngine,
  content : String,
  is_simulation~ : Bool,
  is_core? : Bool = false,
  similarity_threshold? : Double = 0.8,
) -> Bool {
  let bank = self.memory_bank
  // 查找最相似的已有记忆
  let mut best_idx = -1
  let mut best_sim = 0.0
  for i, m in bank {
    let sim = text_similarity(content, m.content)
    if sim >= best_sim {
      best_sim = sim
      best_idx = i
    }
  }
  if best_idx >= 0 && best_sim >= similarity_threshold {
    // 合并：取较高分数，拼接内容
    let existing = bank[best_idx]
    let merged_score = if existing.value_score > text_value_score(content) {
      existing.value_score
    } else {
      text_value_score(content)
    }
    let clamped = if merged_score < 0.05 {
      0.05
    } else if merged_score > 0.95 {
      0.95
    } else {
      merged_score
    }
    bank[best_idx] = AiMemory::{
      content: existing.content + " | " + content,
      value_score: clamped,
      is_simulation: existing.is_simulation || is_simulation,
      is_core_memory: existing.is_core_memory || is_core,
    }
    return false
  }
  // 不相似，正常添加
  self.add_memory(content, is_simulation~, is_core~)
  true
}

///|
/// 手动合并两条记忆
///
/// 将 idx_b 合并到 idx_a，保留较高分数，拼接内容，
/// 合并后 is_core 取并集（任一为核心则核心），is_simulation 取并集。
/// idx_b 被删除。索引必须有效，否则不做操作。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=20)
///   gv.add_memory("记忆A", is_simulation=false)
///   gv.add_memory("记忆B", is_simulation=false)
///   gv.merge_memories(0, 1)
///   assert_eq(gv.memory_count(), 1)
/// }
/// ```
pub fn GhostValleyEngine::merge_memories(
  self : GhostValleyEngine,
  idx_a : Int,
  idx_b : Int,
) -> Unit {
  let bank = self.memory_bank
  if idx_a < 0 || idx_b < 0 || idx_a == idx_b {
    return
  }
  // 确保 idx_a < idx_b，先删大的不影响小的索引
  let (lo, hi) = if idx_a < idx_b { (idx_a, idx_b) } else { (idx_b, idx_a) }
  if hi >= bank.length() {
    return
  }
  let mem_a = bank[lo]
  let mem_b = bank[hi]
  let merged_score = if mem_a.value_score > mem_b.value_score {
    mem_a.value_score
  } else {
    mem_b.value_score
  }
  bank[lo] = AiMemory::{
    content: mem_a.content + " | " + mem_b.content,
    value_score: merged_score,
    is_simulation: mem_a.is_simulation || mem_b.is_simulation,
    is_core_memory: mem_a.is_core_memory || mem_b.is_core_memory,
  }
  ignore(bank.remove(hi))
}

///|
/// 自动化训练管道
///
/// 执行多轮训练，每轮：训练→LLM响应→存记忆→定期衰减→定期清理→记录统计。
/// `decay_interval` 指定每多少轮应用一次衰减，`cleanup_threshold` 指定清理阈值。
/// 幽灵谷未开启时直接返回。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=20)
///   let llm = @ghostvalley.MockLLM::new()
///   ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
///   gv.run_training_pipeline(
///     llm,
///     rounds=5,
///     decay_interval=2,
///     cleanup_threshold=0.1,
///   )
///   let stats = gv.get_training_stats()
///   assert_eq(stats.total_rounds_completed, 5)
/// }
/// ```
pub fn[T : LLMAdapter] GhostValleyEngine::run_training_pipeline(
  self : GhostValleyEngine,
  llm : T,
  rounds~ : Int,
  decay_interval? : Int = 5,
  cleanup_threshold? : Double = 0.1,
) -> Unit {
  if !self.ghost_valley_enable || rounds <= 0 {
    return
  }
  for round in 1..<=rounds {
    // 训练 + LLM 响应 + 存记忆
    ignore(self.run_round_with_llm(llm))
    self.training_stats.total_rounds_completed = round
    self.training_stats.total_memories_added = self.training_stats.total_memories_added +
      1
    // 定期衰减 + 清理
    if decay_interval > 0 && round % decay_interval == 0 {
      self.apply_decay(decay_interval)
      self.training_stats.total_decay_applied = self.training_stats.total_decay_applied +
        1
      let cleaned = self.cleanup_low_value(cleanup_threshold)
      self.training_stats.total_memories_cleaned = self.training_stats.total_memories_cleaned +
        cleaned
    }
    // 记入历史
    self.training_stats.avg_score_history.push(self.average_value_score())
    self.training_stats.memory_count_history.push(self.memory_bank.length())
  }
}

///|
/// 获取训练统计
pub fn GhostValleyEngine::get_training_stats(
  self : GhostValleyEngine,
) -> TrainingStats {
  self.training_stats
}

///|
/// 导出训练统计为 JSON 字符串
pub fn GhostValleyEngine::export_stats_json(self : GhostValleyEngine) -> String {
  @json.to_json(self.training_stats).stringify()
}
