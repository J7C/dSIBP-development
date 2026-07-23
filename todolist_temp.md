# 013 pure time-IBP/tree 与 014 工程化闭环

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
