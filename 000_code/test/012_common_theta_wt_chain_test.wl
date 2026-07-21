(* ::Package:: *)

baseDir = DirectoryName[$InputFileName];
Get[FileNameJoin[{baseDir, "..", "012_dS_ibp_general.wl"}]];

checks = <||>;
record[name_, value_] := AssociateTo[checks, name -> TrueQ[value]];

ClearAll[c0, c1, zeta, zetaOther, aa, bb, h];

multiWT = compileShrinkTerms[
   -c0 x^(-zeta) - c1 x^(-zeta - 1),
   x,
   <||>
   ];
multiWTTerms = SortBy[multiWT["terms"], #["bShift"] &];

record[
 "multi-term WT compiles integer shifts",
 Lookup[multiWTTerms, "bShift"] === {0, 1}
 ];
record[
 "multi-term WT compiles the coefficient of -WT",
 Lookup[multiWTTerms, "coefficient"] === {c0, c1}
 ];
record[
 "multi-term WT keeps one zero-point shift",
 Lookup[multiWTTerms, "zeroPointShift"] === {zeta, zeta} &&
  multiWT["zeroPointShift"] === zeta
 ];
record[
 "incompatible WT zero-point shifts are rejected",
 compileShrinkTerms[
    -c0 x^(-zeta) - c1 x^(-zetaOther - 1),
    x,
    <||>
    ] === $Failed
 ];

oddExpansion[a_List, b_List] := Module[{j = (a + b)/2, d = a - b},
   Total[
    2^(1 - Length[#]) Times @@ d[[#]] *
       Times @@ j[[Complement[Range[Length[a]], #]]] & /@
     Select[Rest[Subsets[Range[Length[a]]]], OddQ[Length[#]] &]
    ]
   ];

gaussianLineContribution[a_List, b_List, i_Integer] := Integrate[
   (a[[i]] - b[[i]]) Times @@ Table[
      If[j === i, 1, b[[j]] + h (a[[j]] - b[[j]])],
      {j, Length[a]}
      ],
   {h, 0, 1}
   ];

Do[
 record[
  "Gaussian sum equals common theta n=" <> ToString[nn],
  Expand[
    Total[gaussianLineContribution[Array[aa, nn], Array[bb, nn], #] & /@ Range[nn]] -
     oddExpansion[Array[aa, nn], Array[bb, nn]]
    ] === 0
  ],
 {nn, 1, 5}
 ];

a3 = Array[aa, 3];
b3 = Array[bb, 3];
j3 = (a3 + b3)/2;
d3 = a3 - b3;
record[
 "three-line resolved contribution contains 1/12 triple term",
 Expand[
   gaussianLineContribution[a3, b3, 1] -
    (d3[[1]] j3[[2]] j3[[3]] + d3[[1]] d3[[2]] d3[[3]]/12)
   ] === 0
 ];

sunriseTopo = parseTopology@Join[
    mixedSunriseCase,
    <|"zeroPointRules" -> {
       a0[1] -> alphaU, a0[2] -> alphaV,
       b0[1] -> beta1, b0[2] -> beta2, b0[3] -> beta3
       }|>
    ];
mixedTripleSeed = J[
   {aU, aV},
   {{b1, 1, 0}, {b2, 1}, {b3, 1}},
   {r1, r2}
   ];
mixedTripleTarget = J[
   {aU + aV - 1},
   {{b1 + 1}, {b2}, {b3}},
   {r1, r2}
   ];
mixedTripleBoundary = applySeedCanonical[
   timeThetaBoundaryShrinkTerms[sunriseTopo, mixedTripleSeed, 1],
   sunriseTopo
   ];
expectedPrefactor = (4 I/Pi) Exp[Pi Im[nuM]];

record[
 "mixed triple contact reaches the final J indices",
 Expand[mixedTripleBoundary - expectedPrefactor mixedTripleTarget] === 0
 ];

tripleSectorTopo = shrinkSectorTopology[sunriseTopo, {1, 2, 3}];
record[
 "mixed triple sector sums the merged time zero-point shift",
 FullSimplify[
   vertexZeroPoint[tripleSectorTopo, 1] -
    (alphaU + alphaV - 2 nuM)
   ] === 0
 ];
record[
 "mixed triple sector records line-local bS zero points",
 FullSimplify[lineBSZeroPoint[tripleSectorTopo, 1] - (beta1 + 2 nuM)] === 0 &&
  FullSimplify[lineBSZeroPoint[tripleSectorTopo, 2] - beta2] === 0 &&
  FullSimplify[lineBSZeroPoint[tripleSectorTopo, 3] - beta3] === 0
 ];

failed = Keys@Select[checks, Not];
Print["common-theta/WT chain checks: ", Count[Values[checks], True], "/", Length[checks]];
If[failed =!= {}, Print["FAILED: ", failed]; Print["multiWT: ", InputForm[multiWT]]; Exit[1]];
Exit[0];
