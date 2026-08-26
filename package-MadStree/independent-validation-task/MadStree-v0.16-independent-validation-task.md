# MadStree v0.16 独立验证任务书

对象：`versions/MadStree-v0.16/` 当前源码。

本任务书中的“通过”只允许来自实际执行。每个 case 运行前必须删除本 case 的旧 `results/`、
`results_temp/` 和自动报告，从空目录重新计算。开发测试、人工构造的 scalar payload、旧版本报告、
其它 case 的缓存或 summary 都不能替代这里的包级验证。

## 一、所有 case 都要遵守的规则

1. 正式 MadStree 路线必须显式加载 v0.16，并调用该 case 要验证的公开入口。凡是声称验证完整树图
   数值链的 case，至少要真实调用 `MSInitTree`、`MSMasterIntegrals`、`MSDLogDE`、
   `MSBoundaryData` 和 `MSEvaluatePath`。不能手写 master、DE 或边界 payload 后仍称作
   “MadStree 包级通过”。
2. 独立 expected 必须在调用 MadStree producer 之前冻结来源和 SHA-256。expected 不得由本轮
   MadStree 输出、差矩阵或失败后的拟合反推。
3. 可以精确比较的结构量，例如 master 数量与顺序、basis 映射、normalization、dlog letters、
   residue 和解析 DE，必须做 exact 比较，并报告“相等项数/总项数、非零差值数、首个差值”。
4. 数值 NDE 结果本来带有截断和舍入误差，不要求逐位完全相同。两条路线分别运行主阶和更高参考阶，
   以两阶差、FlintNDE 返回的误差估计和独立级数截断差组成联合误差预算。逐分量记录绝对差、相对差、
   联合预算和 `差值 <= 安全因子 x 联合预算` 是否成立。安全因子必须在运行前固定；不能看见差值后
   临时放宽。若某条路线没有可信误差估计，该分量不得写成数值通过。
5. 报告必须列出精确输入点、实际坐标、边界/anchor、FlintNDE 返回的路径和节点、工作精度、边界阶、
   主/参考输运阶、wall time、结果文件路径和所有 fail-closed 反例。计划值不能冒充实际值。
6. 每个 `run_validation.wls` 自动生成本 case 的 `000_...report.md` 和 `results/summary.wl`；长路径、
   backend JSON、cache 和 checkpoint 只放 `results_temp/`。即使失败或提前停止，也要写出已完成步骤、
   阻断原因和未执行字段。
7. 三顶点 V5.5 外部参考的唯一正式目录是
   `reference/ref_code_3vertexanalyticcheck/`。验证脚本不得读取任务书目录中的复制品；需要关闭
   `v55RunNow` 或改变运行路径时，只能复制主脚本和 companion 到本 case 的 `results_temp/` 后修改
   隔离副本，并记录正式 reference 与隔离副本的 SHA-256 关系。

### 1.1 原始论文、勘误与公式索引

原始 PDF 只从 `independent-validation-task/reference/` 读取，不修改内容。每次执行先核对 PDF
完整性、页数和 SHA-256；勘误文件与原文相邻保存，但不能覆盖或重写原文。

| 资料文件 | 对应原文公式 | 在本任务中的职责 |
| --- | --- | --- |
| `reference/2309.10849v2-Inflation Correlators with Multiple Massive Exchanges.pdf` | Eq. (83) | 定义三顶点 seed integral 及八个 SK 分支 |
| 同上 | Eq. (103) | Validation-07 的八支总和 oracle；不是单支闭式 |
| 同上 | Appendix B Eqs. (148)--(151) | 列出四个独立积分分支，用于核对 convention 与覆盖边界 |
| `reference/2411.03088-Multivariate hypergeometric solutions of cosmological (dS) correlators by d log-form differential equations.pdf` | Eqs. (3.3)、(4.1)、(4.2)、(4.4)、(4.5) | Validation-04 的 master、basis、DE 与 contact 定义积分 |
| 同上 | Eqs. (3.14)、(3.16)、(4.8)、(4.10) | Validation-04 收敛域内的独立级数/超几何数值 oracle |
| 同上 | Eq. (4.11) | 只保留为原始印刷式反事实，不作为生产边界 oracle |
| `reference/2411.03088-勘误.md` | Eq. (4.11) 对 Eq. (4.2) | 记录 Eq. (4.11) 相对定义积分多一个整体因子 `I` |

本文及其 runner、报告只用 arXiv 号称呼论文，不写作者名。论文没有给出的单支闭式不得由总和
反推；外部 V5.5 结果和 MadStree 输出也不得写成论文公式。

## 二、Validation-01：零外腿辅助能量

选择一个含 massless edge 的两顶点图，使一个顶点分别省略 `externalLegEnergy` 和显式输入 0。

1. 两种输入都真实调用完整 MadStree producer 和数值入口。
2. 比较 master 顺序、解析 dlog、私有辅助坐标和 digest。
3. 确认用户的 `pointSequence`、`ParameterRules` 中没有私有辅助坐标；程序仍从非零阻尼 anchor
   生成边界并输运到辅助坐标的物理值 0。
4. 两种输入在同一物理点的结果按第一节联合误差预算逐分量比较。

## 三、Validation-02：有限奇点终点分类

使用相互独立的 exact 一维 dlog 模型覆盖 removable、true pole 和零阶 log divergence。分别检查
有限数值、文本 `Infinity`、逐分量分类及 `singularityClassifications` 表一致；不得用绕行点值冒充
奇点值。该 case 是 FlintNDE 适配与 fail-closed 验证，不得称为真实树图 master/DE/边界验证。

## 四、Validation-03：Automatic 奇点双侧 bucket 与末端隐藏匹配

以 `SingularityMode -> "Automatic"` 构造“奇点前普通点、奇点、奇点收敛域内多个用户点、奇点后
continuation 点”的同一复仿射序列。要求：

1. 精确奇点不进入普通节点；局部基只使用必要的入射/出射匹配点。
2. 其余近奇点用户点由同一奇点解输出；真实 pole 返回文本 `Infinity`，并保留原始 userIndex。
3. 最后普通点继续得到独立闭式值；记录每点归属、收敛半径和实际节点数。
4. 与 naive 逐点局部求值按第一节联合误差预算互检，并比较 wall time。
5. 另构造末端奇点且前一普通点位于局部收敛圆外，检查隐藏匹配点、低阶主链结果和高阶参考链误差。
6. `FlintNDEPathPlanning -> False` 的中间奇点、需要隐藏末端匹配点的情况，以及奇点位于下一复仿射段
   转向处的分支不唯一情况都必须 fail closed。

机器 summary 至少保存原始 `pointSequence`、userIndex、实际节点、assignment/source、奇点分类表、
收敛半径、隐藏匹配点、主/参考阶、逐点误差、planned/naive wall time 和全部反例状态。

## 五、Validation-04：论文 2411.03088 两顶点 massive G++ 全链交叉验证

本 case 验证论文 Sec. 4 的两顶点、单条 massive `G++`、五主积分系统。必须同时建立下列互不
替代的路线；任一路未执行都不能写成 Validation-04 通过。

### 路线 A：MadStree 自己生成并数值求解

1. 用两个 `vertexType -> "+"` 顶点和一条 massive line 调用 `MSInitTree`。
2. 依次调用 `MSMasterIntegrals`、`MSDLogDE` 和 `MSBoundaryData`，保存原始返回对象的轻量摘要。
3. 对同一个 `pointSequence` 调用 `MSEvaluatePath`；不得把论文矩阵或论文边界塞回 MadStree 入口。
4. 至少取三个论文级数收敛域内的普通点，其中包含一个不交换两顶点的非对称点；所有点避开
   `k12=+-ks`、`k34=+-ks`、`k12+k34=0` 和分支切线。

### 路线 B：按论文手工输入 DE 和边界，直接调用 FlintNDE

1. 只从独立附件 `paper2411_two_vertex_gpp_de.wl` 和
   `paper2411_two_vertex_gpp_solution.wl` 读取论文 master 顺序、dlog potential、边界公式及其
   PDF/勘误/参考代码 hash；附件必须在加载 MadStree 前读取并冻结。PDF authority 固定为
   `reference/2411.03088-Multivariate hypergeometric solutions of cosmological (dS) correlators by d log-form differential equations.pdf`，
   Eq. (4.11) 的相位差只从相邻 `reference/2411.03088-勘误.md` 读取。
2. 把论文五维 dlog DE 和论文无穷远 Frobenius 边界独立转换为 FlintNDE 的输入 schema，直接调用
   MadStree v0.16 内嵌的同版 FlintNDE backend。该转换代码只可读取论文附件，不能读取路线 A 的
   `MSDLogDE`、`MSBoundaryData` 或它们导出的 runtime payload。
3. 路线 B 使用与路线 A 相同的物理点、工作精度、边界阶和主/参考输运阶，并独立保存实际路径、
   节点、主/参考差和 wall time。

### 逐阶段比较

1. **主积分与变量约定**：论文顺序固定为 `{I00,I01,I10,I11,IR}`；MadStree 顺序固定为
   `{00,01,10,11,child}`。论文 Eq. (4.1) 使用 `Exp[+I k tau]`，而 MadStree 的
   `vertexType -> "+"` 使用 `Exp[-I E tau]`，所以先固定 `E12=-k12,E34=-k34`；五个 master
   本身使用 identity basis。再比较每项 integral、裸积分和 normalization。禁止从最终数值差拟合
   额外 basis 或变量映射。
2. **DE**：在上述变量约定和同一 basis 下，比较完整 dlog potential 的 letters/residue，并对
   `{k12,k34,ks}` 三个 `5x5` 连接矩阵逐项 exact 比较。每个变量必须报告 `25/25` 或明确首差值。
3. **边界条件**：比较全部五个 leading branch，而不只比较 contact branch。逐项记录 sector/state、
   Frobenius exponent、coefficient、normalized leading vector、物理 normalization 和 Hankel branch。
   在同一 blow-up chart/rank order 下比较 `coefficient x leading vector`。任何额外整体相位或
   分量相位都必须从论文/包定义解释，不能由普通点结果反推。
4. **普通点**：路线 A 与路线 B 的五分量结果逐点按第一节联合误差预算比较。另用论文超几何/级数
   公式在同一点直接求值，检查 cutoff 加深后的稳定性和代回论文 DE 的 residual；它是第三方数值
   旁证，不替代路线 B 的 FlintNDE 输运。
5. **误差结论**：小于联合预算的非零差异是正常数值误差；超过预算必须判失败并定位到最早不一致的
   master、DE、边界 branch、路径或输运阶段，不能仅写“数值计算有误差”。

### Validation-04 必须保存的证据

- 两个源码/附件 SHA-256、master digest、固定 basis 映射和三个 exact DE 差矩阵；
- 五个边界 branch 的双路线记录和逐字段 residual；
- 至少三个普通点的两条 FlintNDE 路径/节点、论文级数值、逐分量绝对差/相对差/联合误差预算；
- boundary、路线 A、路线 B、论文级数和总 wall time；
- package 路线少调用任一必需公开入口时会失败的完整性门禁。

## 六、任务书覆盖性审阅

执行完上述 case 后，报告还要逐项列出 MadStree v0.16 的公开功能与本任务书覆盖关系：初始化、
master、递推/约化 metadata、dlog DE、边界、普通/奇点路径、多点、辅助能量、正规化和 FlintNDE
适配。每项标记为“真实包级已验证”“只做 adapter/结构检查”“未验证”，并说明仍需增加的正例、
反例或手册说明。不得把一个 scalar fixture 推广成整个包已验证。

## 七、Validation-05：递推约化、换基与 dSIBP 表示桥

选择一个含 top/contact 两层且有非零正、负 time shift 的 exact 小树图，独立手推有限递推，不读取
MadStree 的 recurrence metadata 作为 expected。

1. 调用 `MSFormulaMatrices`、`MSContactMaps`、`MSRecurrenceStep` 和 `MSReduce`，逐步比较每层
   系数、奇异分母、master 顺序和最终 residual；正、负 shift、非法 sector、缺失/重复 MasterBasis
   都要有正反例。
2. 对同一局部状态向量检查 `MSHTohMatrix`、`MShToHMatrix`、`MSConvertBasis` 的双向 exact identity；
   已积分对象在不能唯一换基时必须 fail closed。
3. 检查 `MSToDSIBPJ`、`MSFromDSIBPJ`、`MSFromDSIBPExpression` 的 sector、shift、state slot 和
   normalization 不丢失；该桥只验证表示转换，不能替代 dSIBP 自己的 IBP/DE 检验。

## 八、Validation-06：单顶点族、time graph 与 regulator 重建

1. 分别从 `MSInitVertexFamily` 和 `MSInitTimeGraph` 建立最小可解 context；对 master、dlog、边界和
   普通点使用独立闭式或级数 expected，不能把 `MSInitTree` 的输出复制成 expected。
2. 对一个已知 Laurent 系数的 regulator family 调用 `MSReconstructEpSeries`。拟合点与独立验证点
   必须不相交；逐轮保存使用点、复用点、检测到的最低幂、系数误差和失败后的加阶记录。
3. `MSExportEvaluationData` 的 CSV/JSON 只导出 saved 普通点；临时 waypoint、Infinity 类型和精度
   字段必须 round-trip。缺点、点池耗尽和未达目标精度应返回明确状态，不能静默标记完成。

## 九、Validation-07：V5.5 三顶点 25 维系统交叉检查

本 case 只在 `independent-validation/MadStree-v0.16-validation-07-v55-three-vertex-cross-check/`
内运行。所有 probe、关闭自动运行后的 V5.5 隔离副本、Python companion、cache 与中间输出均放在
该 case 的 `results_temp/`；不得修改或在 `reference/ref_code_3vertexanalyticcheck/` 中生成产物。

### 9.1 外部来源和论文覆盖边界

1. V5.5 主脚本和 Python companion 的唯一 authority 是
   `reference/ref_code_3vertexanalyticcheck/`；先冻结两个 SHA-256，再复制到 `results_temp/`，
   隔离副本只允许关闭自动运行、改 runtime 路径和施加有名字的 counterfactual。
2. 论文来源固定为 `reference/2309.10849v2-Inflation Correlators with Multiple Massive Exchanges.pdf`。
   Eq. (83) 定义八个 SK 分支；Appendix B Eqs. (148)--(151) 明列 `+++`、`++-`、`-++`、`+-+`
   四个独立积分分支；Eq. (103) 是全部 SK 分支求和后的超几何结果，不是某个单支结果。
3. V5.5 和 MadStree 必须都直接计算 `Tuples[{1,-1},3]` 的全部八支。复共轭关系只作为八支直接
   结果之间的额外 identity check，不能用于生成、补齐或替代任一待检分支。
4. 论文 Eq. (103) 只认证按论文 convention 组合后的八支总和。单支只允许以“经 Eq. (103)
   总和认证后的同批 V5.5 八支结果”作为 MadStree 外部参考；不得声称论文直接认证单支。

### 9.2 Master、normalization 与解析 DE

1. 八个分支固定为 `+++`、`++-`、`+-+`、`+--`、`-++`、`-+-`、`--+`、`---`。逐支冻结
   V5.5 和 MadStree 的 25 维
   sector/master 顺序、裸积分、`J_s=calN_s I_s` normalization、SK 顶点号、外腿指数号、
   Wick 旋转和变量映射；映射必须由定义推出，禁止从普通点差值拟合。
2. 对每支逐项 exact 比较 `{E1,E2,E3,s1,s2}` 五个变量的完整 `25x25` 连接矩阵。每个矩阵保存
   相等元素数、非零差值数、首差值和 sector block 位置；只比较单条 pullback 不得写成五变量通过。
3. 对 Top、LeftPinch、RightPinch、DoublePinch 分别列出主积分 normalization 和 contact 深度。
   massive pinch normalization、SK 顶点权重与定义积分 coefficient 做 exact 比较；省略共同的
   momentum 幂后，`++`/`--` Full line 的 child normalization 必须分别为 `-4 I/Pi`、`+4 I/Pi`。
   该 `fullContourSign` 只能进入 sector/master normalization，不能再次进入 normalized-master
   dlog contact block 或 recurrence event。故意恢复
   MadStree 旧 `I^contractedMassiveCount` 时 single/double pinch 必须分别出现 `I/-1` 并使门禁失败。
4. 不得从局部 normalization producer 是否显式出现某个因子，直接判定完整 V5.5 convention
   正误。原始八支必须先由第 9.4 节论文总和认证；额外乘 `Exp[Pi Im[nu]]` 只允许作为隔离、
   明确命名的反事实。reference 原件不得修改，反事实也不得冒充原始 V5.5。

### 9.3 两种边界 chart 与直接 FlintNDE 路线

1. V5.5 使用 `E2 -> Infinity`、其它变量固定的 Frobenius chart；MadStree 公开
   `MSBoundaryData` 使用严格 rank blow-up chart。二者的原始 exponent/vector 不在同一局部变量
   与同一 chart，禁止直接逐项比较后宣称相等。
2. 每个分支分别冻结两套边界 payload。V5.5 路线保存 E2-infinity residue、seed exponent、
   leading vector 和 normalization；MadStree 路线保存 strict-rank singular connection、所有
   leading branches、physical weights 和 normalization。两边各自对各自 residue 做 exact 或
   预先定精度的 Frobenius residual 检查。
3. 两套冻结 payload 都必须直接调用独立
   `package-FlintNDE/versions/FlintNDE-0.5.0/`。V5.5 自带的
   `pyflint_e2_transport.py` 只可用于 producer smoke/countercheck，不能替代本 case 的 FlintNDE
   结果。MadStree 路线也不能通过 `MSEvaluatePath` 重新生成 payload 后冒充冻结输入。
4. 八支都从各自边界输运到同一个普通物理点。`TransportOrder` 的低阶链是正式输出，
   `ReferenceTransportOrder` 的高阶链只作 refinement；逐支保存实际路径、节点、主/参考差、
   boundary/primary/reference/total wall time 和全部 25 分量的联合误差预算。
5. chart 无关的 normalization/contact coefficient 必须在输运前 exact 对齐；两条路线的普通点
   同序向量只在各自误差预算内比较。普通点不能反向决定 master、normalization、Wick 方向或相位。

### 9.4 论文总和与验收

1. 先把 V5.5 直接计算的八支 top master 逐支按 Eq. (83) 的顶点因子映到论文 convention，再直接
   求八支总和；不得用四支复共轭补齐。只在 Eq. (103) 多变量级数收敛域内选点，直接比较论文闭式，
   不增加 `NIntegrate` 路线。
2. 论文级数至少计算低/高两个 cutoff；高 cutoff 只作 truncation 检查。V5.5 原始路线与额外乘
   `Exp[Pi Im[nu]]` 的隔离反事实分开比较。只有原始 V5.5 八支总和通过 Eq. (103)，且额外因子
   反事实被同一预算否决后，才允许进入 MadStree/V5.5 的八支逐支比较；未满足时立即保存结构化
   失败并停止后续比较。
3. 逐支比较 MadStree 与已通过总和门禁的同批 V5.5 八支低阶生产结果；高阶结果只组成联合误差
   预算。另检查直接计算的相反号分支在论文 convention 下是否满足复共轭关系，但该 identity
   不替代任何一支直接计算。
4. 报告必须分别给出：原始 V5.5 状态、额外因子反事实状态、V5.5 八支总和对 Eq. (103) 的
   先决门禁、MadStree v0.16 状态、八支逐支状态和 MadStree 八支总和旁证。任一分支未执行、
   任一 payload 不是 fresh 冻结、论文先决门禁未通过或论文单支覆盖被夸大时，Validation-07
   整体不得通过。
5. `results/summary.wl` 至少保存 source hashes、八支 master/normalization、五变量 DE residual、
   两类 chart、全部 boundary records、FlintNDE 实际路径/节点/阶数/精度/计时、逐分量差、论文
   cutoff 差和所有 fail-closed/counterfactual 结果。
