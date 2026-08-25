// ============================================================
// Phase 3 (v1.11.0) 测试：训练协议 + 安全边界 + 审计日志
// ============================================================

///|
test "TrainingProtocol::default 默认协议" {
  let p = @ghostvalley.TrainingProtocol::default()
  assert_true(p.max_stress_level > 0.0)
  assert_true(p.min_confidence > 0.0)
  assert_true(p.max_rounds_without_improvement > 0)
  assert_true(p.cooldown_rounds > 0)
}

///|
test "TrainingProtocol::strict 严格协议" {
  let p = @ghostvalley.TrainingProtocol::strict()
  let d = @ghostvalley.TrainingProtocol::default()
  assert_true(p.max_stress_level < d.max_stress_level)
  assert_true(p.min_confidence > d.min_confidence)
  assert_true(
    p.max_rounds_without_improvement < d.max_rounds_without_improvement,
  )
  assert_true(p.cooldown_rounds > d.cooldown_rounds)
}

///|
test "protocol_check 无违反" {
  let p = @ghostvalley.TrainingProtocol::default()
  let es = @ghostvalley.EmotionState::initial()
  let violations = @ghostvalley.protocol_check(p, es, 0)
  assert_eq(violations.length(), 0)
}

///|
test "protocol_check 压力超限" {
  let p = @ghostvalley.TrainingProtocol::default()
  let es = @ghostvalley.EmotionState::initial()
  es.stress_level = 0.9
  let violations = @ghostvalley.protocol_check(p, es, 0)
  assert_true(violations.length() >= 1)
  assert_true(violations[0].violation_type == "stress_exceeded")
}

///|
test "protocol_check 信心过低" {
  let p = @ghostvalley.TrainingProtocol::default()
  let es = @ghostvalley.EmotionState::initial()
  es.confidence = 0.1
  let violations = @ghostvalley.protocol_check(p, es, 0)
  assert_true(violations.length() >= 1)
  let mut found = false
  for v in violations {
    if v.violation_type == "confidence_too_low" {
      found = true
    }
  }
  assert_true(found)
}

///|
test "protocol_check 连续无改善" {
  let p = @ghostvalley.TrainingProtocol::default()
  let es = @ghostvalley.EmotionState::initial()
  let violations = @ghostvalley.protocol_check(p, es, 15)
  let mut found = false
  for v in violations {
    if v.violation_type == "no_improvement" {
      found = true
    }
  }
  assert_true(found)
}

///|
test "protocol_check 崩溃状态" {
  let p = @ghostvalley.TrainingProtocol::default()
  let es = @ghostvalley.EmotionState::initial()
  es.stress_level = 0.95
  es.confidence = 0.1
  let violations = @ghostvalley.protocol_check(p, es, 0)
  let mut found = false
  for v in violations {
    if v.violation_type == "breakdown" {
      found = true
    }
  }
  assert_true(found)
}

///|
test "needs_cooldown 无违反" {
  let violations : Array[@ghostvalley.ProtocolViolation] = []
  assert_false(@ghostvalley.needs_cooldown(violations))
}

///|
test "needs_cooldown 有critical违反" {
  let violations : Array[@ghostvalley.ProtocolViolation] = [
    {
      violation_type: "stress_exceeded",
      severity: "critical",
      message: "test",
      current_value: 0.9,
      threshold: 0.85,
    },
  ]
  assert_true(@ghostvalley.needs_cooldown(violations))
}

///|
test "needs_cooldown 只有warning违反" {
  let violations : Array[@ghostvalley.ProtocolViolation] = [
    {
      violation_type: "no_improvement",
      severity: "warning",
      message: "test",
      current_value: 15.0,
      threshold: 10.0,
    },
  ]
  assert_false(@ghostvalley.needs_cooldown(violations))
}

///|
test "AuditLog::new 空日志" {
  let log = @ghostvalley.AuditLog::new()
  assert_eq(log.entry_count(), 0)
}

