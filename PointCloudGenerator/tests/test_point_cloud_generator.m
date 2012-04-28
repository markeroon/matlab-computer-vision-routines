r_x = a + (b-a).*rand(25,1);
r_y = a + (b-a).*rand(25,1);
r_z = a + (b-a).*rand(25,1);

X_s = ones(3,size(r_x,1));
X_s(1,:) = r_x(:);
X_s(2,:) = r_y(:);
X_s(3,:) = r_z(:);


[x,y,z] = meshgrid( min(r_x):max(r_x),min(r_y):max(r_y),min(r_z):max(r_z) );
X = ones(3,size(x(:),1));
X(1,:) = x(:);
X(2,:) = y(:);
X(3,:) = z(:);

[D,d] = compute_distance_to_points(X,X_s);
