# MadStree v0.13

- 版本：`v0.13`
- 状态：当前工作版本
- 语言：Wolfram Language
- 数值后端：版本内嵌 `Vendor/FlintNDE`，与独立 FlintNDE 0.4.0 逐文件同步。
- 缺省 convention：`NuConvention -> "Positive"`
- 数值工作流：`MSEvaluatePath[context, 用户点序列]` 只识别连续同复平面段并拉回 DE；
  全部段在一次 Python 进程中由 FlintNDE 规划和执行。
- 规划开关：`FlintNDEPathPlanning -> True` 缺省启用 FlintNDE 自动节点规划和 fast dense
  multipoint evaluation；`False` 严格以段内用户点为输运节点。
- 路径策略：`SingularityMode -> "Avoid"` 缺省拒绝穿过奇点；`"SingularityJump"` 只在
  开启 FlintNDE 路径规划时可用，并要求用户确认多值分支。
- 消息语言：`MessageLanguage -> "EN"|"CN"`，缺省英文。

本目录从 v0.12 升级。v0.13 以 `vertexType` 与端点派生数据为唯一拓扑 authority；旧
`phaseSign/skType/sigma/phaseSigns` 即使作为额外键出现也不读取，旧线型和迁移 wrapper
均不存在；完整变化见 `UPDATE_NOTES.md`。
