(* ::Package:: *)
(* 016 显式动量角色示例：bubble 的 cycle momenta 为 l1 与 l1+k1+k2，bridge 和 bubble
   另一外腿均携带 k1+k2，三点顶点另接 k1、k2。本例覆盖角色审计、参数重定义、
   用户变量微分 metadata、bridge 指标以及两类动量列表和坐标规则的完备性负例。 *)

(* ::Chapter:: *)
(*加载标准 package*)

exampleDir = DirectoryName[$InputFileName];
packageDir = ExpandFileName[FileNameJoin[{exampleDir, "..", "..", "..", "..", "000_code", "016_dSIBP"}]];
If[! MemberQ[$Path, packageDir], AppendTo[$Path, packageDir]];
Needs["dSIBP`"];


(* ::Chapter:: *)
(*详细物理输入*)

(* loopExternalMomenta 只需给 shift-invariant loop 方向 {k1+k2}；其完整 Gram 产生 ss11。
   independentExternalMomenta 只给 loop Gram 尚未覆盖的实际无圈模长 {k1,k2}，产生 sE1,sE2。
   bridge/bubble 外腿的 |k1+k2| 已由 ss11 覆盖，不再生成 sE3 或 sp[k1,k2]。 *)
caseInput = <|
   "name" -> "016BubbleTreeK1K2",
   "vertexData" -> {{v1, "+"}, {v2, "+"}, {v3, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> l1,
       "nu" -> nu1, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> l1 + k1 + k2,
       "nu" -> nu2, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 3, "endpoints" -> {v2, v3}, "momentum" -> k1 + k2,
       "nu" -> nu3, "bbType" -> "h", "massType" -> "massive"|>
     },
   "extLegs" -> {
     {bubbleLeg, v1, k1 + k2},
     {treeLeg1, v3, k1},
     {treeLeg2, v3, k2}
     },
   "loopMomenta" -> {l1},
   "loopExternalMomenta" -> {k1 + k2},
   "independentExternalMomenta" -> {k1, k2},
   "ibpMode" -> "full",
   (* 顶点相位能量是用户给出的独立标量，不由传播子三动量或 Hankel 指标推断。 *)
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2, v3 -> E3|>,
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2, a0[v3] -> alpha3,
     b0[1] -> beta1, b0[2] -> beta2, b0[3] -> beta3
     },
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;


(* ::Chapter:: *)
(*变量提案与缺省选项*)

kinematicProposal = DSKinematics[caseInput];
kinematicProposal["selectionTemplate"]
kinematicProposal["parameterRedefinitionGuide"]

(* 缺省为 KinematicRules->Automatic，直接采用上一单元格显示的规则。
   其它缺省为不写 init、不预生成微分 metadata、不覆盖不同输入、注册为当前 context。 *)
kinematicRules = Automatic;
initOptions = {
   WriteInitializationFiles -> True,
   InitializationDirectory -> FileNameJoin[{exampleDir, "init"}],
   GenerateDerivativeMetadata -> True,
   OverwriteInitialization -> True,
   RegisterAsCurrent -> True,
   ProgressReporting -> True,
   KinematicRules -> kinematicRules
   };


(* ::Chapter:: *)
(*初始化、notation 与公开原子操作*)

DSMessagesOn[];
context = DSInit[caseInput, Sequence @@ initOptions];
topology = Lookup[context, "topology", <||>];
contextInfo = DSInfo[context, "Full"];
notation = DSParameterNotation[context];
publicAPI = DSPublicAPI[];

(* cycle line pack 为 {b,n1,n2}；bridge pack 只有 {n1,n2}。 *)
integral = J[
   {0, 0, 0},
   {{0, 0, 0}, {0, 0, 0}, {0, 0}},
   {}
   ];

timeSeed = dtau[v3, integral, topology];
loopLoopSeed = dqq[1, 1, integral, topology];
loopExternalSeed = dqk[1, 1, integral, topology];
totalDerivative = ds[ss11^2 integral + sE1 integral, sE1, topology];
innerCoordinate = rep2innerform[sp[k1 + k2, k1 + k2], topology];
outerCoordinate = rep2outform[innerCoordinate, topology];
integrandForm = rep2Integrand[integral, topology];
rawSymmetryRules = repSymmetry0[topology];
canonicalIntegral = symmetry[integral, topology];


