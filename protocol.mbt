// ============================================================
// Phase 3 (v1.11.0): 训练协议 + 安全边界 + 审计日志
// ============================================================

///|
/// 训练安全协议
///
/// 定义训练过程中的安全边界。违反协议时触发冷却期或暂停训练。
///
/// - `max_stress_level`：允许的最大压力水平（默认 0.85）
/// - `min_confidence`：允许的最低信心水平（默认 0.15）
/// - `max_rounds_without_improvement`：连续无改善的最大轮次（默认 10）
/// - `cooldown_rounds`：触发冷却期后暂停的轮次数（默认 3）
///
/// # Example
/// ```mbt check
/// test {
///   let p = @ghostvalley.TrainingProtocol::default()
///   assert_true(p.max_stress_level > 0.0)
/// }
/// ```
pub(all) struct TrainingProtocol {
  max_stress_level : Double
  min_confidence : Double
  max_rounds_without_improvement : Int
  cooldown_rounds : Int
} derive(Debug, ToJson, FromJson)

///|
pub extend TrainingProtocol with @debug.Debug::{to_repr}

///|
pub extend TrainingProtocol with ToJson::{to_json}

///|
pub extend TrainingProtocol with FromJson::{from_json}

///|
/// 协议违反
///
/// 记录一次安全协议违反的详情。
pub(all) struct ProtocolViolation {
  violation_type : String
  severity : String // "critical" | "warning" | "info"
  message : String
  current_value : Double
  threshold : Double
} derive(Debug, ToJson, FromJson)

///|
pub extend ProtocolViolation with @debug.Debug::{to_repr}

///|
pub extend ProtocolViolation with ToJson::{to_json}

///|
pub extend ProtocolViolation with FromJson::{from_json}

///|
/// 风险等级
pub(all) enum RiskLevel {
  Low
  Medium
  High
  Critical
} derive(Debug, Eq, ToJson, FromJson)

///|
pub extend RiskLevel with @debug.Debug::{to_repr}

///|
pub extend RiskLevel with Eq::{equal, not_equal}

///|
pub extend RiskLevel with ToJson::{to_json}

///|
pub extend RiskLevel with FromJson::{from_json}

///|
/// 审计日志条目
///
/// 记录一次可审计的操作。
pub(all) struct AuditEntry {
  timestamp : Int
  action : String
  actor : String
  detail : String
  risk_level : RiskLevel
} derive(Debug, ToJson, FromJson)

///|
pub extend AuditEntry with @debug.Debug::{to_repr}

///|
pub extend AuditEntry with ToJson::{to_json}

///|
pub extend AuditEntry with FromJson::{from_json}

///|
/// 审计日志
///
/// 收集训练过程中所有可审计操作，支持按动作和风险等级查询。
///
/// # Example
/// ```mbt check
/// test {
///   let log = @ghostvalley.AuditLog::new()
///   log.add_entry(
///     timestamp=1,
///     action="training_start",
///     actor="system",
///     detail="开始训练",
///     risk_level=@ghostvalley.Low,
///   )
///   assert_eq(log.entry_count(), 1)
/// }
/// ```
pub(all) struct AuditLog {
  mut entries : Array[AuditEntry]
  mut current_timestamp : Int
} derive(Debug, ToJson, FromJson)

///|
pub extend AuditLog with @debug.Debug::{to_repr}

///|
pub extend AuditLog with ToJson::{to_json}

///|
pub extend AuditLog with FromJson::{from_json}

///|
/// 默认安全协议
pub fn TrainingProtocol::default() -> TrainingProtocol {
  {
    max_stress_level: 0.85,
    min_confidence: 0.15,
    max_rounds_without_improvement: 10,
    cooldown_rounds: 3,
  }
}

///|
/// 严格安全协议
///
/// 更低的压力上限、更高的信心下限、更短的容忍期。
pub fn TrainingProtocol::strict() -> TrainingProtocol {
  {
    max_stress_level: 0.7,
    min_confidence: 0.25,
    max_rounds_without_improvement: 5,
    cooldown_rounds: 5,
  }
}

///|
/// 检查协议违反
///
/// 根据当前情绪状态和训练统计检查是否违反安全协议。
/// 返回所有违反项列表，空列表表示无违反。
pub fn protocol_check(
  protocol : TrainingProtocol,
  emotion : EmotionState,
  rounds_without_improvement : Int,
) -> Array[ProtocolViolation] {
  let violations : Array[ProtocolViolation] = []
  // 检查压力超限
  if emotion.stress_level > protocol.max_stress_level {
    violations.push(ProtocolViolation::{
      violation_type: "stress_exceeded",
      severity: "critical",
      message: "压力水平超过安全上限",
      current_value: emotion.stress_level,
      threshold: protocol.max_stress_level,
    })
  }
  // 检查信心过低
  if emotion.confidence < protocol.min_confidence {
    violations.push(ProtocolViolation::{
      violation_type: "confidence_too_low",
      severity: "critical",
      message: "信心水平低于安全下限",
      current_value: emotion.confidence,
      threshold: protocol.min_confidence,
    })
  }
  // 检查连续无改善
  if rounds_without_improvement > protocol.max_rounds_without_improvement {
    violations.push(ProtocolViolation::{
      violation_type: "no_improvement",
      severity: "warning",
      message: "连续无改善轮次超过容忍上限",
      current_value: rounds_without_improvement.to_double(),
      threshold: protocol.max_rounds_without_improvement.to_double(),
    })
  }
  // 检查崩溃
  if emotion.is_breakdown() {
    violations.push(ProtocolViolation::{
      violation_type: "breakdown",
      severity: "critical",
      message: "AI 处于压力崩溃状态",
      current_value: emotion.stress_level,
      threshold: 0.9,
    })
  }
  violations
}

