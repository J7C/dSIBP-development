# 来源隔离记录

允许的手推输入是最新版 `independent-benchmark/independent-benchmark.md`、其中点名的公开 Hankel 恒等式和 2401.00129 公式。补充 expected 冻结前不读取 `package_014.wl` 或用户手册内容。

本轮开始时已审阅 `000-report/2026-07-22-0543-014-内部.md` 及其 phase2 check 结构，用于确认旧检查把 `seedRanges["isp"]` 固定为 `{0}`，并确认旧 general `ds` check 在 expected 一侧再次调用了 package `ds`。因此本轮不能声称 pristine blind provenance。以下新公式只从任务书的 propagator、ISP 和 total derivative 定义重新推导；旧 frozen expected 与 package actual 不作为公式输入。

阶段 1 冻结后才读取 `independent-benchmark/package/package_014.pdf` 和 `package_014.wl` 的公开调用接口。若 package 对照失败，不修改 frozen expected 追随 actual，而是回到相应推导逐式归因。
