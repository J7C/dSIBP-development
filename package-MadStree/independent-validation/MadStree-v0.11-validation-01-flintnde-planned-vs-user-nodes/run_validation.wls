(* ::Package:: *)

(***
File: run_validation.wls
Purpose: ASCII bootstrap. WolframScript keeps the ordinary command while the
         validation body is decoded explicitly as UTF-8.
***)

(* ::Chapter:: *)
(* UTF-8 bootstrap *)

Get[
  FileNameJoin[{DirectoryName[$InputFileName], "run_validation_main.wl"}],
  CharacterEncoding -> "UTF-8"
];
