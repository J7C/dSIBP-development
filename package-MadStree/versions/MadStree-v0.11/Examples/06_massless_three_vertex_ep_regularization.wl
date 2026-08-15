(* ::Package:: *)

(***
文件：06_massless_three_vertex_ep_regularization.wl
用途：演示真实无质量三顶点树图的共同时间幂解析正规化 a1=a2=a3=1+ep；
      用户只指定需要返回到 ep^0，程序在数值 NDE 前从符号边界与 dlog DE 认证最低幂，
      再选择 exact ep 点并重构 Laurent 系数。
并行：ParallelTaskCount 缺省为 12；生产与独立验证任务都由有界进程池自动调度，
      任务多于并行上限时自动续交，不需要用户提供或手动分批 ep 取值。批量基准可在
      wolframscript 命令末尾传入一个正整数覆盖本例请求值，普通用户直接修改参数行即可。
输出：运行产物由缺省目录合同写入本 example 目录下 results_temp，不写入程序包源码模块目录。
***)

(* ::Chapter:: *)
(*程序包加载与用户参数*)

exampleDirectory = DirectoryName[$InputFileName];
packageRoot = DirectoryName[exampleDirectory];
AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
Needs["MadStree`"];

(* 用户可修改：缺省并行上限是 12；命令行末尾正整数只用于重复基准。 *)
epParallelOverrideText = If[
  ListQ[$ScriptCommandLine] && Length[$ScriptCommandLine] >= 2,
  Last[$ScriptCommandLine],
  ""
];
epParallelOverrideQ = StringQ[epParallelOverrideText] &&
  StringMatchQ[epParallelOverrideText, DigitCharacter ..] &&
  ToExpression[epParallelOverrideText] >= 1;
epParallelTaskCount = If[
  epParallelOverrideQ,
  ToExpression[epParallelOverrideText],
  12
];
maximumEpPower = 0;
epGoalDigits = 12;


(* ::Chapter:: *)
(*无质量三顶点 family 与共同 ep 正规化*)

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
epPointTemplate = {{
  k1 -> -9 I, k2 -> -3 I, k3 -> -5 I,
  q12 -> 1, q23 -> 2,
  a1 -> 1 + ep, a2 -> 1 + ep, a3 -> 1 + ep
}};


(* ::Chapter:: *)
(*自适应正规化级数重构*)

{epSeriesWallSeconds, epSeries} = AbsoluteTiming[MSReconstructEpSeries[
  context,
  ep,
  epPointTemplate,
  MaximumEpPower -> maximumEpPower,
  EpGoalDigits -> epGoalDigits,
  ParallelTaskCount -> epParallelTaskCount,
  FlintNDEPathPlanning -> True,
  BoundaryScale -> 4,
  BoundarySeriesOrder -> 24,
  RankOrder -> {v1, v2, v3},
  MessageLanguage -> "CN",
  MSRuntimeDirectory -> Automatic
]];

If[Head[epSeries] === Failure,
  Print["Example failed at MSReconstructEpSeries: ", InputForm[epSeries]];
  Exit[1]
];


(* ::Chapter:: *)
(*结果与验收*)

checks = <|
  "threeVertices" -> Length[treeSpec["vertices"]] === 3,
  "twoMasslessPropagators" -> Length[treeSpec["lines"]] === 2 &&
    AllTrue[treeSpec["lines"], #["type"] === "masslessFull" &],
  "sharedEpRegularization" ->
    ({a1, a2, a3} /. First[epPointTemplate]) === ConstantArray[1 + ep, 3],
  "defaultParallelCountDocumented" ->
    MemberQ[Options[MSReconstructEpSeries], ParallelTaskCount -> 12] &&
    MemberQ[Options[MSReconstructEpSeries], MaximumEpPower -> 0],
  "requestedFinitePart" -> maximumEpPower === 0 &&
    epSeries["maximumPower"] === 0 && KeyExistsQ[epSeries["coefficients"], 0],
  "symbolicSupportCertifiedBeforeNDE" ->
    epSeries["laurentSupportCertificate", "status"] === "certified" &&
    epSeries["laurentSupportCertificate", "method"] ===
      "symbolicBoundaryAndRegularDLogValuation",
  "automaticLeadingPowerZero" -> epSeries["leadingPower"] === 0 &&
    epSeries["laurentSupportCertificate", "leadingPower"] === 0,
  "regularDEAndAnalyticBoundary" ->
    TrueQ[epSeries["laurentSupportCertificate",
      "differentialEquationRegularAtEpZeroQ"]] &&
    TrueQ[epSeries["laurentSupportCertificate",
      "boundaryFiniteLaurentAtEpZeroQ"]] &&
    TrueQ[epSeries["laurentSupportCertificate",
      "boundaryDefinitionAnalyticAtEpZeroQ"]],
  "automaticProductionGrid" -> Length[epSeries["productionEpValues"]] >=
    epSeries["maximumPower"] - epSeries["leadingPower"] + 1,
  "independentValidationGrid" -> Length[epSeries["validationEpValues"]] >= 1 &&
    Intersection[epSeries["productionEpValues"], epSeries["validationEpValues"]] === {},
  "validationPassed" -> AllTrue[epSeries["validation"], TrueQ[#["passed"]] &],
  "effectiveParallelCount" ->
    epSeries["parallelTaskCountEffective"] === Min[
      epParallelTaskCount,
      Length[epSeries["productionEpValues"]] + Length[epSeries["validationEpValues"]]
    ],
  "allTargetsMet" -> AllTrue[
    Lookup[epSeries["pointEvaluations"], "evaluation"],
    TrueQ[#["flintNDE", "targetRelativeErrorMet"]] &
  ]
|>;

Print["symbolically certified ep powers: ", epSeries["leadingPower"], " through ",
  epSeries["maximumPower"]];
Print["Laurent support certificate: ",
  InputForm[KeyDrop[epSeries["laurentSupportCertificate"], "boundaryRecords"]]];
Print["automatic production ep values: ", epSeries["productionEpValues"]];
Print["independent validation ep values: ", epSeries["validationEpValues"]];
Print["parallel requested/effective: ",
  epSeries["parallelTaskCountRequested"], "/", epSeries["parallelTaskCountEffective"]];
Print["adaptive reconstruction wall seconds: ", epSeriesWallSeconds];
Print["pole coefficients: ", InputForm[epSeries["poleCoefficients"]]];
Print["finite part: ", InputForm[epSeries["finitePart"]]];
Print["maximum validation relative residual: ",
  epSeries["maximumValidationRelativeResidual"]];
Print["checks: ", Count[Values[checks], True], "/", Length[checks]];

If[! And @@ Values[checks],
  Print["failed checks: ", Keys@Select[checks, Not@TrueQ[#] &]];
  Exit[1]
];
Print["Example PASSED: adaptive shared-ep Laurent reconstruction completed."];
