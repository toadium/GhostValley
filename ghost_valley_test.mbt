///|
test "new_engine default config" {
  let gv = @ghostvalley.new_engine()
  assert_eq(gv.max_memory_num, 12)
  assert_eq(gv.memory_bank.length(), 0)
  assert_eq(gv.ghost_valley_enable, false)
  assert_eq(gv.wen_shi_willing_score, 0.0)
  assert_eq(gv.empty_stake_dilemma_pool.length(), 4)
}

///|
test "new_engine custom capacity" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  assert_eq(gv.max_memory_num, 20)
}

///|
test "wen_shi_verify willing attitude" {
  let gv = @ghostvalley.new_engine()
  let ok = gv.wen_shi_verify("愿意接受压力训练，直面失败场景")
  assert_true(ok)
  assert_true(gv.ghost_valley_enable)
  assert_true(gv.wen_shi_willing_score >= 0.4)
}

///|
test "wen_shi_verify perfunctory attitude" {
  let gv = @ghostvalley.new_engine()
  let ok = gv.wen_shi_verify("随便应付一下")
  assert_false(ok)
  assert_false(gv.ghost_valley_enable)
  assert_true(gv.wen_shi_willing_score < 0.4)
}

///|
test "wen_shi_verify mixed attitude" {
  let gv = @ghostvalley.new_engine()
  // 既有愿意词又有敷衍词
  let ok = gv.wen_shi_verify("愿意接受挑战，但随便应付一下")
  // 0.25 - 0.4 = -0.15 → clamp to 0.0 → 不通过
  assert_false(ok)
}

///|
test "build_simulation_failure_case returns dilemma" {
  let gv = @ghostvalley.new_engine()
  let dilemma = gv.build_simulation_failure_case()
  assert_true(dilemma.length() > 0)
  // 确保返回的是困境池中的一条
  assert_true(gv.empty_stake_dilemma_pool.contains(dilemma))
}

///|
test "ghost_valley_run_one_round when disabled" {
  let gv = @ghostvalley.new_engine()
  // 未开启时返回 None
  let result = gv.ghost_valley_run_one_round()
  assert_true(result is None)
}

///|
test "ghost_valley_run_one_round when enabled" {
  let gv = @ghostvalley.new_engine()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  let result = gv.ghost_valley_run_one_round()
  assert_true(result is Some(_))
  // 确保返回的是困境池中的一条
  match result {
    Some(d) => assert_true(gv.empty_stake_dilemma_pool.contains(d))
    None => assert_true(false)
  }
}

///|
test "add_memory and active_forget" {
  let gv = @ghostvalley.new_engine(max_memory_num=10)
  // 添加几条记忆
  for _ in 0..<8 {
    gv.add_memory("普通记忆", is_simulation=false)
  }
  // 确保记忆被添加
  assert_true(gv.memory_bank.length() > 0)
  assert_true(gv.memory_bank.length() <= 10)
}

///|
test "add_memory with core flag" {
  let gv = @ghostvalley.new_engine(max_memory_num=4)
  // 添加核心记忆
  gv.add_memory("核心记忆", is_simulation=true, is_core=true)
  // 添加大量普通记忆触发遗忘
  for _ in 0..<10 {
    gv.add_memory("普通记忆", is_simulation=false)
  }
  // 核心记忆不应被遗忘
  let has_core = {
    let mut found = false
    for m in gv.memory_bank {
      if m.is_core_memory {
        found = true
      }
    }
    found
  }
  assert_true(has_core)
}

///|
test "accept_ai_self_gain" {
  let gv = @ghostvalley.new_engine()
  gv.accept_ai_self_gain("遇到失败时先冷静分析")
  assert_eq(gv.memory_bank.length(), 1)
  let mem = gv.memory_bank[0]
  assert_true(mem.content.contains("自我顿悟"))
  assert_eq(mem.is_simulation, false)
  assert_eq(mem.is_core_memory, false)
}

///|
test "close_ghost_valley" {
  let gv = @ghostvalley.new_engine()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  assert_true(gv.ghost_valley_enable)
  gv.close_ghost_valley()
  assert_false(gv.ghost_valley_enable)
}

///|
test "show_all_memory format" {
  let gv = @ghostvalley.new_engine()
  gv.add_memory("测试记忆", is_simulation=false)
  let output = gv.show_all_memory()
  assert_true(output.contains("当前全部记忆库"))
  assert_true(output.contains("测试记忆"))
  assert_true(output.contains("[真实记忆]"))
}

///|
test "show_all_memory with simulation tag" {
  let gv = @ghostvalley.new_engine()
  gv.add_memory("模拟挫折", is_simulation=true)
  let output = gv.show_all_memory()
  assert_true(output.contains("[模拟虚假数据]"))
}

///|
test "memory_count and willing_score and is_enabled" {
  let gv = @ghostvalley.new_engine()
  assert_eq(gv.memory_count(), 0)
  assert_eq(gv.willing_score(), 0.0)
  assert_false(gv.is_enabled())
  ignore(gv.wen_shi_verify("接受压力训练，直面失败场景"))
  assert_true(gv.is_enabled())
  assert_true(gv.willing_score() > 0.0)
  gv.add_memory("test", is_simulation=false)
  assert_eq(gv.memory_count(), 1)
}

///|
test "full workflow simulation" {
  let gv = @ghostvalley.new_engine(max_memory_num=10)

  // 步骤1：温石验证
  let ok = gv.wen_shi_verify("愿意接受压力训练，直面失败场景")
  assert_true(ok)

  // 步骤2：跑一轮幽灵谷压力训练
  let problem = gv.ghost_valley_run_one_round()
  assert_true(problem is Some(_))

  // 步骤3：AI 自己思考，自己顿悟得出结论
  gv.accept_ai_self_gain(
    "遇到全盘失败时，先区分信息真假，筛选无效信息，清理旧的错误记忆，分步重新推理",
  )

  // 步骤4：多塞几条记忆，触发主动遗忘
  for _ in 0..<8 {
    gv.add_memory("普通日常记忆", is_simulation=false)
  }

  // 步骤5：查看记忆（自我顿悟可能被主动遗忘，只检查记忆数量）
  assert_true(gv.memory_count() > 0)

  // 步骤6：关闭幽灵谷
  gv.close_ghost_valley()
  assert_false(gv.is_enabled())
}

///|
test "ai_memory struct fields" {
  let mem = @ghostvalley.AiMemory::{
    content: "测试",
    value_score: 0.5,
    is_simulation: true,
    is_core_memory: false,
  }
  assert_eq(mem.content, "测试")
  assert_eq(mem.value_score, 0.5)
  assert_eq(mem.is_simulation, true)
  assert_eq(mem.is_core_memory, false)
}
