(* ::Package:: *)

(***
File: Representation.wl
Purpose: Validates native MSIntegral objects, performs H/h state transformations, and adapts the native dSIBP 020 time-only J.
Scope: Reverse conversion is allowed only when the three slots sectorKey, timeShifts and stateBits match the current context exactly.
***)

(* ::Chapter:: *)
(* Native integral validation *)

msIntegralData[int : MSIntegral[key_String, shifts_List, bits_List], context_?MSContextQ] := Module[
  {sector = msSectorByKey[context, key]},
  If[Head[sector] === Missing, Return[Failure["UnknownSector", <|"sectorKey" -> key|>]]];
  If[Length[shifts] =!= Length[sector["vertexComponents"]] || ! And @@ (IntegerQ /@ shifts),
    Return[Failure["BadTimeShifts", <|"expected" -> Length[sector["vertexComponents"]], "actual" -> shifts|>]]
  ];
  If[! MemberQ[sector["stateOrder"], bits],
    Return[Failure[
      "BadStateBits",
      <|"expectedStateOrder" -> sector["stateOrder"], "actual" -> bits|>
    ]]
  ];
  <|"sector" -> sector, "shifts" -> shifts, "bits" -> bits|>
];

msIntegralData[other_, _] := Failure["NotMSIntegral", <|"input" -> HoldForm[other]|>];


(* ::Section:: *)
(* All-sector H/h state-vector transformation *)

(*
Input is ordered by the sector stateBits; massive endpoints and RedundantH massless endpoints each use z=-k tau, while the massless shared quotient acts as the identity under the H/h basis change.
*)
msSectorBasisTransformMatrix[
  direction_Rule,
  sector_Association,
  componentTimes_List,
  nuConvention_String
] := Module[{localMatrices, componentPosition, zValue},
  If[! MemberQ[{"H" -> "h", "h" -> "H"}, direction],
    Return[Failure["UnsupportedBasisDirection", <|"direction" -> direction|>]]
  ];
  localMatrices = Map[
    Function[slot,
      If[slot["kind"] === "masslessShared",
        msIdentity2,
        componentPosition = sector["rootToComponent"][slot["rootVertex"]];
        zValue = -slot["momentum"] componentTimes[[componentPosition]];
        If[direction === ("H" -> "h"),
          msHTohMatrix[slot["nu"], zValue, nuConvention],
          msHToHMatrix[slot["nu"], zValue, nuConvention]
        ]
      ]
    ],
    sector["slots"]
  ];
  msQuotientMatrix[sector, msKroneckerAll[localMatrices]]
];

(*
Returns the sector state vector in the same order as the input. This interface acts on integrand states and does not change the base time powers of MSIntegral; basis changes of integral objects require additional target-family metadata and remain rejected for now.
*)
MSConvertBasis[
  vector_List,
  direction_Rule,
  key_String,
  componentTimes_List,
  context_?MSContextQ
] := Module[{sector, matrix, nuConvention},
  sector = msSectorByKey[context, key];
  If[Head[sector] === Missing, Return[Failure["UnknownSector", <|"sectorKey" -> key|>]]];
  If[Length[componentTimes] =!= Length[sector["vertexComponents"]],
    Return[Failure[
      "ComponentTimeCount",
      <|"expected" -> Length[sector["vertexComponents"]], "actual" -> Length[componentTimes]|>
    ]]
  ];
  If[Length[vector] =!= sector["masterCount"],
    Return[Failure[
      "StateVectorDimension",
      <|"expected" -> sector["masterCount"], "actual" -> Length[vector]|>
    ]]
  ];
  nuConvention = context["convention"]["nuConvention"];
  matrix = msSectorBasisTransformMatrix[direction, sector, componentTimes, nuConvention];
  If[Head[matrix] === Failure, matrix, Simplify[matrix.vector]]
];


(* ::Chapter:: *)
(*dSIBP 020 time-only J[sectorKey,timeShifts,stateBits] adapter*)


(* Input must first pass validation against the current MadStree context; output stays lazy to avoid evaluation when dSIBP is not loaded. *)
MSToDSIBPJ[int : MSIntegral[_, _, _], context_?MSContextQ] := Module[
  {data},
  data = msIntegralData[int, context];
  If[Head[data] === Failure, Return[data]];
  Inactive[dSIBP`J][data["sector"]["sectorKey"], data["shifts"], data["bits"]]
];


msDSIBPActiveJToInactive[expr_] := Replace[
  Unevaluated[expr],
  dSIBP`J[key_String, shifts_List, bits_List] :> Inactive[dSIBP`J][key, shifts, bits]
];


(* The reverse entry validates sector, time-shift dimension and discrete states slot by slot; inconsistent schemas return a native Failure. *)
MSFromDSIBPJ[input_, context_?MSContextQ] := Module[
  {held, key, shifts, bits, candidate, validation},
  held = msDSIBPActiveJToInactive[input];
  If[! MatchQ[held, Inactive[dSIBP`J][_String, _List, _List]],
    Return[Failure["UnsupportedDSIBPJ", <|"input" -> HoldForm[input]|>]]
  ];
  {key, shifts, bits} = List @@ held;
  candidate = MSIntegral[key, shifts, bits];
  validation = msIntegralData[candidate, context];
  If[Head[validation] === Failure, validation, candidate]
];


MSFromDSIBPExpression[expr_, context_?MSContextQ] := Module[
  {integrals, mapped, failures},
  integrals = DeleteDuplicates@Cases[expr, _dSIBP`J, Infinity];
  mapped = MSFromDSIBPJ[#, context] & /@ integrals;
  failures = Pick[mapped, Head /@ mapped, Failure];
  If[failures =!= {},
    Return[Failure[
      "DSIBPExpressionConversionFailed",
      <|"integrals" -> integrals, "failures" -> failures|>
    ]]
  ];
  Expand[expr /. Thread[integrals -> mapped]]
];
