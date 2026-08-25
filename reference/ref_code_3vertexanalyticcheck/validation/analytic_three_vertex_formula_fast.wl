Get[FileNameJoin[{"validation", "xyzz_three_vertex_formula.wl"}]];

ClearAll[
  XYZZDressedF2OneDimensionalSum,
  XYZZDressedF4OneDimensionalSum,
  XYZZThreeVertexAFast,
  XYZZThreeVertexIBBFast,
  XYZZThreeVertexIBBProjectConventionFast,
  XYZZThreeVertexIBBProjectConventionCorrectionFast,
  XYZZThreeVertexTotalProjectConventionCorrectionFast,
  XYZZThreeVertexPiecesFast,
  XYZZThreeVertexBaseFast,
  XYZZThreeVertexTotalFast
];

(* Valid in the same interior convergence domain used for Eq. (103).  The
   Appell-type double sums are summed analytically in x through Gauss 2F1,
   leaving only the y-series truncation. *)

XYZZDressedF2OneDimensionalSum[
  a_, b1_, b2_, c1_, c2_, x_, y_, nMax_Integer?NonNegative
] :=
  Total@Table[
    Gamma[a + n] Gamma[b1] Gamma[b2 + n]/
      (Gamma[c1] Gamma[c2 + n]) *
      XYZZSeriesPower[y, n]/n! *
      Hypergeometric2F1[a + n, b1, c1, x],
    {n, 0, nMax}
  ];

XYZZDressedF4OneDimensionalSum[
  a_, b_, c1_, c2_, x_, y_, nMax_Integer?NonNegative
] :=
  Total@Table[
    Gamma[a + n] Gamma[b + n]/
      (Gamma[c1] Gamma[c2 + n]) *
      XYZZSeriesPower[y, n]/n! *
      Hypergeometric2F1[a + n, b + n, c1, x],
    {n, 0, nMax}
  ];

XYZZThreeVertexAFast[
  p : {p1_, p2_, p3_},
  mu : {mu1_, mu2_},
  {a1_, a2_},
  {r1_, r2_, r3_, r4_},
  nMax_Integer?NonNegative
] :=
  XYZZThreeVertexC[p, mu, {a1, a2}] (r1 r2 r3 r4)^(3/2) *
  XYZZDressedF[p1 + I mu1 + 5/2, -I mu1, r1^2] *
  XYZZDressedF[p3 + I mu2 + 5/2, -I mu2, r4^2] *
  XYZZDressedF4OneDimensionalSum[
    (I a1 mu1 + I a2 mu2 + p2 + 4)/2,
    (I a1 mu1 + I a2 mu2 + p2 + 5)/2,
    1 + I a1 mu1,
    1 + I a2 mu2,
    r2^2,
    r3^2,
    nMax
  ];

XYZZThreeVertexIBBFast[
  {p1_, p2_, p3_},
  {mu1_, mu2_},
  {r1_, r2_, r3_, r4_},
  nMax_Integer?NonNegative
] := XYZZThreeVertexIBBFast[
  {p1, p2, p3}, {mu1, mu2}, {r1, r2, r3, r4}, nMax, nMax
];

XYZZThreeVertexIBBFast[
  {p1_, p2_, p3_},
  {mu1_, mu2_},
  {r1_, r2_, r3_, r4_},
  nOuter_Integer?NonNegative,
  nF2_Integer?NonNegative
] := Module[
  {p123 = p1 + p2 + p3, prefactor},
  prefactor =
    Sin[I Pi mu1] Sin[I Pi mu2] Exp[-I p123 Pi/2]/(4 Pi^2) *
    r2^3 r3^3 (r2/r1)^(p1 + 1) (r3/r4)^(p3 + 1);

  prefactor Total@Flatten@Table[
    (r2/2)^(2 (n1 + n2)) (r3/2)^(2 (n3 + n4))/
      (n1! n2! n3! n4!) *
    Gamma[-n1 - I mu1] Gamma[-n2 + I mu1] *
    Gamma[-n3 + I mu2] Gamma[-n4 - I mu2] *
    XYZZDressedF2OneDimensionalSum[
      p123 + 2 (n1 + n2 + n3 + n4) + 9,
      p1 + 2 n1 + I mu1 + 5/2,
      p3 + 2 n4 + I mu2 + 5/2,
      p1 + 2 n1 + I mu1 + 7/2,
      p3 + 2 n4 + I mu2 + 7/2,
      -r2/r1,
      -r3/r4,
      nF2
    ],
    {n1, 0, nOuter}, {n2, 0, nOuter},
    {n3, 0, nOuter}, {n4, 0, nOuter}
  ]
];

XYZZThreeVertexIBBProjectConventionFast[
  {p1_, p2_, p3_},
  {mu1_, mu2_},
  {r1_, r2_, r3_, r4_},
  nMax_Integer?NonNegative
] := XYZZThreeVertexIBBProjectConventionFast[
  {p1, p2, p3}, {mu1, mu2}, {r1, r2, r3, r4}, nMax, nMax
];

