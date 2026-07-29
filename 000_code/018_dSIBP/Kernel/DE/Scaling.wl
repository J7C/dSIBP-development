(* ::Package:: *)
(* 本模块从闭合 DE 构造 Euler residual，并按显式次数、通用 loop topology
   或 pure-massive-bubble reference convention 生成 master 的齐次次数。 *)

(* ::Chapter:: *)
(*018 标度关系检查*)

(* 标度门禁使用符号 Euler 关系；数值点只能作为诊断，不作为通过依据。 *)

Options[DSScaleCheck] = {
   ScalingRelation -> "Custom",
   ScalingVariables -> Automatic,
   ScalingWeights -> Automatic,
   ScalingDegrees -> Automatic,
   ProgressReporting -> Automatic
   };

DSScaleCheck::badde = "DSScaleCheck 需要 DSDE 返回的 generated DE 数据。";
DSScaleCheck::badspec = "标度 relation/variables/weights/degrees 不完整或长度不一致：`1`。";

dsIntegralPhysicalPowers[int : J[aList_List, linePacks_List, _List], context_Association] := Module[
   {sectorTopo, activeVertices, aPowers, bPowers},
   sectorTopo = dsSectorTopologyForIntegral[int, context];
   If[sectorTopo === $Failed, Return[$Failed]];
   activeVertices = activeAVertexIds[sectorTopo];
   aPowers = MapThread[#1 + vertexZeroPoint[sectorTopo, #2] &, {aList, activeVertices}];
   bPowers = Table[linePowerIndex[sectorTopo, int, e], {e, sectorTopo["nE"]}];
   <|"aPowers" -> aPowers, "bPowers" -> bPowers, "sectorKey" -> sectorKeyFromShrunkLines[Lookup[sectorTopo, "sectorShrunkLines", {}]]|>
   ];

dsPureMassiveBubbleDegree[int_J, context_Association] := Module[{powers, vertexCount, offset},
   powers = dsIntegralPhysicalPowers[int, context];
   If[powers === $Failed, Return[$Failed]];
   vertexCount = Length[powers["aPowers"]];
   offset = Switch[vertexCount, 2, 2, 1, 1, _, Return[$Failed]];
   dim - Total[powers["bPowers"]] - Total[powers["aPowers"]] - offset
   ];


(* ::Section::Closed:: *)
(*通用 loop topology 的 normalized J 次数*)

(* ISP 是 loop scalar product，因而每个幂次贡献两个动量次数。sector prefactor
   必须从完整 N_s 结构读取；只接受关于当前 Euler 变量齐次的 prefactor。 *)
dsLoopTopologyDegree[
   int : J[_, _, ispPowers_List],
   variables_List,
   weights_List,
   context_Association
   ] := Module[
   {powers, rootTopo, loopCount, vertexCount, prefactorData, prefactor,
    prefactorDegree},
   powers = dsIntegralPhysicalPowers[int, context];
   If[powers === $Failed, Return[$Failed]];
   rootTopo = context["topology"];
   loopCount = Lookup[rootTopo, "graphLoopCount", Length[Lookup[rootTopo, "loopMomenta", {}]]];
   vertexCount = Length[powers["aPowers"]];
   prefactorData = sectorPrefactorDataForIntegral018[rootTopo, int];
   prefactor = materializeSectorPrefactor018[prefactorData];
   If[prefactor === $Failed || TrueQ[prefactor === 0], Return[$Failed]];
   prefactorDegree = Together[
     Total[MapThread[#1 #2 D[prefactor, #2] &, {weights, variables}]]/prefactor
     ];
   If[! And @@ (dsScaleZeroQ[D[prefactorDegree, #]] & /@ variables), Return[$Failed]];
   Together[
    loopCount dim - Total[powers["bPowers"]] - Total[powers["aPowers"]] -
     vertexCount + 2 Total[ispPowers] + prefactorDegree
    ]
   ];


dsLoopTopologyExpressionDegree[
   expr_,
   variables_List,
   weights_List,
   context_Association
   ] := Module[
   {linearData, termDegrees, coefficientDegree, integralDegree, referenceDegree},
   linearData = publicLinearIntegralDecomposition[expr];
   If[
    Lookup[linearData, "status", "failed"] =!= "linear" ||
     ! TrueQ[linearData["constantTerm"] === 0],
    Return[$Failed]
    ];
   termDegrees = MapThread[
     Function[{coefficient, int},
      If[
       TrueQ[coefficient === 0],
       Nothing,
       coefficientDegree = Together[
         Total[MapThread[#1 #2 D[coefficient, #2] &, {weights, variables}]]/coefficient
         ];
       integralDegree = dsLoopTopologyDegree[int, variables, weights, context];
       If[
        integralDegree === $Failed ||
         ! And @@ (dsScaleZeroQ[D[coefficientDegree, #]] & /@ variables),
        $Failed,
        Together[coefficientDegree + integralDegree]
        ]
       ]
      ],
     {linearData["coefficients"], linearData["integrals"]}
     ];
   If[termDegrees === {} || MemberQ[termDegrees, $Failed], Return[$Failed]];
   referenceDegree = First[termDegrees];
   If[
    And @@ (dsScaleZeroQ[# - referenceDegree] & /@ Rest[termDegrees]),
    referenceDegree,
    $Failed
    ]
   ];

(* 线性组合的次数同时包含显式动力学系数；所有非零项必须具有同一 Euler 次数。 *)
dsPureMassiveBubbleExpressionDegree[expr_, variables_List, weights_List, context_Association] := Module[
   {linearData, termDegrees, coefficientDegree, integralDegree, referenceDegree},
   linearData = publicLinearIntegralDecomposition[expr];
   If[Lookup[linearData, "status", "failed"] =!= "linear" || ! TrueQ[linearData["constantTerm"] === 0], Return[$Failed]];
   termDegrees = MapThread[
     Function[{coefficient, int},
      If[TrueQ[coefficient === 0],
       Nothing,
       coefficientDegree = Together[Total[MapThread[#1 #2 D[coefficient, #2] &, {weights, variables}]]/coefficient];
       integralDegree = dsPureMassiveBubbleDegree[int, context];
       If[integralDegree === $Failed || ! And @@ (dsScaleZeroQ[D[coefficientDegree, #]] & /@ variables),
        $Failed,
        Together[coefficientDegree + integralDegree]
        ]
       ]
      ],
     {linearData["coefficients"], linearData["integrals"]}
     ];
   If[termDegrees === {} || MemberQ[termDegrees, $Failed], Return[$Failed]];
   referenceDegree = First[termDegrees];
   If[And @@ (dsScaleZeroQ[# - referenceDegree] & /@ Rest[termDegrees]), referenceDegree, $Failed]
   ];

dsScaleZeroQ[expr_] := TrueQ[Together[Expand[expr]] === 0];

DSScaleCheck[deData_Association, spec_: <||>, OptionsPattern[]] := Module[
   {relation, variables, weights, degrees, masters, context, matrices, sources, missingVariables,
    declaredDegrees, sourceManifest, kiraPlan, postDerivativeRules, physicalPostDerivativeRules, degreeRules,
    evaluationRules, evaluatedVariables, eulerMatrix, eulerSource, matrixResidual,
    sourceResidual, checks, status},
   If[Lookup[deData, "status", "missing"] =!= "generated",
    Message[DSScaleCheck::badde]; dsErrorPrint["DE 尚未闭合，不能宣称标度检查通过。 The DE is not closed, so the scaling check cannot be reported as passed."]; Return[<|"status" -> "failed", "reason" -> "deNotGenerated"|>]
    ];
   relation = Lookup[spec, "relation", OptionValue[ScalingRelation]];
   variables = Replace[Lookup[spec, "variables", OptionValue[ScalingVariables]], Automatic -> deData["variables"]];
   weights = Replace[Lookup[spec, "weights", OptionValue[ScalingWeights]], Automatic -> ConstantArray[1, Length[variables]]];
   masters = deData["masters"];
   context = deData["context"];
   declaredDegrees = Lookup[Lookup[deData, "activeBasis", <||>], "scalingDegrees", Automatic];
   sourceManifest = Lookup[deData, "sourceManifest", <||>];
   kiraPlan = Lookup[sourceManifest, "kiraPlan", <||>];
   postDerivativeRules = If[
     Lookup[kiraPlan, "numericStage", "symbolic"] === "postDerivative",
     Lookup[kiraPlan, "coefficientRules", {}],
     {}
     ];
   physicalPostDerivativeRules = If[postDerivativeRules === {},
     {},
     Lookup[sourceManifest, "physicalCoefficientRulesApplied", postDerivativeRules]
     ];
   degrees = Replace[
     Lookup[spec, "degrees", OptionValue[ScalingDegrees]],
     Automatic :> Which[
       ListQ[declaredDegrees], declaredDegrees,
       relation === "PureMassiveBubble", dsPureMassiveBubbleExpressionDegree[#, variables, weights, context] & /@ masters,
       relation === "LoopTopology", dsLoopTopologyExpressionDegree[#, variables, weights, context] & /@ masters,
       True, $Failed
       ]
     ];
   (* seed 前固定的不可求导参数也必须进入齐次次数；DE 变量自身始终保留为符号。 *)
   degreeRules = Join[
     If[TrueQ[Lookup[sourceManifest, "numericRulesAppliedBeforeSeeds", False]],
      Lookup[context["topology"], "numericRules", {}], {}],
     If[ListQ[physicalPostDerivativeRules], physicalPostDerivativeRules, {}]
     ];
   If[ListQ[degrees], degrees = degrees /. degreeRules];
   If[! ListQ[variables] || ! ListQ[weights] || Length[variables] =!= Length[weights] ||
     ! ListQ[degrees] || Length[degrees] =!= Length[masters] || MemberQ[degrees, $Failed],
    Message[DSScaleCheck::badspec, <|"relation" -> relation, "variables" -> variables, "weights" -> weights, "degrees" -> degrees|>];
    dsErrorPrint["标度检查规格无效。 The scaling-check specification is invalid."]; Return[<|"status" -> "failed", "reason" -> "invalidScalingSpecification"|>]
    ];
   matrices = deData["matrices"];
   sources = deData["sources"];
   missingVariables = Select[variables, ! KeyExistsQ[matrices, #] &];
   If[missingVariables =!= {},
    Message[DSScaleCheck::badspec, missingVariables]; dsErrorPrint["DE 缺少 Euler 算符所需变量。 The DE lacks variables required by the Euler operator."]; Return[<|"status" -> "failed", "reason" -> "missingDEVariables", "missingVariables" -> missingVariables|>]
    ];
   evaluationRules = If[ListQ[physicalPostDerivativeRules], physicalPostDerivativeRules, {}];
   evaluatedVariables = variables /. evaluationRules;
   eulerMatrix = Total[MapThread[#1 #2 matrices[#3] &, {weights, evaluatedVariables, variables}]];
   eulerSource = Total[MapThread[#1 #2 sources[#3] &, {weights, evaluatedVariables, variables}]];
   matrixResidual = Map[Together[Expand[#]] &, eulerMatrix - DiagonalMatrix[degrees], {2}];
   sourceResidual = Together[Expand[#]] & /@ eulerSource;
   checks = <|
     "matrixRelation" -> And @@ (dsScaleZeroQ /@ Flatten[matrixResidual]),
     "sourceRelation" -> And @@ (dsScaleZeroQ /@ sourceResidual)
     |>;
   status = If[And @@ Values[checks], "passed", "failed"];
   <|
    "status" -> status,
    "relation" -> relation,
    "variables" -> variables,
    "weights" -> weights,
    "evaluatedVariables" -> evaluatedVariables,
    "evaluationPointRules" -> evaluationRules,
    "degrees" -> degrees,
    "eulerMatrix" -> eulerMatrix,
    "eulerSource" -> eulerSource,
    "matrixResidual" -> matrixResidual,
    "sourceResidual" -> sourceResidual,
    "checks" -> checks,
    "symbolicQ" -> (evaluationRules === {})
    |>
   ];

DSScaleCheck[deData_, spec_: <||>, OptionsPattern[]] := (Message[DSScaleCheck::badde]; dsErrorPrint["DSScaleCheck 输入必须是 DE Association。 DSScaleCheck input must be a DE Association."]; <|"status" -> "failed", "reason" -> "inputNotAssociation"|>);
