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

其中 serializer 只能消费结果，不能重算 contact。详细验收清单见 `000_note/2026-07-21_common_theta_correctness_todo.md`，两种等价分布定义的证明见技术笔记附录。

## 1. 基本对象与记号

图的输入数据由 family 初始化给出：

- 顶点集合：`v = 1,...,V`，每个顶点有共形时间 `\tau_v` 和 SK 分支标记 `\epsilon_v \in \{+,-\}`。
- 圈动量基：`q_1,...,q_L`。
- 内线集合：`e = 1,...,E`，每条内线携带端点 `(u[e], v[e])`、动量 `Q[e] = \sum_l c[e,l] q_l + P_e`、模长 `\xi_e = |Q[e]|`、场参数 `\nu_e`。
- 外线（Boundary）：`B \to v` 表示外腿连接到顶点 `v`，携带动量 `k_{ext}`。
- 外部能量按顶点 e 指数输入：若能量由 `externalMomenta` 张成并应复用关系，写成外部不变量名的函数；否则作为独立 `ke[i]` 参数。不要默认把同一顶点的外腿模相加。

以下 family 初始化信息必须一开始设定，但不写进 `J` 的指标槽：

- 每条线的 `massType`、`bbType`、`skType`、`thetaConvention` 和可选 `packType`。
- 圈动量基 `loopMomenta` 与独立外动量向量基 `externalMomenta`。`externalMomenta` 只包含会进入内线动量 `Q_e = l + sum k` 并与圈动量纠缠的外部三动量向量；只出现在顶点时间相位中的无质量外腿能量模或能量组合不属于该向量基；独立绝对值参数用 `ke[i]` 记录。
- ISP 列表 `ispData`。若传播子不足以覆盖全部独立标量积，必须显式给出 ISP。
- 零点规则 `a0Rules/b0Rules/bS0Rules` 与缩并 prefactor 规则。
- seed 幂次范围和测试范围。范围控制枚举，不属于积分指标本身。

这些配置一开始设定并不麻烦，且能避免后续代码从指标形状反推物理类型。`J` 的职责只是不带歧义地承载动态指标。

强制 seed pipeline：
1. 先确定 sector（哪些线完整、哪些线缩并）和生成元类型（time 或 momentum）。
2. 枚举连续指标 seed 后，必须枚举该 sector 中离散 `n=0/1` 状态；不能只保留符号 `n` 再把 EOM 推迟到后端。
3. 生成元作用后若出现 Hankel 二阶导数态 `n=2`，立即在 seed 层应用 EOM 递推，递归化回 `n=0/1`。
4. massless 线始终走双 theta 合并主线，输出 pack 必须保持 `{b_e,n_e}`，不拆成两个 theta 分支。
5. 任何含 `n=2`、未知 pack 或未处理 theta 边界项的表达式都不能进入 batch、linear-system 或 Kira exporter。

积分的人读记号：
```
J[\{a_v\}, \{linePacks_e\}, \{n_{isp}\}]
```

三个槽位：
- `\{a_v\}`：时间幂次 `(-\tau_v)^{a_v}`，写在分子
- `\{linePacks_e\}`：逐条内线的指标包，结构由线的状态决定
- `\{n_{isp}\}`：ISP 分子幂次；没有 ISP 时为 `{}`

### 线的两种状态

| 状态 | pack 结构 | 含义 |
|------|----------|------|
| massive 完整线 | `{b_e, n_{e,1}, n_{e,2}}` | building block (h/H) 存在，有两个端点指标 |
| massless 完整线 | `{b_e, n_e}` | 双 theta 合并路线，端点关系压缩成两个状态 |
| 缩并线 | `{bS_e}` | theta 导数导致 h 消失，剩余幂次绑定 `k\tau` |

缩并线来自时间 IBP 中 Heaviside 函数的 delta 缩并。`bS_e = 0` 对应更深一层 sub-sector。所有 sector（top 和 sub）使用同一个 Head `J`，通过哪些线处于缩并态区分。

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

当前 012 主线继承 `masslessCross -> {b_e}`。momentum IBP 同时包含传播子幂次和无 theta 指数核的 q 导数；time IBP 中无 theta 边界项，端点相位导数按 SK 符号给出 `+ i q_e` 或 `- i q_e`，指标上为 `b_e -> b_e-1`。该路线已有 `bubbleMasslessCrossNoTheta` 小检查。

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

