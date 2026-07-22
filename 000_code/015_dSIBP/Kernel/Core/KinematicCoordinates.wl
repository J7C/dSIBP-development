(* ::Package:: *)

(* ::Chapter:: *)
(*015 根号动力学坐标适配层*)

(* 本模块把 loop external-momentum 的内部原子 kk[i,j]=sp[k_i,k_j] 暴露为
   ssij=Sqrt[sp[k_i,k_j]]，并把实际出现的无圈动量模长依次暴露为 sE1,sE2,...。
   旧 kk/sij 导数保持原子实现；根号坐标只通过 Jacobian 链式法则调用该原子层。 *)


(* ::Section::Closed:: *)
(*缺省命名与圈外外腿规则*)

externalRootSymbolName[i_Integer, j_Integer] :=
  ToExpression["ss" <> ToString[Min[i, j]] <> ToString[Max[i, j]]];


externalLegRootSymbolName[i_Integer] := ToExpression["sE" <> ToString[i]];


defaultExternalInvariantRulesForTopology[topo_Association] := Module[
   {exts = Lookup[topo, "externalMomenta", {}], nK},
   nK = Length[exts];
   Flatten@Table[
     sp[exts[[i]], exts[[j]]] -> externalRootSymbolName[i, j]^2,
     {i, nK}, {j, i, nK}
     ]
   ];


canonicalExternalLegMomentum[expr_] := Module[{forms, preferred},
   forms = DeleteDuplicates[{Expand[expr], Expand[-expr]}];
   preferred = Select[forms, ! StringStartsQ[ToString[InputForm[#]], "-"] &];
   First@SortBy[If[preferred === {}, forms, preferred], ToString[InputForm[#]] &]
   ];


zeroLoopMomentumQ[expr_, topo_Association] := And @@ (
    zeroQ[Coefficient[Expand[expr], #]] & /@ Lookup[topo, "loopMomenta", {}]
    );


externalMomentumOnlyQ[expr_, topo_Association] := Module[
   {basis = Lookup[topo, "externalMomenta", {}], data},
   data = linearMomentumExpressionData[Expand[expr], basis];
   TrueQ[data["linearQ"]]
   ];


externalLegCoordinateLineQ[expr_, topo_Association] :=
  zeroLoopMomentumQ[expr, topo] && ! externalMomentumOnlyQ[expr, topo];


externalLegMagnitudeMomentaInExpression[expr_, topo_Association] := DeleteDuplicates[
   canonicalExternalLegMomentum /@ Cases[
     expr,
     HoldPattern[Power[sp[p_, r_], Rational[1, 2]]] /; Expand[p - r] === 0 && zeroLoopMomentumQ[p, topo] :> p,
     {0, Infinity}
     ]
   ];


externalLegMagnitudeCandidateMomenta[topo_Association] := Module[
   {lineMomenta, phaseExpressions, candidates},
   lineMomenta = Cases[
     Lookup[Lookup[topo, "lines", {}], "momentum", {}],
     momentum_ /; zeroLoopMomentumQ[momentum, topo] && ! zeroQ[momentum] &&
        ! externalMomentumOnlyQ[momentum, topo] :> momentum
     ];
   phaseExpressions = Join[
     Values@Replace[Lookup[topo, "vertexEnergies", <||>], rules_List :> Association[rules]],
     Cases[Lookup[topo, "extLegs", {}], entry_List /; Length[entry] >= 3 :> entry[[3]]]
     ];
   candidates = Join[
     lineMomenta,
     Flatten[externalLegMagnitudeMomentaInExpression[#, topo] & /@ phaseExpressions]
     ];
   DeleteDuplicates[
    Select[canonicalExternalLegMomentum /@ candidates, ! zeroQ[#] && ! externalMomentumOnlyQ[#, topo] &]
    ]
   ];


externalLegGramPairs[basis_List] := Flatten[
   Table[{i, j}, {i, Length[basis]}, {j, i, Length[basis]}],
   1
   ];


momentumSquaredGramVector[momentum_, basis_List] := Module[{coefficients, pairs},
   coefficients = Coefficient[Expand[momentum], #] & /@ basis;
   pairs = externalLegGramPairs[basis];
   Map[
    Function[pair,
     If[pair[[1]] === pair[[2]],
      coefficients[[pair[[1]]]]^2,
      2 coefficients[[pair[[1]]]] coefficients[[pair[[2]]]]
      ]
     ],
    pairs
    ]
   ];


(* 实际出现集合先在完整声明向量 Gram 空间中展开；完整 loop Gram 已经在基中，
   其余模长平方仅在增加秩时获得新的 sEe。未入基项保留线性 binding。 *)
externalLegMagnitudeBasisAnalysis[topo_Association] := Module[
   {external = Lookup[topo, "externalMomenta", {}],
    declaredLegs = Lookup[topo, "externalLegMomenta", {}], basis, pairs,
    loopPairPositions, loopRows, candidates, candidateRows, selectedPositions = {},
    selectedRows = {}, currentRows, oldRank, newRank, row, basisRows,
    defaultSquaredCoordinates, occurrenceData},
   basis = Join[external, declaredLegs];
   pairs = externalLegGramPairs[basis];
   loopPairPositions = Flatten@Position[
      pairs,
      {i_, j_} /; i <= Length[external] && j <= Length[external],
      {1},
      Heads -> False
      ];
   loopRows = UnitVector[Length[pairs], #] & /@ loopPairPositions;
   candidates = externalLegMagnitudeCandidateMomenta[topo];
   candidateRows = momentumSquaredGramVector[#, basis] & /@ candidates;
   currentRows = loopRows;
   oldRank = If[currentRows === {}, 0, MatrixRank[currentRows]];
   Do[
    row = candidateRows[[position]];
    newRank = MatrixRank[Append[currentRows, row]];
    If[newRank > oldRank,
     AppendTo[selectedPositions, position];
     AppendTo[selectedRows, row];
     AppendTo[currentRows, row];
     oldRank = newRank
     ],
    {position, Length[candidates]}
    ];
   basisRows = Join[loopRows, selectedRows];
   defaultSquaredCoordinates = Join[
     Last /@ defaultExternalInvariantRulesForTopology[topo],
     Table[externalLegRootSymbolName[i]^2, {i, Length[selectedPositions]}]
     ];
   occurrenceData = MapIndexed[
     Function[{momentum, indexSpec},
      Module[{position = First[indexSpec], selectedPosition, coefficients, externalLegIndex},
       coefficients = If[
         basisRows === {},
         {},
         Quiet[Check[LinearSolve[Transpose[basisRows], candidateRows[[position]]], $Failed]]
         ];
       If[! ListQ[coefficients], coefficients = ConstantArray[Indeterminate, Length[basisRows]]];
       selectedPosition = FirstPosition[selectedPositions, position, Missing["Dependent"]];
       externalLegIndex = If[Head[selectedPosition] === Missing, Missing["Dependent"], First[selectedPosition]];
       <|
        "occurrenceIndex" -> position,
        "momentum" -> momentum,
        "squaredExpression" -> sp[momentum, momentum],
        "magnitudeExpression" -> Sqrt[sp[momentum, momentum]],
        "gramVector" -> candidateRows[[position]],
        "baseCoefficients" -> coefficients,
        "independentQ" -> (Head[selectedPosition] =!= Missing),
        "externalLegIndex" -> externalLegIndex,
        "userVariable" -> If[Head[selectedPosition] === Missing, Missing["Dependent"], externalLegRootSymbolName[externalLegIndex]],
        "defaultSquaredExpression" -> Expand[coefficients . defaultSquaredCoordinates]
        |>
       ]
      ],
     candidates
     ];
   <|
    "declaredMomentumBasis" -> basis,
    "gramPairs" -> pairs,
    "loopGramRows" -> loopRows,
    "candidateMomenta" -> candidates,
    "candidateRows" -> candidateRows,
    "selectedOccurrencePositions" -> selectedPositions,
    "basisRows" -> basisRows,
    "defaultSquaredCoordinates" -> defaultSquaredCoordinates,
    "occurrenceData" -> occurrenceData,
    "independentExternalLegData" -> Select[occurrenceData, TrueQ[Lookup[#, "independentQ", False]] &],
    "dependentExternalLegData" -> Select[occurrenceData, ! TrueQ[Lookup[#, "independentQ", False]] &]
    |>
   ];


externalLegMagnitudeData[topo_Association] := Lookup[
   externalLegMagnitudeBasisAnalysis[topo],
   "independentExternalLegData",
   {}
   ];


externalLegMagnitudeOccurrenceData[topo_Association] := Lookup[
   externalLegMagnitudeBasisAnalysis[topo],
   "occurrenceData",
   {}
   ];


defaultExternalLegInvariantRulesForTopology[topo_Association] := Map[
   #1["squaredExpression"] -> #1["userVariable"]^2 &,
   externalLegMagnitudeData[topo]
   ];


kinematicRuleLHS[rule : (Rule | RuleDelayed)[lhs_, _]] := Replace[
   Unevaluated[lhs],
   HoldPattern[Sqrt[arg_]] :> arg,
   {0}
   ];


kinematicRuleRHS[rule : (Rule | RuleDelayed)[lhs_, rhs_]] := If[
   MatchQ[Unevaluated[lhs], HoldPattern[Sqrt[_]]],
   rhs^2,
   rhs
   ];


normalizeKinematicRule[rule : (Rule | RuleDelayed)[_, _]] :=
  kinematicRuleLHS[rule] -> kinematicRuleRHS[rule];


normalizeKinematicRuleList[rules_Association] := normalizeKinematicRuleList[Normal[rules]];
normalizeKinematicRuleList[rules_List] := normalizeKinematicRule /@ Select[rules, validReplacementRuleQ];
normalizeKinematicRuleList[_] := {};


kinematicBaseCoordinateData[topo_Association] := Module[
   {loopRules, legData, loopData},
   loopRules = defaultExternalInvariantRulesForTopology[topo];
   loopData = MapIndexed[
     <|
       "baseIndex" -> First[#2],
       "kind" -> "loopExternalGram",
       "inputExpression" -> First[#1],
       "internalVariable" -> Replace[First[#1], HoldPattern[sp[p_, r_]] :> expandDotExpr[p, r, topo], {0}],
       "defaultVariable" -> rootCoordinateSymbol[Last[#1]],
       "defaultRHS" -> Last[#1]
       |> &,
     loopRules
     ];
   legData = MapIndexed[
     Join[#1, <|
        "baseIndex" -> Length[loopData] + First[#2],
        "kind" -> "externalLegMagnitude",
        "inputExpression" -> #1["squaredExpression"],
        "internalVariable" -> externalLegSquaredCoordinate[First[#2]],
        "defaultVariable" -> #1["userVariable"],
        "defaultRHS" -> #1["userVariable"]^2
        |>] &,
     externalLegMagnitudeData[topo]
     ];
   Join[loopData, legData]
   ];


kinematicRuleBaseVector[rule_, topo_Association, baseData_List] := Module[
   {lhs = kinematicRuleLHS[rule], legHit, loopData, loopVars, internal, coeffs, residual},
   legHit = SelectFirst[
     externalLegMagnitudeOccurrenceData[topo],
     SameQ[lhs, Lookup[#, "squaredExpression"]] &,
     Missing["NotFound"]
     ];
   If[AssociationQ[legHit], Return[Lookup[legHit, "baseCoefficients", Missing["UnsupportedKinematicLHS", lhs]]]];
   loopData = Select[baseData, Lookup[#, "kind", ""] === "loopExternalGram" &];
   loopVars = Lookup[loopData, "internalVariable", {}];
   internal = Expand[lhs /. HoldPattern[sp[p_, r_]] :> expandDotExpr[p, r, topo]];
   If[! FreeQ[internal, sp], Return[Missing["UnsupportedKinematicLHS", lhs]]];
   coeffs = Coefficient[internal, #] & /@ loopVars;
   residual = Expand[internal - Total[MapThread[#1 #2 &, {coeffs, loopVars}]]];
   If[! zeroQ[residual],
    Missing["UnsupportedKinematicLHS", lhs],
    Join[coeffs, ConstantArray[0, Length[baseData] - Length[loopData]]]
    ]
   ];


independentKinematicRows[matrix_List, targetRank_Integer] := Module[
   {selected = {}, current = {}, oldRank = 0, newRank, row},
   Do[
    row = matrix[[i]];
    newRank = MatrixRank[Append[current, row]];
    If[newRank > oldRank,
     AppendTo[selected, i];
     AppendTo[current, row];
     oldRank = newRank
     ];
    If[oldRank >= targetRank, Break[]],
    {i, Length[matrix]}
    ];
   selected
   ];


simpleKinematicInverseQ[rhs_] := MatchQ[
   Unevaluated[rhs],
   _Symbol | HoldPattern[Power[_Symbol, 2]]
   ];


kinematicRootExpression[rhs_] := Replace[
   rhs,
   {
    HoldPattern[Power[s_Symbol, 2]] :> s,
    other_ :> Sqrt[other]
    },
   {0}
   ];


kinematicCoordinateAudit[topo_Association, rules_List, source_String] := Module[
   {baseData, baseCount, normalizedRules, vectors, supportedPositions, unsupportedPositions,
    matrix, rhs, rank, rowSelection, baseRHS = {}, resolvedRules = {}, loopCount,
    missingDirections, ruleMissingDirections, parameterMissingDirections, ruleDependencies,
    parameterDependencies, constraintResiduals = {}, userVariables, parameterJacobian = {},
    baseExpressions, ruleMissingDirectionExpressions, parameterMissingDirectionExpressions,
    ruleDependencyResiduals, parameterRank = 0, ruleCompleteQ, overcompleteQ, completeQ,
    inverseAvailableQ, occurrenceData, bindingCoordinates, dependentBindings},
   baseData = kinematicBaseCoordinateData[topo];
   baseCount = Length[baseData];
   baseExpressions = Lookup[baseData, "inputExpression", {}];
   normalizedRules = normalizeKinematicRuleList[rules];
   vectors = kinematicRuleBaseVector[#, topo, baseData] & /@ normalizedRules;
   supportedPositions = Flatten@Position[vectors, _List, {1}, Heads -> False];
   unsupportedPositions = Complement[Range[Length[vectors]], supportedPositions];
   matrix = If[supportedPositions === {}, {}, vectors[[supportedPositions]]];
   rhs = If[supportedPositions === {}, {}, (Last /@ normalizedRules[[supportedPositions]])];
   rank = Which[
     baseCount === 0, 0,
     matrix === {}, 0,
     True, MatrixRank[matrix]
     ];
   ruleCompleteQ = TrueQ[rank === baseCount] && unsupportedPositions === {};
   If[ruleCompleteQ && baseCount > 0,
    rowSelection = independentKinematicRows[matrix, baseCount];
    baseRHS = Expand[LinearSolve[matrix[[rowSelection]], rhs[[rowSelection]]]];
    resolvedRules = Thread[Lookup[baseData, "inputExpression"] -> baseRHS];
    constraintResiduals = DeleteCases[Together /@ Expand[matrix . baseRHS - rhs], 0]
    ];
   If[baseCount === 0, resolvedRules = {}];
   userVariables = DeleteDuplicates[Flatten[Variables /@ (Last /@ normalizedRules)]];
   If[ruleCompleteQ && baseCount > 0,
    parameterJacobian = Table[D[baseRHS[[i]], userVariables[[j]]], {i, baseCount}, {j, Length[userVariables]}];
    parameterRank = If[userVariables === {}, 0, MatrixRank[parameterJacobian]]
    ];
   completeQ = ruleCompleteQ && TrueQ[parameterRank === baseCount || baseCount === 0];
   ruleMissingDirections = Which[
     baseCount === 0, {},
     matrix === {}, IdentityMatrix[baseCount],
     True, NullSpace[matrix]
     ];
   parameterMissingDirections = If[
     baseCount === 0 || ! ruleCompleteQ,
     {},
     NullSpace[Transpose[parameterJacobian]]
     ];
   missingDirections = DeleteDuplicates@Join[ruleMissingDirections, parameterMissingDirections];
   ruleDependencies = If[matrix === {}, {}, NullSpace[Transpose[matrix]]];
   parameterDependencies = If[parameterJacobian === {} || userVariables === {}, {}, NullSpace[parameterJacobian]];
   (* 零空间向量本身用于严格秩门禁；同时按固定基础坐标顺序给出可读组合，
      便于用户直接定位缺少或被约束的运动学方向。 *)
   ruleMissingDirectionExpressions = Expand[# . baseExpressions] & /@ ruleMissingDirections;
   parameterMissingDirectionExpressions = Expand[# . baseExpressions] & /@ parameterMissingDirections;
   ruleDependencyResiduals = If[ruleDependencies === {}, {}, Together[Expand[# . rhs]] & /@ ruleDependencies];
   overcompleteQ = completeQ && (
      Length[normalizedRules] > baseCount || Length[userVariables] > baseCount ||
       ruleDependencies =!= {} || parameterDependencies =!= {} || constraintResiduals =!= {}
      );
   inverseAvailableQ = completeQ && ! overcompleteQ && And @@ (simpleKinematicInverseQ /@ baseRHS);
   loopCount = Length[defaultExternalInvariantRulesForTopology[topo]];
   occurrenceData = externalLegMagnitudeOccurrenceData[topo];
   bindingCoordinates = If[
     Length[baseRHS] === baseCount,
     baseRHS,
     Lookup[baseData, "defaultRHS", {}]
     ];
   dependentBindings = Map[
     Function[data,
      With[{squared = Expand[Lookup[data, "baseCoefficients", {}] . bindingCoordinates]},
       <|
        "momentum" -> Lookup[data, "momentum"],
        "squaredExpression" -> Lookup[data, "squaredExpression"],
        "userSquaredExpression" -> squared,
        "userMagnitudeExpression" -> kinematicRootExpression[squared]
        |>
       ]
      ],
     Select[occurrenceData, ! TrueQ[Lookup[#, "independentQ", False]] &]
     ];
   <|
    "status" -> Which[! completeQ, "incomplete", overcompleteQ, "overcomplete", True, "complete"],
    "source" -> source,
    "baseCoordinateData" -> baseData,
    "baseCoordinateOrder" -> baseExpressions,
    "baseCoordinateCount" -> baseCount,
    "defaultRules" -> Thread[Lookup[baseData, "inputExpression"] -> Lookup[baseData, "defaultRHS"]],
    "selectionTemplate" -> ("kinematicRules" -> Thread[Lookup[baseData, "inputExpression"] -> Lookup[baseData, "defaultRHS"]]),
    "selectedRules" -> normalizedRules,
    "selectedUserVariables" -> userVariables,
    "userParameterOrder" -> userVariables,
    "coordinateMatrix" -> matrix,
    "coordinateRank" -> rank,
    "parameterJacobian" -> parameterJacobian,
    "parameterRank" -> parameterRank,
    "missingDirections" -> missingDirections,
    "ruleMissingDirections" -> ruleMissingDirections,
    "parameterMissingDirections" -> parameterMissingDirections,
    "ruleMissingDirectionExpressions" -> ruleMissingDirectionExpressions,
    "parameterMissingDirectionExpressions" -> parameterMissingDirectionExpressions,
    "ruleDependencies" -> ruleDependencies,
    "ruleDependencyResiduals" -> ruleDependencyResiduals,
    "parameterDependencies" -> parameterDependencies,
    "constraintResiduals" -> constraintResiduals,
    "unsupportedRulePositions" -> unsupportedPositions,
    "completeQ" -> completeQ,
    "overcompleteQ" -> overcompleteQ,
    "inverseAvailableQ" -> inverseAvailableQ,
    "resolvedRules" -> resolvedRules,
    "baseSquaredUserExpressions" -> baseRHS,
    "baseRootUserExpressions" -> (kinematicRootExpression /@ baseRHS),
    "appearingNoLoopMagnitudeMomenta" -> Lookup[occurrenceData, "momentum", {}],
    "independentNoLoopMagnitudeMomenta" -> Lookup[
      Select[occurrenceData, TrueQ[Lookup[#, "independentQ", False]] &],
      "momentum",
      {}
      ],
    "dependentMagnitudeBindings" -> dependentBindings,
    "rawLoopRules" -> Take[resolvedRules, UpTo[loopCount]],
    "resolvedLoopRules" -> Take[resolvedRules, UpTo[loopCount]],
    "rawExternalLegRules" -> Drop[resolvedRules, Min[loopCount, Length[resolvedRules]]],
    "resolvedExternalLegRules" -> Drop[resolvedRules, Min[loopCount, Length[resolvedRules]]],
    "message" -> Which[
      ! completeQ, "动力学变量不完备；零空间向量及其按 baseCoordinateOrder 展开的表达式给出未覆盖或受约束方向。",
      overcompleteQ, "动力学变量过完备；允许继续生成 IBP，但冗余变量 ds 与 rep2innerform 被禁用，constraintResiduals 给出需在 family 定义中实现的关系。",
      inverseAvailableQ, "动力学变量完备，且当前简单坐标规则可反向转换。",
      True, "动力学变量完备，Jacobian 链式偏导可用；一般混合坐标不提供 rep2innerform。"
      ]
    |>
   ];


resolveKinematicRulesForCase[case_Association, topo_Association] := Module[
   {combined, loopRules, legRules, selected},
   combined = Lookup[case, "kinematicRules", Automatic];
   If[combined =!= Automatic,
    Return[kinematicCoordinateAudit[topo, normalizeKinematicRuleList[combined], "kinematicRules"]]
    ];
   loopRules = normalizeExternalInvariantRulesForTopology[
     Lookup[case, "rawExternalInvariantRules", Lookup[case, "externalInvariantRules", Automatic]],
     topo
     ];
   legRules = normalizeExternalLegInvariantRulesForTopology[
     Lookup[case, "rawExternalLegInvariantRules", Lookup[case, "externalLegInvariantRules", Automatic]],
     topo
     ];
   selected = Join[loopRules, legRules];
   kinematicCoordinateAudit[topo, selected, If[
     Lookup[case, "externalInvariantRules", Automatic] === Automatic && Lookup[case, "externalLegInvariantRules", Automatic] === Automatic,
     "default",
     "legacyFields"
     ]]
   ];


normalizeExternalLegInvariantRulesForTopology[Automatic, topo_Association] :=
  defaultExternalLegInvariantRulesForTopology[topo];
normalizeExternalLegInvariantRulesForTopology[rules_Association, topo_Association] :=
  normalizeExternalLegInvariantRulesForTopology[Normal[rules], topo];
normalizeExternalLegInvariantRulesForTopology[rules_List, topo_Association] := Module[
   {defaults = defaultExternalLegInvariantRulesForTopology[topo], validRules},
   validRules = Select[rules, validReplacementRuleQ] /. Rule[Sqrt[lhs_], rhs_] :> Rule[lhs, rhs^2];
   Normal[Association[Join[defaults, validRules]]]
   ];
normalizeExternalLegInvariantRulesForTopology[_, topo_Association] :=
  defaultExternalLegInvariantRulesForTopology[topo];


rootCoordinateSymbol[expr_] := Replace[
   Unevaluated[expr],
   HoldPattern[Power[s_Symbol, 2]] :> s,
   {0}
   ];


rootCoordinateExpressionQ[expr_] := MatchQ[Unevaluated[expr], HoldPattern[Power[_Symbol, 2]]];


externalLegMagnitudeBindingData[topo_Association] := Module[
   {audit, squaredCoordinates, defaultCoordinates},
   audit = Lookup[topo, "kinematicCoordinateAudit", <||>];
   defaultCoordinates = Lookup[externalLegMagnitudeBasisAnalysis[topo], "defaultSquaredCoordinates", {}];
   squaredCoordinates = Lookup[audit, "baseSquaredUserExpressions", defaultCoordinates];
   If[Length[squaredCoordinates] =!= Length[defaultCoordinates], squaredCoordinates = defaultCoordinates];
   Map[
    Function[data,
     With[{squared = Expand[Lookup[data, "baseCoefficients", {}] . squaredCoordinates]},
      Join[data, <|
        "userSquaredExpression" -> squared,
        "userMagnitudeExpression" -> kinematicRootExpression[squared]
        |>]
      ]
     ],
    externalLegMagnitudeOccurrenceData[topo]
    ]
   ];


externalLegRootInputRules[topo_Association] := Map[
   Lookup[#, "magnitudeExpression"] -> Lookup[#, "userMagnitudeExpression"] &,
   externalLegMagnitudeBindingData[topo]
   ];


externalLegSquaredInputRules[topo_Association] := Map[
   Lookup[#, "squaredExpression"] -> Lookup[#, "userSquaredExpression"] &,
   externalLegMagnitudeBindingData[topo]
   ];


(* 圈外 external-leg 点积先被替换为独立 sE 坐标；剩余 sp 才进入 loop qq/qk/kk 展开。 *)
scalarProductSPInputToInternal[expr_, topo_Association] := Expand[
   expr /.
      externalLegRootInputRules[topo] /.
      externalLegSquaredInputRules[topo] /.
      HoldPattern[sp[p_, r_]] :> expandDotExpr[p, r, topo]
   ];


(* ::Section::Closed:: *)
(*外不变量坐标记录与内外转换*)

externalInvariantCoordinateData[topo_Association] := Module[
   {rules = externalInvariantInternalToUserRules[topo]},
   rules /. Rule[internal_, public_] :> Module[
      {rootQ = rootCoordinateExpressionQ[public], user},
      user = If[rootQ, rootCoordinateSymbol[public], public];
      <|
       "internalVariable" -> internal,
       "publicExpression" -> public,
       "userVariable" -> user,
       "coordinateType" -> If[rootQ, "squareRoot", "legacySquaredInvariant"],
       "internalCoordinateExpression" -> If[rootQ, Sqrt[internal], internal],
       "internalJacobian" -> If[rootQ, 2 Sqrt[internal], 1],
       "userJacobian" -> If[rootQ, 2 user, 1]
       |>
      ]
   ];


externalLegInvariantCoordinateData[topo_Association] := Module[
   {rules = Lookup[topo, "externalLegInvariantRules", defaultExternalLegInvariantRulesForTopology[topo]], magnitudeData},
   magnitudeData = externalLegMagnitudeData[topo];
   rules /. Rule[scalarProduct_, public_] :> Module[
       {rootQ = rootCoordinateExpressionQ[public], user, source},
       user = If[rootQ, rootCoordinateSymbol[public], public];
       source = SelectFirst[magnitudeData, SameQ[Lookup[#, "squaredExpression"], scalarProduct] &, <||>];
       Join[source, <|
        "scalarProduct" -> scalarProduct,
        "publicExpression" -> public,
        "userVariable" -> user,
        "coordinateType" -> If[rootQ, "externalLegSquareRoot", "externalLegLegacy"],
        "userJacobian" -> 1
        |>]
       ]
   ];


resolveExternalInvariantCoordinate[topo_Association, variable_] := SelectFirst[
   externalInvariantCoordinateData[topo],
   SameQ[variable, Lookup[#, "userVariable"]] ||
     SameQ[variable, Lookup[#, "internalVariable"]] ||
     SameQ[variable, Lookup[#, "internalCoordinateExpression"]] &,
   Missing["UnknownExternalInvariantCoordinate", variable]
   ];


externalInvariantUserToInternalRules[topo_Association] := DeleteDuplicates@Flatten[
   Function[data,
     {
      data["publicExpression"] -> data["internalVariable"],
      data["userVariable"] -> data["internalCoordinateExpression"]
      }
     ] /@ externalInvariantCoordinateData[topo]
   ];


rootCoordinateOutputRules[topo_Association] := Flatten@Cases[
   externalInvariantCoordinateData[topo],
   data_Association /; data["coordinateType"] === "squareRoot" :> With[
     {root = data["userVariable"]},
     {
      HoldPattern[Power[Power[root, 2], power_Rational]] :> root^(2 power),
      HoldPattern[Sqrt[root^2]] :> root
      }
     ]
   ];


scalarProductInternalToUser[expr_, topo_Association] := Module[
   {loops = topo["loopMomenta"], exts = topo["externalMomenta"], result},
   result = expr /. Join[
       externalInvariantInternalToUserRules[topo],
       {
        HoldPattern[qq[i_Integer, j_Integer]] :> sp[loops[[i]], loops[[j]]],
        HoldPattern[qk[i_Integer, j_Integer]] :> sp[loops[[i]], exts[[j]]]
        }
       ];
   Expand[result /. rootCoordinateOutputRules[topo]]
   ];


scalarProductInputToInternal[expr_, topo_Association] := Expand[
   scalarProductSPInputToInternal[expr, topo] /. externalInvariantUserToInternalRules[topo]
   ];


externalInvariantNamingReport[topo_Association] := <|
   "externalMomenta" -> Lookup[topo, "externalMomenta", {}],
   "externalInvariantRules" -> Lookup[topo, "externalInvariantRules", defaultExternalInvariantRulesForTopology[topo]],
   "internalExternalInvariantRules" -> externalInvariantInternalToUserRules[topo],
   "coordinateData" -> externalInvariantCoordinateData[topo],
   "defaultNamingConvention" -> "ssij = Sqrt[sp[k_i,k_j]], where i<=j follows externalMomenta order",
   "message" -> "externalMomenta 是进入内线偏移的独立向量；内部仍用 kk[i,j]=sp[k_i,k_j]，015 公开缺省坐标为 ssij。"
   |>;


externalLegInvariantNamingReport[topo_Association] := <|
   "externalLegMomenta" -> Lookup[topo, "externalLegMomenta", {}],
   "appearingMagnitudeMomenta" -> Lookup[externalLegMagnitudeOccurrenceData[topo], "momentum", {}],
   "independentMagnitudeMomenta" -> Lookup[externalLegMagnitudeData[topo], "momentum", {}],
   "dependentMagnitudeBindings" -> Map[
     KeyTake[#, {"momentum", "squaredExpression", "userSquaredExpression", "userMagnitudeExpression"}] &,
     Select[externalLegMagnitudeBindingData[topo], ! TrueQ[Lookup[#, "independentQ", False]] &]
     ],
   "externalLegInvariantRules" -> Lookup[topo, "externalLegInvariantRules", defaultExternalLegInvariantRulesForTopology[topo]],
   "coordinateData" -> externalLegInvariantCoordinateData[topo],
   "defaultNamingConvention" -> "sE1,sE2,... follow the first-occurrence independent basis of no-loop momentum magnitudes in lineData, vertexEnergies and extLegs",
   "automaticCrossProducts" -> False,
   "entersLoopIBPGenerators" -> False,
   "entersISPClosure" -> False
   |>;


(* ::Section::Closed:: *)
(*数值规则与初始化 metadata*)

normalizeNumericRuleForTopology[rule : (Rule | RuleDelayed)[lhs_, rhs_], topo_Association] := Module[
   {coordinate = resolveExternalInvariantCoordinate[topo, lhs], internalLHS},
   If[AssociationQ[coordinate] && SameQ[lhs, coordinate["userVariable"]],
    Return[coordinate["internalVariable"] -> If[coordinate["coordinateType"] === "squareRoot", rhs^2, rhs]]
    ];
   internalLHS = scalarProductInputToInternal[lhs, topo];
   internalLHS -> rhs
   ];


normalizeNumericRulesForTopology[rules_List, topo_Association] :=
  normalizeNumericRuleForTopology[#, topo] & /@ rules;
normalizeNumericRulesForTopology[rules_, _Association] := rules;


normalizeCoefficientRulesForTopology[rules_List, topo_Association] :=
  normalizeNumericRulesForTopology[rules, topo];
normalizeCoefficientRulesForTopology[rules_, _Association] := rules;


userNumericRules[topo_Association] := Lookup[
   topo,
   "rawNumericRules",
   topo["numericRules"] /. (Rule | RuleDelayed)[lhs_, rhs_] :> Rule[scalarProductInternalToUser[lhs, topo], rhs]
   ];


externalInvariantUserVariables[topo_Association] := Lookup[externalInvariantCoordinateData[topo], "userVariable", {}];


numericRuleVariableToUser[variable_, topo_Association] := Module[
   {coordinate = SelectFirst[externalInvariantCoordinateData[topo], SameQ[variable, #["internalVariable"]] &, Missing["NotFound"]]},
   If[AssociationQ[coordinate], coordinate["userVariable"], scalarProductInternalToUser[variable, topo]]
   ];


numericRuleRequirementReport[topo_Association] := Module[
   {provided, external, vertex, line, required, missingExternal, missingVertex, missingLine, missingAll, toUser},
   provided = numericRuleLHSVariables[topo];
   external = externalInvariantVariables[topo];
   vertex = vertexEnergyVariables[topo];
   line = lineParameterVariables[topo];
   required = DeleteDuplicates[Join[external, vertex, line]];
   missingExternal = Complement[external, provided];
   missingVertex = Complement[vertex, provided];
   missingLine = Complement[line, provided];
   missingAll = Complement[required, provided];
   toUser[list_] := numericRuleVariableToUser[#, topo] & /@ list;
   <|
    "providedNumericVariables" -> (First /@ userNumericRules[topo]),
    "internalProvidedNumericVariables" -> provided,
    "requiredExternalInvariants" -> toUser[external],
    "internalRequiredExternalInvariants" -> external,
    "externalInvariantNamingReport" -> externalInvariantNamingReport[topo],
    "externalLegInvariantNamingReport" -> externalLegInvariantNamingReport[topo],
    "vertexEnergyNamingReport" -> vertexEnergyNamingReport[topo],
    "requiredVertexEnergies" -> toUser[vertex],
    "internalRequiredVertexEnergies" -> vertex,
    "requiredLineParameters" -> line,
    "requiredNumericVariables" -> toUser[required],
    "internalRequiredNumericVariables" -> required,
    "missingExternalInvariants" -> toUser[missingExternal],
    "internalMissingExternalInvariants" -> missingExternal,
    "missingVertexEnergies" -> toUser[missingVertex],
    "internalMissingVertexEnergies" -> missingVertex,
    "missingLineParameters" -> missingLine,
    "missingNumericVariables" -> toUser[missingAll],
    "internalMissingNumericVariables" -> missingAll,
    "completeStaticNumericRulesQ" -> TrueQ[missingAll === {}]
    |>
   ];


(* ::Section::Closed:: *)
(*旧原子导数的保存与 Jacobian 包装*)

Options[makeAtomicExternalInvariantDerivativeDecomposition] = Options[makeExternalInvariantDerivativeDecomposition];
DownValues[makeAtomicExternalInvariantDerivativeDecomposition] =
  DownValues[makeExternalInvariantDerivativeDecomposition] /.
   makeExternalInvariantDerivativeDecomposition -> makeAtomicExternalInvariantDerivativeDecomposition;


Clear[makeExternalInvariantDerivativeDecomposition];
Options[makeExternalInvariantDerivativeDecomposition] = {
   ExternalInvariantCoordinateVariables -> Automatic,
   ExternalVectorOperatorBasis -> Automatic
   };
makeExternalInvariantDerivativeDecomposition::badvar =
  "变量 `1` 不在当前 ssij/legacy 外部不变量坐标中。";


makeExternalInvariantDerivativeDecomposition[topo_Association, variable_, OptionsPattern[]] := Module[
   {coordinate, atomic, scale, coefficients, gens, matrix, targetPos, residual},
   coordinate = resolveExternalInvariantCoordinate[topo, variable];
   If[! AssociationQ[coordinate],
    Message[makeExternalInvariantDerivativeDecomposition::badvar, variable];
    Return[<|"status" -> "badVariable", "targetVariable" -> variable|>]
    ];
   atomic = makeAtomicExternalInvariantDerivativeDecomposition[
     topo,
     coordinate["internalVariable"],
     ExternalInvariantCoordinateVariables -> externalInvariantVariables[topo],
     ExternalVectorOperatorBasis -> OptionValue[ExternalVectorOperatorBasis]
     ];
   If[Lookup[atomic, "status", "failed"] =!= "solved", Return[atomic]];
   scale = If[SameQ[variable, coordinate["internalVariable"]], 1, coordinate["internalJacobian"]];
   coefficients = Expand[scale Lookup[atomic, "coefficients", {}]];
   gens = Lookup[atomic, "operators", {}];
   matrix = Lookup[atomic, "matrix", {}];
   targetPos = First@FirstPosition[externalInvariantVariables[topo], coordinate["internalVariable"]];
   residual = Simplify[Expand[matrix . coefficients - scale UnitVector[Length[externalInvariantVariables[topo]], targetPos]]];
   Join[
    atomic,
    <|
     "targetVariable" -> If[scale === 1, coordinate["internalVariable"], coordinate["userVariable"]],
     "internalTargetVariable" -> coordinate["internalVariable"],
     "coordinateVariables" -> externalInvariantUserVariables[topo],
     "internalCoordinateVariables" -> externalInvariantVariables[topo],
     "coordinateType" -> coordinate["coordinateType"],
     "jacobian" -> If[scale === 1, 1, coordinate["userJacobian"]],
     "coefficientRules" -> Thread[externalVectorDerivativeLabel /@ gens -> coefficients],
     "coefficients" -> coefficients,
     "residual" -> residual
     |>
    ]
   ];


applyCompiledScalarMomentumDerivativeTerm[
   topo_Association, int_J, e_Integer, endpointSlot_Integer, term_Association
   ] := Module[{result, endpointVertex, xPower = term["xPower"]},
   endpointVertex = topo["lines"][[e, "endpoints", endpointSlot]];
   result = setLinePackEntry[int, e, endpointSlot + 1, term["targetState"]];
   result = shiftLineB[result, e, -xPower];
   result = shiftVertexA[result, topo, endpointVertex, xPower + 1];
   term["coefficient"] result
   ];


compiledScalarMomentumEndpointDerivativeTerms[
   topo_Association, int_J, e_Integer, endpointSlot_Integer
   ] := Module[{state, terms},
   state = int[[2, e, endpointSlot + 1]];
   terms = Lookup[lineCompiledFunctionSystem[topo["lines"][[e]]], "derivativeTerms", {}];
   Total[
    KroneckerDelta[state, Lookup[#, "sourceState", Missing["NoSourceState"]]] *
       applyCompiledScalarMomentumDerivativeTerm[topo, int, e, endpointSlot, #] & /@ terms
    ]
   ];


scalarMomentumBuildingBlockDerivativeTerms[topo_Association, int_J, e_Integer] := Module[
   {line = topo["lines"][[e]], packType, sigma},
   packType = actualLinePackType[topo, e, int[[2, e]]];
   Switch[packType,
    "massiveFull" | "massiveCross",
    Total[compiledScalarMomentumEndpointDerivativeTerms[topo, int, e, #] & /@ {1, 2}],
    "masslessFull",
    sigma = masslessFullSKSign[line];
    -I sigma shiftVertexA[toggleMasslessLineState[int, e], topo, line["endpoints"][[1]], 1] +
     I sigma shiftVertexA[toggleMasslessLineState[int, e], topo, line["endpoints"][[2]], 1],
    "masslessCross",
    Total@Table[
      -I skEndpointPhaseSign[line, endpointSlot] shiftVertexA[
        int, topo, line["endpoints"][[endpointSlot]], 1
        ],
      {endpointSlot, 2}
      ],
    _,
    0
    ]
   ];


externalLegMagnitudeOccurrenceLineDerivativeSeed[topo_Association, int_J, coordinate_Association] := Module[
   {momentum = Lookup[coordinate, "momentum", Missing["NoMomentum"]], matchingLines},
   If[Head[momentum] === Missing, Return[0]];
   matchingLines = Flatten@Position[
      Lookup[topo["lines"], "momentum", {}],
      lineMomentum_ /; SameQ[canonicalExternalLegMomentum[lineMomentum], canonicalExternalLegMomentum[momentum]],
      {1},
      Heads -> False
      ];
   Total@Table[
     -linePowerIndex[topo, int, e] shiftLineB[int, e, 1] +
      scalarMomentumBuildingBlockDerivativeTerms[topo, int, e],
     {e, matchingLines}
     ]
   ];


externalLegMagnitudeLineDerivativeSeed[topo_Association, int_J, coordinate_Association] := Module[
   {variable = Lookup[coordinate, "userVariable", Missing["NoVariable"]]},
   If[Head[variable] === Missing, Return[0]];
   Total@Map[
     Function[data,
      D[Lookup[data, "userMagnitudeExpression", 0], variable] *
       externalLegMagnitudeOccurrenceLineDerivativeSeed[topo, int, data]
      ],
     externalLegMagnitudeBindingData[topo]
     ]
   ];


directVertexEnergyVariableDerivativeSeed[topo_Association, int_J, variable_] := Module[
   {coordinate, derivativeVariable, derivativeScale, vertices = activeAVertexIds[topo], derivative},
   coordinate = resolveExternalInvariantCoordinate[topo, variable];
   derivativeVariable = If[AssociationQ[coordinate], coordinate["internalVariable"], scalarProductInputToInternal[variable, topo]];
   derivativeScale = If[
     AssociationQ[coordinate] && ! SameQ[variable, coordinate["internalVariable"]],
     coordinate["internalJacobian"],
     1
     ];
   Total@Table[
     derivative = derivativeScale D[vertexExternalEnergy[topo, vertexId], derivativeVariable];
     If[zeroQ[derivative],
      0,
      -vertexExternalPhaseDerivativeCoefficient[topo, vertexId] derivative shiftVertexA[int, topo, vertexId, 1]
      ],
     {vertexId, vertices}
     ]
   ];


literalVertexEnergyVariableDerivativeSeed[topo_Association, int_J, variable_] := Module[
   {vertices = activeAVertexIds[topo], derivative},
   (* 用户混合坐标在 vertex energy 中只保留尚未吸收到 loop kk 原子的显式依赖；
      因而这里不把用户变量再次解析成 kk，避免和 loop 原子导数重复计数。 *)
   Total@Table[
     derivative = D[vertexExternalEnergy[topo, vertexId], variable];
     If[zeroQ[derivative],
      0,
      -vertexExternalPhaseDerivativeCoefficient[topo, vertexId] derivative shiftVertexA[int, topo, vertexId, 1]
      ],
     {vertexId, vertices}
     ]
   ];


externalLegMagnitudeDerivativeSeed[topo_Association, int_J, variable_] := Module[
   {coordinate},
   coordinate = SelectFirst[
     externalLegInvariantCoordinateData[topo],
     SameQ[Lookup[#, "userVariable", Missing["NoVariable"]], variable] &,
     Missing["NotFound"]
     ];
   If[! AssociationQ[coordinate], Return[directVertexEnergyVariableDerivativeSeed[topo, int, variable]]];
   Expand[
    externalLegMagnitudeLineDerivativeSeed[topo, int, coordinate] +
     directVertexEnergyVariableDerivativeSeed[topo, int, variable]
    ]
   ];


kinematicAtomicDerivativeData[topo_Association] := Module[
   {audit = Lookup[topo, "kinematicCoordinateAudit", <||>], baseData, squaredExpressions, rootExpressions},
   baseData = Lookup[audit, "baseCoordinateData", {}];
   squaredExpressions = Lookup[audit, "baseSquaredUserExpressions", {}];
   rootExpressions = Lookup[audit, "baseRootUserExpressions", {}];
   MapThread[
    Join[#1, <|"userSquaredExpression" -> #2, "userRootExpression" -> #3|>] &,
    {baseData, squaredExpressions, rootExpressions}
    ]
   ];


applyUserKinematicDerivativeSeed[topo_Association, int_J, variable_] := Module[
   {audit = Lookup[topo, "kinematicCoordinateAudit", <||>], atomicData, loopTerms, legTerms, phaseTerms},
   If[! TrueQ[Lookup[audit, "completeQ", False]] || TrueQ[Lookup[audit, "overcompleteQ", False]],
    Return[$Failed]
    ];
   atomicData = kinematicAtomicDerivativeData[topo];
   loopTerms = Total@Map[
      Function[data,
        If[Lookup[data, "kind", ""] =!= "loopExternalGram",
         0,
         D[data["userSquaredExpression"], variable] *
           applyExternalInvariantVariableDerivativeSeed[topo, int, data["internalVariable"]]
        ]
       ],
      atomicData
      ];
   If[! FreeQ[loopTerms, $Failed], Return[$Failed]];
   legTerms = Total@Map[
      Function[data,
       D[Lookup[data, "userMagnitudeExpression", 0], variable] *
        externalLegMagnitudeOccurrenceLineDerivativeSeed[topo, int, data]
       ],
      externalLegMagnitudeBindingData[topo]
      ];
   phaseTerms = literalVertexEnergyVariableDerivativeSeed[topo, int, variable];
   Expand[loopTerms + legTerms + phaseTerms]
   ];


applyIndependentVariableDerivativeSeed[topo_Association, int_J, variable_, opts : OptionsPattern[makeExternalInvariantDerivativeDecomposition]] := Module[
   {coordinate = resolveExternalInvariantCoordinate[topo, variable], atomic, selectedVariables},
   selectedVariables = Lookup[Lookup[topo, "kinematicCoordinateAudit", <||>], "selectedUserVariables", {}];
   If[MemberQ[selectedVariables, variable],
    Return[Expand[applyUserKinematicDerivativeSeed[topo, int, variable]]]
    ];
   If[AssociationQ[coordinate],
    atomic = applyExternalInvariantVariableDerivativeSeed[
      topo,
      int,
      coordinate["internalVariable"],
      FilterRules[{opts}, Options[makeExternalInvariantDerivativeDecomposition]]
      ];
    If[atomic === $Failed,
     $Failed,
     Expand[If[SameQ[variable, coordinate["internalVariable"]], 1, coordinate["internalJacobian"]] atomic]
     ],
    Expand[externalLegMagnitudeDerivativeSeed[topo, int, variable]]
    ]
   ];


(* ::Section::Closed:: *)
(*公开变量集合、DE 与初始化信息*)

independentVariableDerivativeVariables[topo_Association] := Module[
   {audit, selectedVariables, allKinematicVariables, vertexVariables, independentScalars},
   audit = Lookup[topo, "kinematicCoordinateAudit", <||>];
   allKinematicVariables = Lookup[audit, "selectedUserVariables", {}];
   selectedVariables = If[
     TrueQ[Lookup[audit, "completeQ", False]] && ! TrueQ[Lookup[audit, "overcompleteQ", False]],
     Lookup[audit, "selectedUserVariables", {}],
     {}
     ];
   vertexVariables = DeleteDuplicates@Flatten[
      Variables[scalarProductInternalToUser[vertexExternalEnergy[topo, #], topo]] & /@ activeAVertexIds[topo]
      ];
   independentScalars = Complement[
     vertexVariables,
      allKinematicVariables
      ];
   DeleteDuplicates@Join[selectedVariables, independentScalars]
   ];


independentVariableDerivativeKind[topo_Association, variable_] := If[
   MemberQ[Lookup[Lookup[topo, "kinematicCoordinateAudit", <||>], "selectedUserVariables", {}], variable],
   "kinematicCoordinate",
   "vertexEnergy"
   ];


makeIndependentVariableDerivativeGenerators[topo_Association] := Map[
   Function[variable,
    Module[{coordinate = resolveExternalInvariantCoordinate[topo, variable]},
      If[MemberQ[Lookup[Lookup[topo, "kinematicCoordinateAudit", <||>], "selectedUserVariables", {}], variable],
       <|
        "variable" -> variable,
        "userVariable" -> variable,
        "internalVariable" -> variable,
        "kind" -> "kinematicCoordinate",
        "coordinateType" -> "userSelected",
         "atomicJacobian" -> (
           D[
              If[Lookup[#, "kind", ""] === "loopExternalGram",
               Lookup[#, "userSquaredExpression", 0],
               Lookup[#, "userRootExpression", 0]
               ],
              variable
              ] & /@ kinematicAtomicDerivativeData[topo]
           )
        |>,
      <|
       "variable" -> variable,
       "userVariable" -> variable,
       "internalVariable" -> variable,
       "kind" -> "vertexEnergy",
       "coordinateType" -> If[MemberQ[Lookup[externalLegInvariantCoordinateData[topo], "userVariable", {}], variable], "externalLegSquareRoot", "independentScalar"]
       |>
      ]
     ]
    ],
   independentVariableDerivativeVariables[topo]
   ];


dsDEResolveVariables[Automatic, context_Association] :=
  Lookup[makeIndependentVariableDerivativeGenerators[context["topology"]], "userVariable", {}];
dsDEResolveVariables[variable_List, _Association] := variable;
dsDEResolveVariables[variable_, _Association] := {variable};


dsConventionMetadata[topo_Association] := <|
   "vertexData" -> topo["vertexData"],
   "lineOrder" -> Lookup[topo["lines"], "id"],
   "lineConventions" -> Map[
     KeyTake[#, {"id", "massType", "packType", "state", "skType", "bbType", "thetaConvention", "functionSystem", "compiledFunctionSystem"}] &,
     topo["lines"]
     ],
   "zeroPointRules" -> topo["zeroPointRules"],
   "shrinkPrefactorRules" -> topo["shrinkPrefactorRules"],
   "symmetryRules" -> topo["symmetryRules"],
   "effectiveSymmetryRules" -> Lookup[topo, "effectiveSymmetryRules", effectiveSymmetryRules0[topo]],
   "tadpoleSymmetryData" -> Lookup[topo, "tadpoleSymmetryData", tadpoleSymmetryData[topo]],
   "externalInvariantRules" -> topo["externalInvariantRules"],
   "externalLegInvariantRules" -> Lookup[topo, "externalLegInvariantRules", {}],
   "externalInvariantCoordinateData" -> externalInvariantCoordinateData[topo],
    "externalLegInvariantCoordinateData" -> externalLegInvariantCoordinateData[topo],
    "kinematicCoordinateAudit" -> Lookup[topo, "kinematicCoordinateAudit", <||>],
    "independentVariables" -> independentVariableDerivativeVariables[topo],
    "defaultDerivativeCoordinates" -> "ssij for the complete loop-external Gram basis; sE1,sE2,... for the first-occurrence independent basis of actually appearing no-loop momentum magnitudes",
   "loopTreeProjection" -> <|
     "vertexPhysicalPower" -> "a+a0 becomes tree a+nu0",
     "linePhysicalPower" -> "removed b+b0 or bS+bS0 becomes an explicit energy power",
     "normalization" -> "relative to the reference loop integral, term by term",
     "unsafePowerExpand" -> False
     |>
   |>;


vertexEnergyNamingReport[topo_Association] := Module[
   {vertices = activeAVertexIds[topo], raw, internal, user, dependencies},
   raw = AssociationThread[vertices -> (rawVertexExternalEnergy[topo, #] & /@ vertices)];
   internal = AssociationThread[vertices -> (vertexExternalEnergy[topo, #] & /@ vertices)];
   user = AssociationThread[vertices -> (scalarProductInternalToUser[vertexExternalEnergy[topo, #], topo] & /@ vertices)];
   dependencies = AssociationThread[vertices -> (vertexEnergyDependencyData[topo, #] & /@ vertices)];
   <|
     "convention" -> "loop external roots use ssij; the independent basis of actually appearing no-loop momentum magnitudes uses sEe variables and dependent magnitudes keep explicit bindings; unrelated scalar phase parameters remain explicit user symbols",
    "rawVertexEnergies" -> raw,
    "internalVertexEnergies" -> internal,
    "userVertexEnergies" -> user,
    "dependencyData" -> dependencies,
    "externalLegInvariantNamingReport" -> externalLegInvariantNamingReport[topo],
     "message" -> "vertexEnergies 可使用 loop-external Gram 根号或实际出现的无圈动量模长；015 不自动生成外腿向量之间的交叉点积。无圈动量变量不进入 loop IBP/ISP。"
     |>
    ];


(* ::Section::Closed:: *)
(*公开动力学变量提案与重选审计*)

DSKinematics[input_Association, rules_: Automatic] := Module[
   {effectiveInput, topo, audit, status},
   effectiveInput = If[rules === Automatic, input, Join[input, <|"kinematicRules" -> rules|>]];
   topo = parseTopology[effectiveInput];
   If[topo === $Failed,
    Return[<|"status" -> "failed", "reason" -> "invalidTopologyInput"|>]
    ];
   audit = Lookup[topo, "kinematicCoordinateAudit", <||>];
   status = Lookup[audit, "status", "unknown"];
   dsInfoPrint[
     "动力学变量提案：" <> ToString[Lookup[audit, "defaultRules", {}], InputForm] <>
      "；当前选择：" <> ToString[Lookup[audit, "selectedRules", {}], InputForm] <>
      "；从属模长绑定：" <> ToString[Lookup[audit, "dependentMagnitudeBindings", {}], InputForm] <>
      "；审计状态 " <> ToString[status],
     Automatic
     ];
   Switch[status,
    "incomplete",
    dsWarningPrint[
      "动力学变量不完备；缺失/受约束方向为 " <>
       ToString[DeleteDuplicates@Join[
          Lookup[audit, "ruleMissingDirectionExpressions", {}],
          Lookup[audit, "parameterMissingDirectionExpressions", {}]
          ], InputForm],
      Automatic
      ],
    "overcomplete",
    dsWarningPrint[
      "动力学变量过完备；IBP 可继续，但冗余坐标 ds 与 rep2innerform 已禁用。约束残差为 " <>
       ToString[Lookup[audit, "constraintResiduals", {}], InputForm],
      Automatic
      ],
    _, Null
    ];
   audit
   ];


DSKinematics[input_, rules_: Automatic] := <|
   "status" -> "failed",
   "reason" -> "inputNotAssociation",
   "input" -> HoldForm[input],
   "rules" -> HoldForm[rules]
   |>;
