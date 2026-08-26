# MadStree 独立验证论文资料

本目录只保存 MadStree 当前独立验证任务实际使用的原始论文和已确认勘误。原始 PDF 从仓库
`reference/ref_paper/` 逐字节复制，不修改内容；验证 runner 读取本目录副本并核对 SHA-256。

| 文件 | SHA-256 | 页数 | 对应任务与公式 |
| --- | --- | ---: | --- |
| `2309.10849v2-Inflation Correlators with Multiple Massive Exchanges.pdf` | `4C416F8A7B179E5B5A59B958F73610D4560DF3431AF5A3632424A73BDAFB9D07` | 56 | Validation-07；Eq. (83)、Eq. (103)、Appendix B Eqs. (148)--(151) |
| `2411.03088-Multivariate hypergeometric solutions of cosmological (dS) correlators by d log-form differential equations.pdf` | `34315DA929126E8B455638C168722B6909CD243183B71C4137EEC81B5F0F2EAA` | 34 | Validation-04；Eqs. (3.3)、(3.14)、(3.16)、(4.1)、(4.2)、(4.4)、(4.5)、(4.8)、(4.10)、(4.11) |
| `2411.03088-勘误.md` | `BFC1BCDAC4DEB19AFA11BD5D30BB6C0A8582E4B3C83693529378435A89B8D5C7` | 不适用 | Eq. (4.11) 相对 Eq. (4.2) 定义积分多一个整体因子 `I`；另说明 endpoint basis 因子不属于勘误 |

论文没有给出的单分支闭式、V5.5 源码结果和 MadStree 生产结果不归入“论文公式”列。
