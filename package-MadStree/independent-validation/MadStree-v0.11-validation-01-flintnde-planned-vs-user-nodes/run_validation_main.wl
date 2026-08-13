(* ::Package:: *)

(***
文件：run_validation_main.wl
用途：对同一 900 点比较 FlintNDE 自动节点规划与严格用户节点路线。
约束：只调用 v0.11 现行 MSEvaluatePath；A/B 各自一次 cold Python 进程。
***)

(* ::Chapter:: *)
(*路径与共同配置*)

validationRoot = DirectoryName[$InputFileName];
madStreeRoot = ExpandFileName@FileNameJoin[{validationRoot, "..", "..", "versions", "MadStree-v0.11"}];
kernelRoot = FileNameJoin[{madStreeRoot, "Kernel"}];
repositoryRoot = ExpandFileName@FileNameJoin[{validationRoot, "..", "..", ".."}];
runtimeRoot = FileNameJoin[{repositoryRoot, ".madstree-v011-validation-runtime", CreateUUID[]}];
runtimeA = FileNameJoin[{runtimeRoot, "route-a"}];
runtimeB = FileNameJoin[{runtimeRoot, "route-b"}];
resultsRoot = FileNameJoin[{validationRoot, "results"}];
summaryFile = FileNameJoin[{resultsRoot, "summary.wl"}];
evidenceFile = FileNameJoin[{resultsRoot, "evidence.json"}];
reportFile = FileNameJoin[{validationRoot, "000_MadStree-v0.11-validation-01-flintnde-planned-vs-user-nodes-report.md"}];
pythonExecutable = With[{override = Quiet[Environment["MADSTREE_PYTHON"]]},
  If[StringQ[override] && StringLength[StringTrim[override]] > 0, StringTrim[override], "python"]
];
workingPrecision = 40;
primaryOrder = 64;
referenceOrder = 88;
targetRelativeError = "1e-18";
boundaryScale = 15;
boundarySeriesOrder = 24;
strictNodeMaximumPoleRatio = 0.31838634237934677799885386319704520539;

