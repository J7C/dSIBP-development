(* ::Package:: *)
(* 文件用途：只读正式保存的 massive-bubble 解析 probe，在唯一固定点检查 scaling relation。
   本脚本不调用 reference producer、package IBP、Kira、reduction 或 post-reduction 流程。 *)


(* ::Chapter:: *)
(*读取已有解析结果*)

projectRoot = DirectoryName[DirectoryName[DirectoryName[$InputFileName]]];
probeFile = FileNameJoin[{
    projectRoot, "independent-benchmark", "reference-results",
    "pure_massive_bubble", "reference_probe.wl"
    }];
If[! FileExistsQ[probeFile], Exit[2]];
probe = Get[probeFile];

deP0 = Lookup[probe, "deP0Physical", Lookup[probe, "deP0", Missing["deP0"]]];
deKs = Lookup[probe, "deKsPhysical", Lookup[probe, "deKs", Missing["deKs"]]];
expectedScaling = Lookup[probe, "scalingDiagonal", Missing["scalingDiagonal"]];
packagePoint = Lookup[probe, "packagePhysicalRules", {}];
ksValue = ks /. packagePoint;
p0Value = P0 /. packagePoint;


(* ::Chapter:: *)
(*唯一固定点的 Euler/scaling 检查*)

scalingMatrix = Map[Together, ksValue deKs + p0Value deP0, {2}];
scalingDifference = Map[Together, scalingMatrix - expectedScaling, {2}];

checks = <|
   "storedProbePassed" -> (Lookup[probe, "status", "failed"] === "passed"),
   "copiedExistingAnalyticResult" ->
    (Lookup[probe, "sourceMode", "missing"] === "copiedExistingAnalyticReferenceResult"),
   "singleRecordedPoint" ->
    (packagePoint === {ks -> 43/17, P0 -> -29 I/13}),
   "energyDirectionRecorded" ->
    (Lookup[probe, "energyDirectionConvention", "missing"] === "P_pkg == -P_ref"),
   "originalDlogKsRestored" ->
    (Lookup[probe, "physicalDlogExplicitKsDegrees", {}] ===
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0}),
   "matrixDimensions" ->
    (Dimensions[deP0] === {19, 19} && Dimensions[deKs] === {19, 19}),
   "scalingExact" -> (scalingDifference === ConstantArray[0, {19, 19}])
   |>;

failed = Keys@Select[checks, Not@TrueQ[#] &];
Print[InputForm[<|
   "passed" -> Count[Values[checks], True],
   "total" -> Length[checks],
   "failed" -> failed,
   "point" -> packagePoint,
   "nonzeroDifferenceCount" -> Count[Flatten[scalingDifference], Except[0]],
   "checks" -> checks
   |>]];
Exit[If[failed === {}, 0, 1]];
