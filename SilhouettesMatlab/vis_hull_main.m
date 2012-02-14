Ny = 30; Nz = 30;
x_lo = -0.1;%-0.08;
x_hi = 0.1;%0.05;
y_lo = 0;
y_hi = 0.13;%0.09;
z_lo = -0.1;%-0.08;
z_hi = 0.1;%0.03;
dx = (x_hi-x_lo)/Nx;
dy = (y_hi-y_lo)/Ny;
dz = (z_hi-z_lo)/Nz;
dX = [dx dy dz];
X = (x_lo:dx:x_hi)';
Y = (y_lo:dy:y_hi)';
Z = (z_lo:dz:z_hi)';
[x,y,z] = meshgrid(X,Y,Z);

[visualHull] = VisHull( x,y,z );