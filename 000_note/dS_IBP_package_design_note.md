# dS IBP Package 设计笔记

本笔记记录当前主线的约定体系和关键推导，与 `dS_IBP_package_plan.md` 配合阅读。不同拓扑由输入 Association 描述，共用同一套 topology-driven IBP 生成函数。

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
- `"H"` → `{2ν, 1, -1}`
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

当前 009 主线已实现 `masslessCross -> {b_e}`。momentum IBP 同时包含传播子幂次和无 theta 指数核的 q 导数；time IBP 中无 theta 边界项，端点相位导数按 SK 符号给出 `+ i q_e` 或 `- i q_e`，指标上为 `b_e -> b_e-1`。该路线已有 `bubbleMasslessCrossNoTheta` 小检查。

### 3.4 G^{+-}/G^{-+} 型 massive 的处理

Massive 线的 Hankel building block `h[\nu, n, q_e \tau]` 在每个端点导数下分别产生 `n_{e,a} \to n_{e,a}+1` 的递推。对 `G^{+-}/G^{-+}` 型，由于无 Heaviside 结构，time IBP 不产生 theta 边界缩并项；但两端 Hankel building block 仍是独立对象，不能像 massless 指数核那样压缩成单个 `n_e`。

- 指标包仍采用 `{b_e,n_{e,1},n_{e,2}}`
- momentum/time building-block 导数项与 `G^{++}/G^{--}` 型 massive 线相同
- EOM 递推与 `G^{++}/G^{--}` 型相同，种子层递归消去所有 `n>=2`
- 唯一区别是没有 theta 导数产生的 shrink-sector 边界项

当前主线已把这类线显式分派为 `massiveCross`，但指标包仍为 `{b_e,n_{e,1},n_{e,2}}`。它已接入离散态枚举、momentum/time building-block seed、EOM canonical 和 linear-system/Kira 前置门禁；theta boundary shrink 只作用于 `massiveFull`。

## 4. h 函数与 H/h 转换

### 4.1 h 函数定义

dS IBP 文献 [Chen:2023eic] 定义归一化 building block `h[\nu, n, z]`（`n = 0, 1`），满足二阶 ODE：
```
u'' + Q(\nu, z) u' + P(\nu, z) u = 0
```

其中 `P, Q` 是由 `\nu` 和 `dim` 决定的系数函数。对标准 dS scalar：
```
Q = -(dim - 1) / \tau    （摩擦项）
P = q^2 + (\nu^2 - (dim-1)^2/4) / \tau^2   （有效势）
```

`n = 0` 对应基函数，`n = 1` 对应一次导数态。`n \geq 2` 由 EOM 递推消去：
```
h[\nu, 2, z] = -Q * h[\nu, 1, z] - P * h[\nu, 0, z]
```

### 4.2 H 函数与 h 函数的关系

标准 Hank尔函数 `H_\nu^{(1)}(z)` 与 `h[\nu, n, z]` 通过归一化变换联系：
```
H_\nu^{(1)}(z) = N(\nu, z) * h[\nu, 0, z]
z d/dz H_\nu^{(1)}(z) = N'(\nu, z) h[\nu, 0, z] + N(\nu, z) h[\nu, 1, z]
```

其中 `N(\nu, z)` 是归一化因子（含 `z` 的幂次和 Gamma 函数）。

### 4.3 转换函数

脚本中提供：
```mathematica
repH2h[expr_]   (* H 表示 → h 表示 *)
reph2H[expr_]   (* 反向 *)
```

转换本质是对每条内线的 building block 做线性基变换。具体映射系数由 §4.2 的 `N(\nu, z)` 决定。此函数用于在不同文献约定间切换，不影响 IBP 生成本身。

## 5. PQ/EOM 框架

### 5.1 PQ 系数

每条内线 `e` 的 building block 满足 ODE `u'' + Q_e u' + P_e u = 0`。package 用 `PQ` 存储：
```mathematica
PQ[e] = {P_e, Q_e}   (* 缺省由 \nu_e 和 dim 自动计算 *)
```

用户可通过 `PQ = {e -> {P_e, Q_e}, ...}` 覆盖。

### 5.2 EOM 递推

对指标 `n_{e,a} \geq 2`，用 PQ 递推：
```
h[\nu_e, n, z] = -Q_e * h[\nu_e, n-1, z] - P_e * h[\nu_e, n-2, z]
```

在指标语言中：`n_{e,a} \to n` = `(-Q_e) * (n_{e,a} \to n-1) + (-P_e) * (n_{e,a} \to n-2)`。

