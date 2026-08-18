///|
test "search_memories finds by keyword" {
  let gv = @ghostvalley.new_engine()
  gv.add_memory("顿悟失败原因，反思改进", is_simulation=false)
  gv.add_memory("普通日常记录", is_simulation=false)
  gv.add_memory("再次顿悟新知识", is_simulation=false)
  let results = gv.search_memories("顿悟")
  assert_eq(results.length(), 2)
}

///|
test "search_memories no match returns empty" {
  let gv = @ghostvalley.new_engine()
  gv.add_memory("普通记忆", is_simulation=false)
  let results = gv.search_memories("不存在的关键词")
  assert_eq(results.length(), 0)
}

///|
test "search_memories empty keyword matches all" {
  let gv = @ghostvalley.new_engine()
  gv.add_memory("记忆A", is_simulation=false)
  gv.add_memory("记忆B", is_simulation=false)
  let results = gv.search_memories("")
  assert_eq(results.length(), 2)
}

///|
test "top_memories returns sorted by score" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("顿悟反思改进修复迭代", is_simulation=false)
  gv.add_memory("普通日常随便应付", is_simulation=false)
  let top = gv.top_memories(2)
  assert_eq(top.length(), 2)
  assert_true(top[0].value_score >= top[1].value_score)
}

///|
test "top_memories n exceeds total" {
  let gv = @ghostvalley.new_engine()
  gv.add_memory("记忆A", is_simulation=false)
  let top = gv.top_memories(10)
  assert_eq(top.length(), 1)
}

///|
test "top_memories zero n" {
  let gv = @ghostvalley.new_engine()
  gv.add_memory("记忆A", is_simulation=false)
  let top = gv.top_memories(0)
  assert_eq(top.length(), 0)
}

///|
test "filter_memories by simulation only" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("模拟挫折", is_simulation=true)
  gv.add_memory("真实记忆", is_simulation=false)
  gv.add_memory("又一个模拟", is_simulation=true)
  let sims = gv.filter_memories(is_simulation=Some(true))
  assert_eq(sims.length(), 2)
  let reals = gv.filter_memories(is_simulation=Some(false))
  assert_eq(reals.length(), 1)
}

///|
test "filter_memories by core only" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("核心记忆", is_simulation=false, is_core=true)
  gv.add_memory("普通记忆", is_simulation=false)
  let cores = gv.filter_memories(is_core=Some(true))
  assert_eq(cores.length(), 1)
}

///|
test "filter_memories by both flags" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("核心模拟", is_simulation=true, is_core=true)
  gv.add_memory("核心真实", is_simulation=false, is_core=true)
  gv.add_memory("普通模拟", is_simulation=true)
  gv.add_memory("普通真实", is_simulation=false)
  let result = gv.filter_memories(is_simulation=Some(true), is_core=Some(true))
  assert_eq(result.length(), 1)
}

///|
test "filter_memories no filter returns all" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  gv.add_memory("记忆B", is_simulation=true)
  let all = gv.filter_memories()
  assert_eq(all.length(), 2)
}

///|
test "average_value_score empty bank" {
  let gv = @ghostvalley.new_engine()
  let avg = gv.average_value_score()
  assert_eq(avg, 0.0)
}

///|
test "average_value_score computes mean" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("顿悟反思改进", is_simulation=false)
  gv.add_memory("普通日常随便", is_simulation=false)
  let avg = gv.average_value_score()
  assert_true(avg > 0.0)
  assert_true(avg <= 1.0)
}

///|
test "real_memories and simulation_memories" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("真实1", is_simulation=false)
  gv.add_memory("模拟1", is_simulation=true)
  gv.add_memory("真实2", is_simulation=false)
  assert_eq(gv.real_memories().length(), 2)
  assert_eq(gv.simulation_memories().length(), 1)
}

///|
test "core_memories convenience method" {
  let gv = @ghostvalley.new_engine(max_memory_num=20)
  gv.add_memory("核心1", is_simulation=false, is_core=true)
  gv.add_memory("普通1", is_simulation=false)
  gv.add_memory("核心2", is_simulation=true, is_core=true)
  assert_eq(gv.core_memories().length(), 2)
}
