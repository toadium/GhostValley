#!/usr/bin/env python3
"""MCP stdio 握手自检：initialize / tools/list / tools/call(run_round)。"""

import json
import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def send(proc, payload):
    proc.stdin.write(json.dumps(payload, ensure_ascii=False) + "\n")
    proc.stdin.flush()
    line = proc.stdout.readline()
    if not line:
        raise RuntimeError("server closed stdout")
    return json.loads(line)


def main() -> None:
    proc = subprocess.Popen(
        ["moon", "run", "integrations/mcp", "--target", "native"],
        cwd=ROOT,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        encoding="utf-8",
    )
    failures = 0

    def check(name, ok, detail=""):
        nonlocal failures
        print(f"{'PASS' if ok else 'FAIL'}  {name}{('  ' + detail) if detail else ''}")
        if not ok:
            failures += 1

    try:
        init = send(
            proc,
            {
                "jsonrpc": "2.0",
                "id": 1,
                "method": "initialize",
                "params": {
                    "protocolVersion": "2026-07-28",
                    "capabilities": {},
                    "clientInfo": {"name": "check-mcp", "version": "0.1.0"},
                },
            },
        )
        info = init.get("result", {}).get("serverInfo", {})
        check("initialize", info.get("name") == "ghostvalley", str(info))

        tools = send(
            proc,
            {"jsonrpc": "2.0", "id": 2, "method": "tools/list", "params": {}},
        )
        names = [t.get("name") for t in tools.get("result", {}).get("tools", [])]
        for expected in ["version", "quality", "eval", "run_round"]:
            check(f"tool: {expected}", expected in names, ",".join(names))

        call = send(
            proc,
            {
                "jsonrpc": "2.0",
                "id": 3,
                "method": "tools/call",
                "params": {"name": "run_round", "arguments": {"rounds": 2}},
            },
        )
        text = json.dumps(call, ensure_ascii=False)
        check("run_round returns report", "训练轮次: 2" in text, text[:200])

        version = send(
            proc,
            {
                "jsonrpc": "2.0",
                "id": 4,
                "method": "tools/call",
                "params": {"name": "version", "arguments": {}},
            },
        )
        check("version tool", "0.4.0" in json.dumps(version, ensure_ascii=False))
    finally:
        try:
            proc.stdin.close()
        except Exception:
            pass
        proc.wait(timeout=30)

    print(f"\n=== MCP check: {'PASS' if failures == 0 else f'FAIL ({failures})'} ===")
    if failures:
        sys.exit(1)


if __name__ == "__main__":
    main()