function [idx_radius] = ...
                    findAverageDensityForPoints( X_vec,radius,num_points )
    idx = randint( num_points, 1,[1 size(X_vec,1)] );
    X_vec_subset = X_vec(idx,:);
    idx_radius = cell(size(idx,1),1);
    idx_ball = cell(size(idx,1),1);
    dist_radius = cell(size(idx,1),1);
    dist_ball = cell(size(idx,1),1);
    tree = kdtree_build(X_vec);
    
    for i=1:size(idx,1)
        [idx_radius{i},dist_radius{i}] = neighborsWithinRadius(X_vec, X_vec_subset(i,:), radius);
        [idx_ball{i}, dist_ball{i}] = kdtree_ball_query( tree, X_vec_subset(i,:), radius);
    end
end