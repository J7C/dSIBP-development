# dSIBP-development

这是 de Sitter 积分计算的开发仓库，包含三个职责不同、可以独立使用、也可以按明确接口衔接的程序包。

## 三个程序包

| 程序包 | 主要输入 | 主要输出 | 核心特征与边界 | 当前入口 |
| --- | --- | --- | --- | --- |
| `dSIBP` | 任意圈数、任意拓扑及 massive/massless 混合的 dS Feynman 图；loop/external momentum 与 ISP 配置 | time/loop IBP 关系、参数微分 seed、sector metadata 和 backend-neutral `linearData`；可导出 Kira 基础输入 | topology-driven Wolfram Language 关系生成器。负责一般拓扑和 loop-momentum IBP，但只生成、检查和序列化关系，不运行 reduction，也不承担数值 DE 输运 | `package-dSibp/versions/018_dSIBP/`；正式单文件 `package-dSibp/independent-benchmark/package/package_018.1.wl` |
| `MadStree` | dS tree 或只积分时间变量的 incidence graph、顶点分支、building blocks、动量和 Hankel convention | contact-reachable sectors、同序主积分、公式型迭代约化、block-triangular dlog DE、自动 Frobenius/sector-leading 边界及数值调用配置 | formula-driven Wolfram Language 包。直接使用张量 building-block 公式，不先生成一般 IBP 方程组；支持 massive/massless 混合、massless quotient 二态与 `RedundantH` 四态。它适合公式已闭合的 tree/time-only 系统，不替代一般 loop-momentum IBP | `package-MadStree/load_current.wl`；当前版本 `package-MadStree/versions/MadStree-v0.3/` |
| `FlintNDE` | 与具体物理模型无关的矩阵微分方程、普通点向量、正则奇点 `{a,b,C}` 或指数型奇点 `{phi,a,b,C}` 边界、路径与精度要求 | 任意精度局部级数、奇点分类、路径规划、主链/参考链 refinement、普通点数值，以及可复用的奇点边界常数和逐点 JSON | 独立 Python/FLINT 数值后端。支持 exact Q(i) rational systems、普通点 Taylor、正则奇点 power-log 和已认证的部分高阶 pole 路线；严格解耦指数型奇点可保存起点/终点/中间点边界，超出代数扩域、ramification 或 Stokes 能力时 fail closed。它不包含 dS 图、主积分或 normalization 知识 | `package-FlintNDE/versions/FlintNDE-v0.1.0.dev0/`；Python import 名 `flintnde` |

## 相互关系

仓库内存在两条不同的工作流：

```text
一般 dS 拓扑
  -> dSIBP
  -> IBP/微分关系与 linearData
  -> Kira 或其它外部 reduction 后端

tree 或 time-only graph
  -> MadStree
  -> 主积分 + 公式约化 + dlog DE + 物理边界
  -> FlintNDE
  -> 用户指定普通点的数值主积分
```

`dSIBP` 当前不调用 MadStree 或 FlintNDE；它解决的是一般拓扑关系生成。MadStree 负责 dS 公式、主积分顺序、normalization、dlog 系统和边界条件，并通过一个集中配置的仓库相对路径自动调用 FlintNDE。FlintNDE 只消费通用矩阵 DE 与边界数据，因此也可以脱离 dS 项目独立使用。

MadStree v0.3 的自动无穷远边界由 sector DAG、component/slot metadata 和用户指定的 strict time rank 通用生成；单顶点显式级数只作为优化。生产路线不回退到有限点定义积分；dlog/chart 未闭合、late-time 指数不衰减、拉回系统非 exact regular singular 或 FlintNDE capability 不足时结构化 fail closed。

MadStree/FlintNDE 的运行文件、保存点和奇点边界常数归调用脚本目录所有，不写入 package 源码目录。开发测试产物放各自 `test/results_test/` 或 `results_temp/`；独立验证只长期保存报告与轻量 `results/summary.wl`。

## 新版本记录与分支

从 2026-07-30 之后新增的 dSIBP、MadStree 和 FlintNDE 版本必须自带更新说明，说明它相对基线版本新增了什么、修复了什么、是否改变接口或 convention、用户如何迁移、已经完成哪些验证以及仍有哪些限制。现有 dSIBP 018.1、MadStree v0.3、FlintNDE `0.1.0.dev0` 及更早资产不追溯补建。

