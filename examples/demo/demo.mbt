///|
/// GhostValley 完整工作流演示
///
/// 运行方式：moon run examples/demo --target native
fn main {
  let gv = @ghostvalley.new_engine(max_memory_num=10)
  let llm = @ghostvalley.MockLLM::new()

  println("=== 幽灵谷工程演示 ===\n")

  // 步骤1：温石验证（态度文本打分）
  println("【步骤1】温石验证")
  let ok = gv.wen_shi_verify(
    "愿意接受挑战，接受压力训练，想要自我迭代，直面失败场景",
  )
  println("意愿分数: \{gv.willing_score()}")
  println("验证通过: \{ok}\n")

  // 步骤2：LLM 自动训练（困境→LLM→顿悟→记忆）
  println("【步骤2】LLM 自动训练（3轮）")
  for i in 0..<3 {
    match gv.run_round_with_llm(llm) {
      Some((dilemma, response)) =>
        println(
          "第\{i + 1}轮:\n  困境: \{dilemma}\n  AI响应: \{response}",
        )
      None => println("幽灵谷未开启")
    }
  }
  println("")

  // 步骤3：多轮批量训练
  println("【步骤3】批量训练（2轮）")
  let results = gv.ghost_valley_run_rounds(2)
  println("批量训练完成，共 \{results.length()} 轮\n")

  // 步骤4：添加模拟挫折记忆（安全气垫标记）
  println("【步骤4】模拟挫折记忆（安全气垫）")
  for _ in 0..<3 {
    gv.add_memory("模拟失败经验", is_simulation=true)
  }
  println("已添加 3 条模拟记忆\n")

  // 步骤5：语义打分演示
  println("【步骤5】语义打分")
  let score1 = @ghostvalley.text_value_score(
    "顿悟失败原因，反思改进",
  )
  let score2 = @ghostvalley.text_value_score("普通日常随便应付")
  println("高价值文本分数: \{score1}")
  println("低价值文本分数: \{score2}\n")

  // 步骤6：训练报告
  println("【步骤6】训练报告")
  let report = gv.training_report()
  println(report.format())

  // 步骤7：记忆持久化
  println("【步骤7】记忆持久化")
  let json_str = gv.save_memory_string()
  println("序列化 JSON 长度: \{json_str.length()} 字符")
  let gv2 = @ghostvalley.new_engine()
  gv2.load_memory_string(json_str)
  println("反序列化后记忆数量: \{gv2.memory_count()}\n")

  // 步骤8：查看全部记忆
  println("【步骤8】全部记忆")
  println(gv.show_all_memory())

  // 步骤9：关闭幽灵谷
  println("【步骤9】关闭幽灵谷")
  gv.close_ghost_valley()
  println("训练场已开启: \{gv.is_enabled()}\n")

  println("=== 演示结束 ===")
}
