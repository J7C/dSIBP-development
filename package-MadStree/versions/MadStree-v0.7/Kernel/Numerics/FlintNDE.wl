(* ::Package:: *)

(***
File: FlintNDE.wl
Purpose: Serializes the MadStree formula-type dlog connection along the anchor-to-target affine path into Q(i)(s), invokes the standalone FlintNDE backend, and restores the target column vector and refinement diagnostics as a Wolfram Association.
Scope: Only certified dlog, same-digest automatic boundaries and exact Gaussian-rational path data are accepted; floating-point denominator guessing is never performed.
***)

(* ::Chapter:: *)
(* Exact Q(i)(s) serialization *)

msGaussianRationalParts[value_] := Module[{real, imaginary},
  real = Together[ComplexExpand[Re[value]]];
  imaginary = Together[ComplexExpand[Im[value]]];
  If[! RationalQ[real] || ! RationalQ[imaginary], Return[$Failed]];
  {real, imaginary}
];

msGaussianRationalString[value_] := Module[{parts = msGaussianRationalParts[value]},
  If[parts === $Failed, Return[$Failed]];
  <|
    "real" -> ToString[parts[[1]], InputForm],
    "imag" -> ToString[parts[[2]], InputForm]
  |>
];

msPolynomialCoefficientStrings[polynomial_, parameter_Symbol] := Module[{degree, coefficients, strings},
  If[! PolynomialQ[polynomial, parameter], Return[$Failed]];
  degree = Exponent[polynomial, parameter];
  coefficients = If[polynomial === 0, {0}, CoefficientList[polynomial, parameter]];
  strings = msGaussianRationalString /@ coefficients;
  If[MemberQ[strings, $Failed], $Failed, strings]
];

msRationalFunctionRecord[expression_, parameter_Symbol] := Module[
  {rational = Cancel[Together[expression]], numerator, denominator, numeratorStrings, denominatorStrings},
  numerator = Numerator[rational];
  denominator = Denominator[rational];
  numeratorStrings = msPolynomialCoefficientStrings[numerator, parameter];
  denominatorStrings = msPolynomialCoefficientStrings[denominator, parameter];
  If[MemberQ[{numeratorStrings, denominatorStrings}, $Failed],
    $Failed,
    <|"numerator" -> numeratorStrings, "denominator" -> denominatorStrings|>
  ]
];

