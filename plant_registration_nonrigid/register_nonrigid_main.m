addpath( '../third_party/gmmreg-read-only/' );
addpath( '../file_management/' );
addpath( genpath( '../third_party/CoherentPointDrift' ) );
addpath( '../plant_registration' );
addpath( '../PointCloudGenerator/' );

filename_0 = sprintf( '~/Data/PlantDataPly/plants_converted82-%03d-clean_cut.ply', 3 );
[Elements_0,varargout_0] = plyread(filename_0);
X = [Elements_0.vertex.x';Elements_0.vertex.y';Elements_0.vertex.z']';
    
filename_1 = sprintf( '~/Data/PlantDataPly/plants_converted82-%03d-clean_cut.ply', 4 );
[Elements_1,varargout_1] = plyread(filename_1);
Y = [Elements_1.vertex.x';Elements_1.vertex.y';Elements_1.vertex.z']';

X = X(1:40:end,:);
Y = Y(1:40:end,:);

iters_rigid = 50;
iters_nonrigid = 0;
lambda = 1;
beta = .1;
Yr_subdiv = ones(size(Y));

[Yr_subdiv(:,1),Yr_subdiv(:,2),Yr_subdiv(:,3)] = register_surface_subdivision_upper_bound( ...
                                           X,Y,iters_rigid,iters_nonrigid,lambda,beta );
                                       
[neighbour_id,neighbour_dist] = kNearestNeighbors(X, Yr_subdiv, 1 );
% get nearest neighbour for each point in the original cloud in the
% matched cloud


neighbour_id_unique = unique(neighbour_id);

X_reg = ones(size(X(neighbour_id_unique,:)));
[X_reg(:,1),X_reg(:,2),X_reg(:,3)] = register_surface_subdivision_upper_bound( ...
                                          Y,X(neighbour_id_unique,:),iters_rigid,iters_nonrigid,lambda, beta );
                                       
[neighbour_id_reg,neighbour_dist_reg] = ...
                    kNearestNeighbors(X_reg, X, 1 );
sprintf('RMS-E: ' )
rms_e = sqrt( sum(neighbour_dist_reg(:)) / length(neighbour_dist_reg(:)) )