XYZZThreeVertexIBBProjectConventionFast[
  {p1_, p2_, p3_},
  {mu1_, mu2_},
  {r1_, r2_, r3_, r4_},
  nOuter_Integer?NonNegative,
  nF2_Integer?NonNegative
] := Module[
  {p123 = p1 + p2 + p3, prefactor},
  prefactor =
    Sin[I Pi mu1] Sin[I Pi mu2] Exp[-I p123 Pi/2]/(4 Pi^2) *
      r2^3 r3^3 (r2/r1)^(p1 + 1) (r3/r4)^(p3 + 1);

  prefactor Total@Flatten@Table[
    (-1)^(n1 + n2 + n3 + n4) *
    (r2/2)^(2 (n1 + n2)) (r3/2)^(2 (n3 + n4))/
      (n1! n2! n3! n4!) *
    Gamma[-n1 - I mu1] Gamma[-n2 + I mu1] *
    Gamma[-n3 + I mu2] Gamma[-n4 - I mu2] *
    XYZZDressedF2OneDimensionalSum[
      p123 + 2 (n1 + n2 + n3 + n4) + 9,
      p1 + 2 n1 + I mu1 + 5/2,
      p3 + 2 n4 + I mu2 + 5/2,
      p1 + 2 n1 + I mu1 + 7/2,
      p3 + 2 n4 + I mu2 + 7/2,
      -r2/r1,
      -r3/r4,
      nF2
    ],
    {n1, 0, nOuter}, {n2, 0, nOuter},
    {n3, 0, nOuter}, {n4, 0, nOuter}
  ]
];

XYZZThreeVertexIBBProjectConventionCorrectionFast[
  {p1_, p2_, p3_},
  {mu1_, mu2_},
  {r1_, r2_, r3_, r4_},
  nOuter_Integer?NonNegative,
  nF2_Integer?NonNegative
] := Module[
  {p123 = p1 + p2 + p3, prefactor, parityDifference},
  prefactor =
    Sin[I Pi mu1] Sin[I Pi mu2] Exp[-I p123 Pi/2]/(4 Pi^2) *
      r2^3 r3^3 (r2/r1)^(p1 + 1) (r3/r4)^(p3 + 1);

  prefactor Total@Flatten@Table[
    parityDifference = (-1)^(n1 + n2 + n3 + n4) - 1;
    If[parityDifference == 0,
      0,
      parityDifference *
      (r2/2)^(2 (n1 + n2)) (r3/2)^(2 (n3 + n4))/
        (n1! n2! n3! n4!) *
      Gamma[-n1 - I mu1] Gamma[-n2 + I mu1] *
      Gamma[-n3 + I mu2] Gamma[-n4 - I mu2] *
      XYZZDressedF2OneDimensionalSum[
        p123 + 2 (n1 + n2 + n3 + n4) + 9,
        p1 + 2 n1 + I mu1 + 5/2,
        p3 + 2 n4 + I mu2 + 5/2,
        p1 + 2 n1 + I mu1 + 7/2,
        p3 + 2 n4 + I mu2 + 7/2,
        -r2/r1,
        -r3/r4,
        nF2
      ]
    ],
    {n1, 0, nOuter}, {n2, 0, nOuter},
    {n3, 0, nOuter}, {n4, 0, nOuter}
  ]
];

XYZZThreeVertexTotalProjectConventionCorrectionFast[
  p_, {mu1_, mu2_}, r_, nOuter_Integer?NonNegative,
  nF2_Integer?NonNegative
] :=
  2 Re@Total@Flatten@Table[
    XYZZThreeVertexIBBProjectConventionCorrectionFast[
      p, {a1 mu1, a2 mu2}, r, nOuter, nF2
    ],
    {a1, {-1, 1}}, {a2, {-1, 1}}
  ];

XYZZThreeVertexPiecesFast[p_, mu : {mu1_, mu2_}, r : {r1_, r2_, r3_, r4_},
  nMax_Integer?NonNegative] := XYZZThreeVertexPiecesFast[p, mu, r, nMax, nMax];

XYZZThreeVertexPiecesFast[p_, mu : {mu1_, mu2_}, r : {r1_, r2_, r3_, r4_},
  nOuter_Integer?NonNegative, nF2_Integer?NonNegative] := <|
  "SS" -> Total@Flatten@Table[
    XYZZThreeVertexAFast[p, mu, {a1, a2}, r, nF2] *
    (r1/2)^(I mu1) (r2/2)^(I a1 mu1) *
    (r3/2)^(I a2 mu2) (r4/2)^(I mu2),
    {a1, {-1, 1}}, {a2, {-1, 1}}
  ],
  "SB" -> XYZZThreeVertexISB[p, mu, r, nOuter],
  "BS" -> XYZZThreeVertexIBS[p, mu, r, nOuter],
  "BB" -> XYZZThreeVertexIBBFast[p, mu, r, nOuter, nF2]
|>;

XYZZThreeVertexBaseFast[p_, mu_, r_, nMax_Integer?NonNegative] :=
  Total[Values[XYZZThreeVertexPiecesFast[p, mu, r, nMax]]];

XYZZThreeVertexBaseFast[p_, mu_, r_, nOuter_Integer?NonNegative,
  nF2_Integer?NonNegative] :=
  Total[Values[XYZZThreeVertexPiecesFast[p, mu, r, nOuter, nF2]]];

XYZZThreeVertexTotalFast[p_, {mu1_, mu2_}, r_, nMax_Integer?NonNegative] :=
  2 Re@Total@Flatten@Table[
    XYZZThreeVertexBaseFast[p, {a1 mu1, a2 mu2}, r, nMax],
    {a1, {-1, 1}}, {a2, {-1, 1}}
  ];

XYZZThreeVertexTotalFast[
  p_, {mu1_, mu2_}, r_, nOuter_Integer?NonNegative,
  nF2_Integer?NonNegative
] :=
  2 Re@Total@Flatten@Table[
    XYZZThreeVertexBaseFast[p, {a1 mu1, a2 mu2}, r, nOuter, nF2],
    {a1, {-1, 1}}, {a2, {-1, 1}}
  ];
