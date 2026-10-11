# 运行提交下的代码原文

提交 `7dfd3c4afad4dd29ccae744f606a784121a90619`。只读节录，未修改代码。完整文件及哈希另附。

## MadStree/Kernel/Numerics/Boundary.wl L249-L302

```text
249: msPaperC[nu_] := 2^(-nu) Gamma[-nu]/(I Pi);
250: 
251: (* Returns the two endpoint branch coefficients of h=z^(+/-nu) H_nu; bit=0/1 corresponds to the MadStree state. *)
252: msVertexEndpointCoefficient["Negative", 1, 0, nu_] := Exp[-I Pi nu] msPaperC[nu];
253: msVertexEndpointCoefficient["Negative", 1, 1, nu_] := -msPaperC[-nu - 1];
254: msVertexEndpointCoefficient["Negative", 2, 0, nu_] := -Exp[I Pi nu] msPaperC[nu];
255: msVertexEndpointCoefficient["Negative", 2, 1, nu_] := msPaperC[-nu - 1];
256: msVertexEndpointCoefficient["Positive", 1, 0, nu_] := msPaperC[-nu];
257: msVertexEndpointCoefficient["Positive", 1, 1, nu_] := 2 nu Exp[-I Pi nu] msPaperC[nu];
258: msVertexEndpointCoefficient["Positive", 2, 0, nu_] := -msPaperC[-nu];
259: msVertexEndpointCoefficient["Positive", 2, 1, nu_] := -2 nu Exp[I Pi nu] msPaperC[nu];
260: 
261: 
262: (* ::Chapter:: *)
263: (* Frobenius leading system of an arbitrary sector DAG *)
264: 
265: (* The Hankel branches of a full propagator are determined only by the SK type and the strict time rank. *)
266: msBoundaryFullBranches["++", firstDominantQ_] := If[firstDominantQ, {1, 2}, {2, 1}];
267: msBoundaryFullBranches["--", firstDominantQ_] := If[firstDominantQ, {2, 1}, {1, 2}];
268: 
269: 
270: msBoundaryComponentRank[sector_Association, componentPosition_Integer, rank_Association] := Min[
271:   rank /@ sector["vertexComponents"][[componentPosition]]
272: ];
273: 
274: 
275: (* Given an endpoint slot, returns the Hankel branch fixed at initialization or by the strict rank. *)
276: msBoundaryHankelBranch[
277:   slot_Association,
278:   sector_Association,
279:   rank_Association,
280:   context_?MSContextQ
281: ] := Module[{line, endpointComponents, firstDominantQ, branches},
282:   line = msLineById[context, slot["lineId"]];
283:   Switch[line["type"],
284:     "massiveExternal",
285:       First[line["hankelBranches"]],
286:     "massiveCross",
287:       line["hankelBranches"][[slot["endpointIndex"]]],
288:     "massiveFull" | "masslessFull",
289:       endpointComponents = sector["rootToComponent"] /@ line["endpoints"];
290:       firstDominantQ = If[
291:         SameQ @@ endpointComponents,
292:         True,
293:         msBoundaryComponentRank[sector, First[endpointComponents], rank] <
294:           msBoundaryComponentRank[sector, Last[endpointComponents], rank]
295:       ];
296:       branches = msBoundaryFullBranches[line["contourType"], firstDominantQ];
297:       branches[[slot["endpointIndex"]]],
298:     _,
299:       Missing["NoHankelBranch", slot["key"]]
300:   ]
301: ];
302: 
```

## MadStree/Kernel/Numerics/Boundary.wl L440-L559

