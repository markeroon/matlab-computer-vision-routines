function [ idx ] = findPointIndicesToNotRegister( ...
                           dataMatrix, queryMatrix,max_registrable_dist )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

neighborIds = zeros(size(queryMatrix,1),k);
neighborDistances = neighborIds;

numDataVectors = size(dataMatrix,1);
numQueryVectors = size(queryMatrix,1);
for i=1:numQueryVectors,
    dist = sum((repmat(queryMatrix(i,:),numDataVectors,1)-dataMatrix).^2,2);
    [sortval sortpos] = sort(dist,'ascend');
    neighborIds(i,:) = sortpos(1:k);
    neighborDistances(i,:) = sqrt(sortval(1:k));
end

idx = find( neighborDistances > max_registrable_dist );

end

