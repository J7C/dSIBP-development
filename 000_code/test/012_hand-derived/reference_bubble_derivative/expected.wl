(* ::Package:: *)
(* reference_bubble_derivative expected：冻结 001 bubble_ibp_sym.m 的 dk0/dksTerm 与 h-EOM，
   再经显式 G/R1/R2 -> J 映射生成同 convention expected。 *)

(* ::Chapter:: *)
(*Legacy 表示与指标操作*)

referenceShift[expr_, slot_, position_, delta_] :=
  ReplacePart[expr, {slot, position} -> expr[[slot, position]] + delta];


referenceBubbleJToLegacy[J[aList_, {pack1_, pack2_}, {}]] := Which[
   Length[pack1] === 3 && Length[pack2] === 3,
   RefG[Join[pack1[[{2, 3}]], pack2[[{2, 3}]]], aList, {pack1[[1]], pack2[[1]]}],
   Length[pack1] === 1 && Length[pack2] === 3,
   RefR1[pack2[[{2, 3}]], aList, {pack1[[1]], pack2[[1]]}],
   Length[pack1] === 3 && Length[pack2] === 1,
   RefR2[pack1[[{2, 3}]], aList, {pack1[[1]], pack2[[1]]}],
   True,
   $Failed
   ];


referenceBubbleLegacyToJ[expr_] := Expand[expr /. {
    RefG[{n1_, n2_, n3_, n4_}, {a1_, a2_}, {b1_, b2_}] :>
     J[{a1, a2}, {{b1, n1, n2}, {b2, n3, n4}}, {}],
    RefR1[{n3_, n4_}, {av_}, {bS_, b2_}] :>
     J[{av}, {{bS}, {b2, n3, n4}}, {}],
    RefR2[{n1_, n2_}, {av_}, {b1_, bS_}] :>
     J[{av}, {{b1, n1, n2}, {bS}}, {}]
    }];


(* ::Chapter:: *)
(*Reference h-EOM*)

referenceBubbleEOM[expr_] := FixedPoint[
   Expand[# /. {
       RefG[{2, n2_, n3_, n4_}, {a1_, a2_}, {b1_, b2_}] :>
        -RefG[{0, n2, n3, n4}, {a1, a2}, {b1, b2}] -
         (2 nu + 1) RefG[{1, n2, n3, n4}, {a1 - 1, a2}, {b1 + 1, b2}],
       RefG[{n1_, 2, n3_, n4_}, {a1_, a2_}, {b1_, b2_}] :>
        -RefG[{n1, 0, n3, n4}, {a1, a2}, {b1, b2}] -
         (2 nu + 1) RefG[{n1, 1, n3, n4}, {a1, a2 - 1}, {b1 + 1, b2}],
       RefG[{n1_, n2_, 2, n4_}, {a1_, a2_}, {b1_, b2_}] :>
        -RefG[{n1, n2, 0, n4}, {a1, a2}, {b1, b2}] -
         (2 nu + 1) RefG[{n1, n2, 1, n4}, {a1 - 1, a2}, {b1, b2 + 1}],
       RefG[{n1_, n2_, n3_, 2}, {a1_, a2_}, {b1_, b2_}] :>
        -RefG[{n1, n2, n3, 0}, {a1, a2}, {b1, b2}] -
         (2 nu + 1) RefG[{n1, n2, n3, 1}, {a1, a2 - 1}, {b1, b2 + 1}],
       RefR1[{2, n4_}, {av_}, {bS_, b2_}] :>
        -RefR1[{0, n4}, {av}, {bS, b2}] -
         (2 nu + 1) RefR1[{1, n4}, {av - 1}, {bS, b2 + 1}],
       RefR1[{n3_, 2}, {av_}, {bS_, b2_}] :>
        -RefR1[{n3, 0}, {av}, {bS, b2}] -
         (2 nu + 1) RefR1[{n3, 1}, {av - 1}, {bS, b2 + 1}],
       RefR2[{2, n2_}, {av_}, {b1_, bS_}] :>
        -RefR2[{0, n2}, {av}, {b1, bS}] -
         (2 nu + 1) RefR2[{1, n2}, {av - 1}, {b1 + 1, bS}],
       RefR2[{n1_, 2}, {av_}, {b1_, bS_}] :>
        -RefR2[{n1, 0}, {av}, {b1, bS}] -
         (2 nu + 1) RefR2[{n1, 1}, {av - 1}, {b1 + 1, bS}]
       }] &,
   Expand[expr]
   ];


(* ::Chapter:: *)
(*Reference dk0 与 dks*)

