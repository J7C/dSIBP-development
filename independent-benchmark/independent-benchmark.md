# dS IBP 独立 benchmark 推导任务书

> **用途边界**：本文交给新的独立 subagent 执行。Phase 1 只允许读取本文与公开文献，不得打开同目录的 `package/`、reference result、主线、维护检查或旧报告；只手推本文限定 family/sign/parity/sector/generator 下、未代入任何 seed 点的 general symbolic IBP seed identities，以及参量微分算符。两类 expected 及来源记录冻结后，Phase 2 才可读取当前正式程序、同版本用户手册和任务书逐路径许可的 reference source/result，先做通用对象单向比较，再按任务书点名项目执行 package 生成、序列化、外部约化、回读、DE 与 scaling 验证。不要把手推答案、expected、check 或运行产物写入本目录；独立 subagent 使用自己的新工作区，最终只按项目规则回收报告。

## 1. 任务目标

本任务严格分为两个阶段，二者不能混写：

| 阶段 | 允许产生的对象 | 明确禁止 |
| --- | --- | --- |
| Phase 1：source-isolated 手推 | 固定 sign/parity、可达 sector 与适用生成元下，保持 general 指标的 IBP seed 恒等式；由声明参量到基础动量不变量的 general symbolic 微分算符 | 连续指标取点、离散态撒点、展开 seed envelope、`DSGenerateIBP`、`DSLinear`、Kira/reduction、DE matrix、scaling、数值 probe，以及读取任何 package/旧 expected/旧结果 |
| Phase 2：正式 package 验证 | 正式 package 的 general seed identities/参量算符与冻结 expected 的逐项比较；随后只对任务书点名项目走 package 生成与 serializer、package 外部 reduction、回读、DE 和 scaling 流程 | 增加未点名的 family/sign/parity；修改 frozen expected 追随 package；用 package actual 反向补造 Phase 1；让 package 自己启动 reduction；把维护侧 `check-smoke/` 当独立证据 |

“Phase 1 完整”只表示限定范围内两类通用符号对象完整，不表示手推撒点后的数万条关系。Phase 2 的规定流程必须真实经过 `DSInit -> DSSeeds -> DSGenerateIBP -> DSLinear -> DSKiraPlan/DSKiraExport -> package 外部 reduction -> DSKiraImport -> DSDE -> scaling check`；它是基于 package 的运行验收，不是额外的独立解析推导。

**当前 package 解析规则**：Phase 1 冻结前不得读取 `package/`。进入 Phase 2 后，先枚举 `package/package_<三位版本>.wl` 与同版本 PDF；交付目录必须只有一对当前版本化程序和手册。把唯一文件名中的三位 token 记为 `currentVersion`，用 `Get[唯一程序路径]` 加载所提供的最新 package，再要求 `$dSIBPVersion===currentVersion`；报告文件名也使用该动态 token。任何验证脚本、命令或文字指令都不得写死某个历史或当前版本号，不得通过仓库内 `000_code/<版本目录>/`、旧单文件或旧报告旁路加载；若版本化文件不唯一、程序/PDF token 不一致或运行时版本不匹配，立即停止。

任务范围完整性索引如下；“手推”列只指 Phase 1，“运行”列只指 Phase 2：

| 对象 | Phase 1 手推 | Phase 2 package 运行 |
| --- | --- | --- |
| 物理模板 | 第 2--8 节只用于推导未撒点的通用 time/momentum/contact IBP seed 恒等式与参量算符 | 初始化后取回对应 general templates/operators 并严格比较 |
| 限定范围 | 第 9--12 节固定 family、sign、parity、sector、生成元与输出 | 只在同一冻结范围内展开，不自行增加 sign case 或放宽 parity |
| 规定流程 | 不执行 | 第 13--17 节中明确点名的 package 生成、外部 reduction、回读、DE/scaling 与结构验收 |
| 报告 | 冻结来源、公式和哈希 | 第 18 节按前文回指完成情况；第 19 节核对功能覆盖与排除边界 |

术语约定：本文以后把 `loopExternalMomenta` 的按序元素简称为 `kL1,kL2,...`，把 `independentExternalMomenta` 的按序元素简称为 `kE1,kE2,...`。这是两套互不共享的列表位置编号，不要求输入符号真的采用这些名字；审计时仍以字段角色和原始表达式为准。

共同范围规则：

- Phase 1 不生成大范围解析 IBP，不撒任何连续指标点或数值点；连续指标保持 general，zero-point 保持非零符号。
- 每个函数族只使用第 9.0 节冻结的一个纯同号分支和一个混合分支，并应用 family 已声明的 parity。通用模板按实际可达 sector 与适用 time/momentum 生成元组织；离散端点只按允许的 `0/1` 等价类推导，不再把连续指标包络展开。
- 任何 massive `n=2` 一出现就立即 EOM；massless 正式表示从不产生 `n=2`。
- Phase 2 的 package 全流程可以展开冻结的 seed envelope；只允许任务书点名的 representative workflow 运行外部 reduction，并且每个 workflow 只使用一组确定性精确数值规则。纯数值 workflow 必须先从符号 topology 构造参量微分算符，再从 `DSSeeds[...,ApplyNumericRules->True]` 起让 seed、撒点关系、导数系数和 reduction 共用同一点；要求 `seedResidualCoefficientVariables==={}`、`sampledCoefficientVariables==={}`，并对去掉全部 `J` 后的系数独立确认 `Variables==={}`。reference 既有解析结果只复制、哈希核验并作约定变换，不重新生成 reference IBP 或运行 reference Kira。

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
| `J[[3]] = ispList` | ISP 坐标的整数幂 | `ispList[[r]]` 对应 `ispData[[r]]`；零点固定为 0，正指标表示 numerator，用户显式负指标表示该坐标的额外 denominator |

每个 ISP 使用当前最新 package 的公开 Association schema：

```mathematica
<|"name" -> rho1, "expr" -> sp[q1,k], "range" -> {0,1}|>
```

`name` 是用户侧唯一符号，`expr` 是由声明动量基组成的标量积表达式，`range` 是该整数指标在 seed 中允许的值域。独立推导与 package 对照均直接使用这三个字段，不设 `id/expression` adapter。物理 numerator case 使用非负幂；package 对用户显式负 range 不得报错或删点。

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

**Normalized-sector convention（后文不得另设 adapter）**：本任务书中的公开积分始终是

```text
J_s = N_s I_s,
```

其中 `I_s` 是按本节三槽指标还原的裸 sector 积分，`N_s` 是该 sector 的完整固定/无圈模长 prefactor。初始化按 `independentExternalMomenta` 的声明顺序给独立模长稳定编号；`N_s` 不把当前参数表达式展开后塞进指标，而以结构数据保存

```mathematica
kEpower[be1,be2,...]
kEParameterExpressions = {expr1,expr2,...}
```

并在物化时形成 `Product[expri^bei,i]`。`expri` 可以是用户定义参量的复合表达式；`DSRedefineParameters` 只更新 `kEParameterExpressions`，不得改变稳定编号和 `kEpower` 幂向量。所有 contact 先从裸 kernel 推得 `c_raw`，再且只再乘一次

```text
c_raw N_source/N_target J_target.
```

因此 `ds[J_s,x]` 和 `DSDE` 必须包含 `D[Log[N_s],x] J_s`；`ds[c(x)J_s,x]` 还必须保留 `c'(x)J_s`。把指标表示还原成具体被积函数时，`rep2Integrand` 必须把同一个 `N_s` 乘回 `I_s`。Phase 1 的 seeds/operators 从一开始就按这一 normalized convention 推导，不允许 Phase 2 再通过额外 normalization 或差矩阵反解来对齐。

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
| ISP `r` | `ispList[[r]]` | 固定零点 `0` | `ispData[[r]]["expr"]^ispList[[r]]` |

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

这里两条式子定义二维物理基 `M[0]/M[1]`，不是导数恒等式。018 公开指标不再把它压成单槽，而以 `F[e,n1,n2]` 保留两个有序端点槽；四个 `n1,n2 in {0,1}` 状态必须通过两条独立关系约到上述二维基，并选定 `n2->0` 的 canonical 方向。公开 line pack 始终是 `{b,n1,n2}` 或 `{"F",n1,n2}`。

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

本文统一使用下列 018 pack 规则；左列为 cycle，右列为 fixed/bridge/timeOnly：

```text
massiveFull 或 massiveCross: {b[e],n[e,1],n[e,2]} | {"F",n[e,1],n[e,2]}
masslessFull:                 {b[e],n[e,1],n[e,2]} | {"F",n[e,1],n[e,2]}
masslessCross:                {b[e],0,0}           | {"F",0,0}
shrunk:                       {bS[e]}              | {"F"}
```

