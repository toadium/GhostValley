///|
/// 业务示例 2：技术团队压力演练
///
/// 模拟技术团队面对项目延期、线上事故、技术选型失误的集体压力训练。
/// 展示：多智能体对比训练 + 交叉学习 + 课程体系 + 检查点恢复
fn main {
  println(
    "╔══════════════════════════════════════════════╗",
  )
  println("║   技术团队压力演练 — GhostValley 业务示例    ║")
  println(
    "╚══════════════════════════════════════════════╝\n",
  )

  // ========== 1. 多智能体初始化 ==========
  println(
    "【1】初始化两个技术团队 AI（A: 资深团队 / B: 新建团队）",
  )
  let gv_a = @ghostvalley.new_engine(max_memory_num=50)
  let gv_b = @ghostvalley.new_engine(max_memory_num=50)

  // 温石验证
  let ok_a = gv_a.wen_shi_verify(
    "愿意接受挑战，接受压力训练，想要自我迭代",
  )
  let ok_b = gv_b.wen_shi_verify(
    "愿意接受挑战，接受压力训练，想要自我迭代",
  )
  println("  团队A 验证: \{ok_a} (分数:\{gv_a.willing_score()})")
  println("  团队B 验证: \{ok_b} (分数:\{gv_b.willing_score()})\n")

  // ========== 2. 困境库加载 ==========
  println(
    "【2】加载技术团队困境库（项目延期+安全事故+技术选型）",
  )
  let lib = @ghostvalley.DilemmaLibrary::with_presets()
  for scenario in ["项目延期", "安全事故复盘", "技术选型失误"] {
    for difficulty in [1, 2, 3] {
      let dilemmas = lib.get_dilemmas(scenario, difficulty)
      for d in dilemmas {
        gv_a.add_dilemma(d.content)
        gv_b.add_dilemma(d.content)
      }
    }
    let templates = lib.get_all_templates(scenario)
    println("  \{scenario}: \{templates.length()} 条困境模板")
  }
  println("  团队A 困境数: \{gv_a.dilemma_pool_size()}")
  println("  团队B 困境数: \{gv_b.dilemma_pool_size()}\n")

  // ========== 3. 课程体系 ==========
  println("【3】创建训练课程体系")
  let curriculum = @ghostvalley.Curriculum::default()
  println("  课程要求数: \{curriculum.requirements.length()}")
  for i, req in curriculum.requirements {
    println(
      "    要求\{i + 1}: 分类=\{req.category} 难度=\{req.difficulty} 最少轮次=\{req.min_rounds}",
    )
  }
  println("  前置依赖数: \{curriculum.prerequisites.length()}")
  for pre in curriculum.prerequisites {
    let (cat, dep) = pre
    println("    \{cat} 依赖 \{dep}")
  }
  println("")

  // ========== 4. 多智能体对比训练 ==========
  println("【4】多智能体对比训练")
  let llm_a = @ghostvalley.MockLLM::new()
  let llm_b = @ghostvalley.MockLLM::new()

  // 团队A 训练
  gv_a.run_training_pipeline(
    llm_a,
    rounds=10,
    decay_interval=3,
    cleanup_threshold=0.1,
  )
  // 团队B 训练（较少轮次）
  gv_b.run_training_pipeline(
    llm_b,
    rounds=6,
    decay_interval=2,
    cleanup_threshold=0.1,
  )

  let stats_a = gv_a.get_training_stats()
  let stats_b = gv_b.get_training_stats()
  println(
    "  团队A: \{stats_a.total_rounds_completed}轮, \{gv_a.memory_count()}条记忆",
  )
  println(
    "  团队B: \{stats_b.total_rounds_completed}轮, \{gv_b.memory_count()}条记忆\n",
  )

  // ========== 5. 交叉学习 ==========
  println("【5】交叉学习 — 团队A 向 团队B 传授经验")
  let session = @ghostvalley.MultiAgentSession::new()
  session.add_agent("资深团队", gv_a)
  session.add_agent("新建团队", gv_b)
  println("  智能体数量: \{session.agent_count()}")
  let names = session.agent_names()
  for name in names {
    println("    - \{name}")
  }
  // 交叉授粉：从团队A的top记忆传给团队B
  let transferred = @ghostvalley.cross_pollinate(gv_b, gv_a, top_n=5)
  println(
    "  交叉学习: 从资深团队向新建团队转移了 \{transferred} 条记忆",
  )
  println("  团队B 记忆数(转移后): \{gv_b.memory_count()}\n")

  // ========== 6. 对比训练 ==========
  println("【6】对比训练 — 同一困境下两个LLM对比")
  let llm_x = @ghostvalley.MockLLM::new()
  let llm_y = @ghostvalley.MockLLM::new()
  let results = gv_a.run_comparative_pipeline(llm_x, llm_y, rounds=5)
  println("  对比轮次: \{results.length()}")
  for i, r in results {
    println(
      "    轮\{i + 1}: A分=\{r.score_a} B分=\{r.score_b} 胜者=\{r.winner}",
    )
  }
  println("")

  // ========== 7. 检查点保存与恢复 ==========
  println("【7】检查点保存与恢复")
  let checkpoint = gv_a.save_checkpoint()
  println("  检查点已完成轮次: \{checkpoint.completed_rounds}")
  println("  检查点时间戳: \{checkpoint.timestamp}")

  // 模拟从检查点恢复训练
  let gv_restored = @ghostvalley.new_engine(max_memory_num=50)
  gv_restored.load_checkpoint(checkpoint)
  println("  恢复后记忆数: \{gv_restored.memory_count()}")
  // 继续训练 5 轮
  let llm_restore = @ghostvalley.MockLLM::new()
  gv_restored.run_training_pipeline(
    llm_restore,
    rounds=5,
    decay_interval=3,
    cleanup_threshold=0.1,
  )
  let stats_restored = gv_restored.get_training_stats()
  println(
    "  恢复后继续训练: \{stats_restored.total_rounds_completed}轮\n",
  )

  // ========== 8. 高级统计 ==========
  println("【8】高级统计分析")
  let scores_a = [0.7, 0.75, 0.8, 0.85, 0.82, 0.88, 0.9, 0.87, 0.92, 0.95]
  let scores_b = [0.3, 0.4, 0.45, 0.5, 0.55, 0.6]
  let ci_a = @ghostvalley.confidence_interval(scores_a, 0.95)
  let (ci_a_lower, ci_a_upper) = ci_a
  let ci_b = @ghostvalley.confidence_interval(scores_b, 0.95)
  let (ci_b_lower, ci_b_upper) = ci_b
  println("  团队A 95%置信区间: [\{ci_a_lower}, \{ci_a_upper}]")
  println("  团队B 95%置信区间: [\{ci_b_lower}, \{ci_b_upper}]")
  let sig = @ghostvalley.significance_test(scores_b, scores_a)
  println("  显著性检验 t值: \{sig.t_value}")
  println("  是否显著: \{sig.is_significant}")
  println("  差异: \{sig.difference}\n")

  // ========== 9. 课程进度 ==========
  println("【9】课程进度检查")
  let progress = gv_a.curriculum_progress(curriculum)
  println("  整体完成度: \{progress.overall_completion}")
  println("  下一步: \{progress.next_step}")
  for i, item in progress.items {
    println(
      "    \{i + 1}. \{item.category} 难度\{item.difficulty}: \{item.completion}",
    )
  }
  println("")

  // ========== 10. 训练报告导出 ==========
  println("【10】训练报告导出")
  let report_a = gv_a.export_full_report_markdown()
  let report_b = gv_b.export_full_report_markdown()
  println("  团队A 报告: \{report_a.length()} 字符")
  println("  团队B 报告: \{report_b.length()} 字符")
  let dash_a = gv_a.render_dashboard()
  println("\n  团队A 仪表盘预览:")
  println(dash_a.format())

  println(
    "\n╔══════════════════════════════════════════════╗",
  )
  println("║        技术团队压力演练完成                   ║")
  println(
    "╚══════════════════════════════════════════════╝",
  )
}
