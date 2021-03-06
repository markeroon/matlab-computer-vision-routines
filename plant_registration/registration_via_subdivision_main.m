addpath( 'file_management' );
addpath( genpath( 'third_party/coherent_point_drift/' ) ); % add subdirs
addpath( '~/Code/filtering/mahalanobis/' );
addpath( '~/Code/filtering' );
addpath('~/Code/PointCloudGenerator/')

filename_0 = '~/Data/PiFiles/20100204-000083-000.3pi';
[X0,Y0,Z0,gray_val_0] = import3Pi( filename_0 );
% remove ground plane
idx = find( Z0 < 620 );
i=1;
filename_1 = sprintf( '~/Data/PiFiles/20100204-000083-%03d.3pi', i )

[X1,Y1,Z1,gray_val_1] = import3Pi( filename_1 );
% remove ground plane
idx_1 = find( Z1 < 620 );

% sans ground plane
    
Y = [X1(idx_1)', Y1(idx_1)', Z1(idx_1)' ];
X = [X0(idx)', Y0(idx)', Z0(idx)' ];

[Y1_reg,Y2_reg,Y3_reg,Trans] = registerToReferenceRangeScan( ...
                                    X,Y,0,50 );
Y = [Y1_reg,Y2_reg,Y3_reg];

left   = min(X(:,1))
right  = max(X(:,1))
top    = max(X(:,2))
bottom = min(X(:,2))
back   = min(X(:,3))
front  = max(X(:,3))

width = ( max(X(:,1)) - min(X(:,1)) ) / 2 
height = ( max(X(:,2)) - min(X(:,2)) ) / 2 
depth = ( max(X(:,3)) - min(X(:,3)) ) / 2 


Y1_registered = [];
Y2_registered = [];
Y3_registered = [];
width = width / 2;
height = height / 2;
depth = depth / 2;

%while width > 15 & height > 15 & depth > 15

    for i=left:width:right-width
        for j=bottom:height:top-height
            for k=back:depth:front-depth
                idx = find( X(:,1) > i   & X(:,1) < i+width & ...
                            X(:,2) > j & X(:,2) < j+height & ...
                            X(:,3) > k   & X(:,3) < k+depth )
                if size(X(idx,:),1) > 10
                    Y_subset = findPointsToRegister( Y,X(idx,:),5,20 );
                    if size(Y_subset,1) > 10
                        [Y1_new,Y2_new,Y3_new,Transform] = registerToReferenceRangeScan(X(idx,:),Y_subset,40,1);%20,150
                            Y1_registered = [ Y1_registered Y1_new' ];
                            Y2_registered = [ Y2_registered Y2_new' ];
                            Y3_registered = [ Y3_registered Y3_new' ];
                    end
                end
            end
        end
    end
    %width = width / 4
    %height = height / 4
    %depth = depth / 4
    
%end