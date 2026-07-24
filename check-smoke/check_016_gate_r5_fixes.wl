(* ::Package:: *)
(* 本脚本轻量验证 Gate R5 的四项维护修复：复合独立外动量编号、atomic massless
   timeOnly 的公开 DSSeeds/DSLinear、失败 capability 归一化和标准两圈 sunrise authority。
   它只加载当前模块源码，不读取独立审计 expected，也不写正式结果。 *)

(* ::Chapter:: *)
(*加载当前模块*)

smokeDir = DirectoryName[$InputFileName];
projectDir = DirectoryName[smokeDir];
packageDir = FileNameJoin[{projectDir, "000_code", "016_dSIBP"}];
packageOverride = Quiet[Environment["DSIBP_PACKAGE_FILE"]];
If[StringQ[packageOverride] && StringLength[StringTrim[packageOverride]] > 0,
  Get[ExpandFileName[packageOverride]],
  If[! MemberQ[$Path, packageDir], AppendTo[$Path, packageDir]];
  Needs["dSIBP`"]
  ];
DSMessagesOff[];


(* ::Chapter:: *)
(*固定输入*)

energyCaseC = <|
   "name" -> "SmokeEnergyCaseC",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> ell-k1,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> ell-k2,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "loopMomenta" -> {ell},
   "loopExternalMomenta" -> {k1, k2},
   "independentExternalMomenta" -> {p1+p2, p2},
   "ibpMode" -> "full",
   "vertexEnergies" -> <|
     v1 -> Sqrt[sp[p1+p2, p1+p2]],
     v2 -> Sqrt[sp[p2, p2]]
     |>,
   "ispData" -> {<|"name" -> rho1, "expr" -> sp[ell, k1], "range" -> {0, 1}|>},
   "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta1, b0[2] -> beta2},
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;


atomicMasslessCase = <|
   "name" -> "SmokeAtomicMasslessTimeOnly",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> p,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "loopMomenta" -> {},
   "loopExternalMomenta" -> {},
   "independentExternalMomenta" -> {p},
   "ibpMode" -> "timeOnly",
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "ispData" -> {},
   "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta1},
   "symmetryRules" -> {},
   "seedPreset" -> "fullDiscrete"
   |>;


sunriseTwoLoopCase = <|
   "name" -> "SmokeMasslessSunriseTwoLoop",
   "vertexData" -> {{v1, "-"}, {v2, "-"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q1,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q2,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> 3, "endpoints" -> {v1, v2}, "momentum" -> k-q1-q2,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "loopMomenta" -> {q1, q2},
   "loopExternalMomenta" -> {k},
   "independentExternalMomenta" -> {},
   "ibpMode" -> "full",
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "ispData" -> {
     <|"name" -> rho1, "expr" -> sp[q1, k], "range" -> {0, 1}|>,
     <|"name" -> rho2, "expr" -> sp[q2, k], "range" -> {0, 1}|>
     },
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2,
     b0[1] -> beta1, b0[2] -> beta2, b0[3] -> beta3
     },
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;


(* ::Chapter:: *)
(*执行公开工作流*)

energyKinematics = DSKinematics[energyCaseC];
energyContext = DSInit[energyCaseC, RegisterAsCurrent -> False, ProgressReporting -> False];

atomicContext = DSInit[atomicMasslessCase, RegisterAsCurrent -> False, ProgressReporting -> False];
atomicSeeds = DSSeeds[
   atomicContext,
   ProgressReporting -> False
   ];
atomicLinear = DSLinear[atomicSeeds, atomicContext, ProgressReporting -> False];

undercompleteRules = {
   sp[k1, k1] -> ss11^2,
   sp[k1, k2] -> ss12^2,
   sp[k2, k2] -> ss22^2,
   sp[p1+p2, p1+p2] -> sE1^2
   };
failedKinematics = DSKinematics[energyCaseC, undercompleteRules];
failedContext = DSInit[
   energyCaseC,
   KinematicRules -> undercompleteRules,
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];

sunriseContext = DSInit[sunriseTwoLoopCase, RegisterAsCurrent -> False, ProgressReporting -> False];
sunriseGenerators = If[
   Lookup[sunriseContext, "status", "failed"] === "initialized",
   dSIBP`Private`makeIBPGenerators[sunriseContext["topology"]],
   {}
   ];
sunriseMomentumGenerators = Select[sunriseGenerators, Lookup[#, "type", None] === "momentum" &];
sunriseScalarProductData = If[
   Lookup[sunriseContext, "status", "failed"] === "initialized",
   dSIBP`Private`makeScalarProductData[sunriseContext["topology"]],
   <||>
   ];
sunriseScalarProductRules = If[
   Lookup[sunriseContext, "status", "failed"] === "initialized",
   dSIBP`Private`makeScalarProductRules[sunriseContext["topology"]],
   <||>
   ];
sunriseQ1Q2Rule = SelectFirst[
   Lookup[sunriseScalarProductRules, "userRepSP2Z", {}],
   SameQ[First[#], sp[q1, q2]] &,
   Missing["NotFound"]
   ];


(* ::Chapter:: *)
(*结构断言*)

atomicDiscreteRules = DeleteDuplicates@Flatten[
    Lookup[Lookup[atomicSeeds, "equations", {}], "discreteRules", {}]
    ];
atomicSectorKeys = Sort@Lookup[Lookup[atomicSeeds, "sectorMetadataList", {}], "sectorKey", {}];
disabledCapabilities = dSIBP`Private`dsDisabledCapabilities[];

checks = <|
   "energyCaseCComplete" -> Lookup[energyKinematics, "status", "failed"] === "complete",
   "energyCaseCVariables" -> Sort[Lookup[energyKinematics, "selectedUserVariables", {}]] ===
     Sort[{ss11, ss12, ss22, sE1, sE2}],
   "energyCaseCInitialized" -> Lookup[energyContext, "status", "failed"] === "initialized",
   "atomicSeedsGenerated" -> Lookup[atomicSeeds, "status", "failed"] === "generated",
   "atomicRepresentation" -> Lookup[atomicSeeds, "representation", None] ===
     "J[timePowers,linePacks,isp]",
   "atomicStates" -> SubsetQ[atomicDiscreteRules, {n[1] -> 0, n[1] -> 1}],
   "atomicSectors" -> atomicSectorKeys === {"e1", "top"},
   "atomicLinearGenerated" -> Lookup[atomicLinear, "status", "failed"] === "generated",
   "failedKinematicsCapabilities" -> Lookup[failedKinematics, "capabilities", <||>] === disabledCapabilities,
   "failedContextCapabilities" -> Lookup[failedContext, "capabilities", <||>] === disabledCapabilities,
   "failedNestedCapabilities" -> Lookup[Lookup[failedContext, "topologyData", <||>], "capabilities", <||>] ===
     disabledCapabilities,
   "sunriseInitialized" -> Lookup[sunriseContext, "status", "failed"] === "initialized",
   "sunriseGraphLoopCount" -> Lookup[Lookup[sunriseContext, "topology", <||>], "graphLoopCount", Missing[]] === 2,
   "sunriseLoopExternalCount" -> Lookup[Lookup[sunriseContext, "topology", <||>], "nK", Missing[]] === 1,
   "sunriseMomentumGeneratorCount" -> Length[sunriseMomentumGenerators] === 6,
   "sunriseISPCount" -> Lookup[sunriseScalarProductData, "ispCount", Missing[]] === 2,
   "sunriseScalarProductCount" -> Lookup[sunriseScalarProductData, "spCount", Missing[]] === 5,
   "sunriseScalarProductDirections" -> Sort[Lookup[sunriseScalarProductData, "scalarProducts", {}]] ===
     Sort[{sp[q1, q1], sp[q1, q2], sp[q2, q2], sp[q1, k], sp[q2, k]}],
   "sunriseCoordinateCount" -> TrueQ[Lookup[sunriseScalarProductData, "coordinateCountQ", False]],
   "sunriseCoordinateSolve" -> Lookup[sunriseScalarProductRules, "status", "failed"] === "computed",
   "sunriseQ1Q2Solve" -> MatchQ[sunriseQ1Q2Rule, _Rule] &&
     Expand[
       Last[sunriseQ1Q2Rule] -
        (dSIBP`Private`z[3]-ss11^2-dSIBP`Private`z[1]-dSIBP`Private`z[2]+2 rho[1]+2 rho[2])/2
       ] === 0,
   "sunriseValidationExact" -> Lookup[
      Lookup[Lookup[sunriseContext, "topology", <||>], "validationReport", <||>],
      "errorCount",
      1
      ] === 0
   |>;

Print["016 Gate R5 smoke: ", Count[Values[checks], True], "/", Length[checks]];
If[! And @@ Values[checks],
 Print["FAILED: ", Keys@Select[checks, ! TrueQ[#] &]];
 Print["energy variables: ", Lookup[energyKinematics, "selectedUserVariables", Missing[]]];
 Print["atomic status: ", Lookup[atomicSeeds, {"status", "representation", "equationCount"}, Missing[]]];
 Print["atomic discrete rules: ", atomicDiscreteRules];
 Print["atomic sectors: ", atomicSectorKeys];
 Print["atomic forbidden: ", Lookup[atomicSeeds, "forbiddenNData", Missing[]]];
 Print["atomic forbidden entries: ", Select[
    Lookup[atomicSeeds, "equations", {}],
    Lookup[#, "forbiddenNData", {}] =!= {} &
    ]];
 Print["atomic linear: ", Lookup[atomicLinear, {"status", "reason", "equationCount"}, Missing[]]];
 Print["atomic coverage: ", Lookup[atomicLinear, "seedCoverageReport", Missing[]]];
 Print["failed capabilities: ", Lookup[failedContext, "capabilities", Missing[]]];
 Print["sunrise status: ", Lookup[sunriseContext, {"status", "reason"}, Missing[]]];
 Print["sunrise generators: ", sunriseMomentumGenerators];
 Print["sunrise scalar products: ", sunriseScalarProductData];
 Print["sunrise scalar-product rules: ", sunriseScalarProductRules];
 Print["sunrise validation: ", Lookup[Lookup[sunriseContext, "topology", <||>], "validationReport", Missing[]]];
 Exit[1]
 ];

Exit[0];
