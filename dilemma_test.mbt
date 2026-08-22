///|
test "Dilemma new basic" {
  let d = @ghostvalley.Dilemma::new(
    "测试困境",
    category="cognitive",
    difficulty=2,
  )
  assert_eq(d.content, "测试困境")
  assert_eq(d.category, "cognitive")
  assert_eq(d.difficulty, 2)
}

///|
test "Dilemma new invalid category defaults" {
  let d = @ghostvalley.Dilemma::new(
    "测试困境",
    category="unknown",
    difficulty=2,
  )
  assert_eq(d.category, "operational")
}

///|
test "Dilemma new difficulty clamped low" {
  let d = @ghostvalley.Dilemma::new(
    "测试困境",
    category="cognitive",
    difficulty=-5,
  )
  assert_eq(d.difficulty, 1)
}

///|
test "Dilemma new difficulty clamped high" {
  let d = @ghostvalley.Dilemma::new(
    "测试困境",
    category="cognitive",
    difficulty=99,
  )
  assert_eq(d.difficulty, 3)
}

///|
test "Dilemma default_pool has 12 entries" {
  let pool = @ghostvalley.Dilemma::default_pool()
  assert_eq(pool.length(), 12)
}

///|
test "Dilemma default_pool covers all categories" {
  let pool = @ghostvalley.Dilemma::default_pool()
  let cats = ["cognitive", "emotional", "social", "operational"]
  for cat in cats {
    let count = {
      let mut n = 0
      for d in pool {
        if d.category == cat {
          n = n + 1
        }
      }
      n
    }
    assert_eq(count, 3)
  }
}

///|
test "Dilemma default_pool covers all difficulties" {
  let pool = @ghostvalley.Dilemma::default_pool()
  for diff in [1, 2, 3] {
    let count = {
      let mut n = 0
      for d in pool {
        if d.difficulty == diff {
          n = n + 1
        }
      }
      n
    }
    assert_eq(count, 4)
  }
}

///|
test "get_dilemma_by_category cognitive" {
  let gv = @ghostvalley.new_engine()
  let cognitive = gv.get_dilemma_by_category("cognitive")
  assert_eq(cognitive.length(), 3)
  for d in cognitive {
    assert_eq(d.category, "cognitive")
  }
}

///|
test "get_dilemma_by_category emotional" {
  let gv = @ghostvalley.new_engine()
  let emotional = gv.get_dilemma_by_category("emotional")
  assert_eq(emotional.length(), 3)
}

///|
test "get_dilemma_by_category social" {
  let gv = @ghostvalley.new_engine()
  let social = gv.get_dilemma_by_category("social")
  assert_eq(social.length(), 3)
}

///|
test "get_dilemma_by_category operational" {
  let gv = @ghostvalley.new_engine()
  let operational = gv.get_dilemma_by_category("operational")
  assert_eq(operational.length(), 3)
}

///|
test "get_dilemma_by_category non-existent" {
  let gv = @ghostvalley.new_engine()
  let result = gv.get_dilemma_by_category("nonexistent")
  assert_eq(result.length(), 0)
}

///|
test "get_dilemma_by_difficulty 1" {
  let gv = @ghostvalley.new_engine()
  let easy = gv.get_dilemma_by_difficulty(1)
  assert_eq(easy.length(), 4)
  for d in easy {
    assert_eq(d.difficulty, 1)
  }
}

///|
test "get_dilemma_by_difficulty 2" {
  let gv = @ghostvalley.new_engine()
  let medium = gv.get_dilemma_by_difficulty(2)
  assert_eq(medium.length(), 4)
}

///|
test "get_dilemma_by_difficulty 3" {
  let gv = @ghostvalley.new_engine()
  let hard = gv.get_dilemma_by_difficulty(3)
  assert_eq(hard.length(), 4)
}

///|
test "get_dilemma_by_difficulty non-existent" {
  let gv = @ghostvalley.new_engine()
  let result = gv.get_dilemma_by_difficulty(5)
  assert_eq(result.length(), 0)
}

///|
test "adaptive_dilemma low performance" {
  let gv = @ghostvalley.new_engine()
  let d = gv.adaptive_dilemma(0.1)
  assert_eq(d.difficulty, 1)
}

///|
test "adaptive_dilemma medium performance" {
  let gv = @ghostvalley.new_engine()
  let d = gv.adaptive_dilemma(0.5)
  assert_eq(d.difficulty, 2)
}

