function [lde] = local_density_estimate( X_vec,f,index,radius )
    
    [id,dist] = neighborsWithinRadius( X_vec, X_vec(index,:), radius );
    
    lde = sum( f(id) ) / size(id,1);
end