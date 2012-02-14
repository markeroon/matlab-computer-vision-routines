function [x_corrupt,y_corrupt,z_corrupt] = addNoisyPoints( X,Y,Z,N,dx,dy,dz,border_width )
% can add noise on interval [a,b] using the following
% r = a + (b-a).*rand(100,1);

X_a = min( X ) - border_width*dx;
X_b = max( X ) + border_width*dx;
Y_a = min( Y ) - border_width*dy;
Y_b = max( Y ) + border_width*dy;
Z_a = min( Z ) - border_width*dz;
Z_b = max( Z ) + border_width*dz;

%x_min = x_min - 10*dx; 
%x_max = x_max + 10*dx;
%y_min = y_min - 10*dy; 
%y_max = y_max + 10*dy;
%z_min = z_min - 10*dz; 
%z_max = z_max + 10*dz;
%[x,y,z] = meshgrid( x_min:dx:x_max,y_min:dy:y_max,z_min:dz:z_max );

X_r = X_a + (X_b-X_a).*rand(N,1);
Y_r = Y_a + (Y_b-Y_a).*rand(N,1);
Z_r = Z_a + (Z_b-Z_a).*rand(N,1);

x_corrupt = [X X_r'];
y_corrupt = [Y Y_r'];
z_corrupt = [Z Z_r'];
end