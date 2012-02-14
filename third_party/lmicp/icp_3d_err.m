function [e, J] = icp_3d_err(p, D)

% ICP_3D_ERR    Error function for icp3d
%               p params
%               D data points

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 31 Aug 01

for k=1:size(D,1)
  Dk = D(k,:);
  
  [T, dTdp] = transform(p, Dk);
end


R = coolquat2mat([p1 p2 p3 p4]) / norm([p1 p2 p3 p4]);
t = [p5 p6 p7];
