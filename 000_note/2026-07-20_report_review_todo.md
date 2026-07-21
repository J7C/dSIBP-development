# 外部报告纠错与 theta bundle 实施 TODO

日期：2026-07-20

权威审查结论见 `000_note/2026-07-20_report_review_and_theta0.md`。

## A. 公式与实现

- [x] 独立推导共同 theta 的 odd-subset 恒等式。
- [x] 给出统一高斯 `rho_eps/H_eps` 的逐传播子自洽定义。
- [x] 修正 massless shrink：`aShift=0`、`bShift=0`。
- [x] 保留 massive Wronskian 的整数 `aShift=bShift`。
- [x] 实现 bundle-aware time boundary 与 simultaneous multi-line contact。
- [x] 把所有幂集 sector 改成 contact-reachable BFS。
- [x] 增加 coincident massive `{b,1,0}->{b,0,1}` canonical。
- [x] 确认 coincident full line 不会再次产生 theta boundary。

## B. 独立 expected 与报告争议

- [x] 修正 atomic massless shrink expected。
- [x] 修正 mixed/pure bubble 的 massless `a`、sector 覆盖和 massive coincidence canonical。
- [x] 修正 triangle 的可达 sector、massless `a` 与 massive coincidence canonical。
- [x] 修正通用 manual engine 的 odd-subset contact 与 BFS sector。
- [x] 确认 cross momentum 的 `b->b-1`，并纠正“额外 IBP 负号”解释。
- [x] 确认 massive momentum untouched endpoint 状态保持。
- [x] 确认 atomic massless `n=0` 外部硬编码符号错误。
- [x] 确认 pure massless bubble 是外部手推/比较脚本错误，不是 ISP convention。
- [x] 确认 mixed triangle 是外部 incidence/endpoint 错误。
- [x] 记录外部比较脚本未加载所声称 expected，16/30 统计不可作为完整 benchmark 结论。
- [x] 复现检查正式 example 无显式编码时成功；把 UTF-8 结论降为未证实的 portability risk。

## C. 文档与交付

- [x] 更新 README、plan、design note、tech note 与正式用户手册。
- [x] 更新 independent benchmark 的 sector/contact 任务规范。
- [x] 更新各 hand-derived family README 中的旧“所有子集/future bundle”表述。
- [x] 重编译并目视检查 tech note 与用户手册 PDF。
- [x] 当时已同步无版本名 package 快照；2026-07-21 发布规则已改为只保留 `package_012.wl` 与 `package_012.pdf`。
- [x] 在外部 `000_report_v011` 目录新增 `report-of-report.md`，不修改两份原报告。

## D. 最终验收

- [x] `000_code/test/012_theta_bundle_and_report_audit_test.wl`：30/30。
- [x] `000_code/test/012_legacy_handcheck_oracle_audit_test.wl`：6/6，证明旧 package 与旧 expected 同源通过。
- [x] 十个 hand-derived family 的受影响回归全部通过。
- [x] 以 012 运行 function-system、massless direction、scalar-product、public API、serializer 等继承回归。
- [x] 运行结构/example 检查，确认新 sector count 已更新。
- [x] 比较主线与 benchmark package snapshot hash。
- [x] 运行 `git diff --check` 和最终文档矛盾扫描。
