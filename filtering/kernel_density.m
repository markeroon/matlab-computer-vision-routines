%KERNEL_DENSITY_ESTIMATE
%k number of nearest neighbours to use
% can formulate X_vec using X_vec = [ X1_vec', X2_vec', X3_vec' ];
% index is the row vector for which we will calculate the kernel density
function [f,f_fixed] = kernel_density( X_vec,index,radius,h,n )

dim = size( X_vec,2 );
id = neighborsWithinRadius( X_vec, X_vec(index,:), radius );
Y = X_vec(index,:);
X = X_vec(id,:);
dist_mahal = cvMahaldist(Y',X');
%dist_mahal_2 = cvMahaldist(X',Y');
f = 0;
f_fixed = 0;
for i=2:size(id,1) 
    %[id_n,dist_n] = kNearestNeighbors( X_vec,X_vec(id(i),:),n);
    %h_x = dist_n(n);
    %f = f + 1/((2*pi)^(dim/2)*(h_x)^dim) * exp( -1 * (dist_mahal(1,i)^2) / h );%/ (2*h_x^2) );
    f_fixed = f_fixed + 1/((2*pi)^(dim/2)) * exp( -1 * (dist_mahal(i)^2) / h );
end

% 1/m
%f = f / (size(id,1)-1);
f_fixed = f_fixed / (size(id,1)-1);
end