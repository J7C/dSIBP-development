# dS IBP 独立 benchmark 推导任务书

> **用途边界**：本文是交给其它 AI 的独立推导任务说明书。第一阶段只允许读取本文，不得打开同目录的 `package/`；手推结果和来源记录冻结后，第二阶段才可读取其中的当前程序与正式用户手册，自行学习调用和比较。不要把本项目的手推答案、expected、check 或运行产物写入此目录。独立推导者应把结果输出到自己的新目录，维护者审查后再决定是否导入项目。

## 1. 任务目标

从本文给出的费曼规则、指标 convention 和函数族定义出发，独立推导小型 dS IBP seed，用来反查当前 012 程序快照。独立推导阶段禁止读取 `package/`、主线代码、`000_code/check/`、旧 expected 或已有运行结果。冻结结果后，使用 `package/package_012.wl` 和 `package/package_012.pdf` 完成程序调用与对照；如何组织 actual/expected 比较由独立推导者自行决定。

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
    q[e] = Sqrt[sp[Q[e],Q[e]]]
    x[e,r] = -q[e] tau[endpoints[e][[r]]],  r=1,2

其中第一端点永远是 u[e]，第二端点永远是 v[e]。端点顺序不是无关 metadata：massive 的 n[e,1]/n[e,2] 和 massless 的有向 n[e] 都依赖它。

去掉与 IBP 无关的整体耦合常数后，一个 top-sector 被积函数统一理解为

    Product[d tau[v] (-tau[v])^A[v] Exp[-I s[v] E[v] tau[v]],v]
    Product[d^d q[l],l]
    Product[q[e]^(-B[e]) PropagatorBlock[e],e]
    Product[ISP[r]^ispN[r],r]

其中 A[v]=a[v]+a0[v]，B[e]=b[e]+b0[e]。顶点相位固定为

    s[v]=+1: Exp[-I E[v] tau[v]]
    s[v]=-1: Exp[+I E[v] tau[v]]

只进入顶点相位的 E[v] 不自动属于 externalMomenta。对一个固定的 `vertexSigns` case，SK contour 顶点因子、耦合常数、整体动量守恒 delta、1/2、pi 和其它不依赖积分变量的 normalization 都是整条齐次 IBP 的共同因子，统一提出且不写入 `J`。不得把这些共同因子误当成端点导数符号；不能提出的是 theta 导数的相对符号和 massive shrink 的 Wronskian prefactor。

所有时间积分均在 `tau[v] in (-Infinity,0)` 上理解，并假设解析正规化或通常的 `i epsilon` 处方使全微分边界项为零。Heaviside 分布固定采用

```text
d theta(x)/dx = delta(x),
theta(x)+theta(-x)=1,
theta(0)=1/2.
```

最后一式只固定单个未缩并传播子的对称 coincidence 值，不自动定义 delta 与不连续函数乘积。遇到这类乘积时，独立推导必须从第 2.1--2.4 节给出的完整原始被积函数出发，明确写出所采用的统一分布正则化并验证极限；不能仅靠点值代入决定结果。

本文直接使用 Mathematica 标量积头 sp，并固定

    SetAttributes[sp, Orderless];

这只表示 sp[p,r]=sp[r,p]，不表示图或积分族对称性。

### 2.2 Massive h/H building block 定义

质量参数采用

    nu[e]^2 = m[e]^2/H^2 - d^2/4

并只考虑纯实 nu 或纯虚 nu。令 `x=-q tau>0`。本文只给函数定义，不给它们满足的微分方程或导数递推。

归一化 h 模式定义为

    F[h,1,0;nu,x] = x^(-nu) HankelH1[nu,x]
    F[h,2,0;nu,x] = x^(-nu) HankelH2[Conjugate[nu],x]

裸 H 模式定义为

    F[H,1,0;nu,x] = HankelH1[nu,x]
    F[H,2,0;nu,x] = HankelH2[Conjugate[nu],x]

两种模式的离散端点态都按同一槽位 convention 定义：

    F[type,s,1;nu,x] = partial_x F[type,s,0;nu,x]
    type in {h,H},  s in {1,2}

