(* ::Package:: *)
(* 本脚本把 019 模块化源码按主 loader 的固定顺序拼成独立单文件。
   它不改写模块内容，也不参与运行时物理计算；可用 DSIBP_BUILD_OUTPUT 先生成候选测试版，
   未设置该变量时写入项目规定的候选测试目录。 *)

(* ::Chapter:: *)
(*路径与模块顺序*)

buildDir = DirectoryName[$InputFileName];
packageRoot = DirectoryName[buildDir];
projectRoot = DirectoryName[DirectoryName[packageRoot]];
loaderPath = FileNameJoin[{packageRoot, "Kernel", "dSIBP.wl"}];
defaultOutputPath = FileNameJoin[{projectRoot, "test", "results_test", "package_019.0.wl"}];
outputOverride = Quiet[Environment["DSIBP_BUILD_OUTPUT"]];
outputPath = If[
   StringQ[outputOverride] && StringLength[StringTrim[outputOverride]] > 0,
   ExpandFileName[outputOverride],
   defaultOutputPath
   ];

modulePaths = FileNameJoin[Prepend[#, packageRoot]] & /@ {
    {"Kernel", "Core", "TopologyKinematics018.wl"},
    {"Kernel", "Core", "LoopCore013.wl"},
    {"Kernel", "Core", "Context.wl"},
    {"Kernel", "Core", "Metadata.wl"},
    {"Kernel", "IBP", "Loop.wl"},
    {"Kernel", "IBP", "Tree.wl"},
    {"Kernel", "IBP", "PureTime018.wl"},
    {"Kernel", "IBP", "GenerateIBP.wl"},
    {"Kernel", "Backends", "KiraExport.wl"},
    {"Kernel", "Backends", "UserMI.wl"},
    {"Kernel", "Backends", "KiraPlan.wl"},
    {"Kernel", "Backends", "KiraImport.wl"},
    {"Kernel", "DE", "BuildDE.wl"},
    {"Kernel", "DE", "Scaling.wl"},
    {"Kernel", "Tree", "VertexFamily.wl"},
    {"Kernel", "Core", "KinematicCoordinates.wl"},
    {"Kernel", "Core", "SectorModel018.wl"},
    {"Kernel", "Core", "RelationsParity018.wl"},
    {"Kernel", "Core", "ParameterInterface018.wl"},
    {"Kernel", "Tree", "PublicBoundary018.wl"},
    {"Kernel", "Core", "BilingualMessages.wl"}
    };


(* ::Chapter:: *)
(*单文件构造与写出*)

(* 冻结交付件使用 UTF-8 BOM 与 LF；BOM 保证 Windows WolframScript 直接 Get 时正确识别中文源码。 *)
writeUTF8LFText[path_String, text_String] := Module[{stream, normalized, bytes},
   normalized = StringReplace[text, {"\r\n" -> "\n", "\r" -> "\n"}];
   bytes = Join[{239, 187, 191}, ToCharacterCode[normalized, "UTF8"]];
   stream = OpenWrite[path, BinaryFormat -> True];
   BinaryWrite[stream, bytes, "Byte"];
   Close[stream];
   path
   ];


loaderSource = Import[loaderPath, "Text", CharacterEncoding -> "UTF-8"];
firstGet = FirstCase[StringPosition[loaderSource, "\nGet["], {start_, _} :> start, Missing["NoPrivateLoader"]];

If[Head[firstGet] === Missing,
 Print["ERROR: 未找到主 loader 的私有模块加载边界。"];
 Exit[1]
 ];

loaderPrefix = StringTrim[StringTake[loaderSource, firstGet - 1]];
moduleSources = Import[#, "Text", CharacterEncoding -> "UTF-8"] & /@ modulePaths;

If[! FreeQ[moduleSources, $Failed],
 Print["ERROR: 至少一个 019 模块无法读取。"];
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

If[! DirectoryQ[DirectoryName[outputPath]],
 CreateDirectory[DirectoryName[outputPath], CreateIntermediateDirectories -> True]
 ];

writeUTF8LFText[outputPath, singleFileSource];

Print["package_019.0.wl: ", outputPath];
Print["bytes: ", FileByteCount[outputPath]];
Print["modules: ", Length[modulePaths]];
