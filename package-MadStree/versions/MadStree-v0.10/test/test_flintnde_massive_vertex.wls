(* ::Package:: *)

(***
File: test_flintnde_massive_vertex.wls
Purpose: Verifies the 2411 infinity boundary and FlintNDE transport of a single-massive external Hankel family under the positive nu prefactor.
Run: wolframscript -file package-MadStree/test/test_flintnde_massive_vertex.wls
***)

(* ::Chapter:: *)
(* Loading and single-vertex family *)

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
(* Infinity boundary and transport *)

directAtTarget = MSBoundaryData[
  context,
  targetRules,
  BoundaryScale -> 4,
  WorkingPrecision -> 32
];

path = MSGeneratePath[
  context,
  {targetRules},
  PythonExecutable -> msTestPythonExecutable[],
  BoundaryScale -> 4,
  WorkingPrecision -> 32
];
transported = MSEvaluatePlannedPath[
  context,
  path,
  PythonExecutable -> msTestPythonExecutable[],
  WorkingPrecision -> 32,
  TransportOrder -> 72,
  ReferenceTransportOrder -> 96,
  TargetRelativeError -> "1e-16"
];


(* ::Chapter:: *)
(* Boundary provenance and transport checks *)

(* The retired single-vertex hypergeometric series remains covered by its
   symbolic oracle tests; this transport test exercises only the public path. *)


checks = <|
  "asymptoticBoundary" -> Lookup[directAtTarget, "method", None] === "2411GenericSectorLeadingSeries",
  "plannedPath" -> MSPlannedPathQ[path],
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
  Print["path: ", InputForm[KeyDrop[path, {"segments", "boundaryData"}]]];
  Print["transported: ", InputForm[transported]];
  Exit[1]
];
