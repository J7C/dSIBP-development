(* ::Package:: *)
(* 本文件定向验证三条平行 massive h 传播子的 R^(1) contact source：
   ++ branch 必须保留共同-theta的 single/triple odd subsets，并把各线 zero-point 写入显式系数；
   +- branch 由顶点符号统一决定全部传播子类型，不得产生任何 theta/contact lower source。 *)

(* ::Chapter:: *)
(*加载 package 与公共输入*)

checkDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[checkDir];
packageDir = FileNameJoin[{codeDir, "014_dSIBP"}];
If[! MemberQ[$Path, packageDir], AppendTo[$Path, packageDir]];
Needs["dSIBP`"];
DSMessagesOff[];

parallelCase[name_, secondSign_] := <|
   "name" -> name,
   "vertexData" -> {{w1, "+"}, {w2, secondSign}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {w1, w2}, "momentum" -> q1,
       "treeEnergy" -> k1, "nu" -> nu1, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 2, "endpoints" -> {w1, w2}, "momentum" -> q2,
       "treeEnergy" -> k2, "nu" -> nu2, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 3, "endpoints" -> {w1, w2}, "momentum" -> q1 + q2,
       "treeEnergy" -> k3, "nu" -> nu3, "bbType" -> "h", "massType" -> "massive"|>
     },
   "loopMomenta" -> {q1, q2},
   "externalMomenta" -> {},
   "vertexEnergies" -> <|w1 -> L1, w2 -> L2|>,
   "zeroPointRules" -> {
     a0[w1] -> gamma1, a0[w2] -> gamma2,
     b0[1] -> delta1, b0[2] -> delta2, b0[3] -> delta3
     },
   "seedPreset" -> "quickCheck"
   |>;


(* ::Chapter:: *)
(*++ branch 的指定 R^(1) 行*)

plusContext = DSInit[parallelCase["014ParallelR1PlusPlus", "+"]];
plusFamilies = dSIBP`Private`dsTreeFamilyContext[plusContext];
plusTopFamily = plusFamilies["topFamily"];

(* 每条线在 w1 端取 n=1、w2 端取 n=0；只把被求导顶点的 a 从 0 改成 1。 *)
plusMaster = J[{{0, 1, 1, 1}, {0, 0, 0, 0}}];
plusRows = dSIBP`Private`dsTreeContactRows[plusTopFamily, {plusMaster}, plusContext];
plusW1Row = plusRows["rowsByVertex", w1][[1]];
plusRawTerms = Lookup[plusW1Row, "rawTerms", {}];
plusReducedTerms = Lookup[plusW1Row, "terms", {}];
plusRawSectors = DeleteDuplicates[Lookup[plusRawTerms, "sectorKey", {}]];
plusTripleTerms = Select[plusRawTerms, Lookup[#, "sectorKey", ""] === "e1_e2_e3" &];
plusTripleAudits = Flatten[Lookup[plusTripleTerms, "physicalPowerAudits", {}], 1];


(* ::Chapter:: *)
(*+- branch 的 mixed-sign 门禁*)

mixedContext = DSInit[parallelCase["014ParallelR1PlusMinus", "-"]];
mixedFamilies = dSIBP`Private`dsTreeFamilyContext[mixedContext];
mixedTopFamily = mixedFamilies["topFamily"];
mixedMaster = First[dSIBP`Private`treeMasterList[mixedTopFamily]];
mixedRows = dSIBP`Private`dsTreeContactRows[mixedTopFamily, {mixedMaster}, mixedContext];
mixedRawTerms = Flatten[Lookup[Values[mixedRows["rowsByVertex"]][[All, 1]], "rawTerms", {}], 1];
mixedPackTypes = Lookup[mixedContext["topology", "lines"], "packType", {}];


(* ::Chapter:: *)
(*验收*)

checks = <|
   "plusContextInitialized" -> Lookup[plusContext, "status", "missing"] === "initialized",
   "plusContactRowsGenerated" -> Lookup[plusRows, "status", "missing"] === "generated",
   "r1SeedNotR0" -> First[plusW1Row["seedIntegral"]][[1, 1]] === 1 &&
     First[plusW1Row["master"]][[1, 1]] === 0,
   "commonThetaOddSubsetSectors" -> ContainsAll[plusRawSectors, {"e1", "e2", "e3", "e1_e2_e3"}] &&
     Intersection[plusRawSectors, {"e1_e2", "e1_e3", "e2_e3"}] === {},
   "directTripleContactPresent" -> plusTripleTerms =!= {},
   "tripleZeroPointAudit" -> AnyTrue[
     plusTripleAudits,
     Lookup[#, "deltaLineIntegerPowers", {}] === {1, 1, 1} &&
       Lookup[#, "deltaLineZeroPointPowers", {}] === {2 nu1, 2 nu2, 2 nu3} &&
       Lookup[#, "deltaLinePhysicalPowers", {}] === {1 + 2 nu1, 1 + 2 nu2, 1 + 2 nu3} &&
       Lookup[#, "explicitEnergyPowers", {}] === {-1 - 2 nu1, -1 - 2 nu2, -1 - 2 nu3} &&
       Lookup[Lookup[#, "target", <||>], "treeNu0", {}] ===
        {gamma1 + gamma2 - 2 nu1 - 2 nu2 - 2 nu3} &
     ],
   "tripleCoefficientProduct" -> AnyTrue[
     plusTripleTerms,
     ! FreeQ[Lookup[#, "projectionCoefficient", 0],
       k1^(-1 - 2 nu1) k2^(-1 - 2 nu2) k3^(-1 - 2 nu3)] &
     ],
   "tripleSourceSurvivesReduction" -> AnyTrue[
     plusReducedTerms,
     Lookup[#, "sectorKey", ""] === "e1_e2_e3" &&
       ! FreeQ[Lookup[#, "coefficient", 0],
        k1^(-1 - 2 nu1) k2^(-1 - 2 nu2) k3^(-1 - 2 nu3)] &
     ],
   "mixedContextInitialized" -> Lookup[mixedContext, "status", "missing"] === "initialized",
   "vertexSignsFixAllMixedPropagators" -> mixedPackTypes === ConstantArray["massiveCross", 3],
   "mixedBranchHasOnlyTopSector" -> Lookup[mixedFamilies, "sectorOrder", {}] === {"top"},
   "mixedContactRowsGenerated" -> Lookup[mixedRows, "status", "missing"] === "generated",
   "mixedBranchHasNoThetaSource" -> mixedRawTerms === {},
   "noUnsafePowerExpand" -> FreeQ[
     {DownValues[dSIBP`Private`dsTreeContactRows],
      DownValues[dSIBP`Private`loopTreeProjectionCoefficient]},
     PowerExpand
     ]
   |>;

Print["014 parallel R1 contact check: ", Count[Values[checks], True], "/", Length[checks]];
If[! And @@ Values[checks],
 Print[Select[checks, Not]];
 Print["plus raw sectors=", plusRawSectors];
 Print["plus triple terms=", Short[plusTripleTerms, 5]];
 Print["mixed pack types=", mixedPackTypes, ", sectors=", Lookup[mixedFamilies, "sectorOrder", Missing["sectorOrder"]]];
 Print["mixed rows=", Short[mixedRows, 5]];
 Exit[1]
 ];
