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

check("A4 README 测试数 503", readme.includes("503"), "README 未写 503");
check("A5 申报书测试数 503", proposal.includes("503"), "申报书未写 503");
check("A6 自查报告测试数 503", selfCheck.includes("503"), "自查报告未写 503");
check("A7 测试报告测试数 503", testReport.includes("503"), "TEST_REPORT 未写 503");

check("A8 覆盖率 ≥ 90% 记录", testReport.includes("91.6%") && testReport.includes("1356"), "TEST_REPORT 缺覆盖率");
check("A9 变异 13/13 记录", testReport.includes("13 / 13 KILLED") || testReport.includes("13/13 KILLED"), "TEST_REPORT 缺变异");

check("A10 Qwen 评测文档存在", existsSync(resolve(root, "docs/QWEN_EVAL.md")) && qwenEval.includes("Qwen2.5-0.5B"), "缺少 QWEN_EVAL.md");
check("A11 Qwen 语料 12 条", (corpus.match(/dilemma:/g) ?? []).length === 12, "qwen_corpus.mbt 样本数不是 12");
check("A11b Qwen 质量层存在", existsSync(resolve(root, "qwen_quality.mbt")) && read("qwen_quality.mbt").includes("qwen_is_acceptable"), "缺少 qwen_quality.mbt");
check("A11c Qwen 大规模评测报告存在", existsSync(resolve(root, "docs/QWEN_BENCHMARK.md")), "缺少 QWEN_BENCHMARK.md");
check("A11d Qwen 精选语料 24 条", existsSync(resolve(root, "qwen_curated.mbt")) && (read("qwen_curated.mbt").match(/dilemma:/g) ?? []).length === 24, "qwen_curated.mbt 不是 24 条");
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

for (const file of [
  "CONTRIBUTING.md",
  "SECURITY.md",
  "CODE_OF_CONDUCT.md",
  "docs/known-gaps.md",
  "docs/MODEL_CARD.md",
  "docs/DATA_CARD.md",
]) {
  check(`A19 立项材料存在 ${file}`, existsSync(resolve(root, file)), "文件不存在");
}
check(
  "A20 Qwen 精选示例存在",
  existsSync(resolve(root, "examples/qwen_curated/moon.pkg")) &&
    existsSync(resolve(root, "examples/qwen_curated/qwen_curated_demo.mbt")),
  "examples/qwen_curated 不完整",
);
check(
  "A21 申报书含 Gitlink / AI 说明 / 3 场景",
  proposal.includes("Gitlink") &&
    proposal.includes("AI 使用说明") &&
    proposal.includes("三个使用场景"),
  "申报书缺少立项关键字段",
);
check("A22 README 含立项材料入口", readme.includes("立项材料："), "README 缺立项材料链接");
const proposalLines = proposal.split("\n").length;
check("A23 申报书 ≤60 行", proposalLines <= 60, `${proposalLines} 行`);
check(
  "A24 语料口径 9/12 + 23/24",
  qwenEval.includes("9/12") && qwenEval.includes("23/24"),
  "QWEN_EVAL 语料口径不一致",
);
check(
  "A25 CI 含 Qwen 精选示例 smoke",
  ci.includes("examples/qwen_curated"),
  "ci.yml 缺示例 smoke",
);

const indexHtml = read("docs/index.html");
const appJs = read("docs/app.js");
const pagesYml = read(".github/workflows/pages.yml");
check(
  "A26 展示页三件套存在",
  existsSync(resolve(root, "docs/index.html")) &&
    existsSync(resolve(root, "docs/app.js")) &&
    existsSync(resolve(root, "docs/style.css")),
  "展示页文件不完整",
);
check(
  "A27 展示页加载 playground.js",
  appJs.includes("./playground.js") && indexHtml.includes("app.js"),
  "app.js 未引用 playground.js",
);
check(
  "A28 Pages workflow 构建 playground",
  pagesYml.includes("playground"),
  "pages.yml 未构建 playground",
);
check(
  "A29 CI 引用 Pages 门禁",
  ci.includes("check_pages.mjs"),
  "ci.yml 缺 check_pages.mjs",
);
for (const file of [
  "docs/FINAL_SCORECARD.md",
  "docs/DEMO_SCRIPT.md",
  "docs/COMPETITIVE_MATRIX.md",
  "docs/TECH_CHALLENGES.md",
  "docs/AI_EVIDENCE.md",
]) {
  check(`A30 决赛材料存在 ${file}`, existsSync(resolve(root, file)), "文件不存在");
}
check(
  "A31 README 含在线演示与决赛材料",
  readme.includes("toadium.github.io/GhostValley") &&
    readme.includes("FINAL_SCORECARD.md"),
  "README 缺在线演示/决赛材料入口",
);

console.log(`passed ${passes.length}, failed ${failures.length}`);
if (failures.length > 0) {
  console.error("docs consistency failed:");
  for (const item of failures) console.error(`  - ${item}`);
  process.exit(1);
}
console.log("docs consistency passed");