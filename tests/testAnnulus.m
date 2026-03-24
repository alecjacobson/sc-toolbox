classdef testAnnulus < matlab.unittest.TestCase
%TESTANNULUS  Regression tests for annulusmap.
%
%   Note: annulusmap does not support evaldiff or accuracy, so those tests
%   are absent here.

    properties
        entries = []
    end

    methods (TestClassSetup)
        function loadEntries(testCase)
            p = fixturesPath();
            if exist(p, 'file') ~= 2, return; end
            s = load(p, 'ann');
            if isfield(s, 'ann'), testCase.entries = s.ann; end
        end
    end

    methods (Access = private)
        function m = buildMap(~, fix)
            opt = sctool.scmapopt('trace', 0, 'tol', 1e-12);
            p_outer = polygon(fix.vertices, fix.angles);
            p_inner = polygon(fix.inner);
            m       = annulusmap(p_outer, p_inner, opt);
        end
    end

    methods (Test)

        function testForwardMap(testCase)
            testCase.assumeNotEmpty(testCase.entries, ...
                'fixtures.mat not found — run generateFixtures() first');
            for k = 1:numel(testCase.entries)
                fix    = testCase.entries(k);
                m      = testCase.buildMap(fix);
                result = arrayfun(@(z) eval(m, z), fix.z);
                testCase.verifyEqual(result, fix.fwd, ...
                    'AbsTol', fix.tol * 50, fix.label);
            end
        end

        function testInverseMap(testCase)
            testCase.assumeNotEmpty(testCase.entries, ...
                'fixtures.mat not found — run generateFixtures() first');
            for k = 1:numel(testCase.entries)
                fix    = testCase.entries(k);
                m      = testCase.buildMap(fix);
                result = arrayfun(@(w) evalinv(m, w), fix.fwd);
                testCase.verifyEqual(result, fix.z, ...
                    'AbsTol', fix.tol * 50, fix.label);
            end
        end

        function testRoundTrip(testCase)
            % Self-verifying: forward then inverse should recover z.
            testCase.assumeNotEmpty(testCase.entries, ...
                'fixtures.mat not found — run generateFixtures() first');
            for k = 1:numel(testCase.entries)
                fix = testCase.entries(k);
                m   = testCase.buildMap(fix);
                fwd = arrayfun(@(z) eval(m, z), fix.z);
                inv = arrayfun(@(w) evalinv(m, w), fwd);
                testCase.verifyEqual(inv, fix.z, 'AbsTol', 1e-8, fix.label);
            end
        end

        function testPlot(testCase)
            testCase.assumeNotEmpty(testCase.entries, ...
                'fixtures.mat not found — run generateFixtures() first');
            for k = 1:numel(testCase.entries)
                fix = testCase.entries(k);
                m   = testCase.buildMap(fix);
                fig = figure('Visible', 'off');
                oc  = onCleanup(@() close(fig));
                plot(m, 3, 2);
            end
        end

    end

end
