# MadStree 开发规划

## 1. 目标与边界

`MadStree`` 是一个独立的 Wolfram Language 程序包。它读取有序 dS 树或纯 time-only incidence graph，直接使用 tensor formula 构造：

1. 每个 contact-reachable sector 的原生 time-only 主积分；
2. 任意整数时间幂 shift 的逐步与完整迭代约化；
3. 与主积分严格同序的 block-triangular dlog DE；
4. 与主积分同序的 2411 无穷远 Frobenius 边界，以及通过 FlintNDE 到用户目标普通点的数值结果。

主算法只组装局部矩阵、Kronecker 嵌入、contact 映射和 sector DAG，不生成一般 IBP 方程组，也不调用 Kira 或其它 reduction 后端。

边界条件与 blow-up 层按任意有限 time-variable graph 设计，不依赖传播子 incidence graph 无圈。`MSInitTree` 保留树输入门禁，`MSInitTimeGraph` 已开放“空间动量保持为参数、只计算所有 time integrals”的圈图，并完成 cyclic topology、重复 contact partition 与 active self-edge canonicalization。若还要积分 loop momentum，则其 Landau/阈值奇点不在本边界定理内。

本项目复用 `dSIBP`` 的物理 convention 和输入语义，但不读取其 loop momentum、ISP、scalar-product closure、general seed、`linearData` 或 backend metadata。MadStree 的公式、约化与 dlog 实现均由本包当前模块提供。

## 2. 固定 convention

### 2.1 时间幂与局部函数

- 原生积分使用 `(-tau)^A`。因此
  `D[(-tau)^A,tau] = -A (-tau)^(A-1)`。
- 始终规定 `nu=|nu|`，只使用一个函数名 `h`：`h(nu,0;z)=z^(sNu nu) H_nu(z)`。`NuConvention -> "Positive"` 是缺省并令 `sNu=+1`；`"Negative"` 令 `sNu=-1`，即 2401 的 prefactor convention。正负只标记 prefactor convention，不写在函数名上。
- 两种 convention 的 EOM、Wronskian、`M1`、contact 幂次、递推和 dlog 公式只差 `nu -> -nu`。引用 2401 时，正 prefactor统一把论文公式中的 `nu` 替换为 `-nu`；负 prefactor直接使用 `+nu`。
- massless 指数核的公开输入是 `nu=1/2`；正 prefactor下内部 `formulaNu=-1/2`，所以 `2 formulaNu+1=1-2 nu=0`。
- `masslessFull` 不是外腿指数。缺省 `masslessRepresentation="Quotient"` 把两个端点四态 quotient 成整条边共享的二维 slot；显式 `"RedundantH"` 则保留两个 h endpoint 的四态表示。该选择只在初始化时给出并固定在 context。
- 默认 package quotient 中，有序边 `e=(u,v)` 的 regular generator 为
  `Q[u,e]=+I sigma[e] q[e] sigma1`、`Q[v,e]=-I sigma[e] q[e] sigma1`，contact 权重为 `-2`、`+2`。
- `masslessCross`/`masslessExternal` 不含 theta，不产生共享 full-edge contact slot；其相位符号仍由 line metadata 明确给出。

### 2.2 原生积分

公开 time-only 对象定为

```wl
MSIntegral[sectorKey, aShifts, stateBits]
```

- `sectorKey` 是按 root propagator 顺序排列的定长 `0/1` 字符串：`0` 为已收缩、`1` 为未收缩，top 为全 `1`；
- `aShifts` 按该 sector 的 canonical vertex-component 顺序排列；
- `stateBits` 按该 sector 的全图 slot registry 排列；
- 每个主积分均取 `aShifts == 0`，所有二进制状态按同一 bit 顺序遍历。

dSIBP 020 的 time-only `J[sectorKey,timeShifts,stateBits]` 只通过显式 adapter 输入/输出；它与 `MSIntegral` 三个槽逐项对应，`stateBits` 是全 sector registry 的离散 `n_i` 态而不是按顶点 pack。该映射要求两边 context 的 sector normalization 已统一；adapter 不把 normalization 乘入积分表达式。MadStree 内部不携带 `b`、ISP 或 root-line 三槽占位结构，也不再构造 019 的 `J[aList,linePacks,{}]`。

## 3. 最小拓扑输入

初始化入口拟定为 `MSInitTree[spec]`。最小 `spec` 包含：

- `vertices`：有序 vertex id、用户命名的外部能量、指数符号 `phaseSign=+1/-1`、root time base power；
- `lines`：有序 line id、两个有序端点或单端点、line type、用户命名的模长、SK type、signed `nu`、normalization/contact 数据；
- 可选 `thetaBundles`：每项给共享同一 root theta argument 的 `lineIds`；未显式给出的 full lines 按当前相同端点自动成 bundle，事件由非空奇数子集自动生成；
- 可选 `normalization`：root/sector normalization 规则；缺省为 1。

支持的首版 line type：

- `massiveFull`：两个独立 endpoint h slots，可 contact；
- `massiveCross`：两个独立 endpoint h slots，不 contact；
- `massiveExternal`：一个 endpoint h slot；
- `masslessFull`：缺省整条边一个共享二维 quotient slot；可选两个 `masslessEndpointH` slots 的冗余四态；两者均可 contact；
- `masslessCross`：无共享 quotient/contact，作为端点指数 generator；
- `masslessExternal`：作为单端点指数 generator。

输入检查只覆盖公式真正依赖的边界：树入口必须为 connected tree，time-only 入口允许 connected cycle；端点存在；line type 与端点数一致；显式 bundle 只能引用 full lines 且必须共享 theta argument；每个二维 massive slot 有 `nu=|nu|` 和模长；每个 contact event 有确定 odd-subset 系数与时间幂贡献。

### 3.1 单顶点函数族专用输入

不要求用户把单顶点 family 包装成图。已实现入口

