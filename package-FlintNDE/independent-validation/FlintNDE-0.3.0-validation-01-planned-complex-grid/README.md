# FlintNDE 0.3.0 planned complex-grid validation

本目录执行 `FlintNDE-0.3.0-independent-validation-task.md`。它用二维对角 dlog 系统的闭式解，
独立检查 900 个复点上的路径规划、JSON round-trip、无重规划执行、dense output 和逐点 naive
路线。

从仓库根运行：

```powershell
python package-FlintNDE/independent-validation/FlintNDE-0.3.0-validation-01-planned-complex-grid/run_validation.py
```

正式保留输出位于 `results/`，结论见
`000_FlintNDE-0.3.0-validation-01-planned-complex-grid-report.md`。runner 会覆盖本目录中由它生成的这两类
文件；不读取旧结果生成 expected。
