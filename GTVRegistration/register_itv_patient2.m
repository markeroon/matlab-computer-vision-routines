function registered_tumor = register_itv_patient2( ...
					patient_num, ...
					staple_primary_idx,...
					primary_seg_idx )

data = open('../../Data/ITV_Workspace.mat');
addpath('../PointCloudGenerator' );
addpath(genpath('../third_party/CPD2/'));
addpath('../plant_registration');
switch patient_num
    case 1
        names = data.names_patient001;
        segmentation = data.rois_patient001;
        num_segmentations = size(segmentation,2);
    case 2
        names = data.names_patient002;
        segmentation = data.rois_patient002;
        num_segmentations = size(segmentation,2);
    case 3
        names = data.names_patient003;
        segmentation = data.rois_patient003;
        num_segmentations = size(segmentation,2);
    case 4
        names = data.names_patient004;
        segmentation = data.rois_patient004;
        num_segmentations = size(segmentation,2);
    case 5
        names = data.names_patient005;
        segmentation = data.rois_patient005;
        num_segmentations = size(segmentation,2);
    case 6
        names = data.names_patient006;
        segmentation = data.rois_patient006;
        num_segmentations = size(segmentation,2);
    case 7
        names = data.names_patient007;
        segmentation = data.rois_patient007;
        num_segmentations = size(segmentation,2);
    case 8
        names = data.names_patient008;
        segmentation = data.rois_patient008;
        num_segmentations = size(segmentation,2);
    case 9
        names = data.names_patient009;
        segmentation = data.rois_patient009;
        num_segmentations = size(segmentation,2);
    case 10
        names = data.names_patient010;
        segmentation = data.rois_patient010;
        num_segmentations = size(segmentation,2);

end
% print 'em out
names{staple_primary_idx}
names{primary_seg_idx}

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

opt.viz = 1;
opt.max_it = 70;
opt.rotation = 1;
opt.scale = 0;
opt.normalize = 1;
opt.fgt = 2;
opt.lambda = 3;
opt.method = 'nonrigid_lowrank';
opt.beta = 2; %possible that less than this is too much ram


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
