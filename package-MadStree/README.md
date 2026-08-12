# MadStree 版本与验证入口

MadStree 是以 Wolfram Language 为主体、自动调用 FlintNDE 数值后端的 dS time-integral 公式程序包。当前工作版本为 `v0.10`。

## 目录

- `versions/MadStree-v0.10/`：v0.10 的 Wolfram 源码、内置 FlintNDE 0.3.0 同版本同步副本、手册、examples 和开发测试。
- `AGENTS.md`：MadStree 的版本、目录、输出和独立验证报告规则。
- `independent-validation-task/`：单列的独立验证任务书；不复制到验证工作目录。
- `independent-validation/MadStree-v0.5-validation-*/`：v0.5 的 T1--T6 程序、结果和自动报告；旧版本目录保留冻结证据，后续版本沿用该验证证据。
- `VERSION_INDEX.md`：当前版本、状态和版本升级记录。
- `load_current.wl`：加载 `VERSION_INDEX.md` 指定的当前版本；正式复现应使用显式版本路径。

## 版本规则

是否升级版本只由用户的明确指令决定，不由改动类型或改动大小自动触发。用户未要求升版时，代码、公式和接口的小改动继续写入当前工作版本；用户明确要求新开或发布版本后，才从当前工作版本复制建立新的 `MadStree-vX.Y/` 目录。新版本建立后，此前版本冻结并永久保留，不得覆盖或删除。

本规则生效后新建的每个版本目录必须包含 `UPDATE_NOTES.md`，至少记录基线版本、新增功能、修复、接口或 convention 变化、迁移要求、验证状态和已知限制；v0.3 及此前已有版本不追溯补建。建议新版本从当前稳定主线建立独立 Git branch 开发和验证，但 branch 是否创建、保留或合并完全由用户决定，默认不会自动合并到 `main`。

显式加载 v0.10：

```wl
packageRoot = ".../package-MadStree/versions/MadStree-v0.10";
AppendTo[$Path, packageRoot];
Needs["MadStree`"];
```

运行时生成的适配器 JSON、日志和 Python cache 写入调用脚本目录的 `results_temp/`，不写入版本源码目录。数值路径只使用两阶段工作流：`MSGeneratePath` 规划多变量用户路径并保存拉回后的单变量计划，`MSEvaluatePlannedPath` 直接执行已有计划，`MSPlannedPathQ` 验证计划对象，`MSExportEvaluationData` 导出普通保存点。裸用户点缺省保存；`{coord,"tmp"}` 是临时路径点，`{coord,"lo"}` 请求方向相关的奇点领头阶；其它字符串标签拒绝。正式结果由调用程序写入自己的 `results/`。

任何经过中途节点的多点输运都称为折跃；只有用局部基显式穿过奇点时才称为奇点折跃。`SingularityMode -> "Avoid"` 是缺省；`"SingularityJump"` 显式允许奇点折跃，并要求用户确认等价绕行路径的多值分支。`MessageLanguage -> "EN"|"CN"` 缺省英文且严格区分大小写。若仿射段的全部 dlog letters 都是常量，该段按零连接正常输运。工作位数为 `ceil(WorkingPrecision*log2(10))+32`，70、100 位分别对应 265、365 bit，更高精度按同一公式增长。

## Examples

v0.10 在 `versions/MadStree-v0.10/Examples/` 随附五个典型脚本：`01_massless_full_edge.wl`、`02_vertex_family_reduction.wl`、`03_time_only_cycle_chart.wl`、`04_three_vertex_tree.wl` 和 `05_massive_three_vertex_tree.wl`。它们分别覆盖 massless quotient 的完整公式/数值入口（01 另含用户自定义边界、批量多点求值与 CSV/JSON 导出）、单顶点函数族约化、time-only 圈图的共同 theta/contact/chart，以及三顶点 massless/massive 树图（+++）的批量求值与导出；五个 examples 由 v0.9 沿用（其中 01--03 源于 v0.5）；本轮 v0.10 fresh 运行 `5/5` 全部退出 `0`，完整回归口径见 `versions/MadStree-v0.10/UPDATE_NOTES.md`。

## 独立验证

每个验证任务目录名必须包含被验证版本号。目录内的 `run_validation.wls` 负责执行检查、保存机器可读结果，并生成按名称排序位于最前面的 `000_MadStree-vX.Y-...-report.md`。报告必须包含验证目标、版本与源码身份、输入、所选数值点、实际路径、各类展开阶数、工作精度、分项或总耗时、实际执行结果、失败边界和结果文件；因此验证目录内不再放任务书副本。完整合同见 `AGENTS.md`。

v0.5 fresh 重跑 T1--T6，计数依次为 `24/24`、`12/12`、`18/18`、`15/15`、`17/17`、`16/16`；任务书位于 `independent-validation-task/MadStree-v0.5-independent-validation-task.md`。后续版本沿用该 T1--T6 验证证据；v0.5 的 11 个开发 tests 与三个原始 examples 亦串行通过，核心计数包括 core `49/49`、simultaneous/time-only chart `22/22`、vertex/reduction `18/18` 和跨包 DE `9/9`。v0.10 fresh 验证为路径专项 `53/53`、Python adapter `10/10`、12 个 Wolfram 开发测试文件合计 `221/221`，Examples 01--05 为 `5/5` 全部退出 0；详见 `versions/MadStree-v0.10/UPDATE_NOTES.md`。
