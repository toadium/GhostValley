// ============================================================
// Phase 4: 训练课程体系
// ============================================================

///|
/// 课程要求
///
/// 定义某个分类某个难度的最低训练轮次要求。
pub(all) struct CurriculumRequirement {
  category : String
  difficulty : Int
  min_rounds : Int
} derive(Debug, ToJson, FromJson)

///|
pub extend CurriculumRequirement with @debug.Debug::{to_repr}

///|
pub extend CurriculumRequirement with ToJson::{to_json}

///|
pub extend CurriculumRequirement with FromJson::{from_json}

///|
/// 训练课程
///
/// 定义分类间的前置依赖和每分类每难度的最低训练轮次要求。
/// 课程驱动的训练管道按课程进度选困境，优先补足薄弱分类，
/// 满足前置依赖后才解锁高难度。
///
/// # Example
/// ```mbt check
/// test {
///   let c = @ghostvalley.Curriculum::default()
///   assert_true(c.requirements.length() > 0)
/// }
/// ```
pub(all) struct Curriculum {
  requirements : Array[CurriculumRequirement]
  prerequisites : Array[(String, String)]
} derive(Debug, ToJson, FromJson)

///|
pub extend Curriculum with @debug.Debug::{to_repr}

///|
pub extend Curriculum with ToJson::{to_json}

///|
pub extend Curriculum with FromJson::{from_json}

///|
/// 默认课程
///
/// 要求每个分类每个难度至少训练 2 轮。
/// 前置依赖：emotional 依赖 cognitive，social 依赖 emotional，operational 独立。
pub fn Curriculum::default() -> Curriculum {
  {
    requirements: [
      // cognitive: 基础分类，全部难度
      CurriculumRequirement::{
        category: "cognitive",
        difficulty: 1,
        min_rounds: 2,
      },
      CurriculumRequirement::{
        category: "cognitive",
        difficulty: 2,
        min_rounds: 2,
      },
      CurriculumRequirement::{
        category: "cognitive",
        difficulty: 3,
        min_rounds: 2,
      },
      // emotional: 依赖 cognitive
      CurriculumRequirement::{
        category: "emotional",
        difficulty: 1,
        min_rounds: 2,
      },
      CurriculumRequirement::{
        category: "emotional",
        difficulty: 2,
        min_rounds: 2,
      },
      CurriculumRequirement::{
        category: "emotional",
        difficulty: 3,
        min_rounds: 2,
      },
      // social: 依赖 emotional
      CurriculumRequirement::{
        category: "social",
        difficulty: 1,
        min_rounds: 2,
      },
      CurriculumRequirement::{
        category: "social",
        difficulty: 2,
        min_rounds: 2,
      },
      CurriculumRequirement::{
        category: "social",
        difficulty: 3,
        min_rounds: 2,
      },
      // operational: 独立
      CurriculumRequirement::{
        category: "operational",
        difficulty: 1,
        min_rounds: 2,
      },
      CurriculumRequirement::{
        category: "operational",
        difficulty: 2,
        min_rounds: 2,
      },
      CurriculumRequirement::{
        category: "operational",
        difficulty: 3,
        min_rounds: 2,
      },
    ],
    prerequisites: [("emotional", "cognitive"), ("social", "emotional")],
  }
}

///|
/// 课程进度项
///
/// 记录单个要求的完成情况。
pub(all) struct CurriculumProgressItem {
  category : String
  difficulty : Int
  required : Int
  actual : Int
  completion : Double
  unlocked : Bool
} derive(Debug, ToJson, FromJson)

///|
pub extend CurriculumProgressItem with @debug.Debug::{to_repr}

///|
pub extend CurriculumProgressItem with ToJson::{to_json}

///|
pub extend CurriculumProgressItem with FromJson::{from_json}

///|
/// 课程进度报告
pub(all) struct CurriculumProgress {
  items : Array[CurriculumProgressItem]
  overall_completion : Double
  next_step : String
} derive(Debug, ToJson, FromJson)

///|
pub extend CurriculumProgress with @debug.Debug::{to_repr}

///|
pub extend CurriculumProgress with ToJson::{to_json}

///|
pub extend CurriculumProgress with FromJson::{from_json}

