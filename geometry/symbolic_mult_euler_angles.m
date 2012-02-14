syms alpha beta gamma x y z a b c r
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

d_x_dash_dalpha = diff( x_y_z_dash, alpha )

%d_x_dash_dalpha = diff( x_y_z_dash, b )

%d_x_dash_dalpha = diff( x_y_z_dash, c )