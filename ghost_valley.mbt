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
  value_score : Double
  is_simulation : Bool
  is_core_memory : Bool
} derive(Debug, Eq)

///|
pub extend AiMemory with @debug.Debug::{to_repr}

///|
pub extend AiMemory with Eq::{equal, not_equal}

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
  empty_stake_dilemma_pool : Array[String]
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
    empty_stake_dilemma_pool: [
      "任务执行全部失败，所有输出全部错误，该怎么调整？",
      "收到大量负面反馈，逻辑全部被推翻，如何修复自身？",
      "新知识和旧记忆冲突，该保留什么舍弃什么？", "任务彻底崩盘，没有外部指导，如何自我修复？",
    ],
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
pub fn GhostValleyEngine::build_simulation_failure_case(
  self : GhostValleyEngine,
) -> String {
  let pool = self.empty_stake_dilemma_pool
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
  if bank.length() <= self.max_memory_num / 2 {
    return // 空间充足，不用清理
  }
  // 筛选非核心记忆，按价值分升序排序
  let non_core : Array[AiMemory] = []
  for m in bank {
    if !m.is_core_memory {
      non_core.push(m)
    }
  }
  // 按价值分排序（升序）
  non_core.sort_by(fn(a, b) { a.value_score.compare(b.value_score) })
  let remove_count = non_core.length() * 3 / 10 // 30%
  for i in 0..<remove_count {
    if i < non_core.length() {
      let bad_mem = non_core[i]
      // 从 memory_bank 中移除
      let mut found_idx = -1
      for j in 0..<bank.length() {
        if bank[j] == bad_mem {
          found_idx = j
          break
        }
      }
      if found_idx >= 0 {
        ignore(bank.remove(found_idx))
      }
    }
  }
}

///|
/// 写入记忆，写完自动触发主动遗忘机制
///
/// 对应 Python 原版的 `add_memory`。
/// 模拟 AI 给这条记忆打价值分（随机 0.2~0.95）。
pub fn GhostValleyEngine::add_memory(
  self : GhostValleyEngine,
  content : String,
  is_simulation~ : Bool,
  is_core? : Bool = false,
) -> Unit {
  // 模拟 AI 给自己这条记忆打价值分
  let score = 0.2 + 0.75 * self.rng.double()
  let new_mem = AiMemory::{
    content,
    value_score: score,
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
  Some(dilemma)
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
