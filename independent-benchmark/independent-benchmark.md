# dS IBP 独立 benchmark 推导任务书

> **用途边界**：本文是交给其它 AI 的独立推导任务说明书。第一阶段只允许读取本文、公开文献和第 13.2 节逐路径许可的 reference source set，不得打开同目录的 `package/`；手推结果和来源记录冻结后，第二阶段才可读取其中的当前程序与正式用户手册，自行学习调用和比较。不要把本项目的手推答案、expected、check 或运行产物写入此目录。独立推导者应把结果输出到自己的新目录，维护者审查后再决定是否导入项目。

## 1. 任务目标

从本文给出的费曼规则、指标 convention 和函数族定义出发，完整执行第 2--17 节的独立审计。每一轮审计都必须在全新工作区从头推导第 2--13 节八个 graph-valid loop family 与两个 atomic `timeOnly` family、第 14--15 节 pure-time/tree 与全面物理工程闭环、第 16 节根号坐标，以及第 17 节显式双动量列表、图论/routing、cycle/fixed pack、pure-time、参数重定义和全 family 参数闭合。章节顺序只表示功能依赖层级，不表示可以跳过前序章节、沿用旧 expected、引用旧报告或只审计最新增量。除第 13.2 节逐路径许可的 reference source set 外，独立推导阶段禁止读取 `package/`、主线代码、`000_code/check/`、根目录 `check-smoke/`、旧 expected 或已有运行结果。`check-smoke/` 只供 package 维护者做非独立轻量检查，独立执行者在任何阶段都不得读取、复制、写入、引用或消费其中的脚本、结果与结论。第 2--17 节全部 expected 和推导记录冻结后，第二阶段只使用 `package/` 中当前提供的最新版本 package 和同版本正式手册完成全量单向对照。

**全量审计硬门禁**：本任务书中的“新增”“增量”“沿用”只描述公式或功能的依赖来源，不缩减本轮执行范围。任何执行计划若没有逐项覆盖第 2--17 节、第 9 节八个 graph-valid loop family 与两个 atomic `timeOnly` family、第 14 节两个 pure-time/tree family、根号坐标层、显式动量/fixed-line 全部任务及规定的两次 fresh reduction 闭环，即为未完成；不得用“前序已冻结”“已有报告”或“当前只改最新功能”为由跳过。

**当前 package 解析规则**：Phase 1 冻结前不得读取 `package/`。进入 Phase 2 后，先枚举 `package/package_<三位版本>.wl` 与同版本 PDF；交付目录必须只有一对当前版本化程序和手册。把唯一文件名中的三位 token 记为 `currentVersion`，用 `Get[唯一程序路径]` 加载所提供的最新 package，再要求 `$dSIBPVersion===currentVersion`；报告文件名也使用该动态 token。任何验证脚本、命令或文字指令都不得写死某个历史或当前版本号，不得通过仓库内 `000_code/<版本目录>/`、旧单文件或旧报告旁路加载；若版本化文件不唯一、程序/PDF token 不一致或运行时版本不匹配，立即停止。

任务范围完整性索引如下；它只帮助定位任务，不替代各节的具体验收条件：

| 审计范围 | 权威章节 |
| --- | --- |
| SK building block、统一 `J`、zero-point、massless 有序指标、EOM/Wronskian/common-theta、time/momentum IBP 与可达 sector | 第 2--8 节 |
| 第 9 节八个 loop family 与两个 atomic `timeOnly` family、固定一个纯同号与一个混合分支、两分支全部适用 seeds、ISP、对称性与冻结输出 | 第 9--12 节 |
| `ds[expr,variable]`、系数乘积法则、reference convention、direct-h/bare-H/H-to-h | 第 13 节 |
| 两/三顶点 pure-time seed、loop-to-tree 投影、迭代约化、同序 masters、dlog DE 与 `G+-` contact guard | 第 14 节 |
| 全量 package/消息/API/examples、Kira 信息生成与完整结果回读、DE/scaling、tree naive/dlog 双路线 | 第 15 节 |
| `ssij/sEi` 根号坐标、Jacobian、数值映射、旧坐标兼容与 generator/ISP 隔离 | 第 16 节 |
| `kL/kE`、图论/routing、cycle/fixed、`timeOnly`、参数重定义、bubble+tree、全 family 参数闭合、条件性 EOM/symmetry/canonical、zero-point 与源码审阅 | 第 17 节 |
| 来源隔离、逐项完成状态、差值/计数/哈希和最终报告门禁 | 第 18 节 |

术语约定：本文以后把 `loopExternalMomenta` 的按序元素简称为 `kL1,kL2,...`，把 `independentExternalMomenta` 的按序元素简称为 `kE1,kE2,...`。这是两套互不共享的列表位置编号，不要求输入符号真的采用这些名字；审计时仍以字段角色和原始表达式为准。

除第 15.3 节默认坐标闭环及第 17.3 节对同一 fixed-parity 系统的 exact 自定义坐标复跑外，只做 seed-level 小型符号推导：

- 不生成大范围解析 IBP。
- 不做大范围撒点。
- 第一阶段不运行 Kira、Fermat、Rational Tracer 或其它 reduction；只有第 15.1--15.2 节冻结并通过后，才按第 15.3 节运行两套且仅两套代表性 fresh reduction：reference pure massive bubble 与第 17.4 节 mixed bubble+tree exact 自定义坐标系统。两次 reduction 的输入 hash、manifest 与结果目录不得混用；其它 family 只做符号 seed/`linearData`/`ds`/DE-operator 检查，不重复运行昂贵 reduction。
- 解析 seed 保持非零符号 zero-point。
- 每个函数族只使用第 9.0 节冻结的一个纯同号分支和一个混合分支；两个分支内部必须覆盖所有实际可达 sector、每个 sector 的全部 time 与 loop-momentum 生成元，以及全部适用离散 `n=0/1` 状态，不得再次抽样。
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

其中第一端点永远是 u[e]，第二端点永远是 v[e]。端点顺序不是无关 metadata：massive 与 massless 的 `n[e,1]/n[e,2]` 都依赖它；massless 的两槽还满足第 4 节要求独立推导并冻结的 quotient relations。

去掉与 IBP 无关的整体耦合常数后，一个 top-sector 被积函数统一理解为

    Product[d tau[v] (-tau[v])^A[v] Exp[-I s[v] E[v] tau[v]],v]
    Product[d^d q[l],l]
    Product[q[e]^(-B[e]) PropagatorBlock[e],e]
    Product[ISP[r]^ispN[r],r]

其中 A[v]=a[v]+a0[v]，B[e]=b[e]+b0[e]。顶点相位固定为

    s[v]=+1: Exp[-I E[v] tau[v]]
    s[v]=-1: Exp[+I E[v] tau[v]]

只进入顶点相位的独立标量 `E[v]` 不自动属于 `loopExternalMomenta` 或 `independentExternalMomenta`。对一个固定的 `vertexSigns` case，SK contour 顶点因子、耦合常数、整体动量守恒 delta、1/2、pi 和其它不依赖积分变量的 normalization 都是整条齐次 IBP 的共同因子，统一提出且不写入 `J`。不得把这些共同因子误当成端点导数符号；不能提出的是 theta 导数的相对符号和 massive shrink 的 Wronskian prefactor。

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

对按 `loopExternalMomenta={kL1,...,kLK}` 排序的圈外向量基，缺省外部标量积根号坐标统一命名为

```text
ssij := Sqrt[sp[kLi,kLj]] = ssji,    1 <= i <= j <= K.
```

在 Mathematica 输出中写成符号 `ss11,ss12,...`，因此反向规则是 `sp[kLi,kLj]->ssij^2`。`ssij` 是点积的根，不是 `|kLi+kLj|`；后者必须由原始矢量和 `Sqrt[sp[kLi+kLj,kLi+kLj]]` 表示。名称 `ssij` 只用于对称的外部不变量坐标，不用来命名有序方向导数算符。用户不输入缺省规则；只有第 16 节 compatibility probe 才显式输入旧 `externalInvariantRules` 平方坐标。

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

正式 `J` 只保存 `n=0,1`。独立推导者必须仅从上述 Hankel 定义出发推导 h 的闭合微分关系；第 9.0 节点名的两个 H family 还必须独立推导裸 H 的闭合关系，再把导数产生的更高 `n` 消回各自基底。本文不提供任何 H/h 微分方程、矩阵、递推系数或指标移位答案。

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

对 `massiveFull`，独立推导者必须从 theta 导数与上述两个 Wightman block 出发，判断哪些 `n[e,1],n[e,2]` 产生非零 coincidence 项，并推导直接 h 的 Wronskian 等式、端点符号、prefactor 及缩并后的时间/动量幂。第 9.0 节点名的两个 H family 还要对裸 H 独立完成同样推导。本文不提供这些等式或具体 shrink 公式。`massiveCross` 是否存在相同机制也必须直接由所给 kernel 判断。

### 2.4 Massless 四种 SK 传播子与全部正负号

对 massless 线仍使用有序端点 `{u,v}` 和 `Delta=tau[u]-tau[v]`。标准共同因子 `1/(2q)` 中，数值 `1/2` 可作为 normalization 提出，固定动量幂 `q^-1` 必须计入该线输入的 `b0[e]`；下列 `D` 只表示余下的指数/theta kernel：

    D++ = theta[ Delta] Exp[-I q Delta]
        + theta[-Delta] Exp[+I q Delta]

    D-- = theta[ Delta] Exp[+I q Delta]
        + theta[-Delta] Exp[-I q Delta]

    D+- = Exp[+I q Delta]
    D-+ = Exp[-I q Delta].

同分支 `++/--` 记为 `masslessFull`；异分支 `+/-/-+` 记为 `masslessCross`。`masslessFull` 的 `n=0,1` 基底定义见第 4 节；`masslessCross` 不设置离散 `n`。所有 time/momentum 导数、theta-delta、端点反转和 coincidence 结果都必须从这些 kernel 独立推出。

### 2.5 外腿能量、两类外部向量与输出不变量

用户必须显式给出两张有序列表，程序不得从符号名或首次出现位置猜角色：

- `loopExternalMomenta` 只列进入 cycle-line routing 并与圈动量形成 scalar-product 空间的独立外向量基；其完整 Gram 根号坐标为 `ssij`。
- `independentExternalMomenta` 列出实际出现在无圈 line、`extLegs` 或被审计相位中的无圈动量模长方向；它们不进入 loop generator/ISP closure，只对独立模长依列表顺序生成 `sE1,sE2,...`，从属模长保存 binding。

顶点相位若复用某个矢量模长，输入仍写原始表达式 `Sqrt[sp[p,p]]`，初始化后才由缺省规则变成相应 `ssij` 或 `sEi`；与两类矢量都无关的相位参数继续写独立标量 `E[v]`。例如 `|p1+p5|` 与 `|p1|+|p5|` 是不同对象；前者输入为 `Sqrt[sp[p1+p5,p1+p5]]`，后者只能由用户通过参数重定义或不同 topology 明确绑定，程序不得自动相加模长。

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

每个 ISP 使用当前最新 package 的公开 Association schema：

```mathematica
<|"name" -> rho1, "expr" -> sp[q1,k], "range" -> {0,1}|>
```

`name` 是用户侧唯一符号，`expr` 是由声明动量基组成的标量积表达式，`range` 是该 numerator 指标在 seed 中允许的值域。独立推导与 package 对照均直接使用这三个字段，不设 `id/expression` adapter。

每个 line pack 内部的槽位由图论线型和 SK 状态共同固定。`ibpMode->"full"` 时只有 cycle line 使用 indexed-power schema；bridge/non-cycle line 使用 fixed-coefficient schema。`ibpMode->"timeOnly"` 时全部 active lines 都使用 fixed-coefficient schema：

| line 状态 | cycle pack | fixed pack | 各槽对应的物理对象 |
|---|---|---|---|
| unshrunk massiveFull/massiveCross | `{b[e],n[e,1],n[e,2]}` | `{"F",n[e,1],n[e,2]}` | 两个 `n` 分别对应有序端点；只有 cycle pack 的 `b[e]` 是可移位整数动量幂 |
| unshrunk masslessFull | `{b[e],n[e,1],n[e,2]}` | `{"F",n[e,1],n[e,2]}` | 两个端点槽保持方向；四个离散态在 quotient relations 下约到二维物理基 |
| unshrunk masslessCross | `{b[e],0,0}` | `{"F",0,0}` | cross 没有活动 theta 基底指标，但仍保留固定三槽 shape |
| shrunk line | `{bS[e]}` | `{"F"}` | cycle/fixed 都保留原 root line 位置；单槽 shape 隐式、可逆地编码 shrink set |

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

1. unshrunk massiveFull/massiveCross：cycle 取 `packp={b,nFirst,nSecond}`，fixed 取 `packp={"F",nFirst,nSecond}`。fixed 情形没有整数 `b`；其模长幂由当前 sector 的结构化 prefactor 保存，并在物化 `J_s=N_s I_s` 时恢复：

   ```text
   LineBlock[e,{b,nFirst,nSecond}]
     = q[e]^(-(b+b0[e]))
       G[s[u[e]],s[v[e]];e,nFirst,nSecond]
   ```

   `G` 是第 2.3 节的相应 SK kernel；`nFirst` 选择第一有序端点 `u[e]` 上的 `F[type,*,nFirst]`，`nSecond` 选择第二端点 `v[e]` 上的 `F[type,*,nSecond]`。二者都是 `partial_x` 阶数，正式值为 `0` 或 `1`。

2. unshrunk masslessFull：cycle 取 `packp={b,nFirst,nSecond}`，fixed 取 `packp={"F",nFirst,nSecond}`：

   ```text
   LineBlock[e,{b,nFirst,nSecond}]
     = q[e]^(-(b+b0[e])) M[sigma[e],nFirst,nSecond;
                                  q[e],tau[u[e]]-tau[v[e]]]
   ```

   这里 `b` 是可移位的整数动量幂，`b0[e]` 包含 family 指定的固定幂（包括采用标准 `1/(2q)` normalization 时的 `q^-1`）。两个 `n` 不是附加幂；它们是端点有序状态。独立推导必须证明 `F[e,0,1]+F[e,1,0]=0`、`F[e,1,1]+F[e,0,0]=0` 或给出等价的两条线性关系，并冻结 canonical 方向；不得从 package 抄取。

3. unshrunk masslessCross：cycle 取 `packp={b,0,0}`，fixed 取 `packp={"F",0,0}`：

   ```text
   LineBlock[e,{b,0,0}]
     = q[e]^(-(b+b0[e])) D[s[u[e]],s[v[e]];e]
   ```

   `D` 是第 2.4 节的 `D+-` 或 `D-+`。两个零是固定 shape 的非活动端点槽，不得当作可撒点变量。

4. shrunk line：cycle 取 `packp={bS}`，fixed 取 `packp={"F"}`：

   ```text
   LineBlock[e,{bS}] = q[e]^(-(bS+bS0Sector[e]))       (* cycle *)
   LineBlock[e,{"F"}] = q[e]^(-BFixedSector[e])        (* fixed *)
   ```

   原传播子函数和端点 `n` 已不在 `J` 中；cycle 的 `bS0Sector[e]` 及 merged-time zero-point 是待独立推导的 sector metadata。fixed line 仍保留 `{"F"}` 槽；其模长幂、zero-point 与幂移属于结构化 sector prefactor，并通过 normalized source/target 比值进入 relation coefficient，不得伪造 `b/bS` 槽或重复外乘。

第三槽中 `zr` 是 `ispData[[r]]["expr"]` 的幂：`zr>0` 表示 numerator，`zr=0` 表示没有该因子，`zr<0` 表示其倒数。第三槽顺序只能跟随 `ispData`，不能按表达式名称重新排序。

例如 atomic massless `timeOnly` 同分支 top sector 的

```mathematica
J[{a1,a2},{{"F",n11,n12}},{}]
```

明确代表

```text
(-tau1)^(a1+alpha1) (-tau2)^(a2+alpha2)
Exp[-I s1 E1 tau1] Exp[-I s2 E2 tau2]
q1^(-beta1) M[sigma,n11,n12;q1,tau1-tau2]
```

