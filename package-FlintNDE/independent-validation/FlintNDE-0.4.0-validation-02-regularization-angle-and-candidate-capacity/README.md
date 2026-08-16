# FlintNDE 0.4.0 regularization angle/candidate validation

本目录执行 0.4.0 独立任务书的 Validation-02。runner 在计算前删除本专项旧结果和旧报告，
不读取 validation-01 或其它 retained 结果生成 expected。

```powershell
python -B package-FlintNDE/independent-validation/FlintNDE-0.4.0-validation-02-regularization-angle-and-candidate-capacity/run_validation.py
```

机器结果位于 `results/summary.json`，正式中文报告位于本目录 `000_...-report.md`。
