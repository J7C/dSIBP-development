(* ::Package:: *)

(***
================================================================================
\:6587\:4ef6\:ff1aOmega_tau_generator.m
\:7528\:9014\:ff1a\:751f\:6210\:5b8c\:6574 bubble \:56fe\:7684\:65f6\:95f4\:79ef\:5206\:90e8\:5206\:ff08tau-side\:ff09\:7684\:7b26\:53f7\:5fae\:5206\:65b9\:7a0b\:3002

\:8f93\:51fa\:ff1a
  - Omegatau/OmegaFolded.m   : \:6298\:53e0 R2 -> R1 \:540e\:7684\:5b8c\:6574 20x20 tau-side DE\:ff08\:4fdd\:7559 log\:ff09
  - Omegatau/MIstau.m        : \:4e0e OmegaFolded \:884c/\:5217\:987a\:5e8f\:4e25\:683c\:5bf9\:5e94\:7684 20 \:4e2a\:4e3b\:79ef\:5206

================================================================================

========== \:9879\:76ee\:89c4\:5219\:ff1a\:4ee5\:4e0b\:7ea6\:5b9a\:662f\:6240\:6709\:76f8\:5173\:811a\:672c\:5fc5\:987b\:9075\:5b88\:7684 ==========

1. ki[i] / nui[i] \:5230\:7269\:7406\:53d8\:91cf\:7684\:6620\:5c04
   ki[0] = P1/P2\:ff08\:5916\:52a8\:91cf/\:80fd\:91cf\:ff09
   ki[1] = x1\:ff08\:7b2c\:4e00\:6761\:5185\:7ebf\:7684\:8d28\:91cf\:53c2\:6570\:ff0c\:5bf9\:5e94\:9876\:70b9\:52a8\:91cf q\:ff09
   ki[2] = x2\:ff08\:7b2c\:4e8c\:6761\:5185\:7ebf\:7684\:8d28\:91cf\:53c2\:6570\:ff0c\:5bf9\:5e94\:9876\:70b9\:52a8\:91cf |q+ks|\:ff09
   nui[0] = a0\:ff08\:65f6\:95f4\:5e42\:6b21\:7684\:57fa\:7ebf\:504f\:79fb\:ff09
   nui[1], nui[2] = nu\:ff08Hankel \:51fd\:6570\:9636\:6570\:ff09

2. BitGet \:4e8c\:8fdb\:5236\:7f16\:7801\:ff08\:51b3\:5b9a n_i \:5bf9\:5e94\:5173\:7cfb\:ff09
   \:5bf9 n-fold \:9876\:70b9\:ff0c\:72b6\:6001\:5e8f\:53f7 i=1..2^n\:ff0cBitGet[i-1, n-j] \:63a7\:5236\:7b2c j \:4e2a ki \:7684\:5f00\:5173\:ff1a
     j=1 -> ki[1] -> x1 -> \:9876\:70b9\:7684\:7b2c\:4e00\:6761\:817f     [MSB]
     j=2 -> ki[2] -> x2 -> \:9876\:70b9\:7684\:7b2c\:4e8c\:6761\:817f     [LSB]
   \:72b6\:6001 i \:7684\:4e8c\:8fdb\:5236\:7f16\:7801 = {bit_x1, bit_x2}
   idx2bin = {{0,0},{0,1},{1,0},{1,1}}\:ff0c\:5176\:4e2d\:ff1a
     idx2bin[[i,1]] = bit1 = x1 \:4fa7\:ff08\:7b2c\:4e00\:6761\:817f\:7684 Hankel \:6307\:6807\:ff09
     idx2bin[[i,2]] = bit0 = x2 \:4fa7\:ff08\:7b2c\:4e8c\:6761\:817f\:7684 Hankel \:6307\:6807\:ff09

3. G \:51fd\:6570\:65cf n_i \:7ea6\:5b9a\:ff08paper Eq B^{(12)}\:ff09
   B^{(12)}[{n1,n2,n3,n4},...] =
     h_{n1}^{(1)}(-q \[Tau]1) h_{n2}^{(2)}(-q \[Tau]2)         \[LeftArrow] \:7b2c\:4e00\:5185\:7ebf\:ff08x1 \:4fa7\:ff09
   \[Times] h_{n3}^{(1)}(-|q+ks| \[Tau]1) h_{n4}^{(2)}(-|q+ks| \[Tau]2) \[LeftArrow] \:7b2c\:4e8c\:5185\:7ebf\:ff08x2 \:4fa7\:ff09
   \:56e0\:6b64\:ff1a
     \:9876\:70b9 1\:ff08\[Tau]1\:ff09\:ff1a{n1, n3} = {bit_i1[1], bit_i1[0]}\:ff08\:7b2c\:4e00\:3001\:4e8c\:6761\:817f\:ff09
     \:9876\:70b9 2\:ff08\[Tau]2\:ff09\:ff1a{n2, n4} = {bit_i2[1], bit_i2[0]}\:ff08\:7b2c\:4e00\:3001\:4e8c\:6761\:817f\:ff09

4. Kronecker \:79ef\:987a\:5e8f\:ff08\:51b3\:5b9a MIstau \:548c OmegaFolded \:884c\:5217\:987a\:5e8f\:ff09
   Omegapp = KroneckerProduct[test1pp, I\:2084] + KroneckerProduct[I\:2084, test2pp]
   \:884c/\:5217\:7d22\:5f15 = (i1-1)*4 + i2\:ff0ci1 \:4e3a\:5916\:6307\:6807\:ff08\:53d8\:6162\:ff09\:ff0ci2 \:4e3a\:5185\:6307\:6807\:ff08\:53d8\:5feb\:ff09
   G[{n1,n2,n3,n4}] = G[{idx2bin[[i1,1]], idx2bin[[i2,1]], idx2bin[[i1,2]], idx2bin[[i2,2]]}]
   \:ff08\:5148\:53d6\:4e24\:4e2a\:9876\:70b9\:7684 bit1\:ff0c\:518d\:53d6\:4e24\:4e2a\:9876\:70b9\:7684 bit0\:ff0c\:4e0d \:662f \:5bf9 n1-n4 \:76f4\:63a5 Table \:904d\:5386\:ff09

5. R1/R2 \:5b50\:6247\:533a
   R1 \:4f7f\:7528 Omegan[1]\:ff0c\:5bf9\:5e94\:4fdd\:7559 x2 \:7684\:6536\:7f29\:9879\:ff0crepknuset \:4f20\:5165 {P1, x2}/{P2, x2}
   R2 \:4f7f\:7528 Omegan[1]\:ff0c\:5bf9\:5e94\:4fdd\:7559 x1 \:7684\:6536\:7f29\:9879\:ff0crepknuset \:4f20\:5165 {P1, x1}/{P2, x1}
   \:5bf9\:79f0\:6027 Eq 43\:ff1aR2[{n1,n2},{a},{b1,b2}] \[RightArrow] R1[{n1,n2},{a},{b2,b1}]

6. R1 \:7684 a0R / b10R / b20R \:7ea6\:5b9a\:ff08bubble_ibp_sym.m\:ff09
   a0R -> 2 a0 - 2 nu
   b10R -> b0 + 2 nu
   b20R -> b0

7. Top\[RightArrow]R1/Top\[RightArrow]R2 \:4f59\:9879\:8026\:5408\:516c\:5f0f\:ff08dS_IBP Eq 3.27\:ff09
   \:7531 buildTopToSubsectorBlock \:5b9e\:73b0\:3002
================================================================================
   OmegaFullpp \:662f 24\[Times]24: Top(16) + R1(4) + R2(4)
   \:6298\:53e0 R2\[RightArrow]R1 \:540e\:5f97\:5230 20\[Times]20
================================================================================
***)