```text
440: msGenericSectorLeadingRecord[
441:   context_?MSContextQ,
442:   sector_Association,
443:   stateBits_List,
444:   globalIndex_Integer,
445:   targetRules_List,
446:   curveData_Association,
447:   workingPrecision_Integer
448: ] := Module[
449:   {rank, parameter, vertexCount, componentRecords, hSlots, timePower, alpha,
450:    componentRank, weight, energyExpression, energyConstant, endpointFactor, slotBit,
451:      line, momentum, physicalNu, formulaNu, branch, sharedFactor, coefficient, exponent,
452:      componentFailure},
453:   rank = curveData["rank"];
454:   parameter = curveData["parameter"];
455:   vertexCount = Length[context["vertices"]];
456:   componentRecords = Table[
457:     hSlots = msHankelSlotsAtComponent[sector, componentPosition];
458:     timePower = sector["baseTimePowers"][[componentPosition]] /. targetRules;
459:     alpha = Simplify[
460:       timePower + 1 - Total[
461:         Function[slot,
462:           slotBit = stateBits[[slot["slotPosition"]]];
463:           slotBit (1 - 2 (slot["formulaNu"] /. targetRules))
464:         ] /@ hSlots
465:       ]
466:     ];
467:     componentFailure = If[msBoundaryGammaPoleQ[alpha],
468:       msFailure[
469:         "BoundaryGammaPole",
470:         <|
471:           "sectorKey" -> sector["sectorKey"],
472:           "stateBits" -> stateBits,
473:           "componentPosition" -> componentPosition,
474:           "gammaArgument" -> alpha
475:         |>
476:       ],
477:       None
478:     ];
479:     If[Head[componentFailure] === Failure,
480:       componentFailure,
481:       componentRank = msBoundaryComponentRank[sector, componentPosition, rank];
482:       weight = vertexCount - componentRank + 1;
483:       energyExpression = Together[
484:         sector["componentEnergies"][[componentPosition]] /.
485:           curveData["curveRules"] /. curveData["retainedRules"]
486:       ];
487:       energyConstant = Together[Limit[parameter^weight energyExpression, parameter -> 0]];
488:       If[TrueQ[PossibleZeroQ[energyConstant]],
489:         msFailure[
490:           "VanishingComponentBoundaryEnergy",
491:           <|"sectorKey" -> sector["sectorKey"], "componentPosition" -> componentPosition|>
492:         ],
493:         endpointFactor = Times @@ Map[
494:           Function[slot,
495:             slotBit = stateBits[[slot["slotPosition"]]];
496:             line = msLineById[context, slot["lineId"]];
497:             momentum = line["momentum"] /. targetRules;
498:             physicalNu = line["nu"] /. targetRules;
499:             formulaNu = line["formulaNu"] /. targetRules;
500:             branch = msBoundaryHankelBranch[slot, sector, rank, context];
501:             (-I momentum)^(-slotBit (1 - 2 formulaNu))
502:               msVertexEndpointCoefficient[
503:                 context["convention", "nuConvention"], branch, slotBit, physicalNu
504:               ]
505:           ],
506:           hSlots
507:         ];
508:         <|
509:           "componentPosition" -> componentPosition,
510:           "timePower" -> timePower,
511:           "frobeniusPower" -> alpha,
512:           "gammaArgument" -> alpha,
513:           "rankWeight" -> weight,
514:           "energyLeadingConstant" -> energyConstant,
515:           "coefficient" -> Simplify[
516:             (-I)^(timePower + 1) Gamma[alpha] endpointFactor
517:           ],
518:           "anchorFactor" -> Simplify[energyConstant^-alpha]
519:         |>
520:       ]
521:     ],
522:     {componentPosition, Length[sector["vertexComponents"]]}
523:   ];
524:   If[Head[componentRecords] === Failure || MemberQ[componentRecords, _Failure],
525:     Return[FirstCase[componentRecords, _Failure, componentRecords]]
526:   ];
527:   sharedFactor = Times @@ MapIndexed[
528:     Function[{slot, position},
529:       If[
530:         slot["kind"] === "masslessShared",
531:         msBoundaryMasslessSharedFactor[
532:           slot, stateBits[[First[position]]], sector, rank, context
533:         ],
534:         1
535:       ]
536:     ],
537:     sector["slots"]
538:   ];
539:   coefficient = Simplify[
540:     (sector["normalization"] /. targetRules)
541:       sharedFactor Times @@ Lookup[componentRecords, "coefficient"]
542:   ];
543:   exponent = Simplify[Total[
544:     Lookup[componentRecords, "rankWeight"] Lookup[componentRecords, "frobeniusPower"]
545:   ]];
546:   <|
547:     "kind" -> "genericSectorDefinitionBranch",
548:     "sectorKey" -> sector["sectorKey"],
549:     "binaryState" -> stateBits,
550:     "rootGlobalIndex" -> globalIndex,
551:     "componentData" -> componentRecords,
552:     "frobeniusExponent" -> exponent,
553:     "logPower" -> 0,
554:     "coefficient" -> coefficient,
555:     "physicalWeight" -> Simplify[
556:       coefficient Times @@ Lookup[componentRecords, "anchorFactor"]
557:     ]
558:   |>
559: ];
```

