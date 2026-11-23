# 示例：客服危机处理训练

模拟 AI 客服面对大量投诉、差评轰炸、恶意攻击场景的心理压力训练。

[← 返回示例总览](../README.md) · [← 根 README](../../README.md)

## 运行

```bash
moon run examples/customer_service --target native
```

## 展示内容

| 步骤 | 内容 |
|---|---|
| 1 | 温石验证 |
| 2 | 加载“客服危机”困境库（3 难度） |
| 3 | 10 轮训练管道（衰减每 3 轮 + 清理阈值 0.1） |
| 4 | 情绪监控（压力/信心/韧性/崩溃风险 + profile） |
| 5 | 安全协议检查 |
| 6 | 审计日志 |
| 7 | 报告导出 |

## 关键 API

```moonbit
let lib = @ghostvalley.DilemmaLibrary::with_presets()
let gv = @ghostvalley.new_engine(max_memory_num=50)
gv.run_training_pipeline(llm, rounds=10, decay_interval=3, cleanup_threshold=0.1)
let violations = @ghostvalley.protocol_check(protocol, emotion, 0)
```

## 相关

- [训练协议与审计](../../README.mbt.md)
- [完整工作流 demo](../demo/README.md)