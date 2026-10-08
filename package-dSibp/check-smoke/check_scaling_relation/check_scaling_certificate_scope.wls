(* ::Package:: *)
(***
文件：check_scaling_certificate_scope.wls
用途：验证 DSScaleCheck 按实际固定的 scaling variables 区分全符号、固定截面与精确点证书。
输入：当前 dSIBP 候选单文件；脚本内构造一维齐次 DE 的三类 scope 和错误反例。
输出：标准输出中的逐项检查计数；不写结果文件。
边界：不生成 IBP、Kira 输入或 reduction，只测试 scaling consumer 的返回合同。
***)


(* ::Chapter:: *)
(*候选加载与合成 DE*)

scriptDirectory = DirectoryName[$InputFileName];
packageRoot = DirectoryName[DirectoryName[scriptDirectory]];
packageCandidate = FileNameJoin[{packageRoot, "independent-benchmark", "package", "package_023.0.wl"}];

If[! FileExistsQ[packageCandidate],
  Print["当前 dSIBP 候选不存在，因此标度证书范围检查不会运行。 " <>
    "The current dSIBP candidate is missing, so the scaling-certificate scope check will not run."];
  Exit[1]
];

Get[packageCandidate, CharacterEncoding -> "UTF-8"];

symbolicDE = <|
  "status" -> "generated",
  "masters" -> {userMI[1]},
  "variables" -> {x, y},
  "matrices" -> <|x -> {{1/x}}, y -> {{0}}|>,
  "sources" -> <|x -> {0}, y -> {0}|>,
  "activeBasis" -> <|"scalingDegrees" -> {1}|>,
  "sourceManifest" -> <|"kiraPlan" -> <|"numericStage" -> "symbolic"|>|>,
  "context" -> <||>
|>;

exactPointDE = <|
  "status" -> "generated",
  "masters" -> {userMI[1]},
  "variables" -> {x, y},
  "matrices" -> <|x -> {{1/2}}, y -> {{0}}|>,
  "sources" -> <|x -> {0}, y -> {0}|>,
  "activeBasis" -> <|"scalingDegrees" -> {1}|>,
  "sourceManifest" -> <|
    "kiraPlan" -> <|
      "numericStage" -> "postDerivative",
      "coefficientRules" -> {x -> 2, y -> 3, fixedParameter -> 5}
    |>,
    "physicalCoefficientRulesApplied" -> {x -> 2, y -> 3, fixedParameter -> 5}
  |>,
  "context" -> <||>
|>;

fixedSectionDE = <|
  "status" -> "generated",
  "masters" -> {userMI[1]},
  "variables" -> {x, y},
  "matrices" -> <|x -> {{1/2}}, y -> {{0}}|>,
  "sources" -> <|x -> {0}, y -> {0}|>,
  "activeBasis" -> <|"scalingDegrees" -> {1}|>,
  "sourceManifest" -> <|
    "kiraPlan" -> <|
      "numericStage" -> "postDerivative",
      "coefficientRules" -> {x -> 2, fixedParameter -> 5}
    |>,
    "physicalCoefficientRulesApplied" -> {x -> 2, fixedParameter -> 5}
  |>,
  "context" -> <||>
|>;

postDerivativeSymbolicDE = Join[
  symbolicDE,
  <|"sourceManifest" -> <|
    "kiraPlan" -> <|
      "numericStage" -> "postDerivative",
      "coefficientRules" -> {fixedParameter -> 5}
    |>,
    "physicalCoefficientRulesApplied" -> {fixedParameter -> 5}
  |>|>
];


(* ::Chapter:: *)
(*两种证书范围与错误反例*)

scaleSpec = <|
  "relation" -> "Custom", "variables" -> {x, y}, "weights" -> {1, 1}, "degrees" -> {1}
|>;

symbolicScale = DSScaleCheck[symbolicDE, scaleSpec];
postDerivativeSymbolicScale = DSScaleCheck[postDerivativeSymbolicDE, scaleSpec];
fixedSectionScale = DSScaleCheck[fixedSectionDE, scaleSpec];
exactPointScale = DSScaleCheck[exactPointDE, scaleSpec];
badPointScale = DSScaleCheck[
  Join[exactPointDE, <|"matrices" -> <|x -> {{1/3}}, y -> {{0}}|>|>],
  scaleSpec
];

checks = <|
  "symbolicStatus" -> (Lookup[symbolicScale, "status", "failed"] === "passed"),
  "symbolicScope" -> (Lookup[symbolicScale, "certificateScope", "missing"] === "symbolic"),
  "symbolicFlag" -> TrueQ[Lookup[symbolicScale, "symbolicQ", False]],
  "symbolicResidual" -> (Lookup[symbolicScale, "matrixResidual", Missing["matrixResidual"]] === {{0}}),
  "symbolicChecks" ->
    (Keys@Lookup[symbolicScale, "checks", <||>] === {"symbolicMatrixRelation", "symbolicSourceRelation"}),
  "postDerivativeCanRemainSymbolic" ->
    (Lookup[postDerivativeSymbolicScale, "status", "failed"] === "passed" &&
      Lookup[postDerivativeSymbolicScale, "certificateScope", "missing"] === "symbolic" &&
      TrueQ[Lookup[postDerivativeSymbolicScale, "symbolicQ", False]]),
  "postDerivativeFixedNoScalingVariables" ->
    (Lookup[postDerivativeSymbolicScale, "fixedScalingVariables", Missing["fixedScalingVariables"]] === {}),
  "fixedSectionStatus" -> (Lookup[fixedSectionScale, "status", "failed"] === "passed"),
  "fixedSectionScope" ->
    (Lookup[fixedSectionScale, "certificateScope", "missing"] === "fixedSection"),
  "fixedSectionVariables" ->
    (Lookup[fixedSectionScale, "fixedScalingVariables", {}] === {x}),
  "fixedSectionNotSymbolic" -> ! TrueQ[Lookup[fixedSectionScale, "symbolicQ", True]],
  "fixedSectionChecks" ->
    (Keys@Lookup[fixedSectionScale, "checks", <||>] ===
      {"fixedSectionMatrixRelation", "fixedSectionSourceRelation"}),
  "pointStatus" -> (Lookup[exactPointScale, "status", "failed"] === "passed"),
  "pointScope" -> (Lookup[exactPointScale, "certificateScope", "missing"] === "exactPoint"),
  "pointFixedAllScalingVariables" ->
    (Lookup[exactPointScale, "fixedScalingVariables", {}] === {x, y}),
  "pointNotSymbolic" -> ! TrueQ[Lookup[exactPointScale, "symbolicQ", True]],
  "pointCoordinates" -> (Lookup[exactPointScale, "evaluatedVariables", {}] === {2, 3}),
  "pointResidual" -> (Lookup[exactPointScale, "matrixResidual", Missing["matrixResidual"]] === {{0}}),
  "pointChecks" ->
    (Keys@Lookup[exactPointScale, "checks", <||>] === {"exactPointMatrixRelation", "exactPointSourceRelation"}),
  "noDuplicatePointResidualFields" ->
    FreeQ[Keys[exactPointScale], "pointMatrixResidual" | "pointSourceResidual"],
  "badPointRejected" -> (Lookup[badPointScale, "status", "passed"] === "failed"),
  "badPointResidualNonzero" ->
    (Lookup[badPointScale, "matrixResidual", Missing["matrixResidual"]] === {{-1/3}})
|>;

failedChecks = Keys@Select[checks, ! TrueQ[#] &];
Print["check_scaling_certificate_scope: ", Count[Values[checks], True], "/", Length[checks]];
Print["failed: ", InputForm[failedChecks]];
If[failedChecks =!= {}, Exit[1]];
