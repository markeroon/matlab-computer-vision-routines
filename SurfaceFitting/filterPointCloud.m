%function [roc_x_var,roc_y_var,roc_x_fixed,roc_y_fixed] = filterPointCloud( dataset, hundred_percent_noise )
addpath('~/Code/filtering/' );
addpath('~/Code/third_party/kdtree/' );
addpath('~/Code/filtering/mahalanobis/' );
addpath('~/Code/file_management/' );
addpath('~/Code/PointCloudGenerator/' );

dataset = 'BUDDHA';
hundred_percent_noise = 5;
border_width = 10000;

if strcmp( dataset, 'BUNNY' )
    fid = fopen( '~/Data/bunny/reconstruction/bun_zipper_stripped.ply', 'r' );
    A = fscanf( fid, '%f %f %f %f %f\n', [5 inf] );
    X = A(1,:);
    Y = A(2,:);
    Z = A(3,:);
    radius = 0.0001;
    %h = 0.001;
    %h_fixed = 1;
    %k = 50;
elseif strcmp( dataset, 'BUDDHA' )
    [tri,pts] = plyread( '~/Data/happy_recon/happy_vrip_res2.ply','tri' );
    X = pts(:,1)';
    Y = pts(:,2)';
    Z = pts(:,3)';
    radius = 0.000001; %0.00001;
    %n = 5;
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
    %n = 3;
    h_fixed = 1;
    h = 20;
end

N = size( X,2 );

x_min = min( X );
x_max = max( X );
y_min = min( Y );
y_max = max( Y );
z_min = min( Z );
z_max = max( Z );

dx = (x_max - x_min) / N;
dy = (y_max - y_min) / N;
dz = (z_max - z_min) / N;

%[X_noisy,Y_noisy,Z_noisy] = addNoise( X,Y,Z,freq,0.004 );
[X_noisy,Y_noisy,Z_noisy] = addNoisyPoints( X,Y,Z,...
                            size(X,2)*hundred_percent_noise,...
                            dx,dy,dz,border_width );

idx = find( Y_noisy > 0.15 & Y_noisy < 0.19 & X_noisy > -0.02 & X_noisy < -0.01  );                        
                        
X_vec = [ X_noisy' , Y_noisy', Z_noisy' ];

X_vec_subset = [ X_noisy(idx)' , Y_noisy(idx)', Z_noisy(idx)' ];
tree_kd = kdtree_build( X_vec );
%idxs = kdtree_k_nearest_neighbors( tree, X_vec_subset(20,:), 50 );


n=2;
k=120;
%{
tic
[f_vb,f_fb,f_vm_d,f_vm_nd,f_reach] = ...
    kernel_density_est_mahal_fast( X_vec_subset,radius,n );
toc
%}
%{
k=50;
tic
for i=1:size(X_vec,1) %ADJUST AFTER
    [f_var_band(i),f_fixed_band(i),f_var_mah_denom(i),f_reach(i)] = ...
    kernel_density_estimate_mex( tree,X_vec,i,k,n );  
   if mod(i,50) == 0
       sprintf( '%f completed', i/size(X_vec,1)*100 )
   end
end
toc
kdtree_delete(tree);
%}
f_fixed_band = ones(size(X_vec,1),1);
f_var_band = ones(size(X_vec,1),1);
f_var_mah_denom = ones(size(X_vec,1),1);
f_reach = ones(size(X_vec,1),1);
tic
for i=1:size(X_vec,1)
   [f_var_band(i),f_fixed_band(i),f_var_mah_denom(i),f_reach(i)] = kernel_density_estimate_mahal_knearest_mex( tree_kd,X_vec,i,k,n );
        %kernel_density_estimate_mahal( X_vec,i,radius,n );
   if mod(i,50) == 0
       sprintf( '%f completed', i/size(X_vec,1)*100 )
   end
end
toc

%set(gcf, 'renderer', 'zbuffer')
%{
plot3( X_noisy,Y_noisy,Z_noisy,'or','markersize',.12)


if strcmp( dataset, 'BUDDHA' )
    [A1] = exportOffFile( X,Y,Z, '~/Data/buddha_prior_to_noise_addition.off'  );
    idx = find( f_radius >= 0.11 );
    [A2] = exportOffFile( X_noisy(idx),Y_noisy(idx),Z_noisy(idx), '~/Data/buddha_filt.off'  );
end
%}

% now check detection algorithm
detection_reference = zeros(size(f_var_band));
detection_reference(size(X,2)+1:end) = 1;
%detection_reference(1:freq:end) = 1;

[roc_x_var,roc_y_var] = getRocCurves( f_var_band,detection_reference );
[roc_x_fixed,roc_y_fixed] = getRocCurves( f_fixed_band,detection_reference );
plot(roc_y_fixed,roc_x_fixed,'--b','linewidth',3)
hold on
plot(roc_y_var,roc_x_var,'--r','linewidth',3)

%{
thresh_max = max( f_var_band_norm .* detection_reference );

roc_x = [];
roc_y = [];
true_positive_detect = 1;
while true_positive_detect > 0
    detection_result = f_var_band_norm < thresh_max;
    thresh_max = thresh_max - 0.001;
    
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

end

function[X,Y,Z] = normalizeByRadius( X,Y,Z,radius )
    norm_val = ones(size(X));
    norm_val = sqrt( X.^2 + Y.^2 + Z.^2 );
    norm_val_max = max( abs(norm_val) );
    X = X / norm_val_max;
    Y = Y / norm_val_max;
    Z = Z / norm_val_max;
end
%}