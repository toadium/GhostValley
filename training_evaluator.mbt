// ============================================================
// Phase 1: 训练评估 + 质量度量
// ============================================================

///|
/// 分类覆盖情况
///
/// 记录某个困境分类的训练轮次和占比。
pub(all) struct CategoryCoverage {
  category : String
  rounds : Int
  percentage : Double
} derive(Debug, ToJson, FromJson)

///|
pub extend CategoryCoverage with @debug.Debug::{to_repr}

///|
pub extend CategoryCoverage with ToJson::{to_json}

///|
pub extend CategoryCoverage with FromJson::{from_json}

///|
/// 综合训练评估报告
///
/// 包含韧性分、分类覆盖度、改善率、总体评级。
pub(all) struct TrainingEvaluation {
  resilience_score : Double
  category_coverages : Array[CategoryCoverage]
  improvement_rate : Double
  overall_grade : String
  total_rounds : Int
  avg_score : Double
} derive(Debug, ToJson, FromJson)

///|
pub extend TrainingEvaluation with @debug.Debug::{to_repr}

///|
pub extend TrainingEvaluation with ToJson::{to_json}

///|
pub extend TrainingEvaluation with FromJson::{from_json}

///|
/// 计算韧性分
///
/// resilience_score = 高难度困境平均响应分 / 低难度平均响应分
/// 衡量 AI 随难度提升的能力保持率。1.0 表示能力不随难度下降，
/// <1.0 表示高难度下能力下降。
/// 无低难度训练数据时返回 0.0。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=30)
///   let llm = @ghostvalley.MockLLM::new()
///   ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
///   gv.run_training_pipeline(
///     llm,
///     rounds=10,
///     decay_interval=5,
///     cleanup_threshold=0.1,
///   )
///   let resilience = gv.resilience_score()
///   assert_true(resilience >= 0.0)
/// }
/// ```
pub fn GhostValleyEngine::resilience_score(self : GhostValleyEngine) -> Double {
  let stats = self.training_stats
  let diff_hist = stats.round_difficulty_history
  let score_hist = stats.avg_score_history
  if diff_hist.length() == 0 || score_hist.length() == 0 {
    return 0.0
  }
  // 按难度分组收集响应分
  let mut high_sum = 0.0
  let mut high_count = 0
  let mut low_sum = 0.0
  let mut low_count = 0
  // diff_hist 和 score_hist 长度可能不同（score 在 round 后 push）
  let n = if diff_hist.length() < score_hist.length() {
    diff_hist.length()
  } else {
    score_hist.length()
  }
  for i in 0..<n {
    let diff = diff_hist[i]
    let score = score_hist[i]
    if diff >= 3 {
      high_sum = high_sum + score
      high_count = high_count + 1
    }
    if diff <= 1 {
      low_sum = low_sum + score
      low_count = low_count + 1
    }
  }
  if low_count == 0 || low_sum == 0.0 {
    return 0.0
  }
  let low_avg = low_sum / low_count.to_double()
  let high_avg = if high_count > 0 {
    high_sum / high_count.to_double()
  } else {
    0.0
  }
  high_avg / low_avg
}

///|
/// 计算分类覆盖情况
///
/// 返回 4 个分类各自的训练轮次和占比，识别薄弱分类。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=30)
///   let llm = @ghostvalley.MockLLM::new()
///   ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
///   gv.run_training_pipeline(
///     llm,
///     rounds=10,
///     decay_interval=5,
///     cleanup_threshold=0.1,
///   )
///   let coverages = gv.category_coverage()
///   assert_true(coverages.length() > 0)
/// }
/// ```
pub fn GhostValleyEngine::category_coverage(
  self : GhostValleyEngine,
) -> Array[CategoryCoverage] {
  let stats = self.training_stats
  let cat_hist = stats.round_category_history
  let total = cat_hist.length()
  let categories = ["cognitive", "emotional", "social", "operational"]
  let result : Array[CategoryCoverage] = []
  for cat in categories {
    let mut count = 0
    for c in cat_hist {
      if c == cat {
        count = count + 1
      }
    }
    let pct = if total > 0 {
      count.to_double() / total.to_double()
    } else {
      0.0
    }
    result.push(CategoryCoverage::{
      category: cat,
      rounds: count,
      percentage: pct,
    })
  }
  result
}

