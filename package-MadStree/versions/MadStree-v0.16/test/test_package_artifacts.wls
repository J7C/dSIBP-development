(* ::Package:: *)

(***
File: test_package_artifacts.wls
Purpose: Checks the v0.16 version-root loading, the built-in FlintNDE configuration and the writing of all-sector formula artifacts.
Scope: only constructs a single massless full edge; numerical transport and external derivative operators are not invoked.
***)

(* ::Chapter:: *)
(* Version-root loading and input *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]];
versionDirectory = msTestLoadKernel[];

spec = <|
  "name" -> "PackageArtifactSmoke",
  "vertices" -> {
    <|"id" -> v1, "externalLegEnergy" -> k1, "timePower" -> a1, "vertexType" -> "+"|>,
    <|"id" -> v2, "externalLegEnergy" -> k2, "timePower" -> a2, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|
      "type" -> "massless",
      "endpoints" -> {v1, v2},
      "momentum" -> q,
      "nu" -> 1/2
    |>
  }
|>;

context = MSInitTree[spec];
topKey = First[context["sectorOrder"]];
quotientIntegral = MSIntegral[topKey, {1, -1}, {1}];
quotientDSIBPJ = MSToDSIBPJ[quotientIntegral, context];
redundantSpec = Join[spec, <|
  "lines" -> {
    Append[spec["lines"][[1]], "masslessRepresentation" -> "RedundantH"]
  }
|>];
redundantContext = MSInitTree[redundantSpec];
redundantIntegral = MSIntegral[
  First[redundantContext["sectorOrder"]],
  {1, -1},
  {1, 0}
];
redundantDSIBPJ = MSToDSIBPJ[redundantIntegral, redundantContext];
symbolicData = MSFormulaData[context];
substitutedData = MSFormulaData[context, TimePowerRules -> {a1 -> 2, a2 -> 3}];
outputRelativeDirectory = FileNameJoin[{
  "results_test",
  "formula-artifacts-" <> CreateUUID[]
}];
writtenData = MSWriteFormulaArtifacts[
  context,
  TimePowerRules -> {a1 -> 2, a2 -> 3},
  MSOutputDirectory -> outputRelativeDirectory
];
ensuredData = MadStree`Private`msEnsureFormulaArtifacts[context];
ensuredAgain = MadStree`Private`msEnsureFormulaArtifacts[context];
partialOutputDirectory = FileNameJoin[{
  "results_test",
  "formula-artifacts-partial-" <> CreateUUID[]
}];
CreateDirectory[
  FileNameJoin[{DirectoryName[$InputFileName], partialOutputDirectory, "manifest.wl"}],
  CreateIntermediateDirectories -> True
];
partialWrite = MSWriteFormulaArtifacts[
  context,
  MSOutputDirectory -> partialOutputDirectory
];


(* ::Chapter:: *)
(* Acceptance and summary *)

configuration = MSFlintNDEConfiguration[];
checks = <|
  "version" -> (context["version"] === "0.16" && configuration["version"] === "0.16"),
  "context" -> MSContextQ[context],
  "caseName" -> (context["caseName"] === "PackageArtifactSmoke"),
  "vendorAvailable" -> TrueQ[configuration["availableQ"]],
  "vendorRelativePath" -> (configuration["relativePath"] === FileNameJoin[{"Vendor", "FlintNDE"}]),
  "vendorInsideVersion" -> StringStartsQ[
    ExpandFileName[configuration["resolvedPath"]],
    ExpandFileName[versionDirectory]
  ],
  "quotientDSIBPRoundTrip" -> (
    quotientDSIBPJ === Inactive[dSIBP`J]["1", {1, -1}, {1}] &&
      MSFromDSIBPJ[quotientDSIBPJ, context] === quotientIntegral
  ),
  "redundantDSIBPRoundTrip" -> (
    redundantDSIBPJ === Inactive[dSIBP`J]["1", {1, -1}, {1, 0}] &&
      MSFromDSIBPJ[redundantDSIBPJ, redundantContext] === redundantIntegral
  ),
  "symbolicGenerated" -> (Lookup[symbolicData, "status", None] === "generated"),
  "allSectorsPresent" -> (
    Keys[symbolicData["recurrenceMetadata"]] === context["sectorOrder"] &&
      symbolicData["dlogDE", "masterDigest"] === context["masterDigest"]
  ),
  "timePowersDeclared" -> (SortBy[symbolicData["timePowerSymbols"], ToString] === {a1, a2}),
  "timePowersPreserved" -> ! FreeQ[
    {symbolicData["recurrenceMetadata"], symbolicData["dlogDE"]},
    a1 | a2
  ],
  "recurrenceTimePowersSubstituted" -> FreeQ[
    substitutedData["recurrenceMetadata"], a1 | a2
  ],
  "analyticDLogNeverSubstituted" ->
    substitutedData["dlogDE"] === symbolicData["dlogDE"] &&
    ! FreeQ[substitutedData["dlogDE"], a1 | a2],
  "written" -> (Lookup[writtenData, "status", None] === "generated"),
  "outputBelongsToCaller" -> StringStartsQ[
    ExpandFileName[writtenData["outputDirectory"]],
    ExpandFileName[DirectoryName[$InputFileName]]
  ],
  "filesExist" -> And @@ (FileExistsQ /@ Values[writtenData["files"]]),
  "writtenDLogIsAnalytic" ->
    Get[writtenData["files", "dlogDE"]] === symbolicData["dlogDE"],
  "manifestAllSector" -> TrueQ[writtenData["manifest", "allSectorQ"]],
  "manifestDLogCertified" -> (
    writtenData["manifest", "dlogStatus"] === "certifiedByFormulaChecks"
  ),
  "manifestListsEveryArtifact" ->
    writtenData["manifest", "files"] === writtenData["files"],
  "automaticEnsureReusesExplicitArtifact" ->
    ensuredData["outputDirectory"] === writtenData["outputDirectory"],
  "automaticEnsureStable" ->
    ensuredAgain["outputDirectory"] === ensuredData["outputDirectory"] &&
      And @@ (FileExistsQ /@ Values[ensuredAgain["files"]]),
  "partialWriteCannotClaimSuccess" ->
    MatchQ[partialWrite, Failure["FormulaArtifactWriteFailed", _Association]]
|>;

failed = Keys@Select[checks, Not@TrueQ[#] &];
If[MemberQ[failed, "quotientDSIBPRoundTrip"],
  Print["quotient J: ", InputForm[quotientDSIBPJ]];
  Print["quotient J full form: ", FullForm[quotientDSIBPJ]];
  Print["quotient inverse: ", InputForm[MSFromDSIBPJ[quotientDSIBPJ, context]]]
];
If[MemberQ[failed, "redundantDSIBPRoundTrip"],
  Print["redundant J: ", InputForm[redundantDSIBPJ]];
  Print["redundant inverse: ", InputForm[MSFromDSIBPJ[redundantDSIBPJ, redundantContext]]]
];
Print[InputForm[<|
  "passed" -> Count[Values[checks], True],
  "total" -> Length[checks],
  "failed" -> failed,
  "outputDirectory" -> Lookup[writtenData, "outputDirectory", Missing["Absent"]],
  "checks" -> checks
|>]];

Exit[If[failed === {}, 0, 1]];
