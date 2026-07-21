# hand_derived_cross_checks

本目录保存“程序包 actual vs 独立手推 expected”的交叉验证 examples。

边界：

- 本目录加载 `000_code/012_dS_ibp_general.wl`。
- 本目录读取 `000_code/test/012_hand-derived/<family>/family.wl` 和 `expected.wl`。
- `012_hand-derived` 目录只保存 012 修正后的独立手推输入与 expected。
- 这些脚本是 package examples，不运行 Kira/Fermat，不做 reduction。

当前 examples：

```text
atomic_massless_line_check.wl
atomic_massive_line_check.wl
pure_massless_bubble_check.wl
mixed_bubble_check.wl
mixed_triangle_check.wl
mixed_sunrise_check.wl
pure_massive_bubble_reference_check.wl
two_loop_isp_toy_check.wl
parallel_massless_bundle_guard_check.wl
vertex_energy_signs_check.wl
tadpole_symmetry_check.wl
ds_total_derivative_check.wl
```

运行方式：

```powershell
wolframscript -file '000_code\test\012_hand_derived_cross_checks\mixed_bubble_check.wl'
```
