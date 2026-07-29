<|"schema" -> "madstree_independent_validation_v1", "version" -> "v0.3",
 "task" -> "T6 MadStree-FlintNDE adapter save points and capability boundary", "status" -> "passed",
 "checks" -> <|"contextAndNormalization" -> True, "boundaryGeneratedWithoutDirectFallback" -> True,
   "invalidNamedSaveRejectedBeforePython" -> True, "ordinaryTransportComputed" -> True,
   "ordinaryThreeSavedPoints" -> True, "ordinarySavedPointFilesExist" -> True, "ordinaryAnalyticAgreement" -> True,
   "ordinaryFinalMatchesReturn" -> True, "ordinaryRefinement" -> True, "regularSingularTransportComputed" -> True,
   "regularSingularClassification" -> True, "regularSingularOrdinaryContinuation" -> True,
   "savedFrobeniusBoundary" -> True, "unsupportedPoleFailsClosed" -> True, "callerDirectoryOwnsSaveOutputs" -> True,
   "packageDirectoryUnchangedByRuntime" -> True|>, "passedCount" -> 16, "checkCount" -> 16,
 "sourceDigests" -> <|"Kernel\\Numerics\\FlintNDE.wl" ->
    "4182a84e8b2e5198d0eb917ed14433e1a509777a7e0c27d4bd96c745aca48b28", "Backend\\flintnde_transport.py" ->
    "ff2b6d64ffcb311dd67205d6d4beb5c217e37ea944f598041d5501dbd09740d2", "Kernel\\Numerics\\Boundary.wl" ->
    "e83b1df67867b5646e4040431c819b99f016f01d54ec092a53e5431ab6b48fea"|>,
 "normalization" -> <|"root" -> 1, "integral" -> "Integral[(-tau)^a Exp[I k0 tau]]"|>,
 "targetRules" -> {k0 -> 3, a -> 1/3}, "anchorRules" -> {k0 -> -8*I, a -> 1/3},
 "ordinaryPathRules" -> {k0 -> -8*I + (3 + 8*I)*msPathParameter11},
 "ordinaryAdaptivePath" -> {<|"real" -> "0", "imag" -> "0", "realRadius" -> "0", "imagRadius" -> "0"|>,
   <|"real" -> "0.42134812990607004059175217009959660904627187233234", "imag" -> "0",
    "realRadius" -> "[1.8448426192772072402794090887952234517882636706161e-60 +/- 4.35e-110]", "imagRadius" -> "0"|>,
   <|"real" -> "0.50000000000000000000000000000000000000000000000000", "imag" -> "0", "realRadius" -> "0",
    "imagRadius" -> "0"|>, <|"real" -> "0.72500000000000000555111512312578270211815834045410", "imag" -> "0",
    "realRadius" -> "[2.4637815291353542222623665322545272477700503879623e-60 +/- 4.26e-110]", "imagRadius" -> "0"|>,
   <|"real" -> "0.88793756945866074010984038051586066253818581276126", "imag" -> "0",
    "realRadius" -> "[5.2727047184112191346227314235840768138662490288448e-60 +/- 3.35e-110]", "imagRadius" -> "0"|>,
   <|"real" -> "1.0000000000000000000000000000000000000000000000000", "imag" -> "0", "realRadius" -> "0",
    "imagRadius" -> "0"|>}, "ordinarySaveInput" -> {{0, "save"}, {1/2, "save"}, {1, "save"}},
 "ordinarySavedPoints" -> {<|"schema" -> "flintnde_saved_point_v1", "sequence" -> 1, "coordinate" -> "0",
    "workingCoordinate" -> "0", "classification" -> "ordinary", "singularityIdentifier" -> Null, "role" -> "start",
    "resultType" -> "ordinary_vector", "result" -> {<|"real" -> "0.05581121947307807570116026960363911758601",
       "imag" -> "0", "realRadius" -> "[2.005463915149012758527718661338780783682e-62 +/- 2.99e-102]",
       "imagRadius" -> "0"|>}, "file" -> "flintnde_save_001.json", "stage" -> "ordinary",
    "sourceFile" -> "F:\\Agent-projects-nut\\dSibp_package\\package-MadStree\\independent-validation\\MadStree-v0.3-val\
idation-06-flintnde-adapter-capability\\results\\flintnde_save_points\\run-9f6613c8-a581-46ad-bdc5-d84050cdaff2\\ordina\
ry\\flintnde_save_001.json"|>, <|"schema" -> "flintnde_saved_point_v1", "sequence" -> 2,
    "coordinate" -> "0.5000000000000000000000000000000000000000", "workingCoordinate" ->
     "0.5000000000000000000000000000000000000000", "classification" -> "ordinary", "singularityIdentifier" -> Null,
    "role" -> "detour", "resultType" -> "ordinary_vector",
    "result" -> {<|"real" -> "0.1143643258369587349293953238128980343522",
       "imag" -> "-0.05930124879735751872583504873184949855791", "realRadius" -> "0", "imagRadius" -> "0"|>},
    "file" -> "flintnde_save_002.json", "stage" -> "ordinary", "sourceFile" -> "F:\\Agent-projects-nut\\dSibp_package\\\
package-MadStree\\independent-validation\\MadStree-v0.3-validation-06-flintnde-adapter-capability\\results\\flintnde_sa\
ve_points\\run-9f6613c8-a581-46ad-bdc5-d84050cdaff2\\ordinary\\flintnde_save_002.json"|>,
   <|"schema" -> "flintnde_saved_point_v1", "sequence" -> 3,
    "coordinate" -> "1.000000000000000000000000000000000000000", "workingCoordinate" ->
     "1.000000000000000000000000000000000000000", "classification" -> "ordinary", "singularityIdentifier" -> Null,
    "role" -> "target", "resultType" -> "ordinary_vector",
    "result" -> {<|"real" -> "-0.1031929020184436632973739033443403530943",
       "imag" -> "-0.1787353492764213747097479361569202264038", "realRadius" -> "0", "imagRadius" -> "0"|>},
    "file" -> "flintnde_save_003.json", "stage" -> "ordinary", "sourceFile" -> "F:\\Agent-projects-nut\\dSibp_package\\\
package-MadStree\\independent-validation\\MadStree-v0.3-validation-06-flintnde-adapter-capability\\results\\flintnde_sa\
ve_points\\run-9f6613c8-a581-46ad-bdc5-d84050cdaff2\\ordinary\\flintnde_save_003.json"|>},
 "ordinaryPhysicalK0" -> {-8*I, 3/2 - 4*I, 3}, "ordinaryResiduals" ->
  {0``39.74671908809498, 1.0021408592247500710878653`6.174018080970582*^-33,
   1.0889534659376275567066499`6.20430891547883*^-33}, "ordinaryRefinementDifference" ->
  "[5.6371828678510944006191606881585354306946566817480e-25 +/- 2.89e-75]", "singularSystem" -> HoldForm[{{2/t}}],
 "singularBoundary" -> HoldForm[{a -> 2, b -> 0, C -> {1}}], "singularOrdinaryAnchorRules" -> {k0 -> -8*I, a -> 1/3},
 "singularOrdinaryTargetRules" -> {k0 -> 3, a -> 1/3}, "singularExpectedFinal" ->
  -1.8489633982683592129156060660958981211891603025540107641794`44.61722431466213 -
   3.202498547136007271134574366265447590129086448602619266716`44.74076541524448*I,
 "singularFinalValue" -> -1.8489633982683592129156060660959094373945548139862`49.26692831403239 -
   3.2024985471360072711345743662654461194061252946367`49.50548894139223*I,
 "singularSavedPoints" -> {<|"schema" -> "flintnde_saved_point_v1", "sequence" -> 1, "coordinate" -> "0",
    "workingCoordinate" -> "0", "classification" -> "regular_singular", "singularityIdentifier" -> "finite_001",
    "role" -> "start", "resultType" -> "frobenius_boundary",
    "result" -> <|"terms" -> {<|"a" -> "2", "b" -> 0, "C" -> {"1"}|>}|>, "file" -> "flintnde_save_001.json",
    "stage" -> "singular", "sourceFile" -> "F:\\Agent-projects-nut\\dSibp_package\\package-MadStree\\independent-valida\
tion\\MadStree-v0.3-validation-06-flintnde-adapter-capability\\results\\flintnde_save_points\\run-295c31e7-5386-4f44-ba\
a8-9ea5085eb796\\singular\\flintnde_save_001.json"|>, <|"schema" -> "flintnde_saved_point_v1", "sequence" -> 1,
    "coordinate" -> "1.000000000000000000000000000000000000000", "workingCoordinate" ->
     "1.000000000000000000000000000000000000000", "classification" -> "ordinary", "singularityIdentifier" -> Null,
    "role" -> "target", "resultType" -> "ordinary_vector",
    "result" -> {<|"real" -> "-1.848963398268359212915606066095909437395",
       "imag" -> "-3.202498547136007271134574366265446119406", "realRadius" -> "0", "imagRadius" -> "0"|>},
    "file" -> "flintnde_save_001.json", "stage" -> "ordinary", "sourceFile" -> "F:\\Agent-projects-nut\\dSibp_package\\\
package-MadStree\\independent-validation\\MadStree-v0.3-validation-06-flintnde-adapter-capability\\results\\flintnde_sa\
ve_points\\run-295c31e7-5386-4f44-baa8-9ea5085eb796\\ordinary\\flintnde_save_001.json"|>},
 "unsupportedClassificationEvidence" -> <|"status" -> "failed", "errorType" -> "ValueError",
   "error" -> "MadStree requires a regular_singular start and ordinary target; got non_fuchsian_input_basis, ordinary",
   "traceback" -> "Traceback (most recent call last):\n  File \
\"F:\\Agent-projects-nut\\dSibp_package\\package-MadStree\\versions\\MadStree-v0.3\\Backend\\flintnde_transport.py\", \
line 244, in main\n    result = _run(_load_input(input_path))\n  File \
\"F:\\Agent-projects-nut\\dSibp_package\\package-MadStree\\versions\\MadStree-v0.3\\Backend\\flintnde_transport.py\", \
line 123, in _run\n    raise ValueError(\n    ...<2 lines>...\n    )\nValueError: MadStree requires a regular_singular \
start and ordinary target; got non_fuchsian_input_basis, ordinary\n"|>, "boundarySeriesOrder" -> 24,
 "singularTransportOrder" -> {72, 96}, "ordinaryTransportOrder" -> {72, 96}, "workingPrecision" -> 50,
 "targetRelativeError" -> "1e-22", "boundarySeconds" -> 0.0209248, "ordinarySeconds" -> 1.2186072,
 "singularSeconds" -> 1.6489193, "failClosedSeconds" -> 0.5363884, "elapsedSeconds" -> 5.0128887`8.151633055676859,
 "ordinarySaveSummary" -> "F:\\Agent-projects-nut\\dSibp_package\\package-MadStree\\independent-validation\\MadStree-v0\
.3-validation-06-flintnde-adapter-capability\\results\\flintnde_save_points\\run-9f6613c8-a581-46ad-bdc5-d84050cdaff2\\\
madstree_flintnde_save_points.json", "singularSaveSummary" -> "F:\\Agent-projects-nut\\dSibp_package\\package-MadStree\
\\independent-validation\\MadStree-v0.3-validation-06-flintnde-adapter-capability\\results\\flintnde_save_points\\run-2\
95c31e7-5386-4f44-baa8-9ea5085eb796\\madstree_flintnde_save_points.json",
 "runtimeDirectory" -> "F:\\Agent-projects-nut\\dSibp_package\\package-MadStree\\independent-validation\\MadStree-v0.3-\
validation-06-flintnde-adapter-capability\\"|>
