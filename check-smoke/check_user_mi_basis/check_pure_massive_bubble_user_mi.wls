(* ::Package:: *)
(* 使用长期 bubble 的积分表检查 package userMI 坐标、backend ID 与导数闭包。 *)

(* ::Chapter:: *)
(*Package 与 family 输入*)

projectRoot = ExpandFileName@FileNameJoin[{DirectoryName[$InputFileName], "..", ".."}];
packageRoot = FileNameJoin[{projectRoot, "000_code", "018_dSIBP"}];
exampleDir = FileNameJoin[{projectRoot, "independent-benchmark", "package", "examples", "04_pure_massive_bubble_closed_loop"}];
candidateArguments = Select[
   $ScriptCommandLine,
   StringQ[#] && StringMatchQ[FileNameTake[#], "package_" ~~ __ ~~ ".wl"] && FileExistsQ[#] &
   ];
candidatePackage = If[candidateArguments =!= {}, Last[candidateArguments], Quiet@Environment["DSIBP_CHECK_PACKAGE"]];
If[StringQ[candidatePackage] && candidatePackage =!= "",
 Get[ExpandFileName[candidatePackage]],
 If[! MemberQ[$Path, packageRoot], AppendTo[$Path, packageRoot]];
 Needs["dSIBP`"]
 ];
DSMessagesOff[];
Get[FileNameJoin[{exampleDir, "reference_user_mi_basis.wl"}]];
Get[FileNameJoin[{exampleDir, "family_conventions.wl"}]];

parameterRules = {dim -> 37/11, nu -> 7/13, etaNu -> 23/17};
caseInput = <|
   "name" -> "018PureMassiveBubbleClosedLoopMinusMinus",
   "vertexData" -> {{v1, "-"}, {v2, "-"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nu|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nu|>
     },
   "loopMomenta" -> {q},
   "loopExternalMomenta" -> {k},
   "independentExternalMomenta" -> {},
   "ibpMode" -> "full",
   "vertexEnergies" -> <|v1 -> P0, v2 -> P0|>,
   "ispData" -> {},
   "numericRules" -> parameterRules,
   "zeroPointRules" -> {
     a0[v1] -> 2 nu, a0[v2] -> 2 nu,
     b0[1] -> -2 nu, b0[2] -> -2 nu
     },
   "shrinkPrefactorRules" -> {Exp[Pi Im[nu]]/Pi -> etaNu},
   "symmetryRules" -> exampleSymmetryRules0,
   "seedPreset" -> "quickCheck",
   "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0}|>
   |>;
context = DSInit[caseInput, RegisterAsCurrent -> False];


(* ::Chapter:: *)
(*复用正式积分表，不运行 seed 或 reduction*)

manifest = Get[FileNameJoin[{exampleDir, "kira", "dsibp-export-manifest.wl"}]];
integralList = manifest["integralList"];
linearData = <|
   "status" -> "generated",
   "dSIBPStatus" -> "generated",
   "caseName" -> caseInput["name"],
   "integralList" -> integralList,
   "integralCount" -> Length[integralList],
   "integralRules" -> Normal@AssociationThread[integralList, Range[Length[integralList]]],
   "linearEquations" -> {},
   "topology" -> context["topology"],
   "sectorMetadataList" -> context["sectors"],
   "contextCapabilities" -> context["capabilities"],
   "completeSystemQ" -> True
   |>;

prepared = DSUserMI[
   linearData,
   pureMassiveBubbleUserMIExpressions /. parameterRules,
   <|
    "names" -> pureMassiveBubbleUserMINames,
    "activeIndices" -> pureMassiveBubbleUserMIActiveIndices,
    "derivativeVariables" -> pureMassiveBubbleUserMIDerivativeVariables,
    "scalingDegrees" -> (pureMassiveBubbleUserMIScalingDegrees /. parameterRules)
    |>
   ];
userData = DSUserMI[prepared];
formalPlan = DSKiraPlan[prepared, <|"stage" -> "formal", "activeBasis" -> Automatic|>];

checks = <|
   "configured" -> (Lookup[prepared, "status", "failed"] === "generated"),
   "candidateRank" -> (Lookup[userData, "rank", 0] === 21),
   "activeRank" -> (Lookup[userData, "activeRank", 0] === 19),
   "supportCount" -> (Lookup[userData, "supportCount", 0] === 37),
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

failed = Keys@Select[checks, ! TrueQ[#] &];
Print[<|"passed" -> Count[Values[checks], True], "total" -> Length[checks], "failed" -> failed|>];
If[failed =!= {}, Exit[1]];
