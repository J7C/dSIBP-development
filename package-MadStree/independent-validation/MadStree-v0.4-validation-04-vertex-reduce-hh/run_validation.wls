(* ::Package:: *)

$CharacterEncoding = "UTF-8";

(***
文件：run_validation.wls
用途：独立验证单顶点二 massive 函数族的二进制矩阵、低阶约化及正负 prefactor H/h 双向变换。
路线：直接由 2401 局部二态方程构造 4x4 oracle；不读取 MadStree 开发测试 expected。
输出：自动写入 results/summary.wl 与 000_MadStree-v0.4-validation-04-report.md。
***)

(* ::Chapter:: *)
(*路径、函数族与工具*)

validationDirectory = DirectoryName[$InputFileName];
madStreeRoot = DirectoryName[DirectoryName[validationDirectory]];
packageRoot = FileNameJoin[{madStreeRoot, "versions", "MadStree-v0.4"}];
resultsDirectory = FileNameJoin[{validationDirectory, "results"}];
summaryFile = FileNameJoin[{resultsDirectory, "summary.wl"}];
reportFile = FileNameJoin[{validationDirectory, "000_MadStree-v0.4-validation-04-report.md"}];
If[! DirectoryQ[resultsDirectory], CreateDirectory[resultsDirectory, CreateIntermediateDirectories -> True]];
AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
Needs["MadStree`"];
validationStartTime = AbsoluteTime[];

writeValidationText[path_String, text_String] := Module[{stream},
  stream = OpenWrite[path, BinaryFormat -> True];
  BinaryWrite[stream, ToCharacterCode[text, "UTF8"], "Byte"];
  Close[stream];
  path
];


writeValidationExpression[path_String, expression_] := writeValidationText[
  path,
  StringReplace[
    ToString[expression, InputForm, PageWidth -> 120],
    RegularExpression["[ \\t]+(?=\\r?\\n|$)"] -> ""
  ] <> "\n"
];

familySpec = <|
  "ki" -> {k0, k1, k2},
  "nui" -> {a0, nu1, nu2},
  "hankelBranches" -> {1, 2},
  "normalization" -> 1
|>;
positiveContext = MSInitVertexFamily[familySpec, NuConvention -> "Positive"];
negativeContext = MSInitVertexFamily[familySpec, NuConvention -> "Negative"];
positiveTopKey = First[positiveContext["sectorOrder"]];
negativeTopKey = First[negativeContext["sectorOrder"]];
probeRules = {
  a0 -> 7/6, k0 -> 11/3, k1 -> 2/5, k2 -> 3/7,
  nu1 -> 1/4, nu2 -> 2/7, z1 -> 5/4, z2 -> 7/5
};

exactZeroQ[expression_] := And @@ (PossibleZeroQ /@ Flatten[{expression}]);
formatSeconds[value_] := ToString[NumberForm[N[value], {Infinity, 6}], OutputForm];


(* ::Chapter:: *)
(*独立 2401 二进制张量矩阵*)

