data = open('../../Data/ITV_Workspace.mat')
addpath('../PointCloudGenerator' );
addpath(genpath('../third_party/CPD2/'));
addpath('../plant_registration');
names = data.names_patient002;
segmentation = data.rois_patient002;
num_segmentations = size(segmentation,2);
X = cell(num_segmentations,1);
data = cell(num_segmentations,1);
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
staple_primary_idx = 2;
primary_seg_idx = [4 6 8 10 12 14 15 18 20 22];
%indices_prim_ten_percent = [22 42 58 94];
%vals = names{indices_prim_ten_percent}

opt.viz = 1;
opt.max_it = 70;
opt.rotation = 1;
opt.scale = 0;
opt.normalize = 1;
opt.fgt = 2;
opt.lambda = 3;
opt.method = 'nonrigid_lowrank';
opt.beta = 2; %possible that less than this is too much ram

%{
beta = 2;
lambda = 3;
fgt = 0;
scale = 1;
%}
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