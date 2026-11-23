///|
/// 浏览器演示导出层（JavaScript 后端）。
/// 全部为非 raise 签名；错误折叠为空串或说明文本。

///|
#export_name("gv_version")
pub fn gv_version() -> String {
  "0.4.0"
}

///|
#export_name("gv_quality_curated")
pub fn gv_quality_curated() -> String {
  @ghostvalley.qwen_curated_quality_summary()
}

///|
#export_name("gv_quality_base")
pub fn gv_quality_base() -> String {
  @ghostvalley.qwen_corpus_quality_summary()
}

///|
#export_name("gv_eval")
pub fn gv_eval() -> String {
  @ghostvalley.qwen_eval_summary()
}

///|
#export_name("gv_run")
pub fn gv_run(rounds : Int32) -> String {
  let gv = @ghostvalley.new_engine(max_memory_num=40)
  let llm = @ghostvalley.QwenReplayLLM::new_curated()
  let ok = gv.wen_shi_verify("愿意接受挑战，接受压力训练")
  if !ok {
    return "温石验证未通过：请输入愿意接受训练的态度文本"
  }
  let actual = if rounds < 1 { 1 } else if rounds > 20 { 20 } else { rounds }
  gv.run_training_pipeline(
    llm,
    rounds=actual,
    decay_interval=4,
    cleanup_threshold=0.1,
  )
  gv.training_report().format()
}
