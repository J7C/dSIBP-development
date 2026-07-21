(* ::Package:: *)
(* 独立展开 massive bubble 的 direct-h、bare-H、H-to-h 三路 seed 与正式 s11
   总导数；reference-only 80 条映射保持单独计数。 *)

familyDir = DirectoryName[$InputFileName];
benchmarkDir = DirectoryName[familyDir];
Get[FileNameJoin[{benchmarkDir, "oracle", "independent_oracle.wl"}]];
Get[FileNameJoin[{familyDir, "family.wl"}]];
Get[FileNameJoin[{benchmarkDir, "oracle", "reference_bubble_oracle.wl"}]];
Get[FileNameJoin[{benchmarkDir, "oracle", "expected_output_helpers.wl"}]];


(* ::Chapter:: *)
(*扁平 expected*)

routeFamily["direct-h"] := familyDefinition;
routeFamily["bare-H"] := Join[
   familyDefinition,
   <|"lineData" -> (
      Join[#1, <|"bbType" -> "H"|>] & /@ familyDefinition["lineData"]
      )|>
   ];

appendRelationRoute[records_List, route_] := Map[
   Function[record,
    Join[record, <|"tags" -> Append[record["tags"], "basisRoute:" <> route]|>]
    ],
   records
   ];

appendDerivativeRoute[records_List, route_] := Map[
   Function[record,
    Join[record, <|
      "mode" -> route,
      "tags" -> Append[record["tags"], "basisRoute:" <> route]
      |>]
    ],
   records
   ];

directHRelations = Join[
   generateTimeExpected[routeFamily["direct-h"]],
   generateMomentumExpected[routeFamily["direct-h"]]
   ];
bareHRelations = Join[
   generateTimeExpected[routeFamily["bare-H"]],
   generateMomentumExpected[routeFamily["bare-H"]]
   ];
directHDerivatives = generateDerivativeExpected[routeFamily["direct-h"]];
bareHDerivatives = generateDerivativeExpected[routeFamily["bare-H"]];

expectedRelations = Join[
   appendRelationRoute[directHRelations, "direct-h"],
   appendRelationRoute[bareHRelations, "bare-H"],
   appendRelationRoute[directHRelations, "H-to-h"]
   ];
expectedDerivatives = Join[
   appendDerivativeRoute[directHDerivatives, "direct-h"],
   appendDerivativeRoute[bareHDerivatives, "bare-H"],
   appendDerivativeRoute[directHDerivatives, "H-to-h"]
   ];
expectedSummary = Join[
   expectedOutputSummary[expectedRelations, expectedDerivatives],
   <|
    "relationCountByRoute" -> <|
      "direct-h" -> Length[directHRelations],
      "bare-H" -> Length[bareHRelations],
      "H-to-h" -> Length[directHRelations]
      |>,
    "derivativeCountByRoute" -> <|
      "direct-h" -> Length[directHDerivatives],
      "bare-H" -> Length[bareHDerivatives],
      "H-to-h" -> Length[directHDerivatives]
      |>,
    "referenceDerivativeCount" -> Length[referenceExpectedDerivatives],
    "referenceSymmetryCount" -> Length[referenceSymmetryExpected],
    "referenceParityCount" -> Length[referenceParityExpected]
    |>
   ];
