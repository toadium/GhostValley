#!/usr/bin/env node
// 变异测试门禁：对核心源码做单点变异，要求全量测试必须失败（KILLED）。
// 用法：node scripts/mutation_test.mjs [--filter M01,M02]
import { spawnSync } from "node:child_process";
import { readFileSync, writeFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const args = process.argv.slice(2);
const filterAt = args.indexOf("--filter");
const filter = filterAt >= 0 ? new Set(args[filterAt + 1].split(",")) : null;

const PKG = "ghostvalley";

const MUTATIONS = [
  {
    id: "M01",
    name: "温石验证阈值 0.4 -> 0.9",
    file: "ghost_valley.mbt",
    find: "let ok = self.wen_shi_willing_score >= 0.4",
    replace: "let ok = self.wen_shi_willing_score >= 0.9",
    pkg: PKG,
  },
  {
    id: "M02",
    name: "主动遗忘永不触发",
    file: "ghost_valley.mbt",
    find: "if bank.length() <= threshold {",
    replace: "if bank.length() <= 0 {",
    pkg: PKG,
  },
  {
    id: "M03",
    name: "Qwen 回放前缀匹配失效",
    file: "qwen_adapter.mbt",
    find: "if prompt == sample.dilemma || prompt.contains(sample.dilemma) {",
    replace: "if prompt == sample.dilemma && prompt.contains(sample.dilemma) {",
    pkg: PKG,
  },
  {
    id: "M04",
    name: "Qwen 清洗不再压缩多空格",
    file: "qwen_adapter.mbt",
    find: `while result.contains("  ") {`,
    replace: "while false {",
    pkg: PKG,
  },
  {
    id: "M05",
    name: "Qwen 相同困境相似度 1.0 -> 0.99",
    file: "qwen_adapter.mbt",
    find: "if prompt == dilemma {\n    1.0",
    replace: "if prompt == dilemma {\n    0.99",
    pkg: PKG,
  },
  {
    id: "M06",
    name: "训练轮次少跑一轮",
    file: "ghost_valley.mbt",
    find: "for round in 1..<=rounds {",
    replace: "for round in 1..<rounds {",
    pkg: PKG,
  },
  {
    id: "M07",
    name: "权重检索排序反转为升序",
    file: "retrieval.mbt",
    find: "scored.sort_by(fn(a, b) { b.0.compare(a.0) })",
    replace: "scored.sort_by(fn(a, b) { a.0.compare(b.0) })",
    pkg: PKG,
  },
  {
    id: "M08",
    name: "清理阈值比较方向反转",
    file: "decay.mbt",
    find: "if !m.is_core_memory && m.value_score < threshold {",
    replace: "if !m.is_core_memory && m.value_score > threshold {",
    pkg: PKG,
  },
  {
    id: "M09",
    name: "对比平局胜者标签错误",
    file: "multi_agent.mbt",
    find: `  } else {
    "tie"
  }`,
    replace: `  } else {
    "unknown"
  }`,
    pkg: PKG,
  },
  {
    id: "M10",
    name: "记忆容量触发阈值翻倍",
    file: "ghost_valley.mbt",
    find: `  let threshold = if self.max_memory_num / 2 >= 1 {
    self.max_memory_num / 2
  } else {
    1
  }`,
    replace: `  let threshold = if self.max_memory_num * 2 >= 1 {
    self.max_memory_num * 2
  } else {
    1
  }`,
    pkg: PKG,
  },
];

function runTests() {
  const result = spawnSync(
    "moon",
    ["test", "--target", "native", "--warn-list", "+73", "--deny-warn"],
    {
      cwd: root,
      encoding: "utf8",
      shell: process.platform === "win32",
      timeout: 600000,
      maxBuffer: 64 * 1024 * 1024,
    },
  );
  const output = `${result.stdout ?? ""}\n${result.stderr ?? ""}`;
  return { killed: result.status !== 0, output };
}

const selected = MUTATIONS.filter((item) => !filter || filter.has(item.id));
if (selected.length === 0) {
  console.error("no mutations selected");
  process.exit(1);
}

console.log("baseline: moon test --target native (all tests)");
const baseline = runTests();
if (baseline.killed) {
  console.error("baseline failed; refusing to mutate");
  console.error(baseline.output.split("\n").filter(Boolean).slice(-15).join("\n"));
  process.exit(1);
}
console.log("baseline passed");

const results = [];
let mutatedFile = null;
let original = null;

function restore() {
  if (mutatedFile !== null && original !== null) {
    writeFileSync(resolve(root, mutatedFile), original, "utf8");
    mutatedFile = null;
    original = null;
  }
}

process.on("SIGINT", () => {
  restore();
  process.exit(130);
});
process.on("exit", restore);

for (const mutation of selected) {
  const full = resolve(root, mutation.file);
  const source = readFileSync(full, "utf8");
  const occurrences = source.split(mutation.find).length - 1;
  if (occurrences !== 1) {
    results.push({
      ...mutation,
      status: "SKIPPED",
      detail: `expected 1 occurrence, found ${occurrences}`,
    });
    continue;
  }
  original = source;
  mutatedFile = mutation.file;
  writeFileSync(full, source.replace(mutation.find, mutation.replace), "utf8");
  let outcome;
  try {
    outcome = runTests();
  } finally {
    restore();
  }
  results.push({
    ...mutation,
    status: outcome.killed ? "KILLED" : "SURVIVED",
    detail: outcome.killed
      ? ""
      : "all tests still pass; mutation not detected",
    output: outcome.killed ? "" : outcome.output,
  });
}

restore();

console.log("");
console.log("id    status    package       mutation");
for (const item of results) {
  console.log(
    `${item.id.padEnd(5)} ${item.status.padEnd(9)} ${item.pkg.padEnd(13)} ${item.name}`,
  );
  if (item.detail) console.log(`      ${item.detail}`);
}

const killed = results.filter((item) => item.status === "KILLED").length;
const survived = results.filter((item) => item.status === "SURVIVED").length;
const skipped = results.filter((item) => item.status === "SKIPPED").length;
console.log("");
console.log(
  `killed ${killed}/${results.length}, survived ${survived}, skipped ${skipped}`,
);
if (survived > 0 || skipped > 0) process.exit(1);