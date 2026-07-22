(* ::Package:: *)

(* ::Chapter:: *)
(*公开上下文与接口声明*)

BeginPackage["dSIBP`"];

$dSIBPVersion::usage = "$dSIBPVersion 给出当前加载的 dSIBP package 三位版本号。";

J::usage = "J 表示统一积分对象；J[aList,linePacks,ispList] 是 loop 表示，J[vertexPacks] 是 tree 表示。";
sp::usage = "sp[p,q] 是用户输入使用的对称标量积。";
qq::usage = "qq[i,j] 是内部圈动量标量积坐标。";
qk::usage = "qk[i,j] 是内部圈动量与外动量标量积坐标。";
kk::usage = "kk[i,j] 是内部外动量标量积坐标。";
a::usage = "a[v] 是 makeBaseIntegral 为顶点 v 建立的时间幂次整数指标。";
b::usage = "b[e] 是未缩并传播子 e 的分母幂次整数指标。";
bS::usage = "bS[e] 是缩并传播子 e 的分母幂次整数指标。";
n::usage = "n[e,...] 是 full-line 的二元离散态指标。";
ispN::usage = "ispN[i] 是第 i 个 ISP 的整数幂次指标。";
a0::usage = "a0[v] 是顶点时间幂次零点；物理幂次为 a+a0。";
b0::usage = "b0[e] 是未缩并传播子分母幂次零点；物理分母幂次为 b+b0。";
bS0::usage = "bS0[e] 是缩并传播子分母幂次零点；物理分母幂次为 bS+bS0。";
rho::usage = "rho[i] 是第 i 个 ISP 的内部坐标符号。";
dim::usage = "dim 是圈动量积分的空间维数参数。";
ke::usage = "ke[i] 是 014 兼容的独立外腿能量参数；015 推荐声明 externalLegMomenta，并让实际出现的无圈动量模长独立基依次绑定为 sE1,sE2,...。";
tau::usage = "tau[v] 是 rep2Integrand 输出中的顶点共形时间。";
xi::usage = "xi[e] 是 rep2Integrand 输出中的第 e 条线的动量模。";
Hh::usage = "Hh[block] 是 rep2Integrand 使用的惰性传播子 building-block 包装。";
MassiveBlock::usage = "MassiveBlock[...] 是 massive line 的惰性 integrand block。";
MasslessBlock::usage = "MasslessBlock[...] 是同分支 massless line 的惰性 integrand block。";
MasslessCrossBlock::usage = "MasslessCrossBlock[...] 是异分支 massless line 的惰性 integrand block。";
Tuserweight::usage = "Tuserweight[id] 是 Kira user-defined system 结果中的积分编号 token。";

dtau::usage = "dtau[vertex,expr] 生成指定顶点的时间 IBP；显式 topology 形式为 dtau[vertex,expr,topo]。";
dqq::usage = "dqq[dLoop,vectorLoop,expr] 生成圈动量沿圈动量方向的 IBP。";
dqk::usage = "dqk[dLoop,vectorExternal,expr] 生成圈动量沿外动量方向的 IBP。";
ds::usage = "ds[expr,var] 对初始化后的外部变量 var 求总导数；015 缺省 var 为 loop Gram 根号 ssij 或实际无圈模长 sE1,sE2,...，并同时作用于积分指标和显式动力学系数。";
rep2innerform::usage = "rep2innerform[expr] 把用户 sp/ssij/sEe 表示转换为当前 topology 的内部坐标；一般混合或过完备坐标没有唯一反向映射时返回 $Failed。";
rep2outform::usage = "rep2outform[expr] 把内部标量积坐标按当前规则转换为用户 sp/ssij/sEe 表示。";
rep2Integrand::usage = "rep2Integrand[expr] 把统一 J 表示展开为用于核对的形式 integrand。";
symmetry::usage = "symmetry[expr,topo] 一次应用 topology 的内建、用户和 tadpole 对称性规则。";
repSymmetry0::usage = "repSymmetry0[topo] 返回 topology 输入的原始用户对称性规则。";
repIterative0::usage = "repIterative0 保存最近一次 tree 单步迭代生成的原始替换规则。";
repIterative::usage = "repIterative[expr,end] 把 tree 积分迭代约化到各顶点的目标时间幂次；sector-tagged treeLinearData 输入会保持 sector 身份并返回同结构约化结果，end 缺省为全零。";
DSTreeSeeds::usage = "DSTreeSeeds 由 loop time-IBP 生成带 sector/contact 审计的 pure-time/tree 种子。";
DSTreeNaiveIBP::usage = "DSTreeNaiveIBP[context,masters] 把 loop time-IBP 投影成 sector-tagged tree 线性系统，并在指定有序 master basis 下直接求解全部一步升幂对象；masters 缺省取 DSTreeDLogDE 的同序归一化 masters。";
DSTreeNaiveDE::usage = "DSTreeNaiveDE[context,variables,masters] 通过 loop 顶点相位导数投影、h 的 treeEnergy 导数和 DSTreeNaiveIBP 约化构造 tree 微分方程；结果保持指定 master 顺序和 normalization。";
DSTreeDLogDE::usage = "DSTreeDLogDE[data] 返回 tree vertex-family 的 dlog 微分方程、同序 master 列表和 letters；DSInit context 输入会由 loop time-IBP contact selectors 组装全部可达 sector 的 block-triangular connection、normalization 审计与同序 tagged masters。";

DSInit::usage = "DSInit[input,opts] 验证 topology/ISP、初始化完整 contact-reachable sector，并可写出版本化 init metadata。";
DSInfo::usage = "DSInfo[] 返回当前初始化的简要信息；DSInfo[context,\"Full\"] 返回完整初始化 Association。";
DSKinematics::usage = "DSKinematics[input,rules] 返回 topology 的缺省动力学变量提案、实际出现/独立无圈模长、从属 binding，以及给定规则的秩、零空间、完备性和可逆性审计；rules 缺省读取 input 或使用自动提案。";
DSSeeds::usage = "DSSeeds[context,opts] 生成所有 contact-reachable sector 的 canonical IBP seeds；不运行 reduction。";
DSLinear::usage = "DSLinear[seedData,context,opts] 把 canonical seeds 转换为 backend-neutral linearData。";
DSKiraExport::usage = "DSKiraExport[linearData,opts] 序列化 Kira 基础输入和同源 manifest；不会启动 Kira。";
DSKiraImport::usage = "DSKiraImport[path,context,opts] 导入并验证完整 Kira reduction、master 顺序和积分双向映射。";
DSDE::usage = "DSDE[reductionData,variables,opts] 用 ds 和 reduction rules 构造保持 master 顺序的微分方程矩阵。";
DSScaleCheck::usage = "DSScaleCheck[deData,spec,opts] 检查约化后的 Euler/标度关系。";
DSMessagesOn::usage = "DSMessagesOn[] 开启 info、progress 和 warning 提醒。";
DSMessagesOff::usage = "DSMessagesOff[] 关闭可选提醒；fatal error 始终保留。";
DSMessagesQ::usage = "DSMessagesQ[] 返回可选提醒当前是否开启。";

WriteInitializationFiles::usage = "WriteInitializationFiles 是 DSInit 的选项；缺省 False。";
InitializationDirectory::usage = "InitializationDirectory 指定 init metadata 目录；缺省 Automatic，解析到调用脚本同目录的 init/。";
GenerateDerivativeMetadata::usage = "GenerateDerivativeMetadata 控制 DSInit 是否预生成独立变量微分算符 metadata；缺省 False。";
OverwriteInitialization::usage = "OverwriteInitialization 控制是否允许覆盖已有但输入哈希不一致的 init metadata；缺省 False。";
RegisterAsCurrent::usage = "RegisterAsCurrent 控制 DSInit 是否注册为无参公开接口的当前 context；缺省 True。";
ProgressReporting::usage = "ProgressReporting 控制单次高层调用的阶段进度；Automatic 跟随全局消息开关。";
KinematicRules::usage = "KinematicRules 是 DSInit 的可选动力学变量替换规则；缺省 Automatic 使用 input 中的 kinematicRules，若仍未给出则采用 DSKinematics 的缺省提案。";

PrecomputeShrinkSectorMetadata::usage = "PrecomputeShrinkSectorMetadata 控制底层是否预枚举 contact-reachable sector metadata。";
MaxShrinkSectorDepth::usage = "MaxShrinkSectorDepth 限制 shrink sector 深度；Automatic 使用完整可达深度。";
MaxShrinkSectorCount::usage = "MaxShrinkSectorCount 限制可初始化的 shrink sector 数。";
UseSampleOnly::usage = "UseSampleOnly 控制 continuous seed 是否使用 sample-only 范围。";
DiscreteMode::usage = "DiscreteMode 选择离散态 seed 模式：\"sample\"、\"all\" 或 \"none\"。";
MaxSeedRuleCount::usage = "MaxSeedRuleCount 限制连续 seed 规则数。";
MaxDiscreteRuleCount::usage = "MaxDiscreteRuleCount 限制离散态规则数。";
MaxEquationCount::usage = "MaxEquationCount 限制生成的方程数。";
ApplyNumericRules::usage = "ApplyNumericRules 控制底层 seed 是否提前代入 numericRules；高层缺省 False，数值替换应优先留到 linearData 层。";
GenerateShrinkSectors::usage = "GenerateShrinkSectors 控制 canonical seed 是否生成 contact-reachable shrink sectors；高层完整工作流缺省 True。";
KiraOrdering::usage = "KiraOrdering 指定 backend-neutral linearData 的 Kira 排序约定。";
CoefficientRules::usage = "CoefficientRules 指定 linearData 层的小规模系数替换规则。";
LinearSystemMode::usage = "LinearSystemMode 选择 DSLinear 的 \"symbolic\" 或 \"numeric\" 模式。";
ExportKira::usage = "ExportKira 是底层组合工作流的导出开关；DSKiraExport 本身不运行 Kira。";
OutputDirectory::usage = "OutputDirectory 指定 serializer 输出目录；None 表示只返回内存数据。";
KiraCoefficientRules::usage = "KiraCoefficientRules 指定 Kira 导出前的系数规则。";
KiraIntegralOrder::usage = "KiraIntegralOrder 指定 Kira 导出的显式积分顺序。";
KiraTargetIntegrals::usage = "KiraTargetIntegrals 指定 Kira job 的目标积分。";
KiraActiveBasis::usage = "KiraActiveBasis 为 DSKiraExport 指定有序 active basis 线性组合、名称和导数变量；缺省 None。";
KiraJobOptions::usage = "KiraJobOptions 指定仅用于生成 Kira job 文件的选项 Association。";
KiraReductionFile::usage = "KiraReductionFile 指定 DSKiraImport 读取的 reduction 规则文件；缺省先查 results/Tuserweight/kira_list.m，再兼容 results/kira_list.m。";
KiraMasterFile::usage = "KiraMasterFile 指定 DSKiraImport 读取的有序 master 文件；缺省先查 results/Tuserweight/masters，再兼容 results/masters。";
KiraCompletionFile::usage = "KiraCompletionFile 指定 DSKiraImport 检查的完成日志；缺省为 kira.log。";
KiraCompletionPatterns::usage = "KiraCompletionPatterns 指定完成日志必须匹配的字符串或 RegularExpression 列表。";
MaxReductionIterations::usage = "MaxReductionIterations 限制 DSDE 对 reduction rules 的 FixedPoint 迭代次数；缺省 100。";
ScalingRelation::usage = "ScalingRelation 指定 DSScaleCheck 使用的 \"Custom\" 或 \"PureMassiveBubble\" 标度关系。";
ScalingVariables::usage = "ScalingVariables 指定 Euler 算符中的变量顺序。";
ScalingWeights::usage = "ScalingWeights 指定 Euler 算符中各变量的系数；015 的 ssij 与实际无圈模长 sEe 都是动量一次量，缺省物理权重为 1。";
ScalingDegrees::usage = "ScalingDegrees 指定各 master 的预期齐次次数；PureMassiveBubble 可设 Automatic。";

(* ::Chapter:: *)
(*私有实现加载*)

Begin["`Private`"];

$dSIBPPackageRoot = DirectoryName[DirectoryName[$InputFileName]];
$dSIBPVersion = "015";

(* ::Chapter:: *)
(*å»ç»åæä»¶ç§æå®ç°*)

(* ::Package:: *)
(* 本文件是 dS IBP package 的通用生成器骨架。
   目标是先把 topology-driven 的结构层做实：拓扑解析、传播子 metadata、统一 J 指标包、
   离散态枚举、完整圈动量 IBP 生成元列表、标量积/ISP 覆盖性验证。
   当前文件生成 momentum seed、time-core seed 与受保护的自动 shrink-sector seed；EOM、有方向的 per-line massless 单 n 规则与 massive/massless theta boundary shrink 已作为 seed 门禁接入，并提供 backend-neutral linear-system 与 Kira serializer。
   008 修正 massive ++ Wronskian theta-boundary 的 Vpm 符号，并加入用户 symmetryRules 的原子化单次应用接口。
   009 进一步按每个 J 的 shrunk packs 重建目标顶点映射，修正跨 sector 的 massless coincident n=1 canonical。
   010 增加 dtau/dqq/dqk 与 rep2innerform/rep2outform/rep2Integrand 公开 API；底层物理公式继续复用 009 原子模块。
   011 增加 P,Q,T,W 函数系统编译层；缺省 h 取 T=IdentityMatrix[2]、WT=W_h，Hankel 作为独立 preset。
   012 增加共同-theta odd-subset contact、contact 可达 sector、massless shrink 幂次修正与 massive coincidence canonical。
   013 只新增 pure time-IBP/tree 表示、loop-time 投影、通用迭代矩阵与直接 dlog DE；标准 package 和交互工程化留到 014。
   性能原则：默认只定义函数和示例输入，不自动运行检查；验证必须是 seed/metadata 层或代数赋值后的小检查。 *)

(* 加载主线脚本不得清空用户 Global` 上下文；开发时需要彻底重载应使用新 kernel。 *)


(* ::Chapter:: *)
(*环境与通用工具*)

(* 本章只解析脚本目录并定义小工具函数。加载 package 不改变用户当前工作目录；输出路径由调用者显式决定。 *)

baseDir = If[StringQ[$InputFileName] && $InputFileName =!= "",
   DirectoryName[$InputFileName],
   If[TrueQ[$Notebooks],
    With[{nd = Quiet[NotebookDirectory[]]},
     If[StringQ[nd] && nd =!= $Failed, nd, Directory[]]
     ],
    Directory[]
    ]
   ];


(* 只做结构零判断；解析化简应放到单独的小规模 specialized check 中。 *)
zeroQ[expr_] := TrueQ[expr === 0];


(* 用户口统一用 sp 表示 scalar product；内部仍用 qq/qk/kk 编号坐标做线性代数。 *)
SetAttributes[sp, Orderless];
SetAttributes[qq, Orderless];
SetAttributes[kk, Orderless];


(* 对称标量积记号。qq/kk 只保留上三角索引，避免同一个标量积出现两种名字。 *)
qqSym[i_, j_] := If[i <= j, qq[i, j], qq[j, i]];
kkSym[i_, j_] := If[i <= j, kk[i, j], kk[j, i]];


(* ::Chapter:: *)
(*拓扑输入规范化*)

(* 本章把用户输入的 vertexData/lineData/extLegs/loopMomenta/ispData 规范化为 Association。
   lineData 可用旧的五元组，也可用 Association；后者可显式指定 massType/skType/packType。 *)


(* 旧格式兼容：{id,{u,v},Q,nu,bbType} 默认是 massive 完整线。 *)
normalizeLine[line_Association] := line;
normalizeLine[{id_, endpoints_, momentum_, nu_, bbType_}] := <|
   "id" -> id,
   "endpoints" -> endpoints,
   "momentum" -> momentum,
   "nu" -> nu,
   "bbType" -> bbType,
   "massType" -> "massive",
   "state" -> "full"
   |>;


(* ISP 可用 {name, expr, range} 或 Association。006 用户口 expr 写成 sp[p,r] 或其线性组合。 *)
normalizeISP[isp_Association] := isp;
normalizeISP[{name_, expr_, range_}] := <|
   "name" -> name,
   "expr" -> expr,
   "range" -> range
   |>;


requiredCaseInputKeys[] := {"vertexData", "lineData", "loopMomenta"};


optionalCaseInputKeys[] := {
   "name", "extLegs", "externalMomenta", "externalInvariantRules", "rawExternalInvariantRules",
   "externalLegMomenta", "externalLegInvariantRules", "rawExternalLegInvariantRules",
   "kinematicRules",
   "ispData", "vertexEnergies", "activeVertexIds",
   "fixedAVertexValues", "numericRules", "rawNumericRules", "sampleDiscreteRules", "seedPreset", "seedRanges",
   "generatorSeedRanges", "seedOptions", "zeroPointRules", "shrinkPrefactorRules", "symmetryRules", "thetaBoundarySignOffset", "kiraOrdering"
   };


validVertexEntryQ[entry_] := ListQ[entry] && Length[entry] >= 2;


validLineEntryShapeQ[entry_] := AssociationQ[entry] || MatchQ[entry, {_, _, _, _, _}];


lineEntryAssociationMissingKeys[entry_Association] := Complement[{"id", "endpoints", "momentum"}, Keys[entry]];
lineEntryAssociationMissingKeys[_] := {};


lineEntryEndpointValue[entry_Association] := Lookup[entry, "endpoints", Missing["NoEndpoints"]];
lineEntryEndpointValue[{_, endpoints_, ___}] := endpoints;
lineEntryEndpointValue[_] := Missing["NoEndpoints"];


validEndpointPairQ[endpoints_] := ListQ[endpoints] && Length[endpoints] == 2;


validISPEntryShapeQ[entry_] := AssociationQ[entry] || MatchQ[entry, {_, _, _}];


ispEntryAssociationMissingKeys[entry_Association] := Complement[{"name", "expr"}, Keys[entry]];
ispEntryAssociationMissingKeys[_] := {};


validIndexRangeSpecQ[spec_] := IntegerQ[spec] || (ListQ[spec] && Length[spec] > 0 && And @@ (IntegerQ /@ spec));


(* 每条生成元覆盖记录都显式携带 sector、现有 generator label 与变量值域。
   ranges 允许只覆盖部分连续变量；未列出的变量继续使用统一 seedRanges。 *)
generatorSeedRangeEntryShapeIssues[entry_, index_] := Module[
   {required = {"sectorKey", "generator", "ranges"}, missing, ranges, badRangePositions},
   If[! AssociationQ[entry],
    Return[{<|"entryIndex" -> index, "reason" -> "entry must be an Association", "entry" -> entry|>}]
    ];
   missing = Complement[required, Keys[entry]];
   If[missing =!= {},
    Return[{<|"entryIndex" -> index, "reason" -> "missing required keys", "missingKeys" -> missing|>}]
    ];
   ranges = entry["ranges"];
   If[! StringQ[entry["sectorKey"]] || ! ListQ[entry["generator"]] || ! ListQ[ranges],
    Return[{<|"entryIndex" -> index, "reason" -> "sectorKey must be a string and generator/ranges must be lists"|>}]
    ];
   badRangePositions = Flatten @ Position[
      ranges,
      rule_ /; ! MatchQ[Unevaluated[rule], (_Rule | _RuleDelayed)] || ! validIndexRangeSpecQ[Last[rule]],
      {1},
      Heads -> False
      ];
   If[badRangePositions === {},
    {},
    {<|"entryIndex" -> index, "reason" -> "ranges must contain index -> integer-range rules", "badRangePositions" -> badRangePositions|>}
    ]
   ];


generatorSeedRangesShapeIssues[data_] := If[
   ! ListQ[data],
   {<|"reason" -> "generatorSeedRanges must be a list of Associations", "value" -> data|>},
   Flatten[MapIndexed[generatorSeedRangeEntryShapeIssues[#1, First[#2]] &, data], 1]
   ];


validNonNegativeIntegerQ[value_] := IntegerQ[value] && value >= 0;


allowedSeedOptionKeys[] := {
   "DiscreteMode", "MaxSeedRuleCount", "MaxDiscreteRuleCount", "MaxEquationCount",
   "MaxShrinkSectorDepth", "MaxShrinkSectorCount"
   };


validSeedOptionValueQ["DiscreteMode", value_] := MemberQ[{"sample", "all", "none"}, value];
validSeedOptionValueQ["MaxShrinkSectorDepth", value_] := value === Automatic || validNonNegativeIntegerQ[value];
validSeedOptionValueQ[key_, value_] /; MemberQ[{"MaxSeedRuleCount", "MaxDiscreteRuleCount", "MaxEquationCount", "MaxShrinkSectorCount"}, key] := validNonNegativeIntegerQ[value];
validSeedOptionValueQ[_, _] := False;


validDiscreteReplacementRuleQ[rule_] := MatchQ[Unevaluated[rule], _Rule | _RuleDelayed];


sampleDiscreteRuleSetShapeIssue[ruleSet_, index_] := Module[{badRulePositions},
   If[! ListQ[ruleSet],
    Return[<|"ruleSetIndex" -> index, "reason" -> "each sample entry must be a list of replacement rules", "entry" -> ruleSet|>]
    ];
   badRulePositions = Flatten @ Position[ruleSet, rule_ /; ! validDiscreteReplacementRuleQ[rule], {1}, Heads -> False];
   If[badRulePositions === {},
    Nothing,
    <|"ruleSetIndex" -> index, "badRulePositions" -> badRulePositions, "entry" -> ruleSet|>
    ]
   ];


sampleDiscreteRulesShapeIssues[rules_] := Module[{badEntries},
   If[! ListQ[rules],
    Return[{<|"reason" -> "sampleDiscreteRules must be a list of replacement-rule lists", "value" -> rules|>}]
    ];
   badEntries = DeleteCases[
     MapIndexed[sampleDiscreteRuleSetShapeIssue[#1, First[#2]] &, rules],
     Nothing
     ];
   badEntries
   ];


sampleDiscreteRulePairs[rules_] := Cases[
   rules,
   (Verbatim[Rule] | Verbatim[RuleDelayed])[lhs_, rhs_] :> {lhs, rhs},
   {0, Infinity}
   ];


caseInputMalformedIssues[case_Association] := Module[
   {issues = {}, vertexData, lineData, loopMomenta, externalMomenta, ispData, seedRanges, generatorSeedRanges, seedOptions, badVertexPositions,
    badLineShapePositions, lineMissingKeyData, badEndpointData, badISPShapePositions, ispMissingKeyData,
    sampleDiscreteRules, sampleRuleShapeIssues, generatorRangeShapeIssues, symmetryRules, badSymmetryRulePositions},
   If[KeyExistsQ[case, "vertexData"],
    vertexData = case["vertexData"];
    If[! ListQ[vertexData],
     AppendTo[issues, <|"severity" -> "error", "code" -> "malformedVertexData", "reason" -> "vertexData must be a list of {id, sign} entries"|>],
     badVertexPositions = Flatten @ Position[vertexData, entry_ /; ! validVertexEntryQ[entry], {1}, Heads -> False];
     If[badVertexPositions =!= {},
      AppendTo[issues, <|"severity" -> "error", "code" -> "malformedVertexData", "badPositions" -> badVertexPositions|>]
      ]
     ]
    ];
   If[KeyExistsQ[case, "lineData"],
    lineData = case["lineData"];
    If[! ListQ[lineData],
     AppendTo[issues, <|"severity" -> "error", "code" -> "malformedLineData", "reason" -> "lineData must be a list of line associations or {id,endpoints,momentum,nu,bbType} entries"|>],
     badLineShapePositions = Flatten @ Position[lineData, entry_ /; ! validLineEntryShapeQ[entry], {1}, Heads -> False];
     If[badLineShapePositions =!= {},
      AppendTo[issues, <|"severity" -> "error", "code" -> "malformedLineData", "badPositions" -> badLineShapePositions|>]
      ];
     lineMissingKeyData = DeleteCases[
       MapIndexed[
        If[AssociationQ[#1] && lineEntryAssociationMissingKeys[#1] =!= {},
          <|"linePosition" -> First[#2], "missingKeys" -> lineEntryAssociationMissingKeys[#1]|>,
          Nothing
          ] &,
        lineData
        ],
       Nothing
       ];
     If[lineMissingKeyData =!= {},
      AppendTo[issues, <|"severity" -> "error", "code" -> "lineDataMissingRequiredKeys", "lines" -> lineMissingKeyData|>]
      ];
     badEndpointData = DeleteCases[
       MapIndexed[
        If[validLineEntryShapeQ[#1] && lineEntryAssociationMissingKeys[#1] === {} && ! validEndpointPairQ[lineEntryEndpointValue[#1]],
          <|"linePosition" -> First[#2], "endpoints" -> lineEntryEndpointValue[#1]|>,
          Nothing
          ] &,
        lineData
        ],
       Nothing
       ];
     If[badEndpointData =!= {},
      AppendTo[issues, <|"severity" -> "error", "code" -> "malformedLineEndpoints", "lines" -> badEndpointData|>]
      ]
     ]
    ];
   If[KeyExistsQ[case, "loopMomenta"],
    loopMomenta = case["loopMomenta"];
    If[! ListQ[loopMomenta],
     AppendTo[issues, <|"severity" -> "error", "code" -> "malformedLoopMomenta", "reason" -> "loopMomenta must be a list"|>]
     ]
    ];
   If[KeyExistsQ[case, "externalMomenta"],
    externalMomenta = case["externalMomenta"];
    If[! ListQ[externalMomenta],
     AppendTo[issues, <|"severity" -> "error", "code" -> "malformedExternalMomenta", "reason" -> "externalMomenta must be a list"|>]
     ]
    ];
   If[KeyExistsQ[case, "seedRanges"],
    seedRanges = case["seedRanges"];
    If[! AssociationQ[seedRanges],
     AppendTo[issues, <|"severity" -> "error", "code" -> "malformedSeedRanges", "reason" -> "seedRanges must be an Association"|>]
     ]
    ];
   If[KeyExistsQ[case, "generatorSeedRanges"],
    generatorSeedRanges = case["generatorSeedRanges"];
    generatorRangeShapeIssues = generatorSeedRangesShapeIssues[generatorSeedRanges];
    If[generatorRangeShapeIssues =!= {},
     AppendTo[issues, <|"severity" -> "error", "code" -> "malformedGeneratorSeedRanges", "issues" -> generatorRangeShapeIssues|>]
     ]
    ];
   If[KeyExistsQ[case, "seedOptions"],
    seedOptions = case["seedOptions"];
    If[! AssociationQ[seedOptions],
     AppendTo[issues, <|"severity" -> "error", "code" -> "malformedSeedOptions", "reason" -> "seedOptions must be an Association"|>]
     ]
    ];
   If[KeyExistsQ[case, "symmetryRules"],
    symmetryRules = case["symmetryRules"];
    If[! ListQ[symmetryRules],
     AppendTo[issues, <|"severity" -> "error", "code" -> "malformedSymmetryRules", "reason" -> "symmetryRules must be a list of Rule or RuleDelayed entries"|>],
     badSymmetryRulePositions = Flatten @ Position[
        symmetryRules,
        rule_ /; ! validDiscreteReplacementRuleQ[rule],
        {1},
        Heads -> False
        ];
     If[badSymmetryRulePositions =!= {},
      AppendTo[issues, <|"severity" -> "error", "code" -> "malformedSymmetryRules", "badPositions" -> badSymmetryRulePositions|>]
      ]
     ]
    ];
   If[KeyExistsQ[case, "ispData"],
    ispData = case["ispData"];
    If[! ListQ[ispData],
     AppendTo[issues, <|"severity" -> "error", "code" -> "malformedISPData", "reason" -> "ispData must be a list of ISP associations or {name,expr,range} entries"|>],
     badISPShapePositions = Flatten @ Position[ispData, entry_ /; ! validISPEntryShapeQ[entry], {1}, Heads -> False];
     If[badISPShapePositions =!= {},
      AppendTo[issues, <|"severity" -> "error", "code" -> "malformedISPData", "badPositions" -> badISPShapePositions|>]
      ];
     ispMissingKeyData = DeleteCases[
       MapIndexed[
        If[AssociationQ[#1] && ispEntryAssociationMissingKeys[#1] =!= {},
          <|"ispPosition" -> First[#2], "missingKeys" -> ispEntryAssociationMissingKeys[#1]|>,
          Nothing
          ] &,
        ispData
        ],
       Nothing
       ];
     If[ispMissingKeyData =!= {},
      AppendTo[issues, <|"severity" -> "error", "code" -> "ispDataMissingRequiredKeys", "isps" -> ispMissingKeyData|>]
      ]
     ]
     ];
    If[KeyExistsQ[case, "sampleDiscreteRules"],
     sampleDiscreteRules = case["sampleDiscreteRules"];
     sampleRuleShapeIssues = sampleDiscreteRulesShapeIssues[sampleDiscreteRules];
     If[sampleRuleShapeIssues =!= {},
      AppendTo[issues, <|"severity" -> "error", "code" -> "malformedSampleDiscreteRules", "issues" -> sampleRuleShapeIssues|>]
      ]
     ];
    issues
    ];


(* raw case 入口的轻量 preflight；避免缺必需字段时 parser 先抛底层 Part 消息。 *)
caseInputRequirementReport[case_Association] := Module[
   {keys = Keys[case], required = requiredCaseInputKeys[], optional = optionalCaseInputKeys[], malformedIssues},
   malformedIssues = caseInputMalformedIssues[case];
   <|
    "providedKeys" -> keys,
    "requiredKeys" -> required,
    "optionalKeys" -> optional,
    "missingRequiredKeys" -> Complement[required, keys],
    "unknownKeys" -> Complement[keys, Join[required, optional]],
    "malformedInputIssues" -> malformedIssues,
    "completeRequiredKeysQ" -> TrueQ[Complement[required, keys] === {}],
    "inputPreflightPassQ" -> TrueQ[Complement[required, keys] === {} && malformedIssues === {}]
    |>
   ];


caseInputErrorReport[case_Association] := Module[{report = caseInputRequirementReport[case]},
   With[{issues = Join[
       If[report["missingRequiredKeys"] === {}, {}, {<|"severity" -> "error", "code" -> "missingRequiredCaseKeys", "missingRequiredKeys" -> report["missingRequiredKeys"]|>}],
       report["malformedInputIssues"]
       ]},
   <|
    "status" -> If[issues === {}, "ok", "issues"],
    "errorCount" -> Length[issues],
    "warningCount" -> 0,
    "pendingCount" -> 0,
    "pendingFeatures" -> {},
    "inputRequirementReport" -> report,
    "issues" -> issues
    |>
    ]
   ];


caseInputMissingRequiredKeysQ[case_Association] := ! TrueQ[caseInputRequirementReport[case]["completeRequiredKeysQ"]];


caseInputPreflightErrorQ[case_Association] := ! TrueQ[caseInputRequirementReport[case]["inputPreflightPassQ"]];


seedPresetAssociation[preset_] := Switch[preset,
   "quickCheck" | Automatic | Missing["NotSet"],
   <|
    "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0}, "sampleOnly" -> True|>,
    "seedOptions" -> <|"DiscreteMode" -> "sample", "MaxSeedRuleCount" -> 200, "MaxDiscreteRuleCount" -> 64, "MaxEquationCount" -> 80, "MaxShrinkSectorDepth" -> Automatic, "MaxShrinkSectorCount" -> 16|>
    |>,
   "fullDiscrete",
   <|
    "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0}, "sampleOnly" -> True|>,
    "seedOptions" -> <|"DiscreteMode" -> "all", "MaxSeedRuleCount" -> 200, "MaxDiscreteRuleCount" -> 64, "MaxEquationCount" -> 200, "MaxShrinkSectorDepth" -> Automatic, "MaxShrinkSectorCount" -> 16|>
    |>,
   "bounded",
   <|
    "seedRanges" -> <|"a" -> {-1, 1}, "b" -> {-2, 2}, "isp" -> {0, 1}, "sampleOnly" -> False|>,
    "seedOptions" -> <|"DiscreteMode" -> "all", "MaxSeedRuleCount" -> 200, "MaxDiscreteRuleCount" -> 64, "MaxEquationCount" -> 200, "MaxShrinkSectorDepth" -> Automatic, "MaxShrinkSectorCount" -> 16|>
    |>,
   _,
   <|
    "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0}, "sampleOnly" -> True|>,
    "seedOptions" -> <|"DiscreteMode" -> "sample", "MaxSeedRuleCount" -> 200, "MaxDiscreteRuleCount" -> 64, "MaxEquationCount" -> 80, "MaxShrinkSectorDepth" -> Automatic, "MaxShrinkSectorCount" -> 16|>,
    "unknownPreset" -> preset
    |>
   ];


normalizeSeedConfig[case_Association] := Module[
   {preset = Lookup[case, "seedPreset", "quickCheck"], presetData, seedRanges, seedOptions},
   presetData = seedPresetAssociation[preset];
   seedRanges = Join[Lookup[presetData, "seedRanges", <||>], Lookup[case, "seedRanges", <||>]];
   seedOptions = Join[Lookup[presetData, "seedOptions", <||>], Lookup[case, "seedOptions", <||>]];
   <|
    "seedPreset" -> preset,
    "seedRanges" -> seedRanges,
    "seedOptions" -> seedOptions,
    "unknownSeedPreset" -> Lookup[presetData, "unknownPreset", None]
    |>
   ];


(* 由端点顶点的 +/- 标记推断 SK 类型。 *)
inferSKType[endpoints_, vertexSignAssoc_] := StringJoin[
   ToString[Lookup[vertexSignAssoc, endpoints[[1]], "+"]],
   ToString[Lookup[vertexSignAssoc, endpoints[[2]], "+"]]
   ];


(* packType 是后续统一 J 表示的核心分派键。massless 统一走双 theta 合并路线。 *)
inferPackType[massType_, skType_, state_] := Which[
   state === "shrunk", "shrunk",
   massType === "massive" && MemberQ[{"+-", "-+"}, skType], "massiveCross",
   massType === "massless" && MemberQ[{"++", "--"}, skType], "masslessFull",
   massType === "massless" && MemberQ[{"+-", "-+"}, skType], "masslessCross",
   True, "massiveFull"
   ];


(* ::Section:: *)
(*特殊函数系统编译*)

functionSystemZeroQ[expr_] := TrueQ[Quiet[FullSimplify[Together[expr] == 0]]];


functionSystemAdditiveTerms[expr_] := Module[{expanded = Expand[expr]},
   Which[
    functionSystemZeroQ[expanded], {},
    Head[expanded] === Plus, List @@ expanded,
    True, {expanded}
    ]
   ];


functionSystemMonomialData[term_, variable_] := Module[{factors, power, coefficient},
   factors = If[Head[term] === Times, List @@ term, {term}];
   power = Total[Replace[
      factors,
      {
       factor_ /; SameQ[factor, variable] :> 1,
       HoldPattern[Power[base_, exponent_]] /; SameQ[base, variable] :> exponent,
       _ -> 0
       },
      {1}
      ]];
   coefficient = Quiet[FullSimplify[term/variable^power]];
   If[FreeQ[coefficient, variable],
    <|"coefficient" -> coefficient, "xPower" -> power|>,
    Missing["NotFiniteLaurentMonomial", term]
    ]
   ];


compileDerivativeTerms[at_, variable_] := Catch[
   Module[{entries = {}, data, grouped},
    Do[
     Do[
      Do[
       data = functionSystemMonomialData[term, variable];
       If[Head[data] === Missing || ! IntegerQ[data["xPower"]], Throw[$Failed, derivativeCompileFailure]];
       AppendTo[entries, Join[
         <|"sourceState" -> i - 1, "targetState" -> j - 1|>,
         data
         ]],
       {term, functionSystemAdditiveTerms[at[[i, j]]]}
       ],
      {j, 2}
      ],
     {i, 2}
     ];
    grouped = GroupBy[entries, {#["sourceState"], #["targetState"], #["xPower"]} &];
    KeyValueMap[
     <|
       "sourceState" -> #1[[1]], "targetState" -> #1[[2]], "xPower" -> #1[[3]],
       "coefficient" -> Quiet[FullSimplify[Total[Lookup[#2, "coefficient"]]]]
       |> &,
     grouped
     ]
    ],
   derivativeCompileFailure
   ];


compileShrinkTerms[wt_, variable_, spec_Association] := Module[
   {rawTerms, data, powers, integerPowers, bShifts, zeroPointShifts, commonZeroPointShift},
   rawTerms = functionSystemAdditiveTerms[wt];
   If[rawTerms === {}, Return[$Failed]];
   data = functionSystemMonomialData[#, variable] & /@ rawTerms;
   If[AnyTrue[data, Head[#] === Missing &], Return[$Failed]];
   powers = Lookup[data, "xPower"];
   If[KeyExistsQ[spec, "shrinkBShift"] || KeyExistsQ[spec, "shrinkZeroPointShift"],
    If[Length[data] =!= 1 || ! KeyExistsQ[spec, "shrinkBShift"] || ! KeyExistsQ[spec, "shrinkZeroPointShift"], Return[$Failed]];
    bShifts = {spec["shrinkBShift"]};
    zeroPointShifts = {spec["shrinkZeroPointShift"]},
    integerPowers = Quiet[FullSimplify[# /. Thread[Variables[{#}] -> 0]]] & /@ powers;
    If[AnyTrue[integerPowers, ! IntegerQ[#] &], Return[$Failed]];
    bShifts = -integerPowers;
    zeroPointShifts = MapThread[Quiet[FullSimplify[-#1 - #2]] &, {powers, bShifts}]
    ];
   If[AnyTrue[bShifts, ! IntegerQ[#] &], Return[$Failed]];
   commonZeroPointShift = First[zeroPointShifts];
   If[AnyTrue[Rest[zeroPointShifts], ! functionSystemZeroQ[# - commonZeroPointShift] &], Return[$Failed]];
   <|
    "terms" -> MapThread[
      Join[#1, <|"coefficient" -> -#1["coefficient"], "bShift" -> #2, "zeroPointShift" -> #3|>] &,
      {data, bShifts, zeroPointShifts}
      ],
    "zeroPointShift" -> commonZeroPointShift
    |>
   ];


functionSystemPreset[preset_String, line_Association] := Module[
   {variable = x, nuValue = Lookup[line, "nu", nu], prefactor},
   prefactor = Lookup[line, "shrinkPrefactor", (4 I/Pi) Exp[Pi Im[nuValue]]];
   Switch[preset,
    "h",
    <|
     "preset" -> "h", "variable" -> variable,
     "P" -> (2 nuValue + 1)/variable, "Q" -> 1,
     "T" -> IdentityMatrix[2],
     "W" -> -prefactor variable^(-2 nuValue - 1), "WT" -> Automatic,
     "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 2 nuValue
     |>,
    "H",
    <|
     "preset" -> "H", "variable" -> variable,
     "P" -> 1/variable, "Q" -> 1 - nuValue^2/variable^2,
     "T" -> IdentityMatrix[2],
     "W" -> -prefactor/variable, "WT" -> Automatic,
     "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 0
     |>,
    _,
    Missing["UnknownFunctionSystemPreset", preset]
    ]
   ];


legacyFunctionSystem[line_Association, coefficients_List] := Module[
   {variable = x, c1, c2, prefactor},
   {c1, c2} = coefficients[[1 ;; 2]];
   prefactor = Lookup[line, "shrinkPrefactor", (4 I/Pi) Exp[Pi Im[Lookup[line, "nu", nu]]]];
   <|
    "preset" -> "legacyEOMCoefficients", "variable" -> variable,
    "P" -> c1/variable, "Q" -> c2, "T" -> IdentityMatrix[2],
    "W" -> -prefactor variable^(-c1), "WT" -> Automatic,
    "shrinkBShift" -> 1, "shrinkZeroPointShift" -> c1 - 1
    |>
   ];


normalizeLineFunctionSystem[line_Association] := Module[{explicit, bbType, coefficients},
   explicit = Lookup[line, "functionSystem", Automatic];
   bbType = Lookup[line, "bbType", "h"];
   Which[
    AssociationQ[explicit], explicit,
    MemberQ[{"h", "H"}, explicit], functionSystemPreset[explicit, line],
    explicit =!= Automatic, Missing["MalformedFunctionSystem", explicit],
    MemberQ[{"h", "H"}, bbType], functionSystemPreset[bbType, line],
    KeyExistsQ[line, "eomCoefficients"] && ListQ[line["eomCoefficients"]] && Length[line["eomCoefficients"]] >= 2,
    legacyFunctionSystem[line, line["eomCoefficients"]],
    ListQ[bbType] && Length[bbType] >= 2, legacyFunctionSystem[line, bbType],
    True, Missing["UnknownFunctionSystemPreset", bbType]
    ]
   ];


compileFunctionSystem[spec_Association] := Module[
   {required = {"P", "Q", "W"}, missing, variable, p, q, t, w, explicitWT, a0, at, wt,
    detT, derivativeTerms, shrinkData, issues = {}},
   missing = Complement[required, Keys[spec]];
   If[missing =!= {}, Return[<|"status" -> "invalid", "issues" -> {<|"code" -> "missingFunctionSystemKeys", "missingKeys" -> missing|>}|>]];
   variable = Lookup[spec, "variable", x];
   p = spec["P"];
   q = spec["Q"];
   t = Replace[Lookup[spec, "T", Automatic], Automatic -> IdentityMatrix[2]];
   w = spec["W"];
   explicitWT = Lookup[spec, "WT", Automatic];
   If[! MatrixQ[t] || Dimensions[t] =!= {2, 2},
    Return[<|"status" -> "invalid", "issues" -> {<|"code" -> "functionSystemTNot2x2", "T" -> t|>}|>]
    ];
   detT = Quiet[FullSimplify[Det[t]]];
   If[functionSystemZeroQ[detT],
    Return[<|"status" -> "invalid", "issues" -> {<|"code" -> "functionSystemTSingular", "T" -> t|>}|>]
    ];
   a0 = {{0, 1}, {-q, -p}};
   at = Quiet[FullSimplify[D[t, variable].Inverse[t] + t.a0.Inverse[t]]];
   wt = Quiet[FullSimplify[detT w]];
   If[! functionSystemZeroQ[D[w, variable] + p w],
    AppendTo[issues, <|"code" -> "functionSystemWInconsistent", "residual" -> Quiet[FullSimplify[D[w, variable] + p w]]|>]
    ];
   If[explicitWT =!= Automatic && ! functionSystemZeroQ[explicitWT - wt],
    AppendTo[issues, <|"code" -> "functionSystemWTInconsistent", "expectedWT" -> wt, "providedWT" -> explicitWT|>]
    ];
   If[! functionSystemZeroQ[D[wt, variable]/wt - Tr[at]],
    AppendTo[issues, <|"code" -> "functionSystemTraceInconsistent", "residual" -> Quiet[FullSimplify[D[wt, variable]/wt - Tr[at]]]|>]
    ];
   derivativeTerms = compileDerivativeTerms[at, variable];
   If[derivativeTerms === $Failed,
    AppendTo[issues, <|"code" -> "functionSystemDerivativeNotFiniteLaurent", "AT" -> at|>]
    ];
   shrinkData = compileShrinkTerms[wt, variable, spec];
   If[shrinkData === $Failed,
    AppendTo[issues, <|"code" -> "functionSystemWTNotFiniteCompatibleLaurent", "WT" -> wt|>]
    ];
   If[issues =!= {}, Return[<|"status" -> "invalid", "issues" -> issues|>]];
   <|
    "status" -> "compiled", "input" -> Join[spec, <|"variable" -> variable, "T" -> t|>],
    "variable" -> variable, "P" -> p, "Q" -> q, "T" -> t, "W" -> w,
    "A0" -> a0, "AT" -> at, "WT" -> wt,
    "derivativeTerms" -> derivativeTerms,
    "shrinkTerms" -> shrinkData["terms"],
    "shrinkZeroPointShift" -> shrinkData["zeroPointShift"]
    |>
   ];


compileFunctionSystem[data_Association] /; KeyExistsQ[data, "endpoints"] := Module[{spec = normalizeLineFunctionSystem[data]},
   If[Head[spec] === Missing,
    <|"status" -> "invalid", "issues" -> {<|"code" -> "invalidLineFunctionSystem", "value" -> spec|>}|>,
    compileFunctionSystem[spec]
    ]
   ];


(* 补齐每条线的默认 metadata。thetaConvention 固定为 mergedTwoTheta。
   endpoints 是有序输入；对 masslessFull，第一端点定义单 n=1 的反对称方向。 *)
completeLineMetadata[line_, vertexSignAssoc_] := Module[
   {endpoints, referenceEndpoints, massType, skType, state, packType, metadata, functionSpec, compiled},
   endpoints = line["endpoints"];
   referenceEndpoints = Lookup[line, "originalEndpoints", endpoints];
   massType = Lookup[line, "massType", "massive"];
   skType = Lookup[line, "skType", inferSKType[endpoints, vertexSignAssoc]];
   state = Lookup[line, "state", "full"];
   packType = Lookup[line, "packType", inferPackType[massType, skType, state]];
   metadata = Join[
     line,
    <|
     "massType" -> massType,
     "skType" -> skType,
     "state" -> state,
     "thetaConvention" -> "mergedTwoTheta",
     "packType" -> packType,
     "masslessN1ReferenceEndpoint" -> If[packType === "masslessFull", referenceEndpoints[[1]], Missing["NotApplicable"]],
     "masslessN1OppositeEndpoint" -> If[packType === "masslessFull", referenceEndpoints[[2]], Missing["NotApplicable"]]
      |>
     ];
   If[massType =!= "massive", Return[metadata]];
   functionSpec = normalizeLineFunctionSystem[metadata];
   compiled = If[Head[functionSpec] === Missing,
     <|"status" -> "invalid", "issues" -> {<|"code" -> "invalidLineFunctionSystem", "value" -> functionSpec|>}|>,
     compileFunctionSystem[functionSpec]
     ];
   Join[metadata, <|
     "functionSystem" -> Lookup[compiled, "input", Lookup[metadata, "functionSystem", Missing["InvalidFunctionSystem"]]],
     "compiledFunctionSystem" -> compiled
     |>]
   ];


(* 将一个 case 解析为通用拓扑对象。externalMomenta 必须给出独立外动量基。 *)
parseTopology::missingkeys = "case 缺少必需字段：`1`。";
parseTopology::badinput = "case 输入 preflight 失败：`1`。";
parseTopology::badfunction = "massive line 的函数系统编译失败：`1`。";


parseTopology[case_Association] := Module[
   {vertexData, vertexIds, vertexSignAssoc, rawLines, lines, badFunctionLines, loopMomenta,
   externalMomenta, rawExternalInvariantRules, externalInvariantRules, externalLegMomenta,
    rawExternalLegInvariantRules, externalLegInvariantRules, kinematicRules, kinematicAudit,
    ispData, nV, nE, nL, nK, bMatrix, vertexLines,
    eMomenta, loopCoeffMatrix, externalCoeffMatrix, externalPartList, seedConfig, topoContext},
   If[caseInputPreflightErrorQ[case],
    If[caseInputMissingRequiredKeysQ[case],
     Message[parseTopology::missingkeys, caseInputRequirementReport[case]["missingRequiredKeys"]],
     Message[parseTopology::badinput, Lookup[caseInputErrorReport[case], "issues", {}]]
     ];
    Return[$Failed]
    ];
   vertexData = case["vertexData"];
   vertexIds = vertexData[[All, 1]];
   vertexSignAssoc = Association[Rule @@@ vertexData];
   rawLines = normalizeLine /@ case["lineData"];
   lines = completeLineMetadata[#, vertexSignAssoc] & /@ rawLines;
   badFunctionLines = Select[
     MapIndexed[Join[<|"lineIndex" -> First[#2], "lineId" -> Lookup[#1, "id", Missing["NoLineId"]]|>, Lookup[#1, "compiledFunctionSystem", <||>]] &, lines],
     KeyExistsQ[#, "status"] && #["status"] =!= "compiled" &
     ];
   If[badFunctionLines =!= {},
    Message[parseTopology::badfunction, Lookup[badFunctionLines, {"lineIndex", "lineId", "issues"}]];
    Return[$Failed]
    ];
   loopMomenta = case["loopMomenta"];
   externalMomenta = Lookup[case, "externalMomenta", {}];
   externalLegMomenta = Lookup[case, "externalLegMomenta", {}];
   ispData = normalizeISP /@ Lookup[case, "ispData", {}];
   nV = Length[vertexIds];
   nE = Length[lines];
   nL = Length[loopMomenta];
   nK = Length[externalMomenta];
   eMomenta = Lookup[lines, "momentum"];
   bMatrix = Table[
     Which[
      lines[[e]]["endpoints"][[1]] === vertexIds[[v]], 1,
      lines[[e]]["endpoints"][[2]] === vertexIds[[v]], -1,
      True, 0
      ],
     {v, nV}, {e, nE}
     ];
   vertexLines = Table[
     Select[Table[{e, bMatrix[[v, e]]}, {e, nE}], #[[2]] =!= 0 &],
     {v, nV}
     ];
   loopCoeffMatrix = Table[
     Coefficient[eMomenta[[e]], loopMomenta[[l]]],
     {e, nE}, {l, nL}
     ];
   externalCoeffMatrix = Table[
     Coefficient[eMomenta[[e]], externalMomenta[[j]]],
     {e, nE}, {j, nK}
     ];
   externalPartList = Table[
     eMomenta[[e]] - Sum[loopCoeffMatrix[[e, l]] loopMomenta[[l]], {l, nL}],
     {e, nE}
     ];
   topoContext = <|"loopMomenta" -> loopMomenta, "externalMomenta" -> externalMomenta,
     "externalLegMomenta" -> externalLegMomenta, "lines" -> lines,
     "vertexEnergies" -> Lookup[case, "vertexEnergies", <||>], "extLegs" -> Lookup[case, "extLegs", {}],
     "nL" -> nL, "nK" -> nK|>;
   kinematicRules = Lookup[case, "kinematicRules", Automatic];
   kinematicAudit = resolveKinematicRulesForCase[case, topoContext];
   rawExternalInvariantRules = Lookup[
     kinematicAudit,
     "rawLoopRules",
     Lookup[case, "rawExternalInvariantRules", Lookup[case, "externalInvariantRules", Automatic]]
     ];
   externalInvariantRules = Lookup[
     kinematicAudit,
     "resolvedLoopRules",
     normalizeExternalInvariantRulesForTopology[rawExternalInvariantRules, topoContext]
     ];
   rawExternalLegInvariantRules = Lookup[
     kinematicAudit,
     "rawExternalLegRules",
     Lookup[case, "rawExternalLegInvariantRules", Lookup[case, "externalLegInvariantRules", Automatic]]
     ];
   externalLegInvariantRules = Lookup[
     kinematicAudit,
     "resolvedExternalLegRules",
     normalizeExternalLegInvariantRulesForTopology[rawExternalLegInvariantRules, topoContext]
     ];
   topoContext = Join[topoContext, <|
      "externalInvariantRules" -> externalInvariantRules,
      "rawExternalLegInvariantRules" -> rawExternalLegInvariantRules,
      "externalLegInvariantRules" -> externalLegInvariantRules,
      "kinematicRules" -> kinematicRules,
      "kinematicCoordinateAudit" -> kinematicAudit
      |>];
   seedConfig = normalizeSeedConfig[case];
   <|
    "name" -> Lookup[case, "name", "unnamed"],
    "vertexData" -> vertexData,
    "vertexIds" -> vertexIds,
    "vertexSignAssoc" -> vertexSignAssoc,
    "lines" -> lines,
    "extLegs" -> Lookup[case, "extLegs", {}],
    "vertexEnergies" -> Lookup[case, "vertexEnergies", <||>],
    "activeVertexIds" -> Lookup[case, "activeVertexIds", vertexIds],
    "fixedAVertexValues" -> Lookup[case, "fixedAVertexValues", <||>],
    "loopMomenta" -> loopMomenta,
    "externalMomenta" -> externalMomenta,
    "externalLegMomenta" -> externalLegMomenta,
    "rawExternalInvariantRules" -> rawExternalInvariantRules,
    "externalInvariantRules" -> externalInvariantRules,
    "rawExternalLegInvariantRules" -> rawExternalLegInvariantRules,
    "externalLegInvariantRules" -> externalLegInvariantRules,
    "kinematicRules" -> kinematicRules,
    "kinematicCoordinateAudit" -> kinematicAudit,
    "ispData" -> ispData,
    "nV" -> nV,
    "nE" -> nE,
    "nL" -> nL,
    "nK" -> nK,
    "bMatrix" -> bMatrix,
    "vertexLines" -> vertexLines,
    "loopCoeffMatrix" -> loopCoeffMatrix,
    "externalCoeffMatrix" -> externalCoeffMatrix,
    "externalPartList" -> externalPartList,
    "rawNumericRules" -> Lookup[case, "rawNumericRules", Lookup[case, "numericRules", {}]],
    "numericRules" -> normalizeNumericRulesForTopology[Lookup[case, "rawNumericRules", Lookup[case, "numericRules", {}]], topoContext],
    "sampleDiscreteRules" -> Lookup[case, "sampleDiscreteRules", {}],
    "seedPreset" -> seedConfig["seedPreset"],
    "seedRanges" -> seedConfig["seedRanges"],
    "generatorSeedRanges" -> Lookup[case, "generatorSeedRanges", {}],
    "seedOptions" -> seedConfig["seedOptions"],
    "unknownSeedPreset" -> seedConfig["unknownSeedPreset"],
    "zeroPointRules" -> Lookup[case, "zeroPointRules", {}],
    "shrinkPrefactorRules" -> Lookup[case, "shrinkPrefactorRules", {}],
    "symmetryRules" -> Lookup[case, "symmetryRules", {}],
    "thetaBoundarySignOffset" -> Lookup[case, "thetaBoundarySignOffset", Automatic],
    "kiraOrdering" -> Lookup[case, "kiraOrdering", <||>],
    "sectorVertexRepresentativeMap" -> Lookup[case, "sectorVertexRepresentativeMap", AssociationThread[vertexIds -> vertexIds]]
    |>
   ];


(* ::Chapter:: *)
(*统一 J 指标包与离散态枚举*)

(* 本章实现 massive/massless 的自然指标打包。离散态按每条线 metadata 枚举，
   不再使用旧 bubble 原型中的 Tuples[{0,1}, 2 nE]。 *)


makeLinePack[line_Association] := Module[{id = line["id"]},
   Switch[line["packType"],
    "massiveFull", {b[id], n[id, 1], n[id, 2]},
    "massiveCross", {b[id], n[id, 1], n[id, 2]},
    "masslessFull", {b[id], n[id]},
    "masslessCross", {b[id]},
    "shrunk", {bS[id]},
    _, Message[makeLinePack::badtype, line["packType"], id]; $Failed
    ]
   ];
makeLinePack::badtype = "未知 packType `1`，line id = `2`。";


makeLinePacks[topo_Association] := makeLinePack /@ topo["lines"];


makeBaseIntegral[topo_Association] := Module[
   {active = Lookup[topo, "activeVertexIds", topo["vertexIds"]], fixedA = Lookup[topo, "fixedAVertexValues", <||>]},
   J[
    Table[If[AssociationQ[fixedA] && KeyExistsQ[fixedA, v], fixedA[v], a[v]], {v, active}],
    makeLinePacks[topo],
    Table[ispN[j], {j, Length[topo["ispData"]]}]
    ]
   ];


makeSectorMetadata[topo_Association] := Module[
   {fixedA = Lookup[topo, "fixedAVertexValues", <||>], active = Lookup[topo, "activeVertexIds", topo["vertexIds"]],
    lines = topo["lines"], vertexIds = topo["vertexIds"], repMap, originalSlotByVertex, compactSlotByVertex,
    activeOriginalGroups, vertexSlots, compactASlots, lineSlots},
   repMap = Lookup[topo, "sectorVertexRepresentativeMap", AssociationThread[topo["vertexIds"] -> topo["vertexIds"]]];
   originalSlotByVertex = AssociationThread[vertexIds -> Range[Length[vertexIds]]];
   activeOriginalGroups = Table[
     v -> Select[vertexIds, Lookup[repMap, #, #] === v &],
     {v, active}
     ];
   compactSlotByVertex = Association @ Flatten[
      Table[Thread[activeOriginalGroups[[i, 2]] -> i], {i, Length[activeOriginalGroups]}],
      1
      ];
   vertexSlots = Table[
     <|
      "slot" -> i,
      "vertexId" -> vertexIds[[i]],
      "representativeVertexId" -> Lookup[repMap, vertexIds[[i]], vertexIds[[i]]],
      "aSymbol" -> a[vertexIds[[i]]],
      "activeQ" -> MemberQ[active, vertexIds[[i]]],
      "fixedValue" -> If[AssociationQ[fixedA] && KeyExistsQ[fixedA, vertexIds[[i]]], fixedA[vertexIds[[i]]], None],
      "compactASlot" -> Lookup[compactSlotByVertex, vertexIds[[i]], None]
      |>,
     {i, Length[vertexIds]}
     ];
   compactASlots = Table[
     <|
      "compactSlot" -> i,
      "representativeVertexId" -> active[[i]],
      "originalVertexIds" -> activeOriginalGroups[[i, 2]],
      "originalSlots" -> Lookup[originalSlotByVertex, activeOriginalGroups[[i, 2]]],
      "aSymbol" -> a[active[[i]]]
      |>,
     {i, Length[active]}
     ];
   lineSlots = Table[
     With[{pack = makeLinePack[lines[[e]]], endpoints = lines[[e]]["endpoints"], originalEndpoints = Lookup[lines[[e]], "originalEndpoints", lines[[e]]["endpoints"]]},
      <|
       "slot" -> e,
       "lineId" -> lines[[e]]["id"],
       "packType" -> lines[[e]]["packType"],
       "massType" -> lines[[e]]["massType"],
       "state" -> lines[[e]]["state"],
       "endpoints" -> endpoints,
       "originalEndpoints" -> originalEndpoints,
       "masslessN1ReferenceEndpoint" -> Lookup[lines[[e]], "masslessN1ReferenceEndpoint", Missing["NotApplicable"]],
       "masslessN1OppositeEndpoint" -> Lookup[lines[[e]], "masslessN1OppositeEndpoint", Missing["NotApplicable"]],
       "endpointOriginalASlots" -> Lookup[originalSlotByVertex, originalEndpoints],
       "endpointCompactASlots" -> Lookup[compactSlotByVertex, endpoints, None],
       "bSymbol" -> pack[[1]],
       "packTemplate" -> pack
       |>
      ],
     {e, Length[lines]}
     ];
   <|
    "caseName" -> topo["name"],
    "sectorShrunkLines" -> Lookup[topo, "sectorShrunkLines", {}],
    "sectorKey" -> sectorKeyFromShrunkLines[Lookup[topo, "sectorShrunkLines", {}]],
    "aSlotMode" -> "compactActiveSlots",
    "sectorVertexRepresentativeMap" -> repMap,
    "vertexIdToOriginalASlot" -> originalSlotByVertex,
    "vertexIdToCompactASlot" -> compactSlotByVertex,
    "vertexSlots" -> vertexSlots,
    "compactASlots" -> compactASlots,
    "activeASlots" -> Range[Length[active]],
    "lineSlots" -> lineSlots,
    "lineIdToSlot" -> AssociationThread[Lookup[lines, "id"] -> Range[Length[lines]]],
    "bSymbolToLineSlot" -> AssociationThread[lineSlots[[All, "bSymbol"]] -> Range[Length[lineSlots]]],
    "ispSlots" -> Table[
      <|"slot" -> j, "indexSymbol" -> ispN[j], "data" -> topo["ispData"][[j]]|>,
      {j, Length[topo["ispData"]]}
      ]
    |>
   ];


sectorKeyFromShrunkLines[shrunkLines_List] := If[shrunkLines === {}, "top", StringRiffle["e" <> ToString[#] & /@ shrunkLines, "_"]];


sectorMetadataKey[metadata_Association] := Lookup[metadata, "sectorKey", sectorKeyFromShrunkLines[Lookup[metadata, "sectorShrunkLines", {}]]];


sectorMetadataLinePackLengths[metadata_Association] := Length /@ Lookup[Lookup[metadata, "lineSlots", {}], "packTemplate", {}];


parsedTopologyQ[spec_Association] := TrueQ[KeyExistsQ[spec, "lines"] && KeyExistsQ[spec, "nL"]];
parsedTopologyQ[_] := False;


normalizeTopologySpec[spec_Association] := If[parsedTopologyQ[spec], spec, parseTopology[spec]];
normalizeTopologySpec[spec_] := spec;


indexContainsLineSymbolQ[index_, symbol_] := ! FreeQ[index, symbol];


indexHasAnyLineSymbolQ[index_] := ! FreeQ[index, _b | _bS];


linePackMatchesSlotQ[pack_List, slot_Association] := Module[
   {template = Lookup[slot, "packTemplate", {}], bSymbol = Lookup[slot, "bSymbol", Missing["bSymbol"]]},
   TrueQ[Length[pack] === Length[template]] &&
    TrueQ[
     Head[bSymbol] === Missing ||
      indexContainsLineSymbolQ[First[pack], bSymbol] ||
      ! indexHasAnyLineSymbolQ[First[pack]]
     ]
   ];


integralMatchesSectorMetadataQ[J[aList_, linePacks_, ispList_], metadata_Association] := Module[
   {lineSlots = Lookup[metadata, "lineSlots", {}], compactASlots = Lookup[metadata, "compactASlots", {}], ispSlots = Lookup[metadata, "ispSlots", {}]},
   TrueQ[
    Length[aList] === Length[compactASlots] &&
     Length[linePacks] === Length[lineSlots] &&
     Length[ispList] === Length[ispSlots] &&
     And @@ MapThread[linePackMatchesSlotQ, {linePacks, lineSlots}]
    ]
   ];


integralSectorKey[J[aList_, linePacks_, ispList_], metadataList_List] := Module[
   {matches},
   matches = Select[metadataList, integralMatchesSectorMetadataQ[J[aList, linePacks, ispList], #] &];
   Which[
    Length[matches] == 1, sectorMetadataKey[First[matches]],
    Length[matches] == 0, Missing["NoMatchingSector"],
    True, Missing["AmbiguousSector", sectorMetadataKey /@ matches]
    ]
   ];


batchSectorMetadataList[batch_Association, topoSpec_: Automatic] := Module[
   {fromBatch, topo, topMetadata},
   fromBatch = Lookup[batch, "sectorMetadataList", Missing["NoSectorMetadataList"]];
   If[ListQ[fromBatch], Return[fromBatch]];
   If[AssociationQ[Lookup[batch, "sectorMetadata", Missing["NoSectorMetadata"]]], Return[{batch["sectorMetadata"]}]];
   topo = normalizeTopologySpec[topoSpec];
   topMetadata = If[parsedTopologyQ[topo], makeSectorMetadata[topo], Missing["NoSectorMetadata"]];
   If[Head[topMetadata] === Missing, {}, {topMetadata}]
   ];


normaliseKiraOrderingSpec[spec_] := Which[
   AssociationQ[spec], spec,
   True, <||>
   ];


allowedKiraOrderingKeys[] := {"IntegralOrder", "ManualIntegralOrder", "PreferredIntegrals", "PreferredPriority", "SectorRank", "SectorOrder"};


validateKiraOrderingSpec[Automatic] := <|"status" -> "ok", "issues" -> {}|>;
validateKiraOrderingSpec[spec_] /; ! AssociationQ[spec] := <|"status" -> "invalidKiraOrdering", "reason" -> "KiraOrdering must be Automatic or an Association", "kiraOrdering" -> spec|>;
validateKiraOrderingSpec[spec_Association] := Module[
   {unknownKeys, badValueData},
   unknownKeys = Complement[Keys[spec], allowedKiraOrderingKeys[]];
   badValueData = DeleteCases[
     {
      If[KeyExistsQ[spec, "IntegralOrder"] && ! ListQ[spec["IntegralOrder"]], <|"optionKey" -> "IntegralOrder", "optionValue" -> spec["IntegralOrder"]|>, Nothing],
      If[KeyExistsQ[spec, "ManualIntegralOrder"] && ! ListQ[spec["ManualIntegralOrder"]], <|"optionKey" -> "ManualIntegralOrder", "optionValue" -> spec["ManualIntegralOrder"]|>, Nothing],
      If[KeyExistsQ[spec, "PreferredIntegrals"] && ! ListQ[spec["PreferredIntegrals"]], <|"optionKey" -> "PreferredIntegrals", "optionValue" -> spec["PreferredIntegrals"]|>, Nothing],
      If[KeyExistsQ[spec, "PreferredPriority"] && ! MemberQ[{"BeforeB", "AfterB"}, spec["PreferredPriority"]], <|"optionKey" -> "PreferredPriority", "optionValue" -> spec["PreferredPriority"]|>, Nothing],
      If[KeyExistsQ[spec, "SectorRank"] && ! AssociationQ[spec["SectorRank"]], <|"optionKey" -> "SectorRank", "optionValue" -> spec["SectorRank"]|>, Nothing],
      If[KeyExistsQ[spec, "SectorOrder"] && ! ListQ[spec["SectorOrder"]], <|"optionKey" -> "SectorOrder", "optionValue" -> spec["SectorOrder"]|>, Nothing]
      },
     Nothing
     ];
   If[unknownKeys === {} && badValueData === {},
    <|"status" -> "ok", "issues" -> {}|>,
    <|"status" -> "invalidKiraOrdering", "reason" -> "KiraOrdering contains unknown keys or invalid values", "unknownKiraOrderingKeys" -> unknownKeys, "malformedKiraOrderingValues" -> badValueData, "allowedKiraOrderingKeys" -> allowedKiraOrderingKeys[]|>
    ]
   ];


resolveKiraOrderingSpec[batch_Association, topoSpec_, optSpec_] := Module[{topo, spec},
   topo = normalizeTopologySpec[topoSpec];
   spec = Which[
     optSpec =!= Automatic, optSpec,
     parsedTopologyQ[topo], Lookup[topo, "kiraOrdering", <||>],
     AssociationQ[Lookup[batch, "kiraOrdering", Missing["NoKiraOrdering"]]], batch["kiraOrdering"],
     True, <||>
     ];
   normaliseKiraOrderingSpec[spec]
   ];


preferredIntegralRank[int_, orderingSpec_Association] := Module[
   {manual = Lookup[orderingSpec, "IntegralOrder", Lookup[orderingSpec, "ManualIntegralOrder", {}]], preferred, pos},
   If[! ListQ[manual], manual = {}];
   preferred = DeleteDuplicates@Join[manual, Lookup[orderingSpec, "PreferredIntegrals", {}]];
   pos = FirstPosition[preferred, int, Missing["NotPreferred"], {1}, Heads -> False];
   If[Head[pos] === Missing, 10^9, First[pos] - 1]
   ];


sectorRankFromOrdering[sectorKey_, orderingSpec_Association] := Module[
   {rank = Lookup[orderingSpec, "SectorRank", <||>], order = Lookup[orderingSpec, "SectorOrder", {}], pos},
   Which[
    AssociationQ[rank] && KeyExistsQ[rank, sectorKey], rank[sectorKey],
    ListQ[order] && MemberQ[order, sectorKey], First[FirstPosition[order, sectorKey]] - 1,
    True, 0
    ]
   ];


numericIndexValue[x_Integer] := x;
numericIndexValue[x_Rational] := x;
numericIndexValue[x_Real] := x;
numericIndexValue[_] := 0;


integralSortKey[J[aList_, linePacks_, ispList_], orderingSpec_: <||>, metadataList_: {}] := Module[
   {int = J[aList, linePacks, ispList], spec = normaliseKiraOrderingSpec[orderingSpec], bValues, aValues, ispValues, nValues,
    preferredRank, sectorKey, sectorRank, baseKey, priority},
   bValues = numericIndexValue /@ linePacks[[All, 1]];
   aValues = numericIndexValue /@ aList;
   ispValues = numericIndexValue /@ ispList;
   nValues = numericIndexValue /@ Flatten[Rest /@ Select[linePacks, Length[#] > 1 &]];
   preferredRank = preferredIntegralRank[int, spec];
   sectorKey = integralSectorKey[int, metadataList];
   sectorRank = sectorRankFromOrdering[sectorKey, spec];
   baseKey = {
     Total[Abs /@ bValues],
     Total[Clip[bValues, {0, Infinity}]],
     Total[Abs /@ aValues],
     Total[Abs /@ ispValues],
     Total[nValues],
     sectorRank,
     ToString[InputForm[int]]
     };
   priority = Lookup[spec, "PreferredPriority", "AfterB"];
   If[priority === "BeforeB",
    Prepend[baseKey, preferredRank],
    Insert[baseKey, preferredRank, 3]
    ]
   ];


sortIntegralsForKira[integrals_List, orderingSpec_: <||>, metadataList_: {}] := SortBy[integrals, integralSortKey[#, orderingSpec, metadataList] &];


integralOrderItemToIntegral[item_, integrals_List] := Which[
   Head[item] === J && MemberQ[integrals, item], item,
   IntegerQ[item] && 1 <= item <= Length[integrals], integrals[[item]],
   True, Missing["UnknownIntegralOrderItem", item]
   ];


normaliseIntegralOrder[order_List, integrals_List] := DeleteDuplicates @ DeleteMissing[
    integralOrderItemToIntegral[#, integrals] & /@ order
    ];


missingIntegralOrderItems[order_List, integrals_List] := Cases[
   integralOrderItemToIntegral[#, integrals] & /@ order,
   Missing["UnknownIntegralOrderItem", item_] :> item
   ];


validateKiraIntegralOrderSpec[orderSpec_] := If[orderSpec === Automatic || ListQ[orderSpec],
   <|"status" -> "ok"|>,
   <|"status" -> "invalidKiraIntegralOrder", "reason" -> "KiraIntegralOrder must be Automatic or a list of integral IDs/J objects", "kiraIntegralOrder" -> orderSpec|>
   ];


kiraOrderingIntegralRequestList[orderingSpec_Association] := Module[
   {manual = Lookup[orderingSpec, "IntegralOrder", Lookup[orderingSpec, "ManualIntegralOrder", {}]],
    preferred = Lookup[orderingSpec, "PreferredIntegrals", {}]},
   If[! ListQ[manual], manual = {}];
   If[! ListQ[preferred], preferred = {}];
   DeleteDuplicates@Join[manual, preferred]
   ];


kiraOrderingMatchReport[orderingSpec_Association, integrals_List] := Module[
   {requested = kiraOrderingIntegralRequestList[orderingSpec], matched, missing},
   matched = normaliseIntegralOrder[requested, integrals];
   missing = DeleteDuplicates @ missingIntegralOrderItems[requested, integrals];
   <|
    "requestedIntegrals" -> requested,
    "matchedIntegrals" -> matched,
    "missingIntegralOrderItems" -> missing,
    "allRequestedIntegralsMatchedQ" -> TrueQ[missing === {}]
    |>
   ];


integralMetadataList[integrals_List, metadataList_List, orderingSpec_: <||>] := Table[
   <|
    "id" -> i,
    "sectorKey" -> integralSectorKey[integrals[[i]], metadataList],
    "sortKey" -> integralSortKey[integrals[[i]], orderingSpec, metadataList]
    |>,
   {i, Length[integrals]}
   ];




discreteVarsForLine[line_Association] := Module[{id = line["id"]},
   Switch[line["packType"],
    "massiveFull", {n[id, 1], n[id, 2]},
    "massiveCross", {n[id, 1], n[id, 2]},
    "masslessFull", {n[id]},
    _, {}
    ]
   ];


ruleSetsForVars[vars_List] := If[Length[vars] == 0,
   {{}},
   Thread[vars -> #] & /@ Tuples[{0, 1}, Length[vars]]
   ];


(* 输出为 {rules, integrals}，便于检查 seed 数和具体替换规则。 *)
enumerateDiscreteStates[expr_, topo_Association] := Module[
   {perLineRuleSets, allRuleSets},
   perLineRuleSets = ruleSetsForVars /@ (discreteVarsForLine /@ topo["lines"]);
   allRuleSets = Flatten[#, 1] & /@ Tuples[perLineRuleSets];
   <|
    "rules" -> allRuleSets,
    "integrals" -> (expr /. # & /@ allRuleSets)
    |>
   ];


(* 大拓扑下不要为了 summary 展开所有离散态；计数只用逐线状态数相乘。 *)
discreteStateCountForLine[line_Association] := Switch[line["packType"],
   "massiveFull", 4,
   "massiveCross", 4,
   "masslessFull", 2,
   _, 1
   ];


discreteStateCount[topo_Association] := Times @@ (discreteStateCountForLine /@ topo["lines"]);


(* 验证只看手选样本；若 case 未给 sampleDiscreteRules，则只保留未替换模板。 *)
sampleDiscreteIntegrals[expr_, topo_Association] := Module[{rules = topo["sampleDiscreteRules"]},
   If[Length[rules] == 0,
    {expr},
    expr /. # & /@ rules
    ]
   ];


(* sample 模式必须给出完整 n=0/1 替换；否则 seed 中会残留符号 n，无法保证即时 EOM。 *)
sampleDiscreteRuleCoverageIssues[topo_Association, rules_List] := Module[
   {vars = Flatten[discreteVarsForLine /@ topo["lines"]]},
   If[vars === {}, Return[{}]];
    DeleteCases[
     MapIndexed[
      Module[{pairs, ruleVars, missing},
        pairs = sampleDiscreteRulePairs[#1];
        ruleVars = If[pairs === {}, {}, DeleteDuplicates[pairs[[All, 1]]]];
        missing = Complement[vars, ruleVars];
        If[missing === {},
         Nothing,
         <|"ruleIndex" -> First[#2], "missingVariables" -> missing, "rule" -> #1|>
        ]
       ] &,
     rules
     ],
    Nothing
    ]
   ];


(* ::Chapter:: *)
(*EOM canonical 与 forbidden-n 扫描*)

(* 本章只处理已经出现在 J 指标中的 Hankel 二阶导数态。
   seed 生成时应先枚举 n=0/1；若生成元把 massiveFull 的端点 n 推到 2 或更高，
   这里立即用 EOM 递推回 n=0/1。massless 的 {b,n} 只有两个状态，不用 Hankel EOM。 *)

vertexPosition[topo_Association, vertexId_] := Module[{pos},
   pos = FirstPosition[topo["vertexIds"], vertexId, Missing["NotFound"]];
   If[Head[pos] === Missing, Missing["VertexNotFound", vertexId], First[pos]]
   ];


activeAVertexIds[topo_Association] := Lookup[topo, "activeVertexIds", topo["vertexIds"]];


vertexRepresentative[topo_Association, vertexId_] := Lookup[
   Lookup[topo, "sectorVertexRepresentativeMap", AssociationThread[topo["vertexIds"] -> topo["vertexIds"]]],
   vertexId,
   vertexId
   ];


vertexASlot[topo_Association, vertexId_] := Module[
   {rep = vertexRepresentative[topo, vertexId], pos},
   pos = FirstPosition[activeAVertexIds[topo], rep, Missing["NotActiveVertex"]];
   If[Head[pos] === Missing, Missing["ActiveVertexNotFound", vertexId, rep], First[pos]]
   ];


shiftVertexA[J[aList_, linePacks_, ispList_], topo_Association, vertexId_, delta_] := Module[
   {newAList = aList, pos},
   pos = vertexASlot[topo, vertexId];
   If[Head[pos] === Missing, Return[$Failed]];
   newAList[[pos]] = newAList[[pos]] + delta;
   J[newAList, linePacks, ispList]
   ];


shiftLinePackEntry[J[aList_, linePacks_, ispList_], e_Integer, packPos_Integer, delta_] := Module[
   {newLinePacks = linePacks},
   newLinePacks[[e, packPos]] = newLinePacks[[e, packPos]] + delta;
   J[aList, newLinePacks, ispList]
   ];


setLinePackEntry[J[aList_, linePacks_, ispList_], e_Integer, packPos_Integer, value_] := Module[
   {newLinePacks = linePacks},
   newLinePacks[[e, packPos]] = value;
   J[aList, newLinePacks, ispList]
   ];


actualLinePackType[topo_Association, e_Integer, pack_List] := Module[
   {declared = topo["lines"][[e]]["packType"]},
   If[Length[pack] === 1 && declared =!= "masslessCross",
    "shrunk",
    declared
    ]
   ];


lineCompiledFunctionSystem[line_Association] := Lookup[line, "compiledFunctionSystem", <||>];


lineDerivativeTerms[line_Association, sourceState_Integer] := Select[
   Lookup[lineCompiledFunctionSystem[line], "derivativeTerms", {}],
   Lookup[#, "sourceState", Missing["NoSourceState"]] === sourceState &
   ];


applyCompiledEOMTerm[topo_Association, int_J, e_Integer, endpointSlot_Integer, term_Association] := Module[
   {result, endpointVertex, xPower = term["xPower"]},
   endpointVertex = topo["lines"][[e, "endpoints", endpointSlot]];
   result = setLinePackEntry[int, e, endpointSlot + 1, term["targetState"]];
   result = shiftLineB[result, e, -xPower];
   result = shiftVertexA[result, topo, endpointVertex, xPower];
   term["coefficient"] result
   ];


massiveEOMTarget[topo_Association, J[aList_, linePacks_, ispList_]] := Module[
   {lines = topo["lines"], packType, pack, nValue, target = Missing["NoEOMTarget"]},
   Do[
    pack = linePacks[[e]];
    packType = actualLinePackType[topo, e, pack];
    If[MemberQ[{"massiveFull", "massiveCross"}, packType],
     Do[
      nValue = pack[[endpointSlot + 1]];
      If[IntegerQ[nValue] && nValue >= 2 && Head[target] === Missing,
       target = <|"lineIndex" -> e, "endpointSlot" -> endpointSlot, "nValue" -> nValue|>
       ],
      {endpointSlot, 2}
      ]
     ],
    {e, Length[lines]}
    ];
   target
   ];


eomReduceIntegralAt[topo_Association, int_J, target_Association] := Module[
   {e, endpointSlot, nValue, line, terms},
   e = target["lineIndex"];
   endpointSlot = target["endpointSlot"];
   nValue = target["nValue"];
   line = topo["lines"][[e]];
   If[nValue =!= 2, Return[int]];
   terms = lineDerivativeTerms[line, 1];
   If[terms === {}, Return[int]];
   Expand[Total[applyCompiledEOMTerm[topo, int, e, endpointSlot, #] & /@ terms]]
   ];


applyEOMToIntegral[topo_Association, int_J] := Module[{target},
   target = massiveEOMTarget[topo, int];
   If[Head[target] === Missing,
    int,
    applyEOM[eomReduceIntegralAt[topo, int, target], topo]
    ]
   ];


applyEOM[expr_, topo_Association] := Expand[expr /. int_J :> applyEOMToIntegral[topo, int]];


(* masslessFull 的单 n 只允许 0/1。它以 line endpoints 的第一端点定义方向，
   所有导数直接在 0/1 间翻转；不再用有歧义的临时 n=2 混写 {20} 与 {11}。
   若其它缩并使该线两端点重合，反对称态 n=1 在等时点恒为零。 *)
integralShrunkLineIndices[
   topo_Association,
   J[aList_, linePacks_, ispList_]
   ] := Select[
   Range[Length[topo["lines"]]],
   actualLinePackType[topo, #, linePacks[[#]]] === "shrunk" &
   ];


integralTargetVertexRepresentativeMap[
   topo_Association,
   int_J
   ] := Module[
   {shrunkLines, originalPairs},
   shrunkLines = integralShrunkLineIndices[topo, int];
   originalPairs = Lookup[
       topo["lines"][[#]],
       "originalEndpoints",
       topo["lines"][[#, "endpoints"]]
       ] & /@ shrunkLines;
   vertexRepresentativeMap[topo["vertexIds"], originalPairs]
   ];


(* J 中的 shrunk packs 决定目标 sector；不能只读取 source topology 的当前 endpoints。 *)
masslessCoincidentAntisymmetricIntegralQ[
   topo_Association,
   int : J[aList_, linePacks_, ispList_]
   ] := Module[
   {lines = topo["lines"], repMap},
   repMap = integralTargetVertexRepresentativeMap[topo, int];
   AnyTrue[
    Range[Length[lines]],
    Function[e,
     Module[{originalEndpoints, targetEndpoints},
      originalEndpoints = Lookup[
        lines[[e]],
        "originalEndpoints",
        lines[[e]]["endpoints"]
        ];
      targetEndpoints = Lookup[repMap, originalEndpoints];
      actualLinePackType[topo, e, linePacks[[e]]] === "masslessFull" &&
       SameQ @@ targetEndpoints &&
       linePacks[[e, 2]] === 1
      ]
     ]
    ]
   ];


applyMasslessEndpointCanonical[expr_, topo_Association] := Expand[
   expr /. (int_J /; masslessCoincidentAntisymmetricIntegralQ[topo, int]) :> 0
   ];


canonicalizeMassiveCoincidentIntegral[
   topo_Association,
   int : J[aList_, linePacks_, ispList_]
   ] := Module[{lines = topo["lines"], repMap, newPacks = linePacks, originalEndpoints, targetEndpoints},
   repMap = integralTargetVertexRepresentativeMap[topo, int];
   Do[
    originalEndpoints = Lookup[lines[[e]], "originalEndpoints", lines[[e]]["endpoints"]];
    targetEndpoints = Lookup[repMap, originalEndpoints];
    If[
     actualLinePackType[topo, e, linePacks[[e]]] === "massiveFull" &&
      SameQ @@ targetEndpoints &&
      linePacks[[e, {2, 3}]] === {1, 0},
     newPacks[[e, {2, 3}]] = linePacks[[e, {3, 2}]]
     ],
    {e, Length[lines]}
    ];
   J[aList, newPacks, ispList]
   ];


applyMassiveCoincidentCanonical[expr_, topo_Association] := Expand[
   expr /. int_J :> canonicalizeMassiveCoincidentIntegral[topo, int]
   ];


applySeedCanonical[expr_, topo_Association] :=
  symmetry[
   applyMasslessEndpointCanonical[
    applyMassiveCoincidentCanonical[applyEOM[expr, topo], topo],
    topo
    ],
   topo
   ];


forbiddenNDataForIntegral[topo_Association, J[aList_, linePacks_, ispList_]] := Module[
   {lines = topo["lines"], issues = {}, packType, pack},
   Do[
    pack = linePacks[[e]];
    packType = actualLinePackType[topo, e, pack];
    Switch[packType,
     "massiveFull",
     Do[
      If[IntegerQ[pack[[endpointSlot + 1]]] && pack[[endpointSlot + 1]] >= 2,
       AppendTo[issues, <|"lineIndex" -> e, "packType" -> packType, "endpointSlot" -> endpointSlot, "nValue" -> pack[[endpointSlot + 1]]|>]
       ],
     {endpointSlot, 2}
     ],
     "masslessFull",
     If[Length[pack] >= 2 && IntegerQ[pack[[2]]] && ! MemberQ[{0, 1}, pack[[2]]],
      AppendTo[issues, <|"lineIndex" -> e, "packType" -> packType, "nValue" -> pack[[2]]|>]
      ],
     "massiveCross",
     Do[
      If[IntegerQ[pack[[endpointSlot + 1]]] && pack[[endpointSlot + 1]] >= 2,
       AppendTo[issues, <|"lineIndex" -> e, "packType" -> packType, "endpointSlot" -> endpointSlot, "nValue" -> pack[[endpointSlot + 1]]|>]
       ],
      {endpointSlot, 2}
      ],
     _, Null
     ],
    {e, Length[lines]}
    ];
   issues
   ];


forbiddenNData[topo_Association, expr_] := DeleteCases[
   Flatten[forbiddenNDataForIntegral[topo, #] & /@ DeleteDuplicates[Cases[expr, _J, {0, Infinity}]]],
   Null
   ];


containsForbiddenNQ[topo_Association, expr_] := Length[forbiddenNData[topo, expr]] > 0;


assertNoForbiddenN::badn = "表达式仍含 forbidden n 指标：`1`。";
assertNoForbiddenN[expr_, topo_Association] := Module[{bad = forbiddenNData[topo, expr]},
   If[bad === {}, expr, Message[assertNoForbiddenN::badn, bad]; $Failed]
   ];

(* ::Chapter:: *)
(*用户输入的积分族对称性*)

(* sp 的 Orderless 只处理标量积交换性；本章只应用用户确认物理条件后的积分族规则。 *)
repSymmetry0[topo_Association] := Lookup[topo, "symmetryRules", {}];


symmetry::badrules = "symmetryRules 必须是 Rule/RuleDelayed 的列表。";


(* tadpole symmetry 只识别可由单个 loop momentum reversal 证明的 self-loop。*)
tadpoleLoopReversalData[topo_Association] := Module[
   {loops = Lookup[topo, "loopMomenta", {}], lines = Lookup[topo, "lines", {}], candidates, momentum, endpoints, loopIndex, exclusiveLoopQ, data = {}},
   Do[
    endpoints = Lookup[lines[[e]], "originalEndpoints", Lookup[lines[[e]], "endpoints", {}]];
    If[SameQ @@ endpoints,
     momentum = Expand[Lookup[lines[[e]], "momentum", 0]];
     candidates = Select[
       Range[Length[loops]],
       Function[l,
        With[{coefficient = Coefficient[momentum, loops[[l]]]},
         coefficient =!= 0 && Expand[momentum - coefficient loops[[l]]] === 0
         ]
        ]
       ];
     If[Length[candidates] === 1,
      loopIndex = First[candidates];
      exclusiveLoopQ = And @@ Table[
         otherLine === e || Coefficient[Expand[Lookup[lines[[otherLine]], "momentum", 0]], loops[[loopIndex]]] === 0,
         {otherLine, Length[lines]}
         ];
      AppendTo[data, <|
        "lineIndex" -> e,
        "lineId" -> Lookup[lines[[e]], "id", e],
        "packType" -> Lookup[lines[[e]], "packType", Missing["packType"]],
        "endpoints" -> endpoints,
        "loopIndex" -> loopIndex,
        "loopMomentum" -> loops[[loopIndex]],
        "exclusiveLoopQ" -> exclusiveLoopQ
        |>]
      ]
     ],
    {e, Length[lines]}
    ];
   data
   ];


reverseLoopScalarProductExpr[expr_, loopIndex_Integer] := Expand[
   expr /. {
     HoldPattern[qq[i_Integer, j_Integer]] :> (-1)^Count[{i, j}, loopIndex] qq[i, j],
     HoldPattern[qk[i_Integer, j_Integer]] :> (-1)^Count[{i}, loopIndex] qk[i, j]
     }
   ];


tadpoleISPParity[topo_Association, loopIndex_Integer, ispIndex_Integer] := Module[
   {exprs = normalizeISPExprs[topo], expr, reversed},
   If[ispIndex < 1 || ispIndex > Length[exprs], Return[0]];
   expr = exprs[[ispIndex]];
   reversed = reverseLoopScalarProductExpr[expr, loopIndex];
   Which[
    Expand[reversed - expr] === 0, 1,
    Expand[reversed + expr] === 0, -1,
    True, 0
    ]
   ];


tadpoleOddISPIntegralQ[topo_Association, J[_, _, ispList_]] := Module[{loopData, oddPowers},
   loopData = Select[
     tadpoleLoopReversalData[topo],
     MemberQ[{"massiveFull", "masslessFull"}, #["packType"]] && TrueQ[#["exclusiveLoopQ"]] &
     ];
   AnyTrue[
    loopData,
    Function[data,
     oddPowers = Select[
       Table[
        If[tadpoleISPParity[topo, data["loopIndex"], j] === -1, ispList[[j]], Nothing],
        {j, Length[ispList]}
        ],
       IntegerQ
       ];
     oddPowers =!= {} && And @@ (IntegerQ /@ oddPowers) && OddQ[Total[oddPowers]]
     ]
    ]
   ];


tadpoleMassiveSwapNeededQ[topo_Association, lineIndex_Integer, J[_, linePacks_, _]] :=
  lineIndex <= Length[linePacks] &&
   Lookup[topo["lines"][[lineIndex]], "packType", Missing["packType"]] === "massiveFull" &&
   Length[linePacks[[lineIndex]]] >= 3 && linePacks[[lineIndex, {2, 3}]] === {1, 0};


tadpoleMasslessZeroQ[topo_Association, lineIndex_Integer, J[_, linePacks_, _]] :=
  lineIndex <= Length[linePacks] &&
   Lookup[topo["lines"][[lineIndex]], "packType", Missing["packType"]] === "masslessFull" &&
   Length[linePacks[[lineIndex]]] >= 2 && linePacks[[lineIndex, 2]] === 1;


tadpoleSwapLinePack[J[aList_, linePacks_, ispList_], lineIndex_Integer] := Module[
   {newPacks = linePacks},
   newPacks[[lineIndex, {2, 3}]] = newPacks[[lineIndex, {3, 2}]];
   J[aList, newPacks, ispList]
   ];


tadpoleSymmetryRules0[topo_Association] := Module[{data, rules = {}},
   data = tadpoleLoopReversalData[topo];
   AppendTo[rules,
    HoldPattern[(int_J /; tadpoleOddISPIntegralQ[topo, int])] :> 0
    ];
   Do[
    Switch[dataItem["packType"],
     "massiveFull",
     With[{lineIndex = dataItem["lineIndex"]},
      AppendTo[rules,
       HoldPattern[(int_J /; tadpoleMassiveSwapNeededQ[topo, lineIndex, int])] :>
        tadpoleSwapLinePack[int, lineIndex]
       ]
      ],
     "masslessFull",
     With[{lineIndex = dataItem["lineIndex"]},
      AppendTo[rules,
       HoldPattern[(int_J /; tadpoleMasslessZeroQ[topo, lineIndex, int])] :> 0
       ]
      ],
     _, Null
     ],
    {dataItem, data}
    ];
   rules
   ];


effectiveSymmetryRules0[topo_Association] := Module[{userRules = repSymmetry0[topo]},
   If[! ListQ[userRules], Return[userRules]];
   DeleteDuplicates@Join[tadpoleSymmetryRules0[topo], userRules]
   ];


tadpoleSymmetryData[topo_Association] := Module[{data = tadpoleLoopReversalData[topo]},
   <|
    "status" -> "generated",
    "loopReversalData" -> data,
    "massiveFullLineIndices" -> Lookup[Select[data, #["packType"] === "massiveFull" &], "lineIndex"],
    "masslessFullLineIndices" -> Lookup[Select[data, #["packType"] === "masslessFull" &], "lineIndex"],
    "automaticRuleCount" -> Length[tadpoleSymmetryRules0[topo]],
    "automaticRules" -> tadpoleSymmetryRules0[topo],
    "userRuleCount" -> Length[repSymmetry0[topo]],
    "effectiveRuleCount" -> Length[effectiveSymmetryRules0[topo]]
    |>
   ];


symmetry[expr_, topo_Association] := Module[
   {rules = effectiveSymmetryRules0[topo]},
   If[
    ! ListQ[rules] || ! And @@ (validDiscreteReplacementRuleQ /@ rules),
    Message[symmetry::badrules];
    Return[$Failed]
    ];
   expr /. rules
   ];

(* ::Chapter:: *)
(*标量积与 ISP 覆盖性*)

(* 本章将 Q_e^2 展开到 qq/qk/kk，并记录 propagator z_e 与用户 ISP 的结构信息。
   默认不做 MatrixRank/Solve 等解析检查；覆盖性验证应在单独 numeric/specialized 脚本中代数赋值后执行。 *)


scalarProductVariables[topo_Association] := Module[{nL = topo["nL"], nK = topo["nK"]},
   Join[
    Flatten[Table[qq[i, j], {i, nL}, {j, i, nL}]],
    Flatten[Table[qk[i, j], {i, nL}, {j, nK}]]
    ]
   ];


externalInvariantVariables[topo_Association] := Module[{nK = topo["nK"]},
   Flatten[Table[kk[i, j], {i, nK}, {j, i, nK}]]
   ];


numericRuleLHSVariables[topo_Association] := DeleteDuplicates[
   Cases[topo["numericRules"], (Rule | RuleDelayed)[lhs_, _] :> lhs, {0, Infinity}]
   ];


missingExternalInvariantNumericRules[topo_Association] := Complement[
   externalInvariantVariables[topo],
   numericRuleLHSVariables[topo]
   ];


vertexEnergyVariables[topo_Association] := DeleteDuplicates[
   Variables[vertexExternalEnergy[topo, #] & /@ activeAVertexIds[topo]]
   ];


missingVertexEnergyNumericRules[topo_Association] := Complement[
   vertexEnergyVariables[topo],
   numericRuleLHSVariables[topo]
   ];


lineParameterVariables[topo_Association] := DeleteDuplicates[
   Variables[Flatten[Lookup[topo["lines"], #, {}] & /@ {"nu", "eomCoefficients", "shrinkPrefactor"}]]
   ];


missingLineParameterNumericRules[topo_Association] := Complement[
   lineParameterVariables[topo],
   numericRuleLHSVariables[topo]
   ];


(* numeric workflow 的前置规则集中在这里，方便用户初始化时一次看清需要补哪些替换。 *)
numericRuleRequirementReport[topo_Association] := Module[
   {provided, external, vertex, line, required, missingExternal, missingVertex, missingLine, missingAll, toUser},
   provided = numericRuleLHSVariables[topo];
   external = externalInvariantVariables[topo];
   vertex = vertexEnergyVariables[topo];
   line = lineParameterVariables[topo];
   required = DeleteDuplicates[Join[external, vertex, line]];
   missingExternal = Complement[external, provided];
   missingVertex = Complement[vertex, provided];
   missingLine = Complement[line, provided];
   missingAll = Complement[required, provided];
   toUser[list_] := scalarProductInternalToUser[#, topo] & /@ list;
   <|
    "providedNumericVariables" -> toUser[provided],
    "internalProvidedNumericVariables" -> provided,
    "requiredExternalInvariants" -> toUser[external],
    "internalRequiredExternalInvariants" -> external,
    "externalInvariantNamingReport" -> externalInvariantNamingReport[topo],
    "vertexEnergyNamingReport" -> vertexEnergyNamingReport[topo],
    "requiredVertexEnergies" -> toUser[vertex],
    "internalRequiredVertexEnergies" -> vertex,
    "requiredLineParameters" -> line,
    "requiredNumericVariables" -> toUser[required],
    "internalRequiredNumericVariables" -> required,
    "missingExternalInvariants" -> toUser[missingExternal],
    "internalMissingExternalInvariants" -> missingExternal,
    "missingVertexEnergies" -> toUser[missingVertex],
    "internalMissingVertexEnergies" -> missingVertex,
    "missingLineParameters" -> missingLine,
    "missingNumericVariables" -> toUser[missingAll],
    "internalMissingNumericVariables" -> missingAll,
    "completeStaticNumericRulesQ" -> TrueQ[missingAll === {}]
    |>
   ];

numericRuleTemplateVariables[report_Association, scope_] := Switch[scope,
   "missing", report["missingNumericVariables"],
   "required", report["requiredNumericVariables"],
   "externalInvariants", report["requiredExternalInvariants"],
   "vertexEnergies", report["requiredVertexEnergies"],
   "lineParameters", report["requiredLineParameters"],
   list_List, list,
   _, report["missingNumericVariables"]
   ];


numericRuleTemplateValue[var_, valueSpec_] := If[valueSpec === Automatic, numericValue[var], valueSpec];


Options[makeNumericRuleTemplate] = {
   NumericRuleTemplateScope -> "missing",
   NumericRuleTemplateValue -> Automatic
   };


(* 生成可直接复制到 case["numericRules"] 的替换规则骨架；默认只列当前缺失项。 *)
makeNumericRuleTemplate[caseOrTopo_Association, OptionsPattern[]] := Module[
   {topo, report, vars, valueSpec},
   If[! parsedTopologyQ[caseOrTopo] && caseInputPreflightErrorQ[caseOrTopo],
    Return[{}]
    ];
   topo = If[KeyExistsQ[caseOrTopo, "lines"] && KeyExistsQ[caseOrTopo, "nL"], caseOrTopo, parseTopology[caseOrTopo]];
   report = numericRuleRequirementReport[topo];
   vars = numericRuleTemplateVariables[report, OptionValue[NumericRuleTemplateScope]];
   valueSpec = OptionValue[NumericRuleTemplateValue];
   (Rule[#, numericRuleTemplateValue[#, valueSpec]] &) /@ vars
   ];


(* 将两个线性动量表达式的点积展开为 qq/qk/kk。 *)
expandDotExpr[p_, r_, topo_Association] := Module[
   {loops = topo["loopMomenta"], exts = topo["externalMomenta"],
    nL = topo["nL"], nK = topo["nK"], lcP, lcR, ecP, ecR, result = 0},
   lcP = Coefficient[p, #] & /@ loops;
   lcR = Coefficient[r, #] & /@ loops;
   ecP = Coefficient[p, #] & /@ exts;
   ecR = Coefficient[r, #] & /@ exts;
   Do[
    result += lcP[[i]] lcR[[j]] qqSym[i, j],
    {i, nL}, {j, nL}
    ];
   Do[
    result += lcP[[i]] ecR[[j]] qk[i, j] + ecP[[j]] lcR[[i]] qk[i, j],
    {i, nL}, {j, nK}
    ];
   Do[
    result += ecP[[i]] ecR[[j]] kkSym[i, j],
    {i, nK}, {j, nK}
    ];
   Expand[result]
   ];



(* 用户口的 sp[p,r] 统一展开到内部 qq/qk/kk 坐标；p,r 可为用户命名的线性动量组合。 *)
scalarProductSPInputToInternal[expr_, topo_Association] := Expand[
   expr /. HoldPattern[sp[p_, r_]] :> expandDotExpr[p, r, topo]
   ];


externalInvariantSymbolName[i_Integer, j_Integer] := ToExpression["s" <> ToString[Min[i, j]] <> ToString[Max[i, j]]];


defaultExternalInvariantRulesForTopology[topo_Association] := Module[
   {exts = Lookup[topo, "externalMomenta", {}], nK = Lookup[topo, "nK", Length[Lookup[topo, "externalMomenta", {}]]]},
   Flatten[Table[sp[exts[[i]], exts[[j]]] -> externalInvariantSymbolName[i, j], {i, nK}, {j, i, nK}]]
   ];


normalizeExternalInvariantRulesForTopology[Automatic, topo_Association] := defaultExternalInvariantRulesForTopology[topo];
normalizeExternalInvariantRulesForTopology[rules_Association, topo_Association] := normalizeExternalInvariantRulesForTopology[Normal[rules], topo];
normalizeExternalInvariantRulesForTopology[rules_List, topo_Association] := Module[
   {defaults = defaultExternalInvariantRulesForTopology[topo], validRules},
   validRules = Select[rules, validReplacementRuleQ];
   Normal[Association[Join[defaults, validRules]]]
   ];
normalizeExternalInvariantRulesForTopology[_, topo_Association] := defaultExternalInvariantRulesForTopology[topo];


externalInvariantInternalToUserRules[topo_Association] := Module[
   {rules = Lookup[topo, "externalInvariantRules", defaultExternalInvariantRulesForTopology[topo]]},
   rules /. (Rule | RuleDelayed)[lhs_, rhs_] :> Rule[scalarProductSPInputToInternal[lhs, topo], rhs]
   ];


externalInvariantUserToInternalRules[topo_Association] := Module[
   {rules = externalInvariantInternalToUserRules[topo]},
   Cases[rules, Rule[lhs_, rhs_] :> Rule[rhs, lhs]]
   ];


externalInvariantNamingReport[topo_Association] := <|
   "externalMomenta" -> Lookup[topo, "externalMomenta", {}],
   "externalInvariantRules" -> Lookup[topo, "externalInvariantRules", defaultExternalInvariantRulesForTopology[topo]],
   "internalExternalInvariantRules" -> externalInvariantInternalToUserRules[topo],
   "defaultNamingConvention" -> "sij, where i,j are positions in externalMomenta and i<=j",
   "message" -> "圈动量相关标量积的用户输入统一用 sp[p,r]；外动量-外动量不变量在输出端使用 externalInvariantRules 指定的变量名，未指定时默认按 externalMomenta 顺序输出为 sij。"
   |>;


scalarProductInputToInternal[expr_, topo_Association] := Expand[
   scalarProductSPInputToInternal[expr, topo] /. externalInvariantUserToInternalRules[topo]
   ];


scalarProductInternalToUser[expr_, topo_Association] := Module[
   {loops = topo["loopMomenta"], exts = topo["externalMomenta"]},
   Expand[expr /. Join[
      externalInvariantInternalToUserRules[topo],
      {
       HoldPattern[qq[i_Integer, j_Integer]] :> sp[loops[[i]], loops[[j]]],
       HoldPattern[qk[i_Integer, j_Integer]] :> sp[loops[[i]], exts[[j]]]
       }
      ]]
   ];


scalarProductExpressionValidQ[expr_, topo_Association] := Module[
   {internal = scalarProductInputToInternal[expr, topo], allowedVars},
   allowedVars = Join[scalarProductVariables[topo], externalInvariantVariables[topo]];
   FreeQ[internal, sp] && SubsetQ[allowedVars, Variables[internal]]
   ];


normalizeISPExprs[topo_Association] := scalarProductInputToInternal[Lookup[#, "expr"], topo] & /@ topo["ispData"];


normalizeNumericRulesForTopology[rules_List, topo_Association] := rules /. (Rule | RuleDelayed)[lhs_, rhs_] :> Rule[scalarProductInputToInternal[lhs, topo], rhs];
normalizeNumericRulesForTopology[rules_, topo_Association] := rules;


normalizeCoefficientRulesForTopology[rules_List, topo_Association] := normalizeNumericRulesForTopology[rules, topo];
normalizeCoefficientRulesForTopology[rules_, topo_Association] := rules;


normalizeCoefficientRulesForLinearData[rules_, linearData_Association] := Module[
   {topo = Lookup[linearData, "topology", Missing["NoTopology"]]},
   If[parsedTopologyQ[topo], normalizeCoefficientRulesForTopology[rules, topo], rules]
   ];


userCoefficientRulesForLinearData[rules_, linearData_Association] := Module[
   {topo = Lookup[linearData, "topology", Missing["NoTopology"]]},
   If[parsedTopologyQ[topo] && ListQ[rules],
    rules /. (Rule | RuleDelayed)[lhs_, rhs_] :> Rule[scalarProductInternalToUser[lhs, topo], rhs],
    rules
    ]
   ];


userNumericRules[topo_Association] := topo["numericRules"] /. (Rule | RuleDelayed)[lhs_, rhs_] :> Rule[scalarProductInternalToUser[lhs, topo], rhs];

loopDependentLineIndices[topo_Association] := Flatten@Position[
   Lookup[topo, "loopCoeffMatrix", {}],
   row_List /; AnyTrue[row, ! zeroQ[#] &]
   ];


expandZList[topo_Association] := Module[{indices = loopDependentLineIndices[topo]},
   expandDotExpr[#, #, topo] & /@ Lookup[topo["lines"][[indices]], "momentum"]
   ];


coefficientMatrix[exprs_List, vars_List] := Table[
   Coefficient[Expand[exprs[[r]]], vars[[c]]],
   {r, Length[exprs]}, {c, Length[vars]}
   ];


linearMomentumExpressionData[expr_, basis_List] := Module[
   {coeffs, residual},
   coeffs = Coefficient[expr, #] & /@ basis;
   residual = Expand[expr - Total[MapThread[#1 #2 &, {coeffs, basis}]]];
   <|"expr" -> expr, "basis" -> basis, "coefficients" -> coeffs, "residual" -> residual, "linearQ" -> TrueQ[residual === 0]|>
   ];


linearMomentumExpressionQ[expr_, basis_List] := TrueQ[linearMomentumExpressionData[expr, basis]["linearQ"]];


lineMomentumLinearityIssues[topo_Association] := Module[
   {basis = Join[topo["loopMomenta"], topo["externalMomenta"], Lookup[topo, "externalLegMomenta", {}]]},
   DeleteCases[
    MapIndexed[
     With[{data = linearMomentumExpressionData[Lookup[#1, "momentum", 0], basis]},
       If[TrueQ[data["linearQ"]],
        Nothing,
        <|"lineIndex" -> First[#2], "lineId" -> Lookup[#1, "id", Missing["id"]], "momentum" -> Lookup[#1, "momentum", Missing["momentum"]], "residual" -> data["residual"], "basis" -> basis|>
        ]
       ] &,
     topo["lines"]
     ],
    Nothing
    ]
   ];


scalarProductArgumentLinearityIssues[topo_Association] := Module[
   {basis = Join[topo["loopMomenta"], topo["externalMomenta"]], rawISPExprs, spData},
   rawISPExprs = Lookup[#, "expr"] & /@ topo["ispData"];
   DeleteCases[
    Flatten[
     MapIndexed[
      Function[{expr, pos},
       MapIndexed[
        Function[{pair, pairPos},
         DeleteCases[
          MapIndexed[
           With[{data = linearMomentumExpressionData[#1, basis]},
             If[TrueQ[data["linearQ"]],
              Nothing,
              <|"ispPosition" -> First[pos], "ispName" -> Lookup[topo["ispData"][[First[pos]]], "name", Missing["name"]], "spPosition" -> First[pairPos], "argumentSlot" -> First[#2], "argument" -> #1, "residual" -> data["residual"], "basis" -> basis|>
              ]
             ] &,
           pair
           ],
          Nothing
          ]
         ],
        Cases[expr, HoldPattern[sp[p_, r_]] :> {p, r}, {0, Infinity}]
        ]
       ],
      rawISPExprs
      ],
     2
     ],
    Nothing
    ]
   ];


vertexEnergySPArgumentIssues[expr_, topo_Association] := Module[
   {basis = Join[topo["loopMomenta"], topo["externalMomenta"], Lookup[topo, "externalLegMomenta", {}]], nL = topo["nL"], pairs},
   pairs = Cases[expr, HoldPattern[sp[p_, r_]] :> {p, r}, {0, Infinity}];
   DeleteCases[
    Flatten[
     MapIndexed[
      Function[{pair, pairPos},
       MapIndexed[
        Function[{arg, argPos},
         Module[{data = linearMomentumExpressionData[arg, basis], loopCoeffs},
          loopCoeffs = Take[data["coefficients"], nL];
          If[TrueQ[data["linearQ"]] && TrueQ[loopCoeffs === ConstantArray[0, nL]],
           Nothing,
           <|
            "spPosition" -> First[pairPos],
            "argumentSlot" -> First[argPos],
            "argument" -> arg,
            "residual" -> data["residual"],
            "loopCoefficients" -> loopCoeffs,
            "basis" -> basis
            |>
           ]
          ]
         ],
        pair
        ]
       ],
      pairs
      ],
     1
     ],
    Nothing
    ]
   ];


vertexEnergyMomentumDependenceIssues[topo_Association] := Module[
   {declared = Join[topo["loopMomenta"], topo["externalMomenta"], Lookup[topo, "externalLegMomenta", {}]],
    loopSPVars = scalarProductVariables[topo], vertices = activeAVertexIds[topo]},
   DeleteCases[
    Table[
     Module[{raw = rawVertexExternalEnergy[topo, vertex], rawNoSP, directMomenta, spArgIssues, internal, loopSPUsed},
      rawNoSP = raw /. HoldPattern[sp[_, _]] -> 0;
      directMomenta = DeleteDuplicates@Cases[rawNoSP, sym_Symbol /; MemberQ[declared, sym], {0, Infinity}];
      spArgIssues = vertexEnergySPArgumentIssues[raw, topo];
      internal = scalarProductInputToInternal[raw, topo];
      loopSPUsed = Intersection[Variables[internal], loopSPVars];
      If[directMomenta === {} && spArgIssues === {} && loopSPUsed === {},
       Nothing,
       <|
        "vertexId" -> vertex,
        "rawVertexEnergy" -> raw,
        "userVertexEnergy" -> scalarProductInternalToUser[internal, topo],
        "directMomentumSymbols" -> directMomenta,
        "spArgumentIssues" -> spArgIssues,
        "loopScalarProducts" -> scalarProductInternalToUser[#, topo] & /@ loopSPUsed,
        "comment" -> "vertexEnergies are scalar time-phase energies for all external legs attached to a vertex; use external invariant variables when the energy is tied to externalMomenta space, otherwise use independent ke[i] parameters"
        |>
       ]
      ],
     {vertex, vertices}
     ],
    Nothing
    ]
   ];



(* 标量积坐标规则只依赖动量路由、ISP 和外部不变量命名。
   缓存键排除 sector、顶点和 seed 配置，使同一 family 的 shrink sectors 共享一次 LinearSolve。 *)
$scalarProductRuleCache = <||>;


scalarProductRuleCacheKey[topo_Association] := With[
   {
    nL = topo["nL"],
    nK = topo["nK"],
    nE = topo["nE"],
    loopMomenta = topo["loopMomenta"],
    externalMomenta = topo["externalMomenta"],
    lineMomenta = Lookup[topo["lines"], "momentum"],
    ispExprs = Lookup[topo["ispData"], "expr"],
    externalInvariantRules = Lookup[topo, "externalInvariantRules", {}]
    },
   HoldComplete[nL, nK, nE, loopMomenta, externalMomenta, lineMomenta, ispExprs, externalInvariantRules]
   ];


clearScalarProductRuleCache[] := ($scalarProductRuleCache = <||>; Null);


scalarProductRuleCacheReport[] := <|
   "entryCount" -> Length[$scalarProductRuleCache],
   "hashes" -> Keys[$scalarProductRuleCache]
   |>;


(* 小规模线性规则核心：直接作为 ISP 给出的标量积会被保留，不强行改写成 rho。
   本 package 假设用户输入的 z_e 与直接 ISP 已经构成闭合坐标；这里不把 dS 图
   默认当成 overcomplete propagator family 处理，避免改变用户定义的函数族。 *)
makeScalarProductRulesUncached[topo_Association] := Module[
   {spVars, zVars, zExprs, rawISPExprs, ispExprs, ispVars, invalidISPPositions, unsupportedISPExprs,
    coordExprs, coordVars, mat, const, rhs, solVec},
   spVars = scalarProductVariables[topo];
   zVars = z /@ loopDependentLineIndices[topo];
   zExprs = expandZList[topo];
   rawISPExprs = Lookup[#, "expr"] & /@ topo["ispData"];
   ispExprs = scalarProductInputToInternal[#, topo] & /@ rawISPExprs;
   ispVars = Table[rho[j], {j, Length[ispExprs]}];
   invalidISPPositions = Flatten@Position[Map[scalarProductExpressionValidQ[#, topo] &, rawISPExprs], False];
   unsupportedISPExprs = rawISPExprs[[invalidISPPositions]];
   If[unsupportedISPExprs =!= {},
    Return[<|
      "status" -> "notComputed",
      "reason" -> "ISP expressions must be scalar products written as sp[p,r] or linear combinations of them",
      "repSP2Z" -> Missing["NotComputedUnsupportedISP"],
      "solveVars" -> Missing["NotComputedUnsupportedISP"],
      "preservedISPVars" -> ispVars,
      "ispCoordinateVars" -> ispVars,
      "unsupportedISPExprs" -> unsupportedISPExprs
      |>]
    ];
   coordExprs = Join[zExprs, ispExprs];
   coordVars = Join[zVars, ispVars];
   If[Length[coordExprs] =!= Length[spVars],
    Return[<|
      "status" -> "notComputed",
      "reason" -> "z plus ISP equation count does not match scalar-product count",
      "repSP2Z" -> Missing["NotComputedCountMismatch"],
      "solveVars" -> spVars,
      "preservedISPVars" -> ispVars,
      "ispCoordinateVars" -> ispVars,
      "zCount" -> Length[zExprs],
      "ispCount" -> Length[ispExprs],
      "scalarProductCount" -> Length[spVars]
      |>]
    ];
   mat = coefficientMatrix[coordExprs, spVars];
   const = coordExprs /. Thread[spVars -> 0];
   rhs = coordVars - const;
   solVec = Check[LinearSolve[mat, rhs], $Failed];
   If[solVec === $Failed,
    Return[<|
      "status" -> "notComputed",
      "reason" -> "LinearSolve failed",
      "repSP2Z" -> Missing["LinearSolveFailed"],
      "solveVars" -> spVars,
      "preservedISPVars" -> ispVars,
      "ispCoordinateVars" -> ispVars,
      "zCount" -> Length[zExprs],
      "ispCount" -> Length[ispExprs],
      "scalarProductCount" -> Length[spVars]
      |>]
    ];
   <|
    "status" -> "computed",
    "repSP2Z" -> Thread[spVars -> (Expand /@ solVec)],
    "userRepSP2Z" -> (Rule[scalarProductInternalToUser[#[[1]], topo], scalarProductInternalToUser[#[[2]], topo]] & /@ Thread[spVars -> (Expand /@ solVec)]),
    "repZ2SP" -> Thread[zVars -> zExprs],
    "userRepZ2SP" -> (Rule[#[[1]], scalarProductInternalToUser[#[[2]], topo]] & /@ Thread[zVars -> zExprs]),
    "repISP2SP" -> Thread[ispVars -> ispExprs],
    "userRepISP2SP" -> (Rule[#[[1]], scalarProductInternalToUser[#[[2]], topo]] & /@ Thread[ispVars -> ispExprs]),
    "solveVars" -> spVars,
    "preservedISPVars" -> ispVars,
    "ispCoordinateVars" -> ispVars,
    "zCount" -> Length[zExprs],
    "ispCount" -> Length[ispExprs],
    "scalarProductCount" -> Length[spVars]
    |>
   ];


(* 公开入口在命中缓存时直接返回；SHA-256 命中后仍用完整键 SameQ 防止哈希冲突。 *)
makeScalarProductRules[topo_Association] := Module[
   {key, hash, entry, result},
   key = scalarProductRuleCacheKey[topo];
   hash = Hash[key, "SHA256"];
   entry = Lookup[$scalarProductRuleCache, hash, Missing["NotCached"]];
   If[AssociationQ[entry] && SameQ[entry["key"], key],
    Return[entry["value"]]
    ];
   result = makeScalarProductRulesUncached[topo];
   AssociateTo[$scalarProductRuleCache, hash -> <|"key" -> key, "value" -> result|>];
   result
   ];


makeScalarProductData[topo_Association] := Module[
   {spVars, zVars, zExprs, rawISPExprs, ispExprs, ispSymbols, invalidISPPositions, unsupportedISPExprs,
    coordExprs, nSP, structuralNeededISPCount, structuralCountQ, coordinateCountQ},
   spVars = scalarProductVariables[topo];
   zVars = z /@ loopDependentLineIndices[topo];
   zExprs = expandZList[topo];
   rawISPExprs = Lookup[#, "expr"] & /@ topo["ispData"];
   ispExprs = scalarProductInputToInternal[#, topo] & /@ rawISPExprs;
   ispSymbols = Table[rho[j], {j, Length[ispExprs]}];
   invalidISPPositions = Flatten@Position[Map[scalarProductExpressionValidQ[#, topo] &, rawISPExprs], False];
   unsupportedISPExprs = rawISPExprs[[invalidISPPositions]];
   coordExprs = Join[zExprs, ispExprs];
   nSP = Length[spVars];
   structuralNeededISPCount = Max[0, nSP - Length[zExprs]];
   structuralCountQ = Length[ispExprs] >= structuralNeededISPCount;
   coordinateCountQ = Length[coordExprs] === nSP;
   <|
    "scalarProducts" -> (scalarProductInternalToUser[#, topo] & /@ spVars),
    "internalScalarProducts" -> spVars,
    "externalInvariants" -> (scalarProductInternalToUser[#, topo] & /@ externalInvariantVariables[topo]),
    "internalExternalInvariants" -> externalInvariantVariables[topo],
    "externalInvariantNamingReport" -> externalInvariantNamingReport[topo],
    "zVars" -> zVars,
    "zExprs" -> (scalarProductInternalToUser[#, topo] & /@ zExprs),
    "internalZExprs" -> zExprs,
    "ispSymbols" -> ispSymbols,
    "ispExprs" -> (scalarProductInternalToUser[#, topo] & /@ ispExprs),
    "internalISPExprs" -> ispExprs,
    "directISPVars" -> ispSymbols,
    "internalDirectISPVars" -> ispSymbols,
    "unsupportedISPExprs" -> unsupportedISPExprs,
    "solveVars" -> spVars,
    "zCount" -> Length[zExprs],
    "spCount" -> nSP,
    "ispCount" -> Length[ispExprs],
    "directISPCount" -> Length[ispExprs],
    "nonISPScalarProductCount" -> nSP - Length[ispExprs],
    "structuralNeededISPCount" -> structuralNeededISPCount,
    "structuralCountQ" -> structuralCountQ,
    "coordinateCountQ" -> coordinateCountQ,
    "coverageQ" -> Missing["NotCheckedSeedOnly"],
    "independentQ" -> Missing["NotCheckedSeedOnly"],
    "repSP2Z" -> Missing["NotComputedSeedOnly"]
    |>
   ];

(* ::Chapter:: *)
(*IBP 生成元枚举*)

(* 本章只生成 IBP 算子标签，不展开公式。完整集合包括 time IBP 和
   momentum IBP: d/dq_l dot q_m, d/dq_l dot k_j。 *)


makeIBPGenerators[topo_Association] := Module[
   {timeGenerators, loopGenerators, externalGenerators},
   timeGenerators = <|"type" -> "time", "vertex" -> #|> & /@ Lookup[topo, "activeVertexIds", topo["vertexIds"]];
   loopGenerators = Flatten[
     Table[
      <|
       "type" -> "momentum",
       "dLoop" -> l,
       "vectorType" -> "loop",
       "vectorIndex" -> m,
       "vector" -> topo["loopMomenta"][[m]]
       |>,
      {l, topo["nL"]}, {m, topo["nL"]}
      ],
     1
     ];
   externalGenerators = Flatten[
     Table[
      <|
       "type" -> "momentum",
       "dLoop" -> l,
       "vectorType" -> "external",
       "vectorIndex" -> j,
       "vector" -> topo["externalMomenta"][[j]]
       |>,
      {l, topo["nL"]}, {j, topo["nK"]}
      ],
     1
     ];
   Join[timeGenerators, loopGenerators, externalGenerators]
   ];


expectedMomentumGeneratorCount[topo_Association] := topo["nL"] (topo["nL"] + topo["nK"]);


(* ::Chapter:: *)
(*轻量 momentum IBP seed*)

(* 本章生成 momentum IBP seed 的传播子幂次项、z/ISP 吸收和 massive/massless building-block 导数项。
   输出会经过 EOM 与 per-line massless endpoint canonical 门禁；shrunk pack 的 bS 幂次也使用当前 pack 指标。 *)

linearTerms[expr_] := Module[{expanded = Expand[expr]},
   If[Head[expanded] === Plus, List @@ expanded, {expanded}]
   ];


shiftLineB[J[aList_, linePacks_, ispList_], e_Integer, delta_] := Module[
   {newLinePacks = linePacks},
   newLinePacks[[e, 1]] = newLinePacks[[e, 1]] + delta;
   J[aList, newLinePacks, ispList]
   ];


zeroPointRuleValue[topo_Association, symbol_, default_: 0] := Module[
   {hits},
   hits = Cases[Lookup[topo, "zeroPointRules", {}], (Rule | RuleDelayed)[lhs_, rhs_] /; lhs === symbol :> rhs];
   If[hits === {}, default, Last[hits]]
   ];


vertexZeroPoint[topo_Association, vertexId_] := zeroPointRuleValue[topo, a0[vertexRepresentative[topo, vertexId]]];


lineBZeroPoint[topo_Association, e_Integer] := zeroPointRuleValue[topo, b0[topo["lines"][[e, "id"]]]];


lineBSZeroPoint[topo_Association, e_Integer] := zeroPointRuleValue[topo, bS0[topo["lines"][[e, "id"]]]];


vertexPowerIndex[topo_Association, J[aList_, linePacks_, ispList_], vertexId_] := Module[
   {pos = vertexASlot[topo, vertexId]},
   If[Head[pos] === Missing, 0, aList[[pos]] + vertexZeroPoint[topo, vertexId]]
   ];


linePowerIndex[topo_Association, J[aList_, linePacks_, ispList_], e_Integer] := Module[
   {base = linePacks[[e, 1]], packType = actualLinePackType[topo, e, linePacks[[e]]]},
   base + If[packType === "shrunk", lineBSZeroPoint[topo, e], lineBZeroPoint[topo, e]]
   ];


shiftISPIndex[J[aList_, linePacks_, ispList_], j_Integer, delta_] := Module[
   {newISPList = ispList},
   newISPList[[j]] = newISPList[[j]] + delta;
   J[aList, linePacks, newISPList]
   ];


(* 将一个线性因子吸收到 b 或 ISP 指标中；无法识别的高次项保持为显式系数。 *)
absorbLinearFactorTerm[term_, int_J, topo_Association] := Module[
   {zVars, ispVars, vars, rules, rebuildMonomial},
   zVars = z /@ loopDependentLineIndices[topo];
   ispVars = Table[rho[j], {j, Length[topo["ispData"]]}];
   vars = Join[zVars, ispVars];
   If[Length[vars] == 0, Return[term int]];
   rules = CoefficientRules[term, vars];
   rebuildMonomial[powers_] := Times @@ MapThread[#1^#2 &, {vars, powers}];
   Total[
    rules /. (powers_ -> coeff_) :> Module[
       {degree = Total[powers], pos, var},
       If[degree === 0,
        coeff int,
        If[Count[powers, 1] === 1 && Count[powers, Except[0 | 1]] === 0 && degree === 1,
         pos = First@FirstPosition[powers, 1];
         var = vars[[pos]];
         Which[
          MatchQ[var, z[_Integer]],
          coeff shiftLineB[int, var[[1]], -2],
          MemberQ[ispVars, var],
          coeff shiftISPIndex[int, First@FirstPosition[ispVars, var], 1],
          True,
          coeff var int
          ],
         coeff rebuildMonomial[powers] int
         ]
        ]
       ]
    ]
   ];


absorbLinearFactor[factor_, int_J, topo_Association] := Total[
   absorbLinearFactorTerm[#, int, topo] & /@ linearTerms[factor]
   ];


momentumDivergenceTerm[int_J, gen_Association] := If[
   gen["type"] === "momentum" && gen["vectorType"] === "loop" && gen["dLoop"] === gen["vectorIndex"],
   dim int,
   0
   ];


(* masslessFull 的 n=1 方向由 endpoints[[1]] 定义；++ 取 sigma=+1，-- 取 sigma=-1。 *)
masslessFullSKSign[line_Association] := If[
   StringTake[Lookup[line, "skType", "++"], 1] === "+",
   1,
   -1
   ];


lineEndpointSlotsAtVertex[line_Association, vertexId_] := Flatten @ Position[
   line["endpoints"],
   vertexId
   ];


applyCompiledTimeDerivativeTerm[
   topo_Association, int_J, e_Integer, endpointSlot_Integer, term_Association
   ] := Module[{result, endpointVertex, xPower = term["xPower"]},
   endpointVertex = topo["lines"][[e, "endpoints", endpointSlot]];
   result = setLinePackEntry[int, e, endpointSlot + 1, term["targetState"]];
   result = shiftLineB[result, e, -(xPower + 1)];
   result = shiftVertexA[result, topo, endpointVertex, xPower];
   -term["coefficient"] result
   ];


compiledTimeEndpointDerivativeTerms[
   topo_Association, int_J, e_Integer, endpointSlot_Integer
   ] := Module[{state, terms},
   state = int[[2, e, endpointSlot + 1]];
   terms = Lookup[lineCompiledFunctionSystem[topo["lines"][[e]]], "derivativeTerms", {}];
   Total[
    KroneckerDelta[state, Lookup[#, "sourceState", Missing["NoSourceState"]]] *
       applyCompiledTimeDerivativeTerm[topo, int, e, endpointSlot, #] & /@ terms
    ]
   ];


applyCompiledMomentumDerivativeTerm[
   topo_Association, int_J, e_Integer, endpointSlot_Integer, factor_, term_Association
   ] := Module[{result, endpointVertex, xPower = term["xPower"]},
   endpointVertex = topo["lines"][[e, "endpoints", endpointSlot]];
   result = setLinePackEntry[int, e, endpointSlot + 1, term["targetState"]];
   result = shiftLineB[result, e, 1 - xPower];
   result = shiftVertexA[result, topo, endpointVertex, xPower + 1];
   term["coefficient"] absorbLinearFactor[factor, result, topo]
   ];


compiledMomentumEndpointDerivativeTerms[
   topo_Association, int_J, e_Integer, endpointSlot_Integer, factor_
   ] := Module[{state, terms},
   state = int[[2, e, endpointSlot + 1]];
   terms = Lookup[lineCompiledFunctionSystem[topo["lines"][[e]]], "derivativeTerms", {}];
   Total[
    KroneckerDelta[state, Lookup[#, "sourceState", Missing["NoSourceState"]]] *
       applyCompiledMomentumDerivativeTerm[topo, int, e, endpointSlot, factor, #] & /@ terms
    ]
   ];


toggleMasslessLineState[J[aList_, linePacks_, ispList_], e_Integer] := Module[
   {newLinePacks = linePacks},
   newLinePacks[[e, 2]] = 1 - newLinePacks[[e, 2]];
   J[aList, newLinePacks, ispList]
   ];


(* q 导数同时作用 massive Hankel block 与 massless 指数核。
   masslessFull 使用 d_q M_n = i sigma (tau_u-tau_v) M_(1-n)；
   masslessCross 使用两个端点相位符号的和。 *)
momentumBuildingBlockDerivativeTerms[topo_Association, int_J, gen_Association, repSP2ZRules_List] := Module[
   {dLoop, vector, lineMomenta, lines, loopCoeff, vDotQ,
     shiftedInt, packType, sigma},
   dLoop = gen["dLoop"];
   vector = gen["vector"];
   lineMomenta = Lookup[topo["lines"], "momentum"];
   lines = topo["lines"];
   Total[
    Table[
     loopCoeff = Coefficient[lineMomenta[[e]], topo["loopMomenta"][[dLoop]]];
     If[zeroQ[loopCoeff],
      0,
      vDotQ = Expand[expandDotExpr[vector, lineMomenta[[e]], topo] /. repSP2ZRules];
      packType = lines[[e]]["packType"];
      Switch[packType,
       "massiveFull" | "massiveCross",
        Total[
         Table[
          loopCoeff compiledMomentumEndpointDerivativeTerms[topo, int, e, endpointSlot, vDotQ],
          {endpointSlot, 2}
          ]
        ],
       "masslessFull",
       sigma = masslessFullSKSign[lines[[e]]];
       shiftedInt = shiftLineB[toggleMasslessLineState[int, e], e, 1];
       loopCoeff (
         -I sigma absorbLinearFactor[
           vDotQ,
           shiftVertexA[shiftedInt, topo, lines[[e]]["endpoints"][[1]], 1],
           topo
           ] +
          I sigma absorbLinearFactor[
           vDotQ,
           shiftVertexA[shiftedInt, topo, lines[[e]]["endpoints"][[2]], 1],
           topo
           ]
         ),
       "masslessCross",
       shiftedInt = shiftLineB[int, e, 1];
       loopCoeff Total[
         Table[
          -I skEndpointPhaseSign[lines[[e]], endpointSlot] absorbLinearFactor[
            vDotQ,
            shiftVertexA[shiftedInt, topo, lines[[e]]["endpoints"][[endpointSlot]], 1],
            topo
            ],
          {endpointSlot, 2}
          ]
         ],
       _,
       0
       ]
      ],
     {e, topo["nE"]}
     ]
    ]
   ];

momentumPropagatorDerivativeTerms[topo_Association, int_J, gen_Association, repSP2ZRules_List] := Module[
   {dLoop, vector, lineMomenta, loopCoeff, vDotQ, shiftedInt},
   dLoop = gen["dLoop"];
   vector = gen["vector"];
   lineMomenta = Lookup[topo["lines"], "momentum"];
   Total[
    Table[
     loopCoeff = Coefficient[lineMomenta[[e]], topo["loopMomenta"][[dLoop]]];
     If[zeroQ[loopCoeff],
      0,
      vDotQ = Expand[expandDotExpr[vector, lineMomenta[[e]], topo] /. repSP2ZRules];
      shiftedInt = shiftLineB[int, e, 2];
      -loopCoeff linePowerIndex[topo, int, e] absorbLinearFactor[vDotQ, shiftedInt, topo]
      ],
     {e, topo["nE"]}
     ]
    ]
   ];


(* ISP 是 numerator 因子；momentum IBP 必须同时微分 ISP^r。
   内部坐标使用 qq/qk/kk，方向导数后再沿现有 z/rho 坐标吸收到指标。 *)
momentumDirectionalSPDerivative[topo_Association, expr_, gen_Association] := Module[
   {dLoop = gen["dLoop"], vector = gen["vector"], loops = topo["loopMomenta"], exts = topo["externalMomenta"]},
   Expand[
    expr /. {
      HoldPattern[qq[i_Integer, j_Integer]] :>
       If[i === dLoop, expandDotExpr[vector, loops[[j]], topo], 0] +
        If[j === dLoop, expandDotExpr[loops[[i]], vector, topo], 0],
      HoldPattern[qk[i_Integer, j_Integer]] :>
       If[i === dLoop, expandDotExpr[vector, exts[[j]], topo], 0],
      HoldPattern[kk[_Integer, _Integer]] :> 0
      }
    ]
   ];


momentumISPDerivativeTerms[topo_Association, int_J, gen_Association, repSP2ZRules_List] := Module[
   {ispExprs, exponent, derivative},
   ispExprs = normalizeISPExprs[topo];
   Total[
    Table[
     exponent = int[[3, j]];
     If[zeroQ[exponent],
      0,
      derivative = Expand[momentumDirectionalSPDerivative[topo, ispExprs[[j]], gen] /. repSP2ZRules];
      exponent absorbLinearFactor[
        derivative,
        shiftISPIndex[int, j, -1],
        topo
        ]
      ],
     {j, Length[ispExprs]}
     ]
    ]
   ];


applyMomentumGeneratorSeed::nosp =
   "拓扑 `1` 的标量积到 z/ISP 规则未生成：`2`。请补充 ISP 配置后再生成 momentum seed。";


applyMomentumGeneratorSeed[topo_Association, int_J, gen_Association] := Module[
   {ruleData},
   ruleData = makeScalarProductRules[topo];
   If[Lookup[ruleData, "status", "notComputed"] =!= "computed",
    Message[applyMomentumGeneratorSeed::nosp, topo["name"], Lookup[ruleData, "reason", Missing["reason"]]];
    Return[$Failed]
    ];
   Expand[
    momentumDivergenceTerm[int, gen] +
     momentumPropagatorDerivativeTerms[topo, int, gen, ruleData["repSP2Z"]] +
     momentumBuildingBlockDerivativeTerms[topo, int, gen, ruleData["repSP2Z"]] +
     momentumISPDerivativeTerms[topo, int, gen, ruleData["repSP2Z"]]
    ]
   ];


(* ::Chapter:: *)
(*轻量 time IBP core seed*)

(* 本章接入 time-IBP 的通用 core 项：顶点幂次、外部能量、massive building-block 端点导数、massless 端点翻转项和 massive/massless theta 边界缩并项。
   单独 time batch 会把进一步 shrink-sector 生成标为 pending；canonical batch 会在保护阈值内自动补齐这些 sectors。 *)

rawVertexExternalEnergy[topo_Association, vertexId_] := Module[
   {vertexEnergies = Lookup[topo, "vertexEnergies", Missing["NotSet"]]},
   Which[
    AssociationQ[vertexEnergies] && KeyExistsQ[vertexEnergies, vertexId], vertexEnergies[vertexId],
    ListQ[vertexEnergies], vertexId /. vertexEnergies,
    True,
    ke[vertexId]
    ]
   ];


vertexExternalEnergy[topo_Association, vertexId_] := scalarProductInputToInternal[rawVertexExternalEnergy[topo, vertexId], topo];


vertexEnergyDependencyData[topo_Association, vertexId_] := Module[
   {internal, vars, externalVars, externalUsed, independentUsed},
   internal = vertexExternalEnergy[topo, vertexId];
   vars = Variables[internal];
   externalVars = externalInvariantVariables[topo];
   externalUsed = Intersection[vars, externalVars];
   independentUsed = Complement[vars, externalVars];
   <|
    "internalExternalInvariantVariables" -> externalUsed,
    "externalInvariantVariables" -> (scalarProductInternalToUser[#, topo] & /@ externalUsed),
    "internalIndependentVertexEnergyParameters" -> independentUsed,
    "independentVertexEnergyParameters" -> (scalarProductInternalToUser[#, topo] & /@ independentUsed),
    "usesExternalInvariantQ" -> TrueQ[externalUsed =!= {}],
    "usesIndependentVertexEnergyQ" -> TrueQ[independentUsed =!= {}],
    "kind" -> Which[
      externalUsed =!= {} && independentUsed === {}, "externalInvariantExpression",
      externalUsed === {} && independentUsed =!= {}, "independentVertexEnergyParameter",
      externalUsed =!= {} && independentUsed =!= {}, "mixedExpression",
      True, "constant"
      ]
    |>
   ];


vertexEnergyNamingReport[topo_Association] := Module[
   {vertices = activeAVertexIds[topo], raw, internal, user, dependencies},
   raw = AssociationThread[vertices -> (rawVertexExternalEnergy[topo, #] & /@ vertices)];
   internal = AssociationThread[vertices -> (vertexExternalEnergy[topo, #] & /@ vertices)];
   user = AssociationThread[vertices -> (scalarProductInternalToUser[vertexExternalEnergy[topo, #], topo] & /@ vertices)];
   dependencies = AssociationThread[vertices -> (vertexEnergyDependencyData[topo, #] & /@ vertices)];
   <|
    "convention" -> "vertex external energy uses ke[i] for independent absolute-value parameters; expressions built from external invariant names are normalized to the same scalar-product coordinates used by loop momenta",
    "rawVertexEnergies" -> raw,
    "internalVertexEnergies" -> internal,
    "userVertexEnergies" -> user,
    "dependencyData" -> dependencies,
    "message" -> "vertexEnergies 的每个值表示一个顶点连着的所有外腿打包后的 e 指数能量。若该能量和 externalMomenta 空间的外部不变量是同一变量，应写成 externalInvariantRules 输出变量的函数，例如 Sqrt[s11]；否则写独立 ke[i]。不要把 |ke1+ke2| 与 |ke1|+|ke2| 混同；若 |ke1+ke2| 独立，应单独命名为 ke[i]。外腿能量参数之间不生成点积关系。"
    |>
   ];


timeVertexPowerTerm[topo_Association, J[aList_, linePacks_, ispList_], vertexId_] := Module[
   {pos = vertexASlot[topo, vertexId]},
   If[Head[pos] === Missing, Return[0]];
   -vertexPowerIndex[topo, J[aList, linePacks, ispList], vertexId] shiftVertexA[J[aList, linePacks, ispList], topo, vertexId, -1]
   ];


(* 顶点 + 对应 exp[-i E tau]，顶点 - 对应 exp[+i E tau]。 *)
vertexExternalPhaseDerivativeCoefficient[topo_Association, vertexId_] := If[
   Lookup[topo["vertexSignAssoc"], vertexId, "+"] === "+",
   -I,
   I
   ];


timeExternalEnergyTerm[topo_Association, int_J, vertexId_] :=
   vertexExternalPhaseDerivativeCoefficient[topo, vertexId] vertexExternalEnergy[topo, vertexId] int;


skEndpointPhaseSign[line_Association, endpointSlot_Integer] := Module[
   {skType = Lookup[line, "skType", "++"], chars},
   chars = Characters[skType];
   If[Length[chars] < endpointSlot,
    If[endpointSlot === 1, 1, -1],
    If[chars[[endpointSlot]] === "+", 1, -1]
    ]
   ];


(* massless time regular 原子：masslessFull 在有序端点上执行 {b,n}->{b-1,1-n}，两端系数为 +I sigma/-I sigma；
   若 sector 已使两端点 coincident，endpointSlots 同时包含 1、2，两个 regular 项必须在此处相消。
   masslessCross 没有 n 或 theta，只按各端点 SK 相位移动 b。 *)
timeMasslessEndpointDerivativeTerms[topo_Association, J[aList_, linePacks_, ispList_], vertexId_] := Module[
   {pos, connectedLines, lines = topo["lines"], endpointSlots, endpointSign,
    newLinePacks, sigma},
   pos = vertexPosition[topo, vertexId];
   If[Head[pos] === Missing, Return[0]];
   connectedLines = topo["vertexLines"][[pos]][[All, 1]];
   Total[
    Table[
     endpointSlots = lineEndpointSlotsAtVertex[lines[[e]], vertexId];
     Switch[lines[[e]]["packType"],
      "masslessFull",
      sigma = masslessFullSKSign[lines[[e]]];
      Total[
       Table[
        endpointSign = sigma If[endpointSlot === 1, 1, -1];
        newLinePacks = linePacks;
        newLinePacks[[e, 1]] = newLinePacks[[e, 1]] - 1;
        newLinePacks[[e, 2]] = 1 - newLinePacks[[e, 2]];
        I endpointSign J[aList, newLinePacks, ispList],
        {endpointSlot, endpointSlots}
        ]
       ],
      "masslessCross",
      Total[
       Table[
        endpointSign = skEndpointPhaseSign[lines[[e]], endpointSlot];
        newLinePacks = linePacks;
        newLinePacks[[e, 1]] = newLinePacks[[e, 1]] - 1;
        I endpointSign J[aList, newLinePacks, ispList],
        {endpointSlot, endpointSlots}
        ]
       ],
      _,
      0
      ],
     {e, connectedLines}
     ]
    ]
   ];


(* 缩并后同一条线的两个原端点可能落到同一 active vertex；
   此时必须同时微分两个 building block，不能只取 FirstPosition。 *)
timeMassiveBuildingBlockDerivativeTerms[topo_Association, J[aList_, linePacks_, ispList_], vertexId_] := Module[
   {pos, connectedLines, lines = topo["lines"], endpointSlots},
   pos = vertexPosition[topo, vertexId];
   If[Head[pos] === Missing, Return[0]];
   connectedLines = topo["vertexLines"][[pos]][[All, 1]];
   Total[
    Table[
     If[! MemberQ[{"massiveFull", "massiveCross"}, actualLinePackType[topo, e, linePacks[[e]]]],
      0,
      endpointSlots = lineEndpointSlotsAtVertex[lines[[e]], vertexId];
       Total[
        Table[
         compiledTimeEndpointDerivativeTerms[topo, J[aList, linePacks, ispList], e, endpointSlot],
         {endpointSlot, endpointSlots}
         ]
       ]
      ],
     {e, connectedLines}
     ]
    ]
   ];


lineCompiledShrinkTerms[line_Association] := Lookup[
   lineCompiledFunctionSystem[line],
   "shrinkTerms",
   {}
   ];


defaultThetaBoundarySignOffset[line_Association] := If[
   Lookup[line, "packType", "massiveFull"] === "massiveFull" &&
    Lookup[line, "skType", "++"] === "++",
   1,
   0
   ];


(* 参考 bubble 的 Vpm convention：++ 为 1，-- 为 0；显式 line/case 设置仍可覆盖默认值。 *)
thetaBoundarySignOffset[topo_Association, e_Integer] := Module[
   {line = topo["lines"][[e]], caseOffset},
   caseOffset = Lookup[topo, "thetaBoundarySignOffset", Automatic];
   Lookup[
    line,
    "thetaBoundarySignOffset",
    If[caseOffset === Automatic, defaultThetaBoundarySignOffset[line], caseOffset]
    ]
   ];
lineShrinkZeroPointShift[line_Association] := Module[
   {compiled = lineCompiledFunctionSystem[line]},
   Lookup[
    line,
    "shrinkZeroPointShift",
    Lookup[compiled, "shrinkZeroPointShift", 0]
    ]
   ];


sectorZeroPointRules[topo_Association, shrunkLines_List, repMap_Association, activeVertices_List] := Module[
   {lineRules, vertexRules, classVertices, classShrunkLines, shiftSum},
   lineRules = Flatten@Table[
      If[MemberQ[shrunkLines, e],
       bS0[topo["lines"][[e, "id"]]] -> lineBZeroPoint[topo, e] + lineShrinkZeroPointShift[topo["lines"][[e]]],
       Switch[actualLinePackType[topo, e, makeLinePack[topo["lines"][[e]]]],
        "shrunk", bS0[topo["lines"][[e, "id"]]] -> lineBSZeroPoint[topo, e],
        _, b0[topo["lines"][[e, "id"]]] -> lineBZeroPoint[topo, e]
        ]
       ],
      {e, topo["nE"]}
      ];
   vertexRules = Table[
     classVertices = Select[topo["vertexIds"], Lookup[repMap, #] === rep &];
     classShrunkLines = Select[shrunkLines, Function[e, And @@ (Function[v, Lookup[repMap, v] === rep] /@ topo["lines"][[e, "endpoints"]])]];
     shiftSum = Total[lineShrinkZeroPointShift[topo["lines"][[#]]] & /@ classShrunkLines];
     a0[rep] -> Total[vertexZeroPoint[topo, #] & /@ classVertices] - shiftSum,
     {rep, activeVertices}
     ];
   DeleteDuplicates@Join[vertexRules, lineRules]
   ];


(* massive Wronskian 缩并带一个额外 1/q 和 1/(-tau)，故 bS=b+1 且 merged a 减 1；
   massless 反对称 theta-delta 不带这些因子，必须保持 bS=b 且 merged a 不移位。 *)
lineShrinkBShift[line_Association] := If[
   Lookup[line, "massType", "massive"] === "massless",
   0,
   Lookup[First[Lookup[lineCompiledFunctionSystem[line], "shrinkTerms", {<|"bShift" -> 1|>}]], "bShift", 1]
   ];


shrinkLineIntegral[topo_Association, J[aList_, linePacks_, ispList_], e_Integer, bShift_: Automatic, aShift_: Automatic] := Module[
   {line = topo["lines"][[e]], uSlot, vSlot, oldActive, newRepMap, newActive, newAList, newLinePacks = linePacks,
     mergedRep, oldSlotsForNewRep, slotValues, effectiveBShift, effectiveAShift},
   effectiveBShift = If[bShift === Automatic, lineShrinkBShift[line], bShift];
    effectiveAShift = If[
      aShift === Automatic,
      If[Lookup[line, "massType", "massive"] === "massless", 0, effectiveBShift],
      aShift
      ];
   uSlot = vertexASlot[topo, line["endpoints"][[1]]];
   vSlot = vertexASlot[topo, line["endpoints"][[2]]];
   If[Head[uSlot] === Missing || Head[vSlot] === Missing, Return[$Failed]];
   oldActive = activeAVertexIds[topo];
   newRepMap = vertexRepresentativeMap[topo["vertexIds"], Join[
      ({#, vertexRepresentative[topo, #]} & /@ topo["vertexIds"]),
      {line["endpoints"]}
      ]];
   newActive = DeleteDuplicates[Lookup[newRepMap, topo["vertexIds"]]];
   mergedRep = Lookup[newRepMap, line["endpoints"][[1]]];
   newAList = Table[
     oldSlotsForNewRep = Flatten[Position[Lookup[newRepMap, oldActive], newActive[[i]]]];
     slotValues = aList[[oldSlotsForNewRep]];
     If[newActive[[i]] === mergedRep,
       If[uSlot === vSlot, 2 aList[[uSlot]], Total[slotValues]] - effectiveAShift,
       Total[slotValues]
       ],
     {i, Length[newActive]}
     ];
   newLinePacks[[e]] = {linePacks[[e, 1]] + effectiveBShift};
   J[newAList, newLinePacks, ispList]
   ];


shrinkLinesIntegral[
   topo_Association,
   J[aList_, linePacks_, ispList_],
   specs_List
   ] := Module[
   {selectedLines, oldActive, pairs, newRepMap, newActive, newAList,
    newLinePacks = linePacks, oldSlotsForNewRep, selectedShiftForRep},
   selectedLines = Lookup[specs, "lineIndex"];
   oldActive = activeAVertexIds[topo];
   pairs = topo["lines"][[#, "endpoints"]] & /@ selectedLines;
   newRepMap = vertexRepresentativeMap[topo["vertexIds"], Join[
      ({#, vertexRepresentative[topo, #]} & /@ topo["vertexIds"]),
      pairs
      ]];
   newActive = DeleteDuplicates[Lookup[newRepMap, topo["vertexIds"]]];
   newAList = Table[
     oldSlotsForNewRep = Flatten[Position[Lookup[newRepMap, oldActive], newActive[[i]]]];
     selectedShiftForRep = Total[MapThread[
        If[SameQ @@ Lookup[newRepMap, #1] && First[Lookup[newRepMap, #1]] === newActive[[i]], #2, 0] &,
        {pairs, Lookup[specs, "aShift"]}
        ]];
     Total[aList[[oldSlotsForNewRep]]] - selectedShiftForRep,
     {i, Length[newActive]}
     ];
   Scan[
    Function[spec,
     newLinePacks[[spec["lineIndex"]]] = {
       linePacks[[spec["lineIndex"], 1]] + spec["bShift"]
       }
     ],
    specs
    ];
   J[newAList, newLinePacks, ispList]
   ];


thetaBoundaryAtomicTerms[
   topo_Association,
   J[aList_, linePacks_, ispList_],
   e_Integer,
   vertexId_
   ] := Module[
   {line = topo["lines"][[e]], endpointSlots, endpointSlot, endpointOrientation,
    pack = linePacks[[e]], packType, coeff, shrinkTerms},
   endpointSlots = lineEndpointSlotsAtVertex[line, vertexId];
   If[Length[endpointSlots] =!= 1, Return[{}]];
   endpointSlot = First[endpointSlots];
   endpointOrientation = If[endpointSlot === 1, 1, -1];
   packType = actualLinePackType[topo, e, pack];
   Switch[packType,
    "massiveFull",
    coeff = KroneckerDelta[pack[[2]] + pack[[3]], 1] (-1)^(pack[[endpointSlot + 1]] + thetaBoundarySignOffset[topo, e]);
    shrinkTerms = lineCompiledShrinkTerms[line];
    (<|
        "lineIndex" -> e,
        "coefficient" -> coeff (Lookup[#, "coefficient", 0] /. topo["shrinkPrefactorRules"]),
        "bShift" -> Lookup[#, "bShift", 1],
        "aShift" -> Lookup[#, "bShift", 1]
        |> &) /@ shrinkTerms,
    "masslessFull",
    {<|
      "lineIndex" -> e,
      "coefficient" -> -2 endpointOrientation KroneckerDelta[pack[[2]], 1],
      "bShift" -> 0,
      "aShift" -> 0
      |>},
    _,
    {}
    ]
   ];


thetaBundleKey[topo_Association, e_Integer] := Sort[vertexPosition[topo, #] & /@ topo["lines"][[e, "endpoints"]]];


(* 同一代表顶点对的 full lines 共享一个 theta。共同边界
   Product[A]-Product[B] 在 J=(A+B)/2、D=A-B 基底中只含非空奇数 D 子集，
   k-line contact 的系数为 2^(1-k)。每个子集只合并顶点一次，绝不生成 delta^k。 *)
timeThetaBoundaryShrinkTerms[topo_Association, int : J[aList_, linePacks_, ispList_], vertexId_] := Module[
   {pos, connectedLines, eligibleLines, bundles, oddSubsets, atomicChoices},
   pos = vertexPosition[topo, vertexId];
   If[Head[pos] === Missing, Return[0]];
   connectedLines = topo["vertexLines"][[pos]][[All, 1]];
   eligibleLines = Select[
     connectedLines,
     MemberQ[{"massiveFull", "masslessFull"}, actualLinePackType[topo, #, linePacks[[#]]]] &&
       Length[lineEndpointSlotsAtVertex[topo["lines"][[#]], vertexId]] === 1 &
     ];
   bundles = GatherBy[eligibleLines, thetaBundleKey[topo, #] &];
   Total[Table[
     oddSubsets = Select[Rest[Subsets[bundle]], OddQ[Length[#]] &];
     Total[Table[
       atomicChoices = thetaBoundaryAtomicTerms[topo, int, #, vertexId] & /@ selected;
       If[AnyTrue[atomicChoices, # === {} &],
        0,
        Total[
         Function[choice,
            2^(1 - Length[selected]) Times @@ Lookup[choice, "coefficient"] *
             shrinkLinesIntegral[topo, int, KeyDrop[#, "coefficient"] & /@ choice]
            ] /@ Tuples[atomicChoices]
         ]
        ],
       {selected, oddSubsets}
       ]],
     {bundle, bundles}
     ]]
   ];


seedUnsupportedPendingFeatures[topo_Association] := DeleteDuplicates@Join[
    unsupportedSeedFeaturesForTopology[topo]
    ];


momentumIBPPendingFeatures[topo_Association] := seedUnsupportedPendingFeatures[topo];


timeIBPPendingFeatures[topo_Association] := DeleteDuplicates@Join[
    seedUnsupportedPendingFeatures[topo],
    If[thetaFullLineIndices[topo] =!= {}, {"shrinkSectorSeedGeneration"}, {}]
    ];


timeGeneratorLabel[gen_Association] := {gen["type"], gen["vertex"]};


applyTimeGeneratorSeed::badgen = "time seed 只能使用 time 生成元，收到：`1`。";


applyTimeGeneratorSeed[topo_Association, int_J, gen_Association] := Module[
   {vertexId},
   If[gen["type"] =!= "time",
    Message[applyTimeGeneratorSeed::badgen, gen];
    Return[$Failed]
    ];
   vertexId = gen["vertex"];
   Expand[
    timeVertexPowerTerm[topo, int, vertexId] +
     timeExternalEnergyTerm[topo, int, vertexId] +
     timeMasslessEndpointDerivativeTerms[topo, int, vertexId] +
     timeMassiveBuildingBlockDerivativeTerms[topo, int, vertexId] +
     timeThetaBoundaryShrinkTerms[topo, int, vertexId]
    ]
   ];


Options[makeTimeIBPSeedBatch] = {
   UseSampleOnly -> Automatic,
   MaxSeedRuleCount -> Automatic,
   DiscreteMode -> Automatic,
   MaxDiscreteRuleCount -> Automatic,
   MaxEquationCount -> Automatic,
   ApplyNumericRules -> False
   };
makeTimeIBPSeedBatch::toomany =
   "拓扑 `1` 的 time seed 方程数为 `2`，超过上限 `3`；未展开方程。";


makeTimeIBPSeedBatch[topo_Association, OptionsPattern[]] := Module[
   {baseIntegral, continuousDataByGenerator, continuousCounts, commonContinuousQ, legacyContinuousCount,
    legacyContinuousRules, discreteData, timeGenerators, equationCount,
    maxEquationCount, genTemplates, equations, pendingFeatures, topologyReport},
   topologyReport = topologyValidationReport[topo];
   If[topologyValidationErrorQ[topologyReport],
    Return[<|"status" -> "invalidTopology", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "equations" -> {}|>]
    ];
   baseIntegral = makeBaseIntegral[topo];
   discreteData = selectedDiscreteSeedRules[
     topo,
     DiscreteMode -> OptionValue[DiscreteMode],
     MaxDiscreteRuleCount -> OptionValue[MaxDiscreteRuleCount]
     ];
   If[discreteData["status"] =!= "generated",
    Return[Join[discreteData, <|"caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "equations" -> {}|>]]
   ];
   timeGenerators = Select[makeIBPGenerators[topo], #["type"] === "time" &];
   continuousDataByGenerator = Table[
     With[{label = timeGeneratorLabel[generator]},
      Join[
       <|"generator" -> label|>,
       makeGeneratorContinuousSeedRules[
        topo,
        label,
        UseSampleOnly -> OptionValue[UseSampleOnly],
        MaxSeedRuleCount -> OptionValue[MaxSeedRuleCount]
        ]
       ]
      ],
     {generator, timeGenerators}
     ];
   If[AnyTrue[continuousDataByGenerator, Lookup[#, "status", "missing"] =!= "generated" &],
    Return[<|"status" -> "invalidGeneratorSeedRanges", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport,
      "generatorContinuousSeedData" -> (KeyDrop[#, "rules"] & /@ continuousDataByGenerator), "equations" -> {}|>]
    ];
   continuousCounts = Lookup[continuousDataByGenerator, "ruleCount", 0];
   commonContinuousQ = Length[continuousDataByGenerator] == 0 || SameQ @@ Lookup[continuousDataByGenerator, "rules", {}];
   legacyContinuousCount = If[Length[continuousCounts] == 0, 0, If[commonContinuousQ, First[continuousCounts], Total[continuousCounts]]];
   legacyContinuousRules = If[Length[continuousDataByGenerator] > 0 && commonContinuousQ, First[Lookup[continuousDataByGenerator, "rules"]], {}];
   equationCount = Total[continuousCounts] discreteData["ruleCount"];
   maxEquationCount = resolveSeedOption[topo, "MaxEquationCount", OptionValue[MaxEquationCount], 80];
   If[equationCount > maxEquationCount,
    Message[makeTimeIBPSeedBatch::toomany, topo["name"], equationCount, maxEquationCount];
    Return[<|
      "status" -> "tooMany",
      "caseName" -> topo["name"],
      "topologyValidationReport" -> topologyReport,
      "continuousSeedRuleCount" -> legacyContinuousCount,
      "generatorContinuousSeedData" -> (KeyDrop[#, "rules"] & /@ continuousDataByGenerator),
      "discreteRuleCount" -> discreteData["ruleCount"],
      "timeGeneratorCount" -> Length[timeGenerators],
      "equationCount" -> equationCount,
      "equations" -> {}
      |>]
   ];
   genTemplates = MapThread[
     <|"generatorData" -> #1, "generator" -> timeGeneratorLabel[#1],
       "template" -> applyTimeGeneratorSeed[topo, baseIntegral, #1], "continuousData" -> #2|> &,
     {timeGenerators, continuousDataByGenerator}
     ];
   If[MemberQ[Lookup[genTemplates, "template"], $Failed], Return[<|"status" -> "failed", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport|>]];
   pendingFeatures = timeIBPPendingFeatures[topo];
   equations = Flatten[
     Table[
      Module[{rules = Join[continuousRule, discreteRule], expr},
       expr = genTemplate["template"] /. rules;
       expr = applySeedCanonical[expr, topo];
       If[TrueQ[OptionValue[ApplyNumericRules]], expr = expr /. topo["numericRules"]];
       <|
        "generator" -> genTemplate["generator"],
        "continuousRules" -> continuousRule,
        "discreteRules" -> discreteRule,
        "equation" -> Expand[expr],
        "forbiddenNData" -> forbiddenNData[topo, expr],
        "eomCanonicalQ" -> ! containsForbiddenNQ[topo, expr]
        |>
       ],
      {genTemplate, genTemplates},
      {continuousRule, genTemplate["continuousData"]["rules"]},
      {discreteRule, discreteData["rules"]}
      ],
     2
     ];
   <|
    "status" -> "generated",
    "caseName" -> topo["name"],
    "topologyValidationReport" -> topologyReport,
    "continuousSeedRuleCount" -> legacyContinuousCount,
    "continuousSeedRuleCountTotal" -> Total[continuousCounts],
    "discreteRuleCount" -> discreteData["ruleCount"],
    "timeGeneratorCount" -> Length[timeGenerators],
    "equationCount" -> Length[equations],
    "eomCanonicalQ" -> And @@ Lookup[equations, "eomCanonicalQ"],
    "forbiddenNData" -> DeleteCases[Flatten[Lookup[equations, "forbiddenNData"]], Null],
    "generators" -> timeGeneratorLabel /@ timeGenerators,
    "continuousSeedRules" -> legacyContinuousRules,
    "generatorSpecificContinuousRangesQ" -> AnyTrue[continuousDataByGenerator, Lookup[#, "rangeSource", "uniform"] === "generatorOverride" &],
    "generatorContinuousSeedData" -> (KeyDrop[#, "rules"] & /@ continuousDataByGenerator),
    "discreteRules" -> discreteData["rules"],
    "pendingFeatures" -> pendingFeatures,
    "completeTimeIBPQ" -> TrueQ[pendingFeatures === {}],
    "equations" -> equations
    |>
   ];
(* ::Chapter:: *)
(*seed 范围与批量 momentum seed*)

(* 本章把用户给出的 seedRanges 转成受保护的替换规则，并生成小批 momentum seed。
   默认尊重 sampleOnly，只使用基准连续指标和手选离散态，避免无意中展开整个 family。 *)

rangeValuesFromSpec[spec_] := Which[
   Head[spec] === Missing, {0},
   ListQ[spec] && Length[spec] == 2 && And @@ (IntegerQ /@ spec), Range[spec[[1]], spec[[2]]],
   ListQ[spec], spec,
   IntegerQ[spec], {spec},
   True, {0}
   ];


seedRangeValues[topo_Association, key_] := rangeValuesFromSpec[Lookup[topo["seedRanges"], key, Missing["NotSet"]]];


indexVariableQ[x_] := ! TrueQ[IntegerQ[x] || NumericQ[x]];


continuousIndexVariables[J[aList_, linePacks_, ispList_]] := Select[Join[aList, linePacks[[All, 1]], ispList], indexVariableQ];


continuousIndexValueLists[topo_Association, J[aList_, linePacks_, ispList_], useSampleOnly_] := Module[
   {aValues, bValues, ispValues, globalISPRangeQ, globalISPValues},
   aValues = ConstantArray[If[TrueQ[useSampleOnly], {0}, seedRangeValues[topo, "a"]], Count[aList, _?indexVariableQ]];
   bValues = ConstantArray[If[TrueQ[useSampleOnly], {0}, seedRangeValues[topo, "b"]], Count[linePacks[[All, 1]], _?indexVariableQ]];
   globalISPRangeQ = KeyExistsQ[topo["seedRanges"], "isp"];
   globalISPValues = seedRangeValues[topo, "isp"];
   ispValues = Table[
     If[TrueQ[useSampleOnly],
      {0},
      If[globalISPRangeQ,
       globalISPValues,
       rangeValuesFromSpec[Lookup[topo["ispData"][[j]], "range", Missing["NotSet"]]]
       ]
      ],
     {j, Length[ispList]}
     ];
   Join[aValues, bValues, ispValues]
   ];


resolveUseSampleOnly[topo_Association, value_] := If[value === Automatic,
   TrueQ[Lookup[topo["seedRanges"], "sampleOnly", False]],
   TrueQ[value]
   ];


resolveDiscreteMode[topo_Association, value_] := If[value === Automatic,
   Lookup[Lookup[topo, "seedOptions", <||>], "DiscreteMode", "sample"],
   value
   ];


resolveSeedOption[topo_Association, key_String, value_, default_] := If[value === Automatic,
   Lookup[Lookup[topo, "seedOptions", <||>], key, default],
   value
   ];


Options[makeContinuousSeedRules] = {UseSampleOnly -> Automatic, MaxSeedRuleCount -> Automatic};
makeContinuousSeedRules::toomany =
   "拓扑 `1` 的连续 seed 规则数为 `2`，超过上限 `3`；未生成规则。";


makeContinuousSeedRules[topo_Association, OptionsPattern[]] := Module[
   {baseIntegral, useSampleOnly, vars, valueLists, ruleCount, maxCount, rules},
   baseIntegral = makeBaseIntegral[topo];
   useSampleOnly = resolveUseSampleOnly[topo, OptionValue[UseSampleOnly]];
   vars = continuousIndexVariables[baseIntegral];
   valueLists = continuousIndexValueLists[topo, baseIntegral, useSampleOnly];
   ruleCount = Times @@ (Length /@ valueLists);
   maxCount = resolveSeedOption[topo, "MaxSeedRuleCount", OptionValue[MaxSeedRuleCount], 200];
   If[ruleCount > maxCount,
    Message[makeContinuousSeedRules::toomany, topo["name"], ruleCount, maxCount];
    Return[<|
      "status" -> "tooMany",
      "caseName" -> topo["name"],
      "useSampleOnly" -> useSampleOnly,
      "variables" -> vars,
      "valueLists" -> valueLists,
      "ruleCount" -> ruleCount,
      "rules" -> {}
      |>]
    ];
   rules = If[Length[vars] == 0,
     {{}},
     Thread[vars -> #] & /@ Tuples[valueLists]
     ];
   <|
    "status" -> "generated",
    "caseName" -> topo["name"],
    "useSampleOnly" -> useSampleOnly,
    "variables" -> vars,
    "valueLists" -> valueLists,
    "ruleCount" -> Length[rules],
    "rules" -> rules
    |>
   ];


(* generatorSeedRanges 是统一 seedRanges 之上的稀疏覆盖层。
   同一 sector/generator 只允许一条记录；未覆盖变量沿用统一范围。 *)
generatorSeedRangeMatches[topo_Association, generatorLabel_List] := Select[
   Lookup[topo, "generatorSeedRanges", {}],
   Lookup[#, "sectorKey", Missing["sectorKey"]] === sectorKeyFromShrunkLines[Lookup[topo, "sectorShrunkLines", {}]] &&
     Lookup[#, "generator", Missing["generator"]] === generatorLabel &
   ];


Options[makeGeneratorContinuousSeedRules] = Options[makeContinuousSeedRules];
makeGeneratorContinuousSeedRules[topo_Association, generatorLabel_List, OptionsPattern[]] := Module[
   {matches, baseData, useSampleOnly, baseIntegral, vars, baseValueLists, configuredRules,
    configuredVars, duplicateVars, unknownVars, valueLists, ruleCount, maxCount, rules, sectorKey},
   sectorKey = sectorKeyFromShrunkLines[Lookup[topo, "sectorShrunkLines", {}]];
   useSampleOnly = resolveUseSampleOnly[topo, OptionValue[UseSampleOnly]];
   matches = generatorSeedRangeMatches[topo, generatorLabel];
   If[useSampleOnly || matches === {},
    baseData = makeContinuousSeedRules[
      topo,
      UseSampleOnly -> OptionValue[UseSampleOnly],
      MaxSeedRuleCount -> OptionValue[MaxSeedRuleCount]
      ];
    Return[Join[baseData, <|"sectorKey" -> sectorKey, "rangeSource" -> "uniform",
       "configuredRanges" -> {}, "generatorOverrideIgnoredBySampleOnlyQ" -> TrueQ[useSampleOnly && matches =!= {}]|>]]
    ];
   If[Length[matches] =!= 1,
    Return[<|"status" -> "duplicateGeneratorRangeEntries", "caseName" -> topo["name"],
      "sectorKey" -> sectorKey, "generator" -> generatorLabel, "entryCount" -> Length[matches], "rules" -> {}|>]
    ];
   baseIntegral = makeBaseIntegral[topo];
   vars = continuousIndexVariables[baseIntegral];
   baseValueLists = continuousIndexValueLists[topo, baseIntegral, False];
   configuredRules = matches[[1]]["ranges"];
   configuredVars = First /@ configuredRules;
   duplicateVars = Cases[Tally[configuredVars], {var_, count_} /; count > 1 :> var];
   unknownVars = Select[configuredVars, Function[var, ! AnyTrue[vars, SameQ[#, var] &]]];
   If[duplicateVars =!= {} || unknownVars =!= {},
    Return[<|"status" -> "invalidGeneratorRangeVariables", "caseName" -> topo["name"],
      "sectorKey" -> sectorKey, "generator" -> generatorLabel, "variables" -> vars,
      "duplicateVariables" -> duplicateVars, "unknownVariables" -> unknownVars, "rules" -> {}|>]
    ];
   valueLists = MapThread[
     Function[{var, fallback},
      With[{match = SelectFirst[configuredRules, SameQ[First[#], var] &, Missing["NotConfigured"]]},
       If[Head[match] === Missing, fallback, rangeValuesFromSpec[Last[match]]]
       ]
      ],
     {vars, baseValueLists}
     ];
   ruleCount = Times @@ (Length /@ valueLists);
   maxCount = resolveSeedOption[topo, "MaxSeedRuleCount", OptionValue[MaxSeedRuleCount], 200];
   If[ruleCount > maxCount,
    Message[makeContinuousSeedRules::toomany, topo["name"] <> "/" <> ToString[generatorLabel, InputForm], ruleCount, maxCount];
    Return[<|"status" -> "tooMany", "caseName" -> topo["name"], "sectorKey" -> sectorKey,
      "generator" -> generatorLabel, "rangeSource" -> "generatorOverride", "useSampleOnly" -> False,
      "variables" -> vars, "valueLists" -> valueLists, "configuredRanges" -> configuredRules,
      "ruleCount" -> ruleCount, "rules" -> {}|>]
    ];
   rules = If[vars === {}, {{}}, Thread[vars -> #] & /@ Tuples[valueLists]];
   <|"status" -> "generated", "caseName" -> topo["name"], "sectorKey" -> sectorKey,
    "generator" -> generatorLabel, "rangeSource" -> "generatorOverride", "useSampleOnly" -> False,
    "variables" -> vars, "valueLists" -> valueLists, "configuredRanges" -> configuredRules,
    "ruleCount" -> Length[rules], "rules" -> rules|>
   ];


Options[selectedDiscreteSeedRules] = {DiscreteMode -> Automatic, MaxDiscreteRuleCount -> Automatic};
selectedDiscreteSeedRules::toomany =
   "拓扑 `1` 的离散态数为 `2`，超过上限 `3`；未生成 all 离散规则。";


selectedDiscreteSeedRules[topo_Association, OptionsPattern[]] := Module[
   {mode, maxCount, rules, count, coverageIssues, shapeIssues},
   mode = resolveDiscreteMode[topo, OptionValue[DiscreteMode]];
   maxCount = resolveSeedOption[topo, "MaxDiscreteRuleCount", OptionValue[MaxDiscreteRuleCount], 64];
   Switch[mode,
    "none",
    rules = {{}},
     "sample",
     rules = If[Length[topo["sampleDiscreteRules"]] > 0, topo["sampleDiscreteRules"], {{}}];
     shapeIssues = sampleDiscreteRulesShapeIssues[rules];
     If[shapeIssues =!= {},
      Return[<|"status" -> "malformedSampleDiscreteRules", "mode" -> mode, "ruleCount" -> 0, "shapeIssues" -> shapeIssues, "rules" -> {}|>]
      ];
     coverageIssues = sampleDiscreteRuleCoverageIssues[topo, rules];
    If[coverageIssues =!= {},
     Return[<|"status" -> "incompleteSampleDiscreteRules", "mode" -> mode, "ruleCount" -> Length[rules], "coverageIssues" -> coverageIssues, "rules" -> {}|>]
     ],
    "all",
    count = discreteStateCount[topo];
    If[count > maxCount,
     Message[selectedDiscreteSeedRules::toomany, topo["name"], count, maxCount];
     Return[<|"status" -> "tooMany", "mode" -> mode, "ruleCount" -> count, "rules" -> {}|>]
     ];
    rules = enumerateDiscreteStates[makeBaseIntegral[topo], topo]["rules"],
    _,
    rules = If[Length[topo["sampleDiscreteRules"]] > 0, topo["sampleDiscreteRules"], {{}}]
    ];
   <|"status" -> "generated", "mode" -> mode, "ruleCount" -> Length[rules], "rules" -> rules|>
   ];


momentumGeneratorLabel[gen_Association] := {gen["type"], gen["dLoop"], gen["vectorType"], gen["vectorIndex"]};


(* ::Chapter:: *)
(*独立变量导数 seed*)

(* 本章生成微分方程阶段使用的独立变量导数。顶点能量 ke[i] 只微分顶点相位；
   外部不变量先在约束坐标中解成外动量矢量导数 k_i.d/dk_j 的线性组合，解的 basis 显式返回。 *)

externalVectorDerivativeGenerators[topo_Association] := Flatten[
   Table[
    <|
     "type" -> "externalVector",
     "vectorIndex" -> i,
     "dExternal" -> j,
     "vector" -> topo["externalMomenta"][[i]]
     |>,
    {i, topo["nK"]}, {j, topo["nK"]}
    ],
   1
   ];


externalVectorDerivativeGeneratorBasis[topo_Association, Automatic] := externalVectorDerivativeGeneratorBasis[topo, "upperTriangular"];
externalVectorDerivativeGeneratorBasis[topo_Association, "upperTriangular"] := Flatten[
   Table[
    If[i <= j,
     <|
      "type" -> "externalVector",
      "vectorIndex" -> i,
      "dExternal" -> j,
      "vector" -> topo["externalMomenta"][[i]]
      |>,
     Nothing
     ],
    {i, topo["nK"]}, {j, topo["nK"]}
    ],
   1
   ];
externalVectorDerivativeGeneratorBasis[topo_Association, "all"] := externalVectorDerivativeGenerators[topo];
externalVectorDerivativeGeneratorBasis[topo_Association, gens_List] := gens;
externalVectorDerivativeGeneratorBasis[topo_Association, _] := externalVectorDerivativeGeneratorBasis[topo, "upperTriangular"];


externalVectorDerivativeLabel[gen_Association] := {gen["type"], gen["vectorIndex"], gen["dExternal"]};


externalVectorSPCoordinateDerivative[topo_Association, coordinate_, gen_Association] := Module[
   {dExternal = gen["dExternal"], vector = gen["vector"], loops = topo["loopMomenta"], exts = topo["externalMomenta"]},
   Expand[
    coordinate /. {
      HoldPattern[qq[_Integer, _Integer]] :> 0,
      HoldPattern[qk[i_Integer, j_Integer]] :>
       If[j === dExternal, expandDotExpr[loops[[i]], vector, topo], 0],
      HoldPattern[kk[i_Integer, j_Integer]] :>
       If[i === dExternal, expandDotExpr[vector, exts[[j]], topo], 0] +
        If[j === dExternal, expandDotExpr[exts[[i]], vector, topo], 0]
      }
   ]
   ];


(* 对非线性动力学量表达式必须显式执行链式法则，不能把坐标直接替成其方向导数。 *)
externalVectorDirectionalSPDerivative[topo_Association, expr_, gen_Association] := Module[
   {coordinates},
   coordinates = DeleteDuplicates[Cases[expr, _qq | _qk | _kk, {0, Infinity}]];
   Expand[Total[
     D[expr, #] externalVectorSPCoordinateDerivative[topo, #, gen] & /@ coordinates
     ]]
   ];


externalVectorPropagatorDerivativeTerms[topo_Association, int_J, gen_Association, repSP2ZRules_List] := Module[
   {dExternal, vector, lineMomenta, extCoeff, vDotQ, shiftedInt},
   dExternal = gen["dExternal"];
   vector = gen["vector"];
   lineMomenta = Lookup[topo["lines"], "momentum"];
   Total[
    Table[
     extCoeff = Coefficient[lineMomenta[[e]], topo["externalMomenta"][[dExternal]]];
     If[zeroQ[extCoeff] || externalLegCoordinateLineQ[lineMomenta[[e]], topo],
      0,
      vDotQ = Expand[expandDotExpr[vector, lineMomenta[[e]], topo] /. repSP2ZRules];
      shiftedInt = shiftLineB[int, e, 2];
      -extCoeff linePowerIndex[topo, int, e] absorbLinearFactor[vDotQ, shiftedInt, topo]
      ],
     {e, topo["nE"]}
     ]
    ]
   ];


(* 外部动力学量导数与 qIBP 共用最终 AT 编译结果；WT 只用于 theta shrink。 *)
externalVectorBuildingBlockDerivativeTerms[topo_Association, int_J, gen_Association, repSP2ZRules_List] := Module[
   {dExternal, vector, lineMomenta, lines, extCoeff, vDotQ,
    shiftedInt, packType, sigma},
   dExternal = gen["dExternal"];
   vector = gen["vector"];
   lineMomenta = Lookup[topo["lines"], "momentum"];
   lines = topo["lines"];
   Total[
    Table[
     extCoeff = Coefficient[lineMomenta[[e]], topo["externalMomenta"][[dExternal]]];
     If[zeroQ[extCoeff] || externalLegCoordinateLineQ[lineMomenta[[e]], topo],
      0,
      vDotQ = Expand[expandDotExpr[vector, lineMomenta[[e]], topo] /. repSP2ZRules];
      packType = lines[[e]]["packType"];
      Switch[packType,
       "massiveFull" | "massiveCross",
       Total[
        Table[
         extCoeff compiledMomentumEndpointDerivativeTerms[
           topo, int, e, endpointSlot, vDotQ
           ],
         {endpointSlot, 2}
         ]
        ],
       "masslessFull",
       sigma = masslessFullSKSign[lines[[e]]];
       shiftedInt = shiftLineB[toggleMasslessLineState[int, e], e, 1];
       extCoeff (
         -I sigma absorbLinearFactor[
           vDotQ,
           shiftVertexA[shiftedInt, topo, lines[[e]]["endpoints"][[1]], 1],
           topo
           ] +
          I sigma absorbLinearFactor[
           vDotQ,
           shiftVertexA[shiftedInt, topo, lines[[e]]["endpoints"][[2]], 1],
           topo
           ]
         ),
       "masslessCross",
       shiftedInt = shiftLineB[int, e, 1];
       extCoeff Total[
         Table[
          -I skEndpointPhaseSign[lines[[e]], endpointSlot] absorbLinearFactor[
            vDotQ,
            shiftVertexA[shiftedInt, topo, lines[[e]]["endpoints"][[endpointSlot]], 1],
            topo
            ],
          {endpointSlot, 2}
          ]
         ],
       _,
       0
       ]
      ],
     {e, topo["nE"]}
     ]
    ]
   ];


externalVectorISPDerivativeTerms[topo_Association, int_J, gen_Association, repSP2ZRules_List] := Module[
   {ispExprs, exponent, derivative},
   ispExprs = normalizeISPExprs[topo];
   Total[
    Table[
     exponent = int[[3, j]];
     If[zeroQ[exponent],
      0,
      derivative = Expand[externalVectorDirectionalSPDerivative[topo, ispExprs[[j]], gen] /. repSP2ZRules];
      exponent absorbLinearFactor[
        derivative,
        shiftISPIndex[int, j, -1],
        topo
        ]
      ],
     {j, Length[ispExprs]}
     ]
    ]
   ];


externalVectorVertexEnergyDerivativeTerms[topo_Association, int_J, gen_Association] := Module[
   {vertices = activeAVertexIds[topo], derivative},
   Total[
    Table[
     derivative = externalVectorDirectionalSPDerivative[topo, vertexExternalEnergy[topo, vertexId], gen];
     If[zeroQ[derivative],
      0,
      -vertexExternalPhaseDerivativeCoefficient[topo, vertexId] derivative shiftVertexA[int, topo, vertexId, 1]
      ],
     {vertexId, vertices}
     ]
    ]
   ];


applyExternalVectorDerivativeSeed::badgen = "external-vector seed 只能使用 externalVector 生成元，收到：`1`。";
applyExternalVectorDerivativeSeed::nosp =
   "拓扑 `1` 的标量积到 z/ISP 规则未生成：`2`。请补充 ISP 配置后再生成 external-vector seed。";


applyExternalVectorDerivativeSeed[topo_Association, int_J, gen_Association] := Module[
   {ruleData},
   If[gen["type"] =!= "externalVector",
    Message[applyExternalVectorDerivativeSeed::badgen, gen];
    Return[$Failed]
    ];
   ruleData = makeScalarProductRules[topo];
   If[Lookup[ruleData, "status", "notComputed"] =!= "computed",
    Message[applyExternalVectorDerivativeSeed::nosp, topo["name"], Lookup[ruleData, "reason", Missing["reason"]]];
    Return[$Failed]
    ];
   Expand[
    externalVectorPropagatorDerivativeTerms[topo, int, gen, ruleData["repSP2Z"]] +
     externalVectorBuildingBlockDerivativeTerms[topo, int, gen, ruleData["repSP2Z"]] +
     externalVectorISPDerivativeTerms[topo, int, gen, ruleData["repSP2Z"]] +
     externalVectorVertexEnergyDerivativeTerms[topo, int, gen]
    ]
   ];


Options[makeExternalInvariantDerivativeDecomposition] = {
   ExternalInvariantCoordinateVariables -> Automatic,
   ExternalVectorOperatorBasis -> Automatic
   };

makeExternalInvariantDerivativeDecomposition::badvar =
   "变量 `1` 不在当前外部不变量坐标 `2` 中；若它是组合变量，请显式给出 ExternalInvariantCoordinateVariables。";
makeExternalInvariantDerivativeDecomposition::nosol =
   "变量 `1` 无法由所选 external-vector operator basis `2` 解出。";


normalizeExternalInvariantCoordinateList[topo_Association, Automatic] := externalInvariantVariables[topo];
normalizeExternalInvariantCoordinateList[topo_Association, coords_List] := scalarProductInputToInternal[#, topo] & /@ coords;
normalizeExternalInvariantCoordinateList[topo_Association, coord_] := {scalarProductInputToInternal[coord, topo]};


makeExternalInvariantDerivativeDecomposition[topo_Association, var_, OptionsPattern[]] := Module[
   {target, coords, targetPos, gens, matrix, coeffs, equations, solutions, selectedRules,
    selectedCoefficients, residual, fullGens, fullMatrix, rank, nullity, freeCoeffRules},
   target = scalarProductInputToInternal[var, topo];
   coords = normalizeExternalInvariantCoordinateList[topo, OptionValue[ExternalInvariantCoordinateVariables]];
   targetPos = FirstPosition[coords, target, Missing["NotFound"]];
   If[Head[targetPos] === Missing,
    Message[makeExternalInvariantDerivativeDecomposition::badvar, var, scalarProductInternalToUser[#, topo] & /@ coords];
    Return[<|"status" -> "badVariable", "targetVariable" -> scalarProductInternalToUser[target, topo], "coordinateVariables" -> scalarProductInternalToUser[#, topo] & /@ coords|>]
    ];
   targetPos = First[targetPos];
   gens = externalVectorDerivativeGeneratorBasis[topo, OptionValue[ExternalVectorOperatorBasis]];
   matrix = Table[
     externalVectorDirectionalSPDerivative[topo, coords[[r]], gens[[c]]],
     {r, Length[coords]}, {c, Length[gens]}
     ];
   coeffs = Array[cv, Length[gens]];
   equations = Thread[matrix . coeffs == UnitVector[Length[coords], targetPos]];
   solutions = Quiet[Solve[equations, coeffs]];
   If[solutions === {},
    Message[makeExternalInvariantDerivativeDecomposition::nosol, var, externalVectorDerivativeLabel /@ gens];
    Return[<|"status" -> "noSolution", "targetVariable" -> scalarProductInternalToUser[target, topo], "operatorBasis" -> externalVectorDerivativeLabel /@ gens, "matrix" -> matrix|>]
    ];
   selectedRules = First[solutions];
   freeCoeffRules = Thread[Complement[coeffs, selectedRules[[All, 1]]] -> 0];
   selectedCoefficients = Expand[coeffs /. selectedRules /. freeCoeffRules];
   residual = Simplify[Expand[matrix . selectedCoefficients - UnitVector[Length[coords], targetPos]]];
   fullGens = externalVectorDerivativeGenerators[topo];
   fullMatrix = Table[
     externalVectorDirectionalSPDerivative[topo, coords[[r]], fullGens[[c]]],
     {r, Length[coords]}, {c, Length[fullGens]}
     ];
   rank = Quiet[MatrixRank[fullMatrix]];
   nullity = If[IntegerQ[rank], Length[fullGens] - rank, Missing["SymbolicRankNotComputed"]];
   <|
    "status" -> "solved",
    "targetVariable" -> scalarProductInternalToUser[target, topo],
    "internalTargetVariable" -> target,
    "coordinateVariables" -> (scalarProductInternalToUser[#, topo] & /@ coords),
    "internalCoordinateVariables" -> coords,
    "operatorBasis" -> (externalVectorDerivativeLabel /@ gens),
    "operators" -> gens,
    "matrix" -> matrix,
    "coefficientRules" -> Thread[externalVectorDerivativeLabel /@ gens -> selectedCoefficients],
    "coefficients" -> selectedCoefficients,
    "residual" -> residual,
    "solutionFamilyRules" -> solutions,
    "fullOperatorCount" -> Length[fullGens],
    "coordinateCount" -> Length[coords],
    "fullOperatorRank" -> rank,
    "nullity" -> nullity,
    "nonUniqueQ" -> TrueQ[IntegerQ[nullity] && nullity > 0]
    |>
   ];


directVertexEnergyVariableDerivativeSeed[topo_Association, int_J, var_] := Module[
   {internalVar, vertices = activeAVertexIds[topo], derivative},
   internalVar = scalarProductInputToInternal[var, topo];
   Total[
    Table[
     derivative = D[vertexExternalEnergy[topo, vertexId], internalVar];
     If[zeroQ[derivative],
      0,
      -vertexExternalPhaseDerivativeCoefficient[topo, vertexId] derivative shiftVertexA[int, topo, vertexId, 1]
      ],
     {vertexId, vertices}
     ]
    ]
   ];


Options[applyExternalInvariantVariableDerivativeSeed] = Options[makeExternalInvariantDerivativeDecomposition];
applyExternalInvariantVariableDerivativeSeed[topo_Association, int_J, var_, opts : OptionsPattern[]] := Module[
   {decomp, terms},
   decomp = makeExternalInvariantDerivativeDecomposition[topo, var, FilterRules[{opts}, Options[makeExternalInvariantDerivativeDecomposition]]];
   If[Lookup[decomp, "status", "failed"] =!= "solved", Return[$Failed]];
   terms = MapThread[
     #1 applyExternalVectorDerivativeSeed[topo, int, #2] &,
     {decomp["coefficients"], decomp["operators"]}
     ];
   Expand[Total[terms]]
   ];


Options[applyIndependentVariableDerivativeSeed] = Options[makeExternalInvariantDerivativeDecomposition];
applyIndependentVariableDerivativeSeed[topo_Association, int_J, var_, opts : OptionsPattern[]] := Module[
   {internalVar},
   internalVar = scalarProductInputToInternal[var, topo];
   If[MemberQ[externalInvariantVariables[topo], internalVar],
    Return[applyExternalInvariantVariableDerivativeSeed[topo, int, internalVar, opts]]
    ];
   Expand[directVertexEnergyVariableDerivativeSeed[topo, int, internalVar]]
   ];


(* 独立变量集合按 external invariant 坐标与未被其表达的顶点能量参数组成。*)
independentVariableDerivativeVariables[topo_Association] := DeleteDuplicates@Join[
   externalInvariantVariables[topo],
   Complement[vertexEnergyVariables[topo], externalInvariantVariables[topo]]
   ];


independentVariableDerivativeKind[topo_Association, var_] := If[
   MemberQ[externalInvariantVariables[topo], var],
   "externalInvariant",
   "vertexEnergy"
   ];


makeIndependentVariableDerivativeGenerators[topo_Association] :=
  (<|
      "variable" -> #,
      "userVariable" -> scalarProductInternalToUser[#, topo],
      "kind" -> independentVariableDerivativeKind[topo, #]
      |> &) /@ independentVariableDerivativeVariables[topo];


Options[makeIndependentVariableDerivativeSeedBatch] = Options[makeExternalInvariantDerivativeDecomposition];
makeIndependentVariableDerivativeSeedBatch[topo_Association, int_J, opts : OptionsPattern[]] := Module[
   {generators, results, derivative, decomposition, kind, variable, failureQ},
   generators = makeIndependentVariableDerivativeGenerators[topo];
   results = Table[
     variable = generator["variable"];
     kind = generator["kind"];
     decomposition = If[kind === "externalInvariant",
       makeExternalInvariantDerivativeDecomposition[
        topo,
        variable,
        FilterRules[{opts}, Options[makeExternalInvariantDerivativeDecomposition]]
        ],
       Missing["NotApplicable"]
       ];
     derivative = If[kind === "externalInvariant" && Lookup[decomposition, "status", "failed"] =!= "solved",
       $Failed,
       applyIndependentVariableDerivativeSeed[
        topo,
        int,
        variable,
        Sequence @@ FilterRules[{opts}, Options[makeExternalInvariantDerivativeDecomposition]]
        ]
       ];
     derivative = If[derivative === $Failed, $Failed, applySeedCanonical[Expand[derivative], topo]];
     <|
      "variable" -> variable,
      "userVariable" -> generator["userVariable"],
      "kind" -> kind,
      "decomposition" -> decomposition,
      "derivative" -> derivative,
      "status" -> If[derivative === $Failed, "failed", "generated"],
      "forbiddenNData" -> If[derivative === $Failed, {}, forbiddenNData[topo, derivative]],
      "canonicalQ" -> If[derivative === $Failed, False, ! containsForbiddenNQ[topo, derivative]]
      |>,
     {generator, generators}
     ];
   failureQ = AnyTrue[results, Lookup[#, "status", "failed"] =!= "generated" &];
   <|
    "status" -> If[failureQ, "failed", "generated"],
    "caseName" -> Lookup[topo, "name", Missing["caseName"]],
    "variables" -> generators,
    "variableCount" -> Length[generators],
    "integral" -> int,
    "equationCount" -> Length[results],
    "equations" -> results,
    "allCanonicalQ" -> And @@ Lookup[results, "canonicalQ", True],
    "failedVariables" -> Lookup[Select[results, Lookup[#, "status", "failed"] =!= "generated" &], "userVariable", {}]
    |>
   ];


Options[makeMomentumIBPSeedBatch] = {
   UseSampleOnly -> Automatic,
   MaxSeedRuleCount -> Automatic,
   DiscreteMode -> Automatic,
   MaxDiscreteRuleCount -> Automatic,
   MaxEquationCount -> Automatic,
   ApplyNumericRules -> False
   };
makeMomentumIBPSeedBatch::toomany =
   "拓扑 `1` 的 momentum seed 方程数为 `2`，超过上限 `3`；未展开方程。";


makeMomentumIBPSeedBatch[topo_Association, OptionsPattern[]] := Module[
   {baseIntegral, continuousDataByGenerator, continuousCounts, commonContinuousQ, legacyContinuousCount,
    legacyContinuousRules, discreteData, momentumGenerators, equationCount,
    maxEquationCount, genTemplates, equations, pendingFeatures, topologyReport},
   topologyReport = topologyValidationReport[topo];
   If[topologyValidationErrorQ[topologyReport],
    Return[<|"status" -> "invalidTopology", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "equations" -> {}|>]
    ];
   baseIntegral = makeBaseIntegral[topo];
   discreteData = selectedDiscreteSeedRules[
     topo,
     DiscreteMode -> OptionValue[DiscreteMode],
     MaxDiscreteRuleCount -> OptionValue[MaxDiscreteRuleCount]
     ];
   If[discreteData["status"] =!= "generated",
    Return[Join[discreteData, <|"caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "equations" -> {}|>]]
   ];
   momentumGenerators = Select[makeIBPGenerators[topo], #["type"] === "momentum" &];
   continuousDataByGenerator = Table[
     With[{label = momentumGeneratorLabel[generator]},
      Join[
       <|"generator" -> label|>,
       makeGeneratorContinuousSeedRules[
        topo,
        label,
        UseSampleOnly -> OptionValue[UseSampleOnly],
        MaxSeedRuleCount -> OptionValue[MaxSeedRuleCount]
        ]
       ]
      ],
     {generator, momentumGenerators}
     ];
   If[AnyTrue[continuousDataByGenerator, Lookup[#, "status", "missing"] =!= "generated" &],
    Return[<|"status" -> "invalidGeneratorSeedRanges", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport,
      "generatorContinuousSeedData" -> (KeyDrop[#, "rules"] & /@ continuousDataByGenerator), "equations" -> {}|>]
    ];
   continuousCounts = Lookup[continuousDataByGenerator, "ruleCount", 0];
   commonContinuousQ = Length[continuousDataByGenerator] == 0 || SameQ @@ Lookup[continuousDataByGenerator, "rules", {}];
   legacyContinuousCount = If[Length[continuousCounts] == 0, 0, If[commonContinuousQ, First[continuousCounts], Total[continuousCounts]]];
   legacyContinuousRules = If[Length[continuousDataByGenerator] > 0 && commonContinuousQ, First[Lookup[continuousDataByGenerator, "rules"]], {}];
   equationCount = Total[continuousCounts] discreteData["ruleCount"];
   maxEquationCount = resolveSeedOption[topo, "MaxEquationCount", OptionValue[MaxEquationCount], 80];
   If[equationCount > maxEquationCount,
    Message[makeMomentumIBPSeedBatch::toomany, topo["name"], equationCount, maxEquationCount];
    Return[<|
      "status" -> "tooMany",
      "caseName" -> topo["name"],
      "topologyValidationReport" -> topologyReport,
      "continuousSeedRuleCount" -> legacyContinuousCount,
      "generatorContinuousSeedData" -> (KeyDrop[#, "rules"] & /@ continuousDataByGenerator),
      "discreteRuleCount" -> discreteData["ruleCount"],
      "momentumGeneratorCount" -> Length[momentumGenerators],
      "equationCount" -> equationCount,
      "equations" -> {}
      |>]
   ];
   genTemplates = MapThread[
     <|"generatorData" -> #1, "generator" -> momentumGeneratorLabel[#1],
       "template" -> applyMomentumGeneratorSeed[topo, baseIntegral, #1], "continuousData" -> #2|> &,
     {momentumGenerators, continuousDataByGenerator}
     ];
   If[MemberQ[Lookup[genTemplates, "template"], $Failed], Return[<|"status" -> "failed", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport|>]];
   pendingFeatures = momentumIBPPendingFeatures[topo];
   equations = Flatten[
     Table[
      Module[{rules = Join[continuousRule, discreteRule], expr},
       expr = genTemplate["template"] /. rules;
       expr = applySeedCanonical[expr, topo];
       If[TrueQ[OptionValue[ApplyNumericRules]], expr = expr /. topo["numericRules"]];
       <|
        "generator" -> genTemplate["generator"],
        "continuousRules" -> continuousRule,
        "discreteRules" -> discreteRule,
        "equation" -> Expand[expr],
        "forbiddenNData" -> forbiddenNData[topo, expr],
        "eomCanonicalQ" -> ! containsForbiddenNQ[topo, expr]
        |>
       ],
      {genTemplate, genTemplates},
      {continuousRule, genTemplate["continuousData"]["rules"]},
      {discreteRule, discreteData["rules"]}
      ],
     2
     ];
   <|
    "status" -> "generated",
    "caseName" -> topo["name"],
    "topologyValidationReport" -> topologyReport,
    "continuousSeedRuleCount" -> legacyContinuousCount,
    "continuousSeedRuleCountTotal" -> Total[continuousCounts],
    "discreteRuleCount" -> discreteData["ruleCount"],
    "momentumGeneratorCount" -> Length[momentumGenerators],
    "equationCount" -> Length[equations],
    "eomCanonicalQ" -> And @@ Lookup[equations, "eomCanonicalQ"],
    "forbiddenNData" -> DeleteCases[Flatten[Lookup[equations, "forbiddenNData"]], Null],
    "generators" -> momentumGeneratorLabel /@ momentumGenerators,
    "continuousSeedRules" -> legacyContinuousRules,
    "generatorSpecificContinuousRangesQ" -> AnyTrue[continuousDataByGenerator, Lookup[#, "rangeSource", "uniform"] === "generatorOverride" &],
    "generatorContinuousSeedData" -> (KeyDrop[#, "rules"] & /@ continuousDataByGenerator),
    "discreteRules" -> discreteData["rules"],
    "pendingFeatures" -> pendingFeatures,
    "completeMomentumIBPQ" -> TrueQ[pendingFeatures === {}],
    "equations" -> equations
    |>
   ];



(* ::Chapter:: *)
(*自动 shrink-sector seed*)

(* 本章从 top-sector 的 massive full lines 派生 shrunk sectors。
   为避免大图爆炸，默认有 sector 数量保护；超过保护时只保留 pending gate，不展开。 *)

vertexRepresentativeMap[vertexIds_List, pairs_List] := Module[
   {parent, pos, find, union},
   parent = AssociationThread[vertexIds -> vertexIds];
   pos = AssociationThread[vertexIds -> Range[Length[vertexIds]]];
   find[x_] := If[parent[x] === x, x, parent[x] = find[parent[x]]];
   union[x_, y_] := Module[{rx = find[x], ry = find[y], rep, other},
     If[rx === ry, Return[]];
     rep = If[pos[rx] <= pos[ry], rx, ry];
     other = If[rep === rx, ry, rx];
     parent[other] = rep;
     ];
   Scan[union[#[[1]], #[[2]]] &, pairs];
   Association[Table[v -> find[v], {v, vertexIds}]]
   ];


remapExtLegsToRepresentatives[extLegs_List, repMap_Association] := Map[
   If[ListQ[#] && Length[#] >= 2,
     Join[#[[1 ;; 1]], {Lookup[repMap, #[[2]], #[[2]]]}, Drop[#, 2]],
     #
     ] &,
   extLegs
   ];


remapVertexEnergiesToRepresentatives[vertexEnergies_, repMap_Association] := Module[
   {rules, grouped},
   Which[
    AssociationQ[vertexEnergies],
    rules = Normal[vertexEnergies] /. (v_ -> val_) :> (Lookup[repMap, v, v] -> val);
    grouped = Merge[rules, Total];
    grouped,
    ListQ[vertexEnergies],
    rules = vertexEnergies /. (v_ -> val_) :> (Lookup[repMap, v, v] -> val);
    Normal[Merge[rules, Total]],
    True,
    vertexEnergies
    ]
   ];


filterRulesToVariables[rules_List, vars_List] := Module[{varSet = DeleteDuplicates[vars]},
   Select[rules, MemberQ[varSet, First[#]] &]
   ];


filterSampleDiscreteRulesForTopology[rules_List, topo_Association] := Module[
   {vars = Flatten[discreteVarsForLine /@ topo["lines"]]},
   If[rules === {}, {}, filterRulesToVariables[#, vars] & /@ rules]
   ];


shrinkSectorTopology[topo_Association, shrunkLines_List] := Module[
   {pairs, repMap, activeVertices, fixedA, newLines, newExtLegs, newZeroPointRules, newCase, sectorTopo},
   pairs = topo["lines"][[#, "endpoints"]] & /@ shrunkLines;
   repMap = vertexRepresentativeMap[topo["vertexIds"], pairs];
   activeVertices = DeleteDuplicates[Lookup[repMap, topo["vertexIds"]]];
   fixedA = Association[Thread[Complement[topo["vertexIds"], activeVertices] -> 0]];
   newLines = MapIndexed[
     Module[{line = #1, e = First[#2], endpoints},
       endpoints = Lookup[repMap, line["endpoints"]];
       If[MemberQ[shrunkLines, e],
        Join[line, <|"originalEndpoints" -> Lookup[line, "originalEndpoints", line["endpoints"]], "endpoints" -> endpoints, "state" -> "shrunk", "packType" -> "shrunk"|>],
        Join[line, <|"originalEndpoints" -> Lookup[line, "originalEndpoints", line["endpoints"]], "endpoints" -> endpoints|>]
        ]
       ] &,
     topo["lines"]
     ];
   newExtLegs = remapExtLegsToRepresentatives[topo["extLegs"], repMap];
   newZeroPointRules = sectorZeroPointRules[topo, shrunkLines, repMap, activeVertices];
   newCase = <|
     "name" -> topo["name"] <> "_sector_" <> StringRiffle["e" <> ToString[#] & /@ shrunkLines, "_"],
     "vertexData" -> topo["vertexData"],
     "lineData" -> newLines,
     "extLegs" -> newExtLegs,
     "vertexEnergies" -> remapVertexEnergiesToRepresentatives[topo["vertexEnergies"], repMap],
     "loopMomenta" -> topo["loopMomenta"],
     "externalMomenta" -> topo["externalMomenta"],
      "externalLegMomenta" -> Lookup[topo, "externalLegMomenta", {}],
      "kinematicRules" -> Lookup[topo, "kinematicRules", Automatic],
     "rawExternalInvariantRules" -> Lookup[topo, "rawExternalInvariantRules", topo["externalInvariantRules"]],
     "externalInvariantRules" -> topo["externalInvariantRules"],
     "rawExternalLegInvariantRules" -> Lookup[topo, "rawExternalLegInvariantRules", Automatic],
     "externalLegInvariantRules" -> Lookup[topo, "externalLegInvariantRules", {}],
     "ispData" -> topo["ispData"],
     "rawNumericRules" -> Lookup[topo, "rawNumericRules", userNumericRules[topo]],
     "numericRules" -> userNumericRules[topo],
     "sampleDiscreteRules" -> topo["sampleDiscreteRules"],
     "seedRanges" -> topo["seedRanges"],
     "generatorSeedRanges" -> Lookup[topo, "generatorSeedRanges", {}],
     "zeroPointRules" -> newZeroPointRules,
     "shrinkPrefactorRules" -> topo["shrinkPrefactorRules"],
     "symmetryRules" -> topo["symmetryRules"],
     "thetaBoundarySignOffset" -> topo["thetaBoundarySignOffset"],
     "kiraOrdering" -> topo["kiraOrdering"],
     "sectorVertexRepresentativeMap" -> repMap,
     "activeVertexIds" -> activeVertices,
     "fixedAVertexValues" -> fixedA,
     "sectorShrunkLines" -> shrunkLines
     |>;
   sectorTopo = Join[parseTopology[newCase], <|"sectorShrunkLines" -> shrunkLines|>];
   Join[sectorTopo, <|
    "sectorMetadata" -> makeSectorMetadata[sectorTopo],
    "tadpoleSymmetryData" -> tadpoleSymmetryData[sectorTopo],
    "effectiveSymmetryRules" -> effectiveSymmetryRules0[sectorTopo],
    "sampleDiscreteRules" -> filterSampleDiscreteRulesForTopology[topo["sampleDiscreteRules"], sectorTopo]
    |>]
   ];


massiveFullLineIndices[topo_Association] := Flatten@Position[Lookup[topo["lines"], "packType"], "massiveFull"];


masslessFullLineIndices[topo_Association] := Flatten@Position[Lookup[topo["lines"], "packType"], "masslessFull"];


thetaFullLineIndices[topo_Association] := Sort @ Join[
   massiveFullLineIndices[topo],
   masslessFullLineIndices[topo]
   ];


contactReachableShrinkSubsets[topo_Association] := Module[
   {lines = thetaFullLineIndices[topo], queue = {{}}, seen = <||>, result = {},
    state, pairs, repMap, eligible, bundles, events, newState, key},
   AssociateTo[seen, ToString[{}, InputForm] -> True];
   While[queue =!= {},
    state = First[queue];
    queue = Rest[queue];
    pairs = topo["lines"][[#, "endpoints"]] & /@ state;
    repMap = vertexRepresentativeMap[topo["vertexIds"], pairs];
    eligible = Select[
      Complement[lines, state],
      ! SameQ @@ Lookup[repMap, topo["lines"][[#, "endpoints"]]] &
      ];
    bundles = GatherBy[
      eligible,
      Sort[vertexPosition[topo, #] & /@ Lookup[repMap, topo["lines"][[#, "endpoints"]]]] &
      ];
    events = Flatten[Select[Rest[Subsets[#]], OddQ[Length[#]] &] & /@ bundles, 1];
    Do[
     newState = Sort[Union[state, event]];
     key = ToString[newState, InputForm];
     If[! KeyExistsQ[seen, key],
      AssociateTo[seen, key -> True];
      AppendTo[result, newState];
      AppendTo[queue, newState]
      ],
     {event, events}
     ];
    ];
   SortBy[result, {Length[#], #} &]
   ];


shrinkSectorSubsets[topo_Association, maxDepthSpec_, maxCount_Integer] := Module[
   {lines = thetaFullLineIndices[topo], maxDepth, allSubsets, subsets},
   If[lines === {}, Return[<|"status" -> "generated", "subsets" -> {}, "completeCoverageQ" -> True|>]];
   maxDepth = If[maxDepthSpec === Automatic || maxDepthSpec === All || maxDepthSpec === Infinity,
     Length[lines],
     Min[Length[lines], maxDepthSpec]
     ];
   allSubsets = contactReachableShrinkSubsets[topo];
   subsets = Select[allSubsets, Length[#] <= maxDepth &];
   If[Length[subsets] > maxCount,
    Return[<|"status" -> "tooMany", "subsets" -> {}, "requestedSubsetCount" -> Length[subsets], "maxCount" -> maxCount, "completeCoverageQ" -> False|>]
    ];
   <|"status" -> "generated", "subsets" -> subsets, "completeCoverageQ" -> TrueQ[Length[subsets] === Length[allSubsets]]|>
   ];


Options[makeTopologyData] = {PrecomputeShrinkSectorMetadata -> False, MaxShrinkSectorDepth -> Automatic, MaxShrinkSectorCount -> Automatic};


makeTopologyIndexMaps[topo_Association, metadata_Association] := <|
   "vertexIdToOriginalASlot" -> metadata["vertexIdToOriginalASlot"],
   "vertexIdToCompactASlot" -> metadata["vertexIdToCompactASlot"],
   "lineIdToSlot" -> metadata["lineIdToSlot"],
   "bSymbolToLineSlot" -> metadata["bSymbolToLineSlot"],
   "compactASlots" -> metadata["compactASlots"],
   "lineSlots" -> metadata["lineSlots"],
   "ispSlots" -> metadata["ispSlots"]
   |>;


makeTopologySeedSummary[topo_Association] := <|
   "continuousVariables" -> continuousIndexVariables[makeBaseIntegral[topo]],
   "discreteVariables" -> Flatten[discreteVarsForLine /@ topo["lines"]],
   "discreteStateCount" -> discreteStateCount[topo],
   "momentumGeneratorCount" -> Count[Lookup[makeIBPGenerators[topo], "type"], "momentum"],
   "timeGeneratorCount" -> Count[Lookup[makeIBPGenerators[topo], "type"], "time"],
   "seedRanges" -> topo["seedRanges"],
   "numericRules" -> topo["numericRules"],
   "numericRuleRequirementReport" -> numericRuleRequirementReport[topo],
   "externalInvariantNamingReport" -> externalInvariantNamingReport[topo],
   "vertexEnergyNamingReport" -> vertexEnergyNamingReport[topo],
   "sampleDiscreteRules" -> topo["sampleDiscreteRules"]
   |>;


vertexPairBundleKey[line_Association] := Sort[Lookup[line, "originalEndpoints", line["endpoints"]]];


masslessBundleCandidates[topo_Association] := Module[
   {indexedLines, masslessFullLines, grouped},
   indexedLines = MapIndexed[Join[#1, <|"lineIndex" -> First[#2]|>] &, topo["lines"]];
   masslessFullLines = Select[indexedLines, #["packType"] === "masslessFull" &];
   grouped = GroupBy[masslessFullLines, vertexPairBundleKey];
   KeyValueMap[
    If[Length[#2] > 1,
      <|
       "vertexPair" -> #1,
       "lineIndices" -> Lookup[#2, "lineIndex"],
       "lineIds" -> Lookup[#2, "id"],
       "packTemplates" -> (makeLinePack /@ #2),
        "bundleMode" -> "commonThetaOddSubsetContacts"
       |>,
      Nothing
      ] &,
    grouped
    ]
   ];


masslessEndpointConventionData[topo_Association] := MapIndexed[
   <|
     "lineIndex" -> First[#2],
     "lineId" -> #1["id"],
     "orderedEndpoints" -> #1["endpoints"],
     "n1ReferenceEndpoint" -> #1["endpoints"][[1]],
     "n1OppositeEndpoint" -> #1["endpoints"][[2]],
     "convention" -> "n=1 is the antisymmetric state defined by the first endpoint; swapping endpoints flips n=1"
     |> &,
   Select[topo["lines"], #["packType"] === "masslessFull" &]
   ];


unsupportedSeedFeaturesForTopology[topo_Association] := DeleteDuplicates@Join[
    {}
    ];


topologyValidationReport[topo_Association] := Module[
   {issues = {}, appendIssue, vertexIds, lineIds, packTypes, allowedPackTypes,
     duplicateLoopMomenta, duplicateExternalMomenta, duplicateExternalLegMomenta,
     loopExternalMomentumOverlap, externalLegMomentumOverlap,
     vertexSigns, activeVertexIds, fixedAVertexIds, badVertexSigns, badActiveVertexIds, badFixedAVertexIds,
    extLegs, badExtLegShapePositions, badExtLegVertexData, vertexEnergies, vertexEnergyKeys, badVertexEnergyKeys,
    ispNames, seedRangeData, badSeedRangeData, badSeedSampleOnlyQ, badISPRangeData, seedOptions,
     unknownSeedOptionKeys, badSeedOptionData, kiraOrderingReport, numericRuleValidationReport,
     zeroPointRuleValidationReport, shrinkPrefactorRuleValidationReport,
    badMassTypeLines, badSKTypeLines, badStateLines,
    badEndpointLines, lineMomentumVars, declaredMomentumVars, undeclaredMomentumVars,
    nonLinearLineMomentumData, nonLinearScalarProductArgumentData, vertexEnergyMomentumDependenceData,
    spData, discreteVars, sampleRuleShapeIssues, sampleRulePairs, unknownDiscreteRules, badDiscreteValues,
    missingDiscreteRuleIssues, missingExternalInvariants, missingVertexEnergies,
     missingLineParameters, numericRequirementReport, pendingFeatures, ruleData, kinematicAudit},
   appendIssue[severity_, code_, data_: <||>] := AppendTo[issues, Join[<|"severity" -> severity, "code" -> code|>, data]];
   vertexIds = topo["vertexIds"];
   vertexSigns = topo["vertexData"][[All, 2]];
   activeVertexIds = Lookup[topo, "activeVertexIds", vertexIds];
   fixedAVertexIds = Keys[Lookup[topo, "fixedAVertexValues", <||>]];
   extLegs = Lookup[topo, "extLegs", {}];
   vertexEnergies = Lookup[topo, "vertexEnergies", <||>];
   kinematicAudit = Lookup[topo, "kinematicCoordinateAudit", <||>];
   ispNames = Lookup[topo["ispData"], "name", {}];
   seedRangeData = KeyDrop[topo["seedRanges"], {"sampleOnly"}];
   If[Lookup[kinematicAudit, "status", "complete"] === "incomplete",
    appendIssue["error", "incompleteKinematicCoordinates", <|
      "coordinateRank" -> Lookup[kinematicAudit, "coordinateRank", Missing["rank"]],
      "parameterRank" -> Lookup[kinematicAudit, "parameterRank", Missing["parameterRank"]],
      "baseCoordinateCount" -> Lookup[kinematicAudit, "baseCoordinateCount", Missing["count"]],
      "missingDirections" -> Lookup[kinematicAudit, "missingDirections", {}],
      "parameterMissingDirections" -> Lookup[kinematicAudit, "parameterMissingDirections", {}],
      "unsupportedRulePositions" -> Lookup[kinematicAudit, "unsupportedRulePositions", {}]
      |>]
    ];
   If[Lookup[kinematicAudit, "status", "complete"] === "overcomplete",
    appendIssue["warning", "overcompleteKinematicCoordinates", <|
      "constraintResiduals" -> Lookup[kinematicAudit, "constraintResiduals", {}],
      "ruleDependencies" -> Lookup[kinematicAudit, "ruleDependencies", {}],
      "comment" -> "IBP generation may continue, but inverse conversion and ds in the redundant coordinates are disabled until the family definition supplies the constraints."
      |>]
    ];
   seedOptions = Lookup[topo, "seedOptions", <||>];
   lineIds = Lookup[topo["lines"], "id"];
   packTypes = Lookup[topo["lines"], "packType"];
   allowedPackTypes = {"massiveFull", "massiveCross", "masslessFull", "masslessCross", "shrunk"};
   duplicateLoopMomenta = Cases[Tally[topo["loopMomenta"]], {mom_, count_} /; count > 1 :> mom];
   If[duplicateLoopMomenta =!= {},
    appendIssue["error", "duplicateLoopMomenta", <|"loopMomenta" -> topo["loopMomenta"], "duplicates" -> duplicateLoopMomenta|>]
    ];
   duplicateExternalMomenta = Cases[Tally[topo["externalMomenta"]], {mom_, count_} /; count > 1 :> mom];
   If[duplicateExternalMomenta =!= {},
    appendIssue["error", "duplicateExternalMomenta", <|"externalMomenta" -> topo["externalMomenta"], "duplicates" -> duplicateExternalMomenta|>]
    ];
   duplicateExternalLegMomenta = Cases[Tally[Lookup[topo, "externalLegMomenta", {}]], {mom_, count_} /; count > 1 :> mom];
   If[duplicateExternalLegMomenta =!= {},
    appendIssue["error", "duplicateExternalLegMomenta", <|"externalLegMomenta" -> Lookup[topo, "externalLegMomenta", {}], "duplicates" -> duplicateExternalLegMomenta|>]
    ];
   loopExternalMomentumOverlap = Intersection[topo["loopMomenta"], topo["externalMomenta"]];
   If[loopExternalMomentumOverlap =!= {},
    appendIssue["error", "loopExternalMomentumOverlap", <|"overlap" -> loopExternalMomentumOverlap, "loopMomenta" -> topo["loopMomenta"], "externalMomenta" -> topo["externalMomenta"]|>]
    ];
   externalLegMomentumOverlap = Intersection[
     Lookup[topo, "externalLegMomenta", {}],
     Join[topo["loopMomenta"], topo["externalMomenta"]]
     ];
   If[externalLegMomentumOverlap =!= {},
    appendIssue["error", "externalLegMomentumOverlap", <|"overlap" -> externalLegMomentumOverlap|>]
    ];
   If[! DuplicateFreeQ[lineIds],
    appendIssue["error", "duplicateLineIds", <|"lineIds" -> lineIds|>]
    ];
   If[ispNames =!= {} && ! DuplicateFreeQ[ispNames],
    appendIssue["error", "duplicateISPNames", <|"ispNames" -> ispNames|>]
    ];
   badSeedRangeData = KeyValueMap[
     If[! validIndexRangeSpecQ[#2],
       <|"rangeKey" -> #1, "rangeSpec" -> #2|>,
       Nothing
       ] &,
     seedRangeData
     ];
   If[badSeedRangeData =!= {},
    appendIssue["error", "malformedSeedRangeSpecs", <|"ranges" -> badSeedRangeData, "allowed" -> "integer or nonempty integer list"|>]
    ];
   badSeedSampleOnlyQ = KeyExistsQ[topo["seedRanges"], "sampleOnly"] && ! BooleanQ[topo["seedRanges", "sampleOnly"]];
   If[TrueQ[badSeedSampleOnlyQ],
    appendIssue["error", "malformedSeedSampleOnly", <|"sampleOnly" -> topo["seedRanges", "sampleOnly"], "allowed" -> {True, False}|>]
    ];
   badISPRangeData = DeleteCases[
     MapIndexed[
      If[KeyExistsQ[#1, "range"] && ! validIndexRangeSpecQ[#1["range"]],
        <|"ispPosition" -> First[#2], "name" -> Lookup[#1, "name", Missing["name"]], "rangeSpec" -> #1["range"]|>,
        Nothing
        ] &,
      topo["ispData"]
      ],
     Nothing
     ];
   If[badISPRangeData =!= {},
    appendIssue["error", "malformedISPRangeSpecs", <|"isps" -> badISPRangeData, "allowed" -> "integer or nonempty integer list"|>]
    ];
   unknownSeedOptionKeys = Complement[Keys[seedOptions], allowedSeedOptionKeys[]];
   If[unknownSeedOptionKeys =!= {},
    appendIssue["error", "unknownSeedOptionKeys", <|"keys" -> unknownSeedOptionKeys, "allowedKeys" -> allowedSeedOptionKeys[]|>]
    ];
   badSeedOptionData = KeyValueMap[
     If[MemberQ[allowedSeedOptionKeys[], #1] && ! validSeedOptionValueQ[#1, #2],
       <|"optionKey" -> #1, "optionValue" -> #2|>,
       Nothing
       ] &,
     seedOptions
     ];
   If[badSeedOptionData =!= {},
    appendIssue["error", "malformedSeedOptionValues", <|"options" -> badSeedOptionData|>]
    ];
   kiraOrderingReport = validateKiraOrderingSpec[Lookup[topo, "kiraOrdering", <||>]];
   If[Lookup[kiraOrderingReport, "status", "ok"] =!= "ok",
    appendIssue["error", "invalidKiraOrdering", KeyDrop[kiraOrderingReport, {"status"}]]
    ];
   numericRuleValidationReport = validateCoefficientRules[topo["numericRules"]];
   If[Lookup[numericRuleValidationReport, "status", "ok"] =!= "ok",
    appendIssue["error", "invalidNumericRules", KeyDrop[numericRuleValidationReport, {"status"}]]
    ];
   zeroPointRuleValidationReport = validateCoefficientRules[topo["zeroPointRules"]];
   If[Lookup[zeroPointRuleValidationReport, "status", "ok"] =!= "ok",
    appendIssue["error", "invalidZeroPointRules", KeyDrop[zeroPointRuleValidationReport, {"status"}]]
    ];
   shrinkPrefactorRuleValidationReport = validateCoefficientRules[topo["shrinkPrefactorRules"]];
   If[Lookup[shrinkPrefactorRuleValidationReport, "status", "ok"] =!= "ok",
    appendIssue["error", "invalidShrinkPrefactorRules", KeyDrop[shrinkPrefactorRuleValidationReport, {"status"}]]
    ];
   If[! DuplicateFreeQ[vertexIds],
    appendIssue["error", "duplicateVertexIds", <|"vertexIds" -> vertexIds|>]
    ];
   badVertexSigns = DeleteDuplicates[Complement[vertexSigns, {"+", "-"}]];
   If[badVertexSigns =!= {},
    appendIssue["error", "unknownVertexSigns", <|"vertexSigns" -> badVertexSigns, "allowedVertexSigns" -> {"+", "-"}|>]
    ];
   badActiveVertexIds = Complement[activeVertexIds, vertexIds];
   If[badActiveVertexIds =!= {},
    appendIssue["error", "activeVertexIdsNotInVertexData", <|"activeVertexIds" -> badActiveVertexIds, "vertexIds" -> vertexIds|>]
    ];
   badFixedAVertexIds = Complement[fixedAVertexIds, vertexIds];
   If[badFixedAVertexIds =!= {},
    appendIssue["error", "fixedAVertexValuesNotInVertexData", <|"fixedAVertexIds" -> badFixedAVertexIds, "vertexIds" -> vertexIds|>]
    ];
   If[! ListQ[extLegs],
    appendIssue["error", "malformedExtLegs", <|"reason" -> "extLegs must be a list of entries with at least {label, vertexId, energy}"|>],
    badExtLegShapePositions = Flatten @ Position[extLegs, entry_ /; !(ListQ[entry] && Length[entry] >= 3), {1}, Heads -> False];
    If[badExtLegShapePositions =!= {},
     appendIssue["error", "malformedExtLegs", <|"badPositions" -> badExtLegShapePositions|>]
     ];
    badExtLegVertexData = DeleteCases[
      MapIndexed[
       If[ListQ[#1] && Length[#1] >= 2 && ! MemberQ[vertexIds, #1[[2]]],
         <|"extLegPosition" -> First[#2], "vertexId" -> #1[[2]]|>,
         Nothing
         ] &,
       extLegs
       ],
      Nothing
      ];
    If[badExtLegVertexData =!= {},
     appendIssue["error", "extLegVertexNotInVertexData", <|"extLegs" -> badExtLegVertexData, "vertexIds" -> vertexIds|>]
     ]
    ];
   vertexEnergyKeys = Which[
     AssociationQ[vertexEnergies], Keys[vertexEnergies],
     ListQ[vertexEnergies] && And @@ (MatchQ[#, _Rule | _RuleDelayed] & /@ vertexEnergies), Cases[vertexEnergies, (Rule | RuleDelayed)[v_, _] :> v],
     vertexEnergies === <||>, {},
     True, Missing["MalformedVertexEnergies"]
     ];
   If[vertexEnergyKeys === Missing["MalformedVertexEnergies"],
    appendIssue["error", "malformedVertexEnergies", <|"reason" -> "vertexEnergies must be an Association or list of rules"|>],
    badVertexEnergyKeys = Complement[vertexEnergyKeys, vertexIds];
    If[badVertexEnergyKeys =!= {},
     appendIssue["error", "vertexEnergiesNotInVertexData", <|"vertexEnergyKeys" -> badVertexEnergyKeys, "vertexIds" -> vertexIds|>]
     ]
    ];
   vertexEnergyMomentumDependenceData = vertexEnergyMomentumDependenceIssues[topo];
   If[vertexEnergyMomentumDependenceData =!= {},
    appendIssue["error", "invalidVertexEnergyMomentumDependence", <|"issues" -> vertexEnergyMomentumDependenceData, "comment" -> "vertexEnergies are scalar time-phase energies for all external legs attached to a vertex: use external invariant variables such as s11/sigW when they belong to externalMomenta space, otherwise use independent ke[i] parameters"|>]
    ];
   If[Lookup[topo, "unknownSeedPreset", None] =!= None,
    appendIssue["error", "unknownSeedPreset", <|"seedPreset" -> topo["unknownSeedPreset"], "allowedSeedPresets" -> {"quickCheck", "fullDiscrete", "bounded"}|>]
    ];
   badEndpointLines = Select[
     MapIndexed[Join[#1, <|"lineIndex" -> First[#2]|>] &, topo["lines"]],
     ! SubsetQ[vertexIds, Lookup[#, "endpoints", {}]] &
     ];
   If[badEndpointLines =!= {},
    appendIssue["error", "lineEndpointNotInVertexData", <|"lineIndices" -> Lookup[badEndpointLines, "lineIndex"], "endpoints" -> Lookup[badEndpointLines, "endpoints"]|>]
    ];
   If[Complement[packTypes, allowedPackTypes] =!= {},
    appendIssue["error", "unknownPackTypes", <|"packTypes" -> DeleteDuplicates[Complement[packTypes, allowedPackTypes]]|>]
    ];
   badMassTypeLines = Select[
     MapIndexed[Join[#1, <|"lineIndex" -> First[#2]|>] &, topo["lines"]],
     ! MemberQ[{"massive", "massless"}, Lookup[#, "massType", "massive"]] &
     ];
   If[badMassTypeLines =!= {},
    appendIssue["error", "unknownLineMassTypes", <|"lineIndices" -> Lookup[badMassTypeLines, "lineIndex"], "massTypes" -> Lookup[badMassTypeLines, "massType"], "allowedMassTypes" -> {"massive", "massless"}|>]
    ];
   badSKTypeLines = Select[
     MapIndexed[Join[#1, <|"lineIndex" -> First[#2]|>] &, topo["lines"]],
     ! MemberQ[{"++", "--", "+-", "-+"}, Lookup[#, "skType", "++"]] &
     ];
   If[badSKTypeLines =!= {},
    appendIssue["error", "unknownLineSKTypes", <|"lineIndices" -> Lookup[badSKTypeLines, "lineIndex"], "skTypes" -> Lookup[badSKTypeLines, "skType"], "allowedSKTypes" -> {"++", "--", "+-", "-+"}|>]
    ];
   badStateLines = Select[
     MapIndexed[Join[#1, <|"lineIndex" -> First[#2]|>] &, topo["lines"]],
     ! MemberQ[{"full", "shrunk"}, Lookup[#, "state", "full"]] &
     ];
   If[badStateLines =!= {},
    appendIssue["error", "unknownLineStates", <|"lineIndices" -> Lookup[badStateLines, "lineIndex"], "states" -> Lookup[badStateLines, "state"], "allowedStates" -> {"full", "shrunk"}|>]
    ];
   lineMomentumVars = DeleteDuplicates[Flatten[Variables /@ Lookup[topo["lines"], "momentum"]]];
   declaredMomentumVars = DeleteDuplicates@Join[
     topo["loopMomenta"], topo["externalMomenta"], Lookup[topo, "externalLegMomenta", {}]
     ];
   undeclaredMomentumVars = Complement[lineMomentumVars, declaredMomentumVars];
   If[undeclaredMomentumVars =!= {},
    appendIssue["error", "undeclaredMomentumVariables", <|"variables" -> undeclaredMomentumVars, "declared" -> declaredMomentumVars|>]
    ];
   nonLinearLineMomentumData = lineMomentumLinearityIssues[topo];
   If[nonLinearLineMomentumData =!= {},
    appendIssue["error", "nonLinearLineMomenta", <|"issues" -> nonLinearLineMomentumData, "comment" -> "line momenta must be linear combinations of loopMomenta, externalMomenta and declared externalLegMomenta"|>]
    ];
   nonLinearScalarProductArgumentData = scalarProductArgumentLinearityIssues[topo];
   If[nonLinearScalarProductArgumentData =!= {},
    appendIssue["error", "nonLinearScalarProductArguments", <|"issues" -> nonLinearScalarProductArgumentData, "comment" -> "sp[p,r] arguments must be linear momentum combinations before scalar products are expanded"|>]
    ];
   spData = makeScalarProductData[topo];
   If[spData["unsupportedISPExprs"] =!= {},
    appendIssue["error", "unsupportedISPExpressions", <|"expressions" -> spData["unsupportedISPExprs"], "allowedScalarProducts" -> spData["scalarProducts"]|>]
    ];
   If[! TrueQ[spData["structuralCountQ"]],
    appendIssue["error", "insufficientISPData", <|"needed" -> spData["structuralNeededISPCount"], "providedDirect" -> spData["directISPCount"], "provided" -> spData["ispCount"]|>]
    ];
   If[spData["unsupportedISPExprs"] === {} && TrueQ[spData["structuralCountQ"]] && ! TrueQ[spData["coordinateCountQ"]],
    appendIssue["error", "scalarProductCoordinateCountMismatch", <|
      "zCount" -> spData["zCount"],
      "nonISPScalarProductCount" -> spData["nonISPScalarProductCount"],
      "assumption" -> "topology input must provide a closed z/ISP coordinate system; no automatic redundant propagator subset is selected"
      |>]
    ];
   If[spData["unsupportedISPExprs"] === {} && TrueQ[spData["structuralCountQ"]] && TrueQ[spData["coordinateCountQ"]],
    ruleData = makeScalarProductRules[topo];
    If[Lookup[ruleData, "status", "notComputed"] =!= "computed",
     appendIssue["error", "scalarProductCoordinateSolveFailed", <|
       "reason" -> Lookup[ruleData, "reason", Missing["reason"]],
       "solveVars" -> Lookup[ruleData, "solveVars", spData["solveVars"]],
       "zCount" -> spData["zCount"],
       "nonISPScalarProductCount" -> spData["nonISPScalarProductCount"]
       |>]
     ]
    ];
   numericRequirementReport = numericRuleRequirementReport[topo];
   missingExternalInvariants = numericRequirementReport["missingExternalInvariants"];
   If[missingExternalInvariants =!= {},
    appendIssue["warning", "numericRulesMissingExternalInvariants", <|
      "missingExternalInvariants" -> missingExternalInvariants,
      "numericRules" -> userNumericRules[topo],
      "comment" -> "analytic seed can still be generated; numeric linear/Kira stages need external invariant value rules, using the output names from externalInvariantRules/default sij"
      |>]
    ];
   missingVertexEnergies = numericRequirementReport["missingVertexEnergies"];
   If[missingVertexEnergies =!= {},
    appendIssue["warning", "numericRulesMissingVertexEnergies", <|
      "missingVertexEnergies" -> missingVertexEnergies,
      "numericRules" -> userNumericRules[topo],
      "comment" -> "analytic seed can still be generated; numeric linear/Kira stages need vertex energy rules from time IBP"
      |>]
    ];
   missingLineParameters = numericRequirementReport["missingLineParameters"];
   If[missingLineParameters =!= {},
    appendIssue["warning", "numericRulesMissingLineParameters", <|
      "missingLineParameters" -> missingLineParameters,
      "numericRules" -> userNumericRules[topo],
      "comment" -> "analytic seed can still be generated; numeric linear/Kira stages need massive line parameter rules"
      |>]
    ];
   discreteVars = Flatten[discreteVarsForLine /@ topo["lines"]];
   sampleRuleShapeIssues = sampleDiscreteRulesShapeIssues[topo["sampleDiscreteRules"]];
   If[sampleRuleShapeIssues =!= {},
    appendIssue["error", "malformedSampleDiscreteRules", <|"issues" -> sampleRuleShapeIssues|>],
    sampleRulePairs = sampleDiscreteRulePairs[topo["sampleDiscreteRules"]];
    unknownDiscreteRules = Select[sampleRulePairs, ! MemberQ[discreteVars, #[[1]]] &];
    If[unknownDiscreteRules =!= {},
     appendIssue["warning", "sampleDiscreteRulesContainUnknownVariables", <|"rules" -> (Rule @@@ unknownDiscreteRules), "allowedDiscreteVariables" -> discreteVars|>]
     ];
    badDiscreteValues = Select[sampleRulePairs, MemberQ[discreteVars, #[[1]]] && ! MemberQ[{0, 1}, #[[2]]] &];
    If[badDiscreteValues =!= {},
     appendIssue["warning", "sampleDiscreteRulesContainNonBinaryValues", <|"rules" -> (Rule @@@ badDiscreteValues)|>]
     ];
    If[discreteVars =!= {} && topo["sampleDiscreteRules"] === {},
     appendIssue["warning", "sampleDiscreteRulesMissingForDiscreteVariables", <|"missingVariables" -> discreteVars, "comment" -> "sample seed mode needs complete n=0/1 rules; DiscreteMode -> all can enumerate them automatically"|>]
     ];
    If[topo["sampleDiscreteRules"] =!= {},
     missingDiscreteRuleIssues = sampleDiscreteRuleCoverageIssues[topo, topo["sampleDiscreteRules"]];
     If[missingDiscreteRuleIssues =!= {},
      appendIssue["error", "sampleDiscreteRulesMissingVariables", <|"issues" -> missingDiscreteRuleIssues, "allowedDiscreteVariables" -> discreteVars|>]
      ]
     ]
    ];
   pendingFeatures = unsupportedSeedFeaturesForTopology[topo];
   If[pendingFeatures =!= {},
    appendIssue["pending", "unsupportedSeedFeatures", <|"pendingFeatures" -> pendingFeatures|>]
    ];
   <|
    "status" -> If[Count[Lookup[issues, "severity", {}], "error"] == 0, "ok", "issues"],
    "errorCount" -> Count[Lookup[issues, "severity", {}], "error"],
    "warningCount" -> Count[Lookup[issues, "severity", {}], "warning"],
    "pendingCount" -> Count[Lookup[issues, "severity", {}], "pending"],
    "numericRuleRequirementReport" -> numericRequirementReport,
    "pendingFeatures" -> pendingFeatures,
    "issues" -> issues
    |>
   ];


topologyValidationErrorQ[report_Association] := TrueQ[Lookup[report, "errorCount", 0] > 0];
topologyValidationErrorQ[_] := False;


makeTopologyData[case_Association, OptionsPattern[]] := Module[
   {topo, topMetadata, subsetData, sectorTopos, sectorMetadataList, maxShrinkDepth, maxShrinkCount, inputReport, validationReport},
   If[caseInputPreflightErrorQ[case],
    inputReport = caseInputRequirementReport[case];
    validationReport = caseInputErrorReport[case];
    Return[Join[case, <|
       "status" -> "invalidInput",
       "reason" -> If[inputReport["missingRequiredKeys"] =!= {}, "missingRequiredCaseKeys", "malformedCaseInput"],
       "inputRequirementReport" -> inputReport,
       "validationReport" -> validationReport,
       "sectorMetadataList" -> {},
       "indexMaps" -> <||>,
       "seedSummary" -> <||>,
       "numericRuleRequirementReport" -> <||>,
       "numericRuleTemplate" -> {},
       "masslessBundleCandidates" -> {},
       "precomputedShrinkSectorSummary" -> <|"status" -> "skipped"|>,
       "precomputedShrinkSectorKeys" -> {}
       |>]]
    ];
   topo = parseTopology[case];
   topMetadata = makeSectorMetadata[topo];
   maxShrinkDepth = resolveSeedOption[topo, "MaxShrinkSectorDepth", OptionValue[MaxShrinkSectorDepth], Automatic];
   maxShrinkCount = resolveSeedOption[topo, "MaxShrinkSectorCount", OptionValue[MaxShrinkSectorCount], 16];
   subsetData = If[TrueQ[OptionValue[PrecomputeShrinkSectorMetadata]],
     shrinkSectorSubsets[topo, maxShrinkDepth, maxShrinkCount],
     <|"status" -> "skipped", "subsets" -> {}, "completeCoverageQ" -> False|>
     ];
   sectorTopos = If[Lookup[subsetData, "status", "skipped"] === "generated",
     shrinkSectorTopology[topo, #] & /@ Lookup[subsetData, "subsets", {}],
     {}
     ];
   sectorMetadataList = Join[{topMetadata}, Lookup[#, "sectorMetadata", makeSectorMetadata[#]] & /@ sectorTopos];
   Join[topo, <|
     "sectorMetadata" -> topMetadata,
     "sectorMetadataList" -> sectorMetadataList,
     "indexMaps" -> makeTopologyIndexMaps[topo, topMetadata],
     "seedSummary" -> makeTopologySeedSummary[topo],
     "validationReport" -> topologyValidationReport[topo],
     "numericRuleRequirementReport" -> numericRuleRequirementReport[topo],
    "numericRuleTemplate" -> makeNumericRuleTemplate[topo],
    "tadpoleSymmetryData" -> tadpoleSymmetryData[topo],
    "effectiveSymmetryRules" -> effectiveSymmetryRules0[topo],
    "masslessBundleCandidates" -> masslessBundleCandidates[topo],
     "masslessEndpointConventions" -> masslessEndpointConventionData[topo],
     "precomputedShrinkSectorSummary" -> KeyDrop[subsetData, "subsets"],
     "precomputedShrinkSectorKeys" -> Lookup[sectorMetadataList, "sectorKey"]
     |>]
   ];

Options[makeShrinkSectorSeedBatch] = Join[
   Options[makeMomentumIBPSeedBatch],
   {MaxShrinkSectorDepth -> Automatic, MaxShrinkSectorCount -> Automatic}
   ];
makeShrinkSectorSeedBatch::toomany = "拓扑 `1` 的 shrink sector 数为 `2`，超过上限 `3`；未展开 shrink sectors。";


(* shrink sector 的摘要要保留各自的生成元列表；coverage report 依赖它判断每个子 sector 是否同时生成完整 q/t seed。 *)
shrinkSectorBatchSummary[batch_Association] := Module[
   {metadata = Lookup[batch["topology"], "sectorMetadata", makeSectorMetadata[batch["topology"]]]},
   <|
    "sectorShrunkLines" -> batch["sectorShrunkLines"],
    "sectorKey" -> metadata["sectorKey"],
    "momentumSummary" -> KeyDrop[batch["momentumBatch"], "equations"],
    "timeSummary" -> KeyDrop[batch["timeBatch"], "equations"]
    |>
   ];


makeShrinkSectorSeedBatch[topo_Association, OptionsPattern[]] := Module[
   {subsetData, subsets, seedOpts, sectorTopos, sectorBatches, bad, equations, pendingFeatures, completeQ, topologyReport, maxShrinkDepth, maxShrinkCount},
   topologyReport = topologyValidationReport[topo];
   maxShrinkDepth = resolveSeedOption[topo, "MaxShrinkSectorDepth", OptionValue[MaxShrinkSectorDepth], Automatic];
   maxShrinkCount = resolveSeedOption[topo, "MaxShrinkSectorCount", OptionValue[MaxShrinkSectorCount], 16];
   subsetData = shrinkSectorSubsets[topo, maxShrinkDepth, maxShrinkCount];
   If[subsetData["status"] === "tooMany",
    Message[makeShrinkSectorSeedBatch::toomany, topo["name"], subsetData["requestedSubsetCount"], subsetData["maxCount"]];
    Return[Join[subsetData, <|"caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "sectorMetadataList" -> {}, "equations" -> {}, "pendingFeatures" -> {"shrinkSectorSeedGeneration"}|>]]
    ];
   subsets = subsetData["subsets"];
   If[subsets === {},
    Return[<|"status" -> "generated", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "sectorCount" -> 0, "sectorMetadataList" -> {}, "equationCount" -> 0, "eomCanonicalQ" -> True, "forbiddenNData" -> {}, "pendingFeatures" -> {}, "completeShrinkSectorGenerationQ" -> True, "sectorSummaries" -> {}, "equations" -> {}|>]
    ];
   seedOpts = FilterRules[
     Table[opt -> OptionValue[opt], {opt, First /@ Options[makeMomentumIBPSeedBatch]}],
     Options[makeMomentumIBPSeedBatch]
     ];
   sectorTopos = shrinkSectorTopology[topo, #] & /@ subsets;
   sectorBatches = Table[
     Module[{mom = makeMomentumIBPSeedBatch[sectorTopo, Sequence @@ seedOpts], tim = makeTimeIBPSeedBatch[sectorTopo, Sequence @@ seedOpts]},
      <|"sectorShrunkLines" -> sectorTopo["sectorShrunkLines"], "topology" -> sectorTopo, "momentumBatch" -> mom, "timeBatch" -> tim|>
      ],
     {sectorTopo, sectorTopos}
     ];
   bad = Select[sectorBatches, Lookup[#["momentumBatch"], "status", "missing"] =!= "generated" || Lookup[#["timeBatch"], "status", "missing"] =!= "generated" &];
   If[bad =!= {},
    Return[<|"status" -> "notGenerated", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "badSectorCount" -> Length[bad], "sectorSummaries" -> KeyDrop[#, {"topology", "momentumBatch", "timeBatch"}] & /@ bad, "equations" -> {}, "pendingFeatures" -> {"shrinkSectorSeedGeneration"}|>]
    ];
   equations = Flatten[
     Table[
      Join[
       annotateSeedEquations[batch["momentumBatch"]["equations"], {"shrinkSectorMomentum", batch["sectorShrunkLines"]}],
       annotateSeedEquations[batch["timeBatch"]["equations"], {"shrinkSectorTime", batch["sectorShrunkLines"]}]
       ],
      {batch, sectorBatches}
      ],
     1
     ];
   pendingFeatures = DeleteCases[
     DeleteDuplicates[Flatten[Lookup[#["timeBatch"], "pendingFeatures", {}] & /@ sectorBatches]],
     "shrinkSectorSeedGeneration"
     ];
   completeQ = TrueQ[subsetData["completeCoverageQ"] && pendingFeatures === {}];
   <|
    "status" -> "generated",
    "caseName" -> topo["name"],
    "topologyValidationReport" -> topologyReport,
    "sectorCount" -> Length[sectorBatches],
    "sectorSubsets" -> subsets,
    "completeCoverageQ" -> subsetData["completeCoverageQ"],
    "equationCount" -> Length[equations],
    "eomCanonicalQ" -> And @@ Flatten[Table[{batch["momentumBatch"]["eomCanonicalQ"], batch["timeBatch"]["eomCanonicalQ"]}, {batch, sectorBatches}]],
    "forbiddenNData" -> DeleteCases[Flatten[Table[{batch["momentumBatch"]["forbiddenNData"], batch["timeBatch"]["forbiddenNData"]}, {batch, sectorBatches}]], Null],
    "pendingFeatures" -> If[completeQ, {}, DeleteDuplicates[Join[pendingFeatures, {"shrinkSectorSeedGeneration"}]]],
    "completeShrinkSectorGenerationQ" -> completeQ,
    "sectorMetadataList" -> (Lookup[#["topology"], "sectorMetadata", makeSectorMetadata[#["topology"]]] & /@ sectorBatches),
    "sectorSummaries" -> (shrinkSectorBatchSummary /@ sectorBatches),
    "equations" -> equations
    |>
   ];

(* ::Chapter:: *)
(*统一 canonical seed 与 Kira 导出门禁*)

(* 本章只合并已经生成的 seed，并给出 Kira 前的 readiness 判断。
   若 time/momentum seed 仍有 pending features 或 forbidden n，Kira exporter 必须返回 notReady，不写文件。 *)

annotateSeedEquations[equations_List, source_] := Join[<|"source" -> source|>, #] & /@ equations;


canonicalPendingFeatures[momentumBatch_Association, timeBatch_Association] := DeleteDuplicates @ Join[
    Lookup[momentumBatch, "pendingFeatures", {}],
    Lookup[timeBatch, "pendingFeatures", {}]
    ];


Options[makeCanonicalSeedBatch] = Join[
   Options[makeMomentumIBPSeedBatch],
   {GenerateShrinkSectors -> True, MaxShrinkSectorDepth -> Automatic, MaxShrinkSectorCount -> Automatic}
   ];


makeCanonicalSeedBatch[topo_Association, opts : OptionsPattern[]] := Module[
   {momentumBatch, timeBatch, shrinkBatch, seedOpts, shrinkOpts, pendingFeatures, equations, eomCanonicalQ, sectorMetadataList, topologyReport},
   topologyReport = topologyValidationReport[topo];
   If[topologyValidationErrorQ[topologyReport],
    Return[<|"status" -> "invalidTopology", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "sectorMetadataList" -> {}, "equationCount" -> 0, "eomCanonicalQ" -> False, "forbiddenNData" -> {}, "pendingFeatures" -> {}, "equations" -> {}|>]
    ];
   seedOpts = FilterRules[{opts}, Options[makeMomentumIBPSeedBatch]];
   shrinkOpts = FilterRules[{opts}, Options[makeShrinkSectorSeedBatch]];
   momentumBatch = makeMomentumIBPSeedBatch[topo, Sequence @@ seedOpts];
   timeBatch = makeTimeIBPSeedBatch[topo, Sequence @@ seedOpts];
   shrinkBatch = If[TrueQ[OptionValue[GenerateShrinkSectors]],
     makeShrinkSectorSeedBatch[topo, Sequence @@ shrinkOpts],
     <|"status" -> "skipped", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "sectorMetadataList" -> {}, "equationCount" -> 0, "eomCanonicalQ" -> True, "forbiddenNData" -> {}, "pendingFeatures" -> If[thetaFullLineIndices[topo] === {}, {}, {"shrinkSectorSeedGeneration"}], "equations" -> {}|>
     ];
   If[Lookup[momentumBatch, "status", "missing"] =!= "generated" || Lookup[timeBatch, "status", "missing"] =!= "generated",
    Return[<|
      "status" -> "notGenerated",
      "caseName" -> topo["name"],
      "topologyValidationReport" -> topologyReport,
      "momentumStatus" -> Lookup[momentumBatch, "status", Missing["momentumStatus"]],
      "timeStatus" -> Lookup[timeBatch, "status", Missing["timeStatus"]],
      "momentumBatch" -> KeyDrop[momentumBatch, "equations"],
      "timeBatch" -> KeyDrop[timeBatch, "equations"]
      |>]
    ];
   pendingFeatures = DeleteDuplicates@Join[
     Lookup[momentumBatch, "pendingFeatures", {}],
     Lookup[timeBatch, "pendingFeatures", {}],
     Lookup[shrinkBatch, "pendingFeatures", {}]
     ];
   If[TrueQ[Lookup[shrinkBatch, "completeShrinkSectorGenerationQ", False]],
    pendingFeatures = DeleteCases[pendingFeatures, "shrinkSectorSeedGeneration"]
    ];
   equations = Join[
     annotateSeedEquations[momentumBatch["equations"], "momentum"],
     annotateSeedEquations[timeBatch["equations"], "time"],
     Lookup[shrinkBatch, "equations", {}]
     ];
   eomCanonicalQ = TrueQ[momentumBatch["eomCanonicalQ"]] && TrueQ[timeBatch["eomCanonicalQ"]] && TrueQ[Lookup[shrinkBatch, "eomCanonicalQ", True]];
   sectorMetadataList = Join[{makeSectorMetadata[topo]}, Lookup[shrinkBatch, "sectorMetadataList", {}]];
   <|
    "status" -> "generated",
    "caseName" -> topo["name"],
    "topologyValidationReport" -> topologyReport,
    "momentumEquationCount" -> momentumBatch["equationCount"],
    "timeEquationCount" -> timeBatch["equationCount"],
    "shrinkSectorEquationCount" -> Lookup[shrinkBatch, "equationCount", 0],
    "equationCount" -> Length[equations],
    "eomCanonicalQ" -> eomCanonicalQ,
    "forbiddenNData" -> DeleteCases[Flatten[{momentumBatch["forbiddenNData"], timeBatch["forbiddenNData"], Lookup[shrinkBatch, "forbiddenNData", {}]}], Null],
    "pendingFeatures" -> pendingFeatures,
    "completeMomentumIBPQ" -> TrueQ[momentumBatch["eomCanonicalQ"] && Lookup[momentumBatch, "pendingFeatures", {}] === {}],
    "completeTimeIBPQ" -> TrueQ[pendingFeatures === {}],
    "completeCanonicalQ" -> TrueQ[eomCanonicalQ && pendingFeatures === {}],
    "sectorMetadata" -> First[sectorMetadataList],
    "sectorMetadataList" -> sectorMetadataList,
    "momentumSummary" -> KeyDrop[momentumBatch, "equations"],
    "timeSummary" -> KeyDrop[timeBatch, "equations"],
    "shrinkSectorSummary" -> KeyDrop[shrinkBatch, "equations"],
    "equations" -> equations
    |>
   ];


canonicalSeedReadyQ[batch_Association] := TrueQ[
   Lookup[batch, "status", "missing"] === "generated" &&
    Lookup[batch, "completeCanonicalQ", False] &&
    Lookup[batch, "forbiddenNData", {"missing"}] === {}
   ];


seedEntrySourceSectorKey[entry_Association] := Module[{source = Lookup[entry, "source", "top"]},
   Which[
    ListQ[source] && Length[source] >= 2 && StringContainsQ[ToString[First[source]], "shrinkSector"], sectorKeyFromShrunkLines[source[[2]]],
    True, "top"
    ]
   ];


seedEntryIBPClass[entry_Association] := Module[{source = ToString[Lookup[entry, "source", "unknown"], InputForm]},
   Which[
    StringContainsQ[source, "Momentum", IgnoreCase -> True], "qIBP",
    StringContainsQ[source, "momentum", IgnoreCase -> True], "qIBP",
    StringContainsQ[source, "Time", IgnoreCase -> True], "tIBP",
    StringContainsQ[source, "time", IgnoreCase -> True], "tIBP",
    True, "unknownIBP"
    ]
   ];


classifyCanonicalSeedBatch[batch_Association] := Module[
   {equations = Lookup[batch, "equations", {}], tagged, grouped},
   tagged = Join[#, <|"sectorKey" -> seedEntrySourceSectorKey[#], "ibpClass" -> seedEntryIBPClass[#]|>] & /@ equations;
   grouped = GroupBy[tagged, {#sectorKey &, #ibpClass &}];
   <|
    "status" -> If[Lookup[batch, "status", "missing"] === "generated", "generated", "notGenerated"],
    "caseName" -> Lookup[batch, "caseName", Missing["caseName"]],
    "sectorKeys" -> Sort[DeleteDuplicates[Lookup[tagged, "sectorKey", {}]]],
    "classes" -> Sort[DeleteDuplicates[Lookup[tagged, "ibpClass", {}]]],
    "equationCount" -> Length[tagged],
    "bySectorThenClass" -> grouped,
    "summary" -> Association @ KeyValueMap[#1 -> Map[Length, #2] &, grouped]
    |>
   ];


canonicalGeneratorStrings[list_] := Sort[ToString[#, InputForm] & /@ list];


expectedGeneratorsBySector[batch_Association] := Module[
   {topEntry, shrinkSummaries, shrinkEntries},
   topEntry = "top" -> <|
      "qIBP" -> Lookup[Lookup[batch, "momentumSummary", <||>], "generators", {}],
      "tIBP" -> Lookup[Lookup[batch, "timeSummary", <||>], "generators", {}]
      |>;
   shrinkSummaries = Lookup[Lookup[batch, "shrinkSectorSummary", <||>], "sectorSummaries", {}];
   shrinkEntries = Table[
     Lookup[summary, "sectorKey", sectorKeyFromShrunkLines[Lookup[summary, "sectorShrunkLines", {}]]] -> <|
       "qIBP" -> Lookup[Lookup[summary, "momentumSummary", <||>], "generators", {}],
       "tIBP" -> Lookup[Lookup[summary, "timeSummary", <||>], "generators", {}]
       |>,
     {summary, shrinkSummaries}
     ];
   Association[Join[{topEntry}, shrinkEntries]]
   ];


sectorGeneratorCoverageChecks[equations_List, expectedBySector_Association, sectorKeys_List] := Association @ Table[
    Module[
     {sectorEquations, actualQ, actualT, expected = Lookup[expectedBySector, sectorKey, <|"qIBP" -> {}, "tIBP" -> {}|>]},
     sectorEquations = Select[equations, seedEntrySourceSectorKey[#] === sectorKey &];
     actualQ = DeleteDuplicates @ Lookup[Select[sectorEquations, seedEntryIBPClass[#] === "qIBP" &], "generator", {}];
     actualT = DeleteDuplicates @ Lookup[Select[sectorEquations, seedEntryIBPClass[#] === "tIBP" &], "generator", {}];
     sectorKey -> <|
       "actualQGenerators" -> actualQ,
       "actualTGenerators" -> actualT,
       "expectedQGenerators" -> expected["qIBP"],
       "expectedTGenerators" -> expected["tIBP"],
       "qGeneratorCoverageQ" -> TrueQ[canonicalGeneratorStrings[actualQ] === canonicalGeneratorStrings[expected["qIBP"]]],
       "tGeneratorCoverageQ" -> TrueQ[canonicalGeneratorStrings[actualT] === canonicalGeneratorStrings[expected["tIBP"]]]
       |>
     ],
    {sectorKey, sectorKeys}
    ];


makeCanonicalSeedCoverageReport[batch_Association] := Module[
   {classified, summary, sectorKeys, equations, sectorClassChecks, topEquations, topQGenerators, topTGenerators,
    expectedQGenerators, expectedTGenerators, expectedBySector, sectorGeneratorChecks,
    totalClassifiedCount, forbiddenData, reportQ},
   classified = classifyCanonicalSeedBatch[batch];
   summary = Lookup[classified, "summary", <||>];
   sectorKeys = Lookup[Lookup[batch, "sectorMetadataList", {}], "sectorKey", {}];
   equations = Lookup[batch, "equations", {}];
   sectorClassChecks = Association @ Table[
      sectorKey -> <|
        "qIBPCount" -> Lookup[Lookup[summary, sectorKey, <||>], "qIBP", 0],
        "tIBPCount" -> Lookup[Lookup[summary, sectorKey, <||>], "tIBP", 0],
        "hasBothQAndT" -> TrueQ[
          Lookup[Lookup[summary, sectorKey, <||>], "qIBP", 0] > 0 &&
           Lookup[Lookup[summary, sectorKey, <||>], "tIBP", 0] > 0
          ]
        |>,
      {sectorKey, sectorKeys}
      ];
   topEquations = Select[equations, seedEntrySourceSectorKey[#] === "top" &];
   topQGenerators = DeleteDuplicates @ Lookup[Select[topEquations, seedEntryIBPClass[#] === "qIBP" &], "generator", {}];
   topTGenerators = DeleteDuplicates @ Lookup[Select[topEquations, seedEntryIBPClass[#] === "tIBP" &], "generator", {}];
   expectedQGenerators = Lookup[Lookup[batch, "momentumSummary", <||>], "generators", {}];
   expectedTGenerators = Lookup[Lookup[batch, "timeSummary", <||>], "generators", {}];
   expectedBySector = expectedGeneratorsBySector[batch];
   sectorGeneratorChecks = sectorGeneratorCoverageChecks[equations, expectedBySector, sectorKeys];
   totalClassifiedCount = Total[Cases[summary, _Integer, Infinity]];
   forbiddenData = DeleteCases[Flatten[Lookup[equations, "forbiddenNData", {}]], Null];
   reportQ = TrueQ[
     Lookup[batch, "status", Missing["status"]] === "generated" &&
      Lookup[batch, "pendingFeatures", {"missing"}] === {} &&
      Lookup[batch, "forbiddenNData", {"missing"}] === {} &&
      TrueQ[Lookup[batch, "eomCanonicalQ", False]] &&
      TrueQ[And @@ Lookup[equations, "eomCanonicalQ", {False}]] &&
      forbiddenData === {} &&
      totalClassifiedCount === Lookup[batch, "equationCount", Missing["equationCount"]] &&
      Sort[Lookup[classified, "sectorKeys", {}]] === Sort[sectorKeys] &&
      FreeQ[Lookup[classified, "classes", {}], "unknownIBP"] &&
      And @@ Lookup[Values[sectorClassChecks], "hasBothQAndT", {False}] &&
      And @@ Flatten[Lookup[Values[sectorGeneratorChecks], {"qGeneratorCoverageQ", "tGeneratorCoverageQ"}, {False}]] &&
      canonicalGeneratorStrings[topQGenerators] === canonicalGeneratorStrings[expectedQGenerators] &&
      canonicalGeneratorStrings[topTGenerators] === canonicalGeneratorStrings[expectedTGenerators]
     ];
   <|
    "status" -> If[reportQ, "ready", "notReady"],
    "caseName" -> Lookup[batch, "caseName", Missing["caseName"]],
    "passQ" -> reportQ,
    "canonicalSeedReadyQ" -> canonicalSeedReadyQ[batch],
    "sectorKeys" -> sectorKeys,
    "classes" -> Lookup[classified, "classes", {}],
    "classSummary" -> summary,
    "sectorClassChecks" -> sectorClassChecks,
    "sectorGeneratorChecks" -> sectorGeneratorChecks,
    "topQGenerators" -> topQGenerators,
    "topTGenerators" -> topTGenerators,
    "expectedQGenerators" -> expectedQGenerators,
    "expectedTGenerators" -> expectedTGenerators,
    "classifiedEquationCount" -> totalClassifiedCount,
    "equationCount" -> Lookup[batch, "equationCount", Missing["equationCount"]],
    "pendingFeatures" -> Lookup[batch, "pendingFeatures", {}],
    "forbiddenNData" -> Lookup[batch, "forbiddenNData", {}],
    "entryForbiddenNData" -> forbiddenData,
    "eomCanonicalQ" -> Lookup[batch, "eomCanonicalQ", False]
    |>
   ];



(* ::Chapter:: *)
(*seed MMA 保存与读取*)

(* seed batch 是前端产物，保存为 Mathematica 表达式；Kira exporter 只读取 linear-system 数据。 *)

Options[writeSeedBatchMMA] = {OutputDirectory -> None, SeedFileBaseName -> Automatic};


validOutputDirectoryOptionQ[value_] := value === None || value === Automatic || (StringQ[value] && StringLength[value] > 0);


validSeedFileBaseNameQ[value_] := value === Automatic || (StringQ[value] && StringLength[value] > 0);


validateSeedMMAOutputOptions[outputDir_, fileBaseName_] := Module[{issues = {}},
   If[! validOutputDirectoryOptionQ[outputDir],
    AppendTo[issues, <|"code" -> "invalidOutputDirectory", "optionKey" -> "OutputDirectory", "value" -> outputDir, "allowed" -> {"None", "Automatic", "non-empty string"}|>]
    ];
   If[! validSeedFileBaseNameQ[fileBaseName],
    AppendTo[issues, <|"code" -> "invalidSeedFileBaseName", "optionKey" -> "SeedFileBaseName", "value" -> fileBaseName, "allowed" -> {"Automatic", "non-empty string"}|>]
    ];
   <|"status" -> If[issues === {}, "ok", "invalidSeedMMAOutputOptions"], "issues" -> issues|>
   ];


validateSeedBatchForSave[batch_Association] := Module[{issues = {}},
   If[Lookup[batch, "status", Missing["status"]] =!= "generated",
    AppendTo[issues, <|"code" -> "seedBatchNotGenerated", "status" -> Lookup[batch, "status", Missing["status"]]|>]
    ];
   If[! KeyExistsQ[batch, "equations"] || ! ListQ[Lookup[batch, "equations", Missing["equations"]]],
    AppendTo[issues, <|"code" -> "seedBatchMissingEquations"|>]
    ];
   If[! KeyExistsQ[batch, "equationCount"],
    AppendTo[issues, <|"code" -> "seedBatchMissingEquationCount"|>]
    ];
   <|"status" -> If[issues === {}, "ok", "invalidSeedBatch"], "issues" -> issues|>
   ];


writeSeedBatchMMA[batch_Association, OptionsPattern[]] := Module[
   {outputDir = OptionValue[OutputDirectory], fileBaseName = OptionValue[SeedFileBaseName], outputOptionReport, batchReport, file},
   outputOptionReport = validateSeedMMAOutputOptions[outputDir, fileBaseName];
   If[outputOptionReport["status"] =!= "ok",
    Return[<|"status" -> "notWritten", "reason" -> "invalidSeedMMAOutputOptions", "outputOptionValidationReport" -> outputOptionReport|>]
    ];
   batchReport = validateSeedBatchForSave[batch];
   If[batchReport["status"] =!= "ok",
    Return[<|"status" -> "notWritten", "reason" -> "invalidSeedBatch", "seedBatchValidationReport" -> batchReport, "outputOptionValidationReport" -> outputOptionReport|>]
    ];
   If[! StringQ[outputDir], Return[<|"status" -> "notWritten", "reason" -> "OutputDirectory was not requested", "outputOptionValidationReport" -> outputOptionReport|>]];
   If[! DirectoryQ[outputDir], CreateDirectory[outputDir, CreateIntermediateDirectories -> True]];
   If[fileBaseName === Automatic, fileBaseName = Lookup[batch, "caseName", "seed_batch"] <> "_canonical_seed"];
   file = FileNameJoin[{outputDir, fileBaseName <> ".m"}];
   Put[batch, file];
   <|"status" -> "written", "file" -> file, "equationCount" -> Lookup[batch, "equationCount", Missing["equationCount"]]|>
   ];


readSeedBatchMMA[file_String] := If[FileExistsQ[file],
   Get[file],
   <|"status" -> "notRead", "reason" -> "fileNotFound", "file" -> file|>
   ];


(* ::Chapter:: *)
(*Kira user-defined system 导出*)

(* 本章按参考 codebubble 的 reduce_user_defined_system 格式导出。
   Kira exporter 的输入是已经撒点/替换参数后的线性系统数据，不直接消费 seed batch。
   userSystem/ibp.kira 每个非零方程一个 block，list 给目标积分编号，jobs.yaml 调用 Kira。
   默认只返回字符串；只有显式给 OutputDirectory 才写文件。 *)

kiraBackendSymbol[name_String] := Symbol["Global`" <> name];


(* Kira/Fermat 只接收小写原子变量；原始 Mathematica 变量可以是 kk[1,1] 这类非原子表达式。 *)
kiraCoefficientVariableMap[variables_List] := MapIndexed[
   <|"original" -> #1, "backend" -> ("dsc" <> ToString[First[#2]])|> &,
   variables
   ];


(* Fermat 的 user-system 文本不直接接收 Sqrt 等分数幂。把这些代数生成元先整体视为
   扩大有理函数域中的独立原子；importer 再按 manifest 恢复原 Mathematica 表达式。 *)
kiraCoefficientAlgebraicGenerators[coefficients_List] := SortBy[
   DeleteDuplicates @ Cases[
     coefficients,
     (power : Power[_, exponent_Rational] /; Denominator[exponent] > 1) :> power,
     Infinity
     ],
   ToString[InputForm[#]] &
   ];


kiraBackendCoefficientRules[variableMap_List] := Join[
   (Lookup[#, "original"] -> kiraBackendSymbol[Lookup[#, "backend"]]) & /@ variableMap
   ];


(* Mathematica 将 -I 和一般有理复数保存为不可再向下匹配的 Complex 原子，
   因此必须先把每个 Gaussian numeric atom 显式写成 a+b dsii，再替换其它系数原子。 *)
kiraBackendCoefficientExpression[expr_, variableMap_List] :=
   (expr /. value_Complex :> Re[value] + Im[value] kiraBackendSymbol["dsii"]) /.
    kiraBackendCoefficientRules[variableMap];


kiraCoefficientString[expr_, variableMap_List] := StringReplace[
   ToString[kiraBackendCoefficientExpression[expr, variableMap], InputForm],
   WhitespaceCharacter .. -> ""
   ];
kiraCoefficientString[expr_] := kiraCoefficientString[expr, {}];


kiraBackendCoefficientStringQ[text_String] := StringMatchQ[
   text,
   RegularExpression["[a-z0-9_+\\-*/^().]+"]
   ];


kiraBackendCoefficientSyntaxReport[linearEquations_List, variableMap_List] := Module[
   {coefficients, strings, badPositions},
   coefficients = Last /@ Flatten[kiraNonzeroCoefficientRules[#["coefficientRules"]] & /@ linearEquations];
   strings = kiraCoefficientString[#, variableMap] & /@ coefficients;
   badPositions = Flatten@Position[strings, text_ /; ! kiraBackendCoefficientStringQ[text], {1}, Heads -> False];
   <|
    "status" -> If[badPositions === {}, "valid", "invalid"],
    "coefficientCount" -> Length[strings],
    "badPositions" -> badPositions,
    "badStrings" -> Lookup[AssociationThread[Range[Length[strings]] -> strings], badPositions, {}]
    |>
   ];


kiraNonzeroCoefficientRules[coefficientRules_List] := Select[
   (First[#] -> Cancel[Last[#]]) & /@ coefficientRules,
   ! TrueQ[Last[#] === 0] &
   ];


kiraEquationBlock[linearEquation_Association, coefficientRules_List, variableMap_List : {}] := Module[
   {nonzeroRules},
   nonzeroRules = kiraNonzeroCoefficientRules[coefficientRules];
   If[nonzeroRules === {}, Return[""]];
   StringRiffle[ToString[First[#]] <> "*(" <> kiraCoefficientString[Last[#], variableMap] <> ")" & /@ nonzeroRules, "\n"] <> "\n\n"
   ];


kiraNumericCoefficientSystemQ[linearEquations_List] := Module[
   {coefficients},
   coefficients = Last /@ Flatten[kiraNonzeroCoefficientRules[#["coefficientRules"]] & /@ linearEquations];
   coefficients =!= {} && And @@ (TrueQ[NumericQ[#]] & /@ coefficients)
   ];


linearCoefficientDiagnostics[linearEquations_List] := Module[
   {coefficients, algebraicGenerators, ordinaryVariables, coefficientVariables},
   coefficients = Last /@ Flatten[kiraNonzeroCoefficientRules[#["coefficientRules"]] & /@ linearEquations];
   algebraicGenerators = kiraCoefficientAlgebraicGenerators[coefficients];
   ordinaryVariables = DeleteDuplicates[Variables[coefficients]];
   coefficientVariables = DeleteDuplicates[Join[algebraicGenerators, ordinaryVariables]];
   <|
    "numericCoefficientSystemQ" -> TrueQ[coefficients =!= {} && And @@ (TrueQ[NumericQ[#]] & /@ coefficients)],
    "coefficientVariables" -> coefficientVariables,
    "coefficientAlgebraicGenerators" -> algebraicGenerators
    |>
   ];


kiraAppendNumericDummyQ[setting_, numericSystemQ_] := If[setting === Automatic, TrueQ[numericSystemQ], TrueQ[setting]];


kiraDummyCoefficientString[symbol_] := If[StringQ[symbol], symbol, kiraCoefficientString[symbol]];


kiraDummyEquationBlock[id_Integer, symbol_] := ToString[id] <> "*(" <> kiraDummyCoefficientString[symbol] <> ")\n\n";


kiraTargetIntegralItems[targetSpec_] := Which[
   targetSpec === Automatic || targetSpec === All, Automatic,
   ListQ[targetSpec], targetSpec,
   True, {targetSpec}
   ];


kiraResolveTargetIntegralIDs[linearData_Association, targetSpec_, numericDummyIntegralId_] := Module[
   {maxId = linearData["integralCount"], idRules, items, resolvedPairs, missingItems, ids, invalidIds, targetIDs},
   idRules = Association[linearData["integralRules"]];
   items = kiraTargetIntegralItems[targetSpec];
   If[items === Automatic,
    targetIDs = Range[maxId],
    resolvedPairs = ({#, Which[
          IntegerQ[#], #,
          MatchQ[#, _J], Lookup[idRules, #, Missing["targetIntegralNotInSystem", #]],
          True, Missing["unsupportedTargetIntegral", #]
          ]} &) /@ items;
    missingItems = Cases[resolvedPairs, {item_, _Missing} :> item];
    ids = DeleteDuplicates[Cases[resolvedPairs, {_, id_Integer} :> id]];
    invalidIds = Select[ids, # < 1 || # > maxId &];
    If[missingItems =!= {} || invalidIds =!= {},
     Return[<|"status" -> "invalidTargetIntegrals", "targetSpec" -> targetSpec, "missingTargetItems" -> missingItems, "invalidTargetIDs" -> invalidIds, "maxIntegralID" -> maxId|>]
     ];
    targetIDs = ids
    ];
   If[numericDummyIntegralId =!= None && ! MemberQ[targetIDs, numericDummyIntegralId],
    targetIDs = Append[targetIDs, numericDummyIntegralId]
    ];
   If[targetIDs === {},
    Return[<|"status" -> "invalidTargetIntegrals", "targetSpec" -> targetSpec, "missingTargetItems" -> {}, "invalidTargetIDs" -> {}, "reason" -> "empty target list"|>]
    ];
   <|"status" -> "resolved", "targetSpec" -> targetSpec, "targetIDs" -> targetIDs, "targetIntegralCount" -> Length[targetIDs]|>
   ];


applyKiraCoefficientRulesToLinearEquation[linearEquation_Association, coeffRules_List] := Module[
   {rules, const},
   rules = linearEquation["coefficientRules"] /. coeffRules;
   rules = (First[#] -> Cancel[Last[#]]) & /@ rules;
   const = Cancel[linearEquation["constantTerm"] /. coeffRules];
   Join[linearEquation, <|"coefficientRules" -> rules, "constantTerm" -> const|>]
   ];


validReplacementRuleQ[rule_] := MatchQ[Unevaluated[rule], _Rule | _RuleDelayed];


validateCoefficientRules[coeffRules_] := Module[
   {badPositions},
   If[! ListQ[coeffRules],
    Return[<|"status" -> "invalidCoefficientRules", "reason" -> "coefficient rules must be a list of Rule or RuleDelayed entries", "coefficientRules" -> coeffRules|>]
    ];
   badPositions = Flatten @ Position[Unevaluated[coeffRules], rule_ /; ! validReplacementRuleQ[rule], {1}, Heads -> False];
   If[badPositions === {},
    <|"status" -> "ok", "coefficientRules" -> coeffRules|>,
    <|"status" -> "invalidCoefficientRules", "reason" -> "coefficient rules contain non-rule entries", "badPositions" -> badPositions, "coefficientRules" -> coeffRules|>
    ]
   ];


defaultKiraJobOptions[] := <|
   "RunInitiate" -> True,
   "RunFirefly" -> True,
   "WriteKira2MathJob" -> True,
   "Kira2MathTarget" -> "list",
   "AppendNumericDummyEquation" -> Automatic,
   "NumericDummySymbol" -> "ccc",
   "WriteRunScript" -> False,
   "RunScriptName" -> "run.sh",
   "KiraCommand" -> "kira",
   "KiraParallelJobs" -> 10,
   "RunScriptDos2Unix" -> True,
   "RunScriptCleanup" -> True
   |>;


allowedKiraJobOptionKeys[] := Keys[defaultKiraJobOptions[]];


validKiraJobOptionValueQ[key_, value_] /; MemberQ[{"RunInitiate", "RunFirefly", "WriteKira2MathJob", "WriteRunScript", "RunScriptDos2Unix", "RunScriptCleanup"}, key] := BooleanQ[value];
validKiraJobOptionValueQ["AppendNumericDummyEquation", value_] := value === Automatic || BooleanQ[value];
validKiraJobOptionValueQ["KiraParallelJobs", value_] := IntegerQ[value] && value > 0;
validKiraJobOptionValueQ[key_, value_] /; MemberQ[{"Kira2MathTarget", "NumericDummySymbol", "RunScriptName", "KiraCommand"}, key] := StringQ[value] && value =!= "";
validKiraJobOptionValueQ[_, _] := False;


validateKiraJobOptions[jobOptions_] := Module[
   {raw, unknownKeys, badValueData},
   If[jobOptions === Automatic,
    Return[<|"status" -> "ok", "issues" -> {}|>]
    ];
   raw = Which[
     AssociationQ[jobOptions], jobOptions,
     ListQ[jobOptions], Check[Association[jobOptions], $Failed],
     True, $Failed
     ];
   If[raw === $Failed,
    Return[<|"status" -> "invalidKiraJobOptions", "reason" -> "KiraJobOptions must be Automatic, Association, or rule list", "issues" -> {<|"code" -> "malformedKiraJobOptions", "jobOptions" -> jobOptions|>}|>]
    ];
   unknownKeys = Complement[Keys[raw], allowedKiraJobOptionKeys[]];
   badValueData = KeyValueMap[
     If[MemberQ[allowedKiraJobOptionKeys[], #1] && ! validKiraJobOptionValueQ[#1, #2],
       <|"optionKey" -> #1, "optionValue" -> #2|>,
       Nothing
       ] &,
     raw
     ];
   If[unknownKeys === {} && badValueData === {},
    <|"status" -> "ok", "issues" -> {}|>,
    <|
     "status" -> "invalidKiraJobOptions",
     "reason" -> "KiraJobOptions contain unknown keys or invalid values",
     "unknownKiraJobOptionKeys" -> unknownKeys,
     "malformedKiraJobOptionValues" -> badValueData,
     "allowedKiraJobOptionKeys" -> allowedKiraJobOptionKeys[]
     |>
    ]
   ];


validateKiraOutputDirectory[outputDir_] := If[validOutputDirectoryOptionQ[outputDir],
   <|"status" -> "ok", "issues" -> {}|>,
   <|"status" -> "invalidOutputDirectory", "issues" -> {<|"code" -> "invalidOutputDirectory", "optionKey" -> "OutputDirectory", "value" -> outputDir, "allowed" -> {"None", "Automatic", "non-empty string"}|>}|>
   ];


normalizeKiraJobOptions[Automatic] := defaultKiraJobOptions[];
normalizeKiraJobOptions[opts_Association] := Join[defaultKiraJobOptions[], opts];
normalizeKiraJobOptions[opts_List] := normalizeKiraJobOptions[Association[opts]];
normalizeKiraJobOptions[_] := defaultKiraJobOptions[];


kiraYAMLBool[value_] := If[TrueQ[value], "true", "false"];


kiraJobsYAML[jobOptions_: Automatic] := Module[
   {opts = normalizeKiraJobOptions[jobOptions], text},
   text = "jobs:\n" <>
     "  - reduce_user_defined_system:\n" <>
     "      input_system: {files: [\"userSystem\"], config: false}\n" <>
     "      select_integrals:\n" <>
     "        select_mandatory_list:\n" <>
     "          - [list]\n" <>
     "      run_initiate: " <> kiraYAMLBool[Lookup[opts, "RunInitiate", True]] <> "\n" <>
     "      run_firefly: " <> kiraYAMLBool[Lookup[opts, "RunFirefly", True]] <> "\n";
   If[TrueQ[Lookup[opts, "WriteKira2MathJob", True]],
    text = text <>
      "  - kira2math:\n" <>
      "      target:\n" <>
      "       - [" <> ToString[Lookup[opts, "Kira2MathTarget", "list"]] <> "]\n"
    ];
   text
   ];


kiraRunCommand[opts_Association] := Module[
   {cmd = ToString[Lookup[opts, "KiraCommand", "kira"]], parallel = Lookup[opts, "KiraParallelJobs", 10]},
   If[IntegerQ[parallel] && parallel > 0,
    cmd <> " --parallel=" <> ToString[parallel] <> " jobs.yaml",
    cmd <> " jobs.yaml"
    ]
   ];


kiraRunScript[jobOptions_: Automatic] := Module[
   {opts = normalizeKiraJobOptions[jobOptions], lines = {}},
   If[TrueQ[Lookup[opts, "RunScriptCleanup", True]],
    lines = Join[lines, {
        "rm -f kira.log",
        "rm -f firefly.log",
        "rm -rf results",
        "rm -rf tmp",
        "rm -rf sectormappings",
        "rm -rf firefly_saves",
        "rm -rf ff_save"
        }]
    ];
   If[TrueQ[Lookup[opts, "RunScriptDos2Unix", True]],
    lines = Join[lines, {
        "dos2unix list",
        "dos2unix userSystem/ibp.kira",
        "dos2unix jobs.yaml"
        }]
    ];
   lines = Append[lines, kiraRunCommand[opts]];
   StringRiffle[lines, "\n"] <> "\n"
   ];


makeKiraInputStrings[linearData_Association, coeffRules_ : {}, jobOptions_: Automatic, targetSpec_: Automatic] := Module[
   {linearEquations, badEquations, exportedEquations, ibpText, listText, jobsText, runScriptText, repKira2JText, repJ2KiraText, metadataText,
    normalizedJobOptions, jobOptionReport, coefficientRuleReport, topologyReport, requiredKeys, missingKeys, coefficientDiagnostics, numericCoefficientSystemQ, appendNumericDummyQ,
    numericDummyIntegralId, targetData, targetIntegralCount, kiraBlockCount, numericDummySymbol, rawCoeffRules, normalizedCoeffRules,
    coefficientVariableMap, backendCoefficientVariables, imaginaryUnitUsedQ, backendSyntaxReport},
   topologyReport = Lookup[linearData, "topologyValidationReport", Missing["NoTopologyValidationReport"]];
   If[Lookup[linearData, "status", "missing"] =!= "generated",
    Return[<|"status" -> "notGenerated", "reason" -> "linear data missing", "topologyValidationReport" -> topologyReport|>]
    ];
   If[topologyValidationErrorQ[topologyReport],
    Return[<|"status" -> "invalidTopology", "reason" -> "topology validation has errors", "topologyValidationReport" -> topologyReport|>]
    ];
   requiredKeys = {"linearEquations", "integralRules", "integralCount", "equationCount"};
   missingKeys = Select[requiredKeys, ! KeyExistsQ[linearData, #] &];
   If[missingKeys =!= {},
    Return[<|"status" -> "notLinearSystem", "reason" -> "Kira exporter expects makeLinearSystemData output", "topologyValidationReport" -> topologyReport, "missingKeys" -> missingKeys|>]
    ];
   jobOptionReport = validateKiraJobOptions[jobOptions];
   If[Lookup[jobOptionReport, "status", "ok"] =!= "ok",
    Return[Join[jobOptionReport, <|"topologyValidationReport" -> topologyReport|>]]
    ];
   rawCoeffRules = coeffRules;
   coefficientRuleReport = validateCoefficientRules[rawCoeffRules];
   If[Lookup[coefficientRuleReport, "status", "ok"] =!= "ok",
    Return[Join[coefficientRuleReport, <|"topologyValidationReport" -> topologyReport|>]]
    ];
   normalizedCoeffRules = normalizeCoefficientRulesForLinearData[rawCoeffRules, linearData];
   linearEquations = applyKiraCoefficientRulesToLinearEquation[#, normalizedCoeffRules] & /@ linearData["linearEquations"];
   badEquations = Select[linearEquations, ! TrueQ[#["linearQ"]] || ! TrueQ[#["constantTerm"] === 0] &];
   If[badEquations =!= {},
    Return[<|"status" -> "notLinear", "topologyValidationReport" -> topologyReport, "badEquationCount" -> Length[badEquations], "badEquations" -> badEquations|>]
    ];
   exportedEquations = Select[linearEquations, kiraNonzeroCoefficientRules[#["coefficientRules"]] =!= {} &];
   If[exportedEquations === {},
    Return[<|"status" -> "emptySystem", "reason" -> "all linear equations are zero after coefficient rules", "topologyValidationReport" -> topologyReport|>]
    ];
   normalizedJobOptions = normalizeKiraJobOptions[jobOptions];
   coefficientDiagnostics = linearCoefficientDiagnostics[exportedEquations];
   coefficientVariableMap = kiraCoefficientVariableMap[coefficientDiagnostics["coefficientVariables"]];
   imaginaryUnitUsedQ = ! FreeQ[
      Last /@ Flatten[kiraNonzeroCoefficientRules[#["coefficientRules"]] & /@ exportedEquations],
      _Complex
      ];
   backendCoefficientVariables = Join[
      Lookup[coefficientVariableMap, "backend", {}],
      If[imaginaryUnitUsedQ, {"dsii"}, {}]
      ];
   backendSyntaxReport = kiraBackendCoefficientSyntaxReport[exportedEquations, coefficientVariableMap];
   If[Lookup[backendSyntaxReport, "status", "invalid"] =!= "valid",
    Return[<|
      "status" -> "invalidBackendCoefficientSyntax",
      "reason" -> "Kira/Fermat coefficients must contain only lowercase atomic variables and rational operators",
      "coefficientVariableMap" -> coefficientVariableMap,
      "backendCoefficientSyntaxReport" -> backendSyntaxReport,
      "topologyValidationReport" -> topologyReport
      |>]
    ];
   numericCoefficientSystemQ = coefficientDiagnostics["numericCoefficientSystemQ"];
   appendNumericDummyQ = kiraAppendNumericDummyQ[Lookup[normalizedJobOptions, "AppendNumericDummyEquation", Automatic], numericCoefficientSystemQ];
   numericDummyIntegralId = If[appendNumericDummyQ, linearData["integralCount"] + 1, None];
   targetData = kiraResolveTargetIntegralIDs[linearData, targetSpec, numericDummyIntegralId];
   If[Lookup[targetData, "status", "missing"] =!= "resolved",
    Return[Join[targetData, <|"topologyValidationReport" -> topologyReport|>]]
    ];
   targetIntegralCount = targetData["targetIntegralCount"];
   kiraBlockCount = Length[exportedEquations] + If[appendNumericDummyQ, 1, 0];
   numericDummySymbol = Lookup[normalizedJobOptions, "NumericDummySymbol", "ccc"];
   ibpText = StringJoin[kiraEquationBlock[#, #["coefficientRules"], coefficientVariableMap] & /@ exportedEquations] <>
     If[appendNumericDummyQ, kiraDummyEquationBlock[numericDummyIntegralId, numericDummySymbol], ""];
   listText = StringRiffle[ToString /@ targetData["targetIDs"], "\n"] <> "\n";
   jobsText = kiraJobsYAML[normalizedJobOptions];
   runScriptText = If[TrueQ[Lookup[normalizedJobOptions, "WriteRunScript", False]], kiraRunScript[normalizedJobOptions], Missing["RunScriptDisabled"]];
   repKira2JText = ToString[InputForm[linearData["integralRules"] /. (j_J -> id_Integer) :> (Tuserweight[id] -> j)]] <> "\n";
   repJ2KiraText = ToString[InputForm[linearData["integralRules"]]] <> "\n";
   metadataText = ToString[InputForm[
       Join[
        KeyDrop[linearData, {"integralList", "integralRules", "linearEquations", "topology"}],
        <|
         "exportedEquationCount" -> Length[exportedEquations],
         "kiraBlockCount" -> kiraBlockCount,
         "targetIntegralCount" -> targetIntegralCount,
         "targetIntegralIDs" -> targetData["targetIDs"],
         "kiraTargetIntegrals" -> targetSpec,
         "numericCoefficientSystemQ" -> numericCoefficientSystemQ,
         "coefficientVariables" -> coefficientDiagnostics["coefficientVariables"],
         "coefficientAlgebraicGenerators" -> coefficientDiagnostics["coefficientAlgebraicGenerators"],
         "coefficientVariableMap" -> coefficientVariableMap,
         "backendCoefficientVariables" -> backendCoefficientVariables,
         "backendImaginaryUnit" -> If[imaginaryUnitUsedQ, "dsii", None],
         "backendCoefficientSyntaxReport" -> backendSyntaxReport,
         "numericDummyAppendedQ" -> appendNumericDummyQ,
         "numericDummyIntegralId" -> numericDummyIntegralId,
         "kiraCoefficientRules" -> normalizedCoeffRules,
         "userKiraCoefficientRules" -> userCoefficientRulesForLinearData[normalizedCoeffRules, linearData],
         "kiraJobOptions" -> normalizedJobOptions
         |>
        ]
       ]] <> "\n";
   <|
    "status" -> "generated",
    "topologyValidationReport" -> topologyReport,
    "ibp.kira" -> ibpText,
    "list" -> listText,
    "jobs.yaml" -> jobsText,
    "runScriptName" -> Lookup[normalizedJobOptions, "RunScriptName", "run.sh"],
    "run.sh" -> runScriptText,
    "result/repkira2J.m" -> repKira2JText,
    "result/repJ2kira.m" -> repJ2KiraText,
    "result/kira_export_metadata.m" -> metadataText,
    "equationCount" -> linearData["equationCount"],
    "exportedEquationCount" -> Length[exportedEquations],
    "kiraBlockCount" -> kiraBlockCount,
    "integralCount" -> linearData["integralCount"],
    "targetIntegralCount" -> targetIntegralCount,
    "targetIntegralIDs" -> targetData["targetIDs"],
    "kiraTargetIntegrals" -> targetSpec,
    "numericCoefficientSystemQ" -> numericCoefficientSystemQ,
    "coefficientVariables" -> coefficientDiagnostics["coefficientVariables"],
    "coefficientAlgebraicGenerators" -> coefficientDiagnostics["coefficientAlgebraicGenerators"],
    "coefficientVariableMap" -> coefficientVariableMap,
    "backendCoefficientVariables" -> backendCoefficientVariables,
    "backendImaginaryUnit" -> If[imaginaryUnitUsedQ, "dsii", None],
    "backendCoefficientSyntaxReport" -> backendSyntaxReport,
    "numericDummyAppendedQ" -> appendNumericDummyQ,
    "numericDummyIntegralId" -> numericDummyIntegralId,
    "kiraCoefficientRulesApplied" -> normalizedCoeffRules,
    "userKiraCoefficientRulesApplied" -> userCoefficientRulesForLinearData[normalizedCoeffRules, linearData]
    |>
   ];


(* Kira 的 Linux user-system parser 会把 CRLF 空行误读为非空方程；所有后端文本固定写成无 BOM UTF-8/LF。 *)
writeKiraUTF8LFText[path_String, text_String] := Module[{stream, normalized, bytes},
   normalized = StringReplace[text, {"\r\n" -> "\n", "\r" -> "\n"}];
   bytes = ToCharacterCode[normalized, "UTF8"];
   stream = OpenWrite[path, BinaryFormat -> True];
   BinaryWrite[stream, bytes, "Byte"];
   Close[stream];
   path
   ];


writeKiraInputFiles[outputDir_String, strings_Association] := Module[
   {userSystemDir, resultDir, runScriptName, files},
   userSystemDir = FileNameJoin[{outputDir, "userSystem"}];
   resultDir = FileNameJoin[{outputDir, "result"}];
   If[! DirectoryQ[outputDir], CreateDirectory[outputDir, CreateIntermediateDirectories -> True]];
   If[! DirectoryQ[userSystemDir], CreateDirectory[userSystemDir, CreateIntermediateDirectories -> True]];
   If[! DirectoryQ[resultDir], CreateDirectory[resultDir, CreateIntermediateDirectories -> True]];
   runScriptName = Lookup[strings, "runScriptName", "run.sh"];
   files = <|
     FileNameJoin[{userSystemDir, "ibp.kira"}] -> strings["ibp.kira"],
     FileNameJoin[{outputDir, "list"}] -> strings["list"],
     FileNameJoin[{outputDir, "jobs.yaml"}] -> strings["jobs.yaml"],
     FileNameJoin[{resultDir, "repkira2J.m"}] -> strings["result/repkira2J.m"],
     FileNameJoin[{resultDir, "repJ2kira.m"}] -> strings["result/repJ2kira.m"],
     FileNameJoin[{resultDir, "kira_export_metadata.m"}] -> strings["result/kira_export_metadata.m"]
     |>;
   If[StringQ[Lookup[strings, "run.sh", Missing["NoRunScript"]]],
    files = Join[files, <|FileNameJoin[{outputDir, runScriptName}] -> strings["run.sh"]|>]
    ];
   KeyValueMap[writeKiraUTF8LFText, files];
   Keys[files]
   ];


Options[makeKiraExportData] = {
   OutputDirectory -> None,
   KiraCoefficientRules -> {},
   KiraIntegralOrder -> Automatic,
   KiraTargetIntegrals -> Automatic,
   KiraJobOptions -> Automatic
   };

makeKiraExportData::notlinearinput = "Kira 导出只接受 linear-system 数据，不直接接受 seed batch：`1`。";
makeKiraExportData::badlinear = "linear-system 不能导出 Kira：`1`。";


makeKiraExportData[linearData_Association, OptionsPattern[]] := Module[
   {linearForExport, strings, outputDir, outputDirReport, filesWritten, topologyReport, integralOrderReport},
   topologyReport = Lookup[linearData, "topologyValidationReport", Missing["NoTopologyValidationReport"]];
   outputDir = OptionValue[OutputDirectory];
   outputDirReport = validateKiraOutputDirectory[outputDir];
   If[outputDirReport["status"] =!= "ok",
    Return[<|
      "status" -> "notReady",
      "caseName" -> Lookup[linearData, "caseName", Missing["caseName"]],
      "topologyValidationReport" -> topologyReport,
      "reason" -> "invalidOutputDirectory",
      "kiraInput" -> outputDirReport
      |>]
    ];
   If[! KeyExistsQ[linearData, "linearEquations"],
    Message[makeKiraExportData::notlinearinput, Lookup[linearData, "caseName", Missing["caseName"]]];
    Return[<|
      "status" -> "notReady",
      "caseName" -> Lookup[linearData, "caseName", Missing["caseName"]],
      "topologyValidationReport" -> topologyReport,
      "reason" -> "Kira exporter expects linear-system data; save seed batch as MMA first, then call makeLinearSystemData after numeric/sampling choices"
      |>]
    ];
   integralOrderReport = validateKiraIntegralOrderSpec[OptionValue[KiraIntegralOrder]];
   If[Lookup[integralOrderReport, "status", "ok"] =!= "ok",
    Return[<|"status" -> "notReady", "caseName" -> Lookup[linearData, "caseName", Missing["caseName"]], "topologyValidationReport" -> topologyReport, "reason" -> "invalid KiraIntegralOrder", "linearSystem" -> linearData, "kiraInput" -> integralOrderReport|>]
    ];
   linearForExport = If[ListQ[OptionValue[KiraIntegralOrder]], reorderLinearSystemIntegrals[linearData, OptionValue[KiraIntegralOrder]], linearData];
   strings = makeKiraInputStrings[linearForExport, OptionValue[KiraCoefficientRules], OptionValue[KiraJobOptions], OptionValue[KiraTargetIntegrals]];
   If[Lookup[strings, "status", "missing"] =!= "generated",
    If[! MemberQ[{"invalidKiraJobOptions", "invalidCoefficientRules"}, Lookup[strings, "status", Missing["status"]]],
     Message[makeKiraExportData::badlinear, Lookup[strings, "status", Missing["status"]]]
     ];
    Return[<|"status" -> "notReady", "caseName" -> linearForExport["caseName"], "topologyValidationReport" -> Lookup[linearForExport, "topologyValidationReport", topologyReport], "reason" -> "linear system is not exportable", "linearSystem" -> linearForExport, "kiraInput" -> strings|>]
    ];
   filesWritten = If[StringQ[outputDir], writeKiraInputFiles[outputDir, strings], {}];
   <|
    "status" -> "ready",
    "caseName" -> linearForExport["caseName"],
    "topologyValidationReport" -> Lookup[linearForExport, "topologyValidationReport", topologyReport],
    "linearSystem" -> linearForExport,
    "kiraInput" -> strings,
    "equationCount" -> Lookup[linearForExport, "equationCount", Missing["equationCount"]],
    "exportedEquationCount" -> Lookup[strings, "exportedEquationCount", Missing["exportedEquationCount"]],
    "kiraBlockCount" -> Lookup[strings, "kiraBlockCount", Missing["kiraBlockCount"]],
    "integralCount" -> Lookup[linearForExport, "integralCount", Missing["integralCount"]],
    "kiraOrderingReport" -> Lookup[linearForExport, "kiraOrderingReport", <||>],
    "manualIntegralOrderReport" -> Lookup[linearForExport, "manualIntegralOrderReport", <||>],
    "targetIntegralCount" -> Lookup[strings, "targetIntegralCount", Missing["targetIntegralCount"]],
    "targetIntegralIDs" -> Lookup[strings, "targetIntegralIDs", Missing["targetIntegralIDs"]],
    "kiraTargetIntegrals" -> Lookup[strings, "kiraTargetIntegrals", Missing["kiraTargetIntegrals"]],
    "numericCoefficientSystemQ" -> Lookup[strings, "numericCoefficientSystemQ", Missing["numericCoefficientSystemQ"]],
    "coefficientVariables" -> Lookup[strings, "coefficientVariables", Missing["coefficientVariables"]],
    "coefficientAlgebraicGenerators" -> Lookup[strings, "coefficientAlgebraicGenerators", {}],
    "coefficientVariableMap" -> Lookup[strings, "coefficientVariableMap", {}],
    "backendCoefficientVariables" -> Lookup[strings, "backendCoefficientVariables", {}],
    "backendImaginaryUnit" -> Lookup[strings, "backendImaginaryUnit", None],
    "backendCoefficientSyntaxReport" -> Lookup[strings, "backendCoefficientSyntaxReport", <||>],
    "numericDummyAppendedQ" -> Lookup[strings, "numericDummyAppendedQ", Missing["numericDummyAppendedQ"]],
    "numericDummyIntegralId" -> Lookup[strings, "numericDummyIntegralId", Missing["numericDummyIntegralId"]],
    "outputDirectory" -> outputDir,
    "writeFilesQ" -> StringQ[outputDir],
    "filesWritten" -> filesWritten
    |>
   ];


(* ::Chapter:: *)
(*端到端轻量工作流入口*)

(* 本章只把 topology、canonical seed、linear-system 和 Kira 文件导出按 gate 串起来。
   它不运行 Kira reduction，也不改变底层 seed/linear/export 函数的物理逻辑。 *)

Options[makeIBPWorkflowData] = Join[
   Options[makeCanonicalSeedBatch],
   {
    LinearSystemMode -> "symbolic",
    CoefficientRules -> Automatic,
    KiraOrdering -> Automatic,
    OutputDirectory -> None,
    ExportKira -> False,
    KiraCoefficientRules -> Automatic,
    KiraIntegralOrder -> Automatic,
    KiraTargetIntegrals -> Automatic,
    KiraJobOptions -> Automatic
    }
   ];


validWorkflowOutputDirectoryQ[value_] := validOutputDirectoryOptionQ[value];


validateIBPWorkflowOptions[exportKira_, outputDirectory_] := Module[{issues = {}},
   If[! BooleanQ[exportKira],
    AppendTo[issues, <|"code" -> "invalidExportKiraValue", "optionKey" -> "ExportKira", "value" -> exportKira, "allowed" -> {True, False}|>]
    ];
   If[! validWorkflowOutputDirectoryQ[outputDirectory],
    AppendTo[issues, <|"code" -> "invalidOutputDirectory", "optionKey" -> "OutputDirectory", "value" -> outputDirectory, "allowed" -> {"None", "Automatic", "non-empty string"}|>]
    ];
   <|"status" -> If[issues === {}, "ok", "invalidWorkflowOptions"], "issues" -> issues|>
   ];


makeIBPWorkflowData[caseOrTopo_Association, opts : OptionsPattern[]] := Module[
   {topo, seedOpts, batch, linearOpts, linearMode, coeffRules, linearData,
     exportQ, kiraCoeffRules, kiraOpts, kiraData, seedCoverageReport, topologyReport,
     allowedLinearModes, workflowOptionReport, inputReport, numericRequirementReport, missingExternalInvariants, missingVertexEnergies, missingLineParameters},
   If[! parsedTopologyQ[caseOrTopo] && caseInputPreflightErrorQ[caseOrTopo],
    inputReport = caseInputRequirementReport[caseOrTopo];
    topologyReport = caseInputErrorReport[caseOrTopo];
    Return[<|
      "status" -> "notReady",
      "stage" -> "topology",
      "reason" -> If[inputReport["missingRequiredKeys"] =!= {}, "missingRequiredCaseKeys", "malformedCaseInput"],
      "missingRequiredKeys" -> inputReport["missingRequiredKeys"],
      "malformedInputIssues" -> inputReport["malformedInputIssues"],
      "inputRequirementReport" -> inputReport,
      "topologyValidationReport" -> topologyReport
      |>]
    ];
   topo = If[KeyExistsQ[caseOrTopo, "lines"] && KeyExistsQ[caseOrTopo, "nL"], caseOrTopo, parseTopology[caseOrTopo]];
   topologyReport = topologyValidationReport[topo];
   numericRequirementReport = numericRuleRequirementReport[topo];
   linearMode = OptionValue[LinearSystemMode];
   allowedLinearModes = {"symbolic", "sampled", "numeric"};
   If[! MemberQ[allowedLinearModes, linearMode],
     Return[<|
       "status" -> "notReady",
       "stage" -> "linear",
      "reason" -> "invalidLinearSystemMode",
      "linearSystemMode" -> linearMode,
      "allowedLinearSystemModes" -> allowedLinearModes,
      "topology" -> topo,
      "topologyValidationReport" -> topologyReport,
      "numericRuleRequirementReport" -> numericRequirementReport
       |>]
     ];
   workflowOptionReport = validateIBPWorkflowOptions[OptionValue[ExportKira], OptionValue[OutputDirectory]];
   If[workflowOptionReport["status"] =!= "ok",
    Return[<|
      "status" -> "notReady",
      "stage" -> "workflow",
      "reason" -> "invalidWorkflowOptions",
      "workflowOptionValidationReport" -> workflowOptionReport,
      "topology" -> topo,
      "topologyValidationReport" -> topologyReport,
      "numericRuleRequirementReport" -> numericRequirementReport
      |>]
    ];
   missingExternalInvariants = numericRequirementReport["missingExternalInvariants"];
   If[linearMode === "numeric" && missingExternalInvariants =!= {},
    Return[<|
      "status" -> "notReady",
      "stage" -> "linear",
      "reason" -> "numericRulesMissingExternalInvariants",
      "missingExternalInvariants" -> missingExternalInvariants,
      "topology" -> topo,
      "topologyValidationReport" -> topologyReport,
      "numericRuleRequirementReport" -> numericRequirementReport
      |>]
    ];
   missingVertexEnergies = numericRequirementReport["missingVertexEnergies"];
   If[linearMode === "numeric" && missingVertexEnergies =!= {},
    Return[<|
      "status" -> "notReady",
      "stage" -> "linear",
      "reason" -> "numericRulesMissingVertexEnergies",
      "missingVertexEnergies" -> missingVertexEnergies,
      "topology" -> topo,
      "topologyValidationReport" -> topologyReport,
      "numericRuleRequirementReport" -> numericRequirementReport
      |>]
    ];
   missingLineParameters = numericRequirementReport["missingLineParameters"];
   If[linearMode === "numeric" && missingLineParameters =!= {},
    Return[<|
      "status" -> "notReady",
      "stage" -> "linear",
      "reason" -> "numericRulesMissingLineParameters",
      "missingLineParameters" -> missingLineParameters,
      "topology" -> topo,
      "topologyValidationReport" -> topologyReport,
      "numericRuleRequirementReport" -> numericRequirementReport
      |>]
    ];
   seedOpts = FilterRules[{opts}, Options[makeCanonicalSeedBatch]];
   batch = makeCanonicalSeedBatch[topo, Sequence @@ seedOpts];
   seedCoverageReport = makeCanonicalSeedCoverageReport[batch];
   If[Lookup[batch, "status", "missing"] =!= "generated" || ! TrueQ[canonicalSeedReadyQ[batch]] || ! TrueQ[Lookup[seedCoverageReport, "passQ", False]],
    Return[<|"status" -> "notReady", "stage" -> "seed", "topology" -> topo, "topologyValidationReport" -> topologyReport, "numericRuleRequirementReport" -> numericRequirementReport, "seedBatch" -> KeyDrop[batch, "equations"], "seedCoverageReport" -> seedCoverageReport|>]
   ];
   linearOpts = FilterRules[{opts}, Options[makeLinearSystemData]];
   coeffRules = OptionValue[CoefficientRules];
   linearData = If[linearMode === "sampled" || linearMode === "numeric",
     makeSampledLinearSystemData[batch, topo, Sequence @@ linearOpts, CoefficientRules -> coeffRules],
     makeLinearSystemData[batch, topo, Sequence @@ linearOpts]
     ];
   If[Lookup[linearData, "status", "missing"] =!= "generated" || ! TrueQ[Lookup[linearData, "linearQ", False]],
    Return[<|"status" -> "notReady", "stage" -> "linear", "topology" -> topo, "topologyValidationReport" -> topologyReport, "numericRuleRequirementReport" -> numericRequirementReport, "seedBatch" -> KeyDrop[batch, "equations"], "linearSystem" -> linearData|>]
    ];
   If[linearMode === "numeric" && ! TrueQ[Lookup[linearData, "numericCoefficientSystemQ", False]],
    Return[<|
      "status" -> "notReady",
      "stage" -> "linear",
      "reason" -> "nonNumericCoefficients",
      "coefficientVariables" -> Lookup[linearData, "coefficientVariables", {}],
      "topology" -> topo,
      "topologyValidationReport" -> topologyReport,
      "numericRuleRequirementReport" -> numericRequirementReport,
      "seedBatch" -> KeyDrop[batch, "equations"],
      "linearSystem" -> linearData
      |>]
    ];
   exportQ = TrueQ[OptionValue[ExportKira]] || StringQ[OptionValue[OutputDirectory]];
   kiraCoeffRules = If[OptionValue[KiraCoefficientRules] === Automatic,
     If[linearMode === "sampled" || linearMode === "numeric", {}, topo["numericRules"]],
     OptionValue[KiraCoefficientRules]
     ];
   kiraOpts = FilterRules[
     {
      OutputDirectory -> OptionValue[OutputDirectory],
      KiraCoefficientRules -> kiraCoeffRules,
      KiraIntegralOrder -> OptionValue[KiraIntegralOrder],
      KiraTargetIntegrals -> OptionValue[KiraTargetIntegrals],
      KiraJobOptions -> OptionValue[KiraJobOptions]
      },
     Options[makeKiraExportData]
     ];
   kiraData = If[exportQ, makeKiraExportData[linearData, Sequence @@ kiraOpts], <|"status" -> "skipped"|>];
   <|
    "status" -> If[exportQ, Lookup[kiraData, "status", "missing"], "ready"],
    "stage" -> If[exportQ, "kira", "linear"],
    "topology" -> topo,
    "topologyValidationReport" -> topologyReport,
    "numericRuleRequirementReport" -> numericRequirementReport,
    "seedBatch" -> batch,
    "seedCoverageReport" -> seedCoverageReport,
    "linearSystem" -> linearData,
    "kiraExport" -> kiraData
   |>
   ];


readinessIssueCodes[report_] := If[AssociationQ[report], Lookup[Lookup[report, "issues", {}], "code", {}], {}];


readinessStatusFromQ[q_] := If[TrueQ[q], "ready", "notReady"];


Options[makeIBPReadinessReport] = Options[makeIBPWorkflowData];


makeIBPReadinessReport[caseOrTopo_Association, opts : OptionsPattern[]] := Module[
   {workflow, topologyReport, seedBatch, seedReport, linearData, kiraData, exportQ, topologyReadyQ, seedReadyQ,
     linearReadyQ, kiraReadyQ, numericRequirementReport, workflowOptionReport},
   workflow = makeIBPWorkflowData[caseOrTopo, opts];
   workflowOptionReport = Lookup[workflow, "workflowOptionValidationReport", validateIBPWorkflowOptions[OptionValue[ExportKira], OptionValue[OutputDirectory]]];
   topologyReport = Lookup[workflow, "topologyValidationReport", <||>];
   numericRequirementReport = Lookup[workflow, "numericRuleRequirementReport", Lookup[topologyReport, "numericRuleRequirementReport", <||>]];
   seedBatch = Lookup[workflow, "seedBatch", <||>];
   seedReport = Lookup[workflow, "seedCoverageReport", <||>];
   linearData = Lookup[workflow, "linearSystem", <||>];
   kiraData = Lookup[workflow, "kiraExport", <|"status" -> "skipped"|>];
   exportQ = workflowOptionReport["status"] === "ok" && (TrueQ[OptionValue[ExportKira]] || (StringQ[OptionValue[OutputDirectory]] && StringLength[OptionValue[OutputDirectory]] > 0));
   topologyReadyQ = AssociationQ[topologyReport] && ! topologyValidationErrorQ[topologyReport];
   seedReadyQ = AssociationQ[seedReport] && Lookup[seedReport, "status", Missing["status"]] === "ready";
   linearReadyQ = AssociationQ[linearData] && Lookup[linearData, "status", Missing["status"]] === "generated" && TrueQ[Lookup[linearData, "linearQ", False]];
   kiraReadyQ = If[exportQ, AssociationQ[kiraData] && Lookup[kiraData, "status", Missing["status"]] === "ready", Missing["NotRequested"]];
   <|
    "status" -> Lookup[workflow, "status", Missing["status"]],
    "stage" -> Lookup[workflow, "stage", Missing["stage"]],
    "caseName" -> Lookup[Lookup[workflow, "topology", <||>], "name", Lookup[workflow, "caseName", Missing["caseName"]]],
    "topologyReadyQ" -> topologyReadyQ,
    "seedReadyQ" -> seedReadyQ,
    "linearReadyQ" -> linearReadyQ,
    "kiraRequestedQ" -> exportQ,
    "kiraReadyQ" -> kiraReadyQ,
    "topologyStatus" -> Lookup[topologyReport, "status", Missing["status"]],
    "topologyIssueCodes" -> readinessIssueCodes[topologyReport],
    "inputRequirementReport" -> Lookup[workflow, "inputRequirementReport", Lookup[topologyReport, "inputRequirementReport", <||>]],
    "missingRequiredKeys" -> Lookup[workflow, "missingRequiredKeys", {}],
    "malformedInputIssues" -> Lookup[workflow, "malformedInputIssues", Lookup[Lookup[workflow, "inputRequirementReport", <||>], "malformedInputIssues", {}]],
    "seedStatus" -> Lookup[seedBatch, "status", Missing["notGenerated"]],
    "seedCoverageStatus" -> Lookup[seedReport, "status", Missing["notGenerated"]],
    "linearStatus" -> Lookup[linearData, "status", Missing["notGenerated"]],
    "kiraStatus" -> Lookup[kiraData, "status", "skipped"],
    "equationCount" -> Lookup[seedBatch, "equationCount", Missing["notGenerated"]],
    "linearEquationCount" -> Lookup[linearData, "equationCount", Missing["notGenerated"]],
    "integralCount" -> Lookup[linearData, "integralCount", Missing["notGenerated"]],
    "exportedEquationCount" -> Lookup[kiraData, "exportedEquationCount", Missing["notGenerated"]],
     "linearSystemMode" -> OptionValue[LinearSystemMode],
     "workflowOptionValidationReport" -> workflowOptionReport,
     "numericCoefficientSystemQ" -> Lookup[linearData, "numericCoefficientSystemQ", Missing["notGenerated"]],
    "coefficientVariables" -> DeleteDuplicates[Flatten[{
        Lookup[workflow, "coefficientVariables", {}],
        Lookup[linearData, "coefficientVariables", {}]
        }]],
    "numericRuleRequirementReport" -> numericRequirementReport,
    "missingExternalInvariants" -> Lookup[workflow, "missingExternalInvariants", {}],
    "missingVertexEnergies" -> Lookup[workflow, "missingVertexEnergies", {}],
    "missingLineParameters" -> Lookup[workflow, "missingLineParameters", {}],
    "pendingFeatures" -> DeleteDuplicates[Flatten[{
        Lookup[topologyReport, "pendingFeatures", {}],
        Lookup[seedBatch, "pendingFeatures", {}],
        Lookup[seedReport, "pendingFeatures", {}],
        Lookup[linearData, "pendingFeatures", {}]
        }]],
    "workflowReason" -> Lookup[workflow, "reason", None],
    "readinessByStage" -> <|
      "topology" -> readinessStatusFromQ[topologyReadyQ],
      "seed" -> readinessStatusFromQ[seedReadyQ],
      "linear" -> readinessStatusFromQ[linearReadyQ],
      "kira" -> If[exportQ, readinessStatusFromQ[kiraReadyQ], "notRequested"]
      |>,
    "workflowSummary" -> KeyDrop[workflow, {"topology", "seedBatch", "linearSystem", "kiraExport"}]
    |>
   ];


(* ::Chapter:: *)
(*线性系统中间格式*)

(* 本章把 seed 方程转成后端可消费的线性系统数据。
   这里只做积分抽取、编号和逐项系数收集，不做求解、排序优化或 Kira 文件语法假设。 *)

integralObjectsInExpression[expr_] := DeleteDuplicates[Cases[expr, _J, {0, Infinity}]];


integralObjectsInBatch[batch_Association] := DeleteDuplicates[
   Flatten[integralObjectsInExpression /@ Lookup[Lookup[batch, "equations", {}], "equation", {}]]
   ];


makeIntegralIndex[integrals_List] := AssociationThread[integrals, Range[Length[integrals]]];


linearTermData[term_, integralIndex_Association] := Module[
   {integrals, integral, coeff},
   integrals = Cases[term, _J, {0, Infinity}];
   Which[
    Length[integrals] == 0,
    <|"kind" -> "constant", "term" -> term|>,
    Length[DeleteDuplicates[integrals]] == 1,
    integral = First[DeleteDuplicates[integrals]];
    coeff = Cancel[term/integral];
    If[FreeQ[coeff, _J] && KeyExistsQ[integralIndex, integral],
     <|"kind" -> "linear", "id" -> integralIndex[integral], "integral" -> integral, "coefficient" -> coeff|>,
     <|"kind" -> "nonlinear", "term" -> term|>
     ],
    True,
    <|"kind" -> "nonlinear", "term" -> term|>
    ]
   ];


combineLinearCoefficientRules[linearTerms_List] := Normal @ Merge[
    (Rule[#["id"], #["coefficient"]] & /@ linearTerms),
    Total
    ];

reindexLinearEquation[eq_Association, oldIdToNewId_Association] := Module[
   {rules},
   rules = Select[
     (Lookup[oldIdToNewId, First[#], Missing["DroppedIntegral"]] -> Last[#]) & /@ Lookup[eq, "coefficientRules", {}],
     Head[First[#]] =!= Missing &
     ];
   Join[eq, <|"coefficientRules" -> Normal@Merge[rules, Total]|>]
   ];


reorderLinearSystemIntegrals[linearData_Association, integralOrder_List] := Module[
   {oldIntegrals, requested, newIntegrals, oldRules, oldIdToIntegral, newIndex, oldIdToNewId,
    newLinearEquations, metadataList, orderingSpec, manualOrderReport},
   If[Lookup[linearData, "status", "missing"] =!= "generated" || ! KeyExistsQ[linearData, "integralList"], Return[linearData]];
   oldIntegrals = linearData["integralList"];
   requested = normaliseIntegralOrder[integralOrder, oldIntegrals];
   newIntegrals = Join[requested, Select[oldIntegrals, ! MemberQ[requested, #] &]];
   oldRules = Association[linearData["integralRules"]];
   oldIdToIntegral = Association[Reverse /@ Normal[oldRules]];
   newIndex = makeIntegralIndex[newIntegrals];
   oldIdToNewId = Association @ KeyValueMap[#1 -> newIndex[#2] &, oldIdToIntegral];
   newLinearEquations = reindexLinearEquation[#, oldIdToNewId] & /@ linearData["linearEquations"];
   metadataList = Lookup[linearData, "sectorMetadataList", {}];
   orderingSpec = Join[Lookup[linearData, "kiraOrdering", <||>], <|"ManualIntegralOrder" -> requested|>];
   manualOrderReport = <|
     "requestedIntegrals" -> integralOrder,
     "matchedIntegrals" -> requested,
     "missingIntegralOrderItems" -> DeleteDuplicates @ missingIntegralOrderItems[integralOrder, oldIntegrals],
     "allRequestedIntegralsMatchedQ" -> TrueQ[missingIntegralOrderItems[integralOrder, oldIntegrals] === {}]
     |>;
   Join[linearData, <|
     "integralList" -> newIntegrals,
     "integralRules" -> Normal[newIndex],
     "kiraOrdering" -> orderingSpec,
     "kiraOrderingReport" -> kiraOrderingMatchReport[orderingSpec, newIntegrals],
     "manualIntegralOrderReport" -> manualOrderReport,
     "integralSortKeys" -> (integralSortKey[#, orderingSpec, metadataList] & /@ newIntegrals),
     "integralMetadata" -> integralMetadataList[newIntegrals, metadataList, orderingSpec],
     "linearEquations" -> newLinearEquations
     |>]
   ];


linearizeSeedEquation[entry_Association, integralIndex_Association] := Module[
   {terms, termData, linearPieces, constantTerms, nonlinearTerms},
   terms = linearTerms[Lookup[entry, "equation", 0]];
   termData = linearTermData[#, integralIndex] & /@ terms;
   linearPieces = Select[termData, #["kind"] === "linear" &];
   constantTerms = Lookup[Select[termData, #["kind"] === "constant" &], "term", {}];
   nonlinearTerms = Lookup[Select[termData, #["kind"] === "nonlinear" &], "term", {}];
   Join[
    KeyDrop[entry, "equation"],
    <|
     "coefficientRules" -> combineLinearCoefficientRules[linearPieces],
     "constantTerm" -> Total[constantTerms],
     "nonlinearTerms" -> nonlinearTerms,
     "linearQ" -> TrueQ[nonlinearTerms === {}]
     |>
    ]
   ];


Options[makeLinearSystemData] = {KiraOrdering -> Automatic};


makeLinearSystemData[batch_Association, topoSpec_: Automatic, OptionsPattern[]] := Module[
   {topo, integrals, integralIndex, equations, linearEquations, coefficientDiagnostics,
    metadataList, metadata, orderingSpec, orderingReport, seedCoverageReport, topologyReport},
   topo = normalizeTopologySpec[topoSpec];
   topologyReport = Lookup[batch, "topologyValidationReport", Missing["NoTopologyValidationReport"]];
   If[MatchQ[topologyReport, _Missing] && parsedTopologyQ[topo],
    topologyReport = topologyValidationReport[topo]
    ];
   If[Lookup[batch, "status", "missing"] =!= "generated",
    Return[<|"status" -> "notGenerated", "sourceStatus" -> Lookup[batch, "status", Missing["status"]], "topologyValidationReport" -> topologyReport|>]
    ];
   If[topologyValidationErrorQ[topologyReport],
    Return[<|"status" -> "invalidTopology", "caseName" -> Lookup[batch, "caseName", Missing["caseName"]], "topologyValidationReport" -> topologyReport|>]
    ];
   If[Lookup[batch, "pendingFeatures", {}] =!= {},
    Return[<|
      "status" -> "notReady",
      "caseName" -> Lookup[batch, "caseName", Missing["caseName"]],
      "topologyValidationReport" -> topologyReport,
      "reason" -> "pendingFeatures",
      "pendingFeatures" -> Lookup[batch, "pendingFeatures", {}]
      |>]
    ];
   If[Lookup[batch, "forbiddenNData", {}] =!= {},
    Return[<|
      "status" -> "notReady",
      "caseName" -> Lookup[batch, "caseName", Missing["caseName"]],
      "topologyValidationReport" -> topologyReport,
      "reason" -> "forbiddenNData",
      "forbiddenNData" -> Lookup[batch, "forbiddenNData", {}]
      |>]
    ];
   If[! KeyExistsQ[batch, "completeCanonicalQ"],
    Return[<|
      "status" -> "notReady",
      "caseName" -> Lookup[batch, "caseName", Missing["caseName"]],
      "topologyValidationReport" -> topologyReport,
      "reason" -> "notCanonicalSeedBatch",
      "comment" -> "linear/Kira stages require makeCanonicalSeedBatch output with all-sector qIBP/tIBP coverage; momentum-only or time-only seed batches are seed-level regression data only"
      |>]
    ];
   seedCoverageReport = makeCanonicalSeedCoverageReport[batch];
   If[! TrueQ[Lookup[seedCoverageReport, "passQ", False]],
    Return[<|
      "status" -> "notReady",
      "caseName" -> Lookup[batch, "caseName", Missing["caseName"]],
      "topologyValidationReport" -> topologyReport,
      "reason" -> "seedCoverageReportNotReady",
      "seedCoverageReport" -> seedCoverageReport
      |>]
    ];
   orderingReport = validateKiraOrderingSpec[OptionValue[KiraOrdering]];
   If[Lookup[orderingReport, "status", "ok"] =!= "ok",
    Return[<|"status" -> "notReady", "caseName" -> Lookup[batch, "caseName", Missing["caseName"]], "topologyValidationReport" -> topologyReport, "reason" -> "invalidKiraOrdering", "kiraOrderingValidationReport" -> orderingReport|>]
    ];
   metadataList = batchSectorMetadataList[batch, topo];
   orderingSpec = resolveKiraOrderingSpec[batch, topo, OptionValue[KiraOrdering]];
   integrals = sortIntegralsForKira[integralObjectsInBatch[batch], orderingSpec, metadataList];
   integralIndex = makeIntegralIndex[integrals];
   equations = symmetry[Lookup[batch, "equations", {}], topo];
   If[equations === $Failed,
    Return[<|"status" -> "notReady", "caseName" -> Lookup[batch, "caseName", Missing["caseName"]], "topologyValidationReport" -> topologyReport, "reason" -> "invalidSymmetryRules"|>]
    ];
   linearEquations = linearizeSeedEquation[#, integralIndex] & /@ equations;
   coefficientDiagnostics = linearCoefficientDiagnostics[linearEquations];
   metadata = If[metadataList === {}, Missing["NoSectorMetadata"], First[metadataList]];
   <|
    "status" -> "generated",
    "caseName" -> Lookup[batch, "caseName", Missing["caseName"]],
    "topology" -> topo,
    "integralCount" -> Length[integrals],
    "equationCount" -> Length[equations],
    "integralList" -> integrals,
    "integralRules" -> Normal[integralIndex],
    "kiraOrdering" -> orderingSpec,
    "kiraOrderingReport" -> kiraOrderingMatchReport[orderingSpec, integrals],
    "integralSortKeys" -> (integralSortKey[#, orderingSpec, metadataList] & /@ integrals),
    "integralMetadata" -> integralMetadataList[integrals, metadataList, orderingSpec],
    "sectorMetadata" -> metadata,
    "sectorMetadataList" -> metadataList,
    "topologyValidationReport" -> topologyReport,
    "seedCoverageReport" -> seedCoverageReport,
    "tadpoleSymmetryData" -> tadpoleSymmetryData[topo],
    "effectiveSymmetryRules" -> effectiveSymmetryRules0[topo],
    "linearEquations" -> linearEquations,
    "linearQ" -> And @@ (Lookup[linearEquations, "linearQ"]),
    "nonlinearEquationCount" -> Count[Lookup[linearEquations, "linearQ"], False],
    "numericCoefficientSystemQ" -> coefficientDiagnostics["numericCoefficientSystemQ"],
    "coefficientVariables" -> coefficientDiagnostics["coefficientVariables"]
    |>
   ];


Options[applyCoefficientRulesToLinearSystem] = {CoefficientRules -> {}};


applyCoefficientRulesToLinearSystem[linearData_Association, OptionsPattern[]] := Module[
   {rawRules = OptionValue[CoefficientRules], rules, ruleReport, linearEquations, coefficientDiagnostics},
   If[Lookup[linearData, "status", "missing"] =!= "generated" || ! KeyExistsQ[linearData, "linearEquations"], Return[linearData]];
   ruleReport = validateCoefficientRules[rawRules];
   If[Lookup[ruleReport, "status", "ok"] =!= "ok",
    Return[Join[linearData, <|"status" -> "notReady", "reason" -> "invalidCoefficientRules", "coefficientRuleValidationReport" -> ruleReport|>]]
    ];
   rules = normalizeCoefficientRulesForLinearData[rawRules, linearData];
   linearEquations = applyKiraCoefficientRulesToLinearEquation[#, rules] & /@ linearData["linearEquations"];
   coefficientDiagnostics = linearCoefficientDiagnostics[linearEquations];
   Join[linearData, <|
     "coefficientRulesApplied" -> rules,
     "userCoefficientRulesApplied" -> userCoefficientRulesForLinearData[rules, linearData],
     "linearEquations" -> linearEquations,
     "linearQ" -> And @@ (Lookup[linearEquations, "linearQ"]),
     "nonlinearEquationCount" -> Count[Lookup[linearEquations, "linearQ"], False],
     "numericCoefficientSystemQ" -> coefficientDiagnostics["numericCoefficientSystemQ"],
     "coefficientVariables" -> coefficientDiagnostics["coefficientVariables"]
     |>]
   ];


Options[makeSampledLinearSystemData] = Join[Options[makeLinearSystemData], {CoefficientRules -> Automatic}];


makeSampledLinearSystemData[batch_Association, topoSpec_: Automatic, OptionsPattern[]] := Module[
   {topo, linearData, rules},
   topo = normalizeTopologySpec[topoSpec];
   linearData = makeLinearSystemData[batch, topo, KiraOrdering -> OptionValue[KiraOrdering]];
   If[Lookup[linearData, "status", "missing"] =!= "generated", Return[linearData]];
   rules = If[OptionValue[CoefficientRules] === Automatic,
     If[parsedTopologyQ[topo], Lookup[topo, "numericRules", {}], {}],
     OptionValue[CoefficientRules]
     ];
   applyCoefficientRulesToLinearSystem[linearData, CoefficientRules -> rules]
   ];

(* ::Chapter:: *)
(*010 公开原子 API 与表示转换*)

(* J 本身不携带 topology；公开短签名必须使用显式注册的 context，不能从指标形状猜测物理类型。 *)
If[! ValueQ[$dSIBPTopologyContext], $dSIBPTopologyContext = Missing["NotSet"]];


dSIBPPublicAPI::notopo =
   "公开 API 缺少 topology context。请使用显式 topo 参数，或先调用 setIBPTopologyContext[topo]。";
dSIBPPublicAPI::badtopo = "topology context 无效或解析失败：`1`。";
dSIBPPublicAPI::badshape = "表达式中的 J 与 topology context 不兼容：`1`。";
dSIBPPublicAPI::badstate = "IBP 公开算子要求所有 full-line 离散态已显式取 0/1：`1`。";
dSIBPPublicAPI::badgen = "找不到请求的 IBP 生成元：`1`。";
dSIBPPublicAPI::badvar = "变量 `1` 不在当前 topology 初始化的外部独立变量列表 `2` 中。";
dSIBPPublicAPI::ambiguousvar = "变量 `1` 属于过完备动力学坐标；在 family 定义中补充约束并重选独立变量前，ds 已禁用。";
dSIBPPublicAPI::noinverse = "当前动力学规则没有唯一的用户坐标到基础标量积反向映射；rep2innerform 已拒绝。审计：`1`。";
dSIBPPublicAPI::nonlinear = "ds 只接受 J 的线性组合；检测到非线性或非多项式 J 依赖：`1`。";
dSIBPPublicAPI::derivativefailed = "变量 `1` 的积分导数生成失败。";


setIBPTopologyContext[spec_Association] := Module[{topo = normalizeTopologySpec[spec]},
   If[! parsedTopologyQ[topo],
    Message[dSIBPPublicAPI::badtopo, spec];
    Return[$Failed]
    ];
   $dSIBPTopologyContext = topo
   ];


clearIBPTopologyContext[] := ($dSIBPTopologyContext = Missing["NotSet"]);


resolvePublicTopologyContext[spec_: Automatic] := Module[{topo},
   topo = If[spec === Automatic, $dSIBPTopologyContext, normalizeTopologySpec[spec]];
   If[! parsedTopologyQ[topo],
    If[spec === Automatic,
     Message[dSIBPPublicAPI::notopo],
     Message[dSIBPPublicAPI::badtopo, spec]
     ];
    Return[$Failed]
    ];
   topo
   ];


publicExpectedPackLength[packType_String] := Switch[packType,
   "massiveFull" | "massiveCross", 3,
   "masslessFull", 2,
   "masslessCross" | "shrunk", 1,
   _, Missing["UnknownPackType", packType]
   ];


publicIntegralShapeIssues[topo_Association, J[aList_, linePacks_, ispList_]] := Module[
   {issues = {}, expected, packType},
   If[Length[aList] =!= Length[activeAVertexIds[topo]],
    AppendTo[issues, <|"slot" -> "aList", "expected" -> Length[activeAVertexIds[topo]], "actual" -> Length[aList]|>]
    ];
   If[Length[linePacks] =!= topo["nE"],
    AppendTo[issues, <|"slot" -> "linePacks", "expected" -> topo["nE"], "actual" -> Length[linePacks]|>],
    Do[
     If[! ListQ[linePacks[[e]]],
      AppendTo[issues, <|"slot" -> "linePack", "lineIndex" -> e, "reason" -> "notList"|>],
      packType = actualLinePackType[topo, e, linePacks[[e]]];
      expected = publicExpectedPackLength[packType];
      If[Head[expected] === Missing || Length[linePacks[[e]]] =!= expected,
       AppendTo[issues, <|"slot" -> "linePack", "lineIndex" -> e, "packType" -> packType, "expected" -> expected, "actual" -> Length[linePacks[[e]]]|>]
       ]
      ],
     {e, Length[linePacks]}
     ]
    ];
   If[Length[ispList] =!= Length[topo["ispData"]],
    AppendTo[issues, <|"slot" -> "ispList", "expected" -> Length[topo["ispData"]], "actual" -> Length[ispList]|>]
    ];
   issues
   ];


publicResolvedDiscreteStateIssues[topo_Association, J[aList_, linePacks_, ispList_]] := Module[
   {issues = {}, packType, pack},
   If[Length[linePacks] =!= topo["nE"], Return[issues]];
   Do[
    pack = linePacks[[e]];
    If[ListQ[pack],
     packType = actualLinePackType[topo, e, pack];
     Switch[packType,
      "massiveFull" | "massiveCross",
      Do[If[! MemberQ[{0, 1}, pack[[p]]], AppendTo[issues, <|"lineIndex" -> e, "packType" -> packType, "packPosition" -> p, "value" -> pack[[p]]|>]], {p, 2, 3}],
      "masslessFull",
      If[! MemberQ[{0, 1}, pack[[2]]], AppendTo[issues, <|"lineIndex" -> e, "packType" -> packType, "packPosition" -> 2, "value" -> pack[[2]]|>]],
      _, Null
      ]
     ],
    {e, Length[linePacks]}
    ];
   issues
   ];


publicExpressionIntegrals[expr_] := DeleteDuplicates[Cases[expr, _J, {0, Infinity}]];


validatePublicExpression[expr_, topo_Association, requireDiscreteQ_: False] := Module[
   {integrals = publicExpressionIntegrals[expr], shapeIssues, stateIssues},
   shapeIssues = Flatten[publicIntegralShapeIssues[topo, #] & /@ integrals];
   If[shapeIssues =!= {}, Message[dSIBPPublicAPI::badshape, shapeIssues]; Return[False]];
   If[TrueQ[requireDiscreteQ],
    stateIssues = Flatten[publicResolvedDiscreteStateIssues[topo, #] & /@ integrals];
    If[stateIssues =!= {}, Message[dSIBPPublicAPI::badstate, stateIssues]; Return[False]]
    ];
   True
   ];


publicLoopIndex[topo_Association, item_] := Which[
   IntegerQ[item] && 1 <= item <= topo["nL"], item,
   MemberQ[topo["loopMomenta"], item], First@FirstPosition[topo["loopMomenta"], item],
   True, Missing["LoopMomentumNotFound", item]
   ];


publicExternalIndex[topo_Association, item_] := Which[
   IntegerQ[item] && 1 <= item <= topo["nK"], item,
   MemberQ[topo["externalMomenta"], item], First@FirstPosition[topo["externalMomenta"], item],
   True, Missing["ExternalMomentumNotFound", item]
   ];


publicApplyIBPGenerator[expr_, topo_Association, gen_Association] := Module[{result},
   If[! validatePublicExpression[expr, topo, True], Return[$Failed]];
   result = Expand[expr /. int_J :> If[
        gen["type"] === "time",
        applyTimeGeneratorSeed[topo, int, gen],
        applyMomentumGeneratorSeed[topo, int, gen]
        ]];
   If[! FreeQ[result, $Failed], Return[$Failed]];
   applySeedCanonical[result, topo]
   ];


dtau[vertex_, expr_, topoSpec_Association] := Module[{topo, gen},
   topo = resolvePublicTopologyContext[topoSpec];
   If[topo === $Failed, Return[$Failed]];
   gen = SelectFirst[makeIBPGenerators[topo], #1["type"] === "time" && #1["vertex"] === vertex &, Missing["NotFound"]];
   If[Head[gen] === Missing, Message[dSIBPPublicAPI::badgen, {"dtau", vertex}]; Return[$Failed]];
   publicApplyIBPGenerator[expr, topo, gen]
   ];
dtau[vertex_, expr_] := Module[{topo = resolvePublicTopologyContext[]},
   If[topo === $Failed, $Failed, dtau[vertex, expr, topo]]
   ];


dqq[dLoop_, vectorLoop_, expr_, topoSpec_Association] := Module[{topo, i, j, gen},
   topo = resolvePublicTopologyContext[topoSpec];
   If[topo === $Failed, Return[$Failed]];
   i = publicLoopIndex[topo, dLoop];
   j = publicLoopIndex[topo, vectorLoop];
   If[Head[i] === Missing || Head[j] === Missing, Message[dSIBPPublicAPI::badgen, {"dqq", dLoop, vectorLoop}]; Return[$Failed]];
   gen = <|"type" -> "momentum", "dLoop" -> i, "vectorType" -> "loop", "vectorIndex" -> j, "vector" -> topo["loopMomenta"][[j]]|>;
   publicApplyIBPGenerator[expr, topo, gen]
   ];
dqq[dLoop_, vectorLoop_, expr_] := Module[{topo = resolvePublicTopologyContext[]},
   If[topo === $Failed, $Failed, dqq[dLoop, vectorLoop, expr, topo]]
   ];


dqk[dLoop_, vectorExternal_, expr_, topoSpec_Association] := Module[{topo, i, j, gen},
   topo = resolvePublicTopologyContext[topoSpec];
   If[topo === $Failed, Return[$Failed]];
   i = publicLoopIndex[topo, dLoop];
   j = publicExternalIndex[topo, vectorExternal];
   If[Head[i] === Missing || Head[j] === Missing, Message[dSIBPPublicAPI::badgen, {"dqk", dLoop, vectorExternal}]; Return[$Failed]];
   gen = <|"type" -> "momentum", "dLoop" -> i, "vectorType" -> "external", "vectorIndex" -> j, "vector" -> topo["externalMomenta"][[j]]|>;
   publicApplyIBPGenerator[expr, topo, gen]
   ];
dqk[dLoop_, vectorExternal_, expr_] := Module[{topo = resolvePublicTopologyContext[]},
   If[topo === $Failed, $Failed, dqk[dLoop, vectorExternal, expr, topo]]
   ];


publicProtectJMap[expr_, function_] := Module[{integrals, tokens, forward, backward},
   integrals = publicExpressionIntegrals[expr];
   tokens = Table[Unique["heldJ$"], {Length[integrals]}];
   forward = Thread[integrals -> tokens];
   backward = Thread[tokens -> integrals];
   function[expr /. forward] /. backward
   ];


userISPToInternalRules[topo_Association] := MapIndexed[
   Rule[Lookup[#1, "name", rho[First[#2]]], rho[First[#2]]] &,
   topo["ispData"]
   ];


internalISPToUserRules[topo_Association] := MapIndexed[
   Rule[rho[First[#2]], Lookup[#1, "name", rho[First[#2]]]] &,
   topo["ispData"]
   ];


rep2innerform[expr_, topoSpec_Association] := Module[{topo, audit},
   topo = resolvePublicTopologyContext[topoSpec];
   If[topo === $Failed, Return[$Failed]];
   audit = Lookup[topo, "kinematicCoordinateAudit", <||>];
   If[AssociationQ[audit] && ! TrueQ[Lookup[audit, "inverseAvailableQ", True]],
    Message[dSIBPPublicAPI::noinverse, KeyTake[audit, {"status", "constraintResiduals", "parameterDependencies"}]];
    Return[$Failed]
    ];
   If[! validatePublicExpression[expr, topo], Return[$Failed]];
   publicProtectJMap[expr, Function[body,
     Expand[scalarProductInputToInternal[body, topo] /. userISPToInternalRules[topo]]
     ]]
   ];
rep2innerform[expr_] := Module[{topo = resolvePublicTopologyContext[]},
   If[topo === $Failed, $Failed, rep2innerform[expr, topo]]
   ];


rep2outform[expr_, topoSpec_Association] := Module[{topo},
   topo = resolvePublicTopologyContext[topoSpec];
   If[topo === $Failed, Return[$Failed]];
   If[! validatePublicExpression[expr, topo], Return[$Failed]];
   publicProtectJMap[expr, Function[body,
     Expand[scalarProductInternalToUser[body /. internalISPToUserRules[topo], topo]]
     ]]
   ];
rep2outform[expr_] := Module[{topo = resolvePublicTopologyContext[]},
   If[topo === $Failed, $Failed, rep2outform[expr, topo]]
   ];


(* ::Section:: *)
(*外部动力学变量总导数*)

(* ds 的变量必须使用 topology 初始化时的外部名称；内部 kk 坐标只在底层导数中出现。 *)
publicIndependentVariableDerivativeData[topo_Association] := makeIndependentVariableDerivativeGenerators[topo];


resolvePublicIndependentVariableDerivativeData[topo_Association, userVariable_] := SelectFirst[
   publicIndependentVariableDerivativeData[topo],
   SameQ[Lookup[#, "userVariable", Missing["userVariable"]], userVariable] &,
   Missing["UnknownIndependentVariable", userVariable]
   ];


(* 先把每个不同的 J 替成惰性 token；这样 D 只作用于显式系数，不会进入指标。 *)
publicLinearIntegralDecomposition[expr_] := Module[
   {expanded, integrals, tokens, forwardRules, backwardRules, heldExpression,
    constantTerm, coefficients, reconstructed},
   expanded = Expand[expr];
   integrals = publicExpressionIntegrals[expanded];
   tokens = Table[Unique["heldJ$"], {Length[integrals]}];
   forwardRules = Thread[integrals -> tokens];
   backwardRules = Thread[tokens -> integrals];
   heldExpression = Expand[expanded /. forwardRules];
   constantTerm = Expand[heldExpression /. Thread[tokens -> 0]];
   coefficients = Coefficient[heldExpression, #] & /@ tokens;
   reconstructed = Expand[constantTerm + Total[MapThread[#1 #2 &, {coefficients, tokens}]]];
   If[! TrueQ[Expand[heldExpression - reconstructed] === 0],
    Return[<|
      "status" -> "nonlinear",
      "heldExpression" -> heldExpression,
      "integrals" -> integrals
      |>]
    ];
   <|
    "status" -> "linear",
    "expression" -> expanded,
    "heldExpression" -> heldExpression,
    "integrals" -> integrals,
    "tokens" -> tokens,
    "coefficients" -> coefficients,
    "constantTerm" -> constantTerm,
    "backwardRules" -> backwardRules
    |>
   ];


(* 乘积法则：显式系数导数与每个 J 的指标导数分别生成，合并后再统一 canonical。 *)
ds[expr_, userVariable_, topoSpec_Association] := Module[
   {topo, variableData, userVariables, userExpr, linearData, internalVariable,
    coefficientDerivative, integralDerivativeTerms, result},
   topo = resolvePublicTopologyContext[topoSpec];
   If[topo === $Failed, Return[$Failed]];
   If[
    TrueQ[Lookup[Lookup[topo, "kinematicCoordinateAudit", <||>], "overcompleteQ", False]] &&
     MemberQ[Lookup[Lookup[topo, "kinematicCoordinateAudit", <||>], "selectedUserVariables", {}], userVariable],
    Message[dSIBPPublicAPI::ambiguousvar, userVariable];
    Return[$Failed]
    ];
   userVariables = Lookup[publicIndependentVariableDerivativeData[topo], "userVariable", {}];
   variableData = resolvePublicIndependentVariableDerivativeData[topo, userVariable];
   If[Head[variableData] === Missing,
    Message[dSIBPPublicAPI::badvar, userVariable, userVariables];
    Return[$Failed]
    ];
   userExpr = rep2outform[expr, topo];
   If[userExpr === $Failed || ! validatePublicExpression[userExpr, topo, True], Return[$Failed]];
   linearData = publicLinearIntegralDecomposition[userExpr];
   If[Lookup[linearData, "status", "failed"] =!= "linear",
    Message[dSIBPPublicAPI::nonlinear, Lookup[linearData, "heldExpression", userExpr]];
    Return[$Failed]
    ];
   internalVariable = variableData["variable"];
   coefficientDerivative = Expand[
     D[linearData["heldExpression"], userVariable] /. linearData["backwardRules"]
     ];
   integralDerivativeTerms = MapThread[
     Function[{coefficient, int},
      With[{term = applyIndependentVariableDerivativeSeed[topo, int, internalVariable]},
       If[term === $Failed, $Failed, coefficient term]
       ]
      ],
     {linearData["coefficients"], linearData["integrals"]}
     ];
   If[! FreeQ[integralDerivativeTerms, $Failed],
    Message[dSIBPPublicAPI::derivativefailed, userVariable];
    Return[$Failed]
    ];
   result = applySeedCanonical[
     Expand[coefficientDerivative + Total[integralDerivativeTerms]],
     topo
     ];
   If[result === $Failed, Return[$Failed]];
   rep2outform[result, topo]
   ];
ds[expr_, userVariable_] := Module[{topo = resolvePublicTopologyContext[]},
   If[topo === $Failed, $Failed, ds[expr, userVariable, topo]]
   ];


integrandVertexFactor[topo_Association, int_J] := Times @@ Table[
   With[{vertex = activeAVertexIds[topo][[slot]]},
    (-tau[vertex])^(int[[1, slot]] + vertexZeroPoint[topo, vertex])
     Exp[vertexExternalPhaseDerivativeCoefficient[topo, vertex] vertexExternalEnergy[topo, vertex] tau[vertex]]
    ],
   {slot, Length[activeAVertexIds[topo]]}
   ];


integrandBuildingBlock[line_Association, pack_List] := Module[
   {lineId = line["id"], endpoints = line["endpoints"], packType = line["packType"]},
   Switch[packType,
    "massiveFull" | "massiveCross",
    Hh[MassiveBlock[Lookup[line, "bbType", "h"], Lookup[line, "nu", nu], Lookup[line, "skType", "++"], lineId, endpoints, xi[lineId], pack[[2]], pack[[3]]]],
    "masslessFull",
    Hh[MasslessBlock[Lookup[line, "skType", "++"], lineId, endpoints, xi[lineId], pack[[2]]]],
    "masslessCross",
    Hh[MasslessCrossBlock[Lookup[line, "skType", "+-"], lineId, endpoints, xi[lineId]]],
    _, 1
    ]
   ];


integrandLineFactor[topo_Association, int_J, e_Integer] := Module[
   {line = topo["lines"][[e]], pack = int[[2, e]], packType, denominator},
   packType = actualLinePackType[topo, e, pack];
   denominator = xi[line["id"]]^(-linePowerIndex[topo, int, e]);
   If[packType === "shrunk", denominator, denominator integrandBuildingBlock[Join[line, <|"packType" -> packType|>], pack]]
   ];


integrandISPFactor[topo_Association, int_J] := Times @@ Table[
   Lookup[topo["ispData"][[j]], "name", rho[j]]^int[[3, j]],
   {j, Length[topo["ispData"]]}
   ];


integralToInertIntegrand[topo_Association, int_J] := Times[
   integrandVertexFactor[topo, int],
   Times @@ Table[integrandLineFactor[topo, int, e], {e, topo["nE"]}],
   integrandISPFactor[topo, int]
   ];


rep2Integrand[expr_, topoSpec_Association] := Module[{topo, result},
   topo = resolvePublicTopologyContext[topoSpec];
   If[topo === $Failed, Return[$Failed]];
   If[! validatePublicExpression[expr, topo], Return[$Failed]];
   result = Expand[expr /. int_J :> integralToInertIntegrand[topo, int]];
   rep2outform[result, topo]
   ];
rep2Integrand[expr_] := Module[{topo = resolvePublicTopologyContext[]},
   If[topo === $Failed, $Failed, rep2Integrand[expr, topo]]
   ];


(* ::Chapter:: *)
(*示例 case 与结构检查*)

(* 本章保留 bubble 作为输入样例，同时增加一个两圈 ISP toy case。
   检查目标不是物理公式正确性，而是验证替换输入拓扑后结构层仍能工作。 *)


bubbleMassiveCase = <|
   "name" -> "bubbleMassive",
   "vertexData" -> {{1, "+"}, {2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> q1, "nu" -> nu1, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 2, "endpoints" -> {1, 2}, "momentum" -> q1 - k, "nu" -> nu2, "bbType" -> "h", "massType" -> "massive"|>
     },
   "extLegs" -> {{B, 1, p1}, {B, 2, p2}},
   "loopMomenta" -> {q1},
   "externalMomenta" -> {k},
   "ispData" -> {},
   "symmetryRules" -> {}
   |>;


(* 用户只有在确认 nu1==nu2 且相关外腿参数相等后，才可把交换规则放入 case。
   示例只展示输入形状；package 不自动检测这些物理条件。
   "symmetryRules" -> {
     HoldPattern[J[{av1_, av2_}, {pack1_, pack2_}, isp_]] :>
       J[{av2, av1}, {pack2, pack1}, isp]
     }
*)


bubbleMasslessCase = <|
   "name" -> "bubbleMasslessMergedTheta",
   "vertexData" -> {{1, "+"}, {2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> q1, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>,
     <|"id" -> 2, "endpoints" -> {1, 2}, "momentum" -> q1 - k, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>
     },
   "extLegs" -> {{B, 1, p1}, {B, 2, p2}},
   "loopMomenta" -> {q1},
   "externalMomenta" -> {k},
   "ispData" -> {},
   "numericRules" -> {dim -> 3, kk[1, 1] -> 5},
   "sampleDiscreteRules" -> {
     {n[1] -> 0, n[2] -> 0},
     {n[1] -> 1, n[2] -> 0},
     {n[1] -> 0, n[2] -> 1}
     },
   "seedRanges" -> <|"a" -> {-1, 1}, "b" -> {-2, 2}, "sampleOnly" -> True|>
   |>;


masslessCrossBubbleCase = <|
   "name" -> "bubbleMasslessCrossNoTheta",
   "vertexData" -> {{1, "+"}, {2, "-"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> q1, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>,
     <|"id" -> 2, "endpoints" -> {1, 2}, "momentum" -> q1 - k, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>
     },
   "extLegs" -> {{B, 1, p1}, {B, 2, p2}},
   "loopMomenta" -> {q1},
   "externalMomenta" -> {k},
   "ispData" -> {},
   "numericRules" -> {dim -> 3, kk[1, 1] -> 5},
   "sampleDiscreteRules" -> {{}},
   "seedRanges" -> <|"a" -> {-1, 1}, "b" -> {-2, 2}, "sampleOnly" -> True|>
   |>;


mixedBubbleCase = <|
   "name" -> "mixedBubbleMassiveMassless",
   "vertexData" -> {{1, "+"}, {2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> q1, "nu" -> nuM, "bbType" -> "h", "massType" -> "massive", "skType" -> "++"|>,
     <|"id" -> 2, "endpoints" -> {1, 2}, "momentum" -> q1 - k, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless", "skType" -> "++"|>
     },
   "extLegs" -> {{B, 1, p1}, {B, 2, p2}},
   "loopMomenta" -> {q1},
   "externalMomenta" -> {k},
   "ispData" -> {},
   "numericRules" -> {dim -> 3, kk[1, 1] -> 5, nuM -> 2, p1 -> 7, p2 -> 11},
   "sampleDiscreteRules" -> {
     {n[1, 1] -> 0, n[1, 2] -> 0, n[2] -> 0},
     {n[1, 1] -> 1, n[1, 2] -> 0, n[2] -> 1}
     },
   "seedRanges" -> <|"a" -> {-1, 1}, "b" -> {-2, 2}, "sampleOnly" -> True|>
   |>;


massiveCrossBubbleCase = <|
   "name" -> "massiveCrossBubbleGate",
   "vertexData" -> {{1, "+"}, {2, "-"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> q1, "nu" -> nuM, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 2, "endpoints" -> {1, 2}, "momentum" -> q1 - k, "nu" -> nuM, "bbType" -> "h", "massType" -> "massive"|>
     },
   "extLegs" -> {{B, 1, p1}, {B, 2, p2}},
   "loopMomenta" -> {q1},
   "externalMomenta" -> {k},
   "ispData" -> {},
   "numericRules" -> {dim -> 3, kk[1, 1] -> 5, nuM -> 2},
   "sampleDiscreteRules" -> {
     {n[1, 1] -> 0, n[1, 2] -> 0, n[2, 1] -> 0, n[2, 2] -> 0},
     {n[1, 1] -> 1, n[1, 2] -> 0, n[2, 1] -> 0, n[2, 2] -> 1}
     },
   "seedRanges" -> <|"a" -> {-1, 1}, "b" -> {-2, 2}, "sampleOnly" -> True|>
   |>;


mixedTriangleCase = <|
   "name" -> "mixedTriangleTwoMassiveOneMassless",
   "vertexData" -> {{1, "+"}, {2, "+"}, {3, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> q1, "nu" -> nuM, "bbType" -> "h", "massType" -> "massive", "skType" -> "++"|>,
     <|"id" -> 2, "endpoints" -> {2, 3}, "momentum" -> q1 - k1, "nu" -> nuM, "bbType" -> "h", "massType" -> "massive", "skType" -> "++"|>,
     <|"id" -> 3, "endpoints" -> {3, 1}, "momentum" -> q1 + k2, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless", "skType" -> "++"|>
     },
   "extLegs" -> {{B, 1, p1}, {B, 2, p2}, {B, 3, p3}},
   "loopMomenta" -> {q1},
   "externalMomenta" -> {k1, k2},
   "ispData" -> {},
   "numericRules" -> {dim -> 3, kk[1, 1] -> 5, kk[1, 2] -> -1, kk[2, 2] -> 7, nuM -> 2},
   "sampleDiscreteRules" -> {
     {n[1, 1] -> 0, n[1, 2] -> 0, n[2, 1] -> 0, n[2, 2] -> 0, n[3] -> 0},
     {n[1, 1] -> 1, n[1, 2] -> 0, n[2, 1] -> 0, n[2, 2] -> 0, n[3] -> 1},
     {n[1, 1] -> 0, n[1, 2] -> 1, n[2, 1] -> 1, n[2, 2] -> 0, n[3] -> 0}
     },
   "seedRanges" -> <|"a" -> {-1, 1}, "b" -> {-2, 2}, "sampleOnly" -> True|>
   |>;


masslessBoxCase = <|
   "name" -> "masslessBoxTopologyReplacement",
   "vertexData" -> {{1, "+"}, {2, "+"}, {3, "+"}, {4, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> q1, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless", "skType" -> "++"|>,
     <|"id" -> 2, "endpoints" -> {2, 3}, "momentum" -> q1 - k1, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless", "skType" -> "++"|>,
     <|"id" -> 3, "endpoints" -> {3, 4}, "momentum" -> q1 - k1 - k2, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless", "skType" -> "++"|>,
     <|"id" -> 4, "endpoints" -> {4, 1}, "momentum" -> q1 + k3, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless", "skType" -> "++"|>
     },
   "extLegs" -> {{B, 1, p1}, {B, 2, p2}, {B, 3, p3}, {B, 4, p4}},
   "loopMomenta" -> {q1},
   "externalMomenta" -> {k1, k2, k3},
   "ispData" -> {},
   "numericRules" -> {dim -> 3, kk[1, 1] -> 5, kk[1, 2] -> -1, kk[1, 3] -> 2, kk[2, 2] -> 7, kk[2, 3] -> -3, kk[3, 3] -> 11, p1 -> 7, p2 -> 11, p3 -> 13, p4 -> 17},
   "sampleDiscreteRules" -> {
     {n[1] -> 0, n[2] -> 0, n[3] -> 0, n[4] -> 0},
     {n[1] -> 1, n[2] -> 0, n[3] -> 1, n[4] -> 0},
     {n[1] -> 0, n[2] -> 1, n[3] -> 0, n[4] -> 1}
     },
   "seedRanges" -> <|"a" -> {-1, 1}, "b" -> {-2, 2}, "sampleOnly" -> True|>
   |>;



mixedSunriseCase = <|
   "name" -> "sunriseOneMassiveTwoMasslessPerLineMergedTheta",
   "vertexData" -> {{1, "+"}, {2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> q1, "nu" -> nuM, "bbType" -> "h", "massType" -> "massive", "skType" -> "++"|>,
     <|"id" -> 2, "endpoints" -> {1, 2}, "momentum" -> q2, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless", "skType" -> "++"|>,
     <|"id" -> 3, "endpoints" -> {1, 2}, "momentum" -> q1 - q2 - k, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless", "skType" -> "++"|>
     },
   "extLegs" -> {{B, 1, p1}, {B, 2, p2}},
   "loopMomenta" -> {q1, q2},
   "externalMomenta" -> {k},
   "ispData" -> {
     {ispQ1K, sp[q1, k], {0, 1}},
     {ispQ2K, sp[q2, k], {0, 1}}
     },
   "numericRules" -> {dim -> 3, kk[1, 1] -> 5, nuM -> 2},
   "sampleDiscreteRules" -> {
     {n[1, 1] -> 0, n[1, 2] -> 0, n[2] -> 0, n[3] -> 0},
     {n[1, 1] -> 1, n[1, 2] -> 0, n[2] -> 1, n[3] -> 0},
     {n[1, 1] -> 0, n[1, 2] -> 1, n[2] -> 0, n[3] -> 1}
     },
   "seedRanges" -> <|"a" -> {-1, 1}, "b" -> {-2, 2}, "isp" -> {0, 1}, "sampleOnly" -> True|>,
   "masslessBundleMode" -> "perLinePacksCommonThetaContacts"
   |>;

twoLoopISPCase = <|
   "name" -> "twoLoopISPtoy",
   "vertexData" -> {{1, "+"}, {2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> q1, "nu" -> nu1, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 2, "endpoints" -> {1, 2}, "momentum" -> q2, "nu" -> nu2, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 3, "endpoints" -> {1, 2}, "momentum" -> q1 - q2, "nu" -> nu3, "bbType" -> "h", "massType" -> "massive"|>
     },
   "extLegs" -> {{B, 1, p1}, {B, 2, p2}},
   "loopMomenta" -> {q1, q2},
   "externalMomenta" -> {k},
   "ispData" -> {
     {ispQ1K, qk[1, 1], {0, 2}},
     {ispQ2K, qk[2, 1], {0, 2}}
     }
   |>;


summarizeCase[case_Association] := Module[
   {topo, baseIntegral, sampleIntegrals, spData, gens, momentumGenCount,
    discreteCount, seedTemplateCount},
   topo = parseTopology[case];
   baseIntegral = makeBaseIntegral[topo];
   discreteCount = discreteStateCount[topo];
   sampleIntegrals = sampleDiscreteIntegrals[baseIntegral, topo];
   spData = makeScalarProductData[topo];
   gens = makeIBPGenerators[topo];
   momentumGenCount = Count[Lookup[gens, "type"], "momentum"];
   seedTemplateCount = Length[gens];
   <|
    "name" -> topo["name"],
    "nV" -> topo["nV"],
    "nE" -> topo["nE"],
    "nL" -> topo["nL"],
    "nK" -> topo["nK"],
    "packTypes" -> Lookup[topo["lines"], "packType"],
    "linePacks" -> makeLinePacks[topo],
    "baseIntegral" -> baseIntegral,
    "discreteStateCount" -> discreteCount,
    "sampleDiscreteRules" -> topo["sampleDiscreteRules"],
    "sampleIntegrals" -> sampleIntegrals,
    "seedTemplateCount" -> seedTemplateCount,
    "maxExpandedSeedCount" -> discreteCount seedTemplateCount,
    "generatorCount" -> Length[gens],
    "generatorList" -> gens,
    "momentumGeneratorCount" -> momentumGenCount,
    "expectedMomentumGeneratorCount" -> expectedMomentumGeneratorCount[topo],
    "scalarProducts" -> spData["scalarProducts"],
    "zExprs" -> spData["zExprs"],
    "numericRules" -> userNumericRules[topo],
    "externalInvariantNamingReport" -> externalInvariantNamingReport[topo],
    "vertexEnergyNamingReport" -> vertexEnergyNamingReport[topo],
    "numericZExprs" -> (spData["internalZExprs"] /. topo["numericRules"]),
    "seedRanges" -> topo["seedRanges"],
    "validationReport" -> topologyValidationReport[topo],
    "masslessBundleCandidates" -> masslessBundleCandidates[topo],
    "masslessEndpointConventions" -> masslessEndpointConventionData[topo],
    "structuralNeededISPCount" -> spData["structuralNeededISPCount"],
    "ispCoverageQ" -> spData["coverageQ"],
    "ispIndependentQ" -> spData["independentQ"],
    "ispCountQ" -> spData["structuralCountQ"],
    "repSP2Z" -> spData["repSP2Z"]
    |>
   ];


runStructureExamples[] := Module[
   {caseSummaries, summaryValue, structureChecks, summaryFile},
   caseSummaries = summarizeCase /@ {
      bubbleMassiveCase,
      bubbleMasslessCase,
      masslessCrossBubbleCase,
      mixedBubbleCase,
      massiveCrossBubbleCase,
      mixedTriangleCase,
      masslessBoxCase,
      mixedSunriseCase,
      twoLoopISPCase
      };
   summaryValue[index_, key_] := Lookup[Part[caseSummaries, index], key];
   structureChecks = <|
     "bubbleMassiveDiscreteStateCount" -> (summaryValue[1, "discreteStateCount"] === 16),
     "bubbleMasslessDiscreteStateCount" -> (summaryValue[2, "discreteStateCount"] === 4),
     "masslessCrossPackTypes" -> (summaryValue[3, "packTypes"] === {"masslessCross", "masslessCross"}),
     "masslessCrossDiscreteStateCount" -> (summaryValue[3, "discreteStateCount"] === 1),
     "mixedBubbleDiscreteStateCount" -> (summaryValue[4, "discreteStateCount"] === 8),
     "mixedBubbleMomentumGeneratorCount" -> (summaryValue[4, "momentumGeneratorCount"] === 2),
     "massiveCrossPackTypes" -> (summaryValue[5, "packTypes"] === {"massiveCross", "massiveCross"}),
     "massiveCrossDiscreteStateCount" -> (summaryValue[5, "discreteStateCount"] === 16),
     "mixedTriangleDiscreteStateCount" -> (summaryValue[6, "discreteStateCount"] === 32),
     "mixedTriangleMomentumGeneratorCount" -> (summaryValue[6, "momentumGeneratorCount"] === 3),
     "masslessBoxDiscreteStateCount" -> (summaryValue[7, "discreteStateCount"] === 16),
     "masslessBoxMomentumGeneratorCount" -> (summaryValue[7, "momentumGeneratorCount"] === 4),
     "masslessBoxValidationOK" -> (summaryValue[7, "validationReport"]["status"] === "ok"),
     "mixedSunriseDiscreteStateCount" -> (summaryValue[8, "discreteStateCount"] === 16),
     "mixedSunriseMomentumGeneratorCount" -> (summaryValue[8, "momentumGeneratorCount"] === 6),
     "mixedSunriseISPCount" -> TrueQ[summaryValue[8, "ispCountQ"]],
     "twoLoopMomentumGeneratorCount" -> (summaryValue[9, "momentumGeneratorCount"] === 6),
     "twoLoopISPCount" -> TrueQ[summaryValue[9, "ispCountQ"]]
     |>;
   summaryFile = FileNameJoin[{baseDir, "004_general_structure_summary.m"}];
   Put[caseSummaries, summaryFile];
   <|"summaries" -> caseSummaries, "checks" -> structureChecks, "summaryFile" -> summaryFile|>
   ];


(* 默认加载只定义函数和示例输入；需要检查时显式调用 runStructureExamples[]。 *)


(* ::Chapter:: *)
(*013 Tree 积分表示与 family metadata*)

(* 本章只处理单槽 J[vertexPacks]。tree 与 loop 共用 Head，但任何入口都先按 arity 分派；
   tree family 的 massiveLegs 顺序同时固定 binary master 顺序和矩阵 tensor 顺序。 *)

integralKind[J[_List, _List, _List]] := "Loop";
integralKind[J[packs_List]] := If[VectorQ[packs, ListQ], "Tree", $Failed];
integralKind[_] := $Failed;


makeTreeFamilyData::badinput = "tree family 输入无效：`1`。";
treeIntegralShape::badshape = "tree J 的 pack 形状与 family 不一致：`1`。";


treeSignedEnergy[vertex_Association] := Lookup[
   vertex,
   "signedEnergy",
   (* package 的 + 顶点相位为 Exp[-I E tau]，故论文 e^(I k0 tau) 中 k0=-E。 *)
   If[Lookup[vertex, "sign", "+"] === "+", -Lookup[vertex, "energy", 0], Lookup[vertex, "energy", 0]]
   ];


treeVertexIssues[vertex_Association] := Module[{issues = {}, legs, required, missing},
   required = {"id", "nu0", "energy", "massiveLegs"};
   missing = Complement[required, Keys[vertex]];
   If[missing =!= {}, AppendTo[issues, <|"code" -> "missingVertexKeys", "keys" -> missing|>]];
   If[! MemberQ[{"+", "-"}, Lookup[vertex, "sign", "+"]],
    AppendTo[issues, <|"code" -> "badVertexSign", "value" -> Lookup[vertex, "sign", Missing["sign"]]|>]
    ];
   legs = Lookup[vertex, "massiveLegs", {}];
   If[! ListQ[legs] || ! And @@ (AssociationQ /@ legs),
    AppendTo[issues, <|"code" -> "badMassiveLegs"|>],
    Do[
     missing = Complement[{"id", "nu", "energy"}, Keys[legs[[i]]]];
     If[missing =!= {}, AppendTo[issues, <|"code" -> "missingLegKeys", "leg" -> i, "keys" -> missing|>]],
     {i, Length[legs]}
     ]
    ];
   issues
   ];


makeTreeFamilyData[spec_Association] := Module[{vertices, issues, ids, normalized},
   vertices = Lookup[spec, "vertices", Missing["vertices"]];
   If[! ListQ[vertices] || ! And @@ (AssociationQ /@ vertices),
    Message[makeTreeFamilyData::badinput, {<|"code" -> "badVertices"|>}];
    Return[$Failed]
    ];
   issues = Flatten[treeVertexIssues /@ vertices];
   ids = Lookup[vertices, "id", Missing["id"]];
   If[DuplicateFreeQ[ids] =!= True, AppendTo[issues, <|"code" -> "duplicateVertexIds", "ids" -> ids|>]];
   If[issues =!= {}, Message[makeTreeFamilyData::badinput, issues]; Return[$Failed]];
   normalized = Map[
     Join[#, <|
         "signedEnergy" -> treeSignedEnergy[#],
         "p" -> Length[#"massiveLegs"]
         |>] &,
     vertices
     ];
   <|
    "status" -> "ready",
    "name" -> Lookup[spec, "name", "treeFamily"],
    "vertices" -> normalized,
    "vertexOrder" -> Lookup[normalized, "id"],
    "packLengths" -> (1 + Lookup[normalized, "p"]),
    "sector" -> Lookup[spec, "sector", "top"],
    "sourceStructure" -> Lookup[spec, "sourceStructure", {}],
    "topology" -> Lookup[spec, "topology", Missing["NoLoopTopology"]],
    "requiresSourceRules" -> TrueQ[Lookup[spec, "requiresSourceRules", False]],
    "loopBaselinePowers" -> Lookup[spec, "loopBaselinePowers", <||>]
    |>
   ];


treeIntegralShapeIssues[int_J, data_Association] := Module[{packs, expected, issues = {}},
   If[integralKind[int] =!= "Tree", Return[{<|"code" -> "notTreeIntegral", "integral" -> int|>}]];
   packs = First[int];
   expected = data["packLengths"];
   If[Length[packs] =!= Length[expected],
    Return[{<|"code" -> "vertexCount", "expected" -> Length[expected], "actual" -> Length[packs]|>}]
    ];
   Do[
    If[! ListQ[packs[[i]]] || Length[packs[[i]]] =!= expected[[i]],
     AppendTo[issues, <|"code" -> "packLength", "vertex" -> data["vertexOrder"][[i]], "expected" -> expected[[i]], "actual" -> If[ListQ[packs[[i]]], Length[packs[[i]]], Missing["NotList"]]|>]
     ],
    {i, Length[packs]}
    ];
   issues
   ];


treeIntegralQ[int_J, data_Association] := treeIntegralShapeIssues[int, data] === {};


treeBinaryStates[p_Integer?NonNegative] := IntegerDigits[#, 2, p] & /@ Range[0, 2^p - 1];


treeVertexMasterPacks[vertex_Association, aValue_: 0] := Prepend[#, aValue] & /@ treeBinaryStates[vertex["p"]];


treeMasterList[data_Association, aValues_: Automatic] := Module[{values, perVertex},
   values = If[aValues === Automatic, ConstantArray[0, Length[data["vertices"]]], aValues];
   If[! ListQ[values] || Length[values] =!= Length[data["vertices"]], Return[$Failed]];
   perVertex = MapThread[treeVertexMasterPacks, {data["vertices"], values}];
   J[#] & /@ Tuples[perVertex]
   ];


(* ::Chapter:: *)
(*Tree 通用迭代矩阵*)

(* 这里直接实现 2401.00129 Eq. (3.37)、(3.47)、(3.50)。M1 与 M0tilde 的逆
   只由对角元构造；数值零对角元返回 $Failed，符号分母则作为 singularLoci 显式记录。 *)

treePauli[0] = {{1, 0}, {0, 1}};
treePauli[1] = {{0, 1}, {1, 0}};
treePauli[2] = {{0, -I}, {I, 0}};
treePauli[3] = {{1, 0}, {0, -1}};
treeBasisTransform = 1/Sqrt[2] {{1, -I}, {-I, 1}};
treeBasisTransformInverse = 1/Sqrt[2] {{1, I}, {I, 1}};


treeTensorProduct[mats_List] := Which[
   mats === {}, {{1}},
   Length[mats] === 1, First[mats],
   True, KroneckerProduct @@ mats
   ];


treePauliLift[p_Integer?Positive, slot_Integer, component_Integer] := treeTensorProduct[
   Table[If[i === slot, treePauli[component], treePauli[0]], {i, p}]
   ];


treeM1[vertex_Association, effectiveNu0_] := Module[{p, nus, identity},
   p = vertex["p"];
   nus = Lookup[vertex["massiveLegs"], "nu"];
   identity = IdentityMatrix[2^p];
   If[p === 0,
    effectiveNu0 identity,
    Sum[(nus[[i]] + 1/2) treePauliLift[p, i, 3], {i, p}] +
     (effectiveNu0 - p/2 - Total[nus]) identity
    ]
   ];


treeM0[vertex_Association] := Module[{p, energies, identity},
   p = vertex["p"];
   energies = Lookup[vertex["massiveLegs"], "energy"];
   identity = IdentityMatrix[2^p];
   If[p === 0,
    I vertex["signedEnergy"] identity,
    -I Sum[energies[[i]] treePauliLift[p, i, 2], {i, p}] + I vertex["signedEnergy"] identity
    ]
   ];


treeM0Tilde[vertex_Association] := Module[{p, energies, identity},
   p = vertex["p"];
   energies = Lookup[vertex["massiveLegs"], "energy"];
   identity = IdentityMatrix[2^p];
   If[p === 0,
    I vertex["signedEnergy"] identity,
    -I Sum[energies[[i]] treePauliLift[p, i, 3], {i, p}] + I vertex["signedEnergy"] identity
    ]
   ];


treeTp[vertex_Association] := treeTensorProduct[ConstantArray[treeBasisTransform, vertex["p"]]];
treeTpInverse[vertex_Association] := treeTensorProduct[ConstantArray[treeBasisTransformInverse, vertex["p"]]];


treeDiagonalInverse::singular = "tree recurrence 位于奇异面：`1`。";


treeDiagonalInverse[matrix_List] := Module[{diag, offDiagonal},
   diag = Diagonal[matrix];
   offDiagonal = matrix - DiagonalMatrix[diag];
   If[! TrueQ[offDiagonal === ConstantArray[0, Dimensions[matrix]]], Return[$Failed]];
   If[AnyTrue[diag, TrueQ[# === 0] &], Message[treeDiagonalInverse::singular, Select[diag, TrueQ[# === 0] &]]; Return[$Failed]];
   DiagonalMatrix[1/diag]
   ];


treeAminusMatrix[vertex_Association, shift_: 0] := Module[{m1, inv},
   m1 = treeM1[vertex, vertex["nu0"] + shift];
   inv = treeDiagonalInverse[m1];
   If[inv === $Failed, $Failed, -inv . treeM0[vertex]]
   ];


treeAplusMatrix[vertex_Association, shift_: 0] := Module[{m0t, inv},
   m0t = treeM0Tilde[vertex];
   inv = treeDiagonalInverse[m0t];
   If[inv === $Failed, $Failed,
    -treeTpInverse[vertex] . inv . treeTp[vertex] . treeM1[vertex, vertex["nu0"] + shift + 1]
    ]
   ];


makeTreeRecurrenceData[data_Association] := Module[{vertices, records},
   vertices = data["vertices"];
   records = Map[
     Function[vertex,
      <|
       "vertex" -> vertex["id"],
       "states" -> treeBinaryStates[vertex["p"]],
       "M1" -> treeM1[vertex, vertex["nu0"]],
       "M0" -> treeM0[vertex],
       "M0Tilde" -> treeM0Tilde[vertex],
       "Aminus" -> treeAminusMatrix[vertex, 0],
       "Aplus" -> treeAplusMatrix[vertex, 0],
       "singularLoci" -> Join[
         Thread[Diagonal[treeM1[vertex, vertex["nu0"]]] != 0],
         Thread[Diagonal[treeM0Tilde[vertex]] != 0]
         ]
       |>
      ],
     vertices
     ];
   <|"status" -> If[FreeQ[records, $Failed], "ready", "singular"], "vertices" -> records|>
   ];


treeStateIndex[bits_List] := FromDigits[bits, 2] + 1;


treeLoopIntegralFromTree::unsupported = "tree 到 loop seed 的反投影尚不支持该 line pack：`1`。";


treeLoopIntegralFromTree[int_J, data_Association] := Module[
   {topo = Lookup[data, "topology", Missing["NoLoopTopology"]], packs, aList, linePacks, baseline, line, states, vertexIndex, legIndex},
   If[Head[topo] === Missing || ! treeIntegralQ[int, data], Return[$Failed]];
   packs = First[int];
   aList = packs[[All, 1]];
   baseline = Lookup[data, "loopBaselinePowers", <||>];
   linePacks = Table[
     line = topo["lines"][[e]];
     Switch[line["packType"],
      "massiveFull" | "massiveCross",
      states = Table[
        vertexIndex = FirstPosition[data["vertexOrder"], line["endpoints"][[slot]], Missing["NoVertex"]];
        If[Head[vertexIndex] === Missing, Return[$Failed]];
        vertexIndex = First[vertexIndex];
        legIndex = FirstPosition[Lookup[data["vertices"][[vertexIndex, "massiveLegs"]], "id"], {line["id"], slot}, Missing["NoLeg"]];
        If[Head[legIndex] === Missing, Return[$Failed]];
        packs[[vertexIndex, 1 + First[legIndex]]],
        {slot, 2}
        ];
      Prepend[states, Lookup[baseline, line["id"], 0]],
      "shrunk",
      {Lookup[baseline, line["id"], 0]},
      _,
      Message[treeLoopIntegralFromTree::unsupported, <|"line" -> line["id"], "packType" -> line["packType"]|>];
      Return[$Failed]
      ],
     {e, topo["nE"]}
     ];
   J[aList, linePacks, ConstantArray[0, Length[topo["ispData"]]]]
   ];


treeSourceAwareStepFromTopology[int_J, vertexIndex_Integer, endpoint_Integer, data_Association] := Module[
   {packs = First[int], current, seedA, states, vertexId, localIntegrals, loopIntegrals, records, ruleData, rules, result},
   current = packs[[vertexIndex, 1]];
   If[current === endpoint, Return[int]];
   seedA = If[current < endpoint, current + 1, current];
   states = treeBinaryStates[data["vertices"][[vertexIndex, "p"]]];
   vertexId = data["vertexOrder"][[vertexIndex]];
   localIntegrals = J[ReplacePart[packs, vertexIndex -> Prepend[#, seedA]]] & /@ states;
   loopIntegrals = treeLoopIntegralFromTree[#, data] & /@ localIntegrals;
   If[! FreeQ[loopIntegrals, $Failed], Return[$Failed]];
   records = Map[DSTreeSeeds[vertexId, #, data["topology"]] &, loopIntegrals];
   If[! FreeQ[records, $Failed], Return[$Failed]];
   ruleData = makeTreeTimeReductionRules[records, data];
   rules = Lookup[ruleData, If[current < endpoint, "minus", "plus"], {}];
   result = Replace[int, rules];
   If[result === int,
    Message[makeTreeFamilyData::badinput, {<|"code" -> "missingSourceAwareStep", "integral" -> int, "vertex" -> vertexId|>}];
    $Failed,
    result
    ]
   ];


treeSingleStepIntegral[int_J, vertexIndex_Integer, endpoint_Integer, data_Association] := Module[
   {packs, pack, current, bits, vertex, matrix, nextA, states, row, newPacks, directRules, directResult},
   If[! treeIntegralQ[int, data], Return[$Failed]];
   packs = First[int];
   pack = packs[[vertexIndex]];
   current = First[pack];
   bits = Rest[pack];
   vertex = data["vertices"][[vertexIndex]];
   If[TrueQ[Lookup[data, "requiresSourceRules", False]] && AssociationQ[Lookup[data, "topology", Missing["NoLoopTopology"]]],
    Return[treeSourceAwareStepFromTopology[int, vertexIndex, endpoint, data]]
    ];
   directRules = Lookup[Lookup[data, "timeReductionRules", <||>], If[current < endpoint, "minus", "plus"], {}];
   directResult = Replace[int, directRules];
   If[directResult =!= int, Return[directResult]];
   If[TrueQ[Lookup[data, "requiresSourceRules", False]],
    Message[makeTreeFamilyData::badinput, {<|"code" -> "missingSourceAwareStep", "integral" -> int, "vertex" -> vertex["id"]|>}];
    Return[$Failed]
    ];
   Which[
    current < endpoint,
    matrix = treeAminusMatrix[vertex, current + 1];
    nextA = current + 1,
    current > endpoint,
    matrix = treeAplusMatrix[vertex, current - 1];
    nextA = current - 1,
    True,
    Return[int]
    ];
   If[matrix === $Failed, Return[$Failed]];
   states = treeBinaryStates[vertex["p"]];
   row = treeStateIndex[bits];
   Total[MapIndexed[
     Function[{state, index},
      newPacks = ReplacePart[packs, vertexIndex -> Prepend[state, nextA]];
      matrix[[row, First[index]]] J[newPacks]
      ],
     states
     ]]
   ];


treeEndpointData::badend = "tree 迭代终点无效：`1`。";


normalizeTreeEndpoints[end_, data_Association] := Module[{result},
   result = If[end === Automatic, ConstantArray[0, Length[data["vertices"]]], end];
   If[! ListQ[result] || Length[result] =!= Length[data["vertices"]] || ! And @@ (IntegerQ /@ result),
    Message[treeEndpointData::badend, end];
    Return[$Failed]
    ];
   result
   ];


treeReducibleIntegrals[expr_, endpoints_List, data_Association] := Select[
   DeleteDuplicates[Cases[expr, int_J /; treeIntegralQ[int, data], {0, Infinity}]],
   Or @@ MapThread[Unequal, {First[#][[All, 1]], endpoints}] &
   ];


repIterativeData::badindex = "tree a 指标必须是可判定整数：`1`。";
repIterativeData::maxsteps = "tree 迭代超过最大步数 `1`。";
repIterativeData::nosector = "tree 积分无法唯一匹配 sector family：`1`。";


Options[repIterativeData] = {MaxIterations -> Automatic};


repIterativeData[expr_, end_: Automatic, data_Association, OptionsPattern[]] := Module[
   {endpoints, result = Expand[expr], integrals, allA, maxSteps, steps = 0, firstInt, packs, vertexIndex},
   endpoints = normalizeTreeEndpoints[end, data];
   If[endpoints === $Failed, Return[<|"status" -> "error", "result" -> $Failed, "steps" -> 0|>]];
   integrals = Select[DeleteDuplicates[Cases[result, int_J /; treeIntegralQ[int, data], {0, Infinity}]], True &];
   allA = Flatten[First[#][[All, 1]] & /@ integrals];
   If[! And @@ (IntegerQ /@ allA), Message[repIterativeData::badindex, Select[allA, ! IntegerQ[#] &]]; Return[<|"status" -> "error", "result" -> $Failed, "steps" -> 0|>]];
   maxSteps = OptionValue[MaxIterations];
   If[maxSteps === Automatic,
    maxSteps = If[integrals === {}, 0, Max[Total[Abs[First[#][[All, 1]] - endpoints]] & /@ integrals]]
    ];
   While[(integrals = treeReducibleIntegrals[result, endpoints, data]) =!= {},
    If[steps >= maxSteps, Message[repIterativeData::maxsteps, maxSteps]; Return[<|"status" -> "maxSteps", "result" -> $Failed, "steps" -> steps|>]];
    firstInt = First[integrals];
    packs = First[firstInt];
    vertexIndex = SelectFirst[Range[Length[endpoints]], packs[[#, 1]] =!= endpoints[[#]] &];
    result = Expand[result /. int_J /; treeIntegralQ[int, data] && First[int][[vertexIndex, 1]] === packs[[vertexIndex, 1]] :>
        treeSingleStepIntegral[int, vertexIndex, endpoints[[vertexIndex]], data]];
    If[! FreeQ[result, $Failed], Return[<|"status" -> "singular", "result" -> $Failed, "steps" -> steps|>]];
    steps++;
    ];
   <|"status" -> "reduced", "result" -> result, "steps" -> steps, "endpoints" -> endpoints|>
   ];


$dSIBPTreeFamilyContext = None;
repIterative0 = {};


treeFirstStepToZero[int_J, data_Association] := Module[{packs, vertexIndex},
   If[! treeIntegralQ[int, data], Return[int]];
   packs = First[int];
   If[! And @@ (IntegerQ /@ packs[[All, 1]]), Return[$Failed]];
   vertexIndex = SelectFirst[Range[Length[packs]], packs[[#, 1]] =!= 0 &, Missing["AtEndpoint"]];
   If[Head[vertexIndex] === Missing, int, treeSingleStepIntegral[int, vertexIndex, 0, data]]
   ];


makeRepIterative0[data_Association] /; KeyExistsQ[data, "vertices"] && ! KeyExistsQ[data, "families"] := With[{family = data}, {
    HoldPattern[int_J] /; treeIntegralQ[int, family] && And @@ (IntegerQ /@ First[int][[All, 1]]) && AnyTrue[First[int][[All, 1]], # != 0 &] :>
     treeFirstStepToZero[int, family]
    }];


setTreeFamilyContext[data_Association] := Module[{},
   $dSIBPTreeFamilyContext = data;
   repIterative0 = makeRepIterative0[data];
   data
   ];


Options[repIterative] = Options[repIterativeData];


repIterative[expr_, end_: Automatic, OptionsPattern[]] := If[
   AssociationQ[$dSIBPTreeFamilyContext],
   If[KeyExistsQ[$dSIBPTreeFamilyContext, "families"],
    repIterativeSectorData[expr, end, $dSIBPTreeFamilyContext, MaxIterations -> OptionValue[MaxIterations]]["result"],
    repIterativeData[expr, end, $dSIBPTreeFamilyContext, MaxIterations -> OptionValue[MaxIterations]]["result"]
    ],
   Message[makeTreeFamilyData::badinput, {<|"code" -> "treeContextNotSet"|>}];
   $Failed
   ];


repIterative[expr_, end_, data_Association, OptionsPattern[]] /;
   KeyExistsQ[data, "vertices"] && ! KeyExistsQ[data, "families"] := Module[{activeData},
   (* 显式 family 调用同时刷新公开原始规则，保证随后可直接使用 repIterative0。 *)
   activeData = setTreeFamilyContext[data];
   repIterativeData[
     expr, end, activeData, MaxIterations -> OptionValue[MaxIterations]
     ]["result"]
   ];


(* ::Chapter:: *)
(*Loop time-IBP 到 tree 的显式投影*)

(* 投影器从每个 loop J 的 shrunk pack 重建目标 sector，再按原始 line/endpoint 顺序打包 n。
   所有 theta、WT、zero-point 与 coincident canonical 已在 dtau 中完成；这里不重写传播子边界公式。 *)

loopToTreeProjection::badloop = "loop-to-tree 投影只接受合法三槽 loop J：`1`。";
loopToTreeProjection::mixedcontact = "mixed-sign line 不得产生 theta/contact shrink：`1`。";


loopIntegralShrunkLines[int : J[_, linePacks_List, _], topo_Association] := Select[
   Range[Min[Length[linePacks], topo["nE"]]],
   Length[linePacks[[#]]] === 1 && ! MemberQ[{"masslessCross", "massiveCross"}, topo["lines"][[#, "packType"]]] &
   ];


loopTreeTargetTopology[int : J[_, linePacks_List, _], topo_Association] := Module[{shrunk, badMixed},
   shrunk = loopIntegralShrunkLines[int, topo];
   badMixed = Select[shrunk, MemberQ[{"+-", "-+"}, Lookup[topo["lines"][[#]], "skType", "++"]] &];
   If[badMixed =!= {}, Message[loopToTreeProjection::mixedcontact, badMixed]; Return[$Failed]];
   If[shrunk === {}, topo, shrinkSectorTopology[topo, shrunk]]
   ];


(* loop 的 a0 留在 tree family 的 nu0 中；b0/bS0 没有 tree 指标槽，必须随完整物理幂次进入显式能量系数。 *)
loopTreeProjectionCoefficient[int : J[aList_List, _, _], targetTopo_Association] := Module[
   {active = activeAVertexIds[targetTopo], timePower, energyPower},
   timePower = Total[aList] + Total[vertexZeroPoint[targetTopo, #] & /@ active];
   energyPower = Times @@ Table[
      Lookup[targetTopo["lines"][[e]], "treeEnergy", xi[targetTopo["lines"][[e, "id"]]]]^(-linePowerIndex[targetTopo, int, e]),
      {e, targetTopo["nE"]}
      ];
   (-1)^timePower energyPower
   ];


loopTreeRelativeProjectionCoefficient[
   int : J[targetA_List, _, _], targetTopo_Association,
   referenceInt : J[referenceA_List, _, _], referenceTopo_Association
   ] := Module[{targetTimePower, referenceTimePower, targetLinePower, referenceLinePower, energy},
   targetTimePower = Total[targetA] + Total[vertexZeroPoint[targetTopo, #] & /@ activeAVertexIds[targetTopo]];
   referenceTimePower = Total[referenceA] + Total[vertexZeroPoint[referenceTopo, #] & /@ activeAVertexIds[referenceTopo]];
   (-1)^Expand[targetTimePower - referenceTimePower] Times @@ Table[
      targetLinePower = linePowerIndex[targetTopo, int, e];
      referenceLinePower = linePowerIndex[referenceTopo, referenceInt, e];
      energy = Lookup[targetTopo["lines"][[e]], "treeEnergy", xi[targetTopo["lines"][[e, "id"]]]];
      energy^(-Expand[targetLinePower - referenceLinePower]),
      {e, targetTopo["nE"]}
      ]
   ];


projectLoopIntegralToTree[int : J[aList_List, linePacks_List, ispList_List], topo_Association, referenceInt : J[_, _, _]] := Module[
   {targetTopo, referenceTopo, active, repMap, packs, legStates, originalEndpoints, line, lineId,
    relativeCoefficient},
   If[Length[linePacks] =!= topo["nE"] || ispList =!= ConstantArray[0, Length[ispList]],
    Message[loopToTreeProjection::badloop, int]; Return[$Failed]
    ];
   targetTopo = loopTreeTargetTopology[int, topo];
   referenceTopo = loopTreeTargetTopology[referenceInt, topo];
   If[MemberQ[{targetTopo, referenceTopo}, $Failed], Return[$Failed]];
   active = activeAVertexIds[targetTopo];
   repMap = Lookup[targetTopo, "sectorVertexRepresentativeMap", AssociationThread[topo["vertexIds"] -> topo["vertexIds"]]];
   If[Length[aList] =!= Length[active], Message[loopToTreeProjection::badloop, int]; Return[$Failed]];
   packs = Table[
     legStates = {};
     Do[
      If[! MemberQ[loopIntegralShrunkLines[int, topo], e] && MemberQ[{"massiveFull", "massiveCross"}, topo["lines"][[e, "packType"]]],
       line = topo["lines"][[e]];
       lineId = line["id"];
       originalEndpoints = Lookup[line, "originalEndpoints", line["endpoints"]];
       Do[
        If[Lookup[repMap, originalEndpoints[[slot]], originalEndpoints[[slot]]] === active[[v]],
         AppendTo[legStates, linePacks[[e, slot + 1]]]
         ],
        {slot, 2}
        ]
       ],
      {e, topo["nE"]}
      ];
     Prepend[legStates, aList[[v]]],
     {v, Length[active]}
     ];
   relativeCoefficient = loopTreeRelativeProjectionCoefficient[int, targetTopo, referenceInt, referenceTopo];
   relativeCoefficient J[packs]
   ];


projectLoopIntegralToTree[int : J[_, _, _], topo_Association] := Module[{targetTopo = loopTreeTargetTopology[int, topo]},
   If[targetTopo === $Failed, $Failed, loopTreeProjectionCoefficient[int, targetTopo] projectLoopIntegralToTree[int, topo, int]]
   ];
projectLoopIntegralToTree[int_J, _Association, _J] := (Message[loopToTreeProjection::badloop, int]; $Failed);
projectLoopIntegralToTree[int_J, _Association] := (Message[loopToTreeProjection::badloop, int]; $Failed);


projectLoopTimeEquationToTree[expr_, topoSpec_Association, referenceInt_: Automatic] := Module[{topo, result, ref},
   topo = normalizeTopologySpec[topoSpec];
   If[topo === $Failed, Return[$Failed]];
   ref = If[referenceInt === Automatic, FirstCase[expr, int : J[_, _, _] :> int, Missing["NoReferenceIntegral"], Infinity], referenceInt];
   If[Head[ref] === Missing || integralKind[ref] =!= "Loop", Message[loopToTreeProjection::badloop, ref]; Return[$Failed]];
   result = Expand[expr /. int : J[_, _, _] :> projectLoopIntegralToTree[int, topo, ref]];
   If[FreeQ[result, $Failed], result, $Failed]
   ];


treeContactSourceIntegrals[expr_] := Module[{integrals, maxVertices},
   integrals = DeleteDuplicates[Cases[expr, int : J[_List] :> int, Infinity]];
   If[integrals === {}, Return[{}]];
   maxVertices = Max[Length[First[#]] & /@ integrals];
   Select[integrals, Length[First[#]] < maxVertices &]
   ];


DSTreeSeeds[vertex_, int : J[_, _, _], topoSpec_Association] := Module[
   {topo, loopSeed, treeSeed, contactAudit, shrinkConsumptionTrace, allLoopIntegrals, shrunkByTerm, projectedReference},
   topo = normalizeTopologySpec[topoSpec];
   If[topo === $Failed, Return[$Failed]];
   loopSeed = dtau[vertex, int, topo];
   If[loopSeed === $Failed, Return[$Failed]];
   allLoopIntegrals = DeleteDuplicates[Cases[loopSeed, J[_, _, _], Infinity]];
   shrunkByTerm = Association@Table[
      ToString[item, InputForm] -> loopIntegralShrunkLines[item, topo],
      {item, allLoopIntegrals}
      ];
   contactAudit = Map[
     Function[e,
      <|"lineIndex" -> e, "lineId" -> topo["lines"][[e, "id"]], "skType" -> Lookup[topo["lines"][[e]], "skType", Missing["skType"]],
       "thetaAllowedQ" -> MemberQ[{"++", "--"}, Lookup[topo["lines"][[e]], "skType", "++"]]|>
      ],
     DeleteDuplicates[Flatten[Values[shrunkByTerm]]]
     ];
   shrinkConsumptionTrace = Map[
     Function[e,
      <|"lineIndex" -> e, "lineId" -> topo["lines"][[e, "id"]],
       "skType" -> Lookup[topo["lines"][[e]], "skType", Missing["skType"]],
       "consumer" -> If[Lookup[topo["lines"][[e]], "massType", "massive"] === "massive", "WT/shrinkTerms", "masslessContact"]|>
      ],
     DeleteDuplicates[Flatten[Values[shrunkByTerm]]]
     ];
   If[AnyTrue[contactAudit, ! TrueQ[#"thetaAllowedQ"] &], Message[loopToTreeProjection::mixedcontact, contactAudit]; Return[$Failed]];
   treeSeed = projectLoopTimeEquationToTree[loopSeed, topo, int];
   projectedReference = projectLoopIntegralToTree[int, topo, int];
   <|
    "status" -> If[treeSeed === $Failed, "error", "generated"],
    "generator" -> dtau[vertex],
    "loopSeed" -> loopSeed,
    "treeSeed" -> treeSeed,
    "treeIntegral" -> projectedReference,
    "referenceA" -> First[int],
    "contactAudit" -> contactAudit,
    "shrinkConsumptionTrace" -> shrinkConsumptionTrace,
    "mixedContactQ" -> AnyTrue[contactAudit, MemberQ[{"+-", "-+"}, #"skType"] &],
    "shrunkLinesByIntegral" -> shrunkByTerm
    |>
   ];


DSTreeSeeds[int : J[_, _, _], topoSpec_Association] := Module[{topo, vertices},
   topo = normalizeTopologySpec[topoSpec];
   If[topo === $Failed, Return[$Failed]];
   vertices = Lookup[Select[makeIBPGenerators[topo], #"type" === "time" &], "vertex"];
   DSTreeSeeds[#, int, topo] & /@ vertices
   ];


treeSeedRuleGroupKey[record_Association, data_Association] := Module[
   {treeInt, treeInts, vertexId, vertexIndex, packs},
   treeInts = Cases[record["treeIntegral"], _J, {0, Infinity}];
   treeInt = If[treeInts === {}, Missing["NoTreeIntegral"], First[treeInts]];
   vertexId = record["generator"] /. dtau[v_] :> v;
   vertexIndex = FirstPosition[data["vertexOrder"], vertexId, Missing["NoVertex"]];
   If[Head[treeInt] === Missing || Head[vertexIndex] === Missing, Return[Missing["BadSeedRecord"]]];
   vertexIndex = First[vertexIndex];
   packs = First[treeInt];
   {vertexId, ReplacePart[packs, vertexIndex -> {packs[[vertexIndex, 1]], "state"}]}
   ];


makeTreeTimeReductionRules::incomplete = "tree time seed 状态组不完整：`1`。";


makeTreeTimeReductionRules[records_List, data_Association] := Module[
   {good, grouped, minusRules = {}, plusRules = {}, sourceQ = False, groupData, vertexId, vertexIndex,
    vertex, states, ordered, currentInts, minusInts, equations, m1, m0, invM1, invM0t, tp, tpInv,
    regular, source, lowerRhs, upperRhs},
   good = Select[Flatten[records], AssociationQ[#] && Lookup[#, "status", "error"] === "generated" &];
   grouped = GroupBy[good, treeSeedRuleGroupKey[#, data] &];
   KeyValueMap[
    Function[{key, group},
     If[Head[key] === Missing, Return[]];
     vertexId = key[[1]];
     vertexIndex = First@FirstPosition[data["vertexOrder"], vertexId];
     vertex = data["vertices"][[vertexIndex]];
     states = treeBinaryStates[vertex["p"]];
     ordered = SortBy[group, Function[record,
        treeStateIndex[Rest[First[First[Cases[record["treeIntegral"], _J, {0, Infinity}]]][[vertexIndex]]]]
        ]];
     If[Length[ordered] =!= Length[states], Message[makeTreeTimeReductionRules::incomplete, <|"key" -> key, "expected" -> Length[states], "actual" -> Length[ordered]|>]; Return[]];
     currentInts = First[Cases[#"treeIntegral", _J, {0, Infinity}]] & /@ ordered;
     minusInts = MapThread[
       Function[{int, state}, J[ReplacePart[First[int], vertexIndex -> Prepend[state, First[int][[vertexIndex, 1]] - 1]]]],
       {currentInts, states}
       ];
     equations = Lookup[ordered, "treeSeed"];
     m1 = treeM1[vertex, vertex["nu0"] + First[currentInts[[1]]][[vertexIndex, 1]]];
     m0 = treeM0[vertex];
     invM1 = treeDiagonalInverse[m1];
     invM0t = treeDiagonalInverse[treeM0Tilde[vertex]];
     If[MemberQ[{invM1, invM0t}, $Failed], Return[]];
     tp = treeTp[vertex];
     tpInv = treeTpInverse[vertex];
     regular = m1.minusInts + m0.currentInts;
     source = Expand[equations - regular];
     If[! TrueQ[source === ConstantArray[0, Length[source]]], sourceQ = True];
     lowerRhs = Expand[treeAminusMatrix[vertex, First[currentInts[[1]]][[vertexIndex, 1]]] . currentInts - invM1.source];
     upperRhs = Expand[treeAplusMatrix[vertex, First[currentInts[[1]]][[vertexIndex, 1]] - 1] . minusInts - tpInv.invM0t.tp.source];
     minusRules = Join[minusRules, Thread[minusInts -> lowerRhs]];
     plusRules = Join[plusRules, Thread[currentInts -> upperRhs]];
     ],
    grouped
    ];
   <|
    "status" -> If[Length[grouped] === 0, "empty", "generated"],
    "minus" -> DeleteDuplicates[minusRules],
    "plus" -> DeleteDuplicates[plusRules],
    "sourceQ" -> sourceQ,
    "groupCount" -> Length[grouped]
    |>
   ];


attachTreeTimeReductionRules[data_Association, ruleData_Association] /;
   KeyExistsQ[data, "vertices"] && ! KeyExistsQ[data, "families"] := Join[
   data,
   <|
    "timeReductionRules" -> KeyTake[ruleData, {"minus", "plus"}],
    "requiresSourceRules" -> TrueQ[ruleData["sourceQ"]]
    |>
   ];


makeTreeFamilyDataFromTopology[topoSpec_Association] := Module[
   {topo, active, repMap, vertices, originalClass, signs, legs},
   topo = normalizeTopologySpec[topoSpec];
   If[topo === $Failed, Return[$Failed]];
   active = activeAVertexIds[topo];
   repMap = Lookup[topo, "sectorVertexRepresentativeMap", AssociationThread[topo["vertexIds"] -> topo["vertexIds"]]];
   vertices = Table[
     originalClass = Select[topo["vertexIds"], Lookup[repMap, #, #] === active[[v]] &];
     signs = DeleteDuplicates[Lookup[topo["vertexSignAssoc"], originalClass]];
     If[Length[signs] =!= 1,
      Message[makeTreeFamilyData::badinput, {<|"code" -> "mixedSignMergedVertex", "vertices" -> originalClass|>}];
      Return[$Failed]
      ];
     legs = Flatten@Table[
        If[MemberQ[{"massiveFull", "massiveCross"}, topo["lines"][[e, "packType"]]],
         Table[
          If[topo["lines"][[e, "endpoints", slot]] === active[[v]],
           {<|
             "id" -> {topo["lines"][[e, "id"]], slot},
             "nu" -> topo["lines"][[e, "nu"]],
             "energy" -> Lookup[topo["lines"][[e]], "treeEnergy", xi[topo["lines"][[e, "id"]]]]
             |>},
           {}
           ],
          {slot, 2}
          ],
         {}
         ],
        {e, topo["nE"]}
        ];
     <|
      "id" -> active[[v]],
      "sign" -> First[signs],
      "nu0" -> vertexZeroPoint[topo, active[[v]]],
      "energy" -> vertexExternalEnergy[topo, active[[v]]],
      "massiveLegs" -> legs
      |>,
     {v, Length[active]}
     ];
   makeTreeFamilyData[<|
     "name" -> topo["name"],
     "sector" -> sectorKeyFromShrunkLines[Lookup[topo, "sectorShrunkLines", {}]],
     "vertices" -> vertices,
     "topology" -> topo,
     "requiresSourceRules" -> thetaFullLineIndices[topo] =!= {}
     |>]
   ];


makeTreeSectorFamilies[topoSpec_Association] := Module[{topo, subsets, sectorTopos, families},
   topo = normalizeTopologySpec[topoSpec];
   If[topo === $Failed, Return[$Failed]];
   subsets = contactReachableShrinkSubsets[topo];
   sectorTopos = Join[{topo}, shrinkSectorTopology[topo, #] & /@ subsets];
   families = makeTreeFamilyDataFromTopology /@ sectorTopos;
   If[MemberQ[families, $Failed], Return[$Failed]];
   <|
    "status" -> "ready",
    "families" -> families,
    "sectorOrder" -> Lookup[families, "sector"],
    "topFamily" -> First[families]
    |>
   ];


attachTreeTimeReductionRules[context_Association, ruleData_Association] /; KeyExistsQ[context, "families"] := Module[
   {families = context["families"]},
   families[[1]] = attachTreeTimeReductionRules[First[families], ruleData];
   Join[context, <|"families" -> families, "topFamily" -> First[families]|>]
   ];


treeFamilyForIntegral::ambiguous = "tree J 的 pack 形状同时匹配多个 sector：`1`。当前表示无法唯一确定 sector，已拒绝继续约化。";


treeFamilyForIntegral[int_J, context_Association] := Module[{matches},
   matches = Select[context["families"], treeIntegralQ[int, #] &];
   Which[
    matches === {}, Missing["NoTreeSectorFamily", int],
    Length[matches] === 1, First[matches],
    True,
    Message[treeFamilyForIntegral::ambiguous, <|"integral" -> int, "sectors" -> Lookup[matches, "sector"]|>];
    Missing["AmbiguousTreeSectorFamily", int, Lookup[matches, "sector"]]
    ]
   ];


makeRepIterative0[context_Association] /; KeyExistsQ[context, "families"] := With[{sectorContext = context}, {
    HoldPattern[int_J] /; integralKind[int] === "Tree" &&
       AssociationQ[treeFamilyForIntegral[int, sectorContext]] &&
       And @@ (IntegerQ /@ First[int][[All, 1]]) &&
       AnyTrue[First[int][[All, 1]], # != 0 &] :>
     treeFirstStepToZero[int, treeFamilyForIntegral[int, sectorContext]]
    }];


treeSectorEndpoints[end_, family_Association, context_Association] := Which[
   end === Automatic, ConstantArray[0, Length[family["vertices"]]],
   AssociationQ[end], Lookup[end, family["sector"], ConstantArray[0, Length[family["vertices"]]]],
   family["sector"] === context["topFamily"]["sector"], end,
   True, ConstantArray[0, Length[family["vertices"]]]
   ];


Options[repIterativeSectorData] = Options[repIterativeData];


repIterativeSectorData[expr_, end_: Automatic, context_Association, OptionsPattern[]] := Module[
   {result = Expand[expr], maxSteps, steps = 0, integrals, item, family, endpoints, packs, vertexIndex, unresolved, scanFailure},
   maxSteps = OptionValue[MaxIterations];
   If[maxSteps === Automatic,
    maxSteps = 10 (1 + Total[Abs[Flatten[First[#][[All, 1]] & /@ DeleteDuplicates[Cases[result, _J, {0, Infinity}]]]]] + Length[context["families"]])
    ];
   If[! IntegerQ[maxSteps] || maxSteps < 0,
    Message[repIterativeData::maxsteps, maxSteps];
    Return[<|"status" -> "error", "result" -> $Failed, "steps" -> steps|>]
    ];
   While[True,
    integrals = DeleteDuplicates[Cases[result, int_J /; integralKind[int] === "Tree", {0, Infinity}]];
    unresolved = {};
    scanFailure = None;
    Do[
     family = treeFamilyForIntegral[item, context];
     If[Head[family] === Missing,
      Message[repIterativeData::nosector, item];
      scanFailure = <|"status" -> "error", "result" -> $Failed, "steps" -> steps|>;
      Break[]
      ];
     If[! And @@ (IntegerQ /@ First[item][[All, 1]]),
      Message[repIterativeData::badindex, First[item][[All, 1]]];
      scanFailure = <|"status" -> "error", "result" -> $Failed, "steps" -> steps|>;
      Break[]
      ];
     endpoints = normalizeTreeEndpoints[treeSectorEndpoints[end, family, context], family];
     If[endpoints === $Failed,
      scanFailure = <|"status" -> "error", "result" -> $Failed, "steps" -> steps|>;
      Break[]
      ];
     If[Or @@ MapThread[Unequal, {First[item][[All, 1]], endpoints}], AppendTo[unresolved, item]],
     {item, integrals}
     ];
    If[AssociationQ[scanFailure], Return[scanFailure]];
    If[unresolved === {}, Break[]];
    If[steps >= maxSteps, Message[repIterativeData::maxsteps, maxSteps]; Return[<|"status" -> "maxSteps", "result" -> $Failed, "steps" -> steps|>]];
    item = First[unresolved];
    family = treeFamilyForIntegral[item, context];
    endpoints = normalizeTreeEndpoints[treeSectorEndpoints[end, family, context], family];
    If[endpoints === $Failed, Return[<|"status" -> "error", "result" -> $Failed, "steps" -> steps|>]];
    packs = First[item];
    vertexIndex = SelectFirst[Range[Length[endpoints]], packs[[#, 1]] =!= endpoints[[#]] &];
    result = Expand[result /. item -> treeSingleStepIntegral[item, vertexIndex, endpoints[[vertexIndex]], family]];
    If[! FreeQ[result, $Failed], Return[<|"status" -> "error", "result" -> $Failed, "steps" -> steps|>]];
    steps++;
    ];
   <|"status" -> "reduced", "result" -> result, "steps" -> steps|>
   ];


repIterative[expr_, end_, context_Association, OptionsPattern[]] /; KeyExistsQ[context, "families"] := Module[{activeContext},
   (* 多 sector context 保留既有唯一分派门禁，同时同步本轮可直接替换的单步规则。 *)
   activeContext = setTreeFamilyContext[context];
   repIterativeSectorData[
     expr, end, activeContext, MaxIterations -> OptionValue[MaxIterations]
     ]["result"]
   ];


(* ::Chapter:: *)
(*Tree dlog connection*)

(* dlog 输出始终把 primitive matrix、letter/constant-matrix 对和同序 master list 一起返回。
   多顶点 top block 是按 vertexOrder 的 Kronecker sum；contact source 由 DSTreeSeeds 单独提供。 *)

treeVertexDLogData[vertex_Association] := Module[
   {p, states, energies, k0, omega0, omegaEx, tp, tpInv, m1, omega, letters, coeffs},
   p = vertex["p"];
   states = treeBinaryStates[p];
   energies = Lookup[vertex["massiveLegs"], "energy"];
   k0 = vertex["signedEnergy"];
   omega0 = -I DiagonalMatrix[Table[
      Log[k0 + Sum[(2 states[[row, i]] - 1) energies[[i]], {i, p}]],
      {row, Length[states]}
      ]];
   omegaEx = DiagonalMatrix[Table[
     -Sum[states[[row, i]] (2 vertex["massiveLegs"][[i, "nu"]] + 1) Log[energies[[i]]], {i, p}],
     {row, Length[states]}
     ]];
   tp = treeTp[vertex];
   tpInv = treeTpInverse[vertex];
   m1 = treeM1[vertex, vertex["nu0"] + 1];
   omega = Expand[omegaEx - I tpInv . omega0 . tp . m1];
   (* 每个顶点先列 massive-leg energies，再按 binary master order 列 cut letters；
      多顶点输出按 vertexOrder 稳定拼接，保证矩阵序列化可复现。 *)
   letters = DeleteDuplicates@Join[energies, Cases[omega0, Log[arg_] :> arg, Infinity]];
   coeffs = Association@Table[letter -> Map[Coefficient[#, Log[letter]] &, omega, {2}], {letter, letters}];
   <|"vertex" -> vertex["id"], "states" -> states, "omega" -> omega, "letters" -> letters, "letterMatrices" -> coeffs|>
   ];


treeEmbedVertexMatrix[matrix_List, vertexIndex_Integer, dimensions_List] := treeTensorProduct[
   Table[If[i === vertexIndex, matrix, IdentityMatrix[dimensions[[i]]]], {i, Length[dimensions]}]
   ];


DSTreeDLogDE[data_Association] := Module[{vertexData, dimensions, omega, letters, letterMatrices, masters},
   vertexData = treeVertexDLogData /@ data["vertices"];
   dimensions = 2^Lookup[data["vertices"], "p"];
   omega = Total[MapIndexed[treeEmbedVertexMatrix[#1["omega"], First[#2], dimensions] &, vertexData]];
   letters = DeleteDuplicates[Flatten[Lookup[vertexData, "letters"]]];
   letterMatrices = Association@Table[
      letter -> Map[Coefficient[#, Log[letter]] &, omega, {2}],
      {letter, letters}
      ];
   masters = treeMasterList[data];
   <|
    "status" -> "generated",
    "sector" -> data["sector"],
    "omega" -> omega,
    "letters" -> letters,
    "letterMatrices" -> letterMatrices,
    "masters" -> masters,
    "masterCount" -> Length[masters],
    "vertexOrder" -> data["vertexOrder"],
    "vertexBlocks" -> vertexData,
    "sourceStructure" -> data["sourceStructure"]
    |>
   ];


DSTreeDLogDE[data_Association, seedData_] := Join[
   DSTreeDLogDE[data],
   <|"sourceEquations" -> seedData|>
   ];

(* ::Package:: *)

(* ::Chapter:: *)
(*015 上下文、消息与进度*)

If[! ValueQ[$dSIBPMessagesEnabled], $dSIBPMessagesEnabled = True];
If[! ValueQ[$dSIBPCurrentContext], $dSIBPCurrentContext = Missing["NotInitialized"]];

DSMessagesOn[] := ($dSIBPMessagesEnabled = True);
DSMessagesOff[] := ($dSIBPMessagesEnabled = False);
DSMessagesQ[] := TrueQ[$dSIBPMessagesEnabled];

dsMessagesEnabledQ[setting_: Automatic] := If[setting === Automatic, DSMessagesQ[], TrueQ[setting]];

dsInfoPrint[text_, setting_: Automatic] := If[dsMessagesEnabledQ[setting], Print["[dSIBP] ", text]];

dsWarningPrint[text_, setting_: Automatic] := If[
   dsMessagesEnabledQ[setting],
   If[TrueQ[$Notebooks], Print[Style["Warning: " <> ToString[text], Darker[Orange]]], Print["[dSIBP Warning] ", text]]
   ];

(* fatal error 不读取全局开关；即使用户关闭可选提醒也必须可见。 *)
dsErrorPrint[text_] := If[
   TrueQ[$Notebooks],
   Print[Style["Error: " <> ToString[text], Red]],
   Print["[dSIBP Error] ", text]
   ];

dsStageRun[label_String, expression_, setting_: Automatic] := Module[{result, elapsed},
   dsInfoPrint["开始：" <> label, setting];
   {elapsed, result} = AbsoluteTiming[expression];
   dsInfoPrint["完成：" <> label <> "（" <> ToString[Round[elapsed, 0.001], InputForm] <> " s）", setting];
   result
   ];

(* Notebook 由 Monitor 在同一输出区域刷新；headless 只报告 25% 里程碑，避免逐项刷屏。 *)
dsProgressMap[label_String, items_List, function_, setting_: Automatic] := Module[
   {index = 0, total = Length[items], marks, result},
   If[total == 0, Return[{}]];
   If[! dsMessagesEnabledQ[setting], Return[function /@ items]];
   If[TrueQ[$Notebooks],
    Monitor[
     Map[(index++; function[#]) &, items],
     Row[{label, " ", Dynamic[index], "/", total, "  ", ProgressIndicator[Dynamic[index], {0, total}]}]
     ],
    marks = If[total < 8, {total}, DeleteDuplicates[Ceiling[total {1/4, 1/2, 3/4, 1}]]];
    result = Map[
      Function[item,
       index++;
       If[MemberQ[marks, index], dsInfoPrint[label <> " " <> ToString[index] <> "/" <> ToString[total], setting]];
       function[item]
       ],
      items
      ];
    result
    ]
   ];

dsContextQ[context_] := AssociationQ[context] && Lookup[context, "status", Missing["status"]] === "initialized" &&
   parsedTopologyQ[Lookup[context, "topology", Missing["topology"]]];

dsResolveContext[Automatic] := If[dsContextQ[$dSIBPCurrentContext], $dSIBPCurrentContext, Missing["NotInitialized"]];
dsResolveContext[context_Association] := If[dsContextQ[context], context, Missing["InvalidContext"]];
dsResolveContext[_] := Missing["InvalidContext"];

dsContextSummary[context_Association] := <|
   "packageVersion" -> Lookup[context, "packageVersion", Missing["packageVersion"]],
   "inputHash" -> Lookup[context, "inputHash", Missing["inputHash"]],
   "caseName" -> Lookup[context, "caseName", Missing["caseName"]],
   "sectorKeys" -> Lookup[Lookup[context, "sectors", {}], "sectorKey", {}],
   "loopTreeProjectionConvention" -> Lookup[context, "loopTreeProjectionConvention", <||>]
   |>;

(* ::Package:: *)

(* ::Chapter:: *)
(*015 初始化与 metadata 序列化*)

Options[DSInit] = {
   WriteInitializationFiles -> False,
   InitializationDirectory -> Automatic,
   GenerateDerivativeMetadata -> False,
   OverwriteInitialization -> False,
   RegisterAsCurrent -> True,
   ProgressReporting -> Automatic,
   KinematicRules -> Automatic,
   MaxShrinkSectorDepth -> Automatic,
   MaxShrinkSectorCount -> Automatic
   };

DSInit::badinput = "DSInit 输入不是有效的 topology Association，或 ISP/动量坐标不闭合。";
DSInit::sectorlimit = "无法完整初始化 contact-reachable sectors：`1`。";
DSInit::initconflict = "初始化目录 `1` 已含不同输入哈希或未知文件；如确认覆盖，请显式设置 OverwriteInitialization -> True。";
DSInit::writefailed = "初始化 metadata 写入失败：`1`。";
DSInfo::noinit = "当前没有已注册的 DSInit context。";
DSInfo::badcontext = "给定对象不是有效的 DSInit context。";

dsInputHash[input_Association] := IntegerString[Hash[HoldComplete[input], "SHA256"], 16, 64];

dsCallerDirectory[] := Which[
   StringQ[$InputFileName] && $InputFileName =!= "", DirectoryName[$InputFileName],
   TrueQ[$Notebooks], With[{directory = Quiet[NotebookDirectory[]]}, If[StringQ[directory], directory, Directory[]]],
   True, Directory[]
   ];

dsResolveInitializationDirectory[Automatic] := FileNameJoin[{dsCallerDirectory[], "init"}];
dsAbsolutePathQ[path_String] := StringStartsQ[path, "/"] || StringStartsQ[path, "\\\\"] ||
   (StringLength[path] >= 3 && StringMatchQ[StringTake[path, 1], LetterCharacter] &&
     StringTake[path, {2, 2}] === ":" && MemberQ[{"\\", "/"}, StringTake[path, {3, 3}]]);
dsResolveInitializationDirectory[path_String] := ExpandFileName[
   If[dsAbsolutePathQ[path], path, FileNameJoin[{dsCallerDirectory[], path}]]
   ];
dsResolveInitializationDirectory[_] := $Failed;

dsDerivativeMetadata[topo_Association, progressSetting_] := Module[{generators, operators},
   generators = makeIndependentVariableDerivativeGenerators[topo];
   operators = dsProgressMap[
     "正在生成微分算符",
     generators,
     Function[generator,
      <|
       "variable" -> generator["variable"],
       "userVariable" -> generator["userVariable"],
       "kind" -> generator["kind"],
        "decomposition" -> Switch[generator["kind"],
          "externalInvariant",
          makeExternalInvariantDerivativeDecomposition[topo, generator["variable"]],
          "kinematicCoordinate",
          <|
           "status" -> "chainRuleAdapter",
           "atomicCoordinates" -> Lookup[kinematicAtomicDerivativeData[topo], "inputExpression", {}],
           "atomicJacobian" -> Lookup[generator, "atomicJacobian", {}]
           |>,
          _,
          Missing["DirectVertexEnergyDerivative"]
          ]
       |>
      ],
     progressSetting
     ];
   <|"status" -> If[FreeQ[operators, $Failed], "generated", "failed"], "variableCount" -> Length[generators], "operators" -> operators|>
   ];

dsConventionMetadata[topo_Association] := <|
   "vertexData" -> topo["vertexData"],
   "lineOrder" -> Lookup[topo["lines"], "id"],
   "lineConventions" -> Map[
     KeyTake[#, {"id", "massType", "packType", "state", "skType", "bbType", "thetaConvention", "functionSystem", "compiledFunctionSystem"}] &,
     topo["lines"]
     ],
   "zeroPointRules" -> topo["zeroPointRules"],
   "shrinkPrefactorRules" -> topo["shrinkPrefactorRules"],
   "symmetryRules" -> topo["symmetryRules"],
   "effectiveSymmetryRules" -> Lookup[topo, "effectiveSymmetryRules", effectiveSymmetryRules0[topo]],
   "tadpoleSymmetryData" -> Lookup[topo, "tadpoleSymmetryData", tadpoleSymmetryData[topo]],
   "externalInvariantRules" -> topo["externalInvariantRules"],
   "independentVariables" -> independentVariableDerivativeVariables[topo],
   "loopTreeProjection" -> <|
     "vertexPhysicalPower" -> "a+a0 becomes tree a+nu0",
     "linePhysicalPower" -> "removed b+b0 or bS+bS0 becomes an explicit energy power",
     "normalization" -> "relative to the reference loop integral, term by term",
     "unsafePowerExpand" -> False
     |>
   |>;

dsRelevantInitializationWarningQ[issue_Association, topo_Association] := ! TrueQ[
   Lookup[issue, "code", ""] === "sampleDiscreteRulesMissingForDiscreteVariables" &&
    Lookup[Lookup[topo, "seedOptions", <||>], "DiscreteMode", "sample"] =!= "sample"
   ];

dsReadExistingManifest[path_String] := If[FileExistsQ[path], Quiet[Check[Get[path], $Failed]], Missing["NoManifest"]];

dsInitializationConflictQ[directory_String, inputHash_String, overwriteQ_] := Module[{manifestPath, manifest, knownFiles},
   If[TrueQ[overwriteQ] || ! DirectoryQ[directory], Return[False]];
   manifestPath = FileNameJoin[{directory, "manifest.wl"}];
   manifest = dsReadExistingManifest[manifestPath];
   knownFiles = FileExistsQ /@ (FileNameJoin[{directory, #}] & /@ {"topology.wl", "sectors.wl", "conventions.wl", "derivatives.wl"});
   Which[
    AssociationQ[manifest], Lookup[manifest, "inputHash", Missing["inputHash"]] =!= inputHash,
    Head[manifest] === Missing && ! Or @@ knownFiles, False,
    True, True
    ]
   ];

dsWriteInitializationFiles[context_Association, directory_String, overwriteQ_] := Module[
   {manifestPath, fileData, paths, manifest, writeResult},
   If[dsInitializationConflictQ[directory, context["inputHash"], overwriteQ], Return[<|"status" -> "conflict", "directory" -> directory|>]];
   Quiet[CreateDirectory[directory, CreateIntermediateDirectories -> True]];
   fileData = <|
     "topology.wl" -> context["topologyData"],
     "sectors.wl" -> context["sectors"],
     "conventions.wl" -> context["conventions"]
     |>;
   If[AssociationQ[context["derivatives"]], AssociateTo[fileData, "derivatives.wl" -> context["derivatives"]]];
   paths = AssociationMap[FileNameJoin[{directory, #}] &, Keys[fileData]];
   writeResult = Quiet[Check[KeyValueMap[(Put[#2, paths[#1]]; #1) &, fileData], $Failed]];
   If[writeResult === $Failed, Return[<|"status" -> "failed", "directory" -> directory|>]];
   manifest = <|
     "status" -> "initialized",
     "packageVersion" -> context["packageVersion"],
     "inputHash" -> context["inputHash"],
     "caseName" -> context["caseName"],
     "generatedAt" -> DateString[{"ISODate", "T", "Time", "TimeZone"}],
      "files" -> Map[FileNameTake, paths],
     "sectorCount" -> Length[context["sectors"]],
     "derivativeMetadataQ" -> AssociationQ[context["derivatives"]]
     |>;
   manifestPath = FileNameJoin[{directory, "manifest.wl"}];
   If[Quiet[Check[Put[manifest, manifestPath]; True, False]] =!= True, Return[<|"status" -> "failed", "directory" -> directory|>]];
   <|"status" -> "written", "directory" -> directory, "manifest" -> manifestPath, "files" -> Append[paths, "manifest.wl" -> manifestPath]|>
   ];

DSInit[input_Association, OptionsPattern[]] := Module[
   {progress = OptionValue[ProgressReporting], topologyData, validation, subsetSummary, derivatives, context,
     inputHash, initDirectory, writeResult = <|"status" -> "notRequested"|>, warnings,
     effectiveInput, kinematicAudit},
   effectiveInput = If[
     OptionValue[KinematicRules] === Automatic,
     input,
     Join[input, <|"kinematicRules" -> OptionValue[KinematicRules]|>]
     ];
   inputHash = dsInputHash[effectiveInput];
   topologyData = dsStageRun[
     "初始化 topology、ISP 与完整 sector metadata",
     makeTopologyData[
       effectiveInput,
      PrecomputeShrinkSectorMetadata -> True,
      MaxShrinkSectorDepth -> OptionValue[MaxShrinkSectorDepth],
      MaxShrinkSectorCount -> OptionValue[MaxShrinkSectorCount]
      ],
     progress
     ];
   validation = Lookup[topologyData, "validationReport", <|"errorCount" -> 1, "issues" -> {}|>];
   kinematicAudit = Lookup[topologyData, "kinematicCoordinateAudit", <||>];
   dsInfoPrint[
     "动力学变量选择：" <> ToString[Lookup[kinematicAudit, "status", "unknown"]] <>
      "；缺省规则 " <> ToString[Lookup[kinematicAudit, "defaultRules", {}], InputForm] <>
      "；当前规则 " <> ToString[Lookup[kinematicAudit, "selectedRules", {}], InputForm] <>
      "；从属模长绑定 " <> ToString[Lookup[kinematicAudit, "dependentMagnitudeBindings", {}], InputForm],
     progress
     ];
   If[Lookup[topologyData, "status", None] === "invalidInput" || topologyValidationErrorQ[validation],
    Message[DSInit::badinput]; dsErrorPrint["topology/ISP 初始化失败；请检查返回对象的 validationReport。"];
    Return[<|"status" -> "failed", "reason" -> "invalidInputOrTopology", "inputHash" -> inputHash, "topologyData" -> topologyData, "validationReport" -> validation|>]
    ];
   subsetSummary = Lookup[topologyData, "precomputedShrinkSectorSummary", <||>];
   If[Lookup[subsetSummary, "status", "missing"] =!= "generated" || ! TrueQ[Lookup[subsetSummary, "completeCoverageQ", False]],
    Message[DSInit::sectorlimit, subsetSummary]; dsErrorPrint["contact-reachable sector 未完整初始化。"];
    Return[<|"status" -> "failed", "reason" -> "incompleteSectorMetadata", "inputHash" -> inputHash, "topologyData" -> topologyData|>]
    ];
   warnings = Select[
     Lookup[validation, "issues", {}],
     Lookup[#, "severity", ""] === "warning" && dsRelevantInitializationWarningQ[#, topologyData] &
     ];
   Scan[dsWarningPrint[Lookup[#, "code", #], progress] &, warnings];
   derivatives = If[TrueQ[OptionValue[GenerateDerivativeMetadata]], dsDerivativeMetadata[topologyData, progress], Missing["NotGenerated"]];
   context = <|
     "status" -> "initialized",
     "packageVersion" -> $dSIBPVersion,
     "inputHash" -> inputHash,
     "caseName" -> Lookup[topologyData, "name", "unnamed"],
      "input" -> effectiveInput,
     "topology" -> topologyData,
     "topologyData" -> topologyData,
     "sectors" -> Lookup[topologyData, "sectorMetadataList", {}],
     "conventions" -> dsConventionMetadata[topologyData],
     "derivatives" -> derivatives,
     "validationReport" -> validation,
     "loopTreeProjectionConvention" -> <|
       "targetAZeroPointBecomesTreeNu0" -> True,
       "removedLineZeroPointsBecomeExplicitEnergyPowers" -> True,
       "relativePhysicalPowerNormalization" -> True,
       "unsafePowerExpand" -> False
       |>,
     "initializationWrite" -> writeResult
     |>;
   If[TrueQ[OptionValue[WriteInitializationFiles]],
    initDirectory = dsResolveInitializationDirectory[OptionValue[InitializationDirectory]];
    If[initDirectory === $Failed,
     Message[DSInit::writefailed, OptionValue[InitializationDirectory]]; dsErrorPrint["InitializationDirectory 无效。"];
     Return[Join[context, <|"status" -> "failed", "reason" -> "invalidInitializationDirectory"|>]]
     ];
    writeResult = dsWriteInitializationFiles[context, initDirectory, OptionValue[OverwriteInitialization]];
    If[writeResult["status"] === "conflict",
     Message[DSInit::initconflict, initDirectory]; dsErrorPrint["已有初始化信息与当前输入不一致，未覆盖。"];
     Return[Join[context, <|"status" -> "failed", "reason" -> "initializationConflict", "initializationWrite" -> writeResult|>]]
     ];
    If[writeResult["status"] =!= "written",
     Message[DSInit::writefailed, initDirectory]; dsErrorPrint["初始化文件未完整写入。"];
     Return[Join[context, <|"status" -> "failed", "reason" -> "initializationWriteFailed", "initializationWrite" -> writeResult|>]]
     ];
    context = Join[context, <|"initializationWrite" -> writeResult|>]
    ];
   If[TrueQ[OptionValue[RegisterAsCurrent]],
    $dSIBPCurrentContext = context;
    setIBPTopologyContext[context["topology"]]
    ];
   dsInfoPrint[
    "初始化完成：" <> context["caseName"] <> "，sector " <> ToString[Length[context["sectors"]]] <> "/" <> ToString[Length[context["sectors"]]],
    progress
    ];
   context
   ];

DSInit[input_, OptionsPattern[]] := (Message[DSInit::badinput]; dsErrorPrint["DSInit 需要 Association 输入。"]; <|"status" -> "failed", "reason" -> "inputNotAssociation", "input" -> HoldForm[input]|>);

DSInfo[] := Module[{context = dsResolveContext[Automatic]},
   If[Head[context] === Missing, Message[DSInfo::noinit]; Return[<|"status" -> "notInitialized"|>]];
   DSInfo[context]
   ];

DSInfo[context_Association] := Module[{resolved = dsResolveContext[context]},
   If[Head[resolved] === Missing, Message[DSInfo::badcontext]; Return[<|"status" -> "invalidContext"|>]];
   Join[<|"status" -> "initialized"|>, dsContextSummary[resolved], <|
     "sectorCount" -> Length[resolved["sectors"]],
     "independentVariables" -> Lookup[resolved["conventions"], "independentVariables", {}],
     "initializationWrite" -> Lookup[resolved, "initializationWrite", <||>]
     |>]
   ];

DSInfo[context_Association, "Full"] := Module[{resolved = dsResolveContext[context]},
   If[Head[resolved] === Missing, Message[DSInfo::badcontext]; <|"status" -> "invalidContext"|>, resolved]
   ];

(* ::Package:: *)

(* ::Chapter:: *)
(*014 loop seed 与 linearData 高层入口*)

Options[DSSeeds] = Join[Options[makeCanonicalSeedBatch], {ProgressReporting -> Automatic}];
Options[DSLinear] = {
   LinearSystemMode -> "symbolic",
   CoefficientRules -> Automatic,
   KiraOrdering -> Automatic,
   ProgressReporting -> Automatic
   };

DSSeeds::noinit = "DSSeeds 需要有效的 DSInit context。";
DSSeeds::failed = "canonical seed 生成未通过门禁：`1`。";
DSLinear::noinit = "DSLinear 需要有效的 DSInit context。";
DSLinear::badseed = "DSLinear 需要 DSSeeds 返回的 canonical seed Association。";
DSLinear::badmode = "LinearSystemMode 只允许 \"symbolic\" 或 \"numeric\"，收到 `1`。";
DSLinear::failed = "linearData 生成未通过门禁：`1`。";

DSSeeds[context_: Automatic, opts : OptionsPattern[]] := Module[{resolved, seedData, progress = OptionValue[ProgressReporting]},
   resolved = dsResolveContext[context];
   If[Head[resolved] === Missing,
    Message[DSSeeds::noinit]; dsErrorPrint["请先成功调用 DSInit。"]; Return[<|"status" -> "failed", "reason" -> "missingContext"|>]
    ];
   seedData = dsStageRun[
     "生成 canonical IBP seeds",
     makeCanonicalSeedBatch[
      resolved["topology"],
      Sequence @@ FilterRules[{opts}, Options[makeCanonicalSeedBatch]]
      ],
     progress
     ];
   If[Lookup[seedData, "status", "missing"] =!= "generated",
    Message[DSSeeds::failed, Lookup[seedData, "status", Missing["status"]]];
    dsErrorPrint["seed generation 返回非 generated 状态。"];
    Return[Join[seedData, <|"dSIBPStatus" -> "failed", "dSIBPContextSummary" -> dsContextSummary[resolved]|>]]
    ];
   Join[seedData, <|
     "dSIBPStatus" -> "generated",
     "dSIBPContextSummary" -> dsContextSummary[resolved],
     "numericRulesAppliedBeforeSeeds" -> TrueQ[OptionValue[ApplyNumericRules]],
     "seedNumericRules" -> If[TrueQ[OptionValue[ApplyNumericRules]], userNumericRules[resolved["topology"]], {}]
     |>]
   ];

DSLinear[seedData_Association, context_: Automatic, opts : OptionsPattern[]] := Module[
   {resolved, linearData, mode = OptionValue[LinearSystemMode], progress = OptionValue[ProgressReporting]},
   resolved = dsResolveContext[context];
   If[Head[resolved] === Missing,
    Message[DSLinear::noinit]; dsErrorPrint["请传入与 seed 同源的 DSInit context。"]; Return[<|"status" -> "failed", "reason" -> "missingContext"|>]
    ];
   If[! KeyExistsQ[seedData, "completeCanonicalQ"],
    Message[DSLinear::badseed]; dsErrorPrint["输入不是 canonical seed batch。"]; Return[<|"status" -> "failed", "reason" -> "notCanonicalSeedBatch"|>]
    ];
   If[! MemberQ[{"symbolic", "numeric"}, mode],
    Message[DSLinear::badmode, mode]; dsErrorPrint["linearData 模式无效。"]; Return[<|"status" -> "failed", "reason" -> "invalidLinearSystemMode", "mode" -> mode|>]
    ];
   linearData = dsStageRun[
     "转换 backend-neutral linearData",
     If[mode === "numeric",
      makeSampledLinearSystemData[
       seedData,
       resolved["topology"],
       KiraOrdering -> OptionValue[KiraOrdering],
       CoefficientRules -> OptionValue[CoefficientRules]
       ],
      makeLinearSystemData[
       seedData,
       resolved["topology"],
       KiraOrdering -> OptionValue[KiraOrdering]
       ]
      ],
     progress
     ];
   If[Lookup[linearData, "status", "missing"] =!= "generated",
    Message[DSLinear::failed, Lookup[linearData, "status", Missing["status"]]];
    dsErrorPrint["linearData 未通过 canonical/linearity 门禁。"];
    Return[Join[linearData, <|"dSIBPStatus" -> "failed", "dSIBPContextSummary" -> dsContextSummary[resolved]|>]]
    ];
   Join[linearData, <|
     "dSIBPStatus" -> "generated",
     "dSIBPContextSummary" -> dsContextSummary[resolved],
     "numericRulesAppliedBeforeSeeds" -> TrueQ[Lookup[seedData, "numericRulesAppliedBeforeSeeds", False]],
     "seedNumericRules" -> Lookup[seedData, "seedNumericRules", {}]
     |>]
   ];

(* ::Package:: *)

(* ::Chapter:: *)
(*014 tree sector-tagged 数据边界*)

(* 裸 J[vertexPacks] 继续作为公开公式表示；进入跨 sector linearData 时必须由后续 token 同时携带 sectorKey。
   loop-to-tree 投影系数始终复用冻结核心的完整物理幂次公式，不能从 tree pack 反推零点。 *)

treeTaggedIntegral[sectorKey_, integral_J, coefficient_: 1] := <|
   "sectorKey" -> sectorKey,
   "integral" -> integral,
   "coefficient" -> coefficient
   |>;

dsExpandedTerms[expr_] := If[Head[Expand[expr]] === Plus, List @@ Expand[expr], {Expand[expr]}];

dsLoopTermTreeTag[term_, topo_Association, referenceInt_J] := Module[
   {loopIntegrals, loopIntegral, loopCoefficient, targetTopology, referenceTopology, projected, treeIntegrals,
    treeIntegral, projectionCoefficient, targetVertices, referenceVertices, targetAInteger, referenceAInteger,
    targetAZeroPoint, referenceAZeroPoint, targetAPhysical, referenceAPhysical, targetBInteger,
    referenceBInteger, targetBZeroPoint, referenceBZeroPoint, targetBPhysical, referenceBPhysical,
    deltaTimePower, deltaLinePowers, explicitEnergyPowers, lineEnergies, auditedProjectionCoefficient},
   loopIntegrals = DeleteDuplicates[Cases[term, J[_, _, _], {0, Infinity}]];
   If[Length[loopIntegrals] =!= 1, Return[$Failed]];
   loopIntegral = First[loopIntegrals];
   loopCoefficient = term /. loopIntegral -> 1;
   targetTopology = loopTreeTargetTopology[loopIntegral, topo];
   referenceTopology = loopTreeTargetTopology[referenceInt, topo];
   projected = projectLoopIntegralToTree[loopIntegral, topo, referenceInt];
   If[MemberQ[{targetTopology, referenceTopology, projected}, $Failed], Return[$Failed]];
   treeIntegrals = DeleteDuplicates[Cases[projected, J[_List], {0, Infinity}]];
   If[Length[treeIntegrals] =!= 1, Return[$Failed]];
   treeIntegral = First[treeIntegrals];
   projectionCoefficient = projected /. treeIntegral -> 1;
   targetVertices = activeAVertexIds[targetTopology];
   referenceVertices = activeAVertexIds[referenceTopology];
   targetAInteger = First[loopIntegral];
   referenceAInteger = First[referenceInt];
   targetAZeroPoint = vertexZeroPoint[targetTopology, #] & /@ targetVertices;
   referenceAZeroPoint = vertexZeroPoint[referenceTopology, #] & /@ referenceVertices;
   targetAPhysical = MapThread[Plus, {targetAInteger, targetAZeroPoint}];
   referenceAPhysical = MapThread[Plus, {referenceAInteger, referenceAZeroPoint}];
   targetBInteger = First /@ loopIntegral[[2]];
   referenceBInteger = First /@ referenceInt[[2]];
   targetBZeroPoint = Table[
     If[actualLinePackType[targetTopology, e, loopIntegral[[2, e]]] === "shrunk",
      lineBSZeroPoint[targetTopology, e],
      lineBZeroPoint[targetTopology, e]
      ],
     {e, targetTopology["nE"]}
     ];
   referenceBZeroPoint = Table[
     If[actualLinePackType[referenceTopology, e, referenceInt[[2, e]]] === "shrunk",
      lineBSZeroPoint[referenceTopology, e],
      lineBZeroPoint[referenceTopology, e]
      ],
     {e, referenceTopology["nE"]}
     ];
   targetBPhysical = MapThread[Plus, {targetBInteger, targetBZeroPoint}];
   referenceBPhysical = MapThread[Plus, {referenceBInteger, referenceBZeroPoint}];
   deltaTimePower = Expand[Total[targetAPhysical] - Total[referenceAPhysical]];
   deltaLinePowers = MapThread[Expand[#1 - #2] &, {targetBPhysical, referenceBPhysical}];
   explicitEnergyPowers = -deltaLinePowers;
   lineEnergies = Table[
     Lookup[targetTopology["lines"][[e]], "treeEnergy", xi[targetTopology["lines"][[e, "id"]]]],
     {e, targetTopology["nE"]}
     ];
   auditedProjectionCoefficient = (-1)^deltaTimePower Times @@ MapThread[Power, {lineEnergies, explicitEnergyPowers}];
   <|
    "sectorKey" -> sectorKeyFromShrunkLines[Lookup[targetTopology, "sectorShrunkLines", {}]],
    "integral" -> treeIntegral,
    "coefficient" -> Expand[loopCoefficient projectionCoefficient],
    "sourceLoopIntegral" -> loopIntegral,
    "projectionCoefficient" -> projectionCoefficient,
    "physicalPowerAudit" -> <|
      "target" -> <|
        "sectorKey" -> sectorKeyFromShrunkLines[Lookup[targetTopology, "sectorShrunkLines", {}]],
        "aInteger" -> targetAInteger,
        "aZeroPoint" -> targetAZeroPoint,
        "aPhysical" -> targetAPhysical,
        "bInteger" -> targetBInteger,
        "bZeroPoint" -> targetBZeroPoint,
        "bPhysical" -> targetBPhysical,
        "treeNu0" -> targetAZeroPoint
        |>,
      "reference" -> <|
        "sectorKey" -> sectorKeyFromShrunkLines[Lookup[referenceTopology, "sectorShrunkLines", {}]],
        "aInteger" -> referenceAInteger,
        "aZeroPoint" -> referenceAZeroPoint,
        "aPhysical" -> referenceAPhysical,
        "bInteger" -> referenceBInteger,
        "bZeroPoint" -> referenceBZeroPoint,
        "bPhysical" -> referenceBPhysical
        |>,
      "deltaTimePower" -> deltaTimePower,
      "deltaLineIntegerPowers" -> MapThread[Expand[#1 - #2] &, {targetBInteger, referenceBInteger}],
      "deltaLineZeroPointPowers" -> MapThread[Expand[#1 - #2] &, {targetBZeroPoint, referenceBZeroPoint}],
      "deltaLinePhysicalPowers" -> deltaLinePowers,
      "explicitEnergyPowers" -> explicitEnergyPowers,
      "lineEnergies" -> lineEnergies,
      "auditedProjectionCoefficient" -> auditedProjectionCoefficient,
      "projectionCoefficientMatchesAudit" -> TrueQ[projectionCoefficient === auditedProjectionCoefficient],
      "zeroPointRules" -> targetTopology["zeroPointRules"],
      "unsafePowerExpand" -> False
      |>
    |>
   ];

dsCombineTreeTaggedTerms[terms_List] := Map[
   Function[group,
    Join[
     First[group],
     <|
      "coefficient" -> Total[Lookup[group, "coefficient"]],
      "sourceLoopIntegrals" -> Lookup[group, "sourceLoopIntegral"],
      "projectionCoefficients" -> Lookup[group, "projectionCoefficient"],
      "physicalPowerAudits" -> Lookup[group, "physicalPowerAudit"],
      "contributions" -> (KeyTake[#, {"coefficient", "sourceLoopIntegral", "projectionCoefficient", "physicalPowerAudit"}] & /@ group)
      |>
     ]
    ],
   GatherBy[terms, {Lookup[#, "sectorKey"], Lookup[#, "integral"]} &]
   ];

dsTreeLinearData[record_Association, topo_Association, referenceInt_J] := Module[{taggedTerms, combined},
   taggedTerms = dsLoopTermTreeTag[#, topo, referenceInt] & /@ dsExpandedTerms[record["loopSeed"]];
   If[MemberQ[taggedTerms, $Failed], Return[<|"status" -> "failed", "reason" -> "treeTagProjectionFailed"|>]];
   combined = dsCombineTreeTaggedTerms[taggedTerms];
   <|
    "status" -> "generated",
    "terms" -> combined,
    "termCount" -> Length[combined],
    "sectorKeys" -> DeleteDuplicates[Lookup[combined, "sectorKey"]],
    "expression" -> Total[(Lookup[#, "coefficient"] Lookup[#, "integral"]) & /@ combined],
    "referenceLoopIntegral" -> referenceInt,
    "coefficientConvention" -> "complete physical powers: a+a0 and b+b0 or bS+bS0"
    |>
   ];

dsEnrichTreeSeedRecord[record_Association, topo_Association, referenceInt_J] := Join[
   record,
   <|"treeLinearData" -> dsTreeLinearData[record, topo, referenceInt]|>
   ];


(* ::Chapter:: *)
(*Sector-tagged tree 迭代*)

(* dsTreeToken 只在 Private context 中承载 sector 身份；对外结果仍序列化为 Association 与统一 Head J。 *)

dsTreeLinearDataQ[data_] := AssociationQ[data] &&
   Lookup[data, "status", Missing["status"]] === "generated" &&
   ListQ[Lookup[data, "terms", Missing["terms"]]] &&
   And @@ (AssociationQ[#] && StringQ[Lookup[#, "sectorKey", None]] && MatchQ[Lookup[#, "integral", None], _J] & /@ data["terms"]);


dsTreeFamilyBySector[sectorKey_String, context_Association] := Module[{matches},
   matches = Select[Lookup[context, "families", {}], Lookup[#, "sector", None] === sectorKey &];
   If[Length[matches] === 1, First[matches], Missing["TreeSectorFamily", sectorKey, Length[matches]]]
   ];


dsTreeTokenExpression[data_Association] /; dsTreeLinearDataQ[data] := Total[
   Lookup[#, "coefficient"] dsTreeToken[Lookup[#, "sectorKey"], Lookup[#, "integral"]] & /@ data["terms"]
   ];


dsTreeTokenTerms[expr_] := Module[{rawTerms, tagged},
   rawTerms = dsExpandedTerms[expr];
   tagged = Map[
     Function[term,
      With[{tokens = DeleteDuplicates[Cases[term, token : dsTreeToken[_String, _J] :> token, {0, Infinity}]]},
       If[Length[tokens] =!= 1,
        $Failed,
        treeTaggedIntegral[tokens[[1, 1]], tokens[[1, 2]], Expand[term /. tokens[[1]] -> 1]]
        ]
       ]
     ],
     rawTerms
     ];
   If[MemberQ[tagged, $Failed], Return[$Failed]];
   Map[
    Function[group, Join[First[group], <|"coefficient" -> Total[Lookup[group, "coefficient"]]|>]],
    GatherBy[tagged, {Lookup[#, "sectorKey"], Lookup[#, "integral"]} &]
    ]
   ];


dsTreeRecordTokenEquation[record_Association] := Module[{linearData = Lookup[record, "treeLinearData", Missing["treeLinearData"]]},
   If[dsTreeLinearDataQ[linearData], dsTreeTokenExpression[linearData], $Failed]
   ];


dsMakeTreeTaggedTimeReductionRules[records_List, data_Association] := Module[
   {good, grouped, minusRules = {}, plusRules = {}, sourceQ = False, sectorKey, vertexId, vertexIndex,
    vertex, states, ordered, currentInts, minusInts, currentTokens, minusTokens, equations,
    m1, m0, invM1, invM0t, tp, tpInv, regular, source, lowerRhs, upperRhs},
   good = Select[Flatten[records], AssociationQ[#] && Lookup[#, "status", "error"] === "generated" &&
       dsTreeLinearDataQ[Lookup[#, "treeLinearData", <||>]] &];
   grouped = GroupBy[good, treeSeedRuleGroupKey[#, data] &];
   sectorKey = data["sector"];
   KeyValueMap[
    Function[{key, group},
     If[Head[key] === Missing, Return[]];
     vertexId = key[[1]];
     vertexIndex = First@FirstPosition[data["vertexOrder"], vertexId];
     vertex = data["vertices"][[vertexIndex]];
     states = treeBinaryStates[vertex["p"]];
     ordered = SortBy[group, Function[record,
        treeStateIndex[Rest[First[First[Cases[record["treeIntegral"], _J, {0, Infinity}]]][[vertexIndex]]]]
        ]];
     If[Length[ordered] =!= Length[states],
      Message[makeTreeTimeReductionRules::incomplete, <|"key" -> key, "expected" -> Length[states], "actual" -> Length[ordered]|>];
      Return[]
      ];
     currentInts = First[Cases[#"treeIntegral", _J, {0, Infinity}]] & /@ ordered;
     minusInts = MapThread[
       Function[{int, state}, J[ReplacePart[First[int], vertexIndex -> Prepend[state, First[int][[vertexIndex, 1]] - 1]]]],
       {currentInts, states}
       ];
     currentTokens = dsTreeToken[sectorKey, #] & /@ currentInts;
     minusTokens = dsTreeToken[sectorKey, #] & /@ minusInts;
     equations = dsTreeRecordTokenEquation /@ ordered;
     If[MemberQ[equations, $Failed], Return[]];
     m1 = treeM1[vertex, vertex["nu0"] + First[currentInts[[1]]][[vertexIndex, 1]]];
     m0 = treeM0[vertex];
     invM1 = treeDiagonalInverse[m1];
     invM0t = treeDiagonalInverse[treeM0Tilde[vertex]];
     If[MemberQ[{invM1, invM0t}, $Failed], Return[]];
     tp = treeTp[vertex];
     tpInv = treeTpInverse[vertex];
     regular = m1.minusTokens + m0.currentTokens;
     source = Expand[equations - regular];
     If[! TrueQ[source === ConstantArray[0, Length[source]]], sourceQ = True];
     lowerRhs = Expand[treeAminusMatrix[vertex, First[currentInts[[1]]][[vertexIndex, 1]]] . currentTokens - invM1.source];
     upperRhs = Expand[treeAplusMatrix[vertex, First[currentInts[[1]]][[vertexIndex, 1]] - 1] . minusTokens - tpInv.invM0t.tp.source];
     minusRules = Join[minusRules, Thread[minusTokens -> lowerRhs]];
     plusRules = Join[plusRules, Thread[currentTokens -> upperRhs]];
     ],
    grouped
    ];
   <|
    "status" -> If[Length[grouped] === 0, "empty", "generated"],
    "minus" -> DeleteDuplicates[minusRules],
    "plus" -> DeleteDuplicates[plusRules],
    "sourceQ" -> sourceQ,
    "groupCount" -> Length[grouped]
    |>
   ];


dsTreeSeedRecordFromSector[vertex_, int : J[_, _, _], family_Association] := Module[
   {sectorTopology = family["topology"], rootTopology, loopSeed, treeSeed, treeIntegral, record},
   rootTopology = Lookup[family, "rootTopology", sectorTopology];
   loopSeed = dtau[vertex, int, sectorTopology];
   If[loopSeed === $Failed, Return[$Failed]];
   treeSeed = projectLoopTimeEquationToTree[loopSeed, rootTopology, int];
   treeIntegral = projectLoopIntegralToTree[int, rootTopology, int];
   If[MemberQ[{treeSeed, treeIntegral}, $Failed], Return[$Failed]];
   record = <|
     "status" -> "generated",
     "generator" -> dtau[vertex],
     "loopSeed" -> loopSeed,
     "treeSeed" -> treeSeed,
     "treeIntegral" -> treeIntegral,
     "referenceA" -> First[int],
     "sectorKey" -> family["sector"]
     |>;
   dsEnrichTreeSeedRecord[record, rootTopology, int]
   ];


dsTreeTaggedSourceAwareStep[token : dsTreeToken[sectorKey_String, int_J], vertexIndex_Integer, endpoint_Integer, family_Association] := Module[
   {packs = First[int], current, seedA, states, vertexId, localIntegrals, loopIntegrals, records, ruleData, rules, result},
   current = packs[[vertexIndex, 1]];
   If[current === endpoint, Return[token]];
   seedA = If[current < endpoint, current + 1, current];
   states = treeBinaryStates[family["vertices"][[vertexIndex, "p"]]];
   vertexId = family["vertexOrder"][[vertexIndex]];
   localIntegrals = J[ReplacePart[packs, vertexIndex -> Prepend[#, seedA]]] & /@ states;
   loopIntegrals = treeLoopIntegralFromTree[#, family] & /@ localIntegrals;
   If[! FreeQ[loopIntegrals, $Failed], Return[$Failed]];
   records = dsTreeSeedRecordFromSector[vertexId, #, family] & /@ loopIntegrals;
   If[! FreeQ[records, $Failed], Return[$Failed]];
   ruleData = dsMakeTreeTaggedTimeReductionRules[records, family];
   rules = Lookup[ruleData, If[current < endpoint, "minus", "plus"], {}];
   result = Replace[token, rules];
   If[result === token,
    Message[makeTreeFamilyData::badinput, {<|"code" -> "missingSectorTaggedSourceStep", "sector" -> sectorKey,
       "integral" -> int, "vertex" -> vertexId|>}];
    $Failed,
    result
    ]
   ];


dsTreeTaggedSingleStep[token : dsTreeToken[sectorKey_String, int_J], vertexIndex_Integer, endpoint_Integer, family_Association] := Module[{bareResult},
   If[TrueQ[Lookup[family, "requiresSourceRules", False]] && AssociationQ[Lookup[family, "topology", Missing["NoLoopTopology"]]],
    Return[dsTreeTaggedSourceAwareStep[token, vertexIndex, endpoint, family]]
    ];
   bareResult = treeSingleStepIntegral[int, vertexIndex, endpoint, family];
   If[bareResult === $Failed, $Failed, bareResult /. item_J :> dsTreeToken[sectorKey, item]]
   ];


Options[dsRepIterativeTreeLinearData] = Options[repIterativeData];


dsRepIterativeTreeLinearData[data_Association, end_: Automatic, context_Association, OptionsPattern[]] := Module[
   {familyContext, result, maxSteps, steps = 0, tokens, token, sectorKey, int, family, endpoints, vertexIndex, reducedTerms},
   If[! dsTreeLinearDataQ[data], Return[<|"status" -> "error", "reason" -> "invalidTreeLinearData"|>]];
   familyContext = dsTreeFamilyContext[context];
   result = Expand[dsTreeTokenExpression[data]];
   maxSteps = OptionValue[MaxIterations];
   If[maxSteps === Automatic,
    maxSteps = 10 (1 + Total[Abs[Cases[result, dsTreeToken[_, item_J] :> First[item][[All, 1]], Infinity] // Flatten]] + Length[familyContext["families"]])
    ];
   If[! IntegerQ[maxSteps] || maxSteps < 0,
    Message[repIterativeData::maxsteps, maxSteps];
    Return[<|"status" -> "error", "reason" -> "invalidMaxIterations", "steps" -> steps|>]
    ];
   While[True,
    tokens = DeleteDuplicates[Cases[result, token : dsTreeToken[_String, _J] :> token, {0, Infinity}]];
    token = SelectFirst[
      tokens,
      Function[item,
       family = dsTreeFamilyBySector[item[[1]], familyContext];
       If[Head[family] === Missing, True,
        endpoints = normalizeTreeEndpoints[treeSectorEndpoints[end, family, familyContext], family];
        endpoints === $Failed || Or @@ MapThread[Unequal, {First[item[[2]]][[All, 1]], endpoints}]
        ]
       ],
      Missing["AllAtEndpoints"]
      ];
    If[Head[token] === Missing, Break[]];
    sectorKey = token[[1]];
    int = token[[2]];
    family = dsTreeFamilyBySector[sectorKey, familyContext];
    If[Head[family] === Missing,
     Message[repIterativeData::nosector, <|"sectorKey" -> sectorKey, "integral" -> int|>];
     Return[<|"status" -> "error", "reason" -> "unknownSector", "steps" -> steps|>]
     ];
    If[! treeIntegralQ[int, family] || ! And @@ (IntegerQ /@ First[int][[All, 1]]),
     Message[repIterativeData::badindex, <|"sectorKey" -> sectorKey, "integral" -> int|>];
     Return[<|"status" -> "error", "reason" -> "invalidTaggedIntegral", "steps" -> steps|>]
     ];
    endpoints = normalizeTreeEndpoints[treeSectorEndpoints[end, family, familyContext], family];
    If[endpoints === $Failed, Return[<|"status" -> "error", "reason" -> "invalidEndpoint", "steps" -> steps|>]];
    If[steps >= maxSteps,
     Message[repIterativeData::maxsteps, maxSteps];
     Return[<|"status" -> "maxSteps", "reason" -> "iterationLimit", "steps" -> steps|>]
     ];
    vertexIndex = SelectFirst[Range[Length[endpoints]], First[int][[#, 1]] =!= endpoints[[#]] &];
    result = Expand[result /. token -> dsTreeTaggedSingleStep[token, vertexIndex, endpoints[[vertexIndex]], family]];
    If[! FreeQ[result, $Failed], Return[<|"status" -> "error", "reason" -> "taggedStepFailed", "steps" -> steps|>]];
    steps++;
    ];
   reducedTerms = dsTreeTokenTerms[result];
   If[reducedTerms === $Failed, Return[<|"status" -> "error", "reason" -> "taggedTermExtractionFailed", "steps" -> steps|>]];
   <|
    "status" -> "reduced",
    "terms" -> reducedTerms,
    "termCount" -> Length[reducedTerms],
    "sectorKeys" -> DeleteDuplicates[Lookup[reducedTerms, "sectorKey"]],
    "expression" -> Total[Lookup[#, "coefficient"] Lookup[#, "integral"] & /@ reducedTerms],
    "steps" -> steps,
    "endpoints" -> end,
    "inputTreeLinearData" -> data,
    "coefficientConvention" -> Lookup[data, "coefficientConvention", Missing["coefficientConvention"]]
    |>
   ];


(* ::Chapter:: *)
(*Naive tree time-IBP 线性系统*)

(* 这一路只把投影后的 dtau 当作线性方程求解，不调用 A-/A+ 递推或 dlog 公式。
   master record 必须携带 sectorKey 与 normalization，避免同 shape lower sector 混淆。 *)

Options[DSTreeNaiveIBP] = {ProgressReporting -> Automatic};

DSTreeNaiveIBP::badmasters = "tree naive IBP 需要非空、无重复且可唯一匹配 sector 的 tagged master 列表。";
DSTreeNaiveIBP::nonsquare = "tree naive IBP 方程数 `1` 与待约化对象数 `2` 不相等。";
DSTreeNaiveIBP::solvefailed = "tree naive IBP 线性系统求解失败。";


dsTreeTaggedMasterQ[record_] := AssociationQ[record] &&
   StringQ[Lookup[record, "sectorKey", None]] &&
   MatchQ[Lookup[record, "integral", None], _J] &&
   ! TrueQ[Lookup[record, "coefficient", 0] === 0];


dsTreeResolveNaiveMasters[Automatic, context_Association] := Module[{dlog = DSTreeDLogDE[context]},
   If[Lookup[dlog, "status", "error"] === "generated", Lookup[dlog, "masters", $Failed], $Failed]
   ];
dsTreeResolveNaiveMasters[masters_List, _Association] := masters;
dsTreeResolveNaiveMasters[_, _Association] := $Failed;


dsTreeMasterFamilyRecords[masters_List, familyContext_Association] := Map[
   Function[master,
    With[{family = dsTreeFamilyBySector[master["sectorKey"], familyContext]},
     If[Head[family] === Missing || ! treeIntegralQ[master["integral"], family],
      $Failed,
      <|"master" -> master, "family" -> family|>
      ]
     ]
    ],
   masters
   ];


dsTreeNaiveSeedRecords[masterFamilyRecords_List, progress_] := Flatten@dsProgressMap[
    "正在生成 naive tree time-IBP",
    masterFamilyRecords,
    Function[item,
     With[{master = item["master"], family = item["family"]},
      MapIndexed[
       Function[{vertexId, position},
        With[{seedIntegral = J[ReplacePart[
             First[master["integral"]],
             First[position] -> ReplacePart[First[master["integral"]][[First[position]]], 1 -> 1]
             ]]},
         With[{loopIntegral = treeLoopIntegralFromTree[seedIntegral, family]},
          If[loopIntegral === $Failed, $Failed, dsTreeSeedRecordFromSector[vertexId, loopIntegral, family]]
          ]
         ]
        ],
       family["vertexOrder"]
       ]
      ]
     ],
    progress
    ];


dsTreePublicReductionRecord[rule_Rule] := Module[{lhs, rhsTerms},
   lhs = First[rule];
   rhsTerms = dsTreeTokenTerms[Last[rule]];
   If[! MatchQ[lhs, dsTreeToken[_String, _J]] || rhsTerms === $Failed,
    $Failed,
    <|
     "lhs" -> treeTaggedIntegral[lhs[[1]], lhs[[2]]],
     "rhsTerms" -> rhsTerms,
     "rhsExpression" -> Total[Lookup[#, "coefficient"] Lookup[#, "integral"] & /@ rhsTerms]
     |>
    ]
   ];


dsTreeInternalReductionRules[data_Association] := Map[
   Function[record,
    dsTreeToken[record["lhs", "sectorKey"], record["lhs", "integral"]] ->
     Total[Lookup[#, "coefficient"] dsTreeToken[Lookup[#, "sectorKey"], Lookup[#, "integral"]] & /@ record["rhsTerms"]]
    ],
   Lookup[data, "reductions", {}]
   ];


DSTreeNaiveIBP[context_Association, masters_: Automatic, OptionsPattern[]] /; dsContextQ[context] := Module[
   {resolvedMasters, familyContext, masterFamilyRecords, seedRecords, equations, masterTokens, allTokens,
    unknownTokens, matrix, constantVector, solution, tokenRules, publicRules, solveResiduals, status},
   resolvedMasters = dsTreeResolveNaiveMasters[masters, context];
   familyContext = dsTreeFamilyContext[context];
   If[! ListQ[resolvedMasters] || resolvedMasters === {} || ! And @@ (dsTreeTaggedMasterQ /@ resolvedMasters) ||
     DuplicateFreeQ[{Lookup[#, "sectorKey"], Lookup[#, "integral"]} & /@ resolvedMasters] =!= True || familyContext === $Failed,
    Message[DSTreeNaiveIBP::badmasters];
    Return[<|"status" -> "failed", "reason" -> "invalidMasters"|>]
    ];
   masterFamilyRecords = dsTreeMasterFamilyRecords[resolvedMasters, familyContext];
   If[MemberQ[masterFamilyRecords, $Failed],
    Message[DSTreeNaiveIBP::badmasters];
    Return[<|"status" -> "failed", "reason" -> "masterSectorMismatch", "masters" -> resolvedMasters|>]
    ];
   seedRecords = dsTreeNaiveSeedRecords[masterFamilyRecords, OptionValue[ProgressReporting]];
   If[MemberQ[seedRecords, $Failed] || AnyTrue[seedRecords, Lookup[#, "status", "error"] =!= "generated" &],
    Return[<|"status" -> "failed", "reason" -> "seedGenerationFailed", "seedRecords" -> seedRecords|>]
    ];
   equations = DeleteDuplicates[dsTreeRecordTokenEquation /@ seedRecords];
   If[MemberQ[equations, $Failed], Return[<|"status" -> "failed", "reason" -> "taggedEquationFailed"|>]];
   masterTokens = dsTreeToken[Lookup[#, "sectorKey"], Lookup[#, "integral"]] & /@ resolvedMasters;
   allTokens = DeleteDuplicates[Cases[equations, token : dsTreeToken[_String, _J] :> token, Infinity]];
   unknownTokens = Select[allTokens, ! MemberQ[masterTokens, #] &];
   If[Length[equations] =!= Length[unknownTokens],
    Message[DSTreeNaiveIBP::nonsquare, Length[equations], Length[unknownTokens]];
    Return[<|"status" -> "failed", "reason" -> "nonSquareSystem", "equationCount" -> Length[equations],
      "unknownCount" -> Length[unknownTokens], "masters" -> resolvedMasters, "seedRecords" -> seedRecords|>]
    ];
   matrix = Table[Coefficient[equations[[row]], unknownTokens[[column]]],
     {row, Length[equations]}, {column, Length[unknownTokens]}];
   constantVector = Expand[equations /. Thread[unknownTokens -> 0]];
   solution = Quiet[Check[LinearSolve[matrix, -constantVector], $Failed]];
   If[solution === $Failed,
    Message[DSTreeNaiveIBP::solvefailed];
    Return[<|"status" -> "failed", "reason" -> "linearSolveFailed", "equationCount" -> Length[equations],
      "unknownCount" -> Length[unknownTokens], "masters" -> resolvedMasters, "seedRecords" -> seedRecords|>]
    ];
   tokenRules = Thread[unknownTokens -> solution];
   solveResiduals = Together /@ Expand[equations /. tokenRules];
   publicRules = dsTreePublicReductionRecord /@ tokenRules;
   status = If[FreeQ[publicRules, $Failed] && And @@ (TrueQ[# === 0] & /@ solveResiduals), "solved", "failed"];
   <|
    "status" -> status,
    "reason" -> If[status === "solved", None, "nonzeroSolveResidual"],
    "masters" -> resolvedMasters,
    "masterCount" -> Length[resolvedMasters],
    "masterSource" -> If[masters === Automatic, "DSTreeDLogDE", "explicit"],
    "equationCount" -> Length[equations],
    "unknownCount" -> Length[unknownTokens],
    "seedRecords" -> seedRecords,
    "reductions" -> publicRules,
    "solveResiduals" -> solveResiduals,
    "context" -> context,
    "equationConvention" -> "projected loop dtau == 0; non-master tagged tree integrals solved in the supplied master basis",
    "formulaRecurrenceUsedQ" -> False
    |>
   ];


DSTreeNaiveIBP[_, ___] := (Message[DSTreeNaiveIBP::badmasters]; <|"status" -> "failed", "reason" -> "invalidContextOrMasters"|>);

(* ::Package:: *)

(* ::Chapter:: *)
(*014 Kira 导出边界*)

Options[DSKiraExport] = Join[Options[makeKiraExportData], {
   KiraActiveBasis -> None,
   ProgressReporting -> Automatic
   }];

DSKiraExport::badlinear = "DSKiraExport 需要 DSLinear 返回的 backend-neutral linearData。";
DSKiraExport::failed = "Kira 输入未生成：`1`。";
DSKiraExport::badbasis = "KiraActiveBasis 未通过验证：`1`。";


(* ::Section::Closed:: *)
(*Active basis 与导数 target closure*)

(* active basis 只占用 backend ID；用户侧和物理层仍只使用 J，避免建立平行积分 Head。 *)
dsKiraActiveBasisVariables[Automatic, topo_Association] :=
   scalarProductInternalToUser[#, topo] & /@ independentVariableDerivativeVariables[topo];
dsKiraActiveBasisVariables[variables_List, _Association] := variables;
dsKiraActiveBasisVariables[variable_, _Association] := {variable};

dsKiraActiveBasisNames[Automatic, count_Integer] := "active" <> ToString[#] & /@ Range[count];
dsKiraActiveBasisNames[names_List, _Integer] := names;
dsKiraActiveBasisNames[_, _Integer] := $Failed;

dsKiraLinearizeActiveBasisExpression[expr_, activeID_Integer, integralIndex_Association, name_String] := Module[
   {terms, termData, linearPieces, constantTerms, nonlinearTerms, rules},
   terms = linearTerms[Expand[expr]];
   termData = linearTermData[#, integralIndex] & /@ terms;
   linearPieces = Select[termData, Lookup[#, "kind", "missing"] === "linear" &];
   constantTerms = Lookup[Select[termData, Lookup[#, "kind", "missing"] === "constant" &], "term", {}];
   nonlinearTerms = Lookup[Select[termData, Lookup[#, "kind", "missing"] === "nonlinear" &], "term", {}];
   rules = Join[{activeID -> 1}, (First[#] -> -Last[#]) & /@ combineLinearCoefficientRules[linearPieces]];
   <|
    "activeBasisName" -> name,
    "activeBasisID" -> activeID,
    "coefficientRules" -> rules,
    "constantTerm" -> Total[constantTerms],
    "nonlinearTerms" -> nonlinearTerms,
    "linearQ" -> TrueQ[nonlinearTerms === {} && Total[constantTerms] === 0 && linearPieces =!= {}]
    |>
   ];

dsKiraAttachActiveBasis[linearData_Association, setting_] /; setting === None || setting === Automatic :=
   Join[linearData, <|"activeBasis" -> <|"status" -> "disabled", "count" -> 0|>|>];

dsKiraAttachActiveBasis[linearData_Association, setting_Association] := Module[
   {expressions, count, names, activeIndices, activeCount, activeExpressions, activeNames, topo, variables, allowedVariables, badVariables, degrees,
    oldCount, oldRules, idShift, shiftedRules, shiftedEquations, integralIndex,
    basisEquations, badEquations, rawDerivatives, derivativeIntegrals, missingDerivativeIntegrals,
    relationIDs, activeIDs, auxiliaryIDs, derivativeTargetIDs, targetIDs, activeData},
   expressions = Lookup[setting, "expressions", Missing["expressions"]];
   If[! ListQ[expressions] || expressions === {},
    Return[<|"status" -> "invalidActiveBasis", "reason" -> "expressionsMustBeNonemptyList", "activeBasisInput" -> setting|>]
    ];
   count = Length[expressions];
   names = dsKiraActiveBasisNames[Lookup[setting, "names", Automatic], count];
   If[names === $Failed || Length[names] =!= count || ! And @@ (StringQ[#] && # =!= "" & /@ names) || ! DuplicateFreeQ[names],
    Return[<|"status" -> "invalidActiveBasis", "reason" -> "namesMustBeUniqueNonemptyStrings", "activeBasisInput" -> setting|>]
    ];
   activeIndices = Replace[Lookup[setting, "activeIndices", Automatic], (Automatic | All) -> Range[count]];
   If[! ListQ[activeIndices] || activeIndices === {} || ! DuplicateFreeQ[activeIndices] ||
     ! And @@ (IntegerQ[#] && 1 <= # <= count & /@ activeIndices),
    Return[<|"status" -> "invalidActiveBasis", "reason" -> "activeIndicesMustBeUniqueValidPositions", "activeIndices" -> activeIndices|>]
    ];
   activeCount = Length[activeIndices];
   activeExpressions = expressions[[activeIndices]];
   activeNames = names[[activeIndices]];
   topo = Lookup[linearData, "topology", Missing["topology"]];
   If[! parsedTopologyQ[topo],
    Return[<|"status" -> "invalidActiveBasis", "reason" -> "missingParsedTopology"|>]
    ];
   variables = dsKiraActiveBasisVariables[Lookup[setting, "derivativeVariables", Automatic], topo];
   allowedVariables = dsKiraActiveBasisVariables[Automatic, topo];
   badVariables = Complement[variables, allowedVariables];
   If[variables === {} || badVariables =!= {},
    Return[<|"status" -> "invalidActiveBasis", "reason" -> "invalidDerivativeVariables", "derivativeVariables" -> variables, "badVariables" -> badVariables, "allowedVariables" -> allowedVariables|>]
    ];
   degrees = Lookup[setting, "scalingDegrees", Automatic];
   If[degrees =!= Automatic && (! ListQ[degrees] || Length[degrees] =!= activeCount),
    Return[<|"status" -> "invalidActiveBasis", "reason" -> "scalingDegreesLengthMismatch", "scalingDegrees" -> degrees|>]
    ];
   oldCount = Lookup[linearData, "integralCount", 0];
   oldRules = Lookup[linearData, "integralRules", {}];
   idShift = AssociationThread[Range[oldCount], Range[oldCount] + count];
   shiftedRules = oldRules /. (integral_J -> id_Integer) :> (integral -> Lookup[idShift, id, Missing["unknownIntegralID", id]]);
   If[Cases[shiftedRules, _Missing, Infinity] =!= {},
    Return[<|"status" -> "invalidActiveBasis", "reason" -> "integralMapShiftFailed"|>]
    ];
   shiftedEquations = reindexLinearEquation[#, idShift] & /@ Lookup[linearData, "linearEquations", {}];
   integralIndex = Association[shiftedRules];
   relationIDs = Range[count];
   activeIDs = relationIDs[[activeIndices]];
   auxiliaryIDs = Complement[relationIDs, activeIDs];
   basisEquations = MapThread[
     dsKiraLinearizeActiveBasisExpression,
     {expressions, relationIDs, ConstantArray[integralIndex, count], names}
     ];
   badEquations = Select[basisEquations, ! TrueQ[Lookup[#, "linearQ", False]] &];
   If[badEquations =!= {},
    Return[<|"status" -> "invalidActiveBasis", "reason" -> "basisExpressionsMustBeHomogeneousLinearCombinationsOfMappedJ", "badBasisEquations" -> badEquations|>]
    ];
   rawDerivatives = Table[
     dsSectorAwareDerivative[
      activeExpressions[[i]],
      variables[[j]],
      <|"topology" -> topo, "sectors" -> Lookup[linearData, "sectorMetadataList", {}]|>
      ],
     {i, activeCount}, {j, Length[variables]}
     ];
   If[! FreeQ[rawDerivatives, $Failed],
    Return[<|"status" -> "invalidActiveBasis", "reason" -> "basisDerivativeFailed", "derivativeVariables" -> variables|>]
    ];
   derivativeIntegrals = DeleteDuplicates[Cases[rawDerivatives, _J, Infinity]];
   missingDerivativeIntegrals = Select[derivativeIntegrals, ! KeyExistsQ[integralIndex, #] &];
   If[missingDerivativeIntegrals =!= {},
    Return[<|"status" -> "invalidActiveBasis", "reason" -> "derivativeTargetOutsideLinearSystem", "missingDerivativeIntegrals" -> missingDerivativeIntegrals, "derivativeVariables" -> variables|>]
    ];
   derivativeTargetIDs = Lookup[integralIndex, derivativeIntegrals, {}];
   targetIDs = DeleteDuplicates[Join[activeIDs, derivativeTargetIDs]];
   activeData = <|
     "status" -> "configured",
     "count" -> count,
     "relationCount" -> count,
     "activeCount" -> activeCount,
     "names" -> names,
     "expressions" -> expressions,
     "ids" -> relationIDs,
     "tokens" -> (Tuserweight /@ relationIDs),
     "activeIndices" -> activeIndices,
     "activeNames" -> activeNames,
     "activeExpressions" -> activeExpressions,
     "activeIDs" -> activeIDs,
     "activeTokens" -> (Tuserweight /@ activeIDs),
     "auxiliaryIDs" -> auxiliaryIDs,
     "equationConvention" -> "Tuserweight[id] == expressions[[i]]",
     "derivativeVariables" -> variables,
     "rawDerivatives" -> rawDerivatives,
     "derivativeTargetIntegrals" -> derivativeIntegrals,
     "derivativeTargetIDs" -> derivativeTargetIDs,
     "targetIntegralIDs" -> targetIDs,
     "scalingDegrees" -> degrees,
     "sourceIntegralCount" -> oldCount
     |>;
   Join[linearData, <|
     "integralRules" -> shiftedRules,
     "integralCount" -> oldCount + count,
     "equationCount" -> Lookup[linearData, "equationCount", Length[shiftedEquations]] + count,
     "linearEquations" -> Join[basisEquations, shiftedEquations],
     "activeBasis" -> activeData
     |>]
   ];

dsKiraAttachActiveBasis[_Association, setting_] := <|"status" -> "invalidActiveBasis", "reason" -> "KiraActiveBasisMustBeNoneAutomaticOrAssociation", "activeBasisInput" -> setting|>;

dsKiraShiftExplicitTargetItem[item_Integer, activeData_Association] := Module[{oldCount, offset},
   oldCount = Lookup[activeData, "sourceIntegralCount", 0];
   offset = Lookup[activeData, "count", 0];
   If[1 <= item <= oldCount, item + offset, item]
   ];
dsKiraShiftExplicitTargetItem[item_, _Association] := item;

dsKiraEffectiveTargets[linearData_Association, targetSpec_] := Module[{activeData, activeIDs, shifted},
   activeData = Lookup[linearData, "activeBasis", <|"status" -> "disabled"|>];
   If[Lookup[activeData, "status", "disabled"] =!= "configured", Return[targetSpec]];
   activeIDs = activeData["activeIDs"];
   Which[
    targetSpec === Automatic, activeData["targetIntegralIDs"],
    targetSpec === All, All,
    ListQ[targetSpec], shifted = dsKiraShiftExplicitTargetItem[#, activeData] & /@ targetSpec; DeleteDuplicates[Join[activeIDs, shifted]],
    True, DeleteDuplicates[Append[activeIDs, dsKiraShiftExplicitTargetItem[targetSpec, activeData]]]
    ]
   ];

dsStableTadpoleSymmetryData[data_Association] := KeyDrop[data, {"automaticRules"}];
dsStableTadpoleSymmetryData[_] := <||>;

dsKiraExportManifest[exportData_Association, linearData_Association] := <|
   "status" -> "exported",
   "packageVersion" -> $dSIBPVersion,
   "caseName" -> Lookup[linearData, "caseName", Missing["caseName"]],
   "context" -> Lookup[linearData, "dSIBPContextSummary", <||>],
   "equationCount" -> Lookup[exportData, "exportedEquationCount", Missing["equationCount"]],
   "integralCount" -> Lookup[exportData, "integralCount", Missing["integralCount"]],
   "targetIntegralIDs" -> Lookup[exportData, "targetIntegralIDs", {}],
   "numericDummyIntegralId" -> Lookup[exportData, "numericDummyIntegralId", None],
   "numericDummySymbol" -> Lookup[Lookup[exportData, "kiraInput", <||>], "numericDummySymbol", Missing["numericDummySymbol"]],
   "coefficientVariables" -> Lookup[exportData, "coefficientVariables", {}],
   "coefficientAlgebraicGenerators" -> Lookup[exportData, "coefficientAlgebraicGenerators", {}],
   "coefficientVariableMap" -> Lookup[exportData, "coefficientVariableMap", {}],
   "backendCoefficientVariables" -> Lookup[exportData, "backendCoefficientVariables", {}],
   "backendImaginaryUnit" -> Lookup[exportData, "backendImaginaryUnit", None],
   "backendCoefficientSyntaxReport" -> Lookup[exportData, "backendCoefficientSyntaxReport", <||>],
   "integralList" -> Lookup[linearData, "integralList", {}],
   "integralRules" -> Lookup[linearData, "integralRules", {}],
   "kiraOrdering" -> Lookup[linearData, "kiraOrdering", <||>],
   "activeBasis" -> Lookup[linearData, "activeBasis", <|"status" -> "disabled", "count" -> 0|>],
   "numericRulesAppliedBeforeSeeds" -> TrueQ[Lookup[linearData, "numericRulesAppliedBeforeSeeds", False]],
   "numericRules" -> Lookup[Lookup[linearData, "topology", <||>], "numericRules", {}],
   "userNumericRules" -> userNumericRules[Lookup[linearData, "topology", <||>]],
   "seedNumericRules" -> Lookup[linearData, "seedNumericRules", {}],
   "coefficientRulesApplied" -> Lookup[linearData, "coefficientRulesApplied", {}],
   "userCoefficientRulesApplied" -> Lookup[linearData, "userCoefficientRulesApplied", {}],
   "zeroPointRules" -> Lookup[Lookup[linearData, "topology", <||>], "zeroPointRules", {}],
   "symmetryRules" -> Lookup[Lookup[linearData, "topology", <||>], "symmetryRules", {}],
   "tadpoleSymmetryData" -> dsStableTadpoleSymmetryData[Lookup[linearData, "tadpoleSymmetryData", <||>]],
   "loopTreeProjectionConvention" -> Lookup[Lookup[linearData, "dSIBPContextSummary", <||>], "loopTreeProjectionConvention", <||>]
   |>;

DSKiraExport[linearData_Association, opts : OptionsPattern[]] := Module[
   {orderedLinearData, preparedLinearData, activeSetting = OptionValue[KiraActiveBasis], effectiveTargets,
    makeOptions, exportData, manifest, outputDirectory = OptionValue[OutputDirectory], manifestPath,
    progress = OptionValue[ProgressReporting], integralOrder = OptionValue[KiraIntegralOrder]},
   If[! KeyExistsQ[linearData, "linearEquations"],
    Message[DSKiraExport::badlinear]; dsErrorPrint["输入缺少 linearEquations。"]; Return[<|"status" -> "failed", "reason" -> "notLinearData"|>]
    ];
   If[Lookup[validateKiraIntegralOrderSpec[integralOrder], "status", "invalid"] =!= "ok",
    Message[DSKiraExport::badlinear]; Return[<|"status" -> "failed", "reason" -> "invalidKiraIntegralOrder"|>]
    ];
   orderedLinearData = If[ListQ[integralOrder], reorderLinearSystemIntegrals[linearData, integralOrder], linearData];
   preparedLinearData = dsKiraAttachActiveBasis[orderedLinearData, activeSetting];
   If[Lookup[preparedLinearData, "status", "missing"] =!= "generated",
    Message[DSKiraExport::badbasis, Lookup[preparedLinearData, "reason", "unknown"]];
    dsErrorPrint["active basis 或其导数 target closure 未通过导出门禁。"]; Return[preparedLinearData]
    ];
   effectiveTargets = dsKiraEffectiveTargets[preparedLinearData, OptionValue[KiraTargetIntegrals]];
   makeOptions = DeleteCases[
     FilterRules[{opts}, Options[makeKiraExportData]],
     HoldPattern[(KiraIntegralOrder | KiraTargetIntegrals) -> _]
     ];
   exportData = dsStageRun[
     "序列化 Kira 基础输入",
     makeKiraExportData[
      preparedLinearData,
      Sequence @@ makeOptions,
      KiraIntegralOrder -> Automatic,
      KiraTargetIntegrals -> effectiveTargets
      ],
     progress
     ];
   If[Lookup[exportData, "status", "missing"] =!= "ready",
    Message[DSKiraExport::failed, Lookup[exportData, "reason", Lookup[exportData, "status", Missing["status"]]]];
    dsErrorPrint["package 未运行 Kira；当前只报告导出门禁失败。"]; Return[exportData]
    ];
   manifest = dsKiraExportManifest[exportData, Lookup[exportData, "linearSystem", preparedLinearData]];
   If[StringQ[outputDirectory],
    manifestPath = FileNameJoin[{outputDirectory, "dsibp-export-manifest.wl"}];
    Quiet[Check[Put[manifest, manifestPath], manifestPath = $Failed]],
    manifestPath = Missing["NotWritten"]
    ];
   Join[exportData, <|"dSIBPExportManifest" -> manifest, "dSIBPExportManifestPath" -> manifestPath|>]
   ];

(* ::Package:: *)

(* ::Chapter:: *)
(*014 Kira 结果取回*)

Options[DSKiraImport] = {
   KiraReductionFile -> Automatic,
   KiraMasterFile -> Automatic,
   KiraCompletionFile -> Automatic,
   KiraCompletionPatterns -> Automatic,
   ProgressReporting -> Automatic
   };

DSKiraImport::badpath = "Kira workspace 路径不存在或不是目录：`1`。";
DSKiraImport::missing = "Kira 结果缺少必需文件：`1`。";
DSKiraImport::incomplete = "Kira 完成日志没有成功标记：`1`。";
DSKiraImport::mismatch = "Kira 结果与当前 export/context 不一致：`1`。";
DSKiraImport::invalid = "Kira reduction 数据未通过完整性检查：`1`。";

dsKiraResolveFile[root_String, Automatic, relative : {__String}] := FileNameJoin[Prepend[relative, root]];
dsKiraResolveFile[root_String, Automatic, relatives : {__List}] := Module[{paths},
   paths = FileNameJoin[Prepend[#, root]] & /@ relatives;
   SelectFirst[paths, FileExistsQ, First[paths]]
   ];
dsKiraResolveFile[root_String, path_String, _List] := ExpandFileName[If[dsAbsolutePathQ[path], path, FileNameJoin[{root, path}]]];
dsKiraResolveFile[_String, _, _List] := $Failed;

dsKiraCompletionPatterns[Automatic] := {
   RegularExpression["(?i)kira[^\\n]*(?:finished|completed)[^\\n]*(?:success|successfully)"],
   RegularExpression["(?i)all jobs[^\\n]*(?:finished|completed)[^\\n]*(?:success|successfully)"],
   RegularExpression["(?i)unreduced integrals:\\s*0\\.?"],
   "Kira finished successfully"
   };
dsKiraCompletionPatterns[patterns_List] := patterns;
dsKiraCompletionPatterns[pattern_] := {pattern};

dsKiraCompletionQ[text_String, patterns_] := AnyTrue[
   dsKiraCompletionPatterns[patterns],
   Function[pattern, StringContainsQ[text, pattern] || StringMatchQ[text, ___ ~~ pattern ~~ ___]]
   ];

dsKiraReadExpression[path_String] := Quiet[Check[Get[path], $Failed]];

dsKiraMasterIDs[text_String] := DeleteDuplicates @ ToExpression @ StringCases[
   text,
   StartOfLine ~~ WhitespaceCharacter ... ~~ id : NumberString ~~ WhitespaceCharacter ... ~~ "#" :> id
   ];

dsRuleListQ[rules_] := ListQ[rules] && And @@ (MatchQ[Unevaluated[#], _Rule | _RuleDelayed] & /@ rules);

dsJToIDPairs[rules_List] := Cases[rules, HoldPattern[integral_J -> id_Integer] :> {integral, id}];
dsIDToJPairs[rules_List] := Cases[rules, HoldPattern[Tuserweight[id_Integer] -> integral_J] :> {id, integral}];

(* 双向文本相等还不够：同步重复的积分或 ID 也会相等，但并不是可逆编号。 *)
dsKiraInverseMapQ[jToKira_List, kiraToJ_List] := Module[{forward, backward},
   forward = SortBy[dsJToIDPairs[jToKira], Last];
   backward = SortBy[Reverse /@ dsIDToJPairs[kiraToJ], Last];
   forward === backward &&
    Length[forward] === Length[jToKira] && Length[backward] === Length[kiraToJ] &&
    DuplicateFreeQ[First /@ forward] && DuplicateFreeQ[Last /@ forward]
   ];

dsKiraRuleIDs[rules_List] := <|
   "lhs" -> DeleteDuplicates @ Cases[rules, HoldPattern[Tuserweight[id_Integer] -> _] :> id],
   "rhs" -> DeleteDuplicates @ Cases[Last /@ rules, Tuserweight[id_Integer] :> id, Infinity],
   "all" -> DeleteDuplicates @ Cases[rules, Tuserweight[id_Integer] :> id, Infinity]
   |>;

dsKiraCoefficientVariables[rules_List] := Module[{rhs},
   rhs = Last /@ rules /. Tuserweight[_Integer] -> 1;
   DeleteDuplicates[Variables[Together /@ rhs]]
   ];

dsKiraBackendVariableNames[rules_List] := DeleteDuplicates[
   SymbolName /@ Select[dsKiraCoefficientVariables[rules], Head[#] === Symbol &]
   ];

dsKiraBackendRestoreRules[variableMap_List, imaginaryUnit_] := Join[
   Map[
    Function[item,
     With[{name = Lookup[item, "backend"], original = Lookup[item, "original"]},
      HoldPattern[s_Symbol /; SymbolName[s] === name] :> original
      ]
     ],
    variableMap
    ],
   If[StringQ[imaginaryUnit],
    {With[{name = imaginaryUnit}, HoldPattern[s_Symbol /; SymbolName[s] === name] :> I]},
    {}
    ]
   ];

dsKiraRestoreBackendCoefficients[rules_List, variableMap_List, imaginaryUnit_] :=
   rules /. dsKiraBackendRestoreRules[variableMap, imaginaryUnit];

dsKiraContextMatchQ[manifest_Association, context_Association] := And[
   Lookup[manifest, "packageVersion", Missing["packageVersion"]] === Lookup[context, "packageVersion", Missing["contextVersion"]],
   Lookup[Lookup[manifest, "context", <||>], "inputHash", Missing["inputHash"]] === Lookup[context, "inputHash", Missing["contextHash"]],
   Lookup[manifest, "zeroPointRules", Missing["zeroPointRules"]] === Lookup[context["topology"], "zeroPointRules", Missing["contextZeroPointRules"]],
   Lookup[manifest, "symmetryRules", Missing["symmetryRules"]] === Lookup[context["topology"], "symmetryRules", Missing["contextSymmetryRules"]],
   Lookup[manifest, "tadpoleSymmetryData", Missing["tadpoleSymmetryData"]] === dsStableTadpoleSymmetryData[Lookup[context["topology"], "tadpoleSymmetryData", tadpoleSymmetryData[context["topology"]]]],
   Lookup[manifest, "loopTreeProjectionConvention", Missing["projectionConvention"]] === Lookup[context, "loopTreeProjectionConvention", Missing["contextProjectionConvention"]]
   ];


(* ::Section::Closed:: *)
(*Active basis manifest 门禁*)

dsKiraActiveBasisData[manifest_Association] := Lookup[manifest, "activeBasis", <|"status" -> "disabled", "count" -> 0|>];

dsKiraActiveBasisDataQ[data_Association] := Module[
   {status, count, activeCount, names, expressions, ids, tokens, activeIndices, activeNames,
    activeExpressions, activeIDs, activeTokens, auxiliaryIDs, variables, targetIDs},
   status = Lookup[data, "status", "disabled"];
   If[status === "disabled", Return[True]];
   count = Lookup[data, "count", -1];
   activeCount = Lookup[data, "activeCount", -1];
   names = Lookup[data, "names", {}];
   expressions = Lookup[data, "expressions", {}];
   ids = Lookup[data, "ids", {}];
   tokens = Lookup[data, "tokens", {}];
   activeIndices = Lookup[data, "activeIndices", {}];
   activeNames = Lookup[data, "activeNames", {}];
   activeExpressions = Lookup[data, "activeExpressions", {}];
   activeIDs = Lookup[data, "activeIDs", {}];
   activeTokens = Lookup[data, "activeTokens", {}];
   auxiliaryIDs = Lookup[data, "auxiliaryIDs", {}];
   variables = Lookup[data, "derivativeVariables", {}];
   targetIDs = Lookup[data, "targetIntegralIDs", {}];
   status === "configured" && IntegerQ[count] && count > 0 && IntegerQ[activeCount] && activeCount > 0 &&
    Length[names] === count && Length[expressions] === count && Length[ids] === count && Length[tokens] === count &&
    And @@ (StringQ[#] && # =!= "" & /@ names) && DuplicateFreeQ[names] &&
    ids === Range[count] && tokens === (Tuserweight /@ ids) &&
    Length[activeIndices] === activeCount && DuplicateFreeQ[activeIndices] &&
    And @@ (IntegerQ[#] && 1 <= # <= count & /@ activeIndices) &&
    activeIDs === ids[[activeIndices]] && activeNames === names[[activeIndices]] &&
    activeExpressions === expressions[[activeIndices]] && activeTokens === (Tuserweight /@ activeIDs) &&
    auxiliaryIDs === Complement[ids, activeIDs] && variables =!= {} &&
    DuplicateFreeQ[targetIDs] && Complement[activeIDs, targetIDs] === {}
   ];

dsKiraBackendMasterObject[id_Integer, activeIDs_List, idToJ_Association] := If[
   MemberQ[activeIDs, id],
   Tuserweight[id],
   Lookup[idToJ, id, Missing["unrecognizedBackendMasterID", id]]
   ];

DSKiraImport[root_String, context_: Automatic, OptionsPattern[]] := Module[
   {resolved, workspace, files, missingFiles, manifest, repJ2Kira, repKira2J, reductionRulesBackend, reductionRulesRaw, masterText,
    completionText, completionQ, mapQ, manifestMapQ, contextQ, masterIDs, mapPairs, idToJ, mapIDs,
    dummyID, targetIDs, ruleIDs, completeTargetsQ, rhsMastersQ, coefficientVariables, allowedCoefficientVariables,
    coefficientQ, coefficientVariableMap, backendImaginaryUnit, backendVariableNames, allowedBackendVariableNames,
    backendCoefficientQ, activeData, activeDataQ, activeQ, relationIDs, activeIDs, auxiliaryIDs, activeExpressions, activeTokens,
    activeMasterOrderQ, auxiliaryNotMastersQ, recognizedIDs, backendMasters, boundaryMasterIDs, boundaryMasters,
    checks, issues, reductionRules, masters, masterTokens, returnedMasterIDs, progress = OptionValue[ProgressReporting]},
   resolved = dsResolveContext[context];
   If[Head[resolved] === Missing,
    Message[DSKiraImport::mismatch, "missing DSInit context"]; dsErrorPrint["Kira import 需要同源 DSInit context。"]; Return[<|"status" -> "failed", "reason" -> "missingContext"|>]
    ];
   workspace = ExpandFileName[root];
   If[! DirectoryQ[workspace],
    Message[DSKiraImport::badpath, workspace]; dsErrorPrint["Kira workspace 不存在。"]; Return[<|"status" -> "failed", "reason" -> "invalidWorkspace", "workspace" -> workspace|>]
    ];
   files = <|
     "manifest" -> FileNameJoin[{workspace, "dsibp-export-manifest.wl"}],
     "repJ2Kira" -> FileNameJoin[{workspace, "result", "repJ2kira.m"}],
     "repKira2J" -> FileNameJoin[{workspace, "result", "repkira2J.m"}],
     "reduction" -> dsKiraResolveFile[workspace, OptionValue[KiraReductionFile], {
        {"results", "Tuserweight", "kira_list.m"},
        {"results", "kira_list.m"}
        }],
     "masters" -> dsKiraResolveFile[workspace, OptionValue[KiraMasterFile], {
        {"results", "Tuserweight", "masters"},
        {"results", "masters"}
        }],
     "completion" -> dsKiraResolveFile[workspace, OptionValue[KiraCompletionFile], {"kira.log"}]
     |>;
   missingFiles = Select[Normal[files], ! StringQ[Last[#]] || ! FileExistsQ[Last[#]] &];
   If[missingFiles =!= {},
    Message[DSKiraImport::missing, missingFiles]; dsErrorPrint["完整 Kira 结果文件不足，未导入。"]; Return[<|"status" -> "failed", "reason" -> "missingFiles", "workspace" -> workspace, "files" -> files, "missingFiles" -> missingFiles|>]
    ];
   {manifest, repJ2Kira, repKira2J, reductionRulesBackend} = dsStageRun[
     "读取 Kira manifest、映射与 reduction",
     dsKiraReadExpression /@ Lookup[files, {"manifest", "repJ2Kira", "repKira2J", "reduction"}],
     progress
     ];
   masterText = Import[files["masters"], "Text"];
   completionText = Import[files["completion"], "Text"];
   completionQ = StringQ[completionText] && dsKiraCompletionQ[completionText, OptionValue[KiraCompletionPatterns]];
   If[! TrueQ[completionQ],
    Message[DSKiraImport::incomplete, files["completion"]]; dsErrorPrint["Kira 日志未确认成功完成。"]; Return[<|"status" -> "failed", "reason" -> "completionMarkerMissing", "workspace" -> workspace, "files" -> files|>]
    ];
   If[! AssociationQ[manifest] || ! dsRuleListQ[repJ2Kira] || ! dsRuleListQ[repKira2J] || ! dsRuleListQ[reductionRulesBackend],
    Message[DSKiraImport::invalid, "malformed manifest/map/reduction expression"]; dsErrorPrint["Kira 文件不是预期的 Wolfram 表达式。"]; Return[<|"status" -> "failed", "reason" -> "malformedExpressions", "workspace" -> workspace|>]
    ];
   coefficientVariableMap = Lookup[manifest, "coefficientVariableMap", {}];
   backendImaginaryUnit = Lookup[manifest, "backendImaginaryUnit", None];
   reductionRulesRaw = dsKiraRestoreBackendCoefficients[
     reductionRulesBackend,
     coefficientVariableMap,
     backendImaginaryUnit
     ];
   mapQ = dsKiraInverseMapQ[repJ2Kira, repKira2J];
   manifestMapQ = SortBy[dsJToIDPairs[Lookup[manifest, "integralRules", {}]], Last] === SortBy[dsJToIDPairs[repJ2Kira], Last];
   contextQ = dsKiraContextMatchQ[manifest, resolved];
   masterIDs = dsKiraMasterIDs[masterText];
   mapPairs = dsIDToJPairs[repKira2J];
   idToJ = Association[Rule @@@ mapPairs];
   mapIDs = Keys[idToJ];
   activeData = dsKiraActiveBasisData[manifest];
   activeDataQ = AssociationQ[activeData] && dsKiraActiveBasisDataQ[activeData];
   activeQ = TrueQ[activeDataQ] && Lookup[activeData, "status", "disabled"] === "configured";
   relationIDs = If[activeQ, Lookup[activeData, "ids", {}], {}];
   activeIDs = If[activeQ, Lookup[activeData, "activeIDs", {}], {}];
   auxiliaryIDs = If[activeQ, Lookup[activeData, "auxiliaryIDs", {}], {}];
   activeExpressions = If[activeQ, Lookup[activeData, "activeExpressions", {}], {}];
   activeTokens = If[activeQ, Lookup[activeData, "activeTokens", {}], {}];
   activeMasterOrderQ = ! activeQ || Select[masterIDs, MemberQ[activeIDs, #] &] === activeIDs;
   auxiliaryNotMastersQ = ! activeQ || Intersection[auxiliaryIDs, masterIDs] === {};
   recognizedIDs = Join[mapIDs, relationIDs];
   dummyID = Lookup[manifest, "numericDummyIntegralId", None];
   targetIDs = DeleteCases[Lookup[manifest, "targetIntegralIDs", mapIDs], dummyID];
   ruleIDs = dsKiraRuleIDs[reductionRulesBackend];
   completeTargetsQ = Complement[targetIDs, Union[ruleIDs["lhs"], masterIDs]] === {};
   rhsMastersQ = Complement[ruleIDs["rhs"], masterIDs] === {};
   coefficientVariables = dsKiraCoefficientVariables[reductionRulesRaw];
   allowedCoefficientVariables = Lookup[manifest, "coefficientVariables", {}];
   coefficientQ = Complement[coefficientVariables, allowedCoefficientVariables] === {};
   backendVariableNames = dsKiraBackendVariableNames[reductionRulesBackend];
   allowedBackendVariableNames = Lookup[manifest, "backendCoefficientVariables", {}];
   backendCoefficientQ = If[coefficientVariableMap === {} && allowedBackendVariableNames === {},
     True,
     Complement[backendVariableNames, allowedBackendVariableNames] === {}
     ];
   checks = <|
     "completionMarker" -> completionQ,
     "inverseIntegralMaps" -> mapQ,
     "manifestIntegralMap" -> manifestMapQ,
     "contextConventionMatch" -> contextQ,
     "activeBasisManifest" -> activeDataQ,
     "nonemptyMasterOrder" -> (masterIDs =!= {}),
     "masterIDsRecognized" -> (Complement[masterIDs, recognizedIDs] === {}),
     "activeBasisIDsAreMasters" -> (! activeQ || Complement[activeIDs, masterIDs] === {}),
     "activeBasisMasterOrder" -> activeMasterOrderQ,
     "auxiliaryBasisIDsNotMasters" -> auxiliaryNotMastersQ,
     "allReductionIDsRecognized" -> (Complement[ruleIDs["all"], Append[recognizedIDs, dummyID]] === {}),
     "completeTargetCoverage" -> completeTargetsQ,
     "rhsContainsOnlyMasters" -> rhsMastersQ,
     "backendCoefficientVariablesRecognized" -> backendCoefficientQ,
     "coefficientVariablesRecognized" -> coefficientQ
     |>;
   issues = Keys @ Select[checks, ! TrueQ[#] &];
   If[issues =!= {},
    Message[DSKiraImport::mismatch, issues]; dsErrorPrint["Kira 结果未通过同源性/完整性门禁。"]; Return[<|"status" -> "failed", "reason" -> "validationFailed", "workspace" -> workspace, "files" -> files, "validationReport" -> <|"checks" -> checks, "issues" -> issues|>|>]
    ];
   backendMasters = dsKiraBackendMasterObject[#, relationIDs, idToJ] & /@ masterIDs;
   boundaryMasterIDs = Complement[masterIDs, relationIDs];
   boundaryMasters = Lookup[idToJ, boundaryMasterIDs, {}];
   masters = If[activeQ, activeExpressions, backendMasters];
   masterTokens = If[activeQ, activeTokens, masters];
   returnedMasterIDs = If[activeQ, activeIDs, masterIDs];
   reductionRules = reductionRulesRaw /. Normal[Association[repKira2J]];
   <|
    "status" -> "imported",
    "workspace" -> workspace,
    "files" -> files,
    "reductionRules" -> reductionRules,
    "backendReductionRules" -> reductionRulesBackend,
    "masters" -> masters,
    "masterTokens" -> masterTokens,
    "masterIDs" -> returnedMasterIDs,
    "backendMasters" -> backendMasters,
    "backendMasterIDs" -> masterIDs,
    "boundaryMasters" -> boundaryMasters,
    "boundaryMasterIDs" -> boundaryMasterIDs,
    "activeBasis" -> activeData,
    "integralMap" -> <|"JToKira" -> repJ2Kira, "KiraToJ" -> repKira2J|>,
    "coefficientVariables" -> coefficientVariables,
    "backendCoefficientVariables" -> backendVariableNames,
    "coefficientVariableMap" -> coefficientVariableMap,
    "sourceManifest" -> manifest,
    "context" -> resolved,
    "validationReport" -> <|"status" -> "passed", "checks" -> checks, "issues" -> {}|>
    |>
   ];

DSKiraImport[root_, context_: Automatic, OptionsPattern[]] := (Message[DSKiraImport::badpath, root]; dsErrorPrint["DSKiraImport 的第一个参数必须是目录字符串。"]; <|"status" -> "failed", "reason" -> "workspaceNotString"|>);

(* ::Package:: *)

(* ::Chapter:: *)
(*015 微分方程构造*)

(* DSDE 只消费经 KiraImport 验证的 reduction data；不会从不完整日志猜测 master 或规则。 *)

Options[DSDE] = {
   MaxReductionIterations -> 100,
   OutputDirectory -> None,
   ProgressReporting -> Automatic
   };

DSDE::badreduction = "DSDE 只接受 DSKiraImport 验证通过的 reductionData。";
DSDE::badvars = "微分变量必须是当前 family 初始化的外部独立变量：`1`。";
DSDE::baditer = "MaxReductionIterations 必须是正整数，收到 `1`。";
DSDE::writefailed = "DE 结果写入失败：`1`。";

dsDEResolveVariables[Automatic, context_Association] := scalarProductInternalToUser[#, context["topology"]] & /@
   independentVariableDerivativeVariables[context["topology"]];
dsDEResolveVariables[variable_List, _Association] := variable;
dsDEResolveVariables[variable_, _Association] := {variable};

dsSectorTopologyForIntegral[int_J, context_Association] := Module[{metadata, matches, shrunk},
   metadata = context["sectors"];
   matches = Select[metadata, integralMatchesSectorMetadataQ[int, #] &];
   If[Length[matches] =!= 1, Return[$Failed]];
   shrunk = Lookup[First[matches], "sectorShrunkLines", {}];
   If[shrunk === {}, context["topology"], shrinkSectorTopology[context["topology"], shrunk]]
   ];

dsReduceExpression[expr_, rules_List, maxIterations_Integer] := FixedPoint[ReplaceAll[#, rules] &, Expand[expr], maxIterations];

(* Kira 关系可以使用内部 kk/ISP 坐标；公开 DE 必须只含 family 声明的外部不变量。 *)
dsDEReducedExpressionToUser[expr_, context_Association] := Module[{topo = context["topology"]},
   Expand[scalarProductInternalToUser[expr /. internalISPToUserRules[topo], topo]]
   ];

dsDEMasterDecomposition[expr_, masterTokens_List] := Module[
   {coefficientTokens, tokenExpr, coefficients, source, residualIntegrals, residualBackendTokens, residualObjects},
   coefficientTokens = Array[Unique["dsMaster$"] &, Length[masterTokens]];
   tokenExpr = expr /. Thread[masterTokens -> coefficientTokens];
   coefficients = Coefficient[tokenExpr, #] & /@ coefficientTokens;
   source = Expand[tokenExpr - coefficients.coefficientTokens];
   residualIntegrals = DeleteDuplicates[Cases[source, _J, Infinity]];
   residualBackendTokens = DeleteDuplicates[Cases[source, Tuserweight[_Integer], Infinity]];
   residualObjects = Join[residualIntegrals, residualBackendTokens];
   <|
    "coefficients" -> coefficients,
    "source" -> source,
    "residualIntegrals" -> residualIntegrals,
    "residualBackendTokens" -> residualBackendTokens,
    "residualObjects" -> residualObjects,
    "closedQ" -> (residualObjects === {})
    |>
   ];

(* active basis 可同时含 top 与 residual-sector J；逐项选择 sector topology，并显式保留系数导数。 *)
dsSectorAwareDerivative[expr_, variable_, context_Association] := Module[
   {linearData, coefficientDerivative, integralDerivativeTerms},
   linearData = publicLinearIntegralDecomposition[expr];
   If[Lookup[linearData, "status", "failed"] =!= "linear", Return[$Failed]];
   coefficientDerivative = Expand[D[linearData["heldExpression"], variable] /. linearData["backwardRules"]];
   integralDerivativeTerms = MapThread[
     Function[{coefficient, int},
      With[{sectorTopology = dsSectorTopologyForIntegral[int, context]},
       If[sectorTopology === $Failed, $Failed, coefficient ds[int, variable, sectorTopology]]
       ]
      ],
     {linearData["coefficients"], linearData["integrals"]}
     ];
   If[! FreeQ[integralDerivativeTerms, $Failed], $Failed, Expand[coefficientDerivative + Total[integralDerivativeTerms]]]
   ];

dsDEVariableData[variable_, masterDefinitions_List, masterTokens_List, rules_List, parameterRules_List, context_Association, maxIterations_Integer, progress_] := Module[
   {raw, reduced, decompositions},
   raw = dsProgressMap[
     "正在构造 " <> ToString[variable, InputForm] <> " 导数",
     masterDefinitions,
     Function[master, dsSectorAwareDerivative[master, variable, context] /. parameterRules],
     progress
     ];
   If[MemberQ[raw, $Failed], Return[<|"status" -> "failed", "variable" -> variable, "reason" -> "dsFailed", "rawDerivatives" -> raw|>]];
   reduced = dsProgressMap[
     "正在约化 " <> ToString[variable, InputForm] <> " 导数",
     raw,
     Function[expr, dsReduceExpression[expr, rules, maxIterations]],
     progress
     ];
   reduced = dsDEReducedExpressionToUser[#, context] & /@ reduced;
   decompositions = dsDEMasterDecomposition[#, masterTokens] & /@ reduced;
   <|
    "status" -> If[And @@ Lookup[decompositions, "closedQ", False], "generated", "notClosed"],
    "variable" -> variable,
    "matrix" -> Lookup[decompositions, "coefficients", {}],
    "source" -> Lookup[decompositions, "source", {}],
    "rawDerivatives" -> raw,
    "reducedDerivatives" -> reduced,
    "residualIntegrals" -> DeleteDuplicates[Flatten[Lookup[decompositions, "residualIntegrals", {}]]],
    "residualBackendTokens" -> DeleteDuplicates[Flatten[Lookup[decompositions, "residualBackendTokens", {}]]],
    "residualObjects" -> DeleteDuplicates[Flatten[Lookup[decompositions, "residualObjects", {}]]]
    |>
   ];

dsWriteDEResult[data_Association, directory_String] := Module[{paths, compact},
   Quiet[CreateDirectory[directory, CreateIntermediateDirectories -> True]];
   paths = <|
     "masters" -> FileNameJoin[{directory, "masters.wl"}],
     "de" -> FileNameJoin[{directory, "de.wl"}],
     "manifest" -> FileNameJoin[{directory, "manifest.wl"}]
     |>;
   compact = KeyDrop[data, {"variableData", "context"}];
   If[Quiet[Check[
       Put[data["masters"], paths["masters"]];
       Put[KeyTake[data, {"status", "variables", "matrices", "sources", "residualIntegrals", "equationConvention"}], paths["de"]];
       Put[Join[compact, <|"files" -> AssociationMap[FileNameTake, paths]|>], paths["manifest"]];
       True,
       False
       ]],
    <|"status" -> "written", "directory" -> directory, "files" -> paths|>,
    <|"status" -> "failed", "directory" -> directory|>
    ]
   ];

DSDE[reductionData_Association, variables_: Automatic, OptionsPattern[]] := Module[
   {context, masters, masterTokens, rules, resolvedVariables, allowedVariables, badVariables, maxIterations,
    parameterRules, variableRecords, variableData, status, result, outputDirectory = OptionValue[OutputDirectory], writeResult},
   If[Lookup[reductionData, "status", "missing"] =!= "imported" ||
     Lookup[Lookup[reductionData, "validationReport", <||>], "status", "missing"] =!= "passed",
    Message[DSDE::badreduction]; dsErrorPrint["reductionData 未经 DSKiraImport 完整验证。"]; Return[<|"status" -> "failed", "reason" -> "unvalidatedReductionData"|>]
    ];
   context = Lookup[reductionData, "context", Missing["context"]];
   If[! dsContextQ[context], Message[DSDE::badreduction]; Return[<|"status" -> "failed", "reason" -> "missingContext"|>]];
   masters = reductionData["masters"];
   masterTokens = Lookup[reductionData, "masterTokens", masters];
   If[! ListQ[masters] || ! ListQ[masterTokens] || Length[masters] =!= Length[masterTokens] || masters === {},
    Message[DSDE::badreduction]; Return[<|"status" -> "failed", "reason" -> "invalidMasterDefinitionsOrTokens"|>]
    ];
   rules = reductionData["reductionRules"];
   (* fixed-rational export 必须在 DE 原子求导层复用同一规则，否则 h EOM 会重新引入 nu 等固定参数。 *)
   parameterRules = If[
     TrueQ[Lookup[Lookup[reductionData, "sourceManifest", <||>], "numericRulesAppliedBeforeSeeds", False]],
     Lookup[context["topology"], "numericRules", {}],
     {}
     ];
   resolvedVariables = dsDEResolveVariables[variables, context];
   allowedVariables = dsDEResolveVariables[Automatic, context];
   badVariables = Complement[resolvedVariables, allowedVariables];
   If[badVariables =!= {},
    Message[DSDE::badvars, badVariables]; dsErrorPrint["DSDE 变量不属于当前 family 的外部表示。"]; Return[<|"status" -> "failed", "reason" -> "invalidVariables", "badVariables" -> badVariables, "allowedVariables" -> allowedVariables|>]
    ];
   maxIterations = OptionValue[MaxReductionIterations];
   If[! IntegerQ[maxIterations] || maxIterations <= 0,
    Message[DSDE::baditer, maxIterations]; dsErrorPrint["reduction 迭代上限无效。"]; Return[<|"status" -> "failed", "reason" -> "invalidMaxReductionIterations"|>]
    ];
   variableRecords = dsProgressMap[
     "正在生成微分方程",
     resolvedVariables,
     Function[variable, dsDEVariableData[variable, masters, masterTokens, rules, parameterRules, context, maxIterations, OptionValue[ProgressReporting]]],
     OptionValue[ProgressReporting]
     ];
   variableData = AssociationThread[resolvedVariables, variableRecords];
   status = Which[
     AnyTrue[variableRecords, Lookup[#, "status", "failed"] === "failed" &], "failed",
     AnyTrue[variableRecords, Lookup[#, "status", "notClosed"] === "notClosed" &], "notClosed",
     True, "generated"
     ];
   result = <|
     "status" -> status,
     "masters" -> masters,
     "masterTokens" -> masterTokens,
     "masterCount" -> Length[masters],
     "variables" -> resolvedVariables,
     "matrices" -> AssociationThread[resolvedVariables, Lookup[variableRecords, "matrix", {}]],
     "sources" -> AssociationThread[resolvedVariables, Lookup[variableRecords, "source", {}]],
     "residualIntegrals" -> AssociationThread[resolvedVariables, Lookup[variableRecords, "residualIntegrals", {}]],
     "residualBackendTokens" -> AssociationThread[resolvedVariables, Lookup[variableRecords, "residualBackendTokens", {}]],
     "residualObjects" -> AssociationThread[resolvedVariables, Lookup[variableRecords, "residualObjects", {}]],
     "variableData" -> variableData,
     "sourceManifest" -> reductionData["sourceManifest"],
     "activeBasis" -> Lookup[reductionData, "activeBasis", <|"status" -> "disabled", "count" -> 0|>],
     "parameterRulesApplied" -> If[parameterRules === {}, {}, userNumericRules[context["topology"]]],
     "context" -> context,
     "equationConvention" -> "D[masters,var] == matrices[var].masters + sources[var]",
     "reductionValidationReport" -> reductionData["validationReport"]
     |>;
   writeResult = If[StringQ[outputDirectory], dsWriteDEResult[result, ExpandFileName[outputDirectory]], <|"status" -> "notRequested"|>];
   If[Lookup[writeResult, "status", "failed"] === "failed", Message[DSDE::writefailed, outputDirectory]; dsErrorPrint["DE 文件未写出。"]];
   Join[result, <|"writeResult" -> writeResult|>]
   ];

DSDE[reductionData_, variables_: Automatic, OptionsPattern[]] := (Message[DSDE::badreduction]; dsErrorPrint["DSDE 输入必须是 reductionData Association。"]; <|"status" -> "failed", "reason" -> "inputNotAssociation"|>);


(* ::Chapter:: *)
(*Naive tree IBP 微分方程*)

(* 顶点相位导数继续由 loop 原子层生成后投影；treeEnergy 是树图的外部能量，不能误当成
   loop 适配器中的积分动量，必须由 h 的动量导数关系直接生成 tree 指标移位。
   sector master 的 normalization N 最后另按乘积法则求导。 *)

Options[DSTreeNaiveDE] = {ProgressReporting -> Automatic};

DSTreeNaiveDE::badibp = "DSTreeNaiveDE 需要 DSTreeNaiveIBP 成功返回的数据或合法 DSInit context。";
DSTreeNaiveDE::badvars = "tree 微分变量必须是当前 family 初始化的外部独立变量：`1`。";


dsTreeZeroTokenTerms[expr_] := If[TrueQ[Expand[expr] === 0], {}, dsTreeTokenTerms[expr]];


dsTreeLineEnergyDerivative[int_J, variable_, family_Association] := Module[
   {packs = First[int], terms = {}, vertex, leg, energyDerivative, state, newPacks, shiftedIntegral},
   Do[
    vertex = family["vertices"][[vertexIndex]];
    Do[
     leg = vertex["massiveLegs"][[legIndex]];
     energyDerivative = D[leg["energy"], variable];
     If[! TrueQ[energyDerivative === 0],
      state = packs[[vertexIndex, 1 + legIndex]];
      If[! MemberQ[{0, 1}, state], Return[$Failed]];
      newPacks = ReplacePart[packs, {vertexIndex, 1} -> packs[[vertexIndex, 1]] + 1];
      newPacks = ReplacePart[newPacks, {vertexIndex, 1 + legIndex} -> 1 - state];
      shiftedIntegral = J[newPacks];
      AppendTo[terms,
       energyDerivative If[
         state === 0,
         -dsTreeToken[family["sector"], shiftedIntegral],
         dsTreeToken[family["sector"], shiftedIntegral] -
          (2 leg["nu"] + 1)/leg["energy"] dsTreeToken[family["sector"], int]
         ]
       ]
      ],
     {legIndex, Length[vertex["massiveLegs"]]}
     ],
    {vertexIndex, Length[family["vertices"]]}
    ];
   Expand[Total[terms]]
   ];


dsTreePhaseDerivative[loopIntegral_J, variable_, family_Association, rootTopology_Association] := Module[
   {internalVariable, loopDerivative, projectedData, expression},
   internalVariable = scalarProductInputToInternal[variable, family["topology"]];
   loopDerivative = directVertexEnergyVariableDerivativeSeed[family["topology"], loopIntegral, internalVariable];
   If[TrueQ[Expand[loopDerivative] === 0],
    Return[<|"status" -> "generated", "loopDerivative" -> 0,
      "projectedData" -> <|"status" -> "generated", "terms" -> {}, "termCount" -> 0|>,
      "internalExpression" -> 0|>]
    ];
   projectedData = dsTreeLinearData[<|"loopSeed" -> loopDerivative|>, rootTopology, loopIntegral];
   If[Lookup[projectedData, "status", "failed"] =!= "generated",
    Return[<|"status" -> "failed", "reason" -> "phaseDerivativeProjectionFailed",
      "loopDerivative" -> loopDerivative, "projectedData" -> projectedData|>]
    ];
   expression = scalarProductInternalToUser[dsTreeTokenExpression[projectedData], rootTopology];
   <|"status" -> "generated", "loopDerivative" -> loopDerivative,
    "projectedData" -> projectedData, "internalExpression" -> expression|>
   ];


dsTreeNaiveAllowedVariables[context_Association, familyContext_Association] := DeleteDuplicates@Join[
   dsDEResolveVariables[Automatic, context],
   Variables[Cases[
     familyContext["families"],
     leg_Association /; KeyExistsQ[leg, "nu"] && KeyExistsQ[leg, "energy"] :> leg["energy"],
     Infinity
     ]]
   ];


dsTreeNaiveMasterDerivative[master_Association, variable_, familyContext_Association, context_Association] := Module[
   {family, rootTopology, loopIntegral, phaseData, lineDerivative, bareToken, bareDerivative,
    normalizedDerivative, publicTerms},
   family = dsTreeFamilyBySector[master["sectorKey"], familyContext];
   If[Head[family] === Missing, Return[<|"status" -> "failed", "reason" -> "unknownSector"|>]];
   rootTopology = context["topology"];
   loopIntegral = treeLoopIntegralFromTree[master["integral"], family];
   If[loopIntegral === $Failed, Return[<|"status" -> "failed", "reason" -> "treeLoopBackProjectionFailed"|>]];
   phaseData = dsTreePhaseDerivative[loopIntegral, variable, family, rootTopology];
   If[Lookup[phaseData, "status", "failed"] =!= "generated", Return[phaseData]];
   lineDerivative = dsTreeLineEnergyDerivative[master["integral"], variable, family];
   If[lineDerivative === $Failed, Return[<|"status" -> "failed", "reason" -> "lineEnergyDerivativeFailed"|>]];
   bareToken = dsTreeToken[master["sectorKey"], master["integral"]];
   bareDerivative = Expand[phaseData["internalExpression"] + lineDerivative];
   normalizedDerivative = Expand[
     D[master["coefficient"], variable] bareToken + master["coefficient"] bareDerivative
     ];
   publicTerms = dsTreeZeroTokenTerms[normalizedDerivative];
   <|
    "status" -> If[publicTerms === $Failed, "failed", "generated"],
    "master" -> master,
    "variable" -> variable,
    "loopRepresentative" -> loopIntegral,
    "loopPhaseDerivative" -> phaseData["loopDerivative"],
    "projectedPhaseDerivative" -> phaseData["projectedData"],
    "lineEnergyDerivativeTerms" -> dsTreeZeroTokenTerms[lineDerivative],
    "masterNormalizationDerivative" -> D[master["coefficient"], variable],
    "rawTerms" -> publicTerms,
    "internalExpression" -> normalizedDerivative
    |>
   ];


dsTreeNaiveVariableData[variable_, ibpData_Association, familyContext_Association, context_Association, progress_] := Module[
   {masters, derivativeRecords, rules, reduced, masterTokens, coefficientTokens, normalizedMasterRules,
    tokenExpressions, coefficients, residuals, residualTokens, rows},
   masters = ibpData["masters"];
   derivativeRecords = dsProgressMap[
     "正在构造 naive tree " <> ToString[variable, InputForm] <> " 导数",
     masters,
     Function[master, dsTreeNaiveMasterDerivative[master, variable, familyContext, context]],
     progress
     ];
   If[AnyTrue[derivativeRecords, Lookup[#, "status", "failed"] =!= "generated" &],
    Return[<|"status" -> "failed", "variable" -> variable, "reason" -> "derivativeGenerationFailed",
      "derivativeRecords" -> derivativeRecords|>]
    ];
   rules = dsTreeInternalReductionRules[ibpData];
   reduced = Expand[Lookup[derivativeRecords, "internalExpression"] /. rules];
   masterTokens = dsTreeToken[Lookup[#, "sectorKey"], Lookup[#, "integral"]] & /@ masters;
   coefficientTokens = Array[Unique["dsTreeMaster$"] &, Length[masters]];
   normalizedMasterRules = MapThread[#1 -> #2/#3 &,
     {masterTokens, coefficientTokens, Lookup[masters, "coefficient"]}];
   tokenExpressions = Expand[reduced /. normalizedMasterRules];
   coefficients = Table[Coefficient[tokenExpressions[[row]], coefficientTokens[[column]]],
     {row, Length[masters]}, {column, Length[masters]}];
   residuals = Expand[tokenExpressions - coefficients . coefficientTokens];
   residualTokens = DeleteDuplicates[Cases[residuals, _dsTreeToken, Infinity]];
   rows = MapThread[
     <|"master" -> #1, "coefficients" -> #2, "source" -> #3|> &,
     {masters, coefficients, residuals}
     ];
   <|
    "status" -> If[residualTokens === {} && And @@ (TrueQ[# === 0] & /@ residuals), "generated", "notClosed"],
    "variable" -> variable,
    "matrix" -> coefficients,
    "source" -> residuals,
    "rows" -> rows,
    "derivativeRecords" -> (KeyDrop[#, "internalExpression"] & /@ derivativeRecords),
    "residualObjects" -> residualTokens
    |>
   ];


dsTreeNaiveDEFromIBP[ibpData_Association, variables_, OptionsPattern[DSTreeNaiveDE]] := Module[
   {context, familyContext, resolvedVariables, allowedVariables, badVariables, variableRecords, variableData, status},
   If[Lookup[ibpData, "status", "failed"] =!= "solved" || ! ListQ[Lookup[ibpData, "masters", None]],
    Message[DSTreeNaiveDE::badibp]; Return[<|"status" -> "failed", "reason" -> "invalidNaiveIBPData"|>]
    ];
   context = Lookup[ibpData, "context", Missing["context"]];
   If[! dsContextQ[context], Message[DSTreeNaiveDE::badibp]; Return[<|"status" -> "failed", "reason" -> "missingContext"|>]];
   familyContext = dsTreeFamilyContext[context];
   allowedVariables = dsTreeNaiveAllowedVariables[context, familyContext];
   resolvedVariables = If[variables === Automatic, allowedVariables, dsDEResolveVariables[variables, context]];
   badVariables = Complement[resolvedVariables, allowedVariables];
   If[badVariables =!= {},
    Message[DSTreeNaiveDE::badvars, badVariables];
    Return[<|"status" -> "failed", "reason" -> "invalidVariables", "badVariables" -> badVariables,
      "allowedVariables" -> allowedVariables|>]
    ];
   variableRecords = dsProgressMap[
     "正在生成 naive tree 微分方程",
     resolvedVariables,
     Function[variable, dsTreeNaiveVariableData[
       variable, ibpData, familyContext, context, OptionValue[ProgressReporting]
       ]],
     OptionValue[ProgressReporting]
     ];
   variableData = AssociationThread[resolvedVariables, variableRecords];
   status = Which[
     AnyTrue[variableRecords, Lookup[#, "status", "failed"] === "failed" &], "failed",
     AnyTrue[variableRecords, Lookup[#, "status", "failed"] === "notClosed" &], "notClosed",
     True, "generated"
     ];
   <|
    "status" -> status,
    "masters" -> ibpData["masters"],
    "masterCount" -> Length[ibpData["masters"]],
    "variables" -> resolvedVariables,
    "matrices" -> AssociationThread[resolvedVariables, Lookup[variableRecords, "matrix", {}]],
    "sources" -> AssociationThread[resolvedVariables, Lookup[variableRecords, "source", {}]],
    "residualObjects" -> AssociationThread[resolvedVariables, Lookup[variableRecords, "residualObjects", {}]],
    "variableData" -> variableData,
    "naiveIBP" -> KeyDrop[ibpData, {"seedRecords", "context"}],
    "context" -> context,
    "equationConvention" -> "D[normalized tagged masters,var] == matrices[var].normalized tagged masters + sources[var]",
    "derivativeRoute" -> "loop phase derivative projection + direct h treeEnergy derivative -> naive projected dtau reduction",
    "formulaDLogUsedQ" -> False
    |>
   ];


DSTreeNaiveDE[context_Association, variables_: Automatic, masters_: Automatic, OptionsPattern[]] /; dsContextQ[context] := Module[
   {ibpData = DSTreeNaiveIBP[context, masters, ProgressReporting -> OptionValue[ProgressReporting]]},
   If[Lookup[ibpData, "status", "failed"] =!= "solved", ibpData,
    dsTreeNaiveDEFromIBP[ibpData, variables, ProgressReporting -> OptionValue[ProgressReporting]]]
   ];


DSTreeNaiveDE[ibpData_Association, variables_: Automatic, OptionsPattern[]] /;
   Lookup[ibpData, "status", "failed"] === "solved" :=
   dsTreeNaiveDEFromIBP[ibpData, variables, ProgressReporting -> OptionValue[ProgressReporting]];


DSTreeNaiveDE[_, ___] := (Message[DSTreeNaiveDE::badibp]; <|"status" -> "failed", "reason" -> "invalidContextOrIBPData"|>);

(* ::Package:: *)

(* ::Chapter:: *)
(*015 标度关系检查*)

(* 标度门禁使用符号 Euler 关系；数值点只能作为诊断，不作为通过依据。 *)

Options[DSScaleCheck] = {
   ScalingRelation -> "Custom",
   ScalingVariables -> Automatic,
   ScalingWeights -> Automatic,
   ScalingDegrees -> Automatic,
   ProgressReporting -> Automatic
   };

DSScaleCheck::badde = "DSScaleCheck 需要 DSDE 返回的 generated DE 数据。";
DSScaleCheck::badspec = "标度 relation/variables/weights/degrees 不完整或长度不一致：`1`。";

dsIntegralPhysicalPowers[int : J[aList_List, linePacks_List, _List], context_Association] := Module[
   {sectorTopo, activeVertices, aPowers, bPowers},
   sectorTopo = dsSectorTopologyForIntegral[int, context];
   If[sectorTopo === $Failed, Return[$Failed]];
   activeVertices = activeAVertexIds[sectorTopo];
   aPowers = MapThread[#1 + vertexZeroPoint[sectorTopo, #2] &, {aList, activeVertices}];
   bPowers = Table[linePowerIndex[sectorTopo, int, e], {e, sectorTopo["nE"]}];
   <|"aPowers" -> aPowers, "bPowers" -> bPowers, "sectorKey" -> sectorKeyFromShrunkLines[Lookup[sectorTopo, "sectorShrunkLines", {}]]|>
   ];

dsPureMassiveBubbleDegree[int_J, context_Association] := Module[{powers, vertexCount, offset},
   powers = dsIntegralPhysicalPowers[int, context];
   If[powers === $Failed, Return[$Failed]];
   vertexCount = Length[powers["aPowers"]];
   offset = Switch[vertexCount, 2, 2, 1, 1, _, Return[$Failed]];
   dim - Total[powers["bPowers"]] - Total[powers["aPowers"]] - offset
   ];

(* 线性组合的次数同时包含显式动力学系数；所有非零项必须具有同一 Euler 次数。 *)
dsPureMassiveBubbleExpressionDegree[expr_, variables_List, weights_List, context_Association] := Module[
   {linearData, termDegrees, coefficientDegree, integralDegree, referenceDegree},
   linearData = publicLinearIntegralDecomposition[expr];
   If[Lookup[linearData, "status", "failed"] =!= "linear" || ! TrueQ[linearData["constantTerm"] === 0], Return[$Failed]];
   termDegrees = MapThread[
     Function[{coefficient, int},
      If[TrueQ[coefficient === 0],
       Nothing,
       coefficientDegree = Together[Total[MapThread[#1 #2 D[coefficient, #2] &, {weights, variables}]]/coefficient];
       integralDegree = dsPureMassiveBubbleDegree[int, context];
       If[integralDegree === $Failed || ! And @@ (dsScaleZeroQ[D[coefficientDegree, #]] & /@ variables),
        $Failed,
        Together[coefficientDegree + integralDegree]
        ]
       ]
      ],
     {linearData["coefficients"], linearData["integrals"]}
     ];
   If[termDegrees === {} || MemberQ[termDegrees, $Failed], Return[$Failed]];
   referenceDegree = First[termDegrees];
   If[And @@ (dsScaleZeroQ[# - referenceDegree] & /@ Rest[termDegrees]), referenceDegree, $Failed]
   ];

dsScaleZeroQ[expr_] := TrueQ[Together[Expand[expr]] === 0];

DSScaleCheck[deData_Association, spec_: <||>, OptionsPattern[]] := Module[
   {relation, variables, weights, degrees, masters, context, matrices, sources, missingVariables,
    declaredDegrees, degreeRules, eulerMatrix, eulerSource, matrixResidual, sourceResidual, checks, status},
   If[Lookup[deData, "status", "missing"] =!= "generated",
    Message[DSScaleCheck::badde]; dsErrorPrint["DE 尚未闭合，不能宣称标度检查通过。"]; Return[<|"status" -> "failed", "reason" -> "deNotGenerated"|>]
    ];
   relation = Lookup[spec, "relation", OptionValue[ScalingRelation]];
   variables = Replace[Lookup[spec, "variables", OptionValue[ScalingVariables]], Automatic -> deData["variables"]];
   weights = Replace[Lookup[spec, "weights", OptionValue[ScalingWeights]], Automatic -> ConstantArray[1, Length[variables]]];
   masters = deData["masters"];
   context = deData["context"];
   declaredDegrees = Lookup[Lookup[deData, "activeBasis", <||>], "scalingDegrees", Automatic];
   degrees = Replace[
     Lookup[spec, "degrees", OptionValue[ScalingDegrees]],
     Automatic :> Which[
       ListQ[declaredDegrees], declaredDegrees,
       relation === "PureMassiveBubble", dsPureMassiveBubbleExpressionDegree[#, variables, weights, context] & /@ masters,
       True, $Failed
       ]
     ];
   (* seed 前固定的不可求导参数也必须进入齐次次数；DE 变量自身始终保留为符号。 *)
   degreeRules = If[
     TrueQ[Lookup[Lookup[deData, "sourceManifest", <||>], "numericRulesAppliedBeforeSeeds", False]],
     Select[
      Lookup[context["topology"], "numericRules", {}],
      ! MemberQ[variables, First[#]] &
      ],
     {}
     ];
   If[ListQ[degrees], degrees = degrees /. degreeRules];
   If[! ListQ[variables] || ! ListQ[weights] || Length[variables] =!= Length[weights] ||
     ! ListQ[degrees] || Length[degrees] =!= Length[masters] || MemberQ[degrees, $Failed],
    Message[DSScaleCheck::badspec, <|"relation" -> relation, "variables" -> variables, "weights" -> weights, "degrees" -> degrees|>];
    dsErrorPrint["标度检查规格无效。"]; Return[<|"status" -> "failed", "reason" -> "invalidScalingSpecification"|>]
    ];
   matrices = deData["matrices"];
   sources = deData["sources"];
   missingVariables = Select[variables, ! KeyExistsQ[matrices, #] &];
   If[missingVariables =!= {},
    Message[DSScaleCheck::badspec, missingVariables]; dsErrorPrint["DE 缺少 Euler 算符所需变量。"]; Return[<|"status" -> "failed", "reason" -> "missingDEVariables", "missingVariables" -> missingVariables|>]
    ];
   eulerMatrix = Total[MapThread[#1 #2 matrices[#2] &, {weights, variables}]];
   eulerSource = Total[MapThread[#1 #2 sources[#2] &, {weights, variables}]];
   matrixResidual = Map[Together[Expand[#]] &, eulerMatrix - DiagonalMatrix[degrees], {2}];
   sourceResidual = Together[Expand[#]] & /@ eulerSource;
   checks = <|
     "matrixRelation" -> And @@ (dsScaleZeroQ /@ Flatten[matrixResidual]),
     "sourceRelation" -> And @@ (dsScaleZeroQ /@ sourceResidual)
     |>;
   status = If[And @@ Values[checks], "passed", "failed"];
   <|
    "status" -> status,
    "relation" -> relation,
    "variables" -> variables,
    "weights" -> weights,
    "degrees" -> degrees,
    "eulerMatrix" -> eulerMatrix,
    "eulerSource" -> eulerSource,
    "matrixResidual" -> matrixResidual,
    "sourceResidual" -> sourceResidual,
    "checks" -> checks,
    "symbolicQ" -> True
    |>
   ];

DSScaleCheck[deData_, spec_: <||>, OptionsPattern[]] := (Message[DSScaleCheck::badde]; dsErrorPrint["DSScaleCheck 输入必须是 DE Association。"]; <|"status" -> "failed", "reason" -> "inputNotAssociation"|>);

(* ::Package:: *)

(* ::Chapter:: *)
(*014 tree vertex-family 接口所有权*)

(* 013 的 vertex-family 公式在冻结核心中；本模块只增加 DSInit context 适配，不复制递推公式。 *)

dsTreeFamilyContext[context_Association] /; dsContextQ[context] := Module[{familyContext, rootTopology = context["topology"], families},
   familyContext = makeTreeSectorFamilies[rootTopology];
   If[familyContext === $Failed, Return[$Failed]];
   families = Join[#, <|"rootTopology" -> rootTopology|>] & /@ familyContext["families"];
   Join[familyContext, <|"families" -> families, "topFamily" -> First[families]|>]
   ];

DSTreeSeeds[vertex_, int : J[_, _, _], context_Association] /; dsContextQ[context] :=
   dsEnrichTreeSeedRecord[DSTreeSeeds[vertex, int, context["topology"]], context["topology"], int];

DSTreeSeeds[int : J[_, _, _], context_Association] /; dsContextQ[context] :=
   DSTreeSeeds[#, int, context] & /@ Lookup[Select[makeIBPGenerators[context["topology"]], #["type"] === "time" &], "vertex"];

repIterative[data_Association, end_: Automatic, context_Association, opts : OptionsPattern[]] /;
   dsTreeLinearDataQ[data] && dsContextQ[context] :=
   dsRepIterativeTreeLinearData[data, end, context, opts];

repIterative[expr_, end_: Automatic, context_Association, opts : OptionsPattern[]] /; dsContextQ[context] :=
   repIterative[expr, end, dsTreeFamilyContext[context], opts];


(* ::Chapter:: *)
(*多 sector dlog 数据汇总*)

(* 每个 sector 的对角块仍由 vertex-family 公式构造；非对角块从 loop dtau 的 tagged contact source 提取，
   因而共同 theta、多线 simultaneous contact 和 mixed-sign 禁用规则只在既有 loop 边界层出现一次。 *)

(* p=0 的 terminal contact vertex 没有 massive leg；空能量表必须是 {}，不能让 Lookup 产生 Missing。 *)
treeVertexDLogData[vertex_Association] := Module[
   {p, states, energies, k0, omega0, omegaEx, tp, tpInv, m1, omega, letters, coeffs},
   p = vertex["p"];
   states = treeBinaryStates[p];
   energies = If[vertex["massiveLegs"] === {}, {}, Lookup[vertex["massiveLegs"], "energy"]];
   k0 = vertex["signedEnergy"];
   omega0 = -I DiagonalMatrix[Table[
      Log[k0 + Sum[(2 states[[row, i]] - 1) energies[[i]], {i, p}]],
      {row, Length[states]}
      ]];
   omegaEx = DiagonalMatrix[Table[
     -Sum[states[[row, i]] (2 vertex["massiveLegs"][[i, "nu"]] + 1) Log[energies[[i]]], {i, p}],
     {row, Length[states]}
     ]];
   tp = treeTp[vertex];
   tpInv = treeTpInverse[vertex];
   m1 = treeM1[vertex, vertex["nu0"] + 1];
   omega = Expand[omegaEx - I tpInv . omega0 . tp . m1];
   letters = DeleteDuplicates@Join[energies, Cases[omega0, Log[arg_] :> arg, Infinity]];
   coeffs = Association@Table[letter -> Map[Coefficient[#, Log[letter]] &, omega, {2}], {letter, letters}];
   <|"vertex" -> vertex["id"], "states" -> states, "omega" -> omega, "letters" -> letters, "letterMatrices" -> coeffs|>
   ];


dsTreeBlockDiagonal[matrices_List] := Module[{dimensions = Length /@ matrices},
   If[matrices === {}, Return[{}]];
   ArrayFlatten@Table[
     If[i === j, matrices[[i]], ConstantArray[0, {dimensions[[i]], dimensions[[j]]}]],
     {i, Length[matrices]}, {j, Length[matrices]}
     ]
   ];


dsTreeMasterSectorOffsets[blocks_List] := Module[{counts, starts, ends},
   counts = Lookup[blocks, "masterCount"];
   starts = 1 + Most[Accumulate[Prepend[counts, 0]]];
   ends = Accumulate[counts];
   MapThread[
    <|"sectorKey" -> #1, "start" -> #2, "end" -> #3, "count" -> #4|> &,
    {Lookup[blocks, "sector"], starts, ends, counts}
    ]
   ];


(* ::Section::Closed:: *)
(*Contact selector 与 sector normalization*)

(* 对 parent sector 的 a=0 master 逐顶点调用 time-IBP；同 sector 项属于 M1/M0，只有 lower-sector 项进入 R。 *)
dsTreeContactRows[family_Association, masters_List, context_Association] := Module[
   {sourceSector = family["sector"], rowsByVertex, vertexIndex, seedMaster, loopIntegral, record, linearData, terms,
    sourceData, reducedSource},
   rowsByVertex = Association@Table[
      vertexIndex = First@FirstPosition[family["vertexOrder"], vertexId];
      vertexId -> Table[
        (* dlog source 来自 f^(1) 的约化，即论文 Eq. (3.67) 中 R^(1)；binary state 不变。 *)
        seedMaster = J[ReplacePart[
           First[masters[[row]]],
           vertexIndex -> ReplacePart[First[masters[[row]]][[vertexIndex]], 1 -> 1]
           ]];
        loopIntegral = treeLoopIntegralFromTree[seedMaster, family];
        If[loopIntegral === $Failed,
         Return[<|"status" -> "error", "reason" -> "treeLoopBackProjectionFailed",
           "sectorKey" -> sourceSector, "vertex" -> vertexId, "row" -> row|>]
         ];
        record = dsTreeSeedRecordFromSector[vertexId, loopIntegral, family];
        If[record === $Failed,
         Return[<|"status" -> "error", "reason" -> "contactSeedGenerationFailed",
           "sectorKey" -> sourceSector, "vertex" -> vertexId, "row" -> row|>]
         ];
        linearData = Lookup[record, "treeLinearData", <||>];
        If[! dsTreeLinearDataQ[linearData],
         Return[<|"status" -> "error", "reason" -> "contactSeedTaggingFailed",
           "sectorKey" -> sourceSector, "vertex" -> vertexId, "row" -> row|>]
         ];
        terms = Select[linearData["terms"], Lookup[#, "sectorKey", sourceSector] =!= sourceSector &];
        sourceData = <|"status" -> "generated", "terms" -> terms,
          "termCount" -> Length[terms], "sectorKeys" -> DeleteDuplicates[Lookup[terms, "sectorKey", {}]],
          "expression" -> Total[Lookup[#, "coefficient"] Lookup[#, "integral"] & /@ terms],
          "coefficientConvention" -> "complete physical powers: a+a0 and b+b0 or bS+bS0"|>;
        reducedSource = If[terms === {},
          Join[sourceData, <|"status" -> "reduced"|>],
          dsRepIterativeTreeLinearData[sourceData, Automatic, context, MaxIterations -> Automatic]
          ];
        If[Lookup[reducedSource, "status", "error"] =!= "reduced",
         Return[<|"status" -> "error", "reason" -> "contactSourceReductionFailed",
           "sectorKey" -> sourceSector, "vertex" -> vertexId, "row" -> row,
           "sourceData" -> sourceData, "reducedSource" -> reducedSource|>]
         ];
        <|"row" -> row, "master" -> masters[[row]], "seedIntegral" -> seedMaster, "rawTerms" -> terms,
          "terms" -> Lookup[reducedSource, "terms", {}],
          "reductionSteps" -> Lookup[reducedSource, "steps", 0]|>,
        {row, Length[masters]}
        ],
      {vertexId, family["vertexOrder"]}
      ];
   <|"status" -> "generated", "sectorKey" -> sourceSector, "rowsByVertex" -> rowsByVertex|>
   ];


(* 每个 target sector 单独按其 master order 抽取矩阵，避免相同裸 J shape 跨 sector 混淆。 *)
dsTreeContactMatrices[
   rowData_Association,
   sectorOrder_List,
   masterLists_Association
   ] := Module[{sourceSector, targetSectors, unresolved = {}, matricesByVertex, positions, matrix},
   If[Lookup[rowData, "status", "error"] =!= "generated", Return[rowData]];
   sourceSector = rowData["sectorKey"];
   targetSectors = Drop[sectorOrder, First@FirstPosition[sectorOrder, sourceSector]];
   matricesByVertex = Association@KeyValueMap[
      Function[{vertexId, rows},
       vertexId -> Association@Table[
          positions = AssociationThread[masterLists[targetSector] -> Range[Length[masterLists[targetSector]]]];
          matrix = ConstantArray[0, {Length[rows], Length[masterLists[targetSector]]}];
          Do[
           Do[
            If[Lookup[term, "sectorKey", None] === targetSector,
             If[KeyExistsQ[positions, term["integral"]],
              matrix[[row, positions[term["integral"]]]] += term["coefficient"],
              AppendTo[unresolved, <|"sourceSector" -> sourceSector, "targetSector" -> targetSector,
                "vertex" -> vertexId, "row" -> row, "term" -> term|>]
              ]
             ],
            {term, rows[[row, "terms"]]}
            ],
           {row, Length[rows]}
           ];
          targetSector -> Expand[matrix],
          {targetSector, targetSectors}
          ]
       ],
      rowData["rowsByVertex"]
      ];
   If[unresolved =!= {},
    <|"status" -> "error", "reason" -> "contactSourceNotInTargetMasterBasis", "unresolved" -> unresolved|>,
    <|"status" -> "generated", "sectorKey" -> sourceSector,
      "rowsByVertex" -> rowData["rowsByVertex"], "matricesByVertex" -> matricesByVertex|>
    ]
   ];


dsTreeContactTransitions[contactData_List] := Flatten[Map[
    Function[sourceData,
     KeyValueMap[
      Function[{vertexId, targetMatrices},
       Flatten@KeyValueMap[
         Function[{targetSector, matrix},
          Cases[
           Flatten[MapIndexed[
             Function[{value, position},
              <|"sourceSector" -> sourceData["sectorKey"], "targetSector" -> targetSector,
                "vertex" -> vertexId, "row" -> position[[1]], "column" -> position[[2]],
                "coefficient" -> value|>
              ],
             matrix,
             {2}
             ]],
           item_Association /; ! TrueQ[Together[item["coefficient"]] === 0]
           ]
          ],
         targetMatrices
         ]
       ],
      sourceData["matricesByVertex"]
      ]
     ],
    contactData
    ], 2];


(* lower-sector master 吸收共同 Wronskian/能量幂；所有其它入边除以该 normalization 后必须不含 DE 能量变量。 *)
dsTreeSectorNormalizations[sectorOrder_List, contactData_List, families_List] := Module[
   {transitions, normalizations = <|First[sectorOrder] -> 1|>, audits = {}, energyExpressions, energyVariables,
    child, candidates, chosen, normalization, ratios, nonconstant},
   transitions = dsTreeContactTransitions[contactData];
   energyExpressions = Flatten[Cases[
      families,
      vertex_Association /; KeyExistsQ[vertex, "signedEnergy"] :>
       Join[{vertex["signedEnergy"]}, Lookup[vertex["massiveLegs"], "energy", {}]],
      Infinity
      ]];
   energyVariables = DeleteDuplicates[Variables[energyExpressions]];
   Do[
    child = sectorOrder[[index]];
    candidates = Select[transitions,
      Lookup[#, "targetSector", None] === child && KeyExistsQ[normalizations, Lookup[#, "sourceSector", None]] &];
    If[candidates === {},
     Return[<|"status" -> "error", "reason" -> "sectorNormalizationSourceMissing", "sectorKey" -> child|>]
     ];
    chosen = First[candidates];
    normalization = Expand[normalizations[chosen["sourceSector"]] chosen["coefficient"]];
    AssociateTo[normalizations, child -> normalization];
    ratios = Map[
      Function[item,
       Join[item, <|"normalizedCoefficient" -> Together[
           normalizations[item["sourceSector"]] item["coefficient"]/normalization
           ]|>]
       ],
      candidates
      ];
    nonconstant = If[energyVariables === {}, {},
      Select[ratios, ! FreeQ[Lookup[#, "normalizedCoefficient"], Alternatives @@ energyVariables] &]
      ];
    AppendTo[audits, <|"sectorKey" -> child, "normalization" -> normalization,
      "chosenTransition" -> chosen, "incomingTransitions" -> ratios,
      "energyIndependentRatiosQ" -> (nonconstant === {}), "nonconstantRatios" -> nonconstant|>];
    If[nonconstant =!= {},
     Return[<|"status" -> "error", "reason" -> "nonconstantContactSelector",
       "sectorKey" -> child, "normalizations" -> normalizations, "audits" -> audits|>]
     ],
    {index, 2, Length[sectorOrder]}
    ];
   <|"status" -> "generated", "normalizations" -> normalizations, "audits" -> audits,
     "energyVariables" -> energyVariables, "transitions" -> transitions|>
   ];


(* ::Section::Closed:: *)
(*Block-triangular primitive connection*)

dsTreeVertexSourcePrimitive[vertex_Association] := Module[{states, energies, cuts},
   states = treeBinaryStates[vertex["p"]];
   energies = If[vertex["massiveLegs"] === {}, {}, Lookup[vertex["massiveLegs"], "energy"]];
   cuts = Table[
     vertex["signedEnergy"] + Sum[(2 states[[row, i]] - 1) energies[[i]], {i, vertex["p"]}],
     {row, Length[states]}
     ];
   treeTpInverse[vertex] . (-I DiagonalMatrix[Log /@ cuts]) . treeTp[vertex]
   ];


dsTreeAssembleConnection[
   blocks_List,
   families_List,
   sectorOrder_List,
   contactData_List,
   normalizationData_Association
   ] := Module[{dimensions, sectorPositions, normalizations, omegaBlocks, sourceIndex, targetIndex,
    sourceFamily, vertexIndex, sourcePrimitive, rawMatrix, normalizedMatrix, normalizedContactData},
   dimensions = Lookup[blocks, "masterCount"];
   sectorPositions = AssociationThread[sectorOrder -> Range[Length[sectorOrder]]];
   normalizations = normalizationData["normalizations"];
   omegaBlocks = Table[
     If[i === j,
      Expand[blocks[[i, "omega"]] + Log[normalizations[sectorOrder[[i]]]] IdentityMatrix[dimensions[[i]]]],
      ConstantArray[0, {dimensions[[i]], dimensions[[j]]}]
      ],
     {i, Length[blocks]}, {j, Length[blocks]}
     ];
   normalizedContactData = Map[
      Function[sourceData,
      sourceIndex = sectorPositions[sourceData["sectorKey"]];
      sourceFamily = families[[sourceIndex]];
      Join[sourceData, <|"normalizedMatricesByVertex" -> Association@KeyValueMap[
          Function[{vertexId, targetMatrices},
           vertexIndex = First@FirstPosition[sourceFamily["vertexOrder"], vertexId];
           sourcePrimitive = treeEmbedVertexMatrix[
             dsTreeVertexSourcePrimitive[sourceFamily["vertices"][[vertexIndex]]],
             vertexIndex,
             2^Lookup[sourceFamily["vertices"], "p"]
             ];
           vertexId -> Association@KeyValueMap[
              Function[{targetSector, matrix},
               targetIndex = sectorPositions[targetSector];
               rawMatrix = matrix;
               normalizedMatrix = Expand[
                 normalizations[sourceData["sectorKey"]]/normalizations[targetSector] rawMatrix
                 ];
               omegaBlocks[[sourceIndex, targetIndex]] = Expand[
                 omegaBlocks[[sourceIndex, targetIndex]] - I sourcePrimitive . normalizedMatrix
                 ];
               targetSector -> normalizedMatrix
               ],
              targetMatrices
              ]
           ],
          sourceData["matricesByVertex"]
          ]|>]
      ],
     contactData
     ];
   <|"omega" -> ArrayFlatten[omegaBlocks], "omegaBlocks" -> omegaBlocks,
     "normalizedContactData" -> normalizedContactData|>
   ];


dsTreeMultiSectorDLog[context_Association, seedData_: Automatic] := Module[
   {familyContext, families, sectorOrder, blocks, dimensions, masterLists, contactRows, contactData,
    normalizationData, assembled, normalizations, letters, omega, letterMatrices, offsets, taggedMasters,
    bareMasters, dlogResidual, sourceEquations},
   familyContext = dsTreeFamilyContext[context];
   If[familyContext === $Failed, Return[<|"status" -> "error", "reason" -> "treeFamilyInitializationFailed"|>]];
   families = familyContext["families"];
   sectorOrder = familyContext["sectorOrder"];
   blocks = DSTreeDLogDE /@ families;
   If[AnyTrue[blocks, Lookup[#, "status", "error"] =!= "generated" &],
    Return[<|"status" -> "error", "reason" -> "sectorDLogFailed", "sectorBlocks" -> blocks|>]
    ];
   dimensions = Lookup[blocks, "masterCount"];
   masterLists = AssociationThread[sectorOrder -> Lookup[blocks, "masters"]];
   contactRows = MapThread[dsTreeContactRows[#1, #2, context] &, {families, Lookup[blocks, "masters"]}];
   If[AnyTrue[contactRows, Lookup[#, "status", "error"] =!= "generated" &],
    Return[<|"status" -> "error", "reason" -> "contactRowGenerationFailed", "contactRows" -> contactRows|>]
    ];
   contactData = dsTreeContactMatrices[#, sectorOrder, masterLists] & /@ contactRows;
   If[AnyTrue[contactData, Lookup[#, "status", "error"] =!= "generated" &],
    Return[<|"status" -> "error", "reason" -> "contactMatrixGenerationFailed", "contactData" -> contactData|>]
    ];
   normalizationData = dsTreeSectorNormalizations[sectorOrder, contactData, families];
   If[Lookup[normalizationData, "status", "error"] =!= "generated",
    Return[Join[<|"status" -> "error", "reason" -> "sectorNormalizationFailed"|>, normalizationData]]
    ];
   assembled = dsTreeAssembleConnection[blocks, families, sectorOrder, contactData, normalizationData];
   normalizations = normalizationData["normalizations"];
   omega = assembled["omega"];
   letters = DeleteDuplicates@Join[
      Flatten[Lookup[blocks, "letters"]],
      DeleteCases[Lookup[normalizations, sectorOrder], 1]
      ];
   letterMatrices = Association@Table[
      letter -> Map[Coefficient[#, Log[letter]] &, omega, {2}],
      {letter, letters}
      ];
   dlogResidual = Expand[omega - Total[MapThread[Log[#1] #2 &, {letters, Values[letterMatrices]}]]];
   offsets = dsTreeMasterSectorOffsets[blocks];
   taggedMasters = Flatten[Map[
      Function[block,
       treeTaggedIntegral[block["sector"], #, normalizations[block["sector"]]] & /@ block["masters"]
       ],
      blocks
      ]];
   bareMasters = Lookup[taggedMasters, "integral"];
   sourceEquations = Lookup[contactData, "rowsByVertex"];
   <|
    "status" -> "generated",
    "connectionStructure" -> "sectorDAGBlockTriangular",
    "offDiagonalSourceStatus" -> "assembledFromLoopTimeIBP",
    "sectorOrder" -> sectorOrder,
    "sectorBlocks" -> blocks,
    "masterSectorOffsets" -> offsets,
    "masters" -> taggedMasters,
    "bareMasters" -> bareMasters,
    "masterCount" -> Length[taggedMasters],
    "omega" -> omega,
    "letters" -> letters,
    "letterMatrices" -> letterMatrices,
    "matrixDimension" -> Dimensions[omega],
    "dlogResidual" -> dlogResidual,
    "dlogQ" -> TrueQ[dlogResidual === ConstantArray[0, Dimensions[omega]]],
    "sectorNormalizations" -> normalizations,
    "normalizationAudits" -> normalizationData["audits"],
    "contactMaps" -> assembled["normalizedContactData"],
    "omegaBlocks" -> assembled["omegaBlocks"],
    "sourceEquations" -> sourceEquations,
    "inputSourceData" -> seedData,
    "sourceConvention" -> "Eq. (3.66)-(3.68): -I T^-1 Omega0 T times loop-dtau contact selector"
    |>
   ];


DSTreeDLogDE[context_Association] /; dsContextQ[context] := dsTreeMultiSectorDLog[context];

DSTreeDLogDE[context_Association, seedData_] /; dsContextQ[context] :=
   dsTreeMultiSectorDLog[context, seedData];

(* ::Package:: *)

(* ::Chapter:: *)
(*015 根号动力学坐标适配层*)

(* 本模块把 loop external-momentum 的内部原子 kk[i,j]=sp[k_i,k_j] 暴露为
   ssij=Sqrt[sp[k_i,k_j]]，并把实际出现的无圈动量模长依次暴露为 sE1,sE2,...。
   旧 kk/sij 导数保持原子实现；根号坐标只通过 Jacobian 链式法则调用该原子层。 *)


(* ::Section::Closed:: *)
(*缺省命名与圈外外腿规则*)

externalRootSymbolName[i_Integer, j_Integer] :=
  ToExpression["ss" <> ToString[Min[i, j]] <> ToString[Max[i, j]]];


externalLegRootSymbolName[i_Integer] := ToExpression["sE" <> ToString[i]];


defaultExternalInvariantRulesForTopology[topo_Association] := Module[
   {exts = Lookup[topo, "externalMomenta", {}], nK},
   nK = Length[exts];
   Flatten@Table[
     sp[exts[[i]], exts[[j]]] -> externalRootSymbolName[i, j]^2,
     {i, nK}, {j, i, nK}
     ]
   ];


canonicalExternalLegMomentum[expr_] := Module[{forms, preferred},
   forms = DeleteDuplicates[{Expand[expr], Expand[-expr]}];
   preferred = Select[forms, ! StringStartsQ[ToString[InputForm[#]], "-"] &];
   First@SortBy[If[preferred === {}, forms, preferred], ToString[InputForm[#]] &]
   ];


zeroLoopMomentumQ[expr_, topo_Association] := And @@ (
    zeroQ[Coefficient[Expand[expr], #]] & /@ Lookup[topo, "loopMomenta", {}]
    );


externalMomentumOnlyQ[expr_, topo_Association] := Module[
   {basis = Lookup[topo, "externalMomenta", {}], data},
   data = linearMomentumExpressionData[Expand[expr], basis];
   TrueQ[data["linearQ"]]
   ];


externalLegCoordinateLineQ[expr_, topo_Association] :=
  zeroLoopMomentumQ[expr, topo] && ! externalMomentumOnlyQ[expr, topo];


externalLegMagnitudeMomentaInExpression[expr_, topo_Association] := DeleteDuplicates[
   canonicalExternalLegMomentum /@ Cases[
     expr,
     HoldPattern[Power[sp[p_, r_], Rational[1, 2]]] /; Expand[p - r] === 0 && zeroLoopMomentumQ[p, topo] :> p,
     {0, Infinity}
     ]
   ];


externalLegMagnitudeCandidateMomenta[topo_Association] := Module[
   {lineMomenta, phaseExpressions, candidates},
   lineMomenta = Cases[
     Lookup[Lookup[topo, "lines", {}], "momentum", {}],
     momentum_ /; zeroLoopMomentumQ[momentum, topo] && ! zeroQ[momentum] &&
        ! externalMomentumOnlyQ[momentum, topo] :> momentum
     ];
   phaseExpressions = Join[
     Values@Replace[Lookup[topo, "vertexEnergies", <||>], rules_List :> Association[rules]],
     Cases[Lookup[topo, "extLegs", {}], entry_List /; Length[entry] >= 3 :> entry[[3]]]
     ];
   candidates = Join[
     lineMomenta,
     Flatten[externalLegMagnitudeMomentaInExpression[#, topo] & /@ phaseExpressions]
     ];
   DeleteDuplicates[
    Select[canonicalExternalLegMomentum /@ candidates, ! zeroQ[#] && ! externalMomentumOnlyQ[#, topo] &]
    ]
   ];


externalLegGramPairs[basis_List] := Flatten[
   Table[{i, j}, {i, Length[basis]}, {j, i, Length[basis]}],
   1
   ];


momentumSquaredGramVector[momentum_, basis_List] := Module[{coefficients, pairs},
   coefficients = Coefficient[Expand[momentum], #] & /@ basis;
   pairs = externalLegGramPairs[basis];
   Map[
    Function[pair,
     If[pair[[1]] === pair[[2]],
      coefficients[[pair[[1]]]]^2,
      2 coefficients[[pair[[1]]]] coefficients[[pair[[2]]]]
      ]
     ],
    pairs
    ]
   ];


(* 实际出现集合先在完整声明向量 Gram 空间中展开；完整 loop Gram 已经在基中，
   其余模长平方仅在增加秩时获得新的 sEe。未入基项保留线性 binding。 *)
externalLegMagnitudeBasisAnalysis[topo_Association] := Module[
   {external = Lookup[topo, "externalMomenta", {}],
    declaredLegs = Lookup[topo, "externalLegMomenta", {}], basis, pairs,
    loopPairPositions, loopRows, candidates, candidateRows, selectedPositions = {},
    selectedRows = {}, currentRows, oldRank, newRank, row, basisRows,
    defaultSquaredCoordinates, occurrenceData},
   basis = Join[external, declaredLegs];
   pairs = externalLegGramPairs[basis];
   loopPairPositions = Flatten@Position[
      pairs,
      {i_, j_} /; i <= Length[external] && j <= Length[external],
      {1},
      Heads -> False
      ];
   loopRows = UnitVector[Length[pairs], #] & /@ loopPairPositions;
   candidates = externalLegMagnitudeCandidateMomenta[topo];
   candidateRows = momentumSquaredGramVector[#, basis] & /@ candidates;
   currentRows = loopRows;
   oldRank = If[currentRows === {}, 0, MatrixRank[currentRows]];
   Do[
    row = candidateRows[[position]];
    newRank = MatrixRank[Append[currentRows, row]];
    If[newRank > oldRank,
     AppendTo[selectedPositions, position];
     AppendTo[selectedRows, row];
     AppendTo[currentRows, row];
     oldRank = newRank
     ],
    {position, Length[candidates]}
    ];
   basisRows = Join[loopRows, selectedRows];
   defaultSquaredCoordinates = Join[
     Last /@ defaultExternalInvariantRulesForTopology[topo],
     Table[externalLegRootSymbolName[i]^2, {i, Length[selectedPositions]}]
     ];
   occurrenceData = MapIndexed[
     Function[{momentum, indexSpec},
      Module[{position = First[indexSpec], selectedPosition, coefficients, externalLegIndex},
       coefficients = If[
         basisRows === {},
         {},
         Quiet[Check[LinearSolve[Transpose[basisRows], candidateRows[[position]]], $Failed]]
         ];
       If[! ListQ[coefficients], coefficients = ConstantArray[Indeterminate, Length[basisRows]]];
       selectedPosition = FirstPosition[selectedPositions, position, Missing["Dependent"]];
       externalLegIndex = If[Head[selectedPosition] === Missing, Missing["Dependent"], First[selectedPosition]];
       <|
        "occurrenceIndex" -> position,
        "momentum" -> momentum,
        "squaredExpression" -> sp[momentum, momentum],
        "magnitudeExpression" -> Sqrt[sp[momentum, momentum]],
        "gramVector" -> candidateRows[[position]],
        "baseCoefficients" -> coefficients,
        "independentQ" -> (Head[selectedPosition] =!= Missing),
        "externalLegIndex" -> externalLegIndex,
        "userVariable" -> If[Head[selectedPosition] === Missing, Missing["Dependent"], externalLegRootSymbolName[externalLegIndex]],
        "defaultSquaredExpression" -> Expand[coefficients . defaultSquaredCoordinates]
        |>
       ]
      ],
     candidates
     ];
   <|
    "declaredMomentumBasis" -> basis,
    "gramPairs" -> pairs,
    "loopGramRows" -> loopRows,
    "candidateMomenta" -> candidates,
    "candidateRows" -> candidateRows,
    "selectedOccurrencePositions" -> selectedPositions,
    "basisRows" -> basisRows,
    "defaultSquaredCoordinates" -> defaultSquaredCoordinates,
    "occurrenceData" -> occurrenceData,
    "independentExternalLegData" -> Select[occurrenceData, TrueQ[Lookup[#, "independentQ", False]] &],
    "dependentExternalLegData" -> Select[occurrenceData, ! TrueQ[Lookup[#, "independentQ", False]] &]
    |>
   ];


externalLegMagnitudeData[topo_Association] := Lookup[
   externalLegMagnitudeBasisAnalysis[topo],
   "independentExternalLegData",
   {}
   ];


externalLegMagnitudeOccurrenceData[topo_Association] := Lookup[
   externalLegMagnitudeBasisAnalysis[topo],
   "occurrenceData",
   {}
   ];


defaultExternalLegInvariantRulesForTopology[topo_Association] := Map[
   #1["squaredExpression"] -> #1["userVariable"]^2 &,
   externalLegMagnitudeData[topo]
   ];


kinematicRuleLHS[rule : (Rule | RuleDelayed)[lhs_, _]] := Replace[
   Unevaluated[lhs],
   HoldPattern[Sqrt[arg_]] :> arg,
   {0}
   ];


kinematicRuleRHS[rule : (Rule | RuleDelayed)[lhs_, rhs_]] := If[
   MatchQ[Unevaluated[lhs], HoldPattern[Sqrt[_]]],
   rhs^2,
   rhs
   ];


normalizeKinematicRule[rule : (Rule | RuleDelayed)[_, _]] :=
  kinematicRuleLHS[rule] -> kinematicRuleRHS[rule];


normalizeKinematicRuleList[rules_Association] := normalizeKinematicRuleList[Normal[rules]];
normalizeKinematicRuleList[rules_List] := normalizeKinematicRule /@ Select[rules, validReplacementRuleQ];
normalizeKinematicRuleList[_] := {};


kinematicBaseCoordinateData[topo_Association] := Module[
   {loopRules, legData, loopData},
   loopRules = defaultExternalInvariantRulesForTopology[topo];
   loopData = MapIndexed[
     <|
       "baseIndex" -> First[#2],
       "kind" -> "loopExternalGram",
       "inputExpression" -> First[#1],
       "internalVariable" -> Replace[First[#1], HoldPattern[sp[p_, r_]] :> expandDotExpr[p, r, topo], {0}],
       "defaultVariable" -> rootCoordinateSymbol[Last[#1]],
       "defaultRHS" -> Last[#1]
       |> &,
     loopRules
     ];
   legData = MapIndexed[
     Join[#1, <|
        "baseIndex" -> Length[loopData] + First[#2],
        "kind" -> "externalLegMagnitude",
        "inputExpression" -> #1["squaredExpression"],
        "internalVariable" -> externalLegSquaredCoordinate[First[#2]],
        "defaultVariable" -> #1["userVariable"],
        "defaultRHS" -> #1["userVariable"]^2
        |>] &,
     externalLegMagnitudeData[topo]
     ];
   Join[loopData, legData]
   ];


kinematicRuleBaseVector[rule_, topo_Association, baseData_List] := Module[
   {lhs = kinematicRuleLHS[rule], legHit, loopData, loopVars, internal, coeffs, residual},
   legHit = SelectFirst[
     externalLegMagnitudeOccurrenceData[topo],
     SameQ[lhs, Lookup[#, "squaredExpression"]] &,
     Missing["NotFound"]
     ];
   If[AssociationQ[legHit], Return[Lookup[legHit, "baseCoefficients", Missing["UnsupportedKinematicLHS", lhs]]]];
   loopData = Select[baseData, Lookup[#, "kind", ""] === "loopExternalGram" &];
   loopVars = Lookup[loopData, "internalVariable", {}];
   internal = Expand[lhs /. HoldPattern[sp[p_, r_]] :> expandDotExpr[p, r, topo]];
   If[! FreeQ[internal, sp], Return[Missing["UnsupportedKinematicLHS", lhs]]];
   coeffs = Coefficient[internal, #] & /@ loopVars;
   residual = Expand[internal - Total[MapThread[#1 #2 &, {coeffs, loopVars}]]];
   If[! zeroQ[residual],
    Missing["UnsupportedKinematicLHS", lhs],
    Join[coeffs, ConstantArray[0, Length[baseData] - Length[loopData]]]
    ]
   ];


independentKinematicRows[matrix_List, targetRank_Integer] := Module[
   {selected = {}, current = {}, oldRank = 0, newRank, row},
   Do[
    row = matrix[[i]];
    newRank = MatrixRank[Append[current, row]];
    If[newRank > oldRank,
     AppendTo[selected, i];
     AppendTo[current, row];
     oldRank = newRank
     ];
    If[oldRank >= targetRank, Break[]],
    {i, Length[matrix]}
    ];
   selected
   ];


simpleKinematicInverseQ[rhs_] := MatchQ[
   Unevaluated[rhs],
   _Symbol | HoldPattern[Power[_Symbol, 2]]
   ];


kinematicRootExpression[rhs_] := Replace[
   rhs,
   {
    HoldPattern[Power[s_Symbol, 2]] :> s,
    other_ :> Sqrt[other]
    },
   {0}
   ];


kinematicCoordinateAudit[topo_Association, rules_List, source_String] := Module[
   {baseData, baseCount, normalizedRules, vectors, supportedPositions, unsupportedPositions,
    matrix, rhs, rank, rowSelection, baseRHS = {}, resolvedRules = {}, loopCount,
    missingDirections, ruleMissingDirections, parameterMissingDirections, ruleDependencies,
    parameterDependencies, constraintResiduals = {}, userVariables, parameterJacobian = {},
    baseExpressions, ruleMissingDirectionExpressions, parameterMissingDirectionExpressions,
    ruleDependencyResiduals, parameterRank = 0, ruleCompleteQ, overcompleteQ, completeQ,
    inverseAvailableQ, occurrenceData, bindingCoordinates, dependentBindings},
   baseData = kinematicBaseCoordinateData[topo];
   baseCount = Length[baseData];
   baseExpressions = Lookup[baseData, "inputExpression", {}];
   normalizedRules = normalizeKinematicRuleList[rules];
   vectors = kinematicRuleBaseVector[#, topo, baseData] & /@ normalizedRules;
   supportedPositions = Flatten@Position[vectors, _List, {1}, Heads -> False];
   unsupportedPositions = Complement[Range[Length[vectors]], supportedPositions];
   matrix = If[supportedPositions === {}, {}, vectors[[supportedPositions]]];
   rhs = If[supportedPositions === {}, {}, (Last /@ normalizedRules[[supportedPositions]])];
   rank = Which[
     baseCount === 0, 0,
     matrix === {}, 0,
     True, MatrixRank[matrix]
     ];
   ruleCompleteQ = TrueQ[rank === baseCount] && unsupportedPositions === {};
   If[ruleCompleteQ && baseCount > 0,
    rowSelection = independentKinematicRows[matrix, baseCount];
    baseRHS = Expand[LinearSolve[matrix[[rowSelection]], rhs[[rowSelection]]]];
    resolvedRules = Thread[Lookup[baseData, "inputExpression"] -> baseRHS];
    constraintResiduals = DeleteCases[Together /@ Expand[matrix . baseRHS - rhs], 0]
    ];
   If[baseCount === 0, resolvedRules = {}];
   userVariables = DeleteDuplicates[Flatten[Variables /@ (Last /@ normalizedRules)]];
   If[ruleCompleteQ && baseCount > 0,
    parameterJacobian = Table[D[baseRHS[[i]], userVariables[[j]]], {i, baseCount}, {j, Length[userVariables]}];
    parameterRank = If[userVariables === {}, 0, MatrixRank[parameterJacobian]]
    ];
   completeQ = ruleCompleteQ && TrueQ[parameterRank === baseCount || baseCount === 0];
   ruleMissingDirections = Which[
     baseCount === 0, {},
     matrix === {}, IdentityMatrix[baseCount],
     True, NullSpace[matrix]
     ];
   parameterMissingDirections = If[
     baseCount === 0 || ! ruleCompleteQ,
     {},
     NullSpace[Transpose[parameterJacobian]]
     ];
   missingDirections = DeleteDuplicates@Join[ruleMissingDirections, parameterMissingDirections];
   ruleDependencies = If[matrix === {}, {}, NullSpace[Transpose[matrix]]];
   parameterDependencies = If[parameterJacobian === {} || userVariables === {}, {}, NullSpace[parameterJacobian]];
   (* 零空间向量本身用于严格秩门禁；同时按固定基础坐标顺序给出可读组合，
      便于用户直接定位缺少或被约束的运动学方向。 *)
   ruleMissingDirectionExpressions = Expand[# . baseExpressions] & /@ ruleMissingDirections;
   parameterMissingDirectionExpressions = Expand[# . baseExpressions] & /@ parameterMissingDirections;
   ruleDependencyResiduals = If[ruleDependencies === {}, {}, Together[Expand[# . rhs]] & /@ ruleDependencies];
   overcompleteQ = completeQ && (
      Length[normalizedRules] > baseCount || Length[userVariables] > baseCount ||
       ruleDependencies =!= {} || parameterDependencies =!= {} || constraintResiduals =!= {}
      );
   inverseAvailableQ = completeQ && ! overcompleteQ && And @@ (simpleKinematicInverseQ /@ baseRHS);
   loopCount = Length[defaultExternalInvariantRulesForTopology[topo]];
   occurrenceData = externalLegMagnitudeOccurrenceData[topo];
   bindingCoordinates = If[
     Length[baseRHS] === baseCount,
     baseRHS,
     Lookup[baseData, "defaultRHS", {}]
     ];
   dependentBindings = Map[
     Function[data,
      With[{squared = Expand[Lookup[data, "baseCoefficients", {}] . bindingCoordinates]},
       <|
        "momentum" -> Lookup[data, "momentum"],
        "squaredExpression" -> Lookup[data, "squaredExpression"],
        "userSquaredExpression" -> squared,
        "userMagnitudeExpression" -> kinematicRootExpression[squared]
        |>
       ]
      ],
     Select[occurrenceData, ! TrueQ[Lookup[#, "independentQ", False]] &]
     ];
   <|
    "status" -> Which[! completeQ, "incomplete", overcompleteQ, "overcomplete", True, "complete"],
    "source" -> source,
    "baseCoordinateData" -> baseData,
    "baseCoordinateOrder" -> baseExpressions,
    "baseCoordinateCount" -> baseCount,
    "defaultRules" -> Thread[Lookup[baseData, "inputExpression"] -> Lookup[baseData, "defaultRHS"]],
    "selectionTemplate" -> ("kinematicRules" -> Thread[Lookup[baseData, "inputExpression"] -> Lookup[baseData, "defaultRHS"]]),
    "selectedRules" -> normalizedRules,
    "selectedUserVariables" -> userVariables,
    "userParameterOrder" -> userVariables,
    "coordinateMatrix" -> matrix,
    "coordinateRank" -> rank,
    "parameterJacobian" -> parameterJacobian,
    "parameterRank" -> parameterRank,
    "missingDirections" -> missingDirections,
    "ruleMissingDirections" -> ruleMissingDirections,
    "parameterMissingDirections" -> parameterMissingDirections,
    "ruleMissingDirectionExpressions" -> ruleMissingDirectionExpressions,
    "parameterMissingDirectionExpressions" -> parameterMissingDirectionExpressions,
    "ruleDependencies" -> ruleDependencies,
    "ruleDependencyResiduals" -> ruleDependencyResiduals,
    "parameterDependencies" -> parameterDependencies,
    "constraintResiduals" -> constraintResiduals,
    "unsupportedRulePositions" -> unsupportedPositions,
    "completeQ" -> completeQ,
    "overcompleteQ" -> overcompleteQ,
    "inverseAvailableQ" -> inverseAvailableQ,
    "resolvedRules" -> resolvedRules,
    "baseSquaredUserExpressions" -> baseRHS,
    "baseRootUserExpressions" -> (kinematicRootExpression /@ baseRHS),
    "appearingNoLoopMagnitudeMomenta" -> Lookup[occurrenceData, "momentum", {}],
    "independentNoLoopMagnitudeMomenta" -> Lookup[
      Select[occurrenceData, TrueQ[Lookup[#, "independentQ", False]] &],
      "momentum",
      {}
      ],
    "dependentMagnitudeBindings" -> dependentBindings,
    "rawLoopRules" -> Take[resolvedRules, UpTo[loopCount]],
    "resolvedLoopRules" -> Take[resolvedRules, UpTo[loopCount]],
    "rawExternalLegRules" -> Drop[resolvedRules, Min[loopCount, Length[resolvedRules]]],
    "resolvedExternalLegRules" -> Drop[resolvedRules, Min[loopCount, Length[resolvedRules]]],
    "message" -> Which[
      ! completeQ, "动力学变量不完备；零空间向量及其按 baseCoordinateOrder 展开的表达式给出未覆盖或受约束方向。",
      overcompleteQ, "动力学变量过完备；允许继续生成 IBP，但冗余变量 ds 与 rep2innerform 被禁用，constraintResiduals 给出需在 family 定义中实现的关系。",
      inverseAvailableQ, "动力学变量完备，且当前简单坐标规则可反向转换。",
      True, "动力学变量完备，Jacobian 链式偏导可用；一般混合坐标不提供 rep2innerform。"
      ]
    |>
   ];


resolveKinematicRulesForCase[case_Association, topo_Association] := Module[
   {combined, loopRules, legRules, selected},
   combined = Lookup[case, "kinematicRules", Automatic];
   If[combined =!= Automatic,
    Return[kinematicCoordinateAudit[topo, normalizeKinematicRuleList[combined], "kinematicRules"]]
    ];
   loopRules = normalizeExternalInvariantRulesForTopology[
     Lookup[case, "rawExternalInvariantRules", Lookup[case, "externalInvariantRules", Automatic]],
     topo
     ];
   legRules = normalizeExternalLegInvariantRulesForTopology[
     Lookup[case, "rawExternalLegInvariantRules", Lookup[case, "externalLegInvariantRules", Automatic]],
     topo
     ];
   selected = Join[loopRules, legRules];
   kinematicCoordinateAudit[topo, selected, If[
     Lookup[case, "externalInvariantRules", Automatic] === Automatic && Lookup[case, "externalLegInvariantRules", Automatic] === Automatic,
     "default",
     "legacyFields"
     ]]
   ];


normalizeExternalLegInvariantRulesForTopology[Automatic, topo_Association] :=
  defaultExternalLegInvariantRulesForTopology[topo];
normalizeExternalLegInvariantRulesForTopology[rules_Association, topo_Association] :=
  normalizeExternalLegInvariantRulesForTopology[Normal[rules], topo];
normalizeExternalLegInvariantRulesForTopology[rules_List, topo_Association] := Module[
   {defaults = defaultExternalLegInvariantRulesForTopology[topo], validRules},
   validRules = Select[rules, validReplacementRuleQ] /. Rule[Sqrt[lhs_], rhs_] :> Rule[lhs, rhs^2];
   Normal[Association[Join[defaults, validRules]]]
   ];
normalizeExternalLegInvariantRulesForTopology[_, topo_Association] :=
  defaultExternalLegInvariantRulesForTopology[topo];


rootCoordinateSymbol[expr_] := Replace[
   Unevaluated[expr],
   HoldPattern[Power[s_Symbol, 2]] :> s,
   {0}
   ];


rootCoordinateExpressionQ[expr_] := MatchQ[Unevaluated[expr], HoldPattern[Power[_Symbol, 2]]];


externalLegMagnitudeBindingData[topo_Association] := Module[
   {audit, squaredCoordinates, defaultCoordinates},
   audit = Lookup[topo, "kinematicCoordinateAudit", <||>];
   defaultCoordinates = Lookup[externalLegMagnitudeBasisAnalysis[topo], "defaultSquaredCoordinates", {}];
   squaredCoordinates = Lookup[audit, "baseSquaredUserExpressions", defaultCoordinates];
   If[Length[squaredCoordinates] =!= Length[defaultCoordinates], squaredCoordinates = defaultCoordinates];
   Map[
    Function[data,
     With[{squared = Expand[Lookup[data, "baseCoefficients", {}] . squaredCoordinates]},
      Join[data, <|
        "userSquaredExpression" -> squared,
        "userMagnitudeExpression" -> kinematicRootExpression[squared]
        |>]
      ]
     ],
    externalLegMagnitudeOccurrenceData[topo]
    ]
   ];


externalLegRootInputRules[topo_Association] := Map[
   Lookup[#, "magnitudeExpression"] -> Lookup[#, "userMagnitudeExpression"] &,
   externalLegMagnitudeBindingData[topo]
   ];


externalLegSquaredInputRules[topo_Association] := Map[
   Lookup[#, "squaredExpression"] -> Lookup[#, "userSquaredExpression"] &,
   externalLegMagnitudeBindingData[topo]
   ];


(* 圈外 external-leg 点积先被替换为独立 sE 坐标；剩余 sp 才进入 loop qq/qk/kk 展开。 *)
scalarProductSPInputToInternal[expr_, topo_Association] := Expand[
   expr /.
      externalLegRootInputRules[topo] /.
      externalLegSquaredInputRules[topo] /.
      HoldPattern[sp[p_, r_]] :> expandDotExpr[p, r, topo]
   ];


(* ::Section::Closed:: *)
(*外不变量坐标记录与内外转换*)

externalInvariantCoordinateData[topo_Association] := Module[
   {rules = externalInvariantInternalToUserRules[topo]},
   rules /. Rule[internal_, public_] :> Module[
      {rootQ = rootCoordinateExpressionQ[public], user},
      user = If[rootQ, rootCoordinateSymbol[public], public];
      <|
       "internalVariable" -> internal,
       "publicExpression" -> public,
       "userVariable" -> user,
       "coordinateType" -> If[rootQ, "squareRoot", "legacySquaredInvariant"],
       "internalCoordinateExpression" -> If[rootQ, Sqrt[internal], internal],
       "internalJacobian" -> If[rootQ, 2 Sqrt[internal], 1],
       "userJacobian" -> If[rootQ, 2 user, 1]
       |>
      ]
   ];


externalLegInvariantCoordinateData[topo_Association] := Module[
   {rules = Lookup[topo, "externalLegInvariantRules", defaultExternalLegInvariantRulesForTopology[topo]], magnitudeData},
   magnitudeData = externalLegMagnitudeData[topo];
   rules /. Rule[scalarProduct_, public_] :> Module[
       {rootQ = rootCoordinateExpressionQ[public], user, source},
       user = If[rootQ, rootCoordinateSymbol[public], public];
       source = SelectFirst[magnitudeData, SameQ[Lookup[#, "squaredExpression"], scalarProduct] &, <||>];
       Join[source, <|
        "scalarProduct" -> scalarProduct,
        "publicExpression" -> public,
        "userVariable" -> user,
        "coordinateType" -> If[rootQ, "externalLegSquareRoot", "externalLegLegacy"],
        "userJacobian" -> 1
        |>]
       ]
   ];


resolveExternalInvariantCoordinate[topo_Association, variable_] := SelectFirst[
   externalInvariantCoordinateData[topo],
   SameQ[variable, Lookup[#, "userVariable"]] ||
     SameQ[variable, Lookup[#, "internalVariable"]] ||
     SameQ[variable, Lookup[#, "internalCoordinateExpression"]] &,
   Missing["UnknownExternalInvariantCoordinate", variable]
   ];


externalInvariantUserToInternalRules[topo_Association] := DeleteDuplicates@Flatten[
   Function[data,
     {
      data["publicExpression"] -> data["internalVariable"],
      data["userVariable"] -> data["internalCoordinateExpression"]
      }
     ] /@ externalInvariantCoordinateData[topo]
   ];


rootCoordinateOutputRules[topo_Association] := Flatten@Cases[
   externalInvariantCoordinateData[topo],
   data_Association /; data["coordinateType"] === "squareRoot" :> With[
     {root = data["userVariable"]},
     {
      HoldPattern[Power[Power[root, 2], power_Rational]] :> root^(2 power),
      HoldPattern[Sqrt[root^2]] :> root
      }
     ]
   ];


scalarProductInternalToUser[expr_, topo_Association] := Module[
   {loops = topo["loopMomenta"], exts = topo["externalMomenta"], result},
   result = expr /. Join[
       externalInvariantInternalToUserRules[topo],
       {
        HoldPattern[qq[i_Integer, j_Integer]] :> sp[loops[[i]], loops[[j]]],
        HoldPattern[qk[i_Integer, j_Integer]] :> sp[loops[[i]], exts[[j]]]
        }
       ];
   Expand[result /. rootCoordinateOutputRules[topo]]
   ];


scalarProductInputToInternal[expr_, topo_Association] := Expand[
   scalarProductSPInputToInternal[expr, topo] /. externalInvariantUserToInternalRules[topo]
   ];


externalInvariantNamingReport[topo_Association] := <|
   "externalMomenta" -> Lookup[topo, "externalMomenta", {}],
   "externalInvariantRules" -> Lookup[topo, "externalInvariantRules", defaultExternalInvariantRulesForTopology[topo]],
   "internalExternalInvariantRules" -> externalInvariantInternalToUserRules[topo],
   "coordinateData" -> externalInvariantCoordinateData[topo],
   "defaultNamingConvention" -> "ssij = Sqrt[sp[k_i,k_j]], where i<=j follows externalMomenta order",
   "message" -> "externalMomenta 是进入内线偏移的独立向量；内部仍用 kk[i,j]=sp[k_i,k_j]，015 公开缺省坐标为 ssij。"
   |>;


externalLegInvariantNamingReport[topo_Association] := <|
   "externalLegMomenta" -> Lookup[topo, "externalLegMomenta", {}],
   "appearingMagnitudeMomenta" -> Lookup[externalLegMagnitudeOccurrenceData[topo], "momentum", {}],
   "independentMagnitudeMomenta" -> Lookup[externalLegMagnitudeData[topo], "momentum", {}],
   "dependentMagnitudeBindings" -> Map[
     KeyTake[#, {"momentum", "squaredExpression", "userSquaredExpression", "userMagnitudeExpression"}] &,
     Select[externalLegMagnitudeBindingData[topo], ! TrueQ[Lookup[#, "independentQ", False]] &]
     ],
   "externalLegInvariantRules" -> Lookup[topo, "externalLegInvariantRules", defaultExternalLegInvariantRulesForTopology[topo]],
   "coordinateData" -> externalLegInvariantCoordinateData[topo],
   "defaultNamingConvention" -> "sE1,sE2,... follow the first-occurrence independent basis of no-loop momentum magnitudes in lineData, vertexEnergies and extLegs",
   "automaticCrossProducts" -> False,
   "entersLoopIBPGenerators" -> False,
   "entersISPClosure" -> False
   |>;


(* ::Section::Closed:: *)
(*数值规则与初始化 metadata*)

normalizeNumericRuleForTopology[rule : (Rule | RuleDelayed)[lhs_, rhs_], topo_Association] := Module[
   {coordinate = resolveExternalInvariantCoordinate[topo, lhs], internalLHS},
   If[AssociationQ[coordinate] && SameQ[lhs, coordinate["userVariable"]],
    Return[coordinate["internalVariable"] -> If[coordinate["coordinateType"] === "squareRoot", rhs^2, rhs]]
    ];
   internalLHS = scalarProductInputToInternal[lhs, topo];
   internalLHS -> rhs
   ];


normalizeNumericRulesForTopology[rules_List, topo_Association] :=
  normalizeNumericRuleForTopology[#, topo] & /@ rules;
normalizeNumericRulesForTopology[rules_, _Association] := rules;


normalizeCoefficientRulesForTopology[rules_List, topo_Association] :=
  normalizeNumericRulesForTopology[rules, topo];
normalizeCoefficientRulesForTopology[rules_, _Association] := rules;


userNumericRules[topo_Association] := Lookup[
   topo,
   "rawNumericRules",
   topo["numericRules"] /. (Rule | RuleDelayed)[lhs_, rhs_] :> Rule[scalarProductInternalToUser[lhs, topo], rhs]
   ];


externalInvariantUserVariables[topo_Association] := Lookup[externalInvariantCoordinateData[topo], "userVariable", {}];


numericRuleVariableToUser[variable_, topo_Association] := Module[
   {coordinate = SelectFirst[externalInvariantCoordinateData[topo], SameQ[variable, #["internalVariable"]] &, Missing["NotFound"]]},
   If[AssociationQ[coordinate], coordinate["userVariable"], scalarProductInternalToUser[variable, topo]]
   ];


numericRuleRequirementReport[topo_Association] := Module[
   {provided, external, vertex, line, required, missingExternal, missingVertex, missingLine, missingAll, toUser},
   provided = numericRuleLHSVariables[topo];
   external = externalInvariantVariables[topo];
   vertex = vertexEnergyVariables[topo];
   line = lineParameterVariables[topo];
   required = DeleteDuplicates[Join[external, vertex, line]];
   missingExternal = Complement[external, provided];
   missingVertex = Complement[vertex, provided];
   missingLine = Complement[line, provided];
   missingAll = Complement[required, provided];
   toUser[list_] := numericRuleVariableToUser[#, topo] & /@ list;
   <|
    "providedNumericVariables" -> (First /@ userNumericRules[topo]),
    "internalProvidedNumericVariables" -> provided,
    "requiredExternalInvariants" -> toUser[external],
    "internalRequiredExternalInvariants" -> external,
    "externalInvariantNamingReport" -> externalInvariantNamingReport[topo],
    "externalLegInvariantNamingReport" -> externalLegInvariantNamingReport[topo],
    "vertexEnergyNamingReport" -> vertexEnergyNamingReport[topo],
    "requiredVertexEnergies" -> toUser[vertex],
    "internalRequiredVertexEnergies" -> vertex,
    "requiredLineParameters" -> line,
    "requiredNumericVariables" -> toUser[required],
    "internalRequiredNumericVariables" -> required,
    "missingExternalInvariants" -> toUser[missingExternal],
    "internalMissingExternalInvariants" -> missingExternal,
    "missingVertexEnergies" -> toUser[missingVertex],
    "internalMissingVertexEnergies" -> missingVertex,
    "missingLineParameters" -> missingLine,
    "missingNumericVariables" -> toUser[missingAll],
    "internalMissingNumericVariables" -> missingAll,
    "completeStaticNumericRulesQ" -> TrueQ[missingAll === {}]
    |>
   ];


(* ::Section::Closed:: *)
(*旧原子导数的保存与 Jacobian 包装*)

Options[makeAtomicExternalInvariantDerivativeDecomposition] = Options[makeExternalInvariantDerivativeDecomposition];
DownValues[makeAtomicExternalInvariantDerivativeDecomposition] =
  DownValues[makeExternalInvariantDerivativeDecomposition] /.
   makeExternalInvariantDerivativeDecomposition -> makeAtomicExternalInvariantDerivativeDecomposition;


Clear[makeExternalInvariantDerivativeDecomposition];
Options[makeExternalInvariantDerivativeDecomposition] = {
   ExternalInvariantCoordinateVariables -> Automatic,
   ExternalVectorOperatorBasis -> Automatic
   };
makeExternalInvariantDerivativeDecomposition::badvar =
  "变量 `1` 不在当前 ssij/legacy 外部不变量坐标中。";


makeExternalInvariantDerivativeDecomposition[topo_Association, variable_, OptionsPattern[]] := Module[
   {coordinate, atomic, scale, coefficients, gens, matrix, targetPos, residual},
   coordinate = resolveExternalInvariantCoordinate[topo, variable];
   If[! AssociationQ[coordinate],
    Message[makeExternalInvariantDerivativeDecomposition::badvar, variable];
    Return[<|"status" -> "badVariable", "targetVariable" -> variable|>]
    ];
   atomic = makeAtomicExternalInvariantDerivativeDecomposition[
     topo,
     coordinate["internalVariable"],
     ExternalInvariantCoordinateVariables -> externalInvariantVariables[topo],
     ExternalVectorOperatorBasis -> OptionValue[ExternalVectorOperatorBasis]
     ];
   If[Lookup[atomic, "status", "failed"] =!= "solved", Return[atomic]];
   scale = If[SameQ[variable, coordinate["internalVariable"]], 1, coordinate["internalJacobian"]];
   coefficients = Expand[scale Lookup[atomic, "coefficients", {}]];
   gens = Lookup[atomic, "operators", {}];
   matrix = Lookup[atomic, "matrix", {}];
   targetPos = First@FirstPosition[externalInvariantVariables[topo], coordinate["internalVariable"]];
   residual = Simplify[Expand[matrix . coefficients - scale UnitVector[Length[externalInvariantVariables[topo]], targetPos]]];
   Join[
    atomic,
    <|
     "targetVariable" -> If[scale === 1, coordinate["internalVariable"], coordinate["userVariable"]],
     "internalTargetVariable" -> coordinate["internalVariable"],
     "coordinateVariables" -> externalInvariantUserVariables[topo],
     "internalCoordinateVariables" -> externalInvariantVariables[topo],
     "coordinateType" -> coordinate["coordinateType"],
     "jacobian" -> If[scale === 1, 1, coordinate["userJacobian"]],
     "coefficientRules" -> Thread[externalVectorDerivativeLabel /@ gens -> coefficients],
     "coefficients" -> coefficients,
     "residual" -> residual
     |>
    ]
   ];


applyCompiledScalarMomentumDerivativeTerm[
   topo_Association, int_J, e_Integer, endpointSlot_Integer, term_Association
   ] := Module[{result, endpointVertex, xPower = term["xPower"]},
   endpointVertex = topo["lines"][[e, "endpoints", endpointSlot]];
   result = setLinePackEntry[int, e, endpointSlot + 1, term["targetState"]];
   result = shiftLineB[result, e, -xPower];
   result = shiftVertexA[result, topo, endpointVertex, xPower + 1];
   term["coefficient"] result
   ];


compiledScalarMomentumEndpointDerivativeTerms[
   topo_Association, int_J, e_Integer, endpointSlot_Integer
   ] := Module[{state, terms},
   state = int[[2, e, endpointSlot + 1]];
   terms = Lookup[lineCompiledFunctionSystem[topo["lines"][[e]]], "derivativeTerms", {}];
   Total[
    KroneckerDelta[state, Lookup[#, "sourceState", Missing["NoSourceState"]]] *
       applyCompiledScalarMomentumDerivativeTerm[topo, int, e, endpointSlot, #] & /@ terms
    ]
   ];


scalarMomentumBuildingBlockDerivativeTerms[topo_Association, int_J, e_Integer] := Module[
   {line = topo["lines"][[e]], packType, sigma},
   packType = actualLinePackType[topo, e, int[[2, e]]];
   Switch[packType,
    "massiveFull" | "massiveCross",
    Total[compiledScalarMomentumEndpointDerivativeTerms[topo, int, e, #] & /@ {1, 2}],
    "masslessFull",
    sigma = masslessFullSKSign[line];
    -I sigma shiftVertexA[toggleMasslessLineState[int, e], topo, line["endpoints"][[1]], 1] +
     I sigma shiftVertexA[toggleMasslessLineState[int, e], topo, line["endpoints"][[2]], 1],
    "masslessCross",
    Total@Table[
      -I skEndpointPhaseSign[line, endpointSlot] shiftVertexA[
        int, topo, line["endpoints"][[endpointSlot]], 1
        ],
      {endpointSlot, 2}
      ],
    _,
    0
    ]
   ];


externalLegMagnitudeOccurrenceLineDerivativeSeed[topo_Association, int_J, coordinate_Association] := Module[
   {momentum = Lookup[coordinate, "momentum", Missing["NoMomentum"]], matchingLines},
   If[Head[momentum] === Missing, Return[0]];
   matchingLines = Flatten@Position[
      Lookup[topo["lines"], "momentum", {}],
      lineMomentum_ /; SameQ[canonicalExternalLegMomentum[lineMomentum], canonicalExternalLegMomentum[momentum]],
      {1},
      Heads -> False
      ];
   Total@Table[
     -linePowerIndex[topo, int, e] shiftLineB[int, e, 1] +
      scalarMomentumBuildingBlockDerivativeTerms[topo, int, e],
     {e, matchingLines}
     ]
   ];


externalLegMagnitudeLineDerivativeSeed[topo_Association, int_J, coordinate_Association] := Module[
   {variable = Lookup[coordinate, "userVariable", Missing["NoVariable"]]},
   If[Head[variable] === Missing, Return[0]];
   Total@Map[
     Function[data,
      D[Lookup[data, "userMagnitudeExpression", 0], variable] *
       externalLegMagnitudeOccurrenceLineDerivativeSeed[topo, int, data]
      ],
     externalLegMagnitudeBindingData[topo]
     ]
   ];


directVertexEnergyVariableDerivativeSeed[topo_Association, int_J, variable_] := Module[
   {coordinate, derivativeVariable, derivativeScale, vertices = activeAVertexIds[topo], derivative},
   coordinate = resolveExternalInvariantCoordinate[topo, variable];
   derivativeVariable = If[AssociationQ[coordinate], coordinate["internalVariable"], scalarProductInputToInternal[variable, topo]];
   derivativeScale = If[
     AssociationQ[coordinate] && ! SameQ[variable, coordinate["internalVariable"]],
     coordinate["internalJacobian"],
     1
     ];
   Total@Table[
     derivative = derivativeScale D[vertexExternalEnergy[topo, vertexId], derivativeVariable];
     If[zeroQ[derivative],
      0,
      -vertexExternalPhaseDerivativeCoefficient[topo, vertexId] derivative shiftVertexA[int, topo, vertexId, 1]
      ],
     {vertexId, vertices}
     ]
   ];


literalVertexEnergyVariableDerivativeSeed[topo_Association, int_J, variable_] := Module[
   {vertices = activeAVertexIds[topo], derivative},
   (* 用户混合坐标在 vertex energy 中只保留尚未吸收到 loop kk 原子的显式依赖；
      因而这里不把用户变量再次解析成 kk，避免和 loop 原子导数重复计数。 *)
   Total@Table[
     derivative = D[vertexExternalEnergy[topo, vertexId], variable];
     If[zeroQ[derivative],
      0,
      -vertexExternalPhaseDerivativeCoefficient[topo, vertexId] derivative shiftVertexA[int, topo, vertexId, 1]
      ],
     {vertexId, vertices}
     ]
   ];


externalLegMagnitudeDerivativeSeed[topo_Association, int_J, variable_] := Module[
   {coordinate},
   coordinate = SelectFirst[
     externalLegInvariantCoordinateData[topo],
     SameQ[Lookup[#, "userVariable", Missing["NoVariable"]], variable] &,
     Missing["NotFound"]
     ];
   If[! AssociationQ[coordinate], Return[directVertexEnergyVariableDerivativeSeed[topo, int, variable]]];
   Expand[
    externalLegMagnitudeLineDerivativeSeed[topo, int, coordinate] +
     directVertexEnergyVariableDerivativeSeed[topo, int, variable]
    ]
   ];


kinematicAtomicDerivativeData[topo_Association] := Module[
   {audit = Lookup[topo, "kinematicCoordinateAudit", <||>], baseData, squaredExpressions, rootExpressions},
   baseData = Lookup[audit, "baseCoordinateData", {}];
   squaredExpressions = Lookup[audit, "baseSquaredUserExpressions", {}];
   rootExpressions = Lookup[audit, "baseRootUserExpressions", {}];
   MapThread[
    Join[#1, <|"userSquaredExpression" -> #2, "userRootExpression" -> #3|>] &,
    {baseData, squaredExpressions, rootExpressions}
    ]
   ];


applyUserKinematicDerivativeSeed[topo_Association, int_J, variable_] := Module[
   {audit = Lookup[topo, "kinematicCoordinateAudit", <||>], atomicData, loopTerms, legTerms, phaseTerms},
   If[! TrueQ[Lookup[audit, "completeQ", False]] || TrueQ[Lookup[audit, "overcompleteQ", False]],
    Return[$Failed]
    ];
   atomicData = kinematicAtomicDerivativeData[topo];
   loopTerms = Total@Map[
      Function[data,
        If[Lookup[data, "kind", ""] =!= "loopExternalGram",
         0,
         D[data["userSquaredExpression"], variable] *
           applyExternalInvariantVariableDerivativeSeed[topo, int, data["internalVariable"]]
        ]
       ],
      atomicData
      ];
   If[! FreeQ[loopTerms, $Failed], Return[$Failed]];
   legTerms = Total@Map[
      Function[data,
       D[Lookup[data, "userMagnitudeExpression", 0], variable] *
        externalLegMagnitudeOccurrenceLineDerivativeSeed[topo, int, data]
       ],
      externalLegMagnitudeBindingData[topo]
      ];
   phaseTerms = literalVertexEnergyVariableDerivativeSeed[topo, int, variable];
   Expand[loopTerms + legTerms + phaseTerms]
   ];


applyIndependentVariableDerivativeSeed[topo_Association, int_J, variable_, opts : OptionsPattern[makeExternalInvariantDerivativeDecomposition]] := Module[
   {coordinate = resolveExternalInvariantCoordinate[topo, variable], atomic, selectedVariables},
   selectedVariables = Lookup[Lookup[topo, "kinematicCoordinateAudit", <||>], "selectedUserVariables", {}];
   If[MemberQ[selectedVariables, variable],
    Return[Expand[applyUserKinematicDerivativeSeed[topo, int, variable]]]
    ];
   If[AssociationQ[coordinate],
    atomic = applyExternalInvariantVariableDerivativeSeed[
      topo,
      int,
      coordinate["internalVariable"],
      FilterRules[{opts}, Options[makeExternalInvariantDerivativeDecomposition]]
      ];
    If[atomic === $Failed,
     $Failed,
     Expand[If[SameQ[variable, coordinate["internalVariable"]], 1, coordinate["internalJacobian"]] atomic]
     ],
    Expand[externalLegMagnitudeDerivativeSeed[topo, int, variable]]
    ]
   ];


(* ::Section::Closed:: *)
(*公开变量集合、DE 与初始化信息*)

independentVariableDerivativeVariables[topo_Association] := Module[
   {audit, selectedVariables, allKinematicVariables, vertexVariables, independentScalars},
   audit = Lookup[topo, "kinematicCoordinateAudit", <||>];
   allKinematicVariables = Lookup[audit, "selectedUserVariables", {}];
   selectedVariables = If[
     TrueQ[Lookup[audit, "completeQ", False]] && ! TrueQ[Lookup[audit, "overcompleteQ", False]],
     Lookup[audit, "selectedUserVariables", {}],
     {}
     ];
   vertexVariables = DeleteDuplicates@Flatten[
      Variables[scalarProductInternalToUser[vertexExternalEnergy[topo, #], topo]] & /@ activeAVertexIds[topo]
      ];
   independentScalars = Complement[
     vertexVariables,
      allKinematicVariables
      ];
   DeleteDuplicates@Join[selectedVariables, independentScalars]
   ];


independentVariableDerivativeKind[topo_Association, variable_] := If[
   MemberQ[Lookup[Lookup[topo, "kinematicCoordinateAudit", <||>], "selectedUserVariables", {}], variable],
   "kinematicCoordinate",
   "vertexEnergy"
   ];


makeIndependentVariableDerivativeGenerators[topo_Association] := Map[
   Function[variable,
    Module[{coordinate = resolveExternalInvariantCoordinate[topo, variable]},
      If[MemberQ[Lookup[Lookup[topo, "kinematicCoordinateAudit", <||>], "selectedUserVariables", {}], variable],
       <|
        "variable" -> variable,
        "userVariable" -> variable,
        "internalVariable" -> variable,
        "kind" -> "kinematicCoordinate",
        "coordinateType" -> "userSelected",
         "atomicJacobian" -> (
           D[
              If[Lookup[#, "kind", ""] === "loopExternalGram",
               Lookup[#, "userSquaredExpression", 0],
               Lookup[#, "userRootExpression", 0]
               ],
              variable
              ] & /@ kinematicAtomicDerivativeData[topo]
           )
        |>,
      <|
       "variable" -> variable,
       "userVariable" -> variable,
       "internalVariable" -> variable,
       "kind" -> "vertexEnergy",
       "coordinateType" -> If[MemberQ[Lookup[externalLegInvariantCoordinateData[topo], "userVariable", {}], variable], "externalLegSquareRoot", "independentScalar"]
       |>
      ]
     ]
    ],
   independentVariableDerivativeVariables[topo]
   ];


dsDEResolveVariables[Automatic, context_Association] :=
  Lookup[makeIndependentVariableDerivativeGenerators[context["topology"]], "userVariable", {}];
dsDEResolveVariables[variable_List, _Association] := variable;
dsDEResolveVariables[variable_, _Association] := {variable};


dsConventionMetadata[topo_Association] := <|
   "vertexData" -> topo["vertexData"],
   "lineOrder" -> Lookup[topo["lines"], "id"],
   "lineConventions" -> Map[
     KeyTake[#, {"id", "massType", "packType", "state", "skType", "bbType", "thetaConvention", "functionSystem", "compiledFunctionSystem"}] &,
     topo["lines"]
     ],
   "zeroPointRules" -> topo["zeroPointRules"],
   "shrinkPrefactorRules" -> topo["shrinkPrefactorRules"],
   "symmetryRules" -> topo["symmetryRules"],
   "effectiveSymmetryRules" -> Lookup[topo, "effectiveSymmetryRules", effectiveSymmetryRules0[topo]],
   "tadpoleSymmetryData" -> Lookup[topo, "tadpoleSymmetryData", tadpoleSymmetryData[topo]],
   "externalInvariantRules" -> topo["externalInvariantRules"],
   "externalLegInvariantRules" -> Lookup[topo, "externalLegInvariantRules", {}],
   "externalInvariantCoordinateData" -> externalInvariantCoordinateData[topo],
    "externalLegInvariantCoordinateData" -> externalLegInvariantCoordinateData[topo],
    "kinematicCoordinateAudit" -> Lookup[topo, "kinematicCoordinateAudit", <||>],
    "independentVariables" -> independentVariableDerivativeVariables[topo],
    "defaultDerivativeCoordinates" -> "ssij for the complete loop-external Gram basis; sE1,sE2,... for the first-occurrence independent basis of actually appearing no-loop momentum magnitudes",
   "loopTreeProjection" -> <|
     "vertexPhysicalPower" -> "a+a0 becomes tree a+nu0",
     "linePhysicalPower" -> "removed b+b0 or bS+bS0 becomes an explicit energy power",
     "normalization" -> "relative to the reference loop integral, term by term",
     "unsafePowerExpand" -> False
     |>
   |>;


vertexEnergyNamingReport[topo_Association] := Module[
   {vertices = activeAVertexIds[topo], raw, internal, user, dependencies},
   raw = AssociationThread[vertices -> (rawVertexExternalEnergy[topo, #] & /@ vertices)];
   internal = AssociationThread[vertices -> (vertexExternalEnergy[topo, #] & /@ vertices)];
   user = AssociationThread[vertices -> (scalarProductInternalToUser[vertexExternalEnergy[topo, #], topo] & /@ vertices)];
   dependencies = AssociationThread[vertices -> (vertexEnergyDependencyData[topo, #] & /@ vertices)];
   <|
     "convention" -> "loop external roots use ssij; the independent basis of actually appearing no-loop momentum magnitudes uses sEe variables and dependent magnitudes keep explicit bindings; unrelated scalar phase parameters remain explicit user symbols",
    "rawVertexEnergies" -> raw,
    "internalVertexEnergies" -> internal,
    "userVertexEnergies" -> user,
    "dependencyData" -> dependencies,
    "externalLegInvariantNamingReport" -> externalLegInvariantNamingReport[topo],
     "message" -> "vertexEnergies 可使用 loop-external Gram 根号或实际出现的无圈动量模长；015 不自动生成外腿向量之间的交叉点积。无圈动量变量不进入 loop IBP/ISP。"
     |>
    ];


(* ::Section::Closed:: *)
(*公开动力学变量提案与重选审计*)

DSKinematics[input_Association, rules_: Automatic] := Module[
   {effectiveInput, topo, audit, status},
   effectiveInput = If[rules === Automatic, input, Join[input, <|"kinematicRules" -> rules|>]];
   topo = parseTopology[effectiveInput];
   If[topo === $Failed,
    Return[<|"status" -> "failed", "reason" -> "invalidTopologyInput"|>]
    ];
   audit = Lookup[topo, "kinematicCoordinateAudit", <||>];
   status = Lookup[audit, "status", "unknown"];
   dsInfoPrint[
     "动力学变量提案：" <> ToString[Lookup[audit, "defaultRules", {}], InputForm] <>
      "；当前选择：" <> ToString[Lookup[audit, "selectedRules", {}], InputForm] <>
      "；从属模长绑定：" <> ToString[Lookup[audit, "dependentMagnitudeBindings", {}], InputForm] <>
      "；审计状态 " <> ToString[status],
     Automatic
     ];
   Switch[status,
    "incomplete",
    dsWarningPrint[
      "动力学变量不完备；缺失/受约束方向为 " <>
       ToString[DeleteDuplicates@Join[
          Lookup[audit, "ruleMissingDirectionExpressions", {}],
          Lookup[audit, "parameterMissingDirectionExpressions", {}]
          ], InputForm],
      Automatic
      ],
    "overcomplete",
    dsWarningPrint[
      "动力学变量过完备；IBP 可继续，但冗余坐标 ds 与 rep2innerform 已禁用。约束残差为 " <>
       ToString[Lookup[audit, "constraintResiduals", {}], InputForm],
      Automatic
      ],
    _, Null
    ];
   audit
   ];


DSKinematics[input_, rules_: Automatic] := <|
   "status" -> "failed",
   "reason" -> "inputNotAssociation",
   "input" -> HoldForm[input],
   "rules" -> HoldForm[rules]
   |>;

End[];
EndPackage[];