```wl
MSInitVertexFamily[<|
  "ki" -> {k0,k1,...},
  "nui" -> {timePower,nu1,...},
  "hankelBranches" -> {1,2,...}
|>, NuConvention -> "Positive"]
```

要求 `Length[ki]==Length[nui]`，`hankelBranches` 的长度比它们少一。紧凑模型只使用 `ki`、`nui`、`hankelBranches`、`exponentialBlocks`、`phaseSign` 和 `normalization`；其中首个 `ki/nui` 元素给出顶点能量和基准 `(-tau)` 幂，其余三元组定义 h blocks。显式模型只使用 `energy`、`timePower`、`hBlocks`、`exponentialBlocks`、`phaseSign` 和 `normalization`。h block 的字段为 `id/momentum/nu/hankelBranch`，指数 block 的字段为 `id/momentum/phaseSign`；每个模型及嵌套 block 都拒绝多余字段。每个纯指数 block 保存为 `1x1` metadata 并只平移 effective energy；每个 h block 是一个 `2x2` massive endpoint slot。专用初始化内部复用同一 sector、master、矩阵、递推、dlog 和边界 producer；数值计算统一使用 `MSEvaluatePath`。

## 4. Sector DAG 与幂次基准

### 4.1 Sector identity

sector 由已收缩 full edges 的 canonical 集合确定。收缩后顶点是 root vertices 在 contracted-edge forest 下的连通分量；分量按其最小 root vertex 位置排序。sector 顺序固定为：剩余 full edge 多者在前，再按 contracted line position 的字典序排列。

每个 sector 保存：

- `vertexComponents`、`vertexOrder`、`rootToComponent`；
- active lines、active slots、slot order 和维数；
- 每个 component 的 external energy 和 master base time power；
- parent/child contact events；
- normalization、normalization ratio 和 dlog 认证状态。

### 4.2 为什么 child base power 必须吸收 `+1`

设 parent 中两个 component 的时间幂为 `A_u+a_u`、`A_v+a_v`，contact event 的 raw 额外时间幂为 `lambda_e`。delta 合并后 raw child 幂次为

```text
A_u + a_u + A_v + a_v + lambda_e.
```

为了让 DE 所需的 `R^(1)` 直接落在 child master，而不是先产生一个 shifted child 再做 kinematic-dependent 约化，child master base 固定为

```text
A_child = A_u + A_v + lambda_e + 1.
```

所以一般 contact 映射产生的 child shift 是

```text
a_child = a_u + a_v - 1.
```

于是 parent 的 `R^(0)` 落到 child shift `-1`，而任一端点 IBP 的 `R^(1)` 恰好落到 child shift `0`。参考 bubble 中 raw contact 的 `a1+a2-2 nu-1` 与 subsector 基准 `a0R=2 a0-2 nu` 正是这一规则。

对于普通树图的逐边 contact，任一 contracted component `C` 的 master base 因而是

```text
Sum[rootBasePower[v], v in C]
+ Sum[contactRawPower[e], contracted e inside C]
+ Length[C] - 1.
```

该式与收缩顺序无关。

### 4.3 共同 theta / 多边 contact

一次 event 同时收缩多边而只产生一个 delta 时，不能机械地给每条边各加 1。初始化必须解 event 约束

```text
A_target(newComponent)
= Sum[A_source(component)] + lambda_event + 1.
```

共同 bundle 使用 `Product[A]-Product[B]` 的非空奇数子集展开；子集 $S$ 的系数为 `2^(1-Length[S])`。一个 event 只把两个当前 components 合并一次，因此最终 component 内真正的合并次数恒为 `Length[C]-1`，上述 base power 只依赖最终 partition 与 contracted set。sector 由 event BFS 枚举；active self-edge 不再触发 contact，多条合法路径 canonical 到同一 key。

合并后未选的 coincident massless full line 删除 odd shared state；coincident massive full line把 `10` canonical 到 `01`。每个 sector 保存 raw state order、canonical state order、embedding `S` 和 projection `P`，并要求 `P.S==IdentityMatrix[masterCount]`。

## 5. Slot registry、basis 与主积分

初始化先建立全图 building-block registry，再由每个 sector 过滤 active blocks。block 分三类：

1. 每个不带 theta 的指数 `Exp[I chi[b] q[b] tau[v[b]]]` 一个一维 `phaseExponent` block；同一顶点可以有多个，纯顶点能量、massless cross/external 分支都在初始化时保留各自编号；
2. 每个 massive endpoint h system 一个二维 `massiveEndpoint` block；
3. 每条未缩并 `masslessFull` 缺省由 massless relations quotient 成一条共享二维 `masslessShared` block；若初始化为 `RedundantH`，则保留两个 `masslessEndpointH` blocks，不在 coincident canonicalization 中自动压缩。

每个 block 保存稳定编号、root line/vertex 来源、维数、basis、用户动量名、指数符号或 Hankel branch/SK metadata；每个 root vertex 另存其关联 block 编号和 endpoint incidence。`masslessShared` 的同一编号同时出现在两个端点的 vertex incidence list 中，不能复制成两个二维因子。一维 blocks 可在矩阵层聚合为该顶点的 signed energy sum，但 registry 和对用户的 DE 坐标映射中不得丢失各自编号。

每个 sector 的二维 slot 顺序固定为：

1. 依 root line 顺序列出 active massive endpoint slots，每条线内按有序端点；
2. 依 root line 顺序列出 active `masslessFull` slots；quotient 是一个 shared slot，`RedundantH` 按有序端点列出两个 slots。

Kronecker 顺序采用左侧 slot 慢变、右侧 slot 快变；`stateBits` 使用同序二进制列表。维数为 `2^slotCount`。

公开 `MSMasterIntegrals[context]` 返回全 sector 同序记录，每项至少含：

