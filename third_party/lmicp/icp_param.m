function p = icp_param(R, t)

% Parametrize 2D rototranslation. opp of icp_deparam

p = [atan2(R(1,2), R(1,1)) t(1) t(2)];
