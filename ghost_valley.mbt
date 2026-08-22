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
