# dS-IBP-Package

面向 de Sitter 圈图的通用 IBP seed 生成框架。目标是支持任意圈数、任意拓扑以及 massive/massless 混合函数族，用统一 `J` 表示生成 time-IBP、loop-momentum IBP、独立变量微分方程 seed、即时 EOM/canonical seed，并转换为后端中立线性系统。Kira 只是可选 serializer；package 不负责运行 reduction。

## 先看这里

- 当前任务、真实完成状态和交接顺序：`研究计划与研究进度.md`
- 用户手册：`000_note/01_dS_ibp_package/dS_ibp_package.tex`，PDF 同目录
- 独立 benchmark 交付：`independent-benchmark/independent-benchmark.md`；当前交付目录只保留 `package_015.wl/pdf`，014 源码基线在 `000_code/014_dSIBP/` 冻结不动
- 长期总体架构：`000_note/dS_IBP_package_plan.md`
- 设计约定：`000_note/dS_IBP_package_design_note.md`
- 技术公式：`000_note/dS_IBP_package_tech_note.tex`
- 给其它 AI 的独立推导任务书：`independent-benchmark/independent-benchmark.md`

每次收到新任务，先更新 `研究计划与研究进度.md`；不要把逐任务 todolist 写进总体 plan。

## 当前主线

- `000_code/015_dSIBP/`：当前模块化主线，标准入口为 `Needs["dSIBP`"]`。
- `000_code/015_dS_ibp_general.wl`：015 的单文件兼容入口。
- `000_code/014_dSIBP/`、`000_code/014_dS_ibp_general.wl`：冻结的 014 基线，不回写。
- `000_code/013_dS_ibp_general.wl`：已通过独立验收的稳定版本，新增 pure time-IBP/tree 模块。
- `000_code/012_dS_ibp_general.wl`：013 的只读核心基线。
- `000_code/011_dS_ibp_general.wl`、`000_code/010_dS_ibp_general.wl`：只读历史版本。001--009 及其专用检查不再保留。

015 在完整继承 014 的基础上，把动量模长改为缺省公开动力学坐标：进入 loop-dependent line momentum 的独立外动量使用完整 `ssij=Sqrt[sp[ki,kj]]` Gram 基；其它实际出现的无圈动量模长平方按首次出现顺序做增量秩筛选，只为独立项绑定 `sE1,sE2,...`，从属项保存为当前坐标的 binding，不自动输出外腿向量交叉点积。内部 loop 部分仍以 `kk[i,j]=sp[ki,kj]` 为原子坐标；`ssij` 导数通过 Jacobian 调用原有平方不变量导数。014 源码文件保持冻结。

014 已完成标准 loader/context、初始化 metadata、消息层、高层 seed/linear/Kira export-import/DE 接口、sector-tagged tree 迭代、naive tree time-IBP/DE，以及由 loop time-IBP `R^(1)` contact selector 自动组装的多 sector block-triangular tree dlog connection。`DSTreeNaiveIBP` 直接联立投影后的 `dtau`，`DSTreeNaiveDE` 以同序 normalized masters 构造逐变量矩阵；两顶点 `++`/`+-` 专项与直接 dlog 路线严格相等。pure massive bubble 的等能量、固定 even parity 子系统已完成 fresh Kira 2.3 reduction：33581 条方程、6555 条独立关系、19 个 active masters、1814 个选定目标全部约化；`DSKiraImport -> DSDE[{s11,P0}] -> DSScaleCheck[{2,1}]` 通过 22/22。最新独立 tree check 为 57/57；其中 general seed recurrence 10/10、终点约化 8/8、seed-derived DE 8/8。此前 ISP、H 和 general-`ds` 计数保持不变。

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

013 在上述核心上新增：loop `dtau` 到 tree 的完整物理幂次投影、`J[vertexPacks]`、general-index `repIterative0/repIterative`、有序 master list、dlog connection/letters 以及 same-sign contact source；`a0` 保留为 tree `nu0`，被删除的 `b0/bS0` 进入显式能量系数。内部独立报告为 `000-report/2026-07-21-2353-013-内部.md`。

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

014 验收记录：

- 正式单文件程序 SHA-256：`B02ED7C1D7E32189EFDAC86D31FC42D26C005031254FEF04145864F5D0B1B1E6`；21 页正式手册 SHA-256：`AB8881D2F6EC0414AB312C75B7ABC39FF9661FFE086CCD2B4E1A0F74FF3CC36E`。
- 最新增量独立报告归档于 `000-report/2026-07-22-1259-014-内部.md`；历史报告保留修正前发现，不改写为修正后结果。

pure massive bubble reference 的顶点交换 symmetry 只在等能量约束下成立。package 使用 `P0=+I k0`，reference basis 使用 `P1=P2=-P0=-I k0`；一般独立 `P1/P2` family 不得复用该 symmetry。Kira 可以在 manifest 中保存 `Sqrt[s11]` 等代数系数生成元的可逆后端原子，但 `DSDE` 的公开矩阵和 source 会统一恢复为初始化声明的外部变量，不保留内部 `kk[i,j]`。

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
- `externalMomenta`：会进入内线动量并与圈动量做标量积的独立外动量；015 缺省公开坐标为 `ssij=Sqrt[sp[ki,kj]]`
- `externalLegMomenta`：允许出现在无圈动量线和外腿相位中的向量声明；实际出现模长中只有增加平方坐标秩的组合才按顺序绑定 `sE1,sE2,...`，其余保存 dependent binding；这些向量不进入 loop IBP 生成元或 ISP 闭合性检查
- `ispData`：补齐 loop scalar-product 空间的 ISP
- `vertexEnergies`：只进入顶点时间相位的外腿打包能量
- `externalInvariantRules`、`zeroPointRules`、`numericRules`、`symmetryRules` 和 seed 范围

