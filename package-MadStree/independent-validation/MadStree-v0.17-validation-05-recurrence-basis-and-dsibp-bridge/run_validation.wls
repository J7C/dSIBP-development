(* ::Package:: *)

(***
文件：run_validation.wls
用途：独立验证 MadStree 的有限 recurrence、H/h 换基和 dSIBP 三槽表示桥。
范围：递推 expected 来自 contact child 的直接 Gamma 积分；不读取 package recurrence metadata 生成 expected。
核心逻辑：先冻结正负 shift 公式和 H/h 矩阵，再调用全部公开入口并执行非法 sector/basis/积分换基负例。
***)

(* ::Chapter:: *)
(*fresh 输出、源码身份与独立 expected*)

$CharacterEncoding = "UTF-8";
validationStart = AbsoluteTime[];
caseRoot = DirectoryName[$InputFileName];
projectRoot = DirectoryName[DirectoryName[DirectoryName[caseRoot]]];
versionRoot = FileNameJoin[{projectRoot, "package-MadStree", "versions", "MadStree-v0.17"}];
resultsRoot = FileNameJoin[{caseRoot, "results"}];
tempRoot = FileNameJoin[{caseRoot, "results_temp"}];
reportPath = FileNameJoin[{caseRoot, "000_MadStree-v0.17-validation-05-report.md"}];
summaryPath = FileNameJoin[{resultsRoot, "summary.wl"}];

Scan[If[DirectoryQ[#], DeleteDirectory[#, DeleteContents -> True]] &, {resultsRoot, tempRoot}];
If[FileExistsQ[reportPath], DeleteFile[reportPath]];
CreateDirectory[resultsRoot, CreateIntermediateDirectories -> True];
CreateDirectory[tempRoot, CreateIntermediateDirectories -> True];

sourceFiles = Sort[FileNames["*.wl", FileNameJoin[{versionRoot, "Kernel"}], Infinity]];
sourceDigest = Hash[FileHash[#, "SHA256"] & /@ sourceFiles, "SHA256", "HexString"];
writeUTF8Text[path_String, text_String] := Module[{stream, writeResult},
  Quiet@Check[CreateDirectory[DirectoryName[path], CreateIntermediateDirectories -> True], Null];
  stream = Quiet@Check[OpenWrite[path, BinaryFormat -> True], $Failed];
  If[stream === $Failed, Return[$Failed]];
  writeResult = Quiet@Check[
    BinaryWrite[stream, ToCharacterCode[text, "UTF-8"], "Byte"];
    Close[stream];
    path,
    Quiet@Check[Close[stream], Null];
    $Failed
  ];
  If[writeResult === path && FileExistsQ[path], path, $Failed]
];
repairSourceUTF8[text_String] := FromCharacterCode[
  ToCharacterCode[text, "ISO8859-1"],
  "UTF-8"
];

(* contact child 的合并 component 带固定时间幂平移 +1，故裸 Gamma 积分基准幂为 a1+a2+1。 *)
lambda = -I (k1 + k2);
expectedPositiveCoefficient = (a1 + a2 + 2)/lambda;
expectedNegativeCoefficient = lambda/(a1 + a2 + 1);
expectedHToh = {{z^nu, 0}, {nu z^(nu - 1), z^nu}};
expectedhToH = {{z^-nu, 0}, {-nu z^(-nu - 1), z^-nu}};

AppendTo[$Path, FileNameJoin[{versionRoot, "Kernel"}]];
Needs["MadStree`"];


(* ::Chapter:: *)
(*top/contact 结构与正负 shift recurrence*)

context = MSInitTree[<|
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> k1, "timePower" -> a1, "vertexType" -> "+"|>,
    <|"id" -> 2, "externalLegEnergy" -> k2, "timePower" -> a2, "vertexType" -> "+"|>
  },
  "lines" -> {<|"type" -> "massless", "endpoints" -> {1, 2}, "momentum" -> q|>}
|>];
masters = MSMasterIntegrals[context];
topSector = First[MSSectors[context]];
childSector = SelectFirst[MSSectors[context], Length[# ["contractedLineIds"]] === 1 &];
topFormula = MSFormulaMatrices[context, topSector["sectorKey"]];
childFormula = MSFormulaMatrices[context, childSector["sectorKey"]];
contactMaps = MSContactMaps[context, topSector["sectorKey"]];

childKey = childSector["sectorKey"];
childMaster = MSIntegral[childKey, {0}, {}];
positiveIntegral = MSIntegral[childKey, {1}, {}];
negativeIntegral = MSIntegral[childKey, {-1}, {}];
positiveStep = MSRecurrenceStep[positiveIntegral, 1, context];
negativeStep = MSRecurrenceStep[negativeIntegral, 1, context];
positiveReduction = MSReduce[positiveIntegral, context];
negativeReduction = MSReduce[negativeIntegral, context];

expectedPositive = expectedPositiveCoefficient childMaster;
expectedNegative = expectedNegativeCoefficient childMaster;
positiveResidual = Together@FullSimplify[positiveStep["result"] - expectedPositive];
negativeResidual = Together@FullSimplify[negativeStep["result"] - expectedNegative];
positiveReductionResidual = Together@FullSimplify[positiveReduction["result"] - expectedPositive];
negativeReductionResidual = Together@FullSimplify[negativeReduction["result"] - expectedNegative];


(* ::Chapter:: *)
(*H/h 局部与 sector 换基*)

massiveContext = MSInitTree[<|
  "vertices" -> {
    <|"id" -> u, "externalLegEnergy" -> e1, "timePower" -> b1, "vertexType" -> "+"|>,
    <|"id" -> v, "externalLegEnergy" -> e2, "timePower" -> b2, "vertexType" -> "+"|>
  },
  "lines" -> {<|"type" -> "massive", "endpoints" -> {u, v}, "momentum" -> p, "nu" -> nu|>}
|>];
massiveTopKey = First[massiveContext["sectorOrder"]];
hToh = MSHTohMatrix[nu, z, massiveContext];
hToH = MShToHMatrix[nu, z, massiveContext];
stateVector = {u00, u01, u10, u11};
z1 = -p tau1;
z2 = -p tau2;
expectedGlobalHToh = KroneckerProduct[expectedHToh /. z -> z1, expectedHToh /. z -> z2];
expectedGlobalhToH = KroneckerProduct[expectedhToH /. z -> z1, expectedhToH /. z -> z2];
globalHToh = MSConvertBasis[stateVector, "H" -> "h", massiveTopKey, {tau1, tau2}, massiveContext];
globalhToH = MSConvertBasis[stateVector, "h" -> "H", massiveTopKey, {tau1, tau2}, massiveContext];
globalRoundTrip = MSConvertBasis[globalHToh, "h" -> "H", massiveTopKey, {tau1, tau2}, massiveContext];
integralBasisFailure = MSConvertBasis[
  First[Lookup[MSMasterIntegrals[massiveContext], "integral"]],
  "H" -> "h", massiveTopKey, {tau}, massiveContext
];


(* ::Chapter:: *)
(*dSIBP 三槽表示桥与负例*)

dsibpMasters = MSToDSIBPJ[#, context] & /@ Lookup[masters, "integral"];
roundTripMasters = MSFromDSIBPJ[#, context] & /@ dsibpMasters;
bridgeExpression = 2 dsibpMasters[[1]] - 3 dsibpMasters[[-1]];
bridgeExpressionActive = Activate[bridgeExpression];
bridgeExpressionBack = MSFromDSIBPExpression[bridgeExpressionActive, context];
expectedExpressionBack = 2 masters[[1, "integral"]] - 3 masters[[-1, "integral"]];

badSector = MSRecurrenceStep[MSIntegral["unknown-sector", {1}, {}], 1, context];
masterBasis = Lookup[masters, "integral"];
missingBasis = MSReduce[positiveIntegral, context, MasterBasis -> Rest[masterBasis]];
duplicateBasis = MSReduce[
  positiveIntegral,
  context,
  MasterBasis -> ReplacePart[masterBasis, -1 -> First[masterBasis]]
];


(* ::Chapter:: *)
(*验收、机器摘要与报告*)

contactNonzero = DeleteCases[Flatten[Values[First[contactMaps]["matricesByComponent"]]], 0];
checks = <|
  "version" -> TrueQ[MadStree`Private`$MadStreeVersion === "0.17"],
  "topAndContact" -> Length[MSSectors[context]] === 2 && topSector["masterCount"] === 2 && childSector["masterCount"] === 1,
  "formulaMatrices" -> AssociationQ[topFormula] && AssociationQ[childFormula],
  "contactMapDerivedWeights" -> Sort[contactNonzero] === {-2, 2},
  "positiveStep" -> Lookup[positiveStep, "status", None] === "reducedOneStep" && positiveResidual === 0,
  "negativeStep" -> Lookup[negativeStep, "status", None] === "reducedOneStep" && negativeResidual === 0,
  "positiveReduce" -> Lookup[positiveReduction, "status", None] === "reduced" && positiveReductionResidual === 0,
  "negativeReduce" -> Lookup[negativeReduction, "status", None] === "reduced" && negativeReductionResidual === 0,
  "singularSurfacesRecorded" -> Lookup[positiveStep, "singularSurfaces", {}] =!= {} && Lookup[negativeStep, "singularSurfaces", {}] =!= {},
  "localHTohExpected" -> FullSimplify[hToh - expectedHToh] === ConstantArray[0, {2, 2}],
  "localhToHExpected" -> FullSimplify[hToH - expectedhToH] === ConstantArray[0, {2, 2}],
  "localRoundTrip" -> FullSimplify[hToH.hToh] === IdentityMatrix[2],
  "globalHTohExpected" -> FullSimplify[globalHToh - expectedGlobalHToh.stateVector] === ConstantArray[0, 4],
  "globalhToHExpected" -> FullSimplify[globalhToH - expectedGlobalhToH.stateVector] === ConstantArray[0, 4],
  "globalRoundTrip" -> FullSimplify[globalRoundTrip - stateVector] === ConstantArray[0, 4],
  "integratedBasisFailsClosed" -> Head[integralBasisFailure] === Failure,
  "dsibpMasterRoundTrip" -> roundTripMasters === Lookup[masters, "integral"],
  "dsibpExpressionRoundTrip" -> Expand[bridgeExpressionBack - expectedExpressionBack] === 0,
  "normalizationPreserved" -> And @@ MapThread[
    MSIntegralDefinition[#1, context]["normalization"] === MSIntegralDefinition[#2, context]["normalization"] &,
    {Lookup[masters, "integral"], roundTripMasters}
  ],
  "badSectorFailsClosed" -> Head[badSector] === Failure,
  "missingBasisFailsClosed" -> Head[missingBasis] === Failure,
  "duplicateBasisFailsClosed" -> Head[duplicateBasis] === Failure
|>;
passedCount = Count[Values[checks], True];
status = If[passedCount === Length[checks], "passed", "failed"];
wallTimeSeconds = N[AbsoluteTime[] - validationStart];
summary = <|
  "schema" -> "madstree_v0.17_validation_05_v1",
  "status" -> status,
  "passedCount" -> passedCount,
  "checkCount" -> Length[checks],
  "sourceRoot" -> versionRoot,
  "sourceDigestSHA256" -> sourceDigest,
  "convention" -> "contact child A=a1+a2+1; J_n proportional to Gamma[A+n+1]/[-I(k1+k2)]^(A+n+1); positive nu H/h basis",
  "numericalPoint" -> "not applicable: exact recurrence/representation case",
  "actualPath" -> "not applicable: no numerical transport",
  "ordersAndPrecision" -> "not applicable: exact symbolic equalities",
  "wallTimeSeconds" -> wallTimeSeconds,
  "masterOrder" -> masterBasis,
  "sectorOrder" -> Lookup[MSSectors[context], "sectorKey"],
  "expectedRecurrence" -> <|"positive" -> expectedPositive, "negative" -> expectedNegative|>,
  "actualSteps" -> <|"positive" -> positiveStep, "negative" -> negativeStep|>,
  "recurrenceResiduals" -> <|"positive" -> positiveResidual, "negative" -> negativeResidual,
    "positiveReduction" -> positiveReductionResidual, "negativeReduction" -> negativeReductionResidual|>,
  "contactMaps" -> contactMaps,
  "basisMatrices" -> <|"expectedHToh" -> expectedHToh, "actualHToh" -> hToh,
    "expectedhToH" -> expectedhToH, "actualhToH" -> hToH,
    "expectedGlobalHToh" -> expectedGlobalHToh, "expectedGlobalhToH" -> expectedGlobalhToH|>,
  "dsibpBridge" -> <|"forward" -> dsibpMasters, "roundTrip" -> roundTripMasters,
    "expression" -> bridgeExpressionBack|>,
  "negativeCases" -> <|"badSector" -> badSector, "missingBasis" -> missingBasis,
    "duplicateBasis" -> duplicateBasis, "integratedBasis" -> integralBasisFailure|>,
  "checks" -> checks
|>;
summaryWriteResult = writeUTF8Text[
  summaryPath,
  ToString[summary, InputForm, PageWidth -> Infinity] <> "\n"
];
If[summaryWriteResult === $Failed,
  Print["The validation summary could not be written, so this case is not marked as passed."];
  Exit[1]
];

report = StringRiffle[{
  "# MadStree v0.17 Validation-05 独立报告", "",
  "- 状态：**" <> status <> "**，" <> ToString[passedCount] <> "/" <> ToString[Length[checks]] <> "。",
  "- 源码聚合 SHA-256：`" <> sourceDigest <> "`。",
  "- 图包含 top/contact 两层；master 顺序、contact 权重和正负 shift 均 exact 比较。", "",
  "## Recurrence", "",
  "contact child 的 component 基准幂为 `A=a1+a2+1`；直接 Gamma 积分给出 `J(+1)=(a1+a2+2)/[-I(k1+k2)] J(0)` 与 `J(-1)=[-I(k1+k2)]/(a1+a2+1) J(0)`。",
  "`MSRecurrenceStep` 和 `MSReduce` 对两式的 exact residual 均保存在 `results/summary.wl`。", "",
  "## 换基与表示桥", "",
  "H/h 局部矩阵逐项等于显式手推矩阵，sector 状态向量双向为 identity；已积分对象无法唯一换基并 fail closed。",
  "MadStree/dSIBP 三槽表示逐 master 和线性表达式 round-trip，sector、shift、state slot 与 normalization 不丢失。",
  "非法 sector、缺失/重复 MasterBasis 均 fail closed。", "",
  "## 数值路径、展开与耗时", "",
  "本 case 只作 exact symbolic 检验；数值点、路径、边界展开阶和输运阶均不适用。",
  "总 wall time：`" <> ToString[wallTimeSeconds] <> " s`。", ""
}, "\n"];
reportWriteResult = writeUTF8Text[reportPath, StringTrim[repairSourceUTF8[report]] <> "\n"];
If[reportWriteResult === $Failed,
  Print["The validation report could not be written, so this case is not marked as passed."];
  Exit[1]
];

Print["MadStree Validation-05: ", passedCount, "/", Length[checks], " checks passed."];
If[status =!= "passed", Exit[1]];
