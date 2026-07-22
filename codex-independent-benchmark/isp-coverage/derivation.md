# 非零 ISP seed 的独立推导

## 统一差分

令被积函数为 `rho_j I0`，动量生成元为 `partial_q . v`。乘积法则给出

```text
partial_q . (v rho_j I0)
  = rho_j partial_q . (v I0) + (v . partial_q rho_j) I0.
```

因此 `r_j=1` 的关系减去把同一 `r=0` 关系中每个积分的第 `j` 个 ISP 指标整体加一，严格只剩 `v.partial_q rho_j` 乘以原 seed。下面逐 family 推导这个插入项。这个口径同时检查非零插入和应严格为零的生成元。

## mixed_sunrise

记

```text
D1=q1^2, D2=q2^2, D3=(q1-q2-k)^2,
rho1=q1.k, rho2=q2.k, s=k^2.
```

五个 loop scalar products 的反解为

```text
q1^2=D1,
q2^2=D2,
q1.k=rho1,
q2.k=rho2,
q1.q2=(D1+D2+s-2 rho1+2 rho2-D3)/2.
```

对 `rho1`，只有 `partial_q1` 三个生成元非零，依次给出 `{rho1,rho2,s}`；对 `rho2`，只有 `partial_q2` 三个生成元非零，依次给出 `{rho1,rho2,s}`。另一个 loop 的三个生成元均严格为零。

## two_loop_isp_toy

令 `l=l3`、`p=k321`、`k=wdnmd`，并记

```text
D1=l^2, D2=p^2, D3=(l-p-k)^2,
rho1=l.(p+l), rho2=l.k, s=k^2.
```

反解为

```text
l.p=rho1-D1,
p.k=(D3-3 D1-D2-s+2 rho1+2 rho2)/2.
```

加上 `l^2=D1`、`p^2=D2`、`l.k=rho2` 即闭合全部五个 loop scalar products。直接求导得到

```text
partial_l rho1 = p+2l,
partial_p rho1 = l,
partial_l rho2 = k,
partial_p rho2 = 0.
```

与 `{l,p,k}` 点乘后即得到 `expectedISPInsertions` 中的十二个 generator 结果。

## vertex_energy_signs

记 `D1=(ell-k)^2`、`rho1=ell.k`、`s=k^2`。反解

```text
ell.k=rho1,
ell^2=D1+2 rho1-s
```

闭合两个 loop scalar products。`partial_ell rho1=k`，所以 `dqq[1,1]` 插入 `rho1`，`dqk[1,1]` 插入 `s11`。该结论与三种顶点能量 case 无关；顶点能量只影响 time/`ds` 项，不进入 momentum generator。
