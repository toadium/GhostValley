// ============================================================
// Phase 1 (v1.9.0) 测试：情绪状态建模 + 记忆权重检索策略
// ============================================================

///|
test "EmotionState::initial 初始状态" {
  let es = EmotionState::initial()
  assert_eq(es.stress_level, 0.0)
  assert_eq(es.confidence, 0.5)
  assert_eq(es.resilience, 0.0)
  assert_eq(es.mood_history.length(), 0)
}

///|
test "EmotionState::update 难度1低压低信心增量" {
  let es = EmotionState::initial()
  es.update(round=1, dilemma_difficulty=1, response_score=0.6)
  assert_true(es.stress_level > 0.0)
  assert_true(es.confidence > 0.5)
  assert_eq(es.mood_history.length(), 1)
}

///|
test "EmotionState::update 难度3高压高信心增量" {
  let es = EmotionState::initial()
  es.update(round=1, dilemma_difficulty=3, response_score=0.8)
  assert_true(es.stress_level >= 0.35)
  assert_true(es.confidence > 0.5)
}

///|
test "EmotionState::update 低质量响应降低信心" {
  let es = EmotionState::initial()
  es.update(round=1, dilemma_difficulty=2, response_score=0.2)
  assert_true(es.confidence < 0.5)
}

///|
test "EmotionState::update 高压高质提升韧性" {
  let es = EmotionState::initial()
  es.update(round=1, dilemma_difficulty=3, response_score=0.8)
  assert_true(es.resilience > 0.0)
}

///|
test "EmotionState::update 低压或低质不提升韧性" {
  let es = EmotionState::initial()
  es.update(round=1, dilemma_difficulty=1, response_score=0.8)
  assert_eq(es.resilience, 0.0)
  let es2 = EmotionState::initial()
  es2.update(round=1, dilemma_difficulty=3, response_score=0.3)
  assert_eq(es2.resilience, 0.0)
}

///|
test "EmotionState::recover 压力衰减" {
  let es = EmotionState::initial()
  es.stress_level = 0.8
  es.recover()
  assert_true(es.stress_level < 0.8)
  assert_true(es.stress_level > 0.0)
}

///|
test "EmotionState::recover 信心向0.5回归" {
  let es = EmotionState::initial()
  es.confidence = 0.9
  es.recover()
  assert_true(es.confidence < 0.9)
  assert_true(es.confidence > 0.5)
  let es2 = EmotionState::initial()
  es2.confidence = 0.1
  es2.recover()
  assert_true(es2.confidence > 0.1)
  assert_true(es2.confidence < 0.5)
}

///|
test "EmotionState::is_breakdown 正常状态不崩溃" {
  let es = EmotionState::initial()
  assert_false(es.is_breakdown())
}

///|
test "EmotionState::is_breakdown 高压低信崩溃" {
  let es = EmotionState::initial()
  es.stress_level = 0.95
  es.confidence = 0.1
  assert_true(es.is_breakdown())
}

///|
test "EmotionState::is_breakdown 边界条件" {
  let es = EmotionState::initial()
  es.stress_level = 0.9
  es.confidence = 0.2
  // 严格大于 0.9 且严格小于 0.2，边界值不触发
  assert_false(es.is_breakdown())
}

///|
test "EmotionState::profile 空历史返回零" {
  let es = EmotionState::initial()
  let p = es.profile()
  assert_eq(p.peak_stress, 0.0)
  assert_eq(p.total_snapshots, 0)
}

///|
test "EmotionState::profile 有历史返回统计" {
  let es = EmotionState::initial()
  es.update(round=1, dilemma_difficulty=2, response_score=0.6)
  es.update(round=2, dilemma_difficulty=3, response_score=0.7)
  es.update(round=3, dilemma_difficulty=1, response_score=0.5)
  let p = es.profile()
  assert_eq(p.total_snapshots, 3)
  assert_true(p.peak_stress > 0.0)
  assert_true(p.avg_stress > 0.0)
}

///|
test "EmotionState::profile 崩溃计数" {
  let es = EmotionState::initial()
  es.stress_level = 0.95
  es.confidence = 0.1
  es.mood_history.push(MoodSnapshot::{
    round: 1,
    stress: 0.95,
    confidence: 0.1,
    resilience: 0.0,
  })
  let p = es.profile()
  assert_eq(p.breakdown_count, 1)
}

