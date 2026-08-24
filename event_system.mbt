// ============================================================
// Phase 3: 事件系统
// ============================================================

///|
/// 训练事件类型
///
/// 训练管道中各关键节点自动记录事件。
pub(all) enum TrainingEvent {
  MemoryAdded
  MemoryForgotten
  DecayApplied
  CleanupDone
  RoundCompleted
} derive(Debug, Eq, ToJson, FromJson)

///|
pub extend TrainingEvent with @debug.Debug::{to_repr}

///|
pub extend TrainingEvent with Eq::{equal, not_equal}

///|
pub extend TrainingEvent with ToJson::{to_json}

///|
pub extend TrainingEvent with FromJson::{from_json}

///|
/// 事件记录
pub(all) struct EventRecord {
  event : String
  round : Int
  detail : String
} derive(Debug, ToJson, FromJson)

///|
pub extend EventRecord with @debug.Debug::{to_repr}

///|
pub extend EventRecord with ToJson::{to_json}

///|
pub extend EventRecord with FromJson::{from_json}

///|
/// 事件系统
///
/// 记录训练过程中触发的事件，支持回调注册。
/// 事件日志可导出为 JSON，回调不参与序列化。
pub(all) struct EventSystem {
  mut event_log : Array[EventRecord]
  mut callbacks : Array[(String, (String, Int) -> Unit)]
}

///|
/// 创建空的事件系统
pub fn EventSystem::new() -> EventSystem {
  { event_log: [], callbacks: [] }
}

///|
/// 注册事件回调
///
/// 当指定类型的事件触发时，调用 handler(detail, round)。
/// `event_type` 为事件名称字符串（如 "MemoryAdded"）。
pub fn EventSystem::register_callback(
  self : EventSystem,
  event_type : String,
  handler : (String, Int) -> Unit,
) -> Unit {
  self.callbacks.push((event_type, handler))
}

///|
/// 触发事件
///
/// 记录事件到日志并调用匹配的回调。
pub fn EventSystem::emit(
  self : EventSystem,
  event_type : String,
  round : Int,
  detail : String,
) -> Unit {
  self.event_log.push(EventRecord::{ event: event_type, round, detail })
  for cb in self.callbacks {
    let (etype, handler) = cb
    if etype == event_type {
      handler(detail, round)
    }
  }
}

///|
/// 获取事件日志
pub fn EventSystem::get_log(self : EventSystem) -> Array[EventRecord] {
  self.event_log
}

///|
/// 统计指定类型事件数量
pub fn EventSystem::event_count(self : EventSystem, event_type : String) -> Int {
  let mut count = 0
  for r in self.event_log {
    if r.event == event_type {
      count = count + 1
    }
  }
  count
}

///|
/// 事件日志转 JSON 字符串
pub fn EventSystem::to_json_string(self : EventSystem) -> String {
  let arr : Array[Json] = []
  for r in self.event_log {
    arr.push(@json.to_json(r))
  }
  Json::array(arr).stringify()
}

///|
/// 事件类型转字符串
pub fn TrainingEvent::to_string(self : TrainingEvent) -> String {
  match self {
    MemoryAdded => "MemoryAdded"
    MemoryForgotten => "MemoryForgotten"
    DecayApplied => "DecayApplied"
    CleanupDone => "CleanupDone"
    RoundCompleted => "RoundCompleted"
  }
}
