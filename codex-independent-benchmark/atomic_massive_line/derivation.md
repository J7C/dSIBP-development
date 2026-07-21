# atomic_massive_line 独立推导

## 输入与来源

有序端点为 `{v1,v2}`，`x_r=-ell tau_r`。采用标准 Bessel 方程

```text
x^2 y''+x y'+(x^2-nu^2)y=0
```

以及 DLMF 10.5.5 的同阶 Hankel Wronskian。对纯虚阶数还使用 DLMF 10.4.7 的阶数反射关系，把第二类函数的阶数 `nu*` 化到 `nu`。记

```text
kappa(nu) = (4 i/pi) exp(pi Im(nu)).
```

这些恒等式从特殊函数定义推导传播子原子，不调用 package EOM、shrink helper 或旧 expected。

## H 模式闭合

令 `H0=H_nu(x)`、`H1=partial_x H0`。Bessel 方程直接给出

```text
H0' = H1,
H1' = -H0-H1/x+nu^2 H0/x^2.
```

因此 `n=1` 再求导产生的 `n=2` 立即回到 `n=0,1`。时间导数使用 `partial_tau=-ell partial_x`：

```text
-ell H1' = ell H0 + H1/(-tau) - nu^2 H0/(ell (-tau)^2).
```

动量径向导数使用 `ell partial_ell=x partial_x`：

```text
x H1' = -x H0-H1+nu^2 H0/x.
```

最后一项分别产生 `(a,b)->(a-2,b+1)` 和 `(a,b)->(a-1,b+1)` 的整数移位；因此二次 pole 不能丢失。

## h 模式闭合

令 `h0=x^(-nu)H_nu(x)`、`h1=partial_x h0`。把 `H_nu=x^nu h0` 代回 Bessel 方程，`nu^2/x^2` 项与幂函数导数恰好消去：

```text
h0' = h1,
h1' = -h0-(2nu+1)h1/x.
```

对应地，

```text
-ell h1' = ell h0 + (2nu+1)h1/(-tau),
x h1' = -x h0-(2nu+1)h1.
```

这与 H 模式是两条独立闭合式，不通过把某个参数设值互相猜测。

## H 到 h 的基变换

由 `h=x^-nu H` 及其一阶导数直接得到

```text
T_Htoh = {{x^-nu,0},{-nu x^(-nu-1),x^-nu}}.
```

把裸 H 的 `A0={{0,1},{-(1-nu^2/x^2),-1/x}}` 代入

```text
AT = T'.Inverse[T] + T.A0.Inverse[T]
```

得到 `AT={{0,1},{-1,-(2nu+1)/x}}`，正是上节独立推导的 h 系统。又因 `Det[T]=x^-2nu`，`WT=Det[T] W_H=-kappa x^(-2nu-1)=W_h`。因此 H-to-h 的 `J` 关系、shrink zero-point 与 direct-h 相同，但 package 输入仍是裸 H 的 `P_H,Q_H,W_H`。

## Wronskian 与 coincidence

对任务书中的 cross-order pair，DLMF 的反射关系给出

```text
W[H_nu^(1),H_nu*^(2)] = -kappa(nu)/x.
```

乘上 h 模式两侧共同的 `x^(-nu)` 后，交叉项抵消，得到

```text
W[h_1,h_2] = -kappa(nu) x^(-2nu-1).
```

在 coincidence 处记 `A=F_1`、`B=F_2`。四个端点态的 `WGreater-WLess` 为

| `(n1,n2)` | 差值 |
|---|---|
| `(0,0)` | `0` |
| `(0,1)` | `W[A,B]` |
| `(1,0)` | `-W[A,B]` |
| `(1,1)` | `0` |

对 `G++`，第一端点的 theta 导数乘这个差值，第二端点取反；`G--` 再整体反号。`G+-/G-+` 没有 theta，因此没有 shrink。

由此定义 `sigma=+1` 对应 `++`、`sigma=-1` 对应 `--`，第一/第二端点符号 `epsilon={+1,-1}`，端点态符号 `chi(1,0)=+1`、`chi(0,1)=-1`，则非零 contact 系数统一为

```text
epsilon sigma chi kappa(nu).
```

## shrink 的指标与 zero-point

H 的物理 contact factor 是 `kappa x^-1`，h 是 `kappa x^(-1-2nu)`。严格按任务书的整数/非整数拆分：

| mode | `s` | `z` | `bS` | `bS0` | `aMerged` | `a0Merged` |
|---|---:|---:|---|---|---|---|
| H | `1` | `0` | `b+1` | `beta1` | `a1+a2-1` | `alpha1+alpha2` |
| h | `1` | `2nuM` | `b+1` | `beta1+2nuM` | `a1+a2-1` | `alpha1+alpha2-2nuM` |

顶点只合并一次，代表为 `v1`。在 top 基点 `a1=a2=b=0`，contact 积分固定为 `J[{-1},{{1}},{}]`。

## Time-IBP 与 momentum-IBP

对 top sector，`tau_r` 全导数含三类项：

```text
-(a_r+alpha_r) J[a_r-1],
-i s_r E_r J,
-ell partial_x F_{n_r},
```

同分支还按上一节加入 contact。对角 momentum 生成元为

```text
0 = (d-b-beta1)J + (x1 partial_x1+x2 partial_x2)J.
```

所有 `n=2` 都立即用各 mode 的闭合式消去。

在 `e1` sector，传播子只剩 `ell^(-(bS+bS0))`，所以唯一 active time 与 momentum 关系为

```text
0 = -(a12+a0Merged) J[a12-1]
    -i sigma(E1+E2)J[a12],
0 = (d-bS-bS0)J[bS].
```

## 覆盖计数

每条 route：固定 `--/-+` 各有 `4` 个端点态、`2` 个 time 和 `1` 个 momentum 关系，共 `2*4*3=24` 条 top 关系；只有 `--` 有 merged-time 与 momentum 两条 shrink 关系。每路共 `26` 条；direct-h、bare-H、H-to-h 三路合计 `78` 条。
