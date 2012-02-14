k = 5;
d = 3;
% X_s is set of surface points
X_s = zeros( 3,k );
%X_s(:,i) is the ith point living in R^d
X_s(:,1) = [2 2 2];
X_s(:,2) = [4 3 2];
X_s(:,3) = [5 2 2];
X_s(:,4) = [2 3 2];
X_s(:,5) = [2 5 2];

[x,y,z] = meshgrid(-10:15,-5:16,-11:12);
n = size(x(:),1);

X = zeros( 3,n );
X(1,:) = x(:);
X(2,:) = y(:);
X(3,:) = z(:);

[D,d] = compute_distance_to_points(X,X_s);
