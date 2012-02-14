 
% MKFIG1        A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 09 Apr 01

hold off
pc(log(D+.1)')
axis off
print -depsc dt-raw.eps

pc(dy')
axis off
print -depsc dt-dx.eps

pc(dx')
axis off
print -depsc dt-dy.eps

pc(atan2(dy(:,2:end),dx(2:end,:))')
colormap hsv
axis off
print -depsc dt-n-angle.eps

colormap gray
pc(sqrt(dy(:,2:end).^2 + dx(2:end,:).^2)')
axis off
print -depsc dt-n-mag.eps
