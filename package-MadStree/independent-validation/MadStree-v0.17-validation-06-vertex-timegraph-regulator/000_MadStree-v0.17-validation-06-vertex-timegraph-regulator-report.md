# MadStree v0.17 Validation-06 独立报告

- 状态：**passed**，23/23。
- 源码聚合 SHA-256：`7c9cc813b0c6d3eaffb85ce567f00bdb763cedc20ea904ebeb7337f258fbea11`。
- 独立 oracle：单顶点 Gamma 积分；平行双 massless 线的两时间排序 chamber 闭式。

## 单顶点与 cyclic time graph

单顶点 master/dlog、边界 `t^2` leading weight 和 `k0=3 i` 普通点均与 `Gamma[a+1](-i k0)^(-a-1)` 比较。
time graph 为两条平行 massless `++` 线的真实 cycle；四个 top 状态和两个 contact child 共 6 个 master。
time graph 两变量 DE exact residual、边界 `t^4` leading vector 与普通点六分量差均写入 `results/summary.wl`。

## Regulator

令 `a=1+ep` 且 normalization 为 `(1+ep)/ep`，闭式为 `((1+ep)/ep) Gamma[2+ep] 3^(-2-ep)`；最低幂为 `ep^-1`。
生产点与验证点不相交；首轮内部最高幂 0，失败后增 2 阶并复用旧生产/验证点。
两点候选池反例返回 `computed_with_warning/candidate_pool_exhausted`，同时保留当前最佳系数。

## 导出、路径与耗时

CSV/JSON 只保留两个 `saved` 记录，排除临时 waypoint；字符串 `Infinity`、相对差和精度门禁字段完成 round-trip。
无 saved 点时返回 `SavedPointResultsRequired`。
实际路径、边界/输运阶和各阶段 wall time 均见机器摘要；总 wall time：`15.9255 s`。
