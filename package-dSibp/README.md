# dSIBP

`dSIBP` 是 topology-driven Wolfram Language 关系生成器。它从任意圈数、任意拓扑以及
massive/massless 混合的 dS Feynman 图输入生成 time/loop IBP、参数微分 seed、sector
metadata 和 backend-neutral `linearData`，并可序列化 Kira 基础输入；程序包本身不运行
reduction。

## 当前版本与入口

- 当前模块化源码：`versions/023_dSIBP/`。
- 标准加载：把该目录加入 `$Path` 后调用 `Needs["dSIBP`"]`。
- 当前正式交付：`independent-benchmark/package/package_023.0.wl` 与同目录用户手册。
  工作树只保留 `023_dSIBP/` 与 `package_023.0.*`；更早版本只从 Git 历史追溯。

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
`id/vertexType/externalLegEnergy`，传播子只接受 `id/massType/endpoints/momentum`，massive
另需 `nu`；SK、pack、state 与 contact 元数据全部由内部 producer 派生。当前版本保持该公开 schema，
但修正 same-branch massive contact 与 child normalization 的 contour sign，并新增时间 IBP
小 t 整数端点门禁。细节见
[`历史版本更新日志/dSIBP-023.0.md`](历史版本更新日志/dSIBP-023.0.md)。

## 目录

- `versions/`：只保留当前模块化源码。
- `历史版本更新日志/`：长期保留各版本更新说明，不随旧源码目录清理。
- `Documentation/`：plan、design note、技术手册和专项正确性清单。
- `independent-benchmark/`：独立任务书、当前正式交付、reference results 和 examples。
- `000-report/`：只归档当前版本且未被后续同类证据取代的独立检验报告。
- `check-smoke/`：维护者轻量检查；不属于独立验证证据。

详细开发、验证和发布门禁见本目录 [AGENTS.md](AGENTS.md)。

## Examples

当前源码随包提供 `versions/023_dSIBP/Examples/`；正式交付在
`independent-benchmark/package/examples/` 同步保留六个互补入口：

- `01_mixed_bubble_workflow.wl`：mixed bubble 基本工作流。
- `02_function_system_hankel.wl`：Hankel/function-system 输入与变换。
- `03_single_massive_sunrise/`：两圈 single-massive sunrise 的 general seeds 与 `{ss11,kE}` 参数算符。
- `04_pure_massive_bubble_closed_loop/`：19-master Kira 回读、DE、reference 与 scaling 闭环，以及轻量输入/结果摘要。
- `05_tree_two_vertex_time_ibp/`：两顶点 tree time-IBP、naive DE 与公式路线。
- `06_mix_bubble_tree/`：mixed cycle/bridge、massless convention、contact contraction，以及 81-master Kira/DE 轻量摘要。

`03_single_massive_sunrise/` 明确只到 general seeds/operators，不进入 sampled relations、Kira、DE 或 scaling，也不登记为第三套待运行的 reduction。

真实 Kira reduction 不在 examples 目录运行。04 的脚本要求用 `DSIBP_KIRA_WORKSPACE` 指定仓库外工作区；正式 04/06 结果均由 WSL Kira 2.3 在外置目录生成。仓库只保留输入脚本与轻量摘要，完整 `init/`、`kira/`、日志、reduction table、database、save、cache 和 DE 运行目录已清理。
