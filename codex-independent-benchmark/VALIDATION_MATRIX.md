# 014 全面验证与 015 根号坐标增量覆盖矩阵

本矩阵依据最新版 `independent-benchmark.md` 建立。014 行使用冻结的 `package_014.pdf/wl`；015 根号坐标行使用 `package_015.pdf/wl`。第一阶段的 `derivation.md`/`expected.wl` 不加载 package，第二阶段 check 只单向读取冻结结果。

| 任务书要求 | 独立手推 | 新 package 对照 | 状态 |
|---|---|---|---|
| 三个 ISP family 的坐标闭合 | `isp-coverage/`：12/12 闭合残差为零 | `check/check_isp_against_package.wl` | 完成 |
| 非零 ISP numerator 自身导数 | `isp-coverage/`：26 个 generator 插入，17 个非零、9 个零门禁 | 同上，显式 `UseSampleOnly->False` | 366/366 相等；非零差值 0 |
| bare-H、`T_Htoh`、`AT`、`WT` | `h-routes/`：局部系统、Wronskian、4/16 维 tensor 残差全零 | `check/check_h_against_package.wl` | H-to-h/direct-h 178/178；bare-H 178/178；compiled 16/16 |
| 两/三顶点 tree、dlog、common-theta、naive IBP/DE | `tree/`：n=1 为 8/8、n=2 为 48/48，Eq. (3.53)--(3.55) 与 common-theta 残差为零 | `check/check_tree_against_package.wl` | 57/57 通过；含 general seed recurrence 10/10、终点约化 8/8、seed-derived DE 8/8，且 `++`/`+-` 的 naive 与公式 DE 同序同 normalization |
| general-`ds` convention | `general-ds/`：upper-triangular `Dij` 10/10、phase、chain/product rule | `check/check_general_ds_against_package.wl` | 独立 expected 16/16；另列 package 自检 3/3 |
| 十个 family 的固定 sign/energy 全覆盖 | 任务书规定的 sector 与 generator 集 | `check/check_full_family_coverage.wl` | 24/24 runs；3018 条方程 |
| 014 单文件公开接口与 Options | 手册附录 A | `check/check_package_contract.wl` | 49/49 通过 |
| init/metadata/message/seed/linear/export 门禁 | 手册第 9--11 节 | `check/check_package_engineering.wl` | 14/14 正向工程门禁通过 |
| importer completion/hash/maps/targets/RHS 负例 | 手册第 11 节；不运行 Kira | `check/check_package_engineering.wl` 的 synthetic fixtures | 5/5 定向负例均拒绝；合计 19/19 |
| pure massive bubble fresh Kira/DE/scaling | reference `001/002` 的 `dk0/dks` 路线；`P_ref=-P0`；degree conjugation | 空工作区 export、WSL Kira 2.3、`DSKiraImport -> DSDE -> DSScaleCheck`、`014_reference_style_bubble_de_aitest.wl` | 33581 equations、6555 independent、19 masters、1814 targets、0 unreduced；package 22/22；degree-lift `0/361 + 0/361`；最终精确 probe `0/361 + 0/361` |
| 015 `ssij`/实际无圈模长坐标 | `kinematic-coordinates/`：简单及混合平方原子 Jacobian、无圈 massive 径向导数、相位不重复计数、乘积法则、实际出现模长的增量秩筛选与从属 binding、完备/过完备门禁、legacy 单位 Jacobian | `check/check_kinematic_coordinates_against_package.wl`、`check/check_package_015_contract.wl`；正式 `015_kinematic_coordinates_check.wl` 与 `015_workflow_smoke_check.wl` | 独立坐标 32/32；015 合同 54/54；正式专项 54/54；workflow 44/44；单文件 10/10；初始化 22/22 |

## 本轮边界

- 保留独立手推和 frozen expected；旧 package check、结果及 014 报告证据已经删除。
- 上表前七组轻量 package-facing checks 本身不启动 Kira；另列 pure massive bubble 闭环已从空工作区显式运行 WSL Kira 2.3，完整命令、日志和差值见 `000-report/2026-07-22-1530-014-内部.md`。
- 2026-07-22 报告发现的手册版本状态和 `DSSeeds` 缺省文字已同步到 014 当前实现；历史的 `46/47` 发现仍保留在正式报告中，新增 tree naive API 后当前 contract 为 49/49。
- general-`ds` 的完整端到端积分指标导数必须由独立原语组合后比较；只用 package `ds[J]` 构造 expected 的旧做法禁止复用。
- 任务书与 014 package 已统一使用 `{"name","expr","range"}` ISP schema，不再设置字段名 adapter。
- `Options[DSSeeds]` 的 `DiscreteMode -> Automatic` 读取 topology preset；缺省 `quickCheck` 落到 `"sample"`，完整离散覆盖应显式传 `"all"` 或使用相应 preset。
- bubble reference 当前不是完整 dlog DE；本矩阵不对 bubble 统计 primitive、letter 或 pole。直接 dlog 双路线只用于 tree。
