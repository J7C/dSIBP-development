(* ::Package:: *)

(***
File: run_validation.wls
Purpose: ASCII bootstrap for a UTF-8 Wolfram validation script. The user-facing
         command remains wolframscript -file run_validation.wls.
***)

(* ::Chapter:: *)
(* UTF-8 bootstrap *)

Get[
  FileNameJoin[{DirectoryName[$InputFileName], "run_validation_main.wl"}],
  CharacterEncoding -> "UTF-8"
];
