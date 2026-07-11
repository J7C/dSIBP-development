(* ::Package:: *)

(* 
   verify_omega_R1.m
   独立验证脚本：核对 codeR1/OmegaR/OmegaR1.m 中的 OmegaRaw 与 
   noteppmassive/main.pdf (Eq 72-79) 中的公式是否一致。
   
   修正：
   1. 变量名移除下划线 (Mathematica 中 _ 是保留字符)。
   2. 修正目录设置。
*)

(* ========================================================================= *)
(* 1. 手工抄录 PDF 公式 (Definitions from main.tex Eq 826-834)               *)
(* ========================================================================= *)

(* 基础矩阵定义 *)
s0 = {{1,0},{0,1}};
s1 = {{0,1},{1,0}};
s2 = {{0,-I},{I,0}};
s3 = {{1,0},{0,-1}};

Id2 = s0;
Id4 = IdentityMatrix[4];

(* 
   辅助函数：KroneckerProduct 简写 
*)
KP[a_, b_] := KroneckerProduct[a, b];

(* 
   抄录 Omega_{P0} (Eq 826-829)
*)
OmegaP0PDF = ((-a0 + 2*nu)/2) * Id4 - 
              ((1 + 2*nu)/4) * (KP[s3, Id2] + KP[Id2, s3]) + 
              (I*(1 + 2*nu)/4) * (KP[s1, s2] + KP[s2, s1]) + 
              ((a0 - 2*nu)/2) * KP[s2, s2];

(* 
   抄录 Omega_{x2} (Eq 830)
*)
Omegax2PDF = -(1 + 2*nu) * Id4 + 
              ((1 + 2*nu)/2) * (KP[s3, Id2] + KP[Id2, s3]);

(* 
   抄录 Omega_{+} (Eq 831-832)
*)
OmegaPlusPDF = ((-a0 + 2*nu)/4) * KP[Id2 - s2, Id2 - s2] + 
                ((1 + 2*nu)/8) * (
                    KP[I*s1 - s3, Id2 - s2] + 
                    KP[Id2 - s2, I*s1 - s3]
                );

(* 
   抄录 Omega_{-} (Eq 833-834)
*)
OmegaMinusPDF = ((-a0 + 2*nu)/4) * KP[Id2 + s2, Id2 + s2] - 
                 ((1 + 2*nu)/8) * (
                     KP[I*s1 + s3, Id2 + s2] + 
                     KP[Id2 + s2, I*s1 + s3]
                 );

(* 构建完整的 Omega 形式 (dlog 形式) *)
OmegaExplicitPDF = OmegaP0PDF * Log[P0] + 
                    Omegax2PDF * Log[x2] + 
                    OmegaPlusPDF * Log[P0 + 2*x2] + 
                    OmegaMinusPDF * Log[P0 - 2*x2];


(* ========================================================================= *)
(* 2. 加载生成的文件                                                         *)
(* ========================================================================= *)

(* 设置目录 *)
SetDirectory["d:\\opencode projects\\dSibp\\codeR1\\OmegaR"];
inputStr = "OmegaR1.m";

If[FileExistsQ[inputStr],
    Print["Loading ", inputStr, "..."];
    Get[inputStr];
    ,
    Print["Error: File ", inputStr, " not found!"];
    Exit[];
];

If[!ValueQ[OmegaRaw],
    Print["Error: OmegaRaw not found in loaded file!"];
    Exit[];
];

(* 统一 Log 符号 *)
OmegaRaw = OmegaRaw /. log -> Log;


(* ========================================================================= *)
(* 3. 验证与比较                                                             *)
(* ========================================================================= *)

Print["\n=== 开始验证 ==="];

(* 3.1 验证完整 Omega *)
diff = OmegaRaw - OmegaExplicitPDF // FullSimplify;

Print["\n1. 完整 Omega 矩阵比较 (OmegaRaw - OmegaExplicitPDF):"];
Print["Diff IsZeroMatrix? ", diff === Table[0, {4}, {4}]];

If[diff =!= Table[0, {4}, {4}],
    Print["WARNING: 完整矩阵不匹配！"];
    nonZeroPos = Position[diff, x_ /; x =!= 0, {2}, Heads -> False];
    Print["非零元素个数: ", Length[nonZeroPos]];
    If[Length[nonZeroPos] > 0,
        p = nonZeroPos[[1]];
        Print["第一个非零元素位置: ", p];
        Print["PDF Value: ", OmegaExplicitPDF[[Sequence @@ p]] // FullSimplify];
        Print["Gen Value: ", OmegaRaw[[Sequence @@ p]] // FullSimplify];
        Print["Diff: ", diff[[Sequence @@ p]]];
    ];
    ,
    Print["SUCCESS: 完整 Omega 矩阵与 PDF 公式完全一致 (Exact Zero)."];
];


(* 3.2 验证各个分量矩阵 *)
If[ValueQ[OmegaP0Ref],
    Print["\n2. 分量矩阵一致性检查 (Generated Ref vs PDF):"];
    
    checkList = {
        {"OmegaP0", OmegaP0Ref, OmegaP0PDF},
        {"Omegax2", Omegax2Ref, Omegax2PDF},
        {"OmegaPlus", OmegaPlusRef, OmegaPlusPDF},
        {"OmegaMinus", OmegaMinusRef, OmegaMinusPDF}
    };
    
    Do[
        name = item[[1]];
        genRef = item[[2]];
        pdfRef = item[[3]];
        
        d = genRef - pdfRef // FullSimplify;
        isZero = (d === Table[0, {4}, {4}]);
        Print[name, ": ", If[isZero, "MATCH", "MISMATCH"]];
        If[!isZero, 
            Print["  Diff: ", d];
        ];
    , {item, checkList}];
];

Print["\n=== 验证结束 ==="];
