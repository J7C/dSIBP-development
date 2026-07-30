<|"schema" -> "madstree_independent_validation_v1", "version" -> "v0.4",
 "task" -> "T4 vertex formula low-order reduce H-h round trips", "status" -> "passed",
 "checks" -> <|"contextsAndNormalization" -> True, "binaryMasterOrder" -> True, "positiveMatrices" -> True,
   "negativeMatrices" -> True, "probeAvoidsSingularLayers" -> True, "lowOrderReductionStatus" -> True,
   "lowOrderReductionCoefficients" -> True, "lowOrderReductionNoResidual" -> True, "customMasterOrder" -> True,
   "positiveLocalRoundTrip" -> True, "negativeLocalRoundTrip" -> True, "positiveGlobalTransform" -> True,
   "negativeGlobalTransform" -> True, "conventionOverrideRejected" -> True, "noGeneralLargeInverse" -> True|>,
 "passedCount" -> 15, "checkCount" -> 15, "sourceDigests" ->
  <|"Kernel\\Core\\VertexFamily.wl" -> "8226fab1c80ba20ee7c579637f0f4f985fc0990e2f19a2737a8a6c4d75c9f51b",
   "Kernel\\Core\\Conventions.wl" -> "df18a7e9e64aa9046d7755b2e79611d83c1a0ab28e5dfa64a9919bc987d7957b",
   "Kernel\\Formula\\TensorAtoms.wl" -> "de5151b7cadd75d39d7849d30cc350de9ab77f65656d1cf4b0285297af4c25d6",
   "Kernel\\Formula\\Recurrence.wl" -> "34f65df211b413186ba21db5f8a07e5556a744035eac1dff0ffc94e39a2a7565"|>,
 "normalization" -> 1, "masterOrder" -> {{0, 0}, {0, 1}, {1, 0}, {1, 1}}, "positiveConvention" -> "h=z^nu H_nu",
 "negativeConvention" -> "h=z^(-nu) H_nu", "probeRules" -> {a0 -> 7/6, k0 -> 11/3, k1 -> 2/5, k2 -> 3/7, nu1 -> 1/4,
   nu2 -> 2/7, z1 -> 5/4, z2 -> 7/5}, "inputExpression" -> -3*MSIntegral["11", {-1}, {1, 0}] +
   2*MSIntegral["11", {1}, {0, 0}], "independentCoefficientVector" ->
  {((-2*I)*(1 + a0)*k0*(k0^2 - k1^2 - k2^2))/(k0^4 + (k1^2 - k2^2)^2 - 2*k0^2*(k1^2 + k2^2)) -
    (3*k1)/(-1 + a0 + 2*nu1), (2*k2*(-k0^2 - k1^2 + k2^2)*(a0 + 2*nu2))/(k0^4 + (k1^2 - k2^2)^2 -
     2*k0^2*(k1^2 + k2^2)), ((-3*I)*k0)/(-1 + a0 + 2*nu1) - (2*k1*(k0^2 - k1^2 + k2^2)*(a0 + 2*nu1))/
     (k0^4 + (k1^2 - k2^2)^2 - 2*k0^2*(k1^2 + k2^2)), (3*k2)/(-1 + a0 + 2*nu1) +
    ((4*I)*k0*k1*k2*(-1 + a0 + 2*nu1 + 2*nu2))/(k0^4 + (k1^2 - k2^2)^2 - 2*k0^2*(k1^2 + k2^2))},
 "coefficientResidual" -> {0, 0, 0, 0}, "boundaryPoint" -> Missing["NotApplicable"],
 "path" -> Missing["NotApplicable"], "frobeniusOrder" -> Missing["NotApplicable"],
 "transportOrder" -> Missing["NotApplicable"], "matrixSeconds" -> 0.0002471, "reductionSeconds" -> 0.1232158,
 "transformSeconds" -> 1.2971593, "elapsedSeconds" -> 1.5551875`7.643327750399903|>
