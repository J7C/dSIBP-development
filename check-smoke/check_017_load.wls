(* ::Package:: *)
(* 017 最小加载检查：只验证标准 Needs 路径、版本号和核心私有定义是否可读。 *)

(* ::Chapter:: *)
(*加载与断言*)

packageDirectory = FileNameJoin[{DirectoryName[DirectoryName[$InputFileName]], "000_code", "017_dSIBP"}];
$Path = Prepend[$Path, packageDirectory];

Needs["dSIBP`"];

checks = <|
   "version" -> (DSPublicAPI[]["version"] === "017"),
   "sectorModel" -> (Length[DownValues[dSIBP`Private`makeSectorMetadata]] > 0),
   "parityModel" -> (Length[DownValues[dSIBP`Private`parityMetadataForSector017]] > 0),
   "publicAPI" -> AssociationQ[DSPublicAPI[]]
   |>;

Print[checks];

If[And @@ Values[checks], Exit[0], Exit[1]];