各 family 数据块后展示的 top notation 就是 `topIntegralTemplate` 必须保存的值。它必须分别展示同分支与异分支时实际的 `J`，不能只写一个无法判断 pack 长度的占位符。ISP 被积函数约定为 `ISP[r]^ispN[r]`，零点固定为 0；正 `ispN` 表示 numerator，用户显式负值表示额外 denominator，并按 `ispData` 顺序放入 `J` 第三槽。

sector 名统一为 `"top"` 或按 `lineOrder` 排序的 `"e1"`、`"e1_e3"` 等。某 sign case 只枚举由第 8 节独立推导实际到达的 line sets；cross 线没有 theta 导数，不应伪造 shrink sector。缩并后以 `vertexOrder` 中序号最小的顶点作为合并类代表，`aList` 按代表顶点的原顺序排列。

本 benchmark 的 sign 分支不在运行时抽样。每个 family 固定一个纯同号分支和一个混合分支；`vertexSignCases` 只写下表两项。分支数量被收缩，但两个入选分支内部不得再抽样：必须遍历全部 contact-reachable sector、全部 active time 生成元、`ibpMode->"full"` family 的全部 `L(L+K)` momentum 生成元和全部剩余离散态，从而生成这两个分支的全部适用 IBP seeds。两个 atomic family 明确使用 `timeOnly`，不得为单 bridge 伪造圈数或 `dqq`。

| family | 固定纯同号分支 | 固定混合分支 | massive 基底范围 |
| --- | --- | --- | --- |
| `atomic_massless_line` | `++` | `+-` | 不适用 |
| `atomic_massive_line` | `--` | `-+` | 直接 h；裸 H `T=I`；H 经 `T_Htoh` 变到 h |
| `pure_massless_bubble` | `--` | `+-` | 不适用 |
| `mixed_bubble` | `++` | `-+` | 直接 h |
| `mixed_triangle` | `---` | `+-+` | 直接 h |
| `single_massive_sunrise` | `++` | `+-` | 直接 h |
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
vertexEnergies = <|v1->kE,v2->kE|>;
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

Phase 2 按正式用户手册所述的公开 workflow 验收，不在任务书中另行规定通用调用教程或私有分派参数。验收合同仅为：`++` 的公开 canonical seed batch 必须保留三槽 fixed line pack，但 source seeds 只生成 `n2->0` 的 `00/10` 两个 quotient representatives；`01/11` 的原始定义、关系、符号与模长参数系数仍由 Phase 1 四态手推覆盖，并在 package 导数输出中检查其立即 canonical。batch 覆盖 `{top,e1}` 两个 sector并能生成 backend-neutral linear data；`+-` 只覆盖 `{top}`。任何必须依赖未公开状态参数才能得到这些结果的实现均不通过。

专测：

- Phase 1 的 `(n1,n2) in {0,1}^2` 两条 quotient relations、原始 `q^2`/fixed 参数系数；Phase 2 source 的 `00/10` representatives 与 canonical 方向；
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
- 所有剩余 masslessFull line 的 `00/10` source representatives；对导数临时产生的 `01/11` 在 relation 层验证 quotient canonical 与完整动量系数链。

本 benchmark 保留 018 逐线 `J` 表示：每条 masslessFull 线各自保留 `{b[e],n[e,1],n[e,2]}`。这只是输出槽 convention，不规定多传播子乘积的分布结果；独立推导必须从原始乘积确定 quotient、contact 与 canonical 各项，不能把 package 的实现或当前 expected 当作输入。

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

### 9.6 single_massive_sunrise

固定定义：

