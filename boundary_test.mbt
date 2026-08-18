///|
test "boundary: empty engine operations" {
  let gv = @ghostvalley.new_engine()
  assert_eq(gv.memory_count(), 0)
  assert_eq(gv.average_value_score(), 0.0)
  assert_eq(gv.search_memories("任意").length(), 0)
  assert_eq(gv.top_memories(5).length(), 0)
  assert_eq(gv.filter_memories().length(), 0)
  assert_eq(gv.real_memories().length(), 0)
  assert_eq(gv.simulation_memories().length(), 0)
  assert_eq(gv.core_memories().length(), 0)
  assert_eq(gv.min_value_score(), 0.0)
  assert_eq(gv.max_value_score(), 0.0)
  assert_eq(gv.cleanup_low_value(0.5), 0)
  gv.apply_decay(100)
  assert_eq(gv.memory_count(), 0)
}

///|
test "boundary: disabled engine returns none" {
  let gv = @ghostvalley.new_engine()
  assert_true(gv.ghost_valley_run_one_round() is None)
  let results = gv.ghost_valley_run_rounds(5)
  for r in results {
    assert_true(r is None)
  }
}

///|
test "boundary: dilemma pool empty after set" {
  let gv = @ghostvalley.new_engine()
  gv.set_dilemma_pool([])
  assert_eq(gv.dilemma_pool_size(), 0)
}

///|
test "boundary: add_dilemma to custom pool" {
  let gv = @ghostvalley.new_engine()
  gv.set_dilemma_pool(["自定义困境"])
  gv.add_dilemma("另一个困境")
  assert_eq(gv.dilemma_pool_size(), 2)
}

///|
test "boundary: set_dilemma_pool replaces entirely" {
  let gv = @ghostvalley.new_engine()
  let original_size = gv.dilemma_pool_size()
  gv.set_dilemma_pool(["新困境A", "新困境B", "新困境C"])
  assert_eq(gv.dilemma_pool_size(), 3)
  assert_true(gv.dilemma_pool_size() != original_size)
}

///|
test "boundary: memory capacity one" {
  let gv = @ghostvalley.new_engine(max_memory_num=1)
  gv.add_memory("记忆A", is_simulation=false)
  gv.add_memory("记忆B", is_simulation=false)
  // active_forget removes 30% of non-core when bank > max/2
  // with max=1, max/2=0, so forget triggers but removes 2*3/10=0
  assert_true(gv.memory_count() >= 1)
}

///|
test "boundary: core memory survives all operations" {
  let gv = @ghostvalley.new_engine(max_memory_num=4)
  gv.add_memory("核心记忆", is_simulation=false, is_core=true)
  for _ in 0..<20 {
    gv.add_memory("普通记忆", is_simulation=false)
  }
  gv.apply_decay(100)
  ignore(gv.cleanup_low_value(0.99))
  let cores = gv.core_memories()
  assert_true(cores.length() >= 1)
}

///|
test "boundary: negative rounds in run_rounds" {
  let gv = @ghostvalley.new_engine()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  let results = gv.ghost_valley_run_rounds(-1)
  assert_eq(results.length(), 0)
}

///|
test "boundary: top_memories negative n" {
  let gv = @ghostvalley.new_engine()
  gv.add_memory("记忆A", is_simulation=false)
  let top = gv.top_memories(-1)
  assert_eq(top.length(), 0)
}

///|
test "boundary: cleanup_low_value threshold zero" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("普通记忆", is_simulation=false)
  let removed = gv.cleanup_low_value(0.0)
  assert_eq(removed, 0)
}

///|
test "boundary: cleanup_low_value negative threshold" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("普通记忆", is_simulation=false)
  let removed = gv.cleanup_low_value(-1.0)
  assert_eq(removed, 0)
}

///|
test "boundary: training log empty export" {
  let gv = @ghostvalley.new_engine()
  let json_str = gv.export_training_log_string()
  assert_true(json_str.contains("[]"))
  let format_str = gv.export_training_log_format()
  assert_true(format_str.contains("共 0 轮"))
}

///|
test "boundary: decay then cleanup workflow" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  for _ in 0..<5 {
    gv.add_memory("普通日常随便应付", is_simulation=false)
  }
  gv.add_memory(
    "顿悟反思改进修复迭代",
    is_simulation=false,
    is_core=true,
  )
  gv.apply_decay(100)
  let removed = gv.cleanup_low_value(0.1)
  assert_true(removed >= 0)
  assert_true(gv.core_memories().length() == 1)
}

///|
test "boundary: filter with both None returns all" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("A", is_simulation=false)
  gv.add_memory("B", is_simulation=true, is_core=true)
  gv.add_memory("C", is_simulation=false, is_core=true)
  let all = gv.filter_memories(is_simulation=None, is_core=None)
  assert_eq(all.length(), 3)
}
