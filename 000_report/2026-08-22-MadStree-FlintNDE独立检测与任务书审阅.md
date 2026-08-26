# dSIBP 022 / MadStree v0.15 / FlintNDE 0.5.0 独立检测与任务书审阅

- 最终更新：2026-08-23（Asia/Shanghai）
- Git 快照：`3955a99d2f40d2cef0d9b43fd1c5ebef2669d23e`；工作树含本轮任务书、
  validation、报告和其它用户未提交改动。
- 对象：dSIBP 022.0、MadStree v0.15、FlintNDE 0.5.0 当前唯一工作版本。
- 主题：真实 public producer/consumer、主积分与论文 dlog DE、论文边界与数值 NDE、任务书覆盖、
  当前功能/手册缺口。

## 1. 结论摘要

三包不能合并写成一个“全部通过”：

| 对象 | 本轮正式结果 | 结论 |
|---|---:|---|
| MadStree Validation-04 | `24/24` | 2411.03088 两顶点 massive G++ 的真实五公开入口、五主积分、三变量 dlog、五支边界和三点 NDE 全链通过 |
| FlintNDE Validation-02 | `12/12` | 双侧奇点 bucket、末端隐藏匹配、继续输运、planned/naive/闭式互检通过 |
| FlintNDE Python 回归 | `181 tests, OK` | 当前 Python 实现回归通过；不能代替未执行的独立物理/高阶奇点 case |
| dSIBP 15.6 树图 | 三变量各 `25/25` | `ds + DSGenerateIBP + exact 数值约化` 与论文 dlog 偏导一致 |
| dSIBP 15.7 bubble | public route `16/18` | Kira 数值约化成功，但 `DSKiraImport -> DSDE` 的 active UserMI token 交接失败，正式闭环未通过 |

MadStree 旧 Validation-03 的人工 scalar adapter 不能验证真实 master/DE/boundary，现行工作树已删除其
报告、summary 和 runner；不再保留错误的“19/19 包级验证”结论。它揭示的问题来自此前轻量自检，
不是本次 Validation-04。本次已经用真实 `MSInitTree -> MSMasterIntegrals -> MSDLogDE ->
MSBoundaryData -> MSEvaluatePath` 重做。

## 2. 范围与方法

### 2.1 实际读取

- 根及三个子项目 `AGENTS.md`、版本索引、README、当前任务书、手册/TODO 和公开 API 声明；
- MadStree 论文 oracle、Validation-04 runner/report/summary；
- FlintNDE Validation-02 runner/report/summary 和当前限制说明；
- dSIBP 022 正式单文件、论文两顶点 oracle、bubble reference source/hash、fresh Kira manifest/log、
  import/DE consumer 实现。

### 2.2 实际执行

1. MadStree Validation-04 从空结果/runtime fresh 执行，`24/24`，退出 0。
2. dSIBP 两顶点 runner fresh 执行，三变量各 `25/25`，退出 0。
3. dSIBP bubble fresh 执行 package export、外部 Kira 2.3 reduction、公开 import/DE 和只读诊断副本。
   Kira 得到 19 masters、0 unreduced；公开 route 因已确认缺陷退出 1。
4. 本轮之前同一审计已 fresh 执行 FlintNDE Validation-02 `12/12` 和完整 Python `181 tests, OK`；
   本次增量没有重复覆盖其 retained result。

没有修改三个正式 package 源码；只修订任务书、独立 oracle 元数据、验证资产和报告。

## 3. 数值误差验收原则

MadStree 的 NDE、论文边界+dlog DE 直接输入 FlintNDE 的路线、论文超几何/级数路线都含截断、
输运和舍入误差，因此不要求逐位相等。本次运行前固定：工作精度 100 位、边界阶 42、主/参考
输运阶 144/184、论文 cutoff 100/120、安全因子 10。每个点、每个分量使用两条 FlintNDE 的
主/参考阶差和论文 cutoff 差组成联合预算；只有差值超过预算才失败。

可 exact 比较的 master order、basis、normalization、dlog letters/residue、解析 DE 和边界系数仍
必须 exact 相等，不能用数值容差掩盖解析不一致。

## 4. MadStree 两顶点论文全链

### 4.1 路线独立性

- 论文路线在加载 MadStree 前读取冻结附件，独立构造五维 DE、五支 Frobenius 边界和 FlintNDE
  JSON；不读取 `MSDLogDE`、`MSBoundaryData` 或 MadStree runtime payload。
- package 路线实际调用五个必需公开入口；少调用 `MSBoundaryData` 的反例被完整性门禁拒绝。
- 论文变量与 MadStree 变量固定为 `e12=-k12,e34=-k34`，五个 master 使用 identity basis；没有
  从最终数值差拟合 adapter。

### 4.2 Exact 结果

- master 顺序：论文 `{I00,I01,I10,I11,IR}` 对 MadStree `{00,01,10,11,child}`。
- `{k12,k34,ks}` 三个 `5x5` 连接矩阵分别 `25/25`，非零差值均为 0。
- 五支 Frobenius exponent：`{9,38/5,31/5,24/5,46/5}`。
- 五个 coefficient residual、boundary weight residual、weighted leading-vector residual 全部为 0。

