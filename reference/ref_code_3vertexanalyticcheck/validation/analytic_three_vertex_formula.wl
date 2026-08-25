(* Xianyu-Zang arXiv:2309.10849v2, Eqs. (103)-(110), (141)-(143).
   The total formula assumes real p_i, real heavy masses, and positive r_i. *)

ClearAll[
  XYZZSeriesPower,
  XYZZDressedF, XYZZDressedF2, XYZZDressedF4,
  XYZZThreeVertexC, XYZZThreeVertexA, XYZZThreeVertexB,
  XYZZThreeVertexISS, XYZZThreeVertexISB, XYZZThreeVertexIBS,
  XYZZThreeVertexIBB, XYZZThreeVertexPieces, XYZZThreeVertexBase,
  XYZZThreeVertexTotal, XYZZThreeVertexF2ConvergenceQ,
  XYZZPaperMuFromProjectNu,
  XYZZProjectNu0FromPaperP, XYZZPaperFromProjectStrippedFactor
];

XYZZSeriesPower[x_, 0] := 1;
XYZZSeriesPower[x_, n_Integer?Positive] := x^n;

XYZZDressedF[a_, b_, z_] :=
  Gamma[a] Gamma[b] Hypergeometric2F1[a/2, (1 + a)/2, 1 - b, z];

XYZZDressedF2[a_, b1_, b2_, c1_, c2_, x_, y_, nMax_Integer?NonNegative] :=
  Total@Flatten@Table[
    Gamma[a + m + n] Gamma[b1 + m] Gamma[b2 + n]/
      (Gamma[c1 + m] Gamma[c2 + n]) *
      XYZZSeriesPower[x, m] XYZZSeriesPower[y, n]/(m! n!),
    {m, 0, nMax}, {n, 0, nMax}
  ];

XYZZDressedF4[a_, b_, c1_, c2_, x_, y_, nMax_Integer?NonNegative] :=
  Total@Flatten@Table[
    Gamma[a + m + n] Gamma[b + m + n]/
      (Gamma[c1 + m] Gamma[c2 + n]) *
      XYZZSeriesPower[x, m] XYZZSeriesPower[y, n]/(m! n!),
    {m, 0, nMax}, {n, 0, nMax}
  ];

XYZZThreeVertexC[{p1_, p2_, p3_}, {mu1_, mu2_}, {a1_, a2_}] := Module[
  {p12 = p1 + p2, p23 = p2 + p3, p13 = p1 + p3, p123 = p1 + p2 + p3},
  2^(2 p2 - 1 + I a1 mu1 + I a2 mu2)/
    (Sqrt[Pi] Sin[I a1 Pi mu1] Sin[I a2 Pi mu2]) *
    (
      -Exp[-I Pi (I a1 mu1 + I a2 mu2 + p123/2)]
      + I Exp[-I Pi (I a1 mu1 + p12/2 - p3/2)]
      + I Exp[-I Pi (I a2 mu2 - p1/2 + p23/2)]
      + Exp[I Pi (-p2/2 + p13/2)]
    )
];

XYZZThreeVertexA[
  p : {p1_, p2_, p3_},
  mu : {mu1_, mu2_},
  {a1_, a2_},
  {r1_, r2_, r3_, r4_},
  nMax_Integer?NonNegative
] :=
  XYZZThreeVertexC[p, mu, {a1, a2}] (r1 r2 r3 r4)^(3/2) *
  XYZZDressedF[p1 + I mu1 + 5/2, -I mu1, r1^2] *
  XYZZDressedF[p3 + I mu2 + 5/2, -I mu2, r4^2] *
  XYZZDressedF4[
    (I a1 mu1 + I a2 mu2 + p2 + 4)/2,
    (I a1 mu1 + I a2 mu2 + p2 + 5)/2,
    1 + I a1 mu1,
    1 + I a2 mu2,
    r2^2,
    r3^2,
    nMax
  ];

XYZZThreeVertexB[
  {p1_, p2_, p3_},
  {mu1_, mu2_},
  a_,
  {r1_, r2_, r3_, r4_},
  nMax_Integer?NonNegative
] := Module[
  {p23 = p2 + p3, prefactor, sum},
  prefactor =
    Exp[-I Pi (p23 + I a mu1 - 1/2)/2]/(4 Pi^2) *
    Sin[Pi (I a mu1 + p1 - 3/2)/2] Sin[I Pi mu2] *
    (r1 r2 r3^2)^(3/2) *
    XYZZDressedF[p1 + I mu1 + 5/2, -I mu1, r1^2];

  sum = Total@Flatten@Table[
    (-1)^(n1 + n2 + n3)/(n1! n2! n3!) *
    Gamma[-n1 - I mu2] Gamma[-n2 + I mu2]/
      (p3 + n3 + 2 n2 - I mu2 + 5/2) *
    (r3/2)^(2 (n1 + n2)) (r3/r4)^(n3 + p3 + 1) *
    XYZZDressedF[
      n3 + 2 (n1 + n2) + p23 + I a mu1 + 13/2,
      -I a mu1,
      r2^2
    ],
    {n1, 0, nMax}, {n2, 0, nMax}, {n3, 0, nMax}
  ];

  prefactor sum
];

