(* Deep analysis script - v3 *)
(* Investigate J-symmetry and ISP structure *)
$HistoryLength = 0;

(* ============================================================ *)
(* Read files *)
(* ============================================================ *)
ourRaw = ReadList[
  "D:\\Agent-projects-nut\\dSibp_package\\000_code\\ibp_equations_v13.m",
  String
];
ourLines = Select[
  StringTrim[StringReplace[#, ";" ~~ EndOfString -> ""]] & /@ ourRaw,
  StringLength[#] > 0 &
];
ourEqs = ToExpression /@ ourLines;

ourG1 = ourEqs[[1 ;; 16]] /. kk -> ks^2;
ourG2 = ourEqs[[17 ;; 32]] /. kk -> ks^2;
ourG3 = ourEqs[[33 ;; 48]] /. kk -> ks^2;
ourG4 = ourEqs[[49 ;; 64]] /. kk -> ks^2;

refData = Get[
  "D:\\Agent-projects-nut\\dSibp_package\\000_code\\check\\check_seeds_J.wl"
];
refG1 = refData[[1]]; refG2 = refData[[2]];
refG3 = refData[[3]]; refG4 = refData[[4]];

(* ============================================================ *)
(* Define J-symmetry: J[{x, y}, args___] == J[{y, x}, args___] *)
(* ============================================================ *)
(* Canonical form: sort the first argument list *)
canonicalize[expr_] := expr /. J[{x_, y_}, args___] :> J[Sort[{x, y}], args]

(* ============================================================ *)
(* Part A: Re-check Group 2 with J-symmetry *)
(* ============================================================ *)
Print["========================================"];
Print["Part A: Group 2 with J-symmetry"];
Print["========================================"];

g2match = 0; g2diff = 0;
For[i = 1, i <= 16, i++,
  d = Simplify[Expand[canonicalize[ourG2[[i]]] - canonicalize[refG2[[i]]]]];
  If[d === 0,
    g2match++;
    Print["  Eq ", i, ": MATCH (after symmetrization)"],
    g2diff++;
    Print["  Eq ", i, ": STILL DIFFERS"];
    Print["    Diff = ", d];
  ];
];
Print["  Summary: ", g2match, " match, ", g2diff, " differ"];

(* ============================================================ *)
(* Part B: Check Group 1 with J-symmetry (sanity check) *)
(* ============================================================ *)
Print["\n========================================"];
Print["Part B: Group 1 with J-symmetry (sanity)"];
Print["========================================"];

g1match = 0; g1diff = 0;
For[i = 1, i <= 16, i++,
  d = Simplify[Expand[canonicalize[ourG1[[i]]] - canonicalize[refG1[[i]]]]];
  If[d === 0,
    g1match++;,
    g1diff++;
    Print["  Eq ", i, ": DIFFERS after sym"];
  ];
];
Print["  Summary: ", g1match, " match, ", g1diff, " differ"];

(* ============================================================ *)
(* Part C: Analyze Group 3 differences in detail *)
(* ============================================================ *)
Print["\n========================================"];
Print["Part C: Group 3 difference structure"];
Print["========================================"];

(* Look at the first difference in detail *)
diff3_1 = Expand[ourG3[[1]] - refG3[[1]]];
Print["\nG3 Eq 1 difference:"];
Print[diff3_1];

(* Identify what types of J structures appear in the difference *)
jTermsDiff = Cases[diff3_1, c_.*J[args___] :> {c, J[args]}, Infinity];
Print["\nJ terms in G3 Eq1 diff:"];
Do[Print["  ", jTermsDiff[[k]]], {k, Length[jTermsDiff]}];

(* Check: are the "extra" J structures in ref G3 related to ISP? *)
(* ISP for the bubble: k1.k2 = (k1^2 + k2^2 - (k1-k2)^2)/2 *)
(* In the integral, ISPs appear as shifted indices *)

(* Collect all J structures unique to ref G3 (not in our G3) *)
ourG3Js = Union@Flatten@Cases[ourG3, _J, Infinity];
refG3Js = Union@Flatten@Cases[refG3, _J, Infinity];
refOnly = Complement[refG3Js, ourG3Js];
ourOnly = Complement[ourG3Js, refG3Js];

Print["\nJ structures only in ref G3: ", Length[refOnly]];
Do[Print["  ", refOnly[[k]]], {k, Length[refOnly]}];

Print["\nJ structures only in our G3: ", Length[ourOnly]];
Do[Print["  ", ourOnly[[k]]], {k, Length[ourOnly]}];

(* ============================================================ *)
(* Part D: Check if ref G3 extra terms are related to ISP *)
(* ============================================================ *)
Print["\n========================================"];
Print["Part D: ISP analysis"];
Print["========================================"];

(* The ISP for the bubble topology is k1.k2 where k1, k2 are loop momenta *)
(* In the integral representation, ISP manifests as shifted propagator indices *)
(* J[{{b1-2,...},{b2+2,...}}] corresponds to (k1.k2)^1 * J[{{b1},{b2}}] *)
(* or equivalently, the ISP k1.k2 = (q1.q2) in momentum space *)

(* Check: do the ref-only J structures have the pattern b1->b1-2, b2->b2+2? *)
Print["\nRef-only J structures pattern analysis:"];
Do[
  j = refOnly[[k]];
  b1args = j[[2, 1]]; (* first set of propagator args *)
  b2args = j[[2, 2]]; (* second set *)
  a1args = j[[1]]; (* vertex args *)
  
  (* Check if first propagator has b1-2 somewhere *)
  hasShiftedB1 = !FreeQ[b1args, -2 + b1];
  hasShiftedB2 = !FreeQ[b2args, 2 + b2];
  
  Print["  ", j];
  Print["    Vertex: ", a1args, " Prop1: ", b1args, " Prop2: ", b2args];
  Print["    Has b1-2: ", hasShiftedB1, " Has b2+2: ", hasShiftedB2];
  ,
  {k, Min[Length[refOnly], 8]}
];

(* ============================================================ *)
(* Part E: Re-check Group 3 with J-symmetry *)
(* ============================================================ *)
Print["\n========================================"];
Print["Part E: Group 3 with J-symmetry"];
Print["========================================"];

g3match = 0; g3diff = 0;
For[i = 1, i <= 16, i++,
  d = Simplify[Expand[canonicalize[ourG3[[i]]] - canonicalize[refG3[[i]]]]];
  If[d === 0,
    g3match++;
    Print["  Eq ", i, ": MATCH"],
    g3diff++;
    Print["  Eq ", i, ": DIFFERS (", LeafCount[d], " nodes)"];
  ];
];
Print["  Summary: ", g3match, " match, ", g3diff, " differ"];

(* ============================================================ *)
(* Part F: Re-check Group 4 with J-symmetry *)
(* ============================================================ *)
Print["\n========================================"];
Print["Part F: Group 4 with J-symmetry"];
Print["========================================"];

g4match = 0; g4diff = 0;
For[i = 1, i <= 16, i++,
  d = Simplify[Expand[canonicalize[ourG4[[i]]] - canonicalize[refG4[[i]]]]];
  If[d === 0,
    g4match++;
    Print["  Eq ", i, ": MATCH"],
    g4diff++;
    Print["  Eq ", i, ": DIFFERS"];
  ];
];
Print["  Summary: ", g4match, " match, ", g4diff, " differ"];

(* ============================================================ *)
(* Part G: Span check with canonicalized J structures *)
(* ============================================================ *)
Print["\n========================================"];
Print["Part G: Span check with canonicalized J"];
Print["========================================"];

(* Build coefficient vectors using canonicalized J structures *)
allExprsCanon = Join[
  canonicalize /@ ourG3,
  canonicalize /@ ourG4,
  canonicalize /@ refG3,
  canonicalize /@ refG4
];
allJpatternsCanon = Union@Flatten@Cases[allExprsCanon, _J, Infinity];
Print["Distinct J structures (canonical): ", Length[allJpatternsCanon]];

getCoeffVecC[expr_, patterns_] := Module[
  {expanded = Expand[canonicalize[expr]]},
  Table[Coefficient[expanded, p], {p, patterns}]
];

ourG3c = Table[getCoeffVecC[ourG3[[i]], allJpatternsCanon], {i, 16}];
ourG4c = Table[getCoeffVecC[ourG4[[i]], allJpatternsCanon], {i, 16}];
refG3c = Table[getCoeffVecC[refG3[[i]], allJpatternsCanon], {i, 16}];
refG4c = Table[getCoeffVecC[refG4[[i]], allJpatternsCanon], {i, 16}];

ourAll34c = Join[ourG3c, ourG4c];
refAll34c = Join[refG3c, refG4c];

ourRankC = MatrixRank[ourAll34c];
refRankC = MatrixRank[refAll34c];
combinedRankC = MatrixRank[Join[ourAll34c, refAll34c]];

Print["Rank of our G3+G4 (canonical): ", ourRankC];
Print["Rank of ref G3+G4 (canonical): ", refRankC];
Print["Rank of combined (canonical): ", combinedRankC];

If[combinedRankC == ourRankC == refRankC,
  Print["PASS: Our G3+G4 and ref G3+G4 span the SAME space (with symmetry)."],
  Print["Combined rank exceeds individual ranks."];
  Print["Difference in dimension: ", combinedRankC - Max[ourRankC, refRankC]];
];

(* Check: does our G4 + ref G3 span same as ref G3 + ref G4? *)
ourG4refG3c = Join[ourG4c, refG3c];
refG3G4c = Join[refG3c, refG4c];
rankOurG4refG3c = MatrixRank[ourG4refG3c];
rankRefG3G4c = MatrixRank[refG3G4c];
rankAllc = MatrixRank[Join[ourG4refG3c, refG3G4c]];

Print["\nRef G3+G4 rank (canonical): ", rankRefG3G4c];
Print["Our G4 + Ref G3 rank (canonical): ", rankOurG4refG3c];
Print["Combined rank (canonical): ", rankAllc];

If[rankAllc == rankRefG3G4c,
  Print["PASS: Our G4 + Ref G3 spans same space as Ref G3 + Ref G4."],
  Print["FAIL: Spaces differ by dimension ", rankAllc - rankRefG3G4c];
];

(* If the span works, find the basis change matrix *)
If[rankAllc == rankRefG3G4c,
  Print["\n--- Finding basis change: ref G4[i] = our G4[?] + combo(ref G3) ---"];
  g3MatrixTc = Transpose[refG3c];
  
  For[i = 1, i <= 16, i++,
    found = False;
    For[j = 1, j <= 16, j++,
      target = getCoeffVecC[refG4[[i]] - ourG4[[j]], allJpatternsCanon];
      sol = LeastSquares[N[g3MatrixTc], N[target]];
      check = g3MatrixTc . sol;
      residual = target - check;
      maxResid = Max[Abs[residual]];
      
      If[maxResid < 10^-8,
        coeffs = Table[If[Abs[sol[[k]]] > 10^-10, k -> NumberForm[sol[[k]], 6], Nothing],
          {k, Length[sol]}];
        Print["  Ref G4[", i, "] = Our G4[", j, "] + ", coeffs, " * refG3"];
        found = True;
        Break[];
      ];
    ];
    If[!found,
      Print["  Ref G4[", i, "]: NO MATCH"];
    ];
  ];
];

Print["\n=== Deep analysis complete ==="]
