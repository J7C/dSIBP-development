(* ::Package:: *)

(***
文件：test_flintnde_massive_vertex.wls
用途：验证正 nu prefactor 下单 massive external Hankel family 的 2411 无穷远边界与 FlintNDE 输运。
运行：wolframscript -file package-MadStree/test/test_flintnde_massive_vertex.wls
***)

(* ::Chapter:: *)
(*加载与单顶点 family*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]];
packageRoot = msTestLoadKernel[];

context = MSInitTree[<|
  "vertices" -> {<|"id" -> v, "energy" -> k0, "timePower" -> a, "phaseSign" -> 1|>},
  "lines" -> {
    <|"id" -> h1, "type" -> "massiveExternal", "endpoints" -> {v},
      "momentum" -> q, "nu" -> nu, "skType" -> "+"|>
  }
|>];
targetRules = {k0 -> -3 I, q -> 1, nu -> 1/3, a -> 2};


(* ::Chapter:: *)
(*无穷远边界与输运*)

directAtTarget = MSBoundaryData[
  context,
  targetRules,
  BoundaryScale -> 4,
  WorkingPrecision -> 32
];

transported = MSEvaluateTree[
  context,
  targetRules,
  PythonExecutable -> msTestPythonExecutable[],
  BoundaryScale -> 4,
  WorkingPrecision -> 32,
  TransportOrder -> 72,
  ReferenceTransportOrder -> 96,
  TargetRelativeError -> "1e-16"
];


(* ::Chapter:: *)
(*边界来源与输运检查*)

checks = <|
  "asymptoticBoundary" -> Lookup[directAtTarget, "method", None] === "2411VertexFrobeniusSeries" &&
    Lookup[directAtTarget, "directIntegrationFallbackQ", True] === False,
  "twoMasters" -> Length[MSMasterIntegrals[context]] === 2,
  "transport" -> Lookup[transported, "status", None] === "computed",
  "sameDigest" -> Lookup[transported, "masterDigest", None] === context["masterDigest"],
  "positiveNu" -> context["convention", "nuConvention"] === "Positive",
  "branch" -> context["lines"][[1, "hankelBranches"]] === {2},
  "refinement" -> TrueQ[transported["flintNDE", "targetRelativeErrorMet"]]
|>;

msTestSummary[checks, "MadStree massive boundary"];

If[! And @@ Values[checks],
  Print["directAtTarget: ", InputForm[directAtTarget]];
  Print["transported: ", InputForm[transported]];
  Exit[1]
];
