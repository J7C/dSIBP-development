# dSIBP

`dSIBP` 是 topology-driven Wolfram Language 关系生成器。它从任意圈数、任意拓扑以及
massive/massless 混合的 dS Feynman 图输入生成 time/loop IBP、参数微分 seed、sector
metadata 和 backend-neutral `linearData`，并可序列化 Kira 基础输入；程序包本身不运行
reduction。

## 当前版本与入口

- 当前模块化源码：`versions/022_dSIBP/`。
- 标准加载：把该目录加入 `$Path` 后调用 `Needs["dSIBP`"]`。
- 验收后的工作树唯一代码版本：`022_dSIBP/`。更早版本只从 Git 历史追溯。

首次成功加载会显示一次引用提醒。在 Notebook 中 arXiv 号为可点击链接；headless kernel
保留完整 URL。建议引用 [arXiv:2401.00129](https://arxiv.org/abs/2401.00129)、
[arXiv:2411.03088](https://arxiv.org/abs/2411.03088)、
[arXiv:2604.14549](https://arxiv.org/abs/2604.14549) 和 dSIBP package paper
（arXiv identifier pending）。

早期 `010_dS_ibp_general.wl` 是尚未模块化的通用 dS IBP 单文件实现；011--015 是该路线的
后续历史快照。它们已被模块化版本和当前正式交付取代，并按仓库版本保留策略
于 2026-07-30 删除；需要追溯时从 Git 历史读取，不再作为运行入口。

020.0 把 `ibpMode -> "timeOnly"` 的唯一公开积分改为
`J[sectorKey,timeShifts,stateBits]`。`sectorKey` 按 root propagator 顺序保存定长 `0/1`
字符串，`timeShifts` 与 `stateBits` 分别保存当前 sector 的 compact 时间幂和离散
building-block 状态；旧 time-only `J[aList,linePacks,{}]` 不兼容。full-loop 仍使用原三槽
表示，因此 Kira/reduction 资产不需迁移。022 破坏性删除旧 topology schema：顶点只接受
`id/vertexType/externalLegEnergy`，line 只接受 `id/massType/endpoints/momentum`，massive
另需 `nu`；SK、pack、state 与 contact 元数据全部由内部 producer 派生。细节见
[`versions/022_dSIBP/UPDATE_NOTES.md`](versions/022_dSIBP/UPDATE_NOTES.md)。

## 目录

- `versions/`：只保留当前 022 模块化源码。
- `Documentation/`：plan、design note、技术手册和专项正确性清单。
- `independent-benchmark/`：独立任务书、正式 022.0 交付、reference results 和 examples。
- `000-report/`：只归档当前 022 且未被后续同类证据取代的独立检验报告。
- `check-smoke/`：维护者轻量检查；不属于独立验证证据。

详细开发、验证和发布门禁见本目录 [AGENTS.md](AGENTS.md)。

## Examples

当前源码随包提供 `versions/022_dSIBP/Examples/`；正式交付在
`independent-benchmark/package/examples/` 同步保留六个互补入口：

- `01_mixed_bubble_workflow.wl`：mixed bubble 基本工作流。
- `02_function_system_hankel.wl`：Hankel/function-system 输入与变换。
- `03_single_massive_sunrise/`：两圈 single-massive sunrise 的 general seeds 与 `{ss11,kE}` 参数算符。
- `04_pure_massive_bubble_closed_loop/`：19-master Kira 回读、DE、reference 与 scaling 闭环。
- `05_tree_two_vertex_time_ibp/`：两顶点 tree time-IBP、naive DE 与公式路线。
- `06_mix_bubble_tree/`：mixed cycle/bridge、massless convention 与 contact contraction。

`03_single_massive_sunrise/` 明确不进入 sampled relations、Kira、DE 或 scaling。它的纯数值 DE/scaling 闭环已在任务书与进度表登记为未完成验证；其它 topology 的旧闭环不能替代。
