///|
/// 训练报告
///
/// 记录幽灵谷训练的完整状态快照，用于分析和监控。
pub(all) struct TrainingReport {
  total_rounds : Int
  total_memories : Int
  core_memories : Int
  simulation_memories : Int
  real_memories : Int
  willing_score : Double
  is_enabled : Bool
  max_capacity : Int
} derive(Debug, ToJson)

///|
pub extend TrainingReport with @debug.Debug::{to_repr}

///|
pub extend TrainingReport with ToJson::{to_json}

///|
/// 生成训练报告
///
/// 采集当前引擎状态，返回结构化报告。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine()
///   ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
///   gv.add_memory("顿悟", is_simulation=false)
///   let report = gv.training_report()
///   assert_true(report.total_memories > 0)
/// }
/// ```
pub fn GhostValleyEngine::training_report(
  self : GhostValleyEngine,
) -> TrainingReport {
  let mut core = 0
  let mut sim = 0
  let mut real = 0
  for m in self.memory_bank {
    if m.is_core_memory {
      core = core + 1
    }
    if m.is_simulation {
      sim = sim + 1
    } else {
      real = real + 1
    }
  }
  TrainingReport::{
    total_rounds: self.total_rounds,
    total_memories: self.memory_bank.length(),
    core_memories: core,
    simulation_memories: sim,
    real_memories: real,
    willing_score: self.wen_shi_willing_score,
    is_enabled: self.ghost_valley_enable,
    max_capacity: self.max_memory_num,
  }
}

///|
/// 训练报告转 JSON 字符串
///
/// 便捷方法，等价于 `training_report().to_json().stringify()`。
pub fn GhostValleyEngine::training_report_json(
  self : GhostValleyEngine,
) -> String {
  @json.to_json(self.training_report()).stringify()
}

///|
/// 训练报告格式化输出
pub fn TrainingReport::format(self : TrainingReport) -> String {
  let buf = StringBuilder::new()
  buf <+ "======== 幽灵谷训练报告 ========\n"
  buf <+ "训练轮次: \{self.total_rounds}\n"
  buf <+ "记忆总数: \{self.total_memories} / \{self.max_capacity}\n"
  buf <+ "  - 核心记忆: \{self.core_memories}\n"
  buf <+ "  - 模拟记忆: \{self.simulation_memories}\n"
  buf <+ "  - 真实记忆: \{self.real_memories}\n"
  buf <+ "意愿分数: \{self.willing_score}\n"
  buf <+
    "训练场状态: \{if self.is_enabled { "开启" } else { "关闭" }}\n"
  buf.to_string()
}
