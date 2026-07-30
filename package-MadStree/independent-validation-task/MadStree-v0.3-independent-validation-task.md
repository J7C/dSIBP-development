# MadStree v0.3 独立验证任务书

更新日期：2026-07-30。

本任务书单列于验证目录之外。每项验证的程序、结果和自动生成报告分别放入下列三个带版本号的目录；报告应复述本任务书中与该项有关的目标、输入、方法和通过条件，因此验证目录内不再复制任务书。前置能力未完成时保持 `pending`，不得把结构检查写成数值通过。

## 统一门禁

- 首先检视全部公开功能是否由 topology/context metadata 驱动并适配任意 dS 树图或声明支持的 time-only 图，而不是只对本任务中的单个函数族、单个图或单组参数成立。生产代码不得按测试图 id、固定顶点数、固定 master 数或论文例的固定数值参数分派；单个数值例通过只认证该例，通用性必须另由源码数据流和结构不同的拓扑共同确认。
- 每个测试固定一个精确、普通、远离收敛边界的参数点；同一点的不同变量表示不计作多个数值点。
- 初始化时总是显式给出 `NuConvention`。MadStree 缺省为 `"Positive"`，而 2411.03088 使用
  `h(nu,0;z)=z^(-nu) H_nu(z)`；所以测试 2、3 必须显式使用
  `NuConvention -> "Negative"`，不得依赖缺省值。
- 两条路线必须使用相同 Hankel branch、时间幂、动量、归一化、master 顺序和边界数据。任何 basis 变换都要保存正反矩阵及 exact residual。
- 数值输运前必须通过 MadStree 的普通点/normal-crossing 证书和 FlintNDE 的 capability preflight。若返回 `continuation_ready=False`，测试停止并记录不支持的奇点类型，不允许回退到普通 Taylor 路线。
- 每项先做 exact 矩阵、basis 和边界系数检查，再做一个数值点。结果保存 exact residual、数值差、工作精度、截断阶数、refinement 误差和运行时间。
- 自动报告必须简要列出实际数值点、从边界/奇点起点到该点的实际分段路径或 blow-up chart、边界 Frobenius/级数阶数、局部奇点展开阶数、普通输运与 reference/refinement 阶数，以及总耗时和可取得的分项耗时。自动路径必须保存 FlintNDE 实际返回的路径摘要，不能只写“自动输运”。
- pending、失败或前置 exact check 提前停止时，上述字段仍须保留；未执行项明确写 `未执行` 和原因，计划点、计划路径或计划阶数不得冒充实际执行数据。

## T1 无质量四态 Hankel 基与 quotient 二态基对照

验证目录：`independent-validation/MadStree-v0.3-validation-01-massless-redundant-vs-quotient/`。

状态：`pending fresh numerical rerun`。旧的 `22/22` 结果只完成了完整符号 intertwining、
manufactured ordinary-boundary continuation 和一个 child-sector 定义积分；它不再满足本轮要求的
25/15 两套生产边界完整数值交叉，因此不能沿用为当前通过结论。

### 目的

验证“先把无质量 full edge 当作两个独立 Hankel 端点套用通用公式，最后代入 massless 额外关系”和“初始化时直接缩成一个共享二态 slot”给出同一结果。

### 固定函数族与 convention

- 使用三顶点链 `v1 -- em -- v2 -- ez -- v3`。`em` 是 `massiveFull G++`，动量 `qm`、`nu=1/5`；`ez` 是 `masslessFull G++`，动量 `qz`、`nu=1/2`。三个顶点均取 `phaseSign=+1`、`timePower=1`。显式指定 `NuConvention -> "Positive"`；此时 massless endpoint 的 `h=z^(1/2) H_(1/2)` 正好化为指数。
- quotient context 对 `ez` 明确写 `masslessRepresentation -> "Quotient"`；冗余 context 明确写 `masslessRepresentation -> "RedundantH"`。表示选择写入 line metadata 和 master digest，初始化后不允许逐次公式调用覆盖。
- quotient 四个 sector 的 master 数依次为 `{8,2,4,1}`，总数 `15`；冗余四态的对应维数为 `{16,4,4,1}`，总数 `25`。sector 顺序按 `{top, contracted:em, contracted:ez, contracted:em,ez}` 的 package canonical order 固定，报告保存实际 key 以复核。
- 冗余论文 h-state 按 `(00,01,10,11)` 排列，满足
  `F01=-F10`、`F11=F00`。未除去端点动量的物理导数态另行验证
  `calF01=-calF10`、`calF11=q^2 calF00`；不得把二者或 package 的
  `F11^J=-F00^J` 混写。
