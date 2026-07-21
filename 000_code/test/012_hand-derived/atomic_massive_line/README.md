# atomic_massive_line

## 函数族

- 顶点：`{v1,v2}`。
- 内线：一条 massive 线，动量 `ell`，质量参数 `nuM`。
- building block：分别测试物理 h 与裸 H 导数基底。
- 顶点分支：`++`、`--`、`+-`、`-+`。
- 非零零点：`a0[v1]=alpha1`、`a0[v2]=alpha2`、`b0[1]=beta`。
- 圈动量：`{ell}`；无进入内线的外动量。

## Sector 与关系计数

每种 building block：

- `++/--`：top sector 有四个 `{n1,n2}` 状态，每态两个 time 加一个 momentum，共 12 条；shrunk sector 有一个 time 与一个 momentum，共 2 条。
- `+-/-+`：massiveCross 只有 top sector；四个离散态，每态三个生成元，共 12 条。
- h/H 合计：`2*(2*(12+2)+2*12)=104` 条。

## 参考符号

参考 bubble code 明确使用

```text
Vpm=0 for --
Vpm=1 for ++
theta boundary coefficient = C (-1)^(n_endpoint+Vpm)
```

因此 expected 不接受把 `++` 与 `--` 的 massive Wronskian shrink offset 都设成 0。

## 易错点

- time 端点导数产生 `n+1` 后立即 EOM。
- q-IBP 的 massive building-block 导数也可能产生 `n=2`，必须立即 EOM。
- massiveCross 保留两个 `n`，但没有 theta shrink。
- h shrink：`a0Merged=alpha1+alpha2-2 nuM`、`bS0=beta+2 nuM`。
- H shrink：`a0Merged=alpha1+alpha2`、`bS0=beta`。
- massive shrink 的整数指标为 `bS=b+1`。

## H 模式 EOM

裸 Hankel 取 `H1=partial_x H0`，使用

```text
H2 = -H0 - H1/x + nuM^2 H0/x^2.
```

expected 对 time 与 momentum seed 分别显式写出二次-pole 项；同时独立检查 Wronskian 的 `1/x` shrink power、零点为 0 和 SK 符号。007--010 都必须通过同一份 104 条 expected。
