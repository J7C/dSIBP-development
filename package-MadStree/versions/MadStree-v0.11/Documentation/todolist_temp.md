# MadStree v0.11 单阶段数值接口清单

- [x] 删除 MadStree 路径规划模块、两阶段公开入口、计划对象和旧 schema。
- [x] 实现最大连续复仿射单变量段识别，每段只拉回一次 dlog DE。
- [x] 用 `FlintNDEPathPlanning -> True|False` 控制 FlintNDE 段内自动规划或严格用户节点。
- [x] 同一节点覆盖点按桶触发 FlintNDE fast multipoint evaluation，并返回实际算法信息。
- [x] 正则奇点边界与全部有限段在单个 Python 请求和进程内完成。
- [x] Python adapter、Wolfram 路径专项和受影响物理测试通过。
- [ ] 五个 examples、完整回归、PDF、UTF-8 与 Vendor 同字节门禁。
- [ ] v0.11 的 900 点独立检验和自动报告。
