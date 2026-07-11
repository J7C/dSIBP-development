(* ::Package:: *)

(* ::Chapter:: *)
(*Initialization & Definitions*)


(* ::Section:: *)
(*Note*)


(*--------------------------------\:9879\:76ee\:6458\:8981--------------------------------------
\:672c\:6587\:4ef6\:7528\:4e8e\:751f\:6210\:5b8c\:6574\:7684dS massive bubble \:7684ibp\:4e0e\:504f\:5fae\:5206\:7b97\:7b26 \:4ee5\:53ca\:6784\:9020dlog\:57fa\:ff08\:4e5f\:5199\:5165ibp\:7cfb\:7edf\:4e2d\:ff09   \:5e76\:5c06\:8fd9\:4e9bibp\:8f6c\:5316\:4e3akira\:683c\:5f0f\:751f\:6210kira\:7ea6\:5316\:6240\:9700\:4fe1\:606f\:6587\:4ef6 
-----------------------\:7279\:522b\:6ce8\:610f\:4e8b\:9879------------------------------
R1\:4e2da0 b0\:4e0etopsector\:4e0d\:540c \:6545\:6d89\:53ca\:65f6\:5747\:987b\:5148\:4f7f\:7528a0R  b10R  b20R\:7b49\:4e13\:7528\:53c2\:6570\:ff0c\:540e\:7eed\:7528repvar\:7b49\:53d8\:6362\:5316\:4e3a\:7edf\:4e00\:7684a0 b0 \:518d\:4f7f\:7528reppara2N\:5bf9a0 b0\:53d6\:503c
----------------------------------------------------------------------------------------*)


(* ::Section:: *)
(*Environment Setup*)


dir = If[StringQ[$InputFileName] && $InputFileName =!= "",
  DirectoryName[$InputFileName],
  If[TrueQ[$Notebooks],
    With[{nd = Quiet[NotebookDirectory[]]},
      If[StringQ[nd] && nd =!= $Failed, nd, Directory[]]
    ],
    Directory[]
  ]
];
SetDirectory[dir];


(* ::Section:: *)
(*Basic IBP & Shift Operators*)


(* \:7edf\:4e00\:7684\:6307\:6807\:5e73\:79fb\:5de5\:5177 *)
listcal[expr_, i_, j_, n_] := ReplacePart[expr, {i, j} -> expr[[i, j]] + n]


(*   Top Sector G 4\:6761 IBP\:ff1a\:65f6\:95f4(2)\:3001\:52a8\:91cf(2)  *)
Ncut=1(*Ncut=1 \:4e0d\:5ffd\:7565topsector\:4e2d\:7684R1,  Ncut=0 \:5ffd\:7565R1*);
Vpm=0 (*Vpm=0\:4e3aV--, Vpm=1\:4e3aV++,  \:6ce8\:610fdlog\:6784\:9020\:5904\:672a\:52a0\:5165\:6b64\:53c2\:6570\:ff0c\:4fee\:6539\:4e3aV++\:65f6\:9700\:53e6\:5916\:624b\:52a8\:4fee\:6539*);
ibp[expr_G, 1] := -I (-1)^Vpm P1 expr - expr[[2, 1]] listcal[expr, 2, 1, -1] - listcal[listcal[expr, 1, 1, 1], 3, 1, -1] - listcal[listcal[expr, 1, 3, 1], 3, 2, -1] +  Ncut(KroneckerDelta[expr[[1, 1]] + expr[[1, 2]], 1] * (-1)^(expr[[1, 1]] + Vpm) * R1[{expr[[1, 3]], expr[[1, 4]]}, {expr[[2, 1]] + expr[[2, 2]] - 2 nu - 1}, {expr[[3, 1]] + 2 nu + 1, expr[[3, 2]]}] + KroneckerDelta[expr[[1, 3]] + expr[[1, 4]], 1] * (-1)^(expr[[1, 3]] + Vpm) * R2[{expr[[1, 1]], expr[[1, 2]]}, {expr[[2, 1]] + expr[[2, 2]] - 2 nu - 1}, {expr[[3, 1]], expr[[3, 2]] + 2 nu + 1}])
ibp[expr_G, 2] := -I (-1)^Vpm P2 expr - expr[[2, 2]] listcal[expr, 2, 2, -1] - listcal[listcal[expr, 1, 2, 1], 3, 1, -1] - listcal[listcal[expr, 1, 4, 1], 3, 2, -1] +  Ncut(KroneckerDelta[expr[[1, 1]] + expr[[1, 2]], 1] * (-1)^(expr[[1, 2]] + Vpm) * R1[{expr[[1, 3]], expr[[1, 4]]}, {expr[[2, 1]] + expr[[2, 2]] - 2 nu - 1}, {expr[[3, 1]] + 2 nu + 1, expr[[3, 2]]}] + KroneckerDelta[expr[[1, 3]] + expr[[1, 4]], 1] * (-1)^(expr[[1, 4]] + Vpm) * R2[{expr[[1, 1]], expr[[1, 2]]}, {expr[[2, 1]] + expr[[2, 2]] - 2 nu - 1}, {expr[[3, 1]], expr[[3, 2]] + 2 nu + 1}])
(* Momentum IBP 1: eq:momIBP_qdot from note main.tex line 380-400.
   0 = D*B - b1*B - (1/2)*b2*(B + B[{b1-2,b2+2}] - ks^2*B[{b1,b2+2}])
       + B[{n1+1},{a1+1},{b1-1,b2}] + B[{n2+1},{a2+1},{b1-1,b2}]
       + (1/2)(B[{n3+1},{a1+1},{b1,b2-1}] + B[{n3+1},{a1+1},{b1+2,b2+1}] - ks^2*B[{n3+1},{a1+1},{b1,b2+1}])
       + (1/2)(B[{n4+1},{a2+1},{b1,b2-1}] + B[{n4+1},{a2+1},{b1-2,b2+1}] - ks^2*B[{n4+1},{a2+1},{b1,b2+1}]) *)
