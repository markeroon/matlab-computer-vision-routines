%KERNEL_DENSITY_ESTIMATE
%k number of nearest neighbours to use
% can formulate X_vec using X_vec = [ X1_vec', X2_vec', X3_vec' ];
% index is the row vector for which we will calculate the kernel density
%function [f,f_fixed_h,f_no_denom] = 
function [f_var_band,f_fixed_band] = ...
    kernel_density_estimate_within_radius( X_vec,index,radius,n ) %,h,h_fixed )

dim = size( X_vec,2 );
if size(X_vec,1) < dim
    error( 'dims are wrong, input X_vec^T' )
end
[id,dist_x] = neighborsWithinRadius( X_vec, X_vec(index,:), radius );
Y = X_vec(index,:);
X = X_vec(id,:);
dist_mahal = cvMahaldist(Y',X');
%f = 0;
f_fixed_band = 0;
f_var_band = 0;
if size(id,1) >= 50
    for i=2:size(id,1) 
        [id_n,dist_n] = kNearestNeighbors( X_vec(id,:),X_vec(id(i),:),n);
        h_x = dist_n(n);
        f_var_band = f_var_band + 1/((2*pi)^(dim/2)*(h_x)^dim) * exp( -1 * (dist_mahal(1,i)^2) );
        f_fixed_band = f_fixed_band + 1/((2*pi)^(dim/2)) * exp( -1 * (dist_mahal(1,i)^2) );
    end
    % 1/m
    f_fixed_band = f_fixed_band / (size(id,1)-1);
    f_var_band = f_var_band / (size(id,1)-1);
    %f_fixed_h = f_fixed_h / (size(id,1)-1);

else
    %f = 0.0000000002;
    f_fixed_band = 0.000000002;
    f_var_band = 0.000000002;
end
end
%h * dist_n(n);
%rd_k = max(dist_n(1,k),dist(1,i));
%f = f + 1/((2*pi)^(dim/2)*(h_x)^dim) * exp( -1 * (dist_mahal(1,i)^2) / (2*h_x^2) );  
%f = f + 1/((2*pi)^(dim/2)*(1)^dim) * exp( -1 * (dist_mahal(1,i)^2) / (2*h_x^2) );
%f_fixed_h = f_fixed_h + 1/((2*pi)^(dim/2)*(h_fixed)^dim) * exp( -1 * (dist_mahal(1,i)^2) / (2*h_fixed^2) );
            