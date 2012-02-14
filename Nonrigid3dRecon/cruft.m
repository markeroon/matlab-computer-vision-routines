%{
usable_pixel = silhouetteIm;
num_pixels = sum(usable_pixel(:) == 1);
x_vec = ones(num_pixels,1);
y_vec = ones(num_pixels,1);
x_dash_vec = ones(num_pixels,1);
y_dash_vec = ones(num_pixels,1);
idx = 1;
for i=1:size( silhouetteIm,1 )
    for j=1:size( silhouetteIm,2 )
        if silhouetteIm(i,j) == 1
            x_vec(idx) = y(i,j);
            x_dash_vec(idx) = y(i,j) + bestshiftsL(i,j);
            y_vec(idx) = x(i,j);
            y_dash_vec(idx) = x(i,j);
            idx = idx+1;
        end        
    end
end
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
[x_vec,y_vec,x_dash_vec,y_dash_vec] = ...
    extractPairsFromRectifiedMapGenericIndexing( silhouetteIm,z_one,X,Y );
[ X1,X2,X3 ] = get3dPoints( x_vec,y_vec,P{1},x_dash_vec,y_dash_vec,P{5} );
%}

depth_im = imread( '~/Data/BreakdancerDepthMaps/depthcam0f000.bmp' );
depth_im_2 = imread( '~/Data/BreakdancerDepthMaps/depthcam3f000.bmp' );

filename = '~/Data/BreakdancerDepthMaps/calibParamsbreakdancers.txt';
fid = fopen( filename, 'r' );

b = fscanf(fid, '%d\n%g %g %g\n%g %g %g\n%g %g %g\n%g %g\n%g %g %g %g\n%g %g %g %g\n%g %g %g %g\n\n' );

P = cell(8,1);
for i=1:8

K1 = [b(2 : 4)' ; b(5: 7)' ; b(8:10)' ]
distort1 = b(11:12)'
R1 = [ b(13:16)'; b(17:20)'; b(21:24)' ]
b = b(25:end); % removes all elements we've just processed

P{i} = K1 * R1;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[Xi,Yi] = meshgrid( 300:700,450:-1:50 );
I2 = interp2(X,Y,z_one,Xi,Yi,'bilinear',NaN);