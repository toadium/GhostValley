// ============================================================
// Phase 3: 训练检查点 + 回放
// ============================================================

///|
/// 训练检查点
///
/// 保存训练中间状态，支持断点续训。
/// 包含完整引擎状态 + 已完成轮次 + 时间戳。
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
///   let cp = gv.save_checkpoint()
///   assert_eq(cp.completed_rounds, 5)
/// }
/// ```
pub(all) struct TrainingCheckpoint {
  engine_state : String
  completed_rounds : Int
  timestamp : Int
} derive(Debug, ToJson, FromJson)

///|
pub extend TrainingCheckpoint with @debug.Debug::{to_repr}

///|
pub extend TrainingCheckpoint with ToJson::{to_json}

///|
pub extend TrainingCheckpoint with FromJson::{from_json}

///|
/// 保存训练检查点
///
/// 将当前引擎状态和训练进度保存为检查点。
pub fn GhostValleyEngine::save_checkpoint(
  self : GhostValleyEngine,
) -> TrainingCheckpoint {
  {
    engine_state: self.save_engine_state(),
    completed_rounds: self.total_rounds,
    timestamp: self.total_rounds,
  }
}

///|
/// 从检查点恢复
///
/// 将引擎状态恢复到检查点保存时的状态。
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
///   let cp = gv.save_checkpoint()
///   let gv2 = @ghostvalley.new_engine(max_memory_num=30)
///   gv2.load_checkpoint(cp)
///   assert_eq(gv2.total_rounds, 3)
/// }
/// ```
pub fn GhostValleyEngine::load_checkpoint(
  self : GhostValleyEngine,
  checkpoint : TrainingCheckpoint,
) -> Unit {
  self.load_engine_state(checkpoint.engine_state)
}

///|
/// 断点续训
///
/// 从检查点恢复引擎状态，然后继续训练 additional_rounds 轮。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=50)
///   let llm = @ghostvalley.MockLLM::new()
///   ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
///   gv.run_training_pipeline(
///     llm,
///     rounds=3,
///     decay_interval=5,
///     cleanup_threshold=0.1,
///   )
///   let cp = gv.save_checkpoint()
///   let gv2 = @ghostvalley.new_engine(max_memory_num=50)
///   gv2.resume_training(
///     cp,
///     llm,
///     additional_rounds=2,
///     decay_interval=5,
///     cleanup_threshold=0.1,
///   )
///   assert_eq(gv2.total_rounds, 5)
/// }
/// ```
pub fn[T : LLMAdapter] GhostValleyEngine::resume_training(
  self : GhostValleyEngine,
  checkpoint : TrainingCheckpoint,
  llm : T,
  additional_rounds~ : Int,
  decay_interval? : Int = 5,
  cleanup_threshold? : Double = 0.1,
) -> Unit {
  self.load_checkpoint(checkpoint)
  self.run_training_pipeline(
    llm,
    rounds=additional_rounds,
    decay_interval~,
    cleanup_threshold~,
  )
}

///|
/// 回放结果
///
/// 记录原训练 vs 回放训练的对比。
pub(all) struct ReplayResult {
  original_rounds : Int
  replayed_rounds : Int
  original_avg_score : Double
  replayed_avg_score : Double
  score_difference : Double
} derive(Debug, ToJson, FromJson)

///|
pub extend ReplayResult with @debug.Debug::{to_repr}

///|
pub extend ReplayResult with ToJson::{to_json}

///|
pub extend ReplayResult with FromJson::{from_json}

///|
/// 回放训练
///
/// 从 TrainingLog 重建困境序列，用新配置重跑训练。
/// 可选参数允许更换评分配置和衰减模型。
/// 返回原训练 vs 回放训练的对比结果。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=50)
///   let llm = @ghostvalley.MockLLM::new()
///   ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
///   gv.run_training_pipeline(
///     llm,
///     rounds=5,
///     decay_interval=5,
///     cleanup_threshold=0.1,
///   )
///   let log = gv.training_log
///   let original_score = gv.average_value_score()
///   let gv2 = @ghostvalley.new_engine(max_memory_num=50)
///   ignore(gv2.wen_shi_verify("愿意接受挑战，接受压力训练"))
///   let result = gv2.replay_training(log, llm)
///   assert_eq(result.replayed_rounds, 5)
/// }
/// ```
pub fn[T : LLMAdapter] GhostValleyEngine::replay_training(
  self : GhostValleyEngine,
  log : TrainingLog,
  llm : T,
  new_scoring_config? : ScoringConfig = ScoringConfig::default(),
  new_decay_model? : DecayModel = Hyperbolic,
) -> ReplayResult {
  // 应用新配置
  self.scoring_config = new_scoring_config
  self.decay_model = new_decay_model
  let original_rounds = log.length()
  let mut original_avg = 0.0
  // 从日志提取原始分数（用 memory_count_after 估算）
  if original_rounds > 0 {
    let mut sum = 0.0
    for entry in log.entries {
      sum = sum + entry.memory_count_after.to_double()
    }
    original_avg = sum / original_rounds.to_double()
  }
  // 回放：用相同困境重跑
  for entry in log.entries {
    if !self.ghost_valley_enable {
      break
    }
    let ai_response = llm.generate_response(entry.dilemma)
    self.accept_ai_self_gain(ai_response)
    self.total_rounds = self.total_rounds + 1
    self.training_log.add_entry(
      self.total_rounds,
      entry.dilemma,
      ai_response,
      self.memory_bank.length(),
    )
    self.training_stats.total_rounds_completed = self.training_stats.total_rounds_completed +
      1
    self.training_stats.total_memories_added = self.training_stats.total_memories_added +
      1
    self.event_system.emit("ReplayRound", entry.round_num, entry.dilemma)
  }
  let replayed_avg = self.average_value_score()
  ReplayResult::{
    original_rounds,
    replayed_rounds: original_rounds,
    original_avg_score: original_avg,
    replayed_avg_score: replayed_avg,
    score_difference: replayed_avg - original_avg,
  }
}

///|
/// 格式化回放结果
pub fn ReplayResult::format(self : ReplayResult) -> String {
  let buf = StringBuilder::new()
  buf <+ "======== 回放结果 ========\n"
  buf <+ "原训练轮次: \{self.original_rounds}\n"
  buf <+ "回放轮次: \{self.replayed_rounds}\n"
  buf <+ "原平均分: \{self.original_avg_score}\n"
  buf <+ "回放平均分: \{self.replayed_avg_score}\n"
  buf <+ "分数差异: \{self.score_difference}\n"
  buf.to_string()
}
