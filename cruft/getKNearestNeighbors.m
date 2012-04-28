function [X_near] = getKNearestNeighbors( X_vec,index,k )
    X = X_vec(index,:);
    X_repmat = repmat( X,size(X_vec,1),1 );
    [norm_sort,idx] = sort( norm( X_vec-X_repmat ) );     
    X_near = X_vec(idx(2:k+1),:); % the closest idx will be X itself
    %X_near = X(idx);
end