正式 `J` 只保存 `n=0,1`。独立推导者必须仅从上述 Hankel 定义出发，分别推导 h 与 H 的闭合微分关系，再把导数产生的更高 `n` 消回该基底。本文不提供任何 H/h 微分方程、矩阵、递推系数或指标移位答案。

### 2.3 Massive 四种 SK 传播子

对有序端点 `{u,v}`，令 `Delta=tau[u]-tau[v]`、`type=bbType[e]`，并定义去掉 coefficient-only normalization 的 Wightman blocks

    WGreater[e] =
      F[type,1,n[e,1];nu[e],-q[e] tau[u]]
      F[type,2,n[e,2];nu[e],-q[e] tau[v]]

    WLess[e] =
      F[type,2,n[e,1];nu[e],-q[e] tau[u]]
      F[type,1,n[e,2];nu[e],-q[e] tau[v]].

四种 SK kernel 固定为

    G++ = theta[ Delta] WGreater + theta[-Delta] WLess
    G-- = theta[-Delta] WGreater + theta[ Delta] WLess
    G+- = WLess
    G-+ = WGreater.

同分支 `++/--` 记为 `massiveFull`；异分支 `+/-/-+` 记为 `massiveCross`。两类未缩并线都保留两个有序端点态 `n[e,1],n[e,2]`。

对 `massiveFull`，独立推导者必须从 theta 导数与上述两个 Wightman block 出发，判断哪些 `n[e,1],n[e,2]` 产生非零 coincidence 项，分别推导 h/H 的 Wronskian 等式、端点符号、prefactor 及缩并后的时间/动量幂。本文不提供这些等式或具体 shrink 公式。`massiveCross` 是否存在相同机制也必须直接由所给 kernel 判断。

### 2.4 Massless 四种 SK 传播子与全部正负号

对 massless 线仍使用有序端点 `{u,v}` 和 `Delta=tau[u]-tau[v]`。标准共同因子 `1/(2q)` 中，数值 `1/2` 可作为 normalization 提出，固定动量幂 `q^-1` 必须计入该线输入的 `b0[e]`；下列 `D` 只表示余下的指数/theta kernel：

    D++ = theta[ Delta] Exp[-I q Delta]
        + theta[-Delta] Exp[+I q Delta]

    D-- = theta[ Delta] Exp[+I q Delta]
        + theta[-Delta] Exp[-I q Delta]

    D+- = Exp[+I q Delta]
    D-+ = Exp[-I q Delta].

同分支 `++/--` 记为 `masslessFull`；异分支 `+/-/-+` 记为 `masslessCross`。`masslessFull` 的 `n=0,1` 基底定义见第 4 节；`masslessCross` 不设置离散 `n`。所有 time/momentum 导数、theta-delta、端点反转和 coincidence 结果都必须从这些 kernel 独立推出。

### 2.5 外腿能量、外部向量与输出不变量

externalMomenta 只列实际进入某个 Q[e] 并与圈动量形成 scalar-product 空间的独立外部向量。顶点相位能量 E[v] 分两类：

- 若它属于 externalMomenta 张成的不变量，写成相应 s[i,j] 的函数；
- 若它只在时间相位中出现，写成独立 ke[i]。

例如 |p1+p5| 若是一个独立模长，必须定义为新的 ke[3]，不能写成 ke[1]+ke[2]。外动量-外动量标量积输出为用户给定变量或默认 s[i,j]，不保留为 sp[k[i],k[j]]。

### 2.6 独立推导边界

第 2 节是允许使用的特殊函数与传播子输入全集。禁止从 package 代码、tech/design/plan note、现有 hand-derived expected 或其它项目文档补充 H/h EOM、Wronskian、缩并系数和指标移位。允许使用公开的标准 Hankel 恒等式，但必须在交付的 `derivation.md` 中写明采用的恒等式并完成推导。


## 3. 统一积分表示

所有 sector 使用

```mathematica
J[aList, linePacks, ispList]
```

