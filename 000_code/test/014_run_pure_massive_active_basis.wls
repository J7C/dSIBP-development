(* ::Package:: *)
(* ASCII wrapper for a background Wolfram kernel: fix UTF-8 before loading the example. *)

(* ::Chapter:: *)
(*Run*)

$CharacterEncoding = "UTF-8";
projectDir = DirectoryName[DirectoryName[DirectoryName[$InputFileName]]];
exampleFile = FileNameJoin[{
    projectDir,
    "000_code", "examples", "014", "pure_massive_bubble_closed_loop", "main.wl"
    }];
Get[exampleFile];