msRationalMatrixRecords[matrix_?MatrixQ, parameter_Symbol] := Module[{records},
  records = Map[msRationalFunctionRecord[#, parameter] &, matrix, {2}];
  If[! FreeQ[records, $Failed], $Failed, records]
];

msDecimalString[value_, digits_Integer] := StringReplace[
  ToString[N[value, digits], InputForm],
  {RegularExpression["`[0-9.]*"] -> "", "*^" -> "e"}
];

msParseDecimalString[text_String] := ToExpression[StringReplace[text, "e" -> "*^"]];

msComplexDecimalRecord[value_?NumericQ, digits_Integer] := <|
  "real" -> msDecimalString[Re[N[value, digits]], digits],
  "imag" -> msDecimalString[Im[N[value, digits]], digits]
|>;

(* On Windows the WolframScript kernel keeps the RunProcess symbol but does not execute it; Run returns an equally reliable exit code. *)
msCommandArgument[value_] := Module[{text = ToString[value]},
  If[StringContainsQ[text, WhitespaceCharacter],
    "\"" <> StringReplace[text, "\"" -> "\\\""] <> "\"",
    text
  ]
];

msCommandString[arguments_List] := StringRiffle[msCommandArgument /@ arguments, " "];


(* ::Chapter:: *)
(* Build the one-dimensional system along the affine kinematic path *)

msRuleValue[symbol_, rules_List] := symbol /. rules;

msAffineConnectionData[
  de_Association,
  anchorRules_List,
  targetRules_List,
  parameter_Symbol
] := Module[{symbols, unresolved, pathRules, constantRules, omega, connection, records},
  symbols = de["kinematicSymbols"];
  unresolved = Select[
    symbols,
    ! NumericQ[N[msRuleValue[#, anchorRules]]] || ! NumericQ[N[msRuleValue[#, targetRules]]] &
  ];
  If[unresolved =!= {}, Return[Failure["IncompleteKinematicPath", <|"symbols" -> unresolved|>]]];
  pathRules = Map[
    Function[symbol,
      symbol -> (msRuleValue[symbol, anchorRules] +
        parameter (msRuleValue[symbol, targetRules] - msRuleValue[symbol, anchorRules]))
    ],
    symbols
  ];
  constantRules = Select[targetRules, FreeQ[symbols, First[#]] &];
  omega = de["omegaPotential"] /. pathRules /. constantRules;
  connection = Map[Cancel[Together[D[#, parameter]]] &, omega, {2}];
  records = msRationalMatrixRecords[connection, parameter];
  If[records === $Failed,
    Return[Failure[
      "FlintNDEExactPathRequired",
      <|"reason" -> "connection coefficients are not in Q(i)(s)", "connection" -> connection|>
    ]]
  ];
  <|
    "parameter" -> parameter,
    "pathRules" -> pathRules,
    "constantRules" -> constantRules,
    "connection" -> connection,
    "matrixRecords" -> records
  |>
];


(* ::Chapter:: *)
(* Python backend invocation *)

(* By default the calling script directory is used; notebooks or interactive sessions without an input file fall back to the current working directory. *)
msDefaultRuntimeDirectory[] := msRuntimeDirectory[];


msResolveRuntimeDirectory[Automatic] := msDefaultRuntimeDirectory[];


(* Absolute paths are expanded directly; relative paths are always resolved against the calling script directory to avoid depending on the current process directory. *)
msAbsoluteRuntimePathQ[path_String] := msAbsolutePathQ[path];


msResolveRuntimeDirectory[path_String] := Module[{base = msDefaultRuntimeDirectory[]},
  ExpandFileName[If[msAbsoluteRuntimePathQ[path], path, FileNameJoin[{base, path}]]]
];
msResolveRuntimeDirectory[other_] := Failure[
  "RuntimeDirectoryRequired",
  <|"value" -> HoldForm[other]|>
];


(* JSON files exist only briefly in results_temp under the calling directory; they are deleted on success and kept with full diagnostics on failure. *)
msExecuteFlintNDEAdapter[inputData_Association, pythonExecutable_, runtimeDirectory_String] := Module[
  {transportDirectory, identifier, inputFile, outputFile, adapterFile,
   command, process, imported},
  transportDirectory = FileNameJoin[{runtimeDirectory, "results_temp", "flintnde_transport"}];
  If[! DirectoryQ[transportDirectory],
    CreateDirectory[transportDirectory, CreateIntermediateDirectories -> True]
  ];
  identifier = CreateUUID[];
  inputFile = FileNameJoin[{transportDirectory, "madstree-flintnde-input-" <> identifier <> ".json"}];
  outputFile = FileNameJoin[{transportDirectory, "madstree-flintnde-output-" <> identifier <> ".json"}];
  adapterFile = FileNameJoin[{$MadStreePackageDirectory, "Backend", "flintnde_transport.py"}];
  Export[inputFile, inputData, "RawJSON"];
  command = {
    pythonExecutable,
    adapterFile,
    inputFile,
    outputFile
  };
  process = <|
    "ExitCode" -> Run[msCommandString[command]],
    "Command" -> command,
    "runtimeDirectory" -> runtimeDirectory,
    "inputFile" -> inputFile,
    "outputFile" -> outputFile
  |>;
  If[! FileExistsQ[outputFile],
    Return[Failure["FlintNDEProcessFailed", <|"process" -> process|>]]
  ];
  imported = Import[outputFile, "RawJSON"];
  If[process["ExitCode"] =!= 0 || Lookup[imported, "status", None] =!= "success",
    Return[Failure["FlintNDEProcessFailed", <|"process" -> process, "backend" -> imported|>]]
  ];
  Quiet[DeleteFile /@ Select[{inputFile, outputFile}, FileExistsQ]];
  Join[imported, <|"process" -> KeyDrop[process, {"inputFile", "outputFile"}]|>]
];


msParseFlintVector[records_List] := Map[
  msParseDecimalString[#["real"]] + I msParseDecimalString[#["imag"]] &,
  records
];


(* ::Section:: *)
(* Unnamed save-point contract *)

(* Save-point coordinates must be exact Q(i) and the tag must be the literal "save"; triples are rejected before Python starts. *)
msSavePointListRecords[points_List] := Module[{records},
  If[! And @@ (MatchQ[#, {_, "save"}] & /@ points),
    Return[Failure[
      "FlintNDESavePointFormat",
      <|"expected" -> "{{coordinate, \"save\"}, ...}", "actual" -> HoldForm[points]|>
    ]]
  ];
  records = Map[
    Function[point,
      With[{coordinate = msGaussianRationalString[First[point]]},
        If[coordinate === $Failed, $Failed, <|"coordinate" -> coordinate, "tag" -> "save"|>]
      ]
    ],
    points
  ];
  If[MemberQ[records, $Failed],
    Return[Failure[
      "FlintNDESavePointExactCoordinateRequired",
      <|"points" -> HoldForm[points]|>
    ]]
  ];
  If[! DuplicateFreeQ[records],
    Return[Failure["FlintNDESavePointDuplicate", <|"points" -> HoldForm[points]|>]]
  ];
  records
];

msSavePointData[Automatic] := <|"singular" -> {}, "ordinary" -> {}|>;
msSavePointData[points_List] := Module[{ordinary = msSavePointListRecords[points]},
  If[Head[ordinary] === Failure, ordinary, <|"singular" -> {}, "ordinary" -> ordinary|>]
];
msSavePointData[stages_Association] := Module[{unknown, singular, ordinary},
  unknown = Complement[Keys[stages], {"singular", "ordinary"}];
  If[unknown =!= {}, Return[Failure["FlintNDESavePointStage", <|"unknownKeys" -> unknown|>]]];
  singular = msSavePointListRecords[Lookup[stages, "singular", {}]];
  If[Head[singular] === Failure, Return[singular]];
  ordinary = msSavePointListRecords[Lookup[stages, "ordinary", {}]];
  If[Head[ordinary] === Failure, Return[ordinary]];
  <|"singular" -> singular, "ordinary" -> ordinary|>
];
msSavePointData[other_] := Failure[
  "FlintNDESavePointFormat",
  <|"expected" -> "list or singular/ordinary Association", "actual" -> HoldForm[other]|>
];

(* The backend writes per-point files immediately; here we only merge the per-stage summaries after the whole chain succeeds. *)
msWriteSavePointAggregate[runDirectory_String, stageImports_List] := Module[
  {stageRecords, points, aggregateFile, payload},
  stageRecords = Flatten@Map[
    Function[stageImport,
      Map[
        Function[file,
          If[FileExistsQ[file],
            <|"stage" -> stageImport["stage"], "file" -> file,
              "summary" -> Import[file, "RawJSON"]|>,
            Nothing
          ]
        ],
        Lookup[stageImport["backend"], "savePointSummaryFiles", {}]
      ]
    ],
    stageImports
  ];
  If[stageRecords === {}, Return[Missing["NoSavePoints"]]];
  points = Flatten@Map[
    Function[record,
      Join[
        #,
        <|
          "stage" -> record["stage"],
          "sourceFile" -> FileNameJoin[{DirectoryName[record["file"]], Lookup[#, "file", ""]}]
        |>
      ] & /@ Lookup[record["summary"], "points", {}]
    ],
    stageRecords
  ];
  aggregateFile = FileNameJoin[{runDirectory, "madstree_flintnde_save_points.json"}];
  payload = <|
    "schema" -> "madstree_flintnde_saved_points_v1",
    "status" -> "complete",
    "pointCount" -> Length[points],
    "points" -> points,
    "stageSummaries" -> KeyDrop[#, "summary"] & /@ stageRecords
  |>;
  Export[aggregateFile, payload, "RawJSON"];
  <|"runDirectory" -> runDirectory, "summaryFile" -> aggregateFile, "points" -> points|>
];


(* Writes one exact normalized leading branch as the FlintNDE {a,b,C} contract. *)
msFrobeniusBranchRecord[branch_Association] := Module[{exponent, vector},
  exponent = msGaussianRationalString[branch["frobeniusExponent"]];
  vector = msGaussianRationalString /@ branch["normalizedLeadingVector"];
  If[exponent === $Failed || MemberQ[vector, $Failed], Return[$Failed]];
  <|
    "a" -> exponent,
    "b" -> branch["logPower"],
    "C" -> vector
  |>
];

Options[MSFlintNDETransport] = {
  PythonExecutable -> "python",
  MSRuntimeDirectory -> Automatic,
  FlintNDESavePoints -> Automatic,
  WorkingPrecision -> 50,
  TransportOrder -> 48,
  ReferenceTransportOrder -> 64,
  TargetRelativeError -> "1e-25"
};

MSFlintNDETransport[
  context_?MSContextQ,
  boundaryData_Association,
  opts : OptionsPattern[]
] := Module[
  {de, configuration, parameter, affineData, digits, inputData, imported, finalValues,
   boundaryKind, singularRecords, branchInputs, branchValues, branchWeights, anchorValues,
   singularImported, ordinaryBoundary, ordinaryImported, singularParameter, combinedBackend,
   runtimeDirectory, savePointData, saveRunDirectory, saveStageImports, savePointEvidence},
  de = MSDLogDE[context];
  If[Lookup[de, "dlogStatus", None] =!= "certifiedByFormulaChecks",
    Return[Failure["CertifiedDLogRequired", <||>]]
  ];
  If[Lookup[boundaryData, "status", None] =!= "generated" ||
     Lookup[boundaryData, "masterDigest", None] =!= de["masterDigest"],
    Return[Failure[
      "BoundaryMasterMismatch",
      <|"expectedDigest" -> de["masterDigest"], "actualDigest" -> Lookup[boundaryData, "masterDigest", Missing["Absent"]]|>
    ]]
  ];
  configuration = MSFlintNDEConfiguration[];
  If[! TrueQ[configuration["availableQ"]],
    Return[Failure["FlintNDENotAvailable", configuration]]
  ];
  digits = OptionValue[WorkingPrecision];
  runtimeDirectory = msResolveRuntimeDirectory[OptionValue[MSRuntimeDirectory]];
  If[Head[runtimeDirectory] === Failure, Return[runtimeDirectory]];
  If[msEnsureDirectory[runtimeDirectory] === $Failed,
    Return[Failure["RuntimeDirectoryCreationFailed", <|"path" -> runtimeDirectory|>]]
  ];
  savePointData = msSavePointData[OptionValue[FlintNDESavePoints]];
  If[Head[savePointData] === Failure, Return[savePointData]];
  saveRunDirectory = FileNameJoin[{
    runtimeDirectory, "results", "flintnde_save_points", "run-" <> CreateUUID[]
  }];
  saveStageImports = {};
  boundaryKind = Lookup[boundaryData, "boundaryKind", "finiteFrobeniusSeries"];
  ordinaryBoundary = boundaryData;
  singularImported = Missing["NotUsed"];
  If[boundaryKind === "singularFrobenius",
    singularParameter = boundaryData["singularParameter"];
    singularRecords = msRationalMatrixRecords[
      boundaryData["singularConnection"], singularParameter
    ];
    branchInputs = msFrobeniusBranchRecord /@ boundaryData["leadingBranches"];
    If[singularRecords === $Failed || MemberQ[branchInputs, $Failed],
      Return[Failure[
        "FlintNDEExactFrobeniusBoundaryRequired",
        <|"reason" -> "singular connection, exponent and normalized C must lie in Q(i)(t)"|>
      ]]
    ];
    inputData = <|
      "schema" -> "madstree_flintnde_singular_transport_v1",
      "backendPackagePath" -> configuration["resolvedPath"],
      "masterDigest" -> de["masterDigest"],
      "dimension" -> de["masterCount"],
      "variable" -> "t",
      "matrix" -> singularRecords,
      "branches" -> (<|"boundary" -> #|> & /@ branchInputs),
      "start" -> "0",
      "target" -> "1",
      "workingPrecisionDigits" -> digits,
      "primaryOrder" -> OptionValue[TransportOrder],
      "referenceOrder" -> OptionValue[ReferenceTransportOrder],
      "targetRelativeError" -> ToString[OptionValue[TargetRelativeError]],
      "savePoints" -> savePointData["singular"],
      "saveOutputDirectory" -> FileNameJoin[{saveRunDirectory, "singular"}],
      "columnVectorConvention" -> "Y'=A(t)Y",
      "dlogStatus" -> de["dlogStatus"]
    |>;
    singularImported = msExecuteFlintNDEAdapter[
      inputData, OptionValue[PythonExecutable], runtimeDirectory
    ];
    If[Head[singularImported] === Failure, Return[singularImported]];
    AppendTo[saveStageImports, <|"stage" -> "singular", "backend" -> singularImported|>];
    branchValues = msParseFlintVector[#["finalValues"]] & /@ singularImported["branchResults"];
    branchWeights = N[Lookup[boundaryData["leadingBranches"], "physicalWeight"], digits];
    If[Length[branchValues] =!= Length[branchWeights] || ! And @@ (NumericQ /@ Flatten[branchValues]),
      Return[Failure["FlintNDESingularBranchMismatch", <||>]]
    ];
    anchorValues = Total[MapThread[#1 #2 &, {branchWeights, branchValues}]];
    ordinaryBoundary = Join[
      boundaryData,
      <|"boundaryKind" -> "finiteFrobeniusMatchPoint", "values" -> anchorValues, "ordinaryAnchorQ" -> True|>
    ],
    If[! ListQ[Lookup[boundaryData, "values", None]] || Length[boundaryData["values"]] =!= de["masterCount"],
      Return[Failure["BoundaryVectorDimension", <|"expected" -> de["masterCount"]|>]]
    ]
  ];
  parameter = Unique["msPathParameter"];
  affineData = msAffineConnectionData[
    de, ordinaryBoundary["anchorRules"], ordinaryBoundary["targetRules"], parameter
  ];
  If[Head[affineData] === Failure, Return[affineData]];
  inputData = <|
    "schema" -> "madstree_flintnde_transport_v1",
    "backendPackagePath" -> configuration["resolvedPath"],
    "masterDigest" -> de["masterDigest"],
    "dimension" -> de["masterCount"],
    "variable" -> "s",
    "matrix" -> affineData["matrixRecords"],
    "boundary" -> (msComplexDecimalRecord[#, digits] & /@ ordinaryBoundary["values"]),
    "start" -> "0",
    "target" -> "1",
    "workingPrecisionDigits" -> digits,
    "primaryOrder" -> OptionValue[TransportOrder],
    "referenceOrder" -> OptionValue[ReferenceTransportOrder],
    "targetRelativeError" -> ToString[OptionValue[TargetRelativeError]],
    "savePoints" -> savePointData["ordinary"],
    "saveOutputDirectory" -> FileNameJoin[{saveRunDirectory, "ordinary"}],
    "columnVectorConvention" -> "Y'=A(s)Y",
    "dlogStatus" -> de["dlogStatus"]
  |>;
  ordinaryImported = msExecuteFlintNDEAdapter[
    inputData, OptionValue[PythonExecutable], runtimeDirectory
  ];
  If[Head[ordinaryImported] === Failure, Return[ordinaryImported]];
  AppendTo[saveStageImports, <|"stage" -> "ordinary", "backend" -> ordinaryImported|>];
  finalValues = msParseFlintVector[ordinaryImported["finalValues"]];
  combinedBackend = If[
    Head[singularImported] === Missing,
    ordinaryImported,
    Join[
      <|
        "schema" -> "madstree_flintnde_singular_then_ordinary_v1",
        "targetRelativeErrorMet" -> TrueQ[singularImported["targetRelativeErrorMet"]] &&
          TrueQ[ordinaryImported["targetRelativeErrorMet"]]
      |>,
      KeyTake[
        ordinaryImported,
        {"relativeDifferenceInf", "relativeDifferenceMidpoint", "targetRelativeError",
         "primarySeconds", "referenceSeconds"}
      ],
      <|
        "singularLaunch" -> singularImported,
        "ordinaryTransport" -> ordinaryImported
      |>
    ]
  ];
  savePointEvidence = msWriteSavePointAggregate[saveRunDirectory, saveStageImports];
  <|
    "status" -> "computed",
    "masters" -> de["masters"],
    "masterDigest" -> de["masterDigest"],
    "values" -> finalValues,
    "boundary" -> ordinaryBoundary,
    "pathRules" -> affineData["pathRules"],
    "connectionAlongPath" -> affineData["connection"],
    "flintNDE" -> combinedBackend,
    "backendConfiguration" -> configuration,
    "runtimeDirectory" -> runtimeDirectory,
    "savePoints" -> savePointEvidence,
    "columnVectorConvention" -> "Y'=A(s)Y"
  |>
];

MSFlintNDETransport[___] := Failure["InitializedContextRequired", <|"function" -> "MSFlintNDETransport"|>];


(* ::Chapter:: *)
(* End-to-end public entry *)

Options[MSEvaluateTree] = DeleteDuplicatesBy[
  Join[Options[MSBoundaryData], Options[MSFlintNDETransport]],
  First
];

MSEvaluateTree[
  context_?MSContextQ,
  targetRules_,
  opts : OptionsPattern[]
] := Module[{boundary, result},
  boundary = MSBoundaryData[
    context,
    targetRules,
    Sequence @@ FilterRules[{opts}, Options[MSBoundaryData]]
  ];
  If[Head[boundary] === Failure, Return[boundary]];
  result = MSFlintNDETransport[
    context,
    boundary,
    Sequence @@ FilterRules[{opts}, Options[MSFlintNDETransport]]
  ];
  result
];

MSEvaluateTree[___] := Failure["InitializedContextRequired", <|"function" -> "MSEvaluateTree"|>];

Options[MSEvaluateVertexFamily] = Options[MSEvaluateTree];

MSEvaluateVertexFamily[
  context_?MSContextQ /; Lookup[context, "contextKind", "tree"] === "vertexFamily",
  targetRules_,
  opts : OptionsPattern[]
] := MSEvaluateTree[context, targetRules, opts];

MSEvaluateVertexFamily[context_?MSContextQ, ___] := Failure[
  "VertexFamilyContextRequired",
  <|"contextKind" -> Lookup[context, "contextKind", "tree"]|>
];

MSEvaluateVertexFamily[___] := Failure[
  "InitializedContextRequired",
  <|"function" -> "MSEvaluateVertexFamily"|>
];
