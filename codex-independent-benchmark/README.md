# Codex 独立手推与 package 检查

本目录是 Codex 依据 `independent-benchmark/independent-benchmark.md` 建立的独立工作区，不属于正式 benchmark 输入目录，也不覆盖项目已采用的 hand-derived expected。

## 边界

- 第一阶段只从任务书给出的传播子定义、指标 convention 和标准 Hankel 恒等式推导 expected。
- 第二阶段读取 `independent-benchmark/package/package_012.wl` 生成 actual；actual 暴露的 oracle 错误必须先从任务书定义独立复核再修正。当前 v7 是补全 `sij/Dij` convention 后的 post-audit 快照，不宣称为 pristine blind freeze。
- `atomic_massive_line/` 保存可人工复核的 family、推导和 expected。
- `check/` 保存只读 expected/package 的对照脚本；运行产物放在被 Git 忽略的 `check/results/`。
- 本目录不会成为主线 package 的输入，也不会写入 `independent-benchmark/package/`。

## 当前范围

- `atomic_massive_line` 按固定 `--/-+` 保存 direct-h、bare-H、H-to-h 三路共 78 条 expected。
- 其余九个 family 由 `oracle/independent_oracle.wl` 按 `ORACLE_DERIVATION.md` 的原始公式展开。
- 十个 family 共生成 2435 条 seed relations、101 条 general-index derivatives 并全部通过 package 对照；reference-only 另有 80 条 derivative、6 条 symmetry 和 4 条 parity。
- `vertex_energy_signs` 已显式加入 `rho1=sp[ell,k]`，覆盖 ISP 点 `{0,1}`，通过 90/90 relations 与 24/24 derivatives。
- 任务书现已把对称 `sij` 坐标与有序 `Dij` 算符分开定义，并固定 upper-triangular `{Dij|i<=j}` raw basis；独立 expected/check 已依此重生并与 package 对齐。
