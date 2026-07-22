# 015 root-coordinate independent benchmark

本目录只保存 015 动力学坐标变换的独立推导和冻结 expected。第一阶段不得加载 package；第二阶段由 `../check/check_kinematic_coordinates_against_package.wl` 单向读取 expected 后加载 `package_015.wl`。

覆盖边界：

- loop external momenta：`ssij = Sqrt[sp[ki,kj]]`；
- 实际出现的无圈动量模长：在完整 loop Gram 基上按出现顺序做增量秩筛选，只为独立项绑定 `sE1,sE2,...`；从属项保存 binding，不自动生成外腿向量交叉点积，且不进入 loop IBP generator/ISP closure；
- 固定 dependent case `{kE,2 kE,k+kE,k-kE}`：检查只产生两个 `sEe`、两条从属平方关系，以及 line/phase 的 binding Jacobian；
- 仍参与 `tau` 积分的无圈 massive 线：同时检查分母幂、两端 h building block 和顶点相位的径向导数；
- 用户重选规则的左端覆盖秩、右端参数 Jacobian、欠完备零空间和过完备约束；
- 对角和非对角 Jacobian；
- 一般混合坐标 `x11=u^2,x12=u v,x22=v^2+w^2` 的完整平方原子 Jacobian，以及 loop phase 不重复计数；
- 过完备 context 仍允许 symbolic IBP，但拒绝冗余变量 `ds` 和无唯一逆映射的 `rep2innerform`；
- 显式动力学系数的乘积法则；
- 用户显式指定旧 `sp -> sij` 时的单位 Jacobian 兼容。

本目录不读取 014/015 源码、主线 expected 或旧 package actual 来定义公式。
