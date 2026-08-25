///|
test "save_memory empty" {
  let gv = @ghostvalley.new_engine()
  let json = gv.save_memory()
  assert_true(json.stringify() == "[]")
}

///|
test "save_load_memory roundtrip" {
  let gv = @ghostvalley.new_engine()
  gv.add_memory("测试记忆", is_simulation=false)
  gv.add_memory("模拟挫折", is_simulation=true)
  let json = gv.save_memory()
  let gv2 = @ghostvalley.new_engine()
  gv2.load_memory(json)
  assert_eq(gv2.memory_count(), 2)
}

///|
test "save_load_memory_string roundtrip" {
  let gv = @ghostvalley.new_engine()
  gv.add_memory("顿悟记忆", is_simulation=false)
  let json_str = gv.save_memory_string()
  assert_true(json_str.contains("顿悟记忆"))
  let gv2 = @ghostvalley.new_engine()
  gv2.load_memory_string(json_str)
  assert_eq(gv2.memory_count(), 1)
}

///|
test "load_memory invalid json type" {
  let gv = @ghostvalley.new_engine()
  gv.load_memory(Json::null())
  assert_eq(gv.memory_count(), 0)
}

///|
test "save_memory preserves core flag" {
  let gv = @ghostvalley.new_engine()
  gv.add_memory("核心记忆", is_simulation=false, is_core=true)
  let json = gv.save_memory()
  let gv2 = @ghostvalley.new_engine()
  gv2.load_memory(json)
  assert_eq(gv2.memory_count(), 1)
  let mem = gv2.memory_bank[0]
  assert_true(mem.is_core_memory)
}

///|
test "save_memory preserves simulation flag" {
  let gv = @ghostvalley.new_engine()
  gv.add_memory("模拟记忆", is_simulation=true)
  let json = gv.save_memory()
  let gv2 = @ghostvalley.new_engine()
  gv2.load_memory(json)
  let mem = gv2.memory_bank[0]
  assert_true(mem.is_simulation)
}
