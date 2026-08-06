(* ::Package:: *)
(***
文件：check_time_only_sector_key.wls
用途：验证 dSIBP 019 的 time-only sector 使用 root propagator 顺序的定长字符串。
核心检查：四条共同-theta 传播子中收缩 {1,2,4} 必须得到 "0010"，且前导零不丢失。
边界：本脚本不生成连续 seed 点、linearData、Kira 输入、reduction 或 DE。
***)


(* ::Chapter:: *)
(*加载与四传播子输入*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "_harness.wls"}]];
projectRoot = DirectoryName[DirectoryName[DirectoryName[$InputFileName]]];
dsSmokeLoadPackage[FileNameJoin[{projectRoot, "versions", "019_dSIBP", "Kernel", "dSIBP.wl"}]];
DSMessagesOff[];

caseInput = <|
   "name" -> "CheckTimeOnlySectorBitString",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> Table[
     <|
      "id" -> lineIndex,
      "endpoints" -> {v1, v2},
      "momentum" -> Symbol["p" <> ToString[lineIndex]],
      "massType" -> "massive",
      "bbType" -> "h",
      "nu" -> Symbol["nu" <> ToString[lineIndex]],
      "skType" -> "++"
      |>,
     {lineIndex, 4}
     ],
   "loopMomenta" -> {},
   "loopExternalMomenta" -> {},
   "independentExternalMomenta" -> {p1, p2, p3, p4},
   "ibpMode" -> "timeOnly",
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "ispData" -> {},
   "zeroPointRules" -> Join[
     {a0[v1] -> alpha1, a0[v2] -> alpha2},
     Table[b0[lineIndex] -> Symbol["beta" <> ToString[lineIndex]], {lineIndex, 4}]
     ],
   "symmetryRules" -> {}
   |>;

context = DSInit[
   caseInput,
   RegisterAsCurrent -> False,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> False,
   ProgressReporting -> False
   ];


(* ::Chapter:: *)
(*Sector identity checks*)

sectors = context["sectors"];
targetSectors = Select[sectors, Lookup[#, "sectorShrunkLines", {}] === {1, 2, 4} &];
schema = First[sectors]["sectorKeySchema"];
keys = Lookup[sectors, "sectorKey"];

oldTopContext = DSInit[
   Join[caseInput, <|
     "name" -> "RejectOldTimeOnlyTopKey",
     "generatorSeedRanges" -> {
       <|"sectorKey" -> "top", "generator" -> {"tIBP", v1}, "ranges" -> {}|>
       }
     |>],
   RegisterAsCurrent -> False,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> False,
   ProgressReporting -> False
   ];

oldJoinedContext = DSInit[
   Join[caseInput, <|
     "name" -> "RejectOldTimeOnlyJoinedKey",
     "generatorSeedRanges" -> {
       <|"sectorKey" -> "e1_e2_e4", "generator" -> {"tIBP", v1}, "ranges" -> {}|>
       }
     |>],
   RegisterAsCurrent -> False,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> False,
   ProgressReporting -> False
   ];

checks = <|
   "initialized" -> (Lookup[context, "status", "failed"] === "initialized"),
   "topIsAllOnes" -> MemberQ[keys, "1111"],
   "requestedSectorUnique" -> (Length[targetSectors] === 1),
   "requestedSectorKey" -> (
     Length[targetSectors] === 1 && First[targetSectors]["sectorKey"] === "0010"
     ),
   "keysAreFixedWidthStrings" -> And @@ (
      StringQ[#] && StringLength[#] === 4 && StringMatchQ[#, ("0" | "1") ..] & /@ keys
      ),
   "keysAreUnique" -> DuplicateFreeQ[keys],
   "schemaMatchesRootOrder" -> (
     schema["type"] === "rootPropagatorBitString" &&
      schema["rootLineOrder"] === {1, 2, 3, 4} &&
      schema["width"] === 4 &&
      schema["storageType"] === "String"
     ),
    "oldTopKeyRejected" -> (Lookup[oldTopContext, "status", None] === "failed"),
    "oldJoinedKeyRejected" -> (Lookup[oldJoinedContext, "status", None] === "failed")
   |>;

failed = Keys@Select[checks, Not@TrueQ[#] &];
Print["check_time_only_sector_key: ", Count[Values[checks], True], "/", Length[checks]];
Print["failed: ", InputForm[failed]];
Print[InputForm[<|"passed" -> Count[Values[checks], True], "total" -> Length[checks], "failed" -> failed,
    "targetSector" -> targetSectors,
    "sectorKeys" -> keys
  "checks" -> checks|>]];
If[Count[Values[checks], True] =!= Length[checks], Exit[1]];
