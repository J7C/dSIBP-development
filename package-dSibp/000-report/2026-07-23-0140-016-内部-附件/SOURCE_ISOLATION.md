# 016 source-isolation record

## Round identity

- Target: version 016 incremental benchmark, task-book section 17 only.
- Workspace: `codex-independent-benchmark/016-explicit-momentum-graph-independent/`.
- Independent agent identity: `Artificial_Idiot-codex-independent-016`.
- Start date: 2026-07-23 (Asia/Shanghai).

## Phase 1 allowed sources

- Root `AGENTS.md`, only for mandatory workflow and correctness gates.
- `independent-benchmark/README.md`.
- `independent-benchmark/independent-benchmark.md`, especially section 17 and the raw definitions in sections 2, 3, 6, 7 and 14.
- Public graph theory, linear algebra and arXiv:2401.00129 sources fetched independently during this round.
- Generic Codex skills for coding, comments, Mathematica, IBP reduction, directory layout and multi-agent collaboration.

## Phase 1 prohibited sources

- `independent-benchmark/package/` and all package 016 program/manual/examples.
- `000_code/016_dSIBP/`, `000_code/016_dS_ibp_general.wl` and all other mainline code.
- `000_code/check/`, mainline expected, existing actual, existing 016 results and old reports.
- Old 014/015 expected, actual or result files as a source for new expected.
- Project memory and prior-run summaries.

## Freeze gate

`derivation.md`, `expected_016.wl`, the phase-1 self-check and this source record must be hashed into `FREEZE.sha256` before any phase-2 source is opened. Frozen expected may not be changed to follow package output. Any later correction must be justified from an allowed phase-1 source, recorded explicitly and followed by a new freeze.

## Phase 2 contract

After the freeze, only `independent-benchmark/package/package_016.wl`, `package_016.pdf` and the shipped examples/coverage manifest may be opened for package comparison. Mainline code and mainline checks remain prohibited throughout this independent round.

## Post-freeze correction record

After phase 2 began, the direct pure-time probe exposed that the first phase-1 self-check had used the loop representation's `(-tau)^A` sign for the direct tree representation.  The allowed public source arXiv:2401.00129 defines the vertex family with `tau^A` and gives diagonal `M1=A-Sum[n_j(2 nu_j+1)]`.  The derivation and the two independent self-check constructors were corrected from the already allowed public source, not from package output.  `expected_016.wl` was unchanged.  `FREEZE_INITIAL.sha256` preserves the original freeze and `FREEZE.sha256` records the corrected phase-1 artifacts.
