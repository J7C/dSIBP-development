(* ::Package:: *)
(* atomic_massless_line：逐条比较独立手推 expected 与 009 actual。 *)

(* ::Chapter:: *)
(*初始化*)

exampleDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[DirectoryName[exampleDir]];
handDerivedDir = FileNameJoin[{codeDir, "check", "hand-derived-v2", "atomic_massless_line"}];
Get[FileNameJoin[{codeDir, "009_dS_ibp_general.wl"}]];
Get[FileNameJoin[{handDerivedDir, "family.wl"}]];
Get[FileNameJoin[{handDerivedDir, "expected.wl"}]];

topologyCache = Association[];
getTopTopology[signKey_String] := If[
   KeyExistsQ[topologyCache, signKey],
   topologyCache[signKey],
   topologyCache[signKey] = parseTopology[makeAtomicMasslessCase[signKey]]
   ];

getSectorTopology[signKey_String, "top"] := getTopTopology[signKey];
getSectorTopology[signKey_String, "e1"] := shrinkSectorTopology[getTopTopology[signKey], {1}];

relationActual[relation_Association] := Module[
   {topo, int, generatorLabel, generator, raw},
   topo = getSectorTopology[relation["vertexSigns"], relation["sector"]];
   int = makeBaseIntegral[topo] /. relation["seedRules"];
   generatorLabel = relation["generator"];
   generator = First @ Select[
      makeIBPGenerators[topo],
      If[First[generatorLabel] === "time",
        timeGeneratorLabel[#] === generatorLabel,
        momentumGeneratorLabel[#] === generatorLabel
        ] &
      ];
   raw = If[First[generatorLabel] === "time",
     applyTimeGeneratorSeed[topo, int, generator],
     applyMomentumGeneratorSeed[topo, int, generator]
     ];
   applySeedCanonical[raw, topo]
   ];

relationResults = MapIndexed[
   Function[{relation, index},
    Module[{actual, pass},
     actual = Expand[relationActual[relation]];
     pass = TrueQ[Expand[actual - relation["equation"]] === 0];
     <|
      "index" -> First[index],
      "sector" -> relation["sector"],
      "vertexSigns" -> relation["vertexSigns"],
      "generator" -> relation["generator"],
      "passQ" -> pass,
      "actual" -> actual,
      "expected" -> relation["equation"]
      |>
     ]
    ],
   expectedRelations
   ];

(* ::Chapter:: *)
(*额外原子检查*)

topPP = getTopTopology["++"];
reversedPP = parseTopology[makeAtomicMasslessCase["++", True]];
intN0 = J[{0, 0}, {{0, 0}}, {}];
intN1 = J[{0, 0}, {{0, 1}}, {}];

firstDerivativeN0 = timeMasslessEndpointDerivativeTerms[topPP, intN0, v1];
firstDerivativeN1 = timeMasslessEndpointDerivativeTerms[topPP, intN1, v1];

coincidentTopo = Join[
   topPP,
   <|"lines" -> {Join[topPP["lines"][[1]], <|"endpoints" -> {v1, v1}|>]}|>
   ];

atomicActual = <|
   "reversedEndpointAtV1N0" ->
     Expand[timeMasslessEndpointDerivativeTerms[reversedPP, intN0, v1]],
   "reversedEndpointAtV1N1Regular" ->
     Expand[timeMasslessEndpointDerivativeTerms[reversedPP, intN1, v1]],
   "sameEndpointSecondDerivativeN0" ->
     Expand[firstDerivativeN0 /. x_J :> timeMasslessEndpointDerivativeTerms[topPP, x, v1]],
   "sameEndpointSecondDerivativeN1" ->
     Expand[firstDerivativeN1 /. x_J :> timeMasslessEndpointDerivativeTerms[topPP, x, v1]],
   "boundaryFirstEndpointN1" ->
     Expand[timeThetaBoundaryShrinkTerms[topPP, intN1, v1]],
   "boundarySecondEndpointN1" ->
     Expand[timeThetaBoundaryShrinkTerms[topPP, intN1, v2]],
   "coincidentAntisymmetricN1" ->
     applyMasslessEndpointCanonical[intN1, coincidentTopo],
   "spIsOrderless" ->
     MemberQ[Attributes[sp], Orderless]
   |>;

atomicResults = Map[
   Function[item,
    <|
     "name" -> item["name"],
     "passQ" -> TrueQ[
       If[BooleanQ[item["expected"]],
        atomicActual[item["name"]] === item["expected"],
        Expand[atomicActual[item["name"]] - item["expected"]] === 0
        ]
       ],
     "actual" -> atomicActual[item["name"]],
     "expected" -> item["expected"]
     |>
    ],
   atomicExpected
   ];

(* ::Chapter:: *)
(*报告*)

failedRelations = Select[relationResults, ! TrueQ[#["passQ"]] &];
failedAtomic = Select[atomicResults, ! TrueQ[#["passQ"]] &];

Print["atomic_massless_line relations: ", Count[Lookup[relationResults, "passQ"], True], "/", Length[relationResults]];
Print["atomic_massless_line atomic: ", Count[Lookup[atomicResults, "passQ"], True], "/", Length[atomicResults]];

If[failedRelations =!= {}, Print["Failed relations: ", failedRelations]];
If[failedAtomic =!= {}, Print["Failed atomic checks: ", failedAtomic]];

If[Length[expectedRelations] =!= 22 || failedRelations =!= {} || failedAtomic =!= {}, Exit[1]];
