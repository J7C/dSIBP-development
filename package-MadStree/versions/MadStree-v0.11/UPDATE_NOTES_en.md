# MadStree v0.11 release notes

## Baseline and ownership

- Built from frozen v0.10; v0.10 is not modified further.
- The vendored numerical backend is upgraded to FlintNDE 0.4.0.
- MadStree only identifies maximal consecutive complex-affine one-variable segments, pulls
  back the dlog DE, and supplies boundary data and master order. Node planning, transport,
  and multipoint series evaluation belong to FlintNDE.

## Current interface

- `MSEvaluatePath[context, pointSequence, ...]` evaluates one parameter assignment and path.
- `MSReconstructEpSeries[context, ep, pointTemplate, MaximumEpPower -> m]` takes only the highest
  requested power. Before any numerical solve, the symbolic boundary and dlog DE certify the lowest
  integer power. The initial fit adds two buffer powers; failed validation adds two more powers and
  computes only new production points while reusing both caches. Three failed rounds stop closed.
- `ParallelTaskCount -> 12` bounds production and validation process pools. The old public
  `MSEvaluateEpBatch` is physically removed; the fixed-point batch executor is private.
- `FlintNDEPathPlanning -> True` (default) asks FlintNDE to plan nodes inside each segment.
  User points covered by one expansion node are evaluated as a bucket: large buckets use
  fast multipoint evaluation through a subproduct/remainder tree and small buckets use the
  iterative algorithm.
- `FlintNDEPathPlanning -> False` preserves every user point as a transport node in input
  order and never calls the planner. A chain that crosses a pole or exceeds a local convergence
  disk fails explicitly.
- Bare coordinates are returned; `{coordinate,"tmp"}` is transient. Other labels are rejected.
- `MSBoundaryData` and `MSEvaluatePath` now default to 200 decimal working digits. Automatic
  regulator planning also uses 200 digits as its lower bound; an explicit precision still overrides it.
- Example 06 requests through `ep^0` for a massless three-vertex chain with
  `a1=a2=a3=1+ep`; its symbolic boundary/DE certificate gives leading power zero.

## Removed interfaces

v0.11 physically removes MadStree path-planning code, the two-phase public functions, plan
objects, old JSON schemas, plan serialization/recovery, LO point labels, and their compatibility
tests. No wrapper, fallback, alias, or current-documentation migration path is retained.

## Encoding and execution

All affine segments, exact pullbacks, boundary data, and options enter one Python process in a
single UTF-8 JSON request. Backend logs and Wolfram package loads also use explicit UTF-8;
ordinary `Needs["MadStree`"]` requires no encoding option from the user.

## Validation status

- The Python adapter passed 8/8 checks. Given certified power `-1`, a synthetic `1/ep+2+3ep`
  route uses four production points with an internal `ep^2` buffer and recovers pole 1 and finite part 2.
- Exact Laurent valuation passed 8/8; the real nine-master, nine-branch three-vertex certificate
  returns `leadingPower=0` before numerical NDE work.
- The full Python regression passed 158/158 and Wolfram `Needs["FlintNDE`"]` passed 20/20.
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
