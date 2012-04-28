function [idx,dist_idx] = neighborsWithinRadius(dataMatrix, queryMatrix, radius)
% 
% Usage:
% [neighbors distances] = kNearestNeighbors(dataMatrix, queryMatrix, k);
% dataMatrix  (N x D) - N vectors with dimensionality D (within which we search for the nearest neighbors)
% queryMatrix (M x D) - M query vectors with dimensionality D
% radius           (1 x 1) - max distance of points
k = size(dataMatrix,1);
neighborIds = zeros(size(queryMatrix,1),k);
neighborDistances = neighborIds;

numDataVectors = size(dataMatrix,1);
numQueryVectors = size(queryMatrix,1);
for i=1:numQueryVectors,
    dist = sum((repmat(queryMatrix(i,:),numDataVectors,1)-dataMatrix).^2,2);
    %[sortval sortpos] = sort(dist,'ascend');
    %neighborIds(i,:) = sortpos(1:k);
    %neighborDistances(i,:) = sqrt(sortval(1:k));
end

idx = find( dist < radius );
dist_idx = dist(idx);
