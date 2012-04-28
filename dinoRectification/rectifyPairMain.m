addpath( '~/Code/third_party/RectifKitE/' );
addpath( '~/Code/file_management/' );
addpath( '~/Code/third_party/stereoflowlinux/' );

THRESH_VAL = 0.19;

I_ref = imread( '~/Data/dinoRing/dinoR0001.png' );
[a,P,numImages] = dinoFileRead( '~/Data/dinoRing/dinoR_par.txt' );

pm_ref = P{1};

range = [3 5];
bestshiftsLCell = cell(5,1);
silhouetteIm = cell(5,1); 

for i = range
    fileL = sprintf( '~/Data/dinoRing/dinoR%04d.png', i );
    fileR = sprintf( '~/Data/dinoRing/dinoR%04d.png', i+1 );
    IL = imread( fileL );
    IR = imread( fileR );

    pml = P{i};
    pmr = P{i+1};

    [ JL,JR ] = warpPairToReferenceFrame( I_ref,pm_ref,IL,pml,IR,pmr );

    shiftrange = [-45:45];
    [bestshiftsL, occlL, bestshiftsR, occlR] = stereoCorrespond(JL, JR, shiftrange);
    bestshiftsLCell{i} = bestshiftsL;
    silhouetteIm{i} = im2bw( im2double( rgb2gray ( JL ) ), THRESH_VAL );
    silhouetteIm{i} =  bwmorph( silhouetteIm{i}, 'dilate', 10 );
    silhouetteIm{i} =  bwmorph( silhouetteIm{i}, 'erode', 7 );
end