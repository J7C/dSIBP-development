# dS IBP 独立 benchmark 推导任务书

> **用途边界**：本文是交给其它 AI 的独立推导任务说明书，所在的 `independent-benchmark/` 目录只保存任务输入。不要把本项目的手推答案、expected、check 或运行产物写入此目录。独立推导者应把结果输出到自己的新目录，维护者审查后再决定是否导入项目。

## 1. 任务目标

从本文给出的费曼规则、指标 convention 和函数族定义出发，独立推导小型 dS IBP seed，用来反查当前开发主线 `000_code/009_dS_ibp_general.wl`。独立推导时禁止读取主线代码、`000_code/check/`、旧 expected 或已有运行结果。

只做 seed-level 小型符号推导：

- 不生成大范围解析 IBP。
- 不做大范围撒点。
- 不运行 Kira、Fermat、Rational Tracer 或其它 reduction。
- 解析 seed 保持非零符号 zero-point。
- 每个函数族必须覆盖所有顶点 `+/-`、所有实际可达 sector、每个 sector 的全部 time 与 loop-momentum 生成元，以及全部适用离散 `n=0/1` 状态。
- 任何 massive `n=2` 一出现就立即 EOM；massless 正式表示从不产生 `n=2`。

## 2. 自包含的 SK 费曼规则与 building block

本文后续所有 family 都使用本节约定；独立推导者不得改用另一套相位或端点顺序。

### 2.1 基本符号与被积函数

顶点按固定顺序 V={v1,...,vV} 排列。把顶点分支写成数值 s[v]=+1 或 -1，并用同一顺序的字符串记录一个 sign case。例如 {+1,-1,+1} 记为 "+-+"。

内线 e 的有序端点、向量动量和模长定义为

    endpoints[e] = {u[e],v[e]}
    Q[e] = Sum[c[e,l] q[l],l] + Sum[d[e,j] k[j],j]
    x[e] = -q[e] tau
    q[e] = Sqrt[sp[Q[e],Q[e]]]

其中第一端点永远是 u[e]，第二端点永远是 v[e]。端点顺序不是无关 metadata：massive 的 n[e,1]/n[e,2] 和 massless 的有向 n[e] 都依赖它。

去掉与 IBP 无关的整体耦合常数后，一个 top-sector 被积函数统一理解为

    Product[d tau[v] (-tau[v])^A[v] Exp[-I s[v] E[v] tau[v]],v]
    Product[d^d q[l],l]
    Product[q[e]^(-B[e]) PropagatorBlock[e],e]
    Product[ISP[r]^ispN[r],r]

其中 A[v]=a[v]+a0[v]，B[e]=b[e]+b0[e]。顶点相位和导数固定为

    s[v]=+1: Exp[-I E[v] tau[v]],  d/dtau[v] -> -I E[v]
    s[v]=-1: Exp[+I E[v] tau[v]],  d/dtau[v] -> +I E[v]

只进入顶点相位的 E[v] 不自动属于 externalMomenta。对一个固定的 `vertexSigns` case，SK contour 顶点因子、耦合常数、整体动量守恒 delta、1/2、pi 和其它不依赖积分变量的 normalization 都是整条齐次 IBP 的共同因子，统一提出且不写入 `J`。不得把这些共同因子误当成端点导数符号；不能提出的是 theta 导数的相对符号和 massive shrink 的 Wronskian prefactor。

所有时间积分均在 `tau[v] in (-Infinity,0)` 上理解，并假设解析正规化或通常的 `i epsilon` 处方使全微分边界项为零。Heaviside 分布固定采用

```text
d theta(x)/dx = delta(x),
theta(x)+theta(-x)=1,
theta(0)=1/2.
```

最后一式只固定 coincidence 的对称取值；不得在 seed 中产生 `delta^2` 或对已经 shrink 的 theta 再求导。

本文直接使用 Mathematica 标量积头 sp，并固定

    SetAttributes[sp, Orderless];

这只表示 sp[p,r]=sp[r,p]，不表示图或积分族对称性。

### 2.2 Massive h building block、ODE 与导数

质量参数采用

    nu[e]^2 = m[e]^2/H^2 - d^2/4

并只考虑纯实 nu 或纯虚 nu。令 x=-q tau>0。归一化 building block 定义为

    h1(nu,0,x) = x^(-nu) HankelH1[nu,x]
    h2(nu,0,x) = x^(-nu) HankelH2[Conjugate[nu],x]
    hs(nu,1,x) = d/dx hs(nu,0,x),  s=1,2

等价地，hs(nu,1,-q tau)=-(1/q) d/dtau hs(nu,0,-q tau)。对允许的纯实或纯虚 nu，两个 hs 都按本 family 的 nu 参数满足同一方程

    d_tau^2 h + (2 nu+1)/tau d_tau h + q^2 h = 0

或

    d_x^2 h + (2 nu+1)/x d_x h + h = 0.

必须使用的一阶递推为

    d_tau h(nu,0,-q tau) = -q h(nu,1,-q tau)

    d_tau h(nu,1,-q tau)
      = -q ((2 nu+1)/(q tau) h(nu,1,-q tau)
            - h(nu,0,-q tau))

    d_q h(nu,0,-q tau) = -tau h(nu,1,-q tau)

    d_q h(nu,1,-q tau)
      = -tau ((2 nu+1)/(q tau) h(nu,1,-q tau)
              - h(nu,0,-q tau)).

若 family 使用裸 Hankel H 模式，则把 EOM 系数 2 nu+1 改为 2 nu；其余端点和 SK 记号不变。

正式 seed 只允许 n=0,1。任何 massive n=2 一出现，立即应用

    J[...,n[e,r]=2,...]
      = -c2[e] J[...,n[e,r]=0,...]
        -c1[e] J[...,a[u_r]-1,b[e]+1,n[e,r]=1,...]

其中 h 模式 {c1,c2}={2 nu[e]+1,1}，H 模式 {c1,c2}={2 nu[e],1}，u_r 是发生导数的有序端点。另一端点的 n 不变。此式是 benchmark 的正式 EOM 指标规则；不得把 n=2 留给后端。

### 2.3 Massive 四种 SK 传播子

对有序端点 {u,v}，令 Delta=tau[u]-tau[v]，并定义去掉 coefficient-only normalization 的 Wightman blocks

    WGreater[e] =
      h1(nu[e],n[e,1],-q[e] tau[u])
      h2(nu[e],n[e,2],-q[e] tau[v])

    WLess[e] =
      h2(nu[e],n[e,1],-q[e] tau[u])
      h1(nu[e],n[e,2],-q[e] tau[v]).

四种 SK kernel 固定为

    G++ = theta[ Delta] WGreater + theta[-Delta] WLess
    G-- = theta[-Delta] WGreater + theta[ Delta] WLess
    G+- = WLess
    G-+ = WGreater.

因此同分支 ++/-- 是 massiveFull，可由 theta 导数 shrink；异分支 +/-/-+ 是 massiveCross，没有 theta shrink，但两个端点仍各有 n[e,1],n[e,2]。

massiveFull 只在 n[e,1]+n[e,2]=1 时产生 Wronskian shrink。端点 r 的正式系数为

    C[e] (-1)^(n[e,r]+Vpm)
    Vpm=1 for ++
    Vpm=0 for --
    C[e]=(4 I/Pi) Exp[Pi Im[nu[e]]].

这不是可由推导者任意选择的符号。只有 familyDefinition 明确给出 thetaBoundarySignOffset 覆盖时才可改变默认 Vpm。

### 2.4 Massless 四种 SK 传播子与全部正负号

对 massless 线仍使用有序端点 {u,v} 和 Delta=tau[u]-tau[v]。去掉共同 1/(2 q) 后，四种 kernel 固定为

    D++ = theta[ Delta] Exp[-I q Delta]
        + theta[-Delta] Exp[+I q Delta]

    D-- = theta[ Delta] Exp[+I q Delta]
        + theta[-Delta] Exp[-I q Delta]

    D+- = Exp[+I q Delta]
    D-+ = Exp[-I q Delta].

因此 masslessFull 的 sigma 定义没有自由度：

    sigma=+1 for ++
    sigma=-1 for --.

masslessCross 可统一写成

    D[s[u],s[v]] = Exp[I s[u] q Delta],  s[v]=-s[u].

于是 cross line 在每个端点的 time 导数系数就是该端点的分支符号：

    + endpoint: +I q
    - endpoint: -I q.

其模长导数为

    d_q Dcross = I s[u] Delta Dcross.

masslessFull 的两个正式状态 M[0],M[1]、theta-delta 项和端点反转规则在第 4 节给出。这里先固定最容易混淆的结论：第一端点是 n=1 的参考方向；++/-- 的 sigma 取值如上；+/- 与 -/+ 没有 n、theta 或 shrink。

### 2.5 外腿能量、外部向量与输出不变量

externalMomenta 只列实际进入某个 Q[e] 并与圈动量形成 scalar-product 空间的独立外部向量。顶点相位能量 E[v] 分两类：

- 若它属于 externalMomenta 张成的不变量，写成相应 s[i,j] 的函数；
- 若它只在时间相位中出现，写成独立 ke[i]。

例如 |p1+p5| 若是一个独立模长，必须定义为新的 ke[3]，不能写成 ke[1]+ke[2]。外动量-外动量标量积输出为用户给定变量或默认 s[i,j]，不保留为 sp[k[i],k[j]]。


## 3. 统一积分表示

所有 sector 使用

```mathematica
J[aList, linePacks, ispList]
```

- `aList`：当前 sector 的 active/merged 顶点时间幂次。delta 合并顶点后只保留一个代表顶点的 `a`。
- massive full/cross：`{b[e],n[e,1],n[e,2]}`。
- massless full：`{b[e],n[e]}`。
- massless cross：`{b[e]}`。
- shrunk line：`{bS[e]}`。
- ISP 指标只写在第三槽。

质量、SK 分支、顶点能量、外不变量、zero-point 和 shrink prefactor 都属于 family 初始化信息，不写进指标槽。

实际时间和线幂次分别为

```text
A[v]  = a[v]  + a0[v]
B[e]  = b[e]  + b0[e]
BS[e] = bS[e] + bS0[e]
```

除旧 reference bubble 的单独 reference 对照外，所有新 benchmark 的 `a0/b0/bS0` 必须保持非零符号参数。连续整数指标可以在基点取 0，但不能把 zero-point 也取 0。

## 4. 有序 massless 单 n convention

对同分支 massless full line，`lineData["endpoints"] -> {u,v}` 是有序输入。第一端点 `u` 定义反对称 `n=1` 的方向。令 `Delta=tau[u]-tau[v]`，`sigma=+1` 对应 `++`，`sigma=-1` 对应 `--`：

```text
M[0] = theta[ Delta] exp[-i sigma q Delta]
     + theta[-Delta] exp[ i sigma q Delta]

M[1] = -theta[ Delta] exp[-i sigma q Delta]
     +  theta[-Delta] exp[ i sigma q Delta]
```

交换端点时 `M[0]` 不变、`M[1]` 变号。旧双端点标签只允许用于中间推导：

```text
{10} = -{01}
{20} = {02} = -q^2 {00}
{11} = +q^2 {00}
```

正式指标只保留 `n=0,1`。端点导数为

```text
d_u M[n] =  i sigma q M[1-n] - 2 n delta(tau[u]-tau[v])
d_v M[n] = -i sigma q M[1-n] + 2 n delta(tau[u]-tau[v])
```

因此：

- regular time 导数：`{b,n}->{b-1,1-n}`；
- 第一端点系数 `+i sigma`，第二端点 `-i sigma`；
- 同一端点连续求导两次回到原 `n`，regular 部分系数为 `-1` 且 `b->b-2`；
- 只有 `n=1` 产生 theta-delta；第一端点 shrink 系数为 `-2`，第二端点为 `+2`；
- massless shrink 使用 `bS=b`、`bS0=b0`，无 Hankel prefactor 或 `nu` zero-point shift；
- 模长导数为 `d_q M[n]=i sigma (tau[u]-tau[v]) M[1-n]`；
- 缩并后两原端点重合时，同一个 time 生成元必须同时作用两端：regular 的 `+i sigma/-i sigma` 相消，theta-delta 的 `-2/+2` 相消，反对称 `n=1` 状态为零；
- top 方程产生 sub-sector 项后，必须根据该输出 `J` 的单元素 shrunk packs 重建目标 sector 代表顶点映射，再应用 coincident canonical。

massless cross line 没有 theta、没有离散 `n`、没有 shrink。其每个端点的 time regular 导数系数由该端点分支决定：`+` 端点为 `+i`，`-` 端点为 `-i`，并令 `b->b-1`。对有序端点 `{u,v}`，其模长导数系数为 `i s[u] (tau[u]-tau[v])`。

## 5. Massive 导数、EOM 与 shrink

massive full/cross 在两个端点各保留 `n[e,1],n[e,2]`。time 导数作用在端点 `r` 时先产生

```text
- J[..., b[e]-1, n[e,r]+1, ...]
```

若出现 `n[e,r]=2`，立刻使用

```text
J[..., n_r=2, ...]
 = -c2[e] J[..., n_r=0, ...]
   -c1[e] J[..., a[r]-1, b[e]+1, n_r=1, ...]
```

其中：

- h 模式：`{c1,c2}={2 nu[e]+1,1}`；
- H 模式：`{c1,c2}={2 nu[e],1}`。

EOM 只改变发生二阶导数的端点指标；另一端点状态保持不变。

massive full 的 theta boundary 只在 `n1+n2=1` 时出现。系数必须严格使用第 2.3 节的 `C[e] (-1)^(n_endpoint+Vpm)`，其中 `Vpm=1` 对 `++`、`Vpm=0` 对 `--`；massive cross 没有 theta shrink。

massive h shrink：

```text
aMerged      = a[u] + a[v] - 1
a0Merged     = a0[u] + a0[v] - 2 nu[e]
bS[e]        = b[e] + 1
bS0[e]       = b0[e] + 2 nu[e]
```

massive H shrink 的整数关系相同，但两个 `2 nu[e]` zero-point shift 均为 0。多线 shrink 时按每个连通合并类累加顶点 zero-point，并乘所有 massive shrink prefactor。

## 6. Time-IBP

对每个当前 sector 的 active vertex `v` 推导

```text
0 = integral d/dtau[v] (integrand)
```

必须同时包含：

1. 顶点幂次：`-A[v]` 乘 `a[v]->a[v]-1` 的积分。
2. 外腿相位：
   - `+` 顶点使用 `exp[-i E[v] tau[v]]`，导数为 `-i E[v]`；
   - `-` 顶点使用 `exp[+i E[v] tau[v]]`，导数为 `+i E[v]`。
3. 所有连接到该 active vertex 的 massive/massless building block 端点导数。
4. 所有适用 theta-delta shrink 项。
5. EOM 和 coincident massless canonical。

缩并后若某条未缩并线的两个原端点都映到同一个 active vertex，对该 active time 求导时两个端点贡献必须都算；不能只取第一个匹配端点。

## 7. Loop-momentum IBP

设圈动量数为 `L`，会进入内线动量的独立外动量数为 `K`。完整生成元为

```text
O[l,v] = d/dq_l . v
v in {q_1,...,q_L,k_1,...,k_K}
```

总数 `L(L+K)`，必须全部推导：

- `d/dq_l.q_l`；
- `d/dq_l.q_m`，`m!=l`；
- `d/dq_l.k_j`。

每条关系必须包含：

1. `v=q_l` 时的空间维数 divergence 项。
2. 所有 line denominator 幂次导数，包括 shrunk line 的 `BS[e]`。
3. massive building block 对线动量模的导数。
4. massless full/cross 指数核对线动量模的导数。
5. ISP 因子自身的导数，以及标量积因子吸收到 propagator/ISP 指标后的移位。
6. 立即 EOM/canonical。

用户端标量积统一写 `sp[p,r]`，且 `sp` 对称。这里仅指标量积交换性，不是图或积分族指标对称性。用户可给圈动量任意符号名。外动量-外动量标量积在输出中使用用户定义变量或默认 `sij`，不保留成 `sp[k_i,k_j]`。

`externalMomenta` 只包含会与圈动量纠缠的外动量。只进入顶点时间相位的外腿打包能量用 `ke[i]`；`|ke1+ke2|` 若是独立模长，应记为新的 `ke[3]`，不能自动等于 `ke[1]+ke[2]`。

## 8. Sector 覆盖

对每个顶点符号 case：

1. 先根据端点分支判断每条 full line：
   - massive 同分支：massiveFull，可 shrink；
   - massive 异分支：massiveCross，不 shrink；
   - massless 同分支：masslessFull，可 shrink；
   - massless 异分支：masslessCross，不 shrink。
2. 枚举所有 theta-full 线的 shrink 子集，包括 top 空集。
3. 每个 sector 重新确定 active/merged vertices、compact `aList`、coincident endpoints 和剩余离散变量。
4. 每个 sector 必须覆盖全部 active time 生成元、全部 `L(L+K)` momentum 生成元和该 sector 全部离散 `0/1` 状态。
5. 即使某条 canonical 关系变成 0，也保留记录并注明原因。

不要给 cross line 伪造 shrink sector，也不要只按全 `+` case 的 sector 表套用到其它 SK case。

## 9. 必推函数族

### 9.0 每个 family 必须采用的固定定义

独立推导者不得自行补猜 topology 或 notation。每个 `family.wl` 必须先定义一个一层 `Association`：

```mathematica
familyDefinition = <|
  "name" -> "...",
  "vertexOrder" -> {...},
  "vertexSignCases" -> <|"..." -> {+1,-1,...}, ...|>,
  "loopMomenta" -> {...},
  "externalMomenta" -> {...},
  "externalInvariantRules" -> {...},
  "vertexEnergies" -> <|v1 -> E1, ...|>,
  "lineOrder" -> {...},
  "lineData" -> {...},
  "ispData" -> {...},
  "zeroPointRules" -> {...},
  "topIntegralTemplate" -> HoldForm[...],
  "sectorNaming" -> "...",
  "generatorList" -> {...},
  "symmetryRules" -> {...}
|>;
```

`lineData` 中每条线必须逐项写明 `id`、`endpoints`、`momentum`、`massType`、`bbType` 和 `nu`。`endpoints->{u,v}` 是有序数据；对 massless 线，第一端点 `u` 就是 `n=1` 的正方向。即使所有线连接同一对顶点，也不允许省略该字段。

本文统一使用下列动态 pack 规则：

```text
massiveFull 或 massiveCross: {b[e],n[e,1],n[e,2]}
masslessFull:                 {b[e],n[e]}
masslessCross:                {b[e]}
shrunk:                       {bS[e]}
```

各 family 数据块后展示的 top notation 就是 `topIntegralTemplate` 必须保存的值。它必须分别展示同分支与异分支时实际的 `J`，不能只写一个无法判断 pack 长度的占位符。ISP 被积函数约定为 `ISP[r]^ispN[r]`，故正 `ispN` 表示 numerator 幂，并按 `ispData` 顺序放入 `J` 第三槽。

sector 名统一为 `"top"` 或按 `lineOrder` 排序的 `"e1"`、`"e1_e3"` 等。某 sign case 只枚举该 case 中 full 线的 shrink 子集；cross 线永不出现在 sector 名中。缩并后以 `vertexOrder` 中序号最小的顶点作为合并类代表，`aList` 按代表顶点的原顺序排列。

生成元标签统一为 `dtau[v]`、`dqq[i,j]` 和 `dqk[i,j]`，分别表示

```text
d/dtau[v],  d/dq[i].q[j],  d/dq[i].k[j].
```

它们是 expected 中 `"generator"` 字段的人类可读标签；不得改成无含义的整数编号。

### 9.1 atomic_massless_line

固定定义：

```mathematica
vertexOrder = {v1,v2};
vertexSignCases = <|
  "++"->{+1,+1}, "--"->{-1,-1},
  "+-"->{+1,-1}, "-+"->{-1,+1}|>;
loopMomenta = {ell};
externalMomenta = {};
externalInvariantRules = {};
vertexEnergies = <|v1->E1,v2->E2|>;
lineOrder = {1};
lineData = {
  <|"id"->1, "endpoints"->{v1,v2}, "momentum"->ell,
    "massType"->"massless", "bbType"->"exp", "nu"->0|>
};
ispData = {};
zeroPointRules = {
  a0[v1]->alpha1, a0[v2]->alpha2,
  b0[1]->beta1, bS0[1]->beta1
};
generatorList = {dtau[v1],dtau[v2],dqq[1,1]};
symmetryRules = {};
```

同分支 top、异分支 top 和同分支 shrink 的 notation 分别为

```mathematica
J[{a1,a2},{{b1,n1}},{}]
J[{a1,a2},{{b1}},{}]
J[{a12},{{bS1}},{}]
```

sector 为：`++/-- -> {top,e1}`，`+-/-+ -> {top}`。另建端点反转子例，只把 line 1 改为 `endpoints->{v2,v1}`；物理动量和其它输入不变，必须检查 `n=0` 不变而 `n=1` 变号。

专测：

- `n=0/1 × 第一/第二端点`；
- `++/--/+-/-+`；
- 端点反转；
- 同端点二阶导数；
- theta-delta `-2/+2`；
- massless shrink `bS=b`；
- coincident `n=1` 为 0；
- massless full/cross 的 momentum 指数核导数；
- 顶点外部相位符号。

### 9.2 atomic_massive_line

固定定义与 9.1 相同，但 line 1 改为

```mathematica
lineData = {
  <|"id"->1, "endpoints"->{v1,v2}, "momentum"->ell,
    "massType"->"massive", "bbType"->mode, "nu"->nuM|>
};
modeCases = {"h","H"};
zeroPointRules = {
  a0[v1]->alpha1, a0[v2]->alpha2, b0[1]->beta1
};
```

top 与 shrink notation 为

```mathematica
J[{a1,a2},{{b1,n11,n12}},{}]
J[{a12},{{bS1}},{}]
```

massive cross 的 top notation 与 full 完全相同，但没有 `e1` sector。sector 为：`++/-- -> {top,e1}`，`+-/-+ -> {top}`。`generatorList={dtau[v1],dtau[v2],dqq[1,1]}`，`symmetryRules={}`。h/H 的 shrink zero-point 不另猜，严格使用第 5 节公式。

分别测试 h/H：

- 两端点 `n=0/1`；
- time 导数后的即时 EOM；
- `n1+n2=1` 的两个端点 Wronskian sign；
- full/cross 区别；
- h/H shrink zero-point；
- 缩并后 compact `a`。

### 9.3 pure_massless_bubble

固定定义：

```mathematica
vertexOrder = {v1,v2};
vertexSignCases = <|
  "++"->{+1,+1}, "--"->{-1,-1},
  "+-"->{+1,-1}, "-+"->{-1,+1}|>;
loopMomenta = {q};
externalMomenta = {k};
externalInvariantRules = {sp[k,k]->s11};
vertexEnergies = <|v1->E1,v2->E2|>;
lineOrder = {1,2};
lineData = {
  <|"id"->1, "endpoints"->{v1,v2}, "momentum"->q,
    "massType"->"massless", "bbType"->"exp", "nu"->0|>,
  <|"id"->2, "endpoints"->{v1,v2}, "momentum"->q-k,
    "massType"->"massless", "bbType"->"exp", "nu"->0|>
};
ispData = {};
zeroPointRules = {
  a0[v1]->alpha1, a0[v2]->alpha2,
  b0[1]->beta1, b0[2]->beta2,
  bS0[1]->beta1, bS0[2]->beta2
};
generatorList = {dtau[v1],dtau[v2],dqq[1,1],dqk[1,1]};
symmetryRules = {};
```

两条 massless 线的第一端点都固定为 `v1`，所以两个 `n[e]=1` 都以 `v1->v2` 为正方向。top notation 为

```text
++ / -- : J[{a1,a2},{{b1,n1},{b2,n2}},{}]
+- / -+ : J[{a1,a2},{{b1},{b2}},{}]
```

同分支 sector 为 `{top,e1,e2,e1_e2}`；异分支只有 `top`。例如 `e1` sector 写成 `J[{a12},{{bS1},{b2,n2}},{}]`，而 coincident 的 `n2=1` 必须 canonical 为 0。

必须覆盖：

- 四个顶点符号组合；
- 每个 case 的全部可达 sector；
- 每个 sector 全部 time 和 `d/dq.q`、`d/dq.k`；
- 所有剩余 masslessFull `n=0/1`。

另推两版多线 theta 处理：

- `perLineMergedTheta`：每条线各自 `{b[e],n[e]}`，用于当前 package 比较；
- `bundledMasslessFuture`：同一顶点对共享两个 theta 区域，只作未来参考，使用惰性 `JBundle[aList,bList,nBundle,ispList]`，不要求 009 通过，也不得与上面的逐线 `J` expected 混用。

### 9.4 mixed_bubble

固定使用 9.3 的顶点、sign cases、动量空间、外不变量、能量和生成元；只改 line 1 为 massive h：

```mathematica
lineData = {
  <|"id"->1, "endpoints"->{v1,v2}, "momentum"->q,
    "massType"->"massive", "bbType"->"h", "nu"->nuM|>,
  <|"id"->2, "endpoints"->{v1,v2}, "momentum"->q-k,
    "massType"->"massless", "bbType"->"exp", "nu"->0|>
};
ispData = {};
zeroPointRules = {
  a0[v1]->alpha1, a0[v2]->alpha2,
  b0[1]->beta1, b0[2]->beta2, bS0[2]->beta2
};
symmetryRules = {};
```

massless line 2 的方向固定为 `v1->v2`。top notation 为

```text
++ / -- : J[{a1,a2},{{b1,n11,n12},{b2,n2}},{}]
+- / -+ : J[{a1,a2},{{b1,n11,n12},{b2}},{}]
```

同分支 sector 为 `{top,e1,e2,e1_e2}`，异分支只有 `top`。massive shrink 的 `bS0[1]` 与 merged `a0` 按第 5 节从 `beta1,alpha1,alpha2,nuM` 派生；不得把它设成 0。要求覆盖 massive/massless 两类 shrink、两线同时 shrink、cross case、EOM、目标 sector coincident canonical 和非零 zero-point。

### 9.5 mixed_triangle

固定定义：

```mathematica
vertexOrder = {v1,v2,v3};
vertexSignCases = AssociationThread[
  {"+++","++-","+-+","+--","-++","-+-","--+","---"},
  {{+1,+1,+1},{+1,+1,-1},{+1,-1,+1},{+1,-1,-1},
   {-1,+1,+1},{-1,+1,-1},{-1,-1,+1},{-1,-1,-1}}
];
loopMomenta = {q};
externalMomenta = {k1,k2};
externalInvariantRules = {
  sp[k1,k1]->s11, sp[k1,k2]->s12, sp[k2,k2]->s22
};
vertexEnergies = <|v1->E1,v2->E2,v3->E3|>;
lineOrder = {1,2,3};
lineData = {
  <|"id"->1, "endpoints"->{v1,v2}, "momentum"->q,
    "massType"->"massive", "bbType"->"h", "nu"->nuM|>,
  <|"id"->2, "endpoints"->{v2,v3}, "momentum"->q-k1,
    "massType"->"massive", "bbType"->"h", "nu"->nuM|>,
  <|"id"->3, "endpoints"->{v3,v1}, "momentum"->q+k2,
    "massType"->"massless", "bbType"->"exp", "nu"->0|>
};
ispData = {};
zeroPointRules = {
  a0[v1]->alpha1, a0[v2]->alpha2, a0[v3]->alpha3,
  b0[1]->beta1, b0[2]->beta2, b0[3]->beta3,
  bS0[3]->beta3
};
generatorList = {dtau[v1],dtau[v2],dtau[v3],
  dqq[1,1],dqk[1,1],dqk[1,2]};
symmetryRules = {};
```

massless line 3 的正方向是 `v3->v1`，不能为了按顶点编号排序而改写成 `{v1,v3}`。top notation 为

```mathematica
J[{a1,a2,a3},
  {{b1,n11,n12},{b2,n21,n22},masslessPack3},{}]
```

其中 `masslessPack3={b3,n3}` 当 `s[v3]=s[v1]`，否则为 `{b3}`。每个 sign case 的可 shrink 线恰好是端点同分支的线；sector 是这些线的全部 shrink 子集，而不是固定照抄 `+++` 的八个 sector。massive line 1、2 等质量只表示共用 `nuM`，本 family 仍令 `symmetryRules={}`，不自动加入图对称性。

要求：

- 三个顶点的 8 个 `+/-` 组合；
- 每个 sector 的全部 active time；
- `d/dq.q`、`d/dq.k1`、`d/dq.k2`；
- 全部剩余 massive/massless 离散状态；
- 缩并导致的顶点合并、coincident line 和 sector zero-point。

### 9.6 mixed_sunrise

固定定义：

```mathematica
vertexOrder = {v1,v2};
vertexSignCases = <|
  "++"->{+1,+1}, "--"->{-1,-1},
  "+-"->{+1,-1}, "-+"->{-1,+1}|>;
loopMomenta = {q1,q2};
externalMomenta = {k};
externalInvariantRules = {sp[k,k]->s11};
vertexEnergies = <|v1->E1,v2->E2|>;
lineOrder = {1,2,3};
lineData = {
  <|"id"->1, "endpoints"->{v1,v2}, "momentum"->q1,
    "massType"->"massive", "bbType"->"h", "nu"->nuM|>,
  <|"id"->2, "endpoints"->{v1,v2}, "momentum"->q2,
    "massType"->"massless", "bbType"->"exp", "nu"->0|>,
  <|"id"->3, "endpoints"->{v1,v2}, "momentum"->q1-q2-k,
    "massType"->"massless", "bbType"->"exp", "nu"->0|>
};
ispData = {
  <|"id"->1,"expression"->sp[q1,k]|>,
  <|"id"->2,"expression"->sp[q2,k]|>
};
zeroPointRules = {
  a0[v1]->alpha1, a0[v2]->alpha2,
  b0[1]->beta1, b0[2]->beta2, b0[3]->beta3,
  bS0[2]->beta2, bS0[3]->beta3
};
generatorList = {dtau[v1],dtau[v2],
  dqq[1,1],dqq[1,2],dqk[1,1],
  dqq[2,1],dqq[2,2],dqk[2,1]};
symmetryRules = {};
```

两条 massless 线 2、3 都以 `v1->v2` 为正方向。top notation 为

```text
++ / -- :
J[{a1,a2},
  {{b1,n11,n12},{b2,n2},{b3,n3}},
  {r1,r2}]

+- / -+ :
J[{a1,a2},
  {{b1,n11,n12},{b2},{b3}},
  {r1,r2}]
```

同分支 sector 是 `{top,e1,e2,e3,e1_e2,e1_e3,e2_e3,e1_e2_e3}`，异分支只有 `top`。五个独立 loop scalar products 为 `q1^2,q1.q2,q2^2,q1.k,q2.k`；三个 propagator square 加上述两个 ISP 必须先证明可反解。不能只在 `ispN=0` 检查：至少另取 `{r1,r2}={1,0}` 和 `{0,1}` 各一个最小 seed，验证两个 ISP 因子自身求导。

四个顶点符号组合、全部可达 sector、全部 active time，以及六个 momentum 生成元：

```text
d/dq1.q1, d/dq1.q2, d/dq1.k
d/dq2.q1, d/dq2.q2, d/dq2.k
```

两条平行 massless 线同样给 `perLineMergedTheta` 与 `bundledMasslessFuture` 两版；009 只比较前者。future 版使用惰性 `JMixedBundle[aList,massivePacks,masslessBList,nBundle,ispList]`，不得写成当前三槽 `J`。

### 9.7 pure_massive_bubble_reference

固定定义：

```mathematica
vertexOrder = {v1,v2};
vertexSignCases = <|
  "++"->{+1,+1}, "--"->{-1,-1},
  "+-"->{+1,-1}, "-+"->{-1,+1}|>;
loopMomenta = {q};
externalMomenta = {k};
externalInvariantRules = {sp[k,k]->s11};
vertexEnergies = <|v1->E1,v2->E2|>;
lineOrder = {1,2};
lineData = {
  <|"id"->1, "endpoints"->{v1,v2}, "momentum"->q,
    "massType"->"massive", "bbType"->"h", "nu"->nuM|>,
  <|"id"->2, "endpoints"->{v1,v2}, "momentum"->q-k,
    "massType"->"massive", "bbType"->"h", "nu"->nuM|>
};
ispData = {};
zeroPointRules = {
  a0[v1]->alpha1, a0[v2]->alpha2,
  b0[1]->beta1, b0[2]->beta2
};
generatorList = {dtau[v1],dtau[v2],dqq[1,1],dqk[1,1]};
```

所有 sign case 的 top notation 都是

```mathematica
J[{a1,a2},{{b1,n11,n12},{b2,n21,n22}},{}]
```

同分支 sector 为 `{top,e1,e2,e1_e2}`，异分支只有 `top`。用统一 `J` 与新 sector metadata 重推。另存一组 reference-only 参数对照：`a0[v1]=a0[v2]=2 nuM`、`b0[1]=b0[2]=-2 nuM`、`d=3-2 ep`、`s11=1`、`E1=E2`；它只用于比较旧 reference code，正式 benchmark 仍保留上面的 `alpha/beta` 非零符号 zero-point。

本函数族还必须单独给出用户 `symmetryRules`：

- 当两线除路由外的参数完全相同（同一 `nuM`、相同 `b0` 和 normalization）时，线交换由 `q->k-q` 诱导；它交换两个 line pack，但不凭空交换 `aList`。
- 顶点交换需额外满足 `E1=E2`、`a0[v1]=a0[v2]` 以及其它外腿参数相同；回到固定端点顺序 `{v1,v2}` 后，每个 massive pack 的 `n[e,1]` 与 `n[e,2]` 同时交换。
- reference code 的额外关系必须逐条写出所需参数条件，不能误说成一般 bubble 恒成立。
- 给出规则作用前后的代表积分与 IBP 关系，并检查 `symmetry` 后 canonical 结果。

### 9.8 two_loop_isp_toy

固定为一个使用任意用户符号名的两圈 sunrise 型 toy；三条 massless 线均有方向 `v1->v2`：

```mathematica
vertexOrder = {v1,v2};
vertexSignCases = <|
  "++"->{+1,+1}, "--"->{-1,-1},
  "+-"->{+1,-1}, "-+"->{-1,+1}|>;
loopMomenta = {l3,k321};
externalMomenta = {wdnmd};
externalInvariantRules = {sp[wdnmd,wdnmd]->s11};
vertexEnergies = <|v1->E1,v2->E2|>;
lineOrder = {1,2,3};
lineData = {
  <|"id"->1, "endpoints"->{v1,v2}, "momentum"->l3,
    "massType"->"massless", "bbType"->"exp", "nu"->0|>,
  <|"id"->2, "endpoints"->{v1,v2}, "momentum"->k321,
    "massType"->"massless", "bbType"->"exp", "nu"->0|>,
  <|"id"->3, "endpoints"->{v1,v2},
    "momentum"->l3-k321-wdnmd,
    "massType"->"massless", "bbType"->"exp", "nu"->0|>
};
ispData = {
  <|"id"->1,"expression"->sp[l3,k321+l3]|>,
  <|"id"->2,"expression"->sp[l3,wdnmd]|>
};
zeroPointRules = {
  a0[v1]->alpha1, a0[v2]->alpha2,
  b0[1]->beta1, b0[2]->beta2, b0[3]->beta3,
  bS0[1]->beta1, bS0[2]->beta2, bS0[3]->beta3
};
generatorList = {dtau[v1],dtau[v2],
  dqq[1,1],dqq[1,2],dqk[1,1],
  dqq[2,1],dqq[2,2],dqk[2,1]};
symmetryRules = {};
```

`sp` 的 `Orderless` 必须让 `sp[k321,l3]` 与 `sp[l3,k321]` 自动一致，但不得展开或重命名用户的 `l3,k321,wdnmd`。三个 propagator square 与 `rho1=sp[l3,k321+l3]`、`rho2=sp[l3,wdnmd]` 必须显式证明可反解全部五个 loop scalar products。

同分支 top notation 是 `J[{a1,a2},{{b1,n1},{b2,n2},{b3,n3}},{r1,r2}]`，异分支把三个 `{b,n}` 都改成 `{b}`。sector 规则与三条平行 full 线的所有 shrink 子集一致；异分支只有 top。专测：

- propagator 加 ISP 的闭合性；
- `dqq` 对角与交叉；
- `dqk`；
- `ispN=0` 时由标量积吸收产生的 ISP 移位；
- `ispN=1` 时 ISP 因子自身导数。

### 9.9 parallel_massless_bundle_guard

固定定义：

```mathematica
vertexOrder = {v1,v2};
vertexSignCases = <|
  "++"->{+1,+1}, "--"->{-1,-1},
  "+-"->{+1,-1}, "-+"->{-1,+1}|>;
loopMomenta = {q};
externalMomenta = {k1,k2};
externalInvariantRules = {
  sp[k1,k1]->s11, sp[k1,k2]->s12, sp[k2,k2]->s22
};
vertexEnergies = <|v1->E1,v2->E2|>;
lineOrder = {1,2,3};
lineData = {
  <|"id"->1, "endpoints"->{v1,v2}, "momentum"->q,
    "massType"->"massless", "bbType"->"exp", "nu"->0|>,
  <|"id"->2, "endpoints"->{v1,v2}, "momentum"->q-k1,
    "massType"->"massless", "bbType"->"exp", "nu"->0|>,
  <|"id"->3, "endpoints"->{v1,v2}, "momentum"->q-k2,
    "massType"->"massless", "bbType"->"exp", "nu"->0|>
};
ispData = {};
zeroPointRules = {
  a0[v1]->alpha1, a0[v2]->alpha2,
  b0[1]->beta1, b0[2]->beta2, b0[3]->beta3,
  bS0[1]->beta1, bS0[2]->beta2, bS0[3]->beta3
};
generatorList = {dtau[v1],dtau[v2],
  dqq[1,1],dqk[1,1],dqk[1,2]};
symmetryRules = {};
```

三条线的 `n[e]=1` 方向都固定为 `v1->v2`。当前逐线 top notation 是 `J[{a1,a2},{{b1,n1},{b2,n2},{b3,n3}},{}]`；同分支 sector 为三条线的全部 shrink 子集，异分支 top 则为 `J[{a1,a2},{{b1},{b2},{b3}},{}]`。

另推共同 theta future 公式并使用 `JBundle[aList,bList,nBundle,ispList]`。必须明确它只有一个共同 `nBundle`，因此积分族维数和关系数不同；禁止把 future 公式写回三槽 `J`，也禁止拿它判定 009 失败。

### 9.10 vertex_energy_signs

固定使用一条有序 `v1->v2` massless 线：

```mathematica
vertexOrder = {v1,v2};
vertexSignCases = <|
  "++"->{+1,+1}, "--"->{-1,-1},
  "+-"->{+1,-1}, "-+"->{-1,+1}|>;
loopMomenta = {ell};
externalMomenta = {k};
externalInvariantRules = {sp[k,k]->s11};
lineOrder = {1};
lineData = {
  <|"id"->1, "endpoints"->{v1,v2}, "momentum"->ell-k,
    "massType"->"massless", "bbType"->"exp", "nu"->0|>
};
ispData = {};
zeroPointRules = {
  a0[v1]->alpha1, a0[v2]->alpha2,
  b0[1]->beta1, bS0[1]->beta1
};
generatorList = {dtau[v1],dtau[v2],dqq[1,1],dqk[1,1]};
symmetryRules = {};
```

在完全相同的 topology 上分别使用三组 `vertexEnergies`：

```mathematica
energyCaseA = <|v1->ke[1],       v2->ke[2]|>;
energyCaseB = <|v1->Sqrt[s11],   v2->ke[2]|>;
energyCaseC = <|v1->ke[3],       v2->ke[2]|>;
```

`ke[3]` 代表独立的 `|p1+p2|`，不是 `ke[1]+ke[2]`，且 `p1,p2` 不进入 `externalMomenta`。只有 case B 明确声明顶点能量与圈外动量不变量为同一变量。notation 和 sector 与 9.1 相同，但这里 momentum generator 还包括 `dqk[1,1]`。

专测：

- `++/--/+-/-+` 顶点相位；
- 独立 `ke[i]`；
- 顶点能量复用 `Sqrt[s11]`；
- 独立 `|ke1+ke2|` 另记 `ke[3]`；
- 外腿能量不参与 momentum generator。
## 10. Seed 取值

一般函数族只取一个连续整数基点：

```mathematica
a[v] -> 0;
b[e] -> 0;
bS[e] -> 0;
ispN[j] -> 0;
```

但始终保留 `a0[v]`、`b0[e]`、`bS0[e]`。若关系退化为 0，可增加一个最小非零整数点并写明原因。`mixed_sunrise` 与 `two_loop_isp_toy` 必须额外取一个 `ispN[j]->1` 点。

离散态不能抽样：每个当前 sector 的所有 massive `n1,n2` 和 masslessFull `n` 都遍历 `0/1`。最终关系中禁止 massive `n>=2` 和 massless 非 `0/1`。


## 11. 用户输入的积分族对称性

积分族对称性完全由用户提供规则，benchmark 不自动从 topology 推断。`pure_massive_bubble_reference` 必须把两类规则分开，不能用一条规则同时交换 line 与 vertex：

```mathematica
(* 条件：两条线的质量、zero-point 与 normalization 完全相同。 *)
lineExchangeRules = {
  HoldPattern[J[a_,{pack1_,pack2_},isp_]] /;
      ! OrderedQ[{pack1,pack2}] :>
    J[a,{pack2,pack1},isp]
};

swapMassiveEndpoints[{bb_,nFirst_,nSecond_}] :=
  {bb,nSecond,nFirst};
swapMassiveEndpoints[{bShrunk_}] := {bShrunk};

(* 另需 E1=E2、a0[v1]=a0[v2] 及相同外腿参数。 *)
vertexExchangeRules = {
  HoldPattern[J[{av1_,av2_},packs_,isp_]] :>
    J[{av2,av1},swapMassiveEndpoints /@ packs,isp]
};
```

这里的规则只是输入形式示例；实际 canonical 方向和防止规则循环的条件必须在该 family 的 README 中固定。独立推导者必须同时给出：

- 原始规则及成立的全部物理参数条件；
- 至少一个积分的规则前后结果；
- 至少一个 time-IBP 与一个 momentum-IBP 的规则前后结果；
- 单独应用 line exchange、单独应用 vertex exchange 和按指定顺序组合应用的结果；
- 规则为空时表达式不变。

只有 `pure_massive_bubble_reference` 使用非空 `symmetryRules`。其它函数族不加入额外对称性。`sp` 的 `Orderless` 另行检查，不能计入这里的图对称性覆盖。
## 12. 简单输出格式

不要把 expected 输出成多层嵌套 Association。每个函数族建立独立目录：

```text
<family-name>/
  README.md
  family.wl
  expected.wl
  derivation.md   (仅在确有必要时)
```

`family.wl` 必须定义第 9.0 节的一层 `familyDefinition`，并把该 family 的固定信息全部落盘：

- `name`、`vertexOrder`、`vertexSignCases`；
- `loopMomenta`、`externalMomenta`、`externalInvariantRules`；
- `vertexEnergies`；
- `lineOrder` 与每条线的有序 `endpoints`、`momentum`、`massType`、`bbType`、`nu`；
- `ispData`、`zeroPointRules`；
- 同分支/异分支 `topIntegralTemplate`；
- `sectorNaming`、`generatorList`、`symmetryRules`。

`README.md` 用普通小节或表格复述 topology、notation、massless 方向、动量路由、sector、生成元、离散态、预期 relation 计数和特殊 tags。它必须能让审查者不运行 `family.wl` 也知道每个 `J` 槽位的含义。

`expected.wl` 使用扁平列表：

```mathematica
expectedRelations = {
  <|
    "sector" -> "top",
    "vertexSigns" -> "++",
    "generator" -> dtau[v1],
    "seedRules" -> {a[v1]->0, b[1]->0, n[1]->1},
    "equation" -> (* 已 EOM/canonical 的 J 线性组合 *),
    "tags" -> {"masslessFirstEndpoint","thetaShrink"}
  |>,
  ...
};
```

每条 relation 只保留上述六个字段。`generator` 只使用 `dtau[v]`、`dqq[i,j]` 或 `dqk[i,j]`。另在 README 写：

- 预期 sector 数；
- 每 sector active time 数；
- momentum generator 数；
- 每 sector 离散态数；
- 总 relation 数；
- 零关系数及原因。
## 13. 完成检查表

每个函数族交付前确认：

- [ ] 没有读取本项目代码或旧 expected。
- [ ] `family.wl` 的 `familyDefinition` 已包含第 9.0 节全部固定字段。
- [ ] README 已逐条写出每条 massless 线的有序端点和 `n=1` 方向。
- [ ] 所有顶点符号组合已覆盖。
- [ ] 每个符号 case 的所有可达 sector 已覆盖。
- [ ] 每个 sector 的所有 active time 生成元已覆盖。
- [ ] 每个 sector 的所有 `L(L+K)` momentum 生成元已覆盖。
- [ ] 所有剩余离散 `n=0/1` 状态已覆盖。
- [ ] massive `n=2` 已立即 EOM。
- [ ] massless theta-delta 与有序端点符号已检查。
- [ ] 非零 zero-point 已保留。
- [ ] ISP 非零指标点已在两圈 ISP 例中检查。
- [ ] 输出没有写回 `independent-benchmark/`。
- [ ] current per-line 与 future bundle 版本没有混用。
