#!/usr/bin/env node
// GhostValley 展示页自检：构建 js、复制产物、导出与语义断言。
import { copyFileSync, existsSync, readFileSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { spawnSync } from "node:child_process";
import { fileURLToPath } from "node:url";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const jsBuild = join(root, "_build/js/release/build/playground/playground.js");
const jsDocs = join(root, "docs/playground.js");

let failures = 0;
function check(name, ok, detail) {
  console.log(`${ok ? "PASS" : "FAIL"}  ${name}${detail ? `  (${detail})` : ""}`);
  if (!ok) failures += 1;
}

for (const file of [
  "docs/index.md",
  "docs/_config.yml",
  "docs/demo.html",
  "docs/app.js",
  "docs/style.css",
]) {
  check(`asset exists: ${file}`, existsSync(join(root, file)));
}

const landing = readFileSync(join(root, "docs/index.md"), "utf8");
const jekyllConfig = readFileSync(join(root, "docs/_config.yml"), "utf8");
const html = readFileSync(join(root, "docs/demo.html"), "utf8");
const appJs = readFileSync(join(root, "docs/app.js"), "utf8");
check(
  "landing mentions GhostValley + Quick start",
  landing.includes("GhostValley") && landing.includes("快速开始"),
);
check("landing links interactive demo", landing.includes("demo.html"));
check(
  "Cayman theme configured",
  jekyllConfig.includes("theme: jekyll-theme-cayman"),
);
check("demo loads app.js / style.css", html.includes("app.js") && html.includes("style.css"));
check("app.js imports playground.js", appJs.includes("./playground.js"));

const moduleReadmes = [
  "playground",
  "cli",
  "bench",
  "integrations/mcp",
  "examples",
  "examples/demo",
  "examples/onboarding",
  "examples/team_stress",
  "examples/customer_service",
  "examples/qwen_curated",
];
check(
  "landing links 10 module READMEs",
  moduleReadmes.every((pkg) => landing.includes(`blob/main/${pkg}/README.md`)),
  `${moduleReadmes.length} 个模块`,
);
const rootReadme = readFileSync(join(root, "README.md"), "utf8");
check(
  "root README decorated",
  rootReadme.includes("521") && rootReadme.includes("97.5%"),
);

const build = spawnSync("moon", ["build", "--target", "js", "--release", "playground"], {
  cwd: root,
  encoding: "utf8",
  shell: process.platform === "win32",
  timeout: 600000,
});
check("build playground js", build.status === 0, (build.stderr ?? "").slice(0, 400));
if (build.status !== 0) process.exit(1);
check("playground.js build exists", existsSync(jsBuild));
if (!existsSync(jsBuild)) process.exit(1);

copyFileSync(jsBuild, jsDocs);
check("docs/playground.js exists", existsSync(jsDocs));

const mod = await import("file://" + jsDocs.replace(/\\/g, "/"));
for (const name of [
  "gv_version",
  "gv_quality_curated",
  "gv_quality_base",
  "gv_eval",
  "gv_run",
]) {
  check(`export: ${name}`, typeof mod[name] === "function");
}

check("version = 0.4.0", mod.gv_version() === "0.4.0");
check(
  "curated quality 23/24",
  mod.gv_quality_curated().includes("accepted=23/24"),
);
check(
  "base quality 9/12",
  mod.gv_quality_base().includes("accepted=9/12"),
);
check("eval summary samples=12", mod.gv_eval().includes("samples=12"));

const report = mod.gv_run(4);
check("run(4) reports 4 rounds", report.includes("训练轮次: 4"));
check("run(0) clamps to 1", mod.gv_run(0).includes("训练轮次: 1"));
check("run(99) clamps to 20", mod.gv_run(99).includes("训练轮次: 20"));

console.log(`\n=== pages check: ${failures === 0 ? "PASS" : `FAIL (${failures})`} ===`);
if (failures > 0) process.exit(1);