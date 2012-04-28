%KERNEL_DENSITY Returns the zero-mean Gaussian with unit standard dev
% l2_norm_x - the distance between point x and a nearest neighbor
function [K_x] = K( l2_norm_x,h_xi )
    K_x = 1/(2*pi)^dim * exp( -1 * (l2_norm_x^2) / (2*(h_xi^2)) );
end