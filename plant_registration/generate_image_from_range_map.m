% consider using sqrt distance map from origin for sift feature matching
addpath( '~/Code/file_management' );

filename_1 = '~/Data/PiFiles/20100204-000083-010.3pi';
filename_2 = '~/Data/PiFiles/20100204-000083-011.3pi';

[X1,Y1,Z1,gray_val_1] = import3Pi( filename_1 );
[X2,Y2,Z2,gray_val_2] = import3Pi( filename_2 );

x_min = min(X1);
y_min = min(Y1);

x_max = max(X1);
y_max = max(Y1);

gray_val_norm = gray_val_1 / max(gray_val_1)
scatter(X1,Y1,3,gray_val_norm)

%[X,Y] = meshgrid( int32(x_min):int32(x_max), int32(y_min):int32(y_max) );
%im = interp2( gray_val_1,X,Y );