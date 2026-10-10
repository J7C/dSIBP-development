# dSIBP 022 干净公开输入重构

## 范围

本版本从 021 的物理公式与数据产物合同出发，重写用户 topology 输入边界。不保留任何
旧 schema、别名、wrapper、fallback 或兼容测试。contact sector 元数据保留数学语义，
但改为内部 producer 直接构造，不再冒充用户 case 重进公开 parser。

## 目标数据流

```text
用户 vertices + lines + momentum declarations + kinematic rules
                         |
                         v
                  root topology parser
                         |
             IBP / EOM / derivative producers
                         |
                         v
             internal contact-sector constructor
                         |
                         v
          sector metadata / linearData / serializers
```

## 公开接口

- 顶点：`<|"id"->1,"vertexType"->"+","externalLegEnergy"->E1|>`。
- 标准传播子：`id/massType/endpoints/momentum`；massive 传播子再需 `nu`。
- 高级 massive 传播子：可用唯一 `functionSystem -> "h"|"H"|Association`。
- 圈外向量：`loopExternalMomenta`。
- 无圈模长基：`independentExternalMomenta`。
- 运动学坐标重定义：唯一 `kinematicRules`。
- 指数相位：`vertexType="+"` 给 `Exp[-I externalLegEnergy tau]`，`"-"` 给
  `Exp[+I externalLegEnergy tau]`。

## 必须删除

- 旧公开 `vertexData`、`vertexEnergies`、`lineData` 和传播子五元组入口。
- `bbType`、`eomCoefficients`、line-local `shrinkPrefactor`。
- 用户传播子的 `skType/packType/state/thetaConvention/thetaBoundarySignOffset`。
- 旧公开/内部 `externalMomenta/externalLegMomenta`；公开只保留
  `loopExternalMomenta/independentExternalMomenta`，内部统一使用
  `effectiveLoopExternalMomenta/effectiveIndependentExternalMomenta`。
- `externalInvariantRules/rawExternalInvariantRules/externalLegInvariantRules/`
  `rawExternalLegInvariantRules`；公开只保留统一 `kinematicRules`，内部只保留规范化后的
  loop/magnitude kinematic rules。
- 用户 `activeVertexIds/fixedAVertexValues/rootZeroPointRules/sectorVertexRepresentativeMap`。
- topology 中的 `seedPreset/seedRanges/generatorSeedRanges/numericRules/kiraOrdering`；它们改归具体
  seed、数值或 Kira 入口。

## 实施要点

1. `parseTopology` 只接受 `vertices/lines/loopMomenta` 三个 root 必需键；每个 vertex 必须含
   `id/vertexType/externalLegEnergy`，每条传播子必须含 `id/massType/endpoints/momentum`。
   massive 传播子另需 `nu`，可选 `functionSystem`；massless 传播子忽略额外键但绝不读取
   `nu/functionSystem`。Association 键顺序任意，额外键不进入内部 topology。
2. `vertexType` 在 parser 内唯一规范化成 vertex sign：`+ -> -1`、`- -> +1`，使外腿指数
   统一为 `Exp[I sign externalLegEnergy tau]`。传播子的 SK、pack、顶点态和 contact 系数只从
   其两端顶点及 contraction 状态派生。
3. root topology 只保存后续模块实际消费的规范化键。sector constructor 直接接收 root
   topology 与缩并传播子集合，生成新的 active vertices、代表映射、传播子 pack、零点和
   normalization；不得构造 Association 再回调公开 parser。
4. `seedPreset/seedRanges/generatorSeedRanges` 移入 seed/IBP 入口选项；`numericRules` 移入
   sampled/numeric linear-data 与检查入口；`kiraOrdering` 只由 Kira plan/export 入口读取。
   topology serializer 不再保存这些工作流配置。
5. 先建立最小 schema smoke，覆盖新输入成功、缺新必需键失败、额外键不改变结果、`+/-`
   相位系数、massive/massless 条件键；随后再迁移 examples 和深层回归。
6. （已完成）021 仅曾作为 022 验收前的只读预期基线；验收通过后已删除旧源码、旧正式
   单文件和被新报告取代的验证资产，不保留 loader 转发。

## 任务

- [x] D1. 定义严格公开 vertices/lines schema 和错误消息。
- [x] D2. 重写 root parser，不读取任何旧字段或用户内部状态。
- [x] D3. 将 `skType/packType/state`、active vertices、root zero points 和 representative map
  改为内部唯一 authority。
- [x] D4. 拆分 root parser 与 sector constructor，sector 不再调用公开 case parser。
- [ ] D5. 内部圈外向量基改名为 `effectiveLoopExternalMomenta`，清除旧 internal key。
- [ ] D6. 将 seed/numeric/Kira 配置移到对应工作流选项，不再混入 topology。
- [ ] D7. 同步公开 API、examples、smoke、builder、单文件交付和独立验证任务书。
- [ ] D8. 同步 README、VERSION_INDEX、UPDATE_NOTES、plan/design/tech note 和用户手册。
- [ ] D9. fresh 运行顶点相位、routing/ISP、contact sector、DE/Kira 受影响回归。
- [ ] D10. 执行旧名静态扫描、UTF-8、PDF、生成物与 `git diff --check` 门禁。
- [x] D11. 在首次加载时显示 FeynCalc 风格的简洁引用提醒：三篇指定论文使用经核对的
  可点击 arXiv 链接，并列出 dSIBP 程序包论文；测试实际输出并逐字复核 URL。
- [x] D12. 修复 `resolveKiraOrderingSpec` 的参数 pattern，确保 `kiraOrdering` 始终是
  Association；积分重排 smoke 同时检查显式顺序、方程 ID、ordering 类型和无
  `Join::incpt`。删除旧日志后 fresh 重跑 Example 01，stdout 只允许紧凑进度与 summary。
- [x] D13. 继续以 dSIBP 自身的论文 DE、normalized-master coefficient 和 contact seed oracle
  验收 022；不得把 `test_dsibp_derivative_dlog.wls` 的 `MSReduce` 残差当作 dSIBP contact
  producer 证据。待 MadStree recurrence 自检修复后再重跑跨包 adapter，确认 dSIBP 参数导数
  与正确 reduction 合成结果一致；若 adapter 恢复 `9/9`，只证明两包组合路线闭合，dSIBP
  contact 正确性仍只由自身论文 oracle 判定。
- [x] D14. 删除公开兼容别名 `metaSeedRange`、`generateIBP` 及其 usage、Options、wrapper、
  context/API/coverage/example/documentation 调用；唯一保留 `DSMetaSeedRange`、`DSGenerateIBP`。
  同时删除 `DSKiraImport` 对 `results/kira_list.m`、`results/masters` 的旧目录 fallback，自动
  发现只认 `results/Tuserweight/`，其它路径必须通过显式文件选项提供。
- [ ] D15. 在正式用户手册的加载章节补充与实际 `Needs` 一致的引用提醒，三篇论文使用
  用户给出的精确 arXiv URL 和可点击链接；程序包论文只写 `arXiv identifier pending`。
  重编正式 PDF 后检查链接目标和中文渲染，不改动已核验的运行时条目顺序。
- [x] D16. 先从函数族而非论文 expected 判定 normalized master convention，再修复动态 physical
  sector prefactor 导数。缺省 naive 指标表示要求 IBP/DE coefficient 仅为参数与动力学量的
  多项式分式，因此 Wronskian shrink 产生的 `kinematic^(c nu)` 连续幂必须完整吸收到 child
  master；其导数只以 `c nu/kinematic` 的有理对数导数出现。共享 producer 必须对每个 master
  建立唯一 complete normalization，组合 dlog coefficient 与 materialized `sectorPrefactorData`，
  naive/direct 两路共同消费；不得只在 `ks` 的 child `(5,5)` 写 family-specific 修补，也不得让
  contact ratio 重复吸收同一因子。增加不读取论文的 Wronskian、连续幂吸收、有理闭合、
  `D Log[N_s]`、乘积法则、Euler scaling 和 static normalization exact 回归；通过后重建正式
  022，再以论文为外部交叉检查 fresh 重跑第 15.6 节至三变量两路线全部 `25/25`。

阶段证据（2026-08-19）：`check_022_topology_schema/check.wls` fresh 通过 16/16；
Example 05 删除 `init/` 后 fresh 退出 0，`sE1` 的 naive/dlog DE 精确一致。tree family
内部只保存明确的顶点外腿能量与传播子动量模长命名，不再接受 `treeEnergy` 覆盖。
Example 01 的首次 022 运行暴露 ordering pattern 缺陷：虽然退出 0，但错误消息展开完整
`linearData`，产生 104,959,796 字节 stdout。修复前结果不计入验收。
修复后 ordering smoke 通过 `10/10`；Example 01 fresh 退出 0，stdout 8,924 字节、stderr
0 字节，无 `Join::incpt`，紧凑 summary 确认 5516 条方程与显式重排后的 plan 成功。

受影响 smoke 已全部改为显式加载 022 新 schema：参数导数 `11/11`、圈数 `7/7`、Kira
能量 `16/16`、API coverage `6/6`、ISP `13/13`、UserMI `17/17`；sunrise parity 的完整
generators/sector 断言通过。UserMI 的 synthetic order 由 reference basis 加同源解析导数
闭包组成，不读取旧 Kira manifest。module ownership 022 为 23 文件、361 顶层符号、无重复。

### D11 实施要点

- Notebook 使用 `Hyperlink`；headless 输出相同 arXiv 号与完整 URL。
- 引用块只在全部模块加载成功后显示，每个 kernel 一次。
- 条目顺序固定为 2401.00129、2411.03088、2604.14549、dSIBP 程序包论文。
- 程序包论文暂写 `arXiv identifier pending`，不构造未提供的链接或书目信息。
- 静态白名单扫描和实际 `Needs["dSIBP`"]` 输出都必须逐字命中三个指定 URL，且不得出现
其它 arXiv 链接。

完成记录（2026-08-19）：连续两次标准 `Needs["dSIBP`"]` 只显示一次提醒；关键公开定义
完整性检查为 True，三条 URL 与白名单逐字相等且各只出现一次，终端条目顺序为三篇指定
论文后接 `dSIBP package paper, arXiv identifier pending`。Notebook 构造保留真实
`Hyperlink[label,url]`，不生成其它论文链接。

### D13 实施要点

- `vertexExternalPhaseDerivativeCoefficient` 只负责指数 `Exp[+/- I E tau]`，约定为
  `vertexType "+" -> -I`、`vertexType "-" -> +I`；当前 15x15 失败没有执行 dSIBP tree contact
  producer，因此不以该残差修改 `thetaBoundaryAtomicTerms`、Wronskian 或 sector prefactor。
- dSIBP 独立检查必须直接调用 022 的 `DSTreeSeeds/DSDLogDE` 或论文任务规定的 IBP-DE 路线，
  保存 package 自己的 coefficient 与论文 oracle 差值；不能通过 MadStree recurrence 间接定责。
- 跨包脚本应先增加 MadStree recurrence-vs-dlog 自检。只有该自检通过后，剩余 adapter 残差
  才能继续追到 dSIBP 的参数导数或表示转换；本轮已撤销未经独立 oracle 支持的 atomic 改动，
  dSIBP 源码在自身 oracle 出现非零差前保持不变。

阶段复核（2026-08-19）：MadStree 无 dSIBP 的 `++/--` recurrence-vs-dlog exact identity 已先
通过，随后跨包 15x15 adapter 恢复 `9/9`，五个变量的非零差数均为 `0`；撤销 speculative
atomic 改动后的 dSIBP 022 topology/phase smoke 保持 `16/16`。这些结果关闭组合路线残差，
但不替代 D13 所要求的 dSIBP 自身论文 oracle，因此 D13 仍保持未完成。

D13 首轮独立结果（2026-08-19）：来源隔离与 master/normalization 静态检查成立，但正式门禁
失败。Eq. (4.2) child normalization 差为 `0`；naive/direct 对 `k12,k34` 均为 `25/25`，
对 `ks` 均为 `24/25`，唯一差 `(5,5)=2 nu1/ks`，两路内部三变量全 `25/25`。这证明
两路共享的当前 normalization 未包含 `sectorPrefactorData` 中 `sE1^(-2 nu1)` 的动态对数导数；
是否构成错误还需由 D16 的函数族 Wronskian 与 naive 有理闭合判据独立确认。现行公开合同已写明
`J_s=N_s I_s`，且不允许 top/subsector coefficient 残留 `sE1^(c nu1)`，因此初步判定应把该连续
幂吸收到 child master，并在 DE 中保留有理项 `-2 nu1/sE1`。D16 修复并 fresh 重跑前，D13
维持未完成且失败报告不得改写成通过。

### D16 实施要点

- 直接从 `functionSystem` 编译后的 Wronskian/shrink data、source/target zero point 和
  `sectorPrefactorData` 重建 massive child normalization；论文公式仅在独立推导完成后比较。
- 默认 naive basis 的闭合判据为：系数可含 `nu`，但只能是参数与动力学量的有理函数；任何
  `Power[动力学量, 含 nu 的指数]` 留在 IBP、reduction 或 DE coefficient 中都判失败。
- complete normalization 必须同时供 naive derivative、direct block diagonal、tagged master 和
  contact ratio 使用。每个 consumer 记录自己消费的是 normalization、log derivative 还是 ratio，
  通过 exact identity 防止遗漏和双计数。
- 用户显式给主积分乘根号或其它 algebraic prefactor 时允许 DE 出现代数系数，但这属于显式 basis
  变换，不改变缺省 naive 指标 basis 的有理闭合合同。

D16 源码与候选阶段证据（2026-08-19）：已建立唯一 `masterNormalizationRecords`，并物理删除
tree dlog 结果中的旧 `sectorNormalizations/normalizationAudits` 字段。direct 对角块读取
`completeNormalization`，naive 导数读取同一记录的 selector 乘积法则和 physical prefactor
对数导数，off-diagonal 只读取 selector ratio。模块路径及候选单文件的专项均为 `13/13`；候选
参数导数/Euler scaling 为 `11/11`，死定义为 `17/17`。child 的 selector、physical prefactor、
complete normalization 和对数导数依次为 `-1/sE1`、
`(4 I/Pi) Exp[Pi Im[nu1]] sE1^(-2 nu1)`、两者乘积和 `-(1+2 nu1)/sE1`；naive IBP/DE
中连续 `nu1` 幂残留为空。候选 SHA-256 为
`15393749586EB2D515801003765DBD2C19B27CC2E6E11157C049AD25961C1CCE`。D16 仍待独立
第 15.6 节重跑、正式包同字节晋升及正式路径复验后关闭。

D16 候选独立结果（2026-08-19）：来源隔离的第 15.6 节为 `allPassed=True`。corrected
paper oracle 直接由冻结 arXiv TeX 勘误并单独自检；原误抄 oracle 与 hash 保留。naive/direct
各自对论文三个 `5x5` 矩阵均 `25/25`，两路互比均 `25/25`；child `ks` 对角项为
`(-1-2 nu1)/ks`；naive IBP、naive DE、direct DE 的连续 `nu1` 动力学幂残留均为空。候选
已满足晋升门禁。

D13/D16 正式完成记录（2026-08-19）：候选程序以 SHA-256
`15393749586EB2D515801003765DBD2C19B27CC2E6E11157C049AD25961C1CCE` 同字节晋升为唯一正式
`package_022.0.wl`。独立 formal runner 只把冻结候选 runner 的加载路径和输出文件改为正式路径，
未读取候选 summary；运行退出码 `0`、`status=passed`、`allPassed=True`。naive/reference、
direct/reference、naive/direct 对 `k12/k34/ks` 的九组矩阵比较均为 `25/25`；IBP `9/9`、
naive DE source `15/15`、direct residual `25/25` 均为零，三类连续 `nu1` 动力学幂残留均为空。
最新成功报告为 `000-report/2026-08-19-1719-022-内部.md`，取代 15:10 的失败报告。

发布收口：正式单文件再次通过 normalization `13/13`、参数导数/Euler `11/11`、死定义
`17/17`；正式用户手册与候选哈希同为
`08A9B79804268C06D4077E10367A08503A89BF7B4CCC8F9C08F3DFBD11018E09`，正式技术笔记与候选
同为 `FB54ADF26A0EF279577FF47933B782A888611A5733D4DA0DABE19F52F4F165FF`。121 个最终保留 dSIBP 文本
文件严格 UTF-8 解码无失败，用户手册三条指定 arXiv hyperlink 目标正确。报告回收后删除
`check/`、`test/results_test/`、021 源码和 021 报告，只保留 022 当前版本。

D13 独立执行安排（2026-08-19）：

| Agent | 当前任务 | 当前进度 | 下一步 |
| --- | --- | --- | --- |
| root-Codex | 冻结 022 候选、工作区和报告回收边界 | 已完成同字节晋升、正式路径复验与成功报告回收 | 清理 `check/`、候选和渲染临时产物后执行发布前定向门禁 |
| Artificial_Idiot-Codex-dsibp_paper_oracle | 只执行任务书第 15.6 节 | 已完成（门禁失败） | Eq. (4.2) 静态 normalization 差为 0；naive/direct 对 `k12,k34` 均 25/25，对 `ks` 均 24/25，唯一差 `(5,5)=2 nu1/ks`，见 `000-report/2026-08-19-1510-022-内部.md` |
| Codex-dsibp_022_normalization_independent | 从空白工作区重跑第 15.6 节 | 已完成；候选与正式路径均 `allPassed=True`，正式 runner/summary 哈希已冻结 | 无 |

### D14 实施要点

- `Kernel/dSIBP.wl` 不再导出或声明两个旧符号；`GenerateIBP.wl` 删除 Options 复制和转发定义，
  `Context.wl`、coverage manifest 与 module ownership 只列唯一 `DS*` 名称。
- Examples 01/04、全部当前 smoke、长期 plan/design/tech note、用户手册和独立任务书统一改用
  `DSMetaSeedRange`、`DSGenerateIBP`；不保留“同义入口”“兼容别名”说明。
- `KiraImport.wl` 的 Automatic candidate list 各只含一个当前 family 路径；usage 和错误提示同步
  写明该唯一路径。显式 `KiraReductionFile`、`KiraMasterFile` 的能力与输入格式不变。
- 增加 fresh 回归：唯一 seed API 的 Options/实际生成结果通过；只存在旧 Kira 根路径时缺省
  import 明确失败；当前 `results/Tuserweight/` 路径可被自动发现。验收后全现行树静态扫描中，
  旧符号定义/调用和旧路径候选必须为零。
- 正式 examples 的 loader 要求 `independent-benchmark/package/` 只有一套同版本程序/PDF。
  因此 022 候选与正式文件同 hash、正式路径最小 smoke 通过后，先删除 `package_021.0.wl/pdf`
  及其更新说明，再 fresh 运行 022 正式 examples；`versions/021_dSIBP/` 已在回归完成后物理删除。
  不得放宽 loader 唯一版本门禁来绕过该顺序。

D14 完成记录（2026-08-19）：唯一 seed API/example coverage `7/7`、旧定义静态清理 `17/17`、
Kira 当前路径合同 `7/7`；正式 `package/` 已删除 021 三件套并只保留 022 程序/PDF/更新说明，
六个正式 examples 均从该唯一路径 fresh 运行。旧根 Kira 路径负例明确失败，当前
`results/Tuserweight/` 自动发现通过；未增加 alias、wrapper 或 fallback。

## 验收

- 新 bubble/sunrise/mixed/tree examples 仅用新 schema 并通过。
- `+/-` 顶点的外腿能量导数系数分别严格为 `-I/+I`。
- 圈动量 routing rank、ISP 闭合、标量积回代和 DE 闭合不退化。
- contact sector 保留 root normalization 与唯一顶点代表映射，用户无法覆盖。
- 当前源码、examples、tests 和现行文档不含被删入口的读取或调用。

## D17：最新版冗余审计修复

- [x] 四个退休运动学字段不再被 parser 读取；runtime 与现行 smoke 不保留旧名字 denylist 或专门反例。
- [x] 删除缺 `kEPower` 时的旧 metadata 重建分支，增加结构缺字段负例。
- [x] 重建候选单文件，完成候选与正式路径同项复验后同字节晋升。

D17 完成记录（2026-08-20）：合法 022 topology 和额外无关键保持原合同；raw-case parser
不读取退休字段，也不再对已删除 schema 的名字附加运行时语义。当前 producer/materializer exact identity 保持，删除
`kEPower` 后返回结构化 `MissingStructuralKEPower`。候选和正式单文件均通过 topology
`16/16`、normalization `14/14`、参数导数 `11/11`、死定义 `17/17`；两者 SHA-256 均为
`FF8B6F87274C88998D9E38AB31ED27B7FAA2ACC6AAD3B9BCCCF4B5D426C06FF3`。

## D18：023 massive contact 与 contour normalization 修复

- [x] 从当前完整 022 工作树建立 `023_dSIBP` 模块化开发树并统一运行时版本、builder 与 example
  manifest；正式单文件/PDF、根 loader/索引和独立任务书目标仍在发布步骤统一晋升。验收前不删除
  022，验收后不保留兼容入口。
- [x] 以 `G++/G--` 原始 theta 定义与 arXiv:2411.03088 top-to-child 数值列为交叉 authority，
  把物理 massive raw contact 固定为
  `contourSign endpointOrientation (n2-n1) W_T`。编译后的 `shrinkTerms` coefficient 是
  `-W_T`，所以消费该 coefficient 的离散 prefactor 必须带一个负号；物理删除
  `thetaBoundarySignOffset` 及其旧注释/调用。
- [x] 让 child sector 的 complete `N_s` 吸收同一个 `contourSign W`，并检查 raw、normalized、
  `DSSeeds`、pure-time recurrence 与 direct dlog 共用同一 convention；`++/--` 不得再靠错误相消。

专项完成记录（2026-08-27）：模块化 `023.0` 对 `++/--`、两个顶点、`10/01`、general/pure-time、
raw/child/normalized 三层恒等式通过 `6/6`；tree normalization、naive/direct dlog 闭合通过
`14/14`。全部 17 个维护侧 smoke 从 `023_dSIBP` 新路径运行，失败数为 0。
- [x] 更正独立 Phase 1 的 massive coincidence canonical 和分阶段公共根号替换；已确认
  lower-sector loop reversal 同时变换 ISP 与 generators，当前未声明 symmetry 时不得加入无条件
  canonical。从空目录重生的 local/descriptor/validator 为 `10/10`、`168/168`、`31/31`，
  time/momentum/operator 为 `976/1363/64`；freeze 与立即 verification 为 19/19 文件、4/4 authority，
  accepted digest 是 `C4B0FD204E3B2951E46471B356A9F7B201BCA241FC63832E90A0060EAA8409A9`。
- [x] fresh 重跑 Phase 2 general/tree/guard：从空结果目录得到 general `15/15`、tree/guard
  `11/11`，Kira 2.3/Fermat 探测可用，preflight 按职责返回 `pending_external`。
- [x] 完成 arXiv:2411.03088 两顶点 targeted IBP-DE。论文与 package 的顶点 `n=1` 定义相同，
  basis map 为单位矩阵；显式应用 `E12/E34=-k12/-k34` 及导数 Jacobian 后，三张 `5x5` 矩阵
  均 `25/25`，非零差均为 0。
- [x] 外部 Kira full flow 的范围已更正为 pure massive bubble 与 mix bubble+tree 两套；原先把
  single-massive sunrise 登记为第三套 reduction 的计划已取消。pure massive bubble 已 fresh 完成：
  5,992 条 backend 方程、2,966 个积分、215 个 targets、19 个 masters、unreduced 0；两张
  `19x19` DE、master 顺序、target/RHS closure 与 scaling 全部通过且残留对象为空。mixed 的
  最终 81-master 结果见后续 D18.27--D18.28；sunrise 只保留 general seeds/operators。
- [x] 修复 mixed lower-sector 导数的 compact `aList` 槽映射：以 sector metadata 的
  `vertexIdToCompactASlot` 为唯一职责源，拒绝不存在或超出当前 `aList` 长度的槽；active-basis
  导数构造若产生任何 Mathematica message 必须返回 `basisDerivativeFailed`，不得继续导出。
- [x] 增加收缩传播子 2 后 `{v1,v2}` 合并、`E3` 仍映射到 compact slot 2 的专项；专项 `10/10`，
  30 个 active masters 对六变量的 180 条导数为 message `0`、失败 `0`。根因修复只允许公开 `ds`
  从 root topology 选择一次 sector，旧重复 sector helper 已物理删除；候选 SHA-256 为
  `DF2AA818A385230FF84FD0722D9E4B1FD12EE4171AE1CAB648970647F4586841`。
- [ ] 从空 mixed formal 工作区以 expanded envelope 重跑所得 Kira reduction 含 81,768 条 backend
  方程、50,578 个积分、238 个导数 targets、268 个 formal targets，Kira 2.3 用时 202.3 s、
  `unreduced=0`，但全局 masters 仍为 245。必须实际运行 import、六变量 `30x30` DE 与
  `LoopTopology` scaling；若 extra masters 进入 RHS，则继续扩 target closure seed，不能把
  `unreduced=0` 或只导出 30 个 active basis 误记为闭合。
- [x] D18.1. 逐线性项分离显式 coefficient 与裸 `J`，只对裸积分执行 sector-aware
  EOM/coincident/顶点 canonical 和 symmetry，随后乘回 coefficient；不得扩宽裸积分 helper
  的 pattern，也不得保留旧分支。
- [x] D18.2. Kira active-basis producer 在写 manifest 前拒绝仍含 `shiftVertexA` 等内部执行 helper
  的导数结果，并返回说明具体残留对象的结构化失败信息。
- [x] D18.3. fresh 检查 mixed 30x6 导数：180 条无 Wolfram message、无 `$Failed`、helper residue
  为 0；`Put/Get` 前后逐条 `SameQ`，active-basis digest round-trip 一致。
- [ ] D18.4. 重建 `package_023.0.wl`，清空 mixed formal 的旧 `results/`、`results_temp/` 后重跑
  prepare、WSL Kira、import、六张 30x30 DE 与 scaling；若 RHS 仍出现 extra masters，继续扩
  closure seed，不能用 `unreduced=0` 代替指定 basis 闭合。
- [ ] D18.5. 对 fresh mixed `notClosed` 用 manifest integral ID 做逐项诊断；同时记录 raw derivative
  中积分、reduction 左端和 `repKira2J` 对象的 `SameQ`、完整 symbol context、目标 ID 与规则覆盖。
  首版裸 `_J` 诊断存在 context 歧义，不据其 153 项统计扩大 seed或修改 frozen basis。
- [x] D18.5 诊断完成：153 个 residual 全部 `SameQ` 命中 integral map，且都是 215 个 active basis
  外 global masters 的子集；不存在 reduction 左端符合 Kira master 语义。先定向扩展两个 cycle 传播子
  的负 `b` 截断，不修改 import、30 个 frozen active masters 或其它参数方向。
- [x] D18.6. `b[1],b[2]>=-4` 的 fresh Kira 得到 121,636 条方程、68,982 个积分、228 个全局
  masters、248 个 targets、`unreduced=0`，墙钟 `156.73 s`；正式 import 通过但 DE 仍有 130 个
  唯一 residual `J`。额外 masters 的 `a` 全为 0、`b[1]` 只在 `{-1,0,1}`，仅 `b[2]` 有 21 项
  命中 `-4`。随后只扩 `b[2]>=-5` 的 fresh 反事实得到 143,119 条方程、78,883 个积分，Kira
  墙钟 `348.72 s`；master 数仍为 228，唯一 residual 仍为 130，负向扩层到此停止。
- [x] D18.7. 现有 30-basis 只来自 556-master 浅层 probe 对 36 个零层候选的筛选，尚无完整 family
  维数证明。有限包络试探只用于判断截断边界，不作为 basis 证明；达到下述停止条件后不再扩层。

D18.7 正上界 `2 -> 3` 记录（2026-08-27）：fresh producer 得到 164,602 条 backend 方程、
88,784 个积分和 248 个 formal targets；Kira masters 从 228 降到 156，完整 reduction 墙钟
`403.38 s`、`unreduced=0`。公开 import 身份与覆盖门禁通过，但六变量 DE 仍有 126 个唯一
residual，scaling 未运行。156 个 masters 恰为 30 项 active basis 加 126 项 residual；extra/residual
两集合完全相同，所有 `a=0`、`b[1] in {-1,0,1}`，`b[2] in [-5,1]`，其中 24 项仍在
`b[2]=1`。下一轮只把正上界从 3 扩到 4；若 masters/residual 不再明显下降，停止有限包络试探，
转为补足 30-basis 的完备性独立推导。

D18.7 正上界 `3 -> 4` 记录（2026-08-27）：fresh producer 得到 196,644 条展开 IBP、186,085 条
backend 方程、98,685 个积分和 248 个 formal targets；Kira 初选 masters 仍为 156。按预先声明
的停止条件在 back substitution 前主动终止，因此当前 workspace 不是完整 reduction 证据。矩形
包络试探到此结束；后续只做 active-basis 完备性判断与最小定向 seed closure 推导，不再机械扩层。
- [x] D18.8. 有限矩形 probe 已证明原 30 项和后续 156 项都不能仅凭截断 Kira master 列表声明为
  formal basis；Phase 1 general seed/operator authority 未改变，不重冻 expected，也不从 package
  actual 反向拟合 adapter。

D18.8 当前定责（2026-08-27）：来源隔离的 Phase 1 general seed 显示两条 cycle 传播子连续幂的 momentum
shift 跨度最高为 `[-2,2]`。上界为 4 的 156 个 Kira 初选 masters 中没有 `b[2]=3,4`，且数量相对
上界 3 不再下降；126 个额外项只在 top/e2/e3 sector，并与原 30 项组成 156 项有限截断候选。
156 项对六变量的解析导数检查为 `156x6=936`，message/失败/helper residue 均为 0，`Put/Get
SameQ=True`；1,079 个导数积分相对 `b[2]>=-5` 只缺 30 项，全部为 top/e3、`b[1]=0,b[2]=-6`。
以此 156 项为声明 basis、定向补到 `b[2]>=-6` 的 fresh producer 得到 219,318 条展开 IBP、
207,568 条 backend 方程、108,586 个积分和 1,235 个 targets，但 Kira 初选增至 382 masters；
已在 back substitution 前中止。该反例同时否定 30 项和 156 项的完整 basis 声明，且证明继续用
矩形边界冻结 master 集没有收敛依据。
- [x] D18.9. 撤回 formal runner 中的 `156`、`b[2]>=-6`、`156x156` 与“fresh master 必须等于
  156”的验收假设，并终止 target-directed relation/incidence/frontier 路线。MMA 在参考 massive
  bubble 的合理指标包络内生成完整 canonical IBP 方程；Kira 用 `select_mandatory_list` 限定
  targets 并自行选择方程、三角化和回代。旧 target-directed/fixed-active 脚本及工作区不再进入
  formal 证据，待当前 probe 结束后清理。

D18.9 失败诊断记录（2026-08-27）：旧 fixed-target 路线固定 30 项 candidate 与 218 个导数积分，
在 51,558 条前端筛选关系上运行 Kira 后仍得到 245 个全局 masters；该 workspace 只是说明前端
筛关系没有建立闭合，不能作为 formal 证据，也不再沿其 incidence 继续扩展。

- [ ] D18.10. 撤回把 fixed-target workspace 的 `1..30 -> 36` 解释成主积分跃变的判断。
  `DSUserMI` 会人为插入 30 个前缀 backend ID，并把自然积分 ID 整体后移；同时旧
  `integralSortKey` 用 `_b|_bS`、`_n` 匹配已经数值化的传播子 pack，实际没有让连续 `b` 和离散
  `n` 进入排序。先修正数值 pack 槽位排序并通过专项，再从空 mixed probe 工作区按未插入
  `userMI` 的自然顺序重跑。候选后的下一 master 编号至少达到候选末编号约三倍，且排序键复杂度
  同时明显上升，才允许冻结 basis；否则继续报告 basis 未确定，不生成 DE/scaling。

D18.10 撒点基线：已闭合 pure massive bubble 使用 `a1,a2 in [-1,4]`、`b1,b2 in [-2,5]`。
mix bubble+tree 不新增 loop momentum，top sector 的新增树顶点与圈积分因子化；新的有界 probe
先沿用 `a1,a2,a3 in [-1,4]`、`b1,b2 in [-2,5]`，只把新增树顶点/contact 所需方向作为相对 bubble
的增量。不得再从旧浅层 `a in [-1,1]`、`b in [-2,2]` probe 推断完整 basis。

- [ ] D18.11. 初次 probe 只把自然排序中覆盖预估 master 区段的有界低复杂度集合设为 mandatory
  targets，缺省约前 1000 项；关系输入仍是 D18.10 包络内的完整 IBP 方程。识别真实 basis 后生成
  全部六变量解析导数，逐项检查首次 reduction table 是否已有规则：不论是否原属 mandatory target，
  只要首轮已有完整左端规则且 RHS 闭合到冻结 active masters，就必须直接复用并进入 `DSDE`，不得
  再次约化；只有无规则或未闭合的导数积分组成追加 mandatory targets。追加运行
  继续使用同一完整关系集，不在 MMA 侧做 target-directed relation pruning。

D18.11 旧排序首轮记录（2026-08-28，已作废）：Kira 2.3 对自然 ID 1--1000 的 mandatory targets 在 `283.8 s`
墙钟时间内完成，`unreduced=0`，得到 183 个 masters，最大自然 master ID 为 704。当前窗口没有达到
候选末编号约三倍，尚不能冻结 basis；下一轮仅复用同一完整 `ibp.kira`，把 mandatory list 扩至
1--2500，不重新生成或裁剪 MMA 方程。

D18.11 旧排序扩展轮记录（2026-08-28，已作废）：2500-target Kira 在 `297.7 s` 完成，`unreduced=0`，得到 226 个
masters。新增 43 项中 40 项直接命中 `a=4`，其余 3 项是边界方程移出的 `a=5,6`；但旧自然排序
先穷举 `b=0` 的整条 `a` 塔，前 2500 项没有任何非零连续传播子幂，故 `704 -> 1026=1.4574`
不能作为合格跃变。修正自然 key：`a/b/ISP` 先按联合绝对复杂度排序，再以各分量作稳定 tie-break；
离散 building-block `n` 保持独立计权。更新排序专项和技术手册后，必须从空目录重生 producer/Kira，
旧两轮只保留为发现排序缺陷的诊断证据。

D18.11 联合排序 fresh 记录（2026-08-28）：从空目录重建得到 633,552 条展开关系、610,559 条
canonical 方程和 281,002 个自然积分；候选 SHA-256 为
`AB99C7334AD4E805DA4733FBE4441F01AB957B4A32D2C3A107F4BBC1823BB494`，`ibp.kira` SHA-256 为
`D4B35A36A8A2679D969D0EBBCDF3C847EF04D8499A215083CF33359D48C2C3F6`。前 1000 targets 中
非零 `a`/非零连续 `b`/两者同时非零分别为 820/453/309，联合复杂度 `0:36,1:312,2:652`，排序
审计 `8/8`。Kira 2.3 以 10 个 Fermat/Blackbox 实例在日志总时间 `57.4 s` 内完成；递归选择
63,829 条关系，得到 228 masters、最大 ID 940、`unreduced=0`。该窗口还没有显示合格的三倍跃变，
下一轮只复制同一 `ibp.kira` 并把 mandatory targets 扩至 1--4000；不得重跑 producer。

D18.11 联合排序 4000-target 记录（2026-08-28）：Kira 2.3 日志总时间 `72.1 s`，递归选择
64,776 条关系，得到 444 masters、最大 ID 3911、`unreduced=0`。分析器未找到三倍跃变；新增
216 项中 147 项命中当前 envelope 边缘，但该性质本身不判断 master 真伪。mixed envelope 与 massive
bubble 相同并只增加 `a[v3]`，因此下一轮仍不改 producer，只复用同一 `ibp.kira` 把 targets 扩至
1--12000，保证探测范围越过 `3*3911=11733`。

D18.11 联合排序 12000-target 记录（2026-08-28）：Kira 2.3 日志总时间 `119.0 s`，递归选择
67,536 条关系，得到 809 masters、最大 ID 11560、`unreduced=0`。3911 后仍持续出现 masters，
前段不能冻结；下一轮只复用同一 `ibp.kira` 把 targets 扩至 1--36000，越过
`3*11560=34680`。

D18.11 联合排序 36000-target 记录（2026-08-28）：Kira 2.3 日志总时间 `266.1 s`，回代
`34209/34209` 条选中方程，得到 1527 masters、最大 ID 33802、`unreduced=0`。分析器仍未找到
合格三倍跃变；下一轮继续复用同一 `ibp.kira`，只把 targets 扩至 1--108000，覆盖
`3*33802=101406`，不得重跑 producer。

D18.11 联合排序 108000-target 记录（2026-08-28）：Kira 2.3 日志总时间 `785.7 s`，回代
`104923/104923` 条选中方程，得到 2563 masters、最大 ID 107800、`unreduced=0`，仍无合格三倍
跃变。新增 2335 项中 2023 项命中当前包络边界，且首轮 ID 38 的叶顶点 `a3=1` 已是内部伪 master。
自然积分总数只有 281002，继续扩 target 不能覆盖 `3*107800`，也不能消除低编号截断传播；停止
target-only 扩窗。下一诊断保持完整 canonical 方程，只扩大新增树顶点 `a3` 的目标包络，先检查
ID 38 是否被约回，再决定是否需要加深 bubble 方向。

D18.11 `a3` 包络反事实（2026-08-28）：只把新增叶顶点 `a3` 从 `[-1,4]` 加深到 `[-4,8]`，
其余 bubble 方向不变。fresh producer 得到 1,382,832 条展开关系、1,332,595 条 canonical 方程和
593,216 个自然积分；前 1000 targets 排序 `8/8`，`ibp.kira` SHA-256 为
`78E49946E1615893EE859E970D4E890561A58C361B9439C9AF606D4F5833EB07`。Kira 10 并行总时间
`80.7 s`、`unreduced=0`，masters 从 228 降到 213，但 ID 38 的 `a3=1` 仍为 master。故该项
不是叶顶点包络边界伪 master；停止扩大 `a3`，转为 exact 检查 `tIBP(v3)` recurrence/rank 与 Kira
ordering 方向。

- [x] D18.12. exact `tIBP(v3)` 的 `n=0,1` 两式给出一般可逆的
  `{{E3,q3},{q3,E3}}` 块；当前 Kira 输入两式均存在，但自然排序把 top-sector ID 38 放在 contact
  child ID 42 前，使 Kira 反向约掉 child。缺省排序仍按联合低复杂度交错所有 sector，不把每个
  sector 整块追加；在连续复杂度主键之后，以收缩深度让 lower sector 在同层 tie-break 中优先。
  显式 `SectorRank/SectorOrder` 覆盖自动顺序。通用排序专项 `20/20`；局部 mixed fresh producer
  为 25 条方程、60 个积分，prepare `12/12`。contact ID 29 先于 parent IDs 45/46；Kira 2.3
  在 `7.1 s` 内保留 `{9,10,29}`、约掉两个 parent 且 `unreduced=0`，finish `10/10`。
- [ ] D18.13. basis 确认后生成六变量导数，先查询首次 reduction table；已有完整 LHS 规则且 RHS
  只含冻结 active masters 的导数积分直接复用。仅把无规则或未闭合的导数追加为 mandatory targets，
  不重复约化已覆盖积分，不筛选 relations，也不扩大 seed envelope。

D18.13 当前阻断（2026-08-28）：修正 sector 排序后的 fresh 完整 probe 为 610,559 条方程、
281,002 个积分，Kira 在 `43.6 s` 内得到 228 masters、`unreduced=0`。此前仅因 `a/b/ISP`
移位不为零便把 IDs 45--812 排除为有限-seed 伪 masters，这个判据没有 IBP 依据，现已撤销；
旧 30 项零移位切片不再作为 active basis。下一轮先按用户指定重定义连续指标 level：绝对值和为
`s`、严格负指标数为 `nNeg` 时，`nNeg=0` 取 `s`，否则取 `s+3+2 nNeg`，同 level 内无负指标者
优先。完成最小排序专项后，从空目录重生同一 mixed `t+q` 关系池并重跑 1000 targets，再依据新
master 编号和指标表示判断截断；probe targets 固定为自然排序前 3000 项，新结果产生前不生成六变量 DE。
- [x] D18.14. 为 `integralSortKey` 实现上述负指标 penalty；专项覆盖一个负指标 `+5`、两个负指标
  `+7`、`F`/离散 `n` 不计数、同 level 正指标优先，以及 lower-sector tie-break 与显式覆盖不回归。
- [x] D18.15. 重建 023 单文件候选并从空目录重跑 mixed 完整 probe/Kira；记录前 3000 targets 的
  新排序分层、全部 masters、ID 600--900 的指标表示、最大 master ID 与最后一次显著编号跃变。
- [x] D18.16. 只读分析 fresh Kira 的 3000-target 与 10648-target 两轮结果。第一个负连续指标对象
  是 ID 10649；此前的 10648 个 targets 全部非负。两轮分别得到 344 与 492 个 masters，后一轮新增
  148 项且旧项一项未消失，新增项延伸到 penalty level 6；因此“负指标排序干扰”已经排除，但正
  幂次 basis 尚未闭合。不得按指标正负、编号或单个 gap 删除这些候选。
- [x] D18.17. 作废把 contact 后 compact `a/b` 直接与 root `a=-1/4,b=-2/5` 比较的边界统计。
  使用 sector representative map、root 传播子状态及每条 shrink affine shift，为 492 个 master 反解
  root 指标前像；分别记录是否存在所有 root 指标均严格位于目标包络内部的前像，以及哪些 root
  指标被迫命中边界。只有该 provenance 或现有关系的精确闭合证据指向 seed 截断时，才扩大 root
  包络；否则继续检查排序与关系方向。
- [x] D18.17. root 前像审计通过：398 项存在全内部前像，94 项被迫命中 root 边界；level 0--3
  全部内部，level 4 为 `39/20`、level 5 为 `38/36`、level 6 为 `0/38`（内部/边界）。
- [x] D18.18. 按用户最新决定把 `Boole[nNeg>0]` 提升为自然排序第一键，使全部非负连续指标积分
  构成连续前缀；前缀内部继续按既有 penalty level、lower-sector tie-break 与稳定指标键排序。
  更新排序专项、重建候选与 fresh mixed 完整关系池；自动取首个负指标 ID 之前的全部积分为 Kira
  targets，检查纯非负 master 区段与 root provenance，不再使用硬编码 10648。
- [x] D18.19. cycle-even fresh producer 的完整非负前缀为 24594 targets；Kira 得到 608 masters，
  其中 100 项有全内部 root 前像，508 项被迫命中 `a=4` 或 cycle `b=5` 的上边界。保持下界不变，
  用 `a=-1..5,b=-2..6` 重生完整关系，只选择原 3000-target 轮的 130 masters 作诊断 targets；
  以 RHS 闭合、root provenance 与零 unreduced 判定稳定 basis，不按编号或 level 直接截断。
- [x] D18.19 第一轮完成：`a=-1..5,b=-2..6` 的完整系统含 329041 条 canonical 方程和 137586 个
  积分；130 targets 降为 106 masters，24 条非 master reduction 完整且 RHS 闭合，`unreduced=0`。
  新 106 项全有扩后 interior 前像，但旧 interior 候选仍有 19 项被约掉，不能据此冻结 basis。
- [x] D18.20. 用 `a=-1..6,b=-2..7` 重生完整关系，只选 D18.19 留下的 106 masters 为 targets；
  只有逐积分集合连续稳定、RHS 闭合、零 unreduced 且不依赖当前上边界，才冻结 active basis。
- [x] D18.20 结果：640748 条 canonical 方程、248712 个积分；106 targets 降为 83 masters，
  23 条 reduction 完整闭合，`unreduced=0`。81 个初始 interior 候选全部保留，初始 boundary
  只剩两个 compact `a=7`、root `a[v1]+a[v2]=8` 的 `e1` sector 离散态。
- [x] D18.21. 定向把 `a[v1],a[v2]` 上界从 6 提到 7，保持 `a[v3]<=6` 与 `b<=7`；以 D18.20
  的 83 masters 为 targets。fresh Kira 恰好约掉两项高层候选，其余 81 项逐积分稳定，RHS 闭合且
  `unreduced=0`，因此冻结这 81 项作为 mixed formal-flow active-basis 候选。
- [x] D18.22. 修正 Kira 实数化对 fixed massless bridge 模长的漏识别。通用 producer 必须结构性
  合并顶点外腿相位参数与 `massType=="massless"`、`linePowerMode=="fixed"` 的传播子模长；
  cycle 传播子的 `xi` 是积分变量，不作为外部 backend 坐标。内部对象、manifest、import 与 DE derivative
  view 统一改称 kinematic convention，不保留旧 energy-only helper 或字段。fixed 模长若不是独立
  `Symbol`，导出须停止，并用自然语言提示用户通过 `KinematicRules` 绑定独立原子坐标。
- [x] D18.23. 补最小 smoke：fixed massless bridge 的 `loopScale` 与 `E1/E2/E3` 一同执行
  `k -> -I ik`；`legScale1/legScale2` 不旋转；两条 cycle propagator 仍分别全偶，fixed bridge 不进入
  parity；非原子 fixed 模长负例明确失败。重建候选后从空 mixed formal workspace 重跑
  `16_prepare -> Kira --parallel=10 -> 17_finish`，旧 manifest/reduction 只保留为诊断，不得复用。
  候选单文件 smoke 已通过 `31/31`，并覆盖 manifest validator、import 恢复和 DE backend view；fresh
  prepare 与 Kira 已完成：81 masters、676 targets、`unreduced=0`、10 并行墙钟 `169.16 s`。consumer
  的 import/order/coverage/六变量 DE/source 均通过，但 physical point 同时含
  `loopScale -> -43 I/17` 与 `kk[1,1] -> +1849/289`，违反 `kk[1,1]=loopScale^2`。先构造虚轴物理截面，
  再用同源 `KinematicRules` 重生依赖的内部平方坐标规则；专项必须检查 `kk[1,1] -> -1849/289`、
  backend `iloopscale -> 43/17`、两条 cycle parity 仍全偶且 fixed bridge 不进 parity。当前 Kira 结果作废；
  修后从空目录重跑完整三步并要求 matrix/source residual 全部 exact 0，本项才可勾选。
- [x] D18.24. 继续只读定位 mixed scaling 的 formal IBP 责任层。master 1 的 q-dilation block 已命中
  fresh `ibp.kira`；两个 time block 的诊断重建目前停在 `phaseTransformNotReal`，尚不能判为 export
  缺失。扩充诊断记录每个 coefficient 的积分/ID、formal map 与 phase metadata 覆盖、原始轴相位及
  row phase 0/1 结果，并核对 shifted time seed 的 formal envelope 与 producer canonical/normalization
  顺序。找到首个真实差异后只修对应职责层；传播子 1、2 分别全偶，tree bridge 传播子 3 不进入 parity。
- [x] D18.25. 根因已由反事实确认：实际提前数值化的实点 time blocks 为 `2/2` 命中；manifest 声明的
  虚轴点与实际 Kira 方程不一致。给 `DSKiraExport` 增加门禁，拒绝在 linearData 阶段已消去需虚轴转换
  的物理坐标或依赖内部坐标；mixed formal producer 改为符号 `DSLinear`，精确实 backend 点仅由 formal
  `DSKiraPlan[...,numericStage->"postDerivative"]` 应用。补专项、更新技术说明，重建候选并从空 formal
  workspace 重跑 producer/Kira/consumer；验收两条 time block 均存在且 81 行 scaling exact 为零。

D18.23--D18.25 完成记录（2026-08-29）：候选单文件 SHA-256 为
`59FDC5DE3657A8D31092CC6D2A59070E17D23F0E9C5E338FB0BA84CF44D95339`，虚轴/从属 Gram/
post-derivative 专项显式加载候选通过 `37/37`。从空 mixed formal workspace 重生得到 818217 条
canonical 关系、818297 条 formal 方程、310769 个积分、81 masters、595 derivative targets 和
676 formal targets；`coefficientRulesApplied={}`，物理点同时含 `loopScale->-43 I/17` 与
`kk[1,1]->-1849/289`。Kira 2.3 以 10 并行完整退出 0，81 masters 恰为 IDs `1..81`、
`unreduced=0`，墙钟 `159.27 s`。公开 import/六变量 `81x81` DE/scaling 全部通过，matrix/source
residual 逐项 exact zero；master 1 的两条 time blocks 与一条 q-dilation block 在 fresh
`ibp.kira` 中覆盖为 `2/2` 与 `1/1`。manifest/reduction SHA-256 分别为
`9BE7F11CF26E7EBC0E595BD6FBF37AF8E1F3AA2E3751DE0471B54936E9037B02`、
`7D66B032E78EB724B7EA643092CEAA1DCACA81AA3A6C2968D362E8127FD9C5BD`。

- [x] D18.26（已被 D18.27 推翻）. 此项错误地假设 `postDerivative` reduction 仍能给出完整符号 DE，
  因而把定点常数矩阵乘回符号 Euler 变量并称为符号 residual。fresh mixed consumer 暴露出 2034 个
  非零项；该旧验收不再作为 023 证据。
- [x] D18.27. `DSScaleCheck` 按 manifest 物理规则实际固定的 scaling variables 数量区分证书范围：
  固定 0 个为 `symbolic`，固定全部为 `exactPoint`，只固定一部分为 `fixedSection`。stage 名本身不能
  决定范围；删除同时返回伪符号和定点 residual 的旧合同。
  mixed 的全符号齐次性由 81/81 source-level Euler+time/q-IBP 恒等式单独认证；consumer 同时读取这份
  source-isolated summary 与 exact-point `DSScaleCheck`。专项覆盖三个 scope 和错误反例，重建候选后
  复用未改变的 Kira artifact 重跑 consumer；传播子 1、2 分别全偶，tree bridge 传播子 3 不进入 parity。
- [x] D18.28. pure massive bubble 的 formal plan 同样是 `postDerivative`。新增 19-master source-level
  Euler+time/q-IBP 证书；由于规则只固定非 scaling 参数而保留 `{ss11,P0}`，finish consumer 应联合
  source-level 证书与 reduction 的 symbolic `DSScaleCheck`，并让
  reference consumer 检查新的联合状态。preflight 只登记 pure bubble、mixed bubble+tree 两套外部
  Kira；删除 single-massive sunrise 的 reduction/DE/scaling pending 路线，保留其 general-only 正负门禁。

D18.27--D18.28 完成记录（2026-08-29）：当前候选单文件 SHA-256 为
`BE9587431732AD46C163FBF223CAEB5FF721E51638BD487A9098D6326514A58F`。scope 专项的
`symbolic/fixedSection/exactPoint` 三分类为 `22/22`，原 scaling 回归为 `7/7`。pure massive
bubble 的 source-level Euler+time/q-IBP 为 33 个不同积分 `33/33`、active basis `19/19`，
reduction 证书为 `symbolic`；mix bubble+tree 为 `81/81`，reduction 证书为 `exactPoint`。
mixed 的 parity 只有两条圈传播子各自全偶；fixed tree bridge 传播子 3 的 `b[3]` 不属于圈积分，
未加入 parity。single-massive sunrise 的实际调用追踪未命中任何禁止入口，Kira case 恰好只有
pure massive bubble 与 mix bubble+tree 两套。

- [x] D18.29. 新建正式 Phase 2 parameter-operator 比较器：逐项读取 Phase 1 冻结的 64 个
  operator records，与 18 个 exact package context 的公开 metadata、变量顺序、Jacobian/rank、
  phase/fixed-line 依赖逐项比较；每个变量只使用一个统一
  `ds[(1+x^2) J1+J2/(2+x)+x^3,x,context]` witness，检查显式系数乘积法则。summary 保存
  `64/64`、逐 family/variant 计数、首差值和 package/Phase 1 哈希；不能只记录 operator 数量。
- [x] D18.30. 新建第 16--17 节 capability 正式套件：mixed triangle exact/under/over、
  fixed/dependent-binding exact、bubble+tree exact/under/over。undercomplete 必须拒绝初始化并关闭
  下游；overcomplete 只允许任务书声明的 symbolic producer，且 `ds/DSDE/rep2innerform/DSKiraExport`
  明确拒绝。两条 bubble+tree cycle 传播子分别全偶，tree bridge 不进入 parity。若公开 capability
  或下游门禁与合同不符，先修生产职责层并重建候选，再 fresh 重跑本套件。
- [x] D18.31. fresh 重跑 arXiv:2411.03088 两顶点 `G++` targeted IBP-DE，保存绑定当前候选的
  三张 `25/25` exact summary；按任务书第 21 节建立公开门禁与用户可见自然语言反馈矩阵，实际
  触发 topology、动力学闭合、seed/linearData、Kira artifact、DE/scaling、时间端点与 parity
  提醒，核对内部 code、阻断状态和完整中英文句子。
- [x] D18.32. 复核 Phase 1 freeze/oracle 的当前任务书、authority source 与 accepted digest；
  编译 023 当前手册 PDF；生成 `000-report/YYYY-MM-DD-HHmm-023-内部.md` 及轻量附件。随后删除
  被正式 summary 取代的 probe/diagnostic、`results_temp`、Kira runtime/cache 和临时脚本，执行
  UTF-8、Wolfram 分节、PDF、死代码/旧版本残留与 `git diff --check` 门禁。

D18.29--D18.31 完成记录（2026-08-29）：最终候选 SHA-256 为
`7B729536E62EC22E8A726F2D245D4A602E73811C531CCDC3982218A80A151740`。参数算符逐项比较为
`64/64`，18 个 context 和 7 项 capability 门禁分别为 `18/18`、`7/7`；第 21 节动态反馈矩阵
为 `21/21`，运行时 100 条 Message 的自然语言/下一步检查为 `100/100`。arXiv:2411.03088
两顶点 `G++` 的 `k12/k34/ks` 三张 `5x5` DE 各为 `25/25` exact equal。Phase 1 freeze 复核
19 个文件和 4 个 authority source 全部通过，accepted digest 为
`7E9BC1D72D4D631DDAF8D532C9048D01D3E001F0560587D430D90C2718DD8DFC`。

D18.32 完成记录（2026-08-30）：经纯 ASCII UTF-8 启动器从当前候选 fresh 运行，pure source
identity 为 `33/33`、active basis 为 `19/19`；mixed source identity 为 `81/81`。随后从空 mixed
formal workspace 重生 818217 条 canonical 关系、818297 条 formal 方程、310769 个积分、81 项
active basis、595 个 derivative targets 与 676 个 formal targets。Kira 2.3 以 `w10*1` 完整退出 0，
81 masters 恰为 IDs `1..81`，`unreduced=0`，墙钟 `160.11 s`。公开 consumer 得到六张 `81x81`
DE，exact-point matrix/source residual 均为零；扫描 310688 个普通积分和全部 active masters 未发现
fixed bridge 传播子 3 被当作圈幂或 parity 槽。传播子 1、2 的两条 cycle parity 分别保持全偶。fresh
manifest/reduction SHA-256 分别为
`B3C9ED791EB2C0247A114FA2AC29B526A860DB77FD9B1C6921E8AA412A7A7106`、
`7D66B032E78EB724B7EA643092CEAA1DCACA81AA3A6C2968D362E8127FD9C5BD`。正式报告及轻量附件已归档；
旧 022、候选、Kira runtime/cache 和 examples 运行产物已清理。正式路径复验 `15/15`，五个 UTF-8
examples 均退出 0；严格 UTF-8、Wolfram 分节、死定义/旧入口、PDF、生成物和 `git diff --check`
门禁全部通过。

D18.32 手册子项（2026-08-29）：当前候选重新编译为 33 页 PDF，SHA-256 为
`6480C1BA58B19F6485FC54838FAA53A26F801C2A85F8AEB0632BE6C72ECA974F`。全部 33 页已逐页渲染
检查，中文、公式、代码块、表格和裁切均正常；编译无 undefined reference、fatal error 或 overfull box，
仅有不影响内容的字体替代 warning。正式 PDF 已晋升并保持同一 SHA-256。

D18.1--D18.3 完成记录（2026-08-27）：massless bridge 的顶点移位现先作用于裸 `J`，fixed-line
幂移随后才产生显式模长系数；sector canonical 和 symmetry 同样只处理裸积分再乘回 coefficient。
Kira active-basis 写出前新增内部 helper residue 门禁。模块化 023 的 mixed `30x6=180` 条导数
message/失败/helper residue 均为 0，`Put/Get` 前后 `SameQ=True`，digest 均为
`f94df59ed395a13c6a84b606bb3a1dca4ad9a47209cdb7c6480817b476204120`；合成 helper 反例命中 1 项。
- [x] 让 general `thetaBoundaryAtomicTerms` 与 pure-time `dsDirectTreeAtomicContactChoices` 对
  编译 `-W_T` 使用同一个离散负号；从空 Phase 1 目录重生并冻结后，先跑 massive-contact
  专项，再重建 023 候选并要求论文三张 `5x5` DE 从旧候选的 `21/25` 恢复为 `25/25`。
- [x] 修正 `lineShrinkNormalizationFactor018`：child `N_s` 必须吸收物理
  `contourSign W_T`，即编译 coefficient 的相反数，不能直接吸收 `contourSign (-W_T)`。
  修正后 Phase 2 general 为 `15/15`、tree normalization 为 `14/14`；论文三张 DE 当前均为
  `21/25`，因此已排除 raw 与 normalization 双错相消，但尚未闭合论文 basis/oracle 冲突。

Phase 1 fresh 记录（2026-08-27）：local/family/oracle 分别为 `10/10`、`168/168`、
`31/31`，time/momentum/operator records 为 `976/1363/64`。Freeze 后立即复验 19 个文件与
4 个 authority source 全部通过；旧 `9D1E...` 作废，当前唯一 accepted digest 为
`FDF78319D3E0050355A305F665F7F3F1C884A53025A393F04A3B12772A8FB69B`；任务书 SHA-256 为
`B0C88C28046F63D0DE1FE102C3D7CC473A15888BBDDDE8554B06FB9869727A50`。

两顶点 targeted 当前记录（2026-08-27）：候选 SHA-256 为
`5EA66A0B500109E5BA2D577527645CD7A46D373B69786684DC9B8235471B39AB`；general
seeds/relations/integrals 为 `9/50/40`，非主积分 unknown/rank 为 `35/35`，solve residual
`50/50` exact 为零。论文与 dSIBP 均使用 `n=1=partial_x h`，预声明 basis map 为单位矩阵；按
`E12=-k12`、`E34=-k34` 及导数 Jacobian 映射后，对 arXiv:2411.03088 的 `k12/k34/ks` 三张
`5x5` 矩阵均为 `25/25`，非零差数均为 0。pure massive bubble full flow 已另行完成；mixed 与
sunrise 仍须分别完成，不能由本项替代。
- [x] 将用户圈动量生成元通过 reference routing 的 affine Jacobian 展成 normalized primitive
  generators；公开 `dqq/dqk` 标签和语义仍对应用户输入的 `loopMomenta`，并增加非零 translation
  下 ISP 与 generator 同时变换的最小回归。
- [x] 修正 Phase 2 expected 的自定义运动学坐标适配，使 `mix_bubble_tree` 的 `ss11^2` 严格映射为
  当前 context 的 `loopScale^2`；该修正只属于独立验证 consumer，不回写冻结 oracle 或 package
  producer。清空旧 Phase 2 结果后要求 general `15/15`、tree/guard `11/11`。
- [x] 完成模块化、候选单文件和正式路径的受影响 smoke；重建中英文手册/PDF，清理 022、候选、
  临时诊断、Kira runtime/cache 与旧报告，执行 UTF-8、分节、死代码、产物和 `git diff --check` 门禁。

## D19. Kira 使用点统一轻量化

- [ ] D19.1 为 pure massive bubble 与 mixed bubble+tree 各保留输入摘要和最终结果摘要，不提交完整 Kira 工作树。
- [ ] D19.2 两个 README 明确记录 WSL 外置运行目录边界、已删除的中间产物和摘要用途。
- [ ] D19.3 同步正式交付 examples、总 README、benchmark 说明、用户手册和 023 更新日志。
- [ ] D19.4 重编手册并复验 examples 文件同集同哈希、正式路径、UTF-8、Wolfram 分节、产物清理和 Git 范围。
- [ ] D19.5 核对其它 examples：01 只构造内存 plan，03 只生成 general seeds/operators，05 只做 time-only 内部约化与 DE 交叉检查；均不生成或运行 Kira，也不登记第三套 pending reduction。
- [ ] D19.6 回收正式报告和轻量附件后删除独立检验 `check/`、系统临时工作区及 examples 运行产物；保留的 smoke 不运行 Kira reduction。
