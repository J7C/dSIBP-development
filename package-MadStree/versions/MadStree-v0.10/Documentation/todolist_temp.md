# 通用多 sector 边界实现清单

## v0.10 同复直线分组与组内 dense output 修订（源码与开发测试已完成）

- [x] 实现连续复仿射共线分组、组内 exact 参数化和转角断组。
- [x] 每组一次调用 FlintNDE，并传入全部组内用户参数点。
- [x] 保存 node snapshot / dense sample 到 userIndex 的完整映射。
- [x] 执行时按映射重建 saved、tmp、重复点和 LO 到达值，不重新规划。
- [x] 增加 900 点二维复格点开发测试：固定 x1 的 300 个复数 x2 点识别为同一复平面组。
- [x] 新建 v0.10 独立验证任务书，要求 900 点与逐点基线比较，并同步中英文交付文档。
- [x] 运行 adapter、路径专项、受影响 Wolfram 回归和 Git hygiene。

独立验证任务书尚未执行；其 900 点准确性和 cold-cache 计时结果不得记为已验证。

## v0.10 路径规划与 FlintNDE 同步修订（已完成）

- [x] `MSGeneratePath` 完成多变量共线点合并、仿射拉回、plan-only 后端调用并把节点、奇点折跃和 sample 路由写入计划变量。
- [x] `MSEvaluatePlannedPath` 只反序列化并执行上述计划，后端不得再次调用路径规划器。
- [x] `SingularityMode -> "Avoid"` 作为缺省；`"SingularityJump"` 显式进入奇点折跃模式并输出分支责任提示。
- [x] 计划保存规划精度；执行精度高于规划精度时结构化拒绝并提示重新规划。
- [x] 统一为 `MessageLanguage -> "EN"|"CN"` 与桥接 `messageLanguage`，严格拒绝其它值和宽松大小写。
- [x] 当前源码、测试、示例和现行文档使用唯一两阶段入口、现行点标签和六个严格的 plan/execute adapter schema。
- [x] 内部奇点启动协议只使用当前 plan/execute schema；奇点算法保留，不保留另一套协议。
- [x] FlintNDE 通用路径几何使用 Arb 球判定，并覆盖大平移坐标、70/100 位节点精度和执行期不重规划。
- [x] Vendor 与独立 FlintNDE 0.3.0 的共同交付文件保持逐字节同步。
- [x] 收口 LO 正式测试与 `Rule::argr`，更新 DEVELOPMENT_PLAN、README、UPDATE_NOTES 和手册中的 Horner/缓存及 blow-up 结论。
- [x] 审计 sector key、component、slot registry、master order 与 digest 的完整数据流。
- [x] 用 sector metadata 生成任意 strict-rank chart 的局部 leading branches。
- [x] 从完整 dlog pullback residue 递归组装 ancestor-sector leading vector。
- [x] 删除公开入口中的两顶点/五 master 专用分派，保留通用失败边界。
- [x] 增加结构不同的多 sector tree 回归并重跑现有检查。
- [x] 同步更新进度、手册、README 与能力说明；fresh 验证为路径专项 53/53、Python adapter 10/10、12 个 Wolfram 文件 221/221、Examples 5/5；三份 PDF 编译及目检通过，Vendor 共同交付文件 26/26 哈希一致。
- [x] FlintNDE 增加 `{phi,a,b,C}` 指数型奇点边界的起点、终点和中间点保存，并同步 MadStree adapter 合同与专项验证。
- [x] 将 canonical sector key 改为 root propagator 顺序的定长 `0/1` 字符串。
- [x] 同步 current examples、core/recurrence/dlog/boundary 消费链并完成短检查。
- [x] 复制并重跑受 sector key 影响的 v0.4 T1--T5 独立验证，更新报告与任务书；T6 与 key 无关，本轮不重跑。
