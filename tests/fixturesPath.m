function p = fixturesPath()
%FIXTURESPATH  Return the absolute path to tests/fixtures.mat.
%
%   Called by all test classes during TestParameterDefinition.  Uses the
%   location of lapsolve.m (which is always on the toolbox root) as the
%   anchor, matching the convention used elsewhere in the toolbox.

here = fileparts(which('lapsolve'));
p    = fullfile(here, 'tests', 'fixtures.mat');
end
