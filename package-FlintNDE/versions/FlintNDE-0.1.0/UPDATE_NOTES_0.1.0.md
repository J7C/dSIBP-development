# FlintNDE 0.1.0 更新说明

## 基线版本

- 基于 `0.1.0.dev0` 建立（首个正式发布版本号）。
- `0.1.0.dev0` 源码与测试保持不变，冻结保留于 `versions/FlintNDE-v0.1.0.dev0/`。

## 新增与修复内容

本轮是纯重构版本，不新增物理/数值功能；公开接口、数值 convention、保存点
schema 与 fail-closed 门禁全部保持不变，已有接入程序无需迁移。

- H2：`regular_point_de.py`/`epsilon_jet_de.py` 复用 `core.py` 公共数值层
  （`configure_working_precision`、范数、相对差、列向量、单位矩阵、中点重建）；
  旧公开名 `midpoint_matrix`/`_identity_matrix` 保留为别名。`vector_taylor_coefficients`
  与 `evaluate_vector_series` 因多列/空列表行为不同保持各自实现，不强行合并。
- M2：`_column`/`_matrix_from_columns`/`_canonical_exact_solve` 下沉到
  `exact_gaussian.py`（`exact_column`/`exact_matrix_from_columns`/`canonical_exact_solve`）；
  `boundary.py`/`local_solutions.py`/`fuchsian.py` 共用，原错误消息与异常类型经
  薄适配保留。
- H3：`transport.py` 普通段循环提取为 `_transport_ordinary_segment`，
  `transport_path` 与批量 Frobenius 输运共用。
- H4：`SingularityInventory.find_finite(identifier)` 统一 6 处按 identifier 查找；
  奇点起点初始化报告提取为 `_singular_initialization_report`。
- M4：单层路径名验证统一为 `output_layout.validate_single_path_name`，
  `savepoints.py` 复用；顺带修复 `_write_singular_start_request` 的缩进不一致。
- M5：`regularization.py` 内部去重（`_require_distinct_points` 3 处复用、
  `SeriesReconstructionResult.evaluate` 复用 `_evaluate_coefficients`）。
- H7：新增仓库级 `check_common.py`，两个 `check_01_nde_*` 脚本共享
  `load_json`/`load_module`/`sha256_file`/Acb 序列化等 helper。
- M1：新增 `tests/_helpers.py`，`test_save_points.py` 复用保存点文件读取样板。
- H11：新增 `tests/test_serializer_contracts.py`，锁定各 Acb serializer 的字段合同，
  防止后续漂移。
- 版本引用同步：examples/check/test 脚本与文档的 `PACKAGE_ROOT` 从
  `versions/FlintNDE-v0.1.0.dev0` 更新为 `versions/FlintNDE-0.1.0`。

## 公开接口或数值 convention 变化

无。`flintnde.__init__` 公开接口与 0.1.0.dev0 完全一致；保存点 JSON schema、
奇点清单 schema、series-reconstruction 摘要 schema 均未改变。

## 迁移要求

无。从 0.1.0.dev0 升级只需把导入路径/安装路径指向 `versions/FlintNDE-0.1.0`。

## 已执行验证

- `python -m unittest discover -s tests -v`：`95/95` 通过（88 项既有 + 7 项新合同测试），
  wall time 约 16.5 s（TEMP 指向 D 盘 package 内避免短路径差异）。
- 重构过程中每完成一组改动即重跑完整测试；H2/M2 的语义差异（非方阵列集、复数
  exact 解析）已通过测试确认未改变行为。

## 已知限制

- 两个 `check_01_nde_*` 脚本依赖仓库外数据源（`000_code_AmpBH`、`000_code_Npackage`），
  本机未检出时无法运行；本轮未执行这两个 check。
- 条件实施项（M3 InputForm 清洗下沉、M6 example 输出布局统一等）未纳入本版本。
