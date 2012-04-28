addpath( '/home/mbrophy/Software/RectifKitE/' );
%addpath( '/home/mbrophy/ComputerScience/LevelSetsAOS3D/' );
addpath( '/home/mbrophy/Software/stereoflowlinux' );
%addpath( '/home/mbrophy/ComputerScience/LevelSetsSegmentation/' );

I_ref = imread( '/home/mbrophy/ComputerScience/dinoRing/dinoR0001.png' );

IL = imread( '/home/mbrophy/ComputerScience/dinoRing/dinoR0013.png' );
IR = imread( '/home/mbrophy/ComputerScience/dinoRing/dinoR0014.png' );
[a,P,numImages] = dinoFileRead( );

pm_ref = P{1};
pml = P{13};
pmr = P{14};
ml = [0;0];

[F1,epi_ref1,epil] = fund(pm_ref,pml);
[F2,epi_ref2,epir] = fund(pm_ref,pmr);

[T_ref1,TL,pm_ref1,pml1] = rectify(pm_ref,pml);
[T_ref2,TR,pm_ref2,pmr1] = rectify(pm_ref,pmr);

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

% warp tie points
mlx = p2t(TL,ml);

shiftrange = [-80:80];
%JL_gray = rgb2gray( JL );
%JR_gray = rgb2gray( JR );
%[bestshiftsL_gray, occlL_gray, bestshiftsR_gray, occlR_gray] = ...
%    stereoCorrespond(JL_gray, JR_gray, shiftrange);

[bestshiftsL, occlL, bestshiftsR, occlR] = ...
    stereoCorrespond(JL, JR, shiftrange, 50);