function [phi_re] = reinitLevelSet3D( phi,dX )

    phi_ext = ones(size(phi)+6);
    phi_ext(4:end-3,4:end-3,4:end-3) = phi;
    spatial_derivative_order = 3;
    ghostcell_width = 3;
    h = min( dX ); % added by Mark, Dec 10, 2010

    S_phi_0 = phi./sqrt(phi.^2 + h.^2); % also changed on Dec 10 (to h from x)
    velocity{1} = S_phi_0;


    cfl_number = 0.3;
    dt = cfl_number/(1/dX(1)^2 + 1/dX(2)^2 + 1/dX(3)^2)
    t = 0;
    t_end = dt*20;

    while( t < t_end )
        phi_ext = advancePhiTVDRK1(phi_ext, velocity, ghostcell_width, ...
                         dX, dt, cfl_number, ...
                         spatial_derivative_order);
        t = t+dt; 
    end
    phi_re = phi_ext(4:end-3,4:end-3,4:end-3);
end