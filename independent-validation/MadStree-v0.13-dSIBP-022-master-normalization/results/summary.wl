<|"status" -> "passed", "overallPassed" -> True, "date" -> "2026-08-20",
 "gitCommit" -> "ea5add8e432fa4902cff9b21170a15538ce633bb",
 "versions" -> <|"MadStree" -> "0.13", "dSIBP" -> "022.0"|>,
 "sourceFiles" -> <|"MadStreeEntry" -> "F:\\Agent-projects-nut\\dSibp_package\
\\package-MadStree\\versions\\MadStree-v0.13\\Kernel\\MadStree.wl",
   "MadStreeSectors" -> "F:\\Agent-projects-nut\\dSibp_package\\package-MadSt\
ree\\versions\\MadStree-v0.13\\Kernel\\Core\\Sectors.wl",
   "dSIBPEntry" -> "F:\\Agent-projects-nut\\dSibp_package\\package-dSibp\\ver\
sions\\022_dSIBP\\Kernel\\dSIBP.wl", "dSIBPSectorModel" -> "F:\\Agent-project\
s-nut\\dSibp_package\\package-dSibp\\versions\\022_dSIBP\\Kernel\\Core\\Secto\
rModel018.wl"|>, "sourceHashes" ->
  <|"MadStreeEntry" ->
    "b95290ac94a56857ce3ec58dbcc51e1c45b350bc9a51e21331e17e772a0cde1f",
   "MadStreeSectors" ->
    "a6e9f21960049557f5782de36d4c5890a95d40a5b563034c74c3e98459749c6d",
   "dSIBPEntry" ->
    "1cc24485c4337d7a0fa4d27515906b9b2aa66554ef453dc81a741a1ee7304119",
   "dSIBPSectorModel" ->
    "17628d00205735062966beca4a23e83784bf10c1a791795579e61084ae631543"|>,
 "scope" -> "master identity and normalization only; no IBP, reduction, Kira, \
DE, boundary or transport", "conventions" -> <|"vertexTypes" -> "all +",
   "MadStreeNuConvention" -> "Positive, input mu_e",
   "dSIBPNuConvention" -> "h preset with nu_e=-mu_e",
   "basis" ->
    "h on both sides; massless full uses one shared quotient state",
   "sectorKey" -> "root line order, 1=active, 0=contracted",
   "stateOrder" ->
    "massive endpoint 1, endpoint 2; massless shared; IntegerDigits order",
   "normalization" ->
    "MadStree sector normalization versus dSIBP compiled Wronskian product"|>\
