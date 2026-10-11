# 边界记录与后端输入对应

## 实际保存的边界

四支完整原件位于 `results/native/*_result.wl`；这里的 `extracted/*_boundary.wl` 是其 `result.boundary` 字段文本副本。`leading_records.json` 保留每一支的扇区、状态、rootGlobalIndex、Frobenius 指数、logPower、coefficient、physicalWeight 和 normalizedLeadingVector 的原表达式。

边界是 `singularFrobenius`，`singularStart=0, singularTarget=1`。局部变量、曲线、锚点、目标点、BoundaryScale 和 rank 均列入 `path_records.json`。保存的 `ordinaryAnchorQ=False` 不被改写为 True。边界记录的 `normalizationIncludedQ=True`；physicalWeight 已包括扇区归一化和各分量的 anchorFactor，不应再自行重复乘入。

根基底共有 pp/mm 各 22 条、pm/mp 各 16 条 leadingBranches。每条含同维 normalizedLeadingVector。`logPower=0` 是这些保存领头分支的数据，不据此宣称任意情况下没有共振或对数问题。后端实际边界路径从已展开的 t_b≈1/3 的点开始，经过保存的中间节点到 1；奇异起点依然是 t_b=0，不能把第一次数值节点误记成物理边界定义。

## 接触扇区对应表

| 分支 | 扇区 | 夹缩线 | 保留线 | 保留线两端 | 状态/全局索引 | 实际边界 Hankel 排列 |
|---|---|---|---|---|---|---|
| pp | 01 | 1 | 2 | 同一时间分量 | 00/17，01/18，11/19 | 固定 `(1,2)` |
| pp | 10 | 2 | 1 | 同一时间分量 | 00/20，01/21，11/22 | 固定 `(1,2)` |
| mm | 01 | 1 | 2 | 同一时间分量 | 00/17，01/18，11/19 | 固定 `(2,1)` |
| mm | 10 | 2 | 1 | 同一时间分量 | 00/20，01/21，11/22 | 固定 `(2,1)` |

上述排列取自固定源码的 `SameQ @@ endpointComponents` 分支并与原结果核对。`thetaFixing` 对两个接触扇区标为 `coincident/equalTime`。原生实现把单导数状态 10 合并为 01；论文定义要求保留线的两种完整 Hankel 乘积取平均。二者的差异见 [审查说明](../review/REVIEW.md)。原值没有被候选正确系数替换。

## 物理定义到后端的证据链

| 步骤 | 固定源码/原记录 | 本目录状态 |
|---|---|---|
| 物理平均定义 | 论文 `eq:bundle-odd-subsets`、附录 Step 4 | 原文节录已附 |
| 端点选择与 coefficient | `Boundary.wl`：`msBoundaryHankelBranch`、`msGenericSectorLeadingRecord` | 固定代码和实际 leadingBranches 已附 |
| 物理权重 | `Boundary.wl` 555–557：coefficient×anchorFactor | 原 physicalWeight 已附 |
| 序列化 | `PathEvaluation.wl` 335–367 `msEvaluationBoundaryInput`；`FlintNDE.wl` 380–390 `msFrobeniusBranchRecord` | 原代码已附；成功请求的输出文件缺失 |
| 后端计算 | `flintnde_transport.py` `_initial_vectors`，读取 `branches`、`weights`，按权重合并 | 成功 process 命令和后端输出已附 |

序列化规则为：`singularConnection→boundary.matrix`；`frobeniusExponent→a`；`logPower→b`；`normalizedLeadingVector→C`；`physicalWeight` 按所设 digits 数值化后进入 `weights`。系数在符号原记录中齐备；成功请求里的数值舍入字符串没有保存，**本轮不求值来补造**。

## 缺失的成功请求

| 分支 | 成功 process 命令中记载的输入文件 | 当前状态 |
|---|---|---|
| pp | i-cd2c920de1d34279.json | 未找到 |
| pm | i-03dfc1b763a34b40.json | 未找到 |
| mp | i-c523b7597e274c42.json | 未找到 |
| mm | i-53faae6a72344765.json | 未找到 |

本轮在原 case 文件树中按精确文件名检查。固定源码 `FlintNDE.wl` 第373行在成功后删除 inputFile、logFile；成功结果仍保存 process 的 Command、ExitCode、StandardError/Output。四份后端输出已逐字另存至 `results/backend_outputs/`。

`prior_failed_attempt_inputs/` 只放上一轮 **rational120、尚未调整 Python 整数字符串限制** 的四份请求和对应失败结果。它们包括完整 `matrix/branches/weights/segments`，可帮助检查当时的编码结构，**不作为成功运行的原始输入证明**。这些输入的来源和失败 run 已分开登记；不将其名义上改成成功版本。本目录不以这个解析报错解释同号物理差异。

成功运行未单独保存 t_b=1 处 primary/reference 的完整初值向量及两条链全部局部递推系数。已有 leadingBranches、物理权重、边界连接、路径和终值，但它们不能替代这部分缺失中间记录。
