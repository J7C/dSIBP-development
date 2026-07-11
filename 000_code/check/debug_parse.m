(* Debug: try different parsing approaches *)
$HistoryLength = 0;

(* Approach 1: strip comment, then ToExpression *)
refRaw = Import["D:/Agent-projects-nut/dSibp_package/000_code/check/check_seeds_J.wl", "String"];
(* Remove comment *)
refClean = StringReplace[refRaw, "(* Created with the Wolfram Language : www.wolfram.com *)" -> ""];
refClean = StringTrim[refClean];
Print["First 100 chars of cleaned: ", StringTake[refClean, 100]];
refData = ToExpression[refClean];
Print["Approach 1 - Head: ", Head[refData], " Length: ", Length[refData]];
If[ListQ[refData] && Length[refData] >= 1,
  Print["  refData[[1]] Length: ", Length[refData[[1]]]];
  If[Length[refData] >= 4,
    Print["  Group sizes: ", {Length[refData[[1]]], Length[refData[[2]]], Length[refData[[3]]], Length[refData[[4]]]}];
  ];
];
