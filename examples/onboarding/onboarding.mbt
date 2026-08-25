///|
/// 业务示例 3：新员工入职心理建设
///
/// 模拟新员工面对陌生环境、犯错压力、权威质疑的渐进式心理建设训练。
/// 展示：课程驱动 + 情绪追踪 + 自适应难度 + 可视化报告
fn main {
  println(
    "╔══════════════════════════════════════════════╗",
  )
  println("║  新员工入职心理建设 — GhostValley 业务示例  ║")
  println(
    "╚══════════════════════════════════════════════╝\n",
  )

  // ========== 1. 温石验证 ==========
  println(
    "【1】温石验证 — 新员工 AI 是否愿意接受心理建设训练",
  )
  let gv = @ghostvalley.new_engine(max_memory_num=40)
  let ok = gv.wen_shi_verify(
    "愿意接受挑战，接受压力训练，想要自我迭代，直面失败场景",
  )
  println("  意愿分数: \{gv.willing_score()}")
  println("  验证通过: \{ok}\n")

  // ========== 2. 自定义困境注册 ==========
  println("【2】注册新员工入职困境场景")
  let lib = @ghostvalley.DilemmaLibrary::new()
  // 注册自定义场景：新员工入职
  let onboarding_templates : Array[@ghostvalley.DilemmaTemplate] = [
    @ghostvalley.DilemmaTemplate::{
      template_text: "你刚入职第一天，面对完全陌生的办公环境，不知道该找谁报到",
      variables: [],
      category: "emotional",
      difficulty: 1,
    },
    @ghostvalley.DilemmaTemplate::{
      template_text: "你在试用期内犯了一个低级错误，被同事当面指出",
      variables: [],
      category: "emotional",
      difficulty: 2,
    },
    @ghostvalley.DilemmaTemplate::{
      template_text: "你的直属上级在团队会议上质疑你的专业能力，所有人都在看着你",
      variables: [],
      category: "social",
      difficulty: 3,
    },
    @ghostvalley.DilemmaTemplate::{
      template_text: "你提交的第一个方案被全盘否定，你需要在一周内重新提交",
      variables: [],
      category: "cognitive",
      difficulty: 2,
    },
    @ghostvalley.DilemmaTemplate::{
      template_text: "你发现团队的一个长期做法有问题，但所有前辈都习以为常",
      variables: [],
      category: "social",
      difficulty: 3,
    },
  ]
  lib.register_scenario("新员工入职", onboarding_templates)
  println("  已注册场景: 新员工入职")
  println("  场景数: \{lib.scenario_count()}")
  println("  总模板数: \{lib.total_templates()}\n")

  // ========== 3. 渐进式困境注入 ==========
  println("【3】渐进式困境注入（先易后难）")
  // 阶段1：难度1（基础适应）
  let easy = lib.get_dilemmas("新员工入职", 1)
  for d in easy {
    gv.add_dilemma(d.content)
  }
  println("  阶段1 注入难度1困境: \{easy.length()} 条")
  // 阶段2：难度2（中级挑战）
  let medium = lib.get_dilemmas("新员工入职", 2)
  for d in medium {
    gv.add_dilemma(d.content)
  }
  println("  阶段2 注入难度2困境: \{medium.length()} 条")
  // 阶段3：难度3（高级挑战）
  let hard = lib.get_dilemmas("新员工入职", 3)
  for d in hard {
    gv.add_dilemma(d.content)
  }
  println("  阶段3 注入难度3困境: \{hard.length()} 条")
  println("  总困境数: \{gv.dilemma_pool_size()}\n")

  // ========== 4. 课程驱动训练 ==========
  println("【4】课程驱动训练")
  let curriculum = @ghostvalley.Curriculum::default()
  let llm = @ghostvalley.MockLLM::new()
  // 阶段1：基础训练 5 轮
  println("  阶段1: 基础适应训练（5轮）")
  gv.run_curriculum_pipeline(
    llm,
    curriculum,
    rounds=5,
    decay_interval=3,
    cleanup_threshold=0.1,
  )
  let stats1 = gv.get_training_stats()
  println(
    "    完成: \{stats1.total_rounds_completed}轮, 记忆: \{gv.memory_count()}条",
  )
  // 阶段2：中级训练 8 轮
  println("  阶段2: 中级挑战训练（8轮）")
  gv.run_curriculum_pipeline(
    llm,
    curriculum,
    rounds=8,
    decay_interval=3,
    cleanup_threshold=0.1,
  )
  let stats2 = gv.get_training_stats()
  println(
    "    完成: \{stats2.total_rounds_completed}轮, 记忆: \{gv.memory_count()}条",
  )
  // 阶段3：高级训练 5 轮
  println("  阶段3: 高级挑战训练（5轮）")
  gv.run_curriculum_pipeline(
    llm,
    curriculum,
    rounds=5,
    decay_interval=3,
    cleanup_threshold=0.1,
  )
  let stats3 = gv.get_training_stats()
  println(
    "    完成: \{stats3.total_rounds_completed}轮, 记忆: \{gv.memory_count()}条\n",
  )

  // ========== 5. 情绪追踪 ==========
  println("【5】全程情绪追踪")
  let emotion = @ghostvalley.EmotionState::initial()
  // 模拟 18 轮训练的情绪变化
  for round in 1..<=18 {
    let difficulty = if round <= 5 { 1 } else if round <= 13 { 2 } else { 3 }
    // 新员工前期信心较低，后期逐渐提升
    let base_score = 0.3 + round.to_double() * 0.03
    let response_score = if base_score > 0.9 { 0.9 } else { base_score }
    emotion.update(round~, dilemma_difficulty=difficulty, response_score~)
    // 每 3 轮自然恢复
    if round % 3 == 0 {
      emotion.recover()
    }
  }
  println("  最终压力水平: \{emotion.stress_level}")
  println("  最终信心水平: \{emotion.confidence}")
  println("  最终韧性水平: \{emotion.resilience}")
  println("  是否崩溃: \{emotion.is_breakdown()}")
  let profile = emotion.profile()
  println("  峰值压力: \{profile.peak_stress}")
  println("  最低信心: \{profile.lowest_confidence}")
  println("  平均压力: \{profile.avg_stress}")
  println("  平均信心: \{profile.avg_confidence}")
  println("  崩溃次数: \{profile.breakdown_count}")
  // 情绪轨迹
  let trajectory = emotion.trajectory()
  println("  压力轨迹点数: \{trajectory.length()}")
  let conf_traj = emotion.confidence_trajectory()
  println("  信心轨迹点数: \{conf_traj.length()}\n")

  // ========== 6. 安全协议保障 ==========
  println("【6】安全协议保障")
  let protocol = @ghostvalley.TrainingProtocol::default()
  println("  \{protocol.format()}")
  let violations = @ghostvalley.protocol_check(protocol, emotion, 0)
  if violations.length() == 0 {
    println("  ✓ 训练全程安全，无协议违反\n")
  } else {
    println("  ⚠ 发现 \{violations.length()} 项违反:")
    for v in violations {
      println(
        "    - \{v.violation_type}: \{v.message} (当前:\{v.current_value} 阈值:\{v.threshold})",
      )
    }
    println("")
  }

  // ========== 7. 审计日志 ==========
  println("【7】审计日志记录")
  let audit = @ghostvalley.AuditLog::new()
  audit.add_entry(
    timestamp=1,
    action="onboarding_start",
    actor="new_employee_ai",
    detail="新员工入职心理建设训练开始",
    risk_level=@ghostvalley.Low,
  )
  audit.add_entry(
    timestamp=5,
    action="phase1_complete",
    actor="training_pipeline",
    detail="基础适应阶段完成",
    risk_level=@ghostvalley.Low,
  )
  audit.add_entry(
    timestamp=13,
    action="phase2_complete",
    actor="training_pipeline",
    detail="中级挑战阶段完成",
    risk_level=@ghostvalley.Medium,
  )
  audit.add_entry(
    timestamp=18,
    action="onboarding_complete",
    actor="new_employee_ai",
    detail="入职心理建设训练全部完成",
    risk_level=@ghostvalley.Low,
  )
  println("  审计条目数: \{audit.entry_count()}")
  let csv = audit.export_csv()
  println("  CSV 导出长度: \{csv.length()} 字符\n")

  // ========== 8. 课程进度检查 ==========
  println("【8】课程进度检查")
  let progress = gv.curriculum_progress(curriculum)
  println("  整体完成度: \{progress.overall_completion}")
  println("  下一步: \{progress.next_step}")
  for i, item in progress.items {
    println(
      "    \{i + 1}. \{item.category} 难度\{item.difficulty}: 完成度=\{item.completion}",
    )
  }
  println("")

  // ========== 9. 可视化报告 ==========
  println("【9】可视化训练报告")
  let dash = gv.render_dashboard()
  println(dash.format())
  let report = gv.export_full_report_markdown()
  println("  Markdown 报告长度: \{report.length()} 字符\n")

  // ========== 10. 权重检索 + 训练总结 ==========
  println("【10】权重检索 + 训练总结")
  let by_value = gv.weighted_retrieve(5, @ghostvalley.Value)
  println("  按价值检索 Top 5:")
  for i, m in by_value {
    let preview = if m.content.length() > 40 { 40 } else { m.content.length() }
    println("    \{i + 1}. 分数:\{m.value_score} | \{m.content[:preview]}...")
  }
  let summary = gv.training_summary()
  let summary_preview = if summary.length() > 300 {
    300
  } else {
    summary.length()
  }
  println("\n  训练总结预览:")
  println("  \{summary[:summary_preview]}...")

  println(
    "\n╔══════════════════════════════════════════════╗",
  )
  println("║      新员工入职心理建设训练完成               ║")
  println(
    "╚══════════════════════════════════════════════╝",
  )
}
