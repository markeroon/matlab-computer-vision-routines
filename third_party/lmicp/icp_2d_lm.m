function [newdata, params, final_err, count] = ...
    icp_2d_lm(x, model, data, m_estimator, DTOL, GX)

% ICP_2D_LM     A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 08 Sep 01

borgefors = icp_2d_lm_init(model);

[newdata, params, final_err, count] = ...
    icp_2d_lm_aux(borgefors, model, data, m_estimator, DTOL, GX);
