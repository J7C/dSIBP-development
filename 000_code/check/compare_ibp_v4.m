(* Efficient comparison - v4, avoid Simplify *)
$HistoryLength = 0;

(* Read files *)
ourRaw = ReadList[
  "D:\\Agent-projects-nut\\dSibp_package\\000_code\\ibp_equations_v13.m", String];
ourLines = Select[
  StringTrim[StringReplace[#, ";" ~~ EndOfString -> ""]] & /@ ourRaw,
  StringLength[#] > 0 &];
ourEqs = ToExpression /@ ourLines;

ourG1 = ourEqs[[1;;16]] /. kk -> ks^2;
ourG2 = ourEqs[[17;;32]] /. kk -> ks^2;
ourG3 = ourEqs[[33;;48]] /. kk -> ks^2;
ourG4 = ourEqs[[49;;64]] /. kk -> ks^2;

refData = Get["D:\\Agent-projects-nut\\dSibp_package\\000_code\\check\\check_seeds_J.wl"];
refG1 = refData[[1]]; refG2 = refData[[2]];
refG3 = refData[[3]]; refG4 = refData[[4]];

(* Canonical form: sort first two args of J *)
canon[expr_] := expr /. J[{x_, y_}, rest___] :> J[Sort[{x, y}], rest]

(* ============================================================ *)
(* Part A: Group 2 with J-symmetry *)
(* ============================================================ *)
Print["=== Group 2 with J-symmetry ==="];
g2m = 0; g2d = 0;
Do[
  d = Expand[canon[ourG2[[i]]] - canon[refG2[[i]]]];
  If[d === 0, g2m++, g2d++; Print["  Eq ", i, " still differs"]],
  {i, 16}
];
Print["Match: ", g2m, ", Differ: ", g2d];

(* ============================================================ *)
(* Part B: Group 3 with J-symmetry *)
(* ============================================================ *)
Print["\n=== Group 3 with J-symmetry ==="];
g3m = 0; g3d = 0;
Do[
  d = Expand[canon[ourG3[[i]]] - canon[refG3[[i]]]];
  If[d === 0, g3m++, g3d++; Print["  Eq ", i, " differs"]],
  {i, 16}
];
Print["Match: ", g3m, ", Differ: ", g3d];

(* ============================================================ *)
(* Part C: Group 4 with J-symmetry *)
(* ============================================================ *)
Print["\n=== Group 4 with J-symmetry ==="];
g4m = 0; g4d = 0;
Do[
  d = Expand[canon[ourG4[[i]]] - canon[refG4[[i]]]];
  If[d === 0, g4m++, g4d++; Print["  Eq ", i, " differs"]],
  {i, 16}
];
Print["Match: ", g4m, ", Differ: ", g4d];

(* ============================================================ *)
(* Part D: Analyze G3 difference structure *)
(* ============================================================ *)
Print["\n=== G3 difference structure ==="];
(* Look at what J structures are unique to each *)
ourG3Js = Union@Flatten@Cases[canon[ourG3], _J, {0, Infinity}];
refG3Js = Union@Flatten@Cases[canon[refG3], _J, {0, Infinity}];
Print["Our G3 J-count: ", Length[ourG3Js]];
Print["Ref G3 J-count: ", Length[refG3Js]];

refOnly3 = Complement[refG3Js, ourG3Js];
ourOnly3 = Complement[ourG3Js, refG3Js];
Print["Only in ref G3: ", Length[refOnly3]];
Do[Print["  ", refOnly3[[k]]], {k, Length[refOnly3]}];
Print["Only in our G3: ", Length[ourOnly3]];
Do[Print["  ", ourOnly3[[k]]], {k, Length[ourOnly3]}];

(* ============================================================ *)
(* Part E: Span check with canonical J *)
(* ============================================================ *)
Print["\n=== Span check (canonical J) ==="];

(* Collect all J structures from canonicalized expressions *)
allCanon = Join[
  canon /@ ourG3, canon /@ ourG4,
  canon /@ refG3, canon /@ refG4
];
allJP = Union@Flatten@Cases[allCanon, _J, {0, Infinity}];
Print["Total distinct J (canonical): ", Length[allJP]];

(* Build coefficient matrix *)
gcv[expr_] := Module[{e = Expand[canon[expr]]},
  Table[Coefficient[e, p], {p, allJP}]
];

Print["Building matrices..."];
oG3 = Table[gcv[ourG3[[i]]], {i, 16}];
oG4 = Table[gcv[ourG4[[i]]], {i, 16}];
rG3 = Table[gcv[refG3[[i]]], {i, 16}];
rG4 = Table[gcv[refG4[[i]]], {i, 16}];

oAll = Join[oG3, oG4];
rAll = Join[rG3, rG4];

oR = MatrixRank[oAll];
rR = MatrixRank[rAll];
cR = MatrixRank[Join[oAll, rAll]];

Print["Our G3+G4 rank: ", oR];
Print["Ref G3+G4 rank: ", rR];
Print["Combined rank: ", cR];

If[cR == oR == rR,
  Print["PASS: Same space"],
  Print["FAIL: Different spaces. Excess rank: ", cR - Max[oR, rR]]
];

(* Check our G4 + ref G3 vs ref G3 + ref G4 *)
oG4rG3 = Join[oG4, rG3];
rG3G4 = Join[rG3, rG4];
r1 = MatrixRank[oG4rG3];
r2 = MatrixRank[rG3G4];
r3 = MatrixRank[Join[oG4rG3, rG3G4]];
Print["\nOur G4+Ref G3 rank: ", r1];
Print["Ref G3+G4 rank: ", r2];
Print["Combined: ", r3];
If[r3 == r2,
  Print["PASS: Our G4 + Ref G3 spans same as Ref G3+G4"],
  Print["FAIL: dimension gap = ", r3 - r2]
];

(* ============================================================ *)
(* Part F: If span works, find basis change *)
(* ============================================================ *)
If[r3 == r2,
  Print["\n=== Basis change for G4 ==="];
  rG3T = Transpose[rG3];
  Do[
    found = False;
    Do[
      target = gcv[refG4[[i]] - ourG4[[j]]];
      (* Use exact solve *)
      sol = LinearSolve[N[rG3T], N[target]];
      res = target - rG3T . sol;
      If[Max[Abs[res]] < 10^-8,
        nz = Pick[Range[16], Unitize[Chop[sol, 10^-10]], 1];
        Print["  refG4[", i, "] = ourG4[", j, "] + ", 
          Table[k -> sol[[k]], {k, nz}], " . refG3"];
        found = True; Break[],
        Null
      ],
      {j, 16}
    ];
    If[!found, Print["  refG4[", i, "]: NO MATCH"]],
    {i, 16}
  ];
];

Print["\n=== Done ==="]