其中 `{s1,s2}={+1,+1}` 时 `sigma=+1`，`{-1,-1}` 时 `sigma=-1`，双端点状态与 `M[0]/M[1]` 的 quotient 见第 4 节。异分支使用 `J[{a1,a2},{{"F",0,0}},{}]` 和 `D+-/D-+`；两个零不参与撒点。任何 fixed 模长幂移都进入结构化 sector prefactor及其 source/target normalization 比值。

### 3.2 幂次零点 convention

零点用于固定每个积分族的指标原点。它把“固定但不参加整数移位的幂”与“IBP 关系中沿整数格点变化的指标”分开：

| 对象 | `J` 中保存 | metadata 中保存 | 被积函数中的实际幂次 |
|---|---|---|---|
| active 顶点 `v` | `a[v]` | `a0Sector[v]` | `(-tau[v])^(a[v]+a0Sector[v])` |
| unshrunk cycle line `e` | `b[e]` | `b0[e]` | `q[e]^(-(b[e]+b0[e]))` |
| shrunk cycle line `e` | `bS[e]` | `bS0Sector[e]` | `q[e]^(-(bS[e]+bS0Sector[e]))` |
| fixed/bridge/timeOnly line `e` | 无 `b/bS` 槽 | `b0[e]` 及 sector 派生零点 | 全部物理幂在显式系数中 |
| ISP `r` | `ispList[[r]]` | 无零点 | `ispData[[r]]["expr"]^ispList[[r]]` |

这里的符号约定必须严格区分：`a` 是正的时间幂指标；cycle line 的 `b/bS` 是分母幂指标，所以实际 `q` 指数前有负号。`a0/b0/bS0` 可以是符号、质量参数的函数或其它固定表达式，不要求为整数；只有实际存在于 `J` 的 `a/b/bS` 才是 IBP 后端整数移位变量。fixed line 即使输入 `b0[e]`，也不能据此获得 `b` 槽。

对 top sector，family 输入必须为 `vertexOrder` 中每个顶点显式给出唯一的 `a0[v]`，并为 `lineOrder` 中每条 unshrunk line 显式给出唯一的 `b0[e]`。即使当前 package 在缺少规则时技术上可回退到 0，独立 benchmark 也禁止依赖这个缺省，否则“确实为 0”和“漏填输入”无法区分。

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

## 4. 有序 massless 双端点 quotient convention

对同分支 massless full line，`lineData["endpoints"] -> {u,v}` 是有序输入。第一端点 `u` 定义反对称 `n=1` 的方向。令 `Delta=tau[u]-tau[v]`，`sigma=+1` 对应 `++`，`sigma=-1` 对应 `--`：

```text
M[sigma,0;q,Delta] = theta[ Delta] exp[-i sigma q Delta]
                   + theta[-Delta] exp[ i sigma q Delta]

M[sigma,1;q,Delta] = -theta[ Delta] exp[-i sigma q Delta]
                   +  theta[-Delta] exp[ i sigma q Delta]
```

这里两条式子定义二维物理基 `M[0]/M[1]`，不是导数恒等式。017 公开指标不再把它压成单槽，而以 `F[e,n1,n2]` 保留两个有序端点槽；四个 `n1,n2 in {0,1}` 状态必须通过两条独立关系约到上述二维基，并选定 `n2->0` 的 canonical 方向。公开 line pack 始终是 `{b,n1,n2}` 或 `{"F",n1,n2}`。

独立推导者必须分别对 `++`、`--` 和两个有序端点，从定义直接推导：

- 四个双端点状态的两条 quotient relations 及其 canonical 符号；
- canonical 二维基的 time/momentum 导数闭合关系；
- theta 导数产生的分布项及其端点符号；
- 端点反转、同端点二阶导数和 coincidence 后的 canonical 关系；
- 对每个 `n1,n2 in {0,1}`，是否产生 shrink，以及产生时的系数、`bS` 和 sector zero-point。

massless cross line 的行为只允许从第 2.4 节给出的 `D+-/D-+` 直接推导；其公开 pack 固定为 `{b,0,0}` 或 `{"F",0,0}`，两个零不参与离散撒点。

## 5. Massive EOM、Wronskian 与 shrink 的独立推导要求

massive full/cross 在两个端点各保留 `n[e,1],n[e,2]`。所有含 massive line 的 family 都必须对直接 h 基底完成以下推导。裸 H 只在第 9.0 节固定的 `atomic_massive_line` 与 `pure_massive_bubble_reference` 两个 family 中手推；这两个 family 不能用 h 的结果通过参数替换猜 H：

1. 从第 2.2 节的 Hankel 定义推导 `n=0,1` 基底的闭合微分关系，并把 time/momentum 导数翻译成 `J` 指标移位。
2. 对导数产生的所有更高 `n` 给出消回 `n=0,1` 的过程；最终 expected 中不得保留 massive `n>=2`。
3. 从第 2.3 节四种 SK kernel 逐一判断 theta boundary 是否存在。
4. 对 `(n[e,1],n[e,2])=(0,0),(0,1),(1,0),(1,1)`，分别计算 coincidence 项；需要时推导对应的 Wronskian 等式、两个端点的符号和完整 prefactor。
5. 对每个非零 shrink 结果，独立推导物理 factor，再严格按第 3.2 节固定的整数/zero-point 分解记录 merged vertex 与 `a/a0`；cycle line 另记录 `bS/bS0`，fixed line 则把对应模长幂和 zero-point 全部写入显式系数，不生成 `bS` 槽。

本节刻意不提供 H/h 微分方程、Wronskian 数值、非零 `n` 条件、SK sign offset、prefactor 或任何 shrink 指标公式。所有这些都是 benchmark 要比较的答案。

上述两个 H family 还必须从第 2.2 节定义独立导出把裸 H 导数基底变到 h 导数基底的矩阵 `T_Htoh`。第二阶段分别把同一裸 H 的 `P_H,Q_H,W_H` 与 `T=IdentityMatrix[2]`、`T=T_Htoh` 交给 package；不得直接抄 package 中的 preset 或变换矩阵作为手推输入。三路 package 验收见第 13.3 节。

## 6. Time-IBP

对每个当前 sector 的 active vertex `v` 推导

```text
0 = integral d/dtau[v] (integrand)
```

必须直接对第 2.1 节的原始被积函数使用乘积法则，覆盖顶点幂、顶点相位以及所有连接到该 active vertex 的传播子端点。regular、分布项、EOM 和 coincidence canonical 的系数与指标变化均属于独立推导结果，本文不列公式。

缩并后若某条未缩并线的两个原端点都映到同一个 active vertex，对该 active time 求导时两个端点贡献必须都算；不能只取第一个匹配端点。

## 7. Loop-momentum IBP

本节只适用于 `ibpMode->"full"`。设圈动量数为 `L`，`loopExternalMomenta` 的有效独立基数为 `K`。完整生成元为

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
2. 所有 cycle-line denominator 幂次导数，包括 shrunk cycle line 的 `BS[e]`；fixed/bridge line 不得进入 `xi` 集合，也不得产生 `b/bS` shift。
3. 所有 cycle massive building block 对线动量模的导数。
4. 所有 cycle massless full/cross 指数核对线动量模的导数。
5. ISP 因子自身的导数，以及标量积因子吸收到 propagator/ISP 指标后的移位。
6. 立即 EOM/canonical。`timeOnly` family 不生成本节关系；其 fixed 模长导数属于 `ds`，不是伪造的 loop generator。

用户端标量积统一写 `sp[p,r]`，且 `sp` 对称。这里仅指标量积交换性，不是图或积分族指标对称性。用户可给圈动量和两类外动量任意符号名。`loopExternalMomenta` 的 Gram 输出使用缺省 `ssij` 或 exact 自定义变量，不保留成裸 `sp[kLi,kLj]`；`independentExternalMomenta` 的独立模长输出使用 `sEi`，不主动生成无圈动量之间的交叉点积。

`loopExternalMomenta` 只包含会与圈动量纠缠的外向量基。只进入无圈 line/外腿/相位的矢量模长由 `independentExternalMomenta` 声明，并以原始 `Sqrt[sp[p,p]]` 输入；与两类矢量都无关的相位参数用独立 `E[v]`。`|p1+p2|` 与 `|p1|+|p2|` 不得自动混同。

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
5. 每个 sector 必须覆盖全部 active time 生成元、`ibpMode->"full"` 时全部 `L(L+K)` momentum 生成元和该 sector 全部离散 `0/1` 状态。即使某条 canonical 关系变成 0，也保留记录并注明原因。

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
  "loopExternalMomenta" -> {...},
  "independentExternalMomenta" -> {...},
  "ibpMode" -> "full" | "timeOnly",
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

上面的 `familyDefinition` 是 Phase 1 冻结多个 sign case 的独立 oracle descriptor，不是可以原样交给 package 的旧输入。Phase 2 必须对每个 `vertexSignCases` 条目构造当前公开 `caseInput`：使用 `"vertexData"` 写入该分支的顶点符号，并使用 `"lineData"`、`"extLegs"`、`"loopMomenta"`、`"loopExternalMomenta"`、`"independentExternalMomenta"`、`"ibpMode"`、`"vertexEnergies"`、`"ispData"`、`"zeroPointRules"` 和 `"symmetryRules"`；不得生成 `externalMomenta/externalLegMomenta/externalInvariantRules` adapter。只有第 16 节明确点名的旧平方坐标 compatibility probe 例外。

`lineData` 中每条线必须逐项写明 `id`、`endpoints`、`momentum`、`massType`、`bbType` 和 `nu`。`endpoints->{u,v}` 是有序数据；对 massless 线，该顺序固定双端点 quotient 的符号和 canonical 方向。即使所有线连接同一对顶点，也不允许省略该字段。

各 family 输入块里的 `zeroPointRules` 只列 unshrunk `a0[v]`、`b0[e]`。独立输出应在 README/derivation 中另列由推导得到的 merged-vertex zero-point、`bS0[e]` 和 shrink normalization；不得把这些派生量倒填成任务输入。

本文统一使用下列 017 pack 规则；左列为 cycle，右列为 fixed/bridge/timeOnly：

```text
massiveFull 或 massiveCross: {b[e],n[e,1],n[e,2]} | {"F",n[e,1],n[e,2]}
masslessFull:                 {b[e],n[e,1],n[e,2]} | {"F",n[e,1],n[e,2]}
masslessCross:                {b[e],0,0}           | {"F",0,0}
shrunk:                       {bS[e]}              | {"F"}
```

各 family 数据块后展示的 top notation 就是 `topIntegralTemplate` 必须保存的值。它必须分别展示同分支与异分支时实际的 `J`，不能只写一个无法判断 pack 长度的占位符。ISP 被积函数约定为 `ISP[r]^ispN[r]`，故正 `ispN` 表示 numerator 幂，并按 `ispData` 顺序放入 `J` 第三槽。

sector 名统一为 `"top"` 或按 `lineOrder` 排序的 `"e1"`、`"e1_e3"` 等。某 sign case 只枚举由第 8 节独立推导实际到达的 line sets；cross 线没有 theta 导数，不应伪造 shrink sector。缩并后以 `vertexOrder` 中序号最小的顶点作为合并类代表，`aList` 按代表顶点的原顺序排列。

本 benchmark 的 sign 分支不在运行时抽样。每个 family 固定一个纯同号分支和一个混合分支；`vertexSignCases` 只写下表两项。分支数量被收缩，但两个入选分支内部不得再抽样：必须遍历全部 contact-reachable sector、全部 active time 生成元、`ibpMode->"full"` family 的全部 `L(L+K)` momentum 生成元和全部剩余离散态，从而生成这两个分支的全部适用 IBP seeds。两个 atomic family 明确使用 `timeOnly`，不得为单 bridge 伪造圈数或 `dqq`。

| family | 固定纯同号分支 | 固定混合分支 | massive 基底范围 |
| --- | --- | --- | --- |
| `atomic_massless_line` | `++` | `+-` | 不适用 |
| `atomic_massive_line` | `--` | `-+` | 直接 h；裸 H `T=I`；H 经 `T_Htoh` 变到 h |
| `pure_massless_bubble` | `--` | `+-` | 不适用 |
| `mixed_bubble` | `++` | `-+` | 直接 h |
| `mixed_triangle` | `---` | `+-+` | 直接 h |
| `mixed_sunrise` | `++` | `+-` | 直接 h |
| `pure_massive_bubble_reference` | `--` | `-+` | 直接 h；裸 H `T=I`；H 经 `T_Htoh` 变到 h |
| `two_loop_isp_toy` | `++` | `-+` | 不适用 |
| `massless_sunrise_bundle_guard` | `--` | `+-` | 不适用 |
| `vertex_energy_signs` | `++` | `-+` | 不适用；三组 energy case 均使用这两个 sign 分支 |

这张表就是冻结后的选择，不需要随机种子，也不得由执行脚本重新选择。所有含 massive line 的 family 都手推并运行直接 h 的 package 对照；H 只允许出现在表中点名的两个 family。

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
  "++"->{+1,+1}, "+-"->{+1,-1}|>;
loopMomenta = {};
loopExternalMomenta = {};
independentExternalMomenta = {ell};
ibpMode = "timeOnly";
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
generatorList = {dtau[v1],dtau[v2]};
derivativeVariables = {sE1};
symmetryRules = {};
```

同分支 top、异分支 top 和同分支 shrink 的 notation 分别为

```mathematica
J[{a1,a2},{{"F",n11,n12}},{}]
J[{a1,a2},{{"F",0,0}},{}]
J[{a12},{{"F"}},{}]
```

sector 为：`++ -> {top,e1}`，`+- -> {top}`。另建端点反转子例，只把 line 1 改为 `endpoints->{v2,v1}`，物理动量和其它输入不变；端点反转对双端点 quotient 的作用必须由第 4 节定义推导。

Phase 2 按正式用户手册所述的公开 workflow 验收，不在任务书中另行规定通用调用教程或私有分派参数。验收合同仅为：`++` 的公开 canonical seed batch 必须保留三槽 fixed line pack、覆盖 top 的四个双端点输入状态、quotient canonical 与 `{top,e1}` 两个 sector，并能生成 backend-neutral linear data；`+-` 只覆盖 `{top}`。任何必须依赖未公开状态参数才能得到这些结果的实现均不通过。

专测：

- `(n1,n2) in {0,1}^2`、两条 quotient relations与 canonical 方向；
- 固定的 `++` 与 `+-` 两个分支；
- 端点反转；
- 同端点二阶导数；
- 四个双端点状态各自的 theta-delta、shrink 和 coincidence 结果；
- massless full/cross 对 fixed 模长 `sE1` 的总导数及显式幂系数；
- 顶点外部相位符号。

### 9.2 atomic_massive_line

除 sign 分支按第 9.0 节固定为 `--` 与 `-+` 外，其余定义与 9.1 相同；line 1 改为

```mathematica
lineData = {
  <|"id"->1, "endpoints"->{v1,v2}, "momentum"->ell,
    "massType"->"massive", "bbType"->mode, "nu"->nuM|>
};
basisRoutes = {"h","HIdentity","HToh"};
zeroPointRules = {
  a0[v1]->alpha1, a0[v2]->alpha2, b0[1]->beta1
};
```

top 与 shrink notation 为

```mathematica
J[{a1,a2},{{"F",n11,n12}},{}]
J[{a12},{{"F"}},{}]
```

massive cross 的 top notation 与 full 完全相同，但没有 `e1` sector。sector 为：`-- -> {top,e1}`，`-+ -> {top}`。`generatorList={dtau[v1],dtau[v2]}`、`derivativeVariables={sE1}`、`symmetryRules={}`。直接 h 与裸 H 的 shrink zero-point、prefactor、fixed 模长显式系数和指标移位必须分别从定义推导；`HToh` 使用同一裸 H 输入与独立推导的 `T_Htoh`，不是第三种物理传播子。

分别对直接 h 与裸 H 做物理检查，并对 `HToh` 做第 13.3 节的等价性检查：

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
  "--"->{-1,-1}, "+-"->{+1,-1}|>;
loopMomenta = {q};
loopExternalMomenta = {k};
independentExternalMomenta = {};
(* 缺省输出：sp[k,k]->ss11^2。 *)
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

两条 massless 线的第一端点都固定为 `v1`；双端点槽都按 `v1->v2` 排序。top notation 为

```text
-- : J[{a1,a2},{{b1,n11,n12},{b2,n21,n22}},{}]
+- : J[{a1,a2},{{b1,0,0},{b2,0,0}},{}]
```

各 sign case 的 sector 集合必须从两条传播子的完整乘积独立推导，不在任务书中预先给出。例如某个只缩并 line 1 的候选结果按指标槽写成 `J[{a12},{{bS1},{b2,n21,n22}},{}]`；它是否非零、是否还有其它结果以及 coincident 双端点态如何 canonical，都必须从第 4 节定义判断。

必须覆盖：

- 固定的 `--` 与 `+-` 两个分支；
- 每个 case 的全部可达 sector；
- 每个 sector 全部 time 和 `d/dq.q`、`d/dq.k`；
- 所有剩余 masslessFull `(n1,n2) in {0,1}^2`，并在 relation 层验证 quotient canonical。

本 benchmark 保留 017 逐线 `J` 表示：每条 masslessFull 线各自保留 `{b[e],n[e,1],n[e,2]}`。这只是输出槽 convention，不规定多传播子乘积的分布结果；独立推导必须从原始乘积确定 quotient、contact 与 canonical 各项，不能把 package 的实现或当前 expected 当作输入。

### 9.4 mixed_bubble

固定使用 9.3 的顶点、动量空间、外不变量、能量和生成元，但 sign 分支按第 9.0 节改为 `++` 与 `-+`；line 1 改为 massive h：

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
++ : J[{a1,a2},{{b1,n11,n12},{b2,n21,n22}},{}]
-+ : J[{a1,a2},{{b1,n11,n12},{b2,0,0}},{}]
```

