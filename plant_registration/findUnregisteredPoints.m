function [Y_unreg] = findUnregisteredPoints( X,Y,threshold_dist )
%FINDUNREGISTEREDPOINTS Return points in X that don't fit Y 
%sufficiently well

Y_unreg = [];
for i=1:size(Y,1)
       [id,dist] = neighborsWithinRadius( X,Y(i,:),threshold_dist );
       if isempty( id ), Y_unreg = [Y_unreg ; Y(i,:)]; end
       
end

end

