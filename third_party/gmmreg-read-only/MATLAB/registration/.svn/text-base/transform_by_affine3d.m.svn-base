% [result] = transform_by_affine3d(pointset, param)
% perform a 3D affine transform on a pointset and
% return the transformed pointset
% the param is expected in the order of 
%  [tx ty tz a11 a21 a31 a12 a22 a32 a13 a23 a33] or
%  [tx a11 a12 a13]
%  [ty a21 a22 a23]
%  [tz a31 a32 a33]
%
% See also: transform_by_affine2d, transform_by_rigid3d
function [result] = transform_by_affine3d(pointset, param)
%%=====================================================================
%% $RCSfile: transform_by_affine3d.m,v $
%% $Author$
%% $Date$
%% $Revision$
%%=====================================================================
n = size(pointset,1);
A = reshape(param,3,4);   A = A'; 
result =  [ones(n,1)  pointset(:,1:3)]*A;
        