```wl
<|
  "sectorKey" -> key,
  "sectorOffset" -> offset,
  "stateBits" -> bits,
  "integral" -> MSIntegral[key, zeros, bits],
  "normalization" -> Ns
|>
```

这份列表是 recurrence、DE 行列、数值边界向量的唯一顺序 authority。任何矩阵都同时返回该列表及其 digest。

## 6. 公式原子与全图矩阵

独立原子 API 包括一维指数 generator、Pauli 矩阵、projector、`T/TInverse`、Hadamard、任意 slot 嵌入和 Kronecker identity。所有高函数族由 building-block registry 参数化，不按 fold 数复制函数。

对 root vertex `v` 的指数统一写成 `Exp[I phaseSign[v] k0User[v] tau[v]]`。其一维 generator 是 `I phaseSign[v] k0User[v]`。`phaseSign` 只说明顶点指数正负，不与 propagator 的 `G++/G--` SK sign 混用。

对 sector `s` 和 active component `v`，组装 package `(-tau)^A` convention 下的

```text
-M1[v,s,A] F_s(a-e_v) + M0[v,s] F_s(a) + R[v,s,a] = 0.
```

- `M1` 只含时间幂和 active massive endpoint projectors；公开 `nu=+1/2`、内部 `formulaNu=-1/2` 的 shared massless slot不进入 `M1`。
- `M0` 是 component 一维指数 generator、massive endpoint generator 与 shared massless endpoint generator 的全图 Kronecker 和。单个顶点仍可直接应用同一个递推公式；massless 的影响只是两个顶点的 `M0` 作用在同一 shared slot，而不是各自拥有一份副本。
- 论文 h-state 中每个二维 `M0` 原子只含 `sigma2`；package quotient 中 massive block 仍含 `sigma2`，massless shared block 只含 `sigma1`。同一 slot 内绝不同时出现两个不对易 Pauli 方向。因此按 block 分别使用 `T` 或 Hadamard 后，所有 `M0[v,s]` 仍由一个全局常数矩阵 `U_s` 同时对角化，energy letters 从其对角元直接读取。
- 共同对角化不是“任意 Pauli Kronecker 和都可以”的结论。若未来某个 block 的待求逆矩阵在同一 slot 同时含两个不平行 Pauli 方向，或不同 vertex 在同一 shared slot 上使用不可共同对角化的方向，则必须先证明新的共同谱分解；否则禁止使用逐 slot 取倒数的快速路径。

公式 producer 返回矩阵本身、对角形式、letters、奇异面和 slot 解释，便于逐项审计。

## 7. Contact 映射与迭代约化

contact 分两层保存：

1. `rawContactMap`：记录 event、source/target sector、被删 slots、状态 injection、系数、normalization ratio 和 target `aShift`；
2. `masterContactMap`：把 raw target shift 递归约到 target master，并保留沿 sector DAG 产生的更低 sector 项。

普通单边 event 在 `R^(1)` 情形下 target shift 应严格为零；这是 dlog 快速路径。若不是零，则必须实际调用 target sector 的公式递推，不能静默丢掉 shift。

已实现迭代入口为：

```wl
MSRecurrenceStep[integral, component, context]
MSReduce[integralOrExpression, context, MasterBasis -> Automatic]
```

- lowering 只对 `M1` 的逐 state 对角本征值取倒数，其离散 resonance 层由这些本征值为零给出；
- raising 使用共同对角化后的 `M0^-1 M1`，且只对逐 state energy letter 取倒数；
- remaining term 始终带 sector identity 和精确 target shift；
- 终止度量是 `(sector rank, L1 distance to target shifts)`，不得用固定最大步数代替数学进展检查；
- 分母为零时返回方向敏感的 singular surface：`M1=0` 只阻断需要 `M1^-1` 的 lowering；`M0=0` 只阻断需要 `M0^-1` 的 raising。反向使用关系时不能把另一方向没有求逆的零本征值误报成障碍。

`MSReduce` 只接受固定 context 所张成的合法对象：contact-reachable `sectorKey`、该 sector 每个 component 的整数 time shift，以及按 2401 二进制顺序排列的全部 state bits。它可处理这些合法 `MSIntegral` 的有限线性组合，但不生成新的传播子幂、离散指标、context 外 sector 或另一函数族。memoized recursion 自动处理 contact DAG。输出固定包含 `result`、`masterBasis`、`masterRules`、同序 `coefficientVector`、`nonMasterResidual`、`remainingShiftedIntegrals`、`memoizedIntegralCount` 和方向敏感的 `singularLayers`。`MasterBasis` 只能是 context 全部 masters 的完整排列；不完整、重复或含外部 master 时 fail closed。

局部逆已经编码为三类原子：massive endpoint 与 `masslessEndpointH` 用 `msPaperT/msPaperTInverse` 对角化固定 `sigma2`；massless shared slot 用自逆 Hadamard 对角化固定 `sigma1`；纯指数是 `1x1`。全 sector `U` 是这些局部矩阵的 Kronecker 积。`M1` 在 state-bit basis 对角，`M0` 在该共同 basis 对角，因此 Formula/DE 路线不调用一般大矩阵 `Inverse`。若后续 building block 使同一个 slot 出现不共线、不可共同对角化的 Pauli 方向，初始化必须拒绝这条局部逆快速路径。

## 8. dlog DE 与主积分同步输出

入口拟定为 `MSDLogDE[context]`，返回：

- `masters`、`bareMasters`、`masterCount` 和顺序 digest；
- 每个 sector 的 diagonal block、letters 和 residue matrices；
- parent-to-child contact blocks 及其 source event；
- 完整 block-triangular `omegaPotential`、`letterMatrices`；
- normalization gauge 项；
- `dlogStatus`、`dlogResidual` 与未认证原因。

