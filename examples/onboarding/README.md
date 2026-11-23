# 示例：新员工入职心理建设

模拟新员工面对陌生环境、犯错压力、权威质疑的渐进式心理建设训练。

[← 返回示例总览](../README.md) · [← 根 README](../../README.md)

## 运行

```bash
moon run examples/onboarding --target native
```

## 展示内容

- 自定义 `DilemmaLibrary` 场景“新员工入职”（5 条模板，覆盖 emotional / social / cognitive）
- 渐进式困境注入：先易后难（难度 1 → 2 → 3）
- 课程驱动训练与情绪追踪
- 自适应难度与可视化报告

## 关键 API

```moonbit
let lib = @ghostvalley.DilemmaLibrary::new()
lib.register_scenario("新员工入职", templates)
for d in lib.get_dilemmas("新员工入职", 1) {
  gv.add_dilemma(d.content)
}
```

## 相关

- [技术团队压力](../team_stress/README.md)
- [课程与评估](../../README.mbt.md)