function fig_corr()

% FIG_CORR      A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 10 Sep 01

t = linspace(0,1,100)';

box = [1-t 1+0*t; 0*t t; t 0*t; 1+0*t t];

model = box * diag([2 1]);

rotangle = 65;
translation = [1.5 2.8];
data = awf_transform_pts(model, rot2d(rotangle / 180 * pi), translation);
data = data + randn(size(data))*.01;

hold off
scatter(model, 'r.');
hold on
scatter(data, 'b.');

axis equal

axis off

