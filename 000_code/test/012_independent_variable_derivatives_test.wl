(* ::Package:: *)
(* independent_variable_derivatives：检查独立变量求导模块。
   覆盖 ke[i] 顶点能量标量求导、s11 外不变量经 k_i.d/dk_j 分解求导、
   以及两外动量时 external-vector 算符空间的非唯一性记录。 *)

(* ::Chapter:: *)
(*初始化*)

exampleDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[exampleDir];
handDerivedDir = FileNameJoin[{codeDir, "check", "hand-derived-v2", "vertex_energy_signs"}];
Get[FileNameJoin[{codeDir, "012_dS_ibp_general.wl"}]];
Get[FileNameJoin[{handDerivedDir, "family.wl"}]];


(* ::Chapter:: *)
(*ke 直接标量求导*)

topApm = parseTopology[makeVertexEnergySignsCase["A+-"]];
intApm = makeBaseIntegral[topApm] /. {a[v1] -> 0, a[v2] -> 0, b[1] -> 0, n[1] -> 0, ispN[1] -> 0};

actualDKe2 = applySeedCanonical[
   applyIndependentVariableDerivativeSeed[topApm, intApm, ke[2]],
   topApm
   ];
expectedDKe2 = applySeedCanonical[
   -vertexExternalPhaseDerivativeCoefficient[topApm, v2] shiftVertexA[intApm, topApm, v2, 1],
   topApm
   ];
kePassQ = TrueQ[Expand[actualDKe2 - expectedDKe2] === 0];


(* ::Chapter:: *)
(*s11 外不变量求导*)

topBpp = parseTopology[makeVertexEnergySignsCase["B++"]];
intBpp = makeBaseIntegral[topBpp] /. {a[v1] -> 0, a[v2] -> 0, b[1] -> 0, n[1] -> 0, ispN[1] -> 1};

decompS11 = makeExternalInvariantDerivativeDecomposition[topBpp, s11];
genD11 = First @ Select[externalVectorDerivativeGenerators[topBpp], externalVectorDerivativeLabel[#] === {"externalVector", 1, 1} &];

actualDS11 = applySeedCanonical[
   applyIndependentVariableDerivativeSeed[topBpp, intBpp, s11],
   topBpp
   ];
expectedDS11 = applySeedCanonical[
   (1/(2 kk[1, 1])) applyExternalVectorDerivativeSeed[topBpp, intBpp, genD11],
   topBpp
   ];
s11PassQ = TrueQ[Expand[actualDS11 - expectedDS11] === 0];
decompPassQ = TrueQ[
   decompS11["operatorBasis"] === {{"externalVector", 1, 1}} &&
    decompS11["coefficients"] === {1/(2 kk[1, 1])} &&
    decompS11["residual"] === {0}
   ];

derivativeBatchBpp = makeIndependentVariableDerivativeSeedBatch[topBpp, intBpp];
batchS11Equation = SelectFirst[
   derivativeBatchBpp["equations"],
   #["userVariable"] === s11 &,
   Missing["NotFound"]
   ];
batchDerivativePassQ = TrueQ[
   derivativeBatchBpp["status"] === "generated" &&
    Lookup[derivativeBatchBpp["variables"], "userVariable"] === {s11, ke[2]} &&
    AssociationQ[batchS11Equation] &&
    Expand[batchS11Equation["derivative"] - actualDS11] === 0
   ];


(* ::Chapter:: *)
(*多外动量时的非唯一性*)

twoExternalCase = <|
   "name" -> "twoExternalDerivativeToy",
   "vertexData" -> {{u, "+"}, {v, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {u, v}, "momentum" -> ell - k1 - k2,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "loopMomenta" -> {ell},
   "externalMomenta" -> {k1, k2},
   "externalInvariantRules" -> {
     sp[k1, k1] -> s11,
     sp[k1, k2] -> s12,
     sp[k2, k2] -> s22
     },
   "vertexEnergies" -> <|u -> ke[1], v -> ke[2]|>,
   "ispData" -> {
     <|"name" -> rhoEllK1, "expr" -> sp[ell, k1], "range" -> {0}|>
     },
   "zeroPointRules" -> {
     a0[u] -> alphaU, a0[v] -> alphaV,
     b0[1] -> beta1, bS0[1] -> beta1
     },
   "seedPreset" -> "quickCheck"
   |>;

top2 = parseTopology[twoExternalCase];
decompS12Canonical = makeExternalInvariantDerivativeDecomposition[top2, s12];
decompS12All = makeExternalInvariantDerivativeDecomposition[
   top2,
   s12,
   ExternalVectorOperatorBasis -> "all"
   ];

nonUniquePassQ = TrueQ[
   decompS12Canonical["status"] === "solved" &&
    decompS12Canonical["residual"] === {0, 0, 0} &&
    decompS12All["status"] === "solved" &&
    decompS12All["nonUniqueQ"] === True &&
    decompS12All["nullity"] > 0
   ];


(* ::Chapter:: *)
(*汇总*)

Print["independent variable derivative ke check: ", kePassQ];
Print["independent variable derivative s11 check: ", s11PassQ];
Print["s11 decomposition check: ", decompPassQ];
Print["independent variable derivative batch check: ", batchDerivativePassQ];
Print["two-external non-unique decomposition recorded: ", nonUniquePassQ];

If[! nonUniquePassQ,
 Print["two-external canonical data: ", decompS12Canonical[[{"status", "operatorBasis", "coefficients", "residual", "nullity", "nonUniqueQ"}]]];
 Print["two-external all-basis data: ", decompS12All[[{"status", "operatorBasis", "coefficients", "residual", "nullity", "nonUniqueQ"}]]];
 ];

If[! And[kePassQ, s11PassQ, decompPassQ, batchDerivativePassQ, nonUniquePassQ], Exit[1]];
