# MadStree v0.16 更新说明

本版从 v0.15 建立，不提供 v0.15 loader、路径、接口或结果的兼容入口。

## 修复

- `MSBoundaryData` 删除 massive contact 深度的重复因子 `I^n`。`sector["normalization"]`、
  Hankel endpoint coefficient 和 component 定义积分已经给出完整相位；旧实现会让 single
  pinch 多 `I`、double pinch 多 `-1`。
- massive child normalization 删除重复的 `Exp[Pi Im[formulaNu]]`。该因子属于论文的共轭阶
  endpoint basis；MadStree 用共同 Hankel 阶表示两个端点，换基恒等式已经吸收该因子。
- massive Full line 收缩后的 sector/master normalization 补回其唯一需要的 `fullContourSign`：
  省略共同动量幂时，`++` child 为 `-4 I/Pi`，`--` child 为 `+4 I/Pi`。该符号只定义
  `J_s=calN_s I_s`，不进入 normalized-master DE 或 recurrence event。
- contact recurrence 与 dlog DE 物理删除 pure-massive event 的额外 contour sign；轮廓信息只从
  有符号能量、用户变量链式因子和最终 SK branch 权重进入。massless quotient 的 `(-1)^N`
  保留。`J_s=calN_s I_s`、sector/master 顺序和公开接口不变，但受影响 lower-sector DE 块已修正。

## 公式说明

- 中英文手册按 2411.03088 Eq. (4.2) 的定义积分使用
  `(-I)^(p+1) Gamma[p+1]`。
- 论文印刷 Eq. (4.11) 相对这个直接积分多一个 `I`；该差异只作为独立诊断，不写入生产边界。
- Eq. (4.2) 中的 `Exp[Pi Im[nu]]` 在论文 endpoint basis 中不是勘误；只有在转到 MadStree
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

## 接口与迁移

公开接口相对 v0.15 不变。当前工作树只保留 v0.16；旧版本从 Git 历史恢复。
