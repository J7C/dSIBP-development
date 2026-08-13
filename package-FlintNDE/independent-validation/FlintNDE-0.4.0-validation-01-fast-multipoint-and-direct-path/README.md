# FlintNDE 0.4.0 fast multipoint and direct-path validation

本目录执行 `FlintNDE-0.4.0-independent-validation-task.md`。它不消费 0.3.0 的报告或结果；
expected 来自逐点 Horner 和二维对角系统的闭式解。

从仓库根运行：

```powershell
python package-FlintNDE/independent-validation/FlintNDE-0.4.0-validation-01-fast-multipoint-and-direct-path/run_validation.py
```

正式机器结果保存在 `results/summary.json`，中文报告保存在本目录的 `000_...-report.md`。
