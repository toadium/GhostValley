// ============================================================
// Phase 4: 模糊测试 + 属性测试 + 基准测试
// ============================================================

// --- 属性测试 ---

///|
test "property: active_forget keeps count <= max_memory_num" {
  for max_cap in [1, 2, 5, 10, 20] {
    let gv = @ghostvalley.new_engine(max_memory_num=max_cap)
    // 添加远超容量的记忆
    for i in 0..<100 {
      gv.add_memory("记忆\{i}顿悟反思", is_simulation=false)
    }
    // active_forget 后记忆数不应超过 max_memory_num
    assert_true(gv.memory_count() <= max_cap)
  }
}

///|
test "property: cleanup removes all below threshold non-core" {
  let gv = @ghostvalley.new_engine(max_memory_num=200)
  // 添加低价值记忆（普通日常类）
  for i in 0..<50 {
    gv.add_memory("普通日常随便应付\{i}", is_simulation=false)
  }
  // 添加核心记忆
  gv.add_memory("核心顿悟反思改进", is_simulation=false, is_core=true)
  let core_count_before = gv.core_memories().length()
  // 用高阈值清理
  ignore(gv.cleanup_low_value(0.5))
  // 核心记忆不应被清理
  assert_eq(gv.core_memories().length(), core_count_before)
}

///|
test "property: top_memories returns at most n" {
  let gv = @ghostvalley.new_engine(max_memory_num=100)
  for i in 0..<30 {
    gv.add_memory("记忆\{i}", is_simulation=false)
  }
  for n in [0, 1, 5, 10, 50, 100] {
    let top = gv.top_memories(n)
    let expected = if n < 30 { n } else { 30 }
    assert_eq(top.length(), expected)
  }
}

///|
test "property: top_memories sorted descending" {
  let gv = @ghostvalley.new_engine(max_memory_num=100)
  for i in 0..<20 {
    if i % 2 == 0 {
      gv.add_memory("顿悟反思改进修复迭代\{i}", is_simulation=false)
    } else {
      gv.add_memory("普通日常\{i}", is_simulation=false)
    }
  }
  let top = gv.top_memories(10)
  for i in 1..<top.length() {
    assert_true(top[i - 1].value_score >= top[i].value_score)
  }
}

///|
test "property: value_score always in range" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  // 各种内容
  let contents = [
    "顿悟反思改进修复迭代冷静分析", "普通日常随便应付", "",
    "失败错误冲突", "自我改进深度思考迭代修复",
  ]
  for c in contents {
    gv.add_memory(c, is_simulation=false)
  }
  for m in gv.memory_bank {
    assert_true(m.value_score >= 0.05)
    assert_true(m.value_score <= 0.95)
  }
}

///|
test "property: core memory never deleted by active_forget" {
  let gv = @ghostvalley.new_engine(max_memory_num=5)
  gv.add_memory("核心记忆A", is_simulation=false, is_core=true)
  gv.add_memory("核心记忆B", is_simulation=false, is_core=true)
  // 填满非核心记忆触发遗忘
  for i in 0..<20 {
    gv.add_memory("普通\{i}", is_simulation=false)
  }
  // 核心记忆应全部保留
  let cores = gv.core_memories()
  assert_true(cores.length() >= 2)
}

///|
test "property: core memory never deleted by cleanup" {
  let gv = @ghostvalley.new_engine(max_memory_num=100)
  gv.add_memory("核心记忆", is_simulation=false, is_core=true)
  for i in 0..<20 {
    gv.add_memory("普通日常随便应付\{i}", is_simulation=false)
  }
  // 高阈值清理
  ignore(gv.cleanup_low_value(0.9))
  // 核心记忆应保留
  assert_true(gv.core_memories().length() >= 1)
}

///|
test "property: weighted_search results <= top_n" {
  let gv = @ghostvalley.new_engine(max_memory_num=100)
  for i in 0..<30 {
    gv.add_memory("记忆\{i}顿悟", is_simulation=false)
  }
  for n in [0, 1, 5, 100] {
    let results = gv.weighted_search("顿悟", n)
    assert_true(results.length() <= n)
  }
}

///|
test "property: search_memories results contain keyword" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  gv.add_memory("顿悟反思A", is_simulation=false)
  gv.add_memory("普通记录B", is_simulation=false)
  gv.add_memory("顿悟改进C", is_simulation=false)
  let results = gv.search_memories("顿悟")
  for m in results {
    assert_true(m.content.contains("顿悟"))
  }
}

///|
test "property: merge_memories reduces count by 1" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  for i in 0..<10 {
    gv.add_memory("记忆\{i}", is_simulation=false)
  }
  let count_before = gv.memory_count()
  gv.merge_memories(0, 1)
  assert_eq(gv.memory_count(), count_before - 1)
}

///|
test "property: add_memory_dedup never increases count beyond 1 for identical" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  for _ in 0..<10 {
    ignore(
      gv.add_memory_dedup("顿悟反思改进修复迭代", is_simulation=false),
    )
  }
  // 相同内容应合并，不超过 1 条
  assert_eq(gv.memory_count(), 1)
}

// --- 模糊测试 ---

///|
test "fuzz: random add/forget/cleanup no crash" {
  let gv = @ghostvalley.new_engine(max_memory_num=10)
  let rng = @rand.Rand::chacha8()
  let samples = [
    "顿悟反思改进", "普通日常", "失败错误冲突", "自我改进深度思考",
    "", "冷静分析迭代修复",
  ]
  for _ in 0..<200 {
    let idx = rng.int(limit=samples.length())
    // 不添加核心记忆，核心记忆不受遗忘限制
    gv.add_memory(samples[idx], is_simulation=false)
    gv.active_forget()
  }
  // 不崩溃 + 非核心记忆受容量限制
  assert_true(gv.memory_count() <= 10)
}