`applyEOM` 函数递归应用此规则直到所有 `n_{e,a} \in \{0, 1\}`。这一函数是 seed 生成的一部分，不是可选后处理。momentum/time 生成元作用后必须立刻调用 `applyEOM`，并用 `containsForbiddenNQ` 一类检查扫描所有 `J`，确认没有 `n>=2` 残留。

### 5.3 absorbFactor 中的 PQ 使用

当 `absorbFactor` 处理动量 IBP 产生的 building block 导数时，导数 `f'(\xi_e)` 通过 PQ 转化为 `n_{e,a}` 的移位和 PQ 系数的乘积。这是 PQ 系数在 IBP 生成中的主要使用场景。

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

当且仅当 `n=1` 时，theta 导数产生 massless shrink sector。第一端点系数为 `-2`，第二端点为 `+2`；shrunk pack 为 `{bS}` 且整数关系 `bS=b`。这不同于 massive Wronskian shrink 的 `bS=b+1`。

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

在指标语言中表现为 `b->b+1`、`n->1-n`、分别乘 `tau[u]` 与 `tau[v]`，随后把 `v.Q[e]` 吸收到 `z/ISP` 指标。009 已为 `masslessFull` 和无 theta 的 `masslessCross` 都接入该项。

### 6.5 同顶点对多条 massless 线

同一对顶点之间多条 massless 线严格只有两个共同 theta 区域。当前实现仍逐线保留 `{b_e,n_e}`，并用 `masslessBundleCandidates` 记录可进一步合并的线组；真实 bundle canonical 留作未来优化。逐线表示必须保留每条线的有序端点，并在某条线 shrink 后应用 coincident antisymmetric zero。

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

`sp` 的 `Orderless` 只实现标量积交换性 `sp[p,q]=sp[q,p]`，不代表 Feynman 图或积分族对称性。积分族对称性依赖质量、外腿能量和动量等物理条件，当前不允许 package 自动猜测。

当前 009 case 可选输入 `symmetryRules`。`repSymmetry0[topo_]` 返回原始规则，`symmetry[expr_,topo_]` 只执行一次 `/.`；空规则保持表达式不变。pure massive bubble reference 会显式输入等质量内线交换规则，以及参考参数中两外腿动量/能量相等后才成立的附加规则。其它 benchmark 不设置对称性。
## 8. IBP 生成要点

IBP seed 包括：
- 时间 IBP：`d/d\tau_v`（`V` 个算子），处理 Heaviside delta 塌缩
- 圈动量 IBP：`q_l^\mu \partial/\partial q_l^\mu`（`L` 个标度算子），多圈时添加 `q_l^\mu \partial/\partial q_m^\mu`
- 前端关系：massless endpoint 与 `G^{+-}/G^{-+}` 简化；symmetry 下一版只应用用户输入规则，apart/scaleless 仍待实现

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
- `masslessBundleCandidates`：同一顶点对上多条 `masslessFull` 线的候选合并组。当前只用于提示 future bundle 简化，不作为生成 seed 的输入。

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

### 10.2 函数族扩展

多圈积分家族需扩展为：

$$J[\{a_v\}; \{\text{pack}_e\}; \{n_{\text{isp}_j}\}]$$

其中：
- $\{a_v\}$：顶点时间幂次
- $\{\text{pack}_e\}$：内线指标包（完整线或缩并线）
- $\{n_{\text{isp}_j}\}$：ISP 分子幂次，$n_{\text{isp}_j} \geq 0$

### 10.3 ISP 完备性验证

在生成 IBP 前，必须验证 ISP 集合的完备性：

1. **覆盖性**：所有标量积 $\{q_i \cdot q_j, q_i \cdot k_j\}$ 均可表示为用户给出的 $\{\xi_e^2\}$ 和 $\{\text{ISP}_j\}$ 的线性组合。
2. **独立性**：ISP 可以是 `sp[p,r]` 的线性组合坐标，例如 `sp[l3, k321 + l3]`；这些 ISP 坐标之间应线性无关，并且不应再由传播子平方线性表示。
3. **数目检查**：`008` 要求 `zExprs` 与 ISP 坐标总数等于独立 loop-scalar-products 数目，即 $\#z_e + \#\text{ISP}=N_{\text{sp}}$。这里的计数是用户定义的 `z/ISP` 坐标闭合条件，不是程序自动选择 propagator 子集。
4. **线性动量检查**：每条 line momentum 以及每个 `sp[p,r]` 的参数都必须是 `loopMomenta/externalMomenta` 的线性组合；若出现 `q1^2` 这类非线性写法，`validationReport` 返回 `nonLinearLineMomenta` 或 `nonLinearScalarProductArguments`。
5. **可解性检查**：数量闭合后，程序会实际构造小矩阵并尝试生成 `repSP2Z`；若传播子动量退化、重复或无法反解，会在 `validationReport` 中报告 `scalarProductCoordinateSolveFailed`，而不是等到 IBP seed 生成时报错。
6. **数值规则检查**：若拓扑包含独立外动量基，`008` 的报告和模板会列出外部不变量变量名，例如默认 `s11`、`s12` 或用户自定义名。推荐 `numericRules` 写 `s11 -> value` 或 `sigW -> value`；`sp[k_i,k_j] -> value` 只作为输入兼容形式。缺失时报 `numericRulesMissingExternalInvariants` warning，不阻止解析 seed。

