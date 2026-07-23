<|"name" -> "016TreeTwoVertexPlusPlus", "vertexData" -> {{v1, "+"}, {v2, "+"}}, "vertexIds" -> {v1, v2},
 "vertexSignAssoc" -> <|v1 -> "+", v2 -> "+"|>,
 "lines" -> {<|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> p12, "treeEnergy" -> k12, "nu" -> nu12,
    "bbType" -> "h", "massType" -> "massive", "skType" -> "++", "state" -> "full",
    "thetaConvention" -> "mergedTwoTheta", "packType" -> "massiveFull", "masslessN1ReferenceEndpoint" ->
     Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> Missing["NotApplicable"],
    "functionSystem" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu12)/dSIBP`Private`x,
      "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu12])*dSIBP`Private`x^(-1 - 2*nu12))/Pi,
      "WT" -> Automatic, "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 2*nu12|>,
    "compiledFunctionSystem" -> <|"status" -> "compiled", "input" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x,
        "P" -> (1 + 2*nu12)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
        "W" -> ((-4*I)*E^(Pi*Im[nu12])*dSIBP`Private`x^(-1 - 2*nu12))/Pi, "WT" -> Automatic, "shrinkBShift" -> 1,
        "shrinkZeroPointShift" -> 2*nu12|>, "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu12)/dSIBP`Private`x,
      "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu12])*dSIBP`Private`x^(-1 - 2*nu12))/Pi,
      "A0" -> {{0, 1}, {-1, -((1 + 2*nu12)/dSIBP`Private`x)}}, "AT" -> {{0, 1}, {-1, -((1 + 2*nu12)/dSIBP`Private`x)}},
      "WT" -> ((-4*I)*E^(Pi*Im[nu12])*dSIBP`Private`x^(-1 - 2*nu12))/Pi, "derivativeTerms" ->
       {<|"sourceState" -> 0, "targetState" -> 1, "xPower" -> 0, "coefficient" -> 1|>,
        <|"sourceState" -> 1, "targetState" -> 0, "xPower" -> 0, "coefficient" -> -1|>,
        <|"sourceState" -> 1, "targetState" -> 1, "xPower" -> -1, "coefficient" -> -1 - 2*nu12|>},
      "shrinkTerms" -> {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu12]))/Pi, "xPower" -> -1 - 2*nu12, "bShift" -> 1,
         "zeroPointShift" -> 2*nu12|>}, "shrinkZeroPointShift" -> 2*nu12|>, "rawMomentum" -> p12, "loopLineQ" -> False,
    "bridgeQ" -> True, "linePowerMode" -> "fixedCoefficient"|>}, "extLegs" -> {},
 "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>, "activeVertexIds" -> {v1, v2}, "fixedAVertexValues" -> <||>,
 "loopMomenta" -> {}, "ibpMode" -> "timeOnly", "graphLoopCount" -> 0,
 "graphTopologyAudit" -> <|"status" -> "valid", "vertexCount" -> 2, "inputLineCount" -> 1, "internalLineCount" -> 1,
   "activeLineIndices" -> {1}, "shrunkLineIndices" -> {}, "connectedComponentCount" -> 1, "graphLoopCount" -> 0,
   "bridgeLineIndices" -> {1}, "cycleLineIndices" -> {}, "selfLoopLineIndices" -> {}, "incidenceMatrix" -> {{1}, {-1}},
   "cycleSpaceDimension" -> 0, "issues" -> {}|>, "loopMomentumRoutingAudit" ->
  <|"status" -> "valid", "ibpMode" -> "timeOnly", "loopMomenta" -> {}, "loopCoefficientMatrix" -> {{}},
   "loopCoefficientRank" -> 0, "lineExternalResiduals" -> {p12}, "referenceLineIndices" -> {},
   "referenceLoopMatrix" -> {}, "referenceExternalResiduals" -> {}, "shiftInvariantLineResiduals" -> {p12},
   "incidenceCycleResidual" -> {}, "issues" -> {}|>, "normalizedLineMomenta" -> {p12},
 "momentumDeclarationAudit" -> <|"status" -> "exact", "ibpMode" -> "timeOnly", "loopExternalMomenta" -> {},
   "independentExternalMomenta" -> {p12}, "requiredLoopExternalDirections" -> {},
   "requiredIndependentMomentumMagnitudes" -> {-p12}, "momentumAtoms" -> {p12},
   "loopExternalAudit" -> <|"status" -> "notRequired", "requiredExpressions" -> {}, "userExpressions" -> {},
     "missingDirections" -> {}, "extraDirections" -> {}, "requiredRank" -> 0, "userRank" -> 0|>,
   "independentExternalAudit" -> <|"status" -> "exact", "atoms" -> {p12}, "loopGramRank" -> 0,
     "requiredMomenta" -> {-p12}, "userMomenta" -> {p12}, "missingMagnitudeSquares" -> {},
     "extraMagnitudeSquares" -> {}, "redundantUserPositions" -> {}, "redundantUserMomenta" -> {},
     "quadraticDependencyOrder" -> {"userMagnitude1"}, "quadraticDependencies" -> {},
     "requiredIndependentMagnitudeCount" -> 1, "userIndependentMagnitudeCount" -> 1, "invalidRequiredPositions" -> {},
     "invalidUserPositions" -> {}, "invalidLoopPositions" -> {}, "missingQuadraticRows" -> {},
     "extraQuadraticRows" -> {}|>, "capabilities" -> <|"initializationUsableQ" -> True, "timeIBPUsableQ" -> True,
     "momentumIBPUsableQ" -> False, "derivativeUsableQ" -> True, "inverseKinematicsUsableQ" -> True|>,
   "issues" -> {}|>, "capabilities" -> <|"initializationUsableQ" -> True, "timeIBPUsableQ" -> True,
   "momentumIBPUsableQ" -> False, "derivativeUsableQ" -> True, "inverseKinematicsUsableQ" -> True|>,
 "cycleLineIndices" -> {}, "bridgeLineIndices" -> {1}, "loopExternalMomenta" -> {},
 "effectiveLoopExternalMomenta" -> {}, "independentExternalMomenta" -> {p12}, "momentumDecompositionBasis" -> {p12},
 "fixedExternalVectorAtoms" -> {p12}, "externalMomenta" -> {}, "externalLegMomenta" -> {p12},
 "rawExternalInvariantRules" -> {}, "externalInvariantRules" -> {},
 "rawExternalLegInvariantRules" -> {sp[p12, p12] -> sE1^2}, "externalLegInvariantRules" -> {sp[p12, p12] -> sE1^2},
 "kinematicRules" -> Automatic, "kinematicCoordinateAudit" -> <|"status" -> "complete", "source" -> "default",
   "baseCoordinateData" -> {<|"occurrenceIndex" -> 1, "momentum" -> p12, "squaredExpression" -> sp[p12, p12],
      "magnitudeExpression" -> Sqrt[sp[p12, p12]], "gramVector" -> {1}, "baseCoefficients" -> {1},
      "independentQ" -> True, "externalLegIndex" -> 1, "userVariable" -> sE1, "defaultSquaredExpression" -> sE1^2,
      "baseIndex" -> 1, "kind" -> "externalLegMagnitude", "inputExpression" -> sp[p12, p12],
      "internalVariable" -> dSIBP`Private`externalLegSquaredCoordinate[1], "defaultVariable" -> sE1,
      "defaultRHS" -> sE1^2|>}, "baseCoordinateOrder" -> {sp[p12, p12]}, "baseCoordinateCount" -> 1,
   "defaultRules" -> {sp[p12, p12] -> sE1^2}, "selectionTemplate" -> "kinematicRules" -> {sp[p12, p12] -> sE1^2},
   "selectedRules" -> {sp[p12, p12] -> sE1^2}, "selectedUserVariables" -> {sE1}, "userParameterOrder" -> {sE1},
   "coordinateMatrix" -> {{1}}, "coordinateRank" -> 1, "parameterJacobian" -> {{2*sE1}}, "parameterRank" -> 1,
   "missingDirections" -> {}, "ruleMissingDirections" -> {}, "parameterMissingDirections" -> {},
   "ruleMissingDirectionExpressions" -> {}, "parameterMissingDirectionExpressions" -> {}, "ruleDependencies" -> {},
   "ruleDependencyResiduals" -> {}, "parameterDependencies" -> {}, "constraintResiduals" -> {},
   "unsupportedRulePositions" -> {}, "completeQ" -> True, "overcompleteQ" -> False, "inverseAvailableQ" -> True,
   "resolvedRules" -> {sp[p12, p12] -> sE1^2}, "baseSquaredUserExpressions" -> {sE1^2},
   "baseRootUserExpressions" -> {sE1}, "appearingNoLoopMagnitudeMomenta" -> {p12},
   "independentNoLoopMagnitudeMomenta" -> {p12}, "dependentMagnitudeBindings" -> {}, "rawLoopRules" -> {},
   "resolvedLoopRules" -> {}, "rawExternalLegRules" -> {sp[p12, p12] -> sE1^2},
   "resolvedExternalLegRules" -> {sp[p12, p12] -> sE1^2},
   "message" -> "动力学变量完备，且当前简单坐标规则可反向转换。"|>, "ispData" -> {}, "nV" -> 2,
 "nE" -> 1, "nL" -> 0, "nK" -> 0, "bMatrix" -> {{1}, {-1}}, "vertexLines" -> {{{1, 1}}, {{1, -1}}},
 "loopCoeffMatrix" -> {{}}, "externalCoeffMatrix" -> {{}}, "externalPartList" -> {p12}, "rawNumericRules" -> {},
 "numericRules" -> {}, "sampleDiscreteRules" -> {}, "seedPreset" -> "quickCheck",
 "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0}, "sampleOnly" -> True|>, "generatorSeedRanges" -> {},
 "seedOptions" -> <|"DiscreteMode" -> "sample", "MaxSeedRuleCount" -> 200, "MaxDiscreteRuleCount" -> 64,
   "MaxEquationCount" -> 80, "MaxShrinkSectorDepth" -> Automatic, "MaxShrinkSectorCount" -> 16|>,
 "unknownSeedPreset" -> None, "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta12},
 "shrinkPrefactorRules" -> {E^(Pi*Im[nu12]) -> eta12}, "symmetryRules" -> {}, "thetaBoundarySignOffset" -> Automatic,
 "kiraOrdering" -> <||>, "sectorVertexRepresentativeMap" -> <|v1 -> v1, v2 -> v2|>,
 "sectorMetadata" -> <|"caseName" -> "016TreeTwoVertexPlusPlus", "sectorShrunkLines" -> {}, "sectorKey" -> "top",
   "aSlotMode" -> "compactActiveSlots", "sectorVertexRepresentativeMap" -> <|v1 -> v1, v2 -> v2|>,
   "vertexIdToOriginalASlot" -> <|v1 -> 1, v2 -> 2|>, "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 2|>,
   "vertexSlots" -> {<|"slot" -> 1, "vertexId" -> v1, "representativeVertexId" -> v1, "aSymbol" -> a[v1],
      "activeQ" -> True, "fixedValue" -> None, "compactASlot" -> 1|>, <|"slot" -> 2, "vertexId" -> v2,
      "representativeVertexId" -> v2, "aSymbol" -> a[v2], "activeQ" -> True, "fixedValue" -> None,
      "compactASlot" -> 2|>}, "compactASlots" -> {<|"compactSlot" -> 1, "representativeVertexId" -> v1,
      "originalVertexIds" -> {v1}, "originalSlots" -> {1}, "aSymbol" -> a[v1]|>,
     <|"compactSlot" -> 2, "representativeVertexId" -> v2, "originalVertexIds" -> {v2}, "originalSlots" -> {2},
      "aSymbol" -> a[v2]|>}, "activeASlots" -> {1, 2},
   "lineSlots" -> {<|"slot" -> 1, "lineId" -> 1, "packType" -> "massiveFull", "massType" -> "massive",
      "state" -> "full", "endpoints" -> {v1, v2}, "originalEndpoints" -> {v1, v2},
      "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
       Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, "endpointCompactASlots" -> {1, 2},
      "linePowerMode" -> "fixedCoefficient", "bPosition" -> Missing["FixedLinePower"], "bSymbol" -> None,
      "nPositions" -> {1, 2}, "packTemplate" -> {n[1, 1], n[1, 2]}|>}, "lineIdToSlot" -> <|1 -> 1|>,
   "bSymbolToLineSlot" -> <||>, "ispSlots" -> {}|>, "sectorMetadataList" ->
  {<|"caseName" -> "016TreeTwoVertexPlusPlus", "sectorShrunkLines" -> {}, "sectorKey" -> "top",
    "aSlotMode" -> "compactActiveSlots", "sectorVertexRepresentativeMap" -> <|v1 -> v1, v2 -> v2|>,
    "vertexIdToOriginalASlot" -> <|v1 -> 1, v2 -> 2|>, "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 2|>,
    "vertexSlots" -> {<|"slot" -> 1, "vertexId" -> v1, "representativeVertexId" -> v1, "aSymbol" -> a[v1],
       "activeQ" -> True, "fixedValue" -> None, "compactASlot" -> 1|>, <|"slot" -> 2, "vertexId" -> v2,
       "representativeVertexId" -> v2, "aSymbol" -> a[v2], "activeQ" -> True, "fixedValue" -> None,
       "compactASlot" -> 2|>}, "compactASlots" -> {<|"compactSlot" -> 1, "representativeVertexId" -> v1,
       "originalVertexIds" -> {v1}, "originalSlots" -> {1}, "aSymbol" -> a[v1]|>,
      <|"compactSlot" -> 2, "representativeVertexId" -> v2, "originalVertexIds" -> {v2}, "originalSlots" -> {2},
       "aSymbol" -> a[v2]|>}, "activeASlots" -> {1, 2},
    "lineSlots" -> {<|"slot" -> 1, "lineId" -> 1, "packType" -> "massiveFull", "massType" -> "massive",
       "state" -> "full", "endpoints" -> {v1, v2}, "originalEndpoints" -> {v1, v2},
       "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, "endpointCompactASlots" -> {1, 2},
       "linePowerMode" -> "fixedCoefficient", "bPosition" -> Missing["FixedLinePower"], "bSymbol" -> None,
       "nPositions" -> {1, 2}, "packTemplate" -> {n[1, 1], n[1, 2]}|>}, "lineIdToSlot" -> <|1 -> 1|>,
    "bSymbolToLineSlot" -> <||>, "ispSlots" -> {}|>, <|"caseName" -> "016TreeTwoVertexPlusPlus_sector_e1",
    "sectorShrunkLines" -> {1}, "sectorKey" -> "e1", "aSlotMode" -> "compactActiveSlots",
    "sectorVertexRepresentativeMap" -> <|v1 -> v1, v2 -> v1|>, "vertexIdToOriginalASlot" -> <|v1 -> 1, v2 -> 2|>,
    "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 1|>, "vertexSlots" ->
     {<|"slot" -> 1, "vertexId" -> v1, "representativeVertexId" -> v1, "aSymbol" -> a[v1], "activeQ" -> True,
       "fixedValue" -> None, "compactASlot" -> 1|>, <|"slot" -> 2, "vertexId" -> v2, "representativeVertexId" -> v1,
       "aSymbol" -> a[v2], "activeQ" -> False, "fixedValue" -> 0, "compactASlot" -> 1|>},
    "compactASlots" -> {<|"compactSlot" -> 1, "representativeVertexId" -> v1, "originalVertexIds" -> {v1, v2},
       "originalSlots" -> {1, 2}, "aSymbol" -> a[v1]|>}, "activeASlots" -> {1},
    "lineSlots" -> {<|"slot" -> 1, "lineId" -> 1, "packType" -> "shrunk", "massType" -> "massive", "state" -> "shrunk",
       "endpoints" -> {v1, v1}, "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" ->
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> Missing["NotApplicable"],
       "endpointOriginalASlots" -> {1, 2}, "endpointCompactASlots" -> {1, 1}, "linePowerMode" -> "fixedCoefficient",
       "bPosition" -> Missing["FixedLinePower"], "bSymbol" -> None, "nPositions" -> {}, "packTemplate" -> {}|>},
    "lineIdToSlot" -> <|1 -> 1|>, "bSymbolToLineSlot" -> <||>, "ispSlots" -> {}|>},
 "indexMaps" -> <|"vertexIdToOriginalASlot" -> <|v1 -> 1, v2 -> 2|>, "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 2|>,
   "lineIdToSlot" -> <|1 -> 1|>, "bSymbolToLineSlot" -> <||>,
   "compactASlots" -> {<|"compactSlot" -> 1, "representativeVertexId" -> v1, "originalVertexIds" -> {v1},
      "originalSlots" -> {1}, "aSymbol" -> a[v1]|>, <|"compactSlot" -> 2, "representativeVertexId" -> v2,
      "originalVertexIds" -> {v2}, "originalSlots" -> {2}, "aSymbol" -> a[v2]|>},
   "lineSlots" -> {<|"slot" -> 1, "lineId" -> 1, "packType" -> "massiveFull", "massType" -> "massive",
      "state" -> "full", "endpoints" -> {v1, v2}, "originalEndpoints" -> {v1, v2},
      "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
       Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, "endpointCompactASlots" -> {1, 2},
      "linePowerMode" -> "fixedCoefficient", "bPosition" -> Missing["FixedLinePower"], "bSymbol" -> None,
      "nPositions" -> {1, 2}, "packTemplate" -> {n[1, 1], n[1, 2]}|>}, "ispSlots" -> {}|>,
 "seedSummary" -> <|"continuousVariables" -> {a[v1], a[v2]}, "discreteVariables" -> {n[1, 1], n[1, 2]},
   "discreteStateCount" -> 4, "momentumGeneratorCount" -> 0, "timeGeneratorCount" -> 2,
   "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0}, "sampleOnly" -> True|>, "numericRules" -> {},
   "numericRuleRequirementReport" -> <|"providedNumericVariables" -> {}, "internalProvidedNumericVariables" -> {},
     "requiredExternalInvariants" -> {}, "internalRequiredExternalInvariants" -> {},
     "externalInvariantNamingReport" -> <|"externalMomenta" -> {}, "externalInvariantRules" -> {},
       "internalExternalInvariantRules" -> {}, "coordinateData" -> {}, "defaultNamingConvention" ->
        "ssij = Sqrt[sp[k_i,k_j]], where i<=j follows loopExternalMomenta order", "message" -> "loopExternalMomenta \
是用户显式给出的 loop 标量积外向量基；内部仍用 kk[i,j]=sp[k_i,k_j]，016 公开缺省坐标为 ssij。"\
|>, "externalLegInvariantNamingReport" -> <|"externalLegMomenta" -> {p12}, "appearingMagnitudeMomenta" -> {p12},
       "independentMagnitudeMomenta" -> {p12}, "dependentMagnitudeBindings" -> {},
       "externalLegInvariantRules" -> {sp[p12, p12] -> sE1^2}, "coordinateData" ->
        {<|"occurrenceIndex" -> 1, "momentum" -> p12, "squaredExpression" -> sp[p12, p12],
          "magnitudeExpression" -> Sqrt[sp[p12, p12]], "gramVector" -> {1}, "baseCoefficients" -> {1},
          "independentQ" -> True, "externalLegIndex" -> 1, "userVariable" -> sE1, "defaultSquaredExpression" -> sE1^2,
          "scalarProduct" -> sp[p12, p12], "publicExpression" -> sE1^2, "coordinateType" -> "externalLegSquareRoot",
          "userJacobian" -> 1|>}, "defaultNamingConvention" -> "sE1,sE2,... follow the first-occurrence independent \
basis of no-loop momentum magnitudes in lineData, vertexEnergies and extLegs", "automaticCrossProducts" -> False,
       "entersLoopIBPGenerators" -> False, "entersISPClosure" -> False|>, "vertexEnergyNamingReport" ->
      <|"convention" -> "loop external roots use ssij; the independent basis of actually appearing no-loop momentum \
magnitudes uses sEe variables and dependent magnitudes keep explicit bindings; unrelated scalar phase parameters remain \
explicit user symbols", "rawVertexEnergies" -> <|v1 -> E1, v2 -> E2|>, "internalVertexEnergies" ->
        <|v1 -> E1, v2 -> E2|>, "userVertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
       "dependencyData" -> <|v1 -> <|"internalExternalInvariantVariables" -> {}, "externalInvariantVariables" -> {},
           "internalIndependentVertexEnergyParameters" -> {E1}, "independentVertexEnergyParameters" -> {E1},
           "usesExternalInvariantQ" -> False, "usesIndependentVertexEnergyQ" -> True,
           "kind" -> "independentVertexEnergyParameter"|>, v2 -> <|"internalExternalInvariantVariables" -> {},
           "externalInvariantVariables" -> {}, "internalIndependentVertexEnergyParameters" -> {E2},
           "independentVertexEnergyParameters" -> {E2}, "usesExternalInvariantQ" -> False,
           "usesIndependentVertexEnergyQ" -> True, "kind" -> "independentVertexEnergyParameter"|>|>,
       "externalLegInvariantNamingReport" -> <|"externalLegMomenta" -> {p12}, "appearingMagnitudeMomenta" -> {p12},
         "independentMagnitudeMomenta" -> {p12}, "dependentMagnitudeBindings" -> {}, "externalLegInvariantRules" ->
          {sp[p12, p12] -> sE1^2}, "coordinateData" -> {<|"occurrenceIndex" -> 1, "momentum" -> p12,
            "squaredExpression" -> sp[p12, p12], "magnitudeExpression" -> Sqrt[sp[p12, p12]], "gramVector" -> {1},
            "baseCoefficients" -> {1}, "independentQ" -> True, "externalLegIndex" -> 1, "userVariable" -> sE1,
            "defaultSquaredExpression" -> sE1^2, "scalarProduct" -> sp[p12, p12], "publicExpression" -> sE1^2,
            "coordinateType" -> "externalLegSquareRoot", "userJacobian" -> 1|>}, "defaultNamingConvention" -> "sE1,sE2,\
... follow the first-occurrence independent basis of no-loop momentum magnitudes in lineData, vertexEnergies and \
extLegs", "automaticCrossProducts" -> False, "entersLoopIBPGenerators" -> False, "entersISPClosure" -> False|>,
       "message" -> "vertexEnergies 可使用 loop-external Gram 根号或 independentExternalMomenta 声明的无圈模长；016 \
不自动生成无圈动量之间的交叉点积。无圈动量变量不进入 loop IBP/ISP。"|>,
     "requiredVertexEnergies" -> {E1, E2}, "internalRequiredVertexEnergies" -> {E1, E2},
     "requiredLineParameters" -> {nu12}, "requiredNumericVariables" -> {E1, E2, nu12},
     "internalRequiredNumericVariables" -> {E1, E2, nu12}, "missingExternalInvariants" -> {},
     "internalMissingExternalInvariants" -> {}, "missingVertexEnergies" -> {E1, E2},
     "internalMissingVertexEnergies" -> {E1, E2}, "missingLineParameters" -> {nu12},
     "missingNumericVariables" -> {E1, E2, nu12}, "internalMissingNumericVariables" -> {E1, E2, nu12},
     "completeStaticNumericRulesQ" -> False|>, "externalInvariantNamingReport" ->
    <|"externalMomenta" -> {}, "externalInvariantRules" -> {}, "internalExternalInvariantRules" -> {},
     "coordinateData" -> {}, "defaultNamingConvention" ->
      "ssij = Sqrt[sp[k_i,k_j]], where i<=j follows loopExternalMomenta order",
     "message" ->
      "loopExternalMomenta 是用户显式给出的 loop 标量积外向量基；内部仍用 kk[i,j]=sp[k_i,k_j]，016 公开缺省坐标为 ssij。"\
|>, "vertexEnergyNamingReport" -> <|"convention" -> "loop external roots use ssij; the independent basis of actually \
appearing no-loop momentum magnitudes uses sEe variables and dependent magnitudes keep explicit bindings; unrelated \
scalar phase parameters remain explicit user symbols", "rawVertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
     "internalVertexEnergies" -> <|v1 -> E1, v2 -> E2|>, "userVertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
     "dependencyData" -> <|v1 -> <|"internalExternalInvariantVariables" -> {}, "externalInvariantVariables" -> {},
         "internalIndependentVertexEnergyParameters" -> {E1}, "independentVertexEnergyParameters" -> {E1},
         "usesExternalInvariantQ" -> False, "usesIndependentVertexEnergyQ" -> True,
         "kind" -> "independentVertexEnergyParameter"|>, v2 -> <|"internalExternalInvariantVariables" -> {},
         "externalInvariantVariables" -> {}, "internalIndependentVertexEnergyParameters" -> {E2},
         "independentVertexEnergyParameters" -> {E2}, "usesExternalInvariantQ" -> False,
         "usesIndependentVertexEnergyQ" -> True, "kind" -> "independentVertexEnergyParameter"|>|>,
     "externalLegInvariantNamingReport" -> <|"externalLegMomenta" -> {p12}, "appearingMagnitudeMomenta" -> {p12},
       "independentMagnitudeMomenta" -> {p12}, "dependentMagnitudeBindings" -> {},
       "externalLegInvariantRules" -> {sp[p12, p12] -> sE1^2}, "coordinateData" ->
        {<|"occurrenceIndex" -> 1, "momentum" -> p12, "squaredExpression" -> sp[p12, p12],
          "magnitudeExpression" -> Sqrt[sp[p12, p12]], "gramVector" -> {1}, "baseCoefficients" -> {1},
          "independentQ" -> True, "externalLegIndex" -> 1, "userVariable" -> sE1, "defaultSquaredExpression" -> sE1^2,
          "scalarProduct" -> sp[p12, p12], "publicExpression" -> sE1^2, "coordinateType" -> "externalLegSquareRoot",
          "userJacobian" -> 1|>}, "defaultNamingConvention" -> "sE1,sE2,... follow the first-occurrence independent \
basis of no-loop momentum magnitudes in lineData, vertexEnergies and extLegs", "automaticCrossProducts" -> False,
       "entersLoopIBPGenerators" -> False, "entersISPClosure" -> False|>, "message" -> "vertexEnergies 可使用 \
loop-external Gram 根号或 independentExternalMomenta 声明的无圈模长；016 不自动生成无圈动量之间的交叉点积。无圈动量变量不进入 loop IBP/ISP。"\
|>, "sampleDiscreteRules" -> {}|>, "validationReport" -> <|"status" -> "ok", "errorCount" -> 0, "warningCount" -> 3,
   "pendingCount" -> 0, "numericRuleRequirementReport" -> <|"providedNumericVariables" -> {},
     "internalProvidedNumericVariables" -> {}, "requiredExternalInvariants" -> {},
     "internalRequiredExternalInvariants" -> {}, "externalInvariantNamingReport" ->
      <|"externalMomenta" -> {}, "externalInvariantRules" -> {}, "internalExternalInvariantRules" -> {},
       "coordinateData" -> {}, "defaultNamingConvention" ->
        "ssij = Sqrt[sp[k_i,k_j]], where i<=j follows loopExternalMomenta order", "message" -> "loopExternalMomenta \
是用户显式给出的 loop 标量积外向量基；内部仍用 kk[i,j]=sp[k_i,k_j]，016 公开缺省坐标为 ssij。"\
|>, "externalLegInvariantNamingReport" -> <|"externalLegMomenta" -> {p12}, "appearingMagnitudeMomenta" -> {p12},
       "independentMagnitudeMomenta" -> {p12}, "dependentMagnitudeBindings" -> {},
       "externalLegInvariantRules" -> {sp[p12, p12] -> sE1^2}, "coordinateData" ->
        {<|"occurrenceIndex" -> 1, "momentum" -> p12, "squaredExpression" -> sp[p12, p12],
          "magnitudeExpression" -> Sqrt[sp[p12, p12]], "gramVector" -> {1}, "baseCoefficients" -> {1},
          "independentQ" -> True, "externalLegIndex" -> 1, "userVariable" -> sE1, "defaultSquaredExpression" -> sE1^2,
          "scalarProduct" -> sp[p12, p12], "publicExpression" -> sE1^2, "coordinateType" -> "externalLegSquareRoot",
          "userJacobian" -> 1|>}, "defaultNamingConvention" -> "sE1,sE2,... follow the first-occurrence independent \
basis of no-loop momentum magnitudes in lineData, vertexEnergies and extLegs", "automaticCrossProducts" -> False,
       "entersLoopIBPGenerators" -> False, "entersISPClosure" -> False|>, "vertexEnergyNamingReport" ->
      <|"convention" -> "loop external roots use ssij; the independent basis of actually appearing no-loop momentum \
magnitudes uses sEe variables and dependent magnitudes keep explicit bindings; unrelated scalar phase parameters remain \
explicit user symbols", "rawVertexEnergies" -> <|v1 -> E1, v2 -> E2|>, "internalVertexEnergies" ->
        <|v1 -> E1, v2 -> E2|>, "userVertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
       "dependencyData" -> <|v1 -> <|"internalExternalInvariantVariables" -> {}, "externalInvariantVariables" -> {},
           "internalIndependentVertexEnergyParameters" -> {E1}, "independentVertexEnergyParameters" -> {E1},
           "usesExternalInvariantQ" -> False, "usesIndependentVertexEnergyQ" -> True,
           "kind" -> "independentVertexEnergyParameter"|>, v2 -> <|"internalExternalInvariantVariables" -> {},
           "externalInvariantVariables" -> {}, "internalIndependentVertexEnergyParameters" -> {E2},
           "independentVertexEnergyParameters" -> {E2}, "usesExternalInvariantQ" -> False,
           "usesIndependentVertexEnergyQ" -> True, "kind" -> "independentVertexEnergyParameter"|>|>,
       "externalLegInvariantNamingReport" -> <|"externalLegMomenta" -> {p12}, "appearingMagnitudeMomenta" -> {p12},
         "independentMagnitudeMomenta" -> {p12}, "dependentMagnitudeBindings" -> {}, "externalLegInvariantRules" ->
          {sp[p12, p12] -> sE1^2}, "coordinateData" -> {<|"occurrenceIndex" -> 1, "momentum" -> p12,
            "squaredExpression" -> sp[p12, p12], "magnitudeExpression" -> Sqrt[sp[p12, p12]], "gramVector" -> {1},
            "baseCoefficients" -> {1}, "independentQ" -> True, "externalLegIndex" -> 1, "userVariable" -> sE1,
            "defaultSquaredExpression" -> sE1^2, "scalarProduct" -> sp[p12, p12], "publicExpression" -> sE1^2,
            "coordinateType" -> "externalLegSquareRoot", "userJacobian" -> 1|>}, "defaultNamingConvention" -> "sE1,sE2,\
... follow the first-occurrence independent basis of no-loop momentum magnitudes in lineData, vertexEnergies and \
extLegs", "automaticCrossProducts" -> False, "entersLoopIBPGenerators" -> False, "entersISPClosure" -> False|>,
       "message" -> "vertexEnergies 可使用 loop-external Gram 根号或 independentExternalMomenta 声明的无圈模长；016 \
不自动生成无圈动量之间的交叉点积。无圈动量变量不进入 loop IBP/ISP。"|>,
     "requiredVertexEnergies" -> {E1, E2}, "internalRequiredVertexEnergies" -> {E1, E2},
     "requiredLineParameters" -> {nu12}, "requiredNumericVariables" -> {E1, E2, nu12},
     "internalRequiredNumericVariables" -> {E1, E2, nu12}, "missingExternalInvariants" -> {},
     "internalMissingExternalInvariants" -> {}, "missingVertexEnergies" -> {E1, E2},
     "internalMissingVertexEnergies" -> {E1, E2}, "missingLineParameters" -> {nu12},
     "missingNumericVariables" -> {E1, E2, nu12}, "internalMissingNumericVariables" -> {E1, E2, nu12},
     "completeStaticNumericRulesQ" -> False|>, "pendingFeatures" -> {},
   "issues" -> {<|"severity" -> "warning", "code" -> "numericRulesMissingVertexEnergies",
      "missingVertexEnergies" -> {E1, E2}, "numericRules" -> {},
      "comment" ->
       "analytic seed can still be generated; numeric linear/Kira stages need vertex energy rules from time IBP"|>,
     <|"severity" -> "warning", "code" -> "numericRulesMissingLineParameters", "missingLineParameters" -> {nu12},
      "numericRules" -> {}, "comment" ->
       "analytic seed can still be generated; numeric linear/Kira stages need massive line parameter rules"|>,
     <|"severity" -> "warning", "code" -> "sampleDiscreteRulesMissingForDiscreteVariables",
      "missingVariables" -> {n[1, 1], n[1, 2]}, "comment" ->
       "sample seed mode needs complete n=0/1 rules; DiscreteMode -> all can enumerate them automatically"|>}|>,
 "numericRuleRequirementReport" -> <|"providedNumericVariables" -> {}, "internalProvidedNumericVariables" -> {},
   "requiredExternalInvariants" -> {}, "internalRequiredExternalInvariants" -> {},
   "externalInvariantNamingReport" -> <|"externalMomenta" -> {}, "externalInvariantRules" -> {},
     "internalExternalInvariantRules" -> {}, "coordinateData" -> {}, "defaultNamingConvention" ->
      "ssij = Sqrt[sp[k_i,k_j]], where i<=j follows loopExternalMomenta order",
     "message" ->
      "loopExternalMomenta 是用户显式给出的 loop 标量积外向量基；内部仍用 kk[i,j]=sp[k_i,k_j]，016 公开缺省坐标为 ssij。"\
|>, "externalLegInvariantNamingReport" -> <|"externalLegMomenta" -> {p12}, "appearingMagnitudeMomenta" -> {p12},
     "independentMagnitudeMomenta" -> {p12}, "dependentMagnitudeBindings" -> {},
     "externalLegInvariantRules" -> {sp[p12, p12] -> sE1^2}, "coordinateData" ->
      {<|"occurrenceIndex" -> 1, "momentum" -> p12, "squaredExpression" -> sp[p12, p12],
        "magnitudeExpression" -> Sqrt[sp[p12, p12]], "gramVector" -> {1}, "baseCoefficients" -> {1},
        "independentQ" -> True, "externalLegIndex" -> 1, "userVariable" -> sE1, "defaultSquaredExpression" -> sE1^2,
        "scalarProduct" -> sp[p12, p12], "publicExpression" -> sE1^2, "coordinateType" -> "externalLegSquareRoot",
        "userJacobian" -> 1|>}, "defaultNamingConvention" -> "sE1,sE2,... follow the first-occurrence independent basis \
of no-loop momentum magnitudes in lineData, vertexEnergies and extLegs", "automaticCrossProducts" -> False,
     "entersLoopIBPGenerators" -> False, "entersISPClosure" -> False|>, "vertexEnergyNamingReport" ->
    <|"convention" -> "loop external roots use ssij; the independent basis of actually appearing no-loop momentum \
magnitudes uses sEe variables and dependent magnitudes keep explicit bindings; unrelated scalar phase parameters remain \
explicit user symbols", "rawVertexEnergies" -> <|v1 -> E1, v2 -> E2|>, "internalVertexEnergies" ->
      <|v1 -> E1, v2 -> E2|>, "userVertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
     "dependencyData" -> <|v1 -> <|"internalExternalInvariantVariables" -> {}, "externalInvariantVariables" -> {},
         "internalIndependentVertexEnergyParameters" -> {E1}, "independentVertexEnergyParameters" -> {E1},
         "usesExternalInvariantQ" -> False, "usesIndependentVertexEnergyQ" -> True,
         "kind" -> "independentVertexEnergyParameter"|>, v2 -> <|"internalExternalInvariantVariables" -> {},
         "externalInvariantVariables" -> {}, "internalIndependentVertexEnergyParameters" -> {E2},
         "independentVertexEnergyParameters" -> {E2}, "usesExternalInvariantQ" -> False,
         "usesIndependentVertexEnergyQ" -> True, "kind" -> "independentVertexEnergyParameter"|>|>,
     "externalLegInvariantNamingReport" -> <|"externalLegMomenta" -> {p12}, "appearingMagnitudeMomenta" -> {p12},
       "independentMagnitudeMomenta" -> {p12}, "dependentMagnitudeBindings" -> {},
       "externalLegInvariantRules" -> {sp[p12, p12] -> sE1^2}, "coordinateData" ->
        {<|"occurrenceIndex" -> 1, "momentum" -> p12, "squaredExpression" -> sp[p12, p12],
          "magnitudeExpression" -> Sqrt[sp[p12, p12]], "gramVector" -> {1}, "baseCoefficients" -> {1},
          "independentQ" -> True, "externalLegIndex" -> 1, "userVariable" -> sE1, "defaultSquaredExpression" -> sE1^2,
          "scalarProduct" -> sp[p12, p12], "publicExpression" -> sE1^2, "coordinateType" -> "externalLegSquareRoot",
          "userJacobian" -> 1|>}, "defaultNamingConvention" -> "sE1,sE2,... follow the first-occurrence independent \
basis of no-loop momentum magnitudes in lineData, vertexEnergies and extLegs", "automaticCrossProducts" -> False,
       "entersLoopIBPGenerators" -> False, "entersISPClosure" -> False|>, "message" -> "vertexEnergies 可使用 \
loop-external Gram 根号或 independentExternalMomenta 声明的无圈模长；016 不自动生成无圈动量之间的交叉点积。无圈动量变量不进入 loop IBP/ISP。"\
|>, "requiredVertexEnergies" -> {E1, E2}, "internalRequiredVertexEnergies" -> {E1, E2},
   "requiredLineParameters" -> {nu12}, "requiredNumericVariables" -> {E1, E2, nu12},
   "internalRequiredNumericVariables" -> {E1, E2, nu12}, "missingExternalInvariants" -> {},
   "internalMissingExternalInvariants" -> {}, "missingVertexEnergies" -> {E1, E2},
   "internalMissingVertexEnergies" -> {E1, E2}, "missingLineParameters" -> {nu12},
   "missingNumericVariables" -> {E1, E2, nu12}, "internalMissingNumericVariables" -> {E1, E2, nu12},
   "completeStaticNumericRulesQ" -> False|>, "numericRuleTemplate" -> {E1 -> dSIBP`Private`numericValue[E1],
   E2 -> dSIBP`Private`numericValue[E2], nu12 -> dSIBP`Private`numericValue[nu12]},
 "tadpoleSymmetryData" -> <|"status" -> "generated", "loopReversalData" -> {}, "massiveFullLineIndices" -> {},
   "masslessFullLineIndices" -> {}, "automaticRuleCount" -> 1,
   "automaticRules" -> {HoldPattern[dSIBP`Private`int$_J /; dSIBP`Private`tadpoleOddISPIntegralQ[
         <|"name" -> "016TreeTwoVertexPlusPlus", "vertexData" -> {{v1, "+"}, {v2, "+"}}, "vertexIds" -> {v1, v2},
          "vertexSignAssoc" -> <|v1 -> "+", v2 -> "+"|>, "lines" -> {<|"id" -> 1, "endpoints" -> {v1, v2},
             "momentum" -> p12, "treeEnergy" -> k12, "nu" -> nu12, "bbType" -> "h", "massType" -> "massive",
             "skType" -> "++", "state" -> "full", "thetaConvention" -> "mergedTwoTheta", "packType" -> "massiveFull",
             "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
              Missing["NotApplicable"], "functionSystem" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x, "P" ->
                (1 + 2*nu12)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu12])*
                  dSIBP`Private`x^(-1 - 2*nu12))/Pi, "WT" -> Automatic, "shrinkBShift" -> 1, "shrinkZeroPointShift" ->
                2*nu12|>, "compiledFunctionSystem" -> <|"status" -> "compiled", "input" -> <|"preset" -> "h",
                 "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu12)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
                 "W" -> ((-4*I)*E^(Pi*Im[nu12])*dSIBP`Private`x^(-1 - 2*nu12))/Pi, "WT" -> Automatic,
                 "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 2*nu12|>, "variable" -> dSIBP`Private`x, "P" ->
                (1 + 2*nu12)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu12])*
                  dSIBP`Private`x^(-1 - 2*nu12))/Pi, "A0" -> {{0, 1}, {-1, -((1 + 2*nu12)/dSIBP`Private`x)}}, "AT" ->
                {{0, 1}, {-1, -((1 + 2*nu12)/dSIBP`Private`x)}}, "WT" -> ((-4*I)*E^(Pi*Im[nu12])*dSIBP`Private`x^
                   (-1 - 2*nu12))/Pi, "derivativeTerms" -> {<|"sourceState" -> 0, "targetState" -> 1, "xPower" -> 0,
                  "coefficient" -> 1|>, <|"sourceState" -> 1, "targetState" -> 0, "xPower" -> 0, "coefficient" -> -1|>,
                 <|"sourceState" -> 1, "targetState" -> 1, "xPower" -> -1, "coefficient" -> -1 - 2*nu12|>},
               "shrinkTerms" -> {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu12]))/Pi, "xPower" -> -1 - 2*nu12, "bShift" -> 1,
                  "zeroPointShift" -> 2*nu12|>}, "shrinkZeroPointShift" -> 2*nu12|>, "rawMomentum" -> p12,
             "loopLineQ" -> False, "bridgeQ" -> True, "linePowerMode" -> "fixedCoefficient"|>}, "extLegs" -> {},
          "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>, "activeVertexIds" -> {v1, v2}, "fixedAVertexValues" -> <||>,
          "loopMomenta" -> {}, "ibpMode" -> "timeOnly", "graphLoopCount" -> 0, "graphTopologyAudit" ->
           <|"status" -> "valid", "vertexCount" -> 2, "inputLineCount" -> 1, "internalLineCount" -> 1,
            "activeLineIndices" -> {1}, "shrunkLineIndices" -> {}, "connectedComponentCount" -> 1,
            "graphLoopCount" -> 0, "bridgeLineIndices" -> {1}, "cycleLineIndices" -> {}, "selfLoopLineIndices" -> {},
            "incidenceMatrix" -> {{1}, {-1}}, "cycleSpaceDimension" -> 0, "issues" -> {}|>,
          "loopMomentumRoutingAudit" -> <|"status" -> "valid", "ibpMode" -> "timeOnly", "loopMomenta" -> {},
            "loopCoefficientMatrix" -> {{}}, "loopCoefficientRank" -> 0, "lineExternalResiduals" -> {p12},
            "referenceLineIndices" -> {}, "referenceLoopMatrix" -> {}, "referenceExternalResiduals" -> {},
            "shiftInvariantLineResiduals" -> {p12}, "incidenceCycleResidual" -> {}, "issues" -> {}|>,
          "normalizedLineMomenta" -> {p12}, "momentumDeclarationAudit" -> <|"status" -> "exact",
            "ibpMode" -> "timeOnly", "loopExternalMomenta" -> {}, "independentExternalMomenta" -> {p12},
            "requiredLoopExternalDirections" -> {}, "requiredIndependentMomentumMagnitudes" -> {-p12},
            "momentumAtoms" -> {p12}, "loopExternalAudit" -> <|"status" -> "notRequired", "requiredExpressions" -> {},
              "userExpressions" -> {}, "missingDirections" -> {}, "extraDirections" -> {}, "requiredRank" -> 0,
              "userRank" -> 0|>, "independentExternalAudit" -> <|"status" -> "exact", "atoms" -> {p12},
              "loopGramRank" -> 0, "requiredMomenta" -> {-p12}, "userMomenta" -> {p12}, "missingMagnitudeSquares" -> {
                }, "extraMagnitudeSquares" -> {}, "redundantUserPositions" -> {}, "redundantUserMomenta" -> {},
              "quadraticDependencyOrder" -> {"userMagnitude1"}, "quadraticDependencies" -> {},
              "requiredIndependentMagnitudeCount" -> 1, "userIndependentMagnitudeCount" -> 1,
              "invalidRequiredPositions" -> {}, "invalidUserPositions" -> {}, "invalidLoopPositions" -> {},
              "missingQuadraticRows" -> {}, "extraQuadraticRows" -> {}|>, "capabilities" ->
             <|"initializationUsableQ" -> True, "timeIBPUsableQ" -> True, "momentumIBPUsableQ" -> False,
              "derivativeUsableQ" -> True, "inverseKinematicsUsableQ" -> True|>, "issues" -> {}|>,
          "capabilities" -> <|"initializationUsableQ" -> True, "timeIBPUsableQ" -> True, "momentumIBPUsableQ" -> False,
            "derivativeUsableQ" -> True, "inverseKinematicsUsableQ" -> True|>, "cycleLineIndices" -> {},
          "bridgeLineIndices" -> {1}, "loopExternalMomenta" -> {}, "effectiveLoopExternalMomenta" -> {},
          "independentExternalMomenta" -> {p12}, "momentumDecompositionBasis" -> {p12}, "fixedExternalVectorAtoms" ->
           {p12}, "externalMomenta" -> {}, "externalLegMomenta" -> {p12}, "rawExternalInvariantRules" -> {},
          "externalInvariantRules" -> {}, "rawExternalLegInvariantRules" -> {sp[p12, p12] -> sE1^2},
          "externalLegInvariantRules" -> {sp[p12, p12] -> sE1^2}, "kinematicRules" -> Automatic,
          "kinematicCoordinateAudit" -> <|"status" -> "complete", "source" -> "default", "baseCoordinateData" ->
             {<|"occurrenceIndex" -> 1, "momentum" -> p12, "squaredExpression" -> sp[p12, p12],
               "magnitudeExpression" -> Sqrt[sp[p12, p12]], "gramVector" -> {1}, "baseCoefficients" -> {1},
               "independentQ" -> True, "externalLegIndex" -> 1, "userVariable" -> sE1, "defaultSquaredExpression" ->
                sE1^2, "baseIndex" -> 1, "kind" -> "externalLegMagnitude", "inputExpression" -> sp[p12, p12],
               "internalVariable" -> dSIBP`Private`externalLegSquaredCoordinate[1], "defaultVariable" -> sE1,
               "defaultRHS" -> sE1^2|>}, "baseCoordinateOrder" -> {sp[p12, p12]}, "baseCoordinateCount" -> 1,
            "defaultRules" -> {sp[p12, p12] -> sE1^2}, "selectionTemplate" -> "kinematicRules" ->
              {sp[p12, p12] -> sE1^2}, "selectedRules" -> {sp[p12, p12] -> sE1^2}, "selectedUserVariables" -> {sE1},
            "userParameterOrder" -> {sE1}, "coordinateMatrix" -> {{1}}, "coordinateRank" -> 1,
            "parameterJacobian" -> {{2*sE1}}, "parameterRank" -> 1, "missingDirections" -> {},
            "ruleMissingDirections" -> {}, "parameterMissingDirections" -> {}, "ruleMissingDirectionExpressions" -> {},
            "parameterMissingDirectionExpressions" -> {}, "ruleDependencies" -> {}, "ruleDependencyResiduals" -> {},
            "parameterDependencies" -> {}, "constraintResiduals" -> {}, "unsupportedRulePositions" -> {},
            "completeQ" -> True, "overcompleteQ" -> False, "inverseAvailableQ" -> True, "resolvedRules" ->
             {sp[p12, p12] -> sE1^2}, "baseSquaredUserExpressions" -> {sE1^2}, "baseRootUserExpressions" -> {sE1},
            "appearingNoLoopMagnitudeMomenta" -> {p12}, "independentNoLoopMagnitudeMomenta" -> {p12},
            "dependentMagnitudeBindings" -> {}, "rawLoopRules" -> {}, "resolvedLoopRules" -> {},
            "rawExternalLegRules" -> {sp[p12, p12] -> sE1^2}, "resolvedExternalLegRules" -> {sp[p12, p12] -> sE1^2},
            "message" -> "动力学变量完备，且当前简单坐标规则可反向转换。"|>, "ispData" -> {},
          "nV" -> 2, "nE" -> 1, "nL" -> 0, "nK" -> 0, "bMatrix" -> {{1}, {-1}}, "vertexLines" -> {{{1, 1}}, {{1, -1}}},
          "loopCoeffMatrix" -> {{}}, "externalCoeffMatrix" -> {{}}, "externalPartList" -> {p12},
          "rawNumericRules" -> {}, "numericRules" -> {}, "sampleDiscreteRules" -> {}, "seedPreset" -> "quickCheck",
          "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0}, "sampleOnly" -> True|>, "generatorSeedRanges" -> {},
          "seedOptions" -> <|"DiscreteMode" -> "sample", "MaxSeedRuleCount" -> 200, "MaxDiscreteRuleCount" -> 64,
            "MaxEquationCount" -> 80, "MaxShrinkSectorDepth" -> Automatic, "MaxShrinkSectorCount" -> 16|>,
          "unknownSeedPreset" -> None, "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta12},
          "shrinkPrefactorRules" -> {E^(Pi*Im[nu12]) -> eta12}, "symmetryRules" -> {}, "thetaBoundarySignOffset" ->
           Automatic, "kiraOrdering" -> <||>, "sectorVertexRepresentativeMap" -> <|v1 -> v1, v2 -> v2|>|>,
         dSIBP`Private`int$]] :> 0}, "userRuleCount" -> 0, "effectiveRuleCount" -> 1|>,
 "effectiveSymmetryRules" ->
  {HoldPattern[dSIBP`Private`int$_J /; dSIBP`Private`tadpoleOddISPIntegralQ[<|"name" -> "016TreeTwoVertexPlusPlus",
        "vertexData" -> {{v1, "+"}, {v2, "+"}}, "vertexIds" -> {v1, v2}, "vertexSignAssoc" -> <|v1 -> "+", v2 -> "+"|>,
        "lines" -> {<|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> p12, "treeEnergy" -> k12, "nu" -> nu12,
           "bbType" -> "h", "massType" -> "massive", "skType" -> "++", "state" -> "full",
           "thetaConvention" -> "mergedTwoTheta", "packType" -> "massiveFull", "masslessN1ReferenceEndpoint" ->
            Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> Missing["NotApplicable"],
           "functionSystem" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu12)/dSIBP`Private`x,
             "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu12])*dSIBP`Private`x^(-1 - 2*nu12))/Pi,
             "WT" -> Automatic, "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 2*nu12|>, "compiledFunctionSystem" ->
            <|"status" -> "compiled", "input" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x, "P" ->
                (1 + 2*nu12)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu12])*
                  dSIBP`Private`x^(-1 - 2*nu12))/Pi, "WT" -> Automatic, "shrinkBShift" -> 1, "shrinkZeroPointShift" ->
                2*nu12|>, "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu12)/dSIBP`Private`x, "Q" -> 1,
             "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu12])*dSIBP`Private`x^(-1 - 2*nu12))/Pi,
             "A0" -> {{0, 1}, {-1, -((1 + 2*nu12)/dSIBP`Private`x)}}, "AT" -> {{0, 1}, {-1,
                -((1 + 2*nu12)/dSIBP`Private`x)}}, "WT" -> ((-4*I)*E^(Pi*Im[nu12])*dSIBP`Private`x^(-1 - 2*nu12))/Pi,
             "derivativeTerms" -> {<|"sourceState" -> 0, "targetState" -> 1, "xPower" -> 0, "coefficient" -> 1|>, <|
                "sourceState" -> 1, "targetState" -> 0, "xPower" -> 0, "coefficient" -> -1|>, <|"sourceState" -> 1,
                "targetState" -> 1, "xPower" -> -1, "coefficient" -> -1 - 2*nu12|>}, "shrinkTerms" ->
              {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu12]))/Pi, "xPower" -> -1 - 2*nu12, "bShift" -> 1,
                "zeroPointShift" -> 2*nu12|>}, "shrinkZeroPointShift" -> 2*nu12|>, "rawMomentum" -> p12,
           "loopLineQ" -> False, "bridgeQ" -> True, "linePowerMode" -> "fixedCoefficient"|>}, "extLegs" -> {},
        "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>, "activeVertexIds" -> {v1, v2}, "fixedAVertexValues" -> <||>,
        "loopMomenta" -> {}, "ibpMode" -> "timeOnly", "graphLoopCount" -> 0, "graphTopologyAudit" ->
         <|"status" -> "valid", "vertexCount" -> 2, "inputLineCount" -> 1, "internalLineCount" -> 1,
          "activeLineIndices" -> {1}, "shrunkLineIndices" -> {}, "connectedComponentCount" -> 1, "graphLoopCount" -> 0,
          "bridgeLineIndices" -> {1}, "cycleLineIndices" -> {}, "selfLoopLineIndices" -> {},
          "incidenceMatrix" -> {{1}, {-1}}, "cycleSpaceDimension" -> 0, "issues" -> {}|>,
        "loopMomentumRoutingAudit" -> <|"status" -> "valid", "ibpMode" -> "timeOnly", "loopMomenta" -> {},
          "loopCoefficientMatrix" -> {{}}, "loopCoefficientRank" -> 0, "lineExternalResiduals" -> {p12},
          "referenceLineIndices" -> {}, "referenceLoopMatrix" -> {}, "referenceExternalResiduals" -> {},
          "shiftInvariantLineResiduals" -> {p12}, "incidenceCycleResidual" -> {}, "issues" -> {}|>,
        "normalizedLineMomenta" -> {p12}, "momentumDeclarationAudit" -> <|"status" -> "exact", "ibpMode" -> "timeOnly",
          "loopExternalMomenta" -> {}, "independentExternalMomenta" -> {p12}, "requiredLoopExternalDirections" -> {},
          "requiredIndependentMomentumMagnitudes" -> {-p12}, "momentumAtoms" -> {p12},
          "loopExternalAudit" -> <|"status" -> "notRequired", "requiredExpressions" -> {}, "userExpressions" -> {},
            "missingDirections" -> {}, "extraDirections" -> {}, "requiredRank" -> 0, "userRank" -> 0|>,
          "independentExternalAudit" -> <|"status" -> "exact", "atoms" -> {p12}, "loopGramRank" -> 0,
            "requiredMomenta" -> {-p12}, "userMomenta" -> {p12}, "missingMagnitudeSquares" -> {},
            "extraMagnitudeSquares" -> {}, "redundantUserPositions" -> {}, "redundantUserMomenta" -> {},
            "quadraticDependencyOrder" -> {"userMagnitude1"}, "quadraticDependencies" -> {},
            "requiredIndependentMagnitudeCount" -> 1, "userIndependentMagnitudeCount" -> 1,
            "invalidRequiredPositions" -> {}, "invalidUserPositions" -> {}, "invalidLoopPositions" -> {},
            "missingQuadraticRows" -> {}, "extraQuadraticRows" -> {}|>, "capabilities" ->
           <|"initializationUsableQ" -> True, "timeIBPUsableQ" -> True, "momentumIBPUsableQ" -> False,
            "derivativeUsableQ" -> True, "inverseKinematicsUsableQ" -> True|>, "issues" -> {}|>,
        "capabilities" -> <|"initializationUsableQ" -> True, "timeIBPUsableQ" -> True, "momentumIBPUsableQ" -> False,
          "derivativeUsableQ" -> True, "inverseKinematicsUsableQ" -> True|>, "cycleLineIndices" -> {},
        "bridgeLineIndices" -> {1}, "loopExternalMomenta" -> {}, "effectiveLoopExternalMomenta" -> {},
        "independentExternalMomenta" -> {p12}, "momentumDecompositionBasis" -> {p12},
        "fixedExternalVectorAtoms" -> {p12}, "externalMomenta" -> {}, "externalLegMomenta" -> {p12},
        "rawExternalInvariantRules" -> {}, "externalInvariantRules" -> {}, "rawExternalLegInvariantRules" ->
         {sp[p12, p12] -> sE1^2}, "externalLegInvariantRules" -> {sp[p12, p12] -> sE1^2},
        "kinematicRules" -> Automatic, "kinematicCoordinateAudit" -> <|"status" -> "complete", "source" -> "default",
          "baseCoordinateData" -> {<|"occurrenceIndex" -> 1, "momentum" -> p12, "squaredExpression" -> sp[p12, p12],
             "magnitudeExpression" -> Sqrt[sp[p12, p12]], "gramVector" -> {1}, "baseCoefficients" -> {1},
             "independentQ" -> True, "externalLegIndex" -> 1, "userVariable" -> sE1, "defaultSquaredExpression" ->
              sE1^2, "baseIndex" -> 1, "kind" -> "externalLegMagnitude", "inputExpression" -> sp[p12, p12],
             "internalVariable" -> dSIBP`Private`externalLegSquaredCoordinate[1], "defaultVariable" -> sE1,
             "defaultRHS" -> sE1^2|>}, "baseCoordinateOrder" -> {sp[p12, p12]}, "baseCoordinateCount" -> 1,
          "defaultRules" -> {sp[p12, p12] -> sE1^2}, "selectionTemplate" -> "kinematicRules" ->
            {sp[p12, p12] -> sE1^2}, "selectedRules" -> {sp[p12, p12] -> sE1^2}, "selectedUserVariables" -> {sE1},
          "userParameterOrder" -> {sE1}, "coordinateMatrix" -> {{1}}, "coordinateRank" -> 1,
          "parameterJacobian" -> {{2*sE1}}, "parameterRank" -> 1, "missingDirections" -> {},
          "ruleMissingDirections" -> {}, "parameterMissingDirections" -> {}, "ruleMissingDirectionExpressions" -> {},
          "parameterMissingDirectionExpressions" -> {}, "ruleDependencies" -> {}, "ruleDependencyResiduals" -> {},
          "parameterDependencies" -> {}, "constraintResiduals" -> {}, "unsupportedRulePositions" -> {},
          "completeQ" -> True, "overcompleteQ" -> False, "inverseAvailableQ" -> True,
          "resolvedRules" -> {sp[p12, p12] -> sE1^2}, "baseSquaredUserExpressions" -> {sE1^2},
          "baseRootUserExpressions" -> {sE1}, "appearingNoLoopMagnitudeMomenta" -> {p12},
          "independentNoLoopMagnitudeMomenta" -> {p12}, "dependentMagnitudeBindings" -> {}, "rawLoopRules" -> {},
          "resolvedLoopRules" -> {}, "rawExternalLegRules" -> {sp[p12, p12] -> sE1^2}, "resolvedExternalLegRules" ->
           {sp[p12, p12] -> sE1^2}, "message" ->
           "动力学变量完备，且当前简单坐标规则可反向转换。"|>, "ispData" -> {}, "nV" -> 2,
        "nE" -> 1, "nL" -> 0, "nK" -> 0, "bMatrix" -> {{1}, {-1}}, "vertexLines" -> {{{1, 1}}, {{1, -1}}},
        "loopCoeffMatrix" -> {{}}, "externalCoeffMatrix" -> {{}}, "externalPartList" -> {p12}, "rawNumericRules" -> {},
        "numericRules" -> {}, "sampleDiscreteRules" -> {}, "seedPreset" -> "quickCheck",
        "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0}, "sampleOnly" -> True|>, "generatorSeedRanges" -> {},
        "seedOptions" -> <|"DiscreteMode" -> "sample", "MaxSeedRuleCount" -> 200, "MaxDiscreteRuleCount" -> 64,
          "MaxEquationCount" -> 80, "MaxShrinkSectorDepth" -> Automatic, "MaxShrinkSectorCount" -> 16|>,
        "unknownSeedPreset" -> None, "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta12},
        "shrinkPrefactorRules" -> {E^(Pi*Im[nu12]) -> eta12}, "symmetryRules" -> {},
        "thetaBoundarySignOffset" -> Automatic, "kiraOrdering" -> <||>, "sectorVertexRepresentativeMap" ->
         <|v1 -> v1, v2 -> v2|>|>, dSIBP`Private`int$]] :> 0}, "masslessBundleCandidates" -> {},
 "masslessEndpointConventions" -> {}, "precomputedShrinkSectorSummary" ->
  <|"status" -> "generated", "completeCoverageQ" -> True|>, "precomputedShrinkSectorKeys" -> {"top", "e1"}|>
