# Kira 2.3 fresh reduction 摘要

- 命令工作目录：`package-dSibp/check/incremental-paper-de/bubble-fresh/kira`
- Kira：`2.3 (Git: 2.3-7-geb541f9)`，external FireFly with FLINT。
- 输入：6,006 equations；Kira fresh stdout 报告 3,211 zero、2,795 independent。
- mandatory targets：215。
- selected equations：1,500。
- masters：19。
- unreduced integrals：0。
- `kira.log` 总时间：约 100 s。

成功命令：

```powershell
wsl --cd /mnt/f/Agent-projects-nut/dSibp_package/package-dSibp/check/incremental-paper-de/bubble-fresh/kira env FERMATPATH=/home/jiaqichen/Softwares/ferl6/fer64 /home/jiaqichen/Softwares/kira/kira/src/kira/kira jobs.yaml
```

首次未设置 `FERMATPATH` 的启动没有进入 reduction，不计入上述结果。
