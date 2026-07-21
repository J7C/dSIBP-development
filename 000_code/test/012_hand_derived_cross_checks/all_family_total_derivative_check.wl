(* ::Package:: *)
(* all_family_total_derivative：比较 10 个物理 family 的 general-index 手推总导数与公开 ds。 *)

(* ::Chapter:: *)
(*初始化*)

exampleDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[DirectoryName[exampleDir]];
handDerivedDir = FileNameJoin[{codeDir, "test", "012_hand-derived", "all_family_total_derivative"}];
Get[FileNameJoin[{codeDir, "012_dS_ibp_general.wl"}]];
Get[FileNameJoin[{handDerivedDir, "family.wl"}]];
Get[FileNameJoin[{handDerivedDir, "expected.wl"}]];


(* ::Chapter:: *)
(*全 case/sector/变量比较*)

allFamilyDerivativeCases = makeAllFamilyDerivativeCases[];
allFamilyDerivativeResults = Flatten[Table[
    Module[{def, top, topo, variables, expression, actual, expected, difference,
      generalIndexQ, externalFormQ, canonicalQ},
     def = allFamilyManualDefinition[entry];
     top = parseTopology[entry["case"]];
     topo = If[sector === "top", top, shrinkSectorTopology[top, manualShrunkLines[sector]]];
     variables = manualIndependentDerivativeVariables[def, entry["signKey"], sector];
     Table[
      expression = allFamilyDerivativeExpression[entry, def, sector, variable];
      actual = ds[expression, variable, topo];
      expected = allFamilyExpectedTotalDerivative[entry, def, sector, variable];
      difference = If[actual === $Failed || expected === $Failed,
        $Failed,
        Together[Expand[actual - expected]]
        ];
      generalIndexQ = ! FreeQ[expression, ga] && ! FreeQ[expression, gb] &&
        (Lookup[def, "ispData", {}] === {} || ! FreeQ[expression, gr]);
      externalFormQ = actual =!= $Failed && FreeQ[actual, kk];
      canonicalQ = actual =!= $Failed && ! containsForbiddenNQ[topo, actual];
      <|
       "family" -> entry["family"],
       "mode" -> entry["mode"],
       "signKey" -> entry["signKey"],
       "sector" -> sector,
       "variable" -> variable,
       "generalIndexQ" -> generalIndexQ,
       "externalFormQ" -> externalFormQ,
       "canonicalQ" -> canonicalQ,
       "passQ" -> TrueQ[difference === 0 && generalIndexQ && externalFormQ && canonicalQ],
       "difference" -> difference
       |>,
      {variable, variables}
      ]
     ],
    {entry, allFamilyDerivativeCases},
    {sector, manualSectors[allFamilyManualDefinition[entry], entry["signKey"]]}
    ], 2];


(* ::Chapter:: *)
(*汇总*)

allFamilyDerivativeFailed = Select[allFamilyDerivativeResults, ! TrueQ[#["passQ"]] &];
allFamilyDerivativeCounts = Counts[Lookup[allFamilyDerivativeResults, "family"]];

Print["all-family total derivative checks: ",
  Count[Lookup[allFamilyDerivativeResults, "passQ"], True], "/",
  Length[allFamilyDerivativeResults]];
Print["checks by family: ", allFamilyDerivativeCounts];

If[allFamilyDerivativeFailed =!= {},
 Print["First failed derivatives: ", Take[allFamilyDerivativeFailed, UpTo[12]]];
 Exit[1]
 ];