dir = If[StringQ[$InputFileName] && $InputFileName =!= "",
  DirectoryName[$InputFileName],
  If[TrueQ[$Notebooks],
    With[{nd = Quiet[Check[NotebookDirectory[], $Failed]]},
      If[StringQ[nd] && nd =!= $Failed, nd, Directory[]]
    ],
    Directory[]
  ]
];
SetDirectory[dir];

outputDir = FileNameJoin[{dir, "Omegatau"}];
If[!DirectoryQ[outputDir], CreateDirectory[outputDir, CreateIntermediateDirectories -> True]];


(* ::Section:: *)
(*Define functions & matrices*)


Subscript[\[Sigma], 0] = {{1, 0}, {0, 1}};
Subscript[\[Sigma], 1] = {{0, 1}, {1, 0}};
Subscript[\[Sigma], 2] = {{0, -I}, {I, 0}};
Subscript[\[Sigma], 3] = {{1, 0}, {0, -1}};

T0 = 1/Sqrt[2] {{1, -I}, {-I, 1}};
T0inv = 1/Sqrt[2] {{1, I}, {I, 1}};

repknuset[expr_, kset_List, nuset_List] := Module[{repki, repnui},
  repki = Table[ki[i - 1] -> kset[[i]], {i, Length[kset]}];
  repnui = Table[nui[i - 1] -> nuset[[i]], {i, Length[nuset]}];
  expr /. repki /. repnui
];

