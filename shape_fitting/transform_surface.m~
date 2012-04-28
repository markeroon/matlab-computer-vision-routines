function [phi_trans] = transform_surface( phi,alpha,beta,gamma,a,b,c,r,X,Y,Z )

phi_trans = ones(size(phi));
x_min = min(X(:));
x_max = max(X(:));
y_min = min(Y(:));
y_max = max(Y(:));
z_min = min(Z(:));
z_max = max(Z(:));

%idx = find( phi > -30 & phi < 30 );

for i=1:size(phi,1)
for j=1:size(phi,2)
for k=1:size(phi,3)
%for i=1:size(idx,1)
    x = X(i,j,k);
    y = Y(i,j,k);
    z = Z(i,j,k);
    %x = X(idx(i));
    %y = Y(idx(i));
    %z = Z(idx(i));
    
    
    R_alpha = ...
    [ 1, 0, 0 ;
    0 ,cos(alpha) ,sin(alpha); 
    0 ,-sin(alpha), cos(alpha) ];

    R_beta = ... 
    [ cos(beta), 0, -sin(beta);
      0, 1,          0;
      sin(beta), 0,  cos(beta)];
  
    R_gamma = ...
    [ cos(gamma), sin(gamma), 0 ;
      -sin(gamma), cos(gamma), 0;
      0 ,  0  , 1];
        
    R_alphabetagamma = R_alpha * R_beta * R_gamma;

    x_y_z_dash = ( R_alphabetagamma * [ x - a; y - b; z - c] ) / r;

    x_dash = (x_y_z_dash(1));
    y_dash = (x_y_z_dash(2));
    z_dash = (x_y_z_dash(3));
    
    if x_dash >= x_min && x_dash <= x_max && y_dash >= y_min ...
        && y_dash <= y_max && z_dash >= z_min && z_dash <= z_max
            %phi_trans(i,j,k) = r*phi(idx);
            phi_trans(i,j,k) = interp3(X,Y,Z,phi,x_dash,y_dash,z_dash);
            %if isnan( phi_trans(idx(i))), error( 'interp3 returns NAN' ); end
            if isnan( phi_trans(i,j,k) ), error( 'interp3 returns NAN' ); end
    end
    
    
end
end
end
    
end