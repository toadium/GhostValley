// ============================================================
// Phase 4 (v1.12.0): 可视化报告 + 导出增强
// ============================================================

///|
/// 柱状图数据项
pub(all) struct BarItem {
  label : String
  value : Double
} derive(Debug, ToJson, FromJson)

///|
pub extend BarItem with @debug.Debug::{to_repr}

///|
pub extend BarItem with ToJson::{to_json}

///|
pub extend BarItem with FromJson::{from_json}

///|
/// 训练仪表盘
///
/// 整合训练全程的可视化信息。
pub(all) struct TrainingDashboard {
  score_chart : String
  category_chart : String
  memory_distribution : String
  summary : String
} derive(Debug, ToJson, FromJson)

///|
pub extend TrainingDashboard with @debug.Debug::{to_repr}

///|
pub extend TrainingDashboard with ToJson::{to_json}

///|
pub extend TrainingDashboard with FromJson::{from_json}

///|
/// 生成 ASCII 折线图
///
/// 将分数序列可视化为 ASCII 折线图。
/// 图高 10 行，宽随数据点数变化。
///
/// # Example
/// ```mbt check
/// test {
///   let chart = @ghostvalley.generate_ascii_chart(
///     [0.2, 0.4, 0.6, 0.8],
///     title="训练分数趋势",
///   )
///   assert_true(chart.contains("训练分数趋势"))
/// }
/// ```
pub fn generate_ascii_chart(scores : Array[Double], title~ : String) -> String {
  let buf = StringBuilder::new()
  buf.write_string("┌─ ")
  buf.write_string(title)
  buf.write_string(" ─┐\n")
  if scores.length() == 0 {
    buf.write_string(
      "│  (无数据)                                    │\n",
    )
    buf.write_string(
      "└──────────────────────────────────────────────┘\n",
    )
    return buf.to_string()
  }
  // 找最大最小值
  let mut min_val = scores[0]
  let mut max_val = scores[0]
  for s in scores {
    if s < min_val {
      min_val = s
    }
    if s > max_val {
      max_val = s
    }
  }
  if max_val == min_val {
    max_val = min_val + 0.1
  }
  let height = 10
  let width = scores.length()
  // 网格：height 行 × width 列
  let grid : Array[Array[Char]] = []
  for _ in 0..<height {
    let row : Array[Char] = []
    for _ in 0..<width {
      row.push(' ')
    }
    grid.push(row)
  }
  // 将每个数据点映射到网格行
  for col, score in scores {
    let normalized = (score - min_val) / (max_val - min_val)
    let row = height - 1 - (normalized * (height - 1).to_double()).to_int()
    let r = if row < 0 { 0 } else if row >= height { height - 1 } else { row }
    grid[r][col] = '●'
    // 连线：与前一个点之间填充
    if col > 0 {
      let prev_score = scores[col - 1]
      let prev_normalized = (prev_score - min_val) / (max_val - min_val)
      let prev_row = height -
        1 -
        (prev_normalized * (height - 1).to_double()).to_int()
      let pr = if prev_row < 0 {
        0
      } else if prev_row >= height {
        height - 1
      } else {
        prev_row
      }
      // 在 prev_row 和 row 之间填充
      let (lo, hi) = if pr < r { (pr, r) } else { (r, pr) }
      for mid in (lo + 1)..<hi {
        grid[mid][col] = '│'
      }
    }
  }
  // 输出网格
  for row in 0..<height {
    buf.write_string("│")
    for col in 0..<width {
      buf.write_char(grid[row][col])
      buf.write_string(" ")
    }
    buf.write_string("│")
    // 在第一行和最后一行标注最大最小值
    if row == 0 {
      buf.write_string(" ")
      buf.write_string(max_val.to_string())
    } else if row == height - 1 {
      buf.write_string(" ")
      buf.write_string(min_val.to_string())
    }
    buf.write_string("\n")
  }
  buf.write_string("└")
  let total_width = width * 2
  for _ in 0..<total_width {
    buf.write_string("─")
  }
  buf.write_string("┘\n")
  buf.to_string()
}

