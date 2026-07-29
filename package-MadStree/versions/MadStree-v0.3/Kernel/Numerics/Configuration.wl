(* ::Package:: *)

(***
文件：Configuration.wl
用途：集中解析 MadStree 版本目录、项目根目录及 FlintNDE Python package 的相对位置。
约定：$MSFlintNDERelativePath 是唯一可修改的后端目录变量；其值始终相对仓库根目录，
      公开函数和适配器不得在函数体中另写 000_FlintNDE 的硬编码路径。
***)

(* ::Chapter:: *)
(*相对路径配置*)

$MadStreePackageDirectory = DirectoryName[$MadStreeKernelDirectory];
$MadStreeCollectionDirectory = DirectoryName[DirectoryName[$MadStreePackageDirectory]];
$MadStreeProjectDirectory = DirectoryName[$MadStreeCollectionDirectory];
$MSFlintNDERelativePath = FileNameJoin[{"000_FlintNDE", "code", "package"}];


(* ::Section:: *)
(*路径验证与公开查询*)

(* 只接受普通相对路径，避免配置意外逃离用户指定的项目根目录。 *)
msRelativePathQ[path_String] := ! AnyTrue[{"/", "\\"}, StringStartsQ[path, #] &] &&
  FreeQ[FileNameSplit[path], ".."] && ! StringMatchQ[path, LetterCharacter ~~ ":" ~~ ___];

msResolvedFlintNDEPath[] := ExpandFileName[
  FileNameJoin[{$MadStreeProjectDirectory, $MSFlintNDERelativePath}]
];

MSFlintNDEConfiguration[] := Module[{resolved = msResolvedFlintNDEPath[]},
  <|
    "version" -> $MadStreeVersion,
    "versionDirectory" -> $MadStreePackageDirectory,
    "collectionDirectory" -> $MadStreeCollectionDirectory,
    "projectDirectory" -> $MadStreeProjectDirectory,
    "relativePath" -> $MSFlintNDERelativePath,
    "resolvedPath" -> resolved,
    "packageFile" -> FileNameJoin[{resolved, "flintnde", "__init__.py"}],
    "availableQ" -> FileExistsQ[FileNameJoin[{resolved, "flintnde", "__init__.py"}]]
  |>
];

(* 修改后立即验证；失败时保留原配置，不产生半更新状态。 *)
MSSetFlintNDERelativePath[path_String] := Module[{old = $MSFlintNDERelativePath, candidate},
  If[! msRelativePathQ[path],
    Return[Failure["RelativeFlintNDEPathRequired", <|"path" -> path|>]]
  ];
  candidate = ExpandFileName[FileNameJoin[{$MadStreeProjectDirectory, path, "flintnde", "__init__.py"}]];
  If[! FileExistsQ[candidate],
    Return[Failure["FlintNDEPackageNotFound", <|"path" -> path, "packageFile" -> candidate|>]]
  ];
  $MSFlintNDERelativePath = path;
  If[TrueQ[MSFlintNDEConfiguration[]["availableQ"]],
    MSFlintNDEConfiguration[],
    $MSFlintNDERelativePath = old;
    Failure["FlintNDEConfigurationFailed", <|"path" -> path|>]
  ]
];

MSSetFlintNDERelativePath[other_] := Failure[
  "RelativeFlintNDEPathRequired",
  <|"path" -> HoldForm[other]|>
];
