addpath( '../file_management' );
addpath( genpath( 'third_party/coherent_point_drift/' ) ); % add subdirs
%addpath( 'third_party/finite_icp/' );
%addpath( '~/Code/filtering/mahalanobis/' );
%addpath( '~/Code/PointCloudGenerator' );


    
R =  [ 0.9101   -0.4080    0.0724 ;
       0.4118    0.8710   -0.2681 ;
       0.0463    0.2738    0.9607 ];
t = [ 63.3043,  234.5963, -46.8392 ];

X2 = cell(11,1);
Y2 = cell(11,1);
Z2 = cell(11,1);

filename_0 = sprintf( '../../Data/PlantDataOFF/plants_converted%03d_clean.off', 0 );
[X0,Y0,Z0] = importOffFile( filename_0 );
X = [X0,Y0,Z0 ];
for i=1:11
    
    
    filename_1 = sprintf( '../../Data/PlantDataOFF/plants_converted%03d_clean.off', i );
    [X1,Y1,Z1] = importOffFile( filename_1 );
    Y = [X1,Y1,Z1];
    
    % transform once for each scan that we've registered
    for j=1:i
        Y_dash = R*Y' + repmat(t,size(Y,1),1)';
        Y = Y_dash';
    end
    iters_rigid = 30; % these two vars have no effect
    iters_nonrigid = 0;
    [X_new,Y_new,Z_new] = register_surface_subdivision_upper_bound( ...
                                                X,Y,iters_rigid,iters_nonrigid );

    X2{i} = X_new';%[ X0 X_new' ];
    Y2{i} = Y_new';%[ Y0 Y_new' ];
    Z2{i} = Z_new';%[ Z0 Z_new' ];
end

X3 = [X0 X2{1:11}];
Y3 = [Y0 Y2{1:11}];
Z3 = [Z0 Z2{1:11}];
X_vec = [X3,Y3,Z3];