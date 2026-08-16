# FlintNDE 0.4.0 正规化角域/候选容量独立检验报告

日期：2026-08-16
对象：当前 `versions/FlintNDE-0.4.0/flintnde/regularization.py`
结论：**通过**

## 快照与 fresh-clean

本 runner 未读取 validation-01 或旧 summary。数值计算前检查并删除本专项旧 `results/`、旧报告
和 cache；清理目标 2 个，清理后全部不存在：
`True`。当前工作精度为
120 位十进制，单进程执行。

当前关键 SHA-256：

- `regularization.py`：`cf82e843132520d533df3f339c34a8c721afad41ef1fc10494510662c59bfe97`
- `flintnde/__init__.py`：`ebd3e0de94a5936d9a64a8a7fbed71fd895bb572ebebda514e02e573e0ee7d7c`
- `run_validation.py`：`221750766d91fd2331b201f3aa7f7fdb039a61739d8e5ad4af18dbd94c0e0688`

## 默认 Automatic 基线

使用 `F(ep)=2/ep+3+4 ep+5 ep^2`。生产点数 4，验证点数
3；`sample_source=automatic`。四个生产点逐项与旧公式
`(1/100)(1+i/100)` 比较，最大复数绝对差
`0.000000e+00`，最大虚部绝对值
`0.000000e+00`。边界收到的全部 regulator 参数均为 exact
`fmpq`：`True`。

前三个自动验证点与对应生产点同角、模长缩为 1/2；直接复数缩放最大差
`0.000000e+00`。四个已知 Laurent 系数最大绝对差
`1.166667e-38`，`precision_target_met=`
`True`。

## 开角域

只增加 `sample_angle_range=(-1,1)`，其余网格参数与默认 case 相同。实际角数量
3，按点循环匹配内部均匀角 `-1/2,0,1/2`；最大角差
`9.016581e-131`。所有点严格位于开区间内部，且模长相对默认同索引
旧公式最大差 `5.635363e-132`。

自动验证点与对应生产点同角且整体缩为 1/2：最大复数缩放差
`4.031538e-132`，最大角差
`0.000000e+00`。相同 Laurent 系数恢复最大差
`3.382583e-42`，`precision_target_met=`
`True`。

## 显式候选池耗尽

候选点 4 个，独立验证点 2 个。严格容差下实际使用 2 轮，最终
`sample_count=4`、`sample_candidate_count=4`、
`unused=0`。程序仍返回 powers
`[0]` 和 1 个系数，但
`precision_target_met=False`，失败原因
`candidate_pool_exhausted`。

边界工厂实际调用 6 次，无重复：`True`；调用
参数集合严格等于四个候选点和两个验证点：`True`。匹配“候选池耗尽且未
生成池外点”的 RuntimeWarning 数量为 1。

## 门禁结论

| case | status | wall time |
| --- | --- | ---: |
| default Automatic | passed | 0.005319 s |
| sample angle range | passed | 0.004790 s |
| candidate pool exhausted | passed | 0.003953 s |

机器 summary 保留全部生产/验证点、角、模长、系数误差、边界调用和 warning。所有正式输出为
UTF-8 无 BOM、无 replacement character；本专项目录无 cache/temp。该结论只覆盖本任务列出的
正规化采样与容量合同，不扩大为其它 DE/边界类型的完整认证。

复核命令：

```powershell
python -B package-FlintNDE/independent-validation/FlintNDE-0.4.0-validation-02-regularization-angle-and-candidate-capacity/run_validation.py
```
