# MadStree v0.4 更新说明

## 基线

- 基于冻结版本 `v0.3` 建立。
- v0.3 源码、手册、examples 与验证结果保持不变。

## 接口与 convention 变化

- time-only `sectorKey` 改为按初始化时 root propagator 顺序排列的定长 `0/1` 字符串。
- `0` 表示对应传播子已经收缩，`1` 表示尚未收缩；不能 contact shrink 的传播子位始终为 `1`。
- top sector 是全 `1` 字符串。key 的存储类型是 `String`，前导零不可删除。
- `context["sectorKeySchema"]` 保存 `rootLineOrder`、位宽和位语义；`MSIntegral` 第一参数、contact transition、sector/master metadata、递推、dlog 与边界统一使用该 key。

## 迁移

- 旧 `"top"` 改为 `First[context["sectorOrder"]]`，或按 schema 写出对应的全 `1` 字符串。
- 旧 `"contracted:e1,e3"` 改为按 `rootLineOrder` 写出的位串。例如顺序 `{e1,e2,e3,e4}`、收缩 `{e1,e2,e4}` 对应字符串 `"0010"`。
- 不要把 key 转成整数；`"0010"` 与 `"10"` 属于不同宽度的 sector schema。

## 验证状态

- 开发检查已通过：core `49/49`、simultaneous/time-only chart `22/22`、vertex/reduction `18/18`。
- 三个随包 examples 已 fresh 运行并退出 `0`。
- 受 sector key 影响的 T1--T5 已按 v0.4 任务书 fresh 通过：`24/24`、`12/12`、`18/18`、`15/15`、`17/17`。T1 实际 sector keys 为 `{"11","01","10","00"}`；T5 triangle keys 为 `{"111","011","101","110","001","010","100"}`。
- T6 只验证 FlintNDE 保存点、调用目录和奇点能力边界，不依赖 sector key，本轮未重跑。
- 公式手册经 BibTeX 与两遍 XeLaTeX 重编译为 28 页，日志无未定义引用；封面、含 `"0010"` 的第 10 页和末页已渲染目检。TeX/PDF SHA-256 分别为 `4211B8FD127CC49D4684F88F79298FFB4C7EAF68F9F6A72DC36AE49666F6C6B8`、`7E8F4EBEE3B8FB75791C72A8C6210E09E865CA385EA822F7B12622B699CB6FA8`。

## 已知限制

- 本次不改变 recurrence、dlog、Frobenius boundary 或 FlintNDE 的数学公式与能力边界。
- key 只编码 root propagator 的收缩状态；component、slot、state bits 与 time shifts 仍由 sector metadata 分别给出。
