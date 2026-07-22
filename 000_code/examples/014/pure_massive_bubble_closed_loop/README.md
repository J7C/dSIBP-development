# Pure massive bubble closed loop

本例固定 `--` branch、even parity 和等能量约束。package 顶点能量为 `P_pkg=P0=+I k0`，reference basis 的能量为 `P1=P2=P_ref=-P0=-I k0`。本例演示从 014 package 初始化到 Kira 输入、外部 reduction、结果取回、19 维微分方程与 Eq. (51)/(64) 标度检查的完整流程。顶点交换 symmetry 只在本例等能量约束下启用；独立 `P1/P2` family 不得复用。

1. 运行 `wolframscript -file main.wl`。package 在本例目录下写出 `init/` 和 `kira/`，但不会启动 Kira；首次正常状态为 `awaitingExternalKira`。
2. 进入 `kira/`，在已经配置 Kira 2.3 的环境中运行 `kira jobs.yaml`。完整结果应写入 `kira/results/Tuserweight/`，并保留本次 `kira.log`。
3. 再运行 `wolframscript -file main.wl`，或只运行 `wolframscript -file post_kira_check.wl`。后者不重新生成 seed/Kira 输入，只执行 `DSKiraImport -> DSDE[{s11,P0}] -> DSScaleCheck[{2,1}]`。

最终 DE 与同序 master list 写入 `results/dlogDE/`，闭环摘要写入 `results/post_kira_summary.wl`。若修改 family、active basis、package 或 Kira 输入，必须重新生成并运行 reduction；脚本会拒绝读取早于当前 export manifest 的旧结果。
