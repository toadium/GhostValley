///|
/// 属性测试：100 组确定性操作序列，检查核心记忆、计数一致性与分数范围。
test "property: operation sequences preserve invariants" {
  for seed in 0..<100 {
    let gv = @ghostvalley.new_engine(max_memory_num=8)
    gv.add_memory("核心记忆", is_simulation=false, is_core=true)
    for step in 0..<20 {
      let mode = (seed + step) % 4
      if mode == 0 {
        gv.apply_decay(1)
      } else if mode == 1 {
        ignore(gv.cleanup_low_value(0.05))
      } else {
        gv.add_memory(
          "普通" + step.to_string(),
          is_simulation=(seed + step) % 2 == 0,
        )
      }
    }
    assert_true(gv.core_memories().length() >= 1)
    let report = gv.training_report()
    assert_eq(report.total_memories, gv.memory_count())
    assert_eq(
      report.simulation_memories + report.real_memories,
      report.total_memories,
    )
    for memory in gv.memory_bank {
      assert_true(memory.value_score >= 0.0 && memory.value_score <= 1.0)
    }
  }
}

///|
/// 属性测试：衰减不增分；清理只删除低价值非核心记忆。
test "property: decay monotonic and cleanup threshold" {
  let gv = @ghostvalley.new_engine(max_memory_num=100)
  gv.add_memory("核心记忆", is_simulation=false, is_core=true)
  for i in 0..<10 {
    gv.add_memory("普通记忆" + i.to_string(), is_simulation=false)
  }
  let before : Array[Double] = []
  for memory in gv.memory_bank {
    before.push(memory.value_score)
  }
  gv.apply_decay(3)
  for i, memory in gv.memory_bank {
    assert_true(memory.value_score <= before[i])
  }
  assert_eq(gv.cleanup_low_value(0.0), 0)
  let removed = gv.cleanup_low_value(2.0)
  assert_true(removed >= 10)
  assert_eq(gv.core_memories().length(), 1)
  assert_eq(gv.memory_count(), 1)
}
