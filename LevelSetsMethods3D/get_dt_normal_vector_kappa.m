function [dt] = get_dt_normal_vector_kappa(alpha, dx, dy, dz, H1_abs, H2_abs, H3_abs, b, dx2, dy2,dz2 )
%
% Calculate the Euler time step.  Adapted from Baris Sumengen's work.
% sumengen@ece.ucsb.edu
% alpha is a const for calculating max timestep: 0.1-0.5 is safe, 0.9 risky
if alpha <= 0 | alpha >= 1 
    error('alpha needs to be between 0 and 1!');
end

maxs = max(max(max( H1_abs/dx + H2_abs/dy + H3_abs/dz + (2*b)/dx2 + (2*b)/dy2 + (2*b)/dz2 )));
dt = alpha/(maxs+(maxs==0));