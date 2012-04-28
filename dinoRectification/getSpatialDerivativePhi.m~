function [phi_x_ENO3_3d,phi_y_ENO3_3d,phi_z_ENO3_3d] = ...
    getSpatialDerivativePhi( phi, d, ghostcell_width, dX )
%GETSPATIALDERIVATIVEPHI get WENO derivative of phi, velocity is
% gradient of d

    [phi_x_plus, phi_y_plus, phi_z_plus, ...
         phi_x_minus, phi_y_minus, phi_z_minus] = ...
        HJ_ENO3_3D(phi, ghostcell_width, dX);
end

