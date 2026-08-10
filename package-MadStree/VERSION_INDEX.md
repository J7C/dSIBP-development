# MadStree 版本索引

## 当前版本

- 版本：`v0.9`
- 目录：`versions/MadStree-v0.9/`
- 状态：当前工作版本
- 版本沿革：`v0.5` -> `v0.6` -> `v0.7` -> `v0.8` -> `v0.9`（v0.9 在 v0.8 基础上修改建立：后端失败诊断增强、`PythonExecutable` 缺省 `Automatic` + `MADSTREE_PYTHON` 包级解析、examples 失败门禁；内置 FlintNDE 保持 0.2.0）
- 验证证据：
  - 11 个开发测试 fresh 全过（`MADSTREE_PYTHON=D:/anaconda/python.exe`，合计 160/160）：check_core `49/49`、test_package_artifacts `18/18`、test_flintnde_boundary `9/9`、test_flintnde_massive_vertex `7/7`、test_flintnde_massless_edge `9/9`、test_flintnde_massive_full_edge `5/5`、test_flintnde_mixed_three_vertex `7/7`、test_flintnde_vertex_family `7/7`、test_dsibp_derivative_dlog `9/9`、test_simultaneous_cycle_chart `22/22`、test_vertex_family_reduce `18/18`
  - examples 01--05 缺省（无环境变量）fresh 全跑，全部 `Example PASSED`、退出码 0
  - 负例验证：对无 python-flint 的解释器显式传 `PythonExecutable`，输出为单条清晰诊断 Message（`Backend error: No module named 'flint'.`）+ `Failure`（含 `"stderr"` 键），example 退出码 1，无 `MapThread::mptd`/`Lookup::invrl` 刷屏

## 保留版本

- `v0.3`：冻结源码、手册、examples 与 T1--T6 报告，不再回写。
- `v0.4`：冻结源码、手册、examples 与 T1--T5 报告，不再回写。
- `v0.5`：冻结源码、手册、examples 与 T1--T6 报告，不再回写。
- `v0.6`：冻结源码、手册、examples 与继承自 v0.5 的 T1--T6 验证证据；作为 v0.7 的冻结基线（由冻结 v0.5 复制），不再回写。
- `v0.7`：冻结源码、手册、examples 与继承自 v0.6 的验证证据；作为 v0.8 的冻结基线，不再回写。
- `v0.8`：冻结源码、手册、examples 与验证证据；作为 v0.9 的冻结基线，不再回写。

## 升级规则

是否升级版本只由用户的明确指令决定，不由代码、公式或接口的改动类型或改动大小自动触发。用户未要求升版时，当前开发修订继续写入当前工作版本；用户明确要求新开或发布版本后，才建立下一版本目录。新版本建立后，此前版本转为冻结状态并永久保留；不得在冻结版本目录内继续修改源码、公式或接口。
