(* ::Package:: *)

(* ASCII loader: locate Kernel/init.m without changing the working directory. *)
Get[FileNameJoin[{DirectoryName[$InputFileName], "Kernel", "init.m"}], CharacterEncoding -> "UTF-8"];
