<|"name" -> "rootKinematicCoordinatesExample", 
 "vertexData" -> {{v1, "+"}, {v2, "+"}}, "vertexIds" -> {v1, v2}, 
 "vertexSignAssoc" -> <|v1 -> "+", v2 -> "+"|>, 
 "lines" -> {<|"id" -> e1, "endpoints" -> {v1, v2}, "momentum" -> q, 
    "nu" -> nu0, "bbType" -> "h", "massType" -> "massive", "skType" -> "++", 
    "state" -> "full", "thetaConvention" -> "mergedTwoTheta", 
    "packType" -> "massiveFull", "masslessN1ReferenceEndpoint" -> 
     Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
     Missing["NotApplicable"], "functionSystem" -> 
     <|"preset" -> "h", "variable" -> dSIBP`Private`x, 
      "P" -> (1 + 2*nu0)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, 
      "W" -> ((-4*I)*E^(Pi*Im[nu0])*dSIBP`Private`x^(-1 - 2*nu0))/Pi, 
      "WT" -> Automatic, "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 
       2*nu0|>, "compiledFunctionSystem" -> <|"status" -> "compiled", 
      "input" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x, 
        "P" -> (1 + 2*nu0)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 
         1}}, "W" -> ((-4*I)*E^(Pi*Im[nu0])*dSIBP`Private`x^(-1 - 2*nu0))/Pi, 
        "WT" -> Automatic, "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 
         2*nu0|>, "variable" -> dSIBP`Private`x, 
      "P" -> (1 + 2*nu0)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, 
      "W" -> ((-4*I)*E^(Pi*Im[nu0])*dSIBP`Private`x^(-1 - 2*nu0))/Pi, 
      "A0" -> {{0, 1}, {-1, -((1 + 2*nu0)/dSIBP`Private`x)}}, 
      "AT" -> {{0, 1}, {-1, -((1 + 2*nu0)/dSIBP`Private`x)}}, 
      "WT" -> ((-4*I)*E^(Pi*Im[nu0])*dSIBP`Private`x^(-1 - 2*nu0))/Pi, 
      "derivativeTerms" -> {<|"sourceState" -> 0, "targetState" -> 1, 
         "xPower" -> 0, "coefficient" -> 1|>, <|"sourceState" -> 1, 
         "targetState" -> 0, "xPower" -> 0, "coefficient" -> -1|>, 
        <|"sourceState" -> 1, "targetState" -> 1, "xPower" -> -1, 
         "coefficient" -> -1 - 2*nu0|>}, "shrinkTerms" -> 
       {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu0]))/Pi, "xPower" -> -1 - 2*nu0, 
         "bShift" -> 1, "zeroPointShift" -> 2*nu0|>}, 
      "shrinkZeroPointShift" -> 2*nu0|>|>, 
   <|"id" -> e2, "endpoints" -> {v1, v2}, "momentum" -> kE, "nu" -> nu1, 
    "bbType" -> "h", "massType" -> "massive", "skType" -> "++", 
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
      "shrinkZeroPointShift" -> 2*nu1|>|>, 
   <|"id" -> e3, "endpoints" -> {v1, v2}, "momentum" -> 2*kE, "nu" -> nu2, 
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
      "shrinkZeroPointShift" -> 2*nu2|>|>}, "extLegs" -> {}, 
 "vertexEnergies" -> <|v1 -> Sqrt[sp[k + kE, k + kE]], 
   v2 -> Sqrt[sp[k - kE, k - kE]]|>, "activeVertexIds" -> {v1, v2}, 
 "fixedAVertexValues" -> <||>, "loopMomenta" -> {q}, 
 "externalMomenta" -> {k}, "externalLegMomenta" -> {kE}, 
 "rawExternalInvariantRules" -> {sp[k, k] -> ss11^2}, 
 "externalInvariantRules" -> {sp[k, k] -> ss11^2}, 
 "rawExternalLegInvariantRules" -> {sp[kE, kE] -> sE1^2, 
   sp[k + kE, k + kE] -> sE2^2}, "externalLegInvariantRules" -> 
  {sp[kE, kE] -> sE1^2, sp[k + kE, k + kE] -> sE2^2}, 
 "kinematicRules" -> Automatic, "kinematicCoordinateAudit" -> 
  <|"status" -> "complete", "source" -> "default", 
   "baseCoordinateData" -> {<|"baseIndex" -> 1, "kind" -> "loopExternalGram", 
      "inputExpression" -> sp[k, k], "internalVariable" -> kk[1, 1], 
      "defaultVariable" -> ss11, "defaultRHS" -> ss11^2|>, 
     <|"occurrenceIndex" -> 1, "momentum" -> kE, "squaredExpression" -> 
       sp[kE, kE], "magnitudeExpression" -> Sqrt[sp[kE, kE]], 
      "gramVector" -> {0, 0, 1}, "baseCoefficients" -> {0, 1, 0}, 
      "independentQ" -> True, "externalLegIndex" -> 1, "userVariable" -> sE1, 
      "defaultSquaredExpression" -> sE1^2, "baseIndex" -> 2, 
      "kind" -> "externalLegMagnitude", "inputExpression" -> sp[kE, kE], 
      "internalVariable" -> dSIBP`Private`externalLegSquaredCoordinate[1], 
      "defaultVariable" -> sE1, "defaultRHS" -> sE1^2|>, 
     <|"occurrenceIndex" -> 3, "momentum" -> k + kE, 
      "squaredExpression" -> sp[k + kE, k + kE], "magnitudeExpression" -> 
       Sqrt[sp[k + kE, k + kE]], "gramVector" -> {1, 2, 1}, 
      "baseCoefficients" -> {0, 0, 1}, "independentQ" -> True, 
      "externalLegIndex" -> 2, "userVariable" -> sE2, 
      "defaultSquaredExpression" -> sE2^2, "baseIndex" -> 3, 
      "kind" -> "externalLegMagnitude", "inputExpression" -> 
       sp[k + kE, k + kE], "internalVariable" -> 
       dSIBP`Private`externalLegSquaredCoordinate[2], 
      "defaultVariable" -> sE2, "defaultRHS" -> sE2^2|>}, 
   "baseCoordinateOrder" -> {sp[k, k], sp[kE, kE], sp[k + kE, k + kE]}, 
   "baseCoordinateCount" -> 3, "defaultRules" -> {sp[k, k] -> ss11^2, 
     sp[kE, kE] -> sE1^2, sp[k + kE, k + kE] -> sE2^2}, 
   "selectionTemplate" -> "kinematicRules" -> {sp[k, k] -> ss11^2, 
      sp[kE, kE] -> sE1^2, sp[k + kE, k + kE] -> sE2^2}, 
   "selectedRules" -> {sp[k, k] -> ss11^2, sp[kE, kE] -> sE1^2, 
     sp[k + kE, k + kE] -> sE2^2}, "selectedUserVariables" -> 
    {ss11, sE1, sE2}, "userParameterOrder" -> {ss11, sE1, sE2}, 
   "coordinateMatrix" -> {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}}, 
   "coordinateRank" -> 3, "parameterJacobian" -> 
    {{2*ss11, 0, 0}, {0, 2*sE1, 0}, {0, 0, 2*sE2}}, "parameterRank" -> 3, 
   "missingDirections" -> {}, "ruleMissingDirections" -> {}, 
   "parameterMissingDirections" -> {}, "ruleMissingDirectionExpressions" -> 
    {}, "parameterMissingDirectionExpressions" -> {}, 
   "ruleDependencies" -> {}, "ruleDependencyResiduals" -> {}, 
   "parameterDependencies" -> {}, "constraintResiduals" -> {}, 
   "unsupportedRulePositions" -> {}, "completeQ" -> True, 
   "overcompleteQ" -> False, "inverseAvailableQ" -> True, 
   "resolvedRules" -> {sp[k, k] -> ss11^2, sp[kE, kE] -> sE1^2, 
     sp[k + kE, k + kE] -> sE2^2}, "baseSquaredUserExpressions" -> 
    {ss11^2, sE1^2, sE2^2}, "baseRootUserExpressions" -> {ss11, sE1, sE2}, 
   "appearingNoLoopMagnitudeMomenta" -> {kE, 2*kE, k + kE, k - kE}, 
   "independentNoLoopMagnitudeMomenta" -> {kE, k + kE}, 
   "dependentMagnitudeBindings" -> {<|"momentum" -> 2*kE, 
      "squaredExpression" -> sp[2*kE, 2*kE], "userSquaredExpression" -> 
       4*sE1^2, "userMagnitudeExpression" -> 2*Sqrt[sE1^2]|>, 
     <|"momentum" -> k - kE, "squaredExpression" -> sp[k - kE, k - kE], 
      "userSquaredExpression" -> 2*sE1^2 - sE2^2 + 2*ss11^2, 
      "userMagnitudeExpression" -> Sqrt[2*sE1^2 - sE2^2 + 2*ss11^2]|>}, 
   "rawLoopRules" -> {sp[k, k] -> ss11^2}, "resolvedLoopRules" -> 
    {sp[k, k] -> ss11^2}, "rawExternalLegRules" -> 
    {sp[kE, kE] -> sE1^2, sp[k + kE, k + kE] -> sE2^2}, 
   "resolvedExternalLegRules" -> {sp[kE, kE] -> sE1^2, 
     sp[k + kE, k + kE] -> sE2^2}, "message" -> "\:52a8\:529b\:5b66\:53d8\
\:91cf\:5b8c\:5907\:ff0c\:4e14\:5f53\:524d\:7b80\:5355\:5750\:6807\:89c4\
\:5219\:53ef\:53cd\:5411\:8f6c\:6362\:3002"|>, 
 "ispData" -> {<|"name" -> rho1, "expr" -> sp[k, q], "range" -> {0}|>}, 
 "nV" -> 2, "nE" -> 3, "nL" -> 1, "nK" -> 1, 
 "bMatrix" -> {{1, 1, 1}, {-1, -1, -1}}, 
 "vertexLines" -> {{{1, 1}, {2, 1}, {3, 1}}, {{1, -1}, {2, -1}, {3, -1}}}, 
 "loopCoeffMatrix" -> {{1}, {0}, {0}}, "externalCoeffMatrix" -> 
  {{0}, {0}, {0}}, "externalPartList" -> {0, kE, 2*kE}, 
 "rawNumericRules" -> {dim -> 3, nu0 -> 1/3, nu1 -> 2/3, nu2 -> 4/3, 
   ss11 -> 5, sE1 -> 7, sE2 -> 11}, "numericRules" -> 
  {dim -> 3, nu0 -> 1/3, nu1 -> 2/3, nu2 -> 4/3, kk[1, 1] -> 25, sE1 -> 7, 
   sE2 -> 11}, "sampleDiscreteRules" -> {}, "seedPreset" -> "fullDiscrete", 
 "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0}, 
   "sampleOnly" -> True|>, "generatorSeedRanges" -> {}, 
 "seedOptions" -> <|"DiscreteMode" -> "all", "MaxSeedRuleCount" -> 200, 
   "MaxDiscreteRuleCount" -> 64, "MaxEquationCount" -> 200, 
   "MaxShrinkSectorDepth" -> Automatic, "MaxShrinkSectorCount" -> 16|>, 
 "unknownSeedPreset" -> None, "zeroPointRules" -> {}, 
 "shrinkPrefactorRules" -> {}, "symmetryRules" -> {}, 
 "thetaBoundarySignOffset" -> Automatic, "kiraOrdering" -> <||>, 
 "sectorVertexRepresentativeMap" -> <|v1 -> v1, v2 -> v2|>, 
 "sectorMetadata" -> <|"caseName" -> "rootKinematicCoordinatesExample", 
   "sectorShrunkLines" -> {}, "sectorKey" -> "top", 
   "aSlotMode" -> "compactActiveSlots", "sectorVertexRepresentativeMap" -> 
    <|v1 -> v1, v2 -> v2|>, "vertexIdToOriginalASlot" -> 
    <|v1 -> 1, v2 -> 2|>, "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 2|>, 
   "vertexSlots" -> {<|"slot" -> 1, "vertexId" -> v1, 
      "representativeVertexId" -> v1, "aSymbol" -> a[v1], "activeQ" -> True, 
      "fixedValue" -> None, "compactASlot" -> 1|>, 
     <|"slot" -> 2, "vertexId" -> v2, "representativeVertexId" -> v2, 
      "aSymbol" -> a[v2], "activeQ" -> True, "fixedValue" -> None, 
      "compactASlot" -> 2|>}, "compactASlots" -> 
    {<|"compactSlot" -> 1, "representativeVertexId" -> v1, 
      "originalVertexIds" -> {v1}, "originalSlots" -> {1}, 
      "aSymbol" -> a[v1]|>, <|"compactSlot" -> 2, "representativeVertexId" -> 
       v2, "originalVertexIds" -> {v2}, "originalSlots" -> {2}, 
      "aSymbol" -> a[v2]|>}, "activeASlots" -> {1, 2}, 
   "lineSlots" -> {<|"slot" -> 1, "lineId" -> e1, 
      "packType" -> "massiveFull", "massType" -> "massive", 
      "state" -> "full", "endpoints" -> {v1, v2}, "originalEndpoints" -> 
       {v1, v2}, "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], 
      "masslessN1OppositeEndpoint" -> Missing["NotApplicable"], 
      "endpointOriginalASlots" -> {1, 2}, "endpointCompactASlots" -> {1, 2}, 
      "bSymbol" -> b[e1], "packTemplate" -> {b[e1], n[e1, 1], n[e1, 2]}|>, 
     <|"slot" -> 2, "lineId" -> e2, "packType" -> "massiveFull", 
      "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v2}, 
      "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" -> 
       Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
       Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, 
      "endpointCompactASlots" -> {1, 2}, "bSymbol" -> b[e2], 
      "packTemplate" -> {b[e2], n[e2, 1], n[e2, 2]}|>, 
     <|"slot" -> 3, "lineId" -> e3, "packType" -> "massiveFull", 
      "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v2}, 
      "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" -> 
       Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
       Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, 
      "endpointCompactASlots" -> {1, 2}, "bSymbol" -> b[e3], 
      "packTemplate" -> {b[e3], n[e3, 1], n[e3, 2]}|>}, 
   "lineIdToSlot" -> <|e1 -> 1, e2 -> 2, e3 -> 3|>, 
   "bSymbolToLineSlot" -> <|b[e1] -> 1, b[e2] -> 2, b[e3] -> 3|>, 
   "ispSlots" -> {<|"slot" -> 1, "indexSymbol" -> ispN[1], 
      "data" -> <|"name" -> rho1, "expr" -> sp[k, q], "range" -> {0}|>|>}|>, 
 "sectorMetadataList" -> {<|"caseName" -> "rootKinematicCoordinatesExample", 
    "sectorShrunkLines" -> {}, "sectorKey" -> "top", 
    "aSlotMode" -> "compactActiveSlots", "sectorVertexRepresentativeMap" -> 
     <|v1 -> v1, v2 -> v2|>, "vertexIdToOriginalASlot" -> 
     <|v1 -> 1, v2 -> 2|>, "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 2|>, 
    "vertexSlots" -> {<|"slot" -> 1, "vertexId" -> v1, 
       "representativeVertexId" -> v1, "aSymbol" -> a[v1], "activeQ" -> True, 
       "fixedValue" -> None, "compactASlot" -> 1|>, 
      <|"slot" -> 2, "vertexId" -> v2, "representativeVertexId" -> v2, 
       "aSymbol" -> a[v2], "activeQ" -> True, "fixedValue" -> None, 
       "compactASlot" -> 2|>}, "compactASlots" -> 
     {<|"compactSlot" -> 1, "representativeVertexId" -> v1, 
       "originalVertexIds" -> {v1}, "originalSlots" -> {1}, 
       "aSymbol" -> a[v1]|>, <|"compactSlot" -> 2, 
       "representativeVertexId" -> v2, "originalVertexIds" -> {v2}, 
       "originalSlots" -> {2}, "aSymbol" -> a[v2]|>}, 
    "activeASlots" -> {1, 2}, "lineSlots" -> 
     {<|"slot" -> 1, "lineId" -> e1, "packType" -> "massiveFull", 
       "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v2}, 
       "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" -> 
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, 
       "endpointCompactASlots" -> {1, 2}, "bSymbol" -> b[e1], 
       "packTemplate" -> {b[e1], n[e1, 1], n[e1, 2]}|>, 
      <|"slot" -> 2, "lineId" -> e2, "packType" -> "massiveFull", 
       "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v2}, 
       "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" -> 
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, 
       "endpointCompactASlots" -> {1, 2}, "bSymbol" -> b[e2], 
       "packTemplate" -> {b[e2], n[e2, 1], n[e2, 2]}|>, 
      <|"slot" -> 3, "lineId" -> e3, "packType" -> "massiveFull", 
       "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v2}, 
       "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" -> 
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, 
       "endpointCompactASlots" -> {1, 2}, "bSymbol" -> b[e3], 
       "packTemplate" -> {b[e3], n[e3, 1], n[e3, 2]}|>}, 
    "lineIdToSlot" -> <|e1 -> 1, e2 -> 2, e3 -> 3|>, 
    "bSymbolToLineSlot" -> <|b[e1] -> 1, b[e2] -> 2, b[e3] -> 3|>, 
    "ispSlots" -> {<|"slot" -> 1, "indexSymbol" -> ispN[1], 
       "data" -> <|"name" -> rho1, "expr" -> sp[k, q], "range" -> {0}|>|>}|>, 
   <|"caseName" -> "rootKinematicCoordinatesExample_sector_e1", 
    "sectorShrunkLines" -> {1}, "sectorKey" -> "e1", 
    "aSlotMode" -> "compactActiveSlots", "sectorVertexRepresentativeMap" -> 
     <|v1 -> v1, v2 -> v1|>, "vertexIdToOriginalASlot" -> 
     <|v1 -> 1, v2 -> 2|>, "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 1|>, 
    "vertexSlots" -> {<|"slot" -> 1, "vertexId" -> v1, 
       "representativeVertexId" -> v1, "aSymbol" -> a[v1], "activeQ" -> True, 
       "fixedValue" -> None, "compactASlot" -> 1|>, 
      <|"slot" -> 2, "vertexId" -> v2, "representativeVertexId" -> v1, 
       "aSymbol" -> a[v2], "activeQ" -> False, "fixedValue" -> 0, 
       "compactASlot" -> 1|>}, "compactASlots" -> 
     {<|"compactSlot" -> 1, "representativeVertexId" -> v1, 
       "originalVertexIds" -> {v1, v2}, "originalSlots" -> {1, 2}, 
       "aSymbol" -> a[v1]|>}, "activeASlots" -> {1}, 
    "lineSlots" -> {<|"slot" -> 1, "lineId" -> e1, "packType" -> "shrunk", 
       "massType" -> "massive", "state" -> "shrunk", "endpoints" -> {v1, v1}, 
       "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" -> 
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, 
       "endpointCompactASlots" -> {1, 1}, "bSymbol" -> bS[e1], 
       "packTemplate" -> {bS[e1]}|>, <|"slot" -> 2, "lineId" -> e2, 
       "packType" -> "massiveFull", "massType" -> "massive", 
       "state" -> "full", "endpoints" -> {v1, v1}, "originalEndpoints" -> 
        {v1, v2}, "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], 
       "masslessN1OppositeEndpoint" -> Missing["NotApplicable"], 
       "endpointOriginalASlots" -> {1, 2}, "endpointCompactASlots" -> {1, 1}, 
       "bSymbol" -> b[e2], "packTemplate" -> {b[e2], n[e2, 1], n[e2, 2]}|>, 
      <|"slot" -> 3, "lineId" -> e3, "packType" -> "massiveFull", 
       "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v1}, 
       "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" -> 
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, 
       "endpointCompactASlots" -> {1, 1}, "bSymbol" -> b[e3], 
       "packTemplate" -> {b[e3], n[e3, 1], n[e3, 2]}|>}, 
    "lineIdToSlot" -> <|e1 -> 1, e2 -> 2, e3 -> 3|>, 
    "bSymbolToLineSlot" -> <|bS[e1] -> 1, b[e2] -> 2, b[e3] -> 3|>, 
    "ispSlots" -> {<|"slot" -> 1, "indexSymbol" -> ispN[1], 
       "data" -> <|"name" -> rho1, "expr" -> sp[k, q], "range" -> {0}|>|>}|>, 
   <|"caseName" -> "rootKinematicCoordinatesExample_sector_e2", 
    "sectorShrunkLines" -> {2}, "sectorKey" -> "e2", 
    "aSlotMode" -> "compactActiveSlots", "sectorVertexRepresentativeMap" -> 
     <|v1 -> v1, v2 -> v1|>, "vertexIdToOriginalASlot" -> 
     <|v1 -> 1, v2 -> 2|>, "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 1|>, 
    "vertexSlots" -> {<|"slot" -> 1, "vertexId" -> v1, 
       "representativeVertexId" -> v1, "aSymbol" -> a[v1], "activeQ" -> True, 
       "fixedValue" -> None, "compactASlot" -> 1|>, 
      <|"slot" -> 2, "vertexId" -> v2, "representativeVertexId" -> v1, 
       "aSymbol" -> a[v2], "activeQ" -> False, "fixedValue" -> 0, 
       "compactASlot" -> 1|>}, "compactASlots" -> 
     {<|"compactSlot" -> 1, "representativeVertexId" -> v1, 
       "originalVertexIds" -> {v1, v2}, "originalSlots" -> {1, 2}, 
       "aSymbol" -> a[v1]|>}, "activeASlots" -> {1}, 
    "lineSlots" -> {<|"slot" -> 1, "lineId" -> e1, 
       "packType" -> "massiveFull", "massType" -> "massive", 
       "state" -> "full", "endpoints" -> {v1, v1}, "originalEndpoints" -> 
        {v1, v2}, "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], 
       "masslessN1OppositeEndpoint" -> Missing["NotApplicable"], 
       "endpointOriginalASlots" -> {1, 2}, "endpointCompactASlots" -> {1, 1}, 
       "bSymbol" -> b[e1], "packTemplate" -> {b[e1], n[e1, 1], n[e1, 2]}|>, 
      <|"slot" -> 2, "lineId" -> e2, "packType" -> "shrunk", 
       "massType" -> "massive", "state" -> "shrunk", "endpoints" -> {v1, v1}, 
       "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" -> 
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, 
       "endpointCompactASlots" -> {1, 1}, "bSymbol" -> bS[e2], 
       "packTemplate" -> {bS[e2]}|>, <|"slot" -> 3, "lineId" -> e3, 
       "packType" -> "massiveFull", "massType" -> "massive", 
       "state" -> "full", "endpoints" -> {v1, v1}, "originalEndpoints" -> 
        {v1, v2}, "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], 
       "masslessN1OppositeEndpoint" -> Missing["NotApplicable"], 
       "endpointOriginalASlots" -> {1, 2}, "endpointCompactASlots" -> {1, 1}, 
       "bSymbol" -> b[e3], "packTemplate" -> {b[e3], n[e3, 1], n[e3, 2]}|>}, 
    "lineIdToSlot" -> <|e1 -> 1, e2 -> 2, e3 -> 3|>, 
    "bSymbolToLineSlot" -> <|b[e1] -> 1, bS[e2] -> 2, b[e3] -> 3|>, 
    "ispSlots" -> {<|"slot" -> 1, "indexSymbol" -> ispN[1], 
       "data" -> <|"name" -> rho1, "expr" -> sp[k, q], "range" -> {0}|>|>}|>, 
   <|"caseName" -> "rootKinematicCoordinatesExample_sector_e3", 
    "sectorShrunkLines" -> {3}, "sectorKey" -> "e3", 
    "aSlotMode" -> "compactActiveSlots", "sectorVertexRepresentativeMap" -> 
     <|v1 -> v1, v2 -> v1|>, "vertexIdToOriginalASlot" -> 
     <|v1 -> 1, v2 -> 2|>, "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 1|>, 
    "vertexSlots" -> {<|"slot" -> 1, "vertexId" -> v1, 
       "representativeVertexId" -> v1, "aSymbol" -> a[v1], "activeQ" -> True, 
       "fixedValue" -> None, "compactASlot" -> 1|>, 
      <|"slot" -> 2, "vertexId" -> v2, "representativeVertexId" -> v1, 
       "aSymbol" -> a[v2], "activeQ" -> False, "fixedValue" -> 0, 
       "compactASlot" -> 1|>}, "compactASlots" -> 
     {<|"compactSlot" -> 1, "representativeVertexId" -> v1, 
       "originalVertexIds" -> {v1, v2}, "originalSlots" -> {1, 2}, 
       "aSymbol" -> a[v1]|>}, "activeASlots" -> {1}, 
    "lineSlots" -> {<|"slot" -> 1, "lineId" -> e1, 
       "packType" -> "massiveFull", "massType" -> "massive", 
       "state" -> "full", "endpoints" -> {v1, v1}, "originalEndpoints" -> 
        {v1, v2}, "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], 
       "masslessN1OppositeEndpoint" -> Missing["NotApplicable"], 
       "endpointOriginalASlots" -> {1, 2}, "endpointCompactASlots" -> {1, 1}, 
       "bSymbol" -> b[e1], "packTemplate" -> {b[e1], n[e1, 1], n[e1, 2]}|>, 
      <|"slot" -> 2, "lineId" -> e2, "packType" -> "massiveFull", 
       "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v1}, 
       "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" -> 
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, 
       "endpointCompactASlots" -> {1, 1}, "bSymbol" -> b[e2], 
       "packTemplate" -> {b[e2], n[e2, 1], n[e2, 2]}|>, 
      <|"slot" -> 3, "lineId" -> e3, "packType" -> "shrunk", 
       "massType" -> "massive", "state" -> "shrunk", "endpoints" -> {v1, v1}, 
       "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" -> 
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, 
       "endpointCompactASlots" -> {1, 1}, "bSymbol" -> bS[e3], 
       "packTemplate" -> {bS[e3]}|>}, "lineIdToSlot" -> 
     <|e1 -> 1, e2 -> 2, e3 -> 3|>, "bSymbolToLineSlot" -> 
     <|b[e1] -> 1, b[e2] -> 2, bS[e3] -> 3|>, 
    "ispSlots" -> {<|"slot" -> 1, "indexSymbol" -> ispN[1], 
       "data" -> <|"name" -> rho1, "expr" -> sp[k, q], "range" -> {0}|>|>}|>, 
   <|"caseName" -> "rootKinematicCoordinatesExample_sector_e1_e2_e3", 
    "sectorShrunkLines" -> {1, 2, 3}, "sectorKey" -> "e1_e2_e3", 
    "aSlotMode" -> "compactActiveSlots", "sectorVertexRepresentativeMap" -> 
     <|v1 -> v1, v2 -> v1|>, "vertexIdToOriginalASlot" -> 
     <|v1 -> 1, v2 -> 2|>, "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 1|>, 
    "vertexSlots" -> {<|"slot" -> 1, "vertexId" -> v1, 
       "representativeVertexId" -> v1, "aSymbol" -> a[v1], "activeQ" -> True, 
       "fixedValue" -> None, "compactASlot" -> 1|>, 
      <|"slot" -> 2, "vertexId" -> v2, "representativeVertexId" -> v1, 
       "aSymbol" -> a[v2], "activeQ" -> False, "fixedValue" -> 0, 
       "compactASlot" -> 1|>}, "compactASlots" -> 
     {<|"compactSlot" -> 1, "representativeVertexId" -> v1, 
       "originalVertexIds" -> {v1, v2}, "originalSlots" -> {1, 2}, 
       "aSymbol" -> a[v1]|>}, "activeASlots" -> {1}, 
    "lineSlots" -> {<|"slot" -> 1, "lineId" -> e1, "packType" -> "shrunk", 
       "massType" -> "massive", "state" -> "shrunk", "endpoints" -> {v1, v1}, 
       "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" -> 
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, 
       "endpointCompactASlots" -> {1, 1}, "bSymbol" -> bS[e1], 
       "packTemplate" -> {bS[e1]}|>, <|"slot" -> 2, "lineId" -> e2, 
       "packType" -> "shrunk", "massType" -> "massive", "state" -> "shrunk", 
       "endpoints" -> {v1, v1}, "originalEndpoints" -> {v1, v2}, 
       "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], 
       "masslessN1OppositeEndpoint" -> Missing["NotApplicable"], 
       "endpointOriginalASlots" -> {1, 2}, "endpointCompactASlots" -> {1, 1}, 
       "bSymbol" -> bS[e2], "packTemplate" -> {bS[e2]}|>, 
      <|"slot" -> 3, "lineId" -> e3, "packType" -> "shrunk", 
       "massType" -> "massive", "state" -> "shrunk", "endpoints" -> {v1, v1}, 
       "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" -> 
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, 
       "endpointCompactASlots" -> {1, 1}, "bSymbol" -> bS[e3], 
       "packTemplate" -> {bS[e3]}|>}, "lineIdToSlot" -> 
     <|e1 -> 1, e2 -> 2, e3 -> 3|>, "bSymbolToLineSlot" -> 
     <|bS[e1] -> 1, bS[e2] -> 2, bS[e3] -> 3|>, 
    "ispSlots" -> {<|"slot" -> 1, "indexSymbol" -> ispN[1], 
       "data" -> <|"name" -> rho1, "expr" -> sp[k, q], 
         "range" -> {0}|>|>}|>}, "indexMaps" -> 
  <|"vertexIdToOriginalASlot" -> <|v1 -> 1, v2 -> 2|>, 
   "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 2|>, 
   "lineIdToSlot" -> <|e1 -> 1, e2 -> 2, e3 -> 3|>, 
   "bSymbolToLineSlot" -> <|b[e1] -> 1, b[e2] -> 2, b[e3] -> 3|>, 
   "compactASlots" -> {<|"compactSlot" -> 1, "representativeVertexId" -> v1, 
      "originalVertexIds" -> {v1}, "originalSlots" -> {1}, 
      "aSymbol" -> a[v1]|>, <|"compactSlot" -> 2, "representativeVertexId" -> 
       v2, "originalVertexIds" -> {v2}, "originalSlots" -> {2}, 
      "aSymbol" -> a[v2]|>}, "lineSlots" -> 
    {<|"slot" -> 1, "lineId" -> e1, "packType" -> "massiveFull", 
      "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v2}, 
      "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" -> 
       Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
       Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, 
      "endpointCompactASlots" -> {1, 2}, "bSymbol" -> b[e1], 
      "packTemplate" -> {b[e1], n[e1, 1], n[e1, 2]}|>, 
     <|"slot" -> 2, "lineId" -> e2, "packType" -> "massiveFull", 
      "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v2}, 
      "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" -> 
       Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
       Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, 
      "endpointCompactASlots" -> {1, 2}, "bSymbol" -> b[e2], 
      "packTemplate" -> {b[e2], n[e2, 1], n[e2, 2]}|>, 
     <|"slot" -> 3, "lineId" -> e3, "packType" -> "massiveFull", 
      "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v2}, 
      "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" -> 
       Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
       Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, 
      "endpointCompactASlots" -> {1, 2}, "bSymbol" -> b[e3], 
      "packTemplate" -> {b[e3], n[e3, 1], n[e3, 2]}|>}, 
   "ispSlots" -> {<|"slot" -> 1, "indexSymbol" -> ispN[1], 
      "data" -> <|"name" -> rho1, "expr" -> sp[k, q], "range" -> {0}|>|>}|>, 
 "seedSummary" -> <|"continuousVariables" -> {a[v1], a[v2], b[e1], b[e2], 
     b[e3], ispN[1]}, "discreteVariables" -> {n[e1, 1], n[e1, 2], n[e2, 1], 
     n[e2, 2], n[e3, 1], n[e3, 2]}, "discreteStateCount" -> 64, 
   "momentumGeneratorCount" -> 2, "timeGeneratorCount" -> 2, 
   "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0}, 
     "sampleOnly" -> True|>, "numericRules" -> {dim -> 3, nu0 -> 1/3, 
     nu1 -> 2/3, nu2 -> 4/3, kk[1, 1] -> 25, sE1 -> 7, sE2 -> 11}, 
   "numericRuleRequirementReport" -> <|"providedNumericVariables" -> 
      {dim, nu0, nu1, nu2, ss11, sE1, sE2}, 
     "internalProvidedNumericVariables" -> {dim, nu0, nu1, nu2, kk[1, 1], 
       sE1, sE2}, "requiredExternalInvariants" -> {ss11}, 
     "internalRequiredExternalInvariants" -> {kk[1, 1]}, 
     "externalInvariantNamingReport" -> <|"externalMomenta" -> {k}, 
       "externalInvariantRules" -> {sp[k, k] -> ss11^2}, 
       "internalExternalInvariantRules" -> {kk[1, 1] -> ss11^2}, 
       "coordinateData" -> {<|"internalVariable" -> kk[1, 1], 
          "publicExpression" -> ss11^2, "userVariable" -> ss11, 
          "coordinateType" -> "squareRoot", "internalCoordinateExpression" -> 
           Sqrt[kk[1, 1]], "internalJacobian" -> 2*Sqrt[kk[1, 1]], 
          "userJacobian" -> 2*ss11|>}, "defaultNamingConvention" -> "ssij = \
Sqrt[sp[k_i,k_j]], where i<=j follows externalMomenta order", 
       "message" -> "externalMomenta \
\:662f\:8fdb\:5165\:5185\:7ebf\:504f\:79fb\:7684\:72ec\:7acb\:5411\:91cf\
\:ff1b\:5185\:90e8\:4ecd\:7528 kk[i,j]=sp[k_i,k_j]\:ff0c015 \
\:516c\:5f00\:7f3a\:7701\:5750\:6807\:4e3a ssij\:3002"|>, 
     "externalLegInvariantNamingReport" -> <|"externalLegMomenta" -> {kE}, 
       "appearingMagnitudeMomenta" -> {kE, 2*kE, k + kE, k - kE}, 
       "independentMagnitudeMomenta" -> {kE, k + kE}, 
       "dependentMagnitudeBindings" -> {<|"momentum" -> 2*kE, 
          "squaredExpression" -> sp[2*kE, 2*kE], "userSquaredExpression" -> 
           4*sE1^2, "userMagnitudeExpression" -> 2*Sqrt[sE1^2]|>, 
         <|"momentum" -> k - kE, "squaredExpression" -> sp[k - kE, k - kE], 
          "userSquaredExpression" -> 2*sE1^2 - sE2^2 + 2*ss11^2, 
          "userMagnitudeExpression" -> Sqrt[2*sE1^2 - sE2^2 + 2*ss11^2]|>}, 
       "externalLegInvariantRules" -> {sp[kE, kE] -> sE1^2, 
         sp[k + kE, k + kE] -> sE2^2}, "coordinateData" -> 
        {<|"occurrenceIndex" -> 1, "momentum" -> kE, "squaredExpression" -> 
           sp[kE, kE], "magnitudeExpression" -> Sqrt[sp[kE, kE]], 
          "gramVector" -> {0, 0, 1}, "baseCoefficients" -> {0, 1, 0}, 
          "independentQ" -> True, "externalLegIndex" -> 1, 
          "userVariable" -> sE1, "defaultSquaredExpression" -> sE1^2, 
          "scalarProduct" -> sp[kE, kE], "publicExpression" -> sE1^2, 
          "coordinateType" -> "externalLegSquareRoot", "userJacobian" -> 1|>, 
         <|"occurrenceIndex" -> 3, "momentum" -> k + kE, 
          "squaredExpression" -> sp[k + kE, k + kE], "magnitudeExpression" -> 
           Sqrt[sp[k + kE, k + kE]], "gramVector" -> {1, 2, 1}, 
          "baseCoefficients" -> {0, 0, 1}, "independentQ" -> True, 
          "externalLegIndex" -> 2, "userVariable" -> sE2, 
          "defaultSquaredExpression" -> sE2^2, "scalarProduct" -> 
           sp[k + kE, k + kE], "publicExpression" -> sE2^2, 
          "coordinateType" -> "externalLegSquareRoot", "userJacobian" -> 
           1|>}, "defaultNamingConvention" -> "sE1,sE2,... follow the \
first-occurrence independent basis of no-loop momentum magnitudes in \
lineData, vertexEnergies and extLegs", "automaticCrossProducts" -> False, 
       "entersLoopIBPGenerators" -> False, "entersISPClosure" -> False|>, 
     "vertexEnergyNamingReport" -> <|"convention" -> "loop external roots use \
ssij; the independent basis of actually appearing no-loop momentum magnitudes \
uses sEe variables and dependent magnitudes keep explicit bindings; unrelated \
scalar phase parameters remain explicit user symbols", 
       "rawVertexEnergies" -> <|v1 -> Sqrt[sp[k + kE, k + kE]], 
         v2 -> Sqrt[sp[k - kE, k - kE]]|>, "internalVertexEnergies" -> 
        <|v1 -> sE2, v2 -> Sqrt[2*sE1^2 - sE2^2 + 2*kk[1, 1]]|>, 
       "userVertexEnergies" -> <|v1 -> sE2, 
         v2 -> Sqrt[2*sE1^2 - sE2^2 + 2*ss11^2]|>, "dependencyData" -> 
        <|v1 -> <|"internalExternalInvariantVariables" -> {}, 
           "externalInvariantVariables" -> {}, 
           "internalIndependentVertexEnergyParameters" -> {sE2}, 
           "independentVertexEnergyParameters" -> {sE2}, 
           "usesExternalInvariantQ" -> False, 
           "usesIndependentVertexEnergyQ" -> True, "kind" -> 
            "independentVertexEnergyParameter"|>, 
         v2 -> <|"internalExternalInvariantVariables" -> {kk[1, 1]}, 
           "externalInvariantVariables" -> {ss11^2}, 
           "internalIndependentVertexEnergyParameters" -> {sE1, sE2}, 
           "independentVertexEnergyParameters" -> {sE1, sE2}, 
           "usesExternalInvariantQ" -> True, 
           "usesIndependentVertexEnergyQ" -> True, "kind" -> 
            "mixedExpression"|>|>, "externalLegInvariantNamingReport" -> 
        <|"externalLegMomenta" -> {kE}, "appearingMagnitudeMomenta" -> 
          {kE, 2*kE, k + kE, k - kE}, "independentMagnitudeMomenta" -> 
          {kE, k + kE}, "dependentMagnitudeBindings" -> 
          {<|"momentum" -> 2*kE, "squaredExpression" -> sp[2*kE, 2*kE], 
            "userSquaredExpression" -> 4*sE1^2, "userMagnitudeExpression" -> 
             2*Sqrt[sE1^2]|>, <|"momentum" -> k - kE, "squaredExpression" -> 
             sp[k - kE, k - kE], "userSquaredExpression" -> 2*sE1^2 - sE2^2 + 
              2*ss11^2, "userMagnitudeExpression" -> Sqrt[2*sE1^2 - sE2^2 + 2*
                ss11^2]|>}, "externalLegInvariantRules" -> 
          {sp[kE, kE] -> sE1^2, sp[k + kE, k + kE] -> sE2^2}, 
         "coordinateData" -> {<|"occurrenceIndex" -> 1, "momentum" -> kE, 
            "squaredExpression" -> sp[kE, kE], "magnitudeExpression" -> 
             Sqrt[sp[kE, kE]], "gramVector" -> {0, 0, 1}, 
            "baseCoefficients" -> {0, 1, 0}, "independentQ" -> True, 
            "externalLegIndex" -> 1, "userVariable" -> sE1, 
            "defaultSquaredExpression" -> sE1^2, "scalarProduct" -> 
             sp[kE, kE], "publicExpression" -> sE1^2, "coordinateType" -> 
             "externalLegSquareRoot", "userJacobian" -> 1|>, 
           <|"occurrenceIndex" -> 3, "momentum" -> k + kE, 
            "squaredExpression" -> sp[k + kE, k + kE], 
            "magnitudeExpression" -> Sqrt[sp[k + kE, k + kE]], 
            "gramVector" -> {1, 2, 1}, "baseCoefficients" -> {0, 0, 1}, 
            "independentQ" -> True, "externalLegIndex" -> 2, 
            "userVariable" -> sE2, "defaultSquaredExpression" -> sE2^2, 
            "scalarProduct" -> sp[k + kE, k + kE], "publicExpression" -> 
             sE2^2, "coordinateType" -> "externalLegSquareRoot", 
            "userJacobian" -> 1|>}, "defaultNamingConvention" -> "sE1,sE2,... \
follow the first-occurrence independent basis of no-loop momentum magnitudes \
in lineData, vertexEnergies and extLegs", "automaticCrossProducts" -> False, 
         "entersLoopIBPGenerators" -> False, "entersISPClosure" -> False|>, 
       "message" -> "vertexEnergies \:53ef\:4f7f\:7528 loop-external Gram \
\:6839\:53f7\:6216\:5b9e\:9645\:51fa\:73b0\:7684\:65e0\:5708\:52a8\:91cf\
\:6a21\:957f\:ff1b015 \
\:4e0d\:81ea\:52a8\:751f\:6210\:5916\:817f\:5411\:91cf\:4e4b\:95f4\:7684\
\:4ea4\:53c9\:70b9\:79ef\:3002\:65e0\:5708\:52a8\:91cf\:53d8\:91cf\:4e0d\
\:8fdb\:5165 loop IBP/ISP\:3002"|>, "requiredVertexEnergies" -> 
      {sE1, sE2, ss11}, "internalRequiredVertexEnergies" -> 
      {sE1, sE2, kk[1, 1]}, "requiredLineParameters" -> {nu0, nu1, nu2}, 
     "requiredNumericVariables" -> {ss11, sE1, sE2, nu0, nu1, nu2}, 
     "internalRequiredNumericVariables" -> {kk[1, 1], sE1, sE2, nu0, nu1, 
       nu2}, "missingExternalInvariants" -> {}, 
     "internalMissingExternalInvariants" -> {}, "missingVertexEnergies" -> 
      {}, "internalMissingVertexEnergies" -> {}, "missingLineParameters" -> 
      {}, "missingNumericVariables" -> {}, 
     "internalMissingNumericVariables" -> {}, 
     "completeStaticNumericRulesQ" -> True|>, 
   "externalInvariantNamingReport" -> <|"externalMomenta" -> {k}, 
     "externalInvariantRules" -> {sp[k, k] -> ss11^2}, 
     "internalExternalInvariantRules" -> {kk[1, 1] -> ss11^2}, 
     "coordinateData" -> {<|"internalVariable" -> kk[1, 1], 
        "publicExpression" -> ss11^2, "userVariable" -> ss11, 
        "coordinateType" -> "squareRoot", "internalCoordinateExpression" -> 
         Sqrt[kk[1, 1]], "internalJacobian" -> 2*Sqrt[kk[1, 1]], 
        "userJacobian" -> 2*ss11|>}, "defaultNamingConvention" -> 
      "ssij = Sqrt[sp[k_i,k_j]], where i<=j follows externalMomenta order", 
     "message" -> "externalMomenta \
\:662f\:8fdb\:5165\:5185\:7ebf\:504f\:79fb\:7684\:72ec\:7acb\:5411\:91cf\
\:ff1b\:5185\:90e8\:4ecd\:7528 kk[i,j]=sp[k_i,k_j]\:ff0c015 \
\:516c\:5f00\:7f3a\:7701\:5750\:6807\:4e3a ssij\:3002"|>, 
   "vertexEnergyNamingReport" -> <|"convention" -> "loop external roots use \
ssij; the independent basis of actually appearing no-loop momentum magnitudes \
uses sEe variables and dependent magnitudes keep explicit bindings; unrelated \
scalar phase parameters remain explicit user symbols", 
     "rawVertexEnergies" -> <|v1 -> Sqrt[sp[k + kE, k + kE]], 
       v2 -> Sqrt[sp[k - kE, k - kE]]|>, "internalVertexEnergies" -> 
      <|v1 -> sE2, v2 -> Sqrt[2*sE1^2 - sE2^2 + 2*kk[1, 1]]|>, 
     "userVertexEnergies" -> <|v1 -> sE2, 
       v2 -> Sqrt[2*sE1^2 - sE2^2 + 2*ss11^2]|>, "dependencyData" -> 
      <|v1 -> <|"internalExternalInvariantVariables" -> {}, 
         "externalInvariantVariables" -> {}, 
         "internalIndependentVertexEnergyParameters" -> {sE2}, 
         "independentVertexEnergyParameters" -> {sE2}, 
         "usesExternalInvariantQ" -> False, "usesIndependentVertexEnergyQ" -> 
          True, "kind" -> "independentVertexEnergyParameter"|>, 
       v2 -> <|"internalExternalInvariantVariables" -> {kk[1, 1]}, 
         "externalInvariantVariables" -> {ss11^2}, 
         "internalIndependentVertexEnergyParameters" -> {sE1, sE2}, 
         "independentVertexEnergyParameters" -> {sE1, sE2}, 
         "usesExternalInvariantQ" -> True, "usesIndependentVertexEnergyQ" -> 
          True, "kind" -> "mixedExpression"|>|>, 
     "externalLegInvariantNamingReport" -> <|"externalLegMomenta" -> {kE}, 
       "appearingMagnitudeMomenta" -> {kE, 2*kE, k + kE, k - kE}, 
       "independentMagnitudeMomenta" -> {kE, k + kE}, 
       "dependentMagnitudeBindings" -> {<|"momentum" -> 2*kE, 
          "squaredExpression" -> sp[2*kE, 2*kE], "userSquaredExpression" -> 
           4*sE1^2, "userMagnitudeExpression" -> 2*Sqrt[sE1^2]|>, 
         <|"momentum" -> k - kE, "squaredExpression" -> sp[k - kE, k - kE], 
          "userSquaredExpression" -> 2*sE1^2 - sE2^2 + 2*ss11^2, 
          "userMagnitudeExpression" -> Sqrt[2*sE1^2 - sE2^2 + 2*ss11^2]|>}, 
       "externalLegInvariantRules" -> {sp[kE, kE] -> sE1^2, 
         sp[k + kE, k + kE] -> sE2^2}, "coordinateData" -> 
        {<|"occurrenceIndex" -> 1, "momentum" -> kE, "squaredExpression" -> 
           sp[kE, kE], "magnitudeExpression" -> Sqrt[sp[kE, kE]], 
          "gramVector" -> {0, 0, 1}, "baseCoefficients" -> {0, 1, 0}, 
          "independentQ" -> True, "externalLegIndex" -> 1, 
          "userVariable" -> sE1, "defaultSquaredExpression" -> sE1^2, 
          "scalarProduct" -> sp[kE, kE], "publicExpression" -> sE1^2, 
          "coordinateType" -> "externalLegSquareRoot", "userJacobian" -> 1|>, 
         <|"occurrenceIndex" -> 3, "momentum" -> k + kE, 
          "squaredExpression" -> sp[k + kE, k + kE], "magnitudeExpression" -> 
           Sqrt[sp[k + kE, k + kE]], "gramVector" -> {1, 2, 1}, 
          "baseCoefficients" -> {0, 0, 1}, "independentQ" -> True, 
          "externalLegIndex" -> 2, "userVariable" -> sE2, 
          "defaultSquaredExpression" -> sE2^2, "scalarProduct" -> 
           sp[k + kE, k + kE], "publicExpression" -> sE2^2, 
          "coordinateType" -> "externalLegSquareRoot", "userJacobian" -> 
           1|>}, "defaultNamingConvention" -> "sE1,sE2,... follow the \
first-occurrence independent basis of no-loop momentum magnitudes in \
lineData, vertexEnergies and extLegs", "automaticCrossProducts" -> False, 
       "entersLoopIBPGenerators" -> False, "entersISPClosure" -> False|>, 
     "message" -> "vertexEnergies \:53ef\:4f7f\:7528 loop-external Gram \
\:6839\:53f7\:6216\:5b9e\:9645\:51fa\:73b0\:7684\:65e0\:5708\:52a8\:91cf\
\:6a21\:957f\:ff1b015 \
\:4e0d\:81ea\:52a8\:751f\:6210\:5916\:817f\:5411\:91cf\:4e4b\:95f4\:7684\
\:4ea4\:53c9\:70b9\:79ef\:3002\:65e0\:5708\:52a8\:91cf\:53d8\:91cf\:4e0d\
\:8fdb\:5165 loop IBP/ISP\:3002"|>, "sampleDiscreteRules" -> {}|>, 
 "validationReport" -> <|"status" -> "ok", "errorCount" -> 0, 
   "warningCount" -> 1, "pendingCount" -> 0, 
   "numericRuleRequirementReport" -> <|"providedNumericVariables" -> 
      {dim, nu0, nu1, nu2, ss11, sE1, sE2}, 
     "internalProvidedNumericVariables" -> {dim, nu0, nu1, nu2, kk[1, 1], 
       sE1, sE2}, "requiredExternalInvariants" -> {ss11}, 
     "internalRequiredExternalInvariants" -> {kk[1, 1]}, 
     "externalInvariantNamingReport" -> <|"externalMomenta" -> {k}, 
       "externalInvariantRules" -> {sp[k, k] -> ss11^2}, 
       "internalExternalInvariantRules" -> {kk[1, 1] -> ss11^2}, 
       "coordinateData" -> {<|"internalVariable" -> kk[1, 1], 
          "publicExpression" -> ss11^2, "userVariable" -> ss11, 
          "coordinateType" -> "squareRoot", "internalCoordinateExpression" -> 
           Sqrt[kk[1, 1]], "internalJacobian" -> 2*Sqrt[kk[1, 1]], 
          "userJacobian" -> 2*ss11|>}, "defaultNamingConvention" -> "ssij = \
Sqrt[sp[k_i,k_j]], where i<=j follows externalMomenta order", 
       "message" -> "externalMomenta \
\:662f\:8fdb\:5165\:5185\:7ebf\:504f\:79fb\:7684\:72ec\:7acb\:5411\:91cf\
\:ff1b\:5185\:90e8\:4ecd\:7528 kk[i,j]=sp[k_i,k_j]\:ff0c015 \
\:516c\:5f00\:7f3a\:7701\:5750\:6807\:4e3a ssij\:3002"|>, 
     "externalLegInvariantNamingReport" -> <|"externalLegMomenta" -> {kE}, 
       "appearingMagnitudeMomenta" -> {kE, 2*kE, k + kE, k - kE}, 
       "independentMagnitudeMomenta" -> {kE, k + kE}, 
       "dependentMagnitudeBindings" -> {<|"momentum" -> 2*kE, 
          "squaredExpression" -> sp[2*kE, 2*kE], "userSquaredExpression" -> 
           4*sE1^2, "userMagnitudeExpression" -> 2*Sqrt[sE1^2]|>, 
         <|"momentum" -> k - kE, "squaredExpression" -> sp[k - kE, k - kE], 
          "userSquaredExpression" -> 2*sE1^2 - sE2^2 + 2*ss11^2, 
          "userMagnitudeExpression" -> Sqrt[2*sE1^2 - sE2^2 + 2*ss11^2]|>}, 
       "externalLegInvariantRules" -> {sp[kE, kE] -> sE1^2, 
         sp[k + kE, k + kE] -> sE2^2}, "coordinateData" -> 
        {<|"occurrenceIndex" -> 1, "momentum" -> kE, "squaredExpression" -> 
           sp[kE, kE], "magnitudeExpression" -> Sqrt[sp[kE, kE]], 
          "gramVector" -> {0, 0, 1}, "baseCoefficients" -> {0, 1, 0}, 
          "independentQ" -> True, "externalLegIndex" -> 1, 
          "userVariable" -> sE1, "defaultSquaredExpression" -> sE1^2, 
          "scalarProduct" -> sp[kE, kE], "publicExpression" -> sE1^2, 
          "coordinateType" -> "externalLegSquareRoot", "userJacobian" -> 1|>, 
         <|"occurrenceIndex" -> 3, "momentum" -> k + kE, 
          "squaredExpression" -> sp[k + kE, k + kE], "magnitudeExpression" -> 
           Sqrt[sp[k + kE, k + kE]], "gramVector" -> {1, 2, 1}, 
          "baseCoefficients" -> {0, 0, 1}, "independentQ" -> True, 
          "externalLegIndex" -> 2, "userVariable" -> sE2, 
          "defaultSquaredExpression" -> sE2^2, "scalarProduct" -> 
           sp[k + kE, k + kE], "publicExpression" -> sE2^2, 
          "coordinateType" -> "externalLegSquareRoot", "userJacobian" -> 
           1|>}, "defaultNamingConvention" -> "sE1,sE2,... follow the \
first-occurrence independent basis of no-loop momentum magnitudes in \
lineData, vertexEnergies and extLegs", "automaticCrossProducts" -> False, 
       "entersLoopIBPGenerators" -> False, "entersISPClosure" -> False|>, 
     "vertexEnergyNamingReport" -> <|"convention" -> "loop external roots use \
ssij; the independent basis of actually appearing no-loop momentum magnitudes \
uses sEe variables and dependent magnitudes keep explicit bindings; unrelated \
scalar phase parameters remain explicit user symbols", 
       "rawVertexEnergies" -> <|v1 -> Sqrt[sp[k + kE, k + kE]], 
         v2 -> Sqrt[sp[k - kE, k - kE]]|>, "internalVertexEnergies" -> 
        <|v1 -> sE2, v2 -> Sqrt[2*sE1^2 - sE2^2 + 2*kk[1, 1]]|>, 
       "userVertexEnergies" -> <|v1 -> sE2, 
         v2 -> Sqrt[2*sE1^2 - sE2^2 + 2*ss11^2]|>, "dependencyData" -> 
        <|v1 -> <|"internalExternalInvariantVariables" -> {}, 
           "externalInvariantVariables" -> {}, 
           "internalIndependentVertexEnergyParameters" -> {sE2}, 
           "independentVertexEnergyParameters" -> {sE2}, 
           "usesExternalInvariantQ" -> False, 
           "usesIndependentVertexEnergyQ" -> True, "kind" -> 
            "independentVertexEnergyParameter"|>, 
         v2 -> <|"internalExternalInvariantVariables" -> {kk[1, 1]}, 
           "externalInvariantVariables" -> {ss11^2}, 
           "internalIndependentVertexEnergyParameters" -> {sE1, sE2}, 
           "independentVertexEnergyParameters" -> {sE1, sE2}, 
           "usesExternalInvariantQ" -> True, 
           "usesIndependentVertexEnergyQ" -> True, "kind" -> 
            "mixedExpression"|>|>, "externalLegInvariantNamingReport" -> 
        <|"externalLegMomenta" -> {kE}, "appearingMagnitudeMomenta" -> 
          {kE, 2*kE, k + kE, k - kE}, "independentMagnitudeMomenta" -> 
          {kE, k + kE}, "dependentMagnitudeBindings" -> 
          {<|"momentum" -> 2*kE, "squaredExpression" -> sp[2*kE, 2*kE], 
            "userSquaredExpression" -> 4*sE1^2, "userMagnitudeExpression" -> 
             2*Sqrt[sE1^2]|>, <|"momentum" -> k - kE, "squaredExpression" -> 
             sp[k - kE, k - kE], "userSquaredExpression" -> 2*sE1^2 - sE2^2 + 
              2*ss11^2, "userMagnitudeExpression" -> Sqrt[2*sE1^2 - sE2^2 + 2*
                ss11^2]|>}, "externalLegInvariantRules" -> 
          {sp[kE, kE] -> sE1^2, sp[k + kE, k + kE] -> sE2^2}, 
         "coordinateData" -> {<|"occurrenceIndex" -> 1, "momentum" -> kE, 
            "squaredExpression" -> sp[kE, kE], "magnitudeExpression" -> 
             Sqrt[sp[kE, kE]], "gramVector" -> {0, 0, 1}, 
            "baseCoefficients" -> {0, 1, 0}, "independentQ" -> True, 
            "externalLegIndex" -> 1, "userVariable" -> sE1, 
            "defaultSquaredExpression" -> sE1^2, "scalarProduct" -> 
             sp[kE, kE], "publicExpression" -> sE1^2, "coordinateType" -> 
             "externalLegSquareRoot", "userJacobian" -> 1|>, 
           <|"occurrenceIndex" -> 3, "momentum" -> k + kE, 
            "squaredExpression" -> sp[k + kE, k + kE], 
            "magnitudeExpression" -> Sqrt[sp[k + kE, k + kE]], 
            "gramVector" -> {1, 2, 1}, "baseCoefficients" -> {0, 0, 1}, 
            "independentQ" -> True, "externalLegIndex" -> 2, 
            "userVariable" -> sE2, "defaultSquaredExpression" -> sE2^2, 
            "scalarProduct" -> sp[k + kE, k + kE], "publicExpression" -> 
             sE2^2, "coordinateType" -> "externalLegSquareRoot", 
            "userJacobian" -> 1|>}, "defaultNamingConvention" -> "sE1,sE2,... \
follow the first-occurrence independent basis of no-loop momentum magnitudes \
in lineData, vertexEnergies and extLegs", "automaticCrossProducts" -> False, 
         "entersLoopIBPGenerators" -> False, "entersISPClosure" -> False|>, 
       "message" -> "vertexEnergies \:53ef\:4f7f\:7528 loop-external Gram \
\:6839\:53f7\:6216\:5b9e\:9645\:51fa\:73b0\:7684\:65e0\:5708\:52a8\:91cf\
\:6a21\:957f\:ff1b015 \
\:4e0d\:81ea\:52a8\:751f\:6210\:5916\:817f\:5411\:91cf\:4e4b\:95f4\:7684\
\:4ea4\:53c9\:70b9\:79ef\:3002\:65e0\:5708\:52a8\:91cf\:53d8\:91cf\:4e0d\
\:8fdb\:5165 loop IBP/ISP\:3002"|>, "requiredVertexEnergies" -> 
      {sE1, sE2, ss11}, "internalRequiredVertexEnergies" -> 
      {sE1, sE2, kk[1, 1]}, "requiredLineParameters" -> {nu0, nu1, nu2}, 
     "requiredNumericVariables" -> {ss11, sE1, sE2, nu0, nu1, nu2}, 
     "internalRequiredNumericVariables" -> {kk[1, 1], sE1, sE2, nu0, nu1, 
       nu2}, "missingExternalInvariants" -> {}, 
     "internalMissingExternalInvariants" -> {}, "missingVertexEnergies" -> 
      {}, "internalMissingVertexEnergies" -> {}, "missingLineParameters" -> 
      {}, "missingNumericVariables" -> {}, 
     "internalMissingNumericVariables" -> {}, 
     "completeStaticNumericRulesQ" -> True|>, "pendingFeatures" -> {}, 
   "issues" -> {<|"severity" -> "warning", 
      "code" -> "sampleDiscreteRulesMissingForDiscreteVariables", 
      "missingVariables" -> {n[e1, 1], n[e1, 2], n[e2, 1], n[e2, 2], 
        n[e3, 1], n[e3, 2]}, "comment" -> "sample seed mode needs complete \
n=0/1 rules; DiscreteMode -> all can enumerate them automatically"|>}|>, 
 "numericRuleRequirementReport" -> 
  <|"providedNumericVariables" -> {dim, nu0, nu1, nu2, ss11, sE1, sE2}, 
   "internalProvidedNumericVariables" -> {dim, nu0, nu1, nu2, kk[1, 1], sE1, 
     sE2}, "requiredExternalInvariants" -> {ss11}, 
   "internalRequiredExternalInvariants" -> {kk[1, 1]}, 
   "externalInvariantNamingReport" -> <|"externalMomenta" -> {k}, 
     "externalInvariantRules" -> {sp[k, k] -> ss11^2}, 
     "internalExternalInvariantRules" -> {kk[1, 1] -> ss11^2}, 
     "coordinateData" -> {<|"internalVariable" -> kk[1, 1], 
        "publicExpression" -> ss11^2, "userVariable" -> ss11, 
        "coordinateType" -> "squareRoot", "internalCoordinateExpression" -> 
         Sqrt[kk[1, 1]], "internalJacobian" -> 2*Sqrt[kk[1, 1]], 
        "userJacobian" -> 2*ss11|>}, "defaultNamingConvention" -> 
      "ssij = Sqrt[sp[k_i,k_j]], where i<=j follows externalMomenta order", 
     "message" -> "externalMomenta \
\:662f\:8fdb\:5165\:5185\:7ebf\:504f\:79fb\:7684\:72ec\:7acb\:5411\:91cf\
\:ff1b\:5185\:90e8\:4ecd\:7528 kk[i,j]=sp[k_i,k_j]\:ff0c015 \
\:516c\:5f00\:7f3a\:7701\:5750\:6807\:4e3a ssij\:3002"|>, 
   "externalLegInvariantNamingReport" -> <|"externalLegMomenta" -> {kE}, 
     "appearingMagnitudeMomenta" -> {kE, 2*kE, k + kE, k - kE}, 
     "independentMagnitudeMomenta" -> {kE, k + kE}, 
     "dependentMagnitudeBindings" -> {<|"momentum" -> 2*kE, 
        "squaredExpression" -> sp[2*kE, 2*kE], "userSquaredExpression" -> 
         4*sE1^2, "userMagnitudeExpression" -> 2*Sqrt[sE1^2]|>, 
       <|"momentum" -> k - kE, "squaredExpression" -> sp[k - kE, k - kE], 
        "userSquaredExpression" -> 2*sE1^2 - sE2^2 + 2*ss11^2, 
        "userMagnitudeExpression" -> Sqrt[2*sE1^2 - sE2^2 + 2*ss11^2]|>}, 
     "externalLegInvariantRules" -> {sp[kE, kE] -> sE1^2, 
       sp[k + kE, k + kE] -> sE2^2}, "coordinateData" -> 
      {<|"occurrenceIndex" -> 1, "momentum" -> kE, "squaredExpression" -> 
         sp[kE, kE], "magnitudeExpression" -> Sqrt[sp[kE, kE]], 
        "gramVector" -> {0, 0, 1}, "baseCoefficients" -> {0, 1, 0}, 
        "independentQ" -> True, "externalLegIndex" -> 1, 
        "userVariable" -> sE1, "defaultSquaredExpression" -> sE1^2, 
        "scalarProduct" -> sp[kE, kE], "publicExpression" -> sE1^2, 
        "coordinateType" -> "externalLegSquareRoot", "userJacobian" -> 1|>, 
       <|"occurrenceIndex" -> 3, "momentum" -> k + kE, "squaredExpression" -> 
         sp[k + kE, k + kE], "magnitudeExpression" -> 
         Sqrt[sp[k + kE, k + kE]], "gramVector" -> {1, 2, 1}, 
        "baseCoefficients" -> {0, 0, 1}, "independentQ" -> True, 
        "externalLegIndex" -> 2, "userVariable" -> sE2, 
        "defaultSquaredExpression" -> sE2^2, "scalarProduct" -> 
         sp[k + kE, k + kE], "publicExpression" -> sE2^2, 
        "coordinateType" -> "externalLegSquareRoot", "userJacobian" -> 1|>}, 
     "defaultNamingConvention" -> "sE1,sE2,... follow the first-occurrence \
independent basis of no-loop momentum magnitudes in lineData, vertexEnergies \
and extLegs", "automaticCrossProducts" -> False, "entersLoopIBPGenerators" -> 
      False, "entersISPClosure" -> False|>, "vertexEnergyNamingReport" -> 
    <|"convention" -> "loop external roots use ssij; the independent basis of \
actually appearing no-loop momentum magnitudes uses sEe variables and \
dependent magnitudes keep explicit bindings; unrelated scalar phase \
parameters remain explicit user symbols", "rawVertexEnergies" -> 
      <|v1 -> Sqrt[sp[k + kE, k + kE]], v2 -> Sqrt[sp[k - kE, k - kE]]|>, 
     "internalVertexEnergies" -> <|v1 -> sE2, 
       v2 -> Sqrt[2*sE1^2 - sE2^2 + 2*kk[1, 1]]|>, "userVertexEnergies" -> 
      <|v1 -> sE2, v2 -> Sqrt[2*sE1^2 - sE2^2 + 2*ss11^2]|>, 
     "dependencyData" -> <|v1 -> <|"internalExternalInvariantVariables" -> 
          {}, "externalInvariantVariables" -> {}, 
         "internalIndependentVertexEnergyParameters" -> {sE2}, 
         "independentVertexEnergyParameters" -> {sE2}, 
         "usesExternalInvariantQ" -> False, "usesIndependentVertexEnergyQ" -> 
          True, "kind" -> "independentVertexEnergyParameter"|>, 
       v2 -> <|"internalExternalInvariantVariables" -> {kk[1, 1]}, 
         "externalInvariantVariables" -> {ss11^2}, 
         "internalIndependentVertexEnergyParameters" -> {sE1, sE2}, 
         "independentVertexEnergyParameters" -> {sE1, sE2}, 
         "usesExternalInvariantQ" -> True, "usesIndependentVertexEnergyQ" -> 
          True, "kind" -> "mixedExpression"|>|>, 
     "externalLegInvariantNamingReport" -> <|"externalLegMomenta" -> {kE}, 
       "appearingMagnitudeMomenta" -> {kE, 2*kE, k + kE, k - kE}, 
       "independentMagnitudeMomenta" -> {kE, k + kE}, 
       "dependentMagnitudeBindings" -> {<|"momentum" -> 2*kE, 
          "squaredExpression" -> sp[2*kE, 2*kE], "userSquaredExpression" -> 
           4*sE1^2, "userMagnitudeExpression" -> 2*Sqrt[sE1^2]|>, 
         <|"momentum" -> k - kE, "squaredExpression" -> sp[k - kE, k - kE], 
          "userSquaredExpression" -> 2*sE1^2 - sE2^2 + 2*ss11^2, 
          "userMagnitudeExpression" -> Sqrt[2*sE1^2 - sE2^2 + 2*ss11^2]|>}, 
       "externalLegInvariantRules" -> {sp[kE, kE] -> sE1^2, 
         sp[k + kE, k + kE] -> sE2^2}, "coordinateData" -> 
        {<|"occurrenceIndex" -> 1, "momentum" -> kE, "squaredExpression" -> 
           sp[kE, kE], "magnitudeExpression" -> Sqrt[sp[kE, kE]], 
          "gramVector" -> {0, 0, 1}, "baseCoefficients" -> {0, 1, 0}, 
          "independentQ" -> True, "externalLegIndex" -> 1, 
          "userVariable" -> sE1, "defaultSquaredExpression" -> sE1^2, 
          "scalarProduct" -> sp[kE, kE], "publicExpression" -> sE1^2, 
          "coordinateType" -> "externalLegSquareRoot", "userJacobian" -> 1|>, 
         <|"occurrenceIndex" -> 3, "momentum" -> k + kE, 
          "squaredExpression" -> sp[k + kE, k + kE], "magnitudeExpression" -> 
           Sqrt[sp[k + kE, k + kE]], "gramVector" -> {1, 2, 1}, 
          "baseCoefficients" -> {0, 0, 1}, "independentQ" -> True, 
          "externalLegIndex" -> 2, "userVariable" -> sE2, 
          "defaultSquaredExpression" -> sE2^2, "scalarProduct" -> 
           sp[k + kE, k + kE], "publicExpression" -> sE2^2, 
          "coordinateType" -> "externalLegSquareRoot", "userJacobian" -> 
           1|>}, "defaultNamingConvention" -> "sE1,sE2,... follow the \
first-occurrence independent basis of no-loop momentum magnitudes in \
lineData, vertexEnergies and extLegs", "automaticCrossProducts" -> False, 
       "entersLoopIBPGenerators" -> False, "entersISPClosure" -> False|>, 
     "message" -> "vertexEnergies \:53ef\:4f7f\:7528 loop-external Gram \
\:6839\:53f7\:6216\:5b9e\:9645\:51fa\:73b0\:7684\:65e0\:5708\:52a8\:91cf\
\:6a21\:957f\:ff1b015 \
\:4e0d\:81ea\:52a8\:751f\:6210\:5916\:817f\:5411\:91cf\:4e4b\:95f4\:7684\
\:4ea4\:53c9\:70b9\:79ef\:3002\:65e0\:5708\:52a8\:91cf\:53d8\:91cf\:4e0d\
\:8fdb\:5165 loop IBP/ISP\:3002"|>, "requiredVertexEnergies" -> 
    {sE1, sE2, ss11}, "internalRequiredVertexEnergies" -> 
    {sE1, sE2, kk[1, 1]}, "requiredLineParameters" -> {nu0, nu1, nu2}, 
   "requiredNumericVariables" -> {ss11, sE1, sE2, nu0, nu1, nu2}, 
   "internalRequiredNumericVariables" -> {kk[1, 1], sE1, sE2, nu0, nu1, nu2}, 
   "missingExternalInvariants" -> {}, "internalMissingExternalInvariants" -> 
    {}, "missingVertexEnergies" -> {}, "internalMissingVertexEnergies" -> {}, 
   "missingLineParameters" -> {}, "missingNumericVariables" -> {}, 
   "internalMissingNumericVariables" -> {}, "completeStaticNumericRulesQ" -> 
    True|>, "numericRuleTemplate" -> {}, "tadpoleSymmetryData" -> 
  <|"status" -> "generated", "loopReversalData" -> {}, 
   "massiveFullLineIndices" -> Missing["KeyAbsent", "lineIndex"], 
   "masslessFullLineIndices" -> Missing["KeyAbsent", "lineIndex"], 
   "automaticRuleCount" -> 1, "automaticRules" -> 
    {HoldPattern[dSIBP`Private`int$_J /; dSIBP`Private`tadpoleOddISPIntegralQ[
         <|"name" -> "rootKinematicCoordinatesExample", "vertexData" -> 
           {{v1, "+"}, {v2, "+"}}, "vertexIds" -> {v1, v2}, 
          "vertexSignAssoc" -> <|v1 -> "+", v2 -> "+"|>, 
          "lines" -> {<|"id" -> e1, "endpoints" -> {v1, v2}, "momentum" -> q, 
             "nu" -> nu0, "bbType" -> "h", "massType" -> "massive", 
             "skType" -> "++", "state" -> "full", "thetaConvention" -> 
              "mergedTwoTheta", "packType" -> "massiveFull", 
             "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], 
             "masslessN1OppositeEndpoint" -> Missing["NotApplicable"], 
             "functionSystem" -> <|"preset" -> "h", "variable" -> 
                dSIBP`Private`x, "P" -> (1 + 2*nu0)/dSIBP`Private`x, "Q" -> 
                1, "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu0])*
                  dSIBP`Private`x^(-1 - 2*nu0))/Pi, "WT" -> Automatic, 
               "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 2*nu0|>, 
             "compiledFunctionSystem" -> <|"status" -> "compiled", "input" -> 
                <|"preset" -> "h", "variable" -> dSIBP`Private`x, 
                 "P" -> (1 + 2*nu0)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 
                  0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu0])*dSIBP`Private`x^
                     (-1 - 2*nu0))/Pi, "WT" -> Automatic, "shrinkBShift" -> 
                  1, "shrinkZeroPointShift" -> 2*nu0|>, "variable" -> 
                dSIBP`Private`x, "P" -> (1 + 2*nu0)/dSIBP`Private`x, "Q" -> 
                1, "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu0])*
                  dSIBP`Private`x^(-1 - 2*nu0))/Pi, "A0" -> {{0, 1}, 
                 {-1, -((1 + 2*nu0)/dSIBP`Private`x)}}, "AT" -> 
                {{0, 1}, {-1, -((1 + 2*nu0)/dSIBP`Private`x)}}, "WT" -> 
                ((-4*I)*E^(Pi*Im[nu0])*dSIBP`Private`x^(-1 - 2*nu0))/Pi, 
               "derivativeTerms" -> {<|"sourceState" -> 0, "targetState" -> 
                   1, "xPower" -> 0, "coefficient" -> 1|>, <|"sourceState" -> 
                   1, "targetState" -> 0, "xPower" -> 0, "coefficient" -> 
                   -1|>, <|"sourceState" -> 1, "targetState" -> 1, 
                  "xPower" -> -1, "coefficient" -> -1 - 2*nu0|>}, 
               "shrinkTerms" -> {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu0]))/
                    Pi, "xPower" -> -1 - 2*nu0, "bShift" -> 1, 
                  "zeroPointShift" -> 2*nu0|>}, "shrinkZeroPointShift" -> 
                2*nu0|>|>, <|"id" -> e2, "endpoints" -> {v1, v2}, 
             "momentum" -> kE, "nu" -> nu1, "bbType" -> "h", 
             "massType" -> "massive", "skType" -> "++", "state" -> "full", 
             "thetaConvention" -> "mergedTwoTheta", "packType" -> 
              "massiveFull", "masslessN1ReferenceEndpoint" -> 
              Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
              Missing["NotApplicable"], "functionSystem" -> <|"preset" -> 
                "h", "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu1)/
                 dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, "W" -> 
                ((-4*I)*E^(Pi*Im[nu1])*dSIBP`Private`x^(-1 - 2*nu1))/Pi, 
               "WT" -> Automatic, "shrinkBShift" -> 1, 
               "shrinkZeroPointShift" -> 2*nu1|>, "compiledFunctionSystem" -> 
              <|"status" -> "compiled", "input" -> <|"preset" -> "h", 
                 "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu1)/
                   dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, 
                 "W" -> ((-4*I)*E^(Pi*Im[nu1])*dSIBP`Private`x^(-1 - 2*nu1))/
                   Pi, "WT" -> Automatic, "shrinkBShift" -> 1, 
                 "shrinkZeroPointShift" -> 2*nu1|>, "variable" -> 
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
                2*nu1|>|>, <|"id" -> e3, "endpoints" -> {v1, v2}, 
             "momentum" -> 2*kE, "nu" -> nu2, "bbType" -> "h", 
             "massType" -> "massive", "skType" -> "++", "state" -> "full", 
             "thetaConvention" -> "mergedTwoTheta", "packType" -> 
              "massiveFull", "masslessN1ReferenceEndpoint" -> 
              Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
              Missing["NotApplicable"], "functionSystem" -> <|"preset" -> 
                "h", "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu2)/
                 dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, "W" -> 
                ((-4*I)*E^(Pi*Im[nu2])*dSIBP`Private`x^(-1 - 2*nu2))/Pi, 
               "WT" -> Automatic, "shrinkBShift" -> 1, 
               "shrinkZeroPointShift" -> 2*nu2|>, "compiledFunctionSystem" -> 
              <|"status" -> "compiled", "input" -> <|"preset" -> "h", 
                 "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu2)/
                   dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, 
                 "W" -> ((-4*I)*E^(Pi*Im[nu2])*dSIBP`Private`x^(-1 - 2*nu2))/
                   Pi, "WT" -> Automatic, "shrinkBShift" -> 1, 
                 "shrinkZeroPointShift" -> 2*nu2|>, "variable" -> 
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
                2*nu2|>|>}, "extLegs" -> {}, "vertexEnergies" -> 
           <|v1 -> Sqrt[sp[k + kE, k + kE]], v2 -> Sqrt[sp[k - kE, k - 
                kE]]|>, "activeVertexIds" -> {v1, v2}, 
          "fixedAVertexValues" -> <||>, "loopMomenta" -> {q}, 
          "externalMomenta" -> {k}, "externalLegMomenta" -> {kE}, 
          "rawExternalInvariantRules" -> {sp[k, k] -> ss11^2}, 
          "externalInvariantRules" -> {sp[k, k] -> ss11^2}, 
          "rawExternalLegInvariantRules" -> {sp[kE, kE] -> sE1^2, 
            sp[k + kE, k + kE] -> sE2^2}, "externalLegInvariantRules" -> 
           {sp[kE, kE] -> sE1^2, sp[k + kE, k + kE] -> sE2^2}, 
          "kinematicRules" -> Automatic, "kinematicCoordinateAudit" -> 
           <|"status" -> "complete", "source" -> "default", 
            "baseCoordinateData" -> {<|"baseIndex" -> 1, "kind" -> 
                "loopExternalGram", "inputExpression" -> sp[k, k], 
               "internalVariable" -> kk[1, 1], "defaultVariable" -> ss11, 
               "defaultRHS" -> ss11^2|>, <|"occurrenceIndex" -> 1, 
               "momentum" -> kE, "squaredExpression" -> sp[kE, kE], 
               "magnitudeExpression" -> Sqrt[sp[kE, kE]], "gramVector" -> 
                {0, 0, 1}, "baseCoefficients" -> {0, 1, 0}, "independentQ" -> 
                True, "externalLegIndex" -> 1, "userVariable" -> sE1, 
               "defaultSquaredExpression" -> sE1^2, "baseIndex" -> 2, 
               "kind" -> "externalLegMagnitude", "inputExpression" -> 
                sp[kE, kE], "internalVariable" -> 
                dSIBP`Private`externalLegSquaredCoordinate[1], 
               "defaultVariable" -> sE1, "defaultRHS" -> sE1^2|>, 
              <|"occurrenceIndex" -> 3, "momentum" -> k + kE, 
               "squaredExpression" -> sp[k + kE, k + kE], 
               "magnitudeExpression" -> Sqrt[sp[k + kE, k + kE]], 
               "gramVector" -> {1, 2, 1}, "baseCoefficients" -> {0, 0, 1}, 
               "independentQ" -> True, "externalLegIndex" -> 2, 
               "userVariable" -> sE2, "defaultSquaredExpression" -> sE2^2, 
               "baseIndex" -> 3, "kind" -> "externalLegMagnitude", 
               "inputExpression" -> sp[k + kE, k + kE], "internalVariable" -> 
                dSIBP`Private`externalLegSquaredCoordinate[2], 
               "defaultVariable" -> sE2, "defaultRHS" -> sE2^2|>}, 
            "baseCoordinateOrder" -> {sp[k, k], sp[kE, kE], sp[k + kE, k + 
                kE]}, "baseCoordinateCount" -> 3, "defaultRules" -> 
             {sp[k, k] -> ss11^2, sp[kE, kE] -> sE1^2, sp[k + kE, k + kE] -> 
               sE2^2}, "selectionTemplate" -> "kinematicRules" -> 
              {sp[k, k] -> ss11^2, sp[kE, kE] -> sE1^2, sp[k + kE, k + kE] -> 
                sE2^2}, "selectedRules" -> {sp[k, k] -> ss11^2, 
              sp[kE, kE] -> sE1^2, sp[k + kE, k + kE] -> sE2^2}, 
            "selectedUserVariables" -> {ss11, sE1, sE2}, 
            "userParameterOrder" -> {ss11, sE1, sE2}, "coordinateMatrix" -> 
             {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}}, "coordinateRank" -> 3, 
            "parameterJacobian" -> {{2*ss11, 0, 0}, {0, 2*sE1, 0}, 
              {0, 0, 2*sE2}}, "parameterRank" -> 3, "missingDirections" -> 
             {}, "ruleMissingDirections" -> {}, 
            "parameterMissingDirections" -> {}, 
            "ruleMissingDirectionExpressions" -> {}, 
            "parameterMissingDirectionExpressions" -> {}, 
            "ruleDependencies" -> {}, "ruleDependencyResiduals" -> {}, 
            "parameterDependencies" -> {}, "constraintResiduals" -> {}, 
            "unsupportedRulePositions" -> {}, "completeQ" -> True, 
            "overcompleteQ" -> False, "inverseAvailableQ" -> True, 
            "resolvedRules" -> {sp[k, k] -> ss11^2, sp[kE, kE] -> sE1^2, 
              sp[k + kE, k + kE] -> sE2^2}, "baseSquaredUserExpressions" -> 
             {ss11^2, sE1^2, sE2^2}, "baseRootUserExpressions" -> 
             {ss11, sE1, sE2}, "appearingNoLoopMagnitudeMomenta" -> 
             {kE, 2*kE, k + kE, k - kE}, 
            "independentNoLoopMagnitudeMomenta" -> {kE, k + kE}, 
            "dependentMagnitudeBindings" -> {<|"momentum" -> 2*kE, 
               "squaredExpression" -> sp[2*kE, 2*kE], 
               "userSquaredExpression" -> 4*sE1^2, 
               "userMagnitudeExpression" -> 2*Sqrt[sE1^2]|>, <|"momentum" -> 
                k - kE, "squaredExpression" -> sp[k - kE, k - kE], 
               "userSquaredExpression" -> 2*sE1^2 - sE2^2 + 2*ss11^2, 
               "userMagnitudeExpression" -> Sqrt[2*sE1^2 - sE2^2 + 
                  2*ss11^2]|>}, "rawLoopRules" -> {sp[k, k] -> ss11^2}, 
            "resolvedLoopRules" -> {sp[k, k] -> ss11^2}, 
            "rawExternalLegRules" -> {sp[kE, kE] -> sE1^2, sp[k + kE, 
                k + kE] -> sE2^2}, "resolvedExternalLegRules" -> 
             {sp[kE, kE] -> sE1^2, sp[k + kE, k + kE] -> sE2^2}, 
            "message" -> "\:52a8\:529b\:5b66\:53d8\:91cf\:5b8c\:5907\:ff0c\
\:4e14\:5f53\:524d\:7b80\:5355\:5750\:6807\:89c4\:5219\:53ef\:53cd\:5411\
\:8f6c\:6362\:3002"|>, "ispData" -> {<|"name" -> rho1, "expr" -> sp[k, q], 
             "range" -> {0}|>}, "nV" -> 2, "nE" -> 3, "nL" -> 1, "nK" -> 1, 
          "bMatrix" -> {{1, 1, 1}, {-1, -1, -1}}, "vertexLines" -> 
           {{{1, 1}, {2, 1}, {3, 1}}, {{1, -1}, {2, -1}, {3, -1}}}, 
          "loopCoeffMatrix" -> {{1}, {0}, {0}}, "externalCoeffMatrix" -> 
           {{0}, {0}, {0}}, "externalPartList" -> {0, kE, 2*kE}, 
          "rawNumericRules" -> {dim -> 3, nu0 -> 1/3, nu1 -> 2/3, nu2 -> 4/3, 
            ss11 -> 5, sE1 -> 7, sE2 -> 11}, "numericRules" -> 
           {dim -> 3, nu0 -> 1/3, nu1 -> 2/3, nu2 -> 4/3, kk[1, 1] -> 25, 
            sE1 -> 7, sE2 -> 11}, "sampleDiscreteRules" -> {}, 
          "seedPreset" -> "fullDiscrete", "seedRanges" -> 
           <|"a" -> {0}, "b" -> {0}, "isp" -> {0}, "sampleOnly" -> True|>, 
          "generatorSeedRanges" -> {}, "seedOptions" -> 
           <|"DiscreteMode" -> "all", "MaxSeedRuleCount" -> 200, 
            "MaxDiscreteRuleCount" -> 64, "MaxEquationCount" -> 200, 
            "MaxShrinkSectorDepth" -> Automatic, "MaxShrinkSectorCount" -> 
             16|>, "unknownSeedPreset" -> None, "zeroPointRules" -> {}, 
          "shrinkPrefactorRules" -> {}, "symmetryRules" -> {}, 
          "thetaBoundarySignOffset" -> Automatic, "kiraOrdering" -> <||>, 
          "sectorVertexRepresentativeMap" -> <|v1 -> v1, v2 -> v2|>|>, 
         dSIBP`Private`int$]] :> 0}, "userRuleCount" -> 0, 
   "effectiveRuleCount" -> 1|>, "effectiveSymmetryRules" -> 
  {HoldPattern[dSIBP`Private`int$_J /; dSIBP`Private`tadpoleOddISPIntegralQ[
       <|"name" -> "rootKinematicCoordinatesExample", 
        "vertexData" -> {{v1, "+"}, {v2, "+"}}, "vertexIds" -> {v1, v2}, 
        "vertexSignAssoc" -> <|v1 -> "+", v2 -> "+"|>, 
        "lines" -> {<|"id" -> e1, "endpoints" -> {v1, v2}, "momentum" -> q, 
           "nu" -> nu0, "bbType" -> "h", "massType" -> "massive", 
           "skType" -> "++", "state" -> "full", "thetaConvention" -> 
            "mergedTwoTheta", "packType" -> "massiveFull", 
           "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], 
           "masslessN1OppositeEndpoint" -> Missing["NotApplicable"], 
           "functionSystem" -> <|"preset" -> "h", "variable" -> 
              dSIBP`Private`x, "P" -> (1 + 2*nu0)/dSIBP`Private`x, "Q" -> 1, 
             "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu0])*
                dSIBP`Private`x^(-1 - 2*nu0))/Pi, "WT" -> Automatic, 
             "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 2*nu0|>, 
           "compiledFunctionSystem" -> <|"status" -> "compiled", 
             "input" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x, 
               "P" -> (1 + 2*nu0)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, 
                {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu0])*dSIBP`Private`x^
                   (-1 - 2*nu0))/Pi, "WT" -> Automatic, "shrinkBShift" -> 
                1, "shrinkZeroPointShift" -> 2*nu0|>, "variable" -> 
              dSIBP`Private`x, "P" -> (1 + 2*nu0)/dSIBP`Private`x, "Q" -> 1, 
             "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu0])*
                dSIBP`Private`x^(-1 - 2*nu0))/Pi, "A0" -> {{0, 1}, {-1, 
                -((1 + 2*nu0)/dSIBP`Private`x)}}, "AT" -> {{0, 1}, {-1, 
                -((1 + 2*nu0)/dSIBP`Private`x)}}, "WT" -> 
              ((-4*I)*E^(Pi*Im[nu0])*dSIBP`Private`x^(-1 - 2*nu0))/Pi, 
             "derivativeTerms" -> {<|"sourceState" -> 0, "targetState" -> 1, 
                "xPower" -> 0, "coefficient" -> 1|>, <|"sourceState" -> 1, 
                "targetState" -> 0, "xPower" -> 0, "coefficient" -> -1|>, <|
                "sourceState" -> 1, "targetState" -> 1, "xPower" -> -1, 
                "coefficient" -> -1 - 2*nu0|>}, "shrinkTerms" -> 
              {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu0]))/Pi, "xPower" -> 
                 -1 - 2*nu0, "bShift" -> 1, "zeroPointShift" -> 2*nu0|>}, 
             "shrinkZeroPointShift" -> 2*nu0|>|>, <|"id" -> e2, 
           "endpoints" -> {v1, v2}, "momentum" -> kE, "nu" -> nu1, 
           "bbType" -> "h", "massType" -> "massive", "skType" -> "++", 
           "state" -> "full", "thetaConvention" -> "mergedTwoTheta", 
           "packType" -> "massiveFull", "masslessN1ReferenceEndpoint" -> 
            Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
            Missing["NotApplicable"], "functionSystem" -> <|"preset" -> "h", 
             "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu1)/
               dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, 
             "W" -> ((-4*I)*E^(Pi*Im[nu1])*dSIBP`Private`x^(-1 - 2*nu1))/Pi, 
             "WT" -> Automatic, "shrinkBShift" -> 1, 
             "shrinkZeroPointShift" -> 2*nu1|>, "compiledFunctionSystem" -> 
            <|"status" -> "compiled", "input" -> <|"preset" -> "h", 
               "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu1)/
                 dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, "W" -> 
                ((-4*I)*E^(Pi*Im[nu1])*dSIBP`Private`x^(-1 - 2*nu1))/Pi, 
               "WT" -> Automatic, "shrinkBShift" -> 1, 
               "shrinkZeroPointShift" -> 2*nu1|>, "variable" -> 
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
             "shrinkZeroPointShift" -> 2*nu1|>|>, <|"id" -> e3, 
           "endpoints" -> {v1, v2}, "momentum" -> 2*kE, "nu" -> nu2, 
           "bbType" -> "h", "massType" -> "massive", "skType" -> "++", 
           "state" -> "full", "thetaConvention" -> "mergedTwoTheta", 
           "packType" -> "massiveFull", "masslessN1ReferenceEndpoint" -> 
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
             "shrinkZeroPointShift" -> 2*nu2|>|>}, "extLegs" -> {}, 
        "vertexEnergies" -> <|v1 -> Sqrt[sp[k + kE, k + kE]], 
          v2 -> Sqrt[sp[k - kE, k - kE]]|>, "activeVertexIds" -> {v1, v2}, 
        "fixedAVertexValues" -> <||>, "loopMomenta" -> {q}, 
        "externalMomenta" -> {k}, "externalLegMomenta" -> {kE}, 
        "rawExternalInvariantRules" -> {sp[k, k] -> ss11^2}, 
        "externalInvariantRules" -> {sp[k, k] -> ss11^2}, 
        "rawExternalLegInvariantRules" -> {sp[kE, kE] -> sE1^2, 
          sp[k + kE, k + kE] -> sE2^2}, "externalLegInvariantRules" -> 
         {sp[kE, kE] -> sE1^2, sp[k + kE, k + kE] -> sE2^2}, 
        "kinematicRules" -> Automatic, "kinematicCoordinateAudit" -> 
         <|"status" -> "complete", "source" -> "default", 
          "baseCoordinateData" -> {<|"baseIndex" -> 1, "kind" -> 
              "loopExternalGram", "inputExpression" -> sp[k, k], 
             "internalVariable" -> kk[1, 1], "defaultVariable" -> ss11, 
             "defaultRHS" -> ss11^2|>, <|"occurrenceIndex" -> 1, 
             "momentum" -> kE, "squaredExpression" -> sp[kE, kE], 
             "magnitudeExpression" -> Sqrt[sp[kE, kE]], "gramVector" -> 
              {0, 0, 1}, "baseCoefficients" -> {0, 1, 0}, "independentQ" -> 
              True, "externalLegIndex" -> 1, "userVariable" -> sE1, 
             "defaultSquaredExpression" -> sE1^2, "baseIndex" -> 2, 
             "kind" -> "externalLegMagnitude", "inputExpression" -> 
              sp[kE, kE], "internalVariable" -> 
              dSIBP`Private`externalLegSquaredCoordinate[1], 
             "defaultVariable" -> sE1, "defaultRHS" -> sE1^2|>, 
            <|"occurrenceIndex" -> 3, "momentum" -> k + kE, 
             "squaredExpression" -> sp[k + kE, k + kE], 
             "magnitudeExpression" -> Sqrt[sp[k + kE, k + kE]], 
             "gramVector" -> {1, 2, 1}, "baseCoefficients" -> {0, 0, 1}, 
             "independentQ" -> True, "externalLegIndex" -> 2, 
             "userVariable" -> sE2, "defaultSquaredExpression" -> sE2^2, 
             "baseIndex" -> 3, "kind" -> "externalLegMagnitude", 
             "inputExpression" -> sp[k + kE, k + kE], "internalVariable" -> 
              dSIBP`Private`externalLegSquaredCoordinate[2], 
             "defaultVariable" -> sE2, "defaultRHS" -> sE2^2|>}, 
          "baseCoordinateOrder" -> {sp[k, k], sp[kE, kE], 
            sp[k + kE, k + kE]}, "baseCoordinateCount" -> 3, 
          "defaultRules" -> {sp[k, k] -> ss11^2, sp[kE, kE] -> sE1^2, 
            sp[k + kE, k + kE] -> sE2^2}, "selectionTemplate" -> 
           "kinematicRules" -> {sp[k, k] -> ss11^2, sp[kE, kE] -> sE1^2, 
             sp[k + kE, k + kE] -> sE2^2}, "selectedRules" -> 
           {sp[k, k] -> ss11^2, sp[kE, kE] -> sE1^2, sp[k + kE, k + kE] -> 
             sE2^2}, "selectedUserVariables" -> {ss11, sE1, sE2}, 
          "userParameterOrder" -> {ss11, sE1, sE2}, "coordinateMatrix" -> 
           {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}}, "coordinateRank" -> 3, 
          "parameterJacobian" -> {{2*ss11, 0, 0}, {0, 2*sE1, 0}, 
            {0, 0, 2*sE2}}, "parameterRank" -> 3, "missingDirections" -> {}, 
          "ruleMissingDirections" -> {}, "parameterMissingDirections" -> {}, 
          "ruleMissingDirectionExpressions" -> {}, 
          "parameterMissingDirectionExpressions" -> {}, "ruleDependencies" -> 
           {}, "ruleDependencyResiduals" -> {}, "parameterDependencies" -> 
           {}, "constraintResiduals" -> {}, "unsupportedRulePositions" -> {}, 
          "completeQ" -> True, "overcompleteQ" -> False, 
          "inverseAvailableQ" -> True, "resolvedRules" -> 
           {sp[k, k] -> ss11^2, sp[kE, kE] -> sE1^2, sp[k + kE, k + kE] -> 
             sE2^2}, "baseSquaredUserExpressions" -> {ss11^2, sE1^2, sE2^2}, 
          "baseRootUserExpressions" -> {ss11, sE1, sE2}, 
          "appearingNoLoopMagnitudeMomenta" -> {kE, 2*kE, k + kE, k - kE}, 
          "independentNoLoopMagnitudeMomenta" -> {kE, k + kE}, 
          "dependentMagnitudeBindings" -> {<|"momentum" -> 2*kE, 
             "squaredExpression" -> sp[2*kE, 2*kE], 
             "userSquaredExpression" -> 4*sE1^2, "userMagnitudeExpression" -> 
              2*Sqrt[sE1^2]|>, <|"momentum" -> k - kE, "squaredExpression" -> 
              sp[k - kE, k - kE], "userSquaredExpression" -> 2*sE1^2 - sE2^
                2 + 2*ss11^2, "userMagnitudeExpression" -> Sqrt[2*sE1^2 - 
                sE2^2 + 2*ss11^2]|>}, "rawLoopRules" -> {sp[k, k] -> ss11^2}, 
          "resolvedLoopRules" -> {sp[k, k] -> ss11^2}, 
          "rawExternalLegRules" -> {sp[kE, kE] -> sE1^2, 
            sp[k + kE, k + kE] -> sE2^2}, "resolvedExternalLegRules" -> 
           {sp[kE, kE] -> sE1^2, sp[k + kE, k + kE] -> sE2^2}, 
          "message" -> "\:52a8\:529b\:5b66\:53d8\:91cf\:5b8c\:5907\:ff0c\
\:4e14\:5f53\:524d\:7b80\:5355\:5750\:6807\:89c4\:5219\:53ef\:53cd\:5411\
\:8f6c\:6362\:3002"|>, "ispData" -> {<|"name" -> rho1, "expr" -> sp[k, q], 
           "range" -> {0}|>}, "nV" -> 2, "nE" -> 3, "nL" -> 1, "nK" -> 1, 
        "bMatrix" -> {{1, 1, 1}, {-1, -1, -1}}, "vertexLines" -> 
         {{{1, 1}, {2, 1}, {3, 1}}, {{1, -1}, {2, -1}, {3, -1}}}, 
        "loopCoeffMatrix" -> {{1}, {0}, {0}}, "externalCoeffMatrix" -> 
         {{0}, {0}, {0}}, "externalPartList" -> {0, kE, 2*kE}, 
        "rawNumericRules" -> {dim -> 3, nu0 -> 1/3, nu1 -> 2/3, nu2 -> 4/3, 
          ss11 -> 5, sE1 -> 7, sE2 -> 11}, "numericRules" -> 
         {dim -> 3, nu0 -> 1/3, nu1 -> 2/3, nu2 -> 4/3, kk[1, 1] -> 25, 
          sE1 -> 7, sE2 -> 11}, "sampleDiscreteRules" -> {}, 
        "seedPreset" -> "fullDiscrete", "seedRanges" -> 
         <|"a" -> {0}, "b" -> {0}, "isp" -> {0}, "sampleOnly" -> True|>, 
        "generatorSeedRanges" -> {}, "seedOptions" -> 
         <|"DiscreteMode" -> "all", "MaxSeedRuleCount" -> 200, 
          "MaxDiscreteRuleCount" -> 64, "MaxEquationCount" -> 200, 
          "MaxShrinkSectorDepth" -> Automatic, "MaxShrinkSectorCount" -> 
           16|>, "unknownSeedPreset" -> None, "zeroPointRules" -> {}, 
        "shrinkPrefactorRules" -> {}, "symmetryRules" -> {}, 
        "thetaBoundarySignOffset" -> Automatic, "kiraOrdering" -> <||>, 
        "sectorVertexRepresentativeMap" -> <|v1 -> v1, v2 -> v2|>|>, 
       dSIBP`Private`int$]] :> 0}, "masslessBundleCandidates" -> {}, 
 "masslessEndpointConventions" -> {}, "precomputedShrinkSectorSummary" -> 
  <|"status" -> "generated", "completeCoverageQ" -> True|>, 
 "precomputedShrinkSectorKeys" -> {"top", "e1", "e2", "e3", "e1_e2_e3"}|>
