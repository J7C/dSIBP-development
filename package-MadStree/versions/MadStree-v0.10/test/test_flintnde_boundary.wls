(* ::Package:: *)

(***
File: test_flintnde_boundary.wls
Purpose: Verifies the automatic Gamma boundary of a single-vertex zero-Hankel family, the relative FlintNDE path and the analytic values at the target point.
Run: wolframscript -file package-MadStree/test/test_flintnde_boundary.wls
***)

(* ::Chapter:: *)
(* Loading and single-vertex input *)

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
(* Automatic boundary and FlintNDE transport *)

configuration = MSFlintNDEConfiguration[];
boundary = MSBoundaryData[
  context,
  targetRules,
  BoundaryScale -> 8,
  WorkingPrecision -> 60
];
path = MSGeneratePath[
  context,
  {targetRules},
  PythonExecutable -> msTestPythonExecutable[],
  BoundaryScale -> 8,
  WorkingPrecision -> 60
];
result = MSEvaluatePlannedPath[
  context,
  path,
  PythonExecutable -> msTestPythonExecutable[],
  WorkingPrecision -> 60,
  TransportOrder -> 96,
  ReferenceTransportOrder -> 128,
  TargetRelativeError -> "1e-28",
  MessageLanguage -> "CN"
];


(* ::Chapter:: *)
(* Analytic comparison and summary *)

expected = N[Gamma[4/3]/(I 3)^(4/3), 50];
relativeDifference = Abs[(First[result["values"]] - expected)/expected];

(* The path itself must contain the singular-boundary plan. Execution may only
   restore this plan; it must not call the planner again. *)


checks = <|
  "initializationMessageFree" -> initializationMessageFreeQ,
  "zeroWidthSectorKey" -> context =!= $Failed && context["sectorKeySchema", "width"] === 0 &&
    context["sectors"][[1, "sectorKey"]] === "" && StringQ[context["sectors"][[1, "sectorKey"]]],
  "configuration" -> TrueQ[configuration["availableQ"]],
  "boundaryGenerated" -> Lookup[boundary, "status", None] === "generated",
  "boundaryMethod" -> Lookup[boundary, "method", None] === "2411GenericSectorLeadingSeries",
  "plannedPath" -> MSPlannedPathQ[path],
  "singularBoundaryPlanned" ->
    Lookup[path["singularBoundaryPlan"], "planningAction", None] ===
      "plan_singular_boundary_without_execution",
  "transportComputed" -> Lookup[result, "status", None] === "computed",
  "singularBoundaryExecutedWithoutReplanning" ->
    Lookup[result["flintNDE", "singularBoundary"], "executionAction", None] ===
      "execute_existing_singular_boundary_plan_without_replanning" &&
    Lookup[result["flintNDE", "singularBoundary"], "messageLanguage", None] === "CN",
  "masterDigest" -> Lookup[result, "masterDigest", None] === context["masterDigest"],
  "analyticAgreement" -> TrueQ[relativeDifference < 10^-26],
  "refinement" -> TrueQ[result["flintNDE", "targetRelativeErrorMet"]]
|>;

msTestSummary[checks, "MadStree FlintNDE boundary"];
Print["relativeDifference: ", InputForm[relativeDifference]];

If[! And @@ Values[checks],
  Print["boundary: ", InputForm[boundary]];
  Print["path: ", InputForm[KeyDrop[path, {"segments", "boundaryData"}]]];
  Print["result: ", InputForm[result]];
  Exit[1]
];
