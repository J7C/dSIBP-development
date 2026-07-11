(* ::Package:: *)
(* 从参考代码提取 bubble IBP seeds（EOM后、symmetry前），保存到 reference/ 供 check *)


(* ::Chapter:: *)
(*提取参考代码 Bubble IBP Seeds*)


(* ::Section:: *)
(*Environment Setup*)

baseDir = If[StringQ[$InputFileName] && $InputFileName =!= "",
  DirectoryName[$InputFileName],
  If[TrueQ[$Notebooks],
    With[{nd = Quiet[NotebookDirectory[]]},
      If[StringQ[nd] && nd =!= $Failed, nd, Directory[]]
    ],
    Directory[]
  ]
];
SetDirectory[baseDir];


(* ::Section:: *)
(*Basic Operators (verbatim from ref code L38-55)*)

listcal[expr_, i_, j_, n_] := ReplacePart[expr, {i, j} -> expr[[i, j]] + n]

Ncut = 1;
Vpm = 0;

ibp[expr_G, 1] := -I (-1)^Vpm P1 expr - expr[[2, 1]] listcal[expr, 2, 1, -1] - listcal[listcal[expr, 1, 1, 1], 3, 1, -1] - listcal[listcal[expr, 1, 3, 1], 3, 2, -1] + Ncut (KroneckerDelta[expr[[1, 1]] + expr[[1, 2]], 1] * (-1)^(expr[[1, 1]] + Vpm) * R1[{expr[[1, 3]], expr[[1, 4]]}, {expr[[2, 1]] + expr[[2, 2]] - 2 nu - 1}, {expr[[3, 1]] + 2 nu + 1, expr[[3, 2]]}] + KroneckerDelta[expr[[1, 3]] + expr[[1, 4]], 1] * (-1)^(expr[[1, 3]] + Vpm) * R2[{expr[[1, 1]], expr[[1, 2]]}, {expr[[2, 1]] + expr[[2, 2]] - 2 nu - 1}, {expr[[3, 1]], expr[[3, 2]] + 2 nu + 1}])

ibp[expr_G, 2] := -I (-1)^Vpm P2 expr - expr[[2, 2]] listcal[expr, 2, 2, -1] - listcal[listcal[expr, 1, 2, 1], 3, 1, -1] - listcal[listcal[expr, 1, 4, 1], 3, 2, -1] + Ncut (KroneckerDelta[expr[[1, 1]] + expr[[1, 2]], 1] * (-1)^(expr[[1, 2]] + Vpm) * R1[{expr[[1, 3]], expr[[1, 4]]}, {expr[[2, 1]] + expr[[2, 2]] - 2 nu - 1}, {expr[[3, 1]] + 2 nu + 1, expr[[3, 2]]}] + KroneckerDelta[expr[[1, 3]] + expr[[1, 4]], 1] * (-1)^(expr[[1, 4]] + Vpm) * R2[{expr[[1, 1]], expr[[1, 2]]}, {expr[[2, 1]] + expr[[2, 2]] - 2 nu - 1}, {expr[[3, 1]], expr[[3, 2]] + 2 nu + 1}])

ibp[expr_G, 3] := d expr - expr[[3, 1]] expr - 1/2 expr[[3, 2]] (expr + listcal[listcal[expr, 3, 1, -2], 3, 2, 2] - ks^2 listcal[expr, 3, 2, 2]) + listcal[listcal[listcal[expr, 1, 1, 1], 2, 1, 1], 3, 1, -1] + listcal[listcal[listcal[expr, 1, 2, 1], 2, 2, 1], 3, 1, -1] + 1/2 (listcal[listcal[listcal[expr, 1, 3, 1], 2, 1, 1], 3, 2, -1] + listcal[listcal[listcal[listcal[expr, 1, 3, 1], 2, 1, 1], 3, 1, -2], 3, 2, 1] - ks^2 listcal[listcal[listcal[expr, 1, 3, 1], 2, 1, 1], 3, 2, 1]) + 1/2 (listcal[listcal[listcal[expr, 1, 4, 1], 2, 2, 1], 3, 2, -1] + listcal[listcal[listcal[listcal[expr, 1, 4, 1], 2, 2, 1], 3, 1, -2], 3, 2, 1] - ks^2 listcal[listcal[listcal[expr, 1, 4, 1], 2, 2, 1], 3, 2, 1])

