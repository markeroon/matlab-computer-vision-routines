function [ dirac_image ] = dirac_im( psi, eps_val )
%DIRAC_IM Gets approximate dirac delta of a 2d image
%   eps_val is the spacing of the level set function
    dirac_image = zeros(size(psi));
    for i = 1:size(dirac_image,1)
        for j = 1:size(dirac_image,2)
	    for k = 1:size(dirac_image,3)
                dirac_image(i,j,k) = dirac_eps(psi(i,j,k),eps_val);
            end
        end
    end
end