///|
/// 计算改善率
///
/// 使用线性回归斜率量化平均分随轮次的变化趋势。
/// 正值表示进步，负值表示退化，0 表示稳定。
/// 不足 2 轮数据时返回 0.0。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=30)
///   let llm = @ghostvalley.MockLLM::new()
///   ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
///   gv.run_training_pipeline(
///     llm,
///     rounds=10,
///     decay_interval=5,
///     cleanup_threshold=0.1,
///   )
///   let rate = gv.improvement_rate()
///   assert_true(rate >= -1.0 && rate <= 1.0)
/// }
/// ```
pub fn GhostValleyEngine::improvement_rate(self : GhostValleyEngine) -> Double {
  let hist = self.training_stats.avg_score_history
  let n = hist.length()
  if n < 2 {
    return 0.0
  }
  // 线性回归斜率 = Σ((x - x_mean)(y - y_mean)) / Σ((x - x_mean)²)
  let n_d = n.to_double()
  let mut x_mean = 0.0
  let mut y_mean = 0.0
  for i in 0..<n {
    x_mean = x_mean + i.to_double()
    y_mean = y_mean + hist[i]
  }
  x_mean = x_mean / n_d
  y_mean = y_mean / n_d
  let mut numerator = 0.0
  let mut denominator = 0.0
  for i in 0..<n {
    let x_diff = i.to_double() - x_mean
    let y_diff = hist[i] - y_mean
    numerator = numerator + x_diff * y_diff
    denominator = denominator + x_diff * x_diff
  }
  if denominator == 0.0 {
    return 0.0
  }
  numerator / denominator
}

///|
/// 综合训练评估
///
/// 返回包含韧性分、覆盖度、改善率、总体评级的综合报告。
/// 评级标准：
/// - S: 韧性 >= 0.9 且 改善率 > 0 且 4 分类全覆盖
/// - A: 韧性 >= 0.8 且 改善率 >= 0
/// - B: 韧性 >= 0.7
/// - C: 韧性 >= 0.5
/// - D: 其他
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=30)
///   let llm = @ghostvalley.MockLLM::new()
///   ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
///   gv.run_training_pipeline(
///     llm,
///     rounds=10,
///     decay_interval=5,
///     cleanup_threshold=0.1,
///   )
///   let eval = gv.evaluate_training()
///   assert_true(eval.overall_grade.length() == 1)
/// }
/// ```
pub fn GhostValleyEngine::evaluate_training(
  self : GhostValleyEngine,
) -> TrainingEvaluation {
  let resilience = self.resilience_score()
  let coverages = self.category_coverage()
  let improvement = self.improvement_rate()
  let total_rounds = self.training_stats.total_rounds_completed
  let avg_score = self.average_value_score()
  // 计算覆盖分类数
  let mut covered_categories = 0
  for c in coverages {
    if c.rounds > 0 {
      covered_categories = covered_categories + 1
    }
  }
  // 评级
  let grade = if resilience >= 0.9 &&
    improvement > 0.0 &&
    covered_categories >= 4 {
    "S"
  } else if resilience >= 0.8 && improvement >= 0.0 {
    "A"
  } else if resilience >= 0.7 {
    "B"
  } else if resilience >= 0.5 {
    "C"
  } else {
    "D"
  }
  TrainingEvaluation::{
    resilience_score: resilience,
    category_coverages: coverages,
    improvement_rate: improvement,
    overall_grade: grade,
    total_rounds,
    avg_score,
  }
}

///|
/// 格式化训练评估报告
pub fn TrainingEvaluation::format(self : TrainingEvaluation) -> String {
  let buf = StringBuilder::new()
  buf <+ "======== 训练评估报告 ========\n"
  buf <+ "总体评级: \{self.overall_grade}\n"
  buf <+ "韧性分: \{self.resilience_score}\n"
  buf <+ "改善率: \{self.improvement_rate}\n"
  buf <+ "平均分: \{self.avg_score}\n"
  buf <+ "总轮次: \{self.total_rounds}\n"
  buf <+ "-------- 分类覆盖 --------\n"
  for c in self.category_coverages {
    buf <+ "  \{c.category}: \{c.rounds} 轮 (\{c.percentage * 100.0}%)\n"
  }
  buf.to_string()
}
