function [x_corrupt,y_corrupt] = addNoisyPoints2D( X,Y,N,dx,dy )
% can add noise on interval [a,b] using the following
% r = a + (b-a).*rand(100,1);

X_a = min( X ) - 20*dx;
X_b = max( X ) + 20*dx;
Y_a = min( Y ) - 20*dy;
Y_b = max( Y ) + 20*dy;


X_r = X_a + (X_b-X_a).*rand(N,1);
Y_r = Y_a + (Y_b-Y_a).*rand(N,1);

x_corrupt = [X X_r'];
y_corrupt = [Y Y_r'];
end