ibp[expr_G, 4] := d expr - expr[[3, 2]] expr - 1/2 expr[[3, 1]] (expr + listcal[listcal[expr, 3, 1, 2], 3, 2, -2] - ks^2 listcal[expr, 3, 1, 2]) + listcal[listcal[listcal[expr, 1, 3, 1], 2, 1, 1], 3, 2, -1] + listcal[listcal[listcal[expr, 1, 4, 1], 2, 2, 1], 3, 2, -1] + 1/2 (listcal[listcal[listcal[expr, 1, 1, 1], 2, 1, 1], 3, 1, -1] + listcal[listcal[listcal[listcal[expr, 1, 1, 1], 2, 1, 1], 3, 1, 1], 3, 2, -2] - ks^2 listcal[listcal[listcal[expr, 1, 1, 1], 2, 1, 1], 3, 1, 1]) + 1/2 (listcal[listcal[listcal[expr, 1, 2, 1], 2, 2, 1], 3, 1, -1] + listcal[listcal[listcal[listcal[expr, 1, 2, 1], 2, 2, 1], 3, 2, -2], 3, 1, 1] - ks^2 listcal[listcal[listcal[expr, 1, 2, 1], 2, 2, 1], 3, 1, 1])


(* R1 Sector IBP (verbatim from ref code L58-61) *)
ibp[expr_R1, 1] := -I (-1)^Vpm P0R1 expr - expr[[2, 1]] listcal[expr, 2, 1, -1] - listcal[listcal[expr, 1, 1, 1], 3, 2, -1] - listcal[listcal[expr, 1, 2, 1], 3, 2, -1]

ibp[expr_R1, 2] := d expr - expr[[3, 1]] expr - 1/2 expr[[3, 2]] (expr + listcal[listcal[expr, 3, 1, -2], 3, 2, 2] - ks^2 listcal[expr, 3, 2, 2]) + 1/2 (listcal[listcal[listcal[expr, 1, 1, 1], 2, 1, 1], 3, 2, -1] + listcal[listcal[listcal[listcal[expr, 1, 1, 1], 2, 1, 1], 3, 1, -2], 3, 2, 1] - ks^2 listcal[listcal[listcal[expr, 1, 1, 1], 2, 1, 1], 3, 2, 1]) + 1/2 (listcal[listcal[listcal[expr, 1, 2, 1], 2, 1, 1], 3, 2, -1] + listcal[listcal[listcal[listcal[expr, 1, 2, 1], 2, 1, 1], 3, 1, -2], 3, 2, 1] - ks^2 listcal[listcal[listcal[expr, 1, 2, 1], 2, 1, 1], 3, 2, 1])

ibp[expr_R1, 3] := d expr - expr[[3, 2]] expr - 1/2 expr[[3, 1]] (expr + listcal[listcal[expr, 3, 1, 2], 3, 2, -2] - ks^2 listcal[expr, 3, 1, 2]) + listcal[listcal[listcal[expr, 1, 1, 1], 2, 1, 1], 3, 2, -1] + listcal[listcal[listcal[expr, 1, 2, 1], 2, 1, 1], 3, 2, -1]


(* ::Section:: *)
(*EOM id (verbatim from ref code L68-78)*)

