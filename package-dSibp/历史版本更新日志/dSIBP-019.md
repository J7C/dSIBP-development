# dSIBP 019 更新说明

## 基线

- 基于冻结代码版本 `018_dSIBP` 与正式发布 `018.1` 建立。
- 019 继续继承部分带 `018` 后缀的 Private 模块名；这些是实现谱系，不是运行时版本号。

## 接口与 convention 变化

- 仅对 `ibpMode -> "timeOnly"`，canonical `sectorKey` 改为按 root `linePacks` 顺序排列的定长 `0/1` 字符串。
- `0` 表示对应 root propagator 已收缩，`1` 表示未收缩；不能发生 contact shrink 的位始终为 `1`。
- top sector 是全 `1` 字符串。key 必须作为 `String` 保存，前导零不可删除。
- sector metadata 新增 `rootLineCount`、`rootLineOrder`、`sectorBits` 与 `sectorKeySchema`。
- full loop 工作流继续使用 018 的 `"top"` / shrunk-line-list key，Kira/reduction 接口不因本次变更迁移。

## 迁移

- time-only 调用方不要硬编码 `"top"`；从 top sector metadata 读取 key，或按 root line 数构造全 `1` 字符串。
- 旧 time-only `"e1_e2_e4"` 在四条 root propagator 的输入中改为 `"0010"`。
- `J[aList,linePacks,{}]` 的 root-ordered full/shrunk pack pattern 仍是可逆的 sector 物理身份；显式 key 只能由该 pattern 派生。

## 验证状态

- modular time-only massless endpoint/contact 检查通过 `9/9`。
- 四传播子前导零与路径合并检查通过 `7/7`，收缩 `{1,2,4}` 唯一得到 `"0010"`。
- 019.0 单文件正式交付已由同字节候选晋升；time-only example 05 在候选与正式路径均退出 `0`，massive dlog 与 naive DE 严格一致，massless quotient 保持既有 fail-closed 边界。
- 程序候选与正式文件 SHA-256 均为 `2E6CDF020FA6B69BADD397759A0B735210D3912C301897DC4ECFF4B63C4C5CFD`。
- 56 页手册候选与正式文件 SHA-256 均为 `45B5AA81B2FEB96F30C0777373867362730B8D0472CFC0FBE04D60B70A410E96`；封面、新位串公式页和末页已目检通过。

## 已知限制

- 本版本不改变 full-loop serializer、Kira import/export、reduction、DE 或 scaling 公式。
- single-massive sunrise 的数值 DE/scaling 闭环仍未执行，本次不重跑。
