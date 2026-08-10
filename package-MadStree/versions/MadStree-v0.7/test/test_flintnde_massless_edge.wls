(* ::Package:: *)

(***
File: test_flintnde_massless_edge.wls
Purpose: Verifies the generic multi-sector Frobenius boundary of a massless full edge and the FlintNDE transport.
Run: wolframscript -file package-MadStree/test/test_flintnde_massless_edge.wls
***)

(* ::Chapter:: *)
(* Loading and graph input *)

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
targetRules = {k1 -> -9 I, k2 -> -3 I, q -> 1, a1 -> 1, a2 -> 1};


(* ::Chapter:: *)
(* Generic infinity boundary *)

directAtTarget = MSBoundaryData[
  context,
  targetRules,
  BoundaryScale -> 3,
  RankOrder -> {v1, v2},
  WorkingPrecision -> 40
];

transported = MSEvaluateTree[
  context,
  targetRules,
  PythonExecutable -> msTestPythonExecutable[],
  BoundaryScale -> 4,
  RankOrder -> {v1, v2},
  WorkingPrecision -> 40,
  TransportOrder -> 80,
  ReferenceTransportOrder -> 104,
  TargetRelativeError -> "1e-20"
];


(* ::Chapter:: *)
(* Analytic time chambers and dlog residuals *)

(* Both ordered time integrals reduce to the same Gauss hypergeometric closed form, used to prevent contact sign drift. *)
orderedIntegral[a_, b_, lambdaA_, lambdaB_] := Module[{weight = a + b + 2},
  Gamma[weight] lambdaB^(-weight) Hypergeometric2F1[
    weight, a + 1, a + 2, -lambdaA/lambdaB
  ]/(a + 1)
];


definitionVectorForSign[phaseSign_] := {
  orderedIntegral[1, 1, I phaseSign k1 - I q, I phaseSign k2 + I q] +
    orderedIntegral[1, 1, I phaseSign k2 - I q, I phaseSign k1 + I q],
  -orderedIntegral[1, 1, I phaseSign k1 - I q, I phaseSign k2 + I q] +
    orderedIntegral[1, 1, I phaseSign k2 - I q, I phaseSign k1 + I q],
  Gamma[4] (I phaseSign (k1 + k2))^-4
};


definitionVector = definitionVectorForSign[1];
de = MSDLogDE[context];
connectionK1 = Map[D[#, k1] &, de["omegaPotential"], {2}];
connectionK2 = Map[D[#, k2] &, de["omegaPotential"], {2}];
definitionDEResidual = Together@FullSimplify@FunctionExpand@Join[
  D[definitionVector, k1] - connectionK1.definitionVector,
  D[definitionVector, k2] - connectionK2.definitionVector
] /. {a1 -> 1, a2 -> 1};
definitionValues = N[definitionVector /. targetRules, 40];
definitionRelativeDifference = Max@MapThread[
  Abs[#1 - #2]/Max[Abs[#2], 10^-35] &,
  {transported["values"], definitionValues}
];

negativeContext = MSInitTree[<|
  "vertices" -> {
    <|"id" -> v1, "energy" -> k1, "timePower" -> a1, "phaseSign" -> -1|>,
    <|"id" -> v2, "energy" -> k2, "timePower" -> a2, "phaseSign" -> -1|>
  },
  "lines" -> {
    <|"id" -> e, "type" -> "masslessFull", "endpoints" -> {v1, v2},
      "momentum" -> q, "skType" -> "++"|>
  }
|>];
negativeDefinitionVector = definitionVectorForSign[-1];
negativeDE = MSDLogDE[negativeContext];
negativeDefinitionDEResidual = Together@FullSimplify@FunctionExpand@Join[
  D[negativeDefinitionVector, k1] -
    Map[D[#, k1] &, negativeDE["omegaPotential"], {2}].negativeDefinitionVector,
  D[negativeDefinitionVector, k2] -
    Map[D[#, k2] &, negativeDE["omegaPotential"], {2}].negativeDefinitionVector
] /. {a1 -> 1, a2 -> 1};
residue = directAtTarget["singularResidue"];
indicialResiduals = Together[
    (#1 IdentityMatrix[Length[residue]] - residue).#2
  ] & @@@ ({#1["frobeniusExponent"], #1["normalizedLeadingVector"]} & /@
    directAtTarget["leadingBranches"]);


(* ::Chapter:: *)
(* Formula closure and transport summary *)

checks = <|
  "threeMasters" -> Length[MSMasterIntegrals[context]] === 3,
  "dlogClosed" -> de["dlogStatus"] === "certifiedByFormulaChecks",
  "definitionDLogResidual" -> TrueQ[And @@ (PossibleZeroQ /@ definitionDEResidual)],
  "negativeDefinitionDLogResidual" -> TrueQ[
    And @@ (PossibleZeroQ /@ negativeDefinitionDEResidual)
  ],
  "genericBoundary" -> Lookup[directAtTarget, "method", None] ===
    "2411GenericSectorLeadingSeries" &&
    Length[Lookup[directAtTarget, "leadingBranches", {}]] === 3,
  "indicialResidual" -> TrueQ[And @@ (PossibleZeroQ /@ Flatten[indicialResiduals])],
  "evaluationComputed" -> Lookup[transported, "status", None] === "computed",
  "sameDigest" -> Lookup[transported, "masterDigest", None] === context["masterDigest"],
  "definitionValue" -> TrueQ[definitionRelativeDifference < 10^-20]
|>;

msTestSummary[checks, "MadStree massless boundary"];

If[! And @@ Values[checks],
  Print["directAtTarget: ", InputForm[directAtTarget]];
  Print["transported: ", InputForm[transported]];
  Print["definitionDEResidual: ", InputForm[definitionDEResidual]];
  Print["negativeDefinitionDEResidual: ", InputForm[negativeDefinitionDEResidual]];
  Print["definitionRelativeDifference: ", InputForm[definitionRelativeDifference]];
  Exit[1]
];
