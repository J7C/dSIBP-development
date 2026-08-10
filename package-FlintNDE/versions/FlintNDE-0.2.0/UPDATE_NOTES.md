# FlintNDE 0.2.0 更新说明

## 基线

- 在 0.1.0 基础上修改建立（版本沿革 0.1.0.dev0 -> 0.1.0 -> 0.2.0；0.1.0 已冻结）。
- 0.1.0 源码与测试作为基线保持不变；0.2.0 新增极点--留数递推、嵌入式截断认证、dense output 采样点和 Mathematica 嵌入接口。

## 新增功能

- **PartialFractionSystem**：`A(z)=C+Σ_j R_j/(z-p_j)` 型系统的极点状态递推。每步状态更新 `u_j[n]=(c[n]-u_j[n-1])/(z-p_j)`、`c[n+1]=(C·c[n]+Σ_j R_j·u_j[n])/(n+1)`；只含 O(极点个数) 次矩阵--向量乘，不做全矩阵系数卷积。递推前缀性质保证高阶运行给出的低阶系数与低阶运行逐位相同，是嵌入式截断认证的基础。
- **嵌入式截断认证**（`certification_mode="embedded"`）：只跑 `reference_order` 一条链，主链结果由解系数前缀重新 Horner 求值得到（递推前缀性质保证逐位一致），参考链开销归零；逐段截断差作为局部误差估计随报告返回。`"certified"` 模式保留独立双链完整重算用于论文级认证。
- **Dense output 采样点**（`sample_points`）：段内 Taylor 系数 Horner 求值，不改变路径；逐点结果以 `role="sample"` 记录随 payload 回传。
- **Mathematica 嵌入接口**：`Mathematica/FlintNDELoader.wl` + `flintnde/mathematica_bridge.py`，用户在 wolframscript 中 `Get` loader 后可直接调用 `flintNDETransport[...]`，最终结果（`finalValues`、`samplePoints`、`segmentTruncationDifferences` 等）直接读进 MMA 变量。例子 `examples/mathematica_interface_example.wl` 提供端到端示范。
- **GaussianRational.to_acb()**：无损送入当前工作精度的 Acb ball，供 PartialFractionSystem 构造使用。

## 接口变化

- `transport_path_refined` 新增 `certification_mode` 和 `sample_points` 关键字参数。
- `transport_frobenius_boundaries_refined` 新增 `certification_mode` 关键字参数。
- `build_straight_path(system, start, target, *, step_fraction=0.20)` 按最近奇点距离的一定比例构造直线路径。
- `relative_difference_inf` 改用 `matrix_norm_inf`（对列向量行为一致），使 batch Frobenius 输运的多列 snapshots 也能通过嵌入式截断认证路径。
- `_mma_float_literal`：Python float 转 Wolfram `*^` 记号，修复 segmentTruncationDifferences 的 `e` 记号解析问题。

## 修复

- `mathematica_bridge.py` 删除不存在的 `write_save_points` 关键字传参。
- `FlintNDELoader.wl` 修复 Association 内 ReplaceAll 替换结果不重新求值的问题（递归拆解 `flintNDEEncode`）。
- `FlintNDELoader.wl` 修复 `CreateDirectory` 幂等性（已存在目录不再报错）。

## 验证状态

- 新增 12 项 unittest 全部通过（覆盖 PartialFractionSystem 解系数递推、embedded 截断认证、sample points 求值、MMA 桥接往返）。
- 0.1.0 既有 unittest 全部通过（2 项既有环境失败除外）。
- MMA 例子 `mathematica_interface_example.wl` 端到端 PASSED（embedded 认证，`relativeDifference ≈ 6e-31`）。