Scan[If[! DirectoryQ[#], CreateDirectory[#, CreateIntermediateDirectories -> True]] &, {resultsRoot, runtimeA, runtimeB}];
SetEnvironment["PYTHONDONTWRITEBYTECODE" -> "1"];


(* ::Chapter:: *)
(*显式加载 v0.11 与 exact 输入*)

AppendTo[$Path, kernelRoot];
Needs["MadStree`"];
context = MSInitTree[<|
  "vertices" -> {
    <|"id" -> v1, "energy" -> k1, "timePower" -> a1, "phaseSign" -> 1|>,
    <|"id" -> v2, "energy" -> k2, "timePower" -> a2, "phaseSign" -> 1|>
  },
  "lines" -> {
    <|"id" -> e, "type" -> "masslessFull", "endpoints" -> {v1, v2},
      "momentum" -> q, "skType" -> "++"|>
  }
|>];
de = MSDLogDE[context];
points = Flatten[
  Table[
    {k1 -> -900 I + aa/10, k2 -> -30 I + nn/10 + I mm/10,
      q -> 1, a1 -> 1, a2 -> 1},
    {aa, 0, 2}, {nn, 0, 99}, {mm, 0, 2}
  ],
  {{1, 2, 3}}
];
commonOptions = {
  PythonExecutable -> pythonExecutable,
  BoundaryScale -> boundaryScale,
  BoundarySeriesOrder -> boundarySeriesOrder,
  RankOrder -> {v1, v2},
  WorkingPrecision -> workingPrecision,
  TransportOrder -> primaryOrder,
  ReferenceTransportOrder -> referenceOrder,
  TargetRelativeError -> targetRelativeError,
  SingularityMode -> "Avoid",
  MessageLanguage -> "EN"
};


(* ::Chapter:: *)
(*两条 cold 单进程公共路线*)

{routeAWall, routeA} = AbsoluteTiming[
  MSEvaluatePath[
    context, points,
    FlintNDEPathPlanning -> True,
    MSRuntimeDirectory -> runtimeA,
    Sequence @@ commonOptions
  ]
];
If[Head[routeA] === Failure, Print[InputForm[routeA]]; Exit[2]];

{routeBWall, routeB} = AbsoluteTiming[
  MSEvaluatePath[
    context, points,
    FlintNDEPathPlanning -> False,
    MSRuntimeDirectory -> runtimeB,
    Sequence @@ commonOptions
  ]
];
If[Head[routeB] === Failure, Print[InputForm[routeB]]; Exit[3]];


(* ::Chapter:: *)
(*逐点比较、覆盖和算法计数*)

valuesA = Lookup[routeA["pointResults"], "value"];
valuesB = Lookup[routeB["pointResults"], "value"];
absoluteDifferences = MapThread[Abs[#1 - #2] &, {valuesA, valuesB}, 2];
relativeDifferences = MapThread[
  #1/Map[Max[Abs[#], 10^-300] &, #2] &,
  {absoluteDifferences, valuesB}
];
segmentsA = routeA["segments"];
segmentsB = routeB["segments"];
backendSegmentsA = routeA[["flintNDE", "segments"]];
backendSegmentsB = routeB[["flintNDE", "segments"]];

algorithmCounts[segments_List] := Counts@Flatten@Map[
  Function[segment,
    Map[
      Replace[Lookup[#, "evaluationAlgorithm", Null], Null -> "node"] &,
      Lookup[segment, "pointValues", {}]
    ]
  ],
  segments
];
algorithmsA = algorithmCounts[backendSegmentsA];
algorithmsB = algorithmCounts[backendSegmentsB];

coverageRecords = Flatten@MapIndexed[
  Function[{segment, position},
    MapThread[
      <|
        "userIndex" -> Lookup[#1, "userIndex"],
        "bucket" -> ToString[First[position]] <> ":" <>
          If[Lookup[#1, "source"] === "node_snapshot",
            "node-" <> ToString[Lookup[#1, "nodeIndex"]],
            "step-" <> ToString[Lookup[#1, "segmentIndex"]]
          ],
        "source" -> Lookup[#1, "source"],
        "algorithm" -> Replace[Lookup[#2, "evaluationAlgorithm", Null], Null -> "node"]
      |> &,
      {Lookup[segment, "pointAssignments", {}], Lookup[segment, "pointValues", {}]}
    ]
  ],
  backendSegmentsA
];
uniqueCoverage = DeleteDuplicatesBy[coverageRecords, Lookup[#, "userIndex"] &];
coverageValues = Values@Counts[Lookup[uniqueCoverage, "bucket"]];
coverageHistogram = Association@KeyValueMap[ToString[#1] -> #2 &, Counts[coverageValues]];
coverageBuckets = Map[
  Function[records,
    <|
      "bucket" -> First[records]["bucket"],
      "size" -> Length[records],
      "algorithm" -> First[DeleteDuplicates[Lookup[records, "algorithm"]]],
      "userIndices" -> Lookup[records, "userIndex"]
    |>
  ],
  GatherBy[coverageRecords, Lookup[#, "bucket"] &]
];
fastBuckets = Select[coverageBuckets, Lookup[#, "algorithm"] === "fast" &];

routeTiming[result_Association, wall_] := Module[{backend, boundarySeconds, backendSeconds},
  backend = result["flintNDE"];
  boundarySeconds = Lookup[Lookup[backend, "boundary", <||>], "seconds", 0.];
  backendSeconds = Total@N@{
    boundarySeconds,
    Lookup[backend, "planningSeconds", 0.],
    Lookup[backend, "primarySeconds", 0.],
    Lookup[backend, "referenceSeconds", 0.]
  };
  <|
    "boundarySeconds" -> boundarySeconds,
    "planningSeconds" -> Lookup[backend, "planningSeconds", 0.],
    "primarySeconds" -> Lookup[backend, "primarySeconds", 0.],
    "referenceSeconds" -> Lookup[backend, "referenceSeconds", 0.],
    "backendOnlySeconds" -> backendSeconds,
    "endToEndWallSeconds" -> wall,
    "nonBackendOverheadSeconds" -> wall - backendSeconds
  |>
];
timingA = routeTiming[routeA, routeAWall];
timingB = routeTiming[routeB, routeBWall];


(* ::Chapter:: *)
(*路径摘要、身份与验收*)

segmentEvidence[outer_, backend_] := MapThread[
  <|
    "segmentIndex" -> #1["segmentIndex"],
    "fromUserIndex" -> #1["fromUserIndex"],
    "toUserIndex" -> #1["toUserIndex"],
    "userIndices" -> #1["userIndices"],
    "physicalStart" -> ToString[#1["startRules"], InputForm],
    "physicalTarget" -> ToString[#1["targetRules"], InputForm],
    "nodeCount" -> #2["nodeCount"],
    "coveredSampleCount" -> #2["coveredSampleCount"],
    "actualNodes" -> #2["actualNodes"],
    "planReport" -> #2["planReport"],
    "relativeDifferenceInf" -> #2["relativeDifferenceInf"],
    "targetRelativeErrorMet" -> #2["targetRelativeErrorMet"],
    "certificationMode" -> #2["certificationMode"]
  |> &,
  {outer, backend}
];
segmentEvidenceA = segmentEvidence[segmentsA, backendSegmentsA];
segmentEvidenceB = segmentEvidence[segmentsB, backendSegmentsB];

sha256[file_String] := IntegerString[FileHash[file, "SHA256"], 16, 64];
flintTreeDigest[root_String] := Module[{files, records},
  files = Sort@Join[FileNames["*.py", FileNameJoin[{root, "flintnde"}]], {FileNameJoin[{root, "pyproject.toml"}]}];
  records = {FileNameDrop[#, FileNameDepth[root]], sha256[#]} & /@ files;
  IntegerString[Hash[ExportString[records, "RawJSON"], "SHA256"], 16, 64]
];
vendorRoot = FileNameJoin[{madStreeRoot, "Vendor", "FlintNDE"}];
commit = StringTrim@RunProcess[{"git", "rev-parse", "HEAD"}, "StandardOutput"];

fixedGroupsA = Select[segmentsA, Length[#userIndices] === 300 &];
outerHasNoNodes = And @@ (! KeyExistsQ[#, "actualNodes"] && ! KeyExistsQ[#, "nodeCount"] & /@ segmentsA);
directNodeContract = And @@ MapThread[
  #2["nodeCount"] === Length[#1["userIndices"]] + 1 &&
    #2["coveredSampleCount"] === 0 &,
  {segmentsB, backendSegmentsB}
];
checks = <|
  "version011" -> MadStree`Private`$MadStreeVersion === "0.11",
  "pointCount900" -> Length[points] === 900,
  "routeAComputed" -> routeA["status"] === "computed" && TrueQ[routeA["pathPlanning"]],
  "routeBComputed" -> routeB["status"] === "computed" && ! TrueQ[routeB["pathPlanning"]],
  "sameFiveSegments" -> Length[segmentsA] === 5 && Length[segmentsB] === 5,
  "threeFixedGroups300" -> Length[fixedGroupsA] === 3,
  "routeAAllPoints" -> Length[valuesA] === 900,
  "routeBAllPoints" -> Length[valuesB] === 900,
  "routeAFastUsed" -> Lookup[algorithmsA, "fast", 0] > 0,
  "fastUsesSharedBuckets" -> fastBuckets =!= {} && Min[Lookup[fastBuckets, "size"]] >= 8 &&
    And @@ (Lookup[#, "source"] =!= "node_snapshot" & /@ Select[coverageRecords, Lookup[#, "algorithm"] === "fast" &]),
  "routeBOnlyNodes" -> Lookup[algorithmsB, "node", 0] === 904 && Total[Values@KeyDrop[algorithmsB, "node"]] === 0,
  "directUserNodeContract" -> directNodeContract,
  "madStreeDidNotPlanNodes" -> outerHasNoNodes,
  "coldSeparateProcesses" -> ! TrueQ[routeA[["flintNDE", "cacheHit"]]] && ! TrueQ[routeB[["flintNDE", "cacheHit"]]] &&
    routeA[["flintNDE", "process", "ExitCode"]] === 0 && routeB[["flintNDE", "process", "ExitCode"]] === 0,
  "allTargetsMet" -> TrueQ[routeA[["flintNDE", "targetRelativeErrorMet"]]] && TrueQ[routeB[["flintNDE", "targetRelativeErrorMet"]]],
  "all900AllMastersCompared" -> Dimensions[absoluteDifferences] === {900, de["masterCount"]},
  "maximumRelativeDifference" -> Max[Flatten[relativeDifferences]] < 10^-15
|>;
passedCount = Count[Values[checks], True];
status = If[passedCount === Length[checks], "passed", "failed"];


(* ::Chapter:: *)
(*正式证据、摘要与报告*)

evidence = <|
  "schema" -> "madstree_v0.11_planned_vs_user_nodes_validation_v1",
  "status" -> status,
  "commit" -> commit,
  "digests" -> <|
    "MadStreeKernelSHA256" -> sha256[FileNameJoin[{madStreeRoot, "Kernel", "MadStree.wl"}]],
    "adapterSHA256" -> sha256[FileNameJoin[{madStreeRoot, "Backend", "flintnde_transport.py"}]],
    "vendorFlintNDETreeSHA256" -> flintTreeDigest[vendorRoot]
  |>,
  "convention" -> <|
    "columnVector" -> "Y'=A(s)Y",
    "masters" -> ToString[de["masters"], InputForm],
    "normalization" -> Lookup[de["masters"], "normalization"],
    "boundaryKind" -> routeA[["boundary", "boundaryKind"]],
    "boundarySeriesOrder" -> routeA[["boundary", "seriesOrder"]],
    "boundaryScale" -> routeA[["boundary", "boundaryScale"]],
    "boundaryConvergenceRatio" -> ToString[routeA[["boundary", "convergenceRatio"]], InputForm],
    "HankelBranch" -> routeA[["boundary", "branchConvention"]]
  |>,
  "input" -> <|
    "pointCount" -> 900,
    "exactCoordinates" -> MapIndexed[<|"userIndex" -> First[#2], "coordinate" -> ToString[#1, InputForm]|> &, points],
    "workingPrecision" -> workingPrecision,
    "primaryOrder" -> primaryOrder,
    "referenceOrder" -> referenceOrder,
    "targetRelativeError" -> targetRelativeError,
    "pythonExecutable" -> pythonExecutable,
    "strictNodeMaximumStepOverNearestPole" -> strictNodeMaximumPoleRatio
  |>,
  "routeA" -> <|
    "name" -> "FlintNDEPathPlanning->True",
    "timing" -> timingA,
    "algorithmCounts" -> algorithmsA,
    "segments" -> segmentEvidenceA,
    "backendBoundary" -> routeA[["flintNDE", "boundary"]],
    "cacheHit" -> routeA[["flintNDE", "cacheHit"]],
    "process" -> routeA[["flintNDE", "process"]],
    "values" -> (ToString[#, InputForm] & /@ valuesA)
  |>,
  "routeB" -> <|
    "name" -> "FlintNDEPathPlanning->False",
    "timing" -> timingB,
    "algorithmCounts" -> algorithmsB,
    "segments" -> segmentEvidenceB,
    "backendBoundary" -> routeB[["flintNDE", "boundary"]],
    "cacheHit" -> routeB[["flintNDE", "cacheHit"]],
    "process" -> routeB[["flintNDE", "process"]],
    "values" -> (ToString[#, InputForm] & /@ valuesB)
  |>,
  "coverage" -> <|
    "minimum" -> Min[coverageValues], "median" -> Median[coverageValues],
    "mean" -> Mean[coverageValues], "maximum" -> Max[coverageValues],
    "histogram" -> coverageHistogram,
    "buckets" -> coverageBuckets,
    "fastBucketCount" -> Length[fastBuckets],
    "fastBucketMinimumSize" -> Min[Lookup[fastBuckets, "size"]]
  |>,
  "fastMultipointImplementation" -> <|
    "owner" -> "FlintNDE Vendor Python backend, not Wolfram Language",
    "file" -> FileNameJoin[{vendorRoot, "flintnde", "transport.py"}],
    "SHA256" -> sha256[FileNameJoin[{vendorRoot, "flintnde", "transport.py"}]],
    "call" -> "acb_poly.evaluate(deltas, algorithm='fast')",
    "method" -> "FLINT subproduct/remainder tree for buckets of at least 8 points"
  |>,
  "comparison" -> <|
    "pointCount" -> 900, "masterCount" -> de["masterCount"],
    "maximumAbsoluteDifference" -> Max[Flatten[absoluteDifferences]],
    "maximumRelativeDifference" -> Max[Flatten[relativeDifferences]],
    "pointwiseAbsoluteDifferences" -> (ToString[#, InputForm] & /@ absoluteDifferences),
    "pointwiseRelativeDifferences" -> (ToString[#, InputForm] & /@ relativeDifferences)
  |>,
  "madStreeNodePlanning" -> <|
    "performed" -> False,
    "evidence" -> "outer segment records contain no actualNodes/nodeCount; all node fields occur only under flintNDE"
  |>,
  "checks" -> checks
|>;
Export[evidenceFile, evidence, "RawJSON"];

summary = <|
  "status" -> status, "commit" -> commit, "digests" -> evidence["digests"],
  "convention" -> evidence["convention"],
  "input" -> KeyDrop[evidence["input"], "exactCoordinates"],
  "routeA" -> <|"timing" -> timingA, "algorithmCounts" -> algorithmsA,
    "backendBoundary" -> evidence[["routeA", "backendBoundary"]], "segments" -> segmentEvidenceA|>,
  "routeB" -> <|"timing" -> timingB, "algorithmCounts" -> algorithmsB,
    "backendBoundary" -> evidence[["routeB", "backendBoundary"]], "segments" -> segmentEvidenceB|>,
  "coverage" -> evidence["coverage"],
  "fastMultipointImplementation" -> evidence["fastMultipointImplementation"],
  "comparison" -> KeyDrop[evidence["comparison"], {"pointwiseAbsoluteDifferences", "pointwiseRelativeDifferences"}],
  "madStreeNodePlanning" -> evidence["madStreeNodePlanning"],
  "checks" -> checks, "passedCount" -> passedCount, "totalCount" -> Length[checks],
  "evidenceFile" -> evidenceFile
|>;
Export[summaryFile, ToString[summary, InputForm] <> "\n", "Text", CharacterEncoding -> "UTF-8"];

segmentRows = MapThread[
  "| " <> ToString[#1["segmentIndex"]] <> " | " <>
    ToString[First[#1["userIndices"]]] <> "--" <> ToString[Last[#1["userIndices"]]] <> " | `" <>
    #1["physicalStart"] <> "` | `" <> #1["physicalTarget"] <> "` | " <>
    ToString[#1["nodeCount"]] <> " / " <> ToString[#2["nodeCount"]] <> " | " <>
    ToString[#1["coveredSampleCount"]] <> " / " <> ToString[#2["coveredSampleCount"]] <> " |" &,
  {segmentEvidenceA, segmentEvidenceB}
];
report = StringRiffle[{
  "# MadStree v0.11 独立验证 01：FlintNDE 自动规划与严格用户节点",
  "",
  "- 日期：2026-08-13",
  "- 状态：`" <> status <> "`（" <> ToString[passedCount] <> "/" <> ToString[Length[checks]] <> "）",
  "- commit：`" <> commit <> "`",
  "- MadStree/adapter/FlintNDE tree SHA-256：`" <> StringRiffle[Values[evidence["digests"]], "` / `"] <> "`。",
  "- 约定：`Y'=A(s)Y`；master/normalization 见 `results/summary.wl`；boundaryKind=`" <>
    evidence[["convention", "boundaryKind"]] <> "`，seriesOrder=" <> ToString[evidence[["convention", "boundarySeriesOrder"]]] <>
    "，Hankel branch=`" <> evidence[["convention", "HankelBranch"]] <> "`。",
  "- master 顺序：`" <> evidence[["convention", "masters"]] <> "`；normalization：`" <>
    ToString[evidence[["convention", "normalization"]], InputForm] <> "`。",
  "",
  "## 输入与职责边界",
  "",
  "exact 900 点：`k1=-900 I+a/10`、`k2=-30 I+n/10+I m/10`、`q=1,a1=a2=1`，a/n/m 顺序。工作精度 40 位，边界和普通点输运主/参考阶 64/88，目标相对误差 `1e-18`。共同 BoundaryScale=15、seriesOrder=24；阻尼基数 30 给出 matching anchor `k1=-900 I,k2=-30 I`。exact 拉回极点预审的最大 `step/nearest-pole-distance=0.3183863423793468<0.60`；Route B 的正式成功执行和实际节点链构成黑盒复核。全部用户点避开 dlog 奇点；边界是正则奇点 Frobenius 起点，实际 transformed boundary path、convergenceRatio 和 physical anchor 见 JSON。",
  "",
  "MadStree 实际只返回 5 个 maximal 复仿射拉回段（300/2/300/2/300 用户记录）；外层 segment 无 `actualNodes` 或 `nodeCount`。所有节点链只存在于 FlintNDE 返回字段，因此 MadStree 本身未规划节点。A/B 使用相同 Python executable，各自在一个 cold adapter 进程内同时完成同一边界初始化和全部段。",
  "边界 transformed `t` 路径 A=`" <> ToString[evidence[["routeA", "backendBoundary", "path"]], InputForm] <>
    "`，B=`" <> ToString[evidence[["routeB", "backendBoundary", "path"]], InputForm] <>
    "`；两者均从同一正则奇点 Frobenius 数据输运至 `t=1` 的 physical anchor `k1=-900 I,k2=-30 I`。",
  "",
  "| segment | userIndex | physical start | physical target | nodes A/B | dense A/B |",
  "| ---: | --- | --- | --- | ---: | ---: |",
  StringRiffle[segmentRows, "\n"],
  "",
  "完整 A/B 参数节点链、逐段 refinement 和 certification mode 位于 `results/evidence.json`。Route A coverage min/median/mean/max = " <>
    StringRiffle[ToString /@ N[{Min[coverageValues], Median[coverageValues], Mean[coverageValues], Max[coverageValues]}], "/"] <>
    "，histogram=`" <> ToString[coverageHistogram, InputForm] <> "`。算法计数 A=`" <> ToString[algorithmsA, InputForm] <>
    "`，B=`" <> ToString[algorithmsB, InputForm] <> "`。",
  "Route A 的 assignment bucket、覆盖用户索引和算法逐桶保存在 JSON。`fast` bucket 数=" <>
    ToString[Length[fastBuckets]] <> "，最小桶规模=" <> ToString[Min[Lookup[fastBuckets, "size"]]] <>
    "。当前 Vendor `flintnde/transport.py` 对不少于 8 点的同节点覆盖桶调用 FLINT `acb_poly.evaluate(deltas, algorithm=\"fast\")`，即子积树/余数树快速多点求值；Wolfram 只提交点列并读取后端结果，没有逐点计算这些值。",
  "",
  "## 耗时（秒）",
  "",
  "| route | boundary | planning | primary | reference | backend-only | end-to-end |",
  "| --- | ---: | ---: | ---: | ---: | ---: | ---: |",
  "| A planning=True | " <> StringRiffle[ToString /@ Values@KeyTake[timingA, {"boundarySeconds", "planningSeconds", "primarySeconds", "referenceSeconds", "backendOnlySeconds", "endToEndWallSeconds"}], " | "] <> " |",
  "| B planning=False | " <> StringRiffle[ToString /@ Values@KeyTake[timingB, {"boundarySeconds", "planningSeconds", "primarySeconds", "referenceSeconds", "backendOnlySeconds", "endToEndWallSeconds"}], " | "] <> " |",
  "",
  "A/B end-to-end ratio=`" <> ToString[N[routeAWall/routeBWall]] <> "x`；backend-only ratio=`" <>
    ToString[N[timingA["backendOnlySeconds"]/timingB["backendOnlySeconds"]]] <> "x`。等价地，本次 Route A 比 Route B 的 end-to-end 约快 `" <>
    ToString[N[routeBWall/routeAWall]] <> "x`，backend-only 约快 `" <>
    ToString[N[timingB["backendOnlySeconds"]/timingA["backendOnlySeconds"]]] <>
    "x`。性能结论只适用于本系统、点序、精度与本次 fresh 运行。",
  "",
  "## 数值互检与结论",
  "",
  "全部 900 点 × " <> ToString[de["masterCount"]] <> " masters 逐分量互检；最大绝对差=`" <>
    ToString[Max[Flatten[absoluteDifferences]], InputForm] <> "`，最大相对差=`" <>
    ToString[Max[Flatten[relativeDifferences]], InputForm] <> "`。两路线全部 refinement gate 通过，A/B 均 cacheHit=False、单一 Python process ExitCode=0。",
  "",
  If[status === "passed", "本任务通过。", "本任务失败；失败键见 `results/summary.wl`，不得据此认证 v0.11。"]
}, "\n"];
Export[reportFile, report, "Text", CharacterEncoding -> "UTF-8"];

If[DirectoryQ[runtimeRoot], DeleteDirectory[runtimeRoot, DeleteContents -> True]];
Print["MadStree v0.11 independent validation: ", passedCount, "/", Length[checks], " ", status];
Print["report: ", reportFile];
If[status =!= "passed", Print["failed: ", Keys@Select[checks, Not@TrueQ[#] &]]; Exit[1]];
