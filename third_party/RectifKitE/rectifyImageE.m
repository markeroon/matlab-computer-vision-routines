function rectifyImageE(img_base)
% Rectification with calibration data

% This function reads a (stereo) pair of images and respective camera matrices
% (PPMs) from files and rectify them. It outputs on files the two rectified
% images in PNG format. It reads  RGB images in PNG format.
%
% The bounding box and the transformation that has been applied
% are saved in the PNG metadata

%         Andrea Fusiello, 2007 (andrea.fusiello@univr.it)


% read reference points ml
ml = load(['data/' img_base '_points']);
% These points (in the left image) are used only for displaying the
% correspoding epipolar lines in the right image. They are not used in the
% rectification, therefore ml can be set to [0;0]


% read camera matrices pml and pmr
load(['data/' img_base '_cam'])
% The user who wants to rectify his own images must provide 
% the two camra perspective projection matrices  pml, pmr here


% At this point ml, pml and pmr are set.


% -------------------- PLOT LEFT VIEW
%figure(1)
subplot(2,2,1)
[IL] = imread(['images/' img_base '0.png'],'png');
image(IL);
axis image
title('Left image');
hold on
plot(ml(1,:), ml(2,:),'w+','MarkerSize',12);
hold off

% Epipolar geometry
[F,epil,epir] = fund(pml,pmr);


% -------------------- PLOT RIGHT VIEW
%figure(2)
subplot(2,2,2)
[IR] = imread(['images/' img_base '1.png'],'png');
image(IR);
axis image
title('Right image');
% plot epipolar lines
x1 =0;
x2 = size(IR,2);
hold on
for i =1:size(ml,2)
    liner = F * [ml(:,i) ; 1];
    plotseg(liner,x1,x2);
end
hold off


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

% warp tie points
mlx = p2t(TL,ml);

% -------------------- PLOT LEFT
%figure(3)
subplot(2,2,3)
image(JL);
axis image
hold on
title('Rectified left image');
x2 = size(JL,2);
for i =1:size(mlx,2)
    plot (mlx(1,i)-bbL(1), mlx(2,i)-bbL(2),'w+','MarkerSize',12);
end
hold off


% --------------------  PLOT RIGHT
%figure(4)
subplot(2,2,4)
image(JR);
axis image
hold on
title('Rectified right image')
x2 = size(JR,2);
for i =1:size(mlx,2)
    liner = star([1 0 0])  * [mlx(:,i) - bbL(1:2) ;  1];
    plotseg(liner,x1,x2);
end

% -------------------- SAVE FILES

imwrite(JL,['imagesE/' img_base '_R_0.png'],'png', 'Alpha', uint8(255*alphaL), ...
    'BB', num2str(bbL'), 'Xform', num2str(TL(:)'));

imwrite(JR,['imagesE/' img_base '_R_1.png'],'png', 'Alpha', uint8(255*alphaR), ...
    'BB', num2str(bbR'), 'Xform', num2str(TR(:)'));

disp(['wrote rectified images: ' 'imagesE/' img_base '_R_0.png  ' 'imagesE/' img_base '_R_1.png']);

