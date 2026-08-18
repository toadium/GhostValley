///|
test "text_value_score high value" {
  let score = @ghostvalley.text_value_score("顿悟失败原因，反思改进")
  assert_true(score > 0.5)
}

///|
test "text_value_score low value" {
  let score = @ghostvalley.text_value_score("普通日常随便应付")
  assert_true(score < 0.3)
}

///|
test "text_value_score mid value" {
  let score = @ghostvalley.text_value_score("任务失败，有错误")
  assert_true(score > 0.2)
}

///|
test "text_value_score base score" {
  let score = @ghostvalley.text_value_score("无关键词文本")
  assert_true(score >= 0.05)
  assert_true(score <= 0.3)
}

///|
test "text_value_score multi high bonus" {
  let score = @ghostvalley.text_value_score("顿悟反思改进修复迭代")
  assert_true(score > 0.7)
}

///|
test "text_similarity identical" {
  let sim = @ghostvalley.text_similarity("失败反思", "失败反思")
  assert_true(sim == 1.0)
}

///|
test "text_similarity no overlap" {
  let sim = @ghostvalley.text_similarity("失败", "训练")
  assert_true(sim == 0.0)
}

///|
test "text_similarity partial overlap" {
  let sim = @ghostvalley.text_similarity("失败反思", "失败改进")
  assert_true(sim > 0.0)
  assert_true(sim < 1.0)
}

///|
test "text_similarity empty string" {
  let sim = @ghostvalley.text_similarity("", "失败")
  assert_true(sim == 0.0)
}
