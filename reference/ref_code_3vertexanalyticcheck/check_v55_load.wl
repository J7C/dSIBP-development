$HistoryLength = 0;
baseDirectory = DirectoryName[$InputFileName];
sourceFile = FileNameJoin[{baseDirectory, "001_dsde3vertex_v5.5.wl"}];
pythonEnvironment = Environment["PYTHON"];
pythonExecutable = If[
  StringQ[pythonEnvironment] && StringLength[pythonEnvironment] > 0,
  pythonEnvironment,
  FileNameJoin[{baseDirectory, "venv", "Scripts", "python.exe"}]
];
pythonModuleEnvironment = Environment["V55_PYTHON_MODULE"];
pythonModule = If[
  StringQ[pythonModuleEnvironment] && StringLength[pythonModuleEnvironment] > 0,
  pythonModuleEnvironment,
  FileNameJoin[{baseDirectory, "pyflint_e2_transport.py"}]
];
artifactDirectoryEnvironment = Environment["V55_ARTIFACT_DIRECTORY"];
artifactDirectory = If[
  StringQ[artifactDirectoryEnvironment] &&
    StringLength[artifactDirectoryEnvironment] > 0,
  artifactDirectoryEnvironment,
  FileNameJoin[{baseDirectory, "smoke_artifacts"}]
];
sourceText = Import[sourceFile, "Text", CharacterEncoding -> "UTF8"];
If[StringTake[sourceText, UpTo[1]] === FromCharacterCode[{65279}],
  sourceText = StringDrop[sourceText, 1]
];
sourceText = StringReplace[sourceText, "v55RunNow = True;" -> "v55RunNow = False;"];
ToExpression[sourceText, InputForm];

failures = {};
check[label_String, condition_] := If[
  TrueQ[condition], Print["PASS: ", label],
  AppendTo[failures, label]; Print["FAIL: ", label]
];

check["V5.5 source parses", NameQ["V55RunLiteratureSoftLimit"]];
check[
  "production q waypoint multiplier is 2/3",
  ("WaypointMultiplier" /. Options[V55RunLiteratureSoftLimit]) === 2/3
];
check[
  "true-infinity boundary waypoint multiplier remains 4/5",
  ("BoundaryWaypointMultiplier" /. Options[V55RunLiteratureSoftLimit]) === 4/5
];
check[
  "scale-aware Frobenius start defaults to 1/320",
  ("SeriesSafetyFactor" /.
    Options[XYZZSolveProjectBranchE2PyFlintFrobenius]) === 1/320
];
check[
  "release result is labelled V5.5",
  StringContainsQ[sourceText, "\"Version\" -> \"5.5\""]
];
check[
  "canonical 25D sector order is unchanged",
  StringContainsQ[
    sourceText,
    "\"Top:16\", \"LeftPinch:4\", \"RightPinch:4\", \"DoublePinch:1\""
  ]
];
check[
  "PyFLINT Gamma-2F1 seed backend is present",
  NameQ["XYZZProjectRawOneVertexVectorPyFlint"]
];

seed = XYZZProjectRawOneVertexVectorPyFlint[
  3/2 + I, 1, 10/99,
  {<|"Kind" -> "H2", "Nu" -> I, "Momentum" -> 1/10|>},
  "WorkingPrecision" -> 60,
  "PythonExecutable" -> pythonExecutable,
  "PythonModule" -> pythonModule,
  "ArtifactDirectory" -> artifactDirectory
];
Print["ONE_VERTEX_SEED_RESULT=", InputForm[seed]];
check[
  "one-leg seed returns the unchanged raw 2-vector order",
  VectorQ[seed, NumericQ] && Length[seed] === 2
];

If[failures === {},
  Print["ALL V5.5 LOAD TESTS PASSED"]; Exit[0],
  Print["FAILED TESTS: ", failures]; Exit[1]
];
