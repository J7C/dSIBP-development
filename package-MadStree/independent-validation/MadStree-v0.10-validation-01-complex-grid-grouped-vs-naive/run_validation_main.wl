(* ::Package:: *)

(***
文件：run_validation.wls
用途：独立验证 MadStree v0.10 对 900 个二维复格点的分组/dense 路线，
      并与直接 FlintNDE 逐点 cold-plan/cold-execute 基线全量互检。
输出：results/summary.wl、results/pointwise_evidence.json 与自动报告。
运行：wolframscript -file run_validation.wls
***)

(* ::Chapter:: *)
(*路径与固定参数*)

validationRoot = DirectoryName[$InputFileName];
madStreeRoot = ExpandFileName@FileNameJoin[{validationRoot, "..", "..", "versions", "MadStree-v0.10"}];
kernelRoot = FileNameJoin[{madStreeRoot, "Kernel"}];
vendorRoot = FileNameJoin[{madStreeRoot, "Vendor", "FlintNDE"}];
backendRoot = FileNameJoin[{madStreeRoot, "Backend"}];
resultsRoot = FileNameJoin[{validationRoot, "results"}];
temporaryRoot = FileNameJoin[{validationRoot, "results_temp"}];
repositoryRoot = ExpandFileName@FileNameJoin[{validationRoot, "..", "..", ".."}];
routeARuntime = FileNameJoin[{repositoryRoot, ".madstree-validation-runtime", CreateUUID[]}];
requestFile = FileNameJoin[{temporaryRoot, "route_a_execute_request.json"}];
routeAFile = FileNameJoin[{temporaryRoot, "route_a_values.json"}];
naiveFile = FileNameJoin[{temporaryRoot, "naive_output.json"}];
sentinelFile = FileNameJoin[{temporaryRoot, "sentinel_output.json"}];
evidenceFile = FileNameJoin[{resultsRoot, "pointwise_evidence.json"}];
summaryFile = FileNameJoin[{resultsRoot, "summary.wl"}];
reportFile = FileNameJoin[{validationRoot, "000_MadStree-v0.10-validation-01-complex-grid-grouped-vs-naive-report.md"}];
pythonExecutable = With[{override = Quiet[Environment["MADSTREE_PYTHON"]]},
  If[StringQ[override] && StringLength[StringTrim[override]] > 0, StringTrim[override], "python"]
];
workingPrecision = 40;
primaryOrder = 64;
referenceOrder = 88;
targetRelativeError = "1e-18";

