(* ::Package:: *)

(***
Validate the generic contracted-two-vertex remainder construction in two ways:
1. Bubble specialization: rebuild OmegaTopToR1 using the generic pattern and compare to the
   current bubble implementation.
2. Tree reference check: generate the 4x1 one-vertex remainder DE from the generic pattern in
   the n1=n2=1 contracted-tree case, and compare to the previously generated result recorded in
   ref-de-code/000_dsdeppsol.m.

This script is intended to be inspected directly after running:
- it prints the generated tree 4x1 result,
- prints the reference result,
- and prints whether their difference is exactly zero.
It does not export extra files.
***)


dir = If[StringQ[$InputFileName] && $InputFileName != "",
  DirectoryName[DirectoryName[$InputFileName]],
  If[TrueQ[$Notebooks],
    With[{nd = Quiet[Check[NotebookDirectory[], $Failed]]},
      If[StringQ[nd] && nd =!= $Failed, DirectoryName[nd], Directory[]]
    ],
    Directory[]
  ]
];
SetDirectory[dir];

Get[FileNameJoin[{dir, "000_DE_bubble_tau.m"}]];

stateListRef[n_Integer] := Table[IntegerDigits[i - 1, 2, n], {i, 2^n}];
stateToIndexRef[bits_List] := FromDigits[bits, 2] + 1;

buildRefRemainderBlock[kernel1_, kernel2_, n1_Integer, n2_Integer, i1_Integer, i2_Integer] := Module[
  {OmegaR01ac, OmegaR02bd, iab, ia, ib, icdhat, ichat, idhat, bj, ai, ibhat, iahat, ichatbj, idhatai},
  OmegaR01ac = Table[
    iab = IntegerDigits[i, 2, n1 + n2];
    icdhat = IntegerDigits[j, 2, n1 + n2 - 2];
    ia = FromDigits[Drop[iab, -n2], 2];
    ib = Drop[iab, n1];
    bj = ib[[i2]];
    ibhat = FromDigits[Drop[ib, {i2}], 2];
    idhat = FromDigits[Drop[icdhat, n1 - 1], 2];
    ichat = Drop[icdhat, -n2 + 1];
    ichatbj = FromDigits[Insert[ichat, 1 - bj, i1], 2];
    If[ibhat == idhat, kernel1[[ia + 1, ichatbj + 1]] (-1)^bj, 0]
    , {i, 0, 2^(n1 + n2) - 1}, {j, 0, 2^(n1 + n2 - 2) - 1}
  ] // Simplify;

  OmegaR02bd = Table[
    iab = IntegerDigits[i, 2, n1 + n2];
    icdhat = IntegerDigits[j, 2, n1 + n2 - 2];
    ib = FromDigits[Drop[iab, n1], 2];
    ia = Drop[iab, -n2];
    ai = ia[[i1]];
    iahat = FromDigits[Drop[ia, {i1}], 2];
    ichat = FromDigits[Drop[icdhat, -n2 + 1], 2];
    idhat = Drop[icdhat, n1 - 1];
    idhatai = FromDigits[Insert[idhat, 1 - ai, i2], 2];
    If[iahat == ichat, kernel2[[ib + 1, idhatai + 1]] (-1)^ai, 0]
    , {i, 0, 2^(n1 + n2) - 1}, {j, 0, 2^(n1 + n2 - 2) - 1}
  ] // Simplify;

  {OmegaR01ac, OmegaR02bd, Simplify[OmegaR01ac + OmegaR02bd]}
];

(* 1. Bubble check *)
{bubbleR1Term1, bubbleR1Term2, OmegaTopToR1Ref} = buildRefRemainderBlock[TinvOmegatildeT1, TinvOmegatildeT2, 2, 2, 1, 1];
DeltaR1 = Simplify[OmegaTopToR1 - OmegaTopToR1Ref];
checkR1Exact = (DeltaR1 === ConstantArray[0, Dimensions[OmegaTopToR1]]);
checkR1Entrywise = And @@ Flatten[Map[PossibleZeroQ, DeltaR1, {2}]];

Print["Bubble Top->R1 validation against generic pattern:"];
Print["  Dimensions current: ", Dimensions[OmegaTopToR1]];
Print["  Dimensions rebuilt: ", Dimensions[OmegaTopToR1Ref]];
Print["  Exact zero-matrix check: ", checkR1Exact];
Print["  Entrywise PossibleZeroQ check: ", checkR1Entrywise];

(* 2. Tree 4x1 reference check from ref-de-code/000_dsdeppsol.m *)
aGpp = 1;
repk12 = {ki[0] -> k12, ki[1] -> ks, nui[0] -> v0, nui[1] -> v1};
repk34 = {ki[0] -> k34, ki[1] -> ks, nui[0] -> v0, nui[1] -> v1};

OmegaR01tempTree = (Tninv[1] . Omegatilde0n[1] . Tn[1] /. repk12) // Simplify;
OmegaR02tempTree = (Tninv[1] . Omegatilde0n[1] . Tn[1] /. repk34) // Simplify;

{OmegaR01acTreeCore, OmegaR02bdTreeCore, OmegaRabcdTreeCore} = buildRefRemainderBlock[OmegaR01tempTree, OmegaR02tempTree, 1, 1, 1, 1];
OmegaR01acTree = (-aGpp I) * OmegaR01acTreeCore // Simplify;
OmegaR02bdTree = (-aGpp I) * OmegaR02bdTreeCore // Simplify;
OmegaRabcdTree = Simplify[OmegaR01acTree + OmegaR02bdTree];

OmegaRabcdTreeRef = {
  {(I/2) (log[k12 - ks] - log[k12 + ks]) + (I/2) (log[k34 - ks] - log[k34 + ks])},
  {(log[k12 - ks] + log[k12 + ks])/2 + (-log[k34 - ks] - log[k34 + ks])/2},
  {(-log[k12 - ks] - log[k12 + ks])/2 + (log[k34 - ks] + log[k34 + ks])/2},
  {(I/2) (log[k12 - ks] - log[k12 + ks]) + (I/2) (log[k34 - ks] - log[k34 + ks])}
} // Simplify;

DeltaTree = Simplify[OmegaRabcdTree - OmegaRabcdTreeRef];
checkTreeExact = (DeltaTree === ConstantArray[0, Dimensions[OmegaRabcdTreeRef]]);
checkTreeEntrywise = And @@ Flatten[Map[PossibleZeroQ, DeltaTree, {2}]];

Print["Tree contracted 4x1 remainder validation against recorded ref-de-code result:"];
Print["  OmegaR01acTree = "];
OmegaR01acTree // MatrixForm // Print;
Print["  OmegaR02bdTree = "];
OmegaR02bdTree // MatrixForm // Print;
Print["  OmegaRabcdTree = "];
OmegaRabcdTree // MatrixForm // Print;
Print["  Reference 4x1 = "];
OmegaRabcdTreeRef // MatrixForm // Print;
Print["  DeltaTree = "];
DeltaTree // MatrixForm // Print;
Print["  Exact zero-matrix check: ", checkTreeExact];
Print["  Entrywise PossibleZeroQ check: ", checkTreeEntrywise];