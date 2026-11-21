///|
/// Qwen 精选回放演示：24 条精选语料 + 质量门槛 + 8 轮训练。
///
/// 运行：moon run examples/qwen_curated --target native
fn main {
  let gv = @ghostvalley.new_engine(max_memory_num=40)
  let llm = @ghostvalley.QwenReplayLLM::new_curated()

  println("=== GhostValley · Qwen 精选回放 ===")
  println(@ghostvalley.qwen_curated_quality_summary())
  println("基础语料：" + @ghostvalley.qwen_corpus_quality_summary())

  let ok = gv.wen_shi_verify("愿意接受挑战，接受压力训练")
  println("温石验证：" + ok.to_string())
  if !ok {
    return
  }

  gv.run_training_pipeline(
    llm,
    rounds=8,
    decay_interval=4,
    cleanup_threshold=0.1,
  )
  println("")
  println(gv.training_report().format())
}
