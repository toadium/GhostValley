# playground

浏览器演示导出层：把 GhostValley 的纯函数/回放能力导出为 JavaScript，供 GitHub Pages 静态页调用。

[← 返回总览](../README.md)

## 构建

```bash
moon build --target js --release playground
```

产物：`_build/js/release/build/playground/playground.js`，页面使用 `docs/playground.js`。

## 导出接口

| 导出名 | 签名 | 说明 |
|---|---|---|
| `gv_version` | `() -> String` | 版本号 |
| `gv_quality_curated` | `() -> String` | 精选 24 条质量摘要 |
| `gv_quality_base` | `() -> String` | 基础 12 条质量摘要 |
| `gv_eval` | `() -> String` | 144 次评测摘要 |
| `gv_run` | `(rounds : Int) -> String` | 跑 1–20 轮训练，返回报告 |

## 页面

- `docs/index.md`：Cayman 介绍页
- `docs/demo.html`：交互 Demo
- `docs/app.js`：调用上方 5 个导出
- `docs/playground.js`：构建产物（入库）

## 行为说明

- `pkgtype(kind: "foreign_library")`，仅 js 后端；主库本身四后端可用。
- 所有导出为非 raise 签名：错误折叠为文本，不抛到 JS。
- `gv_run` 会把轮次夹到 1–20；无模型、无网络请求。

## 相关

- [交互 Demo](https://toadium.github.io/GhostValley/demo.html)
- [Pages 自检](../scripts/check_pages.mjs)
- [根 README](../README.md)