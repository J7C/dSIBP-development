# dSIBP 020 更新说明

## 基线

- 基于冻结代码版本与正式发布 `019.0` 建立。
- 020 继续继承带 `018` 后缀的 Private 模块名；这些名称记录实现谱系，不是运行时版本。

## Time-only 表示变更

- `ibpMode -> "timeOnly"` 的唯一公开积分改为 `J[sectorKey,timeShifts,stateBits]`。
- `sectorKey` 仍是 019 定义的 root propagator 顺序定长 `0/1` 字符串，是唯一 sector 身份。
- `timeShifts` 按当前 sector 的 compact vertex-component 顺序保存时间幂指标。
- `stateBits` 保存 (n_i) 类离散函数态，不是第二套 key。未收缩 massive line 每端点一位；massless quotient 整边共享一位；收缩线不保留状态占位。
- 旧 time-only `J[aList,linePacks,{}]` 不兼容，在 020 公开入口直接拒绝。full 模式继续使用 `J[aList,linePacks,ispList]`，不受本次变更影响。

## 公开入口

- `DSSeeds/DSAllSeeds/DSGenerateIBP/DSLinear`、`dtau/ds` 和初始化 derivative metadata 统一返回新表示。
- `DSTreeSeeds/repIterative/DSTreeNaiveIBP/DSTreeNaiveDE/DSTreeDLogDE` 及其 master list 使用同一表示。
- `rep2innerform/rep2outform/rep2Integrand/symmetry` 接受新表示；需要 line metadata 的步骤只在 Private 内临时还原 producer 表示。
- 内部 IBP/EOM/contact producer 沿用 019 三槽实现，由中央 metadata-driven adapter 精确双向转换；没有重写物理公式。
- time-only consumer 的 sector normalization 直接读取 `sectorKey` 对应的冻结 metadata；逆转换后的旧 producer pack 不再用于重新推断 child zero point 或模长幂。

## 验证状态

- mixed 三顶点 `massiveFull + masslessFull quotient` smoke 通过 `25/25`：4 个 reachable sectors、全部合法 state-bit 往返、37 个 general seeds、506 条撒点 IBP、293 个 `linearData` 积分及 lower-sector/simultaneous-sector `ds` 均通过；massive 已缩并 child 的非零 `D Log[N_s]` 另作精确检查。
- 两顶点 massive tree 公式 smoke 通过 `14/14`：5 个全 sector masters，seed、迭代约化、naive IBP/DE、dlog DE 与表示辅助入口均只返回新 time-only `J`。
- mixed 三顶点跨包检查中，dSIBP `ds` 产生的 75 个导数全部经 MadStree `MSReduce` 闭合到同序 15 masters；对 `{k1,k2,k3,sE1,sE2}` 的五个 `15 x 15` 矩阵与 MadStree 直接 dlog 公式逐项严格相等。
- massless quotient 公式型 tree 接口继续保持 `PendingRederivation`，本次表示迁移不绕过该数学门禁。

## 未改变范围

- `DSDE/DSScaleCheck` 仍只消费 KiraImport 验证的 reduction artifact；time-only tree DE 使用专用 tree 接口。本版本不改变 full-loop serializer、Kira、reduction、DE 或 scaling 合同。
- single-massive sunrise 的数值 DE/scaling 闭环仍未执行。
