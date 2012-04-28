sprintf( 'getting distance function from points...' )
[d,d_x,d_y,d_z] = distance_vol( X1_vec,X2_vec,X3_vec,x,y,z,dX);
sprintf( 'done' )

phi_old2 = cell(200,1);
phi_old3 = cell(100,1);
alpha = 0.3;
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
phi2 = phi;
phi2 = reinit_SD(phi2,dx, dy, dz, alpha,accuracy, 100);
reinit_iterations = 10;


for i=1:50
    phi2 = evolve3D(phi2, dx, dy, dz, alpha, iterations, accuracy, is_signed_distance, normal_evolve, Vn, vector_evolve, u, v, w, kappa_evolve, b);
    if mod(i,5) == 0
        phi_old2{int32(i/5)} = phi2;
        phi2 = reinit_SD(phi2,dx, dy, dz, alpha,accuracy, reinit_iterations);        
    end
end
kappa_evolve = 1;
phi3 = phi2;
for i=1:100
    phi3 = evolve3D(phi3, dx, dy, dz, alpha, iterations, accuracy, is_signed_distance, normal_evolve, Vn, vector_evolve, u, v, w, kappa_evolve, b);
    phi3 = reinit_SD(phi3,dx, dy, dz, alpha,accuracy, reinit_iterations);
    
    phi_old3{i} = phi3;
end