# Pure massive bubble closed loop

本例固定 `--` branch、even parity 和等能量约束。package 与 reference 的能量满足 `P_pkg=P0=-P_ref`。本例演示从 018 package 初始化到 formal Kira 输入、外部 reduction、结果取回、19 维微分方程与 Eq. (51)/(64) 标度检查的完整流程。顶点交换 symmetry 只在本例等能量约束下启用；独立 `P1/P2` family 不得复用。

`active_basis_19.wl` 是可直接使用的主积分文件。加载后，`pureMassiveBubbleActiveBasis018[parameterRules]` 返回含 21 个候选关系、`activeIndices=Range[19]`、physical `ks=ss11`、导数变量和 19 个 scaling degrees 的 Association，可直接传给 `DSKiraPlan` 的 `"activeBasis"`。`dlog_basis.wl` 只保留 reference-readable 的旧记号，不应单独作为 formal basis。

1. 运行 `wolframscript -file main.wl`。package 在本例目录下写出 `init/` 和 `kira/`，但不会启动 Kira；首次正常状态为 `awaitingExternalKira`。
2. 进入 `kira/`，在已经配置 Kira 2.3 的环境中运行 `kira jobs.yaml`。完整结果应写入 `kira/results/Tuserweight/`，并保留本次 `kira.log`。
3. 再运行 `wolframscript -file main.wl`，或只运行 `wolframscript -file post_kira_check.wl`。后者不重新生成 seed/Kira 输入，只执行 `DSKiraImport -> DSDE[{ss11,P0}] -> DSScaleCheck[{1,1}]`。

最终 DE 与同序 master list 写入 `results/dlogDE/`，闭环摘要写入 `results/post_kira_summary.wl`。若修改 family、active basis、package 或 Kira 输入，必须重新生成并运行 reduction；脚本会拒绝读取早于当前 export manifest 的旧结果。
