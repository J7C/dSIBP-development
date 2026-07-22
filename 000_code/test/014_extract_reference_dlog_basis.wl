(* ::Package:: *)
(* 从权威 bubble reference 中只执行 convention/EOM/symmetry 与 dlog-basis 构造段；
   跳过大规模 IBP seed、Kira serializer 和 reduction，输出仅供 014 对齐检查。 *)

(* ::Chapter:: *)
(*路径与参考源码*)

testDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[testDir];
projectDir = DirectoryName[codeDir];
packageDir = FileNameJoin[{codeDir, "014_dSIBP"}];
exampleDir = FileNameJoin[{codeDir, "examples", "014", "pure_massive_bubble_closed_loop"}];
referenceDir = FileNameJoin[{projectDir, "reference", "ref_code", "codebubble"}];
referenceFile = FileNameJoin[{referenceDir, "001 bubble_ibp_sym.m"}];
resultDir = FileNameJoin[{testDir, "results_test", "014_reference_dlog_basis"}];
If[! DirectoryQ[resultDir], CreateDirectory[resultDir, CreateIntermediateDirectories -> True]];

sourceText = Import[referenceFile, "Text"];
If[! MemberQ[$Path, packageDir], AppendTo[$Path, packageDir]];
Needs["dSIBP`"];

extractReferenceSection[text_String, startTitle_String, endTitle_String] := Module[{start, end},
   start = First@First@StringPosition[text, startTitle];
   end = First@First@StringPosition[text, endTitle];
   StringTake[text, {start, end - 1}]
   ];


(* ::Chapter:: *)
(*只执行 dlog basis 的依赖段*)

SetDirectory[referenceDir];
listcal[expr_, i_, j_, shift_] := ReplacePart[expr, {i, j} -> expr[[i, j]] + shift];

conventionText = extractReferenceSection[
   sourceText,
   "(*Integral Substitutions & Symmetries*)",
   "(*Generating Base IBP Seeds*)"
   ];
basisText = extractReferenceSection[
   sourceText,
   "(*Constructing Master Integrals (MIs) & dlog Basis*)",
   "(*Derivatives (k0, ks)*)"
   ];

ToExpression[conventionText];
ToExpression[basisText];
MIdlogPhysical = (MIdlogNote /. repvar /. {
      a0 -> 2 nu,
      b0 -> -2 nu,
      d -> dim,
      k0 -> I (P1 + P2)/2,
      ks -> Sqrt[s11]
      }) // Simplify;
Get[FileNameJoin[{exampleDir, "dlog_basis.wl"}]];
referenceMappedToJ = MIdlogPhysical /. {
    G[nList_List, aList_List, bList_List] :>
     J[aList, {{bList[[1]], nList[[1]], nList[[2]]}, {bList[[2]], nList[[3]], nList[[4]]}}, {}],
    R1[nList_List, {aPower_}, bList_List] :>
     J[{aPower}, {{bList[[1]]}, {bList[[2]], nList[[1]], nList[[2]]}}, {}]
    };
referenceExampleResidual = MapThread[Together[Expand[#1 - #2]] &, {referenceMappedToJ, referenceDlogCandidates}];


(* ::Chapter:: *)
(*输出与结构门禁*)

Put[MIdlogNote, FileNameJoin[{resultDir, "MIdlogNote.wl"}]];
Put[MIdlogKira, FileNameJoin[{resultDir, "MIdlogKira.wl"}]];
Put[Take[MIdlogKira, 19], FileNameJoin[{resultDir, "MIdlogKiraActive19.wl"}]];
Put[MIdlogPhysical, FileNameJoin[{resultDir, "MIdlogPhysicalCandidates21.wl"}]];
Put[Take[MIdlogPhysical, 19], FileNameJoin[{resultDir, "MIdlogPhysicalActive19.wl"}]];
Put[<|
   "basisd123Top" -> Length[basisd123Top],
   "basisd3Top" -> Length[basisd3Top],
   "basisd3OmegaTop" -> Length[basisd3OmegaTop],
   "MIdlogR1" -> Length[MIdlogR1],
   "MIdlogNote" -> Length[MIdlogNote]
   |>, FileNameJoin[{resultDir, "summary.wl"}]];

Print["014 reference dlog basis lengths: ",
  {Length[basisd123Top], Length[basisd3Top], Length[basisd3OmegaTop], Length[MIdlogR1], Length[MIdlogNote]}];
Print["014 reference/example dlog residuals zero: ", And @@ (# === 0 & /@ referenceExampleResidual)];
If[Length[MIdlogNote] =!= 21 || Length[MIdlogKira] =!= 21 || Length[Take[MIdlogKira, 19]] =!= 19 ||
  ! And @@ (# === 0 & /@ referenceExampleResidual), Exit[1]];
