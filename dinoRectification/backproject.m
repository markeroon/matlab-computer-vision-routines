function [vol] = backproject( P_l, P_r, bestShiftsR, im_l, im_r,vol,x,y,z )
%BACKPROJECT take depth map and backproject it into volume


proj_l = Projection( P_l, im_l );
proj_r = Projection( P_r, im_r );
for i = 1:size(vol,1)
    for j = 1:size(vol,2)
        for k=1:size(vol,3)
            X_i = [ x(i,j,k) ; y(i,j,k) ; z( i,j,k) ; 1.0 ];
            x_l = projectToImage( proj_l,X_i );
            x_r = projectToImage( proj_r,X_i );
            if projectsToImage( proj_l,x_l ) && projectsToImage( proj_r,x_r) && ...
                AlmostEqual(x_l(2),x_r(2),.5) && ...
                AlmostEqual(x_l(1),x_r(1) + bestShiftsR(round(x_l(2)),round(x_l(1))),.5)
                        vol(i,j,k) = 1;
            end
        end
    end
end
                

end

