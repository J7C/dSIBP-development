(* ::Package:: *)
(* Purpose: reproduce, with our own evidence on the CURRENT repository bytes, the
   numerical claims of the external report
   000_report/2026-10-3-FlintNDE Mathematica precision-loss report, whose own
   section-8 attachments (the precision_probe and zero_decode_fix_probe wl/json
   files) are absent from the repository and cannot be reviewed.

   This probe modifies NO package source. It (A) reproduces the section-4 root
   cause and the section-6.2 four-input decode table against the shipped private
   decoder, and (B) runs the official mathematica_interface_example system
   end-to-end through the public Wolfram interface and records the precision of
   the returned vector, reproducing section-3.3. Output is JSON.

   ASCII only on purpose: math.exe -script reads this file with the system code
   page, so non-ASCII here would mojibake. *)


(* ::Chapter:: *)
(*Paths and package load*)

probeDirectory = DirectoryName[$InputFileName];

(* Locate the repository root by walking up until the dev FlintNDE version dir is
   found, so this probe runs from any home (scratch or 000_report attachment). *)
findVersionDirectory[dir_] := Module[{candidate, current = dir, guard = 0},
  While[guard < 12,
    candidate = FileNameJoin[{current, "package-FlintNDE", "versions", "FlintNDE-0.5.0"}];
    If[DirectoryQ[candidate], Return[ExpandFileName[candidate]]];
    current = FileNameJoin[{current, ".."}];
    guard++
  ];
  $Failed
];
versionDirectory = findVersionDirectory[probeDirectory];
If[versionDirectory === $Failed,
  Print["could not locate package-FlintNDE/versions/FlintNDE-0.5.0 above ", probeDirectory];
  Exit[1]
];
runtimeDirectory = FileNameJoin[{probeDirectory, "results_temp"}];
If[! DirectoryQ[runtimeDirectory],
  CreateDirectory[runtimeDirectory, CreateIntermediateDirectories -> True]
];
jsonPath = FileNameJoin[{probeDirectory, "precision_recheck.json"}];

$Path = Prepend[$Path, versionDirectory];
Needs["FlintNDE`"];

decodeComplex = Symbol["FlintNDE`Private`flintNDEDecodeComplex"];
decodeDecimal = Symbol["FlintNDE`Private`flintNDEDecodeDecimal"];


(* ::Chapter:: *)
(*Part A: decode-layer reproduction*)

(* ::Section:: *)
(*Root cause: a tagged zero literal*)

preFixZeroLiteral = ToExpression["0.0`40"];
preFixZeroPrecision = Precision[preFixZeroLiteral];
preFixZeroIsMachine = preFixZeroPrecision === MachinePrecision;


(* ::Section:: *)
(*Shipped decoder on the four report input types*)

highReal = "0.7346938775510204081632653061224489795918";
digits = 40;

decodeCase[real_String, imag_String] := Module[
  {record, value, re, im},
  record = <|"real" -> real, "imag" -> imag|>;
  value = decodeComplex[record, digits];
  re = decodeDecimal[real, digits];
  im = decodeDecimal[imag, digits];
  <|
    "real" -> real,
    "imag" -> imag,
    "realPrecision" -> Precision[re],
    "imagPrecision" -> Precision[im],
    "complexPrecision" -> Precision[value],
    "complexIsMachine" -> Precision[value] === MachinePrecision,
    "complexIsExactZero" -> value === 0
  |>
];

decodeTable = {
  <|"label" -> "high-precision real, zero imag",
    "case" -> decodeCase[highReal, "0"]|>,
  <|"label" -> "zero real, pure imaginary",
    "case" -> decodeCase["0", highReal]|>,
  <|"label" -> "both components nonzero",
    "case" -> decodeCase[highReal, highReal]|>,
  <|"label" -> "both components zero",
    "case" -> decodeCase["0", "0"]|>
};

