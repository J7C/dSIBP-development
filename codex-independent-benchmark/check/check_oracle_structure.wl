(* ::Package:: *)
(* 本脚本只加载独立 expected，汇总结构门禁；不加载 package。 *)

checkDir = DirectoryName[$InputFileName];
benchmarkDir = DirectoryName[checkDir];


(* ::Chapter:: *)
(*逐 family 独立加载*)

familyDirs = {
   "atomic_massless_line", "pure_massless_bubble", "mixed_bubble",
   "mixed_triangle", "mixed_sunrise", "pure_massive_bubble_reference",
   "two_loop_isp_toy", "parallel_massless_bundle_guard"
   };


(* 对所有 sij 导数要求显式记录任务书固定的 upper-triangular Dij raw representative。 *)
externalInvariantBasisTaggedQ[family_Association, derivatives_List] := Module[
   {variables = externalInvariantVariables[family], invariantRecords},
   invariantRecords = Select[
     derivatives,
     MemberQ[variables, Lookup[#1, "variable", Missing["variable"]]] &
     ];
   And @@ (
     MemberQ[Lookup[#1, "tags", {}], "upperTriangularDijBasis"] & /@
      invariantRecords
     )
   ];


oracleStructureRows = Table[
   Get[FileNameJoin[{benchmarkDir, familyName, "expected.wl"}]];
   <|
    "family" -> familyName,
    "summary" -> expectedSummary,
    "externalInvariantBasisTaggedQ" ->
     externalInvariantBasisTaggedQ[familyDefinition, expectedDerivatives]
    |>,
   {familyName, familyDirs}
   ];

Get[FileNameJoin[{benchmarkDir, "vertex_energy_signs", "expected.wl"}]];
vertexEnergyStructure = expectedSummary;
vertexEnergyBasisTaggedQ = externalInvariantBasisTaggedQ[
   familyDefinition, expectedDerivatives
   ];
vertexEnergyISPSeedValues = Sort@DeleteDuplicates@Cases[
    Lookup[expectedRelations, "seedRules"],
    HoldPattern[ispN[1] -> value_] :> value,
    Infinity
    ];

oracleStructurePassQ = And @@ (
    TrueQ[#1["summary"]["relationFieldShapeQ"]] &&
      TrueQ[#1["summary"]["derivativeFieldShapeQ"]] &&
      TrueQ[#1["summary"]["linearInJQ"]] &&
      TrueQ[#1["summary"]["absorbedQ"]] &&
      TrueQ[#1["summary"]["forbiddenMassiveNQ"]] &&
      TrueQ[#1["externalInvariantBasisTaggedQ"]] & /@
     oracleStructureRows
    ) &&
   vertexEnergyStructure["status"] === "complete" &&
   TrueQ[vertexEnergyStructure["relationFieldShapeQ"]] &&
   TrueQ[vertexEnergyStructure["derivativeFieldShapeQ"]] &&
   TrueQ[vertexEnergyStructure["linearInJQ"]] &&
   TrueQ[vertexEnergyStructure["absorbedQ"]] &&
   TrueQ[vertexEnergyStructure["forbiddenMassiveNQ"]] &&
   TrueQ[vertexEnergyBasisTaggedQ] &&
   vertexEnergyISPSeedValues === {0, 1};

Print[InputForm[<|
   "families" -> oracleStructureRows,
   "vertexEnergy" -> vertexEnergyStructure,
   "vertexEnergyBasisTaggedQ" -> vertexEnergyBasisTaggedQ,
   "vertexEnergyISPSeedValues" -> vertexEnergyISPSeedValues,
   "passQ" -> oracleStructurePassQ
   |>]];

If[! TrueQ[oracleStructurePassQ], Exit[1]];
