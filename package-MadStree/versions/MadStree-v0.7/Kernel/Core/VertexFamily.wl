(* ::Package:: *)

(***
File: VertexFamily.wl
Purpose: Initializes single-vertex function families from reference-code ki/nui data or explicit building-block associations.
Scope: This entry does not require a topology; internally it only reuses the certified sector/matrix producers and does not generate spurious internal lines.
***)

(* ::Chapter:: *)
(* Input normalization *)

Options[MSInitVertexFamily] = {NuConvention -> "Positive"};

msVertexFamilyCompactInput[spec_Association] := Module[
  {ki = Lookup[spec, "ki", Missing["ki"]],
   nui = Lookup[spec, "nui", Lookup[spec, "nu", Missing["nui"]]], branches, blockCount},
  If[! ListQ[ki] || ! ListQ[nui] || Length[ki] < 1 || Length[ki] =!= Length[nui],
    Return[Failure["VertexFamilyKiNuiLengths", <|"ki" -> ki, "nui" -> nui|>]]
  ];
  blockCount = Length[ki] - 1;
  branches = Lookup[spec, "hankelBranches", Lookup[spec, "branches", ConstantArray[1, blockCount]]];
  If[! ListQ[branches] || Length[branches] =!= blockCount ||
     ! And @@ (MemberQ[{1, 2}, #] & /@ branches),
    Return[Failure[
      "VertexFamilyHankelBranches",
      <|"expectedLength" -> blockCount, "actual" -> branches|>
    ]]
  ];
  <|
    "energy" -> First[ki],
    "timePower" -> First[nui],
    "hBlocks" -> MapThread[
      <|"momentum" -> #1, "nu" -> #2, "hankelBranch" -> #3|> &,
      {Rest[ki], Rest[nui], branches}
    ],
    "exponentialBlocks" -> Lookup[spec, "exponentialBlocks", {}],
    "phaseSign" -> Lookup[spec, "phaseSign", 1],
    "normalization" -> Lookup[spec, "normalization", 1]
  |>
];

msVertexFamilyAssociationInput[spec_Association] := <|
  "energy" -> Lookup[spec, "energy", Lookup[spec, "k0", Missing["energy"]]],
  "timePower" -> Lookup[spec, "timePower", Missing["timePower"]],
  "hBlocks" -> Lookup[spec, "hBlocks", {}],
  "exponentialBlocks" -> Lookup[spec, "exponentialBlocks", {}],
  "phaseSign" -> Lookup[spec, "phaseSign", 1],
  "normalization" -> Lookup[spec, "normalization", 1]
|>;

msNormalizeVertexFamilyInput[spec_Association] := If[
  KeyExistsQ[spec, "ki"] || KeyExistsQ[spec, "nui"],
  msVertexFamilyCompactInput[spec],
  msVertexFamilyAssociationInput[spec]
];

msNormalizeVertexFamilyHBlock[block_Association, position_Integer] := <|
  "id" -> Lookup[block, "id", Symbol["h" <> ToString[position]]],
  "momentum" -> Lookup[block, "momentum", Lookup[block, "k", Missing["momentum", position]]],
  "nu" -> Lookup[block, "nu", Missing["nu", position]],
  "hankelBranch" -> Lookup[block, "hankelBranch", Lookup[block, "branch", 1]]
|>;

msNormalizeVertexFamilyExponentialBlock[block_Association, position_Integer] := <|
  "id" -> Lookup[block, "id", Symbol["exp" <> ToString[position]]],
  "momentum" -> Lookup[block, "momentum", Lookup[block, "k", Missing["momentum", position]]],
  "phaseSign" -> Lookup[block, "phaseSign", Lookup[block, "sign", 1]]
|>;


(* ::Chapter:: *)
(* Dedicated public initialization *)

MSInitVertexFamily[spec_Association, OptionsPattern[]] := Module[
  {normalized, rawHBlocks, rawExponentialBlocks, hBlocks, exponentialBlocks, issues = {},
   effectiveEnergy, treeSpec, context, vertexId = vertexFamilyRoot,
   nuConvention = OptionValue[NuConvention]},
  normalized = msNormalizeVertexFamilyInput[spec];
  If[Head[normalized] === Failure, Return[normalized]];
  rawHBlocks = normalized["hBlocks"];
  rawExponentialBlocks = normalized["exponentialBlocks"];
  If[! ListQ[rawHBlocks] || ! And @@ (AssociationQ /@ rawHBlocks),
    AppendTo[issues, "hBlocks must be a list of associations"]
  ];
  If[! ListQ[rawExponentialBlocks] || ! And @@ (AssociationQ /@ rawExponentialBlocks),
    AppendTo[issues, "exponentialBlocks must be a list of associations"]
  ];
  If[issues =!= {},
    Message[MSInitVertexFamily::badinput, issues];
    Return[Failure["InvalidVertexFamilyInput", <|"issues" -> issues|>]]
  ];
  hBlocks = MapIndexed[msNormalizeVertexFamilyHBlock[#1, First[#2]] &, rawHBlocks];
  exponentialBlocks = MapIndexed[
    msNormalizeVertexFamilyExponentialBlock[#1, First[#2]] &,
    rawExponentialBlocks
  ];
  If[Head[normalized["energy"]] === Missing, AppendTo[issues, "missing energy/k0/ki[0]"]];
  If[Head[normalized["timePower"]] === Missing, AppendTo[issues, "missing timePower/nui[0]"]];
  If[AnyTrue[
      hBlocks,
      Head[#["momentum"]] === Missing || Head[#["nu"]] === Missing ||
        ! MemberQ[{1, 2}, #["hankelBranch"]] &
    ],
    AppendTo[issues, "every h block requires momentum, nu, and Hankel branch 1 or 2"]
  ];
  If[AnyTrue[
      exponentialBlocks,
      Head[#["momentum"]] === Missing || ! MemberQ[{-1, 1}, #["phaseSign"]] &
    ],
    AppendTo[issues, "every exponential block requires momentum and phaseSign +/-1"]
  ];
  If[! MemberQ[{-1, 1}, normalized["phaseSign"]],
    AppendTo[issues, "phaseSign must be +/-1"]
  ];
  If[issues =!= {},
    Message[MSInitVertexFamily::badinput, issues];
    Return[Failure["InvalidVertexFamilyInput", <|"issues" -> issues|>]]
  ];
  effectiveEnergy = Simplify[
    normalized["energy"] + Total[(#["phaseSign"] #["momentum"]) & /@ exponentialBlocks]
  ];
  treeSpec = <|
    "vertices" -> {
      <|
        "id" -> vertexId,
        "energy" -> effectiveEnergy,
        "timePower" -> normalized["timePower"],
        "phaseSign" -> normalized["phaseSign"]
      |>
    },
    "lines" -> Map[
      <|
        "id" -> #["id"],
        "type" -> "massiveExternal",
        "endpoints" -> {vertexId},
        "momentum" -> #["momentum"],
        "nu" -> #["nu"],
        "skType" -> If[#["hankelBranch"] === 1, "-", "+"],
        "hankelBranches" -> {#["hankelBranch"]}
      |> &,
      hBlocks
    ],
    "normalization" -> normalized["normalization"]
  |>;
  context = MSInitTree[treeSpec, NuConvention -> nuConvention];
  If[Head[context] === Failure, Return[context]];
  Join[
    context,
    <|
      "contextKind" -> "vertexFamily",
      "vertexFamily" -> <|
        "inputConvention" -> "ki={k0,k1,...}; nui={timePower,nu1,...}",
        "baseEnergy" -> normalized["energy"],
        "effectiveEnergy" -> effectiveEnergy,
        "timePower" -> normalized["timePower"],
        "phaseBlock" -> <|
          "kind" -> "phaseExponent", "dimension" -> 1,
          "momentum" -> normalized["energy"], "phaseSign" -> 1
        |>,
        "exponentialBlocks" -> Map[
          Join[#, <|"kind" -> "phaseExponent", "dimension" -> 1|>] &,
          exponentialBlocks
        ],
        "hBlocks" -> Map[
          Join[#, <|"kind" -> "massiveEndpoint", "dimension" -> 2|>] &,
          hBlocks
        ]
      |>
    |>
  ]
];

MSInitVertexFamily[other_, ___] := (
  Message[MSInitVertexFamily::badinput, HoldForm[other]];
  Failure["MalformedVertexFamilySpec", <|"input" -> HoldForm[other]|>]
);
