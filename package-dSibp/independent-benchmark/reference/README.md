# dSIBP 独立 benchmark 论文资料

本目录只保存 dSIBP 当前独立任务书实际使用的原始论文和已确认勘误。原始 PDF 从仓库
`reference/ref_paper/` 逐字节复制，不修改内容；独立执行者必须先核对 SHA-256，再冻结 expected。

| 文件 | SHA-256 | 页数 | 对应任务与公式 |
| --- | --- | ---: | --- |
| `2401.00129v5-Towards Systematic Evaluation of de Sitter Correlators via Generalized Integration-By-Parts Relations.pdf` | `48775EEB8949D62B1AD02D8E6F4B21B5602247F9F83016551378FE95FF9DE619` | 26 | 第 14 节；Eq. (3.33) 的 vertex-basis 二进制顺序 |
| `2411.03088-Multivariate hypergeometric solutions of cosmological (dS) correlators by d log-form differential equations.pdf` | `34315DA929126E8B455638C168722B6909CD243183B71C4137EEC81B5F0F2EAA` | 34 | 第 15.6 节；Eqs. (3.3)、(4.1)、(4.2)、(4.4)、(4.5) |
| `2604.14549v3-Loop integrals in de Sitter spacetime - The parity-split IBP system and d log-form differential equations.pdf` | `402B6C2687E148E26DF7CD5BE81C0A828EB1BA25BD18D409B9A0601040C9C057` | 14 | 第 15.7 节；supplementary 的 19×19 d log DE 三套矩阵与 19-master basis（v3 于 2026-10-09 更正主积分与 alphabet，正文 Eq. (32) 给出三字母 alphabet） |
| `2411.03088-勘误.md` | `CD57EA324AB0B2F399E596F5E9DFF0555804BFF995646FBE093BC239CC067B3E` | 不适用 | Eq. (4.11) 相对 Eq. (4.2) 定义积分多一个整体因子 `I`；另说明 endpoint basis 因子不属于勘误 |

`reference-results/pure_massive_bubble/reference_probe.wl` 的对照数据是 arXiv:2604.14549 **v3**
supplementary 构造：2026-10-15 下载 v3 ancillary 文件比对，其四个源文件（`full19_connection/DEP0.m`、
`full19_connection/DEks.m`、`full19_connection/DEscaleCheck.m`、`basis/MIdlogNote.m`）与 v3
supplementary_files 逐字节一致（SHA-256 4/4），作者同日确认该构造出自该论文。因此它列为该论文 v3
supplementary 矩阵的 oracle，服务第 15.7 节的 361/361 对照门禁。bundle 于 2026-10-08 从
`F:\Agent-projects-nut\dSibp\code_final_version\` 复制并变换、没有重新生成 reference IBP 也没有运行
reference Kira 的事实不变；既有解析代码身份与哈希登记见
`reference-results/pure_massive_bubble/README.md`。