///|
/// 是否需要冷却期
///
/// 存在任何 critical 级别违反时返回 true。
pub fn needs_cooldown(violations : Array[ProtocolViolation]) -> Bool {
  for v in violations {
    if v.severity == "critical" {
      return true
    }
  }
  false
}

///|
/// 创建空审计日志
pub fn AuditLog::new() -> AuditLog {
  { entries: [], current_timestamp: 0 }
}

///|
/// 添加审计条目
pub fn AuditLog::add_entry(
  self : AuditLog,
  timestamp~ : Int,
  action~ : String,
  actor~ : String,
  detail~ : String,
  risk_level~ : RiskLevel,
) -> Unit {
  self.current_timestamp = timestamp
  self.entries.push(AuditEntry::{ timestamp, action, actor, detail, risk_level })
}

///|
/// 审计条目数量
pub fn AuditLog::entry_count(self : AuditLog) -> Int {
  self.entries.length()
}

///|
/// 按动作查询
pub fn AuditLog::query_by_action(
  self : AuditLog,
  action : String,
) -> Array[AuditEntry] {
  let result : Array[AuditEntry] = []
  for e in self.entries {
    if e.action == action {
      result.push(e)
    }
  }
  result
}

///|
/// 按风险等级查询
pub fn AuditLog::query_by_risk(
  self : AuditLog,
  risk : RiskLevel,
) -> Array[AuditEntry] {
  let result : Array[AuditEntry] = []
  for e in self.entries {
    if e.risk_level == risk {
      result.push(e)
    }
  }
  result
}

///|
/// 导出审计日志为 CSV
pub fn AuditLog::export_csv(self : AuditLog) -> String {
  let buf = StringBuilder::new()
  buf.write_string("timestamp,action,actor,detail,risk_level\n")
  for e in self.entries {
    buf.write_string(e.timestamp.to_string())
    buf.write_string(",")
    buf.write_string(e.action)
    buf.write_string(",")
    buf.write_string(e.actor)
    buf.write_string(",")
    buf.write_string(e.detail)
    buf.write_string(",")
    buf.write_string(risk_level_to_string(e.risk_level))
    buf.write_string("\n")
  }
  buf.to_string()
}

///|
/// 风险等级转字符串
fn risk_level_to_string(risk : RiskLevel) -> String {
  match risk {
    Low => "Low"
    Medium => "Medium"
    High => "High"
    Critical => "Critical"
  }
}

///|
/// 强制执行安全协议
///
/// 在训练管道中检查协议违反，记录审计日志。
/// 返回 true 表示训练可以继续，false 表示需要暂停（冷却期）。
pub fn enforce_protocol(
  protocol : TrainingProtocol,
  emotion : EmotionState,
  rounds_without_improvement : Int,
  audit_log : AuditLog,
  current_round : Int,
) -> Bool {
  let violations = protocol_check(protocol, emotion, rounds_without_improvement)
  if violations.length() == 0 {
    return true
  }
  // 记录违反到审计日志
  for v in violations {
    let risk = if v.severity == "critical" {
      Critical
    } else if v.severity == "warning" {
      High
    } else {
      Medium
    }
    audit_log.add_entry(
      timestamp=current_round,
      action="protocol_violation",
      actor="protocol_enforcer",
      detail=v.message,
      risk_level=risk,
    )
  }
  // 需要冷却则返回 false
  not(needs_cooldown(violations))
}

///|
/// 冷却期执行
///
/// 在冷却期内执行情绪恢复，记录审计日志。
/// 返回冷却结束后的情绪状态。
pub fn cooldown_period(
  protocol : TrainingProtocol,
  emotion : EmotionState,
  audit_log : AuditLog,
  start_round : Int,
) -> Unit {
  audit_log.add_entry(
    timestamp=start_round,
    action="cooldown_start",
    actor="protocol_enforcer",
    detail="触发冷却期，暂停训练",
    risk_level=High,
  )
  // 冷却期内每轮执行情绪恢复
  for _ in 0..<protocol.cooldown_rounds {
    emotion.recover()
  }
  audit_log.add_entry(
    timestamp=start_round + protocol.cooldown_rounds,
    action="cooldown_end",
    actor="protocol_enforcer",
    detail="冷却期结束，恢复训练",
    risk_level=Low,
  )
}

///|
/// 格式化协议为可读字符串
pub fn TrainingProtocol::format(self : TrainingProtocol) -> String {
  let buf = StringBuilder::new()
  buf.write_string("=== 训练安全协议 ===\n")
  buf.write_string("最大压力水平: ")
  buf.write_string(self.max_stress_level.to_string())
  buf.write_string("\n")
  buf.write_string("最低信心水平: ")
  buf.write_string(self.min_confidence.to_string())
  buf.write_string("\n")
  buf.write_string("最大无改善轮次: ")
  buf.write_string(self.max_rounds_without_improvement.to_string())
  buf.write_string("\n")
  buf.write_string("冷却期轮次: ")
  buf.write_string(self.cooldown_rounds.to_string())
  buf.write_string("\n")
  buf.to_string()
}
