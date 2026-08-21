# MadStree v0.15

- 版本：`v0.15`
- 状态：当前工作版本
- 语言：Wolfram Language
- 数值后端：版本内嵌 `Vendor/FlintNDE`，目标为与独立 FlintNDE 0.5.0 逐文件同步。
- 缺省 convention：`NuConvention -> "Positive"`
- 数值工作流：`MSEvaluatePath[context, pointSequence, ParameterRules -> {...}]` 中
  `pointSequence` 首行定义可跑动坐标、后续行给坐标值；固定参数只给一次。程序只识别连续
  同复平面段并拉回局部参数化 DE；
  全部段在一次 Python 进程中由 FlintNDE 规划和执行。
- 规划开关：`FlintNDEPathPlanning -> True` 缺省启用 FlintNDE 自动节点规划和 fast dense
  multipoint evaluation；`False` 严格以段内用户点为输运节点。
- 路径策略：`SingularityMode -> "Avoid"` 缺省拒绝穿过奇点；`"SingularityJump"` 只在
  开启 FlintNDE 路径规划时可用，并要求用户确认多值分支。
- 消息语言：`MessageLanguage -> "EN"|"CN"`，缺省英文。

本目录从 v0.13 升级。v0.15 删除逐点规则列表 schema；解析 `MSDLogDE` 及落盘
`dlog_de.wl` 不受数值参数替换影响。v0.13 的 `vertexType`、端点派生拓扑和 normalized master
合同保持不变；完整变化见 `UPDATE_NOTES.md`。