用户端标量积统一写 `sp[p,q]`。`sp` 具有 `Orderless` 属性，只表示标量积交换性，不表示图或积分族对称性。015 对 loop 外向量生成完整 `sp[ki,kj]->ssij^2`；对其它无圈动量只为实际出现模长平方的独立基生成 `sp[Pe,Pe]->sEe^2`。例如同时出现 `kE1`、`kE2`、`kE1+kE2` 时得到三个独立模长，不生成 `sp[kE1,kE2]`；`2 kE1` 若随后出现，则记录为 `4 sE1^2` 而不新增变量。显式给出 `externalInvariantRules -> {sp[ki,kj]->sij}` 时，旧平方不变量坐标仍以单位 Jacobian 工作。

`vertexEnergies` 是进入顶点时间相位的标量。它可以引用上述根号坐标；与任何已声明动量都无关的独立能量仍可使用 `ke[i]`。015 之前的 `ke[i]` 只是标量参数，不表示动量向量，也不自动定义点积、IBP 生成元或 ISP。

## 微分方程变量求导

015 提供 seed 层与表达式层接口：

```mathematica
makeExternalInvariantDerivativeDecomposition[topo, var]
applyExternalVectorDerivativeSeed[topo, int, gen]
applyExternalInvariantVariableDerivativeSeed[topo, int, var]
applyIndependentVariableDerivativeSeed[topo, int, var]
independentVariableDerivativeVariables[topo]
makeIndependentVariableDerivativeGenerators[topo]
makeIndependentVariableDerivativeSeedBatch[topo, int]
ds[expr, ssij, topo]
ds[expr, ssij]
```

`applyIndependentVariableDerivativeSeed` 自动分派：

- 若 `var` 是 `sEe`，程序对绑定的无圈线做径向导数，并同时处理显式系数与顶点相位；若它只出现在相位中，就没有线贡献。该路线不生成 loop IBP 方向，也不读取 time-theta 的 `WT/shrinkTerms`。
- 若 `var` 是外不变量，先在外不变量约束坐标上把 `∂/∂var` 解成 `k_i . ∂/∂k_j` 的线性组合，再作用到传播子、building block、ISP 和相关顶点能量表达式。

`makeIndependentVariableDerivativeSeedBatch` 自动枚举全部外不变量坐标和未被其表达的独立顶点能量参数，并逐变量返回 derivative、decomposition、状态、forbidden-`n` 与 canonical 检查。

公开入口 `ds[expr,var]` 使用 family 初始化时约定的外部变量名；015 缺省为 `ss11`、`ss12`、`sE1` 等，显式旧规则仍可使用 `s11`。两阶段接口是 `proposal=DSKinematics[input]`、`audit=DSKinematics[input,rules]`、`DSInit[...,KinematicRules->rules]`，不会用 `Input[]` 阻塞 batch；返回值同时列出缺省/当前规则和 `dependentMagnitudeBindings`。欠完备规则按左端矩阵或参数 Jacobian 的零空间拒绝；过完备规则允许生成内部 IBP，但禁用冗余变量 `ds` 和无唯一逆映射的 `rep2innerform`。满秩混合坐标及从属 line/phase 的 `ds` 都按完整 Jacobian 工作。`expr` 可为单个 `J` 或带动力学量系数的 `J` 线性组合；程序同时计算显式系数导数和每个积分的指标导数，再统一 canonical。

根号坐标不重写导数核心。若 `xij=sp[ki,kj]=ssij^2`，则 `partial_ssij=2 ssij partial_xij`；程序先调用原有平方不变量原子分解，再乘 Jacobian。一般显式系数仍按 `D F=Sum[(∂F/∂x_a) D x_a]` 使用完整乘积与链式法则，不使用 `PowerExpand`。

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
- `tadpole_symmetry`：8/8（含 shared-loop 与 `G+-` 防误用门禁）
- `ds_total_derivative`：9/9（单积分、系数导数、线性组合、外部变量与线性门禁）
- `all_family_total_derivative`：468/468（10 个物理 family 的全部 sign/mode、可达 sector 和独立变量；`a/b/ISP` 保持 general）
- `reference_bubble_derivative`：80/80，另有 symmetry、parity、zero-point 与 `ks^2=s11` convention 原子检查
- `independent_variable_derivatives_check.wl`：覆盖 `ke[i]`、`s11` 和两外动量时的非唯一 decomposition
- `000_code/test/012_theta_bundle_audit_test.wl`：30/30
- 011 的 function-system、public API、symmetry、massless direction、SP/cache 与 serializer 检查作为 012 的继承回归输入；012 的新增测试只放在 `000_code/test/`。

这些是 seed/example 层验证记录，不等于对任意拓扑的数学穷尽证明。serializer 检查不运行 Kira/Fermat。

## 运行示例

```powershell
wolframscript -file '000_code\examples\independent_variable_derivatives_check.wl'
wolframscript -file '000_code\test\012_theta_bundle_audit_test.wl'
wolframscript -file '000_code\examples\hand_derived_cross_checks\mixed_bubble_check.wl'
wolframscript -file '000_code\test\012_hand_derived_cross_checks\all_family_total_derivative_check.wl'
wolframscript -file '000_code\test\012_hand_derived_cross_checks\reference_bubble_derivative_check.wl'
wolframscript -file '000_code\examples\014\pure_massive_bubble_closed_loop\post_kira_check.wl'
```

所有 WolframScript 检查应显式输出结果；不要用 `Quiet` 掩盖消息。
