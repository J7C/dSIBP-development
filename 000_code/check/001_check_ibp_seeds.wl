(* ::Package:: *)
(* Check v4: J notation seeds vs reference G/R1 seeds *)
(* 方法: 翻译 J -> G/R1, 取 nu1=nu2=nu, 比较 *)


(* ::Chapter:: *)
(*IBP Seeds Check*)


(* ::Section:: *)
(*Load Data*)

refG = Get["reference/ref_IBPset0G.wl"];
refR1 = Get["reference/ref_IBPset0R1.wl"];
newJ = Get["check_seeds_J.wl"];


(* ::Section:: *)
(*J -> G/R1 Translation*)

(* top sector: J[{a1,a2}, {{b1,n1,n2},{b2,n3,n4}}] -> G[{n1,n2,n3,n4},{a1,a2},{b1,b2}] *)
jToGR[J[{a1_, a2_}, {{b1_, n1_, n2_}, {b2_, n3_, n4_}}]] :=
  G[{n1, n2, n3, n4}, {a1, a2}, {b1, b2}];

(* sub-sector line 1 shrunk: J[{aMerged,a2},{{bS},{b2,n3,n4}}] -> R1[{n3,n4},{aMerged},{bS,b2}] *)
jToGR[J[{aMerged_, a2_}, {{bS_}, {b2_, n3_, n4_}}]] :=
  R1[{n3, n4}, {aMerged}, {bS, b2}];

(* sub-sector line 2 shrunk: J[{aMerged,a2},{{b1,n1,n2},{bS}}] -> R2[{n1,n2},{aMerged},{b1,bS}] *)
jToGR[J[{aMerged_, a2_}, {{b1_, n1_, n2_}, {bS_}}]] :=
  R2[{n1, n2}, {aMerged}, {b1, bS}];

(* Apply translation to all J expressions in a list *)
translateAll[expr_] := expr /. j_J :> jToGR[j];


(* ::Section:: *)
(*Apply Specializations and Translation*)

(* 我的种子: 翻译 + nu1=nu2=nu *)
specNew = translateAll[newJ] /. {nu1 -> nu, nu2 -> nu};

(* 参考种子: P0R1=P1+P2, 并消除基线移位变量 (参考的 repab020 只替换 G/R1/R2 内部, 不替换系数 *)
specRefG = refG /. {P0R1 -> P1 + P2, a10 -> 0, a20 -> 0, b10 -> 0, b20 -> 0,
  a0R -> 0, b10R -> 0, b20R -> 0};
specRefR1 = refR1 /. {P0R1 -> P1 + P2, a10 -> 0, a20 -> 0, b10 -> 0, b20 -> 0,
  a0R -> 0, b10R -> 0, b20R -> 0};


(* ::Section:: *)
(*Structure Check*)

Print["=== Structure Check ==="];
Print["refG: ", Length[specRefG], " ops"];
Print["newG (from J): ", Length[specNew], " ops"];

If[Length[specNew] >= 4,
  Do[
    Print["op ", i, ": ref terms=", Length[specRefG[[i]]],
      " new terms=", Length[specNew[[i]]]],
    {i, Min[4, Length[specRefG]]}
  ],
  Print["ERROR: newG has fewer than 4 operators"]
];


(* ::Section:: *)
(*Element-wise Comparison*)

Print["=== Element-wise Comparison ==="];

gMatch = True; gMis = 0;
If[Length[specNew] >= 4,
  Do[
    Do[
      refTerm = Expand[specRefG[[i, j]]];
      newTerm = Expand[specNew[[i, j]]];
      diff = Simplify[refTerm - newTerm];
      If[diff =!= 0,
        gMis++;
        gMatch = False;
        If[gMis <= 5,
          Print["MISMATCH G[", i, ",", j, "]: diff = ", diff]
        ]
      ],
      {j, Length[specRefG[[i]]]}
    ],
    {i, Length[specRefG]}
  ],
  Print["Skipping G comparison: insufficient operators"]
];

Print["=== Final Result ==="];
Print["G sector: ", If[gMatch, "PASS", "FAIL"], " (", gMis, " mismatches)"];
Print["Overall: ", If[gMatch, "ALL PASS", "HAS FAILURES"]];
