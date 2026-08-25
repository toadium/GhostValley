// ============================================================
// Phase 1: 多智能体对比训练
// ============================================================

///|
/// 对比训练结果
///
/// 记录同一困境下两个 LLM 的响应对比。
pub(all) struct ComparativeResult {
  dilemma : String
  response_a : String
  response_b : String
  score_a : Double
  score_b : Double
  similarity_score : Double
  winner : String
} derive(Debug, ToJson, FromJson)

///|
pub extend ComparativeResult with @debug.Debug::{to_repr}

///|
pub extend ComparativeResult with ToJson::{to_json}

///|
pub extend ComparativeResult with FromJson::{from_json}

///|
/// 比较两个响应的相似度
///
/// 基于关键词重叠率（Jaccard 系数变体），返回 [0, 1]。
/// 1 表示完全相似，0 表示无重叠。
///
/// # Example
/// ```mbt check
/// test {
///   let s = @ghostvalley.compare_responses(
///     "顿悟反思改进", "顿悟反思修复",
///   )
///   assert_true(s > 0.0 && s <= 1.0)
/// }
/// ```
pub fn compare_responses(a : String, b : String) -> Double {
  text_similarity(a, b)
}

///|
/// 对比训练单轮
///
/// 用同一困境测试两个 LLM，比较响应质量。
/// 两个响应分别存入引擎记忆库，返回对比结果。
/// winner 为 "A"/"B"/"tie"。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=30)
///   let llm_a = @ghostvalley.MockLLM::new()
///   let llm_b = @ghostvalley.MockLLM::new()
///   ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
///   let result = gv.run_comparative_round(llm_a, llm_b)
///   assert_true(result.dilemma.length() > 0)
/// }
/// ```
pub fn[T : LLMAdapter, U : LLMAdapter] GhostValleyEngine::run_comparative_round(
  self : GhostValleyEngine,
  llm_a : T,
  llm_b : U,
) -> ComparativeResult {
  let performance = self.average_value_score()
  let dilemma = self.adaptive_dilemma(performance)
  let response_a = llm_a.generate_response(dilemma.content)
  let response_b = llm_b.generate_response(dilemma.content)
  let score_a = configurable_text_value_score(response_a, self.scoring_config)
  let score_b = configurable_text_value_score(response_b, self.scoring_config)
  let sim = compare_responses(response_a, response_b)
  // 存储两个响应
  self.accept_ai_self_gain(response_a)
  self.accept_ai_self_gain(response_b)
  self.total_rounds = self.total_rounds + 2
  // 判定胜者
  let winner = if score_a > score_b + 0.01 {
    "A"
  } else if score_b > score_a + 0.01 {
    "B"
  } else {
    "tie"
  }
  ComparativeResult::{
    dilemma: dilemma.content,
    response_a,
    response_b,
    score_a,
    score_b,
    similarity_score: sim,
    winner,
  }
}

///|
/// 批量对比训练
///
/// 对同一引擎用两个 LLM 交替训练 rounds 轮，返回所有对比结果。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=50)
///   let llm_a = @ghostvalley.MockLLM::new()
///   let llm_b = @ghostvalley.MockLLM::new()
///   ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
///   let results = gv.run_comparative_pipeline(llm_a, llm_b, rounds=5)
///   assert_eq(results.length(), 5)
/// }
/// ```
pub fn[T : LLMAdapter, U : LLMAdapter] GhostValleyEngine::run_comparative_pipeline(
  self : GhostValleyEngine,
  llm_a : T,
  llm_b : U,
  rounds~ : Int,
) -> Array[ComparativeResult] {
  if !self.ghost_valley_enable || rounds <= 0 {
    return []
  }
  let results : Array[ComparativeResult] = []
  for _ in 0..<rounds {
    let result = self.run_comparative_round(llm_a, llm_b)
    self.event_system.emit(
      "RoundCompleted",
      results.length() + 1,
      "comparative",
    )
    results.push(result)
  }
  results
}

