(* ::Package:: *)
(* 017 表示层 smoke：检查 fixed/massless 三槽、单槽 sector identity、lower ds、
   h parity transport 以及在 seed 域先筛选后生成的 parity certificate。 *)

(* ::Chapter:: *)
(*加载 017*)

projectRoot = DirectoryName[DirectoryName[$InputFileName]];
packageDir = FileNameJoin[{projectRoot, "000_code", "017_dSIBP"}];
$Path = Prepend[$Path, packageDir];
Needs["dSIBP`"];
DSMessagesOff[];


(* ::Chapter:: *)
(*Atomic massless time-only*)

atomicCase = <|
   "name" -> "017AtomicMasslessTimeOnly",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> p,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0, "skType" -> "++"|>
     },
   "loopMomenta" -> {},
   "loopExternalMomenta" -> {},
   "independentExternalMomenta" -> {p},
   "ibpMode" -> "timeOnly",
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "ispData" -> {},
   "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta1},
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;

atomicContext = DSInit[atomicCase, RegisterAsCurrent -> True, ProgressReporting -> False];
atomicMetadata = Lookup[atomicContext, "sectors", {}];
atomicTop = dSIBP`Private`makeBaseIntegral[atomicContext["topology"]];
atomicLowerTopology = dSIBP`Private`shrinkSectorTopology[atomicContext["topology"], {1}];
atomicLower = dSIBP`Private`makeBaseIntegral[atomicLowerTopology];
atomicVariables = dSIBP`Private`independentVariableDerivativeVariables[atomicContext["topology"]];
atomicDerivativeVariable = First[atomicVariables];
atomicTopDerivative = ds[atomicTop /. {a[v1] -> 0, a[v2] -> 0, n[1, 1] -> 0, n[1, 2] -> 0}, atomicDerivativeVariable, atomicContext];
atomicLowerDerivative = ds[atomicLower /. a[v1] -> 0, atomicDerivativeVariable, atomicContext];
atomicSeeds = DSSeeds[atomicContext, ProgressReporting -> False];
atomicGenerated = DSGenerateIBP[DSAllSeeds[atomicSeeds], {-1, 1}, ProgressReporting -> False];


(* ::Chapter:: *)
(*Massive h bubble parity*)