各 sign case 的 sector 集合必须从 mixed 原始乘积独立推导。massive/massless 的 shrink factor、`bS0` 与 merged `a0` 必须按第 3.2 和第 5 节要求独立推导并记录，不能预设为 0；同时覆盖 cross case、EOM、目标 sector coincidence 和非零 zero-point。

### 9.5 mixed_triangle

固定定义：

```mathematica
vertexOrder = {v1,v2,v3};
vertexSignCases = <|
  "---"->{-1,-1,-1}, "+-+"->{+1,-1,+1}|>;
loopMomenta = {q};
loopExternalMomenta = {k1,k2};
independentExternalMomenta = {};
(* 缺省输出：sp[k1,k1]->ss11^2、sp[k1,k2]->ss12^2、sp[k2,k2]->ss22^2。 *)
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

该图有三条内线、三个顶点和一个连通分量，故根图圈数固定为 `3-3+1=1`。`L=1,K=2` 的 loop scalar-product 空间为 `{q^2,q.k1,q.k2}`；三条传播子平方已经给出满秩坐标，所以 `ispData={}`，momentum generators 恰为下面列出的三个。不得把本 family 按两圈 descriptor 枚举，也不得把 line routing 中的 `q` 猜成未声明的 `q1` 或 `q2`。

massless line 3 的正方向是 `v3->v1`，不能为了按顶点编号排序而改写成 `{v1,v3}`。top notation 为

```mathematica
J[{a1,a2,a3},
  {{b1,n11,n12},{b2,n21,n22},masslessPack3},{}]
```

其中 `masslessPack3={b3,n31,n32}` 当 `s[v3]=s[v1]`，否则为 `{b3,0,0}`。每个 sign case 先确定实际 full/cross packs，再按第 8 节从原始乘积独立推导 sector；任务书不提供任何 sign case 的目标 sector 列表。massive line 1、2 等质量只表示共用 `nuM`，本 family 仍令 `symmetryRules={}`，不自动加入图对称性。

要求：

- 固定的 `---` 与 `+-+` 两个分支；
- 每个 sector 的全部 active time；
- `d/dq.q`、`d/dq.k1`、`d/dq.k2`；
- 全部剩余 massive/massless 离散状态；
- 缩并导致的顶点合并、coincident line 和 sector zero-point。

### 9.6 mixed_sunrise

固定定义：

```mathematica
vertexOrder = {v1,v2};
vertexSignCases = <|
  "++"->{+1,+1}, "+-"->{+1,-1}|>;
loopMomenta = {q1,q2};
loopExternalMomenta = {k};
independentExternalMomenta = {};
(* 缺省输出：sp[k,k]->ss11^2。 *)
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
  <|"name"->rho1,"expr"->sp[q1,k],"range"->{0,1}|>,
  <|"name"->rho2,"expr"->sp[q2,k],"range"->{0,1}|>
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

两条 massless 线 2、3 的双端点槽都按 `v1->v2` 排序。top notation 为

```text
++ / -- :
J[{a1,a2},
  {{b1,n11,n12},{b2,n21,n22},{b3,n31,n32}},
  {r1,r2}]

+- / -+ :
J[{a1,a2},
  {{b1,n11,n12},{b2,0,0},{b3,0,0}},
  {r1,r2}]
```

每个 sign case 的 sector 集合都从三条线的完整原始乘积独立推导，任务书不列出目标答案。五个独立 loop scalar products为 `q1^2,q1.q2,q2^2,q1.k,q2.k`；三个 propagator square 加上述两个 ISP 必须先证明可反解。不能只在 `ispN=0` 检查：至少另取 `{r1,r2}={1,0}` 和 `{0,1}` 各一个最小 seed，验证两个 ISP 因子自身求导。

固定的 `++` 与 `+-` 两个分支、全部可达 sector、全部 active time，以及六个 momentum 生成元：

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
  "--"->{-1,-1}, "-+"->{-1,+1}|>;
loopMomenta = {q};
loopExternalMomenta = {k};
independentExternalMomenta = {};
(* 缺省输出：sp[k,k]->ss11^2。 *)
vertexEnergies = <|v1->E1,v2->E2|>;
lineOrder = {1,2};
lineData = {
  <|"id"->1, "endpoints"->{v1,v2}, "momentum"->q,
    "massType"->"massive", "bbType"->mode, "nu"->nuM|>,
  <|"id"->2, "endpoints"->{v1,v2}, "momentum"->q-k,
    "massType"->"massive", "bbType"->mode, "nu"->nuM|>
};
basisRoutes = {"h","HIdentity","HToh"};
ispData = {};
zeroPointRules = {
  a0[v1]->alpha1, a0[v2]->alpha2,
  b0[1]->beta1, b0[2]->beta2
};
generatorList = {dtau[v1],dtau[v2],dqq[1,1],dqk[1,1]};
```

`mode="h"` 表示直接 h。`HIdentity` 与 `HToh` 都以裸 H 的 `P_H,Q_H,W_H` 为输入；前者取 `T=IdentityMatrix[2]`，后者取独立推导的 `T_Htoh`，不得把 `HToh` 当成 package 内置 mode 字符串。

两个固定 sign case 的 top notation 都是

```mathematica
J[{a1,a2},{{b1,n11,n12},{b2,n21,n22}},{}]
```

各 sign case 的 sector 集合必须从两条 massive kernel 的完整乘积独立推导，并用统一 `J` 与 sector metadata 记录。另存一组 reference-only 参数对照：`a0[v1]=a0[v2]=2 nuM`、`b0[1]=b0[2]=-2 nuM`、`d=3-2 ep`、当前根号坐标 `ss11=1`（等价于旧 reference 平方变量 `s11Ref=1`）、`E1=E2`；它只用于比较旧 reference code，正式 benchmark 仍保留上面的 `alpha/beta` 非零符号 zero-point。

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
  "++"->{+1,+1}, "-+"->{-1,+1}|>;
loopMomenta = {l3,k321};
loopExternalMomenta = {wdnmd};
independentExternalMomenta = {};
(* 缺省输出：sp[wdnmd,wdnmd]->ss11^2。 *)
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
  <|"name"->rho1,"expr"->sp[l3,k321+l3],"range"->{0,1}|>,
  <|"name"->rho2,"expr"->sp[l3,wdnmd],"range"->{0,1}|>
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

同分支 top notation 是 `J[{a1,a2},{{b1,n11,n12},{b2,n21,n22},{b3,n31,n32}},{r1,r2}]`，异分支把三个 pack 都改成 `{b,0,0}`。各 sign case 的 sector 集合必须独立推导。专测：

- propagator 加 ISP 的闭合性；
- `dqq` 对角与交叉；
- `dqk`；
- `ispN=0` 时由标量积吸收产生的 ISP 移位；
- `ispN=1` 时 ISP 因子自身导数。

### 9.9 massless_sunrise_bundle_guard

固定定义：

```mathematica
vertexOrder = {v1,v2};
vertexSignCases = <|
  "--"->{-1,-1}, "+-"->{+1,-1}|>;
loopMomenta = {q1,q2};
loopExternalMomenta = {k};
independentExternalMomenta = {};
(* 缺省输出：sp[k,k]->ss11^2。 *)
vertexEnergies = <|v1->E1,v2->E2|>;
lineOrder = {1,2,3};
lineData = {
  <|"id"->1, "endpoints"->{v1,v2}, "momentum"->q1,
    "massType"->"massless", "bbType"->"exp", "nu"->0|>,
  <|"id"->2, "endpoints"->{v1,v2}, "momentum"->q2,
    "massType"->"massless", "bbType"->"exp", "nu"->0|>,
  <|"id"->3, "endpoints"->{v1,v2}, "momentum"->k-q1-q2,
    "massType"->"massless", "bbType"->"exp", "nu"->0|>
};
ispData = {
  <|"name"->rho1,"expr"->sp[q1,k],"range"->{0,1}|>,
  <|"name"->rho2,"expr"->sp[q2,k],"range"->{0,1}|>
};
zeroPointRules = {
  a0[v1]->alpha1, a0[v2]->alpha2,
  b0[1]->beta1, b0[2]->beta2, b0[3]->beta3
};
generatorList = {dtau[v1],dtau[v2],
  dqq[1,1],dqq[1,2],dqq[2,1],dqq[2,2],
  dqk[1,1],dqk[2,1]};
symmetryRules = {};
```

这是标准 sunrise：结构圈数为 `E-V+C=3-2+1=2`，只有一个圈外动量方向 `k`。两列 loop routing 分别为 `{1,0,-1}`、`{0,1,-1}`，都位于三平行边的 incidence cycle space，且秩为二。独立的 loop-dependent 标量积空间维数是

```text
L(L+1)/2+LK = 2(2+1)/2+2*1 = 5,
```

可取

```text
{q1^2,q1.q2,q2^2,q1.k,q2.k}.
```

三个传播子平方 `D1=q1^2`、`D2=q2^2`、`D3=(k-q1-q2)^2` 的系数秩为 3，所以最小缺失方向数为 `5-3=2`。给定的 `rho1=q1.k`、`rho2=q2.k` 补齐坐标；例如可由

```text
q1.q2 = (D3-k^2-D1-D2+2 rho1+2 rho2)/2
```

反解剩余方向。审计方必须独立确认维数、秩和反解，不得把本段文字当作 expected relation。

三条线的双端点顺序都固定为 `v1->v2`。当前逐线 top notation 是 `J[{a1,a2},{{b1,n11,n12},{b2,n21,n22},{b3,n31,n32}},{r1,r2}]`；异分支 top 则为 `J[{a1,a2},{{b1,0,0},{b2,0,0},{b3,0,0}},{r1,r2}]`。两个分支各有六个 momentum generators；连同两个 time generators 时总生成元数才是八。全部规定 ISP 点、所有分布项、sector 和 coincidence 结果都必须直接从给定传播子定义独立推导，任务书不另给目标提示。

### 9.10 vertex_energy_signs

固定使用两条平行的有序 `v1->v2` massless cycle lines，避免把单 bridge 错当作一圈 topology：

```mathematica
vertexOrder = {v1,v2};
vertexSignCases = <|
  "++"->{+1,+1}, "-+"->{-1,+1}|>;
loopMomenta = {ell};
loopExternalMomenta = {k1,k2};
independentExternalMomenta = (* 随下述 energy case 显式给出 *);
ibpMode = "full";
lineOrder = {1,2};
lineData = {
  <|"id"->1, "endpoints"->{v1,v2}, "momentum"->ell-k1,
    "massType"->"massless", "bbType"->"exp", "nu"->0|>,
  <|"id"->2, "endpoints"->{v1,v2}, "momentum"->ell-k2,
    "massType"->"massless", "bbType"->"exp", "nu"->0|>
};
ispData = {
  <|"name"->rho1, "expr"->sp[ell,k1], "range"->{0,1}|>
};
zeroPointRules = {
  a0[v1]->alpha1, a0[v2]->alpha2,
  b0[1]->beta1, b0[2]->beta2
};
generatorList = {dtau[v1],dtau[v2],dqq[1,1],dqk[1,1],dqk[1,2]};
symmetryRules = {};
```

在完全相同的 topology 上分别使用三组 `vertexEnergies`：

```mathematica
energyCaseA = <|
  "independentExternalMomenta"->{p1,p2},
  "vertexEnergies"-><|v1->Sqrt[sp[p1,p1]],v2->Sqrt[sp[p2,p2]]|>
|>;
energyCaseB = <|
  "independentExternalMomenta"->{p2},
  "vertexEnergies"-><|v1->Sqrt[sp[k1,k1]],v2->Sqrt[sp[p2,p2]]|>
|>;
energyCaseC = <|
  "independentExternalMomenta"->{p1+p2,p2},
  "vertexEnergies"-><|v1->Sqrt[sp[p1+p2,p1+p2]],v2->Sqrt[sp[p2,p2]]|>
|>;
```

case A 缺省相位变量为 `sE1,sE2`；case B 为 `ss11,sE1`；case C 为 `sE1,sE2`，其中第一个 `sE1` 代表独立的 `|p1+p2|`，绝不是 `|p1|+|p2|`。只有 case B 明确声明顶点能量与圈外 Gram 根号为同一变量。ISP 记为

```text
rho1 = sp[ell,k1].
```

它与 `D1=(ell-k1)^2`、`D2=(ell-k2)^2` 一起给出完整反解

```text
ell.k1 = rho1,
ell^2 = D1 + 2 rho1 - ss11^2,
ell.k2 = (ell^2 + ss22^2 - D2)/2.
```

因此三个 momentum generators `dqq[1,1]`、`dqk[1,1]`、`dqk[1,2]` 都必须生成。两种 sign branch 的 top notation 为

```mathematica
++ top: J[{a1,a2},{{b1,n11,n12},{b2,n21,n22}},{r1}]
-+ top: J[{a1,a2},{{b1,0,0},{b2,0,0}},{r1}]
```

专测：

- 三组 energy case 中固定的 `++` 与 `-+` 顶点相位；
- 独立 `sEi` 相位模长；
- 顶点能量复用 `ss11=Sqrt[sp[k1,k1]]`；
- 独立 `|p1+p2|` 由原始矢量和声明并映射为相应 `sEi`；
- 外腿能量不参与 momentum generator。
## 10. Seed 取值

一般函数族只取一个连续整数基点：

```mathematica
a[v] -> 0;
b[e] -> 0;
bS[e] -> 0;
ispN[j] -> 0;
```

其中 `b/bS` 规则只对实际拥有对应槽的 cycle line 应用；fixed/bridge/timeOnly line 没有该 seed 变量，但始终保留输入的 `b0[e]`、独立推导所得的显式模长幂、merged zero-point 与适用的 `bS0[e]`。若关系退化为 0，可增加一个最小非零整数点并写明原因。`mixed_sunrise`、`two_loop_isp_toy` 与 `vertex_energy_signs` 必须额外取一个 `ispN[j]->1` 点；`vertex_energy_signs` 的固定点为 `{{0},{1}}`。

离散态不能抽样：每个当前 sector 的所有 massive `n1,n2` 和 masslessFull `n` 都遍历 `0/1`。最终关系中禁止 massive `n>=2` 和 massless 非 `0/1`。

第 9.0 节已经完成唯一一次 sign 分支选择。这里的 seed 取值不得再次对子集抽样：两个固定分支的每个可达 sector 都必须完整枚举上述连续基点/ISP 补点、全部离散态和全部适用生成元。README 必须分别记录两个分支的 seed 计数，不能只给合计数。


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
- `loopMomenta`、`loopExternalMomenta`、`independentExternalMomenta`、`ibpMode`；
- `vertexEnergies`；
- `lineOrder` 与每条线的有序 `endpoints`、`momentum`、`massType`、`bbType`、`nu`；
- `ispData`、`zeroPointRules`；
- 同分支/异分支 `topIntegralTemplate`；
- `sectorNaming`、`generatorList`、`symmetryRules`。

`README.md` 用普通小节或表格复述 topology、notation、massless 方向、动量路由、sector、生成元、离散态、预期 relation 计数和特殊 tags。它必须能让审查者不运行 `family.wl` 也知道每个 `J` 槽位的含义。

`derivation.md` 是必交的来源隔离记录。它必须从第 2 节允许的原始定义开始，列出实际使用的标准 Hankel 恒等式及来源，并展示适用基底路线的 H/h 闭合关系、Wronskian、各 `n` shrink、massless endpoint 关系和 `J` 指标映射的中间步骤；不能只抄最终 expected。没有 H 路线的 family 不得为了形式完整而复制其它 family 的 H 推导。

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

动力学量总导数另存为扁平列表 `expectedDerivatives`。每条记录至少包含 `sector`、`vertexSigns`、`mode`、`variable`、`expression`、`derivative` 和 `tags`；`expression` 必须是带动力学量系数的两个 `J` 的线性组合并含纯系数项，不能只保存单积分导数。

## 13. 动力学量总导数与 reference bubble 对齐

### 13.1 独立总导数要求

对第 9 节全部函数族、第 9.0 节固定的两个 sign 分支、规定的基底路线、所有 contact-reachable sector 和 family 初始化后的每个独立外部变量 `ssij`、`sEi` 或独立相位标量 `E[v]`，独立推导

```text
d/ds Sum_r c_r(s) J_r(s)
  = Sum_r c'_r(s) J_r(s) + Sum_r c_r(s) dJ_r(s)/ds.