### 6.2 二阶导数与单 `n` canonical

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

`{20}` 与 `{11}` 的符号不同，所以不能把它们都压成一个没有方向信息的 “massless n=2”。正式 `J` 只允许 `n=0,1`；time/momentum 原子模块直接翻转 `n -> 1-n`。连续在同一端点作用两次时，两次 `+-i` 系数自动给出负号和 `b->b-2`，不经过临时 `n=2`。

### 6.3 time-IBP 与 theta boundary

完整 kernel 满足

~~~text
d_u M[n] =  i sigma q M[1-n] - 2 n delta[tau[u]-tau[v]]
d_v M[n] = -i sigma q M[1-n] + 2 n delta[tau[u]-tau[v]]
~~~

所以 regular 部分的指标变化为

~~~text
first endpoint : {b,n} -> {b-1,1-n}, coefficient +i sigma
second endpoint: {b,n} -> {b-1,1-n}, coefficient -i sigma
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

当前 012 仍逐线保留 `{b_e,n_e}`，但 boundary 已使用上述共同-theta contact；`masslessBundleCandidates` 只是 massless 子集的 metadata 摘要，不是另一个积分 Head。

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


### 用户对称性规则的边界

`sp` 的 `Orderless` 只实现标量积交换性 `sp[p,q]=sp[q,p]`，不代表一般 Feynman 图或积分族对称性。积分族对称性依赖质量、外腿能量和动量等物理条件，package 不自动猜测一般图 automorphism。

当前 012 case 可选输入 `symmetryRules`。`repSymmetry0[topo_]` 只返回用户原始规则；`effectiveSymmetryRules0[topo_]` 将其与自动 tadpole rules 去重合并，`symmetry[expr_,topo_]` 对并集只执行一次 `/.`。自动规则只识别 `originalEndpoints` 已相同的 self-loop：massive full 规范化 `{1,0}->{0,1}`，massless full 的 `n=1` 归零；odd ISP 还要求该 loop momentum 不出现在其它传播子中。cross propagator 与 shrink 后才 coincident 的普通线均不匹配。
## 8. IBP 生成要点

IBP seed 包括：
- 时间 IBP：`d/d\tau_v`（`V` 个算子），处理 Heaviside delta 塌缩
- 圈动量 IBP：`q_l^\mu \partial/\partial q_l^\mu`（`L` 个标度算子），多圈时添加 `q_l^\mu \partial/\partial q_m^\mu`
- 前端关系：massless full/cross endpoint canonical；`symmetry` 单次应用自动 tadpole 与用户规则并集，apart/scaleless 仍待实现

生成流程：
1. 读取 family 配置，并验证 ISP/零点/numericRules/seedRanges 已定义
2. 构造 sector 指标盒子
3. 枚举连续种子（含撒点范围控制）
4. 对每个连续种子枚举离散 `n=0/1` 状态
5. 分别作用 time-IBP 与 momentum-IBP 生成元
6. 立即应用 EOM，递归消去所有 `n>=2`
7. 应用 massless 双 theta 合并 canonical 关系，保持 `{b_e,n_e}` 包
8. 检查越界与 forbidden `n` → 标记边界 / 扩盒 / 报告
9. 生成 canonical seed summary
10. seed 先保存为 MMA 表达式；只有在 1--9 通过、并完成必要的数值规则/撒点选择后，才允许进入线性系统编号与 Kira 导出


### 8.1 sector metadata 与全局积分排序

每个 sector 需要缓存一份轻量 metadata；canonical batch/linearData 使用 `sectorMetadataList` 保存 top 与所有 shrink sub-sector，避免后端读取时重新从拓扑推断指标含义：

- `activeASlots`：缩并后仍活跃的 `a` 槽。缩并线的 delta 会把两个端点的时间积分合并，因此只有代表顶点的 `a` 保持可变，另一个端点在 `J` 中固定为 `0`。
- `lineSlots`：每条线的原始 line id、当前端点、packType、massType/state、第一幂次指标（`b` 或当前代码中的 `bS`）和完整 pack 模板。
- `ispSlots`：ISP 指标和对应定义。
- `masslessBundleCandidates`：同一顶点对上多条 `masslessFull` 线的分组摘要；time boundary 使用更一般的 massive/massless common-theta bundle 分组生成 odd-subset contacts。

