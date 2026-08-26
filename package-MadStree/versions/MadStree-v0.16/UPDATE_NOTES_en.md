# MadStree v0.16 Update Notes

This release is based on v0.15. It does not provide compatibility loaders, paths, schemas, or
result readers for v0.15.

## Fix

- `MSBoundaryData` no longer multiplies massive contact sectors by an additional depth factor
  `I^n`. The sector normalization, Hankel endpoint coefficients, and component defining
  integrals already contain the complete phase. The removed factor shifted a single pinch by
  `I` and a double pinch by `-1`.
- The massive child normalization no longer repeats `Exp[Pi Im[formulaNu]]`. That factor belongs
  to the conjugate-order endpoint basis used by the paper; MadStree represents both endpoints in
  a common Hankel order, whose basis identity has already absorbed it.
- The sector/master normalization of a contracted massive Full line now retains its one required
  `fullContourSign`: after suppressing the common momentum power, a `++` child is `-4 I/Pi` and a
  `--` child is `+4 I/Pi`. This sign defines `J_s=calN_s I_s` only; it does not enter the
  normalized-master DE or recurrence event.
- The contact recurrence and dlog DE physically remove the additional contour sign for a purely
  massive event. Contour data enter only through signed energies, the user-coordinate chain
  factor, and the final SK branch weight. The massless-quotient `(-1)^N` remains. The public
  definition `J_s=calN_s I_s`, sector/master order, and public interface are unchanged, while the
  affected lower-sector DE blocks are corrected.

## Formula convention

- The manuals use the defining integral in Eq. (4.2) of arXiv:2411.03088, giving
  `(-I)^(p+1) Gamma[p+1]`.
- The printed Eq. (4.11) differs from that direct integral by an extra factor `I`. This remains an
  independent diagnostic and is not inserted into the production boundary.
- `Exp[Pi Im[nu]]` in Eq. (4.2) is not an erratum in the paper endpoint basis. It becomes a
  duplicated normalization only if it is retained again after conversion to the common-Hankel-order
  MadStree basis.

## Independent validation

- Validation-04 retains the full five-master two-vertex paper check.
- Validation-07 computes all eight SK branches directly in both V5.5 and MadStree; no branch is
  supplied by complex conjugation. Their masters,
  normalizations, differential equations, and boundaries are frozen separately and sent directly
  to the same independent FlintNDE 0.5.0 backend. The lower order is the reported result; the
  higher order is refinement only.
- Eq. (103) of arXiv:2309.10849v2 is the sum over all SK branches. Appendix B,
  Eqs. (148)--(151), defines four independent branches but does not publish a complete
  closed-form oracle for each branch separately. The paper therefore validates the sum of the
  eight directly computed branches, while individual branches are cross-checked between V5.5
  and MadStree. The original V5.5 batch becomes the branchwise reference only after it passes
  Eq. (103); adding an extra `Exp[Pi Im[nu]]` is retained only as a counterfactual rejected by
  that equation.
- A fresh complete Validation-07 run passed `21/21`: all forty `25x25` matrices from eight
  branches and five variables were exactly equal, and every ordinary-point component was within
  the predeclared joint error budget. The total wall time was `719.1006252` seconds.

## Interface and migration

The public interface is unchanged from v0.15. Only v0.16 remains in the current worktree; older
versions are recoverable from Git history.