### 4.3 数值结果

- 三个普通点：`{30,6}`、`{24,8}`、`{18,9}`，其中后两点包含非交换对称点。
- 3 点 x 5 分量 = 15 行，MadStree NDE、论文 DE+边界 FlintNDE、论文级数三方全部在联合预算内。
- 最大三方绝对差约 `1.4695e-37`；论文级数代回 DE 最大 residual 约 `1.9967e-36`。
- MadStree/论文 FlintNDE 实际节点数均为 `{11,3,3}`；总 wall time 19.65 s。

正式报告：`package-MadStree/independent-validation/MadStree-v0.15-validation-04-paper2411-two-vertex-gpp/000_MadStree-v0.15-validation-04-paper2411-two-vertex-gpp-report.md`。

## 5. FlintNDE 独立结果

Validation-02 使用 exact scalar 系统 `A(s)=-1/(s-1)+1/(s+1)` 与闭式解
`Y=(s+1)/(1-s)`。结果为 `12/12`：

- 18 个用户点中 `s=1` 是 true pole，返回文本 `Infinity`；奇点没有进入普通节点链。
- 同一局部基覆盖奇点双侧用户点，随后继续到局部圆外 `s=13/4`。
- 末端奇点从圆外 source 自动插入 `s=0.975` 隐藏匹配点，收敛半径 0.1。
- planned/naive wall time 为 0.05249/0.32589 s，naive/planned = 6.2083。
- planned/闭式、naive/闭式、planned/naive 最大相对误差约为
  `3.33e-42`、`8.64e-42`、`6.72e-42`。

该结果认证通用数值输运与奇点规划，不认证 dS 图、master 或论文 normalization；这些已在
MadStree Validation-04 的 handoff 层另行认证。

## 6. 已确认发现

### [高] dSIBP active UserMI import 没有把 backend master token 恢复为 `userMI`

**预期契约。** dSIBP 技术说明规定 active-basis import 的公开 `masterTokens` 使用 `userMI[i]`，
`DSKiraImport -> DSDE` 应消费同一 manifest 的双向映射并闭合到 19 项。

**实际实现。** `package-dSibp/independent-benchmark/package/package_022.0.wl:11557-11563` 已选择
active expressions/tokens，但 `reductionRules` 只应用 `repKira2J`。Fresh manifest 在
`activeBasis -> userMI -> backendToUserMIRules` 明确保留 21 条 `Tuserweight[i] -> userMI[i]`，
consumer 没有应用。

**触发条件。** 用 `DSUserMI` active basis 导出 user-defined Kira system，再由公开
`DSKiraImport` 读取 reduction。

**直接后果。** 全部 import provenance/coverage 门禁通过，但 `DSDE` 返回 `notClosed`；19 个
`Tuserweight[1..19]` 留在 source，正式矩阵为零/不可用。

**下游传播。** Pure massive bubble 的论文 DE 和 scaling 闭环被阻断；任何 active UserMI family
都有同类风险。普通 backend master、没有 active UserMI 的路线不由本次触发证据覆盖。

**复核证据。** Fresh Kira：6,006 equations、19 masters、215 targets、0 unreduced。只在
`reductionData` 副本应用冻结的 21 条 manifest 映射后，同一个公开 `DSDE` 得到
`P0/ip0/ks` 各 `361/361`、0 residual token、0 fixed-parameter residual。该诊断不能计作 package
通过，但精确定位 consumer 缺口。

**修复边界。** 在 `DSKiraImport` active route 应用 validated manifest map；保留 artifact identity、
master order、target coverage、coefficient domain 和 residual 门禁。禁止在 `DSDE` 猜 token 名或
保留 adapter/fallback。

**验收。** 原样 public route 必须 `generated`、0 backend token、三矩阵各 `361/361`；缺失/篡改
map 的反例仍 fail closed。

### [中] 独立任务书仍有已定义但未执行的功能 case

本轮已把缺失项写入任务书，但不能因“任务已写”标为验证通过：

- MadStree Validation-01/02/03 尚无当前正式 fresh 结果；Validation-05 递推/约化、H/h 换基、
  dSIBP 表示桥，以及 Validation-06 单顶点/time graph/regulator 重建均未执行。
- FlintNDE Validation-01/03 尚未执行为现行正式 case；新增 Validation-04 高阶 pole/指数型与
  fail-closed、Validation-05 savepoint/regulator/Mathematica bridge 均未执行。
- dSIBP 15.7 已执行但因 package consumer 缺陷失败；不能用诊断映射或历史 package_014 结果替代。

### [低] TODO/手册状态与当前证据存在滞后

- `package-MadStree/versions/MadStree-v0.15/Documentation/todolist_v0.15.md:13-14` 仍把已完成的
  双侧 bucket/Vendor 同步和 fresh 验收列为未完成。
- `package-FlintNDE/versions/FlintNDE-0.5.0/todolist.md` 仍保留相同的双侧 bucket/继续输运待办。
- dSIBP 手册声称 active UserMI import 的 `masterTokens` 使用 `userMI[i]`，但当前 consumer 缺陷使
  这一用户流程实际失败；修复前应在已知问题中明确说明，不应继续把 example 的 retained reduction
  当作当前 fresh 证据。

这些不改变本轮数值结果，但会让维护者误判功能和验证状态。

## 7. 任务书覆盖审阅

| 功能 | 当前独立证据 | 任务书状态 |
|---|---|---|
| dSIBP `ds` 系数乘积法则 | 树图 witness：正确 `-1`，过早代值为 `0` | 15.6 已明确 |
| dSIBP tree 数值 IBP -> 论文 DE | 三变量各 `25/25` | 15.6 已执行通过 |
| dSIBP loop numeric Kira -> active UserMI DE | Kira 成功，public import/DE 失败 | 15.7 已执行失败 |
| MadStree master/dlog/boundary/NDE 论文全链 | Validation-04 `24/24` | 已明确且通过 |
| MadStree 辅助零外腿、有限奇点、bucket | 开发/adapter 证据，不是当前真实包级 fresh case | Validation-01--03 待执行 |
| MadStree recurrence/H-h/bridge | 本轮未验证 | 新增 Validation-05 |
| MadStree vertex/time graph/ep reconstruction | 本轮未验证 | 新增 Validation-06 |
| FlintNDE singular bucket/terminal match | Validation-02 `12/12` | 已通过 |
| FlintNDE exact target classification/Vendor sync | 回归有覆盖，正式独立 case 未执行 | Validation-01/03 待执行 |
| FlintNDE high-pole/exponential/Stokes fail-closed | 手册说明能力边界，本轮未独立执行 | 新增 Validation-04 |
| FlintNDE savepoint/regulator/Wolfram bridge | 本轮未独立执行 | 新增 Validation-05 |

任务书措辞修订还包括：

- dSIBP 直接列出第五个 master `J["0",{0},{}]/ks`，明确论文物理 prefactor 不进入 package basis；
- dSIBP bubble 明确只能数值 Kira reduction，禁止解析 reduction table；
- MadStree/FlintNDE 明确数值非零差异在预先固定的联合误差预算内属于正常误差；
- FlintNDE 明确只认证通用 DE/boundary transport，不认证上游物理定义。

## 8. 功能和手册改进建议

### dSIBP

1. 优先修复 active UserMI import consumer，并新增 release gate：fresh 小型 user-defined Kira fixture
   必须走到公开 `DSDE`，不能只检查 manifest/round-trip。
2. 手册在 `DSKiraImport -> DSDE` 章节增加 active basis token 数据流图和已知问题状态；Kira/Fermat
   是外部环境时给出最小环境检查示例，但继续保持 package 不管理本机路径的边界。
3. 报告同时列 package master expression、backend token、userMI token 三种顺序，减少出现
   “import 验证通过但 consumer 未转换”的盲区。

### MadStree

1. 用户手册应把 `TargetRelativeError` 明确解释为主/参考链误差估计，不是逐位相等保证，并给出
   联合误差预算的推荐报告字段。
2. 增加 Validation-05/06 后，为 `MSReduce` 的合法 shift/sector 范围、已积分对象不能唯一 H/h
   换基、regulator 点池耗尽等 fail-closed 状态各给一个用户例子。
3. 同步清理已完成 TODO，避免 README、TODO 与正式 validation 互相矛盾。

### FlintNDE

1. README 已正确声明 Q(i)、ramification、algebraic extension 和 Stokes 限制；建议再增加一张
   “普通点/正则奇点/可降高阶 pole/start-only 指数/需 Stokes”能力表，逐类写明可输运到
   start/intermediate/end 的范围。
2. 独立 case 应覆盖 Python 与 Mathematica bridge 的同一数值系统，而不只检查 `Needs`；保存
   cold/resume timing、schema 和 Infinity round-trip。
3. Regulator reconstruction 的手册应集中说明拟合点/验证点严格分离、候选耗尽和
   `precisionTargetMet=False` 的用户处理方式。

## 9. 应保留的合法门禁

- dSIBP 的 artifact identity、active master order、target coverage、coefficient domain、residual
  closure 不得为了修复 token map 而放宽。
- MadStree 的公式资产写出、完整参数闭合、边界 chart certificate 和未认证局部模型 fail-closed
  必须保留。
- FlintNDE 对 defective/repeated formal block、ramification、代数扩域和缺 Stokes connection 的
  拒绝是正确边界，不是“为了跑通”应删除的限制。

## 10. 接手复核与未决边界

dSIBP 详细报告：`package-dSibp/000-report/2026-08-23-1857-022-内部.md`。

MadStree 最小命令：

```powershell
wolframscript -file package-MadStree\independent-validation\MadStree-v0.15-validation-04-paper2411-two-vertex-gpp\run_validation.wls
```

本次没有执行 MadStree Validation-01--03/05--06、FlintNDE Validation-01/03--05，也没有修复 dSIBP
正式源码。它们必须保持未验证/待修复状态。大型 dSIBP Kira runtime 在轻量证据回收后清理；
MadStree Validation-04 的长 JSON、cache 和 formula runtime 已由 runner 自行删除。
