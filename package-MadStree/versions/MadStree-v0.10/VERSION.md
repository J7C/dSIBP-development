# MadStree v0.10

- 版本：`v0.10`
- 状态：当前工作版本
- 语言：Wolfram Language
- 数值后端：版本内嵌 `Vendor/FlintNDE`（FlintNDE 0.3.0 同版本同步副本：折线链式输运、奇点折跃、局部 Frobenius 基、缺省避开奇点模式），由 Wolfram 侧自动调用
- 缺省 convention：`NuConvention -> "Positive"`
- 工作流：**两阶段分离**——`path = MSGeneratePath[context, 用户点序列, ...]` 先规划路径并报告路径上的奇点；`MSEvaluatePlannedPath[context, path]` 只执行该计划，不重新规划。
- 路径策略：`SingularityMode -> "Avoid"` 缺省拒绝穿过奇点的用户线段；`"SingularityJump"` 显式允许奇点折跃，并要求用户确认等价绕行路径的多值分支。
- 消息语言：`MessageLanguage -> "EN"|"CN"`，缺省英文并严格区分大小写。
- 后端解释器策略：**零探测**（沿用 v0.9）——不探测用户目录、不尝试候选解释器；显式通道仅 `PythonExecutable` 选项与 `MADSTREE_PYTHON` 环境变量（缺省 `Automatic` → 环境变量 → `"python"`）；失败时捕获后端输出并给出诊断 Message；examples 尾部有失败门禁。

本目录是在 v0.9 基础上修改建立（版本沿革 v0.5 -> v0.6 -> v0.7 -> v0.8 -> v0.9 -> v0.10；v0.6、v0.7、v0.8、v0.9 均已冻结），保存 v0.10 的源码、内置数值后端、手册、examples 和开发测试。相对基线的变化见 `UPDATE_NOTES.md`；此前版本均已冻结，不再回写。
