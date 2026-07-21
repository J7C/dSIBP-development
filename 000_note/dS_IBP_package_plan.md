# dS IBP Package 主线计划

> 本文件是长期总体 plan，负责记录目标架构、物理 convention 和模块边界。当前逐任务状态、完成勾选和交接顺序统一记录在项目根目录 `研究计划与研究进度.md`；每次收到新任务先更新该文件，不在本 plan 中维护重复 todolist。

## 1. 目标

对任意 dS 时空 Feynman 图（任意圈数、任意拓扑、massive/massless 混合），编写 Mathematica 脚本（`.wl`），通过拓扑输入驱动通用 IBP 生成函数，自动生成经过前端 EOM/time-IBP canonical 化的 IBP 关系。Kira 输入文件只作为后端阶段输出，必须在 EOM 与 time-IBP 完整实现并通过 seed-level 检查后才开放；seed 产物保存为 MMA 表达式，不能直接导出给 Kira。

当前主线门禁：
- EOM 不是后处理选项，而是 seed 生成的一部分；任何 Hankel 二阶导数一旦产生 `n=2`，必须立刻用 EOM 递推消去。
- time-IBP 与 momentum-IBP 同属必需 seed 来源；缺少 time-IBP 时，不允许声称已经得到完整 IBP 系统。
- Kira 导出只消费 `makeLinearSystemData` 产生的 linear-system 数据，不直接消费 seed batch。`makeCanonicalSeedBatch` 会在 `MaxShrinkSectorCount` 保护内自动派生并联立 shrink sectors；若仍有 `n=2`、超过保护阈值的 shrink sector 或其它 pending feature，则不能进入 linear/Kira 阶段。当前 `makeKiraExportData` 已能写 user-defined system 文件，但调用前应先完成数值规则/撒点选择。
- 当前 012 继承 011 的 momentum/time seed、函数系统编译、公开 API 和独立变量求导，并新增 common-theta contact、可达 sector 与完整 coincidence canonical。

### P0 正确性模块：共同 theta、Wronskian 与 shrink 指标

同一当前代表顶点对上存在多条 full lines 时，time boundary 的分布定义、`WT` 调用和最终指标映射属于 IBP 正确性门禁，不是可选 bundle 优化。任何发布版本必须同时满足：

- 整个 bundle 先形成唯一共同 boundary，再转成 odd-subset contact；或使用与之严格等价的统一 mollifier，并保留全部逐线中心矩项。
- massive contact 只能读取 `WT=Det[T]W -> shrinkTerms`；普通导数只能读取 `AT -> derivativeTerms`，两条编译链不得混用。
- 每个选中 massive Laurent term 的整数 `bShift`、zero-point shift 同时进入 shrunk line 和 merged vertex；massless contact 的两类 shift 均为零。
- simultaneous contact 只合并顶点一次，但所有选中线的时间整数/零点 shift 都要累加；未选中 coincident full lines必须立即 canonical。
- sector 只枚举 contact-reachable 状态；canonical batch、linearData 和 serializer 不得重新解释或改变该 sector convention。

逐项验收记录见 `000_note/2026-07-21_common_theta_correctness_todo.md`；两种分布方案及等价性证明见技术笔记附录。

**质量参数 $\nu$**：$\nu^2 = m^2/H^2 - d^2/4$（$d=3$ 时为 $m^2/H^2 - 9/4$）。本 package 只考虑纯实数 $\nu$（重场）和纯虚数 $\nu = i\mu$（轻场）。详见 tech note §1.1。

参考：`ref_code/codebubble/001 bubble_ibp_sym.m`（命名/分段/输出习惯）、`ref_paper/2401.00129_dS_IBP.pdf`（sub-sector 缩并规则）、`ref_paper/1703.10166_SK_Diagrammatics.pdf`（Feynman 规则）。

## 2. 统一积分表示

### 2.1 核心设计

所有 sector（top sector 和所有 sub-sector）使用同一个 Head `J`，通过每条线的状态区分：

```
J[{a_1, ..., a_V}, {pack_1, ..., pack_E}, {n_isp_1, ..., n_isp_R}]
```

每条内线 `e` 的 `pack_e` 有两种状态：
- **massive 完整线**（Hankel/h building block 存在）：`{b_e, n_{e,1}, n_{e,2}}`
- **massless 完整线**（双 theta 合并路线）：`{b_e, n_e}`
- **缩并线**（theta 导数导致 h 消失）：`{bS_e}`（单元素，`bS` = "b-shrunk"）