(* ::Chapter:: *)
(*用户参数重定义*)

(* 左端必须复制 baseCoordinateOrder 中的原始 sp[...]，不能写 ss11->loopScale。
   右端写自定义参数表达式；规则必须覆盖全部基础方向。新 context 的 seed、ds、DSDE
   和 GenerateDerivativeMetadata 都改用 {loopScale,legScale1,legScale2}。 *)
customRules = {
   sp[k1 + k2, k1 + k2] -> loopScale^2,
   sp[k1, k1] -> legScale1^2,
   sp[k2, k2] -> legScale2^2
   };
customContext = DSRedefineParameters[context, customRules, ProgressReporting -> True];
customTopology = Lookup[customContext, "topology", <||>];
customNotation = DSParameterNotation[customContext];
customDerivative = ds[loopScale^2 integral + legScale1 integral, legScale1, customTopology];
customDerivativeVariables = Lookup[Lookup[customContext, "derivatives", <||>], "operators", {}][[All, "userVariable"]];


(* ::Chapter:: *)
(*两个外腿模长和的用户坐标绑定*)

(* 保留 k1、k2 两条外腿，并令 E0=|k1|+|k2|。规则左端仍写原始平方不变量；
   当前参数化选择 |k1|=E0-sE2 的物理支，因此应用区域应满足 E0>sE2>0。 *)
boundEnergyInput = Join[
   caseInput,
   <|"name" -> "016BubbleTreeBoundEnergy", "vertexEnergies" -> <|v1 -> E1, v2 -> E2, v3 -> E0|>|>
   ];
boundEnergyContext0 = DSInit[
   boundEnergyInput,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> True,
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];
boundEnergyContext = DSRedefineParameters[
   boundEnergyContext0,
   {
    sp[k1 + k2, k1 + k2] -> ss11^2,
    sp[k1, k1] -> (E0 - sE2)^2,
    sp[k2, k2] -> sE2^2
    },
   ProgressReporting -> False
   ];
boundEnergyVariables = Lookup[
   Lookup[boundEnergyContext, "derivatives", <||>],
   "operators",
   {}
   ][[All, "userVariable"]];


(* ::Chapter:: *)
(*单一有效外腿的独立拓扑输入*)

(* v3 不再保留 k1、k2 两条外腿，而改为一条 p0 外腿；E0 是 |p0| 及 v3 相位能量。
   这是新的 topology metadata，不是原 family 的纯坐标重命名。 *)
singleLegInput = Join[
   caseInput,
   <|
    "name" -> "016BubbleTreeSingleEffectiveLeg",
    "extLegs" -> {
      {bubbleLeg, v1, k1 + k2},
      {treeLeg0, v3, p0}
      },
    "independentExternalMomenta" -> {p0},
    "vertexEnergies" -> <|v1 -> E1, v2 -> E2, v3 -> E0|>
    |>
   ];
singleLegContext0 = DSInit[
   singleLegInput,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> True,
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];
singleLegContext = DSRedefineParameters[
   singleLegContext0,
   {
    sp[k1 + k2, k1 + k2] -> ss11^2,
    sp[p0, p0] -> E0^2
    },
   ProgressReporting -> False
   ];
singleLegVariables = Lookup[
   Lookup[singleLegContext, "derivatives", <||>],
   "operators",
   {}
   ][[All, "userVariable"]];


(* ::Chapter:: *)
(*动量列表与自定义坐标的过完备/欠完备输入*)

(* loop 列表过完备：多给独立方向 k1-k2；红色 warning 后可生成 symbolic IBP，
   但 ds、DSDE 与唯一 rep2innerform 关闭。 *)
overLoopInput = Join[caseInput, <|"loopExternalMomenta" -> {k1 + k2, k1 - k2}|>];
overLoopAudit = DSKinematics[overLoopInput];
overLoopContext = DSInit[overLoopInput, RegisterAsCurrent -> False, ProgressReporting -> False];

