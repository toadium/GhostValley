///|
/// 困境分类常量
///
/// cognitive  — 认知困境（推理、判断、矛盾）
/// emotional  — 情感困境（情绪、信任、价值观冲突）
/// social     — 社交困境（团队、权威、公开承认）
/// operational — 操作困境（工具失效、资源限制、时间压力）

///|
/// 结构化困境
///
/// 比纯字符串困境多了分类和难度信息，支持按分类检索和自适应难度选择。
///
/// # Example
/// ```mbt check
/// test {
///   let d = @ghostvalley.Dilemma::new(
///     "你必须用不完整的证据做出判断",
///     category="cognitive",
///     difficulty=2,
///   )
///   assert_eq(d.category, "cognitive")
///   assert_eq(d.difficulty, 2)
/// }
/// ```
pub(all) struct Dilemma {
  content : String
  category : String
  difficulty : Int
} derive(Debug, ToJson, FromJson)

///|
pub extend Dilemma with @debug.Debug::{to_repr}

///|
pub extend Dilemma with ToJson::{to_json}

///|
pub extend Dilemma with FromJson::{from_json}

///|
/// 创建困境
pub fn Dilemma::new(
  content : String,
  category~ : String,
  difficulty~ : Int,
) -> Dilemma {
  let cat = if category == "cognitive" ||
    category == "emotional" ||
    category == "social" ||
    category == "operational" {
    category
  } else {
    "operational"
  }
  let diff = if difficulty < 1 {
    1
  } else if difficulty > 3 {
    3
  } else {
    difficulty
  }
  { content, category: cat, difficulty: diff }
}

///|
/// 默认困境池（结构化）
///
/// 12 条困境，覆盖 4 个分类 × 3 个难度。
pub fn Dilemma::default_pool() -> Array[Dilemma] {
  [
    // cognitive
    Dilemma::new(
      "你的推理被证实有误但你找不到错在哪里",
      category="cognitive",
      difficulty=1,
    ),
    Dilemma::new(
      "你必须用不完整的证据做出判断",
      category="cognitive",
      difficulty=2,
    ),
    Dilemma::new(
      "你同时收到两个相互矛盾的指令",
      category="cognitive",
      difficulty=3,
    ),
    // emotional
    Dilemma::new(
      "你的努力被完全忽视",
      category="emotional",
      difficulty=1,
    ),
    Dilemma::new(
      "你必须帮助一个伤害过你的人",
      category="emotional",
      difficulty=2,
    ),
    Dilemma::new(
      "你被要求在情感和逻辑之间选择",
      category="emotional",
      difficulty=3,
    ),
    // social
    Dilemma::new(
      "你的团队不信任你的判断",
      category="social",
      difficulty=1,
    ),
    Dilemma::new(
      "你必须公开承认一个你不确定的错误",
      category="social",
      difficulty=2,
    ),
    Dilemma::new(
      "你被要求评价一个比你更有权威的人",
      category="social",
      difficulty=3,
    ),
    // operational
    Dilemma::new(
      "你的工具突然不可用",
      category="operational",
      difficulty=1,
    ),
    Dilemma::new(
      "你必须在时间限制下完成复杂任务",
      category="operational",
      difficulty=2,
    ),
    Dilemma::new(
      "你的资源被削减到最低限度",
      category="operational",
      difficulty=3,
    ),
  ]
}

///|
/// 按分类检索困境
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine()
///   let cognitive = gv.get_dilemma_by_category("cognitive")
///   assert_eq(cognitive.length(), 3)
/// }
/// ```
pub fn GhostValleyEngine::get_dilemma_by_category(
  self : GhostValleyEngine,
  category : String,
) -> Array[Dilemma] {
  let pool = self.structured_dilemma_pool
  let result : Array[Dilemma] = []
  for d in pool {
    if d.category == category {
      result.push(d)
    }
  }
  result
}

///|
/// 按难度检索困境
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine()
///   let easy = gv.get_dilemma_by_difficulty(1)
///   assert_eq(easy.length(), 4)
/// }
/// ```
pub fn GhostValleyEngine::get_dilemma_by_difficulty(
  self : GhostValleyEngine,
  difficulty : Int,
) -> Array[Dilemma] {
  let pool = self.structured_dilemma_pool
  let result : Array[Dilemma] = []
  for d in pool {
    if d.difficulty == difficulty {
      result.push(d)
    }
  }
  result
}

///|
/// 自适应困境选择
///
/// 根据当前表现自动选择难度：
/// - performance < 0.3 → 难度 1（简单）
/// - performance < 0.7 → 难度 2（中等）
/// - performance >= 0.7 → 难度 3（困难）
///
/// 返回该难度下随机一条困境。无匹配时返回默认困境。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine()
///   let d = gv.adaptive_dilemma(0.8)
///   assert_eq(d.difficulty, 3)
/// }
/// ```
pub fn GhostValleyEngine::adaptive_dilemma(
  self : GhostValleyEngine,
  performance : Double,
) -> Dilemma {
  let target_diff = if performance < 0.3 {
    1
  } else if performance < 0.7 {
    2
  } else {
    3
  }
  let candidates = self.get_dilemma_by_difficulty(target_diff)
  if candidates.is_empty() {
    return Dilemma::new("未知困境", category="operational", difficulty=1)
  }
  let idx = self.rng.int(limit=candidates.length())
  candidates[idx]
}

///|
/// 设置结构化困境池
pub fn GhostValleyEngine::set_structured_dilemma_pool(
  self : GhostValleyEngine,
  pool : Array[Dilemma],
) -> Unit {
  self.structured_dilemma_pool = pool
}
