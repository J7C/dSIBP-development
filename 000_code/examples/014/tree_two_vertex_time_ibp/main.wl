(* ::Package:: *)
(* 014 tree：两顶点同号 massive line 的 pure-time seed、迭代约化与直接 dlog DE。 *)

(* ::Chapter:: *)
(*标准 package 加载*)

exampleDir = DirectoryName[$InputFileName];
codeDir = ExpandFileName[FileNameJoin[{exampleDir, "..", "..", ".."}]];
packageDir = FileNameJoin[{codeDir, "014_dSIBP"}];
If[! MemberQ[$Path, packageDir], AppendTo[$Path, packageDir]];
Needs["dSIBP`"];

(* ::Chapter:: *)
(*详细物理输入*)

(* 两个 + 顶点由一条 massive h full line 相连；因此该线有共同 theta/contact source。 *)
(* ell12 只用于复用 loop dtau 原子公式，pure-time 路线不调用 dqq/dqk。 *)
(* treeEnergy=k12 决定 loop-to-tree 显式系数；alpha1/alpha2/beta12 均保持 general。 *)
treeCaseInput = <|
   "name" -> "014TreeTwoVertexPlusPlus",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> ell12,
       "treeEnergy" -> k12, "nu" -> nu12, "bbType" -> "h", "massType" -> "massive"|>
     },
   "loopMomenta" -> {ell12},
   "externalMomenta" -> {},
   "vertexEnergies" -> <|v1 -> K1, v2 -> K2|>,
   "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta12},
   "shrinkPrefactorRules" -> {Exp[Pi Im[nu12]] -> eta12},
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;

(* ::Chapter:: *)
(*缺省选项与本例覆盖*)

(* 缺省：不写 init 文件、不生成微分算符 metadata、不覆盖已有不同输入。 *)
treeInitOptions = {
   WriteInitializationFiles -> True,
   InitializationDirectory -> FileNameJoin[{exampleDir, "init"}],
   GenerateDerivativeMetadata -> False,
   OverwriteInitialization -> False
   };

(* 缺省：repIterative 终点为全零、MaxIterations->Automatic；本例显式写出全零终点。 *)
treeReductionEndpoint = {0, 0};

(* ::Chapter:: *)
(*初始化与全部 pure-time seeds*)

treeContext = DSInit[treeCaseInput, Sequence @@ treeInitOptions];
loopIntegrals = Flatten@Table[
    J[{a1, a2}, {{b12, n1, n2}}, {}],
    {n1, 0, 1}, {n2, 0, 1}
    ];
treeSeedData = Flatten@Table[
    DSTreeSeeds[vertex, integral, treeContext],
    {vertex, {v1, v2}}, {integral, loopIntegrals}
    ];

(* h contact 的 bS/bS0 与 merged a/a0 必须共同产生 k12^(-1-2 nu12)。 *)
zeroPointProjectionCheck = ! FreeQ[Lookup[treeSeedData, "treeSeed"], k12^(-1 - 2 nu12)];

(* ::Chapter:: *)
(*迭代约化与 dlog/master 同序输出*)

treeTarget = J[{{-2, 1}, {1, 0}}];
treeReduction = repIterative[treeTarget, treeReductionEndpoint, treeContext];
treeDLog = DSTreeDLogDE[treeContext, treeSeedData];

<|
 "status" -> If[zeroPointProjectionCheck && FreeQ[treeReduction, $Failed] && treeDLog["status"] === "generated", "passed", "failed"],
 "zeroPointProjectionCheck" -> zeroPointProjectionCheck,
 "reduction" -> treeReduction,
 "masters" -> treeDLog["masters"],
 "letters" -> treeDLog["letters"],
 "omega" -> treeDLog["omega"],
 "sourceEquations" -> treeDLog["sourceEquations"]
 |>

