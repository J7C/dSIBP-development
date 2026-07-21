(* ::Package:: *)
(* vertex_energy_signs 的三组固定 energy cases；显式 ISP rho1=sp[ell,k] 闭合 momentum 坐标。 *)

familyDir = DirectoryName[$InputFileName];
benchmarkDir = DirectoryName[familyDir];
Get[FileNameJoin[{benchmarkDir, "oracle", "benchmark_family_definitions.wl"}]];


(* ::Chapter:: *)
(*函数族定义*)

familyDefinitions = vertexEnergyFamilies;
familyDefinition = Join[
   First[familyDefinitions],
   <|
    "name" -> "vertex_energy_signs",
    "energyCaseDefinitions" -> AssociationThread[
      Lookup[familyDefinitions, "energyCase"],
      Lookup[familyDefinitions, "vertexEnergies"]
      ]
    |>
   ];
