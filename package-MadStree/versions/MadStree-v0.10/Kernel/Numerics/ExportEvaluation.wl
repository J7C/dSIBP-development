(* ::Package:: *)

(***
File: ExportEvaluation.wl
Purpose: Exports multi-point numerical evaluation data (point coordinates and master values) to CSV and JSON
         for downstream plotting tools.
Scope: Consumes only point/result records from MSEvaluatePlannedPath; it does not
       rerun transports or guess physical conventions.
***)

(* ::Chapter:: *)
(* Public export entry *)

Options[MSExportEvaluationData] = {
  MSOutputDirectory -> Automatic,
  ExportFormats -> Automatic,
  SignificantDigits -> 16
};


(* ::Chapter:: *)
(* Path and record helpers *)

msExportResolveDirectory[Automatic] := FileNameJoin[{
  msRuntimeDirectory[],
  "results",
  "madstree_evaluation",
  "run-" <> CreateUUID[]
}];

msExportResolveDirectory[path_String] := ExpandFileName[
  If[msAbsolutePathQ[path],
    path,
    FileNameJoin[{msRuntimeDirectory[], path}]
  ]
];

msExportResolveDirectory[value_] := Failure[
  "OutputDirectoryRequired",
  <|"expected" -> "Automatic or a path string", "actual" -> HoldForm[value]|>
];


msExportComplexRecord[value_?NumericQ, digits_Integer] := <|
  "real" -> N[Re[value], digits],
  "imag" -> N[Im[value], digits]
|>;

msExportComplexRecord[value_, digits_Integer] := <|"real" -> "NonNumeric", "imag" -> "NonNumeric"|>;

msExportRelativeDifference[result_Association] := ToString[
  Lookup[
    Lookup[result, "flintNDE", <||>],
    "relativeDifferenceInf",
    Missing["Unavailable"]
  ],
  InputForm
];


(* ::Chapter:: *)
(* Public export *)

MSExportEvaluationData[
  evaluation_Association,
  opts : OptionsPattern[]
] := Module[
  {pointRecords, points, results, outputDirectory, formats, digits, variableSymbols,
   masterCount, header, rows, jsonPayload, csvFile, jsonFile, statuses,
   relativeDifferences, metQ, files},
  If[Lookup[evaluation, "status", None] =!= "computed",
    Return[Failure[
      "ComputedEvaluationRequired",
      <|"status" -> Lookup[evaluation, "status", Missing["Absent"]]|>
    ]]
  ];
  (* 只导出执行结果中的已保存常点；临时点、被移除的奇点和 LO 记录不冒充数值结果。 *)
  pointRecords = Select[
    Lookup[evaluation, "pointResults", {}],
    AssociationQ[#] && Lookup[#, "status", None] === "saved" &&
      ListQ[Lookup[#, "value", None]] &
  ];
  If[pointRecords === {},
    Return[Failure["SavedPointResultsRequired", <||>]]
  ];
  points = Lookup[pointRecords, "coordinate"];
  results = Map[
    <|
      "values" -> #["value"],
      "status" -> #["status"],
      "flintNDE" -> Lookup[evaluation, "flintNDE", <||>]
    |> &,
    pointRecords
  ];

  outputDirectory = msExportResolveDirectory[OptionValue[MSOutputDirectory]];
  If[Head[outputDirectory] === Failure, Return[outputDirectory]];
  If[msEnsureDirectory[outputDirectory] === $Failed,
    Return[Failure["OutputDirectoryCreationFailed", <|"path" -> outputDirectory|>]]
  ];

  digits = OptionValue[SignificantDigits];
  If[! IntegerQ[digits] || digits < 2,
    Return[Failure["InvalidSignificantDigits", <|"value" -> digits|>]]
  ];
  formats = Switch[OptionValue[ExportFormats],
    Automatic, {"CSV", "JSON"},
    "CSV", {"CSV"},
    "JSON", {"JSON"},
    list_List, DeleteDuplicates@Select[list, MemberQ[{"CSV", "JSON"}, #] &],
    _, {"CSV"}
  ];
  If[formats === {},
    Return[Failure["InvalidExportFormats", <|"value" -> OptionValue[ExportFormats]|>]]
  ];

  variableSymbols = DeleteDuplicates[Flatten[
    Cases[#, Rule[left_Symbol, _] :> left, Infinity] & /@ points
  ]];
  masterCount = Length[Lookup[First[results], "values"]];
  statuses = Lookup[results, "status"];
  relativeDifferences = msExportRelativeDifference /@ results;
  metQ = TrueQ /@ Lookup[Lookup[results, "flintNDE", <||>], "targetRelativeErrorMet"];

  rows = MapThread[
    Function[{point, result},
      Join[
        Flatten[
          Map[
            Function[symbol,
              With[{record = msExportComplexRecord[symbol /. point, digits]},
                {record["real"], record["imag"]}
              ]
            ],
            variableSymbols
          ]
        ],
        Flatten[
          Map[
            Function[value,
              With[{record = msExportComplexRecord[value, digits]},
                {record["real"], record["imag"]}
              ]
            ],
            result["values"]
          ]
        ],
        {ToString[Lookup[result, "status", Missing["Unavailable"]]],
         msExportRelativeDifference[result],
         ToString[TrueQ[Lookup[Lookup[result, "flintNDE", <||>], "targetRelativeErrorMet"]]]}
      ]
    ],
    {points, results}
  ];

  header = Join[
    Flatten[Map[Function[symbol, {SymbolName[symbol] <> "_re", SymbolName[symbol] <> "_im"}], variableSymbols]],
    Flatten[Table[{("M" <> ToString[index] <> "_re"), ("M" <> ToString[index] <> "_im")}, {index, masterCount}]],
    {"status", "relativeDifferenceInf", "targetRelativeErrorMet"}
  ];

  csvFile = FileNameJoin[{outputDirectory, "evaluation_data.csv"}];
  jsonFile = FileNameJoin[{outputDirectory, "evaluation_data.json"}];
  files = Join[
    If[MemberQ[formats, "CSV"], {csvFile}, {}],
    If[MemberQ[formats, "JSON"], {jsonFile}, {}]
  ];

  If[MemberQ[formats, "CSV"],
    Export[csvFile, Prepend[rows, header], "CSV"]
  ];

  jsonPayload = <|
    "schema" -> "madstree_evaluation_data_v1",
    "pointCount" -> Length[points],
    "masterCount" -> masterCount,
    "digits" -> digits,
    "variables" -> (SymbolName /@ variableSymbols),
    "points" -> Map[
      Function[point,
        AssociationThread[
          SymbolName /@ variableSymbols,
          Map[msExportComplexRecord[# /. point, digits] &, variableSymbols]
        ]
      ],
      points
    ],
    "values" -> Map[
      Function[result, Map[msExportComplexRecord[#, digits] &, result["values"]]],
      results
    ],
    "statuses" -> statuses,
    "relativeDifferenceInf" -> relativeDifferences,
    "targetRelativeErrorMet" -> metQ
  |>;
  If[MemberQ[formats, "JSON"],
    Export[jsonFile, jsonPayload, "JSON"]
  ];

  <|
    "status" -> "written",
    "outputDirectory" -> outputDirectory,
    "files" -> files,
    "formats" -> formats,
    "pointCount" -> Length[points],
    "masterCount" -> masterCount
  |>
];

MSExportEvaluationData[___] := Failure[
  "ComputedEvaluationRequired",
  <|"function" -> "MSExportEvaluationData"|>
];
