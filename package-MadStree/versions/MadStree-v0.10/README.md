# MadStree

English version: [README_en.md](README_en.md)。

当前版本：`v0.10`。本目录是在 v0.9 基础上修改建立（版本沿革 v0.5 -> v0.6 -> v0.7 -> v0.8 -> v0.9 -> v0.10）；接口变化见 `UPDATE_NOTES.md`。

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
packageRoot = ".../package-MadStree/versions/MadStree-v0.10";
AppendTo[$Path, packageRoot];
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
topKey = First[context["sectorOrder"]];
matrices = MSFormulaMatrices[context, topKey];
de = MSDLogDE[context];

formulaData = MSFormulaData[context];
written = MSWriteFormulaArtifacts[
  context,
  TimePowerRules -> Automatic
];
written["outputDirectory"]

targetRules = {k1 -> -9 I, k2 -> -3 I, q -> 1, a1 -> 1, a2 -> 1};
chart = MSBoundaryChartCertificate[context, targetRules];
```

上述 massless 图可直接生成完整多 sector Frobenius 边界，并按同一个两阶段接口输运到一个或多个用户点：

```wl
path = MSGeneratePath[
  context,
  {targetRules},
  BoundaryScale -> 4,
  RankOrder -> {v1, v2},
  WorkingPrecision -> 40,
  MessageLanguage -> "EN"
];

result = MSEvaluatePlannedPath[
  context,
  path,
  PythonExecutable -> "...",
  WorkingPrecision -> 40,
  TransportOrder -> 80,
  ReferenceTransportOrder -> 104,
  TargetRelativeError -> "1e-20",
  MessageLanguage -> "EN"
];
```

多点折线只需把第二个参数改为 `{pointP1, pointP2, pointP3}`。`MSGeneratePath` 只规划并返回完整路径；`MSEvaluatePlannedPath` 只执行该计划，执行阶段不会重新规划。`MSPlannedPathQ` 用于判断对象是否为有效计划。

用户点序列中裸坐标缺省保存；`{coord, "tmp"}` 标记不进入最终保存结果的途经点；`{coord, "lo"}` 请求沿到达方向反解的奇点领头阶记录。其它字符串标签一律拒绝。点结果成对携带 `coordinate`、`value`、`status` 和 `userIndex`；落在奇异超平面上的用户点会被剔除，并在 `"removedPoints"` 与 `"reconnections"` 中报告用户序号和重连方式。

任何经过中途节点的多点输运都称为“折跃”；只有显式穿过奇点并用局部基连接两侧匹配点时才称为“奇点折跃”。`SingularityMode -> "Avoid"` 是缺省模式：相邻用户点连线命中奇点时返回 `"Singular Path Pair"` 与问题点对。只有显式选择 `SingularityMode -> "SingularityJump"` 才允许奇点折跃；程序会建立入射/出射匹配并前瞻后续用户点。奇点折跃选择的多值分支等价于某条绕行路径，用户必须自行确认。`MessageLanguage -> "EN"|"CN"` 严格区分大小写，缺省英文。

计划保存 `WorkingPrecision` 和完整后端 `serializedPlan`。内部 bit 数为 `ceil(WorkingPrecision*log2(10))+32`，例如 70、100 位分别使用 265、365 bit，更高精度继续按同一公式增长；线段投影、匹配比例、旋转因子和 winding/monodromy 均使用当前 Arb 精度。若执行精度高于规划精度，程序拒绝并要求按目标精度重新运行 `MSGeneratePath`，因为低精度序列化节点不能补回信息。
每一仿射段都在 MadStree 侧拉回为单变量连接。若该段所有 dlog letters 都是常量，则其导数全部为零，后端构造无有限极点的零连接并正常输运；“没有极点”不是拒绝该段的理由。

`de["masters"]` 是 DE 行列和边界向量顺序的唯一 authority。`MSBoundaryData` 对已闭合的 tree/time-only context 统一从 sector DAG、component base powers、slot registry、normalization 和 strict time rank 生成 nested curve，拉回完整 dlog connection，求 residue，并按 ancestor sectors 解每个 master 的 indicial leading vector；单顶点 massiveExternal 也走同一通用路线（2411.03088 Sec.3.3 显式级数仅保留为测试对照基准，不进生产路径）。`MSGeneratePath` 保存 exact `{a,b,C}` 分支对应的奇点边界计划；`MSEvaluatePlannedPath` 直接执行该计划，从正则奇点输运到有限匹配点，再继续到用户目标普通点。生产代码不调用定义积分或 `NIntegrate`；这些只允许作为独立验证 oracle。

通用入口不按图 id、顶点数、master 数或论文数值点分派。只有 dlog 未闭合、rank/chart 未通过 normal-crossing 证书、late-time 指数不衰减、拉回系统不是 exact regular singular，或目标/anchor 落在 DE letter 上时才结构化 fail closed。

`masslessFull` 缺省使用 `"Quotient"`：整条边贡献一个共享二态 slot。初始化时写 `"masslessRepresentation" -> "RedundantH"`，同一条边保留两个 h endpoint 和四个状态；`M1/M0`、contact、递推、`MSReduce`、dlog 及 H/h 变换都直接从这两个 slot 生成。该选择写入 context，之后不能逐调用切换。`RedundantH` 只接受 massless `nu=1/2`。

每个 sector 的 `sectorKey` 是按初始化时 root `lines` 顺序排列的定长字符串：`0` 表示对应传播子已收缩，`1` 表示未收缩；不能 contact shrink 的 line 位始终为 `1`。top 是全 `1` 字符串。前导零是身份的一部分，禁止把 key 当整数。`context["sectorKeySchema"]` 给出 `rootLineOrder`、位宽和位语义；例如 `{e1,e2,e3,e4}` 中收缩 `{e1,e2,e4}` 得到 `"0010"`。master 的完整身份是 `MSIntegral[sectorKey,timeShifts,stateBits]`，所以不同 subsector 即使局部 shifts/bits 相同也不是同一积分。`MSInitTree` 的 `sectorIdentityCertificate` 会一次性检查 contraction set、sector key、完整 master、global index 和按完整 master 顺序计算的 SHA-256 digest；碰撞时拒绝初始化。massless top-to-sub dlog 的 contact 原子按 event 中实际 selected massless line 数乘 `(-1)^N`，simultaneous contact 不使用图专用符号表。

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
vertexPath = MSGeneratePath[vertexContext, {targetRules}];
vertexValue = MSEvaluatePlannedPath[vertexContext, vertexPath];
```

