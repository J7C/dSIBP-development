# 运行入口与整理边界

## 已保存的原计算脚本

| 文件 | 作用/状态 |
|---|---|
| `original/bubble_calibration_rational120_intlimit.wls` | 此次成功原生四支、三个点的入口 |
| `original/bubble_calibration.wls` | 更早精确 sqrt(2) 尝试；不是成功结果入口 |
| `original/bubble_calibration_rational120.wls` | 有理化后、Python 整数限制尚未调整的尝试 |
| `original/bubble_reference.py` | 本次自行编写的直接积分定义参考，Bessel 级数与排序矩算法 |
| `original/direct_quadrature.py` | rho=10、pp 的直接二维固定节点 Hankel 积分诊断 |
| `original/bubble_direct_quadrature*.wls` | 旧轮未完成的辅助积分尝试 |
| `original/comparison_bubble_source_excerpt.py.txt` | 原比较脚本中 bubble 块及辅助函数的逐行原文，带原行号；不可执行 |
| `original/test_bubble_reference.py` | 旧参考程序的单元测试原件，本轮未执行 |

原 case 的目录布局是 `scripts/`、`sources/dSIBP-Packages/`、`results/` 和 `venv/`。脚本通过 `$InputFileName` / `__file__` 定位该布局；这里移动后的目录不满足原假设，所以不提供会意外写入旧结果的“一键运行”。如需重现，另建隔离 case、固定版本、配置依赖、复制入口再执行；本轮用户明确未授权重算，以上只是说明复现入口及所需条件。

原环境记录见 `provenance/original_version_records/environment.json`、`requirements-lock.txt`。原生程序使用 Wolfram 14.3；Python 来自原 case 的 venv，使用包自带 Vendor/FlintNDE。成功尝试名称、日志及旧诊断表明该受信任计算进程设置过 `PYTHONINTMAXSTRDIGITS=0`；这是运行环境处理，不是物理修复。本轮不重现该解析错误。

## 比较脚本的保留方式

原 `scripts/compare_results.py` 同时处理树图和 bubble；原文件不改动，仍保留在源 case。为遵守本目录仅含 bubble 的要求，这里保存带原行号的 bubble 代码节录及整文件哈希。它的 `kernel_tail_bound` 调用在旧轮会实际求值，故本轮**未执行比较脚本**，对照表直接从旧 `results/comparisons.json` 的 bubble 子树整理。

数值原字段与 CSV 保持一致；没有新增相减、归一化、误差界或精度测试。新增的验证入口 `verify_evidence.py` 只检查 SHA-256、目录内容及已存字段对应，不导入任何物理计算脚本。
