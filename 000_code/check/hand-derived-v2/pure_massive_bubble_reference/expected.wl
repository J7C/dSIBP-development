(* ::Package:: *)
(* pure_massive_bubble_reference：由独立手推 helper 生成 expectedRelations。 *)

(* ::Chapter:: *)
(*载入独立 helper 与生成 expected*)

handRootDir = DirectoryName[DirectoryName[$InputFileName]];
Get[FileNameJoin[{handRootDir, "_manual_ibp_engine.wl"}]];

expectedRelations = manualExpectedRelations[pureMassiveBubbleDefinition];

pureMassiveBubbleExpectedCounts = Counts[
   ({#["vertexSigns"], #["sector"]} &) /@ expectedRelations
   ];

pureMassiveBubbleExpectedTotal = Length[expectedRelations];
