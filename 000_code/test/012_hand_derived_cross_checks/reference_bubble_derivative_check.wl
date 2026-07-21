(* ::Package:: *)
(* reference_bubble_derivative：在相同 convention 下比较 reference dk0/dks 与公开 ds。 *)

(* ::Chapter:: *)
(*初始化*)

exampleDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[DirectoryName[exampleDir]];
handDerivedDir = FileNameJoin[{codeDir, "test", "012_hand-derived", "reference_bubble_derivative"}];
Get[FileNameJoin[{codeDir, "012_dS_ibp_general.wl"}]];
Get[FileNameJoin[{handDerivedDir, "family.wl"}]];
Get[FileNameJoin[{handDerivedDir, "expected.wl"}]];

referenceBubbleTop = parseTopology[makeReferenceBubbleDerivativeCase[]];
referenceBubbleR1 = shrinkSectorTopology[referenceBubbleTop, {1}];
referenceBubbleR2 = shrinkSectorTopology[referenceBubbleTop, {2}];


(* ::Chapter:: *)
(*General-index 单积分与乘积法则*)

referenceBubbleIntegrals = referenceBubbleGeneralIntegrals[];
referenceBubbleTopology[int_J] := Which[
   referenceBubbleTopIntegralQ[int], referenceBubbleTop,
   referenceBubbleR1IntegralQ[int], referenceBubbleR1,
   referenceBubbleR2IntegralQ[int], referenceBubbleR2,
   True, $Failed
   ];

referenceBubbleSingleResults = Flatten[Table[
    Module[{topo, actual, expected, difference, externalFormQ, canonicalQ},
     topo = referenceBubbleTopology[int];
     actual = ds[int, variable, topo];
     expected = referenceBubbleIntegralDerivative[int, variable];
     difference = Together[Expand[actual - expected]];
     externalFormQ = actual =!= $Failed && FreeQ[actual, kk];
     canonicalQ = actual =!= $Failed && ! containsForbiddenNQ[topo, actual];
     <|"kind" -> "single", "integral" -> int, "variable" -> variable,
       "passQ" -> TrueQ[difference === 0 && externalFormQ && canonicalQ],
       "difference" -> difference|>
     ],
    {int, referenceBubbleIntegrals}, {variable, {k0, s11}}
    ]];

referenceBubbleProductResults = Flatten[Table[
    Module[{topo, int2, expression, actual, expected, difference, externalFormQ, canonicalQ},
     topo = referenceBubbleTopology[int1];
     int2 = int1 /. {
        ra1 -> ra1 + 1, ra2 -> ra2 - 1, ra -> ra + 1,
        rb1 -> rb1 + 2, rb2 -> rb2 - 2,
        rbs1 -> rbs1 + 2, rbs2 -> rbs2 + 2
        };
     expression = (variable^2 + rc[1]/variable) int1 +
       (1 + rc[2] variable + variable^3) int2 + variable^2 + rc[3] variable;
     actual = ds[expression, variable, topo];
     expected = referenceBubbleExpectedTotalDerivative[int1, int2, variable];
     difference = Together[Expand[actual - expected]];
     externalFormQ = actual =!= $Failed && FreeQ[actual, kk];
     canonicalQ = actual =!= $Failed && ! containsForbiddenNQ[topo, actual];
     <|"kind" -> "product", "integral" -> int1, "variable" -> variable,
       "passQ" -> TrueQ[difference === 0 && externalFormQ && canonicalQ],
       "difference" -> difference|>
     ],
    {int1, referenceBubbleIntegrals}, {variable, {k0, s11}}
    ]];


(* ::Chapter:: *)
(*Convention、symmetry 与 parity 原子检查*)

referenceBubbleSymmetrySamples = {
   J[{2, 0}, {{0, 0, 0}, {0, 0, 0}}, {}],
   J[{0, 0}, {{2, 0, 0}, {0, 0, 0}}, {}],
   J[{0, 0}, {{0, 1, 0}, {0, 0, 0}}, {}],
   J[{0}, {{0}, {0, 1, 0}}, {}],
   J[{0}, {{0, 1, 0}, {0}}, {}]
   };
referenceBubbleParitySamples = {
   J[{0, 0}, {{1, 0, 0}, {0, 0, 0}}, {}],
   J[{0, 0}, {{0, 0, 0}, {0, 1, 0}}, {}],
   J[{0}, {{1}, {0, 0, 0}}, {}],
   J[{0}, {{0}, {0, 1, 0}}, {}],
   J[{0}, {{0, 0, 0}, {1}}, {}]
   };

referenceBubbleSymmetryPassQ = And @@ Table[
    symmetry[int, referenceBubbleTopology[int]] === referenceBubbleCanonicalExpression[int],
    {int, referenceBubbleSymmetrySamples}
    ];
referenceBubbleParityPassQ = And @@ Table[
    symmetry[int, referenceBubbleTopology[int]] === 0,
    {int, referenceBubbleParitySamples}
    ];

referenceBubbleZeroPointPassQ = TrueQ[
   vertexZeroPoint[referenceBubbleTop, v1] === 2 nu &&
    vertexZeroPoint[referenceBubbleTop, v2] === 2 nu &&
    lineBZeroPoint[referenceBubbleTop, 1] === -2 nu &&
    lineBZeroPoint[referenceBubbleTop, 2] === -2 nu &&
    vertexZeroPoint[referenceBubbleR1, v1] === 2 nu &&
    lineBSZeroPoint[referenceBubbleR1, 1] === 0 &&
    lineBZeroPoint[referenceBubbleR1, 2] === -2 nu &&
    vertexZeroPoint[referenceBubbleR2, v1] === 2 nu &&
    lineBZeroPoint[referenceBubbleR2, 1] === -2 nu &&
    lineBSZeroPoint[referenceBubbleR2, 2] === 0
   ];
referenceBubbleVariablePassQ = TrueQ[
   Lookup[publicIndependentVariableDerivativeData[referenceBubbleTop], "userVariable"] === {s11, k0}
   ];


(* ::Chapter:: *)
(*汇总*)

referenceBubbleDerivativeResults = Join[
   Flatten[referenceBubbleSingleResults],
   Flatten[referenceBubbleProductResults]
   ];
referenceBubbleDerivativeFailed = Select[
   referenceBubbleDerivativeResults,
   ! TrueQ[#["passQ"]] &
   ];

Print["reference bubble derivative checks: ",
  Count[Lookup[referenceBubbleDerivativeResults, "passQ"], True], "/",
  Length[referenceBubbleDerivativeResults]];
Print["reference symmetry aligned: ", referenceBubbleSymmetryPassQ];
Print["reference parity aligned: ", referenceBubbleParityPassQ];
Print["reference zero-points aligned: ", referenceBubbleZeroPointPassQ];
Print["reference variables aligned: ", referenceBubbleVariablePassQ];

If[
 ! And[
    referenceBubbleDerivativeFailed === {},
    referenceBubbleSymmetryPassQ,
    referenceBubbleParityPassQ,
    referenceBubbleZeroPointPassQ,
    referenceBubbleVariablePassQ
    ],
 Print["First failed reference derivatives: ", Take[referenceBubbleDerivativeFailed, UpTo[12]]];
 Exit[1]
 ];
