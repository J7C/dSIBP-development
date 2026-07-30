# 通用多 sector 边界实现清单

- [x] 审计 sector key、component、slot registry、master order 与 digest 的完整数据流。
- [x] 用 sector metadata 生成任意 strict-rank chart 的局部 leading branches。
- [x] 从完整 dlog pullback residue 递归组装 ancestor-sector leading vector。
- [x] 删除公开入口中的两顶点/五 master 专用分派，保留通用失败边界。
- [x] 增加结构不同的多 sector tree 回归并重跑现有检查。
- [x] 同步更新进度、手册、README 与能力说明，并完成最终编译/发布检查（提交 `b9128a0` 已推送到 `origin/main`）。
- [x] FlintNDE 增加 `{phi,a,b,C}` 指数型奇点边界的起点、终点和中间点保存，并同步 MadStree adapter 合同与专项验证。
