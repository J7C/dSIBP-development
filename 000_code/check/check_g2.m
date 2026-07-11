(* Quick check: Group 2 symmetry *)
$HistoryLength = 0;
Print["Starting..."];

ourRaw = ReadList["D:\\Agent-projects-nut\\dSibp_package\\000_code\\ibp_equations_v13.m", String];
ourLines = Select[StringTrim[StringReplace[#, ";" ~~ EndOfString -> ""]] & /@ ourRaw, StringLength[#] > 0 &];
ourEqs = ToExpression /@ ourLines;
Print["Loaded ", Length[ourEqs], " equations"];

ourG2 = ourEqs[[17;;32]] /. kk -> ks^2;
refData = Get["D:\\Agent-projects-nut\\dSibp_package\\000_code\\check\\check_seeds_J.wl"];
refG2 = refData[[2]];

(* Check: are all differences of the form J[{a1,-1+a1+a2},X] - J[{-1+a1+a2,a2},X]? *)
Print["\n=== Group 2 differences ==="];
Do[
  d = Expand[ourG2[[i]] - refG2[[i]]];
  If[d === 0,
    Print["Eq ", i, ": exact match"],
    (* Check if difference only contains J with {a1, -1+a1+a2} or {-1+a1+a2, a2} *)
    allJ = Cases[d, _J, {0, Infinity}];
    badJ = Select[allJ, j -> !MatchQ[j[[1]], {a1, -1+a1+a2}] && !MatchQ[j[[1]], {-1+a1+a2, a2}]];
    If[Length[badJ] == 0,
      Print["Eq ", i, ": symmetry only (", Length[allJ], " J-terms)"],
      Print["Eq ", i, ": has non-symmetry terms! ", Length[badJ], " bad J's"];
      Do[Print["  ", badJ[[k]]], {k, Length[badJ]}];
    ];
  ],
  {i, 16}
];
Print["Done G2"];