id[expr_] := expr /. {
  G[{2, n2_, n3_, n4_}, {a1_, a2_}, {b1_, b2_}] :> -G[{0, n2, n3, n4}, {a1, a2}, {b1, b2}] - (2 nu + 1) G[{1, n2, n3, n4}, {a1 - 1, a2}, {b1 + 1, b2}],
  G[{n1_, 2, n3_, n4_}, {a1_, a2_}, {b1_, b2_}] :> -G[{n1, 0, n3, n4}, {a1, a2}, {b1, b2}] - (2 nu + 1) G[{n1, 1, n3, n4}, {a1, a2 - 1}, {b1 + 1, b2}],
  G[{n1_, n2_, 2, n4_}, {a1_, a2_}, {b1_, b2_}] :> -G[{n1, n2, 0, n4}, {a1, a2}, {b1, b2}] - (2 nu + 1) G[{n1, n2, 1, n4}, {a1 - 1, a2}, {b1, b2 + 1}],
  G[{n1_, n2_, n3_, 2}, {a1_, a2_}, {b1_, b2_}] :> -G[{n1, n2, n3, 0}, {a1, a2}, {b1, b2}] - (2 nu + 1) G[{n1, n2, n3, 1}, {a1, a2 - 1}, {b1, b2 + 1}],
  R1[{2, n4_}, {a_}, {b1_, b2_}] :> -R1[{0, n4}, {a}, {b1, b2}] - (2 nu + 1) R1[{1, n4}, {a - 1}, {b1, b2 + 1}],
  R1[{n3_, 2}, {a_}, {b1_, b2_}] :> -R1[{n3, 0}, {a}, {b1, b2}] - (2 nu + 1) R1[{n3, 1}, {a - 1}, {b1, b2 + 1}]
};


(* ::Section:: *)
(*Baseline Shifts & Seed Generation (ref code L127-167)*)

int00G = G[{n1, n2, n3, n4}, {a1, a2}, {b1, b2}];
int00R1 = R1[{n3, n4}, {a}, {b1, b2}];

repaddab0G = {a1 -> a1 + a10, a2 -> a2 + a20, b1 -> b1 + b10, b2 -> b2 + b20};
repaddab0R1 = {a -> a + a0R, b1 -> b1 + b10R, b2 -> b2 + b20R};

repab020[expr_] := expr /. {
  G[c1_, c2_, c3_] :> (G[c1, c2, c3] /. {a10 -> 0, a20 -> 0, a0 -> 0, b10 -> 0, b20 -> 0}),
  R1[c1_, c2_, c3_] :> (R1[c1, c2, c3] /. {a10 -> 0, a20 -> 0, a0R -> 0, b10 -> 0, b20 -> 0, b10R -> 0, b20R -> 0}),
  R2[c1_, c2_, c3_] :> (R2[c1, c2, c3] /. {a10 -> 0, a20 -> 0, a0R -> 0, b10 -> 0, b20 -> 0, b10R -> 0, b20R -> 0})
};

int000G = int00G /. repaddab0G;
int000R1 = int00R1 /. repaddab0R1;

IBPset00G = Table[ibp[int000G, i], {i, 4}];

IBPset0G = Table[
  Table[IBPset00G[[i]], {n1, 0, 1}, {n2, 0, 1}, {n3, 0, 1}, {n4, 0, 1}]
  // Flatten // id // repab020 // DeleteDuplicates,
  {i, 4}
] /. {
  R1[c1_, c2_, c3_] :> (R1[c1, c2, c3] /. nu -> 0),
  R2[c1_, c2_, c3_] :> (R2[c1, c2, c3] /. nu -> 0)
} // Simplify;

IBPset00R1 = Table[ibp[int000R1, i], {i, 3}];

IBPset0R1 = Table[
  Table[IBPset00R1[[i]], {n3, 0, 1}, {n4, 0, 1}]
  // Flatten // id // repab020 // DeleteDuplicates,
  {i, 3}
] // Simplify;


(* ::Section:: *)
(*Export Reference Seeds*)

If[!DirectoryQ["reference"], CreateDirectory["reference"]];
Export["reference/ref_IBPset0G.wl", IBPset0G];
Export["reference/ref_IBPset0R1.wl", IBPset0R1];

Print["Reference seeds exported."];
Print["IBPset0G: ", Length[IBPset0G], " operators, total terms: ", Total[Map[Length, IBPset0G, {1}]]];
Print["IBPset0R1: ", Length[IBPset0R1], " operators, total terms: ", Total[Map[Length, IBPset0R1, {1}]]];
