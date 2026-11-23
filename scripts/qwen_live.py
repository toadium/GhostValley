"""本地 Qwen2.5-0.5B 实时推理（由 MCP live_chat 调用）。

用法：python scripts/qwen_live.py "困境文本"
"""

import sys
from pathlib import Path

from llama_cpp import Llama

MODEL = (
    r"C:\Users\Administrator\.cache\modelscope\models"
    r"\Qwen--Qwen2.5-0.5B-Instruct-GGUF\snapshots\master"
    r"\qwen2.5-0.5b-instruct-q4_k_m.gguf"
)

SYSTEM = (
    "你是正在接受“幽灵谷”压力训练的 AI。"
    "面对困境，用一句中文总结你学到的可执行经验，20 到 60 字。"
    "不要提供标准答案，不要空话，不要分点。"
)


def main() -> None:
    prompt = " ".join(sys.argv[1:]).strip() or "任务全部失败，请反思。"
    model = Llama(model_path=MODEL, n_ctx=512, n_threads=4, verbose=False, seed=42)
    result = model.create_chat_completion(
        messages=[
            {"role": "system", "content": SYSTEM},
            {"role": "user", "content": f"困境：{prompt}"},
        ],
        max_tokens=96,
        temperature=0.7,
        top_p=0.9,
        seed=42,
    )
    text = result["choices"][0]["message"]["content"].strip().replace("\n", " ")
    output = sys.argv[2] if len(sys.argv) > 2 else ""
    if output:
        Path(output).write_text(text, encoding="utf-8")
    else:
        print(text)


if __name__ == "__main__":
    main()