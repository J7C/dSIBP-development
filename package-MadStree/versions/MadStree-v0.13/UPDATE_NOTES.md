# MadStree v0.13 更新说明

## 基线与破坏性接口

v0.13 基于冻结的 v0.12。公式、sector DAG、dlog、FlintNDE 输运和正规化算法保持，
顶点外腿指数参数从旧 `energy` 破坏性改名为 `externalLegEnergy`。当前版本不保留旧键、
别名、wrapper、fallback 或兼容测试。

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

- core topology/formula `56/56`，含 `+/-` 外腿相位和独立 contour sign。
- massless `++/--` 定义积分与 dlog 回归 `10/10`。
- dSIBP 022 `ds` 与 MadStree 15×15 dlog DE 对五个变量逐项一致 `9/9`。
- vertex-family/reduction `19/19`，planned/direct 多点 `21/21`，cycle/chart `22/22`。
- 两条指定 arXiv URL 已在 Wolfram 实际加载和 Python CLI 中逐字核对；禁止项
  `2604.14549/2201.11669` 不出现在 MadStree 引用清单。

全部 examples、Python/Wolfram 回归、当前独立验证、PDF、UTF-8 和清理门禁的最终状态以
根 `研究计划与研究进度.md` 的本轮验收记录为准。

## 迁移要求

所有顶点输入、验证 runner 和下游读取必须改用 `externalLegEnergy`。旧 `energy` 即使存在
也不能补足新必需键。`vertexType="+"` 的正阻尼点取 `externalLegEnergy=+I K`；
`"-"` 取 `-I K`。

## 已知限制

MadStree 不生成一般 loop-momentum IBP，也不运行 Kira。公式、dlog 或边界 chart 未闭合时
继续 fail closed；不会回退到慢速定义积分或旧路径接口。

## 2026-08-19 审计清理

- 正式 Kernel 删除已于 v0.10 退出生产、且没有测试消费者的单顶点 Frobenius 特殊路线；
  generic sector-DAG boundary 仍使用唯一的 `msVertexEndpointCoefficient`。
- 删除 `$msSupportedInternalLineTypes`、`msExternalLineQ`、`msIdentityForSector`、
  `msBoundaryAnchorRules` 和 Python `_load_input` 五个无消费者定义，不增加 alias 或 wrapper。
- 同步删除 Vendor FlintNDE 0.4.0 的退休 epsilon 局部求解簇和两个孤立函数。
- 修复后 core `58/58`、generic boundary `10/10`、package artifact `18/18`、Python adapter
  `11/11`、Vendor Python `170/170` 全部通过。
