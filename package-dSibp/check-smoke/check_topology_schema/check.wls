(* ::Package:: *)
(* 本文件检查当前 topology schema、顶点相位和内部 contact-sector constructor。
   输入只使用现行公开字段；检查不生成大规模 seed 或运行 reduction。 *)


(* ::Chapter:: *)
(*加载当前模块包*)

checkDirectory = DirectoryName[$InputFileName];
Get[FileNameJoin[{checkDirectory, "..", "_harness.wls"}]];
packageFile = FileNameJoin[{
    checkDirectory, "..", "..", "versions", "023_dSIBP", "Kernel", "dSIBP.wl"
    }] // ExpandFileName;
dsSmokeLoadPackage[packageFile];


(* ::Chapter:: *)
(*构造新 schema 输入*)

topologyInput = <|
   "name" -> "current_schema_smoke",
   "vertices" -> {
     <|"id" -> 1, "vertexType" -> "+", "externalLegEnergy" -> E1|>,
     <|"id" -> 2, "vertexType" -> "-", "externalLegEnergy" -> E2|>
     },
   "lines" -> {
     <|
      "id" -> 1,
      "massType" -> "massless",
      "endpoints" -> {1, 2},
      "momentum" -> k,
      "note" -> "extra input keys are ignored"
      |>
     },
   "loopMomenta" -> {},
   "independentExternalMomenta" -> {k},
   "note" -> "topology smoke"
   |>;

topology = dSIBP`Private`parseTopology[topologyInput];
line = If[AssociationQ[topology], First[topology["lines"]], <||>];


(* ::Chapter:: *)
(*断言与退出码*)

missingRequiredInput = <|
   "loopMomenta" -> {}
   |>;
missingRequiredReport = dSIBP`Private`caseInputRequirementReport[missingRequiredInput];

massiveWithoutNuInput = Join[
   topologyInput,
   <|"lines" -> {<|"id" -> 1, "massType" -> "massive", "endpoints" -> {1, 2}, "momentum" -> k|>}|>
   ];
massiveWithoutNuReport = dSIBP`Private`caseInputRequirementReport[massiveWithoutNuInput];

sameBranchInput = Join[
   topologyInput,
   <|
    "vertices" -> {
      <|"id" -> 1, "vertexType" -> "+", "externalLegEnergy" -> E1|>,
      <|"id" -> 2, "vertexType" -> "+", "externalLegEnergy" -> E2|>
      },
    "lines" -> {<|"id" -> 1, "massType" -> "massless", "endpoints" -> {1, 2}, "momentum" -> k|>}
    |>
   ];
sameBranchTopology = dSIBP`Private`parseTopology[sameBranchInput];
contractedTopology = If[
   AssociationQ[sameBranchTopology],
   dSIBP`Private`shrinkSectorTopology[sameBranchTopology, {1}],
   $Failed
   ];

checks = <|
   "version023" -> SameQ[dSIBP`$dSIBPVersion, "023.0"],
   "newSchemaParsed" -> AssociationQ[topology],
   "vertexAssociationsRetained" -> SameQ[Lookup[topology["vertices"], "id"], {1, 2}],
   "plusPhaseCoefficient" -> SameQ[dSIBP`Private`vertexExternalPhaseDerivativeCoefficient[topology, 1], -I],
    "minusPhaseCoefficient" -> SameQ[dSIBP`Private`vertexExternalPhaseDerivativeCoefficient[topology, 2], I],
   "vertexEnergyAuthority" -> SameQ[dSIBP`Private`rawVertexExternalEnergy[topology, 1], E1],
   "lineSKDerivedFromVertices" -> SameQ[Lookup[line, "skType"], "+-"],
   "linePackDerivedFromMassAndSK" -> SameQ[Lookup[line, "packType"], "masslessCross"],
   "extraKeysIgnored" -> ! KeyExistsQ[line, "note"],
   "missingRequiredKeysRejected" ->
    Sort[missingRequiredReport["missingRequiredKeys"]] === {"lines", "vertices"},
   "massiveNuRequired" -> MemberQ[
     Lookup[massiveWithoutNuReport["malformedInputIssues"], "code", {}],
     "linesMissingRequiredKeys"
     ],
   "contactSectorConstructedInternally" -> AssociationQ[contractedTopology],
   "contactSectorActiveVertexMerged" -> SameQ[Lookup[contractedTopology, "activeVertexIds", {}], {1}],
   "contactSectorRepresentativeMap" -> SameQ[
     Lookup[contractedTopology, "sectorVertexRepresentativeMap", <||>],
     <|1 -> 1, 2 -> 1|>
     ],
   "contactSectorExternalEnergyMerged" -> SameQ[
     Lookup[contractedTopology, "sectorExternalLegEnergyByVertex", <||>],
     <|1 -> E1 + E2|>
     ]
   |>;

Print[checks];
If[And @@ Values[checks], Exit[0], Exit[1]];