```mathematica
vertexOrder = {v1,v2};
vertexSignCases = <|
  "++"->{+1,+1}, "+-"->{+1,-1}|>;
loopMomenta = {l3,k321};
loopExternalMomenta = {kL};
independentExternalMomenta = {};
(* 缺省输出：sp[k,k]->ss11^2。 *)
vertexEnergies = <|v1->E1,v2->E2|>;
lineOrder = {1,2,3};
lineData = {
  <|"id"->1, "endpoints"->{v1,v2}, "momentum"->l3,
    "massType"->"massive", "bbType"->"h", "nu"->nuM|>,
  <|"id"->2, "endpoints"->{v1,v2}, "momentum"->k321,
    "massType"->"massless", "bbType"->"exp", "nu"->0|>,
  <|"id"->3, "endpoints"->{v1,v2}, "momentum"->l3-k321-kL,
    "massType"->"massless", "bbType"->"exp", "nu"->0|>
};
ispData = {
  <|"name"->rhoMassless2,"expr"->sp[k321,l3],"range"->{0,1}|>,
  <|"name"->rhoMassless3,"expr"->sp[l3-k321-kL,l3],"range"->{0,1}|>
};
zeroPointRules = {
  a0[v1]->alpha, a0[v2]->alpha,
  b0[1]->betaM, b0[2]->beta0, b0[3]->beta0
};
generatorList = {dtau[v1],dtau[v2],
  dqq[1,1],dqq[1,2],dqk[1,1],
  dqq[2,1],dqq[2,2],dqk[2,1]};
symmetryRules = {
  HoldPattern[(int_J /; vertexSwapNeededQ[int])] :> swapVertices[int],
  HoldPattern[(int_J /; masslessLineSwapNeededQ[int])] :>
    swapMasslessLinesAndISP[int]
};
parityConstraints = {
  b[1]+n[1,1]+n[1,2] -> 1,
  b[2]+n[2,1]+n[2,2]+b[3]+n[3,1]+n[3,2] -> 1
};
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

每个 sign case 的 sector 集合都从三条线的完整原始乘积独立推导，任务书不列出目标答案。五个独立 loop scalar products为 `l3^2,l3.k321,k321^2,l3.kL,k321.kL`；三个 propagator square 加上述两个 ISP 必须先证明可反解。两个 ISP 因子自身的求导项都必须保留为 general `r1,r2` 公式，并在公式层确认 `rj=0` 时相应自身导数精确为零；不得为此枚举 ISP 数值点。`++` 分支使用 `odd,odd`：第一条约束是 massive line 的 `b+n1+n2`，第二条是两条可交换 massless lines 对应量之和；lower sector 的 affine offset必须由 root constraint 经 contact map 推导。

两类对称性都必须先为等价类选定唯一 canonical representative，再写成指向该代表的单向规则；上述 `vertexSwapNeededQ`、`masslessLineSwapNeededQ` 及右端 helper 的明确定义必须保存在该 family 的 `family.wl`。顶点交换同时交换 `aList` 并反转三条 full line 的 endpoint slots；在 `k321 <-> l3-k321-kL` 下，两条 massless lines 交换必须同步交换 line 2/3 packs 与 ISP 1/2 指数。禁止写 `A->B` 和 `B->A` 的双向循环，也不能只交换 line packs 而遗漏 ISP。package 当前不负责给未排序规则自动定向。

固定的 `++` 与 `+-` 两个分支、全部可达 sector、全部 active time，以及六个 momentum 生成元：

```text
d/dq1.q1, d/dq1.q2, d/dq1.k
d/dq2.q1, d/dq2.q2, d/dq2.k
```

`++` 与对应 general seed 比较固定使用上述 `odd,odd` 子系统。第一行是唯一 massive line 的 `b+Sum[n]` parity；第二行是两条可交换 massless line 的总 `b+Sum[n]` parity。这里把 parity 作为 general source class 与 sector affine remainder 保存，不枚举连续指标点。contact/shrink sector 不重新手写约束，而由 root 两行经 compiled contact affine map 传播：每收缩一条 massless cycle line，第二行的 affine offset 翻转一次；simultaneous contact 按收缩条数模 2 累加。顶点交换及 massless line/ISP 同步交换必须保持这组 `odd,odd` 约束。

三条线仍按当前逐线 `J` 表示分别保留 line pack；不得用其它 Head 替代这里的三槽 `J`，也不得由 pack 形状反推未经独立推导的分布结果。

本 family 的交付范围到此为止，只允许两类输出：全部限定 branch/sector/generator/discrete class 的 general IBP seed identities，以及 `{ss11,kE}` 的 general 参数微分算符。`ss11=Sqrt[sp[kL,kL]]` 必须由 `2 ss11 d/d sp[kL,kL]` 链式得到；共同参数 `kE` 的算符同时包含两个顶点能量方向。Phase 1 不生成连续 seed 点、target、`linearData`、Kira 输入、master、DE 或 scaling。Phase 2 只用 `DSInit -> DSSeeds/DSAllSeeds` 和初始化 operator metadata/公开 `ds` witness 与上述 frozen expected 比较；不得为此 family 调用 `DSMetaSeedRange`、`DSGenerateIBP`、`DSLinear` 或任何后端。

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
## 10. General IBP seed 身份与离散基底

Phase 1 不给连续指标取任何整数点。每条 expected 都保持

```mathematica
a[v], b[e], bS[e], ispN[j]
```

为 general 符号，并显式保留 `a0[v]`、`b0[e]`、独立推导得到的 merged zero-point、适用的 `bS0[e]` 与结构化 sector prefactor。fixed/bridge/timeOnly line 没有连续 `b/bS` 槽，不得为了统一外形伪造该指标；其物理模长幂留在 `N_s`。若一个 general seed 恒等式严格为零，直接以零模板记录原因，不得另找非零整数点替代。

离散端点状态不是连续撒点。对任务书点名 branch/parity 下实际存在的 massive 或 masslessFull line，Phase 1 先从四个原始 massless 双端点状态推导 quotient 与完整动量系数；冻结后，IBP source seeds 只保留 `n2->0` 的 `00/10` 两个代表，massive 仍按所需四态处理。parity 已判定为零的类记录其选择规则和零原因，不再把相反 parity 当作额外验证项目。massive `n=2` 只作为 EOM 公式中的中间状态并立即消去；massless 正式输出不出现 `n=2` 或非 canonical 的 source `n2=1`。

每条 Phase 1 seed identity 覆盖一个冻结的 `{family,branch,sector,generator,discreteClass,basisMode}`。这里的“覆盖”是 general 公式覆盖，不是对连续指标 envelope 的点枚举。`DSGenerateIBP` 的连续范围、实际点数、parity 筛选和关系数量只属于 Phase 2 点名项目。


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

`pure_massive_bubble_reference` 与 `single_massive_sunrise` 使用非空 `symmetryRules`；其它函数族不加入额外对称性。两者都必须先固定等价类排序并只向 canonical representative 单向替换。`sp` 的 `Orderless` 另行检查，不能计入这里的图对称性覆盖。
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

`README.md` 用普通小节或表格复述 topology、notation、massless 方向、动量路由、sector、生成元、离散基底类、branch/parity 和特殊 tags。它必须能让审查者不运行 `family.wl` 也知道每个 `J` 槽位、每个固定符号和每条选择规则的含义。

`derivation.md` 是必交的来源隔离记录。它必须从第 2 节允许的原始定义开始，列出实际使用的标准 Hankel 恒等式及来源，并展示适用基底路线的 H/h 闭合关系、Wronskian、各 `n` shrink、massless endpoint 关系和 `J` 指标映射的中间步骤；不能只抄最终 expected。没有 H 路线的 family 不得为了形式完整而复制其它 family 的 H 推导。

`expected.wl` 只保存两类 Phase 1 对象，并使用扁平列表。第一类是未撒点的 general IBP seed identity：

```mathematica
expectedSeedIdentities = {
  <|
    "sector" -> "top",
    "vertexSigns" -> "++",
    "generator" -> dtau[v1],
    "discreteClass" -> {n[1,1]->0,n[1,2]->1},
    "parityAssumptions" -> {...},
    "sourceIntegral" -> (* general a/b/bS/ispN 的 J *),
    "equation" -> (* 已 EOM/symmetry/parity/canonical 的 general J 线性组合 *),
    "tags" -> {"masslessFirstEndpoint","thetaShrink"}
  |>,
  ...
};
```

第二类是参量微分算符：

```mathematica
expectedParameterOperators = {
  <|
    "variable" -> ss11,
    "baseCoordinates" -> {sp[k1,k1]},
    "operator" -> 2 ss11 partialSP[k1,k1],
    "phaseTerms" -> {...},
    "fixedLineTerms" -> {...},
    "assumptions" -> {...},
    "tags" -> {"rootCoordinate"}
  |>,
  ...
};
```

`generator` 只使用 `dtau[v]`、`dqq[i,j]` 或 `dqk[i,j]`。禁止出现连续 `seedRules`、数值 probe、展开后的 relation envelope、`linearData`、reduction 或 DE matrix。另在 README 写：

- 预期 sector 数；
- 每 sector active time 数；
- momentum generator 数；
- 每 sector 的离散基底类与 parity 排除类；
- general seed identity 数；
- 严格零模板数及原因；
- 参量微分算符数。

Phase 2 输出与 Phase 1 分目录保存。它可以记录 package 模板比较、撒点后 relation 数、`linearData`、Kira、DE/scaling 和数值点，但不得写回或改写 `expected.wl`。

## 13. 动力学量总导数与 reference bubble 对齐

### 13.1 独立参量微分算符要求

Phase 1 的对象是 family 初始化参量对基础平方不变量、顶点相位和 fixed-line 模长的 general 微分算符，不是对每个 sector、每个离散态和每个积分组合逐条生成导数关系。连续时间指标、线指标和 ISP 指标始终保持 general；branch、parity 和离散基底沿用第 9--10 节冻结范围。

独立推导阶段不得调用 package 的 `ds`、`applyIndependentVariableDerivativeSeed`、external-vector decomposition、指标移位 helper 或现有 derivative expected。外不变量导数必须直接从有序方向导数算符

```text
D_ij = k_i . partial/partial k_j
```

对传播子幂、massive/massless building block、ISP 和顶点相位逐项求导，先解出平方 Gram 原子导数，再用 `partial_ssij=2 ssij partial_sp[kLi,kLj]` 得到根号坐标算符。这里 `ssij` 与 `Dij` 是不同对象：

```text
x_ij = k_i.k_j = x_ji,       ssij = Sqrt[x_ij],
D_ij = k_i.partial_{k_j},     D_ij != D_ji in general,
D_ij x_ab = delta_{ja} x_ib + delta_{jb} x_ai.
```

`Orderless` 只 canonical `sp[kLi,kLj]` 的两个标量积参数，不得用于交换 `Dij` 的“左乘向量”和“被求导外动量”两个角色。为使未约化 raw `J` 结果可逐项 strict-zero 比较，本 benchmark 正式固定

```text
ExternalVectorOperatorBasis = {D_ij | 1 <= i <= j <= K},
```

并按 `i` 后 `j` 的字典序排列，例如 `K=2` 时必须使用 `{D11,D12,D22}`，不得改用同样满秩但给出不同 raw representative 的 `{D11,D12,D21}`。若该 basis 在指定运动学或所选外不变量坐标上不满秩，必须报告输入/坐标不闭合，不得静默换 basis。顶点能量若为 `Sqrt[sp[kLi,kLi]]=ssii` 或一般自定义参数函数，必须显式保留普通链式法则。

每个冻结算符必须分别列出 `baseCoordinates`、`ExternalVectorOperatorBasis`、Jacobian、phase contribution、fixed-line contribution、ISP contribution、允许参数和假设。为验证算符确实包含普通乘积法则，每个算符只需作用于一个统一 witness

```text
c(s) J_1 + d(s) J_2 + f(s),
```

并检查 `c' J_1+d' J_2+f'` 与积分导数同时出现；不得把这个 witness 扩展成每个 sector/离散态的 `expectedDerivatives` 清单。完整结果最后统一执行 EOM、massless/massive coincidence canonical、family symmetry 和 parity。

冻结 `expectedParameterOperators` 后，Phase 2 使用 package 初始化返回的公开 operator metadata 与每个算符一个 `ds` witness 单向比较。差值必须在相同 convention 下严格为零，输出只含初始化后的公开变量名。内部 `kk[i,j]`、未知变量和非线性 `J_i J_j` 的拒绝门禁只在第 16--17 节点名的负例中检查。

### 13.2 Reference bubble 的 convention 映射

`pure_massive_bubble_reference` 的 Phase 1 只按第 2--10 节定义推导 `--`、even parity 下的 general IBP seeds 与 `{ks,P_pkg}` 参量算符，不读取 reference code。两类 expected 冻结后，Phase 2 为解释 convention 才允许读取下列冻结 source set；解析矩阵只从随后点名的既有 result set 复制并核验，不得运行这些 source 重新生成：

```text
reference/ref_code/codebubble/001 bubble_ibp_sym.m
reference/ref_code/codebubble/002 bubble_de.m
reference/ref_code/codebubble/OmegaR/OmegaR1.m
reference/ref_code/codebubble/OmegaR/MIsR1.m
reference/ref_code/codebubble/Omegatau/OmegaFolded.m
reference/ref_code/codebubble/Omegatau/MIstau.m
```

