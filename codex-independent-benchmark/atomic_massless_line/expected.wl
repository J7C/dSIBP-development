(* ::Package:: *)
(* 从独立 massless kernel oracle 展开全部 atomic seed；不加载 package。 *)

familyDir = DirectoryName[$InputFileName];
benchmarkDir = DirectoryName[familyDir];
Get[FileNameJoin[{benchmarkDir, "oracle", "independent_oracle.wl"}]];
Get[FileNameJoin[{familyDir, "family.wl"}]];
Get[FileNameJoin[{benchmarkDir, "oracle", "expected_output_helpers.wl"}]];


(* ::Chapter:: *)
(*扁平 expected*)

expectedRelations = Join[
   generateTimeExpected[familyDefinition],
   generateMomentumExpected[familyDefinition]
   ];
expectedDerivatives = generateDerivativeExpected[familyDefinition];
expectedSummary = expectedOutputSummary[expectedRelations, expectedDerivatives];
