# MadStree v0.17 Validation-01 独立报告

- 状态：**passed**，12/12。
- 源码聚合 SHA-256：`7c9cc813b0c6d3eaffb85ce567f00bdb763cedc20ea904ebeb7337f258fbea11`。
- 输入点：`{{k2},{3 I}}`；固定参数：`{q->1}`；私有辅助坐标未进入用户输入。
- boundary/主/参考阶：`Automatic / 80 / 104`；工作精度 40 位。

## 路线与误差

两条路线分别从非零阻尼 boundary anchor 输运到私有辅助能量的物理值 0。省略/显式零 wall time 为 `1.7228346 / 1.5326668 s`。
联合相对误差预算为 `1/50000000000000000000`，安全因子 8；观察差为 `0``38.88534546250926`。实际 segment、anchor 和计时保存在 `results/summary.wl`。

## 结论

两种公开输入生成相同 master 顺序、digest 和解析 dlog；辅助符号互相独立且均不泄漏到 pointSequence/ParameterRules。
机器结果：`results/summary.wl`。
