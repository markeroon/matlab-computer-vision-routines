function [newdata, params, final_err, iters] = ...
    icp_2dbasic(x, model, data, m_estimator_param, GX)

params = [0 0 0];
iters = 0;


for M_Schedule = [15 5 2]
  [data, newparams, final_err, niters] = ...
      icp_2dbasic_step(x, model, data, M_Schedule * m_estimator_param, GX);
  params = icp_compose_params(newparams, params); iters = iters + niters;
end
