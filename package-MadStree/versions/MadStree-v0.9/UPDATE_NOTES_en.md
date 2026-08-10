# MadStree v0.9 release notes

## Baseline and scope

- Built by modifying v0.8 (version lineage v0.5 -> v0.6 -> v0.7 -> v0.8 -> v0.9; v0.8 is frozen).
- The v0.8 source, manual, examples and validation results are kept as the baseline; v0.9 changes no numerical logic, serialization schema, cache contract or numerical results. Its theme is the revised audit item F2 (see `000_report/2026-08-10-三程序包最新版落地审查.md` in the repository root): **backend failure diagnostics and example failure gates**.

## Design principle (confirmed by the user on 2026-08-10)

**Zero probing**: the package never probes user directories, never tries candidate interpreters, and never hard-codes machine paths; installing Python and keeping it reachable is the user's responsibility. The package keeps exactly two explicit channels (the `PythonExecutable` option and the `MADSTREE_PYTHON` environment variable), and its duty is to explain clearly what went wrong when a run fails.

## New features and fixes

1. **Backend failure diagnostics** (`msExecuteFlintNDEAdapter` in `Kernel/Numerics/FlintNDE.wl`):
   - The backend subprocess stdout/stderr is redirected to `results_temp/flintnde_transport/madstree-flintnde-log-<uuid>.txt`; on failure the log tail (at most 2000 characters) is attached to the `Failure` under the `"stderr"` key; on success the log file is deleted.
   - Two new diagnostic messages (declared in `Kernel/MadStree.wl`):
     - `MSFlintNDETransport::backendLaunchFailed`: the backend produced no output (typically an unusable interpreter or missing python-flint); the message contains the actual interpreter command, the captured output tail, and the two fix channels (install python-flint for that interpreter, or point the `PythonExecutable` option / `MADSTREE_PYTHON` environment variable at an interpreter that has python-flint).
     - `MSFlintNDETransport::backendRunFailed`: the backend ran but returned a non-success status; the message contains the actual interpreter command and the backend `error` text.
   - The cache logic (digest key, reuse on success only, failed outputs never hit) is unchanged.
2. **`MADSTREE_PYTHON` channel moved into the package**: the default of `PythonExecutable` on `MSFlintNDETransport` changes from `"python"` to `Automatic`; the new resolver `msResolvePythonExecutable` resolves: explicit string verbatim -> `MADSTREE_PYTHON` environment variable (when non-empty) -> `"python"`. No candidate probing anywhere. `PythonExecutable::usage` is updated accordingly; `test/_harness.wls` keeps passing the option explicitly.
3. **Example failure gates** (`Examples/01--05`):
   - Each example gains a final gate: if any checked result is a `Failure`, the reason is printed and the script exits with `Exit[1]`; otherwise it prints `Example PASSED`.
   - 01/04/05 additionally fail fast on the intermediate results consumed downstream (01: `targetValue`, `userAnchorValue`; 04/05: `targetValue`), so a backend failure stops the script at the first failing point instead of cascading message floods (`MapThread::mptd`, `Lookup::invrl`, ...); the `AnchorValues` of 04/05 carries an empty placeholder on failure.
   - Example invocations stay default: they pass no `PythonExecutable` and read no environment variable, matching the user documentation.
4. **Version identifier**: `$MadStreeVersion` is corrected from `"0.7"` (a v0.8 leftover) to `"0.9"`; the version assertion in `test_package_artifacts.wls` is updated accordingly.

## Unchanged

Numerical logic, serialization schemas v1/v2, embedded truncation certification, dense output, cache digest and layout, public API signatures and option names, and input gates such as `BoundaryVectorDimension`.

## Validation (fresh runs on this machine, 2026-08-10)

- All 11 development tests exit 0 under `MADSTREE_PYTHON=D:/anaconda/python.exe` (160/160 checks): check_core `49/49`, test_package_artifacts `18/18`, test_flintnde_boundary `9/9`, test_flintnde_massive_vertex `7/7`, test_flintnde_massless_edge `9/9`, test_flintnde_massive_full_edge `5/5`, test_flintnde_mixed_three_vertex `7/7`, test_flintnde_vertex_family `7/7`, test_dsibp_derivative_dlog `9/9`, test_simultaneous_cycle_chart `22/22`, test_vertex_family_reduce `18/18`.
- Examples 01--05 run with defaults (no environment variable; on this machine the default `python` resolves to an interpreter with flint 0.9.0) and all print `Example PASSED` with exit 0.
- Negative case: passing `PythonExecutable` explicitly to a clean venv without flint produces a single `backendRunFailed` message (`Backend error: No module named 'flint'.`), returns a `Failure` (with the `"stderr"` key), the gate exits with code 1, and no message flood occurs.

## Migration and compatibility

- The v0.8 loading recipe is unchanged; adding `versions/MadStree-v0.9/` to `$Path` allows a direct `Needs["MadStree`"]`.
- Callers relying on the previous `"python"` default keep the same behavior (`Automatic` still resolves to `"python"` when the environment variable is unset); set `MADSTREE_PYTHON` to use the environment-variable channel.
- Scripts passing `PythonExecutable -> "..."` explicitly remain valid with unchanged semantics.

## Known limitations

- Same as v0.8: no general IBP system generation, no Kira execution, no duplication of dSIBP's external-momentum derivatives; the pole-residue fast path applies only when dlog letters degenerate to `α+β s` along the affine path; the bundled FlintNDE 0.2.0 keeps the mathematical scope of its source release.
- Default interpreter resolution depends on the PATH of the runtime environment: if the default `python` lacks python-flint, the backend fails with a single diagnostic message (expected behavior, not a package defect); follow the message to install or specify an interpreter.
