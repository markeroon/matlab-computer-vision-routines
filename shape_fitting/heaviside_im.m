function [ heaviside_image ] = heaviside_im( psi, eps_val )
%DIRAC_IM Gets approximate dirac delta of a 2d image
%   eps_val is the spacing of the level set function
    heaviside_image = zeros(size(psi));
    for i = 1:size(heaviside_image,1)
        for j = 1:size(heaviside_image,2)
            for k = 1:size(heaviside_image,3)
               heaviside_image(i,j,k) = .5 * (1.0 + ((2.0/pi) * atan(psi(i,j,k)/eps_val) ));
            end
        end
    end
end

