function x = icp_rotaboutcenter(x, R)

% ICP_ROTABOUTCENTER  x = R * (x - c) + c
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 14 Apr 01

% Rot from scalar to matrix
if all(size(R) == [1 1])
  R = R / 180 * pi;
  c = cos(R);
  s = sin(R);
  R = [c s ; -s c];
end

t = mean(x);

n = size(x,1);
l = ones(n,1);

T = t(l,:);

x = (x - T) * R' + T;
