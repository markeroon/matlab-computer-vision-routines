function x = icp_transrot(x, R, t, special)

% ICP_TRANSROT  Transform data by x -> R * (x + t)
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 04 Apr 01

dimension = size(x, 2);

if dimension == 2
  % Rot from scalar to matrix
  if all(size(R) == [1 1])
    c = cos(R);
    s = sin(R);
    R = [c s ; -s c];
  end
elseif dimension == 3
  if all(sort(size(R)) == [1 3])
    R = expm(cross_matrix(R(:)));
    det(R)
    eig(R)
  end
end

n = size(x,1);
l = ones(n,1);
t = t(:)';
  
x = (x + t(l,:)) * R';
