(* ::Package:: *)
(* 015 根号动力学坐标示例：检查缺省提案、初始化 ssij/sEe，并对带参量系数的积分组合求总导数。 *)

(* ::Chapter:: *)
(*加载标准 package*)

exampleDir = DirectoryName[$InputFileName];
packageDir = ExpandFileName[FileNameJoin[{exampleDir, "..", "..", "..", "..", "000_code", "015_dSIBP"}]];
If[! MemberQ[$Path, packageDir], AppendTo[$Path, packageDir]];
Needs["dSIBP`"];


(* ::Chapter:: *)
(*详细物理输入*)

case = <|
   "name" -> "rootKinematicCoordinatesExample",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> e1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "nu" -> nu0, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> e2, "endpoints" -> {v1, v2}, "momentum" -> kE,
       "nu" -> nu1, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> e3, "endpoints" -> {v1, v2}, "momentum" -> 2 kE,
       "nu" -> nu2, "bbType" -> "h", "massType" -> "massive"|>
     },
   "loopMomenta" -> {q},
   "externalMomenta" -> {k},
   "externalLegMomenta" -> {kE},
   "vertexEnergies" -> <|
     v1 -> Sqrt[sp[k + kE, k + kE]],
     v2 -> Sqrt[sp[k - kE, k - kE]]
     |>,
   "ispData" -> {
     <|"name" -> rho1, "expr" -> sp[q, k], "range" -> {0}|>
     },
   "zeroPointRules" -> {},
   "numericRules" -> {
     dim -> 3, nu0 -> 1/3, nu1 -> 2/3, nu2 -> 4/3,
     ss11 -> 5, sE1 -> 7, sE2 -> 11
     },
   "symmetryRules" -> {},
   "seedPreset" -> "fullDiscrete"
   |>;


(* ::Chapter:: *)
(*变量提案*)

DSMessagesOn[];
kinematicProposal = DSKinematics[case];
kinematicProposal["selectionTemplate"]


(* ::Chapter:: *)
(*缺省选项*)

(* 缺省为 WriteInitializationFiles->False、GenerateDerivativeMetadata->False、
   OverwriteInitialization->False、RegisterAsCurrent->True、ProgressReporting->Automatic、
   KinematicRules->Automatic。后者采用上一单元格显示的缺省规则。
   可把 kinematicProposal["defaultRules"] 复制到下一行修改；保持 Automatic 即不修改。 *)
kinematicRules = Automatic;
initOptions = {
   WriteInitializationFiles -> True,
   InitializationDirectory -> FileNameJoin[{exampleDir, "init"}],
   GenerateDerivativeMetadata -> True,
   OverwriteInitialization -> True,
   ProgressReporting -> True,
   KinematicRules -> kinematicRules
   };


(* ::Chapter:: *)
(*变量提案、初始化与根号坐标 metadata*)

context = DSInit[case, Sequence @@ initOptions];
topology = Lookup[context, "topology", <||>];
derivativeVariables = Lookup[Lookup[context, "derivatives", <||>], "operators", {}][[All, "userVariable"]];


(* ::Chapter:: *)
(*带显式系数的总导数*)

integral = J[{0, 0}, {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}}, {0}];
expr = ss11^2 integral + sE1 integral + ss11 sE1;
dLoopRoot = ds[expr, ss11, topology];
dExternalLegRoot = ds[expr, sE1, topology];

summary = <|
   "version" -> $dSIBPVersion,
   "status" -> Lookup[context, "status", "missing"],
   "kinematicProposal" -> KeyTake[kinematicProposal, {"status", "defaultRules", "selectionTemplate"}],
   "loopRules" -> Lookup[topology, "externalInvariantRules", {}],
   "externalLegRules" -> Lookup[topology, "externalLegInvariantRules", {}],
   "appearingMagnitudeMomenta" -> Lookup[kinematicProposal, "appearingNoLoopMagnitudeMomenta", {}],
   "independentMagnitudeMomenta" -> Lookup[kinematicProposal, "independentNoLoopMagnitudeMomenta", {}],
   "dependentMagnitudeBindings" -> Lookup[kinematicProposal, "dependentMagnitudeBindings", {}],
   "derivativeVariables" -> derivativeVariables,
   "dBySs11" -> dLoopRoot,
   "dBySE1" -> dExternalLegRoot
   |>;

Print[InputForm[summary]];
If[! And[
    summary["version"] === "015",
    summary["status"] === "initialized",
    summary["loopRules"] === {sp[k, k] -> ss11^2},
    Last /@ summary["externalLegRules"] === {sE1^2, sE2^2},
    Length[summary["appearingMagnitudeMomenta"]] === 4,
    Length[summary["independentMagnitudeMomenta"]] === 2,
    Sort[Lookup[summary["dependentMagnitudeBindings"], "userSquaredExpression", {}]] ===
      Sort[{4 sE1^2, 2 ss11^2 + 2 sE1^2 - sE2^2}],
    summary["derivativeVariables"] === {ss11, sE1, sE2}
    ], Exit[1]];
