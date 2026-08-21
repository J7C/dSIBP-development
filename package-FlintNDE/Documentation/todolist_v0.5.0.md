# FlintNDE 0.5.0 TODO

- [x] 建立唯一 `versions/FlintNDE-0.5.0/`，补齐版本说明和版本索引。
- [x] 实现以奇点局部收敛半径为依据的双侧用户点 bucket 与点归属报告。
- [x] 实现 removable、true-pole、log-divergent singular target 状态；不支持的继续输运明确 fail closed。
- [x] 用任意非零 exact `Q(i)` 目标和另一个共存有限奇点验证逐分量分类；变量名与零坐标
  不参与 removable/true-pole/log-divergent 判定，独立包与 MadStree Vendor 专项均为 `7/7`。
- [x] 对命中真实 dlog pole 的最终值序列化为 `Infinity` 文本；可去奇点保持数值输出。
- [x] 输出用户输入 DE 奇点分类表，至少包含坐标、来源字母/矩阵证据、分类和处理方式。
- [x] 保持 `avoid` 和显式 `singularity_jump` 行为可辨识且 fail closed。
- [ ] 让末端奇点使用由目标奇点收敛半径决定的隐藏普通匹配点；主/参考链分别求值并核验分类及有限值误差。
- [x] 增加末端奇点单元测试、序列化 round-trip 和 adapter 专项测试；独立 Python 回归已达 `173/173`。
- [ ] 更新 README、API/技术文档和独立验证任务书，删除“双侧 bucket 待实现/只支持末端奇点”等旧限制。
- [x] 删除 0.4.0 现行源码、测试结果和旧任务书，不保留兼容入口。
- [ ] 完整功能完成后从空结果目录 fresh 重跑 Python/Wolfram/专项验证，并检查 UTF-8、`git diff --check`。
