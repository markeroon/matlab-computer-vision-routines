function [ x_vec,y_vec,x_dash_vec,y_dash_vec ] =  ...
    extractPairsFromRectifiedDisparityMap( silhouetteIm, ...
                                                   bestshiftsL,occlL )
% EXTRACTPAIRSFROMRECTIFIEDDISPARITYMAP extract left and right 
% corresponding % points from disparity map all returned parameters are 
% num_pixels x 1 vectors

usable_pixel(:,:) = (silhouetteIm(:,:) == 1) & (occlL(:,:) == 0);
num_pixels = sum(usable_pixel(:) == 1);
x_vec = ones(num_pixels,1);
y_vec = ones(num_pixels,1);
x_dash_vec = ones(num_pixels,1);
y_dash_vec = ones(num_pixels,1);
idx = 1;
for x=1:size( silhouetteIm,2 )
    for y=1:size( silhouetteIm,1 )
        if(silhouetteIm(y,x) == 1 && occlL(y,x)==0)
            x_vec(idx) = x - 1;
            x_dash_vec(idx) = x + bestshiftsL(y,x) - 1;
            y_vec(idx) = y - 1;
            y_dash_vec(idx) = y - 1;
            idx = idx+1;
        end
    end
end

end