```

连续时间指标、线指标和 ISP 指标必须保持为 general 符号；massive/massless 函数基底的离散态仍按定义显式取 `0/1`。每个 case 至少同时放入一个全零离散态积分和一个覆盖所有适用 `n=1` 分支的积分。系数必须真正依赖当前求导变量，并加入一个不乘积分的纯系数项，以单独检查显式系数导数。

独立推导阶段不得调用 package 的 `ds`、`applyIndependentVariableDerivativeSeed`、external-vector decomposition、指标移位 helper 或现有 derivative expected。外不变量导数必须直接从有序方向导数算符

```text
D_ij = k_i . partial/partial k_j
```

对传播子幂、massive/massless building block、ISP 和顶点相位逐项求导，先解出平方 Gram 原子导数，再用 `partial_ssij=2 ssij partial_sp[kLi,kLj]` 得到根号坐标导数。这里 `ssij` 与 `Dij` 是不同对象：

```text
x_ij = k_i.k_j = x_ji,       ssij = Sqrt[x_ij],
D_ij = k_i.partial_{k_j},     D_ij != D_ji in general,
D_ij x_ab = delta_{ja} x_ib + delta_{jb} x_ai.
```

`Orderless` 只 canonical `sp[kLi,kLj]` 的两个标量积参数，不得用于交换 `Dij` 的“左乘向量”和“被求导外动量”两个角色。为使未约化 raw `J` 结果可逐项 strict-zero 比较，本 benchmark 正式固定

```text
ExternalVectorOperatorBasis = {D_ij | 1 <= i <= j <= K},
```

并按 `i` 后 `j` 的字典序排列，例如 `K=2` 时必须使用 `{D11,D12,D22}`，不得改用同样满秩但给出不同 raw representative 的 `{D11,D12,D21}`。若该 basis 在指定运动学或所选外不变量坐标上不满秩，必须报告输入/坐标不闭合，不得静默换 basis。顶点能量若为 `Sqrt[sp[kLi,kLi]]=ssii` 或一般自定义参数函数，必须显式保留普通链式法则。整个乘积法则结果最后统一做 EOM、massless/massive coincidence canonical、family symmetry 和 parity；不能只 canonical 积分导数项而遗漏 `c'_r(s)J_r`。

冻结本节 `derivation.md` 与 `expectedDerivatives` 后，继续完成第 14--17 节；只有第 2--17 节全部冻结后，第二阶段才按当前 package 解析规则加载最新版本 package，用

```mathematica
ds[expression, variable, topo]
```

逐条比较。差值必须在相同 convention 下严格为零，并检查输出只含初始化后的外部变量名、没有 forbidden `n`。内部 `kk[i,j]`、未知变量和非线性 `J_i J_j` 的拒绝门禁另列检查。

### 13.2 Reference bubble 的 convention 映射

`pure_massive_bubble_reference` 还必须做一条 reference-only 求导对照。此项独立阶段允许额外读取且只允许读取下列冻结 source set：

```text
reference/ref_code/codebubble/001 bubble_ibp_sym.m
reference/ref_code/codebubble/002 bubble_de.m
reference/ref_code/codebubble/OmegaR/OmegaR1.m
reference/ref_code/codebubble/OmegaR/MIsR1.m
reference/ref_code/codebubble/Omegatau/OmegaFolded.m
reference/ref_code/codebubble/Omegatau/MIstau.m
```

后四份文件是 `001` 在构造 `MIdlogNote` 时直接读取的 Omega/MI 源数据，不是允许沿用的 expected。执行方必须从这六份只读输入重建 `MIdlogNote` 的 21 个有序候选，并冻结前 19 个 active 与第 20/21 个 auxiliary 的显式表达式；不得读取 `codebubble/kira_bubble/` 下已有的 `result/`、`results/`、`masters`、`kira_list.m` 或其它旧 reduction 产物来补造 Phase 1 expected，也不得直接读取 package example 中已转录的 `dlog_basis.wl`。若要执行 `001` 的定义，只能在本轮隔离临时目录中禁用其 export/reduction 段，不能改写 reference source tree。

比较前必须显式记录并实施以下映射：

- reference `Vpm=0` 映射 package 的 `--`，但两边顶点能量参数的符号相反：reference time-IBP 相位项为 `-I P_ref`，package `--` 相位项为 `+I P_pkg`，故 `P_pkg=-P_ref=+I k0`，即 reference basis 中的 `P1=P2=P_ref=-P0=-I k0`。必须在此映射后逐项检查 reference `dk0Term` 的两个 top 顶点 shift、R1 的系数 2，以及 active 17 和辅助 20/21 中的显式能量系数。
- `G[{n1,n2,n3,n4},{a1,a2},{b1,b2}]` 映射 top `J[{a1,a2},{{b1,n1,n2},{b2,n3,n4}},{}]`。
- `R1`、`R2` 分别映射 line 1、line 2 shrink；reference 在求导 basis 前已执行 `R2->R1`，所以 R2 必须先由 package `symmetry` canonical 到 R1，不能作为携带另一套 sector metadata 的独立 DE basis。
- top 使用 `a0=2 nu`、`b0=-2 nu`；必须检查 shrink 后 `a0R=2 nu`、shrunk-line `bS0=0`、未缩并线 `b0=-2 nu`。
- reference 的 `ks` 是外动量模长；当前缺省坐标直接是 `ss11=Sqrt[k^2]=ks`。只在读取旧 reference 平方变量 `s11Ref=k^2` 时使用适配 `s11Ref->ss11^2` 和 `partial_ks=2 ks partial_s11Ref`，当前 package 的 `ds[...,ss11]` 不再额外乘一次链式因子。
- reference 的 vertex exchange、line exchange、R2-to-R1、R1 endpoint canonical 和 `reppowerselection` parity 必须全部作为该 case 的 `symmetryRules` 交给 package `symmetry` 模块；不得在 package actual 之外另写后处理冒充 symmetry。

reference 对照必须覆盖实际保留的 top/R1 basis 的全部端点 `n=0/1` 状态、general 连续指标、`dk0/dks` 单积分导数和带参数系数的积分组合；另用原子例子逐项检查 R2-to-R1、所有 canonical tie-break 和四类 parity 零条件。

### 13.3 h、裸 H 与 H 经 T 变到 h 的 package 验收

只在 `atomic_massive_line` 和 `pure_massive_bubble_reference` 两个 family 上执行 H 路线；两者都使用第 9.0 节固定的纯同号与混合分支，并覆盖这两个分支的全部 IBP seeds 和 general-index 动力学量总导数。验证分三路：

1. `direct-h`：从 h 定义独立手推 expected，package 使用直接 h 输入。
2. `bare-H`：从裸 H 定义独立手推 expected，package 使用同一 `P_H,Q_H,W_H` 和 `T=IdentityMatrix[2]`。
3. `H-to-h`：仍输入裸 H 的 `P_H,Q_H,W_H`，但使用从 `h=x^{-nu}H` 及导数基底独立推导的 `T_Htoh`；package 必须消费最终 `AT=T'.Inverse[T]+T.A0.Inverse[T]` 和 `WT=Det[T] W_H`。

`direct-h` 与 `bare-H` 各自和对应独立 expected 逐项比较。`H-to-h` 既要和独立变换后的 expected 比较，也要在相同 `J` 指标基底、zero-point、sector metadata、symmetry/parity 和外部变量表示下，与 `direct-h` 的 package 结果逐条相减。IBP relation、`ds` 总导数、`AT` 编译项和 `WT/shrinkTerms` 四层差值都必须严格为零；只比较矩阵而不比较全部 seeds 不算完成。裸 H `T=I` 与直接 h 属于不同基底，不能跳过 `T_Htoh` 直接声称两者的 `J` 关系相等。

## 14. pure time-IBP/tree 全量审计层

本节在同一轮全量审计中执行，并要求独立推导下列两个 pure-time/tree family。第 9--13 节的八个 loop family、两个 atomic `timeOnly` family、`ds`、h/H 与共同-theta也必须已在本轮从头完成，不得因本节处于后续功能层而省略。冻结本节 expected 后继续完成第 15--17 节；此处不加载任何旧 package，统一在全部 expected 冻结后对当前提供的最新版本 package 做 Phase 2 对照。

### 14.1 固定 family 与表示

只使用以下两个 case，不做运行时随机抽样：

1. 两顶点 `{+,+}`，两顶点由一条 massive full line 连接。该线是单一 `G++`，time-IBP 必须产生同号 theta/contact source。
2. 三顶点 chain `{+,+,-}`，边 `(1,2)` 是单一 `G++`，边 `(2,3)` 是单一 `G+-`。只有 `(1,2)` 可产生 theta/contact source；`G+-` 边不得读取 `WT`，不得产生 shrink/contact。

各顶点允许带 massless 外腿，但它们的能量必须使用与内部 massive 传播子能量相互独立的符号。massless 外腿不占 tree `n` 槽；只作为独立顶点能量进入 time seed。即使 family 用 loop topology 输入，整个 pure-time/tree benchmark 也只调用 `dtau`，禁止调用或消费 `dqq/dqk`。

Tree 的公开积分固定表示为

```mathematica
J[aList,linePacks,{}]
```

`aList` 按当前 sector active vertex 顺序保存时间幂次，`linePacks` 按 root line 顺序保存 `{"F",n1,n2}` 或收缩后的 `{"F"}`。2401.00129 Eq. (3.33) 的 vertex basis 只用于审计方的独立公式推导和 package Private adapter；package 对照的 seed、master、诊断与 DE 中不得出现一参数 `J`。master 依论文二进制顺序排列，最后一个 bit 变化最快。

### 14.2 独立推导和 package 对照顺序

每个 case 必须按以下顺序交付：

1. 从 time total derivative、h 一阶系统和 theta 导数独立推导 general-index `dtau` seed，明确列出 regular 项和 contact/lower-sector source。
2. 把 loop time seed 投影到论文 vertex basis，逐项记录指标映射和 prefactor，再映回同一公开三参数 `J`。必须使用目标项相对参考 seed 的完整物理幂次差：`a+a0` 给出 `(-1)` 相位，`b+b0` 或 `bS+bS0` 给出显式能量幂；h contact 应得到完整 `(-k)^(-2nu-1)`，只检查整数 `k^-1` 不通过。
3. 从 2401.00129 Eq. (3.37)、(3.47)、(3.50) 独立构造 `M1/M0`、`A-/A+` 和 general-index 单步递推，不读取 package 的 `repIterative0`。
4. 冻结 expected 后继续完成其余 Phase 1；待第 2--17 节全部冻结，再调用当前最新 package 的 `dtau`、tree projection 和 `repIterative`，在相同 convention 下逐项相减为零。
5. 使用 Eq. (3.54)--(3.55) 独立生成 dlog connection，检查 package 同时返回完全同序的 matrix、letters 与 master list。letters 固定按 `vertexOrder` 逐顶点拼接 `{该顶点 massiveLegs 顺序的能量 letters, binary master order 的 cut letters}`，最后稳定去重；`letterMatrices` 的 key 顺序必须与该列表一致。

多传播子/多顶点中的 SK 类型始终由一条传播子的两个端点 branch 唯一决定；不得把同一传播子拆成部分 `G++`、部分 `G+-`。三顶点 case 必须有显式负面断言：`G+-` 边的 contact term 数为零，且 trace 中没有该边的 `WT/shrinkTerms` 消费记录。

### 14.3 迭代约化与 time-IBP seed 交叉验证

两种约化路线都要保留 general 连续指标，不允许只检查若干整数 seed：

- 路线 A：把独立手推的 time-IBP seeds 作为线性方程，解出指定下降一步的 tree 积分。
- 路线 B：直接应用由 `A-/A+` 生成的 `repIterative0`，再由 `repIterative[expr,end]` 迭代到同一 `a_e` 终点。

先比较两条 general relation 严格相同；再选一个确定性的、避开 `M1` 和变换后 `M0` 奇异面的非整数有理参数点，并给 top/lower-sector master 依固定顺序赋确定性有理数，以加速完整数值代入。两路最终结果必须严格相等，不以浮点容差代替。`repIterative` 必须接受任意有限整数 endpoint 距离，不得设置最大步数；它只应拒绝终点列表长度错误、非整数指标/终点、递推奇异、单步没有按 `{剩余可 contact 的 theta 线数, Total[Abs[a-aEnd]]}` 字典序严格下降或检测到 canonical 状态循环的请求。

### 14.4 pure-time/tree 分组报告门禁

最终报告必须为本节单列 relation、projection、递推、dlog 和 guard 的逐阶段计数，不得用其它章节的通过数替代。本节记录手推来源、两个 case 的计数、首个失败差值、确定性参数点和 master 赋值，但不单独生成旧版本报告。发现差异时先归因并从受影响的独立手推开始重跑；本节未全部通过时，整轮全量审计不得标为完成。

## 15. Package 全面物理与工程闭环 benchmark

本节不是只检查新增 wrapper。本轮必须已在全新独立工作区完成第 2--13 节全部手推，并完成第 14 节两个 pure-time/tree family；不得复制任何旧 expected、报告或运行结果。继续完成第 16--17 节并冻结全部 Phase 1 产物和哈希后，Phase 2 才加载当前提供的最新版本 package 做全量对照；第 15.1--15.2 节及相关最新 package 对照全部通过后，才运行第 15.3 节外部 Kira。若当前程序或手册哈希在检验中变化，立即停止并从受影响阶段重新冻结与复验。

### 15.1 全量物理回归

