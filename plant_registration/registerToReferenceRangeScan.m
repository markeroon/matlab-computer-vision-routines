% REGISTERTOREFERENCERANGESCAN Registers a range scan (X2,Y2,Z2) to 
% reference range scan (X1,Y1,Z1)
function [X2_registered,Y2_registered,Z2_registered,...
          Transform_rigid,Transform_nonrigid,...
          C_r,C_nr] = ...
           registerToReferenceRangeScan( model_no_ground,scene_no_ground, ...
                                         num_rigid_iters,num_nonrigid_iters, ...
                                         lambda, beta, fgt_val,scale ) 
                                 

% [0,1,2] if > 0, then use FGT. case 1: 
% FGT with fixing sigma after it gets too 
% small (faster, but the result can be rough)
%  case 2: FGT, followed by truncated Gaussian 
% approximation (can be quite slow after switching
%to the truncated kernels, but more accurate than case 1)

if nargin == 6
    opt.fgt = 0;
    opt.scale = 0;
    sprintf( 'fgt = 0, scale = 0' )
elseif nargin == 7
    opt.scale = 0;
    opt.fgt = fgt_val;
    sprintf( 'scale = 0' )
elseif nargin == 8
    opt.scale = scale;
    opt.fgt = fgt_val;
    sprintf( 'scale = %d', scale )
else
    error( 'insufficient args' )
end

C_r = [];
C_nr = [];
Transform_rigid = [];
Transform_nonrigid = [];                                    
% Set the options for registration of the half-spheres
opt.method='rigid'; % use rigid registration
opt.viz=1;          % show every iteration
opt.outliers=0; %0.1;don't account for outliers   % use 0.5 noise weight

opt.normalize=0; %1;    % normalize to unit variance and zero mean before registering (default)
opt.scale=1; %1;        % estimate global scaling too (default)
opt.rot=1;         % estimate strictly rotation
opt.corresp=0;      % do not compute the correspondence vector at the end of registration (default). Can be quite slow for large data sets.

opt.lambda = lambda;
opt.beta = beta;
opt.max_it= num_rigid_iters;     % max number of iterations
opt.tol= 1e-10;       % tolerance
 
if num_rigid_iters > 0
    % registering the half-spheres
    [Transform_rigid,C_r] = cpd_register(model_no_ground,scene_no_ground,opt);
    scene_rigid_transform = [ Transform_rigid.Y(:,1), Transform_rigid.Y(:,2), Transform_rigid.Y(:,3) ];
else
    scene_rigid_transform = scene_no_ground;
end
%opt.fgt = 0;
opt.method = 'nonrigid'; %_lowrank';
%%%%%%%%%%%%%%%%%%%%%opt.sigma = 10; %does not appear to be useful

if num_nonrigid_iters > 0
    opt.max_it = num_nonrigid_iters;
    [Transform_nonrigid,C_nr] = cpd_register( model_no_ground,scene_rigid_transform,opt );
    X2_registered = Transform_nonrigid.Y(:,1);
    Y2_registered = Transform_nonrigid.Y(:,2);
    Z2_registered = Transform_nonrigid.Y(:,3);
elseif num_rigid_iters > 0
    X2_registered = Transform_rigid.Y(:,1);
    Y2_registered = Transform_rigid.Y(:,2);
    Z2_registered = Transform_rigid.Y(:,3);
else
    error( 'Both iters_rigid and iters_nonrigid = 0' )
end