function [divmag] = div2d( phi )
    [phi_y,phi_x] = gradient( phi );
    
    [phi_xy,phi_xx] = gradient(phi_x);
    [phi_yy,phi_yx] = gradient(phi_y);
    divmag = phi_xx + phi_yy; %+phi_zz;
end