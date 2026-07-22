# General-`ds` 独立原语

## 有序外动量导数

使用任务书固定的

```text
Dij = k_i . partial_{k_j},
sij = k_i . k_j = sji,
raw basis = {Dij | i<=j}.
```

`sij` 是对称坐标，`Dij` 是有序算子。一个外动量时，`D11 s11=2 s11`，所以

```text
partial_{s11}=D11/(2 s11).
```

两个外动量时，按坐标 `{s11,s12,s22}` 和算子 `{D11,D12,D22}` 排列，作用矩阵为

```text
M = {{2 s11, 0,     0},
     {s12,   s11,  s12},
     {0,     2 s12,2 s22}}.
```

第 `a` 个坐标导数的系数是 `M.c_a=e_a` 的解。`expected.wl` 保存 `Inverse[M]` 的三列及严格零残差；这正是 upper-triangular convention，而不是把 `Dij` 误当成对称对象。

## 顶点相位与链式法则

顶点符号 `sigma=+1/-1` 对应相位 `Exp[-I sigma E tau]`。由于 `J` 的时间幂使用 `(-tau)^(a+a0)`，对能量变量 `y` 求导得到

```text
partial_y J = I sigma (partial_y E) ShiftA[J,+1].
```

若 `E=Sqrt[s11]`，则 `partial_{s11}E=1/(2 Sqrt[s11])`；独立 `ke[i]` 只对同名变量贡献 1，绝不进入外动量标量积空间。

## 表达式乘积法则

对两个不同积分 `J1,J2` 和纯系数项

```text
F(x)=x^2 J1+(x+1) J2+x^3,
```

完整导数必须是

```text
2 x J1+J2+3 x^2+x^2 dJ1+(x+1) dJ2.
```

这里 `dJ1,dJ2` 是由上面的向量导数、传播子/函数块/ISP 原语逐项组成的积分导数。package 对照不得用 `ds[J1]`、`ds[J2]` 反向拼 expected；它们只能作为 actual 与独立组合后的结果比较。

## 任务书变量覆盖

`expected.wl` 明列十个 loop family 的外不变量与独立顶点能量。`vertex_energy_signs` 的 A/B/C 三案分别区分独立 `ke[1]`、复用 `Sqrt[s11]` 和独立 `ke[3]`，从而单独覆盖显式链式法则与“不把外腿能量加入 momentum generator”的约定。
