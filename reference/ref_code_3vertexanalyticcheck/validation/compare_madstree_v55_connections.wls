(* Exact/numeric block audit of MadStree v0.6 versus the preserved V5.5 raw DE. *)

ClearAll[requiredEnvironment, nonzeroCount, maxAbsNumeric, blockAudit];
requiredEnvironment[name_String] := Module[{value = Quiet[Environment[name]]},
  If[!StringQ[value] || StringLength[value] == 0,
    Print["Missing environment variable: " <> name];
    Exit[2]
  ];
  value
];
nonzeroCount[matrix_] := Count[
  Flatten[matrix],
  entry_ /; !TrueQ[PossibleZeroQ[entry]]
];
maxAbsNumeric[matrix_] := Max[Abs[Flatten[N[matrix, 40]]]];
blockAudit[difference_, rows_, columns_] := Module[{block},
  block = difference[[rows, columns]];
  <|
    "nonzeroCount" -> nonzeroCount[block],
    "maximumAbsoluteDifference" -> maxAbsNumeric[block]
  |>
];

packageRoot = requiredEnvironment["MADSTREE_PACKAGE_ROOT"];
v55Source = requiredEnvironment["V55_SOURCE"];
outputFile = requiredEnvironment["CONNECTION_COMPARISON_OUTPUT"];

sourceText = Import[v55Source, "Text", CharacterEncoding -> "UTF8"];
If[StringTake[sourceText, UpTo[1]] === FromCharacterCode[{65279}],
  sourceText = StringDrop[sourceText, 1]
];
sourceText = StringReplace[sourceText, "v55RunNow = True;" -> "v55RunNow = False;"];
ToExpression[sourceText, InputForm];
If[!TrueQ[XYZZLoadProjectCore[]],
  Print["V5.5 project core failed to load."];
  Exit[3]
];

AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
Needs["MadStree`"];

treeSpec = <|
  "vertices" -> {
    <|"id" -> v1, "externalLegEnergy" -> k1,
      "timePower" -> a1, "vertexType" -> "+"|>,
    <|"id" -> v2, "externalLegEnergy" -> k2,
      "timePower" -> a2, "vertexType" -> "+"|>,
    <|"id" -> v3, "externalLegEnergy" -> k3,
      "timePower" -> a3, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massive", "endpoints" -> {v1, v2},
      "momentum" -> q12, "nu" -> nu12,
      "pinchNormalization" -> -(4 I/Pi) q12^(-2 nu12 - 1)|>,
    <|"type" -> "massive", "endpoints" -> {v2, v3},
      "momentum" -> q23, "nu" -> nu23,
      "pinchNormalization" -> -(4 I/Pi) q23^(-2 nu23 - 1)|>
  }
|>;
context = MSInitTree[treeSpec, NuConvention -> "Negative"];
If[!AssociationQ[context],
  Print["MadStree v0.15 tree initialization failed: ", InputForm[context]];
  Exit[4]
];
de = MSDLogDE[context];
omega = de["omegaPotential"];
If[Dimensions[omega] =!= {25, 25},
  Print["Unexpected MadStree connection dimension: ", Dimensions[omega]];
  Exit[5]
];

(* Generic exact nonsingular audit point.  NuConvention="Negative" is the
   convention used by the official v0.15 three-vertex benchmark.  In v0.15,
   vertexType="+" uses
   Exp[-I k tau], while the validated V5.5 + branch uses Exp[+I E tau].
   Therefore k=-E and A_E=-A_k.  The mass and time-power parameters agree. *)
madRules = {
  k1 -> -7, k2 -> -11, k3 -> -13,
  q12 -> 2, q23 -> 3,
  nu12 -> 2/5, nu23 -> 1/3,
  a1 -> 5/4, a2 -> 7/6, a3 -> 9/8
};
v55Rules = {
  E1 -> 7, E2 -> 11, E3 -> 13,
  s1 -> 2, s2 -> 3,
  nu1 -> 2/5, nu2 -> 1/3,
  nu0L -> 5/4, nu0M -> 7/6, nu0R -> 9/8
};

