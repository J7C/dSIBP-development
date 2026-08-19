# dSIBP 022.0 更新说明

## 基线与范围

022.0 基于 021.0 的公式、IBP producer、time-only 表示和 backend-neutral `linearData`
合同，破坏性重写 topology 输入边界。当前版本不保留旧字段、别名、wrapper、fallback、
旧 schema 解析或兼容测试。

## 公开 topology

- 顶点唯一格式为
  `<|"id"->1,"vertexType"->"+","externalLegEnergy"->E1|>`。
- `vertexType="+"` 给 `Exp[-I externalLegEnergy tau]`，`"-"` 给
  `Exp[+I externalLegEnergy tau]`。
- line 唯一基础字段为 `id/massType/endpoints/momentum`；massive line 另需 `nu`，
  可选 `functionSystem -> "h"|"H"|Association`。massless line 不读取 `nu/functionSystem`。
- 圈外向量和无圈模长基分别使用 `loopExternalMomenta` 与
  `independentExternalMomenta`；动力学坐标只使用统一 `kinematicRules`。
- seed 范围、数值代入和 Kira ordering 由各自工作流入口持有，不属于 topology。

已物理删除 `vertexData/vertexEnergies/lineData`、旧 line 五元组、`bbType`、
`eomCoefficients`、line-local `shrinkPrefactor/skType/packType/state`、旧运动学字段和
用户可覆盖的 contact-sector 内部元数据。Association 的额外键可以被忽略，但不能补足
缺失的现行必需键或覆盖派生值。

## 内部实现

- root parser 与 contact-sector constructor 分离；sector 直接从已解析 root topology
  构造 active vertices、代表映射、零点、line packs 和 normalization，不再重入公开 parser。
- line 的 SK、pack、state、theta 和 contact 数据只由端点 `vertexType`、质量类型及收缩状态
  派生。
- 圈外向量有效基统一为 `effectiveLoopExternalMomenta`，不再读取旧
  `externalMomenta/externalLegMomenta`。
- 修正 `resolveKiraOrderingSpec` 的参数 pattern；显式 `DSReorderIntegrals` 后 ordering
  始终是 Association，不再由 `Join::incpt` 把完整 `linearData` 展开到 stdout。

## 加载与引用

全部关键模块及代表定义完整加载后，每个 Wolfram kernel 显示一次简洁引用提醒。
Notebook 使用可点击 `Hyperlink`；headless 输出完整 URL。条目严格为
`2401.00129`、`2411.03088`、`2604.14549` 和
`dSIBP package paper, arXiv identifier pending`。

## 迁移

调用方必须按 022 schema 重写 topology。旧 021 输入不会被自动转换。标准入口是把
`versions/022_dSIBP/` 加入 `$Path` 后调用 `Needs["dSIBP`"]`；正式单文件为
`independent-benchmark/package/package_022.0.wl`。

## 验证状态

- topology schema 与相位检查 `16/16`。
- 参数导数 `11/11`、圈数 `7/7`、Kira 能量 convention `16/16`、API example coverage
  `6/6`、ISP `13/13`、UserMI `17/17`。
- sunrise 的 2 个 time generators、6 个 momentum generators 与 5 个 sector parity
  检查通过。
- module ownership 扫描 23 个 Kernel 文件、361 个顶层符号，无跨文件同签名重复。
- Example 01 fresh 生成 5516 条方程，stdout 8,924 字节、stderr 0，无 `Join::incpt`。
- Example 04 fresh 生成 57,160 条 IBP 方程并序列化 Kira 输入；状态为
  `awaitingExternalKira`，本轮未运行外部 Kira reduction。

最终 full smoke、全部 examples、正式单文件、PDF、UTF-8 和独立任务书重测状态以根
`研究计划与研究进度.md` 的本轮验收记录为准。

## 已知限制

dSIBP 只生成和序列化关系，不运行 reduction。外部 Kira artifact 缺失时，DE/scaling
闭环保持等待状态，不能用 serializer 成功代替 reduction 通过。

## 2026-08-19 审计清理

- `resolveKinematicRulesForCase` 只读取当前 `kinematicRules`；四个已退休的
  `loopKinematicRules/magnitudeKinematicRules/resolvedLoopKinematicRules/`
  `resolvedMagnitudeKinematicRules` 在 raw case preflight 中定向失败，不能再改变 topology。
  其它无语义冲突的额外 Association 键仍按 022 合同忽略。
- `materializeSectorPrefactor018` 不再从 `parameterList/powerList` 重建缺少 `kEPower` 的旧
  metadata；缺少结构主字段时返回 `MissingStructuralKEPower`。
- 模块路径、候选单文件和正式单文件分别通过 topology `17/17`、normalization `14/14`、
  参数导数 `11/11` 与死定义 `17/17`。正式 `package_022.0.wl` 与验收候选 SHA-256 同为
  `7E9894EF3881F61AF01D0B32C597E8840D5A0FC2C883D189BE8A532C5FED3351`。
