///|
/// 训练统计追踪
///
/// 跨轮次记录训练过程中的关键指标，用于分析训练效果和调参。
/// 由 `run_training_pipeline` 自动更新，也可手动更新。
pub(all) struct TrainingStats {
  mut total_rounds_completed : Int
  mut total_memories_added : Int
  mut total_memories_cleaned : Int
  mut total_decay_applied : Int
  avg_score_history : Array[Double]
  memory_count_history : Array[Int]
} derive(Debug, ToJson)

///|
pub extend TrainingStats with @debug.Debug::{to_repr}

///|
pub extend TrainingStats with ToJson::{to_json}

///|
/// 创建空的训练统计
pub fn TrainingStats::new() -> TrainingStats {
  {
    total_rounds_completed: 0,
    total_memories_added: 0,
    total_memories_cleaned: 0,
    total_decay_applied: 0,
    avg_score_history: [],
    memory_count_history: [],
  }
}

///|
/// 记算记忆保留率
///
/// 返回当前记忆数 / 总添加记忆数。无添加时返回 1.0。
pub fn TrainingStats::retention_rate(self : TrainingStats) -> Double {
  if self.total_memories_added == 0 {
    return 1.0
  }
  let current = if self.memory_count_history.length() > 0 {
    self.memory_count_history[self.memory_count_history.length() - 1]
  } else {
    0
  }
  current.to_double() / self.total_memories_added.to_double()
}

///|
/// 获取平均分变化趋势
///
/// 返回首末平均分之差。正值表示改善，负值表示退化。
pub fn TrainingStats::score_trend(self : TrainingStats) -> Double {
  let hist = self.avg_score_history
  if hist.length() < 2 {
    return 0.0
  }
  hist[hist.length() - 1] - hist[0]
}

///|
/// 格式化输出统计信息
pub fn TrainingStats::format(self : TrainingStats) -> String {
  let buf = StringBuilder::new()
  buf.write_string("======== 训练统计 ========\n")
  buf.write_string("完成轮次: ")
  buf.write_string(self.total_rounds_completed.to_string())
  buf.write_string("\n")
  buf.write_string("总添加记忆: ")
  buf.write_string(self.total_memories_added.to_string())
  buf.write_string("\n")
  buf.write_string("总清理记忆: ")
  buf.write_string(self.total_memories_cleaned.to_string())
  buf.write_string("\n")
  buf.write_string("衰减次数: ")
  buf.write_string(self.total_decay_applied.to_string())
  buf.write_string("\n")
  buf.write_string("保留率: ")
  buf.write_string(self.retention_rate().to_string())
  buf.write_string("\n")
  buf.write_string("平均分趋势: ")
  buf.write_string(self.score_trend().to_string())
  buf.write_string("\n")
  buf.to_string()
}
