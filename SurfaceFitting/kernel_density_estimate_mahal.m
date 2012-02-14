%KERNEL_DENSITY_ESTIMATE
%k number of nearest neighbours to use
% can formulate X_vec using X_vec = [ X1_vec', X2_vec', X3_vec' ];
% index is the row vector for which we will calculate the kernel density
%function [f,f_fixed_h,f_no_denom] = 
function [f_var_band,f_fixed_band,f_var_mah_denom,f_reach] = ...
    kernel_density_estimate_mahal( X_vec,index,radius,n ) %,h,h_fixed )

dim = size( X_vec,2 );
if size(X_vec,1) < dim
    error( 'dims are wrong, input X_vec^T' )
end
[id,dist_x] = neighborsWithinRadius( X_vec, X_vec(index,:), radius );
Y = X_vec(index,:);
X = X_vec(id,:);
[dist_mahal,norm_cov] = cvMahaldist(Y',X');
%f = 0;
f_fixed_band = 0;
f_var_band = 0;
f_var_mah_denom = 0;
f_reach = 0;
if size(id,1) >= 50
    for i=2:size(id,1) 
        [id_j] = neighborsWithinRadius( X_vec,X_vec(id(i),:),radius ); 
        [dist_mahal_j] = cvMahaldist( X_vec(id(i),:)',X_vec(id_j,:)' );
        dist_mahal_j_n = sort( dist_mahal_j, 'ascend' );        
        [id_n,dist_n] = kNearestNeighbors( X_vec(id,:),X_vec(id(i),:),n);
        %h_x = dist_n(n);
        f_var_mah_denom = f_var_mah_denom + 1/((2*pi)^(dim/2)*(dist_mahal_j_n(n))^dim*sqrt(norm_cov)) *exp(-dist_mahal(1,i)^2 / (2*dist_mahal_j_n(n)^2) );
        f_var_band = f_var_band + 1/((2*pi)^(dim/2)*(dist_n(n))^dim*sqrt(norm_cov)) *exp(-dist_mahal(1,i)^2 * radius / dist_n(n) );
        f_fixed_band = f_fixed_band + 1/((2*pi)^(dim/2)) * exp( -1 * (dist_mahal(1,i)^2) );
        f_reach = f_reach + 1/((2*pi)^(dim/2)*(dist_mahal_j_n(n))^dim*sqrt(norm_cov)) *exp(-(max(dist_mahal(1,i),dist_mahal_j_n(n))^2) / (2*dist_mahal_j_n(n)^2) );
    end
    % 1/m
    f_fixed_band = f_fixed_band / (size(id,1)-1);
    f_var_band = f_var_band / (size(id,1)-1);
    f_var_mah_denom = f_var_mah_denom / (size(id,1)-1);
    f_reach = f_reach / (size(id,1)-1);
    %f_fixed_h = f_fixed_h / (size(id,1)-1);

else
    %f = 0.0000000002;
    f_fixed_band = 0.000000002;
    f_var_band = 0.000000002;
    f_var_mah_denom = 0.00000002;
    f_reach = 0.00000003; 
end
end