(* ::Package:: *)

(* 本文件集中冻结 016 的运行时 Message 文本。所有消息逐句先中文、后英文；
   只覆盖展示字符串，不改变任何 status、reason、capability 或返回数据。 *)


(* ::Chapter:: *)
(*高层 workflow 消息*)

DSInit::badinput = "DSInit 输入不是有效的 topology Association，或 ISP/动量坐标不闭合。 The DSInit input is not a valid topology Association, or its ISP/momentum coordinates are not closed.";
DSInit::sectorincomplete = "无法完整初始化 contact-reachable sectors：`1`。 Contact-reachable sectors could not be initialized completely: `1`.";
DSInit::initconflict = "初始化目录 `1` 已含不同输入哈希或未知文件；如确认覆盖，请显式设置 OverwriteInitialization -> True。 Initialization directory `1` contains a different input hash or unknown files; set OverwriteInitialization -> True explicitly to replace it.";
DSInit::writefailed = "初始化 metadata 写入失败：`1`。 Initialization metadata could not be written: `1`.";
DSInfo::noinit = "当前没有已注册的 DSInit context。 No DSInit context is currently registered.";
DSInfo::badcontext = "给定对象不是有效的 DSInit context。 The supplied object is not a valid DSInit context.";

DSSeeds::noinit = "DSSeeds 需要有效的 DSInit context。 DSSeeds requires a valid DSInit context.";
DSSeeds::failed = "canonical seed 生成未通过门禁：`1`。 Canonical seed generation failed its gate: `1`.";
DSSeeds::capability = "当前 context 不具备 seed 生成所需能力：`1`。 The current context lacks the capabilities required for seed generation: `1`.";
DSLinear::noinit = "DSLinear 需要有效的 DSInit context。 DSLinear requires a valid DSInit context.";
DSLinear::badseed = "DSLinear 需要 DSSeeds 或 DSGenerateIBP 返回的 canonical seed Association。 DSLinear requires a canonical seed Association returned by DSSeeds or DSGenerateIBP.";
DSLinear::badmode = "LinearSystemMode 只允许 \"symbolic\" 或 \"numeric\"，收到 `1`。 LinearSystemMode must be \"symbolic\" or \"numeric\"; received `1`.";
DSLinear::failed = "linearData 生成未通过门禁：`1`。 linearData generation failed its gate: `1`.";
DSLinear::capability = "当前 context 不具备 linearData 生成所需能力：`1`。 The current context lacks the capabilities required for linearData generation: `1`.";
DSLinear::context = "seedData 与 context 不是同一次初始化的产物。 seedData and context do not originate from the same initialization.";

DSKiraExport::badlinear = "DSKiraExport 需要 DSLinear 返回的 backend-neutral linearData。 DSKiraExport requires backend-neutral linearData returned by DSLinear.";
DSKiraExport::failed = "Kira 输入未生成：`1`。 Kira input was not generated: `1`.";
DSKiraExport::badbasis = "KiraActiveBasis 未通过验证：`1`。 KiraActiveBasis failed validation: `1`.";
DSKiraExport::capability = "linearData 未携带通过 DSLinear 的同源能力门禁。 linearData does not carry a passed DSLinear provenance/capability gate.";
DSKiraExport::devarrules = "数值/系数规则与微分阶段合同冲突，Kira 导出已拒绝：`1`。 Numeric/coefficient rules conflict with the differentiation-stage contract, so Kira export was rejected: `1`.";
DSKiraExport::badstage = "KiraNumericStage 只允许 \"symbolic\" 或 \"postDerivative\"，收到 `1`。 KiraNumericStage must be \"symbolic\" or \"postDerivative\"; received `1`.";

DSKiraImport::badpath = "Kira workspace 路径不存在或不是目录：`1`。 The Kira workspace path does not exist or is not a directory: `1`.";
DSKiraImport::missing = "Kira 结果缺少必需文件：`1`。 Required Kira result files are missing: `1`.";
DSKiraImport::incomplete = "Kira 完成日志没有成功标记：`1`。 The Kira completion log has no success marker: `1`.";
DSKiraImport::mismatch = "Kira 结果与当前 export/context 不一致：`1`。 Kira results do not match the current export/context: `1`.";
DSKiraImport::invalid = "Kira reduction 数据未通过完整性检查：`1`。 Kira reduction data failed its integrity check: `1`.";