三个顶层槽及其顺序固定如下，独立输出不得重排：

| 位置 | 数据 | 顺序与物理对象 |
|---|---|---|
| `J[[1]] = aList` | 顶点时间幂的整数指标 | 先按 sector 的顶点合并关系取每个连通类在 `vertexOrder` 中最早的顶点为代表，再按这些代表在 `vertexOrder` 中的次序排列；`aList[[i]]` 对应该代表顶点的时间幂 |
| `J[[2]] = linePacks` | 每条原始内线的指标包 | `linePacks[[p]]` 永远对应 `e=lineOrder[[p]]`；即使线已缩并也保留该 line slot，只改变 pack 形状 |
| `J[[3]] = ispList` | ISP numerator 的整数幂 | `ispList[[r]]` 对应 `ispData[[r]]`；被积函数使用 `ISP[r]^ispList[[r]]`，正指标表示 numerator 幂 |

每个 line pack 内部的槽位也固定：

| line 状态 | pack | 各槽对应的物理对象 |
|---|---|---|
| unshrunk massiveFull/massiveCross | `{b[e],n[e,1],n[e,2]}` | `b[e]` 是 `q[e]` 分母幂的整数部分；`n[e,1]` 对应 `endpoints[e][[1]]` 的 `partial_x` 阶数，`n[e,2]` 对应 `endpoints[e][[2]]` |
| unshrunk masslessFull | `{b[e],n[e]}` | `b[e]` 同上；`n[e]` 选择第 4 节按第一端点定向的 `M[0]/M[1]` 基底 |
| unshrunk masslessCross | `{b[e]}` | 只有 `q[e]` 分母幂；没有 theta 基底指标 |
| shrunk line | `{bS[e]}` | 缩并后剩余 `q[e]` 幂的整数部分；不再保留端点 `n` |

质量、SK 分支、顶点能量、外不变量、zero-point、normalization 和 shrink prefactor 都不是 `J` 指标，必须放在 family/sector metadata 或关系系数中。

实际时间和线幂次分别为

```text
A[v]  = a[v]  + a0[v]
B[e]  = b[e]  + b0[e]
BS[e] = bS[e] + bS0[e]
```

输入只直接给 unshrunk 的 `a0[v]` 与 `b0[e]`。合并顶点的 zero-point、`bS0[e]` 和 shrink prefactor 是独立推导输出，不得从本文其它段落读取。连续整数指标可以在基点取 0，但不能在推导中把这些符号 zero-point 预先设为 0。旧 reference bubble 的数值化参数只作为另列的 reference-only 输入。

### 3.1 从 `J` 机械还原被积函数

设当前 sector 的 active/merged 顶点代表按第 3 节规则排列为 `{r1,...,rVa}`，`lineOrder={e1,...,eP}`，`ispData={rho1,...,rhoR}`。则

```mathematica
J[{a1,...,aVa},{pack1,...,packP},{z1,...,zR}]
```

表示的被积函数结构为

```text
Product[(-tau[ri])^(ai+a0Sector[ri]), i=1,...,Va]
Product[LineBlock[ep,packp], p=1,...,P]
Product[rhor^zr, r=1,...,R]
```

再乘第 2.1 节给定的 active 顶点相位、时间/圈动量测度和该 relation 的外部系数。`a0Sector` 是当前 sector 的时间 zero-point：top sector 等于输入 `a0`；发生顶点合并时的值必须独立推导。`ai` 只表示整数指标，不包含 zero-point。

`LineBlock` 按 pack 形状精确定义如下：

1. unshrunk massiveFull/massiveCross，`packp={b,nFirst,nSecond}`：

   ```text
   LineBlock[e,{b,nFirst,nSecond}]
     = q[e]^(-(b+b0[e]))
       G[s[u[e]],s[v[e]];e,nFirst,nSecond]
   ```

   `G` 是第 2.3 节的相应 SK kernel；`nFirst` 选择第一有序端点 `u[e]` 上的 `F[type,*,nFirst]`，`nSecond` 选择第二端点 `v[e]` 上的 `F[type,*,nSecond]`。二者都是 `partial_x` 阶数，正式值为 `0` 或 `1`。

