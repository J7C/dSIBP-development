(* ::Package:: *)
(* 使用长期 bubble 的积分表检查 package userMI 坐标、backend ID 与导数闭包。 *)

(* ::Chapter:: *)
(*Package 与 family 输入*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "_harness.wls"}]];
projectRoot = ExpandFileName@FileNameJoin[{DirectoryName[$InputFileName], "..", ".."}];
exampleDir = FileNameJoin[{projectRoot, "versions", "022_dSIBP", "Examples", "04_pure_massive_bubble_closed_loop"}];
dsSmokeLoadPackage[FileNameJoin[{projectRoot, "versions", "022_dSIBP", "Kernel", "dSIBP.wl"}]];
DSMessagesOff[];
Get[FileNameJoin[{exampleDir, "reference_user_mi_basis.wl"}]];
Get[FileNameJoin[{exampleDir, "family_conventions.wl"}]];

parameterRules = {dim -> 37/11, nu -> 7/13, etaNu -> 23/17};
caseInput = <|
   "name" -> "018PureMassiveBubbleClosedLoopMinusMinus",
   "vertices" -> {
     <|"id" -> v1, "vertexType" -> "-", "externalLegEnergy" -> P0|>,
     <|"id" -> v2, "vertexType" -> "-", "externalLegEnergy" -> P0|>
     },
   "lines" -> {
     <|"id" -> 1, "massType" -> "massive", "endpoints" -> {v1, v2},
       "momentum" -> q, "nu" -> nu|>,
     <|"id" -> 2, "massType" -> "massive", "endpoints" -> {v1, v2},
       "momentum" -> q - k, "nu" -> nu|>
     },
   "loopMomenta" -> {q},
   "loopExternalMomenta" -> {k},
   "independentExternalMomenta" -> {},
   "ibpMode" -> "full",
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[v1] -> 2 nu, a0[v2] -> 2 nu,
     b0[1] -> -2 nu, b0[2] -> -2 nu
     },
   "symmetryRules" -> exampleSymmetryRules0
   |>;
context = DSInit[caseInput, RegisterAsCurrent -> False];


(* ::Chapter:: *)
(*从 reference basis 自身构造积分支撑与解析一阶导数闭包，不读取 Kira 运行产物*)

userMISpec = <|
    "names" -> pureMassiveBubbleUserMINames,
    "activeIndices" -> pureMassiveBubbleUserMIActiveIndices,
    "derivativeVariables" -> pureMassiveBubbleUserMIDerivativeVariables,
    "scalingDegrees" -> (pureMassiveBubbleUserMIScalingDegrees /. parameterRules)
    |>;
basisSupport = DeleteDuplicates@Cases[pureMassiveBubbleUserMIExpressions, _J, Infinity];

makeSyntheticLinearData[order_List] := <|
   "status" -> "generated",
   "dSIBPStatus" -> "generated",
   "caseName" -> caseInput["name"],
   "integralList" -> order,
   "integralCount" -> Length[order],
   "integralRules" -> Normal@AssociationThread[order, Range[Length[order]]],
   "linearEquations" -> {},
   "topology" -> context["topology"],
   "sectorMetadataList" -> context["sectors"],
   "contextCapabilities" -> context["capabilities"],
   "completeSystemQ" -> True
   |>;

closureProbe = Quiet[
   DSUserMI[
    makeSyntheticLinearData[basisSupport],
    pureMassiveBubbleUserMIExpressions /. parameterRules,
    userMISpec
    ],
   DSUserMI::badbasis
   ];
closureIntegrals = Lookup[closureProbe, "missingDerivativeIntegrals", {}];
integralList = DeleteDuplicates@Join[basisSupport, closureIntegrals];
linearData = makeSyntheticLinearData[integralList];
prepared = DSUserMI[
   linearData,
   pureMassiveBubbleUserMIExpressions /. parameterRules,
   userMISpec
   ];
userData = DSUserMI[prepared];
formalPlan = DSKiraPlan[prepared, <|"stage" -> "formal", "activeBasis" -> Automatic|>];

checks = <|
   "configured" -> (Lookup[prepared, "status", "failed"] === "generated"),
   "candidateRank" -> (Lookup[userData, "rank", 0] === 21),
   "activeRank" -> (Lookup[userData, "activeRank", 0] === 19),
   "supportCount" -> (Lookup[userData, "supportCount", 0] === 37),
   "closureProbeFailedClosed" -> (
     Lookup[closureProbe, "reason", None] === "derivativeTargetOutsideLinearSystem" &&
      closureIntegrals =!= {}
     ),
   "reversible" -> TrueQ[Lookup[userData, "reversibleQ", False]],
   "forwardRoundTrip" -> (Lookup[userData, "forwardRoundTripResiduals", {1}] === ConstantArray[0, 21]),
   "reverseRoundTrip" -> (Lookup[userData, "reverseRoundTripResiduals", {1}] === ConstantArray[0, 21]),
   "publicTokens" -> (Lookup[userData, "activeTokens", {}] === (userMI /@ Range[19])),
   "backendIDs" -> (Lookup[userData, "activeBackendIDs", {}] === Range[19]),
   "backendTokens" -> (Lookup[userData, "activeBackendTokens", {}] === (Tuserweight /@ Range[19])),
   "manifestValidation" -> TrueQ[dSIBP`Private`dsKiraActiveBasisDataQ[prepared["activeBasis"]]],
   "derivativeClosure" -> (Lookup[Lookup[prepared, "activeBasis", <||>], "derivativeTargetIntegrals", {}] =!= {}),
   "formalPlan" -> (Lookup[formalPlan, "status", "failed"] === "planned"),
   "planOrderPreserved" -> (Lookup[formalPlan, "integralOrder", {}] === integralList),
   "reorderAfterUserMIRejected" -> (Lookup[Quiet[DSReorderIntegrals[prepared, {First[integralList]}]], "reason", None] === "reorderMustPrecedeUserMI"),
   "publicAPI" -> MemberQ[DSPublicAPI[]["functions"], "DSUserMI"]
   |>;

failed = Keys@Select[checks, Not@TrueQ[#] &];
Print["check_user_mi_basis: ", Count[Values[checks], True], "/", Length[checks]];
Print["failed: ", InputForm[failed]];
Print[InputForm[<|
  "passed" -> Count[Values[checks], True],
  "total" -> Length[checks],
  "failed" -> failed,
  "preparedFailure" -> KeyTake[prepared, {"status", "reason", "missingDerivativeIntegrals", "derivativeVariables"}],
  "checks" -> checks
  |>]];
If[Count[Values[checks], True] =!= Length[checks], Exit[1]];
