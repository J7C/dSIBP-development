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
- `++/--` 覆盖三条 full 线的所有逐线 shrink sector；`+-/-+` 只覆盖 `top`。
- 每个 sector 覆盖全部 active time、`d/dq.q`、`d/dq.k1`、`d/dq.k2`。
- 每条 active masslessFull 线覆盖 `n=0/1`；masslessCross 无 `n`。

## guard 目的

本 family 只比较当前 package 的 per-line merged-theta 版本。future bundle 版本应使用独立的 bundle 表示，不写回当前三槽 `J`，也不用于判定 011 失败。
