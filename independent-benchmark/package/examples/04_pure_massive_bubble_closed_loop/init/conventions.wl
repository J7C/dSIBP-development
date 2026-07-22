<|"vertexData" -> {{v1, "-"}, {v2, "-"}}, "lineOrder" -> {1, 2},
 "lineConventions" -> {<|"id" -> 1, "massType" -> "massive",
    "packType" -> "massiveFull", "state" -> "full", "skType" -> "--",
    "bbType" -> "h", "thetaConvention" -> "mergedTwoTheta",
    "functionSystem" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x,
      "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
      "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi,
      "WT" -> Automatic, "shrinkBShift" -> 1, "shrinkZeroPointShift" ->
       2*nu|>, "compiledFunctionSystem" -> <|"status" -> "compiled",
      "input" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x,
        "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
        "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi,
        "WT" -> Automatic, "shrinkBShift" -> 1, "shrinkZeroPointShift" ->
         2*nu|>, "variable" -> dSIBP`Private`x,
      "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
      "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi,
      "A0" -> {{0, 1}, {-1, -((1 + 2*nu)/dSIBP`Private`x)}},
      "AT" -> {{0, 1}, {-1, -((1 + 2*nu)/dSIBP`Private`x)}},
      "WT" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi,
      "derivativeTerms" -> {<|"sourceState" -> 0, "targetState" -> 1,
         "xPower" -> 0, "coefficient" -> 1|>, <|"sourceState" -> 1,
         "targetState" -> 0, "xPower" -> 0, "coefficient" -> -1|>,
        <|"sourceState" -> 1, "targetState" -> 1, "xPower" -> -1,
         "coefficient" -> -1 - 2*nu|>}, "shrinkTerms" ->
       {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu]))/Pi, "xPower" -> -1 - 2*nu,
         "bShift" -> 1, "zeroPointShift" -> 2*nu|>},
      "shrinkZeroPointShift" -> 2*nu|>|>,
   <|"id" -> 2, "massType" -> "massive", "packType" -> "massiveFull",
    "state" -> "full", "skType" -> "--", "bbType" -> "h",
    "thetaConvention" -> "mergedTwoTheta", "functionSystem" ->
     <|"preset" -> "h", "variable" -> dSIBP`Private`x,
      "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
      "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi,
      "WT" -> Automatic, "shrinkBShift" -> 1, "shrinkZeroPointShift" ->
       2*nu|>, "compiledFunctionSystem" -> <|"status" -> "compiled",
      "input" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x,
        "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
        "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi,
        "WT" -> Automatic, "shrinkBShift" -> 1, "shrinkZeroPointShift" ->
         2*nu|>, "variable" -> dSIBP`Private`x,
      "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
      "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi,
      "A0" -> {{0, 1}, {-1, -((1 + 2*nu)/dSIBP`Private`x)}},
      "AT" -> {{0, 1}, {-1, -((1 + 2*nu)/dSIBP`Private`x)}},
      "WT" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi,
      "derivativeTerms" -> {<|"sourceState" -> 0, "targetState" -> 1,
         "xPower" -> 0, "coefficient" -> 1|>, <|"sourceState" -> 1,
         "targetState" -> 0, "xPower" -> 0, "coefficient" -> -1|>,
        <|"sourceState" -> 1, "targetState" -> 1, "xPower" -> -1,
         "coefficient" -> -1 - 2*nu|>}, "shrinkTerms" ->
       {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu]))/Pi, "xPower" -> -1 - 2*nu,
         "bShift" -> 1, "zeroPointShift" -> 2*nu|>},
      "shrinkZeroPointShift" -> 2*nu|>|>},
 "zeroPointRules" -> {a0[v1] -> 2*nu, a0[v2] -> 2*nu, b0[1] -> -2*nu,
   b0[2] -> -2*nu}, "shrinkPrefactorRules" -> {E^(Pi*Im[nu])/Pi -> etaNu},
 "symmetryRules" -> {HoldPattern[int_J /; exampleParityZeroQ[int]] :> 0,
   HoldPattern[int_J /; exampleR2Q[int]] :> exampleR2ToR1[int],
   HoldPattern[int_J /; exampleTopQ[int]] :> exampleTopCanonical[int],
   HoldPattern[int_J /; exampleR1Q[int]] :> exampleR1Canonical[int]},
 "effectiveSymmetryRules" ->
  {HoldPattern[dSIBP`Private`int$_J /; dSIBP`Private`tadpoleOddISPIntegralQ[
       <|"name" -> "016PureMassiveBubbleClosedLoopMinusMinus",
        "vertexData" -> {{v1, "-"}, {v2, "-"}}, "vertexIds" -> {v1, v2},
        "vertexSignAssoc" -> <|v1 -> "-", v2 -> "-"|>,
        "lines" -> {<|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
           "massType" -> "massive", "bbType" -> "h", "nu" -> nu,
           "skType" -> "--", "state" -> "full", "thetaConvention" ->
            "mergedTwoTheta", "packType" -> "massiveFull",
           "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"],
           "masslessN1OppositeEndpoint" -> Missing["NotApplicable"],
           "functionSystem" -> <|"preset" -> "h", "variable" ->
              dSIBP`Private`x, "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1,
             "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu])*
                dSIBP`Private`x^(-1 - 2*nu))/Pi, "WT" -> Automatic,
             "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 2*nu|>,
           "compiledFunctionSystem" -> <|"status" -> "compiled",
             "input" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x,
               "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0},
                {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^
                   (-1 - 2*nu))/Pi, "WT" -> Automatic, "shrinkBShift" ->
                1, "shrinkZeroPointShift" -> 2*nu|>, "variable" ->
              dSIBP`Private`x, "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1,
             "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu])*
                dSIBP`Private`x^(-1 - 2*nu))/Pi, "A0" -> {{0, 1}, {-1,
                -((1 + 2*nu)/dSIBP`Private`x)}}, "AT" -> {{0, 1}, {-1,
                -((1 + 2*nu)/dSIBP`Private`x)}}, "WT" -> ((-4*I)*
                E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi,
             "derivativeTerms" -> {<|"sourceState" -> 0, "targetState" -> 1,
                "xPower" -> 0, "coefficient" -> 1|>, <|"sourceState" -> 1,
                "targetState" -> 0, "xPower" -> 0, "coefficient" -> -1|>, <|
                "sourceState" -> 1, "targetState" -> 1, "xPower" -> -1,
                "coefficient" -> -1 - 2*nu|>}, "shrinkTerms" ->
              {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu]))/Pi, "xPower" ->
                 -1 - 2*nu, "bShift" -> 1, "zeroPointShift" -> 2*nu|>},
             "shrinkZeroPointShift" -> 2*nu|>, "rawMomentum" -> q,
           "loopLineQ" -> True, "bridgeQ" -> False, "linePowerMode" ->
            "indexed"|>, <|"id" -> 2, "endpoints" -> {v1, v2},
           "momentum" -> -k + q, "massType" -> "massive", "bbType" -> "h",
           "nu" -> nu, "skType" -> "--", "state" -> "full",
           "thetaConvention" -> "mergedTwoTheta", "packType" ->
            "massiveFull", "masslessN1ReferenceEndpoint" ->
            Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
            Missing["NotApplicable"], "functionSystem" -> <|"preset" -> "h",
             "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu)/
               dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
             "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi,
             "WT" -> Automatic, "shrinkBShift" -> 1,
             "shrinkZeroPointShift" -> 2*nu|>, "compiledFunctionSystem" ->
            <|"status" -> "compiled", "input" -> <|"preset" -> "h",
               "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu)/
                 dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, "W" ->
                ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi,
               "WT" -> Automatic, "shrinkBShift" -> 1,
               "shrinkZeroPointShift" -> 2*nu|>, "variable" ->
              dSIBP`Private`x, "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1,
             "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu])*
                dSIBP`Private`x^(-1 - 2*nu))/Pi, "A0" -> {{0, 1}, {-1,
                -((1 + 2*nu)/dSIBP`Private`x)}}, "AT" -> {{0, 1}, {-1,
                -((1 + 2*nu)/dSIBP`Private`x)}}, "WT" -> ((-4*I)*
                E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi,
             "derivativeTerms" -> {<|"sourceState" -> 0, "targetState" -> 1,
                "xPower" -> 0, "coefficient" -> 1|>, <|"sourceState" -> 1,
                "targetState" -> 0, "xPower" -> 0, "coefficient" -> -1|>, <|
                "sourceState" -> 1, "targetState" -> 1, "xPower" -> -1,
                "coefficient" -> -1 - 2*nu|>}, "shrinkTerms" ->
              {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu]))/Pi, "xPower" ->
                 -1 - 2*nu, "bShift" -> 1, "zeroPointShift" -> 2*nu|>},
             "shrinkZeroPointShift" -> 2*nu|>, "rawMomentum" -> -k + q,
           "loopLineQ" -> True, "bridgeQ" -> False, "linePowerMode" ->
            "indexed"|>}, "extLegs" -> {}, "vertexEnergies" ->
         <|v1 -> P0, v2 -> P0|>, "activeVertexIds" -> {v1, v2},
        "fixedAVertexValues" -> <||>, "loopMomenta" -> {q},
        "ibpMode" -> "full", "graphLoopCount" -> 1, "graphTopologyAudit" ->
         <|"status" -> "valid", "vertexCount" -> 2, "inputLineCount" -> 2,
          "internalLineCount" -> 2, "activeLineIndices" -> {1, 2},
          "shrunkLineIndices" -> {}, "connectedComponentCount" -> 1,
          "graphLoopCount" -> 1, "bridgeLineIndices" -> {},
          "cycleLineIndices" -> {1, 2}, "selfLoopLineIndices" -> {},
          "incidenceMatrix" -> {{1, 1}, {-1, -1}}, "cycleSpaceDimension" ->
           1, "issues" -> {}|>, "loopMomentumRoutingAudit" ->
         <|"status" -> "valid", "ibpMode" -> "full", "loopMomenta" -> {q},
          "loopCoefficientMatrix" -> {{1}, {1}}, "loopCoefficientRank" -> 1,
          "lineExternalResiduals" -> {0, -k}, "referenceLineIndices" -> {1},
          "referenceLoopMatrix" -> {{1}}, "referenceExternalResiduals" ->
           {0}, "shiftInvariantLineResiduals" -> {0, -k},
          "incidenceCycleResidual" -> {{0}, {0}}, "issues" -> {}|>,
        "normalizedLineMomenta" -> {q, -k + q}, "momentumDeclarationAudit" ->
         <|"status" -> "exact", "ibpMode" -> "full", "loopExternalMomenta" ->
           {k}, "independentExternalMomenta" -> {},
          "requiredLoopExternalDirections" -> {-k},
          "requiredIndependentMomentumMagnitudes" -> {}, "momentumAtoms" ->
           {k}, "loopExternalAudit" -> <|"status" -> "exact", "atoms" -> {k},
            "requiredExpressions" -> {-k}, "userExpressions" -> {k},
            "requiredBasisDirections" -> {k}, "userBasisDirections" -> {k},
            "missingDirections" -> {}, "extraDirections" -> {},
            "userDependencyVectors" -> {}, "requiredRank" -> 1,
            "userRank" -> 1, "unionRank" -> 1, "invalidRequiredPositions" ->
             {}, "invalidUserPositions" -> {}|>,
          "independentExternalAudit" -> <|"status" -> "exact",
            "atoms" -> {k}, "loopGramRank" -> 1, "requiredMomenta" -> {},
            "userMomenta" -> {}, "missingMagnitudeSquares" -> {},
            "extraMagnitudeSquares" -> {},
            "requiredIndependentMagnitudeCount" -> 0,
            "userIndependentMagnitudeCount" -> 0,
            "invalidRequiredPositions" -> {}, "invalidUserPositions" -> {},
            "invalidLoopPositions" -> {}, "missingQuadraticRows" -> {},
            "extraQuadraticRows" -> {}|>, "capabilities" ->
           <|"initializationUsableQ" -> True, "timeIBPUsableQ" -> True,
            "momentumIBPUsableQ" -> True, "derivativeUsableQ" -> True,
            "inverseKinematicsUsableQ" -> True|>, "issues" -> {}|>,
        "capabilities" -> <|"initializationUsableQ" -> True,
          "timeIBPUsableQ" -> True, "momentumIBPUsableQ" -> True,
          "derivativeUsableQ" -> True, "inverseKinematicsUsableQ" -> True|>,
        "cycleLineIndices" -> {1, 2}, "bridgeLineIndices" -> {},
        "loopExternalMomenta" -> {k}, "effectiveLoopExternalMomenta" -> {k},
        "independentExternalMomenta" -> {}, "momentumDecompositionBasis" ->
         {q, k}, "fixedExternalVectorAtoms" -> {}, "externalMomenta" -> {k},
        "externalLegMomenta" -> {}, "rawExternalInvariantRules" ->
         {sp[k, k] -> s11}, "externalInvariantRules" -> {sp[k, k] -> s11},
        "rawExternalLegInvariantRules" -> {}, "externalLegInvariantRules" ->
         {}, "kinematicRules" -> Automatic, "kinematicCoordinateAudit" ->
         <|"status" -> "complete", "source" -> "legacyFields",
          "baseCoordinateData" -> {<|"baseIndex" -> 1, "kind" ->
              "loopExternalGram", "inputExpression" -> sp[k, k],
             "internalVariable" -> kk[1, 1], "defaultVariable" -> ss11,
             "defaultRHS" -> ss11^2|>}, "baseCoordinateOrder" -> {sp[k, k]},
          "baseCoordinateCount" -> 1, "defaultRules" -> {sp[k, k] -> ss11^2},
          "selectionTemplate" -> "kinematicRules" -> {sp[k, k] -> ss11^2},
          "selectedRules" -> {sp[k, k] -> s11}, "selectedUserVariables" ->
           {s11}, "userParameterOrder" -> {s11}, "coordinateMatrix" -> {{1}},
          "coordinateRank" -> 1, "parameterJacobian" -> {{1}},
          "parameterRank" -> 1, "missingDirections" -> {},
          "ruleMissingDirections" -> {}, "parameterMissingDirections" -> {},
          "ruleMissingDirectionExpressions" -> {},
          "parameterMissingDirectionExpressions" -> {}, "ruleDependencies" ->
           {}, "ruleDependencyResiduals" -> {}, "parameterDependencies" ->
           {}, "constraintResiduals" -> {}, "unsupportedRulePositions" -> {},
          "completeQ" -> True, "overcompleteQ" -> False,
          "inverseAvailableQ" -> True, "resolvedRules" -> {sp[k, k] -> s11},
          "baseSquaredUserExpressions" -> {s11}, "baseRootUserExpressions" ->
           {Sqrt[s11]}, "appearingNoLoopMagnitudeMomenta" -> {},
          "independentNoLoopMagnitudeMomenta" -> {},
          "dependentMagnitudeBindings" -> {}, "rawLoopRules" ->
           {sp[k, k] -> s11}, "resolvedLoopRules" -> {sp[k, k] -> s11},
          "rawExternalLegRules" -> {}, "resolvedExternalLegRules" -> {},
          "message" -> "\:52a8\:529b\:5b66\:53d8\:91cf\:5b8c\:5907\:ff0c\
\:4e14\:5f53\:524d\:7b80\:5355\:5750\:6807\:89c4\:5219\:53ef\:53cd\:5411\
\:8f6c\:6362\:3002"|>, "ispData" -> {}, "nV" -> 2, "nE" -> 2, "nL" -> 1,
        "nK" -> 1, "bMatrix" -> {{1, 1}, {-1, -1}}, "vertexLines" ->
         {{{1, 1}, {2, 1}}, {{1, -1}, {2, -1}}}, "loopCoeffMatrix" ->
         {{1}, {1}}, "externalCoeffMatrix" -> {{0}, {-1}},
        "externalPartList" -> {0, -k}, "rawNumericRules" ->
         {dim -> 37/11, nu -> 7/13, etaNu -> 23/17}, "numericRules" ->
         {dim -> 37/11, nu -> 7/13, etaNu -> 23/17}, "sampleDiscreteRules" ->
         {}, "seedPreset" -> "quickCheck", "seedRanges" ->
         <|"a" -> {0}, "b" -> {0}, "isp" -> {0}, "sampleOnly" -> False|>,
        "generatorSeedRanges" -> {<|"sectorKey" -> "top",
           "generator" -> {"time", v1}, "ranges" ->
            {a[v1] -> {0, 1, 2, 3, 4}, a[v2] -> {-1, 0, 1, 2, 3, 4},
             b[1] -> {-2, -1, 0, 1, 2, 3, 4, 5}, b[2] -> {-2, -1, 0, 1, 2, 3,
              4, 5}}|>, <|"sectorKey" -> "top", "generator" -> {"time", v2},
           "ranges" -> {a[v1] -> {-1, 0, 1, 2, 3, 4}, a[v2] -> {0, 1, 2, 3,
              4}, b[1] -> {-2, -1, 0, 1, 2, 3, 4, 5}, b[2] -> {-2, -1, 0, 1,
              2, 3, 4, 5}}|>, <|"sectorKey" -> "top", "generator" ->
            {"momentum", 1, "loop", 1}, "ranges" ->
            {a[v1] -> {-1, 0, 1, 2, 3}, a[v2] -> {-1, 0, 1, 2, 3},
             b[1] -> {-1, 0, 1, 2, 3, 4, 5}, b[2] -> {-2, -1, 0, 1, 2, 3}}|>,
          <|"sectorKey" -> "top", "generator" -> {"momentum", 1, "external",
             1}, "ranges" -> {a[v1] -> {-1, 0, 1, 2, 3}, a[v2] -> {-1, 0, 1,
              2, 3}, b[1] -> {-2, -1, 0, 1, 2, 3}, b[2] -> {-1, 0, 1, 2, 3,
              4, 5}}|>, <|"sectorKey" -> "e1", "generator" -> {"time", v1},
           "ranges" -> {a[v1] -> {-3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8},
             bS[1] -> {-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8},
             b[2] -> {-3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8}}|>,
          <|"sectorKey" -> "e1", "generator" -> {"momentum", 1, "loop", 1},
           "ranges" -> {a[v1] -> {-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7},
             bS[1] -> {-2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8}, b[2] -> {-3, -2,
              -1, 0, 1, 2, 3, 4, 5, 6}}|>, <|"sectorKey" -> "e1",
           "generator" -> {"momentum", 1, "external", 1},
           "ranges" -> {a[v1] -> {-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7},
             bS[1] -> {-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6},
             b[2] -> {-2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8}}|>,
          <|"sectorKey" -> "e2", "generator" -> {"time", v1},
           "ranges" -> {a[v1] -> {-3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8},
             bS[2] -> {-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8},
             b[1] -> {-3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8}}|>,
          <|"sectorKey" -> "e2", "generator" -> {"momentum", 1, "loop", 1},
           "ranges" -> {a[v1] -> {-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7},
             bS[2] -> {-2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8}, b[1] -> {-3, -2,
              -1, 0, 1, 2, 3, 4, 5, 6}}|>, <|"sectorKey" -> "e2",
           "generator" -> {"momentum", 1, "external", 1},
           "ranges" -> {a[v1] -> {-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7},
             bS[2] -> {-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6},
             b[1] -> {-2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8}}|>},
        "seedOptions" -> <|"DiscreteMode" -> "all", "MaxSeedRuleCount" ->
           5000, "MaxDiscreteRuleCount" -> 64, "MaxEquationCount" -> 100000,
          "MaxShrinkSectorDepth" -> Automatic, "MaxShrinkSectorCount" ->
           16|>, "unknownSeedPreset" -> None, "zeroPointRules" ->
         {a0[v1] -> 2*nu, a0[v2] -> 2*nu, b0[1] -> -2*nu, b0[2] -> -2*nu},
        "shrinkPrefactorRules" -> {E^(Pi*Im[nu])/Pi -> etaNu},
        "symmetryRules" -> {HoldPattern[int_J /; exampleParityZeroQ[int]] :>
           0, HoldPattern[int_J /; exampleR2Q[int]] :> exampleR2ToR1[int],
          HoldPattern[int_J /; exampleTopQ[int]] :> exampleTopCanonical[int],
          HoldPattern[int_J /; exampleR1Q[int]] :> exampleR1Canonical[int]},
        "thetaBoundarySignOffset" -> Automatic, "kiraOrdering" -> <||>,
        "sectorVertexRepresentativeMap" -> <|v1 -> v1, v2 -> v2|>|>,
       dSIBP`Private`int$]] :> 0,
   HoldPattern[int_J /; exampleParityZeroQ[int]] :> 0,
   HoldPattern[int_J /; exampleR2Q[int]] :> exampleR2ToR1[int],
   HoldPattern[int_J /; exampleTopQ[int]] :> exampleTopCanonical[int],
   HoldPattern[int_J /; exampleR1Q[int]] :> exampleR1Canonical[int]},
 "tadpoleSymmetryData" -> <|"status" -> "generated",
   "loopReversalData" -> {}, "massiveFullLineIndices" -> {},
   "masslessFullLineIndices" -> {}, "automaticRuleCount" -> 1,
   "automaticRules" -> {HoldPattern[dSIBP`Private`int$_J /;
        dSIBP`Private`tadpoleOddISPIntegralQ[
         <|"name" -> "016PureMassiveBubbleClosedLoopMinusMinus",
          "vertexData" -> {{v1, "-"}, {v2, "-"}}, "vertexIds" -> {v1, v2},
          "vertexSignAssoc" -> <|v1 -> "-", v2 -> "-"|>,
          "lines" -> {<|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
             "massType" -> "massive", "bbType" -> "h", "nu" -> nu,
             "skType" -> "--", "state" -> "full", "thetaConvention" ->
              "mergedTwoTheta", "packType" -> "massiveFull",
             "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"],
             "masslessN1OppositeEndpoint" -> Missing["NotApplicable"],
             "functionSystem" -> <|"preset" -> "h", "variable" ->
                dSIBP`Private`x, "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" ->
                1, "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu])*
                  dSIBP`Private`x^(-1 - 2*nu))/Pi, "WT" -> Automatic,
               "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 2*nu|>,
             "compiledFunctionSystem" -> <|"status" -> "compiled", "input" ->
                <|"preset" -> "h", "variable" -> dSIBP`Private`x,
                 "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0},
                  {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^
                     (-1 - 2*nu))/Pi, "WT" -> Automatic, "shrinkBShift" -> 1,
                 "shrinkZeroPointShift" -> 2*nu|>, "variable" ->
                dSIBP`Private`x, "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" ->
                1, "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu])*
                  dSIBP`Private`x^(-1 - 2*nu))/Pi, "A0" -> {{0, 1},
                 {-1, -((1 + 2*nu)/dSIBP`Private`x)}}, "AT" -> {{0, 1},
                 {-1, -((1 + 2*nu)/dSIBP`Private`x)}}, "WT" ->
                ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi,
               "derivativeTerms" -> {<|"sourceState" -> 0, "targetState" ->
                   1, "xPower" -> 0, "coefficient" -> 1|>, <|"sourceState" ->
                   1, "targetState" -> 0, "xPower" -> 0, "coefficient" ->
                   -1|>, <|"sourceState" -> 1, "targetState" -> 1,
                  "xPower" -> -1, "coefficient" -> -1 - 2*nu|>},
               "shrinkTerms" -> {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu]))/Pi,
                  "xPower" -> -1 - 2*nu, "bShift" -> 1, "zeroPointShift" ->
                   2*nu|>}, "shrinkZeroPointShift" -> 2*nu|>,
             "rawMomentum" -> q, "loopLineQ" -> True, "bridgeQ" -> False,
             "linePowerMode" -> "indexed"|>, <|"id" -> 2, "endpoints" ->
              {v1, v2}, "momentum" -> -k + q, "massType" -> "massive",
             "bbType" -> "h", "nu" -> nu, "skType" -> "--",
             "state" -> "full", "thetaConvention" -> "mergedTwoTheta",
             "packType" -> "massiveFull", "masslessN1ReferenceEndpoint" ->
              Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
              Missing["NotApplicable"], "functionSystem" -> <|"preset" ->
                "h", "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu)/
                 dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, "W" ->
                ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi,
               "WT" -> Automatic, "shrinkBShift" -> 1,
               "shrinkZeroPointShift" -> 2*nu|>, "compiledFunctionSystem" ->
              <|"status" -> "compiled", "input" -> <|"preset" -> "h",
                 "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu)/
                   dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}},
                 "W" -> ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/
                   Pi, "WT" -> Automatic, "shrinkBShift" -> 1,
                 "shrinkZeroPointShift" -> 2*nu|>, "variable" ->
                dSIBP`Private`x, "P" -> (1 + 2*nu)/dSIBP`Private`x, "Q" ->
                1, "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu])*
                  dSIBP`Private`x^(-1 - 2*nu))/Pi, "A0" -> {{0, 1},
                 {-1, -((1 + 2*nu)/dSIBP`Private`x)}}, "AT" -> {{0, 1},
                 {-1, -((1 + 2*nu)/dSIBP`Private`x)}}, "WT" ->
                ((-4*I)*E^(Pi*Im[nu])*dSIBP`Private`x^(-1 - 2*nu))/Pi,
               "derivativeTerms" -> {<|"sourceState" -> 0, "targetState" ->
                   1, "xPower" -> 0, "coefficient" -> 1|>, <|"sourceState" ->
                   1, "targetState" -> 0, "xPower" -> 0, "coefficient" ->
                   -1|>, <|"sourceState" -> 1, "targetState" -> 1,
                  "xPower" -> -1, "coefficient" -> -1 - 2*nu|>},
               "shrinkTerms" -> {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu]))/Pi,
                  "xPower" -> -1 - 2*nu, "bShift" -> 1, "zeroPointShift" ->
                   2*nu|>}, "shrinkZeroPointShift" -> 2*nu|>,
             "rawMomentum" -> -k + q, "loopLineQ" -> True, "bridgeQ" ->
              False, "linePowerMode" -> "indexed"|>}, "extLegs" -> {},
          "vertexEnergies" -> <|v1 -> P0, v2 -> P0|>, "activeVertexIds" ->
           {v1, v2}, "fixedAVertexValues" -> <||>, "loopMomenta" -> {q},
          "ibpMode" -> "full", "graphLoopCount" -> 1, "graphTopologyAudit" ->
           <|"status" -> "valid", "vertexCount" -> 2, "inputLineCount" -> 2,
            "internalLineCount" -> 2, "activeLineIndices" -> {1, 2},
            "shrunkLineIndices" -> {}, "connectedComponentCount" -> 1,
            "graphLoopCount" -> 1, "bridgeLineIndices" -> {},
            "cycleLineIndices" -> {1, 2}, "selfLoopLineIndices" -> {},
            "incidenceMatrix" -> {{1, 1}, {-1, -1}}, "cycleSpaceDimension" ->
             1, "issues" -> {}|>, "loopMomentumRoutingAudit" ->
           <|"status" -> "valid", "ibpMode" -> "full", "loopMomenta" -> {q},
            "loopCoefficientMatrix" -> {{1}, {1}}, "loopCoefficientRank" ->
             1, "lineExternalResiduals" -> {0, -k}, "referenceLineIndices" ->
             {1}, "referenceLoopMatrix" -> {{1}},
            "referenceExternalResiduals" -> {0},
            "shiftInvariantLineResiduals" -> {0, -k},
            "incidenceCycleResidual" -> {{0}, {0}}, "issues" -> {}|>,
          "normalizedLineMomenta" -> {q, -k + q},
          "momentumDeclarationAudit" -> <|"status" -> "exact",
            "ibpMode" -> "full", "loopExternalMomenta" -> {k},
            "independentExternalMomenta" -> {},
            "requiredLoopExternalDirections" -> {-k},
            "requiredIndependentMomentumMagnitudes" -> {}, "momentumAtoms" ->
             {k}, "loopExternalAudit" -> <|"status" -> "exact",
              "atoms" -> {k}, "requiredExpressions" -> {-k},
              "userExpressions" -> {k}, "requiredBasisDirections" -> {k},
              "userBasisDirections" -> {k}, "missingDirections" -> {},
              "extraDirections" -> {}, "userDependencyVectors" -> {},
              "requiredRank" -> 1, "userRank" -> 1, "unionRank" -> 1,
              "invalidRequiredPositions" -> {}, "invalidUserPositions" -> {
                }|>, "independentExternalAudit" -> <|"status" -> "exact",
              "atoms" -> {k}, "loopGramRank" -> 1, "requiredMomenta" -> {},
              "userMomenta" -> {}, "missingMagnitudeSquares" -> {},
              "extraMagnitudeSquares" -> {},
              "requiredIndependentMagnitudeCount" -> 0,
              "userIndependentMagnitudeCount" -> 0,
              "invalidRequiredPositions" -> {}, "invalidUserPositions" -> {},
              "invalidLoopPositions" -> {}, "missingQuadraticRows" -> {},
              "extraQuadraticRows" -> {}|>, "capabilities" ->
             <|"initializationUsableQ" -> True, "timeIBPUsableQ" -> True,
              "momentumIBPUsableQ" -> True, "derivativeUsableQ" -> True,
              "inverseKinematicsUsableQ" -> True|>, "issues" -> {}|>,
          "capabilities" -> <|"initializationUsableQ" -> True,
            "timeIBPUsableQ" -> True, "momentumIBPUsableQ" -> True,
            "derivativeUsableQ" -> True, "inverseKinematicsUsableQ" ->
             True|>, "cycleLineIndices" -> {1, 2}, "bridgeLineIndices" -> {},
          "loopExternalMomenta" -> {k}, "effectiveLoopExternalMomenta" ->
           {k}, "independentExternalMomenta" -> {},
          "momentumDecompositionBasis" -> {q, k},
          "fixedExternalVectorAtoms" -> {}, "externalMomenta" -> {k},
          "externalLegMomenta" -> {}, "rawExternalInvariantRules" ->
           {sp[k, k] -> s11}, "externalInvariantRules" -> {sp[k, k] -> s11},
          "rawExternalLegInvariantRules" -> {},
          "externalLegInvariantRules" -> {}, "kinematicRules" -> Automatic,
          "kinematicCoordinateAudit" -> <|"status" -> "complete",
            "source" -> "legacyFields", "baseCoordinateData" ->
             {<|"baseIndex" -> 1, "kind" -> "loopExternalGram",
               "inputExpression" -> sp[k, k], "internalVariable" -> kk[1, 1],
               "defaultVariable" -> ss11, "defaultRHS" -> ss11^2|>},
            "baseCoordinateOrder" -> {sp[k, k]}, "baseCoordinateCount" -> 1,
            "defaultRules" -> {sp[k, k] -> ss11^2}, "selectionTemplate" ->
             "kinematicRules" -> {sp[k, k] -> ss11^2}, "selectedRules" ->
             {sp[k, k] -> s11}, "selectedUserVariables" -> {s11},
            "userParameterOrder" -> {s11}, "coordinateMatrix" -> {{1}},
            "coordinateRank" -> 1, "parameterJacobian" -> {{1}},
            "parameterRank" -> 1, "missingDirections" -> {},
            "ruleMissingDirections" -> {}, "parameterMissingDirections" ->
             {}, "ruleMissingDirectionExpressions" -> {},
            "parameterMissingDirectionExpressions" -> {},
            "ruleDependencies" -> {}, "ruleDependencyResiduals" -> {},
            "parameterDependencies" -> {}, "constraintResiduals" -> {},
            "unsupportedRulePositions" -> {}, "completeQ" -> True,
            "overcompleteQ" -> False, "inverseAvailableQ" -> True,
            "resolvedRules" -> {sp[k, k] -> s11},
            "baseSquaredUserExpressions" -> {s11},
            "baseRootUserExpressions" -> {Sqrt[s11]},
            "appearingNoLoopMagnitudeMomenta" -> {},
            "independentNoLoopMagnitudeMomenta" -> {},
            "dependentMagnitudeBindings" -> {}, "rawLoopRules" ->
             {sp[k, k] -> s11}, "resolvedLoopRules" -> {sp[k, k] -> s11},
            "rawExternalLegRules" -> {}, "resolvedExternalLegRules" -> {},
            "message" -> "\:52a8\:529b\:5b66\:53d8\:91cf\:5b8c\:5907\:ff0c\
\:4e14\:5f53\:524d\:7b80\:5355\:5750\:6807\:89c4\:5219\:53ef\:53cd\:5411\
\:8f6c\:6362\:3002"|>, "ispData" -> {}, "nV" -> 2, "nE" -> 2, "nL" -> 1,
          "nK" -> 1, "bMatrix" -> {{1, 1}, {-1, -1}}, "vertexLines" ->
           {{{1, 1}, {2, 1}}, {{1, -1}, {2, -1}}}, "loopCoeffMatrix" ->
           {{1}, {1}}, "externalCoeffMatrix" -> {{0}, {-1}},
          "externalPartList" -> {0, -k}, "rawNumericRules" ->
           {dim -> 37/11, nu -> 7/13, etaNu -> 23/17}, "numericRules" ->
           {dim -> 37/11, nu -> 7/13, etaNu -> 23/17},
          "sampleDiscreteRules" -> {}, "seedPreset" -> "quickCheck",
          "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0},
            "sampleOnly" -> False|>, "generatorSeedRanges" ->
           {<|"sectorKey" -> "top", "generator" -> {"time", v1},
             "ranges" -> {a[v1] -> {0, 1, 2, 3, 4}, a[v2] -> {-1, 0, 1, 2, 3,
                4}, b[1] -> {-2, -1, 0, 1, 2, 3, 4, 5}, b[2] -> {-2, -1, 0,
                1, 2, 3, 4, 5}}|>, <|"sectorKey" -> "top", "generator" ->
              {"time", v2}, "ranges" -> {a[v1] -> {-1, 0, 1, 2, 3, 4},
               a[v2] -> {0, 1, 2, 3, 4}, b[1] -> {-2, -1, 0, 1, 2, 3, 4, 5},
               b[2] -> {-2, -1, 0, 1, 2, 3, 4, 5}}|>, <|"sectorKey" -> "top",
             "generator" -> {"momentum", 1, "loop", 1}, "ranges" ->
              {a[v1] -> {-1, 0, 1, 2, 3}, a[v2] -> {-1, 0, 1, 2, 3}, b[1] ->
                {-1, 0, 1, 2, 3, 4, 5}, b[2] -> {-2, -1, 0, 1, 2, 3}}|>,
            <|"sectorKey" -> "top", "generator" -> {"momentum", 1,
               "external", 1}, "ranges" -> {a[v1] -> {-1, 0, 1, 2, 3},
               a[v2] -> {-1, 0, 1, 2, 3}, b[1] -> {-2, -1, 0, 1, 2, 3},
               b[2] -> {-1, 0, 1, 2, 3, 4, 5}}|>, <|"sectorKey" -> "e1",
             "generator" -> {"time", v1}, "ranges" -> {a[v1] -> {-3, -2, -1,
                0, 1, 2, 3, 4, 5, 6, 7, 8}, bS[1] -> {-4, -3, -2, -1, 0, 1,
                2, 3, 4, 5, 6, 7, 8}, b[2] -> {-3, -2, -1, 0, 1, 2, 3, 4, 5,
                6, 7, 8}}|>, <|"sectorKey" -> "e1", "generator" ->
              {"momentum", 1, "loop", 1}, "ranges" -> {a[v1] -> {-4, -3, -2,
                -1, 0, 1, 2, 3, 4, 5, 6, 7}, bS[1] -> {-2, -1, 0, 1, 2, 3, 4,
                5, 6, 7, 8}, b[2] -> {-3, -2, -1, 0, 1, 2, 3, 4, 5, 6}}|>,
            <|"sectorKey" -> "e1", "generator" -> {"momentum", 1, "external",
               1}, "ranges" -> {a[v1] -> {-4, -3, -2, -1, 0, 1, 2, 3, 4, 5,
                6, 7}, bS[1] -> {-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6},
               b[2] -> {-2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8}}|>,
            <|"sectorKey" -> "e2", "generator" -> {"time", v1},
             "ranges" -> {a[v1] -> {-3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8},
               bS[2] -> {-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8}, b[1] ->
                {-3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8}}|>,
            <|"sectorKey" -> "e2", "generator" -> {"momentum", 1, "loop", 1},
             "ranges" -> {a[v1] -> {-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7},
               bS[2] -> {-2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8}, b[1] -> {-3, -2,
                -1, 0, 1, 2, 3, 4, 5, 6}}|>, <|"sectorKey" -> "e2",
             "generator" -> {"momentum", 1, "external", 1},
             "ranges" -> {a[v1] -> {-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7},
               bS[2] -> {-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6}, b[1] -> {-2,
                -1, 0, 1, 2, 3, 4, 5, 6, 7, 8}}|>}, "seedOptions" ->
           <|"DiscreteMode" -> "all", "MaxSeedRuleCount" -> 5000,
            "MaxDiscreteRuleCount" -> 64, "MaxEquationCount" -> 100000,
            "MaxShrinkSectorDepth" -> Automatic, "MaxShrinkSectorCount" ->
             16|>, "unknownSeedPreset" -> None, "zeroPointRules" ->
           {a0[v1] -> 2*nu, a0[v2] -> 2*nu, b0[1] -> -2*nu, b0[2] -> -2*nu},
          "shrinkPrefactorRules" -> {E^(Pi*Im[nu])/Pi -> etaNu},
          "symmetryRules" -> {HoldPattern[int_J /; exampleParityZeroQ[
                int]] :> 0, HoldPattern[int_J /; exampleR2Q[int]] :>
             exampleR2ToR1[int], HoldPattern[int_J /; exampleTopQ[int]] :>
             exampleTopCanonical[int], HoldPattern[int_J /; exampleR1Q[
                int]] :> exampleR1Canonical[int]},
          "thetaBoundarySignOffset" -> Automatic, "kiraOrdering" -> <||>,
          "sectorVertexRepresentativeMap" -> <|v1 -> v1, v2 -> v2|>|>,
         dSIBP`Private`int$]] :> 0}, "userRuleCount" -> 4,
   "effectiveRuleCount" -> 5|>, "externalInvariantRules" ->
  {sp[k, k] -> s11}, "externalLegInvariantRules" -> {},
 "externalInvariantCoordinateData" ->
  {<|"internalVariable" -> kk[1, 1], "publicExpression" -> s11,
    "userVariable" -> s11, "coordinateType" -> "legacySquaredInvariant",
    "internalCoordinateExpression" -> kk[1, 1], "internalJacobian" -> 1,
    "userJacobian" -> 1|>}, "externalLegInvariantCoordinateData" -> {},
 "kinematicCoordinateAudit" -> <|"status" -> "complete",
   "source" -> "legacyFields", "baseCoordinateData" ->
    {<|"baseIndex" -> 1, "kind" -> "loopExternalGram",
      "inputExpression" -> sp[k, k], "internalVariable" -> kk[1, 1],
      "defaultVariable" -> ss11, "defaultRHS" -> ss11^2|>},
   "baseCoordinateOrder" -> {sp[k, k]}, "baseCoordinateCount" -> 1,
   "defaultRules" -> {sp[k, k] -> ss11^2}, "selectionTemplate" ->
    "kinematicRules" -> {sp[k, k] -> ss11^2}, "selectedRules" ->
    {sp[k, k] -> s11}, "selectedUserVariables" -> {s11},
   "userParameterOrder" -> {s11}, "coordinateMatrix" -> {{1}},
   "coordinateRank" -> 1, "parameterJacobian" -> {{1}}, "parameterRank" -> 1,
   "missingDirections" -> {}, "ruleMissingDirections" -> {},
   "parameterMissingDirections" -> {}, "ruleMissingDirectionExpressions" ->
    {}, "parameterMissingDirectionExpressions" -> {},
   "ruleDependencies" -> {}, "ruleDependencyResiduals" -> {},
   "parameterDependencies" -> {}, "constraintResiduals" -> {},
   "unsupportedRulePositions" -> {}, "completeQ" -> True,
   "overcompleteQ" -> False, "inverseAvailableQ" -> True,
   "resolvedRules" -> {sp[k, k] -> s11}, "baseSquaredUserExpressions" ->
    {s11}, "baseRootUserExpressions" -> {Sqrt[s11]},
   "appearingNoLoopMagnitudeMomenta" -> {},
   "independentNoLoopMagnitudeMomenta" -> {}, "dependentMagnitudeBindings" ->
    {}, "rawLoopRules" -> {sp[k, k] -> s11}, "resolvedLoopRules" ->
    {sp[k, k] -> s11}, "rawExternalLegRules" -> {},
   "resolvedExternalLegRules" -> {}, "message" -> "\:52a8\:529b\:5b66\:53d8\
\:91cf\:5b8c\:5907\:ff0c\:4e14\:5f53\:524d\:7b80\:5355\:5750\:6807\:89c4\
\:5219\:53ef\:53cd\:5411\:8f6c\:6362\:3002"|>,
 "independentVariables" -> {s11, P0}, "defaultDerivativeCoordinates" -> "ssij \
for the complete loop-external Gram basis; sE1,sE2,... for the \
first-occurrence independent basis of actually appearing no-loop momentum \
magnitudes", "loopTreeProjection" ->
  <|"vertexPhysicalPower" -> "a+a0 becomes tree a+nu0",
   "linePhysicalPower" ->
    "removed b+b0 or bS+bS0 becomes an explicit energy power",
   "normalization" ->
    "relative to the reference loop integral, term by term",
   "unsafePowerExpand" -> False|>|>
