///|
test "decay model boundary branches" {
  let hyperbolic = @ghostvalley.DecayModel::Hyperbolic
  let linear = @ghostvalley.DecayModel::Linear
  let params = @ghostvalley.DecayParams::default()
  assert_eq(@ghostvalley.apply_decay_model(hyperbolic, params, 0.5, 0), 0.5)
  assert_eq(@ghostvalley.apply_decay_model(hyperbolic, params, 0.0, 5), 0.0)
  let steep = @ghostvalley.DecayParams::{
    linear_rate: 0.5,
    exp_decay_base: 0.9,
  }
  assert_eq(@ghostvalley.apply_decay_model(linear, steep, 0.5, 10), 0.0)
}

///|
test "curriculum custom requirements and locked progress" {
  let gv = @ghostvalley.new_engine(max_memory_num=10)
  let custom : @ghostvalley.Curriculum = {
    requirements: [
      { category: "X", difficulty: 1, min_rounds: 0, },
      { category: "Y", difficulty: 2, min_rounds: 2, },
    ],
    prerequisites: [("Y", "X")],
  }
  let progress = gv.curriculum_progress(custom)
  assert_eq(progress.items[0].completion, 1.0)
  assert_false(progress.items[1].unlocked)
  assert_true(progress.next_step.contains("X"))
  assert_true(progress.format().contains("🔒"))
  let empty : @ghostvalley.Curriculum = { requirements: [], prerequisites: [], }
  let empty_progress = gv.curriculum_progress(empty)
  assert_eq(empty_progress.overall_completion, 1.0)
  gv.training_stats.round_difficulty_history.push(1)
  let _ = gv.curriculum_progress(custom)
}

///|
fn engine_with_history(
  difficulties : Array[Int32],
  scores : Array[Double],
) -> @ghostvalley.GhostValleyEngine {
  let gv = @ghostvalley.new_engine(max_memory_num=10)
  for diff in difficulties {
    gv.training_stats.round_difficulty_history.push(diff)
  }
  for score in scores {
    gv.training_stats.avg_score_history.push(score)
  }
  gv
}

///|
test "evaluator historical branches and grades" {
  let shorter_diff = engine_with_history([1], [0.5, 0.6])
  assert_true(shorter_diff.resilience_score() >= 0.0)
  let high_only = engine_with_history([3], [0.9])
  assert_eq(high_only.resilience_score(), 0.0)
  let single = engine_with_history([], [0.5])
  assert_eq(single.improvement_rate(), 0.0)
  let grade_a = engine_with_history([1, 3], [0.4, 0.5])
  assert_eq(grade_a.evaluate_training().overall_grade, "A")
  let grade_b = engine_with_history([1, 3], [0.5, 0.4])
  assert_eq(grade_b.evaluate_training().overall_grade, "B")
  let grade_c = engine_with_history([1, 3], [0.5, 0.3])
  assert_eq(grade_c.evaluate_training().overall_grade, "C")
}

///|
test "load_engine_state clamps and defaults" {
  let gv = @ghostvalley.new_engine(max_memory_num=10)
  let state = "{\"memory_bank\":[{\"content\":\"低\",\"value_score\":0.01,\"is_simulation\":false,\"is_core_memory\":false,\"linked_ids\":[[0,\"x\"],[1,0.5],[2],3]},{\"content\":\"高\",\"value_score\":0.99,\"is_simulation\":false,\"is_core_memory\":false}],\"training_stats\":{\"total_rounds_completed\":1,\"total_memories_added\":2,\"total_memories_cleaned\":0,\"total_decay_applied\":0,\"avg_score_history\":[],\"memory_count_history\":[],\"round_difficulty_history\":[],\"round_category_history\":[]},\"max_memory_num\":10,\"ghost_valley_enable\":true,\"total_rounds\":1}"
  gv.load_engine_state(state)
  assert_eq(gv.memory_count(), 2)
  assert_eq(gv.memory_bank[0].value_score, 0.05)
  assert_eq(gv.memory_bank[1].value_score, 0.95)
  assert_eq(gv.memory_bank[0].access_count, 0)
  assert_eq(gv.memory_bank[0].linked_ids.length(), 1)
  assert_true(gv.ghost_valley_enable)
}

///|
test "qwen matching branches and zero hit rate" {
  let llm = @ghostvalley.QwenReplayLLM::new()
  assert_eq(llm.hit_rate(), 0.0)
  assert_eq(@ghostvalley.qwen_match_score("", ""), 1.0)
  assert_eq(@ghostvalley.qwen_match_score("", "x"), 0.0)
  assert_true(
    @ghostvalley.qwen_match_score("顿悟", "顿悟反思改进") > 0.0,
  )
  match @ghostvalley.qwen_response_for("zzzz") {
    Some(_) => fail("expected no match")
    None => ()
  }
}