referenceDk0Term[expr_] := expr /. {
   RefG[nSet_, aSet_, bSet_] :>
    RefG[nSet, aSet + {1, 0}, bSet] + RefG[nSet, aSet + {0, 1}, bSet],
   RefR1[nSet_, aSet_, bSet_] :> 2 referenceShift[RefR1[nSet, aSet, bSet], 2, 1, 1],
   RefR2[nSet_, aSet_, bSet_] :> 2 referenceShift[RefR2[nSet, aSet, bSet], 2, 1, 1]
   };


referenceDksTerm[expr_] := expr /. {
   g : RefG[nSet_, aSet_, bSet_] :> Module[{fullB2, term1, term2, term3},
     fullB2 = -2 nu + g[[3, 2]];
     term1 = (-fullB2)/(2 ks) * (
        ks^2 referenceShift[g, 3, 2, 2] + g -
         referenceShift[referenceShift[g, 3, 1, -2], 3, 2, 2]
        );
     term2 = 1/(2 ks) * (
        ks^2 referenceShift[referenceShift[referenceShift[g, 1, 3, 1], 2, 1, 1], 3, 2, 1] +
         referenceShift[referenceShift[referenceShift[g, 1, 3, 1], 2, 1, 1], 3, 2, -1] -
         referenceShift[referenceShift[referenceShift[referenceShift[g, 1, 3, 1], 2, 1, 1], 3, 1, -2], 3, 2, 1]
        );
     term3 = 1/(2 ks) * (
        ks^2 referenceShift[referenceShift[referenceShift[g, 1, 4, 1], 2, 2, 1], 3, 2, 1] +
         referenceShift[referenceShift[referenceShift[g, 1, 4, 1], 2, 2, 1], 3, 2, -1] -
         referenceShift[referenceShift[referenceShift[referenceShift[g, 1, 4, 1], 2, 2, 1], 3, 1, -2], 3, 2, 1]
        );
     term1 + term2 + term3
     ],
   r : RefR1[nSet_, aSet_, bSet_] :> Module[{fullB2, term1, term2, term3},
     fullB2 = -2 nu + r[[3, 2]];
     term1 = (-fullB2)/(2 ks) * (
        ks^2 referenceShift[r, 3, 2, 2] + r -
         referenceShift[referenceShift[r, 3, 1, -2], 3, 2, 2]
        );
     term2 = 1/(2 ks) * (
        ks^2 referenceShift[referenceShift[referenceShift[r, 1, 1, 1], 2, 1, 1], 3, 2, 1] +
         referenceShift[referenceShift[referenceShift[r, 1, 1, 1], 2, 1, 1], 3, 2, -1] -
         referenceShift[referenceShift[referenceShift[referenceShift[r, 1, 1, 1], 2, 1, 1], 3, 1, -2], 3, 2, 1]
        );
     term3 = 1/(2 ks) * (
        ks^2 referenceShift[referenceShift[referenceShift[r, 1, 2, 1], 2, 1, 1], 3, 2, 1] +
         referenceShift[referenceShift[referenceShift[r, 1, 2, 1], 2, 1, 1], 3, 2, -1] -
         referenceShift[referenceShift[referenceShift[referenceShift[r, 1, 2, 1], 2, 1, 1], 3, 1, -2], 3, 2, 1]
        );
     term1 + term2 + term3
     ],
   r : RefR2[nSet_, aSet_, bSet_] :> Module[{mapped},
     mapped = RefR1[nSet, aSet, Reverse[bSet]];
     referenceDksTerm[mapped]
     ]
   };


referenceBubbleIntegralDerivative[int_J, k0] := referenceBubbleCanonicalExpression[
   referenceBubbleLegacyToJ[
    referenceBubbleEOM[referenceDk0Term[referenceBubbleJToLegacy[int]]]
    ]
   ];


referenceBubbleIntegralDerivative[int_J, s11] := Module[{radial},
   radial = referenceBubbleCanonicalExpression[
     referenceBubbleLegacyToJ[
      referenceBubbleEOM[referenceDksTerm[referenceBubbleJToLegacy[int]]]
      ]
     ];
   Together[Expand[radial/(2 ks)]] /. {ks^2 -> s11, ks^(-2) -> 1/s11}
   ];


referenceBubbleExpectedTotalDerivative[int1_J, int2_J, variable_] := Module[
   {c1 = variable^2 + rc[1]/variable, c2 = 1 + rc[2] variable + variable^3},
   referenceBubbleCanonicalExpression[Expand[
     D[c1, variable] int1 + c1 referenceBubbleIntegralDerivative[int1, variable] +
      D[c2, variable] int2 + c2 referenceBubbleIntegralDerivative[int2, variable] +
      D[variable^2 + rc[3] variable, variable]
     ]]
   ];
