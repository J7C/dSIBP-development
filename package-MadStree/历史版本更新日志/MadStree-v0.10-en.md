# MadStree v0.10 release notes

## Baseline and scope

- Built from v0.9, which is frozen and corresponds to the remote `MadStree-v0.9` tag.
- This work completes v0.10 in place; no additional version number was opened.
- The theme is two-phase multivariable polyline planning, default singularity avoidance,
  explicit singularity jumps, leading-order (LO) records, coordinate-bearing results, and
  high-precision serialization.
- MadStree owns the multivariable path, dlog letters, boundary normalization, and master
  order, and pulls each segment back to one variable. FlintNDE remains a general one-variable
  matrix-DE package. Its internally certified
  `A(x)=P(x)+Sum R_j/(x-p_j)` route, with arbitrary finite-degree `P`, is not a
  MadStree-only or dlog-only interface.
- `Vendor/FlintNDE` and standalone FlintNDE 0.3.0 carry the same implementation.

## New and revised behavior

1. **Two-phase contract**: `MSGeneratePath` performs multivariable polyline
   planning, affine pullback, and backend plan-only calls. Its return value stores all nodes,
   sample routing, singularity-jump geometry, and `serializedPlan` records.
   `MSEvaluatePlannedPath` only deserializes and executes these plans; the backend does not
   call the planner. The two commands already express the workflow, so there is no separate
   option for automatic planning.
2. **Avoid singularities by default**: `SingularityMode -> "Avoid"` is the default.
   A pole on an adjacent user-point segment returns the offending pair, pole, and minimum
   distance. Only explicit `SingularityMode -> "SingularityJump"` enables a singularity jump.
3. **Jump terminology, singularity jumps, and branch responsibility**: every multipoint
   transport through intermediate nodes is a jump; only an explicit crossing of a singularity
   through a local-basis connection is a singularity jump. Entering the pole step range creates
   incoming and outgoing bridges. After the pole, subsequent user points are inspected in
   order and the last point still in one-step range becomes the next node; if the first point
   is outside, one admissible step is taken towards it before ordinary planning resumes. A
   singularity jump chooses a multivalued branch equivalent to one detour path, which the
   user must confirm.
4. **Complex-affine groups and cached evaluation**: exact complex-linear dependence partitions
   the input into maximal consecutive `x(s)=x0+s v` groups, each pulled back once. Complex
   parameter points in one Taylor convergence disk share the node solution coefficients and
   need not be real-collinear; node and dense values are both returned by `userIndex`.
   Different groups inherit only their common-point value and never share local coefficients,
   so no multivariable Taylor ball is constructed.
5. **Singular-locus points and LO**: bare coordinates are saved by default,
   `{coord,"tmp"}` is a transient waypoint, and `{coord,"lo"}` requests the
   arrival-direction LO. Singular-locus points are removed and reconnections are reported.
   LO records carry coordinates, user index, coincident letters, arrival direction, branch,
   exponents, leading vectors, and path-dependence notes. Unsupported resonant local bases
   return `leadingOrderRefused` rather than fabricated numbers.
6. **Point-result format**: every result carries `coordinate`, `value`,
   `status`, and `userIndex`.
7. **Bilingual notices**: `MessageLanguage -> "EN"|"CN"`, default English.
   Planning names the default or explicit path mode; execution states that it consumed an
   existing plan; singularity-jump mode includes the branch warning.
8. **Unified single-vertex route**: single-vertex massiveExternal uses the general
   “boundary leading term + FlintNDE Frobenius recurrence” path. The explicit multivariable
   series of 2411.03088 Sec.3.3 is a test oracle only, not a production dispatch.
9. **Boundary and blow-up conclusion**: nested weights and `RankOrder` select the
   multivariable blow-up chart. FlintNDE then solves the ordinary/regular-singular
   one-variable matrix DE on that curve; it does not redo a multivariable blow-up. After
   inverse blow-up, the leading boundary coefficient is fixed by component endpoint products
   and sector normalization, with no need for a single-vertex production special case.
10. **Constant-letter segments**: if every dlog letter is constant on a segment, the
   pulled-back connection is exactly zero. The backend constructs the zero system with no
   finite poles and transports it normally instead of rejecting an empty pole list.

## Precision, serialization, and cache fixes

- FlintNDE sets
  `ceil(WorkingPrecision*log2(10))+32` bits; 70 and 100 decimal digits use 265 and
  365 bits.
- Plans record their planning precision. Nodes and singularity-jump geometry store Arb
  `midpoint/radius/exponent`. Execution above the planning precision is rejected and
  asks the user to rerun `MSGeneratePath`.
- Segment projection, match ratios, rotation factors, winding, and monodromy all use the current Acb/Arb precision, never Python `complex` or binary64 geometry.
- Successful cache keys include the request plus SHA-256 identities of
  `Backend/flintnde_transport.py`, Vendor `pyproject.toml`, and sorted
  `flintnde/*.py`. An in-place source fix therefore selects a new cache identity
  automatically.
- Fixed the LO arrival-node `FirstPosition` condition that matched internal Association
  rules and emitted `Rule::argr`. The message is no longer produced.
- Structured refusals still pass through and are never written as successful cache entries.

## Public interface

- Path workflow: `MSGeneratePath`, `MSEvaluatePlannedPath`, and `MSPlannedPathQ`.
- Result export: `MSExportEvaluationData`.
- Singularity policy: `SingularityMode -> "Avoid"|"SingularityJump"`, default `"Avoid"`.
- Notice language: `MessageLanguage -> "EN"|"CN"`, default `"EN"`; values are case-sensitive.
- The adapter accepts only the six current plan/execute schemas. Associations and JSON
  records reject missing fields, extra fields, unknown modes, and case-relaxed values.
- `$MadStreeVersion` is `"0.10"`.
## Validation

- Path-focused checks: 53/53 passed, covering default avoidance, explicit singularity jumps,
  zero-connection segments, precision rejection, EN/CN notices, direct plan execution, the formal LO
  contract, and absence of `Rule::argr`.
- Python adapter: 10/10 passed. The nonresonant singularity-jump test round-trips the serialized Arb
  plan and uses a planner sentinel to prove execute-only behavior.
- All twelve Wolfram development files passed, for 221/221 assertions. Independent explicit-series oracle checks against the general single-vertex route remain
  8/8 and 10/10.
- Examples 01--05 all completed successfully: 5/5 with exit code 0.
- SHA-256 hashes match for all 26 shared delivery files in Vendor and standalone FlintNDE 0.3.0; both pyproject.toml files declare version 0.3.0.

## Usage requirements

- Run `path = MSGeneratePath[...]`, inspect the plan, and then call
  `MSEvaluatePlannedPath[context,path,...]`.
- To request a singularity jump, set `SingularityMode -> "SingularityJump"` explicitly and
  confirm the branch. The default never crosses a pole.
- Use the same `WorkingPrecision` for planning and execution. Replan for a higher value.
- User points are bare coordinates, `{coord,"tmp"}`, or `{coord,"lo"}`.
## Known limitations

- Resonant/Jordan/log singularity jumps are numerical only when FlintNDE's exact local-basis gate supports
  them; otherwise a structured refusal is returned.
- MadStree does not generate general IBP systems or run Kira. Python resolution keeps the
  zero-probing policy: explicit option, `MADSTREE_PYTHON`, or PATH.
