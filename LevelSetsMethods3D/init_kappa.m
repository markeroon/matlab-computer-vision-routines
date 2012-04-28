function [dx2, dy2, dz2] = init_kappa(dx,dy,dz)
%
% calculates dx^2 and dy^2 to prevent these from being
% constantly recalculated.
%
% Author: Baris Sumengen  sumengen@ece.ucsb.edu
% http://vision.ece.ucsb.edu/~sumengen/
%

dx2 = dx*dx;
dy2 = dy*dy;
dz2 = dz*dz;