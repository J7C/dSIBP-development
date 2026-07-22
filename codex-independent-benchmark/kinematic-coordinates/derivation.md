# 根号动力学坐标独立推导

令进入 loop propagator 动量偏移的独立外动量为 `ki`，并定义

```text
xij = sp[ki,kj],    ssij = Sqrt[xij],    xij = ssij^2.
```

因此对任意积分或积分线性组合 `F`，链式法则给出

```text
dF/dssij = 2 ssij dF/dxij.
```

这里 `dF/dxij` 是旧 `sij` 路线已经验证的 squared-invariant 原子导数。对角 `i=j` 和非对角 `i<j` 使用同一个 Jacobian；不重新推导 external-vector operator decomposition。

`externalLegMomenta` 只声明允许出现在无圈动量线和外腿相位中的向量。它不生成完整 Gram 表。应从输入中实际出现的无圈动量组合逐个抽取模长：若依次出现 `kE1`、`kE1+kE2`、`kE2`，则定义

```text
sE1 = |kE1|,    sE2 = |kE1+kE2|,    sE3 = |kE2|.
```

三者按函数族输入视为独立标量；不得额外生成 `Sqrt[sp[kE1,kE2]]`，也不得用余弦定理自动消去 `sE2`。若某个无圈动量完全由 `externalMomenta` 张成，则其平方已由完整 `xij` Gram 基表示，不再创建 `sEe`。这些无圈模长不增加 `L(L+K)` 中的 `K`，也不进入 ISP 闭合。

“实际出现”与“独立坐标”不是同一集合。把全部声明向量的上三角 Gram 原子作为形式线性空间，先放入完整 loop-external Gram 行，再按首次出现顺序放入各无圈组合的模长平方行；只有增加矩阵秩的行才建立新的 `sEe`，其余行保留为 dependent binding。例如依次出现

```text
|kE|, |2 kE|, |k+kE|, |k-kE|
```

且 `k` 是 loop external momentum 时，独立变量只有 `{ss11,sE1,sE2}`，其中

```text
sE1^2 = |kE|^2,
sE2^2 = |k+kE|^2,
|2 kE|^2 = 4 sE1^2,
|k-kE|^2 = 2 ss11^2 + 2 sE1^2 - sE2^2.
```

因此从属模长进入 line 或 phase 时，必须对右端根号表达式继续做链式求导。例如

```text
d|2 kE|/dsE1 = d Sqrt[4 sE1^2]/dsE1,
d|k-kE|/dsE1 = 2 sE1/Sqrt[2 ss11^2+2 sE1^2-sE2^2].
```

这里保留根号分支，不使用 `PowerExpand`。

若正分支顶点相位为 `Exp[-I E tau]`，指标表示中的相位导数原子项满足

```text
dJ/dE = +I shiftA[J,+1].
```

负分支符号相反。这个规则只作用于声明依赖该 `sEe` 的顶点，不产生 momentum-IBP generator。

若无圈动量 `pE` 本身是一条仍参与 `tau` 积分的 massive h 线，则对 `r=|pE|` 的导数还必须作用到该线。对 `n1=n2=0`，直接从

```text
r^(-B) h0(r tau1) h0(r tau2),    d h0(x)/dx = h1(x)
```

得到

```text
d/dr = -B shift_b(+1)
       + shift_a1(+1) shift_n1(0->1)
       + shift_a2(+1) shift_n2(0->1).
```

若同一个 `r` 还进入正分支顶点相位，再加 `+I shift_a(+1)`；这仍是标量径向导数，不新增 loop momentum generator。

对线性组合 `C(ss,sE) J + C0(ss,sE)`，总导数必须包含

```text
d(C J + C0)/dss = (dC/dss) J + C dJ/dss + dC0/dss.
```

若用户显式给出 `sp[ki,kj] -> sij`，则 `sij` 仍表示 squared invariant `xij`，Jacobian 为 1；该兼容只由显式输入启用，不是 015 缺省。

用户重选变量时，把所有规则左端先写成基础平方原子的线性组合。左端矩阵必须覆盖完整 loop Gram 原子和全部实际出现的无圈模长原子；右端对用户参数的 Jacobian 也必须满秩。左端或右端欠秩时，零空间给出缺失方向或隐含约束。参数数目超过基础原子数时属于过完备：IBP 仍可生成，但在未把约束写入 family 前，反向变换与独立参数求导没有唯一含义。

一般混合坐标必须直接对平方原子使用 Jacobian。例

```text
x11 = u^2,    x12 = u v,    x22 = v^2+w^2
```

在固定 `{v,w}` 时有

```text
d/du = 2u d/dx11 + v d/dx12.
```

这里不能先把 `u` 当作 `x11` 的根号变量后提前返回，否则会漏掉 `v d/dx12`。loop Gram 原子导数已经包含由该 Gram 变量引起的顶点相位导数；额外的显式 phase 求导只能作用于内部表达式中仍显式依赖用户变量的无圈模长或独立标量，不能重复加入 loop phase。
