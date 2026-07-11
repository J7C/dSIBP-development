# dS IBP 脚本实现计划（v4）

## 1. 目标

对任意 dS 时空 Feynman 图（任意圈数、任意拓扑、massive/massless 混合），编写 Mathematica 脚本（`.wl`），通过拓扑输入驱动通用 IBP 生成函数，自动生成经过前端 EOM/time-IBP canonical 化的 IBP 关系。Kira 输入文件只作为后端阶段输出，必须在 EOM 与 time-IBP 完整实现并通过 seed-level 检查后才开放；seed 产物保存为 MMA 表达式，不能直接导出给 Kira。

当前主线门禁：
- EOM 不是后处理选项，而是 seed 生成的一部分；任何 Hankel 二阶导数一旦产生 `n=2`，必须立刻用 EOM 递推消去。
- time-IBP 与 momentum-IBP 同属必需 seed 来源；缺少 time-IBP 时，不允许声称已经得到完整 IBP 系统。
- Kira 导出只消费 `makeLinearSystemData` 产生的 linear-system 数据，不直接消费 seed batch。`makeCanonicalSeedBatch` 会在 `MaxShrinkSectorCount` 保护内自动派生并联立 shrink sectors；若仍有 `n=2`、超过保护阈值的 shrink sector 或其它 pending feature，则不能进入 linear/Kira 阶段。当前 `makeKiraExportData` 已能写 user-defined system 文件，但调用前应先完成数值规则/撒点选择。
- 当前代码已完成 momentum seed 的传播子项、z/ISP 吸收、massive building-block 导数项、shrunk-line `bS` 幂次项和 EOM 门禁；time-IBP 已接入顶点幂次、外部相位、massive 端点导数、massless 端点翻转、massive theta boundary shrink core 和 EOM/massless endpoint canonical 门禁；canonical batch 已能在保护阈值内自动派生 shrink sectors 并合并其 time/momentum seed。Kira user-defined system 导出已开放给 linear-system 小样本检查，但不运行 Kira 约化。

**质量参数 $\nu$**：$\nu^2 = m^2/H^2 - d^2/4$（$d=3$ 时为 $m^2/H^2 - 9/4$）。本 package 只考虑纯实数 $\nu$（重场）和纯虚数 $\nu = i\mu$（轻场）。详见 tech note §1.1。

参考：`ref_code/codebubble/001 bubble_ibp_sym.m`（命名/分段/输出习惯）、`ref_paper/2401.00129_dS_IBP.pdf`（sub-sector 缩并规则）、`ref_paper/1703.10166_SK_Diagrammatics.pdf`（Feynman 规则）。

## 2. 统一积分表示

### 2.1 核心设计

所有 sector（top sector 和所有 sub-sector）使用同一个 Head `J`，通过每条线的状态区分：

```
J[{a_1, ..., a_V}, {pack_1, ..., pack_E}]
```

每条内线 `e` 的 `pack_e` 有两种状态：
- **massive 完整线**（Hankel/h building block 存在）：`{b_e, n_{e,1}, n_{e,2}}`
- **massless 完整线**（双 theta 合并路线）：`{b_e, n_e}`
- **缩并线**（theta 导数导致 h 消失）：`{bS_e}`（单元素，`bS` = "b-shrunk"）

massless 完整线的 `{b_e,n_e}` 只在双 theta 合并路线中作为正式指标包使用；本 package 不采用逐次约化单个 theta 分支作为主线。缩并线的 `bS_e` 表示该传播子的 h 函数已被 delta 函数消除，剩余的幂次结构绑定到 `k*tau`。`bS_e = 0` 对应更深一层的 sub-sector（类似平直时空中传播子幂次 >= 0 的 sub-sector 链）。

### 2.2 Sub-sector 层级

sub-sector 不再用不同 Head（G/R1/R2）区分，而是通过哪些线处于缩并状态来标记：

| Sub-sector | 缩并线 | pack 结构 |
|-----------|--------|----------|
| Top sector | 无 | 所有线 `{b, n1, n2}` |
| 1-line shrink | 线 e 缩并 | `pack_e = {bS_e}`，其余不变 |
| 2-line shrink | 线 e1, e2 缩并 | `pack_{e1} = {bS_{e1}}`, `pack_{e2} = {bS_{e2}}` |

### 2.3 缩并的零点分解

缩并因子的幂次取决于 building block 类型（详见 tech note §4.5, §5）：