anyDecodeMachine = Or @@ (#[["case", "complexIsMachine"]] & /@ decodeTable);


(* ::Chapter:: *)
(*Part B: end-to-end public interface reproduction*)

system = FlintNDERationalSystem[
  {{1/(z - 1), 0}, {0, -2/(z + 3)}},
  z,
  "Name" -> "external-report-recheck"
];

plan = FlintNDEPlanPath[
  system,
  0,
  {1/4, 1/2},
  FlintNDE`SingularityMode -> "Avoid",
  FlintNDE`MessageLanguage -> "EN",
  "WorkDirectory" -> runtimeDirectory,
  "WorkingPrecisionDigits" -> 80,
  "OutputDigits" -> 40
];

planStatus = If[AssociationQ[plan], Lookup[plan, "status", "error"], "notAssociation"];

result = If[planStatus === "complete",
  FlintNDEExecutePath[
    system,
    {1, 1},
    plan,
    FlintNDE`MessageLanguage -> "EN",
    "WorkDirectory" -> runtimeDirectory,
    "WorkingPrecisionDigits" -> 80,
    "OutputDigits" -> 40,
    "PrimaryOrder" -> 40,
    "ReferenceOrder" -> 48,
    "TargetRelativeError" -> "1e-30"
  ],
  Missing["PlanFailed"]
];

resultStatus = If[AssociationQ[result],
  Lookup[result, "status", "error"],
  "notAssociation"
];

expectedFinal = N[{1/2, 36/49}, 40];

endToEnd = If[AssociationQ[result] && resultStatus === "complete",
  Module[{vec, precList, absErr},
    vec = result["primaryFinalVector"];
    precList = Precision /@ vec;
    absErr = Max[Abs[N[vec, 40] - expectedFinal]];
    <|
      "status" -> resultStatus,
      "certificationMode" -> Lookup[result, "certificationMode", Missing["NotAvailable"]],
      "relativeDifferenceInf" -> Lookup[result, "relativeDifferenceInf", Missing["NotAvailable"]],
      "targetRelativeErrorMet" -> Lookup[result, "targetRelativeErrorMet", Missing["NotAvailable"]],
      "primaryFinalVector" -> vec,
      "precisionList" -> precList,
      "anyComponentMachinePrecision" -> MemberQ[precList, MachinePrecision],
      "absErrorVsClosedForm" -> absErr,
      "absErrorBelowTarget" -> TrueQ[absErr < 10^-30]
    |>
  ],
  <|"status" -> resultStatus, "note" -> "end-to-end run did not complete"|>
];


(* ::Chapter:: *)
(*Part C: parallel Wolfram interface reproduction*)

(* Reproduces report section 5 item 3 and attachment
   fn_wolfram_parallel_configured_details.json: the ep-parallel Wolfram batch used
   the same decoder, so its returned vectors degraded to machine precision pre-fix.
   We run the shipped public entry on the example jobs and record the precision of
   each returned vector against the current fixed bytes. *)

epValues = {1/5, 1/6, 1/7};
parallelJobs = Map[
  <|
    "ep" -> #,
    "system" -> FlintNDERationalSystem[{{#/(1 + x)}}, x],
    "start" -> 0,
    "points" -> {1},
    "initialVector" -> {1}
  |> &,
  epValues
];

batch = FlintNDEEvaluateEpBatch[
  parallelJobs,
  FlintNDE`ParallelTaskCount -> 3,
  FlintNDE`MessageLanguage -> "EN",
  "WorkDirectory" -> runtimeDirectory,
  "WorkingPrecisionDigits" -> 60,
  "OutputDigits" -> 40,
  "PrimaryOrder" -> 48,
  "ReferenceOrder" -> 64,
  "TargetRelativeError" -> "1e-30"
];

parallelSection = If[Head[batch] === Failure,
  <|"status" -> "failure", "detail" -> InputForm[batch]|>,
  Module[{results, rows, maxDiff},
    results = batch["results"];
    rows = Map[
      Function[r,
        Module[{pv, rv},
          pv = r["execution", "primaryFinalVector"];
          rv = r["execution", "referenceFinalVector"];
          <|
            "ep" -> r["ep"],
            "primaryPrecision" -> Precision[First[pv]],
            "referencePrecision" -> Precision[First[rv]],
            "primaryIsMachine" -> Precision[First[pv]] === MachinePrecision,
            "absDiffVsClosedForm" -> Abs[First[rv] - N[2^r["ep"], 40]]
          |>
        ]
      ],
      results
    ];
    maxDiff = Max[Abs[
      (First[#["execution", "referenceFinalVector"]] & /@ results) - N[2^epValues, 40]
    ]];
    <|
      "status" -> "complete",
      "parallelTaskCountEffective" -> batch["parallelTaskCountEffective"],
      "inputOrderPreserved" -> Lookup[results, "ep"] === epValues,
      "anyReturnedVectorMachinePrecision" -> Or @@ (#[["primaryIsMachine"]] & /@ rows),
      "maxAbsDiffVsClosedForm" -> maxDiff,
      "maxAbsDiffBelowTarget" -> TrueQ[maxDiff < 10^-30],
      "perEp" -> rows
    |>
  ]
];


(* ::Chapter:: *)
(*Serialize JSON*)

(* Every diagnostic value is rendered to a faithful InputForm string (or a JSON
   boolean) so that precision tags, Infinity and interval forms survive Export
   without being flattened to a machine number. *)
plainScalar[v_] := Which[
  v === True, True,
  v === False, False,
  StringQ[v], v,
  True, ToString[InputForm[v]]
];

plainAssoc[a_Association] := Association[
  (# -> plainScalar[a[#]]) & /@ Keys[a]
];

decodeRowPlain[row_Association] := <|
  "label" -> row["label"],
  "case" -> plainAssoc[row["case"]]
|>;

partAPlain = <|
  "preFixZeroLiteralPrecisionIsMachine" -> plainScalar[preFixZeroIsMachine],
  "preFixZeroLiteralPrecision" -> plainScalar[preFixZeroPrecision],
  "shippedDecoderAnyMachinePrecision" -> plainScalar[anyDecodeMachine],
  "decodeTable" -> decodeRowPlain /@ decodeTable
|>;

partCPlain = If[Lookup[parallelSection, "status"] === "complete",
  <|
    "status" -> "complete",
    "parallelTaskCountEffective" -> plainScalar[parallelSection["parallelTaskCountEffective"]],
    "inputOrderPreserved" -> plainScalar[parallelSection["inputOrderPreserved"]],
    "anyReturnedVectorMachinePrecision" -> plainScalar[parallelSection["anyReturnedVectorMachinePrecision"]],
    "maxAbsDiffVsClosedForm" -> plainScalar[parallelSection["maxAbsDiffVsClosedForm"]],
    "maxAbsDiffBelowTarget" -> plainScalar[parallelSection["maxAbsDiffBelowTarget"]],
    "perEp" -> plainAssoc /@ parallelSection["perEp"]
  |>,
  plainAssoc[parallelSection]
];

summaryAssoc = <|
  "schema" -> "flintnde_external_report_precision_recheck_v1",
  "wolframVersion" -> plainScalar[$Version],
  "flintndeVersion" -> plainScalar[FlintNDE`$FlintNDEVersion],
  "decodeDigits" -> plainScalar[digits],
  "sourceFlintNDEwl" -> ToUpperCase[FileHash[
    FileNameJoin[{versionDirectory, "Mathematica", "FlintNDE.wl"}],
    "SHA256", "HexString"
  ]],
  "partA" -> partAPlain,
  "partB" -> plainAssoc[endToEnd],
  "partC" -> partCPlain
|>;

Export[jsonPath, summaryAssoc, "JSON"];

Print["PRECISION_RECHECK_JSON_WRITTEN"];
Print["preFixZeroIsMachine=", preFixZeroIsMachine];
Print["shippedDecoderAnyMachinePrecision=", anyDecodeMachine];
Print["endToEndStatus=", resultStatus];
Print["endToEndAnyMachine=", Lookup[endToEnd, "anyComponentMachinePrecision", Missing["NA"]]];
Print["endToEndAbsErr=", Lookup[endToEnd, "absErrorVsClosedForm", Missing["NA"]]];
Print["parallelStatus=", Lookup[parallelSection, "status", Missing["NA"]]];
Print["parallelAnyMachine=", Lookup[parallelSection, "anyReturnedVectorMachinePrecision", Missing["NA"]]];
