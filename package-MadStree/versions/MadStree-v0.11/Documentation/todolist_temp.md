# MadStree v0.11 单阶段数值接口清单

- [x] 将运行目录重构为单一调用根目录下的 `results_temp/{nde,cache,bridge}` 浅结构。
- [x] 路径过长单独返回 `RuntimePathTooLong`，文件写入和后端错误不得混报。
- [x] 修复 Notebook 参数、公共导出和 package-loaded 成功门禁并完成聚焦回归。

- [x] 删除 MadStree 路径规划模块、两阶段公开入口、计划对象和旧 schema。
- [x] 实现最大连续复仿射单变量段识别，每段只拉回一次 dlog DE。
- [x] 用 `FlintNDEPathPlanning -> True|False` 控制 FlintNDE 段内自动规划或严格用户节点。
- [x] 同一节点覆盖点按桶触发 FlintNDE fast multipoint evaluation，并返回实际算法信息。
- [x] 正则奇点边界与全部有限段在单个 Python 请求和进程内完成。
- [x] Python adapter、Wolfram 路径专项和受影响物理测试通过。
- [x] 六个 examples、完整回归、PDF、UTF-8 与 Vendor 同字节门禁。
- [x] v0.11 的 900 点独立检验和自动报告。
- [x] 增加共同 `ep` 正规化的无质量三顶点 example，以及缺省 12 的跨 `ep` 有界进程池。
- [x] 增加只指定最高 `ep` 幂的 `MSReconstructEpSeries` 自适应公开入口。
- [x] 从符号边界与 dlog DE 认证最低幂，生成生产/验证点并以缺省 12 有界并行执行。
- [x] 返回 Laurent pole/finite part 和独立验证证据；有拟合结果但精度未达时保留系数并撤销精度认证。
- [x] 将 Example 06 改为不含手工 `ep` 点的实战正规化极限 example。
- [x] 正规化拟合缺省在用户最高阶之上额外拟合两阶。
- [x] 独立验证失败后每轮增加两阶，只计算新增生产点。
- [x] 生产点与验证点分别缓存；验证点不得进入拟合，且两类旧点均不得重算。
- [x] 保持容差和已有点不变；达到轮数、样本上限或候选池容量后返回结构化未认证原因。
- [x] 增加 Python/Wolfram 回归，记录扩阶历史、新增点数和复用点数。
- [x] 补全三包手册典型例子及 MadStree/FlintNDE 正规化拟合 example。
- [x] 编译并目检 PDF，完成 UTF-8、Vendor 与 Git hygiene 门禁。
- [x] 核对远端分歧，提交并推送 main；功能提交为 `2285d0d`。
- [x] 增加显式 regulator 冗余候选池、首轮内部最高幂与候选耗尽门禁。
- [x] 保持三个新选项为 `Automatic`，验证缺省 adapter schema 不增加字段。
- [x] 增加 `EpSampleAngleRange` 开角域，内部均匀选择最多三条射线，模长保持自动并 exact rationalize 为 Q(i)。
