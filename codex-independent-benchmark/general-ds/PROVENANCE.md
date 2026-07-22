# General-`ds` provenance

这组补充原语是在本轮已经阅读 `package_014.pdf` 的公开 convention，并检查过 `package_014.wl` 的公开接口及旧 `ds` 自证问题之后编写，因此不属于 `FROZEN_STAGE1.sha256` 的 blind freeze。

公式输入仍限制为最新版任务书第 6.5、13.1、15.1 节给出的 `sij`/有序 `Dij` 定义、顶点相位和乘积法则。`expected.wl` 没有加载 package，也没有调用 `ds`、package decomposition 或旧 expected。后续 package 对照若失败，不修改本 expected 追随 actual，而是逐项检查坐标矩阵、phase、building block、ISP 与 canonical 组合。
