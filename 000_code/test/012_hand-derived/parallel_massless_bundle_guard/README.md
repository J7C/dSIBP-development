# parallel_massless_bundle_guard

## 函数族

- 顶点：`{v1,v2}`。
- 三条 massless exp 线均有序为 `{v1,v2}`：
  - `Q1=q`
  - `Q2=q-k1`
  - `Q3=q-k2`
- `loopMomenta={q}`、`externalMomenta={k1,k2}`。
- 外不变量：`sp[k1,k1]->s11`、`sp[k1,k2]->s12`、`sp[k2,k2]->s22`。
- 非零零点：`alpha1,alpha2,beta1,beta2,beta3`；massless shrink 保持 `bS0[e]=beta[e]`。

## 验证范围

- 4 个顶点符号组合。
- `++/--` 覆盖 `top,e1,e2,e3,e1_e2_e3`；`+-/-+` 只覆盖 `top`。
- 每个 sector 覆盖全部 active time、`d/dq.q`、`d/dq.k1`、`d/dq.k2`。
- 每条 active masslessFull 线覆盖 `n=0/1`；masslessCross 无 `n`。

## guard 目的

本 family 验证逐线 pack 与共同-theta boundary 的一致性：single contacts、一次 simultaneous triple contact、coincident odd-state canonical，以及不存在 pair sectors。当前关系总数为 194。
