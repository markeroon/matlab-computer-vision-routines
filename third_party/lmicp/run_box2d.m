function run_box2d()

% RUN_BOX2D     A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 08 Sep 01

t = linspace(0,1,100)';

box = [1-t 1+0*t; 0*t t; t 0*t; 1+0*t t];

model = box * diag([2 1]);

rotangle = 65;
translation = [.5 .8];
data = awf_transform_pts(model, rot2d(rotangle / 180 * pi), translation);
data = data + randn(size(data))*.01;

GX = 2;

[newdata, newparams, final_err, niters_lm] = ...
    icp_2d_lm(model, model, data, 'ls', 100, GX);
fprintf('lm icp done, niters = %d\n', niters_lm);

[newdata, newparams, final_err, niters] = ...
    icp_2dbasic_step(model, model, data , 100, GX);
fprintf('regular icp done, niters = %d\n', niters);

fprintf('Old/LM = %d/%d\n', niters, niters_lm);
