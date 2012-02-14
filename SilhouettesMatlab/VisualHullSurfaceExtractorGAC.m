function [x,y,z,phi] = VisualHullSurfaceExtractorGAC( visHull )
    %
    visHullInv = double(~visHull);
    
    Nx = 100;
    Ny = 100;
    Nz = 100;
    x_lo = -0.1;%-0.08;
    x_hi = 0.1;%0.05; 
    y_lo = -0.1;%-0.03;
    y_hi = 0.1;%0.09; 
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

    x_lo_int = -100;%-0.08;
    x_hi_int = 100;%0.05; 
    y_lo_int = -100;%-0.03;
    y_hi_int = 100;%0.09; 
    z_lo_int = -100;%-0.08;
    z_hi_int = 100;
    dx_int = (x_hi_int-x_lo_int)/Nx;
    dy_int = (y_hi_int-y_lo_int)/Ny;
    dz_int = (z_hi_int-z_lo_int)/Nz;
    dX_int = [dx_int dy_int dz_int];
    X_int = (x_lo_int:dx_int:x_hi_int)';
    Y_int = (y_lo_int:dy_int:y_hi_int)';
    Z_int = (z_lo_int:dz_int:z_hi_int)';
    [x_int,y_int,z_int] = meshgrid(X_int,Y_int,Z_int); 
    
    %phi_init = (x_int).^2 + (y_int).^2 + (z_int).^2 - 0.008;
    phi_init = (x_int).^2 + (y_int).^2 + (z_int).^2 - 8.0;
    %phi_init = phi_init * 10000;
    phi = ac_reinit( phi_init );
    
    delta_t = 2; n_iters = 25;
    contour_weight = 1; expansion_weight = 1;
    phi = ac_GAC_model(visHullInv, phi, contour_weight, expansion_weight, ...
                        delta_t, n_iters, 0 );
    phi(1,:,:) = 100;
    phi(101,:,:) = 100;
    phi(:,1,:) = 100;
    phi(:,101,:) = 100;
    phi(:,:,1) = 100;
    phi(:,:,101) = 100;
end