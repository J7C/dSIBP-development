(* Numerical span check - fixed paths *)
$HistoryLength = 0;
Print["Starting numerical check..."];

(* Assign numerical values *)
a1v = 3; a2v = 5; b1v = 2; b2v = 3; dv = 3; nu1v = 1/3; nu2v = 1/4; ksv = 7;
rules = {a1 -> a1v, a2 -> a2v, b1 -> b1v, b2 -> b2v, d -> dv, 
         nu1 -> nu1v, nu2 -> nu2v, ks -> ksv};

(* Read files - use forward slashes *)
ourRaw = ReadList["D:/Agent-projects-nut/dSibp_package/000_code/ibp_equations_v13.m", String];
ourLines = Select[StringTrim[StringReplace[#, ";" ~~ EndOfString -> ""]] & /@ ourRaw, StringLength[#] > 0 &];
ourEqs = ToExpression /@ ourLines;
ourG3 = ourEqs[[33;;48]] /. kk -> ks^2;
ourG4 = ourEqs[[49;;64]] /. kk -> ks^2;

refData = Get["D:/Agent-projects-nut/dSibp_package/000_code/check/check_seeds_J.wl"];
refG3 = refData[[3]]; refG4 = refData[[4]];

Print["Loaded: our=", Length[ourEqs], " ref groups=", Length[refData], " sizes=", Length /@ refData];

(* Substitute numerical values *)
oG3n = ourG3 /. rules;
oG4n = ourG4 /. rules;
rG3n = refG3 /. rules;
rG4n = refG4 /. rules;

(* Extract all J structures *)
allJ = Union@Flatten@Cases[Join[oG3n, oG4n, rG3n, rG4n], _J, {0, Infinity}];
Print["Distinct J structures: ", Length[allJ]];

(* Build coefficient matrices *)
gcv[expr_] := Table[Coefficient[expr, p], {p, allJ}];

oG3m = Table[gcv[oG3n[[i]]], {i, 16}];
oG4m = Table[gcv[oG4n[[i]]], {i, 16}];
rG3m = Table[gcv[rG3n[[i]]], {i, 16}];
rG4m = Table[gcv[rG4n[[i]]], {i, 16}];

(* Check ranks *)
oAll = Join[oG3m, oG4m]; rAll = Join[rG3m, rG4m];
oR = MatrixRank[oAll]; rR = MatrixRank[rAll]; cR = MatrixRank[Join[oAll, rAll]];
Print["Our G3+G4 rank: ", oR];
Print["Ref G3+G4 rank: ", rR];
Print["Combined rank: ", cR];

If[cR == oR == rR, Print["PASS: Same space"],
  Print["FAIL: Excess = ", cR - Max[oR, rR]]];

(* Check our G4 + ref G3 vs ref G3+G4 *)
r1 = MatrixRank[Join[oG4m, rG3m]];
r2 = MatrixRank[Join[rG3m, rG4m]];
r3 = MatrixRank[Join[oG4m, rG3m, rG4m]];
Print["\nOurG4+RefG3 rank: ", r1];
Print["RefG3+G4 rank: ", r2];
Print["Combined: ", r3];
If[r3 == r2, Print["PASS: OurG4+RefG3 spans same as RefG3+G4"],
  Print["FAIL: gap = ", r3 - r2]];

(* Find basis change if span works *)
If[r3 == r2,
  Print["\n=== Basis change ==="];
  rG3T = Transpose[rG3m];
  Do[
    found = False;
    Do[
      target = gcv[rG4n[[i]] - oG4n[[j]]];
      sol = LinearSolve[N[rG3T], N[target]];
      res = Max[Abs[N[target] - N[rG3T] . sol]];
      If[res < 10^-6,
        nz = Flatten[Position[Chop[sol, 10^-10], _?(# != 0 &)]];
        Print["  refG4[", i, "] = ourG4[", j, "] + ", 
          Table[k -> NumberForm[sol[[k]], {4, 2}], {k, nz}], " . refG3"];
        found = True; Break[]],
      {j, 16}];
    If[!found, Print["  refG4[", i, "]: NO MATCH"]],
    {i, 16}];
];

(* Also try: our G4[i] = ref G4[j] + combo(ref G3) *)
If[r3 == r2,
  Print["\n=== Reverse basis change ==="];
  Do[
    found = False;
    Do[
      target = gcv[oG4n[[i]] - rG4n[[j]]];
      sol = LinearSolve[N[rG3T], N[target]];
      res = Max[Abs[N[target] - N[rG3T] . sol]];
      If[res < 10^-6,
        nz = Flatten[Position[Chop[sol, 10^-10], _?(# != 0 &)]];
        Print["  ourG4[", i, "] = refG4[", j, "] + ", 
          Table[k -> NumberForm[sol[[k]], {4, 2}], {k, nz}], " . refG3"];
        found = True; Break[]],
      {j, 16}];
    If[!found, Print["  ourG4[", i, "]: NO MATCH"]],
    {i, 16}];
];

(* Check G3 differences *)
Print["\n=== G3 diff structure (eq 1) ==="];
d1 = Expand[oG3n[[1]] - rG3n[[1]]];
Print["Eq1 diff: ", d1];
jInDiff = Cases[d1, _J, {0, Infinity}];
Print["J terms in diff: ", Length[jInDiff]];
Do[Print["  ", jInDiff[[k]]], {k, Length[jInDiff]}];

(* Check G4 differences *)
Print["\n=== G4 diff structure (eq 1) ==="];
d41 = Expand[oG4n[[1]] - rG4n[[1]]];
Print["Eq1 diff: ", d41];

Print["\n=== Done ==="]
