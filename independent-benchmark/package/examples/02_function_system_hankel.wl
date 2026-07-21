(* Massive function-system example: bare Hankel P,Q,T,W input. *)

exampleDir = DirectoryName[$InputFileName];
packageDir = DirectoryName[exampleDir];
Get[FileNameJoin[{packageDir, "package_012.wl"}]];

prefactor = (4 I/Pi) Exp[Pi Im[nuM]];
hankelSystem = <|
   "variable" -> x,
   "P" -> 1/x,
   "Q" -> 1 - nuM^2/x^2,
   "T" -> IdentityMatrix[2],
   "W" -> -prefactor/x,
   "WT" -> Automatic,
   "shrinkBShift" -> 1,
   "shrinkZeroPointShift" -> 0
   |>;

compiled = compileFunctionSystem[hankelSystem];

case = <|
   "name" -> "bareHankelExample",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> e1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "nu" -> nuM, "massType" -> "massive",
       "functionSystem" -> hankelSystem|>
     },
   "loopMomenta" -> {q},
   "externalMomenta" -> {},
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2, b0[e1] -> beta1
     },
   "seedPreset" -> "quickCheck"
   |>;

topo = parseTopology[case];
If[topo === $Failed, Exit[1]];

int = makeBaseIntegral[topo] /. {
   a[v1] -> 0, a[v2] -> 0, b[e1] -> 0,
   n[e1, 1] -> 1, n[e1, 2] -> 0
   };

Print[<|
  "compileStatus" -> compiled["status"],
  "AT" -> compiled["AT"],
  "WT" -> compiled["WT"],
  "derivativeTerms" -> compiled["derivativeTerms"],
  "timeRelation" -> dtau[v1, int, topo]
|>];
