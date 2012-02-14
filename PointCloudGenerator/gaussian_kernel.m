function [k_u] = gaussian_kernel( u )
    
    k_u = (1 / sqrt(2*pi)) * exp( -.5 * u^2 ); 


end