///|
/// 生成 ASCII 柱状图
///
/// 将分类数据可视化为 ASCII 柱状图。
///
/// # Example
/// ```mbt check
/// test {
///   let chart = @ghostvalley.generate_ascii_bar(
///     [
///       @ghostvalley.BarItem::{ label: "认知", value: 0.8 },
///       @ghostvalley.BarItem::{ label: "情感", value: 0.5 },
///     ],
///     title="分类覆盖度",
///   )
///   assert_true(chart.contains("分类覆盖度"))
/// }
/// ```
pub fn generate_ascii_bar(data : Array[BarItem], title~ : String) -> String {
  let buf = StringBuilder::new()
  buf.write_string("┌─ ")
  buf.write_string(title)
  buf.write_string(" ─┐\n")
  if data.length() == 0 {
    buf.write_string("│  (无数据)                │\n")
    buf.write_string(
      "└──────────────────────────┘\n",
    )
    return buf.to_string()
  }
  let max_bar = 30
  for item in data {
    buf.write_string("│ ")
    buf.write_string(item.label)
    // 对齐标签
    let label_len = item.label.length()
    for _ in label_len..<8 {
      buf.write_string(" ")
    }
    buf.write_string(" ")
    let bar_len = (item.value * max_bar.to_double()).to_int()
    let bl = if bar_len < 0 {
      0
    } else if bar_len > max_bar {
      max_bar
    } else {
      bar_len
    }
    for _ in 0..<bl {
      buf.write_string("█")
    }
    for _ in bl..<max_bar {
      buf.write_string(" ")
    }
    buf.write_string(" ")
    buf.write_string(item.value.to_string())
    buf.write_string("\n")
  }
  buf.write_string(
    "└──────────────────────────────────────────┘\n",
  )
  buf.to_string()
}

///|
/// 渲染训练仪表盘
///
/// 整合训练统计、评估、情绪状态，生成完整 ASCII 仪表盘。
pub fn GhostValleyEngine::render_dashboard(
  self : GhostValleyEngine,
) -> TrainingDashboard {
  let stats = self.training_stats
  // 分数趋势图
  let score_chart = generate_ascii_chart(
    stats.avg_score_history,
    title="训练分数趋势",
  )
  // 分类覆盖度柱状图
  let eval = self.evaluate_training()
  let bars : Array[BarItem] = []
  for cov in eval.category_coverages {
    bars.push(BarItem::{ label: cov.category, value: cov.percentage })
  }
  let category_chart = generate_ascii_bar(bars, title="分类覆盖度")
  // 记忆分布
  let mut core_count = 0
  let mut sim_count = 0
  let mut real_count = 0
  for m in self.memory_bank {
    if m.is_core_memory {
      core_count = core_count + 1
    }
    if m.is_simulation {
      sim_count = sim_count + 1
    } else {
      real_count = real_count + 1
    }
  }
  let mem_buf = StringBuilder::new()
  mem_buf.write_string("┌─ 记忆分布 ─┐\n")
  mem_buf.write_string("│ 核心记忆: ")
  mem_buf.write_string(core_count.to_string())
  mem_buf.write_string(" 条                │\n")
  mem_buf.write_string("│ 真实记忆: ")
  mem_buf.write_string(real_count.to_string())
  mem_buf.write_string(" 条                │\n")
  mem_buf.write_string("│ 模拟记忆: ")
  mem_buf.write_string(sim_count.to_string())
  mem_buf.write_string(" 条                │\n")
  mem_buf.write_string("│ 总计: ")
  mem_buf.write_string(self.memory_bank.length().to_string())
  mem_buf.write_string(" 条                    │\n")
  mem_buf.write_string(
    "└──────────────────────────┘\n",
  )
  // 摘要
  let summary_buf = StringBuilder::new()
  summary_buf.write_string("┌─ 训练摘要 ─┐\n")
  summary_buf.write_string("│ 总轮次: ")
  summary_buf.write_string(stats.total_rounds_completed.to_string())
  summary_buf.write_string("               │\n")
  summary_buf.write_string("│ 总记忆: ")
  summary_buf.write_string(stats.total_memories_added.to_string())
  summary_buf.write_string("               │\n")
  summary_buf.write_string("│ 衰减次数: ")
  summary_buf.write_string(stats.total_decay_applied.to_string())
  summary_buf.write_string("             │\n")
  summary_buf.write_string("│ 清理记忆: ")
  summary_buf.write_string(stats.total_memories_cleaned.to_string())
  summary_buf.write_string("             │\n")
  summary_buf.write_string("│ 评级: ")
  summary_buf.write_string(eval.overall_grade)
  summary_buf.write_string("                   │\n")
  summary_buf.write_string("│ 韧性分: ")
  summary_buf.write_string(eval.resilience_score.to_string())
  summary_buf.write_string("              │\n")
  summary_buf.write_string(
    "└──────────────────────────┘\n",
  )
  {
    score_chart,
    category_chart,
    memory_distribution: mem_buf.to_string(),
    summary: summary_buf.to_string(),
  }
}

///|
/// 仪表盘格式化为完整字符串
pub fn TrainingDashboard::format(self : TrainingDashboard) -> String {
  let buf = StringBuilder::new()
  buf.write_string(
    "╔══════════════════════════════════════╗\n",
  )
  buf.write_string("║      幽灵谷训练仪表盘                ║\n")
  buf.write_string(
    "╚══════════════════════════════════════╝\n\n",
  )
  buf.write_string(self.summary)
  buf.write_string("\n")
  buf.write_string(self.score_chart)
  buf.write_string("\n")
  buf.write_string(self.category_chart)
  buf.write_string("\n")
  buf.write_string(self.memory_distribution)
  buf.to_string()
}

