function awf_borgefors_demo()

% AWF_BORGEFORS_DEMO A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 08 Sep 01

N = 256;

n = 20;

x = rand(n,1);
y = rand(n,1);

tic
b = awf_borgefors(N,N, -1/N, -1/N, 1/(N-2), 1/(N-2), x,y)
toc

DRangeX = [1:b.xsize] * b.xscale + b.xstart;
DRangeY = [1:b.ysize] * b.yscale + b.ystart;
hold off
Z = 0*b.Id;
H = b.Id/max(b.Id(:));
S = ones(size(b.Id));
V = b.D/max(b.D(:));
V = V.^.3;
imagesc(DRangeX, DRangeY, hsv2rgb(cat(3, H', S', V')))
hold on
plot(x,y,'r.');
drawnow

voronoi(x,y)