**h 模式**：缩并因子 $(k_e \tau_v)^{-(2\nu_e+1)}$，分解为：
$$-(2\nu_e + 1) = \underbrace{-1}_{\text{整数 → 指标}} + \underbrace{(-2\nu_e)}_{\text{非整数 → 零点}}$$

**H 模式**：缩并因子 $F_H = (-k) \cdot W[H_\nu^{(1)}, H_{\nu^*}^{(2)}]$。数值验证给出精确公式 $W[H_\nu^{(1)}, H_{\nu^*}^{(2)}] = -e^{\pi \text{Im}[\nu]} \frac{4i}{\pi z}$（对纯实数和纯虚数 $\nu$ 均成立），故 $F_H = e^{\pi \text{Im}[\nu]} \frac{4i}{\pi} (-k\tau)^{-1}$。$\tau$ 依赖为纯 $1/z$（整数幂次 $-1$），零点无移位。prefactor $= e^{\pi \text{Im}[\nu]} \frac{4i}{\pi}$（与 h 模式相同）。

**无质量**：无 Hankel 缩并机制（模式函数为 $e^{\pm ik\tau}$，无 building block Wronskian）。

**对 $a$（正幂次，$(-\tau)^{a+a0}$）：**
- 指标移位（h/H 整数部分相同）：$a_{\text{merged}} = a_u + a_v - 1$
- 零点移位（h 模式）：$a0_{\text{merged}} = a0_u + a0_v - 2\nu_e$
- 零点移位（H 模式）：$a0_{\text{merged}} = a0_u + a0_v$（Wronskian 给出纯 $1/z$，无非整数部分）

**对 $b$（分母幂次，$q^{-(b+b0)}$）：**
- 指标移位（h/H 整数部分相同）：$bS_e = b_e + 1$
- 零点移位（h 模式）：$bS0_e = b0_e + 2\nu_e$
- 零点移位（H 模式）：$bS0_e = b0_e$（Wronskian 给出纯 $1/z$，无非整数部分）

注意 $b$ 的物理幂次 = $-b$，故物理幂次移位 $-(2\nu+1)$ 对应 $b+b0$ 移位 $+(2\nu+1) = +1 + 2\nu$。

### 2.4 缩并常数 prefactor

每次缩并产生常数 prefactor $\mathcal{C}_e$，乘入 sub-sector 方程系数（详见 tech note §5.3）：

| 模式 | $\mathcal{C}_e$ | 说明 |
|------|----------------|------|
| `"h"` | $\frac{4i}{\pi} e^{\pi \text{Im}[\nu_e]}$ | $e^{\pi\text{Im}[\nu]}$ 来自 $h^{(2)}$ 使用 $H_{\nu^*}^{(2)}$ 与归一化 $(-k\tau)^{-\nu}$ 的共同作用 |
| `"H"` | $\frac{4i}{\pi} e^{\pi \text{Im}[\nu_e]}$ | 与 h 模式相同，来自 cross-order Wronskian $W[H_\nu^{(1)}, H_{\nu^*}^{(2)}] = -e^{\pi \text{Im}[\nu]} \frac{4i}{\pi z}$（已数值验证） |
| 无质量 | $1$ | 无 prefactor |

多次缩并：$\mathcal{C}_{\text{total}} = \prod_{e \in \text{shrunk}} \mathcal{C}_e$。

在 package 实现中，$\mathcal{C}_e$ 作为缩并线属性存储，导出 Kira 输入时乘入系数。

### 2.5 指标零点初始设置

脚本初始化时为所有指标设定零点：

| 模式 | $a0_v$ 缺省 | $b0_e$ 缺省 |
|------|------------|------------|
| `"h"` | $2\nu_{\text{ref}}$ | $-2\nu_e$ |
| `"H"` | $0$ | $0$ |

验证：参考代码 `reppara2N` 给出 $a0 \to 2\nu$, $b0 \to -2\nu$，与 h 模式缺省一致。

## 3. Building Block 参数体系

### 3.1 三类选法

每条内线有一个 building block 类型参数 `bbType_e`，三种填法：

| 填法 | 含义 | 实际展开 |
|------|------|---------|
| `"h"` | h 函数（dS IBP 文献的归一化 building block） | `{Q1_h, Q2_h, shrinkPow_h}` |
| `"H"` | Hankel 函数 `H_nu^(1)` | `{Q1_H, Q2_H, shrinkPow_H}` |
| `{q1, q2, sp}` | 自定义 | `{q1, q2, sp}` 直接指定 |

