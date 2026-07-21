(* ::Package:: *)
(* 012 P,Q,T,W 函数系统编译层的独立小型检查。 *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "012_dS_ibp_general.wl"}]];

pref = (4 I/Pi) Exp[Pi Im[nuM]];
expectedAh = {{0, 1}, {-1, -(2 nuM + 1)/x}};
expectedAH = {{0, 1}, {nuM^2/x^2 - 1, -1/x}};
expectedWh = -pref x^(-2 nuM - 1);
expectedWH = -pref/x;

defaultCase = <|
   "name" -> "defaultHFunctionSystem",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "nu" -> nuM, "massType" -> "massive"|>
     },
   "loopMomenta" -> {q},
   "externalMomenta" -> {},
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "seedPreset" -> "quickCheck"
   |>;

hTopo = parseTopology[defaultCase];
hCompiled = hTopo["lines"][[1, "compiledFunctionSystem"]];

hExplicit = compileFunctionSystem[<|
    "variable" -> x,
    "P" -> (2 nuM + 1)/x,
    "Q" -> 1,
    "W" -> expectedWh,
    "WT" -> expectedWh
    |>];

hankelSpec = <|
   "variable" -> x,
   "P" -> 1/x,
   "Q" -> 1 - nuM^2/x^2,
   "T" -> IdentityMatrix[2],
   "W" -> expectedWH,
   "WT" -> Automatic,
   "shrinkBShift" -> 1,
   "shrinkZeroPointShift" -> 0
   |>;
hankelCompiled = compileFunctionSystem[hankelSpec];

customHCase = ReplacePart[
   defaultCase,
   {"lineData", 1} -> Join[
     defaultCase["lineData"][[1]],
     <|"bbType" -> "customH", "functionSystem" -> hankelSpec|>
     ]
   ];
customHTopo = parseTopology[customHCase];
customHCompiled = customHTopo["lines"][[1, "compiledFunctionSystem"]];

tHtoh = x^(-nuM) {{1, 0}, {-nuM/x, 1}};
transformedCompiled = compileFunctionSystem[Join[
    hankelSpec,
    <|
     "T" -> tHtoh,
     "WT" -> expectedWh,
     "shrinkZeroPointShift" -> 2 nuM
     |>
    ]];

badWT = compileFunctionSystem[Join[hankelSpec, <|"WT" -> 2 expectedWH|>]];
singularT = compileFunctionSystem[Join[hankelSpec, <|"T" -> {{1, 0}, {0, 0}}|>]];
badLineCase = ReplacePart[
   defaultCase,
   {"lineData", 1} -> Join[
     defaultCase["lineData"][[1]],
     <|"bbType" -> "bad", "functionSystem" -> Join[hankelSpec, <|"T" -> {{1, 0}, {0, 0}}|>]|>
     ]
   ];
badLineTopology = Quiet[parseTopology[badLineCase], parseTopology::badfunction];
nonLaurent = compileFunctionSystem[<|
    "variable" -> x,
    "P" -> -1/(1 + x),
    "Q" -> 1,
    "W" -> 1 + x
    |>];

hRow1 = Select[hCompiled["derivativeTerms"], #["sourceState"] === 1 &];
hankelRow1 = Select[hankelCompiled["derivativeTerms"], #["sourceState"] === 1 &];

checks = <|
   "default h compiles" -> (hCompiled["status"] === "compiled"),
   "default preset is h" -> (hCompiled["input", "preset"] === "h"),
   "default T is identity" -> (hCompiled["T"] === IdentityMatrix[2]),
   "default AT is h" -> TrueQ[FullSimplify[hCompiled["AT"] == expectedAh]],
   "default W is h W" -> TrueQ[FullSimplify[hCompiled["W"] == expectedWh]],
   "default WT equals h W" -> TrueQ[FullSimplify[hCompiled["WT"] == expectedWh]],
   "default h zero-point shift" -> TrueQ[FullSimplify[hCompiled["shrinkZeroPointShift"] == 2 nuM]],
   "default h shrink coefficient" -> TrueQ[FullSimplify[hCompiled["shrinkTerms"][[1, "coefficient"]] == pref]],
   "explicit h WT accepted" -> (hExplicit["status"] === "compiled"),
   "h derivative row compiled" -> (Length[hRow1] === 2 && Sort[Lookup[hRow1, "xPower"]] === {-1, 0}),
   "H compiles" -> (hankelCompiled["status"] === "compiled"),
   "H AT has quadratic pole" -> TrueQ[FullSimplify[hankelCompiled["AT"] == expectedAH]],
   "H W and WT" -> TrueQ[FullSimplify[hankelCompiled["W"] == expectedWH && hankelCompiled["WT"] == expectedWH]],
   "H zero-point shift" -> (hankelCompiled["shrinkZeroPointShift"] === 0),
   "H derivative x^-2 term" -> AnyTrue[
     hankelRow1,
     #["targetState"] === 0 && #["xPower"] === -2 && TrueQ[FullSimplify[#["coefficient"] == nuM^2]] &
     ],
   "line-local custom H compiles" -> TrueQ[customHCompiled["status"] === "compiled" && FullSimplify[customHCompiled["AT"] == expectedAH]],
   "H to h transformed AT" -> TrueQ[FullSimplify[transformedCompiled["AT"] == expectedAh]],
   "H to h transformed WT" -> TrueQ[FullSimplify[transformedCompiled["WT"] == expectedWh]],
   "bad explicit WT rejected" -> MemberQ[Lookup[badWT, "issues", {}][[All, "code"]], "functionSystemWTInconsistent"],
   "singular T rejected" -> MemberQ[Lookup[singularT, "issues", {}][[All, "code"]], "functionSystemTSingular"],
   "invalid line system blocks topology" -> (badLineTopology === $Failed),
   "non-Laurent derivative rejected" -> MemberQ[Lookup[nonLaurent, "issues", {}][[All, "code"]], "functionSystemDerivativeNotFiniteLaurent"]
   |>;

Print["012 function-system checks: ", Count[Values[checks], True], "/", Length[checks]];
Print[Select[checks, ! TrueQ[#] &]];
If[! TrueQ[checks["h derivative row compiled"]], Print["h row1 diagnostic: ", InputForm[hRow1]]];
If[! TrueQ[checks["non-Laurent derivative rejected"]], Print["non-Laurent diagnostic: ", InputForm[nonLaurent]]];

If[! And @@ Values[checks], Exit[1]];
