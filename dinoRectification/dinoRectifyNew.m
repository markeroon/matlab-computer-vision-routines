addpath( '~/Code/third_party/RectifKitE/' );
addpath( '~/Code/file_management/' );
addpath( '~/Code/third_party/stereoflowlinux/' );
addpath( '~/Code/third_party/LSMLIB/' );
addpath( '~/Code/geometry/' );
addpath( '~/Code/convection_3d' );

THRESH_VAL = 0.18;

[a,P,numImages] = dinoFileRead( '~/Data/dinoSparseRing/dinoSR_par.txt' );
NUM_IMAGES = numImages;
bestshiftsLArr = cell(NUM_IMAGES,1);
silhouetteImArr = cell(NUM_IMAGES,1);

X1_vec = [];
X2_vec = [];
X3_vec = [];

for i = 1:6:NUM_IMAGES - 1
clear JL
clear JR

filenameL = sprintf( '~/Data/dinoSparseRing/dinoSR%04d.png', i );
filenameR = sprintf( '~/Data/dinoSparseRing/dinoSR%04d.png',i+1 );

IL = imread( filenameL );
IR = imread( filenameR );

pml = P{i};
pmr = P{i+1};
ml = [0;0];

[JL,pml1,JR,pmr1] = rectifyAndCenter( IL,pml,IR,pmr );
shiftrange = [-35:35];
[bestshiftsL, occlL, bestshiftsR, occlR] = stereoCorrespond(JL, JR, shiftrange,30);

%bestshiftsLArr{i,1} = bestshiftsL;

silhouetteIm = im2bw( im2double( rgb2gray ( JL ) ), THRESH_VAL );
silhouetteIm =  bwmorph( silhouetteIm, 'dilate', 10 );
silhouetteIm =  bwmorph( silhouetteIm, 'erode', 7 );
silhouetteImArr{i,1} = silhouetteIm;

[x_vec,y_vec,x_dash_vec,y_dash_vec] = extractPairsFromRectifiedDisparityMap( silhouetteIm,bestshiftsL );

[ X1,X2,X3 ] = extract3dPointsFromDisparityPairs( x_vec,y_vec,pml1,x_dash_vec,y_dash_vec,pmr1 );

X1_vec = [X1_vec X1];
X2_vec = [X2_vec X2];
X3_vec = [X3_vec X3];

size(X1_vec)
end

Nx = 100; Ny = 100; Nz = 100;
ghostcell_width = 3;
%Nx_with_ghostcells = Nx+2*ghostcell_width;
%Ny_with_ghostcells = Ny+2*ghostcell_width;
%Nz_with_ghostcells = Nz+2*ghostcell_width;

%x_lo = min(X1);
%x_hi = max(X1);
%y_lo = min(X2);
%y_hi = max(X2);
%z_lo = min(X3);
%z_hi = max(X3);
    
%-0.061; %0.018;
%-0.018; %0.068;
%-0.057; %0.015;
%dx = (x_hi-x_lo)/Nx;
%dy = (y_hi-y_lo)/Ny;
%dz = (z_hi-z_lo)/Nz;
%dX = [dy dx dz];
%X = (x_lo:dx:x_hi)';
%Y = (y_lo:dy:y_hi)';
%Z = (z_lo:dz:z_hi)';
%[x,y,z] = meshgrid( X,Y,Z );
%X = (x_lo-(ghostcell_width-0.5)*dx:dx:x_hi+ghostcell_width*dx)';
%Y = (y_lo-(ghostcell_width-0.5)*dy:dy:y_hi+ghostcell_width*dy)';
%Z = (z_lo-(ghostcell_width-0.5)*dz:dz:z_hi+ghostcell_width*dz)';
%[x,y,z] = meshgrid(X,Y,Z); 
sprintf( 'getting distance function from points...' )
[dist,d_x,d_y,d_z,x,y,z] = distance_vol( X1_vec,X2_vec,X3_vec,Nx,Ny,Nz,ghostcell_width);
sprintf( 'done' )

phi = cubeSDF( size(dist),[4 4 4] );

velocity{1} = d_x;
velocity{2} = d_y;
velocity{3} = d_z;

%offset_x = -0.025; offset_y = 0.025; offset_z = -0.025;
%radius = 0.05;
%phi_init = (x-offset_x).^2 + (y-offset_y).^2 + (z-offset_z).^2 - (radius*radius);

mask = [];
spatial_discretization_order = 1;

%phi = computeDistanceFunction3d(...
%                phi_init,dX,[],spatial_discretization_order );


delta_t = 0.0001;
n_iters = 1000;
grad_weight = 1.;
curvature_weight = 1.;
%[phi2,dmag,kappa,dphidt] = convect3d( phi, dist,dX,delta_t, ...
%    n_iters,grad_weight,curvature_weight,Ny,Nx,Nz,ghostcell_width );



%{
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

% warp tie points
mlx = p2t(TL,ml);
%}



%Nx = 70;
%Ny = 70;
%Nz = 70;


%dx = (x_hi-x_lo)/Nx;
%dy = (y_hi-y_lo)/Ny;
%dz = (z_hi-z_lo)/Nz;

%[Y,X,Z] = meshgrid( y_lo:dy:y_hi, x_lo:dx:x_hi, z_lo:dz:z_hi );

%x = 0.01; y = 0.02; z = -0.01;


%X1 = X1_c{1};
%X2 = X2_c{1};
%X3 = X3_c{1};
%for i=2:numImages
%    X1 = [X1 X1_c{i}];
%    X2 = [X2 X2_c{i}];
%end


