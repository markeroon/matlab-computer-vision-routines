addpath( '../third_party/gmmreg-read-only/' );
addpath( '../file_management/' );
addpath( genpath( '../third_party/CoherentPointDrift' ) );
addpath( '../plant_registration' );

filename_0 = sprintf( '~/Data/PlantDataPly/plants_converted82-%03d-clean_cut.ply', 3 );
[Elements_0,varargout_0] = plyread(filename_0);
X = [Elements_0.vertex.x';Elements_0.vertex.y';Elements_0.vertex.z']';
    
filename_1 = sprintf( '~/Data/PlantDataPly/plants_converted82-%03d-clean_cut.ply', 4 );
[Elements_1,varargout_1] = plyread(filename_1);
Y = [Elements_1.vertex.x';Elements_1.vertex.y';Elements_1.vertex.z']';

iters_rigid = 1;
iters_nonrigid = 0;
Yr_subdiv = ones(size(Y));

[Yr_subdiv(:,1),Yr_subdiv(:,2),Yr_subdiv(:,3),corr_r] = register_surface_subdivision_upper_bound( ...
                                           X,Y,iters_rigid,iters_nonrigid );
                                       
[neighbour_id,neighbour_dist] = kNearestNeighbors(X, Y, 1 );
% get nearest neighbour for each point in the original cloud in the
% matched cloud



Y_reg = ones(size(X(neighbour_id,:)));
[Y_reg(:,1),Y_reg(:,2),Y_reg(:,3)] = register_surface_subdivision_upper_bound( ...
                                          Y,X(neighbour_id,:),iters_rigid,iters_nonrigid );
                                       
[neighbour_id_reg,neighbour_dist_reg] = kNearestNeighbors(Y_reg, X{20}, 1 );
sprintf('RMS-E: ' )
rms_e = sqrt( sum(neighbour_dist_reg(:))/ length(neighbour_dist_reg(:)) )                      

                                       
%{
lambda = 3;
beta = 0.1;
[Y1_,Y2_,Y3_] = registerToReferenceRangeScan(X, Y, 0, ...                                                iters_rigid,...
                                                    5,...
                                                    lambda,...
                                                    beta,...
                                                    2);
                                                   
%}