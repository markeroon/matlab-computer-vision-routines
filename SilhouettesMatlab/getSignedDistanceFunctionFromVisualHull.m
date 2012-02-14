% visHull is a 3d volume where occupied voxels contain a '1', and unoccupied 
% voxels contain a '0'
function [phi] = getSignedDistanceFunctionFromVisualHull( visHull ) %, nx,ny,nz )    
    if ~exist( 'ac_GAC_model.m', 'file' )
        addpath( '/home/mbrophy/ComputerScience/AOSLevelSetSegmentationToolbox' );
    end
    
    offset_x = size(visHull,1) / 2;
    offset_y = size(visHull,2) / 2;
    offset_z = size(visHull,3) / 2;
    % create phi
    X = 1:size(visHull,1); %nx;%1:101;
    Y = 1:size(visHull,2); %ny;%1:101;
    Z = 1:size(visHull,3); %nz;%1:101;
    [x,y,z] = meshgrid( X,Y,Z );

    %  want contour to stop at edge of visual hull, where it equals zero.
    %  thus, we invert the visual hull's values
    visHullInv = double(~visHull);
    %isosurface(visHullInv)
    % initialize a spherical signed distance function
    phi = (x-offset_x).^2 + (y-offset_y).^2 + (z-offset_z).^2 - (72.0*72.0);
    %phi = (x-50).^2 + (y-50).^2 + (z-50).^2 - 2000.0;
    
    n_iters = 25; delta_t = 1.0;
    contour_weight = 1.0;  expansion_weight = 1.0; show_result = 0;

    phi = ac_GAC_model( visHullInv, phi, contour_weight, expansion_weight, delta_t, n_iters, show_result );
    phi = ac_reinit(phi);
    
    phi(1,:,:) = 82;
    phi(101,:,:) = 82;
    phi(:,1,:) = 82;
    phi(:,101,:) = 82;
    phi(:,:,1) = 82;
    phi(:,:,101) = 82;
end