(* ::Package:: *)

(***
文件：MadStree.wl
用途：声明 MadStree 的公开接口并按依赖顺序加载公式模块。
边界：本包只直接组装 tree formula，不生成一般 IBP 方程组或 reduction 输入。
***)

(* ::Chapter:: *)
(*公开 context 与接口声明*)

BeginPackage["MadStree`"];

MSInitTree::usage = "MSInitTree[spec] 初始化公式型 dS 树拓扑并返回 MadStree context；masslessFull 可在 line 上固定选择 masslessRepresentation->\"Quotient\"|\"RedundantH\"。";
MSInitTimeGraph::usage = "MSInitTimeGraph[spec] 初始化不含 loop-momentum/ISP 的纯 time-only 含圈 incidence graph。";
MSInitVertexFamily::usage = "MSInitVertexFamily[spec] 用 ki/nui 或显式 h/exponential blocks 初始化不依赖图 topology 的单顶点函数族。";
MSContextQ::usage = "MSContextQ[context] 判断对象是否为有效 MadStree context。";
MSSectors::usage = "MSSectors[context] 返回 contact-reachable sectors 的确定顺序列表。";
MSSlotRegistry::usage = "MSSlotRegistry[context,sector] 返回 sector 的全图二维 slot registry。";
MSIntegral::usage = "MSIntegral[sectorKey,aShifts,stateBits] 是 MadStree 的原生 time-only 积分。";
MSMasterIntegrals::usage = "MSMasterIntegrals[context] 返回与所有公式矩阵严格同序的主积分记录。";
MSFormulaMatrices::usage = "MSFormulaMatrices[context,sector] 返回 M1、M0、U 与 energy letters。";
MSFormulaData::usage = "MSFormulaData[context] 汇总全 sector masters、递推 metadata 与完整 dlog DE；TimePowerRules 可选代入用户指定的 a_i。";
MSWriteFormulaArtifacts::usage = "MSWriteFormulaArtifacts[context] 把全 sector masters、递推 metadata、dlog DE 与 manifest 写到调用脚本目录，并返回实际输出路径。";
MSContactMaps::usage = "MSContactMaps[context,sector] 返回 parent-to-subsector 的精确 contact 矩阵。";
MSRecurrenceStep::usage = "MSRecurrenceStep[integral,component,context] 把一个非零时间 shift 向零约化一步。";
MSReduce::usage = "MSReduce[expr,context,MasterBasis->basis] 迭代约化固定 context 内合法 MSIntegral 的有限线性组合，并返回同序系数向量、残留项和奇异层。";
MSDLogDE::usage = "MSDLogDE[context] 返回同序主积分与 block-triangular dlog connection。";
MSHTohMatrix::usage = "MSHTohMatrix[nu,z,context] 按初始化 context 返回局部 H-state 到 h-state 的 2x2 变换。";
MShToHMatrix::usage = "MShToHMatrix[nu,z,context] 按初始化 context 返回局部 h-state 到 H-state 的逆变换。";
MSConvertBasis::usage = "MSConvertBasis 在局部或指定 sector 的同序 H/h state vector 间变换；sector 变换固定读取初始化 context 的 NuConvention，积分对象继续 fail closed。";
MSToLegacyJ::usage = "MSToLegacyJ[integral,context] 把可唯一表示的 massive time-only 积分转成旧 J 结构。";
MSFromLegacyJ::usage = "MSFromLegacyJ[j,context] 把可唯一表示的旧 massive time-only J 转成 MSIntegral。";
MSToDSIBPJ::usage = "MSToDSIBPJ[integral,context] 把 MadStree time-only 积分无损转成惰性的 dSIBP 020 J[sectorKey,timeShifts,stateBits]；只有匹配同一 sector/state-slot schema 的 dSIBP context 才能继续求导。";
MSFromDSIBPJ::usage = "MSFromDSIBPJ[j,context] 把惰性或活动的 dSIBP time-only J 转回同一 context 的 MSIntegral。";
MSFromDSIBPExpression::usage = "MSFromDSIBPExpression[expr,context] 逐项把线性 dSIBP J 表达式转成 MadStree MSIntegral 表达式，不执行约化。";
MSNumericalSystem::usage = "MSNumericalSystem[de,spec] 验证数值替换与边界向量并构造数值 DE 数据。";
MSBoundaryData::usage = "MSBoundaryData[context,targetRules] 从 k0->Infinity Frobenius 公式生成与 dlog masters 同序的有限起算向量；不支持时 fail closed。";
MSBoundaryChartCertificate::usage = "MSBoundaryChartCertificate[context,targetRules] 构造 nested blow-up、逐 sector theta 固化与 normal-crossing 机器证书；RankOrder->All 检查全部 strict charts。";
MSBlowupCoordinate::usage = "MSBlowupCoordinate[i] 是自动边界 nested blow-up chart 的第 i 个局部坐标。";
MSDampingEnergy::usage = "MSDampingEnergy[v] 表示顶点 v 的内部正阻尼能量 K_v=i phaseSign_v k0_v。";
MSFlintNDEConfiguration::usage = "MSFlintNDEConfiguration[] 返回当前版本目录、内置 FlintNDE 相对路径及可用性。";
MSSetFlintNDERelativePath::usage = "MSSetFlintNDERelativePath[path] 修改唯一的版本目录相对 FlintNDE package 路径。";
MSFlintNDETransport::usage = "MSFlintNDETransport[context,boundaryData] 序列化一维 dlog 系统并调用 FlintNDE 输运。";
MSRuntimeDirectory::usage = "MSRuntimeDirectory 指定 MadStree/FlintNDE 运行产物根目录；缺省为调用脚本所在目录。";
FlintNDESavePoints::usage = "FlintNDESavePoints 指定仿射路径参数上的无名保存点；只接受 {{coordinate,\"save\"},...}，或按 \"singular\"/\"ordinary\" 分段的 Association。";
MSEvaluateTree::usage = "MSEvaluateTree[context,targetRules] 自动生成边界、路径并用 FlintNDE 返回目标点同序主积分数值。";
MSEvaluateVertexFamily::usage = "MSEvaluateVertexFamily[context,targetRules] 对 MSInitVertexFamily context 复用同一无穷远 Frobenius 边界与 FlintNDE 输运。";
NuConvention::usage = "NuConvention 选择 h=z^(+/-|nu|) H_|nu| 的 prefactor；缺省 \"Positive\"，\"Negative\" 对应 2401。";
BoundaryScale::usage = "BoundaryScale 控制无穷远 Frobenius 级数有限起算点离边界的距离，必须大于 1。";
BoundarySeriesOrder::usage = "BoundarySeriesOrder 指定无穷远 Frobenius 边界级数的总次数截断。";
RankOrder::usage = "RankOrder 指定从最大阻尼能量到最小阻尼能量的顶点 id 顺序；缺省由目标点确定。";
PythonExecutable::usage = "PythonExecutable 指定调用 FlintNDE 适配器的 Python 命令。";
TransportOrder::usage = "TransportOrder 指定 FlintNDE 主输运链的局部级数阶数。";
ReferenceTransportOrder::usage = "ReferenceTransportOrder 指定 FlintNDE 参考输运链的局部级数阶数。";
TargetRelativeError::usage = "TargetRelativeError 指定 FlintNDE 主/参考链末点相对差目标。";
MasterBasis::usage = "MasterBasis 指定 MSReduce 输出主积分的完整排列；缺省使用 context 固定顺序。";
TimePowerRules::usage = "TimePowerRules 指定公式产物中可选代入的顶点时间幂 a_i 规则；缺省 Automatic 保留符号。";
MSOutputDirectory::usage = "MSOutputDirectory 指定公式产物目录；相对路径以调用脚本目录为基准，缺省写入调用目录的 results/madstree_formula/run-UUID。";

MSInitTree::badinput = "树拓扑输入无效：`1`。";
MSInitVertexFamily::badinput = "单顶点函数族输入无效：`1`。";
MSFormulaMatrices::nosector = "找不到 sector `1`。";
MSContactMaps::nosector = "找不到 sector `1`。";
MSRecurrenceStep::badint = "积分与 context 不匹配：`1`。";
MSReduce::cycle = "迭代约化检测到重复状态：`1`。";
MSConvertBasis::unsupported = "尚未实现该 basis 变换：`1`。";


(* ::Chapter:: *)
(*私有模块加载*)

Begin["`Private`"];

$MadStreeVersion = "0.5";
$MadStreeKernelDirectory = DirectoryName[$InputFileName];

Scan[
  Get[FileNameJoin[{$MadStreeKernelDirectory, #}]] &,
  {
    "Core/Conventions.wl",
    "Core/Topology.wl",
    "Core/Sectors.wl",
    "Core/VertexFamily.wl",
    "Core/Representation.wl",
    "Formula/TensorAtoms.wl",
    "Formula/Recurrence.wl",
    "DE/DLog.wl",
    "Core/Artifacts.wl",
    "Numerics/Configuration.wl",
    "Numerics/Boundary.wl",
    "Numerics/Numerics.wl",
    "Numerics/FlintNDE.wl"
  }
];


(* ::Chapter:: *)
(*包作用域收尾*)

End[];
EndPackage[];
