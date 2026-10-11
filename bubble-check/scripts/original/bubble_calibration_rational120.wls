caseRoot=DirectoryName[DirectoryName[$InputFileName]];
AppendTo[$Path,FileNameJoin[{caseRoot,"sources","dSIBP-Packages","MadStree"}]];Needs["MadStree`"];
out=FileNameJoin[{caseRoot,"results","bubble_calibration_rational120"}];If[!DirectoryQ[out],CreateDirectory[out]];
Do[
 signs=pair;label=StringJoin[If[#==1,"p","m"]& /@ signs];
 ctx=MSInitTimeGraph[<|"vertices"->{<|"id"->1,"externalLegEnergy"->k1,"timePower"->a1,"vertexType"->If[signs[[1]]==1,"+","-"]|>,<|"id"->2,"externalLegEnergy"->k2,"timePower"->a2,"vertexType"->If[signs[[2]]==1,"+","-"]|>},"lines"->{<|"type"->"massive","endpoints"->{1,2},"momentum"->x1,"nu"->I/4|>,<|"type"->"massive","endpoints"->{1,2},"momentum"->x2,"nu"->I/4|>}|>,NuConvention->"Negative"];
 Put[<|"context"->ctx,"masters"->MSMasterIntegrals[ctx],"de"->MSDLogDE[ctx],"contactMaps"->MSContactMaps[ctx]|>,FileNameJoin[{out,label<>"_formula.wl"}]];
 Print[label," DIMENSION ",Length[MSMasterIntegrals[ctx]]];
 {seconds,r}=AbsoluteTiming[MSEvaluatePath[ctx,{{k1,k2},{-10,-10},{-5,-5},{-14/5,-14/5}},ParameterRules->{x1->1,x2->Rationalize[N[Sqrt[2],120],0],a1->1+I/2,a2->1+I/2},WorkingPrecision->80,TransportOrder->80,ReferenceTransportOrder->96,BoundarySeriesOrder->17,TargetRelativeError->"1e-32",BoundaryScale->4,RankOrder->{1,2},SingularityMode->"Avoid",MSRuntimeDirectory->FileNameJoin[{out,label<>"_runtime"}]]];
 Put[<|"seconds"->seconds,"result"->r|>,FileNameJoin[{out,label<>"_result.wl"}]];
 Print[label," STATUS ",If[AssociationQ[r],Lookup[r,"status"],InputForm[r]]," SECONDS ",seconds];
 If[AssociationQ[r]&&KeyExistsQ[r,"pointResults"],MSExportEvaluationData[r,SignificantDigits->70,MSOutputDirectory->FileNameJoin[{out,label<>"_export"}]]];
 ,{pair,{{1,1},{1,-1},{-1,1},{-1,-1}}}];

