(* ::Package:: *)
(* 本脚本诊断 parallel_massless_bundle_guard 的外不变量导数差异。
   它先在独立 oracle 中固定一个 general-index top 积分，再加载 package，分别比较
   四个 D_ij directional seed、当前 upper-triangular 基底和历史 {D11,D12,D21} 基底。 *)


(* ::Chapter:: *)
(*独立 oracle 基线*)

checkDir = DirectoryName[$InputFileName];
benchmarkDir = DirectoryName[checkDir];
workspaceDir = DirectoryName[benchmarkDir];

Get[FileNameJoin[{benchmarkDir, "oracle", "independent_oracle.wl"}]];
Get[FileNameJoin[{benchmarkDir, "oracle", "benchmark_family_definitions.wl"}]];

diagnosticFamily = Join[
   parallelMasslessBundleFamily,
   <|"vertexSignCases" -> <|"--" -> {-1, -1}, "+-" -> {1, -1}|>|>
   ];
diagnosticSectors = reachableSectors[diagnosticFamily, "--"];
diagnosticSector = SelectFirst[diagnosticSectors, #1["name"] === "top" &];
diagnosticChoice = First[extremeDiscreteChoices[diagnosticFamily, diagnosticSector]];
diagnosticIndex = makeGeneralIndex[diagnosticFamily, diagnosticSector, diagnosticChoice];
diagnosticIntegral = indexToJ[diagnosticFamily, diagnosticSector, diagnosticIndex];
diagnosticReduction = scalarReductionData[diagnosticFamily];

oracleOperators = externalOperators[diagnosticFamily];
oracleBasisOperators = externalOperatorBasis[diagnosticFamily];
oracleBasisPositions = (
     First@FirstPosition[oracleOperators, #1]
     ) & /@ oracleBasisOperators;
oracleInvariantMatrix = invariantDirectionalMatrix[diagnosticFamily];
historicalBasisPositions = {1, 2, 3};
oracleIndependentRows = independentInvariantRows[oracleInvariantMatrix];
oracleDirectionalSeeds = externalDirectionalJ[
      diagnosticFamily, diagnosticReduction, diagnosticSector, diagnosticIndex, #1
      ] & /@ oracleOperators;
oracleInvariantSeeds = externalInvariantDerivatives[
   diagnosticFamily, diagnosticReduction, diagnosticSector, diagnosticIndex
   ];


(* ::Chapter:: *)
(*Package 同 topology 与 directional seed*)

Get[FileNameJoin[{workspaceDir, "independent-benchmark", "package", "package_012.wl"}]];

diagnosticCase = <|
   "name" -> "diagnose_parallel_derivative_basis",
   "vertexData" -> {{v1, "-"}, {v2, "-"}},
   "lineData" -> diagnosticFamily["lineData"],
   "loopMomenta" -> diagnosticFamily["loopMomenta"],
   "externalMomenta" -> diagnosticFamily["externalMomenta"],
   "externalInvariantRules" -> diagnosticFamily["externalInvariantRules"],
   "vertexEnergies" -> diagnosticFamily["vertexEnergies"],
   "ispData" -> {},
   "zeroPointRules" -> diagnosticFamily["zeroPointRules"],
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;
diagnosticTopology = parseTopology[diagnosticCase];
packageOperators = externalVectorDerivativeGenerators[diagnosticTopology];
packageUpperOperators = externalVectorDerivativeGeneratorBasis[
   diagnosticTopology, "upperTriangular"
   ];

packageDirectionalSeeds = (
      rep2outform[
         applyExternalVectorDerivativeSeed[diagnosticTopology, diagnosticIntegral, #1],
         diagnosticTopology
         ] /. dim -> d
      ) & /@ packageOperators;
directionalDifferences = Expand[packageDirectionalSeeds - oracleDirectionalSeeds];
directionalAgreementQ = And @@ (
    TrueQ[#1 === 0] || TrueQ[Quiet[FullSimplify[#1 == 0]]] & /@ directionalDifferences
    );


(* ::Chapter:: *)
(*当前与历史反解基底*)

packageDefaultDecompositions = makeExternalInvariantDerivativeDecomposition[
      diagnosticTopology, #1
      ] & /@ {s11, s12, s22};
packageOracleBasisDecompositions = makeExternalInvariantDerivativeDecomposition[
      diagnosticTopology, #1,
      ExternalVectorOperatorBasis -> packageOperators[[oracleBasisPositions]]
      ] & /@ {s11, s12, s22};
packageHistoricalBasisDecompositions = makeExternalInvariantDerivativeDecomposition[
      diagnosticTopology, #1,
      ExternalVectorOperatorBasis -> packageOperators[[historicalBasisPositions]]
      ] & /@ {s11, s12, s22};

packageDefaultSeeds = (
      rep2outform[
         applyExternalInvariantVariableDerivativeSeed[
          diagnosticTopology, diagnosticIntegral, #1
          ],
         diagnosticTopology
         ] /. dim -> d
      ) & /@ {s11, s12, s22};
packageOracleBasisSeeds = (
      rep2outform[
         applyExternalInvariantVariableDerivativeSeed[
          diagnosticTopology, diagnosticIntegral, #1,
          ExternalVectorOperatorBasis -> packageOperators[[oracleBasisPositions]]
          ],
         diagnosticTopology
         ] /. dim -> d
      ) & /@ {s11, s12, s22};
packageHistoricalBasisSeeds = (
      rep2outform[
         applyExternalInvariantVariableDerivativeSeed[
          diagnosticTopology, diagnosticIntegral, #1,
          ExternalVectorOperatorBasis -> packageOperators[[historicalBasisPositions]]
          ],
         diagnosticTopology
         ] /. dim -> d
      ) & /@ {s11, s12, s22};
oracleInvariantSeedList = Lookup[oracleInvariantSeeds, {s11, s12, s22}];

oracleBasisDifferences = Expand[packageOracleBasisSeeds - oracleInvariantSeedList];
oracleBasisAgreementQ = And @@ (
    TrueQ[#1 === 0] || TrueQ[Quiet[FullSimplify[#1 == 0]]] & /@ oracleBasisDifferences
    );
defaultBasisDifferences = Expand[packageDefaultSeeds - oracleInvariantSeedList];
defaultBasisAgreementQ = And @@ (
    TrueQ[#1 === 0] || TrueQ[Quiet[FullSimplify[#1 == 0]]] & /@ defaultBasisDifferences
    );
defaultHistoricalDifferences = Expand[packageDefaultSeeds - packageHistoricalBasisSeeds];
defaultHistoricalNonzeroDifferenceCount = Count[
   defaultHistoricalDifferences,
   difference_ /; ! (TrueQ[difference === 0] ||
      TrueQ[Quiet[FullSimplify[difference == 0]]])
   ];


(* ::Chapter:: *)
(*诊断摘要*)

diagnosticSummary = <|
   "oracleInvariantMatrix" -> oracleInvariantMatrix,
   "oracleIndependentRows" -> oracleIndependentRows,
   "currentOracleBasisPositionsInAllDij" -> oracleBasisPositions,
   "historicalBasisPositionsInAllDij" -> historicalBasisPositions,
   "packageUpperTriangularLabels" -> (
     externalVectorDerivativeLabel /@ packageUpperOperators
     ),
   "packageDefaultResiduals" -> Lookup[packageDefaultDecompositions, "residual"],
   "packageOracleBasisResiduals" -> Lookup[packageOracleBasisDecompositions, "residual"],
   "packageHistoricalBasisResiduals" -> Lookup[packageHistoricalBasisDecompositions, "residual"],
   "directionalAgreementQ" -> directionalAgreementQ,
   "oracleBasisAgreementQ" -> oracleBasisAgreementQ,
   "defaultBasisAgreementQ" -> defaultBasisAgreementQ,
   "defaultNonzeroDifferenceCount" -> Count[
     defaultBasisDifferences,
     difference_ /; ! (TrueQ[difference === 0] ||
        TrueQ[Quiet[FullSimplify[difference == 0]]])
     ],
   "defaultVsHistoricalNonzeroDifferenceCount" -> defaultHistoricalNonzeroDifferenceCount
   |>;

Print[InputForm[diagnosticSummary]];
If[! TrueQ[
    directionalAgreementQ && oracleBasisAgreementQ && defaultBasisAgreementQ &&
     defaultHistoricalNonzeroDifferenceCount === 3
    ], Exit[1]];
