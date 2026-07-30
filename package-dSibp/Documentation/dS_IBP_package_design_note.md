# dS IBP Package 设计笔记

本笔记记录当前主线的约定体系和关键推导，与 `dS_IBP_package_plan.md` 配合阅读。不同拓扑由输入 Association 描述，共用同一套 topology-driven IBP 生成函数。

## 0. 最高优先级正确性门禁

同一代表顶点对的多条 full lines 共享时间差，其分布 boundary、Wronskian 编译、指标/零点映射和 sector 可达性是一个不可拆开的 P0 模块。它不是压缩 line pack 的可选优化。当前权威调用链为：

```text
共同 theta 的 bundle product
  -> odd-subset contact
  -> massive: WT=Det[T]W -> shrinkTerms
     massless: ordered-endpoint -2/+2 contact
  -> simultaneous shrinkLinesIntegral
  -> sectorZeroPointRules
  -> coincident canonical
  -> contactReachableShrinkSubsets
  -> canonical batch -> linearData -> serializer
```

其中 serializer 只能消费结果，不能重算 contact。详细验收清单见 `Documentation/2026-07-21_common_theta_correctness_todo.md`，两种等价分布定义的证明见技术笔记附录。

## 1. 基本对象与记号

图的输入数据由 family 初始化给出：

- 顶点集合：`v = 1,...,V`，每个顶点有共形时间 `\tau_v` 和 SK 分支标记 `\epsilon_v \in \{+,-\}`。
- 圈动量基：`q_1,...,q_L`。
- 内线集合：`e = 1,...,E`，每条内线携带端点 `(u[e], v[e])`、动量 `Q[e] = \sum_l c[e,l] q_l + P_e`、模长 `\xi_e = |Q[e]|`、场参数 `\nu_e`。
- 外线（Boundary）：`B \to v` 表示外腿连接到顶点 `v`，携带动量 `k_{ext}`。
- `loopExternalMomenta={p_i}` 由用户显式给出，以下统一简称为 `kL` 列表。它决定 loop Gram、ISP 与 momentum-IBP；符号名称不携带角色。第 `i` 项进入内部 `qk[*,i]`、`kk[i,j]`，公开缺省坐标是 `ssij=Sqrt[sp[kLi,kLj]]`。
- `independentExternalMomenta={P_e}` 也由用户显式给出，以下统一简称为 `kE` 列表。它只为实际无圈动量模长生成 `sE1,sE2,...`，坐标/Jacobian 内部槽为 `externalLegSquaredCoordinate[e]`。整体反号模长等价，但和/差组合不合并；不主动生成外腿间点积。
- `kL` 与 `kE` 在各自列表中分别从 1 编号，互不共享编号空间；`kL1/kE1` 是角色简称，不要求用户修改原始符号名。
- 外部能量按顶点 e 指数输入：若能量由上述动量张成并应复用关系，写成对应根号坐标的函数；否则作为独立 `ke[i]` 标量参数。不要默认把同一顶点的外腿模相加。

以下 family 初始化信息必须一开始设定，但不写进 `J` 的指标槽：

- 每条线的 `massType`、`bbType`、`skType`、`thetaConvention` 和可选 `packType`。
- 圈动量基 `loopMomenta`、显式 `loopExternalMomenta`、显式 `independentExternalMomenta` 和 `ibpMode`。旧字段只作别名；与两类动量都无关的独立标量参数用 `ke[i]`。
- ISP 列表 `ispData`。若传播子不足以覆盖全部独立标量积，必须显式给出 ISP。
- 零点规则 `a0Rules/b0Rules/bS0Rules` 与缩并 prefactor 规则。
- seed 幂次范围和测试范围。范围控制枚举，不属于积分指标本身。

这些配置一开始设定并不麻烦，且能避免后续代码从指标形状反推物理类型。`J` 的职责只是不带歧义地承载动态指标。

016 的根号坐标求导只包裹旧平方不变量原子层。对 $x_{ij}=\operatorname{sp}(k_i,k_j)$ 与 $s_{ij}^{\rm root}=\sqrt{x_{ij}}$，实现固定使用
$$
\frac{\partial}{\partial s_{ij}^{\rm root}}
=2s_{ij}^{\rm root}\frac{\partial}{\partial x_{ij}}.
$$
因此 external-vector derivative decomposition、传播子/building-block/ISP 导数和 canonical pipeline 仍只有一份。显式旧 `sp[ki,kj]->sij` 规则保持单位 Jacobian；根号正规化不使用 `PowerExpand`。

强制 seed pipeline：
1. 先确定 sector（哪些线完整、哪些线缩并）和生成元类型（time 或 momentum）。
2. 枚举连续指标 seed 后，必须枚举该 sector 中离散 `n=0/1` 状态；不能只保留符号 `n` 再把 EOM 推迟到后端。
3. 生成元作用后若出现 Hankel 二阶导数态 `n=2`，立即在 seed 层应用 EOM 递推，递归化回 `n=0/1`。
4. massless 线始终走双 theta 合并主线，输出 pack 必须保持 `{b_e,n_{e,1},n_{e,2}}` 三槽并在统一 relation 层应用 quotient，不拆成两个 theta 分支。
5. 任何含 `n=2`、未知 pack 或未处理 theta 边界项的表达式都不能进入 batch、linear-system 或 Kira exporter。

积分的人读记号：
```
J[\{a_v\}, \{linePacks_e\}, \{n_{isp}\}]
```

三个槽位：
- `\{a_v\}`：时间幂次 `(-\tau_v)^{a_v}`，写在分子
- `\{linePacks_e\}`：逐条内线的指标包，结构由线的状态决定
- `\{n_{isp}\}`：ISP 坐标的整数幂次，定义零点固定为 `0`；正值为 numerator，用户显式负值为该坐标的额外 denominator；没有 ISP 时为 `{}`

### 线的两种状态

| 状态 | pack 结构 | 含义 |
|------|----------|------|
| cycle massive 完整线 | `{b_e,n_{e,1},n_{e,2}}` | full momentum-IBP 中的连续动量幂与端点态 |
| cycle massless full/cross | `{b_e,n_{e,1},n_{e,2}}` / `{b_e,0,0}` | 双端点 quotient / 无 theta固定态 |
| cycle 缩并线 | `{bS_e}` | root loop space 中的 contact line |
| fixed massive 完整线 | `{"F",n_{e,1},n_{e,2}}` | bridge 或 timeOnly line；幂次在 sector prefactor |
| fixed massless full/cross/shrunk | `{"F",n_{e,1},n_{e,2}}` / `{"F",0,0}` / `{"F"}` | 无 `b/bS`，root line 槽永久保留 |

缩并线来自时间 IBP 中 Heaviside 函数的 delta 缩并。所有 sector 使用同一个 Head `J`。root topology 决定圈数、routing 与 cycle/bridge schema；sector 只改端点代表、full/shrunk 状态、零点和对称性。

缩并时指标移位分解为整数部分（进入指标）和非整数部分（进入零点），详见 plan §2.3 和 tech note §5：
- **h 模式**：幂次 $-(2\nu+1)$，整数 $-1$ 进入指标，$-2\nu$ 进入零点。prefactor $= \frac{4i}{\pi} e^{\pi \text{Im}[\nu]}$。
- **H 模式**：幂次 $-1$（纯整数），全部进入指标，零点无移位。prefactor $= \frac{4i}{\pi} e^{\pi \text{Im}[\nu]}$（与 h 模式相同，来自 cross-order Wronskian $W[H_\nu^{(1)}, H_{\nu^*}^{(2)}] = -e^{\pi \text{Im}[\nu]} \frac{4i}{\pi z}$）。
- **无质量**：无 Hankel 缩并机制。prefactor $= 1$。

### Building Block 类型

每条完整线有一个 building block 类型参数 `bbType_e`，展开为 $\{c_1, c_2, \text{sp}\}$（EOM 递推系数和缩并幂次）：
- `"h"` → `{2ν+1, 1, -(2ν+1)}`
- `"H"` → 裸 Hankel矩阵 EOM `H2=-H0-H1/x+ν²H0/x²`，shrink power `-1`
- `{c1, c2, sp}`：自定义

### 指标零点

指标 $a_v$ 和 $b_e$ 均有零点 $a0_v$ 和 $b0_e$，物理幂次 = 指标 + 零点：
- $a$（正幂次）：$(-\tau_v)^{a_v + a0_v}$
- $b$（分母幂次）：$q_e^{-(b_e + b0_e)}$

零点缺省值（h 模式）：$a0_v = 2\nu_{\text{ref}}$, $b0_e = -2\nu_e$。H 模式缺省均为 0。

## 2. 脚本级配置变量

以下在脚本顶部定义，不写进积分指标：

- 时空维数 `dim`（缺省为符号 `dim`）
- 早时 `i\epsilon` 处方与晚时边界收敛条件
- 传播子 normalization、整体耦合常数、对称因子
- Theta 策略：参考资料也讨论单 theta 路线；本 package 固定使用双 theta 合并，不提供路线开关
- PQ 系数（缺省由 h 函数 ODE 给出）
- 数值替换规则 `repN`（缺省空集）
- 种子撒点范围 `SeedRange`（缺省 `{-3, 3}`）
- 后端排序权重

## 3. 传播子类型与指标包

### 3.1 四种传播子

in-in formalism 中，顶点 ± 标记决定传播子类型：

| 类型 | 两端点标记 | Heaviside 结构 | 指数核 |
|------|-----------|---------------|--------|
| `G^{++}` | `(+,+)` | `\theta(\tau_u - \tau_v) + \theta(\tau_v - \tau_u)` | `e^{i q_e(\tau_u - \tau_v)}` |
| `G^{--}` | `(-,-)` | `\theta(\tau_u - \tau_v) + \theta(\tau_v - \tau_u)` | `e^{-i q_e(\tau_u - \tau_v)}` |
| `G^{+-}` | `(+,-)` | 无（两分支独立） | `e^{i q_e \tau_u} e^{-i q_e \tau_v}` |
| `G^{-+}` | `(-,+)` | 无 | `e^{-i q_e \tau_u} e^{i q_e \tau_v}` |

`G^{++}` 和 `G^{--}` 含有两个互斥 time-ordering 的 Heaviside 和，因此有离散分支指标。`G^{+-}` 和 `G^{-+}` 的两端点属于不同 SK 分支，无 time-ordering 限制，Heaviside 结构为空。

### 3.2 指标包结构

| 传播子类型 | massive（`\nu_e` 非半奇数） | massless（`\nu_e` 半奇数） |
|-----------|---------------------------|---------------------------|
| `G^{++}, G^{--}` | `{b_e, n_{e,1}, n_{e,2}}`，`n_{e,a} \in \{0,1\}` | `{b_e, n_e}`，`n_e \in \{0,1\}` |
| `G^{+-}, G^{-+}` | `{b_e, n_{e,1}, n_{e,2}}`（无 Heaviside 边界项） | `{b_e}`（无离散态） |

其中 `b_e` 是动量幂次（分母 `\xi_e^{b_e}`），`n_{e,a}` 是 Hankel building block 端点指标（massive）或端点导数压缩态（massless）。

### 3.3 G^{+-}/G^{-+} 型 massless 的简化

`G^{+-}` 型 massless 传播子的指数核 `e^{i q_e \tau_u - i q_e \tau_v}` 不含 Heaviside 函数，因此：

- 对 `\tau_u` 或 `\tau_v` 求导（时间 IBP）只产生 `q_e` 因子和 `\tau` 幂次变化，不产生 delta 函数边界项。
- 对 building block 的端点导数不产生对称/反对称两种独立构型——因为没有 Heaviside 拆分，求导结果直接是 `\tau` 无关的系数乘以原函数。

因此在指标层面，`G^{+-}/G^{-+}` 型 massless 线不需要离散态指标 `n_e`，指标包退化为纯 `{b_e}`。这是相对 `G^{++}/G^{--}` 型 massless 线（需要 `n_e \in \{0,1\}`）的关键简化。

014 起沿用 `masslessCross -> {b_e}`，018 保持该表示。momentum IBP 同时包含传播子幂次和无 theta 指数核的 q 导数；time IBP 中无 theta 边界项，端点相位导数按 SK 符号给出 `+ i q_e` 或 `- i q_e`，指标上为 `b_e -> b_e-1`。该路线已有 `bubbleMasslessCrossNoTheta` 小检查。

### 3.4 G^{+-}/G^{-+} 型 massive 的处理

Massive 线的 Hankel building block `h[\nu, n, q_e \tau]` 在每个端点导数下分别产生 `n_{e,a} \to n_{e,a}+1` 的递推。对 `G^{+-}/G^{-+}` 型，由于无 Heaviside 结构，time IBP 不产生 theta 边界缩并项；但两端 Hankel building block 仍是独立对象，不能像 massless 指数核那样压缩成单个 `n_e`。

- 指标包仍采用 `{b_e,n_{e,1},n_{e,2}}`
- momentum/time building-block 导数项与 `G^{++}/G^{--}` 型 massive 线相同
- EOM 递推与 `G^{++}/G^{--}` 型相同，种子层递归消去所有 `n>=2`
- 唯一区别是没有 theta 导数产生的 shrink-sector 边界项

当前主线已把这类线显式分派为 `massiveCross`，但指标包仍为 `{b_e,n_{e,1},n_{e,2}}`。它已接入离散态枚举、momentum/time building-block seed、EOM canonical 和 linear-system/Kira 前置门禁；theta boundary shrink 只作用于 `massiveFull`。

## 4. 二阶标准型与 H/h presets

### 4.1 $P,Q$ convention

所有二维特殊函数空间先写成

$$
f''+P(x)f'+Q(x)f=0,
$$

其中 `P` 固定表示一阶导系数，`Q` 固定表示零阶系数。导数基底
$\mathbf Y=(f,f')^T$ 满足

$$
\mathbf Y'=A_0\mathbf Y,
\qquad
A_0=\begin{pmatrix}0&1\\-Q&-P\end{pmatrix}.
$$

因此更高导数消元时，一阶导态乘 `-P`，零阶态乘 `-Q`。旧文档中对调 `P/Q` 的命名已经废止。

### 4.2 H/h presets

011 的缺省 massive 模式是 h，并直接以 h 导数基底为初始空间：

$$
P_h=(2\nu+1)/x,
\qquad Q_h=1,
\qquad T_h=I_2,
\qquad W_h=-e^{\pi\operatorname{Im}\nu}\frac{4i}{\pi}x^{-2\nu-1}.
$$

因此缺省编译结果满足 $W_T=W_h$。H preset 以裸 Hankel 导数基底为初始空间：

$$
P_H=1/x,
\qquad Q_H=1-\nu^2/x^2,
\qquad
T_H=I_2,
\qquad W_H=-e^{\pi\operatorname{Im}\nu}\frac{4i}{\pi x}.
$$

若用户选择从 H 基底经非平凡 $T$ 构造 h，等价变换为：

$$
T_{H\to h}=x^{-\nu}
\begin{pmatrix}1&0\\-\nu/x&1\end{pmatrix}.
$$

011 已把两种 preset 和一般 $T$ 都接入同一编译器；非平凡 H 到 h 变换用于等价性检查，不是缺省 h 的初始化路径。

## 5. `P,Q,T,W` 编译层

### 5.1 输入与权威派生量

每条 massive line 输入 `P,Q,T,W`；`T` 缺省为单位矩阵。`W` 是原始导数基底带完整归一化的 Wronskian。初始化统一生成

$$
A_T=T'T^{-1}+TA_0T^{-1},
\qquad
W_T=\det(T)W.
$$

显式 `WT` 只允许作为一致性校验输入，不能覆盖 $\det(T)W$。编译器同时验证
$W'/W=-P$ 与 $W_T'/W_T=\operatorname{tr}A_T$。

### 5.2 编译结果

`compileFunctionSystem` 把 $A_T$ 编译成 `derivativeTerms`，把 $W_T$ 编译成 `shrinkTerms`，并缓存

```mathematica
"compiledFunctionSystem" -> <|
  "A0" -> ..., "AT" -> ...,
  "W" -> ..., "WT" -> ...,
  "derivativeTerms" -> ...,
  "shrinkTerms" -> ...
|>
```

$T$ 必须对两个独立解相同且可逆；$A_T$ 和 $W_T$ 必须能有限分解为参数系数与 $x=-\xi\tau$ 幂，从而映射到目标状态、整数指标移位和 zero-point 移位。无法分解时初始化失败。

### 5.3 IBP 消费边界

time/momentum IBP 只调用 `derivativeTerms`，theta shrink 只调用 `shrinkTerms/WT`。`P,Q,T,W` 不在 seed 层重算；Wronskian 方向固定后，SK/端点符号由 shrink 逻辑另行乘入。这样 h/H 和更一般的二维函数空间都走同一条编译后路径。

该编译层已在 011 实现。旧 `bbType`/`eomCoefficients` 输入在初始化时转换成同一编译数据；IBP 层不再含裸 H 二次 pole或 h 递推的专用分支。

## 6. massless 双 theta 与有方向单 `n`

参考资料还讨论过纯 massless 的单 theta 路线；本 package 只采用双 theta 合并，后文不再展开另一条路线。

### 6.1 有序端点定义

对一条 `masslessFull` 线，`lineData["endpoints"]={u,v}` 是有序数据。第一端点 `u` 是单 `n=1` 的参考方向。令 `Delta=tau[u]-tau[v]`，并对 `++/--` 分别取 `sigma=+1/-1`：

~~~text
M0 = theta[Delta] exp[-i sigma q Delta]
   + theta[-Delta] exp[ i sigma q Delta]

M1 = -theta[Delta] exp[-i sigma q Delta]
   +  theta[-Delta] exp[ i sigma q Delta]
~~~

因此 `n=0` 对应 `M0`，`n=1` 对应 `M1`。交换端点 `{u,v}->{v,u}` 时 `M0` 不变、`M1` 变号。该方向保存在 line metadata 的 `masslessN1ReferenceEndpoint`、`masslessN1OppositeEndpoint`，并复制到 sector metadata；不能只从缩并后的 coincident endpoints 重新推断。

### 6.2 二阶导数与双端点 quotient representative

对每个指数分支 `E=exp[+- i q(tau[u]-tau[v])]`：

~~~text
d_u E = -d_v E
d_u^2 E = d_v^2 E = -q^2 E
d_u d_v E = +q^2 E
~~~

若为了推导临时写双端点标签，则

~~~text
{10} = -{01}
{20} = {02} = -q^2 {00}
{11} = +q^2 {00}
~~~

`{20}` 与 `{11}` 的符号不同，所以不能把它们都压成一个没有方向信息的 “massless n=2”。018 的公开 `J` 保持双端点三槽，但无量纲 quotient 只以 `{00,10}` 为 canonical representatives；每次端点导数的 `+-i sigma q` 由算符层承载。cycle line 把 `q` 吸收到 `b->b-1`，fixed/独立外动量 line 显式乘模长参数，所以两次作用仍分别恢复 `-q^2` 与 `+q^2`，不经过临时 `n=2`。

`DSSeeds` 只枚举 `{00,10}` 两个 source representatives，不生成代数等价的 `{01,11}`。输出表达式若由导数临时产生后两态，必须立即按 `n2->0` 连同完整符号和动量因子链 canonical；不得把四态全部生成后交给 linear equation 去重。

### 6.3 time-IBP 与 theta boundary

完整 kernel 满足

~~~text
d_u M[n] =  i sigma q M[1-n] - 2 n delta[tau[u]-tau[v]]
d_v M[n] = -i sigma q M[1-n] + 2 n delta[tau[u]-tau[v]]
~~~

所以 regular 部分的指标变化为

~~~text
first endpoint : canonical `{b,n,0} -> {b-1,1-n,0}`, coefficient `+i sigma`
second endpoint: canonical `{b,n,0} -> {b-1,1-n,0}`, coefficient `-i sigma`
~~~

当且仅当 `n=1` 时，theta 导数产生 massless contact difference。第一端点系数为 `-2`，第二端点为 `+2`；shrunk pack 为 `{bS}` 且整数关系 `bS=b`。massless delta 不带额外 `1/(-tau)`，所以 merged `a` 不移位；这不同于 massive Wronskian shrink 的 `bS=b+1`、`aMerged=a_u+a_v-1`。

若其它缩并已使一条 `masslessFull` 线的两个原端点落在同一 active vertex，则共同时间导数必须同时作用两个端点：regular 项和 theta-delta 的 `-2/+2` 项分别相消，反对称 `n=1` 在等时点为零，不能用 `FirstPosition` 只取一端。对 top 方程中产生的 sub-sector 项，也必须根据该输出 `J` 的单元素 shrunk packs 重建目标 sector 代表顶点映射后再做此 canonical，不能沿用 source topology。

### 6.4 momentum-IBP

massless 指数核也依赖 `q=|Q|`，不能只微分分母。其径向导数为

~~~text
d_q M[n] = i sigma (tau[u]-tau[v]) M[1-n].
~~~

因此 `d/dq_l . v` 除传播子幂次项外，还产生

~~~text
c[e,l] (v.Q[e]/q[e]) i sigma (tau[u]-tau[v]) M[1-n],
~~~

在指标语言中表现为 `b->b+1`、`n->1-n`、分别乘 `tau[u]` 与 `tau[v]`，随后把 `v.Q[e]` 吸收到 `z/ISP` 指标。011 已为 `masslessFull` 和无 theta 的 `masslessCross` 都接入该项。

### 6.5 同顶点对多条 full lines 的共同 theta

同一当前代表顶点对之间的 `massiveFull`/`masslessFull` 线共享一个时间差 $\Delta$。把每条线写成

$$G_e=\theta(\Delta)A_e+\theta(-\Delta)B_e,$$

则整个 bundle 按 almost-everywhere、因而按 distribution 意义满足

$$
\prod_eG_e=\theta(\Delta)\prod_eA_e+\theta(-\Delta)\prod_eB_e.
$$

time derivative 只产生一个共同 delta，边界系数为 $\prod_eA_e-\prod_eB_e$。package 不改变逐线 `J` pack；为把 coincidence 结果写回同一积分族，定义

$$J_e=\frac{A_e+B_e}{2},\qquad D_e=A_e-B_e.$$

精确展开为

$$
\prod_eA_e-\prod_eB_e=
\sum_{\substack{\varnothing\ne S\subseteq B\\ |S|\ {m odd}}}
2^{1-|S|}\prod_{e\in S}D_e\prod_{e\notin S}J_e.
$$

每个 $D_e$ 使用该线已有的 massive Wronskian 或 massless antisymmetric contact 规则；未选择的线保留 full pack，但端点已 coincident，并立即应用 massless odd-zero 与 massive endpoint-swap canonical。两线 bundle 只有 single contacts；三线 bundle 还含系数 $1/4$ 的 triple contact。后者仍来自一个共同 delta，不是 $\delta^3$。

一次 contact 事件选择一个非空奇数子集并只合并两个代表类一次。后续只能在仍不同的代表类之间发生新事件；因此事件之间形成 forest，但一个事件内部可以同时标记多条平行线。`shrinkSectorSubsets` 按此状态图做 BFS，不再枚举全幂集。

单传播子的对称 coincidence 取 $\theta(0)=1/2$。该点值不能单独定义 $\delta\theta^m$。若希望保留逐传播子 theta，可统一取 $H_\epsilon'=\rho_\epsilon$（例如 Gaussian mollifier）；则第 $i$ 条线的 boundary 定义为

$$
\delta(\Delta)\int_0^1 dh\,D_i\prod_{j\ne i}(B_j+hD_j),
$$

所有线求和后严格回到上式。相同正则化还给出 $\rho_\epsilon H_\epsilon^m\to\delta/(m+1)$，而不是把 $H(0)^m=2^{-m}$ 直接乘到 delta 上。

当前 018 逐线保留 `{b_e,n_{e,1},n_{e,2}}` 三槽并在 relation 层应用 quotient，boundary 使用上述共同-theta contact；`masslessBundleCandidates` 只是 massless 子集的 metadata 摘要，不是另一个积分 Head。

对 massive 线，$D_e$ 不能作为未展开的 Wronskian 停留在 canonical 输出中。line-local `compileFunctionSystem` 构造 `WT=Det[T]W`，`compileShrinkTerms` 将每个 `-WT` Laurent monomial 写成 coefficient、整数 `bShift=s` 和共同 `zeroPointShift=z`。一个 odd subset 的所有选中线由 `shrinkLinesIntegral` 同时处理：顶点只合并一次，但 `aMerged` 减去所有 `s` 之和；每条 selected pack 独立变为 `{b+s}`。`sectorZeroPointRules` 使用同一 compiled data，使 `a0Merged` 减去所有 `z` 之和，并逐线设置 `bS0=b0+z`。h preset 为 `(s,z)=(1,2 nu)`，H preset 为 `(1,0)`，massless contact 为 `(0,0)`。

共同-theta 与统一 Gaussian mollifier 对总 boundary 等价；逐线 Gaussian 分配本身依赖共同 regulator，只有对所有线求和后才是 canonical 物理量。因此 012 选择共同-theta实现，不提供会改变结果的逐线开关。任何只使用 `theta(0)=1/2`、丢掉中心矩高阶项或对同一 bundle 使用不同 regulator 的实现都不等价。

## 7. 幂次范围

每个 case 独立配置：
```
a_v \in [a_v^{target} - rTauDown, a_v^{target} + rTauUp]
b_e \in [b_e^{target} - rLineDown, b_e^{target} + rLineUp]
```

IBP 产生的移位：
- 时间 IBP：`a_v \to a_v - 1`
- 动量 IBP 微分指数相位：`a_v \to a_v + 1`
- 动量 IBP 对 `q_e` 链式求导：`b_e \pm 2`
- massless 双端点压缩：`b_e \to b_e - 2` 后回到 `n_e = 0`

保守默认：`rTauDown = 1, rTauUp = 1, rLineDown = 2, rLineUp = 2`。

子拓扑单独设 range，不假设由 top sector 某个 `b_e = 0` 自动表示。

014 的 `generatorSeedRanges` 是统一范围之上的稀疏覆盖层。匹配键为 `sectorKey` 与生成元 label；record 中只出现被覆盖的连续变量，其余变量沿用 `seedRanges`。生成 batch 时必须记录最终变量顺序、每个变量的 value list、配置来源和 rule/equation count，既支持旧 family，也能精确复现 reference code 中不同 time/momentum generator 的非矩形范围。


### 用户对称性规则的边界

`sp` 的 `Orderless` 只实现标量积交换性 `sp[p,q]=sp[q,p]`，不代表一般 Feynman 图或积分族对称性。积分族对称性依赖质量、外腿能量和动量等物理条件，package 不自动猜测一般图 automorphism。

018 case 可选输入 `symmetryRules`。`repSymmetry0[topo_]` 只返回用户原始规则；`effectiveSymmetryRules0[topo_]` 将其与自动 tadpole rules 去重合并，`symmetry[expr_,topo_]` 对并集只执行一次 `/.`。用户负责先在每个等价类中选定唯一 canonical representative，并只写从非代表到代表的有序替换；双向规则会使多阶段 canonicalization 在等价对象间来回翻转。自动规则只识别 `originalEndpoints` 已相同的 self-loop：massive full 规范化 `{1,0}->{0,1}`，massless full 的 `n=1` 归零；odd ISP 还要求该 loop momentum 不出现在其它传播子中。cross propagator 与 shrink 后才 coincident 的普通线均不匹配。自动把未定向等价关系按缺省复杂度与稳定字典序定向的 helper 只列为低优先级易用性优化。
## 8. IBP 生成要点

IBP seed 包括：
- 时间 IBP：`d/d\tau_v`（`V` 个算子），处理 Heaviside delta 塌缩
- 圈动量 IBP：`q_l^\mu \partial/\partial q_l^\mu`（`L` 个标度算子），多圈时添加 `q_l^\mu \partial/\partial q_m^\mu`
- 前端关系：massless full/cross endpoint canonical；`symmetry` 单次应用自动 tadpole 与用户规则并集，apart/scaleless 仍待实现

生成流程：
1. 读取 family 配置，并验证 ISP/零点/seedRanges 及按工作流选取的 numericRules 已定义
2. 构造 sector 指标盒子
3. 枚举连续种子（含撒点范围控制）
4. 对每个连续种子枚举离散 source representatives：massive 为四态，masslessFull 为 `n2->0` 的 `00/10`
5. 分别作用 time-IBP 与 momentum-IBP 生成元
6. 立即应用 EOM，递归消去所有 `n>=2`
7. 应用 massless 双端点 quotient/canonical 关系，保持 `{b_e,n_{e,1},n_{e,2}}` 三槽包
8. 检查越界与 forbidden `n` → 标记边界 / 扩盒 / 报告
9. 生成 canonical seed summary
10. seed 先保存为 MMA 表达式；只有在 1--9 通过、并完成工作流所需的系数域选择后，才允许进入线性系统编号与 Kira 导出。DE 工作流不得数值化 derivative variables

### 8.0.1 模板层与连续撒点层

`DSSeeds` 的稳定模板字段命名为 `allSeeds`。每一项保存 generator/source/sector、已代入的离散规则以及仍含 general 连续指标的 equation；模板列表在公开返回前使用 `Flatten[...,Infinity]` 统一成一维。massive 的端点 `n_i` 完整枚举 `0,1`；masslessFull 先按已证明的 quotient 只枚举 `00/10`，并另存 raw 四态/代表态计数。`allSeeds` 不允许残留符号 `n_i`、forbidden `n` 或非 canonical 的 massless `n2=1`。

模板完整性按“状态记录”而不是“非零方程”定义：EOM/canonical 后的精确零 equation 仍保存其 generator、sector、离散规则、ordinal、逐模板 hash 与集合 hash，确保二元态覆盖可审计。`DSGenerateIBP` 接受密封记录中的精确零，但拒绝缺失 equation 或非零且不含 `J` 的输入。完整列表、合法密封子集和 raw expression 分别标为 sealed complete、sealed subset 与 unsealed raw；后两者可以形成 partial linearData，但不能获得 formal reduction capability。

`DSGenerateIBP` 只展开连续指标，不重新枚举离散状态。两参数范围 `{min,max}` 是所有 root 连续指标共享的最终关系包络；任意多个 `{index,min,max}` 是逐 root 指标精细包络，必须 exact cover 模板中真实出现的全部 root 连续指标。门禁返回 `unknownIndices`、`missingIndices`、`duplicateIndices`、`invalidRanges` 和 `discreteIndicesInRangeSpec`，而不是静默使用缺省值。每个点先通过 sector-aware parity，再代入 continuous rules，应用用户已经定向的 symmetry，并重复应用同一精确 numeric rules 后逐项 `Together/Cancel`；撒点后的 coefficient variables 是全数值后端残留诊断。`DSLinear` 以 coefficient rules、常数项和非线性项组成数学键去重，source metadata 不阻止相同 IBP 合并，同时保存 source/effective/duplicate 三个计数。

`DSMetaSeedRange` 先按用户给定的 seeds 外层结构分组：flat 列表整体为一组，nested 列表的每个顶层元素为一组并在组内完全 `Flatten`。每组从 `J[...]` 全部参数的统一扁平数据中用 `Variables` 发现真实连续指标，并保存每个指标的整数 shift 集合。对目标包络 `[L,U]` 和组内 shift 集合 $\Delta$，`DSGenerateIBP` 取全部逆像的交集 `[L-Min[Delta],U-Max[Delta]]`；这会缩小 seed 点域，并保证每个生成结果仍在目标包络内。默认 `DSSeeds` 分组通常对应单个生成元，但用户可提供任意分组，所以运行时只打印“编号 i / Group i”及可选来源，不把编号称为 IBP 算符。

若某组反推得到 `min>max`，说明目标包络窄于该组 shift 跨度，不存在能使全部移位后积分仍留在包络内的 seed 点。该组 IBP 撒点为空，程序逐编号 warning，保存 `emptySeedRangeGroups`，并把相应 complete IBP capability 设为 false；不静默丢组。后端闭包仍由 `DSKiraPlan` 检查 derivative targets 是否实际属于当前 `linearData`；范围不足时返回缺失 targets，由用户调整最终关系包络重跑。


### 8.1 sector metadata 与全局积分排序

每个 sector 需要缓存一份轻量 metadata；canonical batch/linearData 使用 `sectorMetadataList` 保存 top 与所有 shrink sub-sector，避免后端读取时重新从拓扑推断指标含义：

- `activeASlots`：缩并后仍活跃的 `a` 槽。缩并线的 delta 会把两个端点的时间积分合并，因此只有代表顶点的 `a` 保持可变，另一个端点在 `J` 中固定为 `0`。
- `lineSlots`：每条线的原始 line id、当前端点、packType、massType/state、第一幂次指标（`b` 或当前代码中的 `bS`）和完整 pack 模板。
- `ispSlots`：ISP 指标和对应定义。
- `masslessBundleCandidates`：同一顶点对上多条 `masslessFull` 线的分组摘要；time boundary 使用更一般的 massive/massless common-theta bundle 分组生成 odd-subset contacts。

`J` 的 `aList` 采用 compact active slots：delta 缩并后只保留仍独立的时间变量，不在 `J` 中保留 inactive 原顶点槽。原始顶点编号、外腿、线端点、original slot 与 compact slot 的对应关系全部保存在 `sectorMetadataList` 中。seed batch 通过 `writeSeedBatchMMA` 保存为 MMA 表达式；任何后端 exporter 都不直接读取 seed batch。

`makeLinearSystemData` / `makeSampledLinearSystemData` 的 `linearData` 是 backend-neutral 中间层，保存 `linearEquations`、`integralList`、`integralRules`、全 sector metadata 和 artifact contract。sealed producer 的 source digest 通过后，`DSLinear` 直接消费 producer 的 canonical/coverage 摘要，不重复全量 symmetry 与 coverage 扫描；raw 输入仍执行 consumer 全扫描。Kira 只是当前提供的一个 serializer；Rational Tracer 或其它线性后端应从这一层对接，不要求 package 记录或管理后端可执行文件路径。

formal `DSKiraPlan` 只接受 `completeSystemQ=True`，并把 active-basis 一阶导数 closure 保存为实际 export 消费的 `preparedLinearData`；pre-reduction 允许不完整系统但不得冒充正式约化。export manifest 的 artifact identity 必须覆盖 linear/equation/map/target/rule/active payload 和实际写出文件 SHA-256，importer 复算内容身份；packageVersion 只作诊断，不能代替内容 digest。

Kira 编号必须对所有 sector 的积分一起建立，不能先按 sector 追加。`DSLinear` 生成的 `integralList` 是唯一顺序来源；`DSKiraPlan`、active-basis preparation、serializer、manifest 和 importer 均逐项消费该列表，不得再按 preferred master、complexity 或 sector 暗中重排。用户需要不同编号时，只能在 backend 边界前调用 `DSReorderIntegrals`，由该函数一次性同步 `integralList`、`integralRules` 和线性方程 ID；旧 `KiraIntegralOrder` 不再属于 exporter。`preferredIntegrals` 只参与候选选择，不改变全局 ID。

用户自选主积分通过 `DSUserMI[linearData,expressions,spec]` 实现。`userMI[i]` 是 `J` 线性空间的坐标 token，不是新的积分 Head。package 对有序候选和 active 子集分别做精确满行秩检查，在候选 support 中选择 pivot `J`，保存 `userMI -> J` 以及 `pivot J -> userMI + spectator J` 的双向映射、round-trip residual 和顺序 digest；只声称这一 support 坐标替换可逆，不声称较小用户 basis 覆盖全局积分表。之后复用既有 active-basis derivative closure、backend IDs、manifest 和 import/DE 数据流。附加 `userMI` 后禁止再次重排；import 的公开 token 是 `userMI[i]`，Kira token 单独保留。

`makeTopologyData` 和 `summarizeCase` 还会返回 `validationReport`。016 在轻量结构检查之外，显式执行图论圈数、incidence-cycle、routing rank、两类动量声明的 exact/over/under 及 ISP 坐标闭合审计；不做大规模 reduction。018 的完整 sealed producer 在生成阶段保存 coverage/canonical 摘要和 source digest；`DSLinear` 的 standard 路线只读取 producer 状态、计数与 digest 字段，不重算全部关系，显式 `AuditLevel->"full"` 或 unsealed/raw consumer 才重跑完整 digest/classifier。只有 `completeSystemQ=True` 才能进入 formal Kira。`numericRules` 缺少某些当前外部变量（缺省 `ssij/sEe` 或用户重定义名）时只给 warning，因为解析 seed 仍可生成。只有不再求这些变量导数的 `LinearSystemMode -> "numeric"` 工作流才要求补齐并在 seed 生成前检查 `numericRulesMissingExternalInvariants`。若 Kira 输出要进入 `DSDE`，所有 active-basis derivative variables 及对应内部平方原子必须保持符号；`DSKiraExport` 会联合审计 seed、linear coefficient 和 serializer 规则的左右端。所有适用离散 `n` 状态恒完整枚举后再做即时 EOM canonical，不存在 sample 离散模式。

## 9. 外腿与传播子统一约定

传播子和外腿统一按 Feynman 规则处理，`k` 直接代入对应表达式：

- 顶点 `v`（标记 `+`）：时间积分核含 `e^{i k_v \tau_v}`，外腿因子为 `u^*_{k_v}(\tau_v)`
- 顶点 `v`（标记 `-`）：时间积分核含 `e^{-i k_v \tau_v}`，外腿因子为 `u_{k_v}(\tau_v)`
- 内线 `e`（`G^{++}` 或 `G^{--}`）：指数核 `e^{i\sigma_e q_e (\tau_{u[e]} - \tau_{v[e]})}`
- 内线 `e`（`G^{+-}`）：`u_{q_e}(\tau_{u[e]}) u^*_{q_e}(\tau_{v[e]})`，即 `e^{i q_e \tau_{u[e]}} e^{-i q_e \tau_{v[e]}}`

IBP 中的 `k_v` 符号始终与 Feynman 规则一致，不需要根据顶点 ± 额外翻转。

## 10. 不可约标量积 (ISP) 与多圈函数族

### 10.1 ISP 定义

对于 $L$ 圈图，若 `loopExternalMomenta` 中有 $K$ 个独立外动量向量，则存在 $L(L+1)/2$ 个独立的圈动量标量积 $q_i \cdot q_j$ 和 $L K$ 个圈-外动量标量积 $q_i \cdot k_j$。其中一部分可由传播子动量 $Q_e$ 的平方 $\xi_e^2 = Q_e^2$ 线性表示，剩余的不可约标量积称为 ISP。

**用户口定义**：用户在 `loopMomenta` 中给出独立圈动量，在 `loopExternalMomenta` 中按顺序显式给出 loop 外动量基，在 `independentExternalMomenta` 中显式给出实际无圈模长。符号名称任意；程序不从 `q+k_1`、`q+alice-bob` 等 routing 的名字或首次出现顺序替用户选基，只用 affine shift-invariant 空间审计声明是否 exact/over/under。标量积统一写成 `sp[p,r]`，参数必须是已声明动量的线性组合；加减号保留精确系数。

内部实现仍把所有 `sp[p,r]` 展开到编号坐标 `qq[i,j]`、`qk[i,j]`、`kk[i,j]` 做线性代数；这些内部记号不作为用户输入 convention。输出端需要区别：圈动量相关对象仍可显示为 `sp[...]`，但 loop 外动量 Gram 不变量缺省按 `loopExternalMomenta` 的位置输出为 `ssij^2`。用户通过 `KinematicRules` 或 `DSRedefineParameters` 重定义坐标；旧 `externalInvariantRules` 只保留兼容语义。

dS 的特殊点是：是否属于“外腿动力学”由是否含圈动量决定，不由该线是不是 boundary propagator 决定。任何不含圈动量、但仍参与 `tau` 积分的 line momentum 都属于无圈动量候选来源。程序把候选平方写到声明向量的形式 Gram 线性空间，仅用于秩与 binding 计算，不向用户输出新的交叉点积；完整 loop Gram 先入基，候选按首次出现顺序只在增加秩时建立 `sEe`。因此 `kE1`、`kE2`、`kE1+kE2` 仍给三个独立模长，而 `2 kE1` 会绑定到 `4 sE1^2`。纯相位标量保存在 `vertexEnergies`；若与任何已声明动量无关，仍用 `ke[i]`。

### 10.2 独立变量微分方程求导边界

012 的微分方程 seed 只处理已经由 topology 输入声明清楚的独立变量，不主动替用户拆分或合并物理能量。规则如下：

- `ke[i]` 等独立顶点能量参数只对 `vertexEnergies` 中的 e 指数相位做标量求导；它不进入动量坐标或 ISP 完备性。
- 实际无圈动量模长 `sEe` 对绑定线执行径向导数：分母幂、massive `AT`/massless phase building block、顶点相位和显式系数全部计入；它仍不产生 loop IBP generator。
- 016 缺省 `ssij` 或用户自定义外不变量名属于 `loopExternalMomenta` 的 Gram 坐标。对它求导时，先在平方原子上把 $\partial/\partial x_a$ 写成外动量矢量导数 $D_{ij}=k_i\cdot\partial/\partial k_j$ 的线性组合，再用用户坐标 Jacobian 对全部 $x_a$ 求和。
- 系数由 $\sum_{ij}c^{(a)}_{ij}D_{ij}x_b=\delta_{ab}$ 解出。完整 $K^2$ 个 $D_{ij}$ 一般存在零空间，所以解不唯一；实现必须返回所选 basis、矩阵、系数、残差、`nullity` 和 `nonUniqueQ`。
- 当前默认 basis 是上三角 `externalVector` generators。若物理问题要求其它切向选择，应通过 operator basis 覆盖，而不是在求导核心中硬编码。
- 每个外动量矢量导数要作用到传播子、massive/massless building block、ISP/numerator，以及那些被写成外不变量函数的顶点能量表达式，例如 `Sqrt[s11]`。
- massive building block 的 external-vector/外不变量导数与 qIBP、tIBP 共享 line-local 最终 `AT -> derivativeTerms`，不能另行假设 `n->n+1`。`WT/shrinkTerms` 只属于 time-IBP 的 theta coincidence，不参与普通动力学量导数。

公开入口为 `ds[expr,sij,contextOrTopo]` 或已注册 context 下的 `ds[expr,sij]`；三参数形式统一接受 `DSInit` context 或 parsed topology。`sij` 必须使用 topology 初始化后的外部名字；内部 `kk[i,j]` 不接受。程序用惰性 token 固定每个 `J`，先由 `D` 产生显式系数导数，再用单积分核心补上指标导数，因此严格满足
$$
\partial_s\sum_r c_r(s)J_r=\sum_r c'_r(s)J_r+\sum_r c_r(s)\partial_sJ_r.
$$
允许常数项和任意 `J` 线性组合，不允许 `J_iJ_j` 或非多项式 `J` 依赖。

初始化先由 `DSKinematics` 给出 graph/routing、显式 `loopExternalMomenta`/`independentExternalMomenta` 声明审计、缺省 `sp[ki,kj]->ssij^2`、无圈模长、从属 binding 及 `selectionTemplate`。用户可通过 `KinematicRules` 重选。任一动量列表或动力学规则欠完备时给出固定顺序的零空间/缺失方向并拒绝初始化；所有下游读取同一 capability gate。过完备 warning 后允许 symbolic IBP，但 `ds/DSDE` 与唯一 `rep2innerform` 被禁用。过完备 loop 原声明保存在 `loopExternalMomenta`，核心闭合改用 `effectiveLoopExternalMomenta`，即 affine shift-invariant 需求的独立基，避免整体 loop shift 方向虚增 `nK`。满秩 exact 坐标先展开每条规则右端、提取真正的原子参数，再按完整 Jacobian 对坐标和从属 binding 求导。

external-vector 对标量积函数的作用按坐标链式法则实现：先抽取表达式中的 `qq/qk/kk` 坐标，再求 `D[expr,coordinate] D_ij(coordinate)`。这保证 `Sqrt[s11]` 等非线性顶点能量得到正确的 $1/(2\sqrt{s_{11}})$，而不是错误的 `Sqrt[D_ij s11]`。

### 10.3 函数族扩展

多圈积分家族需扩展为：

$$J[\{a_v\}; \{\text{pack}_e\}; \{n_{\text{isp}_j}\}]$$

其中：
- $\{a_v\}$：顶点时间幂次
- $\{\text{pack}_e\}$：内线指标包（完整线或缩并线）
- $\{n_{\text{isp}_j}\}$：ISP 坐标幂次；零点固定为 $0$。物理 numerator 区域为 $n_{\text{isp}_j}\geq0$，但接口允许用户显式给负整数，此时表示额外 denominator。

ISP range 是用户枚举边界，不是 package 门禁。`DSGenerateIBP` 的 target-to-seed 逆像对 ISP 使用“反推下界与用户 target 下界取较大者”，因此 package 不会为了覆盖升幂项自行向更负方向扩张；用户显式给出的负下界保持有效。ISP 自身求导在指数为 $0$ 时先精确返回零。

### 10.4 ISP 完备性验证

在生成 IBP 前，必须验证 ISP 集合的完备性：

1. **覆盖性**：所有标量积 $\{q_i \cdot q_j, q_i \cdot k_j\}$ 均可表示为用户给出的 $\{\xi_e^2\}$ 和 $\{\text{ISP}_j\}$ 的线性组合。
2. **独立性**：ISP 可以是 `sp[p,r]` 的线性组合坐标，例如 `sp[l3, k321 + l3]`；这些 ISP 坐标之间应线性无关，并且不应再由传播子平方线性表示。
3. **数目检查**：当前实现要求 `zExprs` 与 ISP 坐标总数等于独立 loop-scalar-products 数目，即 $\#z_e + \#\text{ISP}=N_{\text{sp}}$。这里的计数是用户定义的 `z/ISP` 坐标闭合条件，不是程序自动选择 propagator 子集。
4. **线性动量检查**：含圈动量的 line momentum 与 ISP 的 `sp[p,r]` 参数必须由 `loopMomenta/loopExternalMomenta` 线性张成；无圈 line momentum 使用已声明的 `independentExternalMomenta`。若出现 `q1^2` 这类非线性写法，`validationReport` 返回 `nonLinearLineMomenta` 或 `nonLinearScalarProductArguments`。
5. **可解性检查**：数量闭合后，程序会实际构造小矩阵并尝试生成 `repSP2Z`；若传播子动量退化、重复或无法反解，会在 `validationReport` 中报告 `scalarProductCoordinateSolveFailed`，而不是等到 IBP seed 生成时报错。
6. **数值规则检查**：若拓扑包含独立外动量基，当前报告和模板会列出缺省 `ssij/sEe` 或用户自定义名。symbolic linear/Kira 工作流不把这些 derivative variables 数值化。纯数值 DE/scaling 演示先构造符号微分算符，再让 IBP seed、导数系数和 reduction 共用一个固定精确有理点；该路线从 `DSSeeds[...,ApplyNumericRules->True]` 开始就把外部不变量和顶点能量纳入 `numericRules`，并要求 `seedResidualCoefficientVariables==={}`，撒点后要求 `sampledCoefficientVariables==={}`。缺失规则可以作为 numeric workflow warning，但不阻止 symbolic seed。

其中 $N_{\text{sp}} = L(L+1)/2 + L K$，$K$ 是初始化中 `loopExternalMomenta` 的独立外动量基个数。

本 package 的设计边界是：用户在初始化阶段给出完整的传播子动量和 ISP 定义，程序验证这组输入是否能闭合 IBP 中出现的 loop-scalar-products。对于通常的 dS 图，传播子动量加上用户指定 ISP 后应直接固定 family；多圈时常见情况是传播子平方少于全部标量积，需要 ISP 补齐，而不是程序自动从一堆 overcomplete propagators 中选 basis。若输入中存在重复/退化传播子、ISP 过多或不足、特殊数值外动量导致 rank 下降，当前主线不会自动丢弃传播子、也不会替用户重新选一组独立 propagator basis；validation 会报告 `scalarProductCoordinateCountMismatch`、`insufficientISPData` 或 `scalarProductCoordinateSolveFailed`，由用户修正 family 输入。

### 10.5 IBP 生成元

对于 $L$ 圈图，完备的 IBP 生成元集合为：

$$\mathcal{O}_{l,v} = \frac{\partial}{\partial q_l^\mu} \cdot v^\mu$$

其中 $v^\mu$ 遍历：
- $v = q_m$（$m = 1, \ldots, L$）：$L$ 个对角生成元
- $v = q_m$（$m \neq l$）：$L(L-1)$ 个交叉生成元
- $v = k_j$（$j = 1, \ldots, K$）：$LK$ 个外动量生成元，其中 $K=\#\texttt{loopExternalMomenta}$

总计 $L(L + K)$ 个独立生成元。普通散射记号中若用户正好选择 $K=E_{\rm ext}-1$，才退化为常见的 $L(L+E_{\rm ext}-1)$ 写法；这不是本 package 的输入 convention。

### 10.6 链式法则实现

IBP 生成时，对每个生成元 $\mathcal{O}_{l,v}$：

1. **计算散度项**：$\partial \cdot v = d$（当 $v = q_l$）或 $0$（当 $v = k_j$）
2. **计算链式法则系数**：
   - 对每条线 $e$：$c_{e,l} \frac{v \cdot Q_e}{\xi_e}$
   - 对每个 ISP $j$：$v \cdot \partial_{q_l} \text{ISP}_j$
3. **作用到被积函数**：
   - 传播子部分：径向导数与 $1/\xi_e$ 合并后先给出 $b_e\to b_e+2$，再吸收 $v\cdot Q_e$ 的 $z$/ISP 单项式
   - massive building block：读取最终 $AT$ 的 `derivativeTerms`，由其目标态和 $x$ 幂统一决定 $n/a/b$ 变化
   - ISP 部分：$n_{\text{isp}_j} \to n_{\text{isp}_j} \pm 1$
   - 顶点幂次：$a_v \to a_v \pm 1$

### 10.7 分 Sector 存储

IBP 方程按 sector 分组存储：

```
IBP_sector_<sector_id>/
├── seeds/           # 原始种子
├── equations/       # 生成的 IBP 方程
└── summary.txt      # 统计信息
```

命名规则：
- Top sector: `sector_top`
- 1-line shrink: `sector_e<e_index>`
- 2-line shrink: `sector_e<e1>_e<e2>`

## 11. 标量积变量与 z=ξ2 线性变换

### 11.1 标量积约定

外动量-外动量点积在输出端采用变量名，不保持 `sp[k_i,k_j]` 的矢量点积形式。016 未指定 `KinematicRules` 时按 `loopExternalMomenta` 的位置默认生成 `sp[k_i,k_j] -> ssij^2`；旧 `externalInvariantRules` 仅作为兼容输入。

对 bubble 拓扑，单外动量 $k$ 的平方默认记为 $s_{11}$（或用户自定义名）。圈动量相关点积仍在用户输入端写作 `sp[p,r]`，输出到线性系数时外-外部分已经替换成这些变量名。

### 11.2 z 变量定义

每条内线 $e$ 引入变量
$$z_e = \xi_e^2 = Q_e \cdot Q_e$$

其中 $Q_e$ 为该线的传播子动量。物理幂次用 $z$ 表示为
$$\xi_e^{-(b_e + b0_e)} = z_e^{-(b_e + b0_e)/2}$$

即 $b_e$ 指标每移位 $-2$ 对应 $z_e$ 幂次增加 $1$。

### 11.3 线性变换

标量积 $\{q_l \cdot Q_e, q_l \cdot q_m, q_l \cdot k_j\}$ 与 $z_e$ 之间为线性关系，可互相表达。

**正向变换**（标量积 → z）：
$$z_e = \sum_{l,m} A_{e,lm}\, (q_l \cdot q_m) + \sum_{l,j} B_{e,lj}\, (q_l \cdot k_j) + C_e(\{ss_{ij}^{2}\ \text{或用户自定义坐标表达式}\})$$

其中 $C_e$ 为仅含外部不变量名的常数项。系数 $A, B, C$ 由 $Q_e = \sum_l c_{e,l}\, q_l + P_e$ 的定义直接展开得到。

**逆向变换**（z → 标量积）：
$$(q_l \cdot q_m) = \sum_e D_{lm,e}\, z_e + \sum_j E_{lm,j}\, (q_l \cdot k_j) + F_{lm}(\{ss_{ij}^{2}\ \text{或用户自定义坐标表达式}\})$$

当存在 ISP 时，逆向变换中保留 ISP 项（不试图用 $z_e$ 表示）。

存储为两组替换规则：
```mathematica
repZ2SP    (* z_e → 标量积组合 + 外部不变量 *)
repSP2Z    (* 标量积 → z_e 组合 + ISP + 外部不变量 *)
```

### 11.4 在 IBP 中的使用流程

动量 IBP 生成元 $\mathcal{O}_{l,v} = \partial/\partial q_l^\mu \cdot v^\mu$ 作用后被积函数中出现形如 $q_l \cdot Q_e$ 的标量积。处理步骤：

1. **矢量求导与点积**：对生成元做链式法则，得到含 $q_l \cdot Q_e$ 的表达式。此时 $q_l \cdot Q_e$ 仍以矢量点积形式出现。

2. **替换为 z 变量**：应用 `repSP2Z`，将所有 $q_l \cdot Q_e$ 用 $z_e$ 和 ISP 的线性组合替换。外部不变量（缺省 `ssij^2` 或用户自定义坐标表达式）作为常数保留。

3. **幂次移位**：$z_e^n$ 因子转化为 $b_e$ 指标的移位：
   $$z_e^n \quad \longrightarrow \quad b_e \to b_e - 2n$$
   即 $z_e$ 每出现一次（幂次 $+1$），$b_e$ 降 $2$。

4. **端点指标**：$n_{e,a}$ 的指标由 h-函数导数规则独立决定（见 §4、§5），与 $z_e$ 移位无关。具体地，$q_l \cdot Q_e$ 对 building block 的导数贡献体现在 $n_{e,a}$ 的移位上，而 $\xi_e^2$ 的幂次贡献体现在 $b_e$ 的移位上，两者独立处理。

### 11.5 Bubble 验证

对 bubble 拓扑（单圈、两条内线、一个外动量 $k$）：

**内线动量定义**：
```
Q_1 = q_1
Q_2 = q_1 - k
```

**正向变换**（$z$ 的定义展开）：
```
z_1 = Q_1 · Q_1 = q_12
z_2 = Q_2 · Q_2 = (q_1 - k)2 = q_12 - 2 q_1·k + k_s2
```

**逆向变换**（标量积 → z）：
```
q_12 = z_1
q_1 · k = (z_1 + k_s2 - z_2) / 2
```

**链式法则验证**：生成元 $\mathcal{O} = \partial/\partial q_1^\mu \cdot q_1^\mu$（标度生成元）作用后：
```
q_1 · Q_1 = q_12 = z_1
q_1 · Q_2 = q_1 · (q_1 - k) = q_12 - q_1·k = (z_1 + z_2 - k_s2) / 2
```

与参考代码 `reference/ref_code/codebubble/001 bubble_ibp_sym.m` 中 `ibp[expr_G, 3]` 的结果一致。这确认了 $z$ 变量方案与参考实现等价，且 $b_e$ 移位规则正确。

## 12. 验证原则

本 package 的验证分为轻量结构检查和小规模公式检查。默认脚本只能做轻量结构检查，包括 pack 类型、seed 数、生成元数、ISP 覆盖性、EOM canonical 扫描、极小样本公式对比和导出文件结构检查。默认检查不运行 Kira、Rational Tracer 或其它后端；文件结构检查不能替代 seed 完备性检查。

严禁默认生成整族解析 IBP 方程组并做全局化简。若需要 rank/span 检查，必须先对参数做明确代数赋值，使用小整数或有理数 specialized check；不对大符号矩阵做解析 `MatrixRank`。解析公式只允许逐 seed 或代表项检查。


## 13. 当前实现接口与边界

### 13.1 权威实现与公开工作流

当前唯一权威实现是模块化 `versions/018_dSIBP/`，标准入口为把该目录加入 `$Path` 后调用 `Needs["dSIBP`"]`；正式单文件兼容入口是 `independent-benchmark/package/package_018.1.wl`。工作树只保留 016、017、018，010--015 从 Git 历史追溯。

- `makeTopologyData`：解析用户 case，验证 topology、动量基和 `z/ISP` 坐标，并预缓存 index maps、seed summary 与 sector metadata。
- `makeCanonicalSeedBatch`：生成全 sector 的 qIBP/tIBP canonical seed，自动派生受门禁保护的 massive/masslessFull shrink sectors。
- `classifyCanonicalSeedBatch`：按 sector 和 `qIBP/tIBP` 分类，供保存、检查和分块使用。
- `writeSeedBatchMMA` / `readSeedBatchMMA`：保存和读取解析 seed；seed 不直接交给后端。
- `makeLinearSystemData`：把 canonical seed 转成后端中立线性系统。
- `makeSampledLinearSystemData`：在 linear 层应用小规模数值/撒点规则，不污染解析 seed。
- `reorderLinearSystemIntegrals`：在全 sector 积分表上应用用户排序。
- `makeKiraExportData`：把 linear system 转成基础 Kira 输入文件，不运行 Kira。
- `makeIBPWorkflowData` / `makeIBPReadinessReport`：串联 gate 或只报告分阶段 readiness。

### 13.2 Sector metadata 是拓扑缓存

每个 sector 的 `sectorMetadata` 同时保留原图与 sector-local 信息，避免后端从 `J` 的指标形状重新推断拓扑。主要字段包括：

- `sectorVertexRepresentativeMap`；
- `compactASlots`；
- `vertexIdToOriginalASlot` / `vertexIdToCompactASlot`；
- `lineSlots`；
- `lineIdToSlot` / `bSymbolToLineSlot`；
- `masslessBundleCandidates`；
- `masslessN1ReferenceEndpoint` / `masslessN1OppositeEndpoint`。

delta 缩并后，`J` 只保留仍独立的 compact `aList`；原顶点、代表顶点和指标 slot 的对应关系以 metadata 为准。全 sector 积分排序也必须使用这一缓存，不能把某个 subsector 的全部积分简单追加在其它 sector 之后。

### 13.3 后端中立的 `linearData`

`makeLinearSystemData` 与 `makeSampledLinearSystemData` 返回的 `linearData` 是后端中立中间层，至少保存：

- `linearEquations`：编号后的线性方程；
- `integralList` / `integralRules`：全 sector 统一积分表与映射；
- `sectorMetadataList`：sector 与拓扑信息；
- coefficient、ordering、coverage 和 readiness reports。

这里的“后端中立”表示这些数据不含 Kira 可执行路径，也不依赖 Kira 的工作目录。serializer 的职责是读取 `linearData`，转换为目标后端的语法、编号和文件布局，并完成后端特有的输入校验；它不重新生成 IBP、不重新应用 EOM，也不改变 sector convention。

当前 Kira serializer 可生成 `userSystem/ibp.kira`、`list`、`jobs.yaml`、积分映射和 metadata。默认不生成 `run.sh`，不保存 Kira/Fermat 路径，不运行 reduction。若以后对接 Rational Tracer，需要实现新的 serializer 及其格式检查，但 canonical seed 和 linear-system 主线不需要重写。

### 13.4 当前验证结论与剩余设计项

014 最新独立重检覆盖十个 benchmark family 的 24 组固定 sign/energy 运行和 3018 条方程；ISP 366/366 相等且非零差值 0，H-to-h/direct-h 178/178、bare-H 178/178、compiled `AT/WT/shrinkTerms` 16/16、tree 22/22、general-`ds` 独立 expected 16/16、工程门禁 19/19。文档修正前唯一 contract 失败是 `DSSeeds` 缺省说明；物理关系比较没有非零差值。历史 012 计数只保留为冻结基线的验收记录。

这些检查覆盖约定的顶点符号、可达 sector、离散态和 qIBP/tIBP 生成元，但不是任意拓扑的数学穷尽证明。011/012 时代的 expected、helper、actual adapters 和临时测试工作区已在 2026-07-23 清理；历史计数仅作为当时版本的验收记录，不再对应仓库内可重跑资产。

仍保留的设计项：

1. 将独立 benchmark 扩展到当前 10 个已完成物理 family 之外的新 topology；现有指定 family 已完成固定 sign/energy、全生成元和新增 ISP/general-`ds` 对照。
2. 高圈 seed 的 streaming/chunking 与规模报告。
3. 自动图 automorphism/参数对称性检测，以及 scaleless 等可选前端 canonical；用户输入 `symmetryRules` 与 `symmetry[expr_,topo_]` 的单次应用已经实现。较小的后续项是提供 ordered-symmetry helper，把用户给出的未定向等价关系按缺省复杂度与稳定字典序单向指向代表。
4. Rational Tracer 或其它后端 serializer。

自动运行 reduction 和管理后端安装路径不属于本 package 的职责；018 只导出基础输入，并导入、验证用户在外部生成的完整 reduction 结果。

## 14. 013/014 分层与状态所有权

013 已把 pure time-IBP/tree 物理对象与 loop 三槽对象分派清楚；014 已把“公式核心”和“用户工作流”做标准 package 分层。两版都不复制 theta/EOM 物理实现。014 的状态所有权固定如下：

| 层 | 输入 | 拥有的状态 | 不得做的事 |
|---|---|---|---|
| `Core` | 用户 case | topology、convention、sector、derivative metadata | 生成后端文件 |
| `IBP/Loop` | parsed topology | canonical seed batch | 运行 reduction |
| `IBP/Tree` | tree metadata 或 loop time seed | tree rules、sector DAG | 重新推导 theta/contact |
| `Backends/KiraExport` | `linearData` | Kira 输入和映射 manifest | 修改 canonical seed |
| `Backends/KiraImport` | 完整 Kira 输出 | reduction rules、master order、来源检查 | 猜测缺失映射 |
| `DE` | `ds`、reduction data、master order | DE matrix、basis map、scaling report | 改变 symmetry/parity convention |

014 建立的 `DSInit` 高层入口由 018 沿用，仍是建立当前 family context 的唯一入口。它返回不可变的初始化 Association，并可把 metadata 分文件写入 example 的 `init/`。后续高层命令显式接受该 Association；无参短形式只读取当前已注册 context。这样 notebook 交互方便，同时 batch 脚本仍可完全显式、可复现。

014 迁移期 `LoopCore013.wl` 只作为冻结兼容层。loader 在 `BeginPackage["dSIBP`"]` 中预声明公开符号，再在 `dSIBP`Private`` 加载核心，使未公开 helper 留在 Private，而 `J/sp/ds/...` 等已声明接口保持在 package context。新增模块不得依赖 `Global`` 符号解析。

## 15. 014 初始化文件与相对路径

example 根目录由 `$InputFileName` 优先确定，notebook 中才回退到 `NotebookDirectory[]`。所有 `init/`、`kira/`、`results/` 路径都从该根目录通过 `FileNameJoin` 构造。package 加载本身不得 `SetDirectory`。

初始化 metadata 采用 Wolfram 可直接 `Get` 的 Association，而不是仅供人读的日志：

- `manifest.wl`：版本、输入哈希、状态、文件表；
- `topology.wl`：parsed topology、ISP closure 和 generator count；
- `sectors.wl`：sector metadata、contact reachability 和 pack shape；
- `conventions.wl`：SK、function system、zero point、symmetry/parity 和 variable naming；
- `derivatives.wl`：按 option 生成的外变量和 operator decomposition。

同一初始化目录若已有不同输入哈希，缺省拒绝覆盖；显式覆盖 option 必须在 manifest 中记录。导数 metadata 的缺省是关闭，因为 $K>1$ 时 decomposition 数据可能明显增大。

## 16. 014 Kira importer、DE 与 scaling 的数据契约

Kira importer 不是文本替换快捷函数，而是有来源门禁的数据边界。它至少验证：

1. export manifest、`repJ2kira` 和 `repkira2J` 相互逆且来自当前 `linearData`；
2. Kira job 的目标列表、master 列表和完整 reduction 文件存在；
3. reduction 右端只含映射表可识别的积分和声明的系数变量；
4. master 顺序被显式保存，不能依赖文件遍历顺序；
5. symmetry、parity、zero-point 和 branch metadata 与初始化一致。

importer 返回后端中立的 `reductionData`，核心字段为 `reductionRules`、`masters`、`integralMap`、`coefficientVariables`、`sourceManifest` 和 `validationReport`。DE 层只消费该对象，不读取 Kira 私有目录结构。

serializer 的 coefficient domain 只允许实有理函数。`Sqrt[s11]` 这类实代数生成元可映射成小写 `dsc*`，但虚数单位不得映射成可供 Kira 消费的 `dsii`；`dsii` 只作为碰撞检查的禁止保留名。`coefficientAlgebraicGenerators`、实变量映射和逐积分 phase gauge 必须进入 manifest，importer 再按逆序恢复物理 convention。

`DSDE[reductionData, vars]` 的每一列对应一个固定 master：先算 `ds[master,var]`，再应用 reduction rules，把内部 `kk/ISP` 系数坐标转换为 family 声明的外部不变量，最后按完全相同的 master 顺序抽系数。该外部化必须发生在 residual/master 分解之前，否则同一物理量会以 `s11` 与 `kk[1,1]` 两个原子进入 Euler check。若存在非齐次项或未约化 `J`，结果状态为 `notClosed`，不得仍返回“已完成”矩阵。

pure massive bubble reference 的 vertex-exchange symmetry 只在 `P1=P2` 成立。reference `Vpm=0` 与 package `--` 的能量参数满足 `P_pkg=-P_ref`；闭环例使用 package 变量 `P0=+I k0`，并把 reference basis 映射为 `P1=P2=-P0=-I k0`，变量权重为 `{s11,P0}->{2,1}`。独立 `P1/P2` family 不得加载该 symmetry。真实结果的 active IDs/master order 均为 `1..19`，辅助关系 `20,21` 不得成为 master。

`DSScaleCheck` 以 Euler operator 作用于 master vector，并与 index/zero-point 决定的齐次次数相减。`ScalingRelation->"LoopTopology"` 按 root 圈数和目标 sector 的活动顶点、`a/a0`、full 或 shrunk `b/b0`、二次齐次 ISP 幂以及完整 `sectorPrefactorData` 中的 `N_s` 逐 master 生成次数；非齐次 prefactor 或非齐次 master 组合直接失败。top bubble 与 residual `R1` 仍可使用 reference 专用的 2604.14549 Eq. (51)、(64)。检查对象是 reduction 后的符号矩阵恒等式；数值 probe 只能作为诊断附件。

## 17. Tree `J`、master order 与 loop 映射

017 的唯一公开 Head 形状为：

```mathematica
J[aList, linePacks, ispList]
```

`ibpMode->"timeOnly"` 只说明不生成 momentum IBP；公开对象仍保留 root-ordered `linePacks`，并令 `ispList={}`。massive-only 论文递推与 dlog 公式可在 Private adapter 内临时使用 vertex basis，但用户入口、seed、linearData、master list 和返回诊断都必须映射回三参数 `J`。massless 的两个端点态始终保留在 full 三槽 pack，并由内建关系处理；不得再公开有向单 `n` 或二槽退化表示。

`integralKind` 只按 arity 和 shape 返回 `"Loop"`、`"Tree"` 或 failure。tree 的第 `e` 个 pack 为 `{a_e,n_e1,...,n_ep}`，其长度必须等于初始化记录的 `1+p_e`。这里 `p_e` 只数 massive h 外腿；massless 外腿不产生 binary derivative state。

单顶点 master 顺序严格是 binary lexical order，最后一个 `n` 变化最快。多顶点 top basis 使用 vertex 顺序的 tensor product；lower contact sectors 按 sector DAG 的拓扑序追加，并在结果里保存 `masterSectorOffsets`。任何矩阵输出都必须同时保存该列表，避免“矩阵正确但 basis 顺序丢失”。

Tree time seed 通过显式投影器复用 loop 原子层：

```text
loop J + topology
  -> dtau(vertex)
  -> loop EOM/symmetry/parity/common-theta canonical
  -> select time-family data
  -> map loop indices and sector representatives to tree vertex packs
  -> general-index replacement rule
```

映射前 canonical 的原因是共同 theta、`WT` 和 coincident zero 都依赖完整 line/sector metadata；tree pack 自身没有足够信息重新判断。投影器必须保留来源 sector 和 contact source 标签，使 `G++/G--` 的非齐次项进入 lower block。`G+-/G-+` 没有 theta，投影器若收到 contact 标签应直接报错。

投影系数按完整物理幂次而不是整数槽计算。当前项和参考 seed 分别记为 `s/r`，则时间相位为

```text
(-1)^(Sum[a(s)+a0(s)]-Sum[a(r)+a0(r)])
```

每条线的显式能量因子为

```text
k_e^-((b(s)+b0(s))-(b(r)+b0(r)))
```

缩并线把第一括号替换成 `bS+bS0`。当前 sector 的 `a0` 同时成为 tree vertex 的 `nu0`。这样 h contact 的 `a0Merged=a0u+a0v-2nu` 与 `bS0=b0+2nu` 会自动给出完整 `(-k)^(-2nu-1)`，且 general `b/b0` 在相对归一化中直接相消。

Private vertex basis 不保存 sector key，因此 adapter 中必须始终与 sector tag 成对使用。公开三参数 `J` 的 root-ordered full/shrunk pack pattern 唯一编码 shrink set；显式 `sectorKey` 只用于交叉核验，不能成为第二套可独立修改的身份。

014 的 tagged term 还携带完整的物理幂次审计。每个原始 loop 单项分别记录 target/reference 的整数指标、零点和二者之和，再记录 `deltaLineIntegerPowers`、`deltaLineZeroPointPowers`、`deltaLinePhysicalPowers` 与 `explicitEnergyPowers`；由审计字段重建的系数必须与实际 `projectionCoefficient` 完全一致。若多个来源合并成同一 tree 积分，最终 `coefficient` 是来源系数之和，但 `contributions` 和 `physicalPowerAudits` 保留逐来源数据。三条同顶点对 h 线的 triple contact 因此必须同时出现三个 `-1-2 nu_i` 能量指数，不能把 zero-point shift 只累加到 merged vertex 而漏掉逐线显式系数。

## 18. Tree 迭代与 branch 约定

对一个含 `p` 条 massive h 外腿的 vertex family，定义 binary vector `n` 和同序向量 `f(a)`。采用 2401.00129 的矩阵：

```text
M1 = Sum[(nu_i+1/2) Lambda3_i] + (nu0-p/2-Sum[nu_i]) IdentityMatrix[2^p]
M0 = -I Sum[k_i Lambda2_i] + I k0 IdentityMatrix[2^p]
Aminus[nu0] = -Inverse[M1].M0
Aplus[nu0-1] = -Inverse[Tp].Inverse[M0tilde].Tp.M1
```

`M1` 和 `M0tilde` 都是 diagonal，因此实现应按对角元素构造 inverse，并在分母为零时返回 singular-locus report，不对一般 $2^p$ 矩阵调用符号 `Inverse`。`repIterative0` 表示一次 $a_e\to a_e\pm1$；`repIterative` 根据目标逐步应用，保存步数并设置终止门禁。若该 sector 含 theta/contact source，raw 与 sector-tagged 迭代都必须从 016 direct pure-time seed 构造同一单步关系；旧三槽 loop 投影只作独立交叉验证，不能成为生产递推来源，否则 fixed line 的 notation `sEi` 会错误替代用户显式 `treeEnergy`。

dlog letters 必须有稳定 API 顺序：按 `vertexOrder` 逐顶点输出该顶点 `massiveLegs` 顺序的能量 letters，随后输出 binary master order 的 cut letters，再稳定去重。不能依赖 `Cases[Expand[omega],Log[...]]` 的表达式遍历顺序；`letterMatrices` 的 Association key 顺序与该列表一致。

顶点 `+/-` 只通过初始化后的 signed vertex energy 进入 `k0`，不改变 h EOM、binary order 或 `Lambda` 矩阵。内部传播子的 SK 类型由两个端点 branch 唯一确定，所以同一条线不可能同时被当作 `G++` 和 `G+-`。只有 same-sign full line (`G++/G--`) 可带 theta/contact；mixed-sign line (`G+-/G-+`) 必须走无 theta 的因子化路线。

多顶点 same-sign 情形按论文 Eq. (3.66)--(3.68) 处理：齐次部分仍用同一个 `Aplus/Aminus`，contact remaining term 是已低一层 sector 的 source。约化顺序是 sector DAG 从叶到根；不得用一个只对 top family 的 replacement repeated 无限扫全表达式。

直接 dlog 非对角块必须从 `R^(1)` 构造。实现为每个 `a=0` master 复制 binary state，只令当前求导顶点的 `a=1`，调用该 sector 的 loop `dtau`，删除 same-sector `M1/M0` 项后取得 tagged lower-sector rows。`R^(0)` 通常给 lower `a=-1`，若先迭代到 0 会引入合并顶点能量，不能拿来定义 Eq. (3.68) 的 contact selector。

全局 basis 直接使用各 sector 已经 normalized 的 `J_s=N_s I_s`。`N_s` 是 `J_s` 定义的一部分，不得再拼成 `N_s J_s`。sector 对角 primitive 读取 `D[Log[N_s]]`，非对角 source 使用同一 metadata 的 `N_s/N_t`；`contactMaps` 同时保留 raw rows、转换后系数、sector key 和 vertex id 供审计。

Naive tree DE 是独立的线性求解路径，不是 `repIterative` 的包装。`DSTreeNaiveIBP` 固定用户传入的 tagged master 列表，只从每个 master 的 `a_v=1` loop 代表元生成投影 `dtau==0`；master token 从未知量中删除，其余一步升幂 token 作为未知量一次联立求解。公开结果把每条 rule 序列化成 `{lhs->{sectorKey,J},rhsTerms}`，不暴露内部 token。`formulaRecurrenceUsedQ=False` 是接口审计字段。

求导层不能把完整 loop `ds` 机械投影。顶点相位项确实可由 loop 代表元的 phase derivative 投影；但 massive leg 的 `treeEnergy` 是 tree 外变量，而 loop 适配器中对应动量通常是积分变量。故 `DSTreeNaiveDE` 对每个 endpoint 直接应用 h 的原始动量导数，再把产生的 `a_v+1` 对象交给 naive IBP。对 `{n=0,n=1}` 的两行分别是 `{-J[a+1,1], J[a+1,0]-(2nu+1)J[a,1]/k}`，并乘 `D[k,variable]`。最后对 sector normalization 用乘积法则；这一步是 lower-sector 能量导数能够和直接 dlog 对齐的必要条件。

## 19. 013--018 examples 与验证矩阵

014 的完整闭环 example 固定为 pure massive bubble reference 的 `--` branch，并采用参考代码相同的 even-parity subsystem、exchange symmetry 和 `R2 -> R1`。其流程停在“生成 Kira 输入”供用户外部运行；当完整 fixture 存在时，从 importer 开始继续生成 DE 并检查 Eq. (51)/(64)。

018 将长期 loop examples 收缩为三个职责正交的典型案例，而不是按质量组合和 topology 做笛卡尔积：

- `04_pure_massive_bubble_closed_loop` 保留已知 dlog basis 与既有解析 reference，负责 basis/normalization、Kira 取回、DE 和 scaling 的可对照闭环。
- `06_mix_bubble_tree` 用“一条 massive cycle + 一条 massless cycle + 一条 massless bridge”的最小配置，同时触发 `kL/kE` 两类编号、独立无圈参量、massless 三槽、cycle/fixed schema 和两类 contraction。第二条 massive line 会增加 EOM/function-system 分支但不增加这些状态所有权边界，所以明确不加入。
- `03_single_massive_sunrise` 用三平行边产生两圈，并以单 massive、双 massless 和两个 ISP 覆盖多重图、routing rank 与 ISP closure。圈外 Gram 根号 `ss11` 和两个顶点共用能量 `kE` 是两项 general 参数微分算符变量；顶点交换和两条 massless 平行线交换都进入 `symmetryRules`，后者同时交换 line pack 与成对 ISP 指标。该 example 的职责止于 general seeds/operators，不建立 sampled relation、serializer、DE 或 scaling 产物；它是唯一 sunrise example，避免多个质量变体形成重复维护面。

三者分别回答“结果能否与已知 basis/reference 对齐”“复合 topology 的状态是否跨模块一致”“多圈 ISP 的 general seeds/operators 是否闭合”。它们是公开工作流样板，不把 example 自检当成 source-isolated 独立证明。

其它 loop examples 复用 independent benchmark 的 family 和已固定 branch，不随机选择。tree 至少保留：

- 0-fold massless vertex：检查单 master、Eq. (3.59)--(3.60)；
- 1-fold massive vertex：检查 `Aplus/Aminus` 与 2 个 masters；
- 2-fold massive vertex：检查 4 个 masters、binary order 和 dlog matrix；
- 两顶点同号传播子：检查 contact source 和 block-triangular DE；
- 两顶点混合号传播子：检查无 `WT`、无 contact source。
- 两顶点同号/混合号：固定同序 normalized masters，比较 naive time-IBP/DE 与直接 dlog 的全部顶点、传播子能量矩阵。

013 新增 benchmark 固定两个 pure-time case：两顶点同号 massive 连接，以及三顶点 `{+,+,-}` massive chain。massless 外腿能量与内部传播子能量使用不同符号；只调用 `dtau`，即使输入沿用 loop topology 也不生成 momentum-IBP。每个 case 同时检查手推 time seed、tree 投影、contact source、general iterative rule，以及 iterative reduction 与 seed 解在符号和确定性有理数值上的一致性。

benchmark 的 expected 必须先由论文公式手推；package actual 只能在第二阶段比较。013 只验证新增 pure-time 内容，不重复此前已通过的 old expected。014 已按更新后的任务书全面重建手推与 package-facing 验证；工程 importer 检查使用小型 synthetic fixture，真实闭环另读取用户在 package 外生成并保留来源 manifest 的完整 Kira 结果。

018 的成品 examples 统一位于 `independent-benchmark/package/examples/`。`05_tree_two_vertex_time_ibp` 继续展示统一三参数 `timeOnly` seed、naive/公式 tree DE 同序比较；原 root-coordinate 例按其实际物理内容命名为 `06_mix_bubble_tree`。`coverage_manifest.wl` 必须与 `DSPublicAPI[]` 双向一致，并由正式检查验证每个公开函数至少出现在一个成品 example 中。

## 20. 017 统一消息与进度状态

消息显示和计算状态分离。所有长任务返回包含 `status/stage/issues/progressSummary` 的 Association；前端文字只是这一状态的视图。全局 `DSMessagesOn[]`/`DSMessagesOff[]` 只控制 `Info`、`Progress`、`Warning`，不控制 fatal `Error`。

Notebook 检测到 `$FrontEnd =!= Null` 时，长任务用单个 `Monitor`/`ProgressIndicator` 或 `PrintTemporary[Dynamic[...]]` 显示 `n/m`，不为每个 item 新建 cell。headless 模式按总量选择稀疏 checkpoint：总数小于 10 只报开始和结束，否则最多约 10 个比例里程碑。嵌套任务只显示最外层阶段和当前子阶段名称，避免多个进度条互相覆盖。

`Warning` 和 `Error` 必须有稳定 code。Notebook 视图中 Warning 用橙色，Error 用红色粗体；二者同时调用 Mathematica `Message`，确保 notebook、CLI 和日志均可追踪。错误返回 `$Failed` 或 `status -> "error"`，不可只打印红字后继续返回貌似可用的数据。

## 21. 017 sector schema、fixed coefficient 与 parity transport

本节记录已经实施的 017 设计。016 的 cycle/fixed schema、公开单槽 tree 表示和 public root-shape validator 不作为 017 的兼容实现继续扩展。

### 21.1 唯一三槽与 line pack 所有权

017 的唯一公开积分对象是 `J[aList,linePacks,ispList]`。每个 `linePacks[[e]]` 对应 root topology 的第 `e` 条 line；sector 收缩不删除这个列表位置。full line pack 固定三个槽，shrunk line 已无端点态，允许退为单槽：

| line role/state | massive | massless |
|---|---|---|
| cycle full | `{b,n1,n2}` | `{b,n1,n2}` |
| fixed full | `{"F",n1,n2}` | `{"F",n1,n2}` |
| cycle shrunk | `{bS}` | `{bS}` |
| fixed shrunk | `{"F"}` | `{"F"}` |

字符串 `"F"` 是 fixed power slot 的短 sentinel。省略写法 `{,n1,n2}` 会被 Mathematica 解析为 `{Null,n1,n2}` 并产生 `Syntax::com`；`_` 是 `Blank[]` pattern；`Nothing` 会删除列表元素，三者都不能作为 package 数据。massless 与 massive 共用同一 full pack shape，massless 的两个端点态通过内建额外关系约化，不再压成单个有向 `n`。

fixed/non-loop 的模长幂不进入 `linePacks`，但仍属于 sector-normalized `J` 的定义。它不作为自由指标参与积分编号，而由初始化生成的 `sectorPrefactorData` 结构化保存。最小 schema 为

```mathematica
<|
  "fixedLineIndices" -> {e1,e2,...},
  "parameterKeys" -> {fixedMagnitude[e1],fixedMagnitude[e2],...},
  "parameterList" -> {p1,p2,...},
  "powerList" -> {u1,u2,...},
  "powerParts" -> {<|"integer"->i1,"zeroPoint"->z1|>,...},
  "constantFactor" -> c
|>
```

四个逐线列表使用相同顺序和长度。`parameterKeys` 是不随用户记号变化的内部引用；`parameterList` 是当前输出坐标下的参量或 dependent binding。`DSRedefineParameters` 只更新当前参数列表和变换 provenance，不改变 line/key 顺序。`powerList` 可直接用于取回每条 fixed line 在该 sector 的总幂次，`powerParts` 保留整数与 zero-point 来源供 contact/parity 审计。

唯一 materializer 定义

$$
N_s=c_s\prod_i p_{s,i}^{u_{s,i}},\qquad J_s=N_s I_s,
$$

但初始化 metadata 不缓存已乘开的 `p^u` 表达式。相同裸积分的不同 fixed powers 仍是同一个 master token；差异由其 sector normalization 表示，不能产生不同 Kira token 或 master candidate。

`J` 本身不增加独立 sector 编号槽。root-ordered full/shrunk pack pattern 是 shrunk-line set 的隐式、可逆编码：每一条 root line 永久占据 `linePacks` 中同一位置，包括 fixed line 收缩后的 `{"F"}`；只改变该位置的 full/shrunk shape，绝不删除或重排。程序由此 pattern 派生 canonical `sectorKey`；每个 seed/`linearData` term 显式携带该 key 并与 `J` 重新推断的 key 交叉检查。若裸 `J` 无法唯一匹配，明确失败。不同 contact 顺序得到同一最终 shrunk set 时属于同一 sector并合并贡献；不同 shrink set 即使 `aList` 长度和表达式相同也不能合并。这样不在 `J` 中维护与 pack pattern 重复且可能漂移的第二份 sector id。

### 21.2 compact `aList` 的合并

`aList` 按当前 sector 的 active vertex representative 存储，长度等于代表类数，不等于 root 顶点数。一次 simultaneous contact 对所选 lines 的端点做并查集合并。对 child class $C_r$，

$$
a_r^{\rm child}=\sum_{c\subset C_r}a_c^{\rm parent}-\sum_{e\in S_r}s_e,
\qquad
a_{0,r}^{\rm child}=\sum_{v\in C_r}a_{0,v}^{\rm root}-\sum_{e\in E_r^{\rm shrunk}}z_e.
$$

代表元按 root vertex 顺序稳定排列。平行多线只合并顶点一次，但每条选中线的整数/zero-point shift 各计一次。不同 shrink set 可能得到相同长度甚至相同形式的 `aList`，仍由 root line positions、`sectorKey` 和 `rootVertex -> compactASlot` metadata 区分。例如三顶点中 shrink `e12` 与 shrink `e23` 都有两个 `a` 槽，但 keys、pack positions 和 vertex-slot maps 均不同。不同顺序到达同一最终 shrunk set 则必须给出相同 compact `aList` 和 zero point，并在保留 contribution provenance 后合并。

待 shrink line 的端点若已在同一 representative class，不能再次产生 contact。017 不沿用 016 单线 helper 中对 coincident 端点的 `2 a` 分支，只保留统一的 simultaneous merge 实现。

### 21.3 fixed-line 物理幂次审计

对每个 sector 及 source/target transition 保存：

```text
source/target fixedLineIndices
source/target parameterKeys and current parameterList
source/target powerList and powerParts
compiled integer shrink shift
compiled zero-point shrink shift
materialized Ns/Nt
reconstructed physical exponent difference
```

fixed-line contact 的模长幂只由 sector zero-point convention 分配，不增加独立吸收开关。若 compiled shrink factor 的物理模长幂为 $r_e^{-s_e-z_e}$，source/target sector 的 prefactor exponent 分别为 $B_{s,e}$、$B_{t,e}$，则

$$
c^{\rm norm}_{s\to t}
=\mathcal C_e r_e^{-\left[s_e+z_e-(B_{t,e}-B_{s,e})\right]}.
$$

016 缺省传播 $B_t-B_s=z$，故关系系数保留 $\mathcal C r^{-s}$。用户若通过合法 zero-point 规则改变 $B_s$ 或 $B_t$，上式自动改变 normalized reduction/DE coefficient。metadata 逐 transition 保存 source/target zero point、override provenance、compiled $(s,z)$ 和剩余 exponent $s+z-(B_t-B_s)$，使 `N_s/N_t` 可以完整重建实际系数。不得新增 `fixedShrinkConvention`、`fullContactPower` 或另一份“已吸收整数 shift”状态；额外吸收由用户后续的 master/basis 选择处理。

zero-point convention 不改变 contact 的时间幂：始终有 $a_t=a_u+a_v-s_e$、$a_{0,t}=a_{0,u}+a_{0,v}-z_e$。当前 preset 为 h: $(s,z)=(1,2\nu)$，H: $(1,0)$，massless: $(0,0)$。对 cycle line，h 实际写入 $a_t=a_u+a_v-1$、$a_{0,t}=a_{0,u}+a_{0,v}-2\nu$、$b_S=b+1$、$b_{S0}=b_0+2\nu$；H 写入相同整数 shift，但 $a_{0,t}=a_{0,u}+a_{0,v}$、$b_{S0}=b_0$；massless 的四项均无 shift。fixed line 不含 $b/b_S$ 槽，同一 zero point 进入结构化 sector prefactor。配合缺省 $B_t-B_s=z$，h/H fixed contact 的 normalized 系数都含 $r^{-1}$；h target prefactor 相对 source 吸收 $2\nu$，H target prefactor不变；massless 不产生额外模长幂。h/H 的 $\mathcal C=(4i/\pi)e^{\pi\operatorname{Im}\nu}$，massless 的 Wronskian 型常数为 1，端点的 $-2/+2$ 另计。

massless fixed line 的“无额外模长幂”具体表示 $B_t-B_s=0$，source/target 的结构化 prefactor 相同，故 $N_s/N_t=1$；不是把原有 fixed-line 模长因子从 target normalization 中删除。cycle massless line 则直接保留 $b_S=b$、$b_{S0}=b_0$。两种情形都没有新增幂次吸收。

`shrinkBShift`/`shrinkZeroPointShift` 是 Wronskian 编译结果的一部分，不是普通 basis 美化选项。用户手册应建议保留 preset；override 时必须同时重建 child zero point、$N_s/N_t$ coefficient 和 parity metadata，不能只改某一个表项。额外 normalization 仍由 master/basis 选择完成，不另设吸收参数。

contact 恒等式以完全展开的 integrand 为准。atomic massless lower sector 若通过 `sectorPrefactorData` 已含 `sE^-beta`，结果仍写为 `-2 Jlower`，不能再次外乘相同因子。结构化保存只改变数据所有权和调取方式，不改变 normalized `J` 的物理定义。

对 $J_s=N_sI_s$，若裸积分导数为 $\partial_xI_s=\sum_t c_{st}I_t$，normalized basis 中必须使用

$$
\partial_xJ_s=(\partial_x\log N_s)J_s+
\sum_t c_{st}\frac{N_s}{N_t}J_t.
$$

表达式本身若另有系数 $c(x)$，再应用 `ds[c J_s,x]=D[c,x]J_s+c ds[J_s,x]`。sector 间 prefactor 不同时，上式两类贡献都不能省略。scaling degree、DE 和 time-only projection 读取同一 materializer，不从 `J` pack 反推 normalization。

018 已完成该统一修复：massive cycle/fixed contact 的常数和模长幂进入 target `sectorPrefactorData`，所有 contact 只先产生 `c_raw`，随后由公共层转换为 `c_raw N_source/N_target J_target`；`ds/DSDE` 和被积函数反变换读取同一个 prefactor materializer。结构化 smoke 为 `16/16`，但完整 scaling/reference 闭环仍是发布门禁。

### 21.3.1 Kira backend 的 `k=-I ik`

这是一项 serializer convention，不是第二套物理变量。能量角色来自初始化的 vertex-phase dependency data；禁止按 `k/P/sE` 等名字猜测。每个独立 phase-energy 原子生成一条记录：物理原子、backend 原子、来源顶点/角色、`k -> -I ik`、`ik -> I k`、普通导数两个方向的 Jacobian 以及 Euler 不变标志。复合 phase expression 拆成这些原子，同一原子复用时合并 provenance；非 phase 坐标不进入映射。

后端名为物理原子名小写后加前缀 `i`，例如 `P0 -> ip0`。生成前检查非原子输入、保留名 `dsii/ccc`、backend 名重复、大小写折叠冲突及与既有 coefficient symbols 的碰撞；任一项不满足即拒绝 export。数值规则只允许给这些 backend 能量赋精确实有理数；`P0 -> 29/13` 在 manifest 中分解为 backend `ip0 -> 29/13` 与物理求值截面 `P0 -> -29 I/13`，而不是把 `I` 当作 Kira 变量。

export 顺序固定为 massless phase-momentum map、backend numeric rules、残余 Gaussian phase gauge。每个 massless propagator 动量原子都由 topology/line metadata 识别并执行 `k -> -I ik`，不得按名称猜测；massive bubble 的既有路线是参考实现。import 顺序固定为一般 coefficient map 的逆变换、backend `ik` 的逆变换、积分 phase gauge 的逆变换。`DSDE` 用物理截面求物理矩阵，并可由 `A_ik=-I A_k` 给出 backend view；反向为 `A_k=I A_ik`。`DSScaleCheck` 必须读取物理截面，或等价地直接用 `ik D_ik`，不得把 backend 的实数 `ik=r` 错当成物理 `k=r`。

实数化合同适用于所有 Kira family，而不只适用于全参数数值点。含符号参数时，Kira 系数可以是实 backend 变量的有理函数，但仍须通过逐积分相位变换消除全部虚轴因子；若同一系数含不可分离的实部和虚部，或输出文本出现 `I`、`Complex`、`dsii`，serializer 必须 fail closed。初次探测 targets 按预估 master 规模设上界，没有更具体依据时不超过约 1000；formal targets 只含 active basis 与导数闭包。

reference 对照的数据源边界与 package reduction 分开：package 侧在关系或 exporter 改变后 fresh reduction；reference 侧直接复用并哈希核验原始程序已导出的解析 `DEP0/DEks`，禁止为数值 probe 重新生成 reference reduction。bubble 的变量方向是 `P_pkg=-P_ref`，所以同一截面为 `P_pkg=-29 I/13`、`P_ref=29 I/13`，且 `D/D P_pkg=-D/D P_ref`；之后再用 `D_P0=I D_ip0` 得到 backend 导数。原始 `MIdlogNote` 第 15--18 项显式 `ks` 的恢复属于 source-defined basis reconstruction，不是 normalization adapter。最终 19 个 master 定义比例全为 1，三套矩阵均 `361/361`。

### 21.4 parity generator 与 sector offset

root topology 的 parity 定义为 GF(2) 仿射系统

$$
W_0 x_0+r_0=0\pmod 2.
$$

$x_0$ 使用 metadata 中与 full pack 三槽位置对应的稳定 integer slot id。字符串 `"F"` 与 shrunk single-slot sentinel 不进入 integer slot vector；权重为零的槽不参与 parity。017 强制 fixed/non-loop line 的两个端点态和 prefactor 全部不进入 parity。root generator 可以来自用户输入或已验证的 h/H preset，但 child sector 不接受另一套独立手写 generator。

一次 contact/shrink 给出 root/parent 到 child 的槽替换。例如 massive h/H line 满足

$$
n_1+n_2=1,\qquad b_S=b+1.
$$

把这些等式代入 parent generator 并在 GF(2) 上消去被删除的 endpoint slots，即得到 child 的 $W_s,r_s$。这些等式必须来自实际 compiled shrink/sector data。对常见的一行

$$
b+n_1+n_2=0\pmod2
$$

在 h/H 缺省整数 shift `bShift=1` 下自动得到 $b_S=0\pmod2$。h 的 `zShift=2nu` 只改变 zero point，H 的 `zShift=0`；二者都不是额外的整数 seed 槽，因此不翻转该 parity。该计算只在 sector 初始化时做一次并缓存，不在每条 seed 中重复符号消元。fixed/non-loop line 不进入 parity generator。

massless cycle line 的 contact support 同样是 odd endpoint state，但整数 shift 为零：`n1+n2=1, bS=b`。因此 parent 的 `b+n1+n2` 与 child 的 `bS` 相差 1，sector affine offset 必须翻转。016 的单 `n` 表示由 `n=1, bS=b` 得到同一结果。fixed/non-loop massless line 权重为零，不影响 offset。pure massless 不自动猜 root parity 的 remainder；用户显式给出已推导约束后，必须与 mixed h/H family 一样在 massless transition 上应用这次翻转。

用户 zero-point override 只通过整数重基改变 offset。设派生缺省为 $z_s$、用户值为 $z'_s=z_s+\delta$；保持物理幂次不变时 $b_s^{\rm default}=b_s^{\rm user}+\delta$，故

$$
r_s^{\rm user}=r_s^{\rm default}+W_s\delta\pmod2.
$$

实现只接受能精确证明为整数的 $\delta$。偶整数不改变判定，奇整数翻转相应 sector offset。非整数或无法判定为整数的差不属于二元 index 重基；该 sector 的 parity capability 关闭并给出红字中英双语诊断。未请求 parity 的 IBP 仍可生成，避免把 parity 的适用边界变成无关工作流的门禁。

### 21.5 h/H 分级证明

h 的 EOM 把 `{n=2,b}` 化为 `{n=0,b}` 与 `{n=1,b+1}`，三者的 `b+n` 均同余。裸 H 的 EOM

$$
H_2=-H_0-x^{-1}H_1+\nu^2x^{-2}H_0
$$

在指标语言中给出 `{n=0,b}`、`{n=1,b+1}` 和 `{n=0,b+2}`；它们也都与源 `{n=2,b}` 的 `b+n` 同余。因此 H preset 的 EOM 保持相同 GF(2) 分级。这个结论来自微分方程在 $x\to-x$ 下的分级结构，不要求一般复阶 Hankel 函数满足 $H_\nu(-x)=\pm H_\nu(x)$。

h/H contact 还需独立检查 shrink 的分级。当前 h/H Wronskian 分别给出 `{bShift,zShift}={1,2nu}` 与 `{1,0}`；结合 contact 支持 `n1+n2=1`，parent 的 `b+n1+n2` 与 child 的 `bS=b+1` 同余，所以两种缺省 shrink 都保持 parity。018 不硬编码这个结论，而从 `compiledFunctionSystem["shrinkTerms"]`、sector zero-point map 和实际 contact seed 三处交叉确认。如果用户改变 h/H 的 child zero point，则按上一节的 integer rebase 修正 offset；无法证明为整数时关闭该 sector parity capability。

parity capability 逐 line 检查已证明的 GF(2) 闭合：massive line 必须使用 h/H compiled function system，massless line 必须使用 exponential system；二者可以任意混合，也允许 pure-massless family。massless quotient 的 $F_{01}=-F_{10}$、$F_{11}=-F_{00}$ 与动量幂 shift 保持 $b+n_1+n_2$ 分级，故显式 root constraints 可复用同一固定三槽 walker 和 sector transport。package 不替用户猜 pure-massless remainder；未给约束时只是不筛选。未知/custom function system 仍令 `parityUsableQ=False`，显式 parity 请求 fail closed，普通 seed 生成继续。

### 21.6 在 seed 域直接求解 parity

`DSGenerateIBP` 不先构造 Cartesian 全量关系。对每个 sector 和已经固定离散态的模板，把 $W_sx+r_s=0$ 在 GF(2) 上行约化：

1. 选择 pivot continuous indices；其余为 free indices。
2. 枚举 free indices 的用户指定整数范围。
3. 由约束计算每个 pivot 的所需余数，只遍历该范围中具有该余数的整数。
4. 对得到的合法 tuple 才代入模板并生成 IBP equation。

若某行只含已固定离散态而不含 continuous pivot，则在模板进入连续枚举前直接接受或拒绝该离散态。该算法遍历实际合法 seeds，不生成后再删除约一半方程。

post-generation parity check 只作证书：提取每条实际方程中的不同 `J`，解析 sector 后计算其 signature。任何非零 signature 都使该 batch 状态失败；绝不建立 `J /; badParity :> 0` 规则。这样 EOM/contact/slot-map 错误会直接暴露，而不会被零规则掩盖。

### 21.7 massless 与公式型 time-only 的暂缓边界

统一三槽 time-only 路线会转换 massless 内建关系、其它 symmetry、seed、`sectorPrefactorData` 和 derivative operator。参数重定义后的 `parameterList`、source/target normalization ratio 与 prefactor derivative 必须一起转换。massless 关系与用户/tadpole 关系求并集，但按关系本身决定是安全 canonical rule 还是独立线性 equation。

017 不在 massless quotient 上重建公式型 `repIterative` 和直接 dlogDE。含 massless 体内传播子的公式调用返回 `PendingRederivation`；未来任务是重新推导 quotient master basis、迭代终点、单步递推、dlog connection 及运动学依赖换基项，再与 naive time-only IBP+DE 使用同序 basis 交叉检查。
