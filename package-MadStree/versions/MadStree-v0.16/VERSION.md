# MadStree v0.16

- 版本：`v0.16`
- 状态：当前工作版本
- 基线：`v0.15`
- 语言：Wolfram Language
- 数值后端：版本内嵌 `Vendor/FlintNDE`，与独立 FlintNDE 0.5.0 同步。
- 缺省 convention：`NuConvention -> "Positive"`
- 数值入口：`MSEvaluatePath[context, pointSequence, ParameterRules -> {...}]`
- 规划：`FlintNDEPathPlanning -> True` 缺省由 FlintNDE 规划节点；`False` 忠实使用用户节点。
- 奇点：`SingularityMode -> "Automatic"` 缺省忠实处理用户输入的有限奇点。
- 消息语言：`MessageLanguage -> "EN"|"CN"`，缺省英文。

本版修复 massive contact/pinch sector 的边界 coefficient：不再在 sector normalization、Hankel
endpoint coefficient 和 component 定义积分之外按收缩线数重复乘 `I^n`。master 定义、
normalization、recurrence 与 dlog DE 不变；完整变化与验证状态见 `UPDATE_NOTES.md`。
