addpath( '../third_party/gmmreg-read-only/' );
addpath( '../file_management/' );
addpath( genpath( '../third_party/CPD2' ) );
addpath( '../plant_registration' );
addpath( '../PointCloudGenerator/' );

filename_0 = sprintf( '~/Data/PlantDataPly/plants_converted82-%03d-clean_cut.ply', 3 );
[Elements_0,varargout_0] = plyread(filename_0);
X = [Elements_0.vertex.x';Elements_0.vertex.y';Elements_0.vertex.z']';
    
filename_1 = sprintf( '~/Data/PlantDataPly/plants_converted82-%03d-clean_cut.ply', 4 );
[Elements_1,varargout_1] = plyread(filename_1);
Y = [Elements_1.vertex.x';Elements_1.vertex.y';Elements_1.vertex.z']';

iters_rigid = 1;
iters_nonrigid = 0;
Yr_subdiv = ones(size(Y));
%{
[Yr_subdiv(:,1),Yr_subdiv(:,2),Yr_subdiv(:,3),corr_r] = register_surface_subdivision_upper_bound( ...
                                           X,Y,iters_rigid,iters_nonrigid );
 %}

X = X(1:40:end,:);
Y = Y(1:40:end,:);

lambda = 10;
beta = 10;
Y_ = ones(size(Y));
iters_rigid = 30;
iters_nonrigid  = 30;
[Y_(:,1),Y_(:,2),Y_(:,3)] = registerToReferenceRangeScan(X, Y, iters_rigid, ...                                                iters_rigid,...
                                                    iters_nonrigid,...
                                                    lambda,...
                                                    beta,...
                                                    2);
[neighbour_id,neighbour_dist] = kNearestNeighbors(X, Y_, 1 );
% get nearest neighbour for each point in the original cloud in the
% matched cloud



X_reg = ones(size(X(neighbour_id,:)));
[X_reg(:,1),X_reg(:,2),X_reg(:,3)] = registerToReferenceRangeScan( ...
                                            Y,X(neighbour_id,:),...
                                          iters_rigid,iters_nonrigid,...
                                          lambda,beta,2 );
                                       
[neighbour_id_reg,neighbour_dist_reg] = kNearestNeighbors(X_reg,X,1 );
sprintf('RMS-E: ' )
rms_e = sqrt( sum(neighbour_dist_reg(:))/ length(neighbour_dist_reg(:)) )                      
