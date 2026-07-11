(* Efficient span check with proper canonicalization *)
$HistoryLength = 0;
Print["Starting..."];

ourRaw = ReadList["D:\\Agent-projects-nut\\dSibp_package\\000_code\\ibp_equations_v13.m", String];
ourLines = Select[StringTrim[StringReplace[#, ";" ~~ EndOfString -> ""]] & /@ ourRaw, StringLength[#] > 0 &];
ourEqs = ToExpression /@ ourLines;
ourG3 = ourEqs[[33;;48]] /. kk -> ks^2;
ourG4 = ourEqs[[49;;64]] /. kk -> ks^2;

refData = Get["D:\\Agent-projects-nut\\dSibp_package\\000_code\\check\\check_seeds_J.wl"];
refG3 = refData[[3]]; refG4 = refData[[4]];

(* Canonical form: replace J[{a1, -1+a1+a2}, X] -> J[{-1+a1+a2, a2}, X] *)
(* This is the symmetry that identifies the two forms *)
canonRule = J[{a1, -1 + a1 + a2}, x___] :> J[{-1 + a1 + a2, a2}, x];
canon[expr_] := expr /. canonRule

Print["=== G3 with J-symmetry ==="];
Do[
  d = Expand[canon[ourG3[[i]]] - canon[refG3[[i]]]];
  If[d === 0, Print["Eq ", i, ": MATCH"], Print["Eq ", i, ": DIFFERS"]],
  {i, 16}
];

Print["\n=== G4 with J-symmetry ==="];
Do[
  d = Expand[canon[ourG4[[i]]] - canon[refG4[[i]]]];
  If[d === 0, Print["Eq ", i, ": MATCH"], Print["Eq ", i, ": DIFFERS"]],
  {i, 16}
];

(* Now do span check with canonicalized J structures *)
Print["\n=== Span check (canonical) ==="];

allCanon = Join[canon /@ ourG3, canon /@ ourG4, canon /@ refG3, canon /@ refG4];
allJP = Union@Flatten@Cases[allCanon, _J, {0, Infinity}];
Print["Distinct J structures: ", Length[allJP]];

gcv[expr_] := Module[{e = Expand[canon[expr]]},
  Table[Coefficient[e, p], {p, allJP}]
];

Print["Building matrices..."];
oG3 = Table[gcv[ourG3[[i]]], {i, 16}];
oG4 = Table[gcv[ourG4[[i]]], {i, 16}];
rG3 = Table[gcv[refG3[[i]]], {i, 16}];
rG4 = Table[gcv[refG4[[i]]], {i, 16}];

oAll = Join[oG3, oG4]; rAll = Join[rG3, rG4];
Print["Matrix dimensions: our=", Dimensions[oAll], " ref=", Dimensions[rAll]];

oR = MatrixRank[oAll]; rR = MatrixRank[rAll];
cR = MatrixRank[Join[oAll, rAll]];
Print["Our rank: ", oR, " Ref rank: ", rR, " Combined: ", cR];

If[cR == oR == rR, Print["PASS: Same space"],
  Print["FAIL: Excess rank = ", cR - Max[oR, rR]]];

(* Check our G4 + ref G3 vs ref G3+G4 *)
r1 = MatrixRank[Join[oG4, rG3]];
r2 = MatrixRank[Join[rG3, rG4]];
r3 = MatrixRank[Join[oG4, rG3, rG4]];
Print["\nOurG4+RefG3 rank: ", r1, " RefG3+G4 rank: ", r2, " Combined: ", r3];
If[r3 == r2, Print["PASS: OurG4+RefG3 spans same as RefG3+G4"],
  Print["FAIL: gap = ", r3 - r2]];

(* Find basis change if possible *)
If[r3 == r2,
  Print["\n=== Basis change ==="];
  rG3T = Transpose[rG3];
  Do[
    found = False;
    Do[
      target = gcv[refG4[[i]] - ourG4[[j]]];
      sol = LinearSolve[N[rG3T], N[target]];
      res = Max[Abs[target - rG3T . sol]];
      If[res < 10^-8,
        nz = Flatten[Position[Chop[sol, 10^-10], _?(# != 0 &)]];
        Print["  refG4[", i, "] = ourG4[", j, "] + ", 
          Table[k -> NumberForm[sol[[k]], {6, 3}], {k, nz}], " . refG3"];
        found = True; Break[]],
      {j, 16}];
    If[!found, Print["  refG4[", i, "]: NO MATCH"]],
    {i, 16}];
];

Print["\n=== Done ==="]