///|
/// 导出完整 Markdown 报告
///
/// 生成包含表格、图表、建议的完整训练报告。
pub fn GhostValleyEngine::export_full_report_markdown(
  self : GhostValleyEngine,
) -> String {
  let buf = StringBuilder::new()
  let stats = self.training_stats
  let eval = self.evaluate_training()
  // 标题
  buf.write_string("# 幽灵谷训练报告\n\n")
  buf.write_string("## 1. 训练概览\n\n")
  buf.write_string("| 指标 | 值 |\n")
  buf.write_string("|------|------|\n")
  buf.write_string("| 总训练轮次 | ")
  buf.write_string(stats.total_rounds_completed.to_string())
  buf.write_string(" |\n")
  buf.write_string("| 总记忆数 | ")
  buf.write_string(stats.total_memories_added.to_string())
  buf.write_string(" |\n")
  buf.write_string("| 衰减次数 | ")
  buf.write_string(stats.total_decay_applied.to_string())
  buf.write_string(" |\n")
  buf.write_string("| 清理记忆数 | ")
  buf.write_string(stats.total_memories_cleaned.to_string())
  buf.write_string(" |\n")
  buf.write_string("| 当前记忆库大小 | ")
  buf.write_string(self.memory_bank.length().to_string())
  buf.write_string(" |\n\n")
  // 评估
  buf.write_string("## 2. 训练评估\n\n")
  buf.write_string("| 评估指标 | 值 |\n")
  buf.write_string("|----------|------|\n")
  buf.write_string("| 总体评级 | ")
  buf.write_string(eval.overall_grade)
  buf.write_string(" |\n")
  buf.write_string("| 韧性分 | ")
  buf.write_string(eval.resilience_score.to_string())
  buf.write_string(" |\n")
  buf.write_string("| 改善率 | ")
  buf.write_string(eval.improvement_rate.to_string())
  buf.write_string(" |\n")
  buf.write_string("| 平均分 | ")
  buf.write_string(eval.avg_score.to_string())
  buf.write_string(" |\n\n")
  // 分类覆盖
  buf.write_string("## 3. 分类覆盖度\n\n")
  buf.write_string("| 分类 | 轮次 | 占比 |\n")
  buf.write_string("|------|------|------|\n")
  for cov in eval.category_coverages {
    buf.write_string("| ")
    buf.write_string(cov.category)
    buf.write_string(" | ")
    buf.write_string(cov.rounds.to_string())
    buf.write_string(" | ")
    buf.write_string(cov.percentage.to_string())
    buf.write_string(" |\n")
  }
  buf.write_string("\n")
  // 分数趋势
  buf.write_string("## 4. 分数趋势\n\n")
  buf.write_string("```\n")
  buf.write_string(
    generate_ascii_chart(stats.avg_score_history, title="分数趋势"),
  )
  buf.write_string("```\n\n")
  // 记忆列表
  buf.write_string("## 5. 记忆库\n\n")
  for i, m in self.memory_bank {
    buf.write_string((i + 1).to_string() + ". ")
    if m.is_core_memory {
      buf.write_string("[核心] ")
    }
    if m.is_simulation {
      buf.write_string("[模拟] ")
    }
    buf.write_string("(分数:")
    buf.write_string(m.value_score.to_string())
    buf.write_string(", 访问:")
    buf.write_string(m.access_count.to_string())
    buf.write_string(") ")
    buf.write_string(m.content)
    buf.write_string("\n")
  }
  buf.write_string("\n")
  // 建议
  buf.write_string("## 6. 建议\n\n")
  if eval.resilience_score < 0.5 {
    buf.write_string(
      "- ⚠ 韧性分较低，建议增加高难度困境训练\n",
    )
  } else {
    buf.write_string(
      "- ✓ 韧性分良好，AI 在高难度下保持了能力\n",
    )
  }
  if eval.improvement_rate > 0.0 {
    buf.write_string("- ✓ 训练呈正向改善趋势\n")
  } else {
    buf.write_string(
      "- ⚠ 训练未呈现改善趋势，建议调整困境难度\n",
    )
  }
  let mut has_low_coverage = false
  for cov in eval.category_coverages {
    if cov.percentage < 0.15 {
      has_low_coverage = true
    }
  }
  if has_low_coverage {
    buf.write_string(
      "- ⚠ 部分分类覆盖不足，建议补充薄弱分类训练\n",
    )
  } else {
    buf.write_string("- ✓ 分类覆盖均衡\n")
  }
  buf.to_string()
}