- quotient 路线使用当前共享二态及手册中的 embedding/projection、`D_sigma` 和端点 contact 权重 `(-2,+2)`。

### 固定 normalization 与四态/二态映射

- 根 sector normalization 固定为 `1`。对实正物理动量模长，massive 收缩使用 2411.03088 Eq. (4.2) 的无歧义形式
  `-(4 I/Pi) Exp[Pi Im[formulaNu]] qm^(-2 formulaNu-1)`；massless 收缩 normalization 固定为 `1`。两种 context 不允许另加常数 gauge，也不得把形式符号 `(-qm)^power` 交给 Mathematica 主支。
- RedundantH endpoint states 采用 quotient-compatible h normalization，不额外保留原始 Hankel 乘积的 `2/Pi` 常数。对 `sigma=+1`，局部列向量映射固定为
  `Slocal={{1,0},{0,I},{0,-I},{1,0}}`、
  `Plocal={{1,0,0,0},{0,0,I,0}}`，并要求 `Plocal.Slocal=IdentityMatrix[2]`。
- 每个仍含 `ez` 的 sector 在 massive spectator slots 上张量单位矩阵，并按实际 slot key 插入 `Slocal/Plocal`；已经收缩 `ez` 的 sector 使用单位映射。由此得到全局 `Sglobal:25x15` 与 `Pglobal:15x25`，固定要求 `Pglobal.Sglobal=IdentityMatrix[15]`。
- RedundantH 的 massless contact 列在第一个端点为 `2 I sigma {0,-1,1,0}`，第二个端点取反；投影后必须精确得到 quotient 的 `{-2,+2}` endpoint 权重。

### 约化检查

1. 只检查相邻层的一阶 shift，不做高阶遍历：一项在 `v1` 取 `+1` 以触发 massive contact，一项在 `v3` 取 `+1` 以触发 massless contact；其余 component shift 为零。源 state 选择为能给出非零相应 contact 的最低二进制态，具体 bits 与由 `Pglobal` 给出的冗余线性组合一并写入报告。
2. 在冗余四态通用 Hankel 递推中完成约化，随后对 top 与 child 的结果统一施加 massless relation/projection。
3. 用当前 quotient 二态公式直接调用 `MSReduce` 约化同一积分。
4. 把两边映到同一 quotient master order，要求全部 master 系数、contact 系数和 shift residual exact 相等；两边 residual 均为零。

### dlog 与数值检查

1. 生成冗余四态和 quotient 二态的公式矩阵、contact、两项低阶约化及完整 block-triangular dlog；先代入本节冻结的有理数值点，再检查 `P M25 S-M15` 或对应系数向量的最大数值残差。不得每次对完整 25 维表达式执行全符号 `Simplify`。
2. quotient 与 RedundantH context 分别调用生产 `MSBoundaryData`，固定 strict rank `{v1,v2,v3}`；两套边界必须都来自 `2411GenericSectorLeadingSeries`，不得用 manufactured ordinary boundary 代替。
3. 两套生产边界分别交给 FlintNDE，从各自的 Frobenius 奇点起点输运到同一个普通数值点，得到完整 `I15` 与 `I25`。RedundantH 的全部 25 个 Frobenius 初值必须由 `MSBoundaryData[redundantContext]` 直接生成，禁止用 `Sglobal.Cq` 反推或替代；FlintNDE 只可把这 25 个直接生成的初值排成 `25x25` 多列矩阵，共享同一个局部基和路径算子进行批量输运。`Sglobal/Pglobal` 仅用于生成完成后的数值交叉。比较 `Pglobal.I25` 与 `I15`，并分别记录两条路径、阶数、refinement 和耗时。
4. 对完整 `I25` 的每个仍含 `ez` 的 sector、每组 spectator bits，数值检查 `F01=-F10`、`F11=F00`，以及恢复端点动量后 `calF01=-calF10`、`calF11=qz^2 calF00`。这项必须覆盖 top sector，不能只用 massive 已收缩的 child sector 代替。

