# FlintNDE 0.3.0 独立检验报告

日期：2026-08-13
对象：`versions/FlintNDE-0.3.0/`
结论：**通过**

## 结论摘要

本次从闭式公式独立生成 expected，在 30x30 复平面网格的 900 个点上检查公开路径计划、
UTF-8 JSON round-trip、既有计划执行和 dense output。整体路线、逐点 naive 路线以及闭式参考
三方逐点互检全部通过；所有 900 项误差保存在 `results/summary.json`。

## 被测系统与环境

系统为 `dY/dz=diag(1/(z-20),-2/(z+20))Y`、`Y(0)=(1,1)^T`，闭式解为
`Y1=1-z/20`、`Y2=(20/(z+20))^2`。网格、蛇形顺序、精度和阶数严格按任务书执行。

- Python：`3.13.2 (main, Feb 12 2025, 14:49:53) [MSC v.1942 64 bit (AMD64)]`
- python-flint：`0.9.0`
- 工作精度：60 decimal digits，
  232 bits
- 主阶 / 参考阶：40 / 48
- 目标相对误差：`1e-30`

## 实际路径与节点规划

Route G 对 900 点只规划一次。实际得到 2 个执行节点、
1 段，另有 899 个用户点由段内 dense
求值覆盖；奇点折跃数为 0。

实际节点链：

```text
0 -> [0.1000000000000000000000000000000000000000 +/- 3e-45] + [1.450000000000000000000000000000000000000 +/- 3e-44]j
```

原始用户点按 30 行蛇形顺序提交；规划器确认全部用户点都在同一收敛盘内，因而实际执行只需
上述单段，蛇形序列中的其余 899 点作为该段 dense sample 求值。报告分别保留原始点顺序与
实际执行节点，不把输入 waypoint 数量冒充执行段数。

计划以 `planned_path_to_json` 写到 `results/plan_grouped.json`，再从磁盘读回并由
`planned_path_from_json(..., system=system)` 校验。执行返回
`execute_existing_plan_without_replanning`；执行期 sentinel 调用次数为
0，因此没有隐式重规划。

Route N 对每个点均从 `z=0`、`Y(0)` 独立开始，共执行 900 次
规划和 JSON 往返；每次计划节点数范围为 2--2，
累计节点数 1800。它不复用 Route G 的计划、dense patch 或前一点状态。

## 数值互检

| 检查 | 数量 | 最大相对无穷范数差 | 门限 | 状态 |
| --- | ---: | ---: | ---: | --- |
| Route G vs 闭式 | 900 | 3.694818e-37 | 1e-28 | passed |
| Route N vs 闭式 | 900 | 3.694818e-37 | 1e-28 | passed |
| Route G vs Route N | 900 | 0.000000e+00 | 1e-28 | passed |

Route G 主阶/参考阶终点差为 8.649320e-46；两条路线的
`target_relative_error_met` 门禁均通过。这里是 900 项逐点数值验证，不是对任意系统的符号证明。

## 效率

| route | language | parallel | planning | JSON round-trip | execution | wall time | check/status |
| --- | --- | --- | ---: | ---: | ---: | ---: | --- |
| G grouped+dense | Python + FLINT | single process | 0.030495 s | 0.055868 s | 0.070052 s | 0.156830 s | passed |
| N pointwise naive | Python + FLINT | single process | 0.059846 s | 0.066874 s | 0.967146 s | 1.095004 s | passed |

当前主机上，逐点 naive 总墙钟 / grouped+dense 总墙钟为 **6.982x**。该倍率包含两条
路线各自的计划、JSON 往返和执行，但不含 Python import；它只适用于本机与本 case。

## 数据流与证据边界

runner 直接构造系统和闭式公式；规划计划写盘后再读回；结果只写本检验目录，不进入程序包源码。
`summary.json` 保存实际输入顺序、完整节点链、逐段报告、900 组结果文本和三种逐点误差。
所有 JSON/Markdown I/O 均显式 `encoding="utf-8"`，并通过严格 UTF-8 回读检查。

未验证范围：奇点折跃的多值分支选择、一般代数扩域、Lee--Moser、高阶 pole、指数型边界、
ramification 与 Stokes matching。故本报告只认证上述普通点复网格的公开 planned-path 数据链，
不扩大为 FlintNDE 全部算法能力的认证。

## 复核命令

```powershell
python package-FlintNDE/independent-validation/FlintNDE-0.3.0-validation-01-planned-complex-grid/run_validation.py
```
