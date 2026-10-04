# MadStree v0.17 Validation-05 独立报告

- 状态：**passed**，22/22。
- 源码聚合 SHA-256：`7c9cc813b0c6d3eaffb85ce567f00bdb763cedc20ea904ebeb7337f258fbea11`。
- 图包含 top/contact 两层；master 顺序、contact 权重和正负 shift 均 exact 比较。

## Recurrence

contact child 的 component 基准幂为 `A=a1+a2+1`；直接 Gamma 积分给出 `J(+1)=(a1+a2+2)/[-I(k1+k2)] J(0)` 与 `J(-1)=[-I(k1+k2)]/(a1+a2+1) J(0)`。
`MSRecurrenceStep` 和 `MSReduce` 对两式的 exact residual 均保存在 `results/summary.wl`。

## 换基与表示桥

H/h 局部矩阵逐项等于显式手推矩阵，sector 状态向量双向为 identity；已积分对象无法唯一换基并 fail closed。
MadStree/dSIBP 三槽表示逐 master 和线性表达式 round-trip，sector、shift、state slot 与 normalization 不丢失。
非法 sector、缺失/重复 MasterBasis 均 fail closed。

## 数值路径、展开与耗时

本 case 只作 exact symbolic 检验；数值点、路径、边界展开阶和输运阶均不适用。
总 wall time：`1.20248 s`。
