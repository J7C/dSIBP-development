# 独立公式 oracle 推导

本文件给出九个新增 family 共用的原始推导。`oracle/independent_oracle.wl` 只是这些公式的机械展开，不加载 `package_012.wl`、旧 expected 或 `_manual_ibp_engine.wl`。

## 1. Massless 原子

令 `Delta=tau_u-tau_v`，`sigma=+1/-1` 对应 `++/--`：

```text
M0 = theta(Delta)e^{-i sigma q Delta}+theta(-Delta)e^{i sigma q Delta},
M1 =-theta(Delta)e^{-i sigma q Delta}+theta(-Delta)e^{i sigma q Delta}.
```

直接求导得到

```text
partial_u M0 =  i sigma q M1,
partial_v M0 = -i sigma q M1,
partial_u M1 =  i sigma q M0 - 2 delta(Delta),
partial_v M1 = -i sigma q M0 + 2 delta(Delta),
q partial_q M0 = i sigma q Delta M1,
q partial_q M1 = i sigma q Delta M0.
```

所以只有 `n=1` 产生 contact。`D+-=e^{iqDelta}`、`D-+=e^{-iqDelta}` 满足 `partial_u D=i s_u qD`、`partial_v D=-i s_u qD`、`q partial_q D=i s_u qDelta D`，没有 theta boundary。

## 2. Massive 原子

H/h 的 EOM 与 Wronskian 已在 `atomic_massive_line/derivation.md` 独立推导。oracle 使用

```text
H1'=-H0-H1/x+nu^2 H0/x^2,
h1'=-h0-(2nu+1)h1/x,
W_H=-kappa/x,
W_h=-kappa x^{-1-2nu},
kappa=(4i/pi)e^{pi Im(nu)}.
```

`(n1,n2)=(1,0)/(0,1)` 的 `WGreater-WLess` 分别是 `+kappa/-kappa`（`++`），`--` 整体反号；第二端点 time 导数再反号。H 的 contact shift 是整数/零点 `1+0`，h 是 `1+2nu`。

## 3. Common-theta

同一当前代表顶点对的 `m` 条 full lines 共享一个 theta。令每条线在正/负时间差一侧的 coincidence 值为 `A_i/B_i`，则

```text
Product[A_i]-Product[B_i]
 = Sum_{|S| odd} 2^{1-|S|}
   Product_{i in S}(A_i-B_i)
   Product_{j notin S}(A_j+B_j)/2.
```

因此一次 contact 只选非空奇数子集。selected massive/massless 分别消费 Wronskian 或 `-2`；unselected massless 只有 `n=0` 非零，物理值成为纯 `q` 幂但按逐线 J convention 保留 full pack `{b,0}`；unselected massive 把 `(1,0)` 与 `(0,1)` canonical 到同一个 coincidence 状态。sector seed 仍遍历原始 `00/01/10/11` 四态，再对关系输出 canonical。三线 simultaneous contact 的系数 `2^{1-3}=1/4`，不是三个独立 delta 的乘积。

sector 由这些事件做 BFS：每次合并两个当前代表类，selected 线逐条累加整数/zero-point shift，顶点只合并一次。triangle 的全同分支可达两边 forest，但三边 cycle 不可达；三条平行线可达三个 single sector 和一个 triple sector。

## 4. Time-IBP

对 active representative `r`：

```text
0 = -(a_r+a0_r)J[a_r-1]
    -i Sum_{v in class(r)} s_v E_v J
    + Sum incident endpoint regular terms
    + Sum common-theta contact terms.
```

若一条 massive line 的两个原端点都映到 `r`，两个 endpoint regular term 均保留；coincident massless 已 canonical 为纯 `q` 幂，不再产生 regular 或 boundary 项。

## 5. Momentum-IBP 与 ISP

对 `O_{l,V}=partial_{q_l}.V`，线动量 `Q_e` 中 `q_l` 的系数为 `c_el`：

```text
O q_e = c_el (V.Q_e)/q_e,
O q_e^{-B_e} = -B_e c_el (V.Q_e)/q_e^2 q_e^{-B_e}.
```

building block 项为同一个 `c_el(V.Q_e)/q_e^2` 乘 `q_e partial_{q_e}`；massive 使用 EOM，massless 使用第 1 节的 `q partial_q`。`V=q_l` 时另有 `d J`。ISP 项是 `z rho^{z-1}O rho`。

每个 family 先把 propagator squares 与用户 ISP 写成全部 loop scalar products的线性方程并求逆。`propSq[e]` 乘法对应 `b[e]->b[e]-2`，`rho[r]` 对应 `ispN[r]->ispN[r]+1`。若该线性系统不满秩，单独的完整 momentum generators 无法闭合，不能伪造 expected。

## 6. 外不变量总导数

外部不变量坐标命名为对称的 `s_ij=k_i.k_j=s_ji`，只保留 `i<=j`。方向导数则是有序算符

```text
D_ij = k_i.partial_{k_j},
D_ij s_ab = delta_{ja}s_{ib}+delta_{jb}s_{ai}.
```

`Orderless` 只实现 `s_ij=s_ji`，不令 `D_ij=D_ji`。按任务书正式 convention，raw 反解固定使用

```text
{D_ij | i<=j}.
```

例如两个外动量时按 `{D11,D12,D22}` 构造矩阵

```text
{{2 s11, s12, 0},
 {0, s11, 2 s12},
 {0, s12, 2 s22}}.
```

只验证该固定矩阵满秩，不再从全体 `Dij` 中另选其它满秩 representative；不满秩时直接报告坐标/运动学不闭合。随后反解 `partial/partial s_ab`。`D_ij J` 的 line/ISP 规则与 momentum oracle 相同但没有 divergence；若 `E_v=E_v(s)`，相位另给

```text
i s_v (D_ij E_v) J[a_rep+1].
```

独立 `ke[i]` 只微分顶点相位。每条正式检查使用

```text
X = v J0 + v^2 J1 + v^3,
dX/dv = J0+2vJ1+3v^2+v dJ0/dv+v^2 dJ1/dv,
```

其中 `J0` 取全零离散态，`J1` 覆盖所有仍存在的 `n=1`，连续指标保持 general。
