{<|"caseName" -> "016BubbleBridgeTwoExternalLegs", "sectorShrunkLines" -> {},
  "sectorKey" -> "top", "aSlotMode" -> "compactActiveSlots",
  "sectorVertexRepresentativeMap" -> <|v1 -> v1, v2 -> v2, v3 -> v3|>,
  "vertexIdToOriginalASlot" -> <|v1 -> 1, v2 -> 2, v3 -> 3|>,
  "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 2, v3 -> 3|>,
  "vertexSlots" -> {<|"slot" -> 1, "vertexId" -> v1,
     "representativeVertexId" -> v1, "aSymbol" -> a[v1], "activeQ" -> True,
     "fixedValue" -> None, "compactASlot" -> 1|>,
    <|"slot" -> 2, "vertexId" -> v2, "representativeVertexId" -> v2,
     "aSymbol" -> a[v2], "activeQ" -> True, "fixedValue" -> None,
     "compactASlot" -> 2|>, <|"slot" -> 3, "vertexId" -> v3,
     "representativeVertexId" -> v3, "aSymbol" -> a[v3], "activeQ" -> True,
     "fixedValue" -> None, "compactASlot" -> 3|>},
  "compactASlots" -> {<|"compactSlot" -> 1, "representativeVertexId" -> v1,
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
 <|"caseName" -> "016BubbleBridgeTwoExternalLegs_sector_e1",
  "sectorShrunkLines" -> {1}, "sectorKey" -> "e1",
  "aSlotMode" -> "compactActiveSlots", "sectorVertexRepresentativeMap" ->
   <|v1 -> v1, v2 -> v1, v3 -> v3|>, "vertexIdToOriginalASlot" ->
   <|v1 -> 1, v2 -> 2, v3 -> 3|>, "vertexIdToCompactASlot" ->
   <|v1 -> 1, v2 -> 1, v3 -> 2|>, "vertexSlots" ->
   {<|"slot" -> 1, "vertexId" -> v1, "representativeVertexId" -> v1,
     "aSymbol" -> a[v1], "activeQ" -> True, "fixedValue" -> None,
     "compactASlot" -> 1|>, <|"slot" -> 2, "vertexId" -> v2,
     "representativeVertexId" -> v1, "aSymbol" -> a[v2], "activeQ" -> False,
     "fixedValue" -> 0, "compactASlot" -> 1|>,
    <|"slot" -> 3, "vertexId" -> v3, "representativeVertexId" -> v3,
     "aSymbol" -> a[v3], "activeQ" -> True, "fixedValue" -> None,
     "compactASlot" -> 2|>}, "compactASlots" ->
   {<|"compactSlot" -> 1, "representativeVertexId" -> v1,
     "originalVertexIds" -> {v1, v2}, "originalSlots" -> {1, 2},
     "aSymbol" -> a[v1]|>, <|"compactSlot" -> 2, "representativeVertexId" ->
      v3, "originalVertexIds" -> {v3}, "originalSlots" -> {3},
     "aSymbol" -> a[v3]|>}, "activeASlots" -> {1, 2},
  "lineSlots" -> {<|"slot" -> 1, "lineId" -> 1, "packType" -> "shrunk",
     "massType" -> "massive", "state" -> "shrunk", "endpoints" -> {v1, v1},
     "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" ->
      Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
      Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2},
     "endpointCompactASlots" -> {1, 1}, "linePowerMode" -> "indexed",
     "bPosition" -> 1, "bSymbol" -> bS[1], "nPositions" -> {},
     "packTemplate" -> {bS[1]}|>, <|"slot" -> 2, "lineId" -> 2,
     "packType" -> "massiveFull", "massType" -> "massive", "state" -> "full",
     "endpoints" -> {v1, v1}, "originalEndpoints" -> {v1, v2},
     "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"],
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
     "representativeVertexId" -> v1, "aSymbol" -> a[v2], "activeQ" -> False,
     "fixedValue" -> 0, "compactASlot" -> 1|>,
    <|"slot" -> 3, "vertexId" -> v3, "representativeVertexId" -> v3,
     "aSymbol" -> a[v3], "activeQ" -> True, "fixedValue" -> None,
     "compactASlot" -> 2|>}, "compactASlots" ->
   {<|"compactSlot" -> 1, "representativeVertexId" -> v1,
     "originalVertexIds" -> {v1, v2}, "originalSlots" -> {1, 2},
     "aSymbol" -> a[v1]|>, <|"compactSlot" -> 2, "representativeVertexId" ->
      v3, "originalVertexIds" -> {v3}, "originalSlots" -> {3},
     "aSymbol" -> a[v3]|>}, "activeASlots" -> {1, 2},
  "lineSlots" -> {<|"slot" -> 1, "lineId" -> 1, "packType" -> "massiveFull",
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
     "packType" -> "massiveFull", "massType" -> "massive", "state" -> "full",
     "endpoints" -> {v1, v3}, "originalEndpoints" -> {v2, v3},
     "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"],
     "masslessN1OppositeEndpoint" -> Missing["NotApplicable"],
     "endpointOriginalASlots" -> {2, 3}, "endpointCompactASlots" -> {1, 2},
     "linePowerMode" -> "fixedCoefficient", "bPosition" ->
      Missing["FixedLinePower"], "bSymbol" -> None, "nPositions" -> {1, 2},
     "packTemplate" -> {n[3, 1], n[3, 2]}|>},
  "lineIdToSlot" -> <|1 -> 1, 2 -> 2, 3 -> 3|>,
  "bSymbolToLineSlot" -> <|b[1] -> 1, bS[2] -> 2|>, "ispSlots" -> {}|>,
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
     "aSymbol" -> a[v1]|>, <|"compactSlot" -> 2, "representativeVertexId" ->
      v2, "originalVertexIds" -> {v2, v3}, "originalSlots" -> {2, 3},
     "aSymbol" -> a[v2]|>}, "activeASlots" -> {1, 2},
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
    <|"slot" -> 3, "lineId" -> 3, "packType" -> "shrunk",
     "massType" -> "massive", "state" -> "shrunk", "endpoints" -> {v2, v2},
     "originalEndpoints" -> {v2, v3}, "masslessN1ReferenceEndpoint" ->
      Missing["NotApplicable"], "masslessN1OppositeEndpoint" ->
      Missing["NotApplicable"], "endpointOriginalASlots" -> {2, 3},
     "endpointCompactASlots" -> {2, 2}, "linePowerMode" ->
      "fixedCoefficient", "bPosition" -> Missing["FixedLinePower"],
     "bSymbol" -> None, "nPositions" -> {}, "packTemplate" -> {}|>},
  "lineIdToSlot" -> <|1 -> 1, 2 -> 2, 3 -> 3|>,
  "bSymbolToLineSlot" -> <|b[1] -> 1, b[2] -> 2|>, "ispSlots" -> {}|>,
 <|"caseName" -> "016BubbleBridgeTwoExternalLegs_sector_e1_e3",
  "sectorShrunkLines" -> {1, 3}, "sectorKey" -> "e1_e3",
  "aSlotMode" -> "compactActiveSlots", "sectorVertexRepresentativeMap" ->
   <|v1 -> v1, v2 -> v1, v3 -> v1|>, "vertexIdToOriginalASlot" ->
   <|v1 -> 1, v2 -> 2, v3 -> 3|>, "vertexIdToCompactASlot" ->
   <|v1 -> 1, v2 -> 1, v3 -> 1|>, "vertexSlots" ->
   {<|"slot" -> 1, "vertexId" -> v1, "representativeVertexId" -> v1,
     "aSymbol" -> a[v1], "activeQ" -> True, "fixedValue" -> None,
     "compactASlot" -> 1|>, <|"slot" -> 2, "vertexId" -> v2,
     "representativeVertexId" -> v1, "aSymbol" -> a[v2], "activeQ" -> False,
     "fixedValue" -> 0, "compactASlot" -> 1|>,
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
     "packType" -> "massiveFull", "massType" -> "massive", "state" -> "full",
     "endpoints" -> {v1, v1}, "originalEndpoints" -> {v1, v2},
     "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"],
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
  "lineIdToSlot" -> <|1 -> 1, 2 -> 2, 3 -> 3|>,
  "bSymbolToLineSlot" -> <|bS[1] -> 1, b[2] -> 2|>, "ispSlots" -> {}|>,
 <|"caseName" -> "016BubbleBridgeTwoExternalLegs_sector_e2_e3",
  "sectorShrunkLines" -> {2, 3}, "sectorKey" -> "e2_e3",
  "aSlotMode" -> "compactActiveSlots", "sectorVertexRepresentativeMap" ->
   <|v1 -> v1, v2 -> v1, v3 -> v1|>, "vertexIdToOriginalASlot" ->
   <|v1 -> 1, v2 -> 2, v3 -> 3|>, "vertexIdToCompactASlot" ->
   <|v1 -> 1, v2 -> 1, v3 -> 1|>, "vertexSlots" ->
   {<|"slot" -> 1, "vertexId" -> v1, "representativeVertexId" -> v1,
     "aSymbol" -> a[v1], "activeQ" -> True, "fixedValue" -> None,
     "compactASlot" -> 1|>, <|"slot" -> 2, "vertexId" -> v2,
     "representativeVertexId" -> v1, "aSymbol" -> a[v2], "activeQ" -> False,
     "fixedValue" -> 0, "compactASlot" -> 1|>,
    <|"slot" -> 3, "vertexId" -> v3, "representativeVertexId" -> v1,
     "aSymbol" -> a[v3], "activeQ" -> False, "fixedValue" -> 0,
     "compactASlot" -> 1|>}, "compactASlots" ->
   {<|"compactSlot" -> 1, "representativeVertexId" -> v1,
     "originalVertexIds" -> {v1, v2, v3}, "originalSlots" -> {1, 2, 3},
     "aSymbol" -> a[v1]|>}, "activeASlots" -> {1},
  "lineSlots" -> {<|"slot" -> 1, "lineId" -> 1, "packType" -> "massiveFull",
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
     "packType" -> "shrunk", "massType" -> "massive", "state" -> "shrunk",
     "endpoints" -> {v1, v1}, "originalEndpoints" -> {v2, v3},
     "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"],
     "masslessN1OppositeEndpoint" -> Missing["NotApplicable"],
     "endpointOriginalASlots" -> {2, 3}, "endpointCompactASlots" -> {1, 1},
     "linePowerMode" -> "fixedCoefficient", "bPosition" ->
      Missing["FixedLinePower"], "bSymbol" -> None, "nPositions" -> {},
     "packTemplate" -> {}|>}, "lineIdToSlot" -> <|1 -> 1, 2 -> 2, 3 -> 3|>,
  "bSymbolToLineSlot" -> <|b[1] -> 1, bS[2] -> 2|>, "ispSlots" -> {}|>}
