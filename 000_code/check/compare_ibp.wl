(* Comparison script: ibp_equations_v14.m vs check_seeds_J.wl *)
(* Uses kk = ks^2 to check equivalence *)

$Output = "stdout";

Print["=== IBP Equation Comparison Script ==="];
Print[""];

(* --- Import our output file --- *)
ourRaw = Import["D:/Agent-projects-nut/dSibp_package/000_code/ibp_equations_v14.m", "Text"];
ourLines = StringSplit[ourRaw, "\n"];
ourLines = Select[ourLines, StringLength[#] > 0 &];
Print["Our file: ", Length[ourLines], " lines"];

(* Parse each line as a Mathematica expression (strip trailing semicolons) *)
ourExprs = Table[
   ToExpression[StringTrim[line, {";", " ", "\t"}]],
   {line, ourLines}
];

(* Group into 4x16 *)
ourG1 = ourExprs[[1 ;; 16]];
ourG2 = ourExprs[[17 ;; 32]];
ourG3 = ourExprs[[33 ;; 48]];
ourG4 = ourExprs[[49 ;; 64]];

(* --- Import reference file --- *)
refRaw = Import["D:/Agent-projects-nut/dSibp_package/000_code/check/check_seeds_J.wl", "Text"];
refExpr = ToExpression[refRaw];
Print["Reference file: ", Length[refExpr], " groups of ", Length[refExpr[[1]]], " equations"];

refG1 = refExpr[[1]];
refG2 = refExpr[[2]];
refG3 = refExpr[[3]];
refG4 = refExpr[[4]];

(* --- Set kk = ks^2 --- *)
Print[""];
Print["=== Substituting kk -> ks^2 ==="];

ourG1s = ourG1 /. kk -> ks^2;
ourG2s = ourG2 /. kk -> ks^2;
ourG3s = ourG3 /. kk -> ks^2;
ourG4s = ourG4 /. kk -> ks^2;

(* === GROUP 1 === *)
Print[""];
Print["=== GROUP 1: Time IBP vertex 1 (16 equations) ==="];
g1Match = True;
Do[
  diff = Simplify[ourG1s[[i]] - refG1[[i]]];
  If[diff =!= 0,
    Print["  Eq ", i, ": MISMATCH. Difference = ", diff];
    g1Match = False,
    Print["  Eq ", i, ": MATCH"]
  ],
  {i, 16}
];
If[g1Match, Print[">>> GROUP 1: ALL 16 EQUATIONS MATCH EXACTLY <<<"],
  Print[">>> GROUP 1: HAS MISMATCHES <<<"]
];

(* === GROUP 2 === *)
Print[""];
Print["=== GROUP 2: Time IBP vertex 2 (16 equations) ==="];
g2Match = True;
Do[
  diff = Simplify[ourG2s[[i]] - refG2[[i]]];
  If[diff =!= 0,
    Print["  Eq ", i, ": MISMATCH. Difference = ", diff];
    g2Match = False,
    Print["  Eq ", i, ": MATCH"]
  ],
  {i, 16}
];
If[g2Match, Print[">>> GROUP 2: ALL 16 EQUATIONS MATCH EXACTLY <<<"],
  Print[">>> GROUP 2: HAS MISMATCHES <<<"]
];

(* === GROUP 3 === *)
Print[""];
Print["=== GROUP 3: Momentum diagonal IBP (16 equations) ==="];
g3Match = True;
Do[
  diff = Simplify[ourG3s[[i]] - refG3[[i]]];
  If[diff =!= 0,
    Print["  Eq ", i, ": MISMATCH. Difference = ", diff];
    g3Match = False,
    Print["  Eq ", i, ": MATCH"]
  ],
  {i, 16}
];
If[g3Match, Print[">>> GROUP 3: ALL 16 EQUATIONS MATCH EXACTLY <<<"],
  Print[">>> GROUP 3: HAS MISMATCHES <<<"]
];

(* === GROUP 4: Span equivalence === *)
Print[""];
Print["=== GROUP 4: External momentum IBP (16 equations) ==="];

(* First check direct match *)
g4DirectCount = 0;
Do[
  diff = Simplify[ourG4s[[i]] - refG4[[i]]];
  If[diff === 0, g4DirectCount++],
  {i, 16}
];
Print["Direct matches: ", g4DirectCount, "/16"];

(* For span check, use numerical evaluation with random primes *)
(* This avoids symbolic rank computation issues *)
Print[""];
Print["Span check via numerical evaluation..."];

(* Assign random numerical values to all parameters *)
SeedRandom[42];
randVals = {
  a1 -> RandomInteger[{100, 999}],
  a2 -> RandomInteger[{100, 999}],
  b1 -> RandomInteger[{100, 999}],
  b2 -> RandomInteger[{100, 999}],
  d -> RandomInteger[{100, 999}],
  nu1 -> RandomInteger[{100, 999}],
  nu2 -> RandomInteger[{100, 999}],
  ks -> RandomInteger[{100, 999}],
  P1 -> RandomInteger[{100, 999}],
  P2 -> RandomInteger[{100, 999}]
};
Print["Random values: ", randVals];

(* Substitute numerical values *)
ourG3n = ourG3s /. randVals;
ourG4n = ourG4s /. randVals;
refG4n = refG4 /. randVals;

(* Collect all J structures *)
allJStructs = Union[Cases[
  Join[ourG3s, ourG4s, refG4],
  J[_, _],
  Infinity
]];
nJ = Length[allJStructs];
Print["Number of distinct J structures: ", nJ];

(* Build coefficient matrices numerically *)
getCoeffVec[expr_, structs_] := Table[
  Coefficient[expr, s],
  {s, structs}
];

matG3n = Map[getCoeffVec[#, allJStructs] &, ourG3n];
matOurG4n = Map[getCoeffVec[#, allJStructs] &, ourG4n];
matRefG4n = Map[getCoeffVec[#, allJStructs] &, refG4n];

(* Check 1: rank of {ourG3, ourG4} should be 32 *)
matCombined1 = Join[matG3n, matOurG4n];
rank32 = MatrixRank[matCombined1];
Print[""];
Print["Rank of {ourG3, ourG4}: ", rank32, " (expected 32)"];

(* Check 2: rank of {ourG3, refG4} should also be 32 *)
matCombined2 = Join[matG3n, matRefG4n];
rank32b = MatrixRank[matCombined2];
Print["Rank of {ourG3, refG4}: ", rank32b, " (expected 32)"];

(* Check 3: rank of {ourG3, ourG4, refG4} should be 32 (span equivalence) *)
matCombined3 = Join[matG3n, matOurG4n, matRefG4n];
rank48 = MatrixRank[matCombined3];
Print["Rank of {ourG3, ourG4, refG4}: ", rank48, " (expected 32 for span equivalence)"];

(* Also verify with a second set of random values to be sure *)
Print[""];
Print["--- Verification with second random seed ---"];
SeedRandom[12345];
randVals2 = {
  a1 -> RandomInteger[{1000, 9999}],
  a2 -> RandomInteger[{1000, 9999}],
  b1 -> RandomInteger[{1000, 9999}],
  b2 -> RandomInteger[{1000, 9999}],
  d -> RandomInteger[{1000, 9999}],
  nu1 -> RandomInteger[{1000, 9999}],
  nu2 -> RandomInteger[{1000, 9999}],
  ks -> RandomInteger[{1000, 9999}],
  P1 -> RandomInteger[{1000, 9999}],
  P2 -> RandomInteger[{1000, 9999}]
};

ourG3n2 = ourG3s /. randVals2;
ourG4n2 = ourG4s /. randVals2;
refG4n2 = refG4 /. randVals2;

matG3n2 = Map[getCoeffVec[#, allJStructs] &, ourG3n2];
matOurG4n2 = Map[getCoeffVec[#, allJStructs] &, ourG4n2];
matRefG4n2 = Map[getCoeffVec[#, allJStructs] &, refG4n2];

matCombined3b = Join[matG3n2, matOurG4n2, matRefG4n2];
rank48b = MatrixRank[matCombined3b];
Print["Rank of {ourG3, ourG4, refG4} (2nd seed): ", rank48b, " (expected 32)"];

(* Also check individual ref equations are in span *)
Print[""];
Print["--- Per-equation span check ---"];
Do[
  diffVec = matRefG4n[[i]] - matOurG4n[[i]];
  augMat = Join[matG3n, {diffVec}];
  rBase = MatrixRank[matG3n];
  rAug = MatrixRank[augMat];
  If[rBase == rAug,
    Print["  Eq ", i, ": ref-our difference is in Span(ourG3) [rank ", rBase, "]"],
    Print["  Eq ", i, ": NOT in span! rank base=", rBase, " aug=", rAug]
  ],
  {i, 16}
];

Print[""];
Print["=== COMPARISON COMPLETE ==="];
