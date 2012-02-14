syms x y a b r theta
x_dash = ((x - a)*cos(theta) + (y-b)*sin(theta) ) / r
diff( x_dash, x );

y_dash = ( -(x - a)*sin(theta) + (y-b)*cos(theta) ) / r;
diff( y_dash, x );

diff( x_dash, theta )
diff( y_dash, theta )

