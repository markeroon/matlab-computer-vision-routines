function mk_fig_nr(cx, cx2)

% MK_FIG_NR     A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 13 Apr 01

a=[208.2402  349.9251   14.2793  150.8692];

nr = loadimage('data\nrcolorb.ppm');
hold off; 
image(nr(:,:,[3 2 1])/2.0 + 0.5); 
hold on;
axis equal
axis off
drawnow
axis(a);
drawnow

set(scatter(cx, 'k+'), 'markersize', 2);
set(scatter(cx2, 'b+'), 'markersize', 2);

print -depsc /awf/doc/papers/icp/fig_nr.eps