///|
test "EmotionState::trajectory 返回压力曲线" {
  let es = EmotionState::initial()
  es.update(round=1, dilemma_difficulty=1, response_score=0.6)
  es.update(round=2, dilemma_difficulty=2, response_score=0.6)
  let traj = es.trajectory()
  assert_eq(traj.length(), 2)
  assert_true(traj[1] > traj[0]) // 第二轮压力更高
}

///|
test "EmotionState::confidence_trajectory 返回信心曲线" {
  let es = EmotionState::initial()
  es.update(round=1, dilemma_difficulty=1, response_score=0.8)
  es.update(round=2, dilemma_difficulty=1, response_score=0.2)
  let traj = es.confidence_trajectory()
  assert_eq(traj.length(), 2)
  assert_true(traj[0] > traj[1]) // 第一轮信心更高
}

///|
test "EmotionState::format 输出包含关键信息" {
  let es = EmotionState::initial()
  es.update(round=1, dilemma_difficulty=2, response_score=0.6)
  let s = es.format()
  assert_true(s.contains("压力水平"))
  assert_true(s.contains("信心水平"))
  assert_true(s.contains("韧性水平"))
}

///|
test "EmotionState::format 崩溃时输出警告" {
  let es = EmotionState::initial()
  es.stress_level = 0.95
  es.confidence = 0.1
  let s = es.format()
  assert_true(s.contains("警告"))
}

///|
test "weighted_retrieve Recency策略" {
  let gv = new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  gv.add_memory("记忆B", is_simulation=false)
  gv.add_memory("记忆C", is_simulation=false)
  let results = gv.weighted_retrieve(2, @ghostvalley.Recency)
  assert_eq(results.length(), 2)
  // @ghostvalley.Recency: 最后添加的优先
  assert_true(results[0].content.contains("记忆C"))
}

///|
test "weighted_retrieve Value策略" {
  let gv = new_engine(max_memory_num=20)
  gv.add_memory("普通日常随便", is_simulation=false)
  gv.add_memory("顿悟反思改进", is_simulation=false)
  let results = gv.weighted_retrieve(1, @ghostvalley.Value)
  assert_eq(results.length(), 1)
  // @ghostvalley.Value: 高价值记忆优先
  assert_true(results[0].value_score > 0.3)
}

///|
test "weighted_retrieve Frequency策略" {
  let gv = new_engine(max_memory_num=20)
  gv.add_memory("顿悟反思改进", is_simulation=false)
  gv.add_memory("普通日常随便", is_simulation=false)
  // 检索第一条增加其 access_count
  ignore(gv.search_memories("顿悟"))
  let results = gv.weighted_retrieve(1, @ghostvalley.Frequency)
  assert_eq(results.length(), 1)
  // @ghostvalley.Frequency: 被检索过的优先
  assert_true(results[0].access_count > 0)
}

///|
test "weighted_retrieve Combined策略" {
  let gv = new_engine(max_memory_num=20)
  gv.add_memory("普通日常随便", is_simulation=false)
  gv.add_memory("顿悟反思改进", is_simulation=false)
  let results = gv.weighted_retrieve(1, @ghostvalley.Combined)
  assert_eq(results.length(), 1)
}

///|
test "weighted_retrieve 空记忆库" {
  let gv = new_engine()
  let results = gv.weighted_retrieve(5, @ghostvalley.Combined)
  assert_eq(results.length(), 0)
}

///|
test "weighted_retrieve n超过记忆数" {
  let gv = new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  let results = gv.weighted_retrieve(10, @ghostvalley.Combined)
  assert_eq(results.length(), 1)
}

///|
test "weighted_retrieve n为0" {
  let gv = new_engine(max_memory_num=20)
  gv.add_memory("记忆A", is_simulation=false)
  let results = gv.weighted_retrieve(0, @ghostvalley.Combined)
  assert_eq(results.length(), 0)
}

///|
test "WeightStrategy 序列化" {
  let s = @json.to_json(@ghostvalley.Combined)
  let str = s.stringify()
  assert_true(str.contains("Combined"))
}
