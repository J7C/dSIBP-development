(* ::Package:: *)
(* 016 显式动量角色示例：一圈 bubble 通过 bridge 连接第三顶点，第三顶点再连两条外腿。
   本例覆盖参数 notation/redefine、bridge 指标、原子 IBP/求导以及完备性错误输入。 *)

(* ::Chapter:: *)
(*加载标准 package*)

exampleDir = DirectoryName[$InputFileName];
packageDir = ExpandFileName[FileNameJoin[{exampleDir, "..", "..", "..", "..", "000_code", "016_dSIBP"}]];
If[! MemberQ[$Path, packageDir], AppendTo[$Path, packageDir]];
Needs["dSIBP`"];


(* ::Chapter:: *)
(*详细物理输入*)

(* 用户必须显式区分两类动量：
   1. loopExternalMomenta={k} 生成完整 loop Gram 根号 ss11=Sqrt[sp[k,k]]；
   2. independentExternalMomenta={p1,p2,p1+p2} 只为实际出现的模长生成 sE1,sE2,sE3，
      不自动生成 sp[p1,p2]。符号名没有语义，换成 alice/bob 也完全等价。 *)
caseInput = <|
   "name" -> "016BubbleBridgeTwoExternalLegs",
   "vertexData" -> {{v1, "+"}, {v2, "+"}, {v3, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "nu" -> nu1, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q + k,
       "nu" -> nu2, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 3, "endpoints" -> {v2, v3}, "momentum" -> p1 + p2,
       "treeEnergy" -> bridgeEnergy, "nu" -> nu3, "bbType" -> "h", "massType" -> "massive"|>
     },
   "extLegs" -> {{leg1, v3, p1}, {leg2, v3, p2}},
   "loopMomenta" -> {q},
   "loopExternalMomenta" -> {k},
   "independentExternalMomenta" -> {p1, p2, p1 + p2},
   "ibpMode" -> "full",
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
totalDerivative = ds[ss11^2 integral + sE3 integral, sE3, topology];
innerCoordinate = rep2innerform[sp[k, k], topology];
outerCoordinate = rep2outform[innerCoordinate, topology];
integrandForm = rep2Integrand[integral, topology];
rawSymmetryRules = repSymmetry0[topology];
canonicalIntegral = symmetry[integral, topology];


(* ::Chapter:: *)
(*用户参数重定义*)

(* 规则必须覆盖缺省提案的全部独立方向；新 context 会用于后续 seed、ds 和 DSDE。
   正式 API 拼写为 DSRedefineParameters，不使用会暗示全局赋值的 redefineParamater。 *)
customRules = {
   sp[k, k] -> loopScale^2,
   sp[p1, p1] -> legScale1^2,
   sp[p2, p2] -> legScale2^2,
   sp[p1 + p2, p1 + p2] -> legScale12^2
   };
customContext = DSRedefineParameters[context, customRules, ProgressReporting -> True];
customNotation = DSParameterNotation[customContext];


(* ::Chapter:: *)
(*过完备与欠完备错误输入*)

(* 过完备：红色 warning 后允许初始化，但唯一反变换和 ds/DE 能力关闭。 *)
overcompleteInput = Join[caseInput, <|
    "independentExternalMomenta" -> {p1, p2, p1 + p2, 2 p1}
    |>];
overcompleteContext = DSInit[
   overcompleteInput,
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];

(* 欠完备：缺少 |p1+p2|，返回 missingMagnitudeSquares 并拒绝初始化。 *)
undercompleteInput = Join[caseInput, <|
    "independentExternalMomenta" -> {p1, p2}
    |>];
undercompleteAudit = DSKinematics[undercompleteInput];
undercompleteContext = DSInit[
   undercompleteInput,
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];


(* ::Chapter:: *)
(*结果检查*)

bridgePacks = Cases[
   {timeSeed, loopLoopSeed, loopExternalSeed, totalDerivative},
   J[_, packs_, _] :> packs[[3]],
   Infinity
   ];

DSMessagesOff[];
messagesDisabledQ = ! DSMessagesQ[];
DSMessagesOn[];

summary = <|
   "version" -> $dSIBPVersion,
   "initStatus" -> Lookup[context, "status", "missing"],
   "graphLoopCount" -> Lookup[topology, "graphLoopCount", Missing["loopCount"]],
   "notationVariables" -> Lookup[notation, "selectedUserVariables", {}],
   "customVariables" -> Lookup[customNotation, "selectedUserVariables", {}],
   "bridgePackHasNoB" -> And @@ (FreeQ[#, _b | _bS] & /@ bridgePacks),
   "timeSeedUsesBridgeMagnitude" -> ! FreeQ[timeSeed, sE3 | bridgeEnergy],
   "momentumSeedsLeaveBridgePack" -> And @@ (Length[#] == 2 & /@ Cases[{loopLoopSeed, loopExternalSeed}, J[_, packs_, _] :> packs[[3]], Infinity]),
   "totalDerivativeIncludesCoefficientTerm" -> ! FreeQ[totalDerivative, integral],
   "coordinateRoundTrip" -> Together[outerCoordinate - ss11^2] === 0,
   "integrandUsesFixedBridgeMagnitude" -> ! FreeQ[integrandForm, sE3 | bridgeEnergy] && FreeQ[integrandForm, xi[3]],
   "rawSymmetryUnionIsList" -> ListQ[rawSymmetryRules],
   "canonicalIntegral" -> canonicalIntegral,
   "publicFunctionCount" -> Length[Lookup[publicAPI, "functions", {}]],
   "overcompleteContinues" -> Lookup[overcompleteContext, "status", "failed"] === "initialized",
   "overcompleteDerivativeDisabled" -> ! TrueQ[Lookup[Lookup[overcompleteContext, "capabilities", <||>], "derivativeUsableQ", True]],
   "undercompleteStatus" -> Lookup[undercompleteAudit, "status", "missing"],
   "undercompleteMissing" -> Lookup[undercompleteAudit, "missingMagnitudeSquares", {}],
   "undercompleteRejected" -> Lookup[undercompleteContext, "status", "initialized"] === "failed",
   "messagesDisabledQ" -> messagesDisabledQ,
   "contextInfoAvailable" -> AssociationQ[contextInfo]
   |>;

Print[InputForm[summary]];
If[! And[
    summary["version"] === "016",
    summary["initStatus"] === "initialized",
    summary["graphLoopCount"] === 1,
    summary["notationVariables"] === {ss11, sE1, sE2, sE3},
    summary["customVariables"] === {loopScale, legScale1, legScale2, legScale12},
    summary["bridgePackHasNoB"],
    summary["timeSeedUsesBridgeMagnitude"],
    summary["momentumSeedsLeaveBridgePack"],
    summary["coordinateRoundTrip"],
    summary["integrandUsesFixedBridgeMagnitude"],
    summary["overcompleteContinues"],
    summary["overcompleteDerivativeDisabled"],
    summary["undercompleteStatus"] === "undercomplete",
    summary["undercompleteMissing"] =!= {},
    summary["undercompleteRejected"],
    summary["messagesDisabledQ"],
    summary["contextInfoAvailable"]
    ], Exit[1]];
