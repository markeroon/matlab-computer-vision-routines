function b = awf_borgefors(xsize, ysize, xstart, ystart, xscale, yscale, x, y)

% AWF_BORGEFORS Compute 2D distance transform
%               Points in x, y
%               awf_borgefors(W, H, x, y) allows for 3 * diam(x,y)

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 09 Apr 01

if nargin == 4
  % xi = [(x - xstart) / xscale]
  % So
  %  0 = [(xstart - xstart) / xscale];
  %  W = [(xend - xstart) / xscale];
  %  xscale = (xend - xstart) / xsize;
  x = xstart(:);
  y = ystart(:);
  % Set [xstart, ystart, xscale, yscale] to cover diam(x,y) * 3
  lo = min([x y]);
  hi = max([x y]);
  center = mean([hi; lo]);
  delta = hi - center;
  lo = center - 3 * delta;
  hi = center + 3 * delta;
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
  error('zoiks')
end

n=length(xi)
for k=1:n
  D(xi(k),yi(k)) = 0;
  Id(xi(k),yi(k)) = k;
end

DRangeX = [1:xsize] * xscale + xstart;
DRangeY = [1:ysize] * yscale + ystart;
hold off
imagesc(DRangeX, DRangeY, D')
colormap gray
hold on
plot(x,y,'r.');
drawnow

% Perform a forward chamfer convolution on the distance image and associates
% a second image (id) that reports on the ID of the nearest pixel.
disp('fwd')
for i=2:xsize
  for j=2:ysize-1
    vals = [
      D(i-1,j-1)+4
      D(i-1,j  )+3
      D(i-1,j+1)+4
      D(i  ,j-1)+3
      D(i  ,j  );
      ];
    [D(i,j), imin] = min(vals);
    
    switch imin
    case 1
      Id(i,j) = Id(i-1,j-1);
      
    case 2
      Id(i,j) = Id(i-1,j);
      
    case 3
      Id(i,j) = Id(i-1,j+1);
      
    case 4
      Id(i,j) = Id(i,j-1);
               
    case 5
    end
  end
end

hold off
imagesc(DRangeX, DRangeY, log(D)')
colormap gray
hold on
plot(x,y,'r.');
drawnow
pause

disp('back')
% Performs a backward chamfer convolution on the D and Id images.
for i=xsize-2:-1:1
  for j=ysize-2:-1:2
    vals = [
      D(i,j),
      D(i,j+1)+3,
      D(i+1,j-1)+4,
      D(i+1,j)+3,
      D(i+1,j+1)+4
      ];
    [D(i,j), imin] = min(vals);
    
    switch imin
    case 1
    case 2
      Id(i,j) = Id(i,j+1);
    case 3
      Id(i,j) = Id(i+1,j-1);
               
    case 4
      Id(i,j) = Id(i+1,j);
               
    case 5
      Id(i,j) = Id(i+1,j+1);
    end
  end
end

% Fill the borders of D and Id
for i=1:xsize
  D(i,1) = D(i,2);
  Id(i,1) = Id(i,2);
  D(i,ysize) = D(i,ysize-1);
  Id(i,ysize) = Id(i,ysize-1);
end

for i=1:ysize
  D(1,i) = D(2,i);
  Id(1,i) = Id(2,i);
  D(xsize,i) = D(xsize-1,i);
  Id(xsize,i) = Id(xsize-1,i);
end

hold off
imagesc(DRangeX, DRangeY, log(D)')
colormap gray
hold on
plot(x,y,'r.');
drawnow
pause

D = D / 3;

b.D = D;
b.Id = Id;
b.xsize = xsize;
b.ysize = ysize;
b.xstart = xstart;
b.ystart = ystart;
b.xscale = xscale;
b.yscale = yscale;
