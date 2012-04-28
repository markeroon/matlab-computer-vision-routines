function [dist_m] = mahalanobis_distance( X,Y )
    
    D = Y - repmat( X,size(Y,1),1);
    H = D * D'
    H_inv = inv(H);
    
end