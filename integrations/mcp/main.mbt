///|
/// GhostValley MCP server（native，stdio）。
///
/// 复用生态包 moonbitstack/moonmcp 的协议与 stdio 传输；
/// 工具逻辑调用 GhostValley 主库，主库保持零依赖、四后端可用。
async fn main {
  let mcp = @moonmcp.Server::new(
    "ghostvalley",
    version="0.4.0",
    title="GhostValley",
    instructions="AI 心理压力演练：run_round 跑训练，quality 看语料质量，live_chat 调本地 Qwen。",
  )

  mcp.tool(
    "version",
    _ => Json::string("0.4.0"),
    description="GhostValley version",
  )

  mcp.tool(
    "quality",
    _ => Json::string(@ghostvalley.qwen_curated_quality_summary()),
    description="Qwen curated corpus quality summary",
  )

  mcp.tool(
    "eval",
    _ => Json::string(@ghostvalley.qwen_eval_summary()),
    description="Qwen 144-run evaluation summary",
  )

  mcp.tool(
    "run_round",
    args => {
      let rounds = match args.get("rounds") {
        Some(Number(value, ..)) => value.to_int()
        _ => 8
      }
      let gv = @ghostvalley.new_engine(max_memory_num=40)
      let llm = @ghostvalley.QwenReplayLLM::new_curated()
      ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
      gv.run_training_pipeline(
        llm,
        rounds~,
        decay_interval=4,
        cleanup_threshold=0.1,
      )
      Json::string(gv.training_report().format())
    },
    description="Run N training rounds with curated Qwen replay and return the report",
  )

  mcp.run_stdio()
}
