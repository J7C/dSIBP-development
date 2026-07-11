(* Group 4 span check with correct coefficient extraction *)
(* Also: analyze Group 2 swap pattern *)

$Output = "stdout";
Print["=== Group 4 Span Check (fixed) ==="];

(* Import files *)
ourRaw = Import["D:/Agent-projects-nut/dSibp_package/000_code/ibp_equations_v14.m", "Text"];
ourLines = Select[StringSplit[ourRaw, "\n"], StringLength[#] > 0 &];
ourExprs = ToExpression[StringTrim[#, {";", " ", "\t"}]] & /@ ourLines;
ourG3 = ourExprs[[33 ;; 48]]; ourG4 = ourExprs[[49 ;; 64]];

refRaw = Import["D:/Agent-projects-nut/dSibp_package/000_code/check/check_seeds_J.wl", "Text"];
refExpr = ToExpression[refRaw];
refG3 = refExpr[[3]]; refG4 = refExpr[[4]];

(* Apply kk -> ks^2 *)
ourG3s = ourG3 /. kk -> ks^2;
ourG4s = ourG4 /. kk -> ks^2;

(* Verify G3 matches ref *)
g3Check = And @@ Table[Simplify[ourG3s[[i]] - refG3[[i]]] === 0, {i, 16}];
Print["Group 3 match confirmed: ", g3Check];

(* Assign numerical values *)
SeedRandom[42];
numVals = {a1 -> RandomInteger[{100, 999}], a2 -> RandomInteger[{100, 999}],
   b1 -> RandomInteger[{100, 999}], b2 -> RandomInteger[{100, 999}],
   d -> RandomInteger[{100, 999}], nu1 -> RandomInteger[{100, 999}],
   nu2 -> RandomInteger[{100, 999}], ks -> RandomInteger[{100, 999}],
   P1 -> RandomInteger[{100, 999}], P2 -> RandomInteger[{100, 999}]};
Print["Numerical values: ", numVals];

(* Substitute numerical values *)
ourG3n = ourG3s /. numVals;
ourG4n = ourG4s /. numVals;
refG4n = refG4 /. numVals;

(* Collect all J structures *)
allJ = Union[Cases[Join[ourG3n, ourG4n, refG4n], _J, Infinity]];
Print["Distinct J structures: ", Length[allJ]];

(* Correct coefficient extraction: use replacement rules *)
getCoeffVec[expr_, jList_] := Module[{rules, syms},
  syms = Table[Symbol["j" <> ToString[i]], {i, Length[jList]}];
  rules = Table[jList[[i]] -> syms[[i]], {i, Length[jList]}];
  exprR = expr /. rules;
  Table[Coefficient[exprR, s], {s, syms}]
];

Print["Extracting coefficient vectors..."];
matG3 = getCoeffVec[#, allJ] & /@ ourG3n;
matOurG4 = getCoeffVec[#, allJ] & /@ ourG4n;
matRefG4 = getCoeffVec[#, allJ] & /@ refG4n;

(* Check ranks *)
rankG3 = MatrixRank[matG3];
Print["Rank of G3: ", rankG3];

rankG3ourG4 = MatrixRank[Join[matG3, matOurG4]];
Print["Rank of {G3, ourG4}: ", rankG3ourG4];

rankG3refG4 = MatrixRank[Join[matG3, matRefG4]];
Print["Rank of {G3, refG4}: ", rankG3refG4];

rankAll = MatrixRank[Join[matG3, matOurG4, matRefG4]];
Print["Rank of {G3, ourG4, refG4}: ", rankAll];

If[rankAll == rankG3ourG4 == rankG3refG4,
  Print[">>> GROUP 4: SPAN EQUIVALENCE CONFIRMED <<<"],
  Print[">>> GROUP 4: SPAN CHECK RESULT: ranks differ <<<"]
];

(* Per-equation check: is refG4[i] - ourG4[i] in Span(G3)? *)
Print[""];
Print["Per-equation span check:"];
Do[
  diffVec = matRefG4[[i]] - matOurG4[[i]];
  rBase = MatrixRank[matG3];
  rAug = MatrixRank[Join[matG3, {diffVec}]];
  If[rBase == rAug,
    Print["  Eq ", i, ": diff in Span(G3), rank=", rBase],
    Print["  Eq ", i, ": NOT in Span(G3)! base=", rBase, " aug=", rAug]
  ],
  {i, 16}
];

(* Verify with second random seed *)
Print[""];
Print["--- Verification with second seed ---"];
SeedRandom[99999];
numVals2 = {a1 -> RandomInteger[{1000, 9999}], a2 -> RandomInteger[{1000, 9999}],
   b1 -> RandomInteger[{1000, 9999}], b2 -> RandomInteger[{1000, 9999}],
   d -> RandomInteger[{1000, 9999}], nu1 -> RandomInteger[{1000, 9999}],
   nu2 -> RandomInteger[{1000, 9999}], ks -> RandomInteger[{1000, 9999}],
   P1 -> RandomInteger[{1000, 9999}], P2 -> RandomInteger[{1000, 9999}]};

ourG3n2 = ourG3s /. numVals2; ourG4n2 = ourG4s /. numVals2; refG4n2 = refG4 /. numVals2;
allJ2 = Union[Cases[Join[ourG3n2, ourG4n2, refG4n2], _J, Infinity]];
matG3b = getCoeffVec[#, allJ2] & /@ ourG3n2;
matOurG4b = getCoeffVec[#, allJ2] & /@ ourG4n2;
matRefG4b = getCoeffVec[#, allJ2] & /@ refG4n2;
rankAll2 = MatrixRank[Join[matG3b, matOurG4b, matRefG4b]];
rankBase2 = MatrixRank[Join[matG3b, matOurG4b]];
Print["Rank {G3, ourG4, refG4} (2nd seed): ", rankAll2, " vs rank {G3, ourG4}: ", rankBase2];

(* === GROUP 2 ANALYSIS === *)
Print[""];
Print["=== Group 2 Swap Pattern Analysis ==="];
ourG2 = ourExprs[[17 ;; 32]];
refG2 = refExpr[[2]];
ourG2s = ourG2 /. kk -> ks^2;

Print["Checking if differences vanish under J[{a,b},...] -> J[{b,a},...] swap..."];
(* For each mismatched eq, apply the swap and recheck *)
Do[
  diff = Simplify[ourG2s[[i]] - refG2[[i]]];
  If[diff =!= 0,
    (* Apply swap: J[{x, y}, ...] -> J[{y, x}, ...] for first argument *)
    diffSwapped = diff /. J[{a_, b_}, c__] :> J[{b, a}, c];
    diffSwapped = Simplify[diffSwapped];
    If[diffSwapped === 0,
      Print["  Eq ", i, ": vanishes under first-arg swap (swap symmetry)"],
      Print["  Eq ", i, ": does NOT vanish under swap. Remaining: ", diffSwapped]
    ],
    Print["  Eq ", i, ": matches directly"]
  ],
  {i, 16}
];

Print[""];
Print["=== DONE ==="];
