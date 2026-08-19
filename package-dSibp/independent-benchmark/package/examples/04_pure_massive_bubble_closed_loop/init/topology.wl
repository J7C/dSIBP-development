<|"name" -> "018PureMassiveBubbleClosedLoopMinusMinus",
 "vertices" -> {<|"id" -> v1, "vertexType" -> "-", "externalLegEnergy" -> P0|>,
   <|"id" -> v2, "vertexType" -> "-", "externalLegEnergy" -> P0|>}, "vertexIds" -> {v1, v2},
 "vertexSignAssoc" -> <|v1 -> "-", v2 -> "-"|>,
 "lines" -> {<|"id" -> 1, "massType" -> "massive", "endpoints" -> {v1, v2}, "momentum" -> q, "nu" -> nu,
    "skType" -> "--", "state" -> "full", "thetaConvention" -> "mergedTwoTheta", "packType" -> "massiveFull",
    "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
     Missing["NotApplicable"], "functionSystem" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x,
      "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
      "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi, "WT" -> Automatic, "shrinkBShift" -> 1,
      "shrinkZeroPointShift" -> 2*nu|>, "compiledFunctionSystem" -> <|"status" -> "compiled",
      "input" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1,
        "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi, "WT" -> Automatic,
        "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 2*nu|>, "variable" -> dSIBP`Private`x,
      "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
      "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi,
      "A0" -> {{0, 1}, {-1, -((1 + 2*nu)/dSIBP`Private`x)}}, "AT" -> {{0, 1}, {-1, -((1 + 2*nu)/dSIBP`Private`x)}},
      "WT" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi, "derivativeTerms" ->
       {<|"sourceState" -> 0, "targetState" -> 1, "xPower" -> 0, "coefficient" -> 1|>,
        <|"sourceState" -> 1, "targetState" -> 0, "xPower" -> 0, "coefficient" -> -1|>,
        <|"sourceState" -> 1, "targetState" -> 1, "xPower" -> -1, "coefficient" -> -1 - 2*nu|>},
      "shrinkTerms" -> {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu]))/Pi, "xPower" -> -1 - 2*nu, "bShift" -> 1,
         "zeroPointShift" -> 2*nu|>}, "shrinkZeroPointShift" -> 2*nu|>, "rawMomentum" -> q, "loopLineQ" -> True,
    "bridgeQ" -> False, "linePowerMode" -> "indexed"|>, <|"id" -> 2, "massType" -> "massive", "endpoints" -> {v1, v2},
    "momentum" -> -k + q, "nu" -> nu, "skType" -> "--", "state" -> "full", "thetaConvention" -> "mergedTwoTheta",
    "packType" -> "massiveFull", "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"],
    "masslessN1OppositeEndpoint" -> Missing["NotApplicable"], "functionSystem" ->
     <|"preset" -> "h", "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1,
      "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi, "WT" -> Automatic,
      "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 2*nu|>, "compiledFunctionSystem" ->
     <|"status" -> "compiled", "input" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x,
        "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
        "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi, "WT" -> Automatic, "shrinkBShift" -> 1,
        "shrinkZeroPointShift" -> 2*nu|>, "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1,
      "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi,
      "A0" -> {{0, 1}, {-1, -((1 + 2*nu)/dSIBP`Private`x)}}, "AT" -> {{0, 1}, {-1, -((1 + 2*nu)/dSIBP`Private`x)}},
      "WT" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi, "derivativeTerms" ->
       {<|"sourceState" -> 0, "targetState" -> 1, "xPower" -> 0, "coefficient" -> 1|>,
        <|"sourceState" -> 1, "targetState" -> 0, "xPower" -> 0, "coefficient" -> -1|>,
        <|"sourceState" -> 1, "targetState" -> 1, "xPower" -> -1, "coefficient" -> -1 - 2*nu|>},
      "shrinkTerms" -> {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu]))/Pi, "xPower" -> -1 - 2*nu, "bShift" -> 1,
         "zeroPointShift" -> 2*nu|>}, "shrinkZeroPointShift" -> 2*nu|>, "rawMomentum" -> -k + q, "loopLineQ" -> True,
    "bridgeQ" -> False, "linePowerMode" -> "indexed"|>}, "extLegs" -> {},
 "sectorExternalLegEnergyByVertex" -> <|v1 -> P0, v2 -> P0|>, "activeVertexIds" -> {v1, v2},
 "fixedAVertexValues" -> <||>, "loopMomenta" -> {q}, "ibpMode" -> "full", "graphLoopCount" -> 1,
 "graphTopologyAudit" -> <|"status" -> "valid", "vertexCount" -> 2, "inputLineCount" -> 2, "internalLineCount" -> 2,
   "activeLineIndices" -> {1, 2}, "shrunkLineIndices" -> {}, "connectedComponentCount" -> 1, "graphLoopCount" -> 1,
   "bridgeLineIndices" -> {}, "cycleLineIndices" -> {1, 2}, "selfLoopLineIndices" -> {},
   "incidenceMatrix" -> {{1, 1}, {-1, -1}}, "cycleSpaceDimension" -> 1, "issues" -> {}|>,
 "loopMomentumRoutingAudit" -> <|"status" -> "valid", "ibpMode" -> "full", "loopMomenta" -> {q},
   "loopCoefficientMatrix" -> {{1}, {1}}, "loopCoefficientRank" -> 1, "lineExternalResiduals" -> {0, -k},
   "referenceLineIndices" -> {1}, "referenceLoopMatrix" -> {{1}}, "referenceExternalResiduals" -> {0},
   "shiftInvariantLineResiduals" -> {0, -k}, "incidenceCycleResidual" -> {{0}, {0}}, "issues" -> {}|>,
 "normalizedLineMomenta" -> {q, -k + q}, "momentumDeclarationAudit" -> <|"status" -> "exact", "ibpMode" -> "full",
   "loopExternalMomenta" -> {k}, "independentExternalMomenta" -> {}, "requiredLoopExternalDirections" -> {-k},
   "requiredIndependentMomentumMagnitudes" -> {}, "momentumAtoms" -> {k},
   "loopExternalAudit" -> <|"status" -> "exact", "atoms" -> {k}, "requiredExpressions" -> {-k},
     "userExpressions" -> {k}, "requiredBasisDirections" -> {k}, "userBasisDirections" -> {k},
     "missingDirections" -> {}, "extraDirections" -> {}, "userDependencyVectors" -> {}, "requiredRank" -> 1,
     "userRank" -> 1, "unionRank" -> 1, "invalidRequiredPositions" -> {}, "invalidUserPositions" -> {}|>,
   "independentExternalAudit" -> <|"status" -> "exact", "atoms" -> {k}, "loopGramRank" -> 1, "requiredMomenta" -> {},
     "userMomenta" -> {}, "missingMagnitudeSquares" -> {}, "extraMagnitudeSquares" -> {},
     "redundantUserPositions" -> {}, "redundantUserMomenta" -> {}, "quadraticDependencyOrder" -> {"loopGram1"},
     "quadraticDependencies" -> {}, "requiredIndependentMagnitudeCount" -> 0, "userIndependentMagnitudeCount" -> 0,
     "invalidRequiredPositions" -> {}, "invalidUserPositions" -> {}, "invalidLoopPositions" -> {},
     "missingQuadraticRows" -> {}, "extraQuadraticRows" -> {}|>,
   "capabilities" -> <|"initializationUsableQ" -> True, "timeIBPUsableQ" -> True, "momentumIBPUsableQ" -> True,
     "derivativeUsableQ" -> True, "inverseKinematicsUsableQ" -> True|>, "issues" -> {}|>,
 "capabilities" -> <|"initializationUsableQ" -> True, "timeIBPUsableQ" -> True, "momentumIBPUsableQ" -> True,
   "derivativeUsableQ" -> True, "inverseKinematicsUsableQ" -> True, "parityUsableQ" -> True|>,
 "cycleLineIndices" -> {1, 2}, "bridgeLineIndices" -> {}, "selfLoopLineIndices" -> {}, "loopExternalMomenta" -> {k},
 "momentumDecompositionBasis" -> {q, k}, "fixedExternalVectorAtoms" -> {}, "effectiveLoopExternalMomenta" -> {k},
 "independentExternalMomenta" -> {}, "loopKinematicRules" -> {sp[k, k] -> ss11^2},
 "resolvedLoopKinematicRules" -> {sp[k, k] -> ss11^2}, "magnitudeKinematicRules" -> {},
 "resolvedMagnitudeKinematicRules" -> {}, "kinematicRules" -> Automatic,
 "kinematicCoordinateAudit" -> <|"status" -> "complete", "source" -> "default",
   "baseCoordinateData" -> {<|"baseIndex" -> 1, "kind" -> "loopExternalGram", "inputExpression" -> sp[k, k],
      "internalVariable" -> kk[1, 1], "defaultVariable" -> ss11, "defaultRHS" -> ss11^2|>},
   "baseCoordinateOrder" -> {sp[k, k]}, "baseCoordinateCount" -> 1, "defaultRules" -> {sp[k, k] -> ss11^2},
   "selectionTemplate" -> "kinematicRules" -> {sp[k, k] -> ss11^2}, "selectedRules" -> {sp[k, k] -> ss11^2},
   "selectedUserVariables" -> {ss11}, "userParameterOrder" -> {ss11}, "coordinateMatrix" -> {{1}},
   "coordinateRank" -> 1, "parameterJacobian" -> {{2*ss11}}, "parameterRank" -> 1, "missingDirections" -> {},
   "ruleMissingDirections" -> {}, "parameterMissingDirections" -> {}, "ruleMissingDirectionExpressions" -> {},
   "parameterMissingDirectionExpressions" -> {}, "ruleDependencies" -> {}, "ruleDependencyResiduals" -> {},
   "parameterDependencies" -> {}, "constraintResiduals" -> {}, "unsupportedRulePositions" -> {}, "completeQ" -> True,
   "overcompleteQ" -> False, "inverseAvailableQ" -> True, "resolvedRules" -> {sp[k, k] -> ss11^2},
   "baseSquaredUserExpressions" -> {ss11^2}, "baseRootUserExpressions" -> {ss11},
   "appearingNoLoopMagnitudeMomenta" -> {}, "independentNoLoopMagnitudeMomenta" -> {},
   "dependentMagnitudeBindings" -> {}, "rawLoopRules" -> {sp[k, k] -> ss11^2},
   "resolvedLoopRules" -> {sp[k, k] -> ss11^2}, "rawExternalLegRules" -> {}, "resolvedExternalLegRules" -> {},
   "message" -> "动力学变量完备，且当前简单坐标规则可反向转换。"|>, "ispData" -> {}, "nV" -> 2,
 "nE" -> 2, "nL" -> 1, "nK" -> 1, "bMatrix" -> {{1, 1}, {-1, -1}},
 "vertexLines" -> {{{1, 1}, {2, 1}}, {{1, -1}, {2, -1}}}, "loopCoeffMatrix" -> {{1}, {1}},
 "externalCoeffMatrix" -> {{0}, {-1}}, "externalPartList" -> {0, -k},
 "zeroPointRules" -> {a0[v1] -> 2*nu, a0[v2] -> 2*nu, b0[1] -> -2*nu, b0[2] -> -2*nu},
 "rootZeroPointRules" -> {a0[v1] -> 2*nu, a0[v2] -> 2*nu, b0[1] -> -2*nu, b0[2] -> -2*nu},
 "symmetryRules" -> {HoldPattern[int_J /; exampleParityZeroQ[int]] :> 0, HoldPattern[int_J /; exampleR2Q[int]] :>
    exampleR2ToR1[int], HoldPattern[int_J /; exampleTopQ[int]] :> exampleTopCanonical[int],
   HoldPattern[int_J /; exampleR1Q[int]] :> exampleR1Canonical[int]}, "parityConstraints" -> {},
 "sectorVertexRepresentativeMap" -> <|v1 -> v1, v2 -> v2|>,
 "sectorMetadata" -> <|"caseName" -> "018PureMassiveBubbleClosedLoopMinusMinus", "sectorShrunkLines" -> {},
   "sectorKey" -> "top", "aSlotMode" -> "compactActiveSlots", "sectorVertexRepresentativeMap" ->
    <|v1 -> v1, v2 -> v2|>, "vertexIdToOriginalASlot" -> <|v1 -> 1, v2 -> 2|>,
   "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 2|>, "vertexSlots" ->
    {<|"slot" -> 1, "vertexId" -> v1, "representativeVertexId" -> v1, "aSymbol" -> a[v1], "activeQ" -> True,
      "fixedValue" -> None, "compactASlot" -> 1|>, <|"slot" -> 2, "vertexId" -> v2, "representativeVertexId" -> v2,
      "aSymbol" -> a[v2], "activeQ" -> True, "fixedValue" -> None, "compactASlot" -> 2|>},
   "compactASlots" -> {<|"compactSlot" -> 1, "representativeVertexId" -> v1, "originalVertexIds" -> {v1},
      "originalSlots" -> {1}, "aSymbol" -> a[v1]|>, <|"compactSlot" -> 2, "representativeVertexId" -> v2,
      "originalVertexIds" -> {v2}, "originalSlots" -> {2}, "aSymbol" -> a[v2]|>}, "activeASlots" -> {1, 2},
   "lineSlots" -> {<|"slot" -> 1, "lineId" -> 1, "packType" -> "massiveFull", "massType" -> "massive",
      "state" -> "full", "endpoints" -> {v1, v2}, "originalEndpoints" -> {v1, v2},
      "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
       Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, "endpointCompactASlots" -> {1, 2},
      "linePowerMode" -> "indexed", "bPosition" -> 1, "bSymbol" -> b[1], "nPositions" -> {2, 3},
      "packTemplate" -> {b[1], n[1, 1], n[1, 2]}, "rootLinePosition" -> 1, "powerSlotKind" -> "cycle",
      "shrunkQ" -> False|>, <|"slot" -> 2, "lineId" -> 2, "packType" -> "massiveFull", "massType" -> "massive",
      "state" -> "full", "endpoints" -> {v1, v2}, "originalEndpoints" -> {v1, v2},
      "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
       Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, "endpointCompactASlots" -> {1, 2},
      "linePowerMode" -> "indexed", "bPosition" -> 1, "bSymbol" -> b[2], "nPositions" -> {2, 3},
      "packTemplate" -> {b[2], n[2, 1], n[2, 2]}, "rootLinePosition" -> 2, "powerSlotKind" -> "cycle",
      "shrunkQ" -> False|>}, "lineIdToSlot" -> <|1 -> 1, 2 -> 2|>, "bSymbolToLineSlot" -> <|b[1] -> 1, b[2] -> 2|>,
   "ispSlots" -> {}, "rootLineCount" -> 2, "rootLineOrder" -> {1, 2}, "ibpMode" -> "full",
   "sectorPattern" -> {<|"powerKind" -> "cycle", "state" -> "full"|>, <|"powerKind" -> "cycle", "state" -> "full"|>},
   "sectorBits" -> Missing["NotTimeOnlyBitString"], "sectorKeySchema" -> <|"type" -> "legacyContractedLineList",
     "storageType" -> "String"|>, "timeOnlyStateSlots" -> {}, "timeOnlyStateCount" -> 0,
   "publicIntegralRepresentation" -> "J[aList,linePacks,ispList]", "sectorPrefactorData" ->
    <|"lineIndices" -> {}, "parameterKeys" -> {}, "parameterList" -> {}, "powerList" -> {}, "powerParts" -> {},
     "kEIndices" -> {}, "kEMomenta" -> {}, "kEParameterExpressions" -> {}, "kEPower" -> kEpower[],
     "residualPowerParts" -> {}, "contractionParts" -> {}, "constantPrefactor" -> 1,
     "normalizationConvention" -> "structuralKEPowerAndContact-v1"|>, "builtInRelationData" -> {},
   "parityData" -> <|"status" -> "disabled", "reason" -> "noParityConstraints", "parityUsableQ" -> True,
     "constraints" -> {}|>, "representation" -> "J[aList,linePacks,ispList]"|>,
 "sectorMetadataList" -> {<|"caseName" -> "018PureMassiveBubbleClosedLoopMinusMinus", "sectorShrunkLines" -> {},
    "sectorKey" -> "top", "aSlotMode" -> "compactActiveSlots", "sectorVertexRepresentativeMap" ->
     <|v1 -> v1, v2 -> v2|>, "vertexIdToOriginalASlot" -> <|v1 -> 1, v2 -> 2|>,
    "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 2|>, "vertexSlots" ->
     {<|"slot" -> 1, "vertexId" -> v1, "representativeVertexId" -> v1, "aSymbol" -> a[v1], "activeQ" -> True,
       "fixedValue" -> None, "compactASlot" -> 1|>, <|"slot" -> 2, "vertexId" -> v2, "representativeVertexId" -> v2,
       "aSymbol" -> a[v2], "activeQ" -> True, "fixedValue" -> None, "compactASlot" -> 2|>},
    "compactASlots" -> {<|"compactSlot" -> 1, "representativeVertexId" -> v1, "originalVertexIds" -> {v1},
       "originalSlots" -> {1}, "aSymbol" -> a[v1]|>, <|"compactSlot" -> 2, "representativeVertexId" -> v2,
       "originalVertexIds" -> {v2}, "originalSlots" -> {2}, "aSymbol" -> a[v2]|>}, "activeASlots" -> {1, 2},
    "lineSlots" -> {<|"slot" -> 1, "lineId" -> 1, "packType" -> "massiveFull", "massType" -> "massive",
       "state" -> "full", "endpoints" -> {v1, v2}, "originalEndpoints" -> {v1, v2},
       "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, "endpointCompactASlots" -> {1, 2},
       "linePowerMode" -> "indexed", "bPosition" -> 1, "bSymbol" -> b[1], "nPositions" -> {2, 3},
       "packTemplate" -> {b[1], n[1, 1], n[1, 2]}, "rootLinePosition" -> 1, "powerSlotKind" -> "cycle",
       "shrunkQ" -> False|>, <|"slot" -> 2, "lineId" -> 2, "packType" -> "massiveFull", "massType" -> "massive",
       "state" -> "full", "endpoints" -> {v1, v2}, "originalEndpoints" -> {v1, v2},
       "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, "endpointCompactASlots" -> {1, 2},
       "linePowerMode" -> "indexed", "bPosition" -> 1, "bSymbol" -> b[2], "nPositions" -> {2, 3},
       "packTemplate" -> {b[2], n[2, 1], n[2, 2]}, "rootLinePosition" -> 2, "powerSlotKind" -> "cycle",
       "shrunkQ" -> False|>}, "lineIdToSlot" -> <|1 -> 1, 2 -> 2|>, "bSymbolToLineSlot" -> <|b[1] -> 1, b[2] -> 2|>,
    "ispSlots" -> {}, "rootLineCount" -> 2, "rootLineOrder" -> {1, 2}, "ibpMode" -> "full",
    "sectorPattern" -> {<|"powerKind" -> "cycle", "state" -> "full"|>, <|"powerKind" -> "cycle", "state" -> "full"|>},
    "sectorBits" -> Missing["NotTimeOnlyBitString"], "sectorKeySchema" -> <|"type" -> "legacyContractedLineList",
      "storageType" -> "String"|>, "timeOnlyStateSlots" -> {}, "timeOnlyStateCount" -> 0,
    "publicIntegralRepresentation" -> "J[aList,linePacks,ispList]", "sectorPrefactorData" ->
     <|"lineIndices" -> {}, "parameterKeys" -> {}, "parameterList" -> {}, "powerList" -> {}, "powerParts" -> {},
      "kEIndices" -> {}, "kEMomenta" -> {}, "kEParameterExpressions" -> {}, "kEPower" -> kEpower[],
      "residualPowerParts" -> {}, "contractionParts" -> {}, "constantPrefactor" -> 1,
      "normalizationConvention" -> "structuralKEPowerAndContact-v1"|>, "builtInRelationData" -> {},
    "parityData" -> <|"status" -> "disabled", "reason" -> "noParityConstraints", "parityUsableQ" -> True,
      "constraints" -> {}|>, "representation" -> "J[aList,linePacks,ispList]"|>,
   <|"caseName" -> "018PureMassiveBubbleClosedLoopMinusMinus_sector_e1", "sectorShrunkLines" -> {1},
    "sectorKey" -> "e1", "aSlotMode" -> "compactActiveSlots", "sectorVertexRepresentativeMap" ->
     <|v1 -> v1, v2 -> v1|>, "vertexIdToOriginalASlot" -> <|v1 -> 1, v2 -> 2|>,
    "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 1|>, "vertexSlots" ->
     {<|"slot" -> 1, "vertexId" -> v1, "representativeVertexId" -> v1, "aSymbol" -> a[v1], "activeQ" -> True,
       "fixedValue" -> None, "compactASlot" -> 1|>, <|"slot" -> 2, "vertexId" -> v2, "representativeVertexId" -> v1,
       "aSymbol" -> a[v2], "activeQ" -> False, "fixedValue" -> 0, "compactASlot" -> 1|>},
    "compactASlots" -> {<|"compactSlot" -> 1, "representativeVertexId" -> v1, "originalVertexIds" -> {v1, v2},
       "originalSlots" -> {1, 2}, "aSymbol" -> a[v1]|>}, "activeASlots" -> {1},
    "lineSlots" -> {<|"slot" -> 1, "lineId" -> 1, "packType" -> "shrunk", "massType" -> "massive", "state" -> "shrunk",
       "endpoints" -> {v1, v1}, "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" ->
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> Missing["NotApplicable"],
       "endpointOriginalASlots" -> {1, 2}, "endpointCompactASlots" -> {1, 1}, "linePowerMode" -> "indexed",
       "bPosition" -> 1, "bSymbol" -> bS[1], "nPositions" -> {}, "packTemplate" -> {bS[1]}, "rootLinePosition" -> 1,
       "powerSlotKind" -> "cycle", "shrunkQ" -> True|>, <|"slot" -> 2, "lineId" -> 2, "packType" -> "massiveFull",
       "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v1}, "originalEndpoints" -> {v1, v2},
       "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, "endpointCompactASlots" -> {1, 1},
       "linePowerMode" -> "indexed", "bPosition" -> 1, "bSymbol" -> b[2], "nPositions" -> {2, 3},
       "packTemplate" -> {b[2], n[2, 1], n[2, 2]}, "rootLinePosition" -> 2, "powerSlotKind" -> "cycle",
       "shrunkQ" -> False|>}, "lineIdToSlot" -> <|1 -> 1, 2 -> 2|>, "bSymbolToLineSlot" -> <|bS[1] -> 1, b[2] -> 2|>,
    "ispSlots" -> {}, "rootLineCount" -> 2, "rootLineOrder" -> {1, 2}, "ibpMode" -> "full",
    "sectorPattern" -> {<|"powerKind" -> "cycle", "state" -> "shrunk"|>, <|"powerKind" -> "cycle",
       "state" -> "full"|>}, "sectorBits" -> Missing["NotTimeOnlyBitString"],
    "sectorKeySchema" -> <|"type" -> "legacyContractedLineList", "storageType" -> "String"|>,
    "timeOnlyStateSlots" -> {}, "timeOnlyStateCount" -> 0, "publicIntegralRepresentation" ->
     "J[aList,linePacks,ispList]", "sectorPrefactorData" -> <|"lineIndices" -> {}, "parameterKeys" -> {},
      "parameterList" -> {}, "powerList" -> {}, "powerParts" -> {}, "kEIndices" -> {}, "kEMomenta" -> {},
      "kEParameterExpressions" -> {}, "kEPower" -> kEpower[], "residualPowerParts" -> {},
      "contractionParts" -> {<|"lineIndex" -> 1, "lineId" -> 1, "normalizationFactor" -> ((4*I)*E^(Pi*Im[nu]))/Pi|>},
      "constantPrefactor" -> ((4*I)*E^(Pi*Im[nu]))/Pi, "normalizationConvention" -> "structuralKEPowerAndContact-v1"|>,
    "builtInRelationData" -> {}, "parityData" -> <|"status" -> "disabled", "reason" -> "noParityConstraints",
      "parityUsableQ" -> True, "constraints" -> {}|>, "representation" -> "J[aList,linePacks,ispList]"|>,
   <|"caseName" -> "018PureMassiveBubbleClosedLoopMinusMinus_sector_e2", "sectorShrunkLines" -> {2},
    "sectorKey" -> "e2", "aSlotMode" -> "compactActiveSlots", "sectorVertexRepresentativeMap" ->
     <|v1 -> v1, v2 -> v1|>, "vertexIdToOriginalASlot" -> <|v1 -> 1, v2 -> 2|>,
    "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 1|>, "vertexSlots" ->
     {<|"slot" -> 1, "vertexId" -> v1, "representativeVertexId" -> v1, "aSymbol" -> a[v1], "activeQ" -> True,
       "fixedValue" -> None, "compactASlot" -> 1|>, <|"slot" -> 2, "vertexId" -> v2, "representativeVertexId" -> v1,
       "aSymbol" -> a[v2], "activeQ" -> False, "fixedValue" -> 0, "compactASlot" -> 1|>},
    "compactASlots" -> {<|"compactSlot" -> 1, "representativeVertexId" -> v1, "originalVertexIds" -> {v1, v2},
       "originalSlots" -> {1, 2}, "aSymbol" -> a[v1]|>}, "activeASlots" -> {1},
    "lineSlots" -> {<|"slot" -> 1, "lineId" -> 1, "packType" -> "massiveFull", "massType" -> "massive",
       "state" -> "full", "endpoints" -> {v1, v1}, "originalEndpoints" -> {v1, v2},
       "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, "endpointCompactASlots" -> {1, 1},
       "linePowerMode" -> "indexed", "bPosition" -> 1, "bSymbol" -> b[1], "nPositions" -> {2, 3},
       "packTemplate" -> {b[1], n[1, 1], n[1, 2]}, "rootLinePosition" -> 1, "powerSlotKind" -> "cycle",
       "shrunkQ" -> False|>, <|"slot" -> 2, "lineId" -> 2, "packType" -> "shrunk", "massType" -> "massive",
       "state" -> "shrunk", "endpoints" -> {v1, v1}, "originalEndpoints" -> {v1, v2},
       "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, "endpointCompactASlots" -> {1, 1},
       "linePowerMode" -> "indexed", "bPosition" -> 1, "bSymbol" -> bS[2], "nPositions" -> {},
       "packTemplate" -> {bS[2]}, "rootLinePosition" -> 2, "powerSlotKind" -> "cycle", "shrunkQ" -> True|>},
    "lineIdToSlot" -> <|1 -> 1, 2 -> 2|>, "bSymbolToLineSlot" -> <|b[1] -> 1, bS[2] -> 2|>, "ispSlots" -> {},
    "rootLineCount" -> 2, "rootLineOrder" -> {1, 2}, "ibpMode" -> "full",
    "sectorPattern" -> {<|"powerKind" -> "cycle", "state" -> "full"|>, <|"powerKind" -> "cycle",
       "state" -> "shrunk"|>}, "sectorBits" -> Missing["NotTimeOnlyBitString"],
    "sectorKeySchema" -> <|"type" -> "legacyContractedLineList", "storageType" -> "String"|>,
    "timeOnlyStateSlots" -> {}, "timeOnlyStateCount" -> 0, "publicIntegralRepresentation" ->
     "J[aList,linePacks,ispList]", "sectorPrefactorData" -> <|"lineIndices" -> {}, "parameterKeys" -> {},
      "parameterList" -> {}, "powerList" -> {}, "powerParts" -> {}, "kEIndices" -> {}, "kEMomenta" -> {},
      "kEParameterExpressions" -> {}, "kEPower" -> kEpower[], "residualPowerParts" -> {},
      "contractionParts" -> {<|"lineIndex" -> 2, "lineId" -> 2, "normalizationFactor" -> ((4*I)*E^(Pi*Im[nu]))/Pi|>},
      "constantPrefactor" -> ((4*I)*E^(Pi*Im[nu]))/Pi, "normalizationConvention" -> "structuralKEPowerAndContact-v1"|>,
    "builtInRelationData" -> {}, "parityData" -> <|"status" -> "disabled", "reason" -> "noParityConstraints",
      "parityUsableQ" -> True, "constraints" -> {}|>, "representation" -> "J[aList,linePacks,ispList]"|>},
 "indexMaps" -> <|"vertexIdToOriginalASlot" -> <|v1 -> 1, v2 -> 2|>, "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 2|>,
   "lineIdToSlot" -> <|1 -> 1, 2 -> 2|>, "bSymbolToLineSlot" -> <|b[1] -> 1, b[2] -> 2|>,
   "compactASlots" -> {<|"compactSlot" -> 1, "representativeVertexId" -> v1, "originalVertexIds" -> {v1},
      "originalSlots" -> {1}, "aSymbol" -> a[v1]|>, <|"compactSlot" -> 2, "representativeVertexId" -> v2,
      "originalVertexIds" -> {v2}, "originalSlots" -> {2}, "aSymbol" -> a[v2]|>},
   "lineSlots" -> {<|"slot" -> 1, "lineId" -> 1, "packType" -> "massiveFull", "massType" -> "massive",
      "state" -> "full", "endpoints" -> {v1, v2}, "originalEndpoints" -> {v1, v2},
      "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
       Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, "endpointCompactASlots" -> {1, 2},
      "linePowerMode" -> "indexed", "bPosition" -> 1, "bSymbol" -> b[1], "nPositions" -> {2, 3},
      "packTemplate" -> {b[1], n[1, 1], n[1, 2]}, "rootLinePosition" -> 1, "powerSlotKind" -> "cycle",
      "shrunkQ" -> False|>, <|"slot" -> 2, "lineId" -> 2, "packType" -> "massiveFull", "massType" -> "massive",
      "state" -> "full", "endpoints" -> {v1, v2}, "originalEndpoints" -> {v1, v2},
      "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
       Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, "endpointCompactASlots" -> {1, 2},
      "linePowerMode" -> "indexed", "bPosition" -> 1, "bSymbol" -> b[2], "nPositions" -> {2, 3},
      "packTemplate" -> {b[2], n[2, 1], n[2, 2]}, "rootLinePosition" -> 2, "powerSlotKind" -> "cycle",
      "shrunkQ" -> False|>}, "ispSlots" -> {}|>,
 "seedSummary" -> <|"continuousVariables" -> {a[v1], a[v2], b[1], b[2]},
   "discreteVariables" -> {n[1, 1], n[1, 2], n[2, 1], n[2, 2]}, "discreteStateCount" -> 16,
   "momentumGeneratorCount" -> 2, "timeGeneratorCount" -> 2, "loopKinematicNamingReport" ->
    <|"effectiveLoopExternalMomenta" -> {k}, "resolvedLoopKinematicRules" -> {sp[k, k] -> ss11^2},
     "internalExternalInvariantRules" -> {kk[1, 1] -> ss11^2}, "coordinateData" ->
      {<|"internalVariable" -> kk[1, 1], "publicExpression" -> ss11^2, "userVariable" -> ss11,
        "coordinateType" -> "squareRoot", "internalCoordinateExpression" -> Sqrt[kk[1, 1]],
        "internalJacobian" -> 2*Sqrt[kk[1, 1]], "userJacobian" -> 2*ss11|>}, "defaultNamingConvention" ->
      "ssij = Sqrt[sp[k_i,k_j]], where i<=j follows loopExternalMomenta order",
     "message" ->
      "loopExternalMomenta 是用户显式给出的 loop 标量积外向量基；内部仍用 kk[i,j]=sp[k_i,k_j]，018 公开缺省坐标为 ssij。"\
|>, "externalLegEnergyNamingReport" -> <|"convention" -> "loop external roots use ssij; the independent basis of \
actually appearing no-loop momentum magnitudes uses sEe variables and dependent magnitudes keep explicit bindings; \
unrelated scalar phase parameters remain explicit user symbols", "rawExternalLegEnergies" -> <|v1 -> P0, v2 -> P0|>,
     "internalExternalLegEnergies" -> <|v1 -> P0, v2 -> P0|>, "userExternalLegEnergies" -> <|v1 -> P0, v2 -> P0|>,
     "dependencyData" -> <|v1 -> <|"internalExternalInvariantVariables" -> {}, "externalInvariantVariables" -> {},
         "internalIndependentExternalLegEnergyParameters" -> {P0}, "independentExternalLegEnergyParameters" -> {P0},
         "usesExternalInvariantQ" -> False, "usesIndependentExternalLegEnergyQ" -> True,
         "kind" -> "independentExternalLegEnergyParameter"|>, v2 -> <|"internalExternalInvariantVariables" -> {},
         "externalInvariantVariables" -> {}, "internalIndependentExternalLegEnergyParameters" -> {P0},
         "independentExternalLegEnergyParameters" -> {P0}, "usesExternalInvariantQ" -> False,
         "usesIndependentExternalLegEnergyQ" -> True, "kind" -> "independentExternalLegEnergyParameter"|>|>,
     "magnitudeKinematicNamingReport" -> <|"independentExternalMomenta" -> {}, "appearingMagnitudeMomenta" -> {},
       "independentMagnitudeMomenta" -> {}, "dependentMagnitudeBindings" -> {}, "resolvedMagnitudeKinematicRules" ->
        {}, "coordinateData" -> {}, "defaultNamingConvention" -> "sE1,sE2,... follow the first-occurrence independent \
basis of no-loop momentum magnitudes in lines, vertices.externalLegEnergy and extLegs",
       "automaticCrossProducts" -> False, "entersLoopIBPGenerators" -> False, "entersISPClosure" -> False|>,
     "message" -> "vertices.externalLegEnergy 可使用 loop-external Gram 根号或 independentExternalMomenta 声明的无圈模长；022 \
不自动生成无圈动量之间的交叉点积。无圈动量变量不进入 loop IBP/ISP。"|>|>,
 "validationReport" -> <|"status" -> "ok", "errorCount" -> 0, "warningCount" -> 0, "pendingCount" -> 0,
   "pendingFeatures" -> {}, "issues" -> {}|>, "tadpoleSymmetryData" ->
  <|"status" -> "generated", "loopReversalData" -> {}, "massiveFullLineIndices" -> {}, "masslessFullLineIndices" -> {},
   "automaticRuleCount" -> 1, "automaticRules" ->
    {HoldPattern[dSIBP`Private`int$_J /; dSIBP`Private`tadpoleOddISPIntegralQ[
         <|"name" -> "018PureMassiveBubbleClosedLoopMinusMinus", "vertices" ->
           {<|"id" -> v1, "vertexType" -> "-", "externalLegEnergy" -> P0|>, <|"id" -> v2, "vertexType" -> "-",
             "externalLegEnergy" -> P0|>}, "vertexIds" -> {v1, v2}, "vertexSignAssoc" -> <|v1 -> "-", v2 -> "-"|>,
          "lines" -> {<|"id" -> 1, "massType" -> "massive", "endpoints" -> {v1, v2}, "momentum" -> q, "nu" -> nu,
             "skType" -> "--", "state" -> "full", "thetaConvention" -> "mergedTwoTheta", "packType" -> "massiveFull",
             "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
              Missing["NotApplicable"], "functionSystem" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x, "P" ->
                (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu])*
                  dSIBP`Private`x^(-1 - 2*nu))/Pi, "WT" -> Automatic, "shrinkBShift" -> 1, "shrinkZeroPointShift" ->
                2*nu|>, "compiledFunctionSystem" -> <|"status" -> "compiled", "input" -> <|"preset" -> "h",
                 "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
                 "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi, "WT" -> Automatic, "shrinkBShift" -> 1,
                 "shrinkZeroPointShift" -> 2*nu|>, "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu)/dSIBP`Private`x,
               "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi, "A0" ->
                {{0, 1}, {-1, -((1 + 2*nu)/dSIBP`Private`x)}}, "AT" -> {{0, 1}, {-1, -((1 + 2*nu)/dSIBP`Private`x)}},
               "WT" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi, "derivativeTerms" ->
                {<|"sourceState" -> 0, "targetState" -> 1, "xPower" -> 0, "coefficient" -> 1|>, <|"sourceState" -> 1,
                  "targetState" -> 0, "xPower" -> 0, "coefficient" -> -1|>, <|"sourceState" -> 1, "targetState" -> 1,
                  "xPower" -> -1, "coefficient" -> -1 - 2*nu|>}, "shrinkTerms" -> {<|"coefficient" ->
                   ((4*I)*E^(Pi*Im[nu]))/Pi, "xPower" -> -1 - 2*nu, "bShift" -> 1, "zeroPointShift" -> 2*nu|>},
               "shrinkZeroPointShift" -> 2*nu|>, "rawMomentum" -> q, "loopLineQ" -> True, "bridgeQ" -> False,
             "linePowerMode" -> "indexed"|>, <|"id" -> 2, "massType" -> "massive", "endpoints" -> {v1, v2},
             "momentum" -> -k + q, "nu" -> nu, "skType" -> "--", "state" -> "full", "thetaConvention" ->
              "mergedTwoTheta", "packType" -> "massiveFull", "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"],
             "masslessN1OppositeEndpoint" -> Missing["NotApplicable"], "functionSystem" -> <|"preset" -> "h",
               "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
               "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi, "WT" -> Automatic, "shrinkBShift" ->
                1, "shrinkZeroPointShift" -> 2*nu|>, "compiledFunctionSystem" -> <|"status" -> "compiled", "input" ->
                <|"preset" -> "h", "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1,
                 "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi,
                 "WT" -> Automatic, "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 2*nu|>, "variable" ->
                dSIBP`Private`x, "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, "W" ->
                ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi, "A0" -> {{0, 1},
                 {-1, -((1 + 2*nu)/dSIBP`Private`x)}}, "AT" -> {{0, 1}, {-1, -((1 + 2*nu)/dSIBP`Private`x)}}, "WT" ->
                ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi, "derivativeTerms" ->
                {<|"sourceState" -> 0, "targetState" -> 1, "xPower" -> 0, "coefficient" -> 1|>, <|"sourceState" -> 1,
                  "targetState" -> 0, "xPower" -> 0, "coefficient" -> -1|>, <|"sourceState" -> 1, "targetState" -> 1,
                  "xPower" -> -1, "coefficient" -> -1 - 2*nu|>}, "shrinkTerms" -> {<|"coefficient" ->
                   ((4*I)*E^(Pi*Im[nu]))/Pi, "xPower" -> -1 - 2*nu, "bShift" -> 1, "zeroPointShift" -> 2*nu|>},
               "shrinkZeroPointShift" -> 2*nu|>, "rawMomentum" -> -k + q, "loopLineQ" -> True, "bridgeQ" -> False,
             "linePowerMode" -> "indexed"|>}, "extLegs" -> {}, "sectorExternalLegEnergyByVertex" ->
           <|v1 -> P0, v2 -> P0|>, "activeVertexIds" -> {v1, v2}, "fixedAVertexValues" -> <||>, "loopMomenta" -> {q},
          "ibpMode" -> "full", "graphLoopCount" -> 1, "graphTopologyAudit" -> <|"status" -> "valid",
            "vertexCount" -> 2, "inputLineCount" -> 2, "internalLineCount" -> 2, "activeLineIndices" -> {1, 2},
            "shrunkLineIndices" -> {}, "connectedComponentCount" -> 1, "graphLoopCount" -> 1,
            "bridgeLineIndices" -> {}, "cycleLineIndices" -> {1, 2}, "selfLoopLineIndices" -> {},
            "incidenceMatrix" -> {{1, 1}, {-1, -1}}, "cycleSpaceDimension" -> 1, "issues" -> {}|>,
          "loopMomentumRoutingAudit" -> <|"status" -> "valid", "ibpMode" -> "full", "loopMomenta" -> {q},
            "loopCoefficientMatrix" -> {{1}, {1}}, "loopCoefficientRank" -> 1, "lineExternalResiduals" -> {0, -k},
            "referenceLineIndices" -> {1}, "referenceLoopMatrix" -> {{1}}, "referenceExternalResiduals" -> {0},
            "shiftInvariantLineResiduals" -> {0, -k}, "incidenceCycleResidual" -> {{0}, {0}}, "issues" -> {}|>,
          "normalizedLineMomenta" -> {q, -k + q}, "momentumDeclarationAudit" -> <|"status" -> "exact",
            "ibpMode" -> "full", "loopExternalMomenta" -> {k}, "independentExternalMomenta" -> {},
            "requiredLoopExternalDirections" -> {-k}, "requiredIndependentMomentumMagnitudes" -> {},
            "momentumAtoms" -> {k}, "loopExternalAudit" -> <|"status" -> "exact", "atoms" -> {k},
              "requiredExpressions" -> {-k}, "userExpressions" -> {k}, "requiredBasisDirections" -> {k},
              "userBasisDirections" -> {k}, "missingDirections" -> {}, "extraDirections" -> {},
              "userDependencyVectors" -> {}, "requiredRank" -> 1, "userRank" -> 1, "unionRank" -> 1,
              "invalidRequiredPositions" -> {}, "invalidUserPositions" -> {}|>, "independentExternalAudit" ->
             <|"status" -> "exact", "atoms" -> {k}, "loopGramRank" -> 1, "requiredMomenta" -> {}, "userMomenta" -> {},
              "missingMagnitudeSquares" -> {}, "extraMagnitudeSquares" -> {}, "redundantUserPositions" -> {},
              "redundantUserMomenta" -> {}, "quadraticDependencyOrder" -> {"loopGram1"}, "quadraticDependencies" -> {},
              "requiredIndependentMagnitudeCount" -> 0, "userIndependentMagnitudeCount" -> 0,
              "invalidRequiredPositions" -> {}, "invalidUserPositions" -> {}, "invalidLoopPositions" -> {},
              "missingQuadraticRows" -> {}, "extraQuadraticRows" -> {}|>, "capabilities" ->
             <|"initializationUsableQ" -> True, "timeIBPUsableQ" -> True, "momentumIBPUsableQ" -> True,
              "derivativeUsableQ" -> True, "inverseKinematicsUsableQ" -> True|>, "issues" -> {}|>,
          "capabilities" -> <|"initializationUsableQ" -> True, "timeIBPUsableQ" -> True, "momentumIBPUsableQ" -> True,
            "derivativeUsableQ" -> True, "inverseKinematicsUsableQ" -> True|>, "cycleLineIndices" -> {1, 2},
          "bridgeLineIndices" -> {}, "selfLoopLineIndices" -> {}, "loopExternalMomenta" -> {k},
          "momentumDecompositionBasis" -> {q, k}, "fixedExternalVectorAtoms" -> {}, "effectiveLoopExternalMomenta" ->
           {k}, "independentExternalMomenta" -> {}, "loopKinematicRules" -> {sp[k, k] -> ss11^2},
          "resolvedLoopKinematicRules" -> {sp[k, k] -> ss11^2}, "magnitudeKinematicRules" -> {},
          "resolvedMagnitudeKinematicRules" -> {}, "kinematicRules" -> Automatic, "kinematicCoordinateAudit" ->
           <|"status" -> "complete", "source" -> "default", "baseCoordinateData" ->
             {<|"baseIndex" -> 1, "kind" -> "loopExternalGram", "inputExpression" -> sp[k, k], "internalVariable" ->
                kk[1, 1], "defaultVariable" -> ss11, "defaultRHS" -> ss11^2|>}, "baseCoordinateOrder" -> {sp[k, k]},
            "baseCoordinateCount" -> 1, "defaultRules" -> {sp[k, k] -> ss11^2}, "selectionTemplate" ->
             "kinematicRules" -> {sp[k, k] -> ss11^2}, "selectedRules" -> {sp[k, k] -> ss11^2},
            "selectedUserVariables" -> {ss11}, "userParameterOrder" -> {ss11}, "coordinateMatrix" -> {{1}},
            "coordinateRank" -> 1, "parameterJacobian" -> {{2*ss11}}, "parameterRank" -> 1, "missingDirections" -> {},
            "ruleMissingDirections" -> {}, "parameterMissingDirections" -> {}, "ruleMissingDirectionExpressions" -> {},
            "parameterMissingDirectionExpressions" -> {}, "ruleDependencies" -> {}, "ruleDependencyResiduals" -> {},
            "parameterDependencies" -> {}, "constraintResiduals" -> {}, "unsupportedRulePositions" -> {},
            "completeQ" -> True, "overcompleteQ" -> False, "inverseAvailableQ" -> True, "resolvedRules" ->
             {sp[k, k] -> ss11^2}, "baseSquaredUserExpressions" -> {ss11^2}, "baseRootUserExpressions" -> {ss11},
            "appearingNoLoopMagnitudeMomenta" -> {}, "independentNoLoopMagnitudeMomenta" -> {},
            "dependentMagnitudeBindings" -> {}, "rawLoopRules" -> {sp[k, k] -> ss11^2}, "resolvedLoopRules" ->
             {sp[k, k] -> ss11^2}, "rawExternalLegRules" -> {}, "resolvedExternalLegRules" -> {},
            "message" -> "动力学变量完备，且当前简单坐标规则可反向转换。"|>, "ispData" -> {},
          "nV" -> 2, "nE" -> 2, "nL" -> 1, "nK" -> 1, "bMatrix" -> {{1, 1}, {-1, -1}},
          "vertexLines" -> {{{1, 1}, {2, 1}}, {{1, -1}, {2, -1}}}, "loopCoeffMatrix" -> {{1}, {1}},
          "externalCoeffMatrix" -> {{0}, {-1}}, "externalPartList" -> {0, -k}, "zeroPointRules" ->
           {a0[v1] -> 2*nu, a0[v2] -> 2*nu, b0[1] -> -2*nu, b0[2] -> -2*nu}, "rootZeroPointRules" ->
           {a0[v1] -> 2*nu, a0[v2] -> 2*nu, b0[1] -> -2*nu, b0[2] -> -2*nu}, "symmetryRules" ->
           {HoldPattern[int_J /; exampleParityZeroQ[int]] :> 0, HoldPattern[int_J /; exampleR2Q[int]] :>
             exampleR2ToR1[int], HoldPattern[int_J /; exampleTopQ[int]] :> exampleTopCanonical[int],
            HoldPattern[int_J /; exampleR1Q[int]] :> exampleR1Canonical[int]}, "parityConstraints" -> {},
          "sectorVertexRepresentativeMap" -> <|v1 -> v1, v2 -> v2|>|>, dSIBP`Private`int$]] :> 0},
   "userRuleCount" -> 4, "effectiveRuleCount" -> 5|>, "effectiveSymmetryRules" ->
  {HoldPattern[dSIBP`Private`int$_J /; dSIBP`Private`tadpoleOddISPIntegralQ[
       <|"name" -> "018PureMassiveBubbleClosedLoopMinusMinus", "vertices" ->
         {<|"id" -> v1, "vertexType" -> "-", "externalLegEnergy" -> P0|>, <|"id" -> v2, "vertexType" -> "-",
           "externalLegEnergy" -> P0|>}, "vertexIds" -> {v1, v2}, "vertexSignAssoc" -> <|v1 -> "-", v2 -> "-"|>,
        "lines" -> {<|"id" -> 1, "massType" -> "massive", "endpoints" -> {v1, v2}, "momentum" -> q, "nu" -> nu,
           "skType" -> "--", "state" -> "full", "thetaConvention" -> "mergedTwoTheta", "packType" -> "massiveFull",
           "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
            Missing["NotApplicable"], "functionSystem" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x,
             "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
             "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi, "WT" -> Automatic, "shrinkBShift" -> 1,
             "shrinkZeroPointShift" -> 2*nu|>, "compiledFunctionSystem" -> <|"status" -> "compiled",
             "input" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" ->
                1, "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi, "WT" ->
                Automatic, "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 2*nu|>, "variable" -> dSIBP`Private`x,
             "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
             "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi, "A0" -> {{0, 1}, {-1,
                -((1 + 2*nu)/dSIBP`Private`x)}}, "AT" -> {{0, 1}, {-1, -((1 + 2*nu)/dSIBP`Private`x)}},
             "WT" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi, "derivativeTerms" ->
              {<|"sourceState" -> 0, "targetState" -> 1, "xPower" -> 0, "coefficient" -> 1|>, <|"sourceState" -> 1,
                "targetState" -> 0, "xPower" -> 0, "coefficient" -> -1|>, <|"sourceState" -> 1, "targetState" -> 1,
                "xPower" -> -1, "coefficient" -> -1 - 2*nu|>}, "shrinkTerms" -> {<|"coefficient" ->
                 ((4*I)*E^(Pi*Im[nu]))/Pi, "xPower" -> -1 - 2*nu, "bShift" -> 1, "zeroPointShift" -> 2*nu|>},
             "shrinkZeroPointShift" -> 2*nu|>, "rawMomentum" -> q, "loopLineQ" -> True, "bridgeQ" -> False,
           "linePowerMode" -> "indexed"|>, <|"id" -> 2, "massType" -> "massive", "endpoints" -> {v1, v2},
           "momentum" -> -k + q, "nu" -> nu, "skType" -> "--", "state" -> "full", "thetaConvention" ->
            "mergedTwoTheta", "packType" -> "massiveFull", "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"],
           "masslessN1OppositeEndpoint" -> Missing["NotApplicable"], "functionSystem" ->
            <|"preset" -> "h", "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1,
             "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi, "WT" -> Automatic,
             "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 2*nu|>, "compiledFunctionSystem" ->
            <|"status" -> "compiled", "input" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x, "P" ->
                (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu])*
                  dSIBP`Private`x^(-1 - 2*nu))/Pi, "WT" -> Automatic, "shrinkBShift" -> 1, "shrinkZeroPointShift" ->
                2*nu|>, "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1,
             "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi,
             "A0" -> {{0, 1}, {-1, -((1 + 2*nu)/dSIBP`Private`x)}}, "AT" -> {{0, 1}, {-1,
                -((1 + 2*nu)/dSIBP`Private`x)}}, "WT" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi,
             "derivativeTerms" -> {<|"sourceState" -> 0, "targetState" -> 1, "xPower" -> 0, "coefficient" -> 1|>, <|
                "sourceState" -> 1, "targetState" -> 0, "xPower" -> 0, "coefficient" -> -1|>, <|"sourceState" -> 1,
                "targetState" -> 1, "xPower" -> -1, "coefficient" -> -1 - 2*nu|>}, "shrinkTerms" ->
              {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu]))/Pi, "xPower" -> -1 - 2*nu, "bShift" -> 1, "zeroPointShift" ->
                 2*nu|>}, "shrinkZeroPointShift" -> 2*nu|>, "rawMomentum" -> -k + q, "loopLineQ" -> True,
           "bridgeQ" -> False, "linePowerMode" -> "indexed"|>}, "extLegs" -> {}, "sectorExternalLegEnergyByVertex" ->
         <|v1 -> P0, v2 -> P0|>, "activeVertexIds" -> {v1, v2}, "fixedAVertexValues" -> <||>, "loopMomenta" -> {q},
        "ibpMode" -> "full", "graphLoopCount" -> 1, "graphTopologyAudit" -> <|"status" -> "valid", "vertexCount" -> 2,
          "inputLineCount" -> 2, "internalLineCount" -> 2, "activeLineIndices" -> {1, 2}, "shrunkLineIndices" -> {},
          "connectedComponentCount" -> 1, "graphLoopCount" -> 1, "bridgeLineIndices" -> {},
          "cycleLineIndices" -> {1, 2}, "selfLoopLineIndices" -> {}, "incidenceMatrix" -> {{1, 1}, {-1, -1}},
          "cycleSpaceDimension" -> 1, "issues" -> {}|>, "loopMomentumRoutingAudit" ->
         <|"status" -> "valid", "ibpMode" -> "full", "loopMomenta" -> {q}, "loopCoefficientMatrix" -> {{1}, {1}},
          "loopCoefficientRank" -> 1, "lineExternalResiduals" -> {0, -k}, "referenceLineIndices" -> {1},
          "referenceLoopMatrix" -> {{1}}, "referenceExternalResiduals" -> {0}, "shiftInvariantLineResiduals" ->
           {0, -k}, "incidenceCycleResidual" -> {{0}, {0}}, "issues" -> {}|>, "normalizedLineMomenta" -> {q, -k + q},
        "momentumDeclarationAudit" -> <|"status" -> "exact", "ibpMode" -> "full", "loopExternalMomenta" -> {k},
          "independentExternalMomenta" -> {}, "requiredLoopExternalDirections" -> {-k},
          "requiredIndependentMomentumMagnitudes" -> {}, "momentumAtoms" -> {k}, "loopExternalAudit" ->
           <|"status" -> "exact", "atoms" -> {k}, "requiredExpressions" -> {-k}, "userExpressions" -> {k},
            "requiredBasisDirections" -> {k}, "userBasisDirections" -> {k}, "missingDirections" -> {},
            "extraDirections" -> {}, "userDependencyVectors" -> {}, "requiredRank" -> 1, "userRank" -> 1,
            "unionRank" -> 1, "invalidRequiredPositions" -> {}, "invalidUserPositions" -> {}|>,
          "independentExternalAudit" -> <|"status" -> "exact", "atoms" -> {k}, "loopGramRank" -> 1,
            "requiredMomenta" -> {}, "userMomenta" -> {}, "missingMagnitudeSquares" -> {}, "extraMagnitudeSquares" ->
             {}, "redundantUserPositions" -> {}, "redundantUserMomenta" -> {}, "quadraticDependencyOrder" ->
             {"loopGram1"}, "quadraticDependencies" -> {}, "requiredIndependentMagnitudeCount" -> 0,
            "userIndependentMagnitudeCount" -> 0, "invalidRequiredPositions" -> {}, "invalidUserPositions" -> {},
            "invalidLoopPositions" -> {}, "missingQuadraticRows" -> {}, "extraQuadraticRows" -> {}|>,
          "capabilities" -> <|"initializationUsableQ" -> True, "timeIBPUsableQ" -> True, "momentumIBPUsableQ" -> True,
            "derivativeUsableQ" -> True, "inverseKinematicsUsableQ" -> True|>, "issues" -> {}|>,
        "capabilities" -> <|"initializationUsableQ" -> True, "timeIBPUsableQ" -> True, "momentumIBPUsableQ" -> True,
          "derivativeUsableQ" -> True, "inverseKinematicsUsableQ" -> True|>, "cycleLineIndices" -> {1, 2},
        "bridgeLineIndices" -> {}, "selfLoopLineIndices" -> {}, "loopExternalMomenta" -> {k},
        "momentumDecompositionBasis" -> {q, k}, "fixedExternalVectorAtoms" -> {}, "effectiveLoopExternalMomenta" ->
         {k}, "independentExternalMomenta" -> {}, "loopKinematicRules" -> {sp[k, k] -> ss11^2},
        "resolvedLoopKinematicRules" -> {sp[k, k] -> ss11^2}, "magnitudeKinematicRules" -> {},
        "resolvedMagnitudeKinematicRules" -> {}, "kinematicRules" -> Automatic, "kinematicCoordinateAudit" ->
         <|"status" -> "complete", "source" -> "default", "baseCoordinateData" ->
           {<|"baseIndex" -> 1, "kind" -> "loopExternalGram", "inputExpression" -> sp[k, k],
             "internalVariable" -> kk[1, 1], "defaultVariable" -> ss11, "defaultRHS" -> ss11^2|>},
          "baseCoordinateOrder" -> {sp[k, k]}, "baseCoordinateCount" -> 1, "defaultRules" -> {sp[k, k] -> ss11^2},
          "selectionTemplate" -> "kinematicRules" -> {sp[k, k] -> ss11^2}, "selectedRules" -> {sp[k, k] -> ss11^2},
          "selectedUserVariables" -> {ss11}, "userParameterOrder" -> {ss11}, "coordinateMatrix" -> {{1}},
          "coordinateRank" -> 1, "parameterJacobian" -> {{2*ss11}}, "parameterRank" -> 1, "missingDirections" -> {},
          "ruleMissingDirections" -> {}, "parameterMissingDirections" -> {}, "ruleMissingDirectionExpressions" -> {},
          "parameterMissingDirectionExpressions" -> {}, "ruleDependencies" -> {}, "ruleDependencyResiduals" -> {},
          "parameterDependencies" -> {}, "constraintResiduals" -> {}, "unsupportedRulePositions" -> {},
          "completeQ" -> True, "overcompleteQ" -> False, "inverseAvailableQ" -> True,
          "resolvedRules" -> {sp[k, k] -> ss11^2}, "baseSquaredUserExpressions" -> {ss11^2},
          "baseRootUserExpressions" -> {ss11}, "appearingNoLoopMagnitudeMomenta" -> {},
          "independentNoLoopMagnitudeMomenta" -> {}, "dependentMagnitudeBindings" -> {},
          "rawLoopRules" -> {sp[k, k] -> ss11^2}, "resolvedLoopRules" -> {sp[k, k] -> ss11^2},
          "rawExternalLegRules" -> {}, "resolvedExternalLegRules" -> {}, "message" ->
           "动力学变量完备，且当前简单坐标规则可反向转换。"|>, "ispData" -> {}, "nV" -> 2,
        "nE" -> 2, "nL" -> 1, "nK" -> 1, "bMatrix" -> {{1, 1}, {-1, -1}}, "vertexLines" ->
         {{{1, 1}, {2, 1}}, {{1, -1}, {2, -1}}}, "loopCoeffMatrix" -> {{1}, {1}}, "externalCoeffMatrix" -> {{0}, {-1}},
        "externalPartList" -> {0, -k}, "zeroPointRules" -> {a0[v1] -> 2*nu, a0[v2] -> 2*nu, b0[1] -> -2*nu,
          b0[2] -> -2*nu}, "rootZeroPointRules" -> {a0[v1] -> 2*nu, a0[v2] -> 2*nu, b0[1] -> -2*nu, b0[2] -> -2*nu},
        "symmetryRules" -> {HoldPattern[int_J /; exampleParityZeroQ[int]] :> 0,
          HoldPattern[int_J /; exampleR2Q[int]] :> exampleR2ToR1[int], HoldPattern[int_J /; exampleTopQ[int]] :>
           exampleTopCanonical[int], HoldPattern[int_J /; exampleR1Q[int]] :> exampleR1Canonical[int]},
        "parityConstraints" -> {}, "sectorVertexRepresentativeMap" -> <|v1 -> v1, v2 -> v2|>|>, dSIBP`Private`int$]] :>
    0, HoldPattern[int_J /; exampleParityZeroQ[int]] :> 0, HoldPattern[int_J /; exampleR2Q[int]] :> exampleR2ToR1[int],
   HoldPattern[int_J /; exampleTopQ[int]] :> exampleTopCanonical[int], HoldPattern[int_J /; exampleR1Q[int]] :>
    exampleR1Canonical[int]}, "masslessBundleCandidates" -> {}, "masslessEndpointConventions" -> {},
 "precomputedShrinkSectorSummary" -> <|"status" -> "generated", "completeCoverageQ" -> True|>,
 "precomputedShrinkSectorKeys" -> {"top", "e1", "e2"}|>
