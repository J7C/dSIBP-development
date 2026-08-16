"""验证 MadStree v0.11 到 FlintNDE 0.4.0 的唯一单请求 schema。

测试直接加载版本内 adapter，检查自动规划、严格用户节点、逐点互检和旧 schema
拒绝；不依赖安装态 MadStree，也不生成或恢复路径计划对象。
"""

from __future__ import annotations

import importlib
import sys
import unittest
from pathlib import Path
from types import ModuleType


VERSION_ROOT = Path(__file__).resolve().parents[1]
BACKEND_FILE = VERSION_ROOT / "Backend" / "flintnde_transport.py"
VENDOR_ROOT = VERSION_ROOT / "Vendor" / "FlintNDE"


def _load_adapter() -> ModuleType:
    """按真实模块名加载 adapter，使 Windows worker 可以重新导入任务函数。"""

    sys.path.insert(0, str(VERSION_ROOT / "Backend"))
    sys.path.insert(0, str(VENDOR_ROOT))
    return importlib.import_module("flintnde_transport")


ADAPTER = _load_adapter()


def _complex(real: str, imag: str = "0") -> dict[str, str]:
    """建立唯一复数 JSON 记录。"""

    return {"real": real, "imag": imag}


def _request(path_planning: bool) -> dict[str, object]:
    """建立一维 dlog 测试请求；20 个点足以触发 fast dense 多点求值。"""

    points = [_complex(f"{index}/40") for index in range(1, 21)]
    return {
        "schema": ADAPTER.EVALUATE_SCHEMA,
        "backendPackagePath": str(VENDOR_ROOT),
        "masterDigest": "adapter-v011-test",
        "dimension": 1,
        "segments": [{
            "start": "0",
            "points": points,
            "letters": [{
                "alpha": _complex("1"),
                "beta": _complex("-1/2"),
                "residue": [[_complex("1")]],
            }],
            "fromUserIndex": 0,
            "userIndices": list(range(1, 21)),
        }],
        "pathPlanning": path_planning,
        "singularityMode": "avoid",
        "boundary": {"kind": "finite", "values": [_complex("1")]},
        "workingPrecisionDigits": 70,
        "primaryOrder": 64,
        "referenceOrder": 88,
        "targetRelativeError": "1e-30",
        "certificationMode": "embedded",
        "messageLanguage": "CN",
        "columnVectorConvention": "Y'=A(s)Y",
        "dlogStatus": "certifiedByFormulaChecks",
    }


class SingleRequestAdapterTest(unittest.TestCase):
    """检查 v0.11 单进程分组求值合同。"""

    @classmethod
    def setUpClass(cls) -> None:
        cls.planned = ADAPTER._run(ADAPTER._validate_request(_request(True)))
        cls.direct = ADAPTER._run(ADAPTER._validate_request(_request(False)))

    def test_planned_route_uses_dense_fast_multipoint(self) -> None:
        """自动规划应减少节点并让同节点覆盖的大桶走 fast 算法。"""

        segment = self.planned["segments"][0]
        algorithms = {
            record["evaluationAlgorithm"]
            for record in segment["pointValues"]
            if record["evaluationAlgorithm"] is not None
        }
        self.assertLess(segment["nodeCount"], 21)
        self.assertGreater(segment["coveredSampleCount"], 0)
        self.assertIn("fast", algorithms)

    def test_disabled_planning_uses_user_nodes_exactly(self) -> None:
        """关闭规划时不得插点、删点或产生 dense sample。"""

        segment = self.direct["segments"][0]
        self.assertEqual(segment["planReport"]["planning_action"], "disabled_use_user_points_as_nodes")
        self.assertEqual(segment["nodeCount"], 21)
        self.assertEqual(segment["coveredSampleCount"], 0)
        self.assertTrue(all(record["source"] == "node_snapshot" for record in segment["pointValues"]))

    def test_routes_agree_pointwise(self) -> None:
        """自动规划与严格用户节点在全部用户点逐点一致。"""

        planned_values = self.planned["segments"][0]["pointValues"]
        direct_values = self.direct["segments"][0]["pointValues"]
        self.assertEqual(len(planned_values), len(direct_values))
        maximum_difference = max(
            abs(complex(float(p["values"][0]["real"]), float(p["values"][0]["imag"])) -
                complex(float(d["values"][0]["real"]), float(d["values"][0]["imag"])))
            for p, d in zip(planned_values, direct_values)
        )
        self.assertLess(maximum_difference, 1.0e-28)

    def test_old_schema_and_extra_fields_are_rejected(self) -> None:
        """旧两阶段 schema 和兼容字段均不得被当前 adapter 接受。"""

        old = _request(True)
        old["schema"] = "madstree_flintnde_polyline_plan_v2"
        with self.assertRaisesRegex(ValueError, "unsupported"):
            ADAPTER._validate_request(old)
        extra = _request(True)
        extra["serializedPlan"] = {}
        with self.assertRaisesRegex(ValueError, "unexpected"):
            ADAPTER._validate_request(extra)


class EpBatchAdapterTest(unittest.TestCase):
    """检查不同 ep 请求由有界进程池自动续交并保持输入顺序。"""

    def test_default_count_is_capped_by_task_count(self) -> None:
        raw = {
            "schema": ADAPTER.EVALUATE_BATCH_SCHEMA,
            "parallelTaskCount": ADAPTER.DEFAULT_PARALLEL_TASK_COUNT,
            "messageLanguage": "CN",
            "tasks": [
                {"ep": ep, "request": _request(True)} for ep in ("1/5", "1/4", "1/3")
            ],
        }
        result = ADAPTER._run_batch(ADAPTER._validate_batch_request(raw))
        self.assertEqual(result["parallelTaskCountRequested"], 12)
        self.assertEqual(result["parallelTaskCountEffective"], 3)
        self.assertEqual([item["ep"] for item in result["results"]], ["1/5", "1/4", "1/3"])
        self.assertTrue(all(item["result"]["status"] == "success" for item in result["results"]))

    def test_queue_runs_all_tasks_above_parallel_limit(self) -> None:
        values = [f"1/{value}" for value in range(3, 9)]
        raw = {
            "schema": ADAPTER.EVALUATE_BATCH_SCHEMA,
            "parallelTaskCount": 2,
            "messageLanguage": "EN",
            "tasks": [{"ep": ep, "request": _request(False)} for ep in values],
        }
        result = ADAPTER._run_batch(ADAPTER._validate_batch_request(raw))
        self.assertEqual(result["parallelTaskCountEffective"], 2)
        self.assertEqual([item["ep"] for item in result["results"]], values)
        self.assertEqual(
            len({item["result"]["workerPid"] for item in result["results"]}),
            len(values),
        )

    def test_serial_limit_still_isolates_each_ep_worker(self) -> None:
        """并行上限一只限制同时运行数，每个 ep 仍使用新 worker。"""

        values = ["1/5", "1/4", "1/3"]
        raw = {
            "schema": ADAPTER.EVALUATE_BATCH_SCHEMA,
            "parallelTaskCount": 1,
            "messageLanguage": "EN",
            "tasks": [{"ep": ep, "request": _request(False)} for ep in values],
        }
        result = ADAPTER._run_batch(ADAPTER._validate_batch_request(raw))
        self.assertEqual(result["parallelTaskCountEffective"], 1)
        self.assertEqual([item["ep"] for item in result["results"]], values)
        self.assertEqual(
            len({item["result"]["workerPid"] for item in result["results"]}),
            len(values),
        )


class EpSeriesControlTest(unittest.TestCase):
    """检查符号证书给定最低幂后的自适应规划和严格 Laurent 拟合。"""

    @staticmethod
    def _control(action: str, **payload: object) -> dict[str, object]:
        """建立当前唯一的自适应正规化控制请求。"""

        return {
            "schema": ADAPTER.SERIES_CONTROL_SCHEMA,
            "action": action,
            "backendPackagePath": str(VENDOR_ROOT),
            "maximumPower": 0,
            "goalDigits": 12,
            **payload,
        }

    def test_certified_pole_plan_and_finite_part_fit(self) -> None:
        """接收已认证的 -1 最低阶，并用独立点认证 pole 与有限项。"""

        from flint import acb
        from flintnde import configure_working_precision

        plan = ADAPTER._run_series_control(
            ADAPTER._validate_series_control_request(self._control(
                "production_plan", leadingPower=-1, sampleSpacing="0.01",
                validationSampleCount=2, validationScale="0.5", maximumSamples=100,
                extraWorkingPrecision=0.0, productionRound=1,
                fitExtraOrder=2, fitOrderIncrement=2, fitMaximumRounds=3,
            ))
        )
        self.assertEqual(plan["sampleCount"], 4)
        self.assertEqual(plan["internalMaximumPower"], 2)
        self.assertGreaterEqual(plan["workingPrecisionDigits"], 200)
        self.assertTrue(set(plan["points"]).isdisjoint(plan["validationPoints"]))
        expanded_plan = ADAPTER._run_series_control(
            ADAPTER._validate_series_control_request(self._control(
                "production_plan", leadingPower=-1, sampleSpacing="0.01",
                validationSampleCount=2, validationScale="0.5", maximumSamples=100,
                extraWorkingPrecision=0.0, productionRound=2,
                fitExtraOrder=2, fitOrderIncrement=2, fitMaximumRounds=3,
            ))
        )
        self.assertEqual(expanded_plan["sampleCount"], 6)
        self.assertEqual(expanded_plan["points"][:4], plan["points"])
        self.assertEqual(expanded_plan["validationPoints"], plan["validationPoints"])
        self.assertEqual(
            expanded_plan["workingPrecisionDigits"], plan["workingPrecisionDigits"]
        )
        custom_plan = ADAPTER._run_series_control(
            ADAPTER._validate_series_control_request(self._control(
                "production_plan", leadingPower=-1, sampleSpacing="0.01",
                validationSampleCount=2, validationScale="0.5", maximumSamples=100,
                extraWorkingPrecision=0.0, productionRound=1,
                fitExtraOrder=2, fitOrderIncrement=2, fitMaximumRounds=3,
                samplePoints=["1/10", "9/100", "2/25", "7/100", "3/50", "1/20"],
                validationPoints=["1/25", "3/100"],
                initialInternalMaximumPower=2,
            ))
        )
        self.assertEqual(custom_plan["points"], ["1/10", "9/100", "2/25", "7/100"])
        self.assertEqual(custom_plan["validationPoints"], ["1/25", "3/100"])
        self.assertEqual(custom_plan["capacitySampleCount"], 6)
        self.assertEqual(custom_plan["unusedCandidateCount"], 2)
        configure_working_precision(plan["workingPrecisionDigits"])
        production_points = [acb(point) for point in plan["points"]]
        validation_points = [acb(point) for point in plan["validationPoints"]]
        production_values = [[ADAPTER._acb_record(1 / point + 2 + 3 * point, 80)]
                             for point in production_points]
        validation_values = [[ADAPTER._acb_record(1 / point + 2 + 3 * point, 80)]
                             for point in validation_points]
        fitted = ADAPTER._run_series_control(
            ADAPTER._validate_series_control_request(self._control(
                "fit", leadingPower=-1,
                workingPrecisionDigits=plan["workingPrecisionDigits"],
                points=plan["points"], values=production_values,
                validationPoints=plan["validationPoints"],
                validationValues=validation_values, validationTolerance="1e-12",
            ))
        )
        pole = acb(fitted["coefficients"]["-1"][0]["real"])
        finite = acb(fitted["coefficients"]["0"][0]["real"])
        self.assertLess(float(abs(pole - 1).mid()), 1.0e-20)
        self.assertLess(float(abs(finite - 2).mid()), 1.0e-20)
        self.assertTrue(all(item["passed"] for item in fitted["diagnostics"]["validation_samples"]))


if __name__ == "__main__":
    unittest.main()
