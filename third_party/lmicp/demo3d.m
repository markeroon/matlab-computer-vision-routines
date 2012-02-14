% function demo3d()

% DEMO3D        A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 28 Nov 01

bun000 = load('bun000.dat');
bun045 = load('bun045.dat');

% to subsample: bun000 = bun000(1:10:end,:);

% first run, no robustness
params = run_icp3d(bun045, bun000)

pause
% Second run with outlier threshold: 
% note that for efficiency we should not 
% recompute the distance transform, this is 
% left as an exercise to the reader.
params = run_icp3d(bun045, bun000, 3, params)
