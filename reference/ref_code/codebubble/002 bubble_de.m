(* ::Package:: *)

(* ::Chapter:: *)
(*Re-import Kira Results*)


(* ::Section:: *)
(*Paths*)


dir = If[StringQ[$InputFileName] && $InputFileName =!= "",
  DirectoryName[$InputFileName],
  If[TrueQ[$Notebooks],
    With[{nd = Quiet[Check[NotebookDirectory[], $Failed]]},
      If[StringQ[nd] && nd =!= $Failed, nd, Directory[]]
    ],
    Directory[]
  ]
];
SetDirectory[dir];

kiraworkspace = "kira_bubble";
resultDir = FileNameJoin[{dir, kiraworkspace, "result"}];
reduceDir = FileNameJoin[{dir, kiraworkspace, "results"}];


(* ::Section:: *)
(*Load Result Files*)


Get[FileNameJoin[{resultDir, "derivative_rules_bubble.m"}]];
MIdlogNote = Import[FileNameJoin[{resultDir, "MIdlogNote.m"}]];
repkira2GR = Import[FileNameJoin[{resultDir, "repkira2GR.m"}]];
repGR2num = Import[FileNameJoin[{resultDir, "repGR2num.m"}]];
repreduce = Import[FileNameJoin[{reduceDir, "kira_list.m"}]];

repvar
reppara2N
repNumericTestKira


(* ::Section:: *)
(*Choose Independent MIs*)


masterIds = ToExpression @ StringCases[
  Import[FileNameJoin[{reduceDir, "masters"}], "Text"],
  StartOfLine ~~ WhitespaceCharacter ... ~~ id : NumberString ~~ WhitespaceCharacter ... ~~ "#" :> id
]
nMI = 19; (*\:624b\:52a8\:8bbe\:7f6e\:ff0c\:6839\:636e\:591a\:6b21\:7ea6\:5316\:540e\:7a33\:5b9a\:7684\:4e3b\:79ef\:5206\:ff08\:771f\:6b63\:7684\:4e3b\:79ef\:5206\:7684\:622a\:6b62\:6807\:53f7 \:4e00\:822c\:4e0e \:7531\:4e8eibp\:4e0d\:591f\:5bfc\:81f4\:6ca1\:88ab\:7ea6\:5316\:800c\:5217\:5165kira\:4e3b\:79ef\:5206\:7684\:79ef\:5206\:6807\:53f7 \:95f4\:9694\:5de8\:5927\:ff09*)
MIs = Table[Tuserweight[i] ,{i,nMI}];

(* Keep ks/k0 symbolic before differentiation so explicit derivative contributions are preserved. *)
MIdlogSym = (MIdlogNote[[;; nMI]] /. repvar /. reppara2N) // Simplify
repMIs0 = Table[MIs[[i]] -> 0, {i, Length[MIs]}];


(* ::Chapter:: *)
(*DE*)


(* ::Section:: *)
(*Symbolic derivative layer*)


DEk00 = (((dk0[MIdlogSym] // id // symmetry) /. repGR2num)/. repreduce/.repvar/.reppara2N) // Expand;
DEks0 = (((dks[MIdlogSym] // id // symmetry) /. repGR2num)/. repreduce/.repvar/.reppara2N) // Expand;


(* ::Section:: *)
(*Numeric reduction layer*)


(* \:6d4b\:8bd5\:5fae\:5206\:65b9\:7a0b\:4ea7\:751f\:7684\:79ef\:5206\:662f\:5426\:90fd\:5728kira\:4e2d\:88ab\:7ea6\:5316\:6389\:4e86\:ff0c\:5982\:679c\:7ea6\:5316\:6389\:4e86\:ff0crepMIs0\:540e\:5e94\:8be5\:53ea\:52690 *)
DEk00check = Join[
    DEk00 // Cases[#, Tuserweight[___], Infinity] & // DeleteDuplicates,
    DEk00 // Cases[#, G[___] | R1[___] | dlog[_], Infinity] & // DeleteDuplicates
] // DeleteDuplicates;
DEk00check = DEk00check /. repMIs0

DEks0check = Join[
    DEks0 // Cases[#, Tuserweight[___], Infinity] & // DeleteDuplicates,
    DEks0 // Cases[#, G[___] | R1[___] | dlog[_], Infinity] & // DeleteDuplicates
] // DeleteDuplicates;
DEks0check = DEks0check /. repMIs0


(* ::Section:: *)
(*Extract DE matrices in the active dlog dummy basis*)


DEk0 = Table[
    Coefficient[DEk00, MIs[[i]]],
    {i, Length[MIs]}
] // Transpose (*// Factor*);

DEks = Table[
    Coefficient[DEks0, MIs[[i]]],
    {i, Length[MIs]}
] // Transpose (*// Factor*);


(* ::Section:: *)
(*Restore physical variables*)


DEP0O = ((I*DEk0/.ks->1)/ks /. k0 -> I*P0/ks)(* //Factor*);
DEksO = ((DEks/.ks->1)/ks /. k0 -> I*P0/ks)(* //Factor*);


(* ::Section:: *)
(*Scaling Checks*)


repNumericTestKira


(* 1. Symbolic-form logic check: useful for future analytic reduction workflows. *)
DEscaleCheck = (ks*DEksO + P0*DEP0O)/.repvar/.reppara2N/.P0->-I k0/.ks->1/. repNumericTestKira[[3]]// Factor;


DEscaleCheck


(* 2. Fully numeric check for the current numeric-reduction workflow. *)
DEscaleCheckNum = (DEscaleCheck /.P0->-I k0 /.repvar/.reppara2N/.ks->1/. repNumericTestKira) // Simplify


(* ::Section:: *)
(*Export*)


Export[FileNameJoin[{resultDir, "DEP0.m"}], DEP0O];
Export[FileNameJoin[{resultDir, "DEks.m"}], DEksO];
Export[FileNameJoin[{resultDir, "DEscaleCheck.m"}], DEscaleCheck(*DEscaleCheckNum*)];


(* ::Section:: *)
(*Print*)


Print["MIs = ", MIs];
Print["DEk00check = ", DEk00check];
Print["DEks0check = ", DEks0check];
Print["DEP0 dimensions = ", Dimensions[DEP0O]];
Print["DEks dimensions = ", Dimensions[DEksO]];
Print["DEscaleCheck = ", DEscaleCheck];
Print["Scaling diagonal = ", Diagonal[DEscaleCheck]];
Print["Off-diagonal nonzero count = ", Count[Flatten[DEscaleCheck - DiagonalMatrix[Diagonal[DEscaleCheck]]], x_ /; x =!= 0]];
Print["d(scaleCheck)/dP0 (should be zero): ", D[DEscaleCheck, P0] // Simplify === ConstantArray[0, Dimensions[DEscaleCheck]]];
Print["d(scaleCheck)/dks (should be zero): ", D[DEscaleCheck, ks] // Simplify === ConstantArray[0, Dimensions[DEscaleCheck]]];
