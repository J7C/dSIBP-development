<|"status" -> "generated", "variableCount" -> 7,
 "operators" -> {<|"variable" -> ss11, "userVariable" -> ss11,
    "kind" -> "kinematicCoordinate", "decomposition" ->
     <|"status" -> "chainRuleAdapter", "atomicCoordinates" ->
       {sp[k, k], sp[p1, p1], sp[p2, p2], sp[p1 + p2, p1 + p2]},
      "atomicJacobian" -> {2*ss11, 0, 0, 0}|>|>,
   <|"variable" -> sE1, "userVariable" -> sE1,
    "kind" -> "kinematicCoordinate", "decomposition" ->
     <|"status" -> "chainRuleAdapter", "atomicCoordinates" ->
       {sp[k, k], sp[p1, p1], sp[p2, p2], sp[p1 + p2, p1 + p2]},
      "atomicJacobian" -> {0, 1, 0, 0}|>|>, <|"variable" -> sE2,
    "userVariable" -> sE2, "kind" -> "kinematicCoordinate",
    "decomposition" -> <|"status" -> "chainRuleAdapter",
      "atomicCoordinates" -> {sp[k, k], sp[p1, p1], sp[p2, p2],
        sp[p1 + p2, p1 + p2]}, "atomicJacobian" -> {0, 0, 1, 0}|>|>,
   <|"variable" -> sE3, "userVariable" -> sE3,
    "kind" -> "kinematicCoordinate", "decomposition" ->
     <|"status" -> "chainRuleAdapter", "atomicCoordinates" ->
       {sp[k, k], sp[p1, p1], sp[p2, p2], sp[p1 + p2, p1 + p2]},
      "atomicJacobian" -> {0, 0, 0, 1}|>|>, <|"variable" -> E1,
    "userVariable" -> E1, "kind" -> "vertexEnergy",
    "decomposition" -> Missing["DirectVertexEnergyDerivative"]|>,
   <|"variable" -> E2, "userVariable" -> E2, "kind" -> "vertexEnergy",
    "decomposition" -> Missing["DirectVertexEnergyDerivative"]|>,
   <|"variable" -> E3, "userVariable" -> E3, "kind" -> "vertexEnergy",
    "decomposition" -> Missing["DirectVertexEnergyDerivative"]|>}|>
