(* ::Package:: *)
(* 本脚本把 015 模块化源码按主 loader 的固定顺序拼成独立交付用单文件。
   它不改写模块内容，也不参与运行时物理计算；输出仅用于冻结 package_015.wl。 *)

(* ::Chapter:: *)
(*路径与模块顺序*)

buildDir = DirectoryName[$InputFileName];
packageRoot = DirectoryName[buildDir];
projectRoot = DirectoryName[DirectoryName[packageRoot]];
loaderPath = FileNameJoin[{packageRoot, "Kernel", "dSIBP.wl"}];
outputPath = FileNameJoin[{projectRoot, "independent-benchmark", "package", "package_015.wl"}];

modulePaths = FileNameJoin[Prepend[#, packageRoot]] & /@ {
    {"Kernel", "Core", "LoopCore013.wl"},
    {"Kernel", "Core", "Context.wl"},
    {"Kernel", "Core", "Metadata.wl"},
    {"Kernel", "IBP", "Loop.wl"},
    {"Kernel", "IBP", "Tree.wl"},
    {"Kernel", "Backends", "KiraExport.wl"},
    {"Kernel", "Backends", "KiraImport.wl"},
    {"Kernel", "DE", "BuildDE.wl"},
    {"Kernel", "DE", "Scaling.wl"},
    {"Kernel", "Tree", "VertexFamily.wl"},
    {"Kernel", "Core", "KinematicCoordinates.wl"}
    };


(* ::Chapter:: *)
(*单文件构造与写出*)

loaderSource = Import[loaderPath, "Text"];
firstGet = FirstCase[StringPosition[loaderSource, "\nGet["], {start_, _} :> start, Missing["NoPrivateLoader"]];

If[Head[firstGet] === Missing,
 Print["ERROR: 未找到主 loader 的私有模块加载边界。"];
 Exit[1]
 ];

loaderPrefix = StringTrim[StringTake[loaderSource, firstGet - 1]];
moduleSources = Import[#, "Text"] & /@ modulePaths;

If[! FreeQ[moduleSources, $Failed],
 Print["ERROR: 至少一个 015 模块无法读取。"];
 Exit[1]
 ];

singleFileSource = StringRiffle[
   Join[
    {loaderPrefix, "(* ::Chapter:: *)\n(*冻结单文件私有实现*)"},
    StringTrim /@ moduleSources,
    {"End[];\nEndPackage[];\n"}
    ],
   "\n\n"
   ];

Export[outputPath, singleFileSource, "Text"];

Print["package_015.wl: ", outputPath];
Print["bytes: ", FileByteCount[outputPath]];
Print["modules: ", Length[modulePaths]];
