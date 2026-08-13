(* ::Package:: *)

(***
File: test_flintnde_polyline_planning.wls
Purpose: End-to-end test of the v0.10 two-phase polyline workflow on the massless full edge. Covers complete plan serialization, execute-only transport, adaptive precision limits, EN/CN comments, default singularity avoidance, explicit singularity jumps, singular-locus removal, and leading-order refusal records.
Run: wolframscript -file package-MadStree/versions/MadStree-v0.10/test/test_flintnde_polyline_planning.wls
***)

(* ::Chapter:: *)
(* Loading, graph input and closed form *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]];
packageRoot = msTestLoadKernel[];

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


(* Both ordered time integrals reduce to the same Gauss hypergeometric closed form; it is the analytic reference at every non-singular point reached by the polyline. *)
orderedIntegral[a_, b_, lambdaA_, lambdaB_] := Module[{weight = a + b + 2},
  Gamma[weight] lambdaB^(-weight) Hypergeometric2F1[
    weight, a + 1, a + 2, -lambdaA/lambdaB
  ]/(a + 1)
];


definitionVector[rules_List] := N[
  {
    orderedIntegral[1, 1, I k1 - I q, I k2 + I q] +
      orderedIntegral[1, 1, I k2 - I q, I k1 + I q],
    -orderedIntegral[1, 1, I k1 - I q, I k2 + I q] +
      orderedIntegral[1, 1, I k2 - I q, I k1 + I q],
    Gamma[4] (I (k1 + k2))^-4
  } /. rules,
  40
];


