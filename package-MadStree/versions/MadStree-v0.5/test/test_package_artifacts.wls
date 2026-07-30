(* ::Package:: *)

(***
文件：test_package_artifacts.wls
用途：检查 v0.5 版本根加载、内置 FlintNDE 配置及全 sector 公式产物写出。
边界：只构造一个单 massless full edge，不调用数值输运或外部微分算符。
***)

(* ::Chapter:: *)
(*版本根加载与输入*)

versionDirectory = DirectoryName[DirectoryName[$InputFileName]];
AppendTo[$Path, versionDirectory];
Needs["MadStree`"];

spec = <|
  "name" -> "PackageArtifactSmoke",
  "vertices" -> {
    <|"id" -> v1, "energy" -> k1, "timePower" -> a1|>,
    <|"id" -> v2, "energy" -> k2, "timePower" -> a2|>
  },
  "lines" -> {
    <|
      "id" -> e1,
      "type" -> "masslessFull",
      "endpoints" -> {v1, v2},
      "momentum" -> q,
      "skType" -> "++",
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


(* ::Chapter:: *)
(*验收与汇总*)

configuration = MSFlintNDEConfiguration[];
checks = <|
  "version" -> (context["version"] === "0.5" && configuration["version"] === "0.5"),
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
  "timePowersSubstituted" -> FreeQ[
    {substitutedData["recurrenceMetadata"], substitutedData["dlogDE"]},
    a1 | a2
  ],
  "written" -> (Lookup[writtenData, "status", None] === "generated"),
  "outputBelongsToCaller" -> StringStartsQ[
    ExpandFileName[writtenData["outputDirectory"]],
    ExpandFileName[DirectoryName[$InputFileName]]
  ],
  "filesExist" -> And @@ (FileExistsQ /@ Values[writtenData["files"]]),
  "manifestAllSector" -> TrueQ[writtenData["manifest", "allSectorQ"]],
  "manifestDLogCertified" -> (
    writtenData["manifest", "dlogStatus"] === "certifiedByFormulaChecks"
  )
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
