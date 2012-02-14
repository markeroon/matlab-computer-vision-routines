function awf_borgefors_fill_bdry(D,Id)

% AWF_BORGEFORS_FILL_BDRY A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 09 Apr 01

[xsize, ysize] = size(D);

Id = D;

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

pc(log(D))
