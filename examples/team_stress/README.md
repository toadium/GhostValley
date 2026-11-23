# 示例：技术团队压力演练

模拟技术团队面对项目延期、线上事故、技术选型失误的集体压力训练。

[← 返回示例总览](../README.md) · [← 根 README](../../README.md)

## 运行

```bash
moon run examples/team_stress --target native
```

## 展示内容

- 两个智能体：资深团队 A / 新建团队 B
- 预设困境库：“项目延期”“安全事故复盘”“技术选型失误”（各 3 难度）
- `Curriculum::default()` 课程要求与前置依赖
- 多智能体对比训练（10 轮 vs 6 轮）+ 统计对比
- 检查点与交叉学习

## 关键 API

```moonbit
let gv_a = @ghostvalley.new_engine(max_memory_num=50)
let gv_b = @ghostvalley.new_engine(max_memory_num=50)
let lib = @ghostvalley.DilemmaLibrary::with_presets()
gv_a.run_training_pipeline(llm_a, rounds=10, decay_interval=3, cleanup_threshold=0.1)
```

## 相关

- [多智能体/交叉学习](../../README.mbt.md)
- [客服危机](../customer_service/README.md)