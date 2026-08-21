# FlintNDE 0.5.0 TODO

- [x] 建立唯一 `versions/FlintNDE-0.5.0/`，补齐版本说明和版本索引。
- [ ] 实现以奇点局部收敛半径为依据的双侧用户点 bucket 与点归属报告。
- [x] 实现 removable、true-pole、log-divergent singular target 状态；unsupported 继续 fail closed。
- [x] 对命中真实 dlog pole 的最终值序列化为 `Infinity` 文本；可去奇点保持数值输出。
- [x] 输出用户输入 DE 奇点分类表，至少包含坐标、来源字母/矩阵证据、分类和处理方式。
- [ ] 保持 `avoid` 和显式 `singularity_jump` 行为可辨识且 fail closed，并完成奇点后的继续输运。
- [x] 增加奇点目标单元测试和 adapter 专项测试；独立包 173/173、MadStree backend 专项 13/13 已 fresh 运行。
- [x] 更新 README、API/技术文档和独立验证任务书，明确当前继续输运限制。
- [x] 删除 0.4.0 现行源码、测试结果和旧任务书，不保留兼容入口。
- [ ] 完整功能完成后检查 UTF-8、`git diff --check` 并执行清空生成物后的 fresh 验收。