`J` 的 `aList` 采用 compact active slots：delta 缩并后只保留仍独立的时间变量，不在 `J` 中保留 inactive 原顶点槽。原始顶点编号、外腿、线端点、original slot 与 compact slot 的对应关系全部保存在 `sectorMetadataList` 中。seed batch 通过 `writeSeedBatchMMA` 保存为 MMA 表达式；任何后端 exporter 都不直接读取 seed batch。

`makeLinearSystemData` / `makeSampledLinearSystemData` 的 `linearData` 是 backend-neutral 中间层，保存 `linearEquations`、`integralList`、`integralRules` 与全 sector metadata。Kira 只是当前提供的一个 serializer；Rational Tracer 或其它线性后端应从这一层对接，不要求 package 记录或管理后端可执行文件路径。

Kira 编号必须对所有 sector 的积分一起做全局排序，不能先按 sector 追加。当前 `sortIntegralsForKira` 的第一优先级是所有线第一幂次指标的复杂度，随后再看 `a`、ISP、离散 `n` 和稳定字符串序；后续可在此基础上叠加用户指定 master/weight。若用户通过 `IntegralOrder` 或 `PreferredIntegrals` 指定候选主积分，linear-system 会保存 `kiraOrderingReport`；若某个指定对象不在当前全局 `integralList` 中，会出现在 `missingIntegralOrderItems`，避免静默失效。

`makeTopologyData` 和 `summarizeCase` 还会返回 `validationReport`。它只做轻量结构检查：线编号、端点、声明的圈/外动量基、ISP 数量、z/ISP 坐标数是否闭合、`numericRules` 是否覆盖外动量不变量、sampleDiscreteRules 和当前未实现的 seed feature；不做解析 rank、全局求解或大规模 IBP 展开。canonical batch 还必须通过 `makeCanonicalSeedCoverageReport`，确认每个 sector 都有完整 qIBP/tIBP 生成元覆盖后才允许进入 linear/Kira。`numericRules` 缺少某些外部不变量变量名（默认 `sij`，或 `externalInvariantRules` 给出的自定义名）时只给 warning，因为解析 seed 仍可生成；但 workflow 显式使用 `LinearSystemMode -> "numeric"` 时会在 seed 生成前返回 `numericRulesMissingExternalInvariants`，要求用户补齐这些规则。若使用 sample 离散模式，`sampleDiscreteRules` 的每条规则必须覆盖该 sector 的全部离散 `n` 变量；否则 seed 中会残留符号 `n`，不能进入即时 EOM canonical。

## 9. 外腿与传播子统一约定

传播子和外腿统一按 Feynman 规则处理，`k` 直接代入对应表达式：

- 顶点 `v`（标记 `+`）：时间积分核含 `e^{i k_v \tau_v}`，外腿因子为 `u^*_{k_v}(\tau_v)`
- 顶点 `v`（标记 `-`）：时间积分核含 `e^{-i k_v \tau_v}`，外腿因子为 `u_{k_v}(\tau_v)`
- 内线 `e`（`G^{++}` 或 `G^{--}`）：指数核 `e^{i\sigma_e q_e (\tau_{u[e]} - \tau_{v[e]})}`
- 内线 `e`（`G^{+-}`）：`u_{q_e}(\tau_{u[e]}) u^*_{q_e}(\tau_{v[e]})`，即 `e^{i q_e \tau_{u[e]}} e^{-i q_e \tau_{v[e]}}`

IBP 中的 `k_v` 符号始终与 Feynman 规则一致，不需要根据顶点 ± 额外翻转。

## 10. 不可约标量积 (ISP) 与多圈函数族

### 10.1 ISP 定义

对于 $L$ 圈图，若 `externalMomenta` 中有 $K$ 个独立外动量向量，则存在 $L(L+1)/2$ 个独立的圈动量标量积 $q_i \cdot q_j$ 和 $L K$ 个圈-外动量标量积 $q_i \cdot k_j$。其中一部分可由传播子动量 $Q_e$ 的平方 $\xi_e^2 = Q_e^2$ 线性表示，剩余的不可约标量积称为 ISP。

**用户口定义**：用户先在 `loopMomenta` 与 `externalMomenta` 中给出独立圈动量/外动量基，符号名称任意；标量积统一写成 `sp[p,r]`，其中 `p,r` 必须是这些基动量的线性组合，例如 `sp[l3, k321 + l3]`。`sp` 具有 `Orderless` 属性，因此 `sp[p,r]` 与 `sp[r,p]` 自动规范成同一对象。非线性参数如 `sp[l3^2,k]` 不属于 scalar-product 输入，会在 validation 中报错。

内部实现仍把所有 `sp[p,r]` 展开到编号坐标 `qq[i,j]`、`qk[i,j]`、`kk[i,j]` 做线性代数；这些内部记号不作为用户输入 convention。输出端需要区别：圈动量相关对象仍可显示为 `sp[...]`，但外动量-外动量不变量显示为变量名。用户可用 `externalInvariantRules -> {sp[k1,k1] -> s11, sp[k1,k2] -> s12}` 自定义；未指定时默认按 `externalMomenta` 的列表位置输出为 `sij`。

dS 的特殊点是：一个顶点连着的所有外腿在时间相位里只通过打包后的 e 指数能量进入，这个量是标量参数，不是外部三动量向量。只有当某个外部三动量向量实际出现在内线动量偏移 `P_e` 中、从而在 `Q_e^2` 或 `q_l \cdot Q_e` 中和圈动量发生标量积时，才应放入 `externalMomenta` 并参与 `sp` 完备性。若某个外腿能量或能量组合永远只以顶点能量形式出现，则应保存在 `vertexEnergies` / `numericRules`，不进入 `externalMomenta`、`sp`、传播子坐标或 ISP 坐标。若顶点能量和 `externalMomenta` 空间的外部不变量是同一变量，应优先写成 `Sqrt[s11]`、`Sqrt[sigW]` 等外部不变量表达式；否则作为独立能量参数，建议写 `ke[i]`。若 `|ke1+ke2|`、`|ke1|`、`|ke2|` 独立，就必须分别命名，不能自动相加。外腿能量参数不是一组要做完备标量积的向量基，程序不需要生成 `ke[i] ke[j]` 这类外腿-外腿点积。`vertexEnergies` 中不能直接写 `loopMomenta/externalMomenta` 的向量符号，也不能写圈相关 `sp[q,k]`；属于外动量空间时写外部不变量变量名表达式，否则写独立 `ke[i]`。

### 10.2 独立变量微分方程求导边界

012 的微分方程 seed 只处理已经由 topology 输入声明清楚的独立变量，不主动替用户拆分或合并物理能量。规则如下：

- `ke[i]` 等独立顶点能量参数只对 `vertexEnergies` 中的 e 指数相位做标量求导；它不进入 `externalMomenta`、`sp` 坐标或 ISP 完备性。
- 默认 `sij` 或用户自定义外不变量名属于 `externalMomenta` 的 Gram 坐标。对它求导时，先在约束坐标上把 $\partial/\partial x_a$ 写成外动量矢量导数 $D_{ij}=k_i\cdot\partial/\partial k_j$ 的线性组合。
- 系数由 $\sum_{ij}c^{(a)}_{ij}D_{ij}x_b=\delta_{ab}$ 解出。完整 $K^2$ 个 $D_{ij}$ 一般存在零空间，所以解不唯一；实现必须返回所选 basis、矩阵、系数、残差、`nullity` 和 `nonUniqueQ`。
- 当前默认 basis 是上三角 `externalVector` generators。若物理问题要求其它切向选择，应通过 operator basis 覆盖，而不是在求导核心中硬编码。
- 每个外动量矢量导数要作用到传播子、massive/massless building block、ISP/numerator，以及那些被写成外不变量函数的顶点能量表达式，例如 `Sqrt[s11]`。
- massive building block 的 external-vector/外不变量导数与 qIBP、tIBP 共享 line-local 最终 `AT -> derivativeTerms`，不能另行假设 `n->n+1`。`WT/shrinkTerms` 只属于 time-IBP 的 theta coincidence，不参与普通动力学量导数。

公开入口为 `ds[expr,sij,topo]` 或已注册 context 下的 `ds[expr,sij]`。`sij` 必须使用 topology 初始化后的外部名字；内部 `kk[i,j]` 不接受。程序用惰性 token 固定每个 `J`，先由 `D` 产生显式系数导数，再用单积分核心补上指标导数，因此严格满足
$$
\partial_s\sum_r c_r(s)J_r=\sum_r c'_r(s)J_r+\sum_r c_r(s)\partial_sJ_r.
$$
允许常数项和任意 `J` 线性组合，不允许 `J_iJ_j` 或非多项式 `J` 依赖。

external-vector 对标量积函数的作用按坐标链式法则实现：先抽取表达式中的 `qq/qk/kk` 坐标，再求 `D[expr,coordinate] D_ij(coordinate)`。这保证 `Sqrt[s11]` 等非线性顶点能量得到正确的 $1/(2\sqrt{s_{11}})$，而不是错误的 `Sqrt[D_ij s11]`。

### 10.3 函数族扩展

多圈积分家族需扩展为：

$$J[\{a_v\}; \{\text{pack}_e\}; \{n_{\text{isp}_j}\}]$$

其中：
- $\{a_v\}$：顶点时间幂次
- $\{\text{pack}_e\}$：内线指标包（完整线或缩并线）
- $\{n_{\text{isp}_j}\}$：ISP 分子幂次，$n_{\text{isp}_j} \geq 0$

### 10.4 ISP 完备性验证

在生成 IBP 前，必须验证 ISP 集合的完备性：

1. **覆盖性**：所有标量积 $\{q_i \cdot q_j, q_i \cdot k_j\}$ 均可表示为用户给出的 $\{\xi_e^2\}$ 和 $\{\text{ISP}_j\}$ 的线性组合。
2. **独立性**：ISP 可以是 `sp[p,r]` 的线性组合坐标，例如 `sp[l3, k321 + l3]`；这些 ISP 坐标之间应线性无关，并且不应再由传播子平方线性表示。
3. **数目检查**：当前实现要求 `zExprs` 与 ISP 坐标总数等于独立 loop-scalar-products 数目，即 $\#z_e + \#\text{ISP}=N_{\text{sp}}$。这里的计数是用户定义的 `z/ISP` 坐标闭合条件，不是程序自动选择 propagator 子集。
4. **线性动量检查**：每条 line momentum 以及每个 `sp[p,r]` 的参数都必须是 `loopMomenta/externalMomenta` 的线性组合；若出现 `q1^2` 这类非线性写法，`validationReport` 返回 `nonLinearLineMomenta` 或 `nonLinearScalarProductArguments`。
5. **可解性检查**：数量闭合后，程序会实际构造小矩阵并尝试生成 `repSP2Z`；若传播子动量退化、重复或无法反解，会在 `validationReport` 中报告 `scalarProductCoordinateSolveFailed`，而不是等到 IBP seed 生成时报错。
6. **数值规则检查**：若拓扑包含独立外动量基，当前报告和模板会列出外部不变量变量名，例如默认 `s11`、`s12` 或用户自定义名。推荐 `numericRules` 写 `s11 -> value` 或 `sigW -> value`；`sp[k_i,k_j] -> value` 只作为输入兼容形式。缺失时报 `numericRulesMissingExternalInvariants` warning，不阻止解析 seed。

其中 $N_{\text{sp}} = L(L+1)/2 + L K$，$K$ 是初始化中 `externalMomenta` 的独立外动量基个数。

本 package 的设计边界是：用户在初始化阶段给出完整的传播子动量和 ISP 定义，程序验证这组输入是否能闭合 IBP 中出现的 loop-scalar-products。对于通常的 dS 图，传播子动量加上用户指定 ISP 后应直接固定 family；多圈时常见情况是传播子平方少于全部标量积，需要 ISP 补齐，而不是程序自动从一堆 overcomplete propagators 中选 basis。若输入中存在重复/退化传播子、ISP 过多或不足、特殊数值外动量导致 rank 下降，当前主线不会自动丢弃传播子、也不会替用户重新选一组独立 propagator basis；validation 会报告 `scalarProductCoordinateCountMismatch`、`insufficientISPData` 或 `scalarProductCoordinateSolveFailed`，由用户修正 family 输入。

### 10.5 IBP 生成元

对于 $L$ 圈图，完备的 IBP 生成元集合为：

$$\mathcal{O}_{l,v} = \frac{\partial}{\partial q_l^\mu} \cdot v^\mu$$

其中 $v^\mu$ 遍历：
- $v = q_m$（$m = 1, \ldots, L$）：$L$ 个对角生成元
- $v = q_m$（$m \neq l$）：$L(L-1)$ 个交叉生成元
- $v = k_j$（$j = 1, \ldots, K$）：$LK$ 个外动量生成元，其中 $K=\#\texttt{externalMomenta}$

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

外动量-外动量点积在输出端采用变量名，不保持 `sp[k_i,k_j]` 的矢量点积形式。用户可用 `externalInvariantRules` 指定，例如 `sp[k1,k1] -> sigK`；未指定时按 `externalMomenta` 的位置默认记为 `sij`。

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
$$z_e = \sum_{l,m} A_{e,lm}\, (q_l \cdot q_m) + \sum_{l,j} B_{e,lj}\, (q_l \cdot k_j) + C_e(\{s_{ij}\ \text{或用户自定义外部不变量名}\})$$

其中 $C_e$ 为仅含外部不变量名的常数项。系数 $A, B, C$ 由 $Q_e = \sum_l c_{e,l}\, q_l + P_e$ 的定义直接展开得到。

**逆向变换**（z → 标量积）：
$$(q_l \cdot q_m) = \sum_e D_{lm,e}\, z_e + \sum_j E_{lm,j}\, (q_l \cdot k_j) + F_{lm}(\{s_{ij}\ \text{或用户自定义外部不变量名}\})$$

当存在 ISP 时，逆向变换中保留 ISP 项（不试图用 $z_e$ 表示）。

存储为两组替换规则：
```mathematica
repZ2SP    (* z_e → 标量积组合 + 外部不变量 *)
repSP2Z    (* 标量积 → z_e 组合 + ISP + 外部不变量 *)
```

### 11.4 在 IBP 中的使用流程

动量 IBP 生成元 $\mathcal{O}_{l,v} = \partial/\partial q_l^\mu \cdot v^\mu$ 作用后被积函数中出现形如 $q_l \cdot Q_e$ 的标量积。处理步骤：

1. **矢量求导与点积**：对生成元做链式法则，得到含 $q_l \cdot Q_e$ 的表达式。此时 $q_l \cdot Q_e$ 仍以矢量点积形式出现。

2. **替换为 z 变量**：应用 `repSP2Z`，将所有 $q_l \cdot Q_e$ 用 $z_e$ 和 ISP 的线性组合替换。外部不变量名（默认 `sij` 或用户自定义名）作为常数保留。

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

当前唯一权威实现是 `000_code/012_dS_ibp_general.wl`。011 保留为 v011 报告及旧验证资产的对应基线。

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

012 当前通过 12 个修正后 hand-derived family 的 package cross-check：atomic massive 104/104、atomic massless 22/22 加易错点 8/8、pure massless bubble 64/64、mixed bubble 132/132、mixed triangle 1792/1792、mixed sunrise 1842/1842、pure massive bubble reference 608/608（h/H 各 304）、two-loop ISP toy 978/978、parallel massless bundle guard 194/194、vertex energy signs 90/90、tadpole symmetry 8/8、ds total derivative 9/9。另有 theta/report audit 30/30；011 的函数系统、独立变量求导、公开 API 和 serializer 检查作为继承回归。serializer 检查不运行 Kira/Fermat reduction。

这些检查覆盖约定的顶点符号、可达 sector、离散态和 qIBP/tIBP 生成元，但不是任意拓扑的数学穷尽证明。011 时代的 expected/helper 保留在 `000_code/check/hand-derived-v2/`，用于审计旧 oracle 为何会与旧实现同向通过；012 的修正 expected 和 actual adapters 位于 `000_code/test/012_hand-derived/`、`000_code/test/012_hand_derived_cross_checks/`。

仍保留的设计项：

1. 正式 Mathematica package/context；012 已提供显式 topology 或已注册 context 的公开原子 API，但尚未迁入正式 `BeginPackage` context。
2. 将独立 benchmark 扩展到当前 12 个已完成 family 之外的新 topology；现有指定 family 已完成全 sector、全顶点符号与全生成元覆盖。
3. 高圈 seed 的 streaming/chunking 与规模报告。
4. 自动图 automorphism/参数对称性检测，以及 scaleless、parity 等可选前端 canonical；用户输入 `symmetryRules` 与 `symmetry[expr_,topo_]` 的单次应用已经实现。
5. Rational Tracer 或其它后端 serializer。

自动运行 reduction、管理后端安装路径和导入 reduction 结果不属于本 package 的当前职责。