后四份文件解释 `001` 如何定义 `MIdlogNote`，不是 Phase 1 expected，也不是本轮 producer。Phase 2 只从 `F:\Agent-projects-nut\dSibp\codebubble\kira_bubble\result\` 复制既有的 `DEP0.m`、`DEks.m`、`DEscaleCheck.m`、`MIdlogNote.m` 与 `derivative_rules_bubble.m` 到自己的只读临时区，并逐字核验 `reference/ref_code/codebubble/kira_bubble/README.md` 记录的五个 SHA-256。禁止执行 `001`/`002`、`run.sh` 或 `jobs.yaml`，禁止重建 reference IBP/reduction，也禁止从 package actual、`reference_probe.wl` 或差矩阵反推这些结果。若外部 result root 不可用或 hash 不符，reference 对照记为未完成；不得以重新生成代替复制。

原始物理 dlog basis 固定为既有 `MIdlogNote.m` 的前 19 项，不是随后代入 `reppara2N` 的 `MIdlogKira`，也不是 stored `DEP0/DEks` basis。执行方必须从哈希一致的复制件逐项提取显式 `ks` 幂并得到

```text
explicitKsDegrees = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0}.
```

`reppara2N` 明确含 `ks->1`，而 `002` 在调用 `dks[MIdlogSym]` 前已经对 `MIdlogNote` 应用该规则；因此 stored `DEks` 不含第 15--18 项显式系数的导数。若 `I_dlog=T I_stored`，则

```text
T = DiagonalMatrix[ks^explicitKsDegrees];
A_Pref_dlog = T . A_Pref_stored . Inverse[T];
A_ks_dlog = D[T,ks] . Inverse[T]
             + T . A_ks_stored . Inverse[T].
```

这里的 `D[T,ks].Inverse[T]` 是恢复 reference 原始 dlog basis 必需的乘积法则项，不是给 package 追加 normalization，也不能省略为只做 homogeneity lift。执行方必须单独冻结 19 个显式幂、四个非零位置、`D[T,ks].Inverse[T]` 的四个非零对角元，并用直接求 `dks[MIdlogNote]` 的结果交叉验证；只由最终矩阵差值反解 `T` 不通过来源门禁。

比较前必须显式记录并实施以下映射：

- reference `Vpm=0` 映射 package 的 `--`，两边物理能量满足 `P_pkg=-P_ref`。Kira-only 实变量另按第 15.3 节定义 `P_pkg=-I ip0`，因此同一截面上 `P_ref=+I ip0`；`ip0` 是一个整体变量名，不是 `I*p0`。必须在此映射后逐项检查 reference `dk0Term` 的两个 top 顶点 shift、R1 的系数 2，以及 active 17 和辅助 20/21 中的显式能量系数。
- `G[{n1,n2,n3,n4},{a1,a2},{b1,b2}]` 映射 top `J[{a1,a2},{{b1,n1,n2},{b2,n3,n4}},{}]`。
- `R1`、`R2` 分别映射 line 1、line 2 shrink；reference 在求导 basis 前已执行 `R2->R1`，所以 R2 必须先由 package `symmetry` canonical 到 R1，不能作为携带另一套 sector metadata 的独立 DE basis。
- top 使用 `a0=2 nu`、`b0=-2 nu`；必须检查 shrink 后 `a0R=2 nu`、shrunk-line `bS0=0`、未缩并线 `b0=-2 nu`。
- reference 的 `ks` 是外动量模长；当前缺省坐标直接是 `ss11=Sqrt[k^2]=ks`。只在读取旧 reference 平方变量 `s11Ref=k^2` 时使用适配 `s11Ref->ss11^2` 和 `partial_ks=2 ks partial_s11Ref`，当前 package 的 `ds[...,ss11]` 不再额外乘一次链式因子。
- reference 的 vertex exchange、line exchange、R2-to-R1、R1 endpoint canonical 和 `reppowerselection` parity 必须全部作为该 case 的 `symmetryRules` 交给 package `symmetry` 模块；不得在 package actual 之外另写后处理冒充 symmetry。

reference 对照只覆盖 `--`、even-parity subsystem 中实际保留的 top/R1 basis 类；相反 parity 只用任务书列出的最小零条件证明选择规则生效，不扩展为另一套运行项目。连续指标保持 general；`dk0/dks` 只比较冻结参量算符在 active basis 上的结果。另用最小原子例子检查 R2-to-R1 和实际使用的 canonical tie-break。

最终 DE 比较必须直接实施能量变量的方向变换，不能用复共轭作为替代证据。在唯一 backend probe `ip0=29/13` 上，package 物理点是 `P_pkg=-29 I/13`，reference 物理点是 `P_ref=+29 I/13`，并使用

```text
A_Ppkg = -A_Pref /. P_ref -> -P_pkg;
A_ks(P_pkg,ks) = A_ks(P_ref,ks) /. P_ref -> -P_pkg.
```

随后才按上述 `T` 恢复原始 dlog basis。依次检查：19 个 basis 表达式同序；`G/R1` 与 normalized `J_s=N_s I_s` 不含额外常数、符号或动力学量的逐项同定义；physical `P_pkg`、backend `ip0` 与 physical `ks` 导数；scaling matrix/source。三套 `19 x 19` 矩阵各须 `361/361` 精确相等、非零差值 0；若失败，报告首个位置和两侧表达式，不得搜索 post-hoc diagonal adapter。

独立执行者在自己的新工作区内按以下布局自行编写 check；这些脚本不得从项目根目录 `check-smoke/` 复制，也不得把输出写回本交付目录：

```text
check/
  check_13_02_reference_dlog_basis/
    check_13_02_reference_dlog_basis.wls
    results/reference_dlog_basis_summary.wl
  check_15_03_reference_bubble_de/
    check_15_03_reference_bubble_de.wls
    results/reference_bubble_de_summary.wl
```

第一份 summary 至少保存 source/result hash、21/19/2 候选计数、`explicitKsDegrees`、四个显式导数位置、直接 `dks` residual 和禁止执行 producer 的审计；第二份至少保存 package/version/input hash、Kira equations/independent relations/masters/targets/unreduced、三套矩阵的维数/相等数/非零差值数/首差值、scaling matrix/source residual 与能量映射。两份都是 Phase 2 summary，不反向成为下一轮 expected。

### 13.3 h、裸 H 与 H 经 T 变到 h 的 package 验收

只在 `atomic_massive_line` 和 `pure_massive_bubble_reference` 两个 family 上执行 H 路线；两者都使用第 9.0 节固定的纯同号与混合分支，并覆盖这两个分支的全部 IBP seeds 和 general-index 动力学量总导数。验证分三路：

1. `direct-h`：从 h 定义独立手推 expected，package 使用直接 h 输入。
2. `bare-H`：从裸 H 定义独立手推 expected，package 使用同一 `P_H,Q_H,W_H` 和 `T=IdentityMatrix[2]`。
3. `H-to-h`：仍输入裸 H 的 `P_H,Q_H,W_H`，但使用从 `h=x^{-nu}H` 及导数基底独立推导的 `T_Htoh`；package 必须消费最终 `AT=T'.Inverse[T]+T.A0.Inverse[T]` 和 `WT=Det[T] W_H`。

`direct-h` 与 `bare-H` 各自和对应独立 expected 逐项比较。`H-to-h` 既要和独立变换后的 expected 比较，也要在相同 `J` 指标基底、zero-point、sector metadata、symmetry/parity 和外部变量表示下，与 `direct-h` 的 package 结果逐条相减。IBP relation、`ds` 总导数、`AT` 编译项和 `WT/shrinkTerms` 四层差值都必须严格为零；只比较矩阵而不比较全部 seeds 不算完成。裸 H `T=I` 与直接 h 属于不同基底，不能跳过 `T_Htoh` 直接声称两者的 `J` 关系相等。

## 14. pure time-IBP/tree 限定验证

本节只使用下列两个 pure-time/tree case。Phase 1 独立产物限于 general `dtau` IBP seed identities 与 treeEnergy/顶点能量参量算符；不独立构造 endpoint reduction、master reduction 或 DE matrix。Phase 2 在同一 convention 下比较 package general seeds/operators，并执行点名的 tree package 功能检查。

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
3. 独立推导每个 treeEnergy/顶点能量变量的参量算符；fixed massive h line 必须包含 `D[k,variable]`、两端点 `a+1,n:0->1` 与 line-prefactor 导数，不能把 loop 积分变量机械当作 tree 外参量。
4. 冻结 general seeds/operators 后进入 Phase 2，调用当前最新 package 的 `DSSeeds/DSTreeSeeds` 和公开 operator metadata 逐项比较。
5. Phase 2 再调用 `repIterative`、`DSTreeNaiveIBP/DE` 与 `DSTreeDLogDE`。这些结果是 package 路线间交叉验证，不写入 Phase 1 expected。master 依论文二进制顺序，letters 按 `vertexOrder` 逐顶点拼接 `{该顶点 massiveLegs 顺序的能量 letters, binary master order 的 cut letters}` 后稳定去重；`letterMatrices` key 必须同序。

多传播子/多顶点中的 SK 类型始终由一条传播子的两个端点 branch 唯一决定；不得把同一传播子拆成部分 `G++`、部分 `G+-`。三顶点 case 必须有显式负面断言：`G+-` 边的 contact term 数为零，且 trace 中没有该边的 `WT/shrinkTerms` 消费记录。

