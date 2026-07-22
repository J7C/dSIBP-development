# 014 全面 benchmark 与 015 根号坐标增量工作区

本目录保存 `independent-benchmark/independent-benchmark.md` 对应的可复用手推、冻结 expected、check 和轻量结果；正式报告统一归档到根目录 `000-report/`。`kinematic-coordinates/` 是 015 根号坐标的独立增量路线，冻结公式后才允许由 `check/check_kinematic_coordinates_against_package.wl` 单向调用 `package_015.wl`。

当前优先级：

1. `mixed_sunrise`、`two_loop_isp_toy`、`vertex_energy_signs` 的非零 ISP seed；
2. 013/014 新增 pure-time/tree 与三平行 massive h contact；
3. 两个指定 H family 的 bare-H、H-to-h 与 direct-h 全 seed 等价性；
4. general-`ds` 的 upper-triangular `Dij`、相位链式法则与乘积法则；
5. 014 物理 expected 冻结后通过 `package_014.wl` 单向比较；015 坐标 expected 单独冻结后通过 `package_015.wl` 单向比较。

Tree 增量还要求在完全相同的 sector-tagged normalized master 顺序下，分别运行 `DSTreeNaiveIBP -> DSTreeNaiveDE` 和 `DSTreeDLogDE`。naive 路线只能消费投影后的 `dtau` 方程及 h 的原始能量导数，不能调用 `repIterative` 或公式 dlog 矩阵参与约化；最终逐变量矩阵再与冻结公式和直接 dlog 两边比较。

新版任务书到独立 expected 和重建 check 的映射见 `VALIDATION_MATRIX.md`。

旧报告附件只用于确认覆盖缺口，不作为本目录 expected 的公式来源。本轮不是 pristine blind test：开始补充推导前已经审阅旧报告及其 check 结构，但没有从 package actual 或旧 expected 抄写以下 ISP 导数公式。
