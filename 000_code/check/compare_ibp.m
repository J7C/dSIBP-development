(* Comparison script for IBP equations - v2 *)
$HistoryLength = 0;

(* ============================================================ *)
(* 1. Read our file - each line is one equation ending with ; *)
(* ============================================================ *)
ourRaw = ReadList[
  "D:\\Agent-projects-nut\\dSibp_package\\000_code\\ibp_equations_v13.m",
  String
];

(* Remove trailing semicolons and whitespace, filter empty lines *)
ourLines = Select[
  StringTrim[StringReplace[#, ";" ~~ EndOfString -> ""]] & /@ ourRaw,
  StringLength[#] > 0 &
];

Print["Our file: ", Length[ourLines], " equations"];

(* Parse each line as a Mathematica expression *)
ourEqs = Table[
  ToExpression[ourLines[[i]]],
  {i, Length[ourLines]}
];

Print["Parsed: ", Length[ourEqs], " equations"];
Print["First eq head: ", Head[ourEqs[[1]]]];
Print["Sample: ", ourEqs[[1]]];

(* Split into 4 groups of 16 *)
ourG1 = ourEqs[[1 ;; 16]];
ourG2 = ourEqs[[17 ;; 32]];
ourG3 = ourEqs[[33 ;; 48]];
ourG4 = ourEqs[[49 ;; 64]];

(* ============================================================ *)
(* 2. Read reference file *)
(* ============================================================ *)
refData = Get[
  "D:\\Agent-projects-nut\\dSibp_package\\000_code\\check\\check_seeds_J.wl"
];

Print["\nReference file: ", Length[refData], " groups"];
Print["Group sizes: ", Length /@ refData];

refG1 = refData[[1]];
refG2 = refData[[2]];
refG3 = refData[[3]];
refG4 = refData[[4]];

(* ============================================================ *)
(* 3. Substitute kk -> ks^2 in our expressions *)
(* ============================================================ *)
ourG1s = ourG1 /. kk -> ks^2;
ourG2s = ourG2 /. kk -> ks^2;
ourG3s = ourG3 /. kk -> ks^2;
ourG4s = ourG4 /. kk -> ks^2;

(* ============================================================ *)
(* 4. Compare Groups 1-3 term by term *)
(* ============================================================ *)
compareGroup[ourGroup_, refGroup_, name_] := Module[
  {matchCount = 0, diffCount = 0, i, d, simplified},
  
  Print["\n========================================"];
  Print["Comparing ", name];
  Print["========================================"];
  
  For[i = 1, i <= 16, i++,
    d = Expand[ourGroup[[i]] - refGroup[[i]]];
    simplified = Simplify[d];
    
    If[simplified === 0,
      matchCount++;
      Print["  Eq ", i, ": MATCH"],
      
      diffCount++;
      Print["  Eq ", i, ": DIFFER"];
      Print["    Difference = ", simplified];
    ];
  ];
  
  Print["  Summary: ", matchCount, " match, ", diffCount, " differ"];
  {matchCount, diffCount}
]

results1 = compareGroup[ourG1s, refG1, "Group 1 (time IBP vertex 1)"];
results2 = compareGroup[ourG2s, refG2, "Group 2 (time IBP vertex 2)"];
results3 = compareGroup[ourG3s, refG3, "Group 3 (momentum diagonal IBP)"];

(* ============================================================ *)
(* 5. Group 4: Check span equivalence *)
(* ============================================================ *)
Print["\n========================================"];
Print["Group 4 analysis"];
Print["========================================"];

(* Direct comparison *)
g4direct = compareGroup[ourG4s, refG4, "Group 4 direct (our vs ref)"];

(* Extract all distinct J[...] structures *)
allExprs = Join[ourG3s, ourG4s, refG3, refG4];
allJpatterns = Union@Flatten@Cases[allExprs, _J, Infinity];
Print["\nTotal distinct J structures: ", Length[allJpatterns]];

(* Build coefficient vectors *)
getCoeffVec[expr_, patterns_] := Module[
  {expanded = Expand[expr]},
  Table[Coefficient[expanded, p], {p, patterns}]
];

ourG3mat = Table[getCoeffVec[ourG3s[[i]], allJpatterns], {i, 16}];
ourG4mat = Table[getCoeffVec[ourG4s[[i]], allJpatterns], {i, 16}];
refG3mat = Table[getCoeffVec[refG3[[i]], allJpatterns], {i, 16}];
refG4mat = Table[getCoeffVec[refG4[[i]], allJpatterns], {i, 16}];

ourAll34 = Join[ourG3mat, ourG4mat];
refAll34 = Join[refG3mat, refG4mat];

ourRank = MatrixRank[ourAll34];
refRank = MatrixRank[refAll34];
combinedRank = MatrixRank[Join[ourAll34, refAll34]];

Print["\nRank of our G3+G4: ", ourRank];
Print["Rank of ref G3+G4: ", refRank];
Print["Rank of combined: ", combinedRank];

If[combinedRank == ourRank == refRank,
  Print["PASS: Our G3+G4 and ref G3+G4 span the SAME space."],
  Print["FAIL: Spaces differ. Combined rank = ", combinedRank]
];

(* Check: does ref G4 lie in span of our G4 + ref G3? *)
refG3G4 = Join[refG3mat, refG4mat];
ourG4refG3 = Join[ourG4mat, refG3mat];
rankRefG3G4 = MatrixRank[refG3G4];
rankOurG4refG3 = MatrixRank[ourG4refG3];
rankCombined = MatrixRank[Join[ourG4refG3, refG3G4]];

Print["\nRef G3+G4 rank: ", rankRefG3G4];
Print["Our G4 + Ref G3 rank: ", rankOurG4refG3];
Print["Combined rank: ", rankCombined];

If[rankCombined == rankRefG3G4,
  Print["PASS: Our G4 + Ref G3 spans same space as Ref G3 + Ref G4."],
  Print["FAIL: Our G4 + Ref G3 does NOT span same space as Ref G3 + Ref G4."]
];

(* For each ref G4 equation, try to express as our G4 + combo of ref G3 *)
Print["\n--- Expressing ref G4[i] = our G4[i] + combo of ref G3 ---"];
g3MatrixT = Transpose[refG3mat]; (* 16 columns = 16 refG3 equations *)

For[i = 1, i <= 16, i++,
  target = getCoeffVec[refG4[[i]] - ourG4s[[i]], allJpatterns];
  
  (* Check if target is in column space of g3MatrixT *)
  sol = LeastSquares[N[g3MatrixT], N[target]];
  check = g3MatrixT . sol;
  residual = target - check;
  maxResid = Max[Abs[residual]];
  
  If[maxResid < 10^-8,
    Print["  Eq ", i, ": YES. Coefficients: ", 
      Table[If[Abs[sol[[j]]] > 10^-10, j -> NumberForm[sol[[j]], 6], Nothing], 
        {j, Length[sol]}]],
    Print["  Eq ", i, ": NO. Max residual = ", maxResid];
  ];
];

(* Also try: ref G4[i] = our G4[j] + combo of ref G3, for any j *)
Print["\n--- Expressing ref G4[i] = our G4[j] + combo of ref G3 (any j) ---"];
For[i = 1, i <= 16, i++,
  found = False;
  For[j = 1, j <= 16, j++,
    target = getCoeffVec[refG4[[i]] - ourG4s[[j]], allJpatterns];
    sol = LeastSquares[N[g3MatrixT], N[target]];
    check = g3MatrixT . sol;
    residual = target - check;
    maxResid = Max[Abs[residual]];
    
    If[maxResid < 10^-8,
      Print["  Ref G4 eq ", i, " = Our G4 eq ", j, " + combo(refG3). Resid = ", maxResid];
      found = True;
      Break[];
    ];
  ];
  If[!found,
    Print["  Ref G4 eq ", i, ": NO MATCH with any our G4 eq"];
  ];
];

(* Also try: our G4[i] = ref G4[j] + combo of ref G3, for any j *)
Print["\n--- Expressing our G4[i] = ref G4[j] + combo of ref G3 (any j) ---"];
For[i = 1, i <= 16, i++,
  found = False;
  For[j = 1, j <= 16, j++,
    target = getCoeffVec[ourG4s[[i]] - refG4[[j]], allJpatterns];
    sol = LeastSquares[N[g3MatrixT], N[target]];
    check = g3MatrixT . sol;
    residual = target - check;
    maxResid = Max[Abs[residual]];
    
    If[maxResid < 10^-8,
      Print["  Our G4 eq ", i, " = Ref G4 eq ", j, " + combo(refG3). Resid = ", maxResid];
      found = True;
      Break[];
    ];
  ];
  If[!found,
    Print["  Our G4 eq ", i, ": NO MATCH with any ref G4 eq"];
  ];
];

Print["\n=== Comparison complete ==="]
