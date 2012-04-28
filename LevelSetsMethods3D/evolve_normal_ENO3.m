function [delta, H1_abs, H2_abs,H3_abs] = evolve_normal_ENO3(phi, dx, dy, dz, Vn)
%
% Finds the amount of evolution under a force in
% normal direction and using 3rd order accurate ENO scheme
%
% Author: Baris Sumengen  sumengen@ece.ucsb.edu
% http://vision.ece.ucsb.edu/~sumengen/
%
% adapted by Mark Brophy (mbrophy5@csd.uwo.ca)

%delta = zeros(size(phi)+6);
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

H1_abs = abs(Vn.*phi_x.^2 ./ (abs_grad_phi+dx*dx*(abs_grad_phi == 0)));
H2_abs = abs(Vn.*phi_y.^2 ./ (abs_grad_phi+dy*dy*(abs_grad_phi == 0))); % changed to dy on Dec 10
H3_abs = abs(Vn.*phi_z.^2 ./ (abs_grad_phi+dz*dz*(abs_grad_phi == 0)));
H1_abs = H1_abs(4:end-3,4:end-3,4:end-3);
H2_abs = H2_abs(4:end-3,4:end-3,4:end-3);
H3_abs = H3_abs(4:end-3,4:end-3,4:end-3);

delta = Vn.*abs_grad_phi;
delta = delta(4:end-3,4:end-3,4:end-3);


