(* ::Package:: *)

(* 
   generate_OmegaR1.m
   Generates the Omega matrix and Master Integrals for R1 tadpole family.
   
   Method 1: Uses general Omegan formula from 000_DE_1L2pdtau.m (Section 2.0).
   Method 2: Uses explicit matrix decomposition from noteppmassive/main.tex.
   
   Verifies that both methods yield the same result.
*)

(* ========================================================================= *)
(* 1. Definitions & Setup                                                    *)
(* ========================================================================= *)

(* Pauli Matrices *)
s0 = {{1,0},{0,1}};
s1 = {{0,1},{1,0}};
s2 = {{0,-I},{I,0}};
s3 = {{1,0},{0,-1}};

Subscript[\[Sigma], 0] = s0;
Subscript[\[Sigma], 1] = s1;
Subscript[\[Sigma], 2] = s2;
Subscript[\[Sigma], 3] = s3;

(* T0 Matrix for basis transformation *)
T0 = 1/Sqrt[2]{{1,-I},{-I,1}};
T0inv = 1/Sqrt[2]{{1,I},{I,1}};

(* Helper functions for Omegan generation *)
repknuset[expr_, kset_List, nuset_List] := Module[{repki, repnui},
    repki = Table[ki[i-1] -> kset[[i]], {i, Length[kset]}];
    repnui = Table[nui[i-1] -> nuset[[i]], {i, Length[nuset]}];
    expr // ReplaceAll[#, repki]& // ReplaceAll[#, repnui]&
];

Tn[n_] := Module[{test, f, c1}, 
    test = f[Table[T0, {i, n}]] /. f[{c1___}] -> Sequence[c1]; 
    KroneckerProduct[test, {{1}}]
];

Tninv[n_] := Module[{test, f, c1}, 
    test = f[Table[T0inv, {i, n}]] /. f[{c1___}] -> Sequence[c1]; 
    KroneckerProduct[test, {{1}}]
];

Sigman[n_, i0_, j0_] := Module[{test, f, c1}, 
    If[MemberQ[{0, 1, 2, 3}, j0],
        test = f[Table[If[i == i0, Subscript[\[Sigma], j0], Subscript[\[Sigma], 0]], {i, n}]] /. f[{c1___}] -> Sequence[c1];
        KroneckerProduct[test, {{1}}],
        Print["wrong j0 in Sigma[n,i0,j0]"]
    ]
];

M1n[n_] := Sum[(nui[i] + 1/2) Sigman[n, i, 3], {i, n}] + (nui[0] - n/2 - Sum[nui[i], {i, n}]) Sigman[n, 1, 0];

Omegatilde0n[n_] := -I DiagonalMatrix[Table[log[ki[0] + Sum[(2 BitGet[i-1, n-j] - 1) ki[j], {j, n}]], {i, 2^n}]];

Omegaexn[n_] := DiagonalMatrix[Table[-Sum[BitGet[i-1, n-j] (2 nui[j] + 1) log[ki[j]], {j, n}], {i, 2^n}]];

Omegan[n_] := Omegaexn[n] - I Tninv[n] . Omegatilde0n[n] . Tn[n] . (M1n[n] /. nui[0] -> nui[0] + 1);


(* ========================================================================= *)
(* 2. Generation (Method 1: Omegan Formula)                                  *)
(* ========================================================================= *)

(* R1 Parameters *)
(* kset = {P0R1, x2, x2}, nuset = {a0, nu, nu} *)
R1kset = {P0R1, x2, x2};
R1nuset = {a0, nu, nu};

OmegaRaw = Omegan[2] // repknuset[#, R1kset, R1nuset]& // Simplify;


(* ========================================================================= *)
(* 3. Explicit Construction (Method 2: LaTeX Formulas)                       *)
(* ========================================================================= *)

(* Definitions from noteppmassive/main.tex (Corrected Swapped Plus/Minus) *)
Id2 = s0;
Id4 = IdentityMatrix[4];

OmegaP0R1Ref = ((-a0 + 2*nu)/2) * Id4 - 
              ((1 + 2*nu)/4) * (KroneckerProduct[s3, Id2] + KroneckerProduct[Id2, s3]) + 
              (I*(1 + 2*nu)/4) * (KroneckerProduct[s1, s2] + KroneckerProduct[s2, s1]) + 
              ((a0 - 2*nu)/2) * KroneckerProduct[s2, s2];

Omegax2Ref = -(1 + 2*nu) * Id4 + 
              ((1 + 2*nu)/2) * (KroneckerProduct[s3, Id2] + KroneckerProduct[Id2, s3]);

(* Note: OmegaPlus/Minus definitions swapped to match code generation 2024-05 *)
OmegaPlusRef = KroneckerProduct[ ((-a0 + 2*nu)/4)*(Id2 - s2), (Id2 - s2) ] + 
               ((1 + 2*nu)/8) * (
                   KroneckerProduct[(I*s1 - s3), (Id2 - s2)] + 
                   KroneckerProduct[(Id2 - s2), (I*s1 - s3)]
               );

OmegaMinusRef = KroneckerProduct[ ((-a0 + 2*nu)/4)*(Id2 + s2), (Id2 + s2) ] - 
                 ((1 + 2*nu)/8) * (
                     KroneckerProduct[(I*s1 + s3), (Id2 + s2)] + 
                     KroneckerProduct[(Id2 + s2), (I*s1 + s3)]
                 );


(* ========================================================================= *)
(* 4. Verification                                                           *)
(* ========================================================================= *)

(* Convert OmegaRaw log to Log *)
OmegaRaw = OmegaRaw /. log -> Log;

OmegaExplicit = OmegaP0R1Ref * Log[P0R1] + 
                Omegax2Ref * Log[x2] + 
                OmegaPlusRef * Log[P0R1 + 2*x2] + 
                OmegaMinusRef * Log[P0R1 - 2*x2];

Print["Starting verification..."];
diff = OmegaRaw - OmegaExplicit // FullSimplify
Print["Diff simplified (FullSimplify)."];
Print["Diff Head: ", Head[diff]];
Print["Diff Dimensions: ", Dimensions[diff]];
Print["Diff is zero matrix? ", diff === Table[0, {4}, {4}]];

(* Debug: Print diff structure if not zero *)
If[diff === 0 || diff === Table[0, {4}, {4}],
    Print["SUCCESS: Generated Omega matches explicit LaTeX decomposition (Exact Zero)."],
    
    Print["WARNING: Verification did not yield exact zero."];
    
    (* Find non-zero elements at level 2 (matrix elements) *)
    nonZeroIndices = Position[diff, x_ /; x =!= 0, {2}, Heads -> False];
    Print["Number of non-zero elements: ", Length[nonZeroIndices]];
    If[Length[nonZeroIndices] > 0,
        firstNz = nonZeroIndices[[1]];
        Print["First non-zero element at ", firstNz, ":"];
        Print["Diff val: ", diff[[Sequence @@ firstNz]]];
        Print["OmegaRaw val: ", OmegaRaw[[Sequence @@ firstNz]] // FullSimplify];
        Print["OmegaExplicit val: ", OmegaExplicit[[Sequence @@ firstNz]] // FullSimplify];
    ];

    (* Check if all elements are PossibleZero *)
    allPossibleZero = AllTrue[Flatten[diff], PossibleZeroQ];
    If[allPossibleZero,
        Print["SUCCESS: Generated Omega matches explicit LaTeX decomposition (All elements PossibleZero)."],
        Print["FAILURE: Generated Omega DOES NOT match explicit LaTeX decomposition (Some elements not PossibleZero)."]
    ]
];


(* ========================================================================= *)
(* 5. Master Integrals Generation                                            *)
(* ========================================================================= *)

(* 
   Basis Construction directly in R1 notation
   R1 Convention:
   n is the label for the function defined by taking n derivatives of the defined h function.
   (n\:5c31\:662f\:5bf9\:6240\:5b9a\:4e49h\:51fd\:6570\:6c42n\:6b21x\:5bfc\:6570\:7684\:51fd\:6570\:91cd\:65b0\:5b9a\:4e49\:7684\:4e00\:4e2a\:6807\:8bb0)
   
   Therefore, the basis elements are directly R1[{i, j}, ...].
   NO extra signs are needed because R1 includes the definition of the n-th derivative.
*)

BasisOrig = Flatten[Table[R1[{i, j}, {a}, {b1, b2}], {i, 0, 1}, {j, 0, 1}]];

(* Transform to Master Integrals vector *)
MIs = Tninv[2] . BasisOrig // Simplify;


(* ========================================================================= *)
(* 6. Output                                                                 *)
(* ========================================================================= *)

SetDirectory["d:\\opencode projects\\dSibp\\codeR1\\OmegaR"];

(* Output 1: Omega Matrices *)
outputOmegaFile = "OmegaR1.m";
If[FileExistsQ[outputOmegaFile], DeleteFile[outputOmegaFile]];

Save[outputOmegaFile, "OmegaRaw"];
Save[outputOmegaFile, "OmegaP0R1Ref"];
Save[outputOmegaFile, "Omegax2Ref"];
Save[outputOmegaFile, "OmegaPlusRef"];
Save[outputOmegaFile, "OmegaMinusRef"];

Print["Omega matrices saved to ", FileNameJoin[{Directory[], outputOmegaFile}]];

(* Output 2: Master Integrals *)
outputMIsFile = "MIsR1.m";
If[FileExistsQ[outputMIsFile], DeleteFile[outputMIsFile]];

Save[outputMIsFile, "MIs"];

Print["Master Integrals saved to ", FileNameJoin[{Directory[], outputMIsFile}]];




