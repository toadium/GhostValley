///|
/// GhostValley 完整工作流演示
///
/// 运行方式：moon run examples/demo --target native
fn main {
  let gv = @ghostvalley.new_engine(max_memory_num=10)

  println("=== 幽灵谷工程演示 ===\n")

  // 步骤1：温石验证（态度文本打分）
  println("【步骤1】温石验证")
  let ok = gv.wen_shi_verify(
    "愿意接受挑战，接受压力训练，想要自我迭代，直面失败场景",
  )
  println("意愿分数: \{gv.willing_score()}")
  println("验证通过: \{ok}\n")

  // 步骤2：多轮压力训练
  println("【步骤2】多轮压力训练")
  for i in 0..<3 {
    let problem = gv.ghost_valley_run_one_round()
    match problem {
      Some(d) => println("第\{i + 1}轮困境: \{d}")
      None => println("幽灵谷未开启")
    }
  }
  println("")

  // 步骤3：AI 自主顿悟（建造者退场，不写死答案）
  println("【步骤3】AI 自主顿悟")
  gv.accept_ai_self_gain(
    "遇到全盘失败时，先区分信息真假，筛选无效信息，清理旧的错误记忆，分步重新推理",
  )
  gv.accept_ai_self_gain(
    "负面反馈是改进的信号，不是自我否定的理由",
  )
  println("已记录 2 条顿悟感悟\n")

  // 步骤4：添加模拟挫折记忆（安全气垫标记）
  println("【步骤4】模拟挫折记忆（安全气垫）")
  for _ in 0..<5 {
    gv.add_memory("模拟失败经验", is_simulation=true)
  }
  println("已添加 5 条模拟记忆\n")

  // 步骤5：触发主动遗忘
  println("【步骤5】主动遗忘")
  for _ in 0..<4 {
    gv.add_memory("普通日常记忆", is_simulation=false)
  }
  println("当前记忆数量: \{gv.memory_count()}（触发遗忘后）\n")

  // 步骤6：查看全部记忆
  println("【步骤6】全部记忆")
  println(gv.show_all_memory())

  // 步骤7：关闭幽灵谷
  println("【步骤7】关闭幽灵谷")
  gv.close_ghost_valley()
  println("训练场已开启: \{gv.is_enabled()}\n")

  println("=== 演示结束 ===")
}