1. 第 9 节十个 family 各固定使用第 9.0 节表中的一个纯同号分支和一个混合分支，不做随机抽样；覆盖两个分支的全部可达 sector、全部 active time、八个 `full` family 的全部 `L(L+K)` momentum generators、全部适用离散态和规定的非零 ISP 点。两个 atomic `timeOnly` family 不生成 momentum generator。
2. 对十个 family 的每个初始化独立变量重做 general-index `expectedDerivatives`；比较对象必须包含带动力学量系数的至少两个积分之线性组合，使显式系数导数、积分指标导数和纯系数项同时非零。reference bubble 必须先对齐变量、zero-point、parity 与 symmetry convention。
3. `atomic_massive_line` 和 `pure_massive_bubble_reference` 依第 13.3 节分别完成 direct-h、bare-H 与 H-to-h；H-to-h 还必须和 direct-h 的全部 seeds、`ds`、`AT` 与 `WT/shrinkTerms` 逐项比较。
4. 第 14 节两个 tree family 重新推导 loop time seed、完整物理幂投影、sector-tagged 迭代、general 单步/终点约化和同序 dlog connection。另加三条平行 massive h 的定向 contact：同号 case 检查 single/triple odd subset 与逐线显式能量因子乘积；混合 case 必须证明全部传播子统一为 cross，且没有 theta/`WT` source。

手推冻结后才允许调用当前最新 package。所有差值在同一 canonical/symmetry/parity 约定下严格为零；不得以浮点 probe 代替符号等式。确定性有理 probe 只作为大表达式的额外交叉检查。

### 15.2 标准 package 与交互门禁

除本节既有 API/消息检查外，必须按用户公开流程审计模板化撒点模块，不得调用私有 helper 或已废弃的 `DSSeedPlan`：

1. 对一个含 massive `h` 的小型 loop family 调用 `templateData=DSSeeds[...]`，再用 `allSeeds=DSAllSeeds[templateData]`。确认普通 batch 与一维 `allSeeds` 都覆盖全部 contact-reachable sector、全部 time/momentum generator，以及每个 sector 的全部二元 `n_i=0,1` 状态；`DSSeeds` 不提供离散抽样模式。模板不得含符号 `n_i`、`n=2` 或 forbidden `n`，且每项 `eomCanonicalQ=True`。
   若某个完整离散态经 EOM/canonical 后得到精确零，必须确认该密封状态记录仍保留在模板计数、ordinal、哈希和二元态覆盖中，并能由 `DSGenerateIBP` 接受；缺失 equation 或非零且不含 `J` 的伪模板仍必须被拒绝。
2. 先调用 `seedGroups=DSSeedGroups[templateData]` 与 `DSSeedGroupMetadata[templateData]`，再用 `DSMetaSeedRange[seedGroups,indices]` 初始化缺省逐组 shift metadata。另把同一有序 `allSeeds` 人为包装成至少两个不按物理生成元划分的 custom 顶层组，重新调用 `DSMetaSeedRange[customGroups,indices]`；确认后一次初始化覆盖前一次，flat 输入是一组、nested 输入按顶层分组且组内任意深度完全 `Flatten`，声明多余或遗漏只双语 warning 并按实际变量集合继续。
3. 对上述 custom 分组，选择经手推确认对每组均非空的共同最终关系包络，分别调用统一 `DSGenerateIBP[allSeeds,{L,U}]` 和逐指标 exact-cover `generateIBP[allSeeds,{index,Lindex,Uindex},...]`。输入范围是生成后关系允许出现的最终包络，不是直接 seed 范围；逐组逐指标必须满足 `seedRange={L-Min[Delta],U-Max[Delta]}`。两种形式的有序方程集合、source/sector metadata 和模板哈希严格相同，结果均可直接进入 `DSLinear`。运行时必须逐输入组打印 `编号 i（来源）：{指标,min,max},... / Group i (source): ...`；不得把 custom 分组称为 IBP 算符。
4. 另选一个手推确定窄于至少一组 shift 跨度的最终包络（不得预设所有 family 的 `{0,0}` 都有相同结果），确认相应反推区间出现 `min>max`。warning 必须逐编号列出来源和空区间，并解释：不存在能使全部移位后积分仍位于目标包络内的 seed 点，所以该组 IBP 撒点为空，最终关系集合缺组，不能作为完整约化系统。返回数据必须保存同一 `emptySeedRangeGroups`，并把相应 complete IBP/canonical capability 设为 `False`；不得静默丢组后仍宣称完整。
5. 分别构造 missing、unknown、duplicate、noninteger、反向区间和 `n_i` 被误列为连续指标的输入。每种都必须返回 `status->"failed"`、稳定 reason 和具体问题指标集合；Warning/Error 在 notebook 中为红字，headless 文本中每句先中文、后英文。任一种非法输入不得产生部分方程或覆盖最近一次有效模板。
6. 把 `allSeeds` 删除一项、改写一项和重排一项，确认完整性 hash/ordinal/count 门禁拒绝；仅把原多重 `Table` 外壳重新嵌套、随后由接口 `Flatten[...,Infinity]` 恢复同一顺序则应通过。
7. 对非空且 capability 完整的 `DSGenerateIBP` 结果执行 `DSLinear -> DSKiraPlan`，只能使用手册公开调用：

   ```wl
   prePlan = DSKiraPlan[linearData, <|
     "stage" -> "preReduction",
     "preferredIntegrals" -> preferred,
     "candidateIntegrals" -> candidates,
     "outputDirectory" -> preDirectory
   |>];
   formalPlan = DSKiraPlan[linearData, <|
     "stage" -> "formal",
     "preferredIntegrals" -> activeExpressions,
     "activeBasis" -> <|
       "expressions" -> activeExpressions,
       "names" -> activeNames,
       "derivativeVariables" -> deVariables,
       "scalingDegrees" -> activeDegrees
     |>,
     "numericStage" -> "symbolic",
     "coefficientRules" -> {},
     "outputDirectory" -> formalDirectory
   |>];
   ```

   `preReduction` 必须返回 `status->"planned"`、用户候选 `targetIntegrals/targetCount`、全局 `integralOrder` 与 `phaseIsolation`，不得生成 active-basis closure。`formal` 必须先解析生成 active basis 一阶导数和 derivative target closure，并返回 `analyticDerivativeCertificate`、`targetIntegralIDsPreview` 和 `minimalTargetsQ->True`；范围不足时以 `activeBasisClosureFailed` 及缺失 targets 证据失败，禁止绕过逐组逆像规则自动猜测或扩大 Cartesian box。只有成功 formal plan 才可改用 `numericStage->"postDerivative"`，且解析证书必须证明数值规则晚于导数 closure。两个 plan 的 `outputDirectory` 必须不同，各自调用 `DSKiraExport[plan]` 后核对 manifest 中的 stage、targets、input hash 和 phase isolation。
8. 构造 `notLinearData`、`invalidStage`、`invalidOutputDirectory`、`emptyCandidateIntegrals`、`missingActiveBasis`、`activeBasisClosureFailed` 和 `invalidNumericStage` 负例。每项必须返回文档规定的稳定 `reason`，失败 plan 不得被导出，也不得创建部分 Kira 文件。

记录每组模板数、离散变量数、展开方程数、积分数、两阶段 target 数、解析证书 hash、passed/total 和首个失败。该项只做轻量包络，不属于第 15.3 节的真实 Kira reduction 次数。

在一个未预加载 dSIBP 符号的新 kernel 中检查：

- 当前解析出的版本化单文件 package 可独立加载，`$dSIBPVersion===currentVersion`，不依赖主线模块路径；所有手册汇总表中的用户函数均有非空 `::usage`，`Options[函数]` 与手册缺省一致。
- `DSInit` 对输入、ISP 和 contact-reachable sector 做验证；初始化文件只写到 example 同目录的 `init/`，manifest/topology/sectors/conventions 可重新 `Get`，可选 derivatives 文件受选项控制，输入哈希不同且未允许覆盖时必须拒绝。
- `DSMessagesOn[]/Off[]` 确实控制 info/progress/warning；关闭后 fatal error 仍产生标准 `Message`、红色 notebook 错误提示所需的结构化事件和失败 Association。headless 进度只记录阶段开始、固定比例里程碑与结束，不得按元素刷屏。
- `DSSeeds -> DSLinear -> DSKiraExport` 只生成并序列化 backend-neutral 关系，不启动 Kira；manifest 的积分双向映射、系数原子映射、active basis、targets、generator-specific ranges 与输入哈希可逆且完整。
- `DSKiraImport` 对 completion marker、hash、双向映射、targets 和 RHS 非 master 残留各有独立负例；任何一个负例都必须返回失败，不得继续进入 `DSDE`。
- sector-tagged tree 数据在同 shape lower sectors 间仍按 `sectorKey` 分派；`DSTreeDLogDE` 的 master/矩阵同序，非对角 contact block 只沿 contact DAG 方向出现，zero-point/Wronskian normalization 在迭代前后不丢失。

### 15.3 真实 Kira、DE 与 scaling 闭环

只在第 15.1--15.2 节全部通过后运行两套且仅两套代表性 fresh Kira；不得为其它 family、同一 family 的默认/自定义坐标副本或不同 branch 再启动 reduction：

本节另提供 `reference-results/pure_massive_bubble/reference_probe.wl` 作为 massive bubble 的固定点最终对照。Phase 1 严禁读取；Phase 2 也必须先完成 fresh Kira、符号 `DSDE`/scaling、19 维 basis 顺序与下述 convention adapter 审计，才能执行：

```wl
referenceProbe = Get[FileNameJoin[{
  benchmarkDirectory,
  "reference-results","pure_massive_bubble","reference_probe.wl"
}]];
```

该 Association 的审计字段固定为 `"masterBasisNative"`、`"deP0"`、`"deKs"`、`"scalingDiagonal"`、`"probeRulesReference"` 和 `"probeRulesPackage"`。它只用于最后比较，不得用于选择 masters、补造 reduction、构造 Phase 1 expected 或替代任一 fresh Kira 步骤。目录内 README 给出 source/bundle 哈希、固定参数和 adapter；先验证哈希再读取。

1. `pure_massive_bubble_reference`：复用交付 closed-loop example 的 topology、branch/parity、zero-point、active basis 和 seed-range 数据，但本轮 fresh Kira 必须在独立工作目录中重建缺省 root-coordinate context：删去 example 的兼容字段 `externalInvariantRules->{sp[k,k]->s11}`，使用缺省 `sp[k,k]->ss11^2`，并把 active-basis derivative variables 和 `DSDE` 变量同步为 `{ss11,P0}`。不得复用 example 中的旧 `s11` manifest/reduction 后作字符串改名。固定 even parity 与同号分支；package 变量为 `P_pkg=P0=+I k0`，reference basis 使用 `P1=P2=P_ref=-P0=-I k0`。只有在这个等能量约束下才可启用顶点交换 symmetry；另建保持独立 `P1/P2` 的符号负例，确认该 symmetry 不会被复用，但负例不运行 Kira。交付 example 仍保留为旧平方坐标兼容示例，它本身不是本轮 root-coordinate Kira 输入。
2. 第 17.4 节 mixed bubble+tree：固定一个第 17.4 节指定分支、奇偶性和可闭合的小型 active basis，使用 exact 自定义坐标 context 重新 export/reduce/import。该路线验证 cycle/fixed pack、massive/massless 混合、bridge 显式系数和六变量 DE；不能复用 bubble reduction。

闭环按以下顺序验收：

1. `DSKiraExport` 本身不启动 reduction；外部 Kira 完成后，completion log、master list 与完整 reduction 均来自本次独立运行。每套分别记录 equations、independent relations、masters、targets、unreduced、Kira 版本、完整命令和 wall time。
2. bubble 的 19 个有序 active IDs 必须全部成为 masters，两个辅助关系 ID 不得成为 master。bubble+tree 使用第一阶段冻结并在 manifest 中点名的同序 master/target 列表。两套的全部 targets 都必须有 reduction，`unreduced==0`。
3. **所有微分变量从 seed 到最终 DE 始终保持符号。** bubble 固定为 `{ss11,P0}`；bubble+tree exact custom context 固定为 `{loopScale,legScale1,legScale2,E1,E2,E3}`。这些变量、对应内部平方原子及任何含这些变量的表达式都不得出现在数值规则左端或被数值规则间接消去；`kk[1,1]->ss11^2` 及 custom Jacobian 是符号坐标映射，不是数值化。只允许数值化不属于 DE variables 的系数参数，例如一致选取的 `dim` 或 `epsilon`、`nu`、zero-point 参数及已编译 normalization。所选精确值必须非奇异且足以让 Kira 系数域闭合；同一取值表原样写入初始化 metadata、export manifest、后处理 summary 和报告，两端不得各自重选。
4. 每套 export 前必须以结构检查证明 `Intersection[numericRuleLHS,deVariables]=={}`，每条 numeric-rule RHS 也不含任何 DE variable。import 后再次证明 DE variables 全部仍在 manifest/坐标映射中；在 DE 构造完成前禁止任何运动学 probe。违反任一项即作废本次 Kira 结果并重新 export，不允许把已经数值化的 reduction 用插值或改名补救。
5. `DSKiraImport -> DSDE` 后 master 顺序不变，matrix/source 中没有 residual `J`，约化系数不残留内部 `kk/qq/qk/xi/z`、ISP 内部名或已被固定的非 DE 参数；每个声明的 DE variable 都有对应矩阵，显式系数导数保留。bubble 调用 `DSDE[...,{ss11,P0}]`；bubble+tree 使用 exact custom context 的 `DSDE[...,Automatic]` 并检查变量顺序严格为上述六项。
6. scaling relation 必须按以下符号恒等式检查，而不是只做一个数值点。若

   ```text
   partial_{x_a} I = A_a(x) I + s_a(x),
   E = Sum_a w_a x_a partial_{x_a},
   E I_i = delta_i I_i,
   ```

   且 master basis 同序、逐项齐次，则必须有

   ```text
   B(x) = Sum_a w_a x_a A_a(x) = DiagonalMatrix[{delta_i}],
   Sum_a w_a x_a s_a(x) = 0.
   ```

   对 normalized master `I'=T(x) I`，先使用

   ```text
   A'_a = (partial_{x_a} T) Inverse[T] + T A_a Inverse[T],
   B'   = E[T] Inverse[T] + T B Inverse[T].
   ```

   因而动力学量依赖的 normalization 必须包含 `E[T] Inverse[T]`；不能只共轭或直接相减两套矩阵。若 `T` 混合不同 degree，右端一般也不能先验写成原来的同一对角矩阵；应从变换后的 master 定义独立求 degree，或直接与上式右端比较。bubble 使用 `{ss11,P0}`、权重 `{1,1}`；bubble+tree 六个最终变量都取权重 1，并从每个 normalized master 的完整物理幂独立冻结 `delta_i`。对 `M_i=N_i J_i`，`delta_i` 必须包含 `E[N_i]/N_i`，以及 root loop measure、全部 active `a+a0`、cycle `b+b0`、fixed/bridge 显式 `b0` 或 shrink `bS+bS0` 的贡献。
7. bubble 的独立 reference 路线按同目录 `001 bubble_ibp_sym.m`/`002 bubble_de.m` 的 `dk0/dks -> id -> symmetry -> Kira reduction -> DEP0O/DEksO` 顺序生成。reference 中 `ks*DEksO+P0*DEP0O` 正是权重 `{1,1}` 的 Euler matrix；必须检查其非对角元为零、对角元等于同序 master degrees，且不依赖整体尺度。再按 `P_ref=-P0`、`ss11=ks`、同序 master 和逐项 normalization 变到 package basis，与 package DE 比较。旧平方变量 `s11Ref` 只在 adapter 中替换为 `ss11^2`；旧 `002` 的统一除以 `ks` 只作诊断；跨 degree block 使用上一项的完整换基公式。bubble 不是完整 dlog DE，不检查 primitive、letters、pole 或 dlog form。
8. bubble+tree 的 full-loop Kira DE 与其第一阶段独立冻结的 custom-coordinate DE、参数闭合和 scaling 逐项比较。pure-time/tree 的 `DSTreeNaiveDE` 与 `DSTreeDLogDE` 仍只按第 15.5 节在同序、同 normalization tree masters 上比较；full-loop 与 tree 系统只有在另行给出并验证 loop-to-tree projection/basis map 后才能比较，未给该映射时禁止直接相减。
9. 所有符号 DE 与 scaling 门禁通过后，才可选确定性精确有理运动学 probe。bubble 固定 `ks=ss11=43/17`、`P0=29/13`；bubble+tree 由执行方在第一阶段冻结一组有理点。每套代入前收集全部矩阵元分母并证明非零，代入后用精确算术比较，禁止浮点容差。bubble 的种子 `2026072202` 和 bubble+tree 的独立种子均写入报告。
10. bubble 的最终固定点比较读取上述 `referenceProbe`。先确认 package 19 个 masters 与 `referenceProbe["masterBasisNative"]` 经已证明的 convention/normalization map 同序，再分别比较 package 的 `P0`、`ss11` 矩阵与 `referenceProbe["deP0"]`、`referenceProbe["deKs"]`；预期精确相等计数分别为 `361/361` 与 `361/361`，非零差值均为 0。最后比较 Euler 组合与 `referenceProbe["scalingDiagonal"]`。报告必须记录 bundle SHA-256、逐矩阵相等/非零计数和首个差值；不得只引用 bundle 内的 `"checks"` 自证 package 正确。

