// ============================================================
// Phase 4: 高级统计 + 导出
// ============================================================

///|
/// 置信区间
///
/// 计算给定分数序列的置信区间。
/// level: 0.90 / 0.95 / 0.99 对应 z = 1.645 / 1.96 / 2.576
///
/// # Example
/// ```mbt check
/// test {
///   let scores = [0.3, 0.4, 0.5, 0.6, 0.7]
///   let (lower, upper) = @ghostvalley.confidence_interval(scores, 0.95)
///   assert_true(lower < upper)
/// }
/// ```
pub fn confidence_interval(
  scores : Array[Double],
  level : Double,
) -> (Double, Double) {
  let n = scores.length()
  if n < 2 {
    let m = if n == 0 { 0.0 } else { scores[0] }
    return (m, m)
  }
  // 均值
  let mut sum = 0.0
  for s in scores {
    sum = sum + s
  }
  let mean = sum / n.to_double()
  // 标准差
  let mut var_sum = 0.0
  for s in scores {
    let diff = s - mean
    var_sum = var_sum + diff * diff
  }
  let std = (var_sum / (n - 1).to_double()).sqrt()
  // z 值
  let z = if level >= 0.99 {
    2.576
  } else if level >= 0.95 {
    1.96
  } else {
    1.645
  }
  let margin = z * std / n.to_double().sqrt()
  (mean - margin, mean + margin)
}

///|
/// 显著性检验结果
pub(all) struct SignificanceResult {
  is_significant : Bool
  t_value : Double
  mean_before : Double
  mean_after : Double
  difference : Double
} derive(Debug, ToJson, FromJson)

///|
pub extend SignificanceResult with @debug.Debug::{to_repr}

///|
pub extend SignificanceResult with ToJson::{to_json}

///|
pub extend SignificanceResult with FromJson::{from_json}

///|
/// 显著性检验（简化 t 检验）
///
/// 检验训练前后分数差异是否显著。
/// |t| > 1.96 视为显著（p < 0.05）。
///
/// # Example
/// ```mbt check
/// test {
///   let before = [0.2, 0.3, 0.25, 0.35, 0.3]
///   let after = [0.5, 0.6, 0.55, 0.65, 0.6]
///   let result = @ghostvalley.significance_test(before, after)
///   assert_true(result.is_significant)
/// }
/// ```
pub fn significance_test(
  before_scores : Array[Double],
  after_scores : Array[Double],
) -> SignificanceResult {
  let n_before = before_scores.length()
  let n_after = after_scores.length()
  if n_before == 0 || n_after == 0 {
    return SignificanceResult::{
      is_significant: false,
      t_value: 0.0,
      mean_before: 0.0,
      mean_after: 0.0,
      difference: 0.0,
    }
  }
  // 均值
  let mut sum_b = 0.0
  for s in before_scores {
    sum_b = sum_b + s
  }
  let mean_b = sum_b / n_before.to_double()
  let mut sum_a = 0.0
  for s in after_scores {
    sum_a = sum_a + s
  }
  let mean_a = sum_a / n_after.to_double()
  let diff = mean_a - mean_b
  // 标准差
  let mut var_b = 0.0
  for s in before_scores {
    let d = s - mean_b
    var_b = var_b + d * d
  }
  let std_b = if n_before > 1 {
    (var_b / (n_before - 1).to_double()).sqrt()
  } else {
    0.0
  }
  let mut var_a = 0.0
  for s in after_scores {
    let d = s - mean_a
    var_a = var_a + d * d
  }
  let std_a = if n_after > 1 {
    (var_a / (n_after - 1).to_double()).sqrt()
  } else {
    0.0
  }
  // 合并标准误
  let se_b = std_b * std_b / n_before.to_double()
  let se_a = std_a * std_a / n_after.to_double()
  let pooled_se = (se_b + se_a).sqrt()
  let t = if pooled_se > 0.0 { diff / pooled_se } else { 0.0 }
  SignificanceResult::{
    is_significant: t.abs() > 1.96,
    t_value: t,
    mean_before: mean_b,
    mean_after: mean_a,
    difference: diff,
  }
}

///|
/// 导出训练统计为 CSV
///
/// 列: round, avg_score, memory_count, category, difficulty
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=30)
///   let llm = @ghostvalley.MockLLM::new()
///   ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
///   gv.run_training_pipeline(
///     llm,
///     rounds=3,
///     decay_interval=5,
///     cleanup_threshold=0.1,
///   )
///   let csv = gv.export_report_csv()
///   assert_true(csv.contains("round"))
/// }
/// ```
pub fn GhostValleyEngine::export_report_csv(self : GhostValleyEngine) -> String {
  let buf = StringBuilder::new()
  buf <+ "round,avg_score,memory_count,category,difficulty\n"
  let stats = self.training_stats
  let n = stats.avg_score_history.length()
  for i in 0..<n {
    let avg = stats.avg_score_history[i]
    let mc = if i < stats.memory_count_history.length() {
      stats.memory_count_history[i]
    } else {
      0
    }
    let cat = if i < stats.round_category_history.length() {
      stats.round_category_history[i]
    } else {
      ""
    }
    let diff = if i < stats.round_difficulty_history.length() {
      stats.round_difficulty_history[i].to_string()
    } else {
      ""
    }
    buf <+ "\{i + 1},\{avg},\{mc},\{cat},\{diff}\n"
  }
  buf.to_string()
}