### 14.3 迭代约化与 time-IBP seed 交叉验证

本节全部属于 Phase 2。两种 package 路线使用同一冻结 general seed convention：

- 路线 A：`DSTreeNaiveIBP` 消费与独立 general time seed 已经逐项相等的 package seed，解出指定下降一步的 tree 积分。
- 路线 B：package 直接应用 `A-/A+` 生成的 `repIterative0`，再由 `repIterative[expr,end]` 迭代到同一 `a_e` 终点。

先比较两条 general 单步 relation；再只选一个确定性、避开 `M1` 和变换后 `M0` 奇异面的精确有理参数点，并给 top/lower-sector master 依固定顺序赋确定性有理数。两路最终结果必须严格相等，不使用浮点容差。`repIterative` 必须接受任意有限整数 endpoint 距离，不得设置最大步数；它只拒绝终点列表长度错误、非整数指标/终点、递推奇异、单步没有按 `{剩余可 contact 的 theta 线数,Total[Abs[a-aEnd]]}` 字典序严格下降或检测到 canonical 状态循环的请求。

### 14.4 pure-time/tree 分组报告门禁

最终报告分别列出 Phase 1 general seed/operator 和 Phase 2 template、projection、递推、naive/dlog、guard 的计数，记录固定 branch、首个差值、唯一精确参数点与 master 赋值。Phase 2 路线差异不得反向修改 Phase 1 expected。

## 15. Package 限定项目闭环 benchmark

Phase 1 的全部 general seeds/operators 冻结并记录哈希后，Phase 2 才加载当前正式 package。第 9 节点名 family 只做通用对象比较；撒点、`linearData`、外部 Kira、DE/scaling 只在第 15.3 节两套代表流程中执行。若程序、手册或 frozen expected 哈希变化，立即停止并从受影响阶段复核。

### 15.1 通用模板与参量算符比较

1. 第 9.0 节表中的每个 family 只使用表内固定的一个同号分支和一个混合分支，并应用该 family 明示的 parity；不得增加其它 sign/parity。Phase 2 比较 Phase 1 冻结的 `{family,branch,sector,generator,discreteClass,basisMode}` general seed identity 与 package `DSSeeds/DSAllSeeds` 模板，连续指标不取点。
2. 每个第 13、16、17 节点名参量算符与 package operator metadata 严格相同，并只用一个统一 `ds` witness 检查乘积法则；不建立每个 sector/离散态的 derivative 表。
3. `atomic_massive_line` 与 `pure_massive_bubble_reference` 依第 13.3 节比较 direct-h、bare-H、H-to-h 的 general seeds/operators 与 `AT/WT`；不在其它 massive family 重复 H 路线。
4. 第 14 节两个 tree family 比较 general `dtau` seeds、treeEnergy 算符和公开三槽表示；递推与 naive/dlog 只按第 14.3、15.5 节作为 Phase 2 package 路线交叉验证。
5. common-theta 多线只在 `massless_sunrise_bundle_guard` 固定分支中验证 odd-subset/contact；cross 分支必须没有 theta/`WT` source，不另造全 sign 组合。
6. `single_massive_sunrise` 只比较 general seeds 和 `{ss11,kE}` general 参数微分算符；该 family 在 Phase 2 禁止 `DSMetaSeedRange/DSGenerateIBP/DSLinear/Kira/DE/scaling`。

所有 general 对象差值在相同 `J`、zero-point、endpoint order、canonical、symmetry 和 parity convention 下严格为零。Phase 1 不使用数值 probe。

### 15.2 点名流程的 producer/consumer 门禁

以下检查只附着于第 15.3 节的 pure massive bubble 和 mix bubble+tree，不扩展为独立 API/发布审计：

1. `DSSeeds/DSAllSeeds` 模板与冻结 general seed identities 同序同式；零模板保留 ordinal/hash，forbidden `n` 不出现。
2. `DSGenerateIBP` 只消费各流程明示的最终积分包络。连续指标范围 exact cover，parity 在代入点前筛选；一个反向/空区间负例必须返回不完整 capability，不能静默形成 formal system。另用一个最小 ISP relation 检查：用户显式负 definition range、seed range、target 和 `J` 均可通过；ISP metadata 零点仍为 `0`；target-to-seed 反推不把 ISP 下界降到用户 target 下界以下；`ispN=0` 的 ISP 自身求导不留下 `-1` 项。该最小接口检查不扩张第 9 节任一物理 family 的正式包络。
3. `DSLinear` 保存 backend-neutral equations、唯一 `integralList` 顺序、source digest 与 complete/subset 状态。`DSKiraPlan` 和 exporter 不得二次重排；如流程需要自定义编号，只能在 `DSUserMI` 之前显式调用一次 `DSReorderIntegrals`。只对正式 complete producer 构造 formal plan；一个显式 subset 负例必须被 formal plan 拒绝。
4. 用户 basis 必须通过 `DSUserMI` 从有序单个 `J`/齐次线性组合构造，检查 rank、support 内双向映射和 `userMI/backend` token；不得在 benchmark 内手写 active-basis adapter。formal plan 先保存该 basis 的解析一阶导数、变量顺序、scaling degrees 与最小 target closure，之后才允许 `numericStage->"postDerivative"`。不得在 seed 或解析导数前固定 DE variables。
5. `DSKiraExport` 只序列化，不启动 Kira；manifest 保存 equations/map/targets/active basis、energy map、artifact identity 和实际文件 SHA-256。篡改一个文件或 target 的负例必须在 import 前失败。
6. `DSKiraImport` 验证 completion、identity、双向积分映射、targets、master order 和 RHS closure；失败不得继续 `DSDE`。
7. 在新 kernel 中动态解析唯一 `package_<currentVersion>.wl/pdf`，核对运行时版本和两份 frozen expected 哈希。全 API/example coverage 留给发布检查，不属于本独立 benchmark。

报告只记录这两套流程的模板数、展开方程数、积分数、target 数、证书 hash、passed/total 和首个失败。

### 15.3 真实 Kira、DE 与 scaling 闭环

只在第 15.1--15.2 节全部通过后运行两套且仅两套 package fresh reduction；不为其它 family、branch、parity、默认/自定义坐标副本或扩大包络再运行 reduction：

1. `pure_massive_bubble_reference`：固定 `--`、even parity、等顶点能量和缺省根号坐标 `ks=ss11`。直接加载成品 example 同目录的 `reference_user_mi_basis.wl` 候选数据，再调用 package `DSUserMI` 固定前 19 个 active `userMI` 及两个 auxiliary；`DSDE` 变量为 `{ss11,P0}`。只有等能量条件成立时才应用顶点交换 symmetry。
2. 第 17.4 节 mix bubble+tree：full flow 只取 `+++`，并明确 `parityMode->None`（或等价 `noParityConstraints`）；该 family 没有用户 parity rule，不得人为指定 even/odd。使用 exact 自定义变量 `{loopScale,legScale1,legScale2,E1,E2,E3}` 和一个在 Phase 2 开始时显式列出、冻结顺序与定义的小型 active basis。`++-` 只做 general seeds/operators 比较和 cross/contact guard，不运行 reduction。

两套都按 `DSInit -> DSSeeds -> DSGenerateIBP -> DSLinear -> DSKiraPlan/DSKiraExport -> package 外部 Kira -> DSKiraImport -> DSDE -> scaling check` 执行。`DSKiraExport` 只写后端输入，不得由 package 启动 Kira；每套分别记录 equations、independent relations、masters、targets、unreduced、Kira 版本、命令、wall time 与 artifact hash。Phase 1 不选择 master、不构造 DE expected、不选择数值点。

**Kira-only 能量 convention**：所有且仅所有进入顶点相位的独立物理能量原子使用

```text
k -> -I ik,
```

其中 `ik` 是一个整体的、实的 backend 变量名；角色来自初始化的 phase-energy 结构，不能按符号名字猜。复合/复用能量按结构拆分后聚合，纯空间坐标不变。先在物理变量下构造解析一阶导数和最小 target closure，随后才允许 `numericStage->"postDerivative"` 给 `ik` 及其它非 DE 参数代入精确实有理数。普通导数满足 `D_k=I D_ik`，Euler 算符满足 `k D_k=ik D_ik`；manifest 必须保存双向映射和物理截面 `k->-I r`。映射碰撞、非原子 backend 项或非实有理 backend 值均拒绝 export。

`DSKiraImport -> DSDE` 后 master 顺序必须不变，matrix/source 不得残留 `J`、`kk/qq/qk/xi/z`、ISP 内部名或已固定的非 DE 参数。每套只使用一组确定性、非奇异的精确有理 backend 点做最终数值交叉检查；符号 scaling relation仍必须先成立：