///|
/// 交叉学习
///
/// 将 source 引擎的 top_n 高价值记忆导入 target 引擎。
/// 导入的记忆标记为非模拟（真实学习），分数保留。
///
/// # Example
/// ```mbt check
/// test {
///   let source = @ghostvalley.new_engine(max_memory_num=20)
///   source.add_memory("顿悟反思改进", is_simulation=false)
///   source.add_memory("普通记忆", is_simulation=false)
///   let target = @ghostvalley.new_engine(max_memory_num=20)
///   let count = @ghostvalley.cross_pollinate(target, source, top_n=1)
///   assert_eq(count, 1)
///   assert_eq(target.memory_count(), 1)
/// }
/// ```
pub fn cross_pollinate(
  target : GhostValleyEngine,
  source : GhostValleyEngine,
  top_n~ : Int,
) -> Int {
  let top = source.top_memories(top_n)
  let mut count = 0
  for m in top {
    target.add_memory(m.content, is_simulation=false)
    count = count + 1
  }
  count
}

///|
/// 多智能体会话
///
/// 管理多个命名引擎实例，支持统一训练和交叉学习。
///
/// # Example
/// ```mbt check
/// test {
///   let session = @ghostvalley.MultiAgentSession::new()
///   session.add_agent("alpha", @ghostvalley.new_engine(max_memory_num=20))
///   session.add_agent("beta", @ghostvalley.new_engine(max_memory_num=20))
///   assert_eq(session.agent_count(), 2)
/// }
/// ```
pub(all) struct MultiAgentSession {
  agents : Array[(String, GhostValleyEngine)]
}

///|
/// 创建空的多智能体会话
pub fn MultiAgentSession::new() -> MultiAgentSession {
  { agents: [] }
}

///|
/// 添加智能体
pub fn MultiAgentSession::add_agent(
  self : MultiAgentSession,
  name : String,
  engine : GhostValleyEngine,
) -> Unit {
  self.agents.push((name, engine))
}

///|
/// 智能体数量
pub fn MultiAgentSession::agent_count(self : MultiAgentSession) -> Int {
  self.agents.length()
}

///|
/// 获取智能体引擎
pub fn MultiAgentSession::get_agent(
  self : MultiAgentSession,
  name : String,
) -> GhostValleyEngine? {
  for agent in self.agents {
    let (n, engine) = agent
    if n == name {
      return Some(engine)
    }
  }
  None
}

///|
/// 列出所有智能体名称
pub fn MultiAgentSession::agent_names(
  self : MultiAgentSession,
) -> Array[String] {
  let names : Array[String] = []
  for agent in self.agents {
    let (n, _) = agent
    names.push(n)
  }
  names
}

///|
/// 全部智能体交叉学习
///
/// 每个智能体从其他所有智能体导入 top_n 高价值记忆。
/// 返回每个智能体导入的记忆总数。
pub fn MultiAgentSession::cross_learn_all(
  self : MultiAgentSession,
  top_n~ : Int,
) -> Array[(String, Int)] {
  let results : Array[(String, Int)] = []
  for i in 0..<self.agents.length() {
    let (name, engine) = self.agents[i]
    let mut total_imported = 0
    for j in 0..<self.agents.length() {
      if i != j {
        let (_, source) = self.agents[j]
        total_imported = total_imported +
          cross_pollinate(engine, source, top_n~)
      }
    }
    results.push((name, total_imported))
  }
  results
}

///|
/// 格式化对比结果
pub fn ComparativeResult::format(self : ComparativeResult) -> String {
  let buf = StringBuilder::new()
  buf <+ "困境: \{self.dilemma}\n"
  buf <+ "  A 响应: \{self.response_a} (分数: \{self.score_a})\n"
  buf <+ "  B 响应: \{self.response_b} (分数: \{self.score_b})\n"
  buf <+ "  相似度: \{self.similarity_score}\n"
  buf <+ "  胜者: \{self.winner}\n"
  buf.to_string()
}
