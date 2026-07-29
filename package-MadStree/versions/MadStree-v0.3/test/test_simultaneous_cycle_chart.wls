(* ::Package:: *)

(***
文件：test_simultaneous_cycle_chart.wls
用途：验证共同-theta odd-subset simultaneous contact、coincident quotient、time-only 圈图
      sector canonicalization、shifted child 公式约化与 nested blow-up 证书。
运行：wolframscript -file package-MadStree/test/test_simultaneous_cycle_chart.wls
***)

(* ::Chapter:: *)
(*加载与检查工具*)

packageRoot = DirectoryName[DirectoryName[$InputFileName]];
AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
Needs["MadStree`"];

checks = <||>;
record[name_, value_] := AssociateTo[checks, name -> TrueQ[value]];


(* ::Chapter:: *)
(*三条共同 theta 的 massless simultaneous contact*)

parallelMasslessSpec = <|
  "vertices" -> {
    <|"id" -> u, "energy" -> ku, "timePower" -> au|>,
    <|"id" -> v, "energy" -> kv, "timePower" -> av|>
  },
  "lines" -> Table[
    <|"id" -> Symbol["e" <> ToString[index]], "type" -> "masslessFull",
      "endpoints" -> {u, v}, "momentum" -> Symbol["q" <> ToString[index]],
      "skType" -> "++", "nu" -> 1/2|>,
    {index, 3}
  ],
  "contactEvents" -> {{e1, e2, e3}}
|>;

parallelMassless = MSInitTimeGraph[parallelMasslessSpec];
parallelEvents = parallelMassless["contactTransitions"];
record["parallelMasslessContext", MSContextQ[parallelMassless]];
record["oddSubsetEventCount", Length[parallelEvents] === 4];
record["tripleEventPresent",
  Count[Lookup[parallelEvents, "selectedLineIds"], ids_ /; Length[ids] === 3] === 1
];
record["tripleCoefficient",
  First@Lookup[Select[parallelEvents, Length[#["selectedLineIds"]] === 3 &], "thetaBundleCoefficient"] === 1/4
];
record["reachableSectorCount", Length[MSSectors[parallelMassless]] === 5];
record["singleContactCoincidentQuotient",
  And @@ (#["masterCount"] === 1 & /@
    Select[MSSectors[parallelMassless], Length[#["contractedLineIds"]] === 1 &])
];
tripleMap = SelectFirst[MSContactMaps[parallelMassless, "top"], Length[#["selectedLineIds"]] === 3 &];
record["tripleEndpointWeights",
  Sort[Flatten[Values[tripleMap["matricesByComponent"]]]] === Sort[Join[ConstantArray[0, 14], {-2, 2}]]
];
record["parallelMasslessDLog", MSDLogDE[parallelMassless]["dlogStatus"] === "certifiedByFormulaChecks"];


(* ::Chapter:: *)
(*massive coincident quotient 仍由局部张量变换处理*)

parallelMassiveSpec = Join[
  parallelMasslessSpec,
  <|"lines" -> Table[
    <|"id" -> Symbol["m" <> ToString[index]], "type" -> "massiveFull",
      "endpoints" -> {u, v}, "momentum" -> Symbol["p" <> ToString[index]],
      "skType" -> "++", "nu" -> Symbol["nu" <> ToString[index]]|>,
    {index, 3}
  ], "contactEvents" -> {{m1, m2, m3}}|>
];

parallelMassive = MSInitTimeGraph[parallelMassiveSpec];
singleMassiveSector = SelectFirst[
  MSSectors[parallelMassive],
  Length[#["contractedLineIds"]] === 1 &
];
singleMassiveFormula = MSFormulaMatrices[parallelMassive, singleMassiveSector["sectorKey"]];
record["massiveCoincidentDimension", singleMassiveSector["masterCount"] === 9];
record["massiveLocalDiagonalizerRoundTrip",
  Simplify[singleMassiveFormula["UInverse"].singleMassiveFormula["U"]] === IdentityMatrix[9]
];


(* ::Chapter:: *)
(*triangle time-only 圈图与所有 strict charts*)

triangleSpec = <|
  "vertices" -> {
    <|"id" -> t1, "energy" -> k1, "timePower" -> a1|>,
    <|"id" -> t2, "energy" -> k2, "timePower" -> a2|>,
    <|"id" -> t3, "energy" -> k3, "timePower" -> a3|>
  },
  "lines" -> {
    <|"id" -> l12, "type" -> "masslessFull", "endpoints" -> {t1, t2}, "momentum" -> q12,
      "skType" -> "++", "nu" -> 1/2|>,
    <|"id" -> l23, "type" -> "masslessFull", "endpoints" -> {t2, t3}, "momentum" -> q23,
      "skType" -> "++", "nu" -> 1/2|>,
    <|"id" -> l31, "type" -> "masslessFull", "endpoints" -> {t3, t1}, "momentum" -> q31,
      "skType" -> "++", "nu" -> 1/2|>
  }
|>;

triangle = MSInitTimeGraph[triangleSpec];
triangleSectors = MSSectors[triangle];
record["triangleContext", MSContextQ[triangle] && triangle["topologyClass"] === "cyclicTimeOnly"];
record["triangleReachableSectors", Length[triangleSectors] === 7];
record["triangleNoAllEdgeContraction",
  FreeQ[Lookup[triangleSectors, "contractedLineIds"], {l12, l23, l31}]
];
record["triangleContactCanonical",
  DuplicateFreeQ[Lookup[triangleSectors, "sectorKey"]] && Length[triangle["contactTransitions"]] === 9
];

triangleCharts = MSBoundaryChartCertificate[
  triangle,
  {k1 -> -I 11, k2 -> -I 7, k3 -> -I 5, a1 -> 0, a2 -> 0, a3 -> 0,
   q12 -> 2, q23 -> 3, q31 -> 4},
  RankOrder -> All
];
record["allTriangleCharts", Length[triangleCharts["charts"]] === 6];
record["allTriangleChartsCertified", And @@ Lookup[triangleCharts["charts"], "normalCrossingQ"]];
record["thetaFixedInEverySector",
  FreeQ[Lookup[triangleCharts["charts"], "thetaFixingBySector"], "unfixed", Infinity]
];


(* ::Chapter:: *)
(*shifted child reduction helper 与总结*)

triangleTargetSector = triangleSectors[[2]];
shiftReduction = MadStree`Private`msShiftedTargetReduction[
  triangleTargetSector,
  ReplacePart[ConstantArray[0, Length[triangleTargetSector["vertexComponents"]]], 1 -> 1],
  triangle
];
record["shiftedChildReduction", shiftReduction["status"] === "reducedToGlobalMasters"];
record["shiftedChildReductionDimension",
  Dimensions[shiftReduction["matrix"]] === {triangleTargetSector["masterCount"], Length[MSMasterIntegrals[triangle]]}
];
record["noGeneralInverse",
  Total[StringCount[
    Import[#, "Text"],
    RegularExpression["(?<![A-Za-z0-9])Inverse\\["]
  ] & /@ {
    FileNameJoin[{packageRoot, "Kernel", "Formula", "TensorAtoms.wl"}],
    FileNameJoin[{packageRoot, "Kernel", "Formula", "Recurrence.wl"}],
    FileNameJoin[{packageRoot, "Kernel", "DE", "DLog.wl"}]
  }] === 0
];

passed = Count[Values[checks], True];
Print["MadStree simultaneous/cycle/chart checks: ", passed, "/", Length[checks]];
KeyValueMap[Print[#1, ": ", #2] &, checks];

If[passed =!= Length[checks], Exit[1]];
