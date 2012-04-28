addpath( '/home/mbrophy/Software/RectifKitE/' );
addpath( '/home/mbrophy/ComputerScience/LevelSetsAOS3D/' );
addpath( '/home/mbrophy/Software/stereoflowlinux' );
addpath( '/home/mbrophy/ComputerScience/LevelSetsSegmentation/' );

I_2 = imread( '/home/mbrophy/ComputerScience/dinoRing/dinoR0002.png' );
I_13 = imread( '/home/mbrophy/ComputerScience/dinoRing/dinoR0013.png' );

[a,P,numImages] = dinoFileRead( );

pml = P{2};
pmr = P{13};
ml = [0;0];


% Epipolar geometry
[F,epil,epir] = fund(pml,pmr);
% --------------------  RECTIFICATION
disp('---------------------------------- rectifying...')

%  rectification without centeriing
[TL2_13,TR2_13,pml2_13,pmr2_13] = rectify(pml,pmr);
% centering LEFT image
p = [size(IL_2,1)/2; size(IL_13,2)/2; 1];
px = TL2_13 * p;
dL = p(1:2) - px(1:2)./px(3) ;
% centering RIGHT image
p = [size(IR,1)/2; size(IR,2)/2; 1];
px = TR * p;
dR = p(1:2) - px(1:2)./px(3) ;

% vertical diplacement must be the same
dL2_13(2) = dR(2);
%  rectification with centering
[TL,TR,pml1,pmr1] = rectify(pml,pmr,dL,dR);

disp('---------------------------------- warping...')
% find the smallest bb containining both images
%bb = mcbb(size(IL),size(IR), TL, TR);

% warp RGB channels,
%for c = 1:3
    % Warp LEFT
%    [JL(:,:,c),bbL,alphaL] = imwarp(IL(:,:,c), TL, 'bilinear', bb);
%    % Warp RIGHT
%    [JR(:,:,c),bbR,alphaR] = imwarp(IR(:,:,c), TR, 'bilinear', bb);
%end

% warp tie points
%mlx = p2t(TL,ml);

%shiftrange = [-45:45];
%[bestshiftsL, occlL, bestshiftsR, occlR] = ...
 %   stereoCorrespond(JL, JR, shiftrange);

pml2_13 = pml1;
pmr2_13 = pmr1;
JL2_13 = JL;
JR2_13 = JR;


%%% now again
IL = imread( '/home/mbrophy/ComputerScience/dinoRing/dinoR0002.png' );
IR = imread( '/home/mbrophy/ComputerScience/dinoRing/dinoR0014.png' );

pml = P{2};
pmr = P{14};
ml = [0;0];
%JL = ones(size(IL));
%JR = ones(size(IR));

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
%[TL,TR,pml1,pmr1] = rectify(pml,pmr,dL,dR);

disp('---------------------------------- warping...')
% find the smallest bb containining both images
bb = mcbb(size(IL),size(IR), TL, TR);

% warp RGB channels,
for c = 1:3
    % Warp LEFT
    [JL2_14(:,:,c),bbL2,alphaL2] = imwarp(IL(:,:,c), TL, 'bilinear', bb);
    % Warp RIGHT
    [JR2_14(:,:,c),bbR2,alphaR2] = imwarp(IR(:,:,c), TR, 'bilinear', bb);
end

%bb = 
%for c = 1:3
    % warp first

% warp tie points
mlx = p2t(TL,ml);

shiftrange = [-45:45];
%JL_gray = rgb2gray( JL );
%JR_gray = rgb2gray( JR );
[bestshiftsL2, occlL2, bestshiftsR2, occlR2] = ...
    stereoCorrespond(JR2_13, JR2_14, shiftrange);