madMatrices = <|
  "E1" -> -(D[omega, k1] /. madRules),
  "E2" -> -(D[omega, k2] /. madRules),
  "E3" -> -(D[omega, k3] /. madRules),
  "s1" -> (D[omega, q12] /. madRules),
  "s2" -> (D[omega, q23] /. madRules)
|>;
v55Matrices = <|
  "E1" -> (XYZZProjectRawBranchMatrixForVariable[{1, 1, 1}, E1] /. v55Rules),
  "E2" -> (XYZZProjectRawBranchMatrixForVariable[{1, 1, 1}, E2] /. v55Rules),
  "E3" -> (XYZZProjectRawBranchMatrixForVariable[{1, 1, 1}, E3] /. v55Rules),
  "s1" -> (XYZZProjectRawBranchMatrix[{1, 1, 1}] /. v55Rules),
  "s2" -> (XYZZProjectRawBranchMatrixForVariable[{1, 1, 1}, s2] /. v55Rules)
|>;

sectorRanges = <|
  "Top" -> Range[1, 16],
  "LeftPinch" -> Range[17, 20],
  "RightPinch" -> Range[21, 24],
  "DoublePinch" -> {25}
|>;
blockNames = {
  "Top<-Top" -> {sectorRanges["Top"], sectorRanges["Top"]},
  "Top<-LeftPinch" -> {sectorRanges["Top"], sectorRanges["LeftPinch"]},
  "Top<-RightPinch" -> {sectorRanges["Top"], sectorRanges["RightPinch"]},
  "Top<-DoublePinch" -> {sectorRanges["Top"], sectorRanges["DoublePinch"]},
  "LeftPinch<-LeftPinch" -> {sectorRanges["LeftPinch"], sectorRanges["LeftPinch"]},
  "LeftPinch<-DoublePinch" -> {sectorRanges["LeftPinch"], sectorRanges["DoublePinch"]},
  "RightPinch<-RightPinch" -> {sectorRanges["RightPinch"], sectorRanges["RightPinch"]},
  "RightPinch<-DoublePinch" -> {sectorRanges["RightPinch"], sectorRanges["DoublePinch"]},
  "DoublePinch<-DoublePinch" -> {sectorRanges["DoublePinch"], sectorRanges["DoublePinch"]}
};

audits = Association@KeyValueMap[
  Function[{variable, madMatrix}, Module[{difference},
    difference = Map[FullSimplify, v55Matrices[variable] - madMatrix, {2}];
    variable -> <|
      "fullNonzeroCount" -> nonzeroCount[difference],
      "fullMaximumAbsoluteDifference" -> maxAbsNumeric[difference],
      "blocks" -> Association@Map[
        Function[item,
          First[item] -> blockAudit[difference, Last[item][[1]], Last[item][[2]]]
        ],
        blockNames
      ]
    |>
  ]],
  madMatrices
];

result = <|
  "object" -> "25x25 column-connection matrix audit at a generic exact point",
  "mapping" -> <|
    "energy" -> "k_MadStree=-E_V55 and A_E=-A_k",
    "mass" -> "nu_MadStree=nu_V55",
    "timePower" -> "a_MadStree=nu0_V55",
    "sectorOrder" -> "Top16+LeftPinch4+RightPinch4+DoublePinch1"
  |>,
  "madRules" -> madRules,
  "v55Rules" -> v55Rules,
  "audits" -> audits
|>;
Put[result, outputFile];
Print["CONNECTION_AUDIT_BEGIN"];
Print[InputForm[result]];
Print["CONNECTION_AUDIT_END"];
If[Total[Lookup[Values[audits], "fullNonzeroCount"]] === 0,
  Print["ALL MADSTREE/V5.5 CONNECTION BLOCKS MATCH"];
  Exit[0],
  Print["MADSTREE/V5.5 CONNECTION MISMATCH DETECTED"];
  Exit[6]
];
