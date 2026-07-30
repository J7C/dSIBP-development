# NLQNM 2x2 NDE 交叉检查

`check_01_nde_nlqnm_2x2.py` 在相同的统一 `u` 方程、端点基和 horizon 首项归一化下，
用 FlintNDE 从字面量 `inf` 和 horizon 奇点 fresh 重算 OOO-232 两个 parent 的 2x2
connection，并与现有 NLQNM `04_qnm_connection` 结果比较 `Cout`、`Cin` 和禁戒分量比例。
无穷远使用单重二阶-pole 的形式指数递推、固定 N 阶加五阶块比诊断，并与独立二阶标量
递推交叉验证。五阶块比不小于 1 时只警告并保留结果，summary 同时记录块比和五阶相对
refinement。

检查只覆盖 NDE connection 层，不调用 Npackage Step4，也不比较 `Rhat`。正式轻量结果保存到
`results/check_01_nde_nlqnm_2x2_summary.json`。
运行 convention 来自 `package-FlintNDE/config/qnm_u_unified_it0_3_it1_minus1.json`；summary
记录实际 `ConfigPath`、`ConventionName`、`it0`、`it1` 及配置 SHA-256。
