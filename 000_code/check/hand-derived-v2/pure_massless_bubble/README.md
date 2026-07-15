# pure_massless_bubble

## 函数族

- 顶点：`{v1,v2}`。
- 两条有序 massless 线均连接 `{v1,v2}`。
- 动量路由：`Q1=q`、`Q2=q-k`。
- `loopMomenta={q}`、`externalMomenta={k}`、`sp[k,k]->s11`。
- 非零零点：`alpha1,alpha2,beta1,beta2`。
- 顶点能量：`E1,E2`。
- 不输入积分族 `symmetryRules`。
- 当前比较路线：每条线各自使用 merged-two-theta 的 `{b[e],n[e]}`。共同 theta bundle 只保留未来计划，不进入 expected。

## Sector 与关系计数

同分支 `++/--`：

| sector | full 离散态 | active time | momentum | 每个符号关系数 |
|---|---:|---:|---:|---:|
| top | 4 | 2 | 2 | 16 |
| e1 | 2 | 1 | 2 | 6 |
| e2 | 2 | 1 | 2 | 6 |
| e1_e2 | 1 | 1 | 2 | 3 |

每个同分支符号 31 条，两种共 62 条。

异分支 `+-/-+`：两条线都是 masslessCross，只有 top、无离散态，两个 time 加两个 momentum，每个符号 4 条，共 8 条。

总关系数：`70`。

## 易错点

- massless shrink 保持 `bS=b`。
- 任意一条线 shrink 后两个顶点合并，另一条未缩并平行线的端点变为 coincident。
- coincident masslessFull 的 `n=1` 积分必须为零。
- top time-IBP 的 shrink 边界项也必须按目标 sector canonical；不能只用 source top 的端点 metadata。
- `d/dq.q` 与 `d/dq.k` 使用
  `z1=q^2`、`z2=(q-k)^2`、`q.k=(z1+s11-z2)/2`。
