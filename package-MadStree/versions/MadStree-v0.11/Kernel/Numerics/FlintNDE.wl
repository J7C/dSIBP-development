(* ::Package:: *)

(***
文件：FlintNDE.wl
用途：为单阶段 MSEvaluatePath 提供 exact 序列化、运行目录、缓存和后端进程调用。
范围：本模块不选择输运节点、不构造路径计划，也不保存或恢复计划对象。
***)

(* ::Chapter:: *)
(* Exact Q(i)(s) serialization *)

(* Exact algebraic constants like (-1)^(1/3) appear in dlog residue matrices;
   RootReduce turns them into Root objects that ComplexExpand resolves into
   explicit a+b I components, so the serialized strings stay parseable Q(i)
   literals on the Python side. *)
msGaussianRationalParts[value_] := Module[{real, imaginary},
  real = Together[ComplexExpand[Re[RootReduce[value]]]];
  imaginary = Together[ComplexExpand[Im[RootReduce[value]]]];
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

(* Along the affine path every certified dlog letter is alpha+beta s, so
   d Log[letter]/ds = beta/(alpha+beta s) is a simple pole at -alpha/beta with
   residue equal to the letter matrix itself; the backend merges coincident
   poles. Letters with beta==0 contribute nothing and are skipped. *)
msAffineLetterRecord[letter_, letterMatrix_, pathRules_List, constantRules_List, parameter_Symbol] := Module[
  {along, alpha, beta, alphaRecord, betaRecord, residueRecord},
  along = Simplify[letter /. pathRules /. constantRules];
  If[! PolynomialQ[along, parameter] || Exponent[along, parameter] > 1, Return[$Failed]];
  alpha = Together[along /. parameter -> 0];
  beta = Together[Coefficient[along, parameter, 1]];
  If[alpha === 0, Return[$Failed]];
  If[beta === 0, Return[<|"skipped" -> True|>]];
  alpha = RootReduce[alpha];
  beta = RootReduce[beta];
  alphaRecord = msGaussianRationalString[alpha];
  betaRecord = msGaussianRationalString[beta];
  (* The residue matrix is the constant letter matrix; the same non-kinematic
     parameter substitution used for the letter must be applied before
     serialization, otherwise time powers such as a leak into the payload. *)
  residueRecord = Map[msGaussianRationalString, Together[letterMatrix /. constantRules], {2}];
  If[alphaRecord === $Failed || betaRecord === $Failed || ! FreeQ[residueRecord, $Failed],
    $Failed,
    <|"alpha" -> alphaRecord, "beta" -> betaRecord, "residue" -> residueRecord|>
  ]
];

msAffineLetterData[
  de_Association,
  anchorRules_List,
  targetRules_List,
  parameter_Symbol
] := Module[{
  symbols, unresolved, pathRules, constantRules, omega, connection, letters,
  records, record
},
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
  letters = de["letters"];
  records = {};
  Do[
    record = msAffineLetterRecord[
      letter, de["letterMatrices"][letter], pathRules, constantRules, parameter
    ];
    If[record === $Failed,
      Return[Failure[
        "FlintNDEExactPathRequired",
        <|"reason" -> "dlog letter is not affine with Q(i) data along the path",
          "letter" -> letter|>
      ]]
    ];
    If[! TrueQ[Lookup[record, "skipped", False]], AppendTo[records, record]],
    {letter, letters}
  ];
  <|
    "parameter" -> parameter,
    "pathRules" -> pathRules,
    "constantRules" -> constantRules,
    "connection" -> connection,
    "letterRecords" -> records
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


(* 为参与缓存的源码生成固定宽度 SHA-256；文件缺失也进入身份记录，
   避免失败配置与某个既有成功缓存发生碰撞。 *)
msFlintNDESourceDigestRecord[label_String, file_String] := <|
  "file" -> label,
  "sha256" -> If[
    FileExistsQ[file],
    IntegerString[FileHash[file, "SHA256"], 16, 64],
    "missing"
  ]
|>;


(* 缓存必须同时绑定 MadStree adapter 与实际 FlintNDE 源码。这样即使版本号
   不变，原位修复也会自动生成新缓存目录，不会复用与当前源码身份不匹配的序列化计划。 *)
msFlintNDEBackendSourceIdentity[inputData_Association] := Module[{
  adapterFile, backendRoot, packageFile, moduleDirectory, moduleFiles
},
  adapterFile = FileNameJoin[{
    $MadStreePackageDirectory, "Backend", "flintnde_transport.py"
  }];
  backendRoot = Lookup[inputData, "backendPackagePath", Missing["Absent"]];
  If[! StringQ[backendRoot],
    Return[{
      msFlintNDESourceDigestRecord["Backend/flintnde_transport.py", adapterFile],
      <|"file" -> "FlintNDE", "sha256" -> "missing-backend-path"|>
    }]
  ];
  backendRoot = ExpandFileName[backendRoot];
  packageFile = FileNameJoin[{backendRoot, "pyproject.toml"}];
  moduleDirectory = FileNameJoin[{backendRoot, "flintnde"}];
  moduleFiles = If[
    DirectoryQ[moduleDirectory],
    Sort[FileNames["*.py", moduleDirectory]],
    {}
  ];
  Join[
    {
      msFlintNDESourceDigestRecord["Backend/flintnde_transport.py", adapterFile],
      msFlintNDESourceDigestRecord["FlintNDE/pyproject.toml", packageFile]
    },
    msFlintNDESourceDigestRecord[
      "FlintNDE/flintnde/" <> FileNameTake[#], #
    ] & /@ moduleFiles
  ]
];


(* 后端成功输出缓存在调用脚本旁的 flintnde_cache/<digest>/。缓存键包含
   去除保存目录后的请求和后端源码身份；失败输出永不作为缓存命中。 *)
msFlintNDECacheDirectory[runtimeDirectory_String, inputData_Association] := Module[{
  stablePayload, sourceIdentity, digest
},
  sourceIdentity = msFlintNDEBackendSourceIdentity[inputData];
  stablePayload = Append[
    KeyDrop[inputData, {"backendPackagePath"}],
    "backendSourceIdentity" -> sourceIdentity
  ];
  digest = IntegerString[
    Hash[ExportString[stablePayload, "RawJSON"], "SHA256"], 16, 64
  ];
  FileNameJoin[{runtimeDirectory, "flintnde_cache", digest}]
];


(* The backend interpreter is resolved without any filesystem probing: an
   explicit PythonExecutable string is used verbatim, Automatic honours the
   MADSTREE_PYTHON environment variable when it is set and non-empty, and
   otherwise the bare "python" command from PATH is used. Installing a
   suitable interpreter and keeping it reachable is the user's responsibility. *)
msResolvePythonExecutable[executable_String] := executable;


msResolvePythonExecutable[Automatic] := With[{override = Quiet[Environment["MADSTREE_PYTHON"]]},
  If[StringQ[override] && StringLength[StringTrim[override]] > 0,
    StringTrim[override],
    "python"
  ]
];


(* Truncate captured backend output so failure messages stay readable. *)
msBackendLogTail[file_String] := Module[{text},
  If[! FileExistsQ[file], Return["<no backend output captured>"]];
  text = Import[file, "Text", CharacterEncoding -> "UTF-8"];
  If[StringLength[text] > 2000, "..." <> StringTake[text, -2000], text]
];


msExecuteFlintNDEAdapter[inputData_Association, pythonExecutable_, runtimeDirectory_String] := Module[
  {cacheDirectory, cacheFile, cached, transportDirectory, identifier, inputFile,
   adapterFile, logFile, command, commandText, process, imported, logTail},
  cacheDirectory = msFlintNDECacheDirectory[runtimeDirectory, inputData];
  cacheFile = FileNameJoin[{cacheDirectory, "backend_output.json"}];
  If[FileExistsQ[cacheFile],
    cached = Import[cacheFile, "RawJSON"];
    If[AssociationQ[cached] && Lookup[cached, "status", None] === "success",
      Return[Join[cached, <|"cacheHit" -> True, "cacheDirectory" -> cacheDirectory|>]]
    ]
  ];
  If[! DirectoryQ[cacheDirectory],
    CreateDirectory[cacheDirectory, CreateIntermediateDirectories -> True]
  ];
  transportDirectory = FileNameJoin[{runtimeDirectory, "results_temp", "flintnde_transport"}];
  If[! DirectoryQ[transportDirectory],
    CreateDirectory[transportDirectory, CreateIntermediateDirectories -> True]
  ];
  identifier = CreateUUID[];
  inputFile = FileNameJoin[{transportDirectory, "madstree-flintnde-input-" <> identifier <> ".json"}];
  (* Backend stdout/stderr is captured so a failed launch reports the actual
     Python error instead of leaving it on the console. *)
  logFile = FileNameJoin[{transportDirectory, "madstree-flintnde-log-" <> identifier <> ".txt"}];
  adapterFile = FileNameJoin[{$MadStreePackageDirectory, "Backend", "flintnde_transport.py"}];
  (* v0.11 唯一 evaluate schema 的字段集合由 Python 端严格校验。 *)
  Export[inputFile, inputData, "RawJSON"];
  command = {
    pythonExecutable,
    adapterFile,
    inputFile,
    cacheFile
  };
  commandText = "set PYTHONIOENCODING=utf-8&& " <> msCommandString[command] <>
    " > " <> msCommandArgument[logFile] <> " 2>&1";
  process = <|
    "ExitCode" -> Run[commandText],
    "Command" -> command,
    "runtimeDirectory" -> runtimeDirectory,
    "inputFile" -> inputFile,
    "cacheFile" -> cacheFile,
    "logFile" -> logFile
  |>;
  logTail = msBackendLogTail[logFile];
  If[! FileExistsQ[cacheFile],
    Message[MSEvaluatePath::backendLaunchFailed, pythonExecutable, logTail];
    Return[Failure["FlintNDEProcessFailed", <|"process" -> process, "stderr" -> logTail|>]]
  ];
  imported = Import[cacheFile, "RawJSON"];
  (* A structured refusal (no-singularity mode found a pole on the polyline,
     or the leading-order local basis cannot be built, e.g. resonance) is an
     outcome, not a backend failure: it is returned verbatim with cacheHit
     False and never cached as a success. *)
  If[MemberQ[{"singularPathRefused", "leadingOrderRefused"}, Lookup[imported, "status", None]],
    Quiet[DeleteFile /@ Select[{inputFile, logFile}, FileExistsQ]];
    Return[Join[imported, <|"cacheHit" -> False, "cacheDirectory" -> cacheDirectory|>]]
  ];
  If[process["ExitCode"] =!= 0 || Lookup[imported, "status", None] =!= "success",
    Message[MSEvaluatePath::backendRunFailed, pythonExecutable, Lookup[imported, "error", logTail]];
    Return[Failure["FlintNDEProcessFailed", <|"process" -> process, "backend" -> imported, "stderr" -> logTail|>]]
  ];
  Quiet[DeleteFile /@ Select[{inputFile, logFile}, FileExistsQ]];
  Join[imported, <|"cacheHit" -> False, "cacheDirectory" -> cacheDirectory,
    "process" -> KeyDrop[process, {"inputFile", "cacheFile"}]|>]
];


msParseFlintVector[records_List] := Map[
  msParseDecimalString[#["real"]] + I msParseDecimalString[#["imag"]] &,
  records
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
