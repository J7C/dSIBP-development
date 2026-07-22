result = Get[FileNameJoin[{DirectoryName[$InputFileName], "phase2_results.wl"}]];
failed = Select[result["checks"], ! TrueQ[#passed] &];
Do[
  Print["NAME=" <> item["group"] <> ":" <> item["name"]];
  Print["ACTUAL=" <> ToString[Short[item["actual"], 4], InputForm]];
  Print["EXPECTED=" <> ToString[Short[item["expected"], 4], InputForm]];
  If[MatchQ[item["actual"] - item["expected"], _Plus | _Times | _Symbol | _Integer | _Rational | _Complex | _J],
    Print["SIMPLIFIED_DIFFERENCE=" <> ToString[Short[Collect[Together[item["actual"] - item["expected"]], _J], 5], InputForm]]
  ];
  Print["---"],
  {item, failed}
];
