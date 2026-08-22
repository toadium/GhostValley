///|
/// 序列化记忆库为 JSON
///
/// 将全部记忆导出为 JSON 数组，可用于持久化存储或跨会话传输。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine()
///   gv.add_memory("测试记忆", is_simulation=false)
///   let json = gv.save_memory()
///   assert_true(json.stringify().contains("测试记忆"))
/// }
/// ```
pub fn GhostValleyEngine::save_memory(self : GhostValleyEngine) -> Json {
  let arr : Array[Json] = []
  for m in self.memory_bank {
    arr.push(@json.to_json(m))
  }
  Json::array(arr)
}

///|
/// 从 JSON 加载记忆库
///
/// 解析 JSON 数组，替换当前记忆库。
/// 无效数据将被跳过，不中断加载。
pub fn GhostValleyEngine::load_memory(
  self : GhostValleyEngine,
  data : Json,
) -> Unit {
  match data {
    Json::Array(items) => {
      self.memory_bank.clear()
      for item in items {
        match item {
          Json::Object(obj) => {
            let content_opt = match obj.get("content") {
              Some(Json::String(s)) => Some(s)
              _ => None
            }
            let score_opt = match obj.get("value_score") {
              Some(Json::Number(n, ..)) => Some(n)
              _ => None
            }
            let sim_opt = match obj.get("is_simulation") {
              Some(Json::True) => Some(true)
              Some(Json::False) => Some(false)
              _ => None
            }
            let core_opt = match obj.get("is_core_memory") {
              Some(Json::True) => Some(true)
              Some(Json::False) => Some(false)
              _ => None
            }
            match (content_opt, score_opt, sim_opt, core_opt) {
              (Some(c), Some(s), Some(sim), Some(core)) => {
                // clamp value_score to [0.05, 0.95] 防止损坏数据
                let clamped_score = if s < 0.05 {
                  0.05
                } else if s > 0.95 {
                  0.95
                } else {
                  s
                }
                self.memory_bank.push(AiMemory::{
                  content: c,
                  value_score: clamped_score,
                  is_simulation: sim,
                  is_core_memory: core,
                })
              }
              _ => ()
            }
          }
          _ => ()
        }
      }
    }
    _ => ()
  }
}

///|
/// 序列化记忆库为 JSON 字符串
///
/// 便捷方法，等价于 `save_memory().stringify()`。
pub fn GhostValleyEngine::save_memory_string(
  self : GhostValleyEngine,
) -> String {
  self.save_memory().stringify()
}

///|
/// 从 JSON 字符串加载记忆库
///
/// 便捷方法，解析 JSON 字符串后调用 `load_memory`。
/// 解析失败时不做任何操作。
pub fn GhostValleyEngine::load_memory_string(
  self : GhostValleyEngine,
  json_str : String,
) -> Unit {
  try {
    let data = @json.parse(json_str)
    self.load_memory(data)
  } catch {
    _ => ()
  }
}

///|
/// 引擎状态快照
///
/// 包含完整引擎状态：记忆库 + 训练日志 + 统计 + 配置 + 轮次。
/// 用于跨会话保存/恢复训练进度。
pub(all) struct EngineState {
  memory_bank : Array[AiMemory]
  training_log : TrainingLog
  training_stats : TrainingStats
  max_memory_num : Int
  ghost_valley_enable : Bool
  total_rounds : Int
} derive(Debug, ToJson, FromJson)

///|
pub extend EngineState with @debug.Debug::{to_repr}

///|
pub extend EngineState with ToJson::{to_json}

///|
pub extend EngineState with FromJson::{from_json}

///|
/// 保存完整引擎状态为 JSON 字符串
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=20)
///   gv.add_memory("测试记忆", is_simulation=false)
///   let state_json = gv.save_engine_state()
///   assert_true(state_json.contains("memory_bank"))
///   assert_true(state_json.contains("max_memory_num"))
/// }
/// ```
pub fn GhostValleyEngine::save_engine_state(self : GhostValleyEngine) -> String {
  let state : EngineState = {
    memory_bank: {
      let arr : Array[AiMemory] = []
      for m in self.memory_bank {
        arr.push(m)
      }
      arr
    },
    training_log: self.training_log,
    training_stats: self.training_stats,
    max_memory_num: self.max_memory_num,
    ghost_valley_enable: self.ghost_valley_enable,
    total_rounds: self.total_rounds,
  }
  @json.to_json(state).stringify()
}

///|
/// 从 JSON 字符串恢复完整引擎状态
///
/// 解析失败时不修改当前状态。
///
/// # Example
/// ```mbt check
/// test {
///   let gv1 = @ghostvalley.new_engine(max_memory_num=20)
///   gv1.add_memory("测试记忆", is_simulation=false)
///   let state_json = gv1.save_engine_state()
///   let gv2 = @ghostvalley.new_engine()
///   gv2.load_engine_state(state_json)
///   assert_eq(gv2.memory_count(), 1)
///   assert_eq(gv2.max_memory_num, 20)
/// }
/// ```
pub fn GhostValleyEngine::load_engine_state(
  self : GhostValleyEngine,
  json_str : String,
) -> Unit {
  try {
    let json = @json.parse(json_str)
    let obj = json.as_object().unwrap()
    // 恢复记忆
    self.memory_bank.clear()
    let mem_arr = obj["memory_bank"].as_array().unwrap()
    for i in 0..<mem_arr.length() {
      let m = mem_arr[i].as_object().unwrap()
      let score = {
        let raw = m["value_score"].as_number().unwrap()
        if raw < 0.05 {
          0.05
        } else if raw > 0.95 {
          0.95
        } else {
          raw
        }
      }
      self.memory_bank.push(AiMemory::{
        content: m["content"].as_string().unwrap(),
        value_score: score,
        is_simulation: m["is_simulation"].as_bool().unwrap(),
        is_core_memory: m["is_core_memory"].as_bool().unwrap(),
      })
    }
    // 恢复统计
    let stats_obj = obj["training_stats"].as_object().unwrap()
    self.training_stats.total_rounds_completed = stats_obj["total_rounds_completed"]
      .as_number()
      .unwrap()
      .to_int()
    self.training_stats.total_memories_added = stats_obj["total_memories_added"]
      .as_number()
      .unwrap()
      .to_int()
    self.training_stats.total_memories_cleaned = stats_obj["total_memories_cleaned"]
      .as_number()
      .unwrap()
      .to_int()
    self.training_stats.total_decay_applied = stats_obj["total_decay_applied"]
      .as_number()
      .unwrap()
      .to_int()
    self.training_stats.avg_score_history.clear()
    let avg_arr = stats_obj["avg_score_history"].as_array().unwrap()
    for i in 0..<avg_arr.length() {
      self.training_stats.avg_score_history.push(
        avg_arr[i].as_number().unwrap(),
      )
    }
    self.training_stats.memory_count_history.clear()
    let mc_arr = stats_obj["memory_count_history"].as_array().unwrap()
    for i in 0..<mc_arr.length() {
      self.training_stats.memory_count_history.push(
        mc_arr[i].as_number().unwrap().to_int(),
      )
    }
    // 恢复配置
    self.max_memory_num = obj["max_memory_num"].as_number().unwrap().to_int()
    self.ghost_valley_enable = obj["ghost_valley_enable"].as_bool().unwrap()
    self.total_rounds = obj["total_rounds"].as_number().unwrap().to_int()
  } catch {
    _ => ()
  }
}
