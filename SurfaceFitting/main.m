addpath( '~/Code/third_party/AOSLevelSetSegmentationToolbox/' );
addpath( '~/Code/third_party/LSMLIB/' );
addpath( '~/Code/PointCloudGenerator/' );
addpath( '~/Code/LevelSetsMethods3D/' );
addpath( '~/Code/filtering/' );
addpath( '~/Code/file_management/' );
addpath( '~/Code/filtering/mahalanobis/' );
clear

dataset = 'BUDDHA';

if strcmp( dataset, 'BUNNY' )
    fid = fopen( '~/Data/bunny/reconstruction/bun_zipper_stripped.ply', 'r' );
    A = fscanf( fid, '%f %f %f %f %f\n', [5 inf] );
    X = A(1,:);
    Y = A(2,:);
    Z = A(3,:);
    radius = 0.00006;%0.00003;
    h = 0.001;%200;
    h_fixed = 1;
    k = 50;
    n = 5;%10;
elseif strcmp( dataset, 'BUDDHA' )
    [tri,pts] = plyread( '/home/mark/Data/happy_recon/happy_vrip_res2.ply','tri' );
    X = pts(:,1)';
    Y = pts(:,2)';
    Z = pts(:,3)';
    radius = 0.00001;
    n = 10;
    h = 1;
    h_fixed = 1;
elseif strcmp( dataset, 'DRILL' )
    fid = fopen( '~/Data/drill/reconstruction/drill_shaft_vrip_stripped.ply', 'r' );
    A = fscanf( fid, '%f %f %f %f\n', [4 inf] );
    X = A(1,:);
    Y = A(2,:);
    Z = A(3,:);
    radius = 0.01;
elseif strcmp( dataset, 'TORUS' )
    [tri,pts] = plyread( '~/Data/torus.ply','tri' );
    X = pts(:,1)';
    Y = pts(:,2)';
    Z = pts(:,3)';
    radius = 0.05;
    n = 3;
    h_fixed = 1;
    h = 20;
end

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

freq = 5;
%[X_noisy,Y_noisy,Z_noisy] = addNoise( X,Y,Z,freq,0.004 );
[X_noisy,Y_noisy,Z_noisy] = addNoisyPoints( X,Y,Z,size(X,2)*5,dx,dy,dz );

X_vec = [ X_noisy' , Y_noisy', Z_noisy' ];
q_x = ones(size(X_noisy));
f = ones(size(X_noisy));
f_fixed_h = ones(size(X_noisy));
f_no_denom = ones(size(X_noisy));

for i=1:size(X_vec,1)
%for i=[1:100,size(X_vec,1)-100:size(X_vec,1)]
   %[f(i),f_fixed(i)] = kernel_density( X_vec,i,radius,h,n );
   [f(i),f_fixed_h(i),f_no_denom(i)] = kernel_density_estimate_within_radius( X_vec,i,radius,n,h,h_fixed );
   if mod(i,50) == 0
       sprintf( '%f completed', i/size(X_vec,1)*100 )
   end
end

%leset(gcf, 'renderer', 'zbuffer')
plot3( X_noisy,Y_noisy,Z_noisy,'or','markersize',.12)


if strcmp( dataset, 'BUDDHA' )
    [A1] = exportOffFile( X,Y,Z, '~/Data/buddha_prior_to_noise_addition.off'  );
    idx = find( f_radius >= 0.11 );
    [A2] = exportOffFile( X_noisy(idx),Y_noisy(idx),Z_noisy(idx), '~/Data/buddha_filt.off'  );
end

% now check detection algorithm
detection_reference = zeros(size(f));
detection_reference(size(X,2)+1:end) = 1;
%detection_reference(1:freq:end) = 1;

thresh_max = max( f_fixed_h_radius .* detection_reference );

roc_x = [];
roc_y = [];
true_positive_detect = 1;
while true_positive_detect > 0
    detection_result = f_fixed_h_radius < thresh_max;
    thresh_max = thresh_max - 0.0005;
    
    actual_normal_class = ~detection_reference;
    actual_outlier_class = detection_reference;
    
    
    
    true_positive_detect =  sum( detection_reference == 1 & detection_result == 1 );
    false_negative_detect = sum( detection_reference == 1 & detection_result == 0 );   
    
    false_positive_detect =  sum( detection_reference == 0 & detection_result == 1 );
    true_negative_detect  =  sum( detection_reference == 0 & detection_result == 0 );
    
    detect_rate = true_positive_detect / (true_positive_detect + false_negative_detect );
    false_alarm_rate = false_positive_detect / ( false_positive_detect + true_negative_detect );
    roc_x = [roc_x detect_rate];
    roc_y = [roc_y false_alarm_rate];
end

A = [roc_y' , roc_x' ];
filename = sprintf( 'roc_curves_k_%d.txt', k );
f_out = fopen( filename, 'w' );
fprintf( f_out, '%d %d\n', A' );
fclose( f_out );


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