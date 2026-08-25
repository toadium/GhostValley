# Changelog

## [1.12.0] - 2026-08-25

### Added
- **ASCII 折线图**：generate_ascii_chart(scores, title) 训练分数趋势可视化
- **ASCII 柱状图**：generate_ascii_bar(data, title) 分类覆盖度可视化
- **训练仪表盘**：TrainingDashboard + render_dashboard() 整合所有可视化
- **Markdown 报告导出**：export_full_report_markdown() 含表格+图表+建议的完整报告
- **情绪状态建模**：EmotionState（stress/confidence/resilience）+ update/recover/is_breakdown
- **情绪画像**：EmotionProfile 训练全程情绪统计 + trajectory/confidence_trajectory
- **权重检索策略**：WeightStrategy 枚举（Recency/Frequency/Value/Combined）+ weighted_retrieve
- **困境场景库**：DilemmaLibrary + DilemmaTemplate 支持变量插值
- **5 个预置业务场景**：客服危机、项目延期、团队冲突、技术选型失误、安全事故复盘
- **训练安全协议**：TrainingProtocol + protocol_check + ProtocolViolation
- **审计日志**：AuditLog + AuditEntry + query_by_action/query_by_risk/export_csv
- **协议强制执行**：enforce_protocol + cooldown_period 冷却期恢复
- **3 个业务综合示例**：客服危机处理、技术团队压力演练、新员工入职心理建设

## [1.11.0] - 2026-08-25

### Added
- **训练安全协议**：TrainingProtocol（max_stress_level, min_confidence, max_rounds_without_improvement, cooldown_rounds）
- **协议检查**：protocol_check() 检查压力超限/信心过低/无改善/崩溃
- **协议违反**：ProtocolViolation 结构体记录违反详情
- **审计日志**：AuditEntry + AuditLog + add_entry/query_by_action/query_by_risk/export_audit_csv
- **协议强制执行**：enforce_protocol() 违反时记录审计并暂停训练
- **冷却期**：cooldown_period() 暂停训练执行情绪恢复

## [1.10.0] - 2026-08-25

### Added
- **困境模板**：DilemmaTemplate 支持变量插值 {var_name}
- **困境场景库**：DilemmaLibrary 管理多场景困境模板集合
- **5 个预置业务场景**：客服危机、项目延期、团队冲突、技术选型失误、安全事故复盘
- **模板实例化**：instantiate() 将模板变量替换为实际值
- **场景检索**：get_dilemmas/get_all_templates/list_scenarios

## [1.9.0] - 2026-08-25

### Added
- **情绪状态建模**：EmotionState（stress_level, confidence, resilience, mood_history）
- **情绪更新**：update() 困境难度→压力↑，响应质量→信心↑
- **情绪恢复**：recover() 压力衰减5%，信心向0.5回归3%
- **压力崩溃检测**：is_breakdown() stress>0.9 且 confidence<0.2
- **情绪画像**：EmotionProfile 全程统计 + trajectory/confidence_trajectory
- **权重检索策略**：WeightStrategy（Recency/Frequency/Value/Combined）+ weighted_retrieve

## [1.8.0] - 2026-08-25

### Added
- **高级统计**：confidence_interval(scores, level) 置信区间（90%/95%/99%）
- **显著性检验**：significance_test(before, after) 简化 t 检验，SignificanceResult
- **CSV 导出**：export_report_csv() 训练统计导出为 CSV
- **JSON 评估导出**：export_evaluation_json() 综合评估导出为结构化 JSON
- **训练总结**：training_summary() 人类可读完整训练报告（评估+课程+事件+建议）

## [1.7.0] - 2026-08-25

### Added
- **训练检查点**：TrainingCheckpoint + save/load_checkpoint() 断点续训
- **训练回放**：replay_training(log, new_config?) 从日志重建困境序列重跑
- ReplayResult 原训练 vs 回放训练对比
- resume_training(checkpoint, llm, additional_rounds) 断点续训

## [1.6.0] - 2026-08-25

### Added
- **记忆聚类**：cluster_memories(threshold) 按文本相似度分组
- **自动关联**：auto_link(threshold, strength) 自动为相似记忆建链
- **簇统计**：ClusterSummary + cluster_statistics()
- **自适应强化**：adaptive_reinforce(idx) 增量随 access_count 递减

### Changed
- reinforce_memory 改用 adaptive_reinforce（边际递减效应）

## [1.5.0] - 2026-08-25

### Added
- **多智能体对比训练**：ComparativeResult + compare_responses + run_comparative_round/pipeline
- **交叉学习**：cross_pollinate(target, source, top_n) 导入高价值记忆
- **多智能体会话**：MultiAgentSession 管理多引擎 + cross_learn_all()

## [1.4.0] - 2026-08-24

