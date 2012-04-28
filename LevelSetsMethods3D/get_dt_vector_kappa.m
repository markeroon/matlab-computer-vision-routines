function [dt] = get_dt_vector_kappa(alpha,dx,dy,dz, u,v,w, b,dx2,dy2,dz2)
%
% Calculate the Euler time step.
%
% Author: Baris Sumengen  sumengen@ece.ucsb.edu
% http://vision.ece.ucsb.edu/~sumengen/
%



if alpha <= 0 | alpha >= 1 
    error('alpha needs to be between 0 and 1!');
end

maxs = max(max(max(abs(u)/dx + abs(v)/dy + abs(w)/dz + (2*b)/dx2 + (2*b)/dy2 + (2*b)/dz2)));
dt = alpha/(maxs+(maxs==0));
