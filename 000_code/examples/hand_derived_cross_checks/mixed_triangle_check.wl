(* ::Package:: *)
(* mixed_triangle：读取独立手推 expected，并作为 009 程序包交叉验证 example。 *)

(* ::Chapter:: *)
(*初始化*)

exampleDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[DirectoryName[exampleDir]];
handDerivedDir = FileNameJoin[{codeDir, "check", "hand-derived-v2", "mixed_triangle"}];
Get[FileNameJoin[{codeDir, "009_dS_ibp_general.wl"}]];
Get[FileNameJoin[{handDerivedDir, "family.wl"}]];
Get[FileNameJoin[{handDerivedDir, "expected.wl"}]];

topologyCache = Association[];
getTriangleTop[signKey_String] := If[
   KeyExistsQ[topologyCache, signKey],
   topologyCache[signKey],
   topologyCache[signKey] = parseTopology[
     makeMixedTriangleCase[signKey]
     ]
   ];

getTriangleSector[signKey_String, "top"] := getTriangleTop[signKey];
getTriangleSector[signKey_String, sector_String] := shrinkSectorTopology[
   getTriangleTop[signKey],
   manualTriangleShrunkLines[sector]
   ];

triangleRelationActual[relation_Association] := Module[
   {topo, int, label, generator, raw},
   topo = getTriangleSector[relation["vertexSigns"], relation["sector"]];
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
     actual = Expand[triangleRelationActual[relation] /. {
          kk[1, 1] -> s11,
          kk[1, 2] -> s12,
          kk[2, 2] -> s22
          }];
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
failedBySector = If[failed === {}, <||>, Counts[Lookup[failed, "sector"]]];
failedBySign = If[failed === {}, <||>, Counts[Lookup[failed, "vertexSigns"]]];

actualCounts = Counts[
   ({#["vertexSigns"], #["sector"]} &) /@ expectedRelations
   ];

Print["mixed_triangle relations: ",
  Count[Lookup[relationResults, "passQ"], True], "/", Length[relationResults]];
Print["relation counts correct: ", SameQ[actualCounts, manualTriangleExpectedCounts]];
Print["expected total: ", manualTriangleExpectedTotal];
Print["failed by sector: ", failedBySector];
Print["failed by sign: ", failedBySign];

If[! SameQ[actualCounts, manualTriangleExpectedCounts],
 Print["Unexpected coverage count."]; Exit[1]
 ];

If[failed =!= {},
 Print["First failed relations: ", Take[failed, UpTo[12]]];
 Exit[1]
 ];
