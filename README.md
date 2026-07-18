# dS-IBP-Package

面向 de Sitter 圈图的通用 IBP seed 生成框架。目标是支持任意圈数、任意拓扑以及 massive/massless 混合函数族，用统一 `J` 表示生成 time-IBP、loop-momentum IBP、独立变量微分方程 seed、即时 EOM/canonical seed，并转换为后端中立线性系统。Kira 只是可选 serializer；package 不负责运行 reduction。

## 先看这里

- 当前任务、真实完成状态和交接顺序：`研究计划与研究进度.md`
- 用户手册：`000_note/01_dS_ibp_package/dS_ibp_package.tex`，PDF 同目录
- 长期总体架构：`000_note/dS_IBP_package_plan.md`
- 设计约定：`000_note/dS_IBP_package_design_note.md`
- 技术公式：`000_note/dS_IBP_package_tech_note.tex`
- 给其它 AI 的独立推导任务书：`independent-benchmark/independent-benchmark.md`

每次收到新任务，先更新 `研究计划与研究进度.md`；不要把逐任务 todolist 写进总体 plan。

## 当前主线

- `000_code/009_dS_ibp_general.wl`：当前开发主线。
- `000_code/008_dS_ibp_general.wl`：上一开发版。
- `000_code/007_dS_ibp_general.wl`、`000_code/006_dS_ibp_general.wl`：历史/旧稳定接口参考。

009 已实现：

- topology-driven 输入解析，不硬编码 bubble。
- 统一积分表示 `J[aList, linePacks, ispList]`。
- massive/massless full/cross line pack 与 theta-boundary shrunk sector。
- 完整 `L(L+K)` 个 loop-momentum IBP 生成元和每个 active vertex 的 time 生成元。
- massive EOM、massless 有序端点 `n=0/1` canonical、massive/massless theta shrink。
- momentum IBP 对传播子、building block 和 ISP/numerator 因子求导。
- 独立变量微分方程 seed：`ke[i]` 顶点能量标量求导，以及外不变量经 `k_i.d/dk_j` 矢量导数组合求导。
- 解析 seed 保存、后端中立 `linearData`、基础 Kira serializer。

尚未封装成最终公开 API：

- `dtau[i, expr_]`
- `dqq[i, j, expr_]`
- `dqk[i, j, expr_]`
- `rep2innerform[expr_]`
- `rep2outform[expr_]`
- `rep2Integrand[expr_]`

## 核心表示

所有 sector 使用同一个 Head：

```mathematica
J[aList, linePacks, ispList]
```

- massive full/cross：`{b[e], n[e,1], n[e,2]}`
- massless full：`{b[e], n[e]}`，采用双 theta 合并路线
- massless cross：`{b[e]}`
- shrunk line：`{bS[e]}`
- massive shrink：整数指标 `bS=b+1`
- massless shrink：整数指标 `bS=b`
- 缩并后 delta 积掉一个时间变量，合并顶点只保留一个 compact `a`

实际幂次包含用户给出的非零零点 `a0/b0/bS0`。新 benchmark 禁止把这些零点偷偷设为 0。

## 输入边界

用户自行给出：

- `vertexData`：顶点 id 与 `+/-` 分支
- `lineData`：内线 id、有序端点、动量、质量类型和 building-block 参数
- `loopMomenta`：独立圈动量
- `externalMomenta`：会进入内线动量并与圈动量做标量积的独立外动量
- `ispData`：补齐 loop scalar-product 空间的 ISP
- `vertexEnergies`：只进入顶点时间相位的外腿打包能量
- `externalInvariantRules`、`zeroPointRules`、`numericRules`、`symmetryRules` 和 seed 范围

用户端标量积统一写 `sp[p,q]`。`sp` 具有 `Orderless` 属性，只表示标量积交换性，不表示图或积分族对称性。外动量-外动量标量积输出为默认 `sij` 或用户指定变量。

只进入顶点相位且不与圈动量纠缠的外腿能量使用独立参数 `ke[i]`。若某个顶点能量应与外不变量共用同一变量，应显式写成例如 `Sqrt[s11]`。

## 微分方程变量求导

009 提供 seed 层接口：

```mathematica
makeExternalInvariantDerivativeDecomposition[topo, var]
applyExternalVectorDerivativeSeed[topo, int, gen]
applyExternalInvariantVariableDerivativeSeed[topo, int, var]
applyIndependentVariableDerivativeSeed[topo, int, var]
```

`applyIndependentVariableDerivativeSeed` 自动分派：

- 若 `var` 是 `ke[i]` 等独立顶点能量参数，只对顶点指数相位做标量求导。
- 若 `var` 是外不变量，先在外不变量约束坐标上把 `∂/∂var` 解成 `k_i . ∂/∂k_j` 的线性组合，再作用到传播子、building block、ISP 和相关顶点能量表达式。

外动量矢量导数分解的完整 `K^2` 算符空间一般有零空间，解不唯一。当前默认使用上三角 canonical basis，并在 decomposition 数据中返回矩阵、系数、残差、`nullity` 与 `nonUniqueQ`。

## 验证

当前 examples/checks：

- `atomic_massless_line`：22/22 + 8/8
- `atomic_massive_line`：104/104
- `pure_massless_bubble`：70/70
- `mixed_bubble`：138/138
- `mixed_triangle`：1800/1800
- `pure_massive_bubble_reference`：310/310
- `parallel_massless_bundle_guard`：242/242
- `mixed_sunrise`：2178/2178
- `two_loop_isp_toy`：1230/1230
- `vertex_energy_signs`：90/90
- `independent_variable_derivatives_check.wl`：覆盖 `ke[i]`、`s11` 和两外动量时的非唯一 decomposition
- `009_symmetry_check.wl`、`009_massless_direction_check.wl`、`009_sp_interface_check.wl`、`009_scalar_product_cache_check.wl`、`009_kira_export_smoke_check.wl`

这些是 seed/example 层验证记录，不等于对任意拓扑的数学穷尽证明。serializer 检查不运行 Kira/Fermat。

## 运行示例

```powershell
wolframscript -file '000_code\examples\independent_variable_derivatives_check.wl'
wolframscript -file '000_code\examples\hand_derived_cross_checks\mixed_bubble_check.wl'
```

所有 WolframScript 检查应显式输出结果；不要用 `Quiet` 掩盖消息。
