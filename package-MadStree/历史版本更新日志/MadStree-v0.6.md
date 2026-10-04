# MadStree v0.6 更新说明

## 基线

- 基于冻结版本 `v0.5` 建立。
- v0.5 源码、手册、examples 与验证结果保持不变。
- 本轮为纯重构与依赖同步版本：公开接口、数值 convention 与输出 schema 均未改变。

## 重构内容

- F1：新增 `Kernel/Core/Paths.wl`，集中调用目录解析（`msRuntimeDirectory`）、绝对路径判定（`msAbsolutePathQ`）与受控目录创建（`msEnsureDirectory`）；`Artifacts.wl` 与 `Numerics/FlintNDE.wl` 共用，消除两份逐字复制的目录样板。
- F4：slot 定位统一为 `TensorAtoms.wl` 的 `msSlotPositionByKey`；`Sectors.wl` 的 canonical state 与 `Recurrence.wl` 的 event 系数不再各自手写 `FirstPosition` 遍历。
- F9：`Numerics/Boundary.wl` 新增 `msRetainNonEnergyRules`，三处删除 energy 规则的写法统一（单顶点锚、逐 rank 锚、曲线规则保留）。
- F20：新增 `test/_harness.wls` 共享加载与汇总样板（`msTestLoadKernel`/`msTestSummary`/`msTestPythonExecutable`）；11 个开发测试统一头部加载与尾部汇总，测试之间不再逐字复制 loader。
- F21：`msTestSummary` 统一 `passed/total`、失败键列表与退出码；两个结构化输出测试（artifact、dsibp 交叉）保留原有模式。
- F24：`Vendor/FlintNDE` 同步为 FlintNDE `0.1.0`（与 `package-FlintNDE/versions/FlintNDE-0.1.0` 一致），`pyproject.toml` 版本号 `0.1.0`。
- 测试基础设施：FlintNDE 后端解析加入 `PythonExecutable` 可选项（原接口已支持）；开发测试可通过环境变量 `MADSTREE_PYTHON` 固定后端解释器，解决 Windows WolframScript 把 `python` 解析到无 python-flint 解释器的问题。

## 接口与路径变化

无。`MadStree.m` 加载表仅新增 `Core/Paths.wl`（私有实现，不改变公开符号）。

## 迁移要求

无。v0.5 调用方无需改动；`$MadStreeVersion` 由 `"0.5"` 变为 `"0.6"`。

## 验证状态

- 11 个开发测试全部 fresh 通过：`check_core` `49/49`、`test_vertex_family_reduce` `18/18`、`test_simultaneous_cycle_chart` `22/22`、`test_package_artifacts` `18/18`（含 Vendor 版本断言更新为 0.6）、`test_dsibp_derivative_dlog` `9/9`，六个 FlintNDE 输运测试全部通过。
- 运行命令（Windows）：`wolframscript -file package-MadStree/test/<name>.wls`；FlintNDE 后端需要 python-flint 时设置 `MADSTREE_PYTHON` 环境变量指向含 flint 的解释器。

## 已知限制

- 与 v0.5 相同：不生成一般 IBP 方程组，不运行 Kira，也不复制 dSIBP 的外动量求导实现。
- Windows WolframScript 注册表可能把裸 `python` 解析到无 python-flint 的解释器；属于运行环境问题，已通过 `MADSTREE_PYTHON` 覆盖。
