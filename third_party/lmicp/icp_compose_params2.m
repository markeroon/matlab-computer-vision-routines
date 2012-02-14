function p = icp_compose_params(p_new, p_current)

% When d' = R d + t, compose params
% Final data will be [Rn tn] * [Rc tc] * data

[Rc, tc] = icp_deparam(p_current);
[Rn, tn] = icp_deparam(p_new);
% Rn (Rc d + tc) + tn
% Rn Rc d + Rn tc +tn
R = Rn * Rc;
t = Rn * tc(:) + tn(:);
p = icp_param(R, t);
