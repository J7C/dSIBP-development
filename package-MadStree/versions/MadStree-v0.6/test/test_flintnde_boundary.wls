(* ::Package:: *)

(***
文件：test_flintnde_boundary.wls
用途：验证单顶点零 Hankel family 的自动 Gamma 边界、相对 FlintNDE 路径和目标点解析值。
运行：wolframscript -file package-MadStree/test/test_flintnde_boundary.wls
***)

(* ::Chapter:: *)
(*加载与单顶点输入*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]];
packageRoot = msTestLoadKernel[];

initializationMessageFreeQ = True;
context = Check[
  MSInitTree[<|
    "vertices" -> {<|"id" -> v, "energy" -> k0, "timePower" -> a, "phaseSign" -> 1|>},
    "lines" -> {}
  |>],
  initializationMessageFreeQ = False;
  $Failed
];
targetRules = {k0 -> 3, a -> 1/3};


(* ::Chapter:: *)
(*自动边界与 FlintNDE 输运*)

configuration = MSFlintNDEConfiguration[];
boundary = MSBoundaryData[
  context,
  targetRules,
  BoundaryScale -> 8,
  WorkingPrecision -> 60
];
result = MSEvaluateTree[
  context,
  targetRules,
  PythonExecutable -> msTestPythonExecutable[],
  BoundaryScale -> 8,
  WorkingPrecision -> 60,
  TransportOrder -> 96,
  ReferenceTransportOrder -> 128,
  TargetRelativeError -> "1e-28"
];


(* ::Chapter:: *)
(*解析比较与汇总*)

expected = N[Gamma[4/3]/(I 3)^(4/3), 50];
relativeDifference = Abs[(First[result["values"]] - expected)/expected];

checks = <|
  "initializationMessageFree" -> initializationMessageFreeQ,
  "zeroWidthSectorKey" -> context =!= $Failed && context["sectorKeySchema", "width"] === 0 &&
    context["sectors"][[1, "sectorKey"]] === "" && StringQ[context["sectors"][[1, "sectorKey"]]],
  "configuration" -> TrueQ[configuration["availableQ"]],
  "boundaryGenerated" -> Lookup[boundary, "status", None] === "generated",
  "boundaryMethod" -> Lookup[boundary, "method", None] === "2411VertexFrobeniusSeries" &&
    Lookup[boundary, "directIntegrationFallbackQ", True] === False,
  "transportComputed" -> Lookup[result, "status", None] === "computed",
  "masterDigest" -> Lookup[result, "masterDigest", None] === context["masterDigest"],
  "analyticAgreement" -> TrueQ[relativeDifference < 10^-26],
  "refinement" -> TrueQ[result["flintNDE", "targetRelativeErrorMet"]]
|>;

msTestSummary[checks, "MadStree FlintNDE boundary"];
Print["relativeDifference: ", InputForm[relativeDifference]];

If[! And @@ Values[checks],
  Print["boundary: ", InputForm[boundary]];
  Print["result: ", InputForm[result]];
  Exit[1]
];
