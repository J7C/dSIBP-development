# dSIBP 021 更新说明

## 基线

- 基于冻结代码版本与正式发布 `020` 建立。
- 021 继续继承带 `018` 后缀的 Private 模块名；这些名称记录实现谱系，不是运行时版本。
- 本轮为纯重构与检查基础设施版本：公开接口、time-only `J[sectorKey,timeShifts,stateBits]` 合同、IBP/EOM/contact producer、serializer 与数值合同均未改变。

## 重构内容（审计优化点 H1/H3/H5）

- **H1 清除被覆盖旧定义**：删除 `LoopCore013.wl` 中先加载、后被子模块覆盖的 6 组同名定义（`makeBaseIntegral`、`enumerateDiscreteStates`、`discreteVarsForLine`、`normalizeNumericRulesForTopology`、`ds` 三参、`rep2Integrand` 两参），并一并删除由此失去调用者的死 helper `integralToInertIntegrand` 与第二组重复定义（`linePackBPosition`、`discreteStateCountForLine`、`scalarProductSPInputToInternal`、`scalarProductInputToInternal`、`externalInvariantNamingReport`、`userNumericRules`、`makeIndependentVariableDerivativeGenerators`、`dsConventionMetadata`、`dsDEResolveVariables`）。删除前记录 020 加载后的完整 `DownValues` 基线，删除后 6 个目标函数在 021 只保留生效定义，运行时行为不变（详见 H1 专项 smoke）。
- **H3 check-smoke 共享 harness**：新增 `check-smoke/_harness.wls`，统一当前版本入口解析（`$ScriptCommandLine` 候选、`DSIBP_PACKAGE_FILE`、`DSIBP_CHECK_PACKAGE`、缺省版本目录）、package 加载与 `dsSmokeSummary` 汇总/失败键/退出码；14 个既有 smoke 的头部与尾部样板迁移到 harness，每个 smoke 保留自己的 case 输入、断言与额外摘要字段。新增 `check_module_ownership`（静态）与 `check_dead_definition_cleanup`（动态）两个检查。
- **H5 同左端覆盖静态回归**：`check_module_ownership.wls` 扫描 021 Kernel 源码，生成模块所有权表 `module_ownership_021.wl`，并报告同一精确左端跨文件重复定义；021 已清零未登记重复。允许公开短签名与明确声明的扩展 DownValue。

## 接口与路径变化

- `$dSIBPVersion` 由 `"020.0"` 变为 `"021.0"`；公开函数和数学合同不变。
- 当前模块版本在 `versions/021_dSIBP/Examples/` 内随包提供六个 examples；公共 loader 仍让用户通过标准 `Needs["dSIBP`"]` 加载，不要求用户设置字符编码。
- 正式单文件交付同步保留同一套 examples，并自动绑定唯一的同版本 `.wl/.pdf`；维护者候选检查继续要求成对设置 `DSIBP_PACKAGE_FILE` 与 `DSIBP_PDF_FILE`。
- Windows `wolframscript -file` 可能按系统代码页解析 builder 源码；单文件私有实现章节标题现由 Unicode 字符码构造，正式 `package_021.0.wl` 中该中文注释可按 UTF-8 直接读取，包接口与公式不变。

## 迁移要求

无。020 调用方无需改动。

## 验证状态

- H1 专项 smoke `check_dead_definition_cleanup` 对 021 `11/11`：6 个目标函数 DownValues 计数正确、`DSInit` 初始化、`ds` 与 `rep2Integrand` 可调用。
- H5 静态检查 `check_module_ownership` 对 021 通过：377 个顶层符号无未登记同左端重复。
- 021 Examples 的公开 API coverage `6/6`，39 个公开函数全部由声明文件与实际 held 调用共同覆盖；五个 runtime examples 对候选单文件全部退出 0。mixed bubble 的最小可行 `{-2,2}` 目标包络生成 5516 条方程，统一范围与逐指标范围完全一致。
- 中文标题修复候选保持 UTF-8 BOM/LF，与修复前正式单文件逐行比较仅章节标题一行不同；候选和覆盖后的正式路径均可由 `wolframscript -file` 直接加载并退出 0。
- 021 上重跑受影响的 020 smoke：`check_time_only_tree_formula_020` `14/14`；`check_time_only_public_representation_020` 仅版本断言 `version020` 不匹配（其余 24 项通过）；`check_public_api_example_coverage` 仅 `manifestVersion` 不匹配（其余 5 项通过）——后两项的失败键属于 020 版本号断言，非行为回归。
- 既有 check-smoke 在各自冻结版本（018/019/020）上重跑：`check_integral_order_authority` `8/8`、`check_isp_numerator_contract` 通过、`check_kira_energy_convention` 通过、`check_massless_endpoint_contact` 通过、`check_parameter_derivative_operators` 通过、`check_scaling_relation` `7/7`、`check_time_only_sector_key` `9/9`、`check_time_only_public_representation_020` `25/25`、`check_time_only_tree_formula_020` 通过、`check_public_api_example_coverage` `6/6`、`check_topology_loop_count` 通过、`check_sunrise_parity_generators` 通过、`check_user_mi_basis` 通过。`check_general_ibp_seeds` 的 `topMomentumSeedsPresent` 在冻结 018 上基线即失败（该类 seed 的 `ibpClass` 实际为 `qIBP` 而非断言中的 `mIBP`），与 021 无关。

## 已知限制

- 与 020 相同：不生成一般 IBP 方程组之外的 reduction，不运行 Kira，不复制 dSIBP 之外的外动量求导实现。
- `check_general_ibp_seeds` 的 `topMomentumSeedsPresent` 断言与 018 实现类别名不一致，属于冻结基线问题，本轮不修改冻结版本。
