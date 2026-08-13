"""验证 MadStree v0.11 到 FlintNDE 0.4.0 的唯一单请求 schema。

测试直接加载版本内 adapter，检查自动规划、严格用户节点、逐点互检和旧 schema
拒绝；不依赖安装态 MadStree，也不生成或恢复路径计划对象。
"""

from __future__ import annotations

import importlib.util
import sys
import unittest
from pathlib import Path
from types import ModuleType


VERSION_ROOT = Path(__file__).resolve().parents[1]
BACKEND_FILE = VERSION_ROOT / "Backend" / "flintnde_transport.py"
VENDOR_ROOT = VERSION_ROOT / "Vendor" / "FlintNDE"


def _load_adapter() -> ModuleType:
    """从当前版本路径加载 adapter。"""

    sys.path.insert(0, str(VENDOR_ROOT))
    spec = importlib.util.spec_from_file_location("madstree_v011_adapter", BACKEND_FILE)
    if spec is None or spec.loader is None:
        raise RuntimeError("cannot load MadStree v0.11 adapter")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


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


if __name__ == "__main__":
    unittest.main()
