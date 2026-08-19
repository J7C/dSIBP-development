# dSIBP 022 第 15.6 节 Phase 1 独立推导

- 执行者：`46449-Codex022Independent`
- 日期：2026-08-19（Asia/Shanghai）
- 范围：只执行 `independent-benchmark.md` 第 15.6 节。
- 隔离状态：本文件与 `paper_oracle_phase1.wl` 冻结前未读取候选 package、项目
  `reference-results/`、源码实现、`check-smoke/`、旧 check、旧报告或旧验证附件。
- 允许来源：任务书第 2.1--2.3、3、14.1、15.6 节，以及公开 arXiv e-print
  `2411.03088` 的 TeX 原文。
- arXiv e-print SHA-256：
  `409457E1609AFE389D70BF86495F36B8A1C97D64F12B8159DE2C282472C5D37F`。

## 1. h 函数系统

任务书定义

```text
h1(x) = x^(-nu) H_nu^(1)(x),
h2(x) = x^(-nu) H_conjugate(nu)^(2)(x),
h_s,1(x) = d h_s,0(x)/dx.
```

从 Bessel 方程

```text
H'' + H'/x + (1 - nu^2/x^2) H = 0
```

代入 `H=x^nu h`，逐项消去 `x^(-2)` 项，得到

```text
h'' + (2 nu + 1) h'/x + h = 0.
```

因此直接 h 基底 `{h,h'}` 的一阶系统为

```text
d/dx {h,h'}^T = {{0,1},{-1,-(2 nu+1)/x}} {h,h'}^T.
```

## 2. Wronskian 与 coincidence

采用标准 Hankel 恒等式

```text
W_x[H_nu^(1),H_nu^(2)]
  = H_nu^(1) (H_nu^(2))' - (H_nu^(1))' H_nu^(2)
  = -4 i/(pi x),
H_-nu^(2)(x) = exp(-i pi nu) H_nu^(2)(x).
```

对任务书允许的 `nu` 为纯实或纯虚两类，可统一写

```text
phase(nu) = exp(pi Im(nu)),
W_h(x) = h1 h2' - h1' h2
       = -4 i phase(nu)/(pi x^(2 nu+1)).
```

令 `C[n1,n2]=WGreater-WLess` 在 `tau1=tau2=tau` 的值，则

| `(n1,n2)` | `C[n1,n2]` |
|---|---|
| `(0,0)` | `0` |
| `(1,0)` | `+4 i phase/(pi x^(2 nu+1))` |
| `(0,1)` | `-4 i phase/(pi x^(2 nu+1))` |
| `(1,1)` | `0` |

由于 `partial_tau1 theta(tau1-tau2)=+delta`，而
`partial_tau2 theta(tau1-tau2)=-delta`，第二端点的 contact 符号与表中
`C` 相反。取 `x=sE1 (-tau)` 后，论文 remaining master 的 raw Wronskian
normalization 是

```text
-4 i exp(pi Im(nu1))/pi * sE1^(-2 nu1-1).
```

这与公开论文 Eq. (4.2) 的 `ks^(-2 nu1-1)` 连续幂一致，不能只保留
整数 `1/sE1`。

## 3. normalized-sector 分层

按任务书 `J_s=N_s I_s` 约定，child 层必须分开保存：

```text
physical sector prefactor = sE1^(-2 nu1),
rational selector         = -1/sE1,
Wronskian constant        = 4 i exp(pi Im(nu1))/pi,
dlog-basis coefficient    = Wronskian constant * rational selector,
complete normalization    = dlog-basis coefficient * physical prefactor
                          = -4 i exp(pi Im(nu1))/pi
                            * sE1^(-2 nu1-1).
```

不使用 `PowerExpand`，直接按 `(dN/dsE1)/N` 求 logarithmic derivative：

```text
d Log[N]/d sE1 = -(2 nu1+1)/sE1.
```

这四层是不同职责，不能把 `sE1^(-2 nu1)` 在 dlog coefficient 和 physical
sector prefactor 中重复相乘。

## 4. 论文 oracle 与固定 adapter

公开论文 Eq. (4.2) 固定 master 顺序为

```text
{I00,I01,I10,I11,IR}.
```

Eq. (4.4)--(4.5) 给出 `Omega={{A,R},{0,C}}`，其中
`A=Omega1(k12,ks) tensor 1 + 1 tensor Omega1(k34,ks)`；
`paper_oracle_phase1.wl` 从论文的 log-form 原式分别对 `k12,k34,ks` 精确求导，
未使用任何 package actual。任务书预先固定 dSIBP endpoint `n=1` 相对论文的
符号 adapter：

```text
diag(1,-1,-1,1,1).
```

除该矩阵外不从最终差矩阵拟合其它 adapter。
