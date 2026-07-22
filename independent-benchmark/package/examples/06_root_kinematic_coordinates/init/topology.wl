<|"name" -> "016BubbleBridgeTwoExternalLegs",
 "vertexData" -> {{v1, "+"}, {v2, "+"}, {v3, "+"}},
 "vertexIds" -> {v1, v2, v3}, "vertexSignAssoc" ->
  <|v1 -> "+", v2 -> "+", v3 -> "+"|>,
 "lines" -> {<|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
    "nu" -> nu1, "bbType" -> "h", "massType" -> "massive", "skType" -> "++",
    "state" -> "full", "thetaConvention" -> "mergedTwoTheta",
    "packType" -> "massiveFull", "masslessN1ReferenceEndpoint" ->
     Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
     Missing["NotApplicable"], "functionSystem" ->
     <|"preset" -> "h", "variable" -> dSIBP`Private`x,
      "P" -> (1 + 2*nu1)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
      "W" -> ((-4*I)*E^(Pi*Im[nu1])*dSIBP`Private`x^(-1 - 2*nu1))/Pi,
      "WT" -> Automatic, "shrinkBShift" -> 1, "shrinkZeroPointShift" ->
       2*nu1|>, "compiledFunctionSystem" -> <|"status" -> "compiled",
      "input" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x,
        "P" -> (1 + 2*nu1)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0,
         1}}, "W" -> ((-4*I)*E^(Pi*Im[nu1])*dSIBP`Private`x^(-1 - 2*nu1))/Pi,
        "WT" -> Automatic, "shrinkBShift" -> 1, "shrinkZeroPointShift" ->
         2*nu1|>, "variable" -> dSIBP`Private`x,
      "P" -> (1 + 2*nu1)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
      "W" -> ((-4*I)*E^(Pi*Im[nu1])*dSIBP`Private`x^(-1 - 2*nu1))/Pi,
      "A0" -> {{0, 1}, {-1, -((1 + 2*nu1)/dSIBP`Private`x)}},
      "AT" -> {{0, 1}, {-1, -((1 + 2*nu1)/dSIBP`Private`x)}},
      "WT" -> ((-4*I)*E^(Pi*Im[nu1])*dSIBP`Private`x^(-1 - 2*nu1))/Pi,
      "derivativeTerms" -> {<|"sourceState" -> 0, "targetState" -> 1,
         "xPower" -> 0, "coefficient" -> 1|>, <|"sourceState" -> 1,
         "targetState" -> 0, "xPower" -> 0, "coefficient" -> -1|>,
        <|"sourceState" -> 1, "targetState" -> 1, "xPower" -> -1,
         "coefficient" -> -1 - 2*nu1|>}, "shrinkTerms" ->
       {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu1]))/Pi, "xPower" -> -1 - 2*nu1,
         "bShift" -> 1, "zeroPointShift" -> 2*nu1|>},
      "shrinkZeroPointShift" -> 2*nu1|>, "rawMomentum" -> q,
    "loopLineQ" -> True, "bridgeQ" -> False, "linePowerMode" -> "indexed"|>,
   <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> k + q, "nu" -> nu2,
    "bbType" -> "h", "massType" -> "massive", "skType" -> "++",
    "state" -> "full", "thetaConvention" -> "mergedTwoTheta",
    "packType" -> "massiveFull", "masslessN1ReferenceEndpoint" ->
     Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
     Missing["NotApplicable"], "functionSystem" ->
     <|"preset" -> "h", "variable" -> dSIBP`Private`x,
      "P" -> (1 + 2*nu2)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
      "W" -> ((-4*I)*E^(Pi*Im[nu2])*dSIBP`Private`x^(-1 - 2*nu2))/Pi,
      "WT" -> Automatic, "shrinkBShift" -> 1, "shrinkZeroPointShift" ->
       2*nu2|>, "compiledFunctionSystem" -> <|"status" -> "compiled",
      "input" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x,
        "P" -> (1 + 2*nu2)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0,
         1}}, "W" -> ((-4*I)*E^(Pi*Im[nu2])*dSIBP`Private`x^(-1 - 2*nu2))/Pi,
        "WT" -> Automatic, "shrinkBShift" -> 1, "shrinkZeroPointShift" ->
         2*nu2|>, "variable" -> dSIBP`Private`x,
      "P" -> (1 + 2*nu2)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
      "W" -> ((-4*I)*E^(Pi*Im[nu2])*dSIBP`Private`x^(-1 - 2*nu2))/Pi,
      "A0" -> {{0, 1}, {-1, -((1 + 2*nu2)/dSIBP`Private`x)}},
      "AT" -> {{0, 1}, {-1, -((1 + 2*nu2)/dSIBP`Private`x)}},
      "WT" -> ((-4*I)*E^(Pi*Im[nu2])*dSIBP`Private`x^(-1 - 2*nu2))/Pi,
      "derivativeTerms" -> {<|"sourceState" -> 0, "targetState" -> 1,
         "xPower" -> 0, "coefficient" -> 1|>, <|"sourceState" -> 1,
         "targetState" -> 0, "xPower" -> 0, "coefficient" -> -1|>,
        <|"sourceState" -> 1, "targetState" -> 1, "xPower" -> -1,
         "coefficient" -> -1 - 2*nu2|>}, "shrinkTerms" ->
       {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu2]))/Pi, "xPower" -> -1 - 2*nu2,
         "bShift" -> 1, "zeroPointShift" -> 2*nu2|>},
      "shrinkZeroPointShift" -> 2*nu2|>, "rawMomentum" -> k + q,
    "loopLineQ" -> True, "bridgeQ" -> False, "linePowerMode" -> "indexed"|>,
   <|"id" -> 3, "endpoints" -> {v2, v3}, "momentum" -> p1 + p2,
    "treeEnergy" -> bridgeEnergy, "nu" -> nu3, "bbType" -> "h",
    "massType" -> "massive", "skType" -> "++", "state" -> "full",
    "thetaConvention" -> "mergedTwoTheta", "packType" -> "massiveFull",
    "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"],
    "masslessN1OppositeEndpoint" -> Missing["NotApplicable"],
    "functionSystem" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x,
      "P" -> (1 + 2*nu3)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
      "W" -> ((-4*I)*E^(Pi*Im[nu3])*dSIBP`Private`x^(-1 - 2*nu3))/Pi,
      "WT" -> Automatic, "shrinkBShift" -> 1, "shrinkZeroPointShift" ->
       2*nu3|>, "compiledFunctionSystem" -> <|"status" -> "compiled",
      "input" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x,
        "P" -> (1 + 2*nu3)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0,
         1}}, "W" -> ((-4*I)*E^(Pi*Im[nu3])*dSIBP`Private`x^(-1 - 2*nu3))/Pi,
        "WT" -> Automatic, "shrinkBShift" -> 1, "shrinkZeroPointShift" ->
         2*nu3|>, "variable" -> dSIBP`Private`x,
      "P" -> (1 + 2*nu3)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
      "W" -> ((-4*I)*E^(Pi*Im[nu3])*dSIBP`Private`x^(-1 - 2*nu3))/Pi,
      "A0" -> {{0, 1}, {-1, -((1 + 2*nu3)/dSIBP`Private`x)}},
      "AT" -> {{0, 1}, {-1, -((1 + 2*nu3)/dSIBP`Private`x)}},
      "WT" -> ((-4*I)*E^(Pi*Im[nu3])*dSIBP`Private`x^(-1 - 2*nu3))/Pi,
      "derivativeTerms" -> {<|"sourceState" -> 0, "targetState" -> 1,
         "xPower" -> 0, "coefficient" -> 1|>, <|"sourceState" -> 1,
         "targetState" -> 0, "xPower" -> 0, "coefficient" -> -1|>,
        <|"sourceState" -> 1, "targetState" -> 1, "xPower" -> -1,
         "coefficient" -> -1 - 2*nu3|>}, "shrinkTerms" ->
       {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu3]))/Pi, "xPower" -> -1 - 2*nu3,
         "bShift" -> 1, "zeroPointShift" -> 2*nu3|>},
      "shrinkZeroPointShift" -> 2*nu3|>, "rawMomentum" -> p1 + p2,
    "loopLineQ" -> False, "bridgeQ" -> True, "linePowerMode" ->
     "fixedCoefficient"|>}, "extLegs" -> {{leg1, v3, p1}, {leg2, v3, p2}},
 "vertexEnergies" -> <|v1 -> E1, v2 -> E2, v3 -> E3|>,
 "activeVertexIds" -> {v1, v2, v3}, "fixedAVertexValues" -> <||>,
 "loopMomenta" -> {q}, "ibpMode" -> "full", "graphLoopCount" -> 1,
 "graphTopologyAudit" -> <|"status" -> "valid", "vertexCount" -> 3,
   "inputLineCount" -> 3, "internalLineCount" -> 3,
   "activeLineIndices" -> {1, 2, 3}, "shrunkLineIndices" -> {},
   "connectedComponentCount" -> 1, "graphLoopCount" -> 1,
   "bridgeLineIndices" -> {3}, "cycleLineIndices" -> {1, 2},
   "selfLoopLineIndices" -> {}, "incidenceMatrix" ->
    {{1, 1, 0}, {-1, -1, 1}, {0, 0, -1}}, "cycleSpaceDimension" -> 1,
   "issues" -> {}|>, "loopMomentumRoutingAudit" ->
  <|"status" -> "valid", "ibpMode" -> "full", "loopMomenta" -> {q},
   "loopCoefficientMatrix" -> {{1}, {1}, {0}}, "loopCoefficientRank" -> 1,
   "lineExternalResiduals" -> {0, k, p1 + p2}, "referenceLineIndices" -> {1},
   "referenceLoopMatrix" -> {{1}}, "referenceExternalResiduals" -> {0},
   "shiftInvariantLineResiduals" -> {0, k, p1 + p2},
   "incidenceCycleResidual" -> {{0}, {0}, {0}}, "issues" -> {}|>,
 "normalizedLineMomenta" -> {q, k + q, p1 + p2},
 "momentumDeclarationAudit" -> <|"status" -> "exact", "ibpMode" -> "full",
   "loopExternalMomenta" -> {k}, "independentExternalMomenta" ->
    {p1, p2, p1 + p2}, "requiredLoopExternalDirections" -> {k},
   "requiredIndependentMomentumMagnitudes" -> {-p1 - p2, -p1, -p2},
   "momentumAtoms" -> {k, p1, p2}, "loopExternalAudit" ->
    <|"status" -> "exact", "atoms" -> {k, p1, p2}, "requiredExpressions" ->
      {k}, "userExpressions" -> {k}, "requiredBasisDirections" -> {k},
     "userBasisDirections" -> {k}, "missingDirections" -> {},
     "extraDirections" -> {}, "userDependencyVectors" -> {},
     "requiredRank" -> 1, "userRank" -> 1, "unionRank" -> 1,
     "invalidRequiredPositions" -> {}, "invalidUserPositions" -> {}|>,
   "independentExternalAudit" -> <|"status" -> "exact",
     "atoms" -> {k, p1, p2}, "loopGramRank" -> 1, "requiredMomenta" ->
      {-p1 - p2, -p1, -p2}, "userMomenta" -> {p1, p2, p1 + p2},
     "missingMagnitudeSquares" -> {}, "extraMagnitudeSquares" -> {},
     "requiredIndependentMagnitudeCount" -> 3,
     "userIndependentMagnitudeCount" -> 3, "invalidRequiredPositions" -> {},
     "invalidUserPositions" -> {}, "invalidLoopPositions" -> {},
     "missingQuadraticRows" -> {}, "extraQuadraticRows" -> {}|>,
   "capabilities" -> <|"initializationUsableQ" -> True,
     "timeIBPUsableQ" -> True, "momentumIBPUsableQ" -> True,
     "derivativeUsableQ" -> True, "inverseKinematicsUsableQ" -> True|>,
   "issues" -> {}|>, "capabilities" -> <|"initializationUsableQ" -> True,
   "timeIBPUsableQ" -> True, "momentumIBPUsableQ" -> True,
   "derivativeUsableQ" -> True, "inverseKinematicsUsableQ" -> True|>,
 "cycleLineIndices" -> {1, 2}, "bridgeLineIndices" -> {3},
 "loopExternalMomenta" -> {k}, "effectiveLoopExternalMomenta" -> {k},
 "independentExternalMomenta" -> {p1, p2, p1 + p2},
 "momentumDecompositionBasis" -> {q, k, p1, p2},
 "fixedExternalVectorAtoms" -> {p1, p2}, "externalMomenta" -> {k},
 "externalLegMomenta" -> {p1, p2, p1 + p2}, "rawExternalInvariantRules" ->
  {sp[k, k] -> ss11^2}, "externalInvariantRules" -> {sp[k, k] -> ss11^2},
 "rawExternalLegInvariantRules" -> {sp[p1, p1] -> sE1^2, sp[p2, p2] -> sE2^2,
   sp[p1 + p2, p1 + p2] -> sE3^2}, "externalLegInvariantRules" ->
  {sp[p1, p1] -> sE1^2, sp[p2, p2] -> sE2^2, sp[p1 + p2, p1 + p2] -> sE3^2},
 "kinematicRules" -> Automatic, "kinematicCoordinateAudit" ->
  <|"status" -> "complete", "source" -> "default",
   "baseCoordinateData" -> {<|"baseIndex" -> 1, "kind" -> "loopExternalGram",
      "inputExpression" -> sp[k, k], "internalVariable" -> kk[1, 1],
      "defaultVariable" -> ss11, "defaultRHS" -> ss11^2|>,
     <|"occurrenceIndex" -> 1, "momentum" -> p1, "squaredExpression" ->
       sp[p1, p1], "magnitudeExpression" -> Sqrt[sp[p1, p1]],
      "gramVector" -> {0, 0, 0, 1, 0, 0}, "baseCoefficients" -> {0, 1, 0, 0},
      "independentQ" -> True, "externalLegIndex" -> 1, "userVariable" -> sE1,
      "defaultSquaredExpression" -> sE1^2, "baseIndex" -> 2,
      "kind" -> "externalLegMagnitude", "inputExpression" -> sp[p1, p1],
      "internalVariable" -> dSIBP`Private`externalLegSquaredCoordinate[1],
      "defaultVariable" -> sE1, "defaultRHS" -> sE1^2|>,
     <|"occurrenceIndex" -> 2, "momentum" -> p2, "squaredExpression" ->
       sp[p2, p2], "magnitudeExpression" -> Sqrt[sp[p2, p2]],
      "gramVector" -> {0, 0, 0, 0, 0, 1}, "baseCoefficients" -> {0, 0, 1, 0},
      "independentQ" -> True, "externalLegIndex" -> 2, "userVariable" -> sE2,
      "defaultSquaredExpression" -> sE2^2, "baseIndex" -> 3,
      "kind" -> "externalLegMagnitude", "inputExpression" -> sp[p2, p2],
      "internalVariable" -> dSIBP`Private`externalLegSquaredCoordinate[2],
      "defaultVariable" -> sE2, "defaultRHS" -> sE2^2|>,
     <|"occurrenceIndex" -> 3, "momentum" -> p1 + p2,
      "squaredExpression" -> sp[p1 + p2, p1 + p2], "magnitudeExpression" ->
       Sqrt[sp[p1 + p2, p1 + p2]], "gramVector" -> {0, 0, 0, 1, 2, 1},
      "baseCoefficients" -> {0, 0, 0, 1}, "independentQ" -> True,
      "externalLegIndex" -> 3, "userVariable" -> sE3,
      "defaultSquaredExpression" -> sE3^2, "baseIndex" -> 4,
      "kind" -> "externalLegMagnitude", "inputExpression" ->
       sp[p1 + p2, p1 + p2], "internalVariable" ->
       dSIBP`Private`externalLegSquaredCoordinate[3],
      "defaultVariable" -> sE3, "defaultRHS" -> sE3^2|>},
   "baseCoordinateOrder" -> {sp[k, k], sp[p1, p1], sp[p2, p2],
     sp[p1 + p2, p1 + p2]}, "baseCoordinateCount" -> 4,
   "defaultRules" -> {sp[k, k] -> ss11^2, sp[p1, p1] -> sE1^2,
     sp[p2, p2] -> sE2^2, sp[p1 + p2, p1 + p2] -> sE3^2},
   "selectionTemplate" -> "kinematicRules" -> {sp[k, k] -> ss11^2,
      sp[p1, p1] -> sE1^2, sp[p2, p2] -> sE2^2, sp[p1 + p2, p1 + p2] ->
       sE3^2}, "selectedRules" -> {sp[k, k] -> ss11^2, sp[p1, p1] -> sE1^2,
     sp[p2, p2] -> sE2^2, sp[p1 + p2, p1 + p2] -> sE3^2},
   "selectedUserVariables" -> {ss11, sE1, sE2, sE3},
   "userParameterOrder" -> {ss11, sE1, sE2, sE3},
   "coordinateMatrix" -> {{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, 0}, {0, 0, 0,
     1}}, "coordinateRank" -> 4, "parameterJacobian" ->
    {{2*ss11, 0, 0, 0}, {0, 2*sE1, 0, 0}, {0, 0, 2*sE2, 0},
     {0, 0, 0, 2*sE3}}, "parameterRank" -> 4, "missingDirections" -> {},
   "ruleMissingDirections" -> {}, "parameterMissingDirections" -> {},
   "ruleMissingDirectionExpressions" -> {},
   "parameterMissingDirectionExpressions" -> {}, "ruleDependencies" -> {},
   "ruleDependencyResiduals" -> {}, "parameterDependencies" -> {},
   "constraintResiduals" -> {}, "unsupportedRulePositions" -> {},
   "completeQ" -> True, "overcompleteQ" -> False,
   "inverseAvailableQ" -> True, "resolvedRules" ->
    {sp[k, k] -> ss11^2, sp[p1, p1] -> sE1^2, sp[p2, p2] -> sE2^2,
     sp[p1 + p2, p1 + p2] -> sE3^2}, "baseSquaredUserExpressions" ->
    {ss11^2, sE1^2, sE2^2, sE3^2}, "baseRootUserExpressions" ->
    {ss11, sE1, sE2, sE3}, "appearingNoLoopMagnitudeMomenta" ->
    {p1, p2, p1 + p2}, "independentNoLoopMagnitudeMomenta" ->
    {p1, p2, p1 + p2}, "dependentMagnitudeBindings" -> {},
   "rawLoopRules" -> {sp[k, k] -> ss11^2}, "resolvedLoopRules" ->
    {sp[k, k] -> ss11^2}, "rawExternalLegRules" ->
    {sp[p1, p1] -> sE1^2, sp[p2, p2] -> sE2^2, sp[p1 + p2, p1 + p2] ->
      sE3^2}, "resolvedExternalLegRules" -> {sp[p1, p1] -> sE1^2,
     sp[p2, p2] -> sE2^2, sp[p1 + p2, p1 + p2] -> sE3^2},
   "message" -> "\:52a8\:529b\:5b66\:53d8\:91cf\:5b8c\:5907\:ff0c\:4e14\:5f53\
\:524d\:7b80\:5355\:5750\:6807\:89c4\:5219\:53ef\:53cd\:5411\:8f6c\:6362\
\:3002"|>, "ispData" -> {}, "nV" -> 3, "nE" -> 3, "nL" -> 1, "nK" -> 1,
 "bMatrix" -> {{1, 1, 0}, {-1, -1, 1}, {0, 0, -1}},
 "vertexLines" -> {{{1, 1}, {2, 1}}, {{1, -1}, {2, -1}, {3, 1}}, {{3, -1}}},
 "loopCoeffMatrix" -> {{1}, {1}, {0}}, "externalCoeffMatrix" ->
  {{0}, {1}, {0}}, "externalPartList" -> {0, k, p1 + p2},
 "rawNumericRules" -> {}, "numericRules" -> {}, "sampleDiscreteRules" -> {},
 "seedPreset" -> "quickCheck", "seedRanges" -> <|"a" -> {0}, "b" -> {0},
   "isp" -> {0}, "sampleOnly" -> True|>, "generatorSeedRanges" -> {},
 "seedOptions" -> <|"DiscreteMode" -> "sample", "MaxSeedRuleCount" -> 200,
   "MaxDiscreteRuleCount" -> 64, "MaxEquationCount" -> 80,
   "MaxShrinkSectorDepth" -> Automatic, "MaxShrinkSectorCount" -> 16|>,
 "unknownSeedPreset" -> None, "zeroPointRules" ->
  {a0[v1] -> alpha1, a0[v2] -> alpha2, a0[v3] -> alpha3, b0[1] -> beta1,
   b0[2] -> beta2, b0[3] -> beta3}, "shrinkPrefactorRules" -> {},
 "symmetryRules" -> {}, "thetaBoundarySignOffset" -> Automatic,
 "kiraOrdering" -> <||>, "sectorVertexRepresentativeMap" ->
  <|v1 -> v1, v2 -> v2, v3 -> v3|>, "sectorMetadata" ->
  <|"caseName" -> "016BubbleBridgeTwoExternalLegs",
   "sectorShrunkLines" -> {}, "sectorKey" -> "top",
   "aSlotMode" -> "compactActiveSlots", "sectorVertexRepresentativeMap" ->
    <|v1 -> v1, v2 -> v2, v3 -> v3|>, "vertexIdToOriginalASlot" ->
    <|v1 -> 1, v2 -> 2, v3 -> 3|>, "vertexIdToCompactASlot" ->
    <|v1 -> 1, v2 -> 2, v3 -> 3|>, "vertexSlots" ->
    {<|"slot" -> 1, "vertexId" -> v1, "representativeVertexId" -> v1,
      "aSymbol" -> a[v1], "activeQ" -> True, "fixedValue" -> None,
      "compactASlot" -> 1|>, <|"slot" -> 2, "vertexId" -> v2,
      "representativeVertexId" -> v2, "aSymbol" -> a[v2], "activeQ" -> True,
      "fixedValue" -> None, "compactASlot" -> 2|>,
     <|"slot" -> 3, "vertexId" -> v3, "representativeVertexId" -> v3,
      "aSymbol" -> a[v3], "activeQ" -> True, "fixedValue" -> None,
      "compactASlot" -> 3|>}, "compactASlots" ->
    {<|"compactSlot" -> 1, "representativeVertexId" -> v1,
      "originalVertexIds" -> {v1}, "originalSlots" -> {1},
      "aSymbol" -> a[v1]|>, <|"compactSlot" -> 2, "representativeVertexId" ->
       v2, "originalVertexIds" -> {v2}, "originalSlots" -> {2},
      "aSymbol" -> a[v2]|>, <|"compactSlot" -> 3, "representativeVertexId" ->
       v3, "originalVertexIds" -> {v3}, "originalSlots" -> {3},
      "aSymbol" -> a[v3]|>}, "activeASlots" -> {1, 2, 3},
   "lineSlots" -> {<|"slot" -> 1, "lineId" -> 1, "packType" -> "massiveFull",
      "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v2},
      "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" ->
       Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
       Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2},
      "endpointCompactASlots" -> {1, 2}, "linePowerMode" -> "indexed",
      "bPosition" -> 1, "bSymbol" -> b[1], "nPositions" -> {2, 3},
      "packTemplate" -> {b[1], n[1, 1], n[1, 2]}|>,
     <|"slot" -> 2, "lineId" -> 2, "packType" -> "massiveFull",
      "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v2},
      "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" ->
       Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
       Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2},
      "endpointCompactASlots" -> {1, 2}, "linePowerMode" -> "indexed",
      "bPosition" -> 1, "bSymbol" -> b[2], "nPositions" -> {2, 3},
      "packTemplate" -> {b[2], n[2, 1], n[2, 2]}|>,
     <|"slot" -> 3, "lineId" -> 3, "packType" -> "massiveFull",
      "massType" -> "massive", "state" -> "full", "endpoints" -> {v2, v3},
      "originalEndpoints" -> {v2, v3}, "masslessN1ReferenceEndpoint" ->
       Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
       Missing["NotApplicable"], "endpointOriginalASlots" -> {2, 3},
      "endpointCompactASlots" -> {2, 3}, "linePowerMode" ->
       "fixedCoefficient", "bPosition" -> Missing["FixedLinePower"],
      "bSymbol" -> None, "nPositions" -> {1, 2}, "packTemplate" ->
       {n[3, 1], n[3, 2]}|>}, "lineIdToSlot" -> <|1 -> 1, 2 -> 2, 3 -> 3|>,
   "bSymbolToLineSlot" -> <|b[1] -> 1, b[2] -> 2|>, "ispSlots" -> {}|>,
 "sectorMetadataList" -> {<|"caseName" -> "016BubbleBridgeTwoExternalLegs",
    "sectorShrunkLines" -> {}, "sectorKey" -> "top",
    "aSlotMode" -> "compactActiveSlots", "sectorVertexRepresentativeMap" ->
     <|v1 -> v1, v2 -> v2, v3 -> v3|>, "vertexIdToOriginalASlot" ->
     <|v1 -> 1, v2 -> 2, v3 -> 3|>, "vertexIdToCompactASlot" ->
     <|v1 -> 1, v2 -> 2, v3 -> 3|>, "vertexSlots" ->
     {<|"slot" -> 1, "vertexId" -> v1, "representativeVertexId" -> v1,
       "aSymbol" -> a[v1], "activeQ" -> True, "fixedValue" -> None,
       "compactASlot" -> 1|>, <|"slot" -> 2, "vertexId" -> v2,
       "representativeVertexId" -> v2, "aSymbol" -> a[v2], "activeQ" -> True,
       "fixedValue" -> None, "compactASlot" -> 2|>,
      <|"slot" -> 3, "vertexId" -> v3, "representativeVertexId" -> v3,
       "aSymbol" -> a[v3], "activeQ" -> True, "fixedValue" -> None,
       "compactASlot" -> 3|>}, "compactASlots" ->
     {<|"compactSlot" -> 1, "representativeVertexId" -> v1,
       "originalVertexIds" -> {v1}, "originalSlots" -> {1},
       "aSymbol" -> a[v1]|>, <|"compactSlot" -> 2,
       "representativeVertexId" -> v2, "originalVertexIds" -> {v2},
       "originalSlots" -> {2}, "aSymbol" -> a[v2]|>,
      <|"compactSlot" -> 3, "representativeVertexId" -> v3,
       "originalVertexIds" -> {v3}, "originalSlots" -> {3},
       "aSymbol" -> a[v3]|>}, "activeASlots" -> {1, 2, 3},
    "lineSlots" -> {<|"slot" -> 1, "lineId" -> 1, "packType" ->
        "massiveFull", "massType" -> "massive", "state" -> "full",
       "endpoints" -> {v1, v2}, "originalEndpoints" -> {v1, v2},
       "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"],
       "masslessN1OppositeEndpoint" -> Missing["NotApplicable"],
       "endpointOriginalASlots" -> {1, 2}, "endpointCompactASlots" -> {1, 2},
       "linePowerMode" -> "indexed", "bPosition" -> 1, "bSymbol" -> b[1],
       "nPositions" -> {2, 3}, "packTemplate" -> {b[1], n[1, 1], n[1, 2]}|>,
      <|"slot" -> 2, "lineId" -> 2, "packType" -> "massiveFull",
       "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v2},
       "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" ->
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2},
       "endpointCompactASlots" -> {1, 2}, "linePowerMode" -> "indexed",
       "bPosition" -> 1, "bSymbol" -> b[2], "nPositions" -> {2, 3},
       "packTemplate" -> {b[2], n[2, 1], n[2, 2]}|>,
      <|"slot" -> 3, "lineId" -> 3, "packType" -> "massiveFull",
       "massType" -> "massive", "state" -> "full", "endpoints" -> {v2, v3},
       "originalEndpoints" -> {v2, v3}, "masslessN1ReferenceEndpoint" ->
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
        Missing["NotApplicable"], "endpointOriginalASlots" -> {2, 3},
       "endpointCompactASlots" -> {2, 3}, "linePowerMode" ->
        "fixedCoefficient", "bPosition" -> Missing["FixedLinePower"],
       "bSymbol" -> None, "nPositions" -> {1, 2}, "packTemplate" ->
        {n[3, 1], n[3, 2]}|>}, "lineIdToSlot" -> <|1 -> 1, 2 -> 2, 3 -> 3|>,
    "bSymbolToLineSlot" -> <|b[1] -> 1, b[2] -> 2|>, "ispSlots" -> {}|>,
   <|"caseName" -> "016BubbleBridgeTwoExternalLegs_sector_e1",
    "sectorShrunkLines" -> {1}, "sectorKey" -> "e1",
    "aSlotMode" -> "compactActiveSlots", "sectorVertexRepresentativeMap" ->
     <|v1 -> v1, v2 -> v1, v3 -> v3|>, "vertexIdToOriginalASlot" ->
     <|v1 -> 1, v2 -> 2, v3 -> 3|>, "vertexIdToCompactASlot" ->
     <|v1 -> 1, v2 -> 1, v3 -> 2|>, "vertexSlots" ->
     {<|"slot" -> 1, "vertexId" -> v1, "representativeVertexId" -> v1,
       "aSymbol" -> a[v1], "activeQ" -> True, "fixedValue" -> None,
       "compactASlot" -> 1|>, <|"slot" -> 2, "vertexId" -> v2,
       "representativeVertexId" -> v1, "aSymbol" -> a[v2],
       "activeQ" -> False, "fixedValue" -> 0, "compactASlot" -> 1|>,
      <|"slot" -> 3, "vertexId" -> v3, "representativeVertexId" -> v3,
       "aSymbol" -> a[v3], "activeQ" -> True, "fixedValue" -> None,
       "compactASlot" -> 2|>}, "compactASlots" ->
     {<|"compactSlot" -> 1, "representativeVertexId" -> v1,
       "originalVertexIds" -> {v1, v2}, "originalSlots" -> {1, 2},
       "aSymbol" -> a[v1]|>, <|"compactSlot" -> 2,
       "representativeVertexId" -> v3, "originalVertexIds" -> {v3},
       "originalSlots" -> {3}, "aSymbol" -> a[v3]|>},
    "activeASlots" -> {1, 2}, "lineSlots" ->
     {<|"slot" -> 1, "lineId" -> 1, "packType" -> "shrunk",
       "massType" -> "massive", "state" -> "shrunk", "endpoints" -> {v1, v1},
       "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" ->
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2},
       "endpointCompactASlots" -> {1, 1}, "linePowerMode" -> "indexed",
       "bPosition" -> 1, "bSymbol" -> bS[1], "nPositions" -> {},
       "packTemplate" -> {bS[1]}|>, <|"slot" -> 2, "lineId" -> 2,
       "packType" -> "massiveFull", "massType" -> "massive",
       "state" -> "full", "endpoints" -> {v1, v1}, "originalEndpoints" ->
        {v1, v2}, "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"],
       "masslessN1OppositeEndpoint" -> Missing["NotApplicable"],
       "endpointOriginalASlots" -> {1, 2}, "endpointCompactASlots" -> {1, 1},
       "linePowerMode" -> "indexed", "bPosition" -> 1, "bSymbol" -> b[2],
       "nPositions" -> {2, 3}, "packTemplate" -> {b[2], n[2, 1], n[2, 2]}|>,
      <|"slot" -> 3, "lineId" -> 3, "packType" -> "massiveFull",
       "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v3},
       "originalEndpoints" -> {v2, v3}, "masslessN1ReferenceEndpoint" ->
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
        Missing["NotApplicable"], "endpointOriginalASlots" -> {2, 3},
       "endpointCompactASlots" -> {1, 2}, "linePowerMode" ->
        "fixedCoefficient", "bPosition" -> Missing["FixedLinePower"],
       "bSymbol" -> None, "nPositions" -> {1, 2}, "packTemplate" ->
        {n[3, 1], n[3, 2]}|>}, "lineIdToSlot" -> <|1 -> 1, 2 -> 2, 3 -> 3|>,
    "bSymbolToLineSlot" -> <|bS[1] -> 1, b[2] -> 2|>, "ispSlots" -> {}|>,
   <|"caseName" -> "016BubbleBridgeTwoExternalLegs_sector_e2",
    "sectorShrunkLines" -> {2}, "sectorKey" -> "e2",
    "aSlotMode" -> "compactActiveSlots", "sectorVertexRepresentativeMap" ->
     <|v1 -> v1, v2 -> v1, v3 -> v3|>, "vertexIdToOriginalASlot" ->
     <|v1 -> 1, v2 -> 2, v3 -> 3|>, "vertexIdToCompactASlot" ->
     <|v1 -> 1, v2 -> 1, v3 -> 2|>, "vertexSlots" ->
     {<|"slot" -> 1, "vertexId" -> v1, "representativeVertexId" -> v1,
       "aSymbol" -> a[v1], "activeQ" -> True, "fixedValue" -> None,
       "compactASlot" -> 1|>, <|"slot" -> 2, "vertexId" -> v2,
       "representativeVertexId" -> v1, "aSymbol" -> a[v2],
       "activeQ" -> False, "fixedValue" -> 0, "compactASlot" -> 1|>,
      <|"slot" -> 3, "vertexId" -> v3, "representativeVertexId" -> v3,
       "aSymbol" -> a[v3], "activeQ" -> True, "fixedValue" -> None,
       "compactASlot" -> 2|>}, "compactASlots" ->
     {<|"compactSlot" -> 1, "representativeVertexId" -> v1,
       "originalVertexIds" -> {v1, v2}, "originalSlots" -> {1, 2},
       "aSymbol" -> a[v1]|>, <|"compactSlot" -> 2,
       "representativeVertexId" -> v3, "originalVertexIds" -> {v3},
       "originalSlots" -> {3}, "aSymbol" -> a[v3]|>},
    "activeASlots" -> {1, 2}, "lineSlots" ->
     {<|"slot" -> 1, "lineId" -> 1, "packType" -> "massiveFull",
       "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v1},
       "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" ->
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2},
       "endpointCompactASlots" -> {1, 1}, "linePowerMode" -> "indexed",
       "bPosition" -> 1, "bSymbol" -> b[1], "nPositions" -> {2, 3},
       "packTemplate" -> {b[1], n[1, 1], n[1, 2]}|>,
      <|"slot" -> 2, "lineId" -> 2, "packType" -> "shrunk",
       "massType" -> "massive", "state" -> "shrunk", "endpoints" -> {v1, v1},
       "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" ->
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2},
       "endpointCompactASlots" -> {1, 1}, "linePowerMode" -> "indexed",
       "bPosition" -> 1, "bSymbol" -> bS[2], "nPositions" -> {},
       "packTemplate" -> {bS[2]}|>, <|"slot" -> 3, "lineId" -> 3,
       "packType" -> "massiveFull", "massType" -> "massive",
       "state" -> "full", "endpoints" -> {v1, v3}, "originalEndpoints" ->
        {v2, v3}, "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"],
       "masslessN1OppositeEndpoint" -> Missing["NotApplicable"],
       "endpointOriginalASlots" -> {2, 3}, "endpointCompactASlots" -> {1, 2},
       "linePowerMode" -> "fixedCoefficient", "bPosition" ->
        Missing["FixedLinePower"], "bSymbol" -> None, "nPositions" -> {1, 2},
       "packTemplate" -> {n[3, 1], n[3, 2]}|>}, "lineIdToSlot" ->
     <|1 -> 1, 2 -> 2, 3 -> 3|>, "bSymbolToLineSlot" ->
     <|b[1] -> 1, bS[2] -> 2|>, "ispSlots" -> {}|>,
   <|"caseName" -> "016BubbleBridgeTwoExternalLegs_sector_e3",
    "sectorShrunkLines" -> {3}, "sectorKey" -> "e3",
    "aSlotMode" -> "compactActiveSlots", "sectorVertexRepresentativeMap" ->
     <|v1 -> v1, v2 -> v2, v3 -> v2|>, "vertexIdToOriginalASlot" ->
     <|v1 -> 1, v2 -> 2, v3 -> 3|>, "vertexIdToCompactASlot" ->
     <|v1 -> 1, v2 -> 2, v3 -> 2|>, "vertexSlots" ->
     {<|"slot" -> 1, "vertexId" -> v1, "representativeVertexId" -> v1,
       "aSymbol" -> a[v1], "activeQ" -> True, "fixedValue" -> None,
       "compactASlot" -> 1|>, <|"slot" -> 2, "vertexId" -> v2,
       "representativeVertexId" -> v2, "aSymbol" -> a[v2], "activeQ" -> True,
       "fixedValue" -> None, "compactASlot" -> 2|>,
      <|"slot" -> 3, "vertexId" -> v3, "representativeVertexId" -> v2,
       "aSymbol" -> a[v3], "activeQ" -> False, "fixedValue" -> 0,
       "compactASlot" -> 2|>}, "compactASlots" ->
     {<|"compactSlot" -> 1, "representativeVertexId" -> v1,
       "originalVertexIds" -> {v1}, "originalSlots" -> {1},
       "aSymbol" -> a[v1]|>, <|"compactSlot" -> 2,
       "representativeVertexId" -> v2, "originalVertexIds" -> {v2, v3},
       "originalSlots" -> {2, 3}, "aSymbol" -> a[v2]|>},
    "activeASlots" -> {1, 2}, "lineSlots" ->
     {<|"slot" -> 1, "lineId" -> 1, "packType" -> "massiveFull",
       "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v2},
       "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" ->
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2},
       "endpointCompactASlots" -> {1, 2}, "linePowerMode" -> "indexed",
       "bPosition" -> 1, "bSymbol" -> b[1], "nPositions" -> {2, 3},
       "packTemplate" -> {b[1], n[1, 1], n[1, 2]}|>,
      <|"slot" -> 2, "lineId" -> 2, "packType" -> "massiveFull",
       "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v2},
       "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" ->
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2},
       "endpointCompactASlots" -> {1, 2}, "linePowerMode" -> "indexed",
       "bPosition" -> 1, "bSymbol" -> b[2], "nPositions" -> {2, 3},
       "packTemplate" -> {b[2], n[2, 1], n[2, 2]}|>,
      <|"slot" -> 3, "lineId" -> 3, "packType" -> "shrunk",
       "massType" -> "massive", "state" -> "shrunk", "endpoints" -> {v2, v2},
       "originalEndpoints" -> {v2, v3}, "masslessN1ReferenceEndpoint" ->
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
        Missing["NotApplicable"], "endpointOriginalASlots" -> {2, 3},
       "endpointCompactASlots" -> {2, 2}, "linePowerMode" ->
        "fixedCoefficient", "bPosition" -> Missing["FixedLinePower"],
       "bSymbol" -> None, "nPositions" -> {}, "packTemplate" -> {}|>},
    "lineIdToSlot" -> <|1 -> 1, 2 -> 2, 3 -> 3|>, "bSymbolToLineSlot" ->
     <|b[1] -> 1, b[2] -> 2|>, "ispSlots" -> {}|>,
   <|"caseName" -> "016BubbleBridgeTwoExternalLegs_sector_e1_e3",
    "sectorShrunkLines" -> {1, 3}, "sectorKey" -> "e1_e3",
    "aSlotMode" -> "compactActiveSlots", "sectorVertexRepresentativeMap" ->
     <|v1 -> v1, v2 -> v1, v3 -> v1|>, "vertexIdToOriginalASlot" ->
     <|v1 -> 1, v2 -> 2, v3 -> 3|>, "vertexIdToCompactASlot" ->
     <|v1 -> 1, v2 -> 1, v3 -> 1|>, "vertexSlots" ->
     {<|"slot" -> 1, "vertexId" -> v1, "representativeVertexId" -> v1,
       "aSymbol" -> a[v1], "activeQ" -> True, "fixedValue" -> None,
       "compactASlot" -> 1|>, <|"slot" -> 2, "vertexId" -> v2,
       "representativeVertexId" -> v1, "aSymbol" -> a[v2],
       "activeQ" -> False, "fixedValue" -> 0, "compactASlot" -> 1|>,
      <|"slot" -> 3, "vertexId" -> v3, "representativeVertexId" -> v1,
       "aSymbol" -> a[v3], "activeQ" -> False, "fixedValue" -> 0,
       "compactASlot" -> 1|>}, "compactASlots" ->
     {<|"compactSlot" -> 1, "representativeVertexId" -> v1,
       "originalVertexIds" -> {v1, v2, v3}, "originalSlots" -> {1, 2, 3},
       "aSymbol" -> a[v1]|>}, "activeASlots" -> {1},
    "lineSlots" -> {<|"slot" -> 1, "lineId" -> 1, "packType" -> "shrunk",
       "massType" -> "massive", "state" -> "shrunk", "endpoints" -> {v1, v1},
       "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" ->
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2},
       "endpointCompactASlots" -> {1, 1}, "linePowerMode" -> "indexed",
       "bPosition" -> 1, "bSymbol" -> bS[1], "nPositions" -> {},
       "packTemplate" -> {bS[1]}|>, <|"slot" -> 2, "lineId" -> 2,
       "packType" -> "massiveFull", "massType" -> "massive",
       "state" -> "full", "endpoints" -> {v1, v1}, "originalEndpoints" ->
        {v1, v2}, "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"],
       "masslessN1OppositeEndpoint" -> Missing["NotApplicable"],
       "endpointOriginalASlots" -> {1, 2}, "endpointCompactASlots" -> {1, 1},
       "linePowerMode" -> "indexed", "bPosition" -> 1, "bSymbol" -> b[2],
       "nPositions" -> {2, 3}, "packTemplate" -> {b[2], n[2, 1], n[2, 2]}|>,
      <|"slot" -> 3, "lineId" -> 3, "packType" -> "shrunk",
       "massType" -> "massive", "state" -> "shrunk", "endpoints" -> {v1, v1},
       "originalEndpoints" -> {v2, v3}, "masslessN1ReferenceEndpoint" ->
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
        Missing["NotApplicable"], "endpointOriginalASlots" -> {2, 3},
       "endpointCompactASlots" -> {1, 1}, "linePowerMode" ->
        "fixedCoefficient", "bPosition" -> Missing["FixedLinePower"],
       "bSymbol" -> None, "nPositions" -> {}, "packTemplate" -> {}|>},
    "lineIdToSlot" -> <|1 -> 1, 2 -> 2, 3 -> 3|>, "bSymbolToLineSlot" ->
     <|bS[1] -> 1, b[2] -> 2|>, "ispSlots" -> {}|>,
   <|"caseName" -> "016BubbleBridgeTwoExternalLegs_sector_e2_e3",
    "sectorShrunkLines" -> {2, 3}, "sectorKey" -> "e2_e3",
    "aSlotMode" -> "compactActiveSlots", "sectorVertexRepresentativeMap" ->
     <|v1 -> v1, v2 -> v1, v3 -> v1|>, "vertexIdToOriginalASlot" ->
     <|v1 -> 1, v2 -> 2, v3 -> 3|>, "vertexIdToCompactASlot" ->
     <|v1 -> 1, v2 -> 1, v3 -> 1|>, "vertexSlots" ->
     {<|"slot" -> 1, "vertexId" -> v1, "representativeVertexId" -> v1,
       "aSymbol" -> a[v1], "activeQ" -> True, "fixedValue" -> None,
       "compactASlot" -> 1|>, <|"slot" -> 2, "vertexId" -> v2,
       "representativeVertexId" -> v1, "aSymbol" -> a[v2],
       "activeQ" -> False, "fixedValue" -> 0, "compactASlot" -> 1|>,
      <|"slot" -> 3, "vertexId" -> v3, "representativeVertexId" -> v1,
       "aSymbol" -> a[v3], "activeQ" -> False, "fixedValue" -> 0,
       "compactASlot" -> 1|>}, "compactASlots" ->
     {<|"compactSlot" -> 1, "representativeVertexId" -> v1,
       "originalVertexIds" -> {v1, v2, v3}, "originalSlots" -> {1, 2, 3},
       "aSymbol" -> a[v1]|>}, "activeASlots" -> {1},
    "lineSlots" -> {<|"slot" -> 1, "lineId" -> 1, "packType" ->
        "massiveFull", "massType" -> "massive", "state" -> "full",
       "endpoints" -> {v1, v1}, "originalEndpoints" -> {v1, v2},
       "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"],
       "masslessN1OppositeEndpoint" -> Missing["NotApplicable"],
       "endpointOriginalASlots" -> {1, 2}, "endpointCompactASlots" -> {1, 1},
       "linePowerMode" -> "indexed", "bPosition" -> 1, "bSymbol" -> b[1],
       "nPositions" -> {2, 3}, "packTemplate" -> {b[1], n[1, 1], n[1, 2]}|>,
      <|"slot" -> 2, "lineId" -> 2, "packType" -> "shrunk",
       "massType" -> "massive", "state" -> "shrunk", "endpoints" -> {v1, v1},
       "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" ->
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2},
       "endpointCompactASlots" -> {1, 1}, "linePowerMode" -> "indexed",
       "bPosition" -> 1, "bSymbol" -> bS[2], "nPositions" -> {},
       "packTemplate" -> {bS[2]}|>, <|"slot" -> 3, "lineId" -> 3,
       "packType" -> "shrunk", "massType" -> "massive", "state" -> "shrunk",
       "endpoints" -> {v1, v1}, "originalEndpoints" -> {v2, v3},
       "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"],
       "masslessN1OppositeEndpoint" -> Missing["NotApplicable"],
       "endpointOriginalASlots" -> {2, 3}, "endpointCompactASlots" -> {1, 1},
       "linePowerMode" -> "fixedCoefficient", "bPosition" ->
        Missing["FixedLinePower"], "bSymbol" -> None, "nPositions" -> {},
       "packTemplate" -> {}|>}, "lineIdToSlot" -> <|1 -> 1, 2 -> 2, 3 -> 3|>,
    "bSymbolToLineSlot" -> <|b[1] -> 1, bS[2] -> 2|>, "ispSlots" -> {}|>},
 "indexMaps" -> <|"vertexIdToOriginalASlot" -> <|v1 -> 1, v2 -> 2, v3 -> 3|>,
   "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 2, v3 -> 3|>,
   "lineIdToSlot" -> <|1 -> 1, 2 -> 2, 3 -> 3|>,
   "bSymbolToLineSlot" -> <|b[1] -> 1, b[2] -> 2|>,
   "compactASlots" -> {<|"compactSlot" -> 1, "representativeVertexId" -> v1,
      "originalVertexIds" -> {v1}, "originalSlots" -> {1},
      "aSymbol" -> a[v1]|>, <|"compactSlot" -> 2, "representativeVertexId" ->
       v2, "originalVertexIds" -> {v2}, "originalSlots" -> {2},
      "aSymbol" -> a[v2]|>, <|"compactSlot" -> 3, "representativeVertexId" ->
       v3, "originalVertexIds" -> {v3}, "originalSlots" -> {3},
      "aSymbol" -> a[v3]|>}, "lineSlots" ->
    {<|"slot" -> 1, "lineId" -> 1, "packType" -> "massiveFull",
      "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v2},
      "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" ->
       Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
       Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2},
      "endpointCompactASlots" -> {1, 2}, "linePowerMode" -> "indexed",
      "bPosition" -> 1, "bSymbol" -> b[1], "nPositions" -> {2, 3},
      "packTemplate" -> {b[1], n[1, 1], n[1, 2]}|>,
     <|"slot" -> 2, "lineId" -> 2, "packType" -> "massiveFull",
      "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v2},
      "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" ->
       Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
       Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2},
      "endpointCompactASlots" -> {1, 2}, "linePowerMode" -> "indexed",
      "bPosition" -> 1, "bSymbol" -> b[2], "nPositions" -> {2, 3},
      "packTemplate" -> {b[2], n[2, 1], n[2, 2]}|>,
     <|"slot" -> 3, "lineId" -> 3, "packType" -> "massiveFull",
      "massType" -> "massive", "state" -> "full", "endpoints" -> {v2, v3},
      "originalEndpoints" -> {v2, v3}, "masslessN1ReferenceEndpoint" ->
       Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
       Missing["NotApplicable"], "endpointOriginalASlots" -> {2, 3},
      "endpointCompactASlots" -> {2, 3}, "linePowerMode" ->
       "fixedCoefficient", "bPosition" -> Missing["FixedLinePower"],
      "bSymbol" -> None, "nPositions" -> {1, 2}, "packTemplate" ->
       {n[3, 1], n[3, 2]}|>}, "ispSlots" -> {}|>,
 "seedSummary" -> <|"continuousVariables" -> {a[v1], a[v2], a[v3], b[1],
     b[2]}, "discreteVariables" -> {n[1, 1], n[1, 2], n[2, 1], n[2, 2],
     n[3, 1], n[3, 2]}, "discreteStateCount" -> 64,
   "momentumGeneratorCount" -> 2, "timeGeneratorCount" -> 3,
   "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0},
     "sampleOnly" -> True|>, "numericRules" -> {},
   "numericRuleRequirementReport" -> <|"providedNumericVariables" -> {},
     "internalProvidedNumericVariables" -> {},
     "requiredExternalInvariants" -> {ss11},
     "internalRequiredExternalInvariants" -> {kk[1, 1]},
     "externalInvariantNamingReport" -> <|"externalMomenta" -> {k},
       "externalInvariantRules" -> {sp[k, k] -> ss11^2},
       "internalExternalInvariantRules" -> {kk[1, 1] -> ss11^2},
       "coordinateData" -> {<|"internalVariable" -> kk[1, 1],
          "publicExpression" -> ss11^2, "userVariable" -> ss11,
          "coordinateType" -> "squareRoot", "internalCoordinateExpression" ->
           Sqrt[kk[1, 1]], "internalJacobian" -> 2*Sqrt[kk[1, 1]],
          "userJacobian" -> 2*ss11|>}, "defaultNamingConvention" -> "ssij = \
Sqrt[sp[k_i,k_j]], where i<=j follows loopExternalMomenta order",
       "message" -> "loopExternalMomenta \
\:662f\:7528\:6237\:663e\:5f0f\:7ed9\:51fa\:7684 loop \
\:6807\:91cf\:79ef\:5916\:5411\:91cf\:57fa\:ff1b\:5185\:90e8\:4ecd\:7528 \
kk[i,j]=sp[k_i,k_j]\:ff0c016 \:516c\:5f00\:7f3a\:7701\:5750\:6807\:4e3a \
ssij\:3002"|>, "externalLegInvariantNamingReport" ->
      <|"externalLegMomenta" -> {p1, p2, p1 + p2},
       "appearingMagnitudeMomenta" -> {p1, p2, p1 + p2},
       "independentMagnitudeMomenta" -> {p1, p2, p1 + p2},
       "dependentMagnitudeBindings" -> {}, "externalLegInvariantRules" ->
        {sp[p1, p1] -> sE1^2, sp[p2, p2] -> sE2^2, sp[p1 + p2, p1 + p2] ->
          sE3^2}, "coordinateData" -> {<|"occurrenceIndex" -> 1,
          "momentum" -> p1, "squaredExpression" -> sp[p1, p1],
          "magnitudeExpression" -> Sqrt[sp[p1, p1]], "gramVector" ->
           {0, 0, 0, 1, 0, 0}, "baseCoefficients" -> {0, 1, 0, 0},
          "independentQ" -> True, "externalLegIndex" -> 1,
          "userVariable" -> sE1, "defaultSquaredExpression" -> sE1^2,
          "scalarProduct" -> sp[p1, p1], "publicExpression" -> sE1^2,
          "coordinateType" -> "externalLegSquareRoot", "userJacobian" -> 1|>,
         <|"occurrenceIndex" -> 2, "momentum" -> p2, "squaredExpression" ->
           sp[p2, p2], "magnitudeExpression" -> Sqrt[sp[p2, p2]],
          "gramVector" -> {0, 0, 0, 0, 0, 1}, "baseCoefficients" -> {0, 0, 1,
           0}, "independentQ" -> True, "externalLegIndex" -> 2,
          "userVariable" -> sE2, "defaultSquaredExpression" -> sE2^2,
          "scalarProduct" -> sp[p2, p2], "publicExpression" -> sE2^2,
          "coordinateType" -> "externalLegSquareRoot", "userJacobian" -> 1|>,
         <|"occurrenceIndex" -> 3, "momentum" -> p1 + p2,
          "squaredExpression" -> sp[p1 + p2, p1 + p2],
          "magnitudeExpression" -> Sqrt[sp[p1 + p2, p1 + p2]],
          "gramVector" -> {0, 0, 0, 1, 2, 1}, "baseCoefficients" -> {0, 0, 0,
           1}, "independentQ" -> True, "externalLegIndex" -> 3,
          "userVariable" -> sE3, "defaultSquaredExpression" -> sE3^2,
          "scalarProduct" -> sp[p1 + p2, p1 + p2], "publicExpression" ->
           sE3^2, "coordinateType" -> "externalLegSquareRoot",
          "userJacobian" -> 1|>}, "defaultNamingConvention" -> "sE1,sE2,... \
follow the first-occurrence independent basis of no-loop momentum magnitudes \
in lineData, vertexEnergies and extLegs", "automaticCrossProducts" -> False,
       "entersLoopIBPGenerators" -> False, "entersISPClosure" -> False|>,
     "vertexEnergyNamingReport" -> <|"convention" -> "loop external roots use \
ssij; the independent basis of actually appearing no-loop momentum magnitudes \
uses sEe variables and dependent magnitudes keep explicit bindings; unrelated \
scalar phase parameters remain explicit user symbols",
       "rawVertexEnergies" -> <|v1 -> E1, v2 -> E2, v3 -> E3|>,
       "internalVertexEnergies" -> <|v1 -> E1, v2 -> E2, v3 -> E3|>,
       "userVertexEnergies" -> <|v1 -> E1, v2 -> E2, v3 -> E3|>,
       "dependencyData" -> <|v1 -> <|"internalExternalInvariantVariables" ->
            {}, "externalInvariantVariables" -> {},
           "internalIndependentVertexEnergyParameters" -> {E1},
           "independentVertexEnergyParameters" -> {E1},
           "usesExternalInvariantQ" -> False,
           "usesIndependentVertexEnergyQ" -> True, "kind" ->
            "independentVertexEnergyParameter"|>,
         v2 -> <|"internalExternalInvariantVariables" -> {},
           "externalInvariantVariables" -> {},
           "internalIndependentVertexEnergyParameters" -> {E2},
           "independentVertexEnergyParameters" -> {E2},
           "usesExternalInvariantQ" -> False,
           "usesIndependentVertexEnergyQ" -> True, "kind" ->
            "independentVertexEnergyParameter"|>,
         v3 -> <|"internalExternalInvariantVariables" -> {},
           "externalInvariantVariables" -> {},
           "internalIndependentVertexEnergyParameters" -> {E3},
           "independentVertexEnergyParameters" -> {E3},
           "usesExternalInvariantQ" -> False,
           "usesIndependentVertexEnergyQ" -> True, "kind" ->
            "independentVertexEnergyParameter"|>|>,
       "externalLegInvariantNamingReport" -> <|"externalLegMomenta" ->
          {p1, p2, p1 + p2}, "appearingMagnitudeMomenta" ->
          {p1, p2, p1 + p2}, "independentMagnitudeMomenta" ->
          {p1, p2, p1 + p2}, "dependentMagnitudeBindings" -> {},
         "externalLegInvariantRules" -> {sp[p1, p1] -> sE1^2,
           sp[p2, p2] -> sE2^2, sp[p1 + p2, p1 + p2] -> sE3^2},
         "coordinateData" -> {<|"occurrenceIndex" -> 1, "momentum" -> p1,
            "squaredExpression" -> sp[p1, p1], "magnitudeExpression" ->
             Sqrt[sp[p1, p1]], "gramVector" -> {0, 0, 0, 1, 0, 0},
            "baseCoefficients" -> {0, 1, 0, 0}, "independentQ" -> True,
            "externalLegIndex" -> 1, "userVariable" -> sE1,
            "defaultSquaredExpression" -> sE1^2, "scalarProduct" ->
             sp[p1, p1], "publicExpression" -> sE1^2, "coordinateType" ->
             "externalLegSquareRoot", "userJacobian" -> 1|>,
           <|"occurrenceIndex" -> 2, "momentum" -> p2, "squaredExpression" ->
             sp[p2, p2], "magnitudeExpression" -> Sqrt[sp[p2, p2]],
            "gramVector" -> {0, 0, 0, 0, 0, 1}, "baseCoefficients" -> {0, 0,
             1, 0}, "independentQ" -> True, "externalLegIndex" -> 2,
            "userVariable" -> sE2, "defaultSquaredExpression" -> sE2^2,
            "scalarProduct" -> sp[p2, p2], "publicExpression" -> sE2^2,
            "coordinateType" -> "externalLegSquareRoot", "userJacobian" ->
             1|>, <|"occurrenceIndex" -> 3, "momentum" -> p1 + p2,
            "squaredExpression" -> sp[p1 + p2, p1 + p2],
            "magnitudeExpression" -> Sqrt[sp[p1 + p2, p1 + p2]],
            "gramVector" -> {0, 0, 0, 1, 2, 1}, "baseCoefficients" -> {0, 0,
             0, 1}, "independentQ" -> True, "externalLegIndex" -> 3,
            "userVariable" -> sE3, "defaultSquaredExpression" -> sE3^2,
            "scalarProduct" -> sp[p1 + p2, p1 + p2], "publicExpression" ->
             sE3^2, "coordinateType" -> "externalLegSquareRoot",
            "userJacobian" -> 1|>}, "defaultNamingConvention" -> "sE1,sE2,... \
follow the first-occurrence independent basis of no-loop momentum magnitudes \
in lineData, vertexEnergies and extLegs", "automaticCrossProducts" -> False,
         "entersLoopIBPGenerators" -> False, "entersISPClosure" -> False|>,
       "message" -> "vertexEnergies \:53ef\:4f7f\:7528 loop-external Gram \
\:6839\:53f7\:6216 independentExternalMomenta \
\:58f0\:660e\:7684\:65e0\:5708\:6a21\:957f\:ff1b016 \
\:4e0d\:81ea\:52a8\:751f\:6210\:65e0\:5708\:52a8\:91cf\:4e4b\:95f4\:7684\
\:4ea4\:53c9\:70b9\:79ef\:3002\:65e0\:5708\:52a8\:91cf\:53d8\:91cf\:4e0d\
\:8fdb\:5165 loop IBP/ISP\:3002"|>, "requiredVertexEnergies" -> {E1, E2, E3},
     "internalRequiredVertexEnergies" -> {E1, E2, E3},
     "requiredLineParameters" -> {nu1, nu2, nu3},
     "requiredNumericVariables" -> {ss11, E1, E2, E3, nu1, nu2, nu3},
     "internalRequiredNumericVariables" -> {kk[1, 1], E1, E2, E3, nu1, nu2,
       nu3}, "missingExternalInvariants" -> {ss11},
     "internalMissingExternalInvariants" -> {kk[1, 1]},
     "missingVertexEnergies" -> {E1, E2, E3},
     "internalMissingVertexEnergies" -> {E1, E2, E3},
     "missingLineParameters" -> {nu1, nu2, nu3}, "missingNumericVariables" ->
      {E1, E2, E3, nu1, nu2, nu3, ss11}, "internalMissingNumericVariables" ->
      {E1, E2, E3, nu1, nu2, nu3, kk[1, 1]}, "completeStaticNumericRulesQ" ->
      False|>, "externalInvariantNamingReport" -> <|"externalMomenta" -> {k},
     "externalInvariantRules" -> {sp[k, k] -> ss11^2},
     "internalExternalInvariantRules" -> {kk[1, 1] -> ss11^2},
     "coordinateData" -> {<|"internalVariable" -> kk[1, 1],
        "publicExpression" -> ss11^2, "userVariable" -> ss11,
        "coordinateType" -> "squareRoot", "internalCoordinateExpression" ->
         Sqrt[kk[1, 1]], "internalJacobian" -> 2*Sqrt[kk[1, 1]],
        "userJacobian" -> 2*ss11|>}, "defaultNamingConvention" -> "ssij = \
Sqrt[sp[k_i,k_j]], where i<=j follows loopExternalMomenta order",
     "message" -> "loopExternalMomenta \
\:662f\:7528\:6237\:663e\:5f0f\:7ed9\:51fa\:7684 loop \
\:6807\:91cf\:79ef\:5916\:5411\:91cf\:57fa\:ff1b\:5185\:90e8\:4ecd\:7528 \
kk[i,j]=sp[k_i,k_j]\:ff0c016 \:516c\:5f00\:7f3a\:7701\:5750\:6807\:4e3a \
ssij\:3002"|>, "vertexEnergyNamingReport" ->
    <|"convention" -> "loop external roots use ssij; the independent basis of \
actually appearing no-loop momentum magnitudes uses sEe variables and \
dependent magnitudes keep explicit bindings; unrelated scalar phase \
parameters remain explicit user symbols", "rawVertexEnergies" ->
      <|v1 -> E1, v2 -> E2, v3 -> E3|>, "internalVertexEnergies" ->
      <|v1 -> E1, v2 -> E2, v3 -> E3|>, "userVertexEnergies" ->
      <|v1 -> E1, v2 -> E2, v3 -> E3|>, "dependencyData" ->
      <|v1 -> <|"internalExternalInvariantVariables" -> {},
         "externalInvariantVariables" -> {},
         "internalIndependentVertexEnergyParameters" -> {E1},
         "independentVertexEnergyParameters" -> {E1},
         "usesExternalInvariantQ" -> False, "usesIndependentVertexEnergyQ" ->
          True, "kind" -> "independentVertexEnergyParameter"|>,
       v2 -> <|"internalExternalInvariantVariables" -> {},
         "externalInvariantVariables" -> {},
         "internalIndependentVertexEnergyParameters" -> {E2},
         "independentVertexEnergyParameters" -> {E2},
         "usesExternalInvariantQ" -> False, "usesIndependentVertexEnergyQ" ->
          True, "kind" -> "independentVertexEnergyParameter"|>,
       v3 -> <|"internalExternalInvariantVariables" -> {},
         "externalInvariantVariables" -> {},
         "internalIndependentVertexEnergyParameters" -> {E3},
         "independentVertexEnergyParameters" -> {E3},
         "usesExternalInvariantQ" -> False, "usesIndependentVertexEnergyQ" ->
          True, "kind" -> "independentVertexEnergyParameter"|>|>,
     "externalLegInvariantNamingReport" ->
      <|"externalLegMomenta" -> {p1, p2, p1 + p2},
       "appearingMagnitudeMomenta" -> {p1, p2, p1 + p2},
       "independentMagnitudeMomenta" -> {p1, p2, p1 + p2},
       "dependentMagnitudeBindings" -> {}, "externalLegInvariantRules" ->
        {sp[p1, p1] -> sE1^2, sp[p2, p2] -> sE2^2, sp[p1 + p2, p1 + p2] ->
          sE3^2}, "coordinateData" -> {<|"occurrenceIndex" -> 1,
          "momentum" -> p1, "squaredExpression" -> sp[p1, p1],
          "magnitudeExpression" -> Sqrt[sp[p1, p1]], "gramVector" ->
           {0, 0, 0, 1, 0, 0}, "baseCoefficients" -> {0, 1, 0, 0},
          "independentQ" -> True, "externalLegIndex" -> 1,
          "userVariable" -> sE1, "defaultSquaredExpression" -> sE1^2,
          "scalarProduct" -> sp[p1, p1], "publicExpression" -> sE1^2,
          "coordinateType" -> "externalLegSquareRoot", "userJacobian" -> 1|>,
         <|"occurrenceIndex" -> 2, "momentum" -> p2, "squaredExpression" ->
           sp[p2, p2], "magnitudeExpression" -> Sqrt[sp[p2, p2]],
          "gramVector" -> {0, 0, 0, 0, 0, 1}, "baseCoefficients" -> {0, 0, 1,
           0}, "independentQ" -> True, "externalLegIndex" -> 2,
          "userVariable" -> sE2, "defaultSquaredExpression" -> sE2^2,
          "scalarProduct" -> sp[p2, p2], "publicExpression" -> sE2^2,
          "coordinateType" -> "externalLegSquareRoot", "userJacobian" -> 1|>,
         <|"occurrenceIndex" -> 3, "momentum" -> p1 + p2,
          "squaredExpression" -> sp[p1 + p2, p1 + p2],
          "magnitudeExpression" -> Sqrt[sp[p1 + p2, p1 + p2]],
          "gramVector" -> {0, 0, 0, 1, 2, 1}, "baseCoefficients" -> {0, 0, 0,
           1}, "independentQ" -> True, "externalLegIndex" -> 3,
          "userVariable" -> sE3, "defaultSquaredExpression" -> sE3^2,
          "scalarProduct" -> sp[p1 + p2, p1 + p2], "publicExpression" ->
           sE3^2, "coordinateType" -> "externalLegSquareRoot",
          "userJacobian" -> 1|>}, "defaultNamingConvention" -> "sE1,sE2,... \
follow the first-occurrence independent basis of no-loop momentum magnitudes \
in lineData, vertexEnergies and extLegs", "automaticCrossProducts" -> False,
       "entersLoopIBPGenerators" -> False, "entersISPClosure" -> False|>,
     "message" -> "vertexEnergies \:53ef\:4f7f\:7528 loop-external Gram \
\:6839\:53f7\:6216 independentExternalMomenta \
\:58f0\:660e\:7684\:65e0\:5708\:6a21\:957f\:ff1b016 \
\:4e0d\:81ea\:52a8\:751f\:6210\:65e0\:5708\:52a8\:91cf\:4e4b\:95f4\:7684\
\:4ea4\:53c9\:70b9\:79ef\:3002\:65e0\:5708\:52a8\:91cf\:53d8\:91cf\:4e0d\
\:8fdb\:5165 loop IBP/ISP\:3002"|>, "sampleDiscreteRules" -> {}|>,
 "validationReport" -> <|"status" -> "ok", "errorCount" -> 0,
   "warningCount" -> 4, "pendingCount" -> 0,
   "numericRuleRequirementReport" -> <|"providedNumericVariables" -> {},
     "internalProvidedNumericVariables" -> {},
     "requiredExternalInvariants" -> {ss11},
     "internalRequiredExternalInvariants" -> {kk[1, 1]},
     "externalInvariantNamingReport" -> <|"externalMomenta" -> {k},
       "externalInvariantRules" -> {sp[k, k] -> ss11^2},
       "internalExternalInvariantRules" -> {kk[1, 1] -> ss11^2},
       "coordinateData" -> {<|"internalVariable" -> kk[1, 1],
          "publicExpression" -> ss11^2, "userVariable" -> ss11,
          "coordinateType" -> "squareRoot", "internalCoordinateExpression" ->
           Sqrt[kk[1, 1]], "internalJacobian" -> 2*Sqrt[kk[1, 1]],
          "userJacobian" -> 2*ss11|>}, "defaultNamingConvention" -> "ssij = \
Sqrt[sp[k_i,k_j]], where i<=j follows loopExternalMomenta order",
       "message" -> "loopExternalMomenta \
\:662f\:7528\:6237\:663e\:5f0f\:7ed9\:51fa\:7684 loop \
\:6807\:91cf\:79ef\:5916\:5411\:91cf\:57fa\:ff1b\:5185\:90e8\:4ecd\:7528 \
kk[i,j]=sp[k_i,k_j]\:ff0c016 \:516c\:5f00\:7f3a\:7701\:5750\:6807\:4e3a \
ssij\:3002"|>, "externalLegInvariantNamingReport" ->
      <|"externalLegMomenta" -> {p1, p2, p1 + p2},
       "appearingMagnitudeMomenta" -> {p1, p2, p1 + p2},
       "independentMagnitudeMomenta" -> {p1, p2, p1 + p2},
       "dependentMagnitudeBindings" -> {}, "externalLegInvariantRules" ->
        {sp[p1, p1] -> sE1^2, sp[p2, p2] -> sE2^2, sp[p1 + p2, p1 + p2] ->
          sE3^2}, "coordinateData" -> {<|"occurrenceIndex" -> 1,
          "momentum" -> p1, "squaredExpression" -> sp[p1, p1],
          "magnitudeExpression" -> Sqrt[sp[p1, p1]], "gramVector" ->
           {0, 0, 0, 1, 0, 0}, "baseCoefficients" -> {0, 1, 0, 0},
          "independentQ" -> True, "externalLegIndex" -> 1,
          "userVariable" -> sE1, "defaultSquaredExpression" -> sE1^2,
          "scalarProduct" -> sp[p1, p1], "publicExpression" -> sE1^2,
          "coordinateType" -> "externalLegSquareRoot", "userJacobian" -> 1|>,
         <|"occurrenceIndex" -> 2, "momentum" -> p2, "squaredExpression" ->
           sp[p2, p2], "magnitudeExpression" -> Sqrt[sp[p2, p2]],
          "gramVector" -> {0, 0, 0, 0, 0, 1}, "baseCoefficients" -> {0, 0, 1,
           0}, "independentQ" -> True, "externalLegIndex" -> 2,
          "userVariable" -> sE2, "defaultSquaredExpression" -> sE2^2,
          "scalarProduct" -> sp[p2, p2], "publicExpression" -> sE2^2,
          "coordinateType" -> "externalLegSquareRoot", "userJacobian" -> 1|>,
         <|"occurrenceIndex" -> 3, "momentum" -> p1 + p2,
          "squaredExpression" -> sp[p1 + p2, p1 + p2],
          "magnitudeExpression" -> Sqrt[sp[p1 + p2, p1 + p2]],
          "gramVector" -> {0, 0, 0, 1, 2, 1}, "baseCoefficients" -> {0, 0, 0,
           1}, "independentQ" -> True, "externalLegIndex" -> 3,
          "userVariable" -> sE3, "defaultSquaredExpression" -> sE3^2,
          "scalarProduct" -> sp[p1 + p2, p1 + p2], "publicExpression" ->
           sE3^2, "coordinateType" -> "externalLegSquareRoot",
          "userJacobian" -> 1|>}, "defaultNamingConvention" -> "sE1,sE2,... \
follow the first-occurrence independent basis of no-loop momentum magnitudes \
in lineData, vertexEnergies and extLegs", "automaticCrossProducts" -> False,
       "entersLoopIBPGenerators" -> False, "entersISPClosure" -> False|>,
     "vertexEnergyNamingReport" -> <|"convention" -> "loop external roots use \
ssij; the independent basis of actually appearing no-loop momentum magnitudes \
uses sEe variables and dependent magnitudes keep explicit bindings; unrelated \
scalar phase parameters remain explicit user symbols",
       "rawVertexEnergies" -> <|v1 -> E1, v2 -> E2, v3 -> E3|>,
       "internalVertexEnergies" -> <|v1 -> E1, v2 -> E2, v3 -> E3|>,
       "userVertexEnergies" -> <|v1 -> E1, v2 -> E2, v3 -> E3|>,
       "dependencyData" -> <|v1 -> <|"internalExternalInvariantVariables" ->
            {}, "externalInvariantVariables" -> {},
           "internalIndependentVertexEnergyParameters" -> {E1},
           "independentVertexEnergyParameters" -> {E1},
           "usesExternalInvariantQ" -> False,
           "usesIndependentVertexEnergyQ" -> True, "kind" ->
            "independentVertexEnergyParameter"|>,
         v2 -> <|"internalExternalInvariantVariables" -> {},
           "externalInvariantVariables" -> {},
           "internalIndependentVertexEnergyParameters" -> {E2},
           "independentVertexEnergyParameters" -> {E2},
           "usesExternalInvariantQ" -> False,
           "usesIndependentVertexEnergyQ" -> True, "kind" ->
            "independentVertexEnergyParameter"|>,
         v3 -> <|"internalExternalInvariantVariables" -> {},
           "externalInvariantVariables" -> {},
           "internalIndependentVertexEnergyParameters" -> {E3},
           "independentVertexEnergyParameters" -> {E3},
           "usesExternalInvariantQ" -> False,
           "usesIndependentVertexEnergyQ" -> True, "kind" ->
            "independentVertexEnergyParameter"|>|>,
       "externalLegInvariantNamingReport" -> <|"externalLegMomenta" ->
          {p1, p2, p1 + p2}, "appearingMagnitudeMomenta" ->
          {p1, p2, p1 + p2}, "independentMagnitudeMomenta" ->
          {p1, p2, p1 + p2}, "dependentMagnitudeBindings" -> {},
         "externalLegInvariantRules" -> {sp[p1, p1] -> sE1^2,
           sp[p2, p2] -> sE2^2, sp[p1 + p2, p1 + p2] -> sE3^2},
         "coordinateData" -> {<|"occurrenceIndex" -> 1, "momentum" -> p1,
            "squaredExpression" -> sp[p1, p1], "magnitudeExpression" ->
             Sqrt[sp[p1, p1]], "gramVector" -> {0, 0, 0, 1, 0, 0},
            "baseCoefficients" -> {0, 1, 0, 0}, "independentQ" -> True,
            "externalLegIndex" -> 1, "userVariable" -> sE1,
            "defaultSquaredExpression" -> sE1^2, "scalarProduct" ->
             sp[p1, p1], "publicExpression" -> sE1^2, "coordinateType" ->
             "externalLegSquareRoot", "userJacobian" -> 1|>,
           <|"occurrenceIndex" -> 2, "momentum" -> p2, "squaredExpression" ->
             sp[p2, p2], "magnitudeExpression" -> Sqrt[sp[p2, p2]],
            "gramVector" -> {0, 0, 0, 0, 0, 1}, "baseCoefficients" -> {0, 0,
             1, 0}, "independentQ" -> True, "externalLegIndex" -> 2,
            "userVariable" -> sE2, "defaultSquaredExpression" -> sE2^2,
            "scalarProduct" -> sp[p2, p2], "publicExpression" -> sE2^2,
            "coordinateType" -> "externalLegSquareRoot", "userJacobian" ->
             1|>, <|"occurrenceIndex" -> 3, "momentum" -> p1 + p2,
            "squaredExpression" -> sp[p1 + p2, p1 + p2],
            "magnitudeExpression" -> Sqrt[sp[p1 + p2, p1 + p2]],
            "gramVector" -> {0, 0, 0, 1, 2, 1}, "baseCoefficients" -> {0, 0,
             0, 1}, "independentQ" -> True, "externalLegIndex" -> 3,
            "userVariable" -> sE3, "defaultSquaredExpression" -> sE3^2,
            "scalarProduct" -> sp[p1 + p2, p1 + p2], "publicExpression" ->
             sE3^2, "coordinateType" -> "externalLegSquareRoot",
            "userJacobian" -> 1|>}, "defaultNamingConvention" -> "sE1,sE2,... \
follow the first-occurrence independent basis of no-loop momentum magnitudes \
in lineData, vertexEnergies and extLegs", "automaticCrossProducts" -> False,
         "entersLoopIBPGenerators" -> False, "entersISPClosure" -> False|>,
       "message" -> "vertexEnergies \:53ef\:4f7f\:7528 loop-external Gram \
\:6839\:53f7\:6216 independentExternalMomenta \
\:58f0\:660e\:7684\:65e0\:5708\:6a21\:957f\:ff1b016 \
\:4e0d\:81ea\:52a8\:751f\:6210\:65e0\:5708\:52a8\:91cf\:4e4b\:95f4\:7684\
\:4ea4\:53c9\:70b9\:79ef\:3002\:65e0\:5708\:52a8\:91cf\:53d8\:91cf\:4e0d\
\:8fdb\:5165 loop IBP/ISP\:3002"|>, "requiredVertexEnergies" -> {E1, E2, E3},
     "internalRequiredVertexEnergies" -> {E1, E2, E3},
     "requiredLineParameters" -> {nu1, nu2, nu3},
     "requiredNumericVariables" -> {ss11, E1, E2, E3, nu1, nu2, nu3},
     "internalRequiredNumericVariables" -> {kk[1, 1], E1, E2, E3, nu1, nu2,
       nu3}, "missingExternalInvariants" -> {ss11},
     "internalMissingExternalInvariants" -> {kk[1, 1]},
     "missingVertexEnergies" -> {E1, E2, E3},
     "internalMissingVertexEnergies" -> {E1, E2, E3},
     "missingLineParameters" -> {nu1, nu2, nu3}, "missingNumericVariables" ->
      {E1, E2, E3, nu1, nu2, nu3, ss11}, "internalMissingNumericVariables" ->
      {E1, E2, E3, nu1, nu2, nu3, kk[1, 1]}, "completeStaticNumericRulesQ" ->
      False|>, "pendingFeatures" -> {},
   "issues" -> {<|"severity" -> "warning",
      "code" -> "numericRulesMissingExternalInvariants",
      "missingExternalInvariants" -> {ss11}, "numericRules" -> {},
      "comment" -> "analytic seed can still be generated; numeric linear/Kira \
stages need external invariant value rules, using the output names from \
externalInvariantRules/default sij"|>, <|"severity" -> "warning",
      "code" -> "numericRulesMissingVertexEnergies",
      "missingVertexEnergies" -> {E1, E2, E3}, "numericRules" -> {},
      "comment" -> "analytic seed can still be generated; numeric linear/Kira \
stages need vertex energy rules from time IBP"|>, <|"severity" -> "warning",
      "code" -> "numericRulesMissingLineParameters",
      "missingLineParameters" -> {nu1, nu2, nu3}, "numericRules" -> {},
      "comment" -> "analytic seed can still be generated; numeric linear/Kira \
stages need massive line parameter rules"|>, <|"severity" -> "warning",
      "code" -> "sampleDiscreteRulesMissingForDiscreteVariables",
      "missingVariables" -> {n[1, 1], n[1, 2], n[2, 1], n[2, 2], n[3, 1],
        n[3, 2]}, "comment" -> "sample seed mode needs complete n=0/1 rules; \
DiscreteMode -> all can enumerate them automatically"|>}|>,
 "numericRuleRequirementReport" -> <|"providedNumericVariables" -> {},
   "internalProvidedNumericVariables" -> {}, "requiredExternalInvariants" ->
    {ss11}, "internalRequiredExternalInvariants" -> {kk[1, 1]},
   "externalInvariantNamingReport" -> <|"externalMomenta" -> {k},
     "externalInvariantRules" -> {sp[k, k] -> ss11^2},
     "internalExternalInvariantRules" -> {kk[1, 1] -> ss11^2},
     "coordinateData" -> {<|"internalVariable" -> kk[1, 1],
        "publicExpression" -> ss11^2, "userVariable" -> ss11,
        "coordinateType" -> "squareRoot", "internalCoordinateExpression" ->
         Sqrt[kk[1, 1]], "internalJacobian" -> 2*Sqrt[kk[1, 1]],
        "userJacobian" -> 2*ss11|>}, "defaultNamingConvention" -> "ssij = \
Sqrt[sp[k_i,k_j]], where i<=j follows loopExternalMomenta order",
     "message" -> "loopExternalMomenta \
\:662f\:7528\:6237\:663e\:5f0f\:7ed9\:51fa\:7684 loop \
\:6807\:91cf\:79ef\:5916\:5411\:91cf\:57fa\:ff1b\:5185\:90e8\:4ecd\:7528 \
kk[i,j]=sp[k_i,k_j]\:ff0c016 \:516c\:5f00\:7f3a\:7701\:5750\:6807\:4e3a \
ssij\:3002"|>, "externalLegInvariantNamingReport" ->
    <|"externalLegMomenta" -> {p1, p2, p1 + p2},
     "appearingMagnitudeMomenta" -> {p1, p2, p1 + p2},
     "independentMagnitudeMomenta" -> {p1, p2, p1 + p2},
     "dependentMagnitudeBindings" -> {}, "externalLegInvariantRules" ->
      {sp[p1, p1] -> sE1^2, sp[p2, p2] -> sE2^2, sp[p1 + p2, p1 + p2] ->
        sE3^2}, "coordinateData" -> {<|"occurrenceIndex" -> 1,
        "momentum" -> p1, "squaredExpression" -> sp[p1, p1],
        "magnitudeExpression" -> Sqrt[sp[p1, p1]], "gramVector" ->
         {0, 0, 0, 1, 0, 0}, "baseCoefficients" -> {0, 1, 0, 0},
        "independentQ" -> True, "externalLegIndex" -> 1,
        "userVariable" -> sE1, "defaultSquaredExpression" -> sE1^2,
        "scalarProduct" -> sp[p1, p1], "publicExpression" -> sE1^2,
        "coordinateType" -> "externalLegSquareRoot", "userJacobian" -> 1|>,
       <|"occurrenceIndex" -> 2, "momentum" -> p2, "squaredExpression" ->
         sp[p2, p2], "magnitudeExpression" -> Sqrt[sp[p2, p2]],
        "gramVector" -> {0, 0, 0, 0, 0, 1}, "baseCoefficients" -> {0, 0, 1,
         0}, "independentQ" -> True, "externalLegIndex" -> 2,
        "userVariable" -> sE2, "defaultSquaredExpression" -> sE2^2,
        "scalarProduct" -> sp[p2, p2], "publicExpression" -> sE2^2,
        "coordinateType" -> "externalLegSquareRoot", "userJacobian" -> 1|>,
       <|"occurrenceIndex" -> 3, "momentum" -> p1 + p2,
        "squaredExpression" -> sp[p1 + p2, p1 + p2], "magnitudeExpression" ->
         Sqrt[sp[p1 + p2, p1 + p2]], "gramVector" -> {0, 0, 0, 1, 2, 1},
        "baseCoefficients" -> {0, 0, 0, 1}, "independentQ" -> True,
        "externalLegIndex" -> 3, "userVariable" -> sE3,
        "defaultSquaredExpression" -> sE3^2, "scalarProduct" ->
         sp[p1 + p2, p1 + p2], "publicExpression" -> sE3^2,
        "coordinateType" -> "externalLegSquareRoot", "userJacobian" -> 1|>},
     "defaultNamingConvention" -> "sE1,sE2,... follow the first-occurrence \
independent basis of no-loop momentum magnitudes in lineData, vertexEnergies \
and extLegs", "automaticCrossProducts" -> False, "entersLoopIBPGenerators" ->
      False, "entersISPClosure" -> False|>, "vertexEnergyNamingReport" ->
    <|"convention" -> "loop external roots use ssij; the independent basis of \
actually appearing no-loop momentum magnitudes uses sEe variables and \
dependent magnitudes keep explicit bindings; unrelated scalar phase \
parameters remain explicit user symbols", "rawVertexEnergies" ->
      <|v1 -> E1, v2 -> E2, v3 -> E3|>, "internalVertexEnergies" ->
      <|v1 -> E1, v2 -> E2, v3 -> E3|>, "userVertexEnergies" ->
      <|v1 -> E1, v2 -> E2, v3 -> E3|>, "dependencyData" ->
      <|v1 -> <|"internalExternalInvariantVariables" -> {},
         "externalInvariantVariables" -> {},
         "internalIndependentVertexEnergyParameters" -> {E1},
         "independentVertexEnergyParameters" -> {E1},
         "usesExternalInvariantQ" -> False, "usesIndependentVertexEnergyQ" ->
          True, "kind" -> "independentVertexEnergyParameter"|>,
       v2 -> <|"internalExternalInvariantVariables" -> {},
         "externalInvariantVariables" -> {},
         "internalIndependentVertexEnergyParameters" -> {E2},
         "independentVertexEnergyParameters" -> {E2},
         "usesExternalInvariantQ" -> False, "usesIndependentVertexEnergyQ" ->
          True, "kind" -> "independentVertexEnergyParameter"|>,
       v3 -> <|"internalExternalInvariantVariables" -> {},
         "externalInvariantVariables" -> {},
         "internalIndependentVertexEnergyParameters" -> {E3},
         "independentVertexEnergyParameters" -> {E3},
         "usesExternalInvariantQ" -> False, "usesIndependentVertexEnergyQ" ->
          True, "kind" -> "independentVertexEnergyParameter"|>|>,
     "externalLegInvariantNamingReport" ->
      <|"externalLegMomenta" -> {p1, p2, p1 + p2},
       "appearingMagnitudeMomenta" -> {p1, p2, p1 + p2},
       "independentMagnitudeMomenta" -> {p1, p2, p1 + p2},
       "dependentMagnitudeBindings" -> {}, "externalLegInvariantRules" ->
        {sp[p1, p1] -> sE1^2, sp[p2, p2] -> sE2^2, sp[p1 + p2, p1 + p2] ->
          sE3^2}, "coordinateData" -> {<|"occurrenceIndex" -> 1,
          "momentum" -> p1, "squaredExpression" -> sp[p1, p1],
          "magnitudeExpression" -> Sqrt[sp[p1, p1]], "gramVector" ->
           {0, 0, 0, 1, 0, 0}, "baseCoefficients" -> {0, 1, 0, 0},
          "independentQ" -> True, "externalLegIndex" -> 1,
          "userVariable" -> sE1, "defaultSquaredExpression" -> sE1^2,
          "scalarProduct" -> sp[p1, p1], "publicExpression" -> sE1^2,
          "coordinateType" -> "externalLegSquareRoot", "userJacobian" -> 1|>,
         <|"occurrenceIndex" -> 2, "momentum" -> p2, "squaredExpression" ->
           sp[p2, p2], "magnitudeExpression" -> Sqrt[sp[p2, p2]],
          "gramVector" -> {0, 0, 0, 0, 0, 1}, "baseCoefficients" -> {0, 0, 1,
           0}, "independentQ" -> True, "externalLegIndex" -> 2,
          "userVariable" -> sE2, "defaultSquaredExpression" -> sE2^2,
          "scalarProduct" -> sp[p2, p2], "publicExpression" -> sE2^2,
          "coordinateType" -> "externalLegSquareRoot", "userJacobian" -> 1|>,
         <|"occurrenceIndex" -> 3, "momentum" -> p1 + p2,
          "squaredExpression" -> sp[p1 + p2, p1 + p2],
          "magnitudeExpression" -> Sqrt[sp[p1 + p2, p1 + p2]],
          "gramVector" -> {0, 0, 0, 1, 2, 1}, "baseCoefficients" -> {0, 0, 0,
           1}, "independentQ" -> True, "externalLegIndex" -> 3,
          "userVariable" -> sE3, "defaultSquaredExpression" -> sE3^2,
          "scalarProduct" -> sp[p1 + p2, p1 + p2], "publicExpression" ->
           sE3^2, "coordinateType" -> "externalLegSquareRoot",
          "userJacobian" -> 1|>}, "defaultNamingConvention" -> "sE1,sE2,... \
follow the first-occurrence independent basis of no-loop momentum magnitudes \
in lineData, vertexEnergies and extLegs", "automaticCrossProducts" -> False,
       "entersLoopIBPGenerators" -> False, "entersISPClosure" -> False|>,
     "message" -> "vertexEnergies \:53ef\:4f7f\:7528 loop-external Gram \
\:6839\:53f7\:6216 independentExternalMomenta \
\:58f0\:660e\:7684\:65e0\:5708\:6a21\:957f\:ff1b016 \
\:4e0d\:81ea\:52a8\:751f\:6210\:65e0\:5708\:52a8\:91cf\:4e4b\:95f4\:7684\
\:4ea4\:53c9\:70b9\:79ef\:3002\:65e0\:5708\:52a8\:91cf\:53d8\:91cf\:4e0d\
\:8fdb\:5165 loop IBP/ISP\:3002"|>, "requiredVertexEnergies" -> {E1, E2, E3},
   "internalRequiredVertexEnergies" -> {E1, E2, E3},
   "requiredLineParameters" -> {nu1, nu2, nu3}, "requiredNumericVariables" ->
    {ss11, E1, E2, E3, nu1, nu2, nu3}, "internalRequiredNumericVariables" ->
    {kk[1, 1], E1, E2, E3, nu1, nu2, nu3}, "missingExternalInvariants" ->
    {ss11}, "internalMissingExternalInvariants" -> {kk[1, 1]},
   "missingVertexEnergies" -> {E1, E2, E3},
   "internalMissingVertexEnergies" -> {E1, E2, E3},
   "missingLineParameters" -> {nu1, nu2, nu3}, "missingNumericVariables" ->
    {E1, E2, E3, nu1, nu2, nu3, ss11}, "internalMissingNumericVariables" ->
    {E1, E2, E3, nu1, nu2, nu3, kk[1, 1]}, "completeStaticNumericRulesQ" ->
    False|>, "numericRuleTemplate" -> {E1 -> dSIBP`Private`numericValue[E1],
   E2 -> dSIBP`Private`numericValue[E2],
   E3 -> dSIBP`Private`numericValue[E3],
   nu1 -> dSIBP`Private`numericValue[nu1],
   nu2 -> dSIBP`Private`numericValue[nu2],
   nu3 -> dSIBP`Private`numericValue[nu3],
   ss11 -> dSIBP`Private`numericValue[ss11]},
 "tadpoleSymmetryData" -> <|"status" -> "generated",
   "loopReversalData" -> {}, "massiveFullLineIndices" -> {},
   "masslessFullLineIndices" -> {}, "automaticRuleCount" -> 1,
   "automaticRules" -> {HoldPattern[dSIBP`Private`int$_J /;
        dSIBP`Private`tadpoleOddISPIntegralQ[
         <|"name" -> "016BubbleBridgeTwoExternalLegs", "vertexData" ->
           {{v1, "+"}, {v2, "+"}, {v3, "+"}}, "vertexIds" -> {v1, v2, v3},
          "vertexSignAssoc" -> <|v1 -> "+", v2 -> "+", v3 -> "+"|>,
          "lines" -> {<|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
             "nu" -> nu1, "bbType" -> "h", "massType" -> "massive",
             "skType" -> "++", "state" -> "full", "thetaConvention" ->
              "mergedTwoTheta", "packType" -> "massiveFull",
             "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"],
             "masslessN1OppositeEndpoint" -> Missing["NotApplicable"],
             "functionSystem" -> <|"preset" -> "h", "variable" ->
                dSIBP`Private`x, "P" -> (1 + 2*nu1)/dSIBP`Private`x, "Q" ->
                1, "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu1])*
                  dSIBP`Private`x^(-1 - 2*nu1))/Pi, "WT" -> Automatic,
               "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 2*nu1|>,
             "compiledFunctionSystem" -> <|"status" -> "compiled", "input" ->
                <|"preset" -> "h", "variable" -> dSIBP`Private`x,
                 "P" -> (1 + 2*nu1)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1,
                  0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu1])*dSIBP`Private`x^
                     (-1 - 2*nu1))/Pi, "WT" -> Automatic, "shrinkBShift" ->
                  1, "shrinkZeroPointShift" -> 2*nu1|>, "variable" ->
                dSIBP`Private`x, "P" -> (1 + 2*nu1)/dSIBP`Private`x, "Q" ->
                1, "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu1])*
                  dSIBP`Private`x^(-1 - 2*nu1))/Pi, "A0" -> {{0, 1},
                 {-1, -((1 + 2*nu1)/dSIBP`Private`x)}}, "AT" ->
                {{0, 1}, {-1, -((1 + 2*nu1)/dSIBP`Private`x)}}, "WT" ->
                ((-4*I)*E^(Pi*Im[nu1])*dSIBP`Private`x^(-1 - 2*nu1))/Pi,
               "derivativeTerms" -> {<|"sourceState" -> 0, "targetState" ->
                   1, "xPower" -> 0, "coefficient" -> 1|>, <|"sourceState" ->
                   1, "targetState" -> 0, "xPower" -> 0, "coefficient" ->
                   -1|>, <|"sourceState" -> 1, "targetState" -> 1,
                  "xPower" -> -1, "coefficient" -> -1 - 2*nu1|>},
               "shrinkTerms" -> {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu1]))/
                    Pi, "xPower" -> -1 - 2*nu1, "bShift" -> 1,
                  "zeroPointShift" -> 2*nu1|>}, "shrinkZeroPointShift" ->
                2*nu1|>, "rawMomentum" -> q, "loopLineQ" -> True,
             "bridgeQ" -> False, "linePowerMode" -> "indexed"|>,
            <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> k + q,
             "nu" -> nu2, "bbType" -> "h", "massType" -> "massive",
             "skType" -> "++", "state" -> "full", "thetaConvention" ->
              "mergedTwoTheta", "packType" -> "massiveFull",
             "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"],
             "masslessN1OppositeEndpoint" -> Missing["NotApplicable"],
             "functionSystem" -> <|"preset" -> "h", "variable" ->
                dSIBP`Private`x, "P" -> (1 + 2*nu2)/dSIBP`Private`x, "Q" ->
                1, "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu2])*
                  dSIBP`Private`x^(-1 - 2*nu2))/Pi, "WT" -> Automatic,
               "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 2*nu2|>,
             "compiledFunctionSystem" -> <|"status" -> "compiled", "input" ->
                <|"preset" -> "h", "variable" -> dSIBP`Private`x,
                 "P" -> (1 + 2*nu2)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1,
                  0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu2])*dSIBP`Private`x^
                     (-1 - 2*nu2))/Pi, "WT" -> Automatic, "shrinkBShift" ->
                  1, "shrinkZeroPointShift" -> 2*nu2|>, "variable" ->
                dSIBP`Private`x, "P" -> (1 + 2*nu2)/dSIBP`Private`x, "Q" ->
                1, "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu2])*
                  dSIBP`Private`x^(-1 - 2*nu2))/Pi, "A0" -> {{0, 1},
                 {-1, -((1 + 2*nu2)/dSIBP`Private`x)}}, "AT" ->
                {{0, 1}, {-1, -((1 + 2*nu2)/dSIBP`Private`x)}}, "WT" ->
                ((-4*I)*E^(Pi*Im[nu2])*dSIBP`Private`x^(-1 - 2*nu2))/Pi,
               "derivativeTerms" -> {<|"sourceState" -> 0, "targetState" ->
                   1, "xPower" -> 0, "coefficient" -> 1|>, <|"sourceState" ->
                   1, "targetState" -> 0, "xPower" -> 0, "coefficient" ->
                   -1|>, <|"sourceState" -> 1, "targetState" -> 1,
                  "xPower" -> -1, "coefficient" -> -1 - 2*nu2|>},
               "shrinkTerms" -> {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu2]))/
                    Pi, "xPower" -> -1 - 2*nu2, "bShift" -> 1,
                  "zeroPointShift" -> 2*nu2|>}, "shrinkZeroPointShift" ->
                2*nu2|>, "rawMomentum" -> k + q, "loopLineQ" -> True,
             "bridgeQ" -> False, "linePowerMode" -> "indexed"|>,
            <|"id" -> 3, "endpoints" -> {v2, v3}, "momentum" -> p1 + p2,
             "treeEnergy" -> bridgeEnergy, "nu" -> nu3, "bbType" -> "h",
             "massType" -> "massive", "skType" -> "++", "state" -> "full",
             "thetaConvention" -> "mergedTwoTheta", "packType" ->
              "massiveFull", "masslessN1ReferenceEndpoint" ->
              Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
              Missing["NotApplicable"], "functionSystem" -> <|"preset" ->
                "h", "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu3)/
                 dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, "W" ->
                ((-4*I)*E^(Pi*Im[nu3])*dSIBP`Private`x^(-1 - 2*nu3))/Pi,
               "WT" -> Automatic, "shrinkBShift" -> 1,
               "shrinkZeroPointShift" -> 2*nu3|>, "compiledFunctionSystem" ->
              <|"status" -> "compiled", "input" -> <|"preset" -> "h",
                 "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu3)/
                   dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
                 "W" -> ((-4*I)*E^(Pi*Im[nu3])*dSIBP`Private`x^(-1 - 2*nu3))/
                   Pi, "WT" -> Automatic, "shrinkBShift" -> 1,
                 "shrinkZeroPointShift" -> 2*nu3|>, "variable" ->
                dSIBP`Private`x, "P" -> (1 + 2*nu3)/dSIBP`Private`x, "Q" ->
                1, "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu3])*
                  dSIBP`Private`x^(-1 - 2*nu3))/Pi, "A0" -> {{0, 1},
                 {-1, -((1 + 2*nu3)/dSIBP`Private`x)}}, "AT" ->
                {{0, 1}, {-1, -((1 + 2*nu3)/dSIBP`Private`x)}}, "WT" ->
                ((-4*I)*E^(Pi*Im[nu3])*dSIBP`Private`x^(-1 - 2*nu3))/Pi,
               "derivativeTerms" -> {<|"sourceState" -> 0, "targetState" ->
                   1, "xPower" -> 0, "coefficient" -> 1|>, <|"sourceState" ->
                   1, "targetState" -> 0, "xPower" -> 0, "coefficient" ->
                   -1|>, <|"sourceState" -> 1, "targetState" -> 1,
                  "xPower" -> -1, "coefficient" -> -1 - 2*nu3|>},
               "shrinkTerms" -> {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu3]))/
                    Pi, "xPower" -> -1 - 2*nu3, "bShift" -> 1,
                  "zeroPointShift" -> 2*nu3|>}, "shrinkZeroPointShift" ->
                2*nu3|>, "rawMomentum" -> p1 + p2, "loopLineQ" -> False,
             "bridgeQ" -> True, "linePowerMode" -> "fixedCoefficient"|>},
          "extLegs" -> {{leg1, v3, p1}, {leg2, v3, p2}}, "vertexEnergies" ->
           <|v1 -> E1, v2 -> E2, v3 -> E3|>, "activeVertexIds" ->
           {v1, v2, v3}, "fixedAVertexValues" -> <||>, "loopMomenta" -> {q},
          "ibpMode" -> "full", "graphLoopCount" -> 1, "graphTopologyAudit" ->
           <|"status" -> "valid", "vertexCount" -> 3, "inputLineCount" -> 3,
            "internalLineCount" -> 3, "activeLineIndices" -> {1, 2, 3},
            "shrunkLineIndices" -> {}, "connectedComponentCount" -> 1,
            "graphLoopCount" -> 1, "bridgeLineIndices" -> {3},
            "cycleLineIndices" -> {1, 2}, "selfLoopLineIndices" -> {},
            "incidenceMatrix" -> {{1, 1, 0}, {-1, -1, 1}, {0, 0, -1}},
            "cycleSpaceDimension" -> 1, "issues" -> {}|>,
          "loopMomentumRoutingAudit" -> <|"status" -> "valid",
            "ibpMode" -> "full", "loopMomenta" -> {q},
            "loopCoefficientMatrix" -> {{1}, {1}, {0}},
            "loopCoefficientRank" -> 1, "lineExternalResiduals" ->
             {0, k, p1 + p2}, "referenceLineIndices" -> {1},
            "referenceLoopMatrix" -> {{1}}, "referenceExternalResiduals" ->
             {0}, "shiftInvariantLineResiduals" -> {0, k, p1 + p2},
            "incidenceCycleResidual" -> {{0}, {0}, {0}}, "issues" -> {}|>,
          "normalizedLineMomenta" -> {q, k + q, p1 + p2},
          "momentumDeclarationAudit" -> <|"status" -> "exact",
            "ibpMode" -> "full", "loopExternalMomenta" -> {k},
            "independentExternalMomenta" -> {p1, p2, p1 + p2},
            "requiredLoopExternalDirections" -> {k},
            "requiredIndependentMomentumMagnitudes" -> {-p1 - p2, -p1, -p2},
            "momentumAtoms" -> {k, p1, p2}, "loopExternalAudit" ->
             <|"status" -> "exact", "atoms" -> {k, p1, p2},
              "requiredExpressions" -> {k}, "userExpressions" -> {k},
              "requiredBasisDirections" -> {k}, "userBasisDirections" -> {k},
              "missingDirections" -> {}, "extraDirections" -> {},
              "userDependencyVectors" -> {}, "requiredRank" -> 1,
              "userRank" -> 1, "unionRank" -> 1,
              "invalidRequiredPositions" -> {}, "invalidUserPositions" -> {
                }|>, "independentExternalAudit" -> <|"status" -> "exact",
              "atoms" -> {k, p1, p2}, "loopGramRank" -> 1,
              "requiredMomenta" -> {-p1 - p2, -p1, -p2}, "userMomenta" -> {
                p1, p2, p1 + p2}, "missingMagnitudeSquares" -> {},
              "extraMagnitudeSquares" -> {},
              "requiredIndependentMagnitudeCount" -> 3,
              "userIndependentMagnitudeCount" -> 3,
              "invalidRequiredPositions" -> {}, "invalidUserPositions" -> {},
              "invalidLoopPositions" -> {}, "missingQuadraticRows" -> {},
              "extraQuadraticRows" -> {}|>, "capabilities" ->
             <|"initializationUsableQ" -> True, "timeIBPUsableQ" -> True,
              "momentumIBPUsableQ" -> True, "derivativeUsableQ" -> True,
              "inverseKinematicsUsableQ" -> True|>, "issues" -> {}|>,
          "capabilities" -> <|"initializationUsableQ" -> True,
            "timeIBPUsableQ" -> True, "momentumIBPUsableQ" -> True,
            "derivativeUsableQ" -> True, "inverseKinematicsUsableQ" ->
             True|>, "cycleLineIndices" -> {1, 2}, "bridgeLineIndices" ->
           {3}, "loopExternalMomenta" -> {k},
          "effectiveLoopExternalMomenta" -> {k},
          "independentExternalMomenta" -> {p1, p2, p1 + p2},
          "momentumDecompositionBasis" -> {q, k, p1, p2},
          "fixedExternalVectorAtoms" -> {p1, p2}, "externalMomenta" -> {k},
          "externalLegMomenta" -> {p1, p2, p1 + p2},
          "rawExternalInvariantRules" -> {sp[k, k] -> ss11^2},
          "externalInvariantRules" -> {sp[k, k] -> ss11^2},
          "rawExternalLegInvariantRules" -> {sp[p1, p1] -> sE1^2,
            sp[p2, p2] -> sE2^2, sp[p1 + p2, p1 + p2] -> sE3^2},
          "externalLegInvariantRules" -> {sp[p1, p1] -> sE1^2,
            sp[p2, p2] -> sE2^2, sp[p1 + p2, p1 + p2] -> sE3^2},
          "kinematicRules" -> Automatic, "kinematicCoordinateAudit" ->
           <|"status" -> "complete", "source" -> "default",
            "baseCoordinateData" -> {<|"baseIndex" -> 1, "kind" ->
                "loopExternalGram", "inputExpression" -> sp[k, k],
               "internalVariable" -> kk[1, 1], "defaultVariable" -> ss11,
               "defaultRHS" -> ss11^2|>, <|"occurrenceIndex" -> 1,
               "momentum" -> p1, "squaredExpression" -> sp[p1, p1],
               "magnitudeExpression" -> Sqrt[sp[p1, p1]], "gramVector" ->
                {0, 0, 0, 1, 0, 0}, "baseCoefficients" -> {0, 1, 0, 0},
               "independentQ" -> True, "externalLegIndex" -> 1,
               "userVariable" -> sE1, "defaultSquaredExpression" -> sE1^2,
               "baseIndex" -> 2, "kind" -> "externalLegMagnitude",
               "inputExpression" -> sp[p1, p1], "internalVariable" ->
                dSIBP`Private`externalLegSquaredCoordinate[1],
               "defaultVariable" -> sE1, "defaultRHS" -> sE1^2|>,
              <|"occurrenceIndex" -> 2, "momentum" -> p2,
               "squaredExpression" -> sp[p2, p2], "magnitudeExpression" ->
                Sqrt[sp[p2, p2]], "gramVector" -> {0, 0, 0, 0, 0, 1},
               "baseCoefficients" -> {0, 0, 1, 0}, "independentQ" -> True,
               "externalLegIndex" -> 2, "userVariable" -> sE2,
               "defaultSquaredExpression" -> sE2^2, "baseIndex" -> 3,
               "kind" -> "externalLegMagnitude", "inputExpression" ->
                sp[p2, p2], "internalVariable" ->
                dSIBP`Private`externalLegSquaredCoordinate[2],
               "defaultVariable" -> sE2, "defaultRHS" -> sE2^2|>,
              <|"occurrenceIndex" -> 3, "momentum" -> p1 + p2,
               "squaredExpression" -> sp[p1 + p2, p1 + p2],
               "magnitudeExpression" -> Sqrt[sp[p1 + p2, p1 + p2]],
               "gramVector" -> {0, 0, 0, 1, 2, 1}, "baseCoefficients" -> {0,
                0, 0, 1}, "independentQ" -> True, "externalLegIndex" -> 3,
               "userVariable" -> sE3, "defaultSquaredExpression" -> sE3^2,
               "baseIndex" -> 4, "kind" -> "externalLegMagnitude",
               "inputExpression" -> sp[p1 + p2, p1 + p2],
               "internalVariable" ->
                dSIBP`Private`externalLegSquaredCoordinate[3],
               "defaultVariable" -> sE3, "defaultRHS" -> sE3^2|>},
            "baseCoordinateOrder" -> {sp[k, k], sp[p1, p1], sp[p2, p2],
              sp[p1 + p2, p1 + p2]}, "baseCoordinateCount" -> 4,
            "defaultRules" -> {sp[k, k] -> ss11^2, sp[p1, p1] -> sE1^2,
              sp[p2, p2] -> sE2^2, sp[p1 + p2, p1 + p2] -> sE3^2},
            "selectionTemplate" -> "kinematicRules" -> {sp[k, k] -> ss11^2,
               sp[p1, p1] -> sE1^2, sp[p2, p2] -> sE2^2, sp[p1 + p2,
                 p1 + p2] -> sE3^2}, "selectedRules" -> {sp[k, k] -> ss11^2,
              sp[p1, p1] -> sE1^2, sp[p2, p2] -> sE2^2, sp[p1 + p2,
                p1 + p2] -> sE3^2}, "selectedUserVariables" ->
             {ss11, sE1, sE2, sE3}, "userParameterOrder" -> {ss11, sE1, sE2,
              sE3}, "coordinateMatrix" -> {{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0,
              1, 0}, {0, 0, 0, 1}}, "coordinateRank" -> 4,
            "parameterJacobian" -> {{2*ss11, 0, 0, 0}, {0, 2*sE1, 0, 0},
              {0, 0, 2*sE2, 0}, {0, 0, 0, 2*sE3}}, "parameterRank" -> 4,
            "missingDirections" -> {}, "ruleMissingDirections" -> {},
            "parameterMissingDirections" -> {},
            "ruleMissingDirectionExpressions" -> {},
            "parameterMissingDirectionExpressions" -> {},
            "ruleDependencies" -> {}, "ruleDependencyResiduals" -> {},
            "parameterDependencies" -> {}, "constraintResiduals" -> {},
            "unsupportedRulePositions" -> {}, "completeQ" -> True,
            "overcompleteQ" -> False, "inverseAvailableQ" -> True,
            "resolvedRules" -> {sp[k, k] -> ss11^2, sp[p1, p1] -> sE1^2,
              sp[p2, p2] -> sE2^2, sp[p1 + p2, p1 + p2] -> sE3^2},
            "baseSquaredUserExpressions" -> {ss11^2, sE1^2, sE2^2, sE3^2},
            "baseRootUserExpressions" -> {ss11, sE1, sE2, sE3},
            "appearingNoLoopMagnitudeMomenta" -> {p1, p2, p1 + p2},
            "independentNoLoopMagnitudeMomenta" -> {p1, p2, p1 + p2},
            "dependentMagnitudeBindings" -> {}, "rawLoopRules" ->
             {sp[k, k] -> ss11^2}, "resolvedLoopRules" ->
             {sp[k, k] -> ss11^2}, "rawExternalLegRules" ->
             {sp[p1, p1] -> sE1^2, sp[p2, p2] -> sE2^2, sp[p1 + p2,
                p1 + p2] -> sE3^2}, "resolvedExternalLegRules" ->
             {sp[p1, p1] -> sE1^2, sp[p2, p2] -> sE2^2, sp[p1 + p2,
                p1 + p2] -> sE3^2}, "message" -> "\:52a8\:529b\:5b66\:53d8\
\:91cf\:5b8c\:5907\:ff0c\:4e14\:5f53\:524d\:7b80\:5355\:5750\:6807\:89c4\
\:5219\:53ef\:53cd\:5411\:8f6c\:6362\:3002"|>, "ispData" -> {}, "nV" -> 3,
          "nE" -> 3, "nL" -> 1, "nK" -> 1, "bMatrix" ->
           {{1, 1, 0}, {-1, -1, 1}, {0, 0, -1}}, "vertexLines" ->
           {{{1, 1}, {2, 1}}, {{1, -1}, {2, -1}, {3, 1}}, {{3, -1}}},
          "loopCoeffMatrix" -> {{1}, {1}, {0}}, "externalCoeffMatrix" ->
           {{0}, {1}, {0}}, "externalPartList" -> {0, k, p1 + p2},
          "rawNumericRules" -> {}, "numericRules" -> {},
          "sampleDiscreteRules" -> {}, "seedPreset" -> "quickCheck",
          "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0},
            "sampleOnly" -> True|>, "generatorSeedRanges" -> {},
          "seedOptions" -> <|"DiscreteMode" -> "sample",
            "MaxSeedRuleCount" -> 200, "MaxDiscreteRuleCount" -> 64,
            "MaxEquationCount" -> 80, "MaxShrinkSectorDepth" -> Automatic,
            "MaxShrinkSectorCount" -> 16|>, "unknownSeedPreset" -> None,
          "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2,
            a0[v3] -> alpha3, b0[1] -> beta1, b0[2] -> beta2,
            b0[3] -> beta3}, "shrinkPrefactorRules" -> {},
          "symmetryRules" -> {}, "thetaBoundarySignOffset" -> Automatic,
          "kiraOrdering" -> <||>, "sectorVertexRepresentativeMap" ->
           <|v1 -> v1, v2 -> v2, v3 -> v3|>|>, dSIBP`Private`int$]] :> 0},
   "userRuleCount" -> 0, "effectiveRuleCount" -> 1|>,
 "effectiveSymmetryRules" ->
  {HoldPattern[dSIBP`Private`int$_J /; dSIBP`Private`tadpoleOddISPIntegralQ[
       <|"name" -> "016BubbleBridgeTwoExternalLegs", "vertexData" ->
         {{v1, "+"}, {v2, "+"}, {v3, "+"}}, "vertexIds" -> {v1, v2, v3},
        "vertexSignAssoc" -> <|v1 -> "+", v2 -> "+", v3 -> "+"|>,
        "lines" -> {<|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
           "nu" -> nu1, "bbType" -> "h", "massType" -> "massive",
           "skType" -> "++", "state" -> "full", "thetaConvention" ->
            "mergedTwoTheta", "packType" -> "massiveFull",
           "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"],
           "masslessN1OppositeEndpoint" -> Missing["NotApplicable"],
           "functionSystem" -> <|"preset" -> "h", "variable" ->
              dSIBP`Private`x, "P" -> (1 + 2*nu1)/dSIBP`Private`x, "Q" -> 1,
             "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu1])*
                dSIBP`Private`x^(-1 - 2*nu1))/Pi, "WT" -> Automatic,
             "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 2*nu1|>,
           "compiledFunctionSystem" -> <|"status" -> "compiled",
             "input" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x,
               "P" -> (1 + 2*nu1)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0},
                {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu1])*dSIBP`Private`x^
                   (-1 - 2*nu1))/Pi, "WT" -> Automatic, "shrinkBShift" ->
                1, "shrinkZeroPointShift" -> 2*nu1|>, "variable" ->
              dSIBP`Private`x, "P" -> (1 + 2*nu1)/dSIBP`Private`x, "Q" -> 1,
             "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu1])*
                dSIBP`Private`x^(-1 - 2*nu1))/Pi, "A0" -> {{0, 1}, {-1,
                -((1 + 2*nu1)/dSIBP`Private`x)}}, "AT" -> {{0, 1}, {-1,
                -((1 + 2*nu1)/dSIBP`Private`x)}}, "WT" ->
              ((-4*I)*E^(Pi*Im[nu1])*dSIBP`Private`x^(-1 - 2*nu1))/Pi,
             "derivativeTerms" -> {<|"sourceState" -> 0, "targetState" -> 1,
                "xPower" -> 0, "coefficient" -> 1|>, <|"sourceState" -> 1,
                "targetState" -> 0, "xPower" -> 0, "coefficient" -> -1|>, <|
                "sourceState" -> 1, "targetState" -> 1, "xPower" -> -1,
                "coefficient" -> -1 - 2*nu1|>}, "shrinkTerms" ->
              {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu1]))/Pi, "xPower" ->
                 -1 - 2*nu1, "bShift" -> 1, "zeroPointShift" -> 2*nu1|>},
             "shrinkZeroPointShift" -> 2*nu1|>, "rawMomentum" -> q,
           "loopLineQ" -> True, "bridgeQ" -> False, "linePowerMode" ->
            "indexed"|>, <|"id" -> 2, "endpoints" -> {v1, v2},
           "momentum" -> k + q, "nu" -> nu2, "bbType" -> "h",
           "massType" -> "massive", "skType" -> "++", "state" -> "full",
           "thetaConvention" -> "mergedTwoTheta", "packType" ->
            "massiveFull", "masslessN1ReferenceEndpoint" ->
            Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
            Missing["NotApplicable"], "functionSystem" -> <|"preset" -> "h",
             "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu2)/
               dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
             "W" -> ((-4*I)*E^(Pi*Im[nu2])*dSIBP`Private`x^(-1 - 2*nu2))/Pi,
             "WT" -> Automatic, "shrinkBShift" -> 1,
             "shrinkZeroPointShift" -> 2*nu2|>, "compiledFunctionSystem" ->
            <|"status" -> "compiled", "input" -> <|"preset" -> "h",
               "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu2)/
                 dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, "W" ->
                ((-4*I)*E^(Pi*Im[nu2])*dSIBP`Private`x^(-1 - 2*nu2))/Pi,
               "WT" -> Automatic, "shrinkBShift" -> 1,
               "shrinkZeroPointShift" -> 2*nu2|>, "variable" ->
              dSIBP`Private`x, "P" -> (1 + 2*nu2)/dSIBP`Private`x, "Q" -> 1,
             "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu2])*
                dSIBP`Private`x^(-1 - 2*nu2))/Pi, "A0" -> {{0, 1}, {-1,
                -((1 + 2*nu2)/dSIBP`Private`x)}}, "AT" -> {{0, 1}, {-1,
                -((1 + 2*nu2)/dSIBP`Private`x)}}, "WT" ->
              ((-4*I)*E^(Pi*Im[nu2])*dSIBP`Private`x^(-1 - 2*nu2))/Pi,
             "derivativeTerms" -> {<|"sourceState" -> 0, "targetState" -> 1,
                "xPower" -> 0, "coefficient" -> 1|>, <|"sourceState" -> 1,
                "targetState" -> 0, "xPower" -> 0, "coefficient" -> -1|>, <|
                "sourceState" -> 1, "targetState" -> 1, "xPower" -> -1,
                "coefficient" -> -1 - 2*nu2|>}, "shrinkTerms" ->
              {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu2]))/Pi, "xPower" ->
                 -1 - 2*nu2, "bShift" -> 1, "zeroPointShift" -> 2*nu2|>},
             "shrinkZeroPointShift" -> 2*nu2|>, "rawMomentum" -> k + q,
           "loopLineQ" -> True, "bridgeQ" -> False, "linePowerMode" ->
            "indexed"|>, <|"id" -> 3, "endpoints" -> {v2, v3},
           "momentum" -> p1 + p2, "treeEnergy" -> bridgeEnergy, "nu" -> nu3,
           "bbType" -> "h", "massType" -> "massive", "skType" -> "++",
           "state" -> "full", "thetaConvention" -> "mergedTwoTheta",
           "packType" -> "massiveFull", "masslessN1ReferenceEndpoint" ->
            Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
            Missing["NotApplicable"], "functionSystem" -> <|"preset" -> "h",
             "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu3)/
               dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
             "W" -> ((-4*I)*E^(Pi*Im[nu3])*dSIBP`Private`x^(-1 - 2*nu3))/Pi,
             "WT" -> Automatic, "shrinkBShift" -> 1,
             "shrinkZeroPointShift" -> 2*nu3|>, "compiledFunctionSystem" ->
            <|"status" -> "compiled", "input" -> <|"preset" -> "h",
               "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu3)/
                 dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, "W" ->
                ((-4*I)*E^(Pi*Im[nu3])*dSIBP`Private`x^(-1 - 2*nu3))/Pi,
               "WT" -> Automatic, "shrinkBShift" -> 1,
               "shrinkZeroPointShift" -> 2*nu3|>, "variable" ->
              dSIBP`Private`x, "P" -> (1 + 2*nu3)/dSIBP`Private`x, "Q" -> 1,
             "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu3])*
                dSIBP`Private`x^(-1 - 2*nu3))/Pi, "A0" -> {{0, 1}, {-1,
                -((1 + 2*nu3)/dSIBP`Private`x)}}, "AT" -> {{0, 1}, {-1,
                -((1 + 2*nu3)/dSIBP`Private`x)}}, "WT" ->
              ((-4*I)*E^(Pi*Im[nu3])*dSIBP`Private`x^(-1 - 2*nu3))/Pi,
             "derivativeTerms" -> {<|"sourceState" -> 0, "targetState" -> 1,
                "xPower" -> 0, "coefficient" -> 1|>, <|"sourceState" -> 1,
                "targetState" -> 0, "xPower" -> 0, "coefficient" -> -1|>, <|
                "sourceState" -> 1, "targetState" -> 1, "xPower" -> -1,
                "coefficient" -> -1 - 2*nu3|>}, "shrinkTerms" ->
              {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu3]))/Pi, "xPower" ->
                 -1 - 2*nu3, "bShift" -> 1, "zeroPointShift" -> 2*nu3|>},
             "shrinkZeroPointShift" -> 2*nu3|>, "rawMomentum" -> p1 + p2,
           "loopLineQ" -> False, "bridgeQ" -> True, "linePowerMode" ->
            "fixedCoefficient"|>}, "extLegs" -> {{leg1, v3, p1},
          {leg2, v3, p2}}, "vertexEnergies" -> <|v1 -> E1, v2 -> E2,
          v3 -> E3|>, "activeVertexIds" -> {v1, v2, v3},
        "fixedAVertexValues" -> <||>, "loopMomenta" -> {q},
        "ibpMode" -> "full", "graphLoopCount" -> 1, "graphTopologyAudit" ->
         <|"status" -> "valid", "vertexCount" -> 3, "inputLineCount" -> 3,
          "internalLineCount" -> 3, "activeLineIndices" -> {1, 2, 3},
          "shrunkLineIndices" -> {}, "connectedComponentCount" -> 1,
          "graphLoopCount" -> 1, "bridgeLineIndices" -> {3},
          "cycleLineIndices" -> {1, 2}, "selfLoopLineIndices" -> {},
          "incidenceMatrix" -> {{1, 1, 0}, {-1, -1, 1}, {0, 0, -1}},
          "cycleSpaceDimension" -> 1, "issues" -> {}|>,
        "loopMomentumRoutingAudit" -> <|"status" -> "valid",
          "ibpMode" -> "full", "loopMomenta" -> {q},
          "loopCoefficientMatrix" -> {{1}, {1}, {0}},
          "loopCoefficientRank" -> 1, "lineExternalResiduals" ->
           {0, k, p1 + p2}, "referenceLineIndices" -> {1},
          "referenceLoopMatrix" -> {{1}}, "referenceExternalResiduals" ->
           {0}, "shiftInvariantLineResiduals" -> {0, k, p1 + p2},
          "incidenceCycleResidual" -> {{0}, {0}, {0}}, "issues" -> {}|>,
        "normalizedLineMomenta" -> {q, k + q, p1 + p2},
        "momentumDeclarationAudit" -> <|"status" -> "exact",
          "ibpMode" -> "full", "loopExternalMomenta" -> {k},
          "independentExternalMomenta" -> {p1, p2, p1 + p2},
          "requiredLoopExternalDirections" -> {k},
          "requiredIndependentMomentumMagnitudes" -> {-p1 - p2, -p1, -p2},
          "momentumAtoms" -> {k, p1, p2}, "loopExternalAudit" ->
           <|"status" -> "exact", "atoms" -> {k, p1, p2},
            "requiredExpressions" -> {k}, "userExpressions" -> {k},
            "requiredBasisDirections" -> {k}, "userBasisDirections" -> {k},
            "missingDirections" -> {}, "extraDirections" -> {},
            "userDependencyVectors" -> {}, "requiredRank" -> 1,
            "userRank" -> 1, "unionRank" -> 1, "invalidRequiredPositions" ->
             {}, "invalidUserPositions" -> {}|>,
          "independentExternalAudit" -> <|"status" -> "exact",
            "atoms" -> {k, p1, p2}, "loopGramRank" -> 1, "requiredMomenta" ->
             {-p1 - p2, -p1, -p2}, "userMomenta" -> {p1, p2, p1 + p2},
            "missingMagnitudeSquares" -> {}, "extraMagnitudeSquares" -> {},
            "requiredIndependentMagnitudeCount" -> 3,
            "userIndependentMagnitudeCount" -> 3,
            "invalidRequiredPositions" -> {}, "invalidUserPositions" -> {},
            "invalidLoopPositions" -> {}, "missingQuadraticRows" -> {},
            "extraQuadraticRows" -> {}|>, "capabilities" ->
           <|"initializationUsableQ" -> True, "timeIBPUsableQ" -> True,
            "momentumIBPUsableQ" -> True, "derivativeUsableQ" -> True,
            "inverseKinematicsUsableQ" -> True|>, "issues" -> {}|>,
        "capabilities" -> <|"initializationUsableQ" -> True,
          "timeIBPUsableQ" -> True, "momentumIBPUsableQ" -> True,
          "derivativeUsableQ" -> True, "inverseKinematicsUsableQ" -> True|>,
        "cycleLineIndices" -> {1, 2}, "bridgeLineIndices" -> {3},
        "loopExternalMomenta" -> {k}, "effectiveLoopExternalMomenta" -> {k},
        "independentExternalMomenta" -> {p1, p2, p1 + p2},
        "momentumDecompositionBasis" -> {q, k, p1, p2},
        "fixedExternalVectorAtoms" -> {p1, p2}, "externalMomenta" -> {k},
        "externalLegMomenta" -> {p1, p2, p1 + p2},
        "rawExternalInvariantRules" -> {sp[k, k] -> ss11^2},
        "externalInvariantRules" -> {sp[k, k] -> ss11^2},
        "rawExternalLegInvariantRules" -> {sp[p1, p1] -> sE1^2,
          sp[p2, p2] -> sE2^2, sp[p1 + p2, p1 + p2] -> sE3^2},
        "externalLegInvariantRules" -> {sp[p1, p1] -> sE1^2,
          sp[p2, p2] -> sE2^2, sp[p1 + p2, p1 + p2] -> sE3^2},
        "kinematicRules" -> Automatic, "kinematicCoordinateAudit" ->
         <|"status" -> "complete", "source" -> "default",
          "baseCoordinateData" -> {<|"baseIndex" -> 1, "kind" ->
              "loopExternalGram", "inputExpression" -> sp[k, k],
             "internalVariable" -> kk[1, 1], "defaultVariable" -> ss11,
             "defaultRHS" -> ss11^2|>, <|"occurrenceIndex" -> 1,
             "momentum" -> p1, "squaredExpression" -> sp[p1, p1],
             "magnitudeExpression" -> Sqrt[sp[p1, p1]], "gramVector" ->
              {0, 0, 0, 1, 0, 0}, "baseCoefficients" -> {0, 1, 0, 0},
             "independentQ" -> True, "externalLegIndex" -> 1,
             "userVariable" -> sE1, "defaultSquaredExpression" -> sE1^2,
             "baseIndex" -> 2, "kind" -> "externalLegMagnitude",
             "inputExpression" -> sp[p1, p1], "internalVariable" ->
              dSIBP`Private`externalLegSquaredCoordinate[1],
             "defaultVariable" -> sE1, "defaultRHS" -> sE1^2|>,
            <|"occurrenceIndex" -> 2, "momentum" -> p2,
             "squaredExpression" -> sp[p2, p2], "magnitudeExpression" ->
              Sqrt[sp[p2, p2]], "gramVector" -> {0, 0, 0, 0, 0, 1},
             "baseCoefficients" -> {0, 0, 1, 0}, "independentQ" -> True,
             "externalLegIndex" -> 2, "userVariable" -> sE2,
             "defaultSquaredExpression" -> sE2^2, "baseIndex" -> 3,
             "kind" -> "externalLegMagnitude", "inputExpression" ->
              sp[p2, p2], "internalVariable" ->
              dSIBP`Private`externalLegSquaredCoordinate[2],
             "defaultVariable" -> sE2, "defaultRHS" -> sE2^2|>,
            <|"occurrenceIndex" -> 3, "momentum" -> p1 + p2,
             "squaredExpression" -> sp[p1 + p2, p1 + p2],
             "magnitudeExpression" -> Sqrt[sp[p1 + p2, p1 + p2]],
             "gramVector" -> {0, 0, 0, 1, 2, 1}, "baseCoefficients" -> {0, 0,
              0, 1}, "independentQ" -> True, "externalLegIndex" -> 3,
             "userVariable" -> sE3, "defaultSquaredExpression" -> sE3^2,
             "baseIndex" -> 4, "kind" -> "externalLegMagnitude",
             "inputExpression" -> sp[p1 + p2, p1 + p2], "internalVariable" ->
              dSIBP`Private`externalLegSquaredCoordinate[3],
             "defaultVariable" -> sE3, "defaultRHS" -> sE3^2|>},
          "baseCoordinateOrder" -> {sp[k, k], sp[p1, p1], sp[p2, p2],
            sp[p1 + p2, p1 + p2]}, "baseCoordinateCount" -> 4,
          "defaultRules" -> {sp[k, k] -> ss11^2, sp[p1, p1] -> sE1^2,
            sp[p2, p2] -> sE2^2, sp[p1 + p2, p1 + p2] -> sE3^2},
          "selectionTemplate" -> "kinematicRules" -> {sp[k, k] -> ss11^2,
             sp[p1, p1] -> sE1^2, sp[p2, p2] -> sE2^2,
             sp[p1 + p2, p1 + p2] -> sE3^2}, "selectedRules" ->
           {sp[k, k] -> ss11^2, sp[p1, p1] -> sE1^2, sp[p2, p2] -> sE2^2,
            sp[p1 + p2, p1 + p2] -> sE3^2}, "selectedUserVariables" ->
           {ss11, sE1, sE2, sE3}, "userParameterOrder" -> {ss11, sE1, sE2,
            sE3}, "coordinateMatrix" -> {{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0,
            1, 0}, {0, 0, 0, 1}}, "coordinateRank" -> 4,
          "parameterJacobian" -> {{2*ss11, 0, 0, 0}, {0, 2*sE1, 0, 0},
            {0, 0, 2*sE2, 0}, {0, 0, 0, 2*sE3}}, "parameterRank" -> 4,
          "missingDirections" -> {}, "ruleMissingDirections" -> {},
          "parameterMissingDirections" -> {},
          "ruleMissingDirectionExpressions" -> {},
          "parameterMissingDirectionExpressions" -> {}, "ruleDependencies" ->
           {}, "ruleDependencyResiduals" -> {}, "parameterDependencies" ->
           {}, "constraintResiduals" -> {}, "unsupportedRulePositions" -> {},
          "completeQ" -> True, "overcompleteQ" -> False,
          "inverseAvailableQ" -> True, "resolvedRules" ->
           {sp[k, k] -> ss11^2, sp[p1, p1] -> sE1^2, sp[p2, p2] -> sE2^2,
            sp[p1 + p2, p1 + p2] -> sE3^2}, "baseSquaredUserExpressions" ->
           {ss11^2, sE1^2, sE2^2, sE3^2}, "baseRootUserExpressions" ->
           {ss11, sE1, sE2, sE3}, "appearingNoLoopMagnitudeMomenta" ->
           {p1, p2, p1 + p2}, "independentNoLoopMagnitudeMomenta" ->
           {p1, p2, p1 + p2}, "dependentMagnitudeBindings" -> {},
          "rawLoopRules" -> {sp[k, k] -> ss11^2}, "resolvedLoopRules" ->
           {sp[k, k] -> ss11^2}, "rawExternalLegRules" ->
           {sp[p1, p1] -> sE1^2, sp[p2, p2] -> sE2^2, sp[p1 + p2, p1 + p2] ->
             sE3^2}, "resolvedExternalLegRules" -> {sp[p1, p1] -> sE1^2,
            sp[p2, p2] -> sE2^2, sp[p1 + p2, p1 + p2] -> sE3^2},
          "message" -> "\:52a8\:529b\:5b66\:53d8\:91cf\:5b8c\:5907\:ff0c\
\:4e14\:5f53\:524d\:7b80\:5355\:5750\:6807\:89c4\:5219\:53ef\:53cd\:5411\
\:8f6c\:6362\:3002"|>, "ispData" -> {}, "nV" -> 3, "nE" -> 3, "nL" -> 1,
        "nK" -> 1, "bMatrix" -> {{1, 1, 0}, {-1, -1, 1}, {0, 0, -1}},
        "vertexLines" -> {{{1, 1}, {2, 1}}, {{1, -1}, {2, -1}, {3, 1}},
          {{3, -1}}}, "loopCoeffMatrix" -> {{1}, {1}, {0}},
        "externalCoeffMatrix" -> {{0}, {1}, {0}}, "externalPartList" ->
         {0, k, p1 + p2}, "rawNumericRules" -> {}, "numericRules" -> {},
        "sampleDiscreteRules" -> {}, "seedPreset" -> "quickCheck",
        "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0},
          "sampleOnly" -> True|>, "generatorSeedRanges" -> {},
        "seedOptions" -> <|"DiscreteMode" -> "sample", "MaxSeedRuleCount" ->
           200, "MaxDiscreteRuleCount" -> 64, "MaxEquationCount" -> 80,
          "MaxShrinkSectorDepth" -> Automatic, "MaxShrinkSectorCount" ->
           16|>, "unknownSeedPreset" -> None, "zeroPointRules" ->
         {a0[v1] -> alpha1, a0[v2] -> alpha2, a0[v3] -> alpha3,
          b0[1] -> beta1, b0[2] -> beta2, b0[3] -> beta3},
        "shrinkPrefactorRules" -> {}, "symmetryRules" -> {},
        "thetaBoundarySignOffset" -> Automatic, "kiraOrdering" -> <||>,
        "sectorVertexRepresentativeMap" -> <|v1 -> v1, v2 -> v2,
          v3 -> v3|>|>, dSIBP`Private`int$]] :> 0},
 "masslessBundleCandidates" -> {}, "masslessEndpointConventions" -> {},
 "precomputedShrinkSectorSummary" -> <|"status" -> "generated",
   "completeCoverageQ" -> True|>, "precomputedShrinkSectorKeys" ->
  {"top", "e1", "e2", "e3", "e1_e3", "e2_e3"}|>