固定 sector diagonal block直接由同一个 building-block registry、全局 `U_s`、`M1(A+1)` 和 `log(kappa)` 组装。也就是说 dlog DE 已经是 registry 的直接公式输出，不需要先生成或求解大规模 IBP 系统。非对角块必须使用 parent 的 `R^(1)`：

1. 生成 raw contact target 和精确 child shift；
2. 验证 child shift 为零，或用 child recurrence 约到其主积分；
3. 乘 parent 的 transformed log kernel；
4. 乘 `N_parent/N_child`；
5. 检查每个 `Log[letter]` 的系数是否为运动学无关常数。

本包使用 `(-tau)^A`。把 parent raising row 写成

```text
M0 J(A+1) = M1 J(A) - R,
```

则参数微分中的 contact 项是 `+I M0^-1 R`。因此把 2401.00129 的 `tau^nu` 公式适配到本包时，top-to-sub potential 必须包含该整体符号。这个符号已由单 massless full edge 的定义积分有限差分检验，当前公式的 residual 只剩有限差分误差。

只有所有 block 都通过第 5 步，才返回 `dlogStatus -> "certifiedByFormulaChecks"`。若 normalization ratio、shift reduction或共同 theta 使 residue 依赖运动学，仍返回完整 connection candidate 和 obstruction，但状态为 `"requiresGaugeTransformation"`，不把它称为 dlog DE。

这一块的论文 authority 是 2401.00129 第 3.7.2 节的 Eq. (3.65)、(3.68)：subsector master 特意包含 pinching 产生的动量/时间幂 prefactor，因而 top 对 sub 的系数仍是 dlog。`reference/ref_code/codebubble/Omega_tau_generator.m` 中的 `buildTopToSubsectorBlock` 实现了相同的 bit 删除、补 `1-bit`、`(-1)^bit` 和两端点求和结构，并由 `OmegaTopToR1/OmegaTopToR2` 组装 bubble 的 off-diagonal block；该文件注释把来源误标成 Eq. (3.27)，新包不得沿用这个错误编号。

## 9. H/h/time-only 变换

公开局部矩阵：

```wl
MSHTohMatrix[nu,z,context]
MShToHMatrix[nu,z,context]
```

其中

```text
T(H->h) = {{z^nu, 0}, {nu z^(nu-1), z^nu}}.
```

这里 `nu` 是本包输入的 magnitude；`NuConvention` 选择 prefactor exponent `+nu/-nu`，Hankel order 保持 `nu`。负 prefactor 时把上式中的 `nu` 换成 `-nu`。

`MSConvertBasis` 提供局部二态和全 sector 同序状态向量的正反变换。全 sector 变换按 slot registry 组装 Kronecker 矩阵，每个 massive endpoint 与 `masslessEndpointH` 使用自己的 `z=-k tau_component`；massless shared quotient 保持单位作用。`NuConvention` 只在 `MSInitTree` 时选择，全 sector 换基固定读取 context，不接受逐调用覆盖。已经积分后的 `MSIntegral` 还会同时改变 component base time power，首版没有独立的 H-family metadata，因此这一重载必须 fail closed，不能把非整数时间幂变化伪装成普通 bit 变换。

另提供 `MSIntegral[sectorKey,timeShifts,stateBits]` 与 dSIBP 020 `J[sectorKey,timeShifts,stateBits]` 的双向 adapter。adapter 只转换同一 sector/state-slot schema 下可唯一解析的对象；含 loop/ISP/b-slot 或不唯一 sector 的输入拒绝转换。

## 10. 边界条件 producer 与辅助能量流

### 10.1 阻尼变量与主积分数

写 `tau[v]=-t[v] < 0`，并把顶点纯指数统一记为

```text
Exp[I phaseSign[v] k0User[v] tau[v]],
phaseSign[v] in {+1,-1}.
```

沿相应 Wick 阻尼射线定义内部正变量

```text
K[v] = I phaseSign[v] k0User[v] > 0,
k0User[v] = -I phaseSign[v] K[v].
```

于是两种顶点指数都化为 `Exp[-K[v] t[v]]`。按参考文献交流时，`phaseSign=+1` 可写作 `k0 -> -I pik0`，`phaseSign=-1` 可写作 `k0 -> +I mik0`，其中 `pik0,mik0>0`；这些只是外部 notation，内部始终使用由初始化生成的 `phaseSign`、`K` 和稳定坐标 id。此前的 `K0=I k0` 只覆盖 `phaseSign=+1`，不再作为统一定义。

原图没有纯指数时，可加入一个辅助 `phaseExponent` 一维 block。它只给 `M0[v]` 增加 `I phaseSign[v] k0User[v] IdentityMatrix`，不改变 generic kinematics 下的 slot 数和主积分数，也不改变 `M1`。但 `K[v] -> 0` 是 family 的特殊化，只有通过全 sector 普通点检查后才可由普通点数值 DE 到达，不能从 generic 主积分计数直接推出零点仍为普通点。

### 10.2 多顶点 blow-up chart

直接给所有 root times 一个严格 rank 总序，并取相反的阻尼能量总序

```text
K[sigma[1]] >> K[sigma[2]] >> ... >> K[sigma[V]] >> 1.
```

采用嵌套坐标

```text
x[j] = K[sigma[j + 1]]/K[sigma[j]],  j = 1,...,V-1,
x[V] = 1/K[sigma[V]].
```

因此 `1/K[sigma[j]] = Product[x[r], {r,j,V}]`。`x -> 0` 是选定的无穷边界 chart。指数局域化给出 `Abs[tau[sigma[1]]] << ... << Abs[tau[sigma[V]]]`：大 `K` 对应小 `Abs[tau]`，而所有 `tau<0`，所以若 `K[u] >> K[v]`，则 `tau[u] > tau[v]`。于是 `Theta[tau[u]-tau[v]] -> 1`，反向 theta 趋于 0。任意图中的每个显式 theta 因而都固定为 `0/1`；要求循环不等式的 theta 乘积自动为零。`G++/G--` 的每个显式 theta 项都按其参数顺序应用此规则，不能只凭 SK 标签猜值。

