function D = awf_borgefors_morph(BinaryImage)

% AWF_BORGEFORS_MORPH A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 06 Aug 01

[xsize ysize] = size(BinaryImage);
% Max entry in distance array is 3 * max distance which is image diagonal
dmax = (xsize + ysize) * 3;

D = (~BinaryImage) * dmax;
Id = ones(xsize, ysize) * nan;

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
    D(i,j) = min(vals);
  end
end

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
    D(i,j) = min(vals);
  end
end

% Fill the borders of D and Id
for i=1:xsize
  D(i,1) = D(i,2);
  D(i,ysize) = D(i,ysize-1);
end

for i=1:ysize
  D(1,i) = D(2,i);
  D(xsize,i) = D(xsize-1,i);
end

D = D / 3;
