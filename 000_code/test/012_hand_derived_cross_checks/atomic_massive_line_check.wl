(* ::Package:: *)
(* atomic_massive_line：逐条比较参考 Vpm 手推 expected 与主线 actual。 *)

(* ::Chapter:: *)
(*初始化*)

exampleDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[DirectoryName[exampleDir]];
handDerivedDir = FileNameJoin[{codeDir, "test", "012_hand-derived", "atomic_massive_line"}];
versionUnderTest = Last[Select[$ScriptCommandLine, MemberQ[{"007", "008", "009", "010", "011", "012"}, #] &], Environment["DSIBP_VERSION"]];
If[!MemberQ[{"007", "008", "009", "010", "011", "012"}, versionUnderTest], versionUnderTest = "012"];
Get[FileNameJoin[{codeDir, versionUnderTest <> "_dS_ibp_general.wl"}]];
Get[FileNameJoin[{handDerivedDir, "family.wl"}]];
Get[FileNameJoin[{handDerivedDir, "expected.wl"}]];

topologyCache = Association[];
getTopTopology[signKey_String, mode_String] := Module[
   {key = signKey <> ":" <> mode},
   If[
    KeyExistsQ[topologyCache, key],
    topologyCache[key],
    topologyCache[key] = parseTopology[
      makeAtomicMassiveCase[signKey, mode]
      ]
    ]
   ];

getSectorTopology[signKey_String, mode_String, "top"] :=
   getTopTopology[signKey, mode];
getSectorTopology[signKey_String, mode_String, "e1"] :=
   shrinkSectorTopology[getTopTopology[signKey, mode], {1}];

relationActual[relation_Association] := Module[
   {topo, int, label, generator, raw},
   topo = getSectorTopology[
     relation["vertexSigns"], relation["mode"], relation["sector"]];
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
     actual = Expand[relationActual[relation]];
     difference = Expand[actual - relation["equation"]];
     <|
      "index" -> First[index],
      "mode" -> relation["mode"],
      "sector" -> relation["sector"],
      "vertexSigns" -> relation["vertexSigns"],
      "generator" -> relation["generator"],
      "tags" -> relation["tags"],
      "passQ" -> TrueQ[difference === 0],
      "difference" -> difference
      |>
     ]
    ],
   expectedRelations
   ];

failed = Select[relationResults, ! TrueQ[#["passQ"]] &];
failedBySign = If[failed === {}, <||>, Counts[Lookup[failed, "vertexSigns"]]];
failedByMode = If[failed === {}, <||>, Counts[Lookup[failed, "mode"]]];

Print["atomic_massive_line relations: ",
  Count[Lookup[relationResults, "passQ"], True], "/", Length[relationResults]];
Print["package version: ", versionUnderTest];
Print["failed by sign: ", failedBySign];
Print["failed by mode: ", failedByMode];

If[Length[expectedRelations] =!= 104, Print["Unexpected relation count."]; Exit[1]];
If[failed =!= {},
 Print["First failed relations: ", Take[failed, UpTo[8]]];
 Exit[1]
 ];
