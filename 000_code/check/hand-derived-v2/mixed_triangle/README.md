# mixed_triangle

## 函数族

- 顶点：`{v1,v2,v3}`。
- line 1：massive h，端点 `{v1,v2}`，动量 `Q1=q`。
- line 2：massive h，端点 `{v2,v3}`，动量 `Q2=q-k1`。
- line 3：massless exp，端点 `{v3,v1}`，动量 `Q3=q+k2`。
- `loopMomenta={q}`、`externalMomenta={k1,k2}`。
- 外不变量：`sp[k1,k1]->s11`、`sp[k1,k2]->s12`、`sp[k2,k2]->s22`。
- 非零零点：`alpha1,alpha2,alpha3,beta1,beta2,beta3`。
- massive h shrink 的零点由规则派生：`a0` 减去 `2 nuM`，`bS0 -> beta+2 nuM`。
- massless shrink 保持 `bS0[3] -> beta3`。
- 顶点能量：`E1,E2,E3`。
- 不输入积分族 `symmetryRules`。

## 验证范围

- 8 个顶点符号组合。
- 每个符号组合的所有实际可达 shrink sector。
- 每个 sector 的全部 active time 生成元。
- 每个 sector 的全部 `d/dq.q`、`d/dq.k1`、`d/dq.k2`。
- 每条 active massive 线的所有 `{n1,n2} in {0,1}`。
- active masslessFull 线的所有 `n in {0,1}`；masslessCross 无 `n`。

关系计数由 `expected.wl` 中 `manualTriangleExpectedCounts` 固定，package example 必须逐项核对。

## 易错点

- line 1/2 massive h 的 `n=2` 必须即时 EOM。
- massive shrink 使用 `bS=b+1`，massless shrink 使用 `bS=b`。
- shrink 后 active vertex 的 `a0` 必须合并并减去被缩并 massive h 线的 `2 nuM`。
- line 3 masslessFull 的端点若在目标 sector coincident，则 `n=1` 积分 canonical 为零。
- cross 线不产生 theta shrink sector。
- `d/dq.q`、`d/dq.k1`、`d/dq.k2` 使用独立的三分母变量 `z1,z2,z3`。
