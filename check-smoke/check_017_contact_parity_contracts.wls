(* ::Package:: *)
(* 017 contact/parity 合同 smoke：验证 fixed h/H zeroPointOnly、用户 bS0 重基、
   simultaneous common-theta contact、reachable-sector generator 覆盖和 massless 公式能力边界。 *)

(* ::Chapter:: *)
(*加载 017*)

projectRoot = DirectoryName[DirectoryName[$InputFileName]];
packageDir = FileNameJoin[{projectRoot, "000_code", "017_dSIBP"}];
$Path = Prepend[$Path, packageDir];
Needs["dSIBP`"];
DSMessagesOff[];


(* ::Chapter:: *)
(*Fixed h/H zeroPointOnly*)

fixedCase[family_] := <|
   "name" -> ("017Fixed" <> family),
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> p,
       "massType" -> "massive", "bbType" -> family, "nu" -> nu,
       "skType" -> "++"|>
     },
   "loopMomenta" -> {},
   "loopExternalMomenta" -> {},
   "independentExternalMomenta" -> {p},
   "ibpMode" -> "timeOnly",
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "ispData" -> {},
   "zeroPointRules" -> If[
     family === "h",
     {a0[v1] -> 2 nu, a0[v2] -> 2 nu, b0[1] -> -2 nu},
     {a0[v1] -> 0, a0[v2] -> 0, b0[1] -> 0}
     ],
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;

fixedHContext = DSInit[fixedCase["h"], RegisterAsCurrent -> True, ProgressReporting -> False];
fixedHUpper = fixedHContext["sectors"][[1, "sectorPrefactorData", "powerParts", 1]];
fixedHLower = fixedHContext["sectors"][[2, "sectorPrefactorData", "powerParts", 1]];
fixedHSeeds = DSSeeds[fixedHContext, ProgressReporting -> False];
fixedHGenerated = DSGenerateIBP[DSAllSeeds[fixedHSeeds], {-2, 2}, ProgressReporting -> False];
fixedHIntegrals = DeleteDuplicates@Cases[
    Lookup[Lookup[fixedHGenerated, "equations", {}], "equation", {}],
    _J,
    Infinity
    ];
fixedHTopIntegral = J[{a[v1], a[v2]}, {{"F", 1, 0}}, {}];
fixedHLowerTopology = dSIBP`Private`shrinkSectorTopology[fixedHContext["topology"], {1}];
fixedHLowerIntegral = dSIBP`Private`makeBaseIntegral[fixedHLowerTopology] /. a[v1] -> 0;
fixedHLowerDerivative = ds[fixedHLowerIntegral, sE1, fixedHContext];
fixedHFormulaSeed = DSTreeSeeds[v1, fixedHTopIntegral, fixedHContext];
fixedDLog = DSTreeDLogDE[fixedHContext];
fixedNaive = DSTreeNaiveIBP[fixedHContext, Automatic, ProgressReporting -> False];
fixedNaiveDE = DSTreeNaiveDE[fixedHContext, Automatic, Automatic, ProgressReporting -> False];
fixedIterative = If[
   Lookup[fixedDLog, "status", "failed"] === "generated" &&
    ListQ[Lookup[fixedDLog, "masters", None]] && fixedDLog["masters"] =!= {},
   repIterative[First[fixedDLog["masters"]]["integral"], Automatic, fixedHContext],
   <|"status" -> "failed"|>
   ];

fixedHankelContext = DSInit[fixedCase["H"], RegisterAsCurrent -> False, ProgressReporting -> False];
fixedHankelLower = fixedHankelContext["sectors"][[2, "sectorPrefactorData", "powerParts", 1]];

fixedOverrideInput = fixedCase["h"];
fixedOverrideInput["name"] = "017FixedHZeroPointOverride";
fixedOverrideInput["zeroPointRules"] = Append[fixedOverrideInput["zeroPointRules"], bS0[1] -> 1];
fixedOverrideContext = DSInit[fixedOverrideInput, RegisterAsCurrent -> False, ProgressReporting -> False];
fixedOverrideLower = fixedOverrideContext["sectors"][[2, "sectorPrefactorData", "powerParts", 1]];
fixedOverrideBoundary = dSIBP`Private`timeThetaBoundaryShrinkTerms[
   fixedOverrideContext["topology"],
   J[{a[v1], a[v2]}, {{"F", 1, 0}}, {}],
   v1
   ];
fixedOverrideLowerTopology = dSIBP`Private`shrinkSectorTopology[fixedOverrideContext["topology"], {1}];
fixedOverrideLowerIntegral = dSIBP`Private`makeBaseIntegral[fixedOverrideLowerTopology] /. a[v1] -> 0;
fixedOverrideLowerDerivative = ds[fixedOverrideLowerIntegral, sE1, fixedOverrideContext];
fixedOverrideFormulaSeed = DSTreeSeeds[v1, fixedHTopIntegral, fixedOverrideContext];


(* ::Chapter:: *)
(*Cycle parity zero-point rebase*)

cycleCase[override_] := <|
   "name" -> "017CycleParityOverride",
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
   "zeroPointRules" -> Join[
     {a0[v1] -> 2 nu, a0[v2] -> 2 nu, b0[1] -> -2 nu, b0[2] -> -2 nu},
     override
     ],
   "symmetryRules" -> {},
   "parityConstraints" -> {
     b[1] + n[1, 1] + n[1, 2] -> 0,
     b[2] + n[2, 1] + n[2, 2] -> 0
     },
   "seedPreset" -> "quickCheck"
   |>;

integerRebaseContext = DSInit[
   cycleCase[{bS0[1] -> 1, bS0[2] -> 0}],
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];
integerRebaseChild = SelectFirst[
   Lookup[integerRebaseContext, "sectors", {}],
   Lookup[#, "sectorKey", ""] === "e1" &,
   <||>
   ];
integerRebaseConstraints = Lookup[
   Lookup[Lookup[integerRebaseChild, "parityData", <||>], "constraints", {}],
   "expression",
   {}
   ];
integerRebaseChildTopology = dSIBP`Private`sectorTopologyForMetadata017[
   integerRebaseContext["topology"],
   integerRebaseChild
   ];

nonIntegerRebaseContext = DSInit[
   cycleCase[{bS0[1] -> 1/2, bS0[2] -> 0}],
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];


(* ::Chapter:: *)
(*Three-line common theta*)

threeLineCase = <|
   "name" -> "017ThreeLineCommonTheta",
   "vertexData" -> {{u, "+"}, {v, "+"}},
   "lineData" -> Table[
     <|"id" -> e, "endpoints" -> {u, v}, "momentum" -> {p1, p2, p3}[[e]],
       "massType" -> "massive", "bbType" -> "h", "nu" -> {nu1, nu2, nu3}[[e]],
       "skType" -> "++"|>,
     {e, 3}
     ],
   "loopMomenta" -> {},
   "loopExternalMomenta" -> {},
   "independentExternalMomenta" -> {p1, p2, p3},
   "ibpMode" -> "timeOnly",
   "vertexEnergies" -> <|u -> U0, v -> V0|>,
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[u] -> 2 (nu1 + nu2 + nu3), a0[v] -> 2 (nu1 + nu2 + nu3),
     b0[1] -> -2 nu1, b0[2] -> -2 nu2, b0[3] -> -2 nu3
     },
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;

threeLineContext = DSInit[threeLineCase, RegisterAsCurrent -> False, ProgressReporting -> False];
threeLineTopology = threeLineContext["topology"];
threeLineIntegral = J[
   {a[u], a[v]},
   {{"F", 1, 0}, {"F", 1, 0}, {"F", 1, 0}},
   {}
   ];
threeLineBoundary = dSIBP`Private`timeThetaBoundaryShrinkTerms[
   threeLineTopology,
   threeLineIntegral,
   u
   ];
