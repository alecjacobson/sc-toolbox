function defs = fixturePolygons()
%FIXTUREPOLYGONS  Define polygons and map-type parameters for regression tests.
%
%   defs = fixturePolygons() returns a struct with one field per map type.
%   Each field is a struct array; every entry has:
%     label    — short identifier used in test output and fixture keys
%     polygon  — polygon object 
%     z        — evaluation points in the map's domain
%   Plus type-specific fields:
%     strip:  ends    — [i j] indices of the two strip ends
%     rect:   corners — [i j k l] indices of the four corners
%     ann:    inner   — complex vertex array for the inner polygon
%
%   To use the same polygon geometry for multiple map types, add an entry
%   in each relevant section below.  Run generateFixtures() after changes.

% -----------------------------------------------------------------------
% disk
% -----------------------------------------------------------------------
k = 0;

k = k+1;
disk(k).label    = 'hex6';
disk(k).polygon  = polygon([4, 2i, -2+4i, -3, -3-1i, 2-2i]);
disk(k).z        = [0.3+0.4i, -0.6+0.2i, 0.1-0.5i, 0.8+0.1i, 0.999 * exp(2i)];

k = k+1;
disk(k).label    = 'L';
disk(k).polygon  = polygon([1i -1+1i -1-1i 1-1i 1 0]);
disk(k).z        = [0.3+0.4i, -0.6+0.2i, 0.1-0.5i, 0.8+0.1i, 0.999 * exp(2i)];

% -----------------------------------------------------------------------
% ext
% -----------------------------------------------------------------------
k = 0;

k = k+1;
ext(k).label    = 'hex6';
ext(k).polygon  = polygon([4, 2i, -2+4i, -3, -3-1i, 2-2i]);
ext(k).z        = [0.3+0.4i, -0.6+0.2i, 0.1-0.5i, 0.8+0.1i, 0.999 * exp(2i)];

k = k+1;
ext(k).label    = 'L';
ext(k).polygon  = polygon([1i -1+1i -1-1i 1-1i 1 0]);
ext(k).z        = [0.3+0.4i, -0.6+0.2i, 0.1-0.5i, 0.8+0.1i, 0.999 * exp(2i)];

k = k+1;
ext(k).label    = 'vee';
ext(k).polygon  = 1i*polygon([-0.5,1-1.5i,-0.5,0.5+2i]);
ext(k).z        = [0.3+0.4i, -0.6+0.2i, 0.1-0.5i, 0.8+0.1i, 0.99999 * exp(2i)];

% -----------------------------------------------------------------------
% hpl
% -----------------------------------------------------------------------
k = 0;

k = k+1;
hpl(k).label    = 'hex6';
hpl(k).polygon  = polygon([4, 2i, -2+4i, -3, -3-1i, 2-2i]);
hpl(k).z        = [0.5+1i, -2+0.5i, 3+2i, 0+1i, -1, 1.2];

k = k+1;
hpl(k).label    = 'L';
hpl(k).polygon  = polygon([1i -1+1i -1-1i 1-1i 1 0]);
hpl(k).z        = [0.5+1i, -2+0.5i, 3+2i, 0+1i, -1, 1.2];

k = k+1;
hpl(k).label    = 'open_step';
hpl(k).polygon  = polygon(polygon([i,-1i,Inf], [3/2,1/2,-1]));
hpl(k).z        = [0.5+1i, -2+0.5i, 3+2i, 0+1i, -1, 0, 1.2];

% -----------------------------------------------------------------------
% strip
% -----------------------------------------------------------------------
k = 0;

k = k+1;
strip(k).label    = 'hex6';
strip(k).polygon  = polygon([4, 2i, -2+4i, -3, -3-1i, 2-2i]);
strip(k).z        = [0+0.5i, 1+0.3i, -1+0.7i, 2+0.1i, 1i, 0, 0.4];
strip(k).ends     = [1 4];

k = k+1;
strip(k).label    = 'L';
strip(k).polygon  = polygon([1i -1+1i -1-1i 1-1i 1 0]);
strip(k).z        = [0+0.5i, 1+0.3i, -1+0.7i, 2+0.1i, 1i, 0, 0.4];
strip(k).ends     = [1 4];

k = k+1;
strip(k).label    = 'four_lines';
strip(k).polygon  = polygon([Inf,-1-i,-2.5-i,Inf,2.4-3.3i,...
    Inf,2.4-1.3i,Inf,-1+i,-2.5+i], [0,2,1,-.85,2,0,2,-1.15,2,1]);
strip(k).z        = [0+0.5i, 0.1+0.3i, 0.5+0.99i, 0.4 + 1e-1i];
strip(k).ends     = [6 8];

% -----------------------------------------------------------------------
% rect
% -----------------------------------------------------------------------
k = 0;

k = k+1;
rect(k).label    = 'hex6';
rect(k).polygon  = polygon([4, 2i, -2+4i, -3, -3-1i, 2-2i]);
rect(k).z        = [1.5, 1.4+3i, -0.6+1i, 0.5+2i];
rect(k).corners  = 1:4;

k = k+1;
rect(k).label    = 'L';
rect(k).polygon  = polygon([1i -1+1i -1-1i 1-1i 1 0]);
rect(k).z        = [1.5, 1.4+3i, -0.6+1i, 0.5+2i];
rect(k).corners  = [2 4 5 1];

k = k+1;
rect(k).label    = 'mid_sides';
rect(k).polygon  = polygon([-5-i, -5-3i, 5-3i, 5+i, 5+3i, -5+3i]);
rect(k).z        = [2.1, 1.4+1.3i, -0.6+1i, 0.5+0.5i];
rect(k).corners  = [1 2 4 5];

k = k+1;
rect(k).label    = 'probe';
rect(k).polygon  = polygon([1 Inf 0.5+1i -1+1i Inf -1],[1 -0.5 1.5 1.5 -0.5 1]);
rect(k).z        = [1.57+0.05i, 0.5+5i, -1.5+0.1i, -0.5+6.9i];
rect(k).corners  = [3 4 6 1];

% -----------------------------------------------------------------------
% crdisk
% -----------------------------------------------------------------------
k = 0;

k = k+1;
crdisk(k).label    = 'hex6';
crdisk(k).polygon  = polygon([4, 2i, -2+4i, -3, -3-1i, 2-2i]);
crdisk(k).z        = [0.3+0.4i, -0.6+0.2i, 0.1-0.5i, 0.8+0.1i, 0.999 * exp(2i)];

k = k+1;
crdisk(k).label    = 'L';
crdisk(k).polygon  = polygon([1i -1+1i -1-1i 1-1i 1 0]);
crdisk(k).z        = [0.3+0.4i, -0.6+0.2i, 0.1-0.5i, 0.8+0.1i, 0.999 * exp(2i)];

% -----------------------------------------------------------------------
% ann  (doubly-connected: outer vertices + inner vertices)
% -----------------------------------------------------------------------
k = 0;

% TODO not all z values map forward and back correctly.
% Concentric squares (from legacy dctests IPOLY=1)
k = k+1;
q = sqrt(2);
a = 1 + q;
ann(k).label    = 'ann_concentric';
ann(k).polygon  = polygon([a+a*1i, -a+a*1i, -a-a*1i, a-a*1i]);
ann(k).inner    = [q, q*1i, -q, -q*1i];
ann(k).z        = [0.7i, -0.8, 0.6+0.3i];

% TODO Annulus map broken
% % General outer polygon with slit inner (stress test)
% k = k+1;
% ann(k).label    = 'ann_slit';
% ann(k).polygon  = polygon([-2-1i, 2-1i, 2+2i, -0.8+2i, 1+0.5i, -1+2i, -2+2i]);
% ann(k).inner    = [0, -1];
% ann(k).z        = [0.7i, -0.8, 0.6+0.3i];

% -----------------------------------------------------------------------
defs.disk   = disk;
defs.ext    = ext;
defs.hpl    = hpl;
defs.strip  = strip;
defs.rect   = rect;
defs.crdisk = crdisk;
defs.ann    = ann;

end
