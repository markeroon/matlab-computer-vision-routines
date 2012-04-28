function [registered_tumor] = registerToStaple( X,primary_seg_idx,staple_primary_idx,opts ) 
registered_tumor = cell(length(primary_seg_idx),1);
for i=1:length(primary_seg_idx)
    Y = X{primary_seg_idx(i)};
    [T] = cpd_register(X{staple_primary_idx},Y,opt);
    registered_tumor{i} = T;
    registered_tumor{i}.flow_vec = T.W;
    registered_tumor{i}.flow_magnitude = ...
        sqrt(sum(registered_tumor{i}.flow_vec.^2,2));
    registered_tumor{i}.variance_of_flow_mag = ...
        var( registered_tumor{i}.flow_magnitude );
    registered_tumor{i}.name = names{primary_seg_idx(i)};
    [neighbour_id,neighbour_dist] = kNearestNeighbors(...
        Y,X{staple_primary_idx}, 1 );
    registered_tumor{i}.nearest_neighbour_dist = neighbour_dist;
    registered_tumor{i}.rms_e = ...
        sqrt( sum(neighbour_dist(:)) / length(neighbour_dist(:)) );
end

end

