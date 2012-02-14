function [R, t] = icp_solve3d_euclid(M, D)

% ICP_SOLVE3D_EUCLID A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 10 Apr 01

% min M - T * D

[R,t] = svdtrans(D', M');

% So M' = R * D' + t
t=t';


%Dprime = D * R' + t(ones(1,size(D,1)), :);
%err = norm(M - Dprime, 'fro');
