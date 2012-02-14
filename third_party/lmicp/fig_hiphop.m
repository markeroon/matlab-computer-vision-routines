function fig_hiphop()

% FIG_HIPHOP    A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 10 Sep 01

OFF = 0.5;
R = linspace(-1,1);
[xx, yy] = meshgrid(R-OFF);

a = diag(sqrt([10 1])) * rot2d(30 * pi/180);
a = inv(a'*a);

z = a(1) * xx.^2 + 2*a(2) * xx.*yy + a(4) * yy.^2;

hold off
imagesc(R,R,sqrt(z))
axis equal
axis off
hold on
[c,h] = contour(R,R,z);
set(h, 'edgecolor', 'k')


p = [-1.2 -1.4];

allp = [
  p
  ];

% min z = a(1) * p1.^2 + 2*a(2) * p1.*yy + a(4) * yy.^2;
% diff = 2 y a(4) + 2 a(2) p1 = 0
%        y = -a(2) p(1) / a(4);
% Then
%        2 x a(1) + 2 * a(2) * p(2) x + a(4) * p(2)^2
%        x = -a(2) p(2) / a(1)

for k=1:10
  y = -a(2) * p(1) / a(4);
  p = [p(1) y];
  allp = [allp; p];
  
  x = -a(2) * p(2) / a(1);
  p = [x p(2)];
  allp = [allp; p];
end
allp = allp + OFF;

set(scatter(allp, 'ro'), 'markersize', 3);
set(scatter(allp, 'r-'), 'linewidth', 2);

set(text(allp(1,1), allp(1,2), ' Start'), 'color', 'red')

