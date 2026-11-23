import {
  gv_version,
  gv_quality_curated,
  gv_quality_base,
  gv_eval,
  gv_run,
} from "./playground.js";

const $ = (sel) => document.querySelector(sel);

function set(id, text) {
  $(id).textContent = text;
}

try {
  set("#version", gv_version());
  set("#curated", gv_quality_curated());
  set("#base", gv_quality_base());
  set("#eval", gv_eval());
} catch (error) {
  set("#curated", "加载失败：" + error.message);
}

function run(rounds) {
  try {
    set("#report", gv_run(rounds));
  } catch (error) {
    set("#report", "训练失败：" + error.message);
  }
}

$("#run").addEventListener("click", () => {
  const value = Number($("#rounds").value || 8);
  run(value);
});

$("#run20").addEventListener("click", () => {
  $("#rounds").value = "20";
  run(20);
});