### 固定数值点、路径与精度

- 数值矩阵比较点之一固定为 `{k1->-15 I,k2->-10 I,k3->-5 I,qm->4/3,qz->5/4}`；输运 target 固定为 `{k1->-480 I,k2->-60 I,k3->-7 I,qm->4/3,qz->5/4}`，靠近 `BoundaryScale=2` 产生的有限 match point，以避免把无关的长路径成本混入表示比较。
- 从 anchor 到 target 采用三顶点能量的同步仿射参数 `s in [0,1]`；运行前逐个检查两套 dlog 的全部 letters 在 anchor、target 和实际 FlintNDE 分段路径上均非零。若需要绕行，报告保存实际复路径，不改变数值点。
- 生产边界使用 `BoundarySeriesOrder=20`、`BoundaryScale=2`、strict rank `{v1,v2,v3}`。数值矩阵比较在两个固定普通点各做一次；Frobenius 与普通输运初值为 `TransportOrder=24`、`ReferenceTransportOrder=32`、`WorkingPrecision=30`、目标相对误差 `1e-8`，若实际 refinement 不通过才提高，并在报告中记录。禁止恢复 manufactured ordinary boundary。

### 通过条件

- 数值代入后的公式、contact、低阶约化和 dlog 投影残差小于工作精度相称的阈值；
- 两种路线的 quotient 主积分逐分量一致；
- 完整 25 维主积分数值在所有相关 sector 满足无质量关系，且没有漏掉 `q^2` 或 contact distribution。

执行结果：待按上述数值路线 fresh 重跑。旧 `22/22` 报告保留为历史文件内容，重跑成功前不作为当前认证。

## T2 2411.03088 单顶点三 massive 的 `k0 -> infinity` 解

验证目录：`independent-validation/MadStree-v0.3-validation-02-paper2411-three-massive-vertex/`。

状态：`passed (12/12, fresh rerun 2026-07-30)`。生产 Frobenius producer、独立论文级数、测试专用定义积分和 FlintNDE 输运已分路线执行。

### 文献对象

- 2411.03088 Eq. (2.10)-(2.12) 的单顶点 `n`-fold family；取 `n=3`，共有八个 masters。
- `k0 -> infinity` 的通用解和边界系数使用 Eq. (3.44)-(3.46)，一般 Hankel branch 的系数按 Eq. (3.51)-(3.58)。
- 该检查只针对单 sector 内的 vertex-family 系统，不依赖传播子连接到何种 `+/-` 顶点。选择一种与论文 `exp(i k0 tau)` 一致的阻尼 branch 后全程固定即可。

### 输入与点选择

- 用 `MSInitVertexFamily` 输入三个 massive h blocks；显式指定
  `NuConvention -> "Negative"`，并逐条指定 Hankel branch。
- 冻结一组避开 Gamma pole、共振层和 DE letters 零点的精确有理参数。
- 选择满足文献多变量级数收敛条件的普通点，并保留明显余量；推荐要求
  `Sum[Abs[ki/k0],{i,1,3}] <= 1/2`，不要把点放在收敛半径附近。
- 论文公式与 MadStree 必须代入完全相同的 `k0,k1,k2,k3`、三个 `nu`、顶点时间幂、Hankel branches 和边界系数。

### 检查步骤

1. 独立实现 Eq. (3.44)-(3.46) 的八组级数及 Eq. (3.45) 边界系数，记录截断余项估计。
2. 由 MadStree 的论文边界 producer 生成同一八维边界，并核对最低权、二进制顺序和八个 leading coefficients。
3. 用 MadStree dlog DE 从该边界输运到选定普通点；不得改用有限 anchor 直接积分作为被测结果。
4. 将两边变换到同一 master order，逐分量比较八个主积分。定义积分或有限 anchor 只可作为独立第三路线，不可参与选择边界系数。

### 通过条件

- 八个 leading coefficients 与论文公式 exact 相等；
- 级数值与 MadStree/FlintNDE 输运值在截断误差和 refinement 误差内一致；
- 显式负 prefactor context 的 master digest、branch 和 normalization 全部匹配。

执行结果：leading coefficients exact 相等；生产与独立级数在 anchor 差为零；定义积分 oracle 最大相对差 `2.27e-45`；目标点输运与 28 阶独立级数最大相对差 `9.46e-23`。验证程序为对应目录中的 `run_validation.wls`，并由该程序生成 `000_MadStree-v0.3-validation-02-report.md`。

## T3 2411.03088 两顶点单条 `G++` 的五主积分解

验证目录：`independent-validation/MadStree-v0.3-validation-03-paper2411-two-vertex-gpp/`。

状态：`passed (18/18, 2026-07-30)`。独立论文奇点系统与 MadStree 生产边界分别经 FlintNDE 输运，完整五维向量及 contact 分量均通过。

### 文献对象

- 2411.03088 Eq. (4.1) 的两顶点单条 massive `G++` top sector 四个 masters，以及 Eq. (4.2) 的 contact/subsector master，共五个 masters。
- 使用论文 blow-up `x=k34/k12`、`y=1/k34`，对应 `k12 >> k34 >> 1`；最低权与五组解见 Eq. (4.5)-(4.10)。
- 边界系数使用 Eq. (4.11)-(4.13)；前四个 homogeneous 系数还应满足 Eq. (4.14) 的单顶点乘积分解。

### 输入与点选择

- 初始化两个同号正顶点和一条 massive `G++` full edge，端点 Hankel branches、`ks`、顶点时间幂及 normalization 与论文一致。
- 显式指定 `NuConvention -> "Negative"`；不得使用 MadStree 缺省正 prefactor。
- master 顺序固定为论文二进制顺序 `{I00,I01,I10,I11,IR}`。top normalization 为 `1`；child master 固定使用论文 Eq. (4.2) 的 `IR=-(4 I/Pi) Exp[Pi Im[nu1]] ks^(-2 nu1-1)` 乘合并后的单时间积分。修正后的 package basis 与论文 basis 间正反映射都固定为 `IdentityMatrix[5]`，必须同时由完整 connection 和五个 leading branches 检查。
- 精确参数固定为 `nu0=2,nu1=1/5,ks=1`；目标普通点固定为 `{k12=-30 I,k34=-6 I}`，即 `{x=k34/k12=1/5,y=1/k34=I/6}`，满足保守收敛余量 `Abs[x]+Abs[ks y]=11/30<1`。生产 anchor 由 `BoundaryScale=4` 确定为 `{k12=-32 I,k34=-8 I}`，即 `{x=1/4,y=I/8}`。
- 奇点曲线固定为 `k12=1/(xA yA t^2), k34=1/(yA t)`、`t:0->1`；随后从 anchor 到 target 使用同步仿射参数 `s:0->1`。FlintNDE 局部 Frobenius/普通输运使用 `TransportOrder=72`、reference `96`、工作精度 `50`、目标相对误差 `1e-20`。论文双变量闭式级数不另截断；独立路线直接把 Eqs. (3.3)、(4.4)、(4.5)、(4.11)--(4.14) 写成 exact 奇点系统交给同一数值后端。

### 检查步骤

1. 独立生成论文五个 leading solution vectors 和 `C[1]...C[5]`，核对 `C[1]...C[4]` 的顶点乘积分解及 remaining term `C[5]`；所有 `(-1)^r` 均按 principal branch 显式化为 `Exp[I Pi r]` 后做 exact 比较。
2. 由 MadStree nested blow-up producer 在相同 rank `k12 >> k34` 下生成五维边界，检查 theta 固化为论文采用的 `0/1`、top-to-sub block 和 master order。
3. 独立按论文 Eq. (3.3)、(4.4) 构造五维 potential，验证其 connection 与 MadStree connection exact 相等；分别从论文 leading data 和 MadStree boundary 启动 FlintNDE，输运到同一普通点并比较完整五维向量，不能只比较四维 homogeneous top block。
4. 另比较 contact/subsector 分量和 `G++` remaining term，防止仅靠 top-sector 因子化掩盖非齐次块错误。

### 通过条件

- 五个 leading vectors、五个边界系数和 top-to-sub normalization exact 对齐；
- 完整五维数值向量在级数截断与 refinement 误差内一致；
- theta rank、Hankel branch、负 prefactor convention 和 master digest 均有机器可读证据。

执行结果：修正后的 paper/package basis map 为 `IdentityMatrix[5]`；完整 multivariate connection、奇点曲线 connection、五个 leading vectors 与五个 principal-branch coefficients 的 residual 均 exact 为零。目标点与 anchor、路径和阶数如上冻结；生产/独立论文目标向量最大相对差为约 48 位精度的零，contact 分量同样为零。fresh 总 wall time 约 `18.721 s`，正式脚本、自动报告和 summary 位于 T3 验证目录。

## T4 单顶点公式、低阶约化与 H/h 双向变换

验证目录：`independent-validation/MadStree-v0.3-validation-04-vertex-reduce-hh/`。

状态：`passed (15/15, 2026-07-30)`。独立 oracle 只使用 2401 的局部二态方程、二进制张量顺序和一阶 time IBP，不读取开发测试中的 expected。

### 函数族、顺序与 normalization

- 取单顶点、两个 massive h blocks，输入 `ki={k0,k1,k2}`、`nui={a0,nu1,nu2}`、Hankel branches `{1,2}`，根 normalization 固定为 `1`。分别初始化 `NuConvention -> "Positive"` 与 `"Negative"`，初始化后不允许覆盖。
- master 顺序按 2401 的二进制数递增，固定为 `{00,01,10,11}`；第一位属于 `k1,nu1` block，第二位属于 `k2,nu2` block。所有 master 的基准 shift 为 `{0}`。
- h 定义固定为 `h=z^(+nu) H_nu` 或 `h=z^(-nu) H_nu`。局部 H-to-h 矩阵由乘积求导独立得到
  `{{z^p,0},{p z^(p-1),z^p}}`，其中 `p=+nu` 或 `-nu`；逆矩阵由同一三角矩阵直接求出。全 sector 变换是两个局部矩阵按上述 bit order 的 Kronecker product，不另乘 normalization。

### 独立低阶递推

- 独立构造 `P1=DiagonalMatrix[{0,1}]`、`sigma2={{0,-I},{I,0}}`，并用
  `M1(n)=(a0+n) I4-(2 formulaNu1+1) P1 tensor I2-(2 formulaNu2+1) I2 tensor P1`、
  `M0=I k0 I4-I k1 sigma2 tensor I2-I k2 I2 tensor sigma2`。
- 只检查线性组合
  `2 MSIntegral["top",{1},{0,0}]-3 MSIntegral["top",{-1},{1,0}]`。
  `+1` 项由 exact `LinearSolve[M0,...]` 实现 raising 一步，`-1` 项由 exact diagonal `M1(0)` solve 实现 lowering 一步；不做更高阶遍历，也不在独立 oracle 使用 package 的 `U/UInverse`。
- 比较 package `MSReduce` 的完整四维系数向量、残留 shifted integral、非 master residual 和自定义逆序 master basis。两种路线必须在同一 normalization 与 master order 下比较。

### 精确探针与报告字段

- exact 符号比较为主；另固定非奇异有理探针
  `{a0->7/6,k0->11/3,k1->2/5,k2->3/7,nu1->1/4,nu2->2/7,z1->5/4,z2->7/5}`，确认所有被求逆本征值非零。
- 本任务不生成物理边界、不做数值路径输运；边界点、anchor、路径、Frobenius 阶数和输运阶数均在报告写 `不适用`。报告记录符号阶段、递推比较、换基比较和总 wall time。

### 通过条件

- 两个 convention 的 bit order、`M1/M0` 与独立公式逐元 exact 相等；生产 Formula/DE 源码中不出现通用大矩阵 `Inverse`。
- 两项低阶约化的完整系数向量 exact 相等，残留为零，逆序 basis 只反转系数排列。
- 正、负 prefactor 下局部及四维全 sector 的 `H -> h -> H` 与 `h -> H -> h` residual 全为零；逐调用改变 convention 必须 fail closed。

执行结果：两个 convention 的 `4x4` `M1/M0`、两项低阶约化、自定义 master 排列及局部/全 sector H/h 双向变换全部 exact 通过；公式源码未发现通用大矩阵 `Inverse`。正式报告总 wall time 约 `1.753 s`。

## T5 simultaneous contact、time-only 圈图与 normal-crossing

验证目录：`independent-validation/MadStree-v0.3-validation-05-simultaneous-cycle-chart/`。

状态：`passed (17/17, 2026-07-30)`。独立 expected 来自共同-theta 恒等式、图 partition 和严格 rank blow-up，不读取 `test_simultaneous_cycle_chart.wls` 的计数或矩阵。

### Simultaneous contact 与 normalization

- 取两个顶点 `u,v`，时间幂 `au=1/3,av=2/5`，三条平行 massless `G++` full lines，动量 `{2,3,5}`，`nu=1/2`，根 normalization 与每条 massless pinch normalization 均为 `1`。
- 三条边显式组成一个共同-theta bundle。独立展开
  `Product[Ae]-Product[Be]`，只保留非空奇数子集 `S`，事件系数为 `2^(1-|S|)`；因此 top 只有三个单边事件和一个三边 simultaneous event，三边系数为 `1/4`。
- 任一非空 event 只合并 `u,v` 一次；child 基准时间幂均为 `au+av+1=26/15`，normalization 仍为 `1`。未选 massless coincident spectator 的 odd state 为零，所以三个单边 child 各只有一个 master；三边 child 也只有一个 master。

### Triangle time-only 圈图与 chart

- 取三顶点 triangle，三条 massless `G++` full lines `l12,l23,l31`，固定点
  `{k1->-11 I,k2->-7 I,k3->-5 I,a1->1/3,a2->2/5,a3->3/7,q12->2,q23->3,q31->4}`，根/line normalization 全为 `1`。
- 独立 partition 枚举给出七个 reachable sectors：top、三个单边 contraction 和三个双边 contraction；三边同时 contraction 会形成 cycle，不是新的 partition，必须排除。top 有三条转移，每个单边 sector 有两条到双边 sector 的转移，总数 `9`；重复路径必须 canonical 到同一 sector key。
- 对三顶点全部 `3!=6` 个 strict rank charts，按
  `K[sigma1]=1/(x1 x2 x3), K[sigma2]=1/(x2 x3), K[sigma3]=1/x3`
  独立检查每个 affine energy letter 抽去坐标 monomial 后在 `x=0` 为非零 unit。theta 值由同一 root rank 在全部 sectors 固定，不允许出现 `unfixed`。

另以三条平行 massive `G++` lines 检查 coincident quotient。根 normalization 固定为 `1`，三条 line 的显式 pinch normalization 固定为 `{2,3,5}`；单边 child normalization 必须分别为 `{2,3,5}`，三边 simultaneous child 为 `30`。单边 contact 后余下两条 coincident massive lines 各保留 `{00,01~10,11}` 三态，所以总 master 数必须是 `3^2=9`，局部张量对角化正反矩阵 exact 互逆。

### 报告字段与通过条件

- 本任务只做 exact 组合学、矩阵与多变量边界证书，不启动 FlintNDE；数值输运路径与展开阶数写 `不适用`。报告保存上述精确点、六个 rank orders、各 sector normalization/base power、divisor 数与各阶段 wall time。
- odd-subset 事件、系数、child base power、contact endpoint 权重、七 sector/九 transition canonicalization 必须逐项 exact 相等。
- 六张 chart 的全部 sector quotient、theta fixing、Jacobian 和 strict transform 均通过；shifted child contact 必须约到全局 master order且无 residual。

执行结果：共同-theta odd subsets、`1/4` 三边事件、massless/massive simultaneous normalization、`3^2=9` coincident massive masters、triangle 的七 sector/九 transition、六张 strict chart 各 `25` 个 divisors，以及 shifted-child dlog closure 全部 exact 通过。正式报告总 wall time 约 `2.192 s`。

## T6 MadStree--FlintNDE 保存点、调用目录与能力边界

验证目录：`independent-validation/MadStree-v0.3-validation-06-flintnde-adapter-capability/`。

状态：`passed (16/16, 2026-07-30)`。本任务验证 Wolfram 公开入口实际调用 FlintNDE，不用 Python 直调代替 MadStree adapter。

### 普通点路线与 normalization

- 取单顶点零 h-block family，积分 normalization 固定为
  `I(a,k0)=Integral[(-tau)^a Exp[I k0 tau],{tau,-Infinity,0}]`
  且根 normalization 为 `1`。固定 `a=1/3`、目标 `k0=3`，解析值为
  `Gamma[4/3]/(I k0)^(4/3)`，branch 与 MadStree `phaseSign=+1` 一致。
- `MSBoundaryData` 使用 `BoundaryScale=8` 产生无穷远 Frobenius/Laplace match point；从实际 anchor 到目标沿 package 的仿射参数 `s:0->1`。用户保存点输入严格为 `{{0,"save"},{1/2,"save"},{1,"save"}}`，不接受名称字段。
- 工作精度 `50`，普通输运与正则奇点启动均使用阶数 `72/96`，目标相对误差 `1e-22`。较低的 `48/72` 在该长仿射路径上虽使参考链对解析值达到约 `6e-25`，但主链/参考链差仅约 `8e-17`，不满足本任务的 refinement 门槛，因而不作为正式设置。每到一个标记点必须先在验证脚本调用目录写独立 JSON；完整成功后再写一个汇总 JSON。报告逐点列出 `s`、对应物理 `k0(s)`、结果数组、解析差和实际 adaptive path。

### 正则奇点与超能力 fail-closed

- 为同一一维 master 构造与物理 normalization 分开的 adapter capability probe：奇点连接 `A(t)=2/t`，边界 `{a=2,b=0,C={1}}`，物理权重 `1`，从 `t=0` 到 `1`。奇点起点以 `{0,"save"}` 标记，保存结果必须是可复用的 `frobenius_boundary`，而不是伪造的奇点函数值。
- 再把输入改为二阶 pole `A(t)=2/t^2`。MadStree 当前只声明 direct exact regular-singular launch；后端分类若不是 `regular_singular`，必须返回结构化 Failure，错误证据包含实际奇点类型，并且不得进入后续 ordinary transport 或写 complete summary。
- 所有 JSON、cache 与路径中间文件只能出现在验证调用目录及其 `results_temp/`；package 版本目录在执行前后不得新增运行文件。

### 通过条件

- 普通路线三个保存点按输入顺序即时写出，最终汇总含坐标和一维结果数组；终点与公开返回值一致，三个解析 residual 均受 refinement 控制。
- 正则奇点起点保存 `{a,b,C}` 合同并成功输运；二阶 pole probe fail closed，分类和错误类型可机器读取。
- 报告记录 boundary、ordinary、singular、fail-closed、文件检查及总 wall time；保存点输入一旦含名称或缺少字面量 `"save"` 必须在调用 Python 前拒绝。

执行结果：普通点三个保存文件与最终汇总均由调用目录持有，保存值对解析 Gamma 解的最大相对差约 `1.09e-33`；正则奇点保存内容为 `{a=2,b=0,C={1}}`，并成功接到非平凡 ordinary segment；`2/t^2` 被分类为 `non_fuchsian_input_basis` 后 fail closed。正式报告总 wall time 约 `4.122 s`。

## 执行顺序

1. T1--T3 保持其已冻结的物理 normalization；修正共享生产公式后必须 fresh 重跑受影响任务。
2. T4 先独立锁定单顶点公式、递推与 H/h convention，再执行不依赖 NDE 的 T5。
3. T6 最后执行；保存点适配器、正则奇点和 fail-closed 任一失败时，不得用 FlintNDE 自身的 Python 测试冒充 MadStree 入口通过。

任一前置 exact check 失败时停止对应数值测试，只保存失败证据，不继续扩大 FlintNDE 的奇点处理能力边界。
