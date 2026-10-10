# MadStree v0.17 更新说明

本版从 v0.15 建立，不提供 v0.15 loader、路径、接口或结果的兼容入口。

## 修复

- `MSBoundaryData` 删除 massive contact 深度的重复因子 `I^n`。`sector["normalization"]`、
  Hankel 顶点系数和 component 定义积分已经给出完整相位；旧实现会让 single
  pinch 多 `I`、double pinch 多 `-1`。
- massive child normalization 删除重复的 `Exp[Pi Im[formulaNu]]`。该因子属于论文的共轭阶
  顶点 basis；MadStree 用共同 Hankel 阶表示两个顶点，换基恒等式已经吸收该因子。
- massive Full 传播子收缩后的 sector/master normalization 补回其唯一需要的 `fullContourSign`：
  省略共同动量幂时，`++` child 为 `-4 I/Pi`，`--` child 为 `+4 I/Pi`。该符号只定义
  `J_s=calN_s I_s`，不进入 normalized-master DE 或 recurrence event。
- contact recurrence 与 dlog DE 物理删除 pure-massive event 的额外 contour sign；轮廓信息只从
  有符号能量、用户变量链式因子和最终 SK branch 权重进入。massless quotient 的 `(-1)^N`
  保留。`J_s=calN_s I_s`、sector/master 顺序和公开接口不变，但受影响 lower-sector DE 块已修正。
- regulator Laurent 支撑证书的输入覆盖预检改在固定非零 exact 点 `ep=1/1009` 执行，避免合法的
  normalization pole 在通用数值完备性检查中被提前拒绝。该点不进入拟合；DE、完整物理边界与
  共振的正式 valuation 仍在 `ep=0` 执行，奇异 DE、非 Laurent 和晚时不衰减门禁不变。
- `MSExportEvaluationData` 修复 `ExportFormats -> {"CSV","JSON"}` 的列表解析，并让已是字符串的
  `relativeDifferenceInf` 原样写入 JSON，避免 round-trip 后多一层字面引号。

## 公式说明

- 中英文手册按 2411.03088 Eq. (4.2) 的定义积分使用
  `(-I)^(p+1) Gamma[p+1]`。
- 论文印刷 Eq. (4.11) 相对这个直接积分多一个 `I`；该差异只作为独立诊断，不写入生产边界。
- Eq. (4.2) 中的 `Exp[Pi Im[nu]]` 在论文顶点 basis 中不是勘误；只有在转到 MadStree
  共同 Hankel 阶 basis 后再次保留它才是重复 normalization。

## 独立验证

- Validation-04 继续用论文两顶点五主积分全链检查修复后的全部边界 branch。
- Validation-07 升级为全部八个 SK 分支的 V5.5/MadStree 分层检验。两边均直接计算八支，
  不用四支加复共轭补齐。每支分别冻结 master、
  normalization、DE 和边界后直接交给同一独立 FlintNDE 0.5.0；低阶结果用于输出，高阶只作
  refinement。
- arXiv:2309.10849v2 的 Eq. (103) 是全部 SK 分支求和后的闭式结果。论文
  Appendix B Eqs. (148)--(151) 给出四个独立分支的定义，但没有给每支单独的完整闭式
  oracle；因此论文只认证八支直接结果的总和，单支由 V5.5 与 MadStree 互检。原始 V5.5
  八支总和通过 Eq. (103) 后才成为逐支 reference；额外乘 `Exp[Pi Im[nu]]` 的路线作为被
  Eq. (103) 否决的反事实保留。
- fresh 全量 Validation-07 通过 `21/21`；八支乘五变量共 40 个 `25x25` DE 全部 exact 相等，
  八支普通点逐分量均在预先固定的联合误差预算内。总 wall time 为 `719.1006252` 秒。
- Validation-06 从空目录通过 `23/23`，覆盖单顶点闭式、cyclic time graph、regulator 自适应
  扩阶与旧点复用、候选池耗尽保留最佳结果，以及 CSV/JSON 列表导出和字符串字段 round-trip。

## 接口与迁移

- massless Full 传播子现在只保留 shared two-state quotient。旧四态顶点表示、
  `masslessRepresentation` 输入、专用 slot、normalization、adapter 和测试均已物理删除；不提供
  兼容入口或定向拒绝。
- `MSReduce` 新增 List/Table/空列表/ragged 嵌套输入，保持逐元素输出形状并共享递归 memo。
- 初始化保存每个 reachable component 的时间-IBP 安全 shift 下界；零 shift master 命中 Gamma
  非正整数时拒绝，正整数起点只在实际跨越安全下界时拒绝，并提示加入符号解析正规化。

当前工作树只保留 v0.17；旧版本从 Git 历史恢复。
