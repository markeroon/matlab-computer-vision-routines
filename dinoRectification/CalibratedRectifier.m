classdef CalibratedRectifier
    
properties

end
methods
    
    function obj = CalibratedRectifier( )
% CALIBRATEDRECTIFIER Take calibrated stereo pair and rectify 
%   rectify the image pair as well as the two projection matrices
    addpath( '/home/mbrophy/Software/RectifKitE/' );
    addpath( '/home/mbrophy/Software/stereoflowlinux' );
end
function [ pml1,pmr1,JL,JR,bestshiftsL,bestshiftsR ] = rectify( obj,IL,IR,pml,pmr )

    
    % Epipolar geometry
    [F,epil,epir] = fund(pml,pmr);
    % --------------------  RECTIFICATION
    disp('---------------------------------- rectifying...')

    %  rectification without centeriing
    [TL,TR,pml1,pmr1] = rectify(pml,pmr);
    % centering LEFT image
    p = [size(IL,1)/2; size(IL,2)/2; 1];
    px = TL * p;
    dL = p(1:2) - px(1:2)./px(3) ;
    % centering RIGHT image
    p = [size(IR,1)/2; size(IR,2)/2; 1];
    px = TR * p;
    dR = p(1:2) - px(1:2)./px(3) ;

    % vertical diplacement must be the same
    dL(2) = dR(2);
    %  rectification with centering
    [TL,TR,pml1,pmr1] = rectify(pml,pmr,dL,dR);

    disp('---------------------------------- warping...')
    % find the smallest bb containining both images
    bb = mcbb(size(IL),size(IR), TL, TR);

    % warp RGB channels,
    for c = 1:3
        % Warp LEFT
        [JL(:,:,c),bbL,alphaL] = imwarp(IL(:,:,c), TL, 'bilinear', bb);
        % Warp RIGHT
        [JR(:,:,c),bbR,alphaR] = imwarp(IR(:,:,c), TR, 'bilinear', bb);
    end

    ml = [0;0];
    % warp tie points
    mlx = p2t(TL,ml);

    shiftrange = [-45:45];
    [bestshiftsL, occlL, bestshiftsR, occlR] = stereoCorrespond(JL, JR, shiftrange);
end

end

end