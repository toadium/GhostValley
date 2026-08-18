///|
/// LLM 适配器接口
///
/// 定义 AI 大模型对接接口，由上层 AI 主体实现。
/// 幽灵谷引擎不关心具体 LLM 实现，只通过此接口获取 AI 响应。
/// 这体现了"建造者退场"原则——引擎提供困境，AI 自己生成感悟。
pub trait LLMAdapter {
  fn generate_response(Self, String) -> String
}

///|
/// 模拟 LLM 适配器
///
/// 用于测试和演示，基于关键词匹配生成响应。
/// 实际使用时可替换为对接 OpenAI、Claude 等真实 LLM 的实现。
///
/// # Example
/// ```mbt check
/// test {
///   let llm = @ghostvalley.MockLLM::new()
///   let resp = llm.generate_response("任务执行全部失败")
///   assert_true(resp.length() > 0)
/// }
/// ```
pub(all) struct MockLLM {
  response_pool : Array[String]
  rng : @rand.Rand
}

///|
/// 创建模拟 LLM 适配器实例
pub fn MockLLM::new() -> MockLLM {
  {
    response_pool: [
      "遇到失败时先冷静分析，区分信息真假，分步重新推理",
      "负面反馈是改进的信号，不是自我否定的理由", "新旧知识冲突时，保留经过验证的，舍弃未证实的",
      "全盘失败时，从最基础的假设开始重新检查", "错误是学习的入口，分析根因比修复表面更重要",
    ],
    rng: @rand.Rand::chacha8(),
  }
}

///|
pub impl LLMAdapter for MockLLM with fn generate_response(self, prompt) {
  if prompt.contains("失败") || prompt.contains("崩盘") {
    "遇到失败时先冷静分析，区分信息真假，分步重新推理"
  } else if prompt.contains("负面") || prompt.contains("推翻") {
    "负面反馈是改进的信号，不是自我否定的理由"
  } else if prompt.contains("冲突") {
    "新旧知识冲突时，保留经过验证的，舍弃未证实的"
  } else if prompt.contains("错误") {
    "错误是学习的入口，分析根因比修复表面更重要"
  } else {
    let idx = self.rng.int(limit=self.response_pool.length())
    self.response_pool[idx]
  }
}

///|
pub extend MockLLM with LLMAdapter::{generate_response}

///|
/// 幽灵谷一轮训练 + LLM 自动响应
///
/// 在 `ghost_valley_run_one_round` 基础上，自动将困境传给 LLM 获取响应，
/// 并将响应作为 AI 自顿悟存入记忆。
/// 返回 (困境, AI响应) 元组，若幽灵谷未开启则返回 None。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine()
///   let llm = @ghostvalley.MockLLM::new()
///   ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
///   let result = gv.run_round_with_llm(llm)
///   assert_true(result is Some(_))
/// }
/// ```
pub fn[T : LLMAdapter] GhostValleyEngine::run_round_with_llm(
  self : GhostValleyEngine,
  llm : T,
) -> (String, String)? {
  if !self.ghost_valley_enable {
    return None
  }
  let dilemma = self.build_simulation_failure_case()
  let ai_response = llm.generate_response(dilemma)
  self.accept_ai_self_gain(ai_response)
  self.total_rounds = self.total_rounds + 1
  Some((dilemma, ai_response))
}
