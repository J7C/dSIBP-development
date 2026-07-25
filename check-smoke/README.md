# 维护侧小范围检查

本目录只保存维护 agent 可重复使用的最小功能检查，不是独立 benchmark 工作区，也不提供独立 expected。以后按完整任务书执行的独立验证使用根目录 `check/`，每轮从空目录重新建立。

保留范围：

- `check_general_ibp_seeds/`：只构造一个 pure massive bubble 的 general IBP seed templates；不撒点，不调用 `DSGenerateIBP` 或 `DSLinear`。
- `check_parameter_derivative_operators/`：用单条 fixed massive line 检查结构化 `kEpower`、参数重定义、normalized contact、`D[Log[N_s]]` 和 `rep2Integrand` 回乘。
- `check_scaling_relation/`：只读已有 massive-bubble 解析 probe，在唯一固定点检查 Euler/scaling relation；不重新生成 reference，不运行 Kira。
- `check_massless_endpoint_contact/`：只检查一个 `++` fixed-line contact 和一个 `+-` endpoint 相位例子。
- `check_kira_energy_convention/`：只检查 Kira 内部 `P0 -> -I ip0`、实有理数值映射以及普通导数/Euler 算符的 Jacobian。
- `check_topology_loop_count/`：并列检查普通两顶点单边、自环 tadpole 和三平行边 sunrise 的圈数、cycle/bridge、自环 metadata 与 routing rank。

所有脚本都直接加载 `000_code/018_dSIBP/`。如需临时输出，只能写入对应功能目录下的 `results_test/`，任务结束后清理；当前保留脚本不写运行产物。

明确不在本目录保留：016/017 回归、全 family 或全 sign/parity 枚举、大范围手推撒点、expanded envelope、full workflow、reference producer、Kira/reduction/post-reduction、coverage/release gate、旧 expected、失败副本和运行日志。
