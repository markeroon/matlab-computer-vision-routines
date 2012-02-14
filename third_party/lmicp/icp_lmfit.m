function [data, params, err, iters] = ...
    icp_lmfit(x, model, data, m_estimator, m_estimator_param, GX)

% ICP_LMFIT     A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 06 Apr 01

% Translate both sets to model mean for conditioning
I = finite(model(:,1));
t0 = -mean(model(I,:));
R0 = eye(2);
x = awf_transform_pts(x, R0, t0);
model = awf_transform_pts(model, R0, t0);
data = awf_transform_pts(data, R0, t0);

% Initial guess is nuffink
p = [0 0 0];

Origdata = data;

% minimize
iters = 0;
if strcmp(m_estimator, 'ls')
  [data, params, err, niters] = icp_2d_lm(x, model, data, m_estimator, 2 * m_estimator_param, GX);
  p = icp_compose_params2(params, p); iters = iters + niters;
else
  borgefors = icp_2d_lm_init(model, 500, 1.4);
  
  MPARAM_Schedule = [15 12 5 2 1];
  for MPARAM = MPARAM_Schedule
    [data, params, err, niters] = ...
	icp_2d_lm_aux(borgefors, model, ...
	              data, ...
                      m_estimator, MPARAM * m_estimator_param, ...
		      GX, ...
		  Origdata);
		  

    p = icp_compose_params2(params, p); iters = iters + niters;
  end
end

params = icp_compose_params2(p, [0 t0]);
params = icp_compose_params2([0 -t0], params);
