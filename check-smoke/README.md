# check-smoke

本目录只供 package 维护 agent 保存小范围、轻量、可随时运行的 smoke/check/test 脚本。

- 可复用轻量脚本直接放在本目录，命名为 `check_*.wl`、`check_*.wls`、`test_*.wl` 或 `test_*.wls`。
- 所有运行产物只能写入 `results_test/`；可重跑中间产物只能写入 `results_temp/`。两类目录均不提交，并在当前任务结束后清理。
- 不在这里运行 Kira/Fermat reduction，不保存大型表达式、正式 expected、独立手推、冻结哈希或正式报告。
- 本目录不是 package 下游输入，也不为任何物理正确性结论提供独立证据。
- 内部和外部独立审计都禁止读取、复制、写入或引用本目录；独立审计必须使用与本目录完全隔离的工作区。