DSDE::badreduction = "DSDE 只接受 DSKiraImport 验证通过的 reductionData。 DSDE accepts only reductionData validated by DSKiraImport.";
DSDE::badvars = "微分变量必须是当前 family 初始化的外部独立变量：`1`。 Differentiation variables must be initialized independent external variables of the current family: `1`.";
DSDE::writefailed = "DE 结果写入失败：`1`。 DE results could not be written: `1`.";
DSScaleCheck::badde = "DSScaleCheck 需要 DSDE 返回的 generated DE 数据。 DSScaleCheck requires generated DE data returned by DSDE.";
DSScaleCheck::badspec = "标度 relation/variables/weights/degrees 不完整或长度不一致：`1`。 Scaling relation/variables/weights/degrees are incomplete or have inconsistent lengths: `1`.";


(* ::Chapter:: *)
(*底层 seed、坐标与 serializer 消息*)

parseTopology::missingkeys = "case 缺少必需字段：`1`。 The case is missing required fields: `1`.";
parseTopology::badinput = "case 输入 preflight 失败：`1`。 Case-input preflight failed: `1`.";
parseTopology::badfunction = "massive line 的函数系统编译失败：`1`。 Compilation of a massive-line function system failed: `1`.";
makeLinePack::badtype = "未知 packType `1`，line id = `2`。 Unknown packType `1`; line id = `2`.";
assertNoForbiddenN::badn = "表达式仍含 forbidden n 指标：`1`。 The expression still contains forbidden n indices: `1`.";
symmetry::badrules = "symmetryRules 必须是 Rule/RuleDelayed 的列表。 symmetryRules must be a list of Rule or RuleDelayed expressions.";

applyMomentumGeneratorSeed::nosp = "拓扑 `1` 的标量积反解不可用，不能生成 momentum seed：`2`。 Scalar-product inversion is unavailable for topology `1`, so a momentum seed cannot be generated: `2`.";
applyTimeGeneratorSeed::badgen = "time seed 只能使用 time 生成元，收到：`1`。 A time seed requires a time generator; received `1`.";
applyExternalVectorDerivativeSeed::badgen = "external-vector seed 只能使用 externalVector 生成元，收到：`1`。 An external-vector seed requires an externalVector generator; received `1`.";
applyExternalVectorDerivativeSeed::nosp = "拓扑 `1` 的标量积反解不可用，不能生成 external-vector seed：`2`。 Scalar-product inversion is unavailable for topology `1`, so an external-vector seed cannot be generated: `2`.";
makeExternalInvariantDerivativeDecomposition::badvar = "变量 `1` 不是当前支持的外部不变量。 Variable `1` is not a supported external invariant.";
makeExternalInvariantDerivativeDecomposition::nosol = "变量 `1` 无法由外动量矢量导数基 `2` 分解。 Variable `1` cannot be decomposed in the external-vector derivative basis `2`.";
makeKiraExportData::notlinearinput = "Kira 导出只接受 linear-system 数据，不直接接受 seed batch：`1`。 Kira export accepts only linear-system data, not a seed batch directly: `1`.";
makeKiraExportData::badlinear = "linear-system 不能导出 Kira：`1`。 The linear system cannot be exported to Kira: `1`.";

