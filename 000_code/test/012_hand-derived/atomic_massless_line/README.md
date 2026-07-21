# atomic_massless_line

## 函数族

- 顶点：`{v1,v2}`。
- 有序端点：`{v1,v2}`；另建 `{v2,v1}` 专测方向反转。
- 内线：一条 massless 线，动量 `ell`。
- 圈动量：`{ell}`；无进入内线的独立外动量。
- 顶点能量：`E1,E2`。
- 非零零点：`a0[v1]=alpha1`、`a0[v2]=alpha2`、`b0[1]=beta`。
- 顶点分支：`++`、`--`、`+-`、`-+`。

## Sector 与关系计数

- `++/--`：`top` 与 `e1`。
  - top：`n[1]=0,1`；每态两个 time 与一个 `d/dell.ell`，每个符号 6 条。
  - e1：一个 active time 与一个 `d/dell.ell`，每个符号 2 条。
- `+-/-+`：只有 top；无离散 `n`，各两个 time 与一个 momentum，每个符号 3 条。
- 全 sector/generator relations：`2*(6+2)+2*3=22`。

另有 8 个原子检查：端点反转两式、同端点二阶两式、两个 delta 端点、coincident `n=1` 和 `sp` 的 Orderless。

## 易错点

- masslessFull 第一端点定义 `n=1` 方向。
- `++/--` regular 导数符号相反。
- `+-/-+` 没有 theta、无 `n`、无 shrink。
- `n=1` 第一/第二端点 delta 系数为 `-2/+2`。
- massless shrink 保持 `bS=b`，合并后只有一个 `a`。
- shrink sector 仍保留非零 `a0[v1]+a0[v2]` 与 `bS0=beta`。
