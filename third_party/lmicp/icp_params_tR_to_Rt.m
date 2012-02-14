function params = icp_params_tR_to_Rt(params)

% ICP_PARAMS_TR_TO_RT Convert params R(x+t) to Rx + t
%               R(x+t)
%               Rx + Rt

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 10 Sep 01

[R, t] = icp_deparam(params);
params = icp_param(R, R*t(:));
