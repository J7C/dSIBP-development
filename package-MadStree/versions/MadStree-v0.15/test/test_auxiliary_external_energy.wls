(* ::Package:: *)

(***
File: test_auxiliary_external_energy.wls
Purpose: Verifies that an omitted external-leg energy and an explicit zero use the same private auxiliary coordinate, construct a numerical boundary, and return the same physical target value without exposing that coordinate to pointSequence.
Run: wolframscript -file package-MadStree/versions/MadStree-v0.15/test/test_auxiliary_external_energy.wls
***)

(* ::Chapter:: *)
(* Loading and equivalent inputs *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]];
packageRoot = msTestLoadKernel[];

baseVertices = {
  <|"id" -> 1, "timePower" -> 1, "vertexType" -> "+"|>,
  <|"id" -> 2, "externalLegEnergy" -> k2, "timePower" -> 1,
    "vertexType" -> "+"|>
};
lineInput = {
  <|"type" -> "massless", "endpoints" -> {1, 2}, "momentum" -> q|>
};

omittedContext = MSInitTree[<|"vertices" -> baseVertices, "lines" -> lineInput|>];
zeroVertices = ReplacePart[
  baseVertices,
  1 -> Append[First[baseVertices], "externalLegEnergy" -> 0]
];
zeroContext = MSInitTree[<|"vertices" -> zeroVertices, "lines" -> lineInput|>];


(* ::Chapter:: *)
(* Physical zero-target transport *)

commonOptions = {
  ParameterRules -> {q -> 1},
  BoundaryScale -> 4,
  WorkingPrecision -> 40,
  TransportOrder -> 80,
  ReferenceTransportOrder -> 104,
  TargetRelativeError -> "1e-20",
  MessageLanguage -> "EN"
};
pointSequence = {{k2}, {3 I}};

omittedResult = MSEvaluatePath[
  omittedContext,
  pointSequence,
  Sequence @@ commonOptions
];
zeroResult = MSEvaluatePath[
  zeroContext,
  pointSequence,
  Sequence @@ commonOptions
];


(* ::Chapter:: *)
(* Acceptance *)

auxiliarySymbol = omittedContext["vertices"][[1, "externalLegEnergy"]];
checks = <|
  "sameAnalyticContext" ->
    omittedContext["masterDigest"] === zeroContext["masterDigest"],
  "privateAuxiliaryCoordinate" ->
    TrueQ[omittedContext["vertices"][[1, "auxiliaryExternalLegEnergyQ"]]] &&
      omittedContext["vertices"][[1, "externalLegEnergyTarget"]] === 0,
  "publicPointSequenceDoesNotExposeAuxiliary" -> FreeQ[pointSequence, auxiliarySymbol],
  "omittedComputed" -> Lookup[omittedResult, "status", None] === "computed",
  "zeroComputed" -> Lookup[zeroResult, "status", None] === "computed",
  "samePhysicalValue" -> If[
    AssociationQ[omittedResult] && AssociationQ[zeroResult] &&
      KeyExistsQ[omittedResult, "pointResults"] && KeyExistsQ[zeroResult, "pointResults"],
    Max[Abs[
      omittedResult["pointResults"][[1, "values"]] -
        zeroResult["pointResults"][[1, "values"]]
    ]] < 10^-20,
    False
  ]
|>;

msTestSummary[checks, "MadStree auxiliary external-leg energy"];
