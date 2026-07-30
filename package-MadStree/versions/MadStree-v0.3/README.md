# MadStree

当前版本：`v0.3`。本目录是版本化源码目录；是否升版只由用户明确指令决定，小改动不会自动新建版本。

`MadStree`` 是一个直接使用 time-integral tensor formula 的 Wolfram Language 程序包。输入可以是有序 dS 树拓扑，也可以是不积分 loop momentum 的纯 time-only incidence graph；输出包括 contact-reachable sectors、同序主积分、逐步或完整迭代约化、block-triangular dlog connection 和自动边界证书。主算法不生成一般 IBP 方程组，也不调用 Kira。

当前缺省 convention 为

```text
time power: (-tau)^A
nu: |nu|
h(nu,0;z): z^nu H_nu(z)
NuConvention: "Positive"
```

只使用函数名 `h`。`NuConvention -> "Negative"` 选择 2401.00129 的负 prefactor convention；两套公式由统一替换 `nu -> -nu` 联系。

`NuConvention` 只在 `MSInitTree` 初始化时选择。context 建立后，公式矩阵、递推、dlog 与全 sector H/h 换基都固定读取该值，不提供逐调用修改 convention 的入口。

## 加载

```wl
packageRoot = ".../package-MadStree/versions/MadStree-v0.3";
AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
Needs["MadStree`"];
```

## 最小流程

```wl
spec = <|
  "vertices" -> {
    <|"id" -> v1, "energy" -> k1, "timePower" -> a1|>,
    <|"id" -> v2, "energy" -> k2, "timePower" -> a2|>
  },
  "lines" -> {
    <|"id" -> e1, "type" -> "masslessFull", "endpoints" -> {v1, v2},
      "momentum" -> q, "skType" -> "++", "nu" -> 1/2,
      "masslessRepresentation" -> "Quotient"|>
  }
|>;

context = MSInitTree[spec];
masters = MSMasterIntegrals[context];
matrices = MSFormulaMatrices[context, "top"];
de = MSDLogDE[context];

targetRules = {k1 -> -9 I, k2 -> -3 I, q -> 1, a1 -> 1, a2 -> 1};
chart = MSBoundaryChartCertificate[context, targetRules];
```

上述 massless 图可直接生成完整多 sector Frobenius 边界并输运到普通点：

```wl
boundary = MSBoundaryData[context, targetRules, RankOrder -> {v1, v2}];
value = MSEvaluateTree[
  context,
  targetRules,
  RankOrder -> {v1, v2},
  WorkingPrecision -> 40,
  TransportOrder -> 80,
  ReferenceTransportOrder -> 104,
  FlintNDESavePoints -> {{0, "save"}, {1/2, "save"}, {1, "save"}}
];
```

`de["masters"]` 是 DE 行列和边界向量顺序的唯一 authority。除单顶点 massive-external family 保留 2411.03088 Eqs. (3.44)--(3.46) 的显式级数优化外，`MSBoundaryData` 对已闭合的 tree/time-only context 统一从 sector DAG、component base powers、slot registry、normalization 和 strict time rank 生成 nested curve，拉回完整 dlog connection，求 residue，并按 ancestor sectors 解每个 master 的 indicial leading vector。`MSEvaluateTree` 把 exact `{a,b,C}` 分支交给 FlintNDE，从正则奇点输运到有限匹配点，再继续到用户目标普通点。生产代码不调用定义积分或 `NIntegrate`；这些只允许作为独立验证 oracle。

通用入口不按图 id、顶点数、master 数或论文数值点分派。只有 dlog 未闭合、rank/chart 未通过 normal-crossing 证书、late-time 指数不衰减、拉回系统不是 exact regular singular，或目标/anchor 落在 DE letter 上时才结构化 fail closed。

`masslessFull` 缺省使用 `"Quotient"`：整条边贡献一个共享二态 slot。若初始化时写 `"masslessRepresentation" -> "RedundantH"`（等价输入别名为 `"functionSystem" -> "h"`），同一条边保留两个 h endpoint 和四个状态；`M1/M0`、contact、递推、`MSReduce`、dlog 及 H/h 变换都直接从这两个 slot 生成。该选择写入 context，之后不能逐调用切换。`RedundantH` 只接受 massless `nu=1/2`；缺省 quotient 的旧 master 顺序与接口保持不变。

每个 sector 由 canonical `contractedLineIds` 生成唯一 `sectorKey`，master 的完整身份是 `MSIntegral[sectorKey,timeShifts,stateBits]`。因此不同 subsector 即使局部 shifts/bits 相同也不是同一积分。`MSInitTree` 的 `sectorIdentityCertificate` 会一次性检查 contraction set、sector key、完整 master、global index 和按完整 master 顺序计算的 SHA-256 digest；碰撞时拒绝初始化。massless top-to-sub dlog 的 contact 原子按 event 中实际 selected massless line 数乘 `(-1)^N`，simultaneous contact 不使用图专用符号表。

`MSBoundaryChartCertificate[context,targetRules]` 在边界计算前构造
`1/K[sigma[j]]=Product[x[r],{r,j,V}]` 的 nested blow-up，逐 sector 固化所有 theta，并检查完整 dlog letters、normalization、坐标 Jacobian 与 shifted-contact 新分母都是 coordinate monomial 乘边界非零 unit。`RankOrder -> All` 检查全部 root-time strict charts；证书不通过时 `MSBoundaryData` 返回 `BoundaryChartNotCertified`。

## 共同 theta 与 time-only 圈图

同一当前 component pair 上的 full lines 自动组成共同-theta bundle。程序只生成非空奇数子集 event，系数为 `2^(1-Length[selected])`；一个 event 同时删除所选边并只合并一次顶点。sector 由 event BFS 生成，不是 full-line 幂集。合并后未选的 massless full line 只保留 even state，massive full line使用 `10 -> 01` equal-time canonical；raw tensor matrix 通过保存的 projection/embedding 投到真实 master space。

纯 time-only 圈图使用专用入口：

```wl
cycleContext = MSInitTimeGraph[<|
  "vertices" -> {...},
  "lines" -> {...}
|>];
```

它只允许固定 line momenta 的时间积分，不读取或生成 loop momenta、ISP、Landau/threshold 数据。active self-edge 不再触发 contact；多条路径到同一 vertex partition/contracted set 被 canonical 成一个 sector。

## 单顶点函数族

单顶点 family 不需要伪造 topology。紧凑输入沿用参考代码的 `ki/nui` 习惯：

```wl
vertexContext = MSInitVertexFamily[<|
  "ki" -> {k0, k1, k2},
  "nui" -> {a0, nu1, nu2},
  "hankelBranches" -> {1, 2}
|>];

