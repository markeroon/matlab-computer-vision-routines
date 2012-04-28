dims = [106 106];

S = ones(dims);
% remember from Computer Arch!
S(20,20) = 0;
S(35:5:65,35) = 0;
S(35:5:65,65) = 0;
S(35,35:5:65) = 0;
S(65,35:5:65) = 0;
dist_im = bwdist( ~S );

addpath( '~/Code/third_party/AOSLevelSetSegmentationToolbox/' );
addpath( '~/Code/third_party/LSMLIB/' );
phi = ac_SDF_2D( 'rectangle', [106 106], 12 );

dx = 1;
dy = 1;

ghostcell_width = 3;
dX = [1. 1.];
spatial_derivative_order = 5;

d_x  = (dist_im(3:end,:) - dist_im(1:end-2,:))/2/dx;
d_y  = (dist_im(:,3:end) - dist_im(:,1:end-2))/2/dy;

[dist_x,dist_y] = gradient(dist_im);

[phi_x,phi_y] = UPWIND_HJ_ENO3_2D(phi,dist_x,dist_y,ghostcell_width, dX);

%{
d_x  = d_x(ghostcell_width:end-ghostcell_width+1, ...
                 1+ghostcell_width:end-ghostcell_width);
d_y  = d_y(1+ghostcell_width:end-ghostcell_width, ...
              ghostcell_width:end-ghostcell_width+1);
           
velocity{1} = d_y;
velocity{2} = d_x;
            Nx = 100; Ny = 100;


% set up time integration parameters
cfl_number = 0.4;
%dt = cfl_number/(abs(V_x)/dx+abs(V_y)/dy);
dt = 0.6;
t_start = 0;
t_end = 200;

% initialize time
t_cur = t_start;

addpath( '~/Code/third_party/LSMLIB/' );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% main time integration loop for TVD RK1 (forward euler)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while (t_cur < t_end)

  % fill boundary cells 
  phi(1:ghostcell_width,:) = ...
    phi(Ny+1:ghostcell_width+Ny,:);
  phi(Ny+ghostcell_width+1:end,:) = ...
    phi(ghostcell_width+1:2*ghostcell_width,:);
  phi(:,1:ghostcell_width) = ...
    phi(:,Nx+1:ghostcell_width+Nx);
  phi(:,Nx+ghostcell_width+1:end) = ...
    phi(:,ghostcell_width+1:2*ghostcell_width);

  % advance level set function
  phi = advancePhiTVDRK1(phi, velocity, ghostcell_width, ...
                         dX, dt, cfl_number, spatial_derivative_order);
  
    % compute normal velocity
  phi_x  = (phi(3:end,:) - phi(1:end-2,:))/2/dx;
  phi_y  = (phi(:,3:end) - phi(:,1:end-2))/2/dy;
  phi_xy = (phi_y(3:end,:) - phi_y(1:end-2,:))/2/dx;
  phi_xx = (phi(3:end,:) - 2*phi(2:end-1,:) + phi(1:end-2,:))/dx/dx;
  phi_yy = (phi(:,3:end) - 2*phi(:,2:end-1) + phi(:,1:end-2))/dy/dy;

  phi_x  = phi_x(ghostcell_width:end-ghostcell_width+1, ...
                 1+ghostcell_width:end-ghostcell_width);
  phi_y  = phi_y(1+ghostcell_width:end-ghostcell_width, ...
                 ghostcell_width:end-ghostcell_width+1);
  phi_xy = phi_xy(ghostcell_width:end-ghostcell_width+1, ...
                  ghostcell_width:end-ghostcell_width+1);
  phi_xx = phi_xx(ghostcell_width:end-ghostcell_width+1, ...
                  1+ghostcell_width:end-ghostcell_width);
  phi_yy = phi_yy(1+ghostcell_width:end-ghostcell_width, ...
                  ghostcell_width:end-ghostcell_width+1);

  grad_phi = sqrt(phi_x.^2 + phi_y.^2);

  curvature = ( phi_x.*phi_x.*phi_yy ...
              - 2*phi_x.*phi_y.*phi_xy ...
              + phi_y.*phi_y.*phi_xx)./grad_phi.^3;

   velocity_curv{1} = -curvature;
   phi = advancePhiTVDRK1(phi, velocity_curv, ghostcell_width, ...
                         dX, dt, cfl_number, ...
                         spatial_derivative_order);

  phi = ac_reinit(phi);
  % update current time
  t_cur = t_cur + dt
end
contour( phi,[0 0])
%}