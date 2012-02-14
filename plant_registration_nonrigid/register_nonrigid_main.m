addpath( '../third_party/gmmreg-read-only/' );
addpath( '../file_management/' );
addpath( genpath( '../third_party/CoherentPointDrift' ) );
addpath( '../plant_registration' );

filename_0 = sprintf( '~/Data/PlantDataPly/plants_converted82-%03d-clean.ply', 0 );
[Elements_0,varargout_0] = plyread(filename_0);
X = [Elements_0.vertex.x';Elements_0.vertex.y';Elements_0.vertex.z']';
    
filename_1 = sprintf( '~/Data/PlantDataPly/plants_converted82-%03d-clean.ply', 1 );
[Elements_1,varargout_1] = plyread(filename_1);
Y = [Elements_1.vertex.x';Elements_1.vertex.y';Elements_1.vertex.z']';

iters_rigid = 3;
iters_nonrigid = 0;
[X_new,Y_new,Z_new] = register_surface_subdivision_upper_bound( ...
                                           X,Y,iters_rigid,iters_nonrigid );

%{
[Y1_,Y2_,Y3_] = registerToReferenceRangeScan(X, Y, 100, ...                                                iters_rigid,...
                                                       0,...
                                                       1,...
                                                       1,...
                                                       1);
%}
                                                   
