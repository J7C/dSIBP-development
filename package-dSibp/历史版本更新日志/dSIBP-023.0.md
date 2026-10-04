# dSIBP 023.0 更新说明

## 基线与范围

023.0 基于 022.0 的严格 topology schema、统一 `J` 表示、IBP producer、Kira 数据流和
tree vertex-family 接口。该版本修正 same-branch massive contact 的物理符号与 child
normalization，并增加时间 IBP 小端点整数门禁。公开 topology 格式不变，也不增加兼容入口。

## Massive Contact Convention

- `++/--` contour sign 只由传播子两个端点的 `vertexType` 派生：`++ -> +1`、`-- -> -1`。
- raw massive contact 使用同一个 contour sign、有序端点方向、odd endpoint state 和编译后的
  Wronskian `shrinkTerms`；已删除 `thetaBoundarySignOffset` 及其全部调用。
- contact child 的 complete normalization 吸收同一个 contour sign 和 Wronskian 常数。
  因此 raw coefficient、`N_source/N_target` 与 normalized coefficient 只有一套约定，不能靠
  `++/--` 分支中的错误相消得到表面一致的结果。
- general seed、pure-time recurrence、naive tree DE 与 direct dlog DE 共用该 convention。

## 时间 IBP 小端点门禁

- `DSInit` 在全部 contact-reachable sector 中使用已知 h/H 领头幂次表，枚举实际 endpoint
  state 与两支局部行为。
- 任一顶点的 Gamma 参数可被精确证明为整数时，未正规化 family 被拒绝，并在用户消息中列出
  对应顶点和参数。正整数同样拒绝，因为无界整数 IBP 移位最终会命中非正整数端点。
- 含 generic 符号 regulator 的 family 允许继续；程序不以 normalization 或其它发散项作形式相消。
- 自定义函数系统无法由现有 h/H 表完全分类时，只给出自然语言提醒，不猜测端点行为。

## 清理与接口

- 生产表示继续只保留 massless quotient shared state；没有 `RedundantH`、massless endpoint
  四态公开表示、wrapper、fallback 或旧 schema 读取。
- 022 公开 topology 保持不变：顶点使用 `id/vertexType/externalLegEnergy`，line 使用
  `id/massType/endpoints/momentum`，massive line 另需 `nu`，可选 `functionSystem`。
- dSIBP 不提供边界条件或数值输运，也不调用 MadStree/FlintNDE。
- `DSScaleCheck` 对 post-derivative 工作流同时返回符号 Euler residual 与物理精确点 residual。
  `matrixResidual/sourceResidual` 是符号硬门禁；`pointMatrixResidual/pointSourceResidual` 是同一关系
  的精确点复核。DE 变量不会被点值规则替换后冒充符号检查。

## 迁移

使用 022 schema 的调用不需要改 topology。由于 contact/normalization convention 属于物理结果
修正，022 生成的 same-branch massive contact、相关 tree recurrence、DE 或 Kira 输入不能作为
023 的缓存继续使用，必须从 023 源码重新生成。

## 验证状态

- 模块化专项覆盖 `++/--`、两个端点、`10/01`、general/pure-time、raw/child/normalized 三层，
  通过 `6/6`。
- tree normalization、naive/direct dlog exact 检查通过 `14/14`。
- 全部 17 个维护侧 smoke 从 023 模块化路径 fresh 运行，失败数为 0。
- source-isolated Phase 1 从空目录重生：local `10/10`、family descriptor `168/168`、validator
  `31/31`，time/momentum/operator 为 `976/1363/64`；19/19 冻结文件与 4/4 authority source
  立即复验通过，accepted digest 为
  `C4B0FD204E3B2951E46471B356A9F7B201BCA241FC63832E90A0060EAA8409A9`。
- Phase 2 与 WSL Kira full flow 已完成：pure massive bubble 为 19 masters、215 targets、
  `unreduced=0`、墙钟 `91.03 s`；mixed bubble+tree 为 81 masters、676 targets、
  `unreduced=0`、墙钟 `160.11 s`。两者均使用 Kira 2.3 和 `w10*1`，完整 consumer 闭合。
- 两套 Kira 工作树均在仓库外生成并由 WSL 运行。正式 04/06 examples 只保留输入脚本、轻量
  input/result summary；`init/`、`kira/`、database、save、日志、reduction table、cache 和 DE
  运行目录已删除，不作为 Git 资产。

## 已知限制

dSIBP 只生成和序列化关系，不运行 reduction。公式型 tree 迭代/DE 当前只支持已经独立推导的
massive-only quotient；含 massless full line 时保持 `PendingRederivation`，不恢复冗余四态路线。
