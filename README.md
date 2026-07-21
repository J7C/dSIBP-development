# dS-IBP-Package

面向 de Sitter 圈图的通用 IBP seed 生成框架。目标是支持任意圈数、任意拓扑以及 massive/massless 混合函数族，用统一 `J` 表示生成 time-IBP、loop-momentum IBP、独立变量微分方程 seed、即时 EOM/canonical seed，并转换为后端中立线性系统。Kira 只是可选 serializer；package 不负责运行 reduction。

## 先看这里

- 当前任务、真实完成状态和交接顺序：`研究计划与研究进度.md`
- 用户手册：`000_note/01_dS_ibp_package/dS_ibp_package.tex`，PDF 同目录
- 独立 benchmark 交付：`independent-benchmark/independent-benchmark.md`；冻结手推结果后使用 `independent-benchmark/package/package_012.wl`、`package_012.pdf` 和三个典型应用 examples
- 长期总体架构：`000_note/dS_IBP_package_plan.md`
- 设计约定：`000_note/dS_IBP_package_design_note.md`
- 技术公式：`000_note/dS_IBP_package_tech_note.tex`
- 给其它 AI 的独立推导任务书：`independent-benchmark/independent-benchmark.md`

每次收到新任务，先更新 `研究计划与研究进度.md`；不要把逐任务 todolist 写进总体 plan。

## 当前主线

- `000_code/012_dS_ibp_general.wl`：当前开发主线。
- `000_code/011_dS_ibp_general.wl`：上一开发版，保留 v011 报告对应行为。
- `000_code/010_dS_ibp_general.wl`、`000_code/009_dS_ibp_general.wl`、`000_code/008_dS_ibp_general.wl`、`000_code/007_dS_ibp_general.wl`：工作树内保留的历史版本。001--006 及其专用检查不再保留。

012 已实现：

- topology-driven 输入解析，不硬编码 bubble。
- 统一积分表示 `J[aList, linePacks, ispList]`。
- massive/massless full/cross line pack 与 theta-boundary shrunk sector。
- 完整 `L(L+K)` 个 loop-momentum IBP 生成元和每个 active vertex 的 time 生成元。
- massive EOM、massless 有序端点 `n=0/1` canonical、coincident massive endpoint canonical、massive/massless theta shrink。
- 同一代表顶点对的 full lines 使用共同-theta odd-subset contact；一次事件只合并一次顶点，shrink sectors 只枚举 contact 可达状态。
- momentum IBP 对传播子、building block 和 ISP/numerator 因子求导。
- 独立变量微分方程 seed：`ke[i]` 顶点能量标量求导，以及外不变量经 `k_i.d/dk_j` 矢量导数组合求导。
- 解析 seed 保存、后端中立 `linearData`、基础 Kira serializer。
- 公开原子 API：`dtau/dqq/dqk`、`rep2innerform/rep2outform/rep2Integrand`；支持显式 topology 或已注册 context。
- massive line 的 `P,Q,T,W[,WT]` 初始化编译层；`AT` 编译为 `derivativeTerms`，`WT=Det[T] W` 编译为 `shrinkTerms`，time/momentum IBP 与 theta shrink 只读取编译结果。
- h/H 纯数据 presets。缺省 massive 模式是 h：`T=IdentityMatrix[2]`、`W=WT=W_h`；裸 H preset 的 `AT` 含 `nu^2/x^2` 二次 pole。

共同-theta boundary 是当前最高优先级正确性门禁，不是可选优化。完整链路必须同时覆盖 `WT -> shrinkTerms`、simultaneous integer/zero-point shift、coincident canonical、contact-reachable sector、linearData 和 serializer；专项清单见 `000_note/2026-07-21_common_theta_correctness_todo.md`，两种等价分布方案的证明见技术笔记附录。

公开 API 示例：