这里 `First[ki]` 是纯顶点指数能量，`First[nui]` 是 `(-tau)` 的基准幂；其余位置一一给出 h block 的动量和 `nu=|nu|`。也可显式给 `energy`、`timePower`、`hBlocks` 和 `exponentialBlocks`。纯指数 block 是 `1x1`，不增加状态位；每个 h block 是 `2x2`。初始化时选定的 `NuConvention` 此后固定，不能在递推、DE、数值计算或 H/h 变换时另行覆盖。

## 直接约化

```wl
reduction = MSReduce[
  2 MSIntegral[First[vertexContext["sectorOrder"]], {1}, {0, 0}] -
  3 MSIntegral[First[vertexContext["sectorOrder"]], {-1}, {1, 0}],
  vertexContext,
  MasterBasis -> Automatic
];
```

`MSReduce` 只处理固定初始化 context 内的合法 `MSIntegral[sectorKey,timeShifts,stateBits]`：`sectorKey` 必须属于 contact-reachable sector DAG，`timeShifts` 是该 sector 每个 component 的整数平移，`stateBits` 按 2401 的二进制顺序遍历该 sector 全部二维 slots。它可线性处理有限多个这样的对象，但不支持新增传播子幂、新离散指标、context 外 sector 或另一个函数族。约化沿 shift/contact DAG 递归到零 shift masters，并缓存重复子问题。返回的 `masterBasis`、`coefficientVector` 和 `masterRules` 严格同序；`result` 是显式主积分线性组合；`nonMasterResidual` 与 `remainingShiftedIntegrals` 必须同时为空才是完全约化。`MasterBasis` 可给 context 全部 masters 的任意排列，但缺项、重复或额外对象都会拒绝。`singularLayers` 逐步保存方向、分量和分母：正 shift 向零的 raising 只报告 `M0` energy letters，负 shift 向零的 lowering 只报告 `M1` 本征值。

