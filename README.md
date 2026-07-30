# dSIBP-development

本仓库并列维护三个职责分离的程序包。`dSIBP` 负责从一般 dS 图生成关系，`MadStree`
负责直接处理 dS tree/time-only 函数族，`FlintNDE` 负责与物理模型无关的矩阵微分方程
数值求解。三者不是同一程序的三个运行阶段；只有 MadStree 缺省调用其内置的 FlintNDE。

## 三个程序包

### dSIBP

[dSIBP](package-dSibp/README.md) 是 topology-driven Wolfram Language 程序包。它以图拓扑、
传播子和函数族信息为输入，为任意圈数的 dS Feynman 图生成 time/loop-momentum IBP
通用 seed、sector metadata 和动力学量微分算符，并可进一步序列化为 backend-neutral
`linearData` 或 Kira 基础输入。积分约化不在 dSIBP 内执行，需要连接 Kira、Rational Tracer
一类外部线性约化后端；当前仓库明确提供
[`04_pure_massive_bubble_closed_loop`](package-dSibp/independent-benchmark/package/examples/04_pure_massive_bubble_closed_loop/README.md)
中的 Kira 导出、外部 reduction、回读、DE 和 scaling 完整对接示例。

### MadStree

[MadStree](package-MadStree/README.md) 意为 **mad dS tree**。它接收 tree 或 time-only
函数族信息，初始化全部可达 sectors，直接由公式生成全 sector 的 dlog 主积分、迭代约化
metadata 和 dlog 微分方程。用户选定幂次参数后，程序可自动生成 Frobenius 边界数据，并调用
内置 FlintNDE 把主积分数值输运到用户指定的普通点；超出已认证边界或奇点类型时会 fail closed。

MadStree 还加入了论文中尚未给出的结果：对含无质量传播子的树图使用其额外关系，把冗余
Hankel 状态缩并到物理 quotient basis，并在此基础上构造任意树图的迭代约化关系和 dlog DE。
程序同时保留冗余 Hankel 表示，供独立交叉检验。

### FlintNDE

[FlintNDE](package-FlintNDE/README.md) 是基于 Python/FLINT 的通用数值矩阵微分方程程序包。
其稳定主线覆盖普通点、正则奇点、路径输运和保存点。程序还实现了有限的高阶 pole 局部化简
算法，以及带 `exp(-k/t)` 指数因子的广义 power-log 局部级数；这些部分深度参考 AMFlow
开源实现，但没有系统覆盖一般不规则奇点、ramification 和 Stokes matching。MadStree 产生的
dlog DE 不需要这些更复杂的奇点能力。

FlintNDE 另提供 AMFlow-inspired 的解析正规化参数数值重构：在若干固定参数值分别求解完整
DE，再数值拟合例如 `epsilon` 的 Laurent/幂级数系数，并用额外样本验证重构结果。

## 开发方式与反馈

本仓库的程序代码与说明文档均由 AI 编写。作者主要负责设计程序逻辑与交互、提供公式推理
思路、规定物理 convention，并设计独立验证任务和验收标准。若发现 bug，或对输入方式、输出
组织和交互便利性有改进建议，请联系 [jiaqichen@cup.edu.cn](mailto:jiaqichen@cup.edu.cn)。

## 引用

dSIBP 与 MadStree 主要基于以下 dSIBP 系列工作实现。使用这两个程序包时，建议引用与所用
功能相关的三篇论文：

1. Jiaqi Chen and Bo Feng, [*Towards Systematic Evaluation of de Sitter Correlators via Generalized Integration-By-Parts Relations*](https://arxiv.org/abs/2401.00129), arXiv:2401.00129.
2. Jiaqi Chen, Bo Feng and Yi-Xiao Tao, [*Multivariate hypergeometric solutions of cosmological (dS) correlators by d log-form differential equations*](https://arxiv.org/abs/2411.03088), arXiv:2411.03088.
3. Jiaqi Chen, Bo Feng, Zhehan Qin and Yi-Xiao Tao, [*Loop integrals in de Sitter spacetime: The parity-split IBP system and d log-form differential equations*](https://arxiv.org/abs/2604.14549), arXiv:2604.14549.

FlintNDE 的高阶 pole 处理和解析正规化参数重构深度参考了 AMFlow 的公开算法与代码：

- Xiao Liu and Yan-Qing Ma, [*AMFlow: A Mathematica package for Feynman integrals computation via auxiliary mass flow*](https://arxiv.org/abs/2201.11669), arXiv:2201.11669.

## 当前入口

| 程序包 | 当前版本 | 入口 |
| --- | --- | --- |
| dSIBP | `020.0` | `package-dSibp/versions/020_dSIBP/`；正式单文件 `package-dSibp/independent-benchmark/package/package_020.0.wl` |
| MadStree | `v0.5` | `package-MadStree/load_current.wl` |
| FlintNDE | `0.1.0.dev0` | `package-FlintNDE/versions/FlintNDE-v0.1.0.dev0/`；导入名 `flintnde` |

## 依赖与工作流

两条工作流互不混用：

```text
一般 dS 拓扑 -> dSIBP -> linearData/Kira 输入 -> 外部 reduction 后端

tree 或 time-only graph -> MadStree -> 主积分/dlog DE/物理边界 -> FlintNDE -> 数值主积分
```

`dSIBP` 不调用 MadStree 或 FlintNDE。MadStree 负责 dS 公式、主积分顺序、normalization 和边界条件；FlintNDE 只消费通用矩阵 DE 与边界数据，不知道图、sector 或主积分的物理含义。

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