(* loop 列表欠完备：{k1} 不覆盖 k1+k2；红色 error 给出 missingDirections 并拒绝初始化。 *)
underLoopInput = Join[caseInput, <|"loopExternalMomenta" -> {k1}|>];
underLoopAudit = DSKinematics[underLoopInput];
underLoopContext = DSInit[underLoopInput, RegisterAsCurrent -> False, ProgressReporting -> False];

(* independent 列表过完备：k1-k2 的模长已由 {|k1+k2|,|k1|,|k2|} 决定。 *)
overIndependentInput = Join[caseInput, <|"independentExternalMomenta" -> {k1, k2, k1 - k2}|>];
overIndependentAudit = DSKinematics[overIndependentInput];
overIndependentContext = DSInit[overIndependentInput, RegisterAsCurrent -> False, ProgressReporting -> False];

(* independent 列表欠完备：只给 k1 时缺少 |k2|。 *)
underIndependentInput = Join[caseInput, <|"independentExternalMomenta" -> {k1}|>];
underIndependentAudit = DSKinematics[underIndependentInput];
underIndependentContext = DSInit[underIndependentInput, RegisterAsCurrent -> False, ProgressReporting -> False];

(* 自定义坐标过完备：同一个基础平方再绑定 alternateLegScale1；欠完备：删除 |k2| 规则。 *)
overCustomRules = Append[customRules, sp[k1, k1] -> alternateLegScale1^2];
overCustomAudit = DSKinematics[caseInput, overCustomRules];
overCustomContext = DSRedefineParameters[context, overCustomRules, ProgressReporting -> False];
underCustomRules = Most[customRules];
underCustomAudit = DSKinematics[caseInput, underCustomRules];
underCustomContext = DSRedefineParameters[context, underCustomRules, ProgressReporting -> False];


(* ::Chapter:: *)
(*结果检查*)

bridgePacks = Cases[
   {timeSeed, loopLoopSeed, loopExternalSeed, totalDerivative, customDerivative},
   J[_, packs_, _] :> packs[[3]],
   Infinity
   ];

coverage = Lookup[notation, "requiredMagnitudeCoverage", {}];
coverageRules = Lookup[coverage, "squaredExpression", {}] -> Lookup[coverage, "userSquaredExpression", {}];
defaultDerivativeVariables = Lookup[
   Lookup[context, "derivatives", <||>],
   "operators",
   {}
   ][[All, "userVariable"]];

DSMessagesOff[];
messagesDisabledQ = ! DSMessagesQ[];
DSMessagesOn[];