ibp[expr_G, 3] := d expr - expr[[3, 1]] expr - 1/2 expr[[3, 2]] (expr + listcal[listcal[expr, 3, 1, -2], 3, 2, 2] - ks^2 listcal[expr, 3, 2, 2]) + listcal[listcal[listcal[expr, 1, 1, 1], 2, 1, 1], 3, 1, -1] + listcal[listcal[listcal[expr, 1, 2, 1], 2, 2, 1], 3, 1, -1] + 1/2 (listcal[listcal[listcal[expr, 1, 3, 1], 2, 1, 1], 3, 2, -1] + listcal[listcal[listcal[listcal[expr, 1, 3, 1], 2, 1, 1], 3, 1, -2], 3, 2, 1] - ks^2 listcal[listcal[listcal[expr, 1, 3, 1], 2, 1, 1], 3, 2, 1]) + 1/2 (listcal[listcal[listcal[expr, 1, 4, 1], 2, 2, 1], 3, 2, -1] + listcal[listcal[listcal[listcal[expr, 1, 4, 1], 2, 2, 1], 3, 1, -2], 3, 2, 1] - ks^2 listcal[listcal[listcal[expr, 1, 4, 1], 2, 2, 1], 3, 2, 1])
(* Momentum IBP 2: obtained from IBP 1 by {n1,n2,n3,n4}<->{n3,n4,n1,n2} and {b1,b2}<->{b2,b1}
   (note main.tex line 411-415) *)
ibp[expr_G, 4] := d expr - expr[[3, 2]] expr - 1/2 expr[[3, 1]] (expr + listcal[listcal[expr, 3, 1, 2], 3, 2, -2] - ks^2 listcal[expr, 3, 1, 2]) + listcal[listcal[listcal[expr, 1, 3, 1], 2, 1, 1], 3, 2, -1] + listcal[listcal[listcal[expr, 1, 4, 1], 2, 2, 1], 3, 2, -1] + 1/2 (listcal[listcal[listcal[expr, 1, 1, 1], 2, 1, 1], 3, 1, -1] + listcal[listcal[listcal[listcal[expr, 1, 1, 1], 2, 1, 1], 3, 1, 1], 3, 2, -2] - ks^2 listcal[listcal[listcal[expr, 1, 1, 1], 2, 1, 1], 3, 1, 1]) + 1/2 (listcal[listcal[listcal[expr, 1, 2, 1], 2, 2, 1], 3, 1, -1] + listcal[listcal[listcal[listcal[expr, 1, 2, 1], 2, 2, 1], 3, 2, -2], 3, 1, 1] - ks^2 listcal[listcal[listcal[expr, 1, 2, 1], 2, 2, 1], 3, 1, 1])


(* R1 Sector \:4e09\:6761 IBP\:ff1a\:65f6\:95f4\:3001\:52a8\:91cf\:3001\:4e92\:8865\:52a8\:91cf *)
ibp[expr_R1, 1] := -I (-1)^Vpm P0R1  expr - expr[[2, 1]] listcal[expr, 2, 1, -1] - listcal[listcal[expr, 1, 1, 1], 3, 2, -1] - listcal[listcal[expr, 1, 2, 1], 3, 2, -1]
ibp[expr_R1, 2] := d expr - expr[[3, 1]] expr - 1/2 expr[[3, 2]] (expr + listcal[listcal[expr, 3, 1, -2], 3, 2, 2] - ks^2 listcal[expr, 3, 2, 2]) + 1/2 (listcal[listcal[listcal[expr, 1, 1, 1], 2, 1, 1], 3, 2, -1] + listcal[listcal[listcal[listcal[expr, 1, 1, 1], 2, 1, 1], 3, 1, -2], 3, 2, 1] - ks^2 listcal[listcal[listcal[expr, 1, 1, 1], 2, 1, 1], 3, 2, 1]) + 1/2 (listcal[listcal[listcal[expr, 1, 2, 1], 2, 1, 1], 3, 2, -1] + listcal[listcal[listcal[listcal[expr, 1, 2, 1], 2, 1, 1], 3, 1, -2], 3, 2, 1] - ks^2 listcal[listcal[listcal[expr, 1, 2, 1], 2, 1, 1], 3, 2, 1])
ibp[expr_R1, 3] := d expr - expr[[3, 2]] expr - 1/2 expr[[3, 1]] (expr + listcal[listcal[expr, 3, 1, 2], 3, 2, -2] - ks^2 listcal[expr, 3, 1, 2]) + listcal[listcal[listcal[expr, 1, 1, 1], 2, 1, 1], 3, 2, -1] + listcal[listcal[listcal[expr, 1, 2, 1], 2, 1, 1], 3, 2, -1]


(* ::Section:: *)
(*Integral Substitutions & Symmetries*)


(* Hankel \:65b9\:7a0b EOM\:ff1a\:628a n=2 \:9012\:5f52\:5230 n=0,1 *)
id[expr_] := expr /. {
  (* Top Sector EOM *)
  G[{2, n2_, n3_, n4_}, {a1_, a2_}, {b1_, b2_}] :> -G[{0, n2, n3, n4}, {a1, a2}, {b1, b2}] - (2 nu + 1) G[{1, n2, n3, n4}, {a1 - 1, a2}, {b1 + 1, b2}],
  G[{n1_, 2, n3_, n4_}, {a1_, a2_}, {b1_, b2_}] :> -G[{n1, 0, n3, n4}, {a1, a2}, {b1, b2}] - (2 nu + 1) G[{n1, 1, n3, n4}, {a1, a2 - 1}, {b1 + 1, b2}],
  G[{n1_, n2_, 2, n4_}, {a1_, a2_}, {b1_, b2_}] :> -G[{n1, n2, 0, n4}, {a1, a2}, {b1, b2}] - (2 nu + 1) G[{n1, n2, 1, n4}, {a1 - 1, a2}, {b1, b2 + 1}],
  G[{n1_, n2_, n3_, 2}, {a1_, a2_}, {b1_, b2_}] :> -G[{n1, n2, n3, 0}, {a1, a2}, {b1, b2}] - (2 nu + 1) G[{n1, n2, n3, 1}, {a1, a2 - 1}, {b1, b2 + 1}],
  (* R1 Sector EOM *)
  R1[{2, n4_}, {a_}, {b1_, b2_}] :> -R1[{0, n4}, {a}, {b1, b2}] - (2 nu + 1) R1[{1, n4}, {a - 1}, {b1, b2 + 1}],
  R1[{n3_, 2}, {a_}, {b1_, b2_}] :> -R1[{n3, 0}, {a}, {b1, b2}] - (2 nu + 1) R1[{n3, 1}, {a - 1}, {b1, b2 + 1}]
};


