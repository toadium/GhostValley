// ============================================================
// Phase 2: 记忆聚类 + 自动关联 + 自适应强化
// ============================================================

///|
/// 记忆聚类
///
/// 按文本相似度将记忆分组。相似度超过 threshold 的记忆归入同一簇。
/// 使用贪心算法：每条记忆与已有簇的代表记忆比较，相似则加入，否则新建簇。
///
/// 返回 Array[Array[Int]]，每个子数组是一个簇，包含记忆索引。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=20)
///   gv.add_memory("顿悟反思改进", is_simulation=false)
///   gv.add_memory("顿悟反思修复", is_simulation=false)
///   gv.add_memory("普通日常随便", is_simulation=false)
///   let clusters = gv.cluster_memories(0.3)
///   assert_true(clusters.length() >= 2)
/// }
/// ```
pub fn GhostValleyEngine::cluster_memories(
  self : GhostValleyEngine,
  similarity_threshold : Double,
) -> Array[Array[Int]] {
  let bank = self.memory_bank
  if bank.length() == 0 {
    return []
  }
  // 每个簇: (代表记忆索引, 簇内索引列表)
  let clusters : Array[(Int, Array[Int])] = []
  for i in 0..<bank.length() {
    let mut assigned = false
    for c in 0..<clusters.length() {
      let (rep_idx, members) = clusters[c]
      let sim = text_similarity(bank[i].content, bank[rep_idx].content)
      if sim >= similarity_threshold {
        members.push(i)
        assigned = true
        break
      }
    }
    if not(assigned) {
      clusters.push((i, [i]))
    }
  }
  let result : Array[Array[Int]] = []
  for c in clusters {
    let (_, members) = c
    result.push(members)
  }
  result
}

///|
/// 自动关联
///
/// 自动为文本相似度超过阈值的记忆对建立关联。
/// 避免自关联和重复关联。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=20)
///   gv.add_memory("顿悟反思改进", is_simulation=false)
///   gv.add_memory("顿悟反思修复", is_simulation=false)
///   gv.add_memory("普通日常", is_simulation=false)
///   let count = gv.auto_link(0.3, strength=0.5)
///   assert_true(count >= 1)
/// }
/// ```
pub fn GhostValleyEngine::auto_link(
  self : GhostValleyEngine,
  similarity_threshold : Double,
  strength~ : Double,
) -> Int {
  let bank = self.memory_bank
  let mut link_count = 0
  for i in 0..<bank.length() {
    for j in (i + 1)..<bank.length() {
      let sim = text_similarity(bank[i].content, bank[j].content)
      if sim >= similarity_threshold {
        // 检查是否已关联
        let mut already_linked = false
        for link in bank[i].linked_ids {
          let (linked_idx, _) = link
          if linked_idx == j {
            already_linked = true
            break
          }
        }
        if not(already_linked) {
          self.link_memories(i, j, strength~)
          link_count = link_count + 1
        }
      }
    }
  }
  link_count
}

///|
/// 簇摘要
///
/// 记录单个聚类的统计信息。
pub(all) struct ClusterSummary {
  cluster_id : Int
  size : Int
  avg_score : Double
  representative_content : String
  member_indices : Array[Int]
} derive(Debug, ToJson, FromJson)

///|
pub extend ClusterSummary with @debug.Debug::{to_repr}

///|
pub extend ClusterSummary with ToJson::{to_json}

///|
pub extend ClusterSummary with FromJson::{from_json}

///|
/// 簇统计信息
///
/// 对当前记忆库进行聚类并返回各簇的统计摘要。
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=20)
///   gv.add_memory("顿悟反思改进", is_simulation=false)
///   gv.add_memory("普通日常", is_simulation=false)
///   let stats = gv.cluster_statistics(0.3)
///   assert_true(stats.length() >= 1)
/// }
/// ```
pub fn GhostValleyEngine::cluster_statistics(
  self : GhostValleyEngine,
  similarity_threshold : Double,
) -> Array[ClusterSummary] {
  let clusters = self.cluster_memories(similarity_threshold)
  let bank = self.memory_bank
  let summaries : Array[ClusterSummary] = []
  for i in 0..<clusters.length() {
    let members = clusters[i]
    let mut score_sum = 0.0
    for idx in members {
      score_sum = score_sum + bank[idx].value_score
    }
    let avg = if members.length() > 0 {
      score_sum / members.length().to_double()
    } else {
      0.0
    }
    // 代表记忆为簇中分数最高的
    let mut rep_idx = members[0]
    let mut rep_score = bank[rep_idx].value_score
    for idx in members {
      if bank[idx].value_score > rep_score {
        rep_score = bank[idx].value_score
        rep_idx = idx
      }
    }
    summaries.push(ClusterSummary::{
      cluster_id: i,
      size: members.length(),
      avg_score: avg,
      representative_content: bank[rep_idx].content,
      member_indices: members,
    })
  }
  summaries
}

///|
/// 自适应强化
///
/// 根据访问频率自适应递减强化量。
/// access_count 越高，增量越小（边际递减效应）。
/// increment = 0.02 / (1.0 + access_count * 0.1)
/// 首次: 0.02, 第 10 次: 0.01, 第 20 次: 0.0067
///
/// # Example
/// ```mbt check
/// test {
///   let gv = @ghostvalley.new_engine(max_memory_num=20)
///   gv.add_memory("记忆A", is_simulation=false)
///   let s0 = gv.memory_bank[0].value_score
///   gv.adaptive_reinforce(0)
///   let s1 = gv.memory_bank[0].value_score
///   gv.adaptive_reinforce(0)
///   let s2 = gv.memory_bank[0].value_score
///   // 第一次增量 > 第二次增量
///   assert_true(s1 - s0 > s2 - s1)
/// }
/// ```
pub fn GhostValleyEngine::adaptive_reinforce(
  self : GhostValleyEngine,
  idx : Int,
) -> Unit {
  let bank = self.memory_bank
  if idx < 0 || idx >= bank.length() {
    return
  }
  bank[idx].access_count = bank[idx].access_count + 1
  // 自适应增量: 0.02 / (1 + access_count * 0.1)
  let increment = 0.02 / (1.0 + bank[idx].access_count.to_double() * 0.1)
  let new_score = bank[idx].value_score + increment
  bank[idx].value_score = if new_score > 0.95 { 0.95 } else { new_score }
}

///|
/// 格式化簇摘要
pub fn ClusterSummary::format(self : ClusterSummary) -> String {
  let buf = StringBuilder::new()
  buf <+
    "簇 #\{self.cluster_id}: \{self.size} 条记忆, 平均分 \{self.avg_score}\n"
  buf <+ "  代表: \{self.representative_content}\n"
  buf.to_string()
}