其中 $N_{\text{sp}} = L(L+1)/2 + L K$，$K$ 是初始化中 `externalMomenta` 的独立外动量基个数。

本 package 的设计边界是：用户在初始化阶段给出完整的传播子动量和 ISP 定义，程序验证这组输入是否能闭合 IBP 中出现的 loop-scalar-products。对于通常的 dS 图，传播子动量加上用户指定 ISP 后应直接固定 family；多圈时常见情况是传播子平方少于全部标量积，需要 ISP 补齐，而不是程序自动从一堆 overcomplete propagators 中选 basis。若输入中存在重复/退化传播子、ISP 过多或不足、特殊数值外动量导致 rank 下降，当前主线不会自动丢弃传播子、也不会替用户重新选一组独立 propagator basis；validation 会报告 `scalarProductCoordinateCountMismatch`、`insufficientISPData` 或 `scalarProductCoordinateSolveFailed`，由用户修正 family 输入。

### 10.4 IBP 生成元

对于 $L$ 圈图，完备的 IBP 生成元集合为：

$$\mathcal{O}_{l,v} = \frac{\partial}{\partial q_l^\mu} \cdot v^\mu$$

其中 $v^\mu$ 遍历：
- $v = q_m$（$m = 1, \ldots, L$）：$L$ 个对角生成元
- $v = q_m$（$m \neq l$）：$L(L-1)$ 个交叉生成元
- $v = k_j$（$j = 1, \ldots, K$）：$LK$ 个外动量生成元，其中 $K=\#\texttt{externalMomenta}$

总计 $L(L + K)$ 个独立生成元。普通散射记号中若用户正好选择 $K=E_{\rm ext}-1$，才退化为常见的 $L(L+E_{\rm ext}-1)$ 写法；这不是本 package 的输入 convention。

### 10.5 链式法则实现

IBP 生成时，对每个生成元 $\mathcal{O}_{l,v}$：

1. **计算散度项**：$\partial \cdot v = d$（当 $v = q_l$）或 $0$（当 $v = k_j$）
2. **计算链式法则系数**：
   - 对每条线 $e$：$c_{e,l} \frac{v \cdot Q_e}{\xi_e}$
   - 对每个 ISP $j$：$v \cdot \partial_{q_l} \text{ISP}_j$
3. **作用到被积函数**：
   - 传播子部分：$b_e \to b_e + 1$ 或 $b_e - 1$
   - h-函数部分：$n_{e,a} \to n_{e,a} \pm 1$
   - ISP 部分：$n_{\text{isp}_j} \to n_{\text{isp}_j} \pm 1$
   - 顶点幂次：$a_v \to a_v \pm 1$

### 10.6 分 Sector 存储

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

当前唯一权威实现是 `000_code/008_dS_ibp_general.wl`。本设计笔记只描述当前接口，不保留旧脚本的版本差异。

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

009 当前通过独立 massive 原子 104/104、独立 massless 22/22 加易错点 8/8、pure massless bubble 70/70、symmetry/Vpm 11/11、massless 27/27、sp 24/24、缓存 8/8 和 Kira serializer smoke 11/11。serializer 检查不运行 Kira/Fermat。旧的含 massless expected 不再作为当前证据，剩余函数族必须按新 convention 重推。

这些检查不是任意拓扑的数学穷尽证明。当前只完成 massless 单线原子规则与极小 batch；新的 hand-derived 目录必须覆盖每个顶点符号组合、每个 sector 和基准 seed 点上的全部 qIBP/tIBP 生成元。

仍保留的设计项：

1. 正式 Mathematica package/context 和公开 API。
2. 独立 benchmark 的全 sector、全顶点符号与全生成元公式库。
3. 高圈 seed 的 streaming/chunking 与规模报告。
4. 同一顶点对多条 massless 线的 bundle theta canonical。
5. 用户输入 `symmetryRules` 与 `symmetry[expr_,topo_]` 的函数化应用；不自动检测图或参数对称性。scaleless、parity 等其它前端 canonical 仍待实现。
6. Rational Tracer 或其它后端 serializer。

自动运行 reduction、管理后端安装路径和导入 reduction 结果不属于本 package 的当前职责。
