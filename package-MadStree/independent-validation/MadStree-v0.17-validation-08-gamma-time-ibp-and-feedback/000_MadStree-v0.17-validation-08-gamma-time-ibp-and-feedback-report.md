# MadStree v0.17 Validation-08 独立报告

- 状态：**passed**，30/30。
- 源码聚合 SHA-256：`7c9cc813b0c6d3eaffb85ce567f00bdb763cedc20ea904ebeb7337f258fbea11`。
- 独立来源：Gamma 积分、固定 h 小时间两支表、外腿指数因子的定义求导。

## Gamma 与时间-IBP

正非整数、负非整数和非零纯虚 Gamma 参数均与直接 Gamma 公式 exact 一致；参数化样本覆盖 `-16..0`，数学拒绝集合由同一个非正整数谓词定义。
每个实际 master state 的 `2^n` 小时间分支均由 runner 内的固定表重建；正整数只记录有限安全 shift，实际越过首个非正整数层时才拒绝。

## Regulator 与三顶点双路线

正规化闭式为 `Gamma[ep] 3^(-ep)`；生产/验证样点全部非零，直接 `ep=0` 边界返回 `BoundaryGammaPole`。
`+++`、两条 massive 线的 25 个 master 对 `e1,e2,e3` 分别按定义增加所在 component 的时间幂，再经 `MSReduce` 约回；三张 `25x25` 矩阵与公式 dlog 导数逐项 exact 比较。

## 张量快路与用户反馈

massive `sigma2/T`、massless quotient `sigma1/Hadamard` 及 mixed Kronecker 基均通过 exact round-trip/off-diagonal 检查；同一局部槽混入不共线 Pauli 方向不能由任一单一局部基对角化。
公式/递推路线未发现一般大矩阵 `Inverse` 或无结构 `LinearSolve`，生产源码未发现 `RedundantH` 或 `masslessEndpointH`。
实际触发 11 类公开 Failure；每项均保存 tag、中英文句子、Wolfram 显示文本、原因/下一步词和后端调用计数。静态扫描尚未触发的出口列表保存在 `results/summary.wl`，不冒充动态覆盖。

## 数值路径、展开与耗时

本 case 只有 regulator 部分调用数值 NDE；边界阶 18、主/参考输运阶 120/170、工作精度 200、目标相对误差 `1e-5`。其余检查为 exact symbolic 或隔离 mock，不适用普通物理路径。
每个生产/验证 ep 点的实际边界路径、输运节点、段数、奇点跳跃次数、主/参考差值和分项耗时保存在 `results/summary.wl` 的 `regulator.pointPathSummaries`；完整重型 point evaluation 不进入正式 summary。
regulator wall time：`4.8696 s`；三顶点定义求导：`1.9367 s`；总 wall time：`9.07293 s`。
