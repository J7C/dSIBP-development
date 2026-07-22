{<|"caseName" -> "rootKinematicCoordinatesExample", 
  "sectorShrunkLines" -> {}, "sectorKey" -> "top", 
  "aSlotMode" -> "compactActiveSlots", "sectorVertexRepresentativeMap" -> 
   <|v1 -> v1, v2 -> v2|>, "vertexIdToOriginalASlot" -> <|v1 -> 1, v2 -> 2|>, 
  "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 2|>, 
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
  "lineSlots" -> {<|"slot" -> 1, "lineId" -> e1, "packType" -> "massiveFull", 
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
   <|v1 -> v1, v2 -> v1|>, "vertexIdToOriginalASlot" -> <|v1 -> 1, v2 -> 2|>, 
  "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 1|>, 
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
     "packType" -> "massiveFull", "massType" -> "massive", "state" -> "full", 
     "endpoints" -> {v1, v1}, "originalEndpoints" -> {v1, v2}, 
     "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], 
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
   <|v1 -> v1, v2 -> v1|>, "vertexIdToOriginalASlot" -> <|v1 -> 1, v2 -> 2|>, 
  "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 1|>, 
  "vertexSlots" -> {<|"slot" -> 1, "vertexId" -> v1, 
     "representativeVertexId" -> v1, "aSymbol" -> a[v1], "activeQ" -> True, 
     "fixedValue" -> None, "compactASlot" -> 1|>, 
    <|"slot" -> 2, "vertexId" -> v2, "representativeVertexId" -> v1, 
     "aSymbol" -> a[v2], "activeQ" -> False, "fixedValue" -> 0, 
     "compactASlot" -> 1|>}, "compactASlots" -> 
   {<|"compactSlot" -> 1, "representativeVertexId" -> v1, 
     "originalVertexIds" -> {v1, v2}, "originalSlots" -> {1, 2}, 
     "aSymbol" -> a[v1]|>}, "activeASlots" -> {1}, 
  "lineSlots" -> {<|"slot" -> 1, "lineId" -> e1, "packType" -> "massiveFull", 
     "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v1}, 
     "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" -> 
      Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
      Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, 
     "endpointCompactASlots" -> {1, 1}, "bSymbol" -> b[e1], 
     "packTemplate" -> {b[e1], n[e1, 1], n[e1, 2]}|>, 
    <|"slot" -> 2, "lineId" -> e2, "packType" -> "shrunk", 
     "massType" -> "massive", "state" -> "shrunk", "endpoints" -> {v1, v1}, 
     "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" -> 
      Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
      Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, 
     "endpointCompactASlots" -> {1, 1}, "bSymbol" -> bS[e2], 
     "packTemplate" -> {bS[e2]}|>, <|"slot" -> 3, "lineId" -> e3, 
     "packType" -> "massiveFull", "massType" -> "massive", "state" -> "full", 
     "endpoints" -> {v1, v1}, "originalEndpoints" -> {v1, v2}, 
     "masslessN1ReferenceEndpoint" -> Missing["NotApplicable"], 
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
   <|v1 -> v1, v2 -> v1|>, "vertexIdToOriginalASlot" -> <|v1 -> 1, v2 -> 2|>, 
  "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 1|>, 
  "vertexSlots" -> {<|"slot" -> 1, "vertexId" -> v1, 
     "representativeVertexId" -> v1, "aSymbol" -> a[v1], "activeQ" -> True, 
     "fixedValue" -> None, "compactASlot" -> 1|>, 
    <|"slot" -> 2, "vertexId" -> v2, "representativeVertexId" -> v1, 
     "aSymbol" -> a[v2], "activeQ" -> False, "fixedValue" -> 0, 
     "compactASlot" -> 1|>}, "compactASlots" -> 
   {<|"compactSlot" -> 1, "representativeVertexId" -> v1, 
     "originalVertexIds" -> {v1, v2}, "originalSlots" -> {1, 2}, 
     "aSymbol" -> a[v1]|>}, "activeASlots" -> {1}, 
  "lineSlots" -> {<|"slot" -> 1, "lineId" -> e1, "packType" -> "massiveFull", 
     "massType" -> "massive", "state" -> "full", "endpoints" -> {v1, v1}, 
     "originalEndpoints" -> {v1, v2}, "masslessN1ReferenceEndpoint" -> 
      Missing["NotApplicable"], "masslessN1OppositeEndpoint" -> 
      Missing["NotApplicable"], "endpointOriginalASlots" -> {1, 2}, 
     "endpointCompactASlots" -> {1, 1}, "bSymbol" -> b[e1], 
     "packTemplate" -> {b[e1], n[e1, 1], n[e1, 2]}|>, 
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
   <|v1 -> v1, v2 -> v1|>, "vertexIdToOriginalASlot" -> <|v1 -> 1, v2 -> 2|>, 
  "vertexIdToCompactASlot" -> <|v1 -> 1, v2 -> 1|>, 
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
     "data" -> <|"name" -> rho1, "expr" -> sp[k, q], "range" -> {0}|>|>}|>}
