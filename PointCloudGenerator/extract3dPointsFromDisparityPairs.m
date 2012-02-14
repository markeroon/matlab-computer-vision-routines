function [ X1,X2,X3 ] = extract3dPointsFromDisparityPairs( x_vec,y_vec,pml1,x_dash_vec,y_dash_vec,pmr1 )
%EXTRACT3DPOINTSFROMDISPARITYPAIRS triangulates the input pairs utilizing
%the projection matrices
%   X1,X2,X3 are the 3d back-projected points

p1T = pml1(1,:);
p2T = pml1(2,:);
p3T = pml1(3,:);

pdash_1T = pmr1(1,:);
pdash_2T = pmr1(2,:);
pdash_3T = pmr1(3,:);

num_silhouette_elements = size(x_vec,1);
points = ones(4,1,num_silhouette_elements);
X1 = ones(1,num_silhouette_elements);
X2 = ones(1,num_silhouette_elements);
X3 = ones(1,num_silhouette_elements);
for i=1:num_silhouette_elements
   % if mod(i,1000) == 0
   %     sprintf( 'iter num %d',i )
   % end
    x = x_vec(i);
    y = y_vec(i);
    x_dash = x_dash_vec(i);
    y_dash = y_dash_vec(i); 

    A = [ x * p3T - p1T ;
        y * p3T - p2T ;
        x_dash * pdash_3T - pdash_1T ;
        y_dash * pdash_3T - pdash_2T ];
    
    A(1,:) = A(1,:)/norm(A(1,:));
    A(2,:) = A(2,:)/norm(A(2,:));
    A(3,:) = A(3,:)/norm(A(3,:));
    A(4,:) = A(4,:)/norm(A(4,:));
  
    % X is the last column of V, where A = UDV' is the SVD of A.
    [U D V] = svd( A );
    X = V(:,4);
    X = X / X(4); % normalize
    X1(i) = X(1);
    X2(i) = X(2);
    X3(i) = X(3);
    points(:,:,i) = X;
end

end

