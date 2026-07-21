(* ::Package:: *)
(* reference_bubble_derivative：把旧 reference 的 G/R1/R2、Vpm、zero-point、symmetry 与 parity
   显式映射到统一 J family，供 dk0/dks 与公开 ds 做同 convention 比较。 *)

(* ::Chapter:: *)
(*Reference symmetry 与 parity*)

referenceBubbleTopIntegralQ[J[_, {pack1_, pack2_}, {}]] :=
  Length[pack1] === 3 && Length[pack2] === 3;


referenceBubbleR1IntegralQ[J[_, {pack1_, pack2_}, {}]] :=
  Length[pack1] === 1 && Length[pack2] === 3;


referenceBubbleR2IntegralQ[J[_, {pack1_, pack2_}, {}]] :=
  Length[pack1] === 3 && Length[pack2] === 1;


referenceBubbleSwapVertices[J[{a1_, a2_}, {{b1_, n1_, n2_}, {b2_, n3_, n4_}}, {}]] :=
  J[{a2, a1}, {{b1, n2, n1}, {b2, n4, n3}}, {}];


referenceBubbleSwapLines[J[{a1_, a2_}, {{b1_, n1_, n2_}, {b2_, n3_, n4_}}, {}]] :=
  J[{a1, a2}, {{b2, n3, n4}, {b1, n1, n2}}, {}];


(* 顺序严格复制 reference symmetry：先顶点、再线交换，随后处理两个 tie-break。 *)
referenceBubbleTopCanonical[int_J] := Module[{result = int},
   If[TrueQ[result[[1, 1]] > result[[1, 2]]], result = referenceBubbleSwapVertices[result]];
   If[TrueQ[result[[2, 1, 1]] > result[[2, 2, 1]]], result = referenceBubbleSwapLines[result]];
   If[TrueQ[result[[1, 1]] === result[[1, 2]] && result[[2, 1, 2]] > result[[2, 1, 3]]],
    result = referenceBubbleSwapVertices[result]
    ];
   If[TrueQ[
     result[[1, 1]] === result[[1, 2]] &&
      result[[2, 1, 2]] === result[[2, 1, 3]] &&
      result[[2, 2, 2]] > result[[2, 2, 3]]
     ], result = referenceBubbleSwapVertices[result]];
   If[TrueQ[result[[2, 1, 1]] === result[[2, 2, 1]] && result[[2, 1, 2]] > result[[2, 2, 2]]],
    result = referenceBubbleSwapLines[result]
    ];
   If[TrueQ[
     result[[2, 1, 1]] === result[[2, 2, 1]] &&
      result[[2, 1, 2]] === result[[2, 2, 2]] &&
      result[[2, 1, 3]] > result[[2, 2, 3]]
     ], result = referenceBubbleSwapLines[result]];
   result
   ];


referenceBubbleR1Canonical[J[aList_, {{bS_}, {b2_, n3_, n4_}}, {}]] := If[
   TrueQ[n3 > n4],
   J[aList, {{bS}, {b2, n4, n3}}, {}],
   J[aList, {{bS}, {b2, n3, n4}}, {}]
   ];


referenceBubbleR2ToR1[J[aList_, {{b1_, n1_, n2_}, {bS_}}, {}]] :=
  referenceBubbleR1Canonical[J[aList, {{bS}, {b1, n1, n2}}, {}]];


referenceBubbleParityZeroQ[J[_, {{b1_, n1_, n2_}, {b2_, n3_, n4_}}, {}]] :=
  TrueQ[OddQ[n1 + n2 + b1] || OddQ[n3 + n4 + b2]];
referenceBubbleParityZeroQ[J[_, {{bS_}, {b2_, n3_, n4_}}, {}]] :=
  TrueQ[OddQ[bS] || OddQ[n3 + n4 + b2]];
referenceBubbleParityZeroQ[J[_, {{b1_, n1_, n2_}, {bS_}}, {}]] :=
  TrueQ[OddQ[bS] || OddQ[n1 + n2 + b1]];
referenceBubbleParityZeroQ[_] := False;


referenceBubbleSymmetryRules0[] := {
   HoldPattern[(int_J /; referenceBubbleParityZeroQ[int])] :> 0,
   HoldPattern[(int_J /; referenceBubbleR2IntegralQ[int])] :> referenceBubbleR2ToR1[int],
   HoldPattern[(int_J /; referenceBubbleTopIntegralQ[int])] :> referenceBubbleTopCanonical[int],
   HoldPattern[(int_J /; referenceBubbleR1IntegralQ[int])] :> referenceBubbleR1Canonical[int]
   };


referenceBubbleCanonicalExpression[expr_] := Expand[
   expr /. int_J :> Which[
      referenceBubbleParityZeroQ[int], 0,
      referenceBubbleR2IntegralQ[int], referenceBubbleR2ToR1[int],
      referenceBubbleTopIntegralQ[int], referenceBubbleTopCanonical[int],
      referenceBubbleR1IntegralQ[int], referenceBubbleR1Canonical[int],
      True, int
      ]
   ];


(* ::Chapter:: *)
(*统一 J topology*)

makeReferenceBubbleDerivativeCase[] := <|
   "name" -> "referenceBubbleDerivativeAligned",
   "vertexData" -> {{v1, "-"}, {v2, "-"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nu|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nu|>
     },
   "loopMomenta" -> {q},
   "externalMomenta" -> {k},
   "externalInvariantRules" -> {sp[k, k] -> s11},
   (* Vpm=0 的 reference 相位用 E=I k0 映射到 package 的 -- convention。 *)
   "vertexEnergies" -> <|v1 -> I k0, v2 -> I k0|>,
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[v1] -> 2 nu, a0[v2] -> 2 nu,
     b0[1] -> -2 nu, b0[2] -> -2 nu
     },
   "symmetryRules" -> referenceBubbleSymmetryRules0[],
   "seedPreset" -> "quickCheck"
   |>;


referenceBubbleGeneralIntegrals[] := Join[
   Flatten[Table[
     J[{ra1, ra2}, {{rb1, n1, n2}, {rb2, n3, n4}}, {}],
     {n1, 0, 1}, {n2, 0, 1}, {n3, 0, 1}, {n4, 0, 1}
     ]],
   Flatten[Table[
     J[{ra}, {{rbs1}, {rb2, n3, n4}}, {}],
     {n3, 0, 1}, {n4, 0, 1}
     ]]
   ];
