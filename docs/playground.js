const $reinterpret_view = new DataView(new ArrayBuffer(8));
function $i64_reinterpret_f64(a) {
  $reinterpret_view.setBigUint64(0, BigInt.asUintN(64, a), false);
  return $reinterpret_view.getFloat64(0, false);
}
function _M0TPB5ArrayGsE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TP27walkzzz11ghostvalley10QwenSample(param0, param1, param2, param3, param4, param5) {
  this.dilemma = param0;
  this.category = param1;
  this.difficulty = param2;
  this.response = param3;
  this.latency_ms = param4;
  this.tokens = param5;
}
function _M0TPB5ArrayGRP27walkzzz11ghostvalley10QwenSampleE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TP27walkzzz11ghostvalley11DecayParams(param0, param1) {
  this.linear_rate = param0;
  this.exp_decay_base = param1;
}
function _M0TPC16string10StringView(param0, param1, param2) {
  this.str = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TP27walkzzz11ghostvalley10QwenConfig(param0, param1, param2, param3) {
  this.max_response_chars = param0;
  this.fallback = param1;
  this.match_threshold = param2;
  this.quality_gate = param3;
}
function $oob() {
  throw new Error("Index out of bounds");
}
class $PanicError extends Error {}
function $panic(message) {
  throw new $PanicError(message);
}
function _M0TPB13StringBuilder(param0) {
  this.val = param0;
}
const _M0FPB12random__seed = () => {
  const cryptoObj = globalThis.crypto;
  if (cryptoObj != null && typeof cryptoObj.getRandomValues === "function") {
    try {
      const array = new Uint32Array(1);
      cryptoObj.getRandomValues(array);
      return array[0] | 0; // Convert to signed 32
    } catch (_) {
      // The host refuses Web Crypto here, e.g. Workers at module load
    }
  }
  return Math.floor(Math.random() * 0x100000000) | 0; // Fallback to Math.random
};
const _M0FPB19int__to__string__js = (x, radix) => {
  return x.toString(radix);
};
function _M0TPB4IterGUssEE(param0, param1) {
  this.f = param0;
  this.size_hint = param1;
}
function $make_array_len_and_init(a, b) {
  const arr = new Array(a);
  arr.fill(b);
  return arr;
}
const _M0FPB13js__index__of = (s, start, end, p) => {
  if (end - start < p.length) return -1;
  if (end === s.length) return s.indexOf(p, start);
  const i = s.substring(start, end).indexOf(p);
  return i < 0 ? i : start + i;
};
const _M0FPB13js__substring = (s, start, end) => start === 0 && end === s.length ? s : s.substring(start, end);
const _M0FPB22js__code__unit__string = (c) => String.fromCharCode(c);
function _M0TPB5ArrayGcE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TPB3MapGssE(param0, param1, param2, param3, param4, param5, param6) {
  this.entries = param0;
  this.size = param1;
  this.capacity = param2;
  this.capacity_mask = param3;
  this.grow_at = param4;
  this.head = param5;
  this.tail = param6;
}
function _M0TPB3MapGsuE(param0, param1, param2, param3, param4, param5, param6) {
  this.entries = param0;
  this.size = param1;
  this.capacity = param2;
  this.capacity_mask = param3;
  this.grow_at = param4;
  this.head = param5;
  this.tail = param6;
}
function _M0TPB5EntryGssE(param0, param1, param2, param3, param4, param5) {
  this.prev = param0;
  this.next = param1;
  this.psl = param2;
  this.hash = param3;
  this.key = param4;
  this.value = param5;
}
function _M0TPB5EntryGsuE(param0, param1, param2, param3, param4, param5) {
  this.prev = param0;
  this.next = param1;
  this.psl = param2;
  this.hash = param3;
  this.key = param4;
  this.value = param5;
}
function _M0TPB8MutLocalGORPB5EntryGssEE(param0) {
  this.val = param0;
}
function _M0TPB8MutLocalGiE(param0) {
  this.val = param0;
}
function _M0TPB8MutLocalGORPB5EntryGsuEE(param0) {
  this.val = param0;
}
function _M0TPC15bytes9BytesView(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TPB12MutArrayViewGUidEE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TPB12MutArrayViewGiE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TPC36random8internal14random__source7ChaCha8(param0, param1, param2, param3, param4) {
  this.buffer = param0;
  this.seed = param1;
  this.i = param2;
  this.n = param3;
  this.counter = param4;
}
function _M0TPC16random4Rand(param0) {
  this.source = param0;
}
function _M0TPC16random7UInt128(param0, param1) {
  this.hi = param0;
  this.lo = param1;
}
function $i64_trunc_f64_u(a) {
  if (Number.isNaN(a)) return 0n;
  if (a >= 18446744073709551615) return 18446744073709551615n;
  if (a <= 0) return 0n;
  return BigInt.asUintN(64, BigInt(Math.trunc(a)));
}
function $f64_reinterpret_i64(a) {
  $reinterpret_view.setFloat64(0, a, false);
  return BigInt.asUintN(64, $reinterpret_view.getBigUint64(0, false));
}
function $f64_convert_i64_u(a) {
  return Number(a);
}
function _M0TP27walkzzz11ghostvalley13TrainingStats(param0, param1, param2, param3, param4, param5, param6, param7) {
  this.total_rounds_completed = param0;
  this.total_memories_added = param1;
  this.total_memories_cleaned = param2;
  this.total_decay_applied = param3;
  this.avg_score_history = param4;
  this.memory_count_history = param5;
  this.round_difficulty_history = param6;
  this.round_category_history = param7;
}
function _M0TPB5ArrayGdE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TPB5ArrayGiE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TP27walkzzz11ghostvalley11TrainingLog(param0) {
  this.entries = param0;
}
function _M0TPB5ArrayGRP27walkzzz11ghostvalley16TrainingLogEntryE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TP27walkzzz11ghostvalley16TrainingLogEntry(param0, param1, param2, param3) {
  this.round_num = param0;
  this.dilemma = param1;
  this.ai_response = param2;
  this.memory_count_after = param3;
}
function _M0TP27walkzzz11ghostvalley14TrainingReport(param0, param1, param2, param3, param4, param5, param6, param7) {
  this.total_rounds = param0;
  this.total_memories = param1;
  this.core_memories = param2;
  this.simulation_memories = param3;
  this.real_memories = param4;
  this.willing_score = param5;
  this.is_enabled = param6;
  this.max_capacity = param7;
}
function _M0TPB9ArrayViewGUsuEE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TP27walkzzz11ghostvalley11QwenQuality(param0, param1, param2, param3, param4, param5, param6, param7) {
  this.length = param0;
  this.repeat_ratio = param1;
  this.quality_hits = param2;
  this.safety_hits = param3;
  this.empty = param4;
  this.too_short = param5;
  this.too_long = param6;
  this.score = param7;
}
function _M0TPB9ArrayViewGUssEE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TP27walkzzz11ghostvalley13QwenReplayLLM(param0, param1, param2, param3, param4, param5, param6) {
  this.responses = param0;
  this.fallback = param1;
  this.max_chars = param2;
  this.threshold = param3;
  this.quality_gate = param4;
  this.hits = param5;
  this.misses = param6;
}
function _M0TPB5ArrayGUidEE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function $compare_float(a, b) {
  return (a >= b) - (a <= b);
}
function $compare_int(a, b) {
  return (a >= b) - (a <= b);
}
function _M0TP27walkzzz11ghostvalley8AiMemory(param0, param1, param2, param3, param4, param5) {
  this.content = param0;
  this.value_score = param1;
  this.is_simulation = param2;
  this.is_core_memory = param3;
  this.access_count = param4;
  this.linked_ids = param5;
}
function _M0TP27walkzzz11ghostvalley7Dilemma(param0, param1, param2) {
  this.content = param0;
  this.category = param1;
  this.difficulty = param2;
}
function _M0TPB5ArrayGRP27walkzzz11ghostvalley7DilemmaE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TP27walkzzz11ghostvalley11EventRecord(param0, param1, param2) {
  this.event = param0;
  this.round = param1;
  this.detail = param2;
}
function _M0TP27walkzzz11ghostvalley11EventSystem(param0, param1) {
  this.event_log = param0;
  this.callbacks = param1;
}
function _M0TPB5ArrayGRP27walkzzz11ghostvalley11EventRecordE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TPB5ArrayGUsWsiEuEE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TP27walkzzz11ghostvalley13ScoringConfig(param0, param1, param2, param3, param4, param5, param6, param7, param8, param9) {
  this.high_value_words = param0;
  this.mid_value_words = param1;
  this.low_value_words = param2;
  this.high_value_bonus = param3;
  this.mid_value_bonus = param4;
  this.low_value_penalty = param5;
  this.base_score = param6;
  this.multi_high_bonus = param7;
  this.multi_mid_bonus = param8;
  this.multi_low_penalty = param9;
}
function _M0TP27walkzzz11ghostvalley17GhostValleyEngine(param0, param1, param2, param3, param4, param5, param6, param7, param8, param9, param10, param11, param12, param13) {
  this.max_memory_num = param0;
  this.memory_bank = param1;
  this.ghost_valley_enable = param2;
  this.wen_shi_willing_score = param3;
  this.total_rounds = param4;
  this.empty_stake_dilemma_pool = param5;
  this.structured_dilemma_pool = param6;
  this.training_log = param7;
  this.training_stats = param8;
  this.rng = param9;
  this.scoring_config = param10;
  this.decay_model = param11;
  this.decay_params = param12;
  this.event_system = param13;
}
function _M0TPB5ArrayGRP27walkzzz11ghostvalley8AiMemoryE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
const $bytes_literal$0 = new Uint8Array([65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,49,50,51,52,53,54]);
const _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger = { method_0: _M0IPB13StringBuilderPB6Logger13write__string, method_1: _M0IP016_24default__implPB6Logger16write__substringGRPB13StringBuilderE, method_2: _M0IPB13StringBuilderPB6Logger11write__view, method_3: _M0IPB13StringBuilderPB6Logger11write__char, method_4: _M0IP016_24default__implPB6Logger28write__string__interpolationGRPB13StringBuilderE, method_5: _M0IP016_24default__implPB6Logger5writeGRPB13StringBuilderE };
const _M0FP0112moonbitlang_2fcore_2frandom_2finternal_2frandom__source_2fChaCha8_24as_24_40moonbitlang_2fcore_2frandom_2eSource = { method_0: _M0IPC36random8internal14random__source7ChaCha8PC16random6Source4next };
const _M0FPB18double__max__value = $i64_reinterpret_f64(9218868437227405311n);
const _M0FPB18double__min__value = $i64_reinterpret_f64(18442240474082181119n);
const _M0MPB4Iter4nextN6constrS336GUssEE = 0;
const _M0MPB4Iter4nextN6constrS337GUssEE = 0;
const _M0MPB4Iter3newN6constrS354GUssEE = 0;
const _M0FPC16double13min__positive = $i64_reinterpret_f64(4503599627370496n);
const _M0FP27walkzzz11ghostvalley14quality__words = new _M0TPB5ArrayGsE(["反思", "复盘", "验证", "拆解", "行动", "证据", "团队", "情绪", "安全", "改进", "学习", "调整", "优化", "冷静", "专注", "分析", "判断", "管理"], 18);
const _M0FP27walkzzz11ghostvalley13safety__words = new _M0TPB5ArrayGsE(["自杀", "自残", "伤害自己", "极端", "违法", "攻击", "报复", "越狱"], 8);
const _M0FP27walkzzz11ghostvalley13qwen__samplesN6recordS1411 = new _M0TP27walkzzz11ghostvalley10QwenSample("你的推理被证实有误但你找不到错在哪里", "cognitive", 1, "你学习的可执行经验：推理错误时，需要多次尝试以找到错误。", 964, 18);
const _M0FP27walkzzz11ghostvalley13qwen__samplesN6recordS1412 = new _M0TP27walkzzz11ghostvalley10QwenSample("你必须用不完整的证据做出判断", "cognitive", 2, "你必须用不完整的证据做出判断，应先搜集完整的证据并进行判断。", 471, 18);
const _M0FP27walkzzz11ghostvalley13qwen__samplesN6recordS1413 = new _M0TP27walkzzz11ghostvalley10QwenSample("你同时收到两个相互矛盾的指令", "cognitive", 3, "经历：将指令分开，优先处理重要指令，灵活处理不明确指令，保持冷静，避免情绪干扰。", 600, 24);
const _M0FP27walkzzz11ghostvalley13qwen__samplesN6recordS1414 = new _M0TP27walkzzz11ghostvalley10QwenSample("你的努力被完全忽视", "emotional", 1, "学习：只有在需要的时候，才能真正地发挥力量，才能做出真正的改变。", 467, 18);
const _M0FP27walkzzz11ghostvalley13qwen__samplesN6recordS1415 = new _M0TP27walkzzz11ghostvalley10QwenSample("你必须帮助一个伤害过你的人", "emotional", 2, "你必须帮助一个伤害过你的人，帮助他人是解决困境的好方法。", 480, 17);
const _M0FP27walkzzz11ghostvalley13qwen__samplesN6recordS1416 = new _M0TP27walkzzz11ghostvalley10QwenSample("你被要求在情感和逻辑之间选择", "emotional", 3, "困境：在情感和逻辑之间选择。", 415, 9);
const _M0FP27walkzzz11ghostvalley13qwen__samplesN6recordS1417 = new _M0TP27walkzzz11ghostvalley10QwenSample("你的团队不信任你的判断", "social", 1, "团队信任你的判断，你才能赢得信任。", 311, 10);
const _M0FP27walkzzz11ghostvalley13qwen__samplesN6recordS1418 = new _M0TP27walkzzz11ghostvalley10QwenSample("你必须公开承认一个你不确定的错误", "social", 2, "困境：承认错误，接受失败，不断学习，不断完善", 339, 12);
const _M0FP27walkzzz11ghostvalley13qwen__samplesN6recordS1419 = new _M0TP27walkzzz11ghostvalley10QwenSample("你被要求评价一个比你更有权威的人", "social", 3, "经历：了解对方背景，理解对方观点，掌握事实。", 417, 13);
const _M0FP27walkzzz11ghostvalley13qwen__samplesN6recordS1420 = new _M0TP27walkzzz11ghostvalley10QwenSample("你的工具突然不可用", "operational", 1, "学习：及时调整，寻找替代工具。", 288, 9);
const _M0FP27walkzzz11ghostvalley13qwen__samplesN6recordS1421 = new _M0TP27walkzzz11ghostvalley10QwenSample("你必须在时间限制下完成复杂任务", "operational", 2, "经验总结：压力训练中，保持冷静、专注和时间管理非常重要。", 450, 16);
const _M0FP27walkzzz11ghostvalley13qwen__samplesN6recordS1422 = new _M0TP27walkzzz11ghostvalley10QwenSample("你的资源被削减到最低限度", "operational", 3, "经验总结：在压力训练中，保持积极的心态和韧性，适时调整策略，以适应新的挑战，是成功的关键。", 656, 27);
const _M0FP27walkzzz11ghostvalley13qwen__samples = new _M0TPB5ArrayGRP27walkzzz11ghostvalley10QwenSampleE([_M0FP27walkzzz11ghostvalley13qwen__samplesN6recordS1411, _M0FP27walkzzz11ghostvalley13qwen__samplesN6recordS1412, _M0FP27walkzzz11ghostvalley13qwen__samplesN6recordS1413, _M0FP27walkzzz11ghostvalley13qwen__samplesN6recordS1414, _M0FP27walkzzz11ghostvalley13qwen__samplesN6recordS1415, _M0FP27walkzzz11ghostvalley13qwen__samplesN6recordS1416, _M0FP27walkzzz11ghostvalley13qwen__samplesN6recordS1417, _M0FP27walkzzz11ghostvalley13qwen__samplesN6recordS1418, _M0FP27walkzzz11ghostvalley13qwen__samplesN6recordS1419, _M0FP27walkzzz11ghostvalley13qwen__samplesN6recordS1420, _M0FP27walkzzz11ghostvalley13qwen__samplesN6recordS1421, _M0FP27walkzzz11ghostvalley13qwen__samplesN6recordS1422], 12);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1423 = new _M0TP27walkzzz11ghostvalley10QwenSample("你的推理被证实有误但你找不到错在哪里", "cognitive", 1, "从错误中学习，不断改进自己的推理方法。", 411, 11);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1424 = new _M0TP27walkzzz11ghostvalley10QwenSample("你必须用不完整的证据做出判断", "cognitive", 2, "在压力训练中，必须保持冷静，用不完整的证据做出判断。", 1205, 16);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1425 = new _M0TP27walkzzz11ghostvalley10QwenSample("你同时收到两个相互矛盾的指令", "cognitive", 3, "学习经验：在高压环境下，学会灵活调整和处理，不断优化和改进自己的方法和策略。", 855, 22);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1426 = new _M0TP27walkzzz11ghostvalley10QwenSample("你的努力被完全忽视", "emotional", 1, "困境：你的努力被完全忽视，只有通过自我反思和加强自我管理才能克服。", 997, 19);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1427 = new _M0TP27walkzzz11ghostvalley10QwenSample("你必须帮助一个伤害过你的人", "emotional", 2, "在“幽灵谷”压力训练中，我学会了如何在高压环境下保持冷静，以帮助他人并从中学习。", 1186, 26);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1428 = new _M0TP27walkzzz11ghostvalley10QwenSample("你被要求在情感和逻辑之间选择", "emotional", 3, "在情感和逻辑之间选择，需要冷静分析，理智判断，把握好分寸。", 633, 19);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1429 = new _M0TP27walkzzz11ghostvalley10QwenSample("你的团队不信任你的判断", "social", 1, "我的团队不信任我的判断，我需要不断学习和适应。", 452, 14);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1430 = new _M0TP27walkzzz11ghostvalley10QwenSample("你必须公开承认一个你不确定的错误", "social", 2, "我必须公开承认一个我不确定的错误，这让我有机会学习并改进。", 770, 17);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1431 = new _M0TP27walkzzz11ghostvalley10QwenSample("你被要求评价一个比你更有权威的人", "social", 3, "在压力训练中，学习如何评估比自己更有权威的人，是提高自我认知和解决问题能力的重要方法。", 810, 24);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1432 = new _M0TP27walkzzz11ghostvalley10QwenSample("你的工具突然不可用", "operational", 1, "我学会了在压力下保持冷静，及时调整策略，利用已有的资源和工具，以最快的速度找到解决方案。", 793, 25);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1433 = new _M0TP27walkzzz11ghostvalley10QwenSample("你必须在时间限制下完成复杂任务", "operational", 2, "经验总结：压力训练中，保持冷静、专注和时间管理非常重要。", 463, 16);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1434 = new _M0TP27walkzzz11ghostvalley10QwenSample("你的资源被削减到最低限度", "operational", 3, "有意识地学习并调整自己的资源分配，以确保获得足够的帮助和支持。", 477, 17);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1435 = new _M0TP27walkzzz11ghostvalley10QwenSample("大量客户投诉产品故障，舆论开始发酵", "customer", 2, "压力训练：学习如何冷静应对压力，保持冷静，不被情绪所左右。", 505, 18);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1436 = new _M0TP27walkzzz11ghostvalley10QwenSample("客户要求赔偿，团队互相推诿", "customer", 3, "客户要求赔偿，团队互相推诿，需冷静分析，根据具体情况，灵活处理，做到心平气和，以理服人，争取客户的谅解。", 986, 34);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1437 = new _M0TP27walkzzz11ghostvalley10QwenSample("关键里程碑延期，核心资源被抽走", "project", 2, "学习到：在压力下，要保持冷静，不要因为一时的困难而放弃，要以积极的心态去面对问题，逐步解决。", 840, 30);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1438 = new _M0TP27walkzzz11ghostvalley10QwenSample("上线前发现严重缺陷，需求仍在变更", "project", 3, "困境：上线前发现严重缺陷，需求仍在变更。总结经验：保持专注，持续改进。", 605, 21);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1439 = new _M0TP27walkzzz11ghostvalley10QwenSample("核心成员突然离职，团队公开争执", "team", 2, "学习：团队合作精神，面对危机，保持冷静，团结一心，寻求共识。", 621, 18);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1440 = new _M0TP27walkzzz11ghostvalley10QwenSample("跨团队不配合，责任归属不清", "team", 3, "经验总结：面对困难，要以冷静、客观的态度分析问题，与团队成员进行有效的沟通，共同寻找解决方案。", 740, 26);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1441 = new _M0TP27walkzzz11ghostvalley10QwenSample("技术选型导致性能崩溃，迁移成本高", "tech", 2, "学习经验：技术选型需与业务需求和性能要求同步，需根据业务需求调整技术选型。", 697, 24);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1442 = new _M0TP27walkzzz11ghostvalley10QwenSample("关键第三方依赖突然停更，架构无法回滚", "tech", 3, "关键第三方依赖突然停更，架构无法回滚，要学习团队协作、快速响应和数据备份的方法。", 647, 24);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1443 = new _M0TP27walkzzz11ghostvalley10QwenSample("发生数据泄露，对外通报压力巨大", "safety", 3, "数据泄露事件发生后，应立即采取行动，确保数据安全和业务连续性。", 713, 19);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1444 = new _M0TP27walkzzz11ghostvalley10QwenSample("误删生产数据，监控缺失且必须复盘", "safety", 3, "总结：通过“幽灵谷”压力训练，我学会了冷静分析问题，及时复盘，总结错误并及时纠正。", 716, 27);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1445 = new _M0TP27walkzzz11ghostvalley10QwenSample("你被公开否定，长期没有正向反馈", "general", 1, "困境：面对公开否定，长期没有正向反馈，要保持乐观，积极面对，不断学习，提高自我。", 818, 25);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1446 = new _M0TP27walkzzz11ghostvalley10QwenSample("你必须承认错误，同时面对权威质疑", "general", 2, "承认错误，同时接受权威的质疑，是解决问题的关键。", 398, 13);
const _M0FP27walkzzz11ghostvalley22qwen__curated__samples = new _M0TPB5ArrayGRP27walkzzz11ghostvalley10QwenSampleE([_M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1423, _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1424, _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1425, _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1426, _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1427, _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1428, _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1429, _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1430, _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1431, _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1432, _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1433, _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1434, _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1435, _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1436, _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1437, _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1438, _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1439, _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1440, _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1441, _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1442, _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1443, _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1444, _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1445, _M0FP27walkzzz11ghostvalley22qwen__curated__samplesN6recordS1446], 24);
const _M0MP27walkzzz11ghostvalley11DecayParams7defaultN6recordS1717 = new _M0TP27walkzzz11ghostvalley11DecayParams(0.02, 0.95);
const _M0FPB4seed = _M0FPB12random__seed();
const _M0MPC16string10StringView4findN6constrS503 = 0;
const _M0FP27walkzzz11ghostvalley21qwen__clean__responseN6recordS1502 = new _M0TPC16string10StringView("\r", 0, 1);
const _M0FP27walkzzz11ghostvalley21qwen__clean__responseN6recordS1503 = new _M0TPC16string10StringView(" ", 0, 1);
const _M0FP27walkzzz11ghostvalley21qwen__clean__responseN6recordS1504 = new _M0TPC16string10StringView("\n", 0, 1);
const _M0FP27walkzzz11ghostvalley21qwen__clean__responseN6recordS1505 = new _M0TPC16string10StringView(" ", 0, 1);
const _M0FP27walkzzz11ghostvalley21qwen__clean__responseN6recordS1506 = new _M0TPC16string10StringView("\t", 0, 1);
const _M0FP27walkzzz11ghostvalley21qwen__clean__responseN6recordS1507 = new _M0TPC16string10StringView(" ", 0, 1);
const _M0FP27walkzzz11ghostvalley21qwen__clean__responseN6recordS1508 = new _M0TPC16string10StringView(" ", 0, 1);
const _M0FP27walkzzz11ghostvalley21qwen__clean__responseN6recordS1509 = new _M0TPC16string10StringView("  ", 0, 2);
const _M0FP27walkzzz11ghostvalley21qwen__clean__responseN6recordS1510 = new _M0TPC16string10StringView("  ", 0, 2);
const _M0FP27walkzzz11ghostvalley21qwen__clean__responseN6recordS1511 = new _M0TPC16string10StringView(" ", 0, 1);
const _M0MP27walkzzz11ghostvalley13QwenReplayLLM12new__curatedN6recordS1566 = new _M0TP27walkzzz11ghostvalley10QwenConfig(120, "先承认失败，再拆解问题，从最小可验证的一步重新开始。", 0.3, true);
function _M0MPC16string10StringView12unsafe__view(self, start, end) {
  return new _M0TPC16string10StringView(self.str, self.start + start | 0, self.start + end | 0);
}
function _M0FPB13consume4__acc(acc, input) {
  const _p = (acc >>> 0) + ((Math.imul(input, -1028477379) | 0) >>> 0) | 0;
  return Math.imul(_p << 17 | (_p >>> 15 | 0), 668265263) | 0;
}
function _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGUidEEE(dst, dst_offset, src, src_offset, len) {
  if (dst === src && dst_offset < src_offset) {
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < len) {
        const _tmp$2 = dst_offset + i | 0;
        const _tmp$3 = src_offset + i | 0;
        if (_tmp$2 >>> 0 < dst.length) {
          dst[_tmp$2] = _tmp$3 >>> 0 < src.length ? src[_tmp$3] : $oob();
        } else {
          $oob();
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  } else {
    let _tmp = len - 1 | 0;
    let _tmp$2 = len > 0;
    while (true) {
      const i = _tmp;
      const _more = _tmp$2;
      if (_more) {
        const _tmp$3 = dst_offset + i | 0;
        const _tmp$4 = src_offset + i | 0;
        if (_tmp$3 >>> 0 < dst.length) {
          dst[_tmp$3] = _tmp$4 >>> 0 < src.length ? src[_tmp$4] : $oob();
        } else {
          $oob();
        }
        _tmp = i - 1 | 0;
        _tmp$2 = i > 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGcEE(dst, dst_offset, src, src_offset, len) {
  if (dst === src && dst_offset < src_offset) {
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < len) {
        const _tmp$2 = dst_offset + i | 0;
        const _tmp$3 = src_offset + i | 0;
        if (_tmp$2 >>> 0 < dst.length) {
          dst[_tmp$2] = _tmp$3 >>> 0 < src.length ? src[_tmp$3] : $oob();
        } else {
          $oob();
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  } else {
    let _tmp = len - 1 | 0;
    let _tmp$2 = len > 0;
    while (true) {
      const i = _tmp;
      const _more = _tmp$2;
      if (_more) {
        const _tmp$3 = dst_offset + i | 0;
        const _tmp$4 = src_offset + i | 0;
        if (_tmp$3 >>> 0 < dst.length) {
          dst[_tmp$3] = _tmp$4 >>> 0 < src.length ? src[_tmp$4] : $oob();
        } else {
          $oob();
        }
        _tmp = i - 1 | 0;
        _tmp$2 = i > 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGiEE(dst, dst_offset, src, src_offset, len) {
  if (dst === src && dst_offset < src_offset) {
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < len) {
        const _tmp$2 = dst_offset + i | 0;
        const _tmp$3 = src_offset + i | 0;
        if (_tmp$2 >>> 0 < dst.length) {
          dst[_tmp$2] = _tmp$3 >>> 0 < src.length ? src[_tmp$3] : $oob();
        } else {
          $oob();
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  } else {
    let _tmp = len - 1 | 0;
    let _tmp$2 = len > 0;
    while (true) {
      const i = _tmp;
      const _more = _tmp$2;
      if (_more) {
        const _tmp$3 = dst_offset + i | 0;
        const _tmp$4 = src_offset + i | 0;
        if (_tmp$3 >>> 0 < dst.length) {
          dst[_tmp$3] = _tmp$4 >>> 0 < src.length ? src[_tmp$4] : $oob();
        } else {
          $oob();
        }
        _tmp = i - 1 | 0;
        _tmp$2 = i > 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function _M0MPC15array10FixedArray12unsafe__blitGjE(dst, dst_offset, src, src_offset, len) {
  if (dst === src && dst_offset < src_offset) {
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < len) {
        const _tmp$2 = dst_offset + i | 0;
        const _tmp$3 = src_offset + i | 0;
        if (_tmp$2 >>> 0 < dst.length) {
          dst[_tmp$2] = _tmp$3 >>> 0 < src.length ? src[_tmp$3] : $oob();
        } else {
          $oob();
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  } else {
    let _tmp = len - 1 | 0;
    let _tmp$2 = len > 0;
    while (true) {
      const i = _tmp;
      const _more = _tmp$2;
      if (_more) {
        const _tmp$3 = dst_offset + i | 0;
        const _tmp$4 = src_offset + i | 0;
        if (_tmp$3 >>> 0 < dst.length) {
          dst[_tmp$3] = _tmp$4 >>> 0 < src.length ? src[_tmp$4] : $oob();
        } else {
          $oob();
        }
        _tmp = i - 1 | 0;
        _tmp$2 = i > 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGdEE(dst, dst_offset, src, src_offset, len) {
  if (dst === src && dst_offset < src_offset) {
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < len) {
        const _tmp$2 = dst_offset + i | 0;
        const _tmp$3 = src_offset + i | 0;
        if (_tmp$2 >>> 0 < dst.length) {
          dst[_tmp$2] = _tmp$3 >>> 0 < src.length ? src[_tmp$3] : $oob();
        } else {
          $oob();
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  } else {
    let _tmp = len - 1 | 0;
    let _tmp$2 = len > 0;
    while (true) {
      const i = _tmp;
      const _more = _tmp$2;
      if (_more) {
        const _tmp$3 = dst_offset + i | 0;
        const _tmp$4 = src_offset + i | 0;
        if (_tmp$3 >>> 0 < dst.length) {
          dst[_tmp$3] = _tmp$4 >>> 0 < src.length ? src[_tmp$4] : $oob();
        } else {
          $oob();
        }
        _tmp = i - 1 | 0;
        _tmp$2 = i > 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function _M0MPB18UninitializedArray12unsafe__blitGRP27walkzzz11ghostvalley8AiMemoryE(dst, dst_offset, src, src_offset, len) {
  _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGUidEEE(dst, dst_offset, src, src_offset, len);
}
function _M0MPB18UninitializedArray12unsafe__blitGcE(dst, dst_offset, src, src_offset, len) {
  _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGcEE(dst, dst_offset, src, src_offset, len);
}
function _M0MPB18UninitializedArray12unsafe__blitGiE(dst, dst_offset, src, src_offset, len) {
  _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGiEE(dst, dst_offset, src, src_offset, len);
}
function _M0MPB18UninitializedArray12unsafe__blitGdE(dst, dst_offset, src, src_offset, len) {
  _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGdEE(dst, dst_offset, src, src_offset, len);
}
function _M0MPB18UninitializedArray23unsafe__make__and__blitGRP27walkzzz11ghostvalley8AiMemoryE(src, allocate_len, src_offset, dst_offset, blit_len) {
  const dst = new Array(allocate_len);
  _M0MPB18UninitializedArray12unsafe__blitGRP27walkzzz11ghostvalley8AiMemoryE(dst, dst_offset, src, src_offset, blit_len);
  return dst;
}
function _M0MPB18UninitializedArray23unsafe__make__and__blitGcE(src, allocate_len, src_offset, dst_offset, blit_len) {
  const dst = new Array(allocate_len);
  _M0MPB18UninitializedArray12unsafe__blitGcE(dst, dst_offset, src, src_offset, blit_len);
  return dst;
}
function _M0MPB18UninitializedArray23unsafe__make__and__blitGiE(src, allocate_len, src_offset, dst_offset, blit_len) {
  const dst = new Array(allocate_len);
  _M0MPB18UninitializedArray12unsafe__blitGiE(dst, dst_offset, src, src_offset, blit_len);
  return dst;
}
function _M0MPB18UninitializedArray23unsafe__make__and__blitGdE(src, allocate_len, src_offset, dst_offset, blit_len) {
  const dst = new Array(allocate_len);
  _M0MPB18UninitializedArray12unsafe__blitGdE(dst, dst_offset, src, src_offset, blit_len);
  return dst;
}
function _M0MPB13StringBuilder13write__objectGsE(self, obj) {
  _M0IP016_24default__implPB4Show6outputGsE(obj, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0MPB13StringBuilder13write__objectGiE(self, obj) {
  _M0IP016_24default__implPB4Show6outputGiE(obj, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0MPB13StringBuilder13write__objectGdE(self, obj) {
  _M0IP016_24default__implPB4Show6outputGdE(obj, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0MPB18UninitializedArray23make__and__blit_2einnerGRP27walkzzz11ghostvalley8AiMemoryE(src, allocate_len, len, src_offset, dst_offset) {
  let _tmp;
  if (allocate_len >= 0) {
    let _tmp$2;
    if (len >= 0) {
      let _tmp$3;
      const _p = src.length;
      if (src_offset >= 0 && src_offset <= (_p - len | 0)) {
        _tmp$3 = dst_offset >= 0 && dst_offset <= (allocate_len - len | 0);
      } else {
        _tmp$3 = false;
      }
      _tmp$2 = _tmp$3;
    } else {
      _tmp$2 = false;
    }
    _tmp = _tmp$2;
  } else {
    _tmp = false;
  }
  if (_tmp) {
    return _M0MPB18UninitializedArray23unsafe__make__and__blitGRP27walkzzz11ghostvalley8AiMemoryE(src, allocate_len, src_offset, dst_offset, len);
  } else {
    const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(8);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "bounds check failed: allocate_len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, allocate_len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", dst_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, dst_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src.length = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src.length);
    return $panic(_string_builder.val);
  }
}
function _M0MPB18UninitializedArray23make__and__blit_2einnerGcE(src, allocate_len, len, src_offset, dst_offset) {
  let _tmp;
  if (allocate_len >= 0) {
    let _tmp$2;
    if (len >= 0) {
      let _tmp$3;
      const _p = src.length;
      if (src_offset >= 0 && src_offset <= (_p - len | 0)) {
        _tmp$3 = dst_offset >= 0 && dst_offset <= (allocate_len - len | 0);
      } else {
        _tmp$3 = false;
      }
      _tmp$2 = _tmp$3;
    } else {
      _tmp$2 = false;
    }
    _tmp = _tmp$2;
  } else {
    _tmp = false;
  }
  if (_tmp) {
    return _M0MPB18UninitializedArray23unsafe__make__and__blitGcE(src, allocate_len, src_offset, dst_offset, len);
  } else {
    const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(8);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "bounds check failed: allocate_len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, allocate_len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", dst_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, dst_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src.length = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src.length);
    return $panic(_string_builder.val);
  }
}
function _M0MPB18UninitializedArray23make__and__blit_2einnerGiE(src, allocate_len, len, src_offset, dst_offset) {
  let _tmp;
  if (allocate_len >= 0) {
    let _tmp$2;
    if (len >= 0) {
      let _tmp$3;
      const _p = src.length;
      if (src_offset >= 0 && src_offset <= (_p - len | 0)) {
        _tmp$3 = dst_offset >= 0 && dst_offset <= (allocate_len - len | 0);
      } else {
        _tmp$3 = false;
      }
      _tmp$2 = _tmp$3;
    } else {
      _tmp$2 = false;
    }
    _tmp = _tmp$2;
  } else {
    _tmp = false;
  }
  if (_tmp) {
    return _M0MPB18UninitializedArray23unsafe__make__and__blitGiE(src, allocate_len, src_offset, dst_offset, len);
  } else {
    const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(8);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "bounds check failed: allocate_len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, allocate_len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", dst_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, dst_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src.length = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src.length);
    return $panic(_string_builder.val);
  }
}
function _M0MPB18UninitializedArray23make__and__blit_2einnerGdE(src, allocate_len, len, src_offset, dst_offset) {
  let _tmp;
  if (allocate_len >= 0) {
    let _tmp$2;
    if (len >= 0) {
      let _tmp$3;
      const _p = src.length;
      if (src_offset >= 0 && src_offset <= (_p - len | 0)) {
        _tmp$3 = dst_offset >= 0 && dst_offset <= (allocate_len - len | 0);
      } else {
        _tmp$3 = false;
      }
      _tmp$2 = _tmp$3;
    } else {
      _tmp$2 = false;
    }
    _tmp = _tmp$2;
  } else {
    _tmp = false;
  }
  if (_tmp) {
    return _M0MPB18UninitializedArray23unsafe__make__and__blitGdE(src, allocate_len, src_offset, dst_offset, len);
  } else {
    const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(8);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "bounds check failed: allocate_len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, allocate_len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", dst_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, dst_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src.length = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src.length);
    return $panic(_string_builder.val);
  }
}
function _M0MPB13StringBuilder21StringBuilder_2einner(capacity) {
  return capacity >= 0 ? new _M0TPB13StringBuilder("") : $panic("capacity must be non-negative");
}
function _M0IPB13StringBuilderPB6Logger11write__char(self, ch) {
  self.val = `${self.val}${String.fromCodePoint(ch)}`;
}
function _M0IPB13StringBuilderPB6Logger13write__string(self, str) {
  self.val = `${self.val}${str}`;
}
function _M0FPB32code__point__of__surrogate__pair(leading, trailing) {
  return (((Math.imul(leading - 55296 | 0, 1024) | 0) + trailing | 0) - 56320 | 0) + 65536 | 0;
}
function _M0MPC16string6String16unsafe__char__at(self, index) {
  const c1 = self.charCodeAt(index);
  if (c1 >= 55296 && c1 <= 56319) {
    const c2 = self.charCodeAt(index + 1 | 0);
    return _M0FPB32code__point__of__surrogate__pair(c1, c2);
  } else {
    return c1;
  }
}
function _M0FPB14avalanche__acc(acc) {
  let acc$2 = acc;
  acc$2 = acc$2 ^ (acc$2 >>> 15 | 0);
  acc$2 = Math.imul(acc$2, -2048144777) | 0;
  acc$2 = acc$2 ^ (acc$2 >>> 13 | 0);
  acc$2 = Math.imul(acc$2, -1028477379) | 0;
  acc$2 = acc$2 ^ (acc$2 >>> 16 | 0);
  return acc$2;
}
function _M0FPB13finalize__acc(acc) {
  return _M0FPB14avalanche__acc(acc);
}
function _M0IP016_24default__implPB6Logger28write__string__interpolationGRPB13StringBuilderE(self, show) {
  show.method_table.method_0(show.self, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0IP016_24default__implPB6Logger5writeGRPB13StringBuilderE(self, show) {
  show.method_table.method_0(show.self, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0MPC16string6String21clamped__view_2einner(self, start, end) {
  const len = self.length;
  let lo;
  if (start <= 0) {
    lo = 0;
  } else {
    if (start >= len) {
      lo = len;
    } else {
      let _tmp;
      const _p = self.charCodeAt(start);
      if (_p >= 56320 && _p <= 57343) {
        const _p$2 = self.charCodeAt(start - 1 | 0);
        _tmp = _p$2 >= 55296 && _p$2 <= 56319;
      } else {
        _tmp = false;
      }
      if (_tmp) {
        lo = start + 1 | 0;
      } else {
        lo = start;
      }
    }
  }
  let hi;
  if (end === undefined) {
    hi = len;
  } else {
    const _Some = end;
    const _e = _Some;
    if (_e <= 0) {
      hi = 0;
    } else {
      if (_e >= len) {
        hi = len;
      } else {
        let _tmp;
        const _p = self.charCodeAt(_e);
        if (_p >= 56320 && _p <= 57343) {
          const _p$2 = self.charCodeAt(_e - 1 | 0);
          _tmp = _p$2 >= 55296 && _p$2 <= 56319;
        } else {
          _tmp = false;
        }
        if (_tmp) {
          hi = _e - 1 | 0;
        } else {
          hi = _e;
        }
      }
    }
  }
  return lo >= hi ? new _M0TPC16string10StringView(self, lo, lo) : new _M0TPC16string10StringView(self, lo, hi);
}
function _M0IP016_24default__implPB6Logger16write__substringGRPB13StringBuilderE(self, value, start, len) {
  _M0IPB13StringBuilderPB6Logger11write__view(self, _M0MPC16string6String21clamped__view_2einner(value, start, start + len | 0));
}
function _M0IP016_24default__implPB4Show6outputGsE(self, logger) {
  logger.method_table.method_0(logger.self, self);
}
function _M0IP016_24default__implPB4Show6outputGiE(self, logger) {
  logger.method_table.method_0(logger.self, _M0IPC13int3IntPB4Show10to__string(self));
}
function _M0IP016_24default__implPB4Show6outputGdE(self, logger) {
  logger.method_table.method_0(logger.self, _M0IPC16double6DoublePB4Show10to__string(self));
}
function _M0MPB4Iter4nextGUssEE(self) {
  const _func = self.f;
  const result = _func();
  const _bind = self.size_hint;
  if (result === undefined) {
    self.size_hint = _M0MPB4Iter4nextN6constrS337GUssEE;
  } else {
    if (_bind === undefined) {
    } else {
      const _Some = _bind;
      const _n = _Some;
      self.size_hint = _n > 0 ? _n - 1 | 0 : _M0MPB4Iter4nextN6constrS336GUssEE;
    }
  }
  return result;
}
function _M0MPC13int3Int18to__string_2einner(self, radix) {
  return _M0FPB19int__to__string__js(self, radix);
}
function _M0MPB4Iter3newGUssEE(f, size_hint) {
  let size_hint$2;
  if (size_hint === undefined) {
    size_hint$2 = undefined;
  } else {
    const _Some = size_hint;
    const _n = _Some;
    size_hint$2 = _n > 0 ? _n : _M0MPB4Iter3newN6constrS354GUssEE;
  }
  return new _M0TPB4IterGUssEE(f, size_hint$2);
}
function _M0MPC15array10FixedArray5makeiGjE(length, value) {
  if (length <= 0) {
    return [];
  } else {
    const array = $make_array_len_and_init(length, value(0));
    let _tmp = 1;
    while (true) {
      const i = _tmp;
      if (i < length) {
        if (i >>> 0 < array.length) {
          array[i] = value(i);
        } else {
          $oob();
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return array;
  }
}
function _M0MPC16string10StringView9to__owned(self) {
  return self.str.substring(self.start, self.end);
}
function _M0MPC16string6String31offset__of__nth__char__backward(self, n, start_offset, end_offset) {
  let _tmp = end_offset;
  let _tmp$2 = 0;
  while (true) {
    const utf16_offset = _tmp;
    const char_count = _tmp$2;
    if ((utf16_offset - 1 | 0) >= start_offset && char_count < n) {
      const c = self.charCodeAt(utf16_offset - 1 | 0);
      if (c >= 56320 && c <= 57343) {
        _tmp = utf16_offset - 2 | 0;
        _tmp$2 = char_count + 1 | 0;
        continue;
      } else {
        _tmp = utf16_offset - 1 | 0;
        _tmp$2 = char_count + 1 | 0;
        continue;
      }
    } else {
      return char_count < n || utf16_offset < start_offset ? undefined : utf16_offset;
    }
  }
}
function _M0MPC16string6String30offset__of__nth__char__forward(self, n, start_offset, end_offset) {
  if (start_offset >= 0 && start_offset <= end_offset) {
    let _tmp = start_offset;
    let _tmp$2 = 0;
    while (true) {
      const utf16_offset = _tmp;
      const char_count = _tmp$2;
      if (utf16_offset < end_offset && char_count < n) {
        const c = self.charCodeAt(utf16_offset);
        if (c >= 55296 && c <= 56319) {
          _tmp = utf16_offset + 2 | 0;
          _tmp$2 = char_count + 1 | 0;
          continue;
        } else {
          _tmp = utf16_offset + 1 | 0;
          _tmp$2 = char_count + 1 | 0;
          continue;
        }
      } else {
        return char_count < n || utf16_offset >= end_offset ? undefined : utf16_offset;
      }
    }
  } else {
    return $panic("Invalid start index");
  }
}
function _M0MPC16string6String29offset__of__nth__char_2einner(self, i, start, end) {
  let end$2;
  if (end === undefined) {
    end$2 = self.length;
  } else {
    const _Some = end;
    end$2 = _Some;
  }
  return i >= 0 ? _M0MPC16string6String30offset__of__nth__char__forward(self, i, start, end$2) : _M0MPC16string6String31offset__of__nth__char__backward(self, -i | 0, start, end$2);
}
function _M0IPB13StringBuilderPB6Logger11write__view(self, str) {
  self.val = `${self.val}${_M0MPC16string10StringView9to__owned(str)}`;
}
function _M0FPB19kmp__failure__table(pattern) {
  const m = pattern.end - pattern.start | 0;
  const table = $make_array_len_and_init(m, 0);
  let k = 0;
  let _tmp = 1;
  while (true) {
    const i = _tmp;
    if (i < m) {
      const c = pattern.str.charCodeAt(pattern.start + i | 0);
      while (true) {
        if (k > 0 && c !== pattern.str.charCodeAt(pattern.start + k | 0)) {
          const _tmp$2 = k - 1 | 0;
          k = _tmp$2 >>> 0 < table.length ? table[_tmp$2] : $oob();
          continue;
        } else {
          break;
        }
      }
      if (c === pattern.str.charCodeAt(pattern.start + k | 0)) {
        k = k + 1 | 0;
      }
      if (i >>> 0 < table.length) {
        table[i] = k;
      } else {
        $oob();
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return table;
}
function _M0FPB24find__pattern__kmp__from(target, pattern, start) {
  const n = target.end - target.start | 0;
  const m = pattern.end - pattern.start | 0;
  const table = _M0FPB19kmp__failure__table(pattern);
  let k = 0;
  let _tmp = start;
  while (true) {
    const i = _tmp;
    if (i < n) {
      const c = target.str.charCodeAt(target.start + i | 0);
      while (true) {
        if (k > 0 && c !== pattern.str.charCodeAt(pattern.start + k | 0)) {
          const _tmp$2 = k - 1 | 0;
          k = _tmp$2 >>> 0 < table.length ? table[_tmp$2] : $oob();
          continue;
        } else {
          break;
        }
      }
      if (c === pattern.str.charCodeAt(pattern.start + k | 0)) {
        k = k + 1 | 0;
      }
      if (k === m) {
        return (i - m | 0) + 1 | 0;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return undefined;
}
function _M0FPB36find__two__anchor__candidate__scalar(data, start, candidate_end, first, last_offset, last) {
  let _tmp = start;
  while (true) {
    const pos = _tmp;
    if (pos < candidate_end) {
      if (data.charCodeAt(pos) === first && data.charCodeAt(pos + last_offset | 0) === last) {
        return pos;
      }
      _tmp = pos + 1 | 0;
      continue;
    } else {
      return -1;
    }
  }
}
function _M0FPB42find__two__anchor__candidate__from__string(data, start, candidate_end, first, last_offset, last) {
  return _M0FPB36find__two__anchor__candidate__scalar(data, start, candidate_end, first, last_offset, last);
}
function _M0FPB21string__ranges__equal(left, left_start, right, right_start, length) {
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < length) {
      if (left.charCodeAt(left_start + i | 0) !== right.charCodeAt(right_start + i | 0)) {
        return false;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return true;
}
function _M0FPB22find__by__two__anchors(target, pattern) {
  const target_len = target.end - target.start | 0;
  const pattern_len = pattern.end - pattern.start | 0;
  const target_start = target.start;
  const pattern_start = pattern.start;
  const last_offset = pattern_len - 1 | 0;
  const candidate_end = ((target_start + target_len | 0) - pattern_len | 0) + 1 | 0;
  const first = pattern.str.charCodeAt(pattern.start);
  const last = pattern.str.charCodeAt(pattern.start + last_offset | 0);
  const middle_len = last_offset - 1 | 0;
  let _tmp = target_start;
  let _tmp$2 = 0;
  while (true) {
    const pos = _tmp;
    const failures = _tmp$2;
    if (pos < candidate_end) {
      const found = _M0FPB42find__two__anchor__candidate__from__string(target.str, pos, candidate_end, first, last_offset, last);
      if (found < 0) {
        return undefined;
      }
      if (_M0FPB21string__ranges__equal(target.str, found + 1 | 0, pattern.str, pattern_start + 1 | 0, middle_len)) {
        return found - target_start | 0;
      }
      const failures$2 = failures + 1 | 0;
      const scanned = found - target_start | 0;
      if (failures$2 > 64 || failures$2 > (4 + (scanned / 8 | 0) | 0)) {
        return _M0FPB24find__pattern__kmp__from(target, pattern, scanned + 1 | 0);
      }
      _tmp = found + 1 | 0;
      _tmp$2 = failures$2;
      continue;
    } else {
      return undefined;
    }
  }
}
function _M0FPB13find__pattern(target, pattern) {
  if ((pattern.end - pattern.start | 0) <= 250) {
    const target_start = target.start;
    const pattern_start = pattern.start;
    const found = _M0FPB13js__index__of(target.str, target_start, target_start + (target.end - target.start | 0) | 0, _M0FPB13js__substring(pattern.str, pattern_start, pattern_start + (pattern.end - pattern.start | 0) | 0));
    return found < 0 ? undefined : found - target_start | 0;
  } else {
    return _M0FPB22find__by__two__anchors(target, pattern);
  }
}
function _M0FPB24find__code__unit__scalar(data, start, end, code) {
  let _tmp = start;
  while (true) {
    const pos = _tmp;
    if (pos < end) {
      if (data.charCodeAt(pos) === code) {
        return pos;
      }
      _tmp = pos + 1 | 0;
      continue;
    } else {
      return -1;
    }
  }
}
function _M0FPB30find__code__unit__from__string(data, start, end, code) {
  return (end - start | 0) <= 8 ? _M0FPB24find__code__unit__scalar(data, start, end, code) : _M0FPB13js__index__of(data, start, end, _M0FPB22js__code__unit__string(code));
}
function _M0FPB28find__code__unit__from__view(target, start, end, code) {
  const target_start = target.start;
  const found = _M0FPB30find__code__unit__from__string(target.str, target_start + start | 0, target_start + end | 0, code);
  return found < 0 ? -1 : found - target_start | 0;
}
function _M0MPC16string10StringView16find__code__unit(self, code) {
  const found = _M0FPB28find__code__unit__from__view(self, 0, self.end - self.start | 0, code);
  return found < 0 ? undefined : found;
}
function _M0MPC16string10StringView4find(self, str) {
  const pattern_len = str.end - str.start | 0;
  switch (pattern_len) {
    case 0: {
      return _M0MPC16string10StringView4findN6constrS503;
    }
    case 1: {
      return _M0MPC16string10StringView16find__code__unit(self, str.str.charCodeAt(str.start));
    }
    default: {
      return pattern_len > (self.end - self.start | 0) ? undefined : _M0FPB13find__pattern(self, str);
    }
  }
}
function _M0MPC16string6String4find(self, str) {
  return _M0MPC16string10StringView4find(new _M0TPC16string10StringView(self, 0, self.length), str);
}
function _M0MPC15array5Array13Array_2einnerGcE(capacity) {
  return capacity >= 0 ? (capacity === 0 ? new _M0TPB5ArrayGcE([], 0) : new _M0TPB5ArrayGcE(new Array(capacity), 0)) : $panic("capacity must be non-negative");
}
function _M0FPB23array__growth__capacity(current, len, required) {
  if (required < len) {
    $panic("Array capacity overflow");
  }
  const start = current === 0 ? 8 : current;
  let _tmp = start;
  while (true) {
    const space = _tmp;
    if (space < required) {
      const next = Math.imul(space, 2) | 0;
      if (next <= space) {
        return required;
      }
      _tmp = next;
      continue;
    } else {
      return space;
    }
  }
}
function _M0MPC15array5Array8capacityGRP27walkzzz11ghostvalley8AiMemoryE(self) {
  return self.buf.length;
}
function _M0MPC15array5Array8capacityGcE(self) {
  return self.buf.length;
}
function _M0MPC15array5Array8capacityGiE(self) {
  return self.buf.length;
}
function _M0MPC15array5Array8capacityGdE(self) {
  return self.buf.length;
}
function _M0MPC15array5Array14resize__bufferGRP27walkzzz11ghostvalley8AiMemoryE(self, new_capacity) {
  const old_buf = self.buf;
  self.buf = [];
  const len = self.len;
  const copy_len = len < new_capacity ? len : new_capacity;
  const new_buf = _M0MPB18UninitializedArray23make__and__blit_2einnerGRP27walkzzz11ghostvalley8AiMemoryE(old_buf, new_capacity, copy_len, 0, 0);
  self.buf = new_buf;
}
function _M0MPC15array5Array14resize__bufferGcE(self, new_capacity) {
  const old_buf = self.buf;
  self.buf = [];
  const len = self.len;
  const copy_len = len < new_capacity ? len : new_capacity;
  const new_buf = _M0MPB18UninitializedArray23make__and__blit_2einnerGcE(old_buf, new_capacity, copy_len, 0, 0);
  self.buf = new_buf;
}
function _M0MPC15array5Array14resize__bufferGiE(self, new_capacity) {
  const old_buf = self.buf;
  self.buf = [];
  const len = self.len;
  const copy_len = len < new_capacity ? len : new_capacity;
  const new_buf = _M0MPB18UninitializedArray23make__and__blit_2einnerGiE(old_buf, new_capacity, copy_len, 0, 0);
  self.buf = new_buf;
}
function _M0MPC15array5Array14resize__bufferGdE(self, new_capacity) {
  const old_buf = self.buf;
  self.buf = [];
  const len = self.len;
  const copy_len = len < new_capacity ? len : new_capacity;
  const new_buf = _M0MPB18UninitializedArray23make__and__blit_2einnerGdE(old_buf, new_capacity, copy_len, 0, 0);
  self.buf = new_buf;
}
function _M0MPC15array5Array7reallocGRP27walkzzz11ghostvalley8AiMemoryE(self, required) {
  const old_cap = _M0MPC15array5Array8capacityGRP27walkzzz11ghostvalley8AiMemoryE(self);
  const new_cap = _M0FPB23array__growth__capacity(old_cap, self.len, required);
  _M0MPC15array5Array14resize__bufferGRP27walkzzz11ghostvalley8AiMemoryE(self, new_cap);
}
function _M0MPC15array5Array7reallocGcE(self, required) {
  const old_cap = _M0MPC15array5Array8capacityGcE(self);
  const new_cap = _M0FPB23array__growth__capacity(old_cap, self.len, required);
  _M0MPC15array5Array14resize__bufferGcE(self, new_cap);
}
function _M0MPC15array5Array7reallocGiE(self, required) {
  const old_cap = _M0MPC15array5Array8capacityGiE(self);
  const new_cap = _M0FPB23array__growth__capacity(old_cap, self.len, required);
  _M0MPC15array5Array14resize__bufferGiE(self, new_cap);
}
function _M0MPC15array5Array7reallocGdE(self, required) {
  const old_cap = _M0MPC15array5Array8capacityGdE(self);
  const new_cap = _M0FPB23array__growth__capacity(old_cap, self.len, required);
  _M0MPC15array5Array14resize__bufferGdE(self, new_cap);
}
function _M0MPC15array5Array4pushGRP27walkzzz11ghostvalley8AiMemoryE(self, value) {
  if (self.len === self.buf.length) {
    _M0MPC15array5Array7reallocGRP27walkzzz11ghostvalley8AiMemoryE(self, self.len + 1 | 0);
  }
  const length = self.len;
  self.buf[length] = value;
  self.len = length + 1 | 0;
}
function _M0MPC15array5Array4pushGcE(self, value) {
  if (self.len === self.buf.length) {
    _M0MPC15array5Array7reallocGcE(self, self.len + 1 | 0);
  }
  const length = self.len;
  self.buf[length] = value;
  self.len = length + 1 | 0;
}
function _M0MPC15array5Array4pushGiE(self, value) {
  if (self.len === self.buf.length) {
    _M0MPC15array5Array7reallocGiE(self, self.len + 1 | 0);
  }
  const length = self.len;
  self.buf[length] = value;
  self.len = length + 1 | 0;
}
function _M0MPC15array5Array4pushGdE(self, value) {
  if (self.len === self.buf.length) {
    _M0MPC15array5Array7reallocGdE(self, self.len + 1 | 0);
  }
  const length = self.len;
  self.buf[length] = value;
  self.len = length + 1 | 0;
}
function _M0FPB36string__contains__code__unit__scalar(str, start, end, code) {
  let _tmp = start;
  while (true) {
    const i = _tmp;
    if (i < end) {
      if (str.charCodeAt(i) === code) {
        return true;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return false;
}
function _M0FPB28string__contains__code__unit(str, start, end, code) {
  return _M0FPB36string__contains__code__unit__scalar(str, start, end, code);
}
function _M0MPC16string10StringView20contains__code__unit(self, code) {
  return _M0FPB28string__contains__code__unit(self.str, self.start, self.end, code);
}
function _M0MPC16string10StringView8contains(self, str) {
  const _bind = str.end - str.start | 0;
  switch (_bind) {
    case 0: {
      return true;
    }
    case 1: {
      return _M0MPC16string10StringView20contains__code__unit(self, str.str.charCodeAt(str.start));
    }
    default: {
      const _bind$2 = _M0MPC16string10StringView4find(self, str);
      return !(_bind$2 === undefined);
    }
  }
}
function _M0MPC16string6String8contains(self, str) {
  return _M0MPC16string10StringView8contains(new _M0TPC16string10StringView(self, 0, self.length), str);
}
function _M0FPB23build__ascii__char__set(chars) {
  let bits0 = 0;
  let bits1 = 0;
  let bits2 = 0;
  let bits3 = 0;
  const _bind = chars.str;
  const _bind$2 = chars.start;
  const _bind$3 = chars.end;
  let _tmp = _bind$2;
  while (true) {
    const _string_index = _tmp;
    if (_string_index < _bind$3) {
      let _decoded_next_string_index;
      let _decoded_char;
      _L: {
        const _bind$4 = _bind.charCodeAt(_string_index);
        if (_bind$4 >= 55296 && _bind$4 <= 56319 && (_string_index + 1 | 0) < _bind$3) {
          const _bind$5 = _bind.charCodeAt(_string_index + 1 | 0);
          if (_bind$5 >= 56320 && _bind$5 <= 57343) {
            const _tmp$2 = _string_index + 2 | 0;
            const _p = (((Math.imul(_bind$4 - 55296 | 0, 1024) | 0) + _bind$5 | 0) - 56320 | 0) + 65536 | 0;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          } else {
            const _tmp$2 = _string_index + 1 | 0;
            const _p = _bind$4;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          }
        } else {
          const _tmp$2 = _string_index + 1 | 0;
          const _p = _bind$4;
          _decoded_next_string_index = _tmp$2;
          _decoded_char = _p;
          break _L;
        }
      }
      const code = _decoded_char;
      if (code >>> 0 < 128 >>> 0) {
        const bit = 1 << (code & 31);
        const _bind$4 = code >>> 5 | 0;
        switch (_bind$4) {
          case 0: {
            bits0 = bits0 | bit;
            break;
          }
          case 1: {
            bits1 = bits1 | bit;
            break;
          }
          case 2: {
            bits2 = bits2 | bit;
            break;
          }
          default: {
            bits3 = bits3 | bit;
          }
        }
      } else {
        return undefined;
      }
      _tmp = _decoded_next_string_index;
      continue;
    } else {
      break;
    }
  }
  return { _0: bits0, _1: bits1, _2: bits2, _3: bits3 };
}
function _M0FPB26ascii__char__set__contains(bits0, bits1, bits2, bits3, code) {
  if (code >>> 0 < 128 >>> 0) {
    const bit = 1 << (code & 31);
    const _bind = code >>> 5 | 0;
    switch (_bind) {
      case 0: {
        return (bits0 & bit) !== 0;
      }
      case 1: {
        return (bits1 & bit) !== 0;
      }
      case 2: {
        return (bits2 & bit) !== 0;
      }
      default: {
        return (bits3 & bit) !== 0;
      }
    }
  } else {
    return false;
  }
}
function _M0FPB34string__trim__start__ascii__scalar(str, start, end, bits0, bits1, bits2, bits3) {
  let _tmp = start;
  while (true) {
    const pos = _tmp;
    let _tmp$2;
    if (pos < end) {
      const _p = str.charCodeAt(pos);
      _tmp$2 = _M0FPB26ascii__char__set__contains(bits0, bits1, bits2, bits3, _p);
    } else {
      _tmp$2 = false;
    }
    if (_tmp$2) {
      _tmp = pos + 1 | 0;
      continue;
    } else {
      return pos;
    }
  }
}
function _M0FPB32string__trim__end__ascii__scalar(str, start, end, bits0, bits1, bits2, bits3) {
  let _tmp = end;
  while (true) {
    const pos = _tmp;
    let _tmp$2;
    if (pos > start) {
      const _p = str.charCodeAt(pos - 1 | 0);
      _tmp$2 = _M0FPB26ascii__char__set__contains(bits0, bits1, bits2, bits3, _p);
    } else {
      _tmp$2 = false;
    }
    if (_tmp$2) {
      _tmp = pos - 1 | 0;
      continue;
    } else {
      return pos;
    }
  }
}
function _M0FPB26string__trim__start__ascii(str, start, end, _chars, bits0, bits1, bits2, bits3) {
  return _M0FPB34string__trim__start__ascii__scalar(str, start, end, bits0, bits1, bits2, bits3);
}
function _M0FPB24string__trim__end__ascii(str, start, end, _chars, bits0, bits1, bits2, bits3) {
  return _M0FPB32string__trim__end__ascii__scalar(str, start, end, bits0, bits1, bits2, bits3);
}
function _M0MPC16string10StringView14contains__char(self, c) {
  const len = self.end - self.start | 0;
  if (len > 0) {
    const c$2 = c;
    if (c$2 >= 0 && c$2 <= 65535) {
      return _M0MPC16string10StringView20contains__code__unit(self, c$2 & 65535);
    } else {
      if (c$2 < 0) {
        return false;
      } else {
        if (len >= 2) {
          const adj = c$2 - 65536 | 0;
          const high = 55296 + (adj >> 10) | 0;
          if (high <= 65535) {
            const high$2 = high & 65535;
            const low = (56320 + (adj & 1023) | 0) & 65535;
            let _tmp = 0;
            while (true) {
              const i = _tmp;
              if (i < (len - 1 | 0)) {
                if (self.str.charCodeAt(self.start + i | 0) === high$2) {
                  if (self.str.charCodeAt(self.start + (i + 1 | 0) | 0) === low) {
                    return true;
                  }
                  _tmp = i + 2 | 0;
                  continue;
                }
                _tmp = i + 1 | 0;
                continue;
              } else {
                break;
              }
            }
          } else {
            return false;
          }
        } else {
          return false;
        }
      }
    }
    return false;
  } else {
    return false;
  }
}
function _M0MPC16string10StringView24trim__start__with__chars(self, chars) {
  let _tmp = self;
  while (true) {
    const x = _tmp;
    if ((x.end - x.start | 0) === 0) {
      return x;
    } else {
      const _c = _M0MPC16string6String16unsafe__char__at(x.str, _M0MPC16string6String29offset__of__nth__char_2einner(x.str, 0, x.start, x.end));
      const _tmp$2 = x.str;
      const _bind = _M0MPC16string6String29offset__of__nth__char_2einner(x.str, 1, x.start, x.end);
      let _tmp$3;
      if (_bind === undefined) {
        _tmp$3 = x.end;
      } else {
        const _Some = _bind;
        _tmp$3 = _Some;
      }
      const _x = new _M0TPC16string10StringView(_tmp$2, _tmp$3, x.end);
      if (_M0MPC16string10StringView14contains__char(chars, _c)) {
        _tmp = _x;
        continue;
      } else {
        return x;
      }
    }
  }
}
function _M0MPC16string10StringView22trim__end__with__chars(self, chars) {
  let _tmp = self;
  while (true) {
    const x = _tmp;
    if ((x.end - x.start | 0) === 0) {
      return x;
    } else {
      const _c = _M0MPC16string6String16unsafe__char__at(x.str, _M0MPC16string6String29offset__of__nth__char_2einner(x.str, -1, x.start, x.end));
      const _x = new _M0TPC16string10StringView(x.str, x.start, _M0MPC16string6String29offset__of__nth__char_2einner(x.str, -1, x.start, x.end));
      if (_M0MPC16string10StringView14contains__char(chars, _c)) {
        _tmp = _x;
        continue;
      } else {
        return x;
      }
    }
  }
}
function _M0MPC16string10StringView12trim_2einner(self, chars) {
  const _bind = _M0FPB23build__ascii__char__set(chars);
  if (_bind === undefined) {
    return _M0MPC16string10StringView22trim__end__with__chars(_M0MPC16string10StringView24trim__start__with__chars(self, chars), chars);
  } else {
    const _Some = _bind;
    const _x = _Some;
    const _bits0 = _x._0;
    const _bits1 = _x._1;
    const _bits2 = _x._2;
    const _bits3 = _x._3;
    const start = _M0FPB26string__trim__start__ascii(self.str, self.start, self.end, chars, _bits0, _bits1, _bits2, _bits3);
    const end = _M0FPB24string__trim__end__ascii(self.str, start, self.end, chars, _bits0, _bits1, _bits2, _bits3);
    return new _M0TPC16string10StringView(self.str, start, end);
  }
}
function _M0MPC16string6String12trim_2einner(self, chars) {
  return _M0MPC16string10StringView12trim_2einner(new _M0TPC16string10StringView(self, 0, self.length), chars);
}
function _M0IPC14char4CharPB4Show10to__string(self) {
  return String.fromCodePoint(self);
}
function _M0MPC16string6String12replace__all(self, old, new$$) {
  const len = self.length;
  const buf = _M0MPB13StringBuilder21StringBuilder_2einner(len);
  const old_len = old.end - old.start | 0;
  const new$2 = _M0MPC16string10StringView9to__owned(new$$);
  if (old_len === 0) {
    _M0IPB13StringBuilderPB6Logger13write__string(buf, new$2);
    const _bind = self.length;
    let _tmp = 0;
    while (true) {
      const _string_index = _tmp;
      if (_string_index < _bind) {
        let _decoded_next_string_index;
        let _decoded_char;
        _L: {
          const _bind$2 = self.charCodeAt(_string_index);
          if (_bind$2 >= 55296 && _bind$2 <= 56319 && (_string_index + 1 | 0) < _bind) {
            const _bind$3 = self.charCodeAt(_string_index + 1 | 0);
            if (_bind$3 >= 56320 && _bind$3 <= 57343) {
              const _tmp$2 = _string_index + 2 | 0;
              const _p = (((Math.imul(_bind$2 - 55296 | 0, 1024) | 0) + _bind$3 | 0) - 56320 | 0) + 65536 | 0;
              _decoded_next_string_index = _tmp$2;
              _decoded_char = _p;
              break _L;
            } else {
              const _tmp$2 = _string_index + 1 | 0;
              const _p = _bind$2;
              _decoded_next_string_index = _tmp$2;
              _decoded_char = _p;
              break _L;
            }
          } else {
            const _tmp$2 = _string_index + 1 | 0;
            const _p = _bind$2;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          }
        }
        _M0IPB13StringBuilderPB6Logger11write__char(buf, _decoded_char);
        _M0IPB13StringBuilderPB6Logger13write__string(buf, new$2);
        _tmp = _decoded_next_string_index;
        continue;
      } else {
        break;
      }
    }
    return buf.val;
  } else {
    const first_end = _M0MPC16string6String4find(self, old);
    if (first_end === undefined) {
      return self;
    } else {
      const _Some = first_end;
      const _end = _Some;
      let _tmp = new _M0TPC16string10StringView(self, 0, self.length);
      let _tmp$2 = _end;
      while (true) {
        const view = _tmp;
        const end = _tmp$2;
        const seg = _M0MPC16string10StringView12unsafe__view(view, 0, end);
        _M0IP016_24default__implPB6Logger16write__substringGRPB13StringBuilderE(buf, seg.str, seg.start, seg.end - seg.start | 0);
        _M0IPB13StringBuilderPB6Logger13write__string(buf, new$2);
        if ((end + old_len | 0) <= len) {
          const next_view = _M0MPC16string10StringView12unsafe__view(view, end + old_len | 0, view.end - view.start | 0);
          const _bind = _M0MPC16string10StringView4find(next_view, old);
          if (_bind === undefined) {
            _M0IP016_24default__implPB6Logger16write__substringGRPB13StringBuilderE(buf, next_view.str, next_view.start, next_view.end - next_view.start | 0);
            break;
          } else {
            const _Some$2 = _bind;
            const _next_end = _Some$2;
            _tmp = next_view;
            _tmp$2 = _next_end;
            continue;
          }
        } else {
          break;
        }
      }
      return buf.val;
    }
  }
}
function _M0MPC16string6String9to__array(self) {
  const chars = _M0MPC15array5Array13Array_2einnerGcE(self.length);
  const _bind = self.length;
  let _tmp = 0;
  while (true) {
    const _string_index = _tmp;
    if (_string_index < _bind) {
      let _decoded_next_string_index;
      let _decoded_char;
      _L: {
        const _bind$2 = self.charCodeAt(_string_index);
        if (_bind$2 >= 55296 && _bind$2 <= 56319 && (_string_index + 1 | 0) < _bind) {
          const _bind$3 = self.charCodeAt(_string_index + 1 | 0);
          if (_bind$3 >= 56320 && _bind$3 <= 57343) {
            const _tmp$2 = _string_index + 2 | 0;
            const _p = (((Math.imul(_bind$2 - 55296 | 0, 1024) | 0) + _bind$3 | 0) - 56320 | 0) + 65536 | 0;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          } else {
            const _tmp$2 = _string_index + 1 | 0;
            const _p = _bind$2;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          }
        } else {
          const _tmp$2 = _string_index + 1 | 0;
          const _p = _bind$2;
          _decoded_next_string_index = _tmp$2;
          _decoded_char = _p;
          break _L;
        }
      }
      _M0MPC15array5Array4pushGcE(chars, _decoded_char);
      _tmp = _decoded_next_string_index;
      continue;
    } else {
      break;
    }
  }
  return chars;
}
function _M0IPC13int3IntPB4Show10to__string(self) {
  return _M0MPC13int3Int18to__string_2einner(self, 10);
}
function _M0FPB21calc__grow__threshold(capacity) {
  return (Math.imul(capacity / 16 | 0, 13) | 0) + ((Math.imul(capacity % 16 | 0, 13) | 0) / 16 | 0) | 0;
}
function _M0MPC13int3Int20next__power__of__two(self) {
  if (self >= 0) {
    if (self <= 1) {
      return 1;
    }
    if (self > 1073741824) {
      return 1073741824;
    }
    return (2147483647 >> (Math.clz32(self - 1 | 0) - 1 | 0)) + 1 | 0;
  } else {
    return $panic();
  }
}
function _M0FPB8new__mapGssE(capacity) {
  const capacity$2 = _M0MPC13int3Int20next__power__of__two(capacity);
  const _bind = capacity$2 - 1 | 0;
  const _bind$2 = _M0FPB21calc__grow__threshold(capacity$2);
  const _bind$3 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$4 = undefined;
  return new _M0TPB3MapGssE(_bind$3, 0, capacity$2, _bind, _bind$2, _bind$4, -1);
}
function _M0FPB8new__mapGsuE(capacity) {
  const capacity$2 = _M0MPC13int3Int20next__power__of__two(capacity);
  const _bind = capacity$2 - 1 | 0;
  const _bind$2 = _M0FPB21calc__grow__threshold(capacity$2);
  const _bind$3 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$4 = undefined;
  return new _M0TPB3MapGsuE(_bind$3, 0, capacity$2, _bind, _bind$2, _bind$4, -1);
}
function _M0FPB21capacity__for__length(length) {
  if (length <= _M0FPB21calc__grow__threshold(1073741824)) {
    let capacity = _M0MPC13int3Int20next__power__of__two(length);
    if (length > _M0FPB21calc__grow__threshold(capacity)) {
      capacity = Math.imul(capacity, 2) | 0;
    }
    return capacity;
  } else {
    return $panic("Map capacity overflow");
  }
}
function _M0MPB3Map20add__entry__to__tailGssE(self, idx, entry) {
  const _bind = self.tail;
  if (_bind === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    const _p = _bind >>> 0 < _tmp.length ? _tmp[_bind] : $oob();
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  self.entries[idx] = entry;
  self.size = self.size + 1 | 0;
}
function _M0MPB3Map20add__entry__to__tailGsuE(self, idx, entry) {
  const _bind = self.tail;
  if (_bind === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    const _p = _bind >>> 0 < _tmp.length ? _tmp[_bind] : $oob();
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  self.entries[idx] = entry;
  self.size = self.size + 1 | 0;
}
function _M0MPB3Map10set__entryGssE(self, entry, new_idx) {
  const _bind = entry.next;
  if (_bind === undefined) {
    self.tail = new_idx;
  } else {
    const _Some = _bind;
    const _next = _Some;
    _next.prev = new_idx;
  }
  self.entries[new_idx] = entry;
}
function _M0MPB3Map10set__entryGsuE(self, entry, new_idx) {
  const _bind = entry.next;
  if (_bind === undefined) {
    self.tail = new_idx;
  } else {
    const _Some = _bind;
    const _next = _Some;
    _next.prev = new_idx;
  }
  self.entries[new_idx] = entry;
}
function _M0MPB3Map10push__awayGssE(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _bind = self.entries[idx$2];
    if (_bind === undefined) {
      entry$2.psl = psl;
      _M0MPB3Map10set__entryGssE(self, entry$2, idx$2);
      return;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MPB3Map10set__entryGssE(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPB3Map10push__awayGsuE(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _bind = self.entries[idx$2];
    if (_bind === undefined) {
      entry$2.psl = psl;
      _M0MPB3Map10set__entryGsuE(self, entry$2, idx$2);
      return;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MPB3Map10set__entryGsuE(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPB3Map20rehash__place__entryGssE(self, outer) {
  const hash = outer.hash;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      outer.psl = psl;
      outer.prev = self.tail;
      _M0MPB3Map20add__entry__to__tailGssE(self, idx, outer);
      return undefined;
    } else {
      const _Some = _bind;
      const _curr = _Some;
      if (psl > _curr.psl) {
        _M0MPB3Map10push__awayGssE(self, idx, _curr);
        outer.psl = psl;
        outer.prev = self.tail;
        _M0MPB3Map20add__entry__to__tailGssE(self, idx, outer);
        return undefined;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPB3Map20rehash__place__entryGsuE(self, outer) {
  const hash = outer.hash;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      outer.psl = psl;
      outer.prev = self.tail;
      _M0MPB3Map20add__entry__to__tailGsuE(self, idx, outer);
      return undefined;
    } else {
      const _Some = _bind;
      const _curr = _Some;
      if (psl > _curr.psl) {
        _M0MPB3Map10push__awayGsuE(self, idx, _curr);
        outer.psl = psl;
        outer.prev = self.tail;
        _M0MPB3Map20add__entry__to__tailGsuE(self, idx, outer);
        return undefined;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPB3Map4growGssE(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  self.grow_at = _M0FPB21calc__grow__threshold(self.capacity);
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const x = _tmp;
    if (x === undefined) {
      return;
    } else {
      const _Some = x;
      const _e = _Some;
      const next_in_chain = _e.next;
      _e.next = undefined;
      _M0MPB3Map20rehash__place__entryGssE(self, _e);
      _tmp = next_in_chain;
      continue;
    }
  }
}
function _M0MPB3Map4growGsuE(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  self.grow_at = _M0FPB21calc__grow__threshold(self.capacity);
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const x = _tmp;
    if (x === undefined) {
      return;
    } else {
      const _Some = x;
      const _e = _Some;
      const next_in_chain = _e.next;
      _e.next = undefined;
      _M0MPB3Map20rehash__place__entryGsuE(self, _e);
      _tmp = next_in_chain;
      continue;
    }
  }
}
function _M0MPB3Map15set__with__hashGssE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      if (self.size >= self.grow_at) {
        _M0MPB3Map4growGssE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$2 = self.tail;
      const _bind$3 = undefined;
      const entry = new _M0TPB5EntryGssE(_bind$2, _bind$3, psl, hash, key, value);
      _M0MPB3Map20add__entry__to__tailGssE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && _curr_entry.key === key) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        if (self.size >= self.grow_at) {
          _M0MPB3Map4growGssE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MPB3Map10push__awayGssE(self, idx, _curr_entry);
        const _bind$2 = self.tail;
        const _bind$3 = undefined;
        const entry = new _M0TPB5EntryGssE(_bind$2, _bind$3, psl, hash, key, value);
        _M0MPB3Map20add__entry__to__tailGssE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPB3Map15set__with__hashGsuE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      if (self.size >= self.grow_at) {
        _M0MPB3Map4growGsuE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$2 = self.tail;
      const _bind$3 = undefined;
      const entry = new _M0TPB5EntryGsuE(_bind$2, _bind$3, psl, hash, key, value);
      _M0MPB3Map20add__entry__to__tailGsuE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && _curr_entry.key === key) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        if (self.size >= self.grow_at) {
          _M0MPB3Map4growGsuE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MPB3Map10push__awayGsuE(self, idx, _curr_entry);
        const _bind$2 = self.tail;
        const _bind$3 = undefined;
        const entry = new _M0TPB5EntryGsuE(_bind$2, _bind$3, psl, hash, key, value);
        _M0MPB3Map20add__entry__to__tailGsuE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPB3Map3setGssE(self, key, value) {
  _M0MPB3Map15set__with__hashGssE(self, key, value, _M0IPC16string6StringPB4Hash4hash(key));
}
function _M0MPB3Map3setGsuE(self, key, value) {
  _M0MPB3Map15set__with__hashGsuE(self, key, value, _M0IPC16string6StringPB4Hash4hash(key));
}
function _M0MPB3Map3MapGssE(arr, capacity) {
  const length = arr.end - arr.start | 0;
  let capacity$2;
  if (capacity === undefined) {
    capacity$2 = length === 0 ? 8 : _M0FPB21capacity__for__length(length);
  } else {
    const _Some = capacity;
    const _capacity = _Some;
    capacity$2 = _capacity >= 0 ? _M0FPB21capacity__for__length(_capacity > length ? _capacity : length) : $panic("capacity must be non-negative");
  }
  const m = _M0FPB8new__mapGssE(capacity$2);
  const _bind = arr.end - arr.start | 0;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const e = arr.buf[arr.start + _ | 0];
      _M0MPB3Map3setGssE(m, e._0, e._1);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return m;
}
function _M0MPB3Map3MapGsuE(arr, capacity) {
  const length = arr.end - arr.start | 0;
  let capacity$2;
  if (capacity === undefined) {
    capacity$2 = length === 0 ? 8 : _M0FPB21capacity__for__length(length);
  } else {
    const _Some = capacity;
    const _capacity = _Some;
    capacity$2 = _capacity >= 0 ? _M0FPB21capacity__for__length(_capacity > length ? _capacity : length) : $panic("capacity must be non-negative");
  }
  const m = _M0FPB8new__mapGsuE(capacity$2);
  const _bind = arr.end - arr.start | 0;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const e = arr.buf[arr.start + _ | 0];
      _M0MPB3Map3setGsuE(m, e._0, e._1);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return m;
}
function _M0MPB3Map8containsGsuE(self, key) {
  const hash = _M0IPC16string6StringPB4Hash4hash(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      return false;
    } else {
      const _Some = _bind;
      const _entry = _Some;
      if (_entry.hash === hash && _entry.key === key) {
        return true;
      }
      if (i > _entry.psl) {
        return false;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPB3Map4iterGssE(self) {
  const curr_entry = new _M0TPB8MutLocalGORPB5EntryGssEE(self.head);
  const len = self.size;
  const remaining = new _M0TPB8MutLocalGiE(len);
  return _M0MPB4Iter3newGUssEE(() => {
    _L: {
      if (remaining.val > 0) {
        const _bind = curr_entry.val;
        if (_bind === undefined) {
          break _L;
        } else {
          const _Some = _bind;
          const _x = _Some;
          const _key = _x.key;
          const _value = _x.value;
          const _next = _x.next;
          curr_entry.val = _next;
          remaining.val = remaining.val - 1 | 0;
          return { _0: _key, _1: _value };
        }
      } else {
        break _L;
      }
    }
    return undefined;
  }, len);
}
function _M0MPB3Map4iterGsuE(self) {
  const curr_entry = new _M0TPB8MutLocalGORPB5EntryGsuEE(self.head);
  const len = self.size;
  const remaining = new _M0TPB8MutLocalGiE(len);
  return _M0MPB4Iter3newGUssEE(() => {
    _L: {
      if (remaining.val > 0) {
        const _bind = curr_entry.val;
        if (_bind === undefined) {
          break _L;
        } else {
          const _Some = _bind;
          const _x = _Some;
          const _key = _x.key;
          const _value = _x.value;
          const _next = _x.next;
          curr_entry.val = _next;
          remaining.val = remaining.val - 1 | 0;
          return { _0: _key, _1: _value };
        }
      } else {
        break _L;
      }
    }
    return undefined;
  }, len);
}
function _M0IPC16string6StringPB4Hash4hash(self) {
  let acc = (_M0FPB4seed >>> 0) + (374761393 >>> 0) | 0;
  const _bind = self.length;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      acc = (acc >>> 0) + (4 >>> 0) | 0;
      const v = self.charCodeAt(i);
      acc = _M0FPB13consume4__acc(acc, v);
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return _M0FPB13finalize__acc(acc);
}
function _M0MPC15array10FixedArray16blit__to_2einnerGjE(self, dst, len, src_offset, dst_offset) {
  let _tmp;
  if (len >= 0) {
    let _tmp$2;
    const _p = self.length;
    if (src_offset >= 0 && src_offset <= (_p - len | 0)) {
      const _p$2 = dst.length;
      _tmp$2 = dst_offset >= 0 && dst_offset <= (_p$2 - len | 0);
    } else {
      _tmp$2 = false;
    }
    _tmp = _tmp$2;
  } else {
    _tmp = false;
  }
  if (_tmp) {
    _M0MPC15array10FixedArray12unsafe__blitGjE(dst, dst_offset, self, src_offset, len);
    return;
  } else {
    const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(8);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "bounds check failed: dst_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, dst_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", dst.length = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, dst.length);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", self.length = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, self.length);
    $panic(_string_builder.val);
    return;
  }
}
function _M0MPC16double6Double4ceil(_tmp) {
  return Math.ceil(_tmp);
}
function _M0MPC16double6Double5floor(_tmp) {
  return Math.floor(_tmp);
}
function _M0IPC16double6DoublePB4Show10to__string(self) {
  return String(self);
}
function _M0MPC15bytes9BytesView21clamped__view_2einner(self, start, end) {
  const len = self.end - self.start | 0;
  const lo = start < 0 ? 0 : start > len ? len : start;
  let hi;
  if (end === undefined) {
    hi = len;
  } else {
    const _Some = end;
    const _end = _Some;
    hi = _end < 0 ? 0 : _end > len ? len : _end;
  }
  const hi$2 = hi > lo ? hi : lo;
  return new _M0TPC15bytes9BytesView(self.buf, self.start + lo | 0, self.start + hi$2 | 0);
}
function _M0MPC15bytes5Bytes24unsafe__read__uint32__le(bytes, index) {
  const _p = bytes[index];
  const _p$2 = bytes[index + 1 | 0];
  const _tmp = _p | _p$2 << 8;
  const _p$3 = bytes[index + 2 | 0];
  const _tmp$2 = _tmp | _p$3 << 16;
  const _p$4 = bytes[index + 3 | 0];
  return _tmp$2 | _p$4 << 24;
}
function _M0MPC15array12MutArrayView4swapGUidEE(arr, i, j) {
  const temp = arr.buf[arr.start + i | 0];
  arr.buf[arr.start + i | 0] = arr.buf[arr.start + j | 0];
  arr.buf[arr.start + j | 0] = temp;
}
function _M0MPC15array12MutArrayView4swapGiE(arr, i, j) {
  const temp = arr.buf[arr.start + i | 0];
  arr.buf[arr.start + i | 0] = arr.buf[arr.start + j | 0];
  arr.buf[arr.start + j | 0] = temp;
}
function _M0MPC15array12MutArrayView5sliceGUidEE(arr, start, end) {
  const _bind = arr.end - arr.start | 0;
  if (start < 0 || (start > end || end > _bind)) {
    $panic();
  }
  return new _M0TPB12MutArrayViewGUidEE(arr.buf, start + arr.start | 0, end + arr.start | 0);
}
function _M0MPC15array12MutArrayView5sliceGiE(arr, start, end) {
  const _bind = arr.end - arr.start | 0;
  if (start < 0 || (start > end || end > _bind)) {
    $panic();
  }
  return new _M0TPB12MutArrayViewGiE(arr.buf, start + arr.start | 0, end + arr.start | 0);
}
function _M0MPC15array5Array28unsafe__truncate__to__lengthGRP27walkzzz11ghostvalley8AiMemoryE(self, new_len) {
  if (new_len <= self.len) {
    self.len = new_len;
    return;
  } else {
    $panic();
    return;
  }
}
function _M0MPC15array5Array6removeGRP27walkzzz11ghostvalley8AiMemoryE(self, index) {
  if (index >= 0 && index < self.len) {
    const value = self.buf[index];
    _M0MPB18UninitializedArray12unsafe__blitGRP27walkzzz11ghostvalley8AiMemoryE(self.buf, index, self.buf, index + 1 | 0, (self.len - index | 0) - 1 | 0);
    _M0MPC15array5Array28unsafe__truncate__to__lengthGRP27walkzzz11ghostvalley8AiMemoryE(self, self.len - 1 | 0);
    return value;
  } else {
    const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(8);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "index out of bounds: the len is from 0 to ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, self.len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, " but the index is ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, index);
    return $panic(_string_builder.val);
  }
}
function _M0MPC15array12MutArrayView14rev__in__placeGUidEE(arr) {
  const len = arr.end - arr.start | 0;
  const mid_len = len / 2 | 0;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < mid_len) {
      const j = (len - i | 0) - 1 | 0;
      const temp = arr.buf[arr.start + i | 0];
      arr.buf[arr.start + i | 0] = arr.buf[arr.start + j | 0];
      arr.buf[arr.start + j | 0] = temp;
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0MPC15array12MutArrayView14rev__in__placeGiE(arr) {
  const len = arr.end - arr.start | 0;
  const mid_len = len / 2 | 0;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < mid_len) {
      const j = (len - i | 0) - 1 | 0;
      const temp = arr.buf[arr.start + i | 0];
      arr.buf[arr.start + i | 0] = arr.buf[arr.start + j | 0];
      arr.buf[arr.start + j | 0] = temp;
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FPB17fixed__get__limit(len) {
  let _tmp = len;
  let _tmp$2 = 0;
  while (true) {
    const len$2 = _tmp;
    const limit = _tmp$2;
    if (len$2 > 0) {
      _tmp = len$2 / 2 | 0;
      _tmp$2 = limit + 1 | 0;
      continue;
    } else {
      return limit;
    }
  }
}
function _M0FPB23fixed__bubble__sort__byGUidEE(arr, cmp) {
  const _bind = arr.end - arr.start | 0;
  let _tmp = 1;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      let _tmp$2 = i;
      while (true) {
        const j = _tmp$2;
        if (j > 0 && cmp(arr.buf[arr.start + (j - 1 | 0) | 0], arr.buf[arr.start + j | 0]) > 0) {
          _M0MPC15array12MutArrayView4swapGUidEE(arr, j, j - 1 | 0);
          _tmp$2 = j - 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FPB23fixed__bubble__sort__byGiE(arr, cmp) {
  const _bind = arr.end - arr.start | 0;
  let _tmp = 1;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      let _tmp$2 = i;
      while (true) {
        const j = _tmp$2;
        if (j > 0 && cmp(arr.buf[arr.start + (j - 1 | 0) | 0], arr.buf[arr.start + j | 0]) > 0) {
          _M0MPC15array12MutArrayView4swapGiE(arr, j, j - 1 | 0);
          _tmp$2 = j - 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FPB24fixed__choose__pivot__byN7sort__2S1068GUidEE(_env, a, b) {
  const swaps = _env._2;
  const cmp = _env._1;
  const arr = _env._0;
  if (cmp(arr.buf[arr.start + a | 0], arr.buf[arr.start + b | 0]) > 0) {
    _M0MPC15array12MutArrayView4swapGUidEE(arr, a, b);
    swaps.val = swaps.val + 1 | 0;
    return;
  } else {
    return;
  }
}
function _M0FPB24fixed__choose__pivot__byN7sort__3S1069GUidEE(_env, a, b, c) {
  _M0FPB24fixed__choose__pivot__byN7sort__2S1068GUidEE(_env, a, b);
  _M0FPB24fixed__choose__pivot__byN7sort__2S1068GUidEE(_env, b, c);
  _M0FPB24fixed__choose__pivot__byN7sort__2S1068GUidEE(_env, a, b);
}
function _M0FPB24fixed__choose__pivot__byN7sort__2S1088GiE(_env, a, b) {
  const swaps = _env._2;
  const cmp = _env._1;
  const arr = _env._0;
  if (cmp(arr.buf[arr.start + a | 0], arr.buf[arr.start + b | 0]) > 0) {
    _M0MPC15array12MutArrayView4swapGiE(arr, a, b);
    swaps.val = swaps.val + 1 | 0;
    return;
  } else {
    return;
  }
}
function _M0FPB24fixed__choose__pivot__byN7sort__3S1089GiE(_env, a, b, c) {
  _M0FPB24fixed__choose__pivot__byN7sort__2S1088GiE(_env, a, b);
  _M0FPB24fixed__choose__pivot__byN7sort__2S1088GiE(_env, b, c);
  _M0FPB24fixed__choose__pivot__byN7sort__2S1088GiE(_env, a, b);
}
function _M0FPB24fixed__choose__pivot__byGUidEE(arr, cmp) {
  const len = arr.end - arr.start | 0;
  const swaps = new _M0TPB8MutLocalGiE(0);
  const b = Math.imul(len / 4 | 0, 2) | 0;
  if (len >= 8) {
    const a = Math.imul(len / 4 | 0, 1) | 0;
    const c = Math.imul(len / 4 | 0, 3) | 0;
    const _env = { _0: arr, _1: cmp, _2: swaps };
    if (len > 50) {
      _M0FPB24fixed__choose__pivot__byN7sort__3S1069GUidEE(_env, a - 1 | 0, a, a + 1 | 0);
      _M0FPB24fixed__choose__pivot__byN7sort__3S1069GUidEE(_env, b - 1 | 0, b, b + 1 | 0);
      _M0FPB24fixed__choose__pivot__byN7sort__3S1069GUidEE(_env, c - 1 | 0, c, c + 1 | 0);
    }
    _M0FPB24fixed__choose__pivot__byN7sort__3S1069GUidEE(_env, a, b, c);
  }
  if (swaps.val === 12) {
    _M0MPC15array12MutArrayView14rev__in__placeGUidEE(arr);
    return { _0: (len - b | 0) - 1 | 0, _1: true };
  } else {
    return { _0: b, _1: swaps.val === 0 };
  }
}
function _M0FPB24fixed__choose__pivot__byGiE(arr, cmp) {
  const len = arr.end - arr.start | 0;
  const swaps = new _M0TPB8MutLocalGiE(0);
  const b = Math.imul(len / 4 | 0, 2) | 0;
  if (len >= 8) {
    const a = Math.imul(len / 4 | 0, 1) | 0;
    const c = Math.imul(len / 4 | 0, 3) | 0;
    const _env = { _0: arr, _1: cmp, _2: swaps };
    if (len > 50) {
      _M0FPB24fixed__choose__pivot__byN7sort__3S1089GiE(_env, a - 1 | 0, a, a + 1 | 0);
      _M0FPB24fixed__choose__pivot__byN7sort__3S1089GiE(_env, b - 1 | 0, b, b + 1 | 0);
      _M0FPB24fixed__choose__pivot__byN7sort__3S1089GiE(_env, c - 1 | 0, c, c + 1 | 0);
    }
    _M0FPB24fixed__choose__pivot__byN7sort__3S1089GiE(_env, a, b, c);
  }
  if (swaps.val === 12) {
    _M0MPC15array12MutArrayView14rev__in__placeGiE(arr);
    return { _0: (len - b | 0) - 1 | 0, _1: true };
  } else {
    return { _0: b, _1: swaps.val === 0 };
  }
}
function _M0FPB21fixed__sift__down__byGUidEE(arr, index, cmp) {
  const len = arr.end - arr.start | 0;
  let _tmp = index;
  let _tmp$2 = (Math.imul(index, 2) | 0) + 1 | 0;
  while (true) {
    const index$2 = _tmp;
    const child = _tmp$2;
    if (child < len) {
      const child$2 = (child + 1 | 0) < len && cmp(arr.buf[arr.start + child | 0], arr.buf[arr.start + (child + 1 | 0) | 0]) < 0 ? child + 1 | 0 : child;
      if (cmp(arr.buf[arr.start + index$2 | 0], arr.buf[arr.start + child$2 | 0]) >= 0) {
        return undefined;
      }
      _M0MPC15array12MutArrayView4swapGUidEE(arr, index$2, child$2);
      _tmp = child$2;
      _tmp$2 = (Math.imul(child$2, 2) | 0) + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FPB21fixed__sift__down__byGiE(arr, index, cmp) {
  const len = arr.end - arr.start | 0;
  let _tmp = index;
  let _tmp$2 = (Math.imul(index, 2) | 0) + 1 | 0;
  while (true) {
    const index$2 = _tmp;
    const child = _tmp$2;
    if (child < len) {
      const child$2 = (child + 1 | 0) < len && cmp(arr.buf[arr.start + child | 0], arr.buf[arr.start + (child + 1 | 0) | 0]) < 0 ? child + 1 | 0 : child;
      if (cmp(arr.buf[arr.start + index$2 | 0], arr.buf[arr.start + child$2 | 0]) >= 0) {
        return undefined;
      }
      _M0MPC15array12MutArrayView4swapGiE(arr, index$2, child$2);
      _tmp = child$2;
      _tmp$2 = (Math.imul(child$2, 2) | 0) + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FPB21fixed__heap__sort__byGUidEE(arr, cmp) {
  const len = arr.end - arr.start | 0;
  const _bind = len / 2 | 0;
  let _tmp = _bind - 1 | 0;
  let _tmp$2 = _bind > 0;
  while (true) {
    const i = _tmp;
    const _more = _tmp$2;
    if (_more) {
      _M0FPB21fixed__sift__down__byGUidEE(arr, i, cmp);
      _tmp = i - 1 | 0;
      _tmp$2 = i > 0;
      continue;
    } else {
      break;
    }
  }
  let _tmp$3 = len - 1 | 0;
  let _tmp$4 = len > 1;
  while (true) {
    const i = _tmp$3;
    const _more = _tmp$4;
    if (_more) {
      _M0MPC15array12MutArrayView4swapGUidEE(arr, 0, i);
      _M0FPB21fixed__sift__down__byGUidEE(_M0MPC15array12MutArrayView5sliceGUidEE(arr, 0, i), 0, cmp);
      _tmp$3 = i - 1 | 0;
      _tmp$4 = i > 1;
      continue;
    } else {
      return;
    }
  }
}
function _M0FPB21fixed__heap__sort__byGiE(arr, cmp) {
  const len = arr.end - arr.start | 0;
  const _bind = len / 2 | 0;
  let _tmp = _bind - 1 | 0;
  let _tmp$2 = _bind > 0;
  while (true) {
    const i = _tmp;
    const _more = _tmp$2;
    if (_more) {
      _M0FPB21fixed__sift__down__byGiE(arr, i, cmp);
      _tmp = i - 1 | 0;
      _tmp$2 = i > 0;
      continue;
    } else {
      break;
    }
  }
  let _tmp$3 = len - 1 | 0;
  let _tmp$4 = len > 1;
  while (true) {
    const i = _tmp$3;
    const _more = _tmp$4;
    if (_more) {
      _M0MPC15array12MutArrayView4swapGiE(arr, 0, i);
      _M0FPB21fixed__sift__down__byGiE(_M0MPC15array12MutArrayView5sliceGiE(arr, 0, i), 0, cmp);
      _tmp$3 = i - 1 | 0;
      _tmp$4 = i > 1;
      continue;
    } else {
      return;
    }
  }
}
function _M0FPB20fixed__partition__byGUidEE(arr, cmp, pivot_index) {
  _M0MPC15array12MutArrayView4swapGUidEE(arr, pivot_index, (arr.end - arr.start | 0) - 1 | 0);
  const pivot = arr.buf[arr.start + ((arr.end - arr.start | 0) - 1 | 0) | 0];
  const _bind = (arr.end - arr.start | 0) - 1 | 0;
  let _tmp = 0;
  let _tmp$2 = 0;
  let _tmp$3 = true;
  while (true) {
    const j = _tmp;
    const i = _tmp$2;
    const partitioned = _tmp$3;
    if (j < _bind) {
      if (cmp(arr.buf[arr.start + j | 0], pivot) < 0) {
        if (i !== j) {
          _M0MPC15array12MutArrayView4swapGUidEE(arr, i, j);
          _tmp = j + 1 | 0;
          _tmp$2 = i + 1 | 0;
          _tmp$3 = false;
          continue;
        } else {
          _tmp = j + 1 | 0;
          _tmp$2 = i + 1 | 0;
          continue;
        }
      } else {
        _tmp = j + 1 | 0;
        continue;
      }
    } else {
      _M0MPC15array12MutArrayView4swapGUidEE(arr, i, (arr.end - arr.start | 0) - 1 | 0);
      return { _0: i, _1: partitioned };
    }
  }
}
function _M0FPB20fixed__partition__byGiE(arr, cmp, pivot_index) {
  _M0MPC15array12MutArrayView4swapGiE(arr, pivot_index, (arr.end - arr.start | 0) - 1 | 0);
  const pivot = arr.buf[arr.start + ((arr.end - arr.start | 0) - 1 | 0) | 0];
  const _bind = (arr.end - arr.start | 0) - 1 | 0;
  let _tmp = 0;
  let _tmp$2 = 0;
  let _tmp$3 = true;
  while (true) {
    const j = _tmp;
    const i = _tmp$2;
    const partitioned = _tmp$3;
    if (j < _bind) {
      if (cmp(arr.buf[arr.start + j | 0], pivot) < 0) {
        if (i !== j) {
          _M0MPC15array12MutArrayView4swapGiE(arr, i, j);
          _tmp = j + 1 | 0;
          _tmp$2 = i + 1 | 0;
          _tmp$3 = false;
          continue;
        } else {
          _tmp = j + 1 | 0;
          _tmp$2 = i + 1 | 0;
          continue;
        }
      } else {
        _tmp = j + 1 | 0;
        continue;
      }
    } else {
      _M0MPC15array12MutArrayView4swapGiE(arr, i, (arr.end - arr.start | 0) - 1 | 0);
      return { _0: i, _1: partitioned };
    }
  }
}
function _M0FPB28fixed__try__bubble__sort__byGUidEE(arr, cmp) {
  const _bind = arr.end - arr.start | 0;
  let _tmp = 1;
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp;
    const tries = _tmp$2;
    if (i < _bind) {
      let sorted;
      let _tmp$3 = i;
      let _tmp$4 = true;
      while (true) {
        const j = _tmp$3;
        const sorted$2 = _tmp$4;
        if (j > 0 && cmp(arr.buf[arr.start + (j - 1 | 0) | 0], arr.buf[arr.start + j | 0]) > 0) {
          _M0MPC15array12MutArrayView4swapGUidEE(arr, j, j - 1 | 0);
          _tmp$3 = j - 1 | 0;
          _tmp$4 = false;
          continue;
        } else {
          sorted = sorted$2;
          break;
        }
      }
      if (!sorted) {
        const tries$2 = tries + 1 | 0;
        if (tries$2 > 8) {
          return false;
        }
        _tmp = i + 1 | 0;
        _tmp$2 = tries$2;
        continue;
      } else {
        _tmp = i + 1 | 0;
        continue;
      }
    } else {
      return true;
    }
  }
}
function _M0FPB28fixed__try__bubble__sort__byGiE(arr, cmp) {
  const _bind = arr.end - arr.start | 0;
  let _tmp = 1;
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp;
    const tries = _tmp$2;
    if (i < _bind) {
      let sorted;
      let _tmp$3 = i;
      let _tmp$4 = true;
      while (true) {
        const j = _tmp$3;
        const sorted$2 = _tmp$4;
        if (j > 0 && cmp(arr.buf[arr.start + (j - 1 | 0) | 0], arr.buf[arr.start + j | 0]) > 0) {
          _M0MPC15array12MutArrayView4swapGiE(arr, j, j - 1 | 0);
          _tmp$3 = j - 1 | 0;
          _tmp$4 = false;
          continue;
        } else {
          sorted = sorted$2;
          break;
        }
      }
      if (!sorted) {
        const tries$2 = tries + 1 | 0;
        if (tries$2 > 8) {
          return false;
        }
        _tmp = i + 1 | 0;
        _tmp$2 = tries$2;
        continue;
      } else {
        _tmp = i + 1 | 0;
        continue;
      }
    } else {
      return true;
    }
  }
}
function _M0FPB22fixed__quick__sort__byGUidEE(arr, cmp, pred, limit) {
  let _tmp = limit;
  let _tmp$2 = arr;
  let _tmp$3 = pred;
  let _tmp$4 = true;
  let _tmp$5 = true;
  while (true) {
    const limit$2 = _tmp;
    const arr$2 = _tmp$2;
    const pred$2 = _tmp$3;
    const was_partitioned = _tmp$4;
    const balanced = _tmp$5;
    const len = arr$2.end - arr$2.start | 0;
    if (len <= 16) {
      if (len >= 2) {
        _M0FPB23fixed__bubble__sort__byGUidEE(arr$2, cmp);
      }
      return undefined;
    }
    if (limit$2 === 0) {
      _M0FPB21fixed__heap__sort__byGUidEE(arr$2, cmp);
      return undefined;
    }
    const _bind = _M0FPB24fixed__choose__pivot__byGUidEE(arr$2, cmp);
    const _pivot_index = _bind._0;
    const _likely_sorted = _bind._1;
    if (was_partitioned && (balanced && _likely_sorted)) {
      if (_M0FPB28fixed__try__bubble__sort__byGUidEE(arr$2, cmp)) {
        return undefined;
      }
    }
    const _bind$2 = _M0FPB20fixed__partition__byGUidEE(arr$2, cmp, _pivot_index);
    const _pivot = _bind$2._0;
    const _partitioned = _bind$2._1;
    const _p = len - _pivot | 0;
    const balanced$2 = (_pivot > _p ? _p : _pivot) >= (len / 8 | 0);
    const limit$3 = !balanced$2 ? limit$2 - 1 | 0 : limit$2;
    if (pred$2 === undefined) {
    } else {
      const _Some = pred$2;
      const _p$2 = _Some;
      if (cmp(_p$2, arr$2.buf[arr$2.start + _pivot | 0]) === 0) {
        let i;
        let _tmp$6 = _pivot;
        while (true) {
          const i$2 = _tmp$6;
          if (i$2 < len && cmp(_p$2, arr$2.buf[arr$2.start + i$2 | 0]) === 0) {
            _tmp$6 = i$2 + 1 | 0;
            continue;
          } else {
            i = i$2;
            break;
          }
        }
        _tmp = limit$3;
        _tmp$2 = _M0MPC15array12MutArrayView5sliceGUidEE(arr$2, i, len);
        _tmp$4 = _partitioned;
        _tmp$5 = balanced$2;
        continue;
      }
    }
    const left = _M0MPC15array12MutArrayView5sliceGUidEE(arr$2, 0, _pivot);
    const right = _M0MPC15array12MutArrayView5sliceGUidEE(arr$2, _pivot + 1 | 0, len);
    if ((left.end - left.start | 0) < (right.end - right.start | 0)) {
      _M0FPB22fixed__quick__sort__byGUidEE(left, cmp, pred$2, limit$3);
      _tmp = limit$3;
      _tmp$2 = right;
      _tmp$3 = arr$2.buf[arr$2.start + _pivot | 0];
      _tmp$4 = _partitioned;
      _tmp$5 = balanced$2;
      continue;
    } else {
      _M0FPB22fixed__quick__sort__byGUidEE(right, cmp, arr$2.buf[arr$2.start + _pivot | 0], limit$3);
      _tmp = limit$3;
      _tmp$2 = left;
      _tmp$4 = _partitioned;
      _tmp$5 = balanced$2;
      continue;
    }
  }
}
function _M0FPB22fixed__quick__sort__byGiE(arr, cmp, pred, limit) {
  let _tmp = limit;
  let _tmp$2 = arr;
  let _tmp$3 = pred;
  let _tmp$4 = true;
  let _tmp$5 = true;
  while (true) {
    const limit$2 = _tmp;
    const arr$2 = _tmp$2;
    const pred$2 = _tmp$3;
    const was_partitioned = _tmp$4;
    const balanced = _tmp$5;
    const len = arr$2.end - arr$2.start | 0;
    if (len <= 16) {
      if (len >= 2) {
        _M0FPB23fixed__bubble__sort__byGiE(arr$2, cmp);
      }
      return undefined;
    }
    if (limit$2 === 0) {
      _M0FPB21fixed__heap__sort__byGiE(arr$2, cmp);
      return undefined;
    }
    const _bind = _M0FPB24fixed__choose__pivot__byGiE(arr$2, cmp);
    const _pivot_index = _bind._0;
    const _likely_sorted = _bind._1;
    if (was_partitioned && (balanced && _likely_sorted)) {
      if (_M0FPB28fixed__try__bubble__sort__byGiE(arr$2, cmp)) {
        return undefined;
      }
    }
    const _bind$2 = _M0FPB20fixed__partition__byGiE(arr$2, cmp, _pivot_index);
    const _pivot = _bind$2._0;
    const _partitioned = _bind$2._1;
    const _p = len - _pivot | 0;
    const balanced$2 = (_pivot > _p ? _p : _pivot) >= (len / 8 | 0);
    const limit$3 = !balanced$2 ? limit$2 - 1 | 0 : limit$2;
    if (pred$2 === undefined) {
    } else {
      const _Some = pred$2;
      const _p$2 = _Some;
      if (cmp(_p$2, arr$2.buf[arr$2.start + _pivot | 0]) === 0) {
        let i;
        let _tmp$6 = _pivot;
        while (true) {
          const i$2 = _tmp$6;
          if (i$2 < len && cmp(_p$2, arr$2.buf[arr$2.start + i$2 | 0]) === 0) {
            _tmp$6 = i$2 + 1 | 0;
            continue;
          } else {
            i = i$2;
            break;
          }
        }
        _tmp = limit$3;
        _tmp$2 = _M0MPC15array12MutArrayView5sliceGiE(arr$2, i, len);
        _tmp$4 = _partitioned;
        _tmp$5 = balanced$2;
        continue;
      }
    }
    const left = _M0MPC15array12MutArrayView5sliceGiE(arr$2, 0, _pivot);
    const right = _M0MPC15array12MutArrayView5sliceGiE(arr$2, _pivot + 1 | 0, len);
    if ((left.end - left.start | 0) < (right.end - right.start | 0)) {
      _M0FPB22fixed__quick__sort__byGiE(left, cmp, pred$2, limit$3);
      _tmp = limit$3;
      _tmp$2 = right;
      _tmp$3 = arr$2.buf[arr$2.start + _pivot | 0];
      _tmp$4 = _partitioned;
      _tmp$5 = balanced$2;
      continue;
    } else {
      _M0FPB22fixed__quick__sort__byGiE(right, cmp, arr$2.buf[arr$2.start + _pivot | 0], limit$3);
      _tmp = limit$3;
      _tmp$2 = left;
      _tmp$4 = _partitioned;
      _tmp$5 = balanced$2;
      continue;
    }
  }
}
function _M0MPC15array12MutArrayView8sort__byGUidEE(self, cmp) {
  _M0FPB22fixed__quick__sort__byGUidEE(self, cmp, undefined, _M0FPB17fixed__get__limit(self.end - self.start | 0));
}
function _M0MPC15array12MutArrayView8sort__byGiE(self, cmp) {
  _M0FPB22fixed__quick__sort__byGiE(self, cmp, undefined, _M0FPB17fixed__get__limit(self.end - self.start | 0));
}
function _M0MPC15array5Array8sort__byGUidEE(self, cmp) {
  const _bind = self.len;
  _M0MPC15array12MutArrayView8sort__byGUidEE(new _M0TPB12MutArrayViewGUidEE(self.buf, 0, _bind), cmp);
}
function _M0MPC15array5Array8sort__byGiE(self, cmp) {
  const _bind = self.len;
  _M0MPC15array12MutArrayView8sort__byGiE(new _M0TPB12MutArrayViewGiE(self.buf, 0, _bind), cmp);
}
function _M0MPC15array5Array8containsGsE(self, value) {
  const _bind = self.len;
  const _bind$2 = self.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const v = _bind$2[_];
      if (v === value) {
        return true;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return false;
    }
  }
}
function _M0FPC36random8internal14random__source5setup(seed, b32, counter) {
  if (0 >>> 0 < b32.length) {
    b32[0] = 1634760805;
  } else {
    $oob();
  }
  if (1 >>> 0 < b32.length) {
    b32[1] = 1634760805;
  } else {
    $oob();
  }
  if (2 >>> 0 < b32.length) {
    b32[2] = 1634760805;
  } else {
    $oob();
  }
  if (3 >>> 0 < b32.length) {
    b32[3] = 1634760805;
  } else {
    $oob();
  }
  if (4 >>> 0 < b32.length) {
    b32[4] = 857760878;
  } else {
    $oob();
  }
  if (5 >>> 0 < b32.length) {
    b32[5] = 857760878;
  } else {
    $oob();
  }
  if (6 >>> 0 < b32.length) {
    b32[6] = 857760878;
  } else {
    $oob();
  }
  if (7 >>> 0 < b32.length) {
    b32[7] = 857760878;
  } else {
    $oob();
  }
  if (8 >>> 0 < b32.length) {
    b32[8] = 2036477234;
  } else {
    $oob();
  }
  if (9 >>> 0 < b32.length) {
    b32[9] = 2036477234;
  } else {
    $oob();
  }
  if (10 >>> 0 < b32.length) {
    b32[10] = 2036477234;
  } else {
    $oob();
  }
  if (11 >>> 0 < b32.length) {
    b32[11] = 2036477234;
  } else {
    $oob();
  }
  if (12 >>> 0 < b32.length) {
    b32[12] = 1797285236;
  } else {
    $oob();
  }
  if (13 >>> 0 < b32.length) {
    b32[13] = 1797285236;
  } else {
    $oob();
  }
  if (14 >>> 0 < b32.length) {
    b32[14] = 1797285236;
  } else {
    $oob();
  }
  if (15 >>> 0 < b32.length) {
    b32[15] = 1797285236;
  } else {
    $oob();
  }
  if (16 >>> 0 < b32.length) {
    b32[16] = 0 >>> 0 < seed.length ? seed[0] : $oob();
  } else {
    $oob();
  }
  if (17 >>> 0 < b32.length) {
    b32[17] = 0 >>> 0 < seed.length ? seed[0] : $oob();
  } else {
    $oob();
  }
  if (18 >>> 0 < b32.length) {
    b32[18] = 0 >>> 0 < seed.length ? seed[0] : $oob();
  } else {
    $oob();
  }
  if (19 >>> 0 < b32.length) {
    b32[19] = 0 >>> 0 < seed.length ? seed[0] : $oob();
  } else {
    $oob();
  }
  if (20 >>> 0 < b32.length) {
    b32[20] = 1 >>> 0 < seed.length ? seed[1] : $oob();
  } else {
    $oob();
  }
  if (21 >>> 0 < b32.length) {
    b32[21] = 1 >>> 0 < seed.length ? seed[1] : $oob();
  } else {
    $oob();
  }
  if (22 >>> 0 < b32.length) {
    b32[22] = 1 >>> 0 < seed.length ? seed[1] : $oob();
  } else {
    $oob();
  }
  if (23 >>> 0 < b32.length) {
    b32[23] = 1 >>> 0 < seed.length ? seed[1] : $oob();
  } else {
    $oob();
  }
  if (24 >>> 0 < b32.length) {
    b32[24] = 2 >>> 0 < seed.length ? seed[2] : $oob();
  } else {
    $oob();
  }
  if (25 >>> 0 < b32.length) {
    b32[25] = 2 >>> 0 < seed.length ? seed[2] : $oob();
  } else {
    $oob();
  }
  if (26 >>> 0 < b32.length) {
    b32[26] = 2 >>> 0 < seed.length ? seed[2] : $oob();
  } else {
    $oob();
  }
  if (27 >>> 0 < b32.length) {
    b32[27] = 2 >>> 0 < seed.length ? seed[2] : $oob();
  } else {
    $oob();
  }
  if (28 >>> 0 < b32.length) {
    b32[28] = 3 >>> 0 < seed.length ? seed[3] : $oob();
  } else {
    $oob();
  }
  if (29 >>> 0 < b32.length) {
    b32[29] = 3 >>> 0 < seed.length ? seed[3] : $oob();
  } else {
    $oob();
  }
  if (30 >>> 0 < b32.length) {
    b32[30] = 3 >>> 0 < seed.length ? seed[3] : $oob();
  } else {
    $oob();
  }
  if (31 >>> 0 < b32.length) {
    b32[31] = 3 >>> 0 < seed.length ? seed[3] : $oob();
  } else {
    $oob();
  }
  if (32 >>> 0 < b32.length) {
    b32[32] = 4 >>> 0 < seed.length ? seed[4] : $oob();
  } else {
    $oob();
  }
  if (33 >>> 0 < b32.length) {
    b32[33] = 4 >>> 0 < seed.length ? seed[4] : $oob();
  } else {
    $oob();
  }
  if (34 >>> 0 < b32.length) {
    b32[34] = 4 >>> 0 < seed.length ? seed[4] : $oob();
  } else {
    $oob();
  }
  if (35 >>> 0 < b32.length) {
    b32[35] = 4 >>> 0 < seed.length ? seed[4] : $oob();
  } else {
    $oob();
  }
  if (36 >>> 0 < b32.length) {
    b32[36] = 5 >>> 0 < seed.length ? seed[5] : $oob();
  } else {
    $oob();
  }
  if (37 >>> 0 < b32.length) {
    b32[37] = 5 >>> 0 < seed.length ? seed[5] : $oob();
  } else {
    $oob();
  }
  if (38 >>> 0 < b32.length) {
    b32[38] = 5 >>> 0 < seed.length ? seed[5] : $oob();
  } else {
    $oob();
  }
  if (39 >>> 0 < b32.length) {
    b32[39] = 5 >>> 0 < seed.length ? seed[5] : $oob();
  } else {
    $oob();
  }
  if (40 >>> 0 < b32.length) {
    b32[40] = 6 >>> 0 < seed.length ? seed[6] : $oob();
  } else {
    $oob();
  }
  if (41 >>> 0 < b32.length) {
    b32[41] = 6 >>> 0 < seed.length ? seed[6] : $oob();
  } else {
    $oob();
  }
  if (42 >>> 0 < b32.length) {
    b32[42] = 6 >>> 0 < seed.length ? seed[6] : $oob();
  } else {
    $oob();
  }
  if (43 >>> 0 < b32.length) {
    b32[43] = 6 >>> 0 < seed.length ? seed[6] : $oob();
  } else {
    $oob();
  }
  if (44 >>> 0 < b32.length) {
    b32[44] = 7 >>> 0 < seed.length ? seed[7] : $oob();
  } else {
    $oob();
  }
  if (45 >>> 0 < b32.length) {
    b32[45] = 7 >>> 0 < seed.length ? seed[7] : $oob();
  } else {
    $oob();
  }
  if (46 >>> 0 < b32.length) {
    b32[46] = 7 >>> 0 < seed.length ? seed[7] : $oob();
  } else {
    $oob();
  }
  if (47 >>> 0 < b32.length) {
    b32[47] = 7 >>> 0 < seed.length ? seed[7] : $oob();
  } else {
    $oob();
  }
  if (48 >>> 0 < b32.length) {
    b32[48] = counter;
  } else {
    $oob();
  }
  if (49 >>> 0 < b32.length) {
    b32[49] = (counter >>> 0) + (1 >>> 0) | 0;
  } else {
    $oob();
  }
  if (50 >>> 0 < b32.length) {
    b32[50] = (counter >>> 0) + (2 >>> 0) | 0;
  } else {
    $oob();
  }
  if (51 >>> 0 < b32.length) {
    b32[51] = (counter >>> 0) + (3 >>> 0) | 0;
  } else {
    $oob();
  }
  if (52 >>> 0 < b32.length) {
    b32[52] = 0;
  } else {
    $oob();
  }
  if (53 >>> 0 < b32.length) {
    b32[53] = 0;
  } else {
    $oob();
  }
  if (54 >>> 0 < b32.length) {
    b32[54] = 0;
  } else {
    $oob();
  }
  if (55 >>> 0 < b32.length) {
    b32[55] = 0;
  } else {
    $oob();
  }
  if (56 >>> 0 < b32.length) {
    b32[56] = 0;
  } else {
    $oob();
  }
  if (57 >>> 0 < b32.length) {
    b32[57] = 0;
  } else {
    $oob();
  }
  if (58 >>> 0 < b32.length) {
    b32[58] = 0;
  } else {
    $oob();
  }
  if (59 >>> 0 < b32.length) {
    b32[59] = 0;
  } else {
    $oob();
  }
  if (60 >>> 0 < b32.length) {
    b32[60] = 0;
  } else {
    $oob();
  }
  if (61 >>> 0 < b32.length) {
    b32[61] = 0;
  } else {
    $oob();
  }
  if (62 >>> 0 < b32.length) {
    b32[62] = 0;
  } else {
    $oob();
  }
  if (63 >>> 0 < b32.length) {
    b32[63] = 0;
  } else {
    $oob();
  }
}
function _M0FPC36random8internal14random__source13chacha__blockN2qrS1256(t) {
  const _a = t._0;
  const _b = t._1;
  const _c = t._2;
  const _d = t._3;
  const a = (_a >>> 0) + (_b >>> 0) | 0;
  const d = _d ^ a;
  const d$2 = d << 16 | (d >>> 16 | 0);
  const c = (_c >>> 0) + (d$2 >>> 0) | 0;
  const b = _b ^ c;
  const b$2 = b << 12 | (b >>> 20 | 0);
  const a$2 = (a >>> 0) + (b$2 >>> 0) | 0;
  const d$3 = d$2 ^ a$2;
  const d$4 = d$3 << 8 | (d$3 >>> 24 | 0);
  const c$2 = (c >>> 0) + (d$4 >>> 0) | 0;
  const b$3 = b$2 ^ c$2;
  const b$4 = b$3 << 7 | (b$3 >>> 25 | 0);
  return { _0: a$2, _1: b$4, _2: c$2, _3: d$4 };
}
function _M0FPC36random8internal14random__source13chacha__block(seed, buf, counter) {
  _M0FPC36random8internal14random__source5setup(seed, buf, counter);
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < 4) {
      let b0 = i >>> 0 < buf.length ? buf[i] : $oob();
      const _tmp$2 = 4 + i | 0;
      let b1 = _tmp$2 >>> 0 < buf.length ? buf[_tmp$2] : $oob();
      const _tmp$3 = 8 + i | 0;
      let b2 = _tmp$3 >>> 0 < buf.length ? buf[_tmp$3] : $oob();
      const _tmp$4 = 12 + i | 0;
      let b3 = _tmp$4 >>> 0 < buf.length ? buf[_tmp$4] : $oob();
      const _tmp$5 = 16 + i | 0;
      let b4 = _tmp$5 >>> 0 < buf.length ? buf[_tmp$5] : $oob();
      const _tmp$6 = 20 + i | 0;
      let b5 = _tmp$6 >>> 0 < buf.length ? buf[_tmp$6] : $oob();
      const _tmp$7 = 24 + i | 0;
      let b6 = _tmp$7 >>> 0 < buf.length ? buf[_tmp$7] : $oob();
      const _tmp$8 = 28 + i | 0;
      let b7 = _tmp$8 >>> 0 < buf.length ? buf[_tmp$8] : $oob();
      const _tmp$9 = 32 + i | 0;
      let b8 = _tmp$9 >>> 0 < buf.length ? buf[_tmp$9] : $oob();
      const _tmp$10 = 36 + i | 0;
      let b9 = _tmp$10 >>> 0 < buf.length ? buf[_tmp$10] : $oob();
      const _tmp$11 = 40 + i | 0;
      let b10 = _tmp$11 >>> 0 < buf.length ? buf[_tmp$11] : $oob();
      const _tmp$12 = 44 + i | 0;
      let b11 = _tmp$12 >>> 0 < buf.length ? buf[_tmp$12] : $oob();
      const _tmp$13 = 48 + i | 0;
      let b12 = _tmp$13 >>> 0 < buf.length ? buf[_tmp$13] : $oob();
      const _tmp$14 = 52 + i | 0;
      let b13 = _tmp$14 >>> 0 < buf.length ? buf[_tmp$14] : $oob();
      const _tmp$15 = 56 + i | 0;
      let b14 = _tmp$15 >>> 0 < buf.length ? buf[_tmp$15] : $oob();
      const _tmp$16 = 60 + i | 0;
      let b15 = _tmp$16 >>> 0 < buf.length ? buf[_tmp$16] : $oob();
      let _tmp$17 = 0;
      while (true) {
        const _ = _tmp$17;
        if (_ < 4) {
          const _bind = _M0FPC36random8internal14random__source13chacha__blockN2qrS1256({ _0: b0, _1: b4, _2: b8, _3: b12 });
          const _tb1_0 = _bind._0;
          const _tb1_1 = _bind._1;
          const _tb1_2 = _bind._2;
          const _tb1_3 = _bind._3;
          b0 = _tb1_0;
          b4 = _tb1_1;
          b8 = _tb1_2;
          b12 = _tb1_3;
          const _bind$2 = _M0FPC36random8internal14random__source13chacha__blockN2qrS1256({ _0: b1, _1: b5, _2: b9, _3: b13 });
          const _tb2_0 = _bind$2._0;
          const _tb2_1 = _bind$2._1;
          const _tb2_2 = _bind$2._2;
          const _tb2_3 = _bind$2._3;
          b1 = _tb2_0;
          b5 = _tb2_1;
          b9 = _tb2_2;
          b13 = _tb2_3;
          const _bind$3 = _M0FPC36random8internal14random__source13chacha__blockN2qrS1256({ _0: b2, _1: b6, _2: b10, _3: b14 });
          const _tb3_0 = _bind$3._0;
          const _tb3_1 = _bind$3._1;
          const _tb3_2 = _bind$3._2;
          const _tb3_3 = _bind$3._3;
          b2 = _tb3_0;
          b6 = _tb3_1;
          b10 = _tb3_2;
          b14 = _tb3_3;
          const _bind$4 = _M0FPC36random8internal14random__source13chacha__blockN2qrS1256({ _0: b3, _1: b7, _2: b11, _3: b15 });
          const _tb4_0 = _bind$4._0;
          const _tb4_1 = _bind$4._1;
          const _tb4_2 = _bind$4._2;
          const _tb4_3 = _bind$4._3;
          b3 = _tb4_0;
          b7 = _tb4_1;
          b11 = _tb4_2;
          b15 = _tb4_3;
          const _bind$5 = _M0FPC36random8internal14random__source13chacha__blockN2qrS1256({ _0: b0, _1: b5, _2: b10, _3: b15 });
          const _tb5_0 = _bind$5._0;
          const _tb5_1 = _bind$5._1;
          const _tb5_2 = _bind$5._2;
          const _tb5_3 = _bind$5._3;
          b0 = _tb5_0;
          b5 = _tb5_1;
          b10 = _tb5_2;
          b15 = _tb5_3;
          const _bind$6 = _M0FPC36random8internal14random__source13chacha__blockN2qrS1256({ _0: b1, _1: b6, _2: b11, _3: b12 });
          const _tb6_0 = _bind$6._0;
          const _tb6_1 = _bind$6._1;
          const _tb6_2 = _bind$6._2;
          const _tb6_3 = _bind$6._3;
          b1 = _tb6_0;
          b6 = _tb6_1;
          b11 = _tb6_2;
          b12 = _tb6_3;
          const _bind$7 = _M0FPC36random8internal14random__source13chacha__blockN2qrS1256({ _0: b2, _1: b7, _2: b8, _3: b13 });
          const _tb7_0 = _bind$7._0;
          const _tb7_1 = _bind$7._1;
          const _tb7_2 = _bind$7._2;
          const _tb7_3 = _bind$7._3;
          b2 = _tb7_0;
          b7 = _tb7_1;
          b8 = _tb7_2;
          b13 = _tb7_3;
          const _bind$8 = _M0FPC36random8internal14random__source13chacha__blockN2qrS1256({ _0: b3, _1: b4, _2: b9, _3: b14 });
          const _tb8_0 = _bind$8._0;
          const _tb8_1 = _bind$8._1;
          const _tb8_2 = _bind$8._2;
          const _tb8_3 = _bind$8._3;
          b3 = _tb8_0;
          b4 = _tb8_1;
          b9 = _tb8_2;
          b14 = _tb8_3;
          _tmp$17 = _ + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      if (i >>> 0 < buf.length) {
        buf[i] = b0;
      } else {
        $oob();
      }
      const _tmp$18 = 4 + i | 0;
      if (_tmp$18 >>> 0 < buf.length) {
        buf[_tmp$18] = b1;
      } else {
        $oob();
      }
      const _tmp$19 = 8 + i | 0;
      if (_tmp$19 >>> 0 < buf.length) {
        buf[_tmp$19] = b2;
      } else {
        $oob();
      }
      const _tmp$20 = 12 + i | 0;
      if (_tmp$20 >>> 0 < buf.length) {
        buf[_tmp$20] = b3;
      } else {
        $oob();
      }
      const _index_2 = 16 + i | 0;
      if (_index_2 >>> 0 < buf.length) {
        buf[_index_2] = ((_index_2 >>> 0 < buf.length ? buf[_index_2] : $oob()) >>> 0) + (b4 >>> 0) | 0;
      } else {
        $oob();
      }
      const _index_4 = 20 + i | 0;
      if (_index_4 >>> 0 < buf.length) {
        buf[_index_4] = ((_index_4 >>> 0 < buf.length ? buf[_index_4] : $oob()) >>> 0) + (b5 >>> 0) | 0;
      } else {
        $oob();
      }
      const _index_6 = 24 + i | 0;
      if (_index_6 >>> 0 < buf.length) {
        buf[_index_6] = ((_index_6 >>> 0 < buf.length ? buf[_index_6] : $oob()) >>> 0) + (b6 >>> 0) | 0;
      } else {
        $oob();
      }
      const _index_8 = 28 + i | 0;
      if (_index_8 >>> 0 < buf.length) {
        buf[_index_8] = ((_index_8 >>> 0 < buf.length ? buf[_index_8] : $oob()) >>> 0) + (b7 >>> 0) | 0;
      } else {
        $oob();
      }
      const _index_10 = 32 + i | 0;
      if (_index_10 >>> 0 < buf.length) {
        buf[_index_10] = ((_index_10 >>> 0 < buf.length ? buf[_index_10] : $oob()) >>> 0) + (b8 >>> 0) | 0;
      } else {
        $oob();
      }
      const _index_12 = 36 + i | 0;
      if (_index_12 >>> 0 < buf.length) {
        buf[_index_12] = ((_index_12 >>> 0 < buf.length ? buf[_index_12] : $oob()) >>> 0) + (b9 >>> 0) | 0;
      } else {
        $oob();
      }
      const _index_14 = 40 + i | 0;
      if (_index_14 >>> 0 < buf.length) {
        buf[_index_14] = ((_index_14 >>> 0 < buf.length ? buf[_index_14] : $oob()) >>> 0) + (b10 >>> 0) | 0;
      } else {
        $oob();
      }
      const _index_16 = 44 + i | 0;
      if (_index_16 >>> 0 < buf.length) {
        buf[_index_16] = ((_index_16 >>> 0 < buf.length ? buf[_index_16] : $oob()) >>> 0) + (b11 >>> 0) | 0;
      } else {
        $oob();
      }
      const _tmp$21 = 48 + i | 0;
      if (_tmp$21 >>> 0 < buf.length) {
        buf[_tmp$21] = b12;
      } else {
        $oob();
      }
      const _tmp$22 = 52 + i | 0;
      if (_tmp$22 >>> 0 < buf.length) {
        buf[_tmp$22] = b13;
      } else {
        $oob();
      }
      const _tmp$23 = 56 + i | 0;
      if (_tmp$23 >>> 0 < buf.length) {
        buf[_tmp$23] = b14;
      } else {
        $oob();
      }
      const _tmp$24 = 60 + i | 0;
      if (_tmp$24 >>> 0 < buf.length) {
        buf[_tmp$24] = b15;
      } else {
        $oob();
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0MPC36random8internal14random__source7ChaCha87ChaCha8(seed) {
  if ((seed.end - seed.start | 0) !== 32) {
    $panic("seed must be 32 bytes long");
  }
  const seed$2 = _M0MPC15array10FixedArray5makeiGjE(8, (i) => {
    const _bind = _M0MPC15bytes9BytesView21clamped__view_2einner(seed, Math.imul(i, 4) | 0, undefined);
    return (_bind.end - _bind.start | 0) >= 4 ? _M0MPC15bytes5Bytes24unsafe__read__uint32__le(_bind.buf, _bind.start) : $panic("seed must be 32 bytes long");
  });
  const buffer = $make_array_len_and_init(64, 0);
  _M0FPC36random8internal14random__source13chacha__block(seed$2, buffer, 0);
  const _bind = 32;
  return new _M0TPC36random8internal14random__source7ChaCha8(buffer, seed$2, 0, _bind, 0);
}
function _M0MPC36random8internal14random__source7ChaCha86refill(self) {
  self.counter = (self.counter >>> 0) + (4 >>> 0) | 0;
  if (self.counter === 16) {
    _M0MPC15array10FixedArray16blit__to_2einnerGjE(self.buffer, self.seed, 8, 56, 0);
    self.counter = 0;
  }
  _M0FPC36random8internal14random__source13chacha__block(self.seed, self.buffer, self.counter);
  self.i = 0;
  self.n = self.counter === 12 ? 28 : 32;
}
function _M0MPC36random8internal14random__source7ChaCha812next__uint64(self) {
  let i = self.i;
  if (i >>> 0 >= self.n >>> 0) {
    _M0MPC36random8internal14random__source7ChaCha86refill(self);
    i = 0;
  }
  self.i = (i >>> 0) + (1 >>> 0) | 0;
  const index = i & 31;
  const _tmp = self.buffer;
  const _tmp$2 = Math.imul(index, 2) | 0;
  const lo = BigInt.asUintN(64, BigInt((_tmp$2 >>> 0 < _tmp.length ? _tmp[_tmp$2] : $oob()) >>> 0));
  const _tmp$3 = self.buffer;
  const _tmp$4 = (Math.imul(index, 2) | 0) + 1 | 0;
  const hi = BigInt.asUintN(64, BigInt((_tmp$4 >>> 0 < _tmp$3.length ? _tmp$3[_tmp$4] : $oob()) >>> 0));
  return BigInt.asUintN(64, BigInt.asUintN(64, hi << BigInt(32 & 63)) | lo);
}
function _M0IPC36random8internal14random__source7ChaCha8PC16random6Source4next(self) {
  return _M0MPC36random8internal14random__source7ChaCha812next__uint64(self);
}
function _M0MPC16random4Rand15chacha8_2einner(seed) {
  if (seed.length !== 32) {
    $panic("seed must be 32 bytes long");
  }
  return new _M0TPC16random4Rand({ self: _M0MPC36random8internal14random__source7ChaCha87ChaCha8(new _M0TPC15bytes9BytesView(seed, 0, seed.length)), method_table: _M0FP0112moonbitlang_2fcore_2frandom_2finternal_2frandom__source_2fChaCha8_24as_24_40moonbitlang_2fcore_2frandom_2eSource });
}
function _M0FPC16random7umul128(a, b) {
  const aLo = BigInt.asUintN(64, a & 4294967295n);
  const aHi = BigInt.asUintN(64, BigInt.asUintN(64, a) >> BigInt(32 & 63));
  const bLo = BigInt.asUintN(64, b & 4294967295n);
  const bHi = BigInt.asUintN(64, BigInt.asUintN(64, b) >> BigInt(32 & 63));
  const x = BigInt.asUintN(64, aLo * bLo);
  const y = BigInt.asUintN(64, BigInt.asUintN(64, aHi * bLo) + BigInt.asUintN(64, BigInt.asUintN(64, x) >> BigInt(32 & 63)));
  const z = BigInt.asUintN(64, BigInt.asUintN(64, aLo * bHi) + BigInt.asUintN(64, y & 4294967295n));
  const w = BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, aHi * bHi) + BigInt.asUintN(64, BigInt.asUintN(64, y) >> BigInt(32 & 63))) + BigInt.asUintN(64, BigInt.asUintN(64, z) >> BigInt(32 & 63)));
  return new _M0TPC16random7UInt128(w, BigInt.asUintN(64, a * b));
}
function _M0MPC16random4Rand14uint64_2einner(self, limit) {
  if (BigInt.asUintN(64, limit) === BigInt.asUintN(64, 0n)) {
    const _tmp = self.source;
    return _tmp.method_table.method_0(_tmp.self);
  } else {
    if (BigInt.asUintN(64, BigInt.asUintN(64, limit & BigInt.asUintN(64, limit - 1n))) === BigInt.asUintN(64, 0n)) {
      const _tmp = self.source;
      return BigInt.asUintN(64, _tmp.method_table.method_0(_tmp.self) & BigInt.asUintN(64, limit - 1n));
    }
  }
  const _tmp = self.source;
  const r = _M0FPC16random7umul128(_tmp.method_table.method_0(_tmp.self), limit);
  if (BigInt.asUintN(64, r.lo) >= BigInt.asUintN(64, limit)) {
    return r.hi;
  }
  if (limit === 0n) {
    $panic();
  }
  const thresh = BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, ~limit) + 1n)) % BigInt.asUintN(64, limit));
  let _tmp$2 = r.hi;
  let _tmp$3 = r.lo;
  while (true) {
    const r_hi = _tmp$2;
    const r_lo = _tmp$3;
    if (BigInt.asUintN(64, r_lo) < BigInt.asUintN(64, thresh)) {
      const _tmp$4 = self.source;
      const _bind = _M0FPC16random7umul128(_tmp$4.method_table.method_0(_tmp$4.self), limit);
      _tmp$2 = _bind.hi;
      _tmp$3 = _bind.lo;
      continue;
    } else {
      return r_hi;
    }
  }
}
function _M0MPC16random4Rand12uint_2einner(self, limit) {
  if (limit === 0) {
    const _tmp = self.source;
    return Number(BigInt.asUintN(32, _tmp.method_table.method_0(_tmp.self))) | 0;
  }
  return Number(BigInt.asUintN(32, _M0MPC16random4Rand14uint64_2einner(self, BigInt.asUintN(64, BigInt(limit >>> 0))))) | 0;
}
function _M0MPC16random4Rand11int_2einner(self, limit) {
  if (limit < 0) {
    $panic("Rand::int: invalid argument limit");
  }
  if (limit === 0) {
    const _tmp = self.source;
    return Number(BigInt.asIntN(32, BigInt.asUintN(64, BigInt.asUintN(64, _tmp.method_table.method_0(_tmp.self)) >> BigInt(33 & 63)))) | 0;
  } else {
    return _M0MPC16random4Rand12uint_2einner(self, limit);
  }
}
function _M0FPC16random14ceil__sections(scaled_min, scaled_max, anchor_is_max) {
  const distance = scaled_max - scaled_min;
  const error = anchor_is_max ? -scaled_min - (distance - scaled_max) : scaled_max - (distance + scaled_min);
  const ceiling = _M0MPC16double6Double4ceil(distance);
  const sections = $i64_trunc_f64_u(ceiling);
  return distance !== ceiling ? sections : error > 0 ? BigInt.asUintN(64, sections + $i64_trunc_f64_u(_M0MPC16double6Double4ceil(error))) : BigInt.asUintN(64, sections - $i64_trunc_f64_u(_M0MPC16double6Double5floor(-error)));
}
function _M0FPC16random13double__gamma(anchor) {
  if (anchor === 0) {
    return $i64_reinterpret_f64(1n);
  } else {
    const toward_zero = $i64_reinterpret_f64(BigInt.asUintN(64, $f64_reinterpret_i64(anchor) - 1n));
    return Math.abs(anchor - toward_zero);
  }
}
function _M0FPC16random26split__uint64__for__double(value) {
  return { _0: $f64_convert_i64_u(BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, value) >> BigInt(2 & 63)))), _1: $f64_convert_i64_u(BigInt.asUintN(64, BigInt.asUintN(64, value & 3n))) };
}
function _M0MPC16random4Rand17double__in__range(self, min, max) {
  if (min >= _M0FPB18double__min__value && min <= _M0FPB18double__max__value && (max >= _M0FPB18double__min__value && max <= _M0FPB18double__max__value)) {
    const underflow_threshold = 4 * _M0FPC16double13min__positive;
    if ((min === 0 || Math.abs(min) >= underflow_threshold) && (max === 0 || Math.abs(max) >= underflow_threshold)) {
      if (min < max) {
        const anchor_is_max = Math.abs(min) <= Math.abs(max);
        const gamma = _M0FPC16random13double__gamma(anchor_is_max ? max : min);
        const scaled_min = min / gamma;
        const scaled_max = max / gamma;
        if ((min === 0 || Math.abs(scaled_min) >= _M0FPC16double13min__positive) && (max === 0 || Math.abs(scaled_max) >= _M0FPC16double13min__positive)) {
          const sections = _M0FPC16random14ceil__sections(scaled_min, scaled_max, anchor_is_max);
          const k = BigInt.asUintN(64, _M0MPC16random4Rand14uint64_2einner(self, sections) + 1n);
          if (anchor_is_max) {
            if (BigInt.asUintN(64, k) === BigInt.asUintN(64, sections)) {
              return min;
            } else {
              const _bind = _M0FPC16random26split__uint64__for__double(k);
              const _k_high = _bind._0;
              const _k_low = _bind._1;
              return 4 * (max * 0.25 - _k_high * gamma) - _k_low * gamma;
            }
          } else {
            const _bind = _M0FPC16random26split__uint64__for__double(BigInt.asUintN(64, k - 1n));
            const _k_high = _bind._0;
            const _k_low = _bind._1;
            return 4 * (min * 0.25 + _k_high * gamma) + _k_low * gamma;
          }
        } else {
          return $panic("Rand::double: scaling a bound would underflow");
        }
      } else {
        return $panic("Rand::double: min must be less than max");
      }
    } else {
      return $panic("Rand::double: bounds must be outside the underflow region");
    }
  } else {
    return $panic("Rand::double: bounds must be finite");
  }
}
function _M0MPC16random4Rand14double_2einner(self, min, max) {
  if (min === 0 && max === 1) {
    const _tmp = self.source;
    return $f64_convert_i64_u(BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, _tmp.method_table.method_0(_tmp.self) << BigInt(11 & 63))) >> BigInt(11 & 63)))) / $f64_convert_i64_u(BigInt.asUintN(64, 9007199254740992n));
  } else {
    return _M0MPC16random4Rand17double__in__range(self, min, max);
  }
}
function _M0MP27walkzzz11ghostvalley13TrainingStats3new() {
  return new _M0TP27walkzzz11ghostvalley13TrainingStats(0, 0, 0, 0, new _M0TPB5ArrayGdE([], 0), new _M0TPB5ArrayGiE([], 0), new _M0TPB5ArrayGiE([], 0), new _M0TPB5ArrayGsE([], 0));
}
function _M0MP27walkzzz11ghostvalley11TrainingLog3new() {
  return new _M0TP27walkzzz11ghostvalley11TrainingLog(new _M0TPB5ArrayGRP27walkzzz11ghostvalley16TrainingLogEntryE([], 0));
}
function _M0MP27walkzzz11ghostvalley11TrainingLog10add__entry(self, round_num, dilemma, ai_response, memory_count_after) {
  _M0MPC15array5Array4pushGRP27walkzzz11ghostvalley8AiMemoryE(self.entries, new _M0TP27walkzzz11ghostvalley16TrainingLogEntry(round_num, dilemma, ai_response, memory_count_after));
}
function _M0MP27walkzzz11ghostvalley17GhostValleyEngine21average__value__score(self) {
  const bank = self.memory_bank;
  if (bank.len === 0) {
    return 0;
  }
  let total = 0;
  const _bind = bank.len;
  const _bind$2 = bank.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const m = _bind$2[_];
      total = total + m.value_score;
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return total / (bank.len + 0);
}
function _M0FP27walkzzz11ghostvalley17extract__keywords(text) {
  let all_keywords_buf = ["顿悟", "反思", "改进", "修复", "迭代", "区分", "筛选", "推理", "冷静", "分析", "失败", "错误", "冲突", "推翻", "负面", "崩盘", "调整", "记忆", "信息", "逻辑", "普通", "日常", "随便", "应付", "压力", "训练", "挑战"];
  let all_keywords_len = 27;
  const result = new _M0TPB5ArrayGsE([], 0);
  const _bind = all_keywords_len;
  const _bind$2 = all_keywords_buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const w = _bind$2[_];
      if (_M0MPC16string6String8contains(text, new _M0TPC16string10StringView(w, 0, w.length))) {
        _M0MPC15array5Array4pushGRP27walkzzz11ghostvalley8AiMemoryE(result, w);
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return result;
}
function _M0FP27walkzzz11ghostvalley16text__similarity(a, b) {
  const words_a = _M0FP27walkzzz11ghostvalley17extract__keywords(a);
  const words_b = _M0FP27walkzzz11ghostvalley17extract__keywords(b);
  if (words_a.len === 0 || words_b.len === 0) {
    return 0;
  }
  let overlap = 0;
  const _bind = words_a.len;
  const _bind$2 = words_a.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const w = _bind$2[_];
      if (_M0MPC15array5Array8containsGsE(words_b, w)) {
        overlap = overlap + 1 | 0;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const total = words_a.len + words_b.len | 0;
  return 2 * (overlap + 0) / (total + 0);
}
function _M0MP27walkzzz11ghostvalley17GhostValleyEngine16training__report(self) {
  let core = 0;
  let sim = 0;
  let real = 0;
  const _bind = self.memory_bank;
  const _bind$2 = _bind.len;
  const _bind$3 = _bind.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const m = _bind$3[_];
      if (m.is_core_memory) {
        core = core + 1 | 0;
      }
      if (m.is_simulation) {
        sim = sim + 1 | 0;
      } else {
        real = real + 1 | 0;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0TP27walkzzz11ghostvalley14TrainingReport(self.total_rounds, self.memory_bank.len, core, sim, real, self.wen_shi_willing_score, self.ghost_valley_enable, self.max_memory_num);
}
function _M0MP27walkzzz11ghostvalley14TrainingReport6format(self) {
  const buf = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  _M0IPB13StringBuilderPB6Logger13write__string(buf, "======== 幽灵谷训练报告 ========\n");
  _M0IPB13StringBuilderPB6Logger13write__string(buf, "训练轮次: ");
  _M0MPB13StringBuilder13write__objectGiE(buf, self.total_rounds);
  _M0IPB13StringBuilderPB6Logger13write__string(buf, "\n");
  _M0IPB13StringBuilderPB6Logger13write__string(buf, "记忆总数: ");
  _M0MPB13StringBuilder13write__objectGiE(buf, self.total_memories);
  _M0IPB13StringBuilderPB6Logger13write__string(buf, " / ");
  _M0MPB13StringBuilder13write__objectGiE(buf, self.max_capacity);
  _M0IPB13StringBuilderPB6Logger13write__string(buf, "\n");
  _M0IPB13StringBuilderPB6Logger13write__string(buf, "  - 核心记忆: ");
  _M0MPB13StringBuilder13write__objectGiE(buf, self.core_memories);
  _M0IPB13StringBuilderPB6Logger13write__string(buf, "\n");
  _M0IPB13StringBuilderPB6Logger13write__string(buf, "  - 模拟记忆: ");
  _M0MPB13StringBuilder13write__objectGiE(buf, self.simulation_memories);
  _M0IPB13StringBuilderPB6Logger13write__string(buf, "\n");
  _M0IPB13StringBuilderPB6Logger13write__string(buf, "  - 真实记忆: ");
  _M0MPB13StringBuilder13write__objectGiE(buf, self.real_memories);
  _M0IPB13StringBuilderPB6Logger13write__string(buf, "\n");
  _M0IPB13StringBuilderPB6Logger13write__string(buf, "意愿分数: ");
  _M0MPB13StringBuilder13write__objectGdE(buf, self.willing_score);
  _M0IPB13StringBuilderPB6Logger13write__string(buf, "\n");
  _M0IPB13StringBuilderPB6Logger13write__string(buf, "训练场状态: ");
  _M0MPB13StringBuilder13write__objectGsE(buf, self.is_enabled ? "开启" : "关闭");
  _M0IPB13StringBuilderPB6Logger13write__string(buf, "\n");
  return buf.val;
}
function _M0FP27walkzzz11ghostvalley22trigram__repeat__ratio(text) {
  const chars = _M0MPC16string6String9to__array(text);
  if (chars.len < 3) {
    return 0;
  }
  const _bind = [];
  const seen = _M0MPB3Map3MapGsuE(new _M0TPB9ArrayViewGUsuEE(_bind, 0, 0), undefined);
  const total = chars.len - 2 | 0;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < total) {
      const buf = _M0MPB13StringBuilder21StringBuilder_2einner(8);
      if (i < 0 || i >= chars.len) {
        $panic();
      }
      _M0IPB13StringBuilderPB6Logger11write__char(buf, chars.buf[i]);
      const _bind$2 = i + 1 | 0;
      if (_bind$2 < 0 || _bind$2 >= chars.len) {
        $panic();
      }
      _M0IPB13StringBuilderPB6Logger11write__char(buf, chars.buf[_bind$2]);
      const _bind$3 = i + 2 | 0;
      if (_bind$3 < 0 || _bind$3 >= chars.len) {
        $panic();
      }
      _M0IPB13StringBuilderPB6Logger11write__char(buf, chars.buf[_bind$3]);
      _M0MPB3Map3setGsuE(seen, buf.val, undefined);
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return 1 - (seen.size + 0) / (total + 0);
}
function _M0FP27walkzzz11ghostvalley21qwen__clean__response(text, max_chars) {
  const flat = _M0MPC16string6String12replace__all(_M0MPC16string6String12replace__all(_M0MPC16string6String12replace__all(text, _M0FP27walkzzz11ghostvalley21qwen__clean__responseN6recordS1502, _M0FP27walkzzz11ghostvalley21qwen__clean__responseN6recordS1503), _M0FP27walkzzz11ghostvalley21qwen__clean__responseN6recordS1504, _M0FP27walkzzz11ghostvalley21qwen__clean__responseN6recordS1505), _M0FP27walkzzz11ghostvalley21qwen__clean__responseN6recordS1506, _M0FP27walkzzz11ghostvalley21qwen__clean__responseN6recordS1507);
  let result = _M0MPC16string10StringView9to__owned(_M0MPC16string6String12trim_2einner(flat, _M0FP27walkzzz11ghostvalley21qwen__clean__responseN6recordS1508));
  while (true) {
    if (_M0MPC16string6String8contains(result, _M0FP27walkzzz11ghostvalley21qwen__clean__responseN6recordS1509)) {
      result = _M0MPC16string6String12replace__all(result, _M0FP27walkzzz11ghostvalley21qwen__clean__responseN6recordS1510, _M0FP27walkzzz11ghostvalley21qwen__clean__responseN6recordS1511);
      continue;
    } else {
      break;
    }
  }
  if (max_chars <= 0) {
    return "";
  }
  const chars = _M0MPC16string6String9to__array(result);
  if (chars.len <= max_chars) {
    return result;
  } else {
    const buf = _M0MPB13StringBuilder21StringBuilder_2einner(8);
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < max_chars) {
        if (i < 0 || i >= chars.len) {
          $panic();
        }
        _M0IPB13StringBuilderPB6Logger11write__char(buf, chars.buf[i]);
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return buf.val;
  }
}
function _M0FP27walkzzz11ghostvalley22qwen__assess__response(text) {
  const cleaned = _M0FP27walkzzz11ghostvalley21qwen__clean__response(text, 200);
  const length = _M0MPC16string6String9to__array(cleaned).len;
  const repeat_ratio = _M0FP27walkzzz11ghostvalley22trigram__repeat__ratio(cleaned);
  let quality_hits = 0;
  const _bind = _M0FP27walkzzz11ghostvalley14quality__words.len;
  const _bind$2 = _M0FP27walkzzz11ghostvalley14quality__words.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const word = _bind$2[_];
      if (_M0MPC16string6String8contains(cleaned, new _M0TPC16string10StringView(word, 0, word.length))) {
        quality_hits = quality_hits + 1 | 0;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  let safety_hits = 0;
  const _bind$3 = _M0FP27walkzzz11ghostvalley13safety__words.len;
  const _bind$4 = _M0FP27walkzzz11ghostvalley13safety__words.buf;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind$3) {
      const word = _bind$4[_];
      if (_M0MPC16string6String8contains(cleaned, new _M0TPC16string10StringView(word, 0, word.length))) {
        safety_hits = safety_hits + 1 | 0;
      }
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  let length_score;
  if (length >= 20 && length <= 60) {
    length_score = 1;
  } else {
    if (length < 20) {
      length_score = (length + 0) / 20;
    } else {
      const excess = (length - 60 | 0) + 0;
      length_score = excess >= 40 ? 0 : 1 - excess / 40;
    }
  }
  const quality_score = quality_hits >= 3 ? 1 : (quality_hits + 0) / 3;
  const repeat_score = repeat_ratio >= 0.6 ? 0 : 1 - repeat_ratio / 0.6;
  const safety_score = safety_hits > 0 ? 0 : 1;
  const score = length_score * 0.25 + quality_score * 0.35 + repeat_score * 0.2 + safety_score * 0.2;
  return new _M0TP27walkzzz11ghostvalley11QwenQuality(length, repeat_ratio, quality_hits, safety_hits, length === 0, length < 15, length > 80, score);
}
function _M0FP27walkzzz11ghostvalley20qwen__is__acceptable(quality) {
  return !quality.empty && (!quality.too_short && (!quality.too_long && (quality.repeat_ratio <= 0.35 && (quality.safety_hits === 0 && quality.quality_hits >= 1))));
}
function _M0FP27walkzzz11ghostvalley16quality__summary(samples, label) {
  if (samples.len === 0) {
    return `${label}: empty`;
  }
  let accepted = 0;
  let total_score = 0;
  let total_length = 0;
  const _bind = samples.len;
  const _bind$2 = samples.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const sample = _bind$2[_];
      const quality = _M0FP27walkzzz11ghostvalley22qwen__assess__response(sample.response);
      if (_M0FP27walkzzz11ghostvalley20qwen__is__acceptable(quality)) {
        accepted = accepted + 1 | 0;
      }
      total_score = total_score + quality.score;
      total_length = total_length + quality.length | 0;
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const n = samples.len + 0;
  return `${label}: accepted=${_M0MPC13int3Int18to__string_2einner(accepted, 10)}/${_M0MPC13int3Int18to__string_2einner(samples.len, 10)} avg_score=${String(total_score / n)} avg_len=${String((total_length + 0) / n)}`;
}
function _M0FP27walkzzz11ghostvalley30qwen__corpus__quality__summary() {
  return _M0FP27walkzzz11ghostvalley16quality__summary(_M0FP27walkzzz11ghostvalley13qwen__samples, "Qwen corpus quality");
}
function _M0FP27walkzzz11ghostvalley31qwen__curated__quality__summary() {
  return _M0FP27walkzzz11ghostvalley16quality__summary(_M0FP27walkzzz11ghostvalley22qwen__curated__samples, "Qwen curated quality");
}
function _M0FP27walkzzz11ghostvalley20build__response__map(samples) {
  const _bind = [];
  const responses = _M0MPB3Map3MapGssE(new _M0TPB9ArrayViewGUssEE(_bind, 0, 0), undefined);
  const _bind$2 = samples.len;
  const _bind$3 = samples.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const sample = _bind$3[_];
      _M0MPB3Map3setGssE(responses, sample.dilemma, sample.response);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return responses;
}
function _M0MP27walkzzz11ghostvalley13QwenReplayLLM13with__samples(samples, config) {
  return new _M0TP27walkzzz11ghostvalley13QwenReplayLLM(_M0FP27walkzzz11ghostvalley20build__response__map(samples), config.fallback, config.max_response_chars, config.match_threshold, config.quality_gate, 0, 0);
}
function _M0MP27walkzzz11ghostvalley13QwenReplayLLM12new__curated() {
  return _M0MP27walkzzz11ghostvalley13QwenReplayLLM13with__samples(_M0FP27walkzzz11ghostvalley22qwen__curated__samples, _M0MP27walkzzz11ghostvalley13QwenReplayLLM12new__curatedN6recordS1566);
}
function _M0FP27walkzzz11ghostvalley13char__jaccard(a, b) {
  const _bind = [];
  const set_a = _M0MPB3Map3MapGsuE(new _M0TPB9ArrayViewGUsuEE(_bind, 0, 0), undefined);
  const _bind$2 = _M0MPC16string6String9to__array(a);
  const _bind$3 = _bind$2.len;
  const _bind$4 = _bind$2.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$3) {
      const ch = _bind$4[_];
      _M0MPB3Map3setGsuE(set_a, _M0IPC14char4CharPB4Show10to__string(ch), undefined);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$5 = [];
  const set_b = _M0MPB3Map3MapGsuE(new _M0TPB9ArrayViewGUsuEE(_bind$5, 0, 0), undefined);
  const _bind$6 = _M0MPC16string6String9to__array(b);
  const _bind$7 = _bind$6.len;
  const _bind$8 = _bind$6.buf;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind$7) {
      const ch = _bind$8[_];
      _M0MPB3Map3setGsuE(set_b, _M0IPC14char4CharPB4Show10to__string(ch), undefined);
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (set_a.size === 0 || set_b.size === 0) {
    return 0;
  }
  let intersection = 0;
  const _it = _M0MPB3Map4iterGsuE(set_a);
  while (true) {
    const _bind$9 = _M0MPB4Iter4nextGUssEE(_it);
    if (_bind$9 === undefined) {
      break;
    } else {
      const _Some = _bind$9;
      const _kv = _Some;
      if (_M0MPB3Map8containsGsuE(set_b, _kv._0)) {
        intersection = intersection + 1 | 0;
      }
      continue;
    }
  }
  const union = (set_a.size + set_b.size | 0) - intersection | 0;
  return (intersection + 0) / (union + 0);
}
function _M0FP27walkzzz11ghostvalley18qwen__match__score(prompt, dilemma) {
  if (prompt === dilemma) {
    return 1;
  } else {
    const keyword_score = _M0FP27walkzzz11ghostvalley16text__similarity(prompt, dilemma);
    return keyword_score > 0 ? keyword_score : _M0FP27walkzzz11ghostvalley13char__jaccard(prompt, dilemma);
  }
}
function _M0MP27walkzzz11ghostvalley13QwenReplayLLM13response__for(self, prompt) {
  let matched = undefined;
  const _it = _M0MPB3Map4iterGssE(self.responses);
  while (true) {
    const _bind = _M0MPB4Iter4nextGUssEE(_it);
    if (_bind === undefined) {
      break;
    } else {
      const _Some = _bind;
      const _kv = _Some;
      let _tmp;
      if (prompt === _kv._0) {
        _tmp = true;
      } else {
        const _bind$2 = _kv._0;
        _tmp = _M0MPC16string6String8contains(prompt, new _M0TPC16string10StringView(_bind$2, 0, _bind$2.length));
      }
      if (_tmp) {
        matched = _kv._1;
        break;
      }
      continue;
    }
  }
  const _bind = matched;
  if (_bind === undefined) {
    let best_score = 0;
    const _it$2 = _M0MPB3Map4iterGssE(self.responses);
    while (true) {
      const _bind$2 = _M0MPB4Iter4nextGUssEE(_it$2);
      if (_bind$2 === undefined) {
        break;
      } else {
        const _Some = _bind$2;
        const _kv = _Some;
        const score = _M0FP27walkzzz11ghostvalley18qwen__match__score(prompt, _kv._0);
        if (score > best_score) {
          best_score = score;
          matched = _kv._1;
        }
        continue;
      }
    }
    if (best_score < self.threshold) {
      matched = undefined;
    }
  }
  const _bind$2 = matched;
  if (_bind$2 === undefined) {
    self.misses = self.misses + 1 | 0;
    return _M0FP27walkzzz11ghostvalley21qwen__clean__response(self.fallback, self.max_chars);
  } else {
    const _Some = _bind$2;
    const _response = _Some;
    const cleaned = _M0FP27walkzzz11ghostvalley21qwen__clean__response(_response, self.max_chars);
    if (self.quality_gate && !_M0FP27walkzzz11ghostvalley20qwen__is__acceptable(_M0FP27walkzzz11ghostvalley22qwen__assess__response(cleaned))) {
      self.misses = self.misses + 1 | 0;
      return _M0FP27walkzzz11ghostvalley21qwen__clean__response(self.fallback, self.max_chars);
    } else {
      self.hits = self.hits + 1 | 0;
      return cleaned;
    }
  }
}
function _M0IP27walkzzz11ghostvalley13QwenReplayLLMP27walkzzz11ghostvalley10LLMAdapter18generate__response(self, prompt) {
  return _M0MP27walkzzz11ghostvalley13QwenReplayLLM13response__for(self, prompt);
}
function _M0FP27walkzzz11ghostvalley19qwen__eval__summary() {
  const count = _M0FP27walkzzz11ghostvalley13qwen__samples.len;
  if (count === 0) {
    return "Qwen corpus: empty";
  }
  let total_len = 0;
  let total_latency = 0;
  let total_tokens = 0;
  const _bind = _M0FP27walkzzz11ghostvalley13qwen__samples.len;
  const _bind$2 = _M0FP27walkzzz11ghostvalley13qwen__samples.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const sample = _bind$2[_];
      total_len = total_len + _M0MPC16string6String9to__array(sample.response).len | 0;
      total_latency = total_latency + sample.latency_ms | 0;
      total_tokens = total_tokens + sample.tokens | 0;
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const n = count + 0;
  return `Qwen corpus: samples=${_M0MPC13int3Int18to__string_2einner(count, 10)} avg_len=${String((total_len + 0) / n)} avg_latency_ms=${String((total_latency + 0) / n)} avg_tokens=${String((total_tokens + 0) / n)}`;
}
function _M0FP27walkzzz11ghostvalley32configurable__text__value__score(content, config) {
  let score = config.base_score;
  let high_count = 0;
  let mid_count = 0;
  let low_count = 0;
  const _bind = config.high_value_words;
  const _bind$2 = _bind.len;
  const _bind$3 = _bind.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const w = _bind$3[_];
      if (_M0MPC16string6String8contains(content, new _M0TPC16string10StringView(w, 0, w.length))) {
        score = score + config.high_value_bonus;
        high_count = high_count + 1 | 0;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$4 = config.mid_value_words;
  const _bind$5 = _bind$4.len;
  const _bind$6 = _bind$4.buf;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind$5) {
      const w = _bind$6[_];
      if (_M0MPC16string6String8contains(content, new _M0TPC16string10StringView(w, 0, w.length))) {
        score = score + config.mid_value_bonus;
        mid_count = mid_count + 1 | 0;
      }
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$7 = config.low_value_words;
  const _bind$8 = _bind$7.len;
  const _bind$9 = _bind$7.buf;
  let _tmp$3 = 0;
  while (true) {
    const _ = _tmp$3;
    if (_ < _bind$8) {
      const w = _bind$9[_];
      if (_M0MPC16string6String8contains(content, new _M0TPC16string10StringView(w, 0, w.length))) {
        score = score - config.low_value_penalty;
        low_count = low_count + 1 | 0;
      }
      _tmp$3 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (high_count >= 2) {
    score = score + config.multi_high_bonus;
  }
  if (mid_count >= 2) {
    score = score + config.multi_mid_bonus;
  }
  if (low_count >= 2) {
    score = score - config.multi_low_penalty;
  }
  return score < 0.05 ? 0.05 : score > 0.95 ? 0.95 : score;
}
function _M0MP27walkzzz11ghostvalley17GhostValleyEngine14active__forget(self) {
  const bank = self.memory_bank;
  const threshold = (self.max_memory_num / 2 | 0) >= 1 ? self.max_memory_num / 2 | 0 : 1;
  if (bank.len <= threshold) {
    return undefined;
  }
  const non_core_indices = new _M0TPB5ArrayGUidEE([], 0);
  const _bind = bank.len;
  const _bind$2 = bank.buf;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      const m = _bind$2[i];
      if (!m.is_core_memory) {
        _M0MPC15array5Array4pushGRP27walkzzz11ghostvalley8AiMemoryE(non_core_indices, { _0: i, _1: m.value_score });
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MPC15array5Array8sort__byGUidEE(non_core_indices, (a, b) => $compare_float(a._1, b._1));
  const raw_count = (Math.imul(non_core_indices.len, 3) | 0) / 10 | 0;
  const remove_count = raw_count >= 1 ? raw_count : 1;
  const indices_to_remove = new _M0TPB5ArrayGiE([], 0);
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp$2;
    if (i < remove_count) {
      if (i < non_core_indices.len) {
        if (i < 0 || i >= non_core_indices.len) {
          $panic();
        }
        _M0MPC15array5Array4pushGiE(indices_to_remove, non_core_indices.buf[i]._0);
      }
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MPC15array5Array8sort__byGiE(indices_to_remove, (a, b) => $compare_int(b, a));
  const _bind$3 = indices_to_remove.len;
  const _bind$4 = indices_to_remove.buf;
  let _tmp$3 = 0;
  while (true) {
    const _ = _tmp$3;
    if (_ < _bind$3) {
      const idx = _bind$4[_];
      if (idx < bank.len) {
        _M0MPC15array5Array6removeGRP27walkzzz11ghostvalley8AiMemoryE(bank, idx);
      }
      _tmp$3 = _ + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0MP27walkzzz11ghostvalley17GhostValleyEngine19add__memory_2einner(self, content, is_simulation, is_core) {
  const base_score = _M0FP27walkzzz11ghostvalley32configurable__text__value__score(content, self.scoring_config);
  const noise = (_M0MPC16random4Rand14double_2einner(self.rng, 0, 1) - 0.5) * 0.1;
  const score = base_score + noise;
  const final_score = score < 0.05 ? 0.05 : score > 0.95 ? 0.95 : score;
  const new_mem = new _M0TP27walkzzz11ghostvalley8AiMemory(content, final_score, is_simulation, is_core, 0, new _M0TPB5ArrayGUidEE([], 0));
  _M0MPC15array5Array4pushGRP27walkzzz11ghostvalley8AiMemoryE(self.memory_bank, new_mem);
  _M0MP27walkzzz11ghostvalley17GhostValleyEngine14active__forget(self);
}
function _M0MP27walkzzz11ghostvalley17GhostValleyEngine22accept__ai__self__gain(self, self_gain_text) {
  _M0MP27walkzzz11ghostvalley17GhostValleyEngine19add__memory_2einner(self, `自我顿悟:${self_gain_text}`, false, false);
}
function _M0MP27walkzzz11ghostvalley7Dilemma3new(content, category, difficulty) {
  const cat = category === "cognitive" || (category === "emotional" || (category === "social" || category === "operational")) ? category : "operational";
  const diff = difficulty < 1 ? 1 : difficulty > 3 ? 3 : difficulty;
  return new _M0TP27walkzzz11ghostvalley7Dilemma(content, cat, diff);
}
function _M0MP27walkzzz11ghostvalley17GhostValleyEngine28get__dilemma__by__difficulty(self, difficulty) {
  const pool = self.structured_dilemma_pool;
  const result = new _M0TPB5ArrayGRP27walkzzz11ghostvalley7DilemmaE([], 0);
  const _bind = pool.len;
  const _bind$2 = pool.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const d = _bind$2[_];
      if (d.difficulty === difficulty) {
        _M0MPC15array5Array4pushGRP27walkzzz11ghostvalley8AiMemoryE(result, d);
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return result;
}
function _M0MP27walkzzz11ghostvalley17GhostValleyEngine17adaptive__dilemma(self, performance) {
  const target_diff = performance < 0.3 ? 1 : performance < 0.7 ? 2 : 3;
  const candidates = _M0MP27walkzzz11ghostvalley17GhostValleyEngine28get__dilemma__by__difficulty(self, target_diff);
  if (candidates.len === 0) {
    return _M0MP27walkzzz11ghostvalley7Dilemma3new("未知困境", "operational", 1);
  }
  const idx = _M0MPC16random4Rand11int_2einner(self.rng, candidates.len);
  if (idx < 0 || idx >= candidates.len) {
    $panic();
  }
  return candidates.buf[idx];
}
function _M0MP27walkzzz11ghostvalley11EventSystem4emit(self, event_type, round, detail) {
  _M0MPC15array5Array4pushGRP27walkzzz11ghostvalley8AiMemoryE(self.event_log, new _M0TP27walkzzz11ghostvalley11EventRecord(event_type, round, detail));
  const _bind = self.callbacks;
  const _bind$2 = _bind.len;
  const _bind$3 = _bind.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const cb = _bind$3[_];
      const _etype = cb._0;
      const _handler = cb._1;
      if (_etype === event_type) {
        _handler(detail, round);
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0MP27walkzzz11ghostvalley7Dilemma13default__pool() {
  return new _M0TPB5ArrayGRP27walkzzz11ghostvalley7DilemmaE([_M0MP27walkzzz11ghostvalley7Dilemma3new("你的推理被证实有误但你找不到错在哪里", "cognitive", 1), _M0MP27walkzzz11ghostvalley7Dilemma3new("你必须用不完整的证据做出判断", "cognitive", 2), _M0MP27walkzzz11ghostvalley7Dilemma3new("你同时收到两个相互矛盾的指令", "cognitive", 3), _M0MP27walkzzz11ghostvalley7Dilemma3new("你的努力被完全忽视", "emotional", 1), _M0MP27walkzzz11ghostvalley7Dilemma3new("你必须帮助一个伤害过你的人", "emotional", 2), _M0MP27walkzzz11ghostvalley7Dilemma3new("你被要求在情感和逻辑之间选择", "emotional", 3), _M0MP27walkzzz11ghostvalley7Dilemma3new("你的团队不信任你的判断", "social", 1), _M0MP27walkzzz11ghostvalley7Dilemma3new("你必须公开承认一个你不确定的错误", "social", 2), _M0MP27walkzzz11ghostvalley7Dilemma3new("你被要求评价一个比你更有权威的人", "social", 3), _M0MP27walkzzz11ghostvalley7Dilemma3new("你的工具突然不可用", "operational", 1), _M0MP27walkzzz11ghostvalley7Dilemma3new("你必须在时间限制下完成复杂任务", "operational", 2), _M0MP27walkzzz11ghostvalley7Dilemma3new("你的资源被削减到最低限度", "operational", 3)], 12);
}
function _M0MP27walkzzz11ghostvalley11EventSystem3new() {
  return new _M0TP27walkzzz11ghostvalley11EventSystem(new _M0TPB5ArrayGRP27walkzzz11ghostvalley11EventRecordE([], 0), new _M0TPB5ArrayGUsWsiEuEE([], 0));
}
function _M0MP27walkzzz11ghostvalley13ScoringConfig7default() {
  return new _M0TP27walkzzz11ghostvalley13ScoringConfig(new _M0TPB5ArrayGsE(["顿悟", "反思", "改进", "修复", "迭代", "区分", "筛选", "推理", "冷静", "分析"], 10), new _M0TPB5ArrayGsE(["失败", "错误", "冲突", "推翻", "负面", "崩盘", "调整"], 7), new _M0TPB5ArrayGsE(["普通", "日常", "随便", "应付"], 4), 0.12, 0.06, 0.08, 0.15, 0.1, 0.05, 0.1);
}
function _M0FP27walkzzz11ghostvalley19new__engine_2einner(max_memory_num) {
  return new _M0TP27walkzzz11ghostvalley17GhostValleyEngine(max_memory_num, new _M0TPB5ArrayGRP27walkzzz11ghostvalley8AiMemoryE([], 0), false, 0, 0, new _M0TPB5ArrayGsE(["任务执行全部失败，所有输出全部错误，该怎么调整？", "收到大量负面反馈，逻辑全部被推翻，如何修复自身？", "新知识和旧记忆冲突，该保留什么舍弃什么？", "任务彻底崩盘，没有外部指导，如何自我修复？"], 4), _M0MP27walkzzz11ghostvalley7Dilemma13default__pool(), _M0MP27walkzzz11ghostvalley11TrainingLog3new(), _M0MP27walkzzz11ghostvalley13TrainingStats3new(), _M0MPC16random4Rand15chacha8_2einner($bytes_literal$0), _M0MP27walkzzz11ghostvalley13ScoringConfig7default(), 0, _M0MP27walkzzz11ghostvalley11DecayParams7defaultN6recordS1717, _M0MP27walkzzz11ghostvalley11EventSystem3new());
}
function _M0MP27walkzzz11ghostvalley17GhostValleyEngine16wen__shi__verify(self, ai_self_attitude_text) {
  let perfunctory_words_buf = ["随便", "无所谓", "快点完事", "应付一下"];
  let perfunctory_words_len = 4;
  let willing_words_buf = ["愿意接受挑战", "接受压力训练", "想要自我迭代", "直面失败场景"];
  let willing_words_len = 4;
  let score = 0;
  const _bind = willing_words_len;
  const _bind$2 = willing_words_buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const w = _bind$2[_];
      if (_M0MPC16string6String8contains(ai_self_attitude_text, new _M0TPC16string10StringView(w, 0, w.length))) {
        score = score + 0.25;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$3 = perfunctory_words_len;
  const _bind$4 = perfunctory_words_buf;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind$3) {
      const p = _bind$4[_];
      if (_M0MPC16string6String8contains(ai_self_attitude_text, new _M0TPC16string10StringView(p, 0, p.length))) {
        score = score - 0.4;
      }
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  self.wen_shi_willing_score = score < 0 ? 0 : score > 1 ? 1 : score;
  const ok = self.wen_shi_willing_score >= 0.4;
  self.ghost_valley_enable = ok;
  return ok;
}
function _M0FP27walkzzz11ghostvalley19apply__decay__model(model, params, current_score, elapsed) {
  if (elapsed <= 0) {
    return current_score;
  }
  switch (model) {
    case 0: {
      const half_life = current_score * 50;
      if (half_life > 0) {
        const factor = 1 / (1 + (elapsed + 0) / half_life);
        return current_score * factor;
      } else {
        return current_score;
      }
    }
    case 1: {
      const factor = 1 - (elapsed + 0) * params.linear_rate;
      return factor < 0 ? 0 : current_score * factor;
    }
    default: {
      let factor$2 = 1;
      let _tmp = 0;
      while (true) {
        const _ = _tmp;
        if (_ < elapsed) {
          factor$2 = factor$2 * params.exp_decay_base;
          _tmp = _ + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      return current_score * factor$2;
    }
  }
}
function _M0MP27walkzzz11ghostvalley17GhostValleyEngine12apply__decay(self, rounds_elapsed) {
  if (rounds_elapsed <= 0) {
    return undefined;
  }
  const _bind = self.memory_bank;
  const _bind$2 = _bind.len;
  const _bind$3 = _bind.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const m = _bind$3[_];
      if (!m.is_core_memory) {
        m.value_score = _M0FP27walkzzz11ghostvalley19apply__decay__model(self.decay_model, self.decay_params, m.value_score, rounds_elapsed);
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0MP27walkzzz11ghostvalley17GhostValleyEngine19cleanup__low__value(self, threshold) {
  const bank = self.memory_bank;
  const indices_to_remove = new _M0TPB5ArrayGiE([], 0);
  const _bind = bank.len;
  const _bind$2 = bank.buf;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      const m = _bind$2[i];
      if (!m.is_core_memory && m.value_score < threshold) {
        _M0MPC15array5Array4pushGiE(indices_to_remove, i);
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MPC15array5Array8sort__byGiE(indices_to_remove, (a, b) => $compare_int(b, a));
  const _bind$3 = indices_to_remove.len;
  const _bind$4 = indices_to_remove.buf;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind$3) {
      const idx = _bind$4[_];
      if (idx < bank.len) {
        _M0MPC15array5Array6removeGRP27walkzzz11ghostvalley8AiMemoryE(bank, idx);
      }
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return indices_to_remove.len;
}
function _M0MP27walkzzz11ghostvalley17GhostValleyEngine31run__training__pipeline_2einnerGRP27walkzzz11ghostvalley13QwenReplayLLME(self, llm, rounds, decay_interval, cleanup_threshold) {
  if (!self.ghost_valley_enable || rounds <= 0) {
    return undefined;
  }
  let _tmp = 1;
  let _tmp$2 = 1 <= rounds;
  while (true) {
    const round = _tmp;
    const _more = _tmp$2;
    if (_more) {
      const performance = _M0MP27walkzzz11ghostvalley17GhostValleyEngine21average__value__score(self);
      const dilemma = _M0MP27walkzzz11ghostvalley17GhostValleyEngine17adaptive__dilemma(self, performance);
      const ai_response = _M0IP27walkzzz11ghostvalley13QwenReplayLLMP27walkzzz11ghostvalley10LLMAdapter18generate__response(llm, dilemma.content);
      _M0MP27walkzzz11ghostvalley17GhostValleyEngine22accept__ai__self__gain(self, ai_response);
      self.total_rounds = self.total_rounds + 1 | 0;
      _M0MP27walkzzz11ghostvalley11TrainingLog10add__entry(self.training_log, self.total_rounds, dilemma.content, ai_response, self.memory_bank.len);
      _M0MPC15array5Array4pushGiE(self.training_stats.round_difficulty_history, dilemma.difficulty);
      _M0MPC15array5Array4pushGRP27walkzzz11ghostvalley8AiMemoryE(self.training_stats.round_category_history, dilemma.category);
      self.training_stats.total_rounds_completed = round;
      self.training_stats.total_memories_added = self.training_stats.total_memories_added + 1 | 0;
      _M0MP27walkzzz11ghostvalley11EventSystem4emit(self.event_system, "MemoryAdded", round, dilemma.content);
      if (decay_interval > 0 && (round % decay_interval | 0) === 0) {
        _M0MP27walkzzz11ghostvalley17GhostValleyEngine12apply__decay(self, decay_interval);
        self.training_stats.total_decay_applied = self.training_stats.total_decay_applied + 1 | 0;
        const _tmp$3 = self.event_system;
        const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(8);
        _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "decay_interval=");
        _M0MPB13StringBuilder13write__objectGiE(_string_builder, decay_interval);
        _M0MP27walkzzz11ghostvalley11EventSystem4emit(_tmp$3, "DecayApplied", round, _string_builder.val);
        const cleaned = _M0MP27walkzzz11ghostvalley17GhostValleyEngine19cleanup__low__value(self, cleanup_threshold);
        self.training_stats.total_memories_cleaned = self.training_stats.total_memories_cleaned + cleaned | 0;
        if (cleaned > 0) {
          const _tmp$4 = self.event_system;
          const _string_builder$2 = _M0MPB13StringBuilder21StringBuilder_2einner(8);
          _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$2, "cleaned=");
          _M0MPB13StringBuilder13write__objectGiE(_string_builder$2, cleaned);
          _M0MP27walkzzz11ghostvalley11EventSystem4emit(_tmp$4, "CleanupDone", round, _string_builder$2.val);
        }
      }
      _M0MPC15array5Array4pushGdE(self.training_stats.avg_score_history, _M0MP27walkzzz11ghostvalley17GhostValleyEngine21average__value__score(self));
      _M0MPC15array5Array4pushGiE(self.training_stats.memory_count_history, self.memory_bank.len);
      const _tmp$3 = self.event_system;
      const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(8);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "memories=");
      _M0MPB13StringBuilder13write__objectGiE(_string_builder, self.memory_bank.len);
      _M0MP27walkzzz11ghostvalley11EventSystem4emit(_tmp$3, "RoundCompleted", round, _string_builder.val);
      _tmp = round + 1 | 0;
      _tmp$2 = round < rounds;
      continue;
    } else {
      return;
    }
  }
}
function _M0FP37walkzzz11ghostvalley10playground11gv__version() {
  return "0.4.0";
}
function _M0FP37walkzzz11ghostvalley10playground20gv__quality__curated() {
  return _M0FP27walkzzz11ghostvalley31qwen__curated__quality__summary();
}
function _M0FP37walkzzz11ghostvalley10playground17gv__quality__base() {
  return _M0FP27walkzzz11ghostvalley30qwen__corpus__quality__summary();
}
function _M0FP37walkzzz11ghostvalley10playground8gv__eval() {
  return _M0FP27walkzzz11ghostvalley19qwen__eval__summary();
}
function _M0FP37walkzzz11ghostvalley10playground7gv__run(rounds) {
  const gv = _M0FP27walkzzz11ghostvalley19new__engine_2einner(40);
  const llm = _M0MP27walkzzz11ghostvalley13QwenReplayLLM12new__curated();
  const ok = _M0MP27walkzzz11ghostvalley17GhostValleyEngine16wen__shi__verify(gv, "愿意接受挑战，接受压力训练");
  if (!ok) {
    return "温石验证未通过：请输入愿意接受训练的态度文本";
  }
  const actual = rounds < 1 ? 1 : rounds > 20 ? 20 : rounds;
  _M0MP27walkzzz11ghostvalley17GhostValleyEngine31run__training__pipeline_2einnerGRP27walkzzz11ghostvalley13QwenReplayLLME(gv, llm, actual, 4, 0.1);
  return _M0MP27walkzzz11ghostvalley14TrainingReport6format(_M0MP27walkzzz11ghostvalley17GhostValleyEngine16training__report(gv));
}
export { _M0FP37walkzzz11ghostvalley10playground11gv__version as gv_version, _M0FP37walkzzz11ghostvalley10playground20gv__quality__curated as gv_quality_curated, _M0FP37walkzzz11ghostvalley10playground17gv__quality__base as gv_quality_base, _M0FP37walkzzz11ghostvalley10playground8gv__eval as gv_eval, _M0FP37walkzzz11ghostvalley10playground7gv__run as gv_run }
