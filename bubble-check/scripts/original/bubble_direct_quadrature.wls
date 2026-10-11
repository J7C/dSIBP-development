caseRoot=DirectoryName[DirectoryName[$InputFileName]];
$MaxExtraPrecision=1000;
nu=I/4;x={1,Sqrt[2]};rho=10;c=-I;
f[v_?NumericQ,s_?NumericQ]:=2 (Times@@x)^(-2nu) v^3 s Exp[-rho v(1+s)] Times@@(HankelH1[nu,c # s v]HankelH2[nu,c # v]& /@ x);
{seconds,value}=AbsoluteTiming[NIntegrate[f[v,s],{v,0,1,4,12},{s,0,1},WorkingPrecision->40,AccuracyGoal->18,PrecisionGoal->18,MaxRecursion->18,Method->{"GlobalAdaptive","SymbolicProcessing"->0}]];
Put[<|"method"->"Direct ordered Wick-rotated two-dimensional quadrature, v<=12","rho"->rho,"seconds"->seconds,"pp"->value|>,FileNameJoin[{caseRoot,"results","bubble_direct_quadrature.wl"}]];
Print[InputForm[{seconds,value}]];
