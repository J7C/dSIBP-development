(* ::Package:: *)
(* Diagnose active-basis derivative targets missing from the last generated pure-massive linear system. *)

(* ::Chapter:: *)
(*Load*)

$CharacterEncoding = "UTF-8";
testDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[testDir];
packageDir = FileNameJoin[{codeDir, "014_dSIBP"}];
exampleDir = FileNameJoin[{codeDir, "examples", "014", "pure_massive_bubble_closed_loop"}];
If[! MemberQ[$Path, packageDir], AppendTo[$Path, packageDir]];
Needs["dSIBP`"];
Get[FileNameJoin[{exampleDir, "dlog_basis.wl"}]];
Get[FileNameJoin[{exampleDir, "family_conventions.wl"}]];

diagnosticContext = <|
   "topology" -> Get[FileNameJoin[{exampleDir, "init", "topology.wl"}]],
   "sectors" -> Get[FileNameJoin[{exampleDir, "init", "sectors.wl"}]]
   |>;
oldManifest = Get[FileNameJoin[{exampleDir, "kira", "dsibp-export-manifest.wl"}]];


(* ::Chapter:: *)
(*Compare*)

activeExpressions = referenceDlogCandidates[[referenceDlogActiveIndices]] /. {P1 -> -P0, P2 -> -P0};
rawDerivatives = Table[
   dSIBP`Private`dsSectorAwareDerivative[activeExpressions[[i]], variable, diagnosticContext],
   {i, Length[activeExpressions]}, {variable, {s11, P0}}
   ];
derivativeIntegrals = DeleteDuplicates[Cases[rawDerivatives, _J, Infinity]];
mappedIntegrals = Cases[
   Lookup[oldManifest, "integralRules", {}],
   HoldPattern[integral_J -> _Integer] :> integral
   ];
missingFromIntegralList = Complement[derivativeIntegrals, Lookup[oldManifest, "integralList", {}]];
missingFromIntegralMap = Complement[derivativeIntegrals, mappedIntegrals];

result = <|
   "derivativeIntegralCount" -> Length[derivativeIntegrals],
   "manifestIntegralListCount" -> Length[Lookup[oldManifest, "integralList", {}]],
   "manifestMappedIntegralCount" -> Length[mappedIntegrals],
   "missingFromIntegralListCount" -> Length[missingFromIntegralList],
   "missingFromIntegralList" -> missingFromIntegralList,
   "missingFromIntegralMapCount" -> Length[missingFromIntegralMap],
   "missingFromIntegralMap" -> missingFromIntegralMap
   |>;
Put[result, FileNameJoin[{testDir, "results_test", "014_active_basis_missing_targets.wl"}]];
Print["014 active-basis derivative targets: ", Length[derivativeIntegrals],
  "; missing from manifest integralList: ", Length[missingFromIntegralList],
  "; missing from reversible integral map: ", Length[missingFromIntegralMap]];
If[missingFromIntegralMap =!= {}, Print[missingFromIntegralMap]];
