(* ::Package:: *)

(* ::Chapter:: *)
(*公开上下文与接口声明*)

BeginPackage["dSIBP`"];

$dSIBPVersion::usage = "$dSIBPVersion 给出当前加载的 dSIBP package 三位版本号。";

J::usage = "J 表示统一积分对象；J[aList,linePacks,ispList] 是 loop 表示，J[vertexPacks] 是 tree 表示。";
sp::usage = "sp[p,q] 是用户输入使用的对称标量积。";
qq::usage = "qq[i,j] 是内部圈动量标量积坐标。";
qk::usage = "qk[i,j] 是内部圈动量与外动量标量积坐标。";
kk::usage = "kk[i,j] 是内部外动量标量积坐标。";
a::usage = "a[v] 是 makeBaseIntegral 为顶点 v 建立的时间幂次整数指标。";
b::usage = "b[e] 是未缩并传播子 e 的分母幂次整数指标。";
bS::usage = "bS[e] 是缩并传播子 e 的分母幂次整数指标。";
n::usage = "n[e,...] 是 full-line 的二元离散态指标。";
ispN::usage = "ispN[i] 是第 i 个 ISP 的整数幂次指标。";
a0::usage = "a0[v] 是顶点时间幂次零点；物理幂次为 a+a0。";
b0::usage = "b0[e] 是未缩并传播子分母幂次零点；物理分母幂次为 b+b0。";
bS0::usage = "bS0[e] 是缩并传播子分母幂次零点；物理分母幂次为 bS+bS0。";
rho::usage = "rho[i] 是第 i 个 ISP 的内部坐标符号。";
dim::usage = "dim 是圈动量积分的空间维数参数。";
ke::usage = "ke[i] 是与动量向量无关的独立顶点相位能量参数；实际无圈动量模长由 independentExternalMomenta 依次绑定为 sE1,sE2,...。";
tau::usage = "tau[v] 是 rep2Integrand 输出中的顶点共形时间。";
xi::usage = "xi[e] 是 rep2Integrand 输出中的第 e 条线的动量模。";
Hh::usage = "Hh[block] 是 rep2Integrand 使用的惰性传播子 building-block 包装。";
MassiveBlock::usage = "MassiveBlock[...] 是 massive line 的惰性 integrand block。";
MasslessBlock::usage = "MasslessBlock[...] 是同分支 massless line 的惰性 integrand block。";
MasslessCrossBlock::usage = "MasslessCrossBlock[...] 是异分支 massless line 的惰性 integrand block。";
Tuserweight::usage = "Tuserweight[id] 是 Kira user-defined system 结果中的积分编号 token。";

dtau::usage = "dtau[vertex,expr] 生成指定顶点的时间 IBP；三参数形式接受 parsed topology 或 DSInit context。";
dqq::usage = "dqq[dLoop,vectorLoop,expr] 生成圈动量沿圈动量方向的 IBP；四参数形式接受 parsed topology 或 DSInit context。";
dqk::usage = "dqk[dLoop,vectorExternal,expr] 生成圈动量沿外动量方向的 IBP；四参数形式接受 parsed topology 或 DSInit context。";
ds::usage = "ds[expr,var] 对 exact 初始化 context 的外部变量 var 求总导数；三参数形式接受 parsed topology 或 DSInit context。016 缺省 var 为 loop Gram 根号 ssij 或显式独立无圈模长 sE1,sE2,...，并同时作用于积分指标和显式动力学系数。";
rep2innerform::usage = "rep2innerform[expr] 把用户 sp/ssij/sEe 表示转换为当前 topology 的内部坐标；双参数形式接受 parsed topology 或 DSInit context。一般混合或过完备坐标没有唯一反向映射时返回 $Failed。";
rep2outform::usage = "rep2outform[expr] 把内部标量积坐标按当前规则转换为用户 sp/ssij/sEe 表示；双参数形式接受 parsed topology 或 DSInit context。";
rep2Integrand::usage = "rep2Integrand[expr] 把统一 J 表示展开为用于核对的形式 integrand；双参数形式接受 parsed topology 或 DSInit context。";
symmetry::usage = "symmetry[expr,topo] 一次应用 topology 的内建、用户和 tadpole 对称性规则。";
repSymmetry0::usage = "repSymmetry0[topo] 返回 topology 输入的原始用户对称性规则。";
repIterative0::usage = "repIterative0 保存最近一次 tree 单步迭代生成的原始替换规则。";
repIterative::usage = "repIterative[expr,end] 把 tree 积分迭代约化到各顶点的目标时间幂次；sector-tagged treeLinearData 输入会保持 sector 身份并返回同结构约化结果，end 缺省为全零。";
DSTreeSeeds::usage = "DSTreeSeeds 直接生成带 sector/contact 审计的 pure-time/tree 种子；loop time-IBP 投影只保留为交叉验证。";
DSTreeNaiveIBP::usage = "DSTreeNaiveIBP[context,masters] 把 loop time-IBP 投影成 sector-tagged tree 线性系统，并在指定有序 master basis 下直接求解全部一步升幂对象；masters 缺省取 DSTreeDLogDE 的同序归一化 masters。";
DSTreeNaiveDE::usage = "DSTreeNaiveDE[context,variables,masters] 通过 loop 顶点相位导数投影、h 的 treeEnergy 导数和 DSTreeNaiveIBP 约化构造 tree 微分方程；结果保持指定 master 顺序和 normalization。";
DSTreeDLogDE::usage = "DSTreeDLogDE[data] 返回 tree vertex-family 的 dlog 微分方程、同序 master 列表和 letters；DSInit context 输入使用 direct pure-time contact selectors 组装全部可达 sector 的 block-triangular connection、normalization 审计与同序 tagged masters。";

DSInit::usage = "DSInit[input,opts] 验证 topology/ISP、初始化完整 contact-reachable sector，并可写出版本化 init metadata。";
DSInfo::usage = "DSInfo[] 返回当前初始化的简要信息；DSInfo[context,\"Full\"] 返回完整初始化 Association。";
DSKinematics::usage = "DSKinematics[input,rules] 返回 topology 的缺省动力学变量提案、全部必需模长覆盖、从属 binding、可复制的参数重定义格式，以及给定规则的秩、零空间、完备性和可逆性审计；rules 缺省读取 input 或使用自动提案。";
DSParameterNotation::usage = "DSParameterNotation[context] 返回圈外 Gram 根号、独立无圈模长、全部必需模长覆盖、当前用户变量规则及 DSRedefineParameters 的可复制示例；无参数形式读取当前 context。";
DSRedefineParameters::usage = "DSRedefineParameters[context,rules] 用新的完整动力学变量规则重新初始化并返回新 context；rules 左端写 baseCoordinateOrder 中的 sp[原始动量,...]，右端写自定义参数表达式，不写 ssij->custom；DSRedefineParameters[rules] 只在成功后更新当前 context。";
DSSeeds::usage = "DSSeeds[context,opts] 生成所有 contact-reachable sector 的 canonical IBP seeds；不运行 reduction。";
DSLinear::usage = "DSLinear[seedData,context,opts] 把 canonical seeds 转换为 backend-neutral linearData。";
DSKiraExport::usage = "DSKiraExport[linearData,opts] 序列化 Kira 基础输入和同源 manifest；不会启动 Kira。";
DSKiraImport::usage = "DSKiraImport[path,context,opts] 导入并验证完整 Kira reduction、master 顺序和积分双向映射。";
DSDE::usage = "DSDE[reductionData,variables,opts] 用 ds 和 reduction rules 构造保持 master 顺序的微分方程矩阵。";
DSScaleCheck::usage = "DSScaleCheck[deData,spec,opts] 检查约化后的 Euler/标度关系。";
DSMessagesOn::usage = "DSMessagesOn[] 开启 info、progress 和 warning 提醒。";
DSMessagesOff::usage = "DSMessagesOff[] 关闭可选提醒；fatal error 始终保留。";
DSMessagesQ::usage = "DSMessagesQ[] 返回可选提醒当前是否开启。";
DSPublicAPI::usage = "DSPublicAPI[] 返回当前版本需要用户掌握的公开函数、逻辑分组及各高层函数缺省选项；供手册附录和 example 覆盖门禁共同读取。";

WriteInitializationFiles::usage = "WriteInitializationFiles 是 DSInit 的选项；缺省 False。";
InitializationDirectory::usage = "InitializationDirectory 指定 init metadata 目录；缺省 Automatic，解析到调用脚本同目录的 init/。";
GenerateDerivativeMetadata::usage = "GenerateDerivativeMetadata 控制 DSInit 是否预生成独立变量微分算符 metadata；缺省 False。";
OverwriteInitialization::usage = "OverwriteInitialization 控制是否允许覆盖已有但输入哈希不一致的 init metadata；缺省 False。";
RegisterAsCurrent::usage = "RegisterAsCurrent 控制 DSInit 是否注册为无参公开接口的当前 context；缺省 True。";
ProgressReporting::usage = "ProgressReporting 控制单次高层调用的阶段进度；Automatic 跟随全局消息开关。";
KinematicRules::usage = "KinematicRules 是 DSInit 的可选动力学变量替换规则；缺省 Automatic 使用 input 中的 kinematicRules，若仍未给出则采用 DSKinematics 的缺省提案。";

PrecomputeShrinkSectorMetadata::usage = "PrecomputeShrinkSectorMetadata 控制底层是否预枚举 contact-reachable sector metadata。";
MaxShrinkSectorDepth::usage = "MaxShrinkSectorDepth 限制 shrink sector 深度；Automatic 使用完整可达深度。";
MaxShrinkSectorCount::usage = "MaxShrinkSectorCount 限制可初始化的 shrink sector 数。";
UseSampleOnly::usage = "UseSampleOnly 控制 continuous seed 是否使用 sample-only 范围。";
DiscreteMode::usage = "DiscreteMode 选择离散态 seed 模式：\"sample\"、\"all\" 或 \"none\"。";
MaxSeedRuleCount::usage = "MaxSeedRuleCount 限制连续 seed 规则数。";
MaxDiscreteRuleCount::usage = "MaxDiscreteRuleCount 限制离散态规则数。";
MaxEquationCount::usage = "MaxEquationCount 限制生成的方程数。";
ApplyNumericRules::usage = "ApplyNumericRules 控制底层 seed 是否提前代入 numericRules；高层缺省 False，数值替换应优先留到 linearData 层。";
GenerateShrinkSectors::usage = "GenerateShrinkSectors 控制 canonical seed 是否生成 contact-reachable shrink sectors；高层完整工作流缺省 True。";
KiraOrdering::usage = "KiraOrdering 指定 backend-neutral linearData 的 Kira 排序约定。";
CoefficientRules::usage = "CoefficientRules 指定 linearData 层的小规模系数替换规则。";
LinearSystemMode::usage = "LinearSystemMode 选择 DSLinear 的 \"symbolic\" 或 \"numeric\" 模式。";
ExportKira::usage = "ExportKira 是底层组合工作流的导出开关；DSKiraExport 本身不运行 Kira。";
OutputDirectory::usage = "OutputDirectory 指定 serializer 输出目录；None 表示只返回内存数据。";
KiraCoefficientRules::usage = "KiraCoefficientRules 指定 Kira 导出前的系数规则。";
KiraIntegralOrder::usage = "KiraIntegralOrder 指定 Kira 导出的显式积分顺序。";
KiraTargetIntegrals::usage = "KiraTargetIntegrals 指定 Kira job 的目标积分。";
KiraActiveBasis::usage = "KiraActiveBasis 为 DSKiraExport 指定有序 active basis 线性组合、名称和导数变量；缺省 None。";
KiraJobOptions::usage = "KiraJobOptions 指定仅用于生成 Kira job 文件的选项 Association。";
KiraReductionFile::usage = "KiraReductionFile 指定 DSKiraImport 读取的 reduction 规则文件；缺省先查 results/Tuserweight/kira_list.m，再兼容 results/kira_list.m。";
KiraMasterFile::usage = "KiraMasterFile 指定 DSKiraImport 读取的有序 master 文件；缺省先查 results/Tuserweight/masters，再兼容 results/masters。";
KiraCompletionFile::usage = "KiraCompletionFile 指定 DSKiraImport 检查的完成日志；缺省为 kira.log。";
KiraCompletionPatterns::usage = "KiraCompletionPatterns 指定完成日志必须匹配的字符串或 RegularExpression 列表。";
MaxReductionIterations::usage = "MaxReductionIterations 限制 DSDE 对 reduction rules 的 FixedPoint 迭代次数；缺省 100。";
ScalingRelation::usage = "ScalingRelation 指定 DSScaleCheck 使用的 \"Custom\" 或 \"PureMassiveBubble\" 标度关系。";
ScalingVariables::usage = "ScalingVariables 指定 Euler 算符中的变量顺序。";
ScalingWeights::usage = "ScalingWeights 指定 Euler 算符中各变量的系数；016 的 ssij 与独立无圈模长 sEi 都是动量一次量，缺省物理权重为 1。";
ScalingDegrees::usage = "ScalingDegrees 指定各 master 的预期齐次次数；PureMassiveBubble 可设 Automatic。";

(* ::Chapter:: *)
(*私有实现加载*)

Begin["`Private`"];

$dSIBPPackageRoot = DirectoryName[DirectoryName[$InputFileName]];
$dSIBPVersion = "016";

Get[FileNameJoin[{$dSIBPPackageRoot, "Kernel", "Core", "TopologyKinematics016.wl"}]];
Get[FileNameJoin[{$dSIBPPackageRoot, "Kernel", "Core", "LoopCore013.wl"}]];
Get[FileNameJoin[{$dSIBPPackageRoot, "Kernel", "Core", "Context.wl"}]];
Get[FileNameJoin[{$dSIBPPackageRoot, "Kernel", "Core", "Metadata.wl"}]];
Get[FileNameJoin[{$dSIBPPackageRoot, "Kernel", "IBP", "Loop.wl"}]];
Get[FileNameJoin[{$dSIBPPackageRoot, "Kernel", "IBP", "Tree.wl"}]];
Get[FileNameJoin[{$dSIBPPackageRoot, "Kernel", "IBP", "PureTime016.wl"}]];
Get[FileNameJoin[{$dSIBPPackageRoot, "Kernel", "Backends", "KiraExport.wl"}]];
Get[FileNameJoin[{$dSIBPPackageRoot, "Kernel", "Backends", "KiraImport.wl"}]];
Get[FileNameJoin[{$dSIBPPackageRoot, "Kernel", "DE", "BuildDE.wl"}]];
Get[FileNameJoin[{$dSIBPPackageRoot, "Kernel", "DE", "Scaling.wl"}]];
Get[FileNameJoin[{$dSIBPPackageRoot, "Kernel", "Tree", "VertexFamily.wl"}]];
Get[FileNameJoin[{$dSIBPPackageRoot, "Kernel", "Core", "KinematicCoordinates.wl"}]];
Get[FileNameJoin[{$dSIBPPackageRoot, "Kernel", "Core", "ParameterInterface016.wl"}]];

End[];
EndPackage[];
