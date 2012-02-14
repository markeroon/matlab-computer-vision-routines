addpath( '~/Code/third_party/AOSLevelSetSegmentationToolbox/' );
addpath( '~/Code/third_party/LSMLIB/' );
addpath( '~/Code/PointCloudGenerator/' );
addpath( '~/Code/LevelSetsMethods3D/' );
addpath( '~/Code/filtering/' );
addpath( '~/Code/file_management/' );
addpath( '~/Code/filtering/mahalanobis/' );
clear

inc = 2;
NUM_NOISE_LEVELS = 10;
dataset = 'BUDDHA';
hundred_percent_noise = 5;
roc_x = cell( NUM_NOISE_LEVELS,1 );
roc_y = cell( NUM_NOISE_LEVELS,1 );
roc_x_fixed = cell( NUM_NOISE_LEVELS,1 );
roc_y_fixed = cell( NUM_NOISE_LEVELS,1 );
%for i=1:2:NUM_NOISE_LEVELS
    i = 1;
    [roc_x{i},roc_y{i}] = filterPointCloud( dataset, hundred_percent_noise );
    hundred_percent_noise = hundred_percent_noise + inc;
%end