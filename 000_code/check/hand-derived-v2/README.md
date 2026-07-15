# hand-derived-v2

本目录只保存按 007 新 convention 重新独立推导并经人工审查的项目内 benchmark。旧 `hand-derived/` 已整体删除；禁止从旧 expected 复制、改名或做 notation 迁移。

推导任务以根目录 `independent-benchmark/independent-benchmark.md` 为准，但本目录不是给外部 AI 的任务输入目录。外部 AI 的原始结果应先留在它自己的目录，审查通过后才能整理到这里。

每个函数族使用：

```text
<family-name>/
  README.md
  family.wl
  expected.wl
  check.wl
  derivation.md   # 仅在需要人工审查代表推导时
```

强制要求：

- 所有顶点 `+/-` 组合。
- 每个符号 case 的所有实际可达 sector。
- 每个 sector 的全部 active time 生成元和全部 `L(L+K)` momentum 生成元。
- 每个 sector 的全部 massive/masslessFull 离散 `n=0/1` 状态。
- 非零符号 `a0/b0/bS0`。
- massive `n=2` 即时 EOM；massless 只允许 `0/1`。
- expected 不调用主线 seed 生成函数。
- 每完成一个函数族立即单独运行提权 WolframScript check，并把计数写回根目录 `研究计划与研究进度.md`。
- 禁止大范围解析生成、宽范围撒点和运行 Kira/Fermat。

计划函数族和完成状态以 `研究计划与研究进度.md` 为准。
