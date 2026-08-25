Get[FileNameJoin[{"validation", "xyzz_three_vertex_formula_fast.wl"}]];

$MaxExtraPrecision = 3000;

checks = {
  Abs[N[
    XYZZDressedF2OneDimensionalSum[
      7/3, 5/4, 9/5, 11/4, 13/5, 0, 1/20, 5
    ] -
    XYZZDressedF2[
      7/3, 5/4, 9/5, 11/4, 13/5, 0, 1/20, 5
    ],
    50
  ]],
  Abs[N[
    XYZZDressedF4OneDimensionalSum[
      7/3, 5/4, 11/4, 13/5, 0, 1/20, 5
    ] -
    XYZZDressedF4[
      7/3, 5/4, 11/4, 13/5, 0, 1/20, 5
    ],
    50
  ]],
  Abs[Im[N[
    XYZZThreeVertexTotalFast[
      {0, 0, 0}, {1/2, 2/3}, {1/20, 1/1000, 1/1000, 1/20}, 2
    ],
    40
  ]]]
};

Print[InputForm[N[checks, 30]]];

If[Max[checks] < 10^-25,
  Print["fast formula smoke passed"],
  Print["fast formula smoke failed"];
  Exit[1]
];
