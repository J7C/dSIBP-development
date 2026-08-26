# dSIBP 独立 benchmark 论文资料

本目录只保存 dSIBP 当前独立任务书实际使用的原始论文和已确认勘误。原始 PDF 从仓库
`reference/ref_paper/` 逐字节复制，不修改内容；独立执行者必须先核对 SHA-256，再冻结 expected。

| 文件 | SHA-256 | 页数 | 对应任务与公式 |
| --- | --- | ---: | --- |
| `2401.00129v5-Towards Systematic Evaluation of de Sitter Correlators via Generalized Integration-By-Parts Relations.pdf` | `48775EEB8949D62B1AD02D8E6F4B21B5602247F9F83016551378FE95FF9DE619` | 26 | 第 14 节；Eq. (3.33) 的 vertex-basis 二进制顺序 |
| `2411.03088-Multivariate hypergeometric solutions of cosmological (dS) correlators by d log-form differential equations.pdf` | `34315DA929126E8B455638C168722B6909CD243183B71C4137EEC81B5F0F2EAA` | 34 | 第 15.6 节；Eqs. (3.3)、(4.1)、(4.2)、(4.4)、(4.5) |
| `2411.03088-勘误.md` | `CD57EA324AB0B2F399E596F5E9DFF0555804BFF995646FBE093BC239CC067B3E` | 不适用 | Eq. (4.11) 相对 Eq. (4.2) 定义积分多一个整体因子 `I`；另说明 endpoint basis 因子不属于勘误 |

`reference-results/pure_massive_bubble/reference_probe.wl` 是既有解析代码 reference；当前来源记录
没有给出可核验的原论文身份或公式号，因此不把它列作论文 oracle。
