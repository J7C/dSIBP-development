(* ::Package:: *)
(* mixed_sunrise：读取独立 expected，并作为 012 程序包交叉验证 test。 *)

(* ::Chapter:: *)
(*初始化*)

exampleDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[DirectoryName[exampleDir]];
handDerivedDir = FileNameJoin[{codeDir, "test", "012_hand-derived", "mixed_sunrise"}];
Get[FileNameJoin[{codeDir, "012_dS_ibp_general.wl"}]];
Get[FileNameJoin[{handDerivedDir, "family.wl"}]];
Get[FileNameJoin[{handDerivedDir, "expected.wl"}]];

topologyCache = Association[];
getMixedSunriseTop[signKey_String] := If[
   KeyExistsQ[topologyCache, signKey],
   topologyCache[signKey],
   topologyCache[signKey] = parseTopology[makeMixedSunriseCase[signKey]]
   ];

getMixedSunriseSector[signKey_String, "top"] := getMixedSunriseTop[signKey];
getMixedSunriseSector[signKey_String, sector_String] := shrinkSectorTopology[
   getMixedSunriseTop[signKey],
   manualShrunkLines[sector]
   ];

mixedSunriseActual[relation_Association] := Module[
   {topo, int, label, generator, raw},
   topo = getMixedSunriseSector[relation["vertexSigns"], relation["sector"]];
   int = makeBaseIntegral[topo] /. relation["seedRules"];
   label = relation["generator"];
   generator = First @ Select[
      makeIBPGenerators[topo],
      If[First[label] === "time",
        timeGeneratorLabel[#] === label,
        momentumGeneratorLabel[#] === label
        ] &
      ];
   raw = If[First[label] === "time",
     applyTimeGeneratorSeed[topo, int, generator],
     applyMomentumGeneratorSeed[topo, int, generator]
     ];
   applySeedCanonical[raw, topo]
   ];

(* ::Chapter:: *)
(*逐条比较*)

relationResults = MapIndexed[
   Function[{relation, index},
    Module[{actual, difference},
     actual = Expand[mixedSunriseActual[relation] /. {kk[1, 1] -> s11}];
     difference = Expand[actual - relation["equation"]];
     <|
      "index" -> First[index],
      "sector" -> relation["sector"],
      "vertexSigns" -> relation["vertexSigns"],
      "generator" -> relation["generator"],
      "seedRules" -> relation["seedRules"],
      "tags" -> relation["tags"],
      "passQ" -> TrueQ[difference === 0],
      "difference" -> difference
      |>
     ]
    ],
   expectedRelations
   ];

failed = Select[relationResults, ! TrueQ[#["passQ"]] &];
actualCounts = Counts[({#["vertexSigns"], #["sector"]} &) /@ expectedRelations];

Print["mixed_sunrise relations: ",
  Count[Lookup[relationResults, "passQ"], True], "/", Length[relationResults]];
Print["relation counts correct: ", SameQ[actualCounts, mixedSunriseExpectedCounts]];
Print["expected total: ", mixedSunriseExpectedTotal];

If[! SameQ[actualCounts, mixedSunriseExpectedCounts], Exit[1]];
If[failed =!= {}, Print["First failed relations: ", Take[failed, UpTo[12]]]; Exit[1]];
