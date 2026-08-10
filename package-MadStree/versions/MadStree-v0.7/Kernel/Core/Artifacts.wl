(* ::Package:: *)

(***
File: Artifacts.wl
Purpose: Aggregates and writes all-sector master integrals, recurrence metadata and the dlog DE of a MadStree context.
Scope: This module only serializes the results of the existing formula producers; it does not generate IBP equations or derive differential operators.
***)

(* ::Chapter:: *)
(* All-sector formula data *)

(* timePowerRules are substituted uniformly only in the final formula data; the sector/master identities frozen in the context remain unchanged. *)
msFormulaTimePowerSymbols[context_?MSContextQ] := DeleteDuplicates@Cases[
  Lookup[context["vertices"], "timePower", {}],
  symbol_Symbol /; Context[symbol] =!= "System`",
  Infinity
];


msFormulaTimePowerRules[Automatic] := {};
msFormulaTimePowerRules[rules_List] /; And @@ (MatchQ[#, _Rule | _RuleDelayed] & /@ rules) := rules;
msFormulaTimePowerRules[value_] := Failure[
  "TimePowerRulesRequired",
  <|"expected" -> "Automatic or a list of rules", "actual" -> HoldForm[value]|>
];


Options[MSFormulaData] = {TimePowerRules -> Automatic};


MSFormulaData[context_?MSContextQ, OptionsPattern[]] := Module[
  {rules, recurrenceMetadata, de, rawData, substitutedData},
  rules = msFormulaTimePowerRules[OptionValue[TimePowerRules]];
  If[Head[rules] === Failure, Return[rules]];
  recurrenceMetadata = Association@Table[
    sectorKey -> MSFormulaMatrices[context, sectorKey],
    {sectorKey, context["sectorOrder"]}
  ];
  If[! FreeQ[Values[recurrenceMetadata], _Failure],
    Return[Failure["FormulaMatrixGenerationFailed", <|"sectors" -> Keys[recurrenceMetadata]|>]]
  ];
  de = MSDLogDE[context];
  If[Lookup[de, "dlogStatus", None] =!= "certifiedByFormulaChecks",
    Return[Failure[
      "CertifiedDLogRequired",
      <|"dlogStatus" -> Lookup[de, "dlogStatus", Missing["Absent"]]|>
    ]]
  ];
  rawData = <|
    "status" -> "generated",
    "version" -> $MadStreeVersion,
    "caseName" -> Lookup[context, "caseName", "MadStreeContext"],
    "nuConvention" -> context["convention", "nuConvention"],
    "sectorOrder" -> context["sectorOrder"],
    "sectorKeySchema" -> context["sectorKeySchema"],
    "masters" -> context["masters"],
    "masterDigest" -> context["masterDigest"],
    "timePowerSymbols" -> msFormulaTimePowerSymbols[context],
    "timePowerRules" -> rules,
    "recurrenceMetadata" -> recurrenceMetadata,
    "dlogDE" -> de
  |>;
  substitutedData = rawData /. rules;
  Join[
    substitutedData,
    <|
      "timePowerSymbols" -> rawData["timePowerSymbols"],
      "timePowerRules" -> rules,
      "artifactDigest" -> IntegerString[Hash[substitutedData, "SHA256"], 16, 64]
    |>
  ]
];


MSFormulaData[___] := Failure[
  "InitializedContextRequired",
  <|"function" -> "MSFormulaData"|>
];


(* ::Chapter:: *)
(* Calling directory and file writing *)

msFormulaRuntimeDirectory[] := msRuntimeDirectory[];


msFormulaAbsolutePathQ[path_String] := msAbsolutePathQ[path];


msResolveFormulaOutputDirectory[Automatic] := FileNameJoin[{
  msFormulaRuntimeDirectory[],
  "results",
  "madstree_formula",
  "run-" <> CreateUUID[]
}];


msResolveFormulaOutputDirectory[path_String] := ExpandFileName[
  If[msFormulaAbsolutePathQ[path], path, FileNameJoin[{msFormulaRuntimeDirectory[], path}]]
];


msResolveFormulaOutputDirectory[value_] := Failure[
  "OutputDirectoryRequired",
  <|"expected" -> "Automatic or a path string", "actual" -> HoldForm[value]|>
];


Options[MSWriteFormulaArtifacts] = {
  TimePowerRules -> Automatic,
  MSOutputDirectory -> Automatic
};


MSWriteFormulaArtifacts[context_?MSContextQ, OptionsPattern[]] := Module[
  {data, outputDirectory, paths, manifest},
  data = MSFormulaData[
    context,
    TimePowerRules -> OptionValue[TimePowerRules]
  ];
  If[Head[data] === Failure, Return[data]];
  outputDirectory = msResolveFormulaOutputDirectory[OptionValue[MSOutputDirectory]];
  If[Head[outputDirectory] === Failure, Return[outputDirectory]];
  If[msEnsureDirectory[outputDirectory] === $Failed,
    Return[Failure["OutputDirectoryCreationFailed", <|"path" -> outputDirectory|>]]
  ];
  paths = <|
    "masters" -> FileNameJoin[{outputDirectory, "masters.wl"}],
    "recurrenceMetadata" -> FileNameJoin[{outputDirectory, "recurrence_metadata.wl"}],
    "dlogDE" -> FileNameJoin[{outputDirectory, "dlog_de.wl"}]
  |>;
  Quiet@Check[
    Put[data["masters"], paths["masters"]];
    Put[data["recurrenceMetadata"], paths["recurrenceMetadata"]];
    Put[data["dlogDE"], paths["dlogDE"]],
    Return[Failure["FormulaArtifactWriteFailed", <|"outputDirectory" -> outputDirectory|>]]
  ];
  manifest = KeyTake[
    data,
    {
      "status", "version", "caseName", "nuConvention", "sectorOrder",
      "sectorKeySchema", "masterDigest", "timePowerSymbols", "timePowerRules", "artifactDigest"
    }
  ];
  manifest = Join[manifest, <|
    "outputDirectory" -> outputDirectory,
    "files" -> paths,
    "allSectorQ" -> True,
    "dlogStatus" -> data["dlogDE", "dlogStatus"]
  |>];
  Put[manifest, FileNameJoin[{outputDirectory, "manifest.wl"}]];
  Join[
    data,
    <|
      "outputDirectory" -> outputDirectory,
      "files" -> Join[paths, <|"manifest" -> FileNameJoin[{outputDirectory, "manifest.wl"}]|>],
      "manifest" -> manifest
    |>
  ]
];


MSWriteFormulaArtifacts[___] := Failure[
  "InitializedContextRequired",
  <|"function" -> "MSWriteFormulaArtifacts"|>
];
