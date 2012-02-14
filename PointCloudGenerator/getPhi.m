function [phi] = getPhi( x,y,z )
    
x_lo = min(x(:));
x_hi = max(x(:));
y_lo = min(y(:));
y_hi = max(y(:));
z_lo = min(z(:));
z_hi = max(z(:));

%offset_x = (x_hi-x_lo)/2;
%offset_y = (y_hi-y_lo)/2;
%offset_z = (z_hi-z_lo)/2;

radius = 0.025;

phi = 4*(x).^2 + (y).^2 + 4*(z).^2 - radius*radius;
end