Tn[n_] := Module[{test, f, c1},
  test = f[Table[T0, {i, n}]] /. f[{c1___}] -> c1;
  KroneckerProduct[test, {{1}}]
];

Tninv[n_] := Module[{test, f, c1},
  test = f[Table[T0inv, {i, n}]] /. f[{c1___}] -> c1;
  KroneckerProduct[test, {{1}}]
];

Sigman[n_, i0_, j0_] := Module[{test, f, c1},
  If[MemberQ[{0, 1, 2, 3}, j0],
    test = f[Table[If[i == i0, Subscript[\[Sigma], j0], Subscript[\[Sigma], 0]], {i, n}]] /. f[{c1___}] -> c1;
    KroneckerProduct[test, {{1}}],
    Print["wrong j0 in Sigma[n,i0,j0]"]
  ]
];

M1n[n_] := Sum[(nui[i] + 1/2) Sigman[n, i, 3], {i, n}] + (nui[0] - n/2 - Sum[nui[i], {i, n}]) Sigman[n, 1, 0];
M0n[n_] := Sum[(-I ki[i]) Sigman[n, i, 2], {i, n}] + (I ki[0]) Sigman[n, 1, 0];
M1tilden[n_] := Sum[-(nui[i] + 1/2) Sigman[n, i, 2], {i, n}] + (nui[0] - n/2 - Sum[nui[i], {i, n}]) Sigman[n, 1, 0];
M0tilden[n_] := Sum[(-I ki[i]) Sigman[n, i, 3], {i, n}] + (I ki[0]) Sigman[n, 1, 0];

Amn[n_] := -Inverse[M1n[n]] . M0n[n];
Apn[n_] := -Tninv[n] . M0tilden[n] . Tn[n] . M1n[n];

(* Omegatilde0n[n]: diagonal log-kernel before basis rotation.
   ki[0] + Sum_j (2*BitGet[i-1,j]-1)*ki[j]  encodes \[PlusMinus] combinations of internal momenta.
   The signs are: bit=0 => +, bit=1 => -, i.e. (2*bit-1) = \[PlusMinus]1. *)
Omegatilde0n[n_] := -I DiagonalMatrix@Table[
  log[ki[0] + Sum[(2 BitGet[i - 1, n - j] - 1) ki[j], {j, n}]],
  {i, 2^n}
];

(* Omegaexn[n]: diagonal matrix with weights from Hankel function orders.
   BitGet[j] (2*nui[j]+1) * log[ki[j]] counts which internal legs are excited. *)
Omegaexn[n_] := DiagonalMatrix@Table[
  -Sum[BitGet[i - 1, n - j] (2 nui[j] + 1) log[ki[j]], {j, n}],
  {i, 2^n}
];

