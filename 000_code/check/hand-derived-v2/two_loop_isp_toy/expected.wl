(* ::Package:: *)
(* two_loop_isp_toy：由独立手推 helper 生成 expectedRelations。 *)

(* ::Chapter:: *)
(*载入独立 helper 与生成 expected*)

handRootDir = DirectoryName[DirectoryName[$InputFileName]];
Get[FileNameJoin[{handRootDir, "_manual_ibp_engine.wl"}]];

expectedRelations = manualExpectedRelations[twoLoopISPDefinition];

twoLoopISPExpectedCounts = Counts[
   ({#["vertexSigns"], #["sector"]} &) /@ expectedRelations
   ];

twoLoopISPExpectedTotal = Length[expectedRelations];
