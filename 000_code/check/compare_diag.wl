(* Diagnostic: Group 2 swap pattern + Group 4 J-structure comparison *)
$Output = "stdout";

ourRaw = Import["D:/Agent-projects-nut/dSibp_package/000_code/ibp_equations_v14.m", "Text"];
ourLines = Select[StringSplit[ourRaw, "\n"], StringLength[#] > 0 &];
ourExprs = ToExpression[StringTrim[#, {";", " ", "\t"}]] & /@ ourLines;

refRaw = Import["D:/Agent-projects-nut/dSibp_package/000_code/check/check_seeds_J.wl", "Text"];
refExpr = ToExpression[refRaw];

(* === GROUP 2: Check if differences vanish under a1<->a2 exchange === *)
Print["=== Group 2: a1<->a2 exchange test ==="];
ourG2 = (ourExprs[[17 ;; 32]]) /. kk -> ks^2;
refG2 = refExpr[[2]];

Do[
  diff = Simplify[ourG2[[i]] - refG2[[i]]];
  If[diff =!= 0,
    (* Test: swap a1<->a2 in the difference *)
    diffSwap = diff /. {a1 -> a2, a2 -> a1};
    diffSwap = Simplify[diffSwap];
    If[diffSwap === 0,
      Print["  Eq ", i, ": vanishes under a1<->a2 exchange"],
      Print["  Eq ", i, ": does NOT vanish under a1<->a2"]
    ],
    Print["  Eq ", i, ": matches directly"]
  ],
  {i, 16}
];

(* === GROUP 2: Identify the exact pattern of J-structure differences === *)
Print[""];
Print["=== Group 2: J-structure pattern in differences ==="];
Do[
  diff = Simplify[ourG2[[i]] - refG2[[i]]];
  If[diff =!= 0,
    ourJ = Cases[diff, J[{a1, -1 + a1 + a2}, ___]];
    refJ = Cases[diff, J[{-1 + a1 + a2, a2}, ___]];
    Print["  Eq ", i, ": our J[{a1,-1+a1+a2},...] count=", Length[ourJ],
          "  ref J[{-1+a1+a2,a2},...] count=", Length[refJ]]
  ],
  {i, 16}
];

(* === GROUP 4: Compare J structures === *)
Print[""];
Print["=== Group 4: J-structure comparison ==="];
ourG4 = (ourExprs[[49 ;; 64]]) /. kk -> ks^2;
refG4 = refExpr[[4]];
ourG3 = (ourExprs[[33 ;; 48]]) /. kk -> ks^2;
refG3 = refExpr[[3]];

ourJ4 = Union[Cases[ourG4, _J, Infinity]];
refJ4 = Union[Cases[refG4, _J, Infinity]];
ourJ3 = Union[Cases[ourG3, _J, Infinity]];
refJ3 = Union[Cases[refG3, _J, Infinity]];

Print["Our G3 J-structures: ", Length[ourJ3]];
Print["Ref G3 J-structures: ", Length[refJ3]];
Print["Our G4 J-structures: ", Length[ourJ4]];
Print["Ref G4 J-structures: ", Length[refJ4]];

(* J structures in our G4 but not in ref G4 *)
onlyOur = Complement[ourJ4, refJ4];
onlyRef = Complement[refJ4, ourJ4];
inBoth = Intersection[ourJ4, refJ4];

Print[""];
Print["J structures in BOTH G4: ", Length[inBoth]];
Print["J structures ONLY in our G4: ", Length[onlyOur]];
Print["J structures ONLY in ref G4: ", Length[onlyRef]];

If[Length[onlyOur] > 0 && Length[onlyOur] <= 20,
  Print[""];
  Print["Only in our G4:"];
  Do[Print["  ", j], {j, onlyOur}]
];

If[Length[onlyRef] > 0 && Length[onlyRef] <= 20,
  Print[""];
  Print["Only in ref G4:"];
  Do[Print["  ", j], {j, onlyRef}]
];

(* Check: are the "only ours" related to "only ref" by some transformation? *)
If[Length[onlyOur] > 0 && Length[onlyRef] > 0,
  Print[""];
  Print["Checking if 'only ours' and 'only ref' are related by second-arg shift..."];
  (* Look at the second argument patterns *)
  ourSecArgs = Union[#[[2]] & /@ onlyOur];
  refSecArgs = Union[#[[2]] & /@ onlyRef];
  Print["Our unique second args: ", ourSecArgs];
  Print["Ref unique second args: ", refSecArgs];
];

(* Also check: do the first arguments match between our G4 and ref G4? *)
ourFirstArgs = Union[#[[1]] & /@ ourJ4];
refFirstArgs = Union[#[[1]] & /@ refJ4];
Print[""];
Print["Our G4 first args: ", ourFirstArgs];
Print["Ref G4 first args: ", refFirstArgs];

(* Check if first args are the same *)
If[ourFirstArgs == refFirstArgs,
  Print["First arguments MATCH between our G4 and ref G4"],
  Print["First arguments DIFFER between our G4 and ref G4"]
];

Print[""];
Print["=== DONE ==="];