若 top-to-sub 的 `R^(1)` 落在 child 非零 shift，`MSDLogDE` 会逐列调用同一公式递推，生成 shifted child 到全局同序 masters 的 reduction matrix，再右复合 contact block。每个 contact block 保存 `shiftReductionRecords`、residual、remaining shifts 和 singular layers；任何一列未闭合时 dlog 状态为 `contactShiftReductionFailed`，不会输出伪闭合 connection。

公式层不构造一般大矩阵逆。massive endpoint 与 `RedundantH` massless endpoint 的固定 `sigma2` 用论文的 `2x2` 变换及其显式逆，massless shared slot 的固定 `sigma1` 用自逆 Hadamard；全 sector 只作这些局部矩阵的 Kronecker 积。`M1` 在 state-bit basis 逐对角元取倒数，`M0` 在共同对角 basis 逐 energy letter 取倒数。若未来同一个 slot 出现不能共同对角化的 Pauli 方向，这条快速路径必须 fail closed。

H/Hankel state 与 h state 的公开变换为 `MSHTohMatrix`、`MShToHMatrix` 和 `MSConvertBasis`。局部与全 sector 状态向量都读取 context 中固定的 `NuConvention`；已经积分后的 `MSIntegral` 会同时牵涉基准时间幂，当前不能唯一恢复时明确拒绝。

FlintNDE 数值后端（FlintNDE 0.3.0 同版本同步副本：折线链式输运、奇点折跃、局部 Frobenius 基、缺省避开奇点模式；独立 FlintNDE 包本体为通用一阶矩阵微分方程求解器）随 v0.10 放在版本目录内，缺省位置只在一个相对路径变量中定义：

```wl
MSFlintNDEConfiguration[]
(* relativePath -> Vendor/FlintNDE *)

MSSetFlintNDERelativePath[FileNameJoin[{"new-name", "code", "package"}]]
```

路径始终相对当前 MadStree 版本目录；Vendor 此后改名或移动时只改这一项。`MSNumericalSystem` 保留为用户自行提供边界向量时的低层入口。

MMA 自动调用产生的临时 JSON 缺省写入调用脚本目录：

```text
results_temp/flintnde_transport/
```

可用 `MSRuntimeDirectory -> path` 显式指定其它调用者目录：绝对路径直接使用，相对路径相对当前调用脚本目录解析，不依赖进程工作目录。成功后临时 JSON 自动删除；失败时保留输入、输出路径供诊断。成功结果缓存键同时包含请求内容以及 `Backend/flintnde_transport.py`、Vendor `pyproject.toml` 和排序后的 `flintnde/*.py` 的 SHA-256，因此当前版本原位修复后不会误复用与源码身份不匹配的计划。Python 按缺省规则在相应 package 旁建立 `__pycache__/`，该目录及 `*.pyc` 已由 Git 忽略，可在同一 Python 版本和源码状态下复用。除这些调用侧缓存外，程序包源码目录不接收运行产物。

裸用户点的普通点结果保存在 `MSEvaluatePlannedPath` 返回值的 `"saved"` 记录中；`"tmp"` 点只参与路径，`"lo"` 点只返回方向相关的奇点领头阶。可用

```wl
MSExportEvaluationData[result, MSOutputDirectory -> outputDirectory]
```

把已保存普通点导出为 CSV/JSON。奇点领头阶、被移除奇点和临时点不进入普通点导出。运行时 JSON、日志和后端 cache 位于调用脚本目录的 `results_temp/`，正式导出位于调用方指定的 `results/`；程序包源码目录不接收运行产物。
完整公式、massless `4 -> 2` quotient、contact shift 与 top-to-sub dlog 推导见 [Documentation/tree_formula.pdf](Documentation/tree_formula.pdf)。

