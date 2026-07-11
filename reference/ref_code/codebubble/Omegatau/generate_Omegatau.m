(* ::Package:: *)

(* Dedicated execution entry for symbolic tau-side DE generation. *)

dir = If[StringQ[$InputFileName] && $InputFileName =!= "",
  DirectoryName[DirectoryName[$InputFileName]],
  If[TrueQ[$Notebooks],
    With[{nd = Quiet[Check[NotebookDirectory[], $Failed]]},
      If[StringQ[nd] && nd =!= $Failed, DirectoryName[nd], Directory[]]
    ],
    Directory[]
  ]
];
SetDirectory[dir];

Get[FileNameJoin[{dir, "000_DE_bubble_tau.m"}]];