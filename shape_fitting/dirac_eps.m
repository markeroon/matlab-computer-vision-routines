function [ dirac_eps_x ] = dirac_eps( x,eps_val )
%DIRAC_EPS Approximation of delta dirac function
% Specifically for level set functions.  When delta_x = 1 and 
% x = 1, we know that we are very close to the contour
    dirac_eps_x = (1.0 / pi) * (eps_val / (eps_val^2 + x^2));

end

