# 原始结果与外部独立对照

## 数据位置

- `native/*_result.wl`：每支完整原结果，含各点向量、边界、路径、后端报告。
- `native/*_export/evaluation_data.json` 与 CSV：三个点、所有 master，原导出标明 70 位有效数字。保留字节不变；读取长小数应使用十进制/字符串，不能先转 binary64 再显示很多位。
- `backend_outputs/`：原生成功后端 JSON 的逐字副本；包含球记录、实际节点、内部精度指标。
- `reference/`：自行编写的积分参考原始 JSON、多阶结果、固定积分诊断及未完成尝试说明。NaN 和原失败标志未删改。
- `comparison/bubble_comparisons.json`：原混合结果 `comparisons.json` 中 `.bubble` 的原值子树；其整文件哈希在来源清单中。
- `comparison/by_point_and_branch.csv`：3 点×(4 支+K) 的 15 行完整对照，所有值和误差均复制已保存字段；未重新相减、相除或计算误差界。
- `internal_precision_checks.json`：包内部检查，单独列出，不能替代外部比较。

## 独立参考的来源与算法

`bubble_reference.py` 由本次复现工作的 Codex 会话自行编写，不是论文作者提供的程序。输入为积分定义及参数，不调用 MadStree 或 FlintNDE，也不读原生 DE、边界或终值作为参考答案。使用 python-flint 的 Acb/Arb 算术；使用同一个底层数值库不等于调用 FlintNDE 输运。

将 `t=-tau` 的正支旋到 `-i u`、负支旋到 `+i u`，Hankel 展开为 `J_(±nu)` 的级数。两内线每端的幂与 `p=1+i/2` 合并后剩余一次时间幂及展开幂，公共常数为 `(x1*x2)^(-2nu)`。同号分支合并两个对称排序室，异号分支可因子化。排序矩使用脚本中的 Gamma 与 `2F1` 表达式。该实现使用 `rho>x1+x2` 的绝对收敛范围，覆盖本次三个点。

保存脚本的 `kernel_tail_bound` 使用正项 majorant 及几何尾界控制截断，`rounding_only_balls` 只描述球算术舍入。最终比較中的 K 尾界来自原轮保存的比较记录，**本轮没有再次运行尾界函数**。

`direct_quadrature.py` 是另一条有限精度诊断：直接调用 Hankel 函数作二维 Gauss–Legendre 积分，经 `v=y^4,s=w^4` 变换，截断 `v=12`，节点数 32/64/96、binary64 节点、mpmath 工作精度25。只覆盖 rho=10 的 pp；约14位的诊断能力不能当作25位或更高精度证书。两次未完成的 Wolfram 积分尝试日志也保留，不计为通过。

## 误差定义及判据

原比较脚本定义 `absolute=abs(native-reference)`，`relative=abs((native-reference)/reference)`；零参考时 relative 为 null。外部比较使用参考球的 **中点**；误差列不是包含截断和舍入不确定性的严格相对误差区间。

包内 `TargetRelativeError="1e-32"` 是本次脚本明确给定的标准，所有保存点 `targetRelativeErrorMet=false`。内部 `relativeDifferenceInf` 的原球字符串已另存。日志表明 Frobenius 初始化不能复用 embedded 路线，因此后端实际升级为独立 primary/reference 两条链；保存段 `certificationMode="certified"` 不表示物理定义独立验证通过，也没有把 false 目标标志变成 true。

原论文的 201 点、输运差 `1.025e-50`、边界两档差 `4.740e-24`、外部扫描差 `3.70e-14` 是待复现主张，不是本次三个点已达到的验收结果。本次没有已保存的统一外部 PASS 阈值表，也不在本轮新设阈值补判通过。

## 已有差异的摘要

| rho | pp 相对差（摘要） | mm 相对差（摘要） | K 相对差（摘要） |
|---|---|---|---|
| 10 | 0.55628 | 0.55628 | 2.61361 |
| 5 | 1.89999 | 1.89999 | 4.25531 |
| 2.8 | 17.4378 | 17.4378 | 27.4188 |

摘要是旧字段的缩短展示，完整原值在 CSV。pm/mp 的中点相对差约为 `1e-29` 至 `1e-26`，不能据此宣称全部位数获得严格认证。

尤其 rho=2.8 的保存 K 截断上界约 `6.412e-23`，其强度不足以支持以 `1e-26` 中点差声称相应精度已认证。rho=10、5 的尾界分别约 `1.057e-46` 和 `4.864e-33`；这是 K 的总尾界，不应随意改称每支或每个 master 的误差界。较早 JSON 中的 `truncation_certified:false` 保留原样，后续比较文件另存尾界；两个阶段的字段不能合并成一条伪造的原始输出。

本轮没有 201 点新扫描，没有修复后结果，没有性能复测，也没有为缺失指标补算。
