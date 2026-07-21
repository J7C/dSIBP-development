(* ::Package:: *)
(* 本文件统一检查扁平 expected 的字段、J 线性、残留对象和 forbidden n。 *)


(* ::Chapter:: *)
(*Expected 结构门禁*)

relationFields = {"sector", "vertexSigns", "generator", "seedRules", "equation", "tags"};
derivativeFields = {"sector", "vertexSigns", "mode", "variable", "expression", "derivative", "tags"};

linearInJQ[expr_] := Module[{expanded = Expand[expr], terms},
  terms = If[Head[expanded] === Plus, List @@ expanded, {expanded}];
  And @@ (! FreeQ[#1, _J] & /@ Select[terms, # =!= 0 &])
  ];

forbiddenMassiveNData[expr_] := Cases[
   expr,
   HoldPattern[J[_, packs_, _]] :> Select[
     packs,
     Length[#] === 3 && AnyTrue[Rest[#], IntegerQ[#] && # >= 2 &] &
     ],
   Infinity
   ] // Flatten;

expectedOutputSummary[relations_List, derivatives_List] := <|
   "relationCount" -> Length[relations],
   "derivativeCount" -> Length[derivatives],
   "relationFieldShapeQ" -> And @@ (Sort[Keys[#]] === Sort[relationFields] & /@ relations),
   "derivativeFieldShapeQ" -> And @@ (Sort[Keys[#]] === Sort[derivativeFields] & /@ derivatives),
   "linearInJQ" -> And @@ (linearInJQ /@ Lookup[relations, "equation"]),
   "absorbedQ" -> FreeQ[
     {Lookup[relations, "equation"], Lookup[derivatives, "derivative"]},
     _scalarUnknown | _propSq | _rhoVar | _Return | $Failed
     ],
   "forbiddenMassiveNQ" -> (forbiddenMassiveNData[
       {Lookup[relations, "equation"], Lookup[derivatives, "derivative"]}
       ] === {})
   |>;
