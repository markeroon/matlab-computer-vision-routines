data = open('../../Data/DeformStaple_allpatients.mat')
addpath(genpath('../third_party/CPD2/'));
addpath('../plant_registration');
segmentation = data.rois_patient001;
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

iters_rigid = 0;
iters_nonrigid = 70;
lambda = 3;%13; % regularization weight
beta = .1;%10; % width of gaussian
Y = ones(size(X{212}));
[Y(:,1),Y(:,2),Y(:,3),t_r,t_nr,c_r,c_nr] = ...
    registerToReferenceRangeScan(X{20}, X{212}, iters_rigid, ...                                                iters_rigid,...
                                  iters_nonrigid, lambda,...
                                  beta, 1);

lambda = 3;
beta = .1;
Y_ = ones(size(X{212}));
[Y_(:,1),Y_(:,2),Y_(:,3),t_r2,t_nr2,c_r2,c_nr2] = ...
    registerToReferenceRangeScan(X{212},Y, iters_rigid, ...                                                iters_rigid,...
                                  iters_nonrigid, lambda,...
                                  beta, 1);

                                                   
%{
b = rois_patient001{2};
b_x2=[];b_y2=[];b_z2=[];
for i = 1:size(b,1)
    b_x2 = [b_x2; b{i}(:,1)];
    b_y2 = [b_y2; b{i}(:,2)];
    b_z2 = [b_z2; b{i}(:,3)];
end

%}


Data.vertex.x = b_x;
Data.vertex.y = b_y;
Data.vertex.z = b_z;



%addpath('../file_management/');
%ply_write(Data,'~/Data/tumor.ply' );