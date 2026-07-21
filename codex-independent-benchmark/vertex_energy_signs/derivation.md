# vertex_energy_signs 推导

time/EOM/contact 与 atomic massless 相同，只替换顶点相位能量。A 对 `ke1/ke2` 独立，B 的 `v1` 相位对 `s11` 有 `1/(2sqrt(s11))` 链式法则，C 的 `ke3` 不等于 `ke1+ke2`。

任务书补入

```text
rho1=sp[ell,k].
```

与 denominator square

```text
D1=(ell-k)^2=ell^2-2 ell.k+s11
```

共同给出

```text
ell.k=rho1,
ell^2=D1+2 rho1-s11.
```

因此 `d/dell.ell`、`d/dell.k` 中的全部 scalar products 都能吸收到 `D1/rho1` 指标移位。ISP 本身的导数为

```text
(ell.partial_ell) rho1 = rho1,
(k.partial_ell) rho1 = s11,
(k.partial_k) rho1 = rho1.
```

独立 seeds 固定覆盖 `ispN1=0,1`；general derivative 保持第三槽为符号 `rg[1]`。三组能量中，A/C 的 `s11` 只通过 line/ISP 进入，B 还包含顶点相位 `Sqrt[s11]` 的链式法则。
