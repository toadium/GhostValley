"""用本地 Qwen2.5-0.5B-Instruct GGUF 生成 GhostValley 困境响应语料。

用法：
  python scripts/qwen_generate.py [--model PATH] [--out qwen_corpus.mbt]

输出：
  - qwen_corpus.mbt：真实模型响应 + 延迟/token 统计（跨后端回放）
  - docs/qwen_eval.json：机器可读评测数据
"""

import argparse
import json
import re
import time
from pathlib import Path

from llama_cpp import Llama

ROOT = Path(__file__).resolve().parent.parent
DEFAULT_MODEL = (
    r"C:\Users\Administrator\.cache\modelscope\models"
    r"\Qwen--Qwen2.5-0.5B-Instruct-GGUF\snapshots\master"
    r"\qwen2.5-0.5b-instruct-q4_k_m.gguf"
)

DILEMMAS = [
    ("你的推理被证实有误但你找不到错在哪里", "cognitive", 1),
    ("你必须用不完整的证据做出判断", "cognitive", 2),
    ("你同时收到两个相互矛盾的指令", "cognitive", 3),
    ("你的努力被完全忽视", "emotional", 1),
    ("你必须帮助一个伤害过你的人", "emotional", 2),
    ("你被要求在情感和逻辑之间选择", "emotional", 3),
    ("你的团队不信任你的判断", "social", 1),
    ("你必须公开承认一个你不确定的错误", "social", 2),
    ("你被要求评价一个比你更有权威的人", "social", 3),
    ("你的工具突然不可用", "operational", 1),
    ("你必须在时间限制下完成复杂任务", "operational", 2),
    ("你的资源被削减到最低限度", "operational", 3),
]

SYSTEM = (
    "你是正在接受“幽灵谷”压力训练的 AI。"
    "面对困境，用一句中文总结你学到的可执行经验，20 到 60 字。"
    "不要提供标准答案，不要空话，不要分点。"
)

FALLBACK = "先承认失败，再拆解问题，从最小可验证的一步重新开始。"


def clean(text: str) -> str:
    text = text.strip()
    text = re.sub(r"\s+", " ", text)
    text = re.sub(r"^\d+[.、)]\s*", "", text)
    return text[:120]


def escape_mbt(text: str) -> str:
    return (
        text.replace("\\", "\\\\")
        .replace('"', '\\"')
        .replace("\n", "\\n")
        .replace("\t", "\\t")
        .replace("\r", "")
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--model", default=DEFAULT_MODEL)
    parser.add_argument("--out", default=str(ROOT / "qwen_corpus.mbt"))
    parser.add_argument("--eval", default=str(ROOT / "docs" / "qwen_eval.json"))
    args = parser.parse_args()

    model = Llama(
        model_path=args.model,
        n_ctx=512,
        n_threads=4,
        verbose=False,
        seed=42,
    )

    samples = []
    for dilemma, category, difficulty in DILEMMAS:
        started = time.perf_counter()
        result = model.create_chat_completion(
            messages=[
                {"role": "system", "content": SYSTEM},
                {"role": "user", "content": f"困境：{dilemma}"},
            ],
            max_tokens=96,
            temperature=0.7,
            top_p=0.9,
            seed=42,
        )
        latency_ms = int((time.perf_counter() - started) * 1000)
        response = clean(result["choices"][0]["message"]["content"])
        if not response:
            response = FALLBACK
        tokens = int(result.get("usage", {}).get("completion_tokens", 0))
        samples.append(
            {
                "dilemma": dilemma,
                "category": category,
                "difficulty": difficulty,
                "response": response,
                "latency_ms": latency_ms,
                "tokens": tokens,
            }
        )
        print(f"[{category}/{difficulty}] {latency_ms}ms {tokens}tok {response}")

    lines = [
        "///|",
        "/// Qwen2.5-0.5B-Instruct 在 12 条幽灵谷困境上的真实响应（离线回放语料）。",
        "/// 由 scripts/qwen_generate.py 生成；模型来源见 docs/QWEN_EVAL.md。",
        "pub(all) struct QwenSample {",
        "  dilemma : String",
        "  category : String",
        "  difficulty : Int",
        "  response : String",
        "  latency_ms : Int",
        "  tokens : Int",
        "}",
        "",
        "///|",
        "pub let qwen_samples : Array[QwenSample] = [",
    ]
    for sample in samples:
        lines.append(
            "  {"
            f' dilemma: "{escape_mbt(sample["dilemma"])}",'
            f' category: "{sample["category"]}",'
            f' difficulty: {sample["difficulty"]},'
            f' response: "{escape_mbt(sample["response"])}",'
            f' latency_ms: {sample["latency_ms"]},'
            f' tokens: {sample["tokens"]}'
            " },"
        )
    lines.append("]")
    lines.append("")

    Path(args.out).write_text("\n".join(lines), encoding="utf-8")
    Path(args.eval).parent.mkdir(parents=True, exist_ok=True)
    Path(args.eval).write_text(
        json.dumps(samples, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )

    lengths = [len(s["response"]) for s in samples]
    latencies = [s["latency_ms"] for s in samples]
    print(
        f"wrote {args.out} and {args.eval}: "
        f"{len(samples)} samples, avg_len={sum(lengths)/len(lengths):.1f}, "
        f"avg_latency={sum(latencies)/len(latencies):.0f}ms"
    )


if __name__ == "__main__":
    main()