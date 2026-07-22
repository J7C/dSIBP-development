<|"vertexData" -> {{v1, "+"}, {v2, "+"}}, "lineOrder" -> {1}, 
 "lineConventions" -> {<|"id" -> 1, "massType" -> "massive", 
    "packType" -> "massiveFull", "state" -> "full", "skType" -> "++", 
    "bbType" -> "h", "thetaConvention" -> "mergedTwoTheta", 
    "functionSystem" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x, 
      "P" -> (1 + 2*nu12)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, 
      "W" -> ((-4*I)*E^(Pi*Im[nu12])*dSIBP`Private`x^(-1 - 2*nu12))/Pi, 
      "WT" -> Automatic, "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 
       2*nu12|>, "compiledFunctionSystem" -> <|"status" -> "compiled", 
      "input" -> <|"preset" -> "h", "variable" -> dSIBP`Private`x, 
        "P" -> (1 + 2*nu12)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 
         1}}, "W" -> ((-4*I)*E^(Pi*Im[nu12])*dSIBP`Private`x^(-1 - 2*nu12))/
          Pi, "WT" -> Automatic, "shrinkBShift" -> 1, 
        "shrinkZeroPointShift" -> 2*nu12|>, "variable" -> dSIBP`Private`x, 
      "P" -> (1 + 2*nu12)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, 
      "W" -> ((-4*I)*E^(Pi*Im[nu12])*dSIBP`Private`x^(-1 - 2*nu12))/Pi, 
      "A0" -> {{0, 1}, {-1, -((1 + 2*nu12)/dSIBP`Private`x)}}, 
      "AT" -> {{0, 1}, {-1, -((1 + 2*nu12)/dSIBP`Private`x)}}, 
      "WT" -> ((-4*I)*E^(Pi*Im[nu12])*dSIBP`Private`x^(-1 - 2*nu12))/Pi, 
      "derivativeTerms" -> {<|"sourceState" -> 0, "targetState" -> 1, 
         "xPower" -> 0, "coefficient" -> 1|>, <|"sourceState" -> 1, 
         "targetState" -> 0, "xPower" -> 0, "coefficient" -> -1|>, 
        <|"sourceState" -> 1, "targetState" -> 1, "xPower" -> -1, 
         "coefficient" -> -1 - 2*nu12|>}, "shrinkTerms" -> 
       {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu12]))/Pi, 
         "xPower" -> -1 - 2*nu12, "bShift" -> 1, "zeroPointShift" -> 
          2*nu12|>}, "shrinkZeroPointShift" -> 2*nu12|>|>}, 
 "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta12}, 
 "shrinkPrefactorRules" -> {E^(Pi*Im[nu12]) -> eta12}, "symmetryRules" -> {}, 
 "effectiveSymmetryRules" -> 
  {HoldPattern[dSIBP`Private`int$_J /; dSIBP`Private`tadpoleOddISPIntegralQ[
       <|"name" -> "014TreeTwoVertexPlusPlus", "vertexData" -> 
         {{v1, "+"}, {v2, "+"}}, "vertexIds" -> {v1, v2}, 
        "vertexSignAssoc" -> <|v1 -> "+", v2 -> "+"|>, 
        "lines" -> {<|"id" -> 1, "endpoints" -> {v1, v2}, 
           "momentum" -> ell12, "treeEnergy" -> k12, "nu" -> nu12, 
           "bbType" -> "h", "massType" -> "massive", "skType" -> "++", 
           "state" -> "full", "thetaConvention" -> "mergedTwoTheta", 
           "packType" -> "massiveFull", "masslessN1ReferenceEndpoint" -> 
            Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
            Missing["NotApplicable"], "functionSystem" -> <|"preset" -> "h", 
             "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu12)/
               dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, 
             "W" -> ((-4*I)*E^(Pi*Im[nu12])*dSIBP`Private`x^(-1 - 2*nu12))/
               Pi, "WT" -> Automatic, "shrinkBShift" -> 1, 
             "shrinkZeroPointShift" -> 2*nu12|>, "compiledFunctionSystem" -> 
            <|"status" -> "compiled", "input" -> <|"preset" -> "h", 
               "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu12)/
                 dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, "W" -> 
                ((-4*I)*E^(Pi*Im[nu12])*dSIBP`Private`x^(-1 - 2*nu12))/Pi, 
               "WT" -> Automatic, "shrinkBShift" -> 1, 
               "shrinkZeroPointShift" -> 2*nu12|>, "variable" -> 
              dSIBP`Private`x, "P" -> (1 + 2*nu12)/dSIBP`Private`x, "Q" -> 1, 
             "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu12])*
                dSIBP`Private`x^(-1 - 2*nu12))/Pi, "A0" -> {{0, 1}, {-1, 
                -((1 + 2*nu12)/dSIBP`Private`x)}}, "AT" -> {{0, 1}, {-1, 
                -((1 + 2*nu12)/dSIBP`Private`x)}}, "WT" -> 
              ((-4*I)*E^(Pi*Im[nu12])*dSIBP`Private`x^(-1 - 2*nu12))/Pi, 
             "derivativeTerms" -> {<|"sourceState" -> 0, "targetState" -> 1, 
                "xPower" -> 0, "coefficient" -> 1|>, <|"sourceState" -> 1, 
                "targetState" -> 0, "xPower" -> 0, "coefficient" -> -1|>, <|
                "sourceState" -> 1, "targetState" -> 1, "xPower" -> -1, 
                "coefficient" -> -1 - 2*nu12|>}, "shrinkTerms" -> 
              {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu12]))/Pi, "xPower" -> 
                 -1 - 2*nu12, "bShift" -> 1, "zeroPointShift" -> 2*nu12|>}, 
             "shrinkZeroPointShift" -> 2*nu12|>|>}, "extLegs" -> {}, 
        "vertexEnergies" -> <|v1 -> K1, v2 -> K2|>, "activeVertexIds" -> 
         {v1, v2}, "fixedAVertexValues" -> <||>, "loopMomenta" -> {ell12}, 
        "externalMomenta" -> {}, "rawExternalInvariantRules" -> Automatic, 
        "externalInvariantRules" -> {}, "ispData" -> {}, "nV" -> 2, 
        "nE" -> 1, "nL" -> 1, "nK" -> 0, "bMatrix" -> {{1}, {-1}}, 
        "vertexLines" -> {{{1, 1}}, {{1, -1}}}, "loopCoeffMatrix" -> {{1}}, 
        "externalCoeffMatrix" -> {{}}, "externalPartList" -> {0}, 
        "numericRules" -> {}, "sampleDiscreteRules" -> {}, 
        "seedPreset" -> "quickCheck", "seedRanges" -> <|"a" -> {0}, 
          "b" -> {0}, "isp" -> {0}, "sampleOnly" -> True|>, 
        "generatorSeedRanges" -> {}, "seedOptions" -> 
         <|"DiscreteMode" -> "sample", "MaxSeedRuleCount" -> 200, 
          "MaxDiscreteRuleCount" -> 64, "MaxEquationCount" -> 80, 
          "MaxShrinkSectorDepth" -> Automatic, "MaxShrinkSectorCount" -> 
           16|>, "unknownSeedPreset" -> None, "zeroPointRules" -> 
         {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta12}, 
        "shrinkPrefactorRules" -> {E^(Pi*Im[nu12]) -> eta12}, 
        "symmetryRules" -> {}, "thetaBoundarySignOffset" -> Automatic, 
        "kiraOrdering" -> <||>, "sectorVertexRepresentativeMap" -> 
         <|v1 -> v1, v2 -> v2|>|>, dSIBP`Private`int$]] :> 0}, 
 "tadpoleSymmetryData" -> <|"status" -> "generated", 
   "loopReversalData" -> {}, "massiveFullLineIndices" -> 
    Missing["KeyAbsent", "lineIndex"], "masslessFullLineIndices" -> 
    Missing["KeyAbsent", "lineIndex"], "automaticRuleCount" -> 1, 
   "automaticRules" -> {HoldPattern[dSIBP`Private`int$_J /; 
        dSIBP`Private`tadpoleOddISPIntegralQ[
         <|"name" -> "014TreeTwoVertexPlusPlus", "vertexData" -> 
           {{v1, "+"}, {v2, "+"}}, "vertexIds" -> {v1, v2}, 
          "vertexSignAssoc" -> <|v1 -> "+", v2 -> "+"|>, 
          "lines" -> {<|"id" -> 1, "endpoints" -> {v1, v2}, 
             "momentum" -> ell12, "treeEnergy" -> k12, "nu" -> nu12, 
             "bbType" -> "h", "massType" -> "massive", "skType" -> "++", 
             "state" -> "full", "thetaConvention" -> "mergedTwoTheta", 
             "packType" -> "massiveFull", "masslessN1ReferenceEndpoint" -> 
              Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
              Missing["NotApplicable"], "functionSystem" -> <|"preset" -> 
                "h", "variable" -> dSIBP`Private`x, "P" -> (1 + 2*nu12)/
                 dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 0}, {0, 1}}, "W" -> 
                ((-4*I)*E^(Pi*Im[nu12])*dSIBP`Private`x^(-1 - 2*nu12))/Pi, 
               "WT" -> Automatic, "shrinkBShift" -> 1, 
               "shrinkZeroPointShift" -> 2*nu12|>, 
             "compiledFunctionSystem" -> <|"status" -> "compiled", "input" -> 
                <|"preset" -> "h", "variable" -> dSIBP`Private`x, 
                 "P" -> (1 + 2*nu12)/dSIBP`Private`x, "Q" -> 1, "T" -> {{1, 
                  0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu12])*dSIBP`Private`x^
                     (-1 - 2*nu12))/Pi, "WT" -> Automatic, "shrinkBShift" -> 
                  1, "shrinkZeroPointShift" -> 2*nu12|>, "variable" -> 
                dSIBP`Private`x, "P" -> (1 + 2*nu12)/dSIBP`Private`x, "Q" -> 
                1, "T" -> {{1, 0}, {0, 1}}, "W" -> ((-4*I)*E^(Pi*Im[nu12])*
                  dSIBP`Private`x^(-1 - 2*nu12))/Pi, "A0" -> {{0, 1}, 
                 {-1, -((1 + 2*nu12)/dSIBP`Private`x)}}, "AT" -> 
                {{0, 1}, {-1, -((1 + 2*nu12)/dSIBP`Private`x)}}, "WT" -> 
                ((-4*I)*E^(Pi*Im[nu12])*dSIBP`Private`x^(-1 - 2*nu12))/Pi, 
               "derivativeTerms" -> {<|"sourceState" -> 0, "targetState" -> 
                   1, "xPower" -> 0, "coefficient" -> 1|>, <|"sourceState" -> 
                   1, "targetState" -> 0, "xPower" -> 0, "coefficient" -> 
                   -1|>, <|"sourceState" -> 1, "targetState" -> 1, 
                  "xPower" -> -1, "coefficient" -> -1 - 2*nu12|>}, 
               "shrinkTerms" -> {<|"coefficient" -> ((4*I)*E^(Pi*Im[nu12]))/
                    Pi, "xPower" -> -1 - 2*nu12, "bShift" -> 1, 
                  "zeroPointShift" -> 2*nu12|>}, "shrinkZeroPointShift" -> 
                2*nu12|>|>}, "extLegs" -> {}, "vertexEnergies" -> 
           <|v1 -> K1, v2 -> K2|>, "activeVertexIds" -> {v1, v2}, 
          "fixedAVertexValues" -> <||>, "loopMomenta" -> {ell12}, 
          "externalMomenta" -> {}, "rawExternalInvariantRules" -> Automatic, 
          "externalInvariantRules" -> {}, "ispData" -> {}, "nV" -> 2, 
          "nE" -> 1, "nL" -> 1, "nK" -> 0, "bMatrix" -> {{1}, {-1}}, 
          "vertexLines" -> {{{1, 1}}, {{1, -1}}}, "loopCoeffMatrix" -> {{1}}, 
          "externalCoeffMatrix" -> {{}}, "externalPartList" -> {0}, 
          "numericRules" -> {}, "sampleDiscreteRules" -> {}, 
          "seedPreset" -> "quickCheck", "seedRanges" -> <|"a" -> {0}, 
            "b" -> {0}, "isp" -> {0}, "sampleOnly" -> True|>, 
          "generatorSeedRanges" -> {}, "seedOptions" -> 
           <|"DiscreteMode" -> "sample", "MaxSeedRuleCount" -> 200, 
            "MaxDiscreteRuleCount" -> 64, "MaxEquationCount" -> 80, 
            "MaxShrinkSectorDepth" -> Automatic, "MaxShrinkSectorCount" -> 
             16|>, "unknownSeedPreset" -> None, "zeroPointRules" -> 
           {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta12}, 
          "shrinkPrefactorRules" -> {E^(Pi*Im[nu12]) -> eta12}, 
          "symmetryRules" -> {}, "thetaBoundarySignOffset" -> Automatic, 
          "kiraOrdering" -> <||>, "sectorVertexRepresentativeMap" -> 
           <|v1 -> v1, v2 -> v2|>|>, dSIBP`Private`int$]] :> 0}, 
   "userRuleCount" -> 0, "effectiveRuleCount" -> 1|>, 
 "externalInvariantRules" -> {}, "independentVariables" -> {K1, K2}, 
 "loopTreeProjection" -> <|"vertexPhysicalPower" -> 
    "a+a0 becomes tree a+nu0", "linePhysicalPower" -> 
    "removed b+b0 or bS+bS0 becomes an explicit energy power", 
   "normalization" -> 
    "relative to the reference loop integral, term by term", 
   "unsafePowerExpand" -> False|>|>
