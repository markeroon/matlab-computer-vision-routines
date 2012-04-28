function [Vn_ext] = init_normal_ENO3(Vn)
%
% Extends boundary of Vn
%
% Author: Baris Sumengen  sumengen@ece.ucsb.edu
% http://vision.ece.ucsb.edu/~sumengen/
%
% adapted by Mark Brophy (mbrophy5@csd.uwo.ca)

Vn_ext = zeros(size(Vn)+6);
Vn_ext(4:end-3,4:end-3,4:end-3) = Vn;