### Added
- **训练课程体系**：Curriculum 结构体——分类间前置依赖 + 每分类每难度最低轮次要求 + 完成判定
- curriculum_next_dilemma()：按课程进度选困境，优先补足薄弱分类，前置依赖满足后才解锁
- curriculum_progress()：各分类完成度（0-1）+ 总体完成率 + 下一步建议
- run_curriculum_pipeline()：课程驱动的训练管道
- CurriculumProgress::format()：格式化课程进度报告

## [1.3.0] - 2026-08-24

### Added
- **可配置评分**：ScoringConfig 结构体——自定义高/中/低价值关键词及权重，configurable_text_value_score()
- **可配置衰减**：DecayModel 枚举（Hyperbolic/Linear/Exponential）+ DecayParams 可调参数
- **事件系统**：TrainingEvent 枚举 + EventSystem 事件日志 + 回调注册 register_callback + emit
- 训练管道自动 emit 事件（MemoryAdded/DecayApplied/CleanupDone/RoundCompleted）
- 引擎配置访问器：get/set_scoring_config, get/set_decay_model, get/set_decay_params
- 事件查询：get_event_log, event_count

### Changed
- text_value_score 改为调用默认配置的便捷方法（向后兼容）
- apply_decay 按引擎配置的衰减模型计算（默认仍为 Hyperbolic，向后兼容）
- add_memory 使用引擎 scoring_config 而非全局硬编码

## [1.2.0] - 2026-08-24

### Added
- **记忆关联图谱**：AiMemory 新增 access_count + linked_ids 字段
- link_memories()：双向关联建立，strength ∈ [0,1]
- associative_retrieve()：BFS 沿关联链检索
- reinforce_memory()：间隔重复强化（access_count++ + value_score 微增）
- access_frequency_report()：按访问频率排序的记忆列表
- 检索方法（search_memories/weighted_search/top_memories）命中时自动 reinforce

### Changed
- 持久化向后兼容：旧数据默认 access_count=0/linked_ids=[]

## [1.1.0] - 2026-08-24

### Added
- **训练评估体系**：TrainingEvaluator——韧性分、分类覆盖度、改善率、S/A/B/C/D 评级
- resilience_score()：高难度/低难度平均响应分比值
- category_coverage()：4 分类训练覆盖情况
- improvement_rate()：线性回归斜率量化进步速度
- evaluate_training()：综合评估接口
- TrainingEvaluation::format()：格式化评估报告

### Changed
- run_training_pipeline 改用 adaptive_dilemma 结构化困境
- TrainingStats 新增 round_difficulty_history/round_category_history

## [1.0.0] - 2026-08-23

### Added
- **ARCHITECTURE.md**：完整架构文档——五大模块设计原理、数据流图、扩展点说明、API 稳定性表
- **DESIGN_RATIONALE.md**：8 条设计决策记录——关键词匹配 vs embedding、双曲衰减、30% 遗忘率、加权检索权重等
- README 更增完整使用教程（从安装到完整训练流程）
- API 稳定化审查：所有公开 API 标记 stable

### Changed
- 版本 bump 到 1.0.0，标志 API 稳定化完成

## [0.8.0] - 2026-08-23

### Added
- 11 个属性测试：容量上限/核心保护/排序正确性/分数范围/合并减一/去重不重复
- 6 个模糊测试：随机 add/forget/cleanup/decay/search/merge/pipeline 不崩溃
- 7 个基准测试：1000 条记忆下检索/遗忘/衰减/状态持久化性能基线

### Fixed
- `active_forget` 的 `remove_count` 整除为 0 时强制至少删除 1 条（修复小容量遗忘失效遗留）

### Changed
- `top_memories` 从 O(n log n) 全排序优化为 O(n*k) partial selection
- 测试数量：192 → 216

## [0.7.0] - 2026-08-23

### Added
- `Dilemma { content, category, difficulty }` 结构化困境——4 分类 x 3 难度 = 12 默认困境
- `get_dilemma_by_category` / `get_dilemma_by_difficulty` 分类检索
- `adaptive_dilemma(performance)` 按表现自动选难度
- `save_engine_state` / `load_engine_state` 全状态持久化（memory + stats + config + rounds）
- `EngineState` 结构体 + JSON roundtrip
- 37 个测试

### Changed
- `max_memory_num` 改为 `mut` 以支持状态恢复
- 测试数量：155 → 192

## [0.6.0] - 2026-08-23

### Added
- `TrainingStats` 结构体：跨轮次指标追踪（保留率/平均分趋势/清理总数/衰减次数）
- `run_training_pipeline(llm, rounds, decay_interval, cleanup_threshold)` 自动化训练管道
- `get_training_stats()` / `export_stats_json()` 统计接口
- `retention_rate()` / `score_trend()` / `format()` 统计分析方法
- 19 个测试

### Changed
- 测试数量：136 → 155

## [0.5.0] - 2026-08-23