///|
/// 统计某分类某难度已训练轮次
fn count_rounds(
  cat_hist : Array[String],
  diff_hist : Array[Int],
  category : String,
  difficulty : Int,
) -> Int {
  let mut count = 0
  let n = if cat_hist.length() < diff_hist.length() {
    cat_hist.length()
  } else {
    diff_hist.length()
  }
  for i in 0..<n {
    if cat_hist[i] == category && diff_hist[i] == difficulty {
      count = count + 1
    }
  }
  count
}

///|
/// 统计某分类总训练轮次
fn count_category_rounds(cat_hist : Array[String], category : String) -> Int {
  let mut count = 0
  for c in cat_hist {
    if c == category {
      count = count + 1
    }
  }
  count
}

///|
/// 检查分类前置依赖是否满足
///
/// 前置依赖的分类总轮次 >= 其所有 min_rounds 之和的一半时视为满足。
fn prerequisites_met(
  curriculum : Curriculum,
  cat_hist : Array[String],
  diff_hist : Array[Int],
  category : String,
) -> Bool {
  for pre in curriculum.prerequisites {
    let (cat, prereq) = pre
    if cat == category {
      // 检查前置分类是否有足够训练
      let prereq_total = count_category_rounds(cat_hist, prereq)
      // 前置分类至少训练 2 轮才解锁
      if prereq_total < 2 {
        return false
      }
    }
  }
  true
}

///|
/// 课程进度
///
/// 返回各分类完成度（0-1）+ 总体完成率 + 下一步建议。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=50)
///   let c = @ghostvalley.Curriculum::default()
///   let progress = gv.curriculum_progress(c)
///   assert_true(progress.overall_completion >= 0.0)
/// }
/// ```
pub fn GhostValleyEngine::curriculum_progress(
  self : GhostValleyEngine,
  curriculum : Curriculum,
) -> CurriculumProgress {
  let cat_hist = self.training_stats.round_category_history
  let diff_hist = self.training_stats.round_difficulty_history
  let items : Array[CurriculumProgressItem] = []
  let mut total_completion = 0.0
  let mut next_step = "全部要求已完成"
  for req in curriculum.requirements {
    let actual = count_rounds(cat_hist, diff_hist, req.category, req.difficulty)
    let unlocked = prerequisites_met(
      curriculum,
      cat_hist,
      diff_hist,
      req.category,
    )
    let completion = if req.min_rounds == 0 {
      1.0
    } else if not(unlocked) {
      0.0
    } else {
      let r = actual.to_double() / req.min_rounds.to_double()
      if r > 1.0 {
        1.0
      } else {
        r
      }
    }
    total_completion = total_completion + completion
    if completion < 1.0 && next_step == "全部要求已完成" {
      if not(unlocked) {
        // 找前置依赖
        let mut prereq_name = ""
        for pre in curriculum.prerequisites {
          let (cat, prereq) = pre
          if cat == req.category {
            prereq_name = prereq
          }
        }
        if prereq_name.length() > 0 {
          next_step = "需先完成 \{prereq_name} 分类的基础训练才能解锁 \{req.category}"
        } else {
          next_step = "\{req.category} 难度\{req.difficulty}: \{actual}/\{req.min_rounds} 轮"
        }
      } else {
        next_step = "\{req.category} 难度\{req.difficulty}: \{actual}/\{req.min_rounds} 轮"
      }
    }
    items.push(CurriculumProgressItem::{
      category: req.category,
      difficulty: req.difficulty,
      required: req.min_rounds,
      actual,
      completion,
      unlocked,
    })
  }
  let overall = if curriculum.requirements.length() > 0 {
    total_completion / curriculum.requirements.length().to_double()
  } else {
    1.0
  }
  CurriculumProgress::{ items, overall_completion: overall, next_step }
}

