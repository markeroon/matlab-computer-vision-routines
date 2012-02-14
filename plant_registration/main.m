% Manually locate the balls in the range scans, register them using principal
% components, and then use this transformation as a starting point to register the 
% full range maps with icp, excluding the ground plane.
%
% Written by Mark Brophy, University of Western Ontario

addpath( 'file_management' );
addpath( genpath( 'third_party/coherent_point_drift/' ) ); % add subdirs
addpath( 'third_party/finite_icp/' );

filename_0 = '~/Data/PiFiles/20100204-000083-009.3pi';
filename_1 = '~/Data/PiFiles/20100204-000083-010.3pi';
filename_2 = '~/Data/PiFiles/20100204-000083-011.3pi';

[X0,Y0,Z0,gray_val_0] = import3Pi( filename_0 );
[X1,Y1,Z1,gray_val_1] = import3Pi( filename_1 );
[X2,Y2,Z2,gray_val_2] = import3Pi( filename_2 );

idx_0 = find( Z0 < 650 );

idx_1 = find( Z1 < 650 );


% remove ground plane 
scene_no_ground = [X0(idx_0)', Y0(idx_0)', Z0(idx_0)' ];
model_no_ground = [X1(idx_1)', Y1(idx_1)', Z1(idx_1)' ];

% Set the options for registration of the half-spheres
opt.method='nonrigid_lowrank'; % use rigid registration
opt.viz=1;          % show every iteration
opt.outliers=0.5;   % use 0.5 noise weight

opt.normalize=0; %1;    % normalize to unit variance and zero mean before registering (default)
opt.scale=0; %1;        % estimate global scaling too (default)
opt.rot=0;         % estimate strictly rotational matrix (default)
opt.corresp=0;      % do not compute the correspondence vector at the end of registration (default). Can be quite slow for large data sets.

opt.max_it= 300;%100;     % max number of iterations
opt.tol= 1e-4;       % tolerance
opt.fgt=1;          % [0,1,2] if > 0, then use FGT. case 1: FGT with fixing sigma after it gets too small (faster, but the result can be rough)
                    %  case 2: FGT, followed by truncated Gaussian approximation (can be quite slow after switching to the truncated kernels, but more accurate than case 1)

 

% registering the half-spheres
Transform_nonrigid =cpd_register(model_no_ground,scene_no_ground,opt);
plot3(scene_no_ground(:,1),scene_no_ground(:,2),scene_no_ground(:,3),'ob','markersize',1)
hold on
plot3(Transform_nonrigid.Y(:,1),Transform_nonrigid.Y(:,2),Transform_nonrigid.Y(:,3),'og','markersize',1)





% locate balls manually in first scan
idx_1_1 = find( X1 > 55 & X1 < 100 & Z1 > 700 & Z1 < 750 & Y1 > 440 & Y1 < 500);
idx_1_2 = find( X1 > 113 & X1 < 150 & Z1 > 700 & Z1 < 730 & Y1 > 200 & Y1 < 250);
idx_1_3 = find( X1 > 100 & X1 < 150 & Z1 > 675 & Z1 < 725 & Y1 > 325 & Y1 < 395);

% ground plane
%idx_1_4 = find( X1 > 140 & Z1 > 770 );

idx_1 = [ idx_1_1 idx_1_2 idx_1_3 ];

% locate balls manually in second scan
idx_2_1 = find( X2 > 55 & Z2 > 660 & Z2 < 700 & Y2 > 375 & Y2 < 440 );
idx_2_2 = find( X2 > 100 & X2 < 200 & Z2 > 650 & Z2 < 710 & Y2 > 265 & Y2 < 320 );
idx_2_3 = find( X2 > 70 & X2 < 150 & Y2 > 150 & Y2 < 205 & Z2 > 725 & Z2 < 775 );

idx_2 = [idx_2_1 idx_2_2 idx_2_3 ];

model = [X1(idx_1)', Y1(idx_1)', Z1(idx_1)' ];
scene = [X2(idx_2)', Y2(idx_2)', Z2(idx_2)' ];

% remove ground plane 
idx = find( Z2 < 630 );
scene_no_ground = [X2(idx)', Y2(idx)', Z2(idx)' ];
idx = find( Z1 < 610 );
model_no_ground = [X1(idx)', Y1(idx)', Z1(idx)' ];

% Set the options for registration of the half-spheres
opt.method='rigid'; % use rigid registration
opt.viz=1;          % show every iteration
opt.outliers=0.5;   % use 0.5 noise weight

opt.normalize=0; %1;    % normalize to unit variance and zero mean before registering (default)
opt.scale=0; %1;        % estimate global scaling too (default)
opt.rot=0;         % estimate strictly rotational matrix (default)
opt.corresp=0;      % do not compute the correspondence vector at the end of registration (default). Can be quite slow for large data sets.

opt.max_it= 300;%100;     % max number of iterations
opt.tol= 1e-4;       % tolerance
opt.fgt=1;          % [0,1,2] if > 0, then use FGT. case 1: FGT with fixing sigma after it gets too small (faster, but the result can be rough)
                    %  case 2: FGT, followed by truncated Gaussian approximation (can be quite slow after switching to the truncated kernels, but more accurate than case 1)

 

% registering the half-spheres
Transform=cpd_register(model,scene,opt);

%figure;
%scene_trans = Transform.R*scene' + repmat(Transform.t',size(scene,1),1)';
%plot3( scene_trans(1,:),scene_trans(2,:),scene_trans(3,:),'*b','markersize',1)
%hold on
%plot3( model(:,1),model(:,2),model(:,3),'*r', 'markersize',1)

balls_transformed = Transform.R*scene' + repmat(Transform.t',size(scene,1),1)';

% using the recovered transformation from the ball registration, now use 
% icp to refine estimate
scene_no_ground_transformed = Transform.R*scene_no_ground' + repmat(Transform.t',size(scene_no_ground,1),1)';

opt.method = 'nonrigid_lowrank';
opt.tol= 1e-4;
opt.beta=.35; %2;            % the width of Gaussian kernel (smoothness)
opt.lambda=.25;          % regularization weight
Transform = cpd_register( model_no_ground,scene_no_ground_transformed',opt );


%Options.TolP = 0.00001;
%Options.Registration = 'Rigid';




% refine the ball fit using using ICP
%[model_shifted,M]=ICP_finite(balls_transformed', model,Options);

%figure;
%set(gcf, 'renderer', 'painters');
%plot3( scene_no_ground_transformed(1,:),scene_no_ground_transformed(2,:),scene_no_ground_transformed(3,:),'*b','markersize',1)
%hold on
%plot3( model_no_ground(:,1),model_no_ground(:,2),model_no_ground(:,3),'*r', 'markersize',1)


% or refine registration using full scan (excluding ground plane)
%Options.TolP = 0.00001;
%Options.Registration = 'Rigid';
%[model_shifted,M]=ICP_finite(scene_no_ground_transformed', model_no_ground,Options);
%%%model_shifted_full = movepoints(M,model_full');