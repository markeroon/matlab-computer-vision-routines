addpath( '~/Code/third_party/AOSLevelSetSegmentationToolbox/' );
addpath( '~/Code/third_party/LSMLIB/' );
addpath( '~/Code/PointCloudGenerator/' );
addpath( '~/Code/LevelSetsMethods3D/' );
addpath( '~/Code/filtering/' );
clear
fid = fopen( '~/Data/bunny/reconstruction/bun_zipper_stripped.ply', 'r' );

A = fscanf( fid, '%f %f %f %f %f\n', [5 inf] );
X = A(1,:);
Y = A(2,:);
Z = A(3,:);

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

x_min = x_min - 10*dx; 
x_max = x_max + 10*dx;
y_min = y_min - 10*dy; 
y_max = y_max + 10*dy;
z_min = z_min - 10*dz; 
z_max = z_max + 10*dz;
[x,y,z] = meshgrid( x_min:dx:x_max,y_min:dy:y_max,z_min:dz:z_max );

freq = 5;
[X_noisy,Y_noisy,Z_noisy] = addNoise( X,Y,Z,freq,0.004 );

X_vec = [ X_noisy' , Y_noisy', Z_noisy' ];
q_x = ones(size(X_noisy));
k = 11;
h = 0.9;
for i=1:size(X_vec,1)
%for i=200:250
   [q_x(i),id,dist] = kernel_density_estimate( X_vec,i,k,h );
   if mod(i,50) == 0
       sprintf( '%f completed', i/size(X_vec,1)*100 )
   end
end

% now check detection algorithm
detection_reference = ones(size(q_x));
detection_reference(1:freq:end) = 0;

thresh_max = max( q_x .* ~detection_reference );
%while  

detection_result = q_x > 1.0e+06;

correct_detect =    sum( detection_reference == 0 & detection_result == 0 );
incorrect_detect =  sum( detection_reference == 1 & detection_result == 0 );

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