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
- 标准线：`id/massType/endpoints/momentum`；massive 线再需 `nu`。
- 高级 massive 线：可用唯一 `functionSystem -> "h"|"H"|Association`。
- 圈外向量：`loopExternalMomenta`。
- 无圈模长基：`independentExternalMomenta`。
- 运动学坐标重定义：唯一 `kinematicRules`。
- 指数相位：`vertexType="+"` 给 `Exp[-I externalLegEnergy tau]`，`"-"` 给
  `Exp[+I externalLegEnergy tau]`。

## 必须删除

- 旧公开 `vertexData`、`vertexEnergies`、`lineData` 和 line 五元组入口。
- `bbType`、`eomCoefficients`、line-local `shrinkPrefactor`。
- 用户 line 的 `skType/packType/state/thetaConvention/thetaBoundarySignOffset`。
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
   `id/vertexType/externalLegEnergy`，每条 line 必须含 `id/massType/endpoints/momentum`。
   massive 线另需 `nu`，可选 `functionSystem`；massless 线忽略额外键但绝不读取
   `nu/functionSystem`。Association 键顺序任意，额外键不进入内部 topology。
2. `vertexType` 在 parser 内唯一规范化成 vertex sign：`+ -> -1`、`- -> +1`，使外腿指数
   统一为 `Exp[I sign externalLegEnergy tau]`。line 的 SK、pack、endpoint state 和 contact
   系数只从端点顶点及 contraction 状态派生。
3. root topology 只保存后续模块实际消费的规范化键。sector constructor 直接接收 root
   topology 与 contracted-line set，生成新的 active vertices、代表映射、line packs、零点和
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