## Examples

- [01_massless_full_edge.wl](Examples/01_massless_full_edge.wl)：massless quotient、主积分、递推、dlog 和自动边界/数值入口（含用户自定义有限边界与批量多点求值、CSV/JSON 导出）。
- [02_vertex_family_reduction.wl](Examples/02_vertex_family_reduction.wl)：单顶点专用输入、局部张量逆和有限线性组合约化。
- [03_time_only_cycle_chart.wl](Examples/03_time_only_cycle_chart.wl)：time-only 圈图、共同 theta、contact sector 与全部 strict-rank chart。
- [04_three_vertex_tree.wl](Examples/04_three_vertex_tree.wl)：三顶点 massless 树图（+++ 顶点结构），后接批量多点求值与 CSV/JSON 导出。
- [05_massive_three_vertex_tree.wl](Examples/05_massive_three_vertex_tree.wl)：三顶点 massive 树图（+++ 顶点结构、非半整数 nu），后接批量多点求值与 CSV/JSON 导出。

五个 examples 由 v0.9 沿用（其中 01--03 源于 v0.5）；v0.9 验证时全部 fresh 运行 `Example PASSED`、退出 `0`；v0.10 的回归口径以开发测试套件与 `UPDATE_NOTES.md` 的验证记录为准。

## 当前边界

- 已支持共同-theta odd-subset simultaneous contact、coincident massless/massive quotient、event-reachable sector BFS 与纯 time-only 圈图；这不等于支持 loop-momentum integration。
- H/h 局部二态与全 sector 状态向量可逆；已经积分后的 `MSIntegral` 换基涉及 family 基准时间幂变化，当前不伪装成普通状态变换。
- 生产边界不按图名或 master 数分派。单顶点 massiveExternal 也走同一通用路线（2411.03088 Sec.3.3 显式级数仅保留为测试对照基准）；已闭合的 tree/time-only context 统一由 sector DAG、component/slot metadata、normalization 和 strict time rank 生成 nested curve、完整 dlog pullback residue 与 ancestor-sector leading system。公式/dlog/chart 未闭合、late-time 指数不衰减或拉回系统不是 exact regular singular 时结构化 fail closed；有限点定义积分只用于独立验证。
- FlintNDE 输运要求拉回 connection 属于 exact `Q(i)(s)` 或 `Q(i)(t)`。T1 mixed 三顶点的独立 `15 x 15`/`25 x 25` 边界和输运已通过 `24/24`；T2 单顶点三 massive 通过 `12/12`；T3 两顶点 `G++` 的 paper/package basis map、五个边界分支和完整目标向量通过 `18/18`。pure massless 与 triangle time-only 开发检查也使用同一个通用 boundary producer。
- FlintNDE 已实现 exact Lee--Moser projector balances、严格解耦指数乘 power-log，以及单重互异主导根二阶 pole 的 start-only 形式渐近。v0.3.0 的两阶段后端分别规划和执行普通折线、方向相关领头阶与奇点边界；奇点节点化会合并同点消失的多个 letter 留数，并按局部 Frobenius 基执行奇点折跃。无法构造局部基的共振返回结构化拒绝。`build_adaptive_path_plan` 先给出 `continuation_ready`；未认证 high-pole、需要 ramification、代数扩域或一般 Stokes connection 的内部点与终点必须 fail closed。

v0.10 在 v0.9 基础上修改建立（v0.9 与远端 tag `MadStree-v0.9` 对应，已冻结）；v0.5 的全部 11 个开发 tests、三个 examples 与跨包 DE 检验均串行 fresh 通过（历史证据），T1--T6 独立验证计数依次为 `24/24`、`12/12`、`18/18`、`15/15`、`17/17`、`16/16`（报告和机器 summary 位于 `../../independent-validation/MadStree-v0.5-validation-*/`）；v0.10 自身的 fresh 回归证据（路径专项 53/53、Python adapter 10/10、12 个 Wolfram 开发测试文件 221/221、Examples 01--05 为 5/5、单顶点对照 8/8 与 10/10）见 `UPDATE_NOTES.md`。
