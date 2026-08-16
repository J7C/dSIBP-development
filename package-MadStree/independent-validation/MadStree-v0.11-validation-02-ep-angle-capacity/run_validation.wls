(* ::Package:: *)

(***
File: run_validation.wls
Purpose: ASCII bootstrap that loads the validation body with explicit UTF-8 decoding.
***)

(* ::Chapter:: *)
(* UTF-8 bootstrap *)

Get[
  FileNameJoin[{DirectoryName[$InputFileName], "run_validation_main.wl"}],
  CharacterEncoding -> "UTF-8"
];
