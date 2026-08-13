"""比较 Python-FLINT 1/10 线程下底层算术内核。

每次调用只运行一个线程配置，供外层以独立 Python 进程交错重复。本脚本只判断
底层 ``acb_poly`` 与 ``acb_mat`` 是否实际响应 ``ctx.threads``；真实三顶点、
9 master、900 点的 MadStree 端到端测试由 Example 04 专用 runner 负责。
"""

from __future__ import annotations

import argparse
import json
import os
import sys
import time
from pathlib import Path
from typing import Any, Callable


SCRIPT_PATH = Path(__file__).resolve()
RESULTS_DIR = SCRIPT_PATH.parent / "results_test"

sys.dont_write_bytecode = True

from flint import acb, acb_mat, ctx  # noqa: E402


def timed(call: Callable[[], Any]) -> tuple[Any, float, float]:
    """返回结果、墙钟和进程 CPU 时间。"""

    wall_start = time.perf_counter()
    cpu_start = time.process_time()
    result = call()
    return result, time.perf_counter() - wall_start, time.process_time() - cpu_start


def run_large_fast_multipoint(degree: int = 1024, point_count: int = 1024) -> dict[str, Any]:
    """直接测试较大 ``acb_poly.evaluate(fast)`` 是否进入 FLINT 线程池。"""

    from flint import acb_poly

    polynomial = acb_poly(
        [acb((index * 17) % 101 - 50, (index * 11) % 97 - 48) / acb(101)
         for index in range(degree + 1)]
    )
    points = [
        acb(index - point_count // 2, (index * 13) % 103 - 51) / acb(2048)
        for index in range(point_count)
    ]
    values, wall, cpu = timed(lambda: polynomial.evaluate(points, algorithm="fast"))
    return {
        "degree": degree,
        "point_count": point_count,
        "wall_seconds": wall,
        "cpu_seconds": cpu,
        "cpu_over_wall": cpu / wall,
        "checksum": [values[0].str(20), values[-1].str(20)],
    }


def deterministic_matrix(size: int, offset: int) -> acb_mat:
    """构造无需随机数且两种线程配置逐项相同的稠密 Acb 矩阵。"""

    return acb_mat(
        [
            [
                acb(
                    ((row * 17 + column * 13 + offset) % 101) - 50,
                    ((row * 7 - column * 11 + offset) % 97) - 48,
                )
                / acb(101)
                for column in range(size)
            ]
            for row in range(size)
        ]
    )


def run_matrix_multiply(size: int = 180, repetitions: int = 2) -> dict[str, Any]:
    """测试较大稠密 Acb 矩阵乘法是否实际使用 FLINT 线程池。"""

    left = deterministic_matrix(size, 3)
    right = deterministic_matrix(size, 19)

    def multiply() -> acb_mat:
        result = left * right
        for _ in range(repetitions - 1):
            result = left * right
        return result

    result, wall, cpu = timed(multiply)
    return {
        "matrix_shape": [size, size],
        "repetitions": repetitions,
        "wall_seconds": wall,
        "cpu_seconds": cpu,
        "cpu_over_wall": cpu / wall,
        "checksum": [result[0, 0].str(20), result[size - 1, size - 1].str(20)],
    }


def run_matrix_solve(size: int = 120) -> dict[str, Any]:
    """测试稠密 Acb 线性求解是否实际使用 FLINT 线程池。"""

    matrix = deterministic_matrix(size, 7)
    for index in range(size):
        matrix[index, index] += acb(size)
    right = acb_mat([[acb((row * 19) % 103 - 51) / acb(103)] for row in range(size)])
    result, wall, cpu = timed(lambda: matrix.solve(right))
    return {
        "matrix_shape": [size, size],
        "right_hand_side_shape": [size, 1],
        "wall_seconds": wall,
        "cpu_seconds": cpu,
        "cpu_over_wall": cpu / wall,
        "checksum": [result[0, 0].str(20), result[size - 1, 0].str(20)],
    }


def main() -> None:
    """设置线程上限，运行微基准并以显式 UTF-8 保存机器结果。"""

    parser = argparse.ArgumentParser()
    parser.add_argument("--threads", type=int, required=True, choices=(1, 10))
    parser.add_argument("--label", required=True)
    args = parser.parse_args()

    ctx.threads = args.threads
    if int(ctx.threads) != args.threads:
        raise RuntimeError("python-flint did not retain the requested thread count")

    total_start = time.perf_counter()
    payload = {
        "schema": "python_flint_thread_microbenchmark_v1",
        "label": args.label,
        "pid": os.getpid(),
        "requested_threads": args.threads,
        "effective_threads": int(ctx.threads),
        "working_precision_bits": int(ctx.prec),
        "large_fast_multipoint": run_large_fast_multipoint(),
        "matrix_multiply": run_matrix_multiply(),
        "matrix_solve": run_matrix_solve(),
        "passed": True,
    }
    payload["whole_process_benchmark_wall_seconds"] = time.perf_counter() - total_start

    RESULTS_DIR.mkdir(parents=True, exist_ok=True)
    output_path = RESULTS_DIR / f"flint_threads_{args.label}.json"
    output_path.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
        newline="\n",
    )
    print(json.dumps({"output": str(output_path), "passed": payload["passed"]}))


if __name__ == "__main__":
    main()
