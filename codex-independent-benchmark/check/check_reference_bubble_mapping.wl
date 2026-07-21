(* ::Package:: *)
(* 本脚本检查 reference bubble 的 80 条 k0/ks 导数映射及用户输入的 symmetry/parity。
   expected 在加载 package 前冻结；actual 只通过 package 的 ds 与 symmetry 公共层生成。 *)


(* ::Chapter:: *)
(*路径与冻结输入*)

checkDir = DirectoryName[$InputFileName];
benchmarkDir = DirectoryName[checkDir];
workspaceDir = DirectoryName[benchmarkDir];

Get[FileNameJoin[{
    benchmarkDir, "pure_massive_bubble_reference", "expected.wl"
    }]];
frozenReferenceDerivatives = referenceExpectedDerivatives;
frozenReferenceSymmetry = referenceSymmetryExpected;
frozenReferenceParity = referenceParityExpected;

Get[FileNameJoin[{
    workspaceDir, "independent-benchmark", "package", "package_012.wl"
    }]];


(* ::Chapter:: *)
(*Reference symmetry/parity 用户规则*)

swapReferencePack[{b_, nFirst_, nSecond_}] := {b, nSecond, nFirst};
swapReferencePack[{b_}] := {b};

lineSwapTransform[J[a_, {pack1_, pack2_}, isp_]] := J[a, {pack2, pack1}, isp];
vertexSwapTransform[J[{a1_, a2_}, packs_, isp_]] :=
  J[{a2, a1}, swapReferencePack /@ packs, isp];

