///|
/// GhostValley CLI：真实 argv 入口（native）。
///
/// 命令：
///   help / version / quality / eval / run / run20
fn main {
  let args = @env.args()
  let real : Array[String] = []
  for i in 1..<args.length() {
    real.push(args[i])
  }
  let command = if real.length() == 0 { "help" } else { real[0] }
  match command {
    "version" => println("GhostValley 0.4.0")
    "quality" => {
      println(@ghostvalley.qwen_curated_quality_summary())
      println(@ghostvalley.qwen_corpus_quality_summary())
    }
    "eval" => println(@ghostvalley.qwen_eval_summary())
    "run" => run_training(8)
    "run20" => run_training(20)
    "help" | "--help" | "-h" => print_help()
    _ => {
      println("未知命令：" + command)
      print_help()
      @env.exit(1)
    }
  }
  @env.exit(0)
}

///|
fn print_help() -> Unit {
  println("GhostValley CLI 0.4.0")
  println("")
  println("用法：moon run cli --target native -- <command>")
  println("")
  println("  help      显示帮助")
  println("  version   版本")
  println("  quality   基础/精选语料质量摘要")
  println("  eval      144 次评测摘要")
  println("  run       8 轮训练（Qwen 精选回放）")
  println("  run20     20 轮训练（压力测试）")
}

///|
fn run_training(rounds : Int32) -> Unit {
  let gv = @ghostvalley.new_engine(max_memory_num=40)
  let llm = @ghostvalley.QwenReplayLLM::new_curated()
  let ok = gv.wen_shi_verify("愿意接受挑战，接受压力训练")
  if !ok {
    println("温石验证未通过")
    @env.exit(2)
  }
  println(@ghostvalley.qwen_curated_quality_summary())
  gv.run_training_pipeline(
    llm,
    rounds~,
    decay_interval=4,
    cleanup_threshold=0.1,
  )
  println("")
  println(gv.training_report().format())
}