2. unshrunk masslessFull，`packp={b,n}`：

   ```text
   LineBlock[e,{b,n}]
     = q[e]^(-(b+b0[e])) M[sigma[e],n;q[e],tau[u[e]]-tau[v[e]]]
   ```

   这里 `b` 是可移位的整数动量幂，`b0[e]` 包含 family 指定的固定幂（包括采用标准 `1/(2q)` normalization 时的 `q^-1`）。`n` 不是幂次，也不是“已经做了 n 次 time 导数”；它是第 4 节两个函数 `M[0]`、`M[1]` 的基底选择器。`n=1` 的方向由 `endpoints[e][[1]] -> endpoints[e][[2]]` 固定；`sigma[e]` 由该线是 `++` 还是 `--` 按第 4 节定义。

3. unshrunk masslessCross，`packp={b}`：

   ```text
   LineBlock[e,{b}]
     = q[e]^(-(b+b0[e])) D[s[u[e]],s[v[e]];e]
   ```

   `D` 是第 2.4 节的 `D+-` 或 `D-+`。cross pack 没有 `n` 槽，不能人为补成 `{b,0}`。

4. shrunk line，`packp={bS}`：

   ```text
   LineBlock[e,{bS}] = q[e]^(-(bS+bS0Sector[e]))
   ```

   原传播子函数和端点 `n` 已不在 `J` 中；shrink prefactor 属于整条 relation 的系数。`bS0Sector[e]` 及 merged-time zero-point 是待独立推导的 sector metadata，上式只定义它们在最终记号中的位置，不规定其值。

第三槽中 `zr` 是 `ispData[[r]]["expression"]` 的幂：`zr>0` 表示 numerator，`zr=0` 表示没有该因子，`zr<0` 表示其倒数。第三槽顺序只能跟随 `ispData`，不能按表达式名称重新排序。

例如 atomic massless 同分支 top sector 的

```mathematica
J[{a1,a2},{{b1,n1}},{}]
```

明确代表

```text
(-tau1)^(a1+alpha1) (-tau2)^(a2+alpha2)
Exp[-I s1 E1 tau1] Exp[-I s2 E2 tau2]
q1^(-(b1+beta1)) M[sigma,n1;q1,tau1-tau2]
```

其中 `{s1,s2}={+1,+1}` 时 `sigma=+1`，`{-1,-1}` 时 `sigma=-1`，而 `M[0]/M[1]` 的函数定义见第 4 节。异分支使用 `J[{a1,a2},{{b1}},{}]` 和 `D+-/D-+`，不带 `n1`。

### 3.2 幂次零点 convention

零点用于固定每个积分族的指标原点。它把“固定但不参加整数移位的幂”与“IBP 关系中沿整数格点变化的指标”分开：

| 对象 | `J` 中保存 | metadata 中保存 | 被积函数中的实际幂次 |
|---|---|---|---|
| active 顶点 `v` | `a[v]` | `a0Sector[v]` | `(-tau[v])^(a[v]+a0Sector[v])` |
| unshrunk line `e` | `b[e]` | `b0[e]` | `q[e]^(-(b[e]+b0[e]))` |
| shrunk line `e` | `bS[e]` | `bS0Sector[e]` | `q[e]^(-(bS[e]+bS0Sector[e]))` |
| ISP `r` | `ispList[[r]]` | 无零点 | `ispData[[r]]["expression"]^ispList[[r]]` |

这里的符号约定必须严格区分：`a` 是正的时间幂指标；`b/bS` 是分母幂指标，所以实际 `q` 指数前有负号。`a0/b0/bS0` 可以是符号、质量参数的函数或其它固定表达式，不要求为整数；`a/b/bS` 才是 IBP 后端使用的整数移位变量。

对 top sector，family 输入必须为 `vertexOrder` 中每个顶点显式给出唯一的 `a0[v]`，并为 `lineOrder` 中每条 unshrunk line 显式给出唯一的 `b0[e]`。012 在缺少规则时技术上会回退到 0，但独立 benchmark 禁止依赖这个缺省，否则“确实为 0”和“漏填输入”无法区分。

