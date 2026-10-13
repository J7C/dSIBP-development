(* ::Package:: *)

(*** 文件：run_validation.wls
 用途：以合作者 bubble-check 上传物提取出的最小 oracle（主积分序列、dlog DE、边界领头记录、
       修复前数值点与独立 Wick 旋转级数参考）四类对照物，验证当前 MadStree v0.17
       （含等时接触扇区排列平均修复）在固定圈动量 bubble 上的四支 J0000 与 K 组合。
 输入：本目录 oracle/（来源 development 库提交 64fd90c，逐件 SHA-256 见 oracle/PROVENANCE.json）。
 输出：fresh 生成 results/summary.wl 与目录首项 Markdown 报告；runtime 仅暂存 results_temp。 ***)


(* ::Chapter:: *)

(*路径、fresh 清理与输入冻结*)

$CharacterEncoding = "UTF-8";
$MaxExtraPrecision = 10000;
validationDirectory = DirectoryName[$InputFileName];
madStreeRoot = DirectoryName[DirectoryName[validationDirectory]];
repositoryRoot = DirectoryName[madStreeRoot];
versionRoot = FileNameJoin[{madStreeRoot, "versions", "MadStree-v0.17"}];
oracleRoot = FileNameJoin[{validationDirectory, "oracle"}];
resultsDirectory = FileNameJoin[{validationDirectory, "results"}];
runtimeDirectory = FileNameJoin[{validationDirectory, "results_temp"}];
summaryFile = FileNameJoin[{resultsDirectory, "summary.wl"}];
reportFile = FileNameJoin[{validationDirectory,
  "000_MadStree-v0.17-validation-09-fixed-momentum-bubble-reference-report.md"}];

Scan[If[DirectoryQ[#], DeleteDirectory[#, DeleteContents -> True]] &,
  {resultsDirectory, runtimeDirectory}];
If[FileExistsQ[reportFile], DeleteFile[reportFile]];
CreateDirectory[resultsDirectory, CreateIntermediateDirectories -> True];
CreateDirectory[runtimeDirectory, CreateIntermediateDirectories -> True];
validationStart = AbsoluteTime[];

(* 先加载被检程序包再 Get oracle：oracle 的 masters.wl 以裸 MSIntegral 记录主积分，
   Needs 之前 Get 会把符号解析进 Global` 上下文，使结构性比对失配。 *)
AppendTo[$Path, FileNameJoin[{versionRoot, "Kernel"}]];
Needs["MadStree`"];
(* 运行环境级设置：Python 3.11+ 对 int<->str 转换默认设 4300 位十进制上限，
   后端 exact 高斯有理数经 fmpq 字符串往返重解析时，位数超限的有理数会让
   Fraction 解包抛 ValueError（bubble-check 登记的问题二报错掩蔽处）。
   本验证按运行环境解除该上限使数值链可跑；程序包内 exact_gaussian.py 与
   FlintNDE.wl 的报错包装修复仍按登记待用户点头，不在本任务内改动。 *)
SetEnvironment["PYTHONINTMAXSTRDIGITS" -> "0"];

hashFile[path_String] := ToUpperCase@IntegerString[FileHash[path, "SHA256"], 16, 64];
writeUTF8Text[path_String, text_String] := Module[{stream},
  stream = OpenWrite[path, BinaryFormat -> True];
  BinaryWrite[stream, ToCharacterCode[text, "UTF-8"], "Byte"];
  Close[stream];
  path
];
gitHeadCommit = StringTrim[Quiet@Check[
  RunProcess[{"git", "-C", repositoryRoot, "rev-parse", "HEAD"}, "StandardOutput"],
  "unavailable"]];

(* 与合作者成功运行（bubble_calibration_rational120.wls）逐字同参；x2 用同一 120 位有理近似。 *)
rhoLabels = {"10", "5", "2.8"};
rhoValues = {10, 5, 14/5};
x2Rational = Rationalize[N[Sqrt[2], 120], 0];
parameterRules = {x1 -> 1, x2 -> x2Rational, a1 -> 1 + I/2, a2 -> 1 + I/2};
pointSequence = {{k1, k2}, {-10, -10}, {-5, -5}, {-14/5, -14/5}};
workingPrecision = 80;
transportOrder = 80;
referenceTransportOrder = 96;
boundarySeriesOrder = 17;
targetRelativeError = "1e-32";
boundaryScale = 4;
rankOrder = {1, 2};
singularityMode = "Avoid";
(* 门限来源：r2.8 参考自身保存的 K 截断上界 6.41e-23 折成相对约 4.8e-21，
   同一数值链修复前 pm/mp 已达 1e-26 量级；1e-20 取在两者之上，不新设更紧的线。 *)
comparisonTolerance = 10^-20;
improvementFactor = 1000;
(* 等时排列平均修复的解析预言：ν=I/4、Negative 约定下混合 bit 接触支的新旧权重比。
   修复前单排列的选取随分支顶点符号翻转：pp 的旧单边含 E^{π/4}，mm 含 E^{-π/4}，
   故两支"平均/旧单边"之比互为 e^{π/2} 镜像（差恰为 sinh(π/2)）。 *)
predictedChangeRatios = <|
  "pp" -> (1 + Exp[-Pi/2])/2, "pm" -> (1 + Exp[-Pi/2])/2,
  "mp" -> (1 + Exp[-Pi/2])/2, "mm" -> (1 + Exp[Pi/2])/2|>;
predictedChangedIndices = <|"pp" -> {18, 21}, "mm" -> {18, 21}, "pm" -> {}, "mp" -> {}|>;


(* ::Chapter:: *)

(*oracle 完整性、独立参考与修复前对照的读取*)

provenance = Import[FileNameJoin[{oracleRoot, "PROVENANCE.json"}], "RawJSON"];
oracleIntegrity = Association[
  #["oraclePath"] ->
    (ToLowerCase@hashFile[FileNameJoin[{oracleRoot, #["oraclePath"]}]] === #["sha256"]) & /@
    provenance["files"]];

ballNumber[text_String] := ToExpression[StringTrim[StringReplace[text, "e" -> "*^"]]];
parseBallRecord[text_String] := Module[{parts},
  parts = StringCases[text,
    RegularExpression["\\[\\s*([-0-9.e+]+)\\s*\\+/-\\s*([-0-9.e+]+)\\s*\\]"] -> {"$1", "$2"}];
  If[Length[parts] =!= 2,
    Return[<|"real" -> Missing["ParseFailed"], "imag" -> Missing["ParseFailed"],
      "radius" -> Missing["ParseFailed"], "raw" -> text|>]];
  <|"real" -> ballNumber[parts[[1, 1]]], "imag" -> ballNumber[parts[[2, 1]]],
    "radius" -> Max[ballNumber[parts[[1, 2]]], ballNumber[parts[[2, 2]]]],
    "raw" -> text|>
];

referenceFiles = <|
  "10" -> "reference/bubble_reference_r10_n36.json",
  "5" -> "reference/bubble_reference_r5_n52.json",
  "2.8" -> "reference/bubble_reference_r2.8_n200_d300.json"
|>;
referenceData = Association[
  Table[With[{label = rhoLabels[[index]], path = referenceFiles[rhoLabels[[index]]]},
    label -> Module[
    {raw = Import[FileNameJoin[{oracleRoot, path}], "RawJSON"]},
    <|"rho" -> raw["rho"], "order" -> raw["order"], "dps" -> raw["dps"],
      "seconds" -> raw["seconds"],
      "truncationCertified" -> Lookup[raw, "truncationCertified", Missing["NotSaved"]],
      "balls" -> Map[parseBallRecord, raw["rounding_only_balls"]],
      "absoluteKTruncationBound" -> If[KeyMemberQ[raw, "absolute_K_truncation_bound"],
        ballNumber[StringCases[raw["absolute_K_truncation_bound"],
          RegularExpression["\\[\\s*([-0-9.e+]+)"] -> "$1"][[1]]],
        Missing["NotSaved"]],
      "path" -> path|>]],
    {index, Length[rhoLabels]}]];

csvRecords = Module[{lines, rows},
  lines = ReadList[FileNameJoin[{oracleRoot, "comparison_by_point_and_branch.csv"}],
    Record, RecordSeparators -> {"\n"}];
  rows = Select[StringSplit[#, ","] & /@ Rest[lines], Length[#] >= 8 &];
  Association[
    Map[(#["rho"] <> "|" <> #["branch"]) -> # &,
      Map[<|"rho" -> #[[1]], "branch" -> #[[2]],
         "nativeReal" -> ballNumber[#[[3]]], "nativeImag" -> ballNumber[#[[4]]],
         "referenceReal" -> ballNumber[#[[5]]], "referenceImag" -> ballNumber[#[[6]]],
         "absoluteErrorSaved" -> ballNumber[#[[7]]],
         "relativeErrorSaved" -> ballNumber[#[[8]]]|> &, rows]]]];


(* ::Chapter:: *)

(*oracle 的主积分序列、dlog DE 与边界领头记录*)

wlExpression[text_String] := ToExpression[StringReplace[StringTrim[text], "\n" -> " "]];
oracleLeadingRecords = Module[{raw},
  raw = Import[FileNameJoin[{oracleRoot, "leading_records.json"}], "RawJSON"];
  Association[
    Table[label -> Map[
       <|"sectorKey" -> StringReplace[#["sectorKey"], "\"" -> ""],
         "rootGlobalIndex" -> wlExpression[#["rootGlobalIndex"]],
         "binaryState" -> wlExpression[#["binaryState"]],
         "frobeniusExponent" -> wlExpression[#["frobeniusExponent"]],
         "logPower" -> wlExpression[#["logPower"]],
         "coefficient" -> wlExpression[#["coefficient"]],
         "physicalWeight" -> wlExpression[#["physicalWeight"]],
         "normalizedLeadingVector" -> wlExpression[#["normalizedLeadingVector"]]|> &,
       Select[raw, #["branch"] === label &]],
     {label, {"pp", "pm", "mp", "mm"}}]]];

oracleMastersAssociation = Association[
  Table[label -> Get[FileNameJoin[{oracleRoot, "generated", label, "masters.wl"}]],
    {label, {"pp", "pm", "mp", "mm"}}]];
oracleDEAssociation = Association[
  Table[label -> Get[FileNameJoin[{oracleRoot, "generated", label, "dlog_de.wl"}]],
    {label, {"pp", "pm", "mp", "mm"}}]];

deSampleRules = Join[{k1 -> -3 + I/5, k2 -> -2 - I/3}, parameterRules];
(* 规范化文本比对：剥离 MadStree`/Global` 上下文前缀，容许 oracle 与当前运行
   在符号上下文上的无害差异，其余逐字符一致才算结构相同。 *)
canonicalRecordText[record_] := StringReplace[
  ToString[record, InputForm, PageWidth -> Infinity],
  {"MadStree`" -> "", "Global`" -> ""}];
masterCompare[label_, currentMasters_] := Module[
  {oracleMasters = oracleMastersAssociation[label], structuralMismatches,
   normalizationDifferences},
  structuralMismatches = Count[
    MapThread[
      canonicalRecordText[KeyTake[#1, {"sectorKey", "globalIndex", "stateBits", "integral"}]] =!=
        canonicalRecordText[KeyTake[#2, {"sectorKey", "globalIndex", "stateBits", "integral"}]] &,
      {currentMasters, oracleMasters}], True];
  normalizationDifferences = Max[{0} ~Join~
    (Abs[N[(#1["normalization"] - #2["normalization"]) /. parameterRules, 60]] & @@@
      Transpose[{currentMasters, oracleMasters}])];
  <|"countCurrent" -> Length[currentMasters], "countOracle" -> Length[oracleMasters],
    "structuralMismatches" -> structuralMismatches,
    "maxNormalizationDifference" -> normalizationDifferences|>
];
deCompare[label_, currentDE_] := Module[
  {oracleDE = oracleDEAssociation[label], samplePotential, oraclePotential,
   maxDifference, scale},
  samplePotential = Quiet@Check[N[currentDE["omegaPotential"] /. deSampleRules, 60], $Failed];
  oraclePotential = Quiet@Check[N[oracleDE["omegaPotential"] /. deSampleRules, 60], $Failed];
  {maxDifference, scale} = If[samplePotential === $Failed || oraclePotential === $Failed,
    {Infinity, Missing["EvaluationFailed"]},
    {Max[Abs[Flatten[samplePotential - oraclePotential]]],
      Max[Max[Abs[Flatten[oraclePotential]]], 10^-60]}];
  <|"sectorOrderSameQ" -> currentDE["sectorOrder"] === oracleDE["sectorOrder"],
    "sectorDimensionsSameQ" -> currentDE["sectorDimensions"] === oracleDE["sectorDimensions"],
    "lettersSameQ" -> SameQ[currentDE["letters"], oracleDE["letters"]],
    "maxSampledDifference" -> maxDifference, "sampledScale" -> scale,
    "sampledRelativeDifference" -> If[NumericQ[scale], maxDifference/scale, maxDifference]|>
];
boundaryCompare[label_, currentBoundary_] := Module[
  {oracleRecords = oracleLeadingRecords[label],
   currentRecords = currentBoundary["leadingBranches"],
   currentByIndex, rows, changedIndices, unchangedVectorsQ},
  currentByIndex = Association[
    (#["rootGlobalIndex"] -> #) & /@ currentRecords];
  rows = Map[
    Module[{oracle = #, current = Lookup[currentByIndex, #["rootGlobalIndex"], Missing["Absent"]],
       vectorDifference, weightRatio, coefficientRatio, exponentDifference},
      vectorDifference = If[MissingQ[current], Infinity,
        Max[Abs[N[
           (current["normalizedLeadingVector"] - oracle["normalizedLeadingVector"]) /.
            parameterRules, 50]]]];
      exponentDifference = If[MissingQ[current], Infinity,
        Abs[N[current["frobeniusExponent"] - oracle["frobeniusExponent"], 50]]];
      weightRatio = If[MissingQ[current], Missing["Absent"],
        Quiet@Check[N[(current["physicalWeight"]/oracle["physicalWeight"]) /. parameterRules, 50],
          Missing["Undefined"]]];
      coefficientRatio = If[MissingQ[current], Missing["Absent"],
        Quiet@Check[N[(current["coefficient"]/oracle["coefficient"]) /. parameterRules, 50],
          Missing["Undefined"]]];
      <|"rootGlobalIndex" -> oracle["rootGlobalIndex"],
        "matchedQ" -> ! MissingQ[current],
        "exponentDifference" -> exponentDifference,
        "vectorMaxDifference" -> vectorDifference,
        "coefficientRatio" -> coefficientRatio, "weightRatio" -> weightRatio|>] &,
    oracleRecords];
  changedIndices = Map[
    If[TrueQ[Abs[#["weightRatio"] - 1] > 10^-30], #["rootGlobalIndex"], Nothing] &, rows];
  unchangedVectorsQ = AllTrue[rows,
    #["matchedQ"] && #["vectorMaxDifference"] <= 10^-45 && #["exponentDifference"] <= 10^-45 &];
  <|"recordCountOracle" -> Length[oracleRecords],
    "recordCountCurrent" -> Length[currentRecords],
    "unchangedVectorsAndExponentsQ" -> unchangedVectorsQ,
    "changedIndices" -> changedIndices,
    "predictedChangedIndices" -> predictedChangedIndices[label],
    "changeSetMatchesPredictionQ" ->
      Sort[changedIndices] === Sort[predictedChangedIndices[label]],
    "maxAbsChangeRatioError" -> Max[{0} ~Join~ Map[
       If[MemberQ[predictedChangedIndices[label], #["rootGlobalIndex"]],
         Abs[#["weightRatio"] - predictedChangeRatios[label]], 0] &, rows]],
    "rows" -> rows|>
];


(* ::Chapter:: *)

(*四支重算与逐支对照*)

branchSpecs = {{"pp", {1, 1}}, {"pm", {1, -1}}, {"mp", {-1, 1}}, {"mm", {-1, -1}}};
branchResults = Association@Table[
  Module[{label = spec[[1]], signs = spec[[2]], ctx, masters, de, boundary,
     boundarySeconds, masterComparison, deComparison, boundaryComparison,
     seconds, evaluation, pointResults, values, segments, pinchedRecords},
    ctx = MSInitTimeGraph[<|
      "vertices" -> {
        <|"id" -> 1, "externalLegEnergy" -> k1, "timePower" -> a1,
          "vertexType" -> If[signs[[1]] == 1, "+", "-"]|>,
        <|"id" -> 2, "externalLegEnergy" -> k2, "timePower" -> a2,
          "vertexType" -> If[signs[[2]] == 1, "+", "-"]|>},
      "lines" -> {
        <|"type" -> "massive", "endpoints" -> {1, 2}, "momentum" -> x1, "nu" -> I/4|>,
        <|"type" -> "massive", "endpoints" -> {1, 2}, "momentum" -> x2, "nu" -> I/4|>}|>,
      NuConvention -> "Negative"];
    masters = MSMasterIntegrals[ctx];
    de = MSDLogDE[ctx];
    masterComparison = masterCompare[label, masters];
    deComparison = deCompare[label, de];
    pinchedRecords = Select[masters, #["sectorKey"] =!= "11" &];
    {boundarySeconds, boundary} = AbsoluteTiming[
      MSBoundaryData[ctx, Join[{k1 -> -10, k2 -> -10}, parameterRules],
        BoundaryScale -> boundaryScale, BoundarySeriesOrder -> boundarySeriesOrder,
        RankOrder -> rankOrder, WorkingPrecision -> workingPrecision]];
    boundaryComparison = boundaryCompare[label, boundary];
    {seconds, evaluation} = AbsoluteTiming[Quiet@Check[
        MSEvaluatePath[ctx, pointSequence,
          ParameterRules -> parameterRules,
          WorkingPrecision -> workingPrecision,
          TransportOrder -> transportOrder,
          ReferenceTransportOrder -> referenceTransportOrder,
          BoundarySeriesOrder -> boundarySeriesOrder,
          TargetRelativeError -> targetRelativeError,
          BoundaryScale -> boundaryScale,
          RankOrder -> rankOrder,
          SingularityMode -> singularityMode,
          MSRuntimeDirectory -> FileNameJoin[{runtimeDirectory, label <> "_runtime"}]],
        $Failed]];
    If[AssociationQ[evaluation] && KeyMemberQ[evaluation, "pointResults"],
      pointResults = evaluation["pointResults"];
      values = Lookup[pointResults, "value", {}];
      segments = If[KeyMemberQ[evaluation, "flintNDE"],
        Lookup[evaluation["flintNDE"], "segments", {}], {}];,
      pointResults = {}; values = {}; segments = {};
    ];
    Print[label, " masters=", Length[masters],
      " boundarySeconds=", N[boundarySeconds, 4],
      " changed=", boundaryComparison["changedIndices"],
      " points=", Length[values], " seconds=", N[seconds, 4]];
    label -> <|
      "signs" -> signs,
      "masterCount" -> Length[masters],
      "sectorKeys" -> DeleteDuplicates@Lookup[masters, "sectorKey"],
      "pinchedSectorCount" -> Length[pinchedRecords],
      "pinchedNormalizations" ->
        N[Lookup[pinchedRecords, "normalization"] /. parameterRules, 40],
      "masterComparison" -> masterComparison,
      "deComparison" -> deComparison,
      "boundaryComparison" -> KeyDrop[boundaryComparison, "rows"],
      "boundaryRows" -> boundaryComparison["rows"],
      "boundarySeconds" -> boundarySeconds,
      "seconds" -> seconds,
      "computedQ" -> Length[values] === Length[rhoValues],
      "values" -> values,
      "pointTargetMet" -> Lookup[pointResults, "targetRelativeErrorMet", {}],
      "segmentSummary" -> <|
        "segmentCount" -> Length[segments],
        "nodeCounts" -> Lookup[segments, "nodeCount", {}],
        "maxRelativeDifferenceMidpoint" ->
          If[segments === {}, Missing["NoSegments"],
            Max[Lookup[segments, "relativeDifferenceMidpoint", Infinity]]],
        "certificationModes" -> DeleteDuplicates@Lookup[segments, "certificationMode", {}]|>|>
  ],
  {spec, branchSpecs}];


(* ::Chapter:: *)

(*数值点对照、K 组合与修复效果*)

quantityList = {"pp", "pm", "mp", "mm", "K"};
(* 注意：Association 的多参访问只对逐级都为键的链有效；含整数下标的链
   （如 a[k, "values", i, 1]）整体不求值，必须显式单键取值后再 Part。 *)
nativeValue[label_String, pointIndex_Integer] :=
  branchResults[label]["values"][[pointIndex, 1]];
nativeK[pointIndex_Integer] :=
  -nativeValue["pp", pointIndex] + nativeValue["pm", pointIndex] +
  nativeValue["mp", pointIndex] - nativeValue["mm", pointIndex];
referenceComplex[rhoLabel_String, quantity_String] :=
  With[{ball = referenceData[rhoLabel, "balls", quantity]},
    ball["real"] + I ball["imag"]];

comparisonRows = Flatten@Table[
  Module[{native, reference, absolute, relative, preFix, improvement},
    native = If[quantity === "K", nativeK[index], nativeValue[quantity, index]];
    reference = referenceComplex[rhoLabels[[index]], quantity];
    absolute = Abs[native - reference];
    relative = absolute/Abs[reference];
    preFix = Lookup[csvRecords, rhoLabels[[index]] <> "|" <> quantity,
      <|"relativeErrorSaved" -> Missing["NotSaved"]|>]["relativeErrorSaved"];
    improvement = If[NumericQ[preFix] && relative > 0, preFix/relative, Missing["Undefined"]];
    <|"rho" -> rhoValues[[index]], "rhoLabel" -> rhoLabels[[index]],
      "quantity" -> quantity, "native" -> native, "reference" -> reference,
      "absoluteDifference" -> absolute, "relativeDifference" -> relative,
      "preFixRelativeDifference" -> preFix, "improvementFactor" -> improvement,
      "referenceRadius" -> referenceData[rhoLabels[[index]], "balls", quantity]["radius"]|>],
  {index, Length[rhoLabels]}, {quantity, quantityList}];


(* ::Chapter:: *)

(*验收、机器 summary 与自动报告*)

checks = <|
  "oracleIntegrityVerified" -> Length[oracleIntegrity] === 13 &&
    AllTrue[Values[oracleIntegrity], TrueQ],
  "allBranchesComputed" -> AllTrue[Lookup[Values[branchResults], "computedQ"], TrueQ],
  "masterCountsMatchEvidence" ->
    branchResults["pp", "masterCount"] === 22 &&
    branchResults["mm", "masterCount"] === 22 &&
    branchResults["pm", "masterCount"] === 16 &&
    branchResults["mp", "masterCount"] === 16,
  "mastersSequencesMatchOracle" -> AllTrue[
    Lookup[Values[branchResults], "masterComparison"],
    #["countCurrent"] === #["countOracle"] && #["structuralMismatches"] === 0 &&
      #["maxNormalizationDifference"] <= 10^-50 &],
  "dlogDEMatchOracle" -> AllTrue[
    Lookup[Values[branchResults], "deComparison"],
    #["sectorOrderSameQ"] && #["sectorDimensionsSameQ"] &&
      TrueQ[#["sampledRelativeDifference"] <= 10^-50] &],
  "boundaryExponentsAndVectorsUnchanged" -> AllTrue[
    Lookup[Values[branchResults], "boundaryComparison"], #["unchangedVectorsAndExponentsQ"] &],
  "boundaryChangeSetMatchesFixPrediction" -> AllTrue[
    Lookup[Values[branchResults], "boundaryComparison"],
    #["changeSetMatchesPredictionQ"] && #["maxAbsChangeRatioError"] <= 10^-30 &],
  "allJ0000WithinTolerance" -> AllTrue[
    Select[comparisonRows, #["quantity"] =!= "K" &],
    #["relativeDifference"] <= comparisonTolerance &],
  "allKWithinTolerance" -> AllTrue[
    Select[comparisonRows, #["quantity"] === "K" &],
    #["relativeDifference"] <= comparisonTolerance &],
  "coincidentBranchesImproved" -> AllTrue[
    Select[comparisonRows,
      MemberQ[{"pp", "mm", "K"}, #["quantity"]] && NumericQ[#["preFixRelativeDifference"]] &],
    #["relativeDifference"] <= #["preFixRelativeDifference"]/improvementFactor &],
  "oppositeBranchesPreserved" -> AllTrue[
    Select[comparisonRows,
      MemberQ[{"pm", "mp"}, #["quantity"]] && NumericQ[#["preFixRelativeDifference"]] &],
    #["relativeDifference"] <= 10 #["preFixRelativeDifference"] &]
|>;
passedCount = Count[Values[checks], True];
status = If[passedCount === Length[checks], "passed", "failed"];
elapsedSeconds = AbsoluteTime[] - validationStart;

summary = <|
  "status" -> status,
  "scope" ->
    "fixed-momentum bubble: masters, dlog DE, boundary leading records and J0000/K values " <>
    "against the collaborator bubble-check oracle (development commit 64fd90c)",
  "gitHeadCommit" -> gitHeadCommit,
  "checks" -> checks,
  "passedCount" -> passedCount,
  "checkCount" -> Length[checks],
  "sourceIdentity" -> <|
    "MadStree.wl" -> hashFile[FileNameJoin[{versionRoot, "Kernel", "MadStree.wl"}]],
    "Sectors.wl" -> hashFile[FileNameJoin[{versionRoot, "Kernel", "Core", "Sectors.wl"}]],
    "Boundary.wl" -> hashFile[FileNameJoin[{versionRoot, "Kernel", "Numerics", "Boundary.wl"}]],
    "adapter" -> hashFile[FileNameJoin[{versionRoot, "Backend", "flintnde_transport.py"}]]|>,
  "oracleIntegrity" -> oracleIntegrity,
  "predictedChangeRatios" -> predictedChangeRatios,
  "predictedChangedIndices" -> predictedChangedIndices,
  "inputs" -> <|
    "pointSequence" -> pointSequence,
    "parameterRules" -> {x1 -> 1, x2 -> x2Rational, a1 -> 1 + I/2, a2 -> 1 + I/2},
    "options" -> <|
      "workingPrecision" -> workingPrecision, "transportOrder" -> transportOrder,
      "referenceTransportOrder" -> referenceTransportOrder,
      "boundarySeriesOrder" -> boundarySeriesOrder,
      "targetRelativeError" -> targetRelativeError,
      "boundaryScale" -> boundaryScale, "rankOrder" -> rankOrder,
      "singularityMode" -> singularityMode|>,
    "convention" -> <|"nuConvention" -> "Negative", "rankOrder" -> rankOrder|>|>,
  "branchResults" -> (KeyTake[#,
      {"signs", "masterCount", "sectorKeys", "pinchedSectorCount", "pinchedNormalizations",
       "masterComparison", "deComparison", "boundaryComparison", "boundarySeconds",
       "seconds", "computedQ", "pointTargetMet", "segmentSummary"}] & /@ branchResults),
  "comparisonTolerance" -> comparisonTolerance,
  "comparisonRows" -> comparisonRows,
  "referenceMeta" -> (KeyTake[#,
      {"rho", "order", "dps", "truncationCertified", "absoluteKTruncationBound", "path"}] & /@
     referenceData),
  "timings" -> <|
    "boundarySeconds" -> Lookup[Values[branchResults], "boundarySeconds"],
    "branchSeconds" -> Lookup[Values[branchResults], "seconds"],
    "totalSeconds" -> elapsedSeconds|>
|>;
writeUTF8Text[summaryFile, ToString[summary, InputForm, PageWidth -> Infinity] <> "\n"];

repairSourceUTF8[text_String] := FromCharacterCode[ToCharacterCode[text, "ISO8859-1"], "UTF-8"];
numberText[value_] := ToString[N[value, 8], InputForm];
comparisonTableLines = Prepend[
  Map[
    "  | " <> #["rhoLabel"] <> " | " <> #["quantity"] <> " | " <>
      numberText[#["relativeDifference"]] <> " | " <>
      If[NumericQ[#["preFixRelativeDifference"]], numberText[#["preFixRelativeDifference"]], "-"] <> " | " <>
      If[NumericQ[#["improvementFactor"]], numberText[#["improvementFactor"]], "-"] <> " |" &,
    comparisonRows],
  "  | rho | 分支/K | 修复后相对差 | 修复前相对差 | 改善倍数 |"];

reportLines = repairSourceUTF8 /@ Join[{
  "# MadStree v0.17 独立检验报告：固定圈动量 bubble 对照合作者 bubble-check oracle",
  "",
  "## 状态",
  "",
  "- 状态：`" <> status <> "`",
  "- 通过：`" <> ToString[passedCount] <> "/" <> ToString[Length[checks]] <> "`",
  "- git HEAD：`" <> gitHeadCommit <> "`；oracle 来源：development 提交 `64fd90c`，13 件文件 SHA-256 已核对（`oracle/PROVENANCE.json`）。",
  "- 范围：主积分序列、dlog DE、边界领头记录、J0000/K 数值四类对照；数值 oracle 为 bubble-check 的独立 Wick 旋转级数参考（不经 MadStree/FlintNDE）。",
  "- 判据：J0000 与 K 中点相对差 ≤ `" <> ToString[comparisonTolerance, InputForm] <>
    "`（取自 r2.8 参考 K 截断上界折合相对 ~4.8e-21 与修复前 pm/mp 已达的 1e-26 之上）；" <>
    "边界恰只在与修复预言一致的等时混合 bit 接触支（pp/mm 的全局 18、21）按新旧比（pp `" <>
    ToString[N[predictedChangeRatios["pp"], 10], InputForm] <> "`、mm `" <>
    ToString[N[predictedChangeRatios["mm"], 10], InputForm] <>
    "`，两比值互为 e^{π/2} 镜像）改变，其余逐条不变；pp/mm/K 相对修复前改善 ≥ `" <>
    ToString[improvementFactor] <> "` 倍，pm/mp 不劣化超过 10 倍。",
  "",
  "## 主积分序列与 dlog DE",
  "",
  "- 逐支对照：" <> ToString[
      Normal@AssociationThread[{"pp", "pm", "mp", "mm"},
        Lookup[Values[branchResults], "masterComparison"]], InputForm] <> "。",
  "- DE 对照（sectorOrder/维度/SameQ 与采样点数值差）：" <> ToString[
      Normal@AssociationThread[{"pp", "pm", "mp", "mm"},
        Lookup[Values[branchResults], "deComparison"]], InputForm] <> "。",
  "- 接触扇区 normalization（代入参数后）：" <>
    ToString[Normal@AssociationThread[{"pp", "pm", "mp", "mm"},
      Lookup[Values[branchResults], "pinchedNormalizations"]], InputForm] <> "。",
  "",
  "## 边界领头记录与等时修复",
  "",
  "- 逐支记录数（oracle/当前）、变化支集合与变化支比值偏差：" <> ToString[
      Normal@AssociationThread[{"pp", "pm", "mp", "mm"},
        KeyTake[Lookup[Values[branchResults], "boundaryComparison"],
          {"recordCountOracle", "recordCountCurrent", "changedIndices",
           "changeSetMatchesPredictionQ", "maxAbsChangeRatioError"}]], InputForm] <> "。",
  "- 预言变化支：" <> ToString[Normal[predictedChangedIndices], InputForm] <>
    "；预言比值 pp (1+e^{-π/2})/2 = " <> ToString[N[predictedChangeRatios["pp"], 12], InputForm] <>
    "、mm (1+e^{π/2})/2 = " <> ToString[N[predictedChangeRatios["mm"], 12], InputForm] <> "。",
  "",
  "## 数值点",
  "",
  "- 点：rho=10,5,14/5（参考级数要求 rho>x1+x2≈2.414，均在收敛域内）；路径按 `RankOrder -> {1,2}` 的 nested blow-up 边界（oracle 记录的边界曲线 k1=196 i σ1/t_b^2、k2=14 i σ2/t_b，锚点 t_b=1 后输运到实点）；`SingularityMode -> Avoid`，逐支节点数见 summary。",
  "- 边界阶 `" <> ToString[boundarySeriesOrder] <> "`，输运主/参考阶 `" <> ToString[transportOrder] <> "/" <>
    ToString[referenceTransportOrder] <> "`，工作精度 `" <> ToString[workingPrecision] <>
    "` 位，目标 `" <> targetRelativeError <> "`（原运行即未达，逐点标志照抄不作通过条件）。",
  "",
  "相对差（native 对独立参考中点）：",
  ""},
  comparisonTableLines,
  {
  "",
  "## 耗时",
  "",
  "- 逐支边界/输运秒数：`" <> ToString[
      Normal@AssociationThread[{"pp", "pm", "mp", "mm"},
        Transpose[{Lookup[Values[branchResults], "boundarySeconds"],
          Lookup[Values[branchResults], "seconds"]}]], InputForm] <> "`；总 wall：`" <>
    ToString[elapsedSeconds] <> "`。",
  "",
  "## 检查项",
  ""},
  KeyValueMap["- `" <> #1 <> "`：" <> If[TrueQ[#2], "PASS", "FAIL"] &, checks],
  {"", "机器证据：`results/summary.wl`（含 15 行完整比较、76 条边界记录逐条比值与全部原值）。runtime 已清理。"}
];
writeUTF8Text[reportFile, StringRiffle[reportLines, "\n"] <> "\n"];

If[DirectoryQ[runtimeDirectory], DeleteDirectory[runtimeDirectory, DeleteContents -> True]];
Print[InputForm[<|
  "status" -> status, "passed" -> passedCount, "total" -> Length[checks],
  "maxRelativeDifference" -> Max[Lookup[comparisonRows, "relativeDifference"]],
  "changedIndices" -> Normal@AssociationThread[{"pp", "pm", "mp", "mm"},
    Lookup[Lookup[Values[branchResults], "boundaryComparison"], "changedIndices"]]|>]];
Exit[If[status === "passed", 0, 1]];
