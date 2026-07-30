# independent-benchmark 文件夹用途

本目录交付独立推导任务书、Phase 2 所需的正式 package/用户手册，以及任务书点名的轻量 reference 对照。它不是 expected、check、reduction 或运行结果目录。

## 两阶段边界

- 权威任务书是 `independent-benchmark.md`。Phase 1 由新的独立 subagent 在新工作区执行，只读取任务书与公开文献；不得读取 `package/`、`reference-results/`、`versions/`、本项目 `check-smoke/`、旧 expected、旧报告或旧运行结果。
- Phase 1 只推导任务书固定 family/branch/parity/sector/generator 下、连续指标未取点的 general IBP seed identities 与 general 参量微分算符。有限 `n_i in {0,1}` 是离散基底类，不是连续撒点。禁止 `DSGenerateIBP`、`DSLinear`、Kira/reduction、DE、scaling 和数值 probe。
- 两类 Phase 1 expected 与推导来源冻结并记录 hash 后，Phase 2 才动态解析 `package/` 中唯一的 `package_<三位版本>.wl/pdf`，并要求 `$dSIBPVersion` 与文件 token 相同。不得从 `versions/` 或历史单文件旁路加载。
- Phase 2 先比较 general seeds/operators；`single_massive_sunrise` 到此结束，只允许 `DSInit -> DSSeeds/DSAllSeeds` 和参数算符 metadata/公开 `ds` witness。随后只执行任务书点名的其它 package 路线。外部 reduction 仅有两套：pure massive bubble `--`/even/default root coordinates，以及 mix bubble+tree `+++`/no parity/exact custom coordinates。不得增加 branch/parity、expanded envelope、全 family 参数 ledger 或其它 fresh reduction。
- Tree package 交叉验证只在两顶点 `++` massive case 比较 naive/dlog；三顶点 `++-` 只验证 cross/contact guard。massless full-line 的公式型 tree 路线保持 `PendingRederivation`。
- 每套 full flow 只使用一个确定性精确数值点；必须先构造符号导数、最小 target closure 和符号 scaling relation。Package 只生成/序列化 Kira 输入，不自行运行 reduction。

## Convention 边界

- 公开积分统一为 `J[aList,linePacks,ispList]`，并按 `J_s=N_s I_s` 定义。stable kE 编号、`kEpower[...]` 与 `kEParameterExpressions` 分离保存；contact 使用 `c_raw N_source/N_target J_target`，`ds/DSDE` 含 `D[Log[N_s]]`，`rep2Integrand` 把同一 `N_s` 乘回。
- Root 坐标满足 `ssij=Sqrt[sp[k_i,k_j]]` 与 `partial_ssij=2 ssij partial_sp`；标量积坐标对称，但 `D_ij=k_i.partial_{k_j}` 有序，raw basis 固定 `{D_ij|i<=j}`。不使用 `PowerExpand`。
- Kira-only 能量映射只作用于初始化识别出的相位能量原子：`k->-I ik`，其中 `ik` 是单个实 backend 变量；普通导数 `D_k=I D_ik`，Euler 算符不变。纯空间坐标不替换。
- Bubble reference 只在 Phase 2 复制并核验既有解析结果，不重新生成 reference IBP 或运行 reference Kira。必须对齐 `P_pkg=-P_ref`、`P0=-I ip0`、原始 `MIdlogNote` basis 和第 15--18 项显式 `ks` 的 `D[T,ks]T^-1`。

## 目录与报告

- `package/` 只保留当前正式 `package_020.0.wl`、`package_020.0.pdf`、同版本更新说明与少量成品 examples；不得放 expected、验证脚本、报告或 reduction 输出。
- 成品 examples 中长期固定三个典型入口：`03_single_massive_sunrise/main.wl`、`04_pure_massive_bubble_closed_loop/main.wl` 和 `06_mix_bubble_tree/main.wl`。single-massive sunrise 只生成 general seeds 与 general 参数微分算符；只有 pure massive bubble 携带 dlog/reference/scaling 闭环，另外两个不复制 reference producer。
- `reference-results/` 只保存任务书点名、带来源哈希的轻量 Phase 2 对照；它不能用于 Phase 1 或 master 选择。
- 内部独立工作区使用根目录 `check/`，每轮开始前清空旧内容并从头建立；外部执行者在项目外新建工作区。两者都不得读取、复制、写入或引用维护侧 `check-smoke/`。
- 正式报告统一写入 `000-report/YYYY-MM-DD-HHmm-{currentVersion}-{内部/外部}.md`，附件放同名 `-附件/`。执行范围按任务书第 18 节总结，并用第 19 节覆盖索引确认功能、family、branch/parity 和排除边界。

已有报告、维护 smoke 和误执行工作区都不构成本轮独立证据。任何未执行项必须在报告中明确标为未完成，不能用正式 package 自检替代 source-isolated 结论。
