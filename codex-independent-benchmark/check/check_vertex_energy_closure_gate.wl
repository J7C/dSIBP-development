(* ::Package:: *)
(* 本脚本验证 vertex_energy_signs 补入 rho1=sp[ell,k] 后的完整闭合性。
   第一层检查三组 energy case、两个 sign 分支的 scalar system；第二层逐条比较
   独立 time/momentum/general-derivative expected 与 package actual。 *)


(* ::Chapter:: *)
(*独立冻结输入*)

checkDir = DirectoryName[$InputFileName];
benchmarkDir = DirectoryName[checkDir];
workspaceDir = DirectoryName[benchmarkDir];

Get[FileNameJoin[{benchmarkDir, "vertex_energy_signs", "expected.wl"}]];
frozenFamilies = familyDefinitions;
frozenRelations = expectedRelations;
frozenDerivatives = expectedDerivatives;
frozenSummary = expectedSummary;

Get[FileNameJoin[{
    workspaceDir, "independent-benchmark", "package", "package_012.wl"
    }]];


(* ::Chapter:: *)
(*Package topology adapter*)

(* ISP 顺序沿用 family ispData；range 覆盖任务书固定的 0/1 seed 点。 *)
vertexEnergyISPData[family_Association] := MapIndexed[
   <|"name" -> rho[First[#2]], "expr" -> #1["expression"], "range" -> {0, 1}|> &,
   family["ispData"]
   ];


vertexEnergyCase[family_Association, signCase_] := <|
   "name" -> "codexVertexEnergy_" <> family["energyCase"] <> "_" <> signCase,
   "vertexData" -> Transpose[{
      family["vertexOrder"],
      (If[#1 === 1, "+", "-"] &) /@ family["vertexSignCases"][signCase]
      }],
   "lineData" -> family["lineData"],
   "loopMomenta" -> family["loopMomenta"],
   "externalMomenta" -> family["externalMomenta"],
   "externalInvariantRules" -> family["externalInvariantRules"],
   "vertexEnergies" -> family["vertexEnergies"],
   "ispData" -> vertexEnergyISPData[family],
   "zeroPointRules" -> family["zeroPointRules"],
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;


vertexEnergySelectedLines["top"] := {};
vertexEnergySelectedLines[name_String] := ToExpression /@ StringCases[
   name,
   "e" ~~ digits : DigitCharacter .. :> digits
   ];


vertexEnergyTopologies = Association@Table[
   family["energyCase"] -> Association@Table[
     signCase -> parseTopology[vertexEnergyCase[family, signCase]],
     {signCase, Keys[family["vertexSignCases"]]}
     ],
   {family, frozenFamilies}
   ];


vertexEnergyTopology[energyCase_, signCase_, sectorName_] := Module[
   {topo = vertexEnergyTopologies[energyCase][signCase],
    selected = vertexEnergySelectedLines[sectorName]},
   If[selected === {}, topo, shrinkSectorTopology[topo, selected]]
   ];


(* relation 没有独立 energyCase 字段；冻结 tag 是六字段格式下的唯一 case 键。 *)
vertexEnergyRecordCase[record_Association] := Module[
   {tag = SelectFirst[
      Lookup[record, "tags", {}],
      StringQ[#1] && StringStartsQ[#1, "energyCase"] &,
      Missing["EnergyCaseTag"]
      ]},
   If[Head[tag] === Missing, tag, StringDrop[tag, StringLength["energyCase"]]]
   ];


(* ::Chapter:: *)
(*Scalar closure 与 topology 状态*)

closureRows = Flatten@Table[
    Module[{topo, spData, rules, scalarRuleResiduals},
     topo = vertexEnergyTopologies[family["energyCase"]][signCase];
     spData = makeScalarProductData[topo];
     rules = makeScalarProductRules[topo];
     scalarRuleResiduals = If[
       rules["status"] === "computed",
       Expand[{
         (sp[ell, k] /. rules["userRepSP2Z"]) - rho[1],
         (sp[ell, ell] /. rules["userRepSP2Z"]) -
          (z[1] + 2 rho[1] - s11)
         }],
       {$Failed, $Failed}
       ];
     <|
      "energyCase" -> family["energyCase"],
      "signCase" -> signCase,
      "structuralNeededISPCount" -> spData["structuralNeededISPCount"],
      "providedISPCount" -> Length[topo["ispData"]],
      "coverageQ" -> spData["coverageQ"],
      "structuralCountQ" -> spData["structuralCountQ"],
      "coordinateCountQ" -> spData["coordinateCountQ"],
      "ruleStatus" -> rules["status"],
      "ruleReason" -> Lookup[rules, "reason", Missing["NoReason"]],
      "scalarRuleResiduals" -> scalarRuleResiduals
      |>
     ],
    {family, frozenFamilies},
    {signCase, Keys[family["vertexSignCases"]]}
    ];

closureCompleteQ = And @@ (
    #1["structuralNeededISPCount"] === 1 &&
      #1["providedISPCount"] === 1 &&
      TrueQ[#1["structuralCountQ"]] &&
      TrueQ[#1["coordinateCountQ"]] &&
      #1["ruleStatus"] === "computed" &&
      #1["scalarRuleResiduals"] === {0, 0} & /@
     closureRows
    );

topologyStatusQ = And @@ (
    Lookup[topologyValidationReport[#1], "status", "invalid"] === "ok" & /@
     Flatten[Values /@ Values[vertexEnergyTopologies]]
    );


(* ::Chapter:: *)
(*Seed relation 对照*)

vertexEnergyZeroDifferenceQ[difference_] := TrueQ[difference === 0] ||
  TrueQ[Quiet[FullSimplify[difference == 0]]];


vertexEnergyRelationActual[record_Association] := Module[
   {energyCase, topo, integral, generator = record["generator"], actual},
   energyCase = vertexEnergyRecordCase[record];
   If[Head[energyCase] === Missing, Return[$Failed]];
   topo = vertexEnergyTopology[
     energyCase, record["vertexSigns"], record["sector"]
     ];
   integral = makeBaseIntegral[topo] /. record["seedRules"];
   actual = Which[
     Head[generator] === dtau,
     dtau[generator[[1]], integral, topo],
     Head[generator] === dqq,
     dqq[generator[[1]], generator[[2]], integral, topo],
     Head[generator] === dqk,
     dqk[generator[[1]], generator[[2]], integral, topo],
     True,
     $Failed
     ];
   If[
    actual === $Failed,
    $Failed,
    If[
     Head[generator] === dtau,
     Expand[actual /. externalInvariantInternalToUserRules[topo]],
     rep2outform[actual, topo]
     ]
    ]
   ];


relationRows = MapIndexed[
   Function[{record, position},
    Module[{actual, difference, passQ},
     actual = vertexEnergyRelationActual[record];
     difference = If[
       actual === $Failed,
       $Failed,
       Expand[(actual /. dim -> d) - record["equation"]]
       ];
     passQ = vertexEnergyZeroDifferenceQ[difference];
     <|
      "index" -> First[position],
      "energyCase" -> vertexEnergyRecordCase[record],
      "sector" -> record["sector"],
      "vertexSigns" -> record["vertexSigns"],
      "generator" -> record["generator"],
      "seedRules" -> record["seedRules"],
      "passQ" -> passQ,
      "difference" -> If[passQ, 0, difference]
      |>
     ]
    ],
   frozenRelations
   ];

relationFailures = Select[relationRows, ! TrueQ[#1["passQ"]] &];


(* ::Chapter:: *)
(*General total derivative 对照*)

derivativeRows = MapIndexed[
   Function[{record, position},
    Module[{topo, actual, difference, passQ},
     topo = vertexEnergyTopology[
       record["mode"], record["vertexSigns"], record["sector"]
       ];
     actual = ds[record["expression"], record["variable"], topo];
     difference = If[
       actual === $Failed,
       $Failed,
       Expand[(actual /. dim -> d) - record["derivative"]]
       ];
     passQ = vertexEnergyZeroDifferenceQ[difference];
     <|
      "index" -> First[position],
      "energyCase" -> record["mode"],
      "sector" -> record["sector"],
      "vertexSigns" -> record["vertexSigns"],
      "variable" -> record["variable"],
      "passQ" -> passQ,
      "difference" -> If[passQ, 0, difference]
      |>
     ]
    ],
   frozenDerivatives
   ];

derivativeFailures = Select[derivativeRows, ! TrueQ[#1["passQ"]] &];


(* ::Chapter:: *)
(*Summary 与失败样本*)

checkSummary = <|
   "timeRelationCount" -> frozenSummary["timeRelationCount"],
   "momentumRelationCount" -> frozenSummary["momentumRelationCount"],
   "relationCount" -> Length[relationRows],
   "relationPassed" -> Count[Lookup[relationRows, "passQ"], True],
   "relationFailed" -> Length[relationFailures],
   "derivativeCount" -> Length[derivativeRows],
   "derivativePassed" -> Count[Lookup[derivativeRows, "passQ"], True],
   "derivativeFailed" -> Length[derivativeFailures],
   "caseSignCount" -> Length[closureRows],
   "closureRows" -> closureRows,
   "closureCompleteQ" -> closureCompleteQ,
   "topologyStatusQ" -> topologyStatusQ,
   "passQ" -> TrueQ[closureCompleteQ && topologyStatusQ] &&
     relationFailures === {} && derivativeFailures === {} &&
     frozenSummary["status"] === "complete"
   |>;

Print[InputForm[checkSummary]];
If[relationFailures =!= {},
 Print["FIRST_RELATION_FAILURES"];
 Print[InputForm[Take[relationFailures, UpTo[4]]]]
 ];
If[derivativeFailures =!= {},
 Print["FIRST_DERIVATIVE_FAILURES"];
 Print[InputForm[Take[derivativeFailures, UpTo[4]]]]
 ];

If[! TrueQ[checkSummary["passQ"]], Exit[1]];
