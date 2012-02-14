
N = 100;

x_min = min( X );
x_max = max( X );
y_min = min( Y );
y_max = max( Y );
z_min = min( Z );
z_max = max( Z );

dx = (x_max - x_min) / N;
dy = (y_max - y_min) / N;
dz = (z_max - z_min) / N;


phi = cube_SDF( size(x),6,[dx dy dz]  );

sprintf( 'getting distance function from points...' )
[d,d_x,d_y,d_z] = distance_vol( X,Y,Z,x,y,z,[dx dy dz]);
sprintf( 'done' )

reinit_iterations = 25;
alpha = 0.4;
iterations = 1;
accuracy = 'ENO3';
is_signed_distance = 1;
kappa_evolve = 0;               % NOTE THAT KAPPA_EVOLVE IS TURNED OFF!!!!!
b = d;
vector_evolve = 1;
u = d_x;
v = d_y;
w = d_z;
normal_evolve = 0;
Vn = [];
phi_old = cell(400,1);
phi2 = phi;

for i=1:8000
    phi2 = evolve3D(phi2, dx, dy, dz, alpha, iterations, accuracy, is_signed_distance, normal_evolve, Vn, vector_evolve, u, v, w, kappa_evolve, b);
    phi2 = reinit_SD(phi2,dx, dy, dz, alpha,accuracy, reinit_iterations); 
    if mod(i,20) == 0
        phi_old{int32(i/20)} = phi2;               
    end
end