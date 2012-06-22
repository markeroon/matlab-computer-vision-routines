function [ idx_out,idx_in ] = findPointIndicesToNotRegister( ...
                           X,Y,max_registerable_dist )
% FINDPOINTINDICESTONOTREGISTER Find the points in Y whose
% closest point is larger than the max_registrable_dist
% 
% These are the points that will be registered to the secondary
% reference scan
idx_out = [];
idx_in = [];
for i=1:size(Y,1)
    [id,dist] = kNearestNeighbors(X,Y(i,:),1);
    if( dist > max_registerable_dist )
        idx_out = [idx_out i];
    else
        idx_in = [idx_in i];
    end
end
    idx_out = unique(idx_out);
    idx_in = unique(idx_in);

end