massless 完整线的 `{b_e,n_e}` 只在双 theta 合并路线中作为正式指标包使用；本 package 不采用逐次约化单个 theta 分支作为主线。缩并线的 `bS_e` 表示该传播子的 h 函数已被 delta 函数消除，剩余的幂次结构绑定到 `k*tau`。`bS_e = 0` 对应更深一层的 sub-sector（类似平直时空中传播子幂次 >= 0 的 sub-sector 链）。

### 2.2 masslessFull 的有序端点与单 `n`

对 `lineData` 中

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

因此旧的双端点临时标签若只用于推导，满足 `{10}=-{01}`、`{20}={02}=-q^2{00}`、`{11}=+q^2{00}`。正式指标不保存这些双端点标签，也不产生含混的 massless `n=2`；程序直接在 `n=0,1` 间翻转。完整 theta kernel 的导数为

```
d_u M[n] =  I sigma q M[1-n] - 2 n delta[tau[u]-tau[v]]
d_v M[n] = -I sigma q M[1-n] + 2 n delta[tau[u]-tau[v]]
```

故 regular 指标变化为 `{b,n}->{b-1,1-n}`，第一/第二端点系数分别为 `+I sigma` / `-I sigma`。连续在同一端点作用两次会得到 `-J[...,{b-2,n},...]`，这就是同端点二阶导数回到原 `n` 的负号。只在 `n=1` 时出现 theta-delta contact；massless 缩并线使用 `{bS}` 且整数部分 `bS=b`、merged `a` 不移位，不同于 massive Wronskian 的 `bS=b+1`、merged `a` 减 1。

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

007--010 的 h/H 路径使用内置递推。011 保留 `bbType`/`eomCoefficients` 兼容输入，但初始化时一律转成 `functionSystem` 并编译；裸 H 的 `nu^2/x^2` 由 `AT` 的普通 Laurent 项生成，不再在 IBP 层特判。

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

对 masslessFull 的 `{b_e,n_e}`，缩并只在 `n_e=1` 发生：第一/第二端点系数为 `-2/+2`，缩并后 `pack_e={bS_e}` 且 `bS_e=b_e`。若两端点在当前或目标 sector 已 coincident，则两端点贡献必须成对相消，不再生成该 shrink 项。

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
2. **ISP 分子因子**：$(q_l \cdot q_m)^{n_{\text{isp}}}$ 或 $(q_l \cdot k_j)^{n_{\text{isp}}}$（不可约标量积，见 §4.3.4）
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
- ISP 因子：$\partial_{\text{isp}} [\text{isp}^n] = n\, \text{isp}^{n-1}$ → $n_{\text{isp}} \to n_{\text{isp}}-1$

**实现**：`applyIBPOperator[l, v, J[indices]]` 将复合算符作用在指标表示的积分上，输出为 shifted-$J$ 的线性组合。

#### 4.3.3 完备 IBP 生成元集合（FIRE7 框架）

对 $L$ 圈积分，设 `externalMomenta` 中有 $K$ 个独立外动量向量。这里的外动量向量只指实际进入内线动量偏移 $Q_e=\sum_l c_{e,l}q_l+P_e$、并会在 $Q_e^2$ 或 $q_l\cdot Q_e$ 中和圈动量发生标量积的三动量方向。只出现在 dS 顶点时间相位中的无质量外腿能量模或能量组合不计入 `externalMomenta`；独立能量参数内部建议记为 `ke[i]`，例如 `|k_1+k_5|` 可记为 `ke[3]`。完备的 IBP 生成元为：

$$\boxed{\mathcal{O}_{l,v} = \frac{\partial}{\partial q_l^\mu} \cdot v^\mu, \quad l \in \{1,\ldots,L\}, \quad v^\mu \in \{q_1^\mu, \ldots, q_L^\mu, k_1^\mu, \ldots, k_K^\mu\}}$$

总数 $N_{\text{IBP}} = L(L + K)$，分解为：

| 类型 | 生成元 | 数量 | 作用 |
|------|--------|------|------|
| 对角（scale） | $\partial_{q_l} \cdot q_l$ | $L$ | 每圈标度 IBP |
| 交叉（cross） | $\partial_{q_l} \cdot q_m\ (l \neq m)$ | $L(L-1)$ | 耦合不同圈动量 |
| 外动量（special） | $\partial_{q_l} \cdot k_j$ | $LK$ | 连接外动量 |

**交叉 IBP 的必要性**：$L \geq 2$ 时，仅对角 IBP 不足以将所有积分约化到 master integrals。交叉 IBP $\partial_{q_l} \cdot q_m$ 提供不同圈动量之间的关系，是完备约化系统所必需的。

**验证**：独立 loop-scalar-products 数目 $N_{\text{sp}} = L(L+1)/2 + L K$（$K$ 为 `externalMomenta` 的独立外动量基个数）与需要闭合的 $z/ISP$ 坐标维度匹配。这里不把顶点能量符号（如独立 `ke[i]`）算入标量积空间。

#### 4.3.4 ISP（不可约标量积）处理

**定义**：给定拓扑的传播子 $\{\xi_e^2\}$，所有标量积 $\{q_l \cdot q_m,\, q_l \cdot k_j\}$ 中不能表示为 $\xi_e^2$ 线性组合的，称为 ISP。

**函数族扩展**：积分家族增加 ISP 指标：

$$J[\{a_v\}, \{\text{pack}_e\}, \{n_{\text{isp}_j}\}]$$

ISP 指标 $n_{\text{isp}_j} \geq 0$（仅出现在分子，不出现在分母）。

**当前用户输入**：

```mathematica
(* 用户可任意命名 loop/external momenta；标量积统一写 sp[p,r]。 *)
loopMomenta = {l3, k321};
externalMomenta = {wdnmd};

(* 只出现在顶点相位的能量模之和不属于 externalMomenta。 *)
vertexEnergies = <|1 -> ke[1], 2 -> Sqrt[s11]|>;

(* ISP 定义：{名称, sp 标量积表达式, 指标范围} *)
ispData = {
  {rhoA, sp[l3, wdnmd + l3], {0, 1}},
  {rhoB, sp[k321, wdnmd], {0, 1}}
};
```

`sp` 表示 scalar product，并设置为 `Orderless`，所以 `sp[p,r]` 与 `sp[r,p]` 自动相同。它主要用于输入传播子动量相关的标量积与 ISP，其中 `p,r` 必须先是 `loopMomenta/externalMomenta` 的线性组合，不能写成 `q1^2` 这类非线性表达式。外动量-外动量不变量在输出端使用变量名，不保持 `sp[k_i,k_j]` 形式；用户可设 `externalInvariantRules -> {sp[k1,k1] -> s11, sp[k1,k2] -> s12}`，未设时默认按 `externalMomenta` 的位置输出 `sij`（`i<=j`）。内部仍会把 `sp` 展开到编号坐标做线性代数，但用户不需要输入 `qq/qk/kk`。`vertexEnergies` 的每个值表示一个顶点连着的所有外腿打包后的 e 指数能量；若它和 `externalMomenta` 张成空间中的外部不变量是同一变量，优先写成外部不变量变量名的表达式；若不是，则作为独立 `ke[i]`。不同外腿能量参数之间不做点积，`|ke1+ke2|`、`|ke1|`、`|ke2|` 若独立就应分别命名，例如 `|ke1+ke2|` 另记为 `ke[3]`。`vertexEnergies` 中不能直接写 `loopMomenta/externalMomenta` 的向量符号，也不能写圈相关 `sp[q,k]`；属于外动量空间时写外部不变量变量名表达式，否则写独立 `ke[i]`。

**完备性验证**：`verifyISP[topology, ispData]` 检查：
1. 所有标量积 $\{q_l \cdot q_m,\, q_l \cdot k_j\}$ 均可表示为 $\{\xi_e^2\}$ 和 $\{\text{isp}_j\}$ 的线性组合
2. ISP 之间线性无关；当前 ISP 表达式可为 `sp[p,r]` 或其线性组合坐标，不要求直接是某个内部编号变量
3. `zExprs` 与 ISP 坐标总数等于独立标量积数量，即 $\#z_e + \#\text{ISP}=N_{\text{sp}}$
4. line momentum 与 `sp[p,r]` 参数必须是声明动量基的线性组合；非线性输入会触发 `nonLinearLineMomenta` 或 `nonLinearScalarProductArguments`
5. 数量闭合后必须能实际反解出 `repSP2Z`；重复或退化传播子动量会触发 `scalarProductCoordinateSolveFailed`
6. 若要进入数值 linear/Kira 阶段，`numericRules` 应覆盖全部外部不变量和顶点能量符号；外部不变量的推荐写法是输出变量名规则，如自定义 `sigW -> value` 或默认 `s11 -> value`，`sp[k_i,k_j] -> value` 只作为输入兼容形式；独立顶点能量符号写 `ke[i] -> value`；若 `vertexEnergies` 已写成 `Sqrt[s11]` 这类外部不变量表达式，则只需给对应外部不变量数值

这里验证的是用户初始化给出的 `z/ISP` 坐标系是否闭合。程序不把 dS 图默认理解为 overcomplete propagator family，也不自动挑选独立传播子子集；若计数不闭合、ISP 不足/过多、传播子动量退化或特殊数值外动量导致不可反解，validation report 直接报错，用户应修正传播子动量或 ISP 输入。

验证通过后，才进入 IBP 生成步骤。

#### 4.3.5 分 Sector IBP 生成流程

```
1. 读取拓扑 + ISP 配置
2. 验证 ISP 完备性
3. 构造 IBP 生成元集合 {O_{l,v}}（L(L+K) 个，K 为 `externalMomenta` 中独立外动量向量个数）
4. 对每个 sector（由缩并线集合标记）：
   a. 构造该 sector 的指标盒子 {a_v, b_e, n_{e,a}, n_isp}
   b. 枚举种子（撒点范围控制）
   c. 对每个连续种子，先枚举该 sector 中所有离散
` 状态（massive 端点 `0/1`，massless 合并态 `0/1`）。
   d. 对每个离散态和每个生成元 O_{l,v}：
      - 应用链式法则 → z/ξ-导数 + ISP-导数 + 相位项
      - 转化为指标移位算符，包含传播子幂次项与 building-block 导数项
      - 立即应用 EOM 递推，递归消去所有
>=2`
      - 应用 massless 双 theta 合并关系，把结果保持在 `{b_e,n_e}` 包内
      - 扫描结果，若仍有
=2` 或未识别 pack，直接报错而不是继续导出
   e. 保存 EOM-canonical IBP 方程，命名区分 sector 与生成元类型
5. 输出：按 sector 分组的 IBP seed 文件或 MMA seed batch。后续 linear/Kira 只能读取这些 canonical seed 转成的 linear-system。
```

**命名规则**（建议）：`IBP_sector_<shrunkLines>_seed_<seedIndex>.dat`

例如：`IBP_sector_none_seed_001.dat`（top sector），`IBP_sector_e3_seed_012.dat`（线 3 缩并）。

### 4.3.6 独立变量微分方程 seed

微分方程阶段需要生成 $\partial_x J$。本 package 把独立变量分成两类：

1. 顶点外腿能量参数，例如 `ke[i]`。这些变量只进入 `vertexEnergies` 中的 e 指数相位，不进入 `externalMomenta` 或 loop-scalar-product 完备性。
2. 外动量不变量，例如默认 `s11/s12/...` 或用户在 `externalInvariantRules` 中指定的变量名。这些变量来自 `externalMomenta` 的 Gram 坐标。

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
```

`applyIndependentVariableDerivativeSeed` 自动判断 `var` 属于外不变量还是独立顶点能量。外不变量分支会把每个 $D_{ij}$ 作用到传播子、massive/massless building block、ISP/numerator 和可能写成 `Sqrt[sij]` 的顶点能量表达式。

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

独立标量积分三类，其中 $K=\#\texttt{externalMomenta}$ 只统计进入内线动量偏移的外部三动量向量：

| 类型 | 记号 | 数量 |
|------|------|------|
| 圈-圈标量积 | $q_l \cdot q_m$（$l \leq m$） | $L(L+1)/2$ |
| 圈-外动量标量积 | $q_l \cdot k_j$ | $LK$ |
| 外动量-外动量标量积 | $k_i \cdot k_j \to s_{ij}$ 或用户自定义名 | 常数，不计入独立变量 |

独立 loop-scalar-products 总数 $N_{\text{sp}} = L(L+1)/2 + LK$。顶点相位中的 $|k|$ 或 $|k_a|+|k_b|$ 是能量参数，不是这个标量积向量的分量。

外动量-外动量标量积记为符号常数，不保持矢量点积形式。当前输出端用 `externalInvariantRules` 给出的变量名；若未指定，则默认按 `externalMomenta` 中的位置记为 $s_{ij}$。对 $d=3$ bubble 例子（$L=1$，$E=2$，1 独立外动量 $k \equiv k_1$）：
$$N_{\text{sp}} = 1 + 1 = 2, \quad \text{独立标量积：} q_1^2,\; q_1 \cdot k, \quad \text{外部不变量：} k^2 \equiv s_{11}\ \text{(或用户自定义名)}$$

#### 4.4.3 $z$ 与标量积的线性变换

每条内线的 $z_e$ 展开为标量积的线性组合加外部不变量：
$$z_e = Q_e^2 = \left(\sum_l c_{e,l}\, q_l + P_e\right)^2 = \sum_l c_{e,l}^2\, q_l^2 + 2\sum_{l<m} c_{e,l}\, c_{e,m}\, q_l \cdot q_m + 2\sum_l c_{e,l}\, q_l \cdot P_e + P_e^2$$

其中 $P_e^2$ 和 $q_l \cdot P_e$（$P_e$ 为外动量线性组合）均可进一步展开为 $\{q_l \cdot q_m,\; q_l \cdot k_j\}$ 加外动量不变量名（默认 $s_{ij}$ 或用户自定义名）的线性组合。

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
(* 顶点 *)
vertexData = {{1, "+"}, {2, "+"}, ...};

(* 内线: {编号, {起点,终点}, 动量符号, nu, bbType} *)
lineData = {
  {1, {1, 2}, q1, nu1, "h"},     (* 线 1: h 函数 *)
  {2, {1, 2}, q2, nu2, "H"},     (* 线 2: 裸 Hankel；内置含二次-pole EOM *)
  {3, {2, 3}, q3, nu3, {q1val, q2val, spval}}  (* 线 3: 自定义 *)
};

(* 推荐内线格式: Association，显式给出不写入 J 指标的物理 metadata *)
lineData = {
  <|
    "id" -> 1,
    "endpoints" -> {1, 2},
    "momentum" -> q1,
    "nu" -> nu1,
    "bbType" -> "h",
    "massType" -> "massive",
    "skType" -> "++",
    "thetaConvention" -> "mergedTwoTheta",
    "packType" -> Automatic
  |>,
  ...
};

(* 外腿 *)
extLegs = {{B, 1, p1}, {B, 2, p2}, ...};

(* 圈动量与独立外动量基 *)
loopMomenta = {q1, q2, ...};
externalMomenta = {k1, k2, ...};
vertexEnergies = <|v1 -> ke[1], v2 -> Sqrt[s11], ...|>;  (* 独立顶点能量用 ke[i]；可复用外部不变量表达式 *)

(* ISP: {名称, sp 标量积表达式, 指标范围} — 多圈时必需 *)
ispData = {
  {isp1, sp[q1, q2], {0, 2}},     (* q1·q2，分子幂次 0,1,2 *)
  {isp2, sp[q1, k1], {0, 1}}      (* q1·k1，分子幂次 0,1 *)
};
(* 单圈时可省略 ispData（无 ISP），但仍需显式给 externalMomenta = {k} 等外动量基 *)

(* 指标范围 *)
indexRanges = {aMin, aMax, bMin, bMax, bSMin, bSMax};

(* 撒点范围 *)
seedRange = {-3, 3};  (* 可选, 缺省 {-3,3} *)
(* 可选积分族对称性：只由用户在确认质量和外参条件后输入 *)
symmetryRules = {
  HoldPattern[J[{av1_, av2_}, {pack1_, pack2_}, isp_]] /;
      ! OrderedQ[{pack1, pack2}] :>
    J[{av2, av1}, {pack2, pack1}, isp]
};
```

必须一开始设定但不写进指标里的信息包括：顶点 SK 符号、内线的 `massType/bbType/skType/thetaConvention`、圈动量基、独立外动量向量基、顶点能量符号 `vertexEnergies`、ISP 配置、零点规则、缩并 prefactor 规则、用户确认后的 `symmetryRules` 和 seed 幂次范围。这样 `J` 只承载动态指标，物理类型与初始化 convention 不混进指标本体。

## 6. 脚本结构

```
(* ::Package:: *)

(* ::Chapter:: *) Initialization & Definitions
  (* ::Section:: *) Environment Setup
  (* ::Section:: *) Topology Input           — vertexData, lineData, extLegs
  (* ::Section:: *) Topology Parser          — 关联矩阵, 指标位置, bbType 展开
  (* ::Section:: *) Index Manipulation       — shiftA, shiftB, shiftN, shiftBS
  (* ::Section:: *) Building Block Defaults  — bbDefault["h"/"H"] 内置定义
  (* ::Section:: *) EOM Rules Generator      — 从 bbType 自动构造 id[]
  (* ::Section:: *) IBP Generator            — makeIBP[integrand, tau[v]/q[l]]
  (* ::Section:: *) Seed Generation          — 连续种子 × 离散 n=0/1, 施加 IBP, 立即 EOM canonical
  (* ::Section:: *) Parameter Substitution   — repvar, reppara2N
  (* ::Section:: *) Export                   — 仅对 EOM/time-IBP 完备后的 canonical 方程开放

(* ::Chapter:: *) Check & Validation
  (* ::Section:: *) Compare with Reference
```

## 7. 当前主线与工作流

当前唯一权威实现是 `000_code/012_dS_ibp_general.wl`。011 保留为上一开发版及 v011 外部报告对应基线；本文不维护更早脚本的功能差异。

独立 benchmark 的程序交付位于 `independent-benchmark/package/`，当前只含 `package_012.wl`、由正式用户手册生成的 `package_012.pdf` 和少量不含 expected 的应用 examples。独立推导阶段不得读取该目录；结果冻结后才用于学习调用和自行对照。更新交付时按 `package_<版本号>` 命名，并删除旧版程序、旧版手册和无版本名副本。

主线按照以下顺序工作：

1. `makeTopologyData` 读取 topology、动量基、传播子、ISP、零点和数值规则，并缓存 index maps 与 sector metadata。
2. topology validation 检查动量线性、`z/ISP` 坐标闭合、离散态配置、数值规则覆盖和规模门禁。
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

package 默认不安装、配置或运行 Kira/Rational Tracer，不保存本机可执行文件路径，也不导入 reduction/master 结果。

## 8. 当前未实现与下一步
本节只保留长期能力缺口，不表示当前执行顺序。当前正在做什么、哪些检查尚未通过以及下一位接手者的第一步，以根目录 `研究计划与研究进度.md` 为准。

### 8.1 发布前优先项

1. 把当前可 `Get` 的科研脚本封装为正式 Mathematica package：`BeginPackage/EndPackage`、独立 context、公开 API 的 `::usage` 和最小加载示例。
2. 补充真正独立来源的 benchmark 数据集：对规定拓扑覆盖全 sector、全部顶点正负选择，并在每个基准 seed 点给出该 sector 的全部 qIBP 与 tIBP 生成元关系。
3. 为高圈输入增加 streaming/chunked seed 生成和更明确的标量积求解规模报告；当前指数增长主要由数量门禁早停。

### 8.2 可选优化

- 用户输入的 `symmetryRules` 与函数化 `symmetry[expr_,topo_]` 已实现；自动图 automorphism/参数对称性检测仍不实现。scaleless sector 筛选和一般 parity selection 继续作为可选优化。
- 自动从重复或退化的传播子输入中选择独立 basis。当前要求用户直接给出可反解的传播子 + ISP family。
- Rational Tracer 或其它后端 serializer。

这些优化不改变当前主线的物理 convention。特别是纯 massless 与 mixed case 都固定使用双 theta 合并路线，不提供单 theta 路线开关。

## 9. 验证范围与性能红线

012 当前通过：修正后 10 family 回归（atomic massless 22/22+8/8、atomic massive 104/104、pure massless 64/64、mixed bubble 132/132、triangle 1792/1792、pure massive 608/608、parallel massless 194/194、mixed sunrise 1842/1842、two-loop ISP 978/978、vertex energy 90/90）及 theta/report audit 30/30。011 的函数系统、独立变量、公开 API 与 serializer 检查作为继承回归；不运行 Kira/Fermat。

这些数字是检查断言数，不等于独立手推公式数。当前结论是“生成器未硬编码 bubble，并通过代表性 topology 与微分方程变量求导回归”，不是“已对所有拓扑给出数学穷尽证明”。

- 严禁默认生成整族解析 IBP 方程组并做全局化简。
- seed 可保持小规模解析；需要 rank/span 或后端验证时先给参数代数数值，再做小范围撒点。
- 不对大符号矩阵执行解析 `MatrixRank`，不无门禁遍历 massive 离散态或 shrink sectors。
- 所有输出 seed 必须确认 massive 无 `n>=2`；massless 只能是 `n=0/1`，且不能遗漏 `n=1` 的 theta boundary。
- Kira 检查只验证基础文件转换；实际 reduction 属于独立任务。

## 10. 约定总结

| 项目 | 当前约定 |
|------|----------|
| 主线脚本 | `000_code/012_dS_ibp_general.wl` |
| 积分 Head | `J[aList, linePacks, ispList]` |
| massive full/cross pack | `{b_e,n_{e,1},n_{e,2}}` |
| massless full pack | `{b_e,n_e}`，双 theta 合并 |
| massless cross pack | `{b_e}` |
| theta-boundary shrunk pack | `{bS_e}`；massive `bS=b+1`，massless `bS=b` |
| Hankel 离散态 | seed 层枚举 `n=0,1`，`n>=2` 立即 EOM |
| Sub-sector | 同一 Head `J`，compact `aList` + sector metadata |
| 数值规则 | 解析 seed 后，在 sampled/linear/backend 层应用 |
| 后端输入 | 只接收 `linearData`，不直接接收 seed |
| 后端职责 | 只转换文件；不安装、不配置、不运行 reduction |

## 11. 原子化公开接口

012 继承以下公开接口。`J` 不携带 topology，因此推荐显式传入 `topo`；也可先调用 `setIBPTopologyContext[topo]` 再使用短签名。

### 11.1 指定生成元作用

- `dtau[i, expr, topo]` / `dtau[i, expr]`：对 active vertex `tau[i]` 生成时间全微分关系。
- `dqq[i, j, expr, topo]` / `dqq[i, j, expr]`：生成 `d/dq_i . q_j` 的复合圈动量 IBP。
- `dqk[i, j, expr, topo]` / `dqk[i, j, expr]`：生成 `d/dq_i . k_j` 的复合圈动量 IBP。

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
- 外部不变量的默认 `sij` 或用户自定义名字；
- 用户 ISP 名与内部 `rho[j]`；
- 必要的 coefficient-only 参数命名。

这两个函数只转换系数和标量积表示，不改变 `J` 的三个指标槽，不重排 line packs，也不修改任何 `a/b/n/ispN` 指数。用户可以显式在任一阶段调用它们；package 的公开输出默认经过 `rep2outform`。

### 11.3 指标积分到被积函数

`rep2Integrand[expr,topo]` 把含 `J` 的表达式线性地展开为被积函数表示，用于人工检查和手推 benchmark：

- 时间幂次 `Product[(-tau[v])^(a[v]+a0[v]),v]` 直接相乘；
- 每条线的简单分母 `xi[e]^(-(b[e]+b0[e]))` 直接相乘；
- 每条未缩并传播子的非平凡 Hankel/指数/theta 部分用惰性包装 `Hh[传播子部分表达式]` 标记，避免与普通幂次混淆；
- ISP 分子按第三槽指数相乘；
- shrunk line 不再保留原传播子的 `Hh`；
- compact `aList`、zero-point 与原拓扑的对应从 `sectorMetadata` 读取。

`rep2Integrand` 只做表示展开，不执行积分、不生成 IBP、不应用 EOM。011 的 `011_public_api_check.wl` 已覆盖 inner/out round-trip、`J` 指标保持和 inert `Hh` 展开。
### 11.4 用户输入的积分族对称性

- `symmetryRules`：case/topology 的可选替换规则列表。用户负责确认质量相等、外腿能量相等或其它参数条件确实成立。
- `repSymmetry0[topo_]`：返回规则本身，可直接用于 `/.`。
- `symmetry[expr_,topo_]`：单次函数化应用 `expr /. repSymmetry0[topo]`。
- 没有规则时返回原表达式。
- package 暂不自动检测图 automorphism 或由特殊参数取值产生的额外对称性，也不使用 `ReplaceRepeated` 自动迭代规则。
- 新 benchmark 只在 pure massive bubble reference 中输入对称性：既测等质量内线交换，也测参考参数中两外腿动量/能量相同带来的额外关系；其它函数族保持 `symmetryRules -> {}`。
