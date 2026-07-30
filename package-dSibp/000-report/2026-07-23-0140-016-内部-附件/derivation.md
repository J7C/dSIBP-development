# 016 independent derivation

## 1. Scope and sources

This document derives only the version-016 increments in task-book section 17.  It does not reuse any 014/015 expected data.  The only non-task-book technical source used in phase 1 is the freshly downloaded source of arXiv:2401.00129, whose archive SHA-256 is

```text
BCE77FD9F48F65A2174B8384B8C168B63A444ABB3B8F522E7EE29AD8358CE5AB
```

The paper supplies the natural binary ordering and the independent matrix form of the pure-time recurrence.  Graph, routing, declaration, fixed-line and parameter results below are derived directly.

## 2. Multigraph and structural loop space

Orient the two bubble edges oppositely and the bridge from `v2` to `v3`:

```text
e1: v1 -> v2
e2: v2 -> v1
e3: v2 -> v3
```

With rows `{v1,v2,v3}` and columns `{e1,e2,e3}`, the incidence matrix is

```text
B = {{-1, 1, 0},
     { 1,-1,-1},
     { 0, 0, 1}}.
```

There are `E=3`, `V=3`, `C=1`, so `L=E-V+C=1`.  Solving `B.c=0` gives the root cycle vector `c={1,1,0}`.  Thus `e1,e2` are cycle lines and `e3` is a bridge.  Deleting `e3` raises the component count from one to two; deleting either parallel bubble edge leaves the graph connected.

Two minimal probes fix multigraph semantics:

- One vertex with one self-loop has a zero incidence column and `L=1-1+1=1`; its only edge is not a bridge.
- Three parallel edges between two vertices have `L=3-2+1=2`; deleting any one still leaves the vertices connected, so all three are cycle lines.

External legs are not columns of the internal-edge incidence matrix and do not enter `E`.

## 3. Routing shift and exact declarations

Use arbitrary role-free symbols and routing

```text
Q1 = ell + arc
Q2 = ell + arc + spur
Q3 = wing1 + wing2.
```

The loop-coefficient column is `A={1,1,0}`, equal to the incidence null vector.  Select the first row as reference and define `qPrime=ell+arc`.  For `Q=A ell+r`,

```text
rPrime = r - A A_R^(-1) r_R
       = {0, spur, wing1+wing2}.
```

Only `spur` remains in a loop-dependent line, so the exact ordered `loopExternalMomenta` declaration is `{spur}`.  The symbol `arc` is a removable routing origin, not a physical loop-external direction.  A rational-sign probe,

```text
Q1 = 2 ell + arc,
Q2 = -3 ell + spur,
```

gives residual `Q2=-(3/2) qPrime + spur+(3/2) arc`; exact coefficients and signs must be retained.

Declaration outcomes are therefore:

| declaration | result | initialization | symbolic seed | unique derivatives/inverse |
|---|---|---:|---:|---:|
| `{spur}` | exact | yes | yes | yes |
| `{spur,arc}` | overcomplete warning | yes | yes | no |
| `{}` | missing `{spur}` | no | no | no |

The undercomplete certificate is the residual row `{0,1}` in the direction basis `{arc,spur}`: the declared span is zero and the missing quotient direction is `spur`.

Three separate full-mode routing failures are frozen:

1. Two declared loop momenta disagree with structural `L=1`.
2. Support `{1,1,1}` places independent loop flow on bridge `e3`.
3. Support `{1,-1,0}` is not in `NullSpace[B]`, since `B.{1,-1,0}={-2,2,0}`.

For no-loop magnitudes, the actually used expressions are ordered as

```text
{|wing1|, |wing2|, |wing1+wing2|}.
```

They remain three declared magnitude coordinates.  No `sp[wing1,wing2]` coordinate is synthesized.  Overall sign is canonical (`|p|=|-p|`), while `|wing1+wing2|` and `|wing1-wing2|` are distinct.  Exact, overcomplete and undercomplete declarations are respectively `{wing1,wing2,wing1+wing2}`, that list plus `decoy`, and the list with `wing1+wing2` omitted.

An undercomplete declaration makes the context unusable.  Consequently every downstream entry point named in section 17.1 must fail rather than reconstructing a missing role.  Overcomplete declarations retain symbolic seed generation but disable `ds`, `DSDE` and unique inverse conversion.

## 4. Cycle and fixed packs

Choose the mixed root line types

```text
e1: cycle, massive
e2: cycle, masslessFull
e3: bridge, massive fixedCoefficient.
```

The loop representation is

```mathematica
J[{a1,a2,a3},
  {{b1,n11,n12},{b2,n2},{n31,n32}},
  {z1}]
```

and a masslessCross fixed bridge has the empty pack `{}`.  Momentum operators visit only `{e1,e2,rho1}`; `e3` has no `z_e`, `b/bS` shift or momentum building-block term.  Time differentiation still visits all incident active lines:

```text
v1 -> {e1,e2}
v2 -> {e1,e2,e3}
v3 -> {e3}.
```

If both cycle lines shrink, their current packs become `{bS1}` and `{bS2}`, but their inherited roles remain `cycle`; `e3` remains `fixedCoefficient`, and the root loop count remains one.  Contact topology does not redefine the root routing problem.

## 5. Fixed massive h derivatives

For `F0(x)=x^(-nu) H_nu(x)` and `F1=dF0/dx`, the Hankel equation gives

```text
F0' = F1,
F1' = -F0 - (2 nu+1) F1/x.
```

With `x=-r tau`, endpoint time differentiation is

```text
d_tau F0 = -r F1,
d_tau F1 = r F0 + (2 nu+1)(-tau)^(-1) F1.
```

Thus an `n=0` fixed endpoint term has coefficient `-r` and flips `0->1`; an `n=1` term gives coefficient `+r` for `1->0` plus `(2nu+1)` with `a->a-1`.  No line-power index is shifted.

For a two-endpoint fixed line

```text
R = r^(-B) F_nu(-r tau_u) F_nv(-r tau_v),
```

radial differentiation gives, in integral notation,

```text
d_r J00 = -B/r J00 + J10[a_u+1] + J01[a_v+1]
d_r J10 = -(B+2nu+1)/r J10 - J00[a_u+1] + J11[a_v+1]
d_r J01 = -(B+2nu+1)/r J01 + J11[a_u+1] - J00[a_v+1]
d_r J11 = -(B+2(2nu+1))/r J11
           - J01[a_u+1] - J10[a_v+1].
```

More generally a physical-power change `B -> B+DeltaB` contributes the coefficient `r^(-DeltaB)`.  This is why a fixed line needs `B` in metadata but must not acquire a `b` slot.

## 6. Direct pure-time representation

In `ibpMode->"timeOnly"` every line is a coefficient-only h leg at each endpoint.  A two-vertex massive line uses

```mathematica
J[{{a1,n11},{a2,n12}}]
```

and a three-vertex chain uses

```mathematica
J[{{a1,n121},{a2,n122,n231},{a3,n232}}].
```

No `b/bS`, ISP gate or momentum generator exists, even if the input multigraph has nonzero structural loop count.  All active line radii still participate in the independent no-loop magnitude audit.

For one vertex with the direct-tree paper convention `tau^A`, sign `s`, phase energy `E`, and h legs `(nu_j,k_j,n_j)`, direct differentiation gives

```text
0 = [A - Sum_{n_j=1}(2nu_j+1)] J[A-1,n]
    - i s E J[A,n]
    + Sum_{n_j=0} (-k_j) J[A,n with n_j->1]
    + Sum_{n_j=1} (+k_j) J[A,n with n_j->0].
```

This `tau^A` sign is specific to the direct tree representation.  A loop `J[aList,linePacks,ispList]` uses `(-tau)^A`; its projection to the direct tree basis carries the relative `(-1)` power specified in the task book.

The binary masters use `1+Sum_j n_j 2^(p-j)`, so the last bit changes fastest.  Constructing the coefficient matrix row by row from this seed is independent of the public-paper Kronecker construction.  Their equality is a phase-1 self-check.  The deterministic rational probes use noninteger physical powers, rational `nu`, rational energies and exact Gaussian rationals; they do not use floating tolerance.

## 7. Notation and parameter redefinition

For `N` declared momentum categories, indices use width `IntegerLength[N]` only when `N>9`.  The frozen boundaries are

```text
N=9:   ss19, ssE? no; independent magnitude is sE9
N=10:  ss0101, ss0110, sE01
N=100: ss001100, sE001.
```

The exact notation values are recorded without the explanatory `ssE?` text in `expected_016.wl`.

For coordinates `{ss11,sE1,sE2,sE3}`, take

```text
ss11 = u+v,
sE1  = u-v,
sE2  = u+w,
sE3  = u+z.
```

The Jacobian is

```text
{{1,1,0,0},{1,-1,0,0},{1,0,1,0},{1,0,0,1}}
```

with determinant `-2`.  Hence `u` differentiates all four base coordinates and, in the selected family, simultaneously reaches the cycle radius, fixed bridge radius and phase energy.  For `c(u)J1+d(u)J2`, the chain rule includes `c'J1+d'J2` plus the four base-coordinate derivatives of each integral.

Omitting the `sE3` rule is undercomplete.  Adding a fifth parameter `t` through `ss11=u+v+t` leaves a full-row-rank `4x5` Jacobian but creates the right-null vector `{1,1,-1,-1,-2}`.  Therefore no unique inverse or unique independent derivative basis exists; the redundant direction must not be silently set to zero.
