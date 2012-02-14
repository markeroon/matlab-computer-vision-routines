%KERNEL_DENSITY_ESTIMATE
%k number of nearest neighbours to use
% can formulate X_vec using X_vec = [ X1_vec', X2_vec', X3_vec' ];
% index is the row vector for which we will calculate the kernel density
%function [f,f_fixed_h,f_no_denom] = 
function [f_var_band,f_fixed_band,f_var_mah_denom,f_reach] = ...
    kernel_density_estimate_mex( tree,X_vec,index,k,n ) %,h,h_fixed )

dim = size( X_vec,2 );
if size(X_vec,1) < dim
    error( 'dims are wrong, input X_vec^T' )
end

%[id,dist_x] = neighborsWithinRadius( X_vec, X_vec(index,:), k );
[idxs,dists] = kdtree_k_nearest_neighbors( tree, X_vec(index,:)', k );

Y = X_vec(index,:);
X = X_vec(idxs,:);
%X_old = X_vec(id,:);
[dist_mahal,norm_cov] = cvMahaldist(Y',X');
f_fixed_band = 0;
f_var_band = 0;
f_var_mah_denom = 0;
f_reach = 0;
%if size(id,1) >= 50
    
    %for i=2:size(id,1)
        %{ 
        [id_j] = neighborsWithinRadius( X_vec,X_vec(id(i),:),radius ); 
        [dist_mahal_j] = cvMahaldist( X_vec(id(i),:)',X_vec(id_j,:)' );
        dist_mahal_j_n = sort( dist_mahal_j, 'ascend' );        
        [id_n,dist_n] = kNearestNeighbors( X_vec(id,:),X_vec(id(i),:),n);
        %}
    for i=1:size(idxs,1)
        if dists(i) ~= 0
            [idxs_j,dists_j] = kdtree_k_nearest_neighbors( tree, X_vec(idxs(i),:)', k );
            dist_mahal_j = cvMahaldist( X_vec(idxs(i),:)',X_vec(idxs_j,:)' );
            dist_mahal_j_n = getSecondSmallestVal(dist_mahal_j);
            f_fixed_band = f_fixed_band + 1/((2*pi)^(dim/2)) * exp( -1 * (dist_mahal(1,i)^2) );
            if dist_mahal_j_n > eps
                f_var_mah_denom = f_var_mah_denom + 1/((2*pi)^(dim/2)*(dist_mahal_j_n)^dim*sqrt(norm_cov)) *exp(-dist_mahal(1,i)^2 / (2*dist_mahal_j_n^2) );
                f_reach = f_reach + 1/((2*pi)^(dim/2)*(dist_mahal_j_n)^dim*sqrt(norm_cov)) *exp(-(max(dist_mahal(1,i),dist_mahal_j_n)^2) / (2*dist_mahal_j_n^2) );
            end
        end
    end
    % 1/m
    f_fixed_band = f_fixed_band / (size(idxs,1)-1);
    f_var_band = f_var_band / (size(idxs,1)-1);
    f_var_mah_denom = f_var_mah_denom / (size(idxs,1)-1);
    f_reach = f_reach / (size(idxs,1)-1);

%{
else
    %f = 0.0000000002;
    f_fixed_band = 0.000000002;
    f_var_band = 0.000000002;
    f_var_mah_denom = 0.00000002;
    f_reach = 0.00000003; 
end
%}
end


function [second_smallest] = getSecondSmallestVal( arr )
 [val,idx] = min( arr );
 arr(idx) = realmax('double');
 second_smallest = min( arr );
end