"""证明 execute-only handler 在运行期不调用路径规划器。"""

from __future__ import annotations

import json
import sys
from pathlib import Path


def main() -> int:
    if len(sys.argv) != 5:
        raise SystemExit("usage: sentinel_execute.py REQUEST OUTPUT VENDOR_ROOT BACKEND_ROOT")
    request_path, output_path, vendor_root, backend_root = map(Path, sys.argv[1:])
    sys.path.insert(0, str(vendor_root.resolve()))
    sys.path.insert(0, str(backend_root.resolve()))
    import flintnde  # pylint: disable=import-error,import-outside-toplevel
    import flintnde_transport as adapter  # pylint: disable=import-error,import-outside-toplevel

    called = False

    def forbidden_planner(*_args, **_kwargs):
        nonlocal called
        called = True
        raise AssertionError("execute-only route called plan_transport_path")

    flintnde.plan_transport_path = forbidden_planner
    request = json.loads(request_path.read_text(encoding="utf-8"))
    request["segments"] = request["segments"][:1]
    result = adapter._run(request)  # pylint: disable=protected-access
    payload = {
        "status": "passed" if not called and result.get("status") == "success" else "failed",
        "plannerCalled": called,
        "executionAction": result.get("executionAction"),
        "pointCount": sum(
            len(segment.get("pointValues", []))
            for segment in result.get("segments", [])
        ),
    }
    output_path.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    return 0 if payload["status"] == "passed" else 1


if __name__ == "__main__":
    raise SystemExit(main())