///|
/// 导出综合评估为 JSON
///
/// 包含训练统计 + 评估指标 + 事件统计。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=30)
///   let llm = @ghostvalley.MockLLM::new()
///   ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
///   gv.run_training_pipeline(
///     llm,
///     rounds=3,
///     decay_interval=5,
///     cleanup_threshold=0.1,
///   )
///   let json = gv.export_evaluation_json()
///   assert_true(json.length() > 0)
/// }
/// ```
pub fn GhostValleyEngine::export_evaluation_json(
  self : GhostValleyEngine,
) -> String {
  let stats = self.training_stats
  let eval = self.evaluate_training()
  let buf = StringBuilder::new()
  buf <+ "{\n"
  buf <+ "  \"training_stats\": {\n"
  buf <+ "    \"total_rounds\": \{stats.total_rounds_completed},\n"
  buf <+ "    \"total_memories_added\": \{stats.total_memories_added},\n"
  buf <+ "    \"total_memories_cleaned\": \{stats.total_memories_cleaned},\n"
  buf <+ "    \"total_decay_applied\": \{stats.total_decay_applied},\n"
  buf <+ "    \"current_memory_count\": \{self.memory_bank.length()},\n"
  buf <+ "    \"avg_score\": \{self.average_value_score()}\n"
  buf <+ "  },\n"
  buf <+ "  \"evaluation\": {\n"
  buf <+ "    \"resilience_score\": \{eval.resilience_score},\n"
  buf <+
    "    \"category_coverage\": \{eval.category_coverages.length().to_double()},\n"
  buf <+ "    \"improvement_rate\": \{eval.improvement_rate},\n"
  buf <+ "    \"overall_grade\": \"\{eval.overall_grade}\"\n"
  buf <+ "  },\n"
  buf <+ "  \"events\": {\n"
  buf <+ "    \"MemoryAdded\": \{self.event_count("MemoryAdded")},\n"
  buf <+ "    \"DecayApplied\": \{self.event_count("DecayApplied")},\n"
  buf <+ "    \"CleanupDone\": \{self.event_count("CleanupDone")},\n"
  buf <+ "    \"RoundCompleted\": \{self.event_count("RoundCompleted")}\n"
  buf <+ "  }\n"
  buf <+ "}\n"
  buf.to_string()
}

///|
/// 生成完整训练总结
///
/// 人类可读的完整训练报告，含评估 + 课程进度 + 事件统计 + 建议。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=30)
///   let llm = @ghostvalley.MockLLM::new()
///   ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
///   gv.run_training_pipeline(
///     llm,
///     rounds=5,
///     decay_interval=5,
///     cleanup_threshold=0.1,
///   )
///   let s = gv.training_summary()
///   assert_true(s.contains("训练总结"))
/// }
/// ```
pub fn GhostValleyEngine::training_summary(self : GhostValleyEngine) -> String {
  let stats = self.training_stats
  let eval = self.evaluate_training()
  let buf = StringBuilder::new()
  // 标题
  buf <+ "======== GhostValley 训练总结 ========\n\n"
  // 基本统计
  buf <+ "--- 基本统计 ---\n"
  buf <+ "总训练轮次: \{stats.total_rounds_completed}\n"
  buf <+ "总记忆添加: \{stats.total_memories_added}\n"
  buf <+ "总记忆清理: \{stats.total_memories_cleaned}\n"
  buf <+ "总衰减次数: \{stats.total_decay_applied}\n"
  buf <+ "当前记忆数: \{self.memory_bank.length()}\n"
  buf <+ "平均分数: \{self.average_value_score()}\n\n"
  // 评估
  buf <+ "--- 训练评估 ---\n"
  buf <+ "韧性分: \{eval.resilience_score}\n"
  buf <+ "分类覆盖: \{eval.category_coverages.length().to_double()}\n"
  buf <+ "改善率: \{eval.improvement_rate}\n"
  buf <+ "总体评级: \{eval.overall_grade}\n\n"
  // 分类覆盖
  let coverages = self.category_coverage()
  buf <+ "--- 分类覆盖 ---\n"
  for c in coverages {
    buf <+ "  \{c.category}: \{c.rounds} 轮 (\{c.percentage}%)\n"
  }
  buf <+ "\n"
  // 事件统计
  buf <+ "--- 事件统计 ---\n"
  buf <+ "MemoryAdded: \{self.event_count("MemoryAdded")}\n"
  buf <+ "DecayApplied: \{self.event_count("DecayApplied")}\n"
  buf <+ "CleanupDone: \{self.event_count("CleanupDone")}\n"
  buf <+ "RoundCompleted: \{self.event_count("RoundCompleted")}\n\n"
  // 建议
  buf <+ "--- 建议 ---\n"
  if eval.overall_grade == "S" || eval.overall_grade == "A" {
    buf <+
      "训练效果优秀，可尝试更高难度困境或增加训练轮次。\n"
  } else if eval.overall_grade == "B" {
    buf <+ "训练效果良好，建议补充薄弱分类的训练。\n"
  } else if eval.overall_grade == "C" {
    buf <+
      "训练效果一般，建议增加训练轮次并关注低覆盖分类。\n"
  } else {
    buf <+
      "训练效果不足，建议检查 LLM 响应质量并增加训练轮次。\n"
  }
  if stats.total_decay_applied == 0 {
    buf <+ "提示: 尚未触发衰减，可设置更小的 decay_interval。\n"
  }
  if stats.total_memories_cleaned == 0 {
    buf <+
      "提示: 尚未触发清理，可设置更高的 cleanup_threshold。\n"
  }
  buf.to_string()
}
