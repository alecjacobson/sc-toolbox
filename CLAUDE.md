# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

The **SC Toolbox** is a MATLAB package for Schwarz-Christoffel conformal mapping — numerical computation of maps between the complex plane and polygonally-bounded regions. No external MATLAB toolboxes are required.

## Running Tests

Tests use MATLAB's `matlab.unittest` framework. From within MATLAB with the toolbox on the path:

```matlab
% Run all regression tests
sctool.runTests()

% Run a subset by name
sctool.runTests('disk', 'ann')
% Valid names: 'disk', 'ext', 'hpl', 'strip', 'rect', 'crdisk', 'ann', 'vderiv'
```

**One-time setup:** Before tests can run, generate the fixture file:
```matlab
generateFixtures()          % all map types
generateFixtures('disk')    % single type
```
This writes `tests/fixtures.mat`. Re-run whenever polygon definitions in `tests/fixturePolygons.m` change.

## Architecture

### Class hierarchy

```
scmap  (abstract base, @scmap/)
  ├── diskmap    — unit disk → polygon
  ├── extermap   — disk exterior → polygon exterior
  ├── hplmap     — upper half-plane → polygon
  ├── stripmap   — infinite strip → polygon
  ├── rectmap    — rectangle → generalized quadrilateral
  ├── crdiskmap  — disk → polygon (cross-ratio formulation)
  └── crrectmap  — rectilinear polygon → polygon (cross-ratio)

annulusmap         — doubly connected regions (does NOT inherit scmap)
riesurfmap         — Riemann surface (multi-sheet)

polygon            — target region geometry (@polygon/)
moebius            — Möbius transformation (@moebius/)
composite          — composition of maps (@composite/)
scmapinv           — inverse of an SC map (@scmapinv/)
scmapdiff          — derivative wrapper (@scmapdiff/)
```

### Package layout

- `@ClassName/` — MATLAB old-style class directories (one per map type). Each contains `ClassName.m` (constructor) plus method files (`eval.m`, `evalinv.m`, `evaldiff.m`, `plot.m`, `accuracy.m`, etc.).
- `+sctool/` — internal package namespace: numerical solvers (`nesolve*`, `sdogleg`), quadrature helpers (`scqdata`, `scpadapt`), option parsing (`scmapopt`, `parseopt`), and `runTests.m`.
- `tests/` — regression test classes (`testDisk.m`, `testAnnulus.m`, …), fixture helpers, and `fixtures.mat`.
- `private/` — toolbar icons for the GUI.
- Top-level `.m` files — user-facing utilities: `lapsolve`, `faber`, `scgui`, `scdemo`, `polyedit`, `drawpoly`, `plotpoly`, `modpoly`.

### Common map interface

Every `scmap` subclass exposes:

| Method | Purpose |
|--------|---------|
| `eval(m, z)` | Forward map (preimage domain → polygon) |
| `evalinv(m, w)` | Inverse map |
| `evaldiff(m, z)` | Derivative |
| `plot(m)` | Image of orthogonal grid |
| `accuracy(m)` | Approximate max-norm error estimate |
| `get(m, 'field')` | Access stored parameters |

Options for the parameter problem solver are set via `sctool.scmapopt(...)` and passed as the last argument to any map constructor.

### `composite` (old-style class, not a classdef)

`@composite/composite.m` uses the old MATLAB `class()` function syntax (pre-classdef). It accepts any mix of `scmap` subclasses, `scmapinv`, `moebius`, or function handles, and sequences their evaluation.

### `rectmap` shape derivatives

`@rectmap/vertexDeriv.m` computes the derivative of the map value w.r.t. each polygon vertex:

```matlab
[dfdwre, dfdwim] = vertexDeriv(M, zp)
% dfdwre(k,i) = df/d(Re w_i) at zp(k)
% dfdwim(k,i) = df/d(Im w_i) at zp(k)
```

Vertex indexing follows the polygon stored in `M` (post-SCFIX/renumbered order, same as `vertex(polygon(M))`). Implementation uses the implicit function theorem on the SC parameter problem: builds the Jacobian of `rpfun` w.r.t. the unconstrained strip parameters `y` once (via FD), then for each vertex direction solves an `(n-3)×(n-3)` linear system to get the parameter sensitivity, then propagates to the map value via a directional finite difference in parameter space — no nonlinear re-solve per vertex. Requires `M.stripdat` to be populated (automatic for maps constructed with the current code; old saved objects need to be reconstructed).

`@rectmap/evalRaw.m` evaluates the map without the `isinpoly` domain guard — needed for FD near or on the rectangle boundary.

`tests/testVertexDerivative.m` provides both:
- FD convergence baseline tests (`testInteriorFDConverges`, etc.) verifying the FD shape derivative converges at h → h/2
- Analytic vs FD comparison tests (`testAnalyticInterior`, etc.) validating `vertexDeriv` against the FD baseline

### Test fixtures

`tests/fixtures.mat` stores pre-computed reference values keyed by map type (`disk`, `ext`, `hpl`, `strip`, `rect`, `crdisk`, `ann`). Each entry is a struct with fields `label`, `vertices`, `angles`, `z`, `fwd`, `inv`, `diff`, `acc`, `tol`. Test classes load these in `TestClassSetup` and compare fresh computations against them.