massiveCase = <|
   "name" -> "017MassiveBubbleParity",
   "vertexData" -> {{v1, "-"}, {v2, "-"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nu, "skType" -> "--"|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nu, "skType" -> "--"|>
     },
   "loopMomenta" -> {q},
   "loopExternalMomenta" -> {k},
   "independentExternalMomenta" -> {},
   "ibpMode" -> "full",
   "vertexEnergies" -> <|v1 -> P0, v2 -> P0|>,
   "ispData" -> {},
   "zeroPointRules" -> {a0[v1] -> 2 nu, a0[v2] -> 2 nu, b0[1] -> -2 nu, b0[2] -> -2 nu},
   "symmetryRules" -> {},
   "parityConstraints" -> {
     b[1] + n[1, 1] + n[1, 2] -> 0,
     b[2] + n[2, 1] + n[2, 2] -> 0
     },
   "seedPreset" -> "quickCheck"
   |>;

massiveContext = DSInit[massiveCase, RegisterAsCurrent -> True, ProgressReporting -> False];
massiveMetadata = Lookup[massiveContext, "sectors", {}];
massiveSeeds = DSSeeds[massiveContext, ProgressReporting -> False];
massiveAllSeeds = DSAllSeeds[massiveSeeds];
massiveIndices = DeleteDuplicates@Flatten[Lookup[massiveAllSeeds, "continuousIndices", {}], Infinity];
massiveRanges = ({#, -2, 2} & /@ massiveIndices);
massiveGenerated = DSGenerateIBP[
   massiveAllSeeds,
   Sequence @@ massiveRanges,
   ProgressReporting -> False
   ];


(* ::Chapter:: *)
(*Massless flip 与 H preservation metadata*)

mixedCase = Join[massiveCase, <|
    "name" -> "017MixedMasslessParity",
    "lineData" -> {
      massiveCase["lineData"][[1]],
      <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
        "massType" -> "massless", "bbType" -> "exp", "nu" -> 0, "skType" -> "--"|>
      },
    "zeroPointRules" -> {a0[v1] -> 2 nu, a0[v2] -> 2 nu, b0[1] -> -2 nu, b0[2] -> 0}
    |>];
mixedContext = DSInit[mixedCase, RegisterAsCurrent -> False, ProgressReporting -> False];
mixedMetadata = Lookup[mixedContext, "sectors", {}];
mixedMasslessChild = SelectFirst[mixedMetadata, Lookup[#, "sectorKey", ""] === "e2" &, <||>];
mixedMasslessConstraint = Lookup[
   Lookup[Lookup[mixedMasslessChild, "parityData", <||>], "constraints", {}],
   "expression",
   {}
   ];

hCase = Join[massiveCase, <|
    "name" -> "017HankelHParity",
    "lineData" -> (Join[#, <|"bbType" -> "H"|>] & /@ massiveCase["lineData"]),
    "zeroPointRules" -> {a0[v1] -> 0, a0[v2] -> 0, b0[1] -> 0, b0[2] -> 0}
    |>];
hContext = DSInit[hCase, RegisterAsCurrent -> False, ProgressReporting -> False];
hMetadata = Lookup[hContext, "sectors", {}];

atomicCanonical01 = dSIBP`Private`applySeedCanonical[
   J[{0, 0}, {{"F", 0, 1}}, {}], atomicContext["topology"]
   ];
atomicCanonical11 = dSIBP`Private`applySeedCanonical[
   J[{0, 0}, {{"F", 1, 1}}, {}], atomicContext["topology"]
   ];


(* ::Chapter:: *)
(*断言*)

atomicPacks = (Lookup[Lookup[#, "lineSlots", {}], "packTemplate", {}] & /@ atomicMetadata);
atomicPrefactors = Lookup[atomicMetadata, "sectorPrefactorData", {}];
atomicNoncanonical = Cases[
   Lookup[Lookup[atomicGenerated, "equations", {}], "equation", {}],
   int : J[_, {pack_List}, _] /; Length[pack] === 3 && Last[pack] === 1 :> int,
   Infinity
   ];
massiveParity = Lookup[massiveMetadata, "parityData", {}];

checks = <|
   "atomicInitialized" -> (Lookup[atomicContext, "status", "failed"] === "initialized"),
   "atomicSectorKeys" -> (Lookup[atomicMetadata, "sectorKey", {}] === {"top", "e1"}),
   "atomicFixedPacks" -> (atomicPacks === {{{"F", n[1, 1], n[1, 2]}}, {{"F"}}}),
   "atomicTimeOnlyEmptyISP" -> (atomicTop[[3]] === {} && atomicLower[[3]] === {}),
   "atomicTopDs" -> (atomicTopDerivative =!= $Failed),
   "atomicLowerDs" -> (atomicLowerDerivative =!= $Failed),
   "atomicTemplates" -> (Lookup[atomicSeeds, "dSIBPStatus", "failed"] === "generated"),
   "atomicGenerated" -> (Lookup[atomicGenerated, "status", "failed"] === "generated"),
   "atomicMasslessCanonical" -> (atomicNoncanonical === {}),
   "atomicRelation01" -> (atomicCanonical01 === -J[{0, 0}, {{"F", 1, 0}}, {}]),
   "atomicRelation11" -> (atomicCanonical11 === -J[{0, 0}, {{"F", 0, 0}}, {}]),
   "atomicZeroPointOnly" -> (Lookup[Lookup[atomicPrefactors[[2]], "powerParts", {}], "normalizedResidualPower", {}] === {0}),
   "massiveInitialized" -> (Lookup[massiveContext, "status", "failed"] === "initialized"),
   "massiveParityEnabled" -> And @@ (Lookup[#, "status", "disabled"] === "enabled" & /@ massiveParity),
   "massiveParityPreserved" -> (Lookup[massiveParity, "masslessCycleFlipCount", {}] === {0, 0, 0}),
   "massiveGenerated" -> (Lookup[massiveGenerated, "status", "failed"] === "generated"),
   "massiveParityCertificate" -> TrueQ[Lookup[Lookup[massiveGenerated, "parityCertificate", <||>], "passQ", False]]
   ,"mixedInitialized" -> (Lookup[mixedContext, "status", "failed"] === "initialized")
   ,"masslessChildParityFlip" -> MemberQ[mixedMasslessConstraint, 1 + bS[2]]
   ,"hInitialized" -> (Lookup[hContext, "status", "failed"] === "initialized")
   ,"hParityPreserved" -> And @@ (Lookup[#, "masslessCycleFlipCount", -1] === 0 & /@ Lookup[hMetadata, "parityData", {}])
   |>;

failed = Keys@Select[checks, Not];
Print[<|
  "passed" -> Count[Values[checks], True],
  "total" -> Length[checks],
  "failed" -> failed,
  "atomicTop" -> atomicTop,
  "atomicLower" -> atomicLower,
  "atomicVariables" -> atomicVariables,
  "atomicLowerDerivative" -> atomicLowerDerivative,
  "atomicNoncanonical" -> Take[atomicNoncanonical, UpTo[5]],
  "massiveSectorKeys" -> Lookup[massiveMetadata, "sectorKey", {}],
  "massiveParity" -> massiveParity,
  "massiveGeneratedStatus" -> KeyTake[massiveGenerated, {"status", "reason", "equationCount", "parityCertificate"}],
  "mixedMasslessConstraint" -> mixedMasslessConstraint,
  "hParity" -> Lookup[hMetadata, "parityData", {}],
  "checks" -> checks
  |>];

Exit[If[failed === {}, 0, 1]];
