(* ::Package:: *)

(* 本文件为 DSGenerateIBP 产生的 linearData 构造 reference-style 积分顺序、
   预约化 targets 和解析 derivative closure。package 只生成计划与输入，不运行 Kira。 *)


(* ::Chapter:: *)
(*016 Kira 排序与两阶段 reduction 计划*)

DSKiraPlan::badlinear = "DSKiraPlan 需要 DSLinear 返回的 backend-neutral linearData。 DSKiraPlan requires backend-neutral linearData returned by DSLinear.";
DSKiraPlan::badspec = "Kira 计划配置无效：`1`。 The Kira plan specification is invalid: `1`.";
DSKiraPlan::badstage = "stage 只允许 \"preReduction\" 或 \"formal\"，收到 `1`。 stage must be \"preReduction\" or \"formal\"; received `1`.";
DSKiraPlan::badbasis = "formal 计划需要可闭合的 activeBasis：`1`。 A formal plan requires a closed activeBasis: `1`.";


Options[DSKiraPlan] = {ProgressReporting -> Automatic};


(* ::Section::Closed:: *)
(*Reference-style 积分顺序*)

dsKiraPlanIntegralFromItem[item_, linearData_Association] := Which[
   Head[item] === J && MemberQ[linearData["integralList"], item], item,
   IntegerQ[item] && 1 <= item <= linearData["integralCount"], linearData["integralList"][[item]],
   True, Missing["UnknownIntegral", item]
   ];


dsKiraPlanIntegralList[items_List, linearData_Association] := DeleteDuplicates@DeleteMissing[
   dsKiraPlanIntegralFromItem[#, linearData] & /@ items
   ];


dsKiraPlanReferenceKey[int_J, preferred_List, metadata_List] := Module[
   {allContinuous, aValues, bValues, ispValues, nValues, negativePenalty, preferredPosition,
    sectorKey, sectorRank},
   aValues = numericIndexValue /@ int[[1]];
   bValues = numericIndexValue /@ Cases[Flatten[int[[2]]], _b | _bS];
   ispValues = numericIndexValue /@ int[[3]];
   nValues = numericIndexValue /@ Cases[Flatten[int[[2]]], _n];
   allContinuous = Join[aValues, bValues, ispValues];
   negativePenalty = If[AnyTrue[allContinuous, # < 0 &], 50, 0];
   preferredPosition = FirstPosition[preferred, int, Missing["NotPreferred"], {1}, Heads -> False];
   sectorKey = integralSectorKey[int, metadata];
   sectorRank = If[sectorKey === "top", 1, 2 + FirstPosition[Lookup[metadata, "sectorKey", {}], sectorKey, {10^6}][[1]]];
   {
    If[Head[preferredPosition] === Missing, 1, 0],
    If[Head[preferredPosition] === Missing, 10^9, First[preferredPosition]],
    Total[Abs /@ allContinuous], negativePenalty, sectorRank,
    Total[aValues], aValues, bValues, ispValues, nValues, ToString[int, InputForm]
    }
   ];


dsKiraPlanReferenceOrder[linearData_Association, preferred_List] := SortBy[
   linearData["integralList"],
   dsKiraPlanReferenceKey[#, preferred, Lookup[linearData, "sectorMetadataList", {}]] &
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
   preferred = dsKiraPlanIntegralList[Lookup[spec, "preferredIntegrals", {}], linearData];
   order = dsKiraPlanReferenceOrder[linearData, preferred];
   ordered = reorderLinearSystemIntegrals[linearData, order];
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
      "orderingConvention" -> "referenceActiveThenComplexityPenaltySectorIndices",
      "preferredIntegrals" -> preferred, "targetIntegrals" -> candidates,
      "targetCount" -> Length[candidates], "activeBasis" -> None,
      "numericStage" -> "symbolic", "coefficientRules" -> coefficientRules,
      "outputDirectory" -> outputDirectory, "jobOptions" -> jobOptions,
      "phaseIsolation" -> <|"stage" -> stage, "requiresSeparateOutputDirectoryQ" -> True|>
      |>]
    ];
   activeSetting = Lookup[spec, "activeBasis", Missing["activeBasis"]];
   If[! AssociationQ[activeSetting],
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
    "orderingConvention" -> "referenceActiveThenComplexityPenaltySectorIndices",
    "preferredIntegrals" -> preferred, "activeBasis" -> activeSetting,
    "activeBasisPreview" -> activeData,
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

DSKiraExport[plan_Association] /; dsKiraPlanQ[plan] := Module[{result, manifest, path},
   result = DSKiraExport[
     plan["linearData"],
     KiraActiveBasis -> plan["activeBasis"],
     KiraIntegralOrder -> plan["integralOrder"],
     KiraTargetIntegrals -> Lookup[plan, "targetIntegrals", Automatic],
     KiraCoefficientRules -> plan["coefficientRules"],
     KiraJobOptions -> plan["jobOptions"],
     KiraNumericStage -> plan["numericStage"],
     OutputDirectory -> plan["outputDirectory"]
     ];
   If[Lookup[result, "status", "failed"] =!= "ready", Return[result]];
   manifest = Join[Lookup[result, "dSIBPExportManifest", <||>], <|
      "kiraPlan" -> KeyDrop[plan, {"linearData", "activeBasisPreview"}]
      |>];
   path = Lookup[result, "dSIBPExportManifestPath", Missing["NotWritten"]];
   If[StringQ[path], Quiet[Check[Put[manifest, path], Null]]];
   Join[result, <|"dSIBPExportManifest" -> manifest|>]
   ];