vertexDE = MSDLogDE[vertexContext];
vertexValue = MSEvaluateVertexFamily[vertexContext, targetRules];
```

这里 `First[ki]` 是纯顶点指数能量，`First[nui]` 是 `(-tau)` 的基准幂；其余位置一一给出 h block 的动量和 `nu=|nu|`。也可显式给 `k0`、`timePower`、`hBlocks` 和 `exponentialBlocks`。纯指数 block 是 `1x1`，不增加状态位；每个 h block 是 `2x2`。初始化时选定的 `NuConvention` 此后固定，不能在递推、DE、数值计算或 H/h 变换时另行覆盖。

## 直接约化

```wl
reduction = MSReduce[
  2 MSIntegral["top", {1}, {0, 0}] -
  3 MSIntegral["top", {-1}, {1, 0}],
  vertexContext,
  MasterBasis -> Automatic
];
```

`MSReduce` 只处理固定初始化 context 内的合法 `MSIntegral[sectorKey,timeShifts,stateBits]`：`sectorKey` 必须属于 contact-reachable sector DAG，`timeShifts` 是该 sector 每个 component 的整数平移，`stateBits` 按 2401 的二进制顺序遍历该 sector 全部二维 slots。它可线性处理有限多个这样的对象，但不支持新增传播子幂、新离散指标、context 外 sector 或另一个函数族。约化沿 shift/contact DAG 递归到零 shift masters，并缓存重复子问题。返回的 `masterBasis`、`coefficientVector` 和 `masterRules` 严格同序；`result` 是显式主积分线性组合；`nonMasterResidual` 与 `remainingShiftedIntegrals` 必须同时为空才是完全约化。`MasterBasis` 可给 context 全部 masters 的任意排列，但缺项、重复或额外对象都会拒绝。`singularLayers` 逐步保存方向、分量和分母：正 shift 向零的 raising 只报告 `M0` energy letters，负 shift 向零的 lowering 只报告 `M1` 本征值。

若 top-to-sub 的 `R^(1)` 落在 child 非零 shift，`MSDLogDE` 会逐列调用同一公式递推，生成 shifted child 到全局同序 masters 的 reduction matrix，再右复合 contact block。每个 contact block 保存 `shiftReductionRecords`、residual、remaining shifts 和 singular layers；任何一列未闭合时 dlog 状态为 `contactShiftReductionFailed`，不会输出伪闭合 connection。

公式层不构造一般大矩阵逆。massive endpoint 与 `RedundantH` massless endpoint 的固定 `sigma2` 用论文的 `2x2` 变换及其显式逆，massless shared slot 的固定 `sigma1` 用自逆 Hadamard；全 sector 只作这些局部矩阵的 Kronecker 积。`M1` 在 state-bit basis 逐对角元取倒数，`M0` 在共同对角 basis 逐 energy letter 取倒数。若未来同一个 slot 出现不能共同对角化的 Pauli 方向，这条快速路径必须 fail closed。

H/Hankel state 与 h state 的公开变换为 `MSHTohMatrix`、`MShToHMatrix` 和 `MSConvertBasis`。局部与全 sector 状态向量都读取 context 中固定的 `NuConvention`；已经积分后的 `MSIntegral` 会同时牵涉基准时间幂，当前不能唯一恢复时明确拒绝。

FlintNDE 缺省位置只在一个相对路径变量中定义：

```wl
MSFlintNDEConfiguration[]
(* relativePath -> package-FlintNDE/versions/FlintNDE-v0.1.0.dev0 *)

