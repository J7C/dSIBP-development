result = Get[FileNameJoin[{DirectoryName[$InputFileName], "phase2_results.wl"}]];
summary = result["summary"];
Do[
  data = summary["groups"][group];
  Print[StringRiffle[{group, data["passed"], data["total"], data["nonzeroDifferenceCount"], If[data["firstFailure"] === None, "None", data["firstFailure"]["name"]]}, "|"]],
  {group, Keys[summary["groups"]]}
];
Print[StringRiffle[{"TOTAL", summary["passed"], summary["total"], summary["nonzeroDifferenceCount"], If[summary["firstFailure"] === None, "None", summary["firstFailure"]["name"]]}, "|"]];
failed = Select[result["checks"], ! TrueQ[#passed] &];
Print["FAILED_NAMES=" <> StringRiffle[(#["group"] <> ":" <> #["name"] &) /@ failed, ","]];
