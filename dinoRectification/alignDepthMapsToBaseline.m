function [ A out ] = alignDepthMapsToBaseline( P,silhouetteIm,bestshiftsLArr, NUM_IMAGES )
%ALIGNDEPTHMAPSTOBASELINE Align depth maps to a single reference frame

    Pi = ones(3,4, 2); %NUM_IMAGES);
    for i = 1:2 %NUM_IMAGES
        Pi(:,:,i) = P{i};
    end
    
    algs = {'cvpr07', 'bmvc07', 'cvpr08'};
    options = ojw_default_options(algs{2});
    options.dim_out = [0 0 480 640]; % Output image dimensions: [start_x-1 start_y-1 width height]
    options.imout = 1; % Index of projection matrix to use for output
    options.nclosest = [1 4]; % Input images to use, in terms of distance of camera centres from output view
    a = 2;
    
    %num_points_extracted = 0;
    % extract points from depth maps
    %for i=1:size(silhouetteIm{2},1)
    %    for j=1:size(silhouetteIm{2},2)
    %        if silhouetteIm{2}(i,j) == 1 
    %            num_points_extracted = num_points_extracted + 1;
    %            points(1,num_points_extracted) = i;
    %            points(2,num_points_extracted) = j;
    %            points(3,num_points_extracted) = bestshiftsLArr{2}(i,j);
    %        end
    %    end
    %end
    
    disps = -45:45;
    
    save(['dinoR' 'data.mat', points,disps,Pi );
    a = 1;
    [A out] = ibr_render(options, Pi(:,:,a));
end