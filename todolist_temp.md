# 013 pure time-IBP/tree 与 014 工程化闭环

# 018 未完成工作闭环与工程交付（2026-07-24）

## 2026-07-25 三个长期 example 与 tadpole 圈数

- [x] 核对并修正 topology loop count 对 self-loop tadpole、普通单边、平行边和多连通分量的处理，增加最小回归。
- [x] 保留 pure massive bubble 的 dlog/reference 完整闭环；新增或整理限定的 mix bubble+tree 与 single-massive sunrise 成品 examples。
- [x] sunrise 使用共同外腿能量 `kE` 与独立圈外模长 `kL` 的两标度配置，并用 symmetry 模块实现顶点交换、两条 massless 平行线及其 ISP 指数同步交换；不复制 massive bubble 专属 parity/R1/R2。
- [x] 在 plan/design 记录三个案例的选择理由；用户手册只记录使用方法，不写内部选型理由。
- [x] 更新 coverage manifest、项目规则、README 和进度，并完成受影响的轻量检查；不运行 reduction。
- [x] 修复零 contact 进入 normalization 与无参数重定义时 `None` 被拼入提示文本的问题；同步 tech note。
- [x] sunrise 的 `DSSeeds` 正常构造可达 sector general 模板，随后仅选一个 top-sector `qIBP` 模板、按其 shift bounds 展开一个 seed 点的最小关系并移除 `DSKiraPlan`；mix bubble+tree 用 bridge `n=1` 展示收缩，同时检查 `n=0` 不含 `$Failed`。
- [x] 明确 massive bubble 的 reference 对照已应用顶点/平行线交换、`R2 -> R1` 与固定 parity；sunrise 只复用公开 symmetry 数据流。

## 2026-07-25 check 清理与长期 example 边界

- [x] 清空根目录 `check/` 的两套过时独立 full-audit 工作树；该目录只留给新独立会话按完整任务书从头执行。
- [x] 删除 `check-smoke/` 中 016/017、过度扩张 018、全 family/大包络/撒点、reference producer/adapter、Kira/reduction/post 和全部运行产物。
- [x] 将维护侧检查收缩为五个明确功能子目录：general seeds、参量微分与 sector prefactor、单点 scaling、massless endpoint/contact、Kira energy convention。
- [x] 固定 `04_pure_massive_bubble_closed_loop/` 为长期完整 package example，保留可直接加载的 19-master basis 以及从初始化、外部 reduction 回读、DE 到 scaling relation 的全流程。
- [x] 完成路径/范围/Markdown/Git 静态检查：`check/` 为空，五个保留 WLS 不含重型流程调用，旧名称无残留，括号/fence 与 `git diff --check` 通过；本轮未运行 Wolfram、Kira 或 reduction。

## 2026-07-25 018 候选、正式验收与发布

- [x] 校正当前文档中的过时状态，不重复 expanded-envelope、reference 资产和已关闭 E018 缺陷。
- [x] 在 `000_code/test/results_test/` 构建 018 候选 package/manual；最终程序/PDF SHA-256 分别为 `E137F7...EA06`、`FCF95B...0EBA`，PDF 32 页并完成受影响页渲染检查。
- [x] 候选路径完成受影响回归、API/example/coverage、单固定点 DE/scaling/reference 和 PDF 目视检查。
- [x] 同字节晋升 `independent-benchmark/package/`，删除旧 016 交付并做正式路径复验。
- [x] 收缩独立任务书：Phase 1 只冻结点名范围内未撒点的 general IBP seeds/operators；Phase 2 只对 pure massive bubble `--`/even 与 mix bubble+tree `+++`/no parity 运行 full flow；删除 expanded-envelope、全-family ledger 和额外 tree DE，并新增功能覆盖索引。
- [ ] 后续从空工作区按收缩后的任务书完成 018 source-isolated 独立验收并归档正式报告；本轮不执行。
- [x] 清理本轮误执行的 untracked `codex-independent-benchmark/`；删除前确认 8,650 个文件均未跟踪且无本项目 Wolfram/Kira 进程。
- [ ] 清理其它已确认的可再生产物；随后检查远端分歧、提交并推送。

## 2026-07-25 报告门禁、massless 与独立交付

- [x] 审阅最新报告全部发现并建立“已修复/本轮修复/继续 fail-closed”矩阵。
- [x] 修复报告确认的正确性门禁和可闭合 massless lower-sector/fixed-line 问题，增加 fresh 018 smoke。
- [x] 更新独立 benchmark 任务书、README 和 reference bundle，增加可直接加载的 19-master massive-bubble 选择及映射。
- [x] 编写原始 massive-bubble reference code/result README，固定复用路线与禁止事项。
- [x] 构建 018 候选 package/用户手册，完成候选与正式路径同字节复验。
- [ ] 检查远端分歧、提交并推送；不提交 ignored 运行产物或已作废的独立 expected/results。

- [x] 将 017 开发检查点提交并推送到 GitHub；提交 `8032ce7`，不冒充正式交付。
- [x] 从 017 建立只写的 `000_code/018_dSIBP/`，更新版本 token、loader 与构建输出名。
- [x] 精确验证 massive tree 的 `DSTreeNaiveIBP -> DSTreeNaiveDE`，并与同 basis 的 `DSTreeDLogDE` 逐项比较（`12/12`，三个 `5 x 5` 矩阵逐项差值为零）。
- [x] 统一单积分/批量 pure-time seed provenance，并检查公开输出只含三参数 `J`（`15/15`）。
- [x] 全源码扫描并删除遗留数量/规模/任意最大步数限制；018 未发现资源数量门禁。
- [x] P0：优化 `DSGenerateIBP` sector canonical/坐标投影热路径；massless 保持 `13232` 方程、`2726` 积分、零泄漏，generate `108.0 s -> 47.28 s`。
- [x] 修复 raw-expression parity fallback 与完整 sector metadata 汇总；bubble+tree top/e3 代表检查 `12/12`。
- [x] 拆分超时 full-workflow smoke并逐阶段记录；massless 完整通过，bubble+tree 全量五分钟未完成且不计通过。
- [x] 重跑 sector、contact、parity、meta seed range、empty range、tree 和 load 回归；017 contact/parity 的 29 个现行断言通过，要求 `bS0` override 不改变 tree formula 的旧断言按 018 normalized-`J` 合同排除。
- [x] 更新 examples、coverage manifest、tech note 和独立 benchmark 任务书；用户手册随 018 候选构建收口。
- [x] 构建 018 候选 package/PDF，候选路径复验后同字节晋升正式交付。
- [x] 完成 pure massive bubble 代表 family 的 package fresh Kira/DE/scaling 闭环；reference 侧只复制并哈希核验已有解析结果，不重新生成或约化。
- [x] P0：完成 `DSGenerateIBP` 模板级 sector canonical 优化；`[-1,1]` 新旧路径 `18908/18908` 逐条相等、差异 0，`[-2,2]` 完整得到 `397592` 条关系与 `65252` 个积分，23 组非空且 linear/parity/参数闭合通过；未引入资源门禁。
- [x] P0：解析构造 master 一阶导数和最小 targets 后，把 Kira reduction 的全部参数（含 `nu_i`、维数、零点、normalization 与外部动力学量）代入确定性非特殊有理分数；实际 Kira 文本无符号 coefficient parameter 残留，并在同一点验证 DE/scaling。
- [x] P0：撤回把 sector prefactor 当成外部 master normalization 的误诊和全部 post-hoc basis adapter。
- [x] P0：每个 sector 的 `sectorPrefactorData` 保存传播子收缩自动产生的完整 `N_s`；`J_s=N_s I_s` 隐含该因子，外部不重复相乘。
- [x] P0：按 `independentExternalMomenta` 声明顺序冻结稳定 kE 编号；`N_s` 保存 `kEpower[be1,be2,...]`，当前 `kEParameterExpressions` 独立保存且可为复合表达式。`DSRedefineParameters` 只更新后者。
- [x] P0：所有 contact 关系统一使用 `c_raw N_source/N_target J_target`；已覆盖 massive Wronskian、fixed/non-loop 幂次和 simultaneous contact 乘积。
- [x] P0：`ds[J_s,x]` 加入 `D[Log[N_s],x]J_s`，`ds[c(x)J_s,x]` 同时保留显式系数导数；`DSDE` 复用该实现。
- [x] P0：`rep2Integrand` 把结构化 `N_s` 完整乘回具体被积函数；缺省与复合参数重定义专项 smoke `16/16`。
- [x] P0：局部裸积分展开已作开发 smoke；最终仍用完整 scaling relation 统一检查，不增加新的用户阻断条件。
- [x] P0：关系修复后废弃旧 Kira reduction，fresh 重跑 export/reduce/import/DE；新纯有理 reduction 为 19 masters、215 targets、0 unreduced，import 与两个 `19 x 19` DE 无残留。scaling/reference 仍失败，转入 E018-18。
- [x] P0：复审所谓“全数值 Kira”输入，确认 `dsii/ccc` 触发 2,142 个函数、149 probes 与 142.93 秒 FireFly 重构；在错误日志中重新归因为 exporter/validation 缺陷。
- [x] P0：验证 Gaussian-rational 方程存在全局一致的逐积分 `I` 相位规范；14,091 条方程、82,252 个约束、2,987 个 ID、1 个连通分量、冲突 0。
- [x] P0：在 exporter 中把该相位规范转换为纯有理系数 Kira 系统，manifest 保存可逆 phase gauge；importer 在 ID 映射前恢复物理 `J` reduction，合成 round-trip 及冲突/混合轴负例 `16/16`，无 `dsii` 泄漏。
- [x] P0：纯有理路线不追加 `ccc` 自由变量；Kira 2.3 零变量 FireFly 会报 `No variables?`，故改走官方 `run_triangular+run_back_substitution` 常系数路线。prepare 同时检查前端/后端变量、dummy 与实际 Kira 文本，fresh Kira 为 `14091` 方程、`2795` 独立关系、19 masters、215 targets、0 unreduced，`12.86 s`。
- [x] P0（E018-18）：从原始 `DEP0.m`、`DEks.m`、`MIdlogNote.m` 证明 reference 19-master basis 的实际 normalization，与结构化 `N_s` 的 package basis 做有来源的同基比较；禁止由差矩阵反解 adapter。
- [x] P0（E018-18）：按用户指定测试 `G/R1 == normalized J_s`；19 个 master 定义比例逐项均为 1，不加入额外 `C`、符号或 `ks` normalization。
- [x] P0（E018-18）：在同一非奇异精确点使 scaling、physical `P0`、backend `ip0`、physical `ks` 完整比较通过；三套 `19x19` 矩阵各 `361/361`、非零差值 0。
- [x] P0（E018-18）：确认原始物理 dlog basis 是 `MIdlogNote`；第 15--18 项各含一个显式 `ks`，stored `MIdlogKira/DEP0/DEks` 经 `ks->1` 丢失该显式求导。维护侧恢复为 `T' T^-1+T A_ks T^-1` 后 scaling matrix/source residual 全零，原先额外四个 `ks` 差值消失。
- [x] P0（E018-18）：在既有解析 reference 上直接代入 `P_ref=-P_pkg=29 I/13`，对 `P_pkg` 导数乘 `-1`，并恢复第 15--18 项显式 `ks`；19 个 master 定义比例均为 1，physical `P0` 与 `ks` 各 `361/361`。
- [x] P0（E018-18）：把原始 dlog basis、能量/导数方向及 check 输出合同写入独立 benchmark 任务书；独立执行者在自己的 `codex-independent-benchmark/check_.../` 中重写检查，禁止读取或复制维护侧 `check-smoke/`。
- [x] P0（E018-19）：从初始化的 phase-energy 结构数据生成 `physicalEnergy -> -I backendEnergy`，backend symbol 为物理原子名前加单个 `i`；禁止按字符串名猜测能量，禁止替换不进入顶点相位的纯空间坐标。
- [x] P0（E018-19）：在 Kira exporter 应用 energy map 并写入 manifest；importer 反向恢复，固定一般 coefficient、energy map、Gaussian integral phase gauge 的逆序恢复合同。
- [x] P0（E018-19）：把物理撒点 `k -> r` 转成 backend 的 `ik -> r`（`r` 必须为精确实有理数），同时保存物理 DE 截面 `k -> -I r`；普通导数按 `D_k=I D_ik` 对接，Euler/scaling 按 `k D_k=ik D_ik` 保持不变。
- [x] P0（E018-19）：多能量/复合/复用、非相位坐标、命名冲突、非原子、数值负例和 round-trip smoke `19/19`；package actual 为 19 masters、215 targets、0 unreduced，物理 scaling 通过。reference 五份既有解析结果复制哈希 5/5，通过 homogeneity、显式 `ks`、能量方向与 `D_P0=I D_ip0` 变换后，物理 `P0`、backend `ip0`、`ks` 各 `361/361`、差值 0。
- [x] P0（E018-18）：expanded envelope fresh reduction 保持 19 masters、215 targets、0 unreduced，post `20/20`；preferred master 不再被当作充分性证明。
- [x] P0（E018-18）：51 页 tech note 已用 pdfLaTeX 构建，第 35--36 页经 Poppler 目视检查无裁切、重叠、黑块或乱码，并以同一候选字节覆盖正式技术说明 PDF（SHA-256 `BEEE84BE65D054C95863C33E5DCB68CD1D200398E7DBF0C161202AA8CFC0145D`）。scoped `git diff --check` 已通过；三个 fresh-kernel `.wls` 已正常加载 018。
- [ ] 清理七个已盘点且 ignored/untracked 的可再生临时目录；清理前重新确认路径、Git 状态和活动进程。
- [ ] P1（不是最高优先级）：实现有序 `userMI[i]` 线性组合 basis，并持久化 `J <-> userMI <-> Kira ID <-> RT variable` 双向映射。
- [ ] P1：删除 Kira/RT serializer 的二次暗排序，严格消费用户已经排序的 `integralList`；手册说明缺省排序和显式重排方法。
- [ ] P2：重新推导含 massless tree line 的 quotient-basis iterative reduction 与 dlog DE。

阶段记录：早期 018 候选 SHA-256 `8ECCD0B66171362E1671F83B9B68BAF0BEF13B047400B1FAD425FBB362AEC830` 与前序正式候选 `CDA2302295F961274488CFC1109B9041476A18782E17AB683F56E86D27BAF7BE` 均已被本轮边界修复取代；最终候选及正式程序为 `E137F7259B429D2F181E1A8BA101C36A42CEFE2145975F1900A24FDFE8B3EA06`，正式手册为 `FCF95B34B7F0ADCE037E5CB3029F239A78DA8AA50793F21AEEDD8A488BBC0EBA`。Kira/DE/scaling/reference 与 expanded envelope 是前序候选的既有验收，本轮没有重跑；最终字节只执行受影响 example/topology/massless/API 检查。atomic massless formula tree 保持 P2 fail-closed。剩余发布项仅为 source-isolated 独立验收、临时产物清理和 Git 提交/推送。

# 017 统一三槽、sector parity 与 subsector 导数（2026-07-24）

- [x] 核对 016 的 cycle/fixed full/shrunk pack、zero-point 所有权、massless time-only fallback 和 lower-sector `ds` shape gate。
- [x] 冻结唯一公开三顶层槽 `J[aList,linePacks,ispList]` 方向；full line pack 固定三槽，shrunk pack 可退为单槽但保留 root line 位置；取消 017 的公开单槽 `J[vertexPacks]` 生产路线。
- [x] 实测省略列表首项会产生 `{Null,...}` 和 `Syntax::com`，`_` 是 `Blank[]` pattern；冻结短字符串 `"F"` schema：cycle/fixed full 为 `{b,n1,n2}` / `{"F",n1,n2}`，cycle/fixed shrink 允许单槽 `{bS}` / `{"F"}`。
- [x] massless 与 massive 使用同一三槽 line pack；massless 不再退化为 `{b,n}`/`{n}`，额外关系在统一 relation 层处理。
- [x] 决定 fixed/non-loop line 不保留 `b/bS`：其模长幂属于各 sector 的 normalized `J` prefactor，不参与 Kira token、master 排序或 parity。
- [x] 冻结 sector 身份语义：`linePacks` 永远保留 root `lineOrder` 的全部位置，full/shrunk pack pattern 是 shrink set 的隐式、可逆编码；`sectorKey` 只能由该 pattern 派生并作外部交叉核验。
- [x] 核对当前 `aList/a0`：shrink 端点按代表类合并，`a` 求 parent compact 槽之和后减全部整数 shift，`a0` 求原顶点零点之和后减全部 zero-point shift；确认旧单线 coincident `2a` 分支不进入 017。
- [x] 核对 016 fixed-line 收缩缺省 convention：吸收量只由 source/target zero point 的选择决定；缺省 `B_t-B_s=z`，故整数 shift `s` 留作跨-sector显式系数 `r^-s`。h/H/massless 的 compiled `(s,z)` 分别为 `(1,2nu)`、`(1,0)`、`(0,0)`。
- [x] 同步 plan/design/tech note/common-theta TODO/用户手册：列出 h/H 缺省 child 指标与 zero-point 映射，说明 `n1+n2=1` 与 `bS=b+1` 保持 subsector parity，并建议用户一般不要修改 shrink shift；override 必须同步 normalization 与 parity metadata。
- [x] 补齐 massless 缺省吸收与 parity：`(s,z)=(0,0)` 不新增幂次吸收；cycle contact 因 `n1+n2=1, bS=b` 翻转 child offset，fixed line 不参与 parity；同步技术笔记与用户手册并重编 PDF。
- [x] 复核并归档 11:24 平行报告；排除旧 package、旧 Max 门禁和强制二槽表示结论，确认新增真实问题为 3+ 顶点 contact-reachable sector seed 未生成。
- [x] 017 建立唯一 vertex-power merge helper，覆盖单线、多线 simultaneous、三顶点顺序收缩和已 coincident 端点负例。
- [x] 初始化每个 sector 的 `sectorPrefactorData`，以对齐的 `fixedLineIndices/parameterKeys/parameterList/powerList/powerParts` 保存 fixed-line normalization；不直接缓存 `parameter^power` 乘积。
- [x] fixed-line shrink 不增加独立吸收选项；逐 transition 保存 source/target zero point、override 来源和剩余 coefficient exponent `s+z-(B_t-B_s)`，所有 reduction/DE 系数统一由 `N_s/N_t` 生成。额外吸收只由用户的 master/basis 选择处理。
- [x] 让参数最终选取和 `DSRedefineParameters` 更新每个 fixed line 的当前 `parameterList`，同时保留稳定内部 key 与 provenance；验证缺省和自定义变量均可逐线调取。
- [x] 实现唯一 prefactor materializer，并让 `ds/DSDE/scaling/time-only` 使用 `D[Log[N_s]]` 和跨 sector `N_s/N_t`；禁止各模块重复手写 prefactor 展开。
- [ ] 展开 massless、H、direct h、H-to-h 的 top/contact integrand，冻结整数 shift、zero-point shift、source/target prefactor 与 normalized lower integral 的物理幂次表，并最终裁决 atomic massless 报告项是否重复计数。
- [x] 新建 `000_code/017_dSIBP/`，冻结 016；加入同一整数版本目录内以 `017.1`、`017.2` 标记兼容修订的项目规则和 build metadata。
- [x] 统一三槽 schema、sector metadata 和唯一 sector resolver；同形 sector 必须由 term `sectorKey` 消歧。
- [x] 让每个 contact-reachable sector 使用继承的 root loop space 与该 sector 的 compact metadata 完整生成 time/momentum IBP；删除 `shrinkSectorSeedGeneration` pending 路径，bubble+tree 不得靠只生成 top sector 继续下游。
- [x] 修复 `ds`/`DSDE`：逐 `J` 先解析 sector，再按 compact shape 求导，并从 sector metadata 调取 normalization derivative 和 source/target prefactor ratio。
- [x] 合并 massless built-in relations、tadpole/user symmetry 与 EOM；区分可终止 canonical rule 和一般线性 relation。
- [x] 实现 h/H root parity generator、contact GF(2) transport 和用户 integer zero-point rebase offset；非 h/H 或非整数重基只关闭 parity capability并红字诊断。
- [x] 在 `DSGenerateIBP` 撒点域用 GF(2) 行约化直接枚举合法 parity tuple；禁止全量生成后删除，禁止 bad-parity `J->0`。
- [x] 增加生成后轻量 parity signature certificate，覆盖 h EOM、H 三项 EOM、H 缺省 compiled `{bShift,zShift}`、top/contact 默认 parity 不变、奇数/偶数 zero-point override 和非法非整数 override。
- [x] 统一 pure time-only 的三槽积分、seed、relation、zero point、sector prefactor 和 derivative operator 转换。
- [x] 017 暂不修改 massless quotient 上的公式型 `repIterative`/dlogDE；massless 体内线返回 `PendingRederivation`，并登记 quotient basis、递推和 dlog 公式重新推导任务。
- [x] 在 `check-smoke/` 完成 017 定向轻量检查，最终计数为 `4/4`、`21/21`、`14/14`、`30/30`。
- [x] 扫描并修正用户手册、plan/design/tech note 中残留的 016 massless 单 `n`/二槽和 fixed 空 pack convention；examples 的旧 `init/` 必须由 017 候选重新生成。
- [x] 018 已为公开 `DSTreeNaiveIBP` data 增加可逆 tagged reduction 适配；massive-only `DSTreeNaiveDE` 无 shape/residual，并与同 basis dlog DE 逐项相等，`12/12`。
- [x] 018 已让公开单积分 `DSTreeSeeds` 与批量 `DSSeeds` 共用 direct pure-time 原子生成器；provenance 与统一三参数 `J` 为 `15/15`。
- [x] 018 已将撒点域按每个 template 的实际连续指标和反推包络生成，保留 exact-cover 与 parity-before-generation；`[-1,1]` 新旧关系 `18908/18908` 逐条相等。
- [x] 旧“用户手工逐 sector/generator routes”方案已由 `DSMetaSeedRange`、`seedGroups` 和共同最终关系包络反推合同取代；不再要求用户照抄 reference 的七类人工范围。
- [ ] 更新 tech note、用户手册、examples、独立 benchmark 任务书与 README，完成公开 API/example coverage 检查。
- [x] 017 只作为已推送检查点保留，候选晋升任务已由 018 取代；不得再构建或晋升 017。

# 016 独立续审数值化改造（2026-07-24）

- [ ] 为 family/tree/DE 对照建立双方共用的确定性非奇异有理规则和 exact numeric key。
- [x] 删除 Sections 16/17 的全部 notation 位宽/压力测试，只保留会影响数学结果的 coordinate/capability/graph/routing 最小正负例。
- [ ] 删除消息颜色/措辞、重复 API surface 和重复 example 等非正确性门禁，并在报告中列为用户范围排除。
- [ ] 对改造后的 checker 做语法、最小 smoke 和 fresh 全量运行，记录逐组相等/非零/首差计数。
- [ ] 按前置门禁决定是否运行外部 Kira，并更新正式独立报告与进度结论。

# 016 全 package 门禁审计与遗留代码清理（2026-07-24）

- [x] 全量分类数量/规模/迭代/状态门禁，冻结必须保留的数学与来源正确性门禁清单。
- [x] 删除 `MaxSeedRuleCount`、`MaxDiscreteRuleCount`、`MaxEquationCount`、`MaxShrinkSectorCount` 等 package 自设资源门禁的实现、公开接口与文档。
- [x] 让公开 `DSSeeds` 缺省和 `Automatic` 只走完整枚举，移除 preset 隐式 sample 与 `UseSampleOnly` 公开分支。
- [x] 为三条 tree 递推路径加入 endpoint 距离严格下降与 canonical 状态循环检测，删除任意最大步数合同。
- [x] 修复无动力学变量的重定义指南、欠完备 binding 展示与 Windows UTF-8 标准 `Needs`/直接 `Get`。
- [x] 清理失效消息、helper、资源门禁字段、兼容壳、占位英文与重复分支，并做未调用符号/残留文本扫描。
- [x] 验证用户指定连续范围、全部离散态及全部生成元均完整生成，不受旧 `200/64/80` 阈值影响。
- [x] 从只读 massive-bubble reference 结果提取轻量 19 维 DE/scaling 对照 bundle，补齐来源哈希、convention adapter、README 和任务书读取边界。
- [x] 更新正式手册、独立任务书、README、examples 与 coverage manifest，清除旧 sample/Max/最大步数说明。
- [x] 构建并验证候选 package/手册，晋升正式交付并清理候选与运行产物。

# 016 完整手册与独立 benchmark 交付同步（2026-07-23）

- [x] 逐项审计 016 的公开函数、usage、options、手册章节、汇总表和 examples 覆盖。
- [x] 补齐全部新功能的用户流程、错误边界和可复制示例，保持任务书只依赖公开 API。
- [x] 重编译并视觉检查候选手册，验证候选单文件和受影响成品 example。
- [x] 同字节更新独立 benchmark 的 package/manual，正式路径复验并清理候选产物。

# 016 模板化撒点与双语消息（2026-07-23）

- [x] 让 `DSSeeds` 返回扁平 `allSeeds`，模板中已完整枚举 `n_i=0,1` 并完成 EOM/canonical，连续指标保持 general；canonical 精确零保持为可审计状态记录。
- [x] 实现 `DSGenerateIBP`/`generateIBP` 的统一范围和逐指标 exact-cover 两种调用形式。
- [x] 增加 unknown/missing/duplicate/bad-range/symbolic-`n`/forbidden-`n` 双语红字门禁和结构化失败结果。
- [x] 让 `DSLinear` 接受新撒点结果，并保留同源 context、sector metadata、source hash 和 canonical readiness。
- [x] 重写 `check-smoke/check_016_kira_planning.wl`，先验证新撒点模块，再恢复 Kira plan 的最小 target 检查。
- [x] 扫描 016 全部面向用户的 info/progress/warning/error，统一为每句中文后接英文；公共初始化与参数提示使用实际英文翻译。
- [x] 更新手册、成品 example、coverage manifest；候选与正式路径分别复验后按同字节晋升。

# 016 五族数值 Kira、反向撒点与最小 targets（2026-07-23）

- [ ] 冻结五个 loop family 的 branch、逐线 parity channel、active-basis 选择边界和数值 scaling 合同。
- [x] 删除未验证的 `DSSeedPlan` 整数优化草稿；Kira plan 改为消费 `DSGenerateIBP` 的显式撒点结果与 derivative closure。
- [x] 实现 `DSKiraPlan`：reference-style 排序、解析导数闭包、pre-reduction 与 formal minimal-target 两阶段计划。
- [x] 保留缺省符号微分变量门禁，并仅在解析一阶导数及 closure 已冻结后允许 `postDerivative` 数值 Kira。
- [x] 更新用户手册、成品 example、coverage manifest 和独立任务书中的新模块调用与门禁；五族只读 reference 资产随真实闭环补齐。
- [x] 构建撒点/Kira planning 候选，完成新增 smoke 和受影响回归；同字节晋升并清理产物。
- [ ] 完成五族外部 Kira/scaling 闭环并归档独立的数值结果；本次未运行 reduction。

# 016 独立任务书 convention 与交付加载一致性（2026-07-23）

- [x] 审计第 2--17 节旧外动量字段、平方坐标、line pack、Head 与 package 加载入口。
- [x] 统一生产性任务到 `loopExternalMomenta/independentExternalMomenta`、`ssij/sEi` 和 cycle/fixed pack。
- [x] 把两个单 bridge atomic family 改为 `timeOnly` fixed-line oracle，其余八个 family 保持 graph-valid full loop。
- [x] 为交付 examples 建立动态唯一 package/manual loader，删除仓库版本目录和固定版本断言。
- [x] 复建单文件并核对 package/PDF 哈希，完成 fresh-kernel 加载、Wolfram 语法、残留与格式检查，清理 smoke 产物。

# 016 自定义变量 DE 与完备性任务书扩展（2026-07-23）

- [x] 固定双 `kL`/双 `kE` mixed-triangle 自定义参数 `k11,k22,k12,e1,e2`，明确和模长与缺省交叉根号不同。
- [x] 为 bubble+tree、双 `kL`/双 `kE` mixed-triangle、`vertex_energy_signs` 加入 exact/overcomplete/undercomplete 矩阵。
- [x] 规定 exact 逐变量算符、过完备红色 Warning/约束/关闭导数与 backend、欠完备红色 Error/missing direction/拒绝全部下游。
- [x] 要求全部 benchmark families 与成品 examples 检查 seed/linearData/逐变量导数及适用 DE 的最终参数闭合。
- [x] 复核任务书无冲突、Markdown 结构与 `git diff --check`。

# 016 独立任务书完整性与轻量 smoke 目录边界（2026-07-23）

- [x] 核对独立任务书已覆盖全部既定物理、工程、Kira/DE、参数闭合和源码审阅任务，仅增加章节覆盖索引。
- [x] 在根目录建立 `check-smoke/`，只供维护 agent 的轻量 smoke/check/test，运行产物进入并清理 `results_test/`。
- [x] 在 AGENTS、任务书和独立 README 中禁止独立审计读取、写入或引用 `check-smoke/`。
- [x] 复核目录无运行结果、任务书与交付仍存在，并通过 `git diff --check`。

# 016 显式动量角色、图论门禁与桥边指标重建

- [x] 作废未完成的自动角色分类方案，在研究进度登记通盘设计、矛盾点和验收标准。
- [x] 盘点未完成 016 文件与 015 冻结哈希，清理旧草稿并从 015 重建 016。
- [x] 实现多重图圈数、bridge/cycle line、incidence-cycle 与 loop-routing rank 审计及正负 smoke。
- [x] 实现 affine loop-shift 商空间及 loop 外动量 exact/over/under 完备性底层审计。
- [x] 分离传播子向量分解基与独立外动量模长坐标，完成模长 exact/over/under 底层审计。
- [x] 完成 `full/timeOnly` 全部下游 capability gate；context、seed、IBP、`ds`、`DSDE`、serializer 与 tree 均已审计。
- [x] 完成逐线 pack schema：cycle `{b,n...}`、bridge `{n...}`，并迁移 sector、shrink、serializer 与 tree projection。
- [x] 完成 bridge 固定/衍生动量幂显式系数及 shrink zero-point/contact 手推与实现。
- [x] 完成 momentum IBP 只消费 cycle `xi` 的全链门禁。
- [x] 完成逐调用点 pack-schema 审计，清除 topology-blind 槽位判定。
- [x] 完成 `DSRedefineParameters` 欠/过完备、短签名和超过十项补零 notation 专项。
- [x] 让 `timeOnly` 直接使用 pure-time/tree 指标表示并与现有 tree 两路线交叉。
- [x] 实现 notation 报告、`DSRedefineParameters` 和 seed/DE 参数规则贯通。
- [x] 建立 bubble+bridge+三点双外腿 example、错误输入 bench 与公开 API example 覆盖 manifest。
- [x] 更新 AGENTS、README、plan/design/tech note、用户手册和独立 benchmark。
- [x] 构建 016 模块/单文件/PDF，完成新增手推、受影响全回归、内部报告和临时产物清理。
- [x] 复现内部报告的 general-index `ds[...,ss11]` 私有 helper 泄漏并修复 fixed-line 显式系数吸收。
- [x] 给 exact 自定义坐标补逐变量 `ds` 与全部 general-index `DSSeeds/DSLinear` 计算载荷门禁，修复公开 seed/linearData 的 `kk` 残留。
- [x] 重建 016 单文件，复核 phase 2 `402/402`、bubble+tree `36/36` 及受影响回归。
- [ ] 由 source-isolated benchmark 完成 custom loop Kira/`DSDE` 与 custom tree naive/dlog 同 basis 闭环；不得用本轮正式自检替代独立 expected。

- [x] 在进度文件登记任务、阶段和验收标准。
- [x] 核对 loop/tree 论文、bubble reference code 与当前 012 边界。
- [x] 冻结 plan/design/tech/manual 的 013/014 分版设计。
- [x] 删除 007--009 主文件及对应失效 checks，更新版本 selector。
- [x] 从只读 012 建立单文件 `013_dS_ibp_general.wl`，不做工程重构。
- [x] 实现 tree 表示、time-IBP 映射、迭代规则、`repIterative` 与 dlog DE。
- [x] 更新 013 独立 benchmark，只新增两个固定 pure-time family。
- [x] 完成 013 手推、package check、seed/迭代交叉验证、独立报告与修正。
- [x] 冻结 013 交付物并归档独立证据，清理 013 临时工作区、runner、`_aitest` 与 `tmp/`。
- [x] 建立 014 标准 package loader、context 和模块目录。
- [x] 在 014 实现 `DSInit`、`DSInfo`、初始化 metadata 与相对路径 examples。
- [x] 在 014 实现统一消息开关、warning/error 样式及 notebook/headless 稀疏进度。
- [x] 在 014 迁移 loop seed/linear/Kira export 高层入口并补齐 examples；单文件与五个交付 examples 已完成候选冻结验收。
- [x] 在 014 实现 Kira 完整结果取回、DE 与 scaling check，并通过负面门禁与真实 fixed-parity 闭环。
- [x] 为 014 loop-to-tree 转换加入逐来源物理幂次审计，并以单条 h contact 和三条 massive h simultaneous contact 验证零点进入 tree `nu0` 与显式能量系数乘积。
- [x] 将 sector tag 推进到 `repIterative` 实际约化，并聚合全部 contact-reachable sector 的 master 顺序、offset 和对角 dlog blocks。
- [x] 为 Kira importer 增加一个正例及 completion/hash/maps/targets/RHS residual 五个定向负例，并补充同步重复 map 双射门禁。
- [x] 将 loop time-IBP 的 tagged `R^(1)` source 组装为全局 dlog 矩阵的非对角块，并验证 sector normalization、DAG 方向和严格 dlog 重构。
- [x] 增加三条平行 massive h 的定向 `R^(1)` source 检查：直接 triple contact、zero-point 显式系数乘积、merged `nu0` 及 mixed `G^{+-}` 防误用。
- [x] 完成 pure massive bubble 固定 sign/even parity 的真实外部 Kira 取回、`DSDE` 与 Eq. (51)/(64) scaling 闭环。
- [x] 实现 backend-neutral active basis：有序线性组合、稳定 token、dummy relations、优先排序和导数 target closure；manifest 保存完整可逆映射。
- [x] 让 `DSKiraImport` 分离 backend boundary masters 与 active masters，并验证 active token/ID、basis 关系和 target 完整性。
- [x] 让 `DSDE` 只对 active basis 求导，保留系数求导贡献，并要求 active-token 抽取不混入 auxiliary IDs。
- [x] pure massive bubble 固定参考代码的 21 个候选关系、前 19 维 active basis 和同序 targets；不得继续扩大统一有限 seed box。
- [x] 修正 Kira serializer 的系数原子映射，并通过 package/init 与含参量复系数的 importer/exporter 专项及真实 Kira 2.3 parser/FireFly/kira2math。
- [x] 增加按 `sectorKey` 与 generator label 覆盖连续 seed ranges 的配置，保持旧统一 `a/b/isp` 范围兼容。
- [x] 逐生成元记录连续变量、value lists、配置范围、规则数与 range source，并增加统一范围兼容和非法配置负例专项。
- [x] pure massive bubble 对齐 reference 的 top 四个、R1/R2 三类生成元精确范围；经 reference parity/symmetry canonical 后 196 个导数 targets 全部进入 linear system。
- [x] 修正 example export/import 门禁：本次 `DSKiraExport` 非 `ready` 时不得读取任何旧 Kira 结果。
- [x] 重新生成 pure massive bubble Kira workspace并运行真实 Kira 2.3：33581 equations、6555 independent、19 masters、1814 selected targets、0 unreduced。
- [x] 按真实 Kira 输出路径、master 格式和完成日志校准 `DSKiraImport`，不得用 synthetic fixture 代替。
- [x] 由真实 reduction 完成等能量 convention 下的 `DSDE[{s11,P0}]`、权重 `{2,1}` 的 `DSScaleCheck` 与 Eq. (51)/(64) residual 检查；最终为 19/19。
- [x] 全面重新手推和验证 014，完成独立报告、修正及正式回归；正式断言 296/296，未发现 package 缺陷。
- [x] 冻结 014 交付物，完成报告归档、交付哈希复核和临时产物清理。

# 014 新版独立 benchmark 补充手推

- [x] 审计旧 014 报告与新版任务书，确认旧 family check 把 ISP range 固定为 `{0}`，且 general `ds` 的 expected 调用了 package `ds`。
- [x] 在 `codex-independent-benchmark/` 独立补齐三个 ISP family 的闭合反解与全部非零 ISP generator 差分公式。
- [x] 补齐新版 pure-time/tree、三平行 massive h 和 H-to-h 全 seed 手推证据。
- [x] 冻结补充 expected 后开始阅读 014 手册；发现手册存在 012/014 状态文字前后冲突。
- [x] 删除并作废此前全部 package 自检、package 对照脚本、运行结果及旧 014 报告证据；只保留独立手推与 frozen expected。
- [x] 逐条按新版任务书和正式手册重写 package contract/engineering 自检与 ISP/H/tree/general-`ds` 单向对照脚本。
- [x] 完成十个 benchmark family 的 24 组固定 sign/energy 覆盖。
- [x] 从 clean results 状态重跑全部新验证层，并复核 frozen hashes 与 Mathematica 文件结构。
- [x] 更新验证矩阵、014 内部报告与最终进度结论。

# 015 根号外动量坐标与链式微分方程

- [x] 修正外腿参数模型：按 topology 中实际出现且不含圈动量的模长组合建原子，不自动生成 `externalLegMomenta` 的 Gram 交叉项。
- [x] 对实际出现的无圈模长平方做增量秩筛选；独立项建立 `sEe`，从属项保存相对于 loop Gram 与已选 `sEe` 的 binding，并覆盖相位/无圈 line/显式系数链式导数。
- [x] 增加初始化前变量提案与可重入选择接口；完备性不足时报告零空间/缺失方向并拒绝，过完备时 warning 后继续但标记不可逆。
- [x] 让 `DSKinematics`/`DSInit` 分别回报缺省与当前规则、零空间方向表达式和约束残差。
- [x] 禁止过完备坐标进入 `ds`，并按 `inverseAvailableQ` 门禁 `rep2innerform`；保持 symbolic IBP 可生成。
- [x] 增加非对角 mixed-coordinate Jacobian、过完备 `ds`/反向转换负例和 symbolic IBP 正例。

- [x] 冻结 014 并建立 015 模块、兼容入口和单文件构建边界。
- [x] 审计旧 `sij`、顶点能量和 external-leg 参数的内外 convention。
- [x] 实现 `ssij`/实际无圈模长 `sE1,sE2,...` 默认坐标及基于旧 `sij` 原子导数的链式适配。
- [x] 更新初始化 metadata、公开 API、examples、note、手册和项目规则。
- [x] 更新独立 benchmark，验证 Jacobian、系数导数、DE、scaling 和旧坐标兼容。
- [x] 构建 015 交付，运行回归、独立检验、PDF 验收并归档报告。

# 014 tree naive IBP/DE 与公式型 dlogDE 交叉验证

- [x] 审计现有 tree seed、迭代约化、dlogDE、sector tag 和 normalization 数据流。
- [x] 实现指定同序 master basis 的 naive tree IBP 约化与外变量 DE 构造接口。
- [x] 增加两顶点同号和 mixed guard 正式专项，严格比较 naive DE 与公式型 dlogDE。
- [x] 更新独立 benchmark，使两条路线在冻结 expected 后使用相同 masters 做内部互查。
- [x] 重建单文件 package 与手册，更新相关文档、交付和哈希。
- [x] 运行受影响回归与新独立检验，归档报告并清理临时产物。

# 014 fixed-rational Kira/DE 闭环

- [x] 在 benchmark 与进度文件登记仅保留全部可求导运动学变量的数值化约定。
- [x] 固定非奇异有理参数点，并接入 seed 前代入和 export manifest。
- [x] 从全新工作区重跑 Kira 2.3，禁止复用旧符号参数 reduction。
- [x] 回读并严格检查参数残留与 scaling relation；bubble 不做 dlog/pole/letter 检查。
- [x] 更新内部报告、验证矩阵、研究进度和最终哈希。
# 014 reference-style bubble DE 独立交叉验证

- [x] 提取并核对 `MIdlogKira`、`MIdlogPhysical` 与当前 active basis 的逐项 normalization。
- [x] 按 `002 bubble_de.m` 的 `dk0/dks`、前端归一化和 reduction 顺序生成 reference-style DE。
- [x] 在同一 19 维 basis 下与 package `DSDE[{s11,P0}]` 逐项比较，并验证 scaling relation；最终以 `ks=43/17`、`P0=29/13` 做分母门禁后的精确有理 probe。
- [x] 明确 bubble reference 当前不是完整 dlog DE；删除 primitive、letters、pole 检查，dlog 双路线只保留给 tree。
- [x] 按 `P_pkg=-P_ref` 修正 active 17 与辅助 20/21 的能量映射，重建 package，并从空目录完整重跑 export、WSL Kira、import、DE 与 scaling。
- [x] 更新 benchmark、验证矩阵、014 内部报告和最终 package 哈希；保持 frozen 手推 expected 不变。
# 016 发布收口（2026-07-22）

- [x] 修复 `timeOnly` 全 active line 的 fixed-coefficient 表示和无圈模长审计。
- [x] 修复 contact sector 重新降圈，改为继承 root loop-space 与 line-power schema。
- [x] 接通 context/linearData/serializer capability 和 input-hash 门禁。
- [x] 建立 29 项公开 API manifest 与 7 项 example coverage 检查。
- [x] 清理权威文档中“统一 externalMomenta 自动猜角色”和“欠完备仍继续”的废弃合同。
- [x] 在技术笔记补齐 016 图论、affine routing、cycle/fixed pack、显式幂系数、time/momentum IBP 与 root-sector 继承推导。
- [x] 构建并验证单文件 `package_016.wl`，删除 package 交付目录中的 015 旧版本。
- [x] 编译并目视检查用户手册和技术笔记 PDF，交付 `package_016.pdf`。
- [x] 修正当前权威文档中仍把 loop 外动量主字段写成 `externalMomenta` 的残留；保留 015 历史任务和兼容性输入语境。
- [x] 按更新后的独立任务书完成 source-isolated 手推与 package 单向比较：175/175，非零差值 0。
- [x] 重跑 016 专项、成品 examples和受影响的 014/015 历史回归。
- [x] 修复 raw `repIterative` source-aware 路线错误复用 loop 投影而丢失显式 `treeEnergy`；两/三顶点符号与有理 probe 均通过。
- [x] 让 atomic topology 参数统一接受 parsed topology 或完整 `DSInit` context，并验证 mixed-coordinate `ds` 的系数乘积法则。
- [x] 修复 `rep2innerform` 绕过 topology inverse capability 的最终独立检验缺陷，新增过完备 loop 声明负例。
- [x] 复核冻结哈希、独立报告和 `git diff --check`，完成发布记录。

# 016 独立 benchmark bubble+tree 扩展（2026-07-23）

- [x] 固定 topology 输入并取得当前 package 的真实角色、参数与提示输出。
- [x] 审计并补齐参数重定义、完备性与下游 capability 消息合同。
- [x] 扩展独立任务书：先手推冻结，再做 package、错误输入和源码审阅。
- [x] 在任务书中加入固定 bubble+tree 与全 family 的 general 参数闭合、EOM/symmetry 条件性和 zero-point 专项。
- [x] 在任务书中把自定义变量拆成逐变量微分算符、全部 seed/`linearData`、loop `DSDE` 和 tree naive/dlog DE 四层门禁，并检查计算 payload 不残留旧坐标。
- [ ] 由新的 source-isolated 执行者完成上述专项的冻结手推、package 单向比较、参数差集和源码审阅；旧 016 增量报告不替代本项。
- [x] 重建并覆盖独立交付 package/手册/examples，运行回归并记录结果。

# 016 general-index fixed bridge 导数缺陷修复（2026-07-23）

- [x] 原样重跑根目录 `check/phase2_package_check.wls`，确认 `ds[...,ss11]` 私有 helper 泄漏与报告一致。
- [x] 修复 fixed bridge 的线性因子吸收路径，使带显式系数的 `shiftLinePower` 结果正确分解为系数与单一 `J`。
- [x] 扩展 `016_bubble_tree_parameter_contract.wl`，覆盖 general 指标默认/自定义根变量及任意 `dSIBP`Private`` head/symbol 残留。
- [x] 重建 016 单文件与独立交付副本，重跑根目录 phase 2、016 正式专项和受影响回归，更新进度与报告结论。

# 016 候选测试版先行发布门禁（2026-07-23）

- [x] 构建器与 016 检查支持显式候选路径，缺省正式路径保持兼容。
- [x] 在 `000_code/test/results_test/` 构建候选程序和手册并记录哈希。
- [x] 仅加载候选运行全部 016 专项与 phase 2，全部通过前不覆盖正式交付。
- [x] 候选通过后覆盖正式交付，复核哈希并重跑正式路径关键门禁。
- [x] 清理候选产物，更新进度/报告并通过 Git whitespace 审计。

# 016 本轮测试、验证脚本与结果清理（2026-07-23）

- [x] 核对根目录临时 `check/`、对应内部报告、`codex-independent-benchmark/` 及 `results_test` 残留的 tracked/ignored/进程状态。
- [x] 删除本轮临时验证工作区、`codex-independent-benchmark/` 及 010--016 全部验证脚本；历史归档报告保留，根目录 `check/` 与 `000_code/check/` 只保留为空目录。
- [x] 删除过往版本 package 的 Kira/reduction/result/tmp 生成物，保留当前 016 成品 examples 及 Kira 信息生成/serializer/import 接口源码作参考。
- [x] 清除过时引用，复核正式 package/manual、独立审计任务书、归档报告、Kira 生成/serializer/import 接口与当前示例信息文件，并通过 Git whitespace 审计。
# 2026-07-23 Gate R5 新发现修复

- [x] 修复复合 `kE` 顶层编号并补 energyCaseC smoke。
- [x] 实现 atomic massless `timeOnly` 的公开 `DSSeeds` 状态枚举。
- [x] 归一化最终失败 context 的 capability。
- [x] 撤回任务书 9.9 中双外向量、八 momentum generators 和四 ISP 的错误 sunrise authority。
- [x] 更新手册、example coverage、构建候选并完成正式路径复验。
- [x] 清理候选与 smoke 运行产物，记录最终哈希。

# 2026-07-23 两圈 sunrise authority 纠正

- [x] 重算标准 sunrise 的标量积空间、三分母秩、ISP 缺失方向和生成元数量：5、3、2、6。
- [x] 撤回任务书/smoke 中双外向量、四 ISP、八 momentum generators 的错误 authority。
- [x] 用模块入口和正式单文件验证最小 ISP closure、五个方向和精确反解；源码无变化，未构建候选或覆盖正式交付。
- [x] 更新进度与验证记录；本轮无运行产物需要清理。

# 017 seed 包络反推与逐组提示（2026-07-24）

- [x] 按用户 seeds 外层结构保存逐组 shift metadata，并用交集公式从最终关系包络反推较窄 seed 点域。
- [x] 在撒点前逐组打印 `编号 i / Group i`、来源和 `{index,min,max}`，不把用户自定义分组称为 IBP 算符。
- [x] 对 `min>max` 明确解释目标包络、shift 跨度、空 IBP 撒点和不完整约化系统之间的因果关系，并关闭相应 complete capability。
- [x] 增加 custom grouping 空组专项并通过 `10/10`；同步 plan、design note、tech note 和用户手册。
- [ ] 完成 017 全量 core/examples 回归与候选晋升；当前 `check_017_full_workflow.wls` 的全量 `DSLinear` 路线仍需拆分或优化后完成。
# 2026-07-25 018 report gate 与 massless 收口

- [x] 实现 sealed complete / sealed subset / unsealed raw artifact 合同；formal reduction 只接受 `completeSystemQ=True`。
- [x] 让 `DSLinear` 复用 producer digest/摘要，formal Kira plan/export 复用同一 prepared active-basis payload。
- [x] export/import 加入实际内容和文件 SHA-256 identity；`DSInit` 可选写文件失败不关闭内存 context。
- [x] fresh 验收门禁 `17/17`、massless `11/11`；atomic contact `-2/sE1^beta1`，pure bubble top `3/3`、lower `6/6`，非法 shape 与 formula quotient 继续 fail closed。
- [ ] 更新独立 benchmark、massive-bubble active basis、reference README、018 package/manual/examples 后完成候选和正式路径复验。
# 2026-07-25 018 runtime gate 精简

- [x] 对照 `000-report/2026-07-24-2244-018-内部.md` 复核当前 018 默认路径中的全部剩余重复门禁。
- [x] 固化保留、删除、仅 full audit 三类清单并修改 package。
- [x] 更新 `AGENTS.md` 的门禁最小化与单固定点规则。
- [x] 运行针对性结构回归与一个固定点的现有矩阵比对，不扩大验证范围。