relativeDifference[computed_List, reference_List] := Max@MapThread[
  Abs[#1 - #2]/Max[Abs[#2], 10^-35] &,
  {computed, reference}
];


(* ::Chapter:: *)
(* Baseline polyline: saved endpoints plus one transient waypoint *)

pointP1 = {k1 -> -9 I, k2 -> -3 I, q -> 1, a1 -> 1, a2 -> 1};
pointP2 = {k1 -> -7 I, k2 -> -2 I, q -> 1, a1 -> 1, a2 -> 1};
pointP3 = {k1 -> -5 I, k2 -> -4 I, q -> 1, a1 -> 1, a2 -> 1};

pathPlanned = MSGeneratePath[
  context,
  {pointP1, {pointP2, "tmp"}, pointP3},
  BoundaryScale -> 4,
  RankOrder -> {v1, v2},
  WorkingPrecision -> 40
];

plannedStatusCheck = <|
  "plannedPathQ" -> MSPlannedPathQ[pathPlanned],
  "schemaV3" -> Lookup[pathPlanned, "schema", None] ===
    "madstree_planned_path_v3",
  "backendPlanOnly" -> Lookup[
    Lookup[pathPlanned, "backendPlanning", <||>],
    "planningAction",
    None
  ] === "plan_raw_segments_without_execution",
  "serializedPlansStored" -> AllTrue[
    Lookup[pathPlanned, "segments", {}],
    Function[segment,
      With[{
        serialized = Lookup[
          Lookup[segment, "flintNDEPlan", <||>],
          "serializedPlan",
          None
        ]
      },
        AssociationQ[serialized] &&
        Lookup[serialized, "schema", None] ===
          "flintnde_planned_path_serialized_v1" &&
        Lookup[serialized, "planning_precision_digits", None] === 40
      ]
    ]
  ],
  "affineGroupsPresent" -> MatchQ[pathPlanned, _Association] &&
    Length[Lookup[pathPlanned, "segments", {}]] >= 1,
  "noSingularSegment" -> Lookup[pathPlanned, "singularSegments", Missing[]] === {},
  "noRemovedPoint" -> Lookup[pathPlanned, "removedPoints", Missing[]] === {},
  "minimumDistancePositive" -> TrueQ[
    NumberQ[Lookup[pathPlanned, "minimumPolePathDistance", 0]] &&
      Lookup[pathPlanned, "minimumPolePathDistance", 0] > 0
  ]
|>;

baselineResult = MSEvaluatePlannedPath[
  context,
  pathPlanned,
  PythonExecutable -> msTestPythonExecutable[],
  WorkingPrecision -> 40,
  TransportOrder -> 80,
  ReferenceTransportOrder -> 104,
  TargetRelativeError -> "1e-20"
];

precisionFailure = MSEvaluatePlannedPath[
  context,
  pathPlanned,
  WorkingPrecision -> 50,
  MessageLanguage -> "CN"
];

baselinePointResults = Lookup[baselineResult, "pointResults", {}];
baselineChecks = <|
  "computed" -> Lookup[baselineResult, "status", None] === "computed",
  "executionNoReplan" -> Lookup[baselineResult, "executionAction", None] ===
    "execute_existing_plans_without_replanning",
  "backendExecuteOnly" -> Lookup[
    Lookup[baselineResult, "flintNDE", <||>],
    "executionAction",
    None
  ] === "execute_existing_plans_without_replanning",
  "precisionUpgradeRefused" -> MatchQ[
    precisionFailure,
    Failure["PlannedPathPrecisionInsufficient", _Association]
  ],
  "precisionFailureLanguage" -> Head[precisionFailure] === Failure &&
    Lookup[Last[precisionFailure], "messageLanguage", None] === "CN",
  "sameDigest" -> Lookup[baselineResult, "masterDigest", None] === context["masterDigest"],
  "coordinatePairing" -> (#[["coordinate"]] & /@ baselinePointResults) ===
    {pointP1, pointP2, pointP3},
  "userIndices" -> (#[["userIndex"]] & /@ baselinePointResults) === {1, 2, 3},
  "statuses" -> (#[["status"]] & /@ baselinePointResults) ===
    {"saved", "transient", "saved"},
  "transientWaypointValue" -> TrueQ[
    relativeDifference[
      baselinePointResults[[2, "value"]], definitionVector[pointP2]
    ] < 10^-18
  ],
  "valuesMatchClosedForm" -> And @@ MapThread[
    TrueQ[relativeDifference[#1, definitionVector[#2]] < 10^-18] &,
    {#[["value"]] & /@ baselinePointResults, {pointP1, pointP2, pointP3}}
  ],
  "finalValueIsLastPoint" -> TrueQ[
    relativeDifference[
      Lookup[baselineResult, "values", {}],
      definitionVector[pointP3]
    ] < 10^-18
  ],
  "targetRelativeErrorMet" -> TrueQ[
    Lookup[Lookup[baselineResult, "flintNDE", <||>], "targetRelativeErrorMet", False]
  ]
|>;


(* ::Chapter:: *)
(*常量用户段作为零连接*)

constantPath = MSGeneratePath[
  context,
  {pointP1, pointP1},
  BoundaryScale -> 4,
  RankOrder -> {v1, v2},
  WorkingPrecision -> 40
];

constantResult = MSEvaluatePlannedPath[
  context,
  constantPath,
  PythonExecutable -> msTestPythonExecutable[],
  WorkingPrecision -> 40,
  TransportOrder -> 80,
  ReferenceTransportOrder -> 104,
  TargetRelativeError -> "1e-20"
];

constantSegments = Lookup[constantPath, "segments", {}];
constantPointResults = Lookup[constantResult, "pointResults", {}];
constantConnectionChecks = <|
  "planned" -> MSPlannedPathQ[constantPath],
  "duplicateUserIndicesRetainedInGroup" -> Length[constantSegments] >= 1 &&
    Lookup[Last[constantSegments], "userIndices", {}] === {1, 2},
  "computed" -> Lookup[constantResult, "status", None] === "computed",
  "duplicateCoordinatesRetained" -> Length[constantPointResults] === 2 &&
    (#[["coordinate"]] & /@ constantPointResults) === {pointP1, pointP1},
  "zeroConnectionKeepsValue" -> Length[constantPointResults] === 2 &&
    TrueQ[
      relativeDifference[
        constantPointResults[[1, "value"]],
        constantPointResults[[2, "value"]]
      ] < 10^-30
    ]
|>;


(* ::Chapter:: *)
(* Singular-locus point removal and reconnection *)

(* pointR2 sits exactly on the letter hyperplane k2 - q == 0 and must be removed uniformly; the polyline reconnects from point 1 directly to point 3. *)
pointR2 = {k1 -> -1, k2 -> 1, q -> 1, a1 -> 1, a2 -> 1};

removalPath = MSGeneratePath[
  context,
  {pointP1, pointR2, pointP3},
  BoundaryScale -> 4,
  RankOrder -> {v1, v2},
  WorkingPrecision -> 40,
  MessageLanguage -> "CN"
];

removalPlanChecks = <|
  "messageLanguageCN" -> Context[MessageLanguage] === StringJoin["MadStree", FromCharacterCode[96]] &&
    MemberQ[Options[MSGeneratePath], MessageLanguage -> "EN"] &&
    MemberQ[Options[MSEvaluatePlannedPath], MessageLanguage -> "EN"] &&
    Lookup[removalPath, "messageLanguage", None] === "CN" &&
    Lookup[Lookup[removalPath, "backendPlanning", <||>],
      "messageLanguage", None] === "CN",
  "oneRemovedPoint" -> (#[["userIndex"]] & /@ Lookup[removalPath, "removedPoints", {}]) === {2},
  "groupedSegmentsAfterRemoval" -> Length[Lookup[removalPath, "segments", {}]] >= 1,
  "reconnectionReport" -> Lookup[removalPath, "reconnections", {}] === {
    <|
      "removedUserIndices" -> {2},
      "reconnectFrom" -> 1,
      "reconnectTo" -> 3
    |>
  }
|>;

removalResult = MSEvaluatePlannedPath[
  context,
  removalPath,
  PythonExecutable -> msTestPythonExecutable[],
  WorkingPrecision -> 40,
  TransportOrder -> 80,
  ReferenceTransportOrder -> 104,
  TargetRelativeError -> "1e-20"
];

removalPointResults = Lookup[removalResult, "pointResults", {}];
removalChecks = <|
  "computed" -> Lookup[removalResult, "status", None] === "computed",
  "statuses" -> (#[["status"]] & /@ removalPointResults) ===
    {"saved", "removedSingularLocus", "saved"},
  "coordinatePairing" -> (#[["coordinate"]] & /@ removalPointResults) ===
    {pointP1, pointR2, pointP3},
  "removedValueMissing" -> MatchQ[removalPointResults[[2, "value"]], _Missing],
  "keptValuesMatchClosedForm" -> TrueQ[
    relativeDifference[removalPointResults[[1, "value"]], definitionVector[pointP1]] < 10^-18
  ] && TrueQ[
    relativeDifference[removalPointResults[[3, "value"]], definitionVector[pointP3]] < 10^-18
  ]
|>;


(* ::Chapter:: *)
(* No-singularity refusal and singularity-jump crossing *)

(* The segment from crossA to crossB pulls the letter k1 - q back to 1 - (3/2) s, whose pole sits at s = 2/3 strictly inside the segment. The k1 - q residue there has the integer spectrum {0, 0, -2}; the numeric eigen-route of the backend refuses resonant residues with a structured error instead of returning wrong numbers, so the test asserts detection plus structured refusal (the exact power-log route is future work). *)
crossA = {k1 -> 2, k2 -> -5, q -> 1, a1 -> 1, a2 -> 1};
crossB = {k1 -> 1/2, k2 -> -5, q -> 1, a1 -> 1, a2 -> 1};

refusal = MSGeneratePath[
  context,
  {crossA, crossB},
  BoundaryScale -> 4,
  RankOrder -> {v1, v2},
  WorkingPrecision -> 40
];

refusalChecks = <|
  "refusalIsFailure" -> Head[refusal] === Failure,
  "refusalTag" -> First[refusal] === "SingularPathOnUserPolyline",
  "singularPathPair" -> Lookup[Last[refusal], "Singular Path Pair", {}] === {{crossA, crossB}}
|>;

badLanguage = MSGeneratePath[
  context,
  {pointP1},
  BoundaryScale -> 4,
  RankOrder -> {v1, v2},
  WorkingPrecision -> 40,
  MessageLanguage -> "en"
];
badTaggedPoint = MSGeneratePath[
  context,
  {{pointP1, "unsupported"}},
  BoundaryScale -> 4,
  RankOrder -> {v1, v2},
  WorkingPrecision -> 40
];
extraFieldPlan = Append[pathPlanned, "unexpectedField" -> True];

strictContractChecks = <|
  "messageLanguageCaseSensitive" ->
    MatchQ[badLanguage, Failure["MessageLanguage", _Association]],
  "unsupportedTagRejected" ->
    MatchQ[badTaggedPoint, Failure["PathPointTag", _Association]],
  "extraPlanFieldRejected" -> ! MSPlannedPathQ[extraFieldPlan]
|>;


crossPath = MSGeneratePath[
  context,
  {crossA, crossB},
  SingularityMode -> "SingularityJump",
  BoundaryScale -> 4,
  RankOrder -> {v1, v2},
  WorkingPrecision -> 40,
  MessageLanguage -> "CN"
];

crossResult = MSEvaluatePlannedPath[
  context,
  crossPath,
  PythonExecutable -> msTestPythonExecutable[],
  WorkingPrecision -> 40,
  TransportOrder -> 80,
  ReferenceTransportOrder -> 104,
  TargetRelativeError -> "1e-20"
];

crossChecks = <|
  "explicitSingularityJumpMode" ->
    Lookup[crossPath, "singularityMode", None] === "SingularityJump" &&
    Lookup[crossPath, "messageLanguage", None] === "CN",
  "backendPlanOnly" -> Lookup[
    Lookup[crossPath, "backendPlanning", <||>],
    "planningAction",
    None
  ] === "plan_raw_segments_without_execution",
  "singularSegmentDetected" -> Lookup[crossPath, "singularSegments", {}] === {2},
  "minimumDistanceZero" -> Head[crossPath] =!= Failure &&
    TrueQ[N[Lookup[crossPath, "minimumPolePathDistance", 1], 40] == 0],
  "executionStructurallyRefused" -> Head[crossResult] === Failure,
  "polesOnPathPlanned" -> Head[crossPath] =!= Failure &&
    Length[Flatten@Map[
      Select[#[["poles"]], TrueQ[#[["onSegment"]]] &] &,
      Lookup[crossPath, "segments", {}]
    ]] === 1
|>;


(* ::Chapter:: *)
(* Leading-order execute-only refusal contract *)

loPoint = {k1 -> 1, k2 -> -3 I, q -> 1, a1 -> 1, a2 -> 1};
loPath = MSGeneratePath[
  context,
  {pointP1, {loPoint, "lo"}},
  BoundaryScale -> 4,
  RankOrder -> {v1, v2},
  WorkingPrecision -> 40
];

ruleArgrSeen = False;
loResult = Check[
  MSEvaluatePlannedPath[
    context,
    loPath,
    PythonExecutable -> msTestPythonExecutable[],
    WorkingPrecision -> 40,
    TransportOrder -> 80,
    ReferenceTransportOrder -> 104,
    TargetRelativeError -> "1e-20"
  ],
  ruleArgrSeen = True; $Failed,
  Rule::argr
];
loRequests = Lookup[loPath, "leadingOrderRequests", {}];
loRecords = If[
  AssociationQ[loResult],
  Lookup[loResult, "leadingOrderResults", {}],
  {}
];

loChecks = <|
  "onePlannedRequest" -> Length[loRequests] === 1,
  "storedExecutePlan" -> Length[loRequests] === 1 &&
    Lookup[loRequests[[1, "flintNDEPlan"]], "planningAction", None] ===
      "plan_leading_order_match_without_execution" &&
    Lookup[loRequests[[1, "flintNDEPlan", "serializedPlan"]],
      "planning_precision_digits", None] === 40,
  "computedWithRefusalRecord" -> AssociationQ[loResult] &&
    Lookup[loResult, "status", None] === "computed" &&
    Length[loRecords] === 1 &&
    Lookup[First[loRecords], "status", None] === "leadingOrderRefused",
  "executeOnlyRefusal" -> Length[loRecords] === 1 &&
    Lookup[First[loRecords], "executionAction", None] ===
      "execute_existing_leading_order_plan_without_replanning",
  "directionAndCoordinate" -> Length[loRecords] === 1 &&
    Lookup[First[loRecords], "coordinate", None] === loPoint &&
    Lookup[Lookup[First[loRecords], "arrivalDirection", <||>],
      "fromUserIndex", None] === 1,
  "noRuleArgr" -> ! TrueQ[ruleArgrSeen]
|>;


(* ::Chapter:: *)
(* Summary *)

checks = Join @@ (Normal /@ {
  KeyMap["plan." <> # &, plannedStatusCheck],
  KeyMap["baseline." <> # &, baselineChecks],
  KeyMap["constant." <> # &, constantConnectionChecks],
  KeyMap["removalPlan." <> # &, removalPlanChecks],
  KeyMap["removal." <> # &, removalChecks],
  KeyMap["refusal." <> # &, refusalChecks],
  KeyMap["strict." <> # &, strictContractChecks],
  KeyMap["cross." <> # &, crossChecks],
  KeyMap["lo." <> # &, loChecks]
}) // Association;

msTestSummary[checks, "MadStree polyline planning"];

If[! And @@ Values[checks],
  Print["pathPlanned: ", InputForm[KeyDrop[pathPlanned, {"segments", "boundaryData"}]]];
  Print["baselineResult: ", InputForm[KeyDrop[baselineResult, {"flintNDE", "boundary", "path"}]]];
  Print["constantPath: ", InputForm[KeyDrop[constantPath, {"segments", "boundaryData"}]]];
  Print["constantResult: ", InputForm[KeyDrop[constantResult, {"flintNDE", "boundary", "path"}]]];
  Print["removalPath reconnections: ", InputForm[Lookup[removalPath, "reconnections", Missing[]]]];
  Print["removalResult: ", InputForm[KeyDrop[removalResult, {"flintNDE", "boundary", "path"}]]];
  Print["refusal: ", InputForm[refusal]];

  Print["crossPath singularSegments: ", InputForm[Lookup[crossPath, "singularSegments", Missing[]]]];
  Print["crossResult: ", InputForm[crossResult]];
  Print["precisionFailure: ", InputForm[precisionFailure]];
  Print["loPath: ", InputForm[KeyDrop[loPath, {"segments", "boundaryData"}]]];
  Print["loResult: ", InputForm[loResult]];
  Exit[1]
];
