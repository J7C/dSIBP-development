(* ::Package:: *)
(* 本文件验证 007 标量积坐标规则缓存。检查只使用 mixed bubble 的 2x2 线性坐标系，
   不生成大范围 seed，也不运行 Kira；目标是证明缓存不改变规则并可跨 shrink sector 复用。 *)


(* ::Chapter:: *)
(*环境与主线加载*)

SetDirectory[FileNameJoin[{DirectoryName[$InputFileName], "..", ".."}]];

Get["000_code/007_dS_ibp_general.wl"];


(* ::Chapter:: *)
(*缓存等价性与隔离性检查*)

(* 同一动量坐标系只产生一个缓存条目；改变传播子动量路由后必须产生新条目。 *)
cacheTopo = parseTopology[mixedBubbleCase];
cacheShrunkTopo = shrinkSectorTopology[cacheTopo, {1}];

cacheAlteredLineData = ReplacePart[
   mixedBubbleCase["lineData"],
   2 -> Join[mixedBubbleCase["lineData"][[2]], <|"momentum" -> q1 + k|>]
   ];
cacheAlteredTopo = parseTopology[
   Join[mixedBubbleCase, <|"name" -> "mixedBubbleAlteredRouting", "lineData" -> cacheAlteredLineData|>]
   ];

clearScalarProductRuleCache[];
cacheCountAtStart = scalarProductRuleCacheReport[]["entryCount"];

cacheUncachedRules = makeScalarProductRulesUncached[cacheTopo];
cacheFirstRules = makeScalarProductRules[cacheTopo];
cacheCountAfterFirst = scalarProductRuleCacheReport[]["entryCount"];

cacheSecondRules = makeScalarProductRules[cacheTopo];
cacheCountAfterSecond = scalarProductRuleCacheReport[]["entryCount"];

cacheShrunkRules = makeScalarProductRules[cacheShrunkTopo];
cacheCountAfterShrink = scalarProductRuleCacheReport[]["entryCount"];

cacheAlteredRules = makeScalarProductRules[cacheAlteredTopo];
cacheCountAfterAltered = scalarProductRuleCacheReport[]["entryCount"];

cacheCheckResults = <|
   "startsEmpty" -> TrueQ[cacheCountAtStart === 0],
   "cachedEqualsUncached" -> TrueQ[cacheFirstRules === cacheUncachedRules],
   "firstCallAddsOneEntry" -> TrueQ[cacheCountAfterFirst === 1],
   "repeatCallReusesEntry" -> TrueQ[cacheSecondRules === cacheFirstRules && cacheCountAfterSecond === 1],
   "shrinkSectorReusesEntry" -> TrueQ[cacheShrunkRules === cacheFirstRules && cacheCountAfterShrink === 1],
   "changedRoutingAddsEntry" -> TrueQ[cacheCountAfterAltered === 2],
   "changedRoutingHasDifferentRules" -> TrueQ[cacheAlteredRules["repSP2Z"] =!= cacheFirstRules["repSP2Z"]]
   |>;

clearScalarProductRuleCache[];
cacheCheckResults["clearResetsCache"] = TrueQ[scalarProductRuleCacheReport[]["entryCount"] === 0];

cacheCheckSummary = <|
   "checkedCount" -> Length[cacheCheckResults],
   "passedCount" -> Count[Values[cacheCheckResults], True],
   "failedNames" -> Keys@Select[cacheCheckResults, ! TrueQ[#] &]
   |>;

Print[cacheCheckSummary];

If[And @@ Values[cacheCheckResults], Exit[0], Print[cacheCheckResults]; Exit[1]];