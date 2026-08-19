(* ::Package:: *)

(* ::Chapter:: *)
(*公开上下文与接口声明*)

BeginPackage["dSIBP`"];

$dSIBPVersion::usage = "$dSIBPVersion 给出当前加载的 dSIBP package 发布号。";
AuditLevel::usage = "AuditLevel 控制同源数据是否重跑完整开发证书；\"standard\" 复用 sealed producer 状态，\"full\" 重算内容 hash、coverage、representation 或 residual 审计。";
KiraRequireCompleteSystem::usage = "KiraRequireCompleteSystem 指定 Kira 导出是否要求 completeSystemQ；正式约化缺省为 True。";

J::usage = "J 是统一积分 Head。full 模式使用 J[aList,linePacks,ispList]；timeOnly 公开接口只使用 J[sectorKey,timeShifts,stateBits]，其中 sectorKey 是 root propagator 顺序的定长 0/1 字符串。";
sp::usage = "sp[p,q] 是用户输入使用的对称标量积。";
qq::usage = "qq[i,j] 是内部圈动量标量积坐标。";
qk::usage = "qk[i,j] 是内部圈动量与外动量标量积坐标。";
kk::usage = "kk[i,j] 是内部外动量标量积坐标。";
a::usage = "a[v] 是 makeBaseIntegral 为顶点 v 建立的时间幂次整数指标。";
b::usage = "b[e] 是未缩并传播子 e 的分母幂次整数指标。";
bS::usage = "bS[e] 是缩并传播子 e 的分母幂次整数指标。";
n::usage = "n[e,...] 是 full-line 的二元离散态指标。";
ispN::usage = "ispN[i] 是第 i 个 ISP 坐标的整数幂次指标，定义零点固定为 0；正值为 numerator 幂，用户显式给出的负值表示该坐标的额外 denominator，package 不阻断。";
a0::usage = "a0[v] 是顶点时间幂次零点；物理幂次为 a+a0。";
b0::usage = "b0[e] 是未缩并传播子分母幂次零点；物理分母幂次为 b+b0。";
bS0::usage = "bS0[e] 是缩并传播子分母幂次零点；物理分母幂次为 bS+bS0。";
rho::usage = "rho[i] 是第 i 个 ISP 的内部坐标符号。";
dim::usage = "dim 是圈动量积分的空间维数参数。";
ke::usage = "ke[i] 是与动量向量无关的独立顶点相位能量参数；实际无圈动量模长由 independentExternalMomenta 依次绑定为 sE1,sE2,...。";
kEpower::usage = "kEpower[be1,be2,...] 是 sector metadata 中按 independentExternalMomenta 稳定顺序保存的无圈模长幂向量；当前参数表达式由同一 metadata 的 kEParameterExpressions 单独给出。";
tau::usage = "tau[v] 是 rep2Integrand 输出中的顶点共形时间。";
xi::usage = "xi[e] 是 rep2Integrand 输出中的第 e 条线的动量模。";
Hh::usage = "Hh[block] 是 rep2Integrand 使用的惰性传播子 building-block 包装。";
MassiveBlock::usage = "MassiveBlock[...] 是 massive line 的惰性 integrand block。";
MasslessBlock::usage = "MasslessBlock[...] 是同分支 massless line 的惰性 integrand block。";
MasslessCrossBlock::usage = "MasslessCrossBlock[...] 是异分支 massless line 的惰性 integrand block。";
Tuserweight::usage = "Tuserweight[id] 是 Kira user-defined system 结果中的积分编号 token。";
userMI::usage = "userMI[i] 是用户定义主积分坐标的稳定公开 token；其物理内容始终由同源 J 线性组合给出。";

dtau::usage = "dtau[vertex,expr] 生成指定顶点的时间 IBP；三参数形式接受 parsed topology 或 DSInit context。";
dqq::usage = "dqq[dLoop,vectorLoop,expr] 生成圈动量沿圈动量方向的 IBP；四参数形式接受 parsed topology 或 DSInit context。";
dqk::usage = "dqk[dLoop,vectorExternal,expr] 生成圈动量沿外动量方向的 IBP；四参数形式接受 parsed topology 或 DSInit context。";
ds::usage = "ds[expr,var] 对 exact 初始化 context 的外部变量 var 求总导数；三参数形式接受 parsed topology 或 DSInit context。018 缺省 var 为 loop Gram 根号 ssij 或显式独立无圈模长 sE1,sE2,...，并同时作用于积分指标、sector prefactor 和显式动力学系数。";
rep2innerform::usage = "rep2innerform[expr] 把用户 sp/ssij/sEe 表示转换为当前 topology 的内部坐标；双参数形式接受 parsed topology 或 DSInit context。一般混合或过完备坐标没有唯一反向映射时返回 $Failed。";
rep2outform::usage = "rep2outform[expr] 把内部标量积坐标按当前规则转换为用户 sp/ssij/sEe 表示；双参数形式接受 parsed topology 或 DSInit context。";
rep2Integrand::usage = "rep2Integrand[expr] 把统一 J 表示展开为用于核对的形式 integrand；双参数形式接受 parsed topology 或 DSInit context。";
symmetry::usage = "symmetry[expr,topo] 一次应用 topology 的内建、用户和 tadpole 对称性规则。";
repSymmetry0::usage = "repSymmetry0[topo] 返回 topology 输入的原始用户对称性规则。";
repIterative0::usage = "repIterative0 保存最近一次 tree 单步迭代生成的原始替换规则。";
repIterative::usage = "repIterative[expr,end] 把 tree 积分迭代约化到各顶点的目标时间幂次；sector-tagged treeLinearData 输入会保持 sector 身份并返回同结构约化结果，end 缺省为全零。";
DSTreeSeeds::usage = "DSTreeSeeds 直接生成带 sector/contact 审计的 pure-time/tree 种子；loop time-IBP 投影只保留为交叉验证。";
DSTreeNaiveIBP::usage = "DSTreeNaiveIBP[context,masters] 把 loop time-IBP 投影成 sector-tagged tree 线性系统，并在指定有序 master basis 下直接求解全部一步升幂对象；masters 缺省取 DSTreeDLogDE 的同序归一化 masters。";
DSTreeNaiveDE::usage = "DSTreeNaiveDE[context,variables,masters] 通过 loop 顶点相位导数投影、h 的传播子动量模长导数和 DSTreeNaiveIBP 约化构造 tree 微分方程；结果保持指定 master 顺序和 normalization。";
DSTreeDLogDE::usage = "DSTreeDLogDE[data] 返回 tree vertex-family 的 dlog 微分方程、同序 master 列表和 letters；DSInit context 输入使用 direct pure-time contact selectors 组装全部可达 sector 的 block-triangular connection、normalization 审计与同序 tagged masters。严格表示与 dlog residual 证书只在 AuditLevel->\"full\" 执行。";

DSInit::usage = "DSInit[input,opts] 验证 topology/ISP、初始化完整 contact-reachable sector，并可写出版本化 init metadata。";
DSInfo::usage = "DSInfo[] 返回当前初始化的简要信息；DSInfo[context,\"Full\"] 返回完整初始化 Association。";
DSKinematics::usage = "DSKinematics[input,rules] 返回 topology 的缺省动力学变量提案、全部必需模长覆盖、从属 binding、可复制的参数重定义格式，以及给定规则的秩、零空间、完备性和可逆性审计；rules 缺省读取 input 或使用自动提案。";
DSParameterNotation::usage = "DSParameterNotation[context] 返回圈外 Gram 根号、独立无圈模长、全部必需模长覆盖、当前用户变量规则及 DSRedefineParameters 的可复制示例；无参数形式读取当前 context。";
DSRedefineParameters::usage = "DSRedefineParameters[context,rules] 用新的完整动力学变量规则重新初始化并返回新 context；rules 左端写 baseCoordinateOrder 中的 sp[原始动量,...]，右端写自定义参数表达式，不写 ssij->custom；DSRedefineParameters[rules] 只在成功后更新当前 context。";
DSSeeds::usage = "DSSeeds[context,opts] 生成全部 contact-reachable sector、全部离散态的符号 canonical general templates；连续指标域由 DSGenerateIBP 指定，数值系数由 DSLinear 的 CoefficientRules 指定。";
DSAllSeeds::usage = "DSAllSeeds[seedData] 取出 DSSeeds 返回的一维 allSeeds 模板列表；DSAllSeeds[] 取最近一次成功生成的模板。模板已遍历 n_i=0,1 并执行 EOM/canonical，连续指标仍为 general。";
DSSeedGroups::usage = "DSSeedGroups[seedData] 返回 DSSeeds 按 {sectorKey,ibpClass,generator} 排列的嵌套 seedGroups；每个二级组包含该 IBP 算符的全部离散态模板。无参数形式读取最近结果。";
DSSeedGroupMetadata::usage = "DSSeedGroupMetadata[seedData] 返回与 DSSeedGroups 同序的 sector、IBP 类型、生成元、模板 ordinal 和计数。无参数形式读取最近结果。";
DSMetaSeedRange::usage = "DSMetaSeedRange[seeds,{indices...}] 按用户给定的 seeds 外层结构初始化逐组 seed shift metadata；flat seeds 作为一组，nested seeds 的每个顶层元素作为一组。积分参数先统一 Flatten，再由 Variables 审计实际指标。声明多余或遗漏只 warning，metadata 仍按实际完整集合建立；再次初始化覆盖旧状态。DSMetaSeedRange[] 返回当前状态。";
DSGenerateIBP::usage = "DSGenerateIBP[seeds,{min,max}] 把统一目标积分指标包络按已初始化的逐输入组 shift metadata 反推成 seed 点域；DSGenerateIBP[seeds,{index,min,max},...] 要求 root 指标 exact cover。用户可显式给负 ISP 下界；自动反推不会把 ISP seed 下界降到用户 target 下界以下。先筛 parity，再代入数值点生成 IBP；n_i 不得再次撒点。";
DSLinear::usage = "DSLinear[seedData,context,opts] 把 canonical seeds 转换为 backend-neutral linearData。";
DSReorderIntegrals::usage = "DSReorderIntegrals[linearData,order] 按用户给定的 J 或现有积分 ID 显式重排 linearData；其结果的 integralList 是后续 plan/export/import 的唯一积分顺序。";
DSUserMI::usage = "DSUserMI[linearData,expressions,spec] 构造并附加有序 userMI basis；expressions 可为单个 J 或齐次 J 线性组合。DSUserMI[data] 或 DSUserMI[data,key] 查询同源可逆映射、秩和 backend ID。";
DSKiraPlan::usage = "DSKiraPlan[linearData,spec] 按 linearData 的既定积分顺序生成 preReduction/formal 两阶段 Kira 计划；formal 计划先解析构造 active basis 一阶导数及最小 target closure。";
DSKiraExport::usage = "DSKiraExport[linearData,opts] 或 DSKiraExport[kiraPlan] 序列化 Kira 基础输入和同源 manifest；不会启动 Kira。缺省禁止数值化微分变量，只有已冻结解析导数闭包的 formal plan 可显式选择 postDerivative 数值阶段。";
DSKiraImport::usage = "DSKiraImport[path,context,opts] 导入并验证完整 Kira reduction、master 顺序和积分双向映射；完成日志只作诊断，实际 artifact identity 与结构闭合是硬边界。";
DSDE::usage = "DSDE[reductionData,variables,opts] 用 ds 和 reduction rules 构造保持 master 顺序的微分方程矩阵。";
DSScaleCheck::usage = "DSScaleCheck[deData,spec,opts] 检查约化后的 Euler/标度关系。";
DSMessagesOn::usage = "DSMessagesOn[] 开启 info、progress 和 warning 提醒。";
DSMessagesOff::usage = "DSMessagesOff[] 关闭可选提醒；fatal error 始终保留。";
DSMessagesQ::usage = "DSMessagesQ[] 返回可选提醒当前是否开启。";
DSPublicAPI::usage = "DSPublicAPI[] 返回当前版本需要用户掌握的公开函数、逻辑分组及各高层函数缺省选项；供手册附录和 example 覆盖门禁共同读取。";

WriteInitializationFiles::usage = "WriteInitializationFiles 是 DSInit 的选项；缺省 False。";
InitializationDirectory::usage = "InitializationDirectory 指定 init metadata 目录；缺省 Automatic，解析到调用脚本同目录的 init/。";
GenerateDerivativeMetadata::usage = "GenerateDerivativeMetadata 控制 DSInit 是否预生成独立变量微分算符 metadata；缺省 False。";
OverwriteInitialization::usage = "OverwriteInitialization 控制是否允许覆盖已有但输入哈希不一致的 init metadata；缺省 False。";
RegisterAsCurrent::usage = "RegisterAsCurrent 控制 DSInit 是否注册为无参公开接口的当前 context；缺省 True。";
ProgressReporting::usage = "ProgressReporting 控制单次高层调用的阶段进度；Automatic 跟随全局消息开关。";
KinematicRules::usage = "KinematicRules 是 DSInit 的可选动力学变量替换规则；缺省 Automatic 使用 input 中的 kinematicRules，若仍未给出则采用 DSKinematics 的缺省提案。";

PrecomputeShrinkSectorMetadata::usage = "PrecomputeShrinkSectorMetadata 控制底层是否预枚举 contact-reachable sector metadata。";
GenerateShrinkSectors::usage = "GenerateShrinkSectors 控制 canonical seed 是否生成 contact-reachable shrink sectors；高层完整工作流缺省 True。";
KiraOrdering::usage = "KiraOrdering 指定 backend-neutral linearData 的 Kira 排序约定。";
CoefficientRules::usage = "CoefficientRules 指定 linearData 层的小规模系数替换规则；DE 工作流不得直接或间接消去微分变量。";
LinearSystemMode::usage = "LinearSystemMode 选择 DSLinear 的 \"symbolic\" 或 \"numeric\" 模式。";
ExportKira::usage = "ExportKira 是底层组合工作流的导出开关；DSKiraExport 本身不运行 Kira。";
OutputDirectory::usage = "OutputDirectory 指定 serializer 输出目录；None 表示只返回内存数据。";
KiraCoefficientRules::usage = "KiraCoefficientRules 指定 Kira 导出前的系数规则；配置 KiraActiveBasis 时规则不得触及其 derivativeVariables。";
KiraTargetIntegrals::usage = "KiraTargetIntegrals 指定 Kira job 的目标积分。";
KiraActiveBasis::usage = "KiraActiveBasis 为 DSKiraExport 指定有序 active basis 线性组合、名称和导数变量；缺省 None。";
KiraNumericStage::usage = "KiraNumericStage 选择 \"symbolic\"（缺省，DE 变量不得数值化）或 \"postDerivative\"（只在 active basis 的解析一阶导数及 target closure 已构造后允许定点数值 reduction）。";
KiraJobOptions::usage = "KiraJobOptions 指定仅用于生成 Kira job 文件的选项 Association。";
KiraReductionFile::usage = "KiraReductionFile 指定 DSKiraImport 读取的 reduction 规则文件；缺省为 results/Tuserweight/kira_list.m。";
KiraMasterFile::usage = "KiraMasterFile 指定 DSKiraImport 读取的有序 master 文件；缺省为 results/Tuserweight/masters。";
KiraCompletionFile::usage = "KiraCompletionFile 指定 DSKiraImport 检查的完成日志；缺省为 kira.log。";
KiraCompletionPatterns::usage = "KiraCompletionPatterns 指定完成日志必须匹配的字符串或 RegularExpression 列表。";
ScalingRelation::usage = "ScalingRelation 指定 DSScaleCheck 使用的 \"Custom\"、\"LoopTopology\" 或 \"PureMassiveBubble\" 标度关系。";
ScalingVariables::usage = "ScalingVariables 指定 Euler 算符中的变量顺序。";
ScalingWeights::usage = "ScalingWeights 指定 Euler 算符中各变量的系数；018 的 ssij 与独立无圈模长 sEi 都是动量一次量，缺省物理权重为 1。";
ScalingDegrees::usage = "ScalingDegrees 指定各 master 的预期齐次次数；PureMassiveBubble 可设 Automatic。";

(* ::Chapter:: *)
(*私有实现加载*)

Begin["`Private`"];

$dSIBPPackageRoot = DirectoryName[DirectoryName[$InputFileName]];
$dSIBPVersion = "022.0";

(* ::Chapter:: *)
(*冻结单文件私有实现*)

(* ::Package:: *)
(* 本模块为 018 提供图论与动量声明审计。它不生成 IBP，只把 topology 的结构圈数、
   bridge/cycle line、圈动量 routing 以及两类用户外动量列表归一为可供 DSInit 门禁读取的 metadata。 *)

(* ::Chapter:: *)
(*基础线性代数工具*)

(* 只在精确代数意义下判零；本模块不使用数值容差决定 topology。 *)
ds016ZeroQ[expr_] := TrueQ[Together[Expand[expr]] === 0];


ds016MatrixRank[rows_List, width_Integer] := Which[
   rows === {}, 0,
   width === 0, 0,
   True, MatrixRank[rows]
   ];


ds016NonzeroRows[rows_List] := Select[rows, ! And @@ (ds016ZeroQ /@ #) &];


ds016RowBasis[rows_List, width_Integer] := If[
   rows === {} || width === 0,
   {},
   ds016NonzeroRows[RowReduce[rows]]
   ];


(* 按输入顺序选择使行空间增秩的对象；返回位置，便于同时保留来源表达式。 *)
ds016IndependentRowPositions[rows_List, initialRows_List : {}] := Module[
   {selected = {}, current = initialRows, rank, nextRank},
   rank = If[current === {}, 0, MatrixRank[current]];
   Do[
    nextRank = MatrixRank[Append[current, rows[[i]]]];
    If[nextRank > rank,
     AppendTo[selected, i];
     AppendTo[current, rows[[i]]];
     rank = nextRank
     ],
    {i, Length[rows]}
    ];
   selected
   ];


(* momentum 字段只允许由已识别向量原子及精确有理系数组成，避免把符号系数误猜成新向量。 *)
ds016MomentumAtoms[expressions_List, excluded_List : {}] := DeleteDuplicates@Cases[
    Unevaluated[expressions],
    symbol_Symbol /; Context[symbol] =!= "System`" && ! MemberQ[excluded, symbol],
    Infinity,
    Heads -> False
    ];


ds016LinearVectorData[expr_, atoms_List] := Module[{expanded, coefficients, residual, rationalQ},
   expanded = Expand[expr];
   coefficients = Coefficient[expanded, #] & /@ atoms;
   residual = Expand[expanded - coefficients . atoms];
   rationalQ = And @@ (MatchQ[#, _Integer | _Rational] & /@ coefficients);
   <|
    "expression" -> expanded,
    "coefficients" -> coefficients,
    "residual" -> residual,
    "linearQ" -> TrueQ[ds016ZeroQ[residual] && rationalQ]
    |>
   ];


ds016RowsForExpressions[expressions_List, atoms_List] := Lookup[
   ds016LinearVectorData[#, atoms] & /@ expressions,
   "coefficients",
   {}
   ];


ds016DirectionExpressions[rows_List, atoms_List] := Expand[# . atoms] & /@ rows;


(* Lookup[{},key,default] 会把空表误解为规则集合并返回 Missing；线性审计中的空数据必须是零行集。 *)
ds016DataColumn[data_List, key_String] := If[data === {}, {}, Lookup[data, key, {}]];


(* ::Chapter:: *)
(*多重图圈数与 bridge 分类*)

(* 连通分量只使用不同端点间的边；自环不改变连通性，但在 E-V+C 中自然贡献一圈。
   两顶点间的一条普通边给 L=1-2+1=0；真正的 tadpole 必须显式写成 endpoints->{v,v}，给 L=1-1+1=1。 *)
ds016ComponentCount[vertexIds_List, endpoints_List] := Module[{edges, graph},
   edges = (UndirectedEdge @@ # &) /@ Select[endpoints, Length[#] === 2 && ! SameQ @@ # &];
   graph = Graph[vertexIds, edges];
   Length[ConnectedComponents[graph]]
   ];


ds016TopologyGraphAudit[vertexIds_List, lines_List] := Module[
   {endpoints, activeLineIndices, activeEndpoints, malformed, unknown, componentCount, loopCount,
    bridgeLines, cycleLines, incidence},
   endpoints = Lookup[lines, "endpoints", Missing["endpoints"]];
   activeLineIndices = Select[
     Range[Length[lines]],
     Lookup[lines[[#]], "state", "full"] =!= "shrunk" && Lookup[lines[[#]], "packType", Automatic] =!= "shrunk" &
     ];
   activeEndpoints = If[activeLineIndices === {}, {}, endpoints[[activeLineIndices]]];
   malformed = Flatten@Position[endpoints, item_ /; ! ListQ[item] || Length[item] =!= 2, {1}, Heads -> False];
   unknown = If[malformed === {}, Complement[DeleteDuplicates@Flatten[endpoints], vertexIds], {}];
   If[malformed =!= {} || unknown =!= {},
    Return[<|
      "status" -> "invalid",
      "issues" -> DeleteCases[{
         If[malformed === {}, Nothing, <|"code" -> "malformedEndpoints", "lineIndices" -> malformed|>],
         If[unknown === {}, Nothing, <|"code" -> "unknownEndpointVertices", "vertices" -> unknown|>]
         }, Nothing]
      |>]
    ];
   componentCount = ds016ComponentCount[vertexIds, activeEndpoints];
   loopCount = Length[activeLineIndices] - Length[vertexIds] + componentCount;
   bridgeLines = Select[
     activeLineIndices,
     ! SameQ @@ endpoints[[#]] &&
       ds016ComponentCount[vertexIds, endpoints[[DeleteCases[activeLineIndices, #]]]] > componentCount &
     ];
   cycleLines = Complement[activeLineIndices, bridgeLines];
   incidence = Table[
     Which[
      ! MemberQ[activeLineIndices, e], 0,
      SameQ @@ endpoints[[e]], 0,
      vertexIds[[v]] === endpoints[[e, 1]], 1,
      vertexIds[[v]] === endpoints[[e, 2]], -1,
      True, 0
      ],
     {v, Length[vertexIds]}, {e, Length[lines]}
     ];
   <|
    "status" -> "valid",
    "vertexCount" -> Length[vertexIds],
    "inputLineCount" -> Length[lines],
    "internalLineCount" -> Length[activeLineIndices],
    "activeLineIndices" -> activeLineIndices,
    "shrunkLineIndices" -> Complement[Range[Length[lines]], activeLineIndices],
    "connectedComponentCount" -> componentCount,
    "graphLoopCount" -> loopCount,
    "bridgeLineIndices" -> bridgeLines,
    "cycleLineIndices" -> cycleLines,
    "selfLoopLineIndices" -> Select[activeLineIndices, SameQ @@ endpoints[[#]] &],
    "incidenceMatrix" -> incidence,
    "cycleSpaceDimension" -> Length[activeLineIndices] - MatrixRank[incidence],
    "issues" -> {}
    |>
   ];


ds016ResolveIBPMode[case_Association, graphLoopCount_Integer] := Module[{requested},
   requested = Lookup[case, "ibpMode", Automatic];
   Which[
    requested === Automatic && graphLoopCount === 0, "timeOnly",
    requested === Automatic, "full",
    MemberQ[{"full", "timeOnly"}, requested], requested,
    True, "invalid"
    ]
   ];


(* ::Chapter:: *)
(*圈动量 routing 与 affine shift 商空间*)

ds016RawISPExpressions[case_Association] := DeleteCases[
   Map[
    Which[
      AssociationQ[#], Lookup[#, "expr", Nothing],
      ListQ[#] && Length[#] >= 2, #[[2]],
      True, Nothing
      ] &,
    Lookup[case, "ispData", {}]
    ],
   Nothing
   ];


ds016ArgumentRoutingData[argument_, loopMomenta_List, referenceMatrix_, referenceResiduals_] := Module[
   {coefficients, residual, transformedResidual, inverse},
   coefficients = Coefficient[Expand[argument], #] & /@ loopMomenta;
   residual = Expand[argument - coefficients . loopMomenta];
   transformedResidual = residual;
   If[loopMomenta =!= {} && MatrixQ[referenceMatrix] && Length[referenceMatrix] === Length[loopMomenta],
    inverse = Inverse[referenceMatrix];
    transformedResidual = Expand[residual - coefficients . inverse . referenceResiduals]
    ];
   <|
    "argument" -> argument,
    "loopCoefficients" -> coefficients,
    "externalResidual" -> residual,
    "shiftInvariantResidual" -> transformedResidual,
    "containsLoopMomentumQ" -> AnyTrue[coefficients, ! ds016ZeroQ[#] &],
    "linearInLoopMomentaQ" -> FreeQ[residual, Alternatives @@ loopMomenta]
    |>
   ];


ds016ISPShiftInvariantDirections[case_Association, loopMomenta_List, referenceMatrix_, referenceResiduals_] := Module[
   {pairs, pairData},
   pairs = Cases[
     ds016RawISPExpressions[case],
     HoldPattern[sp[left_, right_]] :> {left, right},
     {0, Infinity}
     ];
   DeleteDuplicates@Flatten[
     Map[
      Function[pair,
       pairData = ds016ArgumentRoutingData[#, loopMomenta, referenceMatrix, referenceResiduals] & /@ pair;
       If[AnyTrue[pairData, TrueQ[Lookup[#, "containsLoopMomentumQ", False]] &],
        Select[Lookup[pairData, "shiftInvariantResidual", {}], ! ds016ZeroQ[#] &],
        {}
        ]
       ],
      pairs
      ],
     1
     ]
   ];


ds016LoopRoutingAudit[case_Association, lines_List, graphAudit_Association] := Module[
   {mode, loopMomenta, lineMomenta, matrix, activeLineIndices, activeMatrix, residuals, rank, incidenceResidual, bridgeResidual,
    referencePositions = {}, referenceMatrix = {}, referenceResiduals = {}, shiftResiduals,
    lineLinearQ, routingCoefficientQ, fullChecksQ, issues = {}, graphLoopCount},
   graphLoopCount = Lookup[graphAudit, "graphLoopCount", 0];
   mode = ds016ResolveIBPMode[case, graphLoopCount];
   loopMomenta = Lookup[case, "loopMomenta", {}];
   lineMomenta = Lookup[lines, "momentum", 0];
   If[mode === "invalid", AppendTo[issues, <|"severity" -> "error", "code" -> "invalidIBPMode", "value" -> Lookup[case, "ibpMode", Automatic]|>]];
   matrix = Table[Coefficient[Expand[lineMomenta[[e]]], loopMomenta[[l]]], {e, Length[lines]}, {l, Length[loopMomenta]}];
   activeLineIndices = Lookup[graphAudit, "activeLineIndices", Range[Length[lines]]];
   activeMatrix = If[activeLineIndices === {}, {}, matrix[[activeLineIndices]]];
   residuals = Table[Expand[lineMomenta[[e]] - matrix[[e]] . loopMomenta], {e, Length[lines]}];
   lineLinearQ = If[loopMomenta === {}, ConstantArray[True, Length[lines]], FreeQ[#, Alternatives @@ loopMomenta] & /@ residuals];
   routingCoefficientQ = And @@ (MemberQ[{-1, 0, 1}, #] & /@ Flatten[activeMatrix]);
   rank = ds016MatrixRank[activeMatrix, Length[loopMomenta]];
   (* 每条传播子动量可整体反号，endpoints 顺序不固定其代数方向。
      因而用 GF(2) cycle support 检查流守恒，再用有理秩检查独立圈数。 *)
   incidenceResidual = If[
     Length[loopMomenta] === 0 || ! routingCoefficientQ,
     {},
     Mod[Lookup[graphAudit, "incidenceMatrix", {}] . Mod[matrix, 2], 2]
     ];
   bridgeResidual = If[
     Length[loopMomenta] === 0 || Lookup[graphAudit, "bridgeLineIndices", {}] === {},
     {},
     matrix[[Lookup[graphAudit, "bridgeLineIndices", {}]]]
     ];
   fullChecksQ = mode === "full";
   If[fullChecksQ && Length[loopMomenta] =!= graphLoopCount,
    AppendTo[issues, <|"severity" -> "error", "code" -> "loopMomentumCountMismatch", "expected" -> graphLoopCount, "actual" -> Length[loopMomenta]|>]
    ];
   If[fullChecksQ && rank =!= graphLoopCount,
    AppendTo[issues, <|"severity" -> "error", "code" -> "loopRoutingRankMismatch", "expected" -> graphLoopCount, "actual" -> rank|>]
    ];
   If[fullChecksQ && ! routingCoefficientQ,
    AppendTo[issues, <|"severity" -> "error", "code" -> "unsupportedLoopRoutingCoefficients", "allowed" -> {-1, 0, 1}, "matrix" -> matrix|>]
    ];
   If[fullChecksQ && incidenceResidual =!= {} && ! And @@ (ds016ZeroQ /@ Flatten[incidenceResidual]),
    AppendTo[issues, <|"severity" -> "error", "code" -> "loopRoutingOutsideCycleSpace", "residual" -> incidenceResidual|>]
    ];
   If[fullChecksQ && bridgeResidual =!= {} && ! And @@ (ds016ZeroQ /@ Flatten[bridgeResidual]),
    AppendTo[issues, <|"severity" -> "error", "code" -> "bridgeCarriesLoopMomentum", "lineIndices" -> Lookup[graphAudit, "bridgeLineIndices", {}], "coefficients" -> bridgeResidual|>]
    ];
   If[fullChecksQ && ! And @@ lineLinearQ[[activeLineIndices]],
    AppendTo[issues, <|"severity" -> "error", "code" -> "nonlinearLoopMomentumRouting", "lineIndices" -> Select[activeLineIndices, ! TrueQ[lineLinearQ[[#]]] &]|>]
    ];
   If[fullChecksQ && rank === Length[loopMomenta] && Length[loopMomenta] > 0,
    referencePositions = activeLineIndices[[Take[ds016IndependentRowPositions[activeMatrix], UpTo[Length[loopMomenta]]]]];
    referenceMatrix = matrix[[referencePositions]];
    referenceResiduals = residuals[[referencePositions]];
    shiftResiduals = Expand /@ (residuals - matrix . Inverse[referenceMatrix] . referenceResiduals),
    shiftResiduals = residuals
    ];
   <|
    "status" -> If[AnyTrue[issues, Lookup[#, "severity", ""] === "error" &], "invalid", "valid"],
    "ibpMode" -> mode,
    "loopMomenta" -> loopMomenta,
    "loopCoefficientMatrix" -> matrix,
    "loopCoefficientRank" -> rank,
    "lineExternalResiduals" -> residuals,
    "referenceLineIndices" -> referencePositions,
    "referenceLoopMatrix" -> referenceMatrix,
    "referenceExternalResiduals" -> referenceResiduals,
    "shiftInvariantLineResiduals" -> shiftResiduals,
    "incidenceCycleResidual" -> incidenceResidual,
    "issues" -> issues
    |>
   ];


(* ::Chapter:: *)
(*用户 loop 外动量列表完备性*)

ds016SpanAudit[requiredExpressions_List, userExpressions_List, atoms_List] := Module[
   {requiredData, userData, requiredRows, userRows, requiredBasis, userBasis,
    missingPositions, extraPositions, missingRows, extraRows, dependencies,
    invalidRequired, invalidUser, requiredRank, userRank, unionRank, status},
   requiredData = ds016LinearVectorData[#, atoms] & /@ requiredExpressions;
   userData = ds016LinearVectorData[#, atoms] & /@ userExpressions;
   invalidRequired = Flatten@Position[ds016DataColumn[requiredData, "linearQ"], False];
   invalidUser = Flatten@Position[ds016DataColumn[userData, "linearQ"], False];
   requiredRows = ds016DataColumn[requiredData, "coefficients"];
   userRows = ds016DataColumn[userData, "coefficients"];
   requiredBasis = ds016RowBasis[requiredRows, Length[atoms]];
   userBasis = ds016RowBasis[userRows, Length[atoms]];
   requiredRank = Length[requiredBasis];
   userRank = Length[userBasis];
   unionRank = ds016MatrixRank[Join[requiredBasis, userBasis], Length[atoms]];
   missingPositions = ds016IndependentRowPositions[requiredBasis, userBasis];
   extraPositions = ds016IndependentRowPositions[userBasis, requiredBasis];
   missingRows = If[missingPositions === {}, {}, requiredBasis[[missingPositions]]];
   extraRows = If[extraPositions === {}, {}, userBasis[[extraPositions]]];
   dependencies = If[userRows === {} || Length[userRows] <= userRank, {}, NullSpace[Transpose[userRows]]];
   status = Which[
     invalidRequired =!= {} || invalidUser =!= {}, "invalid",
     missingRows =!= {}, "undercomplete",
     extraRows =!= {} || Length[userExpressions] > userRank, "overcomplete",
     True, "exact"
     ];
   <|
    "status" -> status,
    "atoms" -> atoms,
    "requiredExpressions" -> requiredExpressions,
    "userExpressions" -> userExpressions,
    "requiredBasisDirections" -> ds016DirectionExpressions[requiredBasis, atoms],
    "userBasisDirections" -> ds016DirectionExpressions[userBasis, atoms],
    "missingDirections" -> ds016DirectionExpressions[missingRows, atoms],
    "extraDirections" -> ds016DirectionExpressions[extraRows, atoms],
    "userDependencyVectors" -> dependencies,
    "requiredRank" -> requiredRank,
    "userRank" -> userRank,
    "unionRank" -> unionRank,
    "invalidRequiredPositions" -> invalidRequired,
    "invalidUserPositions" -> invalidUser
    |>
   ];


ds016RequiredLoopExternalDirections[case_Association, graphAudit_Association, routingAudit_Association] := Module[
   {cycleLines, lineDirections, ispDirections, mode},
   mode = Lookup[routingAudit, "ibpMode", "invalid"];
   If[mode =!= "full", Return[{}]];
   cycleLines = Lookup[graphAudit, "cycleLineIndices", {}];
   lineDirections = Lookup[routingAudit, "shiftInvariantLineResiduals", {}];
   lineDirections = If[cycleLines === {}, {}, lineDirections[[cycleLines]]];
   ispDirections = ds016ISPShiftInvariantDirections[
     case,
     Lookup[routingAudit, "loopMomenta", {}],
     Lookup[routingAudit, "referenceLoopMatrix", {}],
     Lookup[routingAudit, "referenceExternalResiduals", {}]
     ];
   DeleteDuplicates@Select[Join[lineDirections, ispDirections], ! ds016ZeroQ[#] &]
   ];


(* ::Chapter:: *)
(*独立无圈动量模长完备性*)

ds016CanonicalMomentumSign[expr_] := Module[{expanded = Expand[expr], opposite},
   opposite = Expand[-expanded];
   First@SortBy[{expanded, opposite}, ToString[InputForm[#]] &]
   ];


ds016MagnitudeMomentaInExpression[expr_] := DeleteDuplicates@Cases[
    expr,
    HoldPattern[Power[sp[left_, right_], Rational[1, 2]]] /; Expand[left - right] === 0 :> ds016CanonicalMomentumSign[left],
    {0, Infinity}
    ];


ds016RequiredIndependentMomentumMagnitudes[case_Association, lines_List, graphAudit_Association, routingAudit_Association] := Module[
   {candidateLines, lineCandidates, extLegCandidates, phaseCandidates, loopMomenta, mode, zeroLoopQ},
   loopMomenta = Lookup[routingAudit, "loopMomenta", {}];
   mode = Lookup[routingAudit, "ibpMode", "invalid"];
   zeroLoopQ[expr_] := And @@ (ds016ZeroQ[Coefficient[Expand[expr], #]] & /@ loopMomenta);
   (* full 模式只把 graph bridge 当作独立模长；timeOnly 中所有 active line 都退出
      loop-IBP 表示，因此它们的模长必须由用户的独立外动量列表覆盖。 *)
   candidateLines = If[
     mode === "timeOnly",
     Lookup[graphAudit, "activeLineIndices", {}],
     Lookup[graphAudit, "bridgeLineIndices", {}]
     ];
   lineCandidates = If[candidateLines === {}, {}, Lookup[lines[[candidateLines]], "momentum", {}]];
   extLegCandidates = Cases[Lookup[case, "extLegs", {}], entry_List /; Length[entry] >= 3 :> entry[[3]]];
   phaseCandidates = Flatten[
     ds016MagnitudeMomentaInExpression /@ Lookup[Lookup[case, "vertices", {}], "externalLegEnergy", {}]
     ];
   DeleteDuplicates@Select[
     ds016CanonicalMomentumSign /@ Join[lineCandidates, extLegCandidates, phaseCandidates],
     ! ds016ZeroQ[#] && (mode === "timeOnly" || zeroLoopQ[#]) &
     ]
   ];


ds016GramPairs[count_Integer] := Flatten[Table[{i, j}, {i, count}, {j, i, count}], 1];


ds016BilinearGramRow[left_List, right_List] := Map[
   Function[pair,
    If[pair[[1]] === pair[[2]],
     left[[pair[[1]]]] right[[pair[[1]]]],
     left[[pair[[1]]]] right[[pair[[2]]]] + left[[pair[[2]]]] right[[pair[[1]]]]
     ]
    ],
   ds016GramPairs[Length[left]]
   ];


ds016SquaredGramRow[row_List] := ds016BilinearGramRow[row, row];


ds016LoopGramRows[loopRows_List] := Flatten[
   Table[ds016BilinearGramRow[loopRows[[i]], loopRows[[j]]], {i, Length[loopRows]}, {j, i, Length[loopRows]}],
   1
   ];


ds016QuadraticSpanAudit[requiredMomenta_List, userMomenta_List, loopMomenta_List, atoms_List] := Module[
   {requiredData, userData, loopData, requiredRows, userRows, loopRows, baseRows,
    missingPositions, extraPositions, missingRows, extraRows, userNewPositions, redundantUserPositions,
    invalidRequired, invalidUser, invalidLoop, requiredNewRank, userNewRank, quadraticDependencies, status},
   requiredData = ds016LinearVectorData[#, atoms] & /@ requiredMomenta;
   userData = ds016LinearVectorData[#, atoms] & /@ userMomenta;
   loopData = ds016LinearVectorData[#, atoms] & /@ loopMomenta;
   invalidRequired = Flatten@Position[ds016DataColumn[requiredData, "linearQ"], False];
   invalidUser = Flatten@Position[ds016DataColumn[userData, "linearQ"], False];
   invalidLoop = Flatten@Position[ds016DataColumn[loopData, "linearQ"], False];
   requiredRows = ds016SquaredGramRow /@ ds016DataColumn[requiredData, "coefficients"];
   userRows = ds016SquaredGramRow /@ ds016DataColumn[userData, "coefficients"];
   loopRows = ds016DataColumn[loopData, "coefficients"];
   baseRows = ds016LoopGramRows[loopRows];
   missingPositions = ds016IndependentRowPositions[requiredRows, Join[baseRows, userRows]];
   extraPositions = ds016IndependentRowPositions[userRows, Join[baseRows, requiredRows]];
   userNewPositions = ds016IndependentRowPositions[userRows, baseRows];
   missingRows = If[missingPositions === {}, {}, requiredRows[[missingPositions]]];
   extraRows = If[extraPositions === {}, {}, userRows[[extraPositions]]];
   requiredNewRank = Length[ds016IndependentRowPositions[requiredRows, baseRows]];
   userNewRank = Length[userNewPositions];
   redundantUserPositions = Complement[Range[Length[userRows]], userNewPositions];
   quadraticDependencies = If[
     Join[baseRows, userRows] === {},
     {},
     NullSpace[Transpose[Join[baseRows, userRows]]]
     ];
   status = Which[
     invalidRequired =!= {} || invalidUser =!= {} || invalidLoop =!= {}, "invalid",
     missingRows =!= {}, "undercomplete",
     extraRows =!= {} || Length[userMomenta] > userNewRank, "overcomplete",
     True, "exact"
     ];
   <|
    "status" -> status,
    "atoms" -> atoms,
    "loopGramRank" -> ds016MatrixRank[baseRows, Length[ds016GramPairs[Length[atoms]]]],
    "requiredMomenta" -> requiredMomenta,
    "userMomenta" -> userMomenta,
    "missingMagnitudeSquares" -> If[missingPositions === {}, {}, sp[#, #] & /@ requiredMomenta[[missingPositions]]],
    "extraMagnitudeSquares" -> If[extraPositions === {}, {}, sp[#, #] & /@ userMomenta[[extraPositions]]],
    "redundantUserPositions" -> redundantUserPositions,
    "redundantUserMomenta" -> If[redundantUserPositions === {}, {}, userMomenta[[redundantUserPositions]]],
    "quadraticDependencyOrder" -> Join[
      Table["loopGram" <> ToString[i], {i, Length[baseRows]}],
      Table["userMagnitude" <> ToString[i], {i, Length[userRows]}]
      ],
    "quadraticDependencies" -> quadraticDependencies,
    "requiredIndependentMagnitudeCount" -> requiredNewRank,
    "userIndependentMagnitudeCount" -> userNewRank,
    "invalidRequiredPositions" -> invalidRequired,
    "invalidUserPositions" -> invalidUser,
    "invalidLoopPositions" -> invalidLoop,
    "missingQuadraticRows" -> missingRows,
    "extraQuadraticRows" -> extraRows
    |>
   ];


(* ::Chapter:: *)
(*统一声明审计与 capability gate*)

ds016MomentumDeclarationAudit[case_Association, lines_List, graphAudit_Association, routingAudit_Association] := Module[
   {loopExternal, independentExternal, requiredLoop, requiredIndependent, atoms,
    loopAudit, independentAudit, mode, status, capabilities, issues = {}},
   loopExternal = Lookup[case, "loopExternalMomenta", Lookup[case, "effectiveLoopExternalMomenta", {}]];
   independentExternal = Lookup[case, "independentExternalMomenta", Lookup[case, "independentExternalMomenta", {}]];
   requiredLoop = ds016RequiredLoopExternalDirections[case, graphAudit, routingAudit];
   requiredIndependent = ds016RequiredIndependentMomentumMagnitudes[case, lines, graphAudit, routingAudit];
   atoms = ds016MomentumAtoms[
     Join[requiredLoop, loopExternal, requiredIndependent, independentExternal],
     Lookup[routingAudit, "loopMomenta", {}]
     ];
   mode = Lookup[routingAudit, "ibpMode", "invalid"];
   loopAudit = If[mode === "full",
     ds016SpanAudit[requiredLoop, loopExternal, atoms],
     <|"status" -> "notRequired", "requiredExpressions" -> {}, "userExpressions" -> loopExternal,
       "missingDirections" -> {}, "extraDirections" -> {}, "requiredRank" -> 0, "userRank" -> 0|>
     ];
   independentAudit = ds016QuadraticSpanAudit[requiredIndependent, independentExternal, loopExternal, atoms];
   status = Which[
     Lookup[graphAudit, "status", "invalid"] =!= "valid" || Lookup[routingAudit, "status", "invalid"] =!= "valid", "invalid",
     MemberQ[Lookup[{loopAudit, independentAudit}, "status"], "invalid"], "invalid",
     MemberQ[Lookup[{loopAudit, independentAudit}, "status"], "undercomplete"], "undercomplete",
     MemberQ[Lookup[{loopAudit, independentAudit}, "status"], "overcomplete"], "overcomplete",
     True, "exact"
     ];
   If[Lookup[loopAudit, "status", ""] === "undercomplete",
    AppendTo[issues, <|"severity" -> "error", "code" -> "undercompleteLoopExternalMomenta", "missingDirections" -> Lookup[loopAudit, "missingDirections", {}]|>]
    ];
   If[Lookup[independentAudit, "status", ""] === "undercomplete",
    AppendTo[issues, <|"severity" -> "error", "code" -> "undercompleteIndependentExternalMomenta", "missingMagnitudeSquares" -> Lookup[independentAudit, "missingMagnitudeSquares", {}]|>]
    ];
   If[Lookup[loopAudit, "status", ""] === "overcomplete",
    AppendTo[issues, <|"severity" -> "warning", "code" -> "overcompleteLoopExternalMomenta", "extraDirections" -> Lookup[loopAudit, "extraDirections", {}], "dependencies" -> Lookup[loopAudit, "userDependencyVectors", {}]|>]
    ];
   If[Lookup[independentAudit, "status", ""] === "overcomplete",
    AppendTo[issues, <|
      "severity" -> "warning",
      "code" -> "overcompleteIndependentExternalMomenta",
      "extraMagnitudeSquares" -> Lookup[independentAudit, "extraMagnitudeSquares", {}],
      "redundantUserMomenta" -> Lookup[independentAudit, "redundantUserMomenta", {}],
      "quadraticDependencyOrder" -> Lookup[independentAudit, "quadraticDependencyOrder", {}],
      "quadraticDependencies" -> Lookup[independentAudit, "quadraticDependencies", {}]
      |>]
    ];
   capabilities = <|
     "initializationUsableQ" -> MemberQ[{"exact", "overcomplete"}, status],
     "timeIBPUsableQ" -> MemberQ[{"exact", "overcomplete"}, status],
     "momentumIBPUsableQ" -> TrueQ[mode === "full" && MemberQ[{"exact", "overcomplete"}, status]],
     "derivativeUsableQ" -> TrueQ[status === "exact"],
     "inverseKinematicsUsableQ" -> TrueQ[status === "exact"]
     |>;
   <|
    "status" -> status,
    "ibpMode" -> mode,
    "loopExternalMomenta" -> loopExternal,
    "independentExternalMomenta" -> independentExternal,
    "requiredLoopExternalDirections" -> requiredLoop,
    "requiredIndependentMomentumMagnitudes" -> requiredIndependent,
    "momentumAtoms" -> atoms,
    "loopExternalAudit" -> loopAudit,
    "independentExternalAudit" -> independentAudit,
    "capabilities" -> capabilities,
    "issues" -> Join[Lookup[routingAudit, "issues", {}], issues]
    |>
   ];


ds016TopologyAndMomentumAudit[case_Association, lines_List, vertexIds_List] := Module[
   {graphAudit, routingAudit, declarationAudit, activeVertexIds},
   activeVertexIds = Lookup[case, "activeVertexIds", vertexIds];
   graphAudit = ds016TopologyGraphAudit[activeVertexIds, lines];
   If[Lookup[graphAudit, "status", "invalid"] =!= "valid",
    Return[<|"status" -> "invalid", "graph" -> graphAudit, "routing" -> <||>, "declarations" -> <||>|>]
    ];
   routingAudit = ds016LoopRoutingAudit[case, lines, graphAudit];
   declarationAudit = ds016MomentumDeclarationAudit[case, lines, graphAudit, routingAudit];
   <|
    "status" -> Lookup[declarationAudit, "status", "invalid"],
    "graph" -> graphAudit,
    "routing" -> routingAudit,
    "declarations" -> declarationAudit,
    "capabilities" -> Lookup[declarationAudit, "capabilities", <||>],
    "issues" -> Join[Lookup[graphAudit, "issues", {}], Lookup[declarationAudit, "issues", {}]]
    |>
   ];

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

(* 本章把用户输入的 vertices/lines/extLegs/loopMomenta/ispData 规范化为 Association。
   顶点和传播子只接受 022 的 Association schema；额外键不进入内部 topology。 *)


(* 顶点相位的唯一公开 authority 是 vertexType；内部保留规范化后的同名字段。 *)
normalizeVertex[vertex_Association] := KeyTake[
   vertex,
   {"id", "vertexType", "externalLegEnergy"}
   ];


(* line 的 SK、pack 和 contact state 都由端点与 sector producer 派生，不能从用户输入读取。 *)
normalizeLine[line_Association] := Module[{massType, allowed},
   massType = Lookup[line, "massType", Missing["massType"]];
   allowed = If[
     massType === "massive",
     {"id", "massType", "endpoints", "momentum", "nu", "functionSystem"},
     {"id", "massType", "endpoints", "momentum"}
     ];
   KeyTake[line, allowed]
   ];


(* ISP 可用 {name, expr, range} 或 Association。其坐标由不可约 numerator 标量积定义，
   零点固定为 0；正幂是 numerator，用户显式选择的负幂作为额外 denominator 保留。 *)
normalizeISP[isp_Association] := Join[isp, <|"zeroPoint" -> 0|>];
normalizeISP[{name_, expr_, range_}] := <|
   "name" -> name,
   "expr" -> expr,
   "range" -> range,
   "zeroPoint" -> 0
   |>;


requiredCaseInputKeys[] := {"vertices", "lines", "loopMomenta"};


optionalCaseInputKeys[] := {
   "name", "extLegs", "ibpMode",
   "loopExternalMomenta", "independentExternalMomenta",
   "kinematicRules",
   "ispData", "zeroPointRules", "symmetryRules", "parityConstraints"
   };


vertexEntryAssociationMissingKeys[entry_Association] := Complement[
   {"id", "vertexType", "externalLegEnergy"},
   Keys[entry]
   ];
vertexEntryAssociationMissingKeys[_] := {};


validVertexEntryQ[entry_] := AssociationQ[entry];


validLineEntryShapeQ[entry_] := AssociationQ[entry];


lineEntryAssociationMissingKeys[entry_Association] := Module[{required},
   required = Join[
     {"id", "massType", "endpoints", "momentum"},
     If[Lookup[entry, "massType", Missing["massType"]] === "massive", {"nu"}, {}]
     ];
   Complement[required, Keys[entry]]
   ];
lineEntryAssociationMissingKeys[_] := {};


lineEntryEndpointValue[entry_Association] := Lookup[entry, "endpoints", Missing["NoEndpoints"]];
lineEntryEndpointValue[_] := Missing["NoEndpoints"];


validEndpointPairQ[endpoints_] := ListQ[endpoints] && Length[endpoints] == 2;


validISPEntryShapeQ[entry_] := AssociationQ[entry] || MatchQ[entry, {_, _, _}];


ispEntryAssociationMissingKeys[entry_Association] := Complement[{"name", "expr"}, Keys[entry]];
ispEntryAssociationMissingKeys[_] := {};


validIndexRangeSpecQ[spec_] := IntegerQ[spec] || (ListQ[spec] && Length[spec] > 0 && And @@ (IntegerQ /@ spec));


validDiscreteReplacementRuleQ[rule_] := MatchQ[Unevaluated[rule], _Rule | _RuleDelayed];


caseInputMalformedIssues[case_Association] := Module[
   {issues = {}, vertices, lineInput, loopMomenta, loopExternalMomenta,
    independentExternalMomenta, ispData, badVertexPositions, vertexMissingKeyData,
    badLineShapePositions, lineMissingKeyData, badEndpointData, badISPShapePositions, ispMissingKeyData,
    symmetryRules, badSymmetryRulePositions},
   If[KeyExistsQ[case, "vertices"],
    vertices = case["vertices"];
    If[! ListQ[vertices],
     AppendTo[issues, <|"severity" -> "error", "code" -> "malformedVertices", "reason" -> "vertices must be a list of Associations"|>],
     badVertexPositions = Flatten @ Position[vertices, entry_ /; ! validVertexEntryQ[entry], {1}, Heads -> False];
     If[badVertexPositions =!= {},
      AppendTo[issues, <|"severity" -> "error", "code" -> "malformedVertices", "badPositions" -> badVertexPositions|>]
      ];
     vertexMissingKeyData = DeleteCases[
       MapIndexed[
        If[AssociationQ[#1] && vertexEntryAssociationMissingKeys[#1] =!= {},
          <|"vertexPosition" -> First[#2], "missingKeys" -> vertexEntryAssociationMissingKeys[#1]|>,
          Nothing
          ] &,
        vertices
        ],
       Nothing
       ];
     If[vertexMissingKeyData =!= {},
      AppendTo[issues, <|"severity" -> "error", "code" -> "verticesMissingRequiredKeys", "vertices" -> vertexMissingKeyData|>]
      ]
     ]
    ];
   If[KeyExistsQ[case, "lines"],
    lineInput = case["lines"];
    If[! ListQ[lineInput],
     AppendTo[issues, <|"severity" -> "error", "code" -> "malformedLines", "reason" -> "lines must be a list of Associations"|>],
     badLineShapePositions = Flatten @ Position[lineInput, entry_ /; ! validLineEntryShapeQ[entry], {1}, Heads -> False];
     If[badLineShapePositions =!= {},
      AppendTo[issues, <|"severity" -> "error", "code" -> "malformedLines", "badPositions" -> badLineShapePositions|>]
      ];
     lineMissingKeyData = DeleteCases[
       MapIndexed[
        If[AssociationQ[#1] && lineEntryAssociationMissingKeys[#1] =!= {},
          <|"linePosition" -> First[#2], "missingKeys" -> lineEntryAssociationMissingKeys[#1]|>,
          Nothing
          ] &,
        lineInput
        ],
       Nothing
       ];
     If[lineMissingKeyData =!= {},
      AppendTo[issues, <|"severity" -> "error", "code" -> "linesMissingRequiredKeys", "lines" -> lineMissingKeyData|>]
      ];
     badEndpointData = DeleteCases[
       MapIndexed[
        If[validLineEntryShapeQ[#1] && lineEntryAssociationMissingKeys[#1] === {} && ! validEndpointPairQ[lineEntryEndpointValue[#1]],
          <|"linePosition" -> First[#2], "endpoints" -> lineEntryEndpointValue[#1]|>,
          Nothing
          ] &,
        lineInput
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
   If[KeyExistsQ[case, "loopExternalMomenta"],
    loopExternalMomenta = case["loopExternalMomenta"];
    If[! ListQ[loopExternalMomenta],
     AppendTo[issues, <|"severity" -> "error", "code" -> "malformedLoopExternalMomenta", "reason" -> "loopExternalMomenta must be a list"|>]
     ]
    ];
   If[KeyExistsQ[case, "independentExternalMomenta"],
    independentExternalMomenta = case["independentExternalMomenta"];
    If[! ListQ[independentExternalMomenta],
     AppendTo[issues, <|"severity" -> "error", "code" -> "malformedIndependentExternalMomenta", "reason" -> "independentExternalMomenta must be a list"|>]
     ]
    ];
   If[KeyExistsQ[case, "ibpMode"] && ! MemberQ[{Automatic, "full", "timeOnly"}, case["ibpMode"]],
    AppendTo[issues, <|"severity" -> "error", "code" -> "malformedIBPMode", "value" -> case["ibpMode"], "allowed" -> {"full", "timeOnly"}|>]
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
    issues
    ];


(* raw case 入口的轻量 preflight；避免缺必需字段时 parser 先抛底层 Part 消息。 *)
caseInputRequirementReport[case_Association] := Module[
   {keys = Keys[case], required = requiredCaseInputKeys[], optional = optionalCaseInputKeys[],
    retiredKeys, malformedIssues},
   retiredKeys = Intersection[
     keys,
     {
      "loopKinematicRules", "magnitudeKinematicRules",
      "resolvedLoopKinematicRules", "resolvedMagnitudeKinematicRules"
      }
     ];
   malformedIssues = caseInputMalformedIssues[case];
   <|
    "providedKeys" -> keys,
    "requiredKeys" -> required,
    "optionalKeys" -> optional,
    "missingRequiredKeys" -> Complement[required, keys],
    "unknownKeys" -> Complement[keys, Join[required, optional]],
    "retiredKeys" -> retiredKeys,
    "malformedInputIssues" -> malformedIssues,
    "completeRequiredKeysQ" -> TrueQ[Complement[required, keys] === {}],
    "inputPreflightPassQ" -> TrueQ[
      Complement[required, keys] === {} &&
       retiredKeys === {} &&
       malformedIssues === {}
      ]
    |>
   ];


caseInputErrorReport[case_Association] := Module[{report = caseInputRequirementReport[case]},
   With[{issues = Join[
       If[report["missingRequiredKeys"] === {}, {}, {<|"severity" -> "error", "code" -> "missingRequiredCaseKeys", "missingRequiredKeys" -> report["missingRequiredKeys"]|>}],
        report["malformedInputIssues"],
        If[report["retiredKeys"] === {}, {},
          {<|"severity" -> "error", "code" -> "retiredCaseInputKeys", "retiredKeys" -> report["retiredKeys"]|>}
          ]
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
   prefactor = (4 I/Pi) Exp[Pi Im[nuValue]];
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


normalizeLineFunctionSystem[line_Association] := Module[{explicit},
   explicit = Lookup[line, "functionSystem", Automatic];
   Which[
     AssociationQ[explicit], explicit,
     MemberQ[{"h", "H"}, explicit], functionSystemPreset[explicit, line],
     explicit =!= Automatic, Missing["MalformedFunctionSystem", explicit],
     True, functionSystemPreset["h", line]
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
   referenceEndpoints = endpoints;
   massType = line["massType"];
   skType = inferSKType[endpoints, vertexSignAssoc];
   state = "full";
   packType = inferPackType[massType, skType, state];
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


(* 将 022 case 解析为通用拓扑对象。公开输入分别声明 loopExternalMomenta 与
   independentExternalMomenta；额外字段不会进入规范化 topology。 *)
parseTopology::missingkeys = "case 缺少必需字段：`1`。";
parseTopology::badinput = "case 输入 preflight 失败：`1`。";
parseTopology::badfunction = "massive line 的函数系统编译失败：`1`。";
parseTopology::badsectorkey = "sectorKey 与当前 ibpMode 不一致：`1`。";


parseTopology[case_Association] := Module[
   {vertices, vertexIds, vertexSignAssoc, rootExternalLegEnergies, rawLines, lines, badFunctionLines, loopMomenta,
   effectiveLoopExternalMomenta, declaredLoopExternalMomenta, loopKinematicRules, resolvedLoopKinematicRules,
    independentExternalMomenta, declaredIndependentExternalMomenta, loopDeclarationAudit,
    loopVectorAtoms, fixedExternalVectorAtoms, momentumDecompositionBasis,
    magnitudeKinematicRules, resolvedMagnitudeKinematicRules, kinematicRules, kinematicAudit,
    ispData, nV, nE, nL, nK, bMatrix, vertexLines,
    eMomenta, momentumBasis, momentumData, loopCoeffMatrix, externalCoeffMatrix, externalPartList,
    topologyMomentumAudit, graphAudit, routingAudit, declarationAudit, capabilities, ibpMode,
    rawLineMomenta, normalizedLineMomenta, referenceLoopMatrix,
      topoContext},
   If[caseInputPreflightErrorQ[case],
    If[caseInputMissingRequiredKeysQ[case],
     Message[parseTopology::missingkeys, caseInputRequirementReport[case]["missingRequiredKeys"]],
     Message[parseTopology::badinput, Lookup[caseInputErrorReport[case], "issues", {}]]
     ];
    Return[$Failed]
    ];
   vertices = normalizeVertex /@ case["vertices"];
   vertexIds = Lookup[vertices, "id"];
   vertexSignAssoc = AssociationThread[vertexIds -> Lookup[vertices, "vertexType"]];
   rootExternalLegEnergies = AssociationThread[vertexIds -> Lookup[vertices, "externalLegEnergy"]];
   rawLines = normalizeLine /@ case["lines"];
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
    topologyMomentumAudit = ds016TopologyAndMomentumAudit[case, lines, vertexIds];
   graphAudit = Lookup[topologyMomentumAudit, "graph", <||>];
   routingAudit = Lookup[topologyMomentumAudit, "routing", <||>];
    declarationAudit = Lookup[topologyMomentumAudit, "declarations", <||>];
    capabilities = Lookup[topologyMomentumAudit, "capabilities", <||>];
    ibpMode = Lookup[routingAudit, "ibpMode", ds016ResolveIBPMode[case, Lookup[graphAudit, "graphLoopCount", 0]]];
   declaredLoopExternalMomenta = Lookup[declarationAudit, "loopExternalMomenta",
     Lookup[case, "loopExternalMomenta", {}]];
   declaredIndependentExternalMomenta = Lookup[declarationAudit, "independentExternalMomenta",
     Lookup[case, "independentExternalMomenta", {}]];
   loopDeclarationAudit = Lookup[declarationAudit, "loopExternalAudit", <||>];
   (* 过完备声明仍可生成 symbolic IBP，但不能把可吸收到圈变量平移中的额外方向
      虚增为 q.k 坐标。核心闭合使用 affine quotient 的必要基，原声明单独保留给审计。 *)
   effectiveLoopExternalMomenta = If[
     Lookup[loopDeclarationAudit, "status", "exact"] === "overcomplete",
     Lookup[loopDeclarationAudit, "requiredBasisDirections",
      Lookup[declarationAudit, "requiredLoopExternalDirections", declaredLoopExternalMomenta]],
     declaredLoopExternalMomenta
     ];
   independentExternalMomenta = declaredIndependentExternalMomenta;
   rawLineMomenta = Lookup[lines, "momentum", 0];
   referenceLoopMatrix = Lookup[routingAudit, "referenceLoopMatrix", {}];
   normalizedLineMomenta = If[
     Lookup[routingAudit, "ibpMode", "invalid"] === "full" &&
      Lookup[routingAudit, "status", "invalid"] === "valid" && loopMomenta =!= {} &&
      MatrixQ[referenceLoopMatrix] && Length[referenceLoopMatrix] === Length[loopMomenta],
     Expand /@ (
       Lookup[routingAudit, "loopCoefficientMatrix", {}] . Inverse[referenceLoopMatrix] . loopMomenta +
        Lookup[routingAudit, "shiftInvariantLineResiduals", {}]
       ),
     rawLineMomenta
     ];
    (* timeOnly 是表示边界，不只是少生成一类算符。此模式下即使图有结构圈，
       所有传播子的动量幂也进入显式系数，tree pack 不得保留 b/bS。 *)
    lines = MapIndexed[
      Join[#1, <|
         "rawMomentum" -> rawLineMomenta[[First[#2]]],
         "momentum" -> normalizedLineMomenta[[First[#2]]],
         "loopLineQ" -> (ibpMode === "full" && MemberQ[Lookup[graphAudit, "cycleLineIndices", {}], First[#2]]),
         "bridgeQ" -> MemberQ[Lookup[graphAudit, "bridgeLineIndices", {}], First[#2]],
         "linePowerMode" -> If[
           ibpMode === "full" && MemberQ[Lookup[graphAudit, "cycleLineIndices", {}], First[#2]],
           "indexed",
           "fixedCoefficient"
           ]
         |>] &,
      lines
      ];
   ispData = normalizeISP /@ Lookup[case, "ispData", {}];
   nV = Length[vertexIds];
   nE = Length[lines];
   nL = Length[loopMomenta];
    nK = Length[effectiveLoopExternalMomenta];
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
   (* independentExternalMomenta 定义模长坐标，不是复合 momentum-IBP 的外向量基。
      这里只补入其原子向量，以便合法解析 bridge 上的 p1+p2 等固定动量。 *)
   loopVectorAtoms = ds016MomentumAtoms[Join[loopMomenta, effectiveLoopExternalMomenta]];
   fixedExternalVectorAtoms = Complement[
     ds016MomentumAtoms[independentExternalMomenta],
     loopVectorAtoms
     ];
   momentumDecompositionBasis = Join[loopMomenta, effectiveLoopExternalMomenta, fixedExternalVectorAtoms];
   momentumBasis = momentumDecompositionBasis;
   momentumData = linearMomentumExpressionData[#, momentumBasis] & /@ eMomenta;
   loopCoeffMatrix = If[nL === 0, ConstantArray[{}, nE],
     Take[Lookup[momentumData, "coefficients", {}], All, UpTo[nL]]
     ];
   externalCoeffMatrix = If[nK === 0, ConstantArray[{}, nE],
     Take[Lookup[momentumData, "coefficients", {}], All, {nL + 1, nL + nK}]
     ];
   externalPartList = Table[
     eMomenta[[e]] - Sum[loopCoeffMatrix[[e, l]] loopMomenta[[l]], {l, nL}],
     {e, nE}
     ];
   topoContext = <|"loopMomenta" -> loopMomenta, "effectiveLoopExternalMomenta" -> effectiveLoopExternalMomenta,
     "independentExternalMomenta" -> independentExternalMomenta, "lines" -> lines,
     "sectorExternalLegEnergyByVertex" -> rootExternalLegEnergies, "extLegs" -> Lookup[case, "extLegs", {}],
     "nL" -> nL, "nK" -> nK|>;
   kinematicRules = Lookup[case, "kinematicRules", Automatic];
   kinematicAudit = resolveKinematicRulesForCase[case, topoContext];
   (* 动量声明和坐标 Jacobian 是两层独立门禁；坐标过完备不得重新开启
      declaration audit 已关闭的能力，也不得让一般满秩混合坐标失去 ds。 *)
   capabilities = Join[capabilities, <|
      "derivativeUsableQ" -> TrueQ[
        Lookup[capabilities, "derivativeUsableQ", False] &&
         Lookup[kinematicAudit, "completeQ", False] &&
         ! Lookup[kinematicAudit, "overcompleteQ", False]
        ],
      "inverseKinematicsUsableQ" -> TrueQ[
        Lookup[capabilities, "inverseKinematicsUsableQ", False] &&
         Lookup[kinematicAudit, "inverseAvailableQ", False]
        ]
      |>];
   loopKinematicRules = Lookup[
     kinematicAudit,
     "rawLoopRules",
     Automatic
     ];
   resolvedLoopKinematicRules = Lookup[
     kinematicAudit,
     "resolvedLoopRules",
     normalizeLoopKinematicRulesForTopology[loopKinematicRules, topoContext]
     ];
   magnitudeKinematicRules = Lookup[
     kinematicAudit,
     "rawExternalLegRules",
     Automatic
     ];
   resolvedMagnitudeKinematicRules = Lookup[
     kinematicAudit,
     "resolvedExternalLegRules",
     normalizeMagnitudeKinematicRulesForTopology[magnitudeKinematicRules, topoContext]
     ];
   topoContext = Join[topoContext, <|
      "resolvedLoopKinematicRules" -> resolvedLoopKinematicRules,
      "magnitudeKinematicRules" -> magnitudeKinematicRules,
      "resolvedMagnitudeKinematicRules" -> resolvedMagnitudeKinematicRules,
      "kinematicRules" -> kinematicRules,
      "kinematicCoordinateAudit" -> kinematicAudit
      |>];
   <|
    "name" -> Lookup[case, "name", "unnamed"],
    "vertices" -> vertices,
    "vertexIds" -> vertexIds,
    "vertexSignAssoc" -> vertexSignAssoc,
    "lines" -> lines,
    "extLegs" -> Lookup[case, "extLegs", {}],
    "sectorExternalLegEnergyByVertex" -> rootExternalLegEnergies,
    "activeVertexIds" -> vertexIds,
    "fixedAVertexValues" -> <||>,
    "loopMomenta" -> loopMomenta,
     "ibpMode" -> ibpMode,
    "graphLoopCount" -> Lookup[graphAudit, "graphLoopCount", Missing["graphLoopCount"]],
    "graphTopologyAudit" -> graphAudit,
    "loopMomentumRoutingAudit" -> routingAudit,
    "normalizedLineMomenta" -> normalizedLineMomenta,
    "momentumDeclarationAudit" -> declarationAudit,
    "capabilities" -> capabilities,
    "cycleLineIndices" -> Lookup[graphAudit, "cycleLineIndices", {}],
    "bridgeLineIndices" -> Lookup[graphAudit, "bridgeLineIndices", {}],
    "selfLoopLineIndices" -> Lookup[graphAudit, "selfLoopLineIndices", {}],
    "loopExternalMomenta" -> declaredLoopExternalMomenta,
    "momentumDecompositionBasis" -> momentumDecompositionBasis,
    "fixedExternalVectorAtoms" -> fixedExternalVectorAtoms,
    "effectiveLoopExternalMomenta" -> effectiveLoopExternalMomenta,
    "independentExternalMomenta" -> independentExternalMomenta,
    "loopKinematicRules" -> loopKinematicRules,
    "resolvedLoopKinematicRules" -> resolvedLoopKinematicRules,
    "magnitudeKinematicRules" -> magnitudeKinematicRules,
    "resolvedMagnitudeKinematicRules" -> resolvedMagnitudeKinematicRules,
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
    "zeroPointRules" -> Lookup[case, "zeroPointRules", {}],
    "rootZeroPointRules" -> Lookup[case, "zeroPointRules", {}],
    "symmetryRules" -> Lookup[case, "symmetryRules", {}],
    "parityConstraints" -> Lookup[case, "parityConstraints", {}],
    "sectorVertexRepresentativeMap" -> AssociationThread[vertexIds -> vertexIds]
    |>
   ];


(* ::Chapter:: *)
(*统一 J 指标包与离散态枚举*)

(* 本章实现 massive/massless 的自然指标打包。离散态按每条线 metadata 枚举，
   不再使用旧 bubble 原型中的 Tuples[{0,1}, 2 nE]。 *)


lineIndexedPowerQ[line_Association] := Lookup[line, "linePowerMode", "indexed"] === "indexed";


linePackNPositions[line_Association, packType_String] := Module[{offset = If[lineIndexedPowerQ[line], 1, 0]},
   Switch[packType,
    "massiveFull" | "massiveCross", offset + {1, 2},
    "masslessFull", {offset + 1},
    _, {}
    ]
   ];


(* 只有 cycle line 的 pack 第一槽是整数动量幂。bridge 的第一槽可能是 n，
   因而任何物理幂次、排序或投影代码都必须通过本访问器读取。 *)
lineIntegerPowerIndex[topo_Association, J[_, linePacks_, _], e_Integer] := If[
   lineIndexedPowerQ[topo["lines"][[e]]],
   linePacks[[e, 1]],
   0
   ];


linePackNPosition[topo_Association, e_Integer, endpointSlot_Integer] := Module[
   {positions = linePackNPositions[topo["lines"][[e]], actualLinePackType[topo, e, makeLinePack[topo["lines"][[e]]]]]},
   If[1 <= endpointSlot <= Length[positions], positions[[endpointSlot]], Missing["NoEndpointState"]]
   ];


makeLinePack[line_Association] := Module[{id = line["id"], indexedQ = lineIndexedPowerQ[line]},
   Switch[line["packType"],
    "massiveFull", If[indexedQ, {b[id], n[id, 1], n[id, 2]}, {n[id, 1], n[id, 2]}],
    "massiveCross", If[indexedQ, {b[id], n[id, 1], n[id, 2]}, {n[id, 1], n[id, 2]}],
    "masslessFull", If[indexedQ, {b[id], n[id]}, {n[id]}],
    "masslessCross", If[indexedQ, {b[id]}, {}],
    "shrunk", If[indexedQ, {bS[id]}, {}],
    _, Message[makeLinePack::badtype, line["packType"], id]; $Failed
    ]
   ];
makeLinePack::badtype = "未知 packType `1`，line id = `2`。";


makeLinePacks[topo_Association] := makeLinePack /@ topo["lines"];


makeSectorMetadataBase018[topo_Association] := Module[
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
       "linePowerMode" -> Lookup[lines[[e]], "linePowerMode", "indexed"],
       "bPosition" -> linePackBPosition[lines[[e]]],
       "bSymbol" -> If[lineIndexedPowerQ[lines[[e]]], First[pack], None],
       "nPositions" -> linePackNPositions[lines[[e]], lines[[e]]["packType"]],
       "packTemplate" -> pack
       |>
      ],
     {e, Length[lines]}
     ];
   <|
    "caseName" -> topo["name"],
    "sectorShrunkLines" -> Lookup[topo, "sectorShrunkLines", {}],
    "sectorKey" -> sectorKeyFromShrunkLines[topo, Lookup[topo, "sectorShrunkLines", {}]],
    "aSlotMode" -> "compactActiveSlots",
    "sectorVertexRepresentativeMap" -> repMap,
    "vertexIdToOriginalASlot" -> originalSlotByVertex,
    "vertexIdToCompactASlot" -> compactSlotByVertex,
    "vertexSlots" -> vertexSlots,
    "compactASlots" -> compactASlots,
    "activeASlots" -> Range[Length[active]],
    "lineSlots" -> lineSlots,
    "lineIdToSlot" -> AssociationThread[Lookup[lines, "id"] -> Range[Length[lines]]],
     "bSymbolToLineSlot" -> Association@Cases[
       MapIndexed[Lookup[#1, "bSymbol", None] -> First[#2] &, lineSlots],
       Rule[symbol_, slot_] /; symbol =!= None :> Rule[symbol, slot]
       ],
    "ispSlots" -> Table[
      <|"slot" -> j, "indexSymbol" -> ispN[j], "data" -> topo["ispData"][[j]]|>,
      {j, Length[topo["ispData"]]}
      ]
    |>
   ];


(* sector key 的位序严格等于 root propagator 顺序。结果必须保留为字符串，
   因为前导零编码了排在最前的传播子已经收缩。 *)
sectorKeyFromShrunkLines[rootLineCount_Integer?NonNegative, shrunkLines_List] := StringJoin[
   If[MemberQ[shrunkLines, #], "0", "1"] & /@ Range[rootLineCount]
   ];


sectorKeyFromShrunkLines[topo_Association, shrunkLines_List] := sectorKeyFromShrunkLines[
   Length[Lookup[topo, "lines", {}]],
   shrunkLines,
   Lookup[topo, "ibpMode", "full"]
   ];


sectorKeyFromShrunkLines[
   rootLineCount_Integer?NonNegative,
   shrunkLines_List,
   "timeOnly"
   ] := sectorKeyFromShrunkLines[rootLineCount, shrunkLines];


sectorKeyFromShrunkLines[
   _Integer?NonNegative,
   shrunkLines_List,
   _
   ] := If[shrunkLines === {}, "top", StringRiffle["e" <> ToString[#] & /@ shrunkLines, "_"]];


sectorKeyForModeQ[key_, "timeOnly", rootLineCount_Integer?NonNegative] :=
   StringQ[key] && StringLength[key] === rootLineCount &&
    And @@ (MemberQ[{"0", "1"}, #] & /@ Characters[key]);


sectorKeyForModeQ[key_, _String, _Integer?NonNegative] := StringQ[key] &&
   (key === "top" || StringMatchQ[key, "e" ~~ DigitCharacter .. ~~ ("_e" ~~ DigitCharacter ..) ...]);


sectorKeyTopQ[key_, "timeOnly", rootLineCount_Integer?NonNegative] :=
   sectorKeyForModeQ[key, "timeOnly", rootLineCount] &&
    And @@ (# === "1" & /@ Characters[key]);


sectorKeyTopQ[key_, _String, _Integer?NonNegative] := key === "top";


sectorKeySchemaFromTopology[topo_Association] := If[
   Lookup[topo, "ibpMode", "full"] === "timeOnly",
   <|
    "type" -> "rootPropagatorBitString",
    "rootLineOrder" -> Lookup[Lookup[topo, "lines", {}], "id", Range[Length[Lookup[topo, "lines", {}]]]],
    "width" -> Length[Lookup[topo, "lines", {}]],
    "contractedBit" -> "0",
    "uncontractedBit" -> "1",
    "storageType" -> "String"
    |>,
   <|"type" -> "legacyContractedLineList", "storageType" -> "String"|>
   ];


sectorMetadataKey[metadata_Association] := Lookup[
   metadata,
   "sectorKey",
   sectorKeyFromShrunkLines[
    Lookup[metadata, "rootLineCount", Length[Lookup[metadata, "lineSlots", {}]]],
    Lookup[metadata, "sectorShrunkLines", {}],
    Lookup[metadata, "ibpMode", "full"]
    ]
   ];


sectorMetadataLinePackLengths[metadata_Association] := Length /@ Lookup[Lookup[metadata, "lineSlots", {}], "packTemplate", {}];


parsedTopologyQ[spec_Association] := TrueQ[KeyExistsQ[spec, "lines"] && KeyExistsQ[spec, "nL"]];
parsedTopologyQ[_] := False;


normalizeTopologySpec[spec_Association] := If[parsedTopologyQ[spec], spec, parseTopology[spec]];
normalizeTopologySpec[spec_] := spec;


indexContainsLineSymbolQ[index_, symbol_] := ! FreeQ[index, symbol];


indexHasAnyLineSymbolQ[index_] := ! FreeQ[index, _b | _bS];


linePackMatchesSlotQ[pack_List, slot_Association] := Module[
   {template = Lookup[slot, "packTemplate", {}], bSymbol = Lookup[slot, "bSymbol", None],
    bPosition = Lookup[slot, "bPosition", Missing["FixedLinePower"]]},
   TrueQ[Length[pack] === Length[template]] &&
     TrueQ[
      bSymbol === None || Head[bPosition] === Missing ||
       indexContainsLineSymbolQ[pack[[bPosition]], bSymbol] ||
       ! indexHasAnyLineSymbolQ[pack[[bPosition]]]
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


resolveKiraOrderingSpec[_Association, _, optSpec_] :=
  normaliseKiraOrderingSpec[Replace[optSpec, Automatic -> <||>]];


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
   bValues = numericIndexValue /@ Cases[Flatten[linePacks], _b | _bS];
   aValues = numericIndexValue /@ aList;
   ispValues = numericIndexValue /@ ispList;
   nValues = numericIndexValue /@ Cases[Flatten[linePacks], _n];
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




ruleSetsForVars[vars_List] := If[Length[vars] == 0,
   {{}},
   Thread[vars -> #] & /@ Tuples[{0, 1}, Length[vars]]
   ];


(* 离散态计数只用于完整性证书；实际 seed 仍由 enumerateDiscreteStates 全量展开。 *)
discreteStateCount[topo_Association] := Times @@ (discreteStateCountForLine /@ topo["lines"]);


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
   {line = topo["lines"][[e]], declared, fullLength, shrunkLength},
   declared = line["packType"];
   If[declared === "shrunk", Return["shrunk"]];
   fullLength = Length[makeLinePack[line]];
   shrunkLength = If[lineIndexedPowerQ[line], 1, 0];
   If[Length[pack] === shrunkLength && fullLength =!= shrunkLength,
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
   {result, endpointVertex, nPosition, xPower = term["xPower"]},
   endpointVertex = topo["lines"][[e, "endpoints", endpointSlot]];
   nPosition = linePackNPositions[topo["lines"][[e]], actualLinePackType[topo, e, int[[2, e]]]][[endpointSlot]];
   result = setLinePackEntry[int, e, nPosition, term["targetState"]];
   result = shiftVertexA[result, topo, endpointVertex, xPower];
   (* bridge 的固定动量幂会由 shiftLinePower 提到显式系数，因此先完成只接受裸 J 的顶点移位。 *)
   result = shiftLinePower[topo, result, e, -xPower];
   term["coefficient"] result
   ];


massiveEOMTarget[topo_Association, J[aList_, linePacks_, ispList_]] := Module[
   {lines = topo["lines"], packType, pack, nValue, target = Missing["NoEOMTarget"]},
   Do[
    pack = linePacks[[e]];
    packType = actualLinePackType[topo, e, pack];
    If[MemberQ[{"massiveFull", "massiveCross"}, packType],
     Do[
      nValue = pack[[linePackNPositions[lines[[e]], packType][[endpointSlot]]]];
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
       linePacks[[e, First[linePackNPositions[lines[[e]], "masslessFull"]]]] === 1
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
      linePacks[[e, linePackNPositions[lines[[e]], "massiveFull"]]] === {1, 0},
     newPacks[[e, linePackNPositions[lines[[e]], "massiveFull"]]] =
       Reverse[linePacks[[e, linePackNPositions[lines[[e]], "massiveFull"]]]]
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
      If[IntegerQ[pack[[linePackNPositions[lines[[e]], packType][[endpointSlot]]]]] &&
        pack[[linePackNPositions[lines[[e]], packType][[endpointSlot]]]] >= 2,
       AppendTo[issues, <|"lineIndex" -> e, "packType" -> packType, "endpointSlot" -> endpointSlot,
         "nValue" -> pack[[linePackNPositions[lines[[e]], packType][[endpointSlot]]]]|>]
       ],
     {endpointSlot, 2}
     ],
     "masslessFull",
     If[IntegerQ[pack[[First[linePackNPositions[lines[[e]], packType]]]]] &&
       ! MemberQ[{0, 1}, pack[[First[linePackNPositions[lines[[e]], packType]]]]],
      AppendTo[issues, <|"lineIndex" -> e, "packType" -> packType,
        "nValue" -> pack[[First[linePackNPositions[lines[[e]], packType]]]]|>]
      ],
     "massiveCross",
     Do[
      If[IntegerQ[pack[[linePackNPositions[lines[[e]], packType][[endpointSlot]]]]] &&
        pack[[linePackNPositions[lines[[e]], packType][[endpointSlot]]]] >= 2,
       AppendTo[issues, <|"lineIndex" -> e, "packType" -> packType, "endpointSlot" -> endpointSlot,
         "nValue" -> pack[[linePackNPositions[lines[[e]], packType][[endpointSlot]]]]|>]
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
    linePacks[[lineIndex, linePackNPositions[topo["lines"][[lineIndex]], "massiveFull"]]] === {1, 0};


tadpoleMasslessZeroQ[topo_Association, lineIndex_Integer, J[_, linePacks_, _]] :=
  lineIndex <= Length[linePacks] &&
    Lookup[topo["lines"][[lineIndex]], "packType", Missing["packType"]] === "masslessFull" &&
    linePacks[[lineIndex, First[linePackNPositions[topo["lines"][[lineIndex]], "masslessFull"]]]] === 1;


tadpoleSwapLinePack[topo_Association, J[aList_, linePacks_, ispList_], lineIndex_Integer] := Module[
   {newPacks = linePacks, nPositions},
   nPositions = linePackNPositions[topo["lines"][[lineIndex]], "massiveFull"];
   newPacks[[lineIndex, nPositions]] = Reverse[newPacks[[lineIndex, nPositions]]];
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
        tadpoleSwapLinePack[topo, int, lineIndex]
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
    (* 空 tadpole 集合是合法结果；显式返回空列，避免 Lookup[{}] 产生 Missing。 *)
    "massiveFullLineIndices" -> Lookup[Select[data, #["packType"] === "massiveFull" &], "lineIndex", {}],
    "masslessFullLineIndices" -> Lookup[Select[data, #["packType"] === "masslessFull" &], "lineIndex", {}],
    "automaticRuleCount" -> Length[tadpoleSymmetryRules0[topo]],
    "automaticRules" -> tadpoleSymmetryRules0[topo],
    "userRuleCount" -> Length[repSymmetry0[topo]],
    "effectiveRuleCount" -> Length[effectiveSymmetryRules0[topo]]
    |>
   ];


symmetry[expr_, topo_Association] := Module[
   {rules = effectiveSymmetryRules0[topo], internalExpr, result, publicTimeOnlyQ},
   If[
    ! ListQ[rules] || ! And @@ (validDiscreteReplacementRuleQ /@ rules),
    Message[symmetry::badrules];
    Return[$Failed]
    ];
   publicTimeOnlyQ = Lookup[topo, "ibpMode", "full"] === "timeOnly" &&
     ! FreeQ[expr, J[_String, _List, _List]];
   internalExpr = If[
     publicTimeOnlyQ,
     dsTimeOnlyExpressionToInternal020[expr, topo],
     expr
     ];
   If[internalExpr === $Failed, Return[$Failed]];
   result = internalExpr /. rules;
   If[publicTimeOnlyQ, dsTimeOnlyExpressionToPublic020[result, topo], result]
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


externalLegEnergyVariables[topo_Association] := DeleteDuplicates[
   Variables[vertexExternalEnergy[topo, #] & /@ activeAVertexIds[topo]]
   ];


(* 将两个线性动量表达式的点积展开为 qq/qk/kk。 *)
expandDotExpr[p_, r_, topo_Association] := Module[
   {loops = topo["loopMomenta"], exts = topo["effectiveLoopExternalMomenta"],
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



externalInvariantSymbolName[i_Integer, j_Integer, count_Integer : 0] := ToExpression[
   "s" <> coordinateIndexString[Min[i, j], count] <> coordinateIndexString[Max[i, j], count]
   ];


defaultLoopKinematicRulesForTopology[topo_Association] := Module[
   {exts = Lookup[topo, "effectiveLoopExternalMomenta", {}], nK = Lookup[topo, "nK", Length[Lookup[topo, "effectiveLoopExternalMomenta", {}]]]},
   Flatten[Table[sp[exts[[i]], exts[[j]]] -> externalInvariantSymbolName[i, j, nK], {i, nK}, {j, i, nK}]]
   ];


normalizeLoopKinematicRulesForTopology[Automatic, topo_Association] := defaultLoopKinematicRulesForTopology[topo];
normalizeLoopKinematicRulesForTopology[rules_Association, topo_Association] := normalizeLoopKinematicRulesForTopology[Normal[rules], topo];
normalizeLoopKinematicRulesForTopology[rules_List, topo_Association] := Module[
   {defaults = defaultLoopKinematicRulesForTopology[topo], validRules},
   validRules = Select[rules, validReplacementRuleQ];
   Normal[Association[Join[defaults, validRules]]]
   ];
normalizeLoopKinematicRulesForTopology[_, topo_Association] := defaultLoopKinematicRulesForTopology[topo];


loopKinematicInternalToUserRules[topo_Association] := Module[
   {rules = Lookup[topo, "resolvedLoopKinematicRules", defaultLoopKinematicRulesForTopology[topo]]},
   rules /. (Rule | RuleDelayed)[lhs_, rhs_] :> Rule[scalarProductSPInputToInternal[lhs, topo], rhs]
   ];


loopKinematicUserToInternalRules[topo_Association] := Module[
   {rules = loopKinematicInternalToUserRules[topo]},
   Cases[rules, Rule[lhs_, rhs_] :> Rule[rhs, lhs]]
   ];


scalarProductInternalToUser[expr_, topo_Association] := Module[
   {loops = topo["loopMomenta"], exts = topo["effectiveLoopExternalMomenta"]},
   Expand[expr /. Join[
      loopKinematicInternalToUserRules[topo],
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


loopDependentLineIndices[topo_Association] := Flatten@Position[
   Lookup[topo, "loopCoeffMatrix", {}],
   row_List /; AnyTrue[row, ! zeroQ[#] &]
   ];


expandZList[topo_Association] := Module[{indices = loopDependentLineIndices[topo]},
   If[
    indices === {},
    {},
    expandDotExpr[#, #, topo] & /@ Lookup[topo["lines"][[indices]], "momentum", {}]
    ]
   ];


coefficientMatrix[exprs_List, vars_List] := Table[
   Coefficient[Expand[exprs[[r]]], vars[[c]]],
   {r, Length[exprs]}, {c, Length[vars]}
   ];


linearMomentumExpressionData[expr_, basis_List] := Module[
   {atoms, expandedBasis, exprCoefficients, basisMatrix, coefficientVariables,
    equations, solutions, coefficients, residual, atomResiduals},
   atoms = ds016MomentumAtoms[Join[{expr}, basis]];
   expandedBasis = Expand /@ basis;
   exprCoefficients = Coefficient[Expand[expr], #] & /@ atoms;
   atomResiduals = Function[basisExpression,
       Expand[basisExpression - Total[(Coefficient[basisExpression, #] & /@ atoms) atoms]]
       ] /@ expandedBasis;
   If[! And @@ (ds016ZeroQ /@ Join[
        atomResiduals,
        {Expand[expr - Total[exprCoefficients atoms]]}
        ]),
    Return[<|"expr" -> expr, "basis" -> basis, "coefficients" -> ConstantArray[0, Length[basis]],
      "residual" -> expr, "linearQ" -> False|>]
    ];
   If[basis === {},
    residual = Expand[expr];
    Return[<|"expr" -> expr, "basis" -> basis, "coefficients" -> {},
      "residual" -> residual, "linearQ" -> ds016ZeroQ[residual]|>]
    ];
   basisMatrix = Table[Coefficient[expandedBasis[[i]], atoms[[j]]], {i, Length[basis]}, {j, Length[atoms]}];
   coefficientVariables = Array[Unique["momentumCoefficient$"] &, Length[basis]];
   equations = Thread[coefficientVariables . basisMatrix == exprCoefficients];
   solutions = Quiet[Solve[equations, coefficientVariables]];
   If[solutions === {},
    Return[<|"expr" -> expr, "basis" -> basis, "coefficients" -> ConstantArray[0, Length[basis]],
      "residual" -> expr, "linearQ" -> False|>]
   ];
   coefficients = coefficientVariables /. First[solutions];
   coefficients = coefficients /. Thread[coefficientVariables -> 0];
   residual = Expand[expr - Total[coefficients basis]];
   <|"expr" -> expr, "basis" -> basis, "coefficients" -> coefficients,
    "residual" -> residual, "linearQ" -> ds016ZeroQ[residual]|>
   ];


linearMomentumExpressionQ[expr_, basis_List] := TrueQ[linearMomentumExpressionData[expr, basis]["linearQ"]];


lineMomentumLinearityIssues[topo_Association] := Module[
   {basis = Lookup[topo, "momentumDecompositionBasis",
      Join[topo["loopMomenta"], topo["effectiveLoopExternalMomenta"], Lookup[topo, "independentExternalMomenta", {}]]]},
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
   {basis = Join[topo["loopMomenta"], topo["effectiveLoopExternalMomenta"]], rawISPExprs, spData},
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


externalLegEnergySPArgumentIssues[expr_, topo_Association] := Module[
   {basis = Lookup[topo, "momentumDecompositionBasis",
      Join[topo["loopMomenta"], topo["effectiveLoopExternalMomenta"], Lookup[topo, "independentExternalMomenta", {}]]],
    nL = topo["nL"], pairs},
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


externalLegEnergyMomentumDependenceIssues[topo_Association] := Module[
   {declared = Join[topo["loopMomenta"], topo["effectiveLoopExternalMomenta"], Lookup[topo, "independentExternalMomenta", {}]],
    loopSPVars = scalarProductVariables[topo], vertices = activeAVertexIds[topo]},
   DeleteCases[
    Table[
     Module[{raw = rawVertexExternalEnergy[topo, vertex], rawNoSP, directMomenta, spArgIssues, internal, loopSPUsed},
      rawNoSP = raw /. HoldPattern[sp[_, _]] -> 0;
      directMomenta = DeleteDuplicates@Cases[rawNoSP, sym_Symbol /; MemberQ[declared, sym], {0, Infinity}];
      spArgIssues = externalLegEnergySPArgumentIssues[raw, topo];
      internal = scalarProductInputToInternal[raw, topo];
      loopSPUsed = Intersection[Variables[internal], loopSPVars];
      If[directMomenta === {} && spArgIssues === {} && loopSPUsed === {},
       Nothing,
       <|
        "vertexId" -> vertex,
        "rawExternalLegEnergy" -> raw,
        "userExternalLegEnergy" -> scalarProductInternalToUser[internal, topo],
        "directMomentumSymbols" -> directMomenta,
        "spArgumentIssues" -> spArgIssues,
        "loopScalarProducts" -> scalarProductInternalToUser[#, topo] & /@ loopSPUsed,
        "comment" -> "vertices.externalLegEnergy values are scalar time-phase energies; use ssij when tied to loopExternalMomenta, sEi when tied to an independentExternalMomenta magnitude, or an independent scalar otherwise"
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
    effectiveLoopExternalMomenta = topo["effectiveLoopExternalMomenta"],
    lineMomenta = Lookup[topo["lines"], "momentum"],
    ispExprs = Lookup[topo["ispData"], "expr"],
    resolvedLoopKinematicRules = Lookup[topo, "resolvedLoopKinematicRules", {}]
    },
   HoldComplete[nL, nK, nE, loopMomenta, effectiveLoopExternalMomenta, lineMomenta, ispExprs, resolvedLoopKinematicRules]
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
    "loopKinematicNamingReport" -> loopKinematicNamingReport[topo],
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
       "vector" -> topo["effectiveLoopExternalMomenta"][[j]]
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


fixedLineMomentumMagnitude[topo_Association, e_Integer] := Module[
   {momentum = Expand[topo["lines"][[e, "momentum"]]], rules, directSquare,
     externalData, coefficients, effectiveLoopExternalMomenta, square, binding},
   binding = SelectFirst[
     externalLegMagnitudeBindingData[topo],
     SameQ[
       canonicalExternalLegMomentum[Lookup[#, "momentum", 0]],
       canonicalExternalLegMomentum[momentum]
       ] &,
     Missing["NoMagnitudeBinding"]
     ];
   If[AssociationQ[binding], Return[Lookup[binding, "userMagnitudeExpression"]]];
   rules = Join[
     Lookup[topo, "resolvedMagnitudeKinematicRules", {}],
     Lookup[topo, "resolvedLoopKinematicRules", {}]
     ];
   directSquare = sp[momentum, momentum] /. rules;
   If[directSquare =!= sp[momentum, momentum],
     Return[If[MatchQ[directSquare, Power[_, 2]], directSquare[[1]], Sqrt[directSquare]]]
    ];
   effectiveLoopExternalMomenta = Lookup[topo, "effectiveLoopExternalMomenta", {}];
   externalData = linearMomentumExpressionData[momentum, effectiveLoopExternalMomenta];
   If[TrueQ[externalData["linearQ"]],
    coefficients = externalData["coefficients"];
    square = Sum[
       coefficients[[i]] coefficients[[j]] sp[effectiveLoopExternalMomenta[[i]], effectiveLoopExternalMomenta[[j]]],
       {i, Length[effectiveLoopExternalMomenta]}, {j, Length[effectiveLoopExternalMomenta]}
       ] /. rules;
     Return[If[MatchQ[square, Power[_, 2]], square[[1]], Sqrt[Expand[square]]]]
    ];
   Sqrt[sp[momentum, momentum]]
   ];


(* cycle line 的 xi[e] 是积分变量；bridge 的模长由公开 momentum 和运动学规则唯一确定。 *)
lineMomentumMagnitude[topo_Association, e_Integer] := If[
   lineIndexedPowerQ[topo["lines"][[e]]],
   xi[topo["lines"][[e, "id"]]],
   fixedLineMomentumMagnitude[topo, e]
   ];


(* cycle 线把幂移写入 b/bS；bridge 线没有连续幂指标，同一变化必须成为显式动量系数。 *)
shiftLinePower[topo_Association, int_J, e_Integer, delta_] := If[
   lineIndexedPowerQ[topo["lines"][[e]]],
   shiftLineB[int, e, delta],
   fixedLineMomentumMagnitude[topo, e]^(-delta) int
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
   {base, packType = actualLinePackType[topo, e, linePacks[[e]]]},
   base = lineIntegerPowerIndex[topo, J[aList, linePacks, ispList], e];
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
          coeff shiftLinePower[topo, int, var[[1]], -2],
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


(* fixed line 的幂移会先产生显式模长系数；这里逐项拆出唯一积分，
   再复用裸 J 的吸收规则，避免内部 helper 留在公开导数结果中。 *)
absorbLinearFactorExpressionTerm[factor_, term_, topo_Association] := Module[
   {integrals, integral, coefficient},
   integrals = DeleteDuplicates[Cases[term, _J, {0, Infinity}]];
   If[Length[integrals] =!= 1, Return[factor term]];
   integral = First[integrals];
   coefficient = Cancel[term/integral];
   If[
    FreeQ[coefficient, _J],
    coefficient absorbLinearFactor[factor, integral, topo],
    factor term
    ]
   ];


absorbLinearFactor[factor_, expr_, topo_Association] := Total[
   absorbLinearFactorExpressionTerm[factor, #, topo] & /@ linearTerms[Expand[expr]]
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
   ] := Module[{result, endpointVertex, nPosition, xPower = term["xPower"]},
   endpointVertex = topo["lines"][[e, "endpoints", endpointSlot]];
   nPosition = linePackNPositions[topo["lines"][[e]], actualLinePackType[topo, e, int[[2, e]]]][[endpointSlot]];
   result = setLinePackEntry[int, e, nPosition, term["targetState"]];
   result = shiftVertexA[result, topo, endpointVertex, xPower];
   result = shiftLinePower[topo, result, e, -(xPower + 1)];
   -term["coefficient"] result
   ];


compiledTimeEndpointDerivativeTerms[
   topo_Association, int_J, e_Integer, endpointSlot_Integer
   ] := Module[{state, terms},
   state = int[[2, e, linePackNPositions[topo["lines"][[e]], actualLinePackType[topo, e, int[[2, e]]]][[endpointSlot]]]];
   terms = Lookup[lineCompiledFunctionSystem[topo["lines"][[e]]], "derivativeTerms", {}];
   Total[
    KroneckerDelta[state, Lookup[#, "sourceState", Missing["NoSourceState"]]] *
       applyCompiledTimeDerivativeTerm[topo, int, e, endpointSlot, #] & /@ terms
    ]
   ];


applyCompiledMomentumDerivativeTerm[
   topo_Association, int_J, e_Integer, endpointSlot_Integer, factor_, term_Association
   ] := Module[{result, endpointVertex, nPosition, xPower = term["xPower"]},
   endpointVertex = topo["lines"][[e, "endpoints", endpointSlot]];
   nPosition = linePackNPositions[topo["lines"][[e]], actualLinePackType[topo, e, int[[2, e]]]][[endpointSlot]];
   result = setLinePackEntry[int, e, nPosition, term["targetState"]];
   result = shiftVertexA[result, topo, endpointVertex, xPower + 1];
   result = shiftLinePower[topo, result, e, 1 - xPower];
   term["coefficient"] absorbLinearFactor[factor, result, topo]
   ];


compiledMomentumEndpointDerivativeTerms[
   topo_Association, int_J, e_Integer, endpointSlot_Integer, factor_
   ] := Module[{state, terms},
   state = int[[2, e, linePackNPositions[topo["lines"][[e]], actualLinePackType[topo, e, int[[2, e]]]][[endpointSlot]]]];
   terms = Lookup[lineCompiledFunctionSystem[topo["lines"][[e]]], "derivativeTerms", {}];
   Total[
    KroneckerDelta[state, Lookup[#, "sourceState", Missing["NoSourceState"]]] *
       applyCompiledMomentumDerivativeTerm[topo, int, e, endpointSlot, factor, #] & /@ terms
    ]
   ];


toggleMasslessLineState[topo_Association, J[aList_, linePacks_, ispList_], e_Integer] := Module[
   {newLinePacks = linePacks, nPosition},
   nPosition = First[linePackNPositions[topo["lines"][[e]], "masslessFull"]];
   newLinePacks[[e, nPosition]] = 1 - newLinePacks[[e, nPosition]];
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
        shiftedInt = shiftLinePower[topo, toggleMasslessLineState[topo, int, e], e, 1];
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
       shiftedInt = shiftLinePower[topo, int, e, 1];
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
      shiftedInt = shiftLinePower[topo, int, e, 2];
      -loopCoeff linePowerIndex[topo, int, e] absorbLinearFactor[vDotQ, shiftedInt, topo]
      ],
     {e, topo["nE"]}
     ]
    ]
   ];


(* ISP 是 numerator 因子；momentum IBP 必须同时微分 ISP^r。
   内部坐标使用 qq/qk/kk，方向导数后再沿现有 z/rho 坐标吸收到指标。 *)
momentumDirectionalSPDerivative[topo_Association, expr_, gen_Association] := Module[
   {dLoop = gen["dLoop"], vector = gen["vector"], loops = topo["loopMomenta"], exts = topo["effectiveLoopExternalMomenta"]},
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
   单独 time batch 会把进一步 shrink-sector 生成标为 pending；canonical batch 完整补齐全部 contact-reachable sectors。 *)

rawVertexExternalEnergy[topo_Association, vertexId_] := Module[
   {sectorEnergies = Lookup[topo, "sectorExternalLegEnergyByVertex", Missing["NotSet"]]},
   Which[
    AssociationQ[sectorEnergies] && KeyExistsQ[sectorEnergies, vertexId], sectorEnergies[vertexId],
    ListQ[sectorEnergies], vertexId /. sectorEnergies,
    True,
    ke[vertexId]
    ]
   ];


vertexExternalEnergy[topo_Association, vertexId_] := scalarProductInputToInternal[rawVertexExternalEnergy[topo, vertexId], topo];


externalLegEnergyDependencyData[topo_Association, vertexId_] := Module[
   {internal, vars, externalVars, externalUsed, independentUsed},
   internal = vertexExternalEnergy[topo, vertexId];
   vars = Variables[internal];
   externalVars = externalInvariantVariables[topo];
   externalUsed = Intersection[vars, externalVars];
   independentUsed = Complement[vars, externalVars];
   <|
    "internalExternalInvariantVariables" -> externalUsed,
    "externalInvariantVariables" -> (scalarProductInternalToUser[#, topo] & /@ externalUsed),
    "internalIndependentExternalLegEnergyParameters" -> independentUsed,
    "independentExternalLegEnergyParameters" -> (scalarProductInternalToUser[#, topo] & /@ independentUsed),
    "usesExternalInvariantQ" -> TrueQ[externalUsed =!= {}],
    "usesIndependentExternalLegEnergyQ" -> TrueQ[independentUsed =!= {}],
    "kind" -> Which[
      externalUsed =!= {} && independentUsed === {}, "externalInvariantExpression",
      externalUsed === {} && independentUsed =!= {}, "independentExternalLegEnergyParameter",
      externalUsed =!= {} && independentUsed =!= {}, "mixedExpression",
      True, "constant"
      ]
    |>
   ];


externalLegEnergyNamingReport[topo_Association] := Module[
   {vertices = activeAVertexIds[topo], raw, internal, user, dependencies},
   raw = AssociationThread[vertices -> (rawVertexExternalEnergy[topo, #] & /@ vertices)];
   internal = AssociationThread[vertices -> (vertexExternalEnergy[topo, #] & /@ vertices)];
   user = AssociationThread[vertices -> (scalarProductInternalToUser[vertexExternalEnergy[topo, #], topo] & /@ vertices)];
   dependencies = AssociationThread[vertices -> (externalLegEnergyDependencyData[topo, #] & /@ vertices)];
   <|
    "convention" -> "vertex external energy uses ke[i] for independent absolute-value parameters; expressions built from external invariant names are normalized to the same scalar-product coordinates used by loop momenta",
    "rawExternalLegEnergies" -> raw,
    "internalExternalLegEnergies" -> internal,
    "userExternalLegEnergies" -> user,
    "dependencyData" -> dependencies,
    "message" -> "每个 vertices.externalLegEnergy 表示对应顶点外腿打包后的相位能量。若它绑定 loopExternalMomenta，输入原始 Sqrt[sp[p,p]] 并由缺省 ssij 或 exact 自定义规则输出；若绑定 independentExternalMomenta 的实际无圈模长，则输出为 sEi；否则写独立标量。不要把 |p1+p2| 与 |p1|+|p2| 混同，程序不会自动生成无圈动量之间的点积关系。"
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
    newLinePacks, shiftedIntegral, nPosition, sigma},
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
        nPosition = First[linePackNPositions[lines[[e]], "masslessFull"]];
        newLinePacks[[e, nPosition]] = 1 - newLinePacks[[e, nPosition]];
        shiftedIntegral = shiftLinePower[topo, J[aList, newLinePacks, ispList], e, -1];
        I endpointSign shiftedIntegral,
        {endpointSlot, endpointSlots}
        ]
       ],
      "masslessCross",
      Total[
       Table[
        endpointSign = skEndpointPhaseSign[lines[[e]], endpointSlot];
        shiftedIntegral = shiftLinePower[topo, J[aList, linePacks, ispList], e, -1];
        I endpointSign shiftedIntegral,
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


(* Vpm convention 只由派生的 line SK 类型决定：++ 为 1，其余为 0。 *)
thetaBoundarySignOffset[topo_Association, e_Integer] :=
  defaultThetaBoundarySignOffset[topo["lines"][[e]]];
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
     mergedRep, oldSlotsForNewRep, slotValues, effectiveBShift, effectiveAShift, powerCoefficient},
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
   powerCoefficient = If[lineIndexedPowerQ[line], 1, fixedLineMomentumMagnitude[topo, e]^(-effectiveBShift)];
   newLinePacks[[e]] = If[
     lineIndexedPowerQ[line],
     {lineIntegerPowerIndex[topo, J[aList, linePacks, ispList], e] + effectiveBShift},
     {}
     ];
   powerCoefficient J[newAList, newLinePacks, ispList]
   ];


shrinkLinesIntegral[
   topo_Association,
   J[aList_, linePacks_, ispList_],
   specs_List
   ] := Module[
   {selectedLines, oldActive, pairs, newRepMap, newActive, newAList,
    newLinePacks = linePacks, oldSlotsForNewRep, selectedShiftForRep, powerCoefficient = 1},
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
      If[lineIndexedPowerQ[topo["lines"][[spec["lineIndex"]]]],
       newLinePacks[[spec["lineIndex"]]] = {
         lineIntegerPowerIndex[topo, J[aList, linePacks, ispList], spec["lineIndex"]] + spec["bShift"]
         },
       powerCoefficient *= fixedLineMomentumMagnitude[topo, spec["lineIndex"]]^(-spec["bShift"]);
       newLinePacks[[spec["lineIndex"]]] = {}
       ]
      ],
    specs
    ];
   powerCoefficient J[newAList, newLinePacks, ispList]
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
    coeff = With[{nPositions = linePackNPositions[line, packType]},
      KroneckerDelta[Total[pack[[nPositions]]], 1] (-1)^(pack[[nPositions[[endpointSlot]]]] + thetaBoundarySignOffset[topo, e])
      ];
    shrinkTerms = lineCompiledShrinkTerms[line];
    (<|
        "lineIndex" -> e,
       "coefficient" -> coeff Lookup[#, "coefficient", 0],
        "bShift" -> Lookup[#, "bShift", 1],
        "aShift" -> Lookup[#, "bShift", 1]
        |> &) /@ shrinkTerms,
    "masslessFull",
    {<|
      "lineIndex" -> e,
      "coefficient" -> -2 endpointOrientation KroneckerDelta[pack[[First[linePackNPositions[line, packType]]]], 1],
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
       (* 精确为零的端点 contact 不参与组合；否则 0 J 会被错误送入 sector normalization。 *)
       atomicChoices = Select[
           thetaBoundaryAtomicTerms[topo, int, #, vertexId],
           ! zeroQ[Lookup[#, "coefficient", 0]] &
           ] & /@ selected;
       If[AnyTrue[atomicChoices, # === {} &],
        0,
        Total[
         Function[choice,
            normalizeContactTerm018[
             topo,
             int,
             2^(1 - Length[selected]) Times @@ Lookup[choice, "coefficient"] *
              shrinkLinesIntegral[topo, int, KeyDrop[#, "coefficient"] & /@ choice]
             ]
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


(* ::Chapter:: *)
(*符号 seed 的结构索引*)

(* general template 的连续指标只在这里枚举变量；实际目标域由 DSGenerateIBP 接收。 *)

indexVariableQ[x_] := ! TrueQ[IntegerQ[x] || NumericQ[x]];


continuousIndexVariables[J[aList_, linePacks_, ispList_]] := Select[
   Join[aList, Cases[Flatten[linePacks], _b | _bS], ispList],
   indexVariableQ
   ];


Options[selectedDiscreteSeedRules] = {};


selectedDiscreteSeedRules[topo_Association, OptionsPattern[]] := Module[
   {rules = enumerateDiscreteStates[makeBaseIntegral[topo], topo]["rules"]},
   <|"status" -> "generated", "mode" -> "all", "ruleCount" -> Length[rules], "rules" -> rules|>
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
     "vector" -> topo["effectiveLoopExternalMomenta"][[i]]
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
      "vector" -> topo["effectiveLoopExternalMomenta"][[i]]
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
   {dExternal = gen["dExternal"], vector = gen["vector"], loops = topo["loopMomenta"], exts = topo["effectiveLoopExternalMomenta"]},
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
     extCoeff = Coefficient[lineMomenta[[e]], topo["effectiveLoopExternalMomenta"][[dExternal]]];
     If[zeroQ[extCoeff] || externalLegCoordinateLineQ[lineMomenta[[e]], topo],
      0,
      vDotQ = Expand[expandDotExpr[vector, lineMomenta[[e]], topo] /. repSP2ZRules];
      shiftedInt = shiftLinePower[topo, int, e, 2];
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
     extCoeff = Coefficient[lineMomenta[[e]], topo["effectiveLoopExternalMomenta"][[dExternal]]];
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
       shiftedInt = shiftLinePower[topo, toggleMasslessLineState[topo, int, e], e, 1];
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
       shiftedInt = shiftLinePower[topo, int, e, 1];
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


externalVectorExternalLegEnergyDerivativeTerms[topo_Association, int_J, gen_Association] := Module[
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
     externalVectorExternalLegEnergyDerivativeTerms[topo, int, gen]
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


directExternalLegEnergyVariableDerivativeSeed[topo_Association, int_J, var_] := Module[
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
   Expand[directExternalLegEnergyVariableDerivativeSeed[topo, int, internalVar]]
   ];


(* 独立变量集合按 external invariant 坐标与未被其表达的顶点能量参数组成。*)
independentVariableDerivativeVariables[topo_Association] := DeleteDuplicates@Join[
   externalInvariantVariables[topo],
   Complement[externalLegEnergyVariables[topo], externalInvariantVariables[topo]]
   ];


independentVariableDerivativeKind[topo_Association, var_] := If[
   MemberQ[externalInvariantVariables[topo], var],
   "externalInvariant",
   "externalLegEnergy"
   ];


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


remapExternalLegEnergiesToRepresentatives[sectorEnergies_, repMap_Association] := Module[
   {rules, grouped},
   Which[
    AssociationQ[sectorEnergies],
    rules = Normal[sectorEnergies] /. (v_ -> val_) :> (Lookup[repMap, v, v] -> val);
    grouped = Merge[rules, Total];
    grouped,
    ListQ[sectorEnergies],
    rules = sectorEnergies /. (v_ -> val_) :> (Lookup[repMap, v, v] -> val);
    Normal[Merge[rules, Total]],
    True,
    sectorEnergies
    ]
   ];


shrinkSectorTopology[topo_Association, shrunkLines_List] := Module[
   {pairs, repMap, activeVertices, fixedA, newLines, newExtLegs, newZeroPointRules,
    newBMatrix, newVertexLines, sectorTopo},
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
   newBMatrix = Table[
     Which[
      newLines[[e, "endpoints", 1]] === topo["vertexIds"][[v]], 1,
      newLines[[e, "endpoints", 2]] === topo["vertexIds"][[v]], -1,
      True, 0
      ],
     {v, Length[topo["vertexIds"]]}, {e, Length[newLines]}
     ];
   newVertexLines = Table[
     Select[Table[{e, newBMatrix[[v, e]]}, {e, Length[newLines]}], #[[2]] =!= 0 &],
     {v, Length[topo["vertexIds"]]}
     ];
   (* sector 只消费已解析 root topology，并更新 contact 真正改变的内部字段。
      不重新构造用户 case，也不再次调用公开 parser。 *)
   sectorTopo = Join[topo, <|
     "name" -> topo["name"] <> "_sector_" <> StringRiffle["e" <> ToString[#] & /@ shrunkLines, "_"],
     "lines" -> newLines,
     "extLegs" -> newExtLegs,
     "sectorExternalLegEnergyByVertex" -> remapExternalLegEnergiesToRepresentatives[
       topo["sectorExternalLegEnergyByVertex"],
       repMap
       ],
     "bMatrix" -> newBMatrix,
     "vertexLines" -> newVertexLines,
     "zeroPointRules" -> newZeroPointRules,
     "rootZeroPointRules" -> Lookup[topo, "rootZeroPointRules", topo["zeroPointRules"]],
     "sectorVertexRepresentativeMap" -> repMap,
     "activeVertexIds" -> activeVertices,
     "fixedAVertexValues" -> fixedA,
     "sectorShrunkLines" -> shrunkLines
     |>];
   Join[sectorTopo, <|
    "sectorMetadata" -> makeSectorMetadata[sectorTopo],
    "tadpoleSymmetryData" -> tadpoleSymmetryData[sectorTopo],
    "effectiveSymmetryRules" -> effectiveSymmetryRules0[sectorTopo]
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


shrinkSectorSubsets[topo_Association] := Module[
   {lines = thetaFullLineIndices[topo], subsets},
   If[lines === {}, Return[<|"status" -> "generated", "subsets" -> {}, "completeCoverageQ" -> True|>]];
   subsets = contactReachableShrinkSubsets[topo];
   <|"status" -> "generated", "subsets" -> subsets, "completeCoverageQ" -> True|>
   ];


Options[makeTopologyData] = {PrecomputeShrinkSectorMetadata -> False};


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
   "loopKinematicNamingReport" -> loopKinematicNamingReport[topo],
    "externalLegEnergyNamingReport" -> externalLegEnergyNamingReport[topo]
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
    extLegs, badExtLegShapePositions, badExtLegVertexData, sectorExternalLegEnergies, externalLegEnergyKeys, badExternalLegEnergyKeys,
    ispNames, badISPRangeData,
     zeroPointRuleValidationReport,
    badMassTypeLines, badSKTypeLines, badStateLines,
    badEndpointLines, lineMomentumVars, declaredMomentumVars, undeclaredMomentumVars,
    nonLinearLineMomentumData, nonLinearScalarProductArgumentData, externalLegEnergyMomentumDependenceData,
    spData, pendingFeatures, ruleData, kinematicAudit,
      topologyMomentumAudit, momentumIBPRequiredQ},
   appendIssue[severity_, code_, data_: <||>] := AppendTo[issues, Join[<|"severity" -> severity, "code" -> code|>, data]];
   vertexIds = topo["vertexIds"];
   vertexSigns = Lookup[topo["vertices"], "vertexType"];
   activeVertexIds = Lookup[topo, "activeVertexIds", vertexIds];
   fixedAVertexIds = Keys[Lookup[topo, "fixedAVertexValues", <||>]];
   extLegs = Lookup[topo, "extLegs", {}];
   sectorExternalLegEnergies = Lookup[topo, "sectorExternalLegEnergyByVertex", <||>];
   kinematicAudit = Lookup[topo, "kinematicCoordinateAudit", <||>];
   topologyMomentumAudit = <|
     "status" -> Lookup[Lookup[topo, "momentumDeclarationAudit", <||>], "status", "invalid"],
     "issues" -> Lookup[Lookup[topo, "momentumDeclarationAudit", <||>], "issues", {}]
     |>;
   momentumIBPRequiredQ = Lookup[topo, "ibpMode", "full"] === "full";
   Scan[
    appendIssue[Lookup[#, "severity", "error"], Lookup[#, "code", "momentumDeclarationIssue"], KeyDrop[#, {"severity", "code"}]] &,
    Lookup[topologyMomentumAudit, "issues", {}]
    ];
   ispNames = Lookup[topo["ispData"], "name", {}];
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
   lineIds = Lookup[topo["lines"], "id"];
   packTypes = Lookup[topo["lines"], "packType"];
   allowedPackTypes = {"massiveFull", "massiveCross", "masslessFull", "masslessCross", "shrunk"};
   duplicateLoopMomenta = Cases[Tally[topo["loopMomenta"]], {mom_, count_} /; count > 1 :> mom];
   If[duplicateLoopMomenta =!= {},
    appendIssue["error", "duplicateLoopMomenta", <|"loopMomenta" -> topo["loopMomenta"], "duplicates" -> duplicateLoopMomenta|>]
    ];
   duplicateExternalMomenta = Cases[Tally[topo["effectiveLoopExternalMomenta"]], {mom_, count_} /; count > 1 :> mom];
   If[duplicateExternalMomenta =!= {},
    appendIssue["error", "duplicateExternalMomenta", <|"effectiveLoopExternalMomenta" -> topo["effectiveLoopExternalMomenta"], "duplicates" -> duplicateExternalMomenta|>]
    ];
   duplicateExternalLegMomenta = Cases[Tally[Lookup[topo, "independentExternalMomenta", {}]], {mom_, count_} /; count > 1 :> mom];
   If[duplicateExternalLegMomenta =!= {},
    appendIssue["error", "duplicateExternalLegMomenta", <|"independentExternalMomenta" -> Lookup[topo, "independentExternalMomenta", {}], "duplicates" -> duplicateExternalLegMomenta|>]
    ];
   loopExternalMomentumOverlap = Intersection[topo["loopMomenta"], topo["effectiveLoopExternalMomenta"]];
   If[loopExternalMomentumOverlap =!= {},
    appendIssue["error", "loopExternalMomentumOverlap", <|"overlap" -> loopExternalMomentumOverlap, "loopMomenta" -> topo["loopMomenta"], "effectiveLoopExternalMomenta" -> topo["effectiveLoopExternalMomenta"]|>]
    ];
   externalLegMomentumOverlap = Intersection[
     Lookup[topo, "independentExternalMomenta", {}],
     Join[topo["loopMomenta"], topo["effectiveLoopExternalMomenta"]]
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
   zeroPointRuleValidationReport = validateCoefficientRules[topo["zeroPointRules"]];
   If[Lookup[zeroPointRuleValidationReport, "status", "ok"] =!= "ok",
    appendIssue["error", "invalidZeroPointRules", KeyDrop[zeroPointRuleValidationReport, {"status"}]]
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
   externalLegEnergyKeys = Which[
     AssociationQ[sectorExternalLegEnergies], Keys[sectorExternalLegEnergies],
     ListQ[sectorExternalLegEnergies] && And @@ (MatchQ[#, _Rule | _RuleDelayed] & /@ sectorExternalLegEnergies), Cases[sectorExternalLegEnergies, (Rule | RuleDelayed)[v_, _] :> v],
     sectorExternalLegEnergies === <||>, {},
     True, Missing["MalformedExternalLegEnergies"]
     ];
   If[externalLegEnergyKeys === Missing["MalformedExternalLegEnergies"],
     appendIssue["error", "malformedExternalLegEnergies", <|"reason" -> "internal sectorExternalLegEnergyByVertex must be an Association or list of rules"|>],
    badExternalLegEnergyKeys = Complement[externalLegEnergyKeys, vertexIds];
    If[badExternalLegEnergyKeys =!= {},
      appendIssue["error", "sectorExternalLegEnergyNotInVertices", <|"externalLegEnergyKeys" -> badExternalLegEnergyKeys, "vertexIds" -> vertexIds|>]
     ]
    ];
   externalLegEnergyMomentumDependenceData = externalLegEnergyMomentumDependenceIssues[topo];
   If[externalLegEnergyMomentumDependenceData =!= {},
    appendIssue["error", "invalidExternalLegEnergyMomentumDependence", <|"issues" -> externalLegEnergyMomentumDependenceData, "comment" -> "vertices.externalLegEnergy must use declared loopExternalMomenta/independentExternalMomenta through raw Sqrt[sp[p,p]] expressions, or independent scalar phase parameters"|>]
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
   declaredMomentumVars = ds016MomentumAtoms@Lookup[
     topo,
     "momentumDecompositionBasis",
     Join[topo["loopMomenta"], topo["effectiveLoopExternalMomenta"], Lookup[topo, "independentExternalMomenta", {}]]
     ];
   undeclaredMomentumVars = Complement[lineMomentumVars, declaredMomentumVars];
   If[undeclaredMomentumVars =!= {},
    appendIssue["error", "undeclaredMomentumVariables", <|"variables" -> undeclaredMomentumVars, "declared" -> declaredMomentumVars|>]
    ];
   nonLinearLineMomentumData = lineMomentumLinearityIssues[topo];
   If[nonLinearLineMomentumData =!= {},
    appendIssue["error", "nonLinearLineMomenta", <|"issues" -> nonLinearLineMomentumData, "comment" -> "line momenta must be linear combinations of loopMomenta, loopExternalMomenta and declared independentExternalMomenta"|>]
    ];
   nonLinearScalarProductArgumentData = scalarProductArgumentLinearityIssues[topo];
   If[nonLinearScalarProductArgumentData =!= {},
    appendIssue["error", "nonLinearScalarProductArguments", <|"issues" -> nonLinearScalarProductArgumentData, "comment" -> "sp[p,r] arguments must be linear momentum combinations before scalar products are expanded"|>]
    ];
   spData = makeScalarProductData[topo];
   If[momentumIBPRequiredQ && spData["unsupportedISPExprs"] =!= {},
    appendIssue["error", "unsupportedISPExpressions", <|"expressions" -> spData["unsupportedISPExprs"], "allowedScalarProducts" -> spData["scalarProducts"]|>]
    ];
   If[momentumIBPRequiredQ && ! TrueQ[spData["structuralCountQ"]],
    appendIssue["error", "insufficientISPData", <|"needed" -> spData["structuralNeededISPCount"], "providedDirect" -> spData["directISPCount"], "provided" -> spData["ispCount"]|>]
    ];
   If[momentumIBPRequiredQ && spData["unsupportedISPExprs"] === {} && TrueQ[spData["structuralCountQ"]] && ! TrueQ[spData["coordinateCountQ"]],
    appendIssue["error", "scalarProductCoordinateCountMismatch", <|
      "zCount" -> spData["zCount"],
      "nonISPScalarProductCount" -> spData["nonISPScalarProductCount"],
      "assumption" -> "topology input must provide a closed z/ISP coordinate system; no automatic redundant propagator subset is selected"
      |>]
    ];
   If[momentumIBPRequiredQ && spData["unsupportedISPExprs"] === {} && TrueQ[spData["structuralCountQ"]] && TrueQ[spData["coordinateCountQ"]],
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
   pendingFeatures = unsupportedSeedFeaturesForTopology[topo];
   If[pendingFeatures =!= {},
    appendIssue["pending", "unsupportedSeedFeatures", <|"pendingFeatures" -> pendingFeatures|>]
    ];
   <|
    "status" -> If[Count[Lookup[issues, "severity", {}], "error"] == 0, "ok", "issues"],
    "errorCount" -> Count[Lookup[issues, "severity", {}], "error"],
    "warningCount" -> Count[Lookup[issues, "severity", {}], "warning"],
    "pendingCount" -> Count[Lookup[issues, "severity", {}], "pending"],
    "pendingFeatures" -> pendingFeatures,
    "issues" -> issues
    |>
   ];


topologyValidationErrorQ[report_Association] := TrueQ[Lookup[report, "errorCount", 0] > 0];
topologyValidationErrorQ[_] := False;


makeTopologyData[case_Association, OptionsPattern[]] := Module[
   {topo, topMetadata, subsetData, sectorTopos, sectorMetadataList, inputReport, validationReport},
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
       "masslessBundleCandidates" -> {},
       "precomputedShrinkSectorSummary" -> <|"status" -> "skipped"|>,
       "precomputedShrinkSectorKeys" -> {}
       |>]]
    ];
   topo = parseTopology[case];
   (* parser 已经负责报告具体输入错误；这里把失败转换为 DSInit 可识别的
      invalidInput 数据，避免 $Failed 继续流入 sector metadata producer。 *)
   If[topo === $Failed,
    validationReport = <|
      "status" -> "issues",
      "errorCount" -> 1,
      "warningCount" -> 0,
      "pendingCount" -> 0,
      "pendingFeatures" -> {},
      "issues" -> {
        <|"severity" -> "error", "code" -> "topologyParseFailed"|>
        }
      |>;
    Return[Join[case, <|
       "status" -> "invalidInput",
       "reason" -> "topologyParseFailed",
       "validationReport" -> validationReport,
       "sectorMetadataList" -> {},
       "indexMaps" -> <||>,
       "seedSummary" -> <||>,
       "masslessBundleCandidates" -> {},
       "precomputedShrinkSectorSummary" -> <|"status" -> "skipped"|>,
       "precomputedShrinkSectorKeys" -> {}
       |>]]
    ];
   topMetadata = makeSectorMetadata[topo];
   subsetData = If[TrueQ[OptionValue[PrecomputeShrinkSectorMetadata]],
     shrinkSectorSubsets[topo],
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
    "tadpoleSymmetryData" -> tadpoleSymmetryData[topo],
    "effectiveSymmetryRules" -> effectiveSymmetryRules0[topo],
    "masslessBundleCandidates" -> masslessBundleCandidates[topo],
     "masslessEndpointConventions" -> masslessEndpointConventionData[topo],
     "precomputedShrinkSectorSummary" -> KeyDrop[subsetData, "subsets"],
     "precomputedShrinkSectorKeys" -> Lookup[sectorMetadataList, "sectorKey"]
     |>]
   ];

(* ::Chapter:: *)
(*统一 canonical seed 与 Kira 导出门禁*)

(* 本章只合并已经生成的 seed，并给出 Kira 前的 readiness 判断。
   若 time/momentum seed 仍有 pending features 或 forbidden n，Kira exporter 必须返回 notReady，不写文件。 *)

canonicalSeedReadyQ[batch_Association] := TrueQ[
   Lookup[batch, "status", "missing"] === "generated" &&
    Lookup[batch, "completeCanonicalQ", False] &&
    Lookup[batch, "forbiddenNData", {"missing"}] === {}
   ];


(* 019 record 必须直接携带定长 sectorKey。旧 source 只有收缩集合而没有总位宽，
   因此不能在新 convention 下无歧义恢复 key，缺字段时明确返回 Missing。 *)
seedEntrySourceSectorKey[entry_Association] := Lookup[entry, "sectorKey", Missing["SectorKeyRequired019"]];


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
   {topEntry, topMetadata, topKey, shrinkSummaries, shrinkEntries},
   topMetadata = SelectFirst[
     Lookup[batch, "sectorMetadataList", {}],
     Lookup[#, "sectorShrunkLines", Missing["NoShrunkLines"]] === {} &,
     Missing["TopSectorMetadata"]
     ];
   topKey = If[Head[topMetadata] === Missing, Missing["TopSectorKey"], topMetadata["sectorKey"]];
   topEntry = topKey -> <|
      "qIBP" -> Lookup[Lookup[batch, "momentumSummary", <||>], "generators", {}],
      "tIBP" -> Lookup[Lookup[batch, "timeSummary", <||>], "generators", {}]
      |>;
   shrinkSummaries = Lookup[Lookup[batch, "shrinkSectorSummary", <||>], "sectorSummaries", {}];
   shrinkEntries = Table[
     Lookup[summary, "sectorKey", Missing["SectorKeyRequired019"]] -> <|
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
     totalClassifiedCount, forbiddenData, reportQ, momentumRequiredQ, ibpMode, rootLineCount},
   classified = classifyCanonicalSeedBatch[batch];
   summary = Lookup[classified, "summary", <||>];
   sectorKeys = Lookup[Lookup[batch, "sectorMetadataList", {}], "sectorKey", {}];
   equations = Lookup[batch, "equations", {}];
   ibpMode = Lookup[batch, "ibpMode", "full"];
   rootLineCount = Lookup[
     SelectFirst[Lookup[batch, "sectorMetadataList", {}], AssociationQ, <||>],
     "rootLineCount",
     0
     ];
   momentumRequiredQ = ibpMode === "full";
   sectorClassChecks = Association @ Table[
      sectorKey -> <|
        "qIBPCount" -> Lookup[Lookup[summary, sectorKey, <||>], "qIBP", 0],
        "tIBPCount" -> Lookup[Lookup[summary, sectorKey, <||>], "tIBP", 0],
        "hasBothQAndT" -> TrueQ[
          Lookup[Lookup[summary, sectorKey, <||>], "qIBP", 0] > 0 &&
           Lookup[Lookup[summary, sectorKey, <||>], "tIBP", 0] > 0
          ],
        "hasRequiredClasses" -> TrueQ[
          Lookup[Lookup[summary, sectorKey, <||>], "tIBP", 0] > 0 &&
           (! momentumRequiredQ || Lookup[Lookup[summary, sectorKey, <||>], "qIBP", 0] > 0)
          ]
        |>,
      {sectorKey, sectorKeys}
      ];
   topEquations = Select[
     equations,
     sectorKeyTopQ[seedEntrySourceSectorKey[#], ibpMode, rootLineCount] &
     ];
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
      And @@ Lookup[Values[sectorClassChecks], "hasRequiredClasses", {False}] &&
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
kiraCoefficientVariableMap[variables_List, preferredBackendSymbols_List : {}] := MapIndexed[
   Function[{variable, position},
    <|
     "original" -> variable,
     "backend" -> If[
       MemberQ[preferredBackendSymbols, variable] && Head[variable] === Symbol,
       SymbolName[Unevaluated[variable]],
       "dsc" <> ToString[First[position]]
       ]
     |>
    ],
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


(* Kira 不消费虚数。Complex 原子必须在 energy map 与积分 phase gauge 阶段消失；
   这里只映射已经通过实数化门禁的实 coefficient variables。 *)
kiraBackendCoefficientExpression[expr_, variableMap_List] :=
   expr /. kiraBackendCoefficientRules[variableMap];


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


(* ::Section::Closed:: *)
(*Kira 内部相位能量坐标*)

(* 这里只读取初始化阶段已经分类的顶点相位依赖；符号名称不参与角色判断。
   每个物理能量 k 在 backend 中写成单一原子 ik，并固定 k=-I ik。 *)
kiraPhaseEnergyOccurrences[topo_Association] := Module[{report, dependencies},
   report = externalLegEnergyNamingReport[topo];
   dependencies = Lookup[report, "dependencyData", <||>];
   Flatten[
    KeyValueMap[
     Function[{vertexId, data},
      (<|
          "physical" -> #,
          "vertexId" -> vertexId,
          "role" -> "independentExternalLegEnergyParameter",
          "externalLegEnergyKind" -> Lookup[data, "kind", Missing["kind"]]
          |> &) /@ Lookup[data, "internalIndependentExternalLegEnergyParameters", {}]
      ],
     dependencies
     ],
    1
    ]
   ];


kiraPhaseEnergyBackendName[physical_Symbol] := "i" <> ToLowerCase[SymbolName[Unevaluated[physical]]];


kiraBackendEnergyConventionData[linearData_Association, linearEquations_List] := Module[
   {topo, occurrences, grouped, physicalAtoms, nonAtomic, backendNames, duplicateNames,
    coefficientVariables, existingNames, collisions, reservedNames = {"dsii", "ccc"}, records},
   topo = Lookup[linearData, "topology", Missing["topology"]];
   If[! parsedTopologyQ[topo],
    Return[<|"status" -> "notRequired", "scope" -> "KiraBackendOnly",
      "reason" -> "parsedTopologyUnavailable"|>]
    ];
   occurrences = kiraPhaseEnergyOccurrences[topo];
   If[occurrences === {},
    Return[<|"status" -> "notRequired", "scope" -> "KiraBackendOnly",
      "reason" -> "noIndependentVertexPhaseEnergyAtoms"|>]
    ];
   physicalAtoms = DeleteDuplicates[Lookup[occurrences, "physical", {}]];
   nonAtomic = Select[physicalAtoms, Head[#] =!= Symbol &];
   If[nonAtomic =!= {},
    Return[<|"status" -> "invalid", "scope" -> "KiraBackendOnly",
      "reason" -> "phaseEnergyAtomsMustBeSymbols", "nonAtomicPhysicalEnergies" -> nonAtomic,
      "sourceOccurrences" -> occurrences|>]
    ];
   backendNames = kiraPhaseEnergyBackendName /@ physicalAtoms;
   duplicateNames = Keys@Select[Counts[backendNames], # > 1 &];
   coefficientVariables = linearCoefficientDiagnostics[linearEquations]["coefficientVariables"];
   existingNames = SymbolName[Unevaluated[#]] & /@ Select[coefficientVariables, Head[#] === Symbol &];
   collisions = DeleteDuplicates@Join[
      duplicateNames,
      Intersection[backendNames, reservedNames],
      Intersection[backendNames, existingNames]
      ];
   If[collisions =!= {} || ! And @@ (StringMatchQ[#, RegularExpression["[a-z][a-z0-9_]*"]] & /@ backendNames),
    Return[<|"status" -> "invalid", "scope" -> "KiraBackendOnly",
      "reason" -> "backendPhaseEnergyNameCollisionOrInvalidName",
      "backendNames" -> backendNames, "conflictingBackendNames" -> collisions,
      "existingCoefficientVariableNames" -> existingNames,
      "sourceOccurrences" -> occurrences|>]
    ];
   grouped = GroupBy[occurrences, Lookup[#, "physical"] &];
   records = MapThread[
     Function[{physical, backendName},
      With[{backend = kiraBackendSymbol[backendName], sources = Lookup[grouped, physical, {}]},
       <|
        "physical" -> physical,
        "backend" -> backend,
        "backendName" -> backendName,
        "sourceVertexIds" -> DeleteDuplicates[Lookup[sources, "vertexId", {}]],
        "sourceRoles" -> DeleteDuplicates[Lookup[sources, "role", {}]],
        "physicalToBackendRule" -> Rule[physical, -I backend],
        "backendToPhysicalRule" -> Rule[backend, I physical],
        "physicalDerivativeFromBackendFactor" -> I,
        "backendDerivativeFromPhysicalFactor" -> -I,
        "eulerOperatorInvariantQ" -> True
        |>
       ]
      ],
     {physicalAtoms, backendNames}
     ];
   <|
    "status" -> "configured",
    "scope" -> "KiraBackendOnly",
    "physicalToBackendConvention" -> "physicalEnergy == -I backendEnergy",
    "derivativeConvention" -> "D[physicalEnergy] == I D[backendEnergy]",
    "eulerConvention" -> "physicalEnergy D[physicalEnergy] == backendEnergy D[backendEnergy]",
    "records" -> records,
    "physicalToBackendRules" -> Lookup[records, "physicalToBackendRule", {}],
    "backendToPhysicalRules" -> Lookup[records, "backendToPhysicalRule", {}],
    "physicalEnergies" -> physicalAtoms,
    "backendEnergies" -> Lookup[records, "backend", {}],
    "backendNames" -> backendNames,
    "sourceOccurrences" -> occurrences,
    "collisionCheck" -> <|"status" -> "passed", "conflictingBackendNames" -> {}|>
    |>
   ];


kiraEnergyCoefficientRulesData[rules_List, convention_Association] := Module[
   {status, records, physicalToBackend, backendRules, physicalPointRules, invalidNumericRules},
   status = Lookup[convention, "status", "notRequired"];
   If[status =!= "configured",
    Return[<|"status" -> "notRequired", "backendRules" -> rules,
      "physicalPointRules" -> rules, "energyNumericRules" -> {}|>]
    ];
   records = Lookup[convention, "records", {}];
   physicalToBackend = Lookup[convention, "physicalToBackendRules", {}];
   invalidNumericRules = Cases[
     rules,
     rule : (Rule | RuleDelayed)[lhs_, rhs_] /;
       AnyTrue[records, SameQ[Lookup[#, "physical"], lhs] &] && ! kiraExactRationalQ[rhs] :> rule
     ];
   If[invalidNumericRules =!= {},
    Return[<|"status" -> "invalid", "reason" -> "backendEnergyNumericValuesMustBeExactRealRationals",
      "invalidNumericRules" -> invalidNumericRules|>]
    ];
   backendRules = Map[
     Function[rule,
      With[{lhs = First[rule], rhs = Last[rule],
        record = SelectFirst[records, SameQ[Lookup[#, "physical"], First[rule]] &, Missing["notEnergy"]]},
       If[AssociationQ[record],
        Rule[Lookup[record, "backend"], rhs],
        Rule[lhs /. physicalToBackend, rhs /. physicalToBackend]
        ]
       ]
      ],
     rules
     ];
   physicalPointRules = Map[
     Function[rule,
      With[{lhs = First[rule], rhs = Last[rule],
        record = SelectFirst[records, SameQ[Lookup[#, "physical"], First[rule]] &, Missing["notEnergy"]]},
       If[AssociationQ[record], Rule[lhs, -I rhs], rule]
       ]
      ],
     rules
     ];
   <|
    "status" -> "converted",
    "backendRules" -> backendRules,
    "physicalPointRules" -> physicalPointRules,
    "energyNumericRules" -> Select[backendRules, MemberQ[Lookup[records, "backend", {}], First[#]] &]
    |>
   ];


kiraRestoreEnergyVariableIdentities[expressions_, convention_Association] := Module[{identityRules},
   identityRules = (Lookup[#, "backend"] -> Lookup[#, "physical"]) & /@ Lookup[convention, "records", {}];
   expressions /. identityRules
   ];


(* ::Section::Closed:: *)
(*Gaussian 相位有理化*)

(* 全数值关系中的系数只允许位于 Gaussian 有理数的实轴或虚轴。逐积分列相位
   与逐方程公共相位共同把它们变成严格有理数；manifest 保存列相位供 importer 反变换。 *)
kiraExactRationalQ[value_] := IntegerQ[value] || Head[value] === Rational;


kiraGaussianPairMultiply[{leftReal_, leftImaginary_}, {rightReal_, rightImaginary_}] := {
   leftReal rightReal - leftImaginary rightImaginary,
   leftReal rightImaginary + leftImaginary rightReal
   };


kiraGaussianPairPower[pair_List, exponent_Integer] := Which[
   exponent === 0, {1, 0},
   exponent > 0, Nest[kiraGaussianPairMultiply[#, pair] &, {1, 0}, exponent],
   exponent < 0,
   With[{positive = kiraGaussianPairPower[pair, -exponent]},
    {
     positive[[1]]/(positive[[1]]^2 + positive[[2]]^2),
     -positive[[2]]/(positive[[1]]^2 + positive[[2]]^2)
     }
    ]
   ];


(* Kira coefficient variables and algebraic generators are real by contract. Only actual
   Complex atoms need pair propagation; this avoids expanding every large rational function. *)
kiraGaussianRealImaginaryPair[expr_] := Which[
   FreeQ[expr, _Complex], {expr, 0},
   Head[expr] === Complex, {Re[expr], Im[expr]},
   Head[expr] === Plus, Total[kiraGaussianRealImaginaryPair /@ List @@ expr],
   Head[expr] === Times, Fold[kiraGaussianPairMultiply, {1, 0}, kiraGaussianRealImaginaryPair /@ List @@ expr],
   MatchQ[expr, Power[_, _Integer]],
   kiraGaussianPairPower[kiraGaussianRealImaginaryPair[First[expr]], Last[expr]],
   True, $Failed
   ];


kiraGaussianAxisData[value_] := Module[
   {normalized = Cancel[value], pair, real, imaginary, realZeroQ, imaginaryZeroQ},
   pair = kiraGaussianRealImaginaryPair[normalized];
   If[pair === $Failed,
    Return[<|"status" -> "invalid", "coefficient" -> value,
      "normalizedCoefficient" -> normalized, "reason" -> "unsupportedComplexCoefficientStructure"|>]
    ];
   real = Cancel[First[pair]];
   imaginary = Cancel[Last[pair]];
   realZeroQ = TrueQ[real === 0];
   imaginaryZeroQ = TrueQ[imaginary === 0];
   Which[
    Xor[realZeroQ, imaginaryZeroQ],
    <|"status" -> "valid", "axisPhase" -> If[realZeroQ, 1, 0],
      "rationalPart" -> If[realZeroQ, imaginary, real]|>,
    True,
    <|"status" -> "invalid", "coefficient" -> value, "normalizedCoefficient" -> normalized,
      "realPart" -> real, "imaginaryPart" -> imaginary|>
    ]
   ];


kiraGaussianPhaseRationalize[linearEquations_List, integralCount_Integer] := Module[
   {equationData, invalidItems = {}, invalidItemCount = 0, buildAxisItem,
    constraints, edges, adjacency, participatingIDs, invalidIDs,
    phaseByID = <||>, componentByID = <||>, conflicts = {}, componentCount = 0,
    queue, current, neighbor, expected, transformedEquations, rowPhases,
    invalidTransformed = {}, invalidTransformedCount = 0, rationalCoefficientCount,
    phaseRules, appliedQ},
   buildAxisItem[rule_] := Module[{data = kiraGaussianAxisData[Last[rule]]},
     If[Lookup[data, "status", "invalid"] =!= "valid",
      invalidItemCount++;
      If[Length[invalidItems] < 20,
       AppendTo[invalidItems, Join[<|"id" -> First[rule], "coefficient" -> Last[rule]|>, data]]
       ]
      ];
     {First[rule], Lookup[data, "axisPhase", Missing["axisPhase"]]}
     ];
   equationData = Map[
     Function[equation,
      buildAxisItem /@ kiraNonzeroCoefficientRules[equation["coefficientRules"]]
      ],
     linearEquations
     ];
   If[invalidItemCount > 0,
    Return[<|"status" -> "notRationalizable", "reason" -> "coefficientsMustBePureAxisRealRationalFunctions",
      "invalidCoefficientCount" -> invalidItemCount, "invalidCoefficients" -> invalidItems|>]
    ];
   participatingIDs = Sort@DeleteDuplicates@Cases[equationData, {id_Integer, _Integer} :> id, Infinity];
   invalidIDs = Select[participatingIDs, ! IntegerQ[#] || # < 1 || # > integralCount &];
   If[invalidIDs =!= {},
    Return[<|"status" -> "notRationalizable", "reason" -> "integralIDOutsideDeclaredRange", "invalidIntegralIDs" -> invalidIDs|>]
    ];
   constraints = Flatten[
     Map[
      Function[items,
       If[Length[items] < 2, {},
        ({First[First[items]], First[#],
            BitXor[Last[First[items]], Last[#]]} &) /@ Rest[items]
        ]
       ],
      equationData
      ],
     1
     ];
   edges = Flatten[
     ({#[[1]] -> {#[[2]], #[[3]]}, #[[2]] -> {#[[1]], #[[3]]}} &) /@ constraints,
     1
     ];
   adjacency = GroupBy[edges, First -> Last];
   Do[
    If[! KeyExistsQ[phaseByID, start],
     componentCount++;
     phaseByID[start] = 0;
     componentByID[start] = componentCount;
     queue = {start};
     While[queue =!= {},
      current = First[queue];
      queue = Rest[queue];
      Do[
       neighbor = edge[[1]];
       expected = BitXor[phaseByID[current], edge[[2]]];
       If[KeyExistsQ[phaseByID, neighbor],
        If[phaseByID[neighbor] =!= expected,
         AppendTo[conflicts, <|"sourceID" -> current, "targetID" -> neighbor,
           "relativePhase" -> edge[[2]], "sourcePhase" -> phaseByID[current],
           "targetPhase" -> phaseByID[neighbor]|>]
         ],
        phaseByID[neighbor] = expected;
        componentByID[neighbor] = componentCount;
        AppendTo[queue, neighbor]
        ],
       {edge, Lookup[adjacency, current, {}]}
       ]
      ]
     ],
    {start, participatingIDs}
    ];
   If[conflicts =!= {},
    Return[<|"status" -> "notRationalizable", "reason" -> "inconsistentIntegralPhaseConstraints",
      "constraintCount" -> Length[constraints], "componentCount" -> componentCount,
      "conflictCount" -> Length[conflicts], "conflicts" -> Take[conflicts, UpTo[20]]|>]
    ];
   Do[
    If[! KeyExistsQ[phaseByID, id], phaseByID[id] = 0],
    {id, Range[integralCount]}
    ];
   rowPhases = Map[
     Function[items,
      If[items === {}, 0,
       Mod[Last[First[items]] + phaseByID[First[First[items]]], 2]
       ]
      ],
     equationData
     ];
   transformedEquations = MapThread[
     Function[{equation, rowPhase},
      Join[equation, <|"coefficientRules" -> Map[
          Function[rule,
           First[rule] -> Cancel[Last[rule] I^phaseByID[First[rule]] I^(-rowPhase)]
           ],
          equation["coefficientRules"]
          ]|>]
      ],
     {linearEquations, rowPhases}
     ];
   transformedEquations = Map[
     Function[equation,
      Join[equation, <|"coefficientRules" -> Map[
          Function[rule,
           If[TrueQ[Last[rule] === 0], rule,
            Module[{data = kiraGaussianAxisData[Last[rule]]},
             If[Lookup[data, "status", "invalid"] === "valid" && Lookup[data, "axisPhase", 1] === 0,
              First[rule] -> Lookup[data, "rationalPart"],
              invalidTransformedCount++;
              If[Length[invalidTransformed] < 20, AppendTo[invalidTransformed, data]];
              rule
              ]
             ]
            ]
           ],
          equation["coefficientRules"]
          ]|>]
     ],
     transformedEquations
     ];
   If[invalidTransformedCount > 0,
    Return[<|"status" -> "notRationalizable", "reason" -> "phaseTransformDidNotProduceRealRationalFunctions",
      "invalidCoefficientCount" -> invalidTransformedCount,
      "invalidCoefficients" -> invalidTransformed|>]
    ];
   rationalCoefficientCount = Total[
     Length[kiraNonzeroCoefficientRules[# ["coefficientRules"]]] & /@ transformedEquations
     ];
   phaseRules = SortBy[Normal[phaseByID], First];
   appliedQ = AnyTrue[Flatten[equationData, 1], MatchQ[#, {_, 1}] &];
   <|
    "status" -> If[appliedQ, "applied", "notRequired"],
    "passQ" -> True,
    "physicalToBackendConvention" -> "J[id] == I^phase[id] Kira[id]",
    "integralCount" -> integralCount,
    "integralPhaseRules" -> phaseRules,
    "equationRowPhases" -> MapIndexed[First[#2] -> #1 &, rowPhases],
    "constraintCount" -> Length[constraints],
    "participatingIntegralCount" -> Length[participatingIDs],
    "componentCount" -> componentCount,
    "conflictCount" -> 0,
    "rationalCoefficientCount" -> rationalCoefficientCount,
    "coefficientDomain" -> "realRationalFunctions",
    "linearEquations" -> transformedEquations
    |>
   ];


kiraPureRationalCoefficientSystemQ[linearEquations_List] := Module[{coefficients},
   coefficients = Last /@ Flatten[kiraNonzeroCoefficientRules[# ["coefficientRules"]] & /@ linearEquations];
   coefficients =!= {} && And @@ (kiraExactRationalQ /@ coefficients)
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
   "RunTriangular" -> False,
   "RunBackSubstitution" -> False,
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


validKiraJobOptionValueQ[key_, value_] /; MemberQ[{"RunInitiate", "RunTriangular", "RunBackSubstitution", "RunFirefly", "WriteKira2MathJob", "WriteRunScript", "RunScriptDos2Unix", "RunScriptCleanup"}, key] := BooleanQ[value];
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
      "      run_triangular: " <> kiraYAMLBool[Lookup[opts, "RunTriangular", False]] <> "\n" <>
      "      run_back_substitution: " <> kiraYAMLBool[Lookup[opts, "RunBackSubstitution", False]] <> "\n" <>
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
    numericDummyIntegralId, targetData, targetIntegralCount, kiraBlockCount, numericDummySymbol,
    rawCoeffRules, normalizedCoeffRules, effectiveCoeffRules, backendEffectiveCoeffRules,
    energyConvention, energyRuleData, physicalCoefficientVariables, physicalCoefficientAlgebraicGenerators,
    coefficientVariableMap, backendCoefficientVariables, imaginaryUnitUsedQ, backendSyntaxReport,
    gaussianPhaseGauge, gaussianPhaseGaugeManifest, pureRationalBackendQ, backendTextAudit},
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
   (* linearData 可能已投影到公开坐标，也可能仍含内部 Gram 原子；两种规则必须在
      同一点并用，避免 s11 只被规范化成 kk 后反而漏掉公开 Sqrt[s11]。 *)
   effectiveCoeffRules = DeleteDuplicatesBy[
     Join[normalizedCoeffRules, rawCoeffRules],
     First
     ];
   energyConvention = kiraBackendEnergyConventionData[linearData, linearData["linearEquations"]];
   If[Lookup[energyConvention, "status", "invalid"] === "invalid",
    Return[<|"status" -> "invalidBackendEnergyConvention",
      "reason" -> Lookup[energyConvention, "reason", "invalidBackendEnergyConvention"],
      "backendEnergyConvention" -> energyConvention,
      "topologyValidationReport" -> topologyReport|>]
    ];
   energyRuleData = kiraEnergyCoefficientRulesData[effectiveCoeffRules, energyConvention];
   If[Lookup[energyRuleData, "status", "invalid"] === "invalid",
    Return[<|"status" -> "invalidBackendEnergyNumericRules",
      "reason" -> Lookup[energyRuleData, "reason", "invalidBackendEnergyNumericRules"],
      "backendEnergyConvention" -> energyConvention,
      "backendEnergyRuleData" -> energyRuleData,
      "topologyValidationReport" -> topologyReport|>]
    ];
   backendEffectiveCoeffRules = Lookup[energyRuleData, "backendRules", effectiveCoeffRules];
   linearEquations = applyKiraCoefficientRulesToLinearEquation[
       #,
       Lookup[energyConvention, "physicalToBackendRules", {}]
       ] & /@ linearData["linearEquations"];
   linearEquations = applyKiraCoefficientRulesToLinearEquation[#, backendEffectiveCoeffRules] & /@ linearEquations;
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
   gaussianPhaseGauge = kiraGaussianPhaseRationalize[
     exportedEquations,
     linearData["integralCount"]
     ];
   If[MemberQ[{"notRationalizable"}, Lookup[gaussianPhaseGauge, "status", "notRationalizable"]],
    Return[Join[
      KeyDrop[gaussianPhaseGauge, {"linearEquations"}],
      <|"status" -> "invalidGaussianPhaseGauge", "topologyValidationReport" -> topologyReport|>
      ]]
    ];
   If[MemberQ[{"applied", "notRequired"}, Lookup[gaussianPhaseGauge, "status", "notApplicable"]],
    exportedEquations = gaussianPhaseGauge["linearEquations"]
    ];
   gaussianPhaseGaugeManifest = KeyDrop[gaussianPhaseGauge, {"linearEquations"}];
   coefficientDiagnostics = linearCoefficientDiagnostics[exportedEquations];
   pureRationalBackendQ = kiraPureRationalCoefficientSystemQ[exportedEquations] &&
     coefficientDiagnostics["coefficientVariables"] === {};
   If[pureRationalBackendQ,
    normalizedJobOptions = Join[normalizedJobOptions, <|
       "RunTriangular" -> True,
       "RunBackSubstitution" -> True,
       "RunFirefly" -> False,
       "AppendNumericDummyEquation" -> False
       |>]
    ];
   physicalCoefficientVariables = kiraRestoreEnergyVariableIdentities[
     coefficientDiagnostics["coefficientVariables"],
     energyConvention
     ];
   physicalCoefficientAlgebraicGenerators = kiraRestoreEnergyVariableIdentities[
     coefficientDiagnostics["coefficientAlgebraicGenerators"],
     energyConvention
     ];
   coefficientVariableMap = kiraCoefficientVariableMap[
     coefficientDiagnostics["coefficientVariables"],
     Lookup[energyConvention, "backendEnergies", {}]
     ];
   imaginaryUnitUsedQ = ! FreeQ[
      Last /@ Flatten[kiraNonzeroCoefficientRules[#["coefficientRules"]] & /@ exportedEquations],
      _Complex
      ];
   If[imaginaryUnitUsedQ,
    Return[<|
      "status" -> "invalidRealBackendCoefficients",
      "reason" -> "Kira coefficients must be real after massless momentum mapping and integral phase gauge",
      "gaussianPhaseGauge" -> gaussianPhaseGaugeManifest,
      "topologyValidationReport" -> topologyReport
      |>]
    ];
   backendCoefficientVariables = Lookup[coefficientVariableMap, "backend", {}];
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
   appendNumericDummyQ = If[pureRationalBackendQ,
     False,
     kiraAppendNumericDummyQ[Lookup[normalizedJobOptions, "AppendNumericDummyEquation", Automatic], numericCoefficientSystemQ]
     ];
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
   backendTextAudit = <|
     "status" -> If[
       ! StringContainsQ[ibpText, "dsii"] && ! StringContainsQ[ibpText, "Complex"] &&
        ! StringContainsQ[ibpText, numericDummySymbol] &&
        If[pureRationalBackendQ, backendCoefficientVariables === {}, True],
       "passed",
       "failed"
       ],
     "pureRationalBackendQ" -> pureRationalBackendQ,
     "containsBackendImaginaryUnitQ" -> StringContainsQ[ibpText, "dsii"],
     "containsComplexTokenQ" -> StringContainsQ[ibpText, "Complex"],
     "containsNumericDummySymbolQ" -> StringContainsQ[ibpText, numericDummySymbol],
     "backendCoefficientVariables" -> backendCoefficientVariables
     |>;
   If[Lookup[backendTextAudit, "status", "failed"] =!= "passed",
    Return[<|"status" -> "invalidRealBackendText",
      "reason" -> "Kira text must be real and must not contain dsii, Complex, or a numeric dummy",
      "gaussianPhaseGauge" -> gaussianPhaseGaugeManifest,
      "backendTextAudit" -> backendTextAudit,
      "topologyValidationReport" -> topologyReport|>]
    ];
   listText = StringRiffle[ToString /@ targetData["targetIDs"], "\n"] <> "\n";
   jobsText = kiraJobsYAML[normalizedJobOptions];
   runScriptText = If[TrueQ[Lookup[normalizedJobOptions, "WriteRunScript", False]], kiraRunScript[normalizedJobOptions], Missing["RunScriptDisabled"]];
   (* backend 只消费整数 ID；反向映射保留 loop J 或带 sector 的 tree token 原对象。 *)
   repKira2JText = ToString[InputForm[
       linearData["integralRules"] /. Rule[integral_, id_Integer] :> Rule[Tuserweight[id], integral]
       ]] <> "\n";
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
          "coefficientVariables" -> physicalCoefficientVariables,
          "coefficientAlgebraicGenerators" -> physicalCoefficientAlgebraicGenerators,
          "backendExpressionVariables" -> coefficientDiagnostics["coefficientVariables"],
          "coefficientVariableMap" -> coefficientVariableMap,
         "backendCoefficientVariables" -> backendCoefficientVariables,
          "backendImaginaryUnit" -> None,
          "backendCoefficientSyntaxReport" -> backendSyntaxReport,
           "gaussianPhaseGauge" -> gaussianPhaseGaugeManifest,
           "backendEnergyConvention" -> energyConvention,
           "backendEnergyRuleData" -> energyRuleData,
          "pureRationalBackendQ" -> pureRationalBackendQ,
          "backendTextAudit" -> backendTextAudit,
          "numericDummyAppendedQ" -> appendNumericDummyQ,
         "numericDummyIntegralId" -> numericDummyIntegralId,
          "kiraCoefficientRules" -> backendEffectiveCoeffRules,
          "physicalCoefficientRules" -> Lookup[energyRuleData, "physicalPointRules", effectiveCoeffRules],
         "normalizedKiraCoefficientRules" -> normalizedCoeffRules,
         "userKiraCoefficientRules" -> rawCoeffRules,
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
     "coefficientVariables" -> physicalCoefficientVariables,
     "coefficientAlgebraicGenerators" -> physicalCoefficientAlgebraicGenerators,
     "backendExpressionVariables" -> coefficientDiagnostics["coefficientVariables"],
    "coefficientVariableMap" -> coefficientVariableMap,
    "backendCoefficientVariables" -> backendCoefficientVariables,
     "backendImaginaryUnit" -> None,
     "backendCoefficientSyntaxReport" -> backendSyntaxReport,
      "gaussianPhaseGauge" -> gaussianPhaseGaugeManifest,
      "backendEnergyConvention" -> energyConvention,
      "backendEnergyRuleData" -> energyRuleData,
     "pureRationalBackendQ" -> pureRationalBackendQ,
     "backendTextAudit" -> backendTextAudit,
     "numericDummyAppendedQ" -> appendNumericDummyQ,
    "numericDummyIntegralId" -> numericDummyIntegralId,
     "kiraCoefficientRulesApplied" -> backendEffectiveCoeffRules,
     "physicalCoefficientRulesApplied" -> Lookup[energyRuleData, "physicalPointRules", effectiveCoeffRules],
    "normalizedKiraCoefficientRulesApplied" -> normalizedCoeffRules,
    "userKiraCoefficientRulesApplied" -> rawCoeffRules
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
   KiraTargetIntegrals -> Automatic,
   KiraJobOptions -> Automatic
   };

makeKiraExportData::notlinearinput = "Kira 导出只接受 linear-system 数据，不直接接受 seed batch：`1`。";
makeKiraExportData::badlinear = "linear-system 不能导出 Kira：`1`。";


makeKiraExportData[linearData_Association, OptionsPattern[]] := Module[
   {linearForExport, strings, outputDir, outputDirReport, filesWritten, topologyReport},
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
   (* serializer 只读取 linearData 的现有顺序；显式重排必须在此边界之前完成。 *)
   linearForExport = linearData;
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
    "backendExpressionVariables" -> Lookup[strings, "backendExpressionVariables", {}],
    "coefficientVariableMap" -> Lookup[strings, "coefficientVariableMap", {}],
     "backendCoefficientVariables" -> Lookup[strings, "backendCoefficientVariables", {}],
     "backendImaginaryUnit" -> Lookup[strings, "backendImaginaryUnit", None],
     "backendCoefficientSyntaxReport" -> Lookup[strings, "backendCoefficientSyntaxReport", <||>],
     "gaussianPhaseGauge" -> Lookup[strings, "gaussianPhaseGauge", <|"status" -> "notApplicable"|>],
     "backendEnergyConvention" -> Lookup[strings, "backendEnergyConvention", <|"status" -> "notRequired"|>],
     "backendEnergyRuleData" -> Lookup[strings, "backendEnergyRuleData", <|"status" -> "notRequired"|>],
     "physicalCoefficientRulesApplied" -> Lookup[strings, "physicalCoefficientRulesApplied", {}],
     "pureRationalBackendQ" -> TrueQ[Lookup[strings, "pureRationalBackendQ", False]],
     "backendTextAudit" -> Lookup[strings, "backendTextAudit", <|"status" -> "notRun"|>],
     "numericDummyAppendedQ" -> Lookup[strings, "numericDummyAppendedQ", Missing["numericDummyAppendedQ"]],
    "numericDummyIntegralId" -> Lookup[strings, "numericDummyIntegralId", Missing["numericDummyIntegralId"]],
    "outputDirectory" -> outputDir,
    "writeFilesQ" -> StringQ[outputDir],
    "filesWritten" -> filesWritten
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


(* 来源 metadata 用于 producer coverage；去重键只包含后端真正消费的数学方程。 *)
linearEquationMathematicalKey[entry_Association] := {
   Lookup[entry, "coefficientRules", {}],
   Lookup[entry, "constantTerm", 0],
   Lookup[entry, "nonlinearTerms", {}]
   };


Options[makeLinearSystemData] = {KiraOrdering -> Automatic, AuditLevel -> "standard"};


dsSeedArtifactContractTrustedQ[batch_Association] := Module[
   {contract = Lookup[batch, "artifactContract", <||>]},
   If[! AssociationQ[contract] || ! TrueQ[Lookup[contract, "sealedQ", False]], Return[False]];
   TrueQ[
    StringQ[Lookup[contract, "sourceDigest", None]] &&
     Lookup[batch, "equationCount", Missing["equationCount"]] === Length[Lookup[batch, "equations", {}]]
    ]
   ];


dsSeedArtifactSourceDigestAuditQ[batch_Association] := Module[
   {contract = Lookup[batch, "artifactContract", <||>], context, rangeAudit},
   context = <|"inputHash" -> Lookup[Lookup[batch, "dSIBPContextSummary", <||>], "inputHash", Missing["inputHash"]]|>;
   rangeAudit = <|"rangeRules" -> Lookup[batch, "targetEnvelopeRules", {}]|>;
   TrueQ[
    dsGeneratedIBPSourceDigest[Lookup[batch, "equations", {}], context, rangeAudit] ===
     Lookup[contract, "sourceDigest", Missing["sourceDigest"]]
    ]
   ];


makeLinearSystemData[batch_Association, topoSpec_: Automatic, OptionsPattern[]] := Module[
   {topo, integrals, integralIndex, equations, linearEquations, coefficientDiagnostics,
    metadataList, metadata, orderingSpec, orderingReport, seedCoverageReport, topologyReport,
    sourceContract, trustedProducerQ, completeSystemQ, sourceDigest,
    auditLevel = OptionValue[AuditLevel], sourceDigestAuditQ},
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
      "comment" -> "linear/Kira stages require complete DSGenerateIBP output with all-sector qIBP/tIBP coverage"
      |>]
    ];
   sourceContract = Lookup[batch, "artifactContract", <||>];
   trustedProducerQ = dsSeedArtifactContractTrustedQ[batch];
   sourceDigestAuditQ = If[
     trustedProducerQ && auditLevel === "full",
     dsSeedArtifactSourceDigestAuditQ[batch],
     Missing["NotRunAtStandardAuditLevel"]
     ];
   If[trustedProducerQ && auditLevel === "full" && ! TrueQ[sourceDigestAuditQ],
    Return[<|"status" -> "notReady", "reason" -> "sourceDigestMismatch",
      "sourceDigestAuditQ" -> sourceDigestAuditQ|>]
    ];
   seedCoverageReport = If[
     trustedProducerQ && auditLevel === "standard",
     <|
      "status" -> "producerCertified",
      "passQ" -> True,
      "completeSystemQ" -> TrueQ[Lookup[sourceContract, "completeSystemQ", False]],
      "sourceDigest" -> Lookup[sourceContract, "sourceDigest", Missing["sourceDigest"]],
      "auditLevel" -> Lookup[sourceContract, "auditLevel", "standard"]
      |>,
     makeCanonicalSeedCoverageReport[batch]
     ];
   If[trustedProducerQ && auditLevel === "full" &&
     TrueQ[Lookup[sourceContract, "completeSystemQ", False]] &&
     ! TrueQ[Lookup[seedCoverageReport, "passQ", False]],
    Return[<|"status" -> "notReady", "reason" -> "fullCoverageAuditFailed",
      "seedCoverageReport" -> seedCoverageReport|>]
    ];
   completeSystemQ = TrueQ[
     trustedProducerQ && Lookup[sourceContract, "completeSystemQ", False]
     ];
   orderingReport = validateKiraOrderingSpec[OptionValue[KiraOrdering]];
   If[Lookup[orderingReport, "status", "ok"] =!= "ok",
    Return[<|"status" -> "notReady", "caseName" -> Lookup[batch, "caseName", Missing["caseName"]], "topologyValidationReport" -> topologyReport, "reason" -> "invalidKiraOrdering", "kiraOrderingValidationReport" -> orderingReport|>]
    ];
   metadataList = batchSectorMetadataList[batch, topo];
   orderingSpec = resolveKiraOrderingSpec[batch, topo, OptionValue[KiraOrdering]];
   integrals = sortIntegralsForKira[integralObjectsInBatch[batch], orderingSpec, metadataList];
   integralIndex = makeIntegralIndex[integrals];
   equations = If[
     trustedProducerQ,
     Lookup[batch, "equations", {}],
     symmetry[Lookup[batch, "equations", {}], topo]
     ];
   If[equations === $Failed,
    Return[<|"status" -> "notReady", "caseName" -> Lookup[batch, "caseName", Missing["caseName"]], "topologyValidationReport" -> topologyReport, "reason" -> "invalidSymmetryRules"|>]
    ];
   linearEquations = linearizeSeedEquation[#, integralIndex] & /@ equations;
   linearEquations = DeleteDuplicatesBy[linearEquations, linearEquationMathematicalKey];
   coefficientDiagnostics = linearCoefficientDiagnostics[linearEquations];
   sourceDigest = If[
     trustedProducerQ,
     Lookup[sourceContract, "sourceDigest", Missing["sourceDigest"]],
     IntegerString[Hash[Lookup[batch, "equations", {}], "SHA256"], 16, 64]
     ];
   metadata = If[metadataList === {}, Missing["NoSectorMetadata"], First[metadataList]];
   <|
    "status" -> "generated",
    "caseName" -> Lookup[batch, "caseName", Missing["caseName"]],
    "topology" -> topo,
    "integralCount" -> Length[integrals],
    "sourceEquationCount" -> Length[equations],
    "equationCount" -> Length[linearEquations],
    "duplicateEquationCount" -> Length[equations] - Length[linearEquations],
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
    "completeSystemQ" -> completeSystemQ,
    "artifactContract" -> <|
      "contractVersion" -> 1,
      "sealedQ" -> trustedProducerQ,
      "sourceDigest" -> sourceDigest,
      "completeSystemQ" -> completeSystemQ,
      "subsetQ" -> ! completeSystemQ,
       "auditLevel" -> If[trustedProducerQ, auditLevel, "consumerFull"],
       "sourceDigestAuditQ" -> sourceDigestAuditQ,
      "capabilities" -> <|
        "serializeQ" -> True,
        "formalReductionQ" -> completeSystemQ,
        "reuseProducerCanonicalQ" -> trustedProducerQ
        |>
      |>,
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
   linearData = makeLinearSystemData[batch, topo,
     KiraOrdering -> OptionValue[KiraOrdering], AuditLevel -> OptionValue[AuditLevel]];
   If[Lookup[linearData, "status", "missing"] =!= "generated", Return[linearData]];
   rules = Replace[OptionValue[CoefficientRules], Automatic -> {}];
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
   (* 原子接口既接受 parsed topology，也接受 DSInit 返回的完整 context；后者必须先解包，
      否则会被误当作原始 case 再次 parse，并产生缺少 lineInput 等字段的伪错误。 *)
   topo = Which[
     spec === Automatic, $dSIBPTopologyContext,
     parsedTopologyQ[spec], spec,
     AssociationQ[spec] && TrueQ[dsContextQ[spec]], spec["topology"],
     True, normalizeTopologySpec[spec]
     ];
   If[! parsedTopologyQ[topo],
    If[spec === Automatic,
     Message[dSIBPPublicAPI::notopo],
     Message[dSIBPPublicAPI::badtopo, spec]
     ];
    Return[$Failed]
    ];
   topo
   ];


publicExpectedPackLength[line_Association, packType_String] := Switch[packType,
   "massiveFull" | "massiveCross", If[lineIndexedPowerQ[line], 3, 2],
   "masslessFull", If[lineIndexedPowerQ[line], 2, 1],
   "masslessCross" | "shrunk", If[lineIndexedPowerQ[line], 1, 0],
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
      expected = publicExpectedPackLength[topo["lines"][[e]], packType];
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
      Do[If[! MemberQ[{0, 1}, pack[[p]]], AppendTo[issues, <|"lineIndex" -> e, "packType" -> packType, "packPosition" -> p, "value" -> pack[[p]]|>]],
       {p, linePackNPositions[topo["lines"][[e]], packType]}],
      "masslessFull",
      With[{p = First[linePackNPositions[topo["lines"][[e]], packType]]},
       If[! MemberQ[{0, 1}, pack[[p]]], AppendTo[issues, <|"lineIndex" -> e, "packType" -> packType, "packPosition" -> p, "value" -> pack[[p]]|>]]],
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
   MemberQ[topo["effectiveLoopExternalMomenta"], item], First@FirstPosition[topo["effectiveLoopExternalMomenta"], item],
   True, Missing["ExternalMomentumNotFound", item]
   ];


publicApplyIBPGenerator[expr_, topo_Association, gen_Association] := Module[{internalExpr, result},
   If[gen["type"] === "time" && ! dsTopologyCapabilityQ[topo, "timeIBPUsableQ"],
    dsErrorPrint["当前 topology 未通过 time-IBP capability gate。 The current topology failed the time-IBP capability gate."]; Return[$Failed]
    ];
   If[gen["type"] === "momentum" && ! dsTopologyCapabilityQ[topo, "momentumIBPUsableQ"],
    dsErrorPrint["当前 topology 未通过 momentum-IBP capability gate。 The current topology failed the momentum-IBP capability gate."]; Return[$Failed]
    ];
    internalExpr = If[
      Lookup[topo, "ibpMode", "full"] === "timeOnly",
      dsTimeOnlyExpressionToInternal020[expr, topo],
      expr
      ];
    If[internalExpr === $Failed, Return[$Failed]];
    If[! validatePublicExpression[internalExpr, topo, True], Return[$Failed]];
    result = Expand[internalExpr /. int_J :> If[
         gen["type"] === "time",
         applyTimeGeneratorSeed[topo, int, gen],
         applyMomentumGeneratorSeed[topo, int, gen]
         ]];
    If[! FreeQ[result, $Failed], Return[$Failed]];
    result = applySeedCanonical[result, topo];
    If[result === $Failed, Return[$Failed]];
    dsTimeOnlyExpressionToPublic020[result, topo]
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
   gen = <|"type" -> "momentum", "dLoop" -> i, "vectorType" -> "external", "vectorIndex" -> j, "vector" -> topo["effectiveLoopExternalMomenta"][[j]]|>;
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
   (* 反向映射同时受动量声明层和坐标 Jacobian 层约束；局部坐标可逆不能覆盖
      过完备 loop/无圈动量声明已经关闭的 topology capability。 *)
   If[! dsTopologyCapabilityQ[topo, "inverseKinematicsUsableQ"],
    Message[dSIBPPublicAPI::noinverse, <|
      "capabilities" -> Lookup[topo, "capabilities", <||>],
      "coordinateAudit" -> KeyTake[audit, {"status", "constraintResiduals", "parameterDependencies"}]
      |>];
    Return[$Failed]
    ];
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


integrandBuildingBlock[line_Association, pack_List, momentumMagnitude_] := Module[
   {lineId = line["id"], endpoints = line["endpoints"], packType = line["packType"], nPositions},
   nPositions = linePackNPositions[line, packType];
   Switch[packType,
    "massiveFull" | "massiveCross",
    Hh[MassiveBlock[lineFunctionPreset018[line], Lookup[line, "nu", nu], Lookup[line, "skType", "++"], lineId, endpoints, momentumMagnitude, pack[[nPositions[[1]]]], pack[[nPositions[[2]]]]]],
    "masslessFull",
    Hh[MasslessBlock[Lookup[line, "skType", "++"], lineId, endpoints, momentumMagnitude, pack[[First[nPositions]]]]],
    "masslessCross",
    Hh[MasslessCrossBlock[Lookup[line, "skType", "+-"], lineId, endpoints, momentumMagnitude]],
    _, 1
    ]
   ];


integrandLineFactor[topo_Association, int_J, e_Integer] := Module[
   {line = topo["lines"][[e]], pack = int[[2, e]], packType, momentumMagnitude, denominator},
   packType = actualLinePackType[topo, e, pack];
   momentumMagnitude = lineMomentumMagnitude[topo, e];
   denominator = momentumMagnitude^(-linePowerIndex[topo, int, e]);
   If[
    packType === "shrunk",
    denominator,
    denominator integrandBuildingBlock[Join[line, <|"packType" -> packType|>], pack, momentumMagnitude]
    ]
   ];


integrandISPFactor[topo_Association, int_J] := Times @@ Table[
   Lookup[topo["ispData"][[j]], "name", rho[j]]^int[[3, j]],
   {j, Length[topo["ispData"]]}
   ];


rep2Integrand[expr_] := Module[{topo = resolvePublicTopologyContext[]},
   If[topo === $Failed, $Failed, rep2Integrand[expr, topo]]
   ];


(* ::Chapter:: *)
(*013 Tree 积分表示与 family metadata*)

(* 本章只处理单槽 J[vertexPacks]。tree 与 loop 共用 Head，但任何入口都先按 arity 分派；
   tree family 的 massiveLegs 顺序同时固定 binary master 顺序和矩阵 tensor 顺序。 *)

integralKind[J[_List, _List, _List]] := "Loop";
integralKind[J[packs_List]] := If[VectorQ[packs, ListQ], "Tree", $Failed];
integralKind[_] := $Failed;


makeTreeFamilyData::badinput = "tree family 输入无效：`1`。";
treeIntegralShape::badshape = "tree J 的 pack 形状与 family 不一致：`1`。";


treeSignedExternalLegEnergy[vertex_Association] :=
  (* package 的 + 顶点相位为 Exp[-I E tau]，故论文 e^(I k0 tau) 中 k0=-E。 *)
  If[vertex["vertexType"] === "+", -vertex["externalLegEnergy"], vertex["externalLegEnergy"]];


treeVertexIssues[vertex_Association] := Module[{issues = {}, legs, required, missing},
   required = {"id", "nu0", "vertexType", "externalLegEnergy", "massiveLegs"};
   missing = Complement[required, Keys[vertex]];
   If[missing =!= {}, AppendTo[issues, <|"code" -> "missingVertexKeys", "keys" -> missing|>]];
   If[! MemberQ[{"+", "-"}, Lookup[vertex, "vertexType", Missing["vertexType"]]],
    AppendTo[issues, <|"code" -> "badVertexType", "value" -> Lookup[vertex, "vertexType", Missing["vertexType"]]|>]
    ];
   legs = Lookup[vertex, "massiveLegs", {}];
   If[! ListQ[legs] || ! And @@ (AssociationQ /@ legs),
    AppendTo[issues, <|"code" -> "badMassiveLegs"|>],
    Do[
     missing = Complement[{"id", "nu", "momentumMagnitude"}, Keys[legs[[i]]]];
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
          "signedExternalLegEnergy" -> treeSignedExternalLegEnergy[#],
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
     "sector" -> Lookup[spec, "sector", ""],
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


treeM0[vertex_Association] := Module[{p, momentumMagnitudes, identity},
   p = vertex["p"];
   momentumMagnitudes = Lookup[vertex["massiveLegs"], "momentumMagnitude"];
   identity = IdentityMatrix[2^p];
   If[p === 0,
    I vertex["signedExternalLegEnergy"] identity,
    -I Sum[momentumMagnitudes[[i]] treePauliLift[p, i, 2], {i, p}] + I vertex["signedExternalLegEnergy"] identity
    ]
   ];


treeM0Tilde[vertex_Association] := Module[{p, momentumMagnitudes, identity},
   p = vertex["p"];
   momentumMagnitudes = Lookup[vertex["massiveLegs"], "momentumMagnitude"];
   identity = IdentityMatrix[2^p];
   If[p === 0,
    I vertex["signedExternalLegEnergy"] identity,
    -I Sum[momentumMagnitudes[[i]] treePauliLift[p, i, 3], {i, p}] + I vertex["signedExternalLegEnergy"] identity
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
      If[lineIndexedPowerQ[line], Prepend[states, Lookup[baseline, line["id"], 0]], states],
      "shrunk",
      If[lineIndexedPowerQ[line], {Lookup[baseline, line["id"], 0]}, {}],
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


treeEndpointDistance[int_J, endpoints_List] := Total[Abs[First[int][[All, 1]] - endpoints]];


treeProgressKeyLessQ[target : {_, _}, source : {_, _}] :=
  target[[1]] < source[[1]] || (target[[1]] === source[[1]] && target[[2]] < source[[2]]);


treeRecurrenceStateHash[expr_] := IntegerString[Hash[HoldComplete[expr], "SHA256"], 16, 64];


(* 每条递推边都必须严格降低到指定 endpoint 的整数 L1 距离。该局部序保证递推 DAG
   不依赖任意迭代次数；完整表达式哈希另用于诊断实现错误造成的状态循环。 *)
treeSingleFamilyStepProgress[source_J, replacement_, endpoints_List, data_Association] := Module[
   {sourceDistance, targets, invalidTargets, targetDistances},
   sourceDistance = treeEndpointDistance[source, endpoints];
   targets = DeleteDuplicates[Cases[replacement, int_J, {0, Infinity}]];
   invalidTargets = Select[
     targets,
     ! treeIntegralQ[#, data] || ! And @@ (IntegerQ /@ First[#][[All, 1]]) &
     ];
   targetDistances = treeEndpointDistance[#, endpoints] & /@ Complement[targets, invalidTargets];
   <|
    "passQ" -> TrueQ[invalidTargets === {} && And @@ (# < sourceDistance & /@ targetDistances)],
    "source" -> source,
    "sourceDistance" -> sourceDistance,
    "targetIntegrals" -> targets,
    "targetDistances" -> targetDistances,
    "invalidTargets" -> invalidTargets
    |>
   ];


repIterativeData::badindex = "tree a 指标必须是可判定整数：`1`。";
repIterativeData::nosector = "tree 积分无法唯一匹配 sector family：`1`。";
repIterativeData::noprogress = "tree 递推没有严格趋近指定终点：`1`。 Tree recurrence did not strictly approach the requested endpoint: `1`.";
repIterativeData::cycle = "tree 递推检测到重复 canonical 状态：`1`。 Tree recurrence encountered a repeated canonical state: `1`.";


Options[repIterativeData] = {};


repIterativeData[expr_, end_: Automatic, data_Association, OptionsPattern[]] := Module[
   {endpoints, result = Expand[expr], integrals, allA, steps = 0, firstInt, packs, vertexIndex,
    replacement, progressData, seenStates = <||>, stateHash},
   endpoints = normalizeTreeEndpoints[end, data];
   If[endpoints === $Failed, Return[<|"status" -> "error", "result" -> $Failed, "steps" -> 0|>]];
   integrals = Select[DeleteDuplicates[Cases[result, int_J /; treeIntegralQ[int, data], {0, Infinity}]], True &];
   allA = Flatten[First[#][[All, 1]] & /@ integrals];
   If[! And @@ (IntegerQ /@ allA), Message[repIterativeData::badindex, Select[allA, ! IntegerQ[#] &]]; Return[<|"status" -> "error", "result" -> $Failed, "steps" -> 0|>]];
   AssociateTo[seenStates, treeRecurrenceStateHash[result] -> True];
   While[(integrals = treeReducibleIntegrals[result, endpoints, data]) =!= {},
    firstInt = First[integrals];
    packs = First[firstInt];
    vertexIndex = SelectFirst[Range[Length[endpoints]], packs[[#, 1]] =!= endpoints[[#]] &];
    replacement = treeSingleStepIntegral[firstInt, vertexIndex, endpoints[[vertexIndex]], data];
    If[replacement === $Failed, Return[<|"status" -> "singular", "result" -> $Failed, "steps" -> steps|>]];
    progressData = treeSingleFamilyStepProgress[firstInt, replacement, endpoints, data];
    If[! TrueQ[progressData["passQ"]],
     Message[repIterativeData::noprogress, progressData];
     Return[<|"status" -> "error", "reason" -> "nonDecreasingRecurrence", "result" -> $Failed,
       "steps" -> steps, "progressData" -> progressData|>]
     ];
    result = Expand[result /. firstInt -> replacement];
    stateHash = treeRecurrenceStateHash[result];
    If[KeyExistsQ[seenStates, stateHash],
     Message[repIterativeData::cycle, stateHash];
     Return[<|"status" -> "error", "reason" -> "recurrenceCycle", "result" -> $Failed,
       "steps" -> steps, "stateHash" -> stateHash|>]
     ];
    AssociateTo[seenStates, stateHash -> True];
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
     repIterativeSectorData[expr, end, $dSIBPTreeFamilyContext]["result"],
     repIterativeData[expr, end, $dSIBPTreeFamilyContext]["result"]
    ],
   Message[makeTreeFamilyData::badinput, {<|"code" -> "treeContextNotSet"|>}];
   $Failed
   ];


repIterative[expr_, end_, data_Association, OptionsPattern[]] /;
   KeyExistsQ[data, "vertices"] && ! KeyExistsQ[data, "families"] := Module[{activeData},
   (* 显式 family 调用同时刷新公开原始规则，保证随后可直接使用 repIterative0。 *)
   activeData = setTreeFamilyContext[data];
   repIterativeData[expr, end, activeData]["result"]
   ];


(* ::Chapter:: *)
(*Loop time-IBP 到 tree 的显式投影*)

(* 投影器从每个 loop J 的 shrunk pack 重建目标 sector，再按原始 line/endpoint 顺序打包 n。
   所有 theta、WT、zero-point 与 coincident canonical 已在 dtau 中完成；这里不重写传播子边界公式。 *)

loopToTreeProjection::badloop = "loop-to-tree 投影只接受合法三槽 loop J：`1`。";
loopToTreeProjection::mixedcontact = "mixed-sign line 不得产生 theta/contact shrink：`1`。";


loopIntegralShrunkLines[int : J[_, linePacks_List, _], topo_Association] := Select[
   Range[Min[Length[linePacks], topo["nE"]]],
   actualLinePackType[topo, #, linePacks[[#]]] === "shrunk" &&
     ! MemberQ[{"masslessCross", "massiveCross"}, topo["lines"][[#, "packType"]]] &
   ];


loopTreeTargetTopology[int : J[_, linePacks_List, _], topo_Association] := Module[{shrunk, badMixed},
   shrunk = loopIntegralShrunkLines[int, topo];
   badMixed = Select[shrunk, MemberQ[{"+-", "-+"}, Lookup[topo["lines"][[#]], "skType", "++"]] &];
   If[badMixed =!= {}, Message[loopToTreeProjection::mixedcontact, badMixed]; Return[$Failed]];
   If[shrunk === {}, topo, shrinkSectorTopology[topo, shrunk]]
   ];


(* loop 的 a0 留在 tree family 的 nu0 中；b0/bS0 没有 tree 指标槽，必须随完整物理幂次进入显式能量系数。 *)
loopTreeProjectionCoefficient[int : J[_, _, _], targetTopo_Association] := Module[
   {momentumMagnitudePower},
   momentumMagnitudePower = Times @@ Table[
      lineMomentumMagnitude[targetTopo, e]^(-linePowerIndex[targetTopo, int, e]),
      {e, targetTopo["nE"]}
      ];
   momentumMagnitudePower
   ];


loopTreeRelativeProjectionCoefficient[
   int : J[targetA_List, _, _], targetTopo_Association,
   referenceInt : J[referenceA_List, _, _], referenceTopo_Association
   ] := Module[{targetLinePower, referenceLinePower, momentumMagnitude},
   Times @@ Table[
      targetLinePower = linePowerIndex[targetTopo, int, e];
      referenceLinePower = linePowerIndex[referenceTopo, referenceInt, e];
      momentumMagnitude = lineMomentumMagnitude[targetTopo, e];
      momentumMagnitude^(-Expand[targetLinePower - referenceLinePower]),
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
          AppendTo[legStates, linePacks[[e, linePackNPositions[line, line["packType"]][[slot]]]]]
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
              "momentumMagnitude" -> lineMomentumMagnitude[topo, e]
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
       "vertexType" -> First[signs],
      "nu0" -> vertexZeroPoint[topo, active[[v]]],
       "externalLegEnergy" -> vertexExternalEnergy[topo, active[[v]]],
      "massiveLegs" -> legs
      |>,
     {v, Length[active]}
     ];
   makeTreeFamilyData[<|
     "name" -> topo["name"],
     "sector" -> sectorKeyFromShrunkLines[topo, Lookup[topo, "sectorShrunkLines", {}]],
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


treeSectorIntegralDistanceData[int_J, end_, context_Association] := Module[{family, endpoints},
   family = treeFamilyForIntegral[int, context];
   If[Head[family] === Missing, Return[$Failed]];
   endpoints = normalizeTreeEndpoints[treeSectorEndpoints[end, family, context], family];
   If[endpoints === $Failed || ! And @@ (IntegerQ /@ First[int][[All, 1]]), Return[$Failed]];
   <|"integral" -> int, "sector" -> family["sector"], "endpoints" -> endpoints,
    "remainingThetaLines" -> Length[thetaFullLineIndices[family["topology"]]],
    "distance" -> treeEndpointDistance[int, endpoints],
    "progressKey" -> {Length[thetaFullLineIndices[family["topology"]]], treeEndpointDistance[int, endpoints]}|>
   ];


treeSectorStepProgress[source_J, replacement_, end_, context_Association] := Module[
   {sourceData, targets, targetData, invalidTargets},
   sourceData = treeSectorIntegralDistanceData[source, end, context];
   targets = DeleteDuplicates[Cases[replacement, int_J /; integralKind[int] === "Tree", {0, Infinity}]];
   targetData = treeSectorIntegralDistanceData[#, end, context] & /@ targets;
   invalidTargets = Pick[targets, Head[#] === Symbol && # === $Failed & /@ targetData];
   <|
    "passQ" -> TrueQ[sourceData =!= $Failed && invalidTargets === {} &&
       And @@ (treeProgressKeyLessQ[Lookup[#, "progressKey", {Infinity, Infinity}], sourceData["progressKey"]] & /@ targetData)],
    "source" -> sourceData,
    "targets" -> targetData,
    "invalidTargets" -> invalidTargets
    |>
   ];


Options[repIterativeSectorData] = Options[repIterativeData];


repIterativeSectorData[expr_, end_: Automatic, context_Association, OptionsPattern[]] := Module[
   {result = Expand[expr], steps = 0, integrals, item, family, endpoints, packs, vertexIndex, unresolved,
    scanFailure, replacement, progressData, seenStates = <||>, stateHash},
   AssociateTo[seenStates, treeRecurrenceStateHash[result] -> True];
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
    item = First[unresolved];
    family = treeFamilyForIntegral[item, context];
    endpoints = normalizeTreeEndpoints[treeSectorEndpoints[end, family, context], family];
    If[endpoints === $Failed, Return[<|"status" -> "error", "result" -> $Failed, "steps" -> steps|>]];
    packs = First[item];
    vertexIndex = SelectFirst[Range[Length[endpoints]], packs[[#, 1]] =!= endpoints[[#]] &];
    replacement = treeSingleStepIntegral[item, vertexIndex, endpoints[[vertexIndex]], family];
    If[replacement === $Failed, Return[<|"status" -> "error", "reason" -> "recurrenceSingular", "result" -> $Failed, "steps" -> steps|>]];
    progressData = treeSectorStepProgress[item, replacement, end, context];
    If[! TrueQ[progressData["passQ"]],
     Message[repIterativeData::noprogress, progressData];
     Return[<|"status" -> "error", "reason" -> "nonDecreasingRecurrence", "result" -> $Failed,
       "steps" -> steps, "progressData" -> progressData|>]
     ];
    result = Expand[result /. item -> replacement];
    stateHash = treeRecurrenceStateHash[result];
    If[KeyExistsQ[seenStates, stateHash],
     Message[repIterativeData::cycle, stateHash];
     Return[<|"status" -> "error", "reason" -> "recurrenceCycle", "result" -> $Failed,
       "steps" -> steps, "stateHash" -> stateHash|>]
     ];
    AssociateTo[seenStates, stateHash -> True];
    steps++;
    ];
   <|"status" -> "reduced", "result" -> result, "steps" -> steps|>
   ];


repIterative[expr_, end_, context_Association, OptionsPattern[]] /; KeyExistsQ[context, "families"] := Module[{activeContext},
   (* 多 sector context 保留既有唯一分派门禁，同时同步本轮可直接替换的单步规则。 *)
   activeContext = setTreeFamilyContext[context];
   repIterativeSectorData[expr, end, activeContext]["result"]
   ];


(* ::Chapter:: *)
(*Tree dlog connection*)

(* dlog 输出始终把 primitive matrix、letter/constant-matrix 对和同序 master list 一起返回。
   多顶点 top block 是按 vertexOrder 的 Kronecker sum；contact source 由 DSTreeSeeds 单独提供。 *)

treeVertexDLogData[vertex_Association] := Module[
   {p, states, momentumMagnitudes, k0, omega0, omegaEx, tp, tpInv, m1, omega, letters, coeffs},
   p = vertex["p"];
   states = treeBinaryStates[p];
   momentumMagnitudes = Lookup[vertex["massiveLegs"], "momentumMagnitude"];
   k0 = vertex["signedExternalLegEnergy"];
   omega0 = -I DiagonalMatrix[Table[
      Log[k0 + Sum[(2 states[[row, i]] - 1) momentumMagnitudes[[i]], {i, p}]],
      {row, Length[states]}
      ]];
   omegaEx = DiagonalMatrix[Table[
     -Sum[states[[row, i]] (2 vertex["massiveLegs"][[i, "nu"]] + 1) Log[momentumMagnitudes[[i]]], {i, p}],
      {row, Length[states]}
      ]];
   tp = treeTp[vertex];
   tpInv = treeTpInverse[vertex];
   m1 = treeM1[vertex, vertex["nu0"] + 1];
   omega = Expand[omegaEx - I tpInv . omega0 . tp . m1];
   (* 每个顶点先列 massive-line momentum magnitudes，再按 binary master order 列 cut letters；
      多顶点输出按 vertexOrder 稳定拼接，保证矩阵序列化可复现。 *)
   letters = DeleteDuplicates@Join[momentumMagnitudes, Cases[omega0, Log[arg_] :> arg, Infinity]];
   coeffs = Association@Table[letter -> Map[Coefficient[#, Log[letter]] &, omega, {2}], {letter, letters}];
   <|"vertex" -> vertex["id"], "states" -> states, "omega" -> omega, "letters" -> letters, "letterMatrices" -> coeffs|>
   ];


treeEmbedVertexMatrix[matrix_List, vertexIndex_Integer, dimensions_List] := treeTensorProduct[
   Table[If[i === vertexIndex, matrix, IdentityMatrix[dimensions[[i]]]], {i, Length[dimensions]}]
   ];


dsTreeDLogBlock018[data_Association] := Module[{vertices, dimensions, omega, letters, letterMatrices, masters},
   vertices = treeVertexDLogData /@ data["vertices"];
   dimensions = 2^Lookup[data["vertices"], "p"];
   omega = Total[MapIndexed[treeEmbedVertexMatrix[#1["omega"], First[#2], dimensions] &, vertices]];
   letters = DeleteDuplicates[Flatten[Lookup[vertices, "letters"]]];
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
    "vertexBlocks" -> vertices,
    "sourceStructure" -> data["sourceStructure"]
    |>
   ];


dsTreeDLogBlock018[data_Association, seedData_] := Join[
   dsTreeDLogBlock018[data],
   <|"sourceEquations" -> seedData|>
   ];

(* ::Package:: *)

(* ::Chapter:: *)
(*018 上下文、消息、进度与公开 API 清单*)

If[! ValueQ[$dSIBPMessagesEnabled], $dSIBPMessagesEnabled = True];
If[! ValueQ[$dSIBPCurrentContext], $dSIBPCurrentContext = Missing["NotInitialized"]];

DSMessagesOn[] := ($dSIBPMessagesEnabled = True);
DSMessagesOff[] := ($dSIBPMessagesEnabled = False);
DSMessagesQ[] := TrueQ[$dSIBPMessagesEnabled];

dsMessagesEnabledQ[setting_: Automatic] := If[setting === Automatic, DSMessagesQ[], TrueQ[setting]];

(* 所有调用点直接提供逐句中英文本；此层只统一非字符串对象的显示，不伪造占位翻译。 *)
dsBilingualRuntimeText[text_] := ToString[text];


dsInfoPrint[text_, setting_: Automatic] := If[
   dsMessagesEnabledQ[setting], Print["[dSIBP] ", dsBilingualRuntimeText[text]]
   ];

dsWarningPrint[text_, setting_: Automatic] := If[
   dsMessagesEnabledQ[setting],
   If[TrueQ[$Notebooks],
    Print[Style["警告 / Warning: " <> dsBilingualRuntimeText[text], Darker[Red]]],
    Print["[dSIBP 警告 / Warning] ", dsBilingualRuntimeText[text]]
    ]
   ];

(* fatal error 不读取全局开关；即使用户关闭可选提醒也必须可见。 *)
dsErrorPrint[text_] := If[
   TrueQ[$Notebooks],
   Print[Style["错误 / Error: " <> dsBilingualRuntimeText[text], Red]],
   Print["[dSIBP 错误 / Error] ", dsBilingualRuntimeText[text]]
   ];

dsStageRun[label_String, expression_, setting_: Automatic] := Module[{result, elapsed},
   dsInfoPrint["开始 / Start: " <> label, setting];
   {elapsed, result} = AbsoluteTiming[expression];
   dsInfoPrint["完成 / Completed: " <> label <> " (" <> ToString[Round[elapsed, 0.001], InputForm] <> " s)", setting];
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

(* 失败初始化不得携带可被下游误读的部分能力；原始 declaration/kinematics audit
   仍保留各自的局部状态，公开 context capability 一律关闭。 *)
dsDisabledCapabilities[] := AssociationMap[
   False &,
   {
    "initializationUsableQ", "timeIBPUsableQ", "momentumIBPUsableQ",
    "derivativeUsableQ", "inverseKinematicsUsableQ", "backendExportUsableQ", "parityUsableQ"
    }
   ];


dsTopologyWithDisabledCapabilities[topo_Association] := Join[
   topo,
   <|"capabilities" -> dsDisabledCapabilities[]|>
   ];


dsTopologyWithDisabledCapabilities[topo_] := topo;


dsFailedInitializationData[reason_String, data_Association : <||>] := Module[{result},
   result = Join[data, <|
      "status" -> "failed",
      "reason" -> reason,
      "capabilities" -> dsDisabledCapabilities[]
      |>];
   If[KeyExistsQ[result, "topologyData"],
    result = Join[result, <|
       "topologyData" -> dsTopologyWithDisabledCapabilities[result["topologyData"]]
       |>]
    ];
   result
   ];


dsResolveContext[Automatic] := If[dsContextQ[$dSIBPCurrentContext], $dSIBPCurrentContext, Missing["NotInitialized"]];
dsResolveContext[context_Association] := If[dsContextQ[context], context, Missing["InvalidContext"]];
dsResolveContext[_] := Missing["InvalidContext"];

dsContextCapabilities[context_Association] := Lookup[
   context,
   "capabilities",
   Lookup[Lookup[context, "topology", <||>], "capabilities", <||>]
   ];

dsTopologyCapabilityQ[topo_Association, capability_String] := TrueQ[
   Lookup[Lookup[topo, "capabilities", <||>], capability, False]
   ];

dsContextCapabilityQ[context_Association, capability_String] := TrueQ[
   Lookup[dsContextCapabilities[context], capability, False]
   ];

dsContextSummary[context_Association] := <|
   "packageVersion" -> Lookup[context, "packageVersion", Missing["packageVersion"]],
   "inputHash" -> Lookup[context, "inputHash", Missing["inputHash"]],
   "caseName" -> Lookup[context, "caseName", Missing["caseName"]],
   "sectorKeys" -> Lookup[Lookup[context, "sectors", {}], "sectorKey", {}],
   "capabilities" -> dsContextCapabilities[context],
   "loopTreeProjectionConvention" -> Lookup[context, "loopTreeProjectionConvention", <||>]
   |>;


(* 公开函数清单是手册汇总表和成品 example 覆盖检查的共同来源。
   函数按用户工作流分组；符号 Head 与 option 名不混入函数覆盖计数。 *)
dsPublicAPISections[] := <|
   "initialization" -> {
     "DSInit", "DSInfo", "DSKinematics", "DSParameterNotation", "DSRedefineParameters"
     },
   "messages" -> {"DSMessagesOn", "DSMessagesOff", "DSMessagesQ"},
   "atomicOperations" -> {
     "dtau", "dqq", "dqk", "ds", "rep2innerform", "rep2outform", "rep2Integrand",
     "symmetry", "repSymmetry0"
     },
    "loopWorkflow" -> {"DSSeeds", "DSAllSeeds", "DSSeedGroups", "DSSeedGroupMetadata", "DSMetaSeedRange", "DSGenerateIBP", "DSLinear", "DSReorderIntegrals", "DSUserMI", "DSKiraPlan", "DSKiraExport", "DSKiraImport", "DSDE", "DSScaleCheck"},
   "pureTimeWorkflow" -> {
     "DSTreeSeeds", "repIterative", "DSTreeNaiveIBP", "DSTreeNaiveDE", "DSTreeDLogDE"
     },
   "introspection" -> {"DSPublicAPI"}
   |>;


dsPublicAPIOptions[] := <|
   "DSInit" -> Options[DSInit],
   "DSSeeds" -> Options[DSSeeds],
   "DSLinear" -> Options[DSLinear],
   "DSGenerateIBP" -> Options[DSGenerateIBP],
   "DSKiraPlan" -> Options[DSKiraPlan],
   "DSKiraExport" -> Options[DSKiraExport],
   "DSKiraImport" -> Options[DSKiraImport],
   "DSDE" -> Options[DSDE],
   "DSScaleCheck" -> Options[DSScaleCheck],
   "DSTreeNaiveIBP" -> Options[DSTreeNaiveIBP],
   "DSTreeNaiveDE" -> Options[DSTreeNaiveDE],
   "DSTreeDLogDE" -> Options[DSTreeDLogDE],
   "repIterative" -> Options[repIterative]
   |>;


DSPublicAPI[] := Module[{sections = dsPublicAPISections[]},
   <|
    "version" -> $dSIBPVersion,
    "sections" -> sections,
    "functions" -> DeleteDuplicates@Flatten[Values[sections]],
    "options" -> dsPublicAPIOptions[]
    |>
   ];

(* ::Package:: *)

(* ::Chapter:: *)
(*018 初始化与 metadata 序列化*)

Options[DSInit] = {
   WriteInitializationFiles -> False,
   InitializationDirectory -> Automatic,
   GenerateDerivativeMetadata -> False,
   OverwriteInitialization -> False,
   RegisterAsCurrent -> True,
   ProgressReporting -> Automatic,
   KinematicRules -> Automatic
   };

DSInit::badinput = "DSInit 输入不是有效的 topology Association，或 ISP/动量坐标不闭合。";
DSInit::sectorincomplete = "无法完整初始化 contact-reachable sectors：`1`。";
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
     "正在生成微分算符 / Building differential operators",
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
          Missing["DirectExternalLegEnergyDerivative"]
          ]
       |>
      ],
     progressSetting
     ];
   <|"status" -> If[FreeQ[operators, $Failed], "generated", "failed"], "variableCount" -> Length[generators], "operators" -> operators|>
   ];

dsInitializationIssueText[issue_Association] := Module[{code, details},
   code = Lookup[issue, "code", "unknownInitializationIssue"];
   details = KeyDrop[issue, {"severity", "code"}];
   "初始化问题 / Initialization issue: " <> code <>
    If[details === <||>, "", "：" <> ToString[details, InputForm]]
   ];

dsReadExistingManifest[path_String] := If[FileExistsQ[path], Quiet[Check[Get[path], $Failed]], Missing["NoManifest"]];


(* 初始化 metadata 固定为 UTF-8/LF 的可读 InputForm，避免 Windows Put 产生 CRLF 与行尾空格。 *)
dsWriteInitializationExpression[expr_, path_String] := Module[{text},
   text = ToString[expr, InputForm, PageWidth -> 120] <> "\n";
   text = StringReplace[text, RegularExpression["[ \\t]+(?=\\n|$)"] -> ""];
   writeKiraUTF8LFText[path, text]
   ];


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
   writeResult = Quiet[Check[KeyValueMap[(dsWriteInitializationExpression[#2, paths[#1]]; #1) &, fileData], $Failed]];
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
   If[Quiet[Check[dsWriteInitializationExpression[manifest, manifestPath]; True, False]] =!= True, Return[<|"status" -> "failed", "directory" -> directory|>]];
   <|"status" -> "written", "directory" -> directory, "manifest" -> manifestPath, "files" -> Append[paths, "manifest.wl" -> manifestPath]|>
   ];

DSInit[input_Association, OptionsPattern[]] := Module[
   {progress = OptionValue[ProgressReporting], topologyData, validation, subsetSummary, derivatives, context,
     inputHash, initDirectory, writeResult = <|"status" -> "notRequested"|>, warnings, errors,
     effectiveInput, kinematicAudit, declarationAudit, guide, guideText, parityDataList,
     parityRequestedQ, parityUsableQ, parityFailures},
   effectiveInput = If[
     OptionValue[KinematicRules] === Automatic,
     input,
     Join[input, <|"kinematicRules" -> OptionValue[KinematicRules]|>]
     ];
   inputHash = dsInputHash[effectiveInput];
   topologyData = dsStageRun[
     "初始化 topology、ISP 与完整 sector metadata / Initializing topology, ISP, and complete sector metadata",
     makeTopologyData[
       effectiveInput,
      PrecomputeShrinkSectorMetadata -> True
      ],
     progress
     ];
   validation = Lookup[topologyData, "validationReport", <|"errorCount" -> 1, "issues" -> {}|>];
   kinematicAudit = Lookup[topologyData, "kinematicCoordinateAudit", <||>];
   declarationAudit = Lookup[topologyData, "momentumDeclarationAudit", <||>];
   guide = kinematicParameterRedefinitionGuide[kinematicAudit];
   guideText = If[
     StringQ[Lookup[guide, "commandExample", None]],
     Lookup[guide, "commandExample", ""],
     Lookup[guide, "defaultBehavior", ""]
     ];
   dsInfoPrint[
     "动量角色：loopMomenta " <> ToString[Lookup[topologyData, "loopMomenta", {}], InputForm] <>
      "；loopExternalMomenta " <> ToString[Lookup[topologyData, "loopExternalMomenta", {}], InputForm] <>
      "；effectiveLoopExternalMomenta " <> ToString[Lookup[topologyData, "effectiveLoopExternalMomenta", {}], InputForm] <>
      "；independentExternalMomenta " <> ToString[Lookup[topologyData, "independentExternalMomenta", {}], InputForm] <>
      "；实际需要的 loop 方向 " <> ToString[Lookup[declarationAudit, "requiredLoopExternalDirections", {}], InputForm] <>
      "；实际需要的无圈模长 " <> ToString[Lookup[declarationAudit, "requiredIndependentMomentumMagnitudes", {}], InputForm] <>
      ". Momentum roles: loopMomenta " <> ToString[Lookup[topologyData, "loopMomenta", {}], InputForm] <>
      "; loopExternalMomenta " <> ToString[Lookup[topologyData, "loopExternalMomenta", {}], InputForm] <>
      "; effectiveLoopExternalMomenta " <> ToString[Lookup[topologyData, "effectiveLoopExternalMomenta", {}], InputForm] <>
      "; independentExternalMomenta " <> ToString[Lookup[topologyData, "independentExternalMomenta", {}], InputForm] <>
      "; required loop directions " <> ToString[Lookup[declarationAudit, "requiredLoopExternalDirections", {}], InputForm] <>
      "; required loop-free magnitudes " <> ToString[Lookup[declarationAudit, "requiredIndependentMomentumMagnitudes", {}], InputForm],
     progress
     ];
   dsInfoPrint[
     "动力学变量选择：" <> ToString[Lookup[kinematicAudit, "status", "unknown"]] <>
      "；缺省规则 " <> ToString[Lookup[kinematicAudit, "defaultRules", {}], InputForm] <>
      "；当前规则 " <> ToString[Lookup[kinematicAudit, "selectedRules", {}], InputForm] <>
      "；从属模长绑定 " <> ToString[Lookup[kinematicAudit, "dependentMagnitudeBindings", {}], InputForm] <>
      ". Kinematic-variable selection: " <> ToString[Lookup[kinematicAudit, "status", "unknown"]] <>
      "; default rules " <> ToString[Lookup[kinematicAudit, "defaultRules", {}], InputForm] <>
      "; selected rules " <> ToString[Lookup[kinematicAudit, "selectedRules", {}], InputForm] <>
      "; dependent magnitude bindings " <> ToString[Lookup[kinematicAudit, "dependentMagnitudeBindings", {}], InputForm],
     progress
     ];
   dsInfoPrint[
     "必需模长的参数覆盖 " <> ToString[kinematicRequiredMagnitudeCoverage[topologyData], InputForm] <>
      ". Parameter coverage of required magnitudes " <> ToString[kinematicRequiredMagnitudeCoverage[topologyData], InputForm],
     progress
     ];
   dsInfoPrint[
     "参数可保持缺省，也可复制以下格式重定义：" <> guideText <>
      "。规则左端写原始 sp[...]，不要写 ssij/sEi -> custom；右端写自定义参数表达式。 " <>
      "Keep the default parameters or copy this form to redefine them: " <> guideText <>
      ". Put the original sp[...] on the left, not ssij/sEi -> custom, and the custom parameter expression on the right.",
     progress
     ];
   If[Lookup[topologyData, "status", None] === "invalidInput" || topologyValidationErrorQ[validation],
    errors = Select[Lookup[validation, "issues", {}], Lookup[#, "severity", ""] === "error" &];
    Scan[dsErrorPrint[dsInitializationIssueText[#]] &, errors];
    Message[DSInit::badinput]; dsErrorPrint["topology/ISP 初始化失败；上述详情同时保存在 validationReport[\"issues\"]。 Topology/ISP initialization failed; the details above are also stored in validationReport[\"issues\"]."];
    Return[dsFailedInitializationData[
      "invalidInputOrTopology",
      <|"inputHash" -> inputHash, "topologyData" -> topologyData, "validationReport" -> validation|>
      ]]
    ];
   subsetSummary = Lookup[topologyData, "precomputedShrinkSectorSummary", <||>];
   If[Lookup[subsetSummary, "status", "missing"] =!= "generated" || ! TrueQ[Lookup[subsetSummary, "completeCoverageQ", False]],
    Message[DSInit::sectorincomplete, subsetSummary]; dsErrorPrint["contact-reachable sector 未完整初始化。 Contact-reachable sectors were not initialized completely."];
    Return[dsFailedInitializationData[
      "incompleteSectorMetadata",
      <|"inputHash" -> inputHash, "topologyData" -> topologyData|>
      ]]
    ];
   parityDataList = Lookup[Lookup[topologyData, "sectorMetadataList", {}], "parityData", {}];
   parityRequestedQ = Lookup[topologyData, "parityConstraints", {}] =!= {};
   parityUsableQ = parityDataList =!= {} && And @@ Lookup[parityDataList, "parityUsableQ", {False}];
   parityFailures = Select[
     parityDataList,
     Lookup[#, "status", "disabled"] === "disabled" &&
       Lookup[#, "reason", "noParityConstraints"] =!= "noParityConstraints" &
     ];
   topologyData = Join[topologyData, <|
      "capabilities" -> Join[
        Lookup[topologyData, "capabilities", <||>],
        <|"parityUsableQ" -> parityUsableQ|>
        ]
      |>];
   If[parityRequestedQ && parityFailures =!= {},
    dsErrorPrint[
     "显式 parity 约束无法在全部 sector 上定义，初始化已拒绝：" <>
      ToString[parityFailures, InputForm] <>
      ". Explicit parity constraints are not defined on every sector; initialization was rejected: " <>
      ToString[parityFailures, InputForm]
     ];
    Return[dsFailedInitializationData[
      "invalidParityConstraints",
      <|"inputHash" -> inputHash, "topologyData" -> topologyData,
        "parityFailures" -> parityFailures|>
      ]]
    ];
   If[! parityRequestedQ && ! parityUsableQ,
    dsErrorPrint[
     "当前函数系统没有已证明可运输的 parity 闭合，parity 筛选已禁用；普通 IBP 仍可继续。 " <>
      "The current function system has no proved transportable parity closure; parity filtering is disabled, while ordinary IBP remains available."
     ]
    ];
    warnings = Select[Lookup[validation, "issues", {}], Lookup[#, "severity", ""] === "warning" &];
   Scan[dsWarningPrint[dsInitializationIssueText[#], progress] &, warnings];
   derivatives = If[
     TrueQ[OptionValue[GenerateDerivativeMetadata]] && dsTopologyCapabilityQ[topologyData, "derivativeUsableQ"],
     dsDerivativeMetadata[topologyData, progress],
     Missing["NotGenerated"]
     ];
   context = <|
     "status" -> "initialized",
     "packageVersion" -> $dSIBPVersion,
     "inputHash" -> inputHash,
     "caseName" -> Lookup[topologyData, "name", "unnamed"],
      "input" -> effectiveInput,
     "topology" -> topologyData,
     "topologyData" -> topologyData,
     "capabilities" -> Lookup[topologyData, "capabilities", <||>],
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
     Message[DSInit::writefailed, OptionValue[InitializationDirectory]];
     dsWarningPrint["InitializationDirectory 无效；内存数学 context 仍然有效。 InitializationDirectory is invalid; the in-memory mathematical context remains valid."];
     writeResult = <|"status" -> "failed", "reason" -> "invalidInitializationDirectory",
       "requestedDirectory" -> OptionValue[InitializationDirectory]|>,
     writeResult = dsWriteInitializationFiles[context, initDirectory, OptionValue[OverwriteInitialization]];
     If[writeResult["status"] === "conflict",
      Message[DSInit::initconflict, initDirectory];
      dsWarningPrint["已有初始化信息与当前输入不一致，未覆盖；内存数学 context 仍然有效。 Existing initialization data do not match the current input and were not overwritten; the in-memory mathematical context remains valid."]
      ];
     If[! MemberQ[{"written", "conflict"}, writeResult["status"]],
      Message[DSInit::writefailed, initDirectory];
      dsWarningPrint["初始化文件未完整写入；内存数学 context 仍然有效。 Initialization files were not written completely; the in-memory mathematical context remains valid."]
      ]
     ];
    context = Join[context, <|"initializationWrite" -> writeResult|>]
    ];
   If[TrueQ[OptionValue[RegisterAsCurrent]],
    $dSIBPCurrentContext = context;
    setIBPTopologyContext[context["topology"]]
    ];
   dsInfoPrint[
    "初始化完成：" <> context["caseName"] <> "，sector " <> ToString[Length[context["sectors"]]] <> "/" <> ToString[Length[context["sectors"]]] <>
     ". Initialization completed: " <> context["caseName"] <> ", sectors " <> ToString[Length[context["sectors"]]] <> "/" <> ToString[Length[context["sectors"]]],
    progress
    ];
   context
   ];

DSInit[input_, OptionsPattern[]] := (
   Message[DSInit::badinput];
   dsErrorPrint["DSInit 需要 Association 输入。 DSInit requires an Association input."];
   dsFailedInitializationData["inputNotAssociation", <|"input" -> HoldForm[input]|>]
   );

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
(*018 统一三槽 seed 与 linearData 高层入口*)

(* DSSeeds 只生产符号 general templates；连续指标域由 DSGenerateIBP 持有，
   数值系数由 DSLinear 的 CoefficientRules 持有。 *)
Options[DSSeeds] = {ProgressReporting -> Automatic};
Options[DSLinear] = {
   LinearSystemMode -> "symbolic",
   CoefficientRules -> Automatic,
   KiraOrdering -> Automatic,
   AuditLevel -> "standard",
   ProgressReporting -> Automatic
   };

DSSeeds::noinit = "DSSeeds 需要有效的 DSInit context。";
DSSeeds::failed = "canonical seed 生成未通过门禁：`1`。";
DSSeeds::capability = "当前 context 不具备 seed 生成所需能力：`1`。";
DSLinear::noinit = "DSLinear 需要有效的 DSInit context。";
DSLinear::badseed = "DSLinear 需要 DSSeeds 返回的 canonical seed Association。";
DSLinear::badmode = "LinearSystemMode 只允许 \"symbolic\" 或 \"numeric\"，收到 `1`。";
DSLinear::failed = "linearData 生成未通过门禁：`1`。";
DSLinear::capability = "当前 context 不具备 linearData 生成所需能力：`1`。";
DSLinear::context = "seedData 与 context 不是同一次初始化的产物。";


(* loop seed 的底层生成器使用 qq/qk/kk；公开高层入口必须在序列化前统一投影到
   当前 context 的用户坐标，使 DSLinear 与后续 backend 不再接触内部 Gram 原子。 *)
dsLoopSeedExpressionToPublicCoordinates[expr_, topo_Association] := publicProtectJMap[
   expr,
   Function[body,
    Expand[scalarProductInternalToUser[body /. internalISPToUserRules[topo], topo]]
    ]
   ];


dsPublicLoopSeedEntry[entry_Association, topo_Association] := If[
   KeyExistsQ[entry, "equation"],
   Join[entry, <|
     "equation" -> dsLoopSeedExpressionToPublicCoordinates[entry["equation"], topo]
     |>],
   entry
   ];


dsPublicLoopSeedBatch[seedData_Association, topo_Association] := If[
   Lookup[seedData, "status", "missing"] === "generated",
   Join[seedData, <|
     "equations" -> (dsPublicLoopSeedEntry[#, topo] & /@ Lookup[seedData, "equations", {}]),
     "allSeeds" -> (dsPublicLoopSeedEntry[#, topo] & /@ Lookup[seedData, "allSeeds", {}]),
     "coordinateRepresentation" -> "user"
     |>],
   seedData
   ];


(* 018 的公开 seed 只有 J[aList,linePacks,ispList]。论文 vertex basis 仍可由 tree
   公式模块内部构造，但不得再决定 DSSeeds/DSLinear 的公开积分形状。 *)


DSLinear[seedData_Association, context_: Automatic, opts : OptionsPattern[]] := Module[
   {resolved, workingSeedData, workingContract, internalDigest, linearData, mode = OptionValue[LinearSystemMode],
    auditLevel = OptionValue[AuditLevel], progress = OptionValue[ProgressReporting]},
   resolved = dsResolveContext[context];
   If[Head[resolved] === Missing,
    Message[DSLinear::noinit]; dsErrorPrint["请传入与 seed 同源的 DSInit context。 Pass the DSInit context from which the seeds originated."]; Return[<|"status" -> "failed", "reason" -> "missingContext"|>]
    ];
    If[! KeyExistsQ[seedData, "completeCanonicalQ"],
     Message[DSLinear::badseed]; dsErrorPrint["输入不是 canonical seed batch。 The input is not a canonical seed batch."]; Return[<|"status" -> "failed", "reason" -> "notCanonicalSeedBatch"|>]
     ];
    If[Lookup[Lookup[seedData, "dSIBPContextSummary", <||>], "inputHash", Missing["seedHash"]] =!=
      Lookup[resolved, "inputHash", Missing["contextHash"]],
     Message[DSLinear::context]; dsErrorPrint["seed 与 context 的 inputHash 不一致。 The seed and context inputHash values differ."]; Return[<|
       "status" -> "failed", "reason" -> "contextMismatch"
       |>]
     ];
    If[Lookup[seedData, "dSIBPStatus", "failed"] =!= "generated" ||
      ! dsContextCapabilityQ[resolved, "timeIBPUsableQ"] ||
      (Lookup[resolved["topology"], "ibpMode", "full"] === "full" &&
        ! dsContextCapabilityQ[resolved, "momentumIBPUsableQ"]),
     Message[DSLinear::capability, dsContextCapabilities[resolved]];
     dsErrorPrint["seed 或 context 未通过 linearData 能力门禁。 The seed or context failed the linearData capability gate."]; Return[<|
       "status" -> "failed", "reason" -> "capabilityGate",
       "capabilities" -> dsContextCapabilities[resolved]
       |>]
     ];
   If[! MemberQ[{"symbolic", "numeric"}, mode],
    Message[DSLinear::badmode, mode]; dsErrorPrint["linearData 模式无效。 The linearData mode is invalid."]; Return[<|"status" -> "failed", "reason" -> "invalidLinearSystemMode", "mode" -> mode|>]
    ];
    If[! MemberQ[{"standard", "full"}, auditLevel],
    Return[<|"status" -> "failed", "reason" -> "invalidAuditLevel",
      "auditLevel" -> auditLevel, "allowedAuditLevels" -> {"standard", "full"}|>]
     ];
    workingSeedData = If[
      Lookup[resolved["topology"], "ibpMode", "full"] === "timeOnly",
      dsTimeOnlyDataToInternal020[seedData, resolved],
      seedData
      ];
    If[workingSeedData === $Failed,
     Return[<|"status" -> "failed", "reason" -> "timeOnlyPublicInputRequired"|>]
     ];
    If[Lookup[resolved["topology"], "ibpMode", "full"] === "timeOnly",
     workingContract = Lookup[workingSeedData, "artifactContract", <||>];
     internalDigest = dsGeneratedIBPSourceDigest[
       Lookup[workingSeedData, "equations", {}],
       resolved,
       <|"rangeRules" -> Lookup[workingSeedData, "targetEnvelopeRules", {}]|>
       ];
     workingSeedData = Join[workingSeedData, <|
        "representation" -> "J[aList,linePacks,ispList]",
        "artifactContract" -> Join[workingContract, <|"sourceDigest" -> internalDigest|>]
        |>]
     ];
    linearData = dsStageRun[
     "转换 backend-neutral linearData / Converting to backend-neutral linearData",
     If[mode === "numeric",
       makeSampledLinearSystemData[
         workingSeedData,
        resolved["topology"],
        KiraOrdering -> OptionValue[KiraOrdering],
        AuditLevel -> auditLevel,
        CoefficientRules -> OptionValue[CoefficientRules]
        ],
       makeLinearSystemData[
         workingSeedData,
        resolved["topology"],
        KiraOrdering -> OptionValue[KiraOrdering],
        AuditLevel -> auditLevel
        ]
     ],
     progress
     ];
   If[Lookup[linearData, "status", "missing"] =!= "generated",
    Message[DSLinear::failed, Lookup[linearData, "status", Missing["status"]]];
    dsErrorPrint["linearData 未通过 canonical/linearity 门禁。 linearData failed the canonical or linearity gate."];
    Return[Join[linearData, <|"dSIBPStatus" -> "failed", "dSIBPContextSummary" -> dsContextSummary[resolved]|>]]
    ];
    If[Lookup[resolved["topology"], "ibpMode", "full"] === "timeOnly",
     linearData = dsTimeOnlyDataToPublic020[linearData, resolved];
     If[linearData === $Failed,
      Return[<|"status" -> "failed", "reason" -> "timeOnlyPublicConversionFailed"|>]
      ];
     linearData = Join[linearData, <|"representation" -> "J[sectorKey,timeShifts,stateBits]"|>]
     ];
    Join[linearData, <|
      "dSIBPStatus" -> "generated",
      "dSIBPContextSummary" -> dsContextSummary[resolved],
       "contextCapabilities" -> dsContextCapabilities[resolved],
        "contextInputHash" -> Lookup[resolved, "inputHash", Missing["inputHash"]]
      |>]
   ];

(* ::Package:: *)

(* ::Chapter:: *)
(*018 tree sector-tagged 数据边界*)

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
     deltaTimePower, deltaLinePowers, explicitMomentumMagnitudePowers, lineMomentumMagnitudes, auditedProjectionCoefficient},
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
   targetBInteger = Table[lineIntegerPowerIndex[targetTopology, loopIntegral, e], {e, targetTopology["nE"]}];
   referenceBInteger = Table[lineIntegerPowerIndex[referenceTopology, referenceInt, e], {e, referenceTopology["nE"]}];
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
   explicitMomentumMagnitudePowers = -deltaLinePowers;
   lineMomentumMagnitudes = Table[
     lineMomentumMagnitude[targetTopology, e],
     {e, targetTopology["nE"]}
     ];
   (* 两侧积分都使用 (-tau)^A；deltaTimePower 只作幂次审计，不产生重复的 (-1)^DeltaA。 *)
   auditedProjectionCoefficient = Times @@ MapThread[Power, {lineMomentumMagnitudes, explicitMomentumMagnitudePowers}];
   <|
    "sectorKey" -> sectorKeyFromShrunkLines[targetTopology, Lookup[targetTopology, "sectorShrunkLines", {}]],
    "integral" -> treeIntegral,
    "coefficient" -> Expand[loopCoefficient projectionCoefficient],
    "sourceLoopIntegral" -> loopIntegral,
    "projectionCoefficient" -> projectionCoefficient,
    "physicalPowerAudit" -> <|
      "target" -> <|
        "sectorKey" -> sectorKeyFromShrunkLines[targetTopology, Lookup[targetTopology, "sectorShrunkLines", {}]],
        "aInteger" -> targetAInteger,
        "aZeroPoint" -> targetAZeroPoint,
        "aPhysical" -> targetAPhysical,
        "bInteger" -> targetBInteger,
        "bZeroPoint" -> targetBZeroPoint,
        "bPhysical" -> targetBPhysical,
        "treeNu0" -> targetAZeroPoint
        |>,
      "reference" -> <|
        "sectorKey" -> sectorKeyFromShrunkLines[referenceTopology, Lookup[referenceTopology, "sectorShrunkLines", {}]],
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
      "explicitMomentumMagnitudePowers" -> explicitMomentumMagnitudePowers,
      "lineMomentumMagnitudes" -> lineMomentumMagnitudes,
      "auditedProjectionCoefficient" -> auditedProjectionCoefficient,
      "projectionCoefficientMatchesAudit" -> TrueQ[projectionCoefficient === auditedProjectionCoefficient],
      "zeroPointRules" -> targetTopology["zeroPointRules"],
      "unsafePowerExpand" -> False
      |>
    |>
   ];

dsCombineTreeTaggedTerms[terms_List] := Map[
   Function[group,
    Module[{optionalKeys, optionalData},
     optionalKeys = Select[
       {"sourceLoopIntegral", "projectionCoefficient", "physicalPowerAudit"},
       Function[key, AnyTrue[group, Function[item, KeyExistsQ[item, key]]]]
       ];
     optionalData = Association@Map[
        Switch[#,
          "sourceLoopIntegral", "sourceLoopIntegrals",
          "projectionCoefficient", "projectionCoefficients",
          "physicalPowerAudit", "physicalPowerAudits"
          ] -> Lookup[group, #] &,
        optionalKeys
        ];
     Join[
      First[group],
      <|
       "coefficient" -> Total[Lookup[group, "coefficient"]],
       "contributions" -> (KeyTake[#, Prepend[optionalKeys, "coefficient"]] & /@ group)
       |>,
      optionalData
      ]
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


dsTreeTaggedSourceAwareStep[
   token : dsTreeToken[sectorKey_String, int_J], vertexIndex_Integer, endpoint_Integer,
   family_Association, familyContext_Association
   ] := Module[
   {packs = First[int], current, seedA, states, vertexId, localIntegrals, records, ruleData, rules, result},
   current = packs[[vertexIndex, 1]];
   If[current === endpoint, Return[token]];
   seedA = If[current < endpoint, current + 1, current];
   states = treeBinaryStates[family["vertices"][[vertexIndex, "p"]]];
   vertexId = family["vertexOrder"][[vertexIndex]];
   localIntegrals = J[ReplacePart[packs, vertexIndex -> Prepend[#, seedA]]] & /@ states;
   records = dsDirectTreeSeedRecord[vertexId, #, family, familyContext] & /@ localIntegrals;
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


dsTreeTaggedSingleStep[
   token : dsTreeToken[sectorKey_String, int_J], vertexIndex_Integer, endpoint_Integer,
   family_Association, familyContext_Association
   ] := Module[{bareResult},
   If[TrueQ[Lookup[family, "requiresSourceRules", False]] && AssociationQ[Lookup[family, "topology", Missing["NoLoopTopology"]]],
    Return[dsTreeTaggedSourceAwareStep[token, vertexIndex, endpoint, family, familyContext]]
    ];
   bareResult = treeSingleStepIntegral[int, vertexIndex, endpoint, family];
   If[bareResult === $Failed, $Failed, bareResult /. item_J :> dsTreeToken[sectorKey, item]]
   ];


dsTreeTokenDistanceData[token : dsTreeToken[sectorKey_String, int_J], end_, familyContext_Association] := Module[
   {family, endpoints},
   family = dsTreeFamilyBySector[sectorKey, familyContext];
   If[Head[family] === Missing || ! treeIntegralQ[int, family] ||
     ! And @@ (IntegerQ /@ First[int][[All, 1]]), Return[$Failed]];
   endpoints = normalizeTreeEndpoints[treeSectorEndpoints[end, family, familyContext], family];
   If[endpoints === $Failed, Return[$Failed]];
   <|"token" -> token, "sectorKey" -> sectorKey, "endpoints" -> endpoints,
    "remainingThetaLines" -> Length[thetaFullLineIndices[family["topology"]]],
    "distance" -> treeEndpointDistance[int, endpoints],
    "progressKey" -> {Length[thetaFullLineIndices[family["topology"]]], treeEndpointDistance[int, endpoints]}|>
   ];


(* tagged linearData 允许递推跨 contact sector；每条跨 sector 依赖仍须严格降低各自 endpoint 距离。 *)
dsTreeTaggedStepProgress[source_dsTreeToken, replacement_, end_, familyContext_Association] := Module[
   {sourceData, targets, targetData, invalidTargets},
   sourceData = dsTreeTokenDistanceData[source, end, familyContext];
   targets = DeleteDuplicates[Cases[replacement, token : dsTreeToken[_String, _J] :> token, {0, Infinity}]];
   targetData = dsTreeTokenDistanceData[#, end, familyContext] & /@ targets;
   invalidTargets = Pick[targets, (# === $Failed & /@ targetData)];
   <|
    "passQ" -> TrueQ[sourceData =!= $Failed && invalidTargets === {} &&
       And @@ (treeProgressKeyLessQ[Lookup[#, "progressKey", {Infinity, Infinity}], sourceData["progressKey"]] & /@ targetData)],
    "source" -> sourceData,
    "targets" -> targetData,
    "invalidTargets" -> invalidTargets
    |>
   ];


Options[dsRepIterativeTreeLinearData] = Options[repIterativeData];


dsRepIterativeTreeLinearData[data_Association, end_: Automatic, context_Association, OptionsPattern[]] := Module[
   {familyContext, result, steps = 0, tokens, token, sectorKey, int, family, endpoints, vertexIndex,
    reducedTerms, replacement, progressData, seenStates = <||>, stateHash},
   If[! dsTreeLinearDataQ[data], Return[<|"status" -> "error", "reason" -> "invalidTreeLinearData"|>]];
   familyContext = dsTreeFamilyContext[context];
   result = Expand[dsTreeTokenExpression[data]];
   AssociateTo[seenStates, treeRecurrenceStateHash[result] -> True];
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
    vertexIndex = SelectFirst[Range[Length[endpoints]], First[int][[#, 1]] =!= endpoints[[#]] &];
    replacement = dsTreeTaggedSingleStep[token, vertexIndex, endpoints[[vertexIndex]], family, familyContext];
    If[replacement === $Failed, Return[<|"status" -> "error", "reason" -> "taggedStepFailed", "steps" -> steps|>]];
    progressData = dsTreeTaggedStepProgress[token, replacement, end, familyContext];
    If[! TrueQ[progressData["passQ"]],
     Message[repIterativeData::noprogress, progressData];
     Return[<|"status" -> "error", "reason" -> "nonDecreasingRecurrence", "steps" -> steps,
       "progressData" -> progressData|>]
     ];
    result = Expand[result /. token -> replacement];
    stateHash = treeRecurrenceStateHash[result];
    If[KeyExistsQ[seenStates, stateHash],
     Message[repIterativeData::cycle, stateHash];
     Return[<|"status" -> "error", "reason" -> "recurrenceCycle", "steps" -> steps,
       "stateHash" -> stateHash|>]
     ];
    AssociateTo[seenStates, stateHash -> True];
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

Options[DSTreeNaiveIBP] = {AuditLevel -> "standard", ProgressReporting -> Automatic};

DSTreeNaiveIBP::badmasters = "tree naive IBP 需要非空、无重复且可唯一匹配 sector 的 tagged master 列表。";
DSTreeNaiveIBP::nonsquare = "tree naive IBP 方程数 `1` 与待约化对象数 `2` 不相等。";
DSTreeNaiveIBP::solvefailed = "tree naive IBP 线性系统求解失败。";


dsTreeTaggedMasterQ[record_] := AssociationQ[record] &&
   StringQ[Lookup[record, "sectorKey", None]] &&
   MatchQ[Lookup[record, "integral", None], _J] &&
   ! TrueQ[Lookup[record, "coefficient", 0] === 0];


dsTreeResolveNaiveMasters[Automatic, context_Association] := Module[{dlog = dsTreeMultiSectorDLog[context]},
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


dsTreeNaiveSeedRecords[masterFamilyRecords_List, familyContext_Association, progress_] := Flatten@dsProgressMap[
    "正在生成 naive tree time-IBP / Building naive-tree time-IBP relations",
    masterFamilyRecords,
    Function[item,
     With[{master = item["master"], family = item["family"]},
      MapIndexed[
       Function[{vertexId, position},
        With[{seedIntegral = J[ReplacePart[
             First[master["integral"]],
             First[position] -> ReplacePart[First[master["integral"]][[First[position]]], 1 -> 1]
             ]]},
         dsDirectTreeSeedRecord[vertexId, seedIntegral, family, familyContext]
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


dsTreeNaiveIBPRaw018[context_Association, masters_: Automatic, OptionsPattern[DSTreeNaiveIBP]] /; dsContextQ[context] := Module[
   {resolvedMasters, familyContext, masterFamilyRecords, seedRecords, equations, masterTokens, allTokens,
    unknownTokens, matrix, constantVector, solution, tokenRules, publicRules, solveResiduals, status},
   If[treeFormulaMasslessPendingQ018[context],
    Return[treeFormulaPendingRederivation018["DSTreeNaiveIBP", context]]
    ];
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
   seedRecords = dsTreeNaiveSeedRecords[masterFamilyRecords, familyContext, OptionValue[ProgressReporting]];
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
   solveResiduals = If[
     OptionValue[AuditLevel] === "full",
     Together /@ Expand[equations /. tokenRules],
     Missing["NotRunAtStandardAuditLevel"]
     ];
   publicRules = dsTreePublicReductionRecord /@ tokenRules;
   status = If[
     FreeQ[publicRules, $Failed] &&
      (Head[solveResiduals] === Missing || And @@ (TrueQ[# === 0] & /@ solveResiduals)),
     "solved",
     "failed"
     ];
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
    "auditLevel" -> OptionValue[AuditLevel],
    "context" -> context,
    "equationConvention" -> "projected loop dtau == 0; non-master tagged tree integrals solved in the supplied master basis",
    "formulaRecurrenceUsedQ" -> False
    |>
   ];


DSTreeNaiveIBP[_, ___] := (Message[DSTreeNaiveIBP::badmasters]; <|"status" -> "failed", "reason" -> "invalidContextOrMasters"|>);

(* ::Package:: *)
(* 本模块保留 016 direct pure-time 公式作为 massive-only 交叉检查；018 生产路径统一使用
   J[aList,linePacks,{}]。regular 项直接由
   vertex-family 的 M1/M0 构造，contact 项直接消费 compiled WT/shrinkTerms 与共同 theta。
   loop 三槽表示仅由独立交叉验证调用，不是本模块的生产路径。 *)

(* ::Chapter:: *)
(*Pure-time 表示能力与状态访问*)

(* 同分支 massless 内线的 regular 导数在 n=0/1 间翻转；当前用户约定的 tree pack
   只保存 massive h 状态，因此这类线必须显式拒绝，不能当作无状态相位。 *)
dsPureTimeUnsupportedLines[family_Association] := Select[
   Range[Lookup[family["topology"], "nE", 0]],
   With[{line = family["topology", "lines"][[#]]},
     Lookup[line, "state", "full"] =!= "shrunk" && Lookup[line, "packType", ""] === "masslessFull"
     ] &
   ];


dsPureTimeFamilyUsableQ[family_Association] := dsPureTimeUnsupportedLines[family] === {};


dsTreeVertexIndex[family_Association, vertexId_] := Module[{position},
   position = FirstPosition[family["vertexOrder"], vertexId, Missing["NoVertex"]];
   If[Head[position] === Missing, position, First[position]]
   ];


dsTreeLegState[int_J, family_Association, lineId_, endpointSlot_Integer] := Module[
   {matches, vertexIndex, legIndex},
   matches = Reap[
       Do[
        legIndex = FirstPosition[
          Lookup[family["vertices"][[vertexIndex, "massiveLegs"]], "id", {}],
          {lineId, endpointSlot},
          Missing["NoLeg"]
          ];
        If[Head[legIndex] =!= Missing, Sow[{vertexIndex, First[legIndex]}]],
        {vertexIndex, Length[family["vertices"]]}
        ]
       ][[2]];
   matches = If[matches === {}, {}, First[matches]];
   If[Length[matches] =!= 1,
    Missing["TreeLegState", lineId, endpointSlot, Length[matches]],
    {vertexIndex, legIndex} = First[matches];
    int[[1, vertexIndex, 1 + legIndex]]
    ]
   ];


(* ::Chapter:: *)
(*Regular M1/M0 time seed*)

dsTreeStateVectorIntegrals[int_J, family_Association, vertexIndex_Integer, aValue_] := Module[
   {packs = First[int], states},
   states = treeBinaryStates[family["vertices"][[vertexIndex, "p"]]];
   J[ReplacePart[packs, vertexIndex -> Prepend[#, aValue]]] & /@ states
   ];


dsDirectTreeRegularSeed[vertexId_, int_J, family_Association] := Module[
   {vertexIndex, vertex, pack, currentA, stateRow, currentIntegrals, lowerIntegrals, equationVector},
   If[! treeIntegralQ[int, family], Return[$Failed]];
   vertexIndex = dsTreeVertexIndex[family, vertexId];
   If[Head[vertexIndex] === Missing, Return[$Failed]];
   vertex = family["vertices"][[vertexIndex]];
   pack = First[int][[vertexIndex]];
   currentA = First[pack];
   stateRow = treeStateIndex[Rest[pack]];
   currentIntegrals = dsTreeStateVectorIntegrals[int, family, vertexIndex, currentA];
   lowerIntegrals = dsTreeStateVectorIntegrals[int, family, vertexIndex, currentA - 1];
   equationVector = Expand[
     treeM1[vertex, vertex["nu0"] + currentA] . lowerIntegrals +
      treeM0[vertex] . currentIntegrals
     ];
   Expand[equationVector[[stateRow]]]
   ];


(* ::Chapter:: *)
(*Direct 共同-theta contact*)

dsDirectTreeAtomicContactChoices[
   vertexId_, int_J, family_Association, lineIndex_Integer
   ] := Module[
   {topo = family["topology"], line, endpointSlots, endpointSlot, n1, n2, coefficient, shrinkTerms},
   line = topo["lines"][[lineIndex]];
   endpointSlots = lineEndpointSlotsAtVertex[line, vertexId];
   If[Length[endpointSlots] =!= 1 || Lookup[line, "packType", ""] =!= "massiveFull", Return[{}]];
   endpointSlot = First[endpointSlots];
   n1 = dsTreeLegState[int, family, line["id"], 1];
   n2 = dsTreeLegState[int, family, line["id"], 2];
   If[MemberQ[{n1, n2}, _Missing], Return[{}]];
    coefficient = KroneckerDelta[n1 + n2, 1] (-1)^(
        If[endpointSlot === 1, n1, n2] + thetaBoundarySignOffset[topo, lineIndex]
        );
   shrinkTerms = lineCompiledShrinkTerms[line];
   Map[
    <|
      "lineIndex" -> lineIndex,
      "coefficient" -> coefficient Lookup[#, "coefficient", 0],
      "bShift" -> Lookup[#, "bShift", 1],
      "zeroPointShift" -> Lookup[#, "zeroPointShift", lineShrinkZeroPointShift[line]],
      "aShift" -> Lookup[#, "bShift", 1]
      |> &,
    shrinkTerms
    ]
   ];


dsTreeContactTargetIntegral[
   int_J,
   sourceFamily_Association,
   targetFamily_Association,
   choices_List
   ] := Module[
   {sourcePacks = First[int], sourceTopo = sourceFamily["topology"], targetTopo = targetFamily["topology"],
    sourceVertices, targetVertices, targetRepMap, selectedLines, targetPacks, sourceClass, aValue, legStates},
   sourceVertices = sourceFamily["vertexOrder"];
   targetVertices = targetFamily["vertexOrder"];
   targetRepMap = Lookup[
     targetTopo,
     "sectorVertexRepresentativeMap",
     AssociationThread[targetTopo["vertexIds"] -> targetTopo["vertexIds"]]
     ];
   selectedLines = Lookup[choices, "lineIndex"];
   targetPacks = Table[
     sourceClass = Select[sourceVertices, Lookup[targetRepMap, #, #] === targetVertices[[targetIndex]] &];
     aValue = Total[
        First[sourcePacks[[dsTreeVertexIndex[sourceFamily, #]]]] & /@ sourceClass
        ] - Total[
        Map[
         Function[choice,
          If[
           And @@ (Lookup[targetRepMap, #, #] === targetVertices[[targetIndex]] & /@
              sourceTopo["lines"][[choice["lineIndex"], "endpoints"]]),
           choice["aShift"],
           0
           ]
          ],
         choices
         ]
        ];
     legStates = Map[
       Function[leg,
        dsTreeLegState[int, sourceFamily, leg["id"][[1]], leg["id"][[2]]]
        ],
       targetFamily["vertices"][[targetIndex, "massiveLegs"]]
       ];
     If[MemberQ[legStates, _Missing], Return[$Failed]];
     Prepend[legStates, aValue],
     {targetIndex, Length[targetVertices]}
     ];
   J[targetPacks]
   ];


dsTreeLineZeroPoint[topo_Association, e_Integer] := If[
   MemberQ[Lookup[topo, "sectorShrunkLines", {}], e] || Lookup[topo["lines"][[e]], "state", "full"] === "shrunk",
   lineBSZeroPoint[topo, e],
   lineBZeroPoint[topo, e]
   ];


dsDirectTreeContactCoefficient[
   int_J,
   targetInt_J,
   sourceFamily_Association,
   targetFamily_Association,
   choices_List,
   thetaBundleCoefficient_
   ] := Module[
    {sourceTopo = sourceFamily["topology"], targetTopo = targetFamily["topology"],
     shiftByLine, deltaLinePowers, lineMomentumMagnitudes, atomicCoefficient},
   (* source 与 target 都按 (-tau)^A 定义，合并时间幂不产生额外连续幂相位。
      vertex basis 已除去逐 sector prefactor；统一 J 中的 residual power 再乘 N_t/N_s 后，
      每条 contact line 只剩 compiled s+z，因而不随用户 bS0 重基改变。 *)
   shiftByLine = Association@Map[
      Lookup[#, "lineIndex"] -> (Lookup[#, "bShift", 0] + Lookup[#, "zeroPointShift", 0]) &,
      choices
      ];
   deltaLinePowers = Table[
     Expand[Lookup[shiftByLine, e, 0]],
     {e, sourceTopo["nE"]}
     ];
   lineMomentumMagnitudes = Table[lineMomentumMagnitude[targetTopo, e], {e, targetTopo["nE"]}];
   atomicCoefficient = Times @@ Lookup[choices, "coefficient"];
   Expand[
    thetaBundleCoefficient atomicCoefficient
      Times @@ MapThread[Power, {lineMomentumMagnitudes, -deltaLinePowers}]
      sectorPrefactorRatio018[
       makeSectorMetadata[sourceTopo],
       makeSectorMetadata[targetTopo]
       ]
    ]
   ];


dsDirectTreeContactTerms[
   vertexId_, int_J, sourceFamily_Association, familyContext_Association
   ] := Module[
   {topo = sourceFamily["topology"], connectedLines, eligibleLines, bundles, sourceShrunk,
    oddSubsets, atomicChoices, totalShrunk, targetSector, targetFamily, targetInt, coefficient, terms = {}},
   connectedLines = DeleteDuplicates@Flatten[Cases[
       Lookup[topo, "vertexLines", {}][[dsTreeVertexIndex[sourceFamily, vertexId]]],
       {e_Integer, _} :> e
       ]];
   eligibleLines = Select[
     connectedLines,
     Lookup[topo["lines"][[#]], "packType", ""] === "massiveFull" &&
       Lookup[topo["lines"][[#]], "state", "full"] =!= "shrunk" &&
       Length[lineEndpointSlotsAtVertex[topo["lines"][[#]], vertexId]] === 1 &
     ];
   bundles = GatherBy[eligibleLines, thetaBundleKey[topo, #] &];
   sourceShrunk = Lookup[topo, "sectorShrunkLines", {}];
   Do[
    oddSubsets = Select[Rest[Subsets[bundle]], OddQ[Length[#]] &];
    Do[
     atomicChoices = dsDirectTreeAtomicContactChoices[vertexId, int, sourceFamily, #] & /@ selected;
     If[AnyTrue[atomicChoices, # === {} &], Continue[]];
     Do[
      totalShrunk = Sort@Union[sourceShrunk, Lookup[choice, "lineIndex"]];
       targetSector = sectorKeyFromShrunkLines[topo, totalShrunk];
      targetFamily = dsTreeFamilyBySector[targetSector, familyContext];
      If[Head[targetFamily] === Missing, Return[$Failed]];
      targetInt = dsTreeContactTargetIntegral[int, sourceFamily, targetFamily, choice];
      If[targetInt === $Failed, Return[$Failed]];
      coefficient = dsDirectTreeContactCoefficient[
        int, targetInt, sourceFamily, targetFamily, choice, 2^(1 - Length[selected])
        ];
      If[! TrueQ[coefficient === 0],
       AppendTo[terms, <|
         "sectorKey" -> targetSector,
         "integral" -> targetInt,
         "coefficient" -> coefficient,
         "selectedLines" -> Lookup[choice, "lineIndex"],
         "route" -> "directCompiledTheta"
         |>]
       ],
      {choice, Tuples[atomicChoices]}
      ],
     {selected, oddSubsets}
     ],
    {bundle, bundles}
    ];
   terms
   ];


(* ::Chapter:: *)
(*公开 direct seed record*)

dsTreeExpressionTerms[expr_, sectorKey_String] := Module[{terms, records},
   terms = If[Head[Expand[expr]] === Plus, List @@ Expand[expr], {Expand[expr]}];
   records = Map[
     Function[term,
      With[{integrals = DeleteDuplicates[Cases[term, int_J :> int, {0, Infinity}]]},
       If[Length[integrals] =!= 1,
        $Failed,
        <|"sectorKey" -> sectorKey, "integral" -> First[integrals],
          "coefficient" -> Expand[term /. First[integrals] -> 1], "route" -> "directM1M0"|>
        ]
       ]
      ],
     terms
     ];
   If[MemberQ[records, $Failed], $Failed, records]
   ];


dsDirectTreeSeedRecord[
   vertexId_, int_J, sourceFamily_Association, familyContext_Association
   ] := Module[{regular, regularTerms, contactTerms, combined},
   If[! dsPureTimeFamilyUsableQ[sourceFamily],
    Return[<|"status" -> "failed", "reason" -> "masslessFullNeedsTreeState",
      "lineIndices" -> dsPureTimeUnsupportedLines[sourceFamily]|>]
    ];
   regular = dsDirectTreeRegularSeed[vertexId, int, sourceFamily];
   If[regular === $Failed, Return[<|"status" -> "failed", "reason" -> "regularSeedFailed"|>]];
   regularTerms = dsTreeExpressionTerms[regular, sourceFamily["sector"]];
   contactTerms = dsDirectTreeContactTerms[vertexId, int, sourceFamily, familyContext];
   If[MemberQ[{regularTerms, contactTerms}, $Failed],
    Return[<|"status" -> "failed", "reason" -> "contactSeedFailed"|>]
    ];
   combined = dsCombineTreeTaggedTerms[Join[regularTerms, contactTerms]];
   <|
    "status" -> "generated",
    "generator" -> dtau[vertexId],
    "treeSeed" -> Total[Lookup[#, "coefficient"] Lookup[#, "integral"] & /@ combined],
    "treeIntegral" -> int,
    "sectorKey" -> sourceFamily["sector"],
    "generationRoute" -> "directPureTime",
    "loopSeed" -> Missing["NotUsed"],
    "treeLinearData" -> <|
      "status" -> "generated",
      "terms" -> combined,
      "termCount" -> Length[combined],
      "sectorKeys" -> DeleteDuplicates[Lookup[combined, "sectorKey"]],
      "expression" -> Total[Lookup[#, "coefficient"] Lookup[#, "integral"] & /@ combined],
      "referenceTreeIntegral" -> int,
      "coefficientConvention" -> "direct tree physical powers from M1/M0 and compiled WT"
      |>
   |>
   ];


(* ::Chapter:: *)
(*Pure-time backend-neutral linearData*)

dsPureTimeTaggedIntegral[term_Association] := dsTreeToken[
   Lookup[term, "sectorKey", Missing["SectorKeyRequired019"]],
   Lookup[term, "integral", Missing["TreeIntegral"]]
   ];


dsPureTimeLinearEquation[record_Association, integralIndex_Association] := Module[
   {terms, rules},
   terms = Lookup[Lookup[record, "treeLinearData", <||>], "terms", {}];
   rules = Merge[
     Rule[
        integralIndex[dsPureTimeTaggedIntegral[#]],
        Lookup[#, "coefficient", 0]
        ] & /@ terms,
     Total
     ];
   <|
    "source" -> "directPureTime",
    "generator" -> Lookup[record, "generator", Missing["generator"]],
     "sectorKey" -> Lookup[record, "sectorKey", Missing["SectorKeyRequired019"]],
    "referenceTreeIntegral" -> Lookup[record, "treeIntegral", Missing["TreeIntegral"]],
    "coefficientRules" -> Normal[rules],
    "constantTerm" -> 0,
    "nonlinearTerms" -> {},
    "linearQ" -> True
    |>
   ];


makePureTimeLinearSystemData[batch_Association, context_Association] /; dsContextQ[context] := Module[
   {records, terms, tokens, integralIndex, linearEquations, publicIntegrals, coefficientDiagnostics},
   If[Lookup[batch, "status", "missing"] =!= "generated" ||
     Lookup[batch, "representation", None] =!= "J[vertexPacks]",
    Return[<|"status" -> "notGenerated", "reason" -> "notPureTimeSeedBatch"|>]
    ];
   records = Lookup[batch, "seedRecords", {}];
   terms = Flatten[Lookup[Lookup[records, "treeLinearData", <||>], "terms", {}], 1];
   If[AnyTrue[terms, ! StringQ[Lookup[#, "sectorKey", None]] || ! MatchQ[Lookup[#, "integral", None], J[_List]] &],
    Return[<|"status" -> "notReady", "reason" -> "invalidSectorTaggedTreeTerms"|>]
    ];
   tokens = DeleteDuplicates[dsPureTimeTaggedIntegral /@ terms];
   integralIndex = makeIntegralIndex[tokens];
   linearEquations = dsPureTimeLinearEquation[#, integralIndex] & /@ records;
   publicIntegrals = Map[
     <|"id" -> integralIndex[#], "sectorKey" -> #[[1]], "integral" -> #[[2]]|> &,
     tokens
     ];
   coefficientDiagnostics = linearCoefficientDiagnostics[linearEquations];
   <|
    "status" -> "generated",
    "caseName" -> Lookup[batch, "caseName", context["topology", "name"]],
    "ibpMode" -> "timeOnly",
    "representation" -> "sectorTaggedJ[vertexPacks]",
    "topology" -> context["topology"],
    "integralCount" -> Length[tokens],
    "equationCount" -> Length[linearEquations],
    "integralList" -> tokens,
    "publicIntegralList" -> publicIntegrals,
    "integralRules" -> Normal[integralIndex],
    "sectorMetadataList" -> Lookup[batch, "sectorMetadataList", {}],
    "topologyValidationReport" -> context["validationReport"],
    "seedCoverageReport" -> <|
      "passQ" -> True,
      "mode" -> "timeOnly",
      "completeTimeGenerationQ" -> True,
      "completeMomentumGenerationQ" -> False
      |>,
    "linearEquations" -> linearEquations,
    "linearQ" -> And @@ Lookup[linearEquations, "linearQ", False],
    "nonlinearEquationCount" -> Count[Lookup[linearEquations, "linearQ", False], False],
    "numericCoefficientSystemQ" -> coefficientDiagnostics["numericCoefficientSystemQ"],
    "coefficientVariables" -> coefficientDiagnostics["coefficientVariables"],
    "sourceSeedBatch" -> KeyDrop[batch, {"equations", "seedRecords"}]
    |>
   ];

(* ::Package:: *)

(* 本文件实现 018 的模板化连续指标撒点。DSSeeds 先生成完整离散态并执行
   EOM/canonical；本模块只展开 general 连续指标，并保留可供 DSLinear 审计的来源信息。 *)


(* ::Chapter:: *)
(*Seed 模板构造与完整性封装*)

If[! ValueQ[$dSIBPLastSeedTemplates], $dSIBPLastSeedTemplates = Missing["NotGenerated"]];
If[! ValueQ[$dSIBPLastSeedGroups], $dSIBPLastSeedGroups = Missing["NotGenerated"]];
If[! ValueQ[$dSIBPLastSeedGroupMetadata], $dSIBPLastSeedGroupMetadata = Missing["NotGenerated"]];


DSAllSeeds::noseeds = "尚未生成 seed 模板。请先成功调用 DSSeeds。 No seed templates are available. Run DSSeeds successfully first.";
DSAllSeeds::badseed = "输入不含 DSSeeds 生成的 allSeeds。 The input does not contain allSeeds generated by DSSeeds.";
DSSeedGroups::noseeds = "尚未生成分组 seed 模板。请先成功调用 DSSeeds。 No grouped seed templates are available. Run DSSeeds successfully first.";
DSSeedGroups::badseed = "输入不含 DSSeeds 生成的 seedGroups。 The input does not contain seedGroups generated by DSSeeds.";
DSSeedGroupMetadata::badseed = "输入不含 DSSeeds 生成的 seedGroupMetadata。 The input does not contain seedGroupMetadata generated by DSSeeds.";


dsTemplateSource[topo_Association, sectorKey_String, ibpClass_String, shrunkLines_List] := Which[
   sectorKeyTopQ[sectorKey, Lookup[topo, "ibpMode", "full"], Length[Lookup[topo, "lines", {}]]] && ibpClass === "qIBP", "momentum",
   sectorKeyTopQ[sectorKey, Lookup[topo, "ibpMode", "full"], Length[Lookup[topo, "lines", {}]]] && ibpClass === "tIBP", "time",
   ibpClass === "qIBP", {"shrinkSectorMomentum", shrunkLines},
   True, {"shrinkSectorTime", shrunkLines}
   ];


dsTemplateGeneratorLabel[generator_Association] := If[
   Lookup[generator, "type", "missing"] === "time",
   timeGeneratorLabel[generator],
   momentumGeneratorLabel[generator]
   ];


dsTemplateGeneratorClass[generator_Association] := If[
   Lookup[generator, "type", "missing"] === "time", "tIBP", "qIBP"
   ];


(* loop 模板只遍历离散 n=0,1，不代入任何连续指标。这样 EOM 在撒点前完成，
   而 a/b/ISP 仍能由 DSGenerateIBP 统一或逐指标展开。 *)
dsLoopTemplatesForTopology[topo_Association] := Module[
   {base, continuousIndices, discreteVariables, discreteData, generators, rawTemplates,
    sectorKey, shrunkLines, metadata, representation, records},
   base = makeBaseIntegral[topo];
   continuousIndices = continuousIndexVariables[base];
   discreteVariables = DeleteDuplicates[Cases[base, _n, Infinity]];
   discreteData = selectedDiscreteSeedRules[topo];
   If[Lookup[discreteData, "status", "failed"] =!= "generated",
    Return[<|"status" -> "failed", "reason" -> "discreteEnumerationFailed",
      "sectorKey" -> sectorKeyFromShrunkLines[topo, Lookup[topo, "sectorShrunkLines", {}]],
      "discreteData" -> discreteData|>]
    ];
   generators = Select[
     makeIBPGenerators[topo],
     Function[generator,
      Lookup[generator, "type", "missing"] === "time" ||
       Lookup[topo, "ibpMode", "full"] === "full"
      ]
     ];
   rawTemplates = Table[
     <|"generatorData" -> generator, "generator" -> dsTemplateGeneratorLabel[generator],
       "ibpClass" -> dsTemplateGeneratorClass[generator],
       "expression" -> If[
         Lookup[generator, "type", "missing"] === "time",
         applyTimeGeneratorSeed[topo, base, generator],
         applyMomentumGeneratorSeed[topo, base, generator]
         ]|>,
     {generator, generators}
     ];
   If[MemberQ[Lookup[rawTemplates, "expression", {}], $Failed],
    Return[<|"status" -> "failed", "reason" -> "generatorTemplateFailed"|>]
    ];
   shrunkLines = Lookup[topo, "sectorShrunkLines", {}];
   sectorKey = sectorKeyFromShrunkLines[topo, shrunkLines];
   metadata = Lookup[topo, "sectorMetadata", makeSectorMetadata[topo]];
   representation = If[
     Lookup[topo, "ibpMode", "full"] === "timeOnly",
     "J[timePowers,linePacks,isp]",
     "J[timePowers,indexedLinePacks,isp]"
     ];
   records = Flatten[
     Table[
      Module[{expr = applySeedCanonical[template["expression"] /. discreteRule, topo]},
       <|
        "source" -> dsTemplateSource[topo, sectorKey, template["ibpClass"], shrunkLines],
        "sectorKey" -> sectorKey,
        "sectorShrunkLines" -> shrunkLines,
        "sectorMetadata" -> metadata,
        "generator" -> template["generator"],
        "ibpClass" -> template["ibpClass"],
        "continuousIndices" -> continuousIndices,
        "sourceIntegral" -> (base /. discreteRule),
        "discreteVariables" -> discreteVariables,
        "discreteRules" -> discreteRule,
        "discreteStateCountExpected" -> discreteData["ruleCount"],
        "rawBinaryDiscreteStateCount" -> Lookup[
          discreteData, "rawBinaryStateCount", 2^Length[discreteVariables]
          ],
        "discreteSeedMode" -> Lookup[discreteData, "mode", "allBinaryStates"],
        "masslessCanonicalDirection" -> Lookup[
          discreteData, "canonicalDirection", Missing["NotApplicable"]
          ],
        "equation" -> Expand[expr],
        "forbiddenNData" -> forbiddenNData[topo, expr],
        "eomCanonicalQ" -> ! containsForbiddenNQ[topo, expr],
        "representation" -> representation,
        "ibpMode" -> Lookup[topo, "ibpMode", "full"]
        |>
       ],
      {template, rawTemplates}, {discreteRule, discreteData["rules"]}
      ],
     1
     ];
   <|
    "status" -> "generated",
    "sectorKey" -> sectorKey,
    "recordCount" -> Length[records],
    "discreteVariables" -> discreteVariables,
    "discreteStateCount" -> Length[discreteData["rules"]],
    "rawBinaryDiscreteStateCount" -> Lookup[
      discreteData, "rawBinaryStateCount", 2^Length[discreteVariables]
      ],
    "eliminatedAlgebraicStateCount" -> Lookup[
      discreteData, "eliminatedAlgebraicStateCount", 0
      ],
    "discreteSeedMode" -> Lookup[discreteData, "mode", "allBinaryStates"],
    "masslessCanonicalDirection" -> Lookup[
      discreteData, "canonicalDirection", Missing["NotApplicable"]
      ],
    "allSeeds" -> records
    |>
   ];


dsLoopSeedTemplateData[context_Association, seedData_Association] := Module[
   {rootTopo, metadataList, shrunkLists, topologies, pieces, bad, records},
   rootTopo = context["topology"];
   metadataList = Lookup[seedData, "sectorMetadataList", {makeSectorMetadata[rootTopo]}];
   shrunkLists = DeleteCases[Lookup[metadataList, "sectorShrunkLines", {}], {}];
   topologies = Join[{rootTopo}, shrinkSectorTopology[rootTopo, #] & /@ shrunkLists];
   pieces = dsLoopTemplatesForTopology /@ topologies;
   bad = Select[pieces, Lookup[#, "status", "failed"] =!= "generated" &];
   If[bad =!= {}, Return[<|"status" -> "failed", "reason" -> "sectorTemplateFailed", "failures" -> bad|>]];
   records = Flatten[Lookup[pieces, "allSeeds", {}], Infinity];
   <|"status" -> "generated", "allSeeds" -> records, "sectorCount" -> Length[pieces],
     "templateCount" -> Length[records],
     "discreteStateAudits" -> (KeyTake[#, {
           "sectorKey", "discreteVariables", "discreteStateCount",
           "rawBinaryDiscreteStateCount", "eliminatedAlgebraicStateCount",
           "discreteSeedMode", "masslessCanonicalDirection"
           }] & /@ pieces)|>
   ];


makeAllSeedTemplateData[context_Association, seedData_Association] :=
   dsLoopSeedTemplateData[context, seedData];


dsSeedTemplateHashPayload[records_List] := KeyDrop[
    #,
    {"templateHash", "templateSetHash", "templateOrdinal", "templateCount", "contextInputHash", "caseName"}
    ] & /@ records;


dsSeedTemplateRecordHash[record_Association] := IntegerString[
   Hash[First[dsSeedTemplateHashPayload[{record}]], "SHA256"],
   16,
   64
   ];


dsSealSeedTemplates[records_List, context_Association] := Module[{flat, payload, hash, count},
   flat = Flatten[records, Infinity];
   count = Length[flat];
   payload = dsSeedTemplateHashPayload[flat];
   hash = IntegerString[Hash[payload, "SHA256"], 16, 64];
   MapIndexed[
    Join[#1, <|"templateHash" -> dsSeedTemplateRecordHash[#1],
       "templateSetHash" -> hash, "templateOrdinal" -> First[#2],
       "templateCount" -> count, "contextInputHash" -> context["inputHash"],
       "caseName" -> context["caseName"]|>] &,
    flat
    ]
   ];


DSAllSeeds[seedData_Association] := Module[{seeds = Lookup[seedData, "allSeeds", Missing["NotFound"]]},
   If[! ListQ[seeds], Message[DSAllSeeds::badseed]; dsErrorPrint[
      "输入中没有可用的 allSeeds。 No usable allSeeds field was found in the input."
      ]; Return[$Failed]];
   seeds
   ];


DSAllSeeds[] := If[
   ListQ[$dSIBPLastSeedTemplates],
   $dSIBPLastSeedTemplates,
   Message[DSAllSeeds::noseeds];
   dsErrorPrint["尚无 seed 模板。 No seed templates have been generated."];
   $Failed
   ];


DSSeedGroups[seedData_Association] := Module[{groups = Lookup[seedData, "seedGroups", Missing["NotFound"]]},
   If[! ListQ[groups], Message[DSSeedGroups::badseed]; dsErrorPrint[
      "输入中没有可用的 seedGroups。 No usable seedGroups field was found in the input."
      ]; Return[$Failed]];
   groups
   ];


DSSeedGroups[] := If[
   ListQ[$dSIBPLastSeedGroups],
   $dSIBPLastSeedGroups,
   Message[DSSeedGroups::noseeds];
   dsErrorPrint["尚无分组 seed 模板。 No grouped seed templates have been generated."];
   $Failed
   ];


DSSeedGroupMetadata[seedData_Association] := Module[
   {metadata = Lookup[seedData, "seedGroupMetadata", Missing["NotFound"]]},
   If[! ListQ[metadata], Message[DSSeedGroupMetadata::badseed]; dsErrorPrint[
      "输入中没有可用的 seedGroupMetadata。 No usable seedGroupMetadata field was found in the input."
      ]; Return[$Failed]];
   metadata
   ];


DSSeedGroupMetadata[] := If[
   ListQ[$dSIBPLastSeedGroupMetadata],
   $dSIBPLastSeedGroupMetadata,
   Message[DSSeedGroups::noseeds];
   dsErrorPrint["尚无 seed 分组说明。 No seed-group metadata have been generated."];
   $Failed
   ];


(* ::Chapter:: *)
(*连续指标提取与范围门禁*)

DSGenerateIBP::badseeds = "seeds 必须是 DSSeeds 生成的模板列表或含 J 的表达式列表。 seeds must be a template list generated by DSSeeds or a list of expressions containing J.";
DSGenerateIBP::badrange = "撒点范围格式或整数边界无效：`1`。 The sampling range format or integer bounds are invalid: `1`.";
DSGenerateIBP::coverage = "精细范围没有精确覆盖模板指标：`1`。 Detailed ranges do not exactly cover the template indices: `1`.";
DSGenerateIBP::discrete = "n_i 是已在模板阶段遍历的离散指标，不得再次撒点：`1`。 n_i are discrete indices already enumerated in the template stage and must not be sampled again: `1`.";
DSGenerateIBP::symbolicn = "模板仍含符号 n_i，说明离散态/EOM 阶段未完成：`1`。 Symbolic n_i remain in the templates, so discrete-state enumeration or EOM canonicalization is incomplete: `1`.";
DSGenerateIBP::integrity = "seed 模板完整性检查失败：`1`。 Seed-template integrity validation failed: `1`.";
Options[DSGenerateIBP] = {AuditLevel -> "standard", ProgressReporting -> Automatic};
$dsMetaSeedRangeState = Missing["NotInitialized"];


dsSeedTemplateEntries[seeds_] := Flatten[{seeds}, Infinity];


(* 公开坐标模板在撒点前只投影一次。canonical 若重新引入底层原子，才需要在该点
   再投影；该判定只跳过恒等变换，不改变任何代数或 sector 规则。 *)
dsInternalCoordinatePresentQ018[expr_] := ! FreeQ[
   expr,
   _qq | _qk | _kk | _z | _xi | _rho | _externalLegSquaredCoordinate
   ];


dsSeedTemplateEquation[entry_Association] := Lookup[entry, "equation", Lookup[entry, "treeSeed", Missing["NoEquation"]]];
dsSeedTemplateEquation[entry_] := entry;


dsContinuousIndicesFromIntegral[J[aList_, linePacks_, ispList_]] := DeleteDuplicates@Join[
    Quiet@Check[Variables[Flatten[{aList}]], Cases[aList, _a, Infinity]],
    DeleteDuplicates[Cases[linePacks, _b | _bS, Infinity]],
    Quiet@Check[Variables[Flatten[{ispList}]], Flatten[{ispList}]]
    ];
dsSeedTemplateContinuousIndices[entries_List] := Module[{declared, inferred},
   declared = DeleteDuplicates@Flatten[Lookup[Select[entries, AssociationQ], "continuousIndices", {}], Infinity];
   inferred = DeleteDuplicates@Flatten[
      dsContinuousIndicesFromIntegral /@ DeleteDuplicates[Cases[dsSeedTemplateEquation /@ entries, _J, Infinity]],
      Infinity
      ];
   DeleteDuplicates@Join[declared, inferred]
   ];


dsSeedTemplateSymbolicN[entries_List] := DeleteDuplicates[Cases[dsSeedTemplateEquation /@ entries, _n, Infinity]];


(* ::Chapter:: *)
(*Seed shift metadata 初始化*)

(* 每个积分先把全部参数 Flatten 成同一种数据面，再用 Variables 发现指标；这里不读取
   aList/linePacks/ispList 的位置或 pack 长度，因此 sector 表示变化不影响 shift 提取。 *)
dsFlattenSeedIntegralData[expr_] := Cases[
   expr,
   HoldPattern[J[args___]] :> Flatten[{args}],
   Infinity
   ];


dsVariablesFromFlattenedSeedData[data_List] := DeleteDuplicates@Quiet@Check[
    Variables[DeleteCases[Flatten[data], _String]],
    {}
    ];


dsEntrySeedVariables[entry_] := Module[{equation, source},
   equation = dsSeedTemplateEquation[entry];
   source = If[AssociationQ[entry], Lookup[entry, "sourceIntegral", Missing["NoSource"]], Missing["NoSource"]];
   dsVariablesFromFlattenedSeedData@Join[
     dsFlattenSeedIntegralData[equation],
     If[Head[source] === J, dsFlattenSeedIntegralData[source], {}]
     ]
   ];


dsSeedMetadataHash[entries_List] := IntegerString[
   Hash[HoldComplete[dsSeedTemplateEquation /@ entries], "SHA256"],
   16,
   64
   ];


(* DSSeeds 的推荐层次按物理生成元分组；用户仍可把 flat allSeeds 作为一个总组传入。 *)
dsSeedSourceDescriptor[entry_] := With[
   {
    sectorKey = If[AssociationQ[entry], Lookup[entry, "sectorKey", Missing["sectorKey"]], Missing["sectorKey"]],
    ibpClass = If[AssociationQ[entry], Lookup[entry, "ibpClass", "unknownIBP"], "unknownIBP"],
    generator = If[AssociationQ[entry], Lookup[entry, "generator", Missing["generator"]], Missing["generator"]]
    },
   HoldComplete[sectorKey, ibpClass, generator]
   ];


dsDefaultSeedGroups[records_List] := GatherBy[records, dsSeedSourceDescriptor];


dsSeedGroupMetadataFromGroups[groups_List] := MapIndexed[
   Function[{group, position}, <|
     "groupOrdinal" -> First[position],
     "sourceDescriptors" -> DeleteDuplicates[dsSeedSourceDescriptor /@ group],
     "sectorKeys" -> DeleteDuplicates[Lookup[Select[group, AssociationQ], "sectorKey", {}]],
     "ibpClasses" -> DeleteDuplicates[Lookup[Select[group, AssociationQ], "ibpClass", {}]],
     "generators" -> DeleteDuplicates[Lookup[Select[group, AssociationQ], "generator", {}]],
     "templateOrdinals" -> Lookup[Select[group, AssociationQ], "templateOrdinal", {}],
     "templateCount" -> Length[group]
     |>],
   groups
   ];


(* flat 输入整体统计；存在二级或更深列表时只认最外层分组，每组内部任意深度 Flatten。 *)
dsMetaSeedInputGroups[seeds_] := Module[{top},
   top = If[ListQ[seeds], seeds, {seeds}];
   If[AnyTrue[top, ListQ], dsSeedTemplateEntries /@ top, {dsSeedTemplateEntries[top]}]
   ];


dsMetaSeedGroupRecord[templateRecords_List] := Module[
   {indices, shiftData, shiftBounds, seedRangeOffsets, first, descriptors},
   first = First[templateRecords];
   descriptors = DeleteDuplicates[Lookup[templateRecords, "sourceDescriptor", {}]];
   indices = DeleteDuplicates[Flatten[Lookup[templateRecords, "continuousIndices", {}]]];
   shiftData = Association@Table[
      index -> DeleteDuplicates@Flatten[
        Table[Lookup[Lookup[record, "shiftData", <||>], index, {}], {record, templateRecords}]
        ],
      {index, indices}
      ];
   shiftBounds = Association@KeyValueMap[
      #1 -> If[#2 === {}, Missing["NoAffineShift"], {Min[#2], Max[#2]}] &,
      shiftData
      ];
   seedRangeOffsets = Association@KeyValueMap[
      #1 -> If[ListQ[#2], {-First[#2], -Last[#2]}, Missing["NoAffineShift"]] &,
      shiftBounds
      ];
   <|
    "groupOrdinal" -> first["groupOrdinal"],
    "groupKey" -> With[{ordinal = first["groupOrdinal"]}, HoldComplete["inputGroup", ordinal]],
    "sourceDescriptors" -> descriptors,
    "sectorKeys" -> DeleteDuplicates[Lookup[templateRecords, "sectorKey", {}]],
    "ibpClasses" -> DeleteDuplicates[Lookup[templateRecords, "ibpClass", {}]],
    "generators" -> DeleteDuplicates[Lookup[templateRecords, "generator", {}]],
    "templateCount" -> Length[templateRecords],
    "templateOrdinals" -> Lookup[templateRecords, "templateOrdinal", {}],
    "continuousIndices" -> indices,
    "shiftData" -> Normal[shiftData],
    "shiftBounds" -> Normal[shiftBounds],
    "seedRangeOffsets" -> Normal[seedRangeOffsets]
    |>
   ];


DSMetaSeedRange::badseeds = "seeds 必须是 DSSeeds 生成的模板列表或含 J 的表达式列表。 seeds must be a template list generated by DSSeeds or a list of expressions containing J.";
DSMetaSeedRange::badindices = "指标声明必须是一个变量列表：`1`。 The index declaration must be a list of variables: `1`.";


(* 用户声明只用于审计预期集合；metadata 始终按 seed 中实际发现的完整变量集建立。
   再次成功调用会整体覆盖旧状态，避免不同 family 的 shift 数据混用。 *)
DSMetaSeedRange[seeds_, declaredIndices_List] := Module[
   {inputGroups, groupingMode, entries, groupOrdinals, badEntries, declared,
    entryVariables, discovered, missing, extra, records, groups, state},
   inputGroups = dsMetaSeedInputGroups[seeds];
   groupingMode = If[Length[inputGroups] === 1 && ! AnyTrue[If[ListQ[seeds], seeds, {seeds}], ListQ],
     "flatOverall", "topLevelGroups"];
   entries = Flatten[inputGroups, 1];
   groupOrdinals = Flatten@MapIndexed[ConstantArray[First[#2], Length[#1]] &, inputGroups];
   badEntries = Select[
     entries,
     Function[entry,
      With[{equation = dsSeedTemplateEquation[entry]},
       Head[equation] === Missing || (! TrueQ[equation === 0] && FreeQ[equation, _J])
       ]
      ]
     ];
dsContinuousIndicesFromIntegral[J[_String, timeShifts_List, _List]] := DeleteDuplicates[
    Quiet@Check[Variables[Flatten[{timeShifts}]], Cases[timeShifts, _a, Infinity]]
    ];
   If[entries === {} || badEntries =!= {},
    Message[DSMetaSeedRange::badseeds];
    dsErrorPrint["无法初始化 seed shift metadata。 Failed to initialize seed-shift metadata."];
    Return[<|"status" -> "failed", "reason" -> "invalidSeeds", "invalidEntries" -> badEntries|>]
    ];
   declared = DeleteDuplicates[Flatten[{declaredIndices}]];
   If[! VectorQ[declared, Not@*NumericQ],
    Message[DSMetaSeedRange::badindices, declaredIndices];
    dsErrorPrint["指标声明包含数值或不是一维变量列表。 The index declaration contains numbers or is not a flat variable list."];
    Return[<|"status" -> "failed", "reason" -> "invalidIndexDeclaration"|>]
    ];
   entryVariables = dsEntrySeedVariables /@ entries;
   discovered = DeleteDuplicates[Flatten[entryVariables]];
   missing = Complement[discovered, declared];
   extra = Complement[declared, discovered];
   If[missing =!= {},
    dsWarningPrint[
     "声明遗漏了实际 seed 指标；初始化将自动补入：" <> ToString[missing, InputForm] <>
      ". The declaration omitted actual seed indices; initialization will add them: " <>
      ToString[missing, InputForm]
     ]
    ];
   If[extra =!= {},
    dsWarningPrint[
     "声明含有 seed 中不存在的指标；它们不会参与撒点：" <> ToString[extra, InputForm] <>
      ". The declaration contains indices absent from the seeds; they will not be sampled: " <>
      ToString[extra, InputForm]
     ]
    ];
   records = MapThread[
     Function[{entry, variables, groupOrdinal, templatePosition}, <|
       "groupOrdinal" -> groupOrdinal,
       "groupKey" -> With[{ordinal = groupOrdinal}, HoldComplete["inputGroup", ordinal]],
       "sourceDescriptor" -> dsSeedSourceDescriptor[entry],
        "sectorKey" -> If[AssociationQ[entry], Lookup[entry, "sectorKey", Missing["sectorKey"]], Missing["sectorKey"]],
       "ibpClass" -> If[AssociationQ[entry], Lookup[entry, "ibpClass", "unknownIBP"], "unknownIBP"],
       "generator" -> If[AssociationQ[entry], Lookup[entry, "generator", Missing["generator"]], Missing["generator"]],
       "templateOrdinal" -> If[AssociationQ[entry], Lookup[entry, "templateOrdinal", Missing["templateOrdinal"]], Missing["templateOrdinal"]],
       "templatePosition" -> templatePosition,
       "continuousIndices" -> variables,
       "shiftData" -> Association@Table[index -> dsSeedIndexShifts[entry, index], {index, variables}]
       |>],
     {entries, entryVariables, groupOrdinals, Range[Length[entries]]}
     ];
   groups = dsMetaSeedGroupRecord /@ GatherBy[records, Lookup[#, "groupOrdinal"] &];
   state = <|
     "status" -> "initialized",
     "seedHash" -> dsSeedMetadataHash[entries],
     "templateCount" -> Length[entries],
     "inputGroupingMode" -> groupingMode,
     "groupingRule" -> "flat list -> one group; nested list -> flatten each top-level item as one group",
     "declaredIndices" -> declared,
     "discoveredIndices" -> discovered,
     "missingIndices" -> missing,
     "extraIndices" -> extra,
     "declarationExactQ" -> (missing === {} && extra === {}),
     "records" -> records,
     "groups" -> groups
     |>;
   $dsMetaSeedRangeState = state;
   dsInfoPrint[
    "分组规则：flat seeds 整体统计；nested seeds 按最外层逐组 Flatten 后统计。本次共 " <>
     ToString[Length[groups]] <> " 组。 Grouping rule: flat seeds are analyzed as one group; " <>
     "nested seeds are flattened and analyzed per top-level item. This call created " <>
     ToString[Length[groups]] <> " groups."
    ];
   dsInfoPrint[
    "已初始化 " <>
     ToString[Length[records]] <> " 条 seed shift metadata；后续初始化会覆盖本状态。 " <>
     "Initialized seed-shift metadata for " <> ToString[Length[records]] <>
     " templates; a later initialization will replace this state."
    ];
   state
   ];


DSMetaSeedRange[seeds_, declared_] := (
   Message[DSMetaSeedRange::badindices, declared];
   dsErrorPrint["第二个参数必须是指标列表。 The second argument must be an index list."];
   <|"status" -> "failed", "reason" -> "invalidIndexDeclaration"|>
   );


DSMetaSeedRange[] := $dsMetaSeedRangeState;


dsSeedTemplateIntegrityAudit[entries_List, auditLevel_String] := Module[
   {records, hashes, counts, ordinals, expectedHash, payload, actualHash,
     declaredCount, ordinalQ, recordHashQ, completeSetQ, passQ},
   records = Select[entries, AssociationQ];
   If[Length[records] =!= Length[entries],
    Return[<|"status" -> "unsealed", "passQ" -> False, "reason" -> "rawExpressions"|>]
    ];
   hashes = DeleteDuplicates[Lookup[records, "templateSetHash", Missing["MissingHash"]]];
   counts = DeleteDuplicates[Lookup[records, "templateCount", Missing["MissingCount"]]];
   ordinals = Lookup[records, "templateOrdinal", Missing["MissingOrdinal"]];
   If[Length[hashes] =!= 1 || Length[counts] =!= 1 || ! IntegerQ[First[counts]],
    Return[<|"status" -> "failed", "passQ" -> False, "reason" -> "metadataMismatch",
      "hashes" -> hashes, "counts" -> counts, "ordinals" -> ordinals|>]
   ];
   declaredCount = First[counts];
   ordinalQ = DuplicateFreeQ[ordinals] && And @@ (IntegerQ[#] && 1 <= # <= declaredCount & /@ ordinals);
   recordHashQ = If[
     auditLevel === "full",
     And @@ Map[
       Function[record,
        Lookup[record, "templateHash", Missing["MissingTemplateHash"]] ===
         dsSeedTemplateRecordHash[record]
        ],
       records
       ],
     Missing["ProducerMetadataTrustedAtStandardAuditLevel"]
     ];
   If[! TrueQ[ordinalQ] || TrueQ[recordHashQ === False],
     Return[<|"status" -> "failed", "passQ" -> False, "reason" -> "recordIntegrityMismatch",
       "declaredTemplateCount" -> declaredCount, "ordinals" -> ordinals,
       "ordinalQ" -> ordinalQ, "recordHashQ" -> recordHashQ|>]
     ];
   expectedHash = First[hashes];
   completeSetQ = Length[records] === declaredCount && ordinals === Range[declaredCount];
   actualHash = If[
     auditLevel === "full" && completeSetQ,
     payload = dsSeedTemplateHashPayload[records];
     IntegerString[Hash[payload, "SHA256"], 16, 64],
     Missing["NotRecomputedAtStandardAuditLevel"]
     ];
   passQ = TrueQ[ordinalQ && (auditLevel =!= "full" ||
        (recordHashQ && (! completeSetQ || expectedHash === actualHash)))];
   <|"status" -> Which[
      ! passQ, "failed",
      completeSetQ, "sealedComplete",
      True, "sealedSubset"
      ],
      "passQ" -> passQ, "sealedQ" -> passQ, "completeSetQ" -> completeSetQ,
      "auditLevel" -> auditLevel,
      "expectedHash" -> expectedHash, "actualHash" -> actualHash,
     "declaredTemplateCount" -> declaredCount, "templateCount" -> Length[records],
     "templateOrdinals" -> ordinals|>
   ];


dsRangePairQ[spec_] := MatchQ[spec, {_Integer, _Integer}] && spec[[1]] <= spec[[2]];


dsRangeSpecificationAudit[indices_List, specs_List] := Module[
   {uniformQ, detailedQ, normalizedSpecs, groupedSpecs, conflictingAliases,
    variables, duplicate, unknown, missing, discrete, invalid},
   uniformQ = Length[specs] === 1 && dsRangePairQ[First[specs]];
   detailedQ = specs =!= {} && And @@ (MatchQ[#, {_, _Integer, _Integer}] & /@ specs);
   If[uniformQ,
    Return[<|"status" -> "passed", "mode" -> "uniform", "variables" -> indices,
      "rangeRules" -> Thread[indices -> ConstantArray[First[specs], Length[indices]]],
      "unknownIndices" -> {}, "missingIndices" -> {}, "duplicateIndices" -> {},
      "discreteIndicesInRangeSpec" -> {}, "invalidRanges" -> {}|>]
    ];
   If[! detailedQ,
    Return[<|"status" -> "failed", "reason" -> "invalidRangeShape", "invalidRanges" -> specs|>]
    ];
   normalizedSpecs = ({dsRootEnvelopeIndex[First[#]], #[[2]], #[[3]]} &) /@ specs;
   groupedSpecs = GatherBy[normalizedSpecs, First];
   conflictingAliases = Select[
     groupedSpecs,
     Length[DeleteDuplicates[#[[All, 2 ;; 3]]]] > 1 &
     ];
   normalizedSpecs = First /@ groupedSpecs;
   variables = First /@ normalizedSpecs;
   duplicate = Cases[Tally[variables], {var_, count_} /; count > 1 :> var];
   discrete = Select[variables, MatchQ[#, _n] &];
   unknown = Select[variables, Function[var, ! AnyTrue[indices, SameQ[#, var] &] && ! MatchQ[var, _n]]];
   missing = Select[indices, Function[var, ! AnyTrue[variables, SameQ[#, var] &]]];
   invalid = Join[Select[normalizedSpecs, #[[2]] > #[[3]] &], conflictingAliases];
   <|
    "status" -> If[Join[duplicate, discrete, unknown, missing, invalid] === {}, "passed", "failed"],
    "mode" -> "detailed",
    "variables" -> indices,
    "rangeRules" -> If[Join[duplicate, discrete, unknown, missing, invalid] === {},
      (#[[1]] -> #[[2 ;; 3]]) & /@ normalizedSpecs, {}],
    "unknownIndices" -> unknown,
    "missingIndices" -> missing,
    "duplicateIndices" -> duplicate,
    "discreteIndicesInRangeSpec" -> discrete,
    "invalidRanges" -> invalid
    |>
   ];


(* shrink sector 的 bS[e] 继承 root top 的 b[e] 目标包络。用户只需描述 root
   指标域；sector-specific seed 区间由模板中的实际 shift 自动反推。 *)
dsRootEnvelopeIndex[index_] := index /. HoldPattern[bS[e_]] :> b[e];


dsRootEnvelopeIndices[indices_List] := DeleteDuplicates[dsRootEnvelopeIndex /@ indices];


dsSeedIndexShifts[entry_, index_] := Module[{equation, values, shifts},
   equation = dsSeedTemplateEquation[entry];
   If[TrueQ[equation === 0], Return[{0}]];
   values = Flatten[dsFlattenSeedIntegralData[equation]];
   shifts = DeleteDuplicates@Cases[
      values,
      value_ /; IntegerQ[Expand[value - index]] :> Expand[value - index]
      ];
   shifts
   ];


(* 要求组内所有 shifted indices 都落在 [L,U]，故 seed 点域取各 shift 逆像的
   交集 [L-Min[Delta],U-Max[Delta]]；作用后所得关系的外包络刚好回到 [L,U]。 *)
dsDerivedSeedRangeAudit[group_Association, targetRanges_Association] := Module[
   {indices, missingTargets, shiftBounds, missingShifts, rawSeedRules, seedRules},
   indices = Lookup[group, "continuousIndices", {}];
   missingTargets = Select[
     indices,
     ! KeyExistsQ[targetRanges, dsRootEnvelopeIndex[#]] &
     ];
   shiftBounds = Association[Lookup[group, "shiftBounds", {}]];
   missingShifts = Select[indices, ! ListQ[Lookup[shiftBounds, #, Missing["NoAffineShift"]]] &];
   If[Join[missingTargets, missingShifts] =!= {},
    Return[<|
      "status" -> "failed",
      "reason" -> "seedEnvelopeInferenceFailed",
      "groupOrdinal" -> Lookup[group, "groupOrdinal", Missing["groupOrdinal"]],
      "groupKey" -> Lookup[group, "groupKey", Missing["groupKey"]],
      "sourceDescriptors" -> Lookup[group, "sourceDescriptors", {}],
      "missingTargetIndices" -> missingTargets,
      "indicesWithoutAffineShifts" -> missingShifts
      |>]
    ];
   rawSeedRules = Table[
     With[
      {target = targetRanges[dsRootEnvelopeIndex[index]], bounds = shiftBounds[index]},
      index -> {First[target] - First[bounds], Last[target] - Last[bounds]}
      ],
     {index, indices}
     ];
   (* 自动反推不得把 ISP seed 下界降到用户 target 下界以下；用户显式给出的负下界
      保持有效，package 只避免为了覆盖升幂项而自行再向更负方向扩张。 *)
   seedRules = rawSeedRules /. HoldPattern[(index_ -> range_List)] /; MatchQ[index, _ispN] :>
      index -> {Max[First[targetRanges[index]], First[range]], Last[range]};
   <|
    "status" -> "passed",
    "groupOrdinal" -> Lookup[group, "groupOrdinal", Missing["groupOrdinal"]],
    "groupKey" -> Lookup[group, "groupKey", Missing["groupKey"]],
    "sourceDescriptors" -> Lookup[group, "sourceDescriptors", {}],
    "ibpClasses" -> Lookup[group, "ibpClasses", {}],
    "templateCount" -> Lookup[group, "templateCount", 0],
    "continuousIndices" -> indices,
    "shiftBounds" -> Normal[shiftBounds],
    "seedRangeOffsets" -> Lookup[group, "seedRangeOffsets", {}],
    "unclippedSeedRangeRules" -> rawSeedRules,
    "seedRangeRules" -> seedRules,
    "emptySeedDomainQ" -> AnyTrue[Last /@ seedRules, First[#] > Last[#] &]
    |>
   ];


dsSeedRangeRuleText[rules_List] := StringRiffle[
   ToString[{First[#], Sequence @@ Last[#]}, InputForm] & /@ rules,
   ", "
   ];


dsSeedRangeSourceText[audit_Association] := ToString[
   Lookup[audit, "sourceDescriptors", {}],
   InputForm
   ];


dsReportDerivedSeedRanges[rangeAudits_List, setting_: Automatic] := Module[
   {ordinal, rules, source, empty},
   Do[
    ordinal = Lookup[audit, "groupOrdinal", Missing["groupOrdinal"]];
    rules = Lookup[audit, "seedRangeRules", {}];
    source = dsSeedRangeSourceText[audit];
    dsInfoPrint[
     "编号 " <> ToString[ordinal] <> "（来源 " <> source <> "）：" <>
      dsSeedRangeRuleText[rules] <> ". Group " <> ToString[ordinal] <>
      " (source " <> source <> "): " <> dsSeedRangeRuleText[rules] <> ".",
     setting
     ],
    {audit, rangeAudits}
    ];
   empty = Select[rangeAudits, TrueQ[Lookup[#, "emptySeedDomainQ", False]] &];
   If[empty =!= {},
    dsWarningPrint[
     "以下分组的目标包络窄于该组 shift 跨度，因此不存在能使所有移位后积分仍落在目标包络内的 seed 点：" <>
      StringRiffle[
       ("编号 " <> ToString[Lookup[#, "groupOrdinal", Missing["groupOrdinal"]]] <>
          "（来源 " <> dsSeedRangeSourceText[#] <> "）：" <>
          dsSeedRangeRuleText[Lookup[#, "seedRangeRules", {}]]) & /@ empty,
       "; "
       ] <> "。这些编号的 IBP 撒点结果为空；最终方程集合缺少对应关系，不能作为完整约化系统。 " <>
       "For the following groups, the target envelope is narrower than the group shift span, so no seed point can keep every shifted integral inside the target envelope: " <>
       StringRiffle[
       ("group " <> ToString[Lookup[#, "groupOrdinal", Missing["groupOrdinal"]]] <>
          " (source " <> dsSeedRangeSourceText[#] <> "): " <>
          dsSeedRangeRuleText[Lookup[#, "seedRangeRules", {}]]) & /@ empty,
       "; "
       ] <> ". IBP sampling is empty for these groups; the final equation set lacks their relations and cannot be used as a complete reduction system.",
     setting
     ]
    ];
   empty
   ];


(* ::Chapter:: *)
(*公开连续撒点入口*)

dsGeneratedIBPSectorSummaries[records_List, ibpMode_String, rootLineCount_Integer?NonNegative] := Module[{sectorKeys},
   sectorKeys = Select[
     DeleteDuplicates[Lookup[records, "sectorKey", {}]],
     StringQ[#] && ! sectorKeyTopQ[#, ibpMode, rootLineCount] &
     ];
   Table[
    With[{sectorRecords = Select[records, Lookup[#, "sectorKey", None] === sectorKey &]},
     <|
      "sectorKey" -> sectorKey,
      "sectorShrunkLines" -> Lookup[First[sectorRecords], "sectorShrunkLines", {}],
      "momentumSummary" -> <|"generators" -> DeleteDuplicates[Lookup[Select[sectorRecords, Lookup[#, "ibpClass", None] === "qIBP" &], "generator", {}]]|>,
      "timeSummary" -> <|"generators" -> DeleteDuplicates[Lookup[Select[sectorRecords, Lookup[#, "ibpClass", None] === "tIBP" &], "generator", {}]]|>
      |>
     ],
    {sectorKey, sectorKeys}
    ]
   ];


dsGeneratedIBPSourceDigest[records_List, context_Association, rangeAudit_Association] := Module[{payload},
   payload = {
     Lookup[context, "inputHash", Missing["inputHash"]],
     Lookup[rangeAudit, "rangeRules", {}],
     KeyTake[#, {"sectorKey", "ibpClass", "generator", "continuousRules", "equation"}] & /@ records
     };
   IntegerString[Hash[payload, "SHA256"], 16, 64]
   ];


dsGeneratedIBPArtifactContract[
   records_List,
   context_Association,
   rangeAudit_Association,
   integrityAudit_Association,
   completeCanonicalQ_,
   auditLevel_String
   ] := Module[{sealedQ, completeSystemQ},
   sealedQ = TrueQ[Lookup[integrityAudit, "sealedQ", False]];
   completeSystemQ = TrueQ[
     sealedQ && Lookup[integrityAudit, "completeSetQ", False] && completeCanonicalQ
     ];
   <|
    "contractVersion" -> 1,
    "sealedQ" -> sealedQ,
    "sourceDigest" -> dsGeneratedIBPSourceDigest[records, context, rangeAudit],
    "completeSystemQ" -> completeSystemQ,
    "subsetQ" -> TrueQ[sealedQ && ! Lookup[integrityAudit, "completeSetQ", False]],
    "auditLevel" -> auditLevel,
    "capabilities" -> <|
      "linearizeQ" -> True,
      "formalReductionQ" -> completeSystemQ,
      "reuseProducerCanonicalQ" -> sealedQ
      |>
    |>
   ];


dsGeneratedIBPBatch[records_List, templates_List, context_Association, rangeAudit_Association,
   integrityAudit_Association, derivedRangeAudits_List, metaState_Association] := Module[
    {topRecords, metadataList, forbidden, eomQ, representation, ibpMode, templateHash,
     templateRecords, firstTemplate, emptyRangeAudits, emptyMomentumQ, emptyTimeQ,
     rootLineCount, invalidSectorKeys},
    templateRecords = Select[templates, AssociationQ];
   firstTemplate = If[templateRecords === {}, Missing["RawExpressionTemplates"], First[templateRecords]];
   (* subset 仍需继承完整 sector schema；模板子集只改变关系覆盖，不改变 topology 身份。 *)
   metadataList = context["sectors"];
   forbidden = DeleteCases[Flatten[Lookup[records, "forbiddenNData", {}]], Null];
   eomQ = And @@ Lookup[records, "eomCanonicalQ", {False}];
   representation = If[Head[firstTemplate] === Missing,
     "J[timePowers,indexedLinePacks,isp]",
     Lookup[firstTemplate, "representation", "J[timePowers,indexedLinePacks,isp]"]
     ];
    ibpMode = If[Head[firstTemplate] === Missing,
      Lookup[context["topology"], "ibpMode", "full"],
      Lookup[firstTemplate, "ibpMode", Lookup[context["topology"], "ibpMode", "full"]]
      ];
    rootLineCount = Length[Lookup[context["topology"], "lines", {}]];
    invalidSectorKeys = Select[
      DeleteDuplicates[Lookup[records, "sectorKey", Missing["sectorKey"]]],
      ! sectorKeyForModeQ[#, ibpMode, rootLineCount] &
      ];
    If[invalidSectorKeys =!= {},
     Return[<|
       "status" -> "failed",
       "reason" -> "invalidSectorKeyForMode",
       "ibpMode" -> ibpMode,
       "rootLineCount" -> rootLineCount,
       "invalidSectorKeys" -> invalidSectorKeys,
       "equations" -> records
       |>]
     ];
    topRecords = Select[
      records,
      sectorKeyTopQ[Lookup[#, "sectorKey", Missing["sectorKey"]], ibpMode, rootLineCount] &
      ];
   templateHash = If[Head[firstTemplate] === Missing,
     Missing["UnsealedTemplates"],
     Lookup[firstTemplate, "templateSetHash", Missing["UnsealedTemplates"]]
     ];
   emptyRangeAudits = Select[derivedRangeAudits, TrueQ[Lookup[#, "emptySeedDomainQ", False]] &];
   emptyMomentumQ = AnyTrue[emptyRangeAudits, MemberQ[Lookup[#, "ibpClasses", {}], "qIBP"] &];
   emptyTimeQ = AnyTrue[emptyRangeAudits, MemberQ[Lookup[#, "ibpClasses", {}], "tIBP"] &];
   <|
    "status" -> "generated",
    "dSIBPStatus" -> "generated",
    "generationRoute" -> "DSGenerateIBP",
    "caseName" -> context["caseName"],
    "ibpMode" -> ibpMode,
    "representation" -> representation,
    "topologyValidationReport" -> context["validationReport"],
    "sectorMetadata" -> First[metadataList],
    "sectorMetadataList" -> metadataList,
    "momentumSummary" -> <|"generators" -> DeleteDuplicates[Lookup[Select[topRecords, Lookup[#, "ibpClass", None] === "qIBP" &], "generator", {}]]|>,
    "timeSummary" -> <|"generators" -> DeleteDuplicates[Lookup[Select[topRecords, Lookup[#, "ibpClass", None] === "tIBP" &], "generator", {}]]|>,
     "shrinkSectorSummary" -> <|
       "sectorSummaries" -> dsGeneratedIBPSectorSummaries[records, ibpMode, rootLineCount]
       |>,
    "equationCount" -> Length[records],
    "eomCanonicalQ" -> eomQ,
    "forbiddenNData" -> forbidden,
    "pendingFeatures" -> {},
    "completeMomentumIBPQ" -> TrueQ[ibpMode === "full" && ! emptyMomentumQ],
    "completeTimeIBPQ" -> ! emptyTimeQ,
    "completeCanonicalQ" -> TrueQ[eomQ && forbidden === {} && emptyRangeAudits === {}],
    "allSeeds" -> templates,
    "templateSetHash" -> templateHash,
    "templateIntegrityAudit" -> integrityAudit,
    "continuousIndices" -> rangeAudit["variables"],
    "rangeMode" -> "targetEnvelope",
    "targetEnvelopeMode" -> rangeAudit["mode"],
    "targetEnvelopeRules" -> rangeAudit["rangeRules"],
    "derivedSeedRangeAudits" -> derivedRangeAudits,
    "emptySeedRangeGroups" -> emptyRangeAudits,
    "seedRangeMetadata" -> KeyDrop[metaState, "records"],
    "candidatePointCount" -> Total[Function[item,
        Lookup[item, "templateCount", 0] *
         Times @@ (Max[0, Last[#] - First[#] + 1] & /@ (Last /@ Lookup[item, "seedRangeRules", {}]))
        ] /@ derivedRangeAudits],
    "parityAcceptedPointCount" -> Length[records],
     "equations" -> records,
     "dSIBPContextSummary" -> dsContextSummary[context]
    |>
   ];


DSGenerateIBP[seeds_, specs__List, OptionsPattern[]] := Module[
   {entries, workingEntries, publicRecords, badEntries, indices, symbolicN, audit, integrity, context, hashes,
    envelopeIndices, specList, targetRangeAssociation, metaState, metaHash,
    derivedRangeAudits, derivedRangeByGroup, entryGroupOrdinals, failedRangeAudits,
    progress, records, sectorTopologyCache, postSamplingCanonicalRequiredQ,
    pointRulesByGroup, parityPointRulesCache,
    parityCertificate, batch, artifactContract, auditLevel = OptionValue[AuditLevel]},
   If[! MemberQ[{"standard", "full"}, auditLevel],
    Return[<|"status" -> "failed", "reason" -> "invalidAuditLevel",
      "auditLevel" -> auditLevel, "allowedAuditLevels" -> {"standard", "full"}|>]
    ];
   entries = dsSeedTemplateEntries[seeds];
   (* EOM/canonical 可以把某个完整离散态模板化为精确零；密封模板中的 0 仍是合法恒等式。
      非零且不含 J 的表达式继续拒绝，避免把任意常数列表误当作 IBP 模板。 *)
   badEntries = Select[
     entries,
     Function[entry,
      With[{equation = dsSeedTemplateEquation[entry]},
       Head[equation] === Missing || (! TrueQ[equation === 0] && FreeQ[equation, _J])
       ]
      ]
     ];
   If[entries === {} || badEntries =!= {},
    Message[DSGenerateIBP::badseeds];
    dsErrorPrint["seeds 不是可展开的 IBP 模板列表。 seeds is not an expandable IBP-template list."];
    Return[<|"status" -> "failed", "reason" -> "invalidSeeds", "invalidEntries" -> badEntries|>]
    ];
   symbolicN = dsSeedTemplateSymbolicN[entries];
   If[symbolicN =!= {},
    Message[DSGenerateIBP::symbolicn, symbolicN];
    dsErrorPrint["模板必须先完整遍历 n_i=0,1 并执行 EOM。 Templates must enumerate n_i=0,1 and apply EOM first."];
    Return[<|"status" -> "failed", "reason" -> "symbolicDiscreteIndices", "symbolicDiscreteIndices" -> symbolicN|>]
    ];
   metaHash = dsSeedMetadataHash[entries];
   metaState = If[
     AssociationQ[$dsMetaSeedRangeState] &&
      Lookup[$dsMetaSeedRangeState, "status", "failed"] === "initialized" &&
      Lookup[$dsMetaSeedRangeState, "seedHash", None] === metaHash,
     $dsMetaSeedRangeState,
     DSMetaSeedRange[entries, DeleteDuplicates[Flatten[dsEntrySeedVariables /@ entries]]]
     ];
   If[Lookup[metaState, "status", "failed"] =!= "initialized",
    Return[<|"status" -> "failed", "reason" -> "seedMetadataInitializationFailed",
      "seedMetadata" -> metaState|>]
    ];
   indices = Lookup[metaState, "discoveredIndices", {}];
   envelopeIndices = dsRootEnvelopeIndices[indices];
   specList = {specs};
   audit = dsRangeSpecificationAudit[envelopeIndices, specList];
   If[Lookup[audit, "discreteIndicesInRangeSpec", {}] =!= {},
    Message[DSGenerateIBP::discrete, audit["discreteIndicesInRangeSpec"]];
    dsErrorPrint["n_i 不属于连续撒点范围。 n_i are not continuous sampling indices."];
    Return[Join[audit, <|"status" -> "failed", "reason" -> "discreteIndexInRangeSpec"|>]]
    ];
   If[Lookup[audit, "status", "failed"] =!= "passed",
    If[Lookup[audit, "reason", None] === "invalidRangeShape",
     Message[DSGenerateIBP::badrange, Lookup[audit, "invalidRanges", {specs}]],
     Message[DSGenerateIBP::coverage, KeyTake[audit, {"unknownIndices", "missingIndices", "duplicateIndices", "invalidRanges"}]]
     ];
    dsErrorPrint["请修正范围格式并完整覆盖所有连续指标。 Correct the ranges and cover every continuous index exactly once."];
    Return[Join[audit, <|"status" -> "failed", "reason" -> Lookup[audit, "reason", "rangeCoverageFailed"]|>]]
    ];
   integrity = dsSeedTemplateIntegrityAudit[entries, auditLevel];
   If[AssociationQ[First[entries]] && ! TrueQ[Lookup[integrity, "passQ", False]],
    Message[DSGenerateIBP::integrity, integrity];
    dsErrorPrint["模板集合被删改或不完整。 The template set was modified or is incomplete."];
    Return[<|"status" -> "failed", "reason" -> "templateIntegrityFailed", "templateIntegrityAudit" -> integrity|>]
    ];
    context = dsResolveContext[Automatic];
   hashes = DeleteDuplicates[Lookup[Select[entries, AssociationQ], "contextInputHash", {}]];
    If[Head[context] === Missing || (hashes =!= {} && hashes =!= {context["inputHash"]}),
    dsErrorPrint["当前 DSInit context 与模板不同源。 The current DSInit context does not match the templates."];
     Return[<|"status" -> "failed", "reason" -> "contextMismatch", "templateContextHashes" -> hashes|>]
     ];
    workingEntries = If[
      Lookup[context["topology"], "ibpMode", "full"] === "timeOnly",
      dsTimeOnlyDataToInternal020[entries, context],
      entries
      ];
    If[workingEntries === $Failed,
     Return[<|"status" -> "failed", "reason" -> "timeOnlyPublicInputRequired"|>]
     ];
   sectorTopologyCache = sectorTopologyCache018[context["topology"], context["sectors"]];
   If[Head[sectorTopologyCache] === Missing,
    dsErrorPrint["sector topology 缓存初始化失败。 Failed to initialize the sector-topology cache."];
    Return[<|"status" -> "failed", "reason" -> "sectorTopologyCacheFailed",
      "cacheFailure" -> sectorTopologyCache|>]
    ];
   postSamplingCanonicalRequiredQ =
    sectorCachePostSamplingCanonicalRequiredQ018[sectorTopologyCache];
   targetRangeAssociation = Association[audit["rangeRules"]];
   derivedRangeAudits = dsDerivedSeedRangeAudit[#, targetRangeAssociation] & /@
     Lookup[metaState, "groups", {}];
   failedRangeAudits = Select[derivedRangeAudits, Lookup[#, "status", "failed"] =!= "passed" &];
   If[failedRangeAudits =!= {},
    dsErrorPrint["无法从目标积分包络反推全部 seed 点域。 Failed to infer every seed domain from the target integral envelope."];
    Return[<|"status" -> "failed", "reason" -> "seedEnvelopeInferenceFailed",
      "failures" -> failedRangeAudits|>]
    ];
   dsReportDerivedSeedRanges[derivedRangeAudits, OptionValue[ProgressReporting]];
   derivedRangeByGroup = AssociationThread[
     Lookup[derivedRangeAudits, "groupOrdinal", {}],
     derivedRangeAudits
     ];
   (* 同一 group 的连续点域由相同的反推范围决定。这里一次性构造后复用，避免每个
      离散态 template 重复建立相同 Tuples；空区间仍自然得到空点域。 *)
   pointRulesByGroup = Association@Map[
      Function[rangeData,
       With[
        {ordinal = Lookup[rangeData, "groupOrdinal", Missing["groupOrdinal"]],
         groupIndices = Lookup[rangeData, "continuousIndices", {}],
         valueLists = (Range @@ Last[#]) & /@ Lookup[rangeData, "seedRangeRules", {}]},
        ordinal -> If[groupIndices === {}, {{}}, Thread[groupIndices -> #] & /@ Tuples[valueLists]]
        ]
       ],
      derivedRangeAudits
      ];
   (* parity 预筛只依赖 group 点域、sector metadata 与 source integral 的仿射 parity
      signature。同 signature 的不同生成元 template 共享筛点结果。 *)
   parityPointRulesCache = <||>;
   entryGroupOrdinals = Lookup[Lookup[metaState, "records", {}], "groupOrdinal", {}];
   progress = OptionValue[ProgressReporting];
   records = dsProgressMap[
      "正在展开连续 IBP 指标 / Expanding continuous IBP indices",
       MapThread[{#1, #2} &, {workingEntries, entryGroupOrdinals}],
       Function[item,
          Module[{entry = First[item], groupOrdinal = Last[item], entryRangeAudit,
            pointRules, parityCacheKey, parityMetadata, paritySource, paritySignature,
            entryPointRules, templateEquation, canonicalTemplateEquation,
             templateForbiddenNData, templateEOMCanonicalQ, expression, updated},
        entryRangeAudit = Lookup[
          derivedRangeByGroup,
          groupOrdinal,
          <|"status" -> "failed", "reason" -> "missingGeneratorGroup"|>
          ];
         pointRules = Lookup[pointRulesByGroup, groupOrdinal, {}];
         parityMetadata = If[AssociationQ[entry], Lookup[entry, "sectorMetadata", Missing["NoSectorMetadata"]], Missing["NoSectorMetadata"]];
         paritySource = If[AssociationQ[entry], Lookup[entry, "sourceIntegral", Missing["NoSourceIntegral"]], Missing["NoSourceIntegral"]];
         paritySignature = If[
           AssociationQ[parityMetadata] && Head[paritySource] === J,
           parityIntegralSignature018[parityMetadata, paritySource],
           Missing["NoParitySignature"]
           ];
         parityCacheKey = HoldComplete[
           groupOrdinal,
           If[AssociationQ[parityMetadata], Lookup[parityMetadata, "sectorKey", Missing["sectorKey"]], Missing["sectorKey"]],
           paritySignature
           ];
         entryPointRules = If[
           KeyExistsQ[parityPointRulesCache, parityCacheKey],
           parityPointRulesCache[parityCacheKey],
           With[{filtered = dsParityFilteredPointRules018[entry, pointRules, context]},
            AssociateTo[parityPointRulesCache, parityCacheKey -> filtered];
            filtered
            ]
           ];
        templateEquation = dsLoopSeedExpressionToPublicCoordinates[
          dsSeedTemplateEquation[entry],
          context["topology"]
          ];
        canonicalTemplateEquation = sectorAwareCanonical018[
          templateEquation,
          context["topology"],
          sectorTopologyCache
          ];
        canonicalTemplateEquation = If[
          canonicalTemplateEquation === $Failed ||
           ! dsInternalCoordinatePresentQ018[canonicalTemplateEquation],
          canonicalTemplateEquation,
          dsLoopSeedExpressionToPublicCoordinates[
           canonicalTemplateEquation,
           context["topology"]
           ]
          ];
        templateForbiddenNData = forbiddenNData[
          context["topology"],
          canonicalTemplateEquation
          ];
         templateEOMCanonicalQ = FreeQ[canonicalTemplateEquation, _n];
          Table[
          expression = canonicalTemplateEquation /. rules;
         If[postSamplingCanonicalRequiredQ,
          (* general template 已完成 EOM 与 target-sector endpoint canonical；具体整数点
             只需补做可能依赖连续指标值的用户/tadpole symmetry。 *)
          expression = sectorAwareSymmetry018[
            Expand[expression],
            context["topology"],
            sectorTopologyCache
            ];
           (* symmetry 可能重新引入内部 Gram 原子，因此在进入 linearData 前重投影。 *)
          expression = If[
            expression === $Failed || ! dsInternalCoordinatePresentQ018[expression],
            expression,
            dsLoopSeedExpressionToPublicCoordinates[expression, context["topology"]]
             ]
           ];
           (* parity 先筛点，连续指标随后取值，用户给出的有序 symmetry 再把每项送到唯一代表。 *)
          updated = If[AssociationQ[entry], Join[entry, <|
              "continuousRules" -> rules,
              "seedRangeGroupOrdinal" -> groupOrdinal,
              "targetEnvelopeRules" -> audit["rangeRules"],
               "derivedSeedRangeRules" -> entryRangeAudit["seedRangeRules"],
                "templateCandidatePointCount" -> Length[pointRules],
               "equation" -> expression,
              "forbiddenNData" -> If[postSamplingCanonicalRequiredQ,
                forbiddenNData[context["topology"], expression], templateForbiddenNData],
              "eomCanonicalQ" -> If[postSamplingCanonicalRequiredQ,
                FreeQ[expression, _n], templateEOMCanonicalQ]
              |>],
           <|"source" -> "userTemplate",
             "sectorKey" -> sectorKeyFromShrunkLines[context["topology"], {}],
             "generator" -> Missing["NotAvailable"],
             "ibpClass" -> "unknownIBP", "continuousRules" -> rules,
             "seedRangeGroupOrdinal" -> groupOrdinal,
             "targetEnvelopeRules" -> audit["rangeRules"],
              "derivedSeedRangeRules" -> entryRangeAudit["seedRangeRules"],
               "templateCandidatePointCount" -> Length[pointRules],
              "equation" -> expression,
             "forbiddenNData" -> If[postSamplingCanonicalRequiredQ,
               forbiddenNData[context["topology"], expression], templateForbiddenNData],
             "eomCanonicalQ" -> If[postSamplingCanonicalRequiredQ,
               FreeQ[expression, _n], templateEOMCanonicalQ]|>];
         If[AssociationQ[entry] && KeyExistsQ[entry, "treeSeed"], updated = Join[updated, <|"treeSeed" -> expression|>]];
         updated,
         {rules, entryPointRules}
         ]
        ]
       ],
      progress
      ] // Flatten[#, 1] &;
   dsInfoPrint[
    "已生成 " <> ToString[Length[records]] <> " 条 IBP 方程。 Generated " <>
     ToString[Length[records]] <> " IBP equations.", progress
    ];
   parityCertificate = If[
     auditLevel === "full" || ! TrueQ[Lookup[integrity, "sealedQ", False]],
     dsParityCertificate018[records, context],
     <|
      "status" -> "producerGuaranteed",
      "passQ" -> True,
      "auditLevel" -> auditLevel,
      "reason" -> "sealed templates were parity-prefiltered and sector-canonicalized by DSGenerateIBP"
      |>
     ];
    If[! TrueQ[Lookup[parityCertificate, "passQ", False]],
    dsErrorPrint["生成后的 parity certificate 失败；未删除任何积分或关系。 The post-generation parity certificate failed; no integral or equation was deleted."];
     Return[<|"status" -> "failed", "reason" -> "parityCertificateFailed",
       "parityCertificate" -> parityCertificate, "equations" -> records|>]
     ];
    publicRecords = If[
      Lookup[context["topology"], "ibpMode", "full"] === "timeOnly",
      dsTimeOnlyDataToPublic020[records, context],
      records
      ];
    If[publicRecords === $Failed,
     Return[<|"status" -> "failed", "reason" -> "timeOnlyPublicConversionFailed"|>]
     ];
    batch = dsGeneratedIBPBatch[publicRecords, entries, context, audit, integrity, derivedRangeAudits, metaState];
   artifactContract = dsGeneratedIBPArtifactContract[
      publicRecords,
     context,
     audit,
     integrity,
     Lookup[batch, "completeCanonicalQ", False],
     auditLevel
     ];
    Join[batch, <|
      "representation" -> If[
        Lookup[context["topology"], "ibpMode", "full"] === "timeOnly",
        "J[sectorKey,timeShifts,stateBits]",
        Lookup[batch, "representation", "J[aList,linePacks,ispList]"]
        ],
     "completeSystemQ" -> artifactContract["completeSystemQ"],
     "artifactContract" -> artifactContract,
     "parityCertificate" -> parityCertificate
     |>]
   ];


DSGenerateIBP[seeds_, ___] := (
   Message[DSGenerateIBP::badrange, "expected {min,max} or {index,min,max},..."];
   dsErrorPrint["调用格式应为 {min,max} 或完整的 {index,min,max},...。 Use {min,max} or a complete sequence of {index,min,max},...."];
   <|"status" -> "failed", "reason" -> "invalidCall"|>
   );

(* ::Package:: *)

(* ::Chapter:: *)
(*018 Kira 导出边界*)

Options[DSKiraExport] = Join[Options[makeKiraExportData], {
   KiraActiveBasis -> None,
   KiraRequireCompleteSystem -> True,
   KiraNumericStage -> "symbolic",
   ProgressReporting -> Automatic
   }];

DSKiraExport::badlinear = "DSKiraExport 需要 DSLinear 返回的 backend-neutral linearData。";
DSKiraExport::failed = "Kira 输入未生成：`1`。";
DSKiraExport::badbasis = "KiraActiveBasis 未通过验证：`1`。";
DSKiraExport::capability = "linearData 未携带通过 DSLinear 的同源能力门禁。";
DSKiraExport::devarrules = "数值/系数规则与微分阶段合同冲突，Kira 导出已拒绝：`1`。";
DSKiraExport::badstage = "KiraNumericStage 只允许 \"symbolic\" 或 \"postDerivative\"，收到 `1`。";


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

dsKiraAttachActiveBasis[linearData_Association, Automatic] /;
   Lookup[Lookup[linearData, "activeBasis", <||>], "status", "disabled"] === "configured" := linearData;

dsKiraAttachActiveBasis[linearData_Association, setting_] /; setting === None || setting === Automatic :=
   Join[linearData, <|"activeBasis" -> <|"status" -> "disabled", "count" -> 0|>|>];

dsKiraAttachActiveBasis[linearData_Association, setting_Association] := Module[
   {expressions, count, names, activeIndices, activeCount, activeExpressions, activeNames, topo, variables, allowedVariables, badVariables, degrees,
     oldCount, oldRules, idShift, shiftedRules, shiftedEquations, integralIndex,
     basisEquations, badEquations, rawDerivatives, derivativeIntegrals, missingDerivativeIntegrals,
     relationIDs, activeIDs, auxiliaryIDs, derivativeTargetIDs, targetIDs, userMIData, activeData},
   If[Lookup[linearData, "representation", None] === "sectorTaggedJ[vertexPacks]",
    Return[<|"status" -> "invalidActiveBasis", "reason" -> "treeActiveBasisNotSupported",
      "comment" -> "tree Kira IDs already include sector identity; active-basis derivatives require a separate tagged closure."|>]
    ];
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
   userMIData = Lookup[setting, "userMIData", None];
   If[AssociationQ[userMIData],
    userMIData = Join[userMIData, <|
       "backendIDs" -> relationIDs,
       "backendTokens" -> (Tuserweight /@ relationIDs),
       "activeBackendIDs" -> activeIDs,
       "activeBackendTokens" -> (Tuserweight /@ activeIDs),
       "userMIToBackendRules" -> Thread[(userMI /@ relationIDs) -> (Tuserweight /@ relationIDs)],
       "backendToUserMIRules" -> Thread[(Tuserweight /@ relationIDs) -> (userMI /@ relationIDs)]
       |>]
    ];
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
     "sourceIntegralCount" -> oldCount,
     "userMI" -> userMIData
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


(* ::Section::Closed:: *)
(*DE 变量符号保留门禁*)

(* active-basis 导数是后续 DSDE 的坐标合同。seed、linearData 或 serializer 任一层的
   替换规则若消去这些变量，外部 reduction 已不足以重建微分方程，必须在写文件前拒绝。 *)
dsKiraDEVariableRuleAudit[linearData_Association, kiraRules_, numericStage_] := Module[
   {topo, activeData, variables, audit, baseData, squaredExpressions, protectedInternal,
    rawRules, normalizedRules, lhsRules, rhsRules, touchesProtectedQ, badLHS, badRHS},
   topo = Lookup[linearData, "topology", <||>];
   activeData = Lookup[linearData, "activeBasis", <||>];
   variables = Lookup[activeData, "derivativeVariables", {}];
   If[! MemberQ[{"symbolic", "postDerivative"}, numericStage],
    Return[<|"status" -> "failed", "passQ" -> False, "reason" -> "invalidNumericStage", "numericStage" -> numericStage|>]
    ];
   If[Lookup[activeData, "status", "disabled"] =!= "configured" || variables === {},
    Return[<|
      "status" -> "notApplicable",
      "passQ" -> True,
      "deVariables" -> {},
      "reason" -> "activeBasisDerivativesNotConfigured",
      "numericStage" -> numericStage
      |>]
    ];
   audit = Lookup[topo, "kinematicCoordinateAudit", <||>];
   baseData = Lookup[audit, "baseCoordinateData", {}];
   squaredExpressions = Lookup[audit, "baseSquaredUserExpressions", {}];
   protectedInternal = DeleteDuplicates@Join[
      variables,
      scalarProductInputToInternal[#, topo] & /@ variables,
      If[Length[baseData] === Length[squaredExpressions],
       MapThread[
        Function[{data, expression},
         If[
          AnyTrue[variables, Function[variable, ! FreeQ[expression, variable]]],
          Lookup[data, "internalVariable", Nothing],
          Nothing
          ]
         ],
        {baseData, squaredExpressions}
        ],
       {}
       ]
      ];
   rawRules = Join[
     Lookup[linearData, "coefficientRulesApplied", {}],
     Replace[kiraRules, Automatic -> {}]
     ];
   rawRules = Cases[rawRules, _Rule | _RuleDelayed];
   normalizedRules = normalizeCoefficientRulesForTopology[rawRules, topo];
   lhsRules = Cases[normalizedRules, (Rule | RuleDelayed)[lhs_, _] :> lhs];
   rhsRules = Cases[normalizedRules, (Rule | RuleDelayed)[_, rhs_] :> rhs];
   touchesProtectedQ[expr_] := AnyTrue[protectedInternal, ! FreeQ[Unevaluated[expr], #] &];
   badLHS = Pick[rawRules, touchesProtectedQ /@ lhsRules];
   badRHS = Pick[rawRules, touchesProtectedQ /@ rhsRules];
   If[numericStage === "postDerivative" &&
     (Lookup[activeData, "rawDerivatives", {}] === {} || Lookup[activeData, "derivativeTargetIntegrals", Missing["closure"]] === Missing["closure"]),
    Return[<|"status" -> "failed", "passQ" -> False, "reason" -> "analyticDerivativeClosureMissing",
      "numericStage" -> numericStage, "deVariables" -> variables|>]
    ];
   <|
    "status" -> If[numericStage === "postDerivative" || (badLHS === {} && badRHS === {}), "passed", "failed"],
    "passQ" -> TrueQ[numericStage === "postDerivative" || (badLHS === {} && badRHS === {})],
    "numericStage" -> numericStage,
    "analyticDerivativeConstructedBeforeRulesQ" -> TrueQ[numericStage === "postDerivative"],
    "deVariablesNumericalizedAfterDerivativeQ" -> TrueQ[numericStage === "postDerivative" && (badLHS =!= {} || badRHS =!= {})],
    "deVariables" -> variables,
    "protectedInternalAtoms" -> protectedInternal,
    "numericRuleLHSIntersection" -> badLHS,
    "numericRuleRHSDependencies" -> badRHS,
    "rulesAudited" -> rawRules,
    "comment" -> If[numericStage === "postDerivative",
      "rules are applied only after raw active-basis derivatives and derivative target closure were constructed",
      "differential variables remain symbolic"]
    |>
   ];

dsStableTadpoleSymmetryData[data_Association] := KeyDrop[data, {"automaticRules"}];
dsStableTadpoleSymmetryData[_] := <||>;


dsKiraExpressionDigest[expr_] := IntegerString[Hash[expr, "SHA256"], 16, 64];


dsKiraRelativePath[path_String, root_String] := FileNameDrop[
   ExpandFileName[path],
   FileNameDepth[ExpandFileName[root]]
   ];


dsKiraExportFileDigests[exportData_Association] := Module[{root, files},
   root = Lookup[exportData, "outputDirectory", None];
   files = Select[Lookup[exportData, "filesWritten", {}], StringQ[#] && FileExistsQ[#] &];
   If[! StringQ[root], Return[{}]];
   Map[
    <|"path" -> dsKiraRelativePath[#, root],
      "sha256" -> IntegerString[FileHash[#, "SHA256"], 16, 64]|> &,
    files
    ]
   ];


dsKiraArtifactIdentity[exportData_Association, linearData_Association] := Module[
   {contract = Lookup[linearData, "artifactContract", <||>], active, identity},
   active = Lookup[linearData, "activeBasis", <|"status" -> "disabled", "count" -> 0|>];
   identity = <|
     "identityVersion" -> 1,
     "linearSourceDigest" -> Lookup[contract, "sourceDigest", Missing["sourceDigest"]],
     "linearEquationsDigest" -> dsKiraExpressionDigest[Lookup[linearData, "linearEquations", {}]],
     "integralMapDigest" -> dsKiraExpressionDigest[Lookup[linearData, "integralRules", {}]],
     "targetDigest" -> dsKiraExpressionDigest[Lookup[exportData, "targetIntegralIDs", {}]],
     "coefficientRulesDigest" -> dsKiraExpressionDigest[Lookup[linearData, "coefficientRulesApplied", {}]],
     "activeBasisDigest" -> dsKiraExpressionDigest[active],
     "exportFiles" -> dsKiraExportFileDigests[exportData]
     |>;
   Join[identity, <|"exportContentDigest" -> dsKiraExpressionDigest[identity]|>]
   ];

dsKiraExportManifest[exportData_Association, linearData_Association] := <|
   "status" -> "exported",
   "packageVersion" -> $dSIBPVersion,
   "caseName" -> Lookup[linearData, "caseName", Missing["caseName"]],
   "context" -> Lookup[linearData, "dSIBPContextSummary", <||>],
   "linearArtifactContract" -> Lookup[linearData, "artifactContract", <||>],
   "artifactIdentity" -> dsKiraArtifactIdentity[exportData, linearData],
   "equationCount" -> Lookup[exportData, "exportedEquationCount", Missing["equationCount"]],
   "integralCount" -> Lookup[exportData, "integralCount", Missing["integralCount"]],
   "targetIntegralIDs" -> Lookup[exportData, "targetIntegralIDs", {}],
   "numericDummyIntegralId" -> Lookup[exportData, "numericDummyIntegralId", None],
   "numericDummySymbol" -> Lookup[Lookup[exportData, "kiraInput", <||>], "numericDummySymbol", Missing["numericDummySymbol"]],
   "coefficientVariables" -> Lookup[exportData, "coefficientVariables", {}],
   "coefficientAlgebraicGenerators" -> Lookup[exportData, "coefficientAlgebraicGenerators", {}],
   "backendExpressionVariables" -> Lookup[exportData, "backendExpressionVariables", {}],
   "coefficientVariableMap" -> Lookup[exportData, "coefficientVariableMap", {}],
   "backendCoefficientVariables" -> Lookup[exportData, "backendCoefficientVariables", {}],
   "backendImaginaryUnit" -> Lookup[exportData, "backendImaginaryUnit", None],
   "backendCoefficientSyntaxReport" -> Lookup[exportData, "backendCoefficientSyntaxReport", <||>],
   "gaussianPhaseGauge" -> Lookup[exportData, "gaussianPhaseGauge", <|"status" -> "notApplicable"|>],
   "backendEnergyConvention" -> Lookup[exportData, "backendEnergyConvention", <|"status" -> "notRequired"|>],
   "backendEnergyRuleData" -> Lookup[exportData, "backendEnergyRuleData", <|"status" -> "notRequired"|>],
   "physicalCoefficientRulesApplied" -> Lookup[exportData, "physicalCoefficientRulesApplied", {}],
   "pureRationalBackendQ" -> TrueQ[Lookup[exportData, "pureRationalBackendQ", False]],
   "backendTextAudit" -> Lookup[exportData, "backendTextAudit", <|"status" -> "notRun"|>],
   "numericDummyAppendedQ" -> TrueQ[Lookup[exportData, "numericDummyAppendedQ", False]],
   "integralList" -> Lookup[linearData, "integralList", {}],
   "integralRules" -> Lookup[linearData, "integralRules", {}],
   "kiraOrdering" -> Lookup[linearData, "kiraOrdering", <||>],
    "activeBasis" -> Lookup[linearData, "activeBasis", <|"status" -> "disabled", "count" -> 0|>],
     "deVariableNumericRuleAudit" -> Lookup[linearData, "deVariableNumericRuleAudit", <|"status" -> "notRun"|>],
   "coefficientRulesApplied" -> Lookup[linearData, "coefficientRulesApplied", {}],
   "userCoefficientRulesApplied" -> Lookup[linearData, "userCoefficientRulesApplied", {}],
   "zeroPointRules" -> Lookup[Lookup[linearData, "topology", <||>], "zeroPointRules", {}],
   "symmetryRules" -> Lookup[Lookup[linearData, "topology", <||>], "symmetryRules", {}],
   "tadpoleSymmetryData" -> dsStableTadpoleSymmetryData[Lookup[linearData, "tadpoleSymmetryData", <||>]],
   "loopTreeProjectionConvention" -> Lookup[Lookup[linearData, "dSIBPContextSummary", <||>], "loopTreeProjectionConvention", <||>]
   |>;

DSKiraExport[linearData_Association, opts : OptionsPattern[]] := Module[
   {preparedLinearData, activeSetting = OptionValue[KiraActiveBasis], effectiveTargets,
      makeOptions, exportData, manifest, deVariableRuleAudit, numericStage = OptionValue[KiraNumericStage], outputDirectory = OptionValue[OutputDirectory], manifestPath,
     progress = OptionValue[ProgressReporting]},
    If[! KeyExistsQ[linearData, "linearEquations"],
     Message[DSKiraExport::badlinear]; dsErrorPrint["输入缺少 linearEquations。 The input does not contain linearEquations."]; Return[<|"status" -> "failed", "reason" -> "notLinearData"|>]
     ];
    If[Lookup[linearData, "dSIBPStatus", "failed"] =!= "generated" ||
      ! TrueQ[Lookup[Lookup[linearData, "contextCapabilities", <||>], "timeIBPUsableQ", False]],
     Message[DSKiraExport::capability]; dsErrorPrint["请传入 DSLinear 返回且同源门禁通过的 linearData。 Pass linearData returned by DSLinear with a valid same-source gate."]; Return[<|
       "status" -> "failed", "reason" -> "capabilityGate"
       |>]
     ];
   If[TrueQ[OptionValue[KiraRequireCompleteSystem]] &&
     ! TrueQ[Lookup[linearData, "completeSystemQ", False]],
    Return[<|"status" -> "failed", "reason" -> "incompleteSystemForFormalReduction",
      "completeSystemQ" -> Lookup[linearData, "completeSystemQ", False]|>]
    ];
   preparedLinearData = dsKiraAttachActiveBasis[linearData, activeSetting];
    If[Lookup[preparedLinearData, "status", "missing"] =!= "generated",
    Message[DSKiraExport::badbasis, Lookup[preparedLinearData, "reason", "unknown"]];
    dsErrorPrint["active basis 或其导数 target closure 未通过导出门禁。 The active basis or its derivative target closure failed the export gate."]; Return[preparedLinearData]
     ];
    If[! MemberQ[{"symbolic", "postDerivative"}, numericStage],
     Message[DSKiraExport::badstage, numericStage]; Return[<|"status" -> "failed", "reason" -> "invalidNumericStage"|>]
     ];
    deVariableRuleAudit = dsKiraDEVariableRuleAudit[preparedLinearData, OptionValue[KiraCoefficientRules], numericStage];
    If[! TrueQ[Lookup[deVariableRuleAudit, "passQ", False]],
     Message[DSKiraExport::devarrules, KeyTake[deVariableRuleAudit, {"deVariables", "numericRuleLHSIntersection", "numericRuleRHSDependencies"}]];
     dsErrorPrint["symbolic 阶段必须保留 DE 变量；postDerivative 只允许在解析一阶导数与 closure 已构造后使用。 The symbolic stage must preserve every DE variable; postDerivative is allowed only after analytic first derivatives and their closure have been constructed."];
     Return[<|
       "status" -> "failed",
       "reason" -> "differentialVariablesWouldBeNumerical",
       "deVariableNumericRuleAudit" -> deVariableRuleAudit
       |>]
     ];
    preparedLinearData = Join[preparedLinearData, <|"deVariableNumericRuleAudit" -> deVariableRuleAudit|>];
    effectiveTargets = dsKiraEffectiveTargets[preparedLinearData, OptionValue[KiraTargetIntegrals]];
    makeOptions = DeleteCases[
      FilterRules[{opts}, Options[makeKiraExportData]],
       HoldPattern[(KiraTargetIntegrals | KiraNumericStage) -> _]
     ];
   exportData = dsStageRun[
     "序列化 Kira 基础输入 / Serializing basic Kira input",
     makeKiraExportData[
      preparedLinearData,
      Sequence @@ makeOptions,
       KiraTargetIntegrals -> effectiveTargets
      ],
     progress
     ];
   If[Lookup[exportData, "status", "missing"] =!= "ready",
    Message[DSKiraExport::failed, Lookup[exportData, "reason", Lookup[exportData, "status", Missing["status"]]]];
    dsErrorPrint["package 未运行 Kira；当前只报告导出门禁失败。 The package did not run Kira; only the failed export gate is reported."]; Return[exportData]
    ];
   manifest = dsKiraExportManifest[exportData, Lookup[exportData, "linearSystem", preparedLinearData]];
   If[StringQ[outputDirectory],
    manifestPath = FileNameJoin[{outputDirectory, "dsibp-export-manifest.wl"}];
    Quiet[Check[Put[manifest, manifestPath], manifestPath = $Failed]],
    manifestPath = Missing["NotWritten"]
    ];
    Join[exportData, <|
      "deVariableNumericRuleAudit" -> deVariableRuleAudit,
      "dSIBPExportManifest" -> manifest,
      "dSIBPExportManifestPath" -> manifestPath
      |>]
    ];

(* ::Package:: *)
(* 用户主积分只定义 J 线性空间中的有序坐标，不建立与 J 并行的物理积分表示。 *)

(* ::Chapter:: *)
(*018 userMI basis 构造与查询*)

DSUserMI::badlinear = "DSUserMI 需要 DSLinear 返回且尚未附加 userMI 的 linearData。";
DSUserMI::badbasis = "userMI basis 无效：`1`。";


(* ::Section::Closed:: *)
(*精确线性坐标*)

dsUserMIFirstNonzeroPosition[row_List] := FirstCase[
   Range[Length[row]],
   index_ /; ! TrueQ[Together[row[[index]]] === 0],
   Missing["NoPivot"]
   ];


dsUserMICoordinateData[expressions_List, activeIndices_List, integralList_List] := Module[
   {support, outsideSupport, matrix, residuals, reduced, pivotColumns, rank,
    activeRank, spectatorColumns, pivotMatrix, spectatorMatrix, tokens,
    pivotIntegrals, spectatorIntegrals, reverseExpressions, forwardRules,
    reverseRules, forwardResiduals, reverseResiduals, payload},
   support = DeleteDuplicates@Cases[expressions, _J, Infinity];
   outsideSupport = Complement[support, integralList];
   If[support === {} || outsideSupport =!= {},
    Return[<|"status" -> "failed", "reason" -> "basisSupportOutsideLinearData",
      "supportIntegrals" -> support, "outsideSupportIntegrals" -> outsideSupport|>]
    ];
   matrix = Table[
     Coefficient[Expand[expressions[[i]]], support[[j]]],
     {i, Length[expressions]}, {j, Length[support]}
     ];
   residuals = MapThread[Together[#1 - #2.#3] &, {
      expressions,
      matrix,
      ConstantArray[support, Length[expressions]]
      }];
   If[! And @@ (TrueQ[# === 0] & /@ residuals),
    Return[<|"status" -> "failed", "reason" -> "basisMustBeHomogeneousLinearInJ",
      "reconstructionResiduals" -> residuals|>]
    ];
   reduced = Quiet@Check[RowReduce[matrix], $Failed];
   If[reduced === $Failed,
    Return[<|"status" -> "failed", "reason" -> "basisRankComputationFailed"|>]
    ];
   pivotColumns = DeleteMissing[dsUserMIFirstNonzeroPosition /@ reduced];
   rank = Length[pivotColumns];
   activeRank = MatrixRank[matrix[[activeIndices]]];
   If[rank =!= Length[expressions] || activeRank =!= Length[activeIndices],
    Return[<|"status" -> "failed", "reason" -> "basisRowsMustBeIndependent",
      "rank" -> rank, "basisCount" -> Length[expressions],
      "activeRank" -> activeRank, "activeCount" -> Length[activeIndices]|>]
    ];
   spectatorColumns = Complement[Range[Length[support]], pivotColumns];
   pivotMatrix = matrix[[All, pivotColumns]];
   spectatorMatrix = matrix[[All, spectatorColumns]];
   tokens = userMI /@ Range[Length[expressions]];
   pivotIntegrals = support[[pivotColumns]];
   spectatorIntegrals = support[[spectatorColumns]];
   reverseExpressions = Together /@ (Inverse[pivotMatrix].(
        tokens - spectatorMatrix.spectatorIntegrals
        ));
   forwardRules = Thread[tokens -> expressions];
   reverseRules = Thread[pivotIntegrals -> reverseExpressions];
   forwardResiduals = Together /@ (tokens - (expressions /. reverseRules));
   reverseResiduals = Together /@ (pivotIntegrals - (reverseExpressions /. forwardRules));
   payload = <|
     "status" -> "configured",
     "count" -> Length[expressions],
     "tokens" -> tokens,
     "expressions" -> expressions,
     "activeIndices" -> activeIndices,
     "activeTokens" -> tokens[[activeIndices]],
     "activeExpressions" -> expressions[[activeIndices]],
     "supportIntegrals" -> support,
     "supportCount" -> Length[support],
     "coefficientMatrix" -> matrix,
     "rank" -> rank,
     "activeRank" -> activeRank,
     "pivotColumns" -> pivotColumns,
     "pivotIntegrals" -> pivotIntegrals,
     "spectatorColumns" -> spectatorColumns,
     "spectatorIntegrals" -> spectatorIntegrals,
     "forwardRules" -> forwardRules,
     "reverseRules" -> reverseRules,
     "forwardRoundTripResiduals" -> forwardResiduals,
     "reverseRoundTripResiduals" -> reverseResiduals,
     "reversibleQ" -> TrueQ[And @@ (TrueQ[# === 0] & /@ Join[forwardResiduals, reverseResiduals])],
     "sourceIntegralOrderDigest" -> dsKiraExpressionDigest[integralList]
     |>;
   Join[payload, <|"mappingDigest" -> dsKiraExpressionDigest[payload]|>]
   ];


(* ::Section:: *)
(*公开构造与查询*)

DSUserMI[linearData_Association, expressions_List, spec_Association : <||>] := Module[
   {names, activeIndices, coordinateData, setting, prepared},
   If[Lookup[linearData, "dSIBPStatus", "failed"] =!= "generated" ||
     ! ListQ[Lookup[linearData, "integralList", Missing["integralList"]]] ||
     Lookup[Lookup[linearData, "activeBasis", <||>], "status", "disabled"] === "configured",
    Message[DSUserMI::badlinear];
    Return[<|"status" -> "failed", "reason" -> "notUnpreparedLinearData"|>]
    ];
   names = dsKiraActiveBasisNames[Lookup[spec, "names", Automatic], Length[expressions]];
   activeIndices = Replace[Lookup[spec, "activeIndices", Automatic], (Automatic | All) -> Range[Length[expressions]]];
   If[names === $Failed || Length[names] =!= Length[expressions] ||
     ! DuplicateFreeQ[names] || ! And @@ (StringQ[#] && # =!= "" & /@ names) ||
     ! ListQ[activeIndices] || activeIndices === {} || ! DuplicateFreeQ[activeIndices] ||
     ! And @@ (IntegerQ[#] && 1 <= # <= Length[expressions] & /@ activeIndices),
    Message[DSUserMI::badbasis, "invalid names or activeIndices"];
    Return[<|"status" -> "failed", "reason" -> "invalidNamesOrActiveIndices"|>]
    ];
   coordinateData = dsUserMICoordinateData[expressions, activeIndices, linearData["integralList"]];
   If[Lookup[coordinateData, "status", "failed"] =!= "configured" ||
     ! TrueQ[Lookup[coordinateData, "reversibleQ", False]],
    Message[DSUserMI::badbasis, Lookup[coordinateData, "reason", "coordinate map is not reversible"]];
    Return[coordinateData]
    ];
   setting = <|
     "names" -> names,
     "expressions" -> expressions,
     "activeIndices" -> activeIndices,
     "derivativeVariables" -> Lookup[spec, "derivativeVariables", Automatic],
     "scalingDegrees" -> Lookup[spec, "scalingDegrees", Automatic],
     "userMIData" -> coordinateData
     |>;
   prepared = dsKiraAttachActiveBasis[linearData, setting];
   If[Lookup[prepared, "status", "failed"] =!= "generated",
    Message[DSUserMI::badbasis, Lookup[prepared, "reason", "active-basis preparation failed"]]
    ];
   prepared
   ];


DSUserMI[data_Association] := Lookup[
   Lookup[data, "activeBasis", <||>],
   "userMI",
   Missing["UserMINotConfigured"]
   ];


DSUserMI[data_Association, key_String] := Lookup[DSUserMI[data], key, Missing["UnknownUserMIKey", key]];


DSUserMI[_, ___] := (Message[DSUserMI::badbasis, "expected linearData, an ordered expression list, and an optional Association"]; <|"status" -> "failed", "reason" -> "invalidArguments"|>);

(* ::Package:: *)

(* 本文件按 linearData 已冻结的积分顺序构造预约化 targets 和解析 derivative closure。
   package 只生成计划与输入，不运行 Kira。 *)


(* ::Chapter:: *)
(*018 Kira 两阶段 reduction 计划*)

DSKiraPlan::badlinear = "DSKiraPlan 需要 DSLinear 返回的 backend-neutral linearData。 DSKiraPlan requires backend-neutral linearData returned by DSLinear.";
DSKiraPlan::badspec = "Kira 计划配置无效：`1`。 The Kira plan specification is invalid: `1`.";
DSKiraPlan::badstage = "stage 只允许 \"preReduction\" 或 \"formal\"，收到 `1`。 stage must be \"preReduction\" or \"formal\"; received `1`.";
DSKiraPlan::badbasis = "formal 计划需要可闭合的 activeBasis：`1`。 A formal plan requires a closed activeBasis: `1`.";
DSKiraPlan::incomplete = "formal 计划只接受 completeSystemQ=True 的 linearData。 A formal plan requires linearData with completeSystemQ=True.";


Options[DSKiraPlan] = {ProgressReporting -> Automatic};


(* ::Section::Closed:: *)
(*既定积分顺序与显式重排*)

DSReorderIntegrals::badlinear = "DSReorderIntegrals 需要 DSLinear 返回的 backend-neutral linearData。";
DSReorderIntegrals::badorder = "积分顺序必须是由现有 J 或积分 ID 组成的非空列表。";


DSReorderIntegrals[linearData_Association, order_List] := Module[{result},
   If[Lookup[linearData, "dSIBPStatus", "failed"] =!= "generated" ||
     ! ListQ[Lookup[linearData, "integralList", Missing["integralList"]]],
    Message[DSReorderIntegrals::badlinear];
    Return[<|"status" -> "failed", "reason" -> "notLinearData"|>]
    ];
   If[Lookup[Lookup[linearData, "activeBasis", <||>], "status", "disabled"] === "configured",
    Message[DSReorderIntegrals::badorder];
    Return[<|"status" -> "failed", "reason" -> "reorderMustPrecedeUserMI"|>]
    ];
   If[order === {},
    Message[DSReorderIntegrals::badorder];
    Return[<|"status" -> "failed", "reason" -> "emptyIntegralOrder"|>]
    ];
   result = reorderLinearSystemIntegrals[linearData, order];
   Join[result, <|
     "integralOrderAuthority" -> "linearData.integralList",
     "integralOrderDigest" -> dsKiraExpressionDigest[result["integralList"]]
     |>]
   ];


DSReorderIntegrals[_, _] := (Message[DSReorderIntegrals::badorder]; <|"status" -> "failed", "reason" -> "invalidIntegralOrder"|>);

dsKiraPlanIntegralFromItem[item_, linearData_Association] := Which[
   Head[item] === J && MemberQ[linearData["integralList"], item], item,
   IntegerQ[item] && 1 <= item <= Length[linearData["integralList"]], linearData["integralList"][[item]],
   True, Missing["UnknownIntegral", item]
   ];


dsKiraPlanIntegralList[items_List, linearData_Association] := DeleteDuplicates@DeleteMissing[
   dsKiraPlanIntegralFromItem[#, linearData] & /@ items
   ];


dsKiraPlanCertificate[activeData_Association] := Module[{payload},
   payload = HoldComplete[
     Lookup[activeData, "activeExpressions", {}],
     Lookup[activeData, "derivativeVariables", {}],
     Lookup[activeData, "rawDerivatives", {}],
     Lookup[activeData, "derivativeTargetIntegrals", {}]
     ];
   <|
    "status" -> "frozenBeforeNumericalRules",
    "hashAlgorithm" -> "SHA256",
    "hash" -> IntegerString[Hash[payload, "SHA256"], 16, 64],
    "activeCount" -> Lookup[activeData, "activeCount", 0],
    "derivativeVariableCount" -> Length[Lookup[activeData, "derivativeVariables", {}]],
    "derivativeTargetCount" -> Length[Lookup[activeData, "derivativeTargetIntegrals", {}]]
    |>
   ];


(* ::Section:: *)
(*公开 Kira 两阶段计划*)

DSKiraPlan[linearData_Association, spec_Association, OptionsPattern[]] := Module[
   {stage, preferred, order, ordered, candidates, activeSetting, preview, activeData, targets,
    numericStage, coefficientRules, outputDirectory, jobOptions, certificate, progress},
   If[Lookup[linearData, "dSIBPStatus", "failed"] =!= "generated" || ! KeyExistsQ[linearData, "linearEquations"],
    Message[DSKiraPlan::badlinear]; Return[<|"status" -> "failed", "reason" -> "notLinearData"|>]
    ];
   progress = OptionValue[ProgressReporting];
   stage = Lookup[spec, "stage", Missing["stage"]];
   If[! MemberQ[{"preReduction", "formal"}, stage],
    Message[DSKiraPlan::badstage, stage]; Return[<|"status" -> "failed", "reason" -> "invalidStage"|>]
    ];
   If[stage === "formal" && ! TrueQ[Lookup[linearData, "completeSystemQ", False]],
    Message[DSKiraPlan::incomplete];
    Return[<|"status" -> "failed", "reason" -> "incompleteSystemForFormalReduction",
      "completeSystemQ" -> Lookup[linearData, "completeSystemQ", False]|>]
    ];
   preferred = dsKiraPlanIntegralList[Lookup[spec, "preferredIntegrals", {}], linearData];
   order = linearData["integralList"];
   ordered = linearData;
   coefficientRules = Lookup[spec, "coefficientRules", {}];
   outputDirectory = Lookup[spec, "outputDirectory", None];
   jobOptions = Lookup[spec, "jobOptions", Automatic];
   If[! MemberQ[{None, Automatic}, outputDirectory] && ! StringQ[outputDirectory],
    Message[DSKiraPlan::badspec, "outputDirectory must be a string or None"];
    Return[<|"status" -> "failed", "reason" -> "invalidOutputDirectory"|>]
    ];
   If[stage === "preReduction",
    candidates = Replace[Lookup[spec, "candidateIntegrals", Automatic], Automatic :> order];
    If[! ListQ[candidates], candidates = {candidates}];
    candidates = dsKiraPlanIntegralList[candidates, ordered];
    If[candidates === {},
     Message[DSKiraPlan::badspec, "empty candidateIntegrals"];
     Return[<|"status" -> "failed", "reason" -> "emptyCandidateIntegrals"|>]
     ];
    Return[<|
      "status" -> "planned", "kiraPlanQ" -> True, "stage" -> stage,
      "caseName" -> Lookup[linearData, "caseName", Missing["caseName"]],
      "linearData" -> linearData, "integralOrder" -> order,
      "orderingConvention" -> "linearDataIntegralList",
      "preferredIntegrals" -> preferred, "targetIntegrals" -> candidates,
      "targetCount" -> Length[candidates], "activeBasis" -> None,
      "numericStage" -> "symbolic", "coefficientRules" -> coefficientRules,
      "outputDirectory" -> outputDirectory, "jobOptions" -> jobOptions,
      "phaseIsolation" -> <|"stage" -> stage, "requiresSeparateOutputDirectoryQ" -> True|>
      |>]
    ];
   activeSetting = Lookup[spec, "activeBasis", Automatic];
   If[! AssociationQ[activeSetting] && ! (
       activeSetting === Automatic &&
        Lookup[Lookup[ordered, "activeBasis", <||>], "status", "disabled"] === "configured"
       ),
    Message[DSKiraPlan::badbasis, "missing activeBasis Association"];
    Return[<|"status" -> "failed", "reason" -> "missingActiveBasis"|>]
    ];
   preview = dsStageRun[
     "构造解析 active-basis 一阶导数与 target closure / Building analytic active-basis first derivatives and target closure",
     dsKiraAttachActiveBasis[ordered, activeSetting],
     progress
     ];
   If[Lookup[preview, "status", "missing"] =!= "generated" ||
     Lookup[Lookup[preview, "activeBasis", <||>], "status", "failed"] =!= "configured",
    Message[DSKiraPlan::badbasis, Lookup[preview, "reason", "closure failed"]];
    Return[<|"status" -> "failed", "reason" -> "activeBasisClosureFailed", "preview" -> preview|>]
    ];
   activeData = preview["activeBasis"];
   targets = activeData["targetIntegralIDs"];
   numericStage = Lookup[spec, "numericStage", "symbolic"];
   If[! MemberQ[{"symbolic", "postDerivative"}, numericStage],
    Message[DSKiraPlan::badspec, "numericStage"];
    Return[<|"status" -> "failed", "reason" -> "invalidNumericStage"|>]
    ];
   certificate = dsKiraPlanCertificate[activeData];
   <|
    "status" -> "planned", "kiraPlanQ" -> True, "stage" -> stage,
    "caseName" -> Lookup[linearData, "caseName", Missing["caseName"]],
    "linearData" -> linearData, "integralOrder" -> order,
    "orderingConvention" -> "linearDataIntegralList",
    "preferredIntegrals" -> preferred, "activeBasis" -> activeSetting,
    "activeBasisPreview" -> activeData,
    "preparedLinearData" -> preview,
    "analyticDerivativeCertificate" -> certificate,
    "targetIntegralIDsPreview" -> targets,
    "minimalTargetsQ" -> True,
    "numericStage" -> numericStage, "coefficientRules" -> coefficientRules,
    "outputDirectory" -> outputDirectory, "jobOptions" -> jobOptions,
    "phaseIsolation" -> <|"stage" -> stage, "requiresSeparateOutputDirectoryQ" -> True|>
    |>
   ];


dsKiraPlanQ[plan_Association] := TrueQ[Lookup[plan, "kiraPlanQ", False]] &&
   Lookup[plan, "status", "failed"] === "planned";


(* ::Section:: *)
(*计划驱动的 Kira 导出*)

DSKiraExport[plan_Association] /; dsKiraPlanQ[plan] := Module[
   {result, manifest, path, prepared, expectedCertificate, actualCertificate},
   prepared = If[
     Lookup[plan, "stage", "formal"] === "preReduction",
     Lookup[plan, "linearData", Missing["linearData"]],
     Lookup[plan, "preparedLinearData", Missing["preparedLinearData"]]
     ];
   If[! AssociationQ[prepared],
    Return[<|"status" -> "failed", "reason" -> "missingPreparedLinearData"|>]
    ];
   If[Lookup[plan, "stage", "formal"] === "formal",
    expectedCertificate = Lookup[plan, "analyticDerivativeCertificate", <||>];
    actualCertificate = dsKiraPlanCertificate[Lookup[prepared, "activeBasis", <||>]];
    If[Lookup[expectedCertificate, "hash", None] =!= Lookup[actualCertificate, "hash", Missing["hash"]],
     Return[<|"status" -> "failed", "reason" -> "preparedActiveBasisDigestMismatch",
       "expectedCertificate" -> expectedCertificate, "actualCertificate" -> actualCertificate|>]
     ]
    ];
   result = DSKiraExport[
     prepared,
     KiraActiveBasis -> If[Lookup[plan, "stage", "formal"] === "formal", Automatic, None],
     KiraTargetIntegrals -> Lookup[plan, "targetIntegrals", Automatic],
     KiraCoefficientRules -> plan["coefficientRules"],
     KiraJobOptions -> plan["jobOptions"],
     KiraNumericStage -> plan["numericStage"],
     KiraRequireCompleteSystem -> TrueQ[Lookup[plan, "stage", "formal"] === "formal"],
     OutputDirectory -> plan["outputDirectory"]
     ];
   If[Lookup[result, "status", "failed"] =!= "ready", Return[result]];
   manifest = Join[Lookup[result, "dSIBPExportManifest", <||>], <|
      "kiraPlan" -> KeyDrop[plan, {"linearData", "activeBasisPreview", "preparedLinearData"}]
      |>];
   path = Lookup[result, "dSIBPExportManifestPath", Missing["NotWritten"]];
   If[StringQ[path], Quiet[Check[Put[manifest, path], Null]]];
   Join[result, <|"dSIBPExportManifest" -> manifest|>]
   ];

(* ::Package:: *)

(* ::Chapter:: *)
(*018 Kira 结果取回*)

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

dsKiraIntegralTokenQ[expr_] := MatchQ[expr, _J | dsTreeToken[_String, J[_List]]];

dsJToIDPairs[rules_List] := Select[
   Cases[rules, HoldPattern[Rule[integral_, id_Integer]] :> {integral, id}],
   dsKiraIntegralTokenQ[First[#]] &
   ];
dsIDToJPairs[rules_List] := Select[
   Cases[rules, HoldPattern[Rule[Tuserweight[id_Integer], integral_]] :> {id, integral}],
   dsKiraIntegralTokenQ[Last[#]] &
   ];

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


(* ::Section::Closed:: *)
(*Kira 内部相位能量坐标恢复*)

dsKiraBackendEnergyConventionDataQ[data_Association] := Module[
   {status, records, physical, backend, names, forward, backward},
   status = Lookup[data, "status", "notRequired"];
   If[status === "notRequired", Return[True]];
   If[status =!= "configured" ||
     Lookup[data, "scope", Missing["scope"]] =!= "KiraBackendOnly" ||
     Lookup[data, "physicalToBackendConvention", Missing["convention"]] =!=
      "physicalEnergy == -I backendEnergy" ||
     Lookup[data, "derivativeConvention", Missing["derivativeConvention"]] =!=
      "D[physicalEnergy] == I D[backendEnergy]" ||
     Lookup[data, "eulerConvention", Missing["eulerConvention"]] =!=
      "physicalEnergy D[physicalEnergy] == backendEnergy D[backendEnergy]",
    Return[False]
    ];
   records = Lookup[data, "records", Missing["records"]];
   If[! ListQ[records] || records === {} || ! And @@ (AssociationQ /@ records), Return[False]];
   physical = Lookup[records, "physical", {}];
   backend = Lookup[records, "backend", {}];
   names = Lookup[records, "backendName", {}];
   forward = Lookup[records, "physicalToBackendRule", {}];
   backward = Lookup[records, "backendToPhysicalRule", {}];
   And[
    And @@ (Head[#] === Symbol & /@ physical),
    And @@ (Head[#] === Symbol & /@ backend),
    And @@ (StringQ /@ names),
    DuplicateFreeQ[physical], DuplicateFreeQ[backend], DuplicateFreeQ[names],
    backend === (kiraBackendSymbol /@ names),
    forward === MapThread[Rule[#1, -I #2] &, {physical, backend}],
    backward === MapThread[Rule[#1, I #2] &, {backend, physical}],
    Lookup[data, "physicalToBackendRules", Missing["forward"]] === forward,
    Lookup[data, "backendToPhysicalRules", Missing["backward"]] === backward,
    And @@ (# === I & /@ Lookup[records, "physicalDerivativeFromBackendFactor", {}]),
    And @@ (# === -I & /@ Lookup[records, "backendDerivativeFromPhysicalFactor", {}]),
    And @@ (TrueQ /@ Lookup[records, "eulerOperatorInvariantQ", {}])
    ]
   ];


dsKiraRestorePhysicalEnergyVariables[rules_List, data_Association] := Module[{restoreRules},
   If[Lookup[data, "status", "notRequired"] =!= "configured", Return[rules]];
   restoreRules = Map[
     Function[record,
      With[{name = Lookup[record, "backendName"], physical = Lookup[record, "physical"]},
       HoldPattern[s_Symbol /; SymbolName[Unevaluated[s]] === name] :> I physical
       ]
      ],
     Lookup[data, "records", {}]
     ];
   rules /. restoreRules
   ];


(* ::Section::Closed:: *)
(*Gaussian 相位规范恢复*)

dsKiraGaussianPhaseGaugeDataQ[data_Association, integralCount_Integer] := Module[
   {status, convention, phaseRules, ids, phases},
   status = Lookup[data, "status", "notApplicable"];
   If[status === "notApplicable", Return[True]];
   If[! MemberQ[{"applied", "notRequired"}, status], Return[False]];
   convention = Lookup[data, "physicalToBackendConvention", Missing["convention"]];
   phaseRules = Lookup[data, "integralPhaseRules", Missing["integralPhaseRules"]];
   If[convention =!= "J[id] == I^phase[id] Kira[id]" || ! dsRuleListQ[phaseRules], Return[False]];
   ids = First /@ phaseRules;
   phases = Last /@ phaseRules;
   Lookup[data, "integralCount", Missing["integralCount"]] === integralCount &&
    ids === Range[integralCount] && And @@ (MemberQ[{0, 1}, #] & /@ phases) &&
    DuplicateFreeQ[ids] && TrueQ[Lookup[data, "conflictCount", 0] === 0]
   ];


dsKiraRestorePhysicalPhaseGauge[rules_List, data_Association] := Module[
   {status = Lookup[data, "status", "notApplicable"], phaseByID},
   If[status === "notApplicable", Return[rules]];
   phaseByID = Association[Lookup[data, "integralPhaseRules", {}]];
   rules /. HoldPattern[Rule[Tuserweight[lhsID_Integer], rhs_]] :>
     Rule[
      Tuserweight[lhsID],
      Expand[I^Lookup[phaseByID, lhsID, 0] (rhs /.
          Tuserweight[rhsID_Integer] :> I^(-Lookup[phaseByID, rhsID, 0]) Tuserweight[rhsID])]
      ]
   ];


dsKiraContextMatchQ[manifest_Association, context_Association] := And[
   Lookup[Lookup[manifest, "context", <||>], "inputHash", Missing["inputHash"]] === Lookup[context, "inputHash", Missing["contextHash"]],
   Lookup[manifest, "zeroPointRules", Missing["zeroPointRules"]] === Lookup[context["topology"], "zeroPointRules", Missing["contextZeroPointRules"]],
   Lookup[manifest, "symmetryRules", Missing["symmetryRules"]] === Lookup[context["topology"], "symmetryRules", Missing["contextSymmetryRules"]],
   Lookup[manifest, "tadpoleSymmetryData", Missing["tadpoleSymmetryData"]] === dsStableTadpoleSymmetryData[Lookup[context["topology"], "tadpoleSymmetryData", tadpoleSymmetryData[context["topology"]]]],
   Lookup[manifest, "loopTreeProjectionConvention", Missing["projectionConvention"]] === Lookup[context, "loopTreeProjectionConvention", Missing["contextProjectionConvention"]]
   ];


dsKiraExportFileDigestsQ[identity_Association, workspace_String] := Module[
   {root = ExpandFileName[workspace], records, paths},
   records = Lookup[identity, "exportFiles", Missing["exportFiles"]];
   If[! ListQ[records] || records === {}, Return[False]];
   paths = FileNameJoin[{root, Lookup[#, "path", ""]}] & /@ records;
   And @@ MapThread[
     Function[{record, path},
      StringStartsQ[ExpandFileName[path], root] && FileExistsQ[path] &&
       IntegerString[FileHash[path, "SHA256"], 16, 64] === Lookup[record, "sha256", Missing["sha256"]]
      ],
     {records, paths}
     ]
   ];


dsKiraArtifactIdentityQ[
   manifest_Association,
   workspace_String,
   repJ2Kira_List
   ] := Module[{identity, payload, contract},
   identity = Lookup[manifest, "artifactIdentity", Missing["artifactIdentity"]];
   contract = Lookup[manifest, "linearArtifactContract", <||>];
   If[! AssociationQ[identity] || ! AssociationQ[contract], Return[False]];
   payload = KeyDrop[identity, "exportContentDigest"];
   TrueQ[
    Lookup[identity, "exportContentDigest", Missing["exportContentDigest"]] === dsKiraExpressionDigest[payload] &&
     Lookup[identity, "linearSourceDigest", Missing["linearSourceDigest"]] === Lookup[contract, "sourceDigest", Missing["sourceDigest"]] &&
     Lookup[identity, "integralMapDigest", Missing["integralMapDigest"]] === dsKiraExpressionDigest[Lookup[manifest, "integralRules", {}]] &&
     Lookup[identity, "integralMapDigest", Missing["integralMapDigest"]] === dsKiraExpressionDigest[repJ2Kira] &&
     Lookup[identity, "targetDigest", Missing["targetDigest"]] === dsKiraExpressionDigest[Lookup[manifest, "targetIntegralIDs", {}]] &&
     Lookup[identity, "coefficientRulesDigest", Missing["coefficientRulesDigest"]] === dsKiraExpressionDigest[Lookup[manifest, "coefficientRulesApplied", {}]] &&
     Lookup[identity, "activeBasisDigest", Missing["activeBasisDigest"]] === dsKiraExpressionDigest[Lookup[manifest, "activeBasis", <||>]] &&
     dsKiraExportFileDigestsQ[identity, workspace]
    ]
   ];


(* ::Section::Closed:: *)
(*Active basis manifest 门禁*)

dsKiraActiveBasisData[manifest_Association] := Lookup[manifest, "activeBasis", <|"status" -> "disabled", "count" -> 0|>];

dsKiraUserMIDataQ[userData_Association, activeData_Association] := Module[
   {count, expressions, activeIndices, tokens, activeTokens, backendIDs, backendTokens, payload},
   count = Lookup[userData, "count", -1];
   expressions = Lookup[userData, "expressions", {}];
   activeIndices = Lookup[userData, "activeIndices", {}];
   tokens = Lookup[userData, "tokens", {}];
   activeTokens = Lookup[userData, "activeTokens", {}];
   backendIDs = Lookup[userData, "backendIDs", {}];
   backendTokens = Lookup[userData, "backendTokens", {}];
   payload = KeyDrop[userData, {
      "mappingDigest", "backendIDs", "backendTokens", "activeBackendIDs",
      "activeBackendTokens", "userMIToBackendRules", "backendToUserMIRules"
      }];
   Lookup[userData, "status", "failed"] === "configured" &&
    count === Lookup[activeData, "count", -2] &&
    expressions === Lookup[activeData, "expressions", Missing["expressions"]] &&
    activeIndices === Lookup[activeData, "activeIndices", Missing["activeIndices"]] &&
    tokens === (userMI /@ Range[count]) && activeTokens === tokens[[activeIndices]] &&
    backendIDs === Lookup[activeData, "ids", Missing["ids"]] &&
    backendTokens === (Tuserweight /@ backendIDs) &&
    Lookup[userData, "activeBackendIDs", {}] === Lookup[activeData, "activeIDs", Missing["activeIDs"]] &&
    Lookup[userData, "activeBackendTokens", {}] === (Tuserweight /@ Lookup[activeData, "activeIDs", {}]) &&
    Lookup[userData, "userMIToBackendRules", {}] === Thread[tokens -> backendTokens] &&
    Lookup[userData, "backendToUserMIRules", {}] === Thread[backendTokens -> tokens] &&
    TrueQ[Lookup[userData, "reversibleQ", False]] &&
    Lookup[userData, "rank", -1] === count &&
    Lookup[userData, "mappingDigest", Missing["mappingDigest"]] === dsKiraExpressionDigest[payload]
   ];


dsKiraUserMIDataQ[None, _Association] := True;
dsKiraUserMIDataQ[_, _Association] := False;


dsKiraActiveBasisDataQ[data_Association] := Module[
   {status, count, activeCount, names, expressions, ids, tokens, activeIndices, activeNames,
    activeExpressions, activeIDs, activeTokens, auxiliaryIDs, variables, targetIDs, userData},
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
   userData = Lookup[data, "userMI", None];
   status === "configured" && IntegerQ[count] && count > 0 && IntegerQ[activeCount] && activeCount > 0 &&
    Length[names] === count && Length[expressions] === count && Length[ids] === count && Length[tokens] === count &&
    And @@ (StringQ[#] && # =!= "" & /@ names) && DuplicateFreeQ[names] &&
    ids === Range[count] && tokens === (Tuserweight /@ ids) &&
    Length[activeIndices] === activeCount && DuplicateFreeQ[activeIndices] &&
    And @@ (IntegerQ[#] && 1 <= # <= count & /@ activeIndices) &&
    activeIDs === ids[[activeIndices]] && activeNames === names[[activeIndices]] &&
    activeExpressions === expressions[[activeIndices]] && activeTokens === (Tuserweight /@ activeIDs) &&
    auxiliaryIDs === Complement[ids, activeIDs] && variables =!= {} &&
    DuplicateFreeQ[targetIDs] && Complement[activeIDs, targetIDs] === {} &&
    dsKiraUserMIDataQ[userData, data]
   ];

dsKiraBackendMasterObject[id_Integer, activeIDs_List, idToJ_Association] := If[
   MemberQ[activeIDs, id],
   Tuserweight[id],
   Lookup[idToJ, id, Missing["unrecognizedBackendMasterID", id]]
   ];

DSKiraImport[root_String, context_: Automatic, OptionsPattern[]] := Module[
   {resolved, workspace, files, missingFiles, manifest, repJ2Kira, repKira2J, reductionRulesBackend, reductionRulesRaw, masterText,
    completionText, completionQ, requiredFiles, mapQ, manifestMapQ, contextQ, artifactIdentityQ, masterIDs, mapPairs, idToJ, mapIDs,
    dummyID, targetIDs, ruleIDs, completeTargetsQ, rhsMastersQ, coefficientVariables, allowedCoefficientVariables,
    coefficientQ, coefficientVariableMap, backendImaginaryUnit, backendVariableNames, allowedBackendVariableNames,
    backendEnergyConvention, backendEnergyConventionQ,
    gaussianPhaseGauge, gaussianPhaseGaugeQ,
    backendCoefficientQ, activeData, activeDataQ, activeQ, relationIDs, activeIDs, auxiliaryIDs, activeExpressions, activeTokens, activeUserMITokens,
    activeMasterOrderQ, auxiliaryNotMastersQ, recognizedIDs, backendMasters, boundaryMasterIDs, boundaryMasters,
     checks, diagnostics, issues, reductionRules, masters, masterTokens, returnedMasterIDs, progress = OptionValue[ProgressReporting]},
   resolved = dsResolveContext[context];
   If[Head[resolved] === Missing,
    Message[DSKiraImport::mismatch, "missing DSInit context"]; dsErrorPrint["Kira import 需要同源 DSInit context。 Kira import requires the matching DSInit context."]; Return[<|"status" -> "failed", "reason" -> "missingContext"|>]
    ];
   workspace = ExpandFileName[root];
   If[! DirectoryQ[workspace],
    Message[DSKiraImport::badpath, workspace]; dsErrorPrint["Kira workspace 不存在。 The Kira workspace does not exist."]; Return[<|"status" -> "failed", "reason" -> "invalidWorkspace", "workspace" -> workspace|>]
    ];
   files = <|
     "manifest" -> FileNameJoin[{workspace, "dsibp-export-manifest.wl"}],
     "repJ2Kira" -> FileNameJoin[{workspace, "result", "repJ2kira.m"}],
     "repKira2J" -> FileNameJoin[{workspace, "result", "repkira2J.m"}],
      "reduction" -> dsKiraResolveFile[workspace, OptionValue[KiraReductionFile], {"results", "Tuserweight", "kira_list.m"}],
      "masters" -> dsKiraResolveFile[workspace, OptionValue[KiraMasterFile], {"results", "Tuserweight", "masters"}],
     "completion" -> dsKiraResolveFile[workspace, OptionValue[KiraCompletionFile], {"kira.log"}]
     |>;
   requiredFiles = KeyDrop[files, "completion"];
   missingFiles = Select[Normal[requiredFiles], ! StringQ[Last[#]] || ! FileExistsQ[Last[#]] &];
   If[missingFiles =!= {},
    Message[DSKiraImport::missing, missingFiles]; dsErrorPrint["完整 Kira 结果文件不足，未导入。 Required Kira result files are missing, so no result was imported."]; Return[<|"status" -> "failed", "reason" -> "missingFiles", "workspace" -> workspace, "files" -> files, "missingFiles" -> missingFiles|>]
    ];
   {manifest, repJ2Kira, repKira2J, reductionRulesBackend} = dsStageRun[
     "读取 Kira manifest、映射与 reduction / Reading the Kira manifest, maps, and reduction",
     dsKiraReadExpression /@ Lookup[files, {"manifest", "repJ2Kira", "repKira2J", "reduction"}],
     progress
     ];
   masterText = Import[files["masters"], "Text"];
   completionText = If[StringQ[files["completion"]] && FileExistsQ[files["completion"]],
     Import[files["completion"], "Text"], Missing["CompletionLogNotFound"]];
   completionQ = StringQ[completionText] && dsKiraCompletionQ[completionText, OptionValue[KiraCompletionPatterns]];
   If[! TrueQ[completionQ],
    dsWarningPrint["Kira 日志未确认成功完成；将以 reduction、targets、masters、映射和系数域的结构闭合作为硬边界。 The Kira log does not confirm successful completion; structural reduction, target, master, map, and coefficient-domain closure remains authoritative."]
    ];
   If[! AssociationQ[manifest] || ! dsRuleListQ[repJ2Kira] || ! dsRuleListQ[repKira2J] || ! dsRuleListQ[reductionRulesBackend],
    Message[DSKiraImport::invalid, "malformed manifest/map/reduction expression"]; dsErrorPrint["Kira 文件不是预期的 Wolfram 表达式。 The Kira files are not the expected Wolfram expressions."]; Return[<|"status" -> "failed", "reason" -> "malformedExpressions", "workspace" -> workspace|>]
    ];
   coefficientVariableMap = Lookup[manifest, "coefficientVariableMap", {}];
   backendImaginaryUnit = Lookup[manifest, "backendImaginaryUnit", None];
   reductionRulesRaw = dsKiraRestoreBackendCoefficients[
     reductionRulesBackend,
     coefficientVariableMap,
     backendImaginaryUnit
     ];
   backendEnergyConvention = Lookup[manifest, "backendEnergyConvention", <|"status" -> "notRequired"|>];
   backendEnergyConventionQ = AssociationQ[backendEnergyConvention] &&
     dsKiraBackendEnergyConventionDataQ[backendEnergyConvention];
   If[backendEnergyConventionQ,
    reductionRulesRaw = dsKiraRestorePhysicalEnergyVariables[reductionRulesRaw, backendEnergyConvention]
    ];
   gaussianPhaseGauge = Lookup[manifest, "gaussianPhaseGauge", <|"status" -> "notApplicable"|>];
   gaussianPhaseGaugeQ = AssociationQ[gaussianPhaseGauge] &&
     dsKiraGaussianPhaseGaugeDataQ[gaussianPhaseGauge, Lookup[manifest, "integralCount", -1]];
   If[gaussianPhaseGaugeQ,
    reductionRulesRaw = dsKiraRestorePhysicalPhaseGauge[reductionRulesRaw, gaussianPhaseGauge]
    ];
   mapQ = dsKiraInverseMapQ[repJ2Kira, repKira2J];
   manifestMapQ = SortBy[dsJToIDPairs[Lookup[manifest, "integralRules", {}]], Last] === SortBy[dsJToIDPairs[repJ2Kira], Last];
   contextQ = dsKiraContextMatchQ[manifest, resolved];
   artifactIdentityQ = dsKiraArtifactIdentityQ[manifest, workspace, repJ2Kira];
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
   activeUserMITokens = If[activeQ,
     Lookup[Lookup[activeData, "userMI", <||>], "activeTokens", activeTokens],
     {}
     ];
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
   diagnostics = <|"completionMarker" -> completionQ|>;
   checks = <|
     "inverseIntegralMaps" -> mapQ,
     "manifestIntegralMap" -> manifestMapQ,
     "contextConventionMatch" -> contextQ,
     "exportArtifactIdentity" -> artifactIdentityQ,
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
     "backendEnergyConventionManifest" -> backendEnergyConventionQ,
     "physicalEnergyVariablesRestored" -> backendEnergyConventionQ,
     "gaussianPhaseGaugeManifest" -> gaussianPhaseGaugeQ,
     "physicalIntegralPhaseRestored" -> gaussianPhaseGaugeQ,
     "coefficientVariablesRecognized" -> coefficientQ
     |>;
   issues = Keys @ Select[checks, ! TrueQ[#] &];
   If[issues =!= {},
    Message[DSKiraImport::mismatch, issues]; dsErrorPrint["Kira 结果未通过同源性/完整性门禁。 The Kira results failed the provenance or completeness gate."]; Return[<|"status" -> "failed", "reason" -> "validationFailed", "workspace" -> workspace, "files" -> files, "validationReport" -> <|"checks" -> checks, "issues" -> issues|>|>]
    ];
   backendMasters = dsKiraBackendMasterObject[#, relationIDs, idToJ] & /@ masterIDs;
   boundaryMasterIDs = Complement[masterIDs, relationIDs];
   boundaryMasters = Lookup[idToJ, boundaryMasterIDs, {}];
   masters = If[activeQ, activeExpressions, backendMasters];
   masterTokens = If[activeQ, activeUserMITokens, masters];
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
    "backendMasterTokens" -> If[activeQ, activeTokens, backendMasters],
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
    "backendEnergyConvention" -> backendEnergyConvention,
    "gaussianPhaseGauge" -> gaussianPhaseGauge,
    "sourceManifest" -> manifest,
    "context" -> resolved,
    "validationReport" -> <|"status" -> "passed", "checks" -> checks,
      "diagnostics" -> diagnostics,
      "warnings" -> If[completionQ, {}, {"completionMarkerMissing"}], "issues" -> {}|>
    |>
   ];

DSKiraImport[root_, context_: Automatic, OptionsPattern[]] := (Message[DSKiraImport::badpath, root]; dsErrorPrint["DSKiraImport 的第一个参数必须是目录字符串。 The first DSKiraImport argument must be a directory string."]; <|"status" -> "failed", "reason" -> "workspaceNotString"|>);

(* ::Package:: *)

(* ::Chapter:: *)
(*018 微分方程构造*)

(* DSDE 只消费经 KiraImport 验证的 reduction data；不会从不完整日志猜测 master 或规则。 *)

Options[DSDE] = {
   OutputDirectory -> None,
   ProgressReporting -> Automatic
   };

DSDE::badreduction = "DSDE 只接受 DSKiraImport 验证通过的 reductionData。";
DSDE::badvars = "微分变量必须是当前 family 初始化的外部独立变量：`1`。";
DSDE::writefailed = "DE 结果写入失败：`1`。";


(* ::Section::Closed:: *)
(*Kira 内部能量坐标的微分接口*)

(* DSDE 的公开矩阵仍表示物理 D_k。这里同时给出直接 backend 坐标的
   D_ik=-I D_k 结果，并保存 D_k=I D_ik 与 Euler 不变量供 scaling 审计。 *)
dsDEBackendEnergyDerivativeView[matrices_Association, sources_Association, variables_List, convention_Association] := Module[
   {records, activeRecords, backendVariables, backendMatrices, backendSources},
   If[Lookup[convention, "status", "notRequired"] =!= "configured",
    Return[<|"status" -> "notRequired", "scope" -> "KiraBackendOnly"|>]
    ];
   records = Lookup[convention, "records", {}];
   activeRecords = Select[records, MemberQ[variables, Lookup[#, "physical"]] &];
   backendVariables = Lookup[activeRecords, "backend", {}];
   backendMatrices = AssociationThread[
     backendVariables,
     (-I Lookup[matrices, Lookup[#, "physical"]]) & /@ activeRecords
     ];
   backendSources = AssociationThread[
     backendVariables,
     (-I Lookup[sources, Lookup[#, "physical"]]) & /@ activeRecords
     ];
   <|
    "status" -> If[activeRecords === {}, "notRequired", "generated"],
    "scope" -> "KiraBackendOnly",
    "backendVariables" -> backendVariables,
    "matrices" -> backendMatrices,
    "sources" -> backendSources,
    "backendFromPhysicalDerivativeFactor" -> -I,
    "physicalFromBackendDerivativeFactor" -> I,
    "ordinaryDerivativeConvention" -> "D[physicalEnergy] == I D[backendEnergy]",
    "eulerConvention" -> "physicalEnergy D[physicalEnergy] == backendEnergy D[backendEnergy]",
    "records" -> activeRecords
    |>
   ];

dsSectorTopologyForIntegral[int_J, context_Association] := Module[{metadata, matches, shrunk},
   metadata = context["sectors"];
   matches = Select[metadata, integralMatchesSectorMetadataQ[int, #] &];
   If[Length[matches] =!= 1, Return[$Failed]];
   shrunk = Lookup[First[matches], "sectorShrunkLines", {}];
   If[shrunk === {}, context["topology"], shrinkSectorTopology[context["topology"], shrunk]]
   ];

(* DSKiraImport 已验证每条 reduction 的右端只含 masters，因此一次替换就是完整约化；
   若外部结果违反该合同，后续 residual gate 会拒绝 DE，而不是用任意迭代次数掩盖问题。 *)
dsReduceExpression[expr_, rules_List] := Expand[expr /. rules];

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

dsDEVariableData[variable_, masterDefinitions_List, masterTokens_List, rules_List, parameterRules_List, context_Association, progress_] := Module[
   {raw, reduced, decompositions},
   raw = dsProgressMap[
     "正在构造 " <> ToString[variable, InputForm] <> " 导数 / Building " <> ToString[variable, InputForm] <> " derivatives",
     masterDefinitions,
     Function[master, dsSectorAwareDerivative[master, variable, context] /. parameterRules],
     progress
     ];
   If[MemberQ[raw, $Failed], Return[<|"status" -> "failed", "variable" -> variable, "reason" -> "dsFailed", "rawDerivatives" -> raw|>]];
   reduced = dsProgressMap[
     "正在约化 " <> ToString[variable, InputForm] <> " 导数 / Reducing " <> ToString[variable, InputForm] <> " derivatives",
     raw,
     Function[expr, dsReduceExpression[expr, rules]],
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
   {context, masters, masterTokens, rules, resolvedVariables, allowedVariables, badVariables,
    sourceManifest, kiraPlan, postDerivativeRules, physicalPostDerivativeRules, parameterRules, variableRecords,
    variableData, status, matrices, sources, backendEnergyConvention, backendDerivativeView,
    result, outputDirectory = OptionValue[OutputDirectory], writeResult},
   If[Lookup[reductionData, "status", "missing"] =!= "imported" ||
     Lookup[Lookup[reductionData, "validationReport", <||>], "status", "missing"] =!= "passed",
    Message[DSDE::badreduction]; dsErrorPrint["reductionData 未经 DSKiraImport 完整验证。 reductionData has not passed complete DSKiraImport validation."]; Return[<|"status" -> "failed", "reason" -> "unvalidatedReductionData"|>]
    ];
   context = Lookup[reductionData, "context", Missing["context"]];
   If[! dsContextQ[context], Message[DSDE::badreduction]; Return[<|"status" -> "failed", "reason" -> "missingContext"|>]];
   If[! dsContextCapabilityQ[context, "derivativeUsableQ"],
    Message[DSDE::badreduction];
    dsErrorPrint["当前参数声明不支持唯一微分算符。 The current parameter declaration does not define unique differential operators."]; Return[<|
      "status" -> "failed", "reason" -> "derivativeCapabilityGate",
      "capabilities" -> dsContextCapabilities[context]
      |>]
    ];
   masters = reductionData["masters"];
   masterTokens = Lookup[reductionData, "masterTokens", masters];
   If[! ListQ[masters] || ! ListQ[masterTokens] || Length[masters] =!= Length[masterTokens] || masters === {},
    Message[DSDE::badreduction]; Return[<|"status" -> "failed", "reason" -> "invalidMasterDefinitionsOrTokens"|>]
    ];
   rules = reductionData["reductionRules"];
   sourceManifest = Lookup[reductionData, "sourceManifest", <||>];
   kiraPlan = Lookup[sourceManifest, "kiraPlan", <||>];
   postDerivativeRules = If[
     Lookup[kiraPlan, "numericStage", "symbolic"] === "postDerivative",
     Lookup[kiraPlan, "coefficientRules", {}],
     {}
     ];
   physicalPostDerivativeRules = If[postDerivativeRules === {},
     {},
     Lookup[sourceManifest, "physicalCoefficientRulesApplied", postDerivativeRules]
     ];
   (* fixed-rational export 在解析导数 closure 冻结后才数值化；DSDE 必须把同一规则
      同时用于内部原子和公开坐标，否则 h EOM 或系数乘积法则会重新引入参数。 *)
   parameterRules = DeleteDuplicatesBy[
     Join[
      If[ListQ[physicalPostDerivativeRules],
       normalizeCoefficientRulesForTopology[physicalPostDerivativeRules, context["topology"]], {}],
      If[ListQ[physicalPostDerivativeRules], physicalPostDerivativeRules, {}]
      ],
     First
     ];
   resolvedVariables = dsDEResolveVariables[variables, context];
   allowedVariables = dsDEResolveVariables[Automatic, context];
   badVariables = Complement[resolvedVariables, allowedVariables];
   If[badVariables =!= {},
    Message[DSDE::badvars, badVariables]; dsErrorPrint["DSDE 变量不属于当前 family 的外部表示。 The DSDE variables are not external coordinates of the current family."]; Return[<|"status" -> "failed", "reason" -> "invalidVariables", "badVariables" -> badVariables, "allowedVariables" -> allowedVariables|>]
    ];
   variableRecords = dsProgressMap[
     "正在生成微分方程 / Building differential equations",
     resolvedVariables,
     Function[variable, dsDEVariableData[variable, masters, masterTokens, rules, parameterRules, context, OptionValue[ProgressReporting]]],
     OptionValue[ProgressReporting]
     ];
   variableData = AssociationThread[resolvedVariables, variableRecords];
   status = Which[
     AnyTrue[variableRecords, Lookup[#, "status", "failed"] === "failed" &], "failed",
     AnyTrue[variableRecords, Lookup[#, "status", "notClosed"] === "notClosed" &], "notClosed",
     True, "generated"
     ];
   matrices = AssociationThread[resolvedVariables, Lookup[variableRecords, "matrix", {}]];
   sources = AssociationThread[resolvedVariables, Lookup[variableRecords, "source", {}]];
   backendEnergyConvention = Lookup[sourceManifest, "backendEnergyConvention", <|"status" -> "notRequired"|>];
   backendDerivativeView = dsDEBackendEnergyDerivativeView[
     matrices,
     sources,
     resolvedVariables,
     backendEnergyConvention
     ];
   result = <|
     "status" -> status,
     "masters" -> masters,
     "masterTokens" -> masterTokens,
     "masterCount" -> Length[masters],
     "variables" -> resolvedVariables,
     "matrices" -> matrices,
     "sources" -> sources,
     "backendEnergyDerivativeView" -> backendDerivativeView,
     "residualIntegrals" -> AssociationThread[resolvedVariables, Lookup[variableRecords, "residualIntegrals", {}]],
     "residualBackendTokens" -> AssociationThread[resolvedVariables, Lookup[variableRecords, "residualBackendTokens", {}]],
     "residualObjects" -> AssociationThread[resolvedVariables, Lookup[variableRecords, "residualObjects", {}]],
     "variableData" -> variableData,
     "sourceManifest" -> reductionData["sourceManifest"],
     "activeBasis" -> Lookup[reductionData, "activeBasis", <|"status" -> "disabled", "count" -> 0|>],
     "parameterRulesApplied" -> parameterRules,
     "postDerivativeRulesApplied" -> postDerivativeRules,
     "physicalPostDerivativeRulesApplied" -> physicalPostDerivativeRules,
     "context" -> context,
     "equationConvention" -> "D[masters,var] == matrices[var].masters + sources[var]",
     "reductionValidationReport" -> reductionData["validationReport"]
     |>;
   writeResult = If[StringQ[outputDirectory], dsWriteDEResult[result, ExpandFileName[outputDirectory]], <|"status" -> "notRequested"|>];
   If[Lookup[writeResult, "status", "failed"] === "failed", Message[DSDE::writefailed, outputDirectory]; dsErrorPrint["DE 文件未写出。 DE files were not written."]];
   Join[result, <|"writeResult" -> writeResult|>]
   ];

DSDE[reductionData_, variables_: Automatic, OptionsPattern[]] := (Message[DSDE::badreduction]; dsErrorPrint["DSDE 输入必须是 reductionData Association。 DSDE input must be a reductionData Association."]; <|"status" -> "failed", "reason" -> "inputNotAssociation"|>);


(* ::Chapter:: *)
(*Naive tree IBP 微分方程*)

(* tree 原生导数直接作用于 Exp[I k0_v tau_v] 与 h building block。
   tree J 使用统一的 (-tau)^a convention，故顶点相位贡献为
   +I D[k0_v,x] J[...,a_v+1,...]；contact 合并不再另乘 (-1)^Delta a。
   sector master 的 normalization N 最后另按乘积法则求导。 *)

Options[DSTreeNaiveDE] = {AuditLevel -> "standard", ProgressReporting -> Automatic};

DSTreeNaiveDE::badibp = "DSTreeNaiveDE 需要 DSTreeNaiveIBP 成功返回的数据或合法 DSInit context。";
DSTreeNaiveDE::badvars = "tree 微分变量必须是当前 family 初始化的外部独立变量：`1`。";


dsTreeZeroTokenTerms[expr_] := If[TrueQ[Expand[expr] === 0], {}, dsTreeTokenTerms[expr]];


dsTreeLineMomentumMagnitudeDerivative[int_J, variable_, family_Association] := Module[
   {packs = First[int], terms = {}, vertex, leg, magnitudeDerivative, state, newPacks, shiftedIntegral},
   Do[
    vertex = family["vertices"][[vertexIndex]];
    Do[
     leg = vertex["massiveLegs"][[legIndex]];
     magnitudeDerivative = D[leg["momentumMagnitude"], variable];
     If[! TrueQ[magnitudeDerivative === 0],
      state = packs[[vertexIndex, 1 + legIndex]];
      If[! MemberQ[{0, 1}, state], Return[$Failed]];
      newPacks = ReplacePart[packs, {vertexIndex, 1} -> packs[[vertexIndex, 1]] + 1];
      newPacks = ReplacePart[newPacks, {vertexIndex, 1 + legIndex} -> 1 - state];
      shiftedIntegral = J[newPacks];
      AppendTo[terms,
        magnitudeDerivative If[
         state === 0,
         -dsTreeToken[family["sector"], shiftedIntegral],
         dsTreeToken[family["sector"], shiftedIntegral] -
          (2 leg["nu"] + 1)/leg["momentumMagnitude"] dsTreeToken[family["sector"], int]
         ]
       ]
      ],
     {legIndex, Length[vertex["massiveLegs"]]}
     ],
    {vertexIndex, Length[family["vertices"]]}
    ];
   Expand[Total[terms]]
   ];


(* 旧 loop 投影只保留为正式 check 的单向 oracle，不再被 018 生产 DE 调用。 *)
dsTreePhaseDerivativeProjectionOracle[loopIntegral_J, variable_, family_Association, rootTopology_Association] := Module[
   {internalVariable, loopDerivative, projectedData, expression},
   internalVariable = scalarProductInputToInternal[variable, family["topology"]];
   loopDerivative = directExternalLegEnergyVariableDerivativeSeed[family["topology"], loopIntegral, internalVariable];
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


dsTreePhaseDerivativeDirect[int_J, variable_, family_Association, rootTopology_Association] := Module[
   {packs = First[int], terms, publicEnergy, derivative, shiftedPacks, shiftedIntegral},
   terms = Table[
     publicEnergy = scalarProductInternalToUser[family["vertices"][[vertexIndex, "signedExternalLegEnergy"]], rootTopology];
     derivative = D[publicEnergy, variable];
     If[TrueQ[derivative === 0],
      0,
      shiftedPacks = ReplacePart[packs, {vertexIndex, 1} -> packs[[vertexIndex, 1]] + 1];
      shiftedIntegral = J[shiftedPacks];
      I derivative dsTreeToken[family["sector"], shiftedIntegral]
      ],
     {vertexIndex, Length[family["vertices"]]}
     ];
   <|
    "status" -> "generated",
    "generationRoute" -> "directTreePhase",
    "terms" -> dsTreeZeroTokenTerms[Expand[Total[terms]]],
    "internalExpression" -> Expand[Total[terms]]
    |>
   ];


dsTreeNaiveAllowedVariables[context_Association, familyContext_Association] := DeleteDuplicates@Join[
   dsDEResolveVariables[Automatic, context],
   Variables[Cases[
     familyContext["families"],
     leg_Association /; KeyExistsQ[leg, "nu"] && KeyExistsQ[leg, "momentumMagnitude"] :> leg["momentumMagnitude"],
     Infinity
     ]]
   ];


dsTreeNaiveMasterDerivative[master_Association, variable_, familyContext_Association, context_Association] := Module[
   {family, rootTopology, phaseData, lineDerivative, bareToken, bareDerivative,
    physicalRecord, physicalLogDerivative, normalizedDerivative, publicTerms},
   family = dsTreeFamilyBySector[master["sectorKey"], familyContext];
   If[Head[family] === Missing, Return[<|"status" -> "failed", "reason" -> "unknownSector"|>]];
   rootTopology = context["topology"];
   phaseData = dsTreePhaseDerivativeDirect[master["integral"], variable, family, rootTopology];
   If[Lookup[phaseData, "status", "failed"] =!= "generated", Return[phaseData]];
   lineDerivative = dsTreeLineMomentumMagnitudeDerivative[master["integral"], variable, family];
   If[lineDerivative === $Failed, Return[<|"status" -> "failed", "reason" -> "lineMomentumMagnitudeDerivativeFailed"|>]];
   physicalRecord = sectorPrefactorRecordForKey018[context, master["sectorKey"]];
   If[! AssociationQ[physicalRecord],
    Return[<|"status" -> "failed", "reason" -> "physicalSectorPrefactorMissing",
      "sectorKey" -> master["sectorKey"], "record" -> physicalRecord|>]
    ];
   physicalLogDerivative = sectorPrefactorLogDerivative018[
     <|"sectorPrefactorData" -> physicalRecord["physicalSectorPrefactorData"]|>,
     variable
     ];
   If[physicalLogDerivative === $Failed,
    Return[<|"status" -> "failed", "reason" -> "physicalSectorPrefactorDerivativeFailed",
      "sectorKey" -> master["sectorKey"], "variable" -> variable|>]
    ];
   bareToken = dsTreeToken[master["sectorKey"], master["integral"]];
   bareDerivative = Expand[
     phaseData["internalExpression"] + lineDerivative + physicalLogDerivative bareToken
     ];
   normalizedDerivative = Expand[
      D[master["coefficient"], variable] bareToken + master["coefficient"] bareDerivative
     ];
   publicTerms = dsTreeZeroTokenTerms[normalizedDerivative];
   <|
    "status" -> If[publicTerms === $Failed, "failed", "generated"],
    "master" -> master,
    "variable" -> variable,
    "phaseDerivativeRoute" -> phaseData["generationRoute"],
    "directPhaseDerivativeTerms" -> phaseData["terms"],
    "lineMomentumMagnitudeDerivativeTerms" -> dsTreeZeroTokenTerms[lineDerivative],
    "selectorCoefficientDerivative" -> D[master["coefficient"], variable],
    "physicalSectorPrefactorLogDerivative" -> physicalLogDerivative,
    "completeNormalizationLogDerivative" -> Cancel[
      D[master["coefficient"], variable]/master["coefficient"] + physicalLogDerivative
      ],
    "rawTerms" -> publicTerms,
    "internalExpression" -> normalizedDerivative
    |>
   ];


dsTreeNaiveVariableData[variable_, ibpData_Association, familyContext_Association, context_Association, progress_] := Module[
   {masters, derivativeRecords, rules, reduced, masterTokens, coefficientTokens, normalizedMasterRules,
    tokenExpressions, coefficients, residuals, residualTokens, rows},
   masters = ibpData["masters"];
   derivativeRecords = dsProgressMap[
     "正在构造 naive tree " <> ToString[variable, InputForm] <> " 导数 / Building naive-tree " <> ToString[variable, InputForm] <> " derivatives",
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
     "正在生成 naive tree 微分方程 / Building naive-tree differential equations",
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
    "derivativeRoute" -> "direct tree phase derivative + direct h line momentum-magnitude derivative -> direct tree dtau reduction",
    "formulaDLogUsedQ" -> False
    |>
   ];


dsTreeNaiveDERaw018[context_Association, variables_: Automatic, masters_: Automatic, OptionsPattern[DSTreeNaiveDE]] /; dsContextQ[context] := Module[
   {ibpData},
   If[treeFormulaMasslessPendingQ018[context],
    Return[treeFormulaPendingRederivation018["DSTreeNaiveDE", context]]
    ];
   ibpData = dsTreeNaiveIBPRaw018[context, masters,
     AuditLevel -> OptionValue[AuditLevel], ProgressReporting -> OptionValue[ProgressReporting]];
   If[Lookup[ibpData, "status", "failed"] =!= "solved", ibpData,
    dsTreeNaiveDEFromIBP[ibpData, variables, ProgressReporting -> OptionValue[ProgressReporting]]]
   ];


DSTreeNaiveDE[_, ___] := (Message[DSTreeNaiveDE::badibp]; <|"status" -> "failed", "reason" -> "invalidContextOrIBPData"|>);

(* ::Package:: *)
(* 本模块从闭合 DE 构造 Euler residual，并按显式次数、通用 loop topology
   或 pure-massive-bubble reference convention 生成 master 的齐次次数。 *)

(* ::Chapter:: *)
(*018 标度关系检查*)

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
   <|"aPowers" -> aPowers, "bPowers" -> bPowers,
    "sectorKey" -> sectorKeyFromShrunkLines[sectorTopo, Lookup[sectorTopo, "sectorShrunkLines", {}]]|>
   ];

dsPureMassiveBubbleDegree[int_J, context_Association] := Module[{powers, vertexCount, offset},
   powers = dsIntegralPhysicalPowers[int, context];
   If[powers === $Failed, Return[$Failed]];
   vertexCount = Length[powers["aPowers"]];
   offset = Switch[vertexCount, 2, 2, 1, 1, _, Return[$Failed]];
   dim - Total[powers["bPowers"]] - Total[powers["aPowers"]] - offset
   ];


(* ::Section::Closed:: *)
(*通用 loop topology 的 normalized J 次数*)

(* ISP 是 loop scalar product，因而每个幂次贡献两个动量次数。time-only 公开 J 必须先经
   唯一边界转换恢复内部 sector 表示；sector prefactor 再从完整 N_s 结构读取。 *)
dsLoopTopologyDegree[
   int_J,
   variables_List,
   weights_List,
   context_Association
   ] := Module[
   {powers, rootTopo, internalInt, ispPowers, loopCount, vertexCount, prefactorData,
     prefactor, prefactorDegree},
   rootTopo = context["topology"];
   internalInt = If[
     Lookup[rootTopo, "ibpMode", "full"] === "timeOnly",
     dsTimeOnlyPublicIntegralToInternal020[int, rootTopo],
     int
     ];
   If[! MatchQ[internalInt, J[_List, _List, _List]], Return[$Failed]];
   ispPowers = internalInt[[3]];
   powers = dsIntegralPhysicalPowers[internalInt, context];
   If[powers === $Failed, Return[$Failed]];
   loopCount = Lookup[rootTopo, "graphLoopCount", Length[Lookup[rootTopo, "loopMomenta", {}]]];
   vertexCount = Length[powers["aPowers"]];
   prefactorData = sectorPrefactorDataForIntegral018[rootTopo, internalInt];
   prefactor = materializeSectorPrefactor018[prefactorData];
   If[prefactor === $Failed || TrueQ[prefactor === 0], Return[$Failed]];
   prefactorDegree = Together[
     Total[MapThread[#1 #2 D[prefactor, #2] &, {weights, variables}]]/prefactor
     ];
   If[! And @@ (dsScaleZeroQ[D[prefactorDegree, #]] & /@ variables), Return[$Failed]];
   Together[
    loopCount dim - Total[powers["bPowers"]] - Total[powers["aPowers"]] -
     vertexCount + 2 Total[ispPowers] + prefactorDegree
    ]
   ];


dsLoopTopologyExpressionDegree[
   expr_,
   variables_List,
   weights_List,
   context_Association
   ] := Module[
   {linearData, termDegrees, coefficientDegree, integralDegree, referenceDegree},
   linearData = publicLinearIntegralDecomposition[expr];
   If[
    Lookup[linearData, "status", "failed"] =!= "linear" ||
     ! TrueQ[linearData["constantTerm"] === 0],
    Return[$Failed]
    ];
   termDegrees = MapThread[
     Function[{coefficient, int},
      If[
       TrueQ[coefficient === 0],
       Nothing,
       coefficientDegree = Together[
         Total[MapThread[#1 #2 D[coefficient, #2] &, {weights, variables}]]/coefficient
         ];
       integralDegree = dsLoopTopologyDegree[int, variables, weights, context];
       If[
        integralDegree === $Failed ||
         ! And @@ (dsScaleZeroQ[D[coefficientDegree, #]] & /@ variables),
        $Failed,
        Together[coefficientDegree + integralDegree]
        ]
       ]
      ],
     {linearData["coefficients"], linearData["integrals"]}
     ];
   If[termDegrees === {} || MemberQ[termDegrees, $Failed], Return[$Failed]];
   referenceDegree = First[termDegrees];
   If[
    And @@ (dsScaleZeroQ[# - referenceDegree] & /@ Rest[termDegrees]),
    referenceDegree,
    $Failed
    ]
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
    declaredDegrees, sourceManifest, kiraPlan, postDerivativeRules, physicalPostDerivativeRules, degreeRules,
    evaluationRules, evaluatedVariables, eulerMatrix, eulerSource, matrixResidual,
    sourceResidual, checks, status},
   If[Lookup[deData, "status", "missing"] =!= "generated",
    Message[DSScaleCheck::badde]; dsErrorPrint["DE 尚未闭合，不能宣称标度检查通过。 The DE is not closed, so the scaling check cannot be reported as passed."]; Return[<|"status" -> "failed", "reason" -> "deNotGenerated"|>]
    ];
   relation = Lookup[spec, "relation", OptionValue[ScalingRelation]];
   variables = Replace[Lookup[spec, "variables", OptionValue[ScalingVariables]], Automatic -> deData["variables"]];
   weights = Replace[Lookup[spec, "weights", OptionValue[ScalingWeights]], Automatic -> ConstantArray[1, Length[variables]]];
   masters = deData["masters"];
   context = deData["context"];
   declaredDegrees = Lookup[Lookup[deData, "activeBasis", <||>], "scalingDegrees", Automatic];
   sourceManifest = Lookup[deData, "sourceManifest", <||>];
   kiraPlan = Lookup[sourceManifest, "kiraPlan", <||>];
   postDerivativeRules = If[
     Lookup[kiraPlan, "numericStage", "symbolic"] === "postDerivative",
     Lookup[kiraPlan, "coefficientRules", {}],
     {}
     ];
   physicalPostDerivativeRules = If[postDerivativeRules === {},
     {},
     Lookup[sourceManifest, "physicalCoefficientRulesApplied", postDerivativeRules]
     ];
   degrees = Replace[
     Lookup[spec, "degrees", OptionValue[ScalingDegrees]],
     Automatic :> Which[
       ListQ[declaredDegrees], declaredDegrees,
       relation === "PureMassiveBubble", dsPureMassiveBubbleExpressionDegree[#, variables, weights, context] & /@ masters,
       relation === "LoopTopology", dsLoopTopologyExpressionDegree[#, variables, weights, context] & /@ masters,
       True, $Failed
       ]
     ];
   (* post-derivative 的物理系数规则必须进入齐次次数；DE 变量自身始终保留为符号。 *)
   degreeRules = If[ListQ[physicalPostDerivativeRules], physicalPostDerivativeRules, {}];
   If[ListQ[degrees], degrees = degrees /. degreeRules];
   If[! ListQ[variables] || ! ListQ[weights] || Length[variables] =!= Length[weights] ||
     ! ListQ[degrees] || Length[degrees] =!= Length[masters] || MemberQ[degrees, $Failed],
    Message[DSScaleCheck::badspec, <|"relation" -> relation, "variables" -> variables, "weights" -> weights, "degrees" -> degrees|>];
    dsErrorPrint["标度检查规格无效。 The scaling-check specification is invalid."]; Return[<|"status" -> "failed", "reason" -> "invalidScalingSpecification"|>]
    ];
   matrices = deData["matrices"];
   sources = deData["sources"];
   missingVariables = Select[variables, ! KeyExistsQ[matrices, #] &];
   If[missingVariables =!= {},
    Message[DSScaleCheck::badspec, missingVariables]; dsErrorPrint["DE 缺少 Euler 算符所需变量。 The DE lacks variables required by the Euler operator."]; Return[<|"status" -> "failed", "reason" -> "missingDEVariables", "missingVariables" -> missingVariables|>]
    ];
   evaluationRules = If[ListQ[physicalPostDerivativeRules], physicalPostDerivativeRules, {}];
   evaluatedVariables = variables /. evaluationRules;
   eulerMatrix = Total[MapThread[#1 #2 matrices[#3] &, {weights, evaluatedVariables, variables}]];
   eulerSource = Total[MapThread[#1 #2 sources[#3] &, {weights, evaluatedVariables, variables}]];
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
    "evaluatedVariables" -> evaluatedVariables,
    "evaluationPointRules" -> evaluationRules,
    "degrees" -> degrees,
    "eulerMatrix" -> eulerMatrix,
    "eulerSource" -> eulerSource,
    "matrixResidual" -> matrixResidual,
    "sourceResidual" -> sourceResidual,
    "checks" -> checks,
    "symbolicQ" -> (evaluationRules === {})
    |>
   ];

DSScaleCheck[deData_, spec_: <||>, OptionsPattern[]] := (Message[DSScaleCheck::badde]; dsErrorPrint["DSScaleCheck 输入必须是 DE Association。 DSScaleCheck input must be a DE Association."]; <|"status" -> "failed", "reason" -> "inputNotAssociation"|>);

(* ::Package:: *)

(* ::Chapter:: *)
(*018 tree vertex-family Private 公式内核*)

(* 013 的 vertex-family 公式在冻结核心中；本模块只增加 DSInit context 适配，不复制递推公式。 *)

(* 从 root topology 统一建立 sector family，并给每个 family 保存同一个 root 引用。
   direct seed、tagged 迭代和 raw 迭代共用这一个构造，避免回退到旧 loop 投影。 *)
dsTreeFamilyContextFromRootTopology[rootTopology_Association] := Module[{familyContext, families},
   familyContext = makeTreeSectorFamilies[rootTopology];
   If[familyContext === $Failed, Return[$Failed]];
   families = Join[#, <|"rootTopology" -> rootTopology|>] & /@ familyContext["families"];
   Join[familyContext, <|"families" -> families, "topFamily" -> First[families]|>]
   ];


dsTreeFamilyContext[context_Association] /; dsContextQ[context] :=
   dsTreeFamilyContextFromRootTopology[context["topology"]];


(* raw J[vertexPacks] 的 source-aware 首步复用 sector-tagged direct seed，再仅在公开 raw
   返回边界去掉 sector token。这样传播子动量模长与共同-theta contact 都保持同源。 *)
treeSourceAwareStepFromTopology[
   int_J, vertexIndex_Integer, endpoint_Integer, data_Association
   ] /; AssociationQ[Lookup[data, "rootTopology", Missing["NoRootTopology"]]] := Module[
   {familyContext, token, taggedResult},
   familyContext = dsTreeFamilyContextFromRootTopology[data["rootTopology"]];
   If[familyContext === $Failed, Return[$Failed]];
   token = dsTreeToken[data["sector"], int];
   taggedResult = dsTreeTaggedSourceAwareStep[token, vertexIndex, endpoint, data, familyContext];
   If[taggedResult === $Failed, Return[$Failed]];
   taggedResult /. dsTreeToken[_, item_J] :> item
   ];


(* 018 的公开 tree overload 统一在 PublicBoundary018.wl 定义。这里仅保留 Private
   vertex-basis 内核，避免用户绕过三参数 J 的 sector 身份与表示审计。 *)


(* ::Chapter:: *)
(*多 sector dlog 数据汇总*)

(* 每个 sector 的对角块仍由 vertex-family 公式构造；非对角块从 loop dtau 的 tagged contact source 提取，
   因而共同 theta、多线 simultaneous contact 和 mixed-sign 禁用规则只在既有 loop 边界层出现一次。 *)

(* p=0 的 terminal contact vertex 没有 massive leg；空能量表必须是 {}，不能让 Lookup 产生 Missing。 *)
treeVertexDLogData[vertex_Association] := Module[
   {p, states, momentumMagnitudes, k0, omega0, omegaEx, tp, tpInv, m1, omega, letters, coeffs},
   p = vertex["p"];
   states = treeBinaryStates[p];
   momentumMagnitudes = If[vertex["massiveLegs"] === {}, {}, Lookup[vertex["massiveLegs"], "momentumMagnitude"]];
   k0 = vertex["signedExternalLegEnergy"];
   omega0 = -I DiagonalMatrix[Table[
      Log[k0 + Sum[(2 states[[row, i]] - 1) momentumMagnitudes[[i]], {i, p}]],
      {row, Length[states]}
      ]];
   omegaEx = DiagonalMatrix[Table[
     -Sum[states[[row, i]] (2 vertex["massiveLegs"][[i, "nu"]] + 1) Log[momentumMagnitudes[[i]]], {i, p}],
     {row, Length[states]}
     ]];
   tp = treeTp[vertex];
   tpInv = treeTpInverse[vertex];
   m1 = treeM1[vertex, vertex["nu0"] + 1];
   omega = Expand[omegaEx - I tpInv . omega0 . tp . m1];
   letters = DeleteDuplicates@Join[momentumMagnitudes, Cases[omega0, Log[arg_] :> arg, Infinity]];
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
   {sourceSector = family["sector"], familyContext, rowsByVertex, vertexIndex, seedMaster, record, linearData, terms,
    sourceData, reducedSource},
   familyContext = dsTreeFamilyContext[context];
   If[familyContext === $Failed, Return[<|"status" -> "error", "reason" -> "treeFamilyInitializationFailed"|>]];
   rowsByVertex = Association@Table[
      vertexIndex = First@FirstPosition[family["vertexOrder"], vertexId];
      vertexId -> Table[
        (* dlog source 来自 f^(1) 的约化，即论文 Eq. (3.67) 中 R^(1)；binary state 不变。 *)
        seedMaster = J[ReplacePart[
           First[masters[[row]]],
           vertexIndex -> ReplacePart[First[masters[[row]]][[vertexIndex]], 1 -> 1]
           ]];
        record = dsDirectTreeSeedRecord[vertexId, seedMaster, family, familyContext];
        If[! AssociationQ[record] || Lookup[record, "status", "error"] =!= "generated",
         Return[<|"status" -> "error", "reason" -> "contactSeedGenerationFailed",
           "sectorKey" -> sourceSector, "vertex" -> vertexId, "row" -> row, "record" -> record|>]
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
          dsRepIterativeTreeLinearData[sourceData, Automatic, context]
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


(* contact selector 把各 lower sector 的入边化为常矩阵；物理 sector prefactor 另由
   sector metadata 保存。两层不能混名，否则容易在 DE 中漏掉或重复连续零点幂。 *)
dsTreeDLogSelectorCoefficients[sectorOrder_List, contactData_List, families_List] := Module[
   {transitions, selectorCoefficients = <|First[sectorOrder] -> 1|>, audits = {}, energyExpressions, energyVariables,
    child, candidates, chosen, selectorCoefficient, ratios, nonconstant},
   transitions = dsTreeContactTransitions[contactData];
   energyExpressions = Flatten[Cases[
      families,
      vertex_Association /; KeyExistsQ[vertex, "signedExternalLegEnergy"] :>
       Join[{vertex["signedExternalLegEnergy"]}, Lookup[vertex["massiveLegs"], "momentumMagnitude", {}]],
      Infinity
      ]];
   energyVariables = DeleteDuplicates[Variables[energyExpressions]];
   Do[
    child = sectorOrder[[index]];
    candidates = Select[transitions,
      Lookup[#, "targetSector", None] === child &&
        KeyExistsQ[selectorCoefficients, Lookup[#, "sourceSector", None]] &];
    If[candidates === {},
     Return[<|"status" -> "error", "reason" -> "selectorSourceMissing", "sectorKey" -> child|>]
     ];
    chosen = First[candidates];
    selectorCoefficient = Expand[
      selectorCoefficients[chosen["sourceSector"]] chosen["coefficient"]
      ];
    AssociateTo[selectorCoefficients, child -> selectorCoefficient];
    ratios = Map[
      Function[item,
       Join[item, <|"normalizedCoefficient" -> Together[
           selectorCoefficients[item["sourceSector"]] item["coefficient"]/selectorCoefficient
           ]|>]
       ],
      candidates
      ];
    nonconstant = If[energyVariables === {}, {},
      Select[ratios, ! FreeQ[Lookup[#, "normalizedCoefficient"], Alternatives @@ energyVariables] &]
      ];
    AppendTo[audits, <|"sectorKey" -> child, "selectorCoefficient" -> selectorCoefficient,
      "chosenTransition" -> chosen, "incomingTransitions" -> ratios,
      "energyIndependentRatiosQ" -> (nonconstant === {}), "nonconstantRatios" -> nonconstant|>];
    If[nonconstant =!= {},
     Return[<|"status" -> "error", "reason" -> "nonconstantContactSelector",
       "sectorKey" -> child, "selectorCoefficients" -> selectorCoefficients, "audits" -> audits|>]
     ],
    {index, 2, Length[sectorOrder]}
    ];
   <|"status" -> "generated", "selectorCoefficients" -> selectorCoefficients, "audits" -> audits,
     "energyVariables" -> energyVariables, "transitions" -> transitions|>
   ];


(* 每个 tree master 的完整 normalization 定义为
   selectorCoefficient * physicalSectorPrefactor。前者化简跨 sector contact，后者保存
   Wronskian 连续幂；所有导数路线都从本记录读取二者，禁止再次从 contact 反推。 *)
dsTreeMasterNormalizationRecords[
   sectorOrder_List,
   selectorData_Association,
   context_Association
   ] := Module[{selectorCoefficients, records, physicalRecord, selectorCoefficient},
   selectorCoefficients = Lookup[selectorData, "selectorCoefficients", <||>];
   records = Association@Table[
      physicalRecord = sectorPrefactorRecordForKey018[context, sectorKey];
      If[! AssociationQ[physicalRecord],
       Return[<|"status" -> "error", "reason" -> "physicalSectorPrefactorMissing",
         "sectorKey" -> sectorKey, "record" -> physicalRecord|>]
       ];
      selectorCoefficient = Lookup[
        selectorCoefficients,
        sectorKey,
        Missing["NoSelectorCoefficient", sectorKey]
        ];
      If[Head[selectorCoefficient] === Missing,
       Return[<|"status" -> "error", "reason" -> "selectorCoefficientMissing",
         "sectorKey" -> sectorKey|>]
       ];
      sectorKey -> Join[
        <|
         "sectorKey" -> sectorKey,
         "selectorCoefficient" -> selectorCoefficient
         |>,
        physicalRecord,
        <|
         "completeNormalization" -> Expand[
           selectorCoefficient physicalRecord["physicalSectorPrefactor"]
           ],
         "normalizationConvention" ->
          "master = selectorCoefficient * normalized J; normalized J = physicalSectorPrefactor * bare integral"
         |>
        ],
      {sectorKey, sectorOrder}
      ];
   <|"status" -> "generated", "records" -> records|>
   ];


(* ::Section::Closed:: *)
(*Block-triangular primitive connection*)

dsTreeVertexSourcePrimitive[vertex_Association] := Module[{states, momentumMagnitudes, cuts},
   states = treeBinaryStates[vertex["p"]];
   momentumMagnitudes = If[vertex["massiveLegs"] === {}, {}, Lookup[vertex["massiveLegs"], "momentumMagnitude"]];
   cuts = Table[
     vertex["signedExternalLegEnergy"] + Sum[(2 states[[row, i]] - 1) momentumMagnitudes[[i]], {i, vertex["p"]}],
     {row, Length[states]}
     ];
   treeTpInverse[vertex] . (-I DiagonalMatrix[Log /@ cuts]) . treeTp[vertex]
   ];


dsTreeAssembleConnection[
   blocks_List,
   families_List,
   sectorOrder_List,
   contactData_List,
   normalizationRecords_Association
   ] := Module[{dimensions, sectorPositions, selectorCoefficients, completeNormalizations,
    omegaBlocks, sourceIndex, targetIndex,
    sourceFamily, vertexIndex, sourcePrimitive, rawMatrix, normalizedMatrix, normalizedContactData},
   dimensions = Lookup[blocks, "masterCount"];
   sectorPositions = AssociationThread[sectorOrder -> Range[Length[sectorOrder]]];
   selectorCoefficients = AssociationMap[
     Lookup[normalizationRecords[#], "selectorCoefficient"] &,
     sectorOrder
     ];
   completeNormalizations = AssociationMap[
     Lookup[normalizationRecords[#], "completeNormalization"] &,
     sectorOrder
     ];
   omegaBlocks = Table[
     If[i === j,
      Expand[
       blocks[[i, "omega"]] +
        Log[completeNormalizations[sectorOrder[[i]]]] IdentityMatrix[dimensions[[i]]]
       ],
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
                  selectorCoefficients[sourceData["sectorKey"]]/
                   selectorCoefficients[targetSector] rawMatrix
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


dsTreeMultiSectorDLog[context_Association, seedData_: Automatic, auditLevel_: "standard"] := Module[
   {familyContext, families, sectorOrder, blocks, dimensions, masterLists, contactRows, contactData,
    selectorData, normalizationData, normalizationRecords, assembled, completeNormalizations,
    letters, omega, letterMatrices, offsets, taggedMasters,
    bareMasters, dlogResidual, sourceEquations},
   familyContext = dsTreeFamilyContext[context];
   If[familyContext === $Failed, Return[<|"status" -> "error", "reason" -> "treeFamilyInitializationFailed"|>]];
   families = familyContext["families"];
   sectorOrder = familyContext["sectorOrder"];
   blocks = dsTreeDLogBlock018 /@ families;
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
   selectorData = dsTreeDLogSelectorCoefficients[sectorOrder, contactData, families];
   If[Lookup[selectorData, "status", "error"] =!= "generated",
    Return[Join[<|"status" -> "error", "reason" -> "dlogSelectorFailed"|>, selectorData]]
     ];
   normalizationData = dsTreeMasterNormalizationRecords[sectorOrder, selectorData, context];
   If[Lookup[normalizationData, "status", "error"] =!= "generated",
    Return[Join[<|"status" -> "error", "reason" -> "masterNormalizationFailed"|>, normalizationData]]
    ];
   normalizationRecords = normalizationData["records"];
   assembled = dsTreeAssembleConnection[
     blocks, families, sectorOrder, contactData, normalizationRecords
     ];
   completeNormalizations = AssociationMap[
     Lookup[normalizationRecords[#], "completeNormalization"] &,
     sectorOrder
     ];
   omega = assembled["omega"];
   letters = DeleteDuplicates@Join[
      Flatten[Lookup[blocks, "letters"]],
      DeleteCases[Lookup[completeNormalizations, sectorOrder], 1]
      ];
   letterMatrices = Association@Table[
      letter -> Map[Coefficient[#, Log[letter]] &, omega, {2}],
      {letter, letters}
      ];
   dlogResidual = If[
     auditLevel === "full",
     Expand[omega - Total[MapThread[Log[#1] #2 &, {letters, Values[letterMatrices]}]]],
     Missing["NotRunAtStandardAuditLevel"]
     ];
   offsets = dsTreeMasterSectorOffsets[blocks];
    taggedMasters = Flatten[Map[
      Function[block,
       treeTaggedIntegral[
          block["sector"],
          #,
          normalizationRecords[block["sector"]]["selectorCoefficient"]
          ] & /@ block["masters"]
       ],
      blocks
      ]];
   bareMasters = Lookup[taggedMasters, "integral"];
   sourceEquations = Lookup[contactData, "rowsByVertex"];
   <|
    "status" -> "generated",
    "connectionStructure" -> "sectorDAGBlockTriangular",
    "offDiagonalSourceStatus" -> "assembledFromDirectCompiledTheta",
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
    "auditLevel" -> auditLevel,
    "dlogResidual" -> dlogResidual,
    "dlogQ" -> If[Head[dlogResidual] === Missing, dlogResidual,
      TrueQ[dlogResidual === ConstantArray[0, Dimensions[omega]]]],
    "masterNormalizationRecords" -> normalizationRecords,
    "dlogSelectorCoefficients" -> selectorData["selectorCoefficients"],
    "selectorAudits" -> selectorData["audits"],
    "contactMaps" -> assembled["normalizedContactData"],
    "omegaBlocks" -> assembled["omegaBlocks"],
    "sourceEquations" -> sourceEquations,
    "inputSourceData" -> seedData,
    "sourceConvention" -> "Eq. (3.66)-(3.68): -I T^-1 Omega0 T times direct compiled-WT contact selector"
    |>
   ];


(* DSTreeDLogDE 的公开定义由 PublicBoundary018.wl 负责把本模块结果映射回统一 J。 *)

(* ::Package:: *)

(* ::Chapter:: *)
(*016 根号动力学坐标与显式双列表适配层*)

(* 本模块把 loop external-momentum 的内部原子 kk[i,j]=sp[k_i,k_j] 暴露为
   ssij=Sqrt[sp[k_i,k_j]]，并把实际出现的无圈动量模长依次暴露为 sE1,sE2,...。
   旧 kk/sij 导数保持原子实现；根号坐标只通过 Jacobian 链式法则调用该原子层。 *)


(* ::Section::Closed:: *)
(*缺省命名与圈外外腿规则*)

coordinateIndexString[index_Integer, count_Integer] := IntegerString[
   index, 10, If[count >= 10, Max[2, IntegerLength[count]], 1]
   ];


externalRootSymbolName[i_Integer, j_Integer, count_Integer : 0] := ToExpression[
   "ss" <> coordinateIndexString[Min[i, j], count] <> coordinateIndexString[Max[i, j], count]
   ];


externalLegRootSymbolName[i_Integer, count_Integer : 0] := ToExpression[
   "sE" <> coordinateIndexString[i, count]
   ];


defaultLoopKinematicRulesForTopology[topo_Association] := Module[
   {exts = Lookup[topo, "effectiveLoopExternalMomenta", {}], nK},
   nK = Length[exts];
   Flatten@Table[
     sp[exts[[i]], exts[[j]]] -> externalRootSymbolName[i, j, nK]^2,
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
   {basis = Lookup[topo, "effectiveLoopExternalMomenta", {}], data},
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
     Values@Replace[Lookup[topo, "sectorExternalLegEnergyByVertex", <||>], rules_List :> Association[rules]],
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
   {external = Lookup[topo, "effectiveLoopExternalMomenta", {}], declaredLegs = Lookup[topo, "independentExternalMomenta", {}],
    atoms, externalRows, declaredRows, loopRows, basisRows, defaultSquaredCoordinates,
    candidates, candidateRows, coefficientVariables, spanCoefficients, occurrenceData},
   candidates = DeleteDuplicates@Join[declaredLegs, externalLegMagnitudeCandidateMomenta[topo]];
   atoms = ds016MomentumAtoms[Join[external, declaredLegs, candidates]];
   externalRows = ds016RowsForExpressions[external, atoms];
   declaredRows = ds016SquaredGramRow /@ ds016RowsForExpressions[declaredLegs, atoms];
   loopRows = ds016LoopGramRows[externalRows];
   basisRows = Join[loopRows, declaredRows];
   candidateRows = ds016SquaredGramRow /@ ds016RowsForExpressions[candidates, atoms];
   defaultSquaredCoordinates = Join[
     Last /@ defaultLoopKinematicRulesForTopology[topo],
     Table[externalLegRootSymbolName[i, Length[declaredLegs]]^2, {i, Length[declaredLegs]}]
     ];
   spanCoefficients[row_List] := Module[{solutions, coefficients},
     If[basisRows === {}, Return[{}]];
     coefficientVariables = Array[Unique["magnitudeCoordinate$"] &, Length[basisRows]];
     solutions = Quiet[Solve[Thread[coefficientVariables . basisRows == row], coefficientVariables]];
     If[solutions === {}, Return[ConstantArray[Indeterminate, Length[basisRows]]]];
     coefficients = coefficientVariables /. First[solutions];
     coefficients /. Thread[coefficientVariables -> 0]
     ];
   occurrenceData = MapIndexed[
     Function[{momentum, indexSpec},
      Module[{position = First[indexSpec], declaredPosition, coefficients, externalLegIndex, independentQ},
       (* 只比较声明列表的完整元素。FirstPosition 的缺省层级会在 p1+p2 内部先命中 p2，
          从而把后续独立模长错误编号为前一个 sEi。 *)
       declaredPosition = FirstPosition[
         Map[
          TrueQ[Expand[# - momentum] === 0 || Expand[# + momentum] === 0] &,
          declaredLegs
          ],
         True,
         Missing["Dependent"]
         ];
       independentQ = Head[declaredPosition] =!= Missing;
       externalLegIndex = If[independentQ, First[declaredPosition], Missing["Dependent"]];
       coefficients = If[
         independentQ,
         UnitVector[Length[basisRows], Length[loopRows] + externalLegIndex],
         spanCoefficients[candidateRows[[position]]]
         ];
       <|
        "occurrenceIndex" -> position,
        "momentum" -> momentum,
        "squaredExpression" -> sp[momentum, momentum],
        "magnitudeExpression" -> Sqrt[sp[momentum, momentum]],
        "gramVector" -> candidateRows[[position]],
        "baseCoefficients" -> coefficients,
        "independentQ" -> independentQ,
        "externalLegIndex" -> externalLegIndex,
        "userVariable" -> If[independentQ, externalLegRootSymbolName[externalLegIndex, Length[declaredLegs]], Missing["Dependent"]],
        "defaultSquaredExpression" -> Expand[coefficients . defaultSquaredCoordinates]
        |>
       ]
      ],
     candidates
     ];
   <|
    "declaredMomentumBasis" -> Join[external, declaredLegs],
    "gramPairs" -> ds016GramPairs[Length[atoms]],
    "loopGramRows" -> loopRows,
    "candidateMomenta" -> candidates,
    "candidateRows" -> candidateRows,
    "selectedOccurrencePositions" -> Range[Length[declaredLegs]],
    "basisRows" -> basisRows,
    "defaultSquaredCoordinates" -> defaultSquaredCoordinates,
    "occurrenceData" -> occurrenceData,
    "independentExternalLegData" -> Take[occurrenceData, UpTo[Length[declaredLegs]]],
    "dependentExternalLegData" -> Drop[occurrenceData, Min[Length[occurrenceData], Length[declaredLegs]]]
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


defaultMagnitudeKinematicRulesForTopology[topo_Association] := Map[
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
   loopRules = defaultLoopKinematicRulesForTopology[topo];
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


kinematicRootExpression[rhs_] := Module[{factored = Factor[rhs]},
   Replace[
    factored,
    {
     HoldPattern[Power[s_, 2]] :> s,
     other_ :> Sqrt[other]
     },
    {0}
    ]
   ];


kinematicCoordinateAudit[topo_Association, rules_List, source_String] := Module[
   {baseData, baseCount, normalizedRules, vectors, supportedPositions, unsupportedPositions,
     matrix, rhs, rank, rowSelection, baseRHS = {}, resolvedRules = {}, loopCount,
    missingDirections, ruleMissingDirections, parameterMissingDirections, ruleDependencies,
    parameterDependencies, constraintResiduals = {}, userVariables, parameterJacobian = {},
    baseExpressions, ruleMissingDirectionExpressions, parameterMissingDirectionExpressions,
    ruleDependencyResiduals, parameterRank = 0, ruleCompleteQ, overcompleteQ, completeQ,
     inverseAvailableQ, occurrenceData, bindingCoordinates, dependentBindings, defaultExpressions},
   baseData = kinematicBaseCoordinateData[topo];
   baseCount = Length[baseData];
   (* Lookup 对空规则列表返回 KeyAbsent；显式保留空坐标列表，避免用户提示泄漏 Missing。 *)
   baseExpressions = If[baseData === {}, {}, Lookup[baseData, "inputExpression"]];
   defaultExpressions = If[baseData === {}, {}, Lookup[baseData, "defaultRHS"]];
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
   (* Variables[(u+v)^2] 会把未展开的 u+v 当成单一代数原子；先合并展开，
      再一次提取参数，才能建立一般混合坐标的完整 Jacobian。 *)
   userVariables = DeleteDuplicates@Flatten[
      Variables[Expand[#]] & /@ (Last /@ normalizedRules)
      ];
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
   loopCount = Length[defaultLoopKinematicRulesForTopology[topo]];
   occurrenceData = externalLegMagnitudeOccurrenceData[topo];
   bindingCoordinates = If[
     Length[baseRHS] === baseCount,
     baseRHS,
     Lookup[baseData, "defaultRHS", {}]
     ];
   (* 欠完备坐标没有定义完整 binding；此时只报告零空间/缺失方向，避免伪造 Indeterminate。 *)
   dependentBindings = If[
     completeQ,
     Map[
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
      ],
     {}
     ];
   <|
    "status" -> Which[! completeQ, "incomplete", overcompleteQ, "overcomplete", True, "complete"],
    "source" -> source,
    "baseCoordinateData" -> baseData,
    "baseCoordinateOrder" -> baseExpressions,
    "baseCoordinateCount" -> baseCount,
     "defaultRules" -> Thread[baseExpressions -> defaultExpressions],
     "selectionTemplate" -> ("kinematicRules" -> Thread[baseExpressions -> defaultExpressions]),
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


(* 重定义指南只生成可复制的文本，不创建或赋值任何用户符号。左端始终使用原始动量的 sp 表示，
   右端才是用户选择的坐标表达式；这样不会把缺省 ss 名误当成规则左端。 *)
kinematicParameterRedefinitionGuide[audit_Association] := Module[
   {defaultRules, lhsStrings, customRuleStrings, commandExample},
   defaultRules = Lookup[audit, "defaultRules", {}];
   If[! ListQ[defaultRules] || defaultRules === {} ||
     ! VectorQ[defaultRules, MatchQ[Unevaluated[#], _Rule | _RuleDelayed] &],
    Return[<|
      "optionalQ" -> True,
      "defaultBehavior" -> "当前 family 没有可重定义动力学坐标。 This family has no redefinable kinematic coordinates.",
      "ruleLeftHandSideFormat" -> "无。 None.",
      "ruleRightHandSideFormat" -> "无。 None.",
      "coverageRequirement" -> "无需动力学坐标规则。 No kinematic-coordinate rules are required.",
      "defaultRules" -> {},
      "commandExample" -> None
      |>]
    ];
   lhsStrings = ToString[First[#], InputForm] & /@ defaultRules;
   customRuleStrings = MapIndexed[
     #1 <> " -> custom" <> ToString[First[#2]] <> "^2" &,
     lhsStrings
     ];
   commandExample = "DSRedefineParameters[context, {" <> StringRiffle[customRuleStrings, ", "] <> "}]";
   <|
    "optionalQ" -> True,
    "defaultBehavior" -> "不调用 DSRedefineParameters 时继续使用 defaultRules。 Without DSRedefineParameters, the family continues to use defaultRules.",
    "ruleLeftHandSideFormat" -> "左端必须写 sp[原始动量表达式,原始动量表达式] 或其它 baseCoordinateOrder 中的 sp；不要写 ssij/sEi -> custom。",
    "ruleLeftHandSideFormatEnglish" -> "The left side must be sp[original momentum expression, original momentum expression], or another sp entry from baseCoordinateOrder; do not write ssij/sEi -> custom.",
    "ruleRightHandSideFormat" -> "右端写该标量积在自定义参数中的表达式；模长坐标常写 custom^2，也允许满秩混合表达式如 (u+v)^2。",
    "ruleRightHandSideFormatEnglish" -> "The right side is the scalar product in custom parameters; magnitude coordinates commonly use custom^2, and full-rank mixed expressions such as (u+v)^2 are allowed.",
    "coverageRequirement" -> "规则左端与右端参数 Jacobian 都必须覆盖全部 baseCoordinateOrder；欠完备拒绝初始化，过完备只允许 symbolic IBP。 Both rule left sides and the right-side parameter Jacobian must cover all of baseCoordinateOrder; undercomplete input is rejected and overcomplete input permits symbolic IBP only.",
    "defaultRules" -> defaultRules,
    "commandExample" -> commandExample
    |>
   ];


kinematicRequiredMagnitudeCoverage[topo_Association] := Module[
   {declarationAudit, requiredMomenta, audit, resolvedRules, effectiveLoopExternalMomenta, canonical, directSquare,
    externalData, coefficients, expandedSquare, baseData, sourceKind},
   declarationAudit = Lookup[topo, "momentumDeclarationAudit", <||>];
   requiredMomenta = Lookup[declarationAudit, "requiredIndependentMomentumMagnitudes", {}];
   audit = Lookup[topo, "kinematicCoordinateAudit", <||>];
   resolvedRules = Lookup[audit, "resolvedRules", Lookup[audit, "defaultRules", {}]];
   effectiveLoopExternalMomenta = Lookup[topo, "effectiveLoopExternalMomenta", {}];
   baseData = Lookup[audit, "baseCoordinateData", {}];
   Map[
    Function[momentum,
     canonical = canonicalExternalLegMomentum[momentum];
     directSquare = Expand[sp[canonical, canonical] /. resolvedRules];
     If[directSquare === sp[canonical, canonical],
      externalData = linearMomentumExpressionData[canonical, effectiveLoopExternalMomenta];
      If[TrueQ[Lookup[externalData, "linearQ", False]],
       coefficients = Lookup[externalData, "coefficients", {}];
       expandedSquare = Expand[Sum[
           coefficients[[i]] coefficients[[j]] sp[effectiveLoopExternalMomenta[[i]], effectiveLoopExternalMomenta[[j]]],
           {i, Length[effectiveLoopExternalMomenta]}, {j, Length[effectiveLoopExternalMomenta]}
           ] /. resolvedRules],
       expandedSquare = Missing["UncoveredMagnitude", canonical]
       ],
      expandedSquare = directSquare
      ];
     sourceKind = Lookup[
       SelectFirst[baseData, SameQ[Lookup[#, "inputExpression", Missing["input"]], sp[canonical, canonical]] &, <||>],
       "kind",
       If[Head[expandedSquare] === Missing, "uncovered", "derivedBinding"]
       ];
     <|
      "momentum" -> canonical,
      "squaredExpression" -> sp[canonical, canonical],
      "userSquaredExpression" -> expandedSquare,
      "userMagnitudeExpression" -> If[Head[expandedSquare] === Missing, expandedSquare, kinematicRootExpression[expandedSquare]],
      "coverageKind" -> sourceKind
      |>
     ],
    requiredMomenta
    ]
   ];


resolveKinematicRulesForCase[case_Association, topo_Association] := Module[
   {combined, loopRules, legRules, selected},
   combined = Lookup[case, "kinematicRules", Automatic];
   If[combined =!= Automatic,
    Return[kinematicCoordinateAudit[topo, normalizeKinematicRuleList[combined], "kinematicRules"]]
    ];
   loopRules = normalizeLoopKinematicRulesForTopology[Automatic, topo];
   legRules = normalizeMagnitudeKinematicRulesForTopology[Automatic, topo];
   selected = Join[loopRules, legRules];
   kinematicCoordinateAudit[topo, selected, "default"]
   ];


normalizeMagnitudeKinematicRulesForTopology[Automatic, topo_Association] :=
  defaultMagnitudeKinematicRulesForTopology[topo];
normalizeMagnitudeKinematicRulesForTopology[rules_Association, topo_Association] :=
  normalizeMagnitudeKinematicRulesForTopology[Normal[rules], topo];
normalizeMagnitudeKinematicRulesForTopology[rules_List, topo_Association] := Module[
   {defaults = defaultMagnitudeKinematicRulesForTopology[topo], validRules},
   validRules = Select[rules, validReplacementRuleQ] /. Rule[Sqrt[lhs_], rhs_] :> Rule[lhs, rhs^2];
   Normal[Association[Join[defaults, validRules]]]
   ];
normalizeMagnitudeKinematicRulesForTopology[_, topo_Association] :=
  defaultMagnitudeKinematicRulesForTopology[topo];


rootCoordinateSymbol[expr_] := Replace[
   Unevaluated[expr],
   HoldPattern[Power[s_, 2]] :> s,
   {0}
   ];


rootCoordinateExpressionQ[expr_] := MatchQ[Unevaluated[expr], HoldPattern[Power[_, 2]]];


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

loopKinematicCoordinateData[topo_Association] := Module[
   {rules = loopKinematicInternalToUserRules[topo]},
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


magnitudeKinematicCoordinateData[topo_Association] := Module[
   {rules = Lookup[topo, "resolvedMagnitudeKinematicRules", defaultMagnitudeKinematicRulesForTopology[topo]], magnitudeData},
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


resolveLoopKinematicCoordinate[topo_Association, variable_] := SelectFirst[
   loopKinematicCoordinateData[topo],
   SameQ[variable, Lookup[#, "userVariable"]] ||
     SameQ[variable, Lookup[#, "internalVariable"]] ||
     SameQ[variable, Lookup[#, "internalCoordinateExpression"]] &,
   Missing["UnknownExternalInvariantCoordinate", variable]
   ];


loopKinematicUserToInternalRules[topo_Association] := DeleteDuplicates@Flatten[
   Function[data,
     {
      data["publicExpression"] -> data["internalVariable"],
      data["userVariable"] -> data["internalCoordinateExpression"]
      }
     ] /@ loopKinematicCoordinateData[topo]
   ];


rootCoordinateOutputRules[topo_Association] := Flatten@Cases[
   loopKinematicCoordinateData[topo],
   data_Association /; data["coordinateType"] === "squareRoot" :> With[
     {root = data["userVariable"]},
     {
      HoldPattern[Power[Power[root, 2], power_Rational]] :> root^(2 power),
      HoldPattern[Sqrt[root^2]] :> root
      }
     ]
   ];


(* 无圈模长平方在 Jacobian 原子层使用私有占位符；公开输出必须按当前坐标审计回代，
   以便缺省坐标和用户满秩重定义共享同一条输出路径。 *)
externalLegSquaredCoordinateOutputRules[topo_Association] := Module[
   {audit, baseData, defaultExpressions, squaredExpressions},
   audit = Lookup[topo, "kinematicCoordinateAudit", <||>];
   baseData = Lookup[audit, "baseCoordinateData", kinematicBaseCoordinateData[topo]];
   defaultExpressions = Lookup[baseData, "defaultRHS", {}];
   squaredExpressions = Lookup[
     audit,
     "baseSquaredUserExpressions",
     defaultExpressions
     ];
   If[Length[squaredExpressions] =!= Length[baseData], squaredExpressions = defaultExpressions];
   Cases[
    MapThread[Join[#1, <|"userSquaredExpression" -> #2|>] &, {baseData, squaredExpressions}],
    data_Association /; Lookup[data, "kind", ""] === "externalLegMagnitude" :>
     Rule[data["internalVariable"], data["userSquaredExpression"]]
    ]
   ];


scalarProductInternalToUser[expr_, topo_Association] := Module[
   {loops = topo["loopMomenta"], exts = topo["effectiveLoopExternalMomenta"], result},
   result = expr /. Join[
       loopKinematicInternalToUserRules[topo],
       externalLegSquaredCoordinateOutputRules[topo],
       {
        HoldPattern[qq[i_Integer, j_Integer]] :> sp[loops[[i]], loops[[j]]],
        HoldPattern[qk[i_Integer, j_Integer]] :> sp[loops[[i]], exts[[j]]]
        }
       ];
   Expand[result /. rootCoordinateOutputRules[topo]]
   ];


scalarProductInputToInternal[expr_, topo_Association] := Expand[
   scalarProductSPInputToInternal[expr, topo] /. loopKinematicUserToInternalRules[topo]
   ];


loopKinematicNamingReport[topo_Association] := <|
   "effectiveLoopExternalMomenta" -> Lookup[topo, "effectiveLoopExternalMomenta", {}],
   "resolvedLoopKinematicRules" -> Lookup[topo, "resolvedLoopKinematicRules", defaultLoopKinematicRulesForTopology[topo]],
   "internalExternalInvariantRules" -> loopKinematicInternalToUserRules[topo],
   "coordinateData" -> loopKinematicCoordinateData[topo],
   "defaultNamingConvention" -> "ssij = Sqrt[sp[k_i,k_j]], where i<=j follows loopExternalMomenta order",
   "message" -> "loopExternalMomenta 是用户显式给出的 loop 标量积外向量基；内部仍用 kk[i,j]=sp[k_i,k_j]，018 公开缺省坐标为 ssij。"
   |>;


magnitudeKinematicNamingReport[topo_Association] := <|
   "independentExternalMomenta" -> Lookup[topo, "independentExternalMomenta", {}],
   "appearingMagnitudeMomenta" -> Lookup[externalLegMagnitudeOccurrenceData[topo], "momentum", {}],
   "independentMagnitudeMomenta" -> Lookup[externalLegMagnitudeData[topo], "momentum", {}],
   "dependentMagnitudeBindings" -> Map[
     KeyTake[#, {"momentum", "squaredExpression", "userSquaredExpression", "userMagnitudeExpression"}] &,
     Select[externalLegMagnitudeBindingData[topo], ! TrueQ[Lookup[#, "independentQ", False]] &]
     ],
   "resolvedMagnitudeKinematicRules" -> Lookup[topo, "resolvedMagnitudeKinematicRules", defaultMagnitudeKinematicRulesForTopology[topo]],
   "coordinateData" -> magnitudeKinematicCoordinateData[topo],
   "defaultNamingConvention" -> "sE1,sE2,... follow the first-occurrence independent basis of no-loop momentum magnitudes in lines, vertices.externalLegEnergy and extLegs",
   "automaticCrossProducts" -> False,
   "entersLoopIBPGenerators" -> False,
   "entersISPClosure" -> False
   |>;


(* ::Section::Closed:: *)
(*数值规则与初始化 metadata*)

normalizeNumericRuleForTopology[rule : (Rule | RuleDelayed)[lhs_, rhs_], topo_Association] := Module[
   {coordinate = resolveLoopKinematicCoordinate[topo, lhs], internalLHS},
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


externalInvariantUserVariables[topo_Association] := Lookup[loopKinematicCoordinateData[topo], "userVariable", {}];


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
   coordinate = resolveLoopKinematicCoordinate[topo, variable];
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
   ] := Module[{result, endpointVertex, nPosition, xPower = term["xPower"]},
   endpointVertex = topo["lines"][[e, "endpoints", endpointSlot]];
   nPosition = linePackNPositions[topo["lines"][[e]], actualLinePackType[topo, e, int[[2, e]]]][[endpointSlot]];
   result = setLinePackEntry[int, e, nPosition, term["targetState"]];
   (* fixed line 的幂移会产生显式系数，因此必须先对裸 J 完成顶点移位。 *)
   result = shiftVertexA[result, topo, endpointVertex, xPower + 1];
   result = shiftLinePower[topo, result, e, -xPower];
   term["coefficient"] result
   ];


compiledScalarMomentumEndpointDerivativeTerms[
   topo_Association, int_J, e_Integer, endpointSlot_Integer
   ] := Module[{state, terms},
   state = int[[2, e, linePackNPositions[topo["lines"][[e]], actualLinePackType[topo, e, int[[2, e]]]][[endpointSlot]]]];
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
    -I sigma shiftVertexA[toggleMasslessLineState[topo, int, e], topo, line["endpoints"][[1]], 1] +
     I sigma shiftVertexA[toggleMasslessLineState[topo, int, e], topo, line["endpoints"][[2]], 1],
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
     -linePowerIndex[topo, int, e] shiftLinePower[topo, int, e, 1] +
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


directExternalLegEnergyVariableDerivativeSeed[topo_Association, int_J, variable_] := Module[
   {coordinate, derivativeVariable, derivativeScale, vertices = activeAVertexIds[topo], derivative},
   coordinate = resolveLoopKinematicCoordinate[topo, variable];
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


literalExternalLegEnergyVariableDerivativeSeed[topo_Association, int_J, variable_] := Module[
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
     magnitudeKinematicCoordinateData[topo],
     SameQ[Lookup[#, "userVariable", Missing["NoVariable"]], variable] &,
     Missing["NotFound"]
     ];
   If[! AssociationQ[coordinate], Return[directExternalLegEnergyVariableDerivativeSeed[topo, int, variable]]];
   Expand[
    externalLegMagnitudeLineDerivativeSeed[topo, int, coordinate] +
     directExternalLegEnergyVariableDerivativeSeed[topo, int, variable]
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
   phaseTerms = literalExternalLegEnergyVariableDerivativeSeed[topo, int, variable];
   Expand[loopTerms + legTerms + phaseTerms]
   ];


applyIndependentVariableDerivativeSeed[topo_Association, int_J, variable_, opts : OptionsPattern[makeExternalInvariantDerivativeDecomposition]] := Module[
   {coordinate = resolveLoopKinematicCoordinate[topo, variable], atomic, selectedVariables},
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
   "externalLegEnergy"
   ];


makeIndependentVariableDerivativeGenerators[topo_Association] := Map[
   Function[variable,
    Module[{coordinate = resolveLoopKinematicCoordinate[topo, variable]},
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
       "kind" -> "externalLegEnergy",
       "coordinateType" -> If[MemberQ[Lookup[magnitudeKinematicCoordinateData[topo], "userVariable", {}], variable], "externalLegSquareRoot", "independentScalar"]
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
   "vertices" -> topo["vertices"],
   "lineOrder" -> Lookup[topo["lines"], "id"],
   "lineConventions" -> Map[
      KeyTake[#, {"id", "massType", "packType", "state", "skType", "thetaConvention", "functionSystem", "compiledFunctionSystem"}] &,
     topo["lines"]
     ],
   "zeroPointRules" -> topo["zeroPointRules"],
   "symmetryRules" -> topo["symmetryRules"],
   "effectiveSymmetryRules" -> Lookup[topo, "effectiveSymmetryRules", effectiveSymmetryRules0[topo]],
   "tadpoleSymmetryData" -> Lookup[topo, "tadpoleSymmetryData", tadpoleSymmetryData[topo]],
   "resolvedLoopKinematicRules" -> topo["resolvedLoopKinematicRules"],
   "resolvedMagnitudeKinematicRules" -> Lookup[topo, "resolvedMagnitudeKinematicRules", {}],
   "loopKinematicCoordinateData" -> loopKinematicCoordinateData[topo],
    "magnitudeKinematicCoordinateData" -> magnitudeKinematicCoordinateData[topo],
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


externalLegEnergyNamingReport[topo_Association] := Module[
   {vertices = activeAVertexIds[topo], raw, internal, user, dependencies},
   raw = AssociationThread[vertices -> (rawVertexExternalEnergy[topo, #] & /@ vertices)];
   internal = AssociationThread[vertices -> (vertexExternalEnergy[topo, #] & /@ vertices)];
   user = AssociationThread[vertices -> (scalarProductInternalToUser[vertexExternalEnergy[topo, #], topo] & /@ vertices)];
   dependencies = AssociationThread[vertices -> (externalLegEnergyDependencyData[topo, #] & /@ vertices)];
   <|
     "convention" -> "loop external roots use ssij; the independent basis of actually appearing no-loop momentum magnitudes uses sEe variables and dependent magnitudes keep explicit bindings; unrelated scalar phase parameters remain explicit user symbols",
    "rawExternalLegEnergies" -> raw,
    "internalExternalLegEnergies" -> internal,
    "userExternalLegEnergies" -> user,
    "dependencyData" -> dependencies,
    "magnitudeKinematicNamingReport" -> magnitudeKinematicNamingReport[topo],
     "message" -> "vertices.externalLegEnergy 可使用 loop-external Gram 根号或 independentExternalMomenta 声明的无圈模长；022 不自动生成无圈动量之间的交叉点积。无圈动量变量不进入 loop IBP/ISP。"
     |>
    ];


(* ::Section::Closed:: *)
(*公开动力学变量提案与重选审计*)

DSKinematics[input_Association, rules_: Automatic] := Module[
   {effectiveInput, topo, audit, coordinateStatus, declarationAudit, declarationStatus, status, result,
    guide, overcompleteDetails, reportedCapabilities},
   effectiveInput = If[rules === Automatic, input, Join[input, <|"kinematicRules" -> rules|>]];
   topo = parseTopology[effectiveInput];
   If[topo === $Failed,
    Return[<|"status" -> "failed", "reason" -> "invalidTopologyInput"|>]
    ];
    audit = Lookup[topo, "kinematicCoordinateAudit", <||>];
    coordinateStatus = Lookup[audit, "status", "unknown"];
    declarationAudit = Lookup[topo, "momentumDeclarationAudit", <||>];
    declarationStatus = Lookup[declarationAudit, "status", "invalid"];
    status = Which[
      MemberQ[{"invalid", "failed"}, declarationStatus] || MemberQ[{"invalid", "failed"}, coordinateStatus], "invalid",
      declarationStatus === "undercomplete", "undercomplete",
      declarationStatus === "overcomplete" || coordinateStatus === "overcomplete", "overcomplete",
      coordinateStatus === "incomplete", "incomplete",
      declarationStatus === "exact" && coordinateStatus === "complete", "complete",
      True, coordinateStatus
      ];
    reportedCapabilities = If[
      MemberQ[{"complete", "overcomplete"}, status],
      Lookup[topo, "capabilities", <||>],
      dsDisabledCapabilities[]
      ];
    guide = kinematicParameterRedefinitionGuide[audit];
    result = Join[audit, <|
       "status" -> status,
       "kinematicCoordinateStatus" -> coordinateStatus,
       "momentumDeclarationStatus" -> declarationStatus,
       "loopExternalAudit" -> Lookup[declarationAudit, "loopExternalAudit", <||>],
       "independentExternalAudit" -> Lookup[declarationAudit, "independentExternalAudit", <||>],
       "missingDirections" -> Lookup[Lookup[declarationAudit, "loopExternalAudit", <||>], "missingDirections", {}],
       "extraDirections" -> Lookup[Lookup[declarationAudit, "loopExternalAudit", <||>], "extraDirections", {}],
       "missingMagnitudeSquares" -> Lookup[Lookup[declarationAudit, "independentExternalAudit", <||>], "missingMagnitudeSquares", {}],
       "extraMagnitudeSquares" -> Lookup[Lookup[declarationAudit, "independentExternalAudit", <||>], "extraMagnitudeSquares", {}],
       "capabilities" -> reportedCapabilities,
       "requiredMagnitudeCoverage" -> kinematicRequiredMagnitudeCoverage[topo],
       "parameterRedefinitionGuide" -> guide
       |>];
   dsInfoPrint[
     "动力学变量提案：" <> ToString[Lookup[audit, "defaultRules", {}], InputForm] <>
      "；当前选择：" <> ToString[Lookup[audit, "selectedRules", {}], InputForm] <>
      "；从属模长绑定：" <> ToString[Lookup[audit, "dependentMagnitudeBindings", {}], InputForm] <>
      "；审计状态 " <> ToString[status] <>
      ". Kinematic-variable proposal: " <> ToString[Lookup[audit, "defaultRules", {}], InputForm] <>
      "; selected rules: " <> ToString[Lookup[audit, "selectedRules", {}], InputForm] <>
      "; dependent magnitude bindings: " <> ToString[Lookup[audit, "dependentMagnitudeBindings", {}], InputForm] <>
      "; audit status " <> ToString[status],
     Automatic
     ];
   If[StringQ[Lookup[guide, "commandExample", None]],
    dsInfoPrint[
      "可选参数重定义：" <> Lookup[guide, "ruleLeftHandSideFormat", ""] <>
       " " <> Lookup[guide, "ruleRightHandSideFormat", ""] <>
       " 示例：" <> guide["commandExample"] <>
       ". Optional parameter redefinition: " <> Lookup[guide, "ruleLeftHandSideFormatEnglish", ""] <>
       " " <> Lookup[guide, "ruleRightHandSideFormatEnglish", ""] <>
       "; example: " <> guide["commandExample"],
      Automatic
      ],
    dsInfoPrint[Lookup[guide, "defaultBehavior", ""], Automatic]
    ];
    Switch[status,
     "undercomplete",
     dsErrorPrint[
       "动量声明欠完备；DSInit 将拒绝继续。缺失方向/模长平方为 " <>
        ToString[Join[Lookup[result, "missingDirections", {}], Lookup[result, "missingMagnitudeSquares", {}]], InputForm] <>
        ". Momentum declarations are undercomplete, so DSInit will stop. Missing directions or squared magnitudes: " <>
        ToString[Join[Lookup[result, "missingDirections", {}], Lookup[result, "missingMagnitudeSquares", {}]], InputForm]
       ],
     "incomplete",
    dsErrorPrint[
      "动力学变量欠完备；DSInit 将拒绝继续。缺失/受约束方向为 " <>
       ToString[DeleteDuplicates@Join[
          Lookup[audit, "ruleMissingDirectionExpressions", {}],
          Lookup[audit, "parameterMissingDirectionExpressions", {}]
          ], InputForm] <>
       ". Kinematic variables are undercomplete, so DSInit will stop. Missing or constrained directions: " <>
       ToString[DeleteDuplicates@Join[
          Lookup[audit, "ruleMissingDirectionExpressions", {}],
          Lookup[audit, "parameterMissingDirectionExpressions", {}]
          ], InputForm]
      ],
    "overcomplete",
    overcompleteDetails = <|
      "loopExternalMomenta" -> KeyTake[Lookup[result, "loopExternalAudit", <||>], {"extraDirections", "userDependencyVectors"}],
      "independentExternalMomenta" -> KeyTake[Lookup[result, "independentExternalAudit", <||>], {"extraMagnitudeSquares", "redundantUserMomenta", "quadraticDependencyOrder", "quadraticDependencies"}],
      "coordinateConstraints" -> Lookup[audit, "constraintResiduals", {}]
      |>;
    dsWarningPrint[
      "动力学变量或动量声明过完备；初始化与 symbolic IBP 可继续，但 ds、DSDE 与唯一 rep2innerform 已禁用。详情：" <>
       ToString[overcompleteDetails, InputForm] <>
       ". Kinematic variables or momentum declarations are overcomplete. Initialization and symbolic IBP may continue, but ds, DSDE, and unique rep2innerform are disabled. Details: " <>
       ToString[overcompleteDetails, InputForm],
      Automatic
      ],
    _, Null
    ];
    result
    ];


DSKinematics[input_, rules_: Automatic] := <|
   "status" -> "failed",
   "reason" -> "inputNotAssociation",
   "input" -> HoldForm[input],
   "rules" -> HoldForm[rules]
   |>;

(* ::Package:: *)
(* 本模块定义 018 唯一积分表示、sector 身份与 massless seed quotient。所有 root
   line 槽位永久保留；full line 使用三槽，shrunk line 使用单槽，fixed line 用短
   字符串 "F" 标记无整数动量幂。masslessFull 的公开槽仍是 {n1,n2}，但 source
   seed 只枚举 n2->0 的两个代数代表，导数输出再由统一 canonical 映回该代表。 *)

(* ::Chapter:: *)
(*统一 line-pack schema*)

fixedLineSentinel018[] := "F";


linePackNPositions[line_Association, packType_String] := Switch[packType,
   "massiveFull" | "massiveCross" | "masslessFull", {2, 3},
   _, {}
   ];


linePackBPosition[line_Association] := If[lineIndexedPowerQ[line], 1, Missing["FixedLinePower"]];


makeLinePack[line_Association] := Module[
   {id = line["id"], indexedQ = lineIndexedPowerQ[line], firstSlot},
   firstSlot = If[indexedQ, b[id], fixedLineSentinel018[]];
   Switch[line["packType"],
    "massiveFull" | "massiveCross" | "masslessFull",
    {firstSlot, n[id, 1], n[id, 2]},
    "masslessCross",
    {firstSlot, 0, 0},
    "shrunk",
    If[indexedQ, {bS[id]}, {fixedLineSentinel018[]}],
    _, Message[makeLinePack::badtype, line["packType"], id]; $Failed
    ]
   ];


actualLinePackType[topo_Association, e_Integer, pack_List] := Module[
   {line = topo["lines"][[e]], declared},
   declared = line["packType"];
   Which[
    declared === "shrunk", "shrunk",
    Length[pack] === 1 && lineIndexedPowerQ[line] && pack[[1]] =!= fixedLineSentinel018[], "shrunk",
    Length[pack] === 1 && ! lineIndexedPowerQ[line] && pack[[1]] === fixedLineSentinel018[], "shrunk",
    True, declared
    ]
   ];


lineIntegerPowerIndex[topo_Association, J[_, linePacks_, _], e_Integer] := If[
   lineIndexedPowerQ[topo["lines"][[e]]],
   linePacks[[e, 1]],
   0
   ];


discreteVarsForLine[line_Association] := If[
   Lookup[line, "state", "full"] === "shrunk" || Lookup[line, "packType", ""] === "shrunk",
   {},
   Switch[line["packType"],
    "massiveFull" | "massiveCross" | "masslessFull", {n[line["id"], 1], n[line["id"], 2]},
    _, {}
    ]
   ];


(* 输入输出仍保留两个端点槽；这里只缩减 DSSeeds 的 source representatives。
   massive 需要四态，masslessFull 只生成 00/10，cross 与 shrunk 不生成离散态。 *)
discreteSeedRuleSetsForLine018[line_Association] := Module[
   {id = line["id"], variables = discreteVarsForLine[line]},
   Switch[Lookup[line, "packType", ""],
    "masslessFull" /; Lookup[line, "state", "full"] =!= "shrunk",
    {
     {n[id, 1] -> 0, n[id, 2] -> 0},
     {n[id, 1] -> 1, n[id, 2] -> 0}
     },
    _, ruleSetsForVars[variables]
    ]
   ];


rawBinaryDiscreteStateCountForLine018[line_Association] :=
  2^Length[discreteVarsForLine[line]];


discreteStateCountForLine[line_Association] :=
  Length[discreteSeedRuleSetsForLine018[line]];


(* enumerateDiscreteStates 是所有普通 time/momentum seed 的共同入口。返回值同时保存
   raw 双端点空间与 quotient representative 空间，供 release/audit 核对缩减边界。 *)
enumerateDiscreteStates[expr_, topo_Association] := Module[
   {perLineRuleSets, allRuleSets, rawStateCount},
   perLineRuleSets = discreteSeedRuleSetsForLine018 /@ topo["lines"];
   allRuleSets = Flatten[#, 1] & /@ Tuples[perLineRuleSets];
   rawStateCount = Times @@ (rawBinaryDiscreteStateCountForLine018 /@ topo["lines"]);
   <|
    "rules" -> allRuleSets,
    "integrals" -> (expr /. # & /@ allRuleSets),
    "mode" -> "masslessQuotientRepresentatives",
    "canonicalDirection" -> "n2ToZero",
    "rawBinaryStateCount" -> rawStateCount,
    "representativeStateCount" -> Length[allRuleSets],
    "eliminatedAlgebraicStateCount" -> rawStateCount - Length[allRuleSets]
    |>
   ];


selectedDiscreteSeedRules[topo_Association, OptionsPattern[]] := Module[
   {data = enumerateDiscreteStates[makeBaseIntegral[topo], topo]},
   Join[
    <|"status" -> "generated", "ruleCount" -> Length[data["rules"]]|>,
    KeyTake[data, {
      "mode", "canonicalDirection", "rawBinaryStateCount",
      "representativeStateCount", "eliminatedAlgebraicStateCount", "rules"
      }]
    ]
   ];


publicExpectedPackLength[_Association, "shrunk"] := 1;
publicExpectedPackLength[_Association, "massiveFull" | "massiveCross" | "masslessFull" | "masslessCross"] := 3;
publicExpectedPackLength[_Association, packType_String] := Missing["UnknownPackType", packType];


makeBaseIntegral[topo_Association] := Module[
   {active = Lookup[topo, "activeVertexIds", topo["vertexIds"]],
    fixedA = Lookup[topo, "fixedAVertexValues", <||>], ispList},
   ispList = If[
     Lookup[topo, "ibpMode", "full"] === "timeOnly",
     {},
     Table[ispN[j], {j, Length[topo["ispData"]]}]
     ];
   J[
    Table[If[AssociationQ[fixedA] && KeyExistsQ[fixedA, v], fixedA[v], a[v]], {v, active}],
    makeLinePacks[topo],
    ispList
    ]
   ];


dsTimeOnlyNeedsLinePackStateQ[_Association] := True;


(* ::Chapter:: *)
(*Sector pattern 与唯一解析*)

sectorLinePattern018[line_Association, pack_List] := <|
   "powerKind" -> If[lineIndexedPowerQ[line], "cycle", "fixed"],
   "state" -> If[Length[pack] === 1, "shrunk", "full"]
   |>;


sectorPattern018[topo_Association, linePacks_List] := MapThread[
   sectorLinePattern018,
   {topo["lines"], linePacks}
   ];


sectorShrunkLinesFromPattern018[pattern_List] := Flatten@Position[Lookup[pattern, "state", {}], "shrunk"];


sectorKeyFromPattern018[topo_Association, pattern_List] := sectorKeyFromShrunkLines[
   topo,
   sectorShrunkLinesFromPattern018[pattern]
   ];


linePackMatchesSlotQ[pack_List, slot_Association] := Module[
   {template = Lookup[slot, "packTemplate", {}], firstTemplate, fixedQ},
   If[Length[pack] =!= Length[template], Return[False]];
   If[template === {}, Return[pack === {}]];
   firstTemplate = First[template];
   fixedQ = SameQ[firstTemplate, fixedLineSentinel018[]];
   TrueQ[
    If[fixedQ, SameQ[First[pack], fixedLineSentinel018[]], First[pack] =!= fixedLineSentinel018[]]
    ]
   ];


(* ::Chapter:: *)
(*结构化 fixed-line sector prefactor*)

zeroPointRuleValue018[rules_List, symbol_, default_: 0] := Module[{hits},
   hits = Cases[rules, (Rule | RuleDelayed)[lhs_, rhs_] /; lhs === symbol :> rhs];
   If[hits === {}, default, Last[hits]]
   ];


explicitZeroPointRuleValue018[rules_List, symbol_] := Module[{hits},
   hits = Cases[rules, (Rule | RuleDelayed)[lhs_, rhs_] /; lhs === symbol :> rhs];
   If[hits === {}, Missing["NoExplicitZeroPoint", symbol], Last[hits]]
   ];


lineDerivedShrinkZeroPoint018[topo_Association, e_Integer] := Expand[
   zeroPointRuleValue018[
     Lookup[topo, "rootZeroPointRules", topo["zeroPointRules"]],
     b0[topo["lines"][[e, "id"]]],
     0
     ] + lineShrinkZeroPointShift[topo["lines"][[e]]]
   ];


lineTargetShrinkZeroPoint018[topo_Association, e_Integer] := Module[
   {rootRules, id, explicit},
   rootRules = Lookup[topo, "rootZeroPointRules", topo["zeroPointRules"]];
   id = topo["lines"][[e, "id"]];
   explicit = explicitZeroPointRuleValue018[rootRules, bS0[id]];
   If[Head[explicit] === Missing, lineDerivedShrinkZeroPoint018[topo, e], explicit]
   ];


lineShrinkZeroPointSource018[topo_Association, e_Integer] := Module[
   {rootRules, id},
   rootRules = Lookup[topo, "rootZeroPointRules", topo["zeroPointRules"]];
   id = topo["lines"][[e, "id"]];
   If[Head[explicitZeroPointRuleValue018[rootRules, bS0[id]]] === Missing,
    "compiledDefault",
    "userBS0Override"
    ]
   ];


(* child sector 继承 root 的显式 bS0 override；未给出时仍严格使用函数系统编译的 z shift。 *)
sectorZeroPointRules[
   topo_Association,
   shrunkLines_List,
   repMap_Association,
   activeVertices_List
   ] := Module[
   {lineRules, vertexRules, classVertices, classShrunkLines, shiftSum, rep},
   lineRules = Table[
     If[MemberQ[shrunkLines, e],
      bS0[topo["lines"][[e, "id"]]] -> lineTargetShrinkZeroPoint018[topo, e],
      Switch[actualLinePackType[topo, e, makeLinePack[topo["lines"][[e]]]],
       "shrunk", bS0[topo["lines"][[e, "id"]]] -> lineBSZeroPoint[topo, e],
       _, b0[topo["lines"][[e, "id"]]] -> lineBZeroPoint[topo, e]
       ]
      ],
     {e, topo["nE"]}
     ];
   vertexRules = Table[
     rep = activeVertices[[i]];
     classVertices = Select[topo["vertexIds"], Lookup[repMap, #] === rep &];
     classShrunkLines = Select[
       shrunkLines,
       Function[e, And @@ (Function[v, Lookup[repMap, v] === rep] /@ topo["lines"][[e, "endpoints"]])]
       ];
     shiftSum = Total[lineShrinkZeroPointShift[topo["lines"][[#]]] & /@ classShrunkLines];
     a0[rep] -> Total[vertexZeroPoint[topo, #] & /@ classVertices] - shiftSum,
     {i, Length[activeVertices]}
     ];
   DeleteDuplicates@Join[vertexRules, lineRules]
   ];


independentExternalMagnitudeExpressions018[topo_Association] := Module[
   {count, bindingData},
   count = Length[Lookup[topo, "independentExternalMomenta", {}]];
   bindingData = externalLegMagnitudeBindingData[topo];
   Lookup[Take[bindingData, UpTo[count]], "userMagnitudeExpression", {}]
   ];


fixedLineKEIndex018[topo_Association, e_Integer] := Module[
   {momentum, declared, matches},
   momentum = Expand[topo["lines"][[e, "momentum"]]];
   declared = Expand /@ Lookup[topo, "independentExternalMomenta", {}];
   matches = Flatten@Position[
      (TrueQ[Expand[# - momentum] === 0] || TrueQ[Expand[# + momentum] === 0]) & /@ declared,
      True
      ];
   If[matches === {}, Missing["NotIndependentExternalMagnitude"], First[matches]]
   ];


lineShrinkNormalizationFactor018[topo_Association, e_Integer] := Module[
   {line, terms, coefficients, nonzero},
   line = topo["lines"][[e]];
   If[Lookup[line, "massType", "massive"] =!= "massive", Return[1]];
   terms = lineCompiledShrinkTerms[line];
   coefficients = Expand[Lookup[#, "coefficient", 0]] & /@ terms;
   nonzero = Select[coefficients, ! TrueQ[# === 0] &];
   If[nonzero === {}, 1, First[nonzero]]
   ];


fixedLinePrefactorRecord018[topo_Association, e_Integer, state_: Automatic] := Module[
   {line = topo["lines"][[e]], id, shrunkQ, rootRules, sourcePower, targetPower,
     integerShift, zeroPointShift, targetMinusSource, residualPower, parameter,
     derivedTarget, overrideSource, kEIndex},
   id = line["id"];
   shrunkQ = If[
     state === Automatic,
     Lookup[line, "state", "full"] === "shrunk" || Lookup[line, "packType", ""] === "shrunk",
     TrueQ[state === "shrunk"]
     ];
   rootRules = Lookup[topo, "rootZeroPointRules", topo["zeroPointRules"]];
   sourcePower = zeroPointRuleValue018[rootRules, b0[id], 0];
   targetPower = If[shrunkQ, lineBSZeroPoint[topo, e], lineBZeroPoint[topo, e]];
   integerShift = If[shrunkQ, lineShrinkBShift[line], 0];
   zeroPointShift = If[shrunkQ, lineShrinkZeroPointShift[line], 0];
   derivedTarget = If[shrunkQ, lineDerivedShrinkZeroPoint018[topo, e], sourcePower];
   overrideSource = If[shrunkQ, lineShrinkZeroPointSource018[topo, e], "sourceSector"];
   targetMinusSource = Expand[targetPower - sourcePower];
   residualPower = Expand[integerShift + zeroPointShift - targetMinusSource];
   parameter = fixedLineMomentumMagnitude[topo, e];
   kEIndex = fixedLineKEIndex018[topo, e];
   <|
    "lineIndex" -> e,
    "lineId" -> id,
    "parameterKey" -> ("fixedLine:" <> ToString[id, InputForm]),
     "parameter" -> parameter,
     "kEIndex" -> kEIndex,
    "state" -> If[shrunkQ, "shrunk", "full"],
    "sourceZeroPoint" -> sourcePower,
    "targetZeroPoint" -> targetPower,
    "derivedTargetZeroPoint" -> derivedTarget,
    "zeroPointOverrideSource" -> overrideSource,
    "integerShift" -> integerShift,
    "compiledIntegerShift" -> integerShift,
    "zeroPointShift" -> zeroPointShift,
    "compiledZeroPointShift" -> zeroPointShift,
    "targetMinusSource" -> targetMinusSource,
    "normalizedResidualPower" -> residualPower,
    "prefactorPower" -> Expand[-targetPower]
    |>
   ];


sectorPrefactorData018[topo_Association, shrunkLines_: Automatic] := Module[
   {effectiveShrunkLines, records, kEIndices, kEMomenta, kEExpressions, kEPowers,
    residualRecords, contractionRecords},
   effectiveShrunkLines = If[
     shrunkLines === Automatic,
     Select[
       Range[topo["nE"]],
       Lookup[topo["lines"][[#]], "state", "full"] === "shrunk" ||
         Lookup[topo["lines"][[#]], "packType", ""] === "shrunk" &
       ],
     Sort@DeleteDuplicates[shrunkLines]
     ];
   records = fixedLinePrefactorRecord018[topo, #] & /@ Select[
      Range[topo["nE"]],
      ! lineIndexedPowerQ[topo["lines"][[#]]] &
      ];
   records = Map[
     fixedLinePrefactorRecord018[
       topo,
       Lookup[#, "lineIndex"],
       If[MemberQ[effectiveShrunkLines, Lookup[#, "lineIndex"]], "shrunk", "full"]
       ] &,
     records
     ];
   kEIndices = Range[Length[Lookup[topo, "independentExternalMomenta", {}]]];
   kEMomenta = Lookup[topo, "independentExternalMomenta", {}];
   kEExpressions = independentExternalMagnitudeExpressions018[topo];
   kEPowers = Table[
     Total[Lookup[Select[records, SameQ[Lookup[#, "kEIndex", None], i] &], "prefactorPower", {}]],
     {i, Length[kEIndices]}
     ];
   residualRecords = Select[records, Head[Lookup[#, "kEIndex", Missing[]]] === Missing &];
   contractionRecords = Map[
     <|
       "lineIndex" -> #,
       "lineId" -> topo["lines"][[#, "id"]],
       "normalizationFactor" -> lineShrinkNormalizationFactor018[topo, #]
       |> &,
     effectiveShrunkLines
     ];
   <|
    "lineIndices" -> Lookup[records, "lineIndex", {}],
    "parameterKeys" -> Lookup[records, "parameterKey", {}],
    "parameterList" -> Lookup[records, "parameter", {}],
    "powerList" -> Lookup[records, "prefactorPower", {}],
     "powerParts" -> records,
     "kEIndices" -> kEIndices,
     "kEMomenta" -> kEMomenta,
     "kEParameterExpressions" -> kEExpressions,
     "kEPower" -> Apply[kEpower, kEPowers],
     "residualPowerParts" -> residualRecords,
     "contractionParts" -> contractionRecords,
     "constantPrefactor" -> Times @@ Lookup[contractionRecords, "normalizationFactor", {}],
     "normalizationConvention" -> "structuralKEPowerAndContact-v1"
     |>
   ];


materializeSectorPrefactor018[data_Association] := Module[
    {powerHead, powers, expressions, residualParts},
    powerHead = Lookup[data, "kEPower", Missing["NoStructuralKEPower"]];
    If[Head[powerHead] === Missing,
     Return[Failure["MissingStructuralKEPower", <|"requiredKey" -> "kEPower"|>]]
     ];
   powers = List @@ powerHead;
   expressions = Lookup[data, "kEParameterExpressions", {}];
   residualParts = Lookup[data, "residualPowerParts", {}];
   If[Length[powers] =!= Length[expressions], Return[$Failed]];
   Expand[
    Lookup[data, "constantPrefactor", 1]
     Times @@ MapThread[Power, {expressions, powers}]
     Times @@ (Power[Lookup[#, "parameter"], Lookup[#, "prefactorPower"]] & /@ residualParts)
    ]
   ];


sectorPrefactorDataForIntegral018[topo_Association, int : J[_, linePacks_List, _]] := Module[
   {metadata, frozenData, pattern, shrunkLines},
   (* 020 time-only 的 sector 身份已经由公开 key 和冻结 metadata 唯一确定；逆转换后的
      旧 pack 只服务 producer，不能再次推断 normalization，否则会丢失 child zero point 幂。 *)
   If[Lookup[topo, "ibpMode", "full"] === "timeOnly",
    metadata = integralSectorMetadata018[topo, int];
    frozenData = If[
      AssociationQ[metadata],
      Lookup[metadata, "sectorPrefactorData", Missing["NoSectorPrefactorData"]],
      Missing["NoSectorMetadata"]
      ];
    If[AssociationQ[frozenData], Return[frozenData]]
    ];
   pattern = sectorPattern018[topo, linePacks];
   shrunkLines = sectorShrunkLinesFromPattern018[pattern];
   sectorPrefactorData018[topo, shrunkLines]
   ];


normalizeContactTerm018[topo_Association, sourceInt_J, rawTerm_] := Module[
   {targets, targetInt, rawCoefficient, sourceData, targetData, ratio},
   targets = DeleteDuplicates[Cases[rawTerm, _J, {0, Infinity}]];
   If[Length[targets] =!= 1, Return[$Failed]];
   targetInt = First[targets];
   rawCoefficient = Cancel[rawTerm/targetInt];
   sourceData = sectorPrefactorDataForIntegral018[topo, sourceInt];
   targetData = sectorPrefactorDataForIntegral018[topo, targetInt];
   ratio = Cancel[
     materializeSectorPrefactor018[sourceData]/materializeSectorPrefactor018[targetData]
     ];
   Expand[rawCoefficient ratio targetInt]
   ];


sectorPrefactorRatio018[source_Association, target_Association] := Cancel[
   materializeSectorPrefactor018[Lookup[source, "sectorPrefactorData", <||>]]/
    materializeSectorPrefactor018[Lookup[target, "sectorPrefactorData", <||>]]
   ];


sectorPrefactorLogDerivative018[metadata_Association, variable_] := Cancel[
   D[materializeSectorPrefactor018[Lookup[metadata, "sectorPrefactorData", <||>]], variable]/
    materializeSectorPrefactor018[Lookup[metadata, "sectorPrefactorData", <||>]]
   ];


(* 按 sectorKey 从 DSInit 冻结的 metadata 读取物理 prefactor。tree dlog、naive DE 与
   普通 ds 必须共用这一份数据，不能从 contact coefficient 或旧 pack 反推连续零点幂。 *)
sectorPrefactorRecordForKey018[context_Association, sectorKey_] := Module[
   {metadata, data, prefactor},
   metadata = SelectFirst[
     Lookup[context, "sectors", {}],
     Lookup[#, "sectorKey", None] === sectorKey &,
     Missing["NoSectorMetadata", sectorKey]
     ];
   If[Head[metadata] === Missing, Return[metadata]];
   data = Lookup[metadata, "sectorPrefactorData", Missing["NoSectorPrefactorData", sectorKey]];
   If[Head[data] === Missing, Return[data]];
   prefactor = materializeSectorPrefactor018[data];
   If[prefactor === $Failed, Return[Missing["InvalidSectorPrefactorData", sectorKey]]];
   <|
    "sectorKey" -> sectorKey,
    "physicalSectorPrefactorData" -> data,
    "physicalSectorPrefactor" -> prefactor
    |>
   ];


(* 旧 016 metadata builder 已改名为 makeSectorMetadataBase018；此包装层只增加 018
   不变量，不复制 vertex/line slot 的既有构造。 *)
makeSectorMetadata[topo_Association] := Module[
   {base, pattern, shrunkLines, lineSlots, ispSlots, parityData, timeOnlyStateSlots},
   base = makeSectorMetadataBase018[topo];
   pattern = sectorPattern018[topo, Lookup[Lookup[base, "lineSlots", {}], "packTemplate", {}]];
   shrunkLines = sectorShrunkLinesFromPattern018[pattern];
   lineSlots = MapThread[
     Join[#1, <|
        "rootLinePosition" -> #2,
        "powerSlotKind" -> Lookup[pattern[[#2]], "powerKind"],
        "shrunkQ" -> (Lookup[pattern[[#2]], "state"] === "shrunk")
        |>] &,
     {Lookup[base, "lineSlots", {}], Range[Length[pattern]]}
     ];
   ispSlots = If[Lookup[topo, "ibpMode", "full"] === "timeOnly", {}, Lookup[base, "ispSlots", {}]];
   parityData = If[Length[DownValues[parityMetadataForSector018]] > 0,
     parityMetadataForSector018[topo],
     <|"status" -> "notLoaded"|>
     ];
    timeOnlyStateSlots = If[
      Lookup[topo, "ibpMode", "full"] === "timeOnly" &&
       Length[DownValues[dsTimeOnlyStateSlots020]] > 0,
      dsTimeOnlyStateSlots020[topo, Join[base, <|"lineSlots" -> lineSlots|>]],
      {}
      ];
    Join[base, <|
      "rootLineCount" -> Length[pattern],
      "rootLineOrder" -> Lookup[topo["lines"], "id", Range[Length[pattern]]],
      "ibpMode" -> Lookup[topo, "ibpMode", "full"],
      "sectorShrunkLines" -> shrunkLines,
      "sectorPattern" -> pattern,
      "sectorKey" -> sectorKeyFromPattern018[topo, pattern],
      "sectorBits" -> If[
        Lookup[topo, "ibpMode", "full"] === "timeOnly",
        Characters[sectorKeyFromPattern018[topo, pattern]],
        Missing["NotTimeOnlyBitString"]
        ],
      "sectorKeySchema" -> sectorKeySchemaFromTopology[topo],
      "lineSlots" -> lineSlots,
      "ispSlots" -> ispSlots,
      "timeOnlyStateSlots" -> timeOnlyStateSlots,
      "timeOnlyStateCount" -> Length[timeOnlyStateSlots],
      "publicIntegralRepresentation" -> If[
        Lookup[topo, "ibpMode", "full"] === "timeOnly",
        "J[sectorKey,timeShifts,stateBits]",
        "J[aList,linePacks,ispList]"
        ],
     "sectorPrefactorData" -> sectorPrefactorData018[topo],
     "builtInRelationData" -> If[Length[DownValues[masslessBuiltInRelationData018]] > 0,
       masslessBuiltInRelationData018[topo],
       {}
       ],
     "parityData" -> parityData,
      "representation" -> If[
        Lookup[topo, "ibpMode", "full"] === "timeOnly",
        "J[sectorKey,timeShifts,stateBits]",
        "J[aList,linePacks,ispList]"
        ]
      |>]
   ];


integralSectorMetadata018[topo_Association, int_J] := Module[{metadataList, matches},
   metadataList = Lookup[topo, "sectorMetadataList", {makeSectorMetadata[topo]}];
   matches = Select[metadataList, integralMatchesSectorMetadataQ[int, #] &];
   Which[
    Length[matches] === 1, First[matches],
    Length[matches] === 0, Missing["NoMatchingSector"],
    True, Missing["AmbiguousSector", Lookup[matches, "sectorKey", {}]]
    ]
   ];


sectorTopologyForMetadata018[rootTopo_Association, metadata_Association] := Module[{shrunk},
   shrunk = Lookup[metadata, "sectorShrunkLines", {}];
   If[shrunk === {}, rootTopo, shrinkSectorTopology[rootTopo, shrunk]]
   ];


sectorTopologyForIntegral018[rootTopo_Association, int_J] := Module[{metadata},
   metadata = integralSectorMetadata018[rootTopo, int];
   If[Head[metadata] === Missing, metadata, sectorTopologyForMetadata018[rootTopo, metadata]]
   ];


(* ::Chapter:: *)
(*Sector-aware 公开 shape gate*)

publicIntegralShapeIssues[topo_Association, int : J[aList_, linePacks_, ispList_]] := Module[
   {metadata, issues = {}, lineSlots, expectedISP},
   metadata = integralSectorMetadata018[topo, int];
   If[Head[metadata] === Missing,
    Return[{<|"slot" -> "sector", "reason" -> metadata|>}]
    ];
   lineSlots = Lookup[metadata, "lineSlots", {}];
   expectedISP = Length[Lookup[metadata, "ispSlots", {}]];
   If[Length[aList] =!= Length[Lookup[metadata, "compactASlots", {}]],
    AppendTo[issues, <|"slot" -> "aList", "expected" -> Length[Lookup[metadata, "compactASlots", {}]], "actual" -> Length[aList]|>]
    ];
   If[Length[linePacks] =!= Length[lineSlots],
    AppendTo[issues, <|"slot" -> "linePacks", "expected" -> Length[lineSlots], "actual" -> Length[linePacks]|>],
    Do[
     If[! ListQ[linePacks[[e]]] || ! linePackMatchesSlotQ[linePacks[[e]], lineSlots[[e]]],
      AppendTo[issues, <|"slot" -> "linePack", "lineIndex" -> e,
        "expected" -> Lookup[lineSlots[[e]], "packTemplate", {}], "actual" -> linePacks[[e]]|>]
      ],
     {e, Length[linePacks]}
     ]
    ];
   If[Length[ispList] =!= expectedISP,
    AppendTo[issues, <|"slot" -> "ispList", "expected" -> expectedISP, "actual" -> Length[ispList]|>]
    ];
   issues
   ];


publicResolvedDiscreteStateIssues[topo_Association, int : J[_, linePacks_, _]] := Module[
   {metadata, issues = {}, lineSlots, positions},
   metadata = integralSectorMetadata018[topo, int];
   If[Head[metadata] === Missing, Return[{<|"slot" -> "sector", "reason" -> metadata|>}]];
   lineSlots = Lookup[metadata, "lineSlots", {}];
   Do[
    positions = Lookup[lineSlots[[e]], "nPositions", {}];
    Do[
     If[! MemberQ[{0, 1}, linePacks[[e, p]]],
      AppendTo[issues, <|"lineIndex" -> e, "packPosition" -> p, "value" -> linePacks[[e, p]]|>]
      ],
     {p, positions}
     ],
    {e, Length[lineSlots]}
    ];
   issues
   ];


(* 020 time-only 公开对象先按冻结的 sector/state registry 还原为 producer 表示；
   shape 与离散态门禁仍由同一套既有检查负责，避免维护第二套物理规则。 *)
publicIntegralShapeIssues[topo_Association, int : J[_String, _List, _List]] /;
   Lookup[topo, "ibpMode", "full"] === "timeOnly" := Module[{internal},
   internal = dsTimeOnlyPublicIntegralToInternal020[int, topo];
   If[
    internal === $Failed,
    {<|"slot" -> "timeOnlyIntegral", "reason" -> "invalidPublicTimeOnlyIntegral", "integral" -> int|>},
    publicIntegralShapeIssues[topo, internal]
    ]
   ];


publicResolvedDiscreteStateIssues[topo_Association, int : J[_String, _List, _List]] /;
   Lookup[topo, "ibpMode", "full"] === "timeOnly" := Module[{internal},
   internal = dsTimeOnlyPublicIntegralToInternal020[int, topo];
   If[
    internal === $Failed,
    {<|"slot" -> "timeOnlyIntegral", "reason" -> "invalidPublicTimeOnlyIntegral", "integral" -> int|>},
    publicResolvedDiscreteStateIssues[topo, internal]
    ]
   ];


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

(* ::Package:: *)
(***
文件：TimeOnlyRepresentation020.wl
用途：定义 020 time-only 公开积分 J[sectorKey,timeShifts,stateBits] 与内部
      J[aList,linePacks,{}] 的唯一双向转换，并提供表达式/数据容器级转换。
核心逻辑：sectorKey 只负责 sector 身份；timeShifts 保存当前 sector 的紧致时间幂指标；
          stateBits 按初始化 metadata 冻结的 root line/endpoint 顺序保存离散 n 态。
边界：full 模式不经过本模块；旧三槽 time-only 对象只允许存在于 Private 内部。
***)


(* ::Chapter:: *)
(*Time-only sector 与 slot metadata*)

(* 从 context 或 parsed topology 取得同一份 root topology；转换规则不得依赖调用方猜测。 *)
dsTimeOnlyTopology020[data_Association] := If[
   KeyExistsQ[data, "topology"] && AssociationQ[data["topology"]],
   data["topology"],
   data
   ];


dsTimeOnlyMetadataList020[data_Association] := Module[{topo = dsTimeOnlyTopology020[data]},
   If[
    KeyExistsQ[data, "sectors"],
    Lookup[data, "sectors", {}],
    Lookup[topo, "sectorMetadataList", {makeSectorMetadata[topo]}]
    ]
   ];


dsTimeOnlyModeQ020[data_Association] :=
  Lookup[dsTimeOnlyTopology020[data], "ibpMode", "full"] === "timeOnly";


dsTimeOnlySectorMetadata020[data_Association, sectorKey_String] := SelectFirst[
   dsTimeOnlyMetadataList020[data],
   Lookup[#, "sectorKey", None] === sectorKey &,
   Missing["UnknownTimeOnlySector", sectorKey]
   ];


(* 每个 slot 直接保存旧 line pack 中的位置；双向转换因此只读取 metadata，不重复推断图。 *)
dsTimeOnlyStateSlots020[topo_Association, metadata_Association] := Module[
   {lines = Lookup[topo, "lines", {}], lineSlots = Lookup[metadata, "lineSlots", {}]},
   Flatten@MapThread[
     Function[{line, lineSlot, linePosition},
      If[TrueQ[Lookup[lineSlot, "shrunkQ", False]],
       {},
       Switch[
        Lookup[line, "packType", ""],
        "massiveFull" | "massiveCross",
        Table[
         <|
          "lineId" -> Lookup[line, "id", linePosition],
          "rootLinePosition" -> linePosition,
          "kind" -> "massiveEndpoint",
          "endpointSlot" -> endpointSlot,
          "packPosition" -> 1 + endpointSlot
          |>,
         {endpointSlot, 2}
         ],
        "masslessFull",
        {<|
          "lineId" -> Lookup[line, "id", linePosition],
          "rootLinePosition" -> linePosition,
          "kind" -> "masslessShared",
          "endpointSlot" -> "shared",
          "packPosition" -> 2
          |>},
        _,
        {}
        ]
       ]
      ],
     {lines, lineSlots, Range[Length[lines]]}
     ]
   ];


dsTimeOnlyStateSlotsForMetadata020[topo_Association, metadata_Association] := Lookup[
   metadata,
   "timeOnlyStateSlots",
   dsTimeOnlyStateSlots020[topo, metadata]
   ];


(* ::Chapter:: *)
(*单积分双向转换*)

dsTimeOnlyInternalIntegralToPublic020[
   int : J[aList_List, linePacks_List, {}],
   data_Association
   ] := Module[{topo, metadata, sectorKey, slots, stateBits},
   topo = dsTimeOnlyTopology020[data];
   If[! dsTimeOnlyModeQ020[data], Return[int]];
   metadata = integralSectorMetadata018[topo, int];
   If[Head[metadata] === Missing, Return[$Failed]];
   sectorKey = Lookup[metadata, "sectorKey", Missing["NoSectorKey"]];
   slots = dsTimeOnlyStateSlotsForMetadata020[topo, metadata];
   If[! StringQ[sectorKey] || Length[aList] =!= Length[Lookup[metadata, "compactASlots", {}]],
    Return[$Failed]
    ];
   stateBits = Extract[
      linePacks,
      ({#rootLinePosition, #packPosition} &) /@ slots
      ];
   If[! VectorQ[stateBits, MemberQ[{0, 1}, #] &], Return[$Failed]];
   J[sectorKey, aList, stateBits]
   ];


dsTimeOnlyInternalIntegralToPublic020[int_J, data_Association] := If[
   dsTimeOnlyModeQ020[data],
   $Failed,
   int
   ];


dsTimeOnlyPublicIntegralToInternal020[
   int : J[sectorKey_String, timeShifts_List, stateBits_List],
   data_Association
   ] := Module[{topo, metadata, slots, linePacks, lines, lineSlots},
   topo = dsTimeOnlyTopology020[data];
   If[! dsTimeOnlyModeQ020[data], Return[$Failed]];
   metadata = dsTimeOnlySectorMetadata020[data, sectorKey];
   If[Head[metadata] === Missing, Return[$Failed]];
   slots = dsTimeOnlyStateSlotsForMetadata020[topo, metadata];
   If[
    Length[timeShifts] =!= Length[Lookup[metadata, "compactASlots", {}]] ||
     Length[stateBits] =!= Length[slots] ||
     ! VectorQ[stateBits, MemberQ[{0, 1}, #] &],
    Return[$Failed]
    ];
   lineSlots = Lookup[metadata, "lineSlots", {}];
   lines = Lookup[topo, "lines", {}];
   linePacks = Lookup[lineSlots, "packTemplate", {}];
   If[Length[linePacks] =!= Length[Lookup[topo, "lines", {}]], Return[$Failed]];
   Do[
    linePacks = ReplacePart[
      linePacks,
      {slots[[slotPosition, "rootLinePosition"]], slots[[slotPosition, "packPosition"]]} ->
       stateBits[[slotPosition]]
      ],
    {slotPosition, Length[slots]}
    ];
   (* quotient massless 的被消去端点槽固定为 0；cross/收缩占位由 sector packTemplate 恢复。 *)
   Do[
    If[
     ! TrueQ[Lookup[lineSlots[[linePosition]], "shrunkQ", False]] &&
      Lookup[lines[[linePosition]], "packType", ""] === "masslessFull",
     linePacks = ReplacePart[linePacks, {linePosition, 3} -> 0]
     ],
    {linePosition, Length[lines]}
    ];
   J[timeShifts, linePacks, {}]
   ];


dsTimeOnlyPublicIntegralToInternal020[int_J, data_Association] := If[
   dsTimeOnlyModeQ020[data],
   $Failed,
   int
   ];


(* ::Chapter:: *)
(*表达式与 Association 边界转换*)

dsTimeOnlyExpressionToPublic020[expr_, data_Association] := Module[{result},
   If[! dsTimeOnlyModeQ020[data], Return[expr]];
   result = expr /. int : J[_List, _List, {}] :>
      dsTimeOnlyInternalIntegralToPublic020[int, data];
   If[FreeQ[result, $Failed], result, $Failed]
   ];


dsTimeOnlyExpressionToInternal020[expr_, data_Association] := Module[{result, oldIntegrals},
   If[! dsTimeOnlyModeQ020[data], Return[expr]];
   oldIntegrals = ! FreeQ[expr, J[_List, _List, _List]];
   If[TrueQ[oldIntegrals], Return[$Failed]];
   result = expr /. int : J[_String, _List, _List] :>
      dsTimeOnlyPublicIntegralToInternal020[int, data];
   If[FreeQ[result, $Failed], result, $Failed]
   ];


dsTimeOnlyDataToPublic020[value_Association, data_Association] := Association@KeyValueMap[
   dsTimeOnlyDataToPublic020[#1, data] -> dsTimeOnlyDataToPublic020[#2, data] &,
   value
   ];
dsTimeOnlyDataToPublic020[value_List, data_Association] :=
  dsTimeOnlyDataToPublic020[#, data] & /@ value;
dsTimeOnlyDataToPublic020[value_, data_Association] :=
  dsTimeOnlyExpressionToPublic020[value, data];


dsTimeOnlyDataToInternal020[value_Association, data_Association] := Association@KeyValueMap[
   dsTimeOnlyDataToInternal020[#1, data] -> dsTimeOnlyDataToInternal020[#2, data] &,
   value
   ];
dsTimeOnlyDataToInternal020[value_List, data_Association] :=
  dsTimeOnlyDataToInternal020[#, data] & /@ value;
dsTimeOnlyDataToInternal020[value_, data_Association] :=
  dsTimeOnlyExpressionToInternal020[value, data];


dsTimeOnlyOldIntegralLeakQ020[value_Association] := AnyTrue[
   Values[value],
   dsTimeOnlyOldIntegralLeakQ020
   ];
dsTimeOnlyOldIntegralLeakQ020[value_List] := AnyTrue[
   value,
   dsTimeOnlyOldIntegralLeakQ020
   ];
dsTimeOnlyOldIntegralLeakQ020[value_] := ! FreeQ[value, J[_List, _List, _List]];


dsTimeOnlyPublicIntegralQ020[int_, data_Association] := Module[{internal},
   If[! MatchQ[int, J[_String, _List, _List]], Return[False]];
   internal = dsTimeOnlyPublicIntegralToInternal020[int, data];
   MatchQ[internal, J[_List, _List, {}]]
   ];

(* ::Package:: *)
(* 本模块统一 018 的 massless 双端点 relation、sector-aware canonical/求导和 parity seed 域。
   parity 只筛选待作用生成元的 seed 点；生成后证书只报告错误，绝不把积分替换为零。 *)

(* ::Chapter:: *)
(*Massless 双端点 quotient*)

masslessFullLineQ018[line_Association] := Lookup[line, "packType", ""] === "masslessFull" &&
   Lookup[line, "state", "full"] =!= "shrunk";


canonicalizeMasslessIntegral018[
   topo_Association,
   int : J[aList_, linePacks_, ispList_]
   ] := Module[{newPacks = linePacks, coefficient = 1, positions, n1, n2},
   Do[
    If[actualLinePackType[topo, e, newPacks[[e]]] =!= "masslessFull", Continue[]];
    positions = linePackNPositions[topo["lines"][[e]], "masslessFull"];
    {n1, n2} = newPacks[[e, positions]];
    If[MemberQ[{0, 1}, n1] && MemberQ[{0, 1}, n2] && n2 === 1,
     coefficient = -coefficient;
     newPacks[[e, positions]] = {1 - n1, 0}
     ],
    {e, Length[topo["lines"]]}
    ];
   coefficient J[aList, newPacks, ispList]
   ];


masslessCoincidentAntisymmetricIntegralQ[
   topo_Association,
   int : J[_, linePacks_, _]
   ] := Module[{repMap, originalEndpoints, targetEndpoints, positions, states},
   repMap = integralTargetVertexRepresentativeMap[topo, int];
   AnyTrue[
    Range[Length[topo["lines"]]],
    Function[e,
     If[actualLinePackType[topo, e, linePacks[[e]]] =!= "masslessFull",
      False,
      originalEndpoints = Lookup[topo["lines"][[e]], "originalEndpoints", topo["lines"][[e, "endpoints"]]];
      targetEndpoints = Lookup[repMap, originalEndpoints];
      positions = linePackNPositions[topo["lines"][[e]], "masslessFull"];
      states = linePacks[[e, positions]];
      TrueQ[SameQ @@ targetEndpoints && And @@ (IntegerQ /@ states) && OddQ[Total[states]]]
      ]
     ]
    ]
   ];


applyMasslessEndpointCanonical[expr_, topo_Association] := Module[{quotient},
   quotient = Expand[expr /. int_J :> canonicalizeMasslessIntegral018[topo, int]];
   Expand[quotient /. (int_J /; masslessCoincidentAntisymmetricIntegralQ[topo, int]) :> 0]
   ];


masslessBuiltInRelationData018[topo_Association] := Map[
   Function[e,
    With[{id = topo["lines"][[e, "id"]]},
     <|
      "lineIndex" -> e,
      "lineId" -> id,
      "relations" -> {
        HoldForm[F[id, 0, 1] + F[id, 1, 0] == 0],
        HoldForm[F[id, 1, 1] + F[id, 0, 0] == 0]
        },
      "canonicalDirection" -> "n2ToZero"
      |>
     ]
    ],
   Select[Range[topo["nE"]], masslessFullLineQ018[topo["lines"][[#]]] &]
   ];


forbiddenNDataForIntegral[topo_Association, J[_, linePacks_, _]] := Module[
   {issues = {}, packType, positions, values},
   Do[
    packType = actualLinePackType[topo, e, linePacks[[e]]];
    positions = linePackNPositions[topo["lines"][[e]], packType];
    values = If[positions === {}, {}, linePacks[[e, positions]]];
    Switch[packType,
     "massiveFull" | "massiveCross",
     Do[
      If[IntegerQ[values[[endpointSlot]]] && values[[endpointSlot]] >= 2,
       AppendTo[issues, <|"lineIndex" -> e, "packType" -> packType,
         "endpointSlot" -> endpointSlot, "nValue" -> values[[endpointSlot]]|>]
       ],
      {endpointSlot, Length[values]}
      ],
     "masslessFull",
     Do[
      If[IntegerQ[values[[endpointSlot]]] && ! MemberQ[{0, 1}, values[[endpointSlot]]],
       AppendTo[issues, <|"lineIndex" -> e, "packType" -> packType,
         "endpointSlot" -> endpointSlot, "nValue" -> values[[endpointSlot]]|>]
       ],
      {endpointSlot, Length[values]}
      ],
     _, Null
     ],
    {e, Length[topo["lines"]]}
    ];
   issues
   ];


(* ::Chapter:: *)
(*Massless regular 与 contact 原子*)

toggleMasslessEndpointState018[
   J[aList_, linePacks_, ispList_], e_Integer, endpointSlot_Integer
   ] := Module[{newPacks = linePacks, position},
   position = 1 + endpointSlot;
   newPacks[[e, position]] = 1 - newPacks[[e, position]];
   J[aList, newPacks, ispList]
   ];


toggleMasslessLineState[topo_Association, int_J, e_Integer] :=
  toggleMasslessEndpointState018[int, e, 1];


timeMasslessEndpointDerivativeTerms[
   topo_Association,
   int : J[_, linePacks_, _],
   vertexId_
   ] := Module[{pos, connectedLines, line, endpointSlots, sigma, shiftedIntegral},
   pos = vertexPosition[topo, vertexId];
   If[Head[pos] === Missing, Return[0]];
   connectedLines = topo["vertexLines"][[pos]][[All, 1]];
   Total@Table[
     line = topo["lines"][[e]];
     endpointSlots = lineEndpointSlotsAtVertex[line, vertexId];
     Switch[actualLinePackType[topo, e, linePacks[[e]]],
      "masslessFull",
      sigma = masslessFullSKSign[line];
      Total@Table[
        shiftedIntegral = shiftLinePower[
          topo, toggleMasslessEndpointState018[int, e, endpointSlot], e, -1
          ];
        I sigma shiftedIntegral,
        {endpointSlot, endpointSlots}
        ],
      "masslessCross",
      Total@Table[
        I skEndpointPhaseSign[line, endpointSlot] shiftLinePower[topo, int, e, -1],
        {endpointSlot, endpointSlots}
        ],
      _, 0
      ],
     {e, connectedLines}
     ]
   ];


momentumBuildingBlockDerivativeTerms[
   topo_Association, int_J, gen_Association, repSP2ZRules_List
   ] := Module[
   {dLoop = gen["dLoop"], vector = gen["vector"], lineMomenta, line, loopCoeff,
    vDotQ, packType, sigma, shiftedInt},
   lineMomenta = Lookup[topo["lines"], "momentum"];
   Total@Table[
     line = topo["lines"][[e]];
     loopCoeff = Coefficient[lineMomenta[[e]], topo["loopMomenta"][[dLoop]]];
     If[zeroQ[loopCoeff],
      0,
      vDotQ = Expand[expandDotExpr[vector, lineMomenta[[e]], topo] /. repSP2ZRules];
      packType = actualLinePackType[topo, e, int[[2, e]]];
      Switch[packType,
       "massiveFull" | "massiveCross",
       Total@Table[
         loopCoeff compiledMomentumEndpointDerivativeTerms[topo, int, e, endpointSlot, vDotQ],
         {endpointSlot, 2}
         ],
       "masslessFull",
       sigma = masslessFullSKSign[line];
       loopCoeff Total@Table[
         shiftedInt = shiftLinePower[
           topo, toggleMasslessEndpointState018[int, e, endpointSlot], e, 1
           ];
         -I sigma absorbLinearFactor[
           vDotQ,
           shiftVertexA[shiftedInt, topo, line["endpoints"][[endpointSlot]], 1],
           topo
           ],
         {endpointSlot, 2}
         ],
       "masslessCross",
       shiftedInt = shiftLinePower[topo, int, e, 1];
       loopCoeff Total@Table[
         -I skEndpointPhaseSign[line, endpointSlot] absorbLinearFactor[
           vDotQ,
           shiftVertexA[shiftedInt, topo, line["endpoints"][[endpointSlot]], 1],
           topo
           ],
         {endpointSlot, 2}
         ],
       _, 0
       ]
      ],
     {e, topo["nE"]}
     ]
   ];


externalVectorBuildingBlockDerivativeTerms[
   topo_Association, int_J, gen_Association, repSP2ZRules_List
   ] := Module[
   {dExternal = gen["dExternal"], vector = gen["vector"], lineMomenta, line, extCoeff,
    vDotQ, packType, sigma, shiftedInt},
   lineMomenta = Lookup[topo["lines"], "momentum"];
   Total@Table[
     line = topo["lines"][[e]];
     extCoeff = Coefficient[lineMomenta[[e]], topo["effectiveLoopExternalMomenta"][[dExternal]]];
     If[zeroQ[extCoeff] || externalLegCoordinateLineQ[lineMomenta[[e]], topo],
      0,
      vDotQ = Expand[expandDotExpr[vector, lineMomenta[[e]], topo] /. repSP2ZRules];
      packType = actualLinePackType[topo, e, int[[2, e]]];
      Switch[packType,
       "massiveFull" | "massiveCross",
       Total@Table[
         extCoeff compiledMomentumEndpointDerivativeTerms[topo, int, e, endpointSlot, vDotQ],
         {endpointSlot, 2}
         ],
       "masslessFull",
       sigma = masslessFullSKSign[line];
       extCoeff Total@Table[
         shiftedInt = shiftLinePower[
           topo, toggleMasslessEndpointState018[int, e, endpointSlot], e, 1
           ];
         -I sigma absorbLinearFactor[
           vDotQ,
           shiftVertexA[shiftedInt, topo, line["endpoints"][[endpointSlot]], 1],
           topo
           ],
         {endpointSlot, 2}
         ],
       "masslessCross",
       shiftedInt = shiftLinePower[topo, int, e, 1];
       extCoeff Total@Table[
         -I skEndpointPhaseSign[line, endpointSlot] absorbLinearFactor[
           vDotQ,
           shiftVertexA[shiftedInt, topo, line["endpoints"][[endpointSlot]], 1],
           topo
           ],
         {endpointSlot, 2}
         ],
       _, 0
       ]
      ],
     {e, topo["nE"]}
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
    Total@Table[
      -I sigma shiftVertexA[
        toggleMasslessEndpointState018[int, e, endpointSlot],
        topo, line["endpoints"][[endpointSlot]], 1
        ],
      {endpointSlot, 2}
      ],
    "masslessCross",
    Total@Table[
      -I skEndpointPhaseSign[line, endpointSlot] shiftVertexA[
        int, topo, line["endpoints"][[endpointSlot]], 1
        ],
      {endpointSlot, 2}
      ],
    _, 0
    ]
   ];


thetaBoundaryAtomicTerms[
   topo_Association,
   J[aList_, linePacks_, ispList_],
   e_Integer,
   vertexId_
   ] := Module[
   {line = topo["lines"][[e]], endpointSlots, endpointSlot, endpointOrientation,
    pack = linePacks[[e]], packType, positions, coeff, shrinkTerms},
   endpointSlots = lineEndpointSlotsAtVertex[line, vertexId];
   If[Length[endpointSlots] =!= 1, Return[{}]];
   endpointSlot = First[endpointSlots];
   endpointOrientation = If[endpointSlot === 1, 1, -1];
   packType = actualLinePackType[topo, e, pack];
   Switch[packType,
    "massiveFull",
    positions = linePackNPositions[line, packType];
     coeff = KroneckerDelta[Total[pack[[positions]]], 1]
        (-1)^(pack[[positions[[endpointSlot]]]] + thetaBoundarySignOffset[topo, e]);
    shrinkTerms = lineCompiledShrinkTerms[line];
    (<|
        "lineIndex" -> e,
        "coefficient" -> coeff Lookup[#, "coefficient", 0],
        "bShift" -> Lookup[#, "bShift", 1],
        "zeroPointShift" -> Lookup[#, "zeroPointShift", lineShrinkZeroPointShift[line]],
        "aShift" -> Lookup[#, "bShift", 1]
        |> &) /@ shrinkTerms,
    "masslessFull",
    positions = linePackNPositions[line, packType];
    {<|
      "lineIndex" -> e,
      "coefficient" -> -2 endpointOrientation
        KroneckerDelta[Total[pack[[positions]]], 1] (-1)^pack[[positions[[2]]]],
      "bShift" -> 0,
      "zeroPointShift" -> 0,
      "aShift" -> 0
      |>},
    _, {}
    ]
   ];


(* ::Chapter:: *)
(*Fixed-line shrink 与 normalized coefficient*)

fixedLineShrinkResidualPower018[
   topo_Association,
   e_Integer,
   integerShift_,
   zeroPointShift_
   ] := Module[{rootRules, id, sourceZero, targetZero},
   rootRules = Lookup[topo, "rootZeroPointRules", topo["zeroPointRules"]];
   id = topo["lines"][[e, "id"]];
   sourceZero = zeroPointRuleValue018[rootRules, b0[id], 0];
   targetZero = lineTargetShrinkZeroPoint018[topo, e];
   Expand[integerShift + zeroPointShift - (targetZero - sourceZero)]
   ];


shrinkLineIntegral[
   topo_Association, int : J[aList_, linePacks_, ispList_], e_Integer,
   bShift_: Automatic, aShift_: Automatic
   ] := Module[
   {line = topo["lines"][[e]], uSlot, vSlot, oldActive, newRepMap, newActive,
    newAList, newLinePacks = linePacks, mergedRep, oldSlotsForNewRep, slotValues,
    effectiveBShift, effectiveAShift, effectiveZeroPointShift, powerCoefficient},
   effectiveBShift = If[bShift === Automatic, lineShrinkBShift[line], bShift];
   effectiveZeroPointShift = lineShrinkZeroPointShift[line];
   effectiveAShift = If[aShift === Automatic,
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
     If[newActive[[i]] === mergedRep, Total[slotValues] - effectiveAShift, Total[slotValues]],
     {i, Length[newActive]}
     ];
   powerCoefficient = If[
     lineIndexedPowerQ[line],
     1,
     fixedLineMomentumMagnitude[topo, e]^(-effectiveBShift - effectiveZeroPointShift)
     ];
   newLinePacks[[e]] = If[
     lineIndexedPowerQ[line],
     {lineIntegerPowerIndex[topo, int, e] + effectiveBShift},
     {fixedLineSentinel018[]}
     ];
   powerCoefficient J[newAList, newLinePacks, ispList]
   ];


shrinkLinesIntegral[
   topo_Association,
   int : J[aList_, linePacks_, ispList_],
   specs_List
   ] := Module[
   {selectedLines, oldActive, pairs, newRepMap, newActive, newAList,
    newLinePacks = linePacks, oldSlotsForNewRep, selectedShiftForRep,
    powerCoefficient = 1},
   selectedLines = Lookup[specs, "lineIndex"];
   oldActive = activeAVertexIds[topo];
   pairs = topo["lines"][[#, "endpoints"]] & /@ selectedLines;
   newRepMap = vertexRepresentativeMap[topo["vertexIds"], Join[
      ({#, vertexRepresentative[topo, #]} & /@ topo["vertexIds"]), pairs
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
     If[lineIndexedPowerQ[topo["lines"][[spec["lineIndex"]]]],
      newLinePacks[[spec["lineIndex"]]] = {
        lineIntegerPowerIndex[topo, int, spec["lineIndex"]] + spec["bShift"]
        },
      powerCoefficient *= fixedLineMomentumMagnitude[topo, spec["lineIndex"]]^(
        -spec["bShift"] -
         Lookup[spec, "zeroPointShift", lineShrinkZeroPointShift[topo["lines"][[spec["lineIndex"]]]]]
        );
      newLinePacks[[spec["lineIndex"]]] = {fixedLineSentinel018[]}
      ]
     ],
    specs
    ];
   powerCoefficient J[newAList, newLinePacks, ispList]
   ];


(* ::Chapter:: *)
(*Sector-aware canonical、ds 与 integrand*)

(* fixed/non-loop line 的零点幂属于 N_s；裸积分核导数只微分有 b/bS 槽的
   cycle denominator。模式函数本身的动量导数仍由原 building-block 路线处理。 *)
lineBarePowerIndex018[topo_Association, int_J, e_Integer] := If[
   lineIndexedPowerQ[topo["lines"][[e]]],
   linePowerIndex[topo, int, e],
   0
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
     -lineBarePowerIndex018[topo, int, e] shiftLinePower[topo, int, e, 1] +
      scalarMomentumBuildingBlockDerivativeTerms[topo, int, e],
     {e, matchingLines}
     ]
   ];


externalVectorPropagatorDerivativeTerms[topo_Association, int_J, gen_Association, repSP2ZRules_List] := Module[
   {dExternal, vector, lineMomenta, extCoeff, vDotQ, shiftedInt},
   dExternal = gen["dExternal"];
   vector = gen["vector"];
   lineMomenta = Lookup[topo["lines"], "momentum"];
   Total@Table[
     extCoeff = Coefficient[lineMomenta[[e]], topo["effectiveLoopExternalMomenta"][[dExternal]]];
     If[zeroQ[extCoeff] || externalLegCoordinateLineQ[lineMomenta[[e]], topo],
      0,
      vDotQ = Expand[expandDotExpr[vector, lineMomenta[[e]], topo] /. repSP2ZRules];
      shiftedInt = shiftLinePower[topo, int, e, 2];
      -extCoeff lineBarePowerIndex018[topo, int, e] absorbLinearFactor[vDotQ, shiftedInt, topo]
      ],
     {e, topo["nE"]}
     ]
   ];

sectorAwareCanonicalTerm018[term_, rootTopo_Association] := Module[
   {integrals, int, coefficient, sectorTopo},
   integrals = DeleteDuplicates[Cases[term, _J, {0, Infinity}]];
   Which[
    integrals === {}, term,
    Length[integrals] =!= 1, $Failed,
    True,
    int = First[integrals];
    coefficient = Cancel[term/int];
    sectorTopo = sectorTopologyForIntegral018[rootTopo, int];
    If[Head[sectorTopo] === Missing, $Failed, applySeedCanonical[coefficient int, sectorTopo]]
    ]
   ];


sectorAwareCanonical018[expr_, rootTopo_Association] := Module[{terms, result},
   terms = linearTerms[Expand[expr]];
   result = sectorAwareCanonicalTerm018[#, rootTopo] & /@ terms;
   If[MemberQ[result, $Failed], $Failed, Expand[Total[result]]]
   ];


(* 连续撒点会反复命中同一批 sector。缓存只复用已经初始化的 sector topology，
   积分仍须与该 sector 的 shape metadata 匹配，不能用缓存绕过表示门禁。 *)
sectorTopologyCache018[rootTopo_Association, metadataList_List] := Module[
   {keys, entries, sectorTopo, symmetryRules, tadpoleData, postSamplingCanonicalRequiredQ},
   keys = Lookup[metadataList, "sectorKey", Missing["NoSectorKey"]];
   If[MemberQ[keys, _Missing] || DuplicateFreeQ[keys] =!= True,
    Return[Missing["InvalidSectorMetadataKeys", keys]]
    ];
   entries = Map[
     Function[metadata,
      sectorTopo = sectorTopologyForMetadata018[rootTopo, metadata];
      symmetryRules = effectiveSymmetryRules0[sectorTopo];
      If[
       ! ListQ[symmetryRules] || ! And @@ (validDiscreteReplacementRuleQ /@ symmetryRules),
       Return[Missing["InvalidSectorSymmetryRules", Lookup[metadata, "sectorKey"]], Module]
       ];
      tadpoleData = Select[
        tadpoleLoopReversalData[sectorTopo],
        MemberQ[{"massiveFull", "masslessFull"}, Lookup[#, "packType", None]] &&
          TrueQ[Lookup[#, "exclusiveLoopQ", False]] &
        ];
      (* EOM 与端点 canonical 已在 general template 层完成。只有用户规则可能依赖
         撒点后的具体指标，或 tadpole odd-ISP 判定需要整数 ISP 幂次时，才逐点重跑。 *)
      postSamplingCanonicalRequiredQ =
       Lookup[sectorTopo, "symmetryRules", {}] =!= {} ||
        (tadpoleData =!= {} && Lookup[sectorTopo, "ispData", {}] =!= {});
      Lookup[metadata, "sectorKey"] -> <|
        "metadata" -> metadata,
        "topology" -> sectorTopo,
        "symmetryRules" -> symmetryRules,
        "postSamplingCanonicalRequiredQ" -> postSamplingCanonicalRequiredQ
        |>
      ],
     metadataList
     ];
   Association[entries]
   ];


sectorCachePostSamplingCanonicalRequiredQ018[cache_Association] := AnyTrue[
   Values[cache],
   TrueQ[Lookup[#, "postSamplingCanonicalRequiredQ", True]] &
   ];


sectorKeyForIntegral018[
   rootTopo_Association,
   J[_, linePacks_List, _]
   ] := If[
   Length[linePacks] =!= Length[Lookup[rootTopo, "lines", {}]],
   Missing["LinePackCountMismatch"],
   sectorKeyFromPattern018[rootTopo, sectorPattern018[rootTopo, linePacks]]
   ];


sectorTopologyForIntegral018[
   rootTopo_Association,
   int_J,
   cache_Association
   ] := Module[{key, entry, metadata},
   key = sectorKeyForIntegral018[rootTopo, int];
   If[Head[key] === Missing, Return[key]];
   entry = Lookup[cache, key, Missing["NoMatchingSector", key]];
   If[Head[entry] === Missing, Return[entry]];
   metadata = Lookup[entry, "metadata", Missing["NoSectorMetadata", key]];
   If[Head[metadata] === Missing || ! TrueQ[integralMatchesSectorMetadataQ[int, metadata]],
    Return[Missing["SectorShapeMismatch", key]]
    ];
   Lookup[entry, "topology", Missing["NoSectorTopology", key]]
   ];


sectorEntryForIntegral018[
   rootTopo_Association,
   int_J,
   cache_Association
   ] := Module[{key, entry, metadata},
   key = sectorKeyForIntegral018[rootTopo, int];
   If[Head[key] === Missing, Return[key]];
   entry = Lookup[cache, key, Missing["NoMatchingSector", key]];
   If[Head[entry] === Missing, Return[entry]];
   metadata = Lookup[entry, "metadata", Missing["NoSectorMetadata", key]];
   If[Head[metadata] === Missing || ! TrueQ[integralMatchesSectorMetadataQ[int, metadata]],
    Return[Missing["SectorShapeMismatch", key]]
    ];
   entry
   ];


applySeedCanonicalWithRules018[
   expr_,
   topo_Association,
   symmetryRules_List
   ] := Expand[
   applyMasslessEndpointCanonical[
      applyMassiveCoincidentCanonical[applyEOM[expr, topo], topo],
      topo
      ] /. symmetryRules
   ];


sectorAwareSymmetryTerm018[
   term_,
   rootTopo_Association,
   cache_Association
   ] := Module[{integrals, int, coefficient, sectorEntry, symmetryRules},
   integrals = DeleteDuplicates[Cases[term, _J, {0, Infinity}]];
   Which[
    integrals === {}, term,
    Length[integrals] =!= 1, $Failed,
    True,
    int = First[integrals];
    coefficient = Cancel[term/int];
    sectorEntry = sectorEntryForIntegral018[rootTopo, int, cache];
    If[Head[sectorEntry] === Missing, Return[$Failed, Module]];
    symmetryRules = Lookup[sectorEntry, "symmetryRules", Missing["NoSectorSymmetryRules"]];
    If[Head[symmetryRules] === Missing, $Failed, Expand[coefficient int /. symmetryRules]]
    ]
   ];


sectorAwareSymmetry018[
   expr_,
   rootTopo_Association,
   cache_Association
   ] := Module[{terms, result},
   terms = linearTerms[Expand[expr]];
   result = sectorAwareSymmetryTerm018[#, rootTopo, cache] & /@ terms;
   If[MemberQ[result, $Failed], $Failed, Expand[Total[result]]]
   ];


sectorAwareCanonicalTerm018[
   term_,
   rootTopo_Association,
   cache_Association
   ] := Module[{integrals, int, coefficient, sectorEntry, sectorTopo, symmetryRules},
   integrals = DeleteDuplicates[Cases[term, _J, {0, Infinity}]];
   Which[
    integrals === {}, term,
    Length[integrals] =!= 1, $Failed,
    True,
    int = First[integrals];
    coefficient = Cancel[term/int];
    sectorEntry = sectorEntryForIntegral018[rootTopo, int, cache];
    If[Head[sectorEntry] === Missing, Return[$Failed, Module]];
    sectorTopo = Lookup[sectorEntry, "topology", Missing["NoSectorTopology"]];
    symmetryRules = Lookup[sectorEntry, "symmetryRules", Missing["NoSectorSymmetryRules"]];
    If[
     Head[sectorTopo] === Missing || Head[symmetryRules] === Missing,
     $Failed,
     applySeedCanonicalWithRules018[coefficient int, sectorTopo, symmetryRules]
     ]
    ]
   ];


sectorAwareCanonical018[
   expr_,
   rootTopo_Association,
   cache_Association
   ] := Module[{terms, result},
   terms = linearTerms[Expand[expr]];
   result = sectorAwareCanonicalTerm018[#, rootTopo, cache] & /@ terms;
   If[MemberQ[result, $Failed], $Failed, Expand[Total[result]]]
   ];


ds[expr_, userVariable_, topoSpec_Association] := Module[
   {rootTopo, internalExpr, variableData, userVariables, userExpr, linearData, internalVariable,
     coefficientDerivative, integralDerivativeTerms, sectorTopo, prefactorData,
     prefactorLogDerivative, result},
   rootTopo = resolvePublicTopologyContext[topoSpec];
   If[rootTopo === $Failed, Return[$Failed]];
   If[! dsTopologyCapabilityQ[rootTopo, "derivativeUsableQ"],
    dsErrorPrint["当前参数声明不支持唯一 ds 微分算符。 The current parameter declaration does not define a unique ds operator."];
    Return[$Failed]
    ];
   userVariables = Lookup[publicIndependentVariableDerivativeData[rootTopo], "userVariable", {}];
   variableData = resolvePublicIndependentVariableDerivativeData[rootTopo, userVariable];
    If[Head[variableData] === Missing,
     Message[dSIBPPublicAPI::badvar, userVariable, userVariables]; Return[$Failed]
     ];
    internalExpr = If[
      Lookup[rootTopo, "ibpMode", "full"] === "timeOnly",
      dsTimeOnlyExpressionToInternal020[expr, rootTopo],
      expr
      ];
    If[internalExpr === $Failed, Return[$Failed]];
    userExpr = rep2outform[internalExpr, rootTopo];
   If[userExpr === $Failed || ! validatePublicExpression[userExpr, rootTopo, True], Return[$Failed]];
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
      sectorTopo = sectorTopologyForIntegral018[rootTopo, int];
       If[Head[sectorTopo] === Missing,
        $Failed,
        prefactorData = sectorPrefactorDataForIntegral018[rootTopo, int];
        prefactorLogDerivative = sectorPrefactorLogDerivative018[
          <|"sectorPrefactorData" -> prefactorData|>,
          userVariable
          ];
        With[{term = applyIndependentVariableDerivativeSeed[sectorTopo, int, internalVariable]},
         If[term === $Failed || prefactorLogDerivative === $Failed,
          $Failed,
          coefficient (term + prefactorLogDerivative int)
          ]
         ]
       ]
      ],
     {linearData["coefficients"], linearData["integrals"]}
     ];
   If[MemberQ[integralDerivativeTerms, $Failed],
    Message[dSIBPPublicAPI::derivativefailed, userVariable]; Return[$Failed]
    ];
   result = sectorAwareCanonical018[
     Expand[coefficientDerivative + Total[integralDerivativeTerms]],
     rootTopo
     ];
    If[result === $Failed, Return[$Failed]];
    result = rep2outform[result, rootTopo];
    If[result === $Failed, Return[$Failed]];
    dsTimeOnlyExpressionToPublic020[result, rootTopo]
    ];


integrandBuildingBlock[line_Association, pack_List, momentumMagnitude_] := Module[
   {lineId = line["id"], endpoints = line["endpoints"], packType = line["packType"], positions},
   positions = linePackNPositions[line, packType];
   Switch[packType,
    "massiveFull" | "massiveCross",
    Hh[MassiveBlock[
       lineFunctionPreset018[line], Lookup[line, "nu", nu], Lookup[line, "skType", "++"],
      lineId, endpoints, momentumMagnitude, pack[[positions[[1]]]], pack[[positions[[2]]]]
      ]],
    "masslessFull",
    Hh[MasslessBlock[
      Lookup[line, "skType", "++"], lineId, endpoints, momentumMagnitude,
      pack[[positions[[1]]]], pack[[positions[[2]]]]
      ]],
    "masslessCross",
    Hh[MasslessCrossBlock[Lookup[line, "skType", "+-"], lineId, endpoints, momentumMagnitude]],
    _, 1
    ]
   ];


integrandLineBareFactor018[topo_Association, int_J, e_Integer] := Module[
   {line, pack, packType, momentumMagnitude, denominator},
   line = topo["lines"][[e]];
   pack = int[[2, e]];
   packType = actualLinePackType[topo, e, pack];
   momentumMagnitude = lineMomentumMagnitude[topo, e];
   denominator = If[
     lineIndexedPowerQ[line],
     momentumMagnitude^(-linePowerIndex[topo, int, e]),
     1
     ];
   If[
    packType === "shrunk",
    denominator,
    denominator integrandBuildingBlock[Join[line, <|"packType" -> packType|>], pack, momentumMagnitude]
    ]
   ];


integralToBareInertIntegrand018[topo_Association, int_J] := Times[
   integrandVertexFactor[topo, int],
   Times @@ Table[integrandLineBareFactor018[topo, int, e], {e, topo["nE"]}],
   integrandISPFactor[topo, int]
   ];


rep2Integrand[expr_, topoSpec_Association] := Module[
   {rootTopo, internalExpr, result, sectorTopo, prefactorData, prefactor},
   rootTopo = resolvePublicTopologyContext[topoSpec];
   If[rootTopo === $Failed, Return[$Failed]];
   internalExpr = If[
     Lookup[rootTopo, "ibpMode", "full"] === "timeOnly",
     dsTimeOnlyExpressionToInternal020[expr, rootTopo],
     expr
     ];
   If[internalExpr === $Failed || ! validatePublicExpression[internalExpr, rootTopo], Return[$Failed]];
   result = Expand[internalExpr /. int_J :> (
         sectorTopo = sectorTopologyForIntegral018[rootTopo, int];
         prefactorData = sectorPrefactorDataForIntegral018[rootTopo, int];
         prefactor = materializeSectorPrefactor018[prefactorData];
         If[
          Head[sectorTopo] === Missing || prefactor === $Failed,
          $Failed,
          prefactor integralToBareInertIntegrand018[sectorTopo, int]
          ]
         )];
   If[! FreeQ[result, $Failed], Return[$Failed]];
   rep2outform[result, rootTopo]
   ];


(* ::Chapter:: *)
(*GF(2) parity metadata 与 sector transport*)

normalizeParityConstraints018[constraints_] := Map[
   Function[item,
    Which[
     MatchQ[item, _Rule | _RuleDelayed], <|"expression" -> First[item], "remainder" -> Last[item]|>,
     AssociationQ[item] && KeyExistsQ[item, "expression"],
     <|"expression" -> item["expression"], "remainder" -> Lookup[item, "remainder", 0]|>,
     True, <|"status" -> "invalid", "input" -> item|>
     ]
    ],
   If[ListQ[constraints], constraints, {constraints}]
   ];


lineFunctionPreset018[line_Association] := Lookup[
   lineCompiledFunctionSystem[line],
   "preset",
    Lookup[Lookup[lineCompiledFunctionSystem[line], "input", <||>], "preset", "custom"]
   ];


(* Parity transport only needs every line building block to have a proved GF(2)
   closure. Massive h/H and massless exponential lines both satisfy this contract;
   an unknown custom function system remains fail closed. *)
parityLineFunctionSystemUsableQ018[line_Association] := Switch[
   Lookup[line, "massType", "massive"],
   "massive", MemberQ[{"h", "H"}, lineFunctionPreset018[line]],
    "massless", True,
   _, False
   ];


parityFunctionSystemUsableQ018[topo_Association] := Module[{lines},
   lines = Lookup[topo, "lines", {}];
   lines =!= {} && And @@ (parityLineFunctionSystemUsableQ018 /@ lines)
   ];


parityLineVariables018[line_Association] := {
   b[line["id"]], n[line["id"], 1], n[line["id"], 2]
   };


transportParityConstraint018[topo_Association, constraint_Association] := Module[
   {expr, remainder, rootRules, issues = {}, line, vars, coefficients, cb, c1, c2,
    integerShift, zeroShift, sourceZero, targetZero, delta, shrunkQ},
   If[Lookup[constraint, "status", "valid"] === "invalid", Return[constraint]];
   expr = Expand[constraint["expression"]];
   remainder = constraint["remainder"];
   rootRules = Lookup[topo, "rootZeroPointRules", topo["zeroPointRules"]];
   Do[
    line = topo["lines"][[e]];
    vars = parityLineVariables018[line];
    coefficients = Coefficient[expr, #] & /@ vars;
    {cb, c1, c2} = coefficients;
    If[And @@ (zeroQ /@ coefficients), Continue[]];
    If[! lineIndexedPowerQ[line] && ! And @@ (zeroQ /@ coefficients),
     AppendTo[issues, <|"reason" -> "fixedLineInParity", "lineIndex" -> e, "coefficients" -> coefficients|>]
     ];
    shrunkQ = Lookup[line, "state", "full"] === "shrunk" || Lookup[line, "packType", ""] === "shrunk";
    If[shrunkQ && lineIndexedPowerQ[line],
     If[! TrueQ[Expand[c1 - c2] === 0],
      AppendTo[issues, <|"reason" -> "endpointWeightsNotTransportable", "lineIndex" -> e, "coefficients" -> coefficients|>],
      integerShift = lineShrinkBShift[line];
      zeroShift = lineShrinkZeroPointShift[line];
      sourceZero = zeroPointRuleValue018[rootRules, b0[line["id"]], 0];
      targetZero = lineBSZeroPoint[topo, e];
      delta = Simplify[Expand[(targetZero - sourceZero) - zeroShift]];
      If[!(TrueQ[delta === 0] || IntegerQ[delta]),
       AppendTo[issues, <|"reason" -> "nonIntegerZeroPointRebase", "lineIndex" -> e, "delta" -> delta|>],
       expr = Expand[
         expr - cb vars[[1]] - c1 vars[[2]] - c2 vars[[3]] +
          cb (bS[line["id"]] - integerShift + delta) + c1
         ]
       ]
      ]
     ],
    {e, topo["nE"]}
    ];
   If[issues =!= {},
    <|"status" -> "invalid", "input" -> constraint, "issues" -> issues|>,
    <|"status" -> "transported", "expression" -> Expand[expr], "remainder" -> remainder|>
    ]
   ];


parityMetadataForSector018[topo_Association] := Module[
   {raw, normalized, transported, invalid, usableFunctionQ},
   raw = Lookup[topo, "parityConstraints", {}];
   usableFunctionQ = parityFunctionSystemUsableQ018[topo];
   If[raw === {} || raw === None,
    Return[<|"status" -> "disabled", "reason" -> "noParityConstraints",
      "parityUsableQ" -> usableFunctionQ, "constraints" -> {}|>]
    ];
   If[! usableFunctionQ,
    Return[<|"status" -> "disabled", "reason" -> "unsupportedParityFunctionSystem",
      "parityUsableQ" -> False, "constraints" -> {}|>]
    ];
   normalized = normalizeParityConstraints018[raw];
   transported = transportParityConstraint018[topo, #] & /@ normalized;
   invalid = Select[transported, Lookup[#, "status", "invalid"] =!= "transported" &];
   If[invalid =!= {},
    <|"status" -> "disabled", "reason" -> "constraintTransportFailed",
      "parityUsableQ" -> False, "constraints" -> {}, "issues" -> invalid|>,
    <|"status" -> "enabled", "parityUsableQ" -> True,
      "constraints" -> transported,
      "masslessCycleFlipCount" -> Mod[Count[
         Select[Range[topo["nE"]], MemberQ[Lookup[topo, "sectorShrunkLines", {}], #] &],
         e_ /; lineIndexedPowerQ[topo["lines"][[e]]] && Lookup[topo["lines"][[e]], "massType", "massive"] === "massless"
         ], 2]
      |>
    ]
   ];


parityIntegralIndexRules018[metadata_Association, int_J] := Module[{lineRules, ispRules},
   lineRules = Flatten@MapThread[
      Thread[Lookup[#1, "packTemplate", {}] -> #2] &,
      {Lookup[metadata, "lineSlots", {}], int[[2]]}
      ];
   ispRules = If[Lookup[metadata, "ispSlots", {}] === {},
     {},
     MapThread[Lookup[#1, "indexSymbol"] -> #2 &, {metadata["ispSlots"], int[[3]]}]
     ];
   Join[lineRules, ispRules]
   ];


parityIntegralSignature018[metadata_Association, int_J] := Module[{data, rules},
   data = Lookup[metadata, "parityData", <|"status" -> "disabled"|>];
   If[Lookup[data, "status", "disabled"] =!= "enabled", Return[{}]];
   rules = parityIntegralIndexRules018[metadata, int];
   Mod[Expand[(#expression - #remainder) /. rules], 2] & /@ Lookup[data, "constraints", {}]
   ];


parityIntegralAllowedQ018[metadata_Association, int_J] := Module[{signature},
   signature = parityIntegralSignature018[metadata, int];
   signature === {} || And @@ (TrueQ[# === 0] & /@ signature)
   ];


dsParityFilteredPointRules018[entry_Association, pointRules_List, context_Association] := Module[
   {metadata, parityData, sourceIntegral},
   metadata = Lookup[entry, "sectorMetadata", Missing["NoSectorMetadata"]];
   If[! AssociationQ[metadata], Return[pointRules]];
   parityData = Lookup[metadata, "parityData", <|"status" -> "disabled"|>];
   If[Lookup[parityData, "status", "disabled"] =!= "enabled", Return[pointRules]];
   sourceIntegral = Lookup[entry, "sourceIntegral", Missing["NoSourceIntegral"]];
   If[Head[sourceIntegral] =!= J, Return[pointRules]];
   Select[pointRules, parityIntegralAllowedQ018[metadata, sourceIntegral /. #] &]
   ];


(* 用户直接传入表达式时没有 sourceIntegral/sector parity provenance，不能在撒点前猜测
   seed parity。此时保留用户点域，并由生成后的 parity certificate 检查实际积分。 *)
dsParityFilteredPointRules018[_, pointRules_List, _Association] := pointRules;


dsParityCertificate018[records_List, context_Association] := Module[
   {metadataList = context["sectors"], failures = {}, integrals, metadata, signature},
   Do[
    integrals = DeleteDuplicates[Cases[Lookup[records[[i]], "equation", 0], _J, {0, Infinity}]];
    Do[
     metadata = SelectFirst[metadataList, integralMatchesSectorMetadataQ[int, #] &, Missing["NoMatchingSector"]];
     If[Head[metadata] === Missing,
      AppendTo[failures, <|"equationIndex" -> i, "integral" -> int, "reason" -> metadata|>],
      signature = parityIntegralSignature018[metadata, int];
      If[signature =!= {} && ! And @@ (TrueQ[# === 0] & /@ signature),
       AppendTo[failures, <|"equationIndex" -> i, "sectorKey" -> metadata["sectorKey"],
         "integral" -> int, "signature" -> signature|>]
       ]
      ],
     {int, integrals}
     ],
    {i, Length[records]}
    ];
   <|"passQ" -> (failures === {}), "checkedEquationCount" -> Length[records],
    "failureCount" -> Length[failures], "failures" -> failures|>
   ];


(* ::Chapter:: *)
(*Massless tree formula capability*)

treeFormulaMasslessLines018[context_Association] := Lookup[
   Select[
    Lookup[context["topology"], "lines", {}],
    Lookup[#, "massType", "massive"] === "massless" &
    ],
   "id",
   {}
   ];


treeFormulaMasslessPendingQ018[context_Association] := treeFormulaMasslessLines018[context] =!= {};


treeFormulaPendingRederivation018[operation_String, context_Association] := Module[{lines},
   lines = treeFormulaMasslessLines018[context];
   dsErrorPrint[
    operation <> " 尚未在 massless 三槽 quotient basis 上重新推导，公式型 tree 路线已停止。" <>
     " " <> operation <> " has not been rederived on the massless three-slot quotient basis; the formula-based tree route was stopped."
    ];
   <|
    "status" -> "PendingRederivation",
    "reason" -> "masslessQuotientFormulaNotCertified",
    "operation" -> operation,
    "masslessLineIds" -> lines,
    "representation" -> "J[aList,linePacks,ispList]",
    "availableAlternative" ->
     "Use DSSeeds -> DSGenerateIBP -> DSLinear on the unified line-pack basis; construct DSDE only after importing an external reduction."
    |>
   ];


(* ::Chapter:: *)
(*018 template-only DSSeeds*)

DSSeeds[context_: Automatic, opts : OptionsPattern[]] := Module[
   {resolved, seedSkeleton, templateData, sealedTemplates, seedGroups, seedGroupMetadata,
    seedRangeMetadata, discoveredIndices, progress = OptionValue[ProgressReporting]},
   resolved = dsResolveContext[context];
   If[Head[resolved] === Missing,
    Message[DSSeeds::noinit];
    dsErrorPrint["请先成功调用 DSInit。 Run DSInit successfully first."];
    Return[<|"status" -> "failed", "reason" -> "missingContext"|>]
    ];
   If[! dsContextCapabilityQ[resolved, "timeIBPUsableQ"] ||
     (Lookup[resolved["topology"], "ibpMode", "full"] === "full" &&
       ! dsContextCapabilityQ[resolved, "momentumIBPUsableQ"]),
    Message[DSSeeds::capability, dsContextCapabilities[resolved]];
    Return[<|"status" -> "failed", "reason" -> "capabilityGate"|>]
    ];
    seedSkeleton = <|
      "status" -> "generated",
      "representation" -> If[
        Lookup[resolved["topology"], "ibpMode", "full"] === "timeOnly",
        "J[sectorKey,timeShifts,stateBits]",
        "J[aList,linePacks,ispList]"
        ],
     "ibpMode" -> Lookup[resolved["topology"], "ibpMode", "full"],
     "sectorMetadata" -> First[resolved["sectors"]],
     "sectorMetadataList" -> resolved["sectors"]
     |>;
   templateData = dsStageRun[
     "构造全部 reachable-sector 离散态 seed 模板 / Building all reachable-sector discrete-state seed templates",
      dsLoopSeedTemplateData[resolved, seedSkeleton],
      progress
      ];
   If[Lookup[templateData, "status", "failed"] =!= "generated",
    Message[DSSeeds::failed, Lookup[templateData, "reason", "templateGenerationFailed"]];
    Return[Join[seedSkeleton, <|"status" -> "failed", "templateData" -> templateData|>]]
    ];
    If[Lookup[resolved["topology"], "ibpMode", "full"] === "timeOnly",
     templateData = Join[templateData, <|
        "generationRoute" -> "internalThreeSlotConverted",
        "representation" -> "J[sectorKey,timeShifts,stateBits]",
        "allSeeds" -> dsTimeOnlyDataToPublic020[Lookup[templateData, "allSeeds", {}], resolved]
        |>];
     If[Lookup[templateData, "allSeeds", $Failed] === $Failed,
      Message[DSSeeds::failed, "timeOnlyPublicConversionFailed"];
      Return[Join[seedSkeleton, <|"status" -> "failed", "reason" -> "timeOnlyPublicConversionFailed"|>]]
      ]
     ];
    sealedTemplates = dsSealSeedTemplates[templateData["allSeeds"], resolved];
   seedGroups = dsDefaultSeedGroups[sealedTemplates];
   seedGroupMetadata = dsSeedGroupMetadataFromGroups[seedGroups];
   discoveredIndices = DeleteDuplicates[Flatten[dsEntrySeedVariables /@ sealedTemplates]];
   seedRangeMetadata = DSMetaSeedRange[seedGroups, discoveredIndices];
   $dSIBPLastSeedTemplates = sealedTemplates;
   $dSIBPLastSeedGroups = seedGroups;
   $dSIBPLastSeedGroupMetadata = seedGroupMetadata;
   Join[seedSkeleton, <|
     "completeCanonicalQ" -> True,
     "completeMomentumIBPQ" -> (Lookup[resolved["topology"], "ibpMode", "full"] === "full"),
     "completeTimeIBPQ" -> True,
     "pendingFeatures" -> {},
     "forbiddenNData" -> {},
     "equationCount" -> 0,
     "equations" -> {},
     "allSeeds" -> sealedTemplates,
     "seedGroups" -> seedGroups,
     "seedGroupMetadata" -> seedGroupMetadata,
     "seedRangeMetadata" -> seedRangeMetadata,
     "seedTemplateSummary" -> KeyDrop[templateData, "allSeeds"],
     "dSIBPStatus" -> "generated",
     "dSIBPContextSummary" -> dsContextSummary[resolved]
     |>]
   ];

(* ::Package:: *)
(* 本模块提供 018 的用户参数 notation 与重定义入口。所有新规则都重新经过 DSKinematics/DSInit，
   因而 seed、ds、DSDE 与序列化 metadata 不会持有彼此不一致的坐标状态。 *)

(* ::Chapter:: *)
(*参数 notation*)

dsParameterNotation[topo_Association] := Module[
   {audit = Lookup[topo, "kinematicCoordinateAudit", <||>], declarationAudit},
   declarationAudit = Lookup[topo, "momentumDeclarationAudit", <||>];
   <|
     "loopExternalMomenta" -> Lookup[topo, "loopExternalMomenta", {}],
     "effectiveLoopExternalMomenta" -> Lookup[topo, "effectiveLoopExternalMomenta", Lookup[topo, "effectiveLoopExternalMomenta", {}]],
     "independentExternalMomenta" -> Lookup[topo, "independentExternalMomenta", {}],
     "kEIndices" -> Range[Length[Lookup[topo, "independentExternalMomenta", {}]]],
     "kEMomenta" -> Lookup[topo, "independentExternalMomenta", {}],
     "kEParameterExpressions" -> independentExternalMagnitudeExpressions018[topo],
    "defaultRules" -> Lookup[audit, "defaultRules", {}],
    "selectedRules" -> Lookup[audit, "selectedRules", {}],
    "selectedUserVariables" -> Lookup[audit, "selectedUserVariables", {}],
    "dependentMagnitudeBindings" -> Lookup[audit, "dependentMagnitudeBindings", {}],
    "requiredLoopExternalDirections" -> Lookup[declarationAudit, "requiredLoopExternalDirections", {}],
    "requiredNoLoopMagnitudeMomenta" -> Lookup[declarationAudit, "requiredIndependentMomentumMagnitudes", {}],
    "requiredMagnitudeCoverage" -> kinematicRequiredMagnitudeCoverage[topo],
    "parameterRedefinitionGuide" -> kinematicParameterRedefinitionGuide[audit],
    "coordinateStatus" -> Lookup[audit, "status", "unknown"],
    "capabilities" -> Lookup[topo, "capabilities", <||>]
    |>
   ];


DSParameterNotation[context_Association] := Module[{resolved = dsResolveContext[context], result, guide, guideText},
   If[Head[resolved] === Missing,
    dsErrorPrint["DSParameterNotation 需要有效的 DSInit context。 DSParameterNotation requires a valid DSInit context."]; Return[$Failed]
    ];
   result = dsParameterNotation[resolved["topology"]];
   guide = Lookup[result, "parameterRedefinitionGuide", <||>];
   guideText = If[
     StringQ[Lookup[guide, "commandExample", None]],
     Lookup[guide, "commandExample", ""],
     Lookup[guide, "defaultBehavior", ""]
     ];
   dsInfoPrint[
    "当前参数 " <> ToString[Lookup[result, "selectedUserVariables", {}], InputForm] <>
     "。可选重定义示例：" <> guideText <>
     ". Current parameters: " <> ToString[Lookup[result, "selectedUserVariables", {}], InputForm] <>
     ". Optional redefinition example: " <> guideText
    ];
   result
   ];


DSParameterNotation[] := Module[{context = dsResolveContext[Automatic]},
   If[Head[context] === Missing,
    dsErrorPrint["请先成功调用 DSInit。 Run DSInit successfully first."]; Return[$Failed]
    ];
   DSParameterNotation[context]
   ];


(* ::Chapter:: *)
(*参数重定义*)

Options[DSRedefineParameters] = {ProgressReporting -> Automatic};


DSRedefineParameters[context_Association, rules_, OptionsPattern[]] := Module[
   {resolved = dsResolveContext[context], input, result, generateDerivativeMetadataQ},
   If[Head[resolved] === Missing,
    dsErrorPrint["DSRedefineParameters 需要有效的 DSInit context。 DSRedefineParameters requires a valid DSInit context."]; Return[$Failed]
    ];
   If[! ListQ[rules] && ! AssociationQ[rules],
    dsErrorPrint["参数重定义规则必须是 Rule 列表或 Association。 Parameter redefinition rules must be a Rule list or an Association."]; Return[$Failed]
    ];
   input = KeyDrop[resolved["input"], {"kinematicRules"}];
   generateDerivativeMetadataQ = AssociationQ[Lookup[resolved, "derivatives", Missing["NotGenerated"]]];
   result = DSInit[
     input,
     KinematicRules -> If[AssociationQ[rules], Normal[rules], rules],
     RegisterAsCurrent -> False,
     WriteInitializationFiles -> False,
     GenerateDerivativeMetadata -> generateDerivativeMetadataQ,
     ProgressReporting -> OptionValue[ProgressReporting]
     ];
   If[Lookup[result, "status", "failed"] =!= "initialized",
    dsErrorPrint["参数重定义未通过完备性或 topology 门禁。 Parameter redefinition failed the completeness or topology gate."]; Return[result]
    ];
   Join[result, <|"parameterRedefinition" -> <|
      "sourceInputHash" -> Lookup[resolved, "inputHash", Missing["inputHash"]],
      "rules" -> If[AssociationQ[rules], Normal[rules], rules]
      |>|>]
   ];


DSRedefineParameters[rules_, OptionsPattern[]] := Module[{current, result},
   current = dsResolveContext[Automatic];
   If[Head[current] === Missing,
    dsErrorPrint["请先成功调用 DSInit。 Run DSInit successfully first."]; Return[$Failed]
    ];
   result = DSRedefineParameters[current, rules, ProgressReporting -> OptionValue[ProgressReporting]];
   If[AssociationQ[result] && Lookup[result, "status", "failed"] === "initialized",
    $dSIBPCurrentContext = result;
    setIBPTopologyContext[result["topology"]]
    ];
   result
   ];

(* ::Package:: *)
(* 本模块把论文 vertex-basis 公式实现限制在 Private 内部，并为 020 的 tree 公开接口提供
   J[sectorKey,timeShifts,stateBits] 适配。它不改变 massive-only 递推或 dlog 公式，也不绕过
   massless quotient 的 PendingRederivation 门禁。 *)

(* ::Chapter:: *)
(*统一 J 与私有 vertex basis 的双向映射*)

(* 公式内核按顶点保存 massive 状态；先构造既有 line-packed producer 对象，再通过
   020 中央 registry 唯一转换为公开 time-only 表示。 *)
dsTreeFormulaIntegralToPublic018[int : J[_List], sectorKey_String, context_Association] := Module[
   {familyContext, family, topo, packs, aList, baseline, linePacks, line, states,
    vertexIndex, legIndex, internalIntegral},
   familyContext = dsTreeFamilyContext[context];
   family = dsTreeFamilyBySector[sectorKey, familyContext];
   If[Head[family] === Missing || ! treeIntegralQ[int, family], Return[$Failed]];
   topo = family["topology"];
   packs = First[int];
   aList = packs[[All, 1]];
   baseline = Lookup[family, "loopBaselinePowers", <||>];
   linePacks = Table[
     line = topo["lines"][[e]];
     Switch[
      Lookup[line, "state", "full"] === "shrunk" || Lookup[line, "packType", ""] === "shrunk",
      True,
      If[lineIndexedPowerQ[line], {Lookup[baseline, line["id"], 0]}, {fixedLineSentinel018[]}],
      False,
      states = Table[
        vertexIndex = FirstPosition[
          family["vertexOrder"],
          line["endpoints"][[endpointSlot]],
          Missing["NoVertex"]
          ];
        If[Head[vertexIndex] === Missing, Return[$Failed]];
        legIndex = FirstPosition[
          Lookup[family["vertices"][[First[vertexIndex], "massiveLegs"]], "id", {}],
          {line["id"], endpointSlot},
          Missing["NoLeg"]
          ];
        If[Head[legIndex] === Missing, Return[$Failed]];
        packs[[First[vertexIndex], 1 + First[legIndex]]],
        {endpointSlot, 2}
        ];
      If[lineIndexedPowerQ[line],
       Prepend[states, Lookup[baseline, line["id"], 0]],
       Prepend[states, fixedLineSentinel018[]]
       ]
      ],
     {e, topo["nE"]}
     ];
   internalIntegral = J[aList, linePacks, {}];
   dsTimeOnlyInternalIntegralToPublic020[internalIntegral, context]
   ];


dsTreePublicIntegralToFormula018[
   int : J[_, _, _], sectorKey_String, context_Association
   ] := Module[
   {internalIntegral, metadata, familyContext, family, topo, aList, linePacks, lineIds, vertexPacks,
    legId, linePosition, endpointSlot, statePosition, states},
   internalIntegral = dsTimeOnlyPublicIntegralToInternal020[int, context];
   If[internalIntegral === $Failed, Return[$Failed]];
   metadata = SelectFirst[
     context["sectors"],
     Lookup[#, "sectorKey", None] === sectorKey && integralMatchesSectorMetadataQ[internalIntegral, #] &,
     Missing["NoSector"]
     ];
   If[Head[metadata] === Missing, Return[$Failed]];
   familyContext = dsTreeFamilyContext[context];
   family = dsTreeFamilyBySector[sectorKey, familyContext];
   If[Head[family] === Missing, Return[$Failed]];
   topo = family["topology"];
   aList = internalIntegral[[1]];
   linePacks = internalIntegral[[2]];
   lineIds = Lookup[topo["lines"], "id", {}];
   If[Length[aList] =!= Length[family["vertexOrder"]], Return[$Failed]];

   (* massiveLegs 的 id 已保存 root line 与端点槽；公开 full pack 的后两槽正是这两个端点态。
      fixed sentinel 只占第一槽，因此 cycle/fixed line 共用同一读取规则。 *)
   vertexPacks = Table[
     states = Map[
       Function[leg,
        legId = Lookup[leg, "id", Missing["NoLegId"]];
        If[! MatchQ[legId, {_, 1 | 2}], Return[$Failed]];
        {linePosition, endpointSlot} = {
          FirstPosition[lineIds, legId[[1]], Missing["NoLine"]],
          legId[[2]]
          };
        If[Head[linePosition] === Missing, Return[$Failed]];
        linePosition = First[linePosition];
        statePosition = 1 + endpointSlot;
        If[Length[linePacks[[linePosition]]] < statePosition, Return[$Failed]];
        linePacks[[linePosition, statePosition]]
        ],
       family["vertices"][[vertexIndex, "massiveLegs"]]
       ];
     Prepend[states, aList[[vertexIndex]]],
     {vertexIndex, Length[family["vertices"]]}
     ];
   If[FreeQ[vertexPacks, $Failed], J[vertexPacks], $Failed]
   ];


dsTreeTaggedTermToPublic018[term_Association, context_Association] := Module[
   {sectorKey, formulaIntegral, publicIntegral},
   sectorKey = Lookup[term, "sectorKey", Missing["NoSector"]];
   formulaIntegral = Lookup[term, "integral", Missing["NoIntegral"]];
   If[! StringQ[sectorKey] || ! MatchQ[formulaIntegral, J[_List]], Return[$Failed]];
   publicIntegral = dsTreeFormulaIntegralToPublic018[formulaIntegral, sectorKey, context];
   If[publicIntegral === $Failed, Return[$Failed]];
   Join[KeyDrop[term, {"integral"}], <|"integral" -> publicIntegral|>]
   ];


dsTreeTaggedTermToFormula018[term_Association, context_Association] := Module[
   {sectorKey, publicIntegral, formulaIntegral},
   sectorKey = Lookup[term, "sectorKey", Missing["NoSector"]];
   publicIntegral = Lookup[term, "integral", Missing["NoIntegral"]];
   If[! StringQ[sectorKey] || ! MatchQ[publicIntegral, J[_, _, _]], Return[$Failed]];
   formulaIntegral = dsTreePublicIntegralToFormula018[publicIntegral, sectorKey, context];
   If[formulaIntegral === $Failed, Return[$Failed]];
   Join[KeyDrop[term, {"integral"}], <|"integral" -> formulaIntegral|>]
   ];


(* ::Chapter:: *)
(*Seed 与 tagged linearData 公开化*)

dsTreeLinearDataToPublic018[data_Association, context_Association] := Module[{terms},
   terms = dsTreeTaggedTermToPublic018[#, context] & /@ Lookup[data, "terms", {}];
   If[MemberQ[terms, $Failed], Return[$Failed]];
   Join[
    KeyDrop[data, {"terms", "expression"}],
    <|
     "terms" -> terms,
     "expression" -> Total[Lookup[#, "coefficient"] Lookup[#, "integral"] & /@ terms],
     "representation" -> "sectorTaggedJ[sectorKey,timeShifts,stateBits]"
     |>
    ]
   ];


dsTreeLinearDataToFormula018[data_Association, context_Association] := Module[{terms},
   terms = dsTreeTaggedTermToFormula018[#, context] & /@ Lookup[data, "terms", {}];
   If[MemberQ[terms, $Failed], Return[$Failed]];
   Join[
    KeyDrop[data, {"terms", "expression"}],
    <|
     "terms" -> terms,
     "expression" -> Total[Lookup[#, "coefficient"] Lookup[#, "integral"] & /@ terms]
     |>
    ]
   ];


dsTreeSeedRecordToPublic018[record_Association, context_Association, referenceInt_J] := Module[
   {linearData, publicLinearData},
   linearData = Lookup[record, "treeLinearData", Missing["NoTreeLinearData"]];
   If[! AssociationQ[linearData], Return[$Failed]];
   publicLinearData = dsTreeLinearDataToPublic018[linearData, context];
   If[publicLinearData === $Failed, Return[$Failed]];
   publicLinearData = Join[
     KeyDrop[publicLinearData, {"referenceTreeIntegral", "referenceLoopIntegral"}],
     <|"referenceTreeIntegral" -> referenceInt|>
     ];
   Join[
    KeyDrop[record, {"treeSeed", "treeIntegral", "treeLinearData"}],
    <|
     "treeSeed" -> publicLinearData["expression"],
     "treeIntegral" -> referenceInt,
     "treeLinearData" -> publicLinearData,
     "representation" -> "J[sectorKey,timeShifts,stateBits]"
     |>
    ]
   ];


(* ::Chapter:: *)
(*批量 direct pure-time 模板*)

(* DSSeeds 的 timeOnly 路线与单积分 DSTreeSeeds 共用同一个原子生成器。
   连续 a 指标保持符号，端点态完整遍历 0/1；sector 与离散规则只作 provenance，
   不另建积分 Head，也不把 Private vertex basis 暴露给用户。 *)
dsPureTimeDirectTemplateRecord018[
   raw_Association,
   family_Association,
   vertexId_,
   formulaIntegral_J,
   context_Association
   ] := Module[
   {sectorKey, publicIntegral, internalIntegral, publicRecord, baseIntegral, discreteVariables,
    discretePositions, discreteRules, metadata},
   sectorKey = family["sector"];
   publicIntegral = dsTreeFormulaIntegralToPublic018[formulaIntegral, sectorKey, context];
   If[publicIntegral === $Failed, Return[$Failed]];
   internalIntegral = dsTimeOnlyPublicIntegralToInternal020[publicIntegral, context];
   If[internalIntegral === $Failed, Return[$Failed]];
   publicRecord = dsTreeSeedRecordToPublic018[raw, context, publicIntegral];
   If[publicRecord === $Failed, Return[$Failed]];
   baseIntegral = makeBaseIntegral[family["topology"]];
   discreteVariables = DeleteDuplicates[Cases[baseIntegral, _n, Infinity]];
   discretePositions = Position[baseIntegral, _n, Infinity];
   discreteRules = Thread[Extract[baseIntegral, discretePositions] -> Extract[internalIntegral, discretePositions]];
   metadata = SelectFirst[
     context["sectors"],
     Lookup[#, "sectorKey", None] === sectorKey &,
     Missing["NoSectorMetadata"]
     ];
   If[Head[metadata] === Missing, Return[$Failed]];
   <|
    "source" -> {"directPureTime", sectorKey},
    "generationRoute" -> "directPureTime",
    "sectorKey" -> sectorKey,
    "sectorShrunkLines" -> Lookup[family["topology"], "sectorShrunkLines", {}],
    "sectorMetadata" -> metadata,
    "generator" -> dtau[vertexId],
    "ibpClass" -> "tIBP",
    "continuousIndices" -> (a /@ family["vertexOrder"]),
    "sourceIntegral" -> publicIntegral,
    "discreteVariables" -> discreteVariables,
    "discreteRules" -> discreteRules,
    "discreteStateCountExpected" -> 2^Length[discreteVariables],
    "equation" -> publicRecord["treeSeed"],
    "forbiddenNData" -> {},
    "eomCanonicalQ" -> True,
    "representation" -> "J[sectorKey,timeShifts,stateBits]",
    "ibpMode" -> "timeOnly",
    "directSeedProvenance" -> KeyTake[
      publicRecord,
      {"generationRoute", "sectorKey", "generator", "treeIntegral", "representation"}
      ]
    |>
   ];


dsPureTimeDirectTemplateData018[context_Association] /; dsContextQ[context] := Module[
   {familyContext, families, records},
   If[treeFormulaMasslessPendingQ018[context],
    Return[treeFormulaPendingRederivation018["DSSeeds", context]]
    ];
   familyContext = dsTreeFamilyContext[context];
   If[familyContext === $Failed,
    Return[<|"status" -> "failed", "reason" -> "treeFamilyInitializationFailed"|>]
    ];
   families = familyContext["families"];
   records = Flatten@Table[
      With[{formulaIntegrals = treeMasterList[family, a /@ family["vertexOrder"]]},
       If[formulaIntegrals === $Failed,
        {$Failed},
        Table[
         With[{raw = dsDirectTreeSeedRecord[vertexId, formulaIntegral, family, familyContext]},
          If[! AssociationQ[raw] || Lookup[raw, "status", "failed"] =!= "generated",
           $Failed,
           dsPureTimeDirectTemplateRecord018[
            raw, family, vertexId, formulaIntegral, context
            ]
           ]
          ],
         {vertexId, family["vertexOrder"]},
         {formulaIntegral, formulaIntegrals}
         ]
        ]
       ],
      {family, families}
      ];
   If[MemberQ[records, $Failed],
    Return[<|"status" -> "failed", "reason" -> "directPureTimeTemplateFailed"|>]
    ];
   <|
    "status" -> "generated",
    "generationRoute" -> "directPureTime",
    "sectorCount" -> Length[families],
    "templateCount" -> Length[records],
    "allSeeds" -> records
    |>
   ];


(* ::Chapter:: *)
(*公开 DSTreeSeeds 与 repIterative*)

DSTreeSeeds[vertex_, int : J[_, _, _], context_Association] /; dsContextQ[context] := Module[
   {internalIntegral, metadata, sectorKey, familyContext, family, formulaIntegral, raw},
   If[treeFormulaMasslessPendingQ018[context],
    Return[treeFormulaPendingRederivation018["DSTreeSeeds", context]]
    ];
   internalIntegral = dsTimeOnlyPublicIntegralToInternal020[int, context];
   If[internalIntegral === $Failed,
    Return[<|"status" -> "failed", "reason" -> "invalidPublicTimeOnlyIntegral"|>]
    ];
   metadata = integralSectorMetadata018[context["topology"], internalIntegral];
   If[Head[metadata] === Missing, Return[<|"status" -> "failed", "reason" -> "unknownTreeSector"|>]];
   sectorKey = metadata["sectorKey"];
   familyContext = dsTreeFamilyContext[context];
   family = dsTreeFamilyBySector[sectorKey, familyContext];
   formulaIntegral = dsTreePublicIntegralToFormula018[int, sectorKey, context];
   If[Head[family] === Missing || formulaIntegral === $Failed,
    Return[<|"status" -> "failed", "reason" -> "treePublicToFormulaFailed"|>]
    ];
   raw = dsDirectTreeSeedRecord[vertex, formulaIntegral, family, familyContext];
   If[! AssociationQ[raw], $Failed, dsTreeSeedRecordToPublic018[raw, context, int]]
   ];


DSTreeSeeds[int : J[_, _, _], context_Association] /; dsContextQ[context] :=
  If[treeFormulaMasslessPendingQ018[context],
   treeFormulaPendingRederivation018["DSTreeSeeds", context],
   DSTreeSeeds[#, int, context] & /@ Lookup[
     Select[makeIBPGenerators[context["topology"]], #["type"] === "time" &],
     "vertex"
     ]
   ];


dsTreePublicExpressionData018[expr_, context_Association] := Module[
   {terms, parsed},
   terms = dsExpandedTerms[Expand[expr]];
   parsed = Map[
     Function[term,
      Module[{integrals, int, internalIntegral, coefficient, metadata},
       (* 裸 J 本身位于 level 0；若只从 level 1 搜索，单积分输入会被误判为空。 *)
       integrals = DeleteDuplicates[Cases[term, item : J[_, _, _] :> item, {0, Infinity}]];
       If[Length[integrals] =!= 1, Return[$Failed]];
       int = First[integrals];
       internalIntegral = dsTimeOnlyPublicIntegralToInternal020[int, context];
       If[internalIntegral === $Failed, Return[$Failed]];
       coefficient = Cancel[term/int];
       metadata = integralSectorMetadata018[context["topology"], internalIntegral];
       If[Head[metadata] === Missing, Return[$Failed]];
       <|"sectorKey" -> metadata["sectorKey"], "integral" -> int, "coefficient" -> coefficient|>
       ]
      ],
     terms
     ];
   If[MemberQ[parsed, $Failed], $Failed,
    <|"status" -> "generated", "terms" -> parsed,
      "expression" -> Total[Lookup[#, "coefficient"] Lookup[#, "integral"] & /@ parsed]|>]
   ];


repIterative[data_Association, end_: Automatic, context_Association, opts : OptionsPattern[]] /;
   dsContextQ[context] := Module[{formulaData, result},
   If[treeFormulaMasslessPendingQ018[context],
    Return[treeFormulaPendingRederivation018["repIterative", context]]
    ];
   formulaData = dsTreeLinearDataToFormula018[data, context];
   If[formulaData === $Failed, Return[<|"status" -> "error", "reason" -> "invalidUnifiedTreeData"|>]];
   result = dsRepIterativeTreeLinearData[formulaData, end, context, opts];
   If[! AssociationQ[result] || ! ListQ[Lookup[result, "terms", None]], result,
    dsTreePublicResult018[result, context]
    ]
   ];


repIterative[expr_, end_: Automatic, context_Association, opts : OptionsPattern[]] /;
   dsContextQ[context] := Module[{data},
   If[treeFormulaMasslessPendingQ018[context],
    Return[treeFormulaPendingRederivation018["repIterative", context]]
    ];
   data = dsTreePublicExpressionData018[expr, context];
   If[data === $Failed,
    <|"status" -> "error", "reason" -> "invalidUnifiedTreeExpression"|>,
    repIterative[data, end, context, opts]
    ]
   ];


(* ::Chapter:: *)
(*Naive 与 dlog 结果的公开结构化映射*)

dsTreeMasterToFormula018[master_Association, context_Association] := Module[{term},
   term = dsTreeTaggedTermToFormula018[
     KeyTake[master, {"sectorKey", "integral", "coefficient"}],
     context
     ];
   If[term === $Failed, $Failed,
    Join[KeyDrop[master, {"integral"}], <|"integral" -> term["integral"]|>]
    ]
   ];


(* 公开 naive-IBP 结果中的 lhs/rhsTerms 已经是统一 time-only J；本适配器只恢复
   Private 公式内核所需的 sector-tagged vertex basis，并保留全部系数与 sectorKey。 *)
dsTreeNaiveReductionToFormula018[record_Association, context_Association] := Module[
   {lhs, rhsTerms},
   lhs = dsTreeTaggedTermToFormula018[Lookup[record, "lhs", <||>], context];
   rhsTerms = dsTreeTaggedTermToFormula018[#, context] & /@ Lookup[record, "rhsTerms", {}];
   If[lhs === $Failed || MemberQ[rhsTerms, $Failed], Return[$Failed]];
   Join[
    KeyDrop[record, {"lhs", "rhsTerms", "rhsExpression"}],
    <|
     "lhs" -> lhs,
     "rhsTerms" -> rhsTerms,
     "rhsExpression" -> Total[Lookup[#, "coefficient"] Lookup[#, "integral"] & /@ rhsTerms]
     |>
    ]
   ];


(* 输入必须是同一 context 产生的公开 solved 数据；失败时不猜测 sector 或积分形状。 *)
dsTreeNaiveIBPDataToFormula018[data_Association, context_Association] := Module[
   {masters, reductions},
   masters = dsTreeMasterToFormula018[#, context] & /@ Lookup[data, "masters", {}];
   reductions = dsTreeNaiveReductionToFormula018[#, context] & /@ Lookup[data, "reductions", {}];
   If[masters === {} || reductions === {} || MemberQ[Join[masters, reductions], $Failed],
    Return[$Failed]
    ];
   Join[
    KeyDrop[data, {"masters", "reductions", "bareMasters", "publicRepresentationAudit"}],
    <|"masters" -> masters, "reductions" -> reductions, "representation" -> "J[vertexPacks]"|>
    ]
   ];


dsTreePublicizeData018[value_, context_Association, sectorHint_: None] := Module[
   {hint = sectorHint, mapped, publicIntegral},
   Which[
    MatchQ[value, dsTreeToken[_String, J[_List]]],
    publicIntegral = dsTreeFormulaIntegralToPublic018[value[[2]], value[[1]], context];
    If[publicIntegral === $Failed, value, publicIntegral],

    MatchQ[value, J[_List]] && StringQ[hint],
    publicIntegral = dsTreeFormulaIntegralToPublic018[value, hint, context];
    If[publicIntegral === $Failed, value, publicIntegral],

    AssociationQ[value],
    hint = Lookup[value, "sectorKey", Lookup[value, "sector", hint]];
    mapped = Association@KeyValueMap[
       Function[{key, item}, key -> dsTreePublicizeData018[item, context, hint]],
       value
       ];
    If[AssociationQ[Lookup[mapped, "treeLinearData", None]],
     mapped = Join[mapped, <|
        "treeSeed" -> mapped["treeLinearData", "expression"],
        "treeIntegral" -> Lookup[
          mapped["treeLinearData"],
          "referenceLoopIntegral",
          Lookup[mapped, "treeIntegral", Missing["NoReferenceIntegral"]]
          ]
        |>]
     ];
    If[KeyExistsQ[mapped, "terms"] && ListQ[mapped["terms"]],
     mapped = Join[mapped, <|
        "expression" -> Total[
          Lookup[#, "coefficient", 1] Lookup[#, "integral", 0] & /@ mapped["terms"]
          ]
        |>]
     ];
    If[KeyExistsQ[mapped, "rhsTerms"] && ListQ[mapped["rhsTerms"]],
     mapped = Join[mapped, <|
        "rhsExpression" -> Total[
          Lookup[#, "coefficient", 1] Lookup[#, "integral", 0] & /@ mapped["rhsTerms"]
          ]
        |>]
     ];
    mapped,

    ListQ[value], dsTreePublicizeData018[#, context, hint] & /@ value,
    Head[value] === Rule,
    Rule @@ (dsTreePublicizeData018[#, context, hint] & /@ List @@ value),
    True, value
    ]
   ];


dsTreePublicResult018[result_Association, context_Association, auditLevel_: "standard"] := Module[
   {public, masters, legacyIntegrals, oldPublicLeakQ, privateTokens, representationAudit},
   public = dsTreePublicizeData018[result, context];
   If[ListQ[Lookup[public, "masters", None]],
    masters = public["masters"];
    If[And @@ (AssociationQ /@ masters),
     public = Join[public, <|"bareMasters" -> Lookup[masters, "integral", {}]|>]
     ]
    ];
   If[ListQ[Lookup[public, "contactMaps", None]],
    public = Join[public, <|"sourceEquations" -> Lookup[public["contactMaps"], "rowsByVertex", {}]|>]
    ];
   representationAudit = If[
      auditLevel === "full",
      legacyIntegrals = DeleteDuplicates[Cases[public, item : J[_List] :> item, Infinity]];
      oldPublicLeakQ = dsTimeOnlyOldIntegralLeakQ020[public];
      privateTokens = DeleteDuplicates[Cases[public, _dsTreeToken, Infinity]];
      <|"status" -> "audited", "passQ" -> TrueQ[legacyIntegrals === {} && ! oldPublicLeakQ && privateTokens === {}],
        "legacyVertexIntegrals" -> legacyIntegrals, "oldPublicIntegralLeakQ" -> oldPublicLeakQ,
        "privateTreeTokens" -> privateTokens|>,
      <|"status" -> "producerGuaranteed", "passQ" -> True,
        "legacyVertexIntegrals" -> {}, "oldPublicIntegralLeakQ" -> False, "privateTreeTokens" -> {},
       "reason" -> "unified public conversion completed by the same producer"|>
     ];
   Join[public, <|
     "representation" -> "J[sectorKey,timeShifts,stateBits]",
     "auditLevel" -> auditLevel,
     "publicRepresentationAudit" -> representationAudit
     |>]
   ];


DSTreeNaiveIBP[context_Association, masters_: Automatic, OptionsPattern[]] /; dsContextQ[context] := Module[
   {formulaMasters, raw},
   If[treeFormulaMasslessPendingQ018[context],
    Return[treeFormulaPendingRederivation018["DSTreeNaiveIBP", context]]
    ];
   formulaMasters = If[masters === Automatic,
     Automatic,
     dsTreeMasterToFormula018[#, context] & /@ masters
     ];
   If[ListQ[formulaMasters] && MemberQ[formulaMasters, $Failed],
    Return[<|"status" -> "failed", "reason" -> "invalidUnifiedMasters"|>]
    ];
   raw = dsTreeNaiveIBPRaw018[
     context,
     formulaMasters,
     AuditLevel -> OptionValue[AuditLevel],
     ProgressReporting -> OptionValue[ProgressReporting]
     ];
   If[AssociationQ[raw], dsTreePublicResult018[raw, context, OptionValue[AuditLevel]], raw]
   ];


DSTreeNaiveDE[context_Association, variables_: Automatic, masters_: Automatic, OptionsPattern[]] /;
   dsContextQ[context] := Module[{formulaMasters, raw},
   If[treeFormulaMasslessPendingQ018[context],
    Return[treeFormulaPendingRederivation018["DSTreeNaiveDE", context]]
    ];
   formulaMasters = If[masters === Automatic,
     Automatic,
     dsTreeMasterToFormula018[#, context] & /@ masters
     ];
   If[ListQ[formulaMasters] && MemberQ[formulaMasters, $Failed],
    Return[<|"status" -> "failed", "reason" -> "invalidUnifiedMasters"|>]
    ];
    raw = dsTreeNaiveDERaw018[
     context,
     variables,
      formulaMasters,
      AuditLevel -> OptionValue[AuditLevel],
      ProgressReporting -> OptionValue[ProgressReporting]
     ];
   If[AssociationQ[raw], dsTreePublicResult018[raw, context, OptionValue[AuditLevel]], raw]
   ];


(* 支持把公开 DSTreeNaiveIBP 返回值直接传回 DSTreeNaiveDE；只在表示审计通过时跨越边界。 *)
DSTreeNaiveDE[ibpData_Association, variables_: Automatic, OptionsPattern[]] /;
   Lookup[ibpData, "status", "failed"] === "solved" &&
     Lookup[ibpData, "representation", None] === "J[sectorKey,timeShifts,stateBits]" := Module[
   {context, formulaData, raw},
   context = Lookup[ibpData, "context", Missing["context"]];
   If[! dsContextQ[context] ||
     ! TrueQ[Lookup[Lookup[ibpData, "publicRepresentationAudit", <||>], "passQ", False]],
    Return[<|"status" -> "failed", "reason" -> "invalidPublicNaiveIBPData"|>]
    ];
   formulaData = dsTreeNaiveIBPDataToFormula018[ibpData, context];
   If[formulaData === $Failed,
    Return[<|"status" -> "failed", "reason" -> "publicNaiveIBPConversionFailed"|>]
    ];
   raw = dsTreeNaiveDEFromIBP[
     formulaData,
     variables,
     ProgressReporting -> OptionValue[ProgressReporting]
     ];
   If[AssociationQ[raw], dsTreePublicResult018[raw, context, OptionValue[AuditLevel]], raw]
   ];


Options[DSTreeDLogDE] = {AuditLevel -> "standard"};


DSTreeDLogDE[context_Association, opts : OptionsPattern[]] /; dsContextQ[context] := Module[{raw},
   If[treeFormulaMasslessPendingQ018[context],
    Return[treeFormulaPendingRederivation018["DSTreeDLogDE", context]]
    ];
   raw = dsTreeMultiSectorDLog[context, Automatic, OptionValue[AuditLevel]];
   If[AssociationQ[raw], dsTreePublicResult018[raw, context, OptionValue[AuditLevel]], raw]
   ];


DSTreeDLogDE[context_Association, seedData_, opts : OptionsPattern[]] /; dsContextQ[context] := Module[{raw},
   If[treeFormulaMasslessPendingQ018[context],
    Return[treeFormulaPendingRederivation018["DSTreeDLogDE", context]]
    ];
   raw = dsTreeMultiSectorDLog[context, seedData, OptionValue[AuditLevel]];
   If[AssociationQ[raw], dsTreePublicResult018[raw, context, OptionValue[AuditLevel]], raw]
   ];

(* ::Package:: *)

(* 本文件集中冻结 018 的运行时 Message 文本。所有消息逐句先中文、后英文；
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

End[];
EndPackage[];
