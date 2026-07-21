(* ::Package:: *)
(* pure_massless_bubble：70 条全 SK、全 sector、全生成元独立对照。 *)

(* ::Chapter:: *)
(*初始化*)

exampleDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[DirectoryName[exampleDir]];
handDerivedDir = FileNameJoin[{codeDir, "check", "hand-derived-v2", "pure_massless_bubble"}];
Get[FileNameJoin[{codeDir, "011_dS_ibp_general.wl"}]];
Get[FileNameJoin[{handDerivedDir, "family.wl"}]];
Get[FileNameJoin[{handDerivedDir, "expected.wl"}]];

topologyCache = Association[];
getBubbleTop[signKey_String] := If[
   KeyExistsQ[topologyCache, signKey],
   topologyCache[signKey],
   topologyCache[signKey] = parseTopology[
     makePureMasslessBubbleCase[signKey]
     ]
   ];

getBubbleSector[signKey_String, "top"] := getBubbleTop[signKey];
getBubbleSector[signKey_String, sector_String] := shrinkSectorTopology[
   getBubbleTop[signKey],
   manualBubbleShrunkLines[sector]
   ];

bubbleRelationActual[relation_Association] := Module[
   {topo, int, label, generator, raw},
   topo = getBubbleSector[relation["vertexSigns"], relation["sector"]];
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
     actual = Expand[bubbleRelationActual[relation] /. kk[1, 1] -> s11];
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
expectedCounts = <|
   {"++", "top"} -> 16, {"++", "e1"} -> 6,
   {"++", "e2"} -> 6, {"++", "e1_e2"} -> 3,
   {"--", "top"} -> 16, {"--", "e1"} -> 6,
   {"--", "e2"} -> 6, {"--", "e1_e2"} -> 3,
   {"+-", "top"} -> 4, {"-+", "top"} -> 4
   |>;

Print["pure_massless_bubble relations: ",
  Count[Lookup[relationResults, "passQ"], True], "/", Length[relationResults]];
Print["relation counts correct: ", SameQ[actualCounts, expectedCounts]];
Print["failed by sector: ", failedBySector];
Print["failed by sign: ", failedBySign];

If[Length[expectedRelations] =!= 70 || ! SameQ[actualCounts, expectedCounts],
 Print["Unexpected coverage count."]; Exit[1]
 ];

If[failed =!= {},
 Print["First failed relations: ", Take[failed, UpTo[12]]];
 Exit[1]
 ];