```mathematica
dtau[v, expr, topo]
dqq[i, j, expr, topo]
dqk[i, j, expr, topo]
rep2innerform[expr, topo]
rep2outform[expr, topo]
rep2Integrand[expr, topo]

setIBPTopologyContext[topo];
dtau[v, expr]  (* short form *)
```

当前仍未完成：

- 正式 Mathematica `BeginPackage` context。

## 核心表示

所有 sector 使用同一个 Head：

```mathematica
J[aList, linePacks, ispList]
```

- massive full/cross：`{b[e], n[e,1], n[e,2]}`
- massless full：`{b[e], n[e]}`；仍保留逐线 pack，但共享顶点对的 boundary 按共同 theta 处理
- massless cross：`{b[e]}`
- shrunk line：`{bS[e]}`
- massive shrink：整数指标 `bS=b+1`
- massless shrink：整数指标 `bS=b`
- massive Wronskian 的整数 `1/(-tau)` 使 merged `a` 减 1；massless delta 不产生该移位
- 一次共同 boundary 可同时 shrink 任意非空奇数条 bundle 线，系数为 `2^(1-k)`；它仍只有一个 delta
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

012 提供 seed 层接口：

```mathematica
makeExternalInvariantDerivativeDecomposition[topo, var]
applyExternalVectorDerivativeSeed[topo, int, gen]
applyExternalInvariantVariableDerivativeSeed[topo, int, var]
applyIndependentVariableDerivativeSeed[topo, int, var]
```

`applyIndependentVariableDerivativeSeed` 自动分派：

- 若 `var` 是 `ke[i]` 等独立顶点能量参数，只对顶点指数相位做标量求导。
- 若 `var` 是外不变量，先在外不变量约束坐标上把 `∂/∂var` 解成 `k_i . ∂/∂k_j` 的线性组合，再作用到传播子、building block、ISP 和相关顶点能量表达式。

massive building block 的动力学量导数与 qIBP、tIBP 自动读取同一份最终 `AT -> derivativeTerms`，因此 h、裸 H 和一般 `P,Q,T,W` 不会出现两套导数 convention。`WT/shrinkTerms` 只用于 time-IBP 的 theta/Wronskian shrink，普通动力学量导数不使用它。

外动量矢量导数分解的完整 `K^2` 算符空间一般有零空间，解不唯一。当前默认使用上三角 canonical basis，并在 decomposition 数据中返回矩阵、系数、残差、`nullity` 与 `nonUniqueQ`。

## 验证

当前 examples/checks：

- `atomic_massless_line`：22/22 + 8/8
- `atomic_massive_line`：104/104
- `pure_massless_bubble`：64/64
- `mixed_bubble`：132/132
- `mixed_triangle`：1792/1792
- `pure_massive_bubble_reference`：608/608（h/H 各 304）
- `parallel_massless_bundle_guard`：194/194
- `mixed_sunrise`：1842/1842
- `two_loop_isp_toy`：978/978
- `vertex_energy_signs`：90/90
- `independent_variable_derivatives_check.wl`：覆盖 `ke[i]`、`s11` 和两外动量时的非唯一 decomposition
- `000_code/test/012_theta_bundle_and_report_audit_test.wl`：30/30
- 011 的 function-system、public API、symmetry、massless direction、SP/cache 与 serializer 检查作为 012 的继承回归输入；012 的新增测试只放在 `000_code/test/`。

这些是 seed/example 层验证记录，不等于对任意拓扑的数学穷尽证明。serializer 检查不运行 Kira/Fermat。

## 运行示例

```powershell
wolframscript -file '000_code\examples\independent_variable_derivatives_check.wl'
wolframscript -file '000_code\test\012_theta_bundle_and_report_audit_test.wl'
wolframscript -file '000_code\examples\hand_derived_cross_checks\mixed_bubble_check.wl'
```

所有 WolframScript 检查应显式输出结果；不要用 `Quiet` 掩盖消息。
