(* ::Package:: *)
(* 独立展开 arbitrary-name two-loop family 的六 momentum generators 与 ISP 自身导数。 *)

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