(* Omegan[n]: full dlog DE matrix for an n-fold vertex integral.
   Omegan = Omegaexn - I * Tninv . Omegatilde0n . Tn . (M1n with nui[0]->nui[0]+1)
   The shift nui[0]->nui[0]+1 comes from the fact that in tau EOM, the time-weight
   for the external Hankel-like factor acquires +1 relative to the internal lines. *)
Omegan[n_] := Omegaexn[n] - I Tninv[n] . Omegatilde0n[n] . Tn[n] . (M1n[n] /. nui[0] -> nui[0] + 1);


(* ::Section:: *)
(*Generic contracted-remainder block builder*)


stateList[2]


(*
  buildTopToSubsectorBlock: build the \[CapitalOmega] matrix block coupling the top sector to a subsector.
  Implements dS_IBP Eq (3.27):
    \[CapitalOmega]_{(a,b)(\:0109,\:0111)} = K1[a, (\:0109; 1-b_j)]\[CenterDot]\[Delta]_{b_spectator,\:0111}\[CenterDot](-1)^(b_j)
                    + K2[b, (\:0111; 1-a_i)]\[CenterDot]\[Delta]_{a_spectator,\:0109}\[CenterDot](-1)^(a_i)
  where (a,b) are the full 2-bit states of the two vertices of the top sector,
  (\:0109,\:0111) are the (n-1)-bit reduced states of the subsector, and kernel1/kernel2
  are the transformed -I Tninv . Omegatilde0n . Tn matrices for each vertex.
*)

stateList[n_Integer] := Table[IntegerDigits[i - 1, 2, n], {i, 2^n}];
stateToIndex[bits_List] := FromDigits[bits, 2] + 1;

idx2bin = stateList[2];
(* idx2bin = {{0,0}, {0,1}, {1,0}, {1,1}} where bit1=x1-side, bit0=x2-side *)

bin2idx[bin_List] := stateToIndex[bin];

buildTopToSubsectorBlock[kernel1_, kernel2_, nLeft_Integer, nRight_Integer, dropLeft_Integer, dropRight_Integer] := Module[
  {leftStates, rightStates, leftReducedStates, rightReducedStates},
  leftStates = stateList[nLeft];
  rightStates = stateList[nRight];
  leftReducedStates = stateList[nLeft - 1];
  rightReducedStates = stateList[nRight - 1];
  Table[
    Module[{a, b, cHat, dHat, term1 = 0, term2 = 0, cBits, dBits},
      a = leftStates[[ia]];    (* vertex 1: {n1,n2} *)
      b = rightStates[[ib]];   (* vertex 2: {n3,n4} *)
      cHat = leftReducedStates[[ic]];
      dHat = rightReducedStates[[id]];
      (* Contribution from IBP on time 1: remove contracted bit from b, insert complement in c *)
      If[Delete[b, dropRight] === dHat,
        cBits = Insert[cHat, 1 - b[[dropRight]], dropLeft];
        term1 = kernel1[[ia, stateToIndex[cBits]]] * (-1)^b[[dropRight]];
      ];
      (* Contribution from IBP on time 2: remove contracted bit from a, insert complement in d *)
      If[Delete[a, dropLeft] === cHat,
        dBits = Insert[dHat, 1 - a[[dropLeft]], dropRight];
        term2 = kernel2[[ib, stateToIndex[dBits]]] * (-1)^a[[dropLeft]];
      ];
      term1 + term2
    ],
    {ia, 1, 2^nLeft}, {ib, 1, 2^nRight}, {ic, 1, 2^(nLeft - 1)}, {id, 1, 2^(nRight - 1)}
  ] // Flatten[#, {{1, 2}, {3, 4}}] &
];


(* ::Section:: *)
(*generate DE of ++ for Bubble with Sub-sectors*)


(* Build the 16x16 top-sector block: each vertex is a 2-fold vertex integral.
   Omegan[2] with variables {P1,x1,x2} for vertex 1, {P2,x1,x2} for vertex 2.
   Kronecker sum (\[CircleTimes] I + I \[CircleTimes]) correctly treats the two vertices as independent. *)
test1pp = Omegan[2] // repknuset[#, {P1, x1, x2}, {a0, nu, nu}] & // Simplify;
test2pp = Omegan[2] // repknuset[#, {P2, x1, x2}, {a0, nu, nu}] & // Simplify;

Omegapp = KroneckerProduct[test1pp, IdentityMatrix[4]] + KroneckerProduct[IdentityMatrix[4], test2pp];

(* Remainder kernels for the two vertices.
   These use only Omegatilde0n (the diagonal log kernel), not the full Omegan. *)
TinvOmegatildeT1 = -I Tninv[2] . (Omegatilde0n[2] // repknuset[#, {P1, x1, x2}, {a0, nu, nu}] &) . Tn[2] // Simplify;
TinvOmegatildeT2 = -I Tninv[2] . (Omegatilde0n[2] // repknuset[#, {P2, x1, x2}, {a0, nu, nu}] &) . Tn[2] // Simplify;

(* R1 remainder: drop first bit (n1/n3 contracted) from both vertices.
   The subsector keeps the SECOND bit (n2/n4) as the reduced state. *)
OmegaTopToR1 = buildTopToSubsectorBlock[TinvOmegatildeT1, TinvOmegatildeT2, 2, 2, 1, 1] // Simplify;

(* R2 remainder: drop second bit (n2/n4 contracted) from both vertices.
   The subsector keeps the FIRST bit (n1/n3) as the reduced state. *)
OmegaTopToR2 = buildTopToSubsectorBlock[TinvOmegatildeT1, TinvOmegatildeT2, 2, 2, 2, 2] // Simplify;

(* R1 and R2 subsector diagonal blocks:
   R1 uses x2 (surviving internal line mass), R2 uses x1. *)
test1R1pp = Omegan[1] // repknuset[#, {P1, x2}, {a0, nu}] & // Simplify;
test2R1pp = Omegan[1] // repknuset[#, {P2, x2}, {a0, nu}] & // Simplify;
OmegaR1pp = KroneckerProduct[test1R1pp, IdentityMatrix[2]] + KroneckerProduct[IdentityMatrix[2], test2R1pp];

test1R2pp = Omegan[1] // repknuset[#, {P1, x1}, {a0, nu}] & // Simplify;
test2R2pp = Omegan[1] // repknuset[#, {P2, x1}, {a0, nu}] & // Simplify;
OmegaR2pp = KroneckerProduct[test1R2pp, IdentityMatrix[2]] + KroneckerProduct[IdentityMatrix[2], test2R2pp];

ZerosR1Top = ConstantArray[0, {4, 16}];
ZerosR2Top = ConstantArray[0, {4, 16}];
ZerosR1R2 = ConstantArray[0, {4, 4}];
ZerosR2R1 = ConstantArray[0, {4, 4}];

(* 24x24 unfurled matrix: Top(16) + R1(4) + R2(4) *)
OmegaFullpp = ArrayFlatten[{
  {Omegapp, OmegaTopToR1, OmegaTopToR2},
  {ZerosR1Top, OmegaR1pp, ZerosR1R2},
  {ZerosR2Top, ZerosR2R1, OmegaR2pp}
}];


(* ::Section:: *)
(*R2->R1 Folding & Master ordering*)


(* Fold R2 -> R1 via Eq 43 symmetry (R2 b1<->b2 mapped to R1).
   24x24 -> 20x20: Top(16) + R1_folded(4).
   Layout of OmegaFullpp:
     1..16   : Top sector (Kronecker-indexed by (i1,i2))
     17..20  : R1 sector (Kronecker-indexed by (k1,k2))
     21..24  : R2 sector (Kronecker-indexed by (k1,k2))
   After folding: Top(1..16) + R1_folded(17..20) where:
     Top->R1_folded = OmegaTopToR1 + OmegaTopToR2  (16x4)
     R1pm_folded    = OmegaR1pp + OmegaR2pp           (4x4) *)
OmegaFolded = ArrayFlatten[{
  {Omegapp, OmegaTopToR1 + OmegaTopToR2},
  {ZerosR1Top, OmegaR1pp + OmegaR2pp}
}];

If[Dimensions[OmegaFolded] =!= {20, 20},
  Print["ERROR: OmegaFolded dimensions wrong: ", Dimensions[OmegaFolded]],
  Print["OmegaFolded dimensions OK: 20x20"]
];

(* MIstau\:ff1a20 \:4e2a\:4e3b\:79ef\:5206\:ff0c\:987a\:5e8f\:4e0e OmegaFolded \:7684\:884c/\:5217\:4e25\:683c\:4e00\:81f4\:3002
   OmegaFolded \:7684\:884c/\:5217\:7d22\:5f15 = (i1-1)*4 + i2\:ff08i1 \:4e3a\:9876\:70b9 1 \:7684\:72b6\:6001\:ff0ci2 \:4e3a\:9876\:70b9 2 \:7684\:72b6\:6001\:ff09\:3002
   MIstau \:4f7f\:7528\:5b8c\:5168\:76f8\:540c\:7684 (i1,i2) \:987a\:5e8f\:ff08i1 \:6162\:53d8\:ff0ci2 \:5feb\:53d8\:ff09\:3002

   G \:51fd\:6570\:7684\:6307\:6807\:987a\:5e8f\:ff08paper Eq B^{(12)}\:ff09\:ff1a
     B^{(12)}[{n1,n2,n3,n4},...] =
       h_{n1}^{(1)}(-q\[Tau]1) h_{n2}^{(2)}(-q\[Tau]2)        [\:7b2c\:4e00\:6761\:5185\:7ebf\:ff0cx1 \:4fa7]
     \[Times] h_{n3}^{(1)}(-|q+ks|\[Tau]1) h_{n4}^{(2)}(-|q+ks|\[Tau]2)  [\:7b2c\:4e8c\:6761\:5185\:7ebf\:ff0cx2 \:4fa7]
   \:9876\:70b9 1 \:7684 2-bit \:72b6\:6001 i1 \:7f16\:7801\:ff1abit[MSB]=n1, bit[LSB]=n3
   \:9876\:70b9 2 \:7684 2-bit \:72b6\:6001 i2 \:7f16\:7801\:ff1abit[MSB]=n2, bit[LSB]=n4

   \:56e0\:6b64 (i1,i2) \:5bf9\:5e94\:7684 G \:79ef\:5206\:ff1a
     G[{n1,n2,n3,n4}] = G[{idx2bin[[i1,1]], idx2bin[[i2,1]], idx2bin[[i1,2]], idx2bin[[i2,2]]}]

   \:7531\:4e8e OmegaTauX2C \:548c OmegaFolded \:540c\:6837\:9075\:5faa\:8fd9\:4e2a (i1,i2) \:987a\:5e8f\:ff0c
   MIstau \:53ef\:76f4\:63a5\:7528\:4f5c bubble_ibp_sym.m \:4e2d basisd32/basisd12 \:7684\:8bd5\:63a2\:5411\:91cf\:3002
   \:66f4\:591a\:8be6\:7ec6\:89e3\:91ca\:89c1 project_context/Manual.md \:7684 2.3 \:8282\:3002 *)
MIstau = Join[
  Flatten@Table[
    G[{idx2bin[[i1, 1]], idx2bin[[i2, 1]], idx2bin[[i1, 2]], idx2bin[[i2, 2]]}, {0, 0}, {0, 0}],
    {i1, 1, 4}, {i2, 1, 4}
  , 1],
  Table[
    R1[{idx2bin[[k, 1]], idx2bin[[k, 2]]}, {0}, {0, 0}],
    {k, 1, 4}
  ]
];

Print["Total master integrals: ", Length[MIstau], "  (expected: 20)"];
If[Length[MIstau] =!= 20, Print["ERROR: Wrong MI count!"], Print["MI count verified: 20"]];


(* ::Section:: *)
(*Export*)


Export[FileNameJoin[{outputDir, "OmegaFolded.m"}], OmegaFolded];
Export[FileNameJoin[{outputDir, "MIstau.m"}], MIstau];

Print["Exported symbolic tau-DE data to: ", outputDir];
Print["Files: OmegaFolded.m, MIstau.m"];