### Added
- `weighted_search(query, top_n)` 加权综合检索：value_score*0.4 + similarity*0.4 + recency*0.2
- `add_memory_dedup(content, threshold=0.8)` 去重添加：超阈值合并而非重复添加
- `merge_memories(idx_a, idx_b)` 手动合并接口
- 21 个测试

### Changed
- 测试数量：115 → 136

## [0.4.0] - 2026-08-22

### Fixed
- **空困境池崩溃修复**：`build_simulation_failure_case` 在困境池为空时不再 panic，返回安全默认困境
- **小容量遗忘失效修复**：`active_forget` 在 `max_memory_num` 很小（如 1）时触发阈值至少为 1，避免每次添加都触发无效遗忘
- **持久化分数校验**：`load_memory` 从 JSON 加载时将 `value_score` clamp 到 [0.05, 0.95]，防止损坏数据破坏后续逻辑

### Added
- 5 个新边界测试：空困境池运行、空困境池默认返回、小容量遗忘清理、load_memory 负数 clamp、load_memory 超大值 clamp
- CI 增加 js 后端测试目标

### Changed
- 测试数量：110 → 115（四后端全通过：native/wasm-gc/wasm/js）
- CI 覆盖：三后端 → 四后端

## [0.3.0] - 2026-08-18

### Added
- **记忆检索 API**：`search_memories`/`top_memories`/`filter_memories`/`average_value_score`
- **记忆分类检索**：`real_memories`/`simulation_memories`/`core_memories` 便捷方法
- **记忆衰减机制**：`apply_decay` 基于双曲衰减模型，高分记忆衰减更慢
- **低价值清理**：`cleanup_low_value` 按阈值清理非核心记忆
- **分数统计**：`min_value_score`/`max_value_score` 获取分数范围
- **训练日志系统**：`TrainingLog`/`TrainingLogEntry` 结构化日志记录
- **日志自动记录**：`run_round_with_llm` 自动记录每轮训练
- **日志手动记录**：`log_round` 供手动流程记录
- **日志导出**：`export_training_log_json`/`export_training_log_string`/`export_training_log_format`
- **配置化困境池**：`add_dilemma`/`set_dilemma_pool`/`dilemma_pool_size` 动态管理困境

### Changed
- `AiMemory.value_score` 改为 `mut` 以支持衰减机制
- `GhostValleyEngine` 新增 `training_log` 字段
- `run_round_with_llm` 自动记录训练日志

### Technical
- 代码行数：~600 → ~850 行
- 测试数量：55 → 110（三后端全通过）
- 新增文件：retrieval/decay/training_log + 测试 + boundary_test
- 公开 API：20+ → 40+

## [0.2.0] - 2026-08-18

### Added
- **Embedding 语义打分**：`text_value_score` 基于关键词匹配替代纯随机打分
- **文本相似度**：`text_similarity` 基于关键词重叠率计算相似度
- **LLM 接口抽象**：`trait LLMAdapter` + `MockLLM` 实现
- **LLM 自动训练**：`run_round_with_llm` 一轮训练 + LLM 自动响应
- **多轮训练 API**：`ghost_valley_run_rounds(n)` 批量训练
- **记忆持久化**：`save_memory`/`load_memory` JSON 序列化
- **训练报告**：`TrainingReport` 结构化报告 + JSON 导出
- **训练轮次追踪**：`total_rounds` 字段

### Changed
- `add_memory` 用语义打分 + 随机扰动替代纯随机
- `active_forget` 优化 O(n^2) → O(n log n)
- `AiMemory` 添加 `ToJson` derive
- 警告治理 25→0（默认级别）

### Technical
- 代码行数：313 → ~600 行
- 测试数量：21 → 55（三后端全通过）
- 新增依赖：`moonbitlang/core/json`
- 新增文件：embedding/llm_adapter/persistence/report + 测试

## [0.1.0] - 2026-08-18

### Added
- 幽灵谷工程 MoonBit 移植初始版本
- 五大模块完整实现：
  - 温石验证（态度文本打分）
  - 防创伤安全气垫（`is_simulation` 标记）
  - 主动式遗忘机制（自打分淘汰低价值记忆）
  - 第八根空桩（不内置标准答案）
  - 建造者退场逻辑（AI 自主生成结论）
- `GhostValleyEngine` 引擎 API（12 个公开方法）
- `AiMemory` 记忆单元结构体
- 21 个测试（三后端全通过：native/wasm-gc/wasm）
- README.mbt.md（API 参考 + 移植说明）
- CI 配置（GitHub Actions）
- 独立示例（`examples/demo/`）

### Technical
- 原项目：Python 幽灵谷工程（用户提供概念性原型）
- 依赖：仅 `moonbitlang/core/random`
- 许可证：Apache-2.0
- 已发布至 mooncakes.io：`walkzzz/ghostvalley`
