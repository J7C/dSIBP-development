# MadStree v0.9

- 版本：`v0.9`
- 状态：当前工作版本
- 语言：Wolfram Language
- 数值后端：版本内嵌 `Vendor/FlintNDE`（FlintNDE 0.2.0），由 Wolfram 侧自动调用
- 缺省 convention：`NuConvention -> "Positive"`
- 后端解释器策略：**零探测**——不探测用户目录、不尝试候选解释器；显式通道仅 `PythonExecutable` 选项与 `MADSTREE_PYTHON` 环境变量（缺省 `Automatic` → 环境变量 → `"python"`）；失败时捕获后端输出并给出诊断 Message；examples 尾部有失败门禁（任一 `Failure` 即 `Exit[1]`）。

本目录是在 v0.8 基础上修改建立（版本沿革 v0.5 -> v0.6 -> v0.7 -> v0.8 -> v0.9；v0.6、v0.7、v0.8 均已冻结），保存 v0.9 的源码、内置数值后端、手册、examples 和开发测试。相对基线的变化见 `UPDATE_NOTES.md`；v0.5、v0.6、v0.7、v0.8 均已冻结，不再回写。