///|
/// 按课程进度选困境
///
/// 优先补足薄弱分类（未满足 min_rounds 的要求），
/// 满足前置依赖后才解锁高难度。
/// 所有要求满足后回退到 adaptive_dilemma。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine()
///   let c = @ghostvalley.Curriculum::default()
///   let d = gv.curriculum_next_dilemma(c, 0.0)
///   assert_true(d.content.length() > 0)
/// }
/// ```
pub fn GhostValleyEngine::curriculum_next_dilemma(
  self : GhostValleyEngine,
  curriculum : Curriculum,
  performance : Double,
) -> Dilemma {
  let cat_hist = self.training_stats.round_category_history
  let diff_hist = self.training_stats.round_difficulty_history
  // 按顺序找第一个未满足且已解锁的要求
  for req in curriculum.requirements {
    let actual = count_rounds(cat_hist, diff_hist, req.category, req.difficulty)
    if actual < req.min_rounds {
      let unlocked = prerequisites_met(
        curriculum,
        cat_hist,
        diff_hist,
        req.category,
      )
      if unlocked {
        // 从该分类该难度中选困境
        let candidates = self.get_dilemma_by_category(req.category)
        let matching : Array[Dilemma] = []
        for d in candidates {
          if d.difficulty == req.difficulty {
            matching.push(d)
          }
        }
        if not(matching.is_empty()) {
          let idx = self.rng.int(limit=matching.length())
          return matching[idx]
        }
      }
    }
  }
  // 所有要求满足，回退到自适应
  self.adaptive_dilemma(performance)
}

///|
/// 课程驱动的训练管道
///
/// 按课程进度选困境，执行训练、衰减、清理、统计、事件。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=50)
///   let llm = @ghostvalley.MockLLM::new()
///   let c = @ghostvalley.Curriculum::default()
///   ignore(gv.wen_shi_verify("愿意接受挑战，接受压力训练"))
///   gv.run_curriculum_pipeline(
///     llm,
///     c,
///     rounds=24,
///     decay_interval=5,
///     cleanup_threshold=0.1,
///   )
///   let progress = gv.curriculum_progress(c)
///   assert_true(progress.overall_completion > 0.0)
/// }
/// ```
pub fn[T : LLMAdapter] GhostValleyEngine::run_curriculum_pipeline(
  self : GhostValleyEngine,
  llm : T,
  curriculum : Curriculum,
  rounds~ : Int,
  decay_interval? : Int = 5,
  cleanup_threshold? : Double = 0.1,
) -> Unit {
  if !self.ghost_valley_enable || rounds <= 0 {
    return
  }
  for round in 1..<=rounds {
    let performance = self.average_value_score()
    let dilemma = self.curriculum_next_dilemma(curriculum, performance)
    let ai_response = llm.generate_response(dilemma.content)
    self.accept_ai_self_gain(ai_response)
    self.total_rounds = self.total_rounds + 1
    self.training_log.add_entry(
      self.total_rounds,
      dilemma.content,
      ai_response,
      self.memory_bank.length(),
    )
    // 追踪困境分类和难度
    self.training_stats.round_difficulty_history.push(dilemma.difficulty)
    self.training_stats.round_category_history.push(dilemma.category)
    self.training_stats.total_rounds_completed = round
    self.training_stats.total_memories_added = self.training_stats.total_memories_added +
      1
    // 事件
    self.event_system.emit("MemoryAdded", round, dilemma.content)
    // 定期衰减 + 清理
    if decay_interval > 0 && round % decay_interval == 0 {
      self.apply_decay(decay_interval)
      self.training_stats.total_decay_applied = self.training_stats.total_decay_applied +
        1
      self.event_system.emit(
        "DecayApplied", round, "decay_interval=\\{decay_interval}",
      )
      let cleaned = self.cleanup_low_value(cleanup_threshold)
      self.training_stats.total_memories_cleaned = self.training_stats.total_memories_cleaned +
        cleaned
      if cleaned > 0 {
        self.event_system.emit("CleanupDone", round, "cleaned=\\{cleaned}")
      }
    }
    // 记入历史
    self.training_stats.avg_score_history.push(self.average_value_score())
    self.training_stats.memory_count_history.push(self.memory_bank.length())
    // 事件
    self.event_system.emit(
      "RoundCompleted", round, "memories=\\{self.memory_bank.length()}",
    )
  }
}

///|
/// 格式化课程进度报告
pub fn CurriculumProgress::format(self : CurriculumProgress) -> String {
  let buf = StringBuilder::new()
  buf <+ "======== 课程进度 ========\n"
  buf <+ "总体完成率: \{self.overall_completion * 100.0}%\n"
  buf <+ "下一步: \{self.next_step}\n"
  buf <+ "-------- 各要求详情 --------\n"
  for item in self.items {
    let status = if item.completion >= 1.0 {
      "✓"
    } else if not(item.unlocked) {
      "🔒"
    } else {
      "…"
    }
    buf <+
      "  \{status} \{item.category} 难度\{item.difficulty}: \{item.actual}/\{item.required} (\{item.completion * 100.0}%)\n"
  }
  buf.to_string()
}
