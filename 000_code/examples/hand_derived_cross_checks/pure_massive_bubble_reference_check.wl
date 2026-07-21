(* ::Package:: *)
(* pure_massive_bubble_reference：读取独立 h/H expected，并作为 011 程序包交叉验证 example。 *)

(* ::Chapter:: *)
(*初始化*)

exampleDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[DirectoryName[exampleDir]];
handDerivedDir = FileNameJoin[{codeDir, "check", "hand-derived-v2", "pure_massive_bubble_reference"}];
Get[FileNameJoin[{codeDir, "011_dS_ibp_general.wl"}]];
Get[FileNameJoin[{handDerivedDir, "family.wl"}]];
Get[FileNameJoin[{handDerivedDir, "expected.wl"}]];

topologyCache = Association[];
getPureMassiveBubbleTop[signKey_String, mode_String] := Module[{key = mode <> ":" <> signKey}, If[
   KeyExistsQ[topologyCache, key],
   topologyCache[key],
   topologyCache[key] = parseTopology[makePureMassiveBubbleReferenceCase[signKey, mode]]
   ]
   ];

getPureMassiveBubbleSector[signKey_String, mode_String, "top"] := getPureMassiveBubbleTop[signKey, mode];
getPureMassiveBubbleSector[signKey_String, mode_String, sector_String] := shrinkSectorTopology[
   getPureMassiveBubbleTop[signKey, mode],
   manualShrunkLines[sector]
   ];

pureMassiveBubbleActual[relation_Association] := Module[
   {topo, int, label, generator, raw},
   topo = getPureMassiveBubbleSector[relation["vertexSigns"], relation["mode"], relation["sector"]];
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
     actual = Expand[pureMassiveBubbleActual[relation] /. {kk[1, 1] -> s11}];
     difference = Expand[actual - relation["equation"]];
     <|
      "index" -> First[index],
      "mode" -> relation["mode"],
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
actualCounts = Counts[({#["mode"], #["vertexSigns"], #["sector"]} &) /@ expectedRelations];

Print["pure_massive_bubble_reference relations: ",
  Count[Lookup[relationResults, "passQ"], True], "/", Length[relationResults]];
Print["relation counts correct: ", SameQ[actualCounts, pureMassiveBubbleExpectedCounts]];
Print["expected total: ", pureMassiveBubbleExpectedTotal];
Print["relations by mode: ", Counts[Lookup[expectedRelations, "mode"]]];

If[! SameQ[actualCounts, pureMassiveBubbleExpectedCounts], Exit[1]];
If[failed =!= {}, Print["First failed relations: ", Take[failed, UpTo[12]]]; Exit[1]];