dSIBPPublicAPI::notopo = "当前没有已注册的 topology context。 No topology context is currently registered.";
dSIBPPublicAPI::badtopo = "topology context 无效或解析失败：`1`。 The topology context is invalid or failed to parse: `1`.";
dSIBPPublicAPI::badshape = "表达式中的 J 与 topology context 不兼容：`1`。 J objects in the expression are incompatible with the topology context: `1`.";
dSIBPPublicAPI::badstate = "IBP 公开算子要求所有 full-line 离散态已显式取 0/1：`1`。 Public IBP operators require every full-line discrete state to be explicitly 0 or 1: `1`.";
dSIBPPublicAPI::badgen = "找不到请求的 IBP 生成元：`1`。 The requested IBP generator was not found: `1`.";
dSIBPPublicAPI::badvar = "变量 `1` 不在当前 topology 初始化的外部独立变量列表 `2` 中。 Variable `1` is not in the initialized independent external-variable list `2`.";
dSIBPPublicAPI::ambiguousvar = "变量 `1` 属于过完备动力学坐标；重选独立变量前，ds 已禁用。 Variable `1` belongs to overcomplete kinematic coordinates; ds is disabled until an independent set is chosen.";
dSIBPPublicAPI::noinverse = "当前动力学规则没有唯一的用户坐标到基础标量积反向映射；rep2innerform 已拒绝。审计：`1`。 The current kinematic rules have no unique inverse map from user coordinates to base scalar products; rep2innerform was rejected. Audit: `1`.";
dSIBPPublicAPI::nonlinear = "ds 只接受 J 的线性组合；检测到非线性或非多项式 J 依赖：`1`。 ds accepts only linear combinations of J; nonlinear or nonpolynomial J dependence was found: `1`.";
dSIBPPublicAPI::derivativefailed = "变量 `1` 的积分导数生成失败。 Integral differentiation with respect to variable `1` failed.";


(* ::Chapter:: *)
(*Tree 与 pure-time 消息*)

makeTreeFamilyData::badinput = "tree family 输入无效：`1`。 Tree-family input is invalid: `1`.";
treeIntegralShape::badshape = "tree J 的 pack 形状与 family 不一致：`1`。 The pack shape of tree J is inconsistent with the family: `1`.";
treeDiagonalInverse::singular = "tree recurrence 位于奇异面：`1`。 The tree recurrence lies on a singular locus: `1`.";
treeLoopIntegralFromTree::unsupported = "tree 到 loop seed 的反投影尚不支持该 line pack：`1`。 Back-projection from tree to loop seed does not support this line pack: `1`.";
treeEndpointData::badend = "tree 迭代终点无效：`1`。 The tree-iteration endpoint is invalid: `1`.";
repIterativeData::badindex = "tree a 指标必须是可判定整数：`1`。 Tree a indices must be decidable integers: `1`.";
repIterativeData::noprogress = "tree 递推没有严格趋近指定终点：`1`。 Tree recurrence did not strictly approach the requested endpoint: `1`.";
repIterativeData::cycle = "tree 递推检测到重复 canonical 状态：`1`。 Tree recurrence encountered a repeated canonical state: `1`.";
repIterativeData::nosector = "tree 积分无法唯一匹配 sector family：`1`。 The tree integral cannot be matched uniquely to a sector family: `1`.";
loopToTreeProjection::badloop = "loop-to-tree 投影只接受合法三槽 loop J：`1`。 Loop-to-tree projection accepts only a valid three-slot loop J: `1`.";
loopToTreeProjection::mixedcontact = "mixed-sign line 不得产生 theta/contact shrink：`1`。 A mixed-sign line must not produce a theta/contact shrink: `1`.";
makeTreeTimeReductionRules::incomplete = "tree time seed 状态组不完整：`1`。 The tree time-seed state group is incomplete: `1`.";
treeFamilyForIntegral::ambiguous = "tree J 的 pack 形状同时匹配多个 sector：`1`。当前表示无法唯一确定 sector，已拒绝继续约化。 The pack shape of tree J matches multiple sectors: `1`. The current representation cannot determine a unique sector, so reduction was rejected.";
DSTreeNaiveIBP::badmasters = "tree naive IBP 需要非空、无重复且可唯一匹配 sector 的 tagged master 列表。 Tree naive IBP requires a nonempty, duplicate-free tagged master list with unique sector matches.";
DSTreeNaiveIBP::nonsquare = "tree naive IBP 方程数 `1` 与待约化对象数 `2` 不相等。 The tree naive IBP equation count `1` differs from the reducible-object count `2`.";
DSTreeNaiveIBP::solvefailed = "tree naive IBP 线性系统求解失败。 Solving the tree naive IBP linear system failed.";
DSTreeNaiveDE::badibp = "DSTreeNaiveDE 需要 DSTreeNaiveIBP 成功返回的数据或合法 DSInit context。 DSTreeNaiveDE requires successful DSTreeNaiveIBP data or a valid DSInit context.";
DSTreeNaiveDE::badvars = "tree 微分变量必须是当前 family 初始化的外部独立变量：`1`。 Tree differentiation variables must be initialized independent external variables of the current family: `1`.";
