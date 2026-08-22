///|
/// 训练日志条目
///
/// 记录单轮训练的困境、AI 响应及训练后记忆库状态。
pub(all) struct TrainingLogEntry {
  round_num : Int
  dilemma : String
  ai_response : String
  memory_count_after : Int
} derive(Debug, Eq, ToJson, FromJson)

///|
pub extend TrainingLogEntry with @debug.Debug::{to_repr}

///|
pub extend TrainingLogEntry with Eq::{equal, not_equal}

///|
pub extend TrainingLogEntry with ToJson::{to_json}

///|
pub extend TrainingLogEntry with FromJson::{from_json}

///|
/// 训练日志
///
/// 按时间顺序记录所有训练轮次，支持 JSON 导出和格式化输出。
pub(all) struct TrainingLog {
  entries : Array[TrainingLogEntry]
} derive(Debug, FromJson)

///|
pub extend TrainingLog with @debug.Debug::{to_repr}

///|
pub extend TrainingLog with FromJson::{from_json}

///|
/// 创建空的训练日志
pub fn TrainingLog::new() -> TrainingLog {
  { entries: [] }
}

///|
/// 添加日志条目
pub fn TrainingLog::add_entry(
  self : TrainingLog,
  round_num : Int,
  dilemma : String,
  ai_response : String,
  memory_count_after : Int,
) -> Unit {
  self.entries.push(TrainingLogEntry::{
    round_num,
    dilemma,
    ai_response,
    memory_count_after,
  })
}

///|
/// 获取日志条目数量
pub fn TrainingLog::length(self : TrainingLog) -> Int {
  self.entries.length()
}

///|
/// 训练日志转 JSON 数组
pub impl ToJson for TrainingLog with fn to_json(self) {
  let arr : Array[Json] = []
  for e in self.entries {
    arr.push(@json.to_json(e))
  }
  Json::array(arr)
}

///|
pub extend TrainingLog with ToJson::{to_json}

///|
/// 训练日志格式化输出
pub fn TrainingLog::format(self : TrainingLog) -> String {
  let buf = StringBuilder::new()
  buf <+ "======== 幽灵谷训练日志 ========\n"
  buf <+ "共 \{self.entries.length()} 轮训练记录\n"
  buf <+ "--------------------------------\n"
  for e in self.entries {
    buf <+ "[第 \{e.round_num} 轮]\n"
    buf <+ "  困境: \{e.dilemma}\n"
    buf <+ "  AI响应: \{e.ai_response}\n"
    buf <+ "  训练后记忆数: \{e.memory_count_after}\n"
    buf <+ "--------------------------------\n"
  }
  buf.to_string()
}

///|
/// 获取引擎内置训练日志
///
/// 引擎自动记录每轮训练的困境和 AI 响应。
pub fn GhostValleyEngine::get_training_log(
  self : GhostValleyEngine,
) -> TrainingLog {
  self.training_log
}

///|
/// 导出训练日志为 JSON
pub fn GhostValleyEngine::export_training_log_json(
  self : GhostValleyEngine,
) -> Json {
  @json.to_json(self.training_log)
}

///|
/// 导出训练日志为 JSON 字符串
pub fn GhostValleyEngine::export_training_log_string(
  self : GhostValleyEngine,
) -> String {
  self.export_training_log_json().stringify()
}

///|
/// 导出训练日志格式化字符串
pub fn GhostValleyEngine::export_training_log_format(
  self : GhostValleyEngine,
) -> String {
  self.training_log.format()
}