summary = <|
   "version" -> $dSIBPVersion,
   "initStatus" -> Lookup[context, "status", "missing"],
   "graphLoopCount" -> Lookup[topology, "graphLoopCount", Missing["loopCount"]],
   "loopExternalMomenta" -> Lookup[notation, "loopExternalMomenta", {}],
   "independentExternalMomenta" -> Lookup[notation, "independentExternalMomenta", {}],
   "notationVariables" -> Lookup[notation, "selectedUserVariables", {}],
   "requiredMagnitudeCoverage" -> coverage,
   "defaultDerivativeVariables" -> defaultDerivativeVariables,
   "customVariables" -> Lookup[customNotation, "selectedUserVariables", {}],
   "customDerivativeVariables" -> customDerivativeVariables,
   "boundEnergyStatus" -> Lookup[boundEnergyContext, "status", "failed"],
   "boundEnergyVariables" -> boundEnergyVariables,
   "singleLegStatus" -> Lookup[singleLegContext, "status", "failed"],
   "singleLegMomenta" -> Lookup[Lookup[singleLegContext, "topology", <||>], "independentExternalMomenta", {}],
   "singleLegVariables" -> singleLegVariables,
   "redefinitionUsesOriginalSP" -> StringContainsQ[Lookup[Lookup[notation, "parameterRedefinitionGuide", <||>], "commandExample", ""], "sp[k1 + k2, k1 + k2]"],
   "bridgePackHasNoB" -> And @@ (FreeQ[#, _b | _bS] & /@ bridgePacks),
   "timeSeedUsesBridgeMagnitude" -> ! FreeQ[timeSeed, ss11],
   "momentumSeedsLeaveBridgePack" -> And @@ (Length[#] == 2 & /@ Cases[{loopLoopSeed, loopExternalSeed}, J[_, packs_, _] :> packs[[3]], Infinity]),
   "totalDerivativeIncludesCoefficientTerm" -> ! FreeQ[totalDerivative, integral],
   "coordinateRoundTrip" -> Together[outerCoordinate - ss11^2] === 0,
   "integrandUsesFixedBridgeMagnitude" -> ! FreeQ[integrandForm, ss11] && FreeQ[integrandForm, xi[3]],
   "rawSymmetryUnionIsList" -> ListQ[rawSymmetryRules],
   "canonicalIntegral" -> canonicalIntegral,
   "publicFunctionCount" -> Length[Lookup[publicAPI, "functions", {}]],
   "overLoopStatus" -> Lookup[overLoopAudit, "status", "missing"],
   "underLoopStatus" -> Lookup[underLoopAudit, "status", "missing"],
   "overIndependentStatus" -> Lookup[overIndependentAudit, "status", "missing"],
   "underIndependentStatus" -> Lookup[underIndependentAudit, "status", "missing"],
   "overCustomStatus" -> Lookup[overCustomAudit, "status", "missing"],
   "underCustomStatus" -> Lookup[underCustomAudit, "status", "missing"],
   "overContextsContinue" -> And @@ (Lookup[#, "status", "failed"] === "initialized" & /@ {overLoopContext, overIndependentContext, overCustomContext}),
   "overDerivativesDisabled" -> And @@ (! TrueQ[Lookup[Lookup[#, "capabilities", <||>], "derivativeUsableQ", True]] & /@ {overLoopContext, overIndependentContext, overCustomContext}),
   "underContextsRejected" -> And @@ (Lookup[#, "status", "initialized"] === "failed" & /@ {underLoopContext, underIndependentContext, underCustomContext}),
   "messagesDisabledQ" -> messagesDisabledQ,
   "contextInfoAvailable" -> AssociationQ[contextInfo]
   |>;

Print[InputForm[summary]];
If[! And[
    summary["version"] === "016",
    summary["initStatus"] === "initialized",
    summary["graphLoopCount"] === 1,
    summary["loopExternalMomenta"] === {k1 + k2},
    summary["independentExternalMomenta"] === {k1, k2},
    summary["notationVariables"] === {ss11, sE1, sE2},
    summary["defaultDerivativeVariables"] === {ss11, sE1, sE2, E1, E2, E3},
    summary["customVariables"] === {loopScale, legScale1, legScale2},
    summary["customDerivativeVariables"] === {
      loopScale, legScale1, legScale2, E1, E2, E3
      },
    summary["boundEnergyStatus"] === "initialized",
    summary["boundEnergyVariables"] === {ss11, E0, sE2, E1, E2},
    summary["singleLegStatus"] === "initialized",
    summary["singleLegMomenta"] === {p0},
    summary["singleLegVariables"] === {ss11, E0, E1, E2},
    summary["redefinitionUsesOriginalSP"],
    summary["bridgePackHasNoB"],
    summary["timeSeedUsesBridgeMagnitude"],
    summary["momentumSeedsLeaveBridgePack"],
    summary["coordinateRoundTrip"],
    summary["integrandUsesFixedBridgeMagnitude"],
    summary["overLoopStatus"] === "overcomplete",
    summary["underLoopStatus"] === "undercomplete",
    summary["overIndependentStatus"] === "overcomplete",
    summary["underIndependentStatus"] === "undercomplete",
    summary["overCustomStatus"] === "overcomplete",
    summary["underCustomStatus"] === "incomplete",
    summary["overContextsContinue"],
    summary["overDerivativesDisabled"],
    summary["underContextsRejected"],
    summary["messagesDisabledQ"],
    summary["contextInfoAvailable"]
    ], Exit[1]];