lineCanonicalTransform[int_J] := First@SortBy[
   {int, lineSwapTransform[int]},
   ToString[#1, InputForm] &
   ];
vertexCanonicalTransform[int_J] := First@SortBy[
   {int, vertexSwapTransform[int]},
   ToString[#1, InputForm] &
   ];
combinedCanonicalTransform[int_J] :=
  vertexCanonicalTransform[lineCanonicalTransform[int]];

topFullIntegralQ[J[_, packs_, _]] :=
  Length[packs] === 2 && And @@ (Length[#1] === 3 & /@ packs);
r2IntegralQ[J[_, packs_, _]] :=
  Length[packs] === 2 && Length[packs[[1]]] === 3 && Length[packs[[2]]] === 1;
r1EndpointSwapQ[J[_, packs_, _]] :=
  Length[packs] === 2 && Length[packs[[1]]] === 1 &&
   Length[packs[[2]]] === 3 && packs[[2, {2, 3}]] === {1, 0};

topParityOddQ[J[_, {{b1_, n1_, n2_}, {b2_, n3_, n4_}}, _]] :=
  And @@ (IntegerQ /@ {b1, n1, n2, b2, n3, n4}) &&
   (OddQ[n1 + n2 + b1] || OddQ[n3 + n4 + b2]);
r1ParityOddQ[J[_, {{bS_}, {b2_, n3_, n4_}}, _]] :=
  And @@ (IntegerQ /@ {bS, b2, n3, n4}) &&
   (OddQ[bS] || OddQ[n3 + n4 + b2]);

r2ToR1Rule = HoldPattern[(int_J /; r2IntegralQ[int])] :>
   lineSwapTransform[int];
r1EndpointRule = HoldPattern[(int_J /; r1EndpointSwapQ[int])] :>
   J[int[[1]], {int[[2, 1]], {int[[2, 2, 1]], 0, 1}}, int[[3]]];
combinedTopRule = HoldPattern[(int_J /; topFullIntegralQ[int] &&
       combinedCanonicalTransform[int] =!= int)] :> combinedCanonicalTransform[int];
topParityRule = HoldPattern[(int_J /; topParityOddQ[int])] :> 0;
r1ParityRule = HoldPattern[(int_J /; r1ParityOddQ[int])] :> 0;

referenceAllRules = {
   r2ToR1Rule, r1EndpointRule, combinedTopRule, topParityRule, r1ParityRule
   };


(* ::Chapter:: *)
(*Reference topology*)

referenceCase[rules_List] := <|
   "name" -> "codexReferenceBubble",
   "vertexData" -> {{v1, "-"}, {v2, "-"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
      "massType" -> "massive", "bbType" -> "h", "nu" -> nuM|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
      "massType" -> "massive", "bbType" -> "h", "nu" -> nuM|>
     },
   "loopMomenta" -> {q},
   "externalMomenta" -> {k},
   "externalInvariantRules" -> {sp[k, k] -> s11},
   "vertexEnergies" -> <|v1 -> I k0, v2 -> I k0|>,
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[v1] -> 2 nuM, a0[v2] -> 2 nuM,
     b0[1] -> -2 nuM, b0[2] -> -2 nuM
     },
   "symmetryRules" -> rules,
   "seedPreset" -> "quickCheck"
   |>;

referenceTop = parseTopology[referenceCase[referenceAllRules]];
referenceR1 = shrinkSectorTopology[referenceTop, {1}];
referenceR2 = shrinkSectorTopology[referenceTop, {2}];

referenceTopology["top"] := referenceTop;
referenceTopology["e1"] := referenceR1;
referenceTopology["e2"] := referenceR2;

referenceTopologyStatusQ = And @@ (
    Lookup[topologyValidationReport[#1], "status", "invalid"] === "ok" & /@
     {referenceTop, referenceR1, referenceR2}
    );


(* ::Chapter:: *)
(*k0/ks 导数*)

referenceZeroDifferenceQ[difference_] := TrueQ[difference === 0] ||
  TrueQ[Quiet[FullSimplify[difference == 0, Assumptions -> ks > 0]]];

referenceDerivativeActual[record_Association] := Module[
  {topo = referenceTopology[record["sector"]], packageExpression, actual},
  If[record["variable"] === k0,
   Return[ds[record["expression"], k0, topo]]
   ];
  packageExpression = record["expression"] /. ks -> Sqrt[s11];
  actual = 2 ks ds[packageExpression, s11, topo];
  Quiet@FullSimplify[
    actual /. s11 -> ks^2,
    Assumptions -> ks > 0
    ]
  ];

referenceDerivativeRows = MapIndexed[
   Function[{record, position},
    Module[{actual, difference, passQ},
     actual = referenceDerivativeActual[record];
     difference = If[actual === $Failed, $Failed,
       Expand[(actual /. dim -> d) - record["derivative"]]
       ];
     passQ = referenceZeroDifferenceQ[difference];
     <|
      "index" -> First[position], "sector" -> record["sector"],
      "mode" -> record["mode"], "variable" -> record["variable"],
      "passQ" -> passQ, "difference" -> If[passQ, 0, difference]
      |>
     ]
    ],
   frozenReferenceDerivatives
   ];
referenceDerivativeFailures = Select[
   referenceDerivativeRows,
   ! TrueQ[#1["passQ"]] &
   ];


(* ::Chapter:: *)
(*Symmetry 与 parity 原子*)

symmetryRulesForRecord["r2ToR1"] := {r2ToR1Rule};
symmetryRulesForRecord["lineExchange"] := {
   HoldPattern[(int_J /; topFullIntegralQ[int] &&
       lineCanonicalTransform[int] =!= int)] :> lineCanonicalTransform[int]
   };
symmetryRulesForRecord["vertexExchange"] := {
   HoldPattern[(int_J /; topFullIntegralQ[int] &&
       vertexCanonicalTransform[int] =!= int)] :> vertexCanonicalTransform[int]
   };
symmetryRulesForRecord["r1Endpoint"] := {r1EndpointRule};
symmetryRulesForRecord["lineThenVertex"] := {
   HoldPattern[(int_J /; topFullIntegralQ[int])] :>
    vertexCanonicalTransform[lineCanonicalTransform[int]]
   };
symmetryRulesForRecord["emptyRules"] := {};

symmetryRows = Map[
   Function[record,
    Module[{topo, actual, difference, passQ},
     topo = Switch[record["inputSector"],
       "e1", shrinkSectorTopology[parseTopology[
          referenceCase[symmetryRulesForRecord[record["name"]]]], {1}],
       "e2", shrinkSectorTopology[parseTopology[
          referenceCase[symmetryRulesForRecord[record["name"]]]], {2}],
       _, parseTopology[referenceCase[symmetryRulesForRecord[record["name"]]]]
       ];
     actual = symmetry[record["input"], topo];
     difference = Expand[actual - record["expected"]];
     passQ = referenceZeroDifferenceQ[difference];
     <|"name" -> record["name"], "passQ" -> passQ,
      "difference" -> If[passQ, 0, difference]|>
     ]
    ],
   frozenReferenceSymmetry
   ];
symmetryFailures = Select[symmetryRows, ! TrueQ[#1["passQ"]] &];

parityRows = Map[
   Function[record,
    Module[{rules, topo, actual, difference, passQ},
     rules = If[record["sector"] === "top", {topParityRule}, {r1ParityRule}];
     topo = If[record["sector"] === "top",
       parseTopology[referenceCase[rules]],
       shrinkSectorTopology[parseTopology[referenceCase[rules]], {1}]
       ];
     actual = symmetry[record["input"], topo];
     difference = Expand[actual - record["expected"]];
     passQ = referenceZeroDifferenceQ[difference];
     <|"name" -> record["name"], "passQ" -> passQ,
      "difference" -> If[passQ, 0, difference]|>
     ]
    ],
   frozenReferenceParity
   ];
parityFailures = Select[parityRows, ! TrueQ[#1["passQ"]] &];


(* ::Chapter:: *)
(*汇总*)

checkSummary = <|
   "topologyStatusQ" -> referenceTopologyStatusQ,
   "derivativeCount" -> Length[referenceDerivativeRows],
   "derivativePassed" -> Count[Lookup[referenceDerivativeRows, "passQ"], True],
   "derivativeFailed" -> Length[referenceDerivativeFailures],
   "symmetryCount" -> Length[symmetryRows],
   "symmetryPassed" -> Count[Lookup[symmetryRows, "passQ"], True],
   "symmetryFailed" -> Length[symmetryFailures],
   "parityCount" -> Length[parityRows],
   "parityPassed" -> Count[Lookup[parityRows, "passQ"], True],
   "parityFailed" -> Length[parityFailures],
   "passQ" -> TrueQ[referenceTopologyStatusQ] &&
     referenceDerivativeFailures === {} && symmetryFailures === {} &&
     parityFailures === {}
   |>;

Print[InputForm[checkSummary]];
If[referenceDerivativeFailures =!= {},
 Print["FIRST_DERIVATIVE_FAILURES"];
 Print[InputForm[Take[referenceDerivativeFailures, UpTo[4]]]]
 ];
If[symmetryFailures =!= {},
 Print["SYMMETRY_FAILURES"];
 Print[InputForm[symmetryFailures]]
 ];
If[parityFailures =!= {},
 Print["PARITY_FAILURES"];
 Print[InputForm[parityFailures]]
 ];

If[! TrueQ[checkSummary["passQ"]], Exit[1]];
