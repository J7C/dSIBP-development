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