```text
partial_{x_a} M = A_a(x) M + s_a(x),
Sum_a w_a x_a A_a(x) = DiagonalMatrix[delta_i],
Sum_a w_a x_a s_a(x) = 0.
```

若 `M'=T(x)M`，必须使用

```text
A'_a = D[T,x_a] Inverse[T] + T A_a Inverse[T],
E'[T] = Sum_a w_a x_a D[T,x_a],
B' = E'[T] Inverse[T] + T B Inverse[T].
```

sector 对象已按第 3 节定义为 `J_s=N_s I_s`，所以 `delta_s` 必须包含 `E[N_s]/N_s` 以及 measure、`a+a0`、cycle `b+b0` 和 shrink `bS+bS0` 的全部物理 degree。若 active master 另写成 `M=T J`，再额外加入 `E[T]T^-1`，不得把 `N_s` 重复乘第二次。bubble 权重为 `{1,1}`；bubble+tree 六变量权重均为 1。

Bubble reference 只复用已有解析结果，不重新生成 reference IBP，也不运行 reference Kira。Phase 2 先按第 13.2 节核验原始 `DEP0.m`、`DEks.m`、`DEscaleCheck.m`、`MIdlogNote.m`、`derivative_rules_bubble.m` 的 SHA-256，再读取 `reference-results/pure_massive_bubble/reference_probe.wl` 作最后对照。必须依次应用：`P_pkg=-P_ref`；package Kira 截面 `P0_pkg=-I ip0`，故 `D_P0=I D_ip0` 而 Euler 不变；按 provenance 恢复一般 `ks` homogeneity；再从原始 `MIdlogNote[[;;19]]` 恢复第 15--18 项各自显式的一个 `ks`，使 `A_ks` 包含 `D[T,ks].Inverse[T]`。`G/R1` 与 normalized `J_s=N_s I_s` 按逐项同定义测试，比例必须全为 1，不允许 post-hoc basis adapter。

Bubble 的唯一固定点为 `ks=ss11=43/17`、`ip0=29/13`、`P0=-29 I/13`；在确认所有分母非零后，physical `P0`、backend `ip0`、physical `ks` 三套 `19 x 19` 比较各报告相等数、非零差值数和首差值。Bubble+tree 的唯一精确点由执行者在进入 Phase 2 full flow 时冻结并记录，不写入 Phase 1 expected。Bubble 不是完整 dlog 系统，不检查 primitive、letters、pole 或 dlog form。

### 15.4 限定闭环分组报告与修正门禁

最终报告分别给出第 15.1 节 general seeds/operators 的 family/branch/sector/generator passed/total、第 14 节点名 tree 检查计数、第 15.2 节最小 producer/consumer 负例计数，以及第 15.3 节两套 Kira 各自的 equations、independent relations、masters、targets、unreduced、DE/scaling 计数。还要记录固定 branch/parity 状态、DE variables、唯一数值点、input/artifact hash、`currentVersion`、当前程序/PDF 哈希、Phase 1 冻结哈希、首个失败、Kira 版本、命令与耗时。

本节结果并入 `000-report/YYYY-MM-DD-HHmm-{currentVersion}-内部.md`，附件放同名 `-附件/`。发现 package 缺陷时，维护者修正当前最新 package 并重新冻结交付；独立检验者不得改 expected 追随 package，而应从受影响的 Phase 1 对象重新核对。未完成项按第 18--19 节逐项报告，不得把限定验证描述成全 family 审计。

### 15.5 Tree naive IBP/DE 与直接 dlog 的双路线门禁

本节只使用第 14.1 节两顶点 `{+,+}` massive `timeOnly` case。Phase 1 已在第 14.2 节冻结 general `dtau` seeds 与 treeEnergy/顶点能量算符；不得再手推 raw derivative 表、有限 naive 线性系统或 DE matrix。

Phase 2 固定使用 `DSTreeDLogDE[context]["masters"]` 给出的同序 `{sectorKey,integral,coefficient}` 列表，其中 `coefficient=N_s` 是 master 定义的一部分。先让 `DSTreeNaiveIBP` 从已与 Phase 1 general seeds 相等的 package seeds 构造有限一步升幂系统，再由 `DSTreeNaiveDE` 求导；另一条路线直接调用 `DSTreeDLogDE`。两路只能共享 topology convention 和显式 master 列表，不共享 reduction rules或矩阵。

验收只包括：equation/unknown 数与 solve residual；master 顺序和 `N_s` normalization；每个顶点能量与不同 massive treeEnergy 的全部矩阵；`D[Log[N_s],x]` 非零项；residual `J`、内部 sector token 和 source；以及两路矩阵逐项严格相等。第 14.1 节三顶点 `{+,+,-}` case 只用 general seed 和 trace 验证 `G+-` 无 contact/`WT` 消费，不再运行第二套 tree DE。最终数值交叉检查沿用第 14.3 节唯一精确点，不增加其它点。

## 16. 根号坐标与参数闭合的限定验证

本节只验证两个 exact context 及由第一个 exact context 派生的一对负例。Phase 1 只从下列 convention 推导 general 参量算符和相应 Jacobian/rank 结论，不生成 seeds、关系包络或 DE matrix；Phase 2 比较 package operator metadata、每个变量一个 `ds` witness，并检查 capability 状态。

基础约定固定为

```text
x_ij = sp[k_i,k_j] = x_ji,
ssij = Sqrt[x_ij],
partial_ssij = 2 ssij partial_xij,
D_ij = k_i . partial/partial k_j.
```

`x_ij` 是对称坐标，但 `D_ij` 是有序算符；raw decomposition 始终使用第 13.1 节的 `{D_ij|i<=j}`，不得把 `D_12` 换成 `D_21`。不使用 `PowerExpand`，不暗改根号分支。显式旧输入 `sp[ki,kj]->sij` 保持单位 Jacobian；只有缺省 `ssij` 使用上式的 `2 ssij` 链式法则。

### 16.1 双 loop-external exact case

使用第 9.5 节 `mixed_triangle` 的 `loopExternalMomenta={kL1,kL2}`。缺省基础坐标为 `{ss11,ss12,ss22}`；再固定 exact 自定义规则

```wl
sp[kL1,kL1]         -> k22^2
sp[kL2,kL2]         -> k11^2
sp[kL1+kL2,kL1+kL2] -> k12^2
```

故 `k11=|kL2|`、`k22=|kL1|`、`k12=|kL1+kL2|`，而 `k12` 绝不是 `ss12=Sqrt[sp[kL1,kL2]]`。Phase 1 冻结三个用户变量对 `{x11,x12,x22}` 的 full-rank Jacobian、对角/非对角 root-chain rule 和统一 witness `c J1+d J2+f` 的三个算符；Phase 2 用 package metadata 与 `ds` 逐项比较。

### 16.2 Fixed/dependent-binding exact case

固定一个 `timeOnly` massive-h context：无圈方向按首次出现次序包含 `{kE,2 kE,k+kE,k-kE}`，独立基础只取 `k` 与 `kE`；fixed line 和顶点相位都从这些原始矢量表达式取模。初始化必须保存稳定 `sEi` 编号和 dependent bindings，而不是生成外腿交叉 Gram 坐标。至少冻结并比较

```text
|2 kE|^2 = 4 |kE|^2,
|k-kE|^2 = 2 |k|^2 + 2 |kE|^2 - |k+kE|^2,
```

以及它们对独立用户变量的链式法则。算符必须同时包含顶点相位、fixed-line 物理系数、`D[Log[N_s]]` 和显式 witness 系数导数；该 context 不产生 momentum generator 或 ISP。

### 16.3 同源 under/over 负例

负例只从第 16.1 节 exact rules 派生：undercomplete 删除和模长规则，使 `sp[kL1,kL2]` 方向缺失；overcomplete 增加 `sp[kL1-kL2,kL1-kL2]->kDiff^2`，得到一维冗余约束。Phase 1 只记录 Jacobian rank 与 missing/null-space；Phase 2 要求 undercomplete 初始化失败并阻断全部下游，overcomplete 允许诊断性 symbolic seeds/`linearData`，但 `derivativeUsableQ=False`、`backendExportUsableQ=False`，`ds/DSDE/rep2innerform/DSKiraExport` 均拒绝。`rep2Integrand` 是从 `J` 还原被积函数的另一方向，只在 exact context 按第 3 节检查，不得与唯一坐标反变换混淆。只核对 severity、rank、missing/null-space、capability 和返回状态，不审计消息颜色、完整措辞或 notation 位宽。

## 17. 显式动量、sector prefactor 与 mix bubble+tree 限定验证

本节不建立全 family 工程审计。Phase 1 只为下述点名 case 推导 general seeds/operators；Phase 2 先比较这些通用对象，再仅对第 17.4 节指定分支进入第 15.3 节 full flow。用户必须分别给出有序 `loopExternalMomenta` 与 `independentExternalMomenta`；符号名没有角色语义，不能从名称或统一原子表猜测。

### 17.1 结构圈数、routing 与声明完备性

只使用第 17.4 节 bubble+tree 图：三条内线、三个顶点、一个连通分量，故根图圈数为 `L=E-V+C=1`；两条 `v1-v2` 平行线是 cycle，`v2-v3` 是 bridge，外腿不计入 `E`。对 `Q=Aq+r` 的 routing shift 使用满秩参考行消去共同平移；复合方向的 `+/-` 精确系数必须保留。

Phase 1 从 topology 冻结结构圈数、cycle/bridge、routing rank、必要 loop-external 方向和无圈模长方向；Phase 2 与 `DSInit` metadata 比较。exact 声明使用第 17.4 节的两套有序列表；under/over 只复用第 16.3 与 17.3 节各一例，不增加自环、三平行边、随机命名或压力测试。

### 17.2 cycle、fixed 与 pure-time 指标表示

第 3 节三槽和 normalized-sector convention 在此不再改写：cycle full `{b,n1,n2}`，fixed full `{"F",n1,n2}`，cross 的端点槽为 `{0,0}`，shrunk line 保留原 root slot 为 `{bS}` 或 `{"F"}`。固定幂进入 `sectorPrefactorData -> N_s`，不伪造 `b/bS`。

Phase 1 在第 17.4 节 general seeds 中验证：momentum 生成元只遍历 cycle `xi` 与 ISP；`dtau` 遍历顶点全部 active line；contact sector 继承 root loop space 和 line schema。Phase 2 比较相同 seeds/metadata，并在第 14 节两个 `timeOnly` case 检查所有 active line 使用 fixed schema、无 momentum generator/ISP。含 massless full line 的 `PendingRederivation` 状态只在第 17.5 节最小 case 检查一次。

### 17.3 Bubble+tree exact/under/over context

本节只使用第 17.4 节 family。缺省基础规则和变量为

```wl
sp[k1+k2,k1+k2] -> ss11^2
sp[k1,k1]       -> sE1^2
sp[k2,k2]       -> sE2^2
variables = {ss11,sE1,sE2,E1,E2,E3}
```

full-flow exact 自定义规则为

```wl
sp[k1+k2,k1+k2] -> loopScale^2
sp[k1,k1]       -> legScale1^2
sp[k2,k2]       -> legScale2^2
```

最终变量顺序必须是 `{loopScale,legScale1,legScale2,E1,E2,E3}`。Phase 1 冻结六个 general 参量算符；`ss11` 或 `loopScale` 是先作矢量和再取模，绝不是两个 leg scale 的和。Phase 2 用 `DSRedefineParameters` 建立新 context，比较 operators 与每变量一个 `ds` witness，再以同一 exact context 生成第 15.3 节 full flow；seed、`linearData`、DE matrices/sources 不得残留旧坐标、`kk/qq/qk/xi/z`、ISP 内部名、私有符号或 residual `J`。

undercomplete 只删除 `sp[k2,k2]` 方向；overcomplete 只增加 `sp[2 k1,2 k1]->legScaleDouble^2`。验收边界与第 16.3 节相同：只记录 rank、missing/null-space、capability 和各下游返回状态，不扩展到其它 family、成品 example、全部 API、notation 位宽或每个消息文本。exact 重定义不得覆盖/污染原 context；under/over 也不得自动补猜或删除用户参数。

### 17.4 固定 bubble+tree 参数闭合专项

固定 family 不得由其它 bubble/bridge 代替：`v1,v2` 间两条 cycle lines 的动量为 `l1`、`l1+k1+k2`，line 1 是 massive h（指标 `nu1`），line 2 是 massless exponential；`v2,v3` 间 line 3 是动量 `k1+k2` 的 massless exponential bridge。`extLegs={{v1,k1+k2},{v3,k1},{v3,k2}}`，`vertexEnergies=<|v1->E1,v2->E2,v3->E3|>`；三项顶点能量不从传播子动量推断。

```wl
vertexSignCases = <|
  "+++" -> {+1,+1,+1},
  "++-" -> {+1,+1,-1}
|>;
```

`+++` top 为 `J[{a1,a2,a3},{{b1,n11,n12},{b2,n21,n22},{"F",n31,n32}},{}]`；`++-` top 为 `J[{a1,a2,a3},{{b1,n11,n12},{b2,n21,n22},{"F",0,0}},{}]`。line 1/2 是 cycle，line 3 是 fixed bridge；只有 line 1 有 massive EOM。`+++` 的 full lines 按各自 kernel 产生允许 contact，`++-` bridge 是 cross，不能产生 contact/shrink。bridge 的完整物理幂进入 `N_s`，不进入 `J` 的 `b` 槽。

```wl
"loopMomenta" -> {l1}
"loopExternalMomenta" -> {k1+k2}
"independentExternalMomenta" -> {k1,k2}
```

缺省变量恰为 `{ss11,sE1,sE2,E1,E2,E3}`；`ss11=|k1+k2|`，不等于 `sE1+sE2`。Phase 1 对 `+++` 与 `++-` 两个分支各自所有可达 sector 和适用 `dtau/dqq/dqk` 推导 general seeds，并推导六个参量算符；不取连续 seed 点，不推 DE。该 family 的 `symmetryRules={}` 且没有 parity 约束，明确记录 `parityMode->None/noParityConstraints`。

Phase 2 先对两个分支比较 general seeds/operators。随后只对 `+++` 执行第 17.3 节 exact/under/over 与第 15.3 节 full flow；`++-` 只检查 bridge cross 无 contact/`WT`。full flow 的 seed/`linearData`/DE 必须只含六个最终变量与允许常量，且按六变量权重全 1 的 scaling relation闭合；不与 tree dlog 矩阵直接比较。

### 17.5 `N_s`、parity 与未推导边界的点名检查

本节只做四项，不扩展成全 family ledger：

1. `atomic_massless_line` 的 `++` fixed case：冻结 stable kE 编号、`kEpower[...]`、`kEParameterExpressions`、完整 `N_s`、`c_raw N_source/N_target` contact、`D[Log[N_s]]` 和 `rep2Integrand` 回乘。normalized contact 系数应为 `-2/sE1^beta1`，lower prefactor 不得重复。
2. 第 9.4 节 `mixed_bubble` 的 `++` case：一条 massive h cycle 与一条 massless cycle，用独立 contact 推导检查 massless `n1+n2=1,bS=b` 使 child parity offset 翻转，而 h 的 `n1+n2=1,bS=b+1` 保持；fixed line不进入 parity generator。用户整数 zero-point rebase 只按模 2 平移，非整数 rebase 拒绝 parity。
3. 第 15.3 节 pure massive bubble `--`、even full flow：记录未筛选/实际作用 seed 点数，确认 parity 在 `DSGenerateIBP` 生成关系前筛选，生成后 certificate 只核签名，不用 `bad-parity J->0`。不为其它 branch/parity 重跑。
4. 一个含 massless full line 的最小 `timeOnly` case：Phase 1 只保留 general `dtau` seed/operator；Phase 2 调用 `repIterative`、`DSTreeNaiveIBP`、`DSTreeNaiveDE`、`DSTreeDLogDE`，均必须返回 `PendingRederivation/masslessQuotientFormulaNotCertified`。`DSTreeSeeds` 仍用于 general seed 对照，不应被误标为公式型 DE 已认证。

## 18. 两阶段完成摘要

本节只汇总前文章节，不新增 family、branch、parity、数值点、负例或运行任务。

### 18.1 Phase 1 冻结

- [ ] 来源隔离符合第 1、12 节：只读取任务书与公开文献；未读取 package、reference result、主线、`check-smoke/`、旧 expected 或旧报告。
- [ ] 仅交付 `expectedSeedIdentities` 与 `expectedParameterOperators`；连续指标保持 general，离散状态只取任务书点名的有限等价类，没有撒点、`linearData`、Kira、DE、scaling 或数值 probe。
- [ ] 每个对象都记录 family、固定 branch、parity 状态、sector、generator/discrete class、所用 convention、推导来源和 hash；Phase 2 前后 frozen hash 不变。

### 18.2 Phase 2 package 验收

- [ ] 第 15.1 节完成点名 family 的 general seeds/operators 单向比较；第 14、16、17 节只执行各自点名的 package 路线与正负例。
- [ ] 仅第 15.3 节两套 full flow 运行外部 Kira：pure massive bubble `--`/even/default root coordinates，以及 mix bubble+tree `+++`/no parity/exact custom coordinates；其它 branch/family 不运行 reduction。
- [ ] 两套 full flow 均完成 export、外部 reduction、import、DE、符号 scaling 和各自唯一精确点；package 未自行启动 reduction，reference bubble 未重新生成 IBP 或运行 reference Kira。
- [ ] 第 15.5 节只对两顶点 `++` massive tree 比较 naive/dlog；三顶点 `++-` 只验证 cross/contact guard；含 massless full line 的公式型 tree 路线保持 `PendingRederivation`。

