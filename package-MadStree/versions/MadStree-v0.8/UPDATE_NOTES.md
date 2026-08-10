# MadStree v0.8 更新说明

English version: [UPDATE_NOTES_en.md](UPDATE_NOTES_en.md)。

## 基线

- 在 v0.7 基础上修改建立（版本沿革 v0.5 -> v0.6 -> v0.7 -> v0.8；v0.7 已冻结）。
- v0.7 源码、手册、examples 与验证结果作为基线保持不变；v0.8 升级内置 FlintNDE 至 0.2.0，并重构数值输运链以使用极点--留数快速路径、嵌入式截断认证和后端输出缓存。

## 新增功能

- **极点--留数序列化（schema v2）**：普通段不再序列化完整有理矩阵 `Q(i)(s)`，而是沿仿射路径将每个 dlog letter `α_j+β_j s` 序列化为极点 `p_j=-α_j/β_j` 与留数矩阵 `M_j` 的记录（`madstree_flintnde_transport_v2`）。后端 `PartialFractionSystem` 直接用极点状态递推生成解系数，省去 Cauchy 采样。同极点 letter 自动合并留数。`msAffineLetterData` 替换 v0.7 的 `msAffineConnectionData`；`msAffineLetterRecord` 负责逐 letter 的仿射检验与序列化。
- **嵌入式截断认证**：奇点段与普通段均显式传 `certificationMode -> "embedded"`，后端只跑 `referenceOrder` 一条链，主链结果由解系数前缀重新 Horner 求值得到（递推前缀性质保证逐位一致），参考链开销归零。逐段截断差作为局部误差估计随报告返回。
- **Dense output 保存点**：保存点不再成为路径节点；端点保存仍挂在首末节点，内部保存走 `sample_points` 参数在某普通段 Cauchy 圆盘内求值，不改变路径。
- **后端输出缓存**：`msExecuteFlintNDEAdapter` 在 `runtimeDirectory/flintnde_cache/<digest>/` 下缓存后端输出。digest 取请求 payload 去除 `saveOutputDirectory` 和 `backendPackagePath` 后的 `Hash[ExportString[#, "RawJSON"]]`，保证确定性。成功（`status == "success"`）才复用，失败输出不作缓存命中。
- **RootReduce 代数数处理**：`msGaussianRationalParts` 对 `(-1)^(1/3)` 等代数数常量先做 `RootReduce`，再 `ComplexExpand` 拆分为 `a+b I` 分量，确保序列化字符串始终是可被 `arb()` 解析的 `p/q` 字面量。
- **非 dlog 回退标记删除**：`Boundary.wl` 中的 `fallbackUsedQ` 和 `directIntegrationFallbackQ` 痕迹标记已删除；数值入口一律 `certifiedByFormulaChecks` 门控。测试中对应断言同步移除。

## 接口与路径变化

- `MSFlintNDEConfiguration[]` 的缺省相对路径仍为 `Vendor/FlintNDE`，基准目录是当前 MadStree 版本目录；Vendor 内核已更新为 FlintNDE 0.2.0。
- Python 适配器 `flintnde_transport.py` 新增 `_build_partial_fraction_system`（v2 极点--留数）与 `_build_rational_system`（v1 有理矩阵 / 奇点段）分支；极点通过 `GaussianRational.to_acb()` 转为 acb ball。
- 普通段使用 `build_straight_path`（直线步进，步幅 `step_fraction=0.45`）替代 `build_adaptive_path`；奇点段保持 `build_adaptive_path` + detour。
- `relative_difference_inf` 改用 `matrix_norm_inf`（对列向量行为一致），使 batch Frobenius 输运的多列 snapshots 也能通过嵌入式截断认证路径。
- `MSFlintNDETransport` 的 ordinary inputData 不再含 `variable`/`matrix`/`saveOutputDirectory`，改含 `letters`（极点--留数记录列表）。

## 修复

- 修复 letter 矩阵序列化时未代入 `constantRules` 导致 time power 符号 `a` 泄漏到 payload 的问题。
- 修复 `PartialFractionSystem` 极点未通过 `GaussianRational.to_acb()` 转换导致 `'GaussianRational' object has no attribute 'str'` 的问题。
- 修复 batch Frobenius 输运多列 snapshots 在嵌入式截断认证中触发 `vector_norm_inf requires a column vector` 的问题。

## 迁移

- v0.7 的显式加载路径无需改动；把 `versions/MadStree-v0.8/` 加入 `$Path` 后可直接调用 `Needs["MadStree`"]`。
- 依赖 v0.7 schema v1 有理矩阵序列化的外部脚本需更新为 v2 极点--留数格式，或在 MadStree 侧添加 v1 兼容分支。
- `flintnde_cache/` 目录由 MadStree 自动创建，属调用目录产物；`results_temp/flintnde_transport/` 仍为临时 JSON 交换区，成功后删除。

## 验证状态

- `check_core` fresh 通过 `49/49`。
- `test_package_artifacts` fresh 通过 `18/18`。
- `test_flintnde_boundary` fresh 通过 `9/9`（`relativeDifference ≈ 4.9e-45`）。
- `test_flintnde_massive_vertex` fresh 通过 `7/7`。
- `test_flintnde_massless_edge` fresh 通过 `9/9`。
- `test_flintnde_massive_full_edge` fresh 通过 `5/5`。
- `test_flintnde_mixed_three_vertex` fresh 通过 `7/7`。
- `test_flintnde_vertex_family` fresh 通过 `7/7`。
- `test_dsibp_derivative_dlog` fresh 通过 `9/9`。
- `test_simultaneous_cycle_chart` fresh 通过 `22/22`。
- `test_vertex_family_reduce` fresh 通过 `18/18`。
- 合计 `160/160` 项检查全部通过。

## 已知限制

- 不生成一般 IBP 方程组，不运行 Kira，也不复制 dSIBP 的外动量求导实现。
- 极点--留数快速路径仅适用于 dlog letters 沿仿射路径退化为 `α+β s` 的情形；非仿射或高次 letter 会 fail closed（`FlintNDEExactPathRequired`）。
- 内置 FlintNDE 0.2.0 的数学能力边界与来源版本一致；vendor 不扩大其 irregular/Stokes 覆盖范围。
