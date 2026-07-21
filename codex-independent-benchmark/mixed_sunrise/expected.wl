(* ::Package:: *)
(* 独立展开 mixed sunrise 的六 momentum generators、ISP 导数与 s11 总导数。 *)

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
