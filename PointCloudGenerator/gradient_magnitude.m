function [abs_grad_phi] = gradient_magnitude( phi,dx,dy,dz )
addpath( '~/Code/LevelSetsMethods3D/' );

Vn = ones(size(phi)+6);
Vn(4:end-3,4:end-3,4:end-3) = phi;

data_ext = zeros(size(phi)+6);
data_ext(4:end-3,4:end-3,4:end-3) = phi;

% Calculate the derivatives (both + and -)
phi_x_minus = zeros(size(phi)+6);
phi_x_plus = zeros(size(phi)+6);
phi_y_minus = zeros(size(phi)+6);
phi_y_plus = zeros(size(phi)+6);
phi_z_minus = zeros(size(phi)+6);
phi_z_plus = zeros(size(phi)+6);
phi_x = zeros(size(phi)+6);
phi_y = zeros(size(phi)+6);
phi_z = zeros(size(phi)+6);

for k = 1:size(phi,3)
    % first scan the rows
    for i=1:size(phi,1)
    	phi_x_minus(i+3,:,k+3) = der_ENO3_minus(data_ext(i+3,:,k+3), dx);	
        phi_x_plus(i+3,:,k+3) = der_ENO3_plus(data_ext(i+3,:,k+3), dx);	
        phi_x(i+3,:,k+3) = select_der_normal(Vn(i+3,:,k+3), phi_x_minus(i+3,:,k+3), phi_x_plus(i+3,:,k+3));
    end
end

for k = 1:size(phi,3)
    % then scan the columns
    for j=1:size(phi,2)
        phi_y_minus(:,j+3,k+3) = der_ENO3_minus(data_ext(:,j+3,k+3), dy);	
        phi_y_plus(:,j+3,k+3) = der_ENO3_plus(data_ext(:,j+3,k+3), dy);	
        phi_y(:,j+3,k+3) = select_der_normal(Vn(:,j+3,k+3), phi_y_minus(:,j+3,k+3), phi_y_plus(:,j+3,k+3));
    end
end

for i=1:size(phi,1)
    for j=1:size(phi,2)
        phi_z_minus(i+3,j+3,:) = der_ENO3_minus(data_ext(i+3,j+3,:), dz);	
        phi_z_plus(i+3,j+3,:) = der_ENO3_plus(data_ext(i+3,j+3,:), dz);	
        phi_z(i+3,j+3,:) = select_der_normal(Vn(i+3,j+3,:), phi_z_minus(i+3,j+3,:), phi_z_plus(i+3,j+3,:));
    
    end
end

abs_grad_phi = sqrt(phi_x.^2 + phi_y.^2 + phi_z.^2);
abs_grad_phi = abs_grad_phi(4:end-3,4:end-3,4:end-3);
end