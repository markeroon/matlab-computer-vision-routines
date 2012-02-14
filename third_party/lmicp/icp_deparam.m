function [R, t] = icp_deparam(params)

% ICP_DEPARAM   Convert [theta , tx , ty] into [R,t]
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 06 Apr 01

c = cos(params(1));
s = sin(params(1));
R = [c s; -s c];
t = [params(2) params(3)];
