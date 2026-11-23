#!/usr/bin/env node
// 覆盖率门禁：运行 moon coverage analyze，统计根包源码（排除 examples/_build）。
// 用法：node scripts/check_coverage.mjs [--min 80] [--from coverage.txt]
import { spawnSync } from "node:child_process";
import { readFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const args = process.argv.slice(2);
const minAt = args.indexOf("--min");
const min = minAt >= 0 ? Number(args[minAt + 1]) : 80;
const fromAt = args.indexOf("--from");

function loadOutput() {
  if (fromAt >= 0) {
    return readFileSync(resolve(root, args[fromAt + 1]), "utf8");
  }
  const run = spawnSync(
    "moon",
    ["coverage", "analyze", "--", "-f", "summary"],
    { cwd: root, encoding: "utf8", shell: process.platform === "win32" },
  );
  const output = `${run.stdout ?? ""}\n${run.stderr ?? ""}`;
  if (run.status !== 0) {
    console.error("coverage command failed");
    console.error(output.split("\n").slice(-20).join("\n"));
    process.exit(1);
  }
  return output;
}

const output = loadOutput();
const rows = [];
const pattern = /^\s*(.+?\.mbt):\s*(\d+)\/(\d+)\s*$/gm;
for (const match of output.matchAll(pattern)) {
  const file = match[1].replace(/\\/g, "/");
  if (file.includes("/_build/") || file.startsWith("_build/")) continue;
  if (file.includes("/examples/") || file.startsWith("examples/")) continue;
  if (file.includes("/playground/") || file.startsWith("playground/")) continue;
  if (file.includes("/cli/") || file.startsWith("cli/")) continue;
  if (file.includes("/bench/") || file.startsWith("bench/")) continue;
  rows.push({ file, covered: Number(match[2]), total: Number(match[3]) });
}

if (rows.length === 0) {
  console.error("no coverage rows parsed");
  process.exit(1);
}

let covered = 0;
let total = 0;
console.log("file                                  covered/total    ratio");
for (const row of rows.sort((a, b) => a.file.localeCompare(b.file))) {
  covered += row.covered;
  total += row.total;
  const ratio = (row.covered / row.total) * 100;
  console.log(
    `${row.file.padEnd(36)} ${String(row.covered).padStart(4)}/${String(row.total).padEnd(4)}   ${ratio.toFixed(1).padStart(5)}%`,
  );
}

const ratio = (covered / total) * 100;
console.log("-".repeat(62));
console.log(
  `total                                 ${String(covered).padStart(4)}/${String(total).padEnd(4)}   ${ratio.toFixed(1).padStart(5)}%   ${ratio >= min ? "PASS" : "FAIL"} (min ${min}%)`,
);
if (ratio < min) {
  console.error(`coverage gate failed: ${ratio.toFixed(1)}% < ${min}%`);
  process.exit(1);
}
console.log("coverage gate passed");