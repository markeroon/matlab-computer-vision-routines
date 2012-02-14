addpath( '../file_management' );
addpath( genpath( 'third_party/coherent_point_drift/' ) ); % add subdirs
%addpath( 'third_party/finite_icp/' );
%addpath( '~/Code/filtering/mahalanobis/' );
%addpath( '~/Code/PointCloudGenerator' );

X2 = cell(6,1);
Y2 = cell(6,1);
Z2 = cell(6,1);
j=1;
for i=1:2:11
    %{
    filename_0 = sprintf( '../../Data/PlantDataOFF/plants_converted%03d_clean.off', i );
    [X0,Y0,Z0] = importOffFile( filename_0 );
    X_rest = [X0,Y0,Z0 ];
    
    filename_1 = sprintf( '../../Data/PlantDataOFF/plants_converted%03d_clean.off', i+1 );
    [X1,Y1,Z1] = importOffFile( filename_1 );
    Y_rest = [X1,Y1,Z1];
    %}
    
    filename_0 = sprintf( '../../Data/PlantDataPly/plants_converted82-%03d-clean.ply', i-1 );
    [Elements_0,varargout_0] = plyread(filename_0);
    X_rest = [Elements_0.vertex.x';Elements_0.vertex.y';Elements_0.vertex.z']';
    
    filename_1 = sprintf( '../../Data/PlantDataPly/plants_converted82-%03d-clean.ply', i );
    [Elements_1,varargout_1] = plyread(filename_1);
    Y_rest = [Elements_1.vertex.x';Elements_1.vertex.y';Elements_1.vertex.z']';

    
    R =  [ 0.9101   -0.4080    0.0724 ;
            0.4118    0.8710   -0.2681 ;
              0.0463    0.2738    0.9607 ]
    t = [ 63.3043,  234.5963, -46.8392 ];
    
    % transform once for each scan that we've registered
    Y_dash = R*Y_rest' + repmat(t,size(Y_rest,1),1)';
    Y_rest = Y_dash';
    
    iters_rigid = 1;%35;
    iters_nonrigid = 0;%35;
    [X_new,Y_new,Z_new] = register_surface_subdivision_upper_bound( ...
                                                X_rest,Y_rest,iters_rigid,iters_nonrigid );

    X2{j} = [ X0 X_new' ];
    Y2{j} = [ Y0 Y_new' ];
    Z2{j} = [ Z0 Z_new' ];        
    j=j+1;
end
X3 = cell(4,1);
Y3 = cell(4,1);
Z3 = cell(4,1);
j=1;
for i=1:2:6
   X = [X2{i}',Y2{i}',Z2{i}'];
   Y = [X2{i+1}',Y2{i+1}',Z2{i+1}'];
   for z=1:2
       Y_dash = R*Y' + repmat(t,size(Y,1),1)';
       Y = Y_dash';
   end
   [X_new,Y_new,Z_new] = register_surface_subdivision_upper_bound( ...
                                           X,Y,iters_rigid,iters_nonrigid );
   X3{j} = [X2{i} X_new'];
   Y3{j} = [Y2{i} Y_new'];
   Z3{j} = [Z2{i} Z_new'];
   j=j+1;
end

X4 = cell(1,1);
Y4 = cell(1,1);
Z4 = cell(1,1);
X = [X3{1}',Y3{1}',Z3{1}'];
Y = [X3{2}',Y3{2}',Z3{2}'];
for z=1:4
    Y_dash = R*Y' + repmat(t,size(Y,1),1)';
    Y = Y_dash';
end
[X_new,Y_new,Z_new] = register_surface_subdivision_upper_bound( ...
                                           X,Y,iters_rigid,iters_nonrigid );
X4{j} = [X3{i} X_new'];
Y4{j} = [Y3{i} Y_new'];
Z4{j} = [Z3{i} Z_new'];

X = [X4{1}',Y4{1}',Z4{1}'];
Y = [X3{3}',Y3{3}',Z3{3}'];
for z=1:6
   Y_dash = R*Y' + repmat(t,size(Y,1),1)';
   Y = Y_dash';
end
[X_new,Y_new,Z_new] = register_surface_subdivision_upper_bound( ...
                                           X,Y,iters_rigid,iters_nonrigid );
X5 = [X4{1} X_new'];
Y5 = [Y4{1} Y_new'];
Z5 = [Z4{1} Z_new'];

%exportOffFile(X5,Y5,Z5,'~/Data/plants_12.off' );