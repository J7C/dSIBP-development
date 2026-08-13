# FlintNDE 效率测试记录

----------
## Step 1: python-flint 线程池响应范围

本步骤只判断哪些底层 FLINT 算术内核会实际响应 `ctx.threads=10`。每组在独立 Python
进程中运行四次，表中 wall time 取中位数；CPU/wall 大于 1 是多核执行的进程级证据。
这些微基准不是 MadStree 三顶点端到端性能结论。

| route | parallel | wall time median | CPU/wall mean | w1/w10 speedup | check/status |
| --- | --- | ---: | ---: | ---: | --- |
| 180x180 `acb_mat` multiplication, twice | w1*1 | 0.498438 s | 0.983 | - | passed |
| 180x180 `acb_mat` multiplication, twice | w10*1 | 0.239898 s | 2.814 | 2.078x | passed; threaded kernel |
| 120x120 `acb_mat.solve` | w1*1 | 0.358749 s | 1.001 | - | passed |
| 120x120 `acb_mat.solve` | w10*1 | 0.299182 s | 1.460 | 1.199x | passed; partial threaded work |
| degree 64, 257-point fast multipoint, 20 repeats | w1*1 | 0.232595 s | 0.974 | - | passed |
| degree 64, 257-point fast multipoint, 20 repeats | w10*1 | 0.232638 s | 0.967 | 1.000x | passed; no observed thread benefit |
| degree 1024, 1024-point fast multipoint | w1*1 | 0.132934 s | 0.999 | - | passed |
| degree 1024, 1024-point fast multipoint | w10*1 | 0.132952 s | 1.083 | 1.000x | passed; no observed thread benefit |

结论：`ctx.threads` 是 FLINT 内部线程池的最大线程数，不会把所有 Python-FLINT 调用自动
并行化。当前实测较大的 `acb_mat` 乘法自动使用线程池，`solve` 只有部分并行收益；当前
fast multipoint 内核未显示可测加速。FlintNDE 的 Python 路径规划、Python 层循环、依赖前一
节点终值的顺序输运以及 MadStree 的段循环仍为串行。矩阵运算是否并行必须按具体内核和规模
判断，不能从对象类型为 `acb_mat` 推断全部自动并行。