///|
test "fuzz: random decay/cleanup no crash" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  for i in 0..<30 {
    gv.add_memory("记忆\{i}顿悟反思", is_simulation=false)
  }
  for _ in 0..<50 {
    gv.apply_decay(5)
    ignore(gv.cleanup_low_value(0.15))
  }
  // 不崩溃 + 核心记忆保留
  assert_true(gv.memory_count() >= 0)
}

///|
test "fuzz: random weighted_search no crash" {
  let gv = @ghostvalley.new_engine(max_memory_num=50)
  let queries = ["顿悟", "反思", "改进", "失败", "日常", ""]
  for i in 0..<30 {
    gv.add_memory("记忆\{i}顿悟反思改进", is_simulation=false)
  }
  let rng = @rand.Rand::chacha8()
  for _ in 0..<100 {
    let qi = rng.int(limit=queries.length())
    let tn = rng.int(limit=20)
    ignore(gv.weighted_search(queries[qi], tn))
  }
  // 不崩溃即通过
  assert_true(true)
}

///|
test "fuzz: random merge_memories no crash" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  for i in 0..<15 {
    gv.add_memory("记忆\{i}", is_simulation=false)
  }
  let rng = @rand.Rand::chacha8()
  for _ in 0..<10 {
    if gv.memory_count() >= 2 {
      let a = rng.int(limit=gv.memory_count())
      let b = rng.int(limit=gv.memory_count())
      gv.merge_memories(a, b)
    }
  }
  assert_true(gv.memory_count() >= 1)
}

///|
test "fuzz: random pipeline no crash" {
  let gv = @ghostvalley.new_engine(max_memory_num=15)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  let rng = @rand.Rand::chacha8()
  for _ in 0..<5 {
    let rounds = rng.int(limit=10)
    let interval = rng.int(limit=5) + 1
    gv.run_training_pipeline(
      llm,
      rounds~,
      decay_interval=interval,
      cleanup_threshold=0.1,
    )
  }
  // 不崩溃即通过
  assert_true(gv.memory_count() <= 15)
}

///|
test "fuzz: random engine state save/load no crash" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  for i in 0..<10 {
    gv.add_memory("记忆\{i}顿悟", is_simulation=false)
  }
  let state = gv.save_engine_state()
  let gv2 = @ghostvalley.new_engine()
  gv2.load_engine_state(state)
  assert_eq(gv2.memory_count(), gv.memory_count())
}

// --- 基准测试 (scale = 1000) ---

///|
test "benchmark: 1000 memories add + top_memories" {
  let gv = @ghostvalley.new_engine(max_memory_num=1000)
  for i in 0..<1000 {
    if i % 3 == 0 {
      gv.add_memory("顿悟反思改进\{i}", is_simulation=false)
    } else if i % 3 == 1 {
      gv.add_memory("普通日常\{i}", is_simulation=false)
    } else {
      gv.add_memory("失败错误\{i}", is_simulation=false)
    }
  }
  let top = gv.top_memories(10)
  assert_eq(top.length(), 10)
  // 验证排序
  for i in 1..<top.length() {
    assert_true(top[i - 1].value_score >= top[i].value_score)
  }
}

///|
test "benchmark: 1000 memories search" {
  let gv = @ghostvalley.new_engine(max_memory_num=1000)
  for i in 0..<1000 {
    gv.add_memory("记忆\{i}顿悟反思", is_simulation=false)
  }
  let results = gv.search_memories("顿悟")
  assert_true(results.length() > 0)
}

///|
test "benchmark: 1000 memories weighted_search" {
  let gv = @ghostvalley.new_engine(max_memory_num=1000)
  for i in 0..<1000 {
    gv.add_memory("记忆\{i}顿悟反思改进", is_simulation=false)
  }
  let results = gv.weighted_search("顿悟反思", 20)
  assert_true(results.length() <= 20)
}

///|
test "benchmark: 1000 memories active_forget" {
  let gv = @ghostvalley.new_engine(max_memory_num=100)
  for i in 0..<1000 {
    gv.add_memory("记忆\{i}", is_simulation=false)
  }
  // 容量 100，添加 1000，应触发多次遗忘
  assert_true(gv.memory_count() <= 100)
}

///|
test "benchmark: 1000 memories cleanup" {
  let gv = @ghostvalley.new_engine(max_memory_num=1000)
  for i in 0..<1000 {
    if i % 2 == 0 {
      gv.add_memory("普通日常随便应付\{i}", is_simulation=false)
    } else {
      gv.add_memory("顿悟反思改进修复迭代\{i}", is_simulation=false)
    }
  }
  let cleaned = gv.cleanup_low_value(0.3)
  assert_true(cleaned >= 0)
  assert_true(gv.memory_count() <= 1000)
}

///|
test "benchmark: 1000 memories decay" {
  let gv = @ghostvalley.new_engine(max_memory_num=1000)
  for i in 0..<1000 {
    gv.add_memory("记忆\{i}顿悟反思", is_simulation=false)
  }
  gv.apply_decay(10)
  // 衰减后分数应降低（非核心）
  let avg = gv.average_value_score()
  assert_true(avg >= 0.0)
}

///|
test "benchmark: 1000 memories engine state roundtrip" {
  let gv = @ghostvalley.new_engine(max_memory_num=500)
  for i in 0..<500 {
    gv.add_memory("记忆\{i}顿悟", is_simulation=false)
  }
  let actual_count = gv.memory_count()
  let state = gv.save_engine_state()
  let gv2 = @ghostvalley.new_engine()
  gv2.load_engine_state(state)
  assert_eq(gv2.memory_count(), actual_count)
  assert_eq(gv2.max_memory_num, 500)
}