(* \:5bf9\:79f0\:6027\:ff1aTop Sector \:5185\:90e8 + R1 \:5185\:90e8 + R2 \:8f6c R1 *)
symmetry[expr_] := Module[{test},
(* R2 -> R1 (Eq 43) *)test=expr /. {R2[{n1_, n2_}, {a_}, {b1_, b2_}] :> R1[{n1, n2}, {a}, {b2, b1}]};
(* Top Sector Symmetry *) test=test/.G[{n1_, n2_, n3_, n4_}, {a1_, a2_}, {b1_, b2_}] :> If[a1 > a2, G[{n2, n1, n4, n3}, {a2, a1}, {b1, b2}], G[{n1, n2, n3, n4}, {a1, a2}, {b1, b2}]] /.
  G[{n1_, n2_, n3_, n4_}, {a1_, a2_}, {b1_, b2_}] :> If[b1 > b2, G[{n3, n4, n1, n2}, {a1, a2}, {b2, b1}], G[{n1, n2, n3, n4}, {a1, a2}, {b1, b2}]] /.
  G[{n1_, n2_, n3_, n4_}, {a1_, a2_}, {b1_, b2_}] :> If[a1 == a2 && n1 > n2, G[{n2, n1, n4, n3}, {a2, a1}, {b1, b2}], G[{n1, n2, n3, n4}, {a1, a2}, {b1, b2}]] /.
  G[{n1_, n2_, n3_, n4_}, {a1_, a2_}, {b1_, b2_}] :> If[a1 == a2 && n1 == n2 && n3 > n4, G[{n2, n1, n4, n3}, {a2, a1}, {b1, b2}], G[{n1, n2, n3, n4}, {a1, a2}, {b1, b2}]] /.
  G[{n1_, n2_, n3_, n4_}, {a1_, a2_}, {b1_, b2_}] :> If[b1 == b2 && n1 > n3, G[{n3, n4, n1, n2}, {a1, a2}, {b2, b1}], G[{n1, n2, n3, n4}, {a1, a2}, {b1, b2}]] /.
  G[{n1_, n2_, n3_, n4_}, {a1_, a2_}, {b1_, b2_}] :> If[b1 == b2 && n1 == n3 && n2 > n4, G[{n3, n4, n1, n2}, {a1, a2}, {b2, b1}], G[{n1, n2, n3, n4}, {a1, a2}, {b1, b2}]];
(* R1 Sector Symmetry *) test=test/.R1[{n3_, n4_}, {a_}, {b1_, b2_}] :> If[n3 > n4, R1[{n4, n3}, {a}, {b1, b2}], R1[{n3, n4}, {a}, {b1, b2}]];
Return[test];
];


(* \:5947\:5076\:6027\:7b5b\:9009 *)
(* Top Sector: n1+n2+b1 \:4e3a\:5076\:6570, \:4e14 n3+n4+b2 \:4e3a\:5076\:6570 *)
(* R1 Sector: b1 \:4e3a\:5076\:6570, \:4e14 n3+n4+b2 \:4e3a\:5076\:6570 *)
(* \:9700\:5728symmetry R2->R1 \:4e4b\:540e\:4f7f\:7528 *)
reppowerselection = {
  G[{n1_, n2_, n3_, n4_}, {a1_, a2_}, {b1_, b2_}] /; (OddQ[n1 + n2 + b1] || OddQ[n3 + n4 + b2]) :> 0,
  R1[{n3_, n4_}, {a_}, {b1_, b2_}] /; (OddQ[b1] || OddQ[n3 + n4 + b2]) :> 0
};