### 15.4 全面闭环分组报告与修正门禁

最终报告必须分别给出第 15.1 节各 family/分支/sector/generator 的 passed/total、第 14 节 tree 检查计数、第 15.2 节工程负例计数，以及两套第 15.3 节 Kira 各自的 equations、independent relations、masters、targets、unreduced、DE/scaling 计数。还要记录每套 DE variables、numericRuleLHS 交集检查、input hash、`currentVersion`、当前程序/PDF 哈希、手推冻结哈希、首个失败差值、Kira 版本、执行命令与耗时。

本节结果并入 `000-report/YYYY-MM-DD-HHmm-{currentVersion}-内部.md`，附件放同名 `-附件/`，不另建旧版本报告。发现 package 缺陷时，维护者修正当前最新 package 并重新冻结交付；独立检验者不得改 expected 追随 package，而应从受影响的独立推导阶段重跑。第 2--17 节未全部通过不得把本轮全量审计标为完成。

### 15.5 Tree naive IBP/DE 与直接 dlog 的双路线门禁

在第 14 节的两顶点同号 massive family 上新增一条不使用 `A-/A+` 递推矩阵的路线。先对每个 contact-reachable sector 的全部 `a=0` binary masters，逐活动顶点构造对应 `a_v=1` loop 代表元；调用 loop `dtau` 后按完整物理幂投影成 sector-tagged tree 方程。把这些方程作为一个有限线性系统，固定 master 不参与求解，只解出全部一步升幂 tree 对象。该路线不得调用 `repIterative`、`treeAplus/treeAminus` 或 `DSTreeDLogDE[...]["omega"]` 生成 reduction rules。

Tree 外部变量分为两部分并分别手推：

1. 顶点相位能量导数沿用 loop 代表元的相位项，再做相对 tree 投影；不得把 loop 的完整 momentum derivative 当作 tree derivative。
2. 每个 massive h 外腿的 `treeEnergy=k` 使用 Eq. (21)：`n=0` 给 `-J[a_v+1,n->1]`，`n=1` 给 `J[a_v+1,n->0]-(2 nu+1)J[a_v,n=1]/k`，并对 `k(variable)` 乘链式法则。若同一线连接两个顶点，两个 endpoint leg 都必须贡献。

先独立冻结上述 raw derivative、naive 线性系统和 Eq. (3.53)--(3.55) 的逐变量 expected。第二阶段再加载 package，并固定使用 `DSTreeDLogDE[context]["masters"]` 给出的同序 `{sectorKey,integral,coefficient}` 列表；`coefficient=N_s` 是 master 定义的一部分，故 `D[N_s,variable] J_s` 必须显式进入 naive 路线。验收顺序为：

1. `DSTreeNaiveIBP` 的 equation/unknown 数相等，全部 solve residual 严格为零。
2. `DSTreeNaiveDE` 的 master 顺序和 normalization 与直接 dlog 完全相同，source、residual tree `J` 和内部 sector token 均为空。
3. 每个顶点能量及每个不同 massive-leg energy 的 naive 矩阵先与独立 expected 比较，再与 `D[DSTreeDLogDE[context]["omega"],variable]` 比较；两边全部元素严格为零。
4. 另固定两顶点 `{+,-}` family 使用同一测试；它只能有 top sector，所有 `contactAudit`、`shrinkConsumptionTrace` 和 `WT` 消费均为空，但 naive 与公式矩阵仍须一致。

报告必须列出 master 数、各变量矩阵维数、equation/unknown 数、非零差值数、首个失败、normalization 导数非零项和 mixed-contact guard。内部互查只允许两条路线共享 topology convention 与显式指定的 master 列表；不得共享 reduction rules 或用一条路线的矩阵构造另一条路线的 expected。

## 16. 根号动力学坐标全量审计层

本节增加根号坐标 adapter 的独立 expected，但不豁免第 2--15 节：这些前序物理关系必须已在本轮全新工作区从头推导并冻结。第一阶段不得读取 package、主线或现有 expected；从以下定义独立推导并冻结本节 `derivation.md` 与 `expected.wl`：

```text
xij = sp[k_i,k_j],       ssij = Sqrt[xij]
partial_ssij = 2 ssij partial_xij
```

`loopExternalMomenta` 是进入 loop-dependent line momentum 的独立外向量，其完整 Gram 基一律保留。`independentExternalMomenta` 声明实际出现在无圈动量线、`extLegs` 或被审计相位中的无圈模长方向，不自动输出它们之间的 Gram 表；从 `lineData`、`vertexEnergies` 和 `extLegs` 中抽取实际出现模长平方，在完整 loop Gram 基上按首次出现顺序做增量秩筛选，只为独立行命名 `sE1,sE2,...`，其余保存 dependent binding。若 `kE1`、`kE1+kE2`、`kE2` 分别出现，则三者可作为三个独立模长变量，禁止自动引入 `Sqrt[sp[kE1,kE2]]`；另固定 `{kE,2 kE,k+kE,k-kE}` 检查从属 binding。

固定做五组小 family：一个 `loopExternalMomenta={k1}` 的单外动量 family、一个 `loopExternalMomenta={k1,k2}` 的两外动量 family、一个 `independentExternalMomenta={kE1,kE1+kE2,kE2}` 且三种模长实际出现于顶点相位的 family、一条动量为 `kE0` 且仍参与两个顶点 `tau` 积分的 massive h fixed line，以及 `{kE,2 kE,k+kE,k-kE}` dependent-binding family。必须验证：

1. 缺省公开变量分别严格为 `{ss11}`、`{ss11,ss12,ss22}` 与按出现顺序绑定的 `{sE1,sE2,sE3}`；内部 loop Gram 原子仍为 `kk[i,j]=sp[ki,kj]`，外腿规则中不存在 `sp[kE1,kE2]`。
2. 对角与非对角 `ssij` 导数都等于独立平方原子导数乘 `2 ssij`，并保持同一 upper-triangular `Dij` decomposition；不得从 package 的 root-coordinate actual 反推 expected。
3. 只出现在相位/显式系数中的 `sEe` 只贡献相位和系数导数，不产生 loop IBP generator，也不增加 ISP closure 维数。若 `sEe` 绑定一条无圈 massive h 线，则另外从 `r^{-B}h_0(r tau_1)h_0(r tau_2)` 手推并冻结 `-B shift_b(+1)`、两个 endpoint 的 `shift_a(+1),n:0->1`，再叠加相位项；不得调用 package helper 生成该 expected。
4. 对 `c(ssij,sEe) J1 + d(ssij,sEe) J2 + f(ssij,sEe)` 使用完整乘积法则；指标保持 general，最终统一执行 EOM/symmetry/canonical。
5. `numericRules->{ssij->r}` 在内部等价于 `kk[i,j]->r^2`。不得使用 `PowerExpand`，也不得默认改变根号分支。
6. 显式旧输入 `externalInvariantRules->{sp[ki,kj]->sij}` 继续以单位 Jacobian 工作，确认当前缺省根号坐标没有改变旧输入兼容语义。
7. 第一阶段独立构造动力学规则左端到基础平方原子的矩阵，以及基础原子对用户参数的 Jacobian。完整重命名必须两者满秩；删除一条规则和让两个基础模长共用同一参数时，分别冻结左端零空间和参数 Jacobian 左零空间。再加入一个依赖规则 `sp[2 k,2 k]->xFourK^2`，冻结其冗余关系与约束 `xFourK^2=4 xLoop^2`。第二阶段要求 package 对欠完备输入给红色 Error 并拒绝；对过完备输入给红色 Warning 后只允许诊断性的 symbolic IBP，标记 `inverseAvailableQ=False`、`derivativeUsableQ=False` 和 backend export 不可用，禁用有歧义的 `ds/DSDE/rep2innerform/DSKiraExport`。
8. 固定一个一般混合坐标 `x11=u^2,x12=u v,x22=v^2+w^2`，独立冻结 `partial_u=2u partial_x11+v partial_x12`。package 必须对三个基础平方原子完整求和，不得因 `u` 恰好也是第一个根号坐标名而提前返回；loop 原子已包含的相位导数不得在显式 phase 分支重复计算。该 Jacobian 满秩但不是简单单值逆映射，`ds` 必须可用而 `rep2innerform` 必须明确失败。
9. 两阶段交互合同必须检查 `selectionTemplate` 已完全求值且等于缺省规则。过完备 context 中 symbolic momentum IBP 必须仍可生成，但冗余变量 `ds`、`DSDE`、`rep2innerform` 和 `DSKiraExport` 都返回 `$Failed`，且不得产生可被外部 backend 误当成独立参数场的文件。
10. dependent-binding family 必须独立冻结：实际出现 4 个模长而独立无圈模长只有 2 个，`|2 kE|^2=4 sE1^2`、`|k-kE|^2=2 ss11^2+2 sE1^2-sE2^2`；对 `sE1` 求导时，第二条无圈 massive line 乘 `D[Sqrt[4 sE1^2],sE1]`，负组合相位乘 `2 sE1/Sqrt[2 ss11^2+2 sE1^2-sE2^2]`。不得用 `PowerExpand` 或 package helper 生成这两个 Jacobian。

冻结本节后继续完成第 17 节；只有第 2--17 节全部冻结后才按当前 package 解析规则加载最新版本 package。新 kernel 中要求 `$dSIBPVersion===currentVersion`，逐项比较上述坐标、Jacobian、相位导数、系数乘积法则、数值映射和 generator/ISP 隔离门禁。最终报告为本节单列 passed/total、非零差值数、首个失败和当前程序/PDF 哈希；不得引用任何旧 package 哈希或旧报告替代本轮执行证据。

## 17. 显式动量角色、图论与 fixed-line 全量审计层

本节增加显式动量与 fixed-line expected，但第 2--16 节必须已在同一轮 source-isolated 工作区从头完成；禁止把它们视为可沿用的“既有 expected”。第一阶段只读取本任务书、公开文献和第 13.2 节逐路径许可的 reference source set，从 topology 输入独立构造全部第 2--17 节 expected；不得读取 package、主线代码、`000_code/check/`、旧 actual、旧报告或任何已有 package 结果。用户必须分别给出有序列表 `loopExternalMomenta` 与 `independentExternalMomenta`；符号可任意命名，程序只验证声明，不得从名字、首次出现位置或统一动量表猜角色。

### 17.1 结构圈数、routing 与声明完备性

固定一个单圈 bubble 加一条 bridge、第三顶点再接两条外腿的多重图，并增加自环和三条平行边两个最小图论 probe。独立冻结：

1. 内部边多重图的结构圈数 $L=E-V+C$；平行边逐条计数、自环各贡献一圈、`extLegs` 不计入 $E$。逐边删边后连通分量增加者为 bridge，其余为 cycle line。
2. 对 $Q=Aq+r$ 选择满秩参考行 $A_R$，以 $q'=A_Rq+r_R$ 消去 routing shift，冻结 $r'=r-AA_R^{-1}r_R$。例 `{q+k1,q+k1+k2}` 的 shift-invariant 需求只有 `k2`；加减号必须以精确有理系数保留。
3. `ibpMode->"full"` 时，`Length[loopMomenta]` 必须等于结构圈数，routing 的圈系数矩阵满秩且属于 incidence cycle space；圈数不足、bridge 错带独立圈流和非法 cycle support 分别作负例。
4. 将实际 routing/ISP 所需 loop-external 向量空间与用户 `loopExternalMomenta` 比较。恰完备通过；多给方向为过完备 warning；少给方向为欠完备 error，并冻结 `missingDirections` 及零空间表达式。
5. 将 topology 实际出现的无圈 line/phase 模长平方，在完整 loop Gram 基上与 `independentExternalMomenta` 声明逐项比较。`p1,p2,p1+p2` 可是三个独立模长变量，不主动生成 `sp[p1,p2]`；整体反号 canonical，但 `p1+p2` 与 `p1-p2` 不合并。恰完备、过完备和欠完备各冻结一例。

欠完备的两个列表或动力学规则都必须给红色 Error，令 `DSInit` 失败、`initializationUsableQ=False`，后续 `DSSeeds/dtau/dqq/dqk/ds/DSDE/DSLinear/DSKiraExport` 均不得绕过 capability gate。过完备给红色 Warning，允许初始化并生成仅用于诊断的 symbolic seeds/linearData，但 `derivativeUsableQ=False`、backend export capability 为 False，`ds/DSDE/rep2innerform/DSKiraExport` 必须拒绝；不得把冗余方向的导数暗设为零，也不得把受约束参数作为代数独立 Kira 字段导出。特别检查共同 affine shift 的额外声明不会增加实际 `nK`：原列表保留作 declared metadata，而核心 Gram/`dqk`/ISP 使用 `effectiveLoopExternalMomenta` 必要基。

### 17.2 cycle、fixed 与 pure-time 指标表示

对同一 bubble+bridge family 手推统一表示 `J[aList,linePacks,ispList]`。cycle full pack 为 `{b,n1,n2}`；bridge/non-cycle full pack 为 `{"F",n1,n2}`；masslessCross 使用 `{b,0,0}` 或 `{"F",0,0}`；收缩后仍在原 root line 位置保留 `{bS}` 或 `{"F"}`。fixed line 的物理幂 $B_e$ 不成为 `b/bS` 指标，而以对齐的 line/key/parameter/power 列表存入每个 sector 的 `sectorPrefactorData`。

独立冻结并逐项比较：

1. `dqq/dqk` 的复合算子只遍历 cycle-line $\xi_e$ 与 ISP；bridge 不产生 $z_e$、`b` shift 或 momentum building-block 项。
2. `dtau` 遍历该顶点连接的全部 active lines；bridge massive h 的 endpoint derivative 同时产生正确的 `a/n` shift，并通过统一 prefactor materializer 产生模长系数。
3. contact sector 继承 root topology 的 loop space、cycle/bridge 和 line-power schema；全 cycle lines 同时 shrink 后也不得把结构圈数重算为零或把原 cycle pack 改成 fixed pack。
4. `ibpMode->"timeOnly"` 时所有 active lines 都是 `fixedCoefficient`，仍使用 `J[aList,linePacks,{}]`；即使底层图含圈也不生成 `b/bS`、momentum generator 或 ISP 门禁，但所有 active line 模长进入独立无圈模长审计和 sector prefactor。
5. 用同一公开三参数、有序 master 列表比较 naive seed/DE 与 massive-only 公式 `repIterative`/`DSTreeDLogDE`；两路线不得共享 reduction rules。两顶点和三顶点 massive 例均需包含 seed 与迭代关系的确定性数值交叉验证。另用含 massless full line 的最小 family 验证五个公式接口都返回 `PendingRederivation`，且无旧一参数 `J` 泄漏。

### 17.3 参数 notation、重定义与公开接口覆盖

独立冻结缺省 notation：`loopExternalMomenta` 的完整 Gram 根号依序命名 `ssij`，`independentExternalMomenta` 只命名各自模长 `sEi`；类别总数超过 9 时按总数位宽补零。边界表固定为 `N=9` 得 `ss19/sE9`，`N=10` 得 `ss0101,ss0110,sE01`，`N=100` 得 `ss001100,sE001`。

自定义变量完备性必须在“初始化所需基础平方原子 -> 用户参数”的 Jacobian 上判定，不能只数替换规则条数：

