#!/usr/bin/env node
// GhostValley 文档一致性门禁：版本 / 测试数 / 覆盖率 / 变异 / Qwen 材料 / 脚本 / CI。
import { existsSync, readFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const read = (file) => readFileSync(resolve(root, file), "utf8");
const failures = [];
const passes = [];

function check(name, ok, detail) {
  if (ok) passes.push(name);
  else failures.push(`${name}: ${detail}`);
}

const version = read("moon.mod").match(/version\s*=\s*"([^"]+)"/)?.[1] ?? "";
const changelog = read("CHANGELOG.md");
const readme = read("README.mbt.md");
const proposal = read("申报书.md");
const selfCheck = read("自查报告.md");
const testReport = read("docs/TEST_REPORT.md");
const qwenEval = read("docs/QWEN_EVAL.md");
const corpus = read("qwen_corpus.mbt");
const ci = read(".github/workflows/ci.yml");

check(
  "A1 CHANGELOG 最新版本 = moon.mod",
  changelog.includes(`## [${version}]`),
  `moon.mod=${version}`,
);
check("A2 申报书版本 = moon.mod", proposal.includes(`v${version}`), `申报书未写 v${version}`);
check("A3 自查报告版本 = moon.mod", selfCheck.includes(`v${version}`), `自查报告未写 v${version}`);

check("A4 README 测试数 498", readme.includes("498"), "README 未写 498");
check("A5 申报书测试数 498", proposal.includes("498"), "申报书未写 498");
check("A6 自查报告测试数 498", selfCheck.includes("498"), "自查报告未写 498");
check("A7 测试报告测试数 498", testReport.includes("498"), "TEST_REPORT 未写 498");

check("A8 覆盖率 ≥ 90% 记录", testReport.includes("91.6%") && testReport.includes("1281"), "TEST_REPORT 缺覆盖率");
check("A9 变异 12/12 记录", testReport.includes("12 / 12 KILLED") || testReport.includes("12/12 KILLED"), "TEST_REPORT 缺变异");

check("A10 Qwen 评测文档存在", existsSync(resolve(root, "docs/QWEN_EVAL.md")) && qwenEval.includes("Qwen2.5-0.5B"), "缺少 QWEN_EVAL.md");
check("A11 Qwen 语料 12 条", (corpus.match(/dilemma:/g) ?? []).length === 12, "qwen_corpus.mbt 样本数不是 12");
check("A11b Qwen 质量层存在", existsSync(resolve(root, "qwen_quality.mbt")) && read("qwen_quality.mbt").includes("qwen_is_acceptable"), "缺少 qwen_quality.mbt");
check("A11c Qwen 大规模评测报告存在", existsSync(resolve(root, "docs/QWEN_BENCHMARK.md")), "缺少 QWEN_BENCHMARK.md");
check("A12 README 含 QwenReplayLLM", readme.includes("QwenReplayLLM"), "README 缺少 QwenReplayLLM");

for (const script of [
  "scripts/qwen_generate.py",
  "scripts/check_coverage.mjs",
  "scripts/mutation_test.mjs",
  "scripts/check_docs.mjs",
]) {
  check(`A13 脚本存在 ${script}`, existsSync(resolve(root, script)), "文件不存在");
}

check("A14 CI 引用覆盖率门禁", ci.includes("check_coverage.mjs"), "ci.yml 缺 check_coverage.mjs");
check("A15 CI 引用文档门禁", ci.includes("check_docs.mjs"), "ci.yml 缺 check_docs.mjs");
check("A16 CI 四后端测试矩阵", ci.includes("wasm-gc") && ci.includes("native"), "ci.yml 缺目标矩阵");

check("A17 README 含 Qwen 评测链接", readme.includes("docs/QWEN_EVAL.md"), "README 缺 QWEN_EVAL 链接");
check("A18 许可证 Apache-2.0", read("LICENSE").toLowerCase().includes("apache"), "LICENSE 非 Apache-2.0");

console.log(`passed ${passes.length}, failed ${failures.length}`);
if (failures.length > 0) {
  console.error("docs consistency failed:");
  for (const item of failures) console.error(`  - ${item}`);
  process.exit(1);
}
console.log("docs consistency passed");