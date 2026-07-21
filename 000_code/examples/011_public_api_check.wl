(* ::Package:: *)
(* 011：公开 IBP 算子、内外表示转换与 inert integrand 小型检查。 *)

exampleDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[exampleDir];
Get[FileNameJoin[{codeDir, "011_dS_ibp_general.wl"}]];

publicAPICase = <|
   "name" -> "publicAPIOneLineISP",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> e1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "loopMomenta" -> {q},
   "externalMomenta" -> {k},
   "externalInvariantRules" -> {sp[k, k] -> s11},
   "ispData" -> {
     <|"name" -> rhoUser, "expr" -> sp[q, k], "range" -> {0, 1}|>
     },
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2,
     b0[e1] -> beta1, bS0[e1] -> beta1
     },
   "symmetryRules" -> {}
   |>;

topo = parseTopology[publicAPICase];
int0 = J[{av1, av2}, {{bv, 0}}, {1}];
int1 = J[{av1 + 1, av2 - 1}, {{bv + 2, 1}}, {0}];

timeGen = SelectFirst[makeIBPGenerators[topo], #1["type"] === "time" && #1["vertex"] === v1 &];
qqGen = SelectFirst[makeIBPGenerators[topo], #1["type"] === "momentum" && #1["dLoop"] === 1 && #1["vectorType"] === "loop" && #1["vectorIndex"] === 1 &];
qkGen = SelectFirst[makeIBPGenerators[topo], #1["type"] === "momentum" && #1["dLoop"] === 1 && #1["vectorType"] === "external" && #1["vectorIndex"] === 1 &];

directTime = applySeedCanonical[applyTimeGeneratorSeed[topo, int0, timeGen], topo];
directQQ = applySeedCanonical[applyMomentumGeneratorSeed[topo, int0, qqGen], topo];
directQK = applySeedCanonical[applyMomentumGeneratorSeed[topo, int0, qkGen], topo];

setIBPTopologyContext[topo];

userCoefficientExpr = (s11 + sp[q, q] + 2 sp[q, k] + rhoUser) int0;
internalCoefficientExpr = (kk[1, 1] + qq[1, 1] + 2 qk[1, 1] + rho[1]) int0;
inner = rep2innerform[userCoefficientExpr, topo];
outer = rep2outform[internalCoefficientExpr, topo];
roundTrip = rep2innerform[rep2outform[internalCoefficientExpr, topo], topo];
integrand = rep2Integrand[3 int0, topo];

expectedIntegrand = Times[
   3,
   (-tau[v1])^(av1 + alpha1), (-tau[v2])^(av2 + alpha2),
   Exp[-I E1 tau[v1]], Exp[-I E2 tau[v2]],
   xi[e1]^(-bv - beta1), rhoUser,
   Hh[MasslessBlock["++", e1, {v1, v2}, xi[e1], 0]]
   ];

checks = {
   <|"name" -> "dtau-explicit", "passQ" -> TrueQ[Expand[dtau[v1, int0, topo] - directTime] === 0]|>,
   <|"name" -> "dqq-explicit", "passQ" -> TrueQ[Expand[dqq[1, 1, int0, topo] - directQQ] === 0]|>,
   <|"name" -> "dqk-explicit", "passQ" -> TrueQ[Expand[dqk[1, 1, int0, topo] - directQK] === 0]|>,
   <|"name" -> "momentum-symbol-indices", "passQ" -> TrueQ[Expand[dqk[q, k, int0, topo] - directQK] === 0]|>,
   <|"name" -> "dtau-linearity", "passQ" -> TrueQ[Expand[dtau[v1, 2 int0 - 3 int1, topo] - 2 dtau[v1, int0, topo] + 3 dtau[v1, int1, topo]] === 0]|>,
   <|"name" -> "registered-context", "passQ" -> TrueQ[Expand[dqq[1, 1, int0] - directQQ] === 0]|>,
   <|"name" -> "inner-form", "passQ" -> TrueQ[Expand[inner - internalCoefficientExpr] === 0]|>,
   <|"name" -> "out-form", "passQ" -> TrueQ[Expand[outer - userCoefficientExpr] === 0]|>,
   <|"name" -> "round-trip", "passQ" -> TrueQ[Expand[roundTrip - internalCoefficientExpr] === 0]|>,
   <|"name" -> "J-slots-preserved", "passQ" -> SameQ[DeleteDuplicates[Cases[inner, _J, Infinity]], {int0}], "actual" -> DeleteDuplicates[Cases[inner, _J, Infinity]]|>,
   <|"name" -> "integrand-no-J", "passQ" -> FreeQ[integrand, _J]|>,
   <|"name" -> "integrand-inert-Hh", "passQ" -> ! FreeQ[integrand, _Hh]|>,
   <|"name" -> "integrand-content", "passQ" -> TrueQ[Expand[integrand - expectedIntegrand] === 0], "difference" -> Expand[integrand - expectedIntegrand]|>,
   <|"name" -> "invalid-discrete-gate", "passQ" -> SameQ[dtau[v1, J[{av1, av2}, {{bv, nbad}}, {1}], topo], $Failed]|>
   };

failed = Select[checks, ! TrueQ[#1["passQ"]] &];
Print["011 public API checks: ", Count[Lookup[checks, "passQ"], True], "/", Length[checks]];
If[failed =!= {}, Print["Failed checks: ", failed]; Exit[1]];

clearIBPTopologyContext[];
