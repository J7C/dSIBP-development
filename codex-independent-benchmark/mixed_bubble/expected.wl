(* ::Package:: *)
(* 独立展开 mixed massive h + massless bubble 的全部 seed 与总导数。 *)

familyDir = DirectoryName[$InputFileName];
benchmarkDir = DirectoryName[familyDir];
Get[FileNameJoin[{benchmarkDir, "oracle", "independent_oracle.wl"}]];
Get[FileNameJoin[{familyDir, "family.wl"}]];
Get[FileNameJoin[{benchmarkDir, "oracle", "expected_output_helpers.wl"}]];


(* ::Chapter:: *)
(*扁平 expected*)

expectedRelations = Join[generateTimeExpected[familyDefinition], generateMomentumExpected[familyDefinition]];
expectedDerivatives = generateDerivativeExpected[familyDefinition];
expectedSummary = expectedOutputSummary[expectedRelations, expectedDerivatives];
