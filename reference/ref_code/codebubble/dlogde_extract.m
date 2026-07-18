(* ::Package:: *)

(* ::Input:: *)
(*Quit[]*)


(***
\:6587\:4ef6\:ff1adlogde_extract.m
\:7528\:9014\:ff1a\:4ece DEP0 \:63d0\:53d6 dlog \:5b57\:6bcd\:548c\:7cfb\:6570\:77e9\:9635\:3002
\:6d41\:7a0b\:ff1a
  1. \:8bfb DEP0.m\:ff08ks=1, P0\[RightArrow]x\:ff09
  2. \:9010\:5143\:7d20\:79ef\:5206\:5f97 dlog \:5f62\:5f0f
  3. \:5c55\:5f00 ArcTan/ArcTanh \[RightArrow] Log
  4. \:63d0\:53d6\:6240\:6709 log \:53c2\:6570\:ff08\:5b57\:6bcd\:5019\:9009\:ff09
  5. \:5bfc\:51fa\:5230 temp/\:ff0c\:8ba9 simplify_letters.m \:5355\:72ec\:505a\:5b57\:6bcd\:5316\:7b80
  6. \:7b80\:5316\:540e\:7684\:66ff\:6362\:89c4\:5219\:5bfc\:56de\:ff0c\:5e94\:7528\:4e8e\:77e9\:9635\:5f97\:5230\:6700\:7ec8 dlogDE

\:8f93\:5165\:ff1akira_bubble/result/DEP0.m
\:8f93\:51fa\:5230 temp/: dlog1.m\:ff08\:5168\:77e9\:9635\:ff09, dlog1_args.m\:ff08\:5b57\:6bcd\:5019\:9009\:ff09, dlog1_coeff.m\:ff08\:7cfb\:6570\:ff09
\:8f93\:51fa\:5230 result/: alphabet.m, coeffdlog.m, dlogDE.m

\:8981\:70b9\:ff1a\:4e0d\:5bf9\:5927\:77e9\:9635\:505a\:5168\:5c40 Simplify\:ff0c\:53ea\:5316\:7b80\:5b57\:6bcd\:53c2\:6570\:3002
***)

(* \:56fa\:5b9a\:8def\:5f84\:ff1a\:786e\:4fdd\:4ece\:4efb\:4f55\:76ee\:5f55\:8fd0\:884c\:90fd\:80fd\:627e\:5230 DEP0.m *)
defaultBase = "D:\\opencode projects\\dSibp\\codebubble";
baseDir = If[DirectoryQ[defaultBase], defaultBase,
  If[DirectoryQ[FileNameJoin[{ParentDirectory[Directory[]], "codebubble"}]],
    FileNameJoin[{ParentDirectory[Directory[]], "codebubble"}],
    Directory[]
  ]
];

resultDir = FileNameJoin[{baseDir, "kira_bubble", "result"}];
tempDir = FileNameJoin[{baseDir, "temp"}];
If[!DirectoryQ[tempDir], CreateDirectory[tempDir]];

DEP0O = Import[FileNameJoin[{resultDir, "DEP0.m"}]];
DEksO = Import[FileNameJoin[{resultDir, "DEks.m"}]];
Get[FileNameJoin[{resultDir, "derivative_rules_bubble.m"}]];


(* \:53d6 k0\[RightArrow]I*P0 \:8fd8\:539f\:540e\:7684 DEP0\:ff0c\:7136\:540e ks\[RightArrow]1, P0\[RightArrow]x *)
repvar
reppara2N
dex = DEksO /. ks -> x /. P0 -> 1 /.repvar/.reppara2N//Factor;
dex//Variables


dlogdex0=dex//Integrate[#,x]&;


toLog[expr_] := expr /. {
  ArcTanh[z_] :> 1/2 (Log[1 + z] - Log[1 - z]),
  ArcCoth[z_] :> 1/2 (Log[z + 1] - Log[z - 1]),
  ArcTan[z_] :> I/2 (Log[1 - I z] - Log[1 + I z])
};
dlog1 = Map[toLog, dlogdex0, {2}];


allArgs = Cases[dlog1, Log[arg_] :> arg, Infinity] // DeleteDuplicates
CoeffArgs=Table[Coefficient[dlog1,Log[allArgs[[i]]]],{i,Length[allArgs]}];


(*\:68c0\:9a8cdlog,\:5982\:679c\:662fdlog form\:ff0clog\:7cfb\:6570\:4e2d\:4e0d\:8be5\:6709\:52a8\:529b\:5b66\:53d8\:91cf\:ff08\:6b64\:5904\:4e3ax\:ff09\:ff0c\:4e14log\:53d60\:540e\:5e94\:8be5\:5168\:4e3a0*)
CoeffArgs//Variables//DeleteDuplicates
dlog1/.Log[c1_]->0 //Factor


(* \:5bfc\:51fa\:539f\:59cb\:6570\:636e\:4f9b temp \:811a\:672c\:5355\:72ec\:5904\:7406 *)
Export[FileNameJoin[{tempDir, "dlog1.m"}], dlog1];
Export[FileNameJoin[{tempDir, "dlog1_args.m"}], allArgs];

Print["=== dlogde_extract.m done ==="];
Print["dlog1.m exported to: ", FileNameJoin[{tempDir, "dlog1.m"}]];
Print["dlog1_args.m exported to: ", FileNameJoin[{tempDir, "dlog1_args.m"}]];
Print["Run temp/simplify_letters.m to simplify and export alphabet + coeff."];
