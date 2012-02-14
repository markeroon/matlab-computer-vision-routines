function n = lsqnormest(p, k)
% Least squares normal estimation from point clouds using PCA
%
% H. Hoppe, T. DeRose, T. Duchamp, J. McDonald, and W. Stuetzle. 
% Surface reconstruction from unorganized points. 
% In Proceedings of ACM Siggraph, pages 71?78, 1992.
%
% p should be a matrix containing the horizontally concatenated column
% vectors with points. k is a scalar indicating how many neighbors the
% normal estimation is based upon.
%
% Note that for large point sets, the function performs significantly
% faster if Statistics Toolbox >= v. 7.3 is installed.
%
% Jakob Wilm 2010

m = size(p,2);
n = zeros(3,m);


v = ver('stats');
if str2double(v.Version) >= 7.3 
    neighbors = transpose(knnsearch(transpose(p), transpose(p), 'k', k+1));
else
    neighbors = kNearestNeighbors(p, p, k+1);
end

for i = 1:m
    x = p(:,neighbors(2:end, i));
    p_bar = 1/k * sum(x,2);
    
    P = (x - repmat(p_bar,1,k)) * transpose(x - repmat(p_bar,1,k)); %spd matrix P
    %P = 2*cov(x);
    
    [V,D] = eig(P);
    
    [nnnn, idx] = min(diag(D)); % choses the smallest eigenvalue
    
    n(:,i) = V(:,idx);   % returns the corresponding eigenvector    
end

