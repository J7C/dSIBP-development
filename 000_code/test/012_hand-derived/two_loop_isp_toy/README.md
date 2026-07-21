# two_loop_isp_toy

## 函数族

- 顶点：`{v1,v2}`。
- 三条 massless exp 线均有序为 `{v1,v2}`：
  - `Q1=l3`
  - `Q2=k321`
  - `Q3=l3-k321-wdnmd`
- `loopMomenta={l3,k321}`、`externalMomenta={wdnmd}`。
- 外不变量：`sp[wdnmd,wdnmd]->s11`。
- ISP：
  - `rho1=sp[k321,l3]`
  - `rho2=sp[l3,wdnmd]`
- 非零零点：`alpha1,alpha2,beta1,beta2,beta3`。

## 验证范围

- 4 个顶点符号组合。
- `++/--` 覆盖 `top,e1,e2,e3,e1_e2_e3`；`+-/-+` 只覆盖 `top`。
- 每个 sector 覆盖全部 active time 和 6 个 momentum 生成元。
- active masslessFull 线覆盖 `n=0/1`；cross 线无 `n`。
- ISP seed 覆盖 `{0,0}`、`{1,0}`、`{0,1}`。

## 易错点

- `sp[k321,l3]` 必须按 `sp` 交换性与 `sp[l3,k321]` 等价。
- 用户动量符号名 `l3,k321,wdnmd` 不应被改名。
- `{z1,z2,z3,rho1,rho2}` 必须闭合五个两圈标量积。
- 三条平行线的 triple sector 来自一次共同 contact，不是三个连续 delta。
