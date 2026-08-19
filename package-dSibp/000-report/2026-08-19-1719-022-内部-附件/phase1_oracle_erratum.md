# Phase 1 论文 oracle 转录勘误

- 执行者：`46449-Codex022Independent`
- 日期：2026-08-19（Asia/Shanghai）
- 原 oracle：`paper_oracle_phase1.wl`
- 原 oracle SHA-256：
  `82D0685AD8FE74E48F9203AB2BDBD5062A9F3C78FCDAE8830CBE53A5BC56264D`
- 原 oracle 保持原字节，不覆盖、不重命名。

## 发现时点与边界

原 oracle 在 candidate/reference 开放前已冻结。Phase 2 运行后，候选 naive/direct 两路均与
项目 reference 得到三变量 `25/25`，但原 oracle 与 reference 的 `k34`、`ks` 矩阵不一致。
本勘误不从该差矩阵反解符号，而回到 Phase 1 已下载和冻结的公开 arXiv TeX 原文重新转录。

公开来源身份：

- arXiv e-print archive SHA-256：
  `409457E1609AFE389D70BF86495F36B8A1C97D64F12B8159DE2C282472C5D37F`
- `dS_DEsol.tex` SHA-256：
  `61BD6F74FDEB67AE5D1EF15593E1A71BC7AF4AC15DE71D14FFEE8B5CC33558FC`
- 原文位置：`dS_DEsol.tex:1180`，Eq. (4.5) 的 `R` 第四项。

原文第四项与第一项相同：

```text
i/2 [ Log(k12-ks) - Log(k12+ks)
    + Log(k34-ks) - Log(k34+ks) ].
```

## 原错误与修正

原 oracle 的第四项错误写成：

```text
i/2 [ Log(k12-ks) - Log(k12+ks)
    - Log(k34-ks) + Log(k34+ks) ].
```

修正后的第四项严格重转录为公开 TeX 的表达式：

```text
i/2 [ Log(k12-ks) - Log(k12+ks)
    + Log(k34-ks) - Log(k34+ks) ].
```

错误只影响论文 `R[[4]]` 的 `k34/ks` 导数；Wronskian、normalized-sector 分层、固定
endpoint adapter、master 顺序和其它三项 `R` 不变。修正文件为
`paper_oracle_phase1_corrected.wl`，其 SHA-256 在单独自检后记录到
`phase1_corrected_check_summary.wl` 和最终 `candidate_summary.wl`。