- **exact**：基础原子方向全部覆盖，Jacobian 行秩等于基础原子数，且用户参数数等于该秩。package 必须按用户给定顺序为每个参数生成独立 `derivatives["operators"]`，并允许 `ds` 及适用的 loop/tree DE。
- **overcomplete**：覆盖全部基础方向但用户参数多于秩，存在非零参数零空间和代数约束。必须用红色 Warning 报告 rank、redundant parameters、null-space/constraint 和建议独立子集；允许生成只作诊断的内存 `DSSeeds/DSLinear`，但标记 `derivativeUsableQ=False`、`backendExportUsableQ=False`，拒绝 `ds/DSDE/rep2innerform/DSKiraExport`。在约束面上没有天然的“保持其它冗余变量不变”的独立偏导，禁止任取一种延拓或把冗余方向导数设为零。
- **undercomplete**：基础方向未覆盖。必须用红色 Error 报告 rank、`missingDirections`、左零空间和需要补充的原始 `sp[...]` 方向，拒绝注册可用 context，并使 `DSSeeds/DSLinear/DSKiraExport/ds/DSDE/rep2innerform` 全部读取失败 capability。若用户本意是施加物理约束，必须把约束写进 topology/kinematics 后重新初始化，使约束后的基础空间重新成为 exact；不得把漏填变量静默解释为物理约束。

过完备或欠完备的重定义都不得覆盖此前可用的 exact context。返回值必须保留原 context 标识、候选规则审计和修正建议；过完备可建议一个独立子集但不得自动替用户删除参数，欠完备可给出需补规则模板但不得自动补猜物理方向。

Notebook/前端中的 Warning 与 Error 文本均须为红字；headless 模式至少保留可机器检查的 `severity -> "Warning"|"Error"` 和 `[WARNING]`/`[ERROR]` 前缀。颜色只用于展示，capability、rank、null-space 和返回状态才是程序门禁。

固定一个双 `kL`、双 `kE` 的非平凡 exact 例。它以第 9.5 节 `mixed_triangle` 的三条 loop-dependent lines、两个 sign 分支和全部 seeds 为基础，把现代字段固定为

```wl
"loopExternalMomenta" -> {kL1,kL2}
"independentExternalMomenta" -> {p1,p2}
"extLegs" -> {{v1,p1},{v2,p2}}
"vertexEnergies" -> <|
  v1 -> E1 + Sqrt[sp[p1,p1]],
  v2 -> E2 + Sqrt[sp[p2,p2]],
  v3 -> E3
|>
```

三条 line momentum 由第 9.5 节的 `{q,q-k1,q+k2}` 原样换名为 `{q,q-kL1,q+kL2}`。缺省可求导变量顺序固定为 `{ss11,ss12,ss22,sE1,sE2,E1,E2,E3}`，其中 `ss12=Sqrt[sp[kL1,kL2]]`。随后用原始 `sp[...]` 左端定义 exact 自定义变量：

```wl
sp[kL2,kL2]                 -> k11^2
sp[kL1,kL1]                 -> k22^2
sp[kL1+kL2,kL1+kL2]         -> k12^2
sp[p1,p1]                   -> e1^2
sp[p2,p2]                   -> e2^2
```

这里 `k11=|kL2|`、`k22=|kL1|`、`k12=|kL1+kL2|`；`k12` 不是缺省的 `ss12`，因为前者是矢量和的模长，后者是交叉标量积的平方根。执行方必须独立得到平方原子反解 `sp[kL1,kL1]=k22^2`、`sp[kL2,kL2]=k11^2`、`sp[kL1,kL2]=(k12^2-k11^2-k22^2)/2`，确认 generic Jacobian 满秩，并避开 `k11 k22 k12=0` 的奇异面。随后冻结正反向关系和全部 `{k11,k22,k12,e1,e2,E1,E2,E3}` 微分算符，不得把它当成交换变量名。每个算符都作用于含 general 指标、变量相关系数和纯系数项的积分组合。

该例的 overcomplete 变体在 exact 规则上增加 `sp[kL1-kL2,kL1-kL2]->kDiff^2`，必须得到一维冗余约束并触发上述 Warning/关闭导数与 backend；Gram-undercomplete 变体删除和模长规则，使交叉 Gram 方向缺失；`kE`-undercomplete 变体删除 `sp[p2,p2]->e2^2`。后二者都必须触发 Error，并分别报告缺失的 loop Gram 与独立外腿模长方向。

在 bubble+bridge 例中先检查 `DSParameterNotation[context]`，再用 `DSRedefineParameters[context,rules]` 把完整坐标改成一个满秩混合参数化。独立用 Jacobian 链式法则手推 `ds[c(u)J_1+d(u)J_2,u]`，必须同时包含显式系数导数、cycle 原子导数、fixed-line 径向导数与顶点相位；重定义后的 seed/DE metadata 使用新规则和新 `inputHash`。另给欠完备与过完备规则负例。

自定义变量不能只检查 metadata 改名。对 exact 重定义还必须逐层完成：

1. 冻结 `oldCoordinateVariables=Complement[defaultVariables,customVariables]` 和自定义 Jacobian。`derivatives["operators"]` 的 `userVariable` 顺序必须与全部可求导 `customVariables` 完全相同；对每个自定义变量分别手推一个带 general 指标、变量相关系数和纯系数项的表达式，并与 `ds` 严格比较。不得只抽查第一个变量。
2. 以同一 custom context 生成全部规定 `DSSeeds` 和 `DSLinear`。逐条检查 canonical seed equation、`linearData` coefficient、`coefficientVariables` 和实际 `inputHash`：计算 payload 中不得出现 `oldCoordinateVariables`，也不得出现 `kk/qq/qk/xi/z/externalLegSquaredCoordinate` 或任意 `dSIBP`Private`` helper/head/symbol。旧变量只允许出现在明确标成 provenance/audit 的 `defaultRules`、`previousRules` 或 selection template 中，不能进入可供 backend 消费的关系。
3. Loop DE 必须使用 custom context 重新执行 `DSKiraExport ->` package 外部 reduction `-> DSKiraImport -> DSDE[Automatic]`；不得复用其它 context 的 manifest/reduction 后再作字符串改名。`DSDE["variables"]`、`matrices`/`sources` 的 key 与全部元素只能含 custom variables 和冻结的允许参数集合，严格不含旧坐标、内部原子、residual `J` 或私有符号。为控制规模，唯一执行这项 fresh custom reduction 的 family 是第 17.4 节 mixed bubble+tree；pure massive bubble 只运行第 15.3 节的 reference 默认根号坐标系统，不再为它重复跑 custom 副本。
4. Tree 路线不需要 Kira；在一个 exact 自定义 timeOnly family 上分别生成 `DSTreeNaiveDE` 与 `DSTreeDLogDE`，用同序 masters 比较全部自定义变量矩阵。两路 `variables`、letters/矩阵系数与 source 均不得残留旧坐标或内部符号。
5. 最终报告为 seed、`linearData`、loop DE、tree naive DE、tree dlog DE 和逐变量 `ds` 分别给出 `oldVariableResiduals`、`internalResiduals`、`missingCustomVariables` 与首个差值；任何一个集合非空都不能称为自定义变量转换成功。

除上述双 `kL`/双 `kE` 例外，再固定以下两个 custom-coordinate 矩阵，因此总计三个例都必须分别执行 exact/overcomplete/undercomplete：

1. 第 17.4 节 bubble+tree。exact 使用该节的满秩混合参数化；overcomplete 在已定义 `sp[k1,k1]` 后再增加 `sp[2 k1,2 k1]->e1Double^2`；undercomplete 删除 `sp[k2,k2]` 方向。必须覆盖 bridge 显式系数、六变量算符与 full-loop Kira/DE；不得在没有 loop-to-tree 映射时把它与第 15.5 节 tree DE 直接比较。
2. 第 9.10 节 `vertex_energy_signs` 的现代字段变体。它保持 `loopExternalMomenta={k1,k2}`，不得引入未声明的 `k`。三个 energy case 共用完整 loop Gram exact 规则

   ```wl
   sp[k1,k1] -> r11^2
   sp[k1,k2] -> r12^2
   sp[k2,k2] -> r22^2
   ```

   并分别追加 case A 的 `{sp[p1,p1]->e1^2,sp[p2,p2]->e2^2}`、case B 的 `{sp[p2,p2]->e1^2}`、case C 的 `{sp[p1+p2,p1+p2]->e1^2,sp[p2,p2]->e2^2}`。case B 的 `v1` 能量随 `r11`，不是额外 `e` 变量。overcomplete 在对应 exact 规则上增加 `sp[k1+k2,k1+k2]->rSum^2`，应给出一维 Gram 冗余关系；undercomplete 删除 `sp[k1,k2]->r12^2`，必须报告缺失的交叉 Gram 方向并拒绝初始化。三个 case 都必须覆盖非零 ISP、相位系数乘积法则、全部 seeds 和每个最终变量的算符。

三个例的每个 over/undercomplete case 都必须原样记录红字消息文本、severity、rank、null-space/missing directions、capability 和每个下游调用的返回状态。exact case 则必须比较 `derivatives["operators"]` 的变量顺序与用户参数顺序完全相同，并证明每个用户变量都有且只有一个算符。

参数闭合检查不得只限于上述三个例。对任务书第 9、14、16、17 节的全部 benchmark families，以及 `package/examples/coverage_manifest.wl` 列出的每个成品 example，均须检查：

- 缺省 context 的 `DSSeeds/DSLinear` 计算 payload 只含缺省最终变量与冻结允许常量；
- exact custom context 的全部 seed、`linearData`、逐变量 `ds` 结果及适用的 `DSDE`、`DSTreeNaiveDE`、`DSTreeDLogDE` 只含最终自定义变量与冻结允许常量；
- 每个 `_J` 先替换为独立惰性 token，再分别检查积分系数和纯系数项；禁止因直接调用 `Variables` 而把 general 指标误报成动力学参数；
- `oldCoordinateVariables`、`kk/qq/qk/xi/z/externalLegSquaredCoordinate`、未消去 ISP 内部名、residual `J` 和任意私有 head/symbol 在计算 payload 中均为空。旧坐标只能留在明确的 provenance/audit 字段。

对没有 reduction 路线的 family，要求完整验证初始化生成的微分算符及其 `ds` 作用结果，不伪造 `DSDE` 矩阵；对任务书已经规定 loop Kira 或 tree naive/dlog 闭环的 family，必须继续检查最终 DE matrices/sources。报告分别列出 `declaredFinalParameters`、`seenFinalParameters`、`missingFinalParameters`、`unexpectedParameters`、`oldVariableResiduals` 和 `internalResiduals`。

最后比较 `DSPublicAPI[]` 与 `package/examples/coverage_manifest.wl`：每个公开函数至少有一个成品 example，手册汇总表不得漏项。第一阶段第 2--17 节 expected 全部冻结后才按当前 package 解析规则加载最新版本 package，要求 `$dSIBPVersion===currentVersion`，报告每组 passed/total、非零差值数、首个失败、程序/PDF 哈希，以及 Phase 2 前后冻结 expected 哈希是否保持不变。

### 17.4 固定 bubble+tree 参数闭合专项

新增一个固定 mixed family，不得用其它 bubble/bridge 输入替代：`v1,v2` 间两条 cycle lines 的动量为 `l1`、`l1+k1+k2`，其中 line 1 是唯一 massive h line（Hankel 指标 `nu1`），line 2 是 massless exponential line；`v2,v3` 间动量为 `k1+k2` 的 line 3 是 massless exponential bridge。`extLegs` 为 `{v1,k1+k2}`、`{v3,k1}`、`{v3,k2}`。基准相位必须独立输入 `vertexEnergies=<|v1->E1,v2->E2,v3->E3|>`；`E1,E2,E3` 与传播子动量及 `nu1` 互不推断。固定分支为

```wl
vertexSignCases = <|
  "+++" -> {+1,+1,+1},
  "++-" -> {+1,+1,-1}
|>;
```

两个分支都执行本节完整矩阵。`+++` 的 pack types 依次为 `{massiveFull,masslessFull,masslessFull}`；top notation 为 `J[{a1,a2,a3},{{b1,n11,n12},{b2,n21,n22},{"F",n31,n32}},{}]`。`++-` 依次为 `{massiveFull,masslessFull,masslessCross}`；top notation 为 `J[{a1,a2,a3},{{b1,n11,n12},{b2,n21,n22},{"F",0,0}},{}]`。line 1/2 是 cycle，line 3 是 fixed bridge；只有 line 1 有 `nu1` 与 massive EOM。`+++` 三条 full line 都按各自 kernel 产生允许的 theta/contact，`++-` 的 bridge 不得产生 contact/shrink sector。三条 line 均保留输入 `b0[e]`；bridge 的物理幂进入各 sector 的结构化 prefactor，不进入 `J` 的 `b` 槽。

第一阶段由执行方从上述 topology 自己选择并手推两个有序动量列表，冻结后才与以下合同比较：

```wl
"loopMomenta" -> {l1}
"loopExternalMomenta" -> {k1+k2}
"independentExternalMomenta" -> {k1,k2}
```

缺省基础规则必须恰为 `sp[k1+k2,k1+k2]->ss11^2`、`sp[k1,k1]->sE1^2`、`sp[k2,k2]->sE2^2`，全部微分变量恰为 `{ss11,sE1,sE2,E1,E2,E3}`。`ss11` 表示先作矢量和再取模，绝不等于 `sE1+sE2`。执行方先手推并冻结 general `a_i,b_i,n_i` 下的全部 time/momentum seeds、全部六个变量的微分算符、显式系数乘积法则、EOM/symmetry/canonical 与所有 `a0[v]、b0[e]` zero-point 产物；手推阶段不得调用 package helper。

冻结后加载 package，至少完成以下输入矩阵：

1. 分别改变 `loopExternalMomenta` 与 `independentExternalMomenta`，各做 exact、overcomplete、undercomplete。过完备必须给红色 Warning、列出额外/冗余方向和二次型依赖，只允许诊断性 symbolic IBP/linearData，并关闭 `ds/DSDE/rep2innerform/DSKiraExport` 及 backend export capability；欠完备必须给红色 Error、返回 missing/null-space 证据，并使所有下游入口读取失败状态。
2. 自定义坐标做 exact、overcomplete、undercomplete。fresh Kira 使用的 exact 规则固定为 `sp[k1+k2,k1+k2]->loopScale^2`、`sp[k1,k1]->legScale1^2`、`sp[k2,k2]->legScale2^2`，最终六变量顺序固定为 `{loopScale,legScale1,legScale2,E1,E2,E3}`；完整执行第 17.3 节逐变量 `ds`、seed、`linearData`、full-loop Kira/DE 旧变量残留门禁。所有六个变量从 seed 到 DE 均保持符号，numeric rules 只能固定 `dim/nu1/zero-point/normalization` 等非 DE 参数。另外验证保留两条外腿时 `sp[k1,k1]->(E0-sE2)^2`、`sp[k2,k2]->sE2^2` 且 `v3->E0` 得到变量 `{ss11,E0,sE2,E1,E2}`。规则左端只能写原始 `sp[...]`。该附加子 case 专门验证坐标/相位绑定，不缩减本节其它全量检查；单一有效外腿属于不同 topology，不与原 family 混作纯重命名。
3. 对全部 seeds 及全部默认/自定义微分算符作用于带 general 指标和参数系数的积分组合；把每个 `_J` 替换为独立惰性 token 后对系数取 `Variables`，剔除指标符号，确认没有裸 `kk/qq/qk/xi/externalLegSquaredCoordinate` 或私有 helper/head/symbol。分别比较声明参数集合与 seed、`linearData`、`DSDE` matrices/sources 实际参数并集，报告缺失、额外和被替换旧变量残留。full-loop custom DE 还要按第 15.3 节六变量、权重全 1 的 Euler relation 检查；与独立 frozen DE 比较。除非另行证明 loop-to-tree projection/basis map，不把它与 tree dlog 矩阵直接相减。
4. 源码审阅必须确认 bridge 不进入 momentum-IBP 的 `xi` 集合、微分 metadata 对 symbolic 指标不按大小猜 symmetry、EOM 只在离散状态可判定时触发、zero-point 未因 canonical 消失；另列出废弃代码、效率热点和可复用模块候选。

报告逐组给出 passed/total、非零差值数和首个失败，并原样记录 exact/over/under 的消息文本、颜色级别、capability、六变量顺序、参数闭合差集及 frozen expected 哈希。

### 17.5 全 family general 参数闭合与条件性 canonical 审计

本节不是新增物理 family，而是把第 9 节八个 loop family与两个 atomic `timeOnly` family、第 14 节两个 pure-time/tree family 和第 17.4 节 bubble+tree 的既有冻结输入统一送入同一套结构审计。执行方必须先完成各节规定的独立手推和 expected 冻结，之后才可加载当前最新 package；不得用本节的 package 输出补造前面缺失的手推关系。

1. 对每个固定 sign 分支、全部 contact-reachable sector、全部规定 seed 与每个初始化微分变量生成 actual。连续 `a_i,b_i,bS_i,ispN_i` 保持 general；离散 Hankel 状态只取任务书规定的 `0/1`，并另放一个确定的 `n=2` 原子输入检查 EOM 触发。不得用 sample seed 代替各节要求的全部 seeds。
2. 为每个 family 先冻结允许系数参数集合：用户坐标、顶点相位能量、实际 line/tree energy、`nu`/质量参数、`dim`、全部 `a0/b0/bS0`、shrink/Wronskian normalization 以及 family 明确声明的其它常量。对每条 seed 和每条 general-index 总导数，把每个不同 `_J` 替成独立惰性 token，再对各 token 系数和纯系数项分别做 `Together`、`Variables`；禁止直接对含 `J` 指标槽的原表达式调用 `Variables` 后把指标误报成动力学参数。
3. 每个 family 都输出 `declaredParameters`、`allowedCoefficientParameters`、`seenCoefficientParameters`、`missingDeclaredParameters`、`unexpectedParameters` 和 `forbiddenInternalAtoms`。`kk/qq/qk/xi/z/externalLegSquaredCoordinate`、私有占位符、未消去 ISP 内部名或未声明符号均属于失败。某个声明参数在全部关系并集中未出现时，执行方必须逐项说明它因 topology/固定分支而数学缺席，或判定为遗漏；不得机械要求每个参数出现在每一条关系，也不得静默删除差集。
4. 对 general `a_i,b_i,ispN_i` 和符号 `n_i` 做条件性检查：符号 `n_i` 不应被假装成 `n=2` 执行 EOM；代入确定的离散 `n=2` 后必须立即约回允许状态。自动 tadpole symmetry 与用户 `symmetryRules` 必须求并集；只有 exact 离散态、可判定奇偶性或用户规则明确匹配时才能作用。不得通过 `OrderedQ`、符号名字符串或未给出的大小假设给 general 指标猜 canonical 次序。
5. 所有 h family 的每个 active `tau` 幂和每条 active line 的模长幂都必须有显式符号 zero-point。cycle line 检查 `a+a0`、`b+b0` 或 `bS+bS0`；bridge/fixed/timeOnly line 虽无 `b/bS` 指标槽，`b0/bS0` 仍必须进入结构化 `sectorPrefactorData`。单 contact、三条平行 massive h 的 simultaneous contact、tree projection、迭代和 dlog normalization 分别检查 zero-point 因子及其乘积，禁止在 canonical 后把它们设成 0 或丢失。
6. package 单向比较完成后，只对当前解析出的最新版本单文件 package 做源码审阅；不得回头读取主线 expected。审阅报告必须列出：EOM/symmetry 条件分支的实际实现位置、参数闭合转换链、可能废弃或不可达代码、重复扫描和高复杂度热点、可抽成多处复用模块的候选，以及每项建议是否影响当前正确性。

本节结果单独给出 family/branch/sector/seed/variable 五级计数和四类差集，不得只报告一个总 passed 数。报告还必须把每项结论标成“任务书已要求”“package 已实现”“正式 package 自检通过”“source-isolated 独立通过”之一；后两者不能互相替代。

### 17.6 017 sector prefactor、parity 与公开表示专项

本节只规定要独立验证的合同，不提供 package 私有 helper 或 expected 表达式。

1. 对 atomic fixed massless、fixed h、fixed H 和至少一个 bubble+tree family，逐 sector 冻结 `lineIndices/parameterKeys/parameterList/powerList/powerParts`。确认 metadata 不缓存乘开的 `parameter^power`，唯一 materializer 构造 `N_s`；`ds[J_s,x]` 含 `D[Log[N_s],x] J_s`，跨 sector 项含同一来源的 `N_s/N_t`。缺省 normalization 只吸收 source/target zero point 的差，不额外吸收整数 shrink power；atomic massless lower 已拥有的 prefactor不得在 contact 系数外重复一份。
2. 从独立 contact 推导验证 cycle parity transport：massless 的 `n1+n2=1,bS=b` 使 child affine offset 翻转 1；massive h/H 的 `n1+n2=1,bS=b+1` 保持 offset；fixed/non-loop line 完全不进入 parity generator。simultaneous contact 的翻转数等于收缩的 massless cycle line 数模 2。H 的结论必须从 H 微分方程推导，不得沿用 h 的文字说明。
3. parity 只在完整 h/H function system 上启用；非 h/H 的显式 parity 请求必须红色失败。用户整数 zero-point rebase 按模 2 平移 child offset，非整数或不可判定 rebase 必须拒绝 parity 初始化并返回双语结构化原因。
4. 审阅并计数 `DSGenerateIBP` 的实际撒点域，确认 parity 在连续/离散点进入生成元前完成筛选，不是先生成全量关系再删除。生成后 certificate 只验证每条关系的 signature；不得把 bad-parity 积分替换为 0。报告给出未筛选候选点数、实际作用点数、方程数和 certificate failure 数。
5. 对 top 及每个 contact-reachable compact lower sector，逐变量调用 `ds` 并验证 sector 先由 root-ordered pack pattern 唯一解析。相同 compact `aList` 的不同 shrink set 不得混淆；每个关系、seed record、`linearData` 和 tree 结果中的公开积分都必须匹配 `J[_,_,_]`，一参数 `J`、旧单 massless `n`、空 fixed pack 都是失败。
6. 对 massive-only tree 验证 Private vertex-basis 适配前后 master 顺序、系数、sector tag 和全部公开表达式不变。对含 massless full line 的最小 tree family，分别调用 `DSTreeSeeds`、`repIterative`、`DSTreeNaiveIBP`、`DSTreeNaiveDE`、`DSTreeDLogDE`，五者都必须返回 `status->PendingRederivation` 与 `reason->masslessQuotientFormulaNotCertified`，不得给出猜测矩阵。

## 18. 完成检查表

每个函数族交付前确认：

- [ ] 除第 13.2 节逐路径许可的六份只读 reference source 输入外，没有读取本项目代码或旧 expected。
- [ ] 没有读取、复制、写入或引用根目录 `check-smoke/`；其中任何脚本、结果或结论均未进入独立推导、比较或归因。
- [ ] `derivation.md` 已记录外部恒等式来源和从原始定义到最终关系的推导链。
- [ ] 所有含 massive line 的 family 都完成直接 h 手推与 package 对照；裸 H 只在指定的两个 family 中独立手推，没有从 package note 补读。
- [ ] `family.wl` 的 `familyDefinition` 已包含第 9.0 节全部固定字段。
- [ ] README 已按 `vertexOrder/lineOrder/ispData` 顺序逐槽说明 `J[aList,linePacks,ispList]` 的物理对象。
- [ ] README 已逐条写出每条 massless 线的有序端点、双端点 quotient relations 和 canonical 方向。
- [ ] 每个 family 的 `vertexSignCases` 与第 9.0 节冻结表完全一致：恰有一个纯同号和一个混合分支，没有运行时随机选择。
- [ ] 两个固定 sign 分支内部的全部 IBP seeds 已覆盖，没有再对子集抽样。
- [ ] 每个符号 case 的所有可达 sector 已覆盖。
- [ ] 每个 sector 的所有 active time 生成元已覆盖。
- [ ] 每个 `ibpMode->"full"` sector 的所有 `L(L+K)` momentum 生成元已覆盖；`timeOnly` family 未伪造 momentum generator。
- [ ] 所有剩余离散 `n=0/1` 状态已覆盖；massless full 的四个双端点输入态与 quotient canonical 已覆盖。
- [ ] massive `n=2` 已立即 EOM。
- [ ] massless theta-delta 与有序端点符号已检查。
- [ ] 非零 zero-point 已保留。
- [ ] ISP 非零指标点已在两圈 ISP 例和 `vertex_energy_signs` 中检查。
- [ ] 每个函数族、固定 sign 分支、规定基底路线、可达 sector 和独立外部变量均已有 general-index `expectedDerivatives`。
- [ ] 每条总导数检查同时覆盖显式系数导数、两个积分的指标导数和纯系数项，最后对完整结果统一 canonical。
- [ ] 外不变量求导从有序 `D_ij` 独立推导，raw 反解严格使用 `{D_ij|i<=j}`；平方 Gram 到 `ssij` 的链式法则及一般非线性顶点能量均已处理。
- [ ] Reference bubble 已完成 reference-only `G/R1/R2 -> J`、`Vpm=0 -> --`、`P_ref=-P_pkg`、zero-point 与 `ks=ss11`（旧平方变量仅在 adapter 中取 `s11Ref=ss11^2`）对齐；active 17 和辅助 20/21 的显式能量符号已逐项核对。
- [ ] Reference 的 symmetry 与 parity 已通过 package `symmetryRules` 应用；R2 在求导 basis 前 canonical 到 R1。
- [ ] 两个 H family 的 `bare-H(T=I)` 与 `H-to-h` 均已和独立 expected 比较；`H-to-h` 的全部 IBP seeds、`ds`、`AT` 与 `WT/shrinkTerms` 还已和 `direct-h` 逐项比较为零。
- [ ] 冻结 expected 后才调用 `ds[expression,variable,topo]`，全部差值为零且无 forbidden `n`/内部 `kk`。
- [ ] 输出没有写回 `independent-benchmark/`。
- [ ] 保持当前逐线三槽 `J`，并已从原始乘积及明确的统一分布正则化独立推导全部非零 boundary 与可达 sector；未引入其它 Head，也未从任务书外补读答案。
- [ ] 当前最新单文件 package 在新 kernel 中独立加载，`$dSIBPVersion` 与 `currentVersion` 一致，usage/Options、初始化 metadata、消息开关和 headless 稀疏进度均通过。
- [ ] 当前最新 package 的 Kira exporter/importer 正例与 completion/hash/maps/targets/RHS 五类负例全部通过，package 未启动 reduction。
- [ ] 恰好两套真实 Kira 来自本次独立工作区：reference bubble 与 mixed bubble+tree exact custom context；每套 equations/independent relations/masters/targets/unreduced、input hash、命令和耗时均已核对，其它 family 未重复运行 reduction。
- [ ] 两套 Kira 的全部 DE variables 从 seed 到 DSDE 均保持符号，`numericRuleLHS` 与 DE variables 交集为空且 RHS 不含 DE variables；bubble 的 `{ss11,P0}` 与 bubble+tree 的六个 custom variables 都没有被直接或间接数值化。
- [ ] `DSDE[{ss11,P0}]` 和 bubble+tree `DSDE[Automatic]` 均无 residual `J` 或内部 `kk`/ISP；Euler matrix/source 恒等式按同序 master degrees 符号成立。reference-style bubble DE 使用含 `E[T] Inverse[T]` 的完整 degree conjugation，并在 `ks=ss11=43/17,P0=29/13` 的非奇异精确点逐项差为零；bubble 未误做 dlog/pole 检查。
- [ ] Tree `++`/`+-` 已在同序 normalized masters 下完成 `DSTreeNaiveIBP -> DSTreeNaiveDE` 与直接 dlog 双路线；传播子能量、顶点能量、`D[N_s]`、solve residual 和 mixed-contact guard 全部通过。
- [ ] 根号坐标 expected 在加载当前最新 package 前冻结；`ssij` Jacobian、`sEi` 相位/系数导数、numeric square mapping、旧 `sij` 单位 Jacobian和 loop-generator/ISP 隔离全部通过。
- [ ] 当前最新单文件和手册哈希已记录，Phase 2 前后全部 frozen expected 哈希复核不变。
- [ ] 双显式动量列表、任意命名、复合方向、加减号、结构圈数、routing/cycle-space 与 exact/over/under 均按冻结 expected 通过。
- [ ] 欠完备给红色 Error、拒绝初始化且所有下游 capability gate 生效；过完备给红色 Warning，只允许诊断性 symbolic seed/linearData，`ds/DSDE/rep2innerform/DSKiraExport` 与 backend export 均拒绝。
- [ ] cycle/fixed 三槽 pack、结构化 sector prefactor、timeOnly 统一三参数表示、root sector 继承及 massive-only naive/公式 tree 双路线逐项通过。
- [ ] massless parity 翻转、h/H parity 保持、fixed line 排除、生成前 parity 筛选和 certificate 均逐项通过。
- [ ] 含 massless full line 的五个公式型 tree 接口均明确 `PendingRederivation`，没有旧公开表示或猜测结果。
- [ ] notation/redefinition、9/10/100 补零和全部 API/example coverage 通过；当前最新程序/PDF 哈希已记录，全部 Phase 1 冻结哈希复核不变。
- [ ] 双 `kL`/双 `kE` mixed-triangle 变体已验证 `k11=|kL2|`、`k22=|kL1|`、`k12=|kL1+kL2|` 的 exact 满秩映射；没有把 `k12` 误当成 `ss12=Sqrt[sp[kL1,kL2]]`，八个用户变量均有且只有一个微分算符。
- [ ] bubble+tree、双 `kL`/双 `kE` mixed-triangle 和 `vertex_energy_signs` 三例均完成 exact/overcomplete/undercomplete；Warning/Error 红字、severity、rank、null-space/missing directions、capability 和下游返回状态全部符合第 17.3 节。
- [ ] exact 自定义参数化不只改 metadata：每个自定义变量的 `ds` 均与独立 Jacobian 结果一致，全部 custom operators/变量顺序完整，无 missing/duplicate。
- [ ] 自定义 context 的全部 `DSSeeds` 与 `DSLinear` 计算 payload 不含被替换旧坐标、内部原子或私有符号；旧坐标只允许留在明确的 provenance/audit 字段。
- [ ] mixed bubble+tree exact custom loop context 已重新 export、外部 reduction、import 并生成 `DSDE[Automatic]`；独立 tree family 的 naive/dlog DE 已同 basis 比较。两类 DE 的 variables、matrices 和 sources 均无旧坐标、内部原子、私有符号或 residual `J`，且未在没有映射时直接比较 full-loop 与 tree 矩阵。
- [ ] 固定 bubble+tree 的六变量 general-index `ds`、全部 seeds、exact/over/under 消息合同、参数差集和源码审阅已按第 17.4 节完成；没有把任何既有 package 自检计作独立 expected。
- [ ] 第 9、14、17 节全部 family 的系数参数并集已按第 17.5 节审计；每个 missing/extra/内部原子都有逐项结论，禁止内部 `kk/qq/qk/xi/z/externalLegSquaredCoordinate` 残留。
- [ ] 第 9、14、16、17 节全部 benchmark families 与 coverage manifest 全部成品 examples 的 seed/linearData/逐变量导数及适用 DE payload 只含最终缺省或自定义参数和允许常量；旧坐标、内部原子、私有符号及 residual `J` 的差集均为空。
- [ ] general 指标没有触发基于符号大小的 EOM/symmetry/canonical；确定的 `n=2`、离散 symmetry 与 parity 仍按约定生效，自动 tadpole 与用户 symmetry 取并集。
- [ ] 所有 h family 的 `tau` 与 line magnitude 物理幂均保留符号 zero-point；fixed/timeOnly 的零点进入显式系数，单/多 contact、tree projection、迭代和 dlog normalization 的零点乘积均已核对。
- [ ] 最终报告明确区分任务书要求、package 实现、正式自检和 source-isolated 独立证据，没有用其中一种状态替代另一种。
