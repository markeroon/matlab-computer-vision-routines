function registered_tumor = register_gtv( ...
                names, ...
				segmentation, ...
				staple_primary_idx, ...
				primary_seg_idx )

addpath('../PointCloudGenerator' );
addpath(genpath('../third_party/CPD2/'));
addpath('../plant_registration');


num_segmentations = size(segmentation,1); %% added may2

% print 'em out
names{staple_primary_idx}
names{primary_seg_idx}

X = cell(num_segmentations,1);
%data = cell(num_segmentations,1);
for i=1:num_segmentations

    b = segmentation{i};
    b_x=[];b_y=[];b_z=[];
    for j = 1:size(b,1)
        b_x = [b_x; b{j}(:,1)];
        b_y = [b_y; b{j}(:,2)];
        b_z = [b_z; b{j}(:,3)];
    end
    
    X{i} = [b_x,b_y,b_z];
    
end

opt.viz = 1;
opt.max_it = 70;
opt.rotation = 1; % 1 is strictly rotation; no reflection
opt.scale = 0;
opt.normalize = 1;
opt.fgt = 2; % switch to truncated at the end;
opt.lambda = 8;
opt.tol=1e-10;
opt.outliers = 0.0;
opt.method = 'nonrigid_lowrank';
opt.beta = 2; %possible that less than this is too much ram

if length(staple_primary_idx) ~= 1
    error( 'problem with extracting staple primary idx' )
end
registered_tumor = cell(length(primary_seg_idx),1);
for i=1:length(primary_seg_idx)
     Y = X{primary_seg_idx(i)};
     [T] = cpd_register(X{staple_primary_idx},Y,opt);
     registered_tumor{i} = T;
     registered_tumor{i}.flow_vec = T.W;
     registered_tumor{i}.flow_magnitude = ...
             sqrt(sum(registered_tumor{i}.flow_vec.^2,2));
     registered_tumor{i}.variance_of_flow_mag = ...
             var( registered_tumor{i}.flow_magnitude );
     registered_tumor{i}.name = names{primary_seg_idx(i)};
     [neighbour_id,neighbour_dist] = kNearestNeighbors(...
             Y,X{staple_primary_idx}, 1 );
     registered_tumor{i}.nearest_neighbour_dist = neighbour_dist;
     registered_tumor{i}.rms_e = ...
             sqrt( sum(neighbour_dist(:)) / length(neighbour_dist(:)) );
end

end
