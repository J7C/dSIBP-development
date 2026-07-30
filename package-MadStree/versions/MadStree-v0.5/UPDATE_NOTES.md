# MadStree v0.5 更新说明

## 基线

- 基于冻结版本 `v0.4` 建立。
- v0.4 源码、手册、examples 与验证结果保持不变。

## 新增功能

- 版本根新增 `MadStree.m`；把 `versions/MadStree-v0.5/` 加入 `$Path` 后可直接调用 `Needs["MadStree`"]`。
- 内置 FlintNDE `v0.1.0.dev0` 源码于 `Vendor/FlintNDE/`，缺省 adapter 不再依赖仓库外的平行 `package-FlintNDE` 目录。
- 新增 `MSFormulaData`，一次返回全 sector masters、每个 sector 的 `M1/M0/U` 递推 metadata 和同一 master 顺序的完整 block-triangular dlog DE。
- 新增 `MSWriteFormulaArtifacts`，把 `masters.wl`、`recurrence_metadata.wl`、`dlog_de.wl` 与 `manifest.wl` 写到调用脚本目录，并返回实际输出目录和文件路径。
- `TimePowerRules` 可选代入顶点时间幂 `a_i`；缺省 `Automatic` 保留符号并在 manifest 中列出可代入符号。

## 接口与路径变化

- `MSFlintNDEConfiguration[]` 的缺省相对路径改为 `Vendor/FlintNDE`，基准目录是当前 MadStree 版本目录。
- `MSSetFlintNDERelativePath[path]` 仍是唯一覆盖接口，但 `path` 现在相对当前版本目录解析。
- Python 使用默认 `__pycache__/`；仓库根 `.gitignore` 已忽略任意层级的 `__pycache__/` 与 `*.py[cod]`。只有 JSON、保存点和计算结果属于调用目录产物。
- MadStree 不新增外动量求导算符。新增 DE 检验复用 dSIBP 的 `ds`，再由 MadStree `MSReduce` 约化，并与 `MSDLogDE` 直接公式比较。
- `MSToDSIBPJ/MSFromDSIBPJ/MSFromDSIBPExpression` 已迁移到 dSIBP 020 原生 `J[sectorKey,timeShifts,stateBits]`；不再生成或解析 019 的 root-line packs。跨包使用时两边 context 的 sector/state-slot schema 与逐 sector normalization 必须一致。

## 迁移

- v0.4 的显式加载路径可改为把 v0.5 版本根加入 `$Path`；无需再把 `Kernel/` 直接加入 `$Path`。
- 依赖仓库平行 FlintNDE 的脚本可删除手工路径设置。若要使用另一个随版本放置的后端副本，再调用 `MSSetFlintNDERelativePath`。
- 需要落盘公式数据的脚本调用 `MSWriteFormulaArtifacts`；相对 `MSOutputDirectory` 始终以调用脚本目录为基准。

## 验证状态

- 阶段性 package/artifact smoke 已 fresh 通过 `16/16`，覆盖版本根加载、Vendor 可用性、全 sector 数据、`a_i` 保留/代入和调用目录写出。
- 020 adapter 加入后 package/artifact smoke 扩展并 fresh 通过 `18/18`。mixed 三顶点跨包 DE 的 75 个导数均闭合到 15 masters；统一 massive child normalization 后，`{k1,k2,k3,sE1,sE2}` 五个 `15 x 15` 矩阵与直接公式逐项严格相等，检查通过 `9/9`。
- dlog contact event phase 已对齐两类公式原子：pure massive 使用 component `phaseSign`，含 masslessFull 的 event 使用 `(-1)^N0`。2401 Eq. (3.68) core `49/49`、正负 massless 定义积分/FlintNDE `9/9`、三边 simultaneous/cycle/chart `22/22` 与跨包 DE `9/9` 同时通过。
- v0.5 全部 11 个开发 tests 和三个 examples 已串行 fresh 通过。T1--T6 独立验证分别通过 `24/24`、`12/12`、`18/18`、`15/15`、`17/17`、`16/16`；正式报告和机器 summary 均保存在版本化独立验证目录。T1 的 25 态与 15 态边界由 v0.5 分别直接生成；T6 由 Wolfram 公开入口调用内置 FlintNDE。

## 已知限制

- 不生成一般 IBP 方程组，不运行 Kira，也不复制 dSIBP 的外动量求导实现。
- `MSFormulaData` 只在 `MSDLogDE` 已通过公式 dlog 认证时返回成品数据；未闭合 contact shift 或 normalization 时 fail closed。
- 内置 FlintNDE 的数学能力边界与来源版本一致；vendor 不扩大其 irregular/Stokes 覆盖范围。
