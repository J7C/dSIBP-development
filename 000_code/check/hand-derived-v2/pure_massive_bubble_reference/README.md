# pure_massive_bubble_reference

## 函数族

- 顶点：`{v1,v2}`。
- line 1：massive h，端点 `{v1,v2}`，动量 `Q1=q`。
- line 2：massive h，端点 `{v1,v2}`，动量 `Q2=q-k`。
- `loopMomenta={q}`、`externalMomenta={k}`，外不变量 `sp[k,k]->s11`。
- 两条 massive 线共用 `nuM`，但本 family 不自动加入拓扑对称性；对称性只在 README 中作为 reference 条件说明。
- 非零零点：`alpha1,alpha2,beta1,beta2`；massive shrink 派生 `bS0[e]=beta[e]+2 nuM`。

## 验证范围

- 4 个顶点符号组合。
- `++/--` 覆盖 `top,e1,e2,e1_e2`；`+-/-+` 只覆盖 `top`。
- 每个 sector 的全部 active time、`d/dq.q`、`d/dq.k`。
- 每条 active massive 线的全部 `{n1,n2} in {0,1}`。
- package example 必须逐项比较 `expectedRelations`，并核对 `pureMassiveBubbleExpectedCounts`。

## reference-only 对称性说明

当且仅当两条内线的 `nu`、零点、归一化完全相同，并且外腿参数满足对应相等条件时，才可额外输入 line exchange 或 vertex exchange 的 `symmetryRules`。本 hand-derived expected 保持 `symmetryRules={}`，避免把 reference 条件误当成一般 bubble 恒等式。
