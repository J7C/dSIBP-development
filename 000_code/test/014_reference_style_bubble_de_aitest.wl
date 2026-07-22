(* ::Package:: *)
(* 本脚本按 codebubble/002 bubble_de.m 的顺序独立生成 pure massive bubble 的 k0/ks 微分方程，
   再把 reference 的无量纲 Kira basis 与 package 的物理 active basis 显式换基后逐项比较。
   输入只使用 reference 公式、当前 fixed-rational Kira reduction 和 package DE；输出写入 results_test。 *)

(* ::Chapter:: *)
(*路径、固定参数与公共 family*)

testDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[testDir];
projectDir = DirectoryName[codeDir];
referenceDir = FileNameJoin[{projectDir, "reference", "ref_code", "codebubble"}];
referenceFile = FileNameJoin[{referenceDir, "001 bubble_ibp_sym.m"}];
exampleDir = FileNameJoin[{projectDir, "independent-benchmark", "package", "examples", "04_pure_massive_bubble_closed_loop"}];
packageFile = FileNameJoin[{projectDir, "independent-benchmark", "package", "package_014.wl"}];
kiraDir = FileNameJoin[{projectDir, "codex-independent-benchmark", "results_temp", "real-kira-014-rational", "package", "examples", "04_pure_massive_bubble_closed_loop", "kira"}];
resultDir = FileNameJoin[{testDir, "results_test", "014_reference_style_bubble_de"}];
Quiet[CreateDirectory[resultDir, CreateIntermediateDirectories -> True]];

Get[packageFile];
Get[FileNameJoin[{exampleDir, "dlog_basis.wl"}]];
Get[FileNameJoin[{exampleDir, "family_conventions.wl"}]];

parameterProbeSeed = 20260722;
parameterProbeRules = {dim -> 37/11, nu -> 7/13, etaNu -> 23/17};
referenceParameterRules = {ep -> -2/11, nu -> 7/13};
kinematicProbeSeed = 2026072202;
kinematicProbeRules = {ks -> 43/17, P0 -> 29/13};

caseInput = <|
   "name" -> "014PureMassiveBubbleClosedLoopMinusMinus",
   "vertexData" -> {{v1, "-"}, {v2, "-"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nu|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nu|>
     },
   "loopMomenta" -> {q},
   "externalMomenta" -> {k},
   "externalInvariantRules" -> {sp[k, k] -> s11},
   "vertexEnergies" -> <|v1 -> P0, v2 -> P0|>,
   "ispData" -> {},
   "numericRules" -> parameterProbeRules,
   "zeroPointRules" -> {a0[v1] -> 2 nu, a0[v2] -> 2 nu, b0[1] -> -2 nu, b0[2] -> -2 nu},
   "shrinkPrefactorRules" -> {Exp[Pi Im[nu]]/Pi -> etaNu},
   "symmetryRules" -> exampleSymmetryRules0,
   "seedPreset" -> "quickCheck",
   "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0}, "sampleOnly" -> False|>,
   "generatorSeedRanges" -> referenceGeneratorSeedRanges,
   "seedOptions" -> <|"DiscreteMode" -> "all", "MaxSeedRuleCount" -> 5000, "MaxEquationCount" -> 100000|>
   |>;

context = DSInit[caseInput, WriteInitializationFiles -> False, GenerateDerivativeMetadata -> False];
reductionData = DSKiraImport[kiraDir, context];
packageDE = DSDE[reductionData, {s11, P0}, ProgressReporting -> False];


(* ::Chapter:: *)
(*Reference basis 与 dk0/dks 原函数*)

(* 只执行 reference 中构造 basis 和导数所需的自包含段，跳过其 IBP/Kira 写出流程。 *)
extractReferenceSection[text_String, startTitle_String, endTitle_String] := Module[{start, end},
   start = First@First@StringPosition[text, startTitle];
   end = First@First@StringPosition[text, endTitle];
   StringTake[text, {start, end - 1}]
   ];

sourceText = Import[referenceFile, "Text"];
listcal[expr_, i_, j_, shift_] := ReplacePart[expr, {i, j} -> expr[[i, j]] + shift];
SetDirectory[referenceDir];

conventionText = extractReferenceSection[
   sourceText,
   "(*Integral Substitutions & Symmetries*)",
   "(*Generating Base IBP Seeds*)"
   ];
basisText = extractReferenceSection[
   sourceText,
   "(*Constructing Master Integrals (MIs) & dlog Basis*)",
   "(*Derivatives (k0, ks)*)"
   ];
derivativeText = extractReferenceSection[
   sourceText,
   "(*Derivatives (k0, ks)*)",
   "(*Formatting Variables & Target for Kira*)"
   ];

ToExpression[conventionText];
ToExpression[basisText];
ToExpression[derivativeText];

referenceKiraBasis = Take[MIdlogKira, 19];
referencePhysicalBasis = Take[MIdlogNote, 19] /. repvar /. {
     a0 -> 2 nu, b0 -> -2 nu, d -> dim, k0 -> I P0/ks
     };


(* ::Chapter:: *)
(*Reference 导数映射与同源 Kira reduction*)

referenceToJRules = {
   G[nList_List, aList_List, bList_List] :>
    J[aList, {{bList[[1]], nList[[1]], nList[[2]]}, {bList[[2]], nList[[3]], nList[[4]]}}, {}],
   R1[nList_List, {aPower_}, bList_List] :>
    J[{aPower}, {{bList[[1]]}, {bList[[2]], nList[[1]], nList[[2]]}}, {}]
   };

referenceRawK0 = dk0[referenceKiraBasis] // id // symmetry // Expand;
referenceRawKs = dks[referenceKiraBasis] // id // symmetry // Expand;
referenceRawK0J = Expand[referenceRawK0 /. referenceToJRules /. referenceParameterRules];
referenceRawKsJ = Expand[referenceRawKs /. referenceToJRules /. referenceParameterRules];

(* package 的 - branch 使用 Ppkg=-Pref=+I k0；active basis 已在 export 前把 Pref 映射为 -P0。 *)
dimensionlessReductionRules = reductionData["reductionRules"] /. {
    Sqrt[s11] -> 1, s11 -> 1, kk[1, 1] -> 1, P0 -> I k0
    };
reduceReference[expr_] := FixedPoint[ReplaceAll[#, dimensionlessReductionRules] &, Expand[expr], 100];

referenceReducedK0 = Expand[reduceReference /@ referenceRawK0J] /. repvar /. reppara2N /. referenceParameterRules;
referenceReducedKs = Expand[reduceReference /@ referenceRawKsJ] /. repvar /. reppara2N /. referenceParameterRules;
referenceTokens = Tuserweight /@ Range[19];

matrixFromRows[rows_List, tokens_List] := Table[
   Coefficient[rows[[row]], tokens[[column]]],
   {row, Length[rows]}, {column, Length[tokens]}
   ];

referenceK0CoefficientsInPackageSlice = matrixFromRows[referenceReducedK0, referenceTokens];
referenceKsCoefficientsInPackageSlice = matrixFromRows[referenceReducedKs, referenceTokens];
referenceResidualK0 = Expand[referenceReducedK0 - referenceK0CoefficientsInPackageSlice.referenceTokens];
referenceResidualKs = Expand[referenceReducedKs - referenceKsCoefficientsInPackageSlice.referenceTokens];
sliceSignDiagonal = ConstantArray[1, 19];
sliceSignMatrix = DiagonalMatrix[sliceSignDiagonal];
referenceK0Matrix = referenceK0CoefficientsInPackageSlice.sliceSignMatrix;
referenceKsMatrix = referenceKsCoefficientsInPackageSlice.sliceSignMatrix;

packageRawP0Slice = Expand[
    Lookup[Lookup[packageDE["variableData"], P0], "rawDerivatives"] /. {
      Sqrt[s11] -> 1, s11 -> 1, kk[1, 1] -> 1, P0 -> I k0
      }
    ];
packageRawP0ReducedSlice = reduceReference /@ packageRawP0Slice;
packageP0SliceMatrix = matrixFromRows[packageRawP0ReducedSlice, referenceTokens];
rawK0ConventionDifference = Expand[
   (referenceRawK0J /. repvar /. reppara2N /. referenceParameterRules) - I sliceSignMatrix.packageRawP0Slice
   ];
reducedK0ConventionDifference = Map[Together, referenceK0Matrix - I sliceSignMatrix.packageP0SliceMatrix.sliceSignMatrix, {2}];

(* 002 的输出变量是 Pref；换到 package 的 P0=-Pref 后，P0 导数多一个负号。 *)
referenceP0KiraMatrix = Together /@ ((-I referenceK0Matrix)/ks /. k0 -> -I P0/ks);
referenceKsKiraMatrix = Together /@ (referenceKsMatrix/ks /. k0 -> -I P0/ks);

(* 002 的统一 1/ks 只适用于等齐次次数块；跨次数块必须左右共轭 degree lift。 *)
referenceSliceScaling = Map[Together, referenceKsMatrix + k0 referenceK0Matrix, {2}];
referenceDegreesKira = Diagonal[referenceSliceScaling];
referenceDegreeMatrix = DiagonalMatrix[ks^referenceDegreesKira];
referenceDegreeInverse = DiagonalMatrix[ks^(-referenceDegreesKira)];
referenceP0KiraDegreeLift = Map[Together,
   referenceDegreeMatrix.((-I referenceK0Matrix) /. k0 -> -I P0/ks).referenceDegreeInverse/ks,
   {2}
   ];
referenceKsKiraDegreeLift = Map[Together,
   referenceDegreeMatrix.(referenceKsMatrix /. k0 -> -I P0/ks).referenceDegreeInverse/ks,
   {2}
   ];


(* ::Chapter:: *)
(*无量纲 basis 与物理 basis 的显式换基*)

normalizationDiagonal = Join[ConstantArray[1, 14], {ks, ks, ks, ks}, {1}];
normalizationMatrix = DiagonalMatrix[normalizationDiagonal];
normalizationInverse = DiagonalMatrix[1/normalizationDiagonal];
normalizationDerivative = D[normalizationMatrix, ks];

positiveKsRules = {Power[ks^2, power_Rational] :> ks^(2 power)};
packageP0Matrix = (Lookup[packageDE["matrices"], P0] /. s11 -> ks^2) /. positiveKsRules;
packageKsMatrix = (2 ks Lookup[packageDE["matrices"], s11] /. s11 -> ks^2) /. positiveKsRules;

packageP0InKiraBasis = Together /@ (normalizationInverse.packageP0Matrix.normalizationMatrix);
packageKsInKiraBasis = Together /@ (
    normalizationInverse.packageKsMatrix.normalizationMatrix - normalizationInverse.normalizationDerivative
    );

referenceP0InPhysicalBasis = Together /@ (
    normalizationMatrix.referenceP0KiraMatrix.normalizationInverse
    );
referenceKsInPhysicalBasis = Together /@ (
    normalizationDerivative.normalizationInverse + normalizationMatrix.referenceKsKiraMatrix.normalizationInverse
    );

kiraBasisP0Difference = Map[Together, packageP0InKiraBasis - referenceP0KiraMatrix, {2}];
kiraBasisKsDifference = Map[Together, packageKsInKiraBasis - referenceKsKiraMatrix, {2}];
physicalBasisP0Difference = Map[Together, packageP0Matrix - referenceP0InPhysicalBasis, {2}];
physicalBasisKsDifference = Map[Together, packageKsMatrix - referenceKsInPhysicalBasis, {2}];
degreeLiftP0Difference = Map[Together, packageP0InKiraBasis - referenceP0KiraDegreeLift, {2}];
degreeLiftKsDifference = Map[Together, packageKsInKiraBasis - referenceKsKiraDegreeLift, {2}];


(* ::Chapter:: *)
(*Scaling、最终精确 probe 与诊断输出*)

referenceScalingKira = Map[Together, ks referenceKsKiraMatrix + P0 referenceP0KiraMatrix, {2}];
referenceScalingPhysical = Map[Together, ks referenceKsInPhysicalBasis + P0 referenceP0InPhysicalBasis, {2}];

(* bubble reference 本身不是完整 dlog DE；这里只对两条 DE 路线做最终精确有理点比较。 *)
kinematicProbeExpressions = Flatten[{
    packageP0InKiraBasis, referenceP0KiraDegreeLift,
    packageKsInKiraBasis, referenceKsKiraDegreeLift
    }];
kinematicProbeDenominators = DeleteDuplicates[Denominator[Together[#]] & /@ kinematicProbeExpressions];
kinematicProbeDenominatorValues = Together /@ (kinematicProbeDenominators /. kinematicProbeRules);
kinematicProbeNonsingularQ = And @@ (TrueQ[# =!= 0] & /@ kinematicProbeDenominatorValues);
kinematicProbeP0Difference = Map[
   Together,
   (packageP0InKiraBasis /. kinematicProbeRules) - (referenceP0KiraDegreeLift /. kinematicProbeRules),
   {2}
   ];
kinematicProbeKsDifference = Map[
   Together,
   (packageKsInKiraBasis /. kinematicProbeRules) - (referenceKsKiraDegreeLift /. kinematicProbeRules),
   {2}
   ];

nonzeroCount[matrix_] := Count[Flatten[matrix], value_ /; ! TrueQ[value === 0]];
firstNonzero[matrix_] := Take[Position[matrix, value_ /; ! TrueQ[value === 0], {2}, Heads -> False], UpTo[8]];

summary = <|
   "status" -> If[
     referenceResidualK0 === ConstantArray[0, 19] && referenceResidualKs === ConstantArray[0, 19] &&
      nonzeroCount[rawK0ConventionDifference] === 0 &&
      nonzeroCount[reducedK0ConventionDifference] === 0 &&
      nonzeroCount[degreeLiftP0Difference] === 0 && nonzeroCount[degreeLiftKsDifference] === 0 &&
      kinematicProbeNonsingularQ &&
      nonzeroCount[kinematicProbeP0Difference] === 0 && nonzeroCount[kinematicProbeKsDifference] === 0,
     "passed", "failed"
     ],
   "parameterProbeSeed" -> parameterProbeSeed,
   "parameterProbeRules" -> parameterProbeRules,
   "kinematicProbeSeed" -> kinematicProbeSeed,
   "kinematicProbeRules" -> kinematicProbeRules,
   "kinematicProbeS11Rule" -> (s11 -> (ks^2 /. kinematicProbeRules)),
   "kinematicProbeNonsingular" -> kinematicProbeNonsingularQ,
   "kinematicProbeDenominatorValues" -> kinematicProbeDenominatorValues,
   "kinematicProbeP0DifferenceNonzero" -> nonzeroCount[kinematicProbeP0Difference],
   "kinematicProbeKsDifferenceNonzero" -> nonzeroCount[kinematicProbeKsDifference],
   "basisNormalizationDiagonal" -> normalizationDiagonal,
   "referenceResidualK0Count" -> nonzeroCount[referenceResidualK0],
   "referenceResidualKsCount" -> nonzeroCount[referenceResidualKs],
   "rawK0ConventionDifferenceNonzero" -> nonzeroCount[rawK0ConventionDifference],
   "rawK0ConventionFirstNonzero" -> firstNonzero[rawK0ConventionDifference],
   "reducedK0ConventionDifferenceNonzero" -> nonzeroCount[reducedK0ConventionDifference],
   "kiraBasisP0DifferenceNonzero" -> nonzeroCount[kiraBasisP0Difference],
   "kiraBasisKsDifferenceNonzero" -> nonzeroCount[kiraBasisKsDifference],
   "physicalBasisP0DifferenceNonzero" -> nonzeroCount[physicalBasisP0Difference],
   "physicalBasisKsDifferenceNonzero" -> nonzeroCount[physicalBasisKsDifference],
   "degreeLiftP0DifferenceNonzero" -> nonzeroCount[degreeLiftP0Difference],
   "degreeLiftKsDifferenceNonzero" -> nonzeroCount[degreeLiftKsDifference],
   "degreeLiftP0FirstNonzero" -> firstNonzero[degreeLiftP0Difference],
   "degreeLiftKsFirstNonzero" -> firstNonzero[degreeLiftKsDifference],
   "kiraBasisP0FirstNonzero" -> firstNonzero[kiraBasisP0Difference],
   "kiraBasisKsFirstNonzero" -> firstNonzero[kiraBasisKsDifference],
   "referenceScalingKiraDiagonal" -> Diagonal[referenceScalingKira],
   "referenceScalingKiraOffDiagonalNonzero" -> nonzeroCount[referenceScalingKira - DiagonalMatrix[Diagonal[referenceScalingKira]]],
   "referenceScalingPhysicalDiagonal" -> Diagonal[referenceScalingPhysical],
   "referenceScalingPhysicalOffDiagonalNonzero" -> nonzeroCount[referenceScalingPhysical - DiagonalMatrix[Diagonal[referenceScalingPhysical]]]
   |>;

Put[summary, FileNameJoin[{resultDir, "summary.wl"}]];
Put[<|"P0" -> kiraBasisP0Difference, "ks" -> kiraBasisKsDifference|>, FileNameJoin[{resultDir, "kira_basis_differences.wl"}]];
Put[<|"P0" -> physicalBasisP0Difference, "ks" -> physicalBasisKsDifference|>, FileNameJoin[{resultDir, "physical_basis_differences.wl"}]];
Put[<|"P0" -> degreeLiftP0Difference, "ks" -> degreeLiftKsDifference|>, FileNameJoin[{resultDir, "degree_lift_differences.wl"}]];
Put[<|"P0" -> kinematicProbeP0Difference, "ks" -> kinematicProbeKsDifference|>, FileNameJoin[{resultDir, "kinematic_probe_differences.wl"}]];
Put[<|"P0" -> referenceP0KiraMatrix, "ks" -> referenceKsKiraMatrix|>, FileNameJoin[{resultDir, "reference_kira_basis_de.wl"}]];
Put[rawK0ConventionDifference, FileNameJoin[{resultDir, "raw_k0_convention_differences.wl"}]];
Put[reducedK0ConventionDifference, FileNameJoin[{resultDir, "reduced_k0_convention_differences.wl"}]];

Print[KeyDrop[summary, {"referenceScalingKiraDiagonal", "referenceScalingPhysicalDiagonal", "kinematicProbeDenominatorValues"}]];
If[summary["status"] =!= "passed", Exit[1]];