identity2 = IdentityMatrix[2];
identity4 = IdentityMatrix[4];
projector1 = DiagonalMatrix[{0, 1}];
sigma2 = {{0, -I}, {I, 0}};
expectedBits = IntegerDigits[#, 2, 2] & /@ Range[0, 3];

independentMatrices[formulaNu1_, formulaNu2_, integerShift_] := <|
  "M1" -> (a0 + integerShift) identity4 -
    (2 formulaNu1 + 1) KroneckerProduct[projector1, identity2] -
    (2 formulaNu2 + 1) KroneckerProduct[identity2, projector1],
  "M0" -> I k0 identity4 - I k1 KroneckerProduct[sigma2, identity2] -
    I k2 KroneckerProduct[identity2, sigma2]
|>;

positiveExpected = independentMatrices[-nu1, -nu2, 0];
positiveExpectedPlus = independentMatrices[-nu1, -nu2, 1];
negativeExpected = independentMatrices[nu1, nu2, 0];
positiveActual = First[MSFormulaMatrices[positiveContext, positiveTopKey]["components"]];
negativeActual = First[MSFormulaMatrices[negativeContext, negativeTopKey]["components"]];

matrixSeconds = First@AbsoluteTiming[
  matrixResiduals = <|
    "positiveM1" -> Simplify[positiveActual["M1"] - positiveExpected["M1"]],
    "positiveM1PlusOne" -> Simplify[positiveActual["M1PlusOne"] - positiveExpectedPlus["M1"]],
    "positiveM0" -> Simplify[positiveActual["M0"] - positiveExpected["M0"]],
    "negativeM1" -> Simplify[negativeActual["M1"] - negativeExpected["M1"]],
    "negativeM0" -> Simplify[negativeActual["M0"] - negativeExpected["M0"]]
  |>;
];


(* ::Chapter:: *)
(*低阶 MSReduce 与独立 exact solve*)

inputExpression = 2 MSIntegral[positiveTopKey, {1}, {0, 0}] -
  3 MSIntegral[positiveTopKey, {-1}, {1, 0}];
raisingMatrix = LinearSolve[positiveExpected["M0"], positiveExpectedPlus["M1"]];
loweringMatrix = LinearSolve[positiveExpected["M1"], positiveExpected["M0"]];
independentCoefficientVector = Simplify[2 raisingMatrix[[1]] - 3 loweringMatrix[[3]]];

{reductionSeconds, packageReduction} = AbsoluteTiming[
  MSReduce[inputExpression, positiveContext]
];
reversedBasis = Reverse[Lookup[MSMasterIntegrals[positiveContext], "integral"]];
reversedReduction = MSReduce[inputExpression, positiveContext, MasterBasis -> reversedBasis];
coefficientResidual = Simplify[packageReduction["coefficientVector"] - independentCoefficientVector];

probeDenominators = Join[
  Det[positiveExpected["M0"]] /. probeRules // Together // List,
  Diagonal[positiveExpected["M1"]] /. probeRules,
  Diagonal[positiveExpectedPlus["M1"]] /. probeRules
];


(* ::Chapter:: *)
(*H/h 局部与全 sector 双向变换*)

localHToh[p_, nu_, z_] := {{z^p, 0}, {p z^(p - 1), z^p}};
localhToH[p_, nu_, z_] := {{z^(-p), 0}, {-p z^(-p - 1), z^(-p)}};

positiveLocalResiduals = {
  Simplify[MSHTohMatrix[nu1, z1, positiveContext] - localHToh[nu1, nu1, z1]],
  Simplify[MShToHMatrix[nu1, z1, positiveContext] - localhToH[nu1, nu1, z1]],
  Simplify[MShToHMatrix[nu1, z1, positiveContext].MSHTohMatrix[nu1, z1, positiveContext] - identity2]
};
negativeLocalResiduals = {
  Simplify[MSHTohMatrix[nu1, z1, negativeContext] - localHToh[-nu1, nu1, z1]],
  Simplify[MShToHMatrix[nu1, z1, negativeContext] - localhToH[-nu1, nu1, z1]],
  Simplify[MShToHMatrix[nu1, z1, negativeContext].MSHTohMatrix[nu1, z1, negativeContext] - identity2]
};

stateVector = Array[c, 4];
positiveGlobalExpected = KroneckerProduct[
  localHToh[nu1, nu1, -k1 tau],
  localHToh[nu2, nu2, -k2 tau]
].stateVector;
negativeGlobalExpected = KroneckerProduct[
  localHToh[-nu1, nu1, -k1 tau],
  localHToh[-nu2, nu2, -k2 tau]
].stateVector;
positiveGlobalActual = MSConvertBasis[stateVector, "H" -> "h", positiveTopKey, {tau}, positiveContext];
negativeGlobalActual = MSConvertBasis[stateVector, "H" -> "h", negativeTopKey, {tau}, negativeContext];
positiveRoundTrip = MSConvertBasis[positiveGlobalActual, "h" -> "H", positiveTopKey, {tau}, positiveContext];
negativeRoundTrip = MSConvertBasis[negativeGlobalActual, "h" -> "H", negativeTopKey, {tau}, negativeContext];
overrideAttempt = Quiet[MSConvertBasis[
  stateVector, "H" -> "h", positiveTopKey, {tau}, positiveContext, NuConvention -> "Negative"
]];
transformSeconds = N[AbsoluteTime[] - validationStartTime - matrixSeconds - reductionSeconds, 10];


(* ::Chapter:: *)
(*检查、summary 与自动报告*)

kernelFormulaFiles = FileNameJoin[{packageRoot, #}] & /@ {
  "Kernel/Formula/TensorAtoms.wl", "Kernel/Formula/Recurrence.wl", "Kernel/DE/DLog.wl"
};
generalInverseFiles = Select[
  kernelFormulaFiles,
  StringCases[
    Import[#, "Text"], RegularExpression["(^|[^A-Za-z0-9])Inverse\\["]
  ] =!= {} &
];

checks = <|
  "contextsAndNormalization" -> MSContextQ[positiveContext] && MSContextQ[negativeContext] &&
    positiveContext["rootNormalization"] === 1 && negativeContext["rootNormalization"] === 1,
  "binaryMasterOrder" -> Lookup[MSMasterIntegrals[positiveContext], "stateBits"] === expectedBits,
  "positiveMatrices" -> exactZeroQ[Values@KeyTake[matrixResiduals, {"positiveM1", "positiveM1PlusOne", "positiveM0"}]],
  "negativeMatrices" -> exactZeroQ[Values@KeyTake[matrixResiduals, {"negativeM1", "negativeM0"}]],
  "probeAvoidsSingularLayers" -> And @@ (! TrueQ[PossibleZeroQ[#]] & /@ probeDenominators),
  "lowOrderReductionStatus" -> packageReduction["status"] === "reduced",
  "lowOrderReductionCoefficients" -> exactZeroQ[coefficientResidual],
  "lowOrderReductionNoResidual" -> packageReduction["remainingShiftedIntegrals"] === {} &&
    packageReduction["nonMasterResidual"] === 0,
  "customMasterOrder" -> reversedReduction["masterBasis"] === reversedBasis &&
    reversedReduction["coefficientVector"] === Reverse[packageReduction["coefficientVector"]],
  "positiveLocalRoundTrip" -> exactZeroQ[positiveLocalResiduals],
  "negativeLocalRoundTrip" -> exactZeroQ[negativeLocalResiduals],
  "positiveGlobalTransform" -> exactZeroQ[positiveGlobalActual - positiveGlobalExpected] &&
    exactZeroQ[positiveRoundTrip - stateVector],
  "negativeGlobalTransform" -> exactZeroQ[negativeGlobalActual - negativeGlobalExpected] &&
    exactZeroQ[negativeRoundTrip - stateVector],
  "conventionOverrideRejected" -> Head[overrideAttempt] === Failure,
  "noGeneralLargeInverse" -> generalInverseFiles === {}
|>;

validationPassed = And @@ Values[checks];
elapsedSeconds = N[AbsoluteTime[] - validationStartTime, 10];
sourceFiles = FileNameJoin[{packageRoot, #}] & /@ {
  "Kernel/Core/VertexFamily.wl", "Kernel/Core/Conventions.wl",
  "Kernel/Formula/TensorAtoms.wl", "Kernel/Formula/Recurrence.wl"
};
sourceDigests = AssociationThread[
  StringReplace[#, packageRoot ~~ ("\\" | "/") -> ""] & /@ sourceFiles,
  IntegerString[FileHash[#, "SHA256"], 16, 64] & /@ sourceFiles
];

summary = <|
  "schema" -> "madstree_independent_validation_v1",
  "version" -> "v0.4",
  "task" -> "T4 vertex formula low-order reduce H-h round trips",
  "status" -> If[validationPassed, "passed", "failed"],
  "checks" -> checks,
  "passedCount" -> Count[Values[checks], True],
  "checkCount" -> Length[checks],
  "sourceDigests" -> sourceDigests,
  "normalization" -> 1,
  "masterOrder" -> expectedBits,
  "positiveConvention" -> "h=z^nu H_nu",
  "negativeConvention" -> "h=z^(-nu) H_nu",
  "probeRules" -> probeRules,
  "inputExpression" -> inputExpression,
  "independentCoefficientVector" -> independentCoefficientVector,
  "coefficientResidual" -> coefficientResidual,
  "boundaryPoint" -> Missing["NotApplicable"],
  "path" -> Missing["NotApplicable"],
  "frobeniusOrder" -> Missing["NotApplicable"],
  "transportOrder" -> Missing["NotApplicable"],
  "matrixSeconds" -> matrixSeconds,
  "reductionSeconds" -> reductionSeconds,
  "transformSeconds" -> transformSeconds,
  "elapsedSeconds" -> elapsedSeconds
|>;
writeValidationExpression[summaryFile, summary];

reportLines = Join[
  {
    "# MadStree v0.4 independent validation report: T4 vertex/reduce/H-h",
    "",
    "> Generated automatically by `run_validation.wls`.",
    "",
    "## Status",
    "",
    "- status: `" <> summary["status"] <> "`",
    "- checks: `" <> ToString[summary["passedCount"]] <> "/" <> ToString[summary["checkCount"]] <> "`",
    "- version: `MadStree-v0.4`",
    "",
    "## Scope and normalization",
    "",
    "- family: one vertex with two massive h blocks; branches `{1,2}`",
    "- root/master normalization: `1`",
    "- master order: `{00,01,10,11}` with the first bit assigned to `(k1,nu1)`",
    "- conventions checked separately: `h=z^nu H_nu` and `h=z^(-nu) H_nu`",
    "- reduced expression: `" <> ToString[inputExpression, InputForm] <> "`",
    "",
    "## Point, path and orders",
    "",
    "- exact non-singular probe: `" <> ToString[probeRules, InputForm] <> "`",
    "- physical boundary and anchor: `not applicable`",
    "- numerical path: `not applicable`",
    "- Frobenius/local/transport orders: `not applicable`",
    "",
    "## Timing",
    "",
    "- matrix comparison: `" <> formatSeconds[matrixSeconds] <> " s`",
    "- reduction: `" <> formatSeconds[reductionSeconds] <> " s`",
    "- transforms/report preparation: `" <> formatSeconds[transformSeconds] <> " s`",
    "- total wall time: `" <> formatSeconds[elapsedSeconds] <> " s`",
    "",
    "## Checks",
    ""
  },
  KeyValueMap["- `" <> #1 <> "`: " <> If[TrueQ[#2], "PASS", "FAIL"] &, checks],
  {
    "",
    "## Evidence",
    "",
    "- independent coefficient residual: `" <> ToString[coefficientResidual, InputForm] <> "`",
    "- shifted and non-master residuals: `" <>
      ToString[{packageReduction["remainingShiftedIntegrals"], packageReduction["nonMasterResidual"]}, InputForm] <> "`",
    "- machine-readable summary: `results/summary.wl`",
    "- no numerical boundary or finite-point integral was used."
  }
];
writeValidationText[reportFile, StringRiffle[reportLines, "\n"] <> "\n"];

Print["MadStree T4 checks: ", summary["passedCount"], "/", summary["checkCount"]];
KeyValueMap[Print[#1, ": ", #2] &, checks];
If[! validationPassed, Exit[1]];