| 组件 | 未来新版本的更新说明路径 |
| --- | --- |
| dSIBP | 新整数代码版本：`package-dSibp/versions/NNN_dSIBP/UPDATE_NOTES.md`；同一代码版本的新正式发布号：`package-dSibp/independent-benchmark/package/package_NNN.x_UPDATE_NOTES.md` |
| MadStree | `package-MadStree/versions/MadStree-vX.Y/UPDATE_NOTES.md` |
| FlintNDE | `package-FlintNDE/versions/FlintNDE-vX.Y.Z/UPDATE_NOTES.md`，目录版本必须与 `pyproject.toml` 一致 |

建议新版本从稳定主线建立独立 Git branch 后开发和验证。branch 不是必须合并：是否创建、保留、关闭或合并均由仓库所有者决定，agent 不会因为版本完成而自行合并到 `main`。

## 先看这里

- 当前任务、真实完成状态和交接顺序：`研究计划与研究进度.md`
- 用户手册：`package-dSibp/Documentation/01_dS_ibp_package/dS_ibp_package.tex`，PDF 同目录
- 独立 benchmark 交付：`package-dSibp/independent-benchmark/independent-benchmark.md`；当前正式程序/手册为 `package_018.1.wl/pdf`
- 三个长期典型 examples：`03_single_massive_sunrise/`、`04_pure_massive_bubble_closed_loop/`、`06_mix_bubble_tree/`；分别覆盖 single-massive sunrise 的 general seeds/参数微分算符、dlog/reference/scaling 闭环和 `kL/kE` 加 cycle/bridge contraction。sunrise example 不撒点、不生成 `linearData`、不运行 Kira/DE/scaling
- 长期总体架构：`package-dSibp/Documentation/dS_IBP_package_plan.md`
- 设计约定：`package-dSibp/Documentation/dS_IBP_package_design_note.md`
- 技术公式：`package-dSibp/Documentation/dS_IBP_package_tech_note.tex`
- 独立直接公式与数值包：`package-MadStree/`；从根目录运行 `Get["package-MadStree/load_current.wl"]` 可加载当前工作版本。版本 README 和 `Documentation/` 说明共同-theta simultaneous contact、time-only 圈图、直接递推/dlog、自动边界证书及 FlintNDE 接口。
- 数值 DE 后端：`package-FlintNDE/README.md`；安装/导入说明见版本 README，算法与能力边界见 `package-FlintNDE/Documentation/FlintNDE.pdf`。
- 给其它 AI 的独立推导任务书：`package-dSibp/independent-benchmark/independent-benchmark.md`

每次收到新任务，先更新 `研究计划与研究进度.md`；不要把逐任务 todolist 写进总体 plan。

维护侧最小功能检查放在 `package-dSibp/check-smoke/` 的明确命名子目录。`package-dSibp/check/` 只供新独立会话按完整任务书从空工作区执行，旧内容不得复用。

## 当前主线

- `package-dSibp/versions/018_dSIBP/`：当前开发主线，标准入口为 `Needs["dSIBP`"]`。
- `package-dSibp/independent-benchmark/package/package_018.1.wl`：当前正式冻结单文件兼容入口。
- `package-dSibp/versions/016_dSIBP/` 与 `017_dSIBP/`：保留的最近两个冻结代码版本。
- 010--015 已从工作树删除，仅保留在 Git 历史中。

018 不自动猜外动量角色。用户必须分别给出 `loopExternalMomenta` 与 `independentExternalMomenta`；符号可以叫 `sah/bob/alice`，名字没有语义。前者是进入 loop scalar-product/ISP/momentum-IBP 的独立外向量基，后者是 topology 中实际出现的无圈动量模长列表。旧字段 `externalMomenta/externalLegMomenta` 只作兼容别名，不参与自动角色推断。

公开 loop 坐标是 `loopExternalMomenta` 的完整 `ssij=Sqrt[sp[p_i,p_j]]` Gram 基；`independentExternalMomenta` 只生成逐项模长 `sE1,sE2,...`，不主动生成彼此点积。任一类别总数达到 10 时按总数位宽补零，例如 `ss0101`、`ss0110`、`sE01`；达到 100 时使用三位。内部 loop 部分继续复用平方 `kk[i,j]` 原子导数，并通过 Jacobian 得到根号变量导数。

结构圈数由无向多重图第一 Betti 数 `L=E-V+C` 给出，自环和平行边均正确计数。`ibpMode->"full"` 要求 `Length[loopMomenta]==L`、routing 满秩且位于 cycle space；`ibpMode->"timeOnly"` 不检查圈动量数量，且所有 line 都使用无 `b/bS` 的 pure-time 固定系数表示。contact sector 继承 root loop space 与 cycle/bridge 分类，不能因 shrink 重新降圈。

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

013 在上述核心上新增：loop `dtau` 到 tree 的完整物理幂次投影、`J[vertexPacks]`、general-index `repIterative0/repIterative`、有序 master list、dlog connection/letters 以及 same-sign contact source；`a0` 保留为 tree `nu0`，被删除的 `b0/bS0` 进入显式能量系数。对应归档报告与附件继续保留，手推/expected/check/result 工作资产已在 2026-07-23 清理。

共同-theta boundary 是当前最高优先级正确性门禁，不是可选优化。完整链路必须同时覆盖 `WT -> shrinkTerms`、simultaneous integer/zero-point shift、coincident canonical、contact-reachable sector、linearData 和 serializer；专项清单见 `package-dSibp/Documentation/2026-07-21_common_theta_correctness_todo.md`，两种等价分布方案的证明见技术笔记附录。

公开 API 示例：

```mathematica
dtau[v, expr, context]  (* context["topology"] 也可 *)
dqq[i, j, expr, context]
dqk[i, j, expr, context]
rep2innerform[expr, context]
rep2outform[expr, context]
rep2Integrand[expr, context]

setIBPTopologyContext[topo];
dtau[v, expr]  (* short form *)
```

014 验收记录：

- 正式单文件程序 SHA-256：`B02ED7C1D7E32189EFDAC86D31FC42D26C005031254FEF04145864F5D0B1B1E6`；21 页正式手册 SHA-256：`AB8881D2F6EC0414AB312C75B7ABC39FF9661FFE086CCD2B4E1A0F74FF3CC36E`。
- 014 的归档验证报告及附件继续保留；手推/expected/check 和生成结果已在 2026-07-23 清理，本节哈希保留为历史版本记录。

pure massive bubble reference 的顶点交换 symmetry 只在等能量约束下成立。package 使用 `P0=+I k0`，reference basis 使用 `P1=P2=-P0=-I k0`；一般独立 `P1/P2` family 不得复用该 symmetry。Kira 可以在 manifest 中保存 `Sqrt[s11]` 等代数系数生成元的可逆后端原子，但 `DSDE` 的公开矩阵和 source 会统一恢复为初始化声明的外部变量，不保留内部 `kk[i,j]`。

## 核心表示

所有 sector 使用同一个 Head：

```mathematica
J[aList, linePacks, ispList]
```

- `full` 模式的 cycle massive full/cross：`{b[e],n[e,1],n[e,2]}`；cycle massless full/cross：`{b[e],n[e]}` / `{b[e]}`；cycle shrunk：`{bS[e]}`
- `full` 模式的 bridge massive full/cross：`{n[e,1],n[e,2]}`；bridge massless full/cross：`{n[e]}` / `{}`；bridge shrunk：`{}`
- `timeOnly` 的所有 line 都按上一条 bridge/fixed-coefficient schema，不因结构 cycle 增加 `b/bS`
- fixed-coefficient line 的 `b0/bS0`、time derivative 和 contact 引入的动量幂全部进入显式模长系数；momentum IBP 只对 cycle-line `xi` 与 ISP 求导
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
- `loopExternalMomenta`：用户显式给出的 loop 外动量独立基；顺序决定 `ssij`
- `independentExternalMomenta`：用户显式给出的实际无圈动量模长列表；顺序决定 `sEe`
- `ibpMode`：`"full"` 或 `"timeOnly"`；树图缺省 `timeOnly`，含圈图缺省 `full`
- `ispData`：补齐 loop scalar-product 空间的 ISP
- `vertexEnergies`：只进入顶点时间相位的外腿打包能量
- `externalInvariantRules`、`zeroPointRules`、`numericRules`、`symmetryRules` 和 seed 范围

用户端标量积统一写 `sp[p,q]`。`sp` 的 `Orderless` 只表示标量积交换性。初始化比较 topology 的必要方向与两个用户列表：恰完备通过；过完备发 warning 后继续，但关闭唯一反变换与 `ds/DSDE`；欠完备返回 `missingDirections/missingMagnitudeSquares` 并拒绝初始化。过完备 loop 声明同时保留用户的 declared list 和用于 `nK`、Gram、`dqk`、ISP 闭合的 `effectiveLoopExternalMomenta`；后者只取 affine quotient 的必要独立方向，不能让可吸收到圈变量平移中的冗余方向虚增标量积空间。`DSKinematics` 同时报告坐标规则状态和动量声明状态，不能把二者混为一个 `complete`。

`vertexEnergies` 是进入顶点时间相位的标量。它可以引用上述根号坐标；与任何已声明动量都无关的独立能量仍可使用 `ke[i]`。015 之前的 `ke[i]` 只是标量参数，不表示动量向量，也不自动定义点积、IBP 生成元或 ISP。

## 微分方程变量求导

016 提供 seed 层与表达式层接口：

```mathematica
makeExternalInvariantDerivativeDecomposition[topo, var]
applyExternalVectorDerivativeSeed[topo, int, gen]
applyExternalInvariantVariableDerivativeSeed[topo, int, var]
applyIndependentVariableDerivativeSeed[topo, int, var]
independentVariableDerivativeVariables[topo]
makeIndependentVariableDerivativeGenerators[topo]
makeIndependentVariableDerivativeSeedBatch[topo, int]
ds[expr, ssij, context]  (* 或 context["topology"] *)
ds[expr, ssij]
```

`applyIndependentVariableDerivativeSeed` 自动分派：

- 若 `var` 是 `sEe`，程序对绑定的无圈线做径向导数，并同时处理显式系数与顶点相位；若它只出现在相位中，就没有线贡献。该路线不生成 loop IBP 方向，也不读取 time-theta 的 `WT/shrinkTerms`。
- 若 `var` 是外不变量，先在外不变量约束坐标上把 `∂/∂var` 解成 `k_i . ∂/∂k_j` 的线性组合，再作用到传播子、building block、ISP 和相关顶点能量表达式。

`makeIndependentVariableDerivativeSeedBatch` 自动枚举全部外不变量坐标和未被其表达的独立顶点能量参数，并逐变量返回 derivative、decomposition、状态、forbidden-`n` 与 canonical 检查。

公开入口 `ds[expr,var]` 使用当前初始化后的外部变量名；三参数形式 `ds[expr,var,context]` 也可直接接收 `DSInit` context 或其 parsed topology。缺省变量为 `ss11`、`ss12`、`sE1` 等。`DSParameterNotation` 显示当前映射；`DSRedefineParameters[context,rules]` 重新初始化并把新规则贯通到 seed、`ds` 与 `DSDE`。正式拼写不是 `redefineParamater`。满秩自定义坐标及从属 line/phase 的 `ds` 按完整 Jacobian 工作。

根号坐标不重写导数核心。若 `xij=sp[ki,kj]=ssij^2`，则 `partial_ssij=2 ssij partial_xij`；程序先调用原有平方不变量原子分解，再乘 Jacobian。一般显式系数仍按 `D F=Sum[(∂F/∂x_a) D x_a]` 使用完整乘积与链式法则，不使用 `PowerExpand`。

massive building block 的动力学量导数与 qIBP、tIBP 自动读取同一份最终 `AT -> derivativeTerms`，因此 h、裸 H 和一般 `P,Q,T,W` 不会出现两套导数 convention。`WT/shrinkTerms` 只用于 time-IBP 的 theta/Wronskian shrink，普通动力学量导数不使用它。

外动量矢量导数分解的完整 `K^2` 算符空间一般有零空间，解不唯一。当前默认使用上三角 canonical basis，并在 decomposition 数据中返回矩阵、系数、残差、`nullity` 与 `nonUniqueQ`。

## 运行示例

```powershell
wolframscript -file 'independent-benchmark\package\examples\06_mix_bubble_tree\main.wl'
```

所有 WolframScript 检查应显式输出结果；不要用 `Quiet` 掩盖消息。
