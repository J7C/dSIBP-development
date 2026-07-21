(* ::Package:: *)
(* 按补全 ISP 后的任务书生成三组 time、momentum 与 general derivative expected。 *)

familyDir = DirectoryName[$InputFileName];
benchmarkDir = DirectoryName[familyDir];
Get[FileNameJoin[{benchmarkDir, "oracle", "independent_oracle.wl"}]];
Get[FileNameJoin[{familyDir, "family.wl"}]];
Get[FileNameJoin[{benchmarkDir, "oracle", "expected_output_helpers.wl"}]];


(* ::Chapter:: *)
(*扁平 expected*)

(* energy case 只作为审计 tag；relation 的六字段结构保持不变。 *)
appendEnergyCaseTag[records_List, family_Association] := (
    Join[#1, <|
       "tags" -> Append[#1["tags"], "energyCase" <> family["energyCase"]]
       |>] &
    ) /@ records;


expectedTimeRelations = Flatten@Table[
    appendEnergyCaseTag[generateTimeExpected[family], family],
    {family, familyDefinitions}];

expectedMomentumRelations = Flatten@Table[
    appendEnergyCaseTag[generateMomentumExpected[family], family],
    {family, familyDefinitions}];

expectedRelations = Join[expectedTimeRelations, expectedMomentumRelations];

expectedDerivatives = Flatten@Table[
    appendEnergyCaseTag[generateDerivativeExpected[family], family],
    {family, familyDefinitions}];

scalarClosureReports = Table[
   <|"energyCase" -> family["energyCase"],
    "reduction" -> scalarReductionData[family]|>,
   {family, familyDefinitions}
   ];

expectedSummary = Join[
  expectedOutputSummary[expectedRelations, expectedDerivatives],
  <|
   "status" -> "complete",
   "timeRelationCount" -> Length[expectedTimeRelations],
   "momentumRelationCount" -> Length[expectedMomentumRelations],
   "neededLoopScalarProducts" -> {sp[ell, ell], sp[ell, k]},
   "providedDenominatorSquares" -> 1,
   "providedISPCount" -> 1,
   "missingISPCount" -> 0,
   "ispSeedPoints" -> {{0}, {1}}
   |>
  ];
