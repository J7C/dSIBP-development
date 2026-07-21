# mixed_bubble

## 函数族

- 顶点：`{v1,v2}`。
- line 1：massive h 线，端点 `{v1,v2}`，动量 `Q1=q`，质量参数 `nuM`。
- line 2：massless exp 线，端点 `{v1,v2}`，动量 `Q2=q-k`。
- `loopMomenta={q}`、`externalMomenta={k}`、`sp[k,k]->s11`。
- 非零零点：`alpha1,alpha2,beta1,beta2`。
- massive h shrink 的零点由规则派生：`a0 -> alpha1+alpha2-2 nuM`，`bS0[1] -> beta1+2 nuM`。
- massless shrink 保持 `bS0[2] -> beta2`。
- 顶点能量：`E1,E2`。
- 不输入积分族 `symmetryRules`。

## Sector 与关系计数

同分支 `++/--`：

| sector | full 离散态 | active time | momentum | 每个符号关系数 |
|---|---:|---:|---:|---:|
| top | 8 | 2 | 2 | 32 |
| e1 | 2 | 1 | 2 | 6 |
| e2 | 4 | 1 | 2 | 12 |
两条平行线共享一个 boundary，`e1_e2` 不可达。每个同分支符号 50 条，两种共 100 条。

异分支 `+-/-+`：line 1 是 massiveCross，line 2 是 masslessCross，只有 top；massive 四个 `{n11,n12}` 状态，两个 time 加两个 momentum，每个符号 16 条，共 32 条。

总关系数：`132`。

## 易错点

- line 1 massive h 的 `n=2` 必须即时 EOM。
- line 1 shrink 使用 `bS=b+1`，line 2 shrink 使用 `bS=b`。
- line 2 masslessFull 在 line 1 shrink 后端点 coincident，`n=1` 积分必须 canonical 为零。
- line 1 massiveFull 在 line 2 shrink 后端点 coincident，不按 massless 规则置零。
- coincident massive pack 使用 `{b,1,0}={b,0,1}` canonical。
- top time-IBP 的 shrink 边界项必须按目标 sector canonical。
- `d/dq.q` 与 `d/dq.k` 使用 `z1=q^2`、`z2=(q-k)^2`、`q.k=(z1+s11-z2)/2`。
