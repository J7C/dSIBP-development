(* ::Package:: *)
(* tadpole 与导数批量 benchmark 的独立 expected；不调用主线 canonical/helper。*)

expectedTadpoleMassiveSwap[int_J] := int /. J[aList_, packs_, ispList_] :>
   J[aList, ReplacePart[packs, 1 -> ReplacePart[packs[[1]], {2 -> packs[[1, 3]], 3 -> packs[[1, 2]]}]], ispList];


expectedTadpoleMasslessZero[_J] := 0;


expectedTadpoleOddISPZero[_J] := 0;


expectedTadpoleUserRule[int_J] := 2 int;


expectedDerivativeBatchVariables[topo_Association] := {
   <|"variable" -> ke[1], "userVariable" -> ke[1], "kind" -> "vertexEnergy"|>
   };


expectedDerivativeBatchEquation[topo_Association, int_J, "externalInvariant"] := 0;
expectedDerivativeBatchEquation[topo_Association, int_J, "vertexEnergy"] :=
   -vertexExternalPhaseDerivativeCoefficient[topo, v] shiftVertexA[int, topo, v, 1];
