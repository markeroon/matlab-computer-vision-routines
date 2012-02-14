function [ X1,X2,X3 ] = get3dPoints( x_vec,y_vec,P1,x_dash_vec,y_dash_vec,P2 )
% efreedom code here -- Hartley's method
num_silhouette_elements = size(x_vec,1);
X1 = ones(1,num_silhouette_elements);
X2 = ones(1,num_silhouette_elements);
X3 = ones(1,num_silhouette_elements);
for i=1:num_silhouette_elements
    
    xhat1 = [x_vec(i) y_vec(i) ];
    xhat2 = [x_dash_vec(i) y_dash_vec(i) ];
    A = [xhat1(1) * P1(3,:) - P1(1,:) ;
     xhat1(2) * P1(3,:) - P1(2,:) ;
     xhat2(1) * P2(3,:) - P2(1,:) ;
     xhat2(2) * P2(3,:) - P2(2,:) ];

    A(1,:) = A(1,:)/norm(A(1,:));
    A(2,:) = A(2,:)/norm(A(2,:));
    A(3,:) = A(3,:)/norm(A(3,:));
    A(4,:) = A(4,:)/norm(A(4,:));

    [Ua Ea Va] = svd(A);
    X = Va(:,end);
    X = X / X(4);   % 3D Point

    X1(i) = X(1);
    X2(i) = X(2);
    X3(i) = X(3);
end

end