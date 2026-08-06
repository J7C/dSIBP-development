(* ::Package:: *)

(***
文件：test_flintnde_vertex_family.wls
用途：验证单顶点专用输入与等价 topology 输入复用同一自动边界、dlog DE 与 FlintNDE 输运。
运行：wolframscript -file package-MadStree/test/test_flintnde_vertex_family.wls
***)

(* ::Chapter:: *)
(*加载与函数族*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]];
packageRoot = msTestLoadKernel[];

context = MSInitVertexFamily[<|
  "ki" -> {k0, q},
  "nui" -> {a, nu},
  "hankelBranches" -> {2}
|>];
topologyContext = MSInitTree[<|
  "vertices" -> {
    <|"id" -> v, "energy" -> k0, "timePower" -> a, "phaseSign" -> 1|>
  },
  "lines" -> {
    <|"id" -> h1, "type" -> "massiveExternal", "endpoints" -> {v},
      "momentum" -> q, "nu" -> nu, "skType" -> "+", "hankelBranches" -> {2}|>
  }
|>];
targetRules = {k0 -> -3 I, q -> 1, nu -> 1/2, a -> 2};


(* ::Chapter:: *)
(*两种初始化接口的边界与输运*)

vertexBoundary = MSBoundaryData[
  context,
  targetRules,
  BoundaryScale -> 4,
  WorkingPrecision -> 32
];

topologyBoundary = MSBoundaryData[
  topologyContext,
  targetRules,
  BoundaryScale -> 4,
  WorkingPrecision -> 32
];

vertexResult = MSEvaluateVertexFamily[
  context,
  targetRules,
  PythonExecutable -> msTestPythonExecutable[],
  BoundaryScale -> 4,
  WorkingPrecision -> 32,
  TransportOrder -> 64,
  ReferenceTransportOrder -> 88,
  TargetRelativeError -> "1e-16"
];

topologyResult = MSEvaluateTree[
  topologyContext,
  targetRules,
  PythonExecutable -> msTestPythonExecutable[],
  BoundaryScale -> 4,
  WorkingPrecision -> 32,
  TransportOrder -> 64,
  ReferenceTransportOrder -> 88,
  TargetRelativeError -> "1e-16"
];


(* ::Chapter:: *)
(*比较*)

relativeDifferences = MapThread[
  Abs[#1 - #2]/Max[Abs[#2], 10^-25] &,
  {vertexResult["values"], topologyResult["values"]}
];
checks = <|
  "vertexContext" -> Lookup[context, "contextKind", None] === "vertexFamily",
  "bothBoundariesGenerated" -> And @@ (
    Lookup[#, "status", None] === "generated" & /@ {vertexBoundary, topologyBoundary}
  ),
  "twoMasters" -> Length[MSMasterIntegrals[context]] === 2 &&
    Length[MSMasterIntegrals[topologyContext]] === 2,
  "dlogEquivalent" -> MSDLogDE[context]["connection"] === MSDLogDE[topologyContext]["connection"],
  "bothTransportsComputed" -> And @@ (
    Lookup[#, "status", None] === "computed" & /@ {vertexResult, topologyResult}
  ),
  "numericalEquivalence" -> TrueQ[Max[relativeDifferences] < 10^-24],
  "refinement" -> And @@ (
    TrueQ[#1["flintNDE", "targetRelativeErrorMet"]] & /@ {vertexResult, topologyResult}
  )
|>;

msTestSummary[checks, "MadStree vertex-family NDE"];
Print["relativeDifferences: ", InputForm[relativeDifferences]];

If[! And @@ Values[checks],
  Print["vertexBoundary: ", InputForm[vertexBoundary]];
  Print["topologyBoundary: ", InputForm[topologyBoundary]];
  Print["vertexResult: ", InputForm[vertexResult]];
  Print["topologyResult: ", InputForm[topologyResult]];
  Exit[1]
];