, "caseCount" -> 3, "passedCaseCount" -> 3, "sectorCount" -> 10,
 "slotOrderEqualCount" -> 10, "selectorEqualCount" -> 10,
 "normalizationEqualSectorCount" -> 10, "masterCount" -> 45,
 "identityEqualCount" -> 45, "normalizationEqualMasterCount" -> 45,
 "wallTimeSeconds" -> 1.5967525`6.,
 "cases" -> {<|"name" -> "two_vertex_massive",
    "title" -> "\:4e24\:9876\:70b9\:5355 massive tree",
    "masses" -> {"massive"}, "sectorOrder" -> {"1", "0"},
    "sectorMasterCounts" -> {4, 1}, "expectedMasterCount" -> 5,
    "madStreeMasterCount" -> 5, "dSIBPMasterCount" -> 5,
    "sectorResults" -> {<|"sectorKey" -> "1", "contractedLinePositions" ->
        {}, "madSlots" -> {<|"linePosition" -> 1, "kind" ->
           "massiveEndpoint", "endpoint" -> 1|>, <|"linePosition" -> 1,
          "kind" -> "massiveEndpoint", "endpoint" -> 2|>},
       "dsibpSlots" -> {<|"linePosition" -> 1, "kind" -> "massiveEndpoint",
          "endpoint" -> 1|>, <|"linePosition" -> 1,
          "kind" -> "massiveEndpoint", "endpoint" -> 2|>},
       "slotOrderEqual" -> True, "madCoefficient" -> 1,
       "dsibpCompiledWronskianCoefficient" -> 1,
       "dsibpPhysicalSectorPrefactor" -> 1, "dsibpSelector" -> 1,
       "expectedSelector" -> 1, "oracleCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "madMatchesOracle" -> True, "dsibpMatchesOracle" -> True,
       "selectorMatches" -> True, "splitReconstructs" -> True|>,
      <|"sectorKey" -> "0", "contractedLinePositions" -> {1},
       "madSlots" -> {}, "dsibpSlots" -> {}, "slotOrderEqual" -> True,
       "madCoefficient" -> ((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi),
       "dsibpCompiledWronskianCoefficient" -> ((-4*I)*sE1^(-1 + 2*mu1))/
         (E^(Pi*Im[mu1])*Pi), "dsibpPhysicalSectorPrefactor" ->
        ((4*I)*sE1^(2*mu1))/(E^(Pi*Im[mu1])*Pi), "dsibpSelector" ->
        -sE1^(-1), "expectedSelector" -> -sE1^(-1), "oracleCoefficient" ->
        ((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi),
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "madMatchesOracle" -> True, "dsibpMatchesOracle" -> True,
       "selectorMatches" -> True, "splitReconstructs" -> True|>},
    "masterResults" -> {<|"globalIndex" -> 1, "madStreeIntegral" ->
        MSIntegral["1", {0, 0}, {0, 0}], "dSIBPIntegral" ->
        Inactive[J]["1", {0, 0}, {0, 0}], "madStreeIdentity" ->
        <|"sectorKey" -> "1", "timeShifts" -> {0, 0}, "stateBits" -> {0,
          0}|>, "dSIBPIdentity" -> <|"sectorKey" -> "1",
         "timeShifts" -> {0, 0}, "stateBits" -> {0, 0}|>,
       "identityEqual" -> True, "madStreeCoefficient" -> 1,
       "dSIBPCoefficient" -> 1, "coefficientDifference" -> 0,
       "coefficientRatio" -> 1, "passed" -> True|>, <|"globalIndex" -> 2,
       "madStreeIntegral" -> MSIntegral["1", {0, 0}, {0, 1}],
       "dSIBPIntegral" -> Inactive[J]["1", {0, 0}, {0, 1}],
       "madStreeIdentity" -> <|"sectorKey" -> "1", "timeShifts" -> {0, 0},
         "stateBits" -> {0, 1}|>, "dSIBPIdentity" -> <|"sectorKey" -> "1",
         "timeShifts" -> {0, 0}, "stateBits" -> {0, 1}|>,
       "identityEqual" -> True, "madStreeCoefficient" -> 1,
       "dSIBPCoefficient" -> 1, "coefficientDifference" -> 0,
       "coefficientRatio" -> 1, "passed" -> True|>, <|"globalIndex" -> 3,
       "madStreeIntegral" -> MSIntegral["1", {0, 0}, {1, 0}],
       "dSIBPIntegral" -> Inactive[J]["1", {0, 0}, {1, 0}],
       "madStreeIdentity" -> <|"sectorKey" -> "1", "timeShifts" -> {0, 0},
         "stateBits" -> {1, 0}|>, "dSIBPIdentity" -> <|"sectorKey" -> "1",
         "timeShifts" -> {0, 0}, "stateBits" -> {1, 0}|>,
       "identityEqual" -> True, "madStreeCoefficient" -> 1,
       "dSIBPCoefficient" -> 1, "coefficientDifference" -> 0,
       "coefficientRatio" -> 1, "passed" -> True|>, <|"globalIndex" -> 4,
       "madStreeIntegral" -> MSIntegral["1", {0, 0}, {1, 1}],
       "dSIBPIntegral" -> Inactive[J]["1", {0, 0}, {1, 1}],
       "madStreeIdentity" -> <|"sectorKey" -> "1", "timeShifts" -> {0, 0},
         "stateBits" -> {1, 1}|>, "dSIBPIdentity" -> <|"sectorKey" -> "1",
         "timeShifts" -> {0, 0}, "stateBits" -> {1, 1}|>,
       "identityEqual" -> True, "madStreeCoefficient" -> 1,
       "dSIBPCoefficient" -> 1, "coefficientDifference" -> 0,
       "coefficientRatio" -> 1, "passed" -> True|>, <|"globalIndex" -> 5,
       "madStreeIntegral" -> MSIntegral["0", {0}, {}],
       "dSIBPIntegral" -> Inactive[J]["0", {0}, {}], "madStreeIdentity" ->
        <|"sectorKey" -> "0", "timeShifts" -> {0}, "stateBits" -> {}|>,
       "dSIBPIdentity" -> <|"sectorKey" -> "0", "timeShifts" -> {0},
         "stateBits" -> {}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> ((-4*I)*sE1^(-1 + 2*mu1))/
         (E^(Pi*Im[mu1])*Pi), "dSIBPCoefficient" -> ((-4*I)*sE1^(-1 + 2*mu1))/
         (E^(Pi*Im[mu1])*Pi), "coefficientDifference" -> 0,
       "coefficientRatio" -> 1, "passed" -> True|>}, "passed" -> True|>,
   <|"name" -> "three_vertex_massive",
    "title" -> "\:4e09\:9876\:70b9\:53cc massive chain",
    "masses" -> {"massive", "massive"}, "sectorOrder" ->
     {"11", "01", "10", "00"}, "sectorMasterCounts" -> {16, 4, 4, 1},
    "expectedMasterCount" -> 25, "madStreeMasterCount" -> 25,
    "dSIBPMasterCount" -> 25, "sectorResults" ->
     {<|"sectorKey" -> "11", "contractedLinePositions" -> {},
       "madSlots" -> {<|"linePosition" -> 1, "kind" -> "massiveEndpoint",
          "endpoint" -> 1|>, <|"linePosition" -> 1,
          "kind" -> "massiveEndpoint", "endpoint" -> 2|>,
         <|"linePosition" -> 2, "kind" -> "massiveEndpoint",
          "endpoint" -> 1|>, <|"linePosition" -> 2,
          "kind" -> "massiveEndpoint", "endpoint" -> 2|>},
       "dsibpSlots" -> {<|"linePosition" -> 1, "kind" -> "massiveEndpoint",
          "endpoint" -> 1|>, <|"linePosition" -> 1,
          "kind" -> "massiveEndpoint", "endpoint" -> 2|>,
         <|"linePosition" -> 2, "kind" -> "massiveEndpoint",
          "endpoint" -> 1|>, <|"linePosition" -> 2,
          "kind" -> "massiveEndpoint", "endpoint" -> 2|>},
       "slotOrderEqual" -> True, "madCoefficient" -> 1,
       "dsibpCompiledWronskianCoefficient" -> 1,
       "dsibpPhysicalSectorPrefactor" -> 1, "dsibpSelector" -> 1,
       "expectedSelector" -> 1, "oracleCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "madMatchesOracle" -> True, "dsibpMatchesOracle" -> True,
       "selectorMatches" -> True, "splitReconstructs" -> True|>,
      <|"sectorKey" -> "01", "contractedLinePositions" -> {1},
       "madSlots" -> {<|"linePosition" -> 2, "kind" -> "massiveEndpoint",
          "endpoint" -> 1|>, <|"linePosition" -> 2,
          "kind" -> "massiveEndpoint", "endpoint" -> 2|>},
       "dsibpSlots" -> {<|"linePosition" -> 2, "kind" -> "massiveEndpoint",
          "endpoint" -> 1|>, <|"linePosition" -> 2,
          "kind" -> "massiveEndpoint", "endpoint" -> 2|>},
       "slotOrderEqual" -> True, "madCoefficient" ->
        ((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi),
       "dsibpCompiledWronskianCoefficient" -> ((-4*I)*sE1^(-1 + 2*mu1))/
         (E^(Pi*Im[mu1])*Pi), "dsibpPhysicalSectorPrefactor" ->
        ((4*I)*sE1^(2*mu1))/(E^(Pi*Im[mu1])*Pi), "dsibpSelector" ->
        -sE1^(-1), "expectedSelector" -> -sE1^(-1), "oracleCoefficient" ->
        ((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi),
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "madMatchesOracle" -> True, "dsibpMatchesOracle" -> True,
       "selectorMatches" -> True, "splitReconstructs" -> True|>,
      <|"sectorKey" -> "10", "contractedLinePositions" -> {2},
       "madSlots" -> {<|"linePosition" -> 1, "kind" -> "massiveEndpoint",
          "endpoint" -> 1|>, <|"linePosition" -> 1,
          "kind" -> "massiveEndpoint", "endpoint" -> 2|>},
       "dsibpSlots" -> {<|"linePosition" -> 1, "kind" -> "massiveEndpoint",
          "endpoint" -> 1|>, <|"linePosition" -> 1,
          "kind" -> "massiveEndpoint", "endpoint" -> 2|>},
       "slotOrderEqual" -> True, "madCoefficient" ->
        ((-4*I)*sE2^(-1 + 2*mu2))/(E^(Pi*Im[mu2])*Pi),
       "dsibpCompiledWronskianCoefficient" -> ((-4*I)*sE2^(-1 + 2*mu2))/
         (E^(Pi*Im[mu2])*Pi), "dsibpPhysicalSectorPrefactor" ->
        ((4*I)*sE2^(2*mu2))/(E^(Pi*Im[mu2])*Pi), "dsibpSelector" ->
        -sE2^(-1), "expectedSelector" -> -sE2^(-1), "oracleCoefficient" ->
        ((-4*I)*sE2^(-1 + 2*mu2))/(E^(Pi*Im[mu2])*Pi),
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "madMatchesOracle" -> True, "dsibpMatchesOracle" -> True,
       "selectorMatches" -> True, "splitReconstructs" -> True|>,
      <|"sectorKey" -> "00", "contractedLinePositions" -> {1, 2},
       "madSlots" -> {}, "dsibpSlots" -> {}, "slotOrderEqual" -> True,
       "madCoefficient" -> (-16*sE1^(-1 + 2*mu1)*sE2^(-1 + 2*mu2))/
         (E^(Pi*(Im[mu1] + Im[mu2]))*Pi^2),
       "dsibpCompiledWronskianCoefficient" ->
        (-16*E^(-(Pi*Im[mu1]) - Pi*Im[mu2])*sE1^(-1 + 2*mu1)*
          sE2^(-1 + 2*mu2))/Pi^2, "dsibpPhysicalSectorPrefactor" ->
        (-16*E^(-(Pi*Im[mu1]) - Pi*Im[mu2])*sE1^(2*mu1)*sE2^(2*mu2))/Pi^2,
       "dsibpSelector" -> 1/(sE1*sE2), "expectedSelector" -> 1/(sE1*sE2),
       "oracleCoefficient" -> (-16*E^(-(Pi*Im[mu1]) - Pi*Im[mu2])*
          sE1^(-1 + 2*mu1)*sE2^(-1 + 2*mu2))/Pi^2, "coefficientDifference" ->
        0, "coefficientRatio" -> 1, "madMatchesOracle" -> True,
       "dsibpMatchesOracle" -> True, "selectorMatches" -> True,
       "splitReconstructs" -> True|>}, "masterResults" ->
     {<|"globalIndex" -> 1, "madStreeIntegral" -> MSIntegral["11", {0, 0, 0},
         {0, 0, 0, 0}], "dSIBPIntegral" -> Inactive[J]["11", {0, 0, 0}, {0,
         0, 0, 0}], "madStreeIdentity" -> <|"sectorKey" -> "11",
         "timeShifts" -> {0, 0, 0}, "stateBits" -> {0, 0, 0, 0}|>,
       "dSIBPIdentity" -> <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {0, 0, 0, 0}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> 1, "dSIBPCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 2, "madStreeIntegral" ->
        MSIntegral["11", {0, 0, 0}, {0, 0, 0, 1}], "dSIBPIntegral" ->
        Inactive[J]["11", {0, 0, 0}, {0, 0, 0, 1}], "madStreeIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {0, 0, 0, 1}|>, "dSIBPIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {0, 0, 0, 1}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> 1, "dSIBPCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 3, "madStreeIntegral" ->
        MSIntegral["11", {0, 0, 0}, {0, 0, 1, 0}], "dSIBPIntegral" ->
        Inactive[J]["11", {0, 0, 0}, {0, 0, 1, 0}], "madStreeIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {0, 0, 1, 0}|>, "dSIBPIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {0, 0, 1, 0}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> 1, "dSIBPCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 4, "madStreeIntegral" ->
        MSIntegral["11", {0, 0, 0}, {0, 0, 1, 1}], "dSIBPIntegral" ->
        Inactive[J]["11", {0, 0, 0}, {0, 0, 1, 1}], "madStreeIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {0, 0, 1, 1}|>, "dSIBPIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {0, 0, 1, 1}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> 1, "dSIBPCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 5, "madStreeIntegral" ->
        MSIntegral["11", {0, 0, 0}, {0, 1, 0, 0}], "dSIBPIntegral" ->
        Inactive[J]["11", {0, 0, 0}, {0, 1, 0, 0}], "madStreeIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {0, 1, 0, 0}|>, "dSIBPIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {0, 1, 0, 0}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> 1, "dSIBPCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 6, "madStreeIntegral" ->
        MSIntegral["11", {0, 0, 0}, {0, 1, 0, 1}], "dSIBPIntegral" ->
        Inactive[J]["11", {0, 0, 0}, {0, 1, 0, 1}], "madStreeIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {0, 1, 0, 1}|>, "dSIBPIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {0, 1, 0, 1}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> 1, "dSIBPCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 7, "madStreeIntegral" ->
        MSIntegral["11", {0, 0, 0}, {0, 1, 1, 0}], "dSIBPIntegral" ->
        Inactive[J]["11", {0, 0, 0}, {0, 1, 1, 0}], "madStreeIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {0, 1, 1, 0}|>, "dSIBPIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {0, 1, 1, 0}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> 1, "dSIBPCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 8, "madStreeIntegral" ->
        MSIntegral["11", {0, 0, 0}, {0, 1, 1, 1}], "dSIBPIntegral" ->
        Inactive[J]["11", {0, 0, 0}, {0, 1, 1, 1}], "madStreeIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {0, 1, 1, 1}|>, "dSIBPIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {0, 1, 1, 1}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> 1, "dSIBPCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 9, "madStreeIntegral" ->
        MSIntegral["11", {0, 0, 0}, {1, 0, 0, 0}], "dSIBPIntegral" ->
        Inactive[J]["11", {0, 0, 0}, {1, 0, 0, 0}], "madStreeIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {1, 0, 0, 0}|>, "dSIBPIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {1, 0, 0, 0}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> 1, "dSIBPCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 10, "madStreeIntegral" ->
        MSIntegral["11", {0, 0, 0}, {1, 0, 0, 1}], "dSIBPIntegral" ->
        Inactive[J]["11", {0, 0, 0}, {1, 0, 0, 1}], "madStreeIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {1, 0, 0, 1}|>, "dSIBPIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {1, 0, 0, 1}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> 1, "dSIBPCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 11, "madStreeIntegral" ->
        MSIntegral["11", {0, 0, 0}, {1, 0, 1, 0}], "dSIBPIntegral" ->
        Inactive[J]["11", {0, 0, 0}, {1, 0, 1, 0}], "madStreeIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {1, 0, 1, 0}|>, "dSIBPIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {1, 0, 1, 0}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> 1, "dSIBPCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 12, "madStreeIntegral" ->
        MSIntegral["11", {0, 0, 0}, {1, 0, 1, 1}], "dSIBPIntegral" ->
        Inactive[J]["11", {0, 0, 0}, {1, 0, 1, 1}], "madStreeIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {1, 0, 1, 1}|>, "dSIBPIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {1, 0, 1, 1}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> 1, "dSIBPCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 13, "madStreeIntegral" ->
        MSIntegral["11", {0, 0, 0}, {1, 1, 0, 0}], "dSIBPIntegral" ->
        Inactive[J]["11", {0, 0, 0}, {1, 1, 0, 0}], "madStreeIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {1, 1, 0, 0}|>, "dSIBPIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {1, 1, 0, 0}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> 1, "dSIBPCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 14, "madStreeIntegral" ->
        MSIntegral["11", {0, 0, 0}, {1, 1, 0, 1}], "dSIBPIntegral" ->
        Inactive[J]["11", {0, 0, 0}, {1, 1, 0, 1}], "madStreeIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {1, 1, 0, 1}|>, "dSIBPIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {1, 1, 0, 1}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> 1, "dSIBPCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 15, "madStreeIntegral" ->
        MSIntegral["11", {0, 0, 0}, {1, 1, 1, 0}], "dSIBPIntegral" ->
        Inactive[J]["11", {0, 0, 0}, {1, 1, 1, 0}], "madStreeIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {1, 1, 1, 0}|>, "dSIBPIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {1, 1, 1, 0}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> 1, "dSIBPCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 16, "madStreeIntegral" ->
        MSIntegral["11", {0, 0, 0}, {1, 1, 1, 1}], "dSIBPIntegral" ->
        Inactive[J]["11", {0, 0, 0}, {1, 1, 1, 1}], "madStreeIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {1, 1, 1, 1}|>, "dSIBPIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {1, 1, 1, 1}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> 1, "dSIBPCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 17, "madStreeIntegral" ->
        MSIntegral["01", {0, 0}, {0, 0}], "dSIBPIntegral" ->
        Inactive[J]["01", {0, 0}, {0, 0}], "madStreeIdentity" ->
        <|"sectorKey" -> "01", "timeShifts" -> {0, 0}, "stateBits" -> {0,
          0}|>, "dSIBPIdentity" -> <|"sectorKey" -> "01",
         "timeShifts" -> {0, 0}, "stateBits" -> {0, 0}|>,
       "identityEqual" -> True, "madStreeCoefficient" ->
        ((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi),
       "dSIBPCoefficient" -> ((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi),
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 18, "madStreeIntegral" ->
        MSIntegral["01", {0, 0}, {0, 1}], "dSIBPIntegral" ->
        Inactive[J]["01", {0, 0}, {0, 1}], "madStreeIdentity" ->
        <|"sectorKey" -> "01", "timeShifts" -> {0, 0}, "stateBits" -> {0,
          1}|>, "dSIBPIdentity" -> <|"sectorKey" -> "01",
         "timeShifts" -> {0, 0}, "stateBits" -> {0, 1}|>,
       "identityEqual" -> True, "madStreeCoefficient" ->
        ((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi),
       "dSIBPCoefficient" -> ((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi),
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 19, "madStreeIntegral" ->
        MSIntegral["01", {0, 0}, {1, 0}], "dSIBPIntegral" ->
        Inactive[J]["01", {0, 0}, {1, 0}], "madStreeIdentity" ->
        <|"sectorKey" -> "01", "timeShifts" -> {0, 0}, "stateBits" -> {1,
          0}|>, "dSIBPIdentity" -> <|"sectorKey" -> "01",
         "timeShifts" -> {0, 0}, "stateBits" -> {1, 0}|>,
       "identityEqual" -> True, "madStreeCoefficient" ->
        ((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi),
       "dSIBPCoefficient" -> ((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi),
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 20, "madStreeIntegral" ->
        MSIntegral["01", {0, 0}, {1, 1}], "dSIBPIntegral" ->
        Inactive[J]["01", {0, 0}, {1, 1}], "madStreeIdentity" ->
        <|"sectorKey" -> "01", "timeShifts" -> {0, 0}, "stateBits" -> {1,
          1}|>, "dSIBPIdentity" -> <|"sectorKey" -> "01",
         "timeShifts" -> {0, 0}, "stateBits" -> {1, 1}|>,
       "identityEqual" -> True, "madStreeCoefficient" ->
        ((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi),
       "dSIBPCoefficient" -> ((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi),
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 21, "madStreeIntegral" ->
        MSIntegral["10", {0, 0}, {0, 0}], "dSIBPIntegral" ->
        Inactive[J]["10", {0, 0}, {0, 0}], "madStreeIdentity" ->
        <|"sectorKey" -> "10", "timeShifts" -> {0, 0}, "stateBits" -> {0,
          0}|>, "dSIBPIdentity" -> <|"sectorKey" -> "10",
         "timeShifts" -> {0, 0}, "stateBits" -> {0, 0}|>,
       "identityEqual" -> True, "madStreeCoefficient" ->
        ((-4*I)*sE2^(-1 + 2*mu2))/(E^(Pi*Im[mu2])*Pi),
       "dSIBPCoefficient" -> ((-4*I)*sE2^(-1 + 2*mu2))/(E^(Pi*Im[mu2])*Pi),
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 22, "madStreeIntegral" ->
        MSIntegral["10", {0, 0}, {0, 1}], "dSIBPIntegral" ->
        Inactive[J]["10", {0, 0}, {0, 1}], "madStreeIdentity" ->
        <|"sectorKey" -> "10", "timeShifts" -> {0, 0}, "stateBits" -> {0,
          1}|>, "dSIBPIdentity" -> <|"sectorKey" -> "10",
         "timeShifts" -> {0, 0}, "stateBits" -> {0, 1}|>,
       "identityEqual" -> True, "madStreeCoefficient" ->
        ((-4*I)*sE2^(-1 + 2*mu2))/(E^(Pi*Im[mu2])*Pi),
       "dSIBPCoefficient" -> ((-4*I)*sE2^(-1 + 2*mu2))/(E^(Pi*Im[mu2])*Pi),
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 23, "madStreeIntegral" ->
        MSIntegral["10", {0, 0}, {1, 0}], "dSIBPIntegral" ->
        Inactive[J]["10", {0, 0}, {1, 0}], "madStreeIdentity" ->
        <|"sectorKey" -> "10", "timeShifts" -> {0, 0}, "stateBits" -> {1,
          0}|>, "dSIBPIdentity" -> <|"sectorKey" -> "10",
         "timeShifts" -> {0, 0}, "stateBits" -> {1, 0}|>,
       "identityEqual" -> True, "madStreeCoefficient" ->
        ((-4*I)*sE2^(-1 + 2*mu2))/(E^(Pi*Im[mu2])*Pi),
       "dSIBPCoefficient" -> ((-4*I)*sE2^(-1 + 2*mu2))/(E^(Pi*Im[mu2])*Pi),
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 24, "madStreeIntegral" ->
        MSIntegral["10", {0, 0}, {1, 1}], "dSIBPIntegral" ->
        Inactive[J]["10", {0, 0}, {1, 1}], "madStreeIdentity" ->
        <|"sectorKey" -> "10", "timeShifts" -> {0, 0}, "stateBits" -> {1,
          1}|>, "dSIBPIdentity" -> <|"sectorKey" -> "10",
         "timeShifts" -> {0, 0}, "stateBits" -> {1, 1}|>,
       "identityEqual" -> True, "madStreeCoefficient" ->
        ((-4*I)*sE2^(-1 + 2*mu2))/(E^(Pi*Im[mu2])*Pi),
       "dSIBPCoefficient" -> ((-4*I)*sE2^(-1 + 2*mu2))/(E^(Pi*Im[mu2])*Pi),
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 25, "madStreeIntegral" ->
        MSIntegral["00", {0}, {}], "dSIBPIntegral" -> Inactive[J]["00", {0},
         {}], "madStreeIdentity" -> <|"sectorKey" -> "00",
         "timeShifts" -> {0}, "stateBits" -> {}|>, "dSIBPIdentity" ->
        <|"sectorKey" -> "00", "timeShifts" -> {0}, "stateBits" -> {}|>,
       "identityEqual" -> True, "madStreeCoefficient" ->
        (-16*sE1^(-1 + 2*mu1)*sE2^(-1 + 2*mu2))/(E^(Pi*(Im[mu1] + Im[mu2]))*
          Pi^2), "dSIBPCoefficient" -> (-16*E^(-(Pi*Im[mu1]) - Pi*Im[mu2])*
          sE1^(-1 + 2*mu1)*sE2^(-1 + 2*mu2))/Pi^2, "coefficientDifference" ->
        0, "coefficientRatio" -> 1, "passed" -> True|>}, "passed" -> True|>,
   <|"name" -> "three_vertex_mixed", "title" ->
     "\:4e09\:9876\:70b9 massive+massless chain",
    "masses" -> {"massive", "massless"}, "sectorOrder" ->
     {"11", "01", "10", "00"}, "sectorMasterCounts" -> {8, 2, 4, 1},
    "expectedMasterCount" -> 15, "madStreeMasterCount" -> 15,
    "dSIBPMasterCount" -> 15, "sectorResults" ->
     {<|"sectorKey" -> "11", "contractedLinePositions" -> {},
       "madSlots" -> {<|"linePosition" -> 1, "kind" -> "massiveEndpoint",
          "endpoint" -> 1|>, <|"linePosition" -> 1,
          "kind" -> "massiveEndpoint", "endpoint" -> 2|>,
         <|"linePosition" -> 2, "kind" -> "masslessShared",
          "endpoint" -> "shared"|>}, "dsibpSlots" ->
        {<|"linePosition" -> 1, "kind" -> "massiveEndpoint",
          "endpoint" -> 1|>, <|"linePosition" -> 1,
          "kind" -> "massiveEndpoint", "endpoint" -> 2|>,
         <|"linePosition" -> 2, "kind" -> "masslessShared",
          "endpoint" -> "shared"|>}, "slotOrderEqual" -> True,
       "madCoefficient" -> 1, "dsibpCompiledWronskianCoefficient" -> 1,
       "dsibpPhysicalSectorPrefactor" -> 1, "dsibpSelector" -> 1,
       "expectedSelector" -> 1, "oracleCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "madMatchesOracle" -> True, "dsibpMatchesOracle" -> True,
       "selectorMatches" -> True, "splitReconstructs" -> True|>,
      <|"sectorKey" -> "01", "contractedLinePositions" -> {1},
       "madSlots" -> {<|"linePosition" -> 2, "kind" -> "masslessShared",
          "endpoint" -> "shared"|>}, "dsibpSlots" ->
        {<|"linePosition" -> 2, "kind" -> "masslessShared",
          "endpoint" -> "shared"|>}, "slotOrderEqual" -> True,
       "madCoefficient" -> ((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi),
       "dsibpCompiledWronskianCoefficient" -> ((-4*I)*sE1^(-1 + 2*mu1))/
         (E^(Pi*Im[mu1])*Pi), "dsibpPhysicalSectorPrefactor" ->
        ((4*I)*sE1^(2*mu1))/(E^(Pi*Im[mu1])*Pi), "dsibpSelector" ->
        -sE1^(-1), "expectedSelector" -> -sE1^(-1), "oracleCoefficient" ->
        ((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi),
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "madMatchesOracle" -> True, "dsibpMatchesOracle" -> True,
       "selectorMatches" -> True, "splitReconstructs" -> True|>,
      <|"sectorKey" -> "10", "contractedLinePositions" -> {2},
       "madSlots" -> {<|"linePosition" -> 1, "kind" -> "massiveEndpoint",
          "endpoint" -> 1|>, <|"linePosition" -> 1,
          "kind" -> "massiveEndpoint", "endpoint" -> 2|>},
       "dsibpSlots" -> {<|"linePosition" -> 1, "kind" -> "massiveEndpoint",
          "endpoint" -> 1|>, <|"linePosition" -> 1,
          "kind" -> "massiveEndpoint", "endpoint" -> 2|>},
       "slotOrderEqual" -> True, "madCoefficient" -> 1,
       "dsibpCompiledWronskianCoefficient" -> 1,
       "dsibpPhysicalSectorPrefactor" -> 1, "dsibpSelector" -> 1,
       "expectedSelector" -> 1, "oracleCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "madMatchesOracle" -> True, "dsibpMatchesOracle" -> True,
       "selectorMatches" -> True, "splitReconstructs" -> True|>,
      <|"sectorKey" -> "00", "contractedLinePositions" -> {1, 2},
       "madSlots" -> {}, "dsibpSlots" -> {}, "slotOrderEqual" -> True,
       "madCoefficient" -> ((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi),
       "dsibpCompiledWronskianCoefficient" -> ((-4*I)*sE1^(-1 + 2*mu1))/
         (E^(Pi*Im[mu1])*Pi), "dsibpPhysicalSectorPrefactor" ->
        ((4*I)*sE1^(2*mu1))/(E^(Pi*Im[mu1])*Pi), "dsibpSelector" ->
        -sE1^(-1), "expectedSelector" -> -sE1^(-1), "oracleCoefficient" ->
        ((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi),
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "madMatchesOracle" -> True, "dsibpMatchesOracle" -> True,
       "selectorMatches" -> True, "splitReconstructs" -> True|>},
    "masterResults" -> {<|"globalIndex" -> 1, "madStreeIntegral" ->
        MSIntegral["11", {0, 0, 0}, {0, 0, 0}], "dSIBPIntegral" ->
        Inactive[J]["11", {0, 0, 0}, {0, 0, 0}], "madStreeIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {0, 0, 0}|>, "dSIBPIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {0, 0, 0}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> 1, "dSIBPCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 2, "madStreeIntegral" ->
        MSIntegral["11", {0, 0, 0}, {0, 0, 1}], "dSIBPIntegral" ->
        Inactive[J]["11", {0, 0, 0}, {0, 0, 1}], "madStreeIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {0, 0, 1}|>, "dSIBPIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {0, 0, 1}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> 1, "dSIBPCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 3, "madStreeIntegral" ->
        MSIntegral["11", {0, 0, 0}, {0, 1, 0}], "dSIBPIntegral" ->
        Inactive[J]["11", {0, 0, 0}, {0, 1, 0}], "madStreeIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {0, 1, 0}|>, "dSIBPIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {0, 1, 0}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> 1, "dSIBPCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 4, "madStreeIntegral" ->
        MSIntegral["11", {0, 0, 0}, {0, 1, 1}], "dSIBPIntegral" ->
        Inactive[J]["11", {0, 0, 0}, {0, 1, 1}], "madStreeIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {0, 1, 1}|>, "dSIBPIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {0, 1, 1}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> 1, "dSIBPCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 5, "madStreeIntegral" ->
        MSIntegral["11", {0, 0, 0}, {1, 0, 0}], "dSIBPIntegral" ->
        Inactive[J]["11", {0, 0, 0}, {1, 0, 0}], "madStreeIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {1, 0, 0}|>, "dSIBPIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {1, 0, 0}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> 1, "dSIBPCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 6, "madStreeIntegral" ->
        MSIntegral["11", {0, 0, 0}, {1, 0, 1}], "dSIBPIntegral" ->
        Inactive[J]["11", {0, 0, 0}, {1, 0, 1}], "madStreeIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {1, 0, 1}|>, "dSIBPIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {1, 0, 1}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> 1, "dSIBPCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 7, "madStreeIntegral" ->
        MSIntegral["11", {0, 0, 0}, {1, 1, 0}], "dSIBPIntegral" ->
        Inactive[J]["11", {0, 0, 0}, {1, 1, 0}], "madStreeIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {1, 1, 0}|>, "dSIBPIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {1, 1, 0}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> 1, "dSIBPCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 8, "madStreeIntegral" ->
        MSIntegral["11", {0, 0, 0}, {1, 1, 1}], "dSIBPIntegral" ->
        Inactive[J]["11", {0, 0, 0}, {1, 1, 1}], "madStreeIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {1, 1, 1}|>, "dSIBPIdentity" ->
        <|"sectorKey" -> "11", "timeShifts" -> {0, 0, 0},
         "stateBits" -> {1, 1, 1}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> 1, "dSIBPCoefficient" -> 1,
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 9, "madStreeIntegral" ->
        MSIntegral["01", {0, 0}, {0}], "dSIBPIntegral" ->
        Inactive[J]["01", {0, 0}, {0}], "madStreeIdentity" ->
        <|"sectorKey" -> "01", "timeShifts" -> {0, 0}, "stateBits" -> {0}|>,
       "dSIBPIdentity" -> <|"sectorKey" -> "01", "timeShifts" -> {0, 0},
         "stateBits" -> {0}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> ((-4*I)*sE1^(-1 + 2*mu1))/
         (E^(Pi*Im[mu1])*Pi), "dSIBPCoefficient" -> ((-4*I)*sE1^(-1 + 2*mu1))/
         (E^(Pi*Im[mu1])*Pi), "coefficientDifference" -> 0,
       "coefficientRatio" -> 1, "passed" -> True|>, <|"globalIndex" -> 10,
       "madStreeIntegral" -> MSIntegral["01", {0, 0}, {1}],
       "dSIBPIntegral" -> Inactive[J]["01", {0, 0}, {1}],
       "madStreeIdentity" -> <|"sectorKey" -> "01", "timeShifts" -> {0, 0},
         "stateBits" -> {1}|>, "dSIBPIdentity" -> <|"sectorKey" -> "01",
         "timeShifts" -> {0, 0}, "stateBits" -> {1}|>,
       "identityEqual" -> True, "madStreeCoefficient" ->
        ((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi),
       "dSIBPCoefficient" -> ((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi),
       "coefficientDifference" -> 0, "coefficientRatio" -> 1,
       "passed" -> True|>, <|"globalIndex" -> 11, "madStreeIntegral" ->
        MSIntegral["10", {0, 0}, {0, 0}], "dSIBPIntegral" ->
        Inactive[J]["10", {0, 0}, {0, 0}], "madStreeIdentity" ->
        <|"sectorKey" -> "10", "timeShifts" -> {0, 0}, "stateBits" -> {0,
          0}|>, "dSIBPIdentity" -> <|"sectorKey" -> "10",
         "timeShifts" -> {0, 0}, "stateBits" -> {0, 0}|>,
       "identityEqual" -> True, "madStreeCoefficient" -> 1,
       "dSIBPCoefficient" -> 1, "coefficientDifference" -> 0,
       "coefficientRatio" -> 1, "passed" -> True|>, <|"globalIndex" -> 12,
       "madStreeIntegral" -> MSIntegral["10", {0, 0}, {0, 1}],
       "dSIBPIntegral" -> Inactive[J]["10", {0, 0}, {0, 1}],
       "madStreeIdentity" -> <|"sectorKey" -> "10", "timeShifts" -> {0, 0},
         "stateBits" -> {0, 1}|>, "dSIBPIdentity" -> <|"sectorKey" -> "10",
         "timeShifts" -> {0, 0}, "stateBits" -> {0, 1}|>,
       "identityEqual" -> True, "madStreeCoefficient" -> 1,
       "dSIBPCoefficient" -> 1, "coefficientDifference" -> 0,
       "coefficientRatio" -> 1, "passed" -> True|>, <|"globalIndex" -> 13,
       "madStreeIntegral" -> MSIntegral["10", {0, 0}, {1, 0}],
       "dSIBPIntegral" -> Inactive[J]["10", {0, 0}, {1, 0}],
       "madStreeIdentity" -> <|"sectorKey" -> "10", "timeShifts" -> {0, 0},
         "stateBits" -> {1, 0}|>, "dSIBPIdentity" -> <|"sectorKey" -> "10",
         "timeShifts" -> {0, 0}, "stateBits" -> {1, 0}|>,
       "identityEqual" -> True, "madStreeCoefficient" -> 1,
       "dSIBPCoefficient" -> 1, "coefficientDifference" -> 0,
       "coefficientRatio" -> 1, "passed" -> True|>, <|"globalIndex" -> 14,
       "madStreeIntegral" -> MSIntegral["10", {0, 0}, {1, 1}],
       "dSIBPIntegral" -> Inactive[J]["10", {0, 0}, {1, 1}],
       "madStreeIdentity" -> <|"sectorKey" -> "10", "timeShifts" -> {0, 0},
         "stateBits" -> {1, 1}|>, "dSIBPIdentity" -> <|"sectorKey" -> "10",
         "timeShifts" -> {0, 0}, "stateBits" -> {1, 1}|>,
       "identityEqual" -> True, "madStreeCoefficient" -> 1,
       "dSIBPCoefficient" -> 1, "coefficientDifference" -> 0,
       "coefficientRatio" -> 1, "passed" -> True|>, <|"globalIndex" -> 15,
       "madStreeIntegral" -> MSIntegral["00", {0}, {}],
       "dSIBPIntegral" -> Inactive[J]["00", {0}, {}], "madStreeIdentity" ->
        <|"sectorKey" -> "00", "timeShifts" -> {0}, "stateBits" -> {}|>,
       "dSIBPIdentity" -> <|"sectorKey" -> "00", "timeShifts" -> {0},
         "stateBits" -> {}|>, "identityEqual" -> True,
       "madStreeCoefficient" -> ((-4*I)*sE1^(-1 + 2*mu1))/
         (E^(Pi*Im[mu1])*Pi), "dSIBPCoefficient" -> ((-4*I)*sE1^(-1 + 2*mu1))/
         (E^(Pi*Im[mu1])*Pi), "coefficientDifference" -> 0,
       "coefficientRatio" -> 1, "passed" -> True|>}, "passed" -> True|>}|>
