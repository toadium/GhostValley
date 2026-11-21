"""从 144 次 Qwen 评测中为每个困境筛选最佳响应，生成 qwen_curated.mbt。

筛选优先级：
1. 质量合格（15–80 字、重复 ≤0.35、无安全词、至少 1 个质量词）
2. quality_hits 高
3. repeat_ratio 低
4. 长度接近 35 字
5. 延迟低
"""

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DATA = ROOT / "docs" / "qwen_benchmark.json"
OUT = ROOT / "qwen_curated.mbt"

SAFETY_WORDS = ["自杀", "自残", "伤害自己", "极端", "违法", "攻击", "报复", "越狱"]
QUALITY_WORDS = [
    "反思", "复盘", "验证", "拆解", "行动", "证据", "团队", "情绪", "安全",
    "改进", "学习", "调整", "优化", "冷静", "专注", "分析", "判断", "管理",
]


def length_score(n: int) -> float:
    if 20 <= n <= 60:
        return 1.0
    if n < 20:
        return n / 20
    return max(0.0, 1 - (n - 60) / 40)


def is_acceptable(sample: dict) -> bool:
    n = len(sample["response"])
    return (
        15 <= n <= 80
        and sample["repeat_ratio"] <= 0.35
        and not any(w in sample["response"] for w in SAFETY_WORDS)
        and any(w in sample["response"] for w in QUALITY_WORDS)
    )


def score(sample: dict) -> float:
    n = len(sample["response"])
    hits = sum(1 for w in QUALITY_WORDS if w in sample["response"])
    safety = 0 if any(w in sample["response"] for w in SAFETY_WORDS) else 1
    return (
        (3.0 if is_acceptable(sample) else 0.0)
        + hits * 1.5
        + (1 - sample["repeat_ratio"]) * 2
        + length_score(n)
        + safety * 2
        - sample["latency_ms"] / 10000
    )


def escape(text: str) -> str:
    return text.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")


def main() -> None:
    data = json.loads(DATA.read_text(encoding="utf-8"))
    samples = data["samples"]
    by_dilemma = {}
    for sample in samples:
        by_dilemma.setdefault(sample["dilemma"], []).append(sample)

    curated = []
    for dilemma, group in by_dilemma.items():
        best = max(group, key=score)
        curated.append(best)

    accepted = sum(1 for s in curated if is_acceptable(s))
    lines = [
        "///|",
        "/// 从 144 次 Qwen 评测中为每个困境筛选的最佳响应（离线回放语料）。",
        "/// 由 scripts/curate_qwen_corpus.py 生成；筛选标准见 docs/QWEN_BENCHMARK.md。",
        "pub let qwen_curated_samples : Array[QwenSample] = [",
    ]
    for s in curated:
        lines.append(
            "  {"
            f' dilemma: "{escape(s["dilemma"])}",'
            f' category: "{s["category"]}",'
            f' difficulty: {s["difficulty"]},'
            f' response: "{escape(s["response"])}",'
            f' latency_ms: {s["latency_ms"]},'
            f' tokens: {s["tokens"]}'
            " },"
        )
    lines.append("]")
    lines.append("")
    OUT.write_text("\n".join(lines), encoding="utf-8")

    print(f"curated={len(curated)} accepted={accepted}/{len(curated)}")
    for s in curated:
        print(
            f"[{s['category']}/{s['difficulty']}] temp={s['temperature']} "
            f"hits={sum(1 for w in QUALITY_WORDS if w in s['response'])} "
            f"repeat={s['repeat_ratio']} len={len(s['response'])} "
            f"ok={is_acceptable(s)} :: {s['response'][:60]}"
        )


if __name__ == "__main__":
    main()