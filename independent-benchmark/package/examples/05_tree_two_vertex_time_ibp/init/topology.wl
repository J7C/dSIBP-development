<|"name" -> "014TreeTwoVertexPlusPlus", 
 "vertexData" -> {{v1, "+"}, {v2, "+"}}, "vertexIds" -> {v1, v2}, 
 "vertexSignAssoc" -> <|v1 -> "+", v2 -> "+"|>, 
 "lines" -> {<|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> ell12, 
    "treeEnergy" -> k12, "nu" -> nu12, "bbType" -> "h", 
    "massType" -> "massive", "skType" -> "++", "state" -> "full", 
    "thetaConvention" -> "mergedTwoTheta", "packType" -> "massiveFull", 
    "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], 
    "masslessN1OppositeEndpoint" -> Missing["NotApplicable"], 
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
          2*nu12|>}, "shrinkZeroPointShift" -> 2*nu12|>|>}, "extLegs" -> {}, 
 "vertexEnergies" -> <|v1 -> K1, v2 -> K2|>, "activeVertexIds" -> {v1, v2}, 
 "fixedAVertexValues" -> <||>, "loopMomenta" -> {ell12}, 
 "externalMomenta" -> {}, "rawExternalInvariantRules" -> Automatic, 
 "externalInvariantRules" -> {}, "ispData" -> {}, "nV" -> 2, "nE" -> 1, 
 "nL" -> 1, "nK" -> 0, "bMatrix" -> {{1}, {-1}}, 
 "vertexLines" -> {{{1, 1}}, {{1, -1}}}, "loopCoeffMatrix" -> {{1}}, 
 "externalCoeffMatrix" -> {{}}, "externalPartList" -> {0}, 
 "numericRules" -> {}, "sampleDiscreteRules" -> {}, 
 "seedPreset" -> "quickCheck", "seedRanges" -> <|"a" -> {0}, "b" -> {0}, 
   "isp" -> {0}, "sampleOnly" -> True|>, "generatorSeedRanges" -> {}, 
 "seedOptions" -> <|"DiscreteMode" -> "sample", "MaxSeedRuleCount" -> 200, 
   "MaxDiscreteRuleCount" -> 64, "MaxEquationCount" -> 80, 
   "MaxShrinkSectorDepth" -> Automatic, "MaxShrinkSectorCount" -> 16|>, 
 "unknownSeedPreset" -> None, "zeroPointRules" -> 
  {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta12}, 
 "shrinkPrefactorRules" -> {E^(Pi*Im[nu12]) -> eta12}, "symmetryRules" -> {}, 
 "thetaBoundarySignOffset" -> Automatic, "kiraOrdering" -> <||>, 
 "sectorVertexRepresentativeMap" -> <|v1 -> v1, v2 -> v2|>, 
 "sectorMetadata" -> <|"caseName" -> "014TreeTwoVertexPlusPlus", 
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
   "lineSlots" -> {<|"slot" -> 1, "lineId" -> 1, "packType" -> "massiveFull", 
      "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v2}, 
      "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" -> 
       Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
       Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, 
      "endpointCompactASlots" -> {1, 2}, "bSymbol" -> b[1], 
      "packTemplate" -> {b[1], n[1, 1], n[1, 2]}|>}, 
   "lineIdToSlot" -> <|1 -> 1|>, "bSymbolToLineSlot" -> <|b[1] -> 1|>, 
   "ispSlots" -> {}|>, "sectorMetadataList" -> 
  {<|"caseName" -> "014TreeTwoVertexPlusPlus", "sectorShrunkLines" -> {}, 
    "sectorKey" -> "top", "aSlotMode" -> "compactActiveSlots", 
    "sectorVertexRepresentativeMap" -> <|v1 -> v1, v2 -> v2|>, 
    "vertexIdToOriginalASlot" -> <|v1 -> 1, v2 -> 2|>, 
    "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 2|>, 
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
     {<|"slot" -> 1, "lineId" -> 1, "packType" -> "massiveFull", 
       "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v2}, 
       "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" -> 
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, 
       "endpointCompactASlots" -> {1, 2}, "bSymbol" -> b[1], 
       "packTemplate" -> {b[1], n[1, 1], n[1, 2]}|>}, 
    "lineIdToSlot" -> <|1 -> 1|>, "bSymbolToLineSlot" -> <|b[1] -> 1|>, 
    "ispSlots" -> {}|>, <|"caseName" -> "014TreeTwoVertexPlusPlus_sector_e1", 
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
    "lineSlots" -> {<|"slot" -> 1, "lineId" -> 1, "packType" -> "shrunk", 
       "massType" -> "massive", "state" -> "shrunk", "endpoints" -> {v1, v1}, 
       "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" -> 
        Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
        Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, 
       "endpointCompactASlots" -> {1, 1}, "bSymbol" -> bS[1], 
       "packTemplate" -> {bS[1]}|>}, "lineIdToSlot" -> <|1 -> 1|>, 
    "bSymbolToLineSlot" -> <|bS[1] -> 1|>, "ispSlots" -> {}|>}, 
 "indexMaps" -> <|"vertexIdToOriginalASlot" -> <|v1 -> 1, v2 -> 2|>, 
   "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 2|>, 
   "lineIdToSlot" -> <|1 -> 1|>, "bSymbolToLineSlot" -> <|b[1] -> 1|>, 
   "compactASlots" -> {<|"compactSlot" -> 1, "representativeVertexId" -> v1, 
      "originalVertexIds" -> {v1}, "originalSlots" -> {1}, 
      "aSymbol" -> a[v1]|>, <|"compactSlot" -> 2, "representativeVertexId" -> 
       v2, "originalVertexIds" -> {v2}, "originalSlots" -> {2}, 
      "aSymbol" -> a[v2]|>}, "lineSlots" -> 
    {<|"slot" -> 1, "lineId" -> 1, "packType" -> "massiveFull", 
      "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v2}, 
      "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" -> 
       Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
       Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, 
      "endpointCompactASlots" -> {1, 2}, "bSymbol" -> b[1], 
      "packTemplate" -> {b[1], n[1, 1], n[1, 2]}|>}, "ispSlots" -> {}|>, 
 "seedSummary" -> <|"continuousVariables" -> {a[v1], a[v2], b[1]}, 
   "discreteVariables" -> {n[1, 1], n[1, 2]}, "discreteStateCount" -> 4, 
   "momentumGeneratorCount" -> 1, "timeGeneratorCount" -> 2, 
   "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0}, 
     "sampleOnly" -> True|>, "numericRules" -> {}, 
   "numericRuleRequirementReport" -> <|"providedNumericVariables" -> {}, 
     "internalProvidedNumericVariables" -> {}, 
     "requiredExternalInvariants" -> {}, 
     "internalRequiredExternalInvariants" -> {}, 
     "externalInvariantNamingReport" -> <|"externalMomenta" -> {}, 
       "externalInvariantRules" -> {}, "internalExternalInvariantRules" -> 
        {}, "defaultNamingConvention" -> 
        "sij, where i,j are positions in externalMomenta and i<=j", 
       "message" -> "\:5708\:52a8\:91cf\:76f8\:5173\:6807\:91cf\:79ef\:7684\
\:7528\:6237\:8f93\:5165\:7edf\:4e00\:7528 \
sp[p,r]\:ff1b\:5916\:52a8\:91cf-\:5916\:52a8\:91cf\:4e0d\:53d8\:91cf\:5728\
\:8f93\:51fa\:7aef\:4f7f\:7528 externalInvariantRules \
\:6307\:5b9a\:7684\:53d8\:91cf\:540d\:ff0c\:672a\:6307\:5b9a\:65f6\:9ed8\
\:8ba4\:6309 externalMomenta \:987a\:5e8f\:8f93\:51fa\:4e3a sij\:3002"|>, 
     "vertexEnergyNamingReport" -> <|"convention" -> "vertex external energy \
uses ke[i] for independent absolute-value parameters; expressions built from \
external invariant names are normalized to the same scalar-product \
coordinates used by loop momenta", "rawVertexEnergies" -> 
        <|v1 -> K1, v2 -> K2|>, "internalVertexEnergies" -> 
        <|v1 -> K1, v2 -> K2|>, "userVertexEnergies" -> 
        <|v1 -> K1, v2 -> K2|>, "dependencyData" -> 
        <|v1 -> <|"internalExternalInvariantVariables" -> {}, 
           "externalInvariantVariables" -> {}, 
           "internalIndependentVertexEnergyParameters" -> {K1}, 
           "independentVertexEnergyParameters" -> {K1}, 
           "usesExternalInvariantQ" -> False, 
           "usesIndependentVertexEnergyQ" -> True, "kind" -> 
            "independentVertexEnergyParameter"|>, 
         v2 -> <|"internalExternalInvariantVariables" -> {}, 
           "externalInvariantVariables" -> {}, 
           "internalIndependentVertexEnergyParameters" -> {K2}, 
           "independentVertexEnergyParameters" -> {K2}, 
           "usesExternalInvariantQ" -> False, 
           "usesIndependentVertexEnergyQ" -> True, "kind" -> 
            "independentVertexEnergyParameter"|>|>, "message" -> "vertexEnerg\
ies \
\:7684\:6bcf\:4e2a\:503c\:8868\:793a\:4e00\:4e2a\:9876\:70b9\:8fde\:7740\
\:7684\:6240\:6709\:5916\:817f\:6253\:5305\:540e\:7684 e \
\:6307\:6570\:80fd\:91cf\:3002\:82e5\:8be5\:80fd\:91cf\:548c externalMomenta \
\:7a7a\:95f4\:7684\:5916\:90e8\:4e0d\:53d8\:91cf\:662f\:540c\:4e00\:53d8\
\:91cf\:ff0c\:5e94\:5199\:6210 externalInvariantRules \
\:8f93\:51fa\:53d8\:91cf\:7684\:51fd\:6570\:ff0c\:4f8b\:5982 \
Sqrt[s11]\:ff1b\:5426\:5219\:5199\:72ec\:7acb ke[i]\:3002\:4e0d\:8981\:628a \
|ke1+ke2| \:4e0e |ke1|+|ke2| \:6df7\:540c\:ff1b\:82e5 |ke1+ke2| \
\:72ec\:7acb\:ff0c\:5e94\:5355\:72ec\:547d\:540d\:4e3a \
ke[i]\:3002\:5916\:817f\:80fd\:91cf\:53c2\:6570\:4e4b\:95f4\:4e0d\:751f\:6210\
\:70b9\:79ef\:5173\:7cfb\:3002"|>, "requiredVertexEnergies" -> {K1, K2}, 
     "internalRequiredVertexEnergies" -> {K1, K2}, 
     "requiredLineParameters" -> {nu12}, "requiredNumericVariables" -> 
      {K1, K2, nu12}, "internalRequiredNumericVariables" -> {K1, K2, nu12}, 
     "missingExternalInvariants" -> {}, 
     "internalMissingExternalInvariants" -> {}, "missingVertexEnergies" -> 
      {K1, K2}, "internalMissingVertexEnergies" -> {K1, K2}, 
     "missingLineParameters" -> {nu12}, "missingNumericVariables" -> 
      {K1, K2, nu12}, "internalMissingNumericVariables" -> {K1, K2, nu12}, 
     "completeStaticNumericRulesQ" -> False|>, 
   "externalInvariantNamingReport" -> <|"externalMomenta" -> {}, 
     "externalInvariantRules" -> {}, "internalExternalInvariantRules" -> {}, 
     "defaultNamingConvention" -> 
      "sij, where i,j are positions in externalMomenta and i<=j", 
     "message" -> "\:5708\:52a8\:91cf\:76f8\:5173\:6807\:91cf\:79ef\:7684\
\:7528\:6237\:8f93\:5165\:7edf\:4e00\:7528 \
sp[p,r]\:ff1b\:5916\:52a8\:91cf-\:5916\:52a8\:91cf\:4e0d\:53d8\:91cf\:5728\
\:8f93\:51fa\:7aef\:4f7f\:7528 externalInvariantRules \
\:6307\:5b9a\:7684\:53d8\:91cf\:540d\:ff0c\:672a\:6307\:5b9a\:65f6\:9ed8\
\:8ba4\:6309 externalMomenta \:987a\:5e8f\:8f93\:51fa\:4e3a sij\:3002"|>, 
   "vertexEnergyNamingReport" -> <|"convention" -> "vertex external energy \
uses ke[i] for independent absolute-value parameters; expressions built from \
external invariant names are normalized to the same scalar-product \
coordinates used by loop momenta", "rawVertexEnergies" -> 
      <|v1 -> K1, v2 -> K2|>, "internalVertexEnergies" -> 
      <|v1 -> K1, v2 -> K2|>, "userVertexEnergies" -> <|v1 -> K1, v2 -> K2|>, 
     "dependencyData" -> <|v1 -> <|"internalExternalInvariantVariables" -> 
          {}, "externalInvariantVariables" -> {}, 
         "internalIndependentVertexEnergyParameters" -> {K1}, 
         "independentVertexEnergyParameters" -> {K1}, 
         "usesExternalInvariantQ" -> False, "usesIndependentVertexEnergyQ" -> 
          True, "kind" -> "independentVertexEnergyParameter"|>, 
       v2 -> <|"internalExternalInvariantVariables" -> {}, 
         "externalInvariantVariables" -> {}, 
         "internalIndependentVertexEnergyParameters" -> {K2}, 
         "independentVertexEnergyParameters" -> {K2}, 
         "usesExternalInvariantQ" -> False, "usesIndependentVertexEnergyQ" -> 
          True, "kind" -> "independentVertexEnergyParameter"|>|>, 
     "message" -> "vertexEnergies \
\:7684\:6bcf\:4e2a\:503c\:8868\:793a\:4e00\:4e2a\:9876\:70b9\:8fde\:7740\
\:7684\:6240\:6709\:5916\:817f\:6253\:5305\:540e\:7684 e \
\:6307\:6570\:80fd\:91cf\:3002\:82e5\:8be5\:80fd\:91cf\:548c externalMomenta \
\:7a7a\:95f4\:7684\:5916\:90e8\:4e0d\:53d8\:91cf\:662f\:540c\:4e00\:53d8\
\:91cf\:ff0c\:5e94\:5199\:6210 externalInvariantRules \
\:8f93\:51fa\:53d8\:91cf\:7684\:51fd\:6570\:ff0c\:4f8b\:5982 \
Sqrt[s11]\:ff1b\:5426\:5219\:5199\:72ec\:7acb ke[i]\:3002\:4e0d\:8981\:628a \
|ke1+ke2| \:4e0e |ke1|+|ke2| \:6df7\:540c\:ff1b\:82e5 |ke1+ke2| \
\:72ec\:7acb\:ff0c\:5e94\:5355\:72ec\:547d\:540d\:4e3a \
ke[i]\:3002\:5916\:817f\:80fd\:91cf\:53c2\:6570\:4e4b\:95f4\:4e0d\:751f\:6210\
\:70b9\:79ef\:5173\:7cfb\:3002"|>, "sampleDiscreteRules" -> {}|>, 
 "validationReport" -> <|"status" -> "ok", "errorCount" -> 0, 
   "warningCount" -> 3, "pendingCount" -> 0, 
   "numericRuleRequirementReport" -> <|"providedNumericVariables" -> {}, 
     "internalProvidedNumericVariables" -> {}, 
     "requiredExternalInvariants" -> {}, 
     "internalRequiredExternalInvariants" -> {}, 
     "externalInvariantNamingReport" -> <|"externalMomenta" -> {}, 
       "externalInvariantRules" -> {}, "internalExternalInvariantRules" -> 
        {}, "defaultNamingConvention" -> 
        "sij, where i,j are positions in externalMomenta and i<=j", 
       "message" -> "\:5708\:52a8\:91cf\:76f8\:5173\:6807\:91cf\:79ef\:7684\
\:7528\:6237\:8f93\:5165\:7edf\:4e00\:7528 \
sp[p,r]\:ff1b\:5916\:52a8\:91cf-\:5916\:52a8\:91cf\:4e0d\:53d8\:91cf\:5728\
\:8f93\:51fa\:7aef\:4f7f\:7528 externalInvariantRules \
\:6307\:5b9a\:7684\:53d8\:91cf\:540d\:ff0c\:672a\:6307\:5b9a\:65f6\:9ed8\
\:8ba4\:6309 externalMomenta \:987a\:5e8f\:8f93\:51fa\:4e3a sij\:3002"|>, 
     "vertexEnergyNamingReport" -> <|"convention" -> "vertex external energy \
uses ke[i] for independent absolute-value parameters; expressions built from \
external invariant names are normalized to the same scalar-product \
coordinates used by loop momenta", "rawVertexEnergies" -> 
        <|v1 -> K1, v2 -> K2|>, "internalVertexEnergies" -> 
        <|v1 -> K1, v2 -> K2|>, "userVertexEnergies" -> 
        <|v1 -> K1, v2 -> K2|>, "dependencyData" -> 
        <|v1 -> <|"internalExternalInvariantVariables" -> {}, 
           "externalInvariantVariables" -> {}, 
           "internalIndependentVertexEnergyParameters" -> {K1}, 
           "independentVertexEnergyParameters" -> {K1}, 
           "usesExternalInvariantQ" -> False, 
           "usesIndependentVertexEnergyQ" -> True, "kind" -> 
            "independentVertexEnergyParameter"|>, 
         v2 -> <|"internalExternalInvariantVariables" -> {}, 
           "externalInvariantVariables" -> {}, 
           "internalIndependentVertexEnergyParameters" -> {K2}, 
           "independentVertexEnergyParameters" -> {K2}, 
           "usesExternalInvariantQ" -> False, 
           "usesIndependentVertexEnergyQ" -> True, "kind" -> 
            "independentVertexEnergyParameter"|>|>, "message" -> "vertexEnerg\
ies \
\:7684\:6bcf\:4e2a\:503c\:8868\:793a\:4e00\:4e2a\:9876\:70b9\:8fde\:7740\
\:7684\:6240\:6709\:5916\:817f\:6253\:5305\:540e\:7684 e \
\:6307\:6570\:80fd\:91cf\:3002\:82e5\:8be5\:80fd\:91cf\:548c externalMomenta \
\:7a7a\:95f4\:7684\:5916\:90e8\:4e0d\:53d8\:91cf\:662f\:540c\:4e00\:53d8\
\:91cf\:ff0c\:5e94\:5199\:6210 externalInvariantRules \
\:8f93\:51fa\:53d8\:91cf\:7684\:51fd\:6570\:ff0c\:4f8b\:5982 \
Sqrt[s11]\:ff1b\:5426\:5219\:5199\:72ec\:7acb ke[i]\:3002\:4e0d\:8981\:628a \
|ke1+ke2| \:4e0e |ke1|+|ke2| \:6df7\:540c\:ff1b\:82e5 |ke1+ke2| \
\:72ec\:7acb\:ff0c\:5e94\:5355\:72ec\:547d\:540d\:4e3a \
ke[i]\:3002\:5916\:817f\:80fd\:91cf\:53c2\:6570\:4e4b\:95f4\:4e0d\:751f\:6210\
\:70b9\:79ef\:5173\:7cfb\:3002"|>, "requiredVertexEnergies" -> {K1, K2}, 
     "internalRequiredVertexEnergies" -> {K1, K2}, 
     "requiredLineParameters" -> {nu12}, "requiredNumericVariables" -> 
      {K1, K2, nu12}, "internalRequiredNumericVariables" -> {K1, K2, nu12}, 
     "missingExternalInvariants" -> {}, 
     "internalMissingExternalInvariants" -> {}, "missingVertexEnergies" -> 
      {K1, K2}, "internalMissingVertexEnergies" -> {K1, K2}, 
     "missingLineParameters" -> {nu12}, "missingNumericVariables" -> 
      {K1, K2, nu12}, "internalMissingNumericVariables" -> {K1, K2, nu12}, 
     "completeStaticNumericRulesQ" -> False|>, "pendingFeatures" -> {}, 
   "issues" -> {<|"severity" -> "warning", 
      "code" -> "numericRulesMissingVertexEnergies", 
      "missingVertexEnergies" -> {K1, K2}, "numericRules" -> {}, 
      "comment" -> "analytic seed can still be generated; numeric linear/Kira \
stages need vertex energy rules from time IBP"|>, <|"severity" -> "warning", 
      "code" -> "numericRulesMissingLineParameters", 
      "missingLineParameters" -> {nu12}, "numericRules" -> {}, 
      "comment" -> "analytic seed can still be generated; numeric linear/Kira \
stages need massive line parameter rules"|>, <|"severity" -> "warning", 
      "code" -> "sampleDiscreteRulesMissingForDiscreteVariables", 
      "missingVariables" -> {n[1, 1], n[1, 2]}, "comment" -> "sample seed \
mode needs complete n=0/1 rules; DiscreteMode -> all can enumerate them \
automatically"|>}|>, "numericRuleRequirementReport" -> 
  <|"providedNumericVariables" -> {}, "internalProvidedNumericVariables" -> 
    {}, "requiredExternalInvariants" -> {}, 
   "internalRequiredExternalInvariants" -> {}, 
   "externalInvariantNamingReport" -> <|"externalMomenta" -> {}, 
     "externalInvariantRules" -> {}, "internalExternalInvariantRules" -> {}, 
     "defaultNamingConvention" -> 
      "sij, where i,j are positions in externalMomenta and i<=j", 
     "message" -> "\:5708\:52a8\:91cf\:76f8\:5173\:6807\:91cf\:79ef\:7684\
\:7528\:6237\:8f93\:5165\:7edf\:4e00\:7528 \
sp[p,r]\:ff1b\:5916\:52a8\:91cf-\:5916\:52a8\:91cf\:4e0d\:53d8\:91cf\:5728\
\:8f93\:51fa\:7aef\:4f7f\:7528 externalInvariantRules \
\:6307\:5b9a\:7684\:53d8\:91cf\:540d\:ff0c\:672a\:6307\:5b9a\:65f6\:9ed8\
\:8ba4\:6309 externalMomenta \:987a\:5e8f\:8f93\:51fa\:4e3a sij\:3002"|>, 
   "vertexEnergyNamingReport" -> <|"convention" -> "vertex external energy \
uses ke[i] for independent absolute-value parameters; expressions built from \
external invariant names are normalized to the same scalar-product \
coordinates used by loop momenta", "rawVertexEnergies" -> 
      <|v1 -> K1, v2 -> K2|>, "internalVertexEnergies" -> 
      <|v1 -> K1, v2 -> K2|>, "userVertexEnergies" -> <|v1 -> K1, v2 -> K2|>, 
     "dependencyData" -> <|v1 -> <|"internalExternalInvariantVariables" -> 
          {}, "externalInvariantVariables" -> {}, 
         "internalIndependentVertexEnergyParameters" -> {K1}, 
         "independentVertexEnergyParameters" -> {K1}, 
         "usesExternalInvariantQ" -> False, "usesIndependentVertexEnergyQ" -> 
          True, "kind" -> "independentVertexEnergyParameter"|>, 
       v2 -> <|"internalExternalInvariantVariables" -> {}, 
         "externalInvariantVariables" -> {}, 
         "internalIndependentVertexEnergyParameters" -> {K2}, 
         "independentVertexEnergyParameters" -> {K2}, 
         "usesExternalInvariantQ" -> False, "usesIndependentVertexEnergyQ" -> 
          True, "kind" -> "independentVertexEnergyParameter"|>|>, 
     "message" -> "vertexEnergies \
\:7684\:6bcf\:4e2a\:503c\:8868\:793a\:4e00\:4e2a\:9876\:70b9\:8fde\:7740\
\:7684\:6240\:6709\:5916\:817f\:6253\:5305\:540e\:7684 e \
\:6307\:6570\:80fd\:91cf\:3002\:82e5\:8be5\:80fd\:91cf\:548c externalMomenta \
\:7a7a\:95f4\:7684\:5916\:90e8\:4e0d\:53d8\:91cf\:662f\:540c\:4e00\:53d8\
\:91cf\:ff0c\:5e94\:5199\:6210 externalInvariantRules \
\:8f93\:51fa\:53d8\:91cf\:7684\:51fd\:6570\:ff0c\:4f8b\:5982 \
Sqrt[s11]\:ff1b\:5426\:5219\:5199\:72ec\:7acb ke[i]\:3002\:4e0d\:8981\:628a \
|ke1+ke2| \:4e0e |ke1|+|ke2| \:6df7\:540c\:ff1b\:82e5 |ke1+ke2| \
\:72ec\:7acb\:ff0c\:5e94\:5355\:72ec\:547d\:540d\:4e3a \
ke[i]\:3002\:5916\:817f\:80fd\:91cf\:53c2\:6570\:4e4b\:95f4\:4e0d\:751f\:6210\
\:70b9\:79ef\:5173\:7cfb\:3002"|>, "requiredVertexEnergies" -> {K1, K2}, 
   "internalRequiredVertexEnergies" -> {K1, K2}, "requiredLineParameters" -> 
    {nu12}, "requiredNumericVariables" -> {K1, K2, nu12}, 
   "internalRequiredNumericVariables" -> {K1, K2, nu12}, 
   "missingExternalInvariants" -> {}, "internalMissingExternalInvariants" -> 
    {}, "missingVertexEnergies" -> {K1, K2}, 
   "internalMissingVertexEnergies" -> {K1, K2}, "missingLineParameters" -> 
    {nu12}, "missingNumericVariables" -> {K1, K2, nu12}, 
   "internalMissingNumericVariables" -> {K1, K2, nu12}, 
   "completeStaticNumericRulesQ" -> False|>, "numericRuleTemplate" -> 
  {K1 -> dSIBP`Private`numericValue[K1], 
   K2 -> dSIBP`Private`numericValue[K2], 
   nu12 -> dSIBP`Private`numericValue[nu12]}, 
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
 "masslessBundleCandidates" -> {}, "masslessEndpointConventions" -> {}, 
 "precomputedShrinkSectorSummary" -> <|"status" -> "generated", 
   "completeCoverageQ" -> True|>, "precomputedShrinkSectorKeys" -> 
  {"top", "e1"}|>
