<|"context" -> <|"head" -> "MadStreeContext", "version" -> "1.0", 
   "caseName" -> "MadStreeContext", "convention" -> 
    <|"timePower" -> "(-tau)^A", "functionBasis" -> "h", 
     "nuConvention" -> "Negative", "hDefinition" -> "z^-nu H_nu", 
     "paperFormulaReplacement" -> "nuPaper -> nu"|>, 
   "vertices" -> {<|"id" -> 1, "position" -> 1, "externalLegEnergy" -> k1, 
      "externalLegEnergyTarget" -> k1, "auxiliaryExternalLegEnergyQ" -> 
       False, "timePower" -> a1, "vertexType" -> "-", "contourSign" -> -1, 
      "vertexSign" -> 1|>, <|"id" -> 2, "position" -> 2, 
      "externalLegEnergy" -> k2, "externalLegEnergyTarget" -> k2, 
      "auxiliaryExternalLegEnergyQ" -> False, "timePower" -> a2, 
      "vertexType" -> "-", "contourSign" -> -1, "vertexSign" -> 1|>}, 
   "lines" -> {<|"id" -> 1, "position" -> 1, "inputType" -> "massive", 
      "type" -> "massiveFull", "endpoints" -> {1, 2}, "momentum" -> x1, 
      "nu" -> I/4, "hankelOrder" -> I/4, "hPrefactorPower" -> -1/4*I, 
      "formulaNu" -> -1/4*I, "nuConvention" -> "Negative", 
      "contourType" -> "--", "fullContourSign" -> -1, 
      "endpointSigns" -> {-1, -1}, "hankelBranches" -> "timeOrdered--", 
      "functionSystem" -> "h", "contactRawPower" -> -1 - I/2, 
      "pinchNormalization" -> (4*I)/(Pi*x1^(1 + I/2))|>, 
     <|"id" -> 2, "position" -> 2, "inputType" -> "massive", 
      "type" -> "massiveFull", "endpoints" -> {1, 2}, "momentum" -> x2, 
      "nu" -> I/4, "hankelOrder" -> I/4, "hPrefactorPower" -> -1/4*I, 
      "formulaNu" -> -1/4*I, "nuConvention" -> "Negative", 
      "contourType" -> "--", "fullContourSign" -> -1, 
      "endpointSigns" -> {-1, -1}, "hankelBranches" -> "timeOrdered--", 
      "functionSystem" -> "h", "contactRawPower" -> -1 - I/2, 
      "pinchNormalization" -> (4*I)/(Pi*x2^(1 + I/2))|>}, 
   "graphMode" -> "TimeOnly", "topologyClass" -> "cyclicTimeOnly", 
   "contactBundles" -> {<|"bundleId" -> "thetaBundle:1", "lineIds" -> {1, 2}, 
      "rootEndpoints" -> {1, 2}, "source" -> 
       "inferredFromCommonEndpoints"|>}, "contactTransitions" -> 
    {<|"eventId" -> "11->01:{1}", "sourceContractedLineIds" -> {}, 
      "targetContractedLineIds" -> {1}, "sourceSector" -> "11", 
      "targetSector" -> "01", "selectedLineIds" -> {1}, 
      "bundleLineIds" -> {1, 2}, "thetaBundleCoefficient" -> 1, 
      "componentPair" -> {1, 2}|>, <|"eventId" -> "11->10:{2}", 
      "sourceContractedLineIds" -> {}, "targetContractedLineIds" -> {2}, 
      "sourceSector" -> "11", "targetSector" -> "10", 
      "selectedLineIds" -> {2}, "bundleLineIds" -> {1, 2}, 
      "thetaBundleCoefficient" -> 1, "componentPair" -> {1, 2}|>}, 
   "sectorKeySchema" -> <|"type" -> "rootPropagatorBitString", 
     "rootLineOrder" -> {1, 2}, "width" -> 2, "contractedBit" -> "0", 
     "uncontractedBit" -> "1", "storageType" -> "String"|>, 
   "energyCoordinates" -> {<|"vertex" -> 1, "userExternalLegEnergy" -> k1, 
      "vertexType" -> "-", "vertexSign" -> 1, "dampingDefinition" -> I*k1|>, 
     <|"vertex" -> 2, "userExternalLegEnergy" -> k2, "vertexType" -> "-", 
      "vertexSign" -> 1, "dampingDefinition" -> I*k2|>}, 
   "sectors" -> {<|"sectorKey" -> "11", "sectorBits" -> {"1", "1"}, 
      "contractedLineIds" -> {}, "remainingFullLineCount" -> 2, 
      "vertexComponents" -> {{1}, {2}}, "vertexOrder" -> {1, 2}, 
      "rootToComponent" -> <|1 -> 1, 2 -> 2|>, "componentEnergies" -> 
       {k1, k2}, "baseTimePowers" -> {a1, a2}, "activeLines" -> 
       {<|"id" -> 1, "position" -> 1, "inputType" -> "massive", 
         "type" -> "massiveFull", "endpoints" -> {1, 2}, "momentum" -> x1, 
         "nu" -> I/4, "hankelOrder" -> I/4, "hPrefactorPower" -> -1/4*I, 
         "formulaNu" -> -1/4*I, "nuConvention" -> "Negative", 
         "contourType" -> "--", "fullContourSign" -> -1, 
         "endpointSigns" -> {-1, -1}, "hankelBranches" -> "timeOrdered--", 
         "functionSystem" -> "h", "contactRawPower" -> -1 - I/2, 
         "pinchNormalization" -> (4*I)/(Pi*x1^(1 + I/2))|>, 
        <|"id" -> 2, "position" -> 2, "inputType" -> "massive", 
         "type" -> "massiveFull", "endpoints" -> {1, 2}, "momentum" -> x2, 
         "nu" -> I/4, "hankelOrder" -> I/4, "hPrefactorPower" -> -1/4*I, 
         "formulaNu" -> -1/4*I, "nuConvention" -> "Negative", 
         "contourType" -> "--", "fullContourSign" -> -1, 
         "endpointSigns" -> {-1, -1}, "hankelBranches" -> "timeOrdered--", 
         "functionSystem" -> "h", "contactRawPower" -> -1 - I/2, 
         "pinchNormalization" -> (4*I)/(Pi*x2^(1 + I/2))|>}, 
      "slots" -> {<|"key" -> {1, 1}, "kind" -> "massiveEndpoint", 
         "lineId" -> 1, "linePosition" -> 1, "endpointIndex" -> 1, 
         "rootVertex" -> 1, "momentum" -> x1, "nu" -> I/4, 
         "formulaNu" -> -1/4*I, "hankelOrder" -> I/4, "hPrefactorPower" -> 
          -1/4*I|>, <|"key" -> {1, 2}, "kind" -> "massiveEndpoint", 
         "lineId" -> 1, "linePosition" -> 1, "endpointIndex" -> 2, 
         "rootVertex" -> 2, "momentum" -> x1, "nu" -> I/4, 
         "formulaNu" -> -1/4*I, "hankelOrder" -> I/4, "hPrefactorPower" -> 
          -1/4*I|>, <|"key" -> {2, 1}, "kind" -> "massiveEndpoint", 
         "lineId" -> 2, "linePosition" -> 2, "endpointIndex" -> 1, 
         "rootVertex" -> 1, "momentum" -> x2, "nu" -> I/4, 
         "formulaNu" -> -1/4*I, "hankelOrder" -> I/4, "hPrefactorPower" -> 
          -1/4*I|>, <|"key" -> {2, 2}, "kind" -> "massiveEndpoint", 
         "lineId" -> 2, "linePosition" -> 2, "endpointIndex" -> 2, 
         "rootVertex" -> 2, "momentum" -> x2, "nu" -> I/4, 
         "formulaNu" -> -1/4*I, "hankelOrder" -> I/4, "hPrefactorPower" -> 
          -1/4*I|>}, "slotCount" -> 4, "normalization" -> 1, 
      "contactDepth" -> 0, "rawStateOrder" -> {{0, 0, 0, 0}, {0, 0, 0, 1}, 
        {0, 0, 1, 0}, {0, 0, 1, 1}, {0, 1, 0, 0}, {0, 1, 0, 1}, {0, 1, 1, 0}, 
        {0, 1, 1, 1}, {1, 0, 0, 0}, {1, 0, 0, 1}, {1, 0, 1, 0}, {1, 0, 1, 1}, 
        {1, 1, 0, 0}, {1, 1, 0, 1}, {1, 1, 1, 0}, {1, 1, 1, 1}}, 
      "stateOrder" -> {{0, 0, 0, 0}, {0, 0, 0, 1}, {0, 0, 1, 0}, {0, 0, 1, 
       1}, {0, 1, 0, 0}, {0, 1, 0, 1}, {0, 1, 1, 0}, {0, 1, 1, 1}, {1, 0, 0, 
       0}, {1, 0, 0, 1}, {1, 0, 1, 0}, {1, 0, 1, 1}, {1, 1, 0, 0}, {1, 1, 0, 
       1}, {1, 1, 1, 0}, {1, 1, 1, 1}}, "stateEmbedding" -> {{1, 0, 0, 0, 0, 
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
       0, 0, 0, 0}, {0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 
       0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 1, 0, 0, 0, 0, 
       0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
       0}, {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 
       0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
       0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0}, {0, 0, 
       0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 
       0, 0, 1, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 
       0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0}, {0, 0, 0, 0, 0, 
       0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
       0, 0, 0, 1}}, "stateProjection" -> {{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
       0, 0, 0, 0, 0}, {0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 
       0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 1, 0, 0, 0, 0, 
       0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
       0}, {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 
       0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 
       0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 
       0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 
       0, 1, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
       0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0}, {0, 0, 0, 0, 0, 
       0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
       0, 0, 1, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}}, 
      "coincidentLineIds" -> {}, "quotientCertifiedQ" -> True, 
      "rawStateCount" -> 16, "masterCount" -> 16|>, 
     <|"sectorKey" -> "01", "sectorBits" -> {"0", "1"}, 
      "contractedLineIds" -> {1}, "remainingFullLineCount" -> 1, 
      "vertexComponents" -> {{1, 2}}, "vertexOrder" -> {1}, 
      "rootToComponent" -> <|1 -> 1, 2 -> 1|>, "componentEnergies" -> 
       {k1 + k2}, "baseTimePowers" -> {-1/2*I + a1 + a2}, 
      "activeLines" -> {<|"id" -> 2, "position" -> 2, "inputType" -> 
          "massive", "type" -> "massiveFull", "endpoints" -> {1, 2}, 
         "momentum" -> x2, "nu" -> I/4, "hankelOrder" -> I/4, 
         "hPrefactorPower" -> -1/4*I, "formulaNu" -> -1/4*I, 
         "nuConvention" -> "Negative", "contourType" -> "--", 
         "fullContourSign" -> -1, "endpointSigns" -> {-1, -1}, 
         "hankelBranches" -> "timeOrdered--", "functionSystem" -> "h", 
         "contactRawPower" -> -1 - I/2, "pinchNormalization" -> 
          (4*I)/(Pi*x2^(1 + I/2))|>}, "slots" -> 
       {<|"key" -> {2, 1}, "kind" -> "massiveEndpoint", "lineId" -> 2, 
         "linePosition" -> 2, "endpointIndex" -> 1, "rootVertex" -> 1, 
         "momentum" -> x2, "nu" -> I/4, "formulaNu" -> -1/4*I, 
         "hankelOrder" -> I/4, "hPrefactorPower" -> -1/4*I|>, 
        <|"key" -> {2, 2}, "kind" -> "massiveEndpoint", "lineId" -> 2, 
         "linePosition" -> 2, "endpointIndex" -> 2, "rootVertex" -> 2, 
         "momentum" -> x2, "nu" -> I/4, "formulaNu" -> -1/4*I, 
         "hankelOrder" -> I/4, "hPrefactorPower" -> -1/4*I|>}, 
      "slotCount" -> 2, "normalization" -> (4*I)/(Pi*x1^(1 + I/2)), 
      "contactDepth" -> 1, "rawStateOrder" -> {{0, 0}, {0, 1}, {1, 0}, {1, 
        1}}, "stateOrder" -> {{0, 0}, {0, 1}, {1, 1}}, 
      "stateEmbedding" -> {{1, 0, 0}, {0, 1, 0}, {0, 1, 0}, {0, 0, 1}}, 
      "stateProjection" -> {{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 0, 1}}, 
      "coincidentLineIds" -> {2}, "quotientCertifiedQ" -> True, 
      "rawStateCount" -> 4, "masterCount" -> 3|>, <|"sectorKey" -> "10", 
      "sectorBits" -> {"1", "0"}, "contractedLineIds" -> {2}, 
      "remainingFullLineCount" -> 1, "vertexComponents" -> {{1, 2}}, 
      "vertexOrder" -> {1}, "rootToComponent" -> <|1 -> 1, 2 -> 1|>, 
      "componentEnergies" -> {k1 + k2}, "baseTimePowers" -> 
       {-1/2*I + a1 + a2}, "activeLines" -> {<|"id" -> 1, "position" -> 1, 
         "inputType" -> "massive", "type" -> "massiveFull", 
         "endpoints" -> {1, 2}, "momentum" -> x1, "nu" -> I/4, 
         "hankelOrder" -> I/4, "hPrefactorPower" -> -1/4*I, 
         "formulaNu" -> -1/4*I, "nuConvention" -> "Negative", 
         "contourType" -> "--", "fullContourSign" -> -1, 
         "endpointSigns" -> {-1, -1}, "hankelBranches" -> "timeOrdered--", 
         "functionSystem" -> "h", "contactRawPower" -> -1 - I/2, 
         "pinchNormalization" -> (4*I)/(Pi*x1^(1 + I/2))|>}, 
      "slots" -> {<|"key" -> {1, 1}, "kind" -> "massiveEndpoint", 
         "lineId" -> 1, "linePosition" -> 1, "endpointIndex" -> 1, 
         "rootVertex" -> 1, "momentum" -> x1, "nu" -> I/4, 
         "formulaNu" -> -1/4*I, "hankelOrder" -> I/4, "hPrefactorPower" -> 
          -1/4*I|>, <|"key" -> {1, 2}, "kind" -> "massiveEndpoint", 
         "lineId" -> 1, "linePosition" -> 1, "endpointIndex" -> 2, 
         "rootVertex" -> 2, "momentum" -> x1, "nu" -> I/4, 
         "formulaNu" -> -1/4*I, "hankelOrder" -> I/4, "hPrefactorPower" -> 
          -1/4*I|>}, "slotCount" -> 2, "normalization" -> 
       (4*I)/(Pi*x2^(1 + I/2)), "contactDepth" -> 1, 
      "rawStateOrder" -> {{0, 0}, {0, 1}, {1, 0}, {1, 1}}, 
      "stateOrder" -> {{0, 0}, {0, 1}, {1, 1}}, "stateEmbedding" -> {{1, 0, 
       0}, {0, 1, 0}, {0, 1, 0}, {0, 0, 1}}, "stateProjection" -> {{1, 0, 0, 
       0}, {0, 1, 0, 0}, {0, 0, 0, 1}}, "coincidentLineIds" -> {1}, 
      "quotientCertifiedQ" -> True, "rawStateCount" -> 4, 
      "masterCount" -> 3|>}, "sectorOrder" -> {"11", "01", "10"}, 
   "masters" -> {<|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 1, "stateBits" -> {0, 0, 0, 0}, 
      "integral" -> MSIntegral["11", {0, 0}, {0, 0, 0, 0}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 2, "stateBits" -> {0, 0, 0, 1}, 
      "integral" -> MSIntegral["11", {0, 0}, {0, 0, 0, 1}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 3, "stateBits" -> {0, 0, 1, 0}, 
      "integral" -> MSIntegral["11", {0, 0}, {0, 0, 1, 0}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 4, "stateBits" -> {0, 0, 1, 1}, 
      "integral" -> MSIntegral["11", {0, 0}, {0, 0, 1, 1}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 5, "stateBits" -> {0, 1, 0, 0}, 
      "integral" -> MSIntegral["11", {0, 0}, {0, 1, 0, 0}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 6, "stateBits" -> {0, 1, 0, 1}, 
      "integral" -> MSIntegral["11", {0, 0}, {0, 1, 0, 1}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 7, "stateBits" -> {0, 1, 1, 0}, 
      "integral" -> MSIntegral["11", {0, 0}, {0, 1, 1, 0}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 8, "stateBits" -> {0, 1, 1, 1}, 
      "integral" -> MSIntegral["11", {0, 0}, {0, 1, 1, 1}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 9, "stateBits" -> {1, 0, 0, 0}, 
      "integral" -> MSIntegral["11", {0, 0}, {1, 0, 0, 0}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 10, "stateBits" -> {1, 0, 0, 1}, 
      "integral" -> MSIntegral["11", {0, 0}, {1, 0, 0, 1}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 11, "stateBits" -> {1, 0, 1, 0}, 
      "integral" -> MSIntegral["11", {0, 0}, {1, 0, 1, 0}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 12, "stateBits" -> {1, 0, 1, 1}, 
      "integral" -> MSIntegral["11", {0, 0}, {1, 0, 1, 1}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 13, "stateBits" -> {1, 1, 0, 0}, 
      "integral" -> MSIntegral["11", {0, 0}, {1, 1, 0, 0}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 14, "stateBits" -> {1, 1, 0, 1}, 
      "integral" -> MSIntegral["11", {0, 0}, {1, 1, 0, 1}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 15, "stateBits" -> {1, 1, 1, 0}, 
      "integral" -> MSIntegral["11", {0, 0}, {1, 1, 1, 0}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 16, "stateBits" -> {1, 1, 1, 1}, 
      "integral" -> MSIntegral["11", {0, 0}, {1, 1, 1, 1}], 
      "normalization" -> 1|>, <|"sectorKey" -> "01", "sectorOffset" -> 17, 
      "globalIndex" -> 17, "stateBits" -> {0, 0}, 
      "integral" -> MSIntegral["01", {0}, {0, 0}], "normalization" -> 
       (4*I)/(Pi*x1^(1 + I/2))|>, <|"sectorKey" -> "01", 
      "sectorOffset" -> 17, "globalIndex" -> 18, "stateBits" -> {0, 1}, 
      "integral" -> MSIntegral["01", {0}, {0, 1}], "normalization" -> 
       (4*I)/(Pi*x1^(1 + I/2))|>, <|"sectorKey" -> "01", 
      "sectorOffset" -> 17, "globalIndex" -> 19, "stateBits" -> {1, 1}, 
      "integral" -> MSIntegral["01", {0}, {1, 1}], "normalization" -> 
       (4*I)/(Pi*x1^(1 + I/2))|>, <|"sectorKey" -> "10", 
      "sectorOffset" -> 20, "globalIndex" -> 20, "stateBits" -> {0, 0}, 
      "integral" -> MSIntegral["10", {0}, {0, 0}], "normalization" -> 
       (4*I)/(Pi*x2^(1 + I/2))|>, <|"sectorKey" -> "10", 
      "sectorOffset" -> 20, "globalIndex" -> 21, "stateBits" -> {0, 1}, 
      "integral" -> MSIntegral["10", {0}, {0, 1}], "normalization" -> 
       (4*I)/(Pi*x2^(1 + I/2))|>, <|"sectorKey" -> "10", 
      "sectorOffset" -> 20, "globalIndex" -> 22, "stateBits" -> {1, 1}, 
      "integral" -> MSIntegral["10", {0}, {1, 1}], "normalization" -> 
       (4*I)/(Pi*x2^(1 + I/2))|>}, "masterDigest" -> 
    "20a0e98060a1615a0e4fe237cf561e9e5791806057b162e599e93b6a686ae5bc", 
   "sectorIdentityCertificate" -> <|"status" -> "certified", 
     "checks" -> <|"sectorKeysUniqueQ" -> True, "contractedSetsUniqueQ" -> 
        True, "sectorKeysCanonicalQ" -> True, "masterIntegralsUniqueQ" -> 
        True, "masterCountMatchesQ" -> True, "globalIndicesContiguousQ" -> 
        True, "masterSectorKeysKnownQ" -> True|>, "sectorCount" -> 3, 
     "masterCount" -> 22, "masterDigest" -> 
      "20a0e98060a1615a0e4fe237cf561e9e5791806057b162e599e93b6a686ae5bc"|>, 
   "timeIBPDomainCertificate" -> <|"status" -> "certified", 
     "componentRecords" -> {<|"sectorKey" -> "11", "componentPosition" -> 1, 
        "vertexIds" -> {1}, "stateBits" -> {0, 0, 0, 0}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {0, 0}, "branchPowers" -> {-1/2*I, -1/2*I}, 
           "gammaArgumentAtMaster" -> (1 - I) + a1|>, <|"branchOrdinal" -> 2, 
           "branchSelection" -> {1, 2}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {0, 0}, "branchPowers" -> {-1/2*I, 0}, 
           "gammaArgumentAtMaster" -> (1 - I/2) + a1|>, 
          <|"branchOrdinal" -> 3, "branchSelection" -> {2, 1}, 
           "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {0, 0}, 
           "branchPowers" -> {0, -1/2*I}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a1|>, <|"branchOrdinal" -> 4, "branchSelection" -> 
            {2, 2}, "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {0, 0}, 
           "branchPowers" -> {0, 0}, "gammaArgumentAtMaster" -> 1 + a1|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 2, 
        "vertexIds" -> {2}, "stateBits" -> {0, 0, 0, 0}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {0, 0}, "branchPowers" -> {-1/2*I, -1/2*I}, 
           "gammaArgumentAtMaster" -> (1 - I) + a2|>, <|"branchOrdinal" -> 2, 
           "branchSelection" -> {1, 2}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {0, 0}, "branchPowers" -> {-1/2*I, 0}, 
           "gammaArgumentAtMaster" -> (1 - I/2) + a2|>, 
          <|"branchOrdinal" -> 3, "branchSelection" -> {2, 1}, 
           "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {0, 0}, 
           "branchPowers" -> {0, -1/2*I}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a2|>, <|"branchOrdinal" -> 4, "branchSelection" -> 
            {2, 2}, "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {0, 0}, 
           "branchPowers" -> {0, 0}, "gammaArgumentAtMaster" -> 1 + a2|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 1, 
        "vertexIds" -> {1}, "stateBits" -> {0, 0, 0, 1}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {0, 0}, "branchPowers" -> {-1/2*I, -1/2*I}, 
           "gammaArgumentAtMaster" -> (1 - I) + a1|>, <|"branchOrdinal" -> 2, 
           "branchSelection" -> {1, 2}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {0, 0}, "branchPowers" -> {-1/2*I, 0}, 
           "gammaArgumentAtMaster" -> (1 - I/2) + a1|>, 
          <|"branchOrdinal" -> 3, "branchSelection" -> {2, 1}, 
           "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {0, 0}, 
           "branchPowers" -> {0, -1/2*I}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a1|>, <|"branchOrdinal" -> 4, "branchSelection" -> 
            {2, 2}, "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {0, 0}, 
           "branchPowers" -> {0, 0}, "gammaArgumentAtMaster" -> 1 + a1|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 2, 
        "vertexIds" -> {2}, "stateBits" -> {0, 0, 0, 1}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {0, 1}, "branchPowers" -> {-1/2*I, -1 - I/2}, 
           "gammaArgumentAtMaster" -> -I + a2|>, <|"branchOrdinal" -> 2, 
           "branchSelection" -> {1, 2}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {0, 1}, "branchPowers" -> {-1/2*I, 1}, 
           "gammaArgumentAtMaster" -> (2 - I/2) + a2|>, 
          <|"branchOrdinal" -> 3, "branchSelection" -> {2, 1}, 
           "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {0, 1}, 
           "branchPowers" -> {0, -1 - I/2}, "gammaArgumentAtMaster" -> 
            -1/2*I + a2|>, <|"branchOrdinal" -> 4, "branchSelection" -> {2, 
            2}, "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {0, 1}, 
           "branchPowers" -> {0, 1}, "gammaArgumentAtMaster" -> 2 + a2|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 1, 
        "vertexIds" -> {1}, "stateBits" -> {0, 0, 1, 0}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {0, 1}, "branchPowers" -> {-1/2*I, -1 - I/2}, 
           "gammaArgumentAtMaster" -> -I + a1|>, <|"branchOrdinal" -> 2, 
           "branchSelection" -> {1, 2}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {0, 1}, "branchPowers" -> {-1/2*I, 1}, 
           "gammaArgumentAtMaster" -> (2 - I/2) + a1|>, 
          <|"branchOrdinal" -> 3, "branchSelection" -> {2, 1}, 
           "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {0, 1}, 
           "branchPowers" -> {0, -1 - I/2}, "gammaArgumentAtMaster" -> 
            -1/2*I + a1|>, <|"branchOrdinal" -> 4, "branchSelection" -> {2, 
            2}, "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {0, 1}, 
           "branchPowers" -> {0, 1}, "gammaArgumentAtMaster" -> 2 + a1|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 2, 
        "vertexIds" -> {2}, "stateBits" -> {0, 0, 1, 0}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {0, 0}, "branchPowers" -> {-1/2*I, -1/2*I}, 
           "gammaArgumentAtMaster" -> (1 - I) + a2|>, <|"branchOrdinal" -> 2, 
           "branchSelection" -> {1, 2}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {0, 0}, "branchPowers" -> {-1/2*I, 0}, 
           "gammaArgumentAtMaster" -> (1 - I/2) + a2|>, 
          <|"branchOrdinal" -> 3, "branchSelection" -> {2, 1}, 
           "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {0, 0}, 
           "branchPowers" -> {0, -1/2*I}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a2|>, <|"branchOrdinal" -> 4, "branchSelection" -> 
            {2, 2}, "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {0, 0}, 
           "branchPowers" -> {0, 0}, "gammaArgumentAtMaster" -> 1 + a2|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 1, 
        "vertexIds" -> {1}, "stateBits" -> {0, 0, 1, 1}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {0, 1}, "branchPowers" -> {-1/2*I, -1 - I/2}, 
           "gammaArgumentAtMaster" -> -I + a1|>, <|"branchOrdinal" -> 2, 
           "branchSelection" -> {1, 2}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {0, 1}, "branchPowers" -> {-1/2*I, 1}, 
           "gammaArgumentAtMaster" -> (2 - I/2) + a1|>, 
          <|"branchOrdinal" -> 3, "branchSelection" -> {2, 1}, 
           "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {0, 1}, 
           "branchPowers" -> {0, -1 - I/2}, "gammaArgumentAtMaster" -> 
            -1/2*I + a1|>, <|"branchOrdinal" -> 4, "branchSelection" -> {2, 
            2}, "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {0, 1}, 
           "branchPowers" -> {0, 1}, "gammaArgumentAtMaster" -> 2 + a1|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 2, 
        "vertexIds" -> {2}, "stateBits" -> {0, 0, 1, 1}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {0, 1}, "branchPowers" -> {-1/2*I, -1 - I/2}, 
           "gammaArgumentAtMaster" -> -I + a2|>, <|"branchOrdinal" -> 2, 
           "branchSelection" -> {1, 2}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {0, 1}, "branchPowers" -> {-1/2*I, 1}, 
           "gammaArgumentAtMaster" -> (2 - I/2) + a2|>, 
          <|"branchOrdinal" -> 3, "branchSelection" -> {2, 1}, 
           "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {0, 1}, 
           "branchPowers" -> {0, -1 - I/2}, "gammaArgumentAtMaster" -> 
            -1/2*I + a2|>, <|"branchOrdinal" -> 4, "branchSelection" -> {2, 
            2}, "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {0, 1}, 
           "branchPowers" -> {0, 1}, "gammaArgumentAtMaster" -> 2 + a2|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 1, 
        "vertexIds" -> {1}, "stateBits" -> {0, 1, 0, 0}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {0, 0}, "branchPowers" -> {-1/2*I, -1/2*I}, 
           "gammaArgumentAtMaster" -> (1 - I) + a1|>, <|"branchOrdinal" -> 2, 
           "branchSelection" -> {1, 2}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {0, 0}, "branchPowers" -> {-1/2*I, 0}, 
           "gammaArgumentAtMaster" -> (1 - I/2) + a1|>, 
          <|"branchOrdinal" -> 3, "branchSelection" -> {2, 1}, 
           "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {0, 0}, 
           "branchPowers" -> {0, -1/2*I}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a1|>, <|"branchOrdinal" -> 4, "branchSelection" -> 
            {2, 2}, "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {0, 0}, 
           "branchPowers" -> {0, 0}, "gammaArgumentAtMaster" -> 1 + a1|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 2, 
        "vertexIds" -> {2}, "stateBits" -> {0, 1, 0, 0}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {1, 0}, "branchPowers" -> {-1 - I/2, -1/2*I}, 
           "gammaArgumentAtMaster" -> -I + a2|>, <|"branchOrdinal" -> 2, 
           "branchSelection" -> {1, 2}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {1, 0}, "branchPowers" -> {-1 - I/2, 0}, 
           "gammaArgumentAtMaster" -> -1/2*I + a2|>, <|"branchOrdinal" -> 3, 
           "branchSelection" -> {2, 1}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {1, 0}, "branchPowers" -> {1, -1/2*I}, 
           "gammaArgumentAtMaster" -> (2 - I/2) + a2|>, 
          <|"branchOrdinal" -> 4, "branchSelection" -> {2, 2}, 
           "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {1, 0}, 
           "branchPowers" -> {1, 0}, "gammaArgumentAtMaster" -> 2 + a2|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 1, 
        "vertexIds" -> {1}, "stateBits" -> {0, 1, 0, 1}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {0, 0}, "branchPowers" -> {-1/2*I, -1/2*I}, 
           "gammaArgumentAtMaster" -> (1 - I) + a1|>, <|"branchOrdinal" -> 2, 
           "branchSelection" -> {1, 2}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {0, 0}, "branchPowers" -> {-1/2*I, 0}, 
           "gammaArgumentAtMaster" -> (1 - I/2) + a1|>, 
          <|"branchOrdinal" -> 3, "branchSelection" -> {2, 1}, 
           "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {0, 0}, 
           "branchPowers" -> {0, -1/2*I}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a1|>, <|"branchOrdinal" -> 4, "branchSelection" -> 
            {2, 2}, "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {0, 0}, 
           "branchPowers" -> {0, 0}, "gammaArgumentAtMaster" -> 1 + a1|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 2, 
        "vertexIds" -> {2}, "stateBits" -> {0, 1, 0, 1}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {1, 1}, "branchPowers" -> {-1 - I/2, -1 - I/2}, 
           "gammaArgumentAtMaster" -> (-1 - I) + a2|>, 
          <|"branchOrdinal" -> 2, "branchSelection" -> {1, 2}, 
           "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {-1 - I/2, 1}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a2|>, <|"branchOrdinal" -> 3, "branchSelection" -> 
            {2, 1}, "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {1, -1 - I/2}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a2|>, <|"branchOrdinal" -> 4, "branchSelection" -> 
            {2, 2}, "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {1, 1}, "gammaArgumentAtMaster" -> 3 + a2|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 1, 
        "vertexIds" -> {1}, "stateBits" -> {0, 1, 1, 0}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {0, 1}, "branchPowers" -> {-1/2*I, -1 - I/2}, 
           "gammaArgumentAtMaster" -> -I + a1|>, <|"branchOrdinal" -> 2, 
           "branchSelection" -> {1, 2}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {0, 1}, "branchPowers" -> {-1/2*I, 1}, 
           "gammaArgumentAtMaster" -> (2 - I/2) + a1|>, 
          <|"branchOrdinal" -> 3, "branchSelection" -> {2, 1}, 
           "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {0, 1}, 
           "branchPowers" -> {0, -1 - I/2}, "gammaArgumentAtMaster" -> 
            -1/2*I + a1|>, <|"branchOrdinal" -> 4, "branchSelection" -> {2, 
            2}, "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {0, 1}, 
           "branchPowers" -> {0, 1}, "gammaArgumentAtMaster" -> 2 + a1|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 2, 
        "vertexIds" -> {2}, "stateBits" -> {0, 1, 1, 0}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {1, 0}, "branchPowers" -> {-1 - I/2, -1/2*I}, 
           "gammaArgumentAtMaster" -> -I + a2|>, <|"branchOrdinal" -> 2, 
           "branchSelection" -> {1, 2}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {1, 0}, "branchPowers" -> {-1 - I/2, 0}, 
           "gammaArgumentAtMaster" -> -1/2*I + a2|>, <|"branchOrdinal" -> 3, 
           "branchSelection" -> {2, 1}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {1, 0}, "branchPowers" -> {1, -1/2*I}, 
           "gammaArgumentAtMaster" -> (2 - I/2) + a2|>, 
          <|"branchOrdinal" -> 4, "branchSelection" -> {2, 2}, 
           "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {1, 0}, 
           "branchPowers" -> {1, 0}, "gammaArgumentAtMaster" -> 2 + a2|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 1, 
        "vertexIds" -> {1}, "stateBits" -> {0, 1, 1, 1}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {0, 1}, "branchPowers" -> {-1/2*I, -1 - I/2}, 
           "gammaArgumentAtMaster" -> -I + a1|>, <|"branchOrdinal" -> 2, 
           "branchSelection" -> {1, 2}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {0, 1}, "branchPowers" -> {-1/2*I, 1}, 
           "gammaArgumentAtMaster" -> (2 - I/2) + a1|>, 
          <|"branchOrdinal" -> 3, "branchSelection" -> {2, 1}, 
           "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {0, 1}, 
           "branchPowers" -> {0, -1 - I/2}, "gammaArgumentAtMaster" -> 
            -1/2*I + a1|>, <|"branchOrdinal" -> 4, "branchSelection" -> {2, 
            2}, "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {0, 1}, 
           "branchPowers" -> {0, 1}, "gammaArgumentAtMaster" -> 2 + a1|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 2, 
        "vertexIds" -> {2}, "stateBits" -> {0, 1, 1, 1}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {1, 1}, "branchPowers" -> {-1 - I/2, -1 - I/2}, 
           "gammaArgumentAtMaster" -> (-1 - I) + a2|>, 
          <|"branchOrdinal" -> 2, "branchSelection" -> {1, 2}, 
           "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {-1 - I/2, 1}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a2|>, <|"branchOrdinal" -> 3, "branchSelection" -> 
            {2, 1}, "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {1, -1 - I/2}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a2|>, <|"branchOrdinal" -> 4, "branchSelection" -> 
            {2, 2}, "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {1, 1}, "gammaArgumentAtMaster" -> 3 + a2|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 1, 
        "vertexIds" -> {1}, "stateBits" -> {1, 0, 0, 0}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {1, 0}, "branchPowers" -> {-1 - I/2, -1/2*I}, 
           "gammaArgumentAtMaster" -> -I + a1|>, <|"branchOrdinal" -> 2, 
           "branchSelection" -> {1, 2}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {1, 0}, "branchPowers" -> {-1 - I/2, 0}, 
           "gammaArgumentAtMaster" -> -1/2*I + a1|>, <|"branchOrdinal" -> 3, 
           "branchSelection" -> {2, 1}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {1, 0}, "branchPowers" -> {1, -1/2*I}, 
           "gammaArgumentAtMaster" -> (2 - I/2) + a1|>, 
          <|"branchOrdinal" -> 4, "branchSelection" -> {2, 2}, 
           "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {1, 0}, 
           "branchPowers" -> {1, 0}, "gammaArgumentAtMaster" -> 2 + a1|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 2, 
        "vertexIds" -> {2}, "stateBits" -> {1, 0, 0, 0}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {0, 0}, "branchPowers" -> {-1/2*I, -1/2*I}, 
           "gammaArgumentAtMaster" -> (1 - I) + a2|>, <|"branchOrdinal" -> 2, 
           "branchSelection" -> {1, 2}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {0, 0}, "branchPowers" -> {-1/2*I, 0}, 
           "gammaArgumentAtMaster" -> (1 - I/2) + a2|>, 
          <|"branchOrdinal" -> 3, "branchSelection" -> {2, 1}, 
           "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {0, 0}, 
           "branchPowers" -> {0, -1/2*I}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a2|>, <|"branchOrdinal" -> 4, "branchSelection" -> 
            {2, 2}, "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {0, 0}, 
           "branchPowers" -> {0, 0}, "gammaArgumentAtMaster" -> 1 + a2|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 1, 
        "vertexIds" -> {1}, "stateBits" -> {1, 0, 0, 1}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {1, 0}, "branchPowers" -> {-1 - I/2, -1/2*I}, 
           "gammaArgumentAtMaster" -> -I + a1|>, <|"branchOrdinal" -> 2, 
           "branchSelection" -> {1, 2}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {1, 0}, "branchPowers" -> {-1 - I/2, 0}, 
           "gammaArgumentAtMaster" -> -1/2*I + a1|>, <|"branchOrdinal" -> 3, 
           "branchSelection" -> {2, 1}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {1, 0}, "branchPowers" -> {1, -1/2*I}, 
           "gammaArgumentAtMaster" -> (2 - I/2) + a1|>, 
          <|"branchOrdinal" -> 4, "branchSelection" -> {2, 2}, 
           "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {1, 0}, 
           "branchPowers" -> {1, 0}, "gammaArgumentAtMaster" -> 2 + a1|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 2, 
        "vertexIds" -> {2}, "stateBits" -> {1, 0, 0, 1}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {0, 1}, "branchPowers" -> {-1/2*I, -1 - I/2}, 
           "gammaArgumentAtMaster" -> -I + a2|>, <|"branchOrdinal" -> 2, 
           "branchSelection" -> {1, 2}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {0, 1}, "branchPowers" -> {-1/2*I, 1}, 
           "gammaArgumentAtMaster" -> (2 - I/2) + a2|>, 
          <|"branchOrdinal" -> 3, "branchSelection" -> {2, 1}, 
           "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {0, 1}, 
           "branchPowers" -> {0, -1 - I/2}, "gammaArgumentAtMaster" -> 
            -1/2*I + a2|>, <|"branchOrdinal" -> 4, "branchSelection" -> {2, 
            2}, "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {0, 1}, 
           "branchPowers" -> {0, 1}, "gammaArgumentAtMaster" -> 2 + a2|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 1, 
        "vertexIds" -> {1}, "stateBits" -> {1, 0, 1, 0}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {1, 1}, "branchPowers" -> {-1 - I/2, -1 - I/2}, 
           "gammaArgumentAtMaster" -> (-1 - I) + a1|>, 
          <|"branchOrdinal" -> 2, "branchSelection" -> {1, 2}, 
           "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {-1 - I/2, 1}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a1|>, <|"branchOrdinal" -> 3, "branchSelection" -> 
            {2, 1}, "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {1, -1 - I/2}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a1|>, <|"branchOrdinal" -> 4, "branchSelection" -> 
            {2, 2}, "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {1, 1}, "gammaArgumentAtMaster" -> 3 + a1|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 2, 
        "vertexIds" -> {2}, "stateBits" -> {1, 0, 1, 0}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {0, 0}, "branchPowers" -> {-1/2*I, -1/2*I}, 
           "gammaArgumentAtMaster" -> (1 - I) + a2|>, <|"branchOrdinal" -> 2, 
           "branchSelection" -> {1, 2}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {0, 0}, "branchPowers" -> {-1/2*I, 0}, 
           "gammaArgumentAtMaster" -> (1 - I/2) + a2|>, 
          <|"branchOrdinal" -> 3, "branchSelection" -> {2, 1}, 
           "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {0, 0}, 
           "branchPowers" -> {0, -1/2*I}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a2|>, <|"branchOrdinal" -> 4, "branchSelection" -> 
            {2, 2}, "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {0, 0}, 
           "branchPowers" -> {0, 0}, "gammaArgumentAtMaster" -> 1 + a2|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 1, 
        "vertexIds" -> {1}, "stateBits" -> {1, 0, 1, 1}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {1, 1}, "branchPowers" -> {-1 - I/2, -1 - I/2}, 
           "gammaArgumentAtMaster" -> (-1 - I) + a1|>, 
          <|"branchOrdinal" -> 2, "branchSelection" -> {1, 2}, 
           "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {-1 - I/2, 1}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a1|>, <|"branchOrdinal" -> 3, "branchSelection" -> 
            {2, 1}, "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {1, -1 - I/2}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a1|>, <|"branchOrdinal" -> 4, "branchSelection" -> 
            {2, 2}, "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {1, 1}, "gammaArgumentAtMaster" -> 3 + a1|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 2, 
        "vertexIds" -> {2}, "stateBits" -> {1, 0, 1, 1}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {0, 1}, "branchPowers" -> {-1/2*I, -1 - I/2}, 
           "gammaArgumentAtMaster" -> -I + a2|>, <|"branchOrdinal" -> 2, 
           "branchSelection" -> {1, 2}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {0, 1}, "branchPowers" -> {-1/2*I, 1}, 
           "gammaArgumentAtMaster" -> (2 - I/2) + a2|>, 
          <|"branchOrdinal" -> 3, "branchSelection" -> {2, 1}, 
           "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {0, 1}, 
           "branchPowers" -> {0, -1 - I/2}, "gammaArgumentAtMaster" -> 
            -1/2*I + a2|>, <|"branchOrdinal" -> 4, "branchSelection" -> {2, 
            2}, "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {0, 1}, 
           "branchPowers" -> {0, 1}, "gammaArgumentAtMaster" -> 2 + a2|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 1, 
        "vertexIds" -> {1}, "stateBits" -> {1, 1, 0, 0}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {1, 0}, "branchPowers" -> {-1 - I/2, -1/2*I}, 
           "gammaArgumentAtMaster" -> -I + a1|>, <|"branchOrdinal" -> 2, 
           "branchSelection" -> {1, 2}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {1, 0}, "branchPowers" -> {-1 - I/2, 0}, 
           "gammaArgumentAtMaster" -> -1/2*I + a1|>, <|"branchOrdinal" -> 3, 
           "branchSelection" -> {2, 1}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {1, 0}, "branchPowers" -> {1, -1/2*I}, 
           "gammaArgumentAtMaster" -> (2 - I/2) + a1|>, 
          <|"branchOrdinal" -> 4, "branchSelection" -> {2, 2}, 
           "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {1, 0}, 
           "branchPowers" -> {1, 0}, "gammaArgumentAtMaster" -> 2 + a1|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 2, 
        "vertexIds" -> {2}, "stateBits" -> {1, 1, 0, 0}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {1, 0}, "branchPowers" -> {-1 - I/2, -1/2*I}, 
           "gammaArgumentAtMaster" -> -I + a2|>, <|"branchOrdinal" -> 2, 
           "branchSelection" -> {1, 2}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {1, 0}, "branchPowers" -> {-1 - I/2, 0}, 
           "gammaArgumentAtMaster" -> -1/2*I + a2|>, <|"branchOrdinal" -> 3, 
           "branchSelection" -> {2, 1}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {1, 0}, "branchPowers" -> {1, -1/2*I}, 
           "gammaArgumentAtMaster" -> (2 - I/2) + a2|>, 
          <|"branchOrdinal" -> 4, "branchSelection" -> {2, 2}, 
           "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {1, 0}, 
           "branchPowers" -> {1, 0}, "gammaArgumentAtMaster" -> 2 + a2|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 1, 
        "vertexIds" -> {1}, "stateBits" -> {1, 1, 0, 1}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {1, 0}, "branchPowers" -> {-1 - I/2, -1/2*I}, 
           "gammaArgumentAtMaster" -> -I + a1|>, <|"branchOrdinal" -> 2, 
           "branchSelection" -> {1, 2}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {1, 0}, "branchPowers" -> {-1 - I/2, 0}, 
           "gammaArgumentAtMaster" -> -1/2*I + a1|>, <|"branchOrdinal" -> 3, 
           "branchSelection" -> {2, 1}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {1, 0}, "branchPowers" -> {1, -1/2*I}, 
           "gammaArgumentAtMaster" -> (2 - I/2) + a1|>, 
          <|"branchOrdinal" -> 4, "branchSelection" -> {2, 2}, 
           "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {1, 0}, 
           "branchPowers" -> {1, 0}, "gammaArgumentAtMaster" -> 2 + a1|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 2, 
        "vertexIds" -> {2}, "stateBits" -> {1, 1, 0, 1}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {1, 1}, "branchPowers" -> {-1 - I/2, -1 - I/2}, 
           "gammaArgumentAtMaster" -> (-1 - I) + a2|>, 
          <|"branchOrdinal" -> 2, "branchSelection" -> {1, 2}, 
           "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {-1 - I/2, 1}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a2|>, <|"branchOrdinal" -> 3, "branchSelection" -> 
            {2, 1}, "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {1, -1 - I/2}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a2|>, <|"branchOrdinal" -> 4, "branchSelection" -> 
            {2, 2}, "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {1, 1}, "gammaArgumentAtMaster" -> 3 + a2|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 1, 
        "vertexIds" -> {1}, "stateBits" -> {1, 1, 1, 0}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {1, 1}, "branchPowers" -> {-1 - I/2, -1 - I/2}, 
           "gammaArgumentAtMaster" -> (-1 - I) + a1|>, 
          <|"branchOrdinal" -> 2, "branchSelection" -> {1, 2}, 
           "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {-1 - I/2, 1}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a1|>, <|"branchOrdinal" -> 3, "branchSelection" -> 
            {2, 1}, "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {1, -1 - I/2}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a1|>, <|"branchOrdinal" -> 4, "branchSelection" -> 
            {2, 2}, "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {1, 1}, "gammaArgumentAtMaster" -> 3 + a1|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 2, 
        "vertexIds" -> {2}, "stateBits" -> {1, 1, 1, 0}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {1, 0}, "branchPowers" -> {-1 - I/2, -1/2*I}, 
           "gammaArgumentAtMaster" -> -I + a2|>, <|"branchOrdinal" -> 2, 
           "branchSelection" -> {1, 2}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {1, 0}, "branchPowers" -> {-1 - I/2, 0}, 
           "gammaArgumentAtMaster" -> -1/2*I + a2|>, <|"branchOrdinal" -> 3, 
           "branchSelection" -> {2, 1}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {1, 0}, "branchPowers" -> {1, -1/2*I}, 
           "gammaArgumentAtMaster" -> (2 - I/2) + a2|>, 
          <|"branchOrdinal" -> 4, "branchSelection" -> {2, 2}, 
           "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {1, 0}, 
           "branchPowers" -> {1, 0}, "gammaArgumentAtMaster" -> 2 + a2|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 1, 
        "vertexIds" -> {1}, "stateBits" -> {1, 1, 1, 1}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 1}, {2, 1}}, 
           "slotStates" -> {1, 1}, "branchPowers" -> {-1 - I/2, -1 - I/2}, 
           "gammaArgumentAtMaster" -> (-1 - I) + a1|>, 
          <|"branchOrdinal" -> 2, "branchSelection" -> {1, 2}, 
           "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {-1 - I/2, 1}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a1|>, <|"branchOrdinal" -> 3, "branchSelection" -> 
            {2, 1}, "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {1, -1 - I/2}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a1|>, <|"branchOrdinal" -> 4, "branchSelection" -> 
            {2, 2}, "slotKeys" -> {{1, 1}, {2, 1}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {1, 1}, "gammaArgumentAtMaster" -> 3 + a1|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "11", "componentPosition" -> 2, 
        "vertexIds" -> {2}, "stateBits" -> {1, 1, 1, 1}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 2}, {2, 2}}, 
           "slotStates" -> {1, 1}, "branchPowers" -> {-1 - I/2, -1 - I/2}, 
           "gammaArgumentAtMaster" -> (-1 - I) + a2|>, 
          <|"branchOrdinal" -> 2, "branchSelection" -> {1, 2}, 
           "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {-1 - I/2, 1}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a2|>, <|"branchOrdinal" -> 3, "branchSelection" -> 
            {2, 1}, "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {1, -1 - I/2}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a2|>, <|"branchOrdinal" -> 4, "branchSelection" -> 
            {2, 2}, "slotKeys" -> {{1, 2}, {2, 2}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {1, 1}, "gammaArgumentAtMaster" -> 3 + a2|>}, 
        "integerBranchRecords" -> {}, "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "01", "componentPosition" -> 1, 
        "vertexIds" -> {1, 2}, "stateBits" -> {0, 0}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{2, 1}, {2, 2}}, 
           "slotStates" -> {0, 0}, "branchPowers" -> {-1/2*I, -1/2*I}, 
           "gammaArgumentAtMaster" -> (1 - (3*I)/2) + a1 + a2|>, 
          <|"branchOrdinal" -> 2, "branchSelection" -> {1, 2}, 
           "slotKeys" -> {{2, 1}, {2, 2}}, "slotStates" -> {0, 0}, 
           "branchPowers" -> {-1/2*I, 0}, "gammaArgumentAtMaster" -> 
            (1 - I) + a1 + a2|>, <|"branchOrdinal" -> 3, "branchSelection" -> 
            {2, 1}, "slotKeys" -> {{2, 1}, {2, 2}}, "slotStates" -> {0, 0}, 
           "branchPowers" -> {0, -1/2*I}, "gammaArgumentAtMaster" -> 
            (1 - I) + a1 + a2|>, <|"branchOrdinal" -> 4, "branchSelection" -> 
            {2, 2}, "slotKeys" -> {{2, 1}, {2, 2}}, "slotStates" -> {0, 0}, 
           "branchPowers" -> {0, 0}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a1 + a2|>}, "integerBranchRecords" -> {}, 
        "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "01", "componentPosition" -> 1, 
        "vertexIds" -> {1, 2}, "stateBits" -> {0, 1}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{2, 1}, {2, 2}}, 
           "slotStates" -> {0, 1}, "branchPowers" -> {-1/2*I, -1 - I/2}, 
           "gammaArgumentAtMaster" -> (-3*I)/2 + a1 + a2|>, 
          <|"branchOrdinal" -> 2, "branchSelection" -> {1, 2}, 
           "slotKeys" -> {{2, 1}, {2, 2}}, "slotStates" -> {0, 1}, 
           "branchPowers" -> {-1/2*I, 1}, "gammaArgumentAtMaster" -> 
            (2 - I) + a1 + a2|>, <|"branchOrdinal" -> 3, "branchSelection" -> 
            {2, 1}, "slotKeys" -> {{2, 1}, {2, 2}}, "slotStates" -> {0, 1}, 
           "branchPowers" -> {0, -1 - I/2}, "gammaArgumentAtMaster" -> 
            -I + a1 + a2|>, <|"branchOrdinal" -> 4, "branchSelection" -> {2, 
            2}, "slotKeys" -> {{2, 1}, {2, 2}}, "slotStates" -> {0, 1}, 
           "branchPowers" -> {0, 1}, "gammaArgumentAtMaster" -> 
            (2 - I/2) + a1 + a2|>}, "integerBranchRecords" -> {}, 
        "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "01", "componentPosition" -> 1, 
        "vertexIds" -> {1, 2}, "stateBits" -> {1, 1}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{2, 1}, {2, 2}}, 
           "slotStates" -> {1, 1}, "branchPowers" -> {-1 - I/2, -1 - I/2}, 
           "gammaArgumentAtMaster" -> (-1 - (3*I)/2) + a1 + a2|>, 
          <|"branchOrdinal" -> 2, "branchSelection" -> {1, 2}, 
           "slotKeys" -> {{2, 1}, {2, 2}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {-1 - I/2, 1}, "gammaArgumentAtMaster" -> 
            (1 - I) + a1 + a2|>, <|"branchOrdinal" -> 3, "branchSelection" -> 
            {2, 1}, "slotKeys" -> {{2, 1}, {2, 2}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {1, -1 - I/2}, "gammaArgumentAtMaster" -> 
            (1 - I) + a1 + a2|>, <|"branchOrdinal" -> 4, "branchSelection" -> 
            {2, 2}, "slotKeys" -> {{2, 1}, {2, 2}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {1, 1}, "gammaArgumentAtMaster" -> 
            (3 - I/2) + a1 + a2|>}, "integerBranchRecords" -> {}, 
        "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "10", "componentPosition" -> 1, 
        "vertexIds" -> {1, 2}, "stateBits" -> {0, 0}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 1}, {1, 2}}, 
           "slotStates" -> {0, 0}, "branchPowers" -> {-1/2*I, -1/2*I}, 
           "gammaArgumentAtMaster" -> (1 - (3*I)/2) + a1 + a2|>, 
          <|"branchOrdinal" -> 2, "branchSelection" -> {1, 2}, 
           "slotKeys" -> {{1, 1}, {1, 2}}, "slotStates" -> {0, 0}, 
           "branchPowers" -> {-1/2*I, 0}, "gammaArgumentAtMaster" -> 
            (1 - I) + a1 + a2|>, <|"branchOrdinal" -> 3, "branchSelection" -> 
            {2, 1}, "slotKeys" -> {{1, 1}, {1, 2}}, "slotStates" -> {0, 0}, 
           "branchPowers" -> {0, -1/2*I}, "gammaArgumentAtMaster" -> 
            (1 - I) + a1 + a2|>, <|"branchOrdinal" -> 4, "branchSelection" -> 
            {2, 2}, "slotKeys" -> {{1, 1}, {1, 2}}, "slotStates" -> {0, 0}, 
           "branchPowers" -> {0, 0}, "gammaArgumentAtMaster" -> 
            (1 - I/2) + a1 + a2|>}, "integerBranchRecords" -> {}, 
        "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "10", "componentPosition" -> 1, 
        "vertexIds" -> {1, 2}, "stateBits" -> {0, 1}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 1}, {1, 2}}, 
           "slotStates" -> {0, 1}, "branchPowers" -> {-1/2*I, -1 - I/2}, 
           "gammaArgumentAtMaster" -> (-3*I)/2 + a1 + a2|>, 
          <|"branchOrdinal" -> 2, "branchSelection" -> {1, 2}, 
           "slotKeys" -> {{1, 1}, {1, 2}}, "slotStates" -> {0, 1}, 
           "branchPowers" -> {-1/2*I, 1}, "gammaArgumentAtMaster" -> 
            (2 - I) + a1 + a2|>, <|"branchOrdinal" -> 3, "branchSelection" -> 
            {2, 1}, "slotKeys" -> {{1, 1}, {1, 2}}, "slotStates" -> {0, 1}, 
           "branchPowers" -> {0, -1 - I/2}, "gammaArgumentAtMaster" -> 
            -I + a1 + a2|>, <|"branchOrdinal" -> 4, "branchSelection" -> {2, 
            2}, "slotKeys" -> {{1, 1}, {1, 2}}, "slotStates" -> {0, 1}, 
           "branchPowers" -> {0, 1}, "gammaArgumentAtMaster" -> 
            (2 - I/2) + a1 + a2|>}, "integerBranchRecords" -> {}, 
        "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>, <|"sectorKey" -> "10", "componentPosition" -> 1, 
        "vertexIds" -> {1, 2}, "stateBits" -> {1, 1}, "hCount" -> 2, 
        "branchCount" -> 4, "branchRecords" -> {<|"branchOrdinal" -> 1, 
           "branchSelection" -> {1, 1}, "slotKeys" -> {{1, 1}, {1, 2}}, 
           "slotStates" -> {1, 1}, "branchPowers" -> {-1 - I/2, -1 - I/2}, 
           "gammaArgumentAtMaster" -> (-1 - (3*I)/2) + a1 + a2|>, 
          <|"branchOrdinal" -> 2, "branchSelection" -> {1, 2}, 
           "slotKeys" -> {{1, 1}, {1, 2}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {-1 - I/2, 1}, "gammaArgumentAtMaster" -> 
            (1 - I) + a1 + a2|>, <|"branchOrdinal" -> 3, "branchSelection" -> 
            {2, 1}, "slotKeys" -> {{1, 1}, {1, 2}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {1, -1 - I/2}, "gammaArgumentAtMaster" -> 
            (1 - I) + a1 + a2|>, <|"branchOrdinal" -> 4, "branchSelection" -> 
            {2, 2}, "slotKeys" -> {{1, 1}, {1, 2}}, "slotStates" -> {1, 1}, 
           "branchPowers" -> {1, 1}, "gammaArgumentAtMaster" -> 
            (3 - I/2) + a1 + a2|>}, "integerBranchRecords" -> {}, 
        "positiveIntegerBranchRecords" -> {}, 
        "nonPositiveIntegerBranchRecords" -> {}, "minimumSafeShift" -> 
         -Infinity|>}, "invalidMasterComponents" -> {}|>, 
   "rootNormalization" -> 1, "capabilities" -> <|"formulaRecurrence" -> True, 
     "formulaDLog" -> True, "simultaneousContact" -> True, 
     "timeOnlyCycles" -> True, "automaticEuclideanBoundary" -> False, 
     "asymptoticBoundaryFormula" -> "2411GenericSectorFrobenius"|>|>, 
 "masters" -> {<|"sectorKey" -> "11", "sectorOffset" -> 1, 
    "globalIndex" -> 1, "stateBits" -> {0, 0, 0, 0}, 
    "integral" -> MSIntegral["11", {0, 0}, {0, 0, 0, 0}], 
    "normalization" -> 1, "bareIntegral" -> MSBareIntegral["11", {0, 0}, {0, 
      0, 0, 0}], "definition" -> HoldForm[MSIntegral["11", {0, 0}, {0, 0, 0, 
        0}] == MSBareIntegral["11", {0, 0}, {0, 0, 0, 0}]]|>, 
   <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 2, 
    "stateBits" -> {0, 0, 0, 1}, "integral" -> MSIntegral["11", {0, 0}, {0, 
      0, 0, 1}], "normalization" -> 1, "bareIntegral" -> 
     MSBareIntegral["11", {0, 0}, {0, 0, 0, 1}], 
    "definition" -> HoldForm[MSIntegral["11", {0, 0}, {0, 0, 0, 1}] == 
       MSBareIntegral["11", {0, 0}, {0, 0, 0, 1}]]|>, 
   <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 3, 
    "stateBits" -> {0, 0, 1, 0}, "integral" -> MSIntegral["11", {0, 0}, {0, 
      0, 1, 0}], "normalization" -> 1, "bareIntegral" -> 
     MSBareIntegral["11", {0, 0}, {0, 0, 1, 0}], 
    "definition" -> HoldForm[MSIntegral["11", {0, 0}, {0, 0, 1, 0}] == 
       MSBareIntegral["11", {0, 0}, {0, 0, 1, 0}]]|>, 
   <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 4, 
    "stateBits" -> {0, 0, 1, 1}, "integral" -> MSIntegral["11", {0, 0}, {0, 
      0, 1, 1}], "normalization" -> 1, "bareIntegral" -> 
     MSBareIntegral["11", {0, 0}, {0, 0, 1, 1}], 
    "definition" -> HoldForm[MSIntegral["11", {0, 0}, {0, 0, 1, 1}] == 
       MSBareIntegral["11", {0, 0}, {0, 0, 1, 1}]]|>, 
   <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 5, 
    "stateBits" -> {0, 1, 0, 0}, "integral" -> MSIntegral["11", {0, 0}, {0, 
      1, 0, 0}], "normalization" -> 1, "bareIntegral" -> 
     MSBareIntegral["11", {0, 0}, {0, 1, 0, 0}], 
    "definition" -> HoldForm[MSIntegral["11", {0, 0}, {0, 1, 0, 0}] == 
       MSBareIntegral["11", {0, 0}, {0, 1, 0, 0}]]|>, 
   <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 6, 
    "stateBits" -> {0, 1, 0, 1}, "integral" -> MSIntegral["11", {0, 0}, {0, 
      1, 0, 1}], "normalization" -> 1, "bareIntegral" -> 
     MSBareIntegral["11", {0, 0}, {0, 1, 0, 1}], 
    "definition" -> HoldForm[MSIntegral["11", {0, 0}, {0, 1, 0, 1}] == 
       MSBareIntegral["11", {0, 0}, {0, 1, 0, 1}]]|>, 
   <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 7, 
    "stateBits" -> {0, 1, 1, 0}, "integral" -> MSIntegral["11", {0, 0}, {0, 
      1, 1, 0}], "normalization" -> 1, "bareIntegral" -> 
     MSBareIntegral["11", {0, 0}, {0, 1, 1, 0}], 
    "definition" -> HoldForm[MSIntegral["11", {0, 0}, {0, 1, 1, 0}] == 
       MSBareIntegral["11", {0, 0}, {0, 1, 1, 0}]]|>, 
   <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 8, 
    "stateBits" -> {0, 1, 1, 1}, "integral" -> MSIntegral["11", {0, 0}, {0, 
      1, 1, 1}], "normalization" -> 1, "bareIntegral" -> 
     MSBareIntegral["11", {0, 0}, {0, 1, 1, 1}], 
    "definition" -> HoldForm[MSIntegral["11", {0, 0}, {0, 1, 1, 1}] == 
       MSBareIntegral["11", {0, 0}, {0, 1, 1, 1}]]|>, 
   <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 9, 
    "stateBits" -> {1, 0, 0, 0}, "integral" -> MSIntegral["11", {0, 0}, {1, 
      0, 0, 0}], "normalization" -> 1, "bareIntegral" -> 
     MSBareIntegral["11", {0, 0}, {1, 0, 0, 0}], 
    "definition" -> HoldForm[MSIntegral["11", {0, 0}, {1, 0, 0, 0}] == 
       MSBareIntegral["11", {0, 0}, {1, 0, 0, 0}]]|>, 
   <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 10, 
    "stateBits" -> {1, 0, 0, 1}, "integral" -> MSIntegral["11", {0, 0}, {1, 
      0, 0, 1}], "normalization" -> 1, "bareIntegral" -> 
     MSBareIntegral["11", {0, 0}, {1, 0, 0, 1}], 
    "definition" -> HoldForm[MSIntegral["11", {0, 0}, {1, 0, 0, 1}] == 
       MSBareIntegral["11", {0, 0}, {1, 0, 0, 1}]]|>, 
   <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 11, 
    "stateBits" -> {1, 0, 1, 0}, "integral" -> MSIntegral["11", {0, 0}, {1, 
      0, 1, 0}], "normalization" -> 1, "bareIntegral" -> 
     MSBareIntegral["11", {0, 0}, {1, 0, 1, 0}], 
    "definition" -> HoldForm[MSIntegral["11", {0, 0}, {1, 0, 1, 0}] == 
       MSBareIntegral["11", {0, 0}, {1, 0, 1, 0}]]|>, 
   <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 12, 
    "stateBits" -> {1, 0, 1, 1}, "integral" -> MSIntegral["11", {0, 0}, {1, 
      0, 1, 1}], "normalization" -> 1, "bareIntegral" -> 
     MSBareIntegral["11", {0, 0}, {1, 0, 1, 1}], 
    "definition" -> HoldForm[MSIntegral["11", {0, 0}, {1, 0, 1, 1}] == 
       MSBareIntegral["11", {0, 0}, {1, 0, 1, 1}]]|>, 
   <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 13, 
    "stateBits" -> {1, 1, 0, 0}, "integral" -> MSIntegral["11", {0, 0}, {1, 
      1, 0, 0}], "normalization" -> 1, "bareIntegral" -> 
     MSBareIntegral["11", {0, 0}, {1, 1, 0, 0}], 
    "definition" -> HoldForm[MSIntegral["11", {0, 0}, {1, 1, 0, 0}] == 
       MSBareIntegral["11", {0, 0}, {1, 1, 0, 0}]]|>, 
   <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 14, 
    "stateBits" -> {1, 1, 0, 1}, "integral" -> MSIntegral["11", {0, 0}, {1, 
      1, 0, 1}], "normalization" -> 1, "bareIntegral" -> 
     MSBareIntegral["11", {0, 0}, {1, 1, 0, 1}], 
    "definition" -> HoldForm[MSIntegral["11", {0, 0}, {1, 1, 0, 1}] == 
       MSBareIntegral["11", {0, 0}, {1, 1, 0, 1}]]|>, 
   <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 15, 
    "stateBits" -> {1, 1, 1, 0}, "integral" -> MSIntegral["11", {0, 0}, {1, 
      1, 1, 0}], "normalization" -> 1, "bareIntegral" -> 
     MSBareIntegral["11", {0, 0}, {1, 1, 1, 0}], 
    "definition" -> HoldForm[MSIntegral["11", {0, 0}, {1, 1, 1, 0}] == 
       MSBareIntegral["11", {0, 0}, {1, 1, 1, 0}]]|>, 
   <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 16, 
    "stateBits" -> {1, 1, 1, 1}, "integral" -> MSIntegral["11", {0, 0}, {1, 
      1, 1, 1}], "normalization" -> 1, "bareIntegral" -> 
     MSBareIntegral["11", {0, 0}, {1, 1, 1, 1}], 
    "definition" -> HoldForm[MSIntegral["11", {0, 0}, {1, 1, 1, 1}] == 
       MSBareIntegral["11", {0, 0}, {1, 1, 1, 1}]]|>, 
   <|"sectorKey" -> "01", "sectorOffset" -> 17, "globalIndex" -> 17, 
    "stateBits" -> {0, 0}, "integral" -> MSIntegral["01", {0}, {0, 0}], 
    "normalization" -> (4*I)/(Pi*x1^(1 + I/2)), "bareIntegral" -> 
     MSBareIntegral["01", {0}, {0, 0}], "definition" -> 
     HoldForm[MSIntegral["01", {0}, {0, 0}] == ((4*I)/(Pi*x1^(1 + I/2)))*
        MSBareIntegral["01", {0}, {0, 0}]]|>, <|"sectorKey" -> "01", 
    "sectorOffset" -> 17, "globalIndex" -> 18, "stateBits" -> {0, 1}, 
    "integral" -> MSIntegral["01", {0}, {0, 1}], 
    "normalization" -> (4*I)/(Pi*x1^(1 + I/2)), "bareIntegral" -> 
     MSBareIntegral["01", {0}, {0, 1}], "definition" -> 
     HoldForm[MSIntegral["01", {0}, {0, 1}] == ((4*I)/(Pi*x1^(1 + I/2)))*
        MSBareIntegral["01", {0}, {0, 1}]]|>, <|"sectorKey" -> "01", 
    "sectorOffset" -> 17, "globalIndex" -> 19, "stateBits" -> {1, 1}, 
    "integral" -> MSIntegral["01", {0}, {1, 1}], 
    "normalization" -> (4*I)/(Pi*x1^(1 + I/2)), "bareIntegral" -> 
     MSBareIntegral["01", {0}, {1, 1}], "definition" -> 
     HoldForm[MSIntegral["01", {0}, {1, 1}] == ((4*I)/(Pi*x1^(1 + I/2)))*
        MSBareIntegral["01", {0}, {1, 1}]]|>, <|"sectorKey" -> "10", 
    "sectorOffset" -> 20, "globalIndex" -> 20, "stateBits" -> {0, 0}, 
    "integral" -> MSIntegral["10", {0}, {0, 0}], 
    "normalization" -> (4*I)/(Pi*x2^(1 + I/2)), "bareIntegral" -> 
     MSBareIntegral["10", {0}, {0, 0}], "definition" -> 
     HoldForm[MSIntegral["10", {0}, {0, 0}] == ((4*I)/(Pi*x2^(1 + I/2)))*
        MSBareIntegral["10", {0}, {0, 0}]]|>, <|"sectorKey" -> "10", 
    "sectorOffset" -> 20, "globalIndex" -> 21, "stateBits" -> {0, 1}, 
    "integral" -> MSIntegral["10", {0}, {0, 1}], 
    "normalization" -> (4*I)/(Pi*x2^(1 + I/2)), "bareIntegral" -> 
     MSBareIntegral["10", {0}, {0, 1}], "definition" -> 
     HoldForm[MSIntegral["10", {0}, {0, 1}] == ((4*I)/(Pi*x2^(1 + I/2)))*
        MSBareIntegral["10", {0}, {0, 1}]]|>, <|"sectorKey" -> "10", 
    "sectorOffset" -> 20, "globalIndex" -> 22, "stateBits" -> {1, 1}, 
    "integral" -> MSIntegral["10", {0}, {1, 1}], 
    "normalization" -> (4*I)/(Pi*x2^(1 + I/2)), "bareIntegral" -> 
     MSBareIntegral["10", {0}, {1, 1}], "definition" -> 
     HoldForm[MSIntegral["10", {0}, {1, 1}] == ((4*I)/(Pi*x2^(1 + I/2)))*
        MSBareIntegral["10", {0}, {1, 1}]]|>}, 
 "de" -> <|"status" -> "generated", "dlogStatus" -> 
    "certifiedByFormulaChecks", "convention" -> <|"timePower" -> "(-tau)^A", 
     "functionBasis" -> "h", "nuConvention" -> "Negative", 
     "hDefinition" -> "z^-nu H_nu", "paperFormulaReplacement" -> 
      "nuPaper -> nu"|>, "sectorOrder" -> {"11", "01", "10"}, 
   "sectorDimensions" -> {16, 3, 3}, "masterSectorOffsets" -> 
    <|"11" -> 1, "01" -> 17, "10" -> 20|>, 
   "masters" -> {<|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 1, "stateBits" -> {0, 0, 0, 0}, 
      "integral" -> MSIntegral["11", {0, 0}, {0, 0, 0, 0}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 2, "stateBits" -> {0, 0, 0, 1}, 
      "integral" -> MSIntegral["11", {0, 0}, {0, 0, 0, 1}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 3, "stateBits" -> {0, 0, 1, 0}, 
      "integral" -> MSIntegral["11", {0, 0}, {0, 0, 1, 0}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 4, "stateBits" -> {0, 0, 1, 1}, 
      "integral" -> MSIntegral["11", {0, 0}, {0, 0, 1, 1}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 5, "stateBits" -> {0, 1, 0, 0}, 
      "integral" -> MSIntegral["11", {0, 0}, {0, 1, 0, 0}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 6, "stateBits" -> {0, 1, 0, 1}, 
      "integral" -> MSIntegral["11", {0, 0}, {0, 1, 0, 1}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 7, "stateBits" -> {0, 1, 1, 0}, 
      "integral" -> MSIntegral["11", {0, 0}, {0, 1, 1, 0}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 8, "stateBits" -> {0, 1, 1, 1}, 
      "integral" -> MSIntegral["11", {0, 0}, {0, 1, 1, 1}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 9, "stateBits" -> {1, 0, 0, 0}, 
      "integral" -> MSIntegral["11", {0, 0}, {1, 0, 0, 0}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 10, "stateBits" -> {1, 0, 0, 1}, 
      "integral" -> MSIntegral["11", {0, 0}, {1, 0, 0, 1}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 11, "stateBits" -> {1, 0, 1, 0}, 
      "integral" -> MSIntegral["11", {0, 0}, {1, 0, 1, 0}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 12, "stateBits" -> {1, 0, 1, 1}, 
      "integral" -> MSIntegral["11", {0, 0}, {1, 0, 1, 1}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 13, "stateBits" -> {1, 1, 0, 0}, 
      "integral" -> MSIntegral["11", {0, 0}, {1, 1, 0, 0}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 14, "stateBits" -> {1, 1, 0, 1}, 
      "integral" -> MSIntegral["11", {0, 0}, {1, 1, 0, 1}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 15, "stateBits" -> {1, 1, 1, 0}, 
      "integral" -> MSIntegral["11", {0, 0}, {1, 1, 1, 0}], 
      "normalization" -> 1|>, <|"sectorKey" -> "11", "sectorOffset" -> 1, 
      "globalIndex" -> 16, "stateBits" -> {1, 1, 1, 1}, 
      "integral" -> MSIntegral["11", {0, 0}, {1, 1, 1, 1}], 
      "normalization" -> 1|>, <|"sectorKey" -> "01", "sectorOffset" -> 17, 
      "globalIndex" -> 17, "stateBits" -> {0, 0}, 
      "integral" -> MSIntegral["01", {0}, {0, 0}], "normalization" -> 
       (4*I)/(Pi*x1^(1 + I/2))|>, <|"sectorKey" -> "01", 
      "sectorOffset" -> 17, "globalIndex" -> 18, "stateBits" -> {0, 1}, 
      "integral" -> MSIntegral["01", {0}, {0, 1}], "normalization" -> 
       (4*I)/(Pi*x1^(1 + I/2))|>, <|"sectorKey" -> "01", 
      "sectorOffset" -> 17, "globalIndex" -> 19, "stateBits" -> {1, 1}, 
      "integral" -> MSIntegral["01", {0}, {1, 1}], "normalization" -> 
       (4*I)/(Pi*x1^(1 + I/2))|>, <|"sectorKey" -> "10", 
      "sectorOffset" -> 20, "globalIndex" -> 20, "stateBits" -> {0, 0}, 
      "integral" -> MSIntegral["10", {0}, {0, 0}], "normalization" -> 
       (4*I)/(Pi*x2^(1 + I/2))|>, <|"sectorKey" -> "10", 
      "sectorOffset" -> 20, "globalIndex" -> 21, "stateBits" -> {0, 1}, 
      "integral" -> MSIntegral["10", {0}, {0, 1}], "normalization" -> 
       (4*I)/(Pi*x2^(1 + I/2))|>, <|"sectorKey" -> "10", 
      "sectorOffset" -> 20, "globalIndex" -> 22, "stateBits" -> {1, 1}, 
      "integral" -> MSIntegral["10", {0}, {1, 1}], "normalization" -> 
       (4*I)/(Pi*x2^(1 + I/2))|>}, "bareMasters" -> 
    {MSIntegral["11", {0, 0}, {0, 0, 0, 0}], MSIntegral["11", {0, 0}, {0, 0, 
      0, 1}], MSIntegral["11", {0, 0}, {0, 0, 1, 0}], 
     MSIntegral["11", {0, 0}, {0, 0, 1, 1}], MSIntegral["11", {0, 0}, {0, 1, 
      0, 0}], MSIntegral["11", {0, 0}, {0, 1, 0, 1}], 
     MSIntegral["11", {0, 0}, {0, 1, 1, 0}], MSIntegral["11", {0, 0}, {0, 1, 
      1, 1}], MSIntegral["11", {0, 0}, {1, 0, 0, 0}], 
     MSIntegral["11", {0, 0}, {1, 0, 0, 1}], MSIntegral["11", {0, 0}, {1, 0, 
      1, 0}], MSIntegral["11", {0, 0}, {1, 0, 1, 1}], 
     MSIntegral["11", {0, 0}, {1, 1, 0, 0}], MSIntegral["11", {0, 0}, {1, 1, 
      0, 1}], MSIntegral["11", {0, 0}, {1, 1, 1, 0}], 
     MSIntegral["11", {0, 0}, {1, 1, 1, 1}], MSIntegral["01", {0}, {0, 0}], 
     MSIntegral["01", {0}, {0, 1}], MSIntegral["01", {0}, {1, 1}], 
     MSIntegral["10", {0}, {0, 0}], MSIntegral["10", {0}, {0, 1}], 
     MSIntegral["10", {0}, {1, 1}]}, "masterCount" -> 22, 
   "masterDigest" -> 
    "20a0e98060a1615a0e4fe237cf561e9e5791806057b162e599e93b6a686ae5bc", 
   "sectorBlocks" -> {<|"sectorKey" -> "11", "dimension" -> 16, 
      "omega" -> {{(-((1 + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
              Log[k1 - x1 + x2] + Log[k1 + x1 + x2])) - 
           (1 + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
             Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 
         ((1 + (2*I)*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/8, 
         ((1 + (2*I)*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/8, 0, 
         ((1 + (2*I)*a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/8, 
         (((-1 - I) + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
            Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 0, 0, 
         ((1 + (2*I)*a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/8, 0, 
         (((-1 - I) + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
            Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/4, 0, 0, 0, 0, 0}, 
        {(-1/4*I)*(1 + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
         ((-4 - 2*I)*Log[x2] - (1 + a1)*(Log[k1 - x1 - x2] + 
             Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + Log[k1 + x1 + x2]) - 
           ((-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
              Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/2)/4, 0, 
         ((1 + (2*I)*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/8, 
         ((-1/2*I + a2)*(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/4, (I/4)*((-1 - I) + a2)*
          (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2]), 0, 0, 0, ((1 + (2*I)*a1)*(Log[k1 - x1 - x2] - 
            Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/8, 0, 
         (((-1 - I) + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
            Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/4, 0, 0, 0, 0}, 
        {(-1/4*I)*(1 + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
         ((-4 - 2*I)*Log[x2] - ((-I + 2*a1)*(Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/2 - 
           (1 + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
             Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 
         ((1 + (2*I)*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/8, 0, 0, 
         ((1 + (2*I)*a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/8, 
         (((-1 - I) + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
            Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 
         ((-1/2*I + a1)*(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/4, 0, 
         (I/4)*((-1 - I) + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 0, 0, 0}, 
        {0, (-1/4*I)*(1 + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), (-1/4*I)*(1 + a2)*
          (Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2]), (-2 - I)*Log[x2] - 
          ((-I + 2*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
             Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/8 - 
          ((-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
             Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/8, 0, 0, 
         ((-1/2*I + a2)*(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/4, (I/4)*((-1 - I) + a2)*
          (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2]), 0, ((-1/2*I + a1)*(-Log[k1 - x1 - x2] + 
            Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/4, 0, 
         (I/4)*((-1 - I) + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 0, 0}, 
        {(-1/4*I)*(1 + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
         ((-1/2*I + a2)*(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/4, 0, 0, 
         ((-4 - 2*I)*Log[x1] - (1 + a1)*(Log[k1 - x1 - x2] + 
             Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + Log[k1 + x1 + x2]) - 
           ((-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
              Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/2)/4, 
         (I/4)*((-1 - I) + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
         ((1 + (2*I)*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/8, 0, 0, 0, 0, 0, 
         ((1 + (2*I)*a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/8, 0, 
         (((-1 - I) + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
            Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/4, 0}, 
        {((1 + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
            Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, (-1/8*I)*(-I + 2*a2)*
          (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2]), 0, 0, (-1/8*I)*(-I + 2*a2)*
          (Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2]), ((-4 - 2*I)*Log[x1] - (4 + 2*I)*Log[x2] - 
           (1 + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
             Log[k1 - x1 + x2] + Log[k1 + x1 + x2]) - ((-1 - I) + a2)*
            (Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] + 
             Log[k2 + x1 + x2]))/4, 0, ((1 + (2*I)*a1)*(Log[k1 - x1 - x2] + 
            Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/8, 0, 
         0, 0, 0, 0, ((1 + (2*I)*a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/8, 0, 
         (((-1 - I) + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
            Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/4}, 
        {0, 0, (-1/4*I)*(1 + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
         ((-1/2*I + a2)*(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/4, (-1/4*I)*(1 + a1)*
          (Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
           Log[k1 + x1 + x2]), 0, ((-4 - 2*I)*Log[x1] - (4 + 2*I)*Log[x2] - 
           ((-I + 2*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
              Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/2 - 
           ((-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
              Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/2)/4, 
         (I/4)*((-1 - I) + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 0, 0, 0, 0, 
         ((-1/2*I + a1)*(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/4, 0, 
         (I/4)*((-1 - I) + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0}, 
        {0, 0, ((1 + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
            Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, (-1/8*I)*(-I + 2*a2)*
          (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2]), 0, (-1/4*I)*(1 + a1)*(Log[k1 - x1 - x2] + 
           Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
         (-1/8*I)*(-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
         ((-4 - 2*I)*Log[x1] - (8 + 4*I)*Log[x2] - 
           ((-I + 2*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
              Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/2 - 
           ((-1 - I) + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
             Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 0, 0, 0, 0, 0, 
         ((-1/2*I + a1)*(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/4, 0, 
         (I/4)*((-1 - I) + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2])}, 
        {(-1/4*I)*(1 + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
         ((-1/2*I + a1)*(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/4, 0, 0, 0, 0, 0, 
         ((-4 - 2*I)*Log[x1] - ((-I + 2*a1)*(Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/2 - 
           (1 + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
             Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 
         ((1 + (2*I)*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/8, (I/4)*((-1 - I) + a1)*
          (Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
           Log[k1 + x1 + x2]), 0, ((1 + (2*I)*a2)*(Log[k2 - x1 - x2] - 
            Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/8, 
         (((-1 - I) + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
            Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 0, 0}, 
        {0, (-1/4*I)*(1 + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
         ((-1/2*I + a1)*(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/4, 0, 0, 0, 0, 
         (-1/4*I)*(1 + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
         ((-4 - 2*I)*Log[x1] - (4 + 2*I)*Log[x2] - 
           ((-I + 2*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
              Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/2 - 
           ((-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
              Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/2)/4, 0, 
         (I/4)*((-1 - I) + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
         ((-1/2*I + a2)*(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/4, (I/4)*((-1 - I) + a2)*
          (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2]), 0, 0}, 
        {((1 + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
            Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/4, 0, 
         (-1/8*I)*(-I + 2*a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 0, 0, 0, 
         (-1/8*I)*(-I + 2*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
         ((-4 - 2*I)*Log[x1] - (4 + 2*I)*Log[x2] - ((-1 - I) + a1)*
            (Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + 
             Log[k1 + x1 + x2]) - (1 + a2)*(Log[k2 - x1 - x2] + 
             Log[k2 + x1 - x2] + Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 
         ((1 + (2*I)*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/8, 0, 0, 
         ((1 + (2*I)*a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/8, 
         (((-1 - I) + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
            Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4}, 
        {0, ((1 + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
            Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/4, 0, 
         (-1/8*I)*(-I + 2*a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 0, 0, 0, 
         (-1/8*I)*(-I + 2*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), (-1/4*I)*(1 + a2)*
          (Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2]), ((-4 - 2*I)*Log[x1] - (8 + 4*I)*Log[x2] - 
           ((-1 - I) + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
             Log[k1 - x1 + x2] + Log[k1 + x1 + x2]) - 
           ((-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
              Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/2)/4, 0, 0, 
         ((-1/2*I + a2)*(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/4, (I/4)*((-1 - I) + a2)*
          (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2])}, {0, 0, 0, 0, (-1/4*I)*(1 + a1)*
          (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
           Log[k1 + x1 + x2]), 0, ((-1/2*I + a1)*(-Log[k1 - x1 - x2] + 
            Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/4, 0, 
         (-1/4*I)*(1 + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
         ((-1/2*I + a2)*(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/4, 0, 0, 
         (-2 - I)*Log[x1] - ((-I + 2*a1)*(Log[k1 - x1 - x2] + 
             Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/8 - 
          ((-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
             Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/8, (I/4)*((-1 - I) + a2)*
          (Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2]), (I/4)*((-1 - I) + a1)*(Log[k1 - x1 - x2] + 
           Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0}, 
        {0, 0, 0, 0, 0, (-1/4*I)*(1 + a1)*(Log[k1 - x1 - x2] - 
           Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
         ((-1/2*I + a1)*(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/4, 
         ((1 + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
            Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, (-1/8*I)*(-I + 2*a2)*
          (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2]), 0, 0, (-1/8*I)*(-I + 2*a2)*
          (Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2]), ((-8 - 4*I)*Log[x1] - (4 + 2*I)*Log[x2] - 
           ((-I + 2*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
              Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/2 - 
           ((-1 - I) + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
             Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 0, 
         (I/4)*((-1 - I) + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2])}, 
        {0, 0, 0, 0, ((1 + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
            Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/4, 0, 
         (-1/8*I)*(-I + 2*a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 0, 
         (-1/4*I)*(1 + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
         ((-1/2*I + a2)*(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/4, (-1/8*I)*(-I + 2*a1)*
          (Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
           Log[k1 + x1 + x2]), 0, ((-8 - 4*I)*Log[x1] - (4 + 2*I)*Log[x2] - 
           ((-1 - I) + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
             Log[k1 - x1 + x2] + Log[k1 + x1 + x2]) - 
           ((-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
              Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/2)/4, 
         (I/4)*((-1 - I) + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2])}, {0, 0, 0, 0, 0, 
         ((1 + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
            Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/4, 0, 
         (-1/8*I)*(-I + 2*a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 
         ((1 + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
            Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, (-1/8*I)*(-I + 2*a2)*
          (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2]), 0, (-1/8*I)*(-I + 2*a1)*(Log[k1 - x1 - x2] + 
           Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
         (-1/8*I)*(-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
         ((-8 - 4*I)*Log[x1] - (8 + 4*I)*Log[x2] - ((-1 - I) + a1)*
            (Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + 
             Log[k1 + x1 + x2]) - ((-1 - I) + a2)*(Log[k2 - x1 - x2] + 
             Log[k2 + x1 - x2] + Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4}}, 
      "omegaEx" -> {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
        {0, (-1 - I/2)*Log[x2], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, (-1 - I/2)*Log[x2], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 0, (-2 - I)*Log[x2], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 0, 0, (-1 - I/2)*Log[x1], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, (-1 - I/2)*Log[x1] - (1 + I/2)*Log[x2], 0, 0, 0, 0, 
         0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, (-1 - I/2)*Log[x1] - 
          (1 + I/2)*Log[x2], 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0, (-1 - I/2)*Log[x1] - (2 + I)*Log[x2], 0, 0, 0, 
         0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, (-1 - I/2)*Log[x1], 0, 0, 
         0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, (-1 - I/2)*Log[x1] - 
          (1 + I/2)*Log[x2], 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 
         0, (-1 - I/2)*Log[x1] - (1 + I/2)*Log[x2], 0, 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (-1 - I/2)*Log[x1] - 
          (2 + I)*Log[x2], 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         (-2 - I)*Log[x1], 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         (-2 - I)*Log[x1] - (1 + I/2)*Log[x2], 0, 0}, {0, 0, 0, 0, 0, 0, 0, 
         0, 0, 0, 0, 0, 0, 0, (-2 - I)*Log[x1] - (1 + I/2)*Log[x2], 0}, 
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (-2 - I)*Log[x1] - 
          (2 + I)*Log[x2]}}, "normalizationGauge" -> {{0, 0, 0, 0, 0, 0, 0, 
       0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
       0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
       0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 
       0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
       0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
       0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 
       0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
       0}}, "componentLogKernels" -> 
       {{{(-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
            Log[k1 + x1 + x2])/4, 0, (I/4)*(Log[k1 - x1 - x2] + 
            Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 
          0, 0, 0, (I/4)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
          (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
            Log[k1 + x1 + x2])/4, 0, 0, 0, 0, 0}, 
         {0, (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
            Log[k1 + x1 + x2])/4, 0, (I/4)*(Log[k1 - x1 - x2] + 
            Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 
          0, 0, 0, (I/4)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
          (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
            Log[k1 + x1 + x2])/4, 0, 0, 0, 0}, 
         {(-1/4*I)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
          (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
            Log[k1 + x1 + x2])/4, 0, 0, 0, 0, 0, 
          (-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
            Log[k1 + x1 + x2])/4, 0, (I/4)*(Log[k1 - x1 - x2] - 
            Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 
          0, 0, 0}, {0, (-1/4*I)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
          (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
            Log[k1 + x1 + x2])/4, 0, 0, 0, 0, 0, 
          (-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
            Log[k1 + x1 + x2])/4, 0, (I/4)*(Log[k1 - x1 - x2] - 
            Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 
          0, 0}, {0, 0, 0, 0, (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2])/4, 0, 
          (I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
            Log[k1 + x1 + x2]), 0, 0, 0, 0, 0, (I/4)*(Log[k1 - x1 - x2] - 
            Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
          (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
            Log[k1 + x1 + x2])/4, 0}, {0, 0, 0, 0, 0, 
          (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
            Log[k1 + x1 + x2])/4, 0, (I/4)*(Log[k1 - x1 - x2] + 
            Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 
          0, 0, 0, (I/4)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
          (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
            Log[k1 + x1 + x2])/4}, {0, 0, 0, 0, (-1/4*I)*(Log[k1 - x1 - x2] + 
            Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
          (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
            Log[k1 + x1 + x2])/4, 0, 0, 0, 0, 0, 
          (-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
            Log[k1 + x1 + x2])/4, 0, (I/4)*(Log[k1 - x1 - x2] - 
            Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0}, 
         {0, 0, 0, 0, 0, (-1/4*I)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
          (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
            Log[k1 + x1 + x2])/4, 0, 0, 0, 0, 0, 
          (-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
            Log[k1 + x1 + x2])/4, 0, (I/4)*(Log[k1 - x1 - x2] - 
            Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2])}, 
         {(-1/4*I)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
          (-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
            Log[k1 + x1 + x2])/4, 0, 0, 0, 0, 0, 
          (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
            Log[k1 + x1 + x2])/4, 0, (I/4)*(Log[k1 - x1 - x2] + 
            Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 
          0, 0, 0}, {0, (-1/4*I)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
          (-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
            Log[k1 + x1 + x2])/4, 0, 0, 0, 0, 0, 
          (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
            Log[k1 + x1 + x2])/4, 0, (I/4)*(Log[k1 - x1 - x2] + 
            Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 
          0, 0}, {(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
            Log[k1 - x1 + x2] + Log[k1 + x1 + x2])/4, 0, 
          (-1/4*I)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 0, 0, 0, 
          (-1/4*I)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
          (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
            Log[k1 + x1 + x2])/4, 0, 0, 0, 0, 0}, 
         {0, (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
            Log[k1 + x1 + x2])/4, 0, (-1/4*I)*(Log[k1 - x1 - x2] - 
            Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 
          0, 0, 0, (-1/4*I)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
          (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
            Log[k1 + x1 + x2])/4, 0, 0, 0, 0}, {0, 0, 0, 0, 
          (-1/4*I)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
          (-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
            Log[k1 + x1 + x2])/4, 0, 0, 0, 0, 0, 
          (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
            Log[k1 + x1 + x2])/4, 0, (I/4)*(Log[k1 - x1 - x2] + 
            Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0}, 
         {0, 0, 0, 0, 0, (-1/4*I)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
          (-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
            Log[k1 + x1 + x2])/4, 0, 0, 0, 0, 0, 
          (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
            Log[k1 + x1 + x2])/4, 0, (I/4)*(Log[k1 - x1 - x2] + 
            Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2])}, 
         {0, 0, 0, 0, (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
            Log[k1 - x1 + x2] + Log[k1 + x1 + x2])/4, 0, 
          (-1/4*I)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 0, 0, 0, 
          (-1/4*I)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
          (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
            Log[k1 + x1 + x2])/4, 0}, {0, 0, 0, 0, 0, 
          (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
            Log[k1 + x1 + x2])/4, 0, (-1/4*I)*(Log[k1 - x1 - x2] - 
            Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 
          0, 0, 0, (-1/4*I)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
            Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
          (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
            Log[k1 + x1 + x2])/4}}, 
        {{(-Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2])/4, (I/4)*(Log[k2 - x1 - x2] + 
            Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 0, 0, 
          (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2]), (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
            Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4, 0, 0, 0, 0, 0, 0, 0, 0, 
          0, 0}, {(-1/4*I)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
          (-Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2])/4, 0, 0, (-Log[k2 - x1 - x2] + 
            Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
          (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2]), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
         {0, 0, (-Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2])/4, (I/4)*(Log[k2 - x1 - x2] + 
            Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 0, 0, 
          (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2]), (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
            Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4, 0, 0, 0, 0, 0, 0, 0, 
          0}, {0, 0, (-1/4*I)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
          (-Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2])/4, 0, 0, (-Log[k2 - x1 - x2] + 
            Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
          (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2]), 0, 0, 0, 0, 0, 0, 0, 0}, 
         {(-1/4*I)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
          (-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2])/4, 0, 0, (-Log[k2 - x1 - x2] - 
            Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
          (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2]), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
         {(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
            Log[k2 + x1 + x2])/4, (-1/4*I)*(Log[k2 - x1 - x2] - 
            Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 0, 0, 
          (-1/4*I)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
          (-Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2])/4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
         {0, 0, (-1/4*I)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
          (-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2])/4, 0, 0, (-Log[k2 - x1 - x2] - 
            Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
          (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2]), 0, 0, 0, 0, 0, 0, 0, 0}, 
         {0, 0, (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
            Log[k2 + x1 + x2])/4, (-1/4*I)*(Log[k2 - x1 - x2] - 
            Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 0, 0, 
          (-1/4*I)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
          (-Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2])/4, 0, 0, 0, 0, 0, 0, 0, 0}, 
         {0, 0, 0, 0, 0, 0, 0, 0, (-Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
          (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2]), 0, 0, (I/4)*(Log[k2 - x1 - x2] - 
            Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
          (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
            Log[k2 + x1 + x2])/4, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 
          (-1/4*I)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
          (-Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2])/4, 0, 0, (-Log[k2 - x1 - x2] + 
            Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
          (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2]), 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
          (-Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2])/4, (I/4)*(Log[k2 - x1 - x2] + 
            Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 0, 0, 
          (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2]), (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
            Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4}, {0, 0, 0, 0, 0, 0, 0, 
          0, 0, 0, (-1/4*I)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
          (-Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2])/4, 0, 0, (-Log[k2 - x1 - x2] + 
            Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
          (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2])}, {0, 0, 0, 0, 0, 0, 0, 0, 
          (-1/4*I)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
          (-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2])/4, 0, 0, (-Log[k2 - x1 - x2] - 
            Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
          (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2]), 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 
          (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
            Log[k2 + x1 + x2])/4, (-1/4*I)*(Log[k2 - x1 - x2] - 
            Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 0, 0, 
          (-1/4*I)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
          (-Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2])/4, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
          (-1/4*I)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
          (-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2])/4, 0, 0, (-Log[k2 - x1 - x2] - 
            Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
          (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2])}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
          (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
            Log[k2 + x1 + x2])/4, (-1/4*I)*(Log[k2 - x1 - x2] - 
            Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 0, 0, 
          (-1/4*I)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
            Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
          (-Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
            Log[k2 + x1 + x2])/4}}}, "letters" -> {k1 - x1 - x2, 
        k1 + x1 - x2, k1 - x1 + x2, k1 + x1 + x2, k2 - x1 - x2, k2 + x1 - x2, 
        k2 - x1 + x2, k2 + x1 + x2, x2, x1}, "masters" -> 
       {<|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 1, 
         "stateBits" -> {0, 0, 0, 0}, "integral" -> MSIntegral["11", {0, 0}, 
           {0, 0, 0, 0}], "normalization" -> 1, "bareIntegral" -> 
          MSBareIntegral["11", {0, 0}, {0, 0, 0, 0}], "definition" -> 
          HoldForm[MSIntegral["11", {0, 0}, {0, 0, 0, 0}] == 
            MSBareIntegral["11", {0, 0}, {0, 0, 0, 0}]]|>, 
        <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 2, 
         "stateBits" -> {0, 0, 0, 1}, "integral" -> MSIntegral["11", {0, 0}, 
           {0, 0, 0, 1}], "normalization" -> 1, "bareIntegral" -> 
          MSBareIntegral["11", {0, 0}, {0, 0, 0, 1}], "definition" -> 
          HoldForm[MSIntegral["11", {0, 0}, {0, 0, 0, 1}] == 
            MSBareIntegral["11", {0, 0}, {0, 0, 0, 1}]]|>, 
        <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 3, 
         "stateBits" -> {0, 0, 1, 0}, "integral" -> MSIntegral["11", {0, 0}, 
           {0, 0, 1, 0}], "normalization" -> 1, "bareIntegral" -> 
          MSBareIntegral["11", {0, 0}, {0, 0, 1, 0}], "definition" -> 
          HoldForm[MSIntegral["11", {0, 0}, {0, 0, 1, 0}] == 
            MSBareIntegral["11", {0, 0}, {0, 0, 1, 0}]]|>, 
        <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 4, 
         "stateBits" -> {0, 0, 1, 1}, "integral" -> MSIntegral["11", {0, 0}, 
           {0, 0, 1, 1}], "normalization" -> 1, "bareIntegral" -> 
          MSBareIntegral["11", {0, 0}, {0, 0, 1, 1}], "definition" -> 
          HoldForm[MSIntegral["11", {0, 0}, {0, 0, 1, 1}] == 
            MSBareIntegral["11", {0, 0}, {0, 0, 1, 1}]]|>, 
        <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 5, 
         "stateBits" -> {0, 1, 0, 0}, "integral" -> MSIntegral["11", {0, 0}, 
           {0, 1, 0, 0}], "normalization" -> 1, "bareIntegral" -> 
          MSBareIntegral["11", {0, 0}, {0, 1, 0, 0}], "definition" -> 
          HoldForm[MSIntegral["11", {0, 0}, {0, 1, 0, 0}] == 
            MSBareIntegral["11", {0, 0}, {0, 1, 0, 0}]]|>, 
        <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 6, 
         "stateBits" -> {0, 1, 0, 1}, "integral" -> MSIntegral["11", {0, 0}, 
           {0, 1, 0, 1}], "normalization" -> 1, "bareIntegral" -> 
          MSBareIntegral["11", {0, 0}, {0, 1, 0, 1}], "definition" -> 
          HoldForm[MSIntegral["11", {0, 0}, {0, 1, 0, 1}] == 
            MSBareIntegral["11", {0, 0}, {0, 1, 0, 1}]]|>, 
        <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 7, 
         "stateBits" -> {0, 1, 1, 0}, "integral" -> MSIntegral["11", {0, 0}, 
           {0, 1, 1, 0}], "normalization" -> 1, "bareIntegral" -> 
          MSBareIntegral["11", {0, 0}, {0, 1, 1, 0}], "definition" -> 
          HoldForm[MSIntegral["11", {0, 0}, {0, 1, 1, 0}] == 
            MSBareIntegral["11", {0, 0}, {0, 1, 1, 0}]]|>, 
        <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 8, 
         "stateBits" -> {0, 1, 1, 1}, "integral" -> MSIntegral["11", {0, 0}, 
           {0, 1, 1, 1}], "normalization" -> 1, "bareIntegral" -> 
          MSBareIntegral["11", {0, 0}, {0, 1, 1, 1}], "definition" -> 
          HoldForm[MSIntegral["11", {0, 0}, {0, 1, 1, 1}] == 
            MSBareIntegral["11", {0, 0}, {0, 1, 1, 1}]]|>, 
        <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 9, 
         "stateBits" -> {1, 0, 0, 0}, "integral" -> MSIntegral["11", {0, 0}, 
           {1, 0, 0, 0}], "normalization" -> 1, "bareIntegral" -> 
          MSBareIntegral["11", {0, 0}, {1, 0, 0, 0}], "definition" -> 
          HoldForm[MSIntegral["11", {0, 0}, {1, 0, 0, 0}] == 
            MSBareIntegral["11", {0, 0}, {1, 0, 0, 0}]]|>, 
        <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 10, 
         "stateBits" -> {1, 0, 0, 1}, "integral" -> MSIntegral["11", {0, 0}, 
           {1, 0, 0, 1}], "normalization" -> 1, "bareIntegral" -> 
          MSBareIntegral["11", {0, 0}, {1, 0, 0, 1}], "definition" -> 
          HoldForm[MSIntegral["11", {0, 0}, {1, 0, 0, 1}] == 
            MSBareIntegral["11", {0, 0}, {1, 0, 0, 1}]]|>, 
        <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 11, 
         "stateBits" -> {1, 0, 1, 0}, "integral" -> MSIntegral["11", {0, 0}, 
           {1, 0, 1, 0}], "normalization" -> 1, "bareIntegral" -> 
          MSBareIntegral["11", {0, 0}, {1, 0, 1, 0}], "definition" -> 
          HoldForm[MSIntegral["11", {0, 0}, {1, 0, 1, 0}] == 
            MSBareIntegral["11", {0, 0}, {1, 0, 1, 0}]]|>, 
        <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 12, 
         "stateBits" -> {1, 0, 1, 1}, "integral" -> MSIntegral["11", {0, 0}, 
           {1, 0, 1, 1}], "normalization" -> 1, "bareIntegral" -> 
          MSBareIntegral["11", {0, 0}, {1, 0, 1, 1}], "definition" -> 
          HoldForm[MSIntegral["11", {0, 0}, {1, 0, 1, 1}] == 
            MSBareIntegral["11", {0, 0}, {1, 0, 1, 1}]]|>, 
        <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 13, 
         "stateBits" -> {1, 1, 0, 0}, "integral" -> MSIntegral["11", {0, 0}, 
           {1, 1, 0, 0}], "normalization" -> 1, "bareIntegral" -> 
          MSBareIntegral["11", {0, 0}, {1, 1, 0, 0}], "definition" -> 
          HoldForm[MSIntegral["11", {0, 0}, {1, 1, 0, 0}] == 
            MSBareIntegral["11", {0, 0}, {1, 1, 0, 0}]]|>, 
        <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 14, 
         "stateBits" -> {1, 1, 0, 1}, "integral" -> MSIntegral["11", {0, 0}, 
           {1, 1, 0, 1}], "normalization" -> 1, "bareIntegral" -> 
          MSBareIntegral["11", {0, 0}, {1, 1, 0, 1}], "definition" -> 
          HoldForm[MSIntegral["11", {0, 0}, {1, 1, 0, 1}] == 
            MSBareIntegral["11", {0, 0}, {1, 1, 0, 1}]]|>, 
        <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 15, 
         "stateBits" -> {1, 1, 1, 0}, "integral" -> MSIntegral["11", {0, 0}, 
           {1, 1, 1, 0}], "normalization" -> 1, "bareIntegral" -> 
          MSBareIntegral["11", {0, 0}, {1, 1, 1, 0}], "definition" -> 
          HoldForm[MSIntegral["11", {0, 0}, {1, 1, 1, 0}] == 
            MSBareIntegral["11", {0, 0}, {1, 1, 1, 0}]]|>, 
        <|"sectorKey" -> "11", "sectorOffset" -> 1, "globalIndex" -> 16, 
         "stateBits" -> {1, 1, 1, 1}, "integral" -> MSIntegral["11", {0, 0}, 
           {1, 1, 1, 1}], "normalization" -> 1, "bareIntegral" -> 
          MSBareIntegral["11", {0, 0}, {1, 1, 1, 1}], "definition" -> 
          HoldForm[MSIntegral["11", {0, 0}, {1, 1, 1, 1}] == 
            MSBareIntegral["11", {0, 0}, {1, 1, 1, 1}]]|>}|>, 
     <|"sectorKey" -> "01", "dimension" -> 3, 
      "omega" -> {{Log[(4*I)/(Pi*x1^(1 + I/2))] - 
          (((2 - I) + 2*a1 + 2*a2)*(2*Log[k1 + k2] + Log[k1 + k2 - 2*x2] + 
             Log[k1 + k2 + 2*x2]))/8, (I/2)*(-I + a1 + a2)*
          (Log[k1 + k2 - 2*x2] - Log[k1 + k2 + 2*x2]), 
         (((-1 - (3*I)/2) + a1 + a2)*(-2*Log[k1 + k2] + Log[k1 + k2 - 2*x2] + 
            Log[k1 + k2 + 2*x2]))/4}, {(-1/4*I)*((1 - I/2) + a1 + a2)*
          (Log[k1 + k2 - 2*x2] - Log[k1 + k2 + 2*x2]), 
         Log[(4*I)/(Pi*x1^(1 + I/2))] - (1 + I/2)*Log[x2] - 
          ((-I + a1 + a2)*(Log[k1 + k2 - 2*x2] + Log[k1 + k2 + 2*x2]))/2, 
         (I/4)*((-1 - (3*I)/2) + a1 + a2)*(Log[k1 + k2 - 2*x2] - 
           Log[k1 + k2 + 2*x2])}, {(((1 - I/2) + a1 + a2)*(-2*Log[k1 + k2] + 
            Log[k1 + k2 - 2*x2] + Log[k1 + k2 + 2*x2]))/4, 
         (-1/2*I)*(-I + a1 + a2)*(Log[k1 + k2 - 2*x2] - Log[k1 + k2 + 2*x2]), 
         Log[(4*I)/(Pi*x1^(1 + I/2))] - (2 + I)*Log[x2] - 
          (((-2 - 3*I) + 2*a1 + 2*a2)*(2*Log[k1 + k2] + Log[k1 + k2 - 2*x2] + 
             Log[k1 + k2 + 2*x2]))/8}}, "omegaEx" -> 
       {{0, 0, 0}, {0, (-1 - I/2)*Log[x2], 0}, {0, 0, (-2 - I)*Log[x2]}}, 
      "normalizationGauge" -> {{Log[(4*I)/(Pi*x1^(1 + I/2))], 0, 0}, 
        {0, Log[(4*I)/(Pi*x1^(1 + I/2))], 0}, 
        {0, 0, Log[(4*I)/(Pi*x1^(1 + I/2))]}}, "componentLogKernels" -> 
       {{{(-2*Log[k1 + k2] - Log[k1 + k2 - 2*x2] - Log[k1 + k2 + 2*x2])/4, 
          (I/2)*(Log[k1 + k2 - 2*x2] - Log[k1 + k2 + 2*x2]), 
          (-2*Log[k1 + k2] + Log[k1 + k2 - 2*x2] + Log[k1 + k2 + 2*x2])/4}, 
         {(-1/4*I)*(Log[k1 + k2 - 2*x2] - Log[k1 + k2 + 2*x2]), 
          (-Log[k1 + k2 - 2*x2] - Log[k1 + k2 + 2*x2])/2, 
          (I/4)*(Log[k1 + k2 - 2*x2] - Log[k1 + k2 + 2*x2])}, 
         {(-2*Log[k1 + k2] + Log[k1 + k2 - 2*x2] + Log[k1 + k2 + 2*x2])/4, 
          (-1/2*I)*(Log[k1 + k2 - 2*x2] - Log[k1 + k2 + 2*x2]), 
          (-2*Log[k1 + k2] - Log[k1 + k2 - 2*x2] - Log[k1 + k2 + 2*x2])/4}}}, 
      "letters" -> {(4*I)/(Pi*x1^(1 + I/2)), k1 + k2, k1 + k2 - 2*x2, 
        k1 + k2 + 2*x2, x2}, "masters" -> {<|"sectorKey" -> "01", 
         "sectorOffset" -> 17, "globalIndex" -> 17, "stateBits" -> {0, 0}, 
         "integral" -> MSIntegral["01", {0}, {0, 0}], "normalization" -> 
          (4*I)/(Pi*x1^(1 + I/2)), "bareIntegral" -> MSBareIntegral["01", 
           {0}, {0, 0}], "definition" -> HoldForm[MSIntegral["01", {0}, {0, 
             0}] == ((4*I)/(Pi*x1^(1 + I/2)))*MSBareIntegral["01", {0}, {0, 
              0}]]|>, <|"sectorKey" -> "01", "sectorOffset" -> 17, 
         "globalIndex" -> 18, "stateBits" -> {0, 1}, "integral" -> 
          MSIntegral["01", {0}, {0, 1}], "normalization" -> 
          (4*I)/(Pi*x1^(1 + I/2)), "bareIntegral" -> MSBareIntegral["01", 
           {0}, {0, 1}], "definition" -> HoldForm[MSIntegral["01", {0}, {0, 
             1}] == ((4*I)/(Pi*x1^(1 + I/2)))*MSBareIntegral["01", {0}, {0, 
              1}]]|>, <|"sectorKey" -> "01", "sectorOffset" -> 17, 
         "globalIndex" -> 19, "stateBits" -> {1, 1}, "integral" -> 
          MSIntegral["01", {0}, {1, 1}], "normalization" -> 
          (4*I)/(Pi*x1^(1 + I/2)), "bareIntegral" -> MSBareIntegral["01", 
           {0}, {1, 1}], "definition" -> HoldForm[MSIntegral["01", {0}, {1, 
             1}] == ((4*I)/(Pi*x1^(1 + I/2)))*MSBareIntegral["01", {0}, {1, 
              1}]]|>}|>, <|"sectorKey" -> "10", "dimension" -> 3, 
      "omega" -> {{-1/8*(((2 - I) + 2*a1 + 2*a2)*(2*Log[k1 + k2] + 
             Log[k1 + k2 - 2*x1] + Log[k1 + k2 + 2*x1])) + 
          Log[(4*I)/(Pi*x2^(1 + I/2))], (I/2)*(-I + a1 + a2)*
          (Log[k1 + k2 - 2*x1] - Log[k1 + k2 + 2*x1]), 
         (((-1 - (3*I)/2) + a1 + a2)*(-2*Log[k1 + k2] + Log[k1 + k2 - 2*x1] + 
            Log[k1 + k2 + 2*x1]))/4}, {(-1/4*I)*((1 - I/2) + a1 + a2)*
          (Log[k1 + k2 - 2*x1] - Log[k1 + k2 + 2*x1]), (-1 - I/2)*Log[x1] - 
          ((-I + a1 + a2)*(Log[k1 + k2 - 2*x1] + Log[k1 + k2 + 2*x1]))/2 + 
          Log[(4*I)/(Pi*x2^(1 + I/2))], (I/4)*((-1 - (3*I)/2) + a1 + a2)*
          (Log[k1 + k2 - 2*x1] - Log[k1 + k2 + 2*x1])}, 
        {(((1 - I/2) + a1 + a2)*(-2*Log[k1 + k2] + Log[k1 + k2 - 2*x1] + 
            Log[k1 + k2 + 2*x1]))/4, (-1/2*I)*(-I + a1 + a2)*
          (Log[k1 + k2 - 2*x1] - Log[k1 + k2 + 2*x1]), (-2 - I)*Log[x1] - 
          (((-2 - 3*I) + 2*a1 + 2*a2)*(2*Log[k1 + k2] + Log[k1 + k2 - 2*x1] + 
             Log[k1 + k2 + 2*x1]))/8 + Log[(4*I)/(Pi*x2^(1 + I/2))]}}, 
      "omegaEx" -> {{0, 0, 0}, {0, (-1 - I/2)*Log[x1], 0}, 
        {0, 0, (-2 - I)*Log[x1]}}, "normalizationGauge" -> 
       {{Log[(4*I)/(Pi*x2^(1 + I/2))], 0, 0}, 
        {0, Log[(4*I)/(Pi*x2^(1 + I/2))], 0}, 
        {0, 0, Log[(4*I)/(Pi*x2^(1 + I/2))]}}, "componentLogKernels" -> 
       {{{(-2*Log[k1 + k2] - Log[k1 + k2 - 2*x1] - Log[k1 + k2 + 2*x1])/4, 
          (I/2)*(Log[k1 + k2 - 2*x1] - Log[k1 + k2 + 2*x1]), 
          (-2*Log[k1 + k2] + Log[k1 + k2 - 2*x1] + Log[k1 + k2 + 2*x1])/4}, 
         {(-1/4*I)*(Log[k1 + k2 - 2*x1] - Log[k1 + k2 + 2*x1]), 
          (-Log[k1 + k2 - 2*x1] - Log[k1 + k2 + 2*x1])/2, 
          (I/4)*(Log[k1 + k2 - 2*x1] - Log[k1 + k2 + 2*x1])}, 
         {(-2*Log[k1 + k2] + Log[k1 + k2 - 2*x1] + Log[k1 + k2 + 2*x1])/4, 
          (-1/2*I)*(Log[k1 + k2 - 2*x1] - Log[k1 + k2 + 2*x1]), 
          (-2*Log[k1 + k2] - Log[k1 + k2 - 2*x1] - Log[k1 + k2 + 2*x1])/4}}}, 
      "letters" -> {k1 + k2, k1 + k2 - 2*x1, k1 + k2 + 2*x1, 
        (4*I)/(Pi*x2^(1 + I/2)), x1}, "masters" -> 
       {<|"sectorKey" -> "10", "sectorOffset" -> 20, "globalIndex" -> 20, 
         "stateBits" -> {0, 0}, "integral" -> MSIntegral["10", {0}, {0, 0}], 
         "normalization" -> (4*I)/(Pi*x2^(1 + I/2)), "bareIntegral" -> 
          MSBareIntegral["10", {0}, {0, 0}], "definition" -> 
          HoldForm[MSIntegral["10", {0}, {0, 0}] == ((4*I)/(Pi*x2^(1 + I/2)))*
             MSBareIntegral["10", {0}, {0, 0}]]|>, <|"sectorKey" -> "10", 
         "sectorOffset" -> 20, "globalIndex" -> 21, "stateBits" -> {0, 1}, 
         "integral" -> MSIntegral["10", {0}, {0, 1}], "normalization" -> 
          (4*I)/(Pi*x2^(1 + I/2)), "bareIntegral" -> MSBareIntegral["10", 
           {0}, {0, 1}], "definition" -> HoldForm[MSIntegral["10", {0}, {0, 
             1}] == ((4*I)/(Pi*x2^(1 + I/2)))*MSBareIntegral["10", {0}, {0, 
              1}]]|>, <|"sectorKey" -> "10", "sectorOffset" -> 20, 
         "globalIndex" -> 22, "stateBits" -> {1, 1}, "integral" -> 
          MSIntegral["10", {0}, {1, 1}], "normalization" -> 
          (4*I)/(Pi*x2^(1 + I/2)), "bareIntegral" -> MSBareIntegral["10", 
           {0}, {1, 1}], "definition" -> HoldForm[MSIntegral["10", {0}, {1, 
             1}] == ((4*I)/(Pi*x2^(1 + I/2)))*MSBareIntegral["10", {0}, {1, 
              1}]]|>}|>}, "contactBlocks" -> 
    {<|"sourceSector" -> "11", "targetSector" -> "01", 
      "eventId" -> "11->01:{1}", "lineId" -> 1, "selectedLineIds" -> {1}, 
      "matrix" -> {{(I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - 
           Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + 
           Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
         (Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
           Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 0}, 
        {(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
           Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + 
           Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
           Log[k2 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] + Log[k1 + x1 + x2])/4}, 
        {(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
           Log[k1 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
           Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + 
           Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
           Log[k2 + x1 + x2]), (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4}, 
        {0, (-Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
         (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])}, 
        {(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
         (-1/4*I)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + 
           Log[k1 + x1 - x2] - Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + 
           Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 0}, 
        {(-1/4*I)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
         (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
         (-1/4*I)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2])}, 
        {(I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
           Log[k1 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + 
           Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - 
           Log[k2 - x1 + x2] + Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
         (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2])}, {0, (I/4)*(Log[k1 - x1 - x2] - 
           Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - Log[k2 + x1 - x2] - 
           Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + 
           Log[k2 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + 
           Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - 
           Log[k2 - x1 + x2] + Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4}, 
        {(-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
         (I/4)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 0}, 
        {(I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2]), (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - 
           Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + 
           Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
         (I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
           Log[k1 + x1 + x2])}, {(-1/4*I)*(Log[k1 - x1 - x2] + 
           Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
         (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
         (-1/4*I)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2])}, 
        {0, (-1/4*I)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + 
           Log[k1 + x1 - x2] - Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + 
           Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 
         (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4}, 
        {(I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
         (Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
           Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 0}, 
        {(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
           Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + 
           Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
           Log[k2 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] + Log[k1 + x1 + x2])/4}, 
        {(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
           Log[k1 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
           Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + 
           Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
           Log[k2 + x1 + x2]), (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4}, 
        {0, (-Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
         (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])}}, 
      "globalMatrix" -> {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
         (Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
           Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         (-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
           Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + 
           Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
           Log[k2 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] + Log[k1 + x1 + x2])/4, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         (-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
           Log[k1 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
           Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + 
           Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
           Log[k2 + x1 + x2]), (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         (-Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
         (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
         (-1/4*I)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + 
           Log[k1 + x1 - x2] - Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + 
           Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 0, 0, 
         0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         (-1/4*I)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
         (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
         (-1/4*I)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         (I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
           Log[k1 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + 
           Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - 
           Log[k2 - x1 + x2] + Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
         (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2]), 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         0, 0, 0, 0, 0, (I/4)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + 
           Log[k1 + x1 - x2] - Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + 
           Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 
         (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
         (I/4)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2]), (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - 
           Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + 
           Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
         (I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
           Log[k1 + x1 + x2]), 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         0, 0, 0, 0, (-1/4*I)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
         (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
         (-1/4*I)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         (-1/4*I)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + 
           Log[k1 + x1 - x2] - Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + 
           Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 
         (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
         (Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
           Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 0, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         (-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
           Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + 
           Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
           Log[k2 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] + Log[k1 + x1 + x2])/4, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         (-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
           Log[k1 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
           Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + 
           Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
           Log[k2 + x1 + x2]), (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4, 0, 0, 0}, 
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         (-Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
         (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 0, 0, 0}}, 
      "matricesByTargetSector" -> 
       <|"11" -> {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}}, 
        "01" -> {{(I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - 
             Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + 
             Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
           (Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
             Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
             Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 0}, 
          {(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
             Log[k2 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
             Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + 
             Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
             Log[k2 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
             Log[k1 - x1 + x2] + Log[k1 + x1 + x2])/4}, 
          {(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
             Log[k1 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
             Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + 
             Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
             Log[k2 + x1 + x2]), (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
             Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4}, 
          {0, (-Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
             Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
             Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
           (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
             Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
             Log[k1 + x1 + x2] - Log[k2 + x1 + x2])}, 
          {(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
             Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
             Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
           (-1/4*I)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + 
             Log[k1 + x1 - x2] - Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + 
             Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 0}, 
          {(-1/4*I)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
             Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
           (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
             Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
             Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
           (-1/4*I)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
             Log[k1 - x1 + x2] - Log[k1 + x1 + x2])}, 
          {(I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
             Log[k1 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + 
             Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - 
             Log[k2 - x1 + x2] + Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
           (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
             Log[k2 + x1 + x2])}, {0, (I/4)*(Log[k1 - x1 - x2] - 
             Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - Log[k2 + x1 - x2] - 
             Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + 
             Log[k2 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + 
             Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - 
             Log[k2 - x1 + x2] + Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4}, 
          {(-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
             Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
             Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
           (I/4)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
             Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
             Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 0}, 
          {(I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
             Log[k2 + x1 + x2]), (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - 
             Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + 
             Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
           (I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
             Log[k1 + x1 + x2])}, {(-1/4*I)*(Log[k1 - x1 - x2] + 
             Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
           (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
             Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
             Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
           (-1/4*I)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
             Log[k2 - x1 + x2] - Log[k2 + x1 + x2])}, 
          {0, (-1/4*I)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + 
             Log[k1 + x1 - x2] - Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + 
             Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 
           (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
             Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
             Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4}, 
          {(I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
             Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
             Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
           (Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
             Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
             Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 0}, 
          {(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
             Log[k2 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
             Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + 
             Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
             Log[k2 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
             Log[k1 - x1 + x2] + Log[k1 + x1 + x2])/4}, 
          {(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
             Log[k1 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
             Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + 
             Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
             Log[k2 + x1 + x2]), (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
             Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4}, 
          {0, (-Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
             Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
             Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
           (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
             Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
             Log[k1 + x1 + x2] - Log[k2 + x1 + x2])}}, 
        "10" -> {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, 
          {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, 
          {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}}|>, 
      "dimensions" -> {16, 22}, "R1TargetShifts" -> <|1 -> {0}, 2 -> {0}|>, 
      "R1HitsTargetMasterQ" -> True, "R1ReductionClosedQ" -> True, 
      "shiftReductionRecords" -> {<|"componentPosition" -> 1, 
         "localContactMatrix" -> {{(I/4)*(Log[k1 - x1 - x2] - 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
              Log[k1 + x1 + x2])/4, 0}, {0, (I/4)*(Log[k1 - x1 - x2] - 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
              Log[k1 + x1 + x2])/4}, {(-Log[k1 - x1 - x2] + Log[k1 + x1 - 
                x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2])/4, 
            (I/4)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + Log[k1 - x1 + 
                x2] - Log[k1 + x1 + x2]), 0}, 
           {0, (-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
              Log[k1 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] - 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2])}, 
           {(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + 
              Log[k1 + x1 + x2])/4, (-1/4*I)*(Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0}, 
           {0, (Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + 
              Log[k1 + x1 + x2])/4, (-1/4*I)*(Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2])}, 
           {(I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + 
                x2] - Log[k1 + x1 + x2]), (Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + Log[k1 + x1 + x2])/4, 
            0}, {0, (I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
              Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + 
              Log[k1 + x1 + x2])/4}, {(-Log[k1 - x1 - x2] - Log[k1 + x1 - 
                x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2])/4, 
            (I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + 
                x2] - Log[k1 + x1 + x2]), 0}, 
           {0, (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
              Log[k1 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2])}, 
           {(-1/4*I)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
              Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
              Log[k1 + x1 + x2])/4, 0}, {0, (-1/4*I)*(Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
              Log[k1 + x1 + x2])/4}, {(I/4)*(Log[k1 - x1 - x2] - 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
              Log[k1 + x1 + x2])/4, 0}, {0, (I/4)*(Log[k1 - x1 - x2] - 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
              Log[k1 + x1 + x2])/4}, {(-Log[k1 - x1 - x2] + Log[k1 + x1 - 
                x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2])/4, 
            (I/4)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + Log[k1 - x1 + 
                x2] - Log[k1 + x1 + x2]), 0}, 
           {0, (-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
              Log[k1 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] - 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2])}}, 
         "shiftReduction" -> <|"status" -> "alreadyTargetMasters", 
           "targetShift" -> {0}, "matrix" -> {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0}}, "residuals" -> {0, 0, 
            0}, "remainingShiftedIntegrals" -> {}, "singularLayers" -> {}|>, 
         "globalContribution" -> {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, (I/4)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
              Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
              Log[k1 + x1 + x2])/4, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, (I/4)*(Log[k1 - x1 - x2] - 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
              Log[k1 + x1 + x2])/4, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, (-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
              Log[k1 - x1 + x2] - Log[k1 + x1 + x2])/4, 
            (I/4)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + Log[k1 - x1 + 
                x2] - Log[k1 + x1 + x2]), 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (-Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2])/4, 
            (I/4)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + Log[k1 - x1 + 
                x2] - Log[k1 + x1 + x2]), 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, (Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
              Log[k1 - x1 + x2] + Log[k1 + x1 + x2])/4, 
            (-1/4*I)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
              Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 0, 0}, 
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            (Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + 
              Log[k1 + x1 + x2])/4, (-1/4*I)*(Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
            0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            (I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + 
                x2] - Log[k1 + x1 + x2]), (Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + Log[k1 + x1 + x2])/4, 
            0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            (I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + 
                x2] - Log[k1 + x1 + x2]), (Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + Log[k1 + x1 + x2])/4, 
            0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
              Log[k1 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
            0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
              Log[k1 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
            0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            (-1/4*I)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
              Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
              Log[k1 + x1 + x2])/4, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, (-1/4*I)*(Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
              Log[k1 + x1 + x2])/4, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, (I/4)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
              Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
              Log[k1 + x1 + x2])/4, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, (I/4)*(Log[k1 - x1 - x2] - 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
              Log[k1 + x1 + x2])/4, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, (-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
              Log[k1 - x1 + x2] - Log[k1 + x1 + x2])/4, 
            (I/4)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + Log[k1 - x1 + 
                x2] - Log[k1 + x1 + x2]), 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (-Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2])/4, 
            (I/4)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + Log[k1 - x1 + 
                x2] - Log[k1 + x1 + x2]), 0, 0, 0}}|>, 
        <|"componentPosition" -> 2, "localContactMatrix" -> 
          {{(I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2]), (Log[k2 - x1 - x2] - 
              Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4, 
            0}, {(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2])/4, (I/4)*(Log[k2 - x1 - x2] - 
              Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 0}, 
           {0, (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
              Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
              Log[k2 + x1 + x2])/4}, {0, (-Log[k2 - x1 - x2] + 
              Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
            (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2])}, {(-Log[k2 - x1 - x2] - 
              Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
            (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2]), 0}, 
           {(-1/4*I)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
              Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (-Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
              Log[k2 + x1 + x2])/4, 0}, {0, (-Log[k2 - x1 - x2] - 
              Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
            (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2])}, {0, (-1/4*I)*(Log[k2 - x1 - x2] + 
              Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (-Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
              Log[k2 + x1 + x2])/4}, {(Log[k2 - x1 - x2] + Log[k2 + x1 - 
                x2] + Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4, 
            (-1/4*I)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
              Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 0}, 
           {(I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2]), (Log[k2 - x1 - x2] + 
              Log[k2 + x1 - x2] + Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4, 
            0}, {0, (Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + 
                x2] + Log[k2 + x1 + x2])/4, (-1/4*I)*(Log[k2 - x1 - x2] + 
              Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2])}, 
           {0, (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
              Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] + 
              Log[k2 + x1 + x2])/4}, {(I/4)*(Log[k2 - x1 - x2] - 
              Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
              Log[k2 + x1 + x2])/4, 0}, {(-Log[k2 - x1 - x2] + 
              Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
            (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2]), 0}, 
           {0, (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
              Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
              Log[k2 + x1 + x2])/4}, {0, (-Log[k2 - x1 - x2] + 
              Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
            (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2])}}, "shiftReduction" -> 
          <|"status" -> "alreadyTargetMasters", "targetShift" -> {0}, 
           "matrix" -> {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 
            0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 1, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 1, 0, 0, 0}}, "residuals" -> {0, 0, 0}, 
           "remainingShiftedIntegrals" -> {}, "singularLayers" -> {}|>, 
         "globalContribution" -> {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
              Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
              Log[k2 + x1 + x2])/4, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, (-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
              Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
            (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2]), 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (I/4)*(Log[k2 - x1 - x2] - 
              Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
              Log[k2 + x1 + x2])/4, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, (-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
              Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
            (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2]), 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, (-Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
              Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
            (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2]), 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, 0, (-1/4*I)*(Log[k2 - x1 - x2] + 
              Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (-Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
              Log[k2 + x1 + x2])/4, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, (-Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
              Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
            (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2]), 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, 0, (-1/4*I)*(Log[k2 - x1 - x2] + 
              Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (-Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
              Log[k2 + x1 + x2])/4, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, (Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
              Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4, 
            (-1/4*I)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
              Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 0, 0, 0, 0}, 
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2]), (Log[k2 - x1 - x2] + 
              Log[k2 + x1 - x2] + Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4, 
            0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            (Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] + 
              Log[k2 + x1 + x2])/4, (-1/4*I)*(Log[k2 - x1 - x2] + 
              Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 0, 
            0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2]), (Log[k2 - x1 - x2] + 
              Log[k2 + x1 - x2] + Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4, 
            0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2]), (Log[k2 - x1 - x2] - 
              Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4, 
            0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            (-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
              Log[k2 + x1 + x2])/4, (I/4)*(Log[k2 - x1 - x2] - 
              Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 0, 
            0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2]), (Log[k2 - x1 - x2] - 
              Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4, 
            0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            (-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
              Log[k2 + x1 + x2])/4, (I/4)*(Log[k2 - x1 - x2] - 
              Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 0, 
            0, 0}}|>}, "absorbedNormalization" -> 1|>, 
     <|"sourceSector" -> "11", "targetSector" -> "10", 
      "eventId" -> "11->10:{2}", "lineId" -> 2, "selectedLineIds" -> {2}, 
      "matrix" -> {{(I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + 
           Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - 
           Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
         (Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
           Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 0}, 
        {(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
         (-1/4*I)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] - 
           Log[k1 + x1 - x2] + Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - 
           Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 0}, 
        {(-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
         (I/4)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 0}, 
        {(I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
         (Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
           Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 0}, 
        {(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
           Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - 
           Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
           Log[k2 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] + Log[k1 + x1 + x2])/4}, 
        {(-1/4*I)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
         (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
         (-1/4*I)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2])}, 
        {(I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2]), (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - 
           Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + 
           Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
         (I/4)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
           Log[k1 + x1 + x2])}, {(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
         (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
         (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
           Log[k1 + x1 + x2])/4}, {(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2])/4, 
         (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
         (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
           Log[k2 + x1 + x2])/4}, {(I/4)*(Log[k1 - x1 - x2] - 
           Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
         (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
         (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2])}, {(-1/4*I)*(Log[k1 - x1 - x2] - 
           Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
         (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
         (-1/4*I)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2])}, 
        {(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
           Log[k1 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
           Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - 
           Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
           Log[k2 + x1 + x2]), (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4}, 
        {0, (-Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
         (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])}, 
        {0, (I/4)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] - 
           Log[k1 + x1 - x2] + Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - 
           Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 
         (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4}, 
        {0, (-1/4*I)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] - 
           Log[k1 + x1 - x2] + Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - 
           Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 
         (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4}, 
        {0, (-Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
         (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])}}, 
      "globalMatrix" -> {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         0, 0, (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + 
           Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - 
           Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
         (Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
           Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 0}, 
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
         (-1/4*I)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] - 
           Log[k1 + x1 - x2] + Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - 
           Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 0}, 
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
         (I/4)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 0}, {0, 0, 0, 0, 0, 0, 0, 
         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (I/4)*(Log[k1 - x1 - x2] + 
           Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - 
           Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
           Log[k2 + x1 + x2]), (Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - 
           Log[k1 + x1 - x2] - Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - 
           Log[k2 - x1 + x2] + Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 0}, 
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         (-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
           Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - 
           Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
           Log[k2 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] + Log[k1 + x1 + x2])/4}, {0, 0, 0, 0, 0, 0, 0, 
         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (-1/4*I)*(Log[k2 - x1 - x2] - 
           Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
         (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
         (-1/4*I)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2])}, {0, 0, 0, 0, 0, 0, 0, 0, 
         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (I/4)*(Log[k2 - x1 - x2] - 
           Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
         (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
         (I/4)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
           Log[k1 + x1 + x2])}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         0, 0, 0, 0, (-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
         (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
         (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
           Log[k1 + x1 + x2])/4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         0, 0, 0, 0, 0, (-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2])/4, 
         (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
         (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
           Log[k2 + x1 + x2])/4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         0, 0, 0, 0, 0, (I/4)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
         (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
         (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
           Log[k2 + x1 + x2])}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         0, 0, 0, 0, (-1/4*I)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
         (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
         (-1/4*I)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2])}, {0, 0, 0, 0, 0, 0, 0, 0, 
         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (-Log[k1 - x1 - x2] + 
           Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2])/4, 
         (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
         (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
           Log[k2 + x1 + x2])/4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         0, 0, 0, 0, 0, 0, (-Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + 
           Log[k1 + x1 - x2] + Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + 
           Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
         (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])}, {0, 0, 0, 0, 0, 0, 0, 0, 
         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (I/4)*(Log[k1 - x1 - x2] - 
           Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + Log[k2 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + 
           Log[k2 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + 
           Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - 
           Log[k2 - x1 + x2] + Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4}, 
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         (-1/4*I)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] - 
           Log[k1 + x1 - x2] + Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - 
           Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 
         (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4}, {0, 0, 0, 0, 0, 0, 0, 
         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         (-Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
         (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
           Log[k1 + x1 + x2] - Log[k2 + x1 + x2])}}, 
      "matricesByTargetSector" -> 
       <|"11" -> {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
          {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}}, 
        "01" -> {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, 
          {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, 
          {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}}, 
        "10" -> {{(I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + 
             Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - 
             Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
           (Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
             Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
             Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 0}, 
          {(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
             Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
             Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
           (-1/4*I)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] - 
             Log[k1 + x1 - x2] + Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - 
             Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 0}, 
          {(-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
             Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
             Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
           (I/4)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
             Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
             Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 0}, 
          {(I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
             Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
             Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
           (Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
             Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
             Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 0}, 
          {(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
             Log[k2 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
             Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - 
             Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
             Log[k2 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
             Log[k1 - x1 + x2] + Log[k1 + x1 + x2])/4}, 
          {(-1/4*I)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
             Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
           (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
             Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
             Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
           (-1/4*I)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
             Log[k1 - x1 + x2] - Log[k1 + x1 + x2])}, 
          {(I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
             Log[k2 + x1 + x2]), (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - 
             Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + 
             Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
           (I/4)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
             Log[k1 + x1 + x2])}, {(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
             Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
           (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
             Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
             Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
           (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
             Log[k1 + x1 + x2])/4}, {(-Log[k1 - x1 - x2] + 
             Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2])/4, 
           (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
             Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
             Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
           (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
             Log[k2 + x1 + x2])/4}, {(I/4)*(Log[k1 - x1 - x2] - 
             Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
           (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
             Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
             Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
           (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
             Log[k2 + x1 + x2])}, {(-1/4*I)*(Log[k1 - x1 - x2] - 
             Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
           (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
             Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
             Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
           (-1/4*I)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
             Log[k2 - x1 + x2] - Log[k2 + x1 + x2])}, 
          {(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
             Log[k1 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
             Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - 
             Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
             Log[k2 + x1 + x2]), (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
             Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4}, 
          {0, (-Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
             Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
             Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
           (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
             Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
             Log[k1 + x1 + x2] - Log[k2 + x1 + x2])}, 
          {0, (I/4)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] - 
             Log[k1 + x1 - x2] + Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - 
             Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 
           (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
             Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
             Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4}, 
          {0, (-1/4*I)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] - 
             Log[k1 + x1 - x2] + Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - 
             Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 
           (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
             Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
             Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4}, 
          {0, (-Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
             Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
             Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
           (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
             Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
             Log[k1 + x1 + x2] - Log[k2 + x1 + x2])}}|>, 
      "dimensions" -> {16, 22}, "R1TargetShifts" -> <|1 -> {0}, 2 -> {0}|>, 
      "R1HitsTargetMasterQ" -> True, "R1ReductionClosedQ" -> True, 
      "shiftReductionRecords" -> {<|"componentPosition" -> 1, 
         "localContactMatrix" -> {{(I/4)*(Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
              Log[k1 + x1 + x2])/4, 0}, {(Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + Log[k1 + x1 + x2])/4, 
            (-1/4*I)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
              Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0}, 
           {(-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
              Log[k1 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] - 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0}, 
           {(I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + 
                x2] - Log[k1 + x1 + x2]), (Log[k1 - x1 - x2] - 
              Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + Log[k1 + x1 + x2])/4, 
            0}, {0, (I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
              Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
              Log[k1 + x1 + x2])/4}, {0, (Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + Log[k1 + x1 + x2])/4, 
            (-1/4*I)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
              Log[k1 - x1 + x2] - Log[k1 + x1 + x2])}, 
           {0, (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
              Log[k1 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] - 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2])}, 
           {0, (I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
              Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
              Log[k1 + x1 + x2])/4}, {(-Log[k1 - x1 - x2] + Log[k1 + x1 - 
                x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2])/4, 
            (I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + 
                x2] - Log[k1 + x1 + x2]), 0}, 
           {(I/4)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + Log[k1 - x1 + 
                x2] - Log[k1 + x1 + x2]), (Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + Log[k1 + x1 + x2])/4, 
            0}, {(-1/4*I)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
              Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
              Log[k1 + x1 + x2])/4, 0}, {(-Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2])/4, 
            (I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + 
                x2] - Log[k1 + x1 + x2]), 0}, 
           {0, (-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
              Log[k1 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2])}, 
           {0, (I/4)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
              Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + 
              Log[k1 + x1 + x2])/4}, {0, (-1/4*I)*(Log[k1 - x1 - x2] - 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
              Log[k1 + x1 + x2])/4}, {0, (-Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2])/4, 
            (I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + 
                x2] - Log[k1 + x1 + x2])}}, "shiftReduction" -> 
          <|"status" -> "alreadyTargetMasters", "targetShift" -> {0}, 
           "matrix" -> {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 1, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 1, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 1}}, "residuals" -> {0, 0, 0}, 
           "remainingShiftedIntegrals" -> {}, "singularLayers" -> {}|>, 
         "globalContribution" -> {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, (I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
              Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
              Log[k1 + x1 + x2])/4, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, (Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
              Log[k1 - x1 + x2] + Log[k1 + x1 + x2])/4, 
            (-1/4*I)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
              Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0}, {0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (-Log[k1 - x1 - x2] - 
              Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2])/4, 
            (I/4)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + Log[k1 - x1 + 
                x2] - Log[k1 + x1 + x2]), 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, 0, (I/4)*(Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
              Log[k1 + x1 + x2])/4, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, (I/4)*(Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
              Log[k1 + x1 + x2])/4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, (Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
              Log[k1 - x1 + x2] + Log[k1 + x1 + x2])/4, 
            (-1/4*I)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
              Log[k1 - x1 + x2] - Log[k1 + x1 + x2])}, {0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (-Log[k1 - x1 - x2] - 
              Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2])/4, 
            (I/4)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + Log[k1 - x1 + 
                x2] - Log[k1 + x1 + x2])}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, 0, (I/4)*(Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
              Log[k1 + x1 + x2])/4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, (-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
              Log[k1 - x1 + x2] - Log[k1 + x1 + x2])/4, 
            (I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + 
                x2] - Log[k1 + x1 + x2]), 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, 0, (I/4)*(Log[k1 - x1 - x2] - 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + 
              Log[k1 + x1 + x2])/4, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, (-1/4*I)*(Log[k1 - x1 - x2] - 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
              Log[k1 + x1 + x2])/4, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, (-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
              Log[k1 - x1 + x2] - Log[k1 + x1 + x2])/4, 
            (I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + 
                x2] - Log[k1 + x1 + x2]), 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (-Log[k1 - x1 - x2] + 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2])/4, 
            (I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + 
                x2] - Log[k1 + x1 + x2])}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, 0, (I/4)*(Log[k1 - x1 - x2] - 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + 
              Log[k1 + x1 + x2])/4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, (-1/4*I)*(Log[k1 - x1 - x2] - 
              Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
            (-Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
              Log[k1 + x1 + x2])/4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, (-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
              Log[k1 - x1 + x2] - Log[k1 + x1 + x2])/4, 
            (I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + 
                x2] - Log[k1 + x1 + x2])}}|>, <|"componentPosition" -> 2, 
         "localContactMatrix" -> {{(I/4)*(Log[k2 - x1 - x2] + 
              Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
              Log[k2 + x1 + x2])/4, 0}, {(-Log[k2 - x1 - x2] - 
              Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
            (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2]), 0}, 
           {(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] + 
              Log[k2 + x1 + x2])/4, (-1/4*I)*(Log[k2 - x1 - x2] - 
              Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 0}, 
           {(I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2]), (Log[k2 - x1 - x2] - 
              Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4, 
            0}, {(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2])/4, (I/4)*(Log[k2 - x1 - x2] + 
              Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 0}, 
           {(-1/4*I)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
              Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (-Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
              Log[k2 + x1 + x2])/4, 0}, {(I/4)*(Log[k2 - x1 - x2] - 
              Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] + 
              Log[k2 + x1 + x2])/4, 0}, {(-Log[k2 - x1 - x2] + 
              Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
            (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2]), 0}, 
           {0, (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
              Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
              Log[k2 + x1 + x2])/4}, {0, (-Log[k2 - x1 - x2] - 
              Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
            (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2])}, {0, (Log[k2 - x1 - x2] + 
              Log[k2 + x1 - x2] + Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4, 
            (-1/4*I)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
              Log[k2 - x1 + x2] - Log[k2 + x1 + x2])}, 
           {0, (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
              Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
              Log[k2 + x1 + x2])/4}, {0, (-Log[k2 - x1 - x2] + 
              Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
            (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2])}, {0, (-1/4*I)*(Log[k2 - x1 - x2] - 
              Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (-Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
              Log[k2 + x1 + x2])/4}, {0, (I/4)*(Log[k2 - x1 - x2] - 
              Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] + 
              Log[k2 + x1 + x2])/4}, {0, (-Log[k2 - x1 - x2] + 
              Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
            (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2])}}, "shiftReduction" -> 
          <|"status" -> "alreadyTargetMasters", "targetShift" -> {0}, 
           "matrix" -> {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 1, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 1, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 1}}, "residuals" -> {0, 0, 0}, 
           "remainingShiftedIntegrals" -> {}, "singularLayers" -> {}|>, 
         "globalContribution" -> {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
              Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
              Log[k2 + x1 + x2])/4, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, (-Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
              Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
            (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2]), 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, 0, (Log[k2 - x1 - x2] + Log[k2 + x1 - 
                x2] + Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4, 
            (-1/4*I)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
              Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 0}, {0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (I/4)*(Log[k2 - x1 - x2] + 
              Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
              Log[k2 + x1 + x2])/4, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, (-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
              Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
            (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2]), 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, 0, (-1/4*I)*(Log[k2 - x1 - x2] - 
              Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (-Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
              Log[k2 + x1 + x2])/4, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - 
                x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] + 
              Log[k2 + x1 + x2])/4, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, (-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
              Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
            (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2]), 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (I/4)*(Log[k2 - x1 - x2] + 
              Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
              Log[k2 + x1 + x2])/4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, (-Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
              Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
            (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2])}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, 0, (Log[k2 - x1 - x2] + Log[k2 + x1 - 
                x2] + Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4, 
            (-1/4*I)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
              Log[k2 - x1 + x2] - Log[k2 + x1 + x2])}, {0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (I/4)*(Log[k2 - x1 - x2] + 
              Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
              Log[k2 + x1 + x2])/4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, (-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
              Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
            (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2])}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 0, 0, (-1/4*I)*(Log[k2 - x1 - x2] - 
              Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (-Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
              Log[k2 + x1 + x2])/4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - 
                x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
            (Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] + 
              Log[k2 + x1 + x2])/4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, (-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
              Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
            (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + 
                x2] - Log[k2 + x1 + x2])}}|>}, "absorbedNormalization" -> 
       1|>}, "omegaBlocks" -> 
    {{{{(-((1 + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
             Log[k1 - x1 + x2] + Log[k1 + x1 + x2])) - 
          (1 + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
            Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 
        ((1 + (2*I)*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/8, 
        ((1 + (2*I)*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/8, 0, 
        ((1 + (2*I)*a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/8, 
        (((-1 - I) + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 0, 0, 
        ((1 + (2*I)*a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/8, 0, 
        (((-1 - I) + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/4, 0, 0, 0, 0, 0}, 
       {(-1/4*I)*(1 + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
          Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
        ((-4 - 2*I)*Log[x2] - (1 + a1)*(Log[k1 - x1 - x2] + 
            Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + Log[k1 + x1 + x2]) - 
          ((-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
             Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/2)/4, 0, 
        ((1 + (2*I)*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/8, 
        ((-1/2*I + a2)*(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/4, (I/4)*((-1 - I) + a2)*
         (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
          Log[k2 + x1 + x2]), 0, 0, 0, ((1 + (2*I)*a1)*(Log[k1 - x1 - x2] - 
           Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/8, 0, 
        (((-1 - I) + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/4, 0, 0, 0, 0}, 
       {(-1/4*I)*(1 + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
          Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
        ((-4 - 2*I)*Log[x2] - ((-I + 2*a1)*(Log[k1 - x1 - x2] + 
             Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/2 - 
          (1 + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
            Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 
        ((1 + (2*I)*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/8, 0, 0, 
        ((1 + (2*I)*a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/8, 
        (((-1 - I) + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 
        ((-1/2*I + a1)*(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/4, 0, 
        (I/4)*((-1 - I) + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
          Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 0, 0, 0}, 
       {0, (-1/4*I)*(1 + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
          Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), (-1/4*I)*(1 + a2)*
         (Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
          Log[k2 + x1 + x2]), (-2 - I)*Log[x2] - 
         ((-I + 2*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
            Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/8 - 
         ((-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
            Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/8, 0, 0, 
        ((-1/2*I + a2)*(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/4, (I/4)*((-1 - I) + a2)*
         (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
          Log[k2 + x1 + x2]), 0, ((-1/2*I + a1)*(-Log[k1 - x1 - x2] + 
           Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/4, 0, 
        (I/4)*((-1 - I) + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
          Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 0, 0}, 
       {(-1/4*I)*(1 + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
          Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
        ((-1/2*I + a2)*(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/4, 0, 0, 
        ((-4 - 2*I)*Log[x1] - (1 + a1)*(Log[k1 - x1 - x2] + 
            Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + Log[k1 + x1 + x2]) - 
          ((-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
             Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/2)/4, 
        (I/4)*((-1 - I) + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
          Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
        ((1 + (2*I)*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/8, 0, 0, 0, 0, 0, 
        ((1 + (2*I)*a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/8, 0, 
        (((-1 - I) + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/4, 0}, 
       {((1 + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, (-1/8*I)*(-I + 2*a2)*
         (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
          Log[k2 + x1 + x2]), 0, 0, (-1/8*I)*(-I + 2*a2)*
         (Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
          Log[k2 + x1 + x2]), ((-4 - 2*I)*Log[x1] - (4 + 2*I)*Log[x2] - 
          (1 + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
            Log[k1 - x1 + x2] + Log[k1 + x1 + x2]) - ((-1 - I) + a2)*
           (Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] + 
            Log[k2 + x1 + x2]))/4, 0, ((1 + (2*I)*a1)*(Log[k1 - x1 - x2] + 
           Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/8, 0, 
        0, 0, 0, 0, ((1 + (2*I)*a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/8, 0, 
        (((-1 - I) + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/4}, 
       {0, 0, (-1/4*I)*(1 + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
          Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
        ((-1/2*I + a2)*(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/4, (-1/4*I)*(1 + a1)*
         (Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
          Log[k1 + x1 + x2]), 0, ((-4 - 2*I)*Log[x1] - (4 + 2*I)*Log[x2] - 
          ((-I + 2*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
             Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/2 - 
          ((-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
             Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/2)/4, 
        (I/4)*((-1 - I) + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
          Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 0, 0, 0, 0, 
        ((-1/2*I + a1)*(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/4, 0, 
        (I/4)*((-1 - I) + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
          Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0}, 
       {0, 0, ((1 + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, (-1/8*I)*(-I + 2*a2)*
         (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
          Log[k2 + x1 + x2]), 0, (-1/4*I)*(1 + a1)*(Log[k1 - x1 - x2] + 
          Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
        (-1/8*I)*(-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
          Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
        ((-4 - 2*I)*Log[x1] - (8 + 4*I)*Log[x2] - 
          ((-I + 2*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
             Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/2 - 
          ((-1 - I) + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
            Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 0, 0, 0, 0, 0, 
        ((-1/2*I + a1)*(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/4, 0, 
        (I/4)*((-1 - I) + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
          Log[k1 - x1 + x2] - Log[k1 + x1 + x2])}, 
       {(-1/4*I)*(1 + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
          Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
        ((-1/2*I + a1)*(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/4, 0, 0, 0, 0, 0, 
        ((-4 - 2*I)*Log[x1] - ((-I + 2*a1)*(Log[k1 - x1 - x2] + 
             Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/2 - 
          (1 + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
            Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 
        ((1 + (2*I)*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/8, (I/4)*((-1 - I) + a1)*
         (Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
          Log[k1 + x1 + x2]), 0, ((1 + (2*I)*a2)*(Log[k2 - x1 - x2] - 
           Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/8, 
        (((-1 - I) + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 0, 0}, 
       {0, (-1/4*I)*(1 + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
          Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
        ((-1/2*I + a1)*(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/4, 0, 0, 0, 0, 
        (-1/4*I)*(1 + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
          Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
        ((-4 - 2*I)*Log[x1] - (4 + 2*I)*Log[x2] - 
          ((-I + 2*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
             Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/2 - 
          ((-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
             Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/2)/4, 0, 
        (I/4)*((-1 - I) + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
          Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
        ((-1/2*I + a2)*(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/4, (I/4)*((-1 - I) + a2)*
         (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
          Log[k2 + x1 + x2]), 0, 0}, 
       {((1 + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/4, 0, 
        (-1/8*I)*(-I + 2*a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
          Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 0, 0, 0, 
        (-1/8*I)*(-I + 2*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
          Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
        ((-4 - 2*I)*Log[x1] - (4 + 2*I)*Log[x2] - ((-1 - I) + a1)*
           (Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + 
            Log[k1 + x1 + x2]) - (1 + a2)*(Log[k2 - x1 - x2] + 
            Log[k2 + x1 - x2] + Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 
        ((1 + (2*I)*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/8, 0, 0, 
        ((1 + (2*I)*a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/8, 
        (((-1 - I) + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4}, 
       {0, ((1 + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/4, 0, 
        (-1/8*I)*(-I + 2*a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
          Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 0, 0, 0, 
        (-1/8*I)*(-I + 2*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
          Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), (-1/4*I)*(1 + a2)*
         (Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
          Log[k2 + x1 + x2]), ((-4 - 2*I)*Log[x1] - (8 + 4*I)*Log[x2] - 
          ((-1 - I) + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
            Log[k1 - x1 + x2] + Log[k1 + x1 + x2]) - 
          ((-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
             Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/2)/4, 0, 0, 
        ((-1/2*I + a2)*(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/4, (I/4)*((-1 - I) + a2)*
         (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
          Log[k2 + x1 + x2])}, {0, 0, 0, 0, (-1/4*I)*(1 + a1)*
         (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
          Log[k1 + x1 + x2]), 0, ((-1/2*I + a1)*(-Log[k1 - x1 - x2] + 
           Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/4, 0, 
        (-1/4*I)*(1 + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
          Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
        ((-1/2*I + a2)*(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/4, 0, 0, 
        (-2 - I)*Log[x1] - ((-I + 2*a1)*(Log[k1 - x1 - x2] + 
            Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/8 - 
         ((-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
            Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/8, (I/4)*((-1 - I) + a2)*
         (Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
          Log[k2 + x1 + x2]), (I/4)*((-1 - I) + a1)*(Log[k1 - x1 - x2] + 
          Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0}, 
       {0, 0, 0, 0, 0, (-1/4*I)*(1 + a1)*(Log[k1 - x1 - x2] - 
          Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
        ((-1/2*I + a1)*(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/4, 
        ((1 + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, (-1/8*I)*(-I + 2*a2)*
         (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
          Log[k2 + x1 + x2]), 0, 0, (-1/8*I)*(-I + 2*a2)*
         (Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
          Log[k2 + x1 + x2]), ((-8 - 4*I)*Log[x1] - (4 + 2*I)*Log[x2] - 
          ((-I + 2*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
             Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/2 - 
          ((-1 - I) + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
            Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 0, 
        (I/4)*((-1 - I) + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
          Log[k1 - x1 + x2] - Log[k1 + x1 + x2])}, 
       {0, 0, 0, 0, ((1 + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/4, 0, 
        (-1/8*I)*(-I + 2*a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
          Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 0, 
        (-1/4*I)*(1 + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
          Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
        ((-1/2*I + a2)*(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/4, (-1/8*I)*(-I + 2*a1)*
         (Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
          Log[k1 + x1 + x2]), 0, ((-8 - 4*I)*Log[x1] - (4 + 2*I)*Log[x2] - 
          ((-1 - I) + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
            Log[k1 - x1 + x2] + Log[k1 + x1 + x2]) - 
          ((-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
             Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/2)/4, 
        (I/4)*((-1 - I) + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
          Log[k2 - x1 + x2] - Log[k2 + x1 + x2])}, {0, 0, 0, 0, 0, 
        ((1 + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
           Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/4, 0, 
        (-1/8*I)*(-I + 2*a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
          Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 
        ((1 + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
           Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, (-1/8*I)*(-I + 2*a2)*
         (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
          Log[k2 + x1 + x2]), 0, (-1/8*I)*(-I + 2*a1)*(Log[k1 - x1 - x2] + 
          Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
        (-1/8*I)*(-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
          Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
        ((-8 - 4*I)*Log[x1] - (8 + 4*I)*Log[x2] - ((-1 - I) + a1)*
           (Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + 
            Log[k1 + x1 + x2]) - ((-1 - I) + a2)*(Log[k2 - x1 - x2] + 
            Log[k2 + x1 - x2] + Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4}}, 
      {{(I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
          Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
          Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
        (Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
          Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
          Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 0}, 
       {(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
          Log[k2 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
          Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + 
          Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
          Log[k2 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
          Log[k1 - x1 + x2] + Log[k1 + x1 + x2])/4}, 
       {(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
          Log[k1 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
          Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + 
          Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
          Log[k2 + x1 + x2]), (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
          Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4}, 
       {0, (-Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
          Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
          Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
        (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
          Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
          Log[k1 + x1 + x2] - Log[k2 + x1 + x2])}, 
       {(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
          Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
          Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
        (-1/4*I)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
          Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
          Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 0}, 
       {(-1/4*I)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
          Log[k2 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + 
          Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - 
          Log[k2 - x1 + x2] + Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
        (-1/4*I)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
          Log[k1 + x1 + x2])}, {(I/4)*(Log[k1 - x1 - x2] + 
          Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
        (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
          Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
          Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
        (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
          Log[k2 + x1 + x2])}, {0, (I/4)*(Log[k1 - x1 - x2] - 
          Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - Log[k2 + x1 - x2] - 
          Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + 
          Log[k2 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + 
          Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - 
          Log[k2 - x1 + x2] + Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4}, 
       {(-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
          Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
          Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
        (I/4)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
          Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
          Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 0}, 
       {(I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
          Log[k2 + x1 + x2]), (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - 
          Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + 
          Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
        (I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
          Log[k1 + x1 + x2])}, {(-1/4*I)*(Log[k1 - x1 - x2] + 
          Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
        (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
          Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
          Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
        (-1/4*I)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
          Log[k2 + x1 + x2])}, {0, (-1/4*I)*(Log[k1 - x1 - x2] - 
          Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - Log[k2 + x1 - x2] - 
          Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + 
          Log[k2 + x1 + x2]), (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - 
          Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + 
          Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4}, 
       {(I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
          Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
          Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
        (Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
          Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
          Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 0}, 
       {(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
          Log[k2 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
          Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + 
          Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
          Log[k2 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
          Log[k1 - x1 + x2] + Log[k1 + x1 + x2])/4}, 
       {(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
          Log[k1 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
          Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + 
          Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
          Log[k2 + x1 + x2]), (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
          Log[k2 - x1 + x2] + Log[k2 + x1 + x2])/4}, 
       {0, (-Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
          Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
          Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
        (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
          Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
          Log[k1 + x1 + x2] - Log[k2 + x1 + x2])}}, 
      {{(I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
          Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
          Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
        (Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
          Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
          Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 0}, 
       {(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
          Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
          Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
        (-1/4*I)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
          Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
          Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 0}, 
       {(-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
          Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
          Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
        (I/4)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
          Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
          Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 0}, 
       {(I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
          Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
          Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
        (Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
          Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
          Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 0}, 
       {(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
          Log[k2 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
          Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - 
          Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
          Log[k2 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
          Log[k1 - x1 + x2] + Log[k1 + x1 + x2])/4}, 
       {(-1/4*I)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
          Log[k2 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + 
          Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - 
          Log[k2 - x1 + x2] + Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
        (-1/4*I)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
          Log[k1 + x1 + x2])}, {(I/4)*(Log[k2 - x1 - x2] - 
          Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
        (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
          Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
          Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
        (I/4)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
          Log[k1 + x1 + x2])}, {(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
          Log[k2 - x1 + x2] - Log[k2 + x1 + x2])/4, 
        (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
          Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
          Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
        (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
          Log[k1 + x1 + x2])/4}, {(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
          Log[k1 - x1 + x2] - Log[k1 + x1 + x2])/4, 
        (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
          Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
          Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
        (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
          Log[k2 + x1 + x2])/4}, {(I/4)*(Log[k1 - x1 - x2] - 
          Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
        (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
          Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
          Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
        (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
          Log[k2 + x1 + x2])}, {(-1/4*I)*(Log[k1 - x1 - x2] - 
          Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
        (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
          Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
          Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
        (-1/4*I)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
          Log[k2 + x1 + x2])}, {(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
          Log[k1 - x1 + x2] - Log[k1 + x1 + x2])/4, 
        (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
          Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
          Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
        (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
          Log[k2 + x1 + x2])/4}, {0, (-Log[k1 - x1 - x2] - 
          Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + Log[k2 + x1 - x2] + 
          Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
          Log[k2 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + 
          Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - 
          Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - 
          Log[k2 + x1 + x2])}, {0, (I/4)*(Log[k1 - x1 - x2] - 
          Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + Log[k2 + x1 - x2] + 
          Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + 
          Log[k2 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + 
          Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - 
          Log[k2 - x1 + x2] + Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4}, 
       {0, (-1/4*I)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] - 
          Log[k1 + x1 - x2] + Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - 
          Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 
        (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
          Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
          Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4}, 
       {0, (-Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
          Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
          Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
        (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
          Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
          Log[k1 + x1 + x2] - Log[k2 + x1 + x2])}}}, 
     {{{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0}}, {{Log[(4*I)/(Pi*x1^(1 + I/2))] - 
         (((2 - I) + 2*a1 + 2*a2)*(2*Log[k1 + k2] + Log[k1 + k2 - 2*x2] + 
            Log[k1 + k2 + 2*x2]))/8, (I/2)*(-I + a1 + a2)*
         (Log[k1 + k2 - 2*x2] - Log[k1 + k2 + 2*x2]), 
        (((-1 - (3*I)/2) + a1 + a2)*(-2*Log[k1 + k2] + Log[k1 + k2 - 2*x2] + 
           Log[k1 + k2 + 2*x2]))/4}, {(-1/4*I)*((1 - I/2) + a1 + a2)*
         (Log[k1 + k2 - 2*x2] - Log[k1 + k2 + 2*x2]), 
        Log[(4*I)/(Pi*x1^(1 + I/2))] - (1 + I/2)*Log[x2] - 
         ((-I + a1 + a2)*(Log[k1 + k2 - 2*x2] + Log[k1 + k2 + 2*x2]))/2, 
        (I/4)*((-1 - (3*I)/2) + a1 + a2)*(Log[k1 + k2 - 2*x2] - 
          Log[k1 + k2 + 2*x2])}, {(((1 - I/2) + a1 + a2)*(-2*Log[k1 + k2] + 
           Log[k1 + k2 - 2*x2] + Log[k1 + k2 + 2*x2]))/4, 
        (-1/2*I)*(-I + a1 + a2)*(Log[k1 + k2 - 2*x2] - Log[k1 + k2 + 2*x2]), 
        Log[(4*I)/(Pi*x1^(1 + I/2))] - (2 + I)*Log[x2] - 
         (((-2 - 3*I) + 2*a1 + 2*a2)*(2*Log[k1 + k2] + Log[k1 + k2 - 2*x2] + 
            Log[k1 + k2 + 2*x2]))/8}}, {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}}}, 
     {{{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0}}, {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}}, 
      {{-1/8*(((2 - I) + 2*a1 + 2*a2)*(2*Log[k1 + k2] + Log[k1 + k2 - 2*x1] + 
            Log[k1 + k2 + 2*x1])) + Log[(4*I)/(Pi*x2^(1 + I/2))], 
        (I/2)*(-I + a1 + a2)*(Log[k1 + k2 - 2*x1] - Log[k1 + k2 + 2*x1]), 
        (((-1 - (3*I)/2) + a1 + a2)*(-2*Log[k1 + k2] + Log[k1 + k2 - 2*x1] + 
           Log[k1 + k2 + 2*x1]))/4}, {(-1/4*I)*((1 - I/2) + a1 + a2)*
         (Log[k1 + k2 - 2*x1] - Log[k1 + k2 + 2*x1]), (-1 - I/2)*Log[x1] - 
         ((-I + a1 + a2)*(Log[k1 + k2 - 2*x1] + Log[k1 + k2 + 2*x1]))/2 + 
         Log[(4*I)/(Pi*x2^(1 + I/2))], (I/4)*((-1 - (3*I)/2) + a1 + a2)*
         (Log[k1 + k2 - 2*x1] - Log[k1 + k2 + 2*x1])}, 
       {(((1 - I/2) + a1 + a2)*(-2*Log[k1 + k2] + Log[k1 + k2 - 2*x1] + 
           Log[k1 + k2 + 2*x1]))/4, (-1/2*I)*(-I + a1 + a2)*
         (Log[k1 + k2 - 2*x1] - Log[k1 + k2 + 2*x1]), (-2 - I)*Log[x1] - 
         (((-2 - 3*I) + 2*a1 + 2*a2)*(2*Log[k1 + k2] + Log[k1 + k2 - 2*x1] + 
            Log[k1 + k2 + 2*x1]))/8 + Log[(4*I)/(Pi*x2^(1 + I/2))]}}}}, 
   "omegaPotential" -> 
    {{(-((1 + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] + Log[k1 + x1 + x2])) - 
        (1 + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] + 
          Log[k2 + x1 + x2]))/4, ((1 + (2*I)*a2)*(Log[k2 - x1 - x2] + 
         Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/8, 
      ((1 + (2*I)*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
         Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/8, 0, 
      ((1 + (2*I)*a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
         Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/8, 
      (((-1 - I) + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
         Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 0, 0, 
      ((1 + (2*I)*a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
         Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/8, 0, 
      (((-1 - I) + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
         Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/4, 0, 0, 0, 0, 0, 
      (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
        Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
        Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
      (Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
        Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
        Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 0, 
      (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
        Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
        Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
      (Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
        Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
        Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 0}, 
     {(-1/4*I)*(1 + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
        Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
      ((-4 - 2*I)*Log[x2] - (1 + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
          Log[k1 - x1 + x2] + Log[k1 + x1 + x2]) - 
        ((-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/2)/4, 0, 
      ((1 + (2*I)*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
         Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/8, 
      ((-1/2*I + a2)*(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
         Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/4, (I/4)*((-1 - I) + a2)*
       (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
        Log[k2 + x1 + x2]), 0, 0, 0, 
      ((1 + (2*I)*a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
         Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/8, 0, 
      (((-1 - I) + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
         Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/4, 0, 0, 0, 0, 
      (-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
        Log[k2 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - 
        Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + 
        Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
      (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
        Log[k1 + x1 + x2])/4, (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + 
        Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - 
        Log[k2 - x1 + x2] + Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
      (-1/4*I)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
        Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
        Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 0}, 
     {(-1/4*I)*(1 + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
        Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
      ((-4 - 2*I)*Log[x2] - ((-I + 2*a1)*(Log[k1 - x1 - x2] + 
           Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/2 - 
        (1 + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] + 
          Log[k2 + x1 + x2]))/4, ((1 + (2*I)*a2)*(Log[k2 - x1 - x2] + 
         Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/8, 0, 0, 
      ((1 + (2*I)*a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
         Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/8, 
      (((-1 - I) + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
         Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 
      ((-1/2*I + a1)*(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
         Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/4, 0, 
      (I/4)*((-1 - I) + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
        Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 0, 0, 0, 
      (-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
        Log[k1 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - 
        Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + 
        Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
      (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
        Log[k2 + x1 + x2])/4, (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - 
        Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + 
        Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
      (I/4)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
        Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
        Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 0}, 
     {0, (-1/4*I)*(1 + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
        Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), (-1/4*I)*(1 + a2)*
       (Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
        Log[k2 + x1 + x2]), (-2 - I)*Log[x2] - 
       ((-I + 2*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
          Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/8 - 
       ((-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
          Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/8, 0, 0, 
      ((-1/2*I + a2)*(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
         Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/4, (I/4)*((-1 - I) + a2)*
       (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
        Log[k2 + x1 + x2]), 0, ((-1/2*I + a1)*(-Log[k1 - x1 - x2] + 
         Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/4, 0, 
      (I/4)*((-1 - I) + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
        Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 0, 0, 0, 
      (-Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
        Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
        Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
      (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
        Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
        Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
      (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
        Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
        Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
      (Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
        Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
        Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 0}, 
     {(-1/4*I)*(1 + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
        Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
      ((-1/2*I + a2)*(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
         Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/4, 0, 0, 
      ((-4 - 2*I)*Log[x1] - (1 + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
          Log[k1 - x1 + x2] + Log[k1 + x1 + x2]) - 
        ((-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/2)/4, 
      (I/4)*((-1 - I) + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
        Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
      ((1 + (2*I)*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
         Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/8, 0, 0, 0, 0, 0, 
      ((1 + (2*I)*a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
         Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/8, 0, 
      (((-1 - I) + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
         Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/4, 0, 
      (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
        Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
        Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
      (-1/4*I)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
        Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
        Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 0, 
      (-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
        Log[k2 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + 
        Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - 
        Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
      (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
        Log[k1 + x1 + x2])/4}, 
     {((1 + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
         Log[k2 + x1 + x2]))/4, (-1/8*I)*(-I + 2*a2)*(Log[k2 - x1 - x2] - 
        Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 0, 0, 
      (-1/8*I)*(-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
        Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
      ((-4 - 2*I)*Log[x1] - (4 + 2*I)*Log[x2] - 
        (1 + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + 
          Log[k1 + x1 + x2]) - ((-1 - I) + a2)*(Log[k2 - x1 - x2] + 
          Log[k2 + x1 - x2] + Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 0, 
      ((1 + (2*I)*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
         Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/8, 0, 0, 0, 0, 0, 
      ((1 + (2*I)*a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
         Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/8, 0, 
      (((-1 - I) + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
         Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/4, 
      (-1/4*I)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
        Log[k2 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + 
        Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - 
        Log[k2 - x1 + x2] + Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
      (-1/4*I)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
        Log[k1 + x1 + x2]), (-1/4*I)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
        Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
      (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
        Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
        Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
      (-1/4*I)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
        Log[k1 + x1 + x2])}, {0, 0, (-1/4*I)*(1 + a2)*
       (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
        Log[k2 + x1 + x2]), ((-1/2*I + a2)*(-Log[k2 - x1 - x2] + 
         Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/4, 
      (-1/4*I)*(1 + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
        Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
      ((-4 - 2*I)*Log[x1] - (4 + 2*I)*Log[x2] - 
        ((-I + 2*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/2 - 
        ((-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/2)/4, 
      (I/4)*((-1 - I) + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
        Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 0, 0, 0, 0, 
      ((-1/2*I + a1)*(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
         Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/4, 0, 
      (I/4)*((-1 - I) + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
        Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
      (I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
        Log[k1 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + 
        Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - 
        Log[k2 - x1 + x2] + Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
      (I/4)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
        Log[k2 + x1 + x2]), (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
        Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
      (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
        Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
        Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
      (I/4)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
        Log[k1 + x1 + x2])}, 
     {0, 0, ((1 + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
         Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, (-1/8*I)*(-I + 2*a2)*
       (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
        Log[k2 + x1 + x2]), 0, (-1/4*I)*(1 + a1)*(Log[k1 - x1 - x2] + 
        Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
      (-1/8*I)*(-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
        Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
      ((-4 - 2*I)*Log[x1] - (8 + 4*I)*Log[x2] - 
        ((-I + 2*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/2 - 
        ((-1 - I) + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
          Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 0, 0, 0, 0, 0, 
      ((-1/2*I + a1)*(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
         Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/4, 0, 
      (I/4)*((-1 - I) + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
        Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
      (I/4)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
        Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
        Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 
      (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
        Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
        Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
      (-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
        Log[k2 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + 
        Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - 
        Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
      (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
        Log[k1 + x1 + x2])/4}, {(-1/4*I)*(1 + a1)*(Log[k1 - x1 - x2] - 
        Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
      ((-1/2*I + a1)*(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
         Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/4, 0, 0, 0, 0, 0, 
      ((-4 - 2*I)*Log[x1] - ((-I + 2*a1)*(Log[k1 - x1 - x2] + 
           Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/2 - 
        (1 + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] + 
          Log[k2 + x1 + x2]))/4, ((1 + (2*I)*a2)*(Log[k2 - x1 - x2] + 
         Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/8, 
      (I/4)*((-1 - I) + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
        Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
      ((1 + (2*I)*a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
         Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/8, 
      (((-1 - I) + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
         Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 0, 0, 
      (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
        Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
        Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
      (I/4)*(Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
        Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
        Log[k1 + x1 + x2] + Log[k2 + x1 + x2]), 0, 
      (-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
        Log[k1 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + 
        Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - 
        Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
      (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
        Log[k2 + x1 + x2])/4}, {0, (-1/4*I)*(1 + a1)*(Log[k1 - x1 - x2] - 
        Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
      ((-1/2*I + a1)*(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
         Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/4, 0, 0, 0, 0, 
      (-1/4*I)*(1 + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
        Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
      ((-4 - 2*I)*Log[x1] - (4 + 2*I)*Log[x2] - 
        ((-I + 2*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/2 - 
        ((-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/2)/4, 0, 
      (I/4)*((-1 - I) + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
        Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
      ((-1/2*I + a2)*(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
         Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/4, (I/4)*((-1 - I) + a2)*
       (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
        Log[k2 + x1 + x2]), 0, 0, (I/4)*(Log[k2 - x1 - x2] + 
        Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
      (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
        Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
        Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
      (I/4)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
        Log[k1 + x1 + x2]), (I/4)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
        Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
      (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - 
        Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
        Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
      (I/4)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
        Log[k2 + x1 + x2])}, 
     {((1 + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
         Log[k1 + x1 + x2]))/4, 0, (-1/8*I)*(-I + 2*a1)*
       (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
        Log[k1 + x1 + x2]), 0, 0, 0, 0, 0, (-1/8*I)*(-I + 2*a1)*
       (Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
        Log[k1 + x1 + x2]), 0, ((-4 - 2*I)*Log[x1] - (4 + 2*I)*Log[x2] - 
        ((-1 - I) + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
          Log[k1 - x1 + x2] + Log[k1 + x1 + x2]) - 
        (1 + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] + 
          Log[k2 + x1 + x2]))/4, ((1 + (2*I)*a2)*(Log[k2 - x1 - x2] + 
         Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/8, 0, 0, 
      ((1 + (2*I)*a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
         Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/8, 
      (((-1 - I) + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - 
         Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 
      (-1/4*I)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
        Log[k1 + x1 + x2]), (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - 
        Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + 
        Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
      (-1/4*I)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
        Log[k2 + x1 + x2]), (-1/4*I)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
        Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
      (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + 
        Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
        Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
      (-1/4*I)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
        Log[k2 + x1 + x2])}, 
     {0, ((1 + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
         Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/4, 0, 
      (-1/8*I)*(-I + 2*a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
        Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 0, 0, 0, 
      (-1/8*I)*(-I + 2*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
        Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), (-1/4*I)*(1 + a2)*
       (Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
        Log[k2 + x1 + x2]), ((-4 - 2*I)*Log[x1] - (8 + 4*I)*Log[x2] - 
        ((-1 - I) + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
          Log[k1 - x1 + x2] + Log[k1 + x1 + x2]) - 
        ((-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/2)/4, 0, 0, 
      ((-1/2*I + a2)*(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
         Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/4, (I/4)*((-1 - I) + a2)*
       (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
        Log[k2 + x1 + x2]), 0, (-1/4*I)*(Log[k1 - x1 - x2] - 
        Log[k2 - x1 - x2] + Log[k1 + x1 - x2] - Log[k2 + x1 - x2] - 
        Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + 
        Log[k2 + x1 + x2]), (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - 
        Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + 
        Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 
      (-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
        Log[k1 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + 
        Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - 
        Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
      (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
        Log[k2 + x1 + x2])/4}, {0, 0, 0, 0, (-1/4*I)*(1 + a1)*
       (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
        Log[k1 + x1 + x2]), 0, ((-1/2*I + a1)*(-Log[k1 - x1 - x2] + 
         Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/4, 0, 
      (-1/4*I)*(1 + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
        Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
      ((-1/2*I + a2)*(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
         Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/4, 0, 0, 
      (-2 - I)*Log[x1] - ((-I + 2*a1)*(Log[k1 - x1 - x2] + 
          Log[k1 + x1 - x2] + Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/8 - 
       ((-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
          Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/8, 
      (I/4)*((-1 - I) + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
        Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), (I/4)*((-1 - I) + a1)*
       (Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
        Log[k1 + x1 + x2]), 0, (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - 
        Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + 
        Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
      (Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
        Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] + 
        Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4, 0, 0, 
      (-Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
        Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
        Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
      (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
        Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
        Log[k1 + x1 + x2] - Log[k2 + x1 + x2])}, 
     {0, 0, 0, 0, 0, (-1/4*I)*(1 + a1)*(Log[k1 - x1 - x2] - 
        Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 
      ((-1/2*I + a1)*(-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
         Log[k1 - x1 + x2] - Log[k1 + x1 + x2]))/4, 
      ((1 + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
         Log[k2 + x1 + x2]))/4, (-1/8*I)*(-I + 2*a2)*(Log[k2 - x1 - x2] - 
        Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 0, 0, 
      (-1/8*I)*(-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
        Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
      ((-8 - 4*I)*Log[x1] - (4 + 2*I)*Log[x2] - 
        ((-I + 2*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
           Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/2 - 
        ((-1 - I) + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
          Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/4, 0, 
      (I/4)*((-1 - I) + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
        Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 
      (-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - 
        Log[k2 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - 
        Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + 
        Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
      (Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - Log[k1 - x1 + x2] + 
        Log[k1 + x1 + x2])/4, 0, (I/4)*(Log[k1 - x1 - x2] - 
        Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + Log[k2 + x1 - x2] + 
        Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + 
        Log[k2 + x1 + x2]), (Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + 
        Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + Log[k1 - x1 + x2] - 
        Log[k2 - x1 + x2] + Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4}, 
     {0, 0, 0, 0, ((1 + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
         Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/4, 0, 
      (-1/8*I)*(-I + 2*a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
        Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 0, 
      (-1/4*I)*(1 + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] + 
        Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
      ((-1/2*I + a2)*(-Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
         Log[k2 - x1 + x2] - Log[k2 + x1 + x2]))/4, (-1/8*I)*(-I + 2*a1)*
       (Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - Log[k1 - x1 + x2] - 
        Log[k1 + x1 + x2]), 0, ((-8 - 4*I)*Log[x1] - (4 + 2*I)*Log[x2] - 
        ((-1 - I) + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
          Log[k1 - x1 + x2] + Log[k1 + x1 + x2]) - 
        ((-I + 2*a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + 
           Log[k2 - x1 + x2] + Log[k2 + x1 + x2]))/2)/4, 
      (I/4)*((-1 - I) + a2)*(Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - 
        Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 
      (-Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + Log[k1 - x1 + x2] - 
        Log[k1 + x1 + x2])/4, (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - 
        Log[k1 + x1 - x2] - Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + 
        Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 
      (Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
        Log[k2 + x1 + x2])/4, 0, (-1/4*I)*(Log[k1 - x1 - x2] - 
        Log[k2 - x1 - x2] - Log[k1 + x1 - x2] + Log[k2 + x1 - x2] + 
        Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + 
        Log[k2 + x1 + x2]), (-Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - 
        Log[k1 + x1 - x2] + Log[k2 + x1 - x2] - Log[k1 - x1 + x2] + 
        Log[k2 - x1 + x2] - Log[k1 + x1 + x2] + Log[k2 + x1 + x2])/4}, 
     {0, 0, 0, 0, 0, ((1 + a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] - 
         Log[k1 - x1 + x2] + Log[k1 + x1 + x2]))/4, 0, 
      (-1/8*I)*(-I + 2*a1)*(Log[k1 - x1 - x2] - Log[k1 + x1 - x2] + 
        Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), 0, 0, 
      ((1 + a2)*(Log[k2 - x1 - x2] - Log[k2 + x1 - x2] - Log[k2 - x1 + x2] + 
         Log[k2 + x1 + x2]))/4, (-1/8*I)*(-I + 2*a2)*(Log[k2 - x1 - x2] - 
        Log[k2 + x1 - x2] + Log[k2 - x1 + x2] - Log[k2 + x1 + x2]), 0, 
      (-1/8*I)*(-I + 2*a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] - 
        Log[k1 - x1 + x2] - Log[k1 + x1 + x2]), (-1/8*I)*(-I + 2*a2)*
       (Log[k2 - x1 - x2] + Log[k2 + x1 - x2] - Log[k2 - x1 + x2] - 
        Log[k2 + x1 + x2]), ((-8 - 4*I)*Log[x1] - (8 + 4*I)*Log[x2] - 
        ((-1 - I) + a1)*(Log[k1 - x1 - x2] + Log[k1 + x1 - x2] + 
          Log[k1 - x1 + x2] + Log[k1 + x1 + x2]) - ((-1 - I) + a2)*
         (Log[k2 - x1 - x2] + Log[k2 + x1 - x2] + Log[k2 - x1 + x2] + 
          Log[k2 + x1 + x2]))/4, 0, (-Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + 
        Log[k1 + x1 - x2] + Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + 
        Log[k2 - x1 + x2] - Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
      (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] - Log[k1 + x1 - x2] - 
        Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
        Log[k1 + x1 + x2] - Log[k2 + x1 + x2]), 0, 
      (-Log[k1 - x1 - x2] - Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
        Log[k2 + x1 - x2] + Log[k1 - x1 + x2] + Log[k2 - x1 + x2] - 
        Log[k1 + x1 + x2] - Log[k2 + x1 + x2])/4, 
      (I/4)*(Log[k1 - x1 - x2] + Log[k2 - x1 - x2] + Log[k1 + x1 - x2] + 
        Log[k2 + x1 - x2] - Log[k1 - x1 + x2] - Log[k2 - x1 + x2] - 
        Log[k1 + x1 + x2] - Log[k2 + x1 + x2])}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0, 0, Log[(4*I)/(Pi*x1^(1 + I/2))] - 
       (((2 - I) + 2*a1 + 2*a2)*(2*Log[k1 + k2] + Log[k1 + k2 - 2*x2] + 
          Log[k1 + k2 + 2*x2]))/8, (I/2)*(-I + a1 + a2)*
       (Log[k1 + k2 - 2*x2] - Log[k1 + k2 + 2*x2]), 
      (((-1 - (3*I)/2) + a1 + a2)*(-2*Log[k1 + k2] + Log[k1 + k2 - 2*x2] + 
         Log[k1 + k2 + 2*x2]))/4, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, (-1/4*I)*((1 - I/2) + a1 + a2)*(Log[k1 + k2 - 2*x2] - 
        Log[k1 + k2 + 2*x2]), Log[(4*I)/(Pi*x1^(1 + I/2))] - 
       (1 + I/2)*Log[x2] - ((-I + a1 + a2)*(Log[k1 + k2 - 2*x2] + 
          Log[k1 + k2 + 2*x2]))/2, (I/4)*((-1 - (3*I)/2) + a1 + a2)*
       (Log[k1 + k2 - 2*x2] - Log[k1 + k2 + 2*x2]), 0, 0, 0}, 
     {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      (((1 - I/2) + a1 + a2)*(-2*Log[k1 + k2] + Log[k1 + k2 - 2*x2] + 
         Log[k1 + k2 + 2*x2]))/4, (-1/2*I)*(-I + a1 + a2)*
       (Log[k1 + k2 - 2*x2] - Log[k1 + k2 + 2*x2]), 
      Log[(4*I)/(Pi*x1^(1 + I/2))] - (2 + I)*Log[x2] - 
       (((-2 - 3*I) + 2*a1 + 2*a2)*(2*Log[k1 + k2] + Log[k1 + k2 - 2*x2] + 
          Log[k1 + k2 + 2*x2]))/8, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, -1/8*(((2 - I) + 2*a1 + 2*a2)*
         (2*Log[k1 + k2] + Log[k1 + k2 - 2*x1] + Log[k1 + k2 + 2*x1])) + 
       Log[(4*I)/(Pi*x2^(1 + I/2))], (I/2)*(-I + a1 + a2)*
       (Log[k1 + k2 - 2*x1] - Log[k1 + k2 + 2*x1]), 
      (((-1 - (3*I)/2) + a1 + a2)*(-2*Log[k1 + k2] + Log[k1 + k2 - 2*x1] + 
         Log[k1 + k2 + 2*x1]))/4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, (-1/4*I)*((1 - I/2) + a1 + a2)*(Log[k1 + k2 - 2*x1] - 
        Log[k1 + k2 + 2*x1]), (-1 - I/2)*Log[x1] - 
       ((-I + a1 + a2)*(Log[k1 + k2 - 2*x1] + Log[k1 + k2 + 2*x1]))/2 + 
       Log[(4*I)/(Pi*x2^(1 + I/2))], (I/4)*((-1 - (3*I)/2) + a1 + a2)*
       (Log[k1 + k2 - 2*x1] - Log[k1 + k2 + 2*x1])}, 
     {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      (((1 - I/2) + a1 + a2)*(-2*Log[k1 + k2] + Log[k1 + k2 - 2*x1] + 
         Log[k1 + k2 + 2*x1]))/4, (-1/2*I)*(-I + a1 + a2)*
       (Log[k1 + k2 - 2*x1] - Log[k1 + k2 + 2*x1]), (-2 - I)*Log[x1] - 
       (((-2 - 3*I) + 2*a1 + 2*a2)*(2*Log[k1 + k2] + Log[k1 + k2 - 2*x1] + 
          Log[k1 + k2 + 2*x1]))/8 + Log[(4*I)/(Pi*x2^(1 + I/2))]}}, 
   "matrixDimension" -> {22, 22}, "letters" -> {k1 - x1 - x2, k1 + x1 - x2, 
     k1 - x1 + x2, k1 + x1 + x2, k2 - x1 - x2, k2 + x1 - x2, k2 - x1 + x2, 
     k2 + x1 + x2, x2, x1, (4*I)/(Pi*x1^(1 + I/2)), k1 + k2, k1 + k2 - 2*x2, 
     k1 + k2 + 2*x2, k1 + k2 - 2*x1, k1 + k2 + 2*x1, 
     (4*I)/(Pi*x2^(1 + I/2))}, "letterMatrices" -> 
    <|k1 - x1 - x2 -> {{(-1 - a1)/4, 0, (1 + (2*I)*a1)/8, 0, 0, 0, 0, 0, 
        (1 + (2*I)*a1)/8, 0, ((-1 - I) + a1)/4, 0, 0, 0, 0, 0, I/4, 1/4, 0, 
        I/4, 1/4, 0}, {0, (-1 - a1)/4, 0, (1 + (2*I)*a1)/8, 0, 0, 0, 0, 0, 
        (1 + (2*I)*a1)/8, 0, ((-1 - I) + a1)/4, 0, 0, 0, 0, 0, I/4, 1/4, 1/4, 
        -1/4*I, 0}, {(-1/4*I)*(1 + a1), 0, (I/2 - a1)/4, 0, 0, 0, 0, 0, 
        (I/2 - a1)/4, 0, (I/4)*((-1 - I) + a1), 0, 0, 0, 0, 0, -1/4, I/4, 0, 
        -1/4, I/4, 0}, {0, (-1/4*I)*(1 + a1), 0, I/8 - a1/4, 0, 0, 0, 0, 0, 
        (I/2 - a1)/4, 0, (I/4)*((-1 - I) + a1), 0, 0, 0, 0, 0, -1/4, I/4, 
        I/4, 1/4, 0}, {0, 0, 0, 0, (-1 - a1)/4, 0, (1 + (2*I)*a1)/8, 0, 0, 0, 
        0, 0, (1 + (2*I)*a1)/8, 0, ((-1 - I) + a1)/4, 0, 1/4, -1/4*I, 0, 0, 
        I/4, 1/4}, {0, 0, 0, 0, 0, (-1 - a1)/4, 0, (1 + (2*I)*a1)/8, 0, 0, 0, 
        0, 0, (1 + (2*I)*a1)/8, 0, ((-1 - I) + a1)/4, 0, 1/4, -1/4*I, 0, 1/4, 
        -1/4*I}, {0, 0, 0, 0, (-1/4*I)*(1 + a1), 0, (I/2 - a1)/4, 0, 0, 0, 0, 
        0, (I/2 - a1)/4, 0, (I/4)*((-1 - I) + a1), 0, I/4, 1/4, 0, 0, -1/4, 
        I/4}, {0, 0, 0, 0, 0, (-1/4*I)*(1 + a1), 0, (I/2 - a1)/4, 0, 0, 0, 0, 
        0, (I/2 - a1)/4, 0, (I/4)*((-1 - I) + a1), 0, I/4, 1/4, 0, I/4, 1/4}, 
       {(-1/4*I)*(1 + a1), 0, (I/2 - a1)/4, 0, 0, 0, 0, 0, (I/2 - a1)/4, 0, 
        (I/4)*((-1 - I) + a1), 0, 0, 0, 0, 0, -1/4, I/4, 0, -1/4, I/4, 0}, 
       {0, (-1/4*I)*(1 + a1), 0, (I/2 - a1)/4, 0, 0, 0, 0, 0, (I/2 - a1)/4, 
        0, (I/4)*((-1 - I) + a1), 0, 0, 0, 0, 0, -1/4, I/4, I/4, 1/4, 0}, 
       {(1 + a1)/4, 0, (-1/8*I)*(-I + 2*a1), 0, 0, 0, 0, 0, 
        (-1/8*I)*(-I + 2*a1), 0, ((1 + I) - a1)/4, 0, 0, 0, 0, 0, -1/4*I, 
        -1/4, 0, -1/4*I, -1/4, 0}, {0, (1 + a1)/4, 0, (-1/8*I)*(-I + 2*a1), 
        0, 0, 0, 0, 0, (-1/8*I)*(-I + 2*a1), 0, ((1 + I) - a1)/4, 0, 0, 0, 0, 
        0, -1/4*I, -1/4, -1/4, I/4, 0}, {0, 0, 0, 0, (-1/4*I)*(1 + a1), 0, 
        (I/2 - a1)/4, 0, 0, 0, 0, 0, I/8 - a1/4, 0, (I/4)*((-1 - I) + a1), 0, 
        I/4, 1/4, 0, 0, -1/4, I/4}, {0, 0, 0, 0, 0, (-1/4*I)*(1 + a1), 0, 
        (I/2 - a1)/4, 0, 0, 0, 0, 0, (I/2 - a1)/4, 0, (I/4)*((-1 - I) + a1), 
        0, I/4, 1/4, 0, I/4, 1/4}, {0, 0, 0, 0, (1 + a1)/4, 0, 
        (-1/8*I)*(-I + 2*a1), 0, 0, 0, 0, 0, (-1/8*I)*(-I + 2*a1), 0, 
        ((1 + I) - a1)/4, 0, -1/4, I/4, 0, 0, -1/4*I, -1/4}, 
       {0, 0, 0, 0, 0, (1 + a1)/4, 0, (-1/8*I)*(-I + 2*a1), 0, 0, 0, 0, 0, 
        (-1/8*I)*(-I + 2*a1), 0, ((1 + I) - a1)/4, 0, -1/4, I/4, 0, -1/4, 
        I/4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0}}, k1 + x1 - x2 -> {{(-1 - a1)/4, 0, (1 + (2*I)*a1)/8, 0, 0, 0, 0, 
        0, (-1 - (2*I)*a1)/8, 0, ((1 + I) - a1)/4, 0, 0, 0, 0, 0, -1/4*I, 
        -1/4, 0, I/4, -1/4, 0}, {0, (-1 - a1)/4, 0, (1 + (2*I)*a1)/8, 0, 0, 
        0, 0, 0, (-1 - (2*I)*a1)/8, 0, ((1 + I) - a1)/4, 0, 0, 0, 0, 0, 
        -1/4*I, -1/4, 1/4, I/4, 0}, {(-1/4*I)*(1 + a1), 0, (I/2 - a1)/4, 0, 
        0, 0, 0, 0, (-1/2*I + a1)/4, 0, (-1/4*I)*((-1 - I) + a1), 0, 0, 0, 0, 
        0, 1/4, -1/4*I, 0, -1/4, -1/4*I, 0}, {0, (-1/4*I)*(1 + a1), 0, 
        I/8 - a1/4, 0, 0, 0, 0, 0, (-1/2*I + a1)/4, 0, 
        (-1/4*I)*((-1 - I) + a1), 0, 0, 0, 0, 0, 1/4, -1/4*I, I/4, -1/4, 0}, 
       {0, 0, 0, 0, (-1 - a1)/4, 0, (1 + (2*I)*a1)/8, 0, 0, 0, 0, 0, 
        (-1 - (2*I)*a1)/8, 0, ((1 + I) - a1)/4, 0, 1/4, -1/4*I, 0, 0, I/4, 
        -1/4}, {0, 0, 0, 0, 0, (-1 - a1)/4, 0, (1 + (2*I)*a1)/8, 0, 0, 0, 0, 
        0, (-1 - (2*I)*a1)/8, 0, ((1 + I) - a1)/4, 0, 1/4, -1/4*I, 0, 1/4, 
        I/4}, {0, 0, 0, 0, (-1/4*I)*(1 + a1), 0, (I/2 - a1)/4, 0, 0, 0, 0, 0, 
        (-1/2*I + a1)/4, 0, (-1/4*I)*((-1 - I) + a1), 0, I/4, 1/4, 0, 0, 
        -1/4, -1/4*I}, {0, 0, 0, 0, 0, (-1/4*I)*(1 + a1), 0, (I/2 - a1)/4, 0, 
        0, 0, 0, 0, (-1/2*I + a1)/4, 0, (-1/4*I)*((-1 - I) + a1), 0, I/4, 
        1/4, 0, I/4, -1/4}, {(I/4)*(1 + a1), 0, (-1/2*I + a1)/4, 0, 0, 0, 0, 
        0, (I/2 - a1)/4, 0, (I/4)*((-1 - I) + a1), 0, 0, 0, 0, 0, -1/4, I/4, 
        0, 1/4, I/4, 0}, {0, (I/4)*(1 + a1), 0, (-1/2*I + a1)/4, 0, 0, 0, 0, 
        0, (I/2 - a1)/4, 0, (I/4)*((-1 - I) + a1), 0, 0, 0, 0, 0, -1/4, I/4, 
        -1/4*I, 1/4, 0}, {(-1 - a1)/4, 0, (I/8)*(-I + 2*a1), 0, 0, 0, 0, 0, 
        (-1/8*I)*(-I + 2*a1), 0, ((1 + I) - a1)/4, 0, 0, 0, 0, 0, -1/4*I, 
        -1/4, 0, I/4, -1/4, 0}, {0, (-1 - a1)/4, 0, (I/8)*(-I + 2*a1), 0, 0, 
        0, 0, 0, (-1/8*I)*(-I + 2*a1), 0, ((1 + I) - a1)/4, 0, 0, 0, 0, 0, 
        -1/4*I, -1/4, 1/4, I/4, 0}, {0, 0, 0, 0, (I/4)*(1 + a1), 0, 
        (-1/2*I + a1)/4, 0, 0, 0, 0, 0, I/8 - a1/4, 0, (I/4)*((-1 - I) + a1), 
        0, -1/4*I, -1/4, 0, 0, 1/4, I/4}, {0, 0, 0, 0, 0, (I/4)*(1 + a1), 0, 
        (-1/2*I + a1)/4, 0, 0, 0, 0, 0, (I/2 - a1)/4, 0, 
        (I/4)*((-1 - I) + a1), 0, -1/4*I, -1/4, 0, -1/4*I, 1/4}, 
       {0, 0, 0, 0, (-1 - a1)/4, 0, (I/8)*(-I + 2*a1), 0, 0, 0, 0, 0, 
        (-1/8*I)*(-I + 2*a1), 0, ((1 + I) - a1)/4, 0, 1/4, -1/4*I, 0, 0, I/4, 
        -1/4}, {0, 0, 0, 0, 0, (-1 - a1)/4, 0, (I/8)*(-I + 2*a1), 0, 0, 0, 0, 
        0, (-1/8*I)*(-I + 2*a1), 0, ((1 + I) - a1)/4, 0, 1/4, -1/4*I, 0, 1/4, 
        I/4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0}}, k1 - x1 + x2 -> {{(-1 - a1)/4, 0, (-1 - (2*I)*a1)/8, 0, 0, 0, 0, 
        0, (1 + (2*I)*a1)/8, 0, ((1 + I) - a1)/4, 0, 0, 0, 0, 0, I/4, -1/4, 
        0, -1/4*I, -1/4, 0}, {0, (-1 - a1)/4, 0, (-1 - (2*I)*a1)/8, 0, 0, 0, 
        0, 0, (1 + (2*I)*a1)/8, 0, ((1 + I) - a1)/4, 0, 0, 0, 0, 0, I/4, 
        -1/4, 1/4, -1/4*I, 0}, {(I/4)*(1 + a1), 0, (I/2 - a1)/4, 0, 0, 0, 0, 
        0, (-1/2*I + a1)/4, 0, (I/4)*((-1 - I) + a1), 0, 0, 0, 0, 0, 1/4, 
        I/4, 0, -1/4, I/4, 0}, {0, (I/4)*(1 + a1), 0, I/8 - a1/4, 0, 0, 0, 0, 
        0, (-1/2*I + a1)/4, 0, (I/4)*((-1 - I) + a1), 0, 0, 0, 0, 0, 1/4, 
        I/4, -1/4*I, -1/4, 0}, {0, 0, 0, 0, (-1 - a1)/4, 0, 
        (-1 - (2*I)*a1)/8, 0, 0, 0, 0, 0, (1 + (2*I)*a1)/8, 0, 
        ((1 + I) - a1)/4, 0, 1/4, I/4, 0, 0, -1/4*I, -1/4}, 
       {0, 0, 0, 0, 0, (-1 - a1)/4, 0, (-1 - (2*I)*a1)/8, 0, 0, 0, 0, 0, 
        (1 + (2*I)*a1)/8, 0, ((1 + I) - a1)/4, 0, 1/4, I/4, 0, 1/4, -1/4*I}, 
       {0, 0, 0, 0, (I/4)*(1 + a1), 0, (I/2 - a1)/4, 0, 0, 0, 0, 0, 
        (-1/2*I + a1)/4, 0, (I/4)*((-1 - I) + a1), 0, -1/4*I, 1/4, 0, 0, 
        -1/4, I/4}, {0, 0, 0, 0, 0, (I/4)*(1 + a1), 0, (I/2 - a1)/4, 0, 0, 0, 
        0, 0, (-1/2*I + a1)/4, 0, (I/4)*((-1 - I) + a1), 0, -1/4*I, 1/4, 0, 
        -1/4*I, -1/4}, {(-1/4*I)*(1 + a1), 0, (-1/2*I + a1)/4, 0, 0, 0, 0, 0, 
        (I/2 - a1)/4, 0, (-1/4*I)*((-1 - I) + a1), 0, 0, 0, 0, 0, -1/4, 
        -1/4*I, 0, 1/4, -1/4*I, 0}, {0, (-1/4*I)*(1 + a1), 0, 
        (-1/2*I + a1)/4, 0, 0, 0, 0, 0, (I/2 - a1)/4, 0, 
        (-1/4*I)*((-1 - I) + a1), 0, 0, 0, 0, 0, -1/4, -1/4*I, I/4, 1/4, 0}, 
       {(-1 - a1)/4, 0, (-1/8*I)*(-I + 2*a1), 0, 0, 0, 0, 0, 
        (I/8)*(-I + 2*a1), 0, ((1 + I) - a1)/4, 0, 0, 0, 0, 0, I/4, -1/4, 0, 
        -1/4*I, -1/4, 0}, {0, (-1 - a1)/4, 0, (-1/8*I)*(-I + 2*a1), 0, 0, 0, 
        0, 0, (I/8)*(-I + 2*a1), 0, ((1 + I) - a1)/4, 0, 0, 0, 0, 0, I/4, 
        -1/4, 1/4, -1/4*I, 0}, {0, 0, 0, 0, (-1/4*I)*(1 + a1), 0, 
        (-1/2*I + a1)/4, 0, 0, 0, 0, 0, I/8 - a1/4, 0, 
        (-1/4*I)*((-1 - I) + a1), 0, I/4, -1/4, 0, 0, 1/4, -1/4*I}, 
       {0, 0, 0, 0, 0, (-1/4*I)*(1 + a1), 0, (-1/2*I + a1)/4, 0, 0, 0, 0, 0, 
        (I/2 - a1)/4, 0, (-1/4*I)*((-1 - I) + a1), 0, I/4, -1/4, 0, I/4, 
        1/4}, {0, 0, 0, 0, (-1 - a1)/4, 0, (-1/8*I)*(-I + 2*a1), 0, 0, 0, 0, 
        0, (I/8)*(-I + 2*a1), 0, ((1 + I) - a1)/4, 0, 1/4, I/4, 0, 0, -1/4*I, 
        -1/4}, {0, 0, 0, 0, 0, (-1 - a1)/4, 0, (-1/8*I)*(-I + 2*a1), 0, 0, 0, 
        0, 0, (I/8)*(-I + 2*a1), 0, ((1 + I) - a1)/4, 0, 1/4, I/4, 0, 1/4, 
        -1/4*I}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}}, k1 + x1 + x2 -> {{(-1 - a1)/4, 0, (-1 - (2*I)*a1)/8, 0, 0, 0, 
        0, 0, (-1 - (2*I)*a1)/8, 0, ((-1 - I) + a1)/4, 0, 0, 0, 0, 0, -1/4*I, 
        1/4, 0, -1/4*I, 1/4, 0}, {0, (-1 - a1)/4, 0, (-1 - (2*I)*a1)/8, 0, 0, 
        0, 0, 0, (-1 - (2*I)*a1)/8, 0, ((-1 - I) + a1)/4, 0, 0, 0, 0, 0, 
        -1/4*I, 1/4, 1/4, I/4, 0}, {(I/4)*(1 + a1), 0, (I/2 - a1)/4, 0, 0, 0, 
        0, 0, (I/2 - a1)/4, 0, (-1/4*I)*((-1 - I) + a1), 0, 0, 0, 0, 0, -1/4, 
        -1/4*I, 0, -1/4, -1/4*I, 0}, {0, (I/4)*(1 + a1), 0, I/8 - a1/4, 0, 0, 
        0, 0, 0, (I/2 - a1)/4, 0, (-1/4*I)*((-1 - I) + a1), 0, 0, 0, 0, 0, 
        -1/4, -1/4*I, -1/4*I, 1/4, 0}, {0, 0, 0, 0, (-1 - a1)/4, 0, 
        (-1 - (2*I)*a1)/8, 0, 0, 0, 0, 0, (-1 - (2*I)*a1)/8, 0, 
        ((-1 - I) + a1)/4, 0, 1/4, I/4, 0, 0, -1/4*I, 1/4}, 
       {0, 0, 0, 0, 0, (-1 - a1)/4, 0, (-1 - (2*I)*a1)/8, 0, 0, 0, 0, 0, 
        (-1 - (2*I)*a1)/8, 0, ((-1 - I) + a1)/4, 0, 1/4, I/4, 0, 1/4, I/4}, 
       {0, 0, 0, 0, (I/4)*(1 + a1), 0, (I/2 - a1)/4, 0, 0, 0, 0, 0, 
        (I/2 - a1)/4, 0, (-1/4*I)*((-1 - I) + a1), 0, -1/4*I, 1/4, 0, 0, 
        -1/4, -1/4*I}, {0, 0, 0, 0, 0, (I/4)*(1 + a1), 0, (I/2 - a1)/4, 0, 0, 
        0, 0, 0, (I/2 - a1)/4, 0, (-1/4*I)*((-1 - I) + a1), 0, -1/4*I, 1/4, 
        0, -1/4*I, 1/4}, {(I/4)*(1 + a1), 0, (I/2 - a1)/4, 0, 0, 0, 0, 0, 
        (I/2 - a1)/4, 0, (-1/4*I)*((-1 - I) + a1), 0, 0, 0, 0, 0, -1/4, 
        -1/4*I, 0, -1/4, -1/4*I, 0}, {0, (I/4)*(1 + a1), 0, (I/2 - a1)/4, 0, 
        0, 0, 0, 0, (I/2 - a1)/4, 0, (-1/4*I)*((-1 - I) + a1), 0, 0, 0, 0, 0, 
        -1/4, -1/4*I, -1/4*I, 1/4, 0}, {(1 + a1)/4, 0, (I/8)*(-I + 2*a1), 0, 
        0, 0, 0, 0, (I/8)*(-I + 2*a1), 0, ((1 + I) - a1)/4, 0, 0, 0, 0, 0, 
        I/4, -1/4, 0, I/4, -1/4, 0}, {0, (1 + a1)/4, 0, (I/8)*(-I + 2*a1), 0, 
        0, 0, 0, 0, (I/8)*(-I + 2*a1), 0, ((1 + I) - a1)/4, 0, 0, 0, 0, 0, 
        I/4, -1/4, -1/4, -1/4*I, 0}, {0, 0, 0, 0, (I/4)*(1 + a1), 0, 
        (I/2 - a1)/4, 0, 0, 0, 0, 0, I/8 - a1/4, 0, (-1/4*I)*((-1 - I) + a1), 
        0, -1/4*I, 1/4, 0, 0, -1/4, -1/4*I}, {0, 0, 0, 0, 0, (I/4)*(1 + a1), 
        0, (I/2 - a1)/4, 0, 0, 0, 0, 0, (I/2 - a1)/4, 0, 
        (-1/4*I)*((-1 - I) + a1), 0, -1/4*I, 1/4, 0, -1/4*I, 1/4}, 
       {0, 0, 0, 0, (1 + a1)/4, 0, (I/8)*(-I + 2*a1), 0, 0, 0, 0, 0, 
        (I/8)*(-I + 2*a1), 0, ((1 + I) - a1)/4, 0, -1/4, -1/4*I, 0, 0, I/4, 
        -1/4}, {0, 0, 0, 0, 0, (1 + a1)/4, 0, (I/8)*(-I + 2*a1), 0, 0, 0, 0, 
        0, (I/8)*(-I + 2*a1), 0, ((1 + I) - a1)/4, 0, -1/4, -1/4*I, 0, -1/4, 
        -1/4*I}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}}, k2 - x1 - x2 -> {{(-1 - a2)/4, (1 + (2*I)*a2)/8, 0, 0, 
        (1 + (2*I)*a2)/8, ((-1 - I) + a2)/4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        I/4, 1/4, 0, I/4, 1/4, 0}, {(-1/4*I)*(1 + a2), (I/2 - a2)/4, 0, 0, 
        (I/2 - a2)/4, (I/4)*((-1 - I) + a2), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        -1/4, I/4, 0, -1/4, I/4, 0}, {0, 0, (-1 - a2)/4, (1 + (2*I)*a2)/8, 0, 
        0, (1 + (2*I)*a2)/8, ((-1 - I) + a2)/4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        I/4, 1/4, 1/4, -1/4*I, 0}, {0, 0, (-1/4*I)*(1 + a2), I/8 - a2/4, 0, 
        0, (I/2 - a2)/4, (I/4)*((-1 - I) + a2), 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        -1/4, I/4, I/4, 1/4, 0}, {(-1/4*I)*(1 + a2), (I/2 - a2)/4, 0, 0, 
        (I/2 - a2)/4, (I/4)*((-1 - I) + a2), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        -1/4, I/4, 0, -1/4, I/4, 0}, {(1 + a2)/4, (-1/8*I)*(-I + 2*a2), 0, 0, 
        (-1/8*I)*(-I + 2*a2), ((1 + I) - a2)/4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        -1/4*I, -1/4, 0, -1/4*I, -1/4, 0}, {0, 0, (-1/4*I)*(1 + a2), 
        (I/2 - a2)/4, 0, 0, (I/2 - a2)/4, (I/4)*((-1 - I) + a2), 0, 0, 0, 0, 
        0, 0, 0, 0, 0, -1/4, I/4, I/4, 1/4, 0}, {0, 0, (1 + a2)/4, 
        (-1/8*I)*(-I + 2*a2), 0, 0, (-1/8*I)*(-I + 2*a2), ((1 + I) - a2)/4, 
        0, 0, 0, 0, 0, 0, 0, 0, 0, -1/4*I, -1/4, -1/4, I/4, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, (-1 - a2)/4, (1 + (2*I)*a2)/8, 0, 0, 
        (1 + (2*I)*a2)/8, ((-1 - I) + a2)/4, 0, 0, 1/4, -1/4*I, 0, 0, I/4, 
        1/4}, {0, 0, 0, 0, 0, 0, 0, 0, (-1/4*I)*(1 + a2), (I/2 - a2)/4, 0, 0, 
        (I/2 - a2)/4, (I/4)*((-1 - I) + a2), 0, 0, I/4, 1/4, 0, 0, -1/4, 
        I/4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (-1 - a2)/4, (1 + (2*I)*a2)/8, 
        0, 0, (1 + (2*I)*a2)/8, ((-1 - I) + a2)/4, 0, 1/4, -1/4*I, 0, 1/4, 
        -1/4*I}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (-1/4*I)*(1 + a2), 
        (I/2 - a2)/4, 0, 0, (I/2 - a2)/4, (I/4)*((-1 - I) + a2), 0, I/4, 1/4, 
        0, I/4, 1/4}, {0, 0, 0, 0, 0, 0, 0, 0, (-1/4*I)*(1 + a2), 
        (I/2 - a2)/4, 0, 0, I/8 - a2/4, (I/4)*((-1 - I) + a2), 0, 0, I/4, 
        1/4, 0, 0, -1/4, I/4}, {0, 0, 0, 0, 0, 0, 0, 0, (1 + a2)/4, 
        (-1/8*I)*(-I + 2*a2), 0, 0, (-1/8*I)*(-I + 2*a2), ((1 + I) - a2)/4, 
        0, 0, -1/4, I/4, 0, 0, -1/4*I, -1/4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        (-1/4*I)*(1 + a2), (I/2 - a2)/4, 0, 0, (I/2 - a2)/4, 
        (I/4)*((-1 - I) + a2), 0, I/4, 1/4, 0, I/4, 1/4}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (1 + a2)/4, (-1/8*I)*(-I + 2*a2), 0, 0, 
        (-1/8*I)*(-I + 2*a2), ((1 + I) - a2)/4, 0, -1/4, I/4, 0, -1/4, I/4}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}}, 
     k2 + x1 - x2 -> {{(-1 - a2)/4, (1 + (2*I)*a2)/8, 0, 0, 
        (-1 - (2*I)*a2)/8, ((1 + I) - a2)/4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        -1/4*I, -1/4, 0, I/4, -1/4, 0}, {(-1/4*I)*(1 + a2), (I/2 - a2)/4, 0, 
        0, (-1/2*I + a2)/4, (-1/4*I)*((-1 - I) + a2), 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 1/4, -1/4*I, 0, -1/4, -1/4*I, 0}, {0, 0, (-1 - a2)/4, 
        (1 + (2*I)*a2)/8, 0, 0, (-1 - (2*I)*a2)/8, ((1 + I) - a2)/4, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, -1/4*I, -1/4, 1/4, I/4, 0}, 
       {0, 0, (-1/4*I)*(1 + a2), I/8 - a2/4, 0, 0, (-1/2*I + a2)/4, 
        (-1/4*I)*((-1 - I) + a2), 0, 0, 0, 0, 0, 0, 0, 0, 0, 1/4, -1/4*I, 
        I/4, -1/4, 0}, {(I/4)*(1 + a2), (-1/2*I + a2)/4, 0, 0, (I/2 - a2)/4, 
        (I/4)*((-1 - I) + a2), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1/4, I/4, 0, 
        1/4, I/4, 0}, {(-1 - a2)/4, (I/8)*(-I + 2*a2), 0, 0, 
        (-1/8*I)*(-I + 2*a2), ((1 + I) - a2)/4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        -1/4*I, -1/4, 0, I/4, -1/4, 0}, {0, 0, (I/4)*(1 + a2), 
        (-1/2*I + a2)/4, 0, 0, (I/2 - a2)/4, (I/4)*((-1 - I) + a2), 0, 0, 0, 
        0, 0, 0, 0, 0, 0, -1/4, I/4, -1/4*I, 1/4, 0}, 
       {0, 0, (-1 - a2)/4, (I/8)*(-I + 2*a2), 0, 0, (-1/8*I)*(-I + 2*a2), 
        ((1 + I) - a2)/4, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1/4*I, -1/4, 1/4, I/4, 
        0}, {0, 0, 0, 0, 0, 0, 0, 0, (-1 - a2)/4, (1 + (2*I)*a2)/8, 0, 0, 
        (-1 - (2*I)*a2)/8, ((1 + I) - a2)/4, 0, 0, 1/4, -1/4*I, 0, 0, I/4, 
        -1/4}, {0, 0, 0, 0, 0, 0, 0, 0, (-1/4*I)*(1 + a2), (I/2 - a2)/4, 0, 
        0, (-1/2*I + a2)/4, (-1/4*I)*((-1 - I) + a2), 0, 0, I/4, 1/4, 0, 0, 
        -1/4, -1/4*I}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (-1 - a2)/4, 
        (1 + (2*I)*a2)/8, 0, 0, (-1 - (2*I)*a2)/8, ((1 + I) - a2)/4, 0, 1/4, 
        -1/4*I, 0, 1/4, I/4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        (-1/4*I)*(1 + a2), (I/2 - a2)/4, 0, 0, (-1/2*I + a2)/4, 
        (-1/4*I)*((-1 - I) + a2), 0, I/4, 1/4, 0, I/4, -1/4}, 
       {0, 0, 0, 0, 0, 0, 0, 0, (I/4)*(1 + a2), (-1/2*I + a2)/4, 0, 0, 
        I/8 - a2/4, (I/4)*((-1 - I) + a2), 0, 0, -1/4*I, -1/4, 0, 0, 1/4, 
        I/4}, {0, 0, 0, 0, 0, 0, 0, 0, (-1 - a2)/4, (I/8)*(-I + 2*a2), 0, 0, 
        (-1/8*I)*(-I + 2*a2), ((1 + I) - a2)/4, 0, 0, 1/4, -1/4*I, 0, 0, I/4, 
        -1/4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (I/4)*(1 + a2), 
        (-1/2*I + a2)/4, 0, 0, (I/2 - a2)/4, (I/4)*((-1 - I) + a2), 0, 
        -1/4*I, -1/4, 0, -1/4*I, 1/4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        (-1 - a2)/4, (I/8)*(-I + 2*a2), 0, 0, (-1/8*I)*(-I + 2*a2), 
        ((1 + I) - a2)/4, 0, 1/4, -1/4*I, 0, 1/4, I/4}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}}, 
     k2 - x1 + x2 -> {{(-1 - a2)/4, (-1 - (2*I)*a2)/8, 0, 0, 
        (1 + (2*I)*a2)/8, ((1 + I) - a2)/4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        I/4, -1/4, 0, -1/4*I, -1/4, 0}, {(I/4)*(1 + a2), (I/2 - a2)/4, 0, 0, 
        (-1/2*I + a2)/4, (I/4)*((-1 - I) + a2), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        1/4, I/4, 0, -1/4, I/4, 0}, {0, 0, (-1 - a2)/4, (-1 - (2*I)*a2)/8, 0, 
        0, (1 + (2*I)*a2)/8, ((1 + I) - a2)/4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        I/4, -1/4, 1/4, -1/4*I, 0}, {0, 0, (I/4)*(1 + a2), I/8 - a2/4, 0, 0, 
        (-1/2*I + a2)/4, (I/4)*((-1 - I) + a2), 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        1/4, I/4, -1/4*I, -1/4, 0}, {(-1/4*I)*(1 + a2), (-1/2*I + a2)/4, 0, 
        0, (I/2 - a2)/4, (-1/4*I)*((-1 - I) + a2), 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, -1/4, -1/4*I, 0, 1/4, -1/4*I, 0}, {(-1 - a2)/4, 
        (-1/8*I)*(-I + 2*a2), 0, 0, (I/8)*(-I + 2*a2), ((1 + I) - a2)/4, 0, 
        0, 0, 0, 0, 0, 0, 0, 0, 0, I/4, -1/4, 0, -1/4*I, -1/4, 0}, 
       {0, 0, (-1/4*I)*(1 + a2), (-1/2*I + a2)/4, 0, 0, (I/2 - a2)/4, 
        (-1/4*I)*((-1 - I) + a2), 0, 0, 0, 0, 0, 0, 0, 0, 0, -1/4, -1/4*I, 
        I/4, 1/4, 0}, {0, 0, (-1 - a2)/4, (-1/8*I)*(-I + 2*a2), 0, 0, 
        (I/8)*(-I + 2*a2), ((1 + I) - a2)/4, 0, 0, 0, 0, 0, 0, 0, 0, 0, I/4, 
        -1/4, 1/4, -1/4*I, 0}, {0, 0, 0, 0, 0, 0, 0, 0, (-1 - a2)/4, 
        (-1 - (2*I)*a2)/8, 0, 0, (1 + (2*I)*a2)/8, ((1 + I) - a2)/4, 0, 0, 
        1/4, I/4, 0, 0, -1/4*I, -1/4}, {0, 0, 0, 0, 0, 0, 0, 0, 
        (I/4)*(1 + a2), (I/2 - a2)/4, 0, 0, (-1/2*I + a2)/4, 
        (I/4)*((-1 - I) + a2), 0, 0, -1/4*I, 1/4, 0, 0, -1/4, I/4}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (-1 - a2)/4, (-1 - (2*I)*a2)/8, 0, 0, 
        (1 + (2*I)*a2)/8, ((1 + I) - a2)/4, 0, 1/4, I/4, 0, 1/4, -1/4*I}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (I/4)*(1 + a2), (I/2 - a2)/4, 0, 0, 
        (-1/2*I + a2)/4, (I/4)*((-1 - I) + a2), 0, -1/4*I, 1/4, 0, -1/4*I, 
        -1/4}, {0, 0, 0, 0, 0, 0, 0, 0, (-1/4*I)*(1 + a2), (-1/2*I + a2)/4, 
        0, 0, I/8 - a2/4, (-1/4*I)*((-1 - I) + a2), 0, 0, I/4, -1/4, 0, 0, 
        1/4, -1/4*I}, {0, 0, 0, 0, 0, 0, 0, 0, (-1 - a2)/4, 
        (-1/8*I)*(-I + 2*a2), 0, 0, (I/8)*(-I + 2*a2), ((1 + I) - a2)/4, 0, 
        0, 1/4, I/4, 0, 0, -1/4*I, -1/4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        (-1/4*I)*(1 + a2), (-1/2*I + a2)/4, 0, 0, (I/2 - a2)/4, 
        (-1/4*I)*((-1 - I) + a2), 0, I/4, -1/4, 0, I/4, 1/4}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (-1 - a2)/4, (-1/8*I)*(-I + 2*a2), 0, 
        0, (I/8)*(-I + 2*a2), ((1 + I) - a2)/4, 0, 1/4, I/4, 0, 1/4, -1/4*I}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}}, 
     k2 + x1 + x2 -> {{(-1 - a2)/4, (-1 - (2*I)*a2)/8, 0, 0, 
        (-1 - (2*I)*a2)/8, ((-1 - I) + a2)/4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        -1/4*I, 1/4, 0, -1/4*I, 1/4, 0}, {(I/4)*(1 + a2), (I/2 - a2)/4, 0, 0, 
        (I/2 - a2)/4, (-1/4*I)*((-1 - I) + a2), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        -1/4, -1/4*I, 0, -1/4, -1/4*I, 0}, {0, 0, (-1 - a2)/4, 
        (-1 - (2*I)*a2)/8, 0, 0, (-1 - (2*I)*a2)/8, ((-1 - I) + a2)/4, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, -1/4*I, 1/4, 1/4, I/4, 0}, 
       {0, 0, (I/4)*(1 + a2), I/8 - a2/4, 0, 0, (I/2 - a2)/4, 
        (-1/4*I)*((-1 - I) + a2), 0, 0, 0, 0, 0, 0, 0, 0, 0, -1/4, -1/4*I, 
        -1/4*I, 1/4, 0}, {(I/4)*(1 + a2), (I/2 - a2)/4, 0, 0, (I/2 - a2)/4, 
        (-1/4*I)*((-1 - I) + a2), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1/4, -1/4*I, 
        0, -1/4, -1/4*I, 0}, {(1 + a2)/4, (I/8)*(-I + 2*a2), 0, 0, 
        (I/8)*(-I + 2*a2), ((1 + I) - a2)/4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        I/4, -1/4, 0, I/4, -1/4, 0}, {0, 0, (I/4)*(1 + a2), (I/2 - a2)/4, 0, 
        0, (I/2 - a2)/4, (-1/4*I)*((-1 - I) + a2), 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        -1/4, -1/4*I, -1/4*I, 1/4, 0}, {0, 0, (1 + a2)/4, (I/8)*(-I + 2*a2), 
        0, 0, (I/8)*(-I + 2*a2), ((1 + I) - a2)/4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        I/4, -1/4, -1/4, -1/4*I, 0}, {0, 0, 0, 0, 0, 0, 0, 0, (-1 - a2)/4, 
        (-1 - (2*I)*a2)/8, 0, 0, (-1 - (2*I)*a2)/8, ((-1 - I) + a2)/4, 0, 0, 
        1/4, I/4, 0, 0, -1/4*I, 1/4}, {0, 0, 0, 0, 0, 0, 0, 0, 
        (I/4)*(1 + a2), (I/2 - a2)/4, 0, 0, (I/2 - a2)/4, 
        (-1/4*I)*((-1 - I) + a2), 0, 0, -1/4*I, 1/4, 0, 0, -1/4, -1/4*I}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (-1 - a2)/4, (-1 - (2*I)*a2)/8, 0, 0, 
        (-1 - (2*I)*a2)/8, ((-1 - I) + a2)/4, 0, 1/4, I/4, 0, 1/4, I/4}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (I/4)*(1 + a2), (I/2 - a2)/4, 0, 0, 
        (I/2 - a2)/4, (-1/4*I)*((-1 - I) + a2), 0, -1/4*I, 1/4, 0, -1/4*I, 
        1/4}, {0, 0, 0, 0, 0, 0, 0, 0, (I/4)*(1 + a2), (I/2 - a2)/4, 0, 0, 
        I/8 - a2/4, (-1/4*I)*((-1 - I) + a2), 0, 0, -1/4*I, 1/4, 0, 0, -1/4, 
        -1/4*I}, {0, 0, 0, 0, 0, 0, 0, 0, (1 + a2)/4, (I/8)*(-I + 2*a2), 0, 
        0, (I/8)*(-I + 2*a2), ((1 + I) - a2)/4, 0, 0, -1/4, -1/4*I, 0, 0, 
        I/4, -1/4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (I/4)*(1 + a2), 
        (I/2 - a2)/4, 0, 0, (I/2 - a2)/4, (-1/4*I)*((-1 - I) + a2), 0, 
        -1/4*I, 1/4, 0, -1/4*I, 1/4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        (1 + a2)/4, (I/8)*(-I + 2*a2), 0, 0, (I/8)*(-I + 2*a2), 
        ((1 + I) - a2)/4, 0, -1/4, -1/4*I, 0, -1/4, -1/4*I}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}}, 
     x2 -> {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0}, {0, -1 - I/2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0}, {0, 0, -1 - I/2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0}, {0, 0, 0, -2 - I, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, -1 - I/2, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, -1 - I/2, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, -2 - I, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 
        -1 - I/2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1 - I/2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2 - I, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1 - I/2, 0, 0, 0, 0, 
        0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1 - I/2, 0, 
        0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        -2 - I, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, -1 - I/2, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, -2 - I, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}}, 
     x1 -> {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0}, {0, 0, 0, 0, -1 - I/2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0}, {0, 0, 0, 0, 0, -1 - I/2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, -1 - I/2, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, -1 - I/2, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, -1 - I/2, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 
        -1 - I/2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1 - I/2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1 - I/2, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2 - I, 0, 0, 0, 0, 0, 
        0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2 - I, 0, 0, 0, 
        0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2 - I, 0, 
        0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        -2 - I, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, -1 - I/2, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0, 0, -2 - I}}, (4*I)/(Pi*x1^(1 + I/2)) -> 
      {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}}, 
     k1 + k2 -> {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        (-1/2 + I/4) - a1/2 - a2/2, 0, ((1 + (3*I)/2) - a1 - a2)/2, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        ((-1 + I/2) - a1 - a2)/2, 0, (1/2 + (3*I)/4) - a1/2 - a2/2, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        (-1/2 + I/4) - a1/2 - a2/2, 0, ((1 + (3*I)/2) - a1 - a2)/2}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        ((-1 + I/2) - a1 - a2)/2, 0, (1/2 + (3*I)/4) - a1/2 - a2/2}}, 
     k1 + k2 - 2*x2 -> {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        (-1/4 + I/8) - a1/4 - a2/4, (I/2)*(-I + a1 + a2), 
        ((-1 - (3*I)/2) + a1 + a2)/4, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, (-1/4*I)*((1 - I/2) + a1 + a2), 
        I/2 - a1/2 - a2/2, (I/4)*((-1 - (3*I)/2) + a1 + a2), 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        ((1 - I/2) + a1 + a2)/4, (-1/2*I)*(-I + a1 + a2), 
        (1/4 + (3*I)/8) - a1/4 - a2/4, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}}, k1 + k2 + 2*x2 -> 
      {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        (-1/4 + I/8) - a1/4 - a2/4, (-1/2*I)*(-I + a1 + a2), 
        ((-1 - (3*I)/2) + a1 + a2)/4, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, (I/4)*((1 - I/2) + a1 + a2), I/2 - a1/2 - a2/2, 
        (-1/4*I)*((-1 - (3*I)/2) + a1 + a2), 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        ((1 - I/2) + a1 + a2)/4, (I/2)*(-I + a1 + a2), 
        (1/4 + (3*I)/8) - a1/4 - a2/4, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}}, k1 + k2 - 2*x1 -> 
      {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        (-1/4 + I/8) - a1/4 - a2/4, (I/2)*(-I + a1 + a2), 
        ((-1 - (3*I)/2) + a1 + a2)/4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, (-1/4*I)*((1 - I/2) + a1 + a2), 
        I/2 - a1/2 - a2/2, (I/4)*((-1 - (3*I)/2) + a1 + a2)}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        ((1 - I/2) + a1 + a2)/4, (-1/2*I)*(-I + a1 + a2), 
        (1/4 + (3*I)/8) - a1/4 - a2/4}}, k1 + k2 + 2*x1 -> 
      {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
       {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        (-1/4 + I/8) - a1/4 - a2/4, (-1/2*I)*(-I + a1 + a2), 
        ((-1 - (3*I)/2) + a1 + a2)/4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, (I/4)*((1 - I/2) + a1 + a2), I/2 - a1/2 - a2/2, 
        (-1/4*I)*((-1 - (3*I)/2) + a1 + a2)}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0, 0, ((1 - I/2) + a1 + a2)/4, 
        (I/2)*(-I + a1 + a2), (1/4 + (3*I)/8) - a1/4 - a2/4}}, 
     (4*I)/(Pi*x2^(1 + I/2)) -> {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 1, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 1, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 1}}|>, "dlogResidual" -> 
    {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
     {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
     {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
     {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
     {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
     {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
     {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
     {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
     {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
     {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
     {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
     {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
     {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
     {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
     {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
     {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
     {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
     {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
     {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
     {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
     {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
     {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}}, 
   "constantResidueQ" -> True, "contactR1MasterShiftQ" -> True, 
   "contactR1ReductionClosedQ" -> True, "normalizationAbsorbedQ" -> True, 
   "kinematicSymbols" -> {k1, k2, x1, x2}, "formulaAuthority" -> 
    "2401.00129 Eq. (3.55), (3.65), (3.68)"|>, 
 "contactMaps" -> 
  <|"11" -> {<|"sourceSector" -> "11", "targetSector" -> "01", 
      "eventId" -> "11->01:{1}", "lineId" -> 1, "selectedLineIds" -> {1}, 
      "bundleLineIds" -> {1, 2}, "thetaBundleCoefficient" -> 1, 
      "lineTypes" -> {"massiveFull"}, "endpointComponents" -> {1, 2}, 
      "matricesByComponent" -> <|1 -> {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 
         0, 0}, {-1, 0, 0}, {0, -1, 0}, {0, -1, 0}, {0, 0, -1}, {1, 0, 0}, 
         {0, 1, 0}, {0, 1, 0}, {0, 0, 1}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, 
         {0, 0, 0}}, 2 -> {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {1, 0, 
         0}, {0, 1, 0}, {0, 1, 0}, {0, 0, 1}, {-1, 0, 0}, {0, -1, 0}, {0, -1, 
         0}, {0, 0, -1}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}}|>, 
      "R0TargetShift" -> {-1}, "R1TargetShiftsByComponent" -> 
       <|1 -> {0}, 2 -> {0}|>, "normalizationRatio" -> 
       (-1/4*I)*Pi*x1^(1 + I/2), "pinchNormalization" -> 
       (4*I)/(Pi*x1^(1 + I/2)), "absorbedNormalization" -> 1|>, 
     <|"sourceSector" -> "11", "targetSector" -> "10", 
      "eventId" -> "11->10:{2}", "lineId" -> 2, "selectedLineIds" -> {2}, 
      "bundleLineIds" -> {1, 2}, "thetaBundleCoefficient" -> 1, 
      "lineTypes" -> {"massiveFull"}, "endpointComponents" -> {1, 2}, 
      "matricesByComponent" -> <|1 -> {{0, 0, 0}, {-1, 0, 0}, {1, 0, 0}, {0, 
         0, 0}, {0, 0, 0}, {0, -1, 0}, {0, 1, 0}, {0, 0, 0}, {0, 0, 0}, {0, 
         -1, 0}, {0, 1, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, -1}, {0, 0, 1}, {0, 
         0, 0}}, 2 -> {{0, 0, 0}, {1, 0, 0}, {-1, 0, 0}, {0, 0, 0}, {0, 0, 
         0}, {0, 1, 0}, {0, -1, 0}, {0, 0, 0}, {0, 0, 0}, {0, 1, 0}, {0, -1, 
         0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 1}, {0, 0, -1}, {0, 0, 0}}|>, 
      "R0TargetShift" -> {-1}, "R1TargetShiftsByComponent" -> 
       <|1 -> {0}, 2 -> {0}|>, "normalizationRatio" -> 
       (-1/4*I)*Pi*x2^(1 + I/2), "pinchNormalization" -> 
       (4*I)/(Pi*x2^(1 + I/2)), "absorbedNormalization" -> 1|>}, "01" -> {}, 
   "10" -> {}|>|>
