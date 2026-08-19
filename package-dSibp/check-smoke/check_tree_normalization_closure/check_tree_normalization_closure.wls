(* ::Package:: *)
(* 文件用途：验证 tree normalized master 的物理 sector prefactor、Wronskian 连续幂吸收、
   naive/direct DE 乘积法则与默认有理闭合。Expected 只由当前函数系统和 metadata 生成，
   不读取论文矩阵；输出仅用于维护侧 smoke，不是独立检验结果。 *)


(* ::Chapter:: *)
(*加载当前模块与两顶点 case*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "_harness.wls"}]];
projectRoot = DirectoryName[DirectoryName[DirectoryName[$InputFileName]]];
dsSmokeLoadPackage[FileNameJoin[{projectRoot, "versions", "022_dSIBP", "Kernel", "dSIBP.wl"}]];
DSMessagesOff[];

caseInput = <|
   "name" -> "CheckTreeNormalizationClosure",
   "vertices" -> {
     <|"id" -> v1, "vertexType" -> "+", "externalLegEnergy" -> E1|>,
     <|"id" -> v2, "vertexType" -> "+", "externalLegEnergy" -> E2|>
     },
   "lines" -> {
     <|"id" -> 1, "massType" -> "massive", "endpoints" -> {v1, v2},
       "momentum" -> p12, "nu" -> nu1|>
     },
   "loopMomenta" -> {},
   "loopExternalMomenta" -> {},
   "independentExternalMomenta" -> {p12},
   "ibpMode" -> "timeOnly",
   "ispData" -> {},
   "zeroPointRules" -> {a0[v1] -> nu0, a0[v2] -> nu0, b0[1] -> 0},
   "symmetryRules" -> {}
   |>;

context = DSInit[caseInput, RegisterAsCurrent -> False, ProgressReporting -> False];
dlog = DSTreeDLogDE[context, AuditLevel -> "full"];
masters = Lookup[dlog, "masters", {}];
child = SelectFirst[masters, Lookup[#, "sectorKey", None] === "0" &, Missing["NoChild"]];
normalizationRecords = Lookup[dlog, "masterNormalizationRecords", <||>];
childNormalizationRecord = Lookup[
   normalizationRecords,
   "0",
   Missing["NoChildNormalizationRecord"]
   ];
naiveIBP = DSTreeNaiveIBP[context, masters, ProgressReporting -> False];
naiveDE = DSTreeNaiveDE[naiveIBP, {E1, E2, sE1}, ProgressReporting -> False];


(* ::Chapter:: *)
(*从函数系统生成 expected 并逐项核对*)

childSelector = Lookup[child, "coefficient", Missing["NoSelector"]];
childPhysical = Lookup[
   childNormalizationRecord,
   "physicalSectorPrefactor",
   Missing["NoPhysicalPrefactor"]
   ];
childComplete = Lookup[
   childNormalizationRecord,
   "completeNormalization",
   Missing["NoCompleteNormalization"]
   ];
childMetadata = SelectFirst[
   Lookup[context, "sectors", {}], Lookup[#, "sectorKey", None] === "0" &,
   Missing["NoChildMetadata"]
   ];
childMetadataPrefactor = If[
   AssociationQ[childMetadata],
   dSIBP`Private`materializeSectorPrefactor018[childMetadata["sectorPrefactorData"]],
   Missing["NoChildMetadataPrefactor"]
   ];
missingStructuralPrefactor = If[
   AssociationQ[childMetadata],
   dSIBP`Private`materializeSectorPrefactor018[
     KeyDrop[childMetadata["sectorPrefactorData"], "kEPower"]
     ],
   Missing["NoChildMetadataPrefactor"]
   ];
childLogDerivative = If[
   Head[childComplete] === Missing,
   Missing["NoChildLogDerivative"],
   FullSimplify[D[Log[childComplete], sE1]]
   ];
directMatrices = Association@Table[
   variable -> D[dlog["omega"], variable],
   {variable, {E1, E2, sE1}}
   ];
directChildDiagonal = Lookup[directMatrices, sE1, {}][[5, 5]];
naiveChildDiagonal = Lookup[naiveDE["matrices"], sE1, {}][[5, 5]];
allDerivativeMatrices = Join[Values[directMatrices], Values[naiveDE["matrices"]]];
ibpReductionCoefficients = Lookup[
   Flatten[Lookup[Lookup[naiveIBP, "reductions", {}], "rhsTerms", {}]],
   "coefficient",
   {}
   ];
kinematicVariables = {E1, E2, sE1};
forbiddenContinuousPowersInIBP = DeleteDuplicates@Cases[
    ibpReductionCoefficients,
    Power[base_, exponent_] /; MemberQ[kinematicVariables, base] && ! FreeQ[exponent, nu1],
    Infinity
    ];
forbiddenContinuousPowersInDE = DeleteDuplicates@Cases[
    allDerivativeMatrices,
    Power[base_, exponent_] /; MemberQ[kinematicVariables, base] && ! FreeQ[exponent, nu1],
    Infinity
    ];

checks = <|
   "initialized" -> (Lookup[context, "status", "failed"] === "initialized"),
   "dlogGenerated" -> (Lookup[dlog, "status", "failed"] === "generated"),
   "naiveIBPSolved" -> (Lookup[naiveIBP, "status", "failed"] === "solved"),
   "naiveDEGenerated" -> (Lookup[naiveDE, "status", "failed"] === "generated"),
   "childSelectorIsRationalContact" -> TrueQ[FullSimplify[childSelector + 1/sE1] === 0],
   "childPhysicalMatchesMetadata" -> TrueQ[FullSimplify[childPhysical - childMetadataPrefactor] === 0],
   "missingStructuralKEPowerRejected" -> MatchQ[
      missingStructuralPrefactor,
      Failure["MissingStructuralKEPower", _Association]
      ],
   "completeNormalizationProductRule" ->
    TrueQ[FullSimplify[childComplete - childSelector childPhysical] === 0],
   "childLogDerivativeContainsNu" ->
    TrueQ[FullSimplify[childLogDerivative + (2 nu1 + 1)/sE1] === 0],
   "directChildDiagonalCorrect" ->
    TrueQ[FullSimplify[directChildDiagonal + (2 nu1 + 1)/sE1] === 0],
   "naiveChildDiagonalCorrect" ->
    TrueQ[FullSimplify[naiveChildDiagonal + (2 nu1 + 1)/sE1] === 0],
   "naiveDirectAgree" -> And @@ Flatten[
      Table[TrueQ[FullSimplify[
        Lookup[naiveDE["matrices"], variable] - Lookup[directMatrices, variable]
        ] === ConstantArray[0, {5, 5}]], {variable, {E1, E2, sE1}}]
      ],
   "noContinuousPowerInIBP" -> (forbiddenContinuousPowersInIBP === {}),
   "noContinuousPowerInDE" -> (forbiddenContinuousPowersInDE === {})
   |>;

dsSmokeSummary[
  checks,
  "check_tree_normalization_closure",
  <|
   "childSelector" -> childSelector,
   "childPhysical" -> childPhysical,
   "childComplete" -> childComplete,
   "missingStructuralPrefactor" -> missingStructuralPrefactor,
   "childLogDerivative" -> childLogDerivative,
   "directChildDiagonal" -> directChildDiagonal,
   "naiveChildDiagonal" -> naiveChildDiagonal,
   "forbiddenContinuousPowersInIBP" -> forbiddenContinuousPowersInIBP,
   "forbiddenContinuousPowersInDE" -> forbiddenContinuousPowersInDE
   |>
  ];
