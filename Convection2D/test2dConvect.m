if ~exist( 'cubeSDF.m', 'file' )
    addpath( '/home/mbrophy/ComputerScience/CubeToCubeEvolution/' );
end
if ~exist( 'ac_reinit.m', 'file' )
    addpath( '/home/mbrophy/ComputerScience/AOSLevelSetSegmentationToolbox/' );
end
if ~exist( 'reinitBoundaries.m', 'file' )
    addpath( '/home/mbrophy/ComputerScience/SphereToPlaneEvolution/' );
end
%dims = [60 60 60];
dims = [50 50 50];

S = ones(dims);
S( 15:3:35,15:3:35,15:3:35 ) = 0;
S( 18:31,18:31,18:31 ) = 1;
%S( 80:3:120,80:3:120,80:3:120 ) = 0;
%S( 84:116,84:116,84:116) = 1;

d = bwdist( ~S );

%[y,x,z] = meshgrid( 1:60,1:60,1:60 );
[y,x,z] = meshgrid( 1:dims(1),1:dims(2),1:dims(3) );

offset_x = dims( 1 ) / 2;
offset_y = dims( 2 ) / 2;
offset_z = dims( 3 ) / 2;

%radius = 22;
%radius = 50;
%phi = (x-offset_x).^2 + (y-offset_y).^2 + (z-offset_z).^2 - (radius*radius);
margins = [10 10 10];
phi = cubeSDF( dims,margins );



delta_t = 0.00001;
n_iters =100;
grad_weight = 1.;
curvature_weight = 15.;
p = 2;
%[phi2,dmag,H,dphidt] = convect3d( phi, d,delta_t, n_iters,grad_weight,curvature_weight );
%[phi2,dmag,H,dphidt] = gradientDistFlow(phi,d,delta_t,n_iters, p );
[phi2,nabla_dnabla_phi] = convect3dSimple( phi,d,delta_t,n_iters );