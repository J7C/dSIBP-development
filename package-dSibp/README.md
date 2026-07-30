# dSIBP

`dSIBP` 是 topology-driven Wolfram Language 关系生成器。它从任意圈数、任意拓扑以及
massive/massless 混合的 dS Feynman 图输入生成 time/loop IBP、参数微分 seed、sector
metadata 和 backend-neutral `linearData`，并可序列化 Kira 基础输入；程序包本身不运行
reduction。

## 当前版本与入口

- 当前模块化源码：`versions/018_dSIBP/`。
- 标准加载：把该目录加入 `$Path` 后调用 `Needs["dSIBP`"]`。
- 正式单文件交付：`independent-benchmark/package/package_018.1.wl`。
- 保留代码版本：`016_dSIBP/`、`017_dSIBP/`、`018_dSIBP/`。

早期 `010_dS_ibp_general.wl` 是尚未模块化的通用 dS IBP 单文件实现；011--015 是该路线的
后续历史快照。它们已被 016--018 模块化版本和 018.1 正式交付取代，并按仓库版本保留策略
于 2026-07-30 删除；需要追溯时从 Git 历史读取，不再作为运行入口。

## 目录

- `versions/`：保留的 016、017、018 模块化源码。
- `Documentation/`：plan、design note、技术手册和专项正确性清单。
- `independent-benchmark/`：独立任务书、正式 018.1 交付、reference results 和 examples。
- `000-report/`：历史独立检验报告归档。
- `check-smoke/`：维护者轻量检查；不属于独立验证证据。

详细开发、验证和发布门禁见本目录 [AGENTS.md](AGENTS.md)。