XYZZThreeVertexISS[p_, mu : {mu1_, mu2_}, r : {r1_, r2_, r3_, r4_},
  nMax_Integer?NonNegative] :=
  Total@Flatten@Table[
    XYZZThreeVertexA[p, mu, {a1, a2}, r, nMax] *
    (r1/2)^(I mu1) (r2/2)^(I a1 mu1) *
    (r3/2)^(I a2 mu2) (r4/2)^(I mu2),
    {a1, {-1, 1}}, {a2, {-1, 1}}
  ];

XYZZThreeVertexISB[p_, mu : {mu1_, mu2_}, r : {r1_, r2_, r3_, r4_},
  nMax_Integer?NonNegative] :=
  Total@Table[
    XYZZThreeVertexB[p, mu, a, r, nMax] *
    (r1/2)^(I mu1) (r2/2)^(I a mu1),
    {a, {-1, 1}}
  ];

XYZZThreeVertexIBS[
  {p1_, p2_, p3_},
  {mu1_, mu2_},
  {r1_, r2_, r3_, r4_},
  nMax_Integer?NonNegative
] :=
  Total@Table[
    XYZZThreeVertexB[
      {p3, p2, p1}, {mu2, mu1}, a, {r4, r3, r2, r1}, nMax
    ] *
    (r4/2)^(I mu2) (r3/2)^(I a mu2),
    {a, {-1, 1}}
  ];

XYZZThreeVertexIBB[
  {p1_, p2_, p3_},
  {mu1_, mu2_},
  {r1_, r2_, r3_, r4_},
  nMax_Integer?NonNegative
] := XYZZThreeVertexIBB[
  {p1, p2, p3}, {mu1, mu2}, {r1, r2, r3, r4}, nMax, nMax
];

XYZZThreeVertexIBB[
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
    XYZZDressedF2[
      p123 + 2 (n1 + n2 + n3 + n4) + 9,
      p1 + 2 n1 + I mu1 + 5/2,
      p3 + 2 n4 + I mu2 + 5/2,
      p1 + 2 n1 + I mu1 + 7/2,
      p3 + 2 n4 + I mu2 + 7/2,
      -r2/r1,
      -r3/r4,
      nF2
    ],
    {n1, 0, nOuter}, {n2, 0, nOuter}, {n3, 0, nOuter}, {n4, 0, nOuter}
  ]
];

XYZZThreeVertexPieces[p_, mu_, r_, nMax_Integer?NonNegative] := <|
  "SS" -> XYZZThreeVertexISS[p, mu, r, nMax],
  "SB" -> XYZZThreeVertexISB[p, mu, r, nMax],
  "BS" -> XYZZThreeVertexIBS[p, mu, r, nMax],
  "BB" -> XYZZThreeVertexIBB[p, mu, r, nMax]
|>;

XYZZThreeVertexBase[p_, mu_, r_, nMax_Integer?NonNegative] :=
  Total[Values[XYZZThreeVertexPieces[p, mu, r, nMax]]];

XYZZThreeVertexTotal[p_, {mu1_, mu2_}, r_, nMax_Integer?NonNegative] :=
  2 Re@Total@Flatten@Table[
    XYZZThreeVertexBase[p, {a1 mu1, a2 mu2}, r, nMax],
    {a1, {-1, 1}}, {a2, {-1, 1}}
  ];

XYZZThreeVertexF2ConvergenceQ[{r1_, r2_, r3_, r4_}] :=
  TrueQ[Abs[r2/r1] + Abs[r3/r4] < 1];

XYZZPaperMuFromProjectNu[{nu1_, nu2_}] := -I {nu1, nu2};

XYZZProjectNu0FromPaperP[
  {p1_, p2_, p3_},
  {nu1_, nu2_}
] := {
  p1 + 3/2 + nu1,
  p2 + 3 + nu1 + nu2,
  p3 + 3/2 + nu2
};

XYZZPaperFromProjectStrippedFactor[
  {p1_, p2_, p3_},
  {nu1_, nu2_},
  {e1_, e2_, e3_},
  {s1_, s2_}
] :=
  -I e1^(p1 + 1) e2^(p2 + 1) e3^(p3 + 1) s1^3 s2^3 *
    (Pi/4)^2 s1^(2 nu1) s2^(2 nu2);
