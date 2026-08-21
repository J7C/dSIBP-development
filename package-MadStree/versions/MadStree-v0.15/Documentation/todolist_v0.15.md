# MadStree v0.15 TODO

- [x] 建立 v0.15 版本目录和更新说明。
- [x] 同步已验收的 FlintNDE 0.5.0 Vendor，删除旧 Vendor 代码入口。
- [x] 省略 `externalLegEnergy` 时按 0 归一化；边界曲线使用私有辅助能量生成无穷远边界。
- [x] 将 Automatic 奇点目标模式接入 MadStree affine 分段结果。
- [x] 接收 FlintNDE 的 Infinity/有限值/发散状态并写出 DE 奇点分类表。
- [x] 增加无外腿/零外腿辅助能量 Example 07 与回归；省略和显式 0 生成相同解析 context/dlog，
  数值路线自动回到 0。
- [x] 增加末端普通点、可去奇点、真实 pole/log 发散的底层回归；奇点后继续输运与双侧 bucket
  仍是 FlintNDE 未完成项，不以末端回归替代。
- [x] 更新 README、用户手册、独立验证任务书和输出目录说明，明确当前继续输运限制。
- [ ] 完成 FlintNDE 双侧奇点 bucket 后同步 Vendor，并补齐 MadStree 连续点序列专项验证。
- [ ] 从空结果目录重跑并清理中间文件，完成 `git diff --check`。
