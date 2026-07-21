# mixed_sunrise

## 函数族

- 顶点：`{v1,v2}`。
- line 1：massive h，端点 `{v1,v2}`，动量 `Q1=q1`。
- line 2：massless exp，端点 `{v1,v2}`，动量 `Q2=q2`。
- line 3：massless exp，端点 `{v1,v2}`，动量 `Q3=q1-q2-k`。
- `loopMomenta={q1,q2}`、`externalMomenta={k}`，外不变量 `sp[k,k]->s11`。
- ISP：`rho1=sp[q1,k]`、`rho2=sp[q2,k]`。
- 非零零点：`alpha1,alpha2,beta1,beta2,beta3`；massless shrink 保持 `bS0=beta`。

## 验证范围

- 4 个顶点符号组合。
- `++/--` 覆盖 `top,e1,e2,e3,e1_e2_e3`；triple sector 来自一次共同 contact，`+-/-+` 只覆盖 `top`。
- 每个 sector 覆盖全部 active time 和 6 个 momentum 生成元：
  `d/dq1.q1,d/dq1.q2,d/dq1.k,d/dq2.q1,d/dq2.q2,d/dq2.k`。
- active massive 线覆盖 `{n1,n2} in {0,1}`；active masslessFull 线覆盖 `n=0/1`。
- ISP seed 覆盖 `{0,0}`、`{1,0}`、`{0,1}`，用于检查 ISP 自身导数。

## 易错点

- 三条线保留逐线 pack，但共同 boundary 包含 single contacts 与系数 `1/4` 的 triple contact。
- shrink 后两个原顶点合并，active time 生成元必须同时作用到剩余线的两个原端点。
- momentum IBP 的标量积坐标由 `{z1,z2,z3,rho1,rho2}` 闭合。
