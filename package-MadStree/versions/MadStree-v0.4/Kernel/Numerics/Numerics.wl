(* ::Package:: *)

(***
文件：Numerics.wl
用途：把已认证 connection 沿用户给定路径变成一维数值初值问题。
边界：本模块不猜测物理边界条件；缺少同序 boundaryValues 时只返回 Missing 状态。
***)

(* ::Chapter:: *)
(*数值路径系统*)

MSNumericalSystem[de_Association, spec_Association : <||>] := Module[
  {parameter, pathRules, substitutions, interval, boundaryPoint, boundaryValues,
   omegaAlongPath, connection, dimension, functions, equations, initialConditions},
  If[Lookup[de, "status", None] =!= "generated" || ! MatrixQ[Lookup[de, "omegaPotential", None]],
    Return[Failure["InvalidDLogData", <||>]]
  ];
  parameter = Lookup[spec, "pathParameter", t];
  pathRules = Lookup[spec, "pathRules", {}];
  substitutions = Lookup[spec, "substitutions", {}];
  interval = Lookup[spec, "interval", {0, 1}];
  boundaryPoint = Lookup[spec, "boundaryPoint", First[interval]];
  boundaryValues = Lookup[spec, "boundaryValues", Missing["BoundaryData"]];
  dimension = de["masterCount"];
  omegaAlongPath = Simplify[de["omegaPotential"] /. pathRules /. substitutions];
  connection = Simplify[D[omegaAlongPath, parameter]];
  functions = Array[msNumericalMaster, dimension];
  equations = Thread[D[Through[functions[parameter]], parameter] == connection.Through[functions[parameter]]];
  initialConditions = If[
    Head[boundaryValues] === Missing,
    Missing["BoundaryData"],
    If[! ListQ[boundaryValues] || Length[boundaryValues] =!= dimension,
      Return[Failure["BoundaryVectorDimension", <|"expected" -> dimension, "actual" -> Length[boundaryValues]|>]],
      Thread[Through[functions[boundaryPoint]] == boundaryValues]
    ]
  ];
  <|
    "status" -> If[Head[initialConditions] === Missing, "boundaryDataRequired", "ready"],
    "masters" -> de["masters"],
    "masterDigest" -> de["masterDigest"],
    "pathParameter" -> parameter,
    "interval" -> interval,
    "omegaAlongPath" -> omegaAlongPath,
    "connectionAlongPath" -> connection,
    "equations" -> equations,
    "initialConditions" -> initialConditions,
    "unknownFunctions" -> functions
  |>
];
