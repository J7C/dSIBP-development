"""设置 python-flint 线程数后原样执行 MadStree 正式 adapter。"""

from __future__ import annotations

import runpy
import json
import os
import sys
import time
from pathlib import Path

from flint import ctx


threads = int(sys.argv[1])
adapter = Path(sys.argv[2]).resolve()
wall_start = time.perf_counter()
cpu_start = time.process_time()
ctx.threads = threads
if int(ctx.threads) != threads:
    raise RuntimeError("python-flint did not retain the requested thread count")
sys.argv = [str(adapter), *sys.argv[3:]]
try:
    runpy.run_path(str(adapter), run_name="__main__")
finally:
    diagnostic_path = os.environ.get("MADSTREE_THREAD_DIAGNOSTIC")
    if diagnostic_path:
        wall = time.perf_counter() - wall_start
        cpu = time.process_time() - cpu_start
        with Path(diagnostic_path).open("a", encoding="utf-8", newline="\n") as stream:
            stream.write(json.dumps({
                "pid": os.getpid(),
                "requested_threads": threads,
                "effective_threads": int(ctx.threads),
                "wall_seconds": wall,
                "cpu_seconds": cpu,
                "cpu_over_wall": cpu / wall,
            }) + "\n")
