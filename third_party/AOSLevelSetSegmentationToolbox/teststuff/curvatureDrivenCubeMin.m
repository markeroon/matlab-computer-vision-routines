Nx = 150;
Ny = 150;
Nz = 150;
x_lo = -.1;
x_hi = .1;
y_lo = -.1;
y_hi = .1;
z_lo = -.1;
z_hi = .1;
dx = (x_hi-x_lo)/Nx;
dy = (y_hi-y_lo)/Ny;
dz = (z_hi-z_lo)/Nz;
dX = [dx dy dz];
X = (x_lo:dx:x_hi)';
Y = (y_lo:dy:y_hi)';
Z = (z_lo:dz:z_hi)';
[x,y,z] = meshgrid(X,Y,Z); 

    
margin = 60; 
phi = zeros(size(x)); 
phi(margin:end-margin, margin:end-margin, margin:end-margin) = 1; 
%phi = ac_reinit(phi-.5);

%delta_t = 3; 
%for i = 1:4
%    phi = ac_curvature_flow_AOS(phi, delta_t); 
%end

%isosurface(x,y,z,phi )