# 代表推导

定义

```text
z1=q^2,
z2=(q-k)^2,
q.k=(z1+s11-z2)/2.
```

因此

```text
q.(q-k)=(z1-s11+z2)/2,
k.(q-k)=(z1-s11-z2)/2.
```

expected 的 momentum 关系只用这四个线性恒等式，将 `z1/z2` 分别吸收到第 1/2 条线的第一幂次指标；没有调用 package 的 `makeScalarProductRules` 或 seed 函数。

当 top 的第 1 条线 shrink 时，目标 sector 中第 2 条平行线端点变为 `{v1,v1}`。若 `n2=1`，该反对称状态在目标 sector 必须为零。因此 `n1=n2=1` 的 top theta-boundary 项不能作为普通非零 `e1/e2` 积分保留。