%{
p1T = pml1(1,:);
p2T = pml1(2,:);
p3T = pml1(3,:);

pdash_1T = pmr1(1,:);
pdash_2T = pmr1(2,:);
pdash_3T = pmr1(3,:);
%}
%{
num_silhouette_elements = sum(sum(silhouetteIm{1}));

points = ones(4,1,num_silhouette_elements);
X1 = ones(1,num_silhouette_elements);
X2 = ones(1,num_silhouette_elements);
X3 = ones(1,num_silhouette_elements);
for i=1:num_silhouette_elements
    if mod(i,1000) == 0
        sprintf( 'iter num %d',i )
    end
    x = x_vec(i);
    y = y_vec(i);
    x_dash = x_dash_vec(i);
    y_dash = y_dash_vec(i); 

    A = [ x * p3T - p1T ;
        y * p3T - p2T ;
        x_dash * pdash_3T - pdash_1T ;
        y_dash * pdash_3T - pdash_2T ];
  
    % X is the last column of V, where A = UDV' is the SVD of A.
    [U D V] = svd( A );
    X = V(:,4);
    X = X / X(4); % normalize
    X1(i) = X(1);
    X2(i) = X(2);
    X3(i) = X(3);
    points(:,:,i) = X;
end
%}

%{
points_l = ones(sum(sum(silhouetteIm{1})),2);
points_r = ones(sum(sum(silhouetteIm{1})),2);
x = ones(sum(sum(silhouetteIm{1})),1);
y = ones(sum(sum(silhouetteIm{1})),1);
x_dash = ones(sum(sum(silhouetteIm{1})),1);
y_dash = ones(sum(sum(silhouetteIm{1})),1);


idx = 1;
for i=1:size( JL,2 )
    for j=1:size( JL,1 )
        if( silhouetteIm{1}(j,i) == 1 )
            %xl(idx) = j;
            points_l(idx,1) = i;
            %x(idx,1) = i;
            points_r(idx,1) = i + bestshiftsL(j,i);
            %x_dash(idx,1) = i + JL(j,i);
            points_l(idx,2) = j;
            %y(idx,1) = j;
            points_r(idx,2) = j;
            %y_dash(idx,1) = j;
            idx = idx+1;
        end
    end
end



fid = fopen( 'points_l.txt', 'wt' );
fprintf( fid, '%d\n', idx );
fprintf( fid, '\n' );
fprintf( fid, '%d %d \n', points_l' );
fclose( fid );

fid = fopen( 'points_r.txt', 'wt' );
fprintf( fid, '%d\n', idx );
fprintf( fid, '\n' );
fprintf( fid, '%d %d \n', points_r' );
fclose( fid );

fid = fopen( 'P_l.txt', 'wt' );
fprintf( fid, '%f %f %f %f \n', pml1' );
fclose( fid );

fid = fopen( 'P_r.txt', 'wt' ); 
fprintf( fid, '%f %f %f %f \n', pmr1' );
fclose( fid );
%}

%fid = fopen('d1.txt', 'wt');
%fprintf(fid, '%6.2f %12.8f\n', y);
%fclose(fid)


%[A R t] = art( pml1 );
%R_inv = inv(R);
%t_inv = -t;

%Rt_inv = ones(3,4);
%Rt_inv( 1:3,1:3 ) = R_inv(:,:);
%Rt_inv( 1:3,4 ) = t_inv(:,:);

%X = [20 ; 30 ; 15 ; 1.0 ];



%{
JL2 = rgb2gray(JL);
JR2 = rgb2gray(JR);
dx = zeros(size(JL)); %,'single');
DbasicSubpixel= zeros(size(JL), 'single');
halfTemplateWidth = 5;  halfTemplateHeight = 5;
template = ones(2*halfTemplateWidth+1,2*halfTemplateHeight+1);
ROI = ones(size(template,1),size(template,2)+2);
% scan over all rows
for i = 20*halfTemplateHeight+1:size(JL,1)-20*halfTemplateHeight
    % scan over all columns
    for j = 20*halfTemplateWidth+1:size(JL,2)-20*halfTemplateWidth
        template(:,:) = JL2(i-halfTemplateHeight:i+halfTemplateHeight, ...
            j-halfTemplateWidth:j+halfTemplateWidth );
        if size( unique(template),1 ) ~= 1 % check template isn't uniform
            ROI(:,:) = JR2( i-halfTemplateHeight:i+halfTemplateHeight, ...
                j-halfTemplateWidth+bestshiftsR(i,j)-1:j+halfTemplateWidth+bestshiftsR(i,j)+1 );
            m = normxcorr2(template,ROI);
            dx(i,j) = bestshiftsR(i,j) + ...
                (  ( m(11,10) - m(11,13) ) / ...
                    2.0*(m(11,11) - m(11,12) + m(11,13)) );
        else
            dx(i,j) = bestshiftsR(i,j);
        end
    end
end

dx2 = dx + abs(min(dx(:)));
dx2_norm = dx2 / max(dx2(:));
imagesc(dx2_norm);
%}



%{
x_vec = ones(num_silhouette_elements,1);
y_vec = ones(sum(sum(silhouetteIm{1})),1);
x_dash_vec = ones(sum(sum(silhouetteIm{1})),1);
y_dash_vec = ones(sum(sum(silhouetteIm{1})),1);

idx = 1;
for i=1:size( JL,2 )
    for j=1:size( JL,1 )
        if( silhouetteIm{1}(j,i) == 1 )
            x_vec(idx) = i;
            x_dash_vec(idx) = i + bestshiftsL(j,i);
            y_vec(idx) = j;
            y_dash_vec(idx) = j;
            idx = idx+1;
        end
    end
end
%}