MSSetFlintNDERelativePath[FileNameJoin[{"new-name", "code", "package"}]]
```

路径始终相对项目根目录；FlintNDE 当前版本目录此后改名或移动时只改这一项。`MSNumericalSystem` 保留为用户自行提供边界向量时的低层入口。

MMA 自动调用产生的临时 JSON 与可复用 Python cache 缺省写入调用脚本目录：

```text
results_temp/flintnde_transport/
results_temp/python_cache/MadStree-v0.3/
```

可用 `MSRuntimeDirectory -> path` 显式指定其它调用者目录：绝对路径直接使用，相对路径相对当前调用脚本目录解析，不依赖进程工作目录。成功后临时 JSON 自动删除；失败时保留输入、输出路径供诊断。Python cache 与具体图或参数输入无关，可在同一 Python 版本和源码状态下复用。程序包源码目录不接收运行产物。

`FlintNDESavePoints` 只接受 `{{coordinate,"save"},...}`，或按阶段给出 `<|"singular"->{{...}},"ordinary"->{{...}}|>`；不允许第三个名称字段。后端每到一个标记点就先写独立 JSON，最后才汇总到

```text
results/flintnde_save_points/run-UUID/madstree_flintnde_save_points.json
```

普通点记录保存坐标和完整结果向量；正则奇点起点保存可复用的 Frobenius `{a,b,C}`，不伪造奇点处函数值。若同一 DE 的内部保存坐标是 FlintNDE 已认证、可桥接的指数型奇点，Python 后端会原样汇入其 `{phi,a,b,C}` / `exponential_boundary` 记录；start-only formal 或需要 Stokes 数据的中间点仍在建路阶段拒绝。后续路径失败时已完成的逐点文件保留，但不写完整汇总。

完整公式、massless `4 -> 2` quotient、contact shift 与 top-to-sub dlog 推导见 [Documentation/tree_formula.pdf](Documentation/tree_formula.pdf)。可直接运行的最小脚本见 [Examples/01_massless_full_edge.wl](Examples/01_massless_full_edge.wl)。

## 当前边界

- 已支持共同-theta odd-subset simultaneous contact、coincident massless/massive quotient、event-reachable sector BFS 与纯 time-only 圈图；这不等于支持 loop-momentum integration。
- H/h 局部二态与全 sector 状态向量可逆；已经积分后的 `MSIntegral` 换基涉及 family 基准时间幂变化，当前不伪装成普通状态变换。
- 生产边界不按图名或 master 数分派。单顶点 massive-external family 保留 2411 显式级数优化；其它已闭合 tree/time-only context 统一由 sector DAG、component/slot metadata、normalization 和 strict time rank 生成 nested curve、完整 dlog pullback residue 与 ancestor-sector leading system。公式/dlog/chart 未闭合、late-time 指数不衰减或拉回系统不是 exact regular singular 时结构化 fail closed，不回退到有限点定义积分。
- FlintNDE 输运要求拉回 connection 属于 exact `Q(i)(s)` 或 `Q(i)(t)`。T1 mixed 三顶点的独立 `15 x 15`/`25 x 25` 边界和输运已通过 `24/24`；T2 单顶点三 massive 通过 `12/12`；T3 两顶点 `G++` 的 paper/package basis map、五个边界分支和完整目标向量通过 `18/18`。pure massless 与 triangle time-only 开发检查也使用同一个通用 boundary producer。
- FlintNDE 已实现 exact Lee--Moser projector balances、严格解耦指数乘 power-log，以及单重互异主导根二阶 pole 的 start-only 形式渐近。`build_adaptive_path_plan` 会先给 `continuation_ready`；严格解耦指数奇点可按 `{phi,a,b,C}` 保存起点、终点和中间 bridge，formal 分支只可保存起点；未认证 high-pole、需要 ramification/代数扩域/general Stokes connection 的内部点或终点必须拒绝。Wolfram 保存点使用 `{coordinate,"save"}`；后续失败保留已完成逐点文件但不写完整汇总。

v0.3 独立验证 T1--T6 fresh 计数为 `24/24, 12/12, 18/18, 15/15, 17/17, 16/16`。开发回归为 MadStree `128/128`、FlintNDE `76/76`；两类证据分开记录。T6 明确验证正则奇点保存结果为可复用 `{a,b,C}`，批量无保存点优化不会删除逐分支保存能力；指数型保存由 FlintNDE 自身的起点、终点、中间点往返测试覆盖。