## MadStree/Kernel/Core/Sectors.wl L154-L214

```text
154:    rawVector=S.canonicalVector，canonicalVector=P.rawVector。massless shared 奇态为零；
155:    massive Full 的 10 依现行约定 canonicalize 为 01。 *)
156: msSectorCanonicalStateData[sector_Association] := Module[
157:   {rawStates, slots, activeLines, rootToComponent, constraints, canonicalize,
158:    images, canonicalStates, canonicalIndex, embedding, projection, mapped, row, column},
159:   slots = sector["slots"];
160:   rawStates = msStateList[Length[slots]];
161:   activeLines = sector["activeLines"];
162:   rootToComponent = sector["rootToComponent"];
163:   constraints = Select[
164:     activeLines,
165:     msFullLineQ[#] && SameQ @@ (rootToComponent /@ #["endpoints"]) &
166:   ];
167:   canonicalize[bits_List] := Module[{result = bits, positions, zeroQ = False, invalidQ = False},
168:     Do[
169:       Switch[line["type"],
170:         "masslessFull",
171:           positions = msSlotPositionByKey[sector, {line["id"], "shared"}];
172:           If[
173:             Head[positions] === Missing,
174:             invalidQ = True,
175:             If[result[[First[positions]]] === 1, zeroQ = True]
176:           ],
177:         "massiveFull",
178:           positions = (msSlotPositionByKey[sector, {line["id"], #}] &) /@ {1, 2};
179:           If[
180:             MemberQ[positions, _Missing, Infinity],
181:             invalidQ = True,
182:             positions = First /@ positions;
183:             If[result[[positions]] === {1, 0}, result = ReplacePart[result, Thread[positions -> {0, 1}]]]
184:           ]
185:       ],
186:       {line, constraints}
187:     ];
188:     Which[invalidQ, Missing["MissingCoincidentSlots"], zeroQ, Missing["ZeroCoincidentState"], True, result]
189:   ];
190:   images = canonicalize /@ rawStates;
191:   canonicalStates = DeleteDuplicates[DeleteCases[images, _Missing]];
192:   canonicalIndex = AssociationThread[ToString[#, InputForm] & /@ canonicalStates, Range[Length[canonicalStates]]];
193:   embedding = ConstantArray[0, {Length[rawStates], Length[canonicalStates]}];
194:   Do[
195:     mapped = images[[row]];
196:     If[Head[mapped] =!= Missing,
197:       column = canonicalIndex[ToString[mapped, InputForm]];
198:       embedding[[row, column]] = 1
199:     ],
200:     {row, Length[rawStates]}
201:   ];
202:   projection = ConstantArray[0, {Length[canonicalStates], Length[rawStates]}];
203:   Do[
204:     row = First@FirstPosition[rawStates, canonicalStates[[column]]];
205:     projection[[column, row]] = 1,
206:     {column, Length[canonicalStates]}
207:   ];
208:   <|
209:     "rawStateOrder" -> rawStates,
210:     "stateOrder" -> canonicalStates,
211:     "stateEmbedding" -> embedding,
212:     "stateProjection" -> projection,
213:     "coincidentLineIds" -> Lookup[constraints, "id", {}],
214:     "quotientCertifiedQ" -> TrueQ[Simplify[projection.embedding] === IdentityMatrix[Length[canonicalStates]]]
```

## MadStree/Kernel/Numerics/PathEvaluation.wl L327-L368

```text
327:     "userIndices" -> points[[All, "userIndex"]]
328:   |>
329: ];
330: 
331: 
332: (* ::Chapter:: *)
333: (*边界与后端请求*)
334: 
335: msEvaluationBoundaryInput[boundary_Association, de_Association, digits_Integer] := Module[
336:   {parameter, matrix, branches, weights},
337:   If[Lookup[boundary, "boundaryKind", "finiteFrobeniusSeries"] =!= "singularFrobenius",
338:     If[! ListQ[Lookup[boundary, "values", None]] ||
339:        Length[boundary["values"]] =!= de["masterCount"],
340:       Return[msFailure["BoundaryVectorDimension", <|"expected" -> de["masterCount"]|>]]
341:     ];
342:     Return[<|
343:       "kind" -> "finite",
344:       "values" -> (msComplexDecimalRecord[#, digits] & /@ boundary["values"])
345:     |>]
346:   ];
347:   parameter = boundary["singularParameter"];
348:   matrix = msRationalMatrixRecords[boundary["singularConnection"], parameter];
349:   branches = msFrobeniusBranchRecord /@ boundary["leadingBranches"];
350:   weights = msComplexDecimalRecord[#, digits] & /@
351:     N[Lookup[boundary["leadingBranches"], "physicalWeight"], digits];
352:   If[matrix === $Failed || MemberQ[branches, $Failed],
353:     Return[msFailure[
354:       "FlintNDEExactFrobeniusBoundaryRequired",
355:       <|"reason" -> "singular connection and branch data must lie in Q(i)(t)"|>
356:     ]]
357:   ];
358:   <|
359:     "kind" -> "regular_singular",
360:     "variable" -> "t",
361:     "matrix" -> matrix,
362:     "branches" -> branches,
363:     "weights" -> weights,
364:     "start" -> "0",
365:     "target" -> "1"
366:   |>
367: ];
368: 
```

## MadStree/Kernel/Numerics/PathEvaluation.wl L523-L550

```text
523:   pythonExecutable = msResolvePythonExecutable[OptionValue[PythonExecutable]];
524:   boundaryInput = msEvaluationBoundaryInput[boundary, de, digits];
525:   If[Head[boundaryInput] === Failure, Return[boundaryInput]];
526:   segmentInputs = <|
527:     "start" -> "0",
528:     "points" -> #["pointParameters"],
529:     "letters" -> #["letters"],
530:     "fromUserIndex" -> #["fromUserIndex"],
531:     "userIndices" -> #["userIndices"]
532:   |> & /@ segments;
533:   inputData = <|
534:     "schema" -> "madstree_flintnde_evaluate_v1",
535:     "backendPackagePath" -> configuration["resolvedPath"],
536:     "masterDigest" -> de["masterDigest"],
537:     "dimension" -> de["masterCount"],
538:     "segments" -> segmentInputs,
539:     "pathPlanning" -> planningQ,
540:     "singularityMode" -> If[! planningQ, "avoid", msBackendSingularityMode[singularityMode]],
541:     "boundary" -> boundaryInput,
542:     "workingPrecisionDigits" -> digits,
543:     "primaryOrder" -> OptionValue[TransportOrder],
544:     "referenceOrder" -> OptionValue[ReferenceTransportOrder],
545:     "targetRelativeError" -> ToString[OptionValue[TargetRelativeError]],
546:     "certificationMode" -> "embedded",
547:     "messageLanguage" -> messageLanguage,
548:     "columnVectorConvention" -> "Y'=A(s)Y",
549:     "dlogStatus" -> de["dlogStatus"]
550:   |>;
```

## MadStree/Kernel/Numerics/FlintNDE.wl L365-L390

```text
365:   If[MemberQ[{"singularPathRefused", "leadingOrderRefused"}, Lookup[imported, "status", None]],
366:     Quiet[DeleteFile /@ Select[{inputFile, logFile}, FileExistsQ]];
367:     Return[Join[imported, <|"cacheHit" -> False, "cacheDirectory" -> cacheDirectory|>]]
368:   ];
369:   If[process["ExitCode"] =!= 0 || Lookup[imported, "status", None] =!= "success",
370:     Message[MSEvaluatePath::backendRunFailed, pythonExecutable, Lookup[imported, "error", logTail]];
371:     Return[msFailure["FlintNDEProcessFailed", <|"process" -> process, "backend" -> imported, "stderr" -> logTail|>]]
372:   ];
373:   Quiet[DeleteFile /@ Select[{inputFile, logFile}, FileExistsQ]];
374:   Join[imported, <|"cacheHit" -> False, "cacheDirectory" -> cacheDirectory,
375:     "process" -> KeyDrop[process, {"inputFile", "cacheFile"}]|>]
376: ];
377: 
378: 
379: (* Writes one exact normalized leading branch as the FlintNDE {a,b,C} contract. *)
380: msFrobeniusBranchRecord[branch_Association] := Module[{exponent, vector},
381:   exponent = msGaussianRationalString[branch["frobeniusExponent"]];
382:   vector = msGaussianRationalString /@ branch["normalizedLeadingVector"];
383:   If[exponent === $Failed || MemberQ[vector, $Failed], Return[$Failed]];
384:   <|
385:     "a" -> exponent,
386:     "b" -> branch["logPower"],
387:     "C" -> vector
388:   |>
389: ];
390: 
```

## MadStree/Backend/flintnde_transport.py L340-L382

```text
340:     from flintnde import (
341:         NamedPoint, build_adaptive_path, frobenius_boundary,
342:         gaussian_rational, transport_frobenius_boundaries_refined,
343:     )
344: 
345:     boundary = data["boundary"]
346:     dimension = data["dimension"]
347:     if boundary["kind"] == "finite":
348:         vector = acb_mat([[acb(item["real"], item["imag"])] for item in boundary["values"]])
349:         return vector, None, {"kind": "finite", "path": [], "seconds": 0.0}
350:     system = _rational_system(boundary, dimension, data["masterDigest"] + "-boundary")
351:     start = gaussian_rational(boundary["start"]).to_acb()
352:     target = gaussian_rational(boundary["target"]).to_acb()
353:     path = build_adaptive_path(
354:         system, NamedPoint("madstree_boundary", start), NamedPoint("madstree_anchor", target),
355:         path_name="madstree_boundary_to_anchor", max_step_over_radius=0.45,
356:         singularity_mode="avoid", message_language=data["messageLanguage"],
357:     )
358:     branches = [frobenius_boundary([record]) for record in boundary["branches"]]
359:     clock = time.perf_counter()
360:     with warnings.catch_warnings(record=True) as caught:
361:         warnings.simplefilter("always")
362:         result = transport_frobenius_boundaries_refined(
363:             system, branches, path,
364:             primary_order=data["primaryOrder"], reference_order=data["referenceOrder"],
365:             radius_fraction=0.60, target_relative_error=data["targetRelativeError"],
366:             certification_mode=data["certificationMode"],
367:         )
368:     weights = [acb(item["real"], item["imag"]) for item in boundary["weights"]]
369: 
370:     def weighted_vector(matrix: Any) -> Any:
371:         """按同一物理边界权重合并一条输运链的基解矩阵。"""
372: 
373:         vector = acb_mat(dimension, 1)
374:         for row in range(dimension):
375:             vector[row, 0] = sum(
376:                 (weights[column] * matrix[row, column] for column in range(len(weights))),
377:                 acb(0),
378:             )
379:         return vector
380: 
381:     primary_vector = weighted_vector(result["primary_snapshots"][-1])
382:     reference_vector = weighted_vector(result["reference_snapshots"][-1])
```
