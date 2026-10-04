"""验证固定 ep 任务池的缺省并行数、自动续交和输入同序结果。"""

from __future__ import annotations

import os
import time
import unittest

from flintnde import DEFAULT_PARALLEL_TASK_COUNT, run_ep_tasks


def delayed_square(value: int) -> dict[str, int]:
    """按反向延迟返回平方，用乱序完成检验最终结果重排。"""

    time.sleep((7 - value % 7) * 0.002)
    return {"input": value, "square": value * value}


def return_none(_value: int) -> None:
    """返回合法空值，用于区分任务结果和内部缺失哨兵。"""

    return None


def fail_on_two(value: int) -> int:
    """在指定 ep 上失败，用于验证批量调用保持 fail closed。"""

    if value == 2:
        raise RuntimeError("intentional ep task failure")
    return value


def worker_identity(value: int) -> dict[str, int]:
    """返回任务值和 PID，用于认证每个 ep 使用独立 worker 生命周期。"""

    return {"input": value, "pid": os.getpid()}


class EpTaskPoolTest(unittest.TestCase):
    """检查 worker 上限由程序控制且不改变输入顺序。"""

    def test_default_worker_count_is_capped_by_ep_count(self) -> None:
        result = run_ep_tasks((1, 2, 3), delayed_square)
        self.assertEqual(DEFAULT_PARALLEL_TASK_COUNT, 12)
        self.assertEqual(result.parallel_task_count_requested, 12)
        self.assertEqual(result.parallel_task_count_effective, 3)
        self.assertEqual([item["input"] for item in result.results], [1, 2, 3])

    def test_one_ep_uses_one_worker(self) -> None:
        """单个 ep 即使缺省上限为 12 也只运行一个任务。"""

        result = run_ep_tasks((5,), delayed_square)
        self.assertEqual(result.parallel_task_count_effective, 1)
        self.assertEqual(result.results[0]["square"], 25)

    def test_queue_continues_when_task_count_exceeds_worker_count(self) -> None:
        values = tuple(range(9))
        result = run_ep_tasks(values, delayed_square, parallel_task_count=3)
        self.assertEqual(result.parallel_task_count_effective, 3)
        self.assertEqual(
            [item["square"] for item in result.results],
            [value * value for value in values],
        )

    def test_each_ep_uses_a_fresh_worker_even_with_serial_limit(self) -> None:
        """并发上限为一时仍逐项隔离 python-flint 全局上下文。"""

        result = run_ep_tasks((1, 2, 3), worker_identity, parallel_task_count=1)
        self.assertEqual([item["input"] for item in result.results], [1, 2, 3])
        self.assertEqual(len({item["pid"] for item in result.results}), 3)

    def test_invalid_parallel_count_is_rejected(self) -> None:
        with self.assertRaisesRegex(ValueError, "positive integer"):
            run_ep_tasks((1,), delayed_square, parallel_task_count=0)

    def test_none_is_a_valid_task_result(self) -> None:
        """合法 None 返回值不能被误判成 worker 未完成。"""

        result = run_ep_tasks((1, 2), return_none, parallel_task_count=2)
        self.assertEqual(result.results, (None, None))

    def test_worker_failure_propagates(self) -> None:
        """任一 ep 失败时整个批量调用必须抛错。"""

        with self.assertRaisesRegex(RuntimeError, "intentional ep task failure"):
            run_ep_tasks((1, 2, 3), fail_on_two, parallel_task_count=2)


if __name__ == "__main__":
    unittest.main()
