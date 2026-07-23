sc-toolbox
==========

Schwarz-Christoffel Toolbox for conformal mapping in MATLAB

The SC Toolbox contains numerical routines and graphical interfaces to work with Schwarz-Christoffel conformal maps--those to regions bounded by polygons in the complex plane. Many map variations are present. The software has no requirements other than core MATLAB.

You might prefer to view the [page at the File Exchange](https://www.mathworks.com/matlabcentral/fileexchange/1316-schwarz-christoffel-toolbox), where you can try the package out online without downloading and installing it.

For more details on the maps, see _Schwarz-Christoffel Mapping_, by Driscoll and Trefethen. For a user's guide, visit https://tobydriscoll.net/project/sc-toolbox/.

## Getting started

Add the toolbox root to your MATLAB path:

```matlab
addpath('/path/to/sc-toolbox')
```

No additional toolboxes are required.

## Map types

| Class | Domain → Target |
|-------|----------------|
| `diskmap` | Unit disk → polygon |
| `extermap` | Disk exterior → polygon exterior |
| `hplmap` | Upper half-plane → polygon |
| `stripmap` | Infinite strip → polygon |
| `rectmap` | Rectangle → polygon |
| `crdiskmap` | Disk → polygon (cross-ratio) |
| `annulusmap` | Annulus → doubly connected region |

Each map type supports `eval`, `evalinv`, `evaldiff`, `plot`, and `accuracy`.

## Shape derivatives (`rectmap`)

`vertexDeriv` computes the derivative of the rectangle map with respect to each polygon vertex position — useful for shape optimization:

```matlab
p = polygon([4, 2i, -2+4i, -3, -3-1i, 2-2i]);
M = rectmap(p, 1:4);

zp = [0.2 + 0.3i, -0.1 + 0.5i];          % preimage points in rectangle
[dfdwre, dfdwim] = vertexDeriv(M, zp);
% dfdwre(k,i) = df/d(Re w_i) at zp(k)
% dfdwim(k,i) = df/d(Im w_i) at zp(k)
```

Vertex indexing follows the post-`scfix` ordering stored in `polygon(M)`.

`evalRaw` evaluates the map at rectangle-domain points without the `isinpoly` domain check, which is useful when working near or on the boundary:

```matlab
wp = evalRaw(M, zp);
```

## Running tests

Tests use MATLAB's `matlab.unittest` framework. Generate fixtures once before running:

```matlab
generateFixtures()       % all map types
generateFixtures('rect') % single type
```

Then run the suite:

```matlab
sctool.runTests()              % all tests
sctool.runTests('rect')        % rectangle map only
sctool.runTests('vderiv')      % shape derivative tests
sctool.runTests('disk', 'ann') % subset
```

Valid suite names: `disk`, `ext`, `hpl`, `strip`, `rect`, `crdisk`, `ann`, `vderiv`.
