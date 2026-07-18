# vertex_energy_signs

## 函数族

- 顶点：`{v1,v2}`。
- line 1：massless exp，端点 `{v1,v2}`，动量 `Q1=ell-k`。
- `loopMomenta={ell}`、`externalMomenta={k}`，外不变量 `sp[k,k]->s11`。
- 为了闭合 `d/dell.k` 的标量积坐标，本 family 加入零幂辅助 ISP `rho1=sp[ell,k]`，所有 seed 固定 `ispN[1]->0`。
- 非零零点：`alpha1,alpha2,beta1`，massless shrink 保持 `bS0[1]=beta1`。

## 能量 case

- `A`: `v1->ke[1]`、`v2->ke[2]`。
- `B`: `v1->Sqrt[s11]`、`v2->ke[2]`。
- `C`: `v1->ke[3]`、`v2->ke[2]`。

## 验证范围

- 每个能量 case 覆盖 `++/--/+-/-+`。
- `++/--` 覆盖 `top,e1`；`+-/-+` 只覆盖 `top`。
- 每个 sector 覆盖全部 active time、`d/dell.ell`、`d/dell.k`。
- active masslessFull 覆盖 `n=0/1`。

## 易错点

- `+` 顶点相位导数为 `-I E`，`-` 顶点相位导数为 `+I E`。
- `Sqrt[s11]` 只在 case B 中作为与外不变量复用的能量。
- `ke[3]` 是独立能量，不等同于 `ke[1]+ke[2]`。