同一物理幂次形式上可以通过在整数指标与零点之间搬移整数来重写，例如 `(b,b0)` 与 `(b+1,b0-1)`；本 benchmark 不把它们视为同一比较键。family 一旦固定 `zeroPointRules`，后续所有 expected 必须保持同一分解，不得逐条 relation 重新选原点。

若独立推导得到某条线的 shrink factor 含

```text
kappa[e] q[e]^(-s[e]-z[e]) (-tau)^(-s[e]-z[e]),
```

必须先固定 `s[e]` 为整数指标 shift、`z[e]` 为不进入整数格点的 zero-point shift，并按以下机械 convention 写回：

```text
bS[e]             = b[e] + s[e]
bS0Sector[e]      = b0[e] + z[e]
aMerged           = a[u] + a[v] - s[e]
a0MergedSector    = a0[u] + a0[v] - z[e]
relation coefficient *= kappa[e]
```

若一次独立推导得到的同一 contact 项同时改变多条 line packs，顶点合并只执行一次，但 `aMerged/a0MergedSector` 分别减去这些线的 `s[e]/z[e]` 之和，各条线的 `bS/bS0Sector` 仍逐线记录。这个段落只固定“已推导物理因子如何编码”的比较键，不给出任何具体传播子的 `s/z/kappa`；h、H、massless 的实际值仍必须从第 2 节定义独立推导。

sector 改变时按以下 convention 处理：

- 顶点没有合并、线没有缩并时，继续使用 top 输入的 `a0[v]`、`b0[e]`。
- 顶点合并后，整数 `a` 写在该合并类按 `vertexOrder` 选出的代表槽；对应 `a0Sector[rep]` 是 sector metadata，不另占 `J` 槽。
- 线缩并后，原 `{b,...n...}` pack 改为 `{bS}`；对应 `bS0Sector[e]` 是 sector metadata，不能继续误用 `b0[e]`，也不能把它附加到 `{bS}` pack 中。
- 对本任务书从 unshrunk top 输入生成的 sector，merged `a0Sector` 与 `bS0Sector` 的具体表达式必须从原始传播子/shrink 推导，不能作为输入预填。若用户直接输入一个起始即为 shrunk 的 topology，则其 `bS0[e]` 必须像其它初始零点一样显式给出。

零点不因普通 IBP 整数移位而改变。例如 `b -> b+1` 只改变 `J` 中的 `b`；该 family/sector 的 `b0` 保持固定。生成关系中的系数若依赖物理幂次，应使用完整和 `a+a0`、`b+b0` 或 `bS+bS0`，而不是只使用整数槽。

## 4. 有序 massless 单 n convention

对同分支 massless full line，`lineData["endpoints"] -> {u,v}` 是有序输入。第一端点 `u` 定义反对称 `n=1` 的方向。令 `Delta=tau[u]-tau[v]`，`sigma=+1` 对应 `++`，`sigma=-1` 对应 `--`：

```text
M[sigma,0;q,Delta] = theta[ Delta] exp[-i sigma q Delta]
                   + theta[-Delta] exp[ i sigma q Delta]

M[sigma,1;q,Delta] = -theta[ Delta] exp[-i sigma q Delta]
                   +  theta[-Delta] exp[ i sigma q Delta]
```

这里两条式子只是 `n` 槽位所代表物理函数的定义，不是导数恒等式。正文简称为 `M[0]/M[1]`；正式指标只保留 `n=0,1`。

独立推导者必须分别对 `++`、`--` 和两个有序端点，从定义直接推导：

- `n=0` 与 `n=1` 的 time/momentum 导数闭合关系；
- theta 导数产生的分布项及其端点符号；
- 端点反转、同端点二阶导数和 coincidence 后的 canonical 关系；
- 对每个 `n=0,1`，是否产生 shrink，以及产生时的系数、`bS` 和 sector zero-point。

