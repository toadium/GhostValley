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
