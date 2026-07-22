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
       <|"name" -> "014PureMassiveBubbleClosedLoopMinusMinus", 
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
             "shrinkZeroPointShift" -> 2*nu|>|>, <|"id" -> 2, 
           "endpoints" -> {v1, v2}, "momentum" -> -k + q, 
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
             "shrinkZeroPointShift" -> 2*nu|>|>}, "extLegs" -> {}, 
        "vertexEnergies" -> <|v1 -> P0, v2 -> P0|>, "activeVertexIds" -> 
         {v1, v2}, "fixedAVertexValues" -> <||>, "loopMomenta" -> {q}, 
        "externalMomenta" -> {k}, "rawExternalInvariantRules" -> 
         {sp[k, k] -> s11}, "externalInvariantRules" -> {sp[k, k] -> s11}, 
        "ispData" -> {}, "nV" -> 2, "nE" -> 2, "nL" -> 1, "nK" -> 1, 
        "bMatrix" -> {{1, 1}, {-1, -1}}, "vertexLines" -> 
         {{{1, 1}, {2, 1}}, {{1, -1}, {2, -1}}}, "loopCoeffMatrix" -> 
         {{1}, {1}}, "externalCoeffMatrix" -> {{0}, {-1}}, 
        "externalPartList" -> {0, -k}, "numericRules" -> {}, 
        "sampleDiscreteRules" -> {}, "seedPreset" -> "quickCheck", 
        "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0}, 
          "sampleOnly" -> False|>, "generatorSeedRanges" -> 
         {<|"sectorKey" -> "top", "generator" -> {"time", v1}, 
           "ranges" -> {a[v1] -> {0, 1, 2, 3, 4}, a[v2] -> {-1, 0, 1, 2, 3, 
              4}, b[1] -> {-2, -1, 0, 1, 2, 3, 4, 5}, b[2] -> {-2, -1, 0, 1, 
              2, 3, 4, 5}}|>, <|"sectorKey" -> "top", "generator" -> 
            {"time", v2}, "ranges" -> {a[v1] -> {-1, 0, 1, 2, 3, 4}, 
             a[v2] -> {0, 1, 2, 3, 4}, b[1] -> {-2, -1, 0, 1, 2, 3, 4, 5}, 
             b[2] -> {-2, -1, 0, 1, 2, 3, 4, 5}}|>, <|"sectorKey" -> "top", 
           "generator" -> {"momentum", 1, "loop", 1}, "ranges" -> 
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
   "loopReversalData" -> {}, "massiveFullLineIndices" -> 
    Missing["KeyAbsent", "lineIndex"], "masslessFullLineIndices" -> 
    Missing["KeyAbsent", "lineIndex"], "automaticRuleCount" -> 1, 
   "automaticRules" -> {HoldPattern[dSIBP`Private`int$_J /; 
        dSIBP`Private`tadpoleOddISPIntegralQ[
         <|"name" -> "014PureMassiveBubbleClosedLoopMinusMinus", 
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
                   2*nu|>}, "shrinkZeroPointShift" -> 2*nu|>|>, 
            <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> -k + q, 
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
                   2*nu|>}, "shrinkZeroPointShift" -> 2*nu|>|>}, 
          "extLegs" -> {}, "vertexEnergies" -> <|v1 -> P0, v2 -> P0|>, 
          "activeVertexIds" -> {v1, v2}, "fixedAVertexValues" -> <||>, 
          "loopMomenta" -> {q}, "externalMomenta" -> {k}, 
          "rawExternalInvariantRules" -> {sp[k, k] -> s11}, 
          "externalInvariantRules" -> {sp[k, k] -> s11}, "ispData" -> {}, 
          "nV" -> 2, "nE" -> 2, "nL" -> 1, "nK" -> 1, "bMatrix" -> 
           {{1, 1}, {-1, -1}}, "vertexLines" -> {{{1, 1}, {2, 1}}, 
            {{1, -1}, {2, -1}}}, "loopCoeffMatrix" -> {{1}, {1}}, 
          "externalCoeffMatrix" -> {{0}, {-1}}, "externalPartList" -> 
           {0, -k}, "numericRules" -> {}, "sampleDiscreteRules" -> {}, 
          "seedPreset" -> "quickCheck", "seedRanges" -> <|"a" -> {0}, 
            "b" -> {0}, "isp" -> {0}, "sampleOnly" -> False|>, 
          "generatorSeedRanges" -> {<|"sectorKey" -> "top", 
             "generator" -> {"time", v1}, "ranges" -> {a[v1] -> {0, 1, 2, 3, 
                4}, a[v2] -> {-1, 0, 1, 2, 3, 4}, b[1] -> {-2, -1, 0, 1, 2, 
                3, 4, 5}, b[2] -> {-2, -1, 0, 1, 2, 3, 4, 5}}|>, 
            <|"sectorKey" -> "top", "generator" -> {"time", v2}, 
             "ranges" -> {a[v1] -> {-1, 0, 1, 2, 3, 4}, a[v2] -> {0, 1, 2, 3, 
                4}, b[1] -> {-2, -1, 0, 1, 2, 3, 4, 5}, b[2] -> {-2, -1, 0, 
                1, 2, 3, 4, 5}}|>, <|"sectorKey" -> "top", "generator" -> 
              {"momentum", 1, "loop", 1}, "ranges" -> {a[v1] -> {-1, 0, 1, 2, 
                3}, a[v2] -> {-1, 0, 1, 2, 3}, b[1] -> {-1, 0, 1, 2, 3, 4, 
                5}, b[2] -> {-2, -1, 0, 1, 2, 3}}|>, <|"sectorKey" -> "top", 
             "generator" -> {"momentum", 1, "external", 1}, 
             "ranges" -> {a[v1] -> {-1, 0, 1, 2, 3}, a[v2] -> {-1, 0, 1, 2, 
                3}, b[1] -> {-2, -1, 0, 1, 2, 3}, b[2] -> {-1, 0, 1, 2, 3, 4, 
                5}}|>, <|"sectorKey" -> "e1", "generator" -> {"time", v1}, 
             "ranges" -> {a[v1] -> {-3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8}, 
               bS[1] -> {-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8}, b[2] -> 
                {-3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8}}|>, 
            <|"sectorKey" -> "e1", "generator" -> {"momentum", 1, "loop", 1}, 
             "ranges" -> {a[v1] -> {-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7}, 
               bS[1] -> {-2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8}, b[2] -> {-3, -2, 
                -1, 0, 1, 2, 3, 4, 5, 6}}|>, <|"sectorKey" -> "e1", 
             "generator" -> {"momentum", 1, "external", 1}, 
             "ranges" -> {a[v1] -> {-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7}, 
               bS[1] -> {-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6}, b[2] -> {-2, 
                -1, 0, 1, 2, 3, 4, 5, 6, 7, 8}}|>, <|"sectorKey" -> "e2", 
             "generator" -> {"time", v1}, "ranges" -> {a[v1] -> {-3, -2, -1, 
                0, 1, 2, 3, 4, 5, 6, 7, 8}, bS[2] -> {-4, -3, -2, -1, 0, 1, 
                2, 3, 4, 5, 6, 7, 8}, b[1] -> {-3, -2, -1, 0, 1, 2, 3, 4, 5, 
                6, 7, 8}}|>, <|"sectorKey" -> "e2", "generator" -> 
              {"momentum", 1, "loop", 1}, "ranges" -> {a[v1] -> {-4, -3, -2, 
                -1, 0, 1, 2, 3, 4, 5, 6, 7}, bS[2] -> {-2, -1, 0, 1, 2, 3, 4, 
                5, 6, 7, 8}, b[1] -> {-3, -2, -1, 0, 1, 2, 3, 4, 5, 6}}|>, 
            <|"sectorKey" -> "e2", "generator" -> {"momentum", 1, "external", 
               1}, "ranges" -> {a[v1] -> {-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 
                6, 7}, bS[2] -> {-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6}, 
               b[1] -> {-2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8}}|>}, 
          "seedOptions" -> <|"DiscreteMode" -> "all", "MaxSeedRuleCount" -> 
             5000, "MaxDiscreteRuleCount" -> 64, "MaxEquationCount" -> 
             100000, "MaxShrinkSectorDepth" -> Automatic, 
            "MaxShrinkSectorCount" -> 16|>, "unknownSeedPreset" -> None, 
          "zeroPointRules" -> {a0[v1] -> 2*nu, a0[v2] -> 2*nu, 
            b0[1] -> -2*nu, b0[2] -> -2*nu}, "shrinkPrefactorRules" -> 
           {E^(Pi*Im[nu])/Pi -> etaNu}, "symmetryRules" -> 
           {HoldPattern[int_J /; exampleParityZeroQ[int]] :> 0, 
            HoldPattern[int_J /; exampleR2Q[int]] :> exampleR2ToR1[int], 
            HoldPattern[int_J /; exampleTopQ[int]] :> exampleTopCanonical[
              int], HoldPattern[int_J /; exampleR1Q[int]] :> 
             exampleR1Canonical[int]}, "thetaBoundarySignOffset" -> 
           Automatic, "kiraOrdering" -> <||>, 
          "sectorVertexRepresentativeMap" -> <|v1 -> v1, v2 -> v2|>|>, 
         dSIBP`Private`int$]] :> 0}, "userRuleCount" -> 4, 
   "effectiveRuleCount" -> 5|>, "externalInvariantRules" -> 
  {sp[k, k] -> s11}, "independentVariables" -> {kk[1, 1], P0}, 
 "loopTreeProjection" -> <|"vertexPhysicalPower" -> 
    "a+a0 becomes tree a+nu0", "linePhysicalPower" -> 
    "removed b+b0 or bS+bS0 becomes an explicit energy power", 
   "normalization" -> 
    "relative to the reference loop integral, term by term", 
   "unsafePowerExpand" -> False|>|>