本文不提供上述任何等式。massless cross line 的行为只允许从第 2.4 节给出的 `D+-/D-+` 直接推导。

## 5. Massive EOM、Wronskian 与 shrink 的独立推导要求

massive full/cross 在两个端点各保留 `n[e,1],n[e,2]`。对 h、H 两种 mode 必须分别完成以下推导，不能用其中一类的结果通过参数替换猜另一类：

1. 从第 2.2 节的 Hankel 定义推导 `n=0,1` 基底的闭合微分关系，并把 time/momentum 导数翻译成 `J` 指标移位。
2. 对导数产生的所有更高 `n` 给出消回 `n=0,1` 的过程；最终 expected 中不得保留 massive `n>=2`。
3. 从第 2.3 节四种 SK kernel 逐一判断 theta boundary 是否存在。
4. 对 `(n[e,1],n[e,2])=(0,0),(0,1),(1,0),(1,1)`，分别计算 coincidence 项；需要时推导对应的 Wronskian 等式、两个端点的符号和完整 prefactor。
5. 对每个非零 shrink 结果，独立推导物理 factor，再严格按第 3.2 节固定的整数/zero-point 分解记录 merged vertex、`a/a0` 与 `bS/bS0`。

本节刻意不提供 H/h 微分方程、Wronskian 数值、非零 `n` 条件、SK sign offset、prefactor 或任何 shrink 指标公式。所有这些都是 benchmark 要比较的答案。

## 6. Time-IBP

对每个当前 sector 的 active vertex `v` 推导

```text
0 = integral d/dtau[v] (integrand)
```

必须直接对第 2.1 节的原始被积函数使用乘积法则，覆盖顶点幂、顶点相位以及所有连接到该 active vertex 的传播子端点。regular、分布项、EOM 和 coincidence canonical 的系数与指标变化均属于独立推导结果，本文不列公式。

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
2. 从 top 空集开始，直接对该 sign case 的完整原始 kernel 乘积做分布求导；每个独立推导得到的非零 shrink 结果定义一个候选 sector 转移，不得预先假设 sector 是 full-line 幂集或任何指定子集列表。
3. 每次转移后重建当前代表顶点、端点 coincidence 和剩余原始 kernel，再独立判断后续 boundary 是否非零；只保留由这套推导实际到达的 line sets。
4. 每个 sector 重新确定 active/merged vertices、compact `aList`、coincident endpoints 和剩余离散变量。
5. 每个 sector 必须覆盖全部 active time 生成元、全部 `L(L+K)` momentum 生成元和该 sector 全部离散 `0/1` 状态。即使某条 canonical 关系变成 0，也保留记录并注明原因。

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

各 family 输入块里的 `zeroPointRules` 只列 unshrunk `a0[v]`、`b0[e]`。独立输出应在 README/derivation 中另列由推导得到的 merged-vertex zero-point、`bS0[e]` 和 shrink normalization；不得把这些派生量倒填成任务输入。

本文统一使用下列动态 pack 规则：

```text
massiveFull 或 massiveCross: {b[e],n[e,1],n[e,2]}
masslessFull:                 {b[e],n[e]}
masslessCross:                {b[e]}
shrunk:                       {bS[e]}
```

各 family 数据块后展示的 top notation 就是 `topIntegralTemplate` 必须保存的值。它必须分别展示同分支与异分支时实际的 `J`，不能只写一个无法判断 pack 长度的占位符。ISP 被积函数约定为 `ISP[r]^ispN[r]`，故正 `ispN` 表示 numerator 幂，并按 `ispData` 顺序放入 `J` 第三槽。

sector 名统一为 `"top"` 或按 `lineOrder` 排序的 `"e1"`、`"e1_e3"` 等。某 sign case 只枚举由第 8 节独立推导实际到达的 line sets；cross 线没有 theta 导数，不应伪造 shrink sector。缩并后以 `vertexOrder` 中序号最小的顶点作为合并类代表，`aList` 按代表顶点的原顺序排列。

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
  b0[1]->beta1
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

sector 为：`++/-- -> {top,e1}`，`+-/-+ -> {top}`。另建端点反转子例，只把 line 1 改为 `endpoints->{v2,v1}`，物理动量和其它输入不变；端点反转对 `n=0,1` 的作用必须由第 4 节定义推导。

专测：

- `n=0/1 × 第一/第二端点`；
- `++/--/+-/-+`；
- 端点反转；
- 同端点二阶导数；
- 两个 `n` 值各自的 theta-delta、shrink 和 coincidence 结果；
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

massive cross 的 top notation 与 full 完全相同，但没有 `e1` sector。sector 为：`++/-- -> {top,e1}`，`+-/-+ -> {top}`。`generatorList={dtau[v1],dtau[v2],dqq[1,1]}`，`symmetryRules={}`。h/H 的 shrink zero-point、prefactor 和指标移位必须分别从定义推导。

分别对 h 与裸 H 做物理检查：

- 两端点 `n=0/1`；
- time 导数后的即时 EOM；
- 四组 `(n1,n2)` 的 coincidence/Wronskian 结果及两个端点符号；
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
  b0[1]->beta1, b0[2]->beta2
};
generatorList = {dtau[v1],dtau[v2],dqq[1,1],dqk[1,1]};
symmetryRules = {};
```

两条 massless 线的第一端点都固定为 `v1`，所以两个 `n[e]=1` 都以 `v1->v2` 为正方向。top notation 为

```text
++ / -- : J[{a1,a2},{{b1,n1},{b2,n2}},{}]
+- / -+ : J[{a1,a2},{{b1},{b2}},{}]
```

各 sign case 的 sector 集合必须从两条传播子的完整乘积独立推导，不在任务书中预先给出。例如某个只缩并 line 1 的候选结果按指标槽写成 `J[{a12},{{bS1},{b2,n2}},{}]`；它是否非零、是否还有其它结果以及 coincident `n2` 如何 canonical，都必须从第 4 节定义判断。

必须覆盖：

- 四个顶点符号组合；
- 每个 case 的全部可达 sector；
- 每个 sector 全部 time 和 `d/dq.q`、`d/dq.k`；
- 所有剩余 masslessFull `n=0/1`。

本 benchmark 保留当前逐线 `J` 表示：每条 masslessFull 线各自保留 `{b[e],n[e]}`。这只是输出槽 convention，不规定多传播子乘积的分布结果；独立推导必须从原始乘积确定各项，不能把 package 的实现或当前 expected 当作输入。

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
  b0[1]->beta1, b0[2]->beta2
};
symmetryRules = {};
```

massless line 2 的方向固定为 `v1->v2`。top notation 为

```text
++ / -- : J[{a1,a2},{{b1,n11,n12},{b2,n2}},{}]
+- / -+ : J[{a1,a2},{{b1,n11,n12},{b2}},{}]
```

各 sign case 的 sector 集合必须从 mixed 原始乘积独立推导。massive/massless 的 shrink factor、`bS0` 与 merged `a0` 必须按第 3.2 和第 5 节要求独立推导并记录，不能预设为 0；同时覆盖 cross case、EOM、目标 sector coincidence 和非零 zero-point。

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
  b0[1]->beta1, b0[2]->beta2, b0[3]->beta3
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

其中 `masslessPack3={b3,n3}` 当 `s[v3]=s[v1]`，否则为 `{b3}`。每个 sign case 先确定实际 full/cross packs，再按第 8 节从原始乘积独立推导 sector；任务书不提供任何 sign case 的目标 sector 列表。massive line 1、2 等质量只表示共用 `nuM`，本 family 仍令 `symmetryRules={}`，不自动加入图对称性。

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
  b0[1]->beta1, b0[2]->beta2, b0[3]->beta3
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

每个 sign case 的 sector 集合都从三条线的完整原始乘积独立推导，任务书不列出目标答案。五个独立 loop scalar products为 `q1^2,q1.q2,q2^2,q1.k,q2.k`；三个 propagator square 加上述两个 ISP 必须先证明可反解。不能只在 `ispN=0` 检查：至少另取 `{r1,r2}={1,0}` 和 `{0,1}` 各一个最小 seed，验证两个 ISP 因子自身求导。

四个顶点符号组合、全部可达 sector、全部 active time，以及六个 momentum 生成元：

```text
d/dq1.q1, d/dq1.q2, d/dq1.k
d/dq2.q1, d/dq2.q2, d/dq2.k
```

三条线仍按当前逐线 `J` 表示分别保留 line pack；不得用其它 Head 替代这里的三槽 `J`，也不得由 pack 形状反推未经独立推导的分布结果。

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

各 sign case 的 sector 集合必须从两条 massive kernel 的完整乘积独立推导，并用统一 `J` 与 sector metadata 记录。另存一组 reference-only 参数对照：`a0[v1]=a0[v2]=2 nuM`、`b0[1]=b0[2]=-2 nuM`、`d=3-2 ep`、`s11=1`、`E1=E2`；它只用于比较旧 reference code，正式 benchmark 仍保留上面的 `alpha/beta` 非零符号 zero-point。

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
  b0[1]->beta1, b0[2]->beta2, b0[3]->beta3
};
generatorList = {dtau[v1],dtau[v2],
  dqq[1,1],dqq[1,2],dqk[1,1],
  dqq[2,1],dqq[2,2],dqk[2,1]};
symmetryRules = {};
```

`sp` 的 `Orderless` 必须让 `sp[k321,l3]` 与 `sp[l3,k321]` 自动一致，但不得展开或重命名用户的 `l3,k321,wdnmd`。三个 propagator square 与 `rho1=sp[l3,k321+l3]`、`rho2=sp[l3,wdnmd]` 必须显式证明可反解全部五个 loop scalar products。

同分支 top notation 是 `J[{a1,a2},{{b1,n1},{b2,n2},{b3,n3}},{r1,r2}]`，异分支把三个 `{b,n}` 都改成 `{b}`。各 sign case 的 sector 集合必须独立推导。专测：

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
  b0[1]->beta1, b0[2]->beta2, b0[3]->beta3
};
generatorList = {dtau[v1],dtau[v2],
  dqq[1,1],dqk[1,1],dqk[1,2]};
symmetryRules = {};
```

三条线的 `n[e]=1` 方向都固定为 `v1->v2`。当前逐线 top notation 是 `J[{a1,a2},{{b1,n1},{b2,n2},{b3,n3}},{}]`；异分支 top 则为 `J[{a1,a2},{{b1},{b2},{b3}},{}]`。该 family 的所有分布项、sector 和 coincidence 结果都必须直接从给定传播子定义独立推导，任务书不另给目标提示。

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
  b0[1]->beta1
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

但始终保留输入的 `a0[v]`、`b0[e]`，以及独立推导所得的 merged zero-point 与 `bS0[e]`。若关系退化为 0，可增加一个最小非零整数点并写明原因。`mixed_sunrise` 与 `two_loop_isp_toy` 必须额外取一个 `ispN[j]->1` 点。

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
  derivation.md
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

`derivation.md` 是必交的来源隔离记录。它必须从第 2 节允许的原始定义开始，列出实际使用的标准 Hankel 恒等式及来源，并展示得到 H/h 闭合关系、Wronskian、各 `n` shrink、massless endpoint 关系和 `J` 指标映射的中间步骤；不能只抄最终 expected。

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
- [ ] `derivation.md` 已记录外部恒等式来源和从原始定义到最终关系的推导链。
- [ ] H/h EOM、Wronskian、shrink 系数与 zero-point 均为独立推导，没有从 package note 补读。
- [ ] `family.wl` 的 `familyDefinition` 已包含第 9.0 节全部固定字段。
- [ ] README 已按 `vertexOrder/lineOrder/ispData` 顺序逐槽说明 `J[aList,linePacks,ispList]` 的物理对象。
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
- [ ] 保持当前逐线三槽 `J`，并已从原始乘积及明确的统一分布正则化独立推导全部非零 boundary 与可达 sector；未引入其它 Head，也未从任务书外补读答案。
