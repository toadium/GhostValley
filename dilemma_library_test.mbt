// ============================================================
// Phase 2 (v1.10.0) 测试：困境场景库 + 自定义困境模板
// ============================================================

///|
test "DilemmaTemplate::new 自动提取变量" {
  let t = @ghostvalley.DilemmaTemplate::new(
    "收到{count}条差评，涉及{product}",
    category="operational",
    difficulty=2,
  )
  assert_eq(t.variables.length(), 2)
  assert_true(t.variables.contains("count"))
  assert_true(t.variables.contains("product"))
}

///|
test "DilemmaTemplate::new 无变量" {
  let t = @ghostvalley.DilemmaTemplate::new(
    "团队冲突如何解决",
    category="social",
    difficulty=1,
  )
  assert_eq(t.variables.length(), 0)
}

///|
test "DilemmaTemplate::instantiate 变量替换" {
  let t = @ghostvalley.DilemmaTemplate::new(
    "收到{count}条差评，涉及{product}",
    category="operational",
    difficulty=2,
  )
  let d = t.instantiate([("count", "50"), ("product", "会员服务")])
  assert_true(d.content.contains("50"))
  assert_true(d.content.contains("会员服务"))
  assert_false(d.content.contains("{count}"))
}

///|
test "DilemmaTemplate::instantiate 部分变量未提供" {
  let t = @ghostvalley.DilemmaTemplate::new(
    "收到{count}条差评，涉及{product}",
    category="operational",
    difficulty=2,
  )
  let d = t.instantiate([("count", "50")])
  assert_true(d.content.contains("50"))
  assert_true(d.content.contains("{product}"))
}

///|
test "DilemmaTemplate::instantiate 保留分类和难度" {
  let t = @ghostvalley.DilemmaTemplate::new(
    "测试{var}",
    category="cognitive",
    difficulty=3,
  )
  let d = t.instantiate([("var", "值")])
  assert_eq(d.category, "cognitive")
  assert_eq(d.difficulty, 3)
}

///|
test "DilemmaLibrary::new 空场景库" {
  let lib = @ghostvalley.DilemmaLibrary::new()
  assert_eq(lib.scenario_count(), 0)
  assert_eq(lib.total_templates(), 0)
}

///|
test "DilemmaLibrary::with_presets 包含5个场景" {
  let lib = @ghostvalley.DilemmaLibrary::with_presets()
  let scenarios = lib.list_scenarios()
  assert_eq(scenarios.length(), 5)
  assert_true(scenarios.contains("客服危机"))
  assert_true(scenarios.contains("项目延期"))
  assert_true(scenarios.contains("团队冲突"))
  assert_true(scenarios.contains("技术选型失误"))
  assert_true(scenarios.contains("安全事故复盘"))
}

///|
test "DilemmaLibrary::with_presets 每场景至少5个困境" {
  let lib = @ghostvalley.DilemmaLibrary::with_presets()
  assert_true(lib.total_templates() >= 25)
}

///|
test "DilemmaLibrary::register_scenario 自定义场景" {
  let lib = @ghostvalley.DilemmaLibrary::new()
  lib.register_scenario("自定义场景", [
    @ghostvalley.DilemmaTemplate::new(
      "测试困境",
      category="cognitive",
      difficulty=1,
    ),
  ])
  assert_eq(lib.scenario_count(), 1)
  let scenarios = lib.list_scenarios()
  assert_true(scenarios.contains("自定义场景"))
}

///|
test "DilemmaLibrary::get_dilemmas 按难度筛选" {
  let lib = @ghostvalley.DilemmaLibrary::with_presets()
  let d1 = lib.get_dilemmas("客服危机", 1)
  let d2 = lib.get_dilemmas("客服危机", 2)
  let d3 = lib.get_dilemmas("客服危机", 3)
  assert_true(d1.length() >= 1)
  assert_true(d2.length() >= 1)
  assert_true(d3.length() >= 1)
}

///|
test "DilemmaLibrary::get_dilemmas 不存在的场景" {
  let lib = @ghostvalley.DilemmaLibrary::with_presets()
  let d = lib.get_dilemmas("不存在的场景", 1)
  assert_eq(d.length(), 0)
}

///|
test "DilemmaLibrary::get_all_templates 获取全部模板" {
  let lib = @ghostvalley.DilemmaLibrary::with_presets()
  let templates = lib.get_all_templates("客服危机")
  assert_true(templates.length() >= 5)
}

///|
test "DilemmaLibrary::get_all_templates 不存在的场景" {
  let lib = @ghostvalley.DilemmaLibrary::with_presets()
  let templates = lib.get_all_templates("不存在")
  assert_eq(templates.length(), 0)
}

///|
test "DilemmaLibrary::total_templates 统计正确" {
  let lib = @ghostvalley.DilemmaLibrary::new()
  lib.register_scenario("场景A", [
    @ghostvalley.DilemmaTemplate::new("A1", category="cognitive", difficulty=1),
    @ghostvalley.DilemmaTemplate::new("A2", category="cognitive", difficulty=2),
  ])
  lib.register_scenario("场景B", [
    @ghostvalley.DilemmaTemplate::new("B1", category="social", difficulty=1),
  ])
  assert_eq(lib.total_templates(), 3)
}

///|
test "DilemmaLibrary::format 输出包含场景名" {
  let lib = @ghostvalley.DilemmaLibrary::with_presets()
  let s = lib.format()
  assert_true(s.contains("客服危机"))
  assert_true(s.contains("项目延期"))
}

///|
test "DilemmaLibrary 序列化" {
  let lib = @ghostvalley.DilemmaLibrary::new()
  lib.register_scenario("测试", [
    @ghostvalley.DilemmaTemplate::new(
      "困境{var}",
      category="cognitive",
      difficulty=1,
    ),
  ])
  let json = @json.to_json(lib)
  let str = json.stringify()
  assert_true(str.contains("测试"))
}

///|
test "DilemmaTemplate 变量插值中文变量名" {
  let t = @ghostvalley.DilemmaTemplate::new(
    "收到{数量}条投诉",
    category="operational",
    difficulty=1,
  )
  assert_true(t.variables.contains("数量"))
  let d = t.instantiate([("数量", "100")])
  assert_true(d.content.contains("100"))
}

///|
test "预置场景困境覆盖所有分类" {
  let lib = @ghostvalley.DilemmaLibrary::with_presets()
  let templates = lib.get_all_templates("客服危机")
  let mut has_cognitive = false
  let mut has_emotional = false
  let mut has_social = false
  let mut has_operational = false
  for t in templates {
    if t.category == "cognitive" {
      has_cognitive = true
    }
    if t.category == "emotional" {
      has_emotional = true
    }
    if t.category == "social" {
      has_social = true
    }
    if t.category == "operational" {
      has_operational = true
    }
  }
  assert_true(has_cognitive)
  assert_true(has_emotional)
  assert_true(has_social)
  assert_true(has_operational)
}

///|
test "预置场景困境覆盖所有难度" {
  let lib = @ghostvalley.DilemmaLibrary::with_presets()
  for scenario in lib.list_scenarios() {
    let d1 = lib.get_dilemmas(scenario, 1)
    let d2 = lib.get_dilemmas(scenario, 2)
    let d3 = lib.get_dilemmas(scenario, 3)
    assert_true(d1.length() >= 1)
    assert_true(d2.length() >= 1)
    assert_true(d3.length() >= 1)
  }
}
