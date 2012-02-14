function scale = estimate_scale(M)

%%=====================================================================
%% Project:   Point Set Registration using Gaussian Mixture Model
%% Module:    $RCSfile: estimate_scale.m,v $
%% Language:  MATLAB
%% Author:    $Author$
%% Date:      $Date$
%% Version:   $Revision$
%%=====================================================================

[m,d] = size(M);
scale = det(M'*M/m);
for i=1:d
    scale = sqrt(scale);
end