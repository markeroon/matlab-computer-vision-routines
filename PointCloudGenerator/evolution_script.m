addpath( '~/Code/LevelSetsMethods3D/' );

x_lo = min(X1);
x_hi = max(X1);
y_lo = min(X2);
y_hi = max(X2);
z_lo = min(X3);
z_hi = max(X3);
dx = (x_hi-x_lo)/Nx;
dy = (y_hi-y_lo)/Ny;
dz = (z_hi-z_lo)/Nz;
X = x_lo-dx*8:dx:x_hi+dx*8;
Y = y_lo-dy*8:dy:y_hi+dy*8;
Z = z_lo-dz*8:dz:z_hi+dz*8;
[x,y,z] = meshgrid(X,Y,Z);
[phi] = getPhi( x,y,z );

alpha = 0.3;
iterations = 10;
accuracy = 'ENO3';
is_signed_distance = 1;
normal_evolve = 0;
Vn = [];
vector_evolve = 1;
u = d_x;
v = d_y;
w = d_z;
kappa_evolve = 1;
b = dist;
for i=1:4
    phi2 = evolve3D(phi, dx, dy, dz, alpha, iterations, accuracy, is_signed_distance, normal_evolve, Vn, vector_evolve, u, v, w, kappa_evolve, b);
    if( mod(i,10) == 0 )
       phi2 = reinit_SD(phi2,dx,dy,dz,alpha,accuracy,20); 
    end
end