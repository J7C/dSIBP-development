# 维护侧小范围检查

本目录只保存维护 agent 可重复使用的最小功能检查，不是独立 benchmark 工作区，也不提供独立 expected。按完整任务书执行的独立验证使用 `independent-benchmark/`，每轮从空运行目录重新建立。

保留范围：

- `check_general_ibp_seeds/`：构造限定 family 的 general IBP seed templates；single-massive sunrise 子检查逐项核对 6 个 `q·q/q·kL` momentum generators、odd/odd sector 传播和 ISP 不参与 parity。不撒连续指标点，不调用 `DSGenerateIBP` 或 `DSLinear`。
- `check_isp_numerator_contract/`：检查 ISP 零点固定为 `0`、正幂 numerator、用户显式负 range/target/`J` 可保留，以及自动反推 seed 只能保持或抬高用户下界；不运行 Kira 或 reduction。
- `check_parameter_derivative_operators/`：用单条 fixed massive line 检查结构化 `kEpower`、参数重定义、normalized contact、`D[Log[N_s]]` 和 `rep2Integrand` 回乘。single-massive sunrise 的 `{ss11,kE}` general 算符由长期 example 直接覆盖，不保留 active-basis wrapper smoke。
- `check_scaling_relation/`：只读已有 massive-bubble 解析 probe，在唯一固定点检查 Euler/scaling relation；不包含 sunrise，不重新生成 reference，不运行 Kira。
- `check_public_api_example_coverage/`：比较 `DSPublicAPI[]`、coverage manifest 和成品 example 源码中的实际调用。
- `check_kira_energy_convention/`：只检查 Kira 内部 `P0 -> -I ip0`、实有理数值映射以及普通导数/Euler 算符的 Jacobian。
- `check_topology_loop_count/`：并列检查普通两顶点单边、自环 tadpole 和三平行边 sunrise 的圈数、cycle/bridge、自环 metadata 与 routing rank。
- `check_integral_order_authority/`：用两积分合成 linearData 检查 `integralList` 唯一顺序、显式 reindex 和 plan 不二次重排；不写 backend 文件。
- `check_user_mi_basis/`：复用长期 massive-bubble 的既有积分表，检查 21/19 维 `userMI` 秩、support 双向映射、backend token 和解析导数 closure；不生成 seeds、不运行或读取 reduction。
- `check_module_ownership/`：静态扫描指定版本 Kernel 源码，报告同一精确左端跨文件重复定义，并生成模块所有权表；只读源码，不加载 package。
- `check_dead_definition_cleanup/`：动态加载目标版本（`DSIBP_PACKAGE_FILE` 指向 022），确认曾被跨文件覆盖的 6 个函数只保留生效定义且可调用；不运行 Kira、reduction 或 DE。

所有 smoke 统一使用 `_harness.wls` 共享样板（版本入口解析、package 加载、`dsSmokeSummary` 汇总与退出码）；每个 smoke 保留自己的 case 输入、断言和额外摘要字段。harness 只被维护侧 check-smoke 读取，独立验证与正式 package 不依赖它。

所有保留 smoke 都必须显式加载当前 022 或由 `DSIBP_PACKAGE_FILE` 指向当前 022；依赖已删除
版本的历史 smoke 不保留。如需临时输出，只能写入对应功能目录下的 `results_test/`，任务结束
后清理；当前保留脚本不写运行产物。

明确不在本目录保留：016/017 回归、全 family 或全 sign/parity 枚举、大范围手推撒点、expanded envelope、full workflow、reference producer、Kira/reduction/post-reduction、coverage/release gate、旧 expected、失败副本和运行日志。
