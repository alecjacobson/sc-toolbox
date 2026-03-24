function generateFixtures(which)
%GENERATEFIXTURES  Generate reference values for SC Toolbox regression tests.
%
%   generateFixtures()         regenerate fixtures for all map types
%   generateFixtures('disk')   regenerate only the disk fixtures
%   generateFixtures({'disk','ann'})  regenerate a subset
%
%   Valid map type names: 'disk', 'ext', 'hpl', 'strip', 'rect', 'crdisk', 'ann'
%
%   Run this function from MATLAB (with the SC Toolbox on the path) whenever
%   polygon definitions change or a new polygon is added to fixturePolygons.m.
%   Results are saved to tests/fixtures.mat.
%
%   Each map type stores a struct array indexed by polygon, with fields:
%     label    — identifier matching fixturePolygons entry
%     polygon  — target polygon
%     z        — evaluation points
%     fwd      — forward map values
%     inv      — inverse map values
%     diff     — derivative values (where supported)
%     acc      — accuracy estimate (where supported)
%     tol      — expected tolerance

ALL_TYPES = {'disk', 'ext', 'hpl', 'strip', 'rect', 'crdisk', 'ann'};

if nargin < 1
    which = ALL_TYPES;
elseif ischar(which)
    which = {which};
end

% Validate requested types
for i = 1:numel(which)
    if ~ismember(which{i}, ALL_TYPES)
        error('Unknown map type ''%s''. Valid types: %s', ...
              which{i}, strjoin(ALL_TYPES, ', '));
    end
end

% Locate output path
here    = fileparts(mfilename('fullpath'));
outpath = fullfile(here, 'fixtures.mat');
opt     = sctool.scmapopt('trace', 0, 'tol', 1e-12);

% Load existing fixtures if the file exists (to preserve types not being regenerated)
if exist(outpath, 'file') == 2
    saved = load(outpath);
else
    saved = struct();
end

defs = fixturePolygons();

for ti = 1:numel(which)
    type = which{ti};
    fprintf('--- %s ---\n', type);
    results = [];

    entries = defs.(type);

    for ki = 1:numel(entries)
        d = entries(ki);
        fprintf('  polygon: %s\n', d.label);

        z = d.z;
        p = d.polygon;

        try
            switch type
                case 'disk'
                    m = diskmap(p, opt);
                    r = buildRecord(d, z, m, true, true);

                case 'ext'
                    m = extermap(p, opt);
                    r = buildRecord(d, z, m, true, true);

                case 'hpl'
                    m = hplmap(p, opt);
                    r = buildRecord(d, z, m, true, true);

                case 'strip'
                    m = stripmap(p, d.ends, opt);
                    r = buildRecord(d, z, m, true, true);
                    r.ends = d.ends;

                case 'rect'
                    m = rectmap(p, d.corners, opt);
                    r = buildRecord(d, z, m, true, true);
                    r.tol     = 1e-9;   % rectmap converges less tightly
                    r.corners = d.corners;

                case 'crdisk'
                    m = crdiskmap(p, opt);
                    r = buildRecord(d, z, m, true, true);

                case 'ann'
                    m = annulusmap(p, polygon(d.inner), opt);
                    r = buildRecord(d, z, m, false, false);
                    r.inner = d.inner;   % needed by testAnnulus to rebuild the map
            end

            % Round-trip sanity check
            if isfield(r, 'inv')
                err = norm(z(:) - r.inv(:), inf);
                if err > r.tol * 1000
                    warning('Round-trip error %.2e for %s/%s exceeds threshold', ...
                            err, type, d.label);
                end
            end

            results = [results, r]; %#ok<AGROW>

        catch ME
            warning('FAILED to generate fixture for %s/%s:\n  %s', ...
                    type, d.label, ME.message);
        end
    end

    if ~isempty(results)
        saved.(type) = results;
        fprintf('  %d polygon(s) stored for %s\n', numel(results), type);
    else
        fprintf('  no polygons found for %s\n', type);
    end
end

save(outpath, '-struct', 'saved');
fprintf('\nSaved %s\n', outpath);
end

% -----------------------------------------------------------------------

function r = buildRecord(d, z, m, hasDiff, hasAcc)
%BUILDRECORD  Evaluate map and collect results into a fixture struct.

r.label    = d.label;
r.vertices = vertex(d.polygon);
r.angles   = angle(d.polygon);
r.z        = z;
r.tol      = 1e-12;

r.fwd = eval(m, z);
r.inv = evalinv(m, r.fwd);

if hasDiff
    r.diff = evaldiff(m, z);
end

if hasAcc
    r.acc = accuracy(m);
end
end
