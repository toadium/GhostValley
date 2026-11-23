///|
/// GhostValley 基准：引擎/记忆/检索/衰减/序列化/Qwen 回放/训练管道。
/// 运行：moon run bench --target native --release
fn bench(name : String, iters : Int32, f : (Int32) -> Unit) -> Unit {
  let warm = iters / 10 + 1
  for i in 0..<warm {
    f(i)
  }
  let started = @async.now()
  for i in 0..<iters {
    f(i)
  }
  let elapsed = @async.now() - started
  let per_us = elapsed.to_double() * 1000.0 / iters.to_double()
  println(
    name +
    " | " +
    iters.to_string() +
    " | " +
    elapsed.to_string() +
    " ms | " +
    per_us.to_string() +
    " us/iter",
  )
}

///|
fn main {
  println("GhostValley benchmark | time-source=@async.now() | unit=us/iter")
  println("operation | iterations | total_ms | us_per_iter")

  bench("engine.new[200]", 2000, _ => {
    ignore(@ghostvalley.new_engine(max_memory_num=200))
  })

  let gv = @ghostvalley.new_engine(max_memory_num=200)
  for i in 0..<200 {
    gv.add_memory("顿悟反思改进 " + i.to_string(), is_simulation=false)
  }

  bench("add_memory[200]", 2000, i => {
    gv.add_memory("记忆 " + i.to_string(), is_simulation=false)
  })
  bench("weighted_search[200]", 2000, _ => {
    ignore(gv.weighted_search("顿悟反思", 5))
  })
  bench("apply_decay[200]", 500, _ => gv.apply_decay(1))
  bench("cleanup_low_value[200]", 500, _ => ignore(gv.cleanup_low_value(0.01)))
  bench("save_engine_state[200]", 200, _ => ignore(gv.save_engine_state()))

  let llm = @ghostvalley.QwenReplayLLM::new_curated()
  bench("qwen.generate[24]", 5000, _ => {
    ignore(llm.generate_response("你的工具突然不可用"))
  })

  bench("training_pipeline[8]", 100, _ => {
    let engine = @ghostvalley.new_engine(max_memory_num=40)
    ignore(engine.wen_shi_verify("愿意接受挑战，接受压力训练"))
    engine.run_training_pipeline(
      llm,
      rounds=8,
      decay_interval=4,
      cleanup_threshold=0.1,
    )
  })
}
