addpath( '../third_party/gmmreg-read-only/' );
addpath( '../file_management/' );
addpath( genpath( '../third_party/CoherentPointDrift' ) );
addpath( '../plant_registration' );
addpath( '../PointCloudGenerator/' );
addpath( '../third_party/LSMLIB' );
dX = [ 1 1 1 ];
filename_0 = sprintf( '~/Data/PlantDataPly/plants_converted82-%03d-clean.ply', 0 );
[Elements_0,varargout_0] = plyread(filename_0);
X = [Elements_0.vertex.x';Elements_0.vertex.y';Elements_0.vertex.z']';
[x,y,z] = meshgrid( min(X(:,1))+200:min(X(:,1))+200+35,min(X(:,2))+200:min(X(:,2))+200+35,min(X(:,3))+200:min(X(:,3))+200+35);

dist = distance_vol( X(:,1)',X(:,2)',X(:,3)',x,y,z,dX );
phi = -1*ones(size(dist));
phi(7:end-7,7:end-7,7:end-7) = 1;
phi = computeDistanceFunction3d( phi,dX );