其中：
- `q1` = EOM 一阶导数系数（`u'` 的系数）
- `q2` = EOM 零阶系数（`u` 的系数）
- `sp` = 缩并时产生的 `k*tau` 幂次（绑定到 `k*tau`）

### 3.2 内置定义

```mathematica
(* h 函数: ODE 系数 + 缩并幂次 *)
(* ODE: h'' + Q1*h' + Q2*h = 0 *)
(* 缩并幂次 sp = -(2ν+1)，来自 F_h ∝ (-kτ)^{-2ν-1} *)
bbDefault["h", nu_, dim_, k_] := {
  (2*nu + 1)/tau,                            (* Q1: 摩擦项 *)
  k^2,                                        (* Q2: 有效势（简化形式） *)
  -(2*nu + 1)                                 (* sp: 缩并幂次 *)
};

(* Hankel 函数: ODE 系数 + 缩并幂次 *)
(* ODE: H'' + Q1*H' + Q2*H = 0 (Bessel 方程) *)
(* 缩并幂次 sp = -1，来自 F_H ∝ (-kτ)^{-1} *)
bbDefault["H", nu_, dim_, k_] := {
  1/tau,                                      (* Q1: 1/z 项 *)
  1 - nu^2/(k*tau)^2,                         (* Q2: Bessel 方程 *)
  -1                                          (* sp: 缩并幂次 *)
};
```

注意：`bbDefault` 返回 `{Q1, Q2, sp}`（ODE 系数 + 缩并幂次），与 design note 的 `{c1, c2, sp}`（EOM 递推系数）不同。两者关系：$c_1 = 2\nu+1$（h 模式）或 $2\nu$（H 模式），$c_2 = 1$，$c_1$ 和 $Q_1$ 通过导数链式法则联系。

### 3.3 EOM 递推

由 building block 参数自动构造 EOM 替换规则：

对完整线 `e`（状态 `{b_e, n_{e,1}, n_{e,2}}`），指标 
_{e,a} = 2` 时：
```
J[..., {b_e, ..., 2, ...}, ...] ->
  -q1_e * J[..., {b_e+1, ..., 1, ...}, ...]   (* n=1, b shift *)
  -q2_e * J[..., {b_e, ..., 0, ...}, ...]     (* n=0 *)
```

其中 `q1_e`, `q2_e` 来自 `bbType_e` 的展开。具体 shift 结构（哪些 a_v 和 b_e 变化）由 h/H 的导数链式法则决定。

### 3.4 缩并规则

时间 IBP 对 theta 函数求导产生 delta 时，线 `e` 从完整变为缩并：

```
delta(tau_{u[e]} - tau_{v[e]}) * J[..., {b_e, n_{e,1}, n_{e,2}}, ...]
-> J[..., {bS_e}, ...]  (* 线 e 缩并 *)
   * (a_{u[e]} += shrinkPow_e)  (* 额外 tau 幂次吸收 *)
   * (bS_e = b_e + bShiftShrink_e)  (* 缩并线的初始幂次 *)
```

## 4. 通用 IBP 生成函数

### 4.1 设计原则

一个函数 `makeIBP[integrand, var]` 对任意被积函数（带符号指标 `a_v, b_e, n_{e,a}` 或具体数值指标）生成 IBP：

- `var = tau[v]`：对顶点 v 的共形时间求全微分
- `var = q[l]`：对圈动量 l 求散度 `q_l^mu d/d q_l^mu`

函数内部读取每条线的当前状态（完整/缩并、building block 类型），自动决定：
- 是否需要对 h/H 部分求导（完整线需要，缩并线不需要）
- EOM 系数取什么值
- 缩并产生什么 sub-sector

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
- h-函数：$\partial_{\xi_e} h(\nu, 0) = h(\nu, 1)$，$\partial_{\xi_e} h(\nu, 1)$ 由 ODE 给出 $h(\nu, 0)$ 和 $h(\nu, 1)$ 的组合
- ISP 因子：$\partial_{\text{isp}} [\text{isp}^n] = n\, \text{isp}^{n-1}$ → $n_{\text{isp}} \to n_{\text{isp}}-1$

**实现**：`applyIBPOperator[l, v, J[indices]]` 将复合算符作用在指标表示的积分上，输出为 shifted-$J$ 的线性组合。

#### 4.3.3 完备 IBP 生成元集合（FIRE7 框架）

对 $L$ 圈积分，独立外动量 $E-1$ 个（动量守恒 $\sum p_i = 0$），完备的 IBP 生成元为：

$$\boxed{\mathcal{O}_{l,v} = \frac{\partial}{\partial q_l^\mu} \cdot v^\mu, \quad l \in \{1,\ldots,L\}, \quad v^\mu \in \{q_1^\mu, \ldots, q_L^\mu, k_1^\mu, \ldots, k_{E-1}^\mu\}}$$

总数 $N_{\text{IBP}} = L(L + E - 1)$，分解为：

| 类型 | 生成元 | 数量 | 作用 |
|------|--------|------|------|
| 对角（scale） | $\partial_{q_l} \cdot q_l$ | $L$ | 每圈标度 IBP |
| 交叉（cross） | $\partial_{q_l} \cdot q_m\ (l \neq m)$ | $L(L-1)$ | 耦合不同圈动量 |
| 外动量（special） | $\partial_{q_l} \cdot k_j$ | $L(E-1)$ | 连接外动量 |

**交叉 IBP 的必要性**：$L \geq 2$ 时，仅对角 IBP 不足以将所有积分约化到 master integrals。交叉 IBP $\partial_{q_l} \cdot q_m$ 提供不同圈动量之间的关系，是完备约化系统所必需的。

**验证**：独立标量积数目 $N_{\text{sp}} = L(L+1)/2 + L K$（$K$ 为 `externalMomenta` 的独立外动量基个数）恰好等于 $N_{\text{IBP}}$，确认生成元集合与标量积空间维度匹配。

#### 4.3.4 ISP（不可约标量积）处理

**定义**：给定拓扑的传播子 $\{\xi_e^2\}$，所有标量积 $\{q_l \cdot q_m,\, q_l \cdot k_j\}$ 中不能表示为 $\xi_e^2$ 线性组合的，称为 ISP。

**函数族扩展**：积分家族增加 ISP 指标：

$$J[\{a_v\}, \{\text{pack}_e\}, \{n_{\text{isp}_j}\}]$$

ISP 指标 $n_{\text{isp}_j} \geq 0$（仅出现在分子，不出现在分母）。

**用户输入**：

```mathematica
(* ISP 定义：{名称, 标量积表达式, 指标范围} *)
ispData = {
  {"isp1", q1 . q2, {0, 2}},      (* q1·q2，分子幂次 0,1,2 *)
  {"isp2", q1 . k1, {0, 1}}       (* q1·k1，分子幂次 0,1 *)
};
```

**完备性验证**：`verifyISP[topology, ispData]` 检查：
1. 所有标量积 $\{q_l \cdot q_m,\, q_l \cdot k_j\}$ 均可表示为 $\{\xi_e^2\}$ 和 $\{\text{isp}_j\}$ 的线性组合
2. ISP 之间线性无关，并且当前主线要求 ISP 表达式直接是某个 `qq[i,j]` 或 `qk[i,j]` 标量积变量
3. `zExprs` 数量等于非 ISP 标量积数量，即 $\#z_e = N_{\text{sp}} - \#\text{ISP}_{\text{direct}}$
4. 数量闭合后必须能实际反解出 `repSP2Z`；重复或退化传播子动量会触发 `scalarProductCoordinateSolveFailed`
5. 若要进入数值 linear/Kira 阶段，`numericRules` 应覆盖全部外部不变量 `kk[i,j]`；缺失只触发 `numericRulesMissingExternalInvariants` warning，不阻止解析 seed 生成

这里验证的是用户初始化给出的 `z/ISP` 坐标系是否闭合。程序不把 dS 图默认理解为 overcomplete propagator family，也不自动挑选独立传播子子集；若计数不闭合、ISP 不足/过多、传播子动量退化或特殊数值外动量导致不可反解，validation report 直接报错，用户应修正传播子动量或 ISP 输入。

验证通过后，才进入 IBP 生成步骤。

#### 4.3.5 分 Sector IBP 生成流程

```
1. 读取拓扑 + ISP 配置
2. 验证 ISP 完备性
3. 构造 IBP 生成元集合 {O_{l,v}}（L(L+E-1) 个）
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

独立标量积分三类：

| 类型 | 记号 | 数量 |
|------|------|------|
| 圈-圈标量积 | $q_l \cdot q_m$（$l \leq m$） | $L(L+1)/2$ |
| 圈-外动量标量积 | $q_l \cdot k_j$ | $L(E-1)$ |
| 外动量-外动量标量积 | $k_i \cdot k_j \equiv k_{ij}$ | 常数，不计入独立变量 |

独立标量积总数 $N_{\text{sp}} = L(L+1)/2 + L(E-1)$（与 §4.3.3 的 IBP 生成元数目一致）。

外动量-外动量标量积 $k_{ij}$ 记为符号常数，不保持矢量点积形式。对 $d=3$ bubble 例子（$L=1$，$E=2$，1 独立外动量 $k \equiv k_1$）：
$$N_{\text{sp}} = 1 + 1 = 2, \quad \text{独立标量积：} q_1^2,\; q_1 \cdot k, \quad \text{外部不变量：} k^2 \equiv k_{11} = k_s^2$$

#### 4.4.3 $z$ 与标量积的线性变换

每条内线的 $z_e$ 展开为标量积的线性组合加外部不变量：
$$z_e = Q_e^2 = \left(\sum_l c_{e,l}\, q_l + P_e\right)^2 = \sum_l c_{e,l}^2\, q_l^2 + 2\sum_{l<m} c_{e,l}\, c_{e,m}\, q_l \cdot q_m + 2\sum_l c_{e,l}\, q_l \cdot P_e + P_e^2$$

其中 $P_e^2$ 和 $q_l \cdot P_e$（$P_e$ 为外动量线性组合）均可进一步展开为 $\{q_l \cdot q_m,\; q_l \cdot k_j,\; k_{ij}\}$ 的线性组合。

定义独立标量积向量 $\mathbf{s} = (s_1, \ldots, s_{N_{\text{sp}}})^T$（包含所有 $q_l \cdot q_m$ 和 $q_l \cdot k_j$），则：
$$\boxed{z_e = \sum_i M_{ei}\, s_i + c_e \quad \Longleftrightarrow \quad \mathbf{z} = M \cdot \mathbf{s} + \mathbf{c}}$$

其中：
- $M$ 为 $E_{\text{prop}} \times N_{\text{sp}}$ 系数矩阵（$E_{\text{prop}}$ 为内线数/传播子数）
- $c_e$ 仅含外动量不变量 $k_{ij}$（与圈动量无关的常数项）
- 当 $E_{\text{prop}} = N_{\text{sp}}$（无 ISP 情形）时，$M$ 为方阵

**逆变换**：
$$\mathbf{s} = M^{-1} \cdot (\mathbf{z} - \mathbf{c})$$

这给出所有标量积 $q_l \cdot q_m$ 和 $q_l \cdot k_j$ 用 $z_e$ 和 $k_{ij}$ 表示的替换规则。在代码中，`makeLinearRep[topology]` 自动构造 $M$、$\mathbf{c}$ 并计算逆，输出替换规则 `repScalarProduct`：
```mathematica
repScalarProduct = {
  q1 . q1 -> ...,    (* z_1, z_2, ..., k_{ij} 的线性组合 *)
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

**IBP 系数的线性结构**：生成元 $\mathcal{O}_{l,v}$ 的系数全部为 $z_e$ 和外不变量 $k_{ij}$ 的线性组合：

| 生成元 | $v \cdot Q_e$ | 系数结构 |
|--------|--------------|---------|
| 对角 $\partial_{q_l} \cdot q_l$ | $q_l \cdot Q_e$ | $z_e$ 线性组合 $+ k_{ij}$ |
| 交叉 $\partial_{q_l} \cdot q_m$ | $q_m \cdot Q_e$ | $z_e$ 线性组合 $+ k_{ij}$ |
| 外动量 $\partial_{q_l} \cdot k_j$ | $k_j \cdot Q_e$ | 纯 $k_{ij}$（与 $z_e$ 无关） |
| 散度 $(\partial \cdot v)$ | — | 常数 $d$（对角）或 $0$（交叉/外动量） |

#### 4.4.5 Bubble 例子

$d=3$ bubble 拓扑：2 顶点，2 内线，$L=1$，$E=2$。内线动量：
$$Q_1 = q_1, \quad Q_2 = q_1 - k$$

**$z$ 变量**：
$$z_1 = q_1^2, \quad z_2 = (q_1 - k)^2 = q_1^2 - 2\, q_1 \cdot k + k_s^2$$

**线性变换矩阵**（$\mathbf{s} = (q_1^2,\; q_1 \cdot k)^T$，$\mathbf{c} = (0,\; k_s^2)^T$）：
$$\begin{pmatrix} z_1 \\ z_2 \end{pmatrix} = \underbrace{\begin{pmatrix} 1 & 0 \\ 1 & -2 \end{pmatrix}}_{M} \begin{pmatrix} q_1^2 \\ q_1 \cdot k \end{pmatrix} + \begin{pmatrix} 0 \\ k_s^2 \end{pmatrix}$$

**逆变换**（$M^{-1} = \begin{pmatrix} 1 & 0 \\ 1/2 & -1/2 \end{pmatrix}$）：
$$q_1^2 = z_1, \quad q_1 \cdot k = \frac{z_1 + k_s^2 - z_2}{2}$$

**$v \cdot Q_e$ 系数**（生成元 $\partial_{q_1} \cdot v$ 的 IBP 系数）：

| $v$ | $v \cdot Q_1 = v \cdot q_1$ | $v \cdot Q_2 = v \cdot (q_1 - k)$ |
|-----|---------------------------|----------------------------------|
| $q_1$（对角） | $q_1^2 = z_1$ | $q_1^2 - q_1 \cdot k = \dfrac{z_1 + z_2 - k_s^2}{2}$ |
| $k$（外动量） | $k \cdot q_1 = \dfrac{z_1 + k_s^2 - z_2}{2}$ | $k \cdot q_1 - k_s^2 = \dfrac{z_1 - z_2 - k_s^2}{2}$ |

所有系数均为 $z_e$ 和 $k_{ij}$ 的线性组合，验证了 §4.4.4 的一般结论。

**IBP 方程示例**（对角生成元 $\mathcal{O}_{1,q_1} = \partial_{q_1} \cdot q_1$，忽略 ISP 和相位项）：
$$0 = \int d^d q_1\; \frac{\partial}{\partial q_1^\mu}\left[q_1^\mu \cdot F\right] = d \cdot F + \sum_e 2\, (q_1 \cdot Q_e)\, \frac{\partial F}{\partial z_e}$$

代入 $q_1 \cdot Q_1 = z_1$，$q_1 \cdot Q_2 = (z_1 + z_2 - k_s^2)/2$，以及 $\partial/\partial z_e$ 的指标移位效果（$b_e \to b_e + 2$），得到 $J$ 的线性关系式，系数为 $z_e$ 和 $k_s^2$ 的多项式。

## 5. 拓扑输入格式

```mathematica
(* 顶点 *)
vertexData = {{1, "+"}, {2, "+"}, ...};

(* 内线: {编号, {起点,终点}, 动量符号, nu, bbType} *)
lineData = {
  {1, {1, 2}, q1, nu1, "h"},     (* 线 1: h 函数 *)
  {2, {1, 2}, q2, nu2, "H"},     (* 线 2: Hankel 函数 *)
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

(* ISP: {名称, 标量积表达式, 指标范围} — 多圈时必需 *)
ispData = {
  {"isp1", q1 . q2, {0, 2}},     (* q1·q2，分子幂次 0,1,2 *)
  {"isp2", q1 . k1, {0, 1}}      (* q1·k1，分子幂次 0,1 *)
};
(* 单圈时可省略 ispData（无 ISP），但仍需显式给 externalMomenta = {k} 等外动量基 *)

(* 指标范围 *)
indexRanges = {aMin, aMax, bMin, bMax, bSMin, bSMax};

(* 撒点范围 *)
seedRange = {-3, 3};  (* 可选, 缺省 {-3,3} *)
```

必须一开始设定但不写进指标里的信息包括：顶点 SK 符号、内线的 `massType/bbType/skType/thetaConvention`、圈动量基、独立外动量基、ISP 配置、零点规则、缩并 prefactor 规则和 seed 幂次范围。这样 `J` 只承载动态指标，物理类型与初始化 convention 不混进指标本体。

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

## 7. 实现步骤

### Phase 1: 框架 + seed canonical check
1. 写 `.wl` 脚本，实现 topology/parser/pack/生成元/指标移位工具
2. 实现 EOM 递推并接入 seed 生成；验证所有输出 seed 中无 
=2`
3. 实现完整 momentum-IBP seed：传播子幂次项、building-block 导数项、ISP 项
4. 补完 time-IBP seed：已接入顶点幂次项、相位项、massive building-block 导数项、massless 端点翻转/canonical、massive theta boundary shrink 项，以及受保护的自动 shrink-sector seed 派生与联立
5. 用 bubble、mixed bubble、mixed triangle、massless bubble、mixed sunrise 的小样本 seed 与手推/参考代码对比

### Phase 2: 多圈 + sub-sector 链
6. 测试 2-loop 拓扑，特别检查 ISP 保留与吸收
7. 验证 sub-sector 链（1-line shrink -> 2-line shrink）
8. 验证缩并线 bS 的动量/时间 IBP 行为

### Phase 3: Linear/Kira 导出 + 扩展
9. 在 seed 完备且 canonical 检查通过后，建立线性系统中间层
10. Kira 格式导出（ctokb, jobs.yaml, list）
11. dlog 基构造（可选）
12. DE 矩阵提取（可选）

## 8. 待完善选项（备注）

- 从 h 的二阶 ODE 自动推导缩并幂次偏移 `shrinkPow`（当前手动指定缺省值 0）
- 图自同构群自动检测（symmetry canonical 化）
- 奇偶性筛选自动生成（reppowerselection）
- 多圈动量 IBP 的标量积展开（Gram 矩阵）
- massless G^{+-}/G^{-+} 的特殊简化
- massive G^{+-}/G^{-+} 的完整 seed：当前 `005` 已用 `massiveCross` 保留无 Heaviside 结构，但指标仍按 massive 双端点 Hankel convention 取 `{b_e,n_{e,1},n_{e,2}}`；momentum/time building-block seed 与 EOM canonical 已接入，且不产生 theta boundary shrink。
- 同一顶点对多条 massless 传播子的 bundle theta 合并。当前先使用逐线 `{b_e,n_e}` 的 merged-two-theta 表示，保证任意拓扑输入不出错；`005` 已在 `makeTopologyData` / `summarizeCase` 中记录 `masslessBundleCandidates`，用于提示未来可合并的同顶点对 massless 线组，但不改变当前 seed 生成和 canonical 逻辑。

## 9. 验证与性能红线

- 主线脚本默认只生成 seed、metadata、pack、生成元列表、linear-system 和 Kira 输入文件；默认不运行 Kira，不触发约化。
- seed 生成必须包含离散 `n=0/1` 枚举后的即时 EOM canonical 化。验证项之一是扫描所有输出 `J`，确认没有 `n=2` 或更高 Hankel 导数态。
- 验证优先使用结构计数：pack 类型、seed 数、生成元数、ISP 覆盖性、canonical 扫描结果。
- rank/span 或矩阵比较必须先对符号参数做代数赋值，使用小整数/有理数 specialized check；不得对大符号矩阵做解析 `MatrixRank`。
- 解析 IBP 只允许逐 seed 或代表项检查，不能批量展开整个 family 后再做全局化简。
- Kira 测试先检查小 toy case 的输入语法；真正约化作为单独任务运行。没有 EOM/time-IBP 完整 seed 和 linear-system 数据时，不做 Kira 导出测试。

## 10. 约定总结

| 项目 | 约定 |
|------|------|
| 文件扩展名 | `.wl` |
| 积分 Head | `J[aList, packList]` |
| massive 完整线 pack | `{b_e, n_{e,1}, n_{e,2}}` |
| massless 完整线 pack | `{b_e, n_e}`（双 theta 合并路线） |
| 缩并线 pack | `{bS_e}` |
| Building block 参数 | `"h"` / `"H"` / `{q1, q2, sp}` |
| 外部能量 | 保持为独立符号到 repvar |
| SK 符号 | `exp(-iP tau)` 对应 (+) 顶点 |
| 时间 IBP 各项符号 | vertex: `-a_v`, ext: `-I*P[v]`, bb: 由链式法则决定 |
| Sub-sector 表示 | 同一 Head `J`，缩并线用 `{bS}` |



## 10. v4.1 后端排序、撒点与 sector metadata 约定

- seed 生成阶段自动完成：按 sector 生成，再按 momentum/time 分类，每类内部枚举该 sector 的离散 `n=0/1` 状态，并立即应用 EOM/massless endpoint canonical。若为验证使用 `DiscreteMode -> "sample"`，`sampleDiscreteRules` 中每条规则也必须覆盖全部离散 `n` 变量；sample 只是减少取样条数，不允许保留符号 `n`。seed 只保存 MMA 表达式，不直接导出 Kira。
- 撒点/数值替换属于 linear/Kira 阶段：用户在 topology 的 `numericRules` 或 Kira 导出时的 `KiraCoefficientRules` 中给规则；`validationReport` 会提前检查外部不变量 `kk[i,j]` 是否被覆盖，缺失只给 warning。验证默认只用小样本，不做大范围遍历。
- Kira/master 排序必须对全 sector 的 `integralList` 一起做。默认排序仍以 line pack 的第一指标（`b` 或 `bS`）复杂度为最高主要权重；用户可用 `KiraOrdering -> <|"IntegralOrder" -> {...}|>` 或 `"PreferredIntegrals"` 提前指定候选主积分。linear-system 会保存 `kiraOrderingReport`，其中 `missingIntegralOrderItems` 用来提示未命中的候选。
- 若 linear-system 已生成，用户可先看 `linearData["integralList"]`，手动重排后调用 `reorderLinearSystemIntegrals[linearData, order]`，或直接在 `makeKiraExportData[..., KiraIntegralOrder -> order]` 中指定导出顺序。手动重排会额外保存 `manualIntegralOrderReport`，越界编号或不在系统中的 `J` 不会静默消失。
- `makeKiraExportData` 的最后一步规则必须可追溯：`KiraCoefficientRules` 和 `KiraJobOptions` 写入 `result/kira_export_metadata.m`。默认 `jobs.yaml` 开启 `run_initiate`、`run_firefly` 和 `kira2math`；用户可覆盖这些开关，但这只改变后端文件，不改变 seed 或 linear-system。
- 数值 Kira 输入沿用参考 code 的 dummy 保护：若所有导出系数均为数值，`KiraJobOptions` 中的 `"AppendNumericDummyEquation" -> Automatic` 会在 `ibp.kira` 末尾加入 `(N+1)*(ccc)`，并让 `list` 多包含这个 dummy id；metadata 中记录 `numericDummyAppendedQ`、`numericDummyIntegralId` 和 `targetIntegralCount`。
- 每个 sector 缓存一份 `sectorMetadata`：包含 `sectorVertexRepresentativeMap`、`compactASlots`、`vertexIdToCompactASlot`、`lineSlots`、`lineIdToSlot`、`bSymbolToLineSlot`。这样导出、排序和人工检查不需要每次从指标形状反推“哪个 a/b 属于哪条线或哪个顶点”。
- 物理 convention 上，缩并后 delta 已积分掉一个时间变量，因此 sub-sector 的有效 `a` 只有 compact 后的 active slots。当前 `004` 主代码已切换为 `aSlotMode -> "compactActiveSlots"`：sub-sector 的 `J` 本身只保留 delta 积分后仍 active 的 compact `aList`；原顶点、原 slot 与 compact slot 的对应关系全部由 `sectorMetadata` 保存。
### v4.1 追加验证：multi-shrink compact aList

已加入一个双 massive-line bubble toy：两条 massive 完整线均可由 theta 边界缩并，自动生成 `{e1}`、`{e2}`、`{e1,e2}` 三个 shrink sectors。该检查验证 double-shrink sector 使用 `aSlotMode -> "compactActiveSlots"`，`J` 的 `aList` 长度为 1，且 `sectorMetadata` 保留每条线的 `originalEndpoints` 与 compact/original slot 对应。
## 11. v5 接口整理与上传边界

`005_dS_ibp_general.wl` 是当前主线脚本，保留 `004_dS_ibp_general.wl` 作为上一版对照。当前验证入口 `000_code/check/run_004_seed_expected_examples.wl` 会优先加载 `005`，不存在时回退 `004`。

新增接口：

- 初始化：`makeTopologyData` 预缓存 sector metadata、index maps 和 seed summary。
- seed 分类：`classifyCanonicalSeedBatch` 按 sector 与 `qIBP/tIBP` 分类。
- 撒点后端：`makeSampledLinearSystemData` 在 linear-system 层应用 `numericRules` 或用户显式 `CoefficientRules`，不污染解析 seed。
- 端到端入口：`makeIBPWorkflowData` 只串联现有 gate，返回 topology、seed、linear-system 和可选 Kira export；`ExportKira -> True` 可只生成内存中的 Kira 字符串，只有给出 `OutputDirectory` 时才写 Kira 文件。
- Kira 排序：默认全 sector 排序；用户仍可在 linear 后查看 `integralList` 并重排，且排序命中情况会写入 report。
- Massless bundle metadata：`masslessBundleCandidates` 只预扫描同一顶点对的多条 `masslessFull` 线，当前不把它们合成一个指标包，也不减少离散态枚举。

上传边界：只提交当前两版主脚本、note、check 源脚本、check reference 和必要参考资料；忽略 test/results_test、Kira 输出、旧 stdout/stderr、旧 IBP 方程导出、LaTeX 辅助文件和更旧主线脚本。
