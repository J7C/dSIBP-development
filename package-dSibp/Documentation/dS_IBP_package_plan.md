# dS IBP Package 主线计划

> 本文件是长期总体 plan，负责记录目标架构、物理 convention 和模块边界。当前逐任务状态、完成勾选和交接顺序统一记录在项目根目录 `研究计划与研究进度.md`；每次收到新任务先更新该文件，不在本 plan 中维护重复 todolist。

## 1. 目标

对任意 dS 时空 Feynman 图（任意圈数、任意拓扑、massive/massless 混合），编写 Mathematica 脚本（`.wl`），通过拓扑输入驱动通用 IBP 生成函数，自动生成经过前端 EOM/time-IBP canonical 化的 IBP 关系。Kira 输入文件只作为后端阶段输出，必须在 EOM 与 time-IBP 完整实现并通过 seed-level 检查后才开放；seed 产物保存为 MMA 表达式，不能直接导出给 Kira。

当前主线门禁：
- EOM 不是后处理选项，而是 seed 生成的一部分；任何 Hankel 二阶导数一旦产生 `n=2`，必须立刻用 EOM 递推消去。
- time-IBP 与 momentum-IBP 同属必需 seed 来源；缺少 time-IBP 时，不允许声称已经得到完整 IBP 系统。
- Kira 导出只消费 `makeLinearSystemData` 产生的 linear-system 数据，不直接消费 seed batch。`makeCanonicalSeedBatch` 自动派生并联立全部 contact-reachable shrink sectors，不设置 sector 数量上限；若仍有 `n=2`、sector coverage 不完整或其它 pending feature，则不能进入 linear/Kira 阶段。当前 `makeKiraExportData` 已能写 user-defined system 文件。独立 numeric linear workflow 可先完成数值规则/撒点选择；准备生成 DE 时，所有 derivative variables 及其内部平方原子必须保持符号，只能固定不参与微分的系数参数。
- 当前 022 使用严格的 `vertices/lines` topology Association、统一三参数 `J`、cycle/fixed 三槽与单槽 shrink schema、sector prefactor、compact lower 导数，以及 massive h/H 与 massless exponential 的 parity transport；用户显式声明两类外动量。common-theta contact、可达 sector 和完整 coincidence canonical 是全部入口共用的正确性门禁。

### P0 seed 模板与显式撒点边界

022 保持 seed 的“离散状态/EOM 构造”和“连续指标撒点”两个原子步骤。`DSSeeds` 生成各 contact-reachable sector 的全部 time/momentum generator 符号模板；模板阶段对 massive 完整枚举端点 `0,1` 四态，对 masslessFull 先按代数 quotient 只枚举 `n2->0` 的 `00/10` representatives，随后立即应用 EOM、共同-theta/contact canonical、可判定 symmetry 与 parity。它额外返回一维列表 `allSeeds`；该列表由所有内部 `Table` 结果用 `Flatten[...,Infinity]` 磨平，连续指标仍为符号。精确数值系数规则只在 `DSLinear` 的 `CoefficientRules` 或 formal Kira 的 post-derivative 阶段使用。

EOM/canonical 可能把某个完整离散态模板化为精确零。密封 `allSeeds` 中的这种 `equation->0` 是应保留的合法恒等式，仍参与模板计数、哈希和离散态完整性审计；只有缺失 equation，或非零且完全不含 `J` 的伪模板才由 `DSGenerateIBP` 拒绝。

`DSGenerateIBP[seeds,{min,max}]` 对模板中全部真实连续指标使用同一整数闭区间。`DSGenerateIBP[seeds,{x1,min1,max1},...]` 允许逐指标范围，但要求用户规则与模板中连续指标 exact cover：未知、遗漏、重复、非整数边界或 `min>max` 均为 fatal input error。`n_i` 不属于连续指标；若 range specification 包含 `n_i`，或模板中仍残留符号 `n_i`/forbidden `n`，接口拒绝生成。`DSGenerateIBP` 是唯一公开撒点入口。

撒点结果必须携带扁平模板、稳定变量顺序、范围规则、候选点数、parity 接受点数、canonical equations、逐模板/输入 SHA-256、离散态完整性和 EOM/canonical 摘要。每个接受点的固定顺序是：代入连续指标、应用用户已经单向定向的 symmetry、重新代入并化简精确 numeric rules、审计 coefficient residual。`artifactContract` 明确区分 sealed complete、sealed subset 与 unsealed raw；三者均可进入 backend-neutral 线性化，但只有 sealed complete 具有 formal reduction capability。`DSLinear` 对 sealed producer 只复算 source digest 并消费摘要，raw 输入才重跑完整 consumer 扫描；随后按 backend 实际消费的数学方程键删除重复关系，并保存去重前、后和删除数。Kira target planning 不再尝试通过整数优化猜测“最大安全 Cartesian box”；它消费用户显式给出的撒点包络并检查 derivative target closure 是否包含在 linear system 中。

018 的连续撒点实现为一次调用内的 sector-topology cache 与条件坐标投影：cache key 只来自 root-ordered line-pack pattern，命中后仍执行 sector metadata shape 检查；general template 先投影一次公开坐标，数值 canonical 只有重新引入内部原子时才再投影。密封模板继续使用 provenance 做 parity 预筛；raw expression 没有 source provenance 时不得猜 parity，保留点域、标记 `unsealed` 并依赖生成后 certificate。raw 子集不自动获得完整 reduction capability。

所有公开调用的 info、progress、warning 与 error 逐句双语输出，固定先中文、后英文。全局消息开关只关闭可选 info/progress/warning，fatal error 始终显示；notebook 中 warning/error 继续用红字。

### P0 动力学坐标边界

018 的用户输入显式区分两类外部动量对象。下文统一简称前者为 `kL`（`kL1,kL2,...`），后者为 `kE`（`kE1,kE2,...`）；这些简称表示列表角色和位置，不要求用户真的采用这些符号名：

- `loopExternalMomenta={kL1,...}` 是用户确认的圈外动量独立基，决定完整 Gram、ISP 闭合与 `dqk` 生成元。第 `i` 项进入内部 `qk[*,i]`、`kk[i,j]`，公开缺省为 `ssij`。程序只审计，不替用户命名或猜选。
- `independentExternalMomenta={kE1,...}` 是实际无圈动量模长列表，只生成 `sp[kEe,kEe]->sEe^2`；坐标/Jacobian 内部槽为 `externalLegSquaredCoordinate[e]`，不生成 `sp[kEe,kEf]`。整体反号视为同一模长，`alice+bob` 与 `alice-bob` 不合并。
- topology 必要方向与两个列表分别比较。exact 通过；overcomplete 允许 seed 但关闭唯一 `ds/DSDE`；undercomplete 返回 missing/null-space 证据并拒绝 `DSInit`。旧动量字段不再读取。

`kL` 与 `kE` 各自在自己的输入列表中从 1 编号，互不共享编号空间。坐标短名只依赖各自列表的稳定顺序：类别总数不超过 9 时保持 `ss11/sE1`；超过 9 时按该列表总数位宽补零，例如 `ss0101/sE01`；超过 99 时自然扩展为三位。用户符号名从不参与编号。

动力学规则或动量列表欠完备时阻断初始化；`DSKinematics` 返回 `undercomplete`、`missingDirections/missingMagnitudeSquares` 与零空间表达式。过完备返回 warning 并允许 symbolic seed，但 `derivativeUsableQ=False`、`inverseKinematicsUsableQ=False`。

根号坐标层是平方不变量原子层的 adapter，而不是第二套微分实现。对

```text
xij = sp[ki,kj] = ssij^2
```

必须使用 `partial_ssij = 2 ssij partial_xij`，并复用已有 `xij` 的 external-vector derivative decomposition。对显式声明的旧规则 `sp[ki,kj]->sij` 保持 `partial_sij=partial_xij` 的单位 Jacobian 兼容语义。转换与求导不得使用 `PowerExpand`。

技术 note 中对 loop Gram 写完整的 `Sqrt[sp[ki,kj]]`，对无圈线写实际动量组合的 `Sqrt[sp[Pe,Pe]]`；`ssij/sEe` 只作为 package API 和 metadata 中的短名。

### P0 正确性模块：共同 theta、Wronskian 与 shrink 指标

同一当前代表顶点对上存在多条 full lines 时，time boundary 的分布定义、`WT` 调用和最终指标映射属于 IBP 正确性门禁，不是可选 bundle 优化。任何发布版本必须同时满足：

- 整个 bundle 先形成唯一共同 boundary，再转成 odd-subset contact；或使用与之严格等价的统一 mollifier，并保留全部逐线中心矩项。
- massive contact 只能读取 `WT=Det[T]W -> shrinkTerms`；普通导数只能读取 `AT -> derivativeTerms`，两条编译链不得混用。
- 每个选中 massive Laurent term 的整数 `bShift`、zero-point shift 同时进入 shrunk line 和 merged vertex；massless contact 的两类 shift 均为零。
- simultaneous contact 只合并顶点一次，但所有选中线的时间整数/零点 shift 都要累加；未选中 coincident full lines必须立即 canonical。
- sector 只枚举 contact-reachable 状态；canonical batch、linearData 和 serializer 不得重新解释或改变该 sector convention。

逐项验收记录见 `Documentation/2026-07-21_common_theta_correctness_todo.md`；两种分布方案及等价性证明见技术笔记附录。

**质量参数 $\nu$**：$\nu^2 = m^2/H^2 - d^2/4$（$d=3$ 时为 $m^2/H^2 - 9/4$）。本 package 只考虑纯实数 $\nu$（重场）和纯虚数 $\nu = i\mu$（轻场）。详见 tech note §1.1。

参考：`ref_code/codebubble/001 bubble_ibp_sym.m`（命名/分段/输出习惯）、`ref_paper/2401.00129_dS_IBP.pdf`（sub-sector 缩并规则）、`ref_paper/1703.10166_SK_Diagrammatics.pdf`（Feynman 规则）。

## 2. 统一积分表示

### 2.1 核心设计

所有 sector（top sector 和所有 sub-sector）使用同一个 Head `J`。020 按初始化后固定的 mode 使用两种互不兼容的参数 schema：

```mathematica
(* full *)
J[{a_1, ..., a_V}, {pack_1, ..., pack_E}, {n_isp_1, ..., n_isp_R}]

(* timeOnly *)
J[sectorKey_String, timeShifts_List, stateBits_List]
```

full 模式中每条内线 `e` 的 pack 同时取决于状态和 line-power schema：
- cycle full line 统一为三槽：massive/masslessFull 都是 `{b,n1,n2}`，masslessCross 是 `{b,0,0}`；cycle shrunk 为单槽 `{bS}`。
- bridge/non-cycle full line 统一以短 sentinel `"F"` 保留三槽：massive/masslessFull 是 `{"F",n1,n2}`，masslessCross 是 `{"F",0,0}`；fixed shrunk 为单槽 `{"F"}`。fixed line 的物理幂由逐 sector 的结构化 `sectorPrefactorData` 保存并参与求导。
- `timeOnly` 下所有 line 都使用 fixed-coefficient schema，即使原图存在结构 cycle；这些 line packs 只在 Private producer 内存在。公开 `sectorKey` 是 root propagator 顺序的定长位串，`timeShifts` 按当前 sector 的 compact vertex components 排列，`stateBits` 按 metadata registry 排列。massive line 每端点一位，massless quotient 整边共享一位，shrunk line 不留占位。

massless 完整线的单 `n_e` 只在双 theta 合并路线中使用。`shiftLinePower` 是唯一幂次原子：cycle line 移动 `b/bS`，fixed line 乘显式能量幂。contact sector 继承 root loop space 与 cycle/bridge schema；shrink 不重新运行一套降圈判定。

### 2.2 masslessFull 的有序端点与单 `n`

对公开 `lines` 列表中的一条线

```mathematica
<|"endpoints" -> {u, v}, "massType" -> "massless", ...|>
```

`{u,v}` 是有序输入。第一端点 `u` 定义 `n=1` 的方向；交换为 `{v,u}` 时，`n=0` 不变，反对称态 `n=1` 变号。对 `++/--` 分别取 `sigma=+1/-1`，令 `Delta=tau[u]-tau[v]`：

```
M[0] = theta[Delta] exp[-I sigma q Delta]
     + theta[-Delta] exp[ I sigma q Delta]

M[1] = -theta[Delta] exp[-I sigma q Delta]
     +  theta[-Delta] exp[ I sigma q Delta]
```

指数核的端点关系为

```
d_u E = -d_v E
d_u^2 E = d_v^2 E = -q^2 E
d_u d_v E = +q^2 E
```

因此原始双端点导数标签满足 `{10}=-{01}`、`{20}={02}=-q^2{00}`、`{11}=+q^2{00}`。018 的公开三槽保留两个有序端点位置，但内部 quotient 把每次端点导数的 `+-i sigma q` 抽到算符系数中，所以无量纲状态写成 `F01=-F10`、`F11=-F00`。cycle line 的 `q` 由每次 `b->b-1` 吸收，fixed/独立外动量 line 的 `q` 由显式模长参数承载；不得把无量纲 quotient 脱离这条系数链解释为原始物理关系。完整 theta kernel 的导数为

```
d_u M[n] =  I sigma q M[1-n] - 2 n delta[tau[u]-tau[v]]
d_v M[n] = -I sigma q M[1-n] + 2 n delta[tau[u]-tau[v]]
```

在 quotient 的 canonical representative `{b,n,0}` 上，regular 指标变化为 `{b,n,0}->{b-1,1-n,0}`，第一/第二端点系数分别为 `+I sigma` / `-I sigma`。连续在同一端点作用两次会得到 `-J[...,{b-2,n,0},...]`。公开三槽中仅 `n1+n2=1` 的奇端点态出现 theta-delta contact；massless 缩并线使用 `{bS}` 且整数部分 `bS=b`、merged `a` 不移位，不同于 massive Wronskian 的 `bS=b+1`、merged `a` 减 1。

双端点 quotient 是代数关系，不是 IBP 关系。`DSSeeds` 的 source 枚举因此只生成 `n2->0` 的 `{00,10}` 两个代表态；`01/11` 只允许作为端点导数或用户表达式的临时输入，并立即连同符号、cycle `b` shift 或 fixed 模长参数 canonical 回代表。seed artifact 同时记录 raw 四态数、代表态数与删除数；不得先生成四态再依赖 `DSLinear` 去重，因为 fixed/独立外动量的物理系数可能含参数，数学方程的字面形式不会重复。

若其它传播子缩并后使某条仍完整的 masslessFull 线的两个原端点映到同一 active vertex，同一个 time 生成元必须同时作用两个端点：regular 的 `+I sigma/-I sigma` 项相消，theta-delta 的 `-2/+2` 项也相消，反对称 `n=1` 积分本身 canonical 为零。这个判定必须根据每个输出 `J` 中的单元素 shrunk packs 重建目标 sector 的代表顶点映射，不能沿用产生该项的 source topology。

上述 regular、shrink 和目标-sector coincident canonical 是 seed pipeline 的强制步骤。任何仍含非法 massless `n`、漏处理 theta 边界项或尚未按目标 sector 抵消的 seed，都不得进入 `linearData` 或 serializer。
`masslessCross` 没有 theta，也没有离散 `n` 或 delta 缩并，但 time 与 momentum IBP 都必须对它的指数相位求导。

### 2.2.1 多条平行 full lines 的共同 theta contact

当前表示继续保留每条线自己的 pack；共同 theta 只改变 time-boundary 与 sector 可达性。对同一当前代表顶点对的 massive/massless full lines 写

$$G_e=\theta(\Delta)A_e+\theta(-\Delta)B_e.$$

则整个 bundle 的唯一 boundary 为

$$\delta(\Delta)\left(\prod_eA_e-\prod_eB_e\right).$$

用 $J_e=(A_e+B_e)/2$、$D_e=A_e-B_e$ 写回逐线 coincidence 基底：

$$
\prod_eA_e-\prod_eB_e=
\sum_{\substack{\varnothing\ne S\subseteq B\\|S|\ {\rm odd}}}
2^{1-|S|}\prod_{e\in S}D_e\prod_{e\notin S}J_e.
$$

因此一次 contact 事件可同时 shrink 任意非空奇数条 bundle 线，系数为 `2^(1-k)`，但只合并代表顶点一次且只含一个 delta。两线只有 single contacts；三线另有 triple contact。未选择的 full lines 在 coincidence 后立即应用 massless odd-zero 与 massive endpoint-swap canonical，不再对其 theta 求导。

sector 枚举按事件状态图进行：只允许连接两个不同当前代表类的 bundle 发生事件；事件之间形成 forest，一个事件内部可以选择奇数条平行线。`shrinkSectorSubsets` 用 BFS 生成这些可达 line sets，而不是 theta-full 线的幂集。

单传播子 equal-time 值采用 `theta(0)=1/2`。该点值不用于直接定义 `delta theta^m`。保留逐线 theta 时可使用同一 Gaussian mollifier `H_eps'=rho_eps`，其逐线极限为 `delta Integral_0^1 dh D_i Product_{j!=i}(B_j+hD_j)`；求和与上式严格等价，并给出 `rho_eps H_eps^m -> delta/(m+1)`。

该 boundary 必须继续落到指标层。对 massive 线，`compileFunctionSystem` 先构造 `WT=Det[T]W`；`compileShrinkTerms` 把 `-WT=Sum c_alpha x^(-s_alpha-z)` 编译为 coefficient、整数 `bShift=s_alpha` 和共同 `zeroPointShift=z`。随后 `thetaBoundaryAtomicTerms` 消费这些项，`shrinkLinesIntegral` 对一个 odd subset 只合并顶点一次并令 `aMerged=a_u+a_v-Sum[s]`、各选中 pack 变为 `{b+s}`，`sectorZeroPointRules` 同步令 `a0Merged=a0_u+a0_v-Sum[z]`、`bS0=b0+z`。massless contact 使用 `s=z=0`。未选中线在新代表映射下应用 coincident canonical；`contactReachableShrinkSubsets` 再由相同事件规则生成 sector。

### 2.3 Sub-sector 层级

sub-sector 不再用不同 Head（G/R1/R2）区分，而是通过哪些线处于缩并状态来标记：

| Sub-sector | 缩并线 | pack 结构 |
|-----------|--------|----------|
| Top sector | 无 | 所有线 `{b, n1, n2}` |
| 1-line shrink | 线 e 缩并 | `pack_e = {bS_e}`，其余不变 |
| 2-line shrink | 线 e1, e2 缩并 | `pack_{e1} = {bS_{e1}}`, `pack_{e2} = {bS_{e2}}` |

### 2.4 缩并的零点分解

缩并因子的幂次取决于 building block 类型（详见 tech note §4.5, §5）：

**h 模式**：缩并因子 $(k_e \tau_v)^{-(2\nu_e+1)}$，分解为：
$$-(2\nu_e + 1) = \underbrace{-1}_{\text{整数 → 指标}} + \underbrace{(-2\nu_e)}_{\text{非整数 → 零点}}$$

**H 模式**：取 $H_1=\partial_zH_0$ 并定义标准 $W_z[f,g]=fg'-gf'$ 时，缩并反对称组合为 $F_H=-W_z[H_\nu^{(1)},H_{\nu^*}^{(2)}]$。数值验证给出精确公式 $W_z[H_\nu^{(1)}, H_{\nu^*}^{(2)}] = -e^{\pi \text{Im}[\nu]} \frac{4i}{\pi z}$（对纯实数和纯虚数 $\nu$ 均成立），故 $F_H = e^{\pi \text{Im}[\nu]} \frac{4i}{\pi} (-k\tau)^{-1}$。$\tau$ 依赖为纯 $1/z$（整数幂次 $-1$），零点无移位。prefactor $= e^{\pi \text{Im}[\nu]} \frac{4i}{\pi}$（与 h 模式相同）。

**无质量**：无 Hankel Wronskian 缩并；但 `masslessFull` 的反对称态 `n=1` 对 theta 求导会产生 delta 缩并。该缩并保留 `bS=b` 且 zero-point 不作 Hankel shift。

**对 $a$（正幂次，$(-\tau)^{a+a0}$）：**
- 指标移位（h/H 整数部分相同）：$a_{\text{merged}} = a_u + a_v - 1$
- 零点移位（h 模式）：$a0_{\text{merged}} = a0_u + a0_v - 2\nu_e$
- 零点移位（H 模式）：$a0_{\text{merged}} = a0_u + a0_v$（Wronskian 给出纯 $1/z$，无非整数部分）

**对 $b$（分母幂次，$q^{-(b+b0)}$）：**
- 指标移位（h/H 整数部分相同）：$bS_e = b_e + 1$
- 零点移位（h 模式）：$bS0_e = b0_e + 2\nu_e$
- 零点移位（H 模式）：$bS0_e = b0_e$（Wronskian 给出纯 $1/z$，无非整数部分）

注意 $b$ 的物理幂次 = $-b$，故物理幂次移位 $-(2\nu+1)$ 对应 $b+b0$ 移位 $+(2\nu+1) = +1 + 2\nu$。

### 2.5 缩并常数 prefactor

每次缩并产生常数 prefactor $\mathcal{C}_e$，乘入 sub-sector 方程系数（详见 tech note §5.3）：

| 模式 | $\mathcal{C}_e$ | 说明 |
|------|----------------|------|
| `"h"` | $\frac{4i}{\pi} e^{\pi \text{Im}[\nu_e]}$ | $e^{\pi\text{Im}[\nu]}$ 来自 $h^{(2)}$ 使用 $H_{\nu^*}^{(2)}$ 与归一化 $(-k\tau)^{-\nu}$ 的共同作用 |
| `"H"` | $\frac{4i}{\pi} e^{\pi \text{Im}[\nu_e]}$ | 与 h 模式相同，来自 cross-order Wronskian $W[H_\nu^{(1)}, H_{\nu^*}^{(2)}] = -e^{\pi \text{Im}[\nu]} \frac{4i}{\pi z}$（已数值验证） |
| 无质量 | $1$ | 无 prefactor |

多次缩并：$\mathcal{C}_{\text{total}} = \prod_{e \in \text{shrunk}} \mathcal{C}_e$。

在 package 实现中，$\mathcal{C}_e$ 作为缩并线属性存储，导出 Kira 输入时乘入系数。

### 2.6 指标零点初始设置

脚本初始化时为所有指标设定零点：

| 模式 | $a0_v$ 缺省 | $b0_e$ 缺省 |
|------|------------|------------|
| `"h"` | $2\nu_{\text{ref}}$ | $-2\nu_e$ |
| `"H"` | $0$ | $0$ |

验证：参考代码 `reppara2N` 给出 $a0 \to 2\nu$, $b0 \to -2\nu$，与 h 模式缺省一致。

## 3. Building Block 参数体系

### 3.1 当前实现与目标接口

022 的 massive 线缺省使用 h preset；需要裸 H 或自定义二维函数空间时，只能通过唯一可选字段 `functionSystem -> "H"|"h"|Association` 指定。裸 H 的 `nu^2/x^2` 由 `AT` 的普通 Laurent 项生成，不在 IBP 层特判，也不读取 `bbType/eomCoefficients`。

目标接口不直接让 IBP 接收一阶矩阵，而是让每条 massive 线先给一个标准二阶函数空间：

$$
f''+P(x)f'+Q(x)f=0,
\qquad
\mathbf Y=(f,f')^T,
\qquad
A_0(x)=\begin{pmatrix}0&1\\-Q&-P\end{pmatrix}.
$$

这里统一规定 `P` 是一阶导系数、`Q` 是零阶系数。目标 `n=0,1` 基底通过同一个可逆矩阵 $T(x)$ 作用于两个独立解得到：

$$
\mathbf F=T(x)\mathbf Y,
\qquad
A_T=T'T^{-1}+TA_0T^{-1}.
$$

每条线的计划输入为

```mathematica
"functionSystem" -> <|
  "variable" -> x,
  "P" -> P[x],
  "Q" -> Q[x],
  "T" -> Automatic,              (* Automatic := IdentityMatrix[2] *)
  "W" -> W[x],                    (* 原始导数基底的完整 Wronskian *)
  "WT" -> Automatic               (* 可选显式值，只用于交叉校验 *)
|>
```

若 massive line 不给 `functionSystem`，缺省使用 h preset：

```mathematica
<|
  "P" -> (2 nu + 1)/x,
  "Q" -> 1,
  "T" -> IdentityMatrix[2],
  "W" -> -(4 I/Pi) Exp[Pi Im[nu]] x^(-2 nu - 1),
  "WT" -> Automatic
|>
```

因此缺省 `WT=Det[T] W=W_h`。显式 `WT` 仍只用于校验，不能覆盖该结果。

`W` 必须包含由函数归一化/边界条件确定的常数；$P$ 只能给出 $W'/W=-P$，不能补出该常数。初始化层以

$$
W_T=\det(T)W
$$

生成目标基底 Wronskian；若用户同时显式给出 `WT`，只检查它是否与该式一致，不能用它覆盖编译结果。

### 3.2 初始化编译层

`compileFunctionSystem[line]` 在生成任何 seed 前完成：

1. 规范化 `T`；`Automatic` 变为单位矩阵，并检查矩阵为 $2\times2$ 且行列式非零。
2. 构造 `A0={{0,1},{-Q,-P}}`、`AT=T'.Inverse[T]+T.A0.Inverse[T]` 和 `WT=Det[T] W`。
3. 检查 `D[W,x]+P W==0`；若给了显式 `WT`，再检查 `WT==Det[T] W`；最后检查 `D[WT,x]/WT==Tr[AT]`。
4. 把 `AT` 的每个矩阵元有限分解为 package 可吸收的参数系数与 $x=-\xi\tau$ 幂，编译为 `derivativeTerms`。
5. 把 `WT` 有限分解为同类项，编译为 `shrinkTerms`；每一项分别映射到系数、整数指标移位和 zero-point 移位。

编译结果缓存为 line-local 数据：

```mathematica
"compiledFunctionSystem" -> <|
  "A0" -> ...,
  "AT" -> ...,
  "W" -> ...,
  "WT" -> ...,
  "derivativeTerms" -> ...,
  "shrinkTerms" -> ...
|>
```

若 `AT` 或 `WT` 不能有限分解到当前 `J` family 的指标格点，初始化直接报错；不能把未识别函数留给 IBP 层，也不能静默退回旧 h/H 分支。

### 3.3 IBP 层的唯一调用边界

IBP 不直接读取或重算 `P/Q/T/W`：

- time/radial 导数遇到状态 $n=i$ 时，只读取 `derivativeTerms` 中由 `AT[[i+1,*]]` 编译出的目标状态与指标移位；
- theta boundary shrink 只读取 `shrinkTerms` 中由 `WT` 编译出的系数和幂次；Wronskian 的方向约定固定为 $W=f_1f_2'-f_1'f_2$，现有 SK/端点符号在 shrink 层另行乘入；
- `P/Q/T/W` 仅保存在 provenance/diagnostic 数据中，不能在 seed 生成过程中形成第二条计算路径。

这样导数和缩并分别只有一个权威入口：`AT -> derivativeTerms -> IBP derivative`，`WT -> shrinkTerms -> IBP shrink`。

### 3.4 h/H presets

h/H 是上述输入的两个纯数据 presets。缺省 h 直接以 h 导数基底为原始和目标基底：

$$
P_h=(2\nu+1)/x,
\qquad Q_h=1,
\qquad T_h=I_2,
\qquad W_T=W_h=-e^{\pi\operatorname{Im}\nu}\frac{4i}{\pi}x^{-2\nu-1}.
$$

- H preset 同样取 `T -> IdentityMatrix[2]`，但输入裸 Hankel 的
$P_H=1/x$、$Q_H=1-\nu^2/x^2$、$W_H=-e^{\pi\operatorname{Im}\nu}4i/(\pi x)$，所以 `AT=A0`、`WT=WH`。
- 从 H 输入经非平凡 $T$ 得到 h 仍是受支持并已检查的等价用法：

$$
T_{H\to h}=x^{-\nu}\begin{pmatrix}1&0\\-\nu/x&1\end{pmatrix},
\qquad W_T=x^{-2\nu}W_H.
$$

011 已完成编译器和调用迁移。`011_function_system_check.wl` 覆盖缺省 h、裸 H、H 到 h 的非平凡 $T$、显式 `WT` 校验及非法输入；atomic massive 和 pure massive bubble 的 h/H 独立手推关系同时通过。

## 4. 通用 IBP 生成函数

对 masslessFull 的 `{b_e,n_{e,1},n_{e,2}}`，缩并只在 `n_{e,1}+n_{e,2}=1` 的 quotient 奇态发生：第一/第二端点系数按 canonical 符号为 `-2/+2`，缩并后 `pack_e={bS_e}` 且 `bS_e=b_e`。若两端点在当前或目标 sector 已 coincident，则两端点贡献必须成对相消，不再生成该 shrink 项。

### 4.1 设计原则

一个函数 `makeIBP[integrand, var]` 对任意被积函数（带符号指标 `a_v, b_e, n_{e,a}` 或具体数值指标）生成 IBP：

- `var = tau[v]`：对顶点 v 的共形时间求全微分
- `var = q[l]`：对圈动量 l 求散度 `q_l^mu d/d q_l^mu`

迁移后的函数内部读取每条线的当前状态和 `compiledFunctionSystem`：
- 完整线的 building-block 导数只调用 `derivativeTerms`
- theta boundary 缩并只调用 `shrinkTerms/WT`
- 缩并线不再调用特殊函数导数数据

### 4.2 时间 IBP 结构

`makeIBP[integrand, tau[v]]` 对顶点 v 生成：

```
Sum over 三项贡献:
(a) vertex power: -a_v * J[..., a_v - 1, ...]
(b) 每条连接 v 的线 e:
    若 e 完整:
      - 相位项: -I*P[v]*J  (外部能量)
      - building block 导数: ±shift_n * shift_b * J  (链式法则)
    若 e 缩并:
      - 仅相位项 (无 building block 导数)
(c) Heaviside 边界:
    若 e 完整 且 n_{e,start} + n_{e,end} == 1:
      - delta 缩并: J[..., {bS_e}, ...]  (线 e 变为缩并态)
      - 吸收 shrinkPow_e 到 a 指标
```

### 4.3 圈动量 IBP：链式法则分解与复合算符

#### 4.3.1 链式法则：从圈动量到 ξ-导数

每条内线 $e$ 的动量为 $Q_e = \sum_l c_{e,l}\, q_l + P_e$，模长 $\xi_e = |Q_e|$。被积函数通过以下途径依赖圈动量 $q_l$：

1. **传播子与 h-函数**：通过 $\xi_e$（分母幂次 $q_e^{-(b_e+b0_e)}$ 和 building block $h(\nu_e, n; \xi_e)$）
2. **ISP 坐标因子**：$(q_l \cdot q_m)^{n_{\text{isp}}}$ 或 $(q_l \cdot k_j)^{n_{\text{isp}}}$（不可约标量积，见 §4.3.4）。定义零点为 $0$；正幂是 numerator，用户显式给出的负幂表示该坐标的额外 denominator。
3. **指数相位**：$e^{i P_v \tau_v}$ 中的 $P_v$ 可能含圈动量（对 dS correlator 通常不含）

链式法则将 $\partial/\partial q_l^\mu$ 分解为：

$$\frac{\partial}{\partial q_l^\mu} = \sum_e \frac{\partial \xi_e}{\partial q_l^\mu} \frac{\partial}{\partial \xi_e} + \sum_{\text{isp}_j} \frac{\partial\, \text{isp}_j}{\partial q_l^\mu} \frac{\partial}{\partial\, \text{isp}_j} + (\text{相位项})$$

其中 $\partial \xi_e / \partial q_l^\mu = c_{e,l}\, Q_{e,\mu} / \xi_e$。

**实现**：`makeChainRule[topology]` 从拓扑输入自动生成此分解。输出为每个 $(l, e)$ 对的系数 $c_{e,l}\, Q_{e,\mu}/\xi_e$，以及 ISP 导数规则。

#### 4.3.2 复合 IBP 算符

IBP 恒等式来自全微分在维正规化下积分为零：

$$0 = \int \prod_l d^d q_l\; \frac{\partial}{\partial q_l^\mu} \left[ v^\mu \cdot F \right] = \int \prod_l d^d q_l\; \left[ (\partial \cdot v)\, F + v^\mu \frac{\partial F}{\partial q_l^\mu} \right]$$

**复合 IBP 算符**定义为 $\mathcal{O}_{l,v} = (\partial \cdot v) + v^\mu \partial/\partial q_l^\mu$，其中 $v^\mu$ 是可用动量的任意线性组合。

代入链式法则：

$$v^\mu \frac{\partial F}{\partial q_l^\mu} = \sum_e c_{e,l} \frac{v \cdot Q_e}{\xi_e} \frac{\partial F}{\partial \xi_e} + \sum_j (v \cdot \partial_{q_l}\, \text{isp}_j) \frac{\partial F}{\partial\, \text{isp}_j} + (\text{相位贡献})$$

每一项 $\partial/\partial \xi_e$ 作用在：
- 传播子幂次：$\partial_{\xi_e} [\xi_e^{-(b+b0)}] = -(b+b0)\, \xi_e^{-(b+b0)-1}$ → $b \to b+1$（同时 $1/\xi_e$ 来自链式法则再贡献一次 → 净效果 $b \to b+2$）
- 特殊函数：目标 `n=0,1` 状态的径向导数直接使用初始化时由 $A_T$ 编译的 `derivativeTerms`
- ISP 因子：$\partial_{\text{isp}} [\text{isp}^n] = n\, \text{isp}^{n-1}$ → $n_{\text{isp}} \to n_{\text{isp}}-1$。$n=0$ 时必须先精确化为零，不能留下由 package 自己产生的 $n=-1$ 项。

**实现**：`applyIBPOperator[l, v, J[indices]]` 将复合算符作用在指标表示的积分上，输出为 shifted-$J$ 的线性组合。

#### 4.3.3 完备 IBP 生成元集合（FIRE7 框架）

对 $L$ 圈积分，设 `loopExternalMomenta` 中有 $K$ 个独立外动量向量。这里的外动量向量只指实际进入内线动量偏移 $Q_e=\sum_l c_{e,l}q_l+P_e$、并会在 $Q_e^2$ 或 $q_l\cdot Q_e$ 中和圈动量发生标量积的三动量方向。只出现在无圈 line/phase 中的独立模长由 `independentExternalMomenta` 声明，不计入 $K$；与任何动量向量无关的独立能量参数可记为 `ke[i]`。完备的 IBP 生成元为：

$$\boxed{\mathcal{O}_{l,v} = \frac{\partial}{\partial q_l^\mu} \cdot v^\mu, \quad l \in \{1,\ldots,L\}, \quad v^\mu \in \{q_1^\mu, \ldots, q_L^\mu, k_1^\mu, \ldots, k_K^\mu\}}$$

总数 $N_{\text{IBP}} = L(L + K)$，分解为：

| 类型 | 生成元 | 数量 | 作用 |
|------|--------|------|------|
| 对角（scale） | $\partial_{q_l} \cdot q_l$ | $L$ | 每圈标度 IBP |
| 交叉（cross） | $\partial_{q_l} \cdot q_m\ (l \neq m)$ | $L(L-1)$ | 耦合不同圈动量 |
| 外动量（special） | $\partial_{q_l} \cdot k_j$ | $LK$ | 连接外动量 |

**交叉 IBP 的必要性**：$L \geq 2$ 时，仅对角 IBP 不足以将所有积分约化到 master integrals。交叉 IBP $\partial_{q_l} \cdot q_m$ 提供不同圈动量之间的关系，是完备约化系统所必需的。

**验证**：独立 loop-scalar-products 数目 $N_{\text{sp}} = L(L+1)/2 + L K$（$K$ 为 `loopExternalMomenta` 的独立外动量基个数）与需要闭合的 $z/ISP$ 坐标维度匹配。这里不把 `independentExternalMomenta` 的模长或独立 `ke[i]` 算入 loop 标量积空间。

#### 4.3.4 ISP（不可约标量积）处理

**定义**：给定拓扑的传播子 $\{\xi_e^2\}$，所有标量积 $\{q_l \cdot q_m,\, q_l \cdot k_j\}$ 中不能表示为 $\xi_e^2$ 线性组合的，称为 ISP。

**函数族扩展**：积分家族增加 ISP 指标：

$$J[\{a_v\}, \{\text{pack}_e\}, \{n_{\text{isp}_j}\}]$$

ISP 指标的定义零点固定为 $0$。物理 ISP numerator 区域为 $n_{\text{isp}_j}\geq0$；接口仍接受用户显式给出的任意整数范围，$n_{\text{isp}_j}<0$ 表示该坐标的额外 denominator，不触发输入阻断。package 自动从 target envelope 反推 seed 点域时不得把 ISP 下界降到用户给定下界以下。

**当前用户输入**：

```mathematica
(* 用户可任意命名 loop/external momenta；标量积统一写 sp[p,r]。 *)
loopMomenta = {l3, k321};
loopExternalMomenta = {wdnmd};
independentExternalMomenta = {kE1};

(* 外腿指数参数直接写在对应顶点上；不是顶点自身能量。 *)
vertices = {
  <|"id" -> 1, "vertexType" -> "+", "externalLegEnergy" -> ke[1]|>,
  <|"id" -> 2, "vertexType" -> "+", "externalLegEnergy" -> Sqrt[sp[wdnmd,wdnmd]]|>,
  <|"id" -> 3, "vertexType" -> "-", "externalLegEnergy" -> Sqrt[sp[kE1,kE1]]|>
};

(* ISP 定义：{名称, sp 标量积表达式, 指标范围} *)
ispData = {
  {rhoA, sp[l3, wdnmd + l3], {0, 1}},
  {rhoB, sp[k321, wdnmd], {0, 1}}
};
```

`sp` 表示 scalar product，并设置为 `Orderless`，所以 `sp[p,r]` 与 `sp[r,p]` 自动相同。loop/ISP 中的 `p,r` 必须是 `loopMomenta/loopExternalMomenta` 的线性组合；程序验证该列表恰好覆盖 shift-invariant routing/ISP 需求，不自动选基。loop 外动量的完整 Gram 基缺省输出为 `ssij^2`；自定义坐标只通过统一 `kinematicRules` 或 `KinematicRules` 入口提供。无圈 line/phase 的实际模长由用户在 `independentExternalMomenta` 中逐项声明，公开变量只取各表达式的模长，不展开或输出它们之间的点积。`kE1`、`kE2`、`kE1+kE2` 同时出现时仍是三个独立模长；额外声明 `2 kE1` 会构成过完备 warning。每个顶点的 `externalLegEnergy` 可引用这些模长或独立标量；与任何已声明动量无关的标量仍可写成 `ke[i]`。

**完备性验证**：`verifyISP[topology, ispData]` 检查：
1. 所有标量积 $\{q_l \cdot q_m,\, q_l \cdot k_j\}$ 均可表示为 $\{\xi_e^2\}$ 和 $\{\text{isp}_j\}$ 的线性组合
2. ISP 之间线性无关；当前 ISP 表达式可为 `sp[p,r]` 或其线性组合坐标，不要求直接是某个内部编号变量
3. `zExprs` 与 ISP 坐标总数等于独立标量积数量，即 $\#z_e + \#\text{ISP}=N_{\text{sp}}$
4. line momentum 与 `sp[p,r]` 参数必须是声明动量基的线性组合；非线性输入会触发 `nonLinearLineMomenta` 或 `nonLinearScalarProductArguments`
5. 数量闭合后必须能实际反解出 `repSP2Z`；重复或退化传播子动量会触发 `scalarProductCoordinateSolveFailed`
6. 数值规则必须按工作流分类。符号 DE 工作流要求 derivative variables、对应内部平方原子及任何含它们的 RHS 从 seed 到 import 都保持符号，只数值化 `dim/epsilon`、`nu`、zero-point 和 normalization 等非 DE 系数参数。数值 linear workflow 在 `DSLinear[...,CoefficientRules->rules]` 统一持有精确规则；formal DE 则先冻结解析导数与 target closure，再在 `postDerivative` 阶段代入固定非奇异精确有理点。topology 和 `DSSeeds` 不持有第二套数值规则。

这里验证的是用户初始化给出的 `z/ISP` 坐标系是否闭合。程序不把 dS 图默认理解为 overcomplete propagator family，也不自动挑选独立传播子子集；若计数不闭合、ISP 不足/过多、传播子动量退化或特殊数值外动量导致不可反解，validation report 直接报错，用户应修正传播子动量或 ISP 输入。

验证通过后，才进入 IBP 生成步骤。

#### 4.3.5 分 Sector IBP 生成流程

```
1. 读取拓扑 + ISP 配置
2. 验证 ISP 完备性
3. 构造 IBP 生成元集合 {O_{l,v}}（L(L+K) 个，K 为 `loopExternalMomenta` 中独立外动量向量个数）
4. 对每个 sector（由缩并线集合标记）：
   a. 构造该 sector 的指标盒子 {a_v, b_e, n_{e,a}, n_isp}
   b. 枚举种子（撒点范围控制）
   c. 对每个连续种子，先枚举该 sector 的离散 source representatives：massive 的两个端点各取 `0/1`；masslessFull 只取 `n2->0` 的 `00/10`，同时记录 raw 四态审计；masslessCross/shrunk 没有离散遍历。
   d. 对每个离散态和每个生成元 O_{l,v}：
      - 应用链式法则 → z/ξ-导数 + ISP-导数 + 相位项
      - 转化为指标移位算符，包含传播子幂次项与 building-block 导数项
      - 立即应用 EOM 递推，递归消去所有
>=2`
      - 对导数临时产生的 `01/11` 应用 massless 双端点 quotient，把结果保持在 `{b_e,n_{e,1},n_{e,2}}` 三槽包内且 `n2=0`
      - 扫描结果，若仍有
=2` 或未识别 pack，直接报错而不是继续导出
   e. 保存 EOM-canonical IBP 方程，命名区分 sector 与生成元类型
5. 输出：按 sector 分组的 IBP seed 文件或 MMA seed batch。后续 linear/Kira 只能读取这些 canonical seed 转成的 linear-system。
```

022 不从 topology 读取 `seedRanges/generatorSeedRanges`。统一或逐指标最终关系包络只传给 `DSGenerateIBP`；它按每组实际 shifts 反推 seed 点域，并逐组保存变量顺序、value lists、配置范围、规则数、方程数和来源。

**命名规则**（建议）：`IBP_sector_<shrunkLines>_seed_<seedIndex>.dat`

例如：`IBP_sector_none_seed_001.dat`（top sector），`IBP_sector_e3_seed_012.dat`（线 3 缩并）。

### 4.3.6 独立变量微分方程 seed

微分方程阶段需要生成 $\partial_x J$。本 package 把独立变量分成三类：

1. 顶点外腿能量参数，例如 `ke[i]`。这些变量只进入对应 vertex 的 `externalLegEnergy` 指数相位。
2. loop 外动量 Gram 根号坐标 `ssij` 或显式旧平方坐标；它们复用 `kk/sij` 原子导数。
3. 实际出现的无圈动量模长 `sEe`。它若绑定 line momentum，就对该线的分母和 building block 做径向导数；同时照常微分顶点相位和显式系数，但不产生 loop momentum generator。

对顶点能量 $y$，求导只作用在顶点相位：

$$
\partial_y J
=\sum_v\left[-\eta_v\,\partial_y E_v\right]J[a_v\to a_v+1],
\qquad
\eta_v=\begin{cases}-i,&v=+,\\ +i,&v=-.\end{cases}
$$

外不变量导数不能假定唯一。令

$$
D_{ij}=k_i\cdot{\partial\over\partial k_j},
\qquad
D_{ij}(k_m\cdot k_n)
=\delta_{jm}(k_i\cdot k_n)+\delta_{jn}(k_i\cdot k_m).
$$

在外不变量坐标 $\{x_b\}$ 的约束面上求

$$
{\partial\over\partial x_a}
=\sum_{ij}c^{(a)}_{ij}D_{ij},
\qquad
\sum_{ij}c^{(a)}_{ij}D_{ij}x_b=\delta_{ab}.
$$

完整 $K^2$ 个 $D_{ij}$ 一般存在零空间；系数解不是唯一的。011 默认选上三角 external-vector basis 作为 canonical 解，同时保留完整 decomposition 报告，包括线性方程矩阵、系数、残差、`nullity` 和 `nonUniqueQ`。若后续某个物理通道需要特定切向选择，应通过 operator basis 覆盖，而不是改写求导核心。

当前接口：

```mathematica
makeExternalInvariantDerivativeDecomposition[topo, var]
applyExternalVectorDerivativeSeed[topo, int, gen]
applyExternalInvariantVariableDerivativeSeed[topo, int, var]
applyIndependentVariableDerivativeSeed[topo, int, var]
independentVariableDerivativeVariables[topo]
makeIndependentVariableDerivativeGenerators[topo]
makeIndependentVariableDerivativeSeedBatch[topo, int]
ds[expr, sij, contextOrTopo]
ds[expr, sij]
```

`applyIndependentVariableDerivativeSeed` 自动判断 `var` 属于用户选定动力学坐标、内部平方 Gram 原子、实际无圈模长还是独立顶点能量。用户混合坐标统一按完整 Jacobian 对所有基础原子求和，不能因变量名同时命中某个简单根号坐标而提前返回。loop Gram 原子分支会把每个 $D_{ij}$ 作用到传播子、massive/massless building block、ISP/numerator 和相应顶点能量；无圈模长分支执行绑定线径向导数及显式相位导数。

`DSKinematics[input]` 给出完整 loop Gram 原子、实际无圈模长独立基的缺省规则、从属模长 binding 和可复制的 `selectionTemplate`；`DSKinematics[input,rules]` 审计候选，`DSInit[...,KinematicRules->rules]` 才重选并重新初始化。审计同时检查规则左端对基础原子的覆盖秩和基础原子对用户参数的 Jacobian 秩，并按 `baseCoordinateOrder` 返回零空间方向表达式。欠秩时拒绝初始化；超完备时返回冗余关系/约束，允许 symbolic IBP 初始化但禁用冗余坐标 `ds` 与无唯一逆映射的 `rep2innerform`。过完备 loop 声明的原列表只用于审计和展示，核心 `nK`/Gram/`dqk`/ISP 使用 affine quotient 的 `effectiveLoopExternalMomenta` 必要基。一般满秩混合坐标先逐条展开规则右端再提取原子参数；即使没有简单逆映射，`ds` 仍按完整 Jacobian 工作。从属 line/phase/显式系数统一对 binding 表达式继续使用同一链式法则。

批量入口枚举 `externalInvariantVariables` 与独立顶点能量参数的并集，并返回每个变量的 decomposition、canonical derivative、失败状态和 forbidden-`n` 数据；它不替用户发明新的物理变量。

表达式级公开入口 `ds[expr,sij]` 只接受初始化后的外部变量名。它先把 `J` 惰性化并对显式系数求 `D[expr,sij]`，再逐个加入积分导数，严格实现
$$
\partial_s\sum_r c_r(s)J_r=\sum_r c'_r(s)J_r+\sum_r c_r(s)\partial_sJ_r.
$$
合并结果统一进入 EOM、symmetry 与 canonical；`kk[i,j]` 仅是内部坐标，不作为 `ds` 的用户变量。

对任意非线性外不变量函数 $F(x)$，external-vector 算符必须按 $D_{ij}F=\sum_a(\partial F/\partial x_a)D_{ij}x_a$ 执行链式法则。直接做 `x_a -> D_{ij}x_a` 的替换只对线性 $F$ 成立，012 不再采用该错误简化。

massive building block 的 external-vector/外不变量导数必须与 qIBP、tIBP 使用同一份 line-local `compiledFunctionSystem`：普通导数只读取最终 `AT -> derivativeTerms`。`WT=Det[T] W -> shrinkTerms` 只处理 time-IBP 的 theta coincidence/Wronskian shrink；动力学量导数不产生 theta shrink，因此不读取 `WT`。

### 4.4 标量积变量与 $z=\xi^2$ 线性变换

#### 4.4.1 $z$ 变量定义

对每条内线 $e$，定义
$$z_e \equiv \xi_e^2 = Q_e \cdot Q_e$$
作为基本变量，而非 $\xi_e$ 本身。这里 $Q_e = \sum_l c_{e,l}\, q_l + P_e$ 为线 $e$ 的总动量（圈动量线性组合 + 外动量偏移），$c_{e,l}$ 为拓扑关联矩阵元素。

**选择 $z_e$ 而非 $\xi_e$ 的理由**：
- 传播子 $\xi_e^{-(b_e+b0_e)} = z_e^{-(b_e+b0_e)/2}$，$z_e$ 的整数幂次移位 $\Delta z_e = -1$ 对应 $b_e$ 移位 $+2$，跳过奇偶性混合
- 所有标量积 $q_l \cdot Q_e$ 和 $Q_e \cdot Q_{e'}$ 均为 $z_e$ 的**线性**组合（无平方根），使 IBP 系数保持线性结构
- 链式法则 $\partial/\partial q_l^\mu$ 通过 $z_e$ 展开时不出现 $1/\xi_e$ 奇异性（见 §4.4.4）

#### 4.4.2 标量积变量约定

独立标量积分三类，其中 $K=\#\texttt{loopExternalMomenta}$ 只统计进入 loop scalar-product 空间的外部三动量向量：

| 类型 | 记号 | 数量 |
|------|------|------|
| 圈-圈标量积 | $q_l \cdot q_m$（$l \leq m$） | $L(L+1)/2$ |
| 圈-外动量标量积 | $q_l \cdot k_j$ | $LK$ |
| 外动量-外动量标量积 | $k_i \cdot k_j \to ss_{ij}^{2}$ 或用户自定义坐标表达式 | 常数，不计入 loop 标量积变量 |

独立 loop-scalar-products 总数 $N_{\text{sp}} = L(L+1)/2 + LK$。顶点相位中的 $|k|$ 或 $|k_a|+|k_b|$ 是能量参数，不是这个标量积向量的分量。

外动量-外动量标量积记为符号常数，不保持矢量点积形式。016 缺省按 `loopExternalMomenta` 的位置生成 `sp[k_i,k_j]->ssij^2`；用户通过 `KinematicRules` 重定义。对 $d=3$ bubble 例子（$L=1$，$E=2$，1 独立外动量 $k \equiv k_1$）：
$$N_{\text{sp}} = 1 + 1 = 2, \quad \text{独立标量积：} q_1^2,\; q_1 \cdot k, \quad \text{外部不变量：} k^2 \equiv ss_{11}^2\ \text{(或用户自定义名)}$$

#### 4.4.3 $z$ 与标量积的线性变换

每条内线的 $z_e$ 展开为标量积的线性组合加外部不变量：
$$z_e = Q_e^2 = \left(\sum_l c_{e,l}\, q_l + P_e\right)^2 = \sum_l c_{e,l}^2\, q_l^2 + 2\sum_{l<m} c_{e,l}\, c_{e,m}\, q_l \cdot q_m + 2\sum_l c_{e,l}\, q_l \cdot P_e + P_e^2$$

其中 $P_e^2$ 和 $q_l \cdot P_e$（$P_e$ 为外动量线性组合）均可进一步展开为 $\{q_l \cdot q_m,\; q_l \cdot k_j\}$ 加外动量不变量（缺省 $ss_{ij}^{2}$ 或用户自定义坐标表达式）的线性组合。

定义独立标量积向量 $\mathbf{s} = (s_1, \ldots, s_{N_{\text{sp}}})^T$（包含所有 $q_l \cdot q_m$ 和 $q_l \cdot k_j$），则：
$$\boxed{z_e = \sum_i M_{ei}\, s_i + c_e \quad \Longleftrightarrow \quad \mathbf{z} = M \cdot \mathbf{s} + \mathbf{c}}$$

其中：
- $M$ 为 $E_{\text{prop}} \times N_{\text{sp}}$ 系数矩阵（$E_{\text{prop}}$ 为内线数/传播子数）
- $c_e$ 仅含外动量不变量名（与圈动量无关的常数项）
- 当 $E_{\text{prop}} = N_{\text{sp}}$（无 ISP 情形）时，$M$ 为方阵

**逆变换**：
$$\mathbf{s} = M^{-1} \cdot (\mathbf{z} - \mathbf{c})$$

这给出所有标量积 $q_l \cdot q_m$ 和 $q_l \cdot k_j$ 用 $z_e$ 和外部不变量名表示的替换规则。在代码中，`makeLinearRep[topology]` 自动构造 $M$、$\mathbf{c}$ 并计算逆，输出替换规则 `repScalarProduct`：
```mathematica
repScalarProduct = {
  q1 . q1 -> ...,    (* z_1, z_2, ..., 外部不变量名的线性组合 *)
  q1 . q2 -> ...,
  q1 . k1 -> ...,
  ...
};
```

#### 4.4.4 在动量 IBP 中的应用

**链式法则的 $z$ 形式**：由 $z_e = Q_e \cdot Q_e$，有 $\partial z_e / \partial q_l^\mu = 2\, c_{e,l}\, Q_{e,\mu}$，故
$$v^\mu \frac{\partial F}{\partial q_l^\mu} = \sum_e 2\, c_{e,l}\, (v \cdot Q_e)\, \frac{\partial F}{\partial z_e} + (\text{ISP 导数项}) + (\text{相位项})$$

**关键优势**：系数中仅出现 $v \cdot Q_e$（$z_e$ 的线性组合），**无 $1/\xi_e$ 因子**。与 §4.3.2 的 $\xi$ 形式对比：
- $\xi$ 形式：系数为 $c_{e,l}\, (v \cdot Q_e)/\xi_e$，含 $1/\xi_e$；$\partial/\partial \xi_e$ 使 $b_e \to b_e + 1$，与 $1/\xi_e$ 合在一起净效果 $b_e \to b_e + 2$
- $z$ 形式：系数为 $2\, c_{e,l}\, (v \cdot Q_e)$，纯 $z_e$ 线性组合；$\partial/\partial z_e$ 直接使 $b_e \to b_e + 2$

两种形式给出相同的净指标移位，但 $z$ 形式一步到位，无需追踪中间的 $1/\xi_e$。

**指标移位规则**：$\partial/\partial z_e$ 作用在 $z_e^{-(b_e+b0_e)/2}$ 上：
$$\frac{\partial}{\partial z_e} z_e^{-(b_e+b0_e)/2} = -\frac{b_e+b0_e}{2}\, z_e^{-(b_e+b0_e)/2 - 1}$$
对应 $b_e \to b_e + 2$（即 $z_e$ 幂次 $-1$ → $b_e$ 移位 $+2$）。

一般地，$z_e^n$ 对应 $b_e$ 移位 $-2n$（因为物理幂次 $\xi_e^{-(b+b0)} = z_e^{-(b+b0)/2}$，$z_e$ 每降 1 次幂，$b+b0$ 增加 2）。

**IBP 系数的线性结构**：生成元 $\mathcal{O}_{l,v}$ 的系数全部为 $z_e$ 和外部不变量名的线性组合：

| 生成元 | $v \cdot Q_e$ | 系数结构 |
|--------|--------------|---------|
| 对角 $\partial_{q_l} \cdot q_l$ | $q_l \cdot Q_e$ | $z_e$ 线性组合 $+$ 外部不变量名 |
| 交叉 $\partial_{q_l} \cdot q_m$ | $q_m \cdot Q_e$ | $z_e$ 线性组合 $+$ 外部不变量名 |
| 外动量 $\partial_{q_l} \cdot k_j$ | $k_j \cdot Q_e$ | 纯外部不变量名（与 $z_e$ 无关） |
| 散度 $(\partial \cdot v)$ | — | 常数 $d$（对角）或 $0$（交叉/外动量） |

#### 4.4.5 Bubble 例子

$d=3$ bubble 拓扑：2 顶点，2 内线，$L=1$，$E=2$。内线动量：
$$Q_1 = q_1, \quad Q_2 = q_1 - k$$

**$z$ 变量**：
$$z_1 = q_1^2, \quad z_2 = (q_1 - k)^2 = q_1^2 - 2\, q_1 \cdot k + s_{11}$$

**线性变换矩阵**（$\mathbf{s} = (q_1^2,\; q_1 \cdot k)^T$，$\mathbf{c} = (0,\; s_{11})^T$）：
$$\begin{pmatrix} z_1 \\ z_2 \end{pmatrix} = \underbrace{\begin{pmatrix} 1 & 0 \\ 1 & -2 \end{pmatrix}}_{M} \begin{pmatrix} q_1^2 \\ q_1 \cdot k \end{pmatrix} + \begin{pmatrix} 0 \\ s_{11} \end{pmatrix}$$

**逆变换**（$M^{-1} = \begin{pmatrix} 1 & 0 \\ 1/2 & -1/2 \end{pmatrix}$）：
$$q_1^2 = z_1, \quad q_1 \cdot k = \frac{z_1 + s_{11} - z_2}{2}$$

**$v \cdot Q_e$ 系数**（生成元 $\partial_{q_1} \cdot v$ 的 IBP 系数）：

| $v$ | $v \cdot Q_1 = v \cdot q_1$ | $v \cdot Q_2 = v \cdot (q_1 - k)$ |
|-----|---------------------------|----------------------------------|
| $q_1$（对角） | $q_1^2 = z_1$ | $q_1^2 - q_1 \cdot k = \dfrac{z_1 + z_2 - s_{11}}{2}$ |
| $k$（外动量） | $k \cdot q_1 = \dfrac{z_1 + s_{11} - z_2}{2}$ | $k \cdot q_1 - s_{11} = \dfrac{z_1 - z_2 - s_{11}}{2}$ |

所有系数均为 $z_e$ 和外部不变量名的线性组合，验证了 §4.4.4 的一般结论。

**IBP 方程示例**（对角生成元 $\mathcal{O}_{1,q_1} = \partial_{q_1} \cdot q_1$，忽略 ISP 和相位项）：
$$0 = \int d^d q_1\; \frac{\partial}{\partial q_1^\mu}\left[q_1^\mu \cdot F\right] = d \cdot F + \sum_e 2\, (q_1 \cdot Q_e)\, \frac{\partial F}{\partial z_e}$$

代入 $q_1 \cdot Q_1 = z_1$，$q_1 \cdot Q_2 = (z_1 + z_2 - s_{11})/2$，以及 $\partial/\partial z_e$ 的指标移位效果（$b_e \to b_e + 2$），得到 $J$ 的线性关系式，系数为 $z_e$ 和 $s_{11}$ 的多项式。

## 5. 拓扑输入格式

```mathematica
caseInput = <|
  "name" -> "exampleFamily",
  "vertices" -> {
    <|"id" -> 1, "vertexType" -> "+", "externalLegEnergy" -> E1|>,
    <|"id" -> 2, "vertexType" -> "-", "externalLegEnergy" -> E2|>
  },
  "lines" -> {
    <|"id" -> 1, "massType" -> "massive", "endpoints" -> {1,2},
      "momentum" -> q1, "nu" -> nu1|>,
    <|"id" -> 2, "massType" -> "massless", "endpoints" -> {1,2},
      "momentum" -> q1-k1|>
  },
  "extLegs" -> {{B,1,p1},{B,2,p2}},
  "loopMomenta" -> {q1},
  "loopExternalMomenta" -> {k1},
  "independentExternalMomenta" -> {p1,p2},
  "ibpMode" -> "full",
  "ispData" -> {},
  "zeroPointRules" -> {
    a0[1]->alpha1,a0[2]->alpha2,b0[1]->beta1,b0[2]->beta2
  },
  "symmetryRules" -> {}
|>;
```

每个顶点只输入 `id/vertexType/externalLegEnergy`。每条线输入 `id/massType/endpoints/momentum`；massive 线另需 `nu`，并可选唯一 `functionSystem`。SK line class、pack/state、contact zero point、representative map 和 shrink prefactor 全部由端点顶点及 contraction 状态内部派生。seed 包络属于 `DSGenerateIBP`，数值规则属于 `DSLinear` 或 formal Kira 阶段，Kira ordering 属于 plan/export；它们都不写入 topology。

## 6. 脚本结构

```
(* ::Package:: *)

(* ::Chapter:: *) Initialization & Definitions
  (* ::Section:: *) Environment Setup
  (* ::Section:: *) Topology Input           — vertices, lines, momentum declarations
  (* ::Section:: *) Topology Parser          — 关联矩阵, 指标位置, functionSystem 编译
  (* ::Section:: *) Index Manipulation       — shiftA, shiftB, shiftN, shiftBS
  (* ::Section:: *) Building Block Defaults  — bbDefault["h"/"H"] 内置定义
  (* ::Section:: *) EOM Rules Generator      — 从 functionSystem 自动构造 id[]
  (* ::Section:: *) IBP Generator            — makeIBP[integrand, tau[v]/q[l]]
  (* ::Section:: *) Seed Generation          — 连续种子 × 离散 n=0/1, 施加 IBP, 立即 EOM canonical
  (* ::Section:: *) Parameter Substitution   — repvar, reppara2N
  (* ::Section:: *) Export                   — 仅对 EOM/time-IBP 完备后的 canonical 方程开放

(* ::Chapter:: *) Check & Validation
  (* ::Section:: *) Compare with Reference
```

## 7. 当前主线与工作流

当前权威实现是模块化 `versions/022_dSIBP/`，标准加载入口为把该目录加入 `$Path` 后调用 `Needs["dSIBP`"]`。当前正式单文件入口是 `independent-benchmark/package/package_022.0.wl`；验收后工作树只保留 022，全部更早源码版本从 Git 历史追溯。022 随源码提供 `Examples/`，正式交付同步保留同一组 examples。

独立 benchmark 的程序交付位于 `independent-benchmark/package/`；当前只保留 `package_022.0.wl/pdf`、同版本更新说明和少量不含 expected 的应用 examples。独立推导阶段不得读取该目录；结果冻结后才用于单向 package 对照。更新交付时按 `package_<版本号>` 命名，并删除旧版程序、旧版手册和无版本名副本。

正式交付采用候选先行门禁：构建器通过 `DSIBP_BUILD_OUTPUT` 把候选单文件写入 `test/results_test/`，正式检查通过 `DSIBP_PACKAGE_FILE`（phase 2 另用 `DSIBP_PDF_FILE`）显式加载候选。只有候选专项、独立单文件检查和受影响 phase 全部通过后，才用同一候选字节覆盖 `independent-benchmark/package/`，随后在正式路径复验并清理候选。未设置这些环境变量时保留原有正式构建/模块检查合同。

主线按照以下顺序工作：

1. `makeTopologyData` 读取 topology、动量基、传播子、ISP、零点和数值规则，并缓存 index maps 与 sector metadata。
2. topology validation 检查动量线性、`z/ISP` 坐标闭合、离散态配置和数值规则覆盖；不按 topology、sector、状态或预计方程数量拒绝合法输入。
3. `makeCanonicalSeedBatch` 按 sector 枚举连续 seed 与完整离散 `n=0/1` 状态，生成所有 qIBP/tIBP；massive 的 `n>=2` 立即 EOM，massless 直接使用有方向的单 `n` 求导与 theta-boundary 规则。
4. massive 与 masslessFull theta boundary 按共同顶点对生成 odd-subset contact，并自动派生 contact 可达 shrink sectors；每个 sector 使用 compact `aList`，原顶点与 compact slot 的对应关系保存在 `sectorMetadataList`。
5. `writeSeedBatchMMA` 保存解析 canonical seed。seed 文件不直接供 Kira 或其它线性后端读取。
6. `makeLinearSystemData` 把 seed 转成后端中立的 `linearData`；`makeSampledLinearSystemData` 可在这一层代入小规模数值规则。
7. 用户可查看并重排全 sector 的 `integralList`，随后选择 Kira serializer 或未来的其它后端 serializer。
8. `makeIBPWorkflowData` 串联上述 gate；`makeIBPReadinessReport` 只返回分阶段 readiness，不执行任何 reduction。

### 7.1 已完成能力

- topology-driven 的任意圈数、任意 massive/massless 混合输入框架；bubble 只是输入例子，不在生成器中硬编码。
- 用户端 `sp[p,r]` 标量积接口、默认或自定义外部不变量名、独立 `ke[i]` 顶点能量参数。
- `massiveFull`、`massiveCross`、`masslessFull`、`masslessCross` 和 theta-boundary shrunk line 的统一 pack 分派。
- 完整的 $L(L+K)$ 个 momentum generators，以及每个 active vertex 的 time generator。
- massive/massless building-block 导数、massless 有序端点 canonical、massive coincidence canonical、共同-theta odd-subset contact 和即时 EOM。
- 独立变量求导 seed：`ke[i]` 只微分顶点 e 指数；外不变量先在约束坐标上分解为外动量矢量导数 `k_i·∂/∂k_j`，再复用传播子/ISP/building-block 求导。
- 自动 massive/massless shrink subsector、compact `aList` 和全 sector metadata。
- 解析 seed 保存、后端中立线性系统、数值/撒点层、全 sector 积分排序与基础 Kira 文件转换。
- `dtau/dqq/dqk`、`rep2innerform/rep2outform/rep2Integrand` 公开 API；支持显式 topology，或通过 `setIBPTopologyContext` 使用短签名。
- `compileFunctionSystem`、line-local `compiledFunctionSystem`、h/H presets，以及 `AT -> derivativeTerms`、`WT -> shrinkTerms` 的唯一 IBP 调用边界。

### 7.2 `linearData` 与 serializer 的边界

`linearData` 是后端中立的 Association，核心字段包括：

- `linearEquations`：按积分编号表示的线性关系；
- `integralList` / `integralRules`：全 sector 统一排序后的积分表和映射；
- `sectorMetadataList`：每个 sector 的拓扑、指标槽和缩并信息；
- coefficient、ordering、coverage 与 readiness reports。

serializer 不重新推导 IBP，也不重新应用 EOM。它只负责把 `linearData` 转为某个后端的语法、编号和文件布局，并做该后端特有的输入校验。当前已有 Kira serializer，可写 `userSystem/ibp.kira`、`list`、`jobs.yaml`、积分映射和 metadata。未来若接 Rational Tracer，需要新增相应 serializer，但 seed 与 linear-system 主线无需重写。

package 默认不安装、配置或运行 Kira/Rational Tracer，也不保存本机可执行文件路径。018 可通过 `DSKiraImport` 导入并验证用户在 package 外生成的完整 reduction/master 结果，再交给 `DSDE` 和 `DSScaleCheck`；缺文件、context capability、artifact identity 或来源映射不一致时拒绝继续。

## 8. 当前未实现与下一步
本节只保留长期能力缺口，不表示当前执行顺序。当前正在做什么、哪些检查尚未通过以及下一位接手者的第一步，以根目录 `研究计划与研究进度.md` 为准。

### 8.1 长期优先项

1. 在现有十个独立 benchmark family 之外继续加入新 topology，并保持先手推、冻结 expected、后调用 package 的来源隔离。
2. 为高圈输入增加不改变用户指定集合的 streaming/chunked seed 生成和更明确的标量积求解规模报告；018 当前完整生成有限用户范围，不设数量早停。

### 8.2 可选优化

- 用户输入的 `symmetryRules` 与函数化 `symmetry[expr_,topo_]` 已实现；用户必须先为每个等价类选定唯一 canonical representative，只写从非代表到代表的单向规则。018 沿用原始 self-loop tadpole 的 massive 端点态交换、massless 反对称态归零及受独占-loop 门禁保护的 odd-ISP 归零。未来可低优先级提供 helper，按缺省复杂度和稳定字典序把未定向等价关系自动定向；一般图 automorphism/参数对称性检测仍不实现。
- 自动从重复或退化的传播子输入中选择独立 basis。当前要求用户直接给出可反解的传播子 + ISP family。
- Rational Tracer 或其它后端 serializer。

这些优化不改变当前主线的物理 convention。特别是纯 massless 与 mixed case 都固定使用双 theta 合并路线，不提供单 theta 路线开关。

## 9. 验证范围与性能红线

014 的历史独立重检覆盖十个 benchmark family 的 24 组固定 sign/energy 运行和 3018 条方程；ISP 366/366 相等且非零差值 0，H-to-h/direct-h 178/178、bare-H 178/178、compiled `AT/WT/shrinkTerms` 16/16、tree 22/22、general-`ds` 独立 expected 16/16、工程门禁 19/19。文档修正前 contract 为 46/47，唯一失败是当时手册把 `DSSeeds` 缺省写成 `"all"`。当时使用的 `DiscreteMode`、`quickCheck -> "sample"` 与 `fullDiscrete`/`bounded` 是 014 历史合同，016 起已废弃；018 的公开 `DSSeeds` 完整枚举用户范围与全部适用离散态，不提供抽样模式或数量上限。上述数字只作为旧版本冻结证据，不是当前 018 独立 benchmark 结论。

这些数字是检查断言数，不等于独立手推公式数。当前结论是“生成器未硬编码 bubble，并通过代表性 topology 与微分方程变量求导回归”，不是“已对所有拓扑给出数学穷尽证明”。

- package 完整生成用户显式选择的有限 seed 集合，不自行扩大范围，也不因预计规模缩小、抽样或拒绝该集合。
- 用户可为资源管理主动选择较小 seed 范围；是否数值化非微分系数由工作流合同决定，package 不擅自改变范围或运动学变量。
- 不以大符号 `MatrixRank` 作为合法输入的前置阻断；全部适用 massive 离散态和 contact-reachable sectors 必须完整遍历。
- 所有输出 seed 必须确认 massive 无 `n>=2`；massless 只能是 `n=0/1`，且不能遗漏 `n=1` 的 theta boundary。
- package 自身不运行 Kira；真实 reduction 必须由用户在外部完成，014 只导入、验证并消费完整结果。

## 10. 约定总结

| 项目 | 当前约定 |
|------|----------|
| 主线脚本 | 模块化 `versions/022_dSIBP/`；正式单文件按 022.0 candidate-first 发布 |
| 积分 Head | full：`J[aList,linePacks,ispList]`；timeOnly：`J[sectorKey,timeShifts,stateBits]` |
| cycle line pack | full massive/massless 均为 `{b_e,n_{e1},n_{e2}}`，shrunk 为 `{bS_e}`；root line 位置永久保留 |
| bridge/fixed line pack | full 为 `{"F",n_{e1},n_{e2}}`，shrunk 为 `{"F"}`；物理幂属于结构化 sector prefactor |
| `timeOnly` 状态 | `sectorKey` 唯一标 sector；`stateBits` 是 (n_i) 离散态，massless quotient 整边共享一位 |
| Hankel 离散态 | seed 层枚举 `n=0,1`，`n>=2` 立即 EOM |
| Sub-sector | 同一 Head `J`，compact `aList` + sector metadata |
| 数值规则 | 解析 seed 后，在 sampled/linear/backend 层应用 |
| 后端输入 | 只接收 `linearData`，不直接接收 seed |
| 后端职责 | 导出输入、导入并验证完整外部结果；不安装、不配置、不运行 reduction |

## 11. 原子化公开接口

020 在 `dSIBP`` context 中公开以下公式级接口，并由 `DSInit` 建立 family context。full 与 timeOnly 均使用三参数 Head `J`，但参数 schema 由 context 初始化后固定且不允许混用；底层调用可显式传入 `topo`，也可使用当前已注册 context 的短签名。

### 11.1 指定生成元作用

- `dtau[i, expr, contextOrTopo]` / `dtau[i, expr]`：对 active vertex `tau[i]` 生成时间全微分关系。
- `dqq[i, j, expr, contextOrTopo]` / `dqq[i, j, expr]`：生成 `d/dq_i . q_j` 的复合圈动量 IBP。
- `dqk[i, j, expr, contextOrTopo]` / `dqk[i, j, expr]`：生成 `d/dq_i . k_j` 的复合圈动量 IBP。

所有原子接口的显式第三参数统一接受 `DSInit` 返回的完整 context 或其 parsed topology；resolver 必须先识别并解包 context，不能把它当作原始 topology case 再次解析。

`expr` 可以是一个 `J` 或若干 `J` 的线性组合，函数对表达式保持线性。自动 seed 生成不另写一套公式，而是枚举 sector、连续 seed、离散 `n` 规则与上述生成元后调用这些原子函数。

对含 massive 或 massless 离散态的 seed，调用顺序固定为：

1. 先给连续 `a/b/isp` 指标；
2. 再枚举或显式指定全部 `n=0/1`；
3. 调用 `dtau/dqq/dqk`；
4. massive 一旦产生 `n>=2` 立即 EOM；massless 直接用有方向的 `0<->1` 规则，不产生 `n=2`；
5. 应用 theta boundary、coincident antisymmetric zero 和 sector canonical。

内部继续拆成“对 `xi_e` 求导”“复合生成元作用于 `xi_e`”“吸收 `z/ISP` 因子”“指标移位”等更小模块，公开复合算子只负责组合链式法则。

### 11.2 内外表示转换

- `rep2innerform[expr,topo]`：用户表示转内部线性代数表示。
- `rep2outform[expr,topo]`：内部表示转用户可读表示。

转换范围包括：

- 任意用户圈/外动量符号与内部编号坐标的对应；
- `sp[p,r]` 与内部 `qq/qk/kk` 坐标；
- 外部不变量的缺省 `ssij^2` 或用户自定义坐标表达式；
- 用户 ISP 名与内部 `rho[j]`；
- 必要的 coefficient-only 参数命名。

这两个函数只转换系数和标量积表示，不改变 `J` 的三个指标槽，不重排 line packs，也不修改任何 `a/b/n/ispN` 指数。用户可以显式在任一阶段调用它们；package 的公开输出默认经过 `rep2outform`。

### 11.3 指标积分到被积函数

`rep2Integrand[expr,topo]` 把含 `J` 的表达式线性地展开为被积函数表示，用于人工检查和手推 benchmark：

- 时间幂次 `Product[(-tau[v])^(a[v]+a0[v]),v]` 直接相乘；
- 每条线的简单分母 `xi[e]^(-(b[e]+b0[e]))` 直接相乘；
- 每条未缩并传播子的非平凡 Hankel/指数/theta 部分用惰性包装 `Hh[传播子部分表达式]` 标记，避免与普通幂次混淆；
- ISP 坐标按第三槽指数相乘；正值为 numerator，显式负值按用户输入还原为倒数；
- shrunk line 不再保留原传播子的 `Hh`；
- compact `aList`、zero-point 与原拓扑的对应从 `sectorMetadata` 读取。

`rep2Integrand` 只做表示展开，不执行积分、不生成 IBP、不应用 EOM。011 的 `011_public_api_check.wl` 已覆盖 inner/out round-trip、`J` 指标保持和 inert `Hh` 展开。
### 11.4 用户输入的积分族对称性

- `symmetryRules`：case/topology 的可选替换规则列表。用户负责确认质量相等、外腿能量相等或其它参数条件确实成立。
- `repSymmetry0[topo_]`：返回规则本身，可直接用于 `/.`。
- `symmetry[expr_,topo_]`：单次函数化应用自动 tadpole rules 与 `repSymmetry0[topo]` 的去重并集；用户规则不被覆盖。
- 没有规则时返回原表达式。
- package 暂不自动检测图 automorphism 或由特殊参数取值产生的额外对称性，也不使用 `ReplaceRepeated` 自动迭代规则。用户规则必须先排序并单向指向唯一代表，不能同时写 `A->B` 与 `B->A`。
- 物理 family benchmark 在 pure massive bubble reference 与 single-massive sunrise 中输入确认成立的对称性；前者包含旧代码的 vertex/line exchange 与 `R2->R1`，后者包含顶点交换和 massless-line/ISP 同步交换。其它函数族保持 `symmetryRules -> {}`。

## 12. 013/014 版本拆分与发布边界（已完成）

013 是已冻结的 pure time-IBP/tree 物理版本：它以 012 的 loop topology 和 `dtau` 原子实现为只读基线，完成 tree vertex-family、迭代约化和直接 dlog DE，不承担 package 工程化、交互系统或 Kira 结果取回。

014 曾在 013 验收后把 topology-driven loop/tree 核心放入标准 Mathematica package，并补齐初始化 metadata、运行进度、Kira 结果取回、DE/scaling 闭环和完整 examples。该段只记录 013/014 的历史分版；当前入口与正式交付以第 7 节的 018 路径为准。

当前目录为：

```text
Git 历史中的 014 模块目录
  dSIBP.m
  Kernel/init.m
  Kernel/dSIBP.wl
  Kernel/Core/LoopCore013.wl
  Kernel/Core/Context.wl
  Kernel/Core/Metadata.wl
  Kernel/IBP/Loop.wl
  Kernel/IBP/Tree.wl
  Kernel/Backends/KiraExport.wl
  Kernel/Backends/KiraImport.wl
  Kernel/DE/BuildDE.wl
  Kernel/DE/Scaling.wl
  Kernel/Tree/VertexFamily.wl
```

`LoopCore013.wl` 是迁移期兼容层：内容冻结自 013，只允许通过 014 loader 在 `dSIBP`Private`` 中加载。新功能不得继续堆入该文件，而应进入上列模块。`dSIBP.m` 与 `Kernel/init.m` 都只定位 package 根目录并加载 `Kernel/dSIBP.wl`；模块内部只能由 package 根目录构造相对路径。

历史 014 example 曾把当时的 014 模块目录加入 `$Path` 后使用：

```mathematica
Needs["dSIBP`"]
(* 或 <<dSIBP` *)
```

公开命名分两层：

- 高层闭环命令使用短而带 `DS` 前缀的名字：`DSInit`、`DSInfo`、`DSSeeds`、`DSLinear`、`DSKiraExport`、`DSKiraImport`、`DSDE`、`DSScaleCheck`、`DSTreeSeeds`、`DSTreeDLogDE`。
- 公式级接口保留已约定名字：`dtau`、`dqq`、`dqk`、`ds`、`rep2innerform`、`rep2outform`、`rep2Integrand`、`symmetry`、`repIterative`。原始规则仍以 `rep****0` 命名。

所有公开符号必须有 `::usage`，所有 option 必须能由 `Options[函数]` 查看。用户手册正文按工作流讲解，附录另给公开函数、用途、参数形式和 option 的总表。

## 13. 016 初始化与 example 规范

每个例子使用独立目录：

```text
independent-benchmark/package/examples/<case>/
  main.wl
  init/
    manifest.wl
    topology.wl
    sectors.wl
    conventions.wl
    derivatives.wl        # 可选
  kira/
  results/
    dlogDE/
```

`main.wl` 按可交互执行的单元组织：

1. package 路径与 `Needs`；
2. 详细物理输入，逐项注释 vertex、line、momentum、ISP、zero point、symmetry 和 parity；
3. 单独的“缺省选项”单元。未覆盖时写出缺省值，覆盖时同时写明 package 缺省；
4. 显式 `DSInit[case,...]`；
5. 逐步调用 seed、linear、serializer、import 或 DE 命令，并直接展示关键中间量；
6. 所有路径从 `main.wl` 所在目录构造，不依赖启动目录。

`DSInit` 至少返回并可写出以下 metadata：

- `topology.wl`：规范化 topology、ISP 闭合报告和动量基；
- `sectors.wl`：contact-reachable sector、compact `a` 映射、line pack shape；
- `conventions.wl`：SK branch、`P/Q/T/W/AT/WT`、zero point、dimension、外部变量名和 parity；
- `derivatives.wl`：可选生成的独立变量及矢量微分算符分解；
- `manifest.wl`：package 版本、输入哈希、生成时间、各文件路径和状态。

初始化写文件缺省为 `False`；开启时缺省目录是当前 example 的 `init/`。导数算符 metadata 缺省不写，避免多外动量 family 初始化膨胀；用户显式打开后才生成。

### 13.1 三个长期典型 example

正式 examples 不追求把 benchmark 的所有 family 各复制一份，而固定三个结构互补、可长期维护的典型案例：

1. `04_pure_massive_bubble_closed_loop/` 是唯一带既有解析 reference 与原始 dlog basis 的闭环案例。它把初始化、parity-closed relations、Kira export/import、19-master DE、显式 `ks` basis 恢复和 scaling relation 放在同一条可对照链上，因此负责验证 normalization、basis order、能量 convention 和 DE/scaling，而不是承担复杂 topology 覆盖。
2. `06_mix_bubble_tree/` 固定一条 massive h cycle line、一条 massless exponential cycle line和一条 massless exponential bridge。这个最小复合图同时区分 `loopExternalMomenta` 的 `kL` 与 `independentExternalMomenta` 的 `kE`，包含独立顶点相位和无圈模长参数，并让 massless 新三槽 convention、cycle contraction 与 fixed/bridge contraction 在同一 context 中出现。再增加 massive line 只会叠加 function-system/EOM 复杂度，不增加上述结构边界，因此不作为缺省 example。
3. `03_single_massive_sunrise/` 是唯一 sunrise example。两个顶点由三条平行边连接，故 `L=3-2+1=2`；只保留一条 massive h line，其余两条 massless，并用两个显式 ISP 补齐五维 loop scalar-product 空间。两个顶点的外腿能量固定为同一个 `kE`，圈外 Gram 根号为 `ss11=Sqrt[sp[kL,kL]]`。顶点交换与两条同类 massless 平行线交换由 `symmetryRules` canonicalize；两个 ISP 特意选成在线交换下互换的一对，避免 line pack 已交换而 ISP 仍停在旧定义。它只负责验证全部 contact-reachable sector 的 general time/momentum IBP seeds、两圈 routing、ISP 闭合、离散 symmetry，以及 `{ss11,kE}` general 参数微分算符；不撒连续指标点，不构造 `linearData`、Kira、DE 或 scaling，也不再另设 all-massless 或 multi-massive sunrise example。

这三项是长期接口与物理 convention 的代表案例，不是全 family 验收的替代品。新增 family 优先进入独立 benchmark；只有当它覆盖三者均不具备的公开功能边界时，才讨论增加正式 example。

## 14. 014 Loop：Kira 到 DE 的闭环

闭环固定为：

```text
topology -> canonical seeds -> linearData -> Kira files
         -> 用户在 package 外运行 Kira
         -> 导入完整 Kira 结果 -> reduction/master data
         -> ds -> DE matrix -> scaling checks
```

package 仍不启动 Kira，不管理 Kira/Fermat 路径。`DSKiraImport` 只读取用户指定目录中的完整输出，以实际 export 文件内容 identity、master 列表、reduction rules、`repJ2kira`/`repkira2J`、targets 和系数域闭合作为硬边界；`kira.log` 完成标记只作诊断 warning。缺少结构化必需文件、内容身份或积分映射不一致时必须拒绝构造 DE。

首个闭环例子固定使用 pure massive bubble reference 的 `--` branch 和论文/参考代码相同的 parity-closed subsystem：top sector 要求 `n1+n2+b1`、`n3+n4+b2` 均为偶数；residual `R1` 要求 `b1`、`n3+n4+b2` 均为偶数。reference code 使用的 vertex/line exchange、`R2 -> R1` 和 parity 必须通过本 package 的 symmetry/parity 模块应用，不在 importer 或 DE 模块私自重写。

该 reference 的 vertex-exchange symmetry 还要求 `P1=P2`。reference `Vpm=0` 的相位项与 package `--` 的相位项符号相反，故 `P_pkg=-P_ref`。014 闭环以 package 变量 `P0=+I k0` 为独立变量，并将 reference basis 映射为 `P1=P2=-P0=-I k0`；一般独立 `P1/P2` family 必须删除这条交换 symmetry，不得同时保留独立能量和等能量对称性。

`DSDE` 对有序 master list 逐个调用 `ds[master,var]`，包含动力学系数的乘积法则，再用导入 reduction 约回相同 master 顺序。Kira coefficient field 可以使用 `dsc*`/`dsii` 原子表示 `Sqrt[s11]`、`I` 等代数系数，manifest 必须保存可逆映射；系数取回后还要把内部 `kk/ISP` 坐标统一外部化，公开 DE 只能含初始化声明的外部变量。输出必须包含 `masters`、`variables`、逐变量矩阵、残留未约化对象和来源 manifest。若 basis 有变换，必须同时保存变换矩阵和原/新 basis 顺序。

scaling check 采用 2604.14549 的两类关系。对 top bubble：

```text
(ks d/dks + P1 d/dP1 + P2 d/dP2) I
  = (d - b1 - b2 - a1 - a2 - 2) I .
```

对 residual/tadpole `R1`：

```text
(ks d/dks + P0 d/dP0) R1
  = (d - b1 - b2 - a - 1) R1 .
```

检查必须在同一 convention、同一 master order、同一 reduction rules 下逐项为零，不能用少量数值点替代全符号结论。dlog 结果统一写到 `results/dlogDE/`，矩阵和完全同序的 master list 必须成对保存。

014 实际闭环采用等能量限制后的 Euler 算符 `2 s11 d/ds11 + P0 d/dP0`；在 reference 变量中这是沿 `P1=P2=-P0` 的共同缩放方向。fresh Kira 2.3 结果为 33581 equations、6555 independent、19 active masters、1814 selected targets 和 0 unreduced integrals；`post_kira_check.wl` 对 import、master/辅助 ID、target closure、DE 顺序、残留对象和 Eq. (51)/(64) residual 共检查 22 项。

## 15. Tree 公开表示、Private vertex basis、迭代约化与 dlog DE

017 的 tree 与 loop 使用同一个唯一公开对象：

```mathematica
J[aList, linePacks, ispList]
```

`timeOnly` 时 `ispList={}`；`aList` 按当前 sector 的稳定 active-vertex 顺序排列，`linePacks` 按 root line 顺序保留 full/shrunk pattern。massive-only 的论文公式内核仍按顶点临时构造 `{{a1,n11,...},{a2,n21,...},...}`，但该对象只存在于 `Private` adapter 内，不是用户可调用或后端可序列化的第二种积分表示。公开 `DSTreeSeeds`、`repIterative`、`DSTreeNaiveIBP`、`DSTreeNaiveDE` 与 `DSTreeDLogDE` 在返回前递归映射回三参数 `J`，并通过 `publicRepresentationAudit` 检查不存在一参数 `J` 或私有 sector token。

对单顶点含 `p` 条 massive h 外腿，master 按 2401.00129 Eq. (3.33) 的二进制顺序排列：

```text
j = 1 + Sum[n_i 2^(p-i), {i,1,p}],
```

所以顺序固定为 `{00...0, 00...1, ..., 11...1}`，共 `2^p` 个。迭代矩阵直接采用该文 Eq. (3.37)、(3.47)、(3.50)，而不是从有限 seed 重新求解：

```text
M1 = Sum[(nu_i+1/2) Lambda3_i] + (nu0-p/2-Sum[nu_i]) I,
M0 = -i Sum[k_i Lambda2_i] + i k0 I,
A-(nu0) = -Inverse[M1].M0,
A+(nu0-1) = -Inverse[Tp].Inverse[M0tilde].Tp.M1.
```

`repIterative[expr_, end_:Automatic]` 读取这些 general-index 单次规则并迭代到每个顶点指定终点。`Automatic` 表示所有 `a_e,end=0`；显式终点列表长度必须等于顶点数，每个起点到终点的距离必须是可判定整数，否则拒绝。各 sector 的 `repIterative0` 保存为可直接 `/.` 使用的单次 general-index 规则，函数形式负责门禁、顺序和终止。含 contact source 的 raw/sector-tagged 两种调用都从 016 direct pure-time seed 生成同一单步规则，保持传播子动量模长、共同 theta 和 lower-sector tag 同源；旧三槽 loop 投影仅用于交叉检查。

dlog DE 的 sector 对角块直接采用 2401.00129 Eq. (3.54)--(3.55)，输出连接、letters、同序 master list 和 convention。letters 的序列化顺序固定为：按 `vertexOrder` 逐顶点拼接该顶点 `massiveLegs` 顺序的能量 letters，再拼接 binary master order 的 cut letters，最后做稳定去重；`letterMatrices` 必须使用完全相同的 key 顺序。对多个顶点，先按顶点 tensor order 构造 top-family basis，再按 contact 缩并形成的 sector DAG 追加 lower-sector basis。

非对角块采用该文 Eq. (3.66)--(3.68)。对 parent sector 的每个 `a=0` binary master 和每个活动顶点，先保持 binary state 不变、只把该顶点时间指标设为 `a=1`，再调用 loop `dtau`；由此得到的是 `f^(1)` 约化中的 `R^(1)` contact source。不能从 `a=0` seed 的 `R^(0)` 出发把 lower integral 的 `a=-1` 强制约到 0，否则会把合并顶点能量因子错误吸入 contact selector。source 仍须先经过完整物理幂投影；多线情形如产生非零 lower `a`，再由 sector-tagged `repIterative` 约到该 target sector 的 master order。

每个 sector `s` 的统一积分 `J_s` 已隐含由传播子收缩得到的 physical sector prefactor `N_s`，即 `J_s=N_s I_s`。为了让全部 lower-sector contact 块在缺省 naive 指标域内有理闭合，dlog basis 另选 `F_s=S_s J_s`；`S_s` 是由 contact DAG 唯一传播的有理 selector coefficient，不是第二份 physical prefactor。contact source 在统一 `J` 表示中已经消费 `N_s/N_t`，tree dlog 层只再乘 `S_s/S_t`。

```text
Omega_ss = Omega_s + Log[S_s N_s] IdentityMatrix,
Omega_st = Sum_v[-I Embed(T_v^-1 Omega0_v T_v) . (S_s R_st^(v) / S_t)],  t lower than s.
```

这里 `R_st^(v)` 是 loop `dtau` tagged source 在统一 normalized `J` 表示中的 contact coefficient。物理 sector prefactor `N_s` 单独由 sector metadata 保存；master 的 complete normalization 是 `S_s N_s`，其 `Log` 对数导数必须完整进入 naive/direct DE。`Log[S_s N_s]` 保持为整体 normalization letter，不对一般复幂使用 `PowerExpand`。生产结果必须返回 `masterNormalizationRecords`、`dlogSelectorCoefficients`、`selectorAudits`、`contactMaps` 和 `omegaBlocks`；`dlogResidual/dlogQ` 及反向 sector/同层 sibling 块的全矩阵证书只在显式 `AuditLevel->"full"`、独立检验或发布检查中构造。

顶点 `+/-` 不改变 h 的二阶 EOM 和 `2^p` binary basis，但改变顶点相位中的 `k0` 符号及 `G++/G--` contact source 的符号。映射必须从 loop topology 的规范化 `vertices` 和 compiled `WT` 读取：

- `G+-/G-+` 没有 theta 导数，不调用 `WT` 或 contact 映射；
- `G++/G--` 的 theta 导数才产生 lower-sector source，分别使用当前 loop time-IBP 已验证的 branch offset；
- 多条同顶点对 full lines 继续使用共同-theta odd-subset contact，不逐传播子重复 delta；
- source 先在 loop 指标中完成 simultaneous shrink、zero-point 和 coincident canonical，再映射成 tree sector，禁止在 tree 模块重写一套 contact 公式。

Tree seeds 的主路线因此是“调用 loop `dtau` 原子结果 -> 只取 time-IBP -> 应用现有 canonical/contact -> 显式映射为 tree `J` replacement rules”。momentum-IBP 不进入 tree 模块。这样 tree 与 loop 共用已验证的 theta/EOM 实现，又不会把 loop 的 denominator/ISP 三槽结构强塞进 tree 表示。

投影不是只删除 loop 的 `b` 槽。对目标项所属 sector `s` 和原 seed 参考积分 `r`，定义

```text
A_s = Sum[a_e + a0_e(s)],
B_es = b_e + b0_e(s)       或       bS_e + bS0_e(s).
```

tree 项的显式归一化系数必须按物理幂次差构造为

```text
Product[k_e^(-(B_es-B_er)),e].
```

source 与 target 都按 `(-tau)^A` 定义，contact 合并只组合同一个负时间变量的幂，因此不得再乘 `(-1)^(A_s-A_r)`。当前 sector 的 `a0` 进入 vertex family 的 `nu0`；被 tree 表示删除的 `b0/bS0` 必须贡献到显式 `k_e` 系数。对 h-mode massive contact，`bS=b+1`、`bS0=b0+2 nu` 与 merged `a/a0` 一起给出完整 `k^(-2 nu-1)`；不得只保留整数 `k^-1`。直接构造幂次差可使 general `b` 与共同 `b0` 显式抵消，不能依赖一般复幂的 `PowerExpand`。绝对 normalized-master 相位由独立论文 oracle 检查，不能由只对常数 basis phase 不敏感的 DE 比较替代。

014 的 sector-tagged `treeLinearData` 对每个未合并贡献保存 target/reference 的 `aInteger/aZeroPoint/aPhysical`、`bInteger/bZeroPoint/bPhysical`，以及 `deltaTimePower`、逐线整数/零点/完整幂次差、`explicitEnergyPowers` 和由这些量重建的投影系数。合并到同一 `{sectorKey,J[...]}` 的贡献可以求和，但必须同时保留 `contributions` 与 `physicalPowerAudits`，不能用第一项的审计信息代表全部来源。多传播子 simultaneous contact 的显式系数按每条线的能量因子相乘，merged vertex 的 tree `nu0` 减去所有选中线的 zero-point shift 之和。

014 的第二条 tree DE 路线由 `DSTreeNaiveIBP` 与 `DSTreeNaiveDE` 组成。前者以同序 sector-tagged masters 为固定列，对每个 sector/master/vertex 生成 `a_v=1` loop 代表元，只调用 `dtau` 后投影为 tree 方程，并直接用线性系统解出全部非 master 的一步升幂对象；不得调用 `repIterative`、`Aplus/Aminus` 或直接 dlog matrix。后者把外腿相位导数从 loop 原子层投影，但对 massive-line 动量模长使用 h 的 Eq. (21) 直接生成 tree 指标移位：`n=0 -> -{a+1,n=1}`，`n=1 -> {a+1,n=0}-(2nu+1){a,n=1}/k`。原因是 loop 适配器中的内部线动量属于积分变量，不等于 tree 的独立外部参数。最终直接对已经 normalized 的 `J_s=N_s I_s` 加入 `D[Log[N_s]] J_s`，再由 naive time-IBP 约化；不得额外构造 `N_s J_s`。

两条路线的发布门禁固定为同一个 `{sectorKey,integral,coefficient}` master 列表。naive 的 equation/unknown 数、solve residual、DE source 和 residual objects 必须闭合；逐变量矩阵与 `D[DSTreeDLogDE[context]["omega"],variable]` 严格相等。至少覆盖两顶点 `++` 的 contact/lower normalization 和两顶点 `+-` 的无 theta/无 `WT` guard。

## 16. 兼容性风险与解决方案

1. 012 中若干通用抽取使用 `_J`，会同时匹配 013 的 tree `J`。013 必须先做 `integralKind` 分派，再进入 loop/tree validator；不能依赖 pattern 没有定义时的偶然不求值。
2. 012 的 Kira serializer、积分排序和 sector metadata 只认识三槽 loop `J`。tree rules 作为单独结果保存；需要后端时先保留其专用 linear schema，不能直接送入 loop serializer。
3. Tree `a_e` 是每个 vertex-family 的时间幂次偏移，loop shrink 后的 compact `aList` 是 sector-local 顶点代表元。二者通过 sector metadata 显式映射，不按列表位置猜测。
4. `G++/G--` 使不同 vertex families 通过 lower-sector source 耦合，故多顶点迭代不是简单的独立 tensor product。解决方案是按 contact-reachable sector DAG 从低到高约化，使用论文 Eq. (3.66) 的非齐次项；无 theta 的 `G+-/G-+` 才完全因子化。
5. Private vertex basis 自身不携带 sector key；内部 adapter 必须始终与显式 `sectorKey` 成对使用。公开积分则由 root-ordered full/shrunk pack pattern 唯一编码 sector，`sectorKey` 只作交叉核验，不能按 family 列表顺序猜测。
6. 012/013 的 public context 尚未隔离。迁移期由 014 loader 预声明公开符号后，在 Private context 加载冻结核心；新增模块不得创建 Global 符号。冻结前用 `Names["Global`*"]` 差分检查泄漏。

## 17. 013/014 实施与验收顺序

013：

1. 删除 007--009 及其专用失效 checks，更新仍把它们列为可运行版本的 selector 和文档；010--012 保留只读。
2. 从 012 新开 `013_dS_ibp_general.wl`，实现 tree shape/metadata、loop-time 到 tree 映射、general single-step rules、`repIterative`、有序 masters 与 dlog DE；不做标准 package 搬迁。
3. independent benchmark 只新增 pure-time 内容，不重复此前已完成 expected：固定两顶点同号 massive case 和三顶点 `{+,+,-}` massive chain；massless 外腿能量与内部传播子能量使用独立符号。
4. 对两例手推全部 time seeds、source 和迭代关系，再与 package 对照。把 iterative reduction 与 seed 解作符号比较，并在非奇异有理点给 master 确定性数值做加速交叉检查。
5. 在新独立会话完成 benchmark，报告归档到 `000-report/`；依据报告修正并重跑到全部新增检查严格为零，才冻结 013。

014：

1. 建立标准 package loader、context、公开 usage/option、`DSInit/DSInfo`、metadata 和统一消息层；先用最小 example 验证 `Needs`、相对路径和无 Global 污染。
2. 迁移 013 的 seed/linear/Kira export 能力到高层命令，建立固定 examples；所有缺省 option 单独成单元。
3. 实现 Kira 完整结果 importer、reduction 数据验证、`DSDE` 和两类 scaling check；完成 pure massive bubble parity-closed 闭环。
4. 更新 independent benchmark：新增 package-load、init metadata、进度/消息、Kira fixture import、DE/scaling 和全部 013 tree/time 专项；014 必须全面重新手推与验证，不能沿用 013 报告代替。
5. 更新用户手册附录 API 总表，编译并目视检查 PDF；冻结 `package_014.wl/pdf` 交付并删除旧交付版本。

013 发布门禁是：tree 1-fold/2-fold iterative 与 Eq. (3.50) 一致；tree dlog 与 Eq. (3.55) 一致；两顶点/三顶点 pure-time seed 与迭代约化相互给出同一结果；含 `G++/G--` 的 source block 与 loop time-IBP 映射一致；任何 `G+-/G-+` edge 都不出现 theta/Wronskian source。

014 发布门禁是：013 与 012 受影响回归全通过；标准加载和相对路径通过；交互/headless 提示不刷屏；固定 parity Kira fixture 可完整取回并生成满足 Eq. (51)/(64) 的 DE；全面独立报告无未解决错误。

## 18. 014 运行进度、提醒与错误反馈

014 建立唯一消息层，所有模块通过它报告，不在循环中散落 `Print`。全局入口为：

```mathematica
DSMessagesOn[]
DSMessagesOff[]
DSMessageStatus[]
```

Notebook example 同时提供 `Button["On",DSMessagesOn[]]` 和 `Button["Off",DSMessagesOff[]]`。Off 关闭 info、progress 和非致命 warning；fatal error 始终显示并返回 `$Failed` 或状态为 `"error"` 的 Association，不能被全局静默掩盖。函数级 `MessageMode -> Automatic`、`ProgressMode -> Automatic` 可覆盖显示方式，但不能关闭 fatal error。

适合报告 `n/m` 的阶段包括：sector metadata 初始化、contact-reachable sector 枚举、外部变量微分算符生成、seed 生成、linearization、Kira 文件写入/结果验证、逐 master 构造 DE 和逐变量 scaling check。只需瞬时完成的原子函数如 `dtau/dqq/dqk/ds` 不显示进度条，只在输入错误或返回 `notReady` 时提醒。

有 FrontEnd 时，长循环外层使用 `Monitor[computation, ProgressIndicator[n,{0,m}]]`；需要文字时用一个 `PrintTemporary[Dynamic[...]]` 单元显示“正在初始化全 sector 信息 n/m”等，完成后替换为摘要。无 FrontEnd 的 `wolframscript` 模式只打印阶段开始、约 10% 的里程碑和结束；当总数很小只打印开始/结束，禁止每处理一个对象打印一行。

severity 分为 `Info`、`Progress`、`Warning`、`Error`。Notebook 中 Warning 使用橙色，Error 使用红色粗体，并同时发出标准 Mathematica `Message` 以便日志捕获；headless 模式写入 `$Messages`，文本包含稳定错误码、阶段、对象和修复建议。返回对象中的 `status/issues` 是机器可读权威信息，颜色文字只是用户反馈。

## 19. 017 统一三槽、fixed-line 系数与 sector parity

017 是表示和 sector convention 的整数版本升级。016 及更早版本保持只读；017 统一公开积分为

```mathematica
J[aList, linePacks, ispList]
```

`aList` 是 sector-local compact 顶点指标，`linePacks` 始终按 root topology 的原始 line 顺序排列，`ispList` 在 pure time-only 中为 `{}`。每条 full line 固定使用三槽 pack；shrunk line 已无端点态，允许退为单槽，但对应的 root line 位置绝不删除。不再把 `J[vertexPacks]` 作为第二种公开物理积分表示；论文 vertex basis 只允许作为带 sector tag 的内部线性映射。

### 19.1 cycle 与 fixed/non-loop line

line 是否参与 momentum IBP 由用户声明的 loop momenta 和 routing 决定，不从符号名猜测。017 的固定 schema 是：

| line role/state | massive | massless |
|---|---|---|
| cycle full | `{b,n1,n2}` | `{b,n1,n2}` |
| fixed full | `{"F",n1,n2}` | `{"F",n1,n2}` |
| cycle shrunk | `{bS}` | `{bS}` |
| fixed shrunk | `{"F"}` | `{"F"}` |

字符串 `"F"` 是“fixed line 没有圈幂次指标”的短 sentinel。不能写 `{,n1,n2}`：Mathematica 会把省略项变成 `Null` 并发出 `Syntax::com`；不能用 `_`，因为它是 `Blank[]` pattern；也不能用 `Nothing`，因为它会从列表中消失。full line 的 slots 2/3 始终对应两个有序端点；shrunk line 已无端点态，可以退为单槽。massless full 不压缩成单个有向 `n`，其额外关系在统一 non-IBP relation 层处理。

root-ordered full/shrunk pack pattern 是 shrink set 的**隐式、可逆编码**，不是仅供显示的 shape。例如第 2、4 条 root line 收缩时，无论它们是 cycle 还是 fixed，`linePacks[[2]]` 与 `linePacks[[4]]` 都保留原位置并改为相应的单槽 shrunk pack；由这些位置唯一得到 shrink set `{2,4}`。程序只允许由该 pattern 派生 canonical `sectorKey`，再让 seed、metadata 与 `linearData` 携带该 key 作交叉核验；不得维护一套可独立修改的第二 sector 编号。019 的 time-only key 使用同序定长字符串，shrunk 为 `0`、full 为 `1`，top 为全 `1`；full-loop key 不在本次迁移范围。删除 fixed shrunk slot、压缩 `linePacks`、把位串转成会丢前导零的整数，或只凭 compact `aList` 判 sector 都是非法表示。

family 初始化必须为每个 sector 构造结构化 `sectorPrefactorData`。它不缓存 `parameter^power` 乘积，而按同一稳定顺序保存至少以下字段：

```mathematica
<|
  "fixedLineIndices" -> {e1,e2,...},
  "parameterKeys" -> {fixedMagnitude[e1],fixedMagnitude[e2],...},
  "parameterList" -> {currentParameter1,currentParameter2,...},
  "powerList" -> {power1,power2,...},
  "powerParts" -> {<|"integer"->...,"zeroPoint"->...|>,...},
  "constantFactor" -> ...
|>
```

`parameterKeys` 永久绑定原始 fixed line；`parameterList` 使用初始化最终选定的公开参量，并在 `DSRedefineParameters` 后同步更新为用户坐标下的参数或 binding 表达式。`powerList` 与 line/parameter 列表逐项对齐，供 contact、求导、scaling 和 serializer 直接调取。Kira token、master 排序和 basis map 不得消费这些幂次，否则同一积分会仅因 normalization 不同而被错误拆成多个 candidate master。

唯一 prefactor materializer 在需要系数时由上述列表构造 $N_s$；其它模块不得手写 `Times@@parameter^power` 的并行实现。sector-normalized 积分定义为 $J_s=N_s I_s$，因此

$$
\partial_xJ_s=(\partial_x\log N_s)J_s+N_s\partial_x I_s.
$$

若裸积分导数或 contact 产生 target sector $t$，改写为 normalized basis 时还必须乘 $N_s/N_t$。`ds`、`DSDE`、scaling、time-only 转换和 loop-to-tree/sector 映射都从 source/target 的 `sectorPrefactorData` 调取该 normalization，不能因 prefactor 逻辑上藏在 `J` 中而漏掉导数或比值。

018 已把上述三处收束为同一数据流：sector metadata 保存完整 `N_s`，contact 统一写成 `c_raw N_source/N_target J_target`，`ds/DSDE` 加入 `D[Log[N_s],x] J_s`，`rep2Integrand` 也从同一 metadata 把 `N_s` 乘回。无圈模长的幂次按初始化冻结的 `kEpower[...]` 保存，当前参数表达式另存于 `kEParameterExpressions`；参数重定义只更新后者，不改变稳定编号和幂向量。局部 `16/16` 已通过，但最终正确性仍由 fresh reduction 后的完整 scaling relation 和 reference 同基比较统一检查。

通用 loop scaling 不复用无 ISP 的 bubble 次数。`DSScaleCheck` 的 `"LoopTopology"` 路线逐 master 使用 root 圈数、目标 sector 活动顶点、物理 `a/b/bS` 幂、`2 Total[ispList]` 与 `Euler[N_s]/N_s`；其中 contact sector 继承 root 圈数，`N_s` 仍从同一结构化 materializer 读取。若显式 master 组合或 `N_s` 对所选变量不齐次，检查失败而不猜次数；`"PureMassiveBubble"` 继续只服务已有 reference 对照。

### 19.1.1 Kira 内部实能量 convention

018 的公开物理 convention 不变；`DSInit/DSSeeds/ds/DSDE` 继续使用用户给出的物理能量 `k`。只有 Kira serializer 在写后端文件前，从 topology/line 的 phase-energy dependency data 结构性识别所有 massless propagator 动量原子并建立

```text
k = -I ik,       ik = I k,
D_k = I D_ik,    D_ik = -I D_k,
k D_k = ik D_ik.
```

`ik` 是一个小写实 backend symbol，命名为物理原子名前加单个 `i`；例如 `P0 -> ip0`。角色来源只允许读取初始化后的 phase dependency 结构数据。复合能量先按该结构拆成独立原子，同一原子在多个顶点或 massless line 中复用时合并来源；不进入任何传播子/顶点相位的 `ssij`、Gram 坐标和其它空间变量保持不变。非原子映射、保留名、大小写折叠重名或与现有系数变量碰撞均 fail closed。

`postDerivative` 数值路线先冻结物理 active basis 的解析一阶导数和最小 target closure，再把物理规则 `k -> r` 转成 Kira 规则 `ik -> r`，其中 `r` 必须是精确实有理数；同一 manifest 另保存物理求值截面 `k -> -I r`。因此 Kira 内部始终只看到实有理变量值，而 `DSDE` 仍返回物理 `k` 导数矩阵，并额外保存 backend derivative view 的 Jacobian。scaling 直接在实 `ik` 坐标做也不改变 Euler 算符，因为 `k D_k=ik D_ik`。

serializer 的固定顺序是：massless phase-momentum 的 `k -> -I ik` 映射、backend 实有理数值规则、剩余 Gaussian integral phase gauge。importer 反向执行：恢复一般 coefficient map、恢复 backend `ik` 到物理动量、再恢复逐积分 Gaussian phase。Gaussian gauge 处理前两步后仍残留的整体积分相位；它适用于实符号有理函数和全数值系统。若 `ibp.kira` 仍含 `I`、`Complex`、`dsii` 或其它虚数替代 token，serializer 必须拒绝导出，不能把改名后的虚数交给 Kira。manifest 必须保存双向动量规则、来源角色、backend/physical 数值截面、普通导数 Jacobian、Euler 不变性、碰撞审计及 Gaussian phase 状态。

Kira 探测的 target 选择必须有界。pre-reduction 初探按 topology 与预估 master 数设置候选范围，不得缺省选择全部积分；没有更具体估计时使用约 1000 的保守上限。formal reduction 只选择 active basis token 与解析一阶导数闭包，不把整个 finite envelope 预约化。

`linearData["integralList"]` 是 plan/export/import 的唯一积分顺序。用户需要不同 ID 时必须先调用 `DSReorderIntegrals`；`preferredIntegrals` 不改编号。用户给出的单个 `J` 或齐次 `J` 线性组合由 `DSUserMI` 构造成有序 `userMI[i]` 坐标：精确保存 support coefficient matrix、全体/active rank、pivot/spectator、双向规则、round-trip residual、原顺序 digest 和 backend ID 映射。它只替换 support 中的 pivot `J` 并保持 spectator `J` 不变；随后直接复用 active-basis derivative closure 和 formal target 逻辑。

pure massive bubble 的 reference 验证不重新生成 reference IBP 或运行 reference Kira。维护路线从原始 reference 结果目录复制并按固定 SHA-256 核验既有解析 `DEP0.m`、`DEks.m`、`DEscaleCheck.m`、`MIdlogNote.m` 与 `derivative_rules_bubble.m`；`reference_user_mi_basis.wl` 只保存 21 个 reference 候选数据，成品 example 必须调用 package `DSUserMI` 选取前 19 个 active，不得自写 basis Association/adapter。随后在解析矩阵上取 `P_ref=-P_pkg=29 I/13`、`ks=43/17`，先做已独立确认的 homogeneity lift，再恢复原始 dlog basis 第 15--18 项显式 `ks` 及 `D[T,ks].Inverse[T]`，最后用 `D_P0=I D_ip0` 形成 backend view。该路线与 fresh package reduction 的 physical `P0`、backend `ip0`、physical `ks` 三套矩阵各通过 `361/361`，19 个 master 定义比例均为 1；不引入事后拟合的 normalization adapter。

018 晋升另要求 package-side expanded-envelope 稳定性：把 pure massive bubble 的 top 目标包络从 `a in [-1,4], b in [-2,5]` 扩为 `a in [-2,5], b in [-3,6]`，不改变 reference 侧任何 producer。当前 fresh 扩张系统有 197232 条生成关系、7850 个 linear 积分、48699 个 Kira 方程和 7871 个导出积分；215 个 targets 由 19 个 active token 与 196 个 derivative `J` 构成，旧 196 个 derivative 对象全部包含。Kira 2.3 仍得到 backend master IDs `1..19`、215 targets、0 unreduced；import/DE/scaling 通过，三套 reference 矩阵再次各 `361/361` 精确相等。该结果用于排除当前 finite-envelope 边界假 master，不替代完整独立 benchmark 的其它 family 验收。

sector resolver 使用完整 `sectorMetadataList`，联合原始 line 位置、full/shrunk pack shape、`"F"`/index/state pattern、compact vertex representative map、ISP shape 和 `sectorKey` 唯一匹配。零匹配或多匹配均 fail closed；不得按列表顺序选择，也不得仅凭 `J` 的总槽数猜测。

### 19.2 compact `aList` 与 vertex zero point

`aList` 不是 root 定长列表，而是当前 sector 的 active vertex representative 列表。每次 contact event 把所选 shrink lines 的端点做并查集合并；代表元按 root `vertexIds` 的首次出现顺序稳定排列。对 child representative class $C_r$，整数与 zero-point 分别更新为

$$
a_r^{\rm child}=\sum_{c\subset C_r}a_c^{\rm parent}
-\sum_{e\in S_r}s_e,
\qquad
a_{0,r}^{\rm child}=\sum_{v\in C_r}a_{0,v}^{\rm root}
-\sum_{e\in E_r^{\rm shrunk}}z_e.
$$

这里 $S_r$ 是本次 simultaneous contact 选中的 lines，$s_e$ 是整数 `aShift`；$E_r^{shrunk}$ 是 target sector 中端点都落入 $C_r$ 的全部 shrunk lines，$z_e$ 是 zero-point shift。平行多线只合并顶点一次，但每条选中线的 $s_e,z_e$ 各贡献一次。例如两顶点 massive 单线给 `{a1+a2-1}`，massless 单线给 `{a1+a2}`，多线 simultaneous 给 `{a1+a2-Total[s_e]}`。三顶点顺序收缩必须与一次按最终 equivalence class 重建相同。

017 只保留一个 vertex-power merge 实现。若待 shrink line 的两个端点已经属于同一 representative class，该 contact 不得再次生成；禁止沿用 016 单线 helper 中的 `2 a` coincident 分支。sector-aware `ds` 按该 compact `aList` 验证，不再用 root 顶点数拒绝 lower sector。

`aList` 的长度和表达式都不参与 sector 身份判定。canonical `sectorKey` 以排序后的 root shrunk-line ids 为主键；`linePacks` 仍保留每条 root line 的位置，因此不同 shrink set 即使给出同长度甚至同表达式的 `aList`，也在不同位置出现 full/single-slot shrunk pack。metadata 另保存 `rootVertex -> compactASlot` 映射。若不同 contact 顺序产生同一最终 shrunk-line set，它们是同一 sector，贡献在保留 provenance 后相加；若仅因用户声明的图对称性应等价，则必须由 symmetry 模块显式 canonical，不能因 `aList` 恰好相同而自动合并。若同一 shrunk set 产生不兼容的 zero-point/prefactor signature，初始化失败并报告冲突，不创建两个外观相同的隐式 sector。

### 19.3 zero point、contact 与物理幂次

每个 contact 项必须保存并能重建以下恒等式：

```text
physical top contact
  = contact coefficient after Ns/Nt normalization
    * sector-normalized lower integral Jt
```

实现前冻结 massless、H、direct h 和 H-to-h 的逐线审计表，分别列出整数 index shift、zero-point shift、source/target `powerList`、materialized $N_s/N_t$ 和总物理幂次。atomic massless lower integral 若已经通过 `sectorPrefactorData` 含 `sE^-beta`，contact 结果保持 `-2 Jlower`，不得再次外乘同一因子。任何模长幂都必须在 normalization 中出现一次且仅一次。

fixed/non-loop line 没有 `b/bS` 槽，其收缩模长幂由已经选定的 sector zero point 唯一分配，不增加与 zero point 并行的吸收开关。设 compiled contact 为

$$
-W_{T,e}=\mathcal C_e\,r_e^{-s_e-z_e}(-\tau)^{-s_e-z_e},
\qquad s_e\in\mathbb Z,
$$

source/target sector 中该 fixed line 的 prefactor 分母指数分别为 $B_{s,e}$、$B_{t,e}$，它们都来自各自已解析的 zero-point convention。改写到 normalized target 后，模长系数唯一为

$$
c^{\rm norm}_{s\to t}
=\mathcal C_e\,r_e^{-\left[s_e+z_e-(B_{t,e}-B_{s,e})\right]}.
$$

共同-theta、端点符号和 $2^{1-|S|}$ 另乘。016 的缺省 sector zero-point 传播是 $B_{t,e}-B_{s,e}=z_e$，故缺省系数为 $\mathcal C_e r_e^{-s_e}$。若用户通过合法的 zero-point convention 改写 source 或 target zero point，上式自动改变约化关系和 DE 的系数；除此之外 package 不再提供 `fixedShrinkConvention`、`fullContactPower` 或任何额外整数幂吸收状态。用户若希望进一步吸收剩余的显式模长幂，应通过后续 master/basis 选择处理。

初始化必须逐 transition 保存 $B_{s,e}$、$B_{t,e}$、两者来源、compiled $(s_e,z_e)$ 和剩余 exponent $s_e+z_e-(B_{t,e}-B_{s,e})$，并由同一 `sectorPrefactorData` materializer 构造 $N_s/N_t$。顶点始终使用 $a_t=a_u+a_v-s_e$、$a_{0,t}=a_{0,u}+a_{0,v}-z_e$，不随用户的 fixed-line basis normalization 另作修改。

现行缺省 compiled 数据为：massive h 的 $(s,z)=(1,2\nu_e)$，massive H 的 $(s,z)=(1,0)$，massless theta contact 的 $(s,z)=(0,0)$。对 cycle line，它们进入 child 指标/zero point 的结果为

| 类型 | $a_t$ | $a_{0,t}$ | $b_S$ | $b_{S0}$ |
|---|---|---|---|---|
| h | $a_u+a_v-1$ | $a_{0,u}+a_{0,v}-2\nu_e$ | $b+1$ | $b_0+2\nu_e$ |
| H | $a_u+a_v-1$ | $a_{0,u}+a_{0,v}$ | $b+1$ | $b_0$ |
| massless | $a_u+a_v$ | $a_{0,u}+a_{0,v}$ | $b$ | $b_0$ |

fixed/non-loop line 没有 $b/b_S$ 指标槽；同一 $z$ 进入 target 的结构化 sector prefactor。配合缺省 $B_t-B_s=z$，h/H 的 fixed-line contact 都在系数中保留 $r_e^{-1}$，h target prefactor 相对 source 吸收 $2\nu_e$，H target prefactor不变；massless 不产生额外模长幂。h/H 的常数 $\mathcal C_e=(4i/\pi)e^{\pi\operatorname{Im}\nu_e}$，massless 的 Wronskian 常数取 1，端点 contact 系数仍为 $-2/+2$。

对 h/H 的缺省 contact，支持条件 $n_1+n_2=1$ 与 $b_S=b+1$ 给出 $b+n_1+n_2\equiv b_S\pmod 2$，所以 cycle line 的 subsector parity 不变。h 的 $2\nu_e$ 属于 zero point，不是整数 seed 槽；H 的 zero-point shift 为零。fixed/non-loop line 本来就不进入 parity generator。`shrinkBShift`/`shrinkZeroPointShift` 是由函数系统 Wronskian 编译得到的物理数据，用户通常不应修改；若确需 override，必须同步重建 child zero point、normalized coefficient 与 parity affine map。不可判定为整数重基时关闭相应 sector 的 parity capability，而不是沿用缺省判定。

massless 必须单独处理。其缺省 $(s,z)=(0,0)$，所以 cycle line 写入 $a_t=a_u+a_v$、$a_{0,t}=a_{0,u}+a_{0,v}$、$b_S=b$、$b_{S0}=b_0$；fixed line 则有 $B_t-B_s=0$，source/target 中原有的结构化模长 prefactor 相同，$N_s/N_t=1$。因此 shrink 本身不吸收任何新增整数幂或 zero-point 幂，normalized contact coefficient 的模长部分为 1，只保留端点导数给出的 $-2/+2$ 及共同-theta系数。

“无 shift”不表示 parity 不变。017 三槽 massless contact 支持 $n_1+n_2=1$，而 $b_S=b$，故

$$
b+n_1+n_2\equiv b_S+1\pmod 2.
$$

因此若 root generator 含该 cycle massless line 的 $b+n_1+n_2$ 分级，child-sector parity offset 必须相对 parent 翻转 1；016 单 $n$ 表示中的 $n=1$ 给出相同结论。fixed/non-loop massless line 不进入 parity generator，所以没有这次翻转。pure massless family 仍不自动获得 parity preset；但 mixed h/H family 一旦已有认证的 root parity，massless cycle contact 必须通过 GF(2) affine map 携带这个 $+1$ offset，不能被忽略或误写成 h/H 的不变映射。

### 19.4 parity 的最小数据模型

parity 只在 h/H compiled function system 中开放。root topology 是唯一的 parity 定义所有者，保存 `WTop` 与 `rTop`：每行表示

```text
Mod[WTop . integerSlotVector + rTop, 2] == 0.
```

slot 使用稳定的 root slot id，并与每条 line 的三个固定位置对应。017 的 parity generator 只允许引用携带圈动量的 line power/endpoint-state 槽和明确声明的 ISP 槽；fixed/non-loop line 的两个端点态、prefactor 幂次和系数完全排除。三槽 walker 统一读取 slot metadata，不为 massless pack 编写专用形状分支；massless 额外关系只改变 relation，不改变 pack schema。但 017 不给非 h/H function system 自动赋予物理 parity。

每个 contact transition 提供 GF(2) affine slot map `xChild=A.xParent+c`。sector parity 由 root generator 沿 sector DAG 代入该映射得到，只保存变换后的权重矩阵与 offset，不复制手写判定函数。对 h/H 缺省 contact，`n1+n2=1` 且 `bS=b+1`，所以 top 的 `b+n1+n2` 与 child 的 `bS` 同余；h 的 $2\nu$ 只改变 zero point，H 的 zero-point shift 为零，二者都不翻转整数 parity。初始化必须从实际 compiled `shrinkTerms`、sector zero-point map 和 seed/contact map 自动复核，不能把该结论写成脱离数据的硬编码答案。

massless cycle contact 的 affine constant 与 h/H 不同：`n1+n2=1, bS=b` 给 child offset 增加 1。该常数来自实际 contact support 与 index shift，不来自 zero point。若同一事件同时 shrink 多条线，总 offset 是各条 massless cycle line 的 1 与用户整数重基 shift 在 GF(2) 上求和；两条给 0，三条给 1。共同-theta只允许奇数条 contact，但 parity transport 仍必须逐线累加，不能用“事件只有一个 delta”替代 slot map。

用户修改 child-sector zero point 时，与 package 派生缺省值的差记为 `delta`. 若 `delta` 可精确化为整数，同一物理幂次对应 `bDefault=bUser+delta`，因此该槽对 sector offset 的修正为 `weight*Mod[delta,2]`。若差值不是可判定整数，则该 sector 没有已定义的二元重基：普通 IBP 初始化可继续，但 `parityUsableQ=False`，红字中英双语报告原因；显式请求 parity filtering 时失败而不是静默忽略。

H 的 parity 依据是 EOM 的分级，不是假设一般 Hankel 函数本身为普通偶函数或奇函数。裸 Hankel 递推

```text
{n=2,b} -> {n=0,b}, {n=1,b+1}, {n=0,b+2}
```

的四个对象均具有相同 `b+n mod 2`；h 递推同样保持该分级。H 缺省 Wronskian 预期编译为 `{bShift,zShift}={1,0}`：整数 shift 与 `n1+n2=1` 共同保持 parity，而 zero-point shift 不翻转 child offset。017 必须把这个结论作为 compiled-data 验收项；若实际 `{bShift,zShift}` 或用户 zero point 改变，则重新按 affine map 和 integer rebase 计算 child offset，不能一律沿用 top parity。未使用 h/H 时初始化明确提示 parity disabled；只有显式调用 parity 筛选才阻断，普通未筛选关系生成不受影响。

### 19.5 生成前筛选与生成后证书

parity 是 seed domain，不是积分归零规则。`DSGenerateIBP` 在作用 IBP 生成元前，把当前 sector 的 GF(2) 约束行约化；枚举自由指标后，只遍历满足所需偶/奇余数的 pivot 指标值。禁止先构造全量 IBP 再删除关系，也禁止把单条关系中 parity 不符的 `J` 替换成 0。

生成后只做轻量正确性证书：提取每条方程中的不同 `J`，唯一解析其 sector，计算该 sector 的 parity signature，并要求全部为零。失败表示 EOM、contact、sector map 或 seed 枚举存在 bug，不能通过删除失败项修补。该证书只线性扫描实际生成的积分，不构造额外全量候选集合。

### 19.6 time-only、massless quotient 与 subsector 导数边界

pure time-only 对统一三槽对象转换，必须同步携带 seed、built-in massless relations、tadpole/user symmetry、EOM、sector zero point、`sectorPrefactorData` 和微分算符。massless 内建额外关系进入统一 non-IBP relation 层；可安全定向且有严格终止序的关系用于 canonical replacement，其余作为线性关系进入系统，并保存 provenance。

公式型 `repIterative` 与直接 dlogDE 在 017 暂不根据 massless 额外关系重建 quotient basis。massive-only 情形继续验证；存在 massless 体内传播子时返回明确的中英双语 `PendingRederivation` 状态。后续需重新推导 massless quotient 上的迭代终点、master 顺序、递推关系和 dlog connection，再与 naive time-only IBP+DE 在同一 basis 上比较。

公开 `ds` 对表达式中每个 `J` 先通过 `sectorMetadataList` 唯一解析 sector，再按该 sector 的 compact `aList`、line packs 和 ISP shape 验证并求导；同一线性组合可包含多个 sector。随后读取该 sector 的 prefactor，加入 `D[Log[N_s],x] J_s`，并在导数落到其它 sector 时加入 $N_s/N_t$。表达式中原有的外部系数仍另行使用普通乘积法则。`DSDE` 必须复用同一 resolver 和 prefactor materializer，不维护第二套 root-shape 或 normalization 实现。
