///|
/// 业务示例 1：客服危机处理训练
///
/// 模拟 AI 客服面对大量投诉、差评轰炸、恶意攻击场景的心理压力训练。
/// 展示完整流程：
///   温石验证 → 困境库加载 → 训练管道 → 情绪监控 → 安全协议 → 审计日志 → 报告导出
fn main {
  println(
    "╔══════════════════════════════════════════════╗",
  )
  println("║   客服危机处理训练 — GhostValley 业务示例    ║")
  println(
    "╚══════════════════════════════════════════════╝\n",
  )

  // ========== 1. 温石验证 ==========
  println("【1】温石验证 — AI 客服是否愿意接受压力训练")
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let ok = gv.wen_shi_verify(
    "愿意接受挑战，接受压力训练，想要自我迭代，直面失败场景",
  )
  println("  意愿分数: \{gv.willing_score()}")
  println("  验证通过: \{ok}\n")

  // ========== 2. 困境库加载 ==========
  println("【2】加载客服危机困境库")
  let lib = @ghostvalley.DilemmaLibrary::with_presets()
  let templates = lib.get_all_templates("客服危机")
  println("  客服危机场景困境数: \{templates.length()}")
  // 实例化困境并注入引擎
  for difficulty in [1, 2, 3] {
    let dilemmas = lib.get_dilemmas("客服危机", difficulty)
    for d in dilemmas {
      gv.add_dilemma(d.content)
    }
  }
  println("  已注入 \{gv.dilemma_pool_size()} 条困境\n")

  // ========== 3. 训练管道 ==========
  println("【3】执行训练管道（10 轮）")
  let llm = @ghostvalley.MockLLM::new()
  gv.run_training_pipeline(
    llm,
    rounds=10,
    decay_interval=3,
    cleanup_threshold=0.1,
  )
  let stats = gv.get_training_stats()
  println("  完成轮次: \{stats.total_rounds_completed}")
  println("  记忆数量: \{gv.memory_count()}")
  println("  衰减次数: \{stats.total_decay_applied}")
  println("  清理记忆: \{stats.total_memories_cleaned}\n")

  // ========== 4. 情绪监控 ==========
  println("【4】情绪状态监控")
  let emotion = @ghostvalley.EmotionState::initial()
  // 模拟 10 轮训练的情绪变化
  for round in 1..<=10 {
    let difficulty = if round <= 3 { 1 } else if round <= 7 { 2 } else { 3 }
    let response_score = @ghostvalley.text_value_score(
      "冷静分析失败原因，反思改进，调整策略",
    )
    emotion.update(round~, dilemma_difficulty=difficulty, response_score~)
    // 每 3 轮恢复一次
    if round % 3 == 0 {
      emotion.recover()
    }
  }
  println("  当前压力水平: \{emotion.stress_level}")
  println("  当前信心水平: \{emotion.confidence}")
  println("  当前韧性水平: \{emotion.resilience}")
  println("  崩溃风险: \{emotion.is_breakdown()}")
  let profile = emotion.profile()
  println("  峰值压力: \{profile.peak_stress}")
  println("  平均压力: \{profile.avg_stress}")
  println("  崩溃次数: \{profile.breakdown_count}\n")

  // ========== 5. 安全协议 ==========
  println("【5】训练安全协议检查")
  let protocol = @ghostvalley.TrainingProtocol::default()
  println("  \{protocol.format()}")
  let violations = @ghostvalley.protocol_check(protocol, emotion, 0)
  if violations.length() == 0 {
    println("  ✓ 无协议违反，训练安全\n")
  } else {
    println("  ⚠ 发现 \{violations.length()} 项违反\n")
  }

  // ========== 6. 审计日志 ==========
  println("【6】审计日志")
  let audit = @ghostvalley.AuditLog::new()
  audit.add_entry(
    timestamp=1,
    action="training_start",
    actor="customer_service_ai",
    detail="客服危机训练开始",
    risk_level=@ghostvalley.Low,
  )
  audit.add_entry(
    timestamp=5,
    action="stress_spike",
    actor="emotion_monitor",
    detail="第5轮压力骤增",
    risk_level=@ghostvalley.Medium,
  )
  audit.add_entry(
    timestamp=10,
    action="training_complete",
    actor="customer_service_ai",
    detail="训练完成，无崩溃",
    risk_level=@ghostvalley.Low,
  )
  println("  审计条目数: \{audit.entry_count()}")
  println("  CSV 导出预览:")
  let csv = audit.export_csv()
  // 只打印前 200 字符
  let preview_len = if csv.length() > 200 { 200 } else { csv.length() }
  println("  \{csv[:preview_len]}...\n")

  // ========== 7. 训练报告导出 ==========
  println("【7】训练报告导出")
  let report = gv.export_full_report_markdown()
  println("  Markdown 报告长度: \{report.length()} 字符")
  // 仪表盘
  let dash = gv.render_dashboard()
  println("\n  训练仪表盘预览:")
  println(dash.format())

  // ========== 8. 权重检索演示 ==========
  println("【8】权重检索策略演示")
  let by_value = gv.weighted_retrieve(3, @ghostvalley.Value)
  println("  按价值检索 Top 3:")
  for i, m in by_value {
    let preview = if m.content.length() > 30 { 30 } else { m.content.length() }
    println("    \{i + 1}. 分数:\{m.value_score} | \{m.content[:preview]}...")
  }
  let by_combined = gv.weighted_retrieve(3, @ghostvalley.Combined)
  println("  按综合策略检索 Top 3:")
  for i, m in by_combined {
    let preview = if m.content.length() > 30 { 30 } else { m.content.length() }
    println(
      "    \{i + 1}. 分数:\{m.value_score} 访问:\{m.access_count} | \{m.content[:preview]}...",
    )
  }

  println(
    "\n╔══════════════════════════════════════════════╗",
  )
  println("║          客服危机训练完成                     ║")
  println(
    "╚══════════════════════════════════════════════╝",
  )
}
