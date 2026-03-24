classdef testRectangle < matlab.unittest.TestCase
%TESTRECTANGLE  Regression tests for rectmap.

    properties
        entries = []
    end

    methods (TestClassSetup)
        function loadEntries(testCase)
            p = fixturesPath();
            if exist(p, 'file') ~= 2, return; end
            s = load(p, 'rect');
            if isfield(s, 'rect'), testCase.entries = s.rect; end
        end
    end

    methods (Access = private)
        function m = buildMap(~, fix)
            opt = sctool.scmapopt('trace', 0, 'tol', 1e-12);
            m   = rectmap(polygon(fix.vertices, fix.angles), fix.corners, opt);
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
            for k = 1:numel(testCase.entries)
                z = [0.1 + 0.5i, 0.2i];
                fix = testCase.entries(k);
                m   = testCase.buildMap(fix);
                h   = 1e-6;
                fd  = (eval(m, z+h) - eval(m, z-h)) / (2*h);
                testCase.verifyEqual(evaldiff(m, z), fd, ...
                    'AbsTol', 1e-4, fix.label);   % rectmap less tight
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
                plot(m, 4, 3);
            end
        end

    end

end