threeLineTripleTerms = Select[
   List @@ Expand[threeLineBoundary],
   ! FreeQ[#, J[_, {{"F"}, {"F"}, {"F"}}, {}]] &
   ];
threeLineTripleIntegral = FirstCase[
   threeLineTripleTerms,
   int : J[_, {{"F"}, {"F"}, {"F"}}, {}] :> int,
   Missing["NoTripleContact"],
   Infinity
   ];
threeLineReachable = Sort[dSIBP`Private`contactReachableShrinkSubsets[threeLineTopology]];
threeLineSeeds = DSSeeds[threeLineContext, ProgressReporting -> False];
threeLineTemplates = DSAllSeeds[threeLineSeeds];
threeLineGeneratorCoverage = Table[
   sectorTopology = dSIBP`Private`sectorTopologyForMetadata017[threeLineTopology, metadata];
   expectedGenerators = Sort[
     dSIBP`Private`dsTemplateGeneratorLabel /@
      dSIBP`Private`makeIBPGenerators[sectorTopology]
     ];
   actualGenerators = Sort@DeleteDuplicates@Lookup[
      Select[
       threeLineTemplates,
       Lookup[#, "sectorKey", ""] === metadata["sectorKey"] &
       ],
      "generator",
      {}
      ];
   <|"sectorKey" -> metadata["sectorKey"], "passQ" -> (actualGenerators === expectedGenerators),
     "expected" -> expectedGenerators, "actual" -> actualGenerators|>,
   {metadata, threeLineContext["sectors"]}
   ];


(* ::Chapter:: *)
(*Massless formula boundary*)

masslessCase = Join[
   fixedCase["H"],
   <|
    "name" -> "017MasslessFormulaPending",
    "lineData" -> {
      <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> p,
        "massType" -> "massless", "bbType" -> "exp", "nu" -> 0,
        "skType" -> "++"|>
      },
    "zeroPointRules" -> {a0[v1] -> 0, a0[v2] -> 0, b0[1] -> 0}
    |>
   ];
masslessContext = DSInit[masslessCase, RegisterAsCurrent -> False, ProgressReporting -> False];
masslessIntegral = dSIBP`Private`makeBaseIntegral[masslessContext["topology"]];
masslessFormulaResults = {
   DSTreeSeeds[masslessIntegral, masslessContext],
   repIterative[masslessIntegral, Automatic, masslessContext],
   DSTreeNaiveIBP[masslessContext],
   DSTreeNaiveDE[masslessContext],
   DSTreeDLogDE[masslessContext]
   };

invalidMasslessParityContext = DSInit[
   Join[masslessCase, <|"parityConstraints" -> {n[1, 1] + n[1, 2] -> 0}|>],
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];


(* ::Chapter:: *)
(*Assertions*)

checks = <|
   "fixedHInitialized" -> (Lookup[fixedHContext, "status", "failed"] === "initialized"),
   "fixedHTopResidualZero" -> (fixedHUpper["normalizedResidualPower"] === 0),
   "fixedHLowerResidualOne" -> (fixedHLower["normalizedResidualPower"] === 1),
   "fixedHCompiledShift" -> ({fixedHLower["compiledIntegerShift"], fixedHLower["compiledZeroPointShift"]} === {1, 2 nu}),
   "fixedHLinePackOnly" -> (fixedHIntegrals =!= {} && And @@ (MatchQ[#, J[_List, _List, _List]] & /@ fixedHIntegrals)),
   "fixedHGenerated" -> (Lookup[fixedHGenerated, "status", "failed"] === "generated"),
   "fixedHLowerDerivative" -> (fixedHLowerDerivative === 0),
   "fixedHankelLowerResidualOne" -> (fixedHankelLower["normalizedResidualPower"] === 1),
   "fixedHankelCompiledShift" -> ({fixedHankelLower["compiledIntegerShift"], fixedHankelLower["compiledZeroPointShift"]} === {1, 0}),
   "fixedOverrideResidualZero" -> (fixedOverrideLower["normalizedResidualPower"] === 0),
   "fixedOverrideProvenance" -> (fixedOverrideLower["zeroPointOverrideSource"] === "userBS0Override"),
   "fixedOverrideCoefficient" -> FreeQ[fixedOverrideBoundary, sE1],
   "fixedOverrideLowerDerivative" -> (fixedOverrideLowerDerivative === -fixedOverrideLowerIntegral/sE1),
   "fixedTreeFormulaInvariant" -> (Lookup[fixedHFormulaSeed, "treeSeed", $Failed] ===
      Lookup[fixedOverrideFormulaSeed, "treeSeed", Missing["NoTreeSeed"]]),
   "fixedTreeSeedPublic" -> (Lookup[fixedHFormulaSeed, "status", "failed"] === "generated" &&
      Lookup[fixedHFormulaSeed, "generationRoute", None] === "directPureTime" &&
      FreeQ[fixedHFormulaSeed, J[_List], Infinity] &&
      FreeQ[fixedHFormulaSeed, _dSIBP`Private`dsTreeToken, Infinity]),
   "fixedDLogPublic" -> (Lookup[fixedDLog, "status", "failed"] === "generated" &&
      TrueQ[Lookup[Lookup[fixedDLog, "publicRepresentationAudit", <||>], "passQ", False]]),
   "fixedNaivePublic" -> (Lookup[fixedNaive, "status", "failed"] === "solved" &&
      TrueQ[Lookup[Lookup[fixedNaive, "publicRepresentationAudit", <||>], "passQ", False]]),
   "fixedNaiveDEPublic" -> (Lookup[fixedNaiveDE, "status", "failed"] === "generated" &&
      TrueQ[Lookup[Lookup[fixedNaiveDE, "publicRepresentationAudit", <||>], "passQ", False]]),
   "fixedIterativePublic" -> (Lookup[fixedIterative, "status", "failed"] === "reduced" &&
      FreeQ[fixedIterative, J[_List], Infinity] &&
      FreeQ[fixedIterative, _dSIBP`Private`dsTreeToken, Infinity]),
   "integerRebaseInitialized" -> (Lookup[integerRebaseContext, "status", "failed"] === "initialized"),
   "integerRebaseParityFlip" -> MemberQ[integerRebaseConstraints, 1 + bS[1]],
   "integerRebaseMetadata" -> (dSIBP`Private`lineBSZeroPoint[integerRebaseChildTopology, 1] === 1),
   "nonIntegerRebaseRejected" -> (Lookup[nonIntegerRebaseContext, "status", "initialized"] === "failed" &&
      Lookup[nonIntegerRebaseContext, "reason", ""] === "invalidParityConstraints"),
   "threeLineInitialized" -> (Lookup[threeLineContext, "status", "failed"] === "initialized"),
   "threeLineReachableSectors" -> (threeLineReachable === Sort[{{1}, {2}, {3}, {1, 2, 3}}]),
   "threeLineTriplePresent" -> (Length[threeLineTripleTerms] === 1),
   "threeLineTripleShift" -> (threeLineTripleIntegral === J[{a[u] + a[v] - 3}, {{"F"}, {"F"}, {"F"}}, {}]),
   "threeLineGeneratorCoverage" -> And @@ Lookup[threeLineGeneratorCoverage, "passQ", {False}],
   "masslessFormulaPending" -> And @@ (Lookup[#, "status", ""] === "PendingRederivation" & /@ masslessFormulaResults),
   "masslessParityRejected" -> (Lookup[invalidMasslessParityContext, "status", "initialized"] === "failed" &&
      Lookup[invalidMasslessParityContext, "reason", ""] === "invalidParityConstraints")
   |>;

failed = Keys@Select[checks, Not];
Print[<|
  "passed" -> Count[Values[checks], True],
  "total" -> Length[checks],
  "failed" -> failed,
  "fixedResidualPowers" -> Lookup[
    {fixedHLower, fixedHankelLower, fixedOverrideLower},
    "normalizedResidualPower"
    ],
  "fixedLowerDerivatives" -> {fixedHLowerDerivative, fixedOverrideLowerDerivative},
  "fixedTreePublicStatus" -> <|
    "seed" -> Lookup[fixedHFormulaSeed, "status", "failed"],
    "iterative" -> {Lookup[fixedIterative, "status", "failed"], Lookup[fixedIterative, "reason", None]},
    "naiveIBP" -> {Lookup[fixedNaive, "status", "failed"],
      Length@Lookup[Lookup[fixedNaive, "publicRepresentationAudit", <||>], "legacyVertexIntegrals", {}],
      Length@Lookup[Lookup[fixedNaive, "publicRepresentationAudit", <||>], "privateTreeTokens", {}]},
    "naiveDE" -> {Lookup[fixedNaiveDE, "status", "failed"],
      Length@Lookup[Lookup[fixedNaiveDE, "publicRepresentationAudit", <||>], "legacyVertexIntegrals", {}],
      Length@Lookup[Lookup[fixedNaiveDE, "publicRepresentationAudit", <||>], "privateTreeTokens", {}]},
    "dlogDE" -> {Lookup[fixedDLog, "status", "failed"],
      Length@Lookup[Lookup[fixedDLog, "publicRepresentationAudit", <||>], "legacyVertexIntegrals", {}],
      Length@Lookup[Lookup[fixedDLog, "publicRepresentationAudit", <||>], "privateTreeTokens", {}]}
    |>,
  "integerRebaseConstraints" -> integerRebaseConstraints,
  "nonIntegerRebase" -> KeyTake[nonIntegerRebaseContext, {"status", "reason", "parityFailures"}],
  "threeLineTripleTerm" -> threeLineTripleTerms,
  "threeLineReachable" -> threeLineReachable,
  "threeLineGeneratorCoverage" -> threeLineGeneratorCoverage,
  "masslessFormulaStatus" -> (KeyTake[#, {"operation", "status", "reason"}] & /@ masslessFormulaResults),
  "checks" -> checks
  |>];

Exit[If[failed === {}, 0, 1]];
