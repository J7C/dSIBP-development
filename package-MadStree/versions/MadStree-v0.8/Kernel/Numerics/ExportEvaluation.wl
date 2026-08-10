(* ::Package:: *)

(***
File: ExportEvaluation.wl
Purpose: Exports multi-point numerical evaluation data (point coordinates and master values) to CSV and JSON
         for downstream plotting tools.
Scope: Consumes only the result associations returned by MSEvaluateTree or MSFlintNDETransport; it does not
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
  points_List,
  results_List,
  opts : OptionsPattern[]
] := Module[
  {outputDirectory, formats, digits, variableSymbols, masterCount, header,
   rows, jsonPayload, csvFile, jsonFile, statuses, relativeDifferences, metQ, files},
  If[Length[points] =!= Length[results],
    Return[Failure[
      "PointResultMismatch",
      <|"pointCount" -> Length[points], "resultCount" -> Length[results]|>
    ]]
  ];
  If[points === {} || ! MatchQ[results, {_Association ..}],
    Return[Failure["InvalidExportInput", <|"points" -> points, "results" -> results|>]]
  ];
  If[! ListQ[Lookup[First[results], "values", None]],
    Return[Failure["InvalidResults", <|"expected" -> "result associations with a values list"|>]]
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
  "InitializedContextRequired",
  <|"function" -> "MSExportEvaluationData"|>
];