### 10.3 Subsector 的继承规则

contact sector 中一个 component `C` 的阻尼能量和 rank 定义为

```text
K[C] = Sum[K[v], v in C],
rank[C] = Max[rank[v], v in C].
```

严格全序下，`K[C]` 由 `C` 内 rank 最大的 root vertex 主导。delta 合并只改变 component、base time power 和 contact normalization；边界 chart 始终由同一套 root rank 诱导，不能在每个 subsector 独立重选一个不兼容的 rank。剩余 theta 连接两个 components 时，比较它们各自主导 root 的 rank。

每个 sector 的边界按自己的 top sector 计算：先使用其 normalization 和 contact 后的 base time power，再把固定为 0/1 的 theta 分支拆成 component vertex families。bottom sector 先算；parent 的非齐次边界再由 block-triangular Frobenius leading system 或等价的 theta/delta 端点展开递归确定。不能只给 top homogeneous product 而遗漏 lower-sector solution 对 parent components 的领先贡献。

### 10.4 非退化证书

由 sector diagonal 公式，任意运动学 letter 都是 component 指数能量加 signed line energies。由 2401.00129 Eq. (3.68) 的 top-to-sub 公式，非对角块只用 parent 的同一组 `Log[kappa]` 乘常数 contact map，不产生新 log argument；若 child shift 需要递推，只会再引入 child sector 的同型 letters。因此对 contact DAG 归纳后，完整 connection 的每个含 `K` 分母均有一般形式

```text
D[alpha,s] = Q[alpha,s] + Sum[c[alpha,s,v] K[v], v],
```

其中 `c` 与运动学无关，且 support 非空。sector diagonal 的特殊情形是 `c[v]=1` 当且仅当 `v` 属于 component `C`。令 `sigma[jLead]` 是严格能量总序中 `c != 0` 的第一个 root，则

```text
D[alpha,s] = K[sigma[jLead]]
  (cLead + Sum[higher-rank x monomials] + Q/K[sigma[jLead]]).
```

括号在 `x=0` 等于非零常数 `cLead`。因此传播子图是否有圈不影响证明；contact 只改变 coefficient support 或把多个 root 合成 component。对 component letter 可具体写成

```text
kappa[C,s] = -I K[C] + signedEnergy[C,s]
           = -I K[vLead] (1 + higher x monomials),
```

其中括号在 `x=0` 为非零常数。因此严格 rank chart 把所有含 `K` 的无穷边界 letters 化成 coordinate monomial 乘 unit。不同 letters 重复出现的 coordinate hyperplane 只算同一个 divisor，边界约化后至多剩 `V` 个 normals，正是 normal crossing。实现采用以下足够而易审计的证书：

1. 汇总完整 block-triangular DE 的所有 sector diagonal、contact block、normalization gauge 和路径 Jacobian 中出现的 irreducible divisor；
2. 代入 blow-up chart，逐个抽出 `Product[x[i]^ni]`；
3. canonicalize 并去重后，要求每个 strict transform 在 `x=0` 非零；
4. 若 strict transform 仍在边界消失，则计算这些因子的 Jacobian。只有每个因子自身光滑且“消失 divisor 数 = normal rank <= 局部变量数”时才是 normal crossing；否则拒绝该 chart；
5. 对每个 contact-reachable sector 重复检查，不能只检查 top diagonal block。

这直接排除 `1/z1, 1/z2, 1/(z1+z2)` 在原点的三 divisor/二维 normal rank 退化；在嵌套 blow-up chart 中，目标是让第三个 strict transform 变成 unit。

该证明只讨论“所有 `K -> infinity` 同时发生”造成的退化。完全不含 `K` 的奇点已经显式列在现有 DE letters 中，不是边界 producer 的待解决障碍：缺省自动路径只接受普通点并绕开它们；package 不计算奇点上的发散值，也不替用户选择局部解析。用户若主动前往这些奇点，直接使用已输出的 DE 自行 blow-up。任意额外 gauge transformation 若引入超出上述 affine-linear letter 集的新分母，则该变换本身不能自动继承本定理。

### 10.5 `k0 -> 0` 与迭代约化奇异层

raising recurrence 使用 `M0^-1`，而

```text
Det[M0[C]] proportional to Product[kappa[C,s], s].
```

所以 `k0[v]=0` 并非自动普通。单条 full edge 的 top letters 是 `k0[u] +/- q`、`k0[v] +/- q`，但缩边 sector 还有 `k0[u]+k0[v]`；两辅助能量同时取零时，top 可非奇异而 child 必为奇异。更一般地，任一 sector component 在目标点没有剩余二维 slot且总指数能量为零时，必有零 letter。

`M1` 的 general-index 零层必须直接由其对角本征值枚举，而不是笼统标成边界发散。它只阻断使用 `M1^-1` 的 lowering；同一点若 raising 只使用 `M0^-1 M1`，则 `M1=0` 只令相应 numerator/rank 降低，不产生求逆 pole。反向地，`M0=0` 阻断 raising，却不阻断只使用 `M1^-1 M0` 的 lowering。程序返回方向、当前 shift、state bits、零本征值和原始 IBP constraint；不自动增加 master，也不把离散 shift resonance 混入共同 `K -> infinity` 边界。

若目标点落在 `M0=0`，普通递推和普通点输运停止，只允许在 generic `k0` 先约化后取受控极限，或由用户基于已输出 DE 另行处理该奇点。

### 10.6 自动边界到用户普通点

最终入口让用户按自己初始化时的符号给出一个目标普通点，并可另给 preferred 起点；两者都必须给齐所有顶点能量和所有传播子模长，package 对外继续使用用户的变量名交流。初始化保存可逆坐标映射，数值层才把顶点能量转换为内部 `K[v]=I phaseSign[v] k0User[v]`，把 line momenta 原样带入 signed-energy letters。程序按以下顺序工作：