///|
test "AuditLog::add_entry 添加条目" {
  let log = @ghostvalley.AuditLog::new()
  log.add_entry(
    timestamp=1,
    action="training_start",
    actor="system",
    detail="开始训练",
    risk_level=@ghostvalley.Low,
  )
  assert_eq(log.entry_count(), 1)
}

///|
test "AuditLog::query_by_action 按动作查询" {
  let log = @ghostvalley.AuditLog::new()
  log.add_entry(
    timestamp=1,
    action="train",
    actor="sys",
    detail="a",
    risk_level=@ghostvalley.Low,
  )
  log.add_entry(
    timestamp=2,
    action="violation",
    actor="sys",
    detail="b",
    risk_level=@ghostvalley.High,
  )
  log.add_entry(
    timestamp=3,
    action="train",
    actor="sys",
    detail="c",
    risk_level=@ghostvalley.Low,
  )
  let results = log.query_by_action("train")
  assert_eq(results.length(), 2)
}

///|
test "AuditLog::query_by_risk 按风险查询" {
  let log = @ghostvalley.AuditLog::new()
  log.add_entry(
    timestamp=1,
    action="a",
    actor="sys",
    detail="x",
    risk_level=@ghostvalley.Low,
  )
  log.add_entry(
    timestamp=2,
    action="b",
    actor="sys",
    detail="y",
    risk_level=@ghostvalley.Critical,
  )
  log.add_entry(
    timestamp=3,
    action="c",
    actor="sys",
    detail="z",
    risk_level=@ghostvalley.Critical,
  )
  let results = log.query_by_risk(@ghostvalley.Critical)
  assert_eq(results.length(), 2)
}

///|
test "AuditLog::export_csv 导出CSV" {
  let log = @ghostvalley.AuditLog::new()
  log.add_entry(
    timestamp=1,
    action="train",
    actor="sys",
    detail="开始",
    risk_level=@ghostvalley.Low,
  )
  let csv = log.export_csv()
  assert_true(csv.contains("timestamp"))
  assert_true(csv.contains("train"))
  assert_true(csv.contains("Low"))
}

///|
test "enforce_protocol 无违反返回true" {
  let p = @ghostvalley.TrainingProtocol::default()
  let es = @ghostvalley.EmotionState::initial()
  let log = @ghostvalley.AuditLog::new()
  let ok = @ghostvalley.enforce_protocol(p, es, 0, log, 1)
  assert_true(ok)
  assert_eq(log.entry_count(), 0)
}

///|
test "enforce_protocol 有违反记录审计并返回false" {
  let p = @ghostvalley.TrainingProtocol::default()
  let es = @ghostvalley.EmotionState::initial()
  es.stress_level = 0.95
  es.confidence = 0.1
  let log = @ghostvalley.AuditLog::new()
  let ok = @ghostvalley.enforce_protocol(p, es, 0, log, 1)
  assert_false(ok)
  assert_true(log.entry_count() > 0)
}

///|
test "cooldown_period 执行情绪恢复" {
  let p = @ghostvalley.TrainingProtocol::default()
  let es = @ghostvalley.EmotionState::initial()
  es.stress_level = 0.9
  let log = @ghostvalley.AuditLog::new()
  @ghostvalley.cooldown_period(p, es, log, 1)
  assert_true(es.stress_level < 0.9)
  assert_true(log.entry_count() >= 2) // start + end
}

///|
test "TrainingProtocol::format 输出协议信息" {
  let p = @ghostvalley.TrainingProtocol::default()
  let s = p.format()
  assert_true(s.contains("最大压力水平"))
  assert_true(s.contains("最低信心水平"))
}

///|
test "RiskLevel 相等比较" {
  assert_true(@ghostvalley.Low == @ghostvalley.Low)
  assert_true(@ghostvalley.Critical != @ghostvalley.Low)
}

///|
test "ProtocolViolation 序列化" {
  let v = @ghostvalley.ProtocolViolation::{
    violation_type: "stress_exceeded",
    severity: "critical",
    message: "test",
    current_value: 0.9,
    threshold: 0.85,
  }
  let json = @json.to_json(v)
  let str = json.stringify()
  assert_true(str.contains("stress_exceeded"))
}
