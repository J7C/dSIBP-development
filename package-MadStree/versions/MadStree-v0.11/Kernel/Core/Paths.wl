(* ::Package:: *)

(***
File: Paths.wl
Purpose: Centralizes calling-directory resolution, absolute-path detection and controlled directory creation, shared by Artifacts.wl and FlintNDE.wl; each consumer keeps its own resolver for the Automatic semantics.
Conventions: This module depends only on System` and references no other MadStree internal symbols.
***)

(* ::Chapter:: *)
(* Calling-directory resolution *)

msRuntimeDirectory[] := Module[{inputFile = $InputFileName, notebookDirectory},
  If[StringQ[inputFile] && inputFile =!= "",
    Return[DirectoryName[ExpandFileName[inputFile]]]
  ];
  notebookDirectory = Quiet@Check[NotebookDirectory[], $Failed];
  If[StringQ[notebookDirectory], ExpandFileName[notebookDirectory], Directory[]]
];


(* ::Section:: *)
(* Absolute-path detection *)

(* Absolute paths are expanded directly; relative paths are always resolved against the calling script directory to avoid depending on the current process directory. *)
msAbsolutePathQ[path_String] := StringMatchQ[
  StringReplace[path, "\\" -> "/"],
  Alternatives[LetterCharacter ~~ ":/" ~~ ___, "/" ~~ ___]
];


(* ::Section:: *)
(* Controlled directory creation *)

(* Returns the directory path on success and $Failed on failure; the caller decides the Failure tag and diagnostic fields. *)
msEnsureDirectory[path_String] := If[
  DirectoryQ[path],
  path,
  Quiet@Check[
    CreateDirectory[path, CreateIntermediateDirectories -> True],
    $Failed
  ]
];
