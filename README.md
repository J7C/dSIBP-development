# dSIBP-development

本仓库包含三个职责分离的程序包：`dSIBP` 生成一般 dS 图的关系，`MadStree` 用闭合公式直接处理 tree/time-only 积分，`FlintNDE` 数值求解与物理模型无关的矩阵微分方程。

## 程序包总览

| 程序包 | 输入与输出 | 主要特征 | 当前入口 |
| --- | --- | --- | --- |
| [dSIBP](package-dSibp/README.md) | 任意圈数、任意拓扑、massive/massless 混合图；输出 time/loop IBP、参数微分 seed、sector metadata、`linearData` 和 Kira 基础输入 | topology-driven Wolfram Language 关系生成器；只生成、检查和序列化关系，不运行 reduction | `package-dSibp/versions/020_dSIBP/`；正式单文件 `package_020.0.wl` |
| [MadStree](package-MadStree/README.md) | dS tree 或只积分时间变量的 incidence graph；输出主积分、公式型迭代约化、dlog DE、Frobenius 边界和数值调用配置 | formula-driven Wolfram Language 包；支持 massive/massless quotient 与冗余 Hankel 表示，内置并自动调用 FlintNDE | `package-MadStree/load_current.wl`；当前 `v0.5` |
| [FlintNDE](package-FlintNDE/README.md) | 一阶矩阵 DE、普通点向量或奇点边界、路径和精度；输出局部级数、路径输运、保存点与边界常数 | 独立 Python/FLINT 后端；支持普通点、正则奇点和已认证的部分高阶 pole，超出能力时 fail closed | `package-FlintNDE/versions/FlintNDE-v0.1.0.dev0/`；导入名 `flintnde` |

两条工作流互不混用：

```text
一般 dS 拓扑 -> dSIBP -> linearData/Kira 输入 -> 外部 reduction 后端

tree 或 time-only graph -> MadStree -> 主积分/dlog DE/物理边界 -> FlintNDE -> 数值主积分
```

`dSIBP` 不调用 MadStree 或 FlintNDE。MadStree 负责 dS 公式、主积分顺序、normalization 和边界条件；FlintNDE 只消费通用矩阵 DE 与边界数据，不知道图、sector 或主积分的物理含义。

## 当前版本

- dSIBP：开发主线 `020_dSIBP`，正式冻结交付 `020.0`；另保留 `018_dSIBP`、`019_dSIBP`。
- MadStree：`v0.5`。
- FlintNDE：`0.1.0.dev0`。

当前任务、未完成项和实际验收状态统一见 [研究计划与研究进度.md](研究计划与研究进度.md)。各包的公式、接口和能力边界以自己的 README、`Documentation/` 与 `AGENTS.md` 为准。

## 典型示例

### dSIBP

目录：`package-dSibp/independent-benchmark/package/examples/`。

| 示例 | 覆盖内容 |
| --- | --- |
| `01_mixed_bubble_workflow.wl` | mixed bubble 基本工作流 |
| `02_function_system_hankel.wl` | Hankel/function-system 输入与变换 |
| `03_single_massive_sunrise/` | 两圈 single-massive sunrise 的 general seeds 与 `{ss11,kE}` 参数算符 |
| `04_pure_massive_bubble_closed_loop/` | 19-master Kira 回读、DE、reference 与 scaling 闭环 |
| `05_tree_two_vertex_time_ibp/` | 两顶点 tree time-IBP、naive DE 与公式路线 |
| `06_mix_bubble_tree/` | mixed cycle/bridge、massless convention 与 contact contraction |

`03_single_massive_sunrise/` 当前不生成 sampled relations、Kira、DE 或 scaling。它的纯数值 DE/scaling 闭环已登记为未完成独立验证任务，不能用其它 topology 的结果代替。

### MadStree

目录：`package-MadStree/versions/MadStree-v0.5/Examples/`。

| 示例 | 覆盖内容 |
| --- | --- |
| `01_massless_full_edge.wl` | massless quotient、主积分、递推、dlog 和自动边界/数值入口 |
| `02_vertex_family_reduction.wl` | 单顶点专用输入、局部张量逆和有限线性组合约化 |
| `03_time_only_cycle_chart.wl` | time-only 圈图、共同 theta、contact sector 与全部 strict-rank chart |

三个 example 已在 v0.5 fresh 运行并退出 `0`。独立验证 T1--T6 均由 v0.5 fresh 执行并通过；T6 通过 Wolfram 公开入口验证内置 FlintNDE 的保存点和能力边界。

### FlintNDE

目录：`package-FlintNDE/examples/`。

| 示例 | 覆盖内容 |
| --- | --- |
| `qnm_2x2.py` | exact 2x2 QNM 系统、无穷远形式渐近和双端匹配 |
| `regular_singular_save.py` | 正则奇点 `{a,b,C}` 边界、普通保存点与 refinement |
| `exponential_boundary_save.py` | 已认证指数型奇点 `{phi,a,b,C}` 的保存和复用 |

后两项抽自当前 `76/76` 回归中已经执行的公开调用配置；本轮只做脚本语法和路径检查，不把它们记成新的数值验收。

## 输出位置

- dSIBP 只生成关系与后端输入；外部 reduction 工作区由调用方管理。
- MadStree 调用 FlintNDE 的临时 JSON 和 Python cache 位于调用脚本旁的 `results_temp/`；保存点进入调用目录的 `results/`。
- FlintNDE 的正式结果位于调用脚本旁的 `results/<run_name>/`；路径 `save` 文件也可由 `save_output_directory` 指定到调用者目录。
- package 源码目录不接收用户运行产物。开发测试使用 `test/results_test/` 或 `results_temp/`。

## 文档与验证

- dSIBP：`package-dSibp/Documentation/`、`package-dSibp/independent-benchmark/`、`package-dSibp/000-report/`。
- MadStree：`package-MadStree/versions/MadStree-v0.5/Documentation/`、`package-MadStree/independent-validation-task/`、`package-MadStree/independent-validation/`。
- FlintNDE：`package-FlintNDE/Documentation/`、版本 README、`check_*` 与 `test/`。

验证报告只证明其记录的版本、路径和范围。旧实现历史保留在 Git history 和进度归档中，不在根 README 重复维护。

## 版本与分支规则

2026-07-30 之后新建的程序包版本必须自带 `UPDATE_NOTES.md`，说明基线、新增功能、修复、接口或 convention 变化、迁移要求、验证状态和已知限制。现有 dSIBP 018.1、MadStree v0.3、FlintNDE 0.1.0.dev0 及更早资产不追溯补建。

建议新版本从稳定主线建立独立 Git branch。是否创建、保留、关闭或合并 branch 由仓库所有者决定；agent 不会因版本完成而自行合并到 `main`。
