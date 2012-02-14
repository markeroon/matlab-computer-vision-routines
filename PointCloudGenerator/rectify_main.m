addpath( '~/Code/third_party/RectifKitE/' );
addpath( '~/Code/file_management/' );
addpath( '~/Code/third_party/OpenVis3D/' );
addpath( '~/Code/SurfaceFitting/' );
addpath( '~/Code/filtering/mahalanobis/' );
%addpath( '~/Code/SilhouettesMatlab/' );
%addpath( '~/Code/LevelSetsMethods3D/' );
%addpath( '~/Code/third_party/LSMLIB/' );
addpath( '~/Code/image_functions/' );

THRESH_VAL = 0.18;
[a,P,numImages] = dinoFileRead( '~/Data/dinoRing/dinoR_par.txt' );
NUM_IMAGES = numImages;
pml_arr = cell(NUM_IMAGES,1);
X1_vec = [];    X2_vec = [];    X3_vec = [];
Nx = 65; Ny = 64; Nz = 60;

%x_lo = -0.075;  y_lo = -0.050; z_lo = -0.08;
%x_hi = 0.025; y_hi =  0.090; z_hi = 0.03;
x_lo=-0.022; y_lo = 0.020; z_lo = -0.017845;
x_hi=0.051; y_hi = 0.109; z_hi = 0.056;
X_sav = cell(16,1);
Y_sav = cell(16,1);
Z_sav = cell(16,1);

dx = (x_hi-x_lo)/Nx;
dy = (y_hi-y_lo)/Ny;
dz = (z_hi-z_lo)/Nz;
dX = [dx dy dz];
X = x_lo:dx:x_hi;
Y = y_lo:dy:y_hi;
Z = z_lo:dz:z_hi;
[x,y,z] = meshgrid(X,Y,Z);
%[phi,silhouettes] = VisHull( x,y,z );
%phi = computeDistanceFunction3d(phi,dX);
h = min(dX);

half_window_size = 5; % defining NCC window size for outlier filtering 
stereo_im  = cell(NUM_IMAGES,1);
%dispMap = cell(NUM_IMAGES,1);
hold on
for i = 1:NUM_IMAGES - 1
clear JL JR IL IR x_vec y_vec x_dash_vec y_dash_vec 
clear bestshiftsL bestshiftsR pml1 pmr1
%filename_prev = sprintf( '~/Data/dinoRing/dinoR%04d.png', i-1 );
filenameL = sprintf( '~/Data/dinoRing/dinoR%04d.png', i+1 );
filenameR = sprintf( '~/Data/dinoRing/dinoR%04d.png',i );
IL = imread( filenameL );   IR = imread( filenameR );
%I_prev = imread( filename_prev );
pml = P{i+1};
pmr = P{i};
ml = [0;0];

[JL,pml1,JR,pmr1] = rectifyCalibratedImagePair( IL, pml, IR, pmr); %rectifyAndCenter( IL,pml,IR,pmr );
[bestshiftsL, occlL, bestshiftsR, occlR] = OvStereoMatlab(JL, JR, -70, 70,50);
%JL = rgb2gray(JL);
%JR = rgb2gray(JR);
%[dispMap{i}] = denseMatch( JL,JR,9,0,50,'ZNCC' );

silhouetteIm = im2bw( im2double( rgb2gray ( JL ) ), THRESH_VAL );
%silhouetteIm = im2bw( im2double( JL ), THRESH_VAL );
silhouetteIm =  bwmorph( silhouetteIm, 'dilate', 5 );
silhouetteIm =  bwmorph( silhouetteIm, 'erode', 4 );
[x_vec,y_vec,x_dash_vec,y_dash_vec] = extractPairsFromRectifiedDisparityMap( silhouetteIm,bestshiftsL,occlL );

[ X1,X2,X3 ] = get3dPoints( x_vec,y_vec,pml1,x_dash_vec,y_dash_vec,pmr1 );
%[X1,X2,X3,confidence] = filterPointsUsingPreviousImage( X1,X2,X3, P{i-1},I_prev,P{i},IL,half_window_size );

X1_vec = [X1_vec X1];%(idx)];
X2_vec = [X2_vec X2];%(idx)];
X3_vec = [X3_vec X3];%(idx)];

end % end for loop


X_vec = [ X1_vec', X2_vec', X3_vec' ];
n=2;
radius = 0.00000025;
tic
[f_vb,f_fb,f_vm_d,f_vm_nd,f_reach] = ...
    kernel_density_est_mahal_fast( X_vec,radius,n );
toc


 exportOffFile( X1_vec2,X2_vec2,X3_vec2,...
     sprintf( '~/Data/range_maps/point_cloud_vishull-%d-%d-%d-%d-%d-%f.off', ...
     clock ) );