(* ::Package:: *)
(* ds_total_derivative：比较公开 ds 总导数与独立乘积法则 expected。*)

(* ::Chapter:: *)
(*初始化*)

exampleDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[DirectoryName[exampleDir]];
handDerivedDir = FileNameJoin[{codeDir, "test", "012_hand-derived", "ds_total_derivative"}];
Get[FileNameJoin[{codeDir, "012_dS_ibp_general.wl"}]];
Get[FileNameJoin[{handDerivedDir, "family.wl"}]];
Get[FileNameJoin[{handDerivedDir, "expected.wl"}]];

topo = parseTopology[makeDSTotalDerivativeCase[]];
integrals = makeDSTotalDerivativeIntegrals[topo];
j0 = integrals["J0"];
j1 = integrals["J1"];
coefficient0 = s11^2 + 3/s11;
linearExpression = coefficient0 j0 + s11 j1 + 1 + s11^3;


(* ::Chapter:: *)
(*逐项交叉检查*)

actualSingle = ds[j0, s11, topo];
expectedSingle = expectedDSIntegral[j0, s11];
singlePassQ = TrueQ[Expand[actualSingle - expectedSingle] === 0];

actualProduct = ds[coefficient0 j0, s11, topo];
expectedProduct = expectedDSProduct[coefficient0, j0, s11];
productPassQ = TrueQ[Expand[actualProduct - expectedProduct] === 0];

setIBPTopologyContext[topo];
actualLinear = ds[linearExpression, s11];
clearIBPTopologyContext[];
expectedLinear = expectedDSLinearCombination[j0, j1, s11];
linearPassQ = TrueQ[Expand[actualLinear - expectedLinear] === 0];

explicitCoefficientContribution = Expand[actualProduct - coefficient0 actualSingle];
coefficientPassQ = TrueQ[
   Expand[explicitCoefficientContribution - D[coefficient0, s11] j0] === 0
   ];

externalVariablePassQ = TrueQ[
   Lookup[publicIndependentVariableDerivativeData[topo], "userVariable"] === {s11} &&
    FreeQ[actualLinear, kk]
   ];

internalVariableRejectedQ = TrueQ[Quiet[ds[j0, kk[1, 1], topo]] === $Failed];
unknownVariableRejectedQ = TrueQ[Quiet[ds[j0, notInitialized, topo]] === $Failed];
nonlinearRejectedQ = TrueQ[Quiet[ds[j0 j1, s11, topo]] === $Failed];
canonicalPassQ = TrueQ[! containsForbiddenNQ[topo, actualLinear]];


(* ::Chapter:: *)
(*汇总*)

Print["ds single integral: ", singlePassQ];
Print["ds coefficient times integral: ", productPassQ];
Print["ds linear combination: ", linearPassQ];
Print["explicit coefficient derivative retained: ", coefficientPassQ];
Print["external variable representation: ", externalVariablePassQ];
Print["internal variable rejected: ", internalVariableRejectedQ];
Print["unknown variable rejected: ", unknownVariableRejectedQ];
Print["nonlinear J input rejected: ", nonlinearRejectedQ];
Print["ds result canonical: ", canonicalPassQ];

If[! And[
    singlePassQ, productPassQ, linearPassQ, coefficientPassQ,
    externalVariablePassQ, internalVariableRejectedQ, unknownVariableRejectedQ,
    nonlinearRejectedQ, canonicalPassQ
    ],
 Print["actual single: ", actualSingle];
 Print["expected single: ", expectedSingle];
 Print["actual linear: ", actualLinear];
 Print["expected linear: ", expectedLinear];
 Exit[1]
 ];
