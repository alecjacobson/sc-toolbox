classdef testHalfplane < matlab.unittest.TestCase
%TESTHALFPLANE  Regression tests for hplmap.

    properties
        entries = []
    end

    methods (TestClassSetup)
        function loadEntries(testCase)
            p = fixturesPath();
            if exist(p, 'file') ~= 2, return; end
            s = load(p, 'hpl');
            if isfield(s, 'hpl'), testCase.entries = s.hpl; end
        end
    end

    methods (Access = private)
        function m = buildMap(~, fix)
            opt = sctool.scmapopt('trace', 0, 'tol', 1e-12);
            m   = hplmap(polygon(fix.vertices, fix.angles), opt);
        end
    end

    methods (Test)

        function testForwardMap(testCase)
            testCase.assumeNotEmpty(testCase.entries, ...
                'fixtures.mat not found — run generateFixtures() first');
            for k = 1:numel(testCase.entries)
                fix = testCase.entries(k);
                m   = testCase.buildMap(fix);
                testCase.verifyEqual(eval(m, fix.z), fix.fwd, ...
                    'AbsTol', fix.tol * 50, fix.label);
            end
        end

        function testInverseMap(testCase)
            testCase.assumeNotEmpty(testCase.entries, ...
                'fixtures.mat not found — run generateFixtures() first');
            for k = 1:numel(testCase.entries)
                fix = testCase.entries(k);
                m   = testCase.buildMap(fix);
                testCase.verifyEqual(evalinv(m, fix.fwd), fix.z, ...
                    'AbsTol', fix.tol * 50, fix.label);
            end
        end

        function testDerivative(testCase)
            testCase.assumeNotEmpty(testCase.entries, ...
                'fixtures.mat not found — run generateFixtures() first');
            for k = 1:numel(testCase.entries)
                fix = testCase.entries(k);
                m   = testCase.buildMap(fix);
                testCase.verifyEqual(evaldiff(m, fix.z), fix.diff, ...
                    'AbsTol', fix.tol * 50, fix.label);
            end
        end

        function testAccuracy(testCase)
            testCase.assumeNotEmpty(testCase.entries, ...
                'fixtures.mat not found — run generateFixtures() first');
            for k = 1:numel(testCase.entries)
                fix = testCase.entries(k);
                m   = testCase.buildMap(fix);
                testCase.verifyLessThan(accuracy(m), fix.tol * 50, fix.label);
            end
        end

        function testDerivativeFiniteDiff(testCase)
            testCase.assumeNotEmpty(testCase.entries, ...
                'fixtures.mat not found — run generateFixtures() first');
            z = [0.3+0.3i, 0.7+0.5i, 0.5+0.8i];   % Re in (0,1), Im in (0.1,1)
            for k = 1:numel(testCase.entries)
                fix = testCase.entries(k);
                m   = testCase.buildMap(fix);
                h   = 1e-6;
                fd  = (eval(m, z+h) - eval(m, z-h)) / (2*h);
                testCase.verifyEqual(evaldiff(m, z), fd, ...
                    'AbsTol', 1e-5, fix.label);
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
                plot(m, 2, 3);
            end
        end

    end

end
