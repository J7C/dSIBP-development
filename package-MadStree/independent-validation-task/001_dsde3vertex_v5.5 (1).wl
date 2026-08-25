(* ::Package:: *)

(* ::Title:: *)
(* Self-contained V5.5 code for 001_dsde3vertex. *)
(* Notebook-ready build: evaluating the complete file starts the Smoke
   literature-slice fixed-waypoint run because v55RunNow=True near the end. *)

(* ::Text:: *)
(* No external .wl modules or result caches; pyflint_e2_transport.py is the only companion source. *)
(* Physics object: three-vertex multi-vertex correlator with pinched subsectors. *)
(* Sector order: Top(16), LeftPinch(4), RightPinch(4), DoublePinch(1). *)
(* V5.5 production transport supports PyFLINT or pure-Wolfram fixed waypoints. *)
(* Open this file in Mathematica as a package/notebook-style source to fold sections. *)

$HistoryLength = 0;
$MaxExtraPrecision = 8000;

(* ::Section::Closed:: *)
(* ====================================================================== *)
(* Part 1A - v4.3 embedded core loader *)
(* ====================================================================== *)

ClearAll[XYZZStandaloneLoadNotebookCore];

$XYZZStandaloneCoreLoaded  =  False;

XYZZStandaloneLoadNotebookCore[] := Module[{}, 

	  If[TrueQ[$XYZZStandaloneCoreLoaded],  Return[True]];

	  M0[k_]:={{0,  - k}, {k, 0}};

	  M1[nu_]:={{0, 0}, {0,  - 2 * nu - 1}};

	  I2 = IdentityMatrix[2];

	  M02[k1_, k2_]:=KroneckerProduct[M0[k1], I2] + KroneckerProduct[I2, M0[k2]];

	  M12[nu1_, nu2_]:=KroneckerProduct[M1[nu1], I2] + KroneckerProduct[I2, M1[nu2]];

	  I4 = IdentityMatrix[4];

	  AMat[nu0_, k0_, k1_, k2_]:=M02[k1, k2] + I * k0 * I4;

	  BMat[nu0_, nu1_, nu2_]:=M12[nu1, nu2] + nu0 * I4;

	  GetReductionMatrix2Fold[nu0_, nu1_, nu2_, k0_, k1_, k2_]:=FullSimplify[ - Inverse[BMat[nu0, nu1, nu2]] . AMat[nu0, k0, k1, k2]];

	  MatrixForm[GetReductionMatrix2Fold[nu0, nu1, nu2, k0, k1, k2]];

	  Null;

	  Null;

	  T1 = 1 / Sqrt[2] {{1,  - I}, { - I, 1}};

	  T2 = KroneckerProduct[T1, T1];

	  T2Inv = Inverse[T2];

	  states = {{0, 0}, {0, 1}, {1, 0}, {1, 1}};

	  OmegaExDiag = Table[ - (a[[1]] * (2 * nu1 + 1) * Log[k1] + a[[2]] * (2 * nu2 + 1) * Log[k2]), {a, states}];

	  OmegaEx = DiagonalMatrix[OmegaExDiag];

	  OmegaTilde0Diag = Table[ - I * Log[(k0 + (2 * a[[1]] - 1) * k1 + (2 * a[[2]] - 1) * k2)], {a, states}];

	  OmegaTilde0 = DiagonalMatrix[OmegaTilde0Diag];

	  Omega2Fold[nu0_, nu1_, nu2_, k0_, k1_, k2_]:=OmegaEx - I * T2Inv . OmegaTilde0 . T2 . BMat[nu0 + 1, nu1, nu2];

	  Omega1Fold[nu0_, nu1_, k0_, k1_]:=Module[{T1, T1Inv, OmegaEx, OmegaTilde0, BMat1}, T1 = 1 / Sqrt[2] {{1,  - I}, { - I, 1}};

	  T1Inv = Inverse[T1];

	  OmegaEx = DiagonalMatrix[{0,  - (2 * nu1 + 1) * Log[k1]}];

	  OmegaTilde0 = DiagonalMatrix[{ - I Log[(k0 - k1)],  - I Log[(k0 + k1)]}];

	  BMat1 = {{nu0 + 1, 0}, {0, nu0 + 1 - 2 nu1 - 1}};

	  FullSimplify[OmegaEx - I * T1Inv . OmegaTilde0 . T1 . BMat1]];

	  Null;

	  OmegaL = Omega1Fold[nu0L, nu1, E1, s1];

	  OmegaM = Omega2Fold[nu0M, nu1, nu2, E2, s1, s2];

	  OmegaR = Omega1Fold[nu0R, nu2, E3, s2];

	  I2 = IdentityMatrix[2];

	  I4 = IdentityMatrix[4];

	  I8 = IdentityMatrix[8]; 

	  OmegaTotal = KroneckerProduct[OmegaL, I4, I2] + KroneckerProduct[I2, OmegaM, I2] + KroneckerProduct[I2, I4, OmegaR];

	  Null;

	  Id2 = IdentityMatrix[2];

	  Id4 = IdentityMatrix[4];

	  MLE1 = FullSimplify[D[OmegaL, E1]];

	  MLS1 = FullSimplify[D[OmegaL, s1]];

	  MME2 = FullSimplify[D[OmegaM, E2]];

	  MMS1 = FullSimplify[D[OmegaM, s1]];

	  MMS2 = FullSimplify[D[OmegaM, s2]];

	  MRE3 = FullSimplify[D[OmegaR, E3]];

	  MRS2 = FullSimplify[D[OmegaR, s2]];

	  MTopE1 = KroneckerProduct[MLE1, Id4, Id2];

	  MTopE2 = KroneckerProduct[Id2, MME2, Id2];

	  MTopE3 = KroneckerProduct[Id2, Id4, MRE3];

	  MTopS1 = KroneckerProduct[MLS1, Id4, Id2] + KroneckerProduct[Id2, MMS1, Id2];

	  MTopS2 = KroneckerProduct[Id2, MMS2, Id2] + KroneckerProduct[Id2, Id4, MRS2];

	  Null;

	  OmegaLeftPinch = KroneckerProduct[Omega1Fold[nu0L + nu0M, nu2, E1 + E2, s2], I2] + KroneckerProduct[I2, Omega1Fold[nu0R, nu2, E3, s2]];

	  OmegaRightPinch = KroneckerProduct[Omega1Fold[nu0L, nu1, E1, s1], I2] + KroneckerProduct[I2, Omega1Fold[nu0M + nu0R, nu1, E2 + E3, s1]];

	  OmegaDoublePinch = {{ - (nu0L + nu0M + nu0R + 1) * Log[E1 + E2 + E3]}};

	  MLeftE1 = FullSimplify[D[OmegaLeftPinch, E1]];

	  MLeftE2 = FullSimplify[D[OmegaLeftPinch, E2]];

	  MLeftE3 = FullSimplify[D[OmegaLeftPinch, E3]];

	  MLeftS1 = FullSimplify[D[OmegaLeftPinch, s1]]; 

	  MLeftS2 = FullSimplify[D[OmegaLeftPinch, s2]];

	  MRightE1 = FullSimplify[D[OmegaRightPinch, E1]];

	  MRightE2 = FullSimplify[D[OmegaRightPinch, E2]];

	  MRightE3 = FullSimplify[D[OmegaRightPinch, E3]];

	  MRightS1 = FullSimplify[D[OmegaRightPinch, s1]];

	  MRightS2 = FullSimplify[D[OmegaRightPinch, s2]];

	  MDoubleE1 = FullSimplify[D[OmegaDoublePinch, E1]];

	  MDoubleE2 = FullSimplify[D[OmegaDoublePinch, E2]];

	  MDoubleE3 = FullSimplify[D[OmegaDoublePinch, E3]];

	  MDoubleS1 = FullSimplify[D[OmegaDoublePinch, s1]];

	  MDoubleS2 = FullSimplify[D[OmegaDoublePinch, s2]];

	  CTopLeft = ConstantArray[0, {16, 4}];

	  For[i = 1, i<=4, i++, CTopLeft[[i, i]] = I;CTopLeft[[i + 4, i]] =  - I;];

	  CTopRight = ConstantArray[0, {16, 4}];

	  For[i = 1, i<=4, i++, CTopRight[[i * 2, i]] = I;];

	  CLeftDouble = {{I}, {0}, { - I}, {0}};

	  CRightDouble = {{I}, { - I}, {0}, {0}};

	  T1 = 1 / Sqrt[2] {{1,  - I}, { - I, 1}};

	  T2 = KroneckerProduct[T1, T1];

	  TTop = KroneckerProduct[T1, T2, T1];

	  TLeft = KroneckerProduct[T1, T1];

	  TRight = KroneckerProduct[T1, T1];

	  TDouble = {{1}};

	  RTopLeft = FullSimplify[(Inverse[TTop] . CTopLeft . TLeft)];

	  RTopRight = FullSimplify[(Inverse[TTop] . CTopRight . TRight)];

	  RLeftDouble = FullSimplify[(Inverse[TLeft] . CLeftDouble . TDouble)];

	  RRightDouble = FullSimplify[(Inverse[TRight] . CRightDouble . TDouble)];

	  RTopDouble = ConstantArray[0, {16, 1}];

	  Null;

	  CL = RTopLeft;

	  CR = RTopRight;

	  CLD = RLeftDouble;

	  CRD = RRightDouble;

	  CTLD = CL . CLD;

	  CTRD = CR . CRD;

	  RTopLeftE1 = MTopE1 . CL - CL . MLeftE1;

	  RTopLeftE2 = MTopE2 . CL - CL . MLeftE2;

	  RTopLeftE3 = MTopE3 . CL - CL . MLeftE3;

	  RTopLeftS1 = MTopS1 . CL - CL . MLeftS1;

	  RTopLeftS2 = MTopS2 . CL - CL . MLeftS2;

	  RTopRightE1 = MTopE1 . CR - CR . MRightE1;

	  RTopRightE2 = MTopE2 . CR - CR . MRightE2;

	  RTopRightE3 = MTopE3 . CR - CR . MRightE3;

	  RTopRightS1 = MTopS1 . CR - CR . MRightS1;

	  RTopRightS2 = MTopS2 . CR - CR . MRightS2;

	  RLeftDoubleE1 = MLeftE1 . CLD - CLD . MDoubleE1;

	  RLeftDoubleE2 = MLeftE2 . CLD - CLD . MDoubleE2;

	  RLeftDoubleE3 = MLeftE3 . CLD - CLD . MDoubleE3;

	  RLeftDoubleS1 = MLeftS1 . CLD - CLD . MDoubleS1;

	  RLeftDoubleS2 = MLeftS2 . CLD - CLD . MDoubleS2;

	  RRightDoubleE1 = MRightE1 . CRD - CRD . MDoubleE1;

	  RRightDoubleE2 = MRightE2 . CRD - CRD . MDoubleE2;

	  RRightDoubleE3 = MRightE3 . CRD - CRD . MDoubleE3;

	  RRightDoubleS1 = MRightS1 . CRD - CRD . MDoubleS1;

	  RRightDoubleS2 = MRightS2 . CRD - CRD . MDoubleS2;

	  RTopDoubleE1 = Simplify[1 / 2 * MTopE1 . CTLD - CL . MLeftE1 . CLD + 1 / 2 * CTLD . MDoubleE1 + 1 / 2 * MTopE1 . CTRD - CR . MRightE1 . CRD + 1 / 2 * CTRD . MDoubleE1];

	  RTopDoubleE2 = Simplify[1 / 2 * MTopE2 . CTLD - CL . MLeftE2 . CLD + 1 / 2 * CTLD . MDoubleE2 + 1 / 2 * MTopE2 . CTRD - CR . MRightE2 . CRD + 1 / 2 * CTRD . MDoubleE2];

	  RTopDoubleE3 = Simplify[1 / 2 * MTopE3 . CTLD - CL . MLeftE3 . CLD + 1 / 2 * CTLD . MDoubleE3 + 1 / 2 * MTopE3 . CTRD - CR . MRightE3 . CRD + 1 / 2 * CTRD . MDoubleE3];

	  RTopDoubleS1 = Simplify[1 / 2 * MTopS1 . CTLD - CL . MLeftS1 . CLD + 1 / 2 * CTLD . MDoubleS1 + 1 / 2 * MTopS1 . CTRD - CR . MRightS1 . CRD + 1 / 2 * CTRD . MDoubleS1];

	  RTopDoubleS2 = Simplify[1 / 2 * MTopS2 . CTLD - CL . MLeftS2 . CLD + 1 / 2 * CTLD . MDoubleS2 + 1 / 2 * MTopS2 . CTRD - CR . MRightS2 . CRD + 1 / 2 * CTRD . MDoubleS2];

	  Null;

	  Z16x4 = ConstantArray[0, {16, 4}];

	  Z4x16 = ConstantArray[0, {4, 16}];

	  Z4x4 = ConstantArray[0, {4, 4}];

	  Z1x16 = ConstantArray[0, {1, 16}];

	  Z1x4 = ConstantArray[0, {1, 4}];

	  MTotalE1 = ArrayFlatten[{{MTopE1, RTopLeftE1, RTopRightE1, RTopDoubleE1}, {Z4x16, MLeftE1, Z4x4, RLeftDoubleE1}, {Z4x16, Z4x4, MRightE1, RRightDoubleE1}, {Z1x16, Z1x4, Z1x4, MDoubleE1}}];

	  MTotalE2 = ArrayFlatten[{{MTopE2, RTopLeftE2, RTopRightE2, RTopDoubleE2}, {Z4x16, MLeftE2, Z4x4, RLeftDoubleE2}, {Z4x16, Z4x4, MRightE2, RRightDoubleE2}, {Z1x16, Z1x4, Z1x4, MDoubleE2}}];

	  MTotalE3 = ArrayFlatten[{{MTopE3, RTopLeftE3, RTopRightE3, RTopDoubleE3}, {Z4x16, MLeftE3, Z4x4, RLeftDoubleE3}, {Z4x16, Z4x4, MRightE3, RRightDoubleE3}, {Z1x16, Z1x4, Z1x4, MDoubleE3}}];

	  MTotalS1 = ArrayFlatten[{{MTopS1, RTopLeftS1, RTopRightS1, RTopDoubleS1}, {Z4x16, MLeftS1, Z4x4, RLeftDoubleS1}, {Z4x16, Z4x4, MRightS1, RRightDoubleS1}, {Z1x16, Z1x4, Z1x4, MDoubleS1}}];

	  MTotalS2 = ArrayFlatten[{{MTopS2, RTopLeftS2, RTopRightS2, RTopDoubleS2}, {Z4x16, MLeftS2, Z4x4, RLeftDoubleS2}, {Z4x16, Z4x4, MRightS2, RRightDoubleS2}, {Z1x16, Z1x4, Z1x4, MDoubleS2}}];

	  IntegrabilityCheck[Mi_, Mj_, vi_, vj_]:=Cancel[Together[D[Mj, vi] - D[Mi, vj] + Mi . Mj - Mj . Mi]];

	  Check1 = IntegrabilityCheck[MTotalE1, MTotalS1, E1, s1];

	  Check2 = IntegrabilityCheck[MTotalS1, MTotalS2, s1, s2];

	  PossibleZeroQ[Check1];

	  Null;

	  $XYZZStandaloneCoreLoaded  = 

	    ValueQ[MTotalS1] && Dimensions[MTotalS1]  ===  {25,  25} &&

	    Dimensions[TTop]  ===  {16,  16} &&

	    Dimensions[TLeft]  ===  {4,  4} &&

	    Dimensions[TRight]  ===  {4,  4};

	  $XYZZStandaloneCoreLoaded

];

(* ::Section::Closed:: *)
(* ====================================================================== *)
(* Part 1B - physical Schwinger-Keldysh boundary code *)
(* ====================================================================== *)

(* Independent Bunch-Davies and Schwinger-Keldysh definitions. *)

ClearAll[
  ProjectBDMode, ProjectBDModeConjugate,
  ProjectWightmanGreater, ProjectWightmanLesser,
  ProjectSKPropagator,
  ProjectPaperPropagatorNormalization, ProjectPaperWickEndpoint,
  ProjectPaperWickGreater, ProjectPaperWickLesser,
  ProjectPaperWickSKPropagator, ProjectPaperWickVertexFactor,
  ProjectPaperCrossEndpointKinds, ProjectPaperWickLineTerms,
  ProjectRawLineThresholdScales,
  ProjectPaperOneVertexIntegral, ProjectPaperSideData,
  ProjectPaperSideValue, ProjectPaperOrderedFactorizedTerm,
  ProjectRawWickH, ProjectRawWickVertexFactor,
  ProjectRawOneVertexVector, ProjectRawCrossTopVector,
  ProjectRawOrderedTerm, ProjectRawTopComponentsCachedSideData,
  ProjectRawTopComponentsCombinedSideData,
  ProjectRawTopVectorCachedSideData,
  ProjectRawTopVector, ProjectRawTopComponent,
  ProjectRawTwoVertexOrderedTerm, ProjectRawTwoVertexVector,
  ProjectPinchShift, ProjectPinchNormalization, ProjectPhysicalRawBoundary25,
  ProjectPhysicalRawBoundaryComponent25,
  ProjectPaperPPPTTLineTerms, ProjectPaperPPPTT,
  ProjectPaperSeedBranch, ProjectPaperSeedCrossFactorized,
  ProjectPaperCompleteBranchValuesByConjugation,
  ProjectPaperWickMeasureVertexFactor, ProjectPaperCompleteSKSum,
  ProjectPaperLineThresholdScales,
  ProjectPaperSeedTotal
];

ProjectBDMode[nu_?NumericQ, k_?NumericQ, tau_?NumericQ] :=
  -I Sqrt[Pi]/2 Exp[I Pi (nu/2 + 1/4)] (-tau)^(3/2)
    HankelH1[nu, -k tau];

ProjectBDModeConjugate[nu_?NumericQ, k_?NumericQ, tau_?NumericQ] :=
  Conjugate[ProjectBDMode[nu, k, tau]];

ProjectWightmanGreater[
  nu_?NumericQ, k_?NumericQ, tau1_?NumericQ, tau2_?NumericQ
] :=
  ProjectBDMode[nu, k, tau1] ProjectBDModeConjugate[nu, k, tau2];

ProjectWightmanLesser[
  nu_?NumericQ, k_?NumericQ, tau1_?NumericQ, tau2_?NumericQ
] :=
  ProjectBDModeConjugate[nu, k, tau1] ProjectBDMode[nu, k, tau2];

ProjectSKPropagator[
  {1, -1}, nu_?NumericQ, k_?NumericQ, tau1_?NumericQ, tau2_?NumericQ
] := ProjectWightmanLesser[nu, k, tau1, tau2];

ProjectSKPropagator[
  {-1, 1}, nu_?NumericQ, k_?NumericQ, tau1_?NumericQ, tau2_?NumericQ
] := ProjectWightmanGreater[nu, k, tau1, tau2];

ProjectSKPropagator[
  {1, 1}, nu_?NumericQ, k_?NumericQ, tau1_?NumericQ, tau2_?NumericQ
] := If[
  tau1 >= tau2,
  ProjectWightmanGreater[nu, k, tau1, tau2],
  ProjectWightmanLesser[nu, k, tau1, tau2]
];

ProjectSKPropagator[
  {-1, -1}, nu_?NumericQ, k_?NumericQ, tau1_?NumericQ, tau2_?NumericQ
] := If[
  tau1 >= tau2,
  ProjectWightmanLesser[nu, k, tau1, tau2],
  ProjectWightmanGreater[nu, k, tau1, tau2]
];

(* Paper Eq. (9)-(11), after z_v = I a_v y_v.  The continued
   positive-frequency argument is -ell tau = -I a_v r y_v. *)

ProjectPaperPropagatorNormalization[mu_?NumericQ] := Pi/4 Exp[-Pi mu];

ProjectPaperWickEndpoint[
  "H1", mu_?NumericQ, z_?NumericQ
] := z^(3/2) HankelH1[I mu, z];

ProjectPaperWickEndpoint[
  "H2", mu_?NumericQ, z_?NumericQ
] := z^(3/2) HankelH2[-I mu, z];

ProjectPaperWickGreater[
  mu_?NumericQ, z1_?NumericQ, z2_?NumericQ
] :=
  ProjectPaperPropagatorNormalization[mu] *
    ProjectPaperWickEndpoint["H1", mu, z1] *
    ProjectPaperWickEndpoint["H2", mu, z2];

ProjectPaperWickLesser[
  mu_?NumericQ, z1_?NumericQ, z2_?NumericQ
] :=
  ProjectPaperPropagatorNormalization[mu] *
    ProjectPaperWickEndpoint["H2", mu, z1] *
    ProjectPaperWickEndpoint["H1", mu, z2];

ProjectPaperWickSKPropagator[
  {1, -1}, mu_?NumericQ, z1_?NumericQ, z2_?NumericQ,
  y1_?NumericQ, y2_?NumericQ
] := ProjectPaperWickLesser[mu, z1, z2];

ProjectPaperWickSKPropagator[
  {-1, 1}, mu_?NumericQ, z1_?NumericQ, z2_?NumericQ,
  y1_?NumericQ, y2_?NumericQ
] := ProjectPaperWickGreater[mu, z1, z2];

ProjectPaperWickSKPropagator[
  {1, 1}, mu_?NumericQ, z1_?NumericQ, z2_?NumericQ,
  y1_?NumericQ, y2_?NumericQ
] := If[
  y1 <= y2,
  ProjectPaperWickGreater[mu, z1, z2],
  ProjectPaperWickLesser[mu, z1, z2]
];

ProjectPaperWickSKPropagator[
  {-1, -1}, mu_?NumericQ, z1_?NumericQ, z2_?NumericQ,
  y1_?NumericQ, y2_?NumericQ
] := If[
  y1 <= y2,
  ProjectPaperWickLesser[mu, z1, z2],
  ProjectPaperWickGreater[mu, z1, z2]
];

ProjectPaperWickVertexFactor[0, _Integer, y_?NumericQ] := Exp[-y];

ProjectPaperWickVertexFactor[
  power_?NumericQ, sign_Integer, y_?NumericQ
] := (-I sign y)^power Exp[-y];

ProjectPaperLineThresholdScales[
  {r1_?NumericQ, r2_?NumericQ, r3_?NumericQ, r4_?NumericQ}
] := {r2/r1, r3/r4};

ProjectRawLineThresholdScales[{e1_, e2_, e3_}] := {e1/e2, e3/e2};

ProjectPaperCrossEndpointKinds[{1, -1}] := {"H2", "H1"};
ProjectPaperCrossEndpointKinds[{-1, 1}] := {"H1", "H2"};

ProjectPaperWickLineTerms[{1, -1}] := {
  <|"LeftKind" -> "H2", "RightKind" -> "H1", "Relation" -> "None"|>
};

ProjectPaperWickLineTerms[{-1, 1}] := {
  <|"LeftKind" -> "H1", "RightKind" -> "H2", "Relation" -> "None"|>
};

ProjectPaperWickLineTerms[{1, 1}] := {
  <|"LeftKind" -> "H1", "RightKind" -> "H2", "Relation" -> "LeftLE"|>,
  <|"LeftKind" -> "H2", "RightKind" -> "H1", "Relation" -> "LeftGE"|>
};

ProjectPaperWickLineTerms[{-1, -1}] := {
  <|"LeftKind" -> "H2", "RightKind" -> "H1", "Relation" -> "LeftLE"|>,
  <|"LeftKind" -> "H1", "RightKind" -> "H2", "Relation" -> "LeftGE"|>
};

Options[ProjectPaperSeedBranch] = {
  "WorkingPrecision" -> 40,
  "AccuracyGoal" -> 20,
  "PrecisionGoal" -> 20,
  "MaxRecursion" -> 14,
  "Cutoff" -> 35,
  "LowerCutoff" -> 10^-8
};

Options[ProjectPaperSeedCrossFactorized] = Options[ProjectPaperSeedBranch];
Options[ProjectPaperSeedTotal] = Options[ProjectPaperSeedBranch];
Options[ProjectPaperPPPTT] = Options[ProjectPaperSeedBranch];
Options[ProjectRawOneVertexVector] = Options[ProjectPaperSeedBranch];
Options[ProjectRawCrossTopVector] = Options[ProjectPaperSeedBranch];
Options[ProjectRawTopComponentsCachedSideData] = Options[ProjectPaperSeedBranch];
Options[ProjectRawTopComponentsCombinedSideData] = Options[ProjectPaperSeedBranch];
Options[ProjectRawTopVectorCachedSideData] = Options[ProjectPaperSeedBranch];
Options[ProjectRawTopVector] = Options[ProjectPaperSeedBranch];
Options[ProjectRawTopComponent] = Options[ProjectPaperSeedBranch];
Options[ProjectRawTwoVertexVector] = Options[ProjectPaperSeedBranch];
Options[ProjectPhysicalRawBoundary25] = Options[ProjectPaperSeedBranch];
Options[ProjectPhysicalRawBoundaryComponent25] = Options[ProjectPaperSeedBranch];

ProjectPaperOneVertexIntegral[
  f_, wp_Integer?Positive, accuracyGoal_Integer?NonNegative,
  precisionGoal_Integer?NonNegative, maxRecursion_Integer?NonNegative
] := NIntegrate[
  f[y],
  {y, 0, Infinity},
  WorkingPrecision -> wp,
  AccuracyGoal -> accuracyGoal,
  PrecisionGoal -> precisionGoal,
  MaxRecursion -> maxRecursion,
  Method -> {"GlobalAdaptive", "SymbolicProcessing" -> 0}
];

ProjectRawWickH[
  "H1", nu_?NumericQ, 0, z_?NumericQ
] := z^(-nu) HankelH1[nu, z];

ProjectRawWickH[
  "H1", nu_?NumericQ, 1, z_?NumericQ
] := -z^(-nu) HankelH1[nu + 1, z];

ProjectRawWickH[
  "H2", nu_?NumericQ, 0, z_?NumericQ
] := z^(-nu) HankelH2[nu, z];

ProjectRawWickH[
  "H2", nu_?NumericQ, 1, z_?NumericQ
] := -z^(-nu) HankelH2[nu + 1, z];

ProjectRawWickVertexFactor[
  power_?NumericQ, sign_Integer, energy_?NumericQ, y_?NumericQ
] :=
  (-I sign/energy) (-I sign y/energy)^power Exp[-y];

ProjectRawOneVertexVector[
  power_?NumericQ,
  sign_Integer,
  energy_?NumericQ,
  legs : {___Association},
  OptionsPattern[]
] := Module[
  {wp, accuracyGoal, precisionGoal, maxRecursion, indexTuples},
  wp = OptionValue["WorkingPrecision"];
  accuracyGoal = OptionValue["AccuracyGoal"];
  precisionGoal = OptionValue["PrecisionGoal"];
  maxRecursion = OptionValue["MaxRecursion"];
  indexTuples = Tuples[{0, 1}, Length[legs]];
  Table[
    ProjectPaperOneVertexIntegral[
      Function[{y},
        ProjectRawWickVertexFactor[power, sign, energy, y] *
          Product[
            ProjectRawWickH[
              legs[[legIndex, "Kind"]],
              legs[[legIndex, "Nu"]],
              indices[[legIndex]],
              -I sign legs[[legIndex, "Momentum"]]/energy y
            ],
            {legIndex, Length[legs]}
          ]
      ],
      wp, accuracyGoal, precisionGoal, maxRecursion
    ],
    {indices, indexTuples}
  ]
];

ProjectRawCrossTopVector[
  {nu0L_?NumericQ, nu0M_?NumericQ, nu0R_?NumericQ},
  {nu1_?NumericQ, nu2_?NumericQ},
  {e1_?NumericQ, e2_?NumericQ, e3_?NumericQ},
  {s1_?NumericQ, s2_?NumericQ},
  signs : {aL_Integer, aM_Integer, aR_Integer},
  OptionsPattern[]
] /; aL != aM && aM != aR := Module[
  {line1Kinds, line2Kinds, commonOptions, left, middle, right},
  line1Kinds = ProjectPaperCrossEndpointKinds[{aL, aM}];
  line2Kinds = ProjectPaperCrossEndpointKinds[{aM, aR}];
  commonOptions = Sequence[
    "WorkingPrecision" -> OptionValue["WorkingPrecision"],
    "AccuracyGoal" -> OptionValue["AccuracyGoal"],
    "PrecisionGoal" -> OptionValue["PrecisionGoal"],
    "MaxRecursion" -> OptionValue["MaxRecursion"],
    "Cutoff" -> OptionValue["Cutoff"],
    "LowerCutoff" -> OptionValue["LowerCutoff"]
  ];
  left = ProjectRawOneVertexVector[
    nu0L, aL, e1,
    {<|"Kind" -> line1Kinds[[1]], "Nu" -> nu1, "Momentum" -> s1|>},
    commonOptions
  ];
  middle = ProjectRawOneVertexVector[
    nu0M, aM, e2,
    {
      <|"Kind" -> line1Kinds[[2]], "Nu" -> nu1, "Momentum" -> s1|>,
      <|"Kind" -> line2Kinds[[1]], "Nu" -> nu2, "Momentum" -> s2|>
    },
    commonOptions
  ];
  right = ProjectRawOneVertexVector[
    nu0R, aR, e3,
    {<|"Kind" -> line2Kinds[[2]], "Nu" -> nu2, "Momentum" -> s2|>},
    commonOptions
  ];
  Flatten@KroneckerProduct[left, middle, right]
];

ProjectRawOrderedTerm[
  {nu0L_?NumericQ, nu0M_?NumericQ, nu0R_?NumericQ},
  {nu1_?NumericQ, nu2_?NumericQ},
  {e1_?NumericQ, e2_?NumericQ, e3_?NumericQ},
  {s1_?NumericQ, s2_?NumericQ},
  {aL_Integer, aM_Integer, aR_Integer},
  line1Term_Association,
  line2Term_Association,
  {indexL_Integer, indexM1_Integer, indexM2_Integer, indexR_Integer},
  cutoff_?NumericQ, lowerCutoff_?NumericQ,
  wp_Integer?Positive, accuracyGoal_Integer?NonNegative,
  precisionGoal_Integer?NonNegative, maxRecursion_Integer?NonNegative
] := Module[
  {f1, f2, f3, leftRelation, rightRelation, leftData, rightData,
    leftScale, rightScale, upper, lower},
  f1[y_?NumericQ] :=
    ProjectRawWickVertexFactor[nu0L, aL, e1, y] *
      ProjectRawWickH[
        line1Term["LeftKind"], nu1, indexL, -I aL s1/e1 y
      ];
  f2[y_?NumericQ] :=
    ProjectRawWickVertexFactor[nu0M, aM, e2, y] *
      ProjectRawWickH[
        line1Term["RightKind"], nu1, indexM1, -I aM s1/e2 y
      ] *
      ProjectRawWickH[
        line2Term["LeftKind"], nu2, indexM2, -I aM s2/e2 y
      ];
  f3[y_?NumericQ] :=
    ProjectRawWickVertexFactor[nu0R, aR, e3, y] *
      ProjectRawWickH[
        line2Term["RightKind"], nu2, indexR, -I aR s2/e3 y
      ];
  leftRelation = Switch[
    line1Term["Relation"],
    "LeftLE", "Prefix",
    "LeftGE", "Suffix",
    _, "None"
  ];
  rightRelation = Switch[
    line2Term["Relation"],
    "LeftLE", "Suffix",
    "LeftGE", "Prefix",
    _, "None"
  ];
  leftData = ProjectPaperSideData[
    f1, leftRelation, cutoff, lowerCutoff,
    wp, accuracyGoal, precisionGoal, maxRecursion
  ];
  rightData = ProjectPaperSideData[
    f3, rightRelation, cutoff, lowerCutoff,
    wp, accuracyGoal, precisionGoal, maxRecursion
  ];
  {leftScale, rightScale} =
    ProjectRawLineThresholdScales[{e1, e2, e3}];
  upper = SetPrecision[cutoff, wp];
  lower = SetPrecision[lowerCutoff, wp];
  NIntegrate[
    f2[y] *
      ProjectPaperSideValue[leftData, leftRelation, leftScale y] *
      ProjectPaperSideValue[rightData, rightRelation, rightScale y],
    {y, 0, Infinity},
    WorkingPrecision -> wp,
    AccuracyGoal -> accuracyGoal,
    PrecisionGoal -> precisionGoal,
    MaxRecursion -> maxRecursion,
    Method -> {"GlobalAdaptive", "SymbolicProcessing" -> 0}
  ]
];

ProjectRawTopComponentsCachedSideData[
  nu0 : {nu0L_?NumericQ, nu0M_?NumericQ, nu0R_?NumericQ},
  nu : {nu1_?NumericQ, nu2_?NumericQ},
  energies : {e1_?NumericQ, e2_?NumericQ, e3_?NumericQ},
  momenta : {s1_?NumericQ, s2_?NumericQ},
  signs : {aL_Integer, aM_Integer, aR_Integer},
  components : {__Integer},
  OptionsPattern[]
] := Module[
  {wp, accuracyGoal, precisionGoal, maxRecursion, cutoff, lowerCutoff,
    line1Terms, line2Terms, leftRelations, rightRelations,
    leftData, rightData, leftScale, rightScale, indexTuples,
    requiredLeftEndpoints, requiredRightEndpoints,
    fLeft, fMiddle, fRight, integrationOptions},
  If[!And @@ (1 <= # <= 16 & /@ components), Return[$Failed]];
  If[
    aL != aM && aM != aR,
    Return@Part[
      ProjectRawCrossTopVector[
        nu0, nu, energies, momenta, signs,
        "WorkingPrecision" -> OptionValue["WorkingPrecision"],
        "AccuracyGoal" -> OptionValue["AccuracyGoal"],
        "PrecisionGoal" -> OptionValue["PrecisionGoal"],
        "MaxRecursion" -> OptionValue["MaxRecursion"],
        "Cutoff" -> OptionValue["Cutoff"],
        "LowerCutoff" -> OptionValue["LowerCutoff"]
      ],
      components
    ]
  ];
  wp = OptionValue["WorkingPrecision"];
  accuracyGoal = OptionValue["AccuracyGoal"];
  precisionGoal = OptionValue["PrecisionGoal"];
  maxRecursion = OptionValue["MaxRecursion"];
  cutoff = OptionValue["Cutoff"];
  lowerCutoff = OptionValue["LowerCutoff"];
  line1Terms = ProjectPaperWickLineTerms[signs[[1 ;; 2]]];
  line2Terms = ProjectPaperWickLineTerms[signs[[2 ;; 3]]];
  leftRelations = Replace[
    Lookup[line1Terms, "Relation"],
    {"LeftLE" -> "Prefix", "LeftGE" -> "Suffix", _ -> "None"},
    {1}
  ];
  rightRelations = Replace[
    Lookup[line2Terms, "Relation"],
    {"LeftLE" -> "Suffix", "LeftGE" -> "Prefix", _ -> "None"},
    {1}
  ];
  indexTuples = Tuples[{0, 1}, 4][[components]];
  requiredLeftEndpoints = Union[indexTuples[[All, 1]]];
  requiredRightEndpoints = Union[indexTuples[[All, 4]]];
  leftData = Table[
    Association@Table[
      fLeft[y_?NumericQ] :=
        ProjectRawWickVertexFactor[nu0L, aL, e1, y] *
          ProjectRawWickH[
            line1Terms[[termIndex, "LeftKind"]], nu1, endpointIndex,
            -I aL s1/e1 y
          ];
      endpointIndex -> ProjectPaperSideData[
        fLeft, leftRelations[[termIndex]], cutoff, lowerCutoff,
        wp, accuracyGoal, precisionGoal, maxRecursion
      ],
      {endpointIndex, requiredLeftEndpoints}
    ],
    {termIndex, Length[line1Terms]}
  ];
  rightData = Table[
    Association@Table[
      fRight[y_?NumericQ] :=
        ProjectRawWickVertexFactor[nu0R, aR, e3, y] *
          ProjectRawWickH[
            line2Terms[[termIndex, "RightKind"]], nu2, endpointIndex,
            -I aR s2/e3 y
          ];
      endpointIndex -> ProjectPaperSideData[
        fRight, rightRelations[[termIndex]], cutoff, lowerCutoff,
        wp, accuracyGoal, precisionGoal, maxRecursion
      ],
      {endpointIndex, requiredRightEndpoints}
    ],
    {termIndex, Length[line2Terms]}
  ];
  {leftScale, rightScale} =
    ProjectRawLineThresholdScales[energies];
  integrationOptions = {
    WorkingPrecision -> wp,
    AccuracyGoal -> accuracyGoal,
    PrecisionGoal -> precisionGoal,
    MaxRecursion -> maxRecursion,
    Method -> {"GlobalAdaptive", "SymbolicProcessing" -> 0}
  };
  Table[
    Total@Flatten@Table[
      fMiddle[y_?NumericQ] :=
        ProjectRawWickVertexFactor[nu0M, aM, e2, y] *
          ProjectRawWickH[
            line1Terms[[line1Index, "RightKind"]], nu1,
            indices[[2]], -I aM s1/e2 y
          ] *
          ProjectRawWickH[
            line2Terms[[line2Index, "LeftKind"]], nu2,
            indices[[3]], -I aM s2/e2 y
          ];
      NIntegrate[
        fMiddle[y] *
          ProjectPaperSideValue[
            leftData[[line1Index]][indices[[1]]],
            leftRelations[[line1Index]], leftScale y
          ] *
          ProjectPaperSideValue[
            rightData[[line2Index]][indices[[4]]],
            rightRelations[[line2Index]], rightScale y
          ],
        {y, 0, Infinity},
        Evaluate[Sequence @@ integrationOptions]
      ],
      {line1Index, Length[line1Terms]},
      {line2Index, Length[line2Terms]}
    ],
    {indices, indexTuples}
  ]
];

ProjectRawTopComponentsCombinedSideData[
  nu0 : {nu0L_?NumericQ, nu0M_?NumericQ, nu0R_?NumericQ},
  nu : {nu1_?NumericQ, nu2_?NumericQ},
  energies : {e1_?NumericQ, e2_?NumericQ, e3_?NumericQ},
  momenta : {s1_?NumericQ, s2_?NumericQ},
  signs : {aL_Integer, aM_Integer, aR_Integer},
  components : {__Integer},
  OptionsPattern[]
] := Module[
  {wp, accuracyGoal, precisionGoal, maxRecursion, cutoff, lowerCutoff,
    line1Terms, line2Terms, leftRelations, rightRelations,
    leftData, rightData, leftScale, rightScale, indexTuples,
    requiredLeftEndpoints, requiredRightEndpoints,
    fLeft, fRight, combinedIntegrand, integrationOptions},
  If[!And @@ (1 <= # <= 16 & /@ components), Return[$Failed]];
  If[
    aL != aM && aM != aR,
    Return@Part[
      ProjectRawCrossTopVector[
        nu0, nu, energies, momenta, signs,
        "WorkingPrecision" -> OptionValue["WorkingPrecision"],
        "AccuracyGoal" -> OptionValue["AccuracyGoal"],
        "PrecisionGoal" -> OptionValue["PrecisionGoal"],
        "MaxRecursion" -> OptionValue["MaxRecursion"],
        "Cutoff" -> OptionValue["Cutoff"],
        "LowerCutoff" -> OptionValue["LowerCutoff"]
      ],
      components
    ]
  ];
  wp = OptionValue["WorkingPrecision"];
  accuracyGoal = OptionValue["AccuracyGoal"];
  precisionGoal = OptionValue["PrecisionGoal"];
  maxRecursion = OptionValue["MaxRecursion"];
  cutoff = OptionValue["Cutoff"];
  lowerCutoff = OptionValue["LowerCutoff"];
  line1Terms = ProjectPaperWickLineTerms[signs[[1 ;; 2]]];
  line2Terms = ProjectPaperWickLineTerms[signs[[2 ;; 3]]];
  leftRelations = Replace[
    Lookup[line1Terms, "Relation"],
    {"LeftLE" -> "Prefix", "LeftGE" -> "Suffix", _ -> "None"},
    {1}
  ];
  rightRelations = Replace[
    Lookup[line2Terms, "Relation"],
    {"LeftLE" -> "Suffix", "LeftGE" -> "Prefix", _ -> "None"},
    {1}
  ];
  indexTuples = Tuples[{0, 1}, 4][[components]];
  requiredLeftEndpoints = Union[indexTuples[[All, 1]]];
  requiredRightEndpoints = Union[indexTuples[[All, 4]]];
  leftData = Table[
    Association@Table[
      fLeft[y_?NumericQ] :=
        ProjectRawWickVertexFactor[nu0L, aL, e1, y] *
          ProjectRawWickH[
            line1Terms[[termIndex, "LeftKind"]], nu1, endpointIndex,
            -I aL s1/e1 y
          ];
      endpointIndex -> ProjectPaperSideData[
        fLeft, leftRelations[[termIndex]], cutoff, lowerCutoff,
        wp, accuracyGoal, precisionGoal, maxRecursion
      ],
      {endpointIndex, requiredLeftEndpoints}
    ],
    {termIndex, Length[line1Terms]}
  ];
  rightData = Table[
    Association@Table[
      fRight[y_?NumericQ] :=
        ProjectRawWickVertexFactor[nu0R, aR, e3, y] *
          ProjectRawWickH[
            line2Terms[[termIndex, "RightKind"]], nu2, endpointIndex,
            -I aR s2/e3 y
          ];
      endpointIndex -> ProjectPaperSideData[
        fRight, rightRelations[[termIndex]], cutoff, lowerCutoff,
        wp, accuracyGoal, precisionGoal, maxRecursion
      ],
      {endpointIndex, requiredRightEndpoints}
    ],
    {termIndex, Length[line2Terms]}
  ];
  {leftScale, rightScale} = ProjectRawLineThresholdScales[energies];
  integrationOptions = {
    WorkingPrecision -> wp,
    AccuracyGoal -> accuracyGoal,
    PrecisionGoal -> precisionGoal,
    MaxRecursion -> maxRecursion,
    Method -> {"GlobalAdaptive", "SymbolicProcessing" -> 0}
  };
  Table[
    combinedIntegrand[y_?NumericQ] := Total@Flatten@Table[
      ProjectRawWickVertexFactor[nu0M, aM, e2, y] *
        ProjectRawWickH[
          line1Terms[[line1Index, "RightKind"]], nu1,
          indices[[2]], -I aM s1/e2 y
        ] *
        ProjectRawWickH[
          line2Terms[[line2Index, "LeftKind"]], nu2,
          indices[[3]], -I aM s2/e2 y
        ] *
        ProjectPaperSideValue[
          leftData[[line1Index]][indices[[1]]],
          leftRelations[[line1Index]], leftScale y
        ] *
        ProjectPaperSideValue[
          rightData[[line2Index]][indices[[4]]],
          rightRelations[[line2Index]], rightScale y
        ],
      {line1Index, Length[line1Terms]},
      {line2Index, Length[line2Terms]}
    ];
    NIntegrate[
      combinedIntegrand[y],
      {y, 0, Infinity},
      Evaluate[Sequence @@ integrationOptions]
    ],
    {indices, indexTuples}
  ]
];

ProjectRawTopVectorCachedSideData[
  nu0 : {_?NumericQ, _?NumericQ, _?NumericQ},
  nu : {_?NumericQ, _?NumericQ},
  energies : {_?NumericQ, _?NumericQ, _?NumericQ},
  momenta : {_?NumericQ, _?NumericQ},
  signs : {_Integer, _Integer, _Integer},
  OptionsPattern[]
] := ProjectRawTopComponentsCachedSideData[
  nu0, nu, energies, momenta, signs, Range[16],
  "WorkingPrecision" -> OptionValue["WorkingPrecision"],
  "AccuracyGoal" -> OptionValue["AccuracyGoal"],
  "PrecisionGoal" -> OptionValue["PrecisionGoal"],
  "MaxRecursion" -> OptionValue["MaxRecursion"],
  "Cutoff" -> OptionValue["Cutoff"],
  "LowerCutoff" -> OptionValue["LowerCutoff"]
];

ProjectRawTopVector[
  nu0 : {_?NumericQ, _?NumericQ, _?NumericQ},
  nu : {_?NumericQ, _?NumericQ},
  energies : {_?NumericQ, _?NumericQ, _?NumericQ},
  momenta : {_?NumericQ, _?NumericQ},
  signs : {aL_Integer, aM_Integer, aR_Integer},
  OptionsPattern[]
] := Module[
  {wp, accuracyGoal, precisionGoal, maxRecursion, cutoff, lowerCutoff,
    line1Terms, line2Terms, indexTuples},
  If[
    aL != aM && aM != aR,
    Return@ProjectRawCrossTopVector[
      nu0, nu, energies, momenta, signs,
      "WorkingPrecision" -> OptionValue["WorkingPrecision"],
      "AccuracyGoal" -> OptionValue["AccuracyGoal"],
      "PrecisionGoal" -> OptionValue["PrecisionGoal"],
      "MaxRecursion" -> OptionValue["MaxRecursion"],
      "Cutoff" -> OptionValue["Cutoff"],
      "LowerCutoff" -> OptionValue["LowerCutoff"]
    ]
  ];
  wp = OptionValue["WorkingPrecision"];
  accuracyGoal = OptionValue["AccuracyGoal"];
  precisionGoal = OptionValue["PrecisionGoal"];
  maxRecursion = OptionValue["MaxRecursion"];
  cutoff = OptionValue["Cutoff"];
  lowerCutoff = OptionValue["LowerCutoff"];
  line1Terms = ProjectPaperWickLineTerms[signs[[1 ;; 2]]];
  line2Terms = ProjectPaperWickLineTerms[signs[[2 ;; 3]]];
  indexTuples = Tuples[{0, 1}, 4];
  Table[
    Total@Flatten@Table[
      ProjectRawOrderedTerm[
        nu0, nu, energies, momenta, signs, line1Term, line2Term, indices,
        cutoff, lowerCutoff, wp, accuracyGoal, precisionGoal, maxRecursion
      ],
      {line1Term, line1Terms},
      {line2Term, line2Terms}
    ],
    {indices, indexTuples}
  ]
];

ProjectRawTopComponent[
  nu0 : {_?NumericQ, _?NumericQ, _?NumericQ},
  nu : {_?NumericQ, _?NumericQ},
  energies : {_?NumericQ, _?NumericQ, _?NumericQ},
  momenta : {_?NumericQ, _?NumericQ},
  signs : {aL_Integer, aM_Integer, aR_Integer},
  component_Integer,
  OptionsPattern[]
] /; 1 <= component <= 16 := Module[
  {wp, accuracyGoal, precisionGoal, maxRecursion, cutoff, lowerCutoff,
    line1Terms, line2Terms, indices},
  wp = OptionValue["WorkingPrecision"];
  accuracyGoal = OptionValue["AccuracyGoal"];
  precisionGoal = OptionValue["PrecisionGoal"];
  maxRecursion = OptionValue["MaxRecursion"];
  cutoff = OptionValue["Cutoff"];
  lowerCutoff = OptionValue["LowerCutoff"];
  indices = Tuples[{0, 1}, 4][[component]];

  If[
    aL != aM && aM != aR,
    Return@Part[
      ProjectRawCrossTopVector[
        nu0, nu, energies, momenta, signs,
        "WorkingPrecision" -> wp,
        "AccuracyGoal" -> accuracyGoal,
        "PrecisionGoal" -> precisionGoal,
        "MaxRecursion" -> maxRecursion,
        "Cutoff" -> cutoff,
        "LowerCutoff" -> lowerCutoff
      ],
      component
    ]
  ];

  line1Terms = ProjectPaperWickLineTerms[signs[[1 ;; 2]]];
  line2Terms = ProjectPaperWickLineTerms[signs[[2 ;; 3]]];
  Total@Flatten@Table[
    ProjectRawOrderedTerm[
      nu0, nu, energies, momenta, signs, line1Term, line2Term, indices,
      cutoff, lowerCutoff, wp, accuracyGoal, precisionGoal, maxRecursion
    ],
    {line1Term, line1Terms},
    {line2Term, line2Terms}
  ]
];

ProjectRawTwoVertexOrderedTerm[
  {nu0Left_?NumericQ, nu0Right_?NumericQ},
  nu_?NumericQ,
  {eLeft_?NumericQ, eRight_?NumericQ},
  momentum_?NumericQ,
  {aLeft_Integer, aRight_Integer},
  lineTerm_Association,
  {indexLeft_Integer, indexRight_Integer},
  cutoff_?NumericQ, lowerCutoff_?NumericQ,
  wp_Integer?Positive, accuracyGoal_Integer?NonNegative,
  precisionGoal_Integer?NonNegative, maxRecursion_Integer?NonNegative
] := Module[
  {fLeft, fRight, relation, leftData, scale, upper, lower},
  fLeft[y_?NumericQ] :=
    ProjectRawWickVertexFactor[nu0Left, aLeft, eLeft, y] *
      ProjectRawWickH[
        lineTerm["LeftKind"], nu, indexLeft,
        -I aLeft momentum/eLeft y
      ];
  fRight[y_?NumericQ] :=
    ProjectRawWickVertexFactor[nu0Right, aRight, eRight, y] *
      ProjectRawWickH[
        lineTerm["RightKind"], nu, indexRight,
        -I aRight momentum/eRight y
      ];
  relation = Switch[
    lineTerm["Relation"],
    "LeftLE", "Prefix",
    "LeftGE", "Suffix",
    _, "None"
  ];
  leftData = ProjectPaperSideData[
    fLeft, relation, cutoff, lowerCutoff,
    wp, accuracyGoal, precisionGoal, maxRecursion
  ];
  scale = eLeft/eRight;
  upper = SetPrecision[cutoff, wp];
  lower = SetPrecision[lowerCutoff, wp];
  NIntegrate[
    fRight[y] * ProjectPaperSideValue[leftData, relation, scale y],
    {y, 0, Infinity},
    WorkingPrecision -> wp,
    AccuracyGoal -> accuracyGoal,
    PrecisionGoal -> precisionGoal,
    MaxRecursion -> maxRecursion,
    Method -> {"GlobalAdaptive", "SymbolicProcessing" -> 0}
  ]
];

ProjectRawTwoVertexVector[
  powers : {_?NumericQ, _?NumericQ},
  nu_?NumericQ,
  energies : {_?NumericQ, _?NumericQ},
  momentum_?NumericQ,
  signs : {aLeft_Integer, aRight_Integer},
  OptionsPattern[]
] := Module[
  {wp, accuracyGoal, precisionGoal, maxRecursion, cutoff, lowerCutoff,
    lineTerms, lineKinds, commonOptions, left, right, indexTuples},
  commonOptions = Sequence[
    "WorkingPrecision" -> OptionValue["WorkingPrecision"],
    "AccuracyGoal" -> OptionValue["AccuracyGoal"],
    "PrecisionGoal" -> OptionValue["PrecisionGoal"],
    "MaxRecursion" -> OptionValue["MaxRecursion"],
    "Cutoff" -> OptionValue["Cutoff"],
    "LowerCutoff" -> OptionValue["LowerCutoff"]
  ];
  If[
    aLeft != aRight,
    lineKinds = ProjectPaperCrossEndpointKinds[signs];
    left = ProjectRawOneVertexVector[
      powers[[1]], aLeft, energies[[1]],
      {<|"Kind" -> lineKinds[[1]], "Nu" -> nu, "Momentum" -> momentum|>},
      commonOptions
    ];
    right = ProjectRawOneVertexVector[
      powers[[2]], aRight, energies[[2]],
      {<|"Kind" -> lineKinds[[2]], "Nu" -> nu, "Momentum" -> momentum|>},
      commonOptions
    ];
    Return[Flatten@KroneckerProduct[left, right]]
  ];
  wp = OptionValue["WorkingPrecision"];
  accuracyGoal = OptionValue["AccuracyGoal"];
  precisionGoal = OptionValue["PrecisionGoal"];
  maxRecursion = OptionValue["MaxRecursion"];
  cutoff = OptionValue["Cutoff"];
  lowerCutoff = OptionValue["LowerCutoff"];
  lineTerms = ProjectPaperWickLineTerms[signs];
  indexTuples = Tuples[{0, 1}, 2];
  Table[
    Total@Table[
      ProjectRawTwoVertexOrderedTerm[
        powers, nu, energies, momentum, signs, lineTerm, indices,
        cutoff, lowerCutoff, wp, accuracyGoal, precisionGoal, maxRecursion
      ],
      {lineTerm, lineTerms}
    ],
    {indices, indexTuples}
  ]
];

ProjectPinchShift[nu_] := 2 nu;

ProjectPinchNormalization[nu_, momentum_, sign_Integer] :=
  -sign 4 I/Pi momentum^(-2 nu - 1);

ProjectPhysicalRawBoundary25[
  nu0 : {nu0L_?NumericQ, nu0M_?NumericQ, nu0R_?NumericQ},
  nu : {nu1_?NumericQ, nu2_?NumericQ},
  energies : {e1_?NumericQ, e2_?NumericQ, e3_?NumericQ},
  momenta : {s1_?NumericQ, s2_?NumericQ},
  signs : {aL_Integer, aM_Integer, aR_Integer},
  OptionsPattern[]
] := Module[
  {commonOptions, top, left, right, double, leftNormalization,
    rightNormalization},
  commonOptions = Sequence[
    "WorkingPrecision" -> OptionValue["WorkingPrecision"],
    "AccuracyGoal" -> OptionValue["AccuracyGoal"],
    "PrecisionGoal" -> OptionValue["PrecisionGoal"],
    "MaxRecursion" -> OptionValue["MaxRecursion"],
    "Cutoff" -> OptionValue["Cutoff"],
    "LowerCutoff" -> OptionValue["LowerCutoff"]
  ];
  top = ProjectRawTopVector[
    nu0, nu, energies, momenta, signs, commonOptions
  ];
  leftNormalization = ProjectPinchNormalization[nu1, s1, aL];
  rightNormalization = ProjectPinchNormalization[nu2, s2, aM];
  left = If[
    aL == aM,
    leftNormalization *
      ProjectRawTwoVertexVector[
        {nu0L + nu0M - ProjectPinchShift[nu1], nu0R},
        nu2, {e1 + e2, e3}, s2, {aM, aR},
        commonOptions
      ],
    ConstantArray[0, 4]
  ];
  right = If[
    aM == aR,
    rightNormalization *
      ProjectRawTwoVertexVector[
        {nu0L, nu0M + nu0R - ProjectPinchShift[nu2]},
        nu1, {e1, e2 + e3}, s1, {aL, aM},
        commonOptions
      ],
    ConstantArray[0, 4]
  ];
  double = If[
    aL == aM == aR,
    leftNormalization rightNormalization *
      ProjectRawOneVertexVector[
        nu0L + nu0M + nu0R -
          ProjectPinchShift[nu1] - ProjectPinchShift[nu2],
        aM, e1 + e2 + e3, {}, commonOptions
      ],
    {0}
  ];
  Join[top, left, right, double]
];

ProjectPhysicalRawBoundaryComponent25[
  nu0 : {nu0L_?NumericQ, nu0M_?NumericQ, nu0R_?NumericQ},
  nu : {nu1_?NumericQ, nu2_?NumericQ},
  energies : {e1_?NumericQ, e2_?NumericQ, e3_?NumericQ},
  momenta : {s1_?NumericQ, s2_?NumericQ},
  signs : {aL_Integer, aM_Integer, aR_Integer},
  component_Integer,
  OptionsPattern[]
] /; 1 <= component <= 25 := Module[
  {commonOptions, leftNormalization, rightNormalization},
  commonOptions = Sequence[
    "WorkingPrecision" -> OptionValue["WorkingPrecision"],
    "AccuracyGoal" -> OptionValue["AccuracyGoal"],
    "PrecisionGoal" -> OptionValue["PrecisionGoal"],
    "MaxRecursion" -> OptionValue["MaxRecursion"],
    "Cutoff" -> OptionValue["Cutoff"],
    "LowerCutoff" -> OptionValue["LowerCutoff"]
  ];
  leftNormalization = ProjectPinchNormalization[nu1, s1, aL];
  rightNormalization = ProjectPinchNormalization[nu2, s2, aM];

  Which[
    component <= 16,
      ProjectRawTopComponent[
        nu0, nu, energies, momenta, signs, component, commonOptions
      ],
    component <= 20,
      If[
        aL == aM,
        leftNormalization *
          Part[
            ProjectRawTwoVertexVector[
              {nu0L + nu0M - ProjectPinchShift[nu1], nu0R},
              nu2, {e1 + e2, e3}, s2, {aM, aR},
              commonOptions
            ],
            component - 16
          ],
        0
      ],
    component <= 24,
      If[
        aM == aR,
        rightNormalization *
          Part[
            ProjectRawTwoVertexVector[
              {nu0L, nu0M + nu0R - ProjectPinchShift[nu2]},
              nu1, {e1, e2 + e3}, s1, {aL, aM},
              commonOptions
            ],
            component - 20
          ],
        0
      ],
    True,
      If[
        aL == aM == aR,
        leftNormalization rightNormalization *
          First@ProjectRawOneVertexVector[
            nu0L + nu0M + nu0R -
              ProjectPinchShift[nu1] - ProjectPinchShift[nu2],
            aM, e1 + e2 + e3, {}, commonOptions
          ],
        0
      ]
  ]
];

ProjectPaperSideData[
  f_, relation_String, cutoff_?NumericQ, lowerCutoff_?NumericQ,
  wp_Integer?Positive, accuracyGoal_Integer?NonNegative,
  precisionGoal_Integer?NonNegative, maxRecursion_Integer?NonNegative
] := Module[{total, prefix, suffix, tail, upper, lower, integrationOptions},
  total = ProjectPaperOneVertexIntegral[
    f, wp, accuracyGoal, precisionGoal, maxRecursion
  ];
  If[relation === "None", Return[<|"Total" -> total|>]];
  upper = SetPrecision[cutoff, wp];
  lower = SetPrecision[lowerCutoff, wp];
  Switch[
    relation,
    "Prefix",
      prefix = NDSolveValue[
        {
          cumulative'[x] == f[x],
          cumulative[lower] == 0
        },
        cumulative,
        {x, lower, upper},
        WorkingPrecision -> wp,
        AccuracyGoal -> accuracyGoal,
        PrecisionGoal -> precisionGoal,
        MaxSteps -> Infinity,
        MaxStepFraction -> 1/500,
        Method -> "StiffnessSwitching"
      ];
      <|
        "Total" -> total,
        "Prefix" -> prefix,
        "LowerCutoff" -> lower,
        "Cutoff" -> upper
      |>,
    "Suffix",
      integrationOptions = {
        WorkingPrecision -> wp,
        AccuracyGoal -> accuracyGoal,
        PrecisionGoal -> precisionGoal,
        MaxRecursion -> maxRecursion,
        Method -> {"GlobalAdaptive", "SymbolicProcessing" -> 0}
      };
      tail = NIntegrate[
        f[x],
        {x, upper, Infinity},
        Evaluate[Sequence @@ integrationOptions]
      ];
      suffix = NDSolveValue[
        {
          cumulative'[t] == f[upper - t],
          cumulative[0] == tail
        },
        cumulative,
        {t, 0, upper - lower},
        WorkingPrecision -> wp,
        AccuracyGoal -> accuracyGoal,
        PrecisionGoal -> precisionGoal,
        MaxSteps -> Infinity,
        MaxStepFraction -> 1/500,
        Method -> "ExplicitRungeKutta"
      ];
      <|
        "Total" -> total,
        "Suffix" -> suffix,
        "LowerCutoff" -> lower,
        "Cutoff" -> upper
      |>,
    _,
      $Failed
  ]
];

ProjectPaperSideValue[data_Association, "None", _?NumericQ] :=
  data["Total"];

ProjectPaperSideValue[data_Association, "Prefix", y_?NumericQ] := Which[
  y <= data["LowerCutoff"], 0,
  y >= data["Cutoff"], data["Prefix"][data["Cutoff"]],
  True, data["Prefix"][y]
];

ProjectPaperSideValue[data_Association, "Suffix", y_?NumericQ] :=
  Which[
    y <= data["LowerCutoff"], data["Total"],
    y >= data["Cutoff"], data["Suffix"][0],
    True, data["Suffix"][data["Cutoff"] - y]
  ];

ProjectPaperOrderedFactorizedTerm[
  {p1_?NumericQ, p2_?NumericQ, p3_?NumericQ},
  {mu1_?NumericQ, mu2_?NumericQ},
  {r1_?NumericQ, r2_?NumericQ, r3_?NumericQ, r4_?NumericQ},
  {a1_Integer, a2_Integer, a3_Integer},
  line1Term_Association, line2Term_Association,
  cutoff_?NumericQ, lowerCutoff_?NumericQ,
  wp_Integer?Positive, accuracyGoal_Integer?NonNegative,
  precisionGoal_Integer?NonNegative, maxRecursion_Integer?NonNegative
] := Module[
  {f1, f2, f3, leftRelation, rightRelation, leftData, rightData,
    leftScale, rightScale, upper, lower},
  f1[y_?NumericQ] :=
    ProjectPaperWickVertexFactor[p1, a1, y] *
      ProjectPaperWickEndpoint[
        line1Term["LeftKind"], mu1, -I a1 r1 y
      ];
  f2[y_?NumericQ] :=
    ProjectPaperWickVertexFactor[p2, a2, y] *
      ProjectPaperWickEndpoint[
        line1Term["RightKind"], mu1, -I a2 r2 y
      ] *
      ProjectPaperWickEndpoint[
        line2Term["LeftKind"], mu2, -I a2 r3 y
      ];
  f3[y_?NumericQ] :=
    ProjectPaperWickVertexFactor[p3, a3, y] *
      ProjectPaperWickEndpoint[
        line2Term["RightKind"], mu2, -I a3 r4 y
      ];
  leftRelation = Switch[
    line1Term["Relation"],
    "LeftLE", "Prefix",
    "LeftGE", "Suffix",
    _, "None"
  ];
  rightRelation = Switch[
    line2Term["Relation"],
    "LeftLE", "Suffix",
    "LeftGE", "Prefix",
    _, "None"
  ];
  leftData = ProjectPaperSideData[
    f1, leftRelation, cutoff, lowerCutoff,
    wp, accuracyGoal, precisionGoal, maxRecursion
  ];
  rightData = ProjectPaperSideData[
    f3, rightRelation, cutoff, lowerCutoff,
    wp, accuracyGoal, precisionGoal, maxRecursion
  ];
  {leftScale, rightScale} =
    ProjectPaperLineThresholdScales[{r1, r2, r3, r4}];
  upper = SetPrecision[cutoff, wp];
  lower = SetPrecision[lowerCutoff, wp];
  NIntegrate[
    f2[y] *
      ProjectPaperSideValue[leftData, leftRelation, leftScale y] *
      ProjectPaperSideValue[rightData, rightRelation, rightScale y],
    {y, 0, Infinity},
    WorkingPrecision -> wp,
    AccuracyGoal -> accuracyGoal,
    PrecisionGoal -> precisionGoal,
    MaxRecursion -> maxRecursion,
    Method -> {"GlobalAdaptive", "SymbolicProcessing" -> 0}
  ]
];

ProjectPaperPPPTTLineTerms[] := <|
  "Left" -> {
    {1, <|"LeftKind" -> "H1", "RightKind" -> "H2",
      "Relation" -> "None"|>},
    {-1, <|"LeftKind" -> "H2", "RightKind" -> "H1",
      "Relation" -> "LeftLE"|>}
  },
  "Right" -> {
    {1, <|"LeftKind" -> "H2", "RightKind" -> "H1",
      "Relation" -> "None"|>},
    {-1, <|"LeftKind" -> "H1", "RightKind" -> "H2",
      "Relation" -> "LeftGE"|>}
  }
|>;

ProjectPaperPPPTT[
  p : {_?NumericQ, _?NumericQ, _?NumericQ},
  mu : {_?NumericQ, _?NumericQ},
  r : {_?NumericQ, _?NumericQ, _?NumericQ, _?NumericQ},
  OptionsPattern[]
] := Module[
  {terms, wp, accuracyGoal, precisionGoal, maxRecursion, cutoff, lowerCutoff},
  terms = ProjectPaperPPPTTLineTerms[];
  wp = OptionValue["WorkingPrecision"];
  accuracyGoal = OptionValue["AccuracyGoal"];
  precisionGoal = OptionValue["PrecisionGoal"];
  maxRecursion = OptionValue["MaxRecursion"];
  cutoff = OptionValue["Cutoff"];
  lowerCutoff = OptionValue["LowerCutoff"];
  ProjectPaperPropagatorNormalization[mu[[1]]] *
    ProjectPaperPropagatorNormalization[mu[[2]]] *
    Total@Flatten@Table[
      left[[1]] right[[1]] *
        ProjectPaperOrderedFactorizedTerm[
          p, mu, r, {1, 1, 1}, left[[2]], right[[2]],
          cutoff, lowerCutoff, wp, accuracyGoal, precisionGoal, maxRecursion
        ],
      {left, terms["Left"]}, {right, terms["Right"]}
    ]
];

ProjectPaperSeedBranch[
  {p1_?NumericQ, p2_?NumericQ, p3_?NumericQ},
  {mu1_?NumericQ, mu2_?NumericQ},
  {r1_?NumericQ, r2_?NumericQ, r3_?NumericQ, r4_?NumericQ},
  signs : {a1_Integer, a2_Integer, a3_Integer},
  OptionsPattern[]
] := Module[
  {wp, accuracyGoal, precisionGoal, maxRecursion, cutoff, lowerCutoff,
    line1Terms, line2Terms},
  wp = OptionValue["WorkingPrecision"];
  accuracyGoal = OptionValue["AccuracyGoal"];
  precisionGoal = OptionValue["PrecisionGoal"];
  maxRecursion = OptionValue["MaxRecursion"];
  cutoff = OptionValue["Cutoff"];
  lowerCutoff = OptionValue["LowerCutoff"];
  If[
    a1 != a2 && a2 != a3,
    Return@ProjectPaperSeedCrossFactorized[
      {p1, p2, p3}, {mu1, mu2}, {r1, r2, r3, r4}, signs,
      "WorkingPrecision" -> wp,
      "AccuracyGoal" -> accuracyGoal,
      "PrecisionGoal" -> precisionGoal,
      "MaxRecursion" -> maxRecursion,
      "Cutoff" -> cutoff,
      "LowerCutoff" -> lowerCutoff
    ]
  ];
  line1Terms = ProjectPaperWickLineTerms[{a1, a2}];
  line2Terms = ProjectPaperWickLineTerms[{a2, a3}];
  ProjectPaperPropagatorNormalization[mu1] *
    ProjectPaperPropagatorNormalization[mu2] *
    Total@Flatten@Table[
      ProjectPaperOrderedFactorizedTerm[
        {p1, p2, p3}, {mu1, mu2}, {r1, r2, r3, r4}, signs,
        line1Term, line2Term, cutoff, lowerCutoff,
        wp, accuracyGoal, precisionGoal, maxRecursion
      ],
      {line1Term, line1Terms}, {line2Term, line2Terms}
    ]
];

ProjectPaperSeedCrossFactorized[
  {p1_?NumericQ, p2_?NumericQ, p3_?NumericQ},
  {mu1_?NumericQ, mu2_?NumericQ},
  {r1_?NumericQ, r2_?NumericQ, r3_?NumericQ, r4_?NumericQ},
  signs : {a1_Integer, a2_Integer, a3_Integer},
  OptionsPattern[]
] /; a1 != a2 && a2 != a3 := Module[
  {line1Kinds, line2Kinds, integrationOptions, v1, v2, v3},
  line1Kinds = ProjectPaperCrossEndpointKinds[{a1, a2}];
  line2Kinds = ProjectPaperCrossEndpointKinds[{a2, a3}];
  integrationOptions = {
    WorkingPrecision -> OptionValue["WorkingPrecision"],
    AccuracyGoal -> OptionValue["AccuracyGoal"],
    PrecisionGoal -> OptionValue["PrecisionGoal"],
    MaxRecursion -> OptionValue["MaxRecursion"],
    Method -> {"GlobalAdaptive", "SymbolicProcessing" -> 0}
  };
  v1 = NIntegrate[
    ProjectPaperWickVertexFactor[p1, a1, y] *
      ProjectPaperWickEndpoint[line1Kinds[[1]], mu1, -I a1 r1 y],
    {y, 0, Infinity}, Evaluate[Sequence @@ integrationOptions]
  ];
  v2 = NIntegrate[
    ProjectPaperWickVertexFactor[p2, a2, y] *
      ProjectPaperWickEndpoint[line1Kinds[[2]], mu1, -I a2 r2 y] *
      ProjectPaperWickEndpoint[line2Kinds[[1]], mu2, -I a2 r3 y],
    {y, 0, Infinity}, Evaluate[Sequence @@ integrationOptions]
  ];
  v3 = NIntegrate[
    ProjectPaperWickVertexFactor[p3, a3, y] *
      ProjectPaperWickEndpoint[line2Kinds[[2]], mu2, -I a3 r4 y],
    {y, 0, Infinity}, Evaluate[Sequence @@ integrationOptions]
  ];
  ProjectPaperPropagatorNormalization[mu1] *
    ProjectPaperPropagatorNormalization[mu2] * v1 v2 v3
];

ProjectPaperCompleteBranchValuesByConjugation[
  independentValues_Association
] := Association@Join[
  Normal[independentValues],
  KeyValueMap[-#1 -> Conjugate[#2] &, independentValues]
];

(* I a dz gives -dy, while the rotated Infinity-to-zero contour gives
   the compensating orientation minus sign at every vertex. *)
ProjectPaperWickMeasureVertexFactor[vertexCount_Integer?NonNegative] :=
  1;

ProjectPaperCompleteSKSum[independentValues_Association] :=
  ProjectPaperWickMeasureVertexFactor[3] *
    Total[Values[
      ProjectPaperCompleteBranchValuesByConjugation[independentValues]
    ]];

ProjectPaperSeedTotal[
  p : {_?NumericQ, _?NumericQ, _?NumericQ},
  mu : {_?NumericQ, _?NumericQ},
  r : {_?NumericQ, _?NumericQ, _?NumericQ, _?NumericQ},
  OptionsPattern[]
] := ProjectPaperCompleteSKSum[
  Association@Table[
    signs -> ProjectPaperSeedBranch[
      p, mu, r, signs,
      "WorkingPrecision" -> OptionValue["WorkingPrecision"],
      "AccuracyGoal" -> OptionValue["AccuracyGoal"],
      "PrecisionGoal" -> OptionValue["PrecisionGoal"],
      "MaxRecursion" -> OptionValue["MaxRecursion"],
      "Cutoff" -> OptionValue["Cutoff"],
      "LowerCutoff" -> OptionValue["LowerCutoff"]
    ],
    {signs, {{1, 1, 1}, {1, 1, -1}, {1, -1, 1}, {-1, 1, 1}}}
  ]
];

(* ::Section::Closed:: *)
(* ====================================================================== *)
(* Part 1C - Jiaqi Chen E2-maximal asymptotic boundary code *)
(* ====================================================================== *)

(* Jiaqi Chen blow-up boundary for the three-vertex chain with E2 maximal. *)
ClearAll[
  ProjectSmallArgumentHankelLeadingTerms,
  ProjectSmallArgumentHankelSeriesTerms,
  ProjectCombineSeriesTerms,
  ProjectMultiplySeriesTerms,
  ProjectTermWorkingPrecision,
  ProjectRawVertexSeriesTerms,
  ProjectOuterPrefixSeriesTerms,
  ProjectOuterSideWeights,
  ProjectOuterSideSeriesTerms,
  ProjectIntegrateSeriesTerms,
  ProjectSeriesIntegratedProduct,
  ProjectRawOneVertexLargeEnergyLeading,
  ProjectRawOneVertexLargeEnergySeries,
  ProjectLeadingTwoVertexLineTerm,
  ProjectE2MaximalLeadingLineTerm,
  ProjectFactorizedTwoVertexVector,
  ProjectFiniteMaximalTwoVertexVector,
  ProjectE2MaximalFiniteTopVector,
  ProjectE2MaximalAsymptoticBoundary25
];

ProjectSmallArgumentHankelSeriesTerms[
  kind : ("H1" | "H2"),
  nu_,
  0,
  maxOrder_Integer?NonNegative
] := Join[
  Table[
    <|
      "Power" -> 2 m,
      "Coefficient" ->
        If[kind === "H1", I Exp[-I Pi nu], -I Exp[I Pi nu]] *
          Csc[Pi nu] (-1)^m 2^(-2 m - nu)/
          (m! Gamma[m + nu + 1])
    |>,
    {m, 0, maxOrder}
  ],
  Table[
    <|
      "Power" -> 2 m - 2 nu,
      "Coefficient" ->
        If[kind === "H1", -I, I] *
          Csc[Pi nu] (-1)^m 2^(-2 m + nu)/
          (m! Gamma[m - nu + 1])
    |>,
    {m, 0, maxOrder}
  ]
];

ProjectSmallArgumentHankelSeriesTerms[
  kind : ("H1" | "H2"),
  nu_,
  1,
  maxOrder_Integer?NonNegative
] := Join[
  Table[
    <|
      "Power" -> 2 m + 1,
      "Coefficient" ->
        If[kind === "H1", -I Exp[-I Pi nu], I Exp[I Pi nu]] *
          Csc[Pi nu] (-1)^m 2^(-2 m - nu - 1)/
          (m! Gamma[m + nu + 2])
    |>,
    {m, 0, maxOrder}
  ],
  Table[
    <|
      "Power" -> 2 m - 2 nu - 1,
      "Coefficient" ->
        If[kind === "H1", -I, I] *
          Csc[Pi nu] (-1)^m 2^(-2 m + nu + 1)/
          (m! Gamma[m - nu])
    |>,
    {m, 0, maxOrder}
  ]
];

ProjectSmallArgumentHankelLeadingTerms[
  kind : ("H1" | "H2"),
  nu_,
  0
] := If[
  kind === "H1",
  {
    <|
      "Power" -> 0,
      "Coefficient" ->
        I Exp[-I Pi nu] 2^-nu Csc[Pi nu]/Gamma[1 + nu]
    |>,
    <|
      "Power" -> -2 nu,
      "Coefficient" ->
        -I 2^nu Csc[Pi nu]/Gamma[1 - nu]
    |>
  },
  {
    <|
      "Power" -> 0,
      "Coefficient" ->
        -I Exp[I Pi nu] 2^-nu Csc[Pi nu]/Gamma[1 + nu]
    |>,
    <|
      "Power" -> -2 nu,
      "Coefficient" ->
        I 2^nu Csc[Pi nu]/Gamma[1 - nu]
    |>
  }
];

ProjectSmallArgumentHankelLeadingTerms[
  kind : ("H1" | "H2"),
  nu_,
  1
] := {
  <|
    "Power" -> -2 nu - 1,
    "Coefficient" ->
      If[kind === "H1", -I, I] *
        2^(nu + 1) Csc[Pi nu]/Gamma[-nu]
  |>
};

ProjectRawOneVertexLargeEnergyLeading[
  power_?NumericQ,
  sign_Integer,
  energy_?NumericQ,
  legs : {___Association}
] := Module[{indexTuples, termLists, selections},
  indexTuples = Tuples[{0, 1}, Length[legs]];
  Table[
    termLists = MapThread[
      ProjectSmallArgumentHankelLeadingTerms[
        #1["Kind"], #1["Nu"], #2
      ] &,
      {legs, indices}
    ];
    selections = If[Length[termLists] == 0, {{}}, Tuples[termLists]];
    Total@Table[
      (-I sign/energy) (-I sign/energy)^power *
        Product[
          selection[[legIndex, "Coefficient"]] *
            (
              -I sign legs[[legIndex, "Momentum"]]/energy
            )^selection[[legIndex, "Power"]],
          {legIndex, Length[legs]}
        ] *
        Gamma[
          power +
            Total[Lookup[selection, "Power", 0]] + 1
        ],
      {selection, selections}
    ],
    {indices, indexTuples}
  ]
];

ProjectRawOneVertexLargeEnergySeries[
  power_?NumericQ,
  sign_Integer,
  energy_?NumericQ,
  legs : {___Association},
  maxOrder_Integer?NonNegative
] := Module[{indexTuples, termLists, selections},
  indexTuples = Tuples[{0, 1}, Length[legs]];
  Table[
    termLists = MapThread[
      ProjectSmallArgumentHankelSeriesTerms[
        #1["Kind"], #1["Nu"], #2, maxOrder
      ] &,
      {legs, indices}
    ];
    selections = If[Length[termLists] == 0, {{}}, Tuples[termLists]];
    Total@Table[
      (-I sign/energy) (-I sign/energy)^power *
        Product[
          selection[[legIndex, "Coefficient"]] *
            (
              -I sign legs[[legIndex, "Momentum"]]/energy
            )^selection[[legIndex, "Power"]],
          {legIndex, Length[legs]}
        ] *
        Gamma[
          power +
            Total[Lookup[selection, "Power", 0]] + 1
        ],
      {selection, selections}
    ],
    {indices, indexTuples}
  ]
];

ProjectCombineSeriesTerms[terms_List] := Map[
  <|
    "Power" -> First[#]["Power"],
    "Coefficient" -> Total[Lookup[#, "Coefficient"]]
  |> &,
  GatherBy[terms, Lookup[#, "Power"] &]
];

ProjectMultiplySeriesTerms[termLists__List] := Fold[
  ProjectCombineSeriesTerms@Flatten@Table[
    <|
      "Power" -> left["Power"] + right["Power"],
      "Coefficient" -> left["Coefficient"] right["Coefficient"]
    |>,
    {left, #1},
    {right, #2}
  ] &,
  {{<|"Power" -> 0, "Coefficient" -> 1|>}, termLists}
];

ProjectTermWorkingPrecision[coefficient_] := Module[
  {precision = Quiet[Precision[coefficient]]},
  If[NumberQ[precision], Max[30, Ceiling[precision]], 50]
];

ProjectRawVertexSeriesTerms[
  power_?NumericQ,
  sign_Integer,
  energy_?NumericQ,
  legs : {___Association},
  indices : {___Integer},
  maxOrder_Integer?NonNegative
] /; Length[legs] == Length[indices] := Module[
  {termLists, selections},
  termLists = MapThread[
    ProjectSmallArgumentHankelSeriesTerms[
      #1["Kind"], #1["Nu"], #2, maxOrder
    ] &,
    {legs, indices}
  ];
  selections = If[Length[termLists] == 0, {{}}, Tuples[termLists]];
  ProjectCombineSeriesTerms@Table[
    <|
      "Power" ->
        power + Total[Lookup[selection, "Power", 0]],
      "Coefficient" ->
        (-I sign/energy) (-I sign/energy)^power *
          Product[
            selection[[legIndex, "Coefficient"]] *
              (
                -I sign legs[[legIndex, "Momentum"]]/energy
              )^selection[[legIndex, "Power"]],
            {legIndex, Length[legs]}
          ]
    |>,
    {selection, selections}
  ]
];

ProjectOuterPrefixSeriesTerms[
  power_?NumericQ,
  sign_Integer,
  outerEnergy_?NumericQ,
  maximalEnergy_?NumericQ,
  leg_Association,
  index_Integer,
  hankelOrder_Integer?NonNegative,
  thetaOrder_Integer?NonNegative
] := Module[{ratio, rawTerms},
  ratio = outerEnergy/maximalEnergy;
  rawTerms = ProjectRawVertexSeriesTerms[
    power, sign, outerEnergy, {leg}, {index}, hankelOrder
  ];
  ProjectCombineSeriesTerms@Flatten@Table[
    With[{integratedPower = term["Power"] + exponentialOrder + 1},
      <|
        "Power" -> integratedPower,
        "Coefficient" ->
          term["Coefficient"] (-1)^exponentialOrder/
            exponentialOrder! *
            ratio^integratedPower/integratedPower
      |>
    ],
    {term, rawTerms},
    {exponentialOrder, 0, thetaOrder}
  ]
];

ProjectOuterSideWeights["None", _] := {1, 0};
ProjectOuterSideWeights["LeftLE", "LeftOuter"] := {0, 1};
ProjectOuterSideWeights["LeftGE", "LeftOuter"] := {1, -1};
ProjectOuterSideWeights["LeftLE", "RightOuter"] := {1, -1};
ProjectOuterSideWeights["LeftGE", "RightOuter"] := {0, 1};

ProjectOuterSideSeriesTerms[
  power_?NumericQ,
  sign_Integer,
  outerEnergy_?NumericQ,
  maximalEnergy_?NumericQ,
  leg_Association,
  index_Integer,
  relation_,
  outerSide : ("LeftOuter" | "RightOuter"),
  totalValue_,
  hankelOrder_Integer?NonNegative,
  thetaOrder_Integer?NonNegative
] := Module[{weights, totalTerms, prefixTerms},
  weights = ProjectOuterSideWeights[relation, outerSide];
  totalTerms = If[
    weights[[1]] == 0,
    {},
    {<|"Power" -> 0, "Coefficient" -> weights[[1]] totalValue|>}
  ];
  prefixTerms = If[
    weights[[2]] == 0,
    {},
    Map[
      <|
        "Power" -> #["Power"],
        "Coefficient" -> weights[[2]] #["Coefficient"]
      |> &,
      ProjectOuterPrefixSeriesTerms[
        power, sign, outerEnergy, maximalEnergy, leg, index,
        hankelOrder, thetaOrder
      ]
    ]
  ];
  ProjectCombineSeriesTerms@Join[totalTerms, prefixTerms]
];

ProjectIntegrateSeriesTerms[terms_List] := Total@Table[
  With[{wp = ProjectTermWorkingPrecision[term["Coefficient"]]},
    N[term["Coefficient"], wp] *
      N[Gamma[N[term["Power"] + 1, wp]], wp]
  ],
  {term, ProjectCombineSeriesTerms[terms]}
];

ProjectSeriesIntegratedProduct[termLists__List] :=
  ProjectIntegrateSeriesTerms[ProjectMultiplySeriesTerms[termLists]];

ProjectLeadingTwoVertexLineTerm[
  signs : {_, _},
  maximalEndpoint : ("LeftMaximal" | "RightMaximal")
] := Module[{terms, requiredRelation},
  terms = ProjectPaperWickLineTerms[signs];
  If[Length[terms] == 1, Return[First[terms]]];
  requiredRelation = If[
    maximalEndpoint === "LeftMaximal",
    "LeftLE",
    "LeftGE"
  ];
  SelectFirst[terms, #["Relation"] === requiredRelation &, $Failed]
];

ProjectE2MaximalLeadingLineTerm[
  signs : {_, _},
  line : ("LeftLine" | "RightLine")
] := ProjectLeadingTwoVertexLineTerm[
  signs,
  If[line === "LeftLine", "RightMaximal", "LeftMaximal"]
];

Options[ProjectFactorizedTwoVertexVector] = Join[
  Options[ProjectRawOneVertexVector],
  {
    "LargeEnergySeriesOrder" -> 0,
    "OuterVertexSeriesOrder" -> Automatic
  }
];

ProjectFactorizedTwoVertexVector[
  powers : {_?NumericQ, _?NumericQ},
  nu_?NumericQ,
  energies : {_?NumericQ, _?NumericQ},
  momentum_?NumericQ,
  signs : {aLeft_Integer, aRight_Integer},
  maximalEndpoint : ("LeftMaximal" | "RightMaximal"),
  OptionsPattern[]
] := Module[
  {lineTerm, commonOptions, seriesOrder, outerSeriesOrder, left, right},
  lineTerm = ProjectLeadingTwoVertexLineTerm[signs, maximalEndpoint];
  If[lineTerm === $Failed, Return[$Failed]];
  seriesOrder = OptionValue["LargeEnergySeriesOrder"];
  outerSeriesOrder = OptionValue["OuterVertexSeriesOrder"];
  commonOptions = Sequence[
    "WorkingPrecision" -> OptionValue["WorkingPrecision"],
    "AccuracyGoal" -> OptionValue["AccuracyGoal"],
    "PrecisionGoal" -> OptionValue["PrecisionGoal"],
    "MaxRecursion" -> OptionValue["MaxRecursion"],
    "Cutoff" -> OptionValue["Cutoff"],
    "LowerCutoff" -> OptionValue["LowerCutoff"]
  ];
  left = If[
    maximalEndpoint === "LeftMaximal",
    If[seriesOrder > 0,
      ProjectRawOneVertexLargeEnergySeries[
        powers[[1]], aLeft, energies[[1]],
        {
          <|
            "Kind" -> lineTerm["LeftKind"],
            "Nu" -> nu,
            "Momentum" -> momentum
          |>
        },
        seriesOrder
      ],
      ProjectRawOneVertexLargeEnergyLeading[
        powers[[1]], aLeft, energies[[1]],
        {
          <|
            "Kind" -> lineTerm["LeftKind"],
            "Nu" -> nu,
            "Momentum" -> momentum
          |>
        }
      ]
    ],
    If[
      IntegerQ[outerSeriesOrder] && outerSeriesOrder >= 0,
      ProjectRawOneVertexLargeEnergySeries[
        powers[[1]], aLeft, energies[[1]],
        {
          <|
            "Kind" -> lineTerm["LeftKind"],
            "Nu" -> nu,
            "Momentum" -> momentum
          |>
        },
        outerSeriesOrder
      ],
      ProjectRawOneVertexVector[
        powers[[1]], aLeft, energies[[1]],
        {
          <|
            "Kind" -> lineTerm["LeftKind"],
            "Nu" -> nu,
            "Momentum" -> momentum
          |>
        },
        commonOptions
      ]
    ]
  ];
  right = If[
    maximalEndpoint === "RightMaximal",
    If[seriesOrder > 0,
      ProjectRawOneVertexLargeEnergySeries[
        powers[[2]], aRight, energies[[2]],
        {
          <|
            "Kind" -> lineTerm["RightKind"],
            "Nu" -> nu,
            "Momentum" -> momentum
          |>
        },
        seriesOrder
      ],
      ProjectRawOneVertexLargeEnergyLeading[
        powers[[2]], aRight, energies[[2]],
        {
          <|
            "Kind" -> lineTerm["RightKind"],
            "Nu" -> nu,
            "Momentum" -> momentum
          |>
        }
      ]
    ],
    If[
      IntegerQ[outerSeriesOrder] && outerSeriesOrder >= 0,
      ProjectRawOneVertexLargeEnergySeries[
        powers[[2]], aRight, energies[[2]],
        {
          <|
            "Kind" -> lineTerm["RightKind"],
            "Nu" -> nu,
            "Momentum" -> momentum
          |>
        },
        outerSeriesOrder
      ],
      ProjectRawOneVertexVector[
        powers[[2]], aRight, energies[[2]],
        {
          <|
            "Kind" -> lineTerm["RightKind"],
            "Nu" -> nu,
            "Momentum" -> momentum
          |>
        },
        commonOptions
      ]
    ]
  ];
  Flatten@KroneckerProduct[left, right]
];

Options[ProjectFiniteMaximalTwoVertexVector] = Join[
  Options[ProjectFactorizedTwoVertexVector],
  {"ThetaOrderingSeriesOrder" -> 0}
];

ProjectFiniteMaximalTwoVertexVector[
  powers : {_?NumericQ, _?NumericQ},
  nu_?NumericQ,
  energies : {eLeft_?NumericQ, eRight_?NumericQ},
  momentum_?NumericQ,
  signs : {aLeft_Integer, aRight_Integer},
  maximalEndpoint : ("LeftMaximal" | "RightMaximal"),
  OptionsPattern[]
] := Module[
  {thetaOrder, seriesOrder, outerSeriesOrder, commonOptions, lineTerms,
    indexPairs},
  thetaOrder = OptionValue["ThetaOrderingSeriesOrder"];
  seriesOrder = OptionValue["LargeEnergySeriesOrder"];
  outerSeriesOrder = OptionValue["OuterVertexSeriesOrder"];
  commonOptions = Sequence[
    "WorkingPrecision" -> OptionValue["WorkingPrecision"],
    "AccuracyGoal" -> OptionValue["AccuracyGoal"],
    "PrecisionGoal" -> OptionValue["PrecisionGoal"],
    "MaxRecursion" -> OptionValue["MaxRecursion"],
    "Cutoff" -> OptionValue["Cutoff"],
    "LowerCutoff" -> OptionValue["LowerCutoff"]
  ];
  If[
    !IntegerQ[thetaOrder] || thetaOrder <= 0,
    Return@ProjectFactorizedTwoVertexVector[
      powers, nu, energies, momentum, signs, maximalEndpoint,
      commonOptions,
      "LargeEnergySeriesOrder" -> seriesOrder,
      "OuterVertexSeriesOrder" -> outerSeriesOrder
    ]
  ];
  If[!IntegerQ[seriesOrder] || seriesOrder < 0, Return[$Failed]];
  lineTerms = ProjectPaperWickLineTerms[signs];
  indexPairs = Tuples[{0, 1}, 2];
  Table[
    Total@Table[
      If[
        maximalEndpoint === "LeftMaximal",
        Module[{maximalLeg, outerLeg, maximalTerms, outerTotal, sideTerms},
          maximalLeg = <|
            "Kind" -> lineTerm["LeftKind"],
            "Nu" -> nu,
            "Momentum" -> momentum
          |>;
          outerLeg = <|
            "Kind" -> lineTerm["RightKind"],
            "Nu" -> nu,
            "Momentum" -> momentum
          |>;
          maximalTerms = ProjectRawVertexSeriesTerms[
            powers[[1]], aLeft, eLeft, {maximalLeg}, {indices[[1]]},
            seriesOrder
          ];
          outerTotal = If[
            IntegerQ[outerSeriesOrder] && outerSeriesOrder >= 0,
            ProjectRawOneVertexLargeEnergySeries[
              powers[[2]], aRight, eRight, {outerLeg}, outerSeriesOrder
            ][[indices[[2]] + 1]],
            ProjectRawOneVertexVector[
              powers[[2]], aRight, eRight, {outerLeg}, commonOptions
            ][[indices[[2]] + 1]]
          ];
          sideTerms = ProjectOuterSideSeriesTerms[
            powers[[2]], aRight, eRight, eLeft, outerLeg, indices[[2]],
            lineTerm["Relation"], "RightOuter", outerTotal, seriesOrder,
            thetaOrder
          ];
          ProjectSeriesIntegratedProduct[maximalTerms, sideTerms]
        ],
        Module[{outerLeg, maximalLeg, maximalTerms, outerTotal, sideTerms},
          outerLeg = <|
            "Kind" -> lineTerm["LeftKind"],
            "Nu" -> nu,
            "Momentum" -> momentum
          |>;
          maximalLeg = <|
            "Kind" -> lineTerm["RightKind"],
            "Nu" -> nu,
            "Momentum" -> momentum
          |>;
          maximalTerms = ProjectRawVertexSeriesTerms[
            powers[[2]], aRight, eRight, {maximalLeg}, {indices[[2]]},
            seriesOrder
          ];
          outerTotal = If[
            IntegerQ[outerSeriesOrder] && outerSeriesOrder >= 0,
            ProjectRawOneVertexLargeEnergySeries[
              powers[[1]], aLeft, eLeft, {outerLeg}, outerSeriesOrder
            ][[indices[[1]] + 1]],
            ProjectRawOneVertexVector[
              powers[[1]], aLeft, eLeft, {outerLeg}, commonOptions
            ][[indices[[1]] + 1]]
          ];
          sideTerms = ProjectOuterSideSeriesTerms[
            powers[[1]], aLeft, eLeft, eRight, outerLeg, indices[[1]],
            lineTerm["Relation"], "LeftOuter", outerTotal, seriesOrder,
            thetaOrder
          ];
          ProjectSeriesIntegratedProduct[maximalTerms, sideTerms]
        ]
      ],
      {lineTerm, lineTerms}
    ],
    {indices, indexPairs}
  ]
];

Options[ProjectE2MaximalFiniteTopVector] = Join[
  Options[ProjectRawOneVertexVector],
  {
    "LargeEnergySeriesOrder" -> 0,
    "OuterVertexSeriesOrder" -> Automatic,
    "ThetaOrderingSeriesOrder" -> 0
  }
];

ProjectE2MaximalFiniteTopVector[
  nu0 : {nu0L_?NumericQ, nu0M_?NumericQ, nu0R_?NumericQ},
  nu : {nu1_?NumericQ, nu2_?NumericQ},
  energies : {e1_?NumericQ, e2_?NumericQ, e3_?NumericQ},
  momenta : {s1_?NumericQ, s2_?NumericQ},
  signs : {aL_Integer, aM_Integer, aR_Integer},
  OptionsPattern[]
] := Module[
  {wp, seriesOrder, outerSeriesOrder, thetaOrder, commonOptions,
    line1Terms, line2Terms, indexTuples, numericTerms, leftTotal,
    rightTotal, middleSeries, leftSideSeries, rightSideSeries},
  wp = OptionValue["WorkingPrecision"];
  seriesOrder = OptionValue["LargeEnergySeriesOrder"];
  outerSeriesOrder = OptionValue["OuterVertexSeriesOrder"];
  thetaOrder = OptionValue["ThetaOrderingSeriesOrder"];
  commonOptions = Sequence[
    "WorkingPrecision" -> OptionValue["WorkingPrecision"],
    "AccuracyGoal" -> OptionValue["AccuracyGoal"],
    "PrecisionGoal" -> OptionValue["PrecisionGoal"],
    "MaxRecursion" -> OptionValue["MaxRecursion"],
    "Cutoff" -> OptionValue["Cutoff"],
    "LowerCutoff" -> OptionValue["LowerCutoff"]
  ];
  If[
    !IntegerQ[seriesOrder] || seriesOrder < 0 ||
      !IntegerQ[thetaOrder] || thetaOrder <= 0,
    Return[$Failed]
  ];
  line1Terms = ProjectPaperWickLineTerms[{aL, aM}];
  line2Terms = ProjectPaperWickLineTerms[{aM, aR}];
  indexTuples = Tuples[{0, 1}, 4];
  numericTerms[terms_List] := Map[
    <|
      "Power" -> #["Power"],
      "Coefficient" -> N[#["Coefficient"], wp]
    |> &,
    terms
  ];

  leftTotal[kind_, index_] := leftTotal[kind, index] = If[
    IntegerQ[outerSeriesOrder] && outerSeriesOrder >= 0,
    N[ProjectRawOneVertexLargeEnergySeries[
      nu0L, aL, e1,
      {<|"Kind" -> kind, "Nu" -> nu1, "Momentum" -> s1|>},
      outerSeriesOrder
    ][[index + 1]], wp],
    N[ProjectRawOneVertexVector[
      nu0L, aL, e1,
      {<|"Kind" -> kind, "Nu" -> nu1, "Momentum" -> s1|>},
      commonOptions
    ][[index + 1]], wp]
  ];
  rightTotal[kind_, index_] := rightTotal[kind, index] = If[
    IntegerQ[outerSeriesOrder] && outerSeriesOrder >= 0,
    N[ProjectRawOneVertexLargeEnergySeries[
      nu0R, aR, e3,
      {<|"Kind" -> kind, "Nu" -> nu2, "Momentum" -> s2|>},
      outerSeriesOrder
    ][[index + 1]], wp],
    N[ProjectRawOneVertexVector[
      nu0R, aR, e3,
      {<|"Kind" -> kind, "Nu" -> nu2, "Momentum" -> s2|>},
      commonOptions
    ][[index + 1]], wp]
  ];
  middleSeries[rightKind_, leftKind_, index1_, index2_] :=
    middleSeries[rightKind, leftKind, index1, index2] =
      numericTerms@ProjectRawVertexSeriesTerms[
        nu0M, aM, e2,
        {
          <|"Kind" -> rightKind, "Nu" -> nu1, "Momentum" -> s1|>,
          <|"Kind" -> leftKind, "Nu" -> nu2, "Momentum" -> s2|>
        },
        {index1, index2},
        seriesOrder
      ];
  leftSideSeries[kind_, relation_, index_] :=
    leftSideSeries[kind, relation, index] = numericTerms@
      ProjectOuterSideSeriesTerms[
      nu0L, aL, e1, e2,
      <|"Kind" -> kind, "Nu" -> nu1, "Momentum" -> s1|>,
      index, relation, "LeftOuter", leftTotal[kind, index],
      seriesOrder, thetaOrder
    ];
  rightSideSeries[kind_, relation_, index_] :=
    rightSideSeries[kind, relation, index] = numericTerms@
      ProjectOuterSideSeriesTerms[
      nu0R, aR, e3, e2,
      <|"Kind" -> kind, "Nu" -> nu2, "Momentum" -> s2|>,
      index, relation, "RightOuter", rightTotal[kind, index],
      seriesOrder, thetaOrder
    ];

  Table[
    ProjectIntegrateSeriesTerms@Flatten@Table[
      ProjectMultiplySeriesTerms[
        middleSeries[
          line1Term["RightKind"], line2Term["LeftKind"],
          indices[[2]], indices[[3]]
        ],
        leftSideSeries[
          line1Term["LeftKind"], line1Term["Relation"], indices[[1]]
        ],
        rightSideSeries[
          line2Term["RightKind"], line2Term["Relation"], indices[[4]]
        ]
      ],
      {line1Term, line1Terms},
      {line2Term, line2Terms}
    ],
    {indices, indexTuples}
  ]
];

Options[ProjectE2MaximalAsymptoticBoundary25] = Join[
  Options[ProjectRawOneVertexVector],
  {
    "LargeEnergySeriesOrder" -> 0,
    "OuterVertexSeriesOrder" -> Automatic,
    "ThetaOrderingSeriesOrder" -> 0
  }
];

ProjectE2MaximalAsymptoticBoundary25[
  nu0 : {nu0L_?NumericQ, nu0M_?NumericQ, nu0R_?NumericQ},
  nu : {nu1_?NumericQ, nu2_?NumericQ},
  energies : {e1_?NumericQ, e2_?NumericQ, e3_?NumericQ},
  momenta : {s1_?NumericQ, s2_?NumericQ},
  signs : {aL_Integer, aM_Integer, aR_Integer},
  OptionsPattern[]
] := Module[
  {commonOptions, seriesOrder, outerSeriesOrder, thetaOrder, line1, line2,
    leftVertex, middleVertex, rightVertex, top, left, right, double,
    leftNormalization, rightNormalization},
  commonOptions = Sequence[
    "WorkingPrecision" -> OptionValue["WorkingPrecision"],
    "AccuracyGoal" -> OptionValue["AccuracyGoal"],
    "PrecisionGoal" -> OptionValue["PrecisionGoal"],
    "MaxRecursion" -> OptionValue["MaxRecursion"],
    "Cutoff" -> OptionValue["Cutoff"],
    "LowerCutoff" -> OptionValue["LowerCutoff"]
  ];
  seriesOrder = OptionValue["LargeEnergySeriesOrder"];
  outerSeriesOrder = OptionValue["OuterVertexSeriesOrder"];
  thetaOrder = OptionValue["ThetaOrderingSeriesOrder"];
  line1 = ProjectE2MaximalLeadingLineTerm[{aL, aM}, "LeftLine"];
  line2 = ProjectE2MaximalLeadingLineTerm[{aM, aR}, "RightLine"];
  If[MemberQ[{line1, line2}, $Failed], Return[$Failed]];

  leftVertex = If[
    IntegerQ[outerSeriesOrder] && outerSeriesOrder >= 0,
    ProjectRawOneVertexLargeEnergySeries[
      nu0L, aL, e1,
      {
        <|"Kind" -> line1["LeftKind"], "Nu" -> nu1, "Momentum" -> s1|>
      },
      outerSeriesOrder
    ],
    ProjectRawOneVertexVector[
      nu0L, aL, e1,
      {
        <|"Kind" -> line1["LeftKind"], "Nu" -> nu1, "Momentum" -> s1|>
      },
      commonOptions
    ]
  ];
  middleVertex = If[
    seriesOrder > 0,
    ProjectRawOneVertexLargeEnergySeries[
      nu0M, aM, e2,
      {
        <|"Kind" -> line1["RightKind"], "Nu" -> nu1, "Momentum" -> s1|>,
        <|"Kind" -> line2["LeftKind"], "Nu" -> nu2, "Momentum" -> s2|>
      },
      seriesOrder
    ],
    ProjectRawOneVertexLargeEnergyLeading[
      nu0M, aM, e2,
      {
        <|"Kind" -> line1["RightKind"], "Nu" -> nu1, "Momentum" -> s1|>,
        <|"Kind" -> line2["LeftKind"], "Nu" -> nu2, "Momentum" -> s2|>
      }
    ]
  ];
  rightVertex = If[
    IntegerQ[outerSeriesOrder] && outerSeriesOrder >= 0,
    ProjectRawOneVertexLargeEnergySeries[
      nu0R, aR, e3,
      {
        <|"Kind" -> line2["RightKind"], "Nu" -> nu2, "Momentum" -> s2|>
      },
      outerSeriesOrder
    ],
    ProjectRawOneVertexVector[
      nu0R, aR, e3,
      {
        <|"Kind" -> line2["RightKind"], "Nu" -> nu2, "Momentum" -> s2|>
      },
      commonOptions
    ]
  ];
  top = If[
    IntegerQ[thetaOrder] && thetaOrder > 0,
    ProjectE2MaximalFiniteTopVector[
      nu0, nu, energies, momenta, signs,
      commonOptions,
      "LargeEnergySeriesOrder" -> seriesOrder,
      "OuterVertexSeriesOrder" -> outerSeriesOrder,
      "ThetaOrderingSeriesOrder" -> thetaOrder
    ],
    Flatten@KroneckerProduct[leftVertex, middleVertex, rightVertex]
  ];

  leftNormalization = ProjectPinchNormalization[nu1, s1, aL];
  rightNormalization = ProjectPinchNormalization[nu2, s2, aM];
  left = If[
    aL == aM,
    leftNormalization *
      ProjectFiniteMaximalTwoVertexVector[
        {nu0L + nu0M - ProjectPinchShift[nu1], nu0R},
        nu2, {e1 + e2, e3}, s2, {aM, aR}, "LeftMaximal",
        commonOptions,
        "LargeEnergySeriesOrder" -> seriesOrder,
        "OuterVertexSeriesOrder" -> outerSeriesOrder,
        "ThetaOrderingSeriesOrder" -> thetaOrder
      ],
    ConstantArray[0, 4]
  ];
  right = If[
    aM == aR,
    rightNormalization *
      ProjectFiniteMaximalTwoVertexVector[
        {nu0L, nu0M + nu0R - ProjectPinchShift[nu2]},
        nu1, {e1, e2 + e3}, s1, {aL, aM}, "RightMaximal",
        commonOptions,
        "LargeEnergySeriesOrder" -> seriesOrder,
        "OuterVertexSeriesOrder" -> outerSeriesOrder,
        "ThetaOrderingSeriesOrder" -> thetaOrder
      ],
    ConstantArray[0, 4]
  ];
  double = If[
    aL == aM == aR,
    leftNormalization rightNormalization *
      If[
        seriesOrder > 0,
        ProjectRawOneVertexLargeEnergySeries[
          nu0L + nu0M + nu0R -
            ProjectPinchShift[nu1] - ProjectPinchShift[nu2],
          aM, e1 + e2 + e3, {}, seriesOrder
        ],
        ProjectRawOneVertexLargeEnergyLeading[
          nu0L + nu0M + nu0R -
            ProjectPinchShift[nu1] - ProjectPinchShift[nu2],
          aM, e1 + e2 + e3, {}
        ]
      ],
    {0}
  ];
  Join[top, left, right, double]
];

(* ::Section::Closed:: *)
(* ====================================================================== *)
(* Part 1D - corrected 25D IBP/DE numerical evolution code *)
(* ====================================================================== *)

(* Adapter for the archived 25-dimensional three-vertex dlog system. *)

ClearAll[
  XYZZProjectCoreSourceFile, XYZZLoadProjectCore, XYZZProjectCoreLoadedQ,
  XYZZProjectBranchActivity, XYZZProjectBranchSKSign, XYZZProjectPinchShift,
  XYZZProjectPinchNormalization,
  XYZZProjectInitVal, XYZZProjectRawV1, XYZZProjectRawV2,
  XYZZProjectTotalToRaw, XYZZProjectSystemToRaw,
  XYZZProjectBranchMatrix, XYZZProjectBranchMatrixForVariable,
  XYZZCorrectOmega2Fold,
  XYZZCorrectMTopE1, XYZZCorrectMTopE3,
  XYZZCorrectMTopE2, XYZZCorrectMTopS1, XYZZCorrectMTopS2,
  XYZZCorrectMLeftE1, XYZZCorrectMLeftE3, XYZZCorrectMLeftS2,
  XYZZCorrectMRightE1, XYZZCorrectMRightE3, XYZZCorrectMRightS2,
  XYZZCorrectMDoubleE1, XYZZCorrectMDoubleE3, XYZZCorrectMDoubleS2,
  XYZZCorrectMLeftE2, XYZZCorrectMRightE2, XYZZCorrectMDoubleE2,
  XYZZCorrectMLeftS1, XYZZCorrectMRightS1,
  XYZZCorrectMDoubleS1, XYZZProjectPhysicalLineSourcePotential,
  XYZZProjectPhysicalLineSourceS1,
  XYZZProjectEq368T, XYZZProjectEq368TildeOmega0,
  XYZZProjectEq368RemainingPotential,
  XYZZProjectEq368TopLeftPotential, XYZZProjectEq368TopRightPotential,
  XYZZProjectEq368TopLeftE2, XYZZProjectEq368TopRightE2,
  XYZZProjectEq368TopLeftS1, XYZZProjectEq368TopRightS1,
  XYZZProjectEq368TopLeftE1, XYZZProjectEq368TopRightE3,
  XYZZProjectEq368TopLeftS2, XYZZProjectEq368TopRightS2,
  XYZZProjectRawBranchMatrix,
  XYZZProjectRawBranchMatrixForVariable,
  XYZZProjectBranchRawInit, XYZZProjectPhysicalBranchRawInit,
  XYZZProjectBranchDlogInit,
  XYZZProjectS1RelevantBoundaryIndices, XYZZProjectE2RelevantBoundaryIndices,
  XYZZProjectTopSeedS1ReachableIndices,
  XYZZProjectEmbedRelevantBoundary, XYZZProjectEmbedS1RelevantBoundary,
  XYZZProjectEmbedE2RelevantBoundary,
  XYZZSolveProjectBranch, XYZZSolveProjectBranchPath,
  XYZZSolveProjectBranchE2InversePath,
  XYZZProjectE2InfinityVertexModes,
  XYZZProjectE2InfinityConnectionData,
  XYZZProjectE2InfinitySectorSeeds,
  XYZZProjectE2InfinityLeadingModes,
  XYZZProjectE2InfinityFrobeniusData,
  XYZZProjectE2InfinityEvaluate,
  XYZZProjectE2InfinitySeriesDerivative,
  XYZZProjectE2InfinitySeriesResidual,
  XYZZSolveProjectBranchE2FromInfinity,
  XYZZSolveProjectAllBranches,
  XYZZProjectIndependentBranchSigns, XYZZSolveProjectIndependentBranches,
  XYZZCompleteProjectBranchValuesByConjugation,
  XYZZProjectConjugateCompletedBranchValues,
  XYZZProjectBranchTop0000, XYZZProjectStrippedSignedSKSum,
  XYZZProjectStrippedConjugateCompletedSKSum
];

$XYZZProjectCoreLoaded = False;
$XYZZProjectCoreLoadedFile = "StandaloneEmbeddedV43";

XYZZProjectCoreLoadedQ[] := TrueQ[$XYZZProjectCoreLoaded];

XYZZProjectCoreSourceFile[] := "StandaloneEmbeddedV43";

XYZZLoadProjectCore[notebookFile_:Automatic] := Module[{},
  If[XYZZProjectCoreLoadedQ[], Return[True]];
  $XYZZProjectCoreLoaded = XYZZStandaloneLoadNotebookCore[];
  If[$XYZZProjectCoreLoaded, $XYZZProjectCoreLoadedFile = "StandaloneEmbeddedV43"];
  $XYZZProjectCoreLoaded
];

XYZZProjectBranchActivity[{aL_, aM_, aR_}] := <|
  "LeftPinch" -> TrueQ[aL == aM],
  "RightPinch" -> TrueQ[aM == aR],
  "DoublePinch" -> TrueQ[aL == aM == aR]
|>;

XYZZProjectBranchSKSign[{aL_, aM_, aR_}] := aL aM aR;

XYZZProjectS1RelevantBoundaryIndices[signs : {_, _, _}] := Module[
  {activity},
  activity = XYZZProjectBranchActivity[signs];
  Join[
    Range[16],
    If[activity["LeftPinch"], Range[17, 20], {}],
    If[activity["RightPinch"], Range[21, 24], {}],
    If[activity["DoublePinch"], {25}, {}]
  ]
];

XYZZProjectE2RelevantBoundaryIndices[signs : {_, _, _}] := Module[
  {activity},
  activity = XYZZProjectBranchActivity[signs];
  Join[
    Range[16],
    If[activity["LeftPinch"], Range[17, 20], {}],
    If[activity["RightPinch"], Range[21, 24], {}],
    If[activity["DoublePinch"], {25}, {}]
  ]
];

XYZZProjectTopSeedS1ReachableIndices[signs : {_, _, _}] := Module[
  {activity},
  activity = XYZZProjectBranchActivity[signs];
  Join[
    Range[1, 15, 2],
    If[activity["LeftPinch"], {17, 19}, {}],
    If[activity["RightPinch"], Range[21, 24], {}],
    If[activity["DoublePinch"], {25}, {}]
  ]
];

XYZZProjectEmbedRelevantBoundary[
  required_List,
  componentValues_Association
] := Module[{},
  If[!And @@ (KeyExistsQ[componentValues, #] & /@ required), Return[$Failed]];
  Table[Lookup[componentValues, index, 0], {index, 25}]
];

XYZZProjectEmbedS1RelevantBoundary[
  signs : {_, _, _},
  componentValues_Association
] := XYZZProjectEmbedRelevantBoundary[
  XYZZProjectS1RelevantBoundaryIndices[signs],
  componentValues
];

XYZZProjectEmbedE2RelevantBoundary[
  signs : {_, _, _},
  componentValues_Association
] := XYZZProjectEmbedRelevantBoundary[
  XYZZProjectE2RelevantBoundaryIndices[signs],
  componentValues
];

XYZZProjectPinchShift[nu_] := 2 nu;

XYZZProjectPinchNormalization[nu_, momentum_, sign_] :=
  -sign 4 I/Pi momentum^(-2 nu - 1);

XYZZProjectInitVal[power_, energy_] :=
  Gamma[power + 1] (-I/energy)^(power + 1);

XYZZProjectRawV1[power_, nu_, energy_, momentum_] := {
  XYZZProjectInitVal[power, energy],
  XYZZProjectInitVal[power - 2 nu, energy]/momentum^(2 nu + 1)
};

XYZZProjectRawV2[power_, nuLeft_, nuRight_, energy_, sLeft_, sRight_] := {
  XYZZProjectInitVal[power, energy],
  XYZZProjectInitVal[power - 2 nuRight, energy]/sRight^(2 nuRight + 1),
  XYZZProjectInitVal[power - 2 nuLeft, energy]/sLeft^(2 nuLeft + 1),
  XYZZProjectInitVal[power - 2 nuLeft - 2 nuRight, energy]/
    (sLeft^(2 nuLeft + 1) sRight^(2 nuRight + 1))
};

XYZZProjectTotalToRaw[wp_Integer?Positive] := N[
  ArrayFlatten[{
    {TTop, ConstantArray[0, {16, 4}], ConstantArray[0, {16, 4}],
      ConstantArray[0, {16, 1}]},
    {ConstantArray[0, {4, 16}], TLeft, ConstantArray[0, {4, 4}],
      ConstantArray[0, {4, 1}]},
    {ConstantArray[0, {4, 16}], ConstantArray[0, {4, 4}], TRight,
      ConstantArray[0, {4, 1}]},
    {ConstantArray[0, {1, 16}], ConstantArray[0, {1, 4}],
      ConstantArray[0, {1, 4}], IdentityMatrix[1]}
  }],
  wp
];

XYZZProjectSystemToRaw["Raw", wp_Integer?Positive] :=
  N[IdentityMatrix[25], wp];

XYZZProjectSystemToRaw["LegacyMixed", wp_Integer?Positive] :=
  XYZZProjectTotalToRaw[wp];

XYZZProjectBranchMatrix[signs : {aL_, aM_, aR_}] := Module[
  {activity, energyRules, z16x4, z16x1, z4x16, z4x4, z4x1,
    z1x16, z1x4, z1x1, mLeft, mRight, mDouble, rTL, rTR, rTD, rLD, rRD},
  activity = XYZZProjectBranchActivity[signs];
  energyRules = {E1 -> aL E1, E2 -> aM E2, E3 -> aR E3};
  z16x4 = ConstantArray[0, {16, 4}];
  z16x1 = ConstantArray[0, {16, 1}];
  z4x16 = ConstantArray[0, {4, 16}];
  z4x4 = ConstantArray[0, {4, 4}];
  z4x1 = ConstantArray[0, {4, 1}];
  z1x16 = ConstantArray[0, {1, 16}];
  z1x4 = ConstantArray[0, {1, 4}];
  z1x1 = ConstantArray[0, {1, 1}];

  mLeft = If[activity["LeftPinch"], MLeftS1 /. energyRules, z4x4];
  mRight = If[activity["RightPinch"], MRightS1 /. energyRules, z4x4];
  mDouble = If[activity["DoublePinch"], MDoubleS1 /. energyRules, z1x1];
  rTL = If[activity["LeftPinch"], RTopLeftS1 /. energyRules, z16x4];
  rTR = If[activity["RightPinch"], RTopRightS1 /. energyRules, z16x4];
  rTD = If[activity["DoublePinch"], RTopDoubleS1 /. energyRules, z16x1];
  rLD = If[activity["DoublePinch"], RLeftDoubleS1 /. energyRules, z4x1];
  rRD = If[activity["DoublePinch"], RRightDoubleS1 /. energyRules, z4x1];

  ArrayFlatten[{
    {MTopS1 /. energyRules, rTL, rTR, rTD},
    {z4x16, mLeft, z4x4, rLD},
    {z4x16, z4x4, mRight, rRD},
    {z1x16, z1x4, z1x4, mDouble}
  }]
];

XYZZProjectBranchMatrixForVariable[
  signs : {aL_, aM_, aR_},
  s1
] := XYZZProjectBranchMatrix[signs];

XYZZProjectBranchMatrixForVariable[
  signs : {aL_, aM_, aR_},
  variable : (E1 | E2 | E3 | s2)
] := Module[
  {activity, energyRules, chainFactor, matrices,
    mTop, mLeftRaw, mRightRaw, mDoubleRaw,
    rTLRaw, rTRRaw, rTDRaw, rLDRaw, rRDRaw,
    z16x4, z16x1, z4x16, z4x4, z4x1, z1x16, z1x4, z1x1},
  activity = XYZZProjectBranchActivity[signs];
  energyRules = {E1 -> aL E1, E2 -> aM E2, E3 -> aR E3};
  chainFactor = Switch[variable, E1, aL, E2, aM, E3, aR, s2, 1];
  matrices = Switch[
    variable,
    E1, {MTopE1, MLeftE1, MRightE1, MDoubleE1,
      RTopLeftE1, RTopRightE1, RTopDoubleE1,
      RLeftDoubleE1, RRightDoubleE1},
    E2, {MTopE2, MLeftE2, MRightE2, MDoubleE2,
      RTopLeftE2, RTopRightE2, RTopDoubleE2,
      RLeftDoubleE2, RRightDoubleE2},
    E3, {MTopE3, MLeftE3, MRightE3, MDoubleE3,
      RTopLeftE3, RTopRightE3, RTopDoubleE3,
      RLeftDoubleE3, RRightDoubleE3},
    s2, {MTopS2, MLeftS2, MRightS2, MDoubleS2,
      RTopLeftS2, RTopRightS2, RTopDoubleS2,
      RLeftDoubleS2, RRightDoubleS2}
  ];
  {
    mTop, mLeftRaw, mRightRaw, mDoubleRaw,
    rTLRaw, rTRRaw, rTDRaw, rLDRaw, rRDRaw
  } = matrices /. energyRules;
  mTop = Switch[
    variable,
    E2, XYZZCorrectMTopE2[] /. energyRules,
    s2, XYZZCorrectMTopS2[] /. energyRules,
    _, mTop
  ];

  z16x4 = ConstantArray[0, {16, 4}];
  z16x1 = ConstantArray[0, {16, 1}];
  z4x16 = ConstantArray[0, {4, 16}];
  z4x4 = ConstantArray[0, {4, 4}];
  z4x1 = ConstantArray[0, {4, 1}];
  z1x16 = ConstantArray[0, {1, 16}];
  z1x4 = ConstantArray[0, {1, 4}];
  z1x1 = ConstantArray[0, {1, 1}];

  chainFactor ArrayFlatten[{
    {
      mTop,
      If[activity["LeftPinch"], rTLRaw, z16x4],
      If[activity["RightPinch"], rTRRaw, z16x4],
      If[activity["DoublePinch"], rTDRaw, z16x1]
    },
    {
      z4x16,
      If[activity["LeftPinch"], mLeftRaw, z4x4],
      z4x4,
      If[activity["DoublePinch"], rLDRaw, z4x1]
    },
    {
      z4x16,
      z4x4,
      If[activity["RightPinch"], mRightRaw, z4x4],
      If[activity["DoublePinch"], rRDRaw, z4x1]
    },
    {
      z1x16,
      z1x4,
      z1x4,
      If[activity["DoublePinch"], mDoubleRaw, z1x1]
    }
  }]
];

XYZZCorrectOmega2Fold[
  nu0_, nuLeft_, nuRight_, k0_, kLeft_, kRight_
] := Module[
  {states, t1, t2, t2Inv, omegaEx, omegaTilde0},
  states = {{0, 0}, {0, 1}, {1, 0}, {1, 1}};
  t1 = 1/Sqrt[2] {{1, -I}, {-I, 1}};
  t2 = KroneckerProduct[t1, t1];
  t2Inv = Inverse[t2];
  omegaEx = DiagonalMatrix@Table[
    -(
      state[[1]] (2 nuLeft + 1) Log[kLeft] +
      state[[2]] (2 nuRight + 1) Log[kRight]
    ),
    {state, states}
  ];
  omegaTilde0 = DiagonalMatrix@Table[
    -I Log[
      k0 + (2 state[[1]] - 1) kLeft +
        (2 state[[2]] - 1) kRight
    ],
    {state, states}
  ];
  omegaEx - I t2Inv . omegaTilde0 . t2 .
    BMat[nu0 + 1, nuLeft, nuRight]
];

XYZZCorrectMTopE1[] := XYZZCorrectMTopE1[] = FullSimplify[
  KroneckerProduct[
    D[Omega1Fold[nu0L, nu1, E1, s1], E1],
    I4,
    I2
  ]
];

XYZZCorrectMTopE2[] := XYZZCorrectMTopE2[] = FullSimplify[
  KroneckerProduct[
    I2,
    D[
      XYZZCorrectOmega2Fold[nu0M, nu1, nu2, E2, s1, s2],
      E2
    ],
    I2
  ]
];

XYZZCorrectMTopE3[] := XYZZCorrectMTopE3[] = FullSimplify[
  KroneckerProduct[
    I2,
    I4,
    D[Omega1Fold[nu0R, nu2, E3, s2], E3]
  ]
];

XYZZCorrectMTopS1[] := XYZZCorrectMTopS1[] = FullSimplify[
  KroneckerProduct[MLS1, I4, I2] +
  KroneckerProduct[
    I2,
    D[
      XYZZCorrectOmega2Fold[nu0M, nu1, nu2, E2, s1, s2],
      s1
    ],
    I2
  ]
];

XYZZCorrectMTopS2[] := XYZZCorrectMTopS2[] = FullSimplify[
  KroneckerProduct[
    I2,
    D[
      XYZZCorrectOmega2Fold[nu0M, nu1, nu2, E2, s1, s2],
      s2
    ],
    I2
  ] +
  KroneckerProduct[I2, I4, MRS2]
];

XYZZCorrectMLeftE1[] := XYZZCorrectMLeftE1[] = FullSimplify@D[
  KroneckerProduct[
    Omega1Fold[
      nu0L + nu0M - XYZZProjectPinchShift[nu1],
      nu2, E1 + E2, s2
    ],
    I2
  ] +
  KroneckerProduct[I2, Omega1Fold[nu0R, nu2, E3, s2]],
  E1
];

XYZZCorrectMLeftE2[] := XYZZCorrectMLeftE2[] = FullSimplify@D[
  KroneckerProduct[
    Omega1Fold[
      nu0L + nu0M - XYZZProjectPinchShift[nu1],
      nu2, E1 + E2, s2
    ],
    I2
  ] +
  KroneckerProduct[I2, Omega1Fold[nu0R, nu2, E3, s2]],
  E2
];

XYZZCorrectMLeftE3[] := XYZZCorrectMLeftE3[] = FullSimplify@D[
  KroneckerProduct[
    Omega1Fold[
      nu0L + nu0M - XYZZProjectPinchShift[nu1],
      nu2, E1 + E2, s2
    ],
    I2
  ] +
  KroneckerProduct[I2, Omega1Fold[nu0R, nu2, E3, s2]],
  E3
];

XYZZCorrectMLeftS2[] := XYZZCorrectMLeftS2[] = FullSimplify@D[
  KroneckerProduct[
    Omega1Fold[
      nu0L + nu0M - XYZZProjectPinchShift[nu1],
      nu2, E1 + E2, s2
    ],
    I2
  ] +
  KroneckerProduct[I2, Omega1Fold[nu0R, nu2, E3, s2]],
  s2
];

XYZZCorrectMRightE1[] := XYZZCorrectMRightE1[] = FullSimplify@D[
  KroneckerProduct[Omega1Fold[nu0L, nu1, E1, s1], I2] +
  KroneckerProduct[
    I2,
    Omega1Fold[
      nu0M + nu0R - XYZZProjectPinchShift[nu2],
      nu1, E2 + E3, s1
    ]
  ],
  E1
];

XYZZCorrectMRightE2[] := XYZZCorrectMRightE2[] = FullSimplify@D[
  KroneckerProduct[Omega1Fold[nu0L, nu1, E1, s1], I2] +
  KroneckerProduct[
    I2,
    Omega1Fold[
      nu0M + nu0R - XYZZProjectPinchShift[nu2],
      nu1, E2 + E3, s1
    ]
  ],
  E2
];

XYZZCorrectMRightE3[] := XYZZCorrectMRightE3[] = FullSimplify@D[
  KroneckerProduct[Omega1Fold[nu0L, nu1, E1, s1], I2] +
  KroneckerProduct[
    I2,
    Omega1Fold[
      nu0M + nu0R - XYZZProjectPinchShift[nu2],
      nu1, E2 + E3, s1
    ]
  ],
  E3
];

XYZZCorrectMRightS2[] := XYZZCorrectMRightS2[] =
  -(2 nu2 + 1)/s2 IdentityMatrix[4];

XYZZCorrectMDoubleE1[] := XYZZCorrectMDoubleE1[] = FullSimplify@D[
  {{
    -(
      nu0L + nu0M + nu0R -
      XYZZProjectPinchShift[nu1] - XYZZProjectPinchShift[nu2] + 1
    ) Log[E1 + E2 + E3] -
    (2 nu1 + 1) Log[s1] - (2 nu2 + 1) Log[s2]
  }},
  E1
];

XYZZCorrectMDoubleE2[] := XYZZCorrectMDoubleE2[] = FullSimplify@D[
  {{
    -(
      nu0L + nu0M + nu0R -
      XYZZProjectPinchShift[nu1] - XYZZProjectPinchShift[nu2] + 1
    ) Log[E1 + E2 + E3] -
    (2 nu1 + 1) Log[s1] - (2 nu2 + 1) Log[s2]
  }},
  E2
];

XYZZCorrectMDoubleE3[] := XYZZCorrectMDoubleE3[] = FullSimplify@D[
  {{
    -(
      nu0L + nu0M + nu0R -
      XYZZProjectPinchShift[nu1] - XYZZProjectPinchShift[nu2] + 1
    ) Log[E1 + E2 + E3] -
    (2 nu1 + 1) Log[s1] - (2 nu2 + 1) Log[s2]
  }},
  E3
];

XYZZCorrectMLeftS1[] := XYZZCorrectMLeftS1[] =
  -(2 nu1 + 1)/s1 IdentityMatrix[4];

XYZZCorrectMRightS1[] := XYZZCorrectMRightS1[] = FullSimplify@D[
  KroneckerProduct[Omega1Fold[nu0L, nu1, E1, s1], I2] +
  KroneckerProduct[
    I2,
    Omega1Fold[
      nu0M + nu0R - XYZZProjectPinchShift[nu2],
      nu1, E2 + E3, s1
    ]
  ],
  s1
];

XYZZCorrectMDoubleS1[] := XYZZCorrectMDoubleS1[] = FullSimplify@D[
  {{
    -(
      nu0L + nu0M + nu0R -
      XYZZProjectPinchShift[nu1] - XYZZProjectPinchShift[nu2] + 1
    ) Log[E1 + E2 + E3] -
    (2 nu1 + 1) Log[s1] - (2 nu2 + 1) Log[s2]
  }},
  s1
];

XYZZCorrectMDoubleS2[] := XYZZCorrectMDoubleS2[] = FullSimplify@D[
  {{
    -(
      nu0L + nu0M + nu0R -
      XYZZProjectPinchShift[nu1] - XYZZProjectPinchShift[nu2] + 1
    ) Log[E1 + E2 + E3] -
    (2 nu1 + 1) Log[s1] - (2 nu2 + 1) Log[s2]
  }},
  s2
];

XYZZProjectPhysicalLineSourcePotential[kLeft_, kRight_, momentum_] := {
  I/2 (
    Log[kLeft - momentum] - Log[kLeft + momentum] +
    Log[kRight - momentum] - Log[kRight + momentum]
  ),
  1/2 (
    Log[kLeft - momentum] + Log[kLeft + momentum] -
    Log[kRight - momentum] - Log[kRight + momentum]
  ),
  1/2 (
    -Log[kLeft - momentum] - Log[kLeft + momentum] +
    Log[kRight - momentum] + Log[kRight + momentum]
  ),
  I/2 (
    Log[kLeft - momentum] - Log[kLeft + momentum] +
    Log[kRight - momentum] - Log[kRight + momentum]
  )
};

XYZZProjectPhysicalLineSourceS1[kLeft_, kRight_, momentum_] := Module[
  {q},
  D[XYZZProjectPhysicalLineSourcePotential[kLeft, kRight, q], q] /.
    q -> momentum
];

XYZZProjectEq368T[n_Integer?Positive] := Module[
  {t1 = 1/Sqrt[2] {{1, -I}, {-I, 1}}},
  If[n === 1, t1, KroneckerProduct @@ ConstantArray[t1, n]]
];

XYZZProjectEq368TildeOmega0[k0_, momenta_List] := Module[
  {states = Tuples[{0, 1}, Length[momenta]]},
  DiagonalMatrix@Table[
    -I Log[k0 + Sum[(2 state[[r]] - 1) momenta[[r]], {r, Length[momenta]}]],
    {state, states}
  ]
];

XYZZProjectEq368RemainingPotential[
  n1_Integer?Positive, n2_Integer?Positive,
  i_Integer?Positive, j_Integer?Positive,
  k01_, momenta1_List, k02_, momenta2_List
] := Module[
  {
    states1 = Tuples[{0, 1}, n1],
    states2 = Tuples[{0, 1}, n2],
    subStates1 = Tuples[{0, 1}, n1 - 1],
    subStates2 = Tuples[{0, 1}, n2 - 1],
    q1, q2, rows, cols
  },
  q1 = Inverse[XYZZProjectEq368T[n1]] .
    XYZZProjectEq368TildeOmega0[k01, momenta1] .
    XYZZProjectEq368T[n1];
  q2 = Inverse[XYZZProjectEq368T[n2]] .
    XYZZProjectEq368TildeOmega0[k02, momenta2] .
    XYZZProjectEq368T[n2];
  rows = Flatten[Table[{a, b}, {a, states1}, {b, states2}], 1];
  cols = Flatten[Table[{c, d}, {c, subStates1}, {d, subStates2}], 1];
  Table[
    Module[
      {
        a = rows[[row, 1]], b = rows[[row, 2]],
        cHat = cols[[col, 1]], dHat = cols[[col, 2]],
        term1 = 0, term2 = 0
      },
      If[Delete[b, j] === dHat,
        term1 =
          -I q1[[
            First@First@Position[states1, a],
            First@First@Position[states1, Insert[cHat, 1 - b[[j]], i]]
          ]] (-1)^b[[j]]
      ];
      If[Delete[a, i] === cHat,
        term2 =
          -I q2[[
            First@First@Position[states2, b],
            First@First@Position[states2, Insert[dHat, 1 - a[[i]], j]]
          ]] (-1)^a[[i]]
      ];
      term1 + term2
    ],
    {row, Length[rows]}, {col, Length[cols]}
  ]
];

XYZZProjectEq368TopLeftPotential[] :=
  XYZZProjectEq368TopLeftPotential[] = KroneckerProduct[
    XYZZProjectEq368RemainingPotential[
      1, 2, 1, 1, E1, {s1}, E2, {s1, s2}
    ],
    IdentityMatrix[2]
  ];

XYZZProjectEq368TopRightPotential[] :=
  XYZZProjectEq368TopRightPotential[] = KroneckerProduct[
    IdentityMatrix[2],
    XYZZProjectEq368RemainingPotential[
      2, 1, 2, 1, E2, {s1, s2}, E3, {s2}
    ]
  ];

XYZZProjectEq368TopLeftE2[] :=
  XYZZProjectEq368TopLeftE2[] =
    FullSimplify[D[XYZZProjectEq368TopLeftPotential[], E2]];

XYZZProjectEq368TopRightE2[] :=
  XYZZProjectEq368TopRightE2[] =
    FullSimplify[D[XYZZProjectEq368TopRightPotential[], E2]];

XYZZProjectEq368TopLeftE1[] :=
  XYZZProjectEq368TopLeftE1[] =
    FullSimplify[D[XYZZProjectEq368TopLeftPotential[], E1]];

XYZZProjectEq368TopRightE3[] :=
  XYZZProjectEq368TopRightE3[] =
    FullSimplify[D[XYZZProjectEq368TopRightPotential[], E3]];

XYZZProjectEq368TopLeftS1[] :=
  XYZZProjectEq368TopLeftS1[] =
    FullSimplify[D[XYZZProjectEq368TopLeftPotential[], s1]];

XYZZProjectEq368TopRightS1[] :=
  XYZZProjectEq368TopRightS1[] =
    FullSimplify[D[XYZZProjectEq368TopRightPotential[], s1]];

XYZZProjectEq368TopLeftS2[] :=
  XYZZProjectEq368TopLeftS2[] =
    FullSimplify[D[XYZZProjectEq368TopLeftPotential[], s2]];

XYZZProjectEq368TopRightS2[] :=
  XYZZProjectEq368TopRightS2[] =
    FullSimplify[D[XYZZProjectEq368TopRightPotential[], s2]];

XYZZProjectRawBranchMatrix[signs : {aL_, aM_, aR_}] := Module[
  {activity, energyRules, z16x4, z16x1, z4x16, z4x4, z4x1,
    z1x16, z1x4, z1x1, mTop, mLeftRaw, mRightRaw, mDoubleRaw,
    rTLRaw, rTRRaw, rTDRaw, rLDRaw, rRDRaw,
    mLeft, mRight, mDouble, rTL, rTR, rTD, rLD, rRD,
    mTopSymbolic, mLeftSymbolic, mRightSymbolic, mDoubleSymbolic,
    rightDoubleSourceColumn},
  activity = XYZZProjectBranchActivity[signs];
  energyRules = {E1 -> aL E1, E2 -> aM E2, E3 -> aR E3};
  z16x4 = ConstantArray[0, {16, 4}];
  z16x1 = ConstantArray[0, {16, 1}];
  z4x16 = ConstantArray[0, {4, 16}];
  z4x4 = ConstantArray[0, {4, 4}];
  z4x1 = ConstantArray[0, {4, 1}];
  z1x16 = ConstantArray[0, {1, 16}];
  z1x4 = ConstantArray[0, {1, 4}];
  z1x1 = ConstantArray[0, {1, 1}];

  mTopSymbolic = XYZZCorrectMTopS1[];
  mLeftSymbolic = XYZZCorrectMLeftS1[];
  mRightSymbolic = XYZZCorrectMRightS1[];
  mDoubleSymbolic = XYZZCorrectMDoubleS1[];
  rightDoubleSourceColumn =
    XYZZProjectPhysicalLineSourceS1[aL E1, aM E2 + aR E3, s1];

  mTop = mTopSymbolic /. energyRules;
  mLeftRaw = mLeftSymbolic /. energyRules;
  mRightRaw = mRightSymbolic /. energyRules;
  mDoubleRaw = mDoubleSymbolic /. energyRules;
  rTLRaw = XYZZProjectEq368TopLeftS1[] /. energyRules;
  rTRRaw = XYZZProjectEq368TopRightS1[] /. energyRules;
  rTDRaw = z16x1;
  rLDRaw = z4x1;
  rRDRaw = Transpose[{rightDoubleSourceColumn}];

  mLeft = If[activity["LeftPinch"], mLeftRaw, z4x4];
  mRight = If[activity["RightPinch"], mRightRaw, z4x4];
  mDouble = If[activity["DoublePinch"], mDoubleRaw, z1x1];
  rTL = If[activity["LeftPinch"], rTLRaw, z16x4];
  rTR = If[activity["RightPinch"], rTRRaw, z16x4];
  rTD = If[activity["DoublePinch"], rTDRaw, z16x1];
  rLD = If[activity["DoublePinch"], rLDRaw, z4x1];
  rRD = If[activity["DoublePinch"], rRDRaw, z4x1];

  ArrayFlatten[{
    {mTop, rTL, rTR, rTD},
    {z4x16, mLeft, z4x4, rLD},
    {z4x16, z4x4, mRight, rRD},
    {z1x16, z1x4, z1x4, mDouble}
  }]
];

XYZZProjectRawBranchMatrixForVariable[
  signs : {aL_, aM_, aR_},
  variable : (E1 | E2 | E3 | s2)
] := Module[
  {activity, energyRules, chainFactor,
    mTopRaw, mLeftRaw, mRightRaw, mDoubleRaw,
    rTLRaw, rTRRaw, rTDRaw, rLDRaw, rRDRaw,
    leftDoubleColumn, rightDoubleColumn,
    z16x4, z16x1, z4x16, z4x4, z4x1, z1x16, z1x4, z1x1},
  activity = XYZZProjectBranchActivity[signs];
  energyRules = {E1 -> aL E1, E2 -> aM E2, E3 -> aR E3};
  chainFactor = Switch[variable, E1, aL, E2, aM, E3, aR, s2, 1];

  z16x4 = ConstantArray[0, {16, 4}];
  z16x1 = ConstantArray[0, {16, 1}];
  z4x16 = ConstantArray[0, {4, 16}];
  z4x4 = ConstantArray[0, {4, 4}];
  z4x1 = ConstantArray[0, {4, 1}];
  z1x16 = ConstantArray[0, {1, 16}];
  z1x4 = ConstantArray[0, {1, 4}];
  z1x1 = ConstantArray[0, {1, 1}];

  {
    mTopRaw, mLeftRaw, mRightRaw, mDoubleRaw,
    rTLRaw, rTRRaw, leftDoubleColumn, rightDoubleColumn
  } = Switch[
    variable,
    E1,
      {
        XYZZCorrectMTopE1[], XYZZCorrectMLeftE1[],
        XYZZCorrectMRightE1[], XYZZCorrectMDoubleE1[],
        XYZZProjectEq368TopLeftE1[], z16x4,
        Transpose[{
          D[XYZZProjectPhysicalLineSourcePotential[E1 + E2, E3, s2], E1]
        }],
        Transpose[{
          D[XYZZProjectPhysicalLineSourcePotential[E1, E2 + E3, s1], E1]
        }]
      },
    E2,
      {
        XYZZCorrectMTopE2[], XYZZCorrectMLeftE2[],
        XYZZCorrectMRightE2[], XYZZCorrectMDoubleE2[],
        XYZZProjectEq368TopLeftE2[], XYZZProjectEq368TopRightE2[],
        Transpose[{
          D[XYZZProjectPhysicalLineSourcePotential[E1 + E2, E3, s2], E2]
        }],
        Transpose[{
          D[XYZZProjectPhysicalLineSourcePotential[E1, E2 + E3, s1], E2]
        }]
      },
    E3,
      {
        XYZZCorrectMTopE3[], XYZZCorrectMLeftE3[],
        XYZZCorrectMRightE3[], XYZZCorrectMDoubleE3[],
        z16x4, XYZZProjectEq368TopRightE3[],
        Transpose[{
          D[XYZZProjectPhysicalLineSourcePotential[E1 + E2, E3, s2], E3]
        }],
        Transpose[{
          D[XYZZProjectPhysicalLineSourcePotential[E1, E2 + E3, s1], E3]
        }]
      },
    s2,
      {
        XYZZCorrectMTopS2[], XYZZCorrectMLeftS2[],
        XYZZCorrectMRightS2[], XYZZCorrectMDoubleS2[],
        XYZZProjectEq368TopLeftS2[], XYZZProjectEq368TopRightS2[],
        Transpose[{
          XYZZProjectPhysicalLineSourceS1[E1 + E2, E3, s2]
        }],
        z4x1
      }
  ];

  rTDRaw = z16x1;
  rLDRaw = leftDoubleColumn;
  rRDRaw = rightDoubleColumn;

  chainFactor ArrayFlatten[{
    {
      mTopRaw,
      If[activity["LeftPinch"], rTLRaw, z16x4],
      If[activity["RightPinch"], rTRRaw, z16x4],
      If[activity["DoublePinch"], rTDRaw, z16x1]
    },
    {
      z4x16,
      If[activity["LeftPinch"], mLeftRaw, z4x4],
      z4x4,
      If[activity["DoublePinch"], rLDRaw, z4x1]
    },
    {
      z4x16,
      z4x4,
      If[activity["RightPinch"], mRightRaw, z4x4],
      If[activity["DoublePinch"], rRDRaw, z4x1]
    },
    {
      z1x16,
      z1x4,
      z1x4,
      If[activity["DoublePinch"], mDoubleRaw, z1x1]
    }
  }] /. energyRules
];

XYZZProjectBranchRawInit[
  signs : {aL_, aM_, aR_},
  rules_List,
  sStart_,
  wp_Integer?Positive
] := Module[
  {activity, rawTop, rawLeft, rawRight, rawDouble},
  activity = XYZZProjectBranchActivity[signs];
  rawTop = Flatten@KroneckerProduct[
    XYZZProjectRawV1[nu0L, nu1, aL E1, sStart],
    XYZZProjectRawV2[nu0M, nu1, nu2, aM E2, sStart, s2],
    XYZZProjectRawV1[nu0R, nu2, aR E3, s2]
  ];
  rawLeft = If[
    activity["LeftPinch"],
    XYZZProjectPinchNormalization[nu1, sStart, aL] *
      Flatten@KroneckerProduct[
        XYZZProjectRawV1[
          nu0L + nu0M - XYZZProjectPinchShift[nu1],
          nu2, aL E1 + aM E2, s2
        ],
        XYZZProjectRawV1[nu0R, nu2, aR E3, s2]
      ],
    ConstantArray[0, 4]
  ];
  rawRight = If[
    activity["RightPinch"],
    XYZZProjectPinchNormalization[nu2, s2, aM] *
      Flatten@KroneckerProduct[
        XYZZProjectRawV1[nu0L, nu1, aL E1, sStart],
        XYZZProjectRawV1[
          nu0M + nu0R - XYZZProjectPinchShift[nu2],
          nu1, aM E2 + aR E3, sStart
        ]
      ],
    ConstantArray[0, 4]
  ];
  rawDouble = If[
    activity["DoublePinch"],
    XYZZProjectPinchNormalization[nu1, sStart, aL] *
      XYZZProjectPinchNormalization[nu2, s2, aM] *
      {XYZZProjectInitVal[
        nu0L + nu0M + nu0R -
          XYZZProjectPinchShift[nu1] - XYZZProjectPinchShift[nu2],
        aL E1 + aM E2 + aR E3
      ]},
    {0}
  ];
  N[Join[rawTop, rawLeft, rawRight, rawDouble] /. rules, wp]
];

Options[XYZZProjectPhysicalBranchRawInit] = {
  "AccuracyGoal" -> 20,
  "PrecisionGoal" -> 20,
  "MaxRecursion" -> 14,
  "Cutoff" -> 35,
  "LowerCutoff" -> 10^-8
};

XYZZProjectPhysicalBranchRawInit[
  signs : {(_Integer)..},
  rules_List,
  sStart_?NumericQ,
  wp_Integer?Positive,
  OptionsPattern[]
] := Module[
  {parameterValues},
  If[Length[DownValues[ProjectPhysicalRawBoundary25]] == 0, Return[$Failed]];
  parameterValues = N[
    {
      {nu0L, nu0M, nu0R},
      {nu1, nu2},
      {E1, E2, E3},
      {s1, s2}
    } /. Join[rules, {s1 -> sStart}],
    wp
  ];
  ProjectPhysicalRawBoundary25[
    parameterValues[[1]],
    parameterValues[[2]],
    parameterValues[[3]],
    parameterValues[[4]],
    signs,
    "WorkingPrecision" -> wp,
    "AccuracyGoal" -> OptionValue["AccuracyGoal"],
    "PrecisionGoal" -> OptionValue["PrecisionGoal"],
    "MaxRecursion" -> OptionValue["MaxRecursion"],
    "Cutoff" -> OptionValue["Cutoff"],
    "LowerCutoff" -> OptionValue["LowerCutoff"]
  ]
];

Options[XYZZProjectBranchDlogInit] = {
  "SystemBasis" -> "Raw",
  "BoundaryMode" -> "PhysicalSK",
  "BoundaryAccuracyGoal" -> 20,
  "BoundaryPrecisionGoal" -> 20,
  "BoundaryMaxRecursion" -> 14,
  "BoundaryCutoff" -> 35,
  "BoundaryLowerCutoff" -> 10^-8
};

XYZZProjectBranchDlogInit[
  signs_,
  rules_List,
  sStart_,
  wp_Integer?Positive,
  OptionsPattern[]
] := Module[{rawInit},
  rawInit = Switch[
    OptionValue["BoundaryMode"],
    "RawAnchor",
      XYZZProjectBranchRawInit[signs, rules, sStart, wp],
    "PhysicalSK",
      XYZZProjectPhysicalBranchRawInit[
        signs, rules, sStart, wp,
        "AccuracyGoal" -> OptionValue["BoundaryAccuracyGoal"],
        "PrecisionGoal" -> OptionValue["BoundaryPrecisionGoal"],
        "MaxRecursion" -> OptionValue["BoundaryMaxRecursion"],
        "Cutoff" -> OptionValue["BoundaryCutoff"],
        "LowerCutoff" -> OptionValue["BoundaryLowerCutoff"]
      ],
    _,
      Return[$Failed]
  ];
  If[rawInit === $Failed, Return[$Failed]];
  LinearSolve[XYZZProjectSystemToRaw[OptionValue["SystemBasis"], wp], rawInit]
];

Options[XYZZSolveProjectBranch] = {
  "WorkingPrecision" -> 50,
  "AccuracyGoal" -> 30,
  "PrecisionGoal" -> 30,
  "MaxStepFraction" -> 1/200,
  "SystemBasis" -> "Raw",
  "BoundaryMode" -> "PhysicalSK",
  "BoundaryAccuracyGoal" -> 20,
  "BoundaryPrecisionGoal" -> 20,
  "BoundaryMaxRecursion" -> 14,
  "BoundaryCutoff" -> 35,
  "BoundaryLowerCutoff" -> 10^-8,
  "InitialRawVector" -> Automatic
};

Options[XYZZSolveProjectBranchPath] = {
  "WorkingPrecision" -> 50,
  "AccuracyGoal" -> 30,
  "PrecisionGoal" -> 30,
  "MaxStepFraction" -> 1/200
};

XYZZSolveProjectBranchPath[
  signs : {(_Integer)..},
  rules_List,
  segments : {{(E1 | E2 | E3 | s1 | s2), _?NumericQ, _?NumericQ} ..},
  initialRawVector_List,
  OptionsPattern[]
] := Module[
  {wp, currentRules, currentRaw, segmentRecords, variable, end, start,
    systemBasis, systemToRaw, rulesNoVariable, mExpression, mFunction,
    init, solution, segment},
  If[!XYZZLoadProjectCore[], Return[$Failed]];
  If[Length[initialRawVector] =!= 25, Return[$Failed]];
  wp = OptionValue["WorkingPrecision"];
  currentRules = rules;
  currentRaw = N[initialRawVector, wp];
  segmentRecords = {};

  Do[
    {variable, end, start} = segment;
    systemBasis = "Raw";
    systemToRaw = XYZZProjectSystemToRaw[systemBasis, wp];
    rulesNoVariable = DeleteCases[currentRules, variable -> _];
    mExpression = Switch[
        variable,
        s1, XYZZProjectRawBranchMatrix[signs],
        _, XYZZProjectRawBranchMatrixForVariable[signs, variable]
      ] /. rulesNoVariable;
    mFunction[x_?NumericQ] := N[
      mExpression /. variable -> N[x, wp],
      wp
    ];
    init = LinearSolve[systemToRaw, currentRaw];
    solution = NDSolveValue[
      {
        y'[x] == mFunction[x] . y[x],
        y[start] == init
      },
      y,
      {x, end, start},
      WorkingPrecision -> wp,
      AccuracyGoal -> OptionValue["AccuracyGoal"],
      PrecisionGoal -> OptionValue["PrecisionGoal"],
      MaxStepFraction -> OptionValue["MaxStepFraction"],
      MaxSteps -> Infinity,
      Method -> "StiffnessSwitching"
    ];
    currentRaw = N[systemToRaw . solution[end], wp];
    currentRules = Join[
      DeleteCases[currentRules, variable -> _],
      {variable -> end}
    ];
    segmentRecords = Append[
      segmentRecords,
      <|"Variable" -> variable, "Range" -> {end, start},
        "SystemBasis" -> systemBasis|>
    ],
    {segment, segments}
  ];

  <|
    "Signs" -> signs,
    "RawBoundary25" -> currentRaw,
    "Rules" -> currentRules,
    "Segments" -> segmentRecords,
    "WorkingPrecision" -> wp
  |>
];

Options[XYZZSolveProjectBranchE2InversePath] = {
  "WorkingPrecision" -> 50,
  "AccuracyGoal" -> 30,
  "PrecisionGoal" -> 30,
  "MaxStepFraction" -> 1/200
};

XYZZSolveProjectBranchE2InversePath[
  signs : {(_Integer)..},
  rules_List,
  {e2End_?NumericQ, e2Start_?NumericQ},
  initialRawVector_List,
  OptionsPattern[]
] := Module[
  {wp, t, tStart, tEnd, systemBasis, systemToRaw, rulesNoE2,
    mExpression, mFunction, init, solution, currentRules, currentRaw},
  If[!XYZZLoadProjectCore[], Return[$Failed]];
  If[Length[initialRawVector] =!= 25, Return[$Failed]];
  wp = OptionValue["WorkingPrecision"];
  tStart = N[1/e2Start, wp];
  tEnd = N[1/e2End, wp];
  If[!NumericQ[tStart] || !NumericQ[tEnd] || tStart <= 0 || tEnd <= 0,
    Return[$Failed]
  ];
  systemBasis = "Raw";
  systemToRaw = XYZZProjectSystemToRaw[systemBasis, wp];
  rulesNoE2 = DeleteCases[rules, E2 -> _];
  mExpression =
    XYZZProjectRawBranchMatrixForVariable[signs, E2] /. rulesNoE2;
  mFunction[x_?NumericQ] := N[
    (-1/x^2) (mExpression /. E2 -> N[1/x, wp]),
    wp
  ];
  init = LinearSolve[systemToRaw, N[initialRawVector, wp]];
  solution = NDSolveValue[
    {
      y'[t] == mFunction[t] . y[t],
      y[tStart] == init
    },
    y,
    {t, tStart, tEnd},
    WorkingPrecision -> wp,
    AccuracyGoal -> OptionValue["AccuracyGoal"],
    PrecisionGoal -> OptionValue["PrecisionGoal"],
    MaxStepFraction -> OptionValue["MaxStepFraction"],
    MaxSteps -> Infinity,
    Method -> "StiffnessSwitching"
  ];
  currentRaw = N[systemToRaw . solution[tEnd], wp];
  currentRules = Join[DeleteCases[rules, E2 -> _], {E2 -> e2End}];
  <|
    "Signs" -> signs,
    "RawBoundary25" -> currentRaw,
    "Rules" -> currentRules,
    "Segments" -> {
      <|"Variable" -> E2, "Range" -> {e2End, e2Start},
        "EvolutionVariable" -> "InverseT", "TRange" -> {tStart, tEnd},
        "Jacobian" -> "-1/t^2", "SystemBasis" -> systemBasis|>
    },
    "WorkingPrecision" -> wp
  |>
];

(* Exact E2 -> Infinity boundary in the sense of an asymptotic germ.
   This implements the indicial equation and coefficient recurrence of
   arXiv:2411.03088, Eqs. (3.5)-(3.11).  NDSolve is never initialized at the
   singular point t=0; the Frobenius germ is evaluated at a certified t>0. *)

XYZZProjectE2InfinityVertexModes[
  power_?NumericQ,
  sign_Integer,
  legs : {___Association},
  wp_Integer?Positive
] := Module[
  {states, dimension, selectedTerms, powers, exponent, coefficient},
  states = Tuples[{0, 1}, Length[legs]];
  dimension = 2^Length[legs];
  Table[
    selectedTerms = MapThread[
      Function[{leg, stateIndex},
        Module[{terms},
          terms = ProjectSmallArgumentHankelLeadingTerms[
            leg["Kind"], leg["Nu"], stateIndex
          ];
          If[
            stateIndex == 0,
            SelectFirst[
              terms,
              TrueQ[FullSimplify[#1["Power"] == 0]] &,
              $Failed
            ],
            First[terms]
          ]
        ]
      ],
      {legs, state}
    ];
    If[MemberQ[selectedTerms, $Failed], Return[$Failed]];
    powers = Lookup[selectedTerms, "Power", {}];
    exponent = N[power + Total[powers] + 1, wp];
    coefficient = N[
      (-I sign) (-I sign)^power Gamma[power + Total[powers] + 1] *
        Product[
          selectedTerms[[legIndex, "Coefficient"]] *
            (-I sign legs[[legIndex, "Momentum"]])^
              powers[[legIndex]],
          {legIndex, Length[legs]}
        ],
      wp
    ];
    <|
      "State" -> state,
      "Exponent" -> exponent,
      "BoundaryCoefficient" -> coefficient,
      "LeadingVector" -> N[
        coefficient UnitVector[dimension, stateIndex],
        wp
      ]
    |>,
    {stateIndex, dimension},
    {state, {states[[stateIndex]]}}
  ] // Flatten
];

Options[XYZZProjectE2InfinityConnectionData] = {
  "WorkingPrecision" -> 50,
  "SeriesOrder" -> 10
};

XYZZProjectE2InfinityConnectionData[
  signs : {(_Integer)..},
  rules_List,
  OptionsPattern[]
] := Module[
  {wp, seriesOrder, t, rulesNoE2, matrixExpression,
    connectionExpression, seriesExpression, residue, regularCoefficients},
  If[!XYZZLoadProjectCore[], Return[$Failed]];
  wp = OptionValue["WorkingPrecision"];
  seriesOrder = OptionValue["SeriesOrder"];
  If[!IntegerQ[seriesOrder] || seriesOrder < 1, Return[$Failed]];
  rulesNoE2 = DeleteCases[rules, E2 -> _];
  matrixExpression =
    XYZZProjectRawBranchMatrixForVariable[signs, E2] /. rulesNoE2;
  connectionExpression =
    (-1/t^2) (matrixExpression /. E2 -> 1/t);
  seriesExpression = Quiet@Check[
    Map[
      Normal@Series[Together[#1], {t, 0, seriesOrder - 1}] &,
      connectionExpression,
      {2}
    ],
    $Failed
  ];
  If[seriesExpression === $Failed, Return[$Failed]];
  residue = N[
    Map[Coefficient[#1, t, -1] &, seriesExpression, {2}],
    wp
  ];
  regularCoefficients = Table[
    N[Map[Coefficient[#1, t, order] &, seriesExpression, {2}], wp],
    {order, 0, seriesOrder - 1}
  ];
  If[
    Dimensions[residue] =!= {25, 25} ||
      !And @@ (Dimensions[#1] === {25, 25} & /@ regularCoefficients),
    Return[$Failed]
  ];
  <|
    "VariableTransformation" -> "E2=1/t",
    "Jacobian" -> "dE2/dt=-1/t^2",
    "SeriesVariable" -> t,
    "ConnectionExpression" -> connectionExpression,
    "ResidueMatrix" -> residue,
    "RegularConnectionCoefficients" -> regularCoefficients,
    "SeriesOrder" -> seriesOrder,
    "WorkingPrecision" -> wp,
    "RulesNoE2" -> rulesNoE2
  |>
];

Options[XYZZProjectE2InfinitySectorSeeds] = {
  "WorkingPrecision" -> 50,
  "AccuracyGoal" -> 25,
  "PrecisionGoal" -> 25,
  "MaxRecursion" -> 14,
  "Cutoff" -> 35,
  "LowerCutoff" -> 10^-8,
  "OuterVertexEvaluation" -> "Direct",
  "OuterVertexSeriesOrder" -> 16
};

XYZZProjectE2InfinitySectorSeeds[
  signs : {aL_Integer, aM_Integer, aR_Integer},
  rules_List,
  OptionsPattern[]
] := Module[
  {wp, rulesNoE2, values, localNu0L, localNu0M, localNu0R,
    localNu1, localNu2, localE1, localE3, localS1, localS2,
    activity, line1, line2, commonOptions, outerEvaluation,
    outerSeriesOrder, outerVector, topLeftOuter, topRightOuter,
    topModes, leftLine, leftOuter, leftModes, rightLine, rightOuter,
    rightModes, doubleModes, seeds},
  wp = OptionValue["WorkingPrecision"];
  rulesNoE2 = DeleteCases[rules, E2 -> _];
  values = N[
    {
      nu0L, nu0M, nu0R, nu1, nu2,
      E1, E3, s1, s2
    } /. rulesNoE2,
    wp
  ];
  If[!VectorQ[values, NumericQ] || Length[values] =!= 9, Return[$Failed]];
  {
    localNu0L, localNu0M, localNu0R, localNu1, localNu2,
    localE1, localE3, localS1, localS2
  } = values;
  activity = XYZZProjectBranchActivity[signs];
  outerEvaluation = OptionValue["OuterVertexEvaluation"];
  outerSeriesOrder = OptionValue["OuterVertexSeriesOrder"];
  commonOptions = Sequence[
    "WorkingPrecision" -> wp,
    "AccuracyGoal" -> OptionValue["AccuracyGoal"],
    "PrecisionGoal" -> OptionValue["PrecisionGoal"],
    "MaxRecursion" -> OptionValue["MaxRecursion"],
    "Cutoff" -> OptionValue["Cutoff"],
    "LowerCutoff" -> OptionValue["LowerCutoff"]
  ];
  outerVector[power_, sign_, energy_, leg_Association] := Switch[
    outerEvaluation,
    "Direct",
      N[
        ProjectRawOneVertexVector[
          power, sign, energy, {leg}, commonOptions
        ],
        wp
      ],
    "Series",
      N[
        ProjectRawOneVertexLargeEnergySeries[
          power, sign, energy, {leg}, outerSeriesOrder
        ],
        wp
      ],
    _,
      $Failed
  ];

  line1 = ProjectE2MaximalLeadingLineTerm[{aL, aM}, "LeftLine"];
  line2 = ProjectE2MaximalLeadingLineTerm[{aM, aR}, "RightLine"];
  If[MemberQ[{line1, line2}, $Failed], Return[$Failed]];
  topLeftOuter = outerVector[
    localNu0L, aL, localE1,
    <|"Kind" -> line1["LeftKind"], "Nu" -> localNu1,
      "Momentum" -> localS1|>
  ];
  topRightOuter = outerVector[
    localNu0R, aR, localE3,
    <|"Kind" -> line2["RightKind"], "Nu" -> localNu2,
      "Momentum" -> localS2|>
  ];
  If[MemberQ[{topLeftOuter, topRightOuter}, $Failed], Return[$Failed]];
  topModes = XYZZProjectE2InfinityVertexModes[
    localNu0M,
    aM,
    {
      <|"Kind" -> line1["RightKind"], "Nu" -> localNu1,
        "Momentum" -> localS1|>,
      <|"Kind" -> line2["LeftKind"], "Nu" -> localNu2,
        "Momentum" -> localS2|>
    },
    wp
  ];
  If[topModes === $Failed, Return[$Failed]];
  seeds = Map[
    <|
      "Sector" -> "Top",
      "State" -> #1["State"],
      "Exponent" -> #1["Exponent"],
      "SectorVector" -> N[
        Flatten@KroneckerProduct[
          topLeftOuter, #1["LeadingVector"], topRightOuter
        ],
        wp
      ]
    |> &,
    topModes
  ];

  If[TrueQ[activity["LeftPinch"]],
    leftLine = ProjectLeadingTwoVertexLineTerm[
      {aM, aR}, "LeftMaximal"
    ];
    If[leftLine === $Failed, Return[$Failed]];
    leftOuter = outerVector[
      localNu0R, aR, localE3,
      <|"Kind" -> leftLine["RightKind"], "Nu" -> localNu2,
        "Momentum" -> localS2|>
    ];
    leftModes = XYZZProjectE2InfinityVertexModes[
      localNu0L + localNu0M - XYZZProjectPinchShift[localNu1],
      aM,
      {
        <|"Kind" -> leftLine["LeftKind"], "Nu" -> localNu2,
          "Momentum" -> localS2|>
      },
      wp
    ];
    If[MemberQ[{leftOuter, leftModes}, $Failed], Return[$Failed]];
    seeds = Join[
      seeds,
      Map[
        <|
          "Sector" -> "LeftPinch",
          "State" -> #1["State"],
          "Exponent" -> #1["Exponent"],
          "SectorVector" -> N[
            XYZZProjectPinchNormalization[localNu1, localS1, aL] *
              Flatten@KroneckerProduct[
                #1["LeadingVector"], leftOuter
              ],
            wp
          ]
        |> &,
        leftModes
      ]
    ];
  ];

  If[TrueQ[activity["RightPinch"]],
    rightLine = ProjectLeadingTwoVertexLineTerm[
      {aL, aM}, "RightMaximal"
    ];
    If[rightLine === $Failed, Return[$Failed]];
    rightOuter = outerVector[
      localNu0L, aL, localE1,
      <|"Kind" -> rightLine["LeftKind"], "Nu" -> localNu1,
        "Momentum" -> localS1|>
    ];
    rightModes = XYZZProjectE2InfinityVertexModes[
      localNu0M + localNu0R - XYZZProjectPinchShift[localNu2],
      aM,
      {
        <|"Kind" -> rightLine["RightKind"], "Nu" -> localNu1,
          "Momentum" -> localS1|>
      },
      wp
    ];
    If[MemberQ[{rightOuter, rightModes}, $Failed], Return[$Failed]];
    seeds = Join[
      seeds,
      Map[
        <|
          "Sector" -> "RightPinch",
          "State" -> #1["State"],
          "Exponent" -> #1["Exponent"],
          "SectorVector" -> N[
            XYZZProjectPinchNormalization[localNu2, localS2, aM] *
              Flatten@KroneckerProduct[
                rightOuter, #1["LeadingVector"]
              ],
            wp
          ]
        |> &,
        rightModes
      ]
    ];
  ];

  If[TrueQ[activity["DoublePinch"]],
    doubleModes = XYZZProjectE2InfinityVertexModes[
      localNu0L + localNu0M + localNu0R -
        XYZZProjectPinchShift[localNu1] -
        XYZZProjectPinchShift[localNu2],
      aM,
      {},
      wp
    ];
    If[doubleModes === $Failed, Return[$Failed]];
    seeds = Join[
      seeds,
      Map[
        <|
          "Sector" -> "DoublePinch",
          "State" -> #1["State"],
          "Exponent" -> #1["Exponent"],
          "SectorVector" -> N[
            XYZZProjectPinchNormalization[localNu1, localS1, aL] *
              XYZZProjectPinchNormalization[localNu2, localS2, aM] *
              #1["LeadingVector"],
            wp
          ]
        |> &,
        doubleModes
      ]
    ];
  ];
  seeds
];

Options[XYZZProjectE2InfinityLeadingModes] = {
  "WorkingPrecision" -> 50
};

XYZZProjectE2InfinityLeadingModes[
  residue_?MatrixQ,
  seeds_List,
  OptionsPattern[]
] := Module[
  {wp, topIndices, leftIndices, rightIndices, doubleIndices,
    rTT, rTL, rTR, rTD, rLL, rLD, rRR, rRD, solveBlock,
    leadingModes},
  wp = OptionValue["WorkingPrecision"];
  If[Dimensions[residue] =!= {25, 25}, Return[$Failed]];
  topIndices = Range[16];
  leftIndices = Range[17, 20];
  rightIndices = Range[21, 24];
  doubleIndices = {25};
  rTT = residue[[topIndices, topIndices]];
  rTL = residue[[topIndices, leftIndices]];
  rTR = residue[[topIndices, rightIndices]];
  rTD = residue[[topIndices, doubleIndices]];
  rLL = residue[[leftIndices, leftIndices]];
  rLD = residue[[leftIndices, doubleIndices]];
  rRR = residue[[rightIndices, rightIndices]];
  rRD = residue[[rightIndices, doubleIndices]];
  solveBlock[block_, exponent_, rhs_] := Quiet@Check[
    LinearSolve[
      N[exponent IdentityMatrix[Length[block]] - block, wp],
      N[rhs, wp]
    ],
    $Failed
  ];

  leadingModes = Table[
    Module[
      {sector, exponent, sectorVector, top, left, right, double,
        full, residualNorm, residualScale},
      sector = seed["Sector"];
      exponent = N[seed["Exponent"], wp];
      sectorVector = N[seed["SectorVector"], wp];
      top = ConstantArray[0, 16];
      left = ConstantArray[0, 4];
      right = ConstantArray[0, 4];
      double = {0};
      Switch[
        sector,
        "Top",
          top = sectorVector,
        "LeftPinch",
          left = sectorVector;
          top = solveBlock[rTT, exponent, rTL . left],
        "RightPinch",
          right = sectorVector;
          top = solveBlock[rTT, exponent, rTR . right],
        "DoublePinch",
          double = sectorVector;
          left = solveBlock[rLL, exponent, rLD . double];
          right = solveBlock[rRR, exponent, rRD . double];
          If[MemberQ[{left, right}, $Failed], Return[$Failed]];
          top = solveBlock[
            rTT,
            exponent,
            rTL . left + rTR . right + rTD . double
          ],
        _,
          Return[$Failed]
      ];
      If[MemberQ[{top, left, right, double}, $Failed], Return[$Failed]];
      full = N[Join[top, left, right, double], wp];
      residualNorm = Norm[(residue - exponent IdentityMatrix[25]) . full];
      residualScale = Max[Norm[residue . full], Abs[exponent] Norm[full], 10^-100];
      Join[
        seed,
        <|
          "Exponent" -> exponent,
          "LeadingVector" -> full,
          "IndicialRelativeResidual" -> N[residualNorm/residualScale, wp]
        |>
      ]
    ],
    {seed, seeds}
  ];
  If[MemberQ[leadingModes, $Failed], $Failed, leadingModes]
];

Options[XYZZProjectE2InfinityFrobeniusData] = {
  "WorkingPrecision" -> 50,
  "SeriesOrder" -> 10,
  "AccuracyGoal" -> 25,
  "PrecisionGoal" -> 25,
  "MaxRecursion" -> 14,
  "Cutoff" -> 35,
  "LowerCutoff" -> 10^-8,
  "OuterVertexEvaluation" -> "Direct",
  "OuterVertexSeriesOrder" -> 16
};

XYZZProjectE2InfinityFrobeniusData[
  signs : {(_Integer)..},
  rules_List,
  OptionsPattern[]
] := Module[
  {wp, seriesOrder, connectionData, residue, regularCoefficients,
    seeds, leadingModes, modes},
  wp = OptionValue["WorkingPrecision"];
  seriesOrder = OptionValue["SeriesOrder"];
  connectionData = XYZZProjectE2InfinityConnectionData[
    signs,
    rules,
    "WorkingPrecision" -> wp,
    "SeriesOrder" -> seriesOrder
  ];
  If[connectionData === $Failed, Return[$Failed]];
  residue = connectionData["ResidueMatrix"];
  regularCoefficients = connectionData["RegularConnectionCoefficients"];
  seeds = XYZZProjectE2InfinitySectorSeeds[
    signs,
    rules,
    "WorkingPrecision" -> wp,
    "AccuracyGoal" -> OptionValue["AccuracyGoal"],
    "PrecisionGoal" -> OptionValue["PrecisionGoal"],
    "MaxRecursion" -> OptionValue["MaxRecursion"],
    "Cutoff" -> OptionValue["Cutoff"],
    "LowerCutoff" -> OptionValue["LowerCutoff"],
    "OuterVertexEvaluation" -> OptionValue["OuterVertexEvaluation"],
    "OuterVertexSeriesOrder" -> OptionValue["OuterVertexSeriesOrder"]
  ];
  If[seeds === $Failed, Return[$Failed]];
  leadingModes = XYZZProjectE2InfinityLeadingModes[
    residue,
    seeds,
    "WorkingPrecision" -> wp
  ];
  If[leadingModes === $Failed, Return[$Failed]];

  modes = Table[
    Module[
      {exponent, coefficientVectors, recurrenceResiduals, rhs,
        recurrenceMatrix, nextVector, residualNorm, residualScale},
      exponent = mode["Exponent"];
      coefficientVectors = {mode["LeadingVector"]};
      recurrenceResiduals = {};
      Do[
        rhs = Sum[
          regularCoefficients[[regularOrder + 1]] .
            coefficientVectors[[order - regularOrder]],
          {regularOrder, 0, order - 1}
        ];
        recurrenceMatrix =
          (exponent + order) IdentityMatrix[25] - residue;
        nextVector = Quiet@Check[
          LinearSolve[N[recurrenceMatrix, wp], N[rhs, wp]],
          $Failed
        ];
        If[nextVector === $Failed, Return[$Failed]];
        nextVector = N[nextVector, wp];
        residualNorm = Norm[recurrenceMatrix . nextVector - rhs];
        residualScale = Max[
          Norm[recurrenceMatrix . nextVector], Norm[rhs], 10^-100
        ];
        coefficientVectors = Append[coefficientVectors, nextVector];
        recurrenceResiduals = Append[
          recurrenceResiduals,
          N[residualNorm/residualScale, wp]
        ],
        {order, 1, seriesOrder}
      ];
      Join[
        mode,
        <|
          "CoefficientVectors" -> coefficientVectors,
          "RecurrenceRelativeResiduals" -> recurrenceResiduals
        |>
      ]
    ],
    {mode, leadingModes}
  ];
  If[MemberQ[modes, $Failed], Return[$Failed]];
  Join[
    connectionData,
    <|
      "BoundaryAtInfinityQ" -> True,
      "BoundaryDefinition" ->
        "Frobenius germ at t=0 matched to Wick-rotated Hankel asymptotics",
      "Signs" -> signs,
      "Modes" -> modes
    |>
  ]
];

XYZZProjectE2InfinityEvaluate[
  data_Association,
  tValue_?NumericQ,
  requestedOrder_:Automatic
] := Module[
  {wp, order},
  wp = data["WorkingPrecision"];
  order = Replace[requestedOrder, Automatic :> data["SeriesOrder"]];
  If[
    !IntegerQ[order] || order < 0 || order > data["SeriesOrder"] ||
      tValue <= 0,
    Return[$Failed]
  ];
  N[
    Total@Table[
      tValue^mode["Exponent"] *
        Sum[
          mode["CoefficientVectors"][[n + 1]] tValue^n,
          {n, 0, order}
        ],
      {mode, data["Modes"]}
    ],
    wp
  ]
];

XYZZProjectE2InfinitySeriesDerivative[
  data_Association,
  tValue_?NumericQ,
  requestedOrder_:Automatic
] := Module[
  {wp, order},
  wp = data["WorkingPrecision"];
  order = Replace[requestedOrder, Automatic :> data["SeriesOrder"]];
  If[
    !IntegerQ[order] || order < 0 || order > data["SeriesOrder"] ||
      tValue <= 0,
    Return[$Failed]
  ];
  N[
    Total@Table[
      tValue^(mode["Exponent"] - 1) *
        Sum[
          (mode["Exponent"] + n) *
            mode["CoefficientVectors"][[n + 1]] tValue^n,
          {n, 0, order}
        ],
      {mode, data["Modes"]}
    ],
    wp
  ]
];

XYZZProjectE2InfinitySeriesResidual[
  data_Association,
  tValue_?NumericQ,
  requestedOrder_:Automatic
] := Module[
  {wp, t, yValue, derivativeValue, connectionValue, rhsValue},
  wp = data["WorkingPrecision"];
  t = data["SeriesVariable"];
  yValue = XYZZProjectE2InfinityEvaluate[
    data, tValue, requestedOrder
  ];
  derivativeValue = XYZZProjectE2InfinitySeriesDerivative[
    data, tValue, requestedOrder
  ];
  If[MemberQ[{yValue, derivativeValue}, $Failed], Return[$Failed]];
  connectionValue = N[
    data["ConnectionExpression"] /. t -> N[tValue, wp],
    wp
  ];
  rhsValue = connectionValue . yValue;
  N[
    Norm[derivativeValue - rhsValue]/
      Max[Norm[derivativeValue], Norm[rhsValue], 10^-100],
    wp
  ]
];

Options[XYZZSolveProjectBranchE2FromInfinity] = {
  "WorkingPrecision" -> 50,
  "AccuracyGoal" -> 30,
  "PrecisionGoal" -> 30,
  "MaxStepFraction" -> 1/200,
  "SeriesOrder" -> 10,
  "BoundaryAccuracyGoal" -> 25,
  "SeriesStartT" -> Automatic,
  "SeriesSafetyFactor" -> 1/20,
  "MaxSeriesHalvings" -> 20,
  "BoundaryGuardDigits" -> 20,
  "BoundaryMaxRecursion" -> 14,
  "BoundaryCutoff" -> 35,
  "BoundaryLowerCutoff" -> 10^-8,
  "OuterVertexEvaluation" -> "Direct",
  "OuterVertexSeriesOrder" -> 16
};

XYZZSolveProjectBranchE2FromInfinity[
  signs : {(_Integer)..},
  rules_List,
  e2End_?NumericQ,
  OptionsPattern[]
] := Module[
  {wp, boundaryWP, guardDigits, boundaryComputationGoal, seriesOrder,
    boundaryAccuracyGoal, tEnd, rulesNoE2, scaleValues,
    scale, tStartOption, tStart, maxHalvings, tolerance, data,
    boundaryAtStartHigh, previousBoundaryHigh, boundaryAtStart,
    truncationEstimate, halvings,
    t, connectionExpression, connectionFunction, solution, currentRaw,
    currentRules, seriesResidual},
  If[!XYZZLoadProjectCore[], Return[$Failed]];
  wp = OptionValue["WorkingPrecision"];
  guardDigits = OptionValue["BoundaryGuardDigits"];
  boundaryWP = wp + guardDigits;
  seriesOrder = OptionValue["SeriesOrder"];
  boundaryAccuracyGoal = OptionValue["BoundaryAccuracyGoal"];
  boundaryComputationGoal = Min[
    boundaryWP - 10,
    Max[
      boundaryAccuracyGoal + 10,
      OptionValue["AccuracyGoal"] + 10,
      OptionValue["PrecisionGoal"] + 10
    ]
  ];
  tEnd = N[1/e2End, boundaryWP];
  If[!NumericQ[tEnd] || tEnd <= 0, Return[$Failed]];
  rulesNoE2 = DeleteCases[rules, E2 -> _];
  data = XYZZProjectE2InfinityFrobeniusData[
    signs,
    rulesNoE2,
    "WorkingPrecision" -> boundaryWP,
    "SeriesOrder" -> seriesOrder,
    "AccuracyGoal" -> boundaryComputationGoal,
    "PrecisionGoal" -> boundaryComputationGoal,
    "MaxRecursion" -> OptionValue["BoundaryMaxRecursion"],
    "Cutoff" -> OptionValue["BoundaryCutoff"],
    "LowerCutoff" -> OptionValue["BoundaryLowerCutoff"],
    "OuterVertexEvaluation" -> OptionValue["OuterVertexEvaluation"],
    "OuterVertexSeriesOrder" -> OptionValue["OuterVertexSeriesOrder"]
  ];
  If[data === $Failed, Return[$Failed]];
  scaleValues = N[Abs[{E1, E3, s1, s2} /. rulesNoE2], boundaryWP];
  If[!VectorQ[scaleValues, NumericQ], Return[$Failed]];
  scale = Max[1, Sequence @@ scaleValues];
  tStartOption = OptionValue["SeriesStartT"];
  tStart = If[
    tStartOption === Automatic,
    Min[tEnd, N[OptionValue["SeriesSafetyFactor"]/scale, boundaryWP]],
    Min[tEnd, N[tStartOption, boundaryWP]]
  ];
  If[!NumericQ[tStart] || tStart <= 0, Return[$Failed]];
  maxHalvings = OptionValue["MaxSeriesHalvings"];
  tolerance = N[10^-boundaryAccuracyGoal, boundaryWP];
  halvings = 0;
  boundaryAtStartHigh = XYZZProjectE2InfinityEvaluate[data, tStart];
  previousBoundaryHigh = XYZZProjectE2InfinityEvaluate[
    data, tStart, seriesOrder - 1
  ];
  truncationEstimate = N[
    Norm[boundaryAtStartHigh - previousBoundaryHigh]/
      Max[Norm[boundaryAtStartHigh], 10^-100],
    boundaryWP
  ];
  While[
    truncationEstimate > tolerance && halvings < maxHalvings,
    tStart = tStart/2;
    halvings++;
    boundaryAtStartHigh = XYZZProjectE2InfinityEvaluate[data, tStart];
    previousBoundaryHigh = XYZZProjectE2InfinityEvaluate[
      data, tStart, seriesOrder - 1
    ];
    truncationEstimate = N[
      Norm[boundaryAtStartHigh - previousBoundaryHigh]/
        Max[Norm[boundaryAtStartHigh], 10^-100],
      boundaryWP
    ];
  ];
  If[truncationEstimate > tolerance, Return[$Failed]];
  seriesResidual = XYZZProjectE2InfinitySeriesResidual[data, tStart];
  boundaryAtStart = N[boundaryAtStartHigh, wp];
  t = data["SeriesVariable"];
  connectionExpression = data["ConnectionExpression"];
  If[
    TrueQ[tStart == tEnd],
    currentRaw = boundaryAtStart,
    connectionFunction[x_?NumericQ] := N[
      connectionExpression /. t -> N[x, boundaryWP],
      wp
    ];
    solution = NDSolveValue[
      {
        y'[x] == connectionFunction[x] . y[x],
        y[tStart] == boundaryAtStart
      },
      y,
      {x, tStart, tEnd},
      WorkingPrecision -> wp,
      AccuracyGoal -> OptionValue["AccuracyGoal"],
      PrecisionGoal -> OptionValue["PrecisionGoal"],
      MaxStepFraction -> OptionValue["MaxStepFraction"],
      MaxSteps -> Infinity,
      Method -> "StiffnessSwitching"
    ];
    currentRaw = N[solution[N[tEnd, wp]], wp]
  ];
  currentRules = Join[rulesNoE2, {E2 -> e2End}];
  <|
    "Signs" -> signs,
    "RawBoundary25" -> currentRaw,
    "Rules" -> currentRules,
    "Segments" -> {
      <|
        "Variable" -> E2,
        "Range" -> {e2End, Infinity},
        "EvolutionVariable" -> "InverseTFromTrueInfinity",
        "TRange" -> {0, tEnd},
        "SeriesPatchT" -> tStart,
        "SeriesPatchE2" -> 1/tStart,
        "SeriesOrder" -> seriesOrder,
        "BoundaryWorkingPrecision" -> boundaryWP,
        "SeriesHalvings" -> halvings,
        "EstimatedRelativeTruncation" -> truncationEstimate,
        "SeriesODERelativeResidual" -> seriesResidual,
        "Jacobian" -> "-1/t^2",
        "TransportMethod" -> "NDSolve",
        "AutomaticODESolverUsedQ" -> True,
        "BoundaryAtInfinityQ" -> True,
        "SystemBasis" -> "Raw"
      |>
    },
    "WorkingPrecision" -> wp,
    "BoundaryAtInfinityQ" -> True,
    "FrobeniusData" -> data
  |>
];

XYZZSolveProjectBranch[
  signs : {(_Integer)..},
  rules_List,
  {sEnd_?NumericQ, sStart_?NumericQ},
  OptionsPattern[]
] := Module[
  {wp, rulesNoS1, mExpression, mFunction, init, initialRawVector,
    solution, systemBasis},
  If[!XYZZLoadProjectCore[], Return[$Failed]];
  wp = OptionValue["WorkingPrecision"];
  systemBasis = OptionValue["SystemBasis"];
  rulesNoS1 = DeleteCases[rules, s1 -> _];
  mExpression = Switch[
    systemBasis,
    "Raw", XYZZProjectRawBranchMatrix[signs],
    "LegacyMixed", XYZZProjectBranchMatrix[signs],
    _, Return[$Failed]
  ] /. rulesNoS1;
  mFunction[s_?NumericQ] := N[
    mExpression /. s1 -> N[s, wp],
    wp
  ];
  initialRawVector = OptionValue["InitialRawVector"];
  init = If[
    initialRawVector === Automatic,
    XYZZProjectBranchDlogInit[
      signs, rulesNoS1, sStart, wp,
      "SystemBasis" -> systemBasis,
      "BoundaryMode" -> OptionValue["BoundaryMode"],
      "BoundaryAccuracyGoal" -> OptionValue["BoundaryAccuracyGoal"],
      "BoundaryPrecisionGoal" -> OptionValue["BoundaryPrecisionGoal"],
      "BoundaryMaxRecursion" -> OptionValue["BoundaryMaxRecursion"],
      "BoundaryCutoff" -> OptionValue["BoundaryCutoff"],
      "BoundaryLowerCutoff" -> OptionValue["BoundaryLowerCutoff"]
    ],
    If[
      !VectorQ[initialRawVector] || Length[initialRawVector] =!= 25,
      Return[$Failed]
    ];
    LinearSolve[
      XYZZProjectSystemToRaw[systemBasis, wp],
      N[initialRawVector, wp]
    ]
  ];
  If[init === $Failed, Return[$Failed]];
  solution = NDSolveValue[
    {
      y'[s] == mFunction[s] . y[s],
      y[sStart] == init
    },
    y,
    {s, sEnd, sStart},
    WorkingPrecision -> wp,
    AccuracyGoal -> OptionValue["AccuracyGoal"],
    PrecisionGoal -> OptionValue["PrecisionGoal"],
    MaxStepFraction -> OptionValue["MaxStepFraction"],
    MaxSteps -> Infinity,
    Method -> "StiffnessSwitching"
  ];
  <|"Signs" -> signs, "Solution" -> solution, "Rules" -> rulesNoS1,
    "Range" -> {sEnd, sStart}, "WorkingPrecision" -> wp,
    "SystemBasis" -> systemBasis|>
];

XYZZSolveProjectAllBranches[
  rules_List,
  range : {sEnd_?NumericQ, sStart_?NumericQ},
  options : OptionsPattern[XYZZSolveProjectBranch]
] := Association@Table[
  signs -> XYZZSolveProjectBranch[signs, rules, range, options],
  {signs, Tuples[{-1, 1}, 3]}
];

XYZZProjectIndependentBranchSigns[] := {
  {1, 1, 1},
  {1, 1, -1},
  {1, -1, 1},
  {-1, 1, 1}
};

XYZZSolveProjectIndependentBranches[
  rules_List,
  range : {sEnd_?NumericQ, sStart_?NumericQ},
  options : OptionsPattern[XYZZSolveProjectBranch]
] := Association@Table[
  signs -> XYZZSolveProjectBranch[signs, rules, range, options],
  {signs, XYZZProjectIndependentBranchSigns[]}
];

XYZZCompleteProjectBranchValuesByConjugation::disabled =
  "Raw branch conjugation is disabled.  Complete SK branches only after mapping each independent raw branch to paper convention with XYZZProjectIndependentRawToPaperValues and then using XYZZCompletePaperBranchValuesByConjugation.";

XYZZProjectConjugateCompletedBranchValues::disabled =
  XYZZCompleteProjectBranchValuesByConjugation::disabled;

XYZZProjectStrippedConjugateCompletedSKSum::disabled =
  XYZZCompleteProjectBranchValuesByConjugation::disabled;

XYZZCompleteProjectBranchValuesByConjugation[
  independentValues_Association
] := (
  Message[XYZZCompleteProjectBranchValuesByConjugation::disabled];
  $Failed
);

XYZZProjectBranchTop0000[branch_Association, s_?NumericQ] := Module[
  {raw},
  raw = XYZZProjectSystemToRaw[
      Lookup[branch, "SystemBasis", "LegacyMixed"],
      branch["WorkingPrecision"]
    ] .
    branch["Solution"][s];
  raw[[1]]
];

XYZZProjectConjugateCompletedBranchValues[
  independentBranches_Association,
  s_?NumericQ
] := (
  Message[XYZZProjectConjugateCompletedBranchValues::disabled];
  $Failed
);

XYZZProjectStrippedSignedSKSum[branches_Association, s_?NumericQ] :=
  Total@KeyValueMap[
    XYZZProjectBranchSKSign[#1] XYZZProjectBranchTop0000[#2, s] &,
    branches
  ];

XYZZProjectStrippedConjugateCompletedSKSum[
  independentBranches_Association,
  s_?NumericQ
] := (
  Message[XYZZProjectStrippedConjugateCompletedSKSum::disabled];
  $Failed
);

(* ::Section::Closed:: *)
(* ====================================================================== *)
(* Part 2 - project-to-xyzz convention code *)
(* ====================================================================== *)

(* Convention map from stripped project master integrals to xyzz Eq. (83). *)

ClearAll[
  XYZZVertexFactor, XYZZProjectDimensionlessFactor,
  XYZZProjectPropagatorFactor, XYZZProjectCommonToPaperFactor,
  XYZZProjectBranchToPaperFactor, XYZZProjectToPaperFactor,
  XYZZSignedBranchSum, XYZZProjectBranchesToPaperSeed,
  XYZZProjectIndependentRawToPaperValues,
  XYZZCompletePaperBranchValuesByConjugation,
  XYZZProjectIndependentRawToPaperSeed
];

XYZZVertexFactor[signs_List] := Times @@ (I signs);

XYZZProjectDimensionlessFactor[
  {p1_, p2_, p3_}, {e1_, e2_, e3_}, {s1_, s2_}
] :=
  e1^(p1 + 1) e2^(p2 + 1) e3^(p3 + 1) s1^3 s2^3;

(* Exp[-Pi mu] H2[-I mu,z] = H2[I mu,z], so no Boltzmann factor
   remains after converting the paper endpoint to the project's common order. *)
XYZZProjectPropagatorFactor[{nu1_, nu2_}, {s1_, s2_}] :=
  (Pi/4)^2 s1^(2 nu1) s2^(2 nu2);

XYZZProjectCommonToPaperFactor[p_, nu_, energies_, momenta_] :=
  XYZZProjectDimensionlessFactor[p, energies, momenta] *
    XYZZProjectPropagatorFactor[nu, momenta];

XYZZProjectBranchToPaperFactor[signs_, p_, nu_, energies_, momenta_] :=
  XYZZVertexFactor[signs] *
    XYZZProjectCommonToPaperFactor[p, nu, energies, momenta];

XYZZProjectToPaperFactor[p_, nu_, energies_, momenta_] :=
  I^3 *
    XYZZProjectCommonToPaperFactor[p, nu, energies, momenta];

XYZZSignedBranchSum[branches_Association, valueFunction_] :=
  Total@KeyValueMap[(Times @@ #1) valueFunction[#1, #2] &, branches];

XYZZProjectBranchesToPaperSeed[
  branches_Association, valueFunction_, p_, nu_, energies_, momenta_
] :=
  XYZZProjectToPaperFactor[p, nu, energies, momenta] *
    XYZZSignedBranchSum[branches, valueFunction];

XYZZProjectIndependentRawToPaperValues[
  independentRawValues_Association, commonFactor_
] := Association@KeyValueMap[
  #1 -> XYZZVertexFactor[#1] commonFactor #2 &,
  independentRawValues
];

XYZZCompletePaperBranchValuesByConjugation[
  independentPaperValues_Association
] := Association@Join[
  Normal[independentPaperValues],
  KeyValueMap[-#1 -> Conjugate[#2] &, independentPaperValues]
];

XYZZProjectIndependentRawToPaperSeed[
  independentRawValues_Association, commonFactor_
] := Total@Values@XYZZCompletePaperBranchValuesByConjugation[
  XYZZProjectIndependentRawToPaperValues[independentRawValues, commonFactor]
];

(* ::Section::Closed:: *)
(* ====================================================================== *)
(* Part 3A - xyzz Eq.(103) base analytic code *)
(* ====================================================================== *)

(* Xianyu-Zang arXiv:2309.10849v2, Eqs. (103)-(110), (141)-(143).
   The total formula assumes real p_i, real heavy masses, and positive r_i. *)

ClearAll[
  XYZZSeriesPower,
  XYZZDressedF, XYZZDressedF2, XYZZDressedF4,
  XYZZThreeVertexC, XYZZThreeVertexA, XYZZThreeVertexB,
  XYZZThreeVertexISS, XYZZThreeVertexISB, XYZZThreeVertexIBS,
  XYZZThreeVertexIBB, XYZZThreeVertexPieces, XYZZThreeVertexBase,
  XYZZThreeVertexTotal, XYZZThreeVertexF2ConvergenceQ,
  XYZZPaperMuFromProjectNu,
  XYZZProjectNu0FromPaperP, XYZZPaperFromProjectStrippedFactor
];

XYZZSeriesPower[x_, 0] := 1;
XYZZSeriesPower[x_, n_Integer?Positive] := x^n;

XYZZDressedF[a_, b_, z_] :=
  Gamma[a] Gamma[b] Hypergeometric2F1[a/2, (1 + a)/2, 1 - b, z];

XYZZDressedF2[a_, b1_, b2_, c1_, c2_, x_, y_, nMax_Integer?NonNegative] :=
  Total@Flatten@Table[
    Gamma[a + m + n] Gamma[b1 + m] Gamma[b2 + n]/
      (Gamma[c1 + m] Gamma[c2 + n]) *
      XYZZSeriesPower[x, m] XYZZSeriesPower[y, n]/(m! n!),
    {m, 0, nMax}, {n, 0, nMax}
  ];

XYZZDressedF4[a_, b_, c1_, c2_, x_, y_, nMax_Integer?NonNegative] :=
  Total@Flatten@Table[
    Gamma[a + m + n] Gamma[b + m + n]/
      (Gamma[c1 + m] Gamma[c2 + n]) *
      XYZZSeriesPower[x, m] XYZZSeriesPower[y, n]/(m! n!),
    {m, 0, nMax}, {n, 0, nMax}
  ];

XYZZThreeVertexC[{p1_, p2_, p3_}, {mu1_, mu2_}, {a1_, a2_}] := Module[
  {p12 = p1 + p2, p23 = p2 + p3, p13 = p1 + p3, p123 = p1 + p2 + p3},
  2^(2 p2 - 1 + I a1 mu1 + I a2 mu2)/
    (Sqrt[Pi] Sin[I a1 Pi mu1] Sin[I a2 Pi mu2]) *
    (
      -Exp[-I Pi (I a1 mu1 + I a2 mu2 + p123/2)]
      + I Exp[-I Pi (I a1 mu1 + p12/2 - p3/2)]
      + I Exp[-I Pi (I a2 mu2 - p1/2 + p23/2)]
      + Exp[I Pi (-p2/2 + p13/2)]
    )
];

XYZZThreeVertexA[
  p : {p1_, p2_, p3_},
  mu : {mu1_, mu2_},
  {a1_, a2_},
  {r1_, r2_, r3_, r4_},
  nMax_Integer?NonNegative
] :=
  XYZZThreeVertexC[p, mu, {a1, a2}] (r1 r2 r3 r4)^(3/2) *
  XYZZDressedF[p1 + I mu1 + 5/2, -I mu1, r1^2] *
  XYZZDressedF[p3 + I mu2 + 5/2, -I mu2, r4^2] *
  XYZZDressedF4[
    (I a1 mu1 + I a2 mu2 + p2 + 4)/2,
    (I a1 mu1 + I a2 mu2 + p2 + 5)/2,
    1 + I a1 mu1,
    1 + I a2 mu2,
    r2^2,
    r3^2,
    nMax
  ];

XYZZThreeVertexB[
  {p1_, p2_, p3_},
  {mu1_, mu2_},
  a_,
  {r1_, r2_, r3_, r4_},
  nMax_Integer?NonNegative
] := Module[
  {p23 = p2 + p3, prefactor, sum},
  prefactor =
    Exp[-I Pi (p23 + I a mu1 - 1/2)/2]/(4 Pi^2) *
    Sin[Pi (I a mu1 + p1 - 3/2)/2] Sin[I Pi mu2] *
    (r1 r2 r3^2)^(3/2) *
    XYZZDressedF[p1 + I mu1 + 5/2, -I mu1, r1^2];

  sum = Total@Flatten@Table[
    (-1)^(n1 + n2 + n3)/(n1! n2! n3!) *
    Gamma[-n1 - I mu2] Gamma[-n2 + I mu2]/
      (p3 + n3 + 2 n2 - I mu2 + 5/2) *
    (r3/2)^(2 (n1 + n2)) (r3/r4)^(n3 + p3 + 1) *
    XYZZDressedF[
      n3 + 2 (n1 + n2) + p23 + I a mu1 + 13/2,
      -I a mu1,
      r2^2
    ],
    {n1, 0, nMax}, {n2, 0, nMax}, {n3, 0, nMax}
  ];

  prefactor sum
];

XYZZThreeVertexISS[p_, mu : {mu1_, mu2_}, r : {r1_, r2_, r3_, r4_},
  nMax_Integer?NonNegative] :=
  Total@Flatten@Table[
    XYZZThreeVertexA[p, mu, {a1, a2}, r, nMax] *
    (r1/2)^(I mu1) (r2/2)^(I a1 mu1) *
    (r3/2)^(I a2 mu2) (r4/2)^(I mu2),
    {a1, {-1, 1}}, {a2, {-1, 1}}
  ];

XYZZThreeVertexISB[p_, mu : {mu1_, mu2_}, r : {r1_, r2_, r3_, r4_},
  nMax_Integer?NonNegative] :=
  Total@Table[
    XYZZThreeVertexB[p, mu, a, r, nMax] *
    (r1/2)^(I mu1) (r2/2)^(I a mu1),
    {a, {-1, 1}}
  ];

XYZZThreeVertexIBS[
  {p1_, p2_, p3_},
  {mu1_, mu2_},
  {r1_, r2_, r3_, r4_},
  nMax_Integer?NonNegative
] :=
  Total@Table[
    XYZZThreeVertexB[
      {p3, p2, p1}, {mu2, mu1}, a, {r4, r3, r2, r1}, nMax
    ] *
    (r4/2)^(I mu2) (r3/2)^(I a mu2),
    {a, {-1, 1}}
  ];

XYZZThreeVertexIBB[
  {p1_, p2_, p3_},
  {mu1_, mu2_},
  {r1_, r2_, r3_, r4_},
  nMax_Integer?NonNegative
] := XYZZThreeVertexIBB[
  {p1, p2, p3}, {mu1, mu2}, {r1, r2, r3, r4}, nMax, nMax
];

XYZZThreeVertexIBB[
  {p1_, p2_, p3_},
  {mu1_, mu2_},
  {r1_, r2_, r3_, r4_},
  nOuter_Integer?NonNegative,
  nF2_Integer?NonNegative
] := Module[
  {p123 = p1 + p2 + p3, prefactor},
  prefactor =
    Sin[I Pi mu1] Sin[I Pi mu2] Exp[-I p123 Pi/2]/(4 Pi^2) *
    r2^3 r3^3 (r2/r1)^(p1 + 1) (r3/r4)^(p3 + 1);

  prefactor Total@Flatten@Table[
    (r2/2)^(2 (n1 + n2)) (r3/2)^(2 (n3 + n4))/
      (n1! n2! n3! n4!) *
    Gamma[-n1 - I mu1] Gamma[-n2 + I mu1] *
    Gamma[-n3 + I mu2] Gamma[-n4 - I mu2] *
    XYZZDressedF2[
      p123 + 2 (n1 + n2 + n3 + n4) + 9,
      p1 + 2 n1 + I mu1 + 5/2,
      p3 + 2 n4 + I mu2 + 5/2,
      p1 + 2 n1 + I mu1 + 7/2,
      p3 + 2 n4 + I mu2 + 7/2,
      -r2/r1,
      -r3/r4,
      nF2
    ],
    {n1, 0, nOuter}, {n2, 0, nOuter}, {n3, 0, nOuter}, {n4, 0, nOuter}
  ]
];

XYZZThreeVertexPieces[p_, mu_, r_, nMax_Integer?NonNegative] := <|
  "SS" -> XYZZThreeVertexISS[p, mu, r, nMax],
  "SB" -> XYZZThreeVertexISB[p, mu, r, nMax],
  "BS" -> XYZZThreeVertexIBS[p, mu, r, nMax],
  "BB" -> XYZZThreeVertexIBB[p, mu, r, nMax]
|>;

XYZZThreeVertexBase[p_, mu_, r_, nMax_Integer?NonNegative] :=
  Total[Values[XYZZThreeVertexPieces[p, mu, r, nMax]]];

XYZZThreeVertexTotal[p_, {mu1_, mu2_}, r_, nMax_Integer?NonNegative] :=
  2 Re@Total@Flatten@Table[
    XYZZThreeVertexBase[p, {a1 mu1, a2 mu2}, r, nMax],
    {a1, {-1, 1}}, {a2, {-1, 1}}
  ];

XYZZThreeVertexF2ConvergenceQ[{r1_, r2_, r3_, r4_}] :=
  TrueQ[Abs[r2/r1] + Abs[r3/r4] < 1];

XYZZPaperMuFromProjectNu[{nu1_, nu2_}] := -I {nu1, nu2};

XYZZProjectNu0FromPaperP[
  {p1_, p2_, p3_},
  {nu1_, nu2_}
] := {
  p1 + 3/2 + nu1,
  p2 + 3 + nu1 + nu2,
  p3 + 3/2 + nu2
};

XYZZPaperFromProjectStrippedFactor[
  {p1_, p2_, p3_},
  {nu1_, nu2_},
  {e1_, e2_, e3_},
  {s1_, s2_}
] :=
  -I e1^(p1 + 1) e2^(p2 + 1) e3^(p3 + 1) s1^3 s2^3 *
    (Pi/4)^2 s1^(2 nu1) s2^(2 nu2);

(* ::Section::Closed:: *)
(* ====================================================================== *)
(* Part 3B - xyzz Eq.(103) fast summation code *)
(* ====================================================================== *)

ClearAll[
  XYZZDressedF2OneDimensionalSum,
  XYZZDressedF4OneDimensionalSum,
  XYZZThreeVertexAFast,
  XYZZThreeVertexIBBFast,
  XYZZThreeVertexIBBProjectConventionFast,
  XYZZThreeVertexIBBProjectConventionCorrectionFast,
  XYZZThreeVertexTotalProjectConventionCorrectionFast,
  XYZZThreeVertexPiecesFast,
  XYZZThreeVertexBaseFast,
  XYZZThreeVertexTotalFast
];

(* Valid in the same interior convergence domain used for Eq. (103).  The
   Appell-type double sums are summed analytically in x through Gauss 2F1,
   leaving only the y-series truncation. *)

XYZZDressedF2OneDimensionalSum[
  a_, b1_, b2_, c1_, c2_, x_, y_, nMax_Integer?NonNegative
] :=
  Total@Table[
    Gamma[a + n] Gamma[b1] Gamma[b2 + n]/
      (Gamma[c1] Gamma[c2 + n]) *
      XYZZSeriesPower[y, n]/n! *
      Hypergeometric2F1[a + n, b1, c1, x],
    {n, 0, nMax}
  ];

XYZZDressedF4OneDimensionalSum[
  a_, b_, c1_, c2_, x_, y_, nMax_Integer?NonNegative
] :=
  Total@Table[
    Gamma[a + n] Gamma[b + n]/
      (Gamma[c1] Gamma[c2 + n]) *
      XYZZSeriesPower[y, n]/n! *
      Hypergeometric2F1[a + n, b + n, c1, x],
    {n, 0, nMax}
  ];

XYZZThreeVertexAFast[
  p : {p1_, p2_, p3_},
  mu : {mu1_, mu2_},
  {a1_, a2_},
  {r1_, r2_, r3_, r4_},
  nMax_Integer?NonNegative
] :=
  XYZZThreeVertexC[p, mu, {a1, a2}] (r1 r2 r3 r4)^(3/2) *
  XYZZDressedF[p1 + I mu1 + 5/2, -I mu1, r1^2] *
  XYZZDressedF[p3 + I mu2 + 5/2, -I mu2, r4^2] *
  XYZZDressedF4OneDimensionalSum[
    (I a1 mu1 + I a2 mu2 + p2 + 4)/2,
    (I a1 mu1 + I a2 mu2 + p2 + 5)/2,
    1 + I a1 mu1,
    1 + I a2 mu2,
    r2^2,
    r3^2,
    nMax
  ];

XYZZThreeVertexIBBFast[
  {p1_, p2_, p3_},
  {mu1_, mu2_},
  {r1_, r2_, r3_, r4_},
  nMax_Integer?NonNegative
] := XYZZThreeVertexIBBFast[
  {p1, p2, p3}, {mu1, mu2}, {r1, r2, r3, r4}, nMax, nMax
];

XYZZThreeVertexIBBFast[
  {p1_, p2_, p3_},
  {mu1_, mu2_},
  {r1_, r2_, r3_, r4_},
  nOuter_Integer?NonNegative,
  nF2_Integer?NonNegative
] := Module[
  {p123 = p1 + p2 + p3, prefactor},
  prefactor =
    Sin[I Pi mu1] Sin[I Pi mu2] Exp[-I p123 Pi/2]/(4 Pi^2) *
    r2^3 r3^3 (r2/r1)^(p1 + 1) (r3/r4)^(p3 + 1);

  prefactor Total@Flatten@Table[
    (r2/2)^(2 (n1 + n2)) (r3/2)^(2 (n3 + n4))/
      (n1! n2! n3! n4!) *
    Gamma[-n1 - I mu1] Gamma[-n2 + I mu1] *
    Gamma[-n3 + I mu2] Gamma[-n4 - I mu2] *
    XYZZDressedF2OneDimensionalSum[
      p123 + 2 (n1 + n2 + n3 + n4) + 9,
      p1 + 2 n1 + I mu1 + 5/2,
      p3 + 2 n4 + I mu2 + 5/2,
      p1 + 2 n1 + I mu1 + 7/2,
      p3 + 2 n4 + I mu2 + 7/2,
      -r2/r1,
      -r3/r4,
      nF2
    ],
    {n1, 0, nOuter}, {n2, 0, nOuter},
    {n3, 0, nOuter}, {n4, 0, nOuter}
  ]
];

(* The project Wick-rotated double-pinch residue carries one extra
   (-1)^(n1+n2+n3+n4) relative to the BB series printed in Eq. (107).
   Keep the printed paper formula above unchanged and expose the conversion
   explicitly for 25D-project comparisons. *)
XYZZThreeVertexIBBProjectConventionFast[
  {p1_, p2_, p3_},
  {mu1_, mu2_},
  {r1_, r2_, r3_, r4_},
  nMax_Integer?NonNegative
] := XYZZThreeVertexIBBProjectConventionFast[
  {p1, p2, p3}, {mu1, mu2}, {r1, r2, r3, r4}, nMax, nMax
];

XYZZThreeVertexIBBProjectConventionFast[
  {p1_, p2_, p3_},
  {mu1_, mu2_},
  {r1_, r2_, r3_, r4_},
  nOuter_Integer?NonNegative,
  nF2_Integer?NonNegative
] := Module[
  {p123 = p1 + p2 + p3, prefactor},
  prefactor =
    Sin[I Pi mu1] Sin[I Pi mu2] Exp[-I p123 Pi/2]/(4 Pi^2) *
      r2^3 r3^3 (r2/r1)^(p1 + 1) (r3/r4)^(p3 + 1);

  prefactor Total@Flatten@Table[
    (-1)^(n1 + n2 + n3 + n4) *
    (r2/2)^(2 (n1 + n2)) (r3/2)^(2 (n3 + n4))/
      (n1! n2! n3! n4!) *
    Gamma[-n1 - I mu1] Gamma[-n2 + I mu1] *
    Gamma[-n3 + I mu2] Gamma[-n4 - I mu2] *
    XYZZDressedF2OneDimensionalSum[
      p123 + 2 (n1 + n2 + n3 + n4) + 9,
      p1 + 2 n1 + I mu1 + 5/2,
      p3 + 2 n4 + I mu2 + 5/2,
      p1 + 2 n1 + I mu1 + 7/2,
      p3 + 2 n4 + I mu2 + 7/2,
      -r2/r1,
      -r3/r4,
      nF2
    ],
    {n1, 0, nOuter}, {n2, 0, nOuter},
    {n3, 0, nOuter}, {n4, 0, nOuter}
  ]
];

XYZZThreeVertexIBBProjectConventionCorrectionFast[
  {p1_, p2_, p3_},
  {mu1_, mu2_},
  {r1_, r2_, r3_, r4_},
  nOuter_Integer?NonNegative,
  nF2_Integer?NonNegative
] := Module[
  {p123 = p1 + p2 + p3, prefactor, parityDifference},
  prefactor =
    Sin[I Pi mu1] Sin[I Pi mu2] Exp[-I p123 Pi/2]/(4 Pi^2) *
      r2^3 r3^3 (r2/r1)^(p1 + 1) (r3/r4)^(p3 + 1);

  prefactor Total@Flatten@Table[
    parityDifference = (-1)^(n1 + n2 + n3 + n4) - 1;
    If[parityDifference == 0,
      0,
      parityDifference *
      (r2/2)^(2 (n1 + n2)) (r3/2)^(2 (n3 + n4))/
        (n1! n2! n3! n4!) *
      Gamma[-n1 - I mu1] Gamma[-n2 + I mu1] *
      Gamma[-n3 + I mu2] Gamma[-n4 - I mu2] *
      XYZZDressedF2OneDimensionalSum[
        p123 + 2 (n1 + n2 + n3 + n4) + 9,
        p1 + 2 n1 + I mu1 + 5/2,
        p3 + 2 n4 + I mu2 + 5/2,
        p1 + 2 n1 + I mu1 + 7/2,
        p3 + 2 n4 + I mu2 + 7/2,
        -r2/r1,
        -r3/r4,
        nF2
      ]
    ],
    {n1, 0, nOuter}, {n2, 0, nOuter},
    {n3, 0, nOuter}, {n4, 0, nOuter}
  ]
];

XYZZThreeVertexTotalProjectConventionCorrectionFast[
  p_, {mu1_, mu2_}, r_, nOuter_Integer?NonNegative,
  nF2_Integer?NonNegative
] :=
  2 Re@Total@Flatten@Table[
    XYZZThreeVertexIBBProjectConventionCorrectionFast[
      p, {a1 mu1, a2 mu2}, r, nOuter, nF2
    ],
    {a1, {-1, 1}}, {a2, {-1, 1}}
  ];

XYZZThreeVertexPiecesFast[p_, mu : {mu1_, mu2_}, r : {r1_, r2_, r3_, r4_},
  nMax_Integer?NonNegative] := XYZZThreeVertexPiecesFast[p, mu, r, nMax, nMax];

XYZZThreeVertexPiecesFast[p_, mu : {mu1_, mu2_}, r : {r1_, r2_, r3_, r4_},
  nOuter_Integer?NonNegative, nF2_Integer?NonNegative] := <|
  "SS" -> Total@Flatten@Table[
    XYZZThreeVertexAFast[p, mu, {a1, a2}, r, nF2] *
    (r1/2)^(I mu1) (r2/2)^(I a1 mu1) *
    (r3/2)^(I a2 mu2) (r4/2)^(I mu2),
    {a1, {-1, 1}}, {a2, {-1, 1}}
  ],
  "SB" -> XYZZThreeVertexISB[p, mu, r, nOuter],
  "BS" -> XYZZThreeVertexIBS[p, mu, r, nOuter],
  "BB" -> XYZZThreeVertexIBBFast[p, mu, r, nOuter, nF2]
|>;

XYZZThreeVertexBaseFast[p_, mu_, r_, nMax_Integer?NonNegative] :=
  Total[Values[XYZZThreeVertexPiecesFast[p, mu, r, nMax]]];

XYZZThreeVertexBaseFast[p_, mu_, r_, nOuter_Integer?NonNegative,
  nF2_Integer?NonNegative] :=
  Total[Values[XYZZThreeVertexPiecesFast[p, mu, r, nOuter, nF2]]];

XYZZThreeVertexTotalFast[p_, {mu1_, mu2_}, r_, nMax_Integer?NonNegative] :=
  2 Re@Total@Flatten@Table[
    XYZZThreeVertexBaseFast[p, {a1 mu1, a2 mu2}, r, nMax],
    {a1, {-1, 1}}, {a2, {-1, 1}}
  ];

XYZZThreeVertexTotalFast[
  p_, {mu1_, mu2_}, r_, nOuter_Integer?NonNegative,
  nF2_Integer?NonNegative
] :=
  2 Re@Total@Flatten@Table[
    XYZZThreeVertexBaseFast[p, {a1 mu1, a2 mu2}, r, nOuter, nF2],
    {a1, {-1, 1}}, {a2, {-1, 1}}
  ];

(* ::Section::Closed:: *)
(* ====================================================================== *)
(* Part 1E - deterministic patchwise Taylor-series continuation *)
(* ====================================================================== *)

(* This backend changes only the one-variable numerical transport.
   The full 25D raw block-triangular connection, Frobenius boundary germ,
   sector order, source blocks, and SK/BB conventions are unchanged. *)

ClearAll[
  XYZZPatchwiseScalarTaylorCoefficients,
  XYZZPatchwiseConnectionTaylorCoefficients,
  XYZZPatchwiseConnectionSingularities,
  XYZZPatchwiseAutomaticWaypoints,
  XYZZPatchwiseSeriesPropagate,
  XYZZSolveProjectBranchE2PatchwiseFromInfinity
];

XYZZPatchwiseScalarTaylorCoefficients[
  expression_,
  variable_Symbol,
  center_?NumericQ,
  maximumOrder_Integer?NonNegative,
  workingPrecision_Integer?Positive
] := Module[
  {z, rationalExpression, numerator, denominator, numeratorCoefficients,
    denominatorCoefficients, denominator0, coefficients, n, j},
  rationalExpression = Cancel[Together[expression]];
  If[
    TrueQ[rationalExpression === 0],
    Return[ConstantArray[0, maximumOrder + 1]]
  ];
  z = Unique["z"];
  numerator = Numerator[rationalExpression] /. variable -> center + z;
  denominator = Denominator[rationalExpression] /. variable -> center + z;
  If[
    !PolynomialQ[numerator, z] || !PolynomialQ[denominator, z],
    Return[Failure[
      "NonRationalConnectionEntry",
      <|"Expression" -> expression, "Variable" -> variable|>
    ]]
  ];
  numeratorCoefficients = N[
    Take[
      PadRight[CoefficientList[Expand[numerator], z], maximumOrder + 1],
      maximumOrder + 1
    ],
    workingPrecision
  ];
  denominatorCoefficients = N[
    Take[
      PadRight[CoefficientList[Expand[denominator], z], maximumOrder + 1],
      maximumOrder + 1
    ],
    workingPrecision
  ];
  denominator0 = denominatorCoefficients[[1]];
  If[
    !NumericQ[denominator0] || TrueQ[PossibleZeroQ[denominator0]],
    Return[Failure[
      "ExpansionCenterIsSingular",
      <|"Center" -> center, "Expression" -> expression|>
    ]]
  ];
  coefficients = ConstantArray[0, maximumOrder + 1];
  Do[
    coefficients[[n + 1]] = N[
      (
        numeratorCoefficients[[n + 1]] -
          Sum[
            denominatorCoefficients[[j + 1]] *
              coefficients[[n - j + 1]],
            {j, 1, n}
          ]
      )/denominator0,
      workingPrecision
    ],
    {n, 0, maximumOrder}
  ];
  coefficients
];

XYZZPatchwiseConnectionTaylorCoefficients[
  connectionExpression_?MatrixQ,
  variable_Symbol,
  center_?NumericQ,
  maximumOrder_Integer?NonNegative,
  workingPrecision_Integer?Positive
] := Module[{entryCoefficients, failure},
  entryCoefficients = Map[
    XYZZPatchwiseScalarTaylorCoefficients[
      #1, variable, center, maximumOrder, workingPrecision
    ] &,
    connectionExpression,
    {2}
  ];
  failure = Cases[entryCoefficients, _Failure, Infinity];
  If[failure =!= {}, Return[First[failure]]];
  Table[
    Map[#1[[order + 1]] &, entryCoefficients, {2}],
    {order, 0, maximumOrder}
  ]
];

XYZZPatchwiseConnectionSingularities[
  connectionExpression_?MatrixQ,
  variable_Symbol,
  workingPrecision_Integer?Positive
] := Module[
  {nonzeroEntries, denominators, rootLists, roots, mergeTolerance},
  nonzeroEntries = Select[
    Flatten[connectionExpression],
    !TrueQ[PossibleZeroQ[#1]] &
  ];
  denominators = DeleteDuplicates[
    Denominator[Cancel[Together[#1]]] & /@ nonzeroEntries
  ];
  denominators = Select[denominators, !FreeQ[#1, variable] &];
  rootLists = Table[
    Quiet@Check[
      variable /. NSolve[
        denominator == 0,
        variable,
        WorkingPrecision -> workingPrecision
      ],
      {}
    ],
    {denominator, denominators}
  ];
  roots = Select[Flatten[rootLists], NumericQ];
  mergeTolerance = N[10^(-Max[10, Floor[workingPrecision/2]]), workingPrecision];
  DeleteDuplicates[
    N[roots, workingPrecision],
    Abs[#1 - #2] <= mergeTolerance &
  ]
];

XYZZPatchwiseAutomaticWaypoints[
  start_?NumericQ,
  end_?NumericQ,
  safetyFactor_?NumericQ
] := Module[{points, direction, current, next, multiplier, maximumSegments},
  If[
    !TrueQ[0 < safetyFactor < 1] || !TrueQ[start > 0] || !TrueQ[end > 0],
    Return[$Failed]
  ];
  If[TrueQ[start == end], Return[{start}]];
  direction = Sign[end - start];
  If[direction < 0, Return[$Failed]];
  multiplier = 1 + safetyFactor/2;
  points = {start};
  current = start;
  maximumSegments = 10000;
  While[current < end && Length[points] <= maximumSegments,
    next = Min[end, multiplier current];
    If[TrueQ[next == current], Return[$Failed]];
    points = Append[points, next];
    current = next;
  ];
  If[current =!= end, $Failed, points]
];

Options[XYZZPatchwiseSeriesPropagate] = {
  "WorkingPrecision" -> 50,
  "SeriesOrder" -> 60,
  "CompareOrderDrop" -> 2,
  "RelativeTolerance" -> 10^-18,
  "SafetyFactor" -> 1/2,
  "Singularities" -> Automatic
};

XYZZPatchwiseSeriesPropagate[
  connectionExpression_?MatrixQ,
  variable_Symbol,
  waypoints : {__?NumericQ},
  initialValue_List,
  OptionsPattern[]
] := Module[
  {workingPrecision, seriesOrder, compareOrderDrop, relativeTolerance,
    safetyFactor, singularities, numericWaypoints, currentValue, records,
    center, endpoint, step, distances, radius, nearestSingularity,
    stepRatio, connectionCoefficients, coefficientSeconds,
    coefficientVectors, recurrenceSeconds, highValue, lowValue,
    truncationEstimate, endpointDerivative, endpointConnection,
    endpointODEResidual, n, k, segmentIndex, acceptedQ, failureResult},
  workingPrecision = OptionValue["WorkingPrecision"];
  seriesOrder = OptionValue["SeriesOrder"];
  compareOrderDrop = OptionValue["CompareOrderDrop"];
  relativeTolerance = N[
    OptionValue["RelativeTolerance"], workingPrecision
  ];
  safetyFactor = N[OptionValue["SafetyFactor"], workingPrecision];
  If[
    !IntegerQ[seriesOrder] || seriesOrder < 2 ||
      !IntegerQ[compareOrderDrop] ||
      compareOrderDrop < 1 || compareOrderDrop >= seriesOrder ||
      !TrueQ[0 < safetyFactor < 1],
    Return[$Failed]
  ];
  If[
    Length[initialValue] =!= Length[connectionExpression] ||
      Dimensions[connectionExpression] =!=
        {Length[initialValue], Length[initialValue]},
    Return[$Failed]
  ];
  numericWaypoints = N[waypoints, workingPrecision];
  currentValue = N[initialValue, workingPrecision];
  singularities = Replace[
    OptionValue["Singularities"],
    Automatic :> XYZZPatchwiseConnectionSingularities[
      connectionExpression, variable, workingPrecision
    ]
  ];
  If[singularities === $Failed || !ListQ[singularities], Return[$Failed]];
  singularities = N[singularities, workingPrecision];
  records = {};
  failureResult = None;

  Do[
    center = numericWaypoints[[segmentIndex]];
    endpoint = numericWaypoints[[segmentIndex + 1]];
    step = endpoint - center;
    If[singularities === {},
      radius = Infinity;
      nearestSingularity = Missing["NoFiniteSingularity"];
      stepRatio = 0,
      distances = Abs[center - singularities];
      radius = Min[distances];
      nearestSingularity = singularities[[First@FirstPosition[distances, radius]]];
      If[
        !NumericQ[radius] || TrueQ[radius <= 0],
        failureResult = $Failed;
        Break[]
      ];
      stepRatio = N[Abs[step]/radius, workingPrecision]
    ];
    If[!TrueQ[stepRatio < safetyFactor],
      failureResult = Failure[
        "UnsafeWaypointStep",
        <|
          "SegmentIndex" -> segmentIndex,
          "Center" -> center,
          "Endpoint" -> endpoint,
          "NearestSingularity" -> nearestSingularity,
          "ConvergenceRadius" -> radius,
          "StepRatio" -> stepRatio,
          "SafetyFactor" -> safetyFactor
        |>
      ];
      Break[]
    ];
    coefficientSeconds = First@AbsoluteTiming[
      connectionCoefficients =
        XYZZPatchwiseConnectionTaylorCoefficients[
          connectionExpression,
          variable,
          center,
          seriesOrder - 1,
          workingPrecision
        ];
    ];
    If[
      Head[connectionCoefficients] === Failure,
      failureResult = connectionCoefficients;
      Break[]
    ];
    coefficientVectors = ConstantArray[0, seriesOrder + 1];
    coefficientVectors[[1]] = currentValue;
    recurrenceSeconds = First@AbsoluteTiming[
      Do[
        coefficientVectors[[n + 2]] = N[
          Sum[
            connectionCoefficients[[k + 1]] .
              coefficientVectors[[n - k + 1]],
            {k, 0, n}
          ]/(n + 1),
          workingPrecision
        ],
        {n, 0, seriesOrder - 1}
      ];
      highValue = N[
        Sum[
          coefficientVectors[[n + 1]] step^n,
          {n, 0, seriesOrder}
        ],
        workingPrecision
      ];
      lowValue = N[
        Sum[
          coefficientVectors[[n + 1]] step^n,
          {n, 0, seriesOrder - compareOrderDrop}
        ],
        workingPrecision
      ];
    ];
    truncationEstimate = N[
      Norm[highValue - lowValue]/Max[Norm[highValue], 10^-100],
      workingPrecision
    ];
    endpointDerivative = N[
      Sum[
        n coefficientVectors[[n + 1]] step^(n - 1),
        {n, 1, seriesOrder}
      ],
      workingPrecision
    ];
    endpointConnection = N[
      connectionExpression /. variable -> endpoint,
      workingPrecision
    ];
    endpointODEResidual = N[
      Norm[endpointDerivative - endpointConnection . highValue]/
        Max[
          Norm[endpointDerivative],
          Norm[endpointConnection . highValue],
          10^-100
        ],
      workingPrecision
    ];
    acceptedQ = TrueQ[truncationEstimate <= relativeTolerance];
    records = Append[
      records,
      <|
        "SegmentIndex" -> segmentIndex,
        "Center" -> center,
        "Endpoint" -> endpoint,
        "Step" -> step,
        "NearestSingularity" -> nearestSingularity,
        "ConvergenceRadius" -> radius,
        "StepRatio" -> stepRatio,
        "SafetyFactor" -> safetyFactor,
        "SeriesOrder" -> seriesOrder,
        "CompareOrder" -> seriesOrder - compareOrderDrop,
        "EstimatedRelativeTruncation" -> truncationEstimate,
        "EndpointODERelativeResidual" -> endpointODEResidual,
        "CoefficientSeconds" -> coefficientSeconds,
        "RecurrenceAndEvaluationSeconds" -> recurrenceSeconds,
        "AcceptedQ" -> acceptedQ
      |>
    ];
    If[
      !acceptedQ,
      failureResult = Failure[
        "PatchTruncationNotMet",
        <|
          "SegmentIndex" -> segmentIndex,
          "EstimatedRelativeTruncation" -> truncationEstimate,
          "RelativeTolerance" -> relativeTolerance,
          "SegmentRecord" -> Last[records]
        |>
      ];
      Break[]
    ];
    currentValue = highValue,
    {segmentIndex, 1, Length[numericWaypoints] - 1}
  ];
  If[failureResult =!= None, Return[failureResult]];

  <|
    "Value" -> currentValue,
    "Waypoints" -> numericWaypoints,
    "Singularities" -> singularities,
    "SeriesOrder" -> seriesOrder,
    "CompareOrderDrop" -> compareOrderDrop,
    "RelativeTolerance" -> relativeTolerance,
    "SafetyFactor" -> safetyFactor,
    "Segments" -> records,
    "AcceptedQ" -> And @@ Lookup[records, "AcceptedQ", False]
  |>
];

Options[XYZZSolveProjectBranchE2PatchwiseFromInfinity] = {
  "WorkingPrecision" -> 50,
  "SeriesOrder" -> 8,
  "BoundaryAccuracyGoal" -> 18,
  "BoundaryGuardDigits" -> 20,
  "BoundaryMaxRecursion" -> 14,
  "BoundaryCutoff" -> 35,
  "BoundaryLowerCutoff" -> 10^-8,
  "OuterVertexEvaluation" -> "Series",
  "OuterVertexSeriesOrder" -> 5,
  "SeriesStartT" -> Automatic,
  "SeriesSafetyFactor" -> 1/20,
  "WaypointsT" -> Automatic,
  "LocalSeriesOrder" -> 60,
  "LocalCompareOrderDrop" -> 2,
  "LocalRelativeTolerance" -> 10^-18,
  "LocalSafetyFactor" -> 1/2,
  "ReturnFrobeniusData" -> False
};

XYZZSolveProjectBranchE2PatchwiseFromInfinity[
  signs : {(_Integer)..},
  rules_List,
  e2End_?NumericQ,
  OptionsPattern[]
] := Module[
  {workingPrecision, boundaryWorkingPrecision, seriesOrder,
    boundaryAccuracyGoal, rulesNoE2, tEnd, scaleValues, scale,
    requestedWaypoints, tStart, boundaryTolerance, data, dataSeconds,
    boundaryHigh, boundaryLow, boundaryTruncation, boundaryResidual,
    waypoints, propagated, transportSeconds, currentRules, result},
  If[!NameQ["XYZZProjectE2InfinityFrobeniusData"], Return[$Failed]];
  If[!XYZZLoadProjectCore[], Return[$Failed]];
  workingPrecision = OptionValue["WorkingPrecision"];
  boundaryWorkingPrecision =
    workingPrecision + OptionValue["BoundaryGuardDigits"];
  seriesOrder = OptionValue["SeriesOrder"];
  boundaryAccuracyGoal = OptionValue["BoundaryAccuracyGoal"];
  rulesNoE2 = DeleteCases[rules, E2 -> _];
  tEnd = N[1/e2End, boundaryWorkingPrecision];
  If[!NumericQ[tEnd] || !TrueQ[tEnd > 0], Return[$Failed]];
  requestedWaypoints = OptionValue["WaypointsT"];
  scaleValues = N[Abs[{E1, E3, s1, s2} /. rulesNoE2], boundaryWorkingPrecision];
  If[!VectorQ[scaleValues, NumericQ], Return[$Failed]];
  scale = Max[1, Sequence @@ scaleValues];
  tStart = Which[
    ListQ[requestedWaypoints] && Length[requestedWaypoints] >= 1,
      N[First[requestedWaypoints], boundaryWorkingPrecision],
    OptionValue["SeriesStartT"] === Automatic,
      Min[
        tEnd,
        N[OptionValue["SeriesSafetyFactor"]/scale, boundaryWorkingPrecision]
      ],
    True,
      Min[tEnd, N[OptionValue["SeriesStartT"], boundaryWorkingPrecision]]
  ];
  If[!NumericQ[tStart] || !TrueQ[0 < tStart <= tEnd], Return[$Failed]];
  dataSeconds = First@AbsoluteTiming[
    data = XYZZProjectE2InfinityFrobeniusData[
      signs,
      rulesNoE2,
      "WorkingPrecision" -> boundaryWorkingPrecision,
      "SeriesOrder" -> seriesOrder,
      "AccuracyGoal" -> Min[
        boundaryWorkingPrecision - 10,
        boundaryAccuracyGoal + 10
      ],
      "PrecisionGoal" -> Min[
        boundaryWorkingPrecision - 10,
        boundaryAccuracyGoal + 10
      ],
      "MaxRecursion" -> OptionValue["BoundaryMaxRecursion"],
      "Cutoff" -> OptionValue["BoundaryCutoff"],
      "LowerCutoff" -> OptionValue["BoundaryLowerCutoff"],
      "OuterVertexEvaluation" -> OptionValue["OuterVertexEvaluation"],
      "OuterVertexSeriesOrder" -> OptionValue["OuterVertexSeriesOrder"]
    ];
  ];
  If[!AssociationQ[data], Return[$Failed]];
  boundaryHigh = XYZZProjectE2InfinityEvaluate[data, tStart];
  boundaryLow = XYZZProjectE2InfinityEvaluate[data, tStart, seriesOrder - 1];
  boundaryTruncation = N[
    Norm[boundaryHigh - boundaryLow]/Max[Norm[boundaryHigh], 10^-100],
    boundaryWorkingPrecision
  ];
  boundaryTolerance = N[10^-boundaryAccuracyGoal, boundaryWorkingPrecision];
  If[
    !TrueQ[boundaryTruncation <= boundaryTolerance],
    Return[Failure[
      "InfinityBoundaryTruncationNotMet",
      <|
        "SeriesPatchT" -> tStart,
        "EstimatedRelativeTruncation" -> boundaryTruncation,
        "BoundaryTolerance" -> boundaryTolerance
      |>
    ]]
  ];
  boundaryResidual = XYZZProjectE2InfinitySeriesResidual[data, tStart];
  waypoints = If[
    requestedWaypoints === Automatic,
    XYZZPatchwiseAutomaticWaypoints[
      N[tStart, workingPrecision],
      N[tEnd, workingPrecision],
      OptionValue["LocalSafetyFactor"]
    ],
    N[requestedWaypoints, workingPrecision]
  ];
  If[
    !ListQ[waypoints] || Length[waypoints] < 1 ||
      !TrueQ[First[waypoints] == N[tStart, workingPrecision]] ||
      !TrueQ[Last[waypoints] == N[tEnd, workingPrecision]],
    Return[$Failed]
  ];
  transportSeconds = First@AbsoluteTiming[
    propagated = XYZZPatchwiseSeriesPropagate[
      data["ConnectionExpression"],
      data["SeriesVariable"],
      waypoints,
      N[boundaryHigh, workingPrecision],
      "WorkingPrecision" -> workingPrecision,
      "SeriesOrder" -> OptionValue["LocalSeriesOrder"],
      "CompareOrderDrop" -> OptionValue["LocalCompareOrderDrop"],
      "RelativeTolerance" -> OptionValue["LocalRelativeTolerance"],
      "SafetyFactor" -> OptionValue["LocalSafetyFactor"]
    ];
  ];
  If[!AssociationQ[propagated], Return[propagated]];
  currentRules = Join[rulesNoE2, {E2 -> e2End}];
  result = <|
    "Signs" -> signs,
    "RawBoundary25" -> propagated["Value"],
    "Rules" -> currentRules,
    "Segments" -> {
      <|
        "Variable" -> E2,
        "Range" -> {e2End, Infinity},
        "EvolutionVariable" -> "PatchwiseSeriesFromTrueInfinity",
        "TRange" -> {0, tEnd},
        "SeriesPatchT" -> tStart,
        "SeriesPatchE2" -> 1/tStart,
        "InfinitySeriesOrder" -> seriesOrder,
        "EstimatedInfinityBoundaryTruncation" -> boundaryTruncation,
        "InfinitySeriesODERelativeResidual" -> boundaryResidual,
        "WaypointsT" -> waypoints,
        "WaypointsE2" -> 1/waypoints,
        "LocalSeriesOrder" -> OptionValue["LocalSeriesOrder"],
        "LocalSeriesSegments" -> propagated["Segments"],
        "BoundarySeconds" -> dataSeconds,
        "TransportSeconds" -> transportSeconds,
        "TransportMethod" -> "PatchwiseSeries",
        "BoundaryAtInfinityQ" -> True,
        "AutomaticODESolverUsedQ" -> False,
        "SystemBasis" -> "Raw"
      |>
    },
    "WorkingPrecision" -> workingPrecision,
    "BoundaryAtInfinityQ" -> True
  |>;
  If[TrueQ[OptionValue["ReturnFrobeniusData"]],
    Append[result, "FrobeniusData" -> data],
    result
  ]
];

(* ::Section::Closed:: *)
(* ====================================================================== *)
(* Part 4A - comparison harness *)
(* ====================================================================== *)

ClearAll[
  StandaloneRelativeResidual, StandaloneVectorResidual,
  StandaloneQualitySettings, StandaloneDefaultParameters,
  StandaloneDefaultTargetPoint, StandaloneDefaultStartPoints,
  StandaloneResolvePathChoice, StandaloneVariableSymbol,
  StandalonePointEnergies, StandalonePointMomenta, StandaloneRulesFromPoint,
  StandaloneXYZZRatiosAtPoint, StandaloneEq103AtPoint,
  StandaloneEq103ProjectConventionCorrectionAtPoint,
  StandaloneProjectValueInXYZZEq103Convention,
  StandaloneCommonFactorAtPoint, StandaloneIndependentTop0000,
  StandalonePaperValueFromRaw25, StandaloneComputeBoundarySet,
  StandaloneBranchResidualRows, StandaloneRunOnePath,
  StandalonePairwisePathResiduals, StandaloneStripRawPathResult,
  StandaloneRunPathSet, StandaloneMakeConfig,
  StandalonePrintCompactReport
];

StandaloneRelativeResidual[x_, y_] :=
  N[Abs[x - y]/Max[Abs[y], 10^-100], 60];

StandaloneVectorResidual[x_, y_] :=
  N[Norm[Flatten[x - y]]/Max[Norm[Flatten[y]], 10^-100], 60];

StandaloneQualitySettings["Smoke"] := <|
  "WorkingPrecision" -> 50,
  "AccuracyGoal" -> 25,
  "PrecisionGoal" -> 25,
  "MaxStepFraction" -> 1/300,
  "E2InfinitySeriesOrder" -> 8,
  "E2InfinityBoundaryAccuracyGoal" -> 18,
  "E2InfinityOuterVertexEvaluation" -> "Series",
  "BoundaryOptions" -> <|
    "WorkingPrecision" -> 50,
    "BoundaryGuardDigits" -> 20,
    "AccuracyGoal" -> 12,
    "PrecisionGoal" -> 12,
    "MaxRecursion" -> 14,
    "Cutoff" -> 35,
    "LowerCutoff" -> 10^-8,
    "LargeEnergySeriesOrder" -> 4,
    "OuterVertexSeriesOrder" -> 5,
    "ThetaOrderingSeriesOrder" -> 6
  |>,
  "Eq103Order" -> {3, 4}
|>;

StandaloneQualitySettings["Medium"] := <|
  "WorkingPrecision" -> 80,
  "AccuracyGoal" -> 45,
  "PrecisionGoal" -> 45,
  "MaxStepFraction" -> 1/800,
  "E2InfinitySeriesOrder" -> 14,
  "E2InfinityBoundaryAccuracyGoal" -> 35,
  "E2InfinityOuterVertexEvaluation" -> "Series",
  "BoundaryOptions" -> <|
    "WorkingPrecision" -> 80,
    "BoundaryGuardDigits" -> 20,
    "AccuracyGoal" -> 35,
    "PrecisionGoal" -> 35,
    "MaxRecursion" -> 14,
    "Cutoff" -> 35,
    "LowerCutoff" -> 10^-8,
    "LargeEnergySeriesOrder" -> 12,
    "OuterVertexSeriesOrder" -> 16,
    "ThetaOrderingSeriesOrder" -> 20
  |>,
  "Eq103Order" -> {7, 10}
|>;

StandaloneQualitySettings["High"] := <|
  "WorkingPrecision" -> 90,
  "AccuracyGoal" -> 50,
  "PrecisionGoal" -> 50,
  "MaxStepFraction" -> 1/1000,
  "E2InfinitySeriesOrder" -> 18,
  "E2InfinityBoundaryAccuracyGoal" -> 45,
  "E2InfinityOuterVertexEvaluation" -> "Series",
  "BoundaryOptions" -> <|
    "WorkingPrecision" -> 90,
    "BoundaryGuardDigits" -> 20,
    "AccuracyGoal" -> 45,
    "PrecisionGoal" -> 45,
    "MaxRecursion" -> 14,
    "Cutoff" -> 35,
    "LowerCutoff" -> 10^-8,
    "LargeEnergySeriesOrder" -> 18,
    "OuterVertexSeriesOrder" -> 24,
    "ThetaOrderingSeriesOrder" -> 32
  |>,
  "Eq103Order" -> {8, 10}
|>;

StandaloneQualitySettings[quality_String] := (
  Print["Unknown quality setting: ", quality, ". Use Smoke, Medium, or High."];
  $Failed
);

StandaloneDefaultParameters[] := Module[{p, mu, nu},
  p = {0, 0, 0};
  mu = {1/2, 2/3};
  nu = I mu;
  <|"p" -> p, "mu" -> mu, "nu" -> nu,
    "nu0" -> XYZZProjectNu0FromPaperP[p, nu]|>
];

StandaloneDefaultTargetPoint[] := <|
  "E1" -> 90,
  "E2" -> 9000,
  "E3" -> 110,
  "s1" -> 3/10,
  "s2" -> 1/3
|>;

StandaloneDefaultStartPoints[target_Association:StandaloneDefaultTargetPoint[]] := <|
  "E1" -> Join[target, <|"E1" -> 180|>],
  "E2" -> Join[target, <|"E2" -> 18000|>],
  "E3" -> Join[target, <|"E3" -> 220|>],
  "s1" -> Join[target, <|"s1" -> 1/5|>],
  "s2" -> Join[target, <|"s2" -> 1/5|>]
|>;

StandaloneResolvePathChoice["AllFive"] := {"E1", "E2", "E3", "s1", "s2"};
StandaloneResolvePathChoice[path_String] /; MemberQ[{"E1", "E2", "E3", "s1", "s2"}, path] := {path};
StandaloneResolvePathChoice[pathList_List] /; And @@ (MemberQ[{"E1", "E2", "E3", "s1", "s2"}, #] & /@ pathList) := pathList;
StandaloneResolvePathChoice[bad_] := (
  Print["Bad path choice: ", bad, ". Use E1, E2, E3, s1, s2, AllFive, or a list of these strings."];
  $Failed
);

StandaloneVariableSymbol["E1"] := E1;
StandaloneVariableSymbol["E2"] := E2;
StandaloneVariableSymbol["E3"] := E3;
StandaloneVariableSymbol["s1"] := s1;
StandaloneVariableSymbol["s2"] := s2;

StandalonePointEnergies[point_Association] := Lookup[point, {"E1", "E2", "E3"}];
StandalonePointMomenta[point_Association] := Lookup[point, {"s1", "s2"}];

StandaloneRulesFromPoint[params_Association, point_Association] := {
  nu0L -> params["nu0"][[1]],
  nu0M -> params["nu0"][[2]],
  nu0R -> params["nu0"][[3]],
  nu1 -> params["nu"][[1]],
  nu2 -> params["nu"][[2]],
  E1 -> point["E1"],
  E2 -> point["E2"],
  E3 -> point["E3"],
  s1 -> point["s1"],
  s2 -> point["s2"]
};

StandaloneXYZZRatiosAtPoint[point_Association, wp_Integer:50] := N[
  {
    point["s1"]/point["E1"],
    point["s1"]/point["E2"],
    point["s2"]/point["E2"],
    point["s2"]/point["E3"]
  },
  wp
];

StandaloneEq103AtPoint[
  params_Association,
  point_Association,
  order : {nOuter_Integer?NonNegative, nF2_Integer?NonNegative},
  wp_Integer
] := N[
  XYZZThreeVertexTotalFast[
    params["p"],
    params["mu"],
    StandaloneXYZZRatiosAtPoint[point, wp],
    nOuter,
    nF2
  ],
  wp
];

StandaloneEq103ProjectConventionCorrectionAtPoint[
  params_Association,
  point_Association,
  order : {nOuter_Integer?NonNegative, nF2_Integer?NonNegative},
  wp_Integer
] := N[
  XYZZThreeVertexTotalProjectConventionCorrectionFast[
    params["p"],
    params["mu"],
    StandaloneXYZZRatiosAtPoint[point, wp],
    nOuter,
    nF2
  ],
  wp
];

StandaloneProjectValueInXYZZEq103Convention[
  projectValue_,
  params_Association,
  point_Association,
  order : {nOuter_Integer?NonNegative, nF2_Integer?NonNegative},
  wp_Integer
] := N[
  projectValue - StandaloneEq103ProjectConventionCorrectionAtPoint[
    params, point, order, wp
  ],
  wp
];

StandaloneCommonFactorAtPoint[params_Association, point_Association, wp_Integer] :=
  N[
    XYZZProjectCommonToPaperFactor[
      params["p"],
      params["nu"],
      StandalonePointEnergies[point],
      StandalonePointMomenta[point]
    ],
    wp
  ];

StandaloneIndependentTop0000[raw25_Association] :=
  Association@KeyValueMap[#1 -> #2[[1]] &, raw25];

StandalonePaperValueFromRaw25[
  params_Association,
  point_Association,
  raw25_Association,
  wp_Integer
] := Module[{commonFactor},
  commonFactor = StandaloneCommonFactorAtPoint[params, point, wp];
  N[
    XYZZProjectIndependentRawToPaperSeed[
      StandaloneIndependentTop0000[raw25],
      commonFactor
    ],
    wp
  ]
];

StandaloneComputeBoundarySet[
  params_Association,
  point_Association,
  boundaryOptions_Association,
  signsList_List,
  label_String,
  verbose_:True
] := Module[
  {nu0, nu, energies, momenta, outputWP, guardDigits, boundaryWP,
    boundaryOptionsHigh, opts, rawHigh},
  nu0 = params["nu0"];
  nu = params["nu"];
  energies = StandalonePointEnergies[point];
  momenta = StandalonePointMomenta[point];
  outputWP = Lookup[
    boundaryOptions,
    "OutputWorkingPrecision",
    Lookup[boundaryOptions, "WorkingPrecision", MachinePrecision]
  ];
  guardDigits = Lookup[boundaryOptions, "BoundaryGuardDigits", 20];
  boundaryWP = Lookup[
    boundaryOptions,
    "BoundaryWorkingPrecision",
    outputWP + guardDigits
  ];
  boundaryOptionsHigh = Join[
    KeyDrop[
      boundaryOptions,
      {"OutputWorkingPrecision", "BoundaryGuardDigits",
       "BoundaryWorkingPrecision"}
    ],
    <|"WorkingPrecision" -> boundaryWP|>
  ];
  opts = Sequence @@ Normal[boundaryOptionsHigh];
  rawHigh = Association@Table[
    If[TrueQ[verbose], Print["Boundary ", label, ", signs = ", signs]];
    signs -> ProjectE2MaximalAsymptoticBoundary25[
      nu0, nu, energies, momenta, signs, opts
    ],
    {signs, signsList}
  ];
  If[MemberQ[Values[rawHigh], $Failed], Return[$Failed]];
  N[rawHigh, outputWP]
];

StandaloneBranchResidualRows[
  evolvedRaw25_Association,
  targetRaw25_Association,
  signsList_List,
  wp_Integer
] := Association@Table[
  signs -> <|
    "EvolvedTop0000" -> N[evolvedRaw25[signs][[1]], Min[wp, 60]],
    "DirectTop0000" -> N[targetRaw25[signs][[1]], Min[wp, 60]],
    "Top0000RelativeResidualVsDirectBoundary" ->
      StandaloneRelativeResidual[evolvedRaw25[signs][[1]], targetRaw25[signs][[1]]],
    "VectorRelativeResidualVsDirectBoundary" ->
      StandaloneVectorResidual[evolvedRaw25[signs], targetRaw25[signs]]
  |>,
  {signs, signsList}
];

StandaloneRunOnePath[
  pathName_String,
  config_Association,
  startRaw25_,
  targetRaw25_Association,
  analyticEq103_,
  bbConventionCorrection_
] := Module[
  {params, targetPoint, startPoint, wp, signsList, var, rulesStart, evolved,
   evolvedRaw25, projectValue, directValue, projectEq103Value,
   directEq103Value, branchRows, boundaryOptions, e2Mode, e2InverseQ,
   e2TrueInfinityQ, e2TransportMethod, patchwiseWaypointsT,
   startPointRecord},
  params = config["Parameters"];
  targetPoint = config["TargetPoint"];
  wp = config["WorkingPrecision"];
  signsList = config["SignsList"];
  boundaryOptions = config["BoundaryOptions"];
  var = StandaloneVariableSymbol[pathName];
  e2Mode = Lookup[config, "E2EvolutionVariable", "TrueInfinity"];
  e2TransportMethod = Lookup[config, "E2TransportMethod", "NDSolve"];
  patchwiseWaypointsT = Replace[
    Lookup[config, "E2PatchwiseWaypointsE2", Automatic],
    points_List :> 1/points
  ];
  e2TrueInfinityQ = pathName === "E2" && e2Mode === "TrueInfinity";
  startPoint = If[
    e2TrueInfinityQ,
    targetPoint,
    config["StartPoints"][pathName]
  ];
  rulesStart = StandaloneRulesFromPoint[params, startPoint];
  e2InverseQ = pathName === "E2" && e2Mode === "InverseT";
  startPointRecord = If[
    e2TrueInfinityQ,
    Join[targetPoint, <|"E2" -> Infinity|>],
    startPoint
  ];

  If[TrueQ[config["Verbose"]],
    Print["Evolving path ", pathName, ": ",
      If[e2TrueInfinityQ, Infinity, startPoint[pathName]],
      " -> ", targetPoint[pathName],
      Which[
        e2TrueInfinityQ,
          " using the t=0 Frobenius boundary germ and " <>
            e2TransportMethod <> " transport",
        e2InverseQ, " using finite-start E2=1/t",
        True, ""
      ]]
  ];

  evolved = If[
    e2TrueInfinityQ,
    Association@Table[
      signs -> Switch[
        e2TransportMethod,
        "NDSolve",
          XYZZSolveProjectBranchE2FromInfinity[
            signs,
            rulesStart,
            targetPoint["E2"],
            "WorkingPrecision" -> config["WorkingPrecision"],
            "AccuracyGoal" -> config["AccuracyGoal"],
            "PrecisionGoal" -> config["PrecisionGoal"],
            "MaxStepFraction" -> config["MaxStepFraction"],
            "SeriesOrder" -> config["E2InfinitySeriesOrder"],
            "BoundaryAccuracyGoal" ->
              config["E2InfinityBoundaryAccuracyGoal"],
            "BoundaryGuardDigits" ->
              Lookup[boundaryOptions, "BoundaryGuardDigits", 20],
            "BoundaryMaxRecursion" ->
              Lookup[boundaryOptions, "MaxRecursion", 14],
            "BoundaryCutoff" -> Lookup[boundaryOptions, "Cutoff", 35],
            "BoundaryLowerCutoff" ->
              Lookup[boundaryOptions, "LowerCutoff", 10^-8],
            "OuterVertexEvaluation" ->
              config["E2InfinityOuterVertexEvaluation"],
            "OuterVertexSeriesOrder" ->
              Lookup[boundaryOptions, "OuterVertexSeriesOrder", 16]
          ],
        "PatchwiseSeries",
          XYZZSolveProjectBranchE2PatchwiseFromInfinity[
            signs,
            rulesStart,
            targetPoint["E2"],
            "WorkingPrecision" -> config["WorkingPrecision"],
            "SeriesOrder" -> config["E2InfinitySeriesOrder"],
            "BoundaryAccuracyGoal" ->
              config["E2InfinityBoundaryAccuracyGoal"],
            "BoundaryGuardDigits" ->
              Lookup[boundaryOptions, "BoundaryGuardDigits", 20],
            "BoundaryMaxRecursion" ->
              Lookup[boundaryOptions, "MaxRecursion", 14],
            "BoundaryCutoff" -> Lookup[boundaryOptions, "Cutoff", 35],
            "BoundaryLowerCutoff" ->
              Lookup[boundaryOptions, "LowerCutoff", 10^-8],
            "OuterVertexEvaluation" ->
              config["E2InfinityOuterVertexEvaluation"],
            "OuterVertexSeriesOrder" ->
              Lookup[boundaryOptions, "OuterVertexSeriesOrder", 16],
            "WaypointsT" -> patchwiseWaypointsT,
            "LocalSeriesOrder" -> config["E2PatchwiseLocalSeriesOrder"],
            "LocalCompareOrderDrop" ->
              config["E2PatchwiseCompareOrderDrop"],
            "LocalRelativeTolerance" ->
              config["E2PatchwiseRelativeTolerance"],
            "LocalSafetyFactor" -> config["E2PatchwiseSafetyFactor"]
          ]
      ],
      {signs, signsList}
    ],
    Association@KeyValueMap[
      Function[{signs, rawVector},
        signs -> If[
          e2InverseQ,
          XYZZSolveProjectBranchE2InversePath[
            signs,
            rulesStart,
            {targetPoint[pathName], startPoint[pathName]},
            rawVector,
            "WorkingPrecision" -> config["WorkingPrecision"],
            "AccuracyGoal" -> config["AccuracyGoal"],
            "PrecisionGoal" -> config["PrecisionGoal"],
            "MaxStepFraction" -> config["MaxStepFraction"]
          ],
          XYZZSolveProjectBranchPath[
            signs,
            rulesStart,
            {{var, targetPoint[pathName], startPoint[pathName]}},
            rawVector,
            "WorkingPrecision" -> config["WorkingPrecision"],
            "AccuracyGoal" -> config["AccuracyGoal"],
            "PrecisionGoal" -> config["PrecisionGoal"],
            "MaxStepFraction" -> config["MaxStepFraction"]
          ]
        ]
      ],
      startRaw25
    ]
  ];
  If[!And @@ (AssociationQ /@ Values[evolved]), Return[$Failed]];

  evolvedRaw25 = Association@KeyValueMap[#1 -> #2["RawBoundary25"] &, evolved];
  projectValue = StandalonePaperValueFromRaw25[params, targetPoint, evolvedRaw25, wp];
  directValue = StandalonePaperValueFromRaw25[params, targetPoint, targetRaw25, wp];
  projectEq103Value = N[projectValue - bbConventionCorrection, wp];
  directEq103Value = N[directValue - bbConventionCorrection, wp];
  branchRows = StandaloneBranchResidualRows[evolvedRaw25, targetRaw25, signsList, wp];

  <|
    "PathName" -> pathName,
    "Variable" -> var,
    "TransportMethod" -> If[
      e2TrueInfinityQ, e2TransportMethod, "NDSolve"
    ],
    "AutomaticODESolverUsedQ" ->
      !TrueQ[e2TrueInfinityQ && e2TransportMethod === "PatchwiseSeries"],
    "StartPoint" -> startPointRecord,
    "TargetPoint" -> targetPoint,
    "Segments" -> Association@KeyValueMap[#1 -> #2["Segments"] &, evolved],
    "Project25DInPaperConvention" -> projectValue,
    "Project25DInXYZZEq103Convention" -> projectEq103Value,
    "BBOuterParityConventionCorrection" -> bbConventionCorrection,
    "AnalyticEq103" -> analyticEq103,
    "DirectTargetBoundaryInPaperConvention" -> directValue,
    "DirectTargetBoundaryInXYZZEq103Convention" -> directEq103Value,
    "ProjectVsAnalyticUncorrectedRelativeResidual" ->
      StandaloneRelativeResidual[projectValue, analyticEq103],
    "ProjectVsAnalyticRelativeResidual" ->
      StandaloneRelativeResidual[projectEq103Value, analyticEq103],
    "ProjectVsDirectBoundaryRelativeResidual" ->
      StandaloneRelativeResidual[projectValue, directValue],
    "DirectBoundaryVsAnalyticUncorrectedRelativeResidual" ->
      StandaloneRelativeResidual[directValue, analyticEq103],
    "DirectBoundaryVsAnalyticRelativeResidual" ->
      StandaloneRelativeResidual[directEq103Value, analyticEq103],
    "BranchRows" -> branchRows,
    "StartRaw25" -> startRaw25,
    "EvolvedRaw25" -> evolvedRaw25,
    "DirectTargetRaw25" -> targetRaw25
  |>
];

StandalonePairwisePathResiduals[pathResults_Association, signsList_List] := Module[
  {names, pairs, paperResiduals, branchVectorResiduals, branchTopResiduals},
  names = Keys[pathResults];
  pairs = Subsets[names, {2}];
  If[pairs === {},
    Return[<|
      "PairwisePaperResiduals" -> <||>,
      "MaxPairwiseProjectPaperRelativeResidual" -> Missing["SinglePath"],
      "MaxPairwiseBranchVectorRelativeResidual" -> Missing["SinglePath"],
      "MaxPairwiseBranchTop0000RelativeResidual" -> Missing["SinglePath"]
    |>]
  ];
  paperResiduals = Association@Table[
    pair -> StandaloneRelativeResidual[
      pathResults[pair[[1]]]["Project25DInPaperConvention"],
      pathResults[pair[[2]]]["Project25DInPaperConvention"]
    ],
    {pair, pairs}
  ];
  branchVectorResiduals = Flatten@Table[
    StandaloneVectorResidual[
      pathResults[pair[[1]]]["EvolvedRaw25"][signs],
      pathResults[pair[[2]]]["EvolvedRaw25"][signs]
    ],
    {pair, pairs}, {signs, signsList}
  ];
  branchTopResiduals = Flatten@Table[
    StandaloneRelativeResidual[
      pathResults[pair[[1]]]["EvolvedRaw25"][signs][[1]],
      pathResults[pair[[2]]]["EvolvedRaw25"][signs][[1]]
    ],
    {pair, pairs}, {signs, signsList}
  ];
  <|
    "PairwisePaperResiduals" -> paperResiduals,
    "MaxPairwiseProjectPaperRelativeResidual" -> Max[Values[paperResiduals]],
    "MaxPairwiseBranchVectorRelativeResidual" -> Max[branchVectorResiduals],
    "MaxPairwiseBranchTop0000RelativeResidual" -> Max[branchTopResiduals]
  |>
];

StandaloneStripRawPathResult[pathResult_Association] :=
  KeyDrop[pathResult, {"StartRaw25", "EvolvedRaw25", "DirectTargetRaw25"}];

StandaloneRunPathSet[config_Association] := Module[
  {params, targetPoint, wp, boundaryOptions, signsList, pathNames,
   targetRaw25, analyticEq103, bbConventionCorrectionOrder,
   bbConventionCorrection, pathResults, pairwise, returnRawQ,
   trueInfinityQ},
  If[!XYZZLoadProjectCore[], Return[$Failed]];
  params = config["Parameters"];
  targetPoint = config["TargetPoint"];
  wp = config["WorkingPrecision"];
  boundaryOptions = config["BoundaryOptions"];
  signsList = config["SignsList"];
  pathNames = config["PathNames"];
  returnRawQ = TrueQ[config["ReturnRawVectors"]];

  If[TrueQ[config["Verbose"]], Print["Computing direct target boundary..."]];
  targetRaw25 = StandaloneComputeBoundarySet[
    params, targetPoint, boundaryOptions, signsList, "target", config["Verbose"]
  ];
  If[targetRaw25 === $Failed, Return[$Failed]];

  If[TrueQ[config["Verbose"]], Print["Computing xyzz Eq.(103)..."]];
  analyticEq103 = StandaloneEq103AtPoint[
    params, targetPoint, config["Eq103Order"], wp
  ];
  bbConventionCorrectionOrder = Replace[
    Lookup[config, "BBOuterParityCorrectionOrder", Automatic],
    Automatic :> config["Eq103Order"]
  ];
  If[
    ! MatchQ[
      bbConventionCorrectionOrder,
      {_Integer?NonNegative, _Integer?NonNegative}
    ],
    Print["Bad BBOuterParityCorrectionOrder: ",
      bbConventionCorrectionOrder];
    Return[$Failed]
  ];
  bbConventionCorrection = If[
    TrueQ[Lookup[
      config, "ApplyBBOuterParityConventionCorrection", True
    ]],
    StandaloneEq103ProjectConventionCorrectionAtPoint[
      params, targetPoint, bbConventionCorrectionOrder, wp
    ],
    0
  ];

  pathResults = Association@Table[
    Module[{startPoint, startRaw25, one},
      trueInfinityQ =
        pathName === "E2" &&
          Lookup[config, "E2EvolutionVariable", "TrueInfinity"] ===
            "TrueInfinity";
      startPoint = If[
        trueInfinityQ,
        targetPoint,
        config["StartPoints"][pathName]
      ];
      startRaw25 = If[
        trueInfinityQ,
        Missing["BoundaryAtTrueInfinity"],
        If[
          TrueQ[config["Verbose"]],
          Print["Computing start boundary for path ", pathName, "..."]
        ];
        StandaloneComputeBoundarySet[
          params, startPoint, boundaryOptions, signsList,
          "start-" <> pathName, config["Verbose"]
        ]
      ];
      If[startRaw25 === $Failed, Return[pathName -> $Failed]];
      one = StandaloneRunOnePath[
        pathName, config, startRaw25, targetRaw25, analyticEq103,
        bbConventionCorrection
      ];
      pathName -> one
    ],
    {pathName, pathNames}
  ];
  If[MemberQ[Values[pathResults], $Failed], Return[$Failed]];

  pairwise = StandalonePairwisePathResiduals[pathResults, signsList];
  <|
    "ComparisonObject" ->
      "Self-contained corrected 25D IBP/DE evolution vs xyzz Eq.(103)",
    "ConventionFittedQ" -> False,
    "PathNames" -> pathNames,
    "Parameters" -> params,
    "TargetPoint" -> targetPoint,
    "StartPoints" -> Association@Table[
      pathName -> If[
        pathName === "E2" &&
          Lookup[config, "E2EvolutionVariable", "TrueInfinity"] ===
            "TrueInfinity",
        Join[targetPoint, <|"E2" -> Infinity|>],
        config["StartPoints"][pathName]
      ],
      {pathName, pathNames}
    ],
    "Numerics" -> KeyTake[
      config,
      {"WorkingPrecision", "AccuracyGoal", "PrecisionGoal",
       "MaxStepFraction", "BoundaryOptions", "Eq103Order",
       "ApplyBBOuterParityConventionCorrection",
       "BBOuterParityCorrectionOrder",
       "E2EvolutionVariable", "E2InfinitySeriesOrder",
       "E2InfinityBoundaryAccuracyGoal",
       "E2InfinityOuterVertexEvaluation", "E2TransportMethod",
       "E2PatchwiseWaypointsE2", "E2PatchwiseLocalSeriesOrder",
       "E2PatchwiseCompareOrderDrop", "E2PatchwiseRelativeTolerance",
       "E2PatchwiseSafetyFactor"}
    ],
    "Ratios" -> StandaloneXYZZRatiosAtPoint[targetPoint, wp],
    "F2ConvergenceQ" ->
      XYZZThreeVertexF2ConvergenceQ[StandaloneXYZZRatiosAtPoint[targetPoint, wp]],
    "AnalyticEq103" -> analyticEq103,
    "BBOuterParityConventionCorrectionOrder" ->
      bbConventionCorrectionOrder,
    "BBOuterParityConventionCorrection" -> bbConventionCorrection,
    "DirectTargetBoundaryInPaperConvention" ->
      StandalonePaperValueFromRaw25[params, targetPoint, targetRaw25, wp],
    "DirectTargetBoundaryInXYZZEq103Convention" -> N[
      StandalonePaperValueFromRaw25[
        params, targetPoint, targetRaw25, wp
      ] - bbConventionCorrection,
      wp
    ],
    "PathResults" ->
      If[
        returnRawQ,
        pathResults,
        Association@KeyValueMap[#1 -> StandaloneStripRawPathResult[#2] &, pathResults]
      ],
    "PairwisePathResiduals" -> pairwise
  |>
];

Options[StandaloneMakeConfig] = {
  "PathChoice" -> "s1",
  "Quality" -> "Smoke",
  "Parameters" -> Automatic,
  "TargetPoint" -> Automatic,
  "StartPoints" -> Automatic,
  "E2EvolutionVariable" -> "TrueInfinity",
  "E2TransportMethod" -> "NDSolve",
  "E2PatchwiseWaypointsE2" -> Automatic,
  "E2PatchwiseLocalSeriesOrder" -> Automatic,
  "E2PatchwiseCompareOrderDrop" -> 2,
  "E2PatchwiseRelativeTolerance" -> Automatic,
  "E2PatchwiseSafetyFactor" -> 1/2,
  "ApplyBBOuterParityConventionCorrection" -> True,
  "BBOuterParityCorrectionOrder" -> Automatic,
  "ReturnRawVectors" -> False,
  "Verbose" -> True
};

StandaloneMakeConfig[OptionsPattern[]] := Module[
  {quality, settings, params, targetPoint, startPoints, pathNames,
   e2EvolutionVariable, e2TransportMethod, e2PatchwiseWaypointsE2,
   e2PatchwiseLocalSeriesOrder, e2PatchwiseCompareOrderDrop,
   e2PatchwiseRelativeTolerance, e2PatchwiseSafetyFactor,
   requiredStartPaths},
  quality = OptionValue["Quality"];
  settings = StandaloneQualitySettings[quality];
  If[settings === $Failed, Return[$Failed]];
  params = Replace[OptionValue["Parameters"], Automatic :> StandaloneDefaultParameters[]];
  targetPoint = Replace[OptionValue["TargetPoint"], Automatic :> StandaloneDefaultTargetPoint[]];
  startPoints = Replace[OptionValue["StartPoints"], Automatic :> StandaloneDefaultStartPoints[targetPoint]];
  pathNames = StandaloneResolvePathChoice[OptionValue["PathChoice"]];
  If[pathNames === $Failed, Return[$Failed]];
  e2EvolutionVariable = OptionValue["E2EvolutionVariable"];
  If[
    !MemberQ[{"DirectE2", "InverseT", "TrueInfinity"},
      e2EvolutionVariable],
    Print[
      "Bad E2EvolutionVariable: ", e2EvolutionVariable,
      ". Use DirectE2, InverseT, or TrueInfinity."
    ];
    Return[$Failed]
  ];
  e2TransportMethod = OptionValue["E2TransportMethod"];
  If[!MemberQ[{"NDSolve", "PatchwiseSeries"}, e2TransportMethod],
    Print[
      "Bad E2TransportMethod: ", e2TransportMethod,
      ". Use NDSolve or PatchwiseSeries."
    ];
    Return[$Failed]
  ];
  If[
    MemberQ[pathNames, "E2"] &&
      e2TransportMethod === "PatchwiseSeries" &&
      e2EvolutionVariable =!= "TrueInfinity",
    Print[
      "PatchwiseSeries currently requires ",
      "E2EvolutionVariable -> TrueInfinity."
    ];
    Return[$Failed]
  ];
  e2PatchwiseWaypointsE2 = OptionValue["E2PatchwiseWaypointsE2"];
  If[
    e2TransportMethod === "PatchwiseSeries" &&
      e2PatchwiseWaypointsE2 =!= Automatic,
    If[
      !ListQ[e2PatchwiseWaypointsE2] ||
        Length[e2PatchwiseWaypointsE2] < 2 ||
        !VectorQ[e2PatchwiseWaypointsE2, NumericQ] ||
        !And @@ (TrueQ[#1 > 0] & /@ e2PatchwiseWaypointsE2) ||
        !And @@ MapThread[
          TrueQ[#1 > #2] &,
          {Most[e2PatchwiseWaypointsE2], Rest[e2PatchwiseWaypointsE2]}
        ] ||
        !TrueQ[Last[e2PatchwiseWaypointsE2] == targetPoint["E2"]],
      Print[
        "E2PatchwiseWaypointsE2 must be a strictly decreasing positive ",
        "list whose last entry equals TargetPoint[\"E2\"]."
      ];
      Return[$Failed]
    ]
  ];
  e2PatchwiseLocalSeriesOrder = Replace[
    OptionValue["E2PatchwiseLocalSeriesOrder"],
    Automatic :> Switch[quality, "Smoke", 60, "Medium", 72, "High", 84]
  ];
  e2PatchwiseCompareOrderDrop =
    OptionValue["E2PatchwiseCompareOrderDrop"];
  e2PatchwiseRelativeTolerance = Replace[
    OptionValue["E2PatchwiseRelativeTolerance"],
    Automatic :> Switch[
      quality, "Smoke", 10^-18, "Medium", 10^-28, "High", 10^-36
    ]
  ];
  e2PatchwiseSafetyFactor = OptionValue["E2PatchwiseSafetyFactor"];
  If[
    !IntegerQ[e2PatchwiseLocalSeriesOrder] ||
      !IntegerQ[e2PatchwiseCompareOrderDrop] ||
      e2PatchwiseLocalSeriesOrder < 2 ||
      e2PatchwiseCompareOrderDrop < 1 ||
      e2PatchwiseCompareOrderDrop >= e2PatchwiseLocalSeriesOrder ||
      !NumericQ[e2PatchwiseRelativeTolerance] ||
      !TrueQ[e2PatchwiseRelativeTolerance > 0] ||
      !NumericQ[e2PatchwiseSafetyFactor] ||
      !TrueQ[0 < e2PatchwiseSafetyFactor < 1],
    Print["Bad PatchwiseSeries order, tolerance, or safety-factor setting."];
    Return[$Failed]
  ];
  requiredStartPaths = Select[
    pathNames,
    !(#1 === "E2" && e2EvolutionVariable === "TrueInfinity") &
  ];
  If[!And @@ (KeyExistsQ[startPoints, #] & /@ requiredStartPaths),
    Print["StartPoints does not contain every requested finite-start path: ",
      requiredStartPaths];
    Return[$Failed]
  ];
  Join[
    <|
      "Quality" -> quality,
      "Parameters" -> params,
      "TargetPoint" -> targetPoint,
      "StartPoints" -> startPoints,
      "PathNames" -> pathNames,
      "SignsList" -> XYZZProjectIndependentBranchSigns[],
      "E2EvolutionVariable" -> e2EvolutionVariable,
      "E2TransportMethod" -> e2TransportMethod,
      "E2PatchwiseWaypointsE2" -> e2PatchwiseWaypointsE2,
      "E2PatchwiseLocalSeriesOrder" -> e2PatchwiseLocalSeriesOrder,
      "E2PatchwiseCompareOrderDrop" -> e2PatchwiseCompareOrderDrop,
      "E2PatchwiseRelativeTolerance" -> e2PatchwiseRelativeTolerance,
      "E2PatchwiseSafetyFactor" -> e2PatchwiseSafetyFactor,
      "ApplyBBOuterParityConventionCorrection" ->
        OptionValue["ApplyBBOuterParityConventionCorrection"],
      "BBOuterParityCorrectionOrder" ->
        OptionValue["BBOuterParityCorrectionOrder"],
      "ReturnRawVectors" -> OptionValue["ReturnRawVectors"],
      "Verbose" -> OptionValue["Verbose"]
    |>,
    settings
  ]
];

StandalonePrintCompactReport[result_Association] := Module[
  {pathRows, pairwise},
  Print[""];
  Print["========== Corrected self-contained xyzz comparison =========="];
  Print["Object: ", result["ComparisonObject"]];
  Print["ConventionFittedQ: ", result["ConventionFittedQ"]];
  Print["PathNames: ", result["PathNames"]];
  Print["TargetPoint: ", result["TargetPoint"]];
  Print["E2TransportMethod: ",
    Lookup[result["Numerics"], "E2TransportMethod", "NDSolve"]];
  If[
    Lookup[result["Numerics"], "E2TransportMethod", "NDSolve"] ===
      "PatchwiseSeries",
    Print["E2PatchwiseWaypointsE2: ",
      result["Numerics"]["E2PatchwiseWaypointsE2"]]
  ];
  Print["Ratios {s1/E1,s1/E2,s2/E2,s2/E3}: ", N[result["Ratios"], 30]];
  Print["F2ConvergenceQ: ", result["F2ConvergenceQ"]];
  Print["AnalyticEq103: ", N[result["AnalyticEq103"], 40]];
  Print["BBOuterParityConventionCorrection: ",
    N[result["BBOuterParityConventionCorrection"], 40]];
  Print["BBOuterParityConventionCorrectionOrder: ",
    result["BBOuterParityConventionCorrectionOrder"]];
  Print["DirectTargetBoundaryInPaperConvention: ",
    N[result["DirectTargetBoundaryInPaperConvention"], 40]];
  pathRows = KeyValueMap[
    {
      #1,
      N[#2["Project25DInXYZZEq103Convention"], 35],
      N[#2["ProjectVsAnalyticRelativeResidual"], 20],
      N[#2["ProjectVsAnalyticUncorrectedRelativeResidual"], 20],
      N[#2["ProjectVsDirectBoundaryRelativeResidual"], 20],
      N[#2["DirectBoundaryVsAnalyticRelativeResidual"], 20]
    } &,
    result["PathResults"]
  ];
  Print[Grid[
    Prepend[
      pathRows,
      {"path", "Project25D xyzz Eq103 convention", "ProjectVsAnalytic",
       "Uncorrected ProjectVsAnalytic", "ProjectVsDirectBoundary",
       "DirectBoundaryVsAnalytic"}
    ],
    Frame -> All,
    Alignment -> Left
  ]];
  pairwise = result["PairwisePathResiduals"];
  Print["Pairwise flatness: ",
    KeyTake[
      pairwise,
      {"MaxPairwiseProjectPaperRelativeResidual",
       "MaxPairwiseBranchVectorRelativeResidual",
       "MaxPairwiseBranchTop0000RelativeResidual"}
    ]
  ];
  result
];

(* Self-contained V5.5 replacement for the old Part 4B cell. *)

(* Evaluate Parts 1--4A first, then evaluate this entire cell once. *)

$HistoryLength = 0;

ClearAll[
  XYZZPatchwiseScalarTaylorCoefficients,
  XYZZPatchwiseConnectionTaylorCoefficients,
  XYZZPatchwiseConnectionSingularities,
  XYZZPatchwiseAutomaticWaypoints,
  XYZZPatchwiseSeriesPropagate,
  XYZZPatchwiseSeriesEvaluate,
  XYZZSolveProjectBranchE2PatchwiseFromInfinity
];

XYZZPatchwiseScalarTaylorCoefficients[
  expression_,
  variable_Symbol,
  center_?NumericQ,
  maximumOrder_Integer?NonNegative,
  workingPrecision_Integer?Positive
] := Module[
  {z, rationalExpression, numerator, denominator, numeratorCoefficients,
    denominatorCoefficients, denominator0, coefficients, n, j},
  rationalExpression = Cancel[Together[expression]];
  If[
    TrueQ[rationalExpression === 0],
    Return[ConstantArray[0, maximumOrder + 1]]
  ];
  z = Unique["z"];
  numerator = Numerator[rationalExpression] /. variable -> center + z;
  denominator = Denominator[rationalExpression] /. variable -> center + z;
  If[
    !PolynomialQ[numerator, z] || !PolynomialQ[denominator, z],
    Return[Failure[
      "NonRationalConnectionEntry",
      <|"Expression" -> expression, "Variable" -> variable|>
    ]]
  ];
  numeratorCoefficients = N[
    Take[
      PadRight[CoefficientList[Expand[numerator], z], maximumOrder + 1],
      maximumOrder + 1
    ],
    workingPrecision
  ];
  denominatorCoefficients = N[
    Take[
      PadRight[CoefficientList[Expand[denominator], z], maximumOrder + 1],
      maximumOrder + 1
    ],
    workingPrecision
  ];
  denominator0 = denominatorCoefficients[[1]];
  If[
    !NumericQ[denominator0] || TrueQ[PossibleZeroQ[denominator0]],
    Return[Failure[
      "ExpansionCenterIsSingular",
      <|"Center" -> center, "Expression" -> expression|>
    ]]
  ];
  coefficients = ConstantArray[0, maximumOrder + 1];
  Do[
    coefficients[[n + 1]] = N[
      (
        numeratorCoefficients[[n + 1]] -
          Sum[
            denominatorCoefficients[[j + 1]] *
              coefficients[[n - j + 1]],
            {j, 1, n}
          ]
      )/denominator0,
      workingPrecision
    ],
    {n, 0, maximumOrder}
  ];
  coefficients
];

XYZZPatchwiseConnectionTaylorCoefficients[
  connectionExpression_?MatrixQ,
  variable_Symbol,
  center_?NumericQ,
  maximumOrder_Integer?NonNegative,
  workingPrecision_Integer?Positive
] := Module[{entryCoefficients, failure},
  entryCoefficients = Map[
    XYZZPatchwiseScalarTaylorCoefficients[
      #1, variable, center, maximumOrder, workingPrecision
    ] &,
    connectionExpression,
    {2}
  ];
  failure = Cases[entryCoefficients, _Failure, Infinity];
  If[failure =!= {}, Return[First[failure]]];
  Table[
    Map[#1[[order + 1]] &, entryCoefficients, {2}],
    {order, 0, maximumOrder}
  ]
];

XYZZPatchwiseConnectionSingularities[
  connectionExpression_?MatrixQ,
  variable_Symbol,
  workingPrecision_Integer?Positive
] := Module[
  {nonzeroEntries, denominators, rootLists, roots, mergeTolerance},
  nonzeroEntries = Select[
    Flatten[connectionExpression],
    !TrueQ[PossibleZeroQ[#1]] &
  ];
  denominators = DeleteDuplicates[
    Denominator[Cancel[Together[#1]]] & /@ nonzeroEntries
  ];
  denominators = Select[denominators, !FreeQ[#1, variable] &];
  rootLists = Table[
    Quiet@Check[
      variable /. NSolve[
        denominator == 0,
        variable,
        WorkingPrecision -> workingPrecision
      ],
      {}
    ],
    {denominator, denominators}
  ];
  roots = Select[Flatten[rootLists], NumericQ];
  mergeTolerance = N[10^(-Max[10, Floor[workingPrecision/2]]), workingPrecision];
  DeleteDuplicates[
    N[roots, workingPrecision],
    Abs[#1 - #2] <= mergeTolerance &
  ]
];

XYZZPatchwiseAutomaticWaypoints[
  start_?NumericQ,
  end_?NumericQ,
  safetyFactor_?NumericQ
] := Module[
  {points, direction, current, next, multiplier, maximumSegments},
  If[
    !TrueQ[0 < safetyFactor < 1] || !TrueQ[start > 0] || !TrueQ[end > 0],
    Return[$Failed]
  ];
  If[TrueQ[start == end], Return[{start}]];
  direction = Sign[end - start];
  multiplier = If[
    direction > 0,
    1 + safetyFactor/2,
    1 - safetyFactor/2
  ];
  points = {start};
  current = start;
  maximumSegments = 10000;
  While[direction (end - current) > 0 && Length[points] <= maximumSegments,
    next = If[
      direction > 0,
      Min[end, multiplier current],
      Max[end, multiplier current]
    ];
    If[TrueQ[next == current], Return[$Failed]];
    points = Append[points, next];
    current = next;
  ];
  If[current =!= end, $Failed, points]
];

Options[XYZZPatchwiseSeriesPropagate] = {
  "WorkingPrecision" -> 50,
  "SeriesOrder" -> 60,
  "CompareOrderDrop" -> 2,
  "RelativeTolerance" -> 10^-18,
  "SafetyFactor" -> 1/2,
  "Singularities" -> Automatic,
  "ReturnPatchData" -> False
};

XYZZPatchwiseSeriesPropagate[
  connectionExpression_?MatrixQ,
  variable_Symbol,
  waypoints : {__?NumericQ},
  initialValue_List,
  OptionsPattern[]
] := Module[
  {workingPrecision, seriesOrder, compareOrderDrop, relativeTolerance,
    safetyFactor, singularities, returnPatchData, numericWaypoints,
    currentValue, records,
    center, endpoint, step, distances, radius, nearestSingularity,
    stepRatio, connectionCoefficients, coefficientSeconds,
    coefficientVectors, recurrenceSeconds, highValue, lowValue,
    truncationEstimate, endpointDerivative, endpointConnection,
    endpointODEResidual, n, k, segmentIndex, acceptedQ, failureResult,
    segmentRecord},
  workingPrecision = OptionValue["WorkingPrecision"];
  seriesOrder = OptionValue["SeriesOrder"];
  compareOrderDrop = OptionValue["CompareOrderDrop"];
  relativeTolerance = N[
    OptionValue["RelativeTolerance"], workingPrecision
  ];
  safetyFactor = N[OptionValue["SafetyFactor"], workingPrecision];
  returnPatchData = TrueQ[OptionValue["ReturnPatchData"]];
  If[
    !IntegerQ[seriesOrder] || seriesOrder < 2 ||
      !IntegerQ[compareOrderDrop] ||
      compareOrderDrop < 1 || compareOrderDrop >= seriesOrder ||
      !TrueQ[0 < safetyFactor < 1],
    Return[$Failed]
  ];
  If[
    Length[initialValue] =!= Length[connectionExpression] ||
      Dimensions[connectionExpression] =!=
        {Length[initialValue], Length[initialValue]},
    Return[$Failed]
  ];
  numericWaypoints = N[waypoints, workingPrecision];
  currentValue = N[initialValue, workingPrecision];
  singularities = Replace[
    OptionValue["Singularities"],
    Automatic :> XYZZPatchwiseConnectionSingularities[
      connectionExpression, variable, workingPrecision
    ]
  ];
  If[singularities === $Failed || !ListQ[singularities], Return[$Failed]];
  singularities = N[singularities, workingPrecision];
  records = {};
  failureResult = None;

  Do[
    center = numericWaypoints[[segmentIndex]];
    endpoint = numericWaypoints[[segmentIndex + 1]];
    step = endpoint - center;
    If[singularities === {},
      radius = Infinity;
      nearestSingularity = Missing["NoFiniteSingularity"];
      stepRatio = 0,
      distances = Abs[center - singularities];
      radius = Min[distances];
      nearestSingularity = singularities[[First@FirstPosition[distances, radius]]];
      If[
        !NumericQ[radius] || TrueQ[radius <= 0],
        failureResult = $Failed;
        Break[]
      ];
      stepRatio = N[Abs[step]/radius, workingPrecision]
    ];
    If[!TrueQ[stepRatio < safetyFactor],
      failureResult = Failure[
        "UnsafeWaypointStep",
        <|
          "SegmentIndex" -> segmentIndex,
          "Center" -> center,
          "Endpoint" -> endpoint,
          "NearestSingularity" -> nearestSingularity,
          "ConvergenceRadius" -> radius,
          "StepRatio" -> stepRatio,
          "SafetyFactor" -> safetyFactor
        |>
      ];
      Break[]
    ];
    coefficientSeconds = First@AbsoluteTiming[
      connectionCoefficients =
        XYZZPatchwiseConnectionTaylorCoefficients[
          connectionExpression,
          variable,
          center,
          seriesOrder - 1,
          workingPrecision
        ];
    ];
    If[
      Head[connectionCoefficients] === Failure,
      failureResult = connectionCoefficients;
      Break[]
    ];
    coefficientVectors = ConstantArray[0, seriesOrder + 1];
    coefficientVectors[[1]] = currentValue;
    recurrenceSeconds = First@AbsoluteTiming[
      Do[
        coefficientVectors[[n + 2]] = N[
          Sum[
            connectionCoefficients[[k + 1]] .
              coefficientVectors[[n - k + 1]],
            {k, 0, n}
          ]/(n + 1),
          workingPrecision
        ],
        {n, 0, seriesOrder - 1}
      ];
      highValue = N[
        Sum[
          coefficientVectors[[n + 1]] step^n,
          {n, 0, seriesOrder}
        ],
        workingPrecision
      ];
      lowValue = N[
        Sum[
          coefficientVectors[[n + 1]] step^n,
          {n, 0, seriesOrder - compareOrderDrop}
        ],
        workingPrecision
      ];
    ];
    truncationEstimate = N[
      Norm[highValue - lowValue]/Max[Norm[highValue], 10^-100],
      workingPrecision
    ];
    endpointDerivative = N[
      Sum[
        n coefficientVectors[[n + 1]] step^(n - 1),
        {n, 1, seriesOrder}
      ],
      workingPrecision
    ];
    endpointConnection = N[
      connectionExpression /. variable -> endpoint,
      workingPrecision
    ];
    endpointODEResidual = N[
      Norm[endpointDerivative - endpointConnection . highValue]/
        Max[
          Norm[endpointDerivative],
          Norm[endpointConnection . highValue],
          10^-100
        ],
      workingPrecision
    ];
    acceptedQ = TrueQ[truncationEstimate <= relativeTolerance];
    segmentRecord = <|
        "SegmentIndex" -> segmentIndex,
        "Center" -> center,
        "Endpoint" -> endpoint,
        "Step" -> step,
        "NearestSingularity" -> nearestSingularity,
        "ConvergenceRadius" -> radius,
        "StepRatio" -> stepRatio,
        "SafetyFactor" -> safetyFactor,
        "SeriesOrder" -> seriesOrder,
        "CompareOrder" -> seriesOrder - compareOrderDrop,
        "EstimatedRelativeTruncation" -> truncationEstimate,
        "EndpointODERelativeResidual" -> endpointODEResidual,
        "CoefficientSeconds" -> coefficientSeconds,
        "RecurrenceAndEvaluationSeconds" -> recurrenceSeconds,
        "AcceptedQ" -> acceptedQ
      |>;
    If[
      returnPatchData,
      segmentRecord = Join[
        segmentRecord,
        <|"CoefficientVectors" -> coefficientVectors|>
      ]
    ];
    records = Append[records, segmentRecord];
    If[
      !acceptedQ,
      failureResult = Failure[
        "PatchTruncationNotMet",
        <|
          "SegmentIndex" -> segmentIndex,
          "EstimatedRelativeTruncation" -> truncationEstimate,
          "RelativeTolerance" -> relativeTolerance,
          "SegmentRecord" -> Last[records]
        |>
      ];
      Break[]
    ];
    currentValue = highValue,
    {segmentIndex, 1, Length[numericWaypoints] - 1}
  ];
  If[failureResult =!= None, Return[failureResult]];

  <|
    "Value" -> currentValue,
    "Waypoints" -> numericWaypoints,
    "Singularities" -> singularities,
    "SeriesOrder" -> seriesOrder,
    "CompareOrderDrop" -> compareOrderDrop,
    "RelativeTolerance" -> relativeTolerance,
    "SafetyFactor" -> safetyFactor,
    "WorkingPrecision" -> workingPrecision,
    "PatchDataAvailableQ" -> returnPatchData,
    "PatchBuildCount" -> Length[records],
    "Segments" -> records,
    "AcceptedQ" -> And @@ Lookup[records, "AcceptedQ", False]
  |>
];

XYZZPatchwiseSeriesEvaluate[
  result_Association,
  point_?NumericQ
] := Module[
  {segments, patch, coefficients, center, endpoint, delta, highOrder,
    compareOrder, highValue, lowValue, relativeDifference, radius,
    stepRatio, workingPrecision, containmentTolerance},
  segments = Lookup[result, "Segments", {}];
  If[
    !TrueQ[Lookup[result, "PatchDataAvailableQ", False]] ||
      !ListQ[segments] || segments === {},
    Return[Failure[
      "PatchDataUnavailable",
      <|"Point" -> point|>
    ]]
  ];
  workingPrecision = Lookup[
    result,
    "WorkingPrecision",
    Max[20, Replace[Precision[N[point]], MachinePrecision -> 20]]
  ];
  containmentTolerance = N[10^(-Floor[workingPrecision/2]), workingPrecision];
  patch = SelectFirst[
    segments,
    With[
      {lo = Min[#1["Center"], #1["Endpoint"]],
        hi = Max[#1["Center"], #1["Endpoint"]]},
      TrueQ[lo - containmentTolerance <= point <= hi + containmentTolerance]
    ] &,
    Missing["NotFound"]
  ];
  If[
    MissingQ[patch],
    Return[Failure[
      "PointOutsidePatchDomain",
      <|
        "Point" -> point,
        "Domain" -> {
          Min[Lookup[segments, "Center"] ~Join~ Lookup[segments, "Endpoint"]],
          Max[Lookup[segments, "Center"] ~Join~ Lookup[segments, "Endpoint"]]
        }
      |>
    ]]
  ];
  coefficients = Lookup[patch, "CoefficientVectors", Missing["NotFound"]];
  If[MissingQ[coefficients] || !ListQ[coefficients],
    Return[Failure[
      "PatchCoefficientDataUnavailable",
      <|"SegmentIndex" -> patch["SegmentIndex"], "Point" -> point|>
    ]]
  ];
  center = patch["Center"];
  endpoint = patch["Endpoint"];
  delta = point - center;
  highOrder = patch["SeriesOrder"];
  compareOrder = patch["CompareOrder"];
  If[
    TrueQ[PossibleZeroQ[delta]],
    highValue = N[First[coefficients], workingPrecision];
    lowValue = highValue;
    relativeDifference = N[0, workingPrecision],
    highValue = N[
      Sum[coefficients[[n + 1]] delta^n, {n, 0, highOrder}],
      workingPrecision
    ];
    lowValue = N[
      Sum[coefficients[[n + 1]] delta^n, {n, 0, compareOrder}],
      workingPrecision
    ];
    relativeDifference = N[
      Norm[highValue - lowValue]/Max[Norm[highValue], 10^-100],
      workingPrecision
    ]
  ];
  radius = patch["ConvergenceRadius"];
  stepRatio = If[
    radius === Infinity,
    0,
    N[Abs[delta]/radius, workingPrecision]
  ];
  <|
    "Value" -> highValue,
    "CompareValue" -> lowValue,
    "EstimatedRelativeTruncation" -> relativeDifference,
    "Point" -> N[point, workingPrecision],
    "SegmentIndex" -> patch["SegmentIndex"],
    "Center" -> center,
    "Endpoint" -> endpoint,
    "StepRatio" -> stepRatio,
    "SeriesOrder" -> highOrder,
    "CompareOrder" -> compareOrder
  |>
];

Options[XYZZSolveProjectBranchE2PatchwiseFromInfinity] = {
  "WorkingPrecision" -> 50,
  "SeriesOrder" -> 8,
  "BoundaryAccuracyGoal" -> 18,
  "BoundaryGuardDigits" -> 20,
  "BoundaryMaxRecursion" -> 14,
  "BoundaryCutoff" -> 35,
  "BoundaryLowerCutoff" -> 10^-8,
  "OuterVertexEvaluation" -> "Series",
  "OuterVertexSeriesOrder" -> 5,
  "SeriesStartT" -> Automatic,
  "SeriesSafetyFactor" -> 1/20,
  "WaypointsT" -> Automatic,
  "LocalSeriesOrder" -> 60,
  "LocalCompareOrderDrop" -> 2,
  "LocalRelativeTolerance" -> 10^-18,
  "LocalSafetyFactor" -> 1/2,
  "ReturnPatchData" -> False,
  "ReturnFrobeniusData" -> False
};

XYZZSolveProjectBranchE2PatchwiseFromInfinity[
  signs : {(_Integer)..},
  rules_List,
  e2End_?NumericQ,
  OptionsPattern[]
] := Module[
  {workingPrecision, boundaryWorkingPrecision, seriesOrder,
    boundaryAccuracyGoal, rulesNoE2, tEnd, scaleValues, scale,
    requestedWaypoints, tStart, boundaryTolerance, data, dataSeconds,
    boundaryHigh, boundaryLow, boundaryTruncation, boundaryResidual,
    waypoints, propagated, transportSeconds, currentRules, result},
  If[!NameQ["XYZZProjectE2InfinityFrobeniusData"], Return[$Failed]];
  If[!XYZZLoadProjectCore[], Return[$Failed]];
  workingPrecision = OptionValue["WorkingPrecision"];
  boundaryWorkingPrecision =
    workingPrecision + OptionValue["BoundaryGuardDigits"];
  seriesOrder = OptionValue["SeriesOrder"];
  boundaryAccuracyGoal = OptionValue["BoundaryAccuracyGoal"];
  rulesNoE2 = DeleteCases[rules, E2 -> _];
  tEnd = N[1/e2End, boundaryWorkingPrecision];
  If[!NumericQ[tEnd] || !TrueQ[tEnd > 0], Return[$Failed]];
  requestedWaypoints = OptionValue["WaypointsT"];
  scaleValues = N[Abs[{E1, E3, s1, s2} /. rulesNoE2], boundaryWorkingPrecision];
  If[!VectorQ[scaleValues, NumericQ], Return[$Failed]];
  scale = Max[1, Sequence @@ scaleValues];
  tStart = Which[
    ListQ[requestedWaypoints] && Length[requestedWaypoints] >= 1,
      N[First[requestedWaypoints], boundaryWorkingPrecision],
    OptionValue["SeriesStartT"] === Automatic,
      Min[
        tEnd,
        N[OptionValue["SeriesSafetyFactor"]/scale, boundaryWorkingPrecision]
      ],
    True,
      Min[tEnd, N[OptionValue["SeriesStartT"], boundaryWorkingPrecision]]
  ];
  If[!NumericQ[tStart] || !TrueQ[0 < tStart <= tEnd], Return[$Failed]];
  dataSeconds = First@AbsoluteTiming[
    data = XYZZProjectE2InfinityFrobeniusData[
      signs,
      rulesNoE2,
      "WorkingPrecision" -> boundaryWorkingPrecision,
      "SeriesOrder" -> seriesOrder,
      "AccuracyGoal" -> Min[
        boundaryWorkingPrecision - 10,
        boundaryAccuracyGoal + 10
      ],
      "PrecisionGoal" -> Min[
        boundaryWorkingPrecision - 10,
        boundaryAccuracyGoal + 10
      ],
      "MaxRecursion" -> OptionValue["BoundaryMaxRecursion"],
      "Cutoff" -> OptionValue["BoundaryCutoff"],
      "LowerCutoff" -> OptionValue["BoundaryLowerCutoff"],
      "OuterVertexEvaluation" -> OptionValue["OuterVertexEvaluation"],
      "OuterVertexSeriesOrder" -> OptionValue["OuterVertexSeriesOrder"]
    ];
  ];
  If[!AssociationQ[data], Return[$Failed]];
  boundaryHigh = XYZZProjectE2InfinityEvaluate[data, tStart];
  boundaryLow = XYZZProjectE2InfinityEvaluate[data, tStart, seriesOrder - 1];
  boundaryTruncation = N[
    Norm[boundaryHigh - boundaryLow]/Max[Norm[boundaryHigh], 10^-100],
    boundaryWorkingPrecision
  ];
  boundaryTolerance = N[10^-boundaryAccuracyGoal, boundaryWorkingPrecision];
  If[
    !TrueQ[boundaryTruncation <= boundaryTolerance],
    Return[Failure[
      "InfinityBoundaryTruncationNotMet",
      <|
        "SeriesPatchT" -> tStart,
        "EstimatedRelativeTruncation" -> boundaryTruncation,
        "BoundaryTolerance" -> boundaryTolerance
      |>
    ]]
  ];
  boundaryResidual = XYZZProjectE2InfinitySeriesResidual[data, tStart];
  waypoints = If[
    requestedWaypoints === Automatic,
    XYZZPatchwiseAutomaticWaypoints[
      N[tStart, workingPrecision],
      N[tEnd, workingPrecision],
      OptionValue["LocalSafetyFactor"]
    ],
    N[requestedWaypoints, workingPrecision]
  ];
  If[
    !ListQ[waypoints] || Length[waypoints] < 1 ||
      !TrueQ[First[waypoints] == N[tStart, workingPrecision]] ||
      !TrueQ[Last[waypoints] == N[tEnd, workingPrecision]],
    Return[$Failed]
  ];
  transportSeconds = First@AbsoluteTiming[
    propagated = XYZZPatchwiseSeriesPropagate[
      data["ConnectionExpression"],
      data["SeriesVariable"],
      waypoints,
      N[boundaryHigh, workingPrecision],
      "WorkingPrecision" -> workingPrecision,
      "SeriesOrder" -> OptionValue["LocalSeriesOrder"],
      "CompareOrderDrop" -> OptionValue["LocalCompareOrderDrop"],
      "RelativeTolerance" -> OptionValue["LocalRelativeTolerance"],
      "SafetyFactor" -> OptionValue["LocalSafetyFactor"],
      "ReturnPatchData" -> OptionValue["ReturnPatchData"]
    ];
  ];
  If[!AssociationQ[propagated], Return[propagated]];
  currentRules = Join[rulesNoE2, {E2 -> e2End}];
  result = <|
    "Signs" -> signs,
    "RawBoundary25" -> propagated["Value"],
    "Rules" -> currentRules,
    "Segments" -> {
      <|
        "Variable" -> E2,
        "Range" -> {e2End, Infinity},
        "EvolutionVariable" -> "PatchwiseSeriesFromTrueInfinity",
        "TRange" -> {0, tEnd},
        "SeriesPatchT" -> tStart,
        "SeriesPatchE2" -> 1/tStart,
        "InfinitySeriesOrder" -> seriesOrder,
        "EstimatedInfinityBoundaryTruncation" -> boundaryTruncation,
        "InfinitySeriesODERelativeResidual" -> boundaryResidual,
        "WaypointsT" -> waypoints,
        "WaypointsE2" -> 1/waypoints,
        "LocalSeriesOrder" -> OptionValue["LocalSeriesOrder"],
        "LocalSeriesSegments" -> propagated["Segments"],
        "BoundarySeconds" -> dataSeconds,
        "TransportSeconds" -> transportSeconds,
        "TransportMethod" -> "PatchwiseSeries",
        "BoundaryAtInfinityQ" -> True,
        "AutomaticODESolverUsedQ" -> False,
        "SystemBasis" -> "Raw"
      |>
    },
    "WorkingPrecision" -> workingPrecision,
    "BoundaryAtInfinityQ" -> True
  |>;
  If[TrueQ[OptionValue["ReturnFrobeniusData"]],
    Append[result, "FrobeniusData" -> data],
    result
  ]
];

$HistoryLength = 0;

ClearAll[
  SoftLimitLoadProject,
  SoftLimitParameters,
  SoftLimitPointFromQ,
  SoftLimitPointFromX,
  SoftLimitRatiosFromX,
  SoftLimitXGrids,
  SoftLimitQGrids,
  SoftLimitEq103AnchorX,
  SoftLimitPullbackConnection,
  SoftLimitGeometricWaypoints,
  SoftLimitFixedBoundaryWaypointsT,
  SoftLimitSignTag,
  SoftLimitCacheHash,
  SoftLimitVectorResidual,
  SoftLimitScalarResidual,
  SoftLimitBoundaryProfiles,
  SoftLimitBoundaryBranchRecord,
  SoftLimitBoundarySetForOptions,
  SoftLimitSelectBoundary,
  SoftLimitRunPatchwise,
  SoftLimitSamplePatchwise,
  SoftLimitPatchDiagnostics,
  SoftLimitRawAtQ,
  SoftLimitPaperValueAtQ,
  SoftLimitEq103Record,
  SoftLimitEq103ConventionCorrection,
  SoftLimitPiecewiseLinearTime,
  SoftLimitProjectedEq103Time
];

SoftLimitParameters[] := Module[{p, mu, nu},
  p = {0, 0, 0};
  mu = {1, 2};
  nu = I mu;
  <|
    "p" -> p,
    "mu" -> mu,
    "nu" -> nu,
    "nu0" -> XYZZProjectNu0FromPaperP[p, nu]
  |>
];

SoftLimitPointFromQ[q_] := <|
  "E1" -> 100 q/99,
  "E2" -> 1,
  "E3" -> 10/99,
  "s1" -> q,
  "s2" -> 1/10
|>;

SoftLimitPointFromX[x_, wp_Integer:80] := AssociationMap[
  N[#1, wp] &,
  SoftLimitPointFromQ[10^-x]
];

SoftLimitRatiosFromX[x_, wp_Integer:80] := Module[{point},
  point = SoftLimitPointFromX[x, wp];
  N[{
    point["s1"]/point["E1"],
    point["s1"]/point["E2"],
    point["s2"]/point["E2"],
    point["s2"]/point["E3"]
  }, wp]
];

SoftLimitXGrids[] := <|
  1 -> {4},
  10 -> Table[1 + 3 j/9, {j, 0, 9}],
  50 -> Table[1 + 3 j/49, {j, 0, 49}]
|>;

SoftLimitQGrids[wp_Integer:80] := Map[
  Function[xValues, N[10^-#1, wp] & /@ xValues],
  SoftLimitXGrids[]
];

SoftLimitEq103AnchorX[] := {1, 7/4, 5/2, 13/4, 4};

SoftLimitPullbackConnection[
  signs : {(_Integer) ..},
  variable_Symbol
] := Module[{params, rules, mE1, mS1},
  params = SoftLimitParameters[];
  rules = {
    nu0L -> params["nu0"][[1]],
    nu0M -> params["nu0"][[2]],
    nu0R -> params["nu0"][[3]],
    nu1 -> params["nu"][[1]],
    nu2 -> params["nu"][[2]],
    E1 -> 100 variable/99,
    E2 -> 1,
    E3 -> 10/99,
    s1 -> variable,
    s2 -> 1/10
  };
  mE1 = XYZZProjectRawBranchMatrixForVariable[signs, E1] /. rules;
  mS1 = XYZZProjectRawBranchMatrix[signs] /. rules;
  Map[Cancel[Together[#1]] &, 100 mE1/99 + mS1, {2}]
];

SoftLimitGeometricWaypoints[
  start_:1/10,
  end_:1/10000,
  multiplier_:61/100,
  wp_Integer:80
] := Module[{points, current, next},
  If[
    !TrueQ[0 < end < start] || !TrueQ[0 < multiplier < 1],
    Return[$Failed]
  ];
  points = {start};
  current = start;
  While[current > end,
    next = Max[end, multiplier current];
    If[TrueQ[next == current], Return[$Failed]];
    points = Append[points, next];
    current = next;
  ];
  N[points, wp]
];

(* Deterministic, non-adaptive E2 waypoints for the true-infinity boundary
   transport.  The returned path is in t=1/E2 and runs from t=1/20 to t=1. *)
SoftLimitFixedBoundaryWaypointsT[multiplier_:4/5] := Module[
  {e2Points, current, next},
  If[!TrueQ[0 < multiplier < 1], Return[$Failed]];
  e2Points = {20};
  current = 20;
  While[current > 1,
    next = Max[1, multiplier current];
    If[TrueQ[next == current], Return[$Failed]];
    e2Points = Append[e2Points, next];
    current = next;
  ];
  1/e2Points
];

SoftLimitSignTag[signs_List] := StringJoin[
  If[#1 == 1, "p", "m"] & /@ signs
];

SoftLimitCacheHash[expression_] := IntegerString[
  Hash[expression, "SHA256"],
  16,
  64
];

SoftLimitVectorResidual[x_, y_, wp_Integer:60] := N[
  Norm[Flatten[x - y]]/Max[Norm[Flatten[y]], 10^-100],
  wp
];

SoftLimitScalarResidual[x_, y_, wp_Integer:60] := N[
  Abs[x - y]/Max[Abs[y], 10^-100],
  wp
];

SoftLimitBoundaryProfiles["Smoke"] := {
  <|
    "Name" -> "InfinitySmoke8",
    "HighSeriesOrder" -> 8,
    "LowSeriesOrder" -> 6
  |>,
  <|
    "Name" -> "InfinitySmoke10",
    "HighSeriesOrder" -> 10,
    "LowSeriesOrder" -> 8
  |>,
  <|
    "Name" -> "InfinitySmoke12",
    "HighSeriesOrder" -> 12,
    "LowSeriesOrder" -> 10
  |>
};

SoftLimitBoundaryProfiles["Medium"] := {
  <|
    "Name" -> "InfinityMedium14",
    "HighSeriesOrder" -> 14,
    "LowSeriesOrder" -> 12
  |>,
  <|
    "Name" -> "InfinityMedium16",
    "HighSeriesOrder" -> 16,
    "LowSeriesOrder" -> 14
  |>,
  <|
    "Name" -> "InfinityMedium18",
    "HighSeriesOrder" -> 18,
    "LowSeriesOrder" -> 16
  |>
};

SoftLimitBoundaryProfiles[] := SoftLimitBoundaryProfiles["Medium"];

SoftLimitBoundaryBranchRecord[
  signs_List,
  options_Association,
  cacheDirectory_String,
  cacheLabel_String,
  sourceHash_
] := Module[
  {params, point, rules, spec, specHash, cacheFile, cached, outputWP,
    opts, seconds, solution, value, segment},
  params = SoftLimitParameters[];
  point = SoftLimitPointFromQ[1/10];
  spec = <|
    "Object" -> "soft-limit x=1 true-infinity raw-25 boundary branch",
    "Signs" -> signs,
    "Parameters" -> params,
    "Point" -> point,
    "Options" -> options,
    "SourceHash" -> sourceHash
  |>;
  specHash = SoftLimitCacheHash[spec];
  cacheFile = FileNameJoin[{
    cacheDirectory,
    "boundary_" <> cacheLabel <> "_" <> SoftLimitSignTag[signs] <> ".wl"
  }];
  If[FileExistsQ[cacheFile],
    cached = Quiet@Check[Get[cacheFile], $Failed];
    If[
      AssociationQ[cached] && Lookup[cached, "SpecHash", ""] === specHash,
      Return[Append[cached, "CacheHitQ" -> True]]
    ]
  ];
  outputWP = Lookup[options, "OutputWorkingPrecision",
    Lookup[options, "WorkingPrecision", 80]];
  rules = StandaloneRulesFromPoint[params, point];
  opts = Sequence @@ Normal@KeyDrop[options, {"OutputWorkingPrecision"}];
  seconds = First@AbsoluteTiming[
    solution = XYZZSolveProjectBranchE2PatchwiseFromInfinity[
      signs, rules, point["E2"], opts
    ];
  ];
  If[!AssociationQ[solution],
    Return[Failure[
      "TrueInfinityBoundaryBranchFailed",
      <|"Signs" -> signs, "Options" -> options|>
    ]]
  ];
  value = Lookup[solution, "RawBoundary25", $Failed];
  If[value === $Failed || !VectorQ[value, NumericQ] || Length[value] =!= 25,
    Return[Failure[
      "BoundaryBranchFailed",
      <|"Signs" -> signs, "Options" -> options|>
    ]]
  ];
  segment = First@Lookup[solution, "Segments", {<||>}];
  cached = <|
    "SpecHash" -> specHash,
    "Signs" -> signs,
    "Value" -> N[value, outputWP],
    "Seconds" -> seconds,
    "CacheHitQ" -> False,
    "Options" -> options,
    "TransportDiagnostics" -> KeyTake[segment, {
      "InfinitySeriesOrder", "SeriesPatchT", "SeriesPatchE2",
      "EstimatedInfinityBoundaryTruncation",
      "InfinitySeriesODERelativeResidual", "WaypointsT", "WaypointsE2",
      "LocalSeriesOrder", "LocalSeriesSegments", "TransportMethod",
      "AutomaticODESolverUsedQ"
    }]
  |>;
  Put[cached, cacheFile];
  cached
];

SoftLimitBoundarySetForOptions[
  options_Association,
  cacheDirectory_String,
  cacheLabel_String,
  sourceHash_
] := Module[{signsList, records},
  signsList = XYZZProjectIndependentBranchSigns[];
  records = Association@Table[
    signs -> SoftLimitBoundaryBranchRecord[
      signs, options, cacheDirectory, cacheLabel, sourceHash
    ],
    {signs, signsList}
  ];
  If[!And @@ (AssociationQ /@ Values[records]), Return[records]];
  <|
    "Raw25" -> Association@KeyValueMap[#1 -> #2["Value"] &, records],
    "Records" -> records,
    "MeasuredSeconds" -> Total[Lookup[Values[records], "Seconds"]],
    "AllCacheHitsQ" -> And @@ Lookup[Values[records], "CacheHitQ"]
  |>
];

SoftLimitSelectBoundary[
  settings_Association,
  cacheDirectory_String,
  sourceHash_,
  tolerance_:10^-25
] := Module[
  {base, profiles, profile, highOrder, lowOrder, highOptions,
    lowOptions, high, low, branchResiduals, maximumResidual, result,
    boundaryWaypointsT},
  boundaryWaypointsT = SoftLimitFixedBoundaryWaypointsT[
    Lookup[settings, "BoundaryWaypointMultiplier", 4/5]
  ];
  If[!ListQ[boundaryWaypointsT], Return[$Failed]];
  base = <|
    "WorkingPrecision" -> settings["WorkingPrecision"],
    "OutputWorkingPrecision" -> settings["WorkingPrecision"],
    "BoundaryAccuracyGoal" -> Max[
      35, settings["E2InfinityBoundaryAccuracyGoal"]
    ],
    "BoundaryGuardDigits" -> 20,
    "BoundaryMaxRecursion" -> 14,
    "BoundaryCutoff" -> 35,
    "BoundaryLowerCutoff" -> 10^-8,
    "OuterVertexEvaluation" -> "Direct",
    "OuterVertexSeriesOrder" -> 16,
    "SeriesStartT" -> First[boundaryWaypointsT],
    "WaypointsT" -> boundaryWaypointsT,
    "LocalSeriesOrder" ->
      Lookup[settings, "BoundaryWaypointSeriesOrder", 72],
    "LocalCompareOrderDrop" -> 2,
    "LocalRelativeTolerance" ->
      Lookup[settings, "BoundaryWaypointRelativeTolerance", 10^-28],
    "LocalSafetyFactor" ->
      Lookup[settings, "BoundaryWaypointSafetyFactor", 2/5],
    "ReturnPatchData" -> False,
    "ReturnFrobeniusData" -> False
  |>;
  profiles = Lookup[
    settings,
    "BoundaryProfiles",
    SoftLimitBoundaryProfiles[]
  ];
  If[
    !ListQ[profiles] || profiles === {} ||
      !And @@ (AssociationQ /@ profiles),
    Return[$Failed]
  ];
  Do[
    highOrder = profile["HighSeriesOrder"];
    lowOrder = profile["LowSeriesOrder"];
    highOptions = Join[base, <|
      "SeriesOrder" -> highOrder
    |>];
    lowOptions = Join[base, <|
      "SeriesOrder" -> lowOrder
    |>];
    high = SoftLimitBoundarySetForOptions[
      highOptions, cacheDirectory, profile["Name"] <> "_high", sourceHash
    ];
    If[!AssociationQ[high], Return[high]];
    low = SoftLimitBoundarySetForOptions[
      lowOptions, cacheDirectory, profile["Name"] <> "_low", sourceHash
    ];
    If[!AssociationQ[low], Return[low]];
    branchResiduals = Association@Table[
      signs -> SoftLimitVectorResidual[
        high["Raw25"][signs], low["Raw25"][signs]
      ],
      {signs, XYZZProjectIndependentBranchSigns[]}
    ];
    maximumResidual = Max[Values[branchResiduals]];
    result = <|
      "Profile" -> profile,
      "Raw25" -> high["Raw25"],
      "High" -> high,
      "Low" -> low,
      "BranchResiduals" -> branchResiduals,
      "MaximumEstimatedRelativeTruncation" -> maximumResidual,
      "AcceptedQ" -> TrueQ[maximumResidual <= tolerance]
    |>;
    If[result["AcceptedQ"], Return[result]],
    {profile, profiles}
  ];
  result
];

SoftLimitRunPatchwise[
  connections_Association,
  initialRaw25_Association,
  variable_Symbol,
  waypoints_List,
  seriesOrder_Integer,
  wp_Integer:80,
  relativeTolerance_:10^-28,
  safetyFactor_:2/5
] := Module[{signsList, rows, totalSeconds},
  signsList = Keys[connections];
  rows = Association@Table[
    signs -> Module[{singularities, propagated, seconds},
      seconds = First@AbsoluteTiming[
        singularities = XYZZPatchwiseConnectionSingularities[
          connections[signs], variable, wp
        ];
        propagated = XYZZPatchwiseSeriesPropagate[
          connections[signs],
          variable,
          waypoints,
          N[initialRaw25[signs], wp],
          "WorkingPrecision" -> wp,
          "SeriesOrder" -> seriesOrder,
          "CompareOrderDrop" -> 2,
          "RelativeTolerance" -> relativeTolerance,
          "SafetyFactor" -> safetyFactor,
          "Singularities" -> singularities,
          "ReturnPatchData" -> True
        ];
      ];
      If[!AssociationQ[propagated], propagated,
        <|
          "Propagation" -> propagated,
          "Seconds" -> seconds,
          "Singularities" -> singularities
        |>
      ]
    ],
    {signs, signsList}
  ];
  If[
    !And @@ (AssociationQ[#1] && KeyExistsQ[#1, "Propagation"] & /@
      Values[rows]),
    Return[Failure["PatchwiseBranchFailed", <|"Rows" -> rows|>]]
  ];
  totalSeconds = Total[Lookup[Values[rows], "Seconds"]];
  <|
    "Rows" -> rows,
    "Propagations" ->
      Association@KeyValueMap[#1 -> #2["Propagation"] &, rows],
    "TransportSeconds" -> totalSeconds,
    "SeriesOrder" -> seriesOrder,
    "WorkingPrecision" -> wp,
    "RelativeTolerance" -> relativeTolerance,
    "SafetyFactor" -> safetyFactor,
    "PatchBuildCount" -> Total[
      Lookup[Lookup[Values[rows], "Propagation"], "PatchBuildCount"]
    ]
  |>
];

SoftLimitSamplePatchwise[
  run_Association,
  qValues_List
] := Module[{evaluations, values, seconds},
  seconds = First@AbsoluteTiming[
    evaluations = Association@Table[
      signs -> (XYZZPatchwiseSeriesEvaluate[
          run["Propagations"][signs], #1
        ] & /@ qValues),
      {signs, Keys[run["Propagations"]]}
    ];
  ];
  If[
    !And @@ Flatten[Map[AssociationQ, Values[evaluations], {2}]],
    Return[Failure[
      "PatchwiseSamplingFailed",
      <|"Evaluations" -> evaluations|>
    ]]
  ];
  values = Association@KeyValueMap[
    #1 -> Lookup[#2, "Value"] &,
    evaluations
  ];
  <|
    "Values" -> values,
    "Evaluations" -> evaluations,
    "Seconds" -> seconds
  |>
];

SoftLimitPatchDiagnostics[run_Association] := Module[{segments},
  segments = Flatten[
    Lookup[Values[run["Propagations"]], "Segments"],
    1
  ];
  <|
    "MaximumEstimatedRelativeTruncation" ->
      Max[Lookup[segments, "EstimatedRelativeTruncation"]],
    "MaximumEndpointODERelativeResidual" ->
      Max[Lookup[segments, "EndpointODERelativeResidual"]],
    "MaximumStepRatio" -> Max[Lookup[segments, "StepRatio"]],
    "PatchBuildCount" -> Length[segments]
  |>
];

SoftLimitRawAtQ[
  sampledValues_Association,
  index_Integer
] := Association@KeyValueMap[#1 -> #2[[index]] &, sampledValues];

SoftLimitPaperValueAtQ[
  params_Association,
  q_,
  sampledValues_Association,
  index_Integer,
  wp_Integer:80
] := StandalonePaperValueFromRaw25[
  params,
  AssociationMap[N[#1, wp] &, SoftLimitPointFromQ[q]],
  SoftLimitRawAtQ[sampledValues, index],
  wp
];

SoftLimitEq103Record[
  x_,
  repeat_Integer,
  wp_Integer,
  order_List,
  cacheDirectory_String,
  sourceHash_
] := Module[
  {params, point, spec, specHash, tag, cacheFile, cached, seconds, value},
  params = SoftLimitParameters[];
  point = SoftLimitPointFromX[x, wp];
  spec = <|
    "Object" -> "soft-limit Eq103 timing anchor",
    "x" -> x,
    "Repeat" -> repeat,
    "WorkingPrecision" -> wp,
    "Order" -> order,
    "Parameters" -> params,
    "Point" -> point,
    "SourceHash" -> sourceHash
  |>;
  specHash = SoftLimitCacheHash[spec];
  tag = StringReplace[ToString[InputForm[x]], {"/" -> "_", " " -> ""}];
  cacheFile = FileNameJoin[{
    cacheDirectory,
    "eq103_x" <> tag <> "_repeat" <> ToString[repeat] <> ".wl"
  }];
  If[FileExistsQ[cacheFile],
    cached = Quiet@Check[Get[cacheFile], $Failed];
    If[
      AssociationQ[cached] && Lookup[cached, "SpecHash", ""] === specHash,
      Return[Append[cached, "CacheHitQ" -> True]]
    ]
  ];
  seconds = First@AbsoluteTiming[
    value = StandaloneEq103AtPoint[params, point, order, wp];
  ];
  cached = <|
    "SpecHash" -> specHash,
    "x" -> N[x, 20],
    "Repeat" -> repeat,
    "Value" -> value,
    "Seconds" -> seconds,
    "CacheHitQ" -> False,
    "Order" -> order,
    "WorkingPrecision" -> wp
  |>;
  Put[cached, cacheFile];
  cached
];

SoftLimitEq103ConventionCorrection[
  x_,
  wp_Integer,
  order_List
] := Module[{params, point},
  params = SoftLimitParameters[];
  point = SoftLimitPointFromX[x, wp];
  StandaloneEq103ProjectConventionCorrectionAtPoint[
    params, point, order, wp
  ]
];

SoftLimitPiecewiseLinearTime[
  anchors_List,
  x_?NumericQ
] := Module[{sorted, exact, pair},
  sorted = SortBy[anchors, First];
  exact = SelectFirst[sorted, TrueQ[First[#1] == x] &, Missing["NotFound"]];
  If[!MissingQ[exact], Return[Last[exact]]];
  pair = SelectFirst[
    Partition[sorted, 2, 1],
    TrueQ[#[[1, 1]] < x < #[[2, 1]]] &,
    Missing["NotFound"]
  ];
  If[MissingQ[pair], Return[$Failed]];
  Interpolation[pair, InterpolationOrder -> 1][x]
];

SoftLimitProjectedEq103Time[
  anchors_List,
  xValues_List,
  loadSeconds_:0
] := N[
  loadSeconds + Total[SoftLimitPiecewiseLinearTime[anchors, #1] & /@ xValues],
  20
];

(* ::Section:: *)
(* ====================================================================== *)
(* Part 1F - PyFLINT bridge (Wolfram adapter embedded in this file)      *)
(* ====================================================================== *)

(* ::Text:: *)
(* V5.5 boundary update:
   - exact E2 pole/residue data are reused for t=1/E2;
   - python-flint performs the indicial cascade and Frobenius recurrence;
   - direct outer-vertex integrals and complete physical seeds are cached;
   - call XYZZClearInfinityBoundaryCaches[] to force a fresh boundary build. *)
(* The only companion source file is pyflint_e2_transport.py. *)
$HistoryLength = 0;

ClearAll[
  XYZZPyFlintBaseDirectory,
  XYZZPyFlintExactString,
  XYZZPyFlintDecimalString,
  XYZZPyFlintComplexRecord,
  XYZZPyFlintExactMatrixRecords,
  XYZZPyFlintPoleResidueData,
  XYZZBuildPyFlint25DPayload,
  XYZZExportPyFlint25DPayload,
  XYZZBuildE2PyFlintPayload,
  XYZZExportE2PyFlintPayload,
  XYZZRunE2PyFlintPayload,
  XYZZRunPyFlint25DPayload,
  XYZZPyFlintParseDecimal,
  XYZZPyFlintResultVector,
  XYZZProjectRawOneVertexVectorPyFlint,
  XYZZProjectRawOneVertexVectorPyFlintCached,
  XYZZSolveProjectBranchE2PyFlintFromInfinity
];

XYZZPyFlintBaseDirectory[] := Module[{notebookDirectory},
  If[
    StringQ[$InputFileName] && StringLength[$InputFileName] > 0,
    Return[DirectoryName[ExpandFileName[$InputFileName]]]
  ];
  notebookDirectory = Quiet@Check[NotebookDirectory[], $Failed];
  If[
    StringQ[notebookDirectory] && StringLength[notebookDirectory] > 0,
    ExpandFileName[notebookDirectory],
    Directory[]
  ]
];

$XYZZPyFlintAdapterDirectory = XYZZPyFlintBaseDirectory[];

XYZZPyFlintExactString[value_] := ToString[
  FullSimplify[value],
  InputForm
];

XYZZPyFlintDecimalString[value_, digits_Integer?Positive] := Module[
  {text},
  text = ToString[N[value, digits], InputForm];
  StringReplace[
    text,
    {
      RegularExpression["`+[0-9.]*"] -> "",
      "*^" -> "e",
      " " -> ""
    }
  ]
];

XYZZPyFlintComplexRecord[value_, digits_Integer?Positive] := <|
  "re" -> XYZZPyFlintDecimalString[Re[N[value, digits]], digits],
  "im" -> XYZZPyFlintDecimalString[Im[N[value, digits]], digits]
|>;

XYZZPyFlintExactMatrixRecords[matrix_?MatrixQ] := Map[
  XYZZPyFlintExactString,
  matrix,
  {2}
];

XYZZPyFlintPoleResidueData[
  connectionExpression_?MatrixQ,
  variable_Symbol
] := Module[
  {connection, nonzeroEntries, denominators, poleRules, poles,
    constant, residues, reconstructed, residual, badScalars},
  connection = Map[Cancel[Together[#1]] &, connectionExpression, {2}];
  nonzeroEntries = Select[Flatten[connection], !TrueQ[PossibleZeroQ[#1]] &];
  denominators = DeleteDuplicates[
    Denominator[#1] & /@ nonzeroEntries
  ];
  denominators = Select[denominators, !FreeQ[#1, variable] &];
  poleRules = Quiet@Check[
    Flatten[Solve[#1 == 0, variable] & /@ denominators],
    $Failed
  ];
  If[poleRules === $Failed, Return[Failure[
    "PoleSolveFailed",
    <|"Variable" -> variable, "Denominators" -> denominators|>
  ]]];
  poles = (variable /. #1) & /@ poleRules;
  poles = DeleteDuplicates[
    poles,
    TrueQ[FullSimplify[#1 == #2]] &
  ];
  poles = SortBy[
    poles,
    {N[Re[#1], 30], N[Im[#1], 30]} &
  ];
  If[poles === {}, Return[Failure[
    "NoFinitePoles",
    <|"Variable" -> variable|>
  ]]];
  constant = Quiet@Check[
    Map[FullSimplify[Limit[#1, variable -> Infinity]] &, connection, {2}],
    $Failed
  ];
  If[constant === $Failed || !MatrixQ[constant] ||
      !FreeQ[constant, DirectedInfinity | Indeterminate],
    Return[Failure[
      "NonconstantPolynomialPart",
      <|"Variable" -> variable|>
    ]]
  ];
  residues = Table[
    Map[
      FullSimplify[Limit[(variable - pole) #1, variable -> pole]] &,
      connection,
      {2}
    ],
    {pole, poles}
  ];
  reconstructed = constant + Total@MapThread[
    #2/(variable - #1) &,
    {poles, residues}
  ];
  residual = Map[
    FullSimplify[Together[#1]] &,
    connection - reconstructed,
    {2}
  ];
  If[!And @@ Flatten[Map[TrueQ[PossibleZeroQ[#1]] &, residual, {2}]],
    Return[Failure[
      "NotSimplePoleResidueForm",
      <|
        "Variable" -> variable,
        "Poles" -> poles,
        "Residual" -> residual
      |>
    ]]
  ];
  badScalars = Select[
    Flatten[{poles, constant, residues}],
    !TrueQ[
      Element[Re[#1], Rationals] && Element[Im[#1], Rationals]
    ] &
  ];
  If[badScalars =!= {}, Return[Failure[
    "PoleResidueDataNotExactRational",
    <|"Examples" -> Take[badScalars, UpTo[5]]|>
  ]]];
  <|
    "Poles" -> poles,
    "ConstantMatrix" -> constant,
    "ResidueMatrices" -> residues,
    "ExactReconstructionQ" -> True
  |>
];

Options[XYZZBuildPyFlint25DPayload] = {
  "WorkingPrecision" -> 80,
  "EvolutionVariable" -> Automatic
};

XYZZBuildPyFlint25DPayload[
  requestId_String,
  connectionExpression_?MatrixQ,
  variable_Symbol,
  waypoints_List,
  initialVector_List,
  lowerInitialVector_:Automatic,
  metadata_:<||>,
  OptionsPattern[]
] := Module[
  {workingPrecision, evolutionVariable, decomposition, payload},
  workingPrecision = OptionValue["WorkingPrecision"];
  evolutionVariable = Replace[
    OptionValue["EvolutionVariable"],
    Automatic :> ToString[variable, InputForm]
  ];
  If[Dimensions[connectionExpression] =!= {25, 25}, Return[Failure[
    "BadConnectionShape",
    <|"Dimensions" -> Dimensions[connectionExpression]|>
  ]]];
  If[Length[initialVector] =!= 25, Return[Failure[
    "BadInitialVectorLength",
    <|"Length" -> Length[initialVector]|>
  ]]];
  If[lowerInitialVector =!= Automatic && Length[lowerInitialVector] =!= 25,
    Return[Failure[
      "BadLowerInitialVectorLength",
      <|"Length" -> Length[lowerInitialVector]|>
    ]]
  ];
  If[Length[waypoints] < 2 || !VectorQ[waypoints, NumericQ], Return[Failure[
    "BadWaypoints",
    <|"Waypoints" -> waypoints|>
  ]]];
  decomposition = XYZZPyFlintPoleResidueData[
    connectionExpression,
    variable
  ];
  If[Head[decomposition] === Failure, Return[decomposition]];
  payload = <|
    "schema" -> "xyzz-25d-pyflint-pole-residue-v1",
    "request_id" -> requestId,
    "dimension" -> 25,
    "equation_orientation" -> "column",
    "evolution_variable" -> evolutionVariable,
    "basis" -> "Raw",
    "basis_order" -> {
      "Top:16", "LeftPinch:4", "RightPinch:4", "DoublePinch:1"
    },
    "taylor_recurrence" -> "pole_state",
    "poles_exact" -> (
      XYZZPyFlintExactString /@ decomposition["Poles"]
    ),
    "constant_matrix_exact" -> XYZZPyFlintExactMatrixRecords[
      decomposition["ConstantMatrix"]
    ],
    "residue_matrices_exact" -> (
      XYZZPyFlintExactMatrixRecords /@ decomposition["ResidueMatrices"]
    ),
    "waypoints_real" -> (
      XYZZPyFlintDecimalString[#1, workingPrecision] & /@ waypoints
    ),
    "initial_vector" -> (
      XYZZPyFlintComplexRecord[#1, workingPrecision] & /@
        N[initialVector, workingPrecision]
    ),
    "metadata" -> Join[
      <|
        "connection_exact_reconstruction" -> True,
        "working_precision" -> workingPrecision
      |>,
      metadata
    ]
  |>;
  If[lowerInitialVector =!= Automatic,
    AssociateTo[
      payload,
      "initial_vector_lower" -> (
        XYZZPyFlintComplexRecord[#1, workingPrecision] & /@
          N[lowerInitialVector, workingPrecision]
      )
    ]
  ];
  <|
    "Payload" -> payload,
    "PoleResidueData" -> decomposition,
    "Waypoints" -> N[waypoints, workingPrecision]
  |>
];

Options[XYZZExportPyFlint25DPayload] = Options[XYZZBuildPyFlint25DPayload];

XYZZExportPyFlint25DPayload[
  requestId_String,
  connectionExpression_?MatrixQ,
  variable_Symbol,
  waypoints_List,
  initialVector_List,
  lowerInitialVector_,
  metadata_,
  outputFile_String,
  OptionsPattern[]
] := Module[{built, exported},
  built = XYZZBuildPyFlint25DPayload[
    requestId,
    connectionExpression,
    variable,
    waypoints,
    initialVector,
    lowerInitialVector,
    metadata,
    "WorkingPrecision" -> OptionValue["WorkingPrecision"],
    "EvolutionVariable" -> OptionValue["EvolutionVariable"]
  ];
  If[!AssociationQ[built], Return[built]];
  exported = Quiet@Check[
    Export[outputFile, built["Payload"], "RawJSON"],
    $Failed
  ];
  If[exported === $Failed, Return[Failure[
    "PayloadExportFailed",
    <|"OutputFile" -> outputFile|>
  ]]];
  Join[built, <|"PayloadFile" -> ExpandFileName[outputFile]|>]
];

Options[XYZZBuildE2PyFlintPayload] = {
  "WorkingPrecision" -> 50,
  "BoundaryGuardDigits" -> 20,
  "InfinitySeriesOrder" -> 8,
  "BoundaryAccuracyGoal" -> 18,
  "BoundaryMaxRecursion" -> 14,
  "BoundaryCutoff" -> 35,
  "BoundaryLowerCutoff" -> 10^-8,
  "OuterVertexEvaluation" -> "Series",
  "OuterVertexSeriesOrder" -> 5,
  "WaypointsE2" -> {36000, 25000, 17500, 12500, 9000},
  "LocalSafetyFactor" -> 1/2,
  "ReturnFrobeniusData" -> False
};

XYZZBuildE2PyFlintPayload[
  signs : {(_Integer)..},
  rules_List,
  e2End_?NumericQ,
  OptionsPattern[]
] := Module[
  {workingPrecision, boundaryWorkingPrecision, infinitySeriesOrder,
    boundaryAccuracyGoal, rulesNoE2, waypointsE2, waypointsT,
    data, decomposition, boundaryHigh, boundaryLow,
    boundaryTruncation, boundaryResidual, payload, result},
  If[!NameQ["XYZZProjectE2InfinityFrobeniusData"] ||
      !NameQ["XYZZProjectE2InfinityEvaluate"] ||
      !NameQ["XYZZProjectE2InfinitySeriesResidual"],
    Return[Failure[
      "TrueInfinityAPIUnavailable",
      <|"RequiredSource" -> "001_dsde3vertex_v5.5.wl"|>
    ]]
  ];
  If[!XYZZLoadProjectCore[], Return[Failure[
    "ProjectCoreLoadFailed",
    <||>
  ]]];
  workingPrecision = OptionValue["WorkingPrecision"];
  boundaryWorkingPrecision = workingPrecision +
    OptionValue["BoundaryGuardDigits"];
  infinitySeriesOrder = OptionValue["InfinitySeriesOrder"];
  boundaryAccuracyGoal = OptionValue["BoundaryAccuracyGoal"];
  rulesNoE2 = DeleteCases[rules, E2 -> _];
  waypointsE2 = OptionValue["WaypointsE2"];
  If[
    !VectorQ[waypointsE2, NumericQ] || Length[waypointsE2] < 2 ||
      !And @@ Thread[Most[waypointsE2] > Rest[waypointsE2]] ||
      !TrueQ[Last[waypointsE2] == e2End],
    Return[Failure[
      "BadE2Waypoints",
      <|"WaypointsE2" -> waypointsE2, "ExpectedEndpoint" -> e2End|>
    ]]
  ];
  waypointsT = N[1/waypointsE2, boundaryWorkingPrecision];
  data = XYZZProjectE2InfinityFrobeniusData[
    signs,
    rulesNoE2,
    "WorkingPrecision" -> boundaryWorkingPrecision,
    "SeriesOrder" -> infinitySeriesOrder,
    "AccuracyGoal" -> Min[
      boundaryWorkingPrecision - 10,
      boundaryAccuracyGoal + 10
    ],
    "PrecisionGoal" -> Min[
      boundaryWorkingPrecision - 10,
      boundaryAccuracyGoal + 10
    ],
    "MaxRecursion" -> OptionValue["BoundaryMaxRecursion"],
    "Cutoff" -> OptionValue["BoundaryCutoff"],
    "LowerCutoff" -> OptionValue["BoundaryLowerCutoff"],
    "OuterVertexEvaluation" -> OptionValue["OuterVertexEvaluation"],
    "OuterVertexSeriesOrder" -> OptionValue["OuterVertexSeriesOrder"]
  ];
  If[!AssociationQ[data], Return[Failure[
    "TrueInfinityFrobeniusDataFailed",
    <|"Signs" -> signs|>
  ]]];
  decomposition = XYZZPyFlintPoleResidueData[
    data["ConnectionExpression"],
    data["SeriesVariable"]
  ];
  If[Head[decomposition] === Failure, Return[decomposition]];
  boundaryHigh = XYZZProjectE2InfinityEvaluate[
    data,
    First[waypointsT]
  ];
  boundaryLow = XYZZProjectE2InfinityEvaluate[
    data,
    First[waypointsT],
    infinitySeriesOrder - 1
  ];
  If[MemberQ[{boundaryHigh, boundaryLow}, $Failed], Return[Failure[
    "TrueInfinityBoundaryEvaluationFailed",
    <|"SeriesPatchT" -> First[waypointsT]|>
  ]]];
  boundaryTruncation = N[
    Norm[boundaryHigh - boundaryLow]/Max[Norm[boundaryHigh], 10^-100],
    boundaryWorkingPrecision
  ];
  boundaryResidual = XYZZProjectE2InfinitySeriesResidual[
    data,
    First[waypointsT]
  ];
  payload = <|
    "schema" -> "xyzz-e2-pyflint-pole-residue-v1",
    "request_id" -> StringJoin[
      "three_vertex_25d_e2_",
      StringRiffle[ToString /@ signs, "_"],
      "_",
      StringReplace[ToString[e2End, InputForm], "/" -> "over"]
    ],
    "dimension" -> 25,
    "equation_orientation" -> "column",
    "evolution_variable" -> "t=1/E2",
    "basis" -> "Raw",
    "basis_order" -> {
      "Top:16", "LeftPinch:4", "RightPinch:4", "DoublePinch:1"
    },
    "poles_exact" -> (
      XYZZPyFlintExactString /@ decomposition["Poles"]
    ),
    "constant_matrix_exact" -> XYZZPyFlintExactMatrixRecords[
      decomposition["ConstantMatrix"]
    ],
    "residue_matrices_exact" -> (
      XYZZPyFlintExactMatrixRecords /@
        decomposition["ResidueMatrices"]
    ),
    "waypoints_real" -> (
      XYZZPyFlintDecimalString[#1, boundaryWorkingPrecision] & /@
        waypointsT
    ),
    "initial_vector" -> (
      XYZZPyFlintComplexRecord[#1, boundaryWorkingPrecision] & /@
        N[boundaryHigh, boundaryWorkingPrecision]
    ),
    "initial_vector_lower" -> (
      XYZZPyFlintComplexRecord[#1, boundaryWorkingPrecision] & /@
        N[boundaryLow, boundaryWorkingPrecision]
    ),
    "metadata" -> <|
      "object" -> "three-vertex de Sitter correlator 25D E2 transport",
      "boundary" -> "true-infinity Frobenius germ at t=0",
      "signs" -> signs,
      "rules_no_E2" -> (ToString[#1, InputForm] & /@ rulesNoE2),
      "target_E2" -> ToString[e2End, InputForm],
      "waypoints_E2" -> (ToString[#1, InputForm] & /@ waypointsE2),
      "infinity_series_order" -> infinitySeriesOrder,
      "boundary_working_precision" -> boundaryWorkingPrecision,
      "boundary_relative_truncation" ->
        XYZZPyFlintDecimalString[boundaryTruncation, boundaryWorkingPrecision],
      "boundary_ode_relative_residual" ->
        XYZZPyFlintDecimalString[boundaryResidual, boundaryWorkingPrecision],
      "local_safety_factor_exact" ->
        XYZZPyFlintExactString[OptionValue["LocalSafetyFactor"]],
      "connection_exact_reconstruction" -> True
    |>
  |>;
  result = <|
    "Payload" -> payload,
    "BoundaryHigh" -> boundaryHigh,
    "BoundaryLow" -> boundaryLow,
    "BoundaryEstimatedRelativeTruncation" -> boundaryTruncation,
    "BoundaryODERelativeResidual" -> boundaryResidual,
    "WaypointsT" -> waypointsT,
    "WaypointsE2" -> waypointsE2,
    "PoleResidueData" -> decomposition
  |>;
  If[TrueQ[OptionValue["ReturnFrobeniusData"]],
    Append[result, "FrobeniusData" -> data],
    result
  ]
];

Options[XYZZExportE2PyFlintPayload] = Options[XYZZBuildE2PyFlintPayload];

XYZZExportE2PyFlintPayload[
  signs : {(_Integer)..},
  rules_List,
  e2End_?NumericQ,
  outputFile_String,
  OptionsPattern[]
] := Module[{built, exported},
  built = XYZZBuildE2PyFlintPayload[
    signs,
    rules,
    e2End,
    Sequence @@ Map[
      With[{key = First[#1]}, key -> OptionValue[key]] &,
      Options[XYZZBuildE2PyFlintPayload]
    ]
  ];
  If[!AssociationQ[built], Return[built]];
  exported = Quiet@Check[
    Export[outputFile, built["Payload"], "RawJSON"],
    $Failed
  ];
  If[exported === $Failed, Return[Failure[
    "PayloadExportFailed",
    <|"OutputFile" -> outputFile|>
  ]]];
  Join[built, <|"PayloadFile" -> ExpandFileName[outputFile]|>]
];

Options[XYZZRunE2PyFlintPayload] = {
  "PythonExecutable" -> Automatic,
  "PythonModule" -> Automatic,
  "WorkingPrecision" -> 60,
  "GuardBits" -> 32,
  "HighOrder" -> 60,
  "LowOrder" -> 58,
  "CompareOrderDrop" -> 2,
  "SafetyFraction" -> 1/2
};

XYZZRunE2PyFlintPayload[
  payloadFile_String,
  outputFile_String,
  OptionsPattern[]
] := Module[
  {pythonExecutable, pythonModule, command, process, imported},
  pythonExecutable = Replace[
    OptionValue["PythonExecutable"],
    Automatic :> If[
      StringLength[Environment["PYTHON"]] > 0,
      Environment["PYTHON"],
      "python"
    ]
  ];
  pythonModule = Replace[
    OptionValue["PythonModule"],
    Automatic :> FileNameJoin[{
      $XYZZPyFlintAdapterDirectory,
      "pyflint_e2_transport.py"
    }]
  ];
  If[!FileExistsQ[payloadFile], Return[Failure[
    "PayloadFileNotFound",
    <|"PayloadFile" -> payloadFile|>
  ]]];
  If[!FileExistsQ[pythonModule], Return[Failure[
    "PythonModuleNotFound",
    <|"PythonModule" -> pythonModule|>
  ]]];
  command = {
    pythonExecutable,
    pythonModule,
    "--input", ExpandFileName[payloadFile],
    "--output", ExpandFileName[outputFile],
    "--digits", ToString[OptionValue["WorkingPrecision"]],
    "--guard-bits", ToString[OptionValue["GuardBits"]],
    "--high-order", ToString[OptionValue["HighOrder"]],
    "--low-order", ToString[OptionValue["LowOrder"]],
    "--compare-order-drop", ToString[OptionValue["CompareOrderDrop"]],
    "--safety-fraction", XYZZPyFlintExactString[
      OptionValue["SafetyFraction"]
    ]
  };
  process = Quiet@Check[RunProcess[command], $Failed];
  If[process === $Failed, Return[Failure[
    "PythonProcessLaunchFailed",
    <|"Command" -> command|>
  ]]];
  If[process["ExitCode"] =!= 0, Return[Failure[
    "PythonProcessFailed",
    <|
      "ExitCode" -> process["ExitCode"],
      "StandardOutput" -> process["StandardOutput"],
      "StandardError" -> process["StandardError"],
      "InstallHint" ->
        "python -m pip install -r validation/requirements-pyflint.txt",
      "OutputFile" -> outputFile
    |>
  ]]];
  imported = Quiet@Check[Import[outputFile, "RawJSON"], $Failed];
  If[!AssociationQ[imported] || Lookup[imported, "status", ""] =!= "passed",
    Return[Failure[
      "PyFlintResultImportFailed",
      <|"OutputFile" -> outputFile, "Imported" -> imported|>
    ]]
  ];
  <|
    "Process" -> process,
    "Result" -> imported,
    "PayloadFile" -> ExpandFileName[payloadFile],
    "OutputFile" -> ExpandFileName[outputFile],
    "PythonModule" -> ExpandFileName[pythonModule]
  |>
];

Options[XYZZRunPyFlint25DPayload] = Options[XYZZRunE2PyFlintPayload];

XYZZRunPyFlint25DPayload[
  payloadFile_String,
  outputFile_String,
  OptionsPattern[]
] := XYZZRunE2PyFlintPayload[
  payloadFile,
  outputFile,
  Sequence @@ Map[
    With[{key = First[#1]}, key -> OptionValue[key]] &,
    Options[XYZZRunE2PyFlintPayload]
  ]
];

XYZZPyFlintParseDecimal[text_String] := ToExpression@StringReplace[
  text,
  RegularExpression["[eE]([+-]?[0-9]+)$"] -> "*^$1"
];

XYZZPyFlintResultVector[result_Association, key_String:"raw_boundary_25"] := Module[
  {records},
  records = Lookup[result, key, Missing["NotFound"]];
  If[MissingQ[records] || !ListQ[records], Return[$Failed]];
  N[
    XYZZPyFlintParseDecimal[#1["re"]] +
      I XYZZPyFlintParseDecimal[#1["im"]] & /@ records,
    Lookup[result, "working_precision_decimal_digits", 50]
  ]
];

Options[XYZZProjectRawOneVertexVectorPyFlint] = Join[
  Options[ProjectRawOneVertexVector],
  {
    "PythonExecutable" -> Automatic,
    "PythonModule" -> Automatic,
    "ArtifactDirectory" -> Automatic,
    "GuardBits" -> 32
  }
];

XYZZProjectRawOneVertexVectorPyFlint[
  power_?NumericQ,
  sign_Integer,
  energy_?NumericQ,
  legs : {___Association},
  OptionsPattern[]
] := Module[
  {wp, artifactDirectory, token, payloadFile, outputFile, payload,
    run, vector},
  wp = OptionValue["WorkingPrecision"];
  If[Length[legs] =!= 1, Return[Failure[
    "PyFlintOneVertexRequiresOneLeg",
    <|"LegCount" -> Length[legs]|>
  ]]];
  artifactDirectory = Replace[
    OptionValue["ArtifactDirectory"], Automatic :> $TemporaryDirectory
  ];
  If[!DirectoryQ[artifactDirectory],
    CreateDirectory[artifactDirectory, CreateIntermediateDirectories -> True]
  ];
  token = StringReplace[CreateUUID[], "-" -> ""];
  payloadFile = FileNameJoin[{
    artifactDirectory, "one_vertex_seed_" <> token <> "_input.json"
  }];
  outputFile = StringReplace[payloadFile, "_input.json" -> "_output.json"];
  payload = <|
    "schema" -> "three-vertex-one-leg-seed-v1",
    "operation" -> "one_vertex_seed",
    "request_id" -> "one_vertex_seed_" <> token,
    "power" -> XYZZPyFlintComplexRecord[power, wp],
    "sign" -> sign,
    "energy" -> XYZZPyFlintComplexRecord[energy, wp],
    "kind" -> legs[[1, "Kind"]],
    "nu" -> XYZZPyFlintComplexRecord[legs[[1, "Nu"]], wp],
    "momentum" -> XYZZPyFlintComplexRecord[legs[[1, "Momentum"]], wp]
  |>;
  Export[payloadFile, payload, "RawJSON"];
  run = XYZZRunPyFlint25DPayload[
    payloadFile,
    outputFile,
    "PythonExecutable" -> OptionValue["PythonExecutable"],
    "PythonModule" -> OptionValue["PythonModule"],
    "WorkingPrecision" -> wp,
    "GuardBits" -> OptionValue["GuardBits"],
    "HighOrder" -> 4,
    "LowOrder" -> 2,
    "CompareOrderDrop" -> 1,
    "SafetyFraction" -> 2/5
  ];
  If[!AssociationQ[run], Return[run]];
  vector = XYZZPyFlintResultVector[run["Result"], "raw_vector_2"];
  If[!VectorQ[vector, NumericQ] || Length[vector] =!= 2,
    Return[Failure[
      "PyFlintOneVertexVectorImportFailed",
      <|"OutputFile" -> outputFile|>
    ]]
  ];
  N[vector, wp]
];

Options[XYZZSolveProjectBranchE2PyFlintFromInfinity] = Join[
  Options[XYZZBuildE2PyFlintPayload],
  DeleteCases[
    Options[XYZZRunE2PyFlintPayload],
    "WorkingPrecision" -> _
  ]
];

XYZZSolveProjectBranchE2PyFlintFromInfinity[
  signs : {(_Integer)..},
  rules_List,
  e2End_?NumericQ,
  OptionsPattern[]
] := Module[
  {token, payloadFile, outputFile, built, run, pythonResult,
    rawBoundary, currentRules},
  token = StringReplace[CreateUUID[], "-" -> ""];
  payloadFile = FileNameJoin[{
    $TemporaryDirectory,
    "xyzz_e2_pyflint_" <> token <> "_input.json"
  }];
  outputFile = FileNameJoin[{
    $TemporaryDirectory,
    "xyzz_e2_pyflint_" <> token <> "_output.json"
  }];
  built = XYZZExportE2PyFlintPayload[
    signs,
    rules,
    e2End,
    payloadFile,
    Sequence @@ Map[
      With[{key = First[#1]}, key -> OptionValue[key]] &,
      Options[XYZZBuildE2PyFlintPayload]
    ]
  ];
  If[!AssociationQ[built], Return[built]];
  run = XYZZRunE2PyFlintPayload[
    payloadFile,
    outputFile,
    "WorkingPrecision" -> OptionValue["WorkingPrecision"],
    Sequence @@ Map[
      With[{key = First[#1]}, key -> OptionValue[key]] &,
      DeleteCases[
        Options[XYZZRunE2PyFlintPayload],
        "WorkingPrecision" -> _
      ]
    ]
  ];
  If[!AssociationQ[run], Return[run]];
  pythonResult = run["Result"];
  rawBoundary = XYZZPyFlintResultVector[pythonResult];
  If[rawBoundary === $Failed || Length[rawBoundary] =!= 25,
    Return[Failure[
      "PyFlintRawVectorImportFailed",
      <|"OutputFile" -> outputFile|>
    ]]
  ];
  currentRules = Join[DeleteCases[rules, E2 -> _], {E2 -> e2End}];
  <|
    "Signs" -> signs,
    "RawBoundary25" -> rawBoundary,
    "Rules" -> currentRules,
    "Segments" -> {
      <|
        "Variable" -> E2,
        "Range" -> {e2End, Infinity},
        "EvolutionVariable" -> "PyFlintAcbPatchwiseFromTrueInfinity",
        "TRange" -> {0, Last[built["WaypointsT"]]},
        "SeriesPatchT" -> First[built["WaypointsT"]],
        "SeriesPatchE2" -> First[built["WaypointsE2"]],
        "WaypointsT" -> built["WaypointsT"],
        "WaypointsE2" -> built["WaypointsE2"],
        "InfinitySeriesOrder" -> OptionValue["InfinitySeriesOrder"],
        "EstimatedInfinityBoundaryTruncation" ->
          built["BoundaryEstimatedRelativeTruncation"],
        "InfinitySeriesODERelativeResidual" ->
          built["BoundaryODERelativeResidual"],
        "LocalSeriesOrder" -> OptionValue["HighOrder"],
        "LocalReferenceOrder" -> OptionValue["LowOrder"],
        "LocalSeriesSegments" -> pythonResult["segments"],
        "FinalHighLowRelativeDelta" ->
          pythonResult["final_high_low_relative_delta_midpoint"],
        "BoundaryAtInfinityQ" -> True,
        "AutomaticODESolverUsedQ" -> False,
        "SystemBasis" -> "Raw"
      |>
    },
    "WorkingPrecision" -> OptionValue["WorkingPrecision"],
    "BoundaryAtInfinityQ" -> True,
    "PythonResult" -> pythonResult,
    "PayloadFile" -> run["PayloadFile"],
    "OutputFile" -> run["OutputFile"]
  |>
];

$HistoryLength = 0;

ClearAll[
  XYZZSharedBoundaryRelativeDelta,
  XYZZSolveProjectBranchE2PyFlintSharedOrders
];

XYZZSharedBoundaryRelativeDelta[x_List, y_List, wp_Integer] := N[
  Norm[x - y]/Max[Norm[x], 10^-100],
  wp
];

Options[XYZZSolveProjectBranchE2PyFlintSharedOrders] = {
  "WorkingPrecision" -> 80,
  "AccuracyGoal" -> 45,
  "PrecisionGoal" -> 45,
  "BoundaryGuardDigits" -> 20,
  "BoundaryAccuracyGoal" -> 35,
  "HighInfinitySeriesOrder" -> 14,
  "LowInfinitySeriesOrder" -> 12,
  "SeriesStartT" -> Automatic,
  "SeriesSafetyFactor" -> 1/20,
  "MaxSeriesHalvings" -> 20,
  "BoundaryMaxRecursion" -> 14,
  "BoundaryCutoff" -> 35,
  "BoundaryLowerCutoff" -> 10^-8,
  "OuterVertexEvaluation" -> "Direct",
  "OuterVertexSeriesOrder" -> 16,
  "LocalHighOrder" -> 72,
  "LocalLowOrder" -> 70,
  "LocalCompareOrderDrop" -> 2,
  "LocalSafetyFactor" -> 2/5,
  "GuardBits" -> 32,
  "PythonExecutable" -> Automatic,
  "ArtifactDirectory" -> Automatic
};

XYZZSolveProjectBranchE2PyFlintSharedOrders[
  signs : {(_Integer) ..},
  rules_List,
  e2End_?NumericQ,
  OptionsPattern[]
] := Module[
  {wp, boundaryWP, boundaryGoal, highOrder, lowOrder,
    rulesNoE2, tEnd, scaleValues, scale, tStart, maxHalvings,
    tolerance, halvings, data, dataSeconds, boundarySeconds,
    high, highPrevious, low, lowPrevious, highTruncation,
    lowTruncation, highLowAtPatch, highSeriesResidual,
    lowSeriesResidual, waypoints, tag, token, artifactDirectory,
    payloadFile, outputFile, built, payloadSeconds, exportSeconds,
    run, pyFlintWallSeconds, pyResult, rawHigh, rawLow,
    currentRules, segments, maximumHighODEResidual,
    maximumLowODEResidual, maximumLocalTruncation,
    finalHighLow, pythonExecutable, result},
  wp = OptionValue["WorkingPrecision"];
  boundaryWP = wp + OptionValue["BoundaryGuardDigits"];
  boundaryGoal = OptionValue["BoundaryAccuracyGoal"];
  highOrder = OptionValue["HighInfinitySeriesOrder"];
  lowOrder = OptionValue["LowInfinitySeriesOrder"];
  If[!IntegerQ[highOrder] || !IntegerQ[lowOrder] ||
      !(highOrder > lowOrder >= 1),
    Return[Failure[
      "BadSharedInfinityOrders",
      <|"HighOrder" -> highOrder, "LowOrder" -> lowOrder|>
    ]]
  ];
  If[!And @@ (NameQ /@ {
      "XYZZProjectE2InfinityFrobeniusData",
      "XYZZProjectE2InfinityEvaluate",
      "XYZZProjectE2InfinitySeriesResidual",
      "XYZZBuildPyFlint25DPayload",
      "XYZZRunPyFlint25DPayload"
    }),
    Return[Failure["SharedBoundaryAPIUnavailable", <||>]]
  ];
  rulesNoE2 = DeleteCases[rules, E2 -> _];
  tEnd = N[1/e2End, boundaryWP];
  scaleValues = N[Abs[{E1, E3, s1, s2} /. rulesNoE2], boundaryWP];
  If[!TrueQ[tEnd > 0] || !VectorQ[scaleValues, NumericQ],
    Return[Failure["BadSharedBoundaryKinematics", <||>]]
  ];
  scale = Max[1, Sequence @@ scaleValues];
  tStart = If[
    OptionValue["SeriesStartT"] === Automatic,
    Min[tEnd, N[OptionValue["SeriesSafetyFactor"]/scale, boundaryWP]],
    Min[tEnd, N[OptionValue["SeriesStartT"], boundaryWP]]
  ];
  If[!TrueQ[0 < tStart <= tEnd],
    Return[Failure["BadSharedBoundaryStart", <|"TStart" -> tStart|>]]
  ];
  dataSeconds = First@AbsoluteTiming[
    data = XYZZProjectE2InfinityFrobeniusData[
      signs,
      rulesNoE2,
      "WorkingPrecision" -> boundaryWP,
      "SeriesOrder" -> highOrder,
      "AccuracyGoal" -> Min[
        boundaryWP - 10,
        Max[
          boundaryGoal + 10,
          OptionValue["AccuracyGoal"] + 10,
          OptionValue["PrecisionGoal"] + 10
        ]
      ],
      "PrecisionGoal" -> Min[
        boundaryWP - 10,
        Max[
          boundaryGoal + 10,
          OptionValue["AccuracyGoal"] + 10,
          OptionValue["PrecisionGoal"] + 10
        ]
      ],
      "MaxRecursion" -> OptionValue["BoundaryMaxRecursion"],
      "Cutoff" -> OptionValue["BoundaryCutoff"],
      "LowerCutoff" -> OptionValue["BoundaryLowerCutoff"],
      "OuterVertexEvaluation" -> OptionValue["OuterVertexEvaluation"],
      "OuterVertexSeriesOrder" -> OptionValue["OuterVertexSeriesOrder"]
    ];
  ];
  If[!AssociationQ[data],
    Return[Failure["SharedFrobeniusDataFailed", <|"Signs" -> signs|>]]
  ];
  tolerance = N[10^-boundaryGoal, boundaryWP];
  maxHalvings = OptionValue["MaxSeriesHalvings"];
  halvings = 0;
  boundarySeconds = First@AbsoluteTiming[
    high = XYZZProjectE2InfinityEvaluate[data, tStart, highOrder];
    highPrevious = XYZZProjectE2InfinityEvaluate[
      data, tStart, highOrder - 1
    ];
    low = XYZZProjectE2InfinityEvaluate[data, tStart, lowOrder];
    lowPrevious = XYZZProjectE2InfinityEvaluate[
      data, tStart, lowOrder - 1
    ];
    highTruncation = XYZZSharedBoundaryRelativeDelta[
      high, highPrevious, boundaryWP
    ];
    lowTruncation = XYZZSharedBoundaryRelativeDelta[
      low, lowPrevious, boundaryWP
    ];
    While[
      Max[highTruncation, lowTruncation] > tolerance &&
        halvings < maxHalvings,
      tStart = tStart/2;
      halvings++;
      high = XYZZProjectE2InfinityEvaluate[data, tStart, highOrder];
      highPrevious = XYZZProjectE2InfinityEvaluate[
        data, tStart, highOrder - 1
      ];
      low = XYZZProjectE2InfinityEvaluate[data, tStart, lowOrder];
      lowPrevious = XYZZProjectE2InfinityEvaluate[
        data, tStart, lowOrder - 1
      ];
      highTruncation = XYZZSharedBoundaryRelativeDelta[
        high, highPrevious, boundaryWP
      ];
      lowTruncation = XYZZSharedBoundaryRelativeDelta[
        low, lowPrevious, boundaryWP
      ];
    ];
    highLowAtPatch = XYZZSharedBoundaryRelativeDelta[
      high, low, boundaryWP
    ];
    highSeriesResidual = XYZZProjectE2InfinitySeriesResidual[
      data, tStart, highOrder
    ];
    lowSeriesResidual = XYZZProjectE2InfinitySeriesResidual[
      data, tStart, lowOrder
    ];
  ];
  If[Max[highTruncation, lowTruncation] > tolerance,
    Return[Failure[
      "SharedInfinityBoundaryTruncationNotMet",
      <|
        "HighTruncation" -> highTruncation,
        "LowTruncation" -> lowTruncation,
        "Tolerance" -> tolerance,
        "TStart" -> tStart
      |>
    ]]
  ];
  waypoints = XYZZPatchwiseAutomaticWaypoints[
    N[tStart, boundaryWP],
    N[tEnd, boundaryWP],
    OptionValue["LocalSafetyFactor"]
  ];
  If[!ListQ[waypoints] || Length[waypoints] < 2,
    Return[Failure["SharedBoundaryWaypointsFailed", <||>]]
  ];
  tag = StringJoin[If[#1 == 1, "p", "m"] & /@ signs];
  token = StringReplace[CreateUUID[], "-" -> ""];
  artifactDirectory = Replace[
    OptionValue["ArtifactDirectory"],
    Automatic :> $TemporaryDirectory
  ];
  If[!DirectoryQ[artifactDirectory],
    CreateDirectory[artifactDirectory, CreateIntermediateDirectories -> True]
  ];
  payloadFile = FileNameJoin[{
    artifactDirectory, "boundary_" <> tag <> "_" <> token <> "_input.json"
  }];
  outputFile = FileNameJoin[{
    artifactDirectory, "boundary_" <> tag <> "_" <> token <> "_output.json"
  }];
  payloadSeconds = First@AbsoluteTiming[
    built = XYZZBuildPyFlint25DPayload[
      "three_vertex_shared_boundary_" <> tag,
      data["ConnectionExpression"],
      data["SeriesVariable"],
      waypoints,
      N[high, boundaryWP],
      N[low, boundaryWP],
      <|
        "object" -> "three-vertex 25D true-infinity shared boundary",
        "boundary" -> "Frobenius germ at t=0",
        "signs" -> signs,
        "target_E2" -> ToString[e2End, InputForm],
        "high_infinity_series_order" -> highOrder,
        "low_infinity_series_order" -> lowOrder,
        "shared_frobenius_data" -> True,
        "series_patch_t" -> ToString[tStart, InputForm]
      |>,
      "WorkingPrecision" -> boundaryWP,
      "EvolutionVariable" -> "t=1/E2"
    ];
  ];
  If[!AssociationQ[built], Return[built]];
  exportSeconds = First@AbsoluteTiming[
    Export[payloadFile, built["Payload"], "RawJSON"];
  ];
  pythonExecutable = OptionValue["PythonExecutable"];
  pyFlintWallSeconds = First@AbsoluteTiming[
    run = XYZZRunPyFlint25DPayload[
      payloadFile,
      outputFile,
      "PythonExecutable" -> pythonExecutable,
      "WorkingPrecision" -> wp,
      "GuardBits" -> OptionValue["GuardBits"],
      "HighOrder" -> OptionValue["LocalHighOrder"],
      "LowOrder" -> OptionValue["LocalLowOrder"],
      "CompareOrderDrop" -> OptionValue["LocalCompareOrderDrop"],
      "SafetyFraction" -> OptionValue["LocalSafetyFactor"]
    ];
  ];
  If[!AssociationQ[run], Return[run]];
  pyResult = run["Result"];
  rawHigh = XYZZPyFlintResultVector[pyResult, "raw_boundary_25"];
  rawLow = XYZZPyFlintResultVector[
    pyResult, "raw_boundary_25_low_order"
  ];
  If[!VectorQ[rawHigh, NumericQ] || !VectorQ[rawLow, NumericQ] ||
      Length[rawHigh] =!= 25 || Length[rawLow] =!= 25,
    Return[Failure["SharedBoundaryPyFlintVectorFailed", <||>]]
  ];
  segments = pyResult["segments"];
  maximumHighODEResidual = Max[
    Lookup[Lookup[segments, "high"],
      "endpoint_ode_relative_residual_midpoint"]
  ];
  maximumLowODEResidual = Max[
    Lookup[Lookup[segments, "low"],
      "endpoint_ode_relative_residual_midpoint"]
  ];
  maximumLocalTruncation = Max[
    Join[
      Lookup[Lookup[segments, "high"],
        "estimated_relative_truncation_midpoint"],
      Lookup[Lookup[segments, "low"],
        "estimated_relative_truncation_midpoint"]
    ]
  ];
  finalHighLow = pyResult["final_high_low_relative_delta_midpoint"];
  currentRules = Join[rulesNoE2, {E2 -> e2End}];
  result = <|
    "Signs" -> signs,
    "RawBoundary25" -> rawHigh,
    "RawBoundary25LowOrder" -> rawLow,
    "Rules" -> currentRules,
    "SharedFrobeniusDataQ" -> True,
    "AutomaticODESolverUsedQ" -> False,
    "InfinityOrders" -> {highOrder, lowOrder},
    "LocalOrders" -> {
      OptionValue["LocalHighOrder"], OptionValue["LocalLowOrder"]
    },
    "SeriesPatchT" -> tStart,
    "SeriesPatchE2" -> 1/tStart,
    "SeriesHalvings" -> halvings,
    "WaypointCount" -> Length[waypoints],
    "WaypointsT" -> waypoints,
    "HighEstimatedInfinityTruncation" -> highTruncation,
    "LowEstimatedInfinityTruncation" -> lowTruncation,
    "HighLowRelativeDeltaAtSeriesPatch" -> highLowAtPatch,
    "HighInfinitySeriesODERelativeResidual" -> highSeriesResidual,
    "LowInfinitySeriesODERelativeResidual" -> lowSeriesResidual,
    "MaximumPyFlintHighEndpointODERelativeResidual" ->
      maximumHighODEResidual,
    "MaximumPyFlintLowEndpointODERelativeResidual" ->
      maximumLowODEResidual,
    "MaximumPyFlintEstimatedLocalTruncation" ->
      maximumLocalTruncation,
    "FinalHighLowRelativeDelta" -> finalHighLow,
    "Timings" -> <|
      "SharedFrobeniusAndConnectionSeconds" -> dataSeconds,
      "SharedBoundaryEvaluationSeconds" -> boundarySeconds,
      "PayloadBuildSeconds" -> payloadSeconds,
      "PayloadExportSeconds" -> exportSeconds,
      "PyFlintProcessWallSeconds" -> pyFlintWallSeconds,
      "PyFlintKernelSeconds" -> pyResult["elapsed_seconds"],
      "BranchTotalSeconds" -> Total[{
        dataSeconds, boundarySeconds, payloadSeconds,
        exportSeconds, pyFlintWallSeconds
      }]
    |>,
    "PayloadFile" -> payloadFile,
    "OutputFile" -> outputFile,
    "PythonResult" -> KeyDrop[pyResult, {
      "raw_boundary_25", "raw_boundary_25_low_order"
    }]
  |>;
  result
];


$HistoryLength = 0;

(* V5.5 boundary construction.  Exact E2 pole/residue data are transformed
   algebraically to t=1/E2.  The one-leg physical Hankel seeds are evaluated
   by their Gamma-2F1 Laplace transforms and the indicial/recurrence solves are
   delegated to python-flint.  SK phases, pinch normalizations, the raw basis,
   and the Top/LeftPinch/RightPinch/DoublePinch order are unchanged. *)

ClearAll[
  XYZZClearInfinityBoundaryCaches,
  XYZZProjectInitializeInfinityOuterVertexCache,
  XYZZProjectRawOneVertexVectorUncached,
  XYZZProjectRawOneVertexVectorCached,
  XYZZProjectRawOneVertexVectorPyFlintCached,
  XYZZProjectE2InfinityPoleResidueData,
  XYZZProjectE2InfinityFrobeniusSeedRecords,
  XYZZBuildProjectE2InfinityPyFlintPayload,
  XYZZSolveProjectBranchE2PyFlintFrobenius
];

XYZZClearInfinityBoundaryCaches[] := (
  $XYZZInfinityOuterVertexCache = <||>;
  $XYZZInfinityPhysicalSeedCache = <||>;
  $XYZZInfinityOuterVertexCacheStats = <|
    "Hits" -> 0, "Misses" -> 0, "UncachedEvaluationSeconds" -> 0.
  |>;
  True
);

If[!AssociationQ[$XYZZInfinityOuterVertexCache],
  $XYZZInfinityOuterVertexCache = <||>
];
If[!AssociationQ[$XYZZInfinityOuterVertexCacheStats],
  $XYZZInfinityOuterVertexCacheStats = <|
    "Hits" -> 0, "Misses" -> 0, "UncachedEvaluationSeconds" -> 0.
  |>
];
If[!AssociationQ[$XYZZInfinityPhysicalSeedCache],
  $XYZZInfinityPhysicalSeedCache = <||>
];

XYZZProjectInitializeInfinityOuterVertexCache[] := Module[{rules},
  If[DownValues[XYZZProjectRawOneVertexVectorUncached] =!= {}, Return[True]];
  If[!NameQ["ProjectRawOneVertexVector"] ||
      DownValues[ProjectRawOneVertexVector] === {}, Return[False]];
  rules = DownValues[ProjectRawOneVertexVector] /.
    ProjectRawOneVertexVector -> XYZZProjectRawOneVertexVectorUncached;
  DownValues[XYZZProjectRawOneVertexVectorUncached] = rules;
  Options[XYZZProjectRawOneVertexVectorUncached] =
    Options[ProjectRawOneVertexVector];
  Options[XYZZProjectRawOneVertexVectorCached] =
    Options[ProjectRawOneVertexVector];
  True
];

XYZZProjectRawOneVertexVectorCached[
  power_?NumericQ,
  sign_Integer,
  energy_?NumericQ,
  legs : {___Association},
  OptionsPattern[]
] := Module[{key, value, seconds},
  key = ToString[
    HoldComplete[
      N[power, OptionValue["WorkingPrecision"]], sign,
      N[energy, OptionValue["WorkingPrecision"]],
      N[legs, OptionValue["WorkingPrecision"]],
      "DirectNIntegrate",
      OptionValue["WorkingPrecision"], OptionValue["AccuracyGoal"],
      OptionValue["PrecisionGoal"], OptionValue["MaxRecursion"]
    ],
    InputForm
  ];
  If[KeyExistsQ[$XYZZInfinityOuterVertexCache, key],
    $XYZZInfinityOuterVertexCacheStats["Hits"]++;
    Return[$XYZZInfinityOuterVertexCache[key]]
  ];
  seconds = First@AbsoluteTiming[
    value = XYZZProjectRawOneVertexVectorUncached[
      power, sign, energy, legs,
      "WorkingPrecision" -> OptionValue["WorkingPrecision"],
      "AccuracyGoal" -> OptionValue["AccuracyGoal"],
      "PrecisionGoal" -> OptionValue["PrecisionGoal"],
      "MaxRecursion" -> OptionValue["MaxRecursion"],
      "Cutoff" -> OptionValue["Cutoff"],
      "LowerCutoff" -> OptionValue["LowerCutoff"]
    ];
  ];
  If[value === $Failed, Return[$Failed]];
  AssociateTo[$XYZZInfinityOuterVertexCache, key -> value];
  $XYZZInfinityOuterVertexCacheStats["Misses"]++;
  $XYZZInfinityOuterVertexCacheStats["UncachedEvaluationSeconds"] += seconds;
  value
];

Options[XYZZProjectRawOneVertexVectorPyFlintCached] =
  Options[ProjectRawOneVertexVector];

XYZZProjectRawOneVertexVectorPyFlintCached[
  power_?NumericQ,
  sign_Integer,
  energy_?NumericQ,
  legs : {___Association},
  OptionsPattern[]
] := Module[{key, value, seconds},
  key = ToString[
    HoldComplete[
      N[power, OptionValue["WorkingPrecision"]], sign,
      N[energy, OptionValue["WorkingPrecision"]],
      N[legs, OptionValue["WorkingPrecision"]],
      "PyFlintGamma2F1",
      OptionValue["WorkingPrecision"],
      $XYZZInfinityOuterVertexPythonExecutable,
      $XYZZInfinityOuterVertexPythonModule
    ],
    InputForm
  ];
  If[KeyExistsQ[$XYZZInfinityOuterVertexCache, key],
    $XYZZInfinityOuterVertexCacheStats["Hits"]++;
    Return[$XYZZInfinityOuterVertexCache[key]]
  ];
  seconds = First@AbsoluteTiming[
    value = XYZZProjectRawOneVertexVectorPyFlint[
      power, sign, energy, legs,
      "WorkingPrecision" -> OptionValue["WorkingPrecision"],
      "AccuracyGoal" -> OptionValue["AccuracyGoal"],
      "PrecisionGoal" -> OptionValue["PrecisionGoal"],
      "MaxRecursion" -> OptionValue["MaxRecursion"],
      "Cutoff" -> OptionValue["Cutoff"],
      "LowerCutoff" -> OptionValue["LowerCutoff"],
      "PythonExecutable" -> $XYZZInfinityOuterVertexPythonExecutable,
      "PythonModule" -> $XYZZInfinityOuterVertexPythonModule,
      "ArtifactDirectory" -> $XYZZInfinityOuterVertexArtifactDirectory,
      "GuardBits" -> $XYZZInfinityOuterVertexGuardBits
    ];
  ];
  If[value === $Failed || Head[value] === Failure, Return[value]];
  AssociateTo[$XYZZInfinityOuterVertexCache, key -> value];
  $XYZZInfinityOuterVertexCacheStats["Misses"]++;
  $XYZZInfinityOuterVertexCacheStats["UncachedEvaluationSeconds"] += seconds;
  value
];

XYZZProjectE2InfinityPoleResidueData[
  signs : {(_Integer) ..},
  rules_List
] := Module[
  {rulesNoE2, matrixExpression, matrixSeconds, decomposition,
    decompositionSeconds, constantZeroQ, e2Poles, e2Residues,
    zeroResidue, nonzeroIndices, tPoles, tResidues, transformSeconds},
  If[!And @@ (NameQ /@ {
      "XYZZLoadProjectCore",
      "XYZZProjectRawBranchMatrixForVariable",
      "XYZZPyFlintPoleResidueData"
    }), Return[Failure["InfinityPoleResidueAPIUnavailable", <||>]]];
  If[!TrueQ[XYZZLoadProjectCore[]], Return[Failure[
    "InfinityProjectCoreLoadFailed", <|"Signs" -> signs|>
  ]]];
  rulesNoE2 = DeleteCases[rules, E2 -> _];
  matrixSeconds = First@AbsoluteTiming[
    matrixExpression =
      XYZZProjectRawBranchMatrixForVariable[signs, E2] /. rulesNoE2;
  ];
  If[Dimensions[matrixExpression] =!= {25, 25}, Return[Failure[
    "BadE2ConnectionShape",
    <|"Dimensions" -> Dimensions[matrixExpression]|>
  ]]];
  decompositionSeconds = First@AbsoluteTiming[
    decomposition = XYZZPyFlintPoleResidueData[matrixExpression, E2];
  ];
  If[!AssociationQ[decomposition], Return[decomposition]];
  constantZeroQ = And @@ Flatten@Map[
    TrueQ[PossibleZeroQ[#1]] &,
    decomposition["ConstantMatrix"],
    {2}
  ];
  If[!constantZeroQ, Return[Failure[
    "IrregularInfinityConstantPart",
    <|"ConstantMatrix" -> decomposition["ConstantMatrix"]|>
  ]]];
  transformSeconds = First@AbsoluteTiming[
    e2Poles = decomposition["Poles"];
    e2Residues = decomposition["ResidueMatrices"];
    zeroResidue = -Total[e2Residues];
    nonzeroIndices = Select[
      Range[Length[e2Poles]],
      !TrueQ[PossibleZeroQ[e2Poles[[#1]]]] &
    ];
    tPoles = Join[{0}, (1/e2Poles[[#1]] &) /@ nonzeroIndices];
    tResidues = Join[{zeroResidue}, e2Residues[[nonzeroIndices]]];
  ];
  <|
    "RulesNoE2" -> rulesNoE2,
    "E2ConnectionExpression" -> matrixExpression,
    "E2PoleResidueData" -> decomposition,
    "TPoles" -> tPoles,
    "TConstantMatrix" -> ConstantArray[0, {25, 25}],
    "TResidueMatrices" -> tResidues,
    "TResidueAtZero" -> zeroResidue,
    "ExactTransformation" ->
      "A(t)=-M(1/t)/t^2; R0=-Sum[Bj]; pole 1/aj has residue Bj",
    "Timings" -> <|
      "ExactE2ConnectionMatrixSeconds" -> matrixSeconds,
      "E2PoleResidueDecompositionSeconds" -> decompositionSeconds,
      "E2ToTAlgebraicTransformSeconds" -> transformSeconds
    |>
  |>
];

XYZZProjectE2InfinityFrobeniusSeedRecords[
  signs : {(_Integer) ..},
  rules_List,
  workingPrecision_Integer?Positive,
  options_Association
] := Module[{seedKey, cached, seeds, seconds, records, result},
  If[!TrueQ[XYZZProjectInitializeInfinityOuterVertexCache[]],
    Return[Failure["OuterVertexCacheInitializationFailed", <||>]]
  ];
  seedKey = ToString[
    HoldComplete[signs, N[rules, workingPrecision], workingPrecision, options],
    InputForm
  ];
  If[KeyExistsQ[$XYZZInfinityPhysicalSeedCache, seedKey],
    cached = $XYZZInfinityPhysicalSeedCache[seedKey];
    Return@Join[
      cached,
      <|
        "PhysicalSeedConstructionSeconds" -> 0.,
        "PhysicalSeedCacheHitQ" -> True,
        "OuterVertexCacheStats" ->
          Association[$XYZZInfinityOuterVertexCacheStats],
        "OuterVertexCacheEntryCount" ->
          Length[$XYZZInfinityOuterVertexCache]
      |>
    ]
  ];
  seconds = First@AbsoluteTiming[
    seeds = Block[
      {
        ProjectRawOneVertexVector = If[
          options["OuterVertexEvaluation"] === "PyFlint",
          XYZZProjectRawOneVertexVectorPyFlintCached,
          XYZZProjectRawOneVertexVectorCached
        ],
        $XYZZInfinityOuterVertexPythonExecutable =
          Lookup[options, "PythonExecutable", Automatic],
        $XYZZInfinityOuterVertexPythonModule =
          Lookup[options, "PythonModule", Automatic],
        $XYZZInfinityOuterVertexArtifactDirectory =
          Lookup[options, "ArtifactDirectory", Automatic],
        $XYZZInfinityOuterVertexGuardBits =
          Lookup[options, "GuardBits", 32]
      },
      XYZZProjectE2InfinitySectorSeeds[
        signs,
        rules,
        "WorkingPrecision" -> workingPrecision,
        "AccuracyGoal" -> options["AccuracyGoal"],
        "PrecisionGoal" -> options["PrecisionGoal"],
        "MaxRecursion" -> options["MaxRecursion"],
        "Cutoff" -> options["Cutoff"],
        "LowerCutoff" -> options["LowerCutoff"],
        "OuterVertexEvaluation" -> If[
          options["OuterVertexEvaluation"] === "PyFlint",
          "Direct",
          options["OuterVertexEvaluation"]
        ],
        "OuterVertexSeriesOrder" -> options["OuterVertexSeriesOrder"]
      ]
    ];
  ];
  If[!ListQ[seeds] || seeds === {}, Return[Failure[
    "InfinityPhysicalSeedConstructionFailed",
    <|"Signs" -> signs|>
  ]]];
  records = Map[
    <|
      "sector" -> #1["Sector"],
      "state" -> #1["State"],
      "exponent" -> XYZZPyFlintComplexRecord[
        #1["Exponent"], workingPrecision
      ],
      "exponent_group" -> StringJoin[
        XYZZPyFlintDecimalString[
          Re[N[#1["Exponent"], workingPrecision]], workingPrecision
        ],
        "+I*",
        XYZZPyFlintDecimalString[
          Im[N[#1["Exponent"], workingPrecision]], workingPrecision
        ]
      ],
      "sector_vector" -> (
        XYZZPyFlintComplexRecord[#1, workingPrecision] & /@
          N[#1["SectorVector"], workingPrecision]
      )
    |> &,
    seeds
  ];
  result = <|
    "Seeds" -> seeds,
    "Records" -> records,
    "SeedCount" -> Length[records],
    "PhysicalSeedConstructionSeconds" -> seconds,
    "PhysicalSeedCacheHitQ" -> False,
    "OuterVertexCacheStats" -> Association[$XYZZInfinityOuterVertexCacheStats],
    "OuterVertexCacheEntryCount" -> Length[$XYZZInfinityOuterVertexCache]
  |>;
  AssociateTo[
    $XYZZInfinityPhysicalSeedCache,
    seedKey -> KeyTake[result, {"Seeds", "Records", "SeedCount"}]
  ];
  result
];

XYZZBuildProjectE2InfinityPyFlintPayload[
  requestId_String,
  poleData_Association,
  seedData_Association,
  tStart_?NumericQ,
  highOrder_Integer?Positive,
  lowOrder_Integer?Positive,
  waypoints_List,
  workingPrecision_Integer?Positive,
  metadata_Association,
  frobeniusOnly_:False
] := Module[{payload},
  If[!(highOrder > lowOrder >= 1), Return[Failure[
    "BadInfinityOrders",
    <|"HighOrder" -> highOrder, "LowOrder" -> lowOrder|>
  ]]];
  payload = <|
    "schema" -> "xyzz-25d-pyflint-frobenius-v1",
    "request_id" -> requestId,
    "dimension" -> 25,
    "equation_orientation" -> "column",
    "evolution_variable" -> "t=1/E2",
    "basis" -> "Raw",
    "basis_order" -> {
      "Top:16", "LeftPinch:4", "RightPinch:4", "DoublePinch:1"
    },
    "taylor_recurrence" -> "pole_state",
    "poles_exact" -> (
      XYZZPyFlintExactString /@ poleData["TPoles"]
    ),
    "constant_matrix_exact" -> XYZZPyFlintExactMatrixRecords[
      poleData["TConstantMatrix"]
    ],
    "residue_matrices_exact" -> (
      XYZZPyFlintExactMatrixRecords /@ poleData["TResidueMatrices"]
    ),
    "frobenius_evaluation_point" ->
      XYZZPyFlintComplexRecord[tStart, workingPrecision],
    "frobenius_high_order" -> highOrder,
    "frobenius_low_order" -> lowOrder,
    "frobenius_seeds" -> seedData["Records"],
    "frobenius_only" -> TrueQ[frobeniusOnly],
    "return_patch_data" -> False,
    "metadata" -> Join[
      <|
        "boundary" ->
          "Frobenius germ from project physical seeds and exact pole residues",
        "working_precision" -> workingPrecision,
        "physical_seed_count" -> seedData["SeedCount"],
        "connection_exact_reconstruction" -> True
      |>,
      metadata
    ]
  |>;
  If[!TrueQ[frobeniusOnly],
    If[Length[waypoints] < 2, Return[Failure[
      "BadInfinityWaypoints", <|"Waypoints" -> waypoints|>
    ]]];
    AssociateTo[
      payload,
      "waypoints_complex" -> (
        XYZZPyFlintComplexRecord[#1, workingPrecision] & /@ waypoints
      )
    ];
  ];
  payload
];

Options[XYZZSolveProjectBranchE2PyFlintFrobenius] = {
  "WorkingPrecision" -> 80,
  "AccuracyGoal" -> 45,
  "PrecisionGoal" -> 45,
  "BoundaryGuardDigits" -> 20,
  "BoundaryAccuracyGoal" -> 35,
  "HighInfinitySeriesOrder" -> 14,
  "LowInfinitySeriesOrder" -> 12,
  "SeriesStartT" -> Automatic,
  (* A conservative scale-aware first probe.  If a different parameter point
     still fails the requested Frobenius tolerance, the halving loop below
     remains active. *)
  "SeriesSafetyFactor" -> 1/320,
  "MaxSeriesHalvings" -> 20,
  "BoundaryMaxRecursion" -> 14,
  "BoundaryCutoff" -> 35,
  "BoundaryLowerCutoff" -> 10^-8,
  "OuterVertexEvaluation" -> "PyFlint",
  "OuterVertexSeriesOrder" -> 16,
  "LocalHighOrder" -> 72,
  "LocalLowOrder" -> 70,
  "LocalCompareOrderDrop" -> 2,
  "LocalSafetyFactor" -> 2/5,
  "GuardBits" -> 32,
  "PythonExecutable" -> Automatic,
  "ArtifactDirectory" -> Automatic
};

XYZZSolveProjectBranchE2PyFlintFrobenius[
  signs : {(_Integer) ..},
  rules_List,
  e2End_?NumericQ,
  OptionsPattern[]
] := Module[
  {wp, boundaryWP, boundaryGoal, highOrder, lowOrder, rulesNoE2,
    tEnd, scaleValues, scale, tStart, tolerance, maxHalvings,
    halvings, poleData, seedOptions, seedData, tag, token,
    artifactDirectory, pythonExecutable, probePayloadFile,
    probeOutputFile, probePayload, probeRun, probeResult,
    probePayloadSeconds = 0, probeExportSeconds = 0,
    probeProcessSeconds = 0, highTruncation, lowTruncation,
    attemptPayloadSeconds, attemptExportSeconds, attemptProcessSeconds,
    accepted, waypoints, payloadFile, outputFile, payload,
    payloadSeconds, exportSeconds, run, pyFlintWallSeconds,
    pyResult, rawHigh, rawLow, segments, maximumHighODEResidual,
    maximumLowODEResidual, maximumLocalTruncation, finalHighLow,
    frobenius, result, totalSeconds},
  totalSeconds = AbsoluteTime[];
  wp = OptionValue["WorkingPrecision"];
  boundaryWP = wp + OptionValue["BoundaryGuardDigits"];
  boundaryGoal = OptionValue["BoundaryAccuracyGoal"];
  highOrder = OptionValue["HighInfinitySeriesOrder"];
  lowOrder = OptionValue["LowInfinitySeriesOrder"];
  If[!IntegerQ[highOrder] || !IntegerQ[lowOrder] ||
      !(highOrder > lowOrder >= 1), Return[Failure[
    "BadInfinityOrders",
    <|"HighOrder" -> highOrder, "LowOrder" -> lowOrder|>
  ]]];
  rulesNoE2 = DeleteCases[rules, E2 -> _];
  tEnd = N[1/e2End, boundaryWP];
  scaleValues = N[Abs[{E1, E3, s1, s2} /. rulesNoE2], boundaryWP];
  If[!TrueQ[tEnd > 0] || !VectorQ[scaleValues, NumericQ],
    Return[Failure["BadInfinityKinematics", <||>]]
  ];
  scale = Max[1, Sequence @@ scaleValues];
  tStart = If[
    OptionValue["SeriesStartT"] === Automatic,
    Min[tEnd, N[OptionValue["SeriesSafetyFactor"]/scale, boundaryWP]],
    Min[tEnd, N[OptionValue["SeriesStartT"], boundaryWP]]
  ];
  tolerance = N[10^-boundaryGoal, boundaryWP];
  maxHalvings = OptionValue["MaxSeriesHalvings"];
  If[!TrueQ[0 < tStart <= tEnd], Return[Failure[
    "BadInfinitySeriesStart", <|"TStart" -> tStart|>
  ]]];

  poleData = XYZZProjectE2InfinityPoleResidueData[signs, rulesNoE2];
  If[!AssociationQ[poleData], Return[poleData]];
  seedOptions = <|
    "AccuracyGoal" -> Min[
      boundaryWP - 10,
      Max[boundaryGoal + 10, OptionValue["AccuracyGoal"] + 10]
    ],
    "PrecisionGoal" -> Min[
      boundaryWP - 10,
      Max[boundaryGoal + 10, OptionValue["PrecisionGoal"] + 10]
    ],
    "MaxRecursion" -> OptionValue["BoundaryMaxRecursion"],
    "Cutoff" -> OptionValue["BoundaryCutoff"],
    "LowerCutoff" -> OptionValue["BoundaryLowerCutoff"],
    "OuterVertexEvaluation" -> OptionValue["OuterVertexEvaluation"],
    "OuterVertexSeriesOrder" -> OptionValue["OuterVertexSeriesOrder"],
    "PythonExecutable" -> OptionValue["PythonExecutable"],
    "PythonModule" -> Automatic,
    "ArtifactDirectory" -> Replace[
      OptionValue["ArtifactDirectory"], Automatic :> $TemporaryDirectory
    ],
    "GuardBits" -> OptionValue["GuardBits"]
  |>;
  seedData = XYZZProjectE2InfinityFrobeniusSeedRecords[
    signs, rulesNoE2, boundaryWP, seedOptions
  ];
  If[!AssociationQ[seedData], Return[seedData]];

  tag = StringJoin[If[#1 == 1, "p", "m"] & /@ signs];
  token = StringReplace[CreateUUID[], "-" -> ""];
  artifactDirectory = Replace[
    OptionValue["ArtifactDirectory"], Automatic :> $TemporaryDirectory
  ];
  If[!DirectoryQ[artifactDirectory],
    CreateDirectory[artifactDirectory, CreateIntermediateDirectories -> True]
  ];
  pythonExecutable = OptionValue["PythonExecutable"];
  accepted = False;
  halvings = 0;
  While[!accepted && halvings <= maxHalvings,
    waypoints = XYZZPatchwiseAutomaticWaypoints[
      N[tStart, boundaryWP], N[tEnd, boundaryWP],
      OptionValue["LocalSafetyFactor"]
    ];
    If[!ListQ[waypoints] || Length[waypoints] < 2,
      Return[Failure["InfinityWaypointsFailed", <||>]]
    ];
    probePayloadFile = FileNameJoin[{
      artifactDirectory,
      "frobenius_probe_" <> tag <> "_" <> token <> "_" <>
        ToString[halvings] <> "_input.json"
    }];
    probeOutputFile = StringReplace[probePayloadFile, "_input.json" -> "_output.json"];
    attemptPayloadSeconds = First@AbsoluteTiming[
      probePayload = XYZZBuildProjectE2InfinityPyFlintPayload[
        "three_vertex_frobenius_probe_" <> tag,
        poleData, seedData, tStart, highOrder, lowOrder, waypoints, boundaryWP,
        <|
          "signs" -> signs,
          "merged_probe_and_transport" -> True,
          "target_E2" -> ToString[e2End, InputForm]
        |>,
        False
      ];
    ];
    probePayloadSeconds += attemptPayloadSeconds;
    If[!AssociationQ[probePayload], Return[probePayload]];
    attemptExportSeconds = First@AbsoluteTiming[
      Export[probePayloadFile, probePayload, "RawJSON"];
    ];
    probeExportSeconds += attemptExportSeconds;
    attemptProcessSeconds = First@AbsoluteTiming[
      probeRun = XYZZRunPyFlint25DPayload[
        probePayloadFile,
        probeOutputFile,
        "PythonExecutable" -> pythonExecutable,
        "WorkingPrecision" -> wp,
        "GuardBits" -> OptionValue["GuardBits"],
        "HighOrder" -> OptionValue["LocalHighOrder"],
        "LowOrder" -> OptionValue["LocalLowOrder"],
        "CompareOrderDrop" -> OptionValue["LocalCompareOrderDrop"],
        "SafetyFraction" -> OptionValue["LocalSafetyFactor"]
      ];
    ];
    probeProcessSeconds += attemptProcessSeconds;
    If[!AssociationQ[probeRun], Return[probeRun]];
    probeResult = probeRun["Result"];
    highTruncation = probeResult["frobenius"][
      "high_estimated_truncation_midpoint"
    ];
    lowTruncation = probeResult["frobenius"][
      "low_estimated_truncation_midpoint"
    ];
    accepted = TrueQ[Max[highTruncation, lowTruncation] <= tolerance];
    If[!accepted, tStart = tStart/2; halvings++];
  ];
  If[!accepted, Return[Failure[
    "InfinityBoundaryTruncationNotMet",
    <|
      "HighTruncation" -> highTruncation,
      "LowTruncation" -> lowTruncation,
      "Tolerance" -> tolerance,
      "TStart" -> tStart,
      "Halvings" -> halvings
    |>
  ]]];
  payloadFile = probePayloadFile;
  outputFile = probeOutputFile;
  payload = probePayload;
  run = probeRun;
  pyResult = probeResult;
  payloadSeconds = attemptPayloadSeconds;
  exportSeconds = attemptExportSeconds;
  pyFlintWallSeconds = attemptProcessSeconds;
  probePayloadSeconds -= attemptPayloadSeconds;
  probeExportSeconds -= attemptExportSeconds;
  probeProcessSeconds -= attemptProcessSeconds;
  rawHigh = XYZZPyFlintResultVector[pyResult, "raw_boundary_25"];
  rawLow = XYZZPyFlintResultVector[
    pyResult, "raw_boundary_25_low_order"
  ];
  If[!VectorQ[rawHigh, NumericQ] || !VectorQ[rawLow, NumericQ] ||
      Length[rawHigh] =!= 25 || Length[rawLow] =!= 25,
    Return[Failure["PyFlintFrobeniusVectorFailed", <||>]]
  ];
  frobenius = pyResult["frobenius"];
  segments = pyResult["segments"];
  maximumHighODEResidual = Max[
    Lookup[Lookup[segments, "high"],
      "endpoint_ode_relative_residual_midpoint"]
  ];
  maximumLowODEResidual = Max[
    Lookup[Lookup[segments, "low"],
      "endpoint_ode_relative_residual_midpoint"]
  ];
  maximumLocalTruncation = Max@Join[
    Lookup[Lookup[segments, "high"],
      "estimated_relative_truncation_midpoint"],
    Lookup[Lookup[segments, "low"],
      "estimated_relative_truncation_midpoint"]
  ];
  finalHighLow = pyResult["final_high_low_relative_delta_midpoint"];
  result = <|
    "Signs" -> signs,
    "RawBoundary25" -> rawHigh,
    "RawBoundary25LowOrder" -> rawLow,
    "Rules" -> Join[rulesNoE2, {E2 -> e2End}],
    "PyFlintFrobeniusRecurrenceQ" -> True,
    "AutomaticODESolverUsedQ" -> False,
    "InfinityOrders" -> {highOrder, lowOrder},
    "LocalOrders" -> {
      OptionValue["LocalHighOrder"], OptionValue["LocalLowOrder"]
    },
    "PhysicalSeedCount" -> seedData["SeedCount"],
    "PhysicalSeedCacheHitQ" -> seedData["PhysicalSeedCacheHitQ"],
    "OuterVertexCacheStats" -> seedData["OuterVertexCacheStats"],
    "OuterVertexCacheEntryCount" -> seedData["OuterVertexCacheEntryCount"],
    "SeriesPatchT" -> tStart,
    "SeriesPatchE2" -> 1/tStart,
    "SeriesHalvings" -> halvings,
    "WaypointCount" -> Length[waypoints],
    "WaypointsT" -> waypoints,
    "HighEstimatedInfinityTruncation" ->
      frobenius["high_estimated_truncation_midpoint"],
    "LowEstimatedInfinityTruncation" ->
      frobenius["low_estimated_truncation_midpoint"],
    "HighLowRelativeDeltaAtSeriesPatch" ->
      frobenius["high_low_relative_delta_midpoint"],
    "HighInfinitySeriesODERelativeResidual" ->
      frobenius["high_ode_relative_residual_midpoint"],
    "LowInfinitySeriesODERelativeResidual" ->
      frobenius["low_ode_relative_residual_midpoint"],
    "MaximumIndicialRelativeResidual" ->
      frobenius["maximum_indicial_relative_residual_midpoint"],
    "MaximumRecurrenceRelativeResidual" ->
      frobenius["maximum_recurrence_relative_residual_midpoint"],
    "MaximumPyFlintHighEndpointODERelativeResidual" ->
      maximumHighODEResidual,
    "MaximumPyFlintLowEndpointODERelativeResidual" ->
      maximumLowODEResidual,
    "MaximumPyFlintEstimatedLocalTruncation" ->
      maximumLocalTruncation,
    "FinalHighLowRelativeDelta" -> finalHighLow,
    "Timings" -> Join[
      poleData["Timings"],
      <|
        "PhysicalSeedConstructionSeconds" ->
          seedData["PhysicalSeedConstructionSeconds"],
        "BoundaryProbePayloadBuildSeconds" -> probePayloadSeconds,
        "BoundaryProbeExportSeconds" -> probeExportSeconds,
        "BoundaryProbeProcessWallSeconds" -> probeProcessSeconds,
        "FinalPayloadBuildSeconds" -> payloadSeconds,
        "FinalPayloadExportSeconds" -> exportSeconds,
        "FinalPyFlintProcessWallSeconds" -> pyFlintWallSeconds,
        "FinalPyFlintTransportKernelSeconds" -> pyResult["elapsed_seconds"],
        "FinalPyFlintFrobeniusKernelSeconds" ->
          frobenius["timings"]["total_seconds"],
        "BranchTotalSeconds" -> N[AbsoluteTime[] - totalSeconds]
      |>
    ],
    "PayloadFile" -> payloadFile,
    "OutputFile" -> outputFile,
    "PythonResult" -> KeyDrop[pyResult, {
      "raw_boundary_25", "raw_boundary_25_low_order"
    }]
  |>;
  result
];

(* ::Section:: *)
(* ====================================================================== *)
(* Part 1G - V5.5 PyFLINT orchestration                                 *)
(* ====================================================================== *)

ClearAll[
  V55ResolvePyFlintPython,
  V55PyFlintDependencyCheck,
  V55PyFlintVectorFromRecords,
  V55RunPyFlintSharedBoundary,
  V55RunPyFlintPath,
  V55SamplePyFlint
];

V55ResolvePyFlintPython[requested_:Automatic] := Module[
  {baseDirectory, candidates, probe, found},
  baseDirectory = XYZZPyFlintBaseDirectory[];
  candidates = DeleteDuplicates@Select[
    Flatten@{
      If[StringQ[requested], requested, Nothing],
      Environment["XYZZ_PYFLINT_PYTHON"],
      Environment["PYTHON"],
      FileNameJoin[{
        baseDirectory, ".venv-pyflint", "Scripts", "python.exe"
      }],
      FileNameJoin[{
        baseDirectory, ".venv-pyflint", "bin", "python"
      }],
      FileNameJoin[{
        $HomeDirectory, "Documents", "宇宙学关联函数计算",
        ".venv-pyflint", "Scripts", "python.exe"
      }],
      FileNameJoin[{
        $HomeDirectory, "Documents",
        FromCharacterCode[{23431, 23449, 23398, 20851, 32852, 20989, 25968, 35745, 31639}],
        ".venv-pyflint", "Scripts", "python.exe"
      }],
      "python"
    },
    StringQ[#1] && StringLength[#1] > 0 &
  ];
  found = SelectFirst[
    candidates,
    Function[executable,
      probe = Quiet@Check[
        RunProcess[{
          executable,
          "-c",
          "import flint, sympy; print('xyzz-pyflint-ok')"
        }],
        $Failed
      ];
      AssociationQ[probe] && probe["ExitCode"] === 0
    ],
    Missing["NotFound"]
  ];
  If[
    MissingQ[found],
    Failure[
      "PyFlintPythonDependencyMissing",
      <|
        "TriedExecutables" -> candidates,
        "RequiredPackages" -> {"python-flint", "sympy"},
        "InstallCommand" ->
          "python -m pip install python-flint sympy",
        "Configuration" ->
          "Set v55PyFlintPythonExecutable to the Python executable containing those packages."
      |>
    ],
    found
  ]
];

V55PyFlintDependencyCheck[requested_:Automatic] := Module[
  {pythonFile, pythonExecutable},
  $XYZZPyFlintAdapterDirectory = XYZZPyFlintBaseDirectory[];
  pythonFile = FileNameJoin[{
    $XYZZPyFlintAdapterDirectory, "pyflint_e2_transport.py"
  }];
  If[!FileExistsQ[pythonFile],
    Return[Failure[
      "PyFlintCompanionScriptMissing",
      <|
        "ExpectedFile" -> pythonFile,
        "Fix" ->
          "Put pyflint_e2_transport.py beside the .wl file or beside the notebook."
      |>
    ]]
  ];
  pythonExecutable = V55ResolvePyFlintPython[requested];
  If[Head[pythonExecutable] === Failure, Return[pythonExecutable]];
  <|
    "AcceptedQ" -> True,
    "PythonExecutable" -> pythonExecutable,
    "PythonModule" -> pythonFile,
    "RequiredPackages" -> {"python-flint", "sympy"}
  |>
];

V55PyFlintVectorFromRecords[records_List, wp_Integer] := N[
  XYZZPyFlintParseDecimal[#1["re"]] +
    I XYZZPyFlintParseDecimal[#1["im"]] & /@ records,
  wp
];

V55RunPyFlintSharedBoundary[
  settings_Association,
  cacheDirectory_String,
  sourceHash_,
  boundaryTolerance_,
  pythonExecutable_String,
  artifactDirectory_String
] := Module[
  {wp, parameters, point, rules, signsList, highOrder, lowOrder,
    localHighOrder, localLowOrder, records, tag, spec, specHash,
    cacheFile, cached, seconds, solution, record,
    highRaw, lowRaw, residuals, maximumResidual},
  wp = settings["WorkingPrecision"];
  parameters = SoftLimitParameters[];
  point = SoftLimitPointFromQ[1/10];
  rules = StandaloneRulesFromPoint[parameters, point];
  signsList = XYZZProjectIndependentBranchSigns[];
  highOrder = Lookup[settings, "BoundaryHighSeriesOrder", 14];
  lowOrder = Lookup[settings, "BoundaryLowSeriesOrder", 12];
  localHighOrder = Lookup[settings, "BoundaryWaypointSeriesOrder", 72];
  localLowOrder = Lookup[
    settings, "BoundaryWaypointLowSeriesOrder", localHighOrder - 2
  ];
  If[!DirectoryQ[artifactDirectory],
    CreateDirectory[artifactDirectory, CreateIntermediateDirectories -> True]
  ];
  records = Association@Table[
    tag = SoftLimitSignTag[signs];
    spec = <|
      "Object" -> "V5.5 pole-residue PyFLINT Frobenius boundary",
      "Signs" -> signs,
      "Parameters" -> parameters,
      "Point" -> point,
      "WorkingPrecision" -> wp,
      "BoundaryAccuracyGoal" ->
        Max[35, settings["E2InfinityBoundaryAccuracyGoal"]],
      "InfinityOrders" -> {highOrder, lowOrder},
      "LocalOrders" -> {localHighOrder, localLowOrder},
      "SafetyFactor" ->
        Lookup[settings, "BoundaryWaypointSafetyFactor", 2/5],
      "SeriesSafetyFactor" ->
        Lookup[settings, "BoundarySeriesSafetyFactor", 1/320],
      "SourceHash" -> sourceHash
    |>;
    specHash = SoftLimitCacheHash[spec];
    cacheFile = FileNameJoin[{
      cacheDirectory, "boundary_pyflint_frobenius_" <> tag <> ".wl"
    }];
    cached = If[
      FileExistsQ[cacheFile],
      Quiet@Check[Get[cacheFile], $Failed],
      $Failed
    ];
    If[
      AssociationQ[cached] && Lookup[cached, "SpecHash", ""] === specHash,
      signs -> Join[cached, <|"CacheHitQ" -> True, "SecondsThisRun" -> 0|>],
      seconds = First@AbsoluteTiming[
        solution = XYZZSolveProjectBranchE2PyFlintFrobenius[
          signs,
          rules,
          point["E2"],
          "WorkingPrecision" -> wp,
          "AccuracyGoal" -> settings["AccuracyGoal"],
          "PrecisionGoal" -> settings["PrecisionGoal"],
          "BoundaryGuardDigits" -> 20,
          "BoundaryAccuracyGoal" ->
            Max[35, settings["E2InfinityBoundaryAccuracyGoal"]],
          "HighInfinitySeriesOrder" -> highOrder,
          "LowInfinitySeriesOrder" -> lowOrder,
          "SeriesSafetyFactor" ->
            Lookup[settings, "BoundarySeriesSafetyFactor", 1/320],
          "BoundaryMaxRecursion" -> 14,
          "BoundaryCutoff" -> 35,
          "BoundaryLowerCutoff" -> 10^-8,
          "OuterVertexEvaluation" -> "PyFlint",
          "OuterVertexSeriesOrder" -> 16,
          "LocalHighOrder" -> localHighOrder,
          "LocalLowOrder" -> localLowOrder,
          "LocalCompareOrderDrop" -> 2,
          "LocalSafetyFactor" ->
            Lookup[settings, "BoundaryWaypointSafetyFactor", 2/5],
          "GuardBits" -> 32,
          "PythonExecutable" -> pythonExecutable,
          "ArtifactDirectory" -> artifactDirectory
        ];
      ];
      If[!AssociationQ[solution], Return[solution]];
      record = <|
        "SpecHash" -> specHash,
        "Signs" -> signs,
        "HighValue" -> N[solution["RawBoundary25"], wp],
        "LowValue" -> N[solution["RawBoundary25LowOrder"], wp],
        "MeasuredSeconds" -> seconds,
        "SecondsThisRun" -> seconds,
        "CacheHitQ" -> False,
        "Diagnostics" -> KeyTake[solution, {
          "PyFlintFrobeniusRecurrenceQ", "AutomaticODESolverUsedQ",
          "MaximumIndicialRelativeResidual",
          "MaximumRecurrenceRelativeResidual",
          "PhysicalSeedCacheHitQ", "OuterVertexCacheStats",
          "InfinityOrders", "LocalOrders", "SeriesPatchT",
          "SeriesPatchE2", "SeriesHalvings", "WaypointCount",
          "HighEstimatedInfinityTruncation",
          "LowEstimatedInfinityTruncation",
          "HighInfinitySeriesODERelativeResidual",
          "LowInfinitySeriesODERelativeResidual",
          "MaximumPyFlintHighEndpointODERelativeResidual",
          "MaximumPyFlintEstimatedLocalTruncation",
          "FinalHighLowRelativeDelta", "Timings"
        }]
      |>;
      Put[record, cacheFile];
      signs -> record
    ],
    {signs, signsList}
  ];
  If[!And @@ (AssociationQ /@ Values[records]), Return[records]];
  highRaw = Association@KeyValueMap[#1 -> #2["HighValue"] &, records];
  lowRaw = Association@KeyValueMap[#1 -> #2["LowValue"] &, records];
  residuals = Association@Table[
    signs -> SoftLimitVectorResidual[
      highRaw[signs], lowRaw[signs], wp
    ],
    {signs, signsList}
  ];
  maximumResidual = Max[Values[residuals]];
  <|
    "Profile" -> <|
      "Name" -> "PyFlintFrobeniusInfinity14_12",
      "HighSeriesOrder" -> highOrder,
      "LowSeriesOrder" -> lowOrder
    |>,
    "Raw25" -> highRaw,
    "Raw25LowOrder" -> lowRaw,
    "Records" -> records,
    "BranchResiduals" -> residuals,
    "MaximumEstimatedRelativeTruncation" -> maximumResidual,
    "MeasuredSeconds" -> Total[Lookup[Values[records], "MeasuredSeconds"]],
    "SecondsThisRun" -> Total[Lookup[Values[records], "SecondsThisRun"]],
    "AllCacheHitsQ" -> And @@ Lookup[Values[records], "CacheHitQ"],
    "AcceptedQ" -> TrueQ[maximumResidual <= boundaryTolerance],
    "TransportMethod" -> "PyFlint",
    "AutomaticODESolverUsedQ" -> False,
    "SharedHighLowFrobeniusDataQ" -> True
  |>
];

V55RunPyFlintPath[
  connections_Association,
  boundary_Association,
  variable_Symbol,
  waypoints_List,
  sampleQValues_List,
  highOrder_Integer,
  lowOrder_Integer,
  wp_Integer,
  safetyFactor_,
  pythonExecutable_String,
  artifactDirectory_String
] := Module[
  {signsList, rows, tag, payloadFile, outputFile, payloadBuildSeconds,
    built, payload, exportSeconds, processSeconds, run, pythonResult,
    highRaw, lowRaw, sampleVectors, segments, row},
  signsList = Keys[connections];
  If[!DirectoryQ[artifactDirectory],
    CreateDirectory[artifactDirectory, CreateIntermediateDirectories -> True]
  ];
  rows = Association@Table[
    tag = SoftLimitSignTag[signs];
    payloadFile = FileNameJoin[{
      artifactDirectory, "q_path_" <> tag <> "_input.json"
    }];
    outputFile = FileNameJoin[{
      artifactDirectory, "q_path_" <> tag <> "_output.json"
    }];
    payloadBuildSeconds = First@AbsoluteTiming[
      built = XYZZBuildPyFlint25DPayload[
        "v55_literature_soft_limit_" <> tag,
        connections[signs],
        variable,
        waypoints,
        boundary["Raw25"][signs],
        boundary["Raw25LowOrder"][signs],
        <|
          "object" -> "V5.5 canonical soft-limit q pullback",
          "x_range" -> {1, 4},
          "q_range" -> {"1/10", "1/10000"},
          "signs" -> signs,
          "shared_boundary" -> True
        |>,
        "WorkingPrecision" -> wp,
        "EvolutionVariable" -> "q=s1"
      ];
      If[AssociationQ[built],
        payload = built["Payload"];
        AssociateTo[
          payload,
          "sample_points_real" ->
            (XYZZPyFlintDecimalString[#1, wp] & /@ sampleQValues)
        ];
      ];
    ];
    If[!AssociationQ[built], Return[built]];
    exportSeconds = First@AbsoluteTiming[
      Export[payloadFile, payload, "RawJSON"];
    ];
    processSeconds = First@AbsoluteTiming[
      run = XYZZRunPyFlint25DPayload[
        payloadFile,
        outputFile,
        "PythonExecutable" -> pythonExecutable,
        "WorkingPrecision" -> wp,
        "GuardBits" -> 32,
        "HighOrder" -> highOrder,
        "LowOrder" -> lowOrder,
        "CompareOrderDrop" -> 2,
        "SafetyFraction" -> safetyFactor
      ];
    ];
    If[!AssociationQ[run], Return[run]];
    pythonResult = run["Result"];
    highRaw = XYZZPyFlintResultVector[pythonResult, "raw_boundary_25"];
    lowRaw = XYZZPyFlintResultVector[
      pythonResult, "raw_boundary_25_low_order"
    ];
    sampleVectors = V55PyFlintVectorFromRecords[
        #1["raw_vector"], wp
      ] & /@ pythonResult["sample_results"];
    If[Length[sampleVectors] =!= Length[sampleQValues],
      Return[Failure[
        "V55PyFlintSampleCountMismatch",
        <|
          "Signs" -> signs,
          "Expected" -> Length[sampleQValues],
          "Actual" -> Length[sampleVectors]
        |>
      ]]
    ];
    segments = pythonResult["segments"];
    row = <|
      "Signs" -> signs,
      "Raw25" -> highRaw,
      "Raw25LowOrder" -> lowRaw,
      "Samples" -> MapThread[
        <|"q" -> #1, "Raw25" -> #2|> &,
        {sampleQValues, sampleVectors}
      ],
      "PayloadBuildSeconds" -> payloadBuildSeconds,
      "PayloadExportSeconds" -> exportSeconds,
      "PyFlintProcessWallSeconds" -> processSeconds,
      "PyFlintKernelSeconds" -> pythonResult["elapsed_seconds"],
      "FinalHighLowRelativeDelta" ->
        pythonResult["final_high_low_relative_delta_midpoint"],
      "MaximumEndpointODERelativeResidual" -> Max[
        Lookup[Lookup[segments, "high"],
          "endpoint_ode_relative_residual_midpoint"]
      ],
      "MaximumEstimatedRelativeTruncation" -> Max[
        Join[
          Lookup[Lookup[segments, "high"],
            "estimated_relative_truncation_midpoint"],
          Lookup[Lookup[segments, "low"],
            "estimated_relative_truncation_midpoint"]
        ]
      ],
      "MaximumStepRatio" ->
        Max[Lookup[segments, "step_over_radius_midpoint"]],
      "PayloadFile" -> payloadFile,
      "OutputFile" -> outputFile
    |>;
    signs -> row,
    {signs, signsList}
  ];
  If[!And @@ (AssociationQ /@ Values[rows]), Return[rows]];
  <|
    "Rows" -> rows,
    "Raw25" -> Association@KeyValueMap[#1 -> #2["Raw25"] &, rows],
    "Raw25LowOrder" ->
      Association@KeyValueMap[#1 -> #2["Raw25LowOrder"] &, rows],
    "TransportSeconds" ->
      Total[Lookup[Values[rows], "PyFlintProcessWallSeconds"]],
    "PreparationSeconds" -> Total[
      Lookup[Values[rows], "PayloadBuildSeconds"] +
        Lookup[Values[rows], "PayloadExportSeconds"]
    ],
    "SeriesOrder" -> highOrder,
    "LowSeriesOrder" -> lowOrder,
    "WorkingPrecision" -> wp,
    "SafetyFactor" -> safetyFactor,
    "PatchBuildCount" -> Length[signsList] (Length[waypoints] - 1),
    "MaximumEndpointODERelativeResidual" -> Max[
      Lookup[Values[rows], "MaximumEndpointODERelativeResidual"]
    ],
    "MaximumEstimatedRelativeTruncation" -> Max[
      Lookup[Values[rows], "MaximumEstimatedRelativeTruncation"]
    ],
    "MaximumStepRatio" ->
      Max[Lookup[Values[rows], "MaximumStepRatio"]],
    "MaximumFinalHighLowRelativeDelta" -> Max[
      Lookup[Values[rows], "FinalHighLowRelativeDelta"]
    ],
    "TransportMethod" -> "PyFlint",
    "AutomaticODESolverUsedQ" -> False
  |>
];

V55SamplePyFlint[
  run_Association,
  qValues_List,
  wp_Integer
] := Module[{tolerance, sampledRows, seconds, match},
  tolerance = N[10^-Max[30, Floor[wp/2]], wp];
  seconds = First@AbsoluteTiming[
    sampledRows = Association@KeyValueMap[
      Function[{signs, branch},
        signs -> Table[
          match = SelectFirst[
            branch["Samples"],
            Abs[#1["q"] - q] <= tolerance Max[1, Abs[q]] &,
            Missing["NotFound"]
          ];
          If[MissingQ[match],
            Failure[
              "V55PyFlintSampleNotPrecomputed",
              <|"Signs" -> signs, "q" -> q|>
            ],
            match["Raw25"]
          ],
          {q, qValues}
        ]
      ],
      run["Rows"]
    ];
  ];
  If[Cases[sampledRows, _Failure, Infinity] =!= {},
    Return[First@Cases[sampledRows, _Failure, Infinity]]
  ];
  <|"Values" -> sampledRows, "Seconds" -> seconds|>
];

(* ::Section:: *)
(* ====================================================================== *)
(* V5.5 - literature soft-limit q-path driver                           *)
(* ====================================================================== *)

(* This block is evaluated after Parts 1--4A of V5.2.  It changes no
   25-dimensional basis, source block, SK branch, or BB convention. *)

ClearAll[
  V55DefaultCacheDirectory,
  V55DefinitionHash,
  V55ValidateLiteratureSlice,
  V55RunLiteratureSoftLimit,
  V55SampleLiteratureSoftLimit,
  V55LoadMatchedAnalyticX4,
  V55CompareMatchedAnalyticX4,
  V55LegacyDoubleConventionCorrectionDiagnostic,
  V55PrintReport
];

V55DefaultCacheDirectory[] := Module[{base},
  base = Quiet@Check[NotebookDirectory[], $Failed];
  If[!StringQ[base] || base === "", base = Directory[]];
  FileNameJoin[{base, "v5.5_soft_limit_cache"}]
];

V55DefinitionHash[] := SoftLimitCacheHash[
  HoldComplete[
    "001_dsde3vertex-v5.5-literature-soft-limit-pyflint",
    DownValues[XYZZProjectRawBranchMatrix],
    DownValues[XYZZProjectRawBranchMatrixForVariable],
    DownValues[XYZZProjectE2InfinityFrobeniusData],
    DownValues[XYZZSolveProjectBranchE2PatchwiseFromInfinity],
    DownValues[XYZZPatchwiseSeriesPropagate],
    DownValues[XYZZSolveProjectBranchE2PyFlintFrobenius],
    DownValues[V55RunPyFlintSharedBoundary],
    DownValues[V55RunPyFlintPath],
    DownValues[SoftLimitFixedBoundaryWaypointsT],
    DownValues[StandalonePaperValueFromRaw25]
  ]
];

V55ValidateLiteratureSlice[wp_Integer:80] := Module[
  {xValues, ratios, errors, maximumError, tolerance},
  xValues = {1, 5/2, 4};
  ratios = SoftLimitRatiosFromX[#1, wp] & /@ xValues;
  errors = <|
    "r1" -> Max[Abs[ratios[[All, 1]] - 99/100]],
    "r2Range" -> Max[
      Max[0, 10^-4 - Min[ratios[[All, 2]]]],
      Max[0, Max[ratios[[All, 2]]] - 10^-1]
    ],
    "r3" -> Max[Abs[ratios[[All, 3]] - 1/10]],
    "r4" -> Max[Abs[ratios[[All, 4]] - 99/100]]
  |>;
  maximumError = Max[Values[errors]];
  tolerance = N[10^-Max[20, Floor[wp/2]], wp];
  <|
    "AcceptedQ" ->
      TrueQ[PossibleZeroQ[maximumError]] || TrueQ[maximumError < tolerance],
    "AuditX" -> xValues,
    "Ratios" -> ratios,
    "MaximumAbsoluteError" -> maximumError,
    "Tolerance" -> tolerance
  |>
];

Options[V55RunLiteratureSoftLimit] = {
  "TransportBackend" -> "PyFlint",
  "PyFlintPythonExecutable" -> Automatic,
  "WorkingPrecision" -> 80,
  "AccuracyGoal" -> 45,
  "PrecisionGoal" -> 45,
  "E2InfinityBoundaryAccuracyGoal" -> 35,
  "BoundaryProfiles" -> Automatic,
  "BoundaryTolerance" -> 10^-25,
  "WaypointRelativeTolerance" -> 10^-28,
  "WaypointSeriesOrder" -> 72,
  "WaypointLowSeriesOrder" -> 70,
  "WaypointSafetyFactor" -> 2/5,
  "WaypointMultiplier" -> 2/3,
  "BoundaryWaypointMultiplier" -> 4/5,
  "XValues" -> {4},
  "CacheDirectory" -> Automatic,
  "Verbose" -> True
};

V55RunLiteratureSoftLimit[OptionsPattern[]] := Module[
  {transportBackend, pyFlintPythonRequested, pyFlintDependencies,
    pythonExecutable, pyFlintArtifactDirectory,
    wp, accuracyGoal, precisionGoal, infinityBoundaryAccuracyGoal,
    boundaryProfiles, boundaryTolerance,
    waypointTolerance, waypointOrder, waypointLowOrder, waypointSafety,
    waypointMultiplier, boundaryWaypointMultiplier,
    xValues, cacheDirectory, verbose,
    requiredNames, settings, sourceHash, parameters, qV55,
    signsList, sliceAudit, connections, connectionSeconds,
    boundary, boundaryThisRunSeconds, boundaryTransportDiagnostics,
    waypoints, patchRun, precomputedXValues, precomputedQValues,
    patchThisRunSeconds, patchDiagnostics, result, initialSample},

  transportBackend = OptionValue["TransportBackend"];
  pyFlintPythonRequested = OptionValue["PyFlintPythonExecutable"];
  wp = OptionValue["WorkingPrecision"];
  accuracyGoal = OptionValue["AccuracyGoal"];
  precisionGoal = OptionValue["PrecisionGoal"];
  infinityBoundaryAccuracyGoal =
    OptionValue["E2InfinityBoundaryAccuracyGoal"];
  boundaryProfiles = Replace[
    OptionValue["BoundaryProfiles"],
    Automatic :> SoftLimitBoundaryProfiles[]
  ];
  boundaryTolerance = OptionValue["BoundaryTolerance"];
  waypointTolerance = OptionValue["WaypointRelativeTolerance"];
  waypointOrder = OptionValue["WaypointSeriesOrder"];
  waypointLowOrder = OptionValue["WaypointLowSeriesOrder"];
  waypointSafety = OptionValue["WaypointSafetyFactor"];
  waypointMultiplier = OptionValue["WaypointMultiplier"];
  boundaryWaypointMultiplier = OptionValue["BoundaryWaypointMultiplier"];
  xValues = OptionValue["XValues"];
  cacheDirectory = Replace[
    OptionValue["CacheDirectory"],
    Automatic :> V55DefaultCacheDirectory[]
  ];
  verbose = TrueQ[OptionValue["Verbose"]];

  If[!MemberQ[{"PyFlint", "PatchwiseSeries"}, transportBackend],
    Return[Failure[
      "V55UnknownTransportBackend",
      <|
        "Requested" -> transportBackend,
        "Allowed" -> {"PyFlint", "PatchwiseSeries"}
      |>
    ]]
  ];

  requiredNames = {
    "XYZZLoadProjectCore",
    "XYZZProjectIndependentBranchSigns",
    "XYZZProjectRawBranchMatrix",
    "XYZZProjectRawBranchMatrixForVariable",
    "XYZZSolveProjectBranchE2PatchwiseFromInfinity",
    "XYZZPatchwiseSeriesPropagate",
    "XYZZPatchwiseSeriesEvaluate",
    "XYZZSolveProjectBranchE2PyFlintFrobenius",
    "XYZZBuildPyFlint25DPayload",
    "XYZZRunPyFlint25DPayload",
    "StandalonePaperValueFromRaw25"
  };
  If[!And @@ (NameQ /@ requiredNames),
    Return[Failure[
      "V55BaseDefinitionsMissing",
      <|"MissingNames" -> Select[requiredNames, !NameQ[#1] &]|>
    ]]
  ];
  If[!XYZZLoadProjectCore[],
    Return[Failure["V55ProjectCoreLoadFailed", <||>]]
  ];
  If[
    !IntegerQ[wp] || wp < 30 || !IntegerQ[accuracyGoal] ||
      !IntegerQ[precisionGoal] ||
      !IntegerQ[infinityBoundaryAccuracyGoal] ||
      !ListQ[boundaryProfiles] || boundaryProfiles === {} ||
      !And @@ (AssociationQ /@ boundaryProfiles) ||
      !IntegerQ[waypointOrder] || !IntegerQ[waypointLowOrder] ||
      !(waypointOrder > waypointLowOrder >= 4) ||
      !VectorQ[xValues, NumericQ] ||
      xValues === {} || !And @@ (TrueQ[1 <= #1 <= 4] & /@ xValues) ||
      !TrueQ[0 < waypointSafety < 1] ||
      !TrueQ[0 < waypointMultiplier < 1] ||
      !TrueQ[0 < boundaryWaypointMultiplier < 1],
    Return[Failure["V55InvalidOptions", <|"XValues" -> xValues|>]]
  ];
  If[!DirectoryQ[cacheDirectory],
    CreateDirectory[cacheDirectory, CreateIntermediateDirectories -> True]
  ];
  pyFlintDependencies = If[
    transportBackend === "PyFlint",
    V55PyFlintDependencyCheck[pyFlintPythonRequested],
    <|"AcceptedQ" -> True, "PythonExecutable" -> Missing["NotUsed"]|>
  ];
  If[!AssociationQ[pyFlintDependencies], Return[pyFlintDependencies]];
  pythonExecutable = pyFlintDependencies["PythonExecutable"];
  pyFlintArtifactDirectory = FileNameJoin[{
    cacheDirectory, "pyflint_artifacts"
  }];

  parameters = SoftLimitParameters[];
  signsList = XYZZProjectIndependentBranchSigns[];
  sliceAudit = V55ValidateLiteratureSlice[wp];
  If[!TrueQ[sliceAudit["AcceptedQ"]],
    Return[Failure["V55LiteratureSliceAuditFailed", sliceAudit]]
  ];
  sourceHash = V55DefinitionHash[];
  settings = <|
    "WorkingPrecision" -> wp,
    "AccuracyGoal" -> accuracyGoal,
    "PrecisionGoal" -> precisionGoal,
    "E2InfinityBoundaryAccuracyGoal" -> infinityBoundaryAccuracyGoal,
    "BoundaryProfiles" -> boundaryProfiles,
    "BoundaryHighSeriesOrder" ->
      Lookup[First[boundaryProfiles], "HighSeriesOrder", 14],
    "BoundaryLowSeriesOrder" ->
      Lookup[First[boundaryProfiles], "LowSeriesOrder", 12],
    "BoundaryWaypointSeriesOrder" -> waypointOrder,
    "BoundaryWaypointLowSeriesOrder" -> waypointLowOrder,
    "BoundaryWaypointRelativeTolerance" -> waypointTolerance,
    "BoundaryWaypointSafetyFactor" -> waypointSafety,
    "BoundarySeriesSafetyFactor" -> 1/320,
    "BoundaryWaypointMultiplier" -> boundaryWaypointMultiplier
  |>;

  If[verbose,
    Print[
      "V5.5 slice: q=10^-x, x in [1,4], ",
      "(E1,E2,E3,s1,s2)=(100 q/99,1,10/99,q,1/10)."
    ];
    Print["Building four exact 25D q-pullback connections..."];
  ];
  connectionSeconds = First@AbsoluteTiming[
    connections = Association@Table[
      signs -> SoftLimitPullbackConnection[signs, qV55],
      {signs, signsList}
    ];
  ];
  If[
    !And @@ (MatrixQ[#1] && Dimensions[#1] === {25, 25} & /@
        Values[connections]),
    Return[Failure["V55PullbackConnectionFailed", <||>]]
  ];

  If[verbose,
    Print[
      "Constructing/caching the common x=1 boundary ",
      "from the true-infinity Frobenius germ..."
    ]
  ];
  boundaryThisRunSeconds = First@AbsoluteTiming[
    boundary = If[
      transportBackend === "PyFlint",
      V55RunPyFlintSharedBoundary[
        settings,
        cacheDirectory,
        sourceHash,
        boundaryTolerance,
        pythonExecutable,
        FileNameJoin[{pyFlintArtifactDirectory, "boundary"}]
      ],
      SoftLimitSelectBoundary[
        settings, cacheDirectory, sourceHash, boundaryTolerance
      ]
    ];
  ];
  If[
    !AssociationQ[boundary] || !TrueQ[Lookup[boundary, "AcceptedQ", False]],
    Return[Failure[
      "V55BoundaryPrecisionGateFailed",
      <|"BoundaryResult" -> boundary,
        "RequiredTolerance" -> boundaryTolerance|>
    ]]
  ];
  If[
    !And @@ (VectorQ[#1, NumericQ] && Length[#1] === 25 & /@
        Values[boundary["Raw25"]]),
    Return[Failure["V55BoundaryVectorShapeFailed", <||>]]
  ];
  boundaryTransportDiagnostics = If[
    transportBackend === "PyFlint",
    Lookup[Values[boundary["Records"]], "Diagnostics", <||>],
    Lookup[
      Values[boundary["High"]["Records"]],
      "TransportDiagnostics",
      <||>
    ]
  ];
  If[
    !And @@ Map[
      Function[diagnostics,
        If[
          transportBackend === "PyFlint",
          TrueQ[Lookup[diagnostics, "PyFlintFrobeniusRecurrenceQ", False]] &&
            TrueQ[
              Lookup[diagnostics, "AutomaticODESolverUsedQ", True] === False
            ],
          Lookup[diagnostics, "TransportMethod", Missing["NotRecorded"]] ===
              "PatchwiseSeries" &&
            TrueQ[
              Lookup[diagnostics, "AutomaticODESolverUsedQ", True] === False
            ]
        ]
      ],
      boundaryTransportDiagnostics
    ],
    Return[Failure[
      "V55BoundaryUsedUnexpectedTransport",
      <|"TransportDiagnostics" -> boundaryTransportDiagnostics|>
    ]]
  ];

  waypoints = SoftLimitGeometricWaypoints[
    1/10, 1/10000, waypointMultiplier, wp
  ];
  If[!ListQ[waypoints] || Length[waypoints] < 2,
    Return[Failure["V55WaypointGenerationFailed", <||>]]
  ];
  If[verbose,
    Print[
      "Propagating once from q=0.1 to q=10^-4 with backend ",
      transportBackend, ", ", Length[waypoints] - 1,
      " fixed segments at local orders ",
      {waypointOrder, waypointLowOrder}, "."
    ]
  ];
  precomputedXValues = DeleteDuplicates@Join[
    xValues,
    Flatten[Values[SoftLimitXGrids[]]]
  ];
  precomputedQValues = N[10^-#1 & /@ precomputedXValues, wp];
  patchThisRunSeconds = First@AbsoluteTiming[
    patchRun = If[
      transportBackend === "PyFlint",
      V55RunPyFlintPath[
        connections,
        boundary,
        qV55,
        waypoints,
        precomputedQValues,
        waypointOrder,
        waypointLowOrder,
        wp,
        waypointSafety,
        pythonExecutable,
        FileNameJoin[{pyFlintArtifactDirectory, "q_path"}]
      ],
      SoftLimitRunPatchwise[
        connections,
        boundary["Raw25"],
        qV55,
        waypoints,
        waypointOrder,
        wp,
        waypointTolerance,
        waypointSafety
      ]
    ];
  ];
  If[!AssociationQ[patchRun], Return[patchRun]];
  patchDiagnostics = If[
    transportBackend === "PyFlint",
    <|
      "MaximumEstimatedRelativeTruncation" ->
        patchRun["MaximumEstimatedRelativeTruncation"],
      "MaximumEndpointODERelativeResidual" ->
        patchRun["MaximumEndpointODERelativeResidual"],
      "MaximumStepRatio" -> patchRun["MaximumStepRatio"],
      "MaximumFinalHighLowRelativeDelta" ->
        patchRun["MaximumFinalHighLowRelativeDelta"],
      "PatchBuildCount" -> patchRun["PatchBuildCount"]
    |>,
    SoftLimitPatchDiagnostics[patchRun]
  ];
  If[
    !TrueQ[
      patchDiagnostics["MaximumEstimatedRelativeTruncation"] <=
        waypointTolerance
    ],
    Return[Failure[
      "V55WaypointPrecisionGateFailed",
      <|"Diagnostics" -> patchDiagnostics,
        "RequiredTolerance" -> waypointTolerance|>
    ]]
  ];

  result = <|
    "Version" -> "5.5",
    "Object" -> "25D multi-vertex correlator with pinched subsectors",
    "Method" -> If[
      transportBackend === "PyFlint",
      "PyFLINT fixed-waypoint Acb Taylor continuation",
      "Mathematica fixed-waypoint local-series continuation"
    ],
    "TransportBackend" -> transportBackend,
    "BoundaryTransportMethod" -> transportBackend,
    "AutomaticODESolverUsedQ" -> False,
    "PyFlintDependencies" -> pyFlintDependencies,
    "LiteratureSlice" -> <|
      "q" -> "10^-x",
      "xRange" -> {1, 4},
      "E1" -> "100 q/99",
      "E2" -> 1,
      "E3" -> 10/99,
      "s1" -> "q",
      "s2" -> 1/10,
      "p" -> {0, 0, 0},
      "muTilde" -> {1, 2}
    |>,
    "Parameters" -> parameters,
    "Variable" -> qV55,
    "WorkingPrecision" -> wp,
    "AccuracyGoal" -> accuracyGoal,
    "PrecisionGoal" -> precisionGoal,
    "CacheDirectory" -> cacheDirectory,
    "DefinitionHash" -> sourceHash,
    "SliceAudit" -> sliceAudit,
    "Connections" -> connections,
    "Boundary" -> boundary,
    "Waypoints" -> waypoints,
    "PrecomputedXValues" -> precomputedXValues,
    "WaypointRun" -> patchRun,
    "PatchDiagnostics" -> patchDiagnostics,
    "Timings" -> <|
      "ConnectionSeconds" -> connectionSeconds,
      "BoundarySecondsThisRun" -> boundaryThisRunSeconds,
      "WaypointSecondsThisRun" -> patchThisRunSeconds,
      "BoundaryMeasuredSecondsStoredInCacheRecords" ->
        If[
          transportBackend === "PyFlint",
          boundary["MeasuredSeconds"],
          boundary["High"]["MeasuredSeconds"]
        ]
    |>
  |>;
  initialSample = V55SampleLiteratureSoftLimit[result, xValues];
  If[!AssociationQ[initialSample], Return[initialSample]];
  result = Append[result, "InitialSample" -> initialSample];
  result = Append[
    result,
    "Timings" -> Join[
      result["Timings"],
      <|
        "InitialSamplingSeconds" -> initialSample["SamplingSeconds"],
        "ThisRunTotalSeconds" -> N[
          connectionSeconds + boundaryThisRunSeconds +
            patchThisRunSeconds + initialSample["SamplingSeconds"],
          20
        ]
      |>
    ]
  ];
  If[verbose, V55PrintReport[result]];
  result
];

V55SampleLiteratureSoftLimit[
  result_Association,
  xValues_List
] := Module[
  {wp, parameters, qValues, sampled, rows},
  wp = Lookup[result, "WorkingPrecision", 80];
  parameters = result["Parameters"];
  If[
    !VectorQ[xValues, NumericQ] || xValues === {} ||
      !And @@ (TrueQ[1 <= #1 <= 4] & /@ xValues),
    Return[Failure["V55SamplingPointOutsideLiteratureSlice", <|
      "XValues" -> xValues, "AllowedRange" -> {1, 4}|>]]
  ];
  qValues = N[10^-#1 & /@ xValues, wp];
  sampled = If[
    Lookup[result, "TransportBackend", "PatchwiseSeries"] === "PyFlint",
    V55SamplePyFlint[result["WaypointRun"], qValues, wp],
    SoftLimitSamplePatchwise[result["WaypointRun"], qValues]
  ];
  If[!AssociationQ[sampled], Return[sampled]];
  rows = Table[
    <|
      "x" -> N[xValues[[index]], 20],
      "q" -> qValues[[index]],
      "Kinematics" -> SoftLimitPointFromQ[qValues[[index]]],
      "Raw25ByIndependentSKBranch" ->
        SoftLimitRawAtQ[sampled["Values"], index],
      "PaperValue" -> SoftLimitPaperValueAtQ[
        parameters,
        qValues[[index]],
        sampled["Values"],
        index,
        wp
      ]
    |>,
    {index, Length[xValues]}
  ];
  <|
    "XValues" -> xValues,
    "QValues" -> qValues,
    "Rows" -> rows,
    "SamplingSeconds" -> sampled["Seconds"],
    "PatchBuildCount" -> result["WaypointRun"]["PatchBuildCount"],
    "RebuiltPatchesQ" -> False
  |>
];

V55LoadMatchedAnalyticX4[
  convergedFile_String,
  downscanFile_String
] := Module[{reference, downscan, candidate, referenceBB, value},
  If[!FileExistsQ[convergedFile] || !FileExistsQ[downscanFile],
    Return[Failure[
      "V55MatchedAnalyticFilesMissing",
      <|"ConvergedFile" -> convergedFile, "DownscanFile" -> downscanFile|>
    ]]
  ];
  reference = Quiet@Check[Get[convergedFile], $Failed];
  downscan = Quiet@Check[Get[downscanFile], $Failed];
  If[!AssociationQ[reference] || !AssociationQ[downscan],
    Return[Failure["V55MatchedAnalyticImportFailed", <||>]]
  ];
  candidate = SelectFirst[
    downscan["Rows"],
    #1["OuterOrder"] == 14 && #1["F2Order"] == 26 &,
    Missing["NotFound"]
  ];
  If[MissingQ[candidate],
    Return[Failure["V55MatchedAnalyticOrderMissing", <||>]]
  ];
  referenceBB =
    reference["SectorRecords"]["BBScan"]["Values"][18][40];
  value = N[
    reference["AnalyticProjectConventionValue"] - referenceBB +
      candidate["BBValue"],
    reference["WorkingPrecision"]
  ];
  <|
    "x" -> 4,
    "Value" -> value,
    "OrderDescription" -> <|
      "SS" -> "F2 summed through 20",
      "SBBS" -> "outer sum through 38",
      "BB" -> "outer sum through 14 and F2 sum through 26"
    |>,
    "MeasuredAnalyticSeconds" ->
      downscan["LoadSeconds"] + downscan["ScanSeconds"],
    "ReferenceConvergedOrders" -> reference["Orders"],
    "CandidateBBResidualToConvergedReference" ->
      candidate["ReferenceResidual"]
  |>
];

V55CompareMatchedAnalyticX4[
  result_Association,
  analyticRecord_Association
] := Module[
  {wp, sample, waypointPaperValue},
  wp = result["WorkingPrecision"];
  sample = V55SampleLiteratureSoftLimit[result, {4}];
  If[!AssociationQ[sample], Return[sample]];
  (* StandalonePaperValueFromRaw25 has already applied the common raw-to-paper
     convention map.  The matched analytic record is stored in that same
     project/paper convention, so no additional BB-parity subtraction belongs
     in the primary comparison. *)
  waypointPaperValue = sample["Rows"][[1]]["PaperValue"];
  <|
    "x" -> 4,
    "ConventionMap" ->
      "common raw-to-paper map applied once before comparison",
    "WaypointValueInAnalyticConvention" -> waypointPaperValue,
    "AnalyticValue" -> analyticRecord["Value"],
    "RelativeResidual" -> SoftLimitScalarResidual[
      waypointPaperValue, analyticRecord["Value"], wp
    ],
    "AnalyticOrderDescription" -> analyticRecord["OrderDescription"]
  |>
];

V55LegacyDoubleConventionCorrectionDiagnostic[
  result_Association,
  analyticRecord_Association,
  conventionCorrectionOrder_List:{16, 16}
] := Module[
  {wp, sample, paperValue, correction, doubleCorrectedValue},
  wp = result["WorkingPrecision"];
  sample = V55SampleLiteratureSoftLimit[result, {4}];
  If[!AssociationQ[sample], Return[sample]];
  paperValue = sample["Rows"][[1]]["PaperValue"];
  correction = SoftLimitEq103ConventionCorrection[
    4, wp, conventionCorrectionOrder
  ];
  doubleCorrectedValue = N[paperValue - correction, wp];
  <|
    "DiagnosticOnlyQ" -> True,
    "Description" ->
      "legacy extra subtraction after the raw-to-paper map; not a primary comparison",
    "ConventionCorrectionOrder" -> conventionCorrectionOrder,
    "DoubleCorrectedValue" -> doubleCorrectedValue,
    "RelativeResidual" -> SoftLimitScalarResidual[
      doubleCorrectedValue, analyticRecord["Value"], wp
    ]
  |>
];

V55PrintReport[result_Association] := Module[
  {timings, diagnostics, sample},
  timings = result["Timings"];
  diagnostics = result["PatchDiagnostics"];
  sample = result["InitialSample"];
  Print[Grid[
    {
      {"V5.5 method", result["Method"]},
      {"transport backend", result["TransportBackend"]},
      {"boundary transport", result["BoundaryTransportMethod"]},
      {"automatic ODE solver used?", result["AutomaticODESolverUsedQ"]},
      {"x range", result["LiteratureSlice"]["xRange"]},
      {"q range", {1/10, 1/10000}},
      {"local series order", result["WaypointRun"]["SeriesOrder"]},
      {"local comparison order",
        Lookup[result["WaypointRun"], "LowSeriesOrder", Missing["NotUsed"]]},
      {"patch builds (four SK branches)",
        result["WaypointRun"]["PatchBuildCount"]},
      {"maximum step/radius",
        diagnostics["MaximumStepRatio"]},
      {"maximum local truncation estimate",
        diagnostics["MaximumEstimatedRelativeTruncation"]},
      {"maximum endpoint ODE residual",
        diagnostics["MaximumEndpointODERelativeResidual"]},
      {"connection seconds", timings["ConnectionSeconds"]},
      {"boundary seconds in this run", timings["BoundarySecondsThisRun"]},
      {"waypoint seconds in this run", timings["WaypointSecondsThisRun"]},
      {"sampling seconds", sample["SamplingSeconds"]},
      {"sampling rebuilt patches?", sample["RebuiltPatchesQ"]}
    },
    Frame -> All,
    Alignment -> Left
  ]];
];

(* ::Section:: *)
(* ====================================================================== *)
(* Part 4B (V5.5) - literature soft-limit switchboard                    *)
(* ====================================================================== *)

(* Change only this small switchboard for routine V5.5 runs. *)
v55RunNow = True;

(* PyFlint is the new default.  Use "PatchwiseSeries" for the pure-Wolfram
   fallback.  Automatic probes the Python environment for flint and sympy. *)
v55TransportBackend = "PyFlint";
v55PyFlintPythonExecutable = Automatic;

(* Change only this line to switch between the bounded Smoke check and the
   production settings used in the validated x=1 -> 4 PyFLINT run. *)
v55Quality = "Smoke";
Switch[
  v55Quality,
  "Smoke",
    v55WorkingPrecision = 50;
    v55AccuracyGoal = 25;
    v55PrecisionGoal = 25;
    v55InfinityBoundaryAccuracyGoal = 8;
    v55BoundaryTolerance = 10^-8;
    v55WaypointRelativeTolerance = 10^-18;
    v55WaypointSeriesOrder = 60;
    v55WaypointLowSeriesOrder = 58,
  "Medium",
    v55WorkingPrecision = 80;
    v55AccuracyGoal = 45;
    v55PrecisionGoal = 45;
    v55InfinityBoundaryAccuracyGoal = 35;
    v55BoundaryTolerance = 10^-25;
    v55WaypointRelativeTolerance = 10^-28;
    v55WaypointSeriesOrder = 72;
    v55WaypointLowSeriesOrder = 70,
  _,
    Print["Bad v55Quality: ", v55Quality, ". Use Smoke or Medium."];
    v55RunNow = False
];
v55BoundaryProfiles = SoftLimitBoundaryProfiles[v55Quality];

(* Single endpoint.  After the path is built, use the second call below
   for N=10 or N=50 without rebuilding any patch. *)
v55InitialXValues = {4};

If[TrueQ[v55RunNow],
  v55Result = V55RunLiteratureSoftLimit[
    "TransportBackend" -> v55TransportBackend,
    "PyFlintPythonExecutable" -> v55PyFlintPythonExecutable,
    "WorkingPrecision" -> v55WorkingPrecision,
    "AccuracyGoal" -> v55AccuracyGoal,
    "PrecisionGoal" -> v55PrecisionGoal,
    "E2InfinityBoundaryAccuracyGoal" ->
      v55InfinityBoundaryAccuracyGoal,
    "BoundaryProfiles" -> v55BoundaryProfiles,
    "BoundaryTolerance" -> v55BoundaryTolerance,
    "WaypointRelativeTolerance" -> v55WaypointRelativeTolerance,
    "WaypointSeriesOrder" -> v55WaypointSeriesOrder,
    "WaypointLowSeriesOrder" -> v55WaypointLowSeriesOrder,
    "WaypointSafetyFactor" -> 2/5,
    "WaypointMultiplier" -> 2/3,
    "BoundaryWaypointMultiplier" -> 4/5,
    "XValues" -> v55InitialXValues,
    "CacheDirectory" -> Automatic,
    "Verbose" -> True
  ];

  If[AssociationQ[v55Result],
    (* Amortized scans: PyFLINT points were precomputed in one transport;
       the Mathematica backend samples its stored local coefficients. *)
    v55Scan10 = V55SampleLiteratureSoftLimit[
      v55Result, SoftLimitXGrids[][10]
    ];
    v55Scan50 = V55SampleLiteratureSoftLimit[
      v55Result, SoftLimitXGrids[][50]
    ];
    Print[
      "N=10 sampling seconds (no patch rebuild): ",
      v55Scan10["SamplingSeconds"]
    ];
    Print[
      "N=50 sampling seconds (no patch rebuild): ",
      v55Scan50["SamplingSeconds"]
    ];,
    Print["V5.5 run failed: ", v55Result]
  ];
];

(* Optional matched analytic comparison at x=4.  This uses the already computed
      sector-adaptive reference: SS F2->20, SB/BS outer->38, and BB
      outer->14 with F2->26.  Supply the two cached result files:

      v55Analytic = V55LoadMatchedAnalyticX4[
        ".../eq103_converged_x4.wl",
        ".../eq103_bb_downscan_x4.wl"
      ];
      v55AnalyticCheck = V55CompareMatchedAnalyticX4[
        v55Result, v55Analytic
      ];
*)
