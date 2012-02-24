b_x=[];b_y=[];b_z=[];
for i = 1:10
    b_x = [b_x; b{i}(:,1)];
    b_y = [b_y; b{i}(:,2)];
    b_z = [b_z; b{i}(:,3)];
end
Data.vertex.x = b_x;
Data.vertex.y = b_y;
Data.vertex.z = b_z;
addpath('Code/file_management/');
ply_write(Data,'~/Data/tumor.ply' );