(* ::Package:: *)

(***
文件：run_validation_main.wl
用途：独立验证 MadStree v0.11 正规化角域、自动候选容量和候选池耗尽合同。
边界：只调用当前公共 MSReconstructEpSeries 和当前 adapter CLI，不读取 validation-01。
***)

(* ::Chapter:: *)
(*路径、fresh-clean 与输出工具*)

validationRoot = DirectoryName[$InputFileName];
madStreeRoot = ExpandFileName@FileNameJoin[{validationRoot, "..", "..", "versions", "MadStree-v0.11"}];
kernelRoot = FileNameJoin[{madStreeRoot, "Kernel"}];
adapterFile = FileNameJoin[{madStreeRoot, "Backend", "flintnde_transport.py"}];
vendorRoot = FileNameJoin[{madStreeRoot, "Vendor", "FlintNDE"}];
runtimeRoot = FileNameJoin[{validationRoot, "results_temp"}];
runtimeAngle = FileNameJoin[{runtimeRoot, "angle"}];
runtimeCapacity = FileNameJoin[{runtimeRoot, "capacity"}];
runtimeSchema = FileNameJoin[{runtimeRoot, "schema"}];
resultsRoot = FileNameJoin[{validationRoot, "results"}];
summaryFile = FileNameJoin[{resultsRoot, "summary.wl"}];
evidenceFile = FileNameJoin[{resultsRoot, "evidence.json"}];
reportFile = FileNameJoin[{validationRoot, "000_MadStree-v0.11-validation-02-ep-angle-capacity-report.md"}];
pythonExecutable = With[{override = Quiet[Environment["MADSTREE_PYTHON"]]},
  If[StringQ[override] && StringLength[StringTrim[override]] > 0, StringTrim[override], "python"]
];

Scan[
  Function[path,
    If[DirectoryQ[path],
      Quiet@Check[DeleteDirectory[path, DeleteContents -> True], $Failed];
      If[DirectoryQ[path], Print["fresh cleanup failed: ", path]; Exit[1]]
    ]
  ],
  {runtimeRoot, resultsRoot}
];
If[FileExistsQ[reportFile],
  Quiet@Check[DeleteFile[reportFile], $Failed];
  If[FileExistsQ[reportFile], Print["fresh cleanup failed: ", reportFile]; Exit[1]]
];
Scan[
  If[! DirectoryQ[#], CreateDirectory[#, CreateIntermediateDirectories -> True]] &,
  {resultsRoot, runtimeSchema, runtimeAngle, runtimeCapacity}
];
SetEnvironment["PYTHONDONTWRITEBYTECODE" -> "1"];

writeUTF8LF[path_String, text_String] := Module[{stream, normalized},
  normalized = StringReplace[text, {"\r\n" -> "\n", "\r" -> "\n"}];
  stream = OpenWrite[path, BinaryFormat -> True];
  If[stream === $Failed, Return[$Failed]];
  BinaryWrite[stream, ToCharacterCode[normalized, "UTF-8"], "Byte"];
  Close[stream]
];

restoreUTF8SourceText[text_String] := StringJoin@Map[
  Function[group,
    Module[{part, codes, decoded},
      part = StringJoin[group];
      If[AllTrue[ToCharacterCode[part], # <= 255 &],
        codes = ToCharacterCode[part, "ISOLatin1"];
        decoded = Quiet@Check[FromCharacterCode[codes, "UTF-8"], $Failed];
        If[StringQ[decoded] && ToCharacterCode[decoded, "UTF-8"] === codes, decoded, part],
        part
      ]
    ]
  ],
  SplitBy[Characters[text], Function[character, First[ToCharacterCode[character]] <= 255]]
];

sha256[file_String] := IntegerString[FileHash[file, "SHA256"], 16, 64];
jsonSafe[value_Association] := Association@KeyValueMap[ToString[#1] -> jsonSafe[#2] &, value];
jsonSafe[value_List] := jsonSafe /@ value;
jsonSafe[value_String | value_Integer | value_Real | value_True | value_False | value_Null] := value;
jsonSafe[value_] := ToString[value, InputForm];

runAdapterPlan[payload_Association, stem_String] := Module[
  {inputFile, outputFile, process, imported},
  inputFile = FileNameJoin[{runtimeSchema, stem <> "-input.json"}];
  outputFile = FileNameJoin[{runtimeSchema, stem <> "-output.json"}];
  If[writeUTF8LF[inputFile, ExportString[payload, "RawJSON"] <> "\n"] === $Failed,
    Return[Failure["SchemaInputWriteFailed", <|"path" -> inputFile|>]]
  ];
  process = RunProcess[{pythonExecutable, adapterFile, inputFile, outputFile}];
  If[process["ExitCode"] =!= 0 || ! FileExistsQ[outputFile],
    Return[Failure["SchemaAdapterFailed", <|"process" -> process, "output" -> outputFile|>]]
  ];
  imported = Import[outputFile, "RawJSON"];
  <|"input" -> payload, "output" -> imported, "process" -> process|>
];


(* ::Chapter:: *)
(*显式加载 v0.11 与真实三顶点输入*)

AppendTo[$Path, kernelRoot];
Needs["MadStree`"];
treeSpec = <|
  "vertices" -> {
    <|"id" -> v1, "energy" -> k1, "timePower" -> a1, "phaseSign" -> 1|>,
    <|"id" -> v2, "energy" -> k2, "timePower" -> a2, "phaseSign" -> 1|>,
    <|"id" -> v3, "energy" -> k3, "timePower" -> a3, "phaseSign" -> 1|>
  },
  "lines" -> {
    <|"id" -> l12, "type" -> "masslessFull", "endpoints" -> {v1, v2},
      "momentum" -> q12, "skType" -> "++", "nu" -> 1/2|>,
    <|"id" -> l23, "type" -> "masslessFull", "endpoints" -> {v2, v3},
      "momentum" -> q23, "skType" -> "++", "nu" -> 1/2|>
  }
|>;
context = MSInitTree[treeSpec];
de = MSDLogDE[context];
epPointTemplate = {{
  k1 -> -9 I, k2 -> -3 I, k3 -> -5 I,
  q12 -> 1, q23 -> 2,
  a1 -> 1 + ep, a2 -> 1 + ep, a3 -> 1 + ep
}};
angleRange = {-Pi/3, Pi/3};
productionCandidates = {1/100, 1/110, 1/120};
validationCandidates = {1/130, 1/140};
commonOptions = {
  ParallelTaskCount -> 5,
  FlintNDEPathPlanning -> True,
  BoundaryScale -> 4,
  BoundarySeriesOrder -> 50,
  RankOrder -> {v1, v2, v3},
  MessageLanguage -> "CN",
  PythonExecutable -> pythonExecutable
};


(* ::Chapter:: *)
(*默认 schema 与角域 plan 独立探针*)

schemaBase = <|
  "schema" -> "madstree_flintnde_ep_series_control_v1",
  "action" -> "production_plan",
  "backendPackagePath" -> vendorRoot,
  "maximumPower" -> 0,
  "goalDigits" -> 12,
  "leadingPower" -> 0,
  "sampleSpacing" -> "0.01",
  "validationSampleCount" -> 2,
  "validationScale" -> "0.5",
  "maximumSamples" -> 100,
  "extraWorkingPrecision" -> 0.,
  "productionRound" -> 1,
  "fitExtraOrder" -> 2,
  "fitOrderIncrement" -> 2,
  "fitMaximumRounds" -> 1
|>;
{schemaWall, schemaProbe} = AbsoluteTiming[runAdapterPlan[schemaBase, "default"]];
If[Head[schemaProbe] === Failure, Print[InputForm[schemaProbe]]; Exit[2]];
anglePlanProbe = runAdapterPlan[
  Append[schemaBase, "sampleAngleRange" ->
    (StringReplace[ToString[N[#, 60], InputForm], RegularExpression["`.*$"] -> ""] & /@ angleRange)],
  "angle"
];
If[Head[anglePlanProbe] === Failure, Print[InputForm[anglePlanProbe]]; Exit[2]];


(* ::Chapter:: *)
(*公共入口：显式开角域*)

{angleWall, angleResult} = AbsoluteTiming[MSReconstructEpSeries[
  context,
  ep,
  epPointTemplate,
  MaximumEpPower -> 0,
  EpGoalDigits -> 12,
  EpSamplePoints -> Automatic,
  EpSampleAngleRange -> angleRange,
  EpValidationPoints -> Automatic,
  EpFitMaximumRounds -> 1,
  MSRuntimeDirectory -> runtimeAngle,
  Sequence @@ commonOptions
]];
If[Head[angleResult] === Failure, Print[InputForm[angleResult]]; Exit[3]];


(* ::Chapter:: *)
(*公共入口：显式候选池耗尽*)

{capacityWall, capacityResult} = AbsoluteTiming[MSReconstructEpSeries[
  context,
  ep,
  epPointTemplate,
  MaximumEpPower -> 0,
  EpGoalDigits -> 20,
  EpSamplePoints -> productionCandidates,
  EpValidationPoints -> validationCandidates,
  EpInitialInternalMaximumPower -> 2,
  EpFitMaximumRounds -> 1,
  MSRuntimeDirectory -> runtimeCapacity,
  Sequence @@ commonOptions
]];
If[Head[capacityResult] === Failure, Print[InputForm[capacityResult]]; Exit[4]];


(* ::Chapter:: *)
(*几何、路径、容量和状态验收*)

exactGaussianRationalQ[value_] := NumericQ[value] && FreeQ[value, _Real] &&
  MatchQ[Re[value], _Integer | _Rational] && MatchQ[Im[value], _Integer | _Rational];
angleProduction = angleResult["productionEpValues"];
angleValidation = angleResult["validationEpValues"];
angleArguments = Arg /@ N[angleProduction, 80];
angleLabels = DeleteDuplicates[Round[angleArguments, 10^-30]];
capacityActualProduction = capacityResult["productionEpValues"];
capacityActualValidation = capacityResult["validationEpValues"];
capacityAllEp = Lookup[capacityResult["pointEvaluations"], "ep"];

representativeEvaluation[result_Association] := Module[{record, evaluation, segments},
  record = First[result["pointEvaluations"]];
  evaluation = record["evaluation"];
  segments = evaluation["segments"];
  <|
    "ep" -> ToString[record["ep"], InputForm],
    "boundary" -> jsonSafe[evaluation["boundary"]],
    "pathPlanning" -> evaluation["pathPlanning"],
    "segmentCount" -> Length[segments],
    "segments" -> Map[
      Function[segment,
        <|
          "segmentIndex" -> segment["segmentIndex"],
          "physicalStart" -> ToString[segment["startRules"], InputForm],
          "physicalTarget" -> ToString[segment["targetRules"], InputForm],
          "actualNodes" -> Lookup[segment["flintNDE"], "actualNodes", {}],
          "nodeCount" -> Lookup[segment["flintNDE"], "nodeCount", Missing["NotAvailable"]],
          "relativeDifferenceInf" -> Lookup[segment["flintNDE"], "relativeDifferenceInf", Missing["NotAvailable"]],
          "targetRelativeErrorMet" -> Lookup[segment["flintNDE"], "targetRelativeErrorMet", Missing["NotAvailable"]],
          "certificationMode" -> Lookup[segment["flintNDE"], "certificationMode", Missing["NotAvailable"]],
          "planReport" -> KeyDrop[
            jsonSafe[Lookup[segment["flintNDE"], "planReport", <||>]],
            "messages"
          ]
        |>
      ],
      segments
    ]
  |>
];
representativeAngle = representativeEvaluation[angleResult];
representativeCapacity = representativeEvaluation[capacityResult];

allPointTargets[result_Association] := And @@ Flatten@Map[
  Function[record,
    Lookup[Lookup[record["evaluation", "segments"], "flintNDE"], "targetRelativeErrorMet", False]
  ],
  result["pointEvaluations"]
];

checks = <|
  "version011" -> MadStree`Private`$MadStreeVersion === "0.11",
  "schemaInputOmitsAngleRange" -> ! KeyExistsQ[schemaProbe["input"], "sampleAngleRange"],
  "schemaAdapterSucceeded" -> schemaProbe["process", "ExitCode"] === 0 && schemaProbe["output", "status"] === "success",
  "schemaDefaultAutomatic" -> schemaProbe["output", "sampleSource"] === "automatic",
  "anglePublicComputed" -> angleResult["status"] === "computed" && TrueQ[angleResult["precisionTargetMet"]],
  "angleUsesAutomaticCandidates" -> angleResult["productionEpCandidateValues"] === Automatic,
  "anglePlanSource" -> angleResult["productionPlan", "sampleSource"] === "automatic-angle-range",
  "anglePlanKeepsAutomaticRadius" -> angleResult["productionPlan", "baseSample"] === schemaProbe["output", "baseSample"] &&
    angleResult["productionPlan", "alphaEpsilon"] === schemaProbe["output", "alphaEpsilon"],
  "angleDirectPlanMatchesPublic" -> anglePlanProbe["output", "points"] === angleResult["productionPlan", "points"],
  "angleExactDistinctNonzeroProduction" -> AllTrue[angleProduction, exactGaussianRationalQ] &&
    DuplicateFreeQ[angleProduction] && FreeQ[angleProduction, 0],
  "angleExactDistinctNonzeroValidation" -> AllTrue[angleValidation, exactGaussianRationalQ] &&
    DuplicateFreeQ[angleValidation] && FreeQ[angleValidation, 0] && DisjointQ[angleProduction, angleValidation],
  "angleStrictlyOpen" -> AllTrue[angleArguments, TrueQ[N[First[angleRange], 80] < # < N[Last[angleRange], 80]] &],
  "angleAtMostThreeRays" -> Length[angleLabels] <= 3,
  "angleRealPointEvaluation" -> Length[angleResult["pointEvaluations"]] === Length[angleProduction] + Length[angleValidation],
  "anglePathRefinementPassed" -> allPointTargets[angleResult],
  "capacityWarningStatus" -> capacityResult["status"] === "computed_with_warning",
  "capacityTargetNotMet" -> ! TrueQ[capacityResult["precisionTargetMet"]],
  "capacityFailureReason" -> capacityResult["precisionFailureReason"] === "candidate_pool_exhausted",
  "capacityReturnsCoefficients" -> AssociationQ[capacityResult["coefficients"]] && Length[capacityResult["coefficients"]] > 0,
  "capacityProductionSubset" -> SubsetQ[productionCandidates, capacityActualProduction],
  "capacityValidationExact" -> capacityActualValidation === validationCandidates,
  "capacityAllEvaluationsInPools" -> SubsetQ[Join[productionCandidates, validationCandidates], capacityAllEp],
  "capacityNoUnusedCandidate" -> capacityResult["productionPlan", "unusedCandidateCount"] === 0,
  "capacityRealPointEvaluation" -> Length[capacityResult["pointEvaluations"]] === 5,
  "capacityPathRefinementPassed" -> allPointTargets[capacityResult],
  "runtimeUnderValidationRoot" -> DirectoryName[runtimeRoot] === validationRoot
|>;
passedCount = Count[Values[checks], True];
status = If[passedCount === Length[checks], "passed", "failed"];


(* ::Chapter:: *)
(*源码身份、机器证据与中文报告*)

commit = StringTrim@RunProcess[{"git", "rev-parse", "HEAD"}, "StandardOutput"];
digests = <|
  "MadStreeKernelSHA256" -> sha256[FileNameJoin[{madStreeRoot, "Kernel", "MadStree.wl"}]],
  "PathEvaluationSHA256" -> sha256[FileNameJoin[{madStreeRoot, "Kernel", "Numerics", "PathEvaluation.wl"}]],
  "adapterSHA256" -> sha256[adapterFile],
  "vendorRegularizationSHA256" -> sha256[FileNameJoin[{vendorRoot, "flintnde", "regularization.py"}]],
  "validationRunnerSHA256" -> sha256[FileNameJoin[{validationRoot, "run_validation_main.wl"}]]
|>;
convention = <|
  "columnVector" -> "Y'=A(s)Y",
  "masters" -> ToString[de["masters"], InputForm],
  "normalization" -> jsonSafe[Lookup[de["masters"], "normalization"]],
  "HankelBranch" -> Lookup[representativeAngle["boundary"], "branchConvention", "see boundary evidence"],
  "tree" -> "massless three-vertex chain v1--v2--v3 with q12=1, q23=2",
  "physicalPoint" -> ToString[First[epPointTemplate], InputForm]
|>;
evidence = <|
  "schema" -> "madstree_v0.11_ep_angle_capacity_validation_v1",
  "status" -> status,
  "baselineCommit" -> commit,
  "digests" -> digests,
  "freshRun" -> <|
    "cleanupBeforeNumericalWork" -> True,
    "runtimeRoot" -> runtimeRoot,
    "repositoryRootRuntimeUsed" -> False
  |>,
  "convention" -> convention,
  "schemaProbe" -> jsonSafe[schemaProbe],
  "anglePlanProbe" -> jsonSafe[anglePlanProbe],
  "angleRoute" -> <|
    "wallSeconds" -> angleWall,
    "sampleAngleRange" -> ToString[angleRange, InputForm],
    "productionEpValues" -> (ToString[#, InputForm] & /@ angleProduction),
    "validationEpValues" -> (ToString[#, InputForm] & /@ angleValidation),
    "anglesRadians" -> (ToString[#, InputForm] & /@ angleArguments),
    "rayCount" -> Length[angleLabels],
    "productionPlan" -> jsonSafe[angleResult["productionPlan"]],
    "leadingPower" -> angleResult["leadingPower"],
    "maximumPower" -> angleResult["maximumPower"],
    "workingPrecisionDigits" -> angleResult["productionPlan", "workingPrecisionDigits"],
    "primaryOrder" -> angleResult["productionPlan", "primaryOrder"],
    "referenceOrder" -> angleResult["productionPlan", "referenceOrder"],
    "targetRelativeError" -> angleResult["productionPlan", "targetRelativeError"],
    "maximumValidationRelativeResidual" -> jsonSafe[angleResult["maximumValidationRelativeResidual"]],
    "representativeEvaluation" -> representativeAngle
  |>,
  "capacityRoute" -> <|
    "wallSeconds" -> capacityWall,
    "requestedProductionCandidates" -> (ToString[#, InputForm] & /@ productionCandidates),
    "actualProductionEpValues" -> (ToString[#, InputForm] & /@ capacityActualProduction),
    "requestedValidationPoints" -> (ToString[#, InputForm] & /@ validationCandidates),
    "actualValidationEpValues" -> (ToString[#, InputForm] & /@ capacityActualValidation),
    "allEvaluatedEpValues" -> (ToString[#, InputForm] & /@ capacityAllEp),
    "status" -> capacityResult["status"],
    "precisionTargetMet" -> capacityResult["precisionTargetMet"],
    "precisionFailureReason" -> capacityResult["precisionFailureReason"],
    "precisionWarning" -> capacityResult["precisionWarning"],
    "coefficients" -> jsonSafe[capacityResult["coefficients"]],
    "maximumValidationRelativeResidual" -> jsonSafe[capacityResult["maximumValidationRelativeResidual"]],
    "productionPlan" -> jsonSafe[capacityResult["productionPlan"]],
    "leadingPower" -> capacityResult["leadingPower"],
    "maximumPower" -> capacityResult["maximumPower"],
    "workingPrecisionDigits" -> capacityResult["productionPlan", "workingPrecisionDigits"],
    "primaryOrder" -> capacityResult["productionPlan", "primaryOrder"],
    "referenceOrder" -> capacityResult["productionPlan", "referenceOrder"],
    "targetRelativeError" -> capacityResult["productionPlan", "targetRelativeError"],
    "representativeEvaluation" -> representativeCapacity
  |>,
  "timing" -> <|"schemaProbeWallSeconds" -> schemaWall, "angleWallSeconds" -> angleWall,
    "capacityWallSeconds" -> capacityWall, "totalRouteWallSeconds" -> schemaWall + angleWall + capacityWall|>,
  "checks" -> checks
|>;
If[writeUTF8LF[evidenceFile, ExportString[jsonSafe[evidence], "RawJSON"] <> "\n"] === $Failed,
  Print["evidence write failed: ", evidenceFile]; Exit[5]
];

summary = <|
  "status" -> status,
  "baselineCommit" -> commit,
  "digests" -> digests,
  "convention" -> convention,
  "freshRun" -> evidence["freshRun"],
  "schemaProbe" -> <|"wallSeconds" -> schemaWall, "sampleSource" -> schemaProbe["output", "sampleSource"],
    "inputKeys" -> Keys[schemaProbe["input"]], "output" -> schemaProbe["output"]|>,
  "angleRoute" -> KeyDrop[evidence["angleRoute"], "representativeEvaluation"],
  "capacityRoute" -> KeyDrop[evidence["capacityRoute"], "representativeEvaluation"],
  "representativeAnglePath" -> representativeAngle,
  "representativeCapacityPath" -> representativeCapacity,
  "timing" -> evidence["timing"],
  "checks" -> checks,
  "passedCount" -> passedCount,
  "totalCount" -> Length[checks],
  "evidenceFile" -> evidenceFile
|>;
If[writeUTF8LF[summaryFile, ToString[summary, InputForm] <> "\n"] === $Failed,
  Print["summary write failed: ", summaryFile]; Exit[5]
];

report = StringRiffle[{
  "# MadStree v0.11 独立验证 02：正规化角域与候选容量",
  "",
  "- 日期：" <> DateString[{"Year", "-", "Month", "-", "Day"}],
  "- 状态：`" <> status <> "`（" <> ToString[passedCount] <> "/" <> ToString[Length[checks]] <> "）",
  "- Git baseline commit：`" <> commit <> "`；当前未提交被测源码由 `results/summary.wl` 中四项 SHA-256 唯一标识。",
  "- 独立性：本 runner 不读取 validation-01、旧 summary 或旧 expected；运行前物理删除本专项旧结果、runtime 与报告。",
  "",
  "## 物理输入与数值约定",
  "",
  "真实无质量三顶点链 `v1--v2--v3`，传播子 `q12=1,q23=2`，点为 `k1=-9 I,k2=-3 I,k3=-5 I`，共同正规化 `a1=a2=a3=1+ep`。master 顺序=`" <> convention["masters"] <> "`；normalization 和 Hankel branch 见机器摘要与 boundary 证据。DE 约定为 `Y'=A(s)Y`。",
  "",
  "两条公共入口路线均使用自动路径规划、BoundaryScale=4、boundary series order=50。角域路线 Laurent 阶 " <>
    ToString[angleResult["leadingPower"]] <> ".." <> ToString[angleResult["maximumPower"]] <>
    "，工作精度/主阶/参考阶=" <> StringRiffle[
      ToString /@ Lookup[angleResult["productionPlan"], {"workingPrecisionDigits", "primaryOrder", "referenceOrder"}], "/"] <>
    "，目标误差=`" <> angleResult["productionPlan", "targetRelativeError"] <> "`。候选耗尽路线对应参数=" <>
    StringRiffle[
      ToString /@ Lookup[capacityResult["productionPlan"], {"workingPrecisionDigits", "primaryOrder", "referenceOrder"}], "/"] <>
    "，目标误差=`" <> capacityResult["productionPlan", "targetRelativeError"] <> "`。实际 boundary、anchor、segment、FlintNDE actualNodes、refinement 与 certification mode 保存在 `results/evidence.json`。",
  "代表性角域点从 regular-singular Frobenius 坐标 `t=" <>
    ToString[Lookup[representativeAngle["boundary"], "singularStart", 0]] <> "` 输运到 `t=" <>
    ToString[Lookup[representativeAngle["boundary"], "singularTarget", 1]] <> "`；物理 anchor=`" <>
    representativeAngle["segments"][[1, "physicalStart"]] <> "`，终点=`" <>
    representativeAngle["segments"][[1, "physicalTarget"]] <> "`。FlintNDE 实际节点数=" <>
    ToString[representativeAngle["segments"][[1, "nodeCount"]]] <> "，refinement=`" <>
    ToString[representativeAngle["segments"][[1, "relativeDifferenceInf"]]] <> "`，target gate=" <>
    ToString[representativeAngle["segments"][[1, "targetRelativeErrorMet"]]] <> "，certification=`" <>
    ToString[representativeAngle["segments"][[1, "certificationMode"]]] <>
    "`。局部奇点展开阶不适用；本任务使用边界 Frobenius 级数与普通点主/参考阶输运。",
  "",
  "## 三条 fresh 路线",
  "",
  "1. 默认 schema CLI 探针：输入键不含 `sampleAngleRange`，adapter ExitCode=" <> ToString[schemaProbe["process", "ExitCode"]] <>
    "，返回 `sampleSource=\"" <> schemaProbe["output", "sampleSource"] <> "\"`。耗时 " <> ToString[schemaWall] <> " 秒。",
  "2. 显式角域公共入口：`EpSampleAngleRange->{-Pi/3,Pi/3}`，返回 " <> ToString[Length[angleProduction]] <>
    " 个生产点、" <> ToString[Length[angleValidation]] <> " 个独立验证点，内部射线数=" <> ToString[Length[angleLabels]] <>
    "，全部角度严格位于开区间。`sampleSource=\"automatic-angle-range\"`；baseSample/alphaEpsilon 与默认 plan 相同，故模长仍由程序自动决定。耗时 " <> ToString[angleWall] <> " 秒。",
  "3. 候选容量公共入口：生产候选=`" <> ToString[productionCandidates, InputForm] <> "`，独立验证点=`" <>
    ToString[validationCandidates, InputForm] <> "`。返回 `" <> capacityResult["status"] <> "`、`precisionTargetMet=" <>
    ToString[capacityResult["precisionTargetMet"]] <> "`、reason=`" <> capacityResult["precisionFailureReason"] <>
    "`；仍保留 " <> ToString[Length[capacityResult["coefficients"]]] <> " 组系数。全部实际 ep 求值均属于两个人工集合，没有池外点。最大验证相对 residual=`" <>
    ToString[capacityResult["maximumValidationRelativeResidual"], InputForm] <> "`。耗时 " <> ToString[capacityWall] <> " 秒。",
  "",
  "## 结论",
  "",
  If[status === "passed",
    "本专项通过。默认 schema、开角域 exact Gaussian-rational 点、真实路径/refinement、候选池耗尽 warning 与无池外点合同均由 fresh 运行互相复核。",
    "本专项失败；失败键见 `results/summary.wl`，不得据此认证当前 v0.11。"
  ]
}, "\n"];
report = restoreUTF8SourceText[report];
If[writeUTF8LF[reportFile, report <> "\n"] === $Failed,
  Print["report write failed: ", reportFile]; Exit[5]
];

If[DirectoryQ[runtimeRoot], DeleteDirectory[runtimeRoot, DeleteContents -> True]];
Print["MadStree v0.11 validation-02: ", passedCount, "/", Length[checks], " ", status];
Print["report: ", reportFile];
If[status =!= "passed", Print["failed: ", Keys@Select[checks, Not@TrueQ[#] &]]; Exit[1]];