### 18.3 范围与报告

- [ ] 没有增加任务书未点名的 sign/parity、全 family 参数闭合、expanded-envelope、API/example coverage、notation 压力、消息颜色/全文、源码性能或废弃代码审计。
- [ ] 报告按第 15.4 节分别列出 Phase 1/2 计数、两个 full flow 的 equations/masters/targets/unreduced、DE/scaling 差值、唯一数值点、版本/hash、首个失败和明确未完成项。
- [ ] 报告明确区分“任务书要求”“package 运行结果”“既有正式自检”和“本轮 source-isolated 证据”；任一状态不替代另一状态。

## 19. 验证功能覆盖索引

本表用于发现漏检功能。若新增功能不在表中，应先修改点名 case 和章节边界；不得在执行时临时扩大 family/sign/parity。

| 功能 | 必须统一的 convention | 定义章节 | Phase 1：family / branch / parity | Phase 2：章节与函数族 | 排除边界 |
| --- | --- | --- | --- | --- | --- |
| 统一三槽 `J` 与 sector identity | 只用 `J[aList,linePacks,ispList]`；root line slot 不删除 | 3, 8 | 第 9 节全部点名 family；第 14 节两个 tree case；17.4 `+++`,`++-` / no parity | 15.1 `DSSeeds/DSAllSeeds`；17.2 bubble+tree/tree shape | 不审计一参数旧 `J` 路线 |
| `J_s=N_s I_s` 与 `kEpower` | stable kE 编号；表达式与幂向量分离 | 3, 17.5 | `atomic_massless_line` `++`；16.2 fixed binding | 17.5 `DSInit` metadata、`ds`、`rep2Integrand` | 不做全 family prefactor ledger |
| Contact normalization | `c_raw N_source/N_target J_target`，只乘一次 | 3, 5, 8 | `atomic_massless_line` `++`；`mixed_bubble` `++`；17.4 两分支 | 15.1 seeds；17.5 atomic/mixed targeted checks | 不扩展到所有 h/H/fixed 组合 |
| `D[Log[N_s]]` | `ds[J_s,x]` 含 normalization derivative；显式 `c'(x)` 另保留 | 3, 13.1 | 13.1 witness；16.2 fixed binding；17.4 六算符 | 13.1/16/17 `ds`；15.3 `DSDE`；15.5 tree DE | 不生成逐 sector `expectedDerivatives` |
| 指标到 integrand 还原 | `rep2Integrand` 把同一 `N_s` 乘回裸 integrand；不同于 `rep2innerform` | 3.1, 17.5 | `atomic_massless_line` `++` | 17.5 exact context 的 `rep2Integrand` | 过完备时关闭的是唯一坐标反变换 `rep2innerform` |
| Massive h/H EOM | h、bare H、`T_Htoh` 各按自身一阶系统 | 2.2, 5, 13.3 | `atomic_massive_line` 与 `pure_massive_bubble_reference` 固定两分支 | 13.3 direct-h/bare-H/H-to-h seeds/operators、`AT/WT` | 其它 massive family 只走 direct h |
| Wronskian、共同 theta 与 simultaneous contact | 同一 propagator 的两端 branch 唯一；cross 无 `WT` | 2.3, 5, 8 | `massless_sunrise_bundle_guard` 固定分支；14.1 两个 tree case | 15.1 general compare；14.2/15.5 package trace | 不枚举全 sign 组合 |
| Massless ordered quotient | endpoint order 固定；单导数的 `+/-i` 先保留再 quotient | 2.4, 4 | `atomic_massless_line`、`pure_massless_bubble`、`mixed_bubble` 点名分支 | 15.1 general templates；17.5 formula-tree fail-closed | 不把 quotient relation 当 physical derivative |
| Time IBP seeds | 每个 active vertex 一个 general `dtau`；不撒点 | 6, 9, 14 | 第 9 节点名范围；14.1 两个 tree；17.4 两分支 | 15.1 `DSSeeds`; 14.2 `DSTreeSeeds` | 只在两个 full flow 展开关系 |
| Momentum IBP 与 ISP | 完整 `L(L+K)`；bridge 不进 `xi`; ISP 按声明顺序 | 7, 9.8, 17.1 | 第 9 节 full families；17.4 两分支 | 15.1 templates；17.4 bubble+tree；15.3 `+++` full flow | `timeOnly` 不产生 momentum generator |
| Contact-reachable sector | sector 继承 root loop space/schema，只改变 line state/merged vertex | 8, 17.2 | 点名 family 的 general sector seeds | 15.1 templates；17.4 `+++`,`++-` | 不遍历任务书外 sector/family |
| Symmetry/canonical | 显式用户规则先排序并单向指向唯一代表；不允许双向循环 | 9.6, 10, 11 | `pure_massive_bubble_reference`；`single_massive_sunrise` 的顶点与 massless-line/ISP 交换 | 15.1 general compare；13.2 R2->R1；9.6 ordered canonical | 不做全 family automorphism 检测或自动定向 |
| Root-coordinate 算符 | symmetric `x_ij`，ordered `D_ij`，`partial_ssij=2ssij partial_xij` | 13.1, 16 | 16.1 mixed_triangle exact；16.2 fixed binding | 16.1/16.2 metadata + one `ds` witness/variable | 不做五组坐标 family |
| Loop/independent momentum roles | 两个显式有序列表；不按名字猜；复合方向保留系数 | 2.5, 17.1 | 17.4 bubble+tree topology | 17.1 `DSInit` metadata；17.3 capability | 不做随机命名、自环、压力测试 |
| Exact/under/over kinematics | exact full rank；under fail init；over 仅 diagnostic symbolic | 16.3, 17.3 | 同源 Jacobian rank/missing/null-space | `DSRedefineParameters`, `DSSeeds`, `DSLinear`, `ds`, `DSDE`, `rep2innerform`, `DSKiraExport` capability | 仅 mixed_triangle 与 bubble+tree 各一组 |
| `timeOnly` fixed schema | 全 active line 用 `"F"` pack；无 momentum/ISP | 3, 14, 17.2 | 14.1 两个 massive tree；17.5 massless minimal | `DSTreeSeeds`; 15.5 naive/dlog；17.5 fail-closed | 不运行 tree Kira |
| Parity transport | massless cycle 翻转；h/H cycle 保持；fixed 排除 | 8, 17.5 | `mixed_bubble` `++` | 17.5 seeds/sector metadata | 不给 bubble+tree 发明 parity |
| Parity pre-filter | 在生成关系前筛选，不用 `bad-parity J->0` | 10, 17.5 | pure massive bubble `--`/even 的选择规则 | 15.3/17.5 `DSGenerateIBP` counts + certificate | 不跑其它 parity channel |
| Massless tree 未推导边界 | 公式型 quotient reduction 未认证 | 14, 17.5 | 最小 massless `timeOnly` general seed/operator | 17.5 `repIterative`/naive/dlog 返回 `PendingRederivation` | `DSTreeSeeds` 的 general seed 对照仍允许 |
| Kira 能量变量 | 仅相位能量 `k->-I ik`; `D_k=I D_ik`; Euler 不变 | 15.3 | Phase 1 不涉及 | 两套 full flow 的 `DSKiraPlan/Export/Import` | 不替换纯空间坐标，不运行 reference Kira |
| Serializer/import identity | backend-neutral `linearData`; artifact/hash/map/target/master closure | 15.2 | Phase 1 不涉及 | 仅两套 full flow的 `DSLinear/DSKiraPlan/Export/Import` | 不做全 API/release 审计 |
| DE closure | master 同序；无 residual `J`/内部原子；显式系数求导保留 | 15.3, 15.5 | Phase 1 不推 DE matrix | 两套 loop `DSDE`；一个 two-vertex tree naive/dlog | full-loop 与 tree 无 map 时不比较 |
| Scaling relation | 完整 physical degree 含 `N_s`; normalization 用 `E[T]T^-1` | 15.3 | Phase 1 不做 scaling | 两套 full flow，先符号恒等式后唯一精确点 | 不作为额外 family/example 任务 |
| Reference basis/energy/`ks` | `P_pkg=-P_ref`; `P0=-I ip0`; 原始 `MIdlogNote`; explicit `ks` 导数恢复 | 13.2, 15.3 | pure massive bubble `--`/even seeds/operators，不读 reference | reference source hash、R2->R1、`T' T^-1`、三套 `361` 比较 | 不反解 adapter，不 fresh reference reduction |
