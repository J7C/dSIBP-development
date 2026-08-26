# FlintNDE 0.5.0 独立验证任务书

对象：`versions/FlintNDE-0.5.0/` 当前源码。验证 expected 必须来自闭式解或独立局部幂对数构造，不得复用被测函数的输出。每项运行前删除自身旧结果和报告。

## 所有 case 的共同判据

1. 可以精确比较的输入结构、路径计划 schema、奇点分类和 exact Q(i) 系数必须 exact 比较。
2. 数值输运、局部展开和主/参考阶结果不要求逐位相等。运行前固定工作精度、主阶、参考阶、
   目标误差和安全因子；逐分量报告绝对差、相对差、两阶差或闭式解误差，并以联合误差预算判定。
   小于预算的非零差异是正常数值误差，超过预算才判失败；不得在看见结果后放宽安全因子。
3. FlintNDE 只认证通用矩阵 DE、边界和输运算法，不认证上游的 dS 图、主积分顺序、normalization
   或论文物理公式。MadStree 的论文全链 case 必须在上游先认证这些对象，再检查交给 FlintNDE 的
   矩阵和边界与已认证对象一致；不能用本任务书的 scalar/exact 模型替代上游物理验证。

## Validation-01：奇点目标值与序列化

使用三个 exact Q(i) 一维/二维系统，分别具有 removable singularity、true pole 和零阶 log divergence。检查：

1. removable 分量返回 Acb 数值并与闭式极限一致；
2. pole 和 log 发散分量返回文本 `Infinity`；
3. 总分类、逐分量分类、局部阶数和样本证据一致；
4. 结果 round-trip 后文本与数值类型不混淆。

## Validation-02：奇点双侧节点、末端匹配与多点 bucket

给出入射普通点、奇点、奇点两侧各 3--20 个用户点和后续普通点。规划必须按奇点到最近其它奇点的距离选择入射/出射匹配点，并由同一个局部基覆盖其余近奇点点；记录每点所属节点/局部基、实际路径、节点数和 fast/iterative 算法。精确奇点不得作为普通节点，后续普通点必须从出射匹配点继续。结果与 naive 逐点局部求值互检，报告两条路线的 wall time 与比值。

另取一个末端奇点，其前一个普通用户点位于目标局部收敛圆外。检查 `plan_singular_target_match` 自动给出域内隐藏普通匹配点；低阶主链输出结果，高阶参考链只核验分类和有限值误差。关闭规划时若必须插入隐藏点，应返回明确失败；奇点处非共线转向也必须 fail closed。

机器 summary 至少保存：原始用户点及索引、普通节点、入射/出射/末端隐藏匹配点、收敛半径、每点 assignment、主/参考阶、逐点闭式误差、planned 与 naive wall time、节点数及最终奇点分类。

## Validation-03：回归与同步

运行完整 Python `unittest`、提升权限的 Wolfram `Needs` 端到端测试，并按相对路径比较独立包与 MadStree v0.15 Vendor 的全部非缓存交付文件 SHA-256。任何源码差异均失败；MadStree 自有 adapter 文件不纳入 Vendor 同源比较。

## Validation-04：高阶 pole、指数型局部解与 fail-closed 边界

使用独立构造的 exact Q(i)(x) 系统分别覆盖：可降为 Fuchsian 的高阶 pole、已支持的单重指数
power-log 起点，以及需要 defective/repeated formal block、ramification、代数扩域或 Stokes
connection 的系统。前两类逐阶检查变换 residual、局部系数和普通匹配点；后一类必须在启动未知
输运前给出明确 unsupported/inconclusive 状态。start-only 的指数边界不得被复用到中间点或终点。

## Validation-05：savepoint、regulator 重建与 Mathematica bridge

1. 对同一普通/正则奇点路线比较 cold run、savepoint resume 和序列化 round-trip；节点、精度、
   主/参考结果及证书状态必须一致，并记录 cached/cold wall time。
2. 用已知 Laurent 系数的矩阵 family 检查 regulator series 的采样、拟合、独立验证、增量加阶和
   点复用。拟合点与验证点必须严格分离；未达目标精度或候选点耗尽不得写成通过。
3. 通过 `Mathematica/FlintNDE.wl` 公开入口执行同一最小 case，比较 Python/Wolfram schema、复数类型、
   Infinity、消息语言和输出路径；不能只验证 `Needs` 成功。

## 交付

验证目录命名为 `independent-validation/FlintNDE-0.5.0-validation-NN-.../`；保存 runner、`000_...report.md` 和轻量 summary。报告必须列出源码 digest、数值点、实际节点/路径、工作精度、主/参考阶、wall time、逐分量误差和未执行边界。
