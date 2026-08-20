# MadStree

English version: [README_en.md](README_en.md)。

当前版本：`v0.13`。本目录从 v0.12 升级；接口变化见 `UPDATE_NOTES.md`。

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
packageRoot = ".../package-MadStree/versions/MadStree-v0.13";
AppendTo[$Path, packageRoot];
Needs["MadStree`"];
```

首次成功加载会显示一次引用提醒。在 Notebook 中 arXiv 号为可点击链接；headless kernel
保留完整 URL。MadStree 只列出 [arXiv:2401.00129](https://arxiv.org/abs/2401.00129)、
[arXiv:2411.03088](https://arxiv.org/abs/2411.03088) 和 MadStree package paper
（arXiv identifier pending）。

## 最小流程

```wl
spec = <|
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> k1, "timePower" -> a1, "vertexType" -> "+"|>,
    <|"id" -> 2, "externalLegEnergy" -> k2, "timePower" -> a2, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massless", "endpoints" -> {1, 2},
      "momentum" -> q, "nu" -> 1/2,
      "masslessRepresentation" -> "Quotient"|>
  }
|>;

context = MSInitTree[spec];
masters = MSMasterIntegrals[context];
masterDefinitions = KeyTake[#, {"integral", "normalization", "bareIntegral", "definition"}] & /@ masters;
topKey = First[context["sectorOrder"]];
matrices = MSFormulaMatrices[context, topKey];
de = MSDLogDE[context];

formulaData = MSFormulaData[context];
written = MSWriteFormulaArtifacts[
  context,
  TimePowerRules -> Automatic
];
written["outputDirectory"]

targetRules = {k1 -> 9 I, k2 -> 3 I, q -> 1, a1 -> 1, a2 -> 1};
chart = MSBoundaryChartCertificate[context, targetRules];
```

`MSIntegral[sectorKey,timeShifts,stateBits]` 表示 normalized master
$J_s(\mathbf n;\mathbf a)$；同一组三项也唯一标识裸积分 $I_s(\mathbf n;\mathbf a)$。
`MSMasterIntegrals` 直接给出每个 master 的精确 `normalization` 和
`J_s=normalization I_s`；单个 shifted integral 可用
`MSIntegralDefinition[MSIntegral[sectorKey,timeShifts,stateBits],context]` 查询。
二态因子是 massive endpoint、`masslessEndpointH` 或整条 massless Full 边共享的 quotient
二态；其逐位顺序由 `MSSlotRegistry` 给出。`++/--` 的 h 组合只在手册统一定义，不在每条输出中展开。

`"vertexType" -> "+"|"-"` 是顶点的 Schwinger--Keldysh 轮廓支，必须在每个顶点上
显式给出。传播子不再输入 `skType`、`sigma` 或端点符号；程序从 `"endpoints"` 指向的
顶点自动推导 Full/Cross/External、`++/--/+-/-+`、整体符号和缺省 Hankel branches。
公开传播子 `"type"` 只接受 `"massive"` 或 `"massless"`。传播子不输入 ID；程序始终按
`"lines"` 输入顺序在内部编号。只有显式 `thetaBundles` 需要引用传播子时，才使用这一位置编号。

`"externalLegEnergy"` 不是“顶点自身具有的能量”，而是附着在该顶点的外腿无 theta
指数参数。`vertexType="+"` 唯一给出 `Exp[-I externalLegEnergy tau]`，`"-"` 唯一给出
`Exp[+I externalLegEnergy tau]`。SK contour sign 也由同一 `vertexType` 派生，但在内部与
外腿指数符号分字段保存，传播子 contact map 不读取第二套用户符号。对 `+` 支的正阻尼坐标
`K>0`，应取 `externalLegEnergy=+I K`；对 `-` 支则取 `-I K`。

上述 massless 图可直接生成完整多 sector Frobenius 边界，并通过单阶段入口输运到一个或多个用户点：

```wl
result = MSEvaluatePath[
  context,
  {targetRules},
  FlintNDEPathPlanning -> True,
  BoundaryScale -> 4,
  RankOrder -> {1, 2},
  PythonExecutable -> "...",
  WorkingPrecision -> 200,
  TransportOrder -> 80,
  ReferenceTransportOrder -> 104,
  TargetRelativeError -> "1e-20",
  MessageLanguage -> "EN"
];
```

多点只需把第二个参数改为 `{pointP1, pointP2, pointP3}`。MadStree 按输入顺序划分最大连续复仿射单变量段 `x(s)=x0+s v`，每段只拉回一次并把全部 exact 复参数点交给 FlintNDE；MadStree 不规划节点或绕行。裸坐标缺省返回，`{coord,"tmp"}` 是不进入最终保存结果的途经点；其它字符串标签一律拒绝。点结果携带 `coordinate`、`value`、`status` 和 `userIndex`。

`TransportOrder -> 80` 是生产阶数，返回的节点值、dense 用户点、段末值及后续正规化拟合均取
低阶 primary chain。`ReferenceTransportOrder -> 104` 只运行高阶 reference chain，并用两链
差值检查 `TargetRelativeError`。跨多个复仿射段时两条链分别续传自己的末点，高阶值不会替换
用户结果，也不会在下一段成为主链初值。

共同解析 regulator `ep` 的 Laurent 极限使用：

```wl
epSeries = MSReconstructEpSeries[
  context,
  ep,
  {{k1 -> 9 I, k2 -> 3 I, k3 -> 5 I, q12 -> 1, q23 -> 2,
    a1 -> 1 + ep, a2 -> 1 + ep, a3 -> 1 + ep}},
  MaximumEpPower -> 0,
  EpGoalDigits -> 20,
  ParallelTaskCount -> 12
];
```

`MaximumEpPower` 是用户需要返回的最高 `ep` 幂；缺省 `0` 表示需要 pole（若存在）及有限项。
缺省时用户不提供任何 `ep` 取值。任何数值 NDE 启动前，程序先从实际符号边界条件与 dlog DE
认证最低整数幂：检查 `ep=0` 处 DE 无负 Laurent 阶、定义积分边界解析且物理分支合并后
存在可证明非零的最低系数；正规化参数进入未认证路径坐标或结构无法证明时 fail closed。
随后按最低幂、最高幂和 `EpGoalDigits` 自动决定生产点、`ep` 尺度、工作精度、输运阶数及
不参与拟合的独立验证点。内部拟合缺省比用户最高阶多两阶；验证失败时每轮再增加两阶，
只计算新增生产点，既有生产点和验证点分别缓存复用。最多三轮仍不满足原误差门槛时返回
当前最佳系数，并用 `status -> "computed_with_warning"`、`precisionTargetMet -> False` 和
结构化原因明确撤销精度认证。
自动工作精度取 200 位与自适应估计的较大者。
`ParallelTaskCount` 缺省为 12，控制每批独立 `ep` 后端进程；超出部分自动续交。它不同于
python-flint 单进程内的 `ctx.threads`。

若需把所有取值限制在用户认可范围，可显式给出 `EpSamplePoints -> {...}` 与
`EpValidationPoints -> {...}`。前者是有序生产候选池，可以多于首轮所需点数；设置
`EpInitialInternalMaximumPower -> q` 后，首轮只取拟合到 `ep^q` 所需的前缀，验证失败才从
剩余候选中增量取点并复用旧值。验证点从不参与拟合且必须与整个生产候选池分离；候选耗尽
不会自动越出用户范围，结果原因是 `candidate_pool_exhausted`。

另一种自动入口是 `EpSampleAngleRange -> {thetaMin,thetaMax}`，单位为弧度并按开区间解释，
不能与显式 `EpSamplePoints` 同时使用。程序在内部均匀选择最多三条射线，不取边界；模长仍由
pole 深度、`EpGoalDigits` 和拟合阶数自动决定，没有模长上限选项。自动验证点保持角度并缩小
模长。为满足 MadStree exact dlog 拉回合同，adapter 把高精度生成的复点转为 exact
Gaussian-rational 后再求值。上述选项缺省均为 `Automatic`，因此缺省调用及后端输入 schema
不变。

`FlintNDEPathPlanning -> True` 让 FlintNDE 在每段内部规划节点。落在同一节点收敛圆盘内的用户点组成一个 evaluation bucket，并用该节点保存的向量级数做快速多点求值；点数不少于 8 的桶使用子积树/余数树，小桶使用 iterative 算法。`False` 则严格把用户点依次作为节点，不插点、不删点、不调用规划器。不同复仿射段不共享局部系数，因此没有多变量高维 Taylor 球。若一段全部 dlog letters 为常量，拉回连接为零并正常输运。

`SingularityMode -> "Avoid"` 是缺省；用户折线命中奇点时明确拒绝。只有在开启 FlintNDE 规划时才能显式选择 `"SingularityJump"`；其多值分支等价于某条绕行路径，用户必须确认。`MessageLanguage -> "EN"|"CN"` 严格区分大小写，缺省英文。`MSBoundaryData` 与 `MSEvaluatePath` 的 `WorkingPrecision` 缺省为 200 位；显式给值时直接覆盖。内部 bit 数为 `ceil(WorkingPrecision*log2(10))+32`。

`de["masters"]` 是 DE 行列和边界向量顺序的唯一 authority。`MSBoundaryData` 对已闭合的 tree/time-only context 统一生成 nested curve、拉回完整 dlog connection、求 residue，并按 ancestor sectors 解每个 master 的 indicial leading vector。`MSEvaluatePath` 把 exact `{a,b,C}` 分支、全部复仿射段和用户选项放入同一 UTF-8 请求；FlintNDE 在同一进程内完成边界初始化和后续有限段输运。生产代码不调用定义积分或 `NIntegrate`；这些只允许作为独立验证 oracle。

通用入口不按图 id、顶点数、master 数或论文数值点分派。只有 dlog 未闭合、rank/chart 未通过 normal-crossing 证书、late-time 指数不衰减、拉回系统不是 exact regular singular，或目标/anchor 落在 DE letter 上时才结构化 fail closed。

端点同属一个轮廓支时，公开 `"massless"` 线在内部派生为 `masslessFull`，缺省使用
`"Quotient"`：整条边贡献一个共享二态 slot。初始化时写
`"masslessRepresentation" -> "RedundantH"`，同一条边保留两个 h endpoint 和四个状态；
`M1/M0`、contact、递推、`MSReduce`、dlog 及 H/h 变换都直接从这些 slots 生成。该选择写入
context，之后不能逐调用切换。`RedundantH` 只接受 massless `nu=1/2`。

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
vertexValue = MSEvaluatePath[vertexContext, {targetRules}];
```

这里 `First[ki]` 是纯顶点指数能量，`First[nui]` 是 `(-tau)` 的基准幂；其余位置一一给出 h block 的动量和 `nu=|nu|`。也可显式给 `externalLegEnergy`、`timePower`、`hBlocks` 和 `exponentialBlocks`。纯指数 block 是 `1x1`，不增加状态位；每个 h block 是 `2x2`。初始化时选定的 `NuConvention` 此后固定，不能在递推、DE、数值计算或 H/h 变换时另行覆盖。

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

FlintNDE 0.4.0 数值后端随 v0.13 放在版本目录内，缺省位置只在一个相对路径变量中定义：

```wl
MSFlintNDEConfiguration[]
(* relativePath -> Vendor/FlintNDE *)

MSSetFlintNDERelativePath[FileNameJoin[{"new-name", "code", "package"}]]
```

路径始终相对当前 MadStree 版本目录；Vendor 此后改名或移动时只改这一项。`MSNumericalSystem` 保留为用户自行提供边界向量时的低层入口。

MMA 自动调用的运行根缺省是调用脚本旁唯一的 `results_temp/`：

```text
results_temp/
  nde/    # 当前请求输入与日志
  cache/  # 按请求和后端源码身份命名的成功 JSON cache
```

`MSRuntimeDirectory -> path` 的显式路径就是运行根本身；绝对路径直接使用，相对路径相对当前调用脚本目录解析，不依赖进程工作目录，也不会再次追加 `results_temp`。Windows 下在目录创建和 Python 启动前检查完整 cache/input/log 路径；超过安全上限时独立返回 `RuntimePathTooLong` 及实际长度。`RuntimeInputWriteFailed`、`PythonFlintUnavailable`、`FlintNDELaunchFailed`、`FlintNDEOutputMissing` 和 `FlintNDEOutputInvalid` 保持互斥故障边界。成功结果缓存键同时包含请求内容以及 `Backend/flintnde_transport.py`、Vendor `pyproject.toml` 和排序后的 `flintnde/*.py` 的 SHA-256，因此当前版本原位修复后不会误复用与源码身份不匹配的计划。Python 按缺省规则在相应 package 旁建立 `__pycache__/`，该目录及 `*.pyc` 已由 Git 忽略。除这些调用侧缓存外，程序包源码目录不接收运行产物。
MadStree adapter 与 Vendor Wolfram bridge 均通过参数列表 `RunProcess` 启动 Python，不经过
shell `Run`、命令引号拼接或重定向，也不提供重试 fallback；连续调用的 Windows DLL 初始化
回归由当前数值门禁和 Vendor `25/25` 接口测试共同覆盖。

裸用户点结果保存在 `MSEvaluatePath` 返回值的 `"saved"` 记录中；`"tmp"` 点只参与输运。可用

```wl
MSExportEvaluationData[result, MSOutputDirectory -> outputDirectory]
```

把已保存普通点导出为 CSV/JSON。任一请求格式写出失败时返回 `EvaluationExportFailed`，不会因另一格式已写出而声称整体 `"written"`；路径过长仍单独返回 `RuntimePathTooLong`。临时点不进入普通点导出。正式导出位于调用方指定的 `results/`；程序包源码目录不接收运行产物。
完整公式、massless `4 -> 2` quotient、contact shift 与 top-to-sub dlog 推导见 [Documentation/tree_formula.pdf](Documentation/tree_formula.pdf)。

## Examples

- [01_massless_full_edge.wl](Examples/01_massless_full_edge.wl)：massless quotient、主积分、递推、dlog 和自动边界/数值入口（含用户自定义有限边界与批量多点求值、CSV/JSON 导出）。
- [02_vertex_family_reduction.wl](Examples/02_vertex_family_reduction.wl)：单顶点专用输入、局部张量逆和有限线性组合约化。
- [03_time_only_cycle_chart.wl](Examples/03_time_only_cycle_chart.wl)：time-only 圈图、共同 theta、contact sector 与全部 strict-rank chart。
- [04_three_vertex_tree.wl](Examples/04_three_vertex_tree.wl)：三顶点 massless 树图（+++ 顶点结构），后接批量多点求值与 CSV/JSON 导出。
- [05_massive_three_vertex_tree.wl](Examples/05_massive_three_vertex_tree.wl)：三顶点 massive 树图（+++ 顶点结构、非半整数 nu），后接批量多点求值与 CSV/JSON 导出。
- [06_massless_three_vertex_ep_regularization.wl](Examples/06_massless_three_vertex_ep_regularization.wl)：
  三顶点 massless 树的共同时间幂正规化 `a1=a2=a3=1+ep`；用户只要求返回到 `ep^0`，
  程序在数值 NDE 前由符号边界与 DE 认证最低幂为 `0`，再选择生产/验证点并提取有限项。

六个 examples 已在删除既有 `results/` 与 `results_temp/` 后从 v0.13 路径全部 fresh 运行并退出 `0`；
Example 06 自适应检查为 `15/15`，使用 3 个生产点、2 个独立验证点，缺省请求 12 并按实际
点数自动使用 5 个并行任务。

## 当前边界

- 已支持共同-theta odd-subset simultaneous contact、coincident massless/massive quotient、event-reachable sector BFS 与纯 time-only 圈图；这不等于支持 loop-momentum integration。
- H/h 局部二态与全 sector 状态向量可逆；已经积分后的 `MSIntegral` 换基涉及 family 基准时间幂变化，当前不伪装成普通状态变换。
- 生产边界不按图名或 master 数分派。单顶点 massiveExternal 也走同一通用路线（2411.03088 Sec.3.3 显式级数仅保留为测试对照基准）；已闭合的 tree/time-only context 统一由 sector DAG、component/slot metadata、normalization 和 strict time rank 生成 nested curve、完整 dlog pullback residue 与 ancestor-sector leading system。公式/dlog/chart 未闭合、late-time 指数不衰减或拉回系统不是 exact regular singular 时结构化 fail closed；有限点定义积分只用于独立验证。
- FlintNDE 输运要求拉回 connection 属于 exact `Q(i)(s)` 或 `Q(i)(t)`。T1 mixed 三顶点的独立 `15 x 15`/`25 x 25` 边界和输运已通过 `24/24`；T2 单顶点三 massive 通过 `12/12`；T3 两顶点 `G++` 的 paper/package basis map、五个边界分支和完整目标向量通过 `18/18`。pure massless 与 triangle time-only 开发检查也使用同一个通用 boundary producer。
- FlintNDE 0.4.0 保留 exact Lee--Moser、高阶 pole 与奇点折跃能力，并增加按节点覆盖桶的 fast multipoint evaluation 和公开严格用户节点入口。未认证 high-pole、需要 ramification、代数扩域或一般 Stokes connection 的内部点与终点继续 fail closed。

v0.13 当前开发回归包含符号 Laurent valuation、真实三顶点最低阶证书及 Python adapter；
Examples 01--06 `6/6`。清空旧报告和结果后的独立验证 01/02/03 分别通过 `18/18`、`26/26`、
`16/16`，详见版本化任务书与当前报告。