(* 1D\[RightArrow]3D \:5347\:7ef4\:6620\:5c04----------\:5bf9\:79ef\:5206\:6307\:6807\:4e2da0 b0\:5df2\:88abshift\:6389\:ff08\:5269\:4e0b\:5269\:4e0b\:6574\:6570\:ff09\:7684\:79ef\:5206\:4f7f\:7528\:ff01\:ff01\:ff01 \:53ea\:7528\:5230dlog\:6784\:9020\:4e2d*)
repdimplus2[expr_] := Module[{res},
  res = expr /. {
    G[c1_, c2_, c3_] :> (
      2 ((b10 + c3[[1]]) (G[c1, c2, c3] // listcal[#, 3, 1, 2] &)
       + (b20 + c3[[2]]) (G[c1, c2, c3] // listcal[#, 3, 2, 2] &))
      - 2 ((G[c1, c2, c3] // listcal[#, 1, 1, 1] & // listcal[#, 2, 1, 1] & // listcal[#, 3, 1, 1] &)
       + (G[c1, c2, c3] // listcal[#, 1, 2, 1] & // listcal[#, 2, 2, 1] & // listcal[#, 3, 1, 1] &)
       + (G[c1, c2, c3] // listcal[#, 1, 3, 1] & // listcal[#, 2, 1, 1] & // listcal[#, 3, 2, 1] &)
       + (G[c1, c2, c3] // listcal[#, 1, 4, 1] & // listcal[#, 2, 2, 1] & // listcal[#, 3, 2, 1] &))
    ),
    R1[c1_, c2_, c3_] :> (
      2 ((b10R + c3[[1]]) (R1[c1, c2, c3] // listcal[#, 3, 1, 2] &)
       + (b20R + c3[[2]]) (R1[c1, c2, c3] // listcal[#, 3, 2, 2] &))
      - 2 ((R1[c1, c2, c3] // listcal[#, 1, 1, 1] & // listcal[#, 2, 1, 1] & // listcal[#, 3, 2, 1] &)
       + (R1[c1, c2, c3] // listcal[#, 1, 2, 1] & // listcal[#, 2, 1, 1] & // listcal[#, 3, 2, 1] &))
    )
  };
  res // id // symmetry
];


(* \:901a\:7528\:79ef\:5206\:4e0e a0/b0 \:57fa\:7ebf\:4f4d\:79fb *)
int00G = G[{n1, n2, n3, n4}, {a1, a2}, {b1, b2}];
int00R1 = R1[{n3, n4}, {a}, {b1, b2}];

repaddab0G = {a1 -> a1 + a10, a2 -> a2 + a20, b1 -> b1 + b10, b2 -> b2 + b20};
repaddab0R1 = {a -> a + a0R , b1 -> b1 + b10R, b2 -> b2 + b20R};

repab020[expr_] := expr /. {
  G[c1_, c2_, c3_] :> (G[c1, c2, c3] /. {a10 -> 0, a20 -> 0, a0 -> 0, b10 -> 0, b20 -> 0}),
  R1[c1_, c2_, c3_] :> (R1[c1, c2, c3] /. {a10 -> 0, a20 -> 0, a0R -> 0, b10 -> 0, b20 -> 0 , b10R->0, b20R->0 } )(*bubble dtau-IBP\:4e2d R1\:91cc\:6307\:6807\:4f1a\:51fa\:73b0a10 a20  \:6545\:8981\:52a0\:4e0a*),
  R2[c1_, c2_, c3_] :> (R2[c1, c2, c3] /. {a10 -> 0, a20 -> 0, a0R -> 0, b10 -> 0, b20 -> 0 , b10R->0, b20R->0 } )
};


(* Kira \:4fa7\:91c7\:7528\:7684\:53c2\:6570\:66ff\:6362 *)
(* \:6ce8\:610f\:ff1aTop Sector P1=P2=P0, R1 Sector P0R1 = 2 P0 *)
repvar = {P1 -> -I k0, P2 -> -I k0, P0R1 -> -2 I k0, a10 -> a0, a20 -> a0, b10 -> b0, b20 -> b0 ,a0R-> 2a0 - 2nu, b10R-> b0+2nu, b20R-> b0};
reppara2N = {a0 -> (*da +*) 2 nu,  b0 -> -2 nu,  d -> 3 - 2 ep, ks -> 1};


(* ::Section:: *)
(*Generating Base IBP Seeds*)


int000G = int00G /. repaddab0G
int000R1 = int00R1 /. repaddab0R1

IBPset00G = Table[ibp[int000G, i], {i, 4}];
IBPset0G = Table[
  Table[IBPset00G[[i]], {n1, 0, 1}, {n2, 0, 1}, {n3, 0, 1}, {n4, 0, 1}]  // Flatten // id // repab020  // DeleteDuplicates
  , {i, 4}
] /. {
  R1[c1_, c2_, c3_] :> (R1[c1, c2, c3] /. nu -> 0),
  R2[c1_, c2_, c3_] :> (R2[c1, c2, c3] /. nu -> 0)
}(*bubble\:6536\:7f29\:4f20\:64ad\:5b50\:751f\:6210\:7684R1\:91cc\:6709\:989d\:5916\:7684nu\:56e0\:5b50\:ff0c\:4e0eR1\:51fd\:6570\:65cf\:8bb0\:53f7\:672a\:7edf\:4e00\:ff0c\:7ecf\:8fc7\:8be5\:53d8\:6362\:540e\:7edf\:4e00*)//Simplify;

IBPset00R1 = Table[ibp[int000R1, i], {i, 3}];
IBPset0R1 = Table[
  Table[IBPset00R1[[i]], {n3, 0, 1}, {n4, 0, 1}] // Flatten // id // repab020  // DeleteDuplicates
  , {i, 3}
]//Simplify;


(* ::Chapter:: *)
(*IBP Generation & Export*)


(* ::Section:: *)
(*Generating and Expanding IBP Equations*)


(* Top Sector Ranges *)
(*aMin = -1; aMax = 2; bMin = 1; bMax = 3;*)
aMin = -1; aMax = 2; bMin = 1; bMax = 3;

(* R1 Sector Ranges (Matched or Expanded) *)
aR1Min = -4; aR1Max = 8; bR1Min = -4; bR1Max = 8;


Print["Generating IBP equations..."];
AbsoluteTiming[
IBPset1G = Join[
  (* Top Sector *)
  Table[IBPset0G[[1]]  /. repvar /. reppara2N, {a1, -1-aMin, 2+aMax}, {a2, -2-aMin, 2+aMax}, {b1, -1-bMin, 2+bMax}, {b2, -1-bMin, 2+bMax}],
  Table[IBPset0G[[2]] /. repvar /. reppara2N, {a1, -2-aMin, 2+aMax}, {a2, -1-aMin, 2+aMax}, {b1, -1-bMin, 2+bMax}, {b2, -1-bMin, 2+bMax}],
  Table[IBPset0G[[3]]  /. repvar /. reppara2N, {a1, -2-aMin, 1+aMax}, {a2, -2-aMin, 1+aMax}, {b1, 0-bMin, 2+bMax}, {b2, -1-bMin, 0+bMax}],
  Table[IBPset0G[[4]]  /. repvar /. reppara2N, {a1, -2-aMin, 1+aMax}, {a2, -2-aMin, 1+aMax}, {b1, -1-bMin, 0+bMax}, {b2, 0-bMin, 2+bMax}]
] // id // symmetry // Flatten // DeleteDuplicates;

IBPset1R1 = Join[
  (* R1 Sector *)
  Table[IBPset0R1[[1]] /. repvar /. reppara2N, {a, aR1Min+1, aR1Max}, {b1, bR1Min, bR1Max}, {b2, bR1Min+1, bR1Max}],
  Table[IBPset0R1[[2]] /. repvar /. reppara2N, {a, aR1Min, aR1Max-1}, {b1, bR1Min+2, bR1Max}, {b2, bR1Min+1, bR1Max-2}],
  Table[IBPset0R1[[3]] /. repvar /. reppara2N, {a, aR1Min, aR1Max-1}, {b1, bR1Min, bR1Max-2}, {b2, bR1Min+2, bR1Max}]
] // id // symmetry // Flatten // DeleteDuplicates;
]


IBPset1 = Join[IBPset1G, IBPset1R1] // DeleteDuplicates;
Print["Raw Top Sector (G) Equation Count: ", Length[IBPset1G]];
Print["Raw R1 Sector Equation Count: ", Length[IBPset1R1]];

Print["Applying power selection and Expand..."];
AbsoluteTiming[
IBPsetPG = ReplaceAll[IBPset1G, reppowerselection] // Expand // DeleteDuplicates // Complement[#, {0}] &;
IBPsetPR1 = ReplaceAll[IBPset1R1, reppowerselection] // Expand // DeleteDuplicates // Complement[#, {0}] &;
(* --------select the part you want to reduce---------------*)
IBPsetP0 = Join[IBPsetPG, IBPsetPR1] (*// DeleteDuplicates*);
]
Print["Selected Top Sector (G) Equation Count: ", Length[IBPsetPG]];
Print["Selected R1 Sector Equation Count: ", Length[IBPsetPR1]];
Print["Final Equation Count: ", Length[IBPsetP0]];

varsetAll = IBPsetP0 // Cases[#, _R1 | _G, Infinity] & // DeleteDuplicates;
Print["Final Integral Count: ", Length[varsetAll]];


(* ::Section:: *)
(*Constructing Master Integrals (MIs) & dlog Basis*)


(* Load Omega and MIs for R1 sector from generated files *)
Get["OmegaR/OmegaR1.m"]; (* Defines OmegaP0Ref, etc. *)
Get["OmegaR/MIsR1.m"];   (* Defines MIs (which we rename to MIsR1) *)
MIsR1 = MIs;
OmegaP0R1Ref = OmegaP0R1Ref/. a0 -> a0R
Omegax2Ref = Omegax2Ref/. a0 -> a0R;
OmegaPlusRef = OmegaPlusRef/. a0 -> a0R;
OmegaMinusRef = OmegaMinusRef/. a0 -> a0R;

(* Load the full folded tau-side DE and its matching tau master ordering. *)
OmegaTauFolded = Import["Omegatau/OmegaFolded.m"];
MIstau = Import["Omegatau/MIstau.m"];
OmegaTauX2C = Coefficient[OmegaTauFolded, log[x2]] // Simplify;


(* ----- Top-sector dlog basis (follow bubble_top notebook operation order exactly) ----- *)
(* Order for each block: raw expression -> reppowerselection -> Simplify -> symmetry -> DeleteDuplicates -> Complement[{0}] *)

(* basisd1 / basisd3: generate via Table over all 16 binary index states, then filter by reppowerselection *)
basisdTopSeed = Flatten[Table[G[{n1,n2,n3,n4},{0,0},{0,0}],{n1,0,1},{n2,0,1},{n3,0,1},{n4,0,1}]] ;
basisd1Top=Join[basisdTopSeed/. 
  G[nset_, {0, 0}, {0, 0}] :> G[nset, {0, 0}, {1, 0}] /. reppowerselection // Simplify // symmetry // DeleteDuplicates // Complement[#, {0}] &,
  basisdTopSeed/. 
  G[nset_, {0, 0}, {0, 0}] :> G[nset, {1, 0}, {0, 0}] /. reppowerselection // Simplify // symmetry // DeleteDuplicates // Complement[#, {0}] &
 ]

basisd123Top = repdimplus2 /@ basisd1Top /. reppowerselection // Simplify // symmetry // DeleteDuplicates // Complement[#, {0}] &;

basisd3Top=Join[basisdTopSeed/. 
  G[nset_, {0, 0}, {0, 0}] :> G[nset, {0, 0}, {2, 2}] /. reppowerselection // Simplify // symmetry // DeleteDuplicates // Complement[#, {0}] &,
  basisdTopSeed/. 
  G[nset_, {0, 0}, {0, 0}] :> G[nset, {1, 0}, {2, 1}] /. reppowerselection // Simplify // symmetry // DeleteDuplicates // Complement[#, {0}] & ]

basisd1Top//Length
basisd3Top//Length


(* Only the top-sector part (first 16 entries) of MIstau enters the top-sector dlog basis. *)
basisd32SeedTopTau = MIstau /. {
  G[nset_, {0, 0}, {0, 0}] :> G[nset, {0, 0}, {1, 3}],
  R1[nset_, {0}, {0, 0}] :> R1[nset, {0}, {1, 3}] 
};
basisd12SeedTopTau = MIstau/. {
  G[nset_, {0, 0}, {0, 0}] :> G[nset, {0, 0}, {0, 1}],
   R1[nset_, {0}, {0, 0}] :> R1[nset, {0}, {0, 1}] 
};

basisd3OmegaTop0 = basisd32SeedTopTau*(b0 + 1) -  Transpose[OmegaTauX2C . Transpose[basisd32SeedTopTau]];
basisd1OmegaTop0 = basisd12SeedTopTau*(b0 - 1) -  Transpose[OmegaTauX2C . Transpose[basisd12SeedTopTau]];

basisd3OmegaTop = basisd3OmegaTop0[[1;;16]] /. reppowerselection // Simplify // symmetry // DeleteDuplicates // Complement[#, {0}] &;
basisd1OmegaTop = basisd1OmegaTop0[[1;;16]] /. reppowerselection // Simplify // symmetry // DeleteDuplicates // Complement[#, {0}] &;
basisd123OmegaTop = repdimplus2 /@ basisd1OmegaTop /. reppowerselection //id// Simplify // symmetry // DeleteDuplicates // Complement[#, {0}] &;

basisd3OmegaTop
basisd1OmegaTop


(* raw export order mirroring bubble_top MIdlogO *)
MIdlogTop0 = Join[
  basisd1Top /. G[c__] :> G[c, 1],
  basisd3Top /. G[c__] :> G[c, 3],
  basisd3OmegaTop /. G[c__] :> G[c, 3] /. R1[c__] :> R1[c, 3](*,
  basisd1OmegaTop /. G[c__] :> G[c, 1] /. R1[c__] :> R1[c, 1]*)
];

(* working 3D order mirroring bubble_top MIdlog0.
   Use Flatten[{...}] instead of Join to handle empty component lists correctly. *)
MIdlogTop = Flatten[{basisd123Top, basisd3Top, basisd3OmegaTop(*, basisd1OmegaTop*)}] // Simplify;


(* Construct R1 Sector dlog basis *)
vec3Da0R1 = MIsR1 /. {a -> 0, b1 -> 2, b2 -> 2};
vec3Da1R1 = MIsR1 /. {a -> 1, b1 -> 2, b2 -> 1};
vec3Da0tR1 = MIsR1 /. {a -> 0, b1 -> 2, b2 -> 1};
OmegaInfinityRef = -(Omegax2Ref + OmegaPlusRef + OmegaMinusRef) /. a0 -> a0R // Simplify;

vec3Da1CorrR1 = vec3Da1R1 + (I/P0R1) * OmegaP0R1Ref . (MIsR1 /. {a -> 0, b1 -> 2, b2 -> 1}) // Simplify;

vec3Da0tCorrR1 = (2/P0R1) * (((b20R - 1) IdentityMatrix[Length[MIsR1]] - OmegaInfinityRef) . vec3Da0tR1) // Simplify;

basis3DR1 = Join[
  ks * vec3Da0R1 /. reppowerselection // Complement[#, {0}] & // symmetry // DeleteDuplicates ,
  (-I) * ks * vec3Da0tCorrR1 /. reppowerselection // Complement[#, {0}] & // symmetry // DeleteDuplicates ,
  ks * vec3Da1CorrR1 /. reppowerselection // Complement[#, {0}] & // symmetry // DeleteDuplicates 
] // Simplify;

vec1Da010R1 = MIsR1 /. {a -> 0, b1 -> 1, b2 -> 0};
vec1Da001R1 = MIsR1 /. {a -> 0, b1 -> 0, b2 -> 1};
vec1Da100R1 = MIsR1 /. {a -> 1, b1 -> 0, b2 -> 0};
vec1Da000R1 = MIsR1 /. {a -> 0, b1 -> 0, b2 -> 0};
vec1Da100CorrR1 = vec1Da100R1 + (I/P0R1) * OmegaP0R1Ref . vec1Da000R1;

basis1DR1 = Join[
  vec1Da010R1/. reppowerselection//symmetry // Complement[#, {0}] & // DeleteDuplicates,
  vec1Da001R1/. reppowerselection//symmetry // Complement[#, {0}] & // DeleteDuplicates,
  vec1Da100CorrR1/. reppowerselection//symmetry // Complement[#, {0}] & // DeleteDuplicates
]  // Simplify;

basis1D3DR1 = (repdimplus2 /@ basis1DR1)  //id//symmetry // Simplify;

MIdlogR10 = Join[
  basis3DR1 /. R1[c__] :> R1[c, 3],
  basis1DR1 /. R1[c__] :> R1[c, 1]
];
MIdlogR1 = Join[basis3DR1, basis1D3DR1]  // Simplify;


(* Final combined outputs *)
MIdlogNote0 = Join[MIdlogTop0, MIdlogR10] // Flatten;(*d=1 d=3*)
MIdlogNote = Join[MIdlogTop, MIdlogR1] // Flatten;(*all d=3*)

Print["basisd123Top length: ", Length[basisd123Top]];
Print["basisd3Top length: ", Length[basisd3Top]];
Print["basisd3OmegaTop length: ", Length[basisd3OmegaTop]];
Print["basisd1OmegaTop length: ", Length[basisd1OmegaTop]];
Print["MIdlogR1 length: ", Length[MIdlogR1]];
Print["MIdlogNote length: ", Length[MIdlogNote]];
MIdlogKira = (MIdlogNote /. repvar /. reppara2N) // Simplify;
(MIdlogKira//MatrixForm)


(* ::Section:: *)
(*Derivatives (k0, ks)*)


dk0Term[expr_] := expr /. {
  G[c1_, c2_, c3_] :> G[c1, c2 + {1, 0}, c3] + G[c1, c2 + {0, 1}, c3],
  R1[c1_, c2_, c3_] :> 2 (*\:7edf\:4e00\:8003\:8651bubble\:4e0eR1\:65f6\:ff0cR1\:4e2de\:6307\:6570\:662fE^(-2 k0 tau,\:6240\:4ee5\:6c42k0\:5bfc\:6570\:5f97\:5230\:7684\:56e0\:5b50\:662f2*\:ff08-tau\:ff09)*) listcal[R1[c1, c2, c3], 2, 1, 1]
};

dk0[expr_] := D[expr, k0] + (Expand[expr] /. a_. r:(G[__] | R1[__]) :> a * dk0Term[r]);

dksTerm[expr_] := expr /. {
  g:G[c1_, c2_, c3_] :> Module[{b2, term1, term2, term3},
    b2 = b20 + g[[3, 2]];
    term1 = (-b2)/(2 ks) * (ks^2 listcal[g, 3, 2, 2] + g - listcal[listcal[g, 3, 1, -2], 3, 2, 2]);
    term2 = (1/(2 ks)) * (
      ks^2 listcal[listcal[listcal[g, 1, 3, 1], 2, 1, 1], 3, 2, 1]
      + listcal[listcal[listcal[g, 1, 3, 1], 2, 1, 1], 3, 2, -1]
      - listcal[listcal[listcal[listcal[g, 1, 3, 1], 2, 1, 1], 3, 1, -2], 3, 2, 1]
    );
    term3 = (1/(2 ks)) * (
      ks^2 listcal[listcal[listcal[g, 1, 4, 1], 2, 2, 1], 3, 2, 1]
      + listcal[listcal[listcal[g, 1, 4, 1], 2, 2, 1], 3, 2, -1]
      - listcal[listcal[listcal[listcal[g, 1, 4, 1], 2, 2, 1], 3, 1, -2], 3, 2, 1]
    );
    term1 + term2 + term3
  ],
  r:R1[c1_, c2_, c3_] :> Module[{b2, term1, term2, term3},
    b2 = b20R + r[[3, 2]];
    term1 = (-b2)/(2 ks) * (ks^2 listcal[r, 3, 2, 2] + r - listcal[listcal[r, 3, 1, -2], 3, 2, 2]);
    term2 = (1/(2 ks)) * (
      ks^2 listcal[listcal[listcal[r, 1, 1, 1], 2, 1, 1], 3, 2, 1]
      + listcal[listcal[listcal[r, 1, 1, 1], 2, 1, 1], 3, 2, -1]
      - listcal[listcal[listcal[listcal[r, 1, 1, 1], 2, 1, 1], 3, 1, -2], 3, 2, 1]
    );
    term3 = (1/(2 ks)) * (
      ks^2 listcal[listcal[listcal[r, 1, 2, 1], 2, 1, 1], 3, 2, 1]
      + listcal[listcal[listcal[r, 1, 2, 1], 2, 1, 1], 3, 2, -1]
      - listcal[listcal[listcal[listcal[r, 1, 2, 1], 2, 1, 1], 3, 1, -2], 3, 2, 1]
    );
    term1 + term2 + term3
  ]
};

dks[expr_] := D[expr, ks] + (Expand[expr] /. a_. r:(G[__] | R1[__]) :> a * dksTerm[r]);


DEk00 = (dk0[MIdlogNote] // id // symmetry);
DEks0 = (dks[MIdlogNote] // id // symmetry);


(* ::Section:: *)
(*Formatting Variables & Target for Kira*)


IBPsetdlogbasis =Table[dlog[i] - MIdlogKira[[i]], {i,Length[MIdlogKira]}]//Factor;
(*IBPsetdlogbasis ={}; *) (*-----------\:4e0d\:52a0\:5165dlog\:57fa\:6d4b\:8bd5\:ff0c\:8981\:52a0\:5165\:65f6\:6ce8\:91ca\:6b64\:884c----------*)
IBPsetP = Join[IBPsetdlogbasis, IBPsetP0];

varsetP = IBPsetP // Cases[#, _R1|_G|_dlog, Infinity] & // DeleteDuplicates;
(* Sorting rule for varsetP (integral ordering for Kira):
   Priority 0 (first): dlog basis integrals G["dlog", i], sorted by i.
   Priority 1 (remaining): all non-dlog integrals, sorted by:
     (a) Primary:   sum |a_i| + |b_i|  (with +400 penalty if any index < 0)
     (b) Secondary: G before R1  (type flag: 1 for G, 2 for R1)
     (c) Tertiary:  sum of a indices  (a1+a2 for G,  a for R1)
     (d) Then:      individual a indices (a1, a2 for G;  a, 0 for R1)
     (e) Then:      individual b indices (b1, b2)
     (f) Finally:   discrete Hankel labels (n1,n2,n3,n4 for G;  n3,n4,0,0 for R1)
*)
varsetP = SortBy[varsetP, Which[
    MatchQ[#, dlog[_Integer]],
      {0, #[[1]], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    MatchQ[#, G[_,_,_]],
      With[{n1=#[[1,1]], n2=#[[1,2]], n3=#[[1,3]], n4=#[[1,4]],
            a1=#[[2,1]], a2=#[[2,2]], b1=#[[3,1]], b2=#[[3,2]]},
        {1, Total[Abs /@ {a1,a2,b1,b2}],
         If[a1<0||a2<0||b1<0||b2<0, 50, 0],
         1, a1+a2, a1, a2, b1, b2, n1, n2, n3, n4}
      ],
    MatchQ[#, R1[__]],
      With[{n3=#[[1,1]], n4=#[[1,2]], a=#[[2,1]], b1=#[[3,1]], b2=#[[3,2]]},
        {1, Total[Abs /@ {a,b1,b2}],
         If[a<0||b1<0||b2<0, 50, 0],
         2, a, 0, 0, b1, b2, n3, n4, 0, 0}
      ],
    True, {9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
  ] &
];

repkira2GR = Table[Tuserweight[i] -> varsetP[[i]], {i, Length[varsetP]}];
repGR2num = Table[varsetP[[i]] -> Tuserweight[i], {i, Length[varsetP]}];


{IBPsetP,DEk00,DEks0}// Cases[#, _R1|_G|_dlog, Infinity] & // DeleteDuplicates//Complement[#,varsetAll]&(*\:68c0\:6d4b\:5fae\:5206\:65b9\:7a0b\:504f\:5bfc\:51fa\:73b0\:7684\:79ef\:5206\:662f\:5426\:90fd\:5728\:7ea6\:5316\:8303\:56f4\:5185\:4e86*)


IBPsetdlogbasis


(* ::Section:: *)
(*Exporting Kira Workspace*)


kiraworkspace = "kira_bubble";  
If[!DirectoryQ["./" <> kiraworkspace], CreateDirectory["./" <> kiraworkspace, CreateIntermediateDirectories -> True]];
If[!DirectoryQ["./" <> kiraworkspace <> "/userSystem"], CreateDirectory["./" <> kiraworkspace <> "/userSystem", CreateIntermediateDirectories -> True]];
If[!DirectoryQ["./" <> kiraworkspace <> "/result"], CreateDirectory["./" <> kiraworkspace <> "/result", CreateIntermediateDirectories -> True]];


(* === Write userSystem/ibp.kira ===
   Format: reduce_user_defined_system (matches R1_ibp_sym.m ctokb pattern).
   Each equation is a block of lines "index*(coeff)", separated by a blank line. *)
ctokb[IBPset0_, varset0_] := Module[{string, stream, intsettemp, indexset},
  stream = OpenWrite["./" <> kiraworkspace <> "/userSystem/ibp.kira"];
  Do[
    string = "";
    intsettemp = IBPset0[[i]] // Cases[#, _R1 | _G | _dlog, Infinity] & // DeleteDuplicates;
    indexset = Table[intsettemp[[j]] /. repGR2num /. Tuserweight[c_] -> c, {j, Length[intsettemp]}] // Flatten;
    Do[
      string = StringJoin[string,
        ToString[indexset[[k]]], "*(",
        ToString[Coefficient[IBPset0[[i]], intsettemp[[k]]] // Factor, InputForm]
          // StringReplace[Whitespace -> ""],
        ")\n"];
      , {k, 1, Length[intsettemp]}];
    string = StringJoin[string, "\n"];
    WriteString[stream, string];
    , {i, Length[IBPset0]}];
  Close[stream];
];

(* --- Symbolic run (default): just call ctokb on symbolic IBPsetP --- *)
ctokb[IBPsetP, varsetP];
repNumericTestKira = {nu -> 17/7, ep -> 1/13, k0 -> 5/23, da -> 0}; (*\:5373\:4f7f\:4e0d\:505a\:6570\:503c\:7ea6\:5316\:ff0c\:4e5f\:53ef\:4ee5\:7528\:4e8e\:4ee3\:5165\:6570\:503c\:68c0\:9a8c*)
(*--- Numeric test run: uncomment the block below AND comment the line above ---*)
(* IBPsetPKira = IBPsetP /. repNumericTestKira; *)
(* ctokb[IBPsetPKira, varsetP]; *)

(* Append dummy equation: (N+1)*(ccc) only needed when ALL coefficients are numeric.
   For symbolic run it is omitted. *)
Print["ibp.kira written (", Length[IBPsetP], " equations)."];


(* === Write list ===
   List ALL integrals (1..Length[varsetP]) for Kira reduction, matching R1_ibp_sym.m.
   Kira needs to reduce all integrals that may appear in derivatives of dlog basis. *)
listb[targetK0_] := Module[{string, stream},
  stream = OpenWrite["./" <> kiraworkspace <> "/list"];
  Do[
    string = StringJoin[ToString[k], "\n"];
    WriteString[stream, string];
    , {k, targetK0}];
  Close[stream];
];

(* Target integrals for Kira reduction.
   Only integrals in this list will have reduction rules in kira_list.m.
   Set targetMax to cover at least all integrals appearing in derivatives of dlog basis.
   Use Length[varsetP] to reduce all; use a smaller number for faster test runs. *)
targetMax = 1691;  (* stop right before the first integral with abs-weight 8 *)
targetKAll = Range[Min[targetMax, Length[varsetP]+ 1]];  (* +1 for dummy integral in numeric mode *)
listb[targetKAll];
Print["list written (", Length[targetKAll], " target integrals)."];


(* === Write jobs.yaml (reduce_user_defined_system, matching R1_ibp_sym.m) === *)
Export["./" <> kiraworkspace <> "/jobs.yaml",
  "jobs:\n" <>
  "  - reduce_user_defined_system:\n" <>
  "      input_system: {files: [\"userSystem\"], config: false}\n" <>
  "      select_integrals:\n" <>
  "        select_mandatory_list:\n" <>
  "          - [list]\n" <>
  "      run_initiate: true\n" <>
  "      run_firefly: true\n" <>
  "  - kira2math:\n" <>
  "      target:\n" <>
  "       - [list]\n",
  "String"
];


(* === Write run.sh (cleanup + dos2unix + kira, matching R1_ibp_sym.m) === *)
Export["./" <> kiraworkspace <> "/run.sh",
  "rm -f kira.log\n" <>
  "rm -f firefly.log\n" <>
  "rm -rf results\n" <>
  "rm -rf tmp\n" <>
  "rm -rf sectormappings\n" <>
  "rm -rf firefly_saves\n" <>
  "rm -rf ff_save\n" <>
  "dos2unix list\n" <>
  "dos2unix userSystem/ibp.kira\n" <>
  "dos2unix jobs.yaml\n" <>
  "/home/jiaqichen/Softwares/kira/bin/kira --parallel=10 jobs.yaml\n",
  "String"
];


(* === Export result files for bubble_de.m === *)
Export["./" <> kiraworkspace <> "/result/MIdlogNote.m", MIdlogNote];
Export["./" <> kiraworkspace <> "/result/MIdlogNote0.m", MIdlogNote0];
Export["./" <> kiraworkspace <> "/result/OmegaTauX2C.m", OmegaTauX2C];
Export["./" <> kiraworkspace <> "/result/MIdlogTop.m", MIdlogTop];
Export["./" <> kiraworkspace <> "/result/MIdlogTop0.m", MIdlogTop0];
Export["./" <> kiraworkspace <> "/result/repkira2GR.m", repkira2GR];
Export["./" <> kiraworkspace <> "/result/repGR2num.m", repGR2num];
DeleteFile["./" <> kiraworkspace <> "/result/derivative_rules_bubble.m"] /; FileExistsQ["./" <> kiraworkspace <> "/result/derivative_rules_bubble.m"];
Save["./" <> kiraworkspace <> "/result/derivative_rules_bubble.m",
  {listcal, repvar, reppara2N, repNumericTestKira, id, symmetry, dk0, dks, dk0Term, dksTerm}];

Print["Export done. Workspace ready at: ", kiraworkspace];



(* ::Section:: *)
(*test*)


Tuserweight[330]/.repkira2GR
