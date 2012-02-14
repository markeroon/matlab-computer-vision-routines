function [m3d, T] = icp_3dbasic_init(model)

% ICP_3DBASIC_INIT A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 10 Apr 01

m3d = model;

if 0
  
  % Add cube...
  [X,Y,Z] = cylinder([1 1 1], 8); 
  C = [X(:) Y(:) Z(:)];
  
  m3d = [m3d; C * .5];
  
  % And noise
  m3d = m3d + randn(size(m3d)) * 0.0001;
end

T = delaunayn(m3d);
