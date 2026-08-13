(* ::Package:: *)

(***
文件：test_example04_three_vertex_threads.wls
用途：在 Example 04 的真实三顶点、两传播子拓扑上比较 python-flint 线程数。
输入：MADSTREE_THREAD_LABEL、MADSTREE_PYTHON；MADSTREE_POINT_LIMIT 可用于小规模探针。
输出：test/results_test/example04_<label>/summary.json，不写入程序包源码目录。
***)

(* ::Chapter:: *)
(*路径与运行参数*)

testRoot = DirectoryName[$InputFileName];
packageRoot = DirectoryName[testRoot];
kernelRoot = FileNameJoin[{packageRoot, "versions", "MadStree-v0.11", "Kernel"}];
label = Environment["MADSTREE_THREAD_LABEL"];
pythonExecutable = Environment["MADSTREE_PYTHON"];
pointLimitText = Environment["MADSTREE_POINT_LIMIT"];
pointLimit = If[StringQ[pointLimitText] && StringMatchQ[pointLimitText, DigitCharacter ..],
  ToExpression[pointLimitText], 900];
If[! StringQ[label] || ! StringMatchQ[label, RegularExpression["[A-Za-z0-9_-]+"]], Exit[10]];
If[! StringQ[pythonExecutable] || StringLength[StringTrim[pythonExecutable]] == 0, Exit[11]];
outputRoot = FileNameJoin[{testRoot, "results_test", "example04_" <> label}];
runtimeRoot = FileNameJoin[{outputRoot, "runtime"}];
runtimePlanned = FileNameJoin[{runtimeRoot, "planned"}];
runtimeDirect = FileNameJoin[{runtimeRoot, "direct"}];
summaryFile = FileNameJoin[{outputRoot, "summary.json"}];
Scan[If[! DirectoryQ[#], CreateDirectory[#, CreateIntermediateDirectories -> True]] &,
  {outputRoot, runtimePlanned, runtimeDirect}];
SetEnvironment["PYTHONDONTWRITEBYTECODE" -> "1"];
SetEnvironment["MADSTREE_THREAD_DIAGNOSTIC" -> FileNameJoin[{outputRoot, "python_processes.jsonl"}]];


(* ::Chapter:: *)
(*Example 04 三顶点拓扑与 900 个 exact 点*)

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
bridgeStartRules = {
  k1 -> -4096 I, k2 -> -256 I, k3 -> -16 I,
  q12 -> 1, q23 -> 2, a1 -> 1, a2 -> 1, a3 -> 1
};
bridgeTargetRules = {
  k1 -> -9 I, k2 -> -3 I, k3 -> -5 I,
  q12 -> 1, q23 -> 2, a1 -> 1, a2 -> 1, a3 -> 1
};
bridgeSymbols = {k1, k2, k3, q12, q23, a1, a2, a3};
allPoints = Table[
  Thread[
    bridgeSymbols ->
      ((1 - s) (bridgeSymbols /. bridgeStartRules) + s (bridgeSymbols /. bridgeTargetRules))
  ],
  {s, 1/900, 1, 1/900}
];
points = Take[allPoints, Min[pointLimit, Length[allPoints]]];
commonOptions = {
  PythonExecutable -> pythonExecutable,
  BoundaryScale -> 4,
  BoundarySeriesOrder -> 24,
  RankOrder -> {v1, v2, v3},
  WorkingPrecision -> 40,
  TransportOrder -> 80,
  ReferenceTransportOrder -> 104,
  TargetRelativeError -> "1e-20",
  SingularityMode -> "Avoid",
  MessageLanguage -> "EN"
};


(* ::Chapter:: *)
(*Planned 与 direct 两条 cold 路线*)

{plannedWall, planned} = AbsoluteTiming[
  MSEvaluatePath[
    context, points,
    FlintNDEPathPlanning -> True,
    MSRuntimeDirectory -> runtimePlanned,
    Sequence @@ commonOptions
  ]
];
If[Head[planned] === Failure, Print[InputForm[planned]]; Exit[20]];
Put[
  <|
    "boundary" -> planned["boundary"],
    "outerFirstSegment" -> First[planned["segments"]],
    "backendFirstSegment" -> First[planned[["flintNDE", "segments"]]]
  |>,
  FileNameJoin[{outputRoot, "planned_first_segment.wl"}]
];

{directWall, direct} = AbsoluteTiming[
  MSEvaluatePath[
    context, points,
    FlintNDEPathPlanning -> False,
    MSRuntimeDirectory -> runtimeDirect,
    Sequence @@ commonOptions
  ]
];
If[Head[direct] === Failure, Print[InputForm[direct]]; Exit[21]];


(* ::Chapter:: *)
(*逐点互检与计时摘要*)

plannedValues = Lookup[planned["pointResults"], "value"];
directValues = Lookup[direct["pointResults"], "value"];
absoluteDifferences = MapThread[Abs[#1 - #2] &, {plannedValues, directValues}, 2];
maximumAbsoluteDifference = Max[Flatten[absoluteDifferences]];
routeTiming[result_Association, wall_] := Module[
  {backend, boundarySeconds, planningSeconds, primarySeconds, referenceSeconds},
  backend = result["flintNDE"];
  boundarySeconds = N[Lookup[backend["boundary"], "seconds", 0]];
  planningSeconds = N[Lookup[backend, "planningSeconds", 0]];
  primarySeconds = N[Lookup[backend, "primarySeconds", 0]];
  referenceSeconds = N[Lookup[backend, "referenceSeconds", 0]];
  <|
    "boundarySeconds" -> boundarySeconds,
    "planningSeconds" -> planningSeconds,
    "primarySeconds" -> primarySeconds,
    "referenceSeconds" -> referenceSeconds,
    "backendOnlySeconds" -> boundarySeconds + planningSeconds + primarySeconds + referenceSeconds,
    "endToEndWallSeconds" -> wall
  |>
];
plannedTiming = routeTiming[planned, plannedWall];
directTiming = routeTiming[direct, directWall];
algorithmCounts[result_Association] := Counts@Flatten@Map[
  Replace[
    Lookup[Lookup[#, "pointValues", {}], "evaluationAlgorithm", Null],
    Null -> "node",
    {1}
  ] &,
  result[["flintNDE", "segments"]]
];
backendNodeCount[result_Association] := Total[Lookup[result[["flintNDE", "segments"]], "nodeCount", 0]];
backendDenseCount[result_Association] := Total[Lookup[result[["flintNDE", "segments"]], "coveredSampleCount", 0]];
checks = <|
  "threeVertices" -> Length[treeSpec["vertices"]] === 3,
  "twoPropagators" -> Length[treeSpec["lines"]] === 2,
  "pointCount" -> Length[points] === pointLimit,
  "masterDimension" -> de["masterCount"] === 9,
  "plannedAllPoints" -> Length[plannedValues] === Length[points],
  "directAllPoints" -> Length[directValues] === Length[points],
  "plannedDirectAgreement" -> maximumAbsoluteDifference < 10^-18,
  "targetsMet" -> TrueQ[planned[["flintNDE", "targetRelativeErrorMet"]]] &&
    TrueQ[direct[["flintNDE", "targetRelativeErrorMet"]]],
  "coldProcesses" -> ! TrueQ[planned[["flintNDE", "cacheHit"]]] &&
    ! TrueQ[direct[["flintNDE", "cacheHit"]]]
|>;


(* ::Chapter:: *)
(*机器结果与清理*)

summary = <|
  "schema" -> "madstree_v011_example04_threads_benchmark_v1",
  "status" -> If[And @@ Values[checks], "passed", "failed"],
  "label" -> label,
  "topology" -> "v1--l12--v2--l23--v3, two masslessFull propagators",
  "vertexCount" -> Length[treeSpec["vertices"]],
  "propagatorCount" -> Length[treeSpec["lines"]],
  "masterCount" -> de["masterCount"],
  "pointCount" -> Length[points],
  "workingPrecisionDigits" -> 40,
  "primaryOrder" -> 80,
  "referenceOrder" -> 104,
  "pythonExecutable" -> pythonExecutable,
  "planned" -> <|
    "timing" -> plannedTiming,
    "algorithmCounts" -> algorithmCounts[planned],
    "backendNodeCountSum" -> backendNodeCount[planned],
    "backendDenseCount" -> backendDenseCount[planned],
    "segmentCount" -> Length[planned["segments"]]
  |>,
  "direct" -> <|
    "timing" -> directTiming,
    "algorithmCounts" -> algorithmCounts[direct],
    "backendNodeCountSum" -> backendNodeCount[direct],
    "backendDenseCount" -> backendDenseCount[direct],
    "segmentCount" -> Length[direct["segments"]]
  |>,
  "maximumPlannedDirectAbsoluteDifference" -> ToString[maximumAbsoluteDifference, InputForm],
  "checks" -> checks
|>;
Export[summaryFile, summary, "RawJSON"];
If[DirectoryQ[runtimeRoot], DeleteDirectory[runtimeRoot, DeleteContents -> True]];
Print["Example 04 three-vertex threads benchmark: ", summary["status"],
  ", masters=", summary["masterCount"], ", points=", summary["pointCount"]];
If[summary["status"] =!= "passed", Exit[30]];
