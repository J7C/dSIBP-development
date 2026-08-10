# MadStree v0.9 更新说明

English version: [UPDATE_NOTES_en.md](UPDATE_NOTES_en.md)。

## 基线与定位

- 在 v0.8 基础上修改建立（版本沿革 v0.5 -> v0.6 -> v0.7 -> v0.8 -> v0.9；v0.8 已冻结）。
- v0.8 源码、手册、examples 与验证结果作为基线保持不变；v0.9 不改任何数值逻辑、序列化 schema、缓存合同与数值结果，主题为落实审计项 F2 修订版（见根仓库 `000_report/2026-08-10-三程序包最新版落地审查.md`）：**后端失败诊断与 examples 失败门禁**。

## 设计原则（用户 2026-08-10 确认）

**零探测**：不探测用户目录、不尝试候选解释器、不硬编码机器路径；Python 的安装与 PATH 配置是用户自己的责任。包只保留两条显式通道（`PythonExecutable` 选项、`MADSTREE_PYTHON` 环境变量），包的责任是运行失败时把问题说清楚。

## 新增与修复

1. **后端失败诊断增强**（`Kernel/Numerics/FlintNDE.wl` 的 `msExecuteFlintNDEAdapter`）：
   - 后端子进程的 stdout/stderr 重定向到 `results_temp/flintnde_transport/madstree-flintnde-log-<uuid>.txt`；失败时读回日志尾部（至多 2000 字符）放入 `Failure` 的 `"stderr"` 键；成功时删除日志文件。
   - 新增两条诊断 Message（声明于 `Kernel/MadStree.wl`）：
     - `MSFlintNDETransport::backendLaunchFailed`：后端未产生输出（通常是解释器不可用或缺 python-flint），内容含实际解释器命令、捕获的输出尾部，以及两条修复通道（为解释器安装 python-flint；或用 `PythonExecutable` 选项 / `MADSTREE_PYTHON` 环境变量指向装有 python-flint 的解释器）。
     - `MSFlintNDETransport::backendRunFailed`：后端运行但返回非 success，内容含实际解释器命令与后端 `error` 文本。
   - 缓存逻辑（digest 键、仅 success 复用、失败状态文件不命中）完全不变。
2. **`MADSTREE_PYTHON` 通道下沉到包级**：`MSFlintNDETransport` 的 `PythonExecutable` 缺省由 `"python"` 改为 `Automatic`；新解析函数 `msResolvePythonExecutable` 的解析顺序为：显式字符串原样使用 → `MADSTREE_PYTHON` 环境变量（非空时）→ `"python"`。全程无任何候选探测。`PythonExecutable::usage` 同步更新；`test/_harness.wls` 保持显式传参不变。
3. **examples 失败门禁**（`Examples/01--05`）：
   - 每个 example 尾部新增总门禁：任一被检查结果为 `Failure` 时打印原因并 `Exit[1]`，全部非 `Failure` 时打印 `Example PASSED`。
   - 01/04/05 另在被下游消费的中间结果处加快速失败门禁（01：`targetValue`、`userAnchorValue`；04/05：`targetValue`），后端失败时脚本在第一失败点停止，不再级联刷屏（`MapThread::mptd`、`Lookup::invrl` 等）；04/05 的 `AnchorValues` 在失败时携带空占位符。
   - examples 的调用方式保持缺省：不传 `PythonExecutable`、不读环境变量，与用户文档一致。
4. **版本标识**：`$MadStreeVersion` 由 `"0.7"`（v0.8 遗留）更正为 `"0.9"`；`test_package_artifacts.wls` 的版本断言同步更新。

## 不变项

数值逻辑、序列化 schema v1/v2、嵌入式截断认证、dense output、缓存 digest 与目录布局、公开 API 签名与选项名、`BoundaryVectorDimension` 等输入门禁。

## 验证（2026-08-10 本机 fresh 运行）

- 11 个开发测试在 `MADSTREE_PYTHON=D:/anaconda/python.exe` 下全部 exit 0（合计 160/160）：check_core `49/49`、test_package_artifacts `18/18`、test_flintnde_boundary `9/9`、test_flintnde_massive_vertex `7/7`、test_flintnde_massless_edge `9/9`、test_flintnde_massive_full_edge `5/5`、test_flintnde_mixed_three_vertex `7/7`、test_flintnde_vertex_family `7/7`、test_dsibp_derivative_dlog `9/9`、test_simultaneous_cycle_chart `22/22`、test_vertex_family_reduce `18/18`。
- examples 01--05 缺省运行（无环境变量；本机缺省 `python` 解析到装有 flint 0.9.0 的解释器）全部 `Example PASSED`、exit 0。
- 负例验证：对无 flint 的干净 venv 显式传 `PythonExecutable`，输出为单条 `backendRunFailed` Message（`Backend error: No module named 'flint'.`），返回 `Failure`（含 `"stderr"` 键），门禁退出码 1，无刷屏。

## 迁移与兼容性

- v0.8 的显式加载路径无需改动；把 `versions/MadStree-v0.9/` 加入 `$Path` 后可直接调用 `Needs["MadStree`"]`。
- 此前依赖缺省 `"python"` 的调用方行为不变（未设置环境变量时 `Automatic` 仍解析为 `"python"`）；希望用环境变量通道时设置 `MADSTREE_PYTHON` 即可。
- 显式传 `PythonExecutable -> "..."` 的脚本继续有效，语义不变。

## 已知限制

- 与 v0.8 相同：不生成一般 IBP 方程组，不运行 Kira，不复制 dSIBP 的外动量求导实现；极点--留数快速路径仅适用于 dlog letters 沿仿射路径退化为 `α+β s` 的情形；内嵌 FlintNDE 0.2.0 的数学能力边界与来源版本一致。
- 缺省解释器解析依赖运行环境的 PATH：若缺省 `python` 无 python-flint，后端会以单条诊断 Message 失败（这是预期行为，非包缺陷）；按 Message 指引安装或指定解释器即可。
