addpath( '../file_management/' );
addpath( '../plant_registration' );
addpath( '../PointCloudGenerator/' );
addpath( '/opt/lsmlib-matlab/LSMLIB' );
%addpath( '../LevelSetsMethods3D' );
addpath( '../third_party/AOSLevelSetSegmentationToolbox/' );
%filename_0 = sprintf( '~/Data/PlantDataPly/plants_converted82-%03d-clean.ply', 0 );
filename_0 = '~/Data/branch_test.ply';
[Elements_0,varargout_0] = plyread(filename_0);
X = [Elements_0.vertex.x';Elements_0.vertex.y';Elements_0.vertex.z']';

N = 50;
x_min = min( X(:,1) ) - 5;
x_max = max( X(:,1) ) + 5;
y_min = min( X(:,2) ) - 5;
y_max = max( X(:,2) ) + 5;
z_min = min( X(:,3) ) - 5;
z_max = max( X(:,3) ) + 5;

dx = (x_max - x_min) / N;
dy = (y_max -  y_min) / N;
dz = (z_max - z_min) / N;
dX = [ dx dy dz ];

[x,y,z] = meshgrid( x_min:dx:x_max,y_min:dy:y_max,z_min:dz:z_max );


[d,d_x,d_y,d_z] = distance_vol( X(:,1)',X(:,2)',X(:,3)',x,y,z,dX );
phi_init = cube_SDF( size(d),7,dX );
phi = phi_init;

%phi = ones(30,30,30);
%phi(10:20,10:20,10:20) = -1;
%phi = double((phi > 0).*(bwdist(phi < 0)-0.5) - (phi < 0).*(bwdist(phi > 0)-0.5));

ghostcell_width = 3;
reinit_iterations = 100;
spatial_deriv_order = 3;
dphi_dt = 0;
dt=.7;
for i=1:10000
[phi_x,phi_y,phi_z] = computeUpwindDerivatives3D( phi, ...
                                                           d_x,d_y,d_z, ...
                                                           ghostcell_width, ...
                                                           dX, spatial_deriv_order );
dphi_dt = phi_x.*d_x + phi_y.*d_y + phi_z.*d_z;
phi = -dphi_dt*dt + phi;
phi = reinitializeLevelSetFunction(phi, ...
                                    ghostcell_width, ...
                                    dX, ...
                                    reinit_iterations );

end

