# MadStree v0.11 release notes

## Baseline and ownership

- Built from frozen v0.10; v0.10 is not modified further.
- The vendored numerical backend is upgraded to FlintNDE 0.4.0.
- MadStree only identifies maximal consecutive complex-affine one-variable segments, pulls
  back the dlog DE, and supplies boundary data and master order. Node planning, transport,
  and multipoint series evaluation belong to FlintNDE.

## Current interface

- `MSEvaluatePath[context, pointSequence, ...]` is the sole numerical entry point.
- `FlintNDEPathPlanning -> True` (default) asks FlintNDE to plan nodes inside each segment.
  User points covered by one expansion node are evaluated as a bucket: large buckets use
  fast multipoint evaluation through a subproduct/remainder tree and small buckets use the
  iterative algorithm.
- `FlintNDEPathPlanning -> False` preserves every user point as a transport node in input
  order and never calls the planner. A chain that crosses a pole or exceeds a local convergence
  disk fails explicitly.
- Bare coordinates are returned; `{coordinate,"tmp"}` is transient. Other labels are rejected.

## Removed interfaces

v0.11 physically removes MadStree path-planning code, the two-phase public functions, plan
objects, old JSON schemas, plan serialization/recovery, LO point labels, and their compatibility
tests. No wrapper, fallback, alias, or current-documentation migration path is retained.

## Encoding and execution

All affine segments, exact pullbacks, boundary data, and options enter one Python process in a
single UTF-8 JSON request. Backend logs and Wolfram package loads also use explicit UTF-8;
ordinary `Needs["MadStree`"]` requires no encoding option from the user.

## Validation status

- Single-request Python adapter: 4/4 passed.
- Thirteen Wolfram development scripts passed 184/184 checks; all five examples exited zero.
- The full Python regression passed 146/146 and Wolfram `Needs["FlintNDE`"]` passed 18/18.
  Twenty Python implementation files and fourteen test files are byte-identical between the
  standalone backend and the Vendor copy.
- The v0.11 independent validation passed 17/17. Across 900 points and three masters, the largest
  componentwise absolute difference was `5.8262e-43`; 894 points entered six fast buckets. The
  planned route was 2.5269 times faster end to end and 4.5128 times faster in backend time than
  the strict user-node route.
- Both manuals passed XeLaTeX/BibTeX builds with no undefined references; the title and numerical
  interface pages passed visual inspection.

## Known limitations

- With planning disabled, automatic singularity jumps are unavailable; the user supplies a valid
  ordinary-point node chain.
- Fast multipoint speed depends on bucket size, series order, and master dimension. The independent
  report records actual nodes, coverage, algorithms, and timings against the direct-node route.
