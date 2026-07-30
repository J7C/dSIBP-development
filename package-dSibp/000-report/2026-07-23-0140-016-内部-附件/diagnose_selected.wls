result = Get[FileNameJoin[{DirectoryName[$InputFileName], "phase2_results.wl"}]];
targets = {
  "fixed endpoint dtau n1",
  "two iteration vs direct seed symbolic", "two deterministic rational iteration",
  "three iteration vs direct seed symbolic", "three deterministic rational iteration",
  "mixed product and chain rule"
};
Do[
  item = SelectFirst[result["checks"], #["name"] === name &];
  Print["NAME=" <> name];
  Print["ACTUAL=" <> ToString[item["actual"], InputForm]];
  Print["EXPECTED=" <> ToString[item["expected"], InputForm]];
  Print["DIFF=" <> ToString[Collect[Together[item["actual"] - item["expected"]], _J], InputForm]];
  Print["---"],
  {name, targets}
];
