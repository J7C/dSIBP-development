# MadStree v0.15 更新说明

本版从 v0.14 建立。辅助外腿能量、Automatic 奇点目标和 FlintNDE 0.5.0 已在本版实现，
完整开发回归和七个 examples 已从空结果目录 fresh 重跑；独立验证按当前任务书另行执行。
v0.14 仅作为基线，不提供兼容入口。

## 奇点目标输出

命中 dlogDE 有限奇点的用户点不再与普通点混淆：局部幂对数解判定为真实 pole 或零阶
log 发散时，逐分量结果写为文本 `Infinity`；可去奇点保留数值。所有命中的奇点和证据
集中写入 `singularityClassifications`，包括 `removable_singularity`、`true_pole` 和
`log_divergent_singularity`。`Automatic` 模式把中间精确奇点从普通节点链移除，由同一
FlintNDE 局部基覆盖收敛域内双侧用户点，并从出射普通点继续。末端奇点若需匹配，则按
目标奇点到最近其它奇点的距离插入隐藏普通点；低阶主链输出结果，高阶参考链只做分类与
有限值精度核验。奇点处非共线转向、连续奇点和关闭规划后的中间奇点继续 fail closed。
候选奇点只由完整拉回 DE 的 exact 有理矩阵/letters 决定，不按变量名、零坐标或拓扑分派；
独立 FlintNDE 回归已在非零复位置 $2+i$、另有有限奇点 $5+i$ 共存时同时得到可去与真实
pole 分量。Example 05 另以独立调用计算四个 `k2=0` 点；它们的完整 letters 均非零，故全部
按普通点保存，分类表为空。

## 基线与破坏性接口

v0.15 基于冻结的 v0.13。v0.13 已有的拓扑、normalized master 定义、sector DAG、dlog、
FlintNDE 输运和正规化算法保持。本版破坏性替换数值点输入：不再接受逐点规则列表，固定参数
只通过 `ParameterRules` 一次给出，可跑动坐标只通过 `pointSequence` 表头和值行给出。不保留
旧 schema、解析分支、wrapper、fallback 或兼容测试。

顶点唯一格式为

```wl
<|
  "id" -> 1,
  "vertexType" -> "+",
  "externalLegEnergy" -> E1,
  "timePower" -> a1
|>
```

`vertexType="+"` 唯一给出 `Exp[-I externalLegEnergy tau]`，`"-"` 唯一给出
`Exp[+I externalLegEnergy tau]`。内部把外腿指数符号 `vertexSign=-1/+1` 与 SK
`contourSign=+1/-1` 分开保存；传播子 Full/Cross/External、端点符号和 contact 数据只从
端点类型派生。line 不设公开 ID，按输入顺序内部编号。

`MSInitVertexFamily` 的显式模型同步只接受 `externalLegEnergy`；context metadata 使用
`userExternalLegEnergy/baseExternalLegEnergy/effectiveExternalLegEnergy`，不保存含混旧名。

## 主积分定义

- `MSIntegral[s,n,a]` 继续是 recurrence、DE 和数值层使用的 normalized master $J_s(n;a)$。
- 新增惰性 `MSBareIntegral[s,n,a]` 和 `MSIntegralDefinition[integral,context]`，用完全相同的
  sector、shift 与二态指标返回精确 $J_s=\mathcal N_s I_s$。
- `MSMasterIntegrals` 的同序记录直接增加 `bareIntegral` 与 `definition`；原有 `integral`、
  normalization、顺序和 digest 不变。top normalization 为 1 时显示 $J_s=I_s$。
- 手册把二态因子数记为 $n_s^{\mathrm{slot}}$，normalization 只记为 $\mathcal N_s$，并修正
  边界权重中曾把后者写成普通 $N_s$ 的符号 typo。

## 数值和正规化

- `MSEvaluatePath` 的第二参数统一为坐标表 `pointSequence`：首行是有序坐标符号，后续是等宽
  值行；单点只有一行值，多点追加值行，临时点写成 `{{values...},"tmp"}`。
- 固定、不可偏导参数只用 `ParameterRules` 一次给出。它与表头必须互斥，二者必须覆盖解析
  DE 与边界的全部必需符号；缺失或非数值时在 Python/FlintNDE 启动前返回明确 `Failure`。
- `MSReconstructEpSeries` 使用同一坐标表和固定参数合同；regulator 只允许出现在
  `ParameterRules` 右端，不允许进入路径坐标值。
- `MSDLogDE` 与 `MSWriteFormulaArtifacts` 始终保留、落盘完整解析 DE。所有公开数值入口在
  启动 Python/FlintNDE 前自动写出或复用同一 context/调用根的正式公式资产，返回实际路径；
  任一文件写出失败时 NDE 不启动。数值阶段只在函数内部派生参数化副本，不覆盖 `dlog_de.wl`。
- `MSEvaluatePath` 仍只划分最大连续复仿射单变量段；每段 exact 拉回一次，节点规划及
  fast multipoint 均由 FlintNDE 完成。
- `FlintNDEPathPlanning -> True|False` 分别选择后端自动规划或严格用户节点。
- `TransportOrder` 是低阶生产链；更高的 `ReferenceTransportOrder` 只做精度核验，不替换
  用户输出或下一段 primary 初值。
- `MSReconstructEpSeries` 继续从边界与 DE 自动认证最低 Laurent 幂，缺省内部多拟合两阶；
  精度不足时增量提高拟合阶数并复用已有点。
- `EpSamplePoints` 提供冗余候选池，`EpValidationPoints` 保留独立点；候选耗尽仍返回当前
  系数并标记 `computed_with_warning/candidate_pool_exhausted`，不生成池外点。
- `EpSampleAngleRange->{thetaMin,thetaMax}` 约束复角开区间；程序最多使用三条均匀内部射线，
  模长仍由精度策略决定。
- `ParallelTaskCount` 缺省 12，按固定 regulator 值分配独立进程并自动续交队列。

## 加载与引用

16 个模块和代表定义全部加载成功后，每个 Wolfram kernel 显示一次引用提醒。Notebook
使用真正的 `Hyperlink`，headless 输出完整 URL。条目严格为 `2401.00129`、
`2411.03088` 和 `MadStree package paper, arXiv identifier pending`。

Python adapter 的文件协议响应在 `metadata.citationNotice` 保存同一清单，不向 stdout
打印引用；无参数人工 CLI 显示文本。Vendor FlintNDE 的自身 import 提示在协议进程中显式
静默，避免混入 MadStree 日志。

## 验证状态

- core topology/formula `58/58`，公式 artifact `24/24`。
- point-sequence/planning `27/27`，二维 900 点复平面分组 `8/8`，vertex-family NDE `13/13`，
  runtime/export `10/10`。
- massless、massive Full、massive vertex、mixed 三顶点分别 `10/10`、`6/6`、`8/8`、`8/8`。
- 七个 examples 从空输出目录全部退出 `0`；Example 06 为 `16/16`，Example 07 为 `5/5`。
- v0.15 独立验证任务书已同步新接口，但本轮未运行独立验证；旧版本报告和结果已删除。

PDF、UTF-8 和清理门禁的最终状态见根 `研究计划与研究进度.md` 的本轮验收记录。

## 迁移要求

所有数值调用必须改用表头/值行 `pointSequence` 与一次性 `ParameterRules`。旧逐点规则列表
不再被读取。v0.13 已完成的 `externalLegEnergy` 与 `vertexType` 拓扑合同保持不变。

## 已知限制

MadStree 不生成一般 loop-momentum IBP，也不运行 Kira。公式、dlog 或边界 chart 未闭合时
继续 fail closed；不会回退到慢速定义积分或旧路径接口。

## 2026-08-19 审计清理

- 正式 Kernel 删除已于 v0.10 退出生产、且没有测试消费者的单顶点 Frobenius 特殊路线；
  generic sector-DAG boundary 仍使用唯一的 `msVertexEndpointCoefficient`。
- 删除 `$msSupportedInternalLineTypes`、`msExternalLineQ`、`msIdentityForSector`、
  `msBoundaryAnchorRules` 和 Python `_load_input` 五个无消费者定义，不增加 alias 或 wrapper。
- 同步删除 Vendor FlintNDE 0.5.0 的退休 epsilon 局部求解簇和两个孤立函数。
- 修复后 core `58/58`、generic boundary `10/10`、package artifact `18/18`、Python adapter
  `11/11`、Vendor Python `170/170` 全部通过。