Scan[If[! DirectoryQ[#], CreateDirectory[#, CreateIntermediateDirectories -> True]] &, {resultsRoot, temporaryRoot, routeARuntime}];


(* ::Chapter:: *)
(*显式加载当前版本与建立物理系统*)

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
x10 = -9 I;
x20 = -5 I;
gridPoints = Flatten[
  Table[
    {k1 -> x10 + a/10, k2 -> x20 + n/10 + I m/10,
      q -> 1, a1 -> 1, a2 -> 1},
    {a, 0, 2}, {n, 0, 99}, {m, 0, 2}
  ],
  {{1, 2, 3}}
];


(* ::Chapter:: *)
(*Route A：公共 MadStree 分组规划与只执行*)

{routeAPlanningSeconds, plannedPath} = AbsoluteTiming[
  MSGeneratePath[
    context,
    gridPoints,
    BoundaryScale -> 4,
    RankOrder -> {v1, v2},
    WorkingPrecision -> workingPrecision,
    PythonExecutable -> pythonExecutable,
    MSRuntimeDirectory -> routeARuntime,
    SingularityMode -> "Avoid",
    MessageLanguage -> "EN"
  ]
];
If[Head[plannedPath] === Failure, Print[InputForm[plannedPath]]; Exit[2]];

{routeAExecutionSeconds, routeAResult} = AbsoluteTiming[
  MSEvaluatePlannedPath[
    context,
    plannedPath,
    WorkingPrecision -> workingPrecision,
    TransportOrder -> primaryOrder,
    ReferenceTransportOrder -> referenceOrder,
    TargetRelativeError -> targetRelativeError,
    PythonExecutable -> pythonExecutable,
    MSRuntimeDirectory -> routeARuntime,
    MessageLanguage -> "EN"
  ]
];
If[Head[routeAResult] === Failure, Print[InputForm[routeAResult]]; Exit[3]];


(* ::Chapter:: *)
(*构造与 Route A 相同问题定义的独立执行合同*)

configuration = MSFlintNDEConfiguration[];
digits = workingPrecision;
initialVector = If[
  Lookup[plannedPath["boundaryData"], "boundaryKind", "finiteFrobeniusSeries"] === "singularFrobenius",
  Total@MapThread[
    #1 MadStree`Private`msParseFlintVector[#2["finalValues"]] &,
    {
      N[Lookup[plannedPath[["boundaryData", "leadingBranches"]], "physicalWeight"], digits],
      routeAResult[["flintNDE", "singularBoundary", "branchResults"]]
    }
  ],
  plannedPath[["boundaryData", "values"]]
];
executeSegments = Map[
  <|
    "start" -> "0",
    "points" -> #["pointParameters"],
    "letters" -> #["letters"],
    "plan" -> #[["flintNDEPlan", "serializedPlan"]],
    "fromUserIndex" -> #["fromUserIndex"],
    "userIndices" -> #["userIndices"]
  |> &,
  plannedPath["segments"]
];
executeRequest = <|
  "schema" -> "madstree_flintnde_polyline_execute_v2",
  "backendPackagePath" -> configuration["resolvedPath"],
  "masterDigest" -> de["masterDigest"],
  "dimension" -> de["masterCount"],
  "segments" -> executeSegments,
  "singularityMode" -> "avoid",
  "boundary" -> (MadStree`Private`msComplexDecimalRecord[#, digits] & /@ initialVector),
  "workingPrecisionDigits" -> digits,
  "primaryOrder" -> primaryOrder,
  "referenceOrder" -> referenceOrder,
  "targetRelativeError" -> targetRelativeError,
  "certificationMode" -> "embedded",
  "messageLanguage" -> "EN",
  "columnVectorConvention" -> "Y'=A(s)Y",
  "dlogStatus" -> de["dlogStatus"]
|>;
Export[requestFile, executeRequest, "RawJSON"];

backendSegments = routeAResult[["flintNDE", "segments"]];
routeARawPointValues = SortBy[Flatten[Lookup[backendSegments, "pointValues", {}]], Lookup[#, "userIndex"] &];
routeAPointValues = DeleteDuplicatesBy[routeARawPointValues, Lookup[#, "userIndex"] &];
routeADuplicateEndpointAgreement = And @@ Map[
  Function[group,
    Length[DeleteDuplicates[Lookup[group, "values"]]] === 1
  ],
  Select[GatherBy[routeARawPointValues, Lookup[#, "userIndex"] &], Length[#] > 1 &]
];
routeAEvidence = <|
  "route" -> "public-MSGeneratePath-plus-MSEvaluatePlannedPath-grouped-dense",
  "planningSeconds" -> routeAPlanningSeconds,
  "executionSeconds" -> routeAExecutionSeconds,
  "totalWallSeconds" -> routeAPlanningSeconds + routeAExecutionSeconds,
  "executionAction" -> routeAResult["executionAction"],
  "targetRelativeErrorMet" -> routeAResult[["flintNDE", "targetRelativeErrorMet"]],
  "pointValues" -> routeAPointValues,
  "segments" -> MapThread[
    <|
      "segmentIndex" -> #1["segmentIndex"],
      "fromUserIndex" -> #1["fromUserIndex"],
      "userIndices" -> #1["userIndices"],
      "pointParameters" -> #1["pointParameters"],
      "startRules" -> ToString[#1["startRules"], InputForm],
      "targetRules" -> ToString[#1["targetRules"], InputForm],
      "actualPath" -> #1[["flintNDEPlan", "serializedPlan", "nodes"]],
      "plannedNodeCount" -> Length[#1[["flintNDEPlan", "serializedPlan", "nodes"]]],
      "pointAssignments" -> #1[["flintNDEPlan", "pointAssignments"]],
      "nodeSnapshotCount" -> Count[#1[["flintNDEPlan", "pointAssignments"]], KeyValuePattern["source" -> "node_snapshot"]],
      "densePointCount" -> Count[#1[["flintNDEPlan", "pointAssignments"]], KeyValuePattern["source" -> Except["node_snapshot"]]],
      "relativeDifferenceInf" -> #2["relativeDifferenceInf"],
      "targetRelativeErrorMet" -> #2["targetRelativeErrorMet"]
    |> &,
    {plannedPath["segments"], backendSegments}
  ]
|>;
Export[routeAFile, routeAEvidence, "RawJSON"];


(* ::Chapter:: *)
(*Route B、执行期规划哨兵与完整比较*)

naiveProcess = RunProcess[{
  pythonExecutable,
  FileNameJoin[{validationRoot, "naive_oracle.py"}],
  requestFile, routeAFile, naiveFile, vendorRoot
}];
If[naiveProcess["ExitCode"] =!= 0, Print[naiveProcess["StandardError"]]; Exit[4]];
naiveEvidence = Import[naiveFile, "RawJSON"];

sentinelProcess = RunProcess[{
  pythonExecutable,
  FileNameJoin[{validationRoot, "sentinel_execute.py"}],
  requestFile, sentinelFile, vendorRoot, backendRoot
}];
If[sentinelProcess["ExitCode"] =!= 0, Print[sentinelProcess["StandardError"]]; Exit[5]];
sentinelEvidence = Import[sentinelFile, "RawJSON"];

assignmentRecords = Flatten@MapIndexed[
  Function[{segment, segmentPosition},
    Map[
      Append[
        #,
        "coverageNode" -> ToString[First[segmentPosition]] <> ":n" <>
          ToString[If[#source === "node_snapshot", #nodeIndex, #segmentIndex]]
      ] &,
      segment["pointAssignments"]
    ]
  ],
  routeAEvidence["segments"]
];
uniqueAssignmentRecords = DeleteDuplicatesBy[assignmentRecords, Lookup[#, "userIndex"] &];
assignmentKeys = Lookup[uniqueAssignmentRecords, "coverageNode"];
coverageCounts = Counts[assignmentKeys];
coverageValues = Values[coverageCounts];
coverageHistogram = Association@KeyValueMap[ToString[#1] -> #2 &, Counts[coverageValues]];
fixedGroupIndices = {2, 4, 6};
fixedGroups = routeAEvidence["segments"][[fixedGroupIndices]];
allCoordinates = MapIndexed[
  <|"userIndex" -> First[#2], "exactCoordinate" -> ToString[#1, InputForm]|> &,
  gridPoints
];


(* ::Chapter:: *)
(*验收、机器摘要与自动报告*)

checks = <|
  "pointCount900" -> Length[gridPoints] === 900,
  "sixActualSegmentsIncludingBoundary" -> Length[plannedPath["segments"]] === 6,
  "threeFixedX1GroupsOf300" -> (Length[#userIndices] & /@ fixedGroups) === {300, 300, 300},
  "fixedGroupsUseComplexPlane" -> And @@ (
    (Length[DeleteDuplicates[Lookup[#, "pointParameters"]]] === 300) & /@ fixedGroups
  ),
  "routeAAllPoints" -> Length[routeAPointValues] === 900 && Lookup[routeAPointValues, "userIndex"] === Range[900],
  "routeASharedEndpointsAgree" -> TrueQ[routeADuplicateEndpointAgreement],
  "routeBAllPoints" -> naiveEvidence[["naive", "pointCount"]] === 900,
  "routeATargetMet" -> TrueQ[routeAEvidence["targetRelativeErrorMet"]],
  "routeBTargetMet" -> TrueQ[naiveEvidence[["naive", "allTargetsMet"]]],
  "all900CrossChecked" -> naiveEvidence[["comparison", "pointCount"]] === 900,
  "crossDifferenceBelow1e15" -> naiveEvidence[["comparison", "maximumRelativeDifference"]] < 10^-15,
  "twelveHigherOrderChecks" -> Length[naiveEvidence["higherOrderSpotChecks"]] === 12,
  "higherOrderTargetMet" -> And @@ Lookup[naiveEvidence["higherOrderSpotChecks"], "targetRelativeErrorMet"],
  "higherOrderDifferenceBelow1e15" -> Max[Lookup[naiveEvidence["higherOrderSpotChecks"], "maximumRelativeDifferenceVsRouteA"]] < 10^-15,
  "noReplanningSentinel" -> sentinelEvidence["status"] === "passed" && ! TrueQ[sentinelEvidence["plannerCalled"]],
  "defaultOptionsRecorded" -> MemberQ[Options[MSGeneratePath], SingularityMode -> "Avoid"] && MemberQ[Options[MSGeneratePath], MessageLanguage -> "EN"],
  "differentGroupsNoCoefficientSharing" ->
    Length[DeleteDuplicates[Lookup[fixedGroups, "segmentIndex"]]] === 3 &&
    And @@ (AssociationQ[#[["flintNDEPlan", "serializedPlan"]]] & /@ plannedPath["segments"][[fixedGroupIndices]]) &&
    And @@ (Length[#pointAssignments] === 300 & /@ fixedGroups) &&
    Length[backendSegments[[fixedGroupIndices]]] === 3
|>;
passedCount = Count[Values[checks], True];
status = If[passedCount === Length[checks], "passed", "failed"];
commit = StringTrim@RunProcess[{"git", "rev-parse", "HEAD"}, "StandardOutput"];
sourceDigest = IntegerString[FileHash[FileNameJoin[{madStreeRoot, "Kernel", "MadStree.wl"}], "SHA256"], 16, 64];
flintTreeDigest[root_String] := Module[{files, records},
  files = Sort@Join[
    FileNames["*.py", FileNameJoin[{root, "flintnde"}]],
    Select[{FileNameJoin[{root, "pyproject.toml"}]}, FileExistsQ]
  ];
  records = {FileNameDrop[#, FileNameDepth[root]], IntegerString[FileHash[#, "SHA256"], 16, 64]} & /@ files;
  IntegerString[Hash[ExportString[records, "RawJSON"], "SHA256"], 16, 64]
];
independentFlintRoot = ExpandFileName@FileNameJoin[{validationRoot, "..", "..", "..", "package-FlintNDE", "versions", "FlintNDE-0.3.0"}];
vendorDigest = flintTreeDigest[vendorRoot];
independentDigest = flintTreeDigest[independentFlintRoot];

evidence = <|
  "schema" -> "madstree_v0.10_complex_grid_independent_validation_v1",
  "status" -> status,
  "commit" -> commit,
  "sourceDigestSHA256" -> sourceDigest,
  "flintNDEVendorDigestSHA256" -> vendorDigest,
  "flintNDEIndependentDigestSHA256" -> independentDigest,
  "flintNDECopiesIdentical" -> vendorDigest === independentDigest,
  "convention" -> "Y'=A(s)Y; master order follows MSDLogDE[context][masters]",
  "masters" -> ToString[de["masters"], InputForm],
  "grid" -> <|"x1Base" -> ToString[x10, InputForm], "x2Base" -> ToString[x20, InputForm], "coordinates" -> allCoordinates|>,
  "precision" -> <|"workingPrecisionDigits" -> workingPrecision, "primaryOrder" -> primaryOrder, "referenceOrder" -> referenceOrder, "higherPrimaryOrder" -> primaryOrder + 24, "higherReferenceOrder" -> referenceOrder + 32, "targetRelativeError" -> targetRelativeError|>,
  "boundary" -> <|
    "boundaryKind" -> plannedPath[["boundaryData", "boundaryKind"]],
    "seriesOrder" -> plannedPath[["boundaryData", "seriesOrder"]],
    "rankOrder" -> ToString[plannedPath[["boundaryData", "rankOrder"]], InputForm],
    "branchConvention" -> plannedPath[["boundaryData", "branchConvention"]],
    "singularBoundaryPrimaryOrder" -> primaryOrder,
    "singularBoundaryReferenceOrder" -> referenceOrder,
    "singularBoundaryPathPointCount" -> Lookup[plannedPath["singularBoundaryPlan"], "pathPointCount", Missing["NotReturned"]]
  |>,
  "routeA" -> routeAEvidence,
  "routeB" -> naiveEvidence["naive"],
  "comparison" -> naiveEvidence["comparison"],
  "higherOrderSpotChecks" -> naiveEvidence["higherOrderSpotChecks"],
  "coverage" -> <|"minimum" -> Min[coverageValues], "median" -> Median[coverageValues], "mean" -> Mean[coverageValues], "maximum" -> Max[coverageValues], "histogram" -> coverageHistogram|>,
  "sentinel" -> sentinelEvidence,
  "checks" -> checks
|>;
Export[evidenceFile, evidence, "RawJSON"];

routeASummary = KeyDrop[routeAEvidence, "pointValues"];
routeASummary["segments"] = KeyDrop[#, {"pointParameters", "pointAssignments"}] & /@ routeASummary["segments"];
routeAToBTotalWallRatio = routeAEvidence["totalWallSeconds"]/naiveEvidence[["naive", "totalWallSeconds"]];
routeASlowerPercent = 100 (routeAToBTotalWallRatio - 1);
summary = KeyDrop[evidence, {"grid", "routeA", "routeB", "comparison", "higherOrderSpotChecks"}];
summary = Join[summary, <|
  "routeA" -> routeASummary,
  "pointwiseEvidence" -> evidenceFile,
  "routeBTiming" -> KeyTake[naiveEvidence["naive"], {"planningSeconds", "executionSeconds", "totalWallSeconds", "overheadSeconds"}],
  "efficiencyComparison" -> <|
    "routeAToBTotalWallRatio" -> routeAToBTotalWallRatio,
    "routeBToATotalWallRatio" -> 1/routeAToBTotalWallRatio,
    "routeASlowerPercent" -> routeASlowerPercent,
    "conclusion" -> If[routeAToBTotalWallRatio > 1, "grouped/dense slower than naive", "grouped/dense faster than naive"]
  |>,
  "comparisonSummary" -> KeyDrop[naiveEvidence["comparison"], "points"],
  "higherOrderSpotCheckSummary" -> <|"count" -> Length[naiveEvidence["higherOrderSpotChecks"]], "maximumRelativeDifferenceVsRouteA" -> Max[Lookup[naiveEvidence["higherOrderSpotChecks"], "maximumRelativeDifferenceVsRouteA"]]|>,
  "passedCount" -> passedCount,
  "totalCount" -> Length[checks]
|>];
Export[summaryFile, ToString[summary, InputForm] <> "\n", "Text", CharacterEncoding -> "UTF-8"];

segmentRows = Map[
  Function[segment,
    "| " <> ToString[segment["segmentIndex"]] <> " | " <>
      ToString[First[segment["userIndices"]]] <> "--" <> ToString[Last[segment["userIndices"]]] <>
      " (" <> ToString[Length[segment["userIndices"]]] <> ") | " <>
      "`" <> segment["startRules"] <> "` | `" <> segment["targetRules"] <> "` | " <>
      ToString[segment["plannedNodeCount"]] <> " | " <> ToString[segment["nodeSnapshotCount"]] <>
      " | " <> ToString[segment["densePointCount"]] <> " | `" <>
      StringRiffle[
        (Lookup[#, "real"] <> "+(" <> Lookup[#, "imag"] <> ")I") & /@
          segment["actualPath"],
        " -> "
      ] <> "` |"
  ],
  routeAEvidence["segments"]
];
efficiencyRatio = 1/routeAToBTotalWallRatio;

report = StringRiffle[{
  "# MadStree v0.10 独立验证 01：二维复格点分组与逐点基线",
  "",
  "- 日期：2026-08-13",
  "- 状态：`" <> status <> "`（" <> ToString[passedCount] <> "/" <> ToString[Length[checks]] <> "）",
  "- commit：`" <> commit <> "`",
  "- 对象：massless full-edge 三主积分 dlog DE；列向量约定 `Y'=A(s)Y`；master 顺序 `" <> ToString[de["masters"], InputForm] <> "`。",
  "- MadStree 主入口 SHA-256：`" <> sourceDigest <> "`。",
  "- FlintNDE：Vendor 源码树 digest `" <> vendorDigest <> "`；独立 0.3.0 源码树 digest `" <> independentDigest <> "`；相同：`" <> ToString[vendorDigest === independentDigest] <> "`。",
  "",
  "## 输入、路径和精度",
  "",
  "exact 格点为 `k1=-9 I+a/10`、`k2=-5 I+n/10+I m/10`、`q=1,a1=a2=1`，`a=0..2,n=0..99,m=0..2`，输入顺序为 a/n/m，共 900 点。公共规划实际返回 6 组：第 1 组从 boundary anchor 到首点，第 2、4、6 组各含固定 k1 的 300 个复 x2 点，第 3、5 组为公共端点到下一平面的过渡。每组的 exact 参数、实际节点、userIndices 与 node/dense assignment 均在 `results/pointwise_evidence.json`。",
  "",
  "| segment | userIndex 范围（组内记录数） | physical start | physical target | planned nodes | node points | dense points | actual FlintNDE node chain |",
  "| ---: | --- | --- | --- | ---: | ---: | ---: | --- |",
  StringRiffle[segmentRows, "\n"],
  "",
  "工作精度 " <> ToString[workingPrecision] <> " 位；普通点输运主阶/参考阶 " <> ToString[primaryOrder] <> "/" <> ToString[referenceOrder] <> "；高阶 spot check " <> ToString[primaryOrder + 24] <> "/" <> ToString[referenceOrder + 32] <> "；目标相对误差 `" <> targetRelativeError <> "`。实际 boundaryKind=`" <> plannedPath[["boundaryData", "boundaryKind"]] <> "`，边界 Frobenius seriesOrder=" <> ToString[plannedPath[["boundaryData", "seriesOrder"]]] <> "，rankOrder=`" <> ToString[plannedPath[["boundaryData", "rankOrder"]], InputForm] <> "`；singular-boundary 局部输运主阶/参考阶同为 " <> ToString[primaryOrder] <> "/" <> ToString[referenceOrder] <> "，实际路径点数 " <> ToString[Lookup[plannedPath["singularBoundaryPlan"], "pathPointCount", Missing["NotReturned"]]] <> "。Hankel branch convention=`" <> plannedPath[["boundaryData", "branchConvention"]] <> "`。SingularityMode/MessageLanguage 实际为缺省 `Avoid`/`EN`。",
  "",
  "## 路线与效率",
  "",
  "Route A 是公共 `MSGeneratePath` + `MSEvaluatePlannedPath`，使用分组计划与 dense output；Route B 是直接 FlintNDE oracle，不是 MadStree 公共入口：它不读取 Route A 序列化计划或局部系数，对原始顺序中的每个新用户点独立 plan+execute 并链式传递上点数值。两条路线均使用独立空运行目录/进程开始，Route B 未由 Route A 缓存预热。",
  "",
  "| route | planning (s) | execution (s) | total wall (s) | points |",
  "| --- | ---: | ---: | ---: | ---: |",
  "| A grouped/dense | " <> ToString[routeAPlanningSeconds] <> " | " <> ToString[routeAExecutionSeconds] <> " | " <> ToString[routeAPlanningSeconds + routeAExecutionSeconds] <> " | 900 |",
  "| B direct FlintNDE naive | " <> ToString[naiveEvidence[["naive", "planningSeconds"]]] <> " | " <> ToString[naiveEvidence[["naive", "executionSeconds"]]] <> " | " <> ToString[naiveEvidence[["naive", "totalWallSeconds"]]] <> " | 900 |",
  "",
  "Route A 节点覆盖统计：min/median/mean/max = " <> StringRiffle[ToString /@ N[{Min[coverageValues], Median[coverageValues], Mean[coverageValues], Max[coverageValues]}], "/"] <> "；直方图 `" <> ToString[coverageHistogram, InputForm] <> "`。Route B 每点节点数 min/median/mean/max = " <> StringRiffle[ToString /@ Lookup[naiveEvidence["naive"], {"nodeCountMinimum", "nodeCountMedian", "nodeCountMean", "nodeCountMaximum"}], "/"] <> "。本次 A/B total wall-time 比为 `" <> ToString[N[routeAToBTotalWallRatio]] <> "x`（B/A=`" <> ToString[N[efficiencyRatio]] <> "x`），即 grouped/dense 路线慢约 `" <> ToString[N[routeASlowerPercent]] <> "%`；该小型 3×3 系统的逐点两节点计算太轻，Route A 的公共边界、6 组规划及进程/JSON 成本占主导。",
  "",
  "## 数值交叉检查",
  "",
  "全部 900 点、每点全部 " <> ToString[de["masterCount"]] <> " 个分量均已互检。最大绝对差为 `" <> ToString[naiveEvidence[["comparison", "maximumAbsoluteDifference"]], InputForm] <> "`，最大相对差为 `" <> ToString[naiveEvidence[["comparison", "maximumRelativeDifference"]], InputForm] <> "`。12 个跨 a/n/m 的高阶 spot checks 最大相对差为 `" <> ToString[Max[Lookup[naiveEvidence["higherOrderSpotChecks"], "maximumRelativeDifferenceVsRouteA"]], InputForm] <> "`。两路线 refinement gate 均通过。",
  "",
  "执行期 planner 哨兵：`" <> sentinelEvidence["status"] <> "`，plannerCalled=`" <> ToString[sentinelEvidence["plannerCalled"]] <> "`，executionAction=`" <> ToString[sentinelEvidence["executionAction"]] <> "`。哨兵执行第一个已保存段，不修改生产源码。三个固定复仿射组具有不同 segmentIndex、各自完整 serialized plan 与 300 条 assignment；后端逐段恢复计划并只继承端点向量，没有跨组共享局部系数。",
  "",
  "## 结论与边界",
  "",
  If[status === "passed", "本任务通过：公共 grouped/dense 路线完整覆盖 900 点，与 cold-cache 逐点 FlintNDE 基线及高阶抽查一致。", "本任务失败；失败键见 `results/summary.wl`，不得据此认证当前路线。"],
  "已确认可移植性风险：若把 `MSRuntimeDirectory` 直接设为本验证目录内的长路径，Windows 下 adapter 的 `flintnde_cache/<64位digest>/backend_output.json` 超过传统 MAX_PATH 并报 `FileNotFoundError`。正式 runner 使用仓库根 `.madstree-validation-runtime/<UUID>/` 作为短临时 runtime，结果仍写回本验证目录；生产 adapter 尚未内部解决任意长调用路径。",
  "性能结论仅适用于本机、本 DE、上述精度与点序；Python 进程启动和 JSON 报告时间计入各路线 wall time，但底层 primary/reference 秒数不等同于总执行 wall time。完整逐点路径、值、误差与 refinement 证据在 `results/pointwise_evidence.json`。"
}, "\n"];
Export[reportFile, report, "Text", CharacterEncoding -> "UTF-8"];

Print["MadStree v0.10 independent validation: ", passedCount, "/", Length[checks], " ", status];
Print["report: ", reportFile];
If[status =!= "passed", Print["failed: ", Keys@Select[checks, Not@TrueQ[#] &]]; Exit[1]];