1. 若用户给 preferred 起点，在 `Re[K[v]]>0` 的前提下按 `Re[K]` 从大到小选择首选 strict rank；相等时依次用 `Abs[K]` 和 root vertex order 确定性破缺。该能量降序对应 `Abs[tau]` 升序；
2. 对所有与 theta 相容的 strict charts 做普通点和 normal-crossing 证书；首选 rank 只是让 boundary 到 preferred point 的第一段尽量匹配该点的尺度层级，可能减少需要绕开的 letters，但不声称全局最优；
3. 生成所选无穷边界 chart，并由 2411.03088 的单 component `K -> infinity` 系数（按本包正 prefactor 统一执行 `nu -> -nu`）及 sector normalization，递归生成与 `MSDLogDE[context]["masters"]` 同序的边界数据；
4. 从 chart 内的小有限点出发，先到 preferred point（若提供），再到最终目标点；每一段都构造不穿任何 letter hypersurface 的路径；
5. 若某些顶点能量是辅助变量，优先逐个移除，并在每一步重做全 sector 普通点检查；只有检查通过才允许以普通点 DE 到达零；
6. 一旦零点是正则或更高奇点，返回 `singularAuxiliaryRemovalRequired` 及对应 DE letters，不得把它交给普通点 NDE；package 不替用户选择该奇点的 blow-up。

因此“先把所有辅助 `k0` 跑到零，再跑其它参数”只是条件性优化，不是缺省算法。安全缺省是保留非零辅助 anchor，或逐个移除且每一步通过全 sector 证书。

### 10.7 当前生产 Frobenius 边界

`MSBoundaryData[context,targetRules]` 只使用 2411.03088 的 $k_0\to\infty$ 数据，不计算有限点定义积分。包括单顶点 massive-external family 在内，所有已闭合 tree/time-only context 都统一使用 metadata producer：按 strict rank 构造 $K_{\sigma(j)}=B^{V-j+1}t^{-(V-j+1)}$，拉回完整 block-triangular dlog connection，求 $t=0$ residue，并对每个 sector master 使用自身 component base powers、normalization、slot/state order 与 theta fixing 计算物理 leading weight。ancestor-sector 线性系统给出与全局 master 顺序一致的 leading vector。Eqs. (3.44)--(3.46) 的单顶点显式多变量级数只保留为测试 oracle，不进入生产分派。

完整 power-log 递推不在 MadStree 重写。MMA 自动把每个 `{a,b,C}` 分支交给 FlintNDE 的 `frobenius_boundary`，从 $t=0$ 输运到 $t=1$；Gamma 等不属于 $\mathbb Q(\mathrm i)$ 的物理权重在返回 MMA 后相乘求和。测试专用定义积分只作为独立验证 oracle，不进入生产输入。

无质量指数二态的 theta contact 相对 2401 massive Wronskian 原子多一个负号。dlog producer 对 simultaneous event 按 `selectedLineIds` 中 `masslessFull` 的实际个数乘 $(-1)^{N_0}$；纯 massless 两顶点的两张定义积分 DE residual 因而 exact 为零。简并 indicial roots 不新增人为 branch 参数，FlintNDE 从完整 residue 自动完成共振递推。

## 11. 数值接口

数值层的现行公开接口为：

- `MSNumericalSystem[de,spec]`：低层手动入口，验证用户提供的同序 boundary vector 并生成列向量系统；
- `MSBoundaryData[context,targetRules]`：为任意已闭合 tree/time-only/vertex-family context 生成 exact 奇点分支数据；
- `MSEvaluatePath[context,pointSequence]`：识别最大连续复仿射单变量段、逐段拉回，并在一次请求中委托 FlintNDE 规划与输运；
- `MSExportEvaluationData[evaluation]`：导出普通保存点的 CSV/JSON。

任何经过中途节点的多点输运都称为折跃；只有显式穿过奇点并使用局部基连接两侧匹配点时才称为奇点折跃。`SingularityMode -> "Avoid"` 是缺省，命中奇点时返回问题线段与奇点；只有 `SingularityMode -> "SingularityJump"` 才允许奇点折跃，并提示用户确认等价绕行类的多值分支。`MessageLanguage` 缺省 `"EN"`，可选 `"CN"`；两个选项都严格拒绝其它值和宽松大小写。

用户点只允许裸坐标或 `{coordinate,"tmp"}`：前者缺省保存，后者是临时途经点。执行结果携带坐标、数值、状态和用户序号；普通保存点由 `MSExportEvaluationData` 导出。

每段拉回系统由 MadStree 构造后交给 FlintNDE。`FlintNDEPathPlanning -> True` 使后端规划节点，并把同一节点覆盖的用户点组成 evaluation bucket；大桶用子积树/余数树快速多点求值，小桶用 iterative 算法。`False` 严格把用户点作为节点且不调用规划器。若全部 dlog letters 在该段均为常量，其导数全为零，合法系统就是无有限极点的零连接。

FlintNDE 的位置只由 `$MSFlintNDERelativePath` 定义，缺省为版本目录内的 `Vendor/FlintNDE`（与独立 FlintNDE 0.4.0 同步）；`MSSetFlintNDERelativePath` 可显式覆盖。adapter 只接受当前单请求 schema `madstree_flintnde_evaluate_v1`。临时 JSON 写入调用脚本目录的 `results_temp/`；成功后删除。Python cache 由 Git 忽略，版本源码目录不接收用户结果。
自动入口不猜测额外的 late-time 常数；它严格使用初始化时固定的 Hankel/SK branch、sector normalization 和论文 endpoint coefficients。手动入口未给 boundary data 时仍返回结构化 `Missing["BoundaryData"]`。dlog/chart 未认证、late-time 指数不衰减、拉回奇点非 exact/Fuchsian 或 FlintNDE capability preflight 失败时均 fail closed；能力边界不再用图名或固定维数描述。

## 12. 模块与公开接口

目录和职责：

```text
package-MadStree/versions/MadStree-v0.11/
  VERSION.md
  README.md
  Documentation/DEVELOPMENT_PLAN.md
  Kernel/init.m
  Kernel/MadStree.wl
  Kernel/Core/Conventions.wl
  Kernel/Core/Topology.wl
  Kernel/Core/Sectors.wl
  Kernel/Core/Representation.wl
  Kernel/Formula/TensorAtoms.wl
  Kernel/Formula/Recurrence.wl
  Kernel/DE/DLog.wl
  Kernel/Numerics/Configuration.wl
  Kernel/Numerics/Boundary.wl
  Kernel/Numerics/Numerics.wl
  Kernel/Numerics/FlintNDE.wl
  Kernel/Numerics/PathEvaluation.wl
  Backend/flintnde_transport.py
  Documentation/tree_formula.tex
  Documentation/tree_formula.pdf
  Documentation/references.bib
  Examples/
  test/results_test/
```

现行公开接口包括初始化、结构、公式、边界、输运和导出六层：`MSInitTree`、`MSInitTimeGraph`、`MSInitVertexFamily`、`MSContextQ`、`MSSectors`、`MSSlotRegistry`、`MSIntegral`、`MSMasterIntegrals`、`MSFormulaMatrices`、`MSFormulaData`、`MSWriteFormulaArtifacts`、`MSContactMaps`、`MSRecurrenceStep`、`MSReduce`、`MSDLogDE`、`MSHTohMatrix`、`MShToHMatrix`、`MSConvertBasis`、`MSToDSIBPJ`、`MSFromDSIBPJ`、`MSFromDSIBPExpression`、`MSNumericalSystem`、`MSBoundaryChartCertificate`、`MSBoundaryData`、`MSFlintNDEConfiguration`、`MSSetFlintNDERelativePath`、`MSEvaluatePath` 和 `MSExportEvaluationData`。

内部函数按物理含义命名；不以数字后缀区分操作，不为不同 sector 或 fold 数复制实现。

## 13. 实现阶段

### Phase A：结构与 convention

- 迁入 tree formula note，并把摘要/前言改为 MadStree 的公式手册；使用指南标为接口稳定后补。
- 建立 package loader、公开 symbol 和结构化错误。
- 实现 topology validation、sector DAG、base-power 约束和 slot registry。

验收：给定小树可确定性输出 sector、component、slot、维数和主积分顺序；重复初始化结果完全相同。

### Phase B：矩阵与主积分

- 实现张量原子、`M1/M0/U`、energy letters、sector masters。
- 实现 massless `4->2` embedding/projection 与 package quotient endpoint/contact 原子。

验收：`P.S==I2`；两端 generator 符号相反；每个无 theta 指数有稳定 block id；正/负顶点的 `phaseSign` 只改变 signed energy 和用户坐标 Jacobian；单顶点任意 fold 与参考 `Tn/M1n/M0n/Omegan` 的适用子集一致。

### Phase C：contact 与递推

- 实现 raw/master contact map。
- 实现单步 raising/lowering 和 DAG 递归约化。
- 对每个 contact 显示 source shift、target shift 和 base-power 推导。
- 对每个 state 显示方向敏感的 `M1` lowering resonance 与 `M0` raising letter；同时为零时返回原始 rank-deficient constraint，不自动改变 master basis。

验收：bubble 的 raw `R^(0)` 为 child `-1` shift，`R^(1)` 为 child `0` shift；无 contact sector 的升降一步互逆；递归不残留非目标 shifted integral。

### Phase D：dlog DE

- 按 Eq. (3.65)、(3.68) 组装 sector diagonal 和 parent-to-child blocks，并把 `buildTopToSubsectorBlock` 仅作为 bubble specialization oracle。
- 同步输出 master list、offset 和 digest。
- 做 constant-residue、normalization ratio、block-triangular 和 exact residual 检查。
- 对每个二维 slot 检查所有 vertex-local Pauli directions 共线；只有通过共同对角化条件时才使用逐 letter 取逆的快速路径。
- 非零 `R^(1)` child shift 逐列调用 `MSReduce`，抽取到全局 master order 的 reduction matrix 后右复合 contact block；任何 residual/remaining shift 返回 `contactShiftReductionFailed`。

验收：pure massive two-vertex 适用子集与参考 `Omega_tau_generator.m` 同序比较；单 massless full edge 的 top 维数由 4 降为 2，subsector master 与 contact block 维数正确；所有声称 dlog 的 block residue 为常数。

### Phase E：变换、数值边界与文档

- 实现 H/h 局部基变换及 dSIBP 020 time-only adapter 的可逆子集。
- 固定手动数值系统接口；自动边界由 Phase F 独立实现。
- 补 README 和最小 examples；完整使用指南待接口稳定后写入手册。

### Phase F：任意 time graph 的边界 producer 与自动路径

- [x] 删除生产有限 Euclidean 定义积分路线；定义积分只保留在独立验证目录作为 oracle。
- [x] 集中配置版本内 `Vendor/FlintNDE` 0.4.0 相对路径，并完成 exact $\mathbb Q(i)(s)$ 序列化、普通点检查、adaptive path 和 refinement 输运。
- [x] 实现所有 root times 的 nested blow-up、theta 固化、component rank 继承和全 sector normal-crossing 机器证书；`MSBoundaryChartCertificate[...,RankOrder->All]` 可检查全部 strict charts，`MSBoundaryData` 强制消费所选证书。
- [x] 实现 2411.03088 单顶点边界系数、state order 与 normalization；实现由完整 sector DAG、component/slot metadata 和 strict rank 驱动的通用 multi-sector producer，并直接接入 FlintNDE 奇点模块。两顶点 massive `G++`、pure massless、mixed 三顶点和 triangle time-only context 共用该 producer；单顶点显式级数只作为测试 oracle 保留，不进入生产路线。
- [x] 实现裸坐标普通保存点、临时点与奇点 LO 点语义；二阶 pole 等未认证起点在普通输运前 fail closed。
- [ ] 实现逐个辅助顶点能量移除；singular auxiliary removal fail closed，并把 DE letters 交给用户自行处理。

验收：复现文献两顶点 chart `x=k34/k12, y=1/k34`、五维 leading system 和边界 factorization；正/负顶点分别以 `k0=-I pik0`、`k0=+I mik0` 得到同一 `Exp[-K t]`；preferred 点的能量降序与 time 尺度升序一致；单 massless full edge 的 top/child 零点判定正确；任意小树每个 sector 的 strict transforms 均通过 normal-crossing 检查；输出边界向量与 `MSDLogDE` master digest 完全一致。

### Phase G：time-only 圈图输入扩展

- [x] 在不引入 loop-momentum IBP 的前提下，由 `MSInitTimeGraph` 允许传播子 incidence graph 含圈，所有 line momenta 仍作为固定参数。
- [x] canonicalize contact 产生的 vertex partitions，处理多条收缩路径到同一 sector、active self-edge 和循环 theta 乘积归零。
- [x] 复用 Phase F 的 affine-linear denominator 证明和同一个 boundary producer，不复制 tree-only 路线。

验收：triangle time graph 和至少一个含平行边的圈图中，严格 time 总序把所有 theta 项化为 `0/1`；所有 reachable partitions 的 `K`-dependent strict transforms 都为 units；与直接被积函数 leading region 和公式 DE 的 divisor 集逐项一致。仍不运行或声称完成 loop-momentum integration。

## 14. 首轮检查矩阵

结构检查之外，版本化独立数值/文献验收统一登记在
`../../../independent-validation-task/MadStree-v0.5-independent-validation-task.md`。其中 2411.03088 两项必须显式使用
`NuConvention -> "Negative"`。v0.5 T1--T6 已 fresh 通过（v0.7 在 v0.6 基础上修改建立，v0.6 由冻结 v0.5 复制），计数依次为 `24/24`、`12/12`、`18/18`、`15/15`、`17/17`、`16/16`。

1. 单顶点 0-fold/1-fold/一般 p-fold：维数、bit order、`M1/M0/U` 和 letters。
2. 纯 massive 两顶点单 full edge：top/subsector master、`R^(0)/R^(1)` shift、block DE。
3. 单 massless full edge：四态 quotient、共享 slot、两端 regular/contact 符号、top `2` 个而非 `4` 个 master。
4. mixed 三顶点链：同一 massless slot同时进入两端 `M0`，sector DAG 和多级 contact 自动终止。
5. H->h->H：正/负 prefactor 下局部矩阵恒等；全 sector 状态向量在 massive 支持子集的 round trip residual 为零；`MSIntegral` 重载明确 fail closed。
6. dlog：矩阵维数等于 master 数；sector offsets 无间隙；非对角块只指向严格 lower sector；`omegaPotential` 对所有 `Log[letter]` 的 residual 为零。

### Phase H：连续同复直线分组与组内 dense output

- [x] 以多变量坐标向量的 exact 复线性相关为判据，把输入顺序中的连续点划为最大复仿射直线组；
  两点总能定义起始方向，后续点不共线时在前一公共端点断组。
- [x] 每组选择一个非零方向并求 exact 复参数 s_i；只构造一次 x(s)=x0+s v 的 dlog 拉回，
  将全部 s_i 一次性交给 FlintNDE。
- [x] 保存每个 userIndex 对应的 node snapshot 或 dense sample assignment。执行期只恢复计划，
  节点点取 snapshot，非节点点由对应节点缓存系数求值。
- [x] 不同复直线组不共享 Taylor/Frobenius 系数；避奇点和显式奇点折跃均沿各组的单变量
  复平面处理，转角处继承数值向量后重新拉回。
- [x] 开发测试和独立验证任务书使用 3*3*100=900 点二维复格点：固定 x1 时连续输入全部 300 个
  复数 x2 点且让不同实部序号依次出现。每个固定 x1 应识别为一个 x2 复平面组，不能按
  固定虚部拆成三条实直线；开发测试认证分组结构，任务书要求独立验证再与逐点单段输运
  比较准确性和总时间，当前尚未产生该独立验证报告。

验收：同线组数、实际节点、每节点覆盖 user indices 和 source（node/dense sample）均可审计；
900 点结果按 userIndex 完整返回，且执行不重新规划。

## 15. 明确未认证项

- 不能从“输入是 tree/time-only graph”单独推出所有数学门禁必然成立。通用 producer 只消费 context metadata，不按图名分派；每个具体 context 仍必须通过公式/dlog closure、strict-rank normal-crossing、late-time 衰减与 exact regular-singular pullback 证书，否则结构化 fail closed；
- 当前独立/开发检查覆盖单顶点 massive、两顶点 massive $G_{++}$、pure massless、mixed 三顶点和 triangle time-only 等结构，但不据此宣称任意维数下的数值效率、所有参数区域或所有一般 $\nu$ 情形已经穷尽认证；
- 任意 mixed normalization 若需要额外 gauge transformation 才得到 constant-residue dlog，仍不自动构造该 gauge；
- 辅助 `k0=0` 若为奇点则不自动取极限；package 只返回现有 DE letters，由用户自行选择 blow-up；
- time-only 圈图的 loop-momentum integration；当前只认证固定内部动量参数的 time integrals；


这些项目在得到专项推导和独立检查前必须以状态字段暴露，不能被默认成功值掩盖。
