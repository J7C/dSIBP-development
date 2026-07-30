(* ::Package:: *)
(* 文件用途：用一个 ++ fixed massless line 检查 contact normalization，并用一个 +- line
   检查两个有序端点的相位。这里不枚举全部 SK 组合或 parity 分支。 *)


(* ::Chapter:: *)
(*加载开发包与 atomic topology*)

projectRoot = DirectoryName[DirectoryName[DirectoryName[$InputFileName]]];
packageDir = FileNameJoin[{projectRoot, "versions", "018_dSIBP"}];
$Path = Prepend[$Path, packageDir];
Needs["dSIBP`"];
DSMessagesOff[];

caseInput = <|
   "name" -> "CheckMasslessEndpointContact",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> p,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0,
       "skType" -> "++"|>
     },
   "loopMomenta" -> {},
   "loopExternalMomenta" -> {},
   "independentExternalMomenta" -> {p},
   "ibpMode" -> "timeOnly",
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "ispData" -> {},
   "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta1},
   "symmetryRules" -> {}
   |>;

context = DSInit[caseInput, RegisterAsCurrent -> False, ProgressReporting -> False];
topIntegral = dSIBP`Private`makeBaseIntegral[context["topology"]] /.
   {n[1, 1] -> 1, n[1, 2] -> 0};
topData = dSIBP`Private`sectorPrefactorDataForIntegral018[
   context["topology"], topIntegral
   ];


(* ::Chapter:: *)
(*单 contact 与一个 cross-SK endpoint witness*)

boundary = Expand@dSIBP`Private`timeThetaBoundaryShrinkTerms[
    context["topology"], topIntegral, v1
    ];
zeroContactIntegral = ReplacePart[topIntegral, {2, 1} -> {"F", 0, 0}];
zeroContactBoundary = Expand@dSIBP`Private`timeThetaBoundaryShrinkTerms[
    context["topology"], zeroContactIntegral, v1
    ];
contactTerm = SelectFirst[
   If[Head[boundary] === Plus, List @@ boundary, {boundary}],
   ! FreeQ[#, J[_, {{"F"}}, {}]] &,
   Missing["NoContact"]
   ];
contactIntegral = FirstCase[contactTerm, _J, Missing["NoContactIntegral"], Infinity];
contactCoefficient = If[
   Head[contactIntegral] === Missing,
   Missing["NoContactCoefficient"],
   Cancel[contactTerm/contactIntegral]
   ];

crossLine = <|"skType" -> "+-", "packType" -> "masslessCross"|>;
crossEndpointCoefficients = I dSIBP`Private`skEndpointPhaseSign[crossLine, #] & /@ {1, 2};


(* ::Chapter:: *)
(*验收*)

checks = <|
   "initialized" -> (Lookup[context, "status", "failed"] === "initialized"),
   "fixedLineThreeSlotState" -> MatchQ[topIntegral, J[_, {{"F", _, _}}, {}]],
   "structuralKEPower" -> (Lookup[topData, "kEPower", None] === kEpower[-beta1]),
   "normalizedContact" -> (contactCoefficient === -2/sE1^beta1),
   "zeroContactIsZero" -> (zeroContactBoundary === 0),
   "zeroContactHasNoFailure" -> FreeQ[zeroContactBoundary, $Failed],
   "singleCrossSKWitness" -> (crossEndpointCoefficients === {I, -I})
   |>;

failed = Keys@Select[checks, Not@TrueQ[#] &];
Print[InputForm[<|
   "passed" -> Count[Values[checks], True],
   "total" -> Length[checks],
   "failed" -> failed,
   "contactCoefficient" -> contactCoefficient,
   "crossEndpointCoefficients" -> crossEndpointCoefficients,
   "checks" -> checks
   |>]];
Exit[If[failed === {}, 0, 1]];