///|
test "adaptive_dilemma high performance" {
  let gv = @ghostvalley.new_engine()
  let d = gv.adaptive_dilemma(0.9)
  assert_eq(d.difficulty, 3)
}

///|
test "adaptive_dilemma boundary 0.3" {
  let gv = @ghostvalley.new_engine()
  let d = gv.adaptive_dilemma(0.3)
  // 0.3 is not < 0.3, so difficulty 2
  assert_eq(d.difficulty, 2)
}

///|
test "adaptive_dilemma boundary 0.7" {
  let gv = @ghostvalley.new_engine()
  let d = gv.adaptive_dilemma(0.7)
  // 0.7 is not < 0.7, so difficulty 3
  assert_eq(d.difficulty, 3)
}

///|
test "set_structured_dilemma_pool custom" {
  let gv = @ghostvalley.new_engine()
  let custom = [
    @ghostvalley.Dilemma::new(
      "自定义困境",
      category="cognitive",
      difficulty=1,
    ),
  ]
  gv.set_structured_dilemma_pool(custom)
  let result = gv.get_dilemma_by_category("cognitive")
  assert_eq(result.length(), 1)
}

///|
test "save_engine_state basic" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("测试记忆", is_simulation=false)
  let state_json = gv.save_engine_state()
  assert_true(state_json.contains("memory_bank"))
  assert_true(state_json.contains("max_memory_num"))
  assert_true(state_json.contains("ghost_valley_enable"))
}

///|
test "load_engine_state roundtrip" {
  let gv1 = @ghostvalley.new_engine(max_memory_num=20)
  gv1.add_memory("测试记忆A", is_simulation=false)
  gv1.add_memory("测试记忆B", is_simulation=false, is_core=true)
  let state_json = gv1.save_engine_state()
  let gv2 = @ghostvalley.new_engine()
  gv2.load_engine_state(state_json)
  assert_eq(gv2.memory_count(), 2)
  assert_eq(gv2.max_memory_num, 20)
}

///|
test "load_engine_state preserves core flag" {
  let gv1 = @ghostvalley.new_engine(max_memory_num=20)
  gv1.add_memory("核心记忆", is_simulation=false, is_core=true)
  let state_json = gv1.save_engine_state()
  let gv2 = @ghostvalley.new_engine()
  gv2.load_engine_state(state_json)
  assert_true(gv2.memory_bank[0].is_core_memory)
}

///|
test "load_engine_state preserves simulation flag" {
  let gv1 = @ghostvalley.new_engine(max_memory_num=20)
  gv1.add_memory("模拟记忆", is_simulation=true)
  let state_json = gv1.save_engine_state()
  let gv2 = @ghostvalley.new_engine()
  gv2.load_engine_state(state_json)
  assert_true(gv2.memory_bank[0].is_simulation)
}

///|
test "load_engine_state preserves config" {
  let gv1 = @ghostvalley.new_engine(max_memory_num=42)
  ignore(gv1.wen_shi_verify("愿意接受挑战，接受压力训练"))
  let state_json = gv1.save_engine_state()
  let gv2 = @ghostvalley.new_engine()
  gv2.load_engine_state(state_json)
  assert_eq(gv2.max_memory_num, 42)
  assert_true(gv2.ghost_valley_enable)
}

///|
test "load_engine_state preserves stats" {
  let gv1 = @ghostvalley.new_engine(max_memory_num=30)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv1.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv1.run_training_pipeline(
    llm,
    rounds=3,
    decay_interval=2,
    cleanup_threshold=0.1,
  )
  let state_json = gv1.save_engine_state()
  let gv2 = @ghostvalley.new_engine()
  gv2.load_engine_state(state_json)
  let stats = gv2.get_training_stats()
  assert_eq(stats.total_rounds_completed, 3)
}

///|
test "load_engine_state invalid json no crash" {
  let gv = @ghostvalley.new_engine()
  gv.load_engine_state("not valid json")
  // 应不崩溃，状态不变
  assert_eq(gv.memory_count(), 0)
}

///|
test "load_engine_state empty string no crash" {
  let gv = @ghostvalley.new_engine()
  gv.load_engine_state("")
  assert_eq(gv.memory_count(), 0)
}

///|
test "save_engine_state empty engine" {
  let gv = @ghostvalley.new_engine()
  let state_json = gv.save_engine_state()
  assert_true(state_json.contains("memory_bank"))
}
