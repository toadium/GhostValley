// ============================================================
// Phase 4 (v1.12.0) 测试：可视化报告 + 导出增强
// ============================================================

///|
test "generate_ascii_chart 基本折线图" {
  let chart = @ghostvalley.generate_ascii_chart(
    [0.2, 0.4, 0.6, 0.8],
    title="训练分数趋势",
  )
  assert_true(chart.contains("训练分数趋势"))
  assert_true(chart.contains("●"))
}

///|
test "generate_ascii_chart 空数据" {
  let chart = @ghostvalley.generate_ascii_chart([], title="空")
  assert_true(chart.contains("无数据"))
}

///|
test "generate_ascii_chart 单个数据点" {
  let chart = @ghostvalley.generate_ascii_chart([0.5], title="单点")
  assert_true(chart.contains("单点"))
  assert_true(chart.contains("●"))
}

///|
test "generate_ascii_chart 相同值" {
  let chart = @ghostvalley.generate_ascii_chart([0.5, 0.5, 0.5], title="恒定")
  assert_true(chart.contains("恒定"))
}

///|
test "generate_ascii_chart 递减序列" {
  let chart = @ghostvalley.generate_ascii_chart(
    [0.8, 0.6, 0.4, 0.2],
    title="递减",
  )
  assert_true(chart.contains("递减"))
  assert_true(chart.contains("●"))
}

///|
test "generate_ascii_bar 基本柱状图" {
  let chart = @ghostvalley.generate_ascii_bar(
    [
      @ghostvalley.BarItem::{ label: "认知", value: 0.8 },
      @ghostvalley.BarItem::{ label: "情感", value: 0.5 },
    ],
    title="分类覆盖度",
  )
  assert_true(chart.contains("分类覆盖度"))
  assert_true(chart.contains("认知"))
  assert_true(chart.contains("情感"))
  assert_true(chart.contains("█"))
}

///|
test "generate_ascii_bar 空数据" {
  let chart = @ghostvalley.generate_ascii_bar([], title="空")
  assert_true(chart.contains("无数据"))
}

///|
test "generate_ascii_bar 零值" {
  let chart = @ghostvalley.generate_ascii_bar(
    [@ghostvalley.BarItem::{ label: "测试", value: 0.0 }],
    title="零值",
  )
  assert_true(chart.contains("测试"))
}

///|
test "generate_ascii_bar 满值" {
  let chart = @ghostvalley.generate_ascii_bar(
    [@ghostvalley.BarItem::{ label: "满分", value: 1.0 }],
    title="满值",
  )
  assert_true(chart.contains("满分"))
  assert_true(chart.contains("█"))
}

///|
test "render_dashboard 完整仪表盘" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=5,
    decay_interval=2,
    cleanup_threshold=0.1,
  )
  let dash = gv.render_dashboard()
  assert_true(dash.score_chart.length() > 0)
  assert_true(dash.summary.length() > 0)
}

///|
test "TrainingDashboard::format 输出完整仪表盘" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=5,
    decay_interval=2,
    cleanup_threshold=0.1,
  )
  let dash = gv.render_dashboard()
  let s = dash.format()
  assert_true(s.contains("幽灵谷训练仪表盘"))
  assert_true(s.contains("训练摘要"))
}

///|
test "export_full_report_markdown 基本报告" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=5,
    decay_interval=2,
    cleanup_threshold=0.1,
  )
  let report = gv.export_full_report_markdown()
  assert_true(report.contains("幽灵谷训练报告"))
  assert_true(report.contains("训练概览"))
  assert_true(report.contains("训练评估"))
  assert_true(report.contains("分类覆盖度"))
  assert_true(report.contains("分数趋势"))
  assert_true(report.contains("记忆库"))
  assert_true(report.contains("建议"))
}

///|
test "export_full_report_markdown 包含表格" {
  let gv = @ghostvalley.new_engine(max_memory_num=30)
  let llm = @ghostvalley.MockLLM::new()
  ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
  gv.run_training_pipeline(
    llm,
    rounds=3,
    decay_interval=2,
    cleanup_threshold=0.1,
  )
  let report = gv.export_full_report_markdown()
  assert_true(report.contains("| 指标 | 值 |"))
  assert_true(report.contains("|------|------|"))
}

///|
test "export_full_report_markdown 空训练" {
  let gv = @ghostvalley.new_engine()
  let report = gv.export_full_report_markdown()
  assert_true(report.contains("幽灵谷训练报告"))
}

///|
test "BarItem 序列化" {
  let item = @ghostvalley.BarItem::{ label: "测试", value: 0.5 }
  let json = @json.to_json(item)
  let str = json.stringify()
  assert_true(str.contains("测试"))
}

///|
test "TrainingDashboard 序列化" {
  let dash = @ghostvalley.TrainingDashboard::{
    score_chart: "chart",
    category_chart: "bar",
    memory_distribution: "dist",
    summary: "sum",
  }
  let json = @json.to_json(dash)
  let str = json.stringify()
  assert_true(str.contains("chart"))
}
