function b = awf_borgefors(xsize, ysize, xstart, ystart, xscale, yscale, x, y)

% AWF_BORGEFORS Compute 2D distance transform
%               Points in x, y
%               awf_borgefors(W, H, x, y) allows for 3 * diam(x,y)

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 09 Apr 01

if (nargin == 4) | (nargin == 5)
  %% 4 means (xsize, ysize, x, y)
  %% 5 means (xsize, ysize, EXPANDFACTOR, x, y)
  if nargin == 4
    EXPANDFACTOR = 3;
    x = xstart(:);
    y = ystart(:);
  else
    EXPANDFACTOR = xstart
    x = ystart(:);
    y = xscale(:);
  end
  
  % xi = [(x - xstart) / xscale]
  % So
  %  0 = [(xstart - xstart) / xscale];
  %  W = [(xend - xstart) / xscale];
  %  xscale = (xend - xstart) / xsize;
  % Set [xstart, ystart, xscale, yscale] to cover diam(x,y) * 3
  lo = min([x y]);
  hi = max([x y]);
  center = mean([hi; lo]);
  delta = hi - center;
  lo = center - EXPANDFACTOR * delta;
  hi = center + EXPANDFACTOR * delta;
  xstart = lo(1);
  ystart = lo(2);
  xscale = (hi(1) - xstart) / xsize;
  yscale = (hi(2) - ystart) / ysize;
end

% Max entry in distance array is 3 * max distance which is image diagonal
dmax = (xsize + ysize) * 3;

D = ones(xsize, ysize) * dmax;
Id = ones(xsize, ysize) * nan;

xi = round((x - xstart) / xscale);
yi = round((y - ystart) / yscale);

if (any(xi < 1) | any(yi < 1) | any(xi > xsize) | any(yi > ysize) )
  [xi yi]
  error('zoiks')
end

n=length(xi);
I = sub2ind(size(D), xi,yi);
D(I) = 0;
Id(I) = 1:n;

[b.D, b.Id] = awf_borgefors_internal(D, Id);
b.xsize = xsize;
b.ysize = ysize;
b.xstart = xstart;
b.ystart = ystart;
b.xscale = xscale;
b.yscale = yscale;

if 0
  DRangeX = [1:xsize] * xscale + xstart;
  DRangeY = [1:ysize] * yscale + ystart;
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
end
