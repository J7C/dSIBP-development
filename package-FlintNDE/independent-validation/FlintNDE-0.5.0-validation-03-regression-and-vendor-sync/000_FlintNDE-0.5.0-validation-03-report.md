# FlintNDE 0.5.0 Validation-03 独立报告

- 状态：**passed**，7/7。
- Python 完整回归：`181` 项，退出码 `0`，wall time `10.742533 s`。
- Wolfram `Needs` 端到端：`26/26`，退出码 `0`，wall time `4.126498 s`。
- 独立包与 MadStree v0.16 Vendor：相对文件集合 `44` 项；SHA-256 不同 `0` 项。

## 同步边界

- 独立包仅开发用的 `DEVELOPMENT_PLAN.md` 与 `todolist.md` 不属于 Vendor 交付集合。
- cache、pyc、results_temp/results_test 不参与同源比较；MadStree 自有 adapter 不在 Vendor 根中。
- independent-only：`[]`；vendor-only：`[]`；digest mismatch：`[]`。
- 标准 Wolfram 测试曾创建版本内 runtime：`True`；报告前已清理：`True`。

## 产物

- 机器 summary：`results/summary.json`，含全部逐文件 SHA-256。
- 完整 Python/Wolfram stdout、stderr：`results_temp/`，属于可重跑临时证据。
- 失败项：`无`。
