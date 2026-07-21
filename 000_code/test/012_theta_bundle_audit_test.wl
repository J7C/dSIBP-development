(* ::Package:: *)

baseDir = DirectoryName[$InputFileName];
Get[FileNameJoin[{baseDir, "..", "012_dS_ibp_general.wl"}]];

checks = <||>;
record[name_, value_] := AssociateTo[checks, name -> TrueQ[value]];

bubbleMasslessTopo = parseTopology[bubbleMasslessCase];
bubbleMassiveTopo = parseTopology[bubbleMassiveCase];
sunriseTopo = parseTopology[mixedSunriseCase];
triangleTopo = parseTopology[mixedTriangleCase];

masslessAtomicShrink = shrinkLineIntegral[
   bubbleMasslessTopo,
   J[{0, 0}, {{0, 1}, {0, 0}}, {}],
   1
   ];
record[
 "massless atomic shrink has no integer a shift",
 masslessAtomicShrink === J[{0}, {{0}, {0, 0}}, {}]
 ];

massiveAtomicShrink = shrinkLineIntegral[
   bubbleMassiveTopo,
   J[{0, 0}, {{0, 0, 1}, {0, 0, 0}}, {}],
   1
   ];
record[
 "massive atomic shrink retains Wronskian integer powers",
 massiveAtomicShrink === J[{-1}, {{1}, {0, 0, 0}}, {}]
 ];

twoLineBoundary = Expand@timeThetaBoundaryShrinkTerms[
   bubbleMasslessTopo,
   J[{0, 0}, {{0, 1}, {0, 0}}, {}],
   1
   ];
record[
 "two parallel lines generate single contact only",
 twoLineBoundary === -2 J[{0}, {{0}, {0, 0}}, {}]
 ];

threeLineBoundary = applySeedCanonical[
   timeThetaBoundaryShrinkTerms[
    sunriseTopo,
    J[{0, 0}, {{0, 0, 1}, {0, 1}, {0, 1}}, {0, 0}],
    1
    ],
   sunriseTopo
   ];
record[
 "three parallel active differences generate a triple contact",
 ! FreeQ[threeLineBoundary, J[{-1}, {{1}, {0}, {0}}, {0, 0}]]
 ];
record[
 "three-line triple contact has the odd-subset coefficient",
 FullSimplify[
   Coefficient[threeLineBoundary, J[{-1}, {{1}, {0}, {0}}, {0, 0}]] +
    (4 I/Pi) Exp[Pi Im[nuM]]
   ] === 0
 ];
record[
 "three-line boundary has no surviving single contact when the other massless odd states coincide",
 Count[threeLineBoundary, _J, Infinity] === 1
 ];

record[
 "two-line reachable sectors are singles",
 shrinkSectorSubsets[bubbleMasslessTopo, Automatic, 100]["subsets"] === {{1}, {2}}
 ];
record[
 "three-parallel reachable sectors include singles and one triple event",
 shrinkSectorSubsets[sunriseTopo, Automatic, 100]["subsets"] === {{1}, {2}, {3}, {1, 2, 3}}
 ];
record[
 "triangle reachable sectors contain singles and pairs but no cycle",
 shrinkSectorSubsets[triangleTopo, Automatic, 100]["subsets"] ===
  {{1}, {2}, {3}, {1, 2}, {1, 3}, {2, 3}}
 ];

massiveCoincident = applySeedCanonical[
   J[{0}, {{0, 1, 0}, {0}}, {}],
   bubbleMassiveTopo
   ];
record[
 "massive coincidence canonical swaps endpoint states",
 massiveCoincident === J[{0}, {{0, 0, 1}, {0}}, {}]
 ];

singleSectorTopo = shrinkSectorTopology[bubbleMasslessTopo, {1}];
record[
 "coincident remaining theta is not differentiated again",
 timeThetaBoundaryShrinkTerms[
    singleSectorTopo,
    J[{0}, {{0}, {0, 1}}, {}],
    1
    ] === 0
 ];

ClearAll[aSym, bSym, jSym, aa, bb];
oddExpansion[a_List, b_List] := Module[{j = (a + b)/2, d = a - b},
   Total[
    2^(1 - Length[#]) Times @@ d[[#]] Times @@ j[[Complement[Range[Length[a]], #]]] & /@
     Select[Rest[Subsets[Range[Length[a]]]], OddQ[Length[#]] &]
    ]
   ];
Do[
 record[
  "common-theta odd-subset identity n=" <> ToString[nn],
  Expand[Times @@ Array[aa, nn] - Times @@ Array[bb, nn] -
     oddExpansion[Array[aa, nn], Array[bb, nn]]] === 0
  ],
 {nn, 1, 4}
 ];

record[
 "naive theta-zero counting happens to agree for two lines",
 2/2^(2 - 1) === 1
 ];
record[
 "naive theta-zero counting fails for three lines",
 3/2^(3 - 1) =!= 1
 ];

auditAtomicMasslessCase[signs_List] := <|
   "name" -> "auditAtomicMassless",
   "vertexData" -> {{auditV1, signs[[1]]}, {auditV2, signs[[2]]}},
   "lineData" -> {<|
      "id" -> 1, "endpoints" -> {auditV1, auditV2}, "momentum" -> auditQ,
      "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"
      |>},
   "loopMomenta" -> {auditQ}, "externalMomenta" -> {},
   "vertexEnergies" -> <|auditV1 -> 0, auditV2 -> 0|>,
   "zeroPointRules" -> {a0[auditV1] -> 0, a0[auditV2] -> 0, b0[1] -> auditBeta}
   |>;

auditMasslessFullTopo = parseTopology[auditAtomicMasslessCase[{"+", "+"}]];
auditMasslessN0 = J[{0, 0}, {{0, 0}}, {}];
auditMasslessN0Momentum = dqq[auditQ, auditQ, auditMasslessN0, auditMasslessFullTopo];
record[
 "atomic massless n=0 momentum sign follows partial-q M0=+i sigma Delta M1",
 Expand[
   auditMasslessN0Momentum -
    ((dim - auditBeta) J[{0, 0}, {{0, 0}}, {}] -
      I J[{1, 0}, {{-1, 1}}, {}] + I J[{0, 1}, {{-1, 1}}, {}])
   ] === 0
 ];

auditMasslessCrossTopo = parseTopology[auditAtomicMasslessCase[{"+", "-"}]];
auditCrossMomentum = dqq[
   auditQ, auditQ, J[{0, 0}, {{0}}, {}], auditMasslessCrossTopo
   ];
record[
 "massless cross momentum endpoint terms carry b-1",
 ! FreeQ[auditCrossMomentum, J[{1, 0}, {{-1}}, {}]] &&
  ! FreeQ[auditCrossMomentum, J[{0, 1}, {{-1}}, {}]] &&
  FreeQ[auditCrossMomentum, J[{1, 0}, {{0}}, {}] | J[{0, 1}, {{0}}, {}]]
 ];

auditAtomicMassiveCase = <|
   "name" -> "auditAtomicMassive", "vertexData" -> {{auditV1, "+"}, {auditV2, "+"}},
   "lineData" -> {<|
      "id" -> 1, "endpoints" -> {auditV1, auditV2}, "momentum" -> auditQ,
      "nu" -> auditNu, "bbType" -> "h", "massType" -> "massive"
      |>},
   "loopMomenta" -> {auditQ}, "externalMomenta" -> {},
   "vertexEnergies" -> <|auditV1 -> 0, auditV2 -> 0|>,
   "zeroPointRules" -> {a0[auditV1] -> 0, a0[auditV2] -> 0, b0[1] -> auditBeta}
   |>;
auditMassiveTopo = parseTopology[auditAtomicMassiveCase];
auditMassiveMomentum = dqq[
   auditQ, auditQ, J[{0, 0}, {{0, 1, 0}}, {}], auditMassiveTopo
   ];
record[
 "massive momentum derivative preserves the untouched endpoint state",
 ! FreeQ[auditMassiveMomentum, J[{0, 1}, {{-1, 1, 1}}, {}]] &&
 FreeQ[auditMassiveMomentum, J[{0, 1}, {{-1, 0, 1}}, {}]]
 ];

auditHCase = Join[
   auditAtomicMassiveCase,
   <|"name" -> "auditAtomicH",
     "lineData" -> {Join[First[auditAtomicMassiveCase["lineData"]], <|"bbType" -> "H"|>]}
     |>
   ];
auditHTopo = parseTopology[auditHCase];
auditHSector = shrinkSectorTopology[auditHTopo, {1}];
auditHShrink = shrinkLineIntegral[
   auditHTopo, J[{0, 0}, {{0, 0, 1}}, {}], 1
   ];
record[
 "H shrink total time power uses integer 1 plus zero-point 0",
 auditHShrink === J[{-1}, {{1}}, {}] &&
  vertexZeroPoint[auditHSector, auditV1] === 0
 ];
record[
 "H shrink total momentum power uses integer 1 plus zero-point 0",
 lineBSZeroPoint[auditHSector, 1] === auditBeta &&
  auditHShrink[[2, 1, 1]] + lineBSZeroPoint[auditHSector, 1] - auditBeta === 1
 ];

auditHSectorTop = shrinkSectorTopology[auditMassiveTopo, {1}];
auditHShrink = shrinkLineIntegral[
   auditMassiveTopo, J[{0, 0}, {{0, 0, 1}}, {}], 1
   ];
record[
 "h shrink total time power uses integer 1 plus zero-point 2 nu",
 FullSimplify[
   auditHShrink[[1, 1]] + vertexZeroPoint[auditHSectorTop, auditV1] + 2 auditNu + 1
   ] === 0
 ];
record[
 "h shrink total momentum power uses integer 1 plus zero-point 2 nu",
 FullSimplify[
   auditHShrink[[2, 1, 1]] + lineBSZeroPoint[auditHSectorTop, 1] - auditBeta - (2 auditNu + 1)
   ] === 0
 ];

auditMasslessSector = shrinkSectorTopology[auditMasslessFullTopo, {1}];
auditMasslessShrink = shrinkLineIntegral[
   auditMasslessFullTopo, J[{0, 0}, {{0, 1}}, {}], 1
   ];
record[
 "massless shrink total time and momentum shifts are 0+0",
 auditMasslessShrink[[1, 1]] === 0 &&
  vertexZeroPoint[auditMasslessSector, auditV1] === 0 &&
  auditMasslessShrink[[2, 1, 1]] === 0 &&
  lineBSZeroPoint[auditMasslessSector, 1] === auditBeta
 ];

triangleSeed = J[{0, 0, 0}, {{0, 0, 0}, {0, 0, 0}, {0, 0}}, {}];
triangleAtV1 = dtau[1, triangleSeed, triangleTopo];
record[
 "mixed triangle dtau-v1 does not differentiate nonincident line 2",
 Cases[triangleAtV1, int_J /; int[[2, 2]] =!= {0, 0, 0}, Infinity] === {}
 ];

gaussianResolvedLineContribution[a_List, b_List, i_Integer] := Integrate[
   (a[[i]] - b[[i]]) Times @@
    Table[If[j === i, 1, b[[j]] + h (a[[j]] - b[[j]])], {j, Length[a]}],
   {h, 0, 1}
   ];
Do[
 record[
  "coherent smooth-theta linewise sum n=" <> ToString[nn],
  Expand[
    Total[gaussianResolvedLineContribution[Array[aa, nn], Array[bb, nn], #] & /@ Range[nn]] -
     (Times @@ Array[aa, nn] - Times @@ Array[bb, nn])
    ] === 0
  ],
 {nn, 1, 4}
 ];

failed = Keys@Select[checks, Not];
Print["theta bundle audit checks: ", Count[Values[checks], True], "/", Length[checks]];
If[failed =!= {}, Print["FAILED: ", failed]; Exit[1]];
Exit[0];
