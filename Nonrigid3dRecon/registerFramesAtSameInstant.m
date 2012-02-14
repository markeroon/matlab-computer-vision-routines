function [ X_rigid,Y_rigid,Z_rigid ] = registerFramesAtSameInstant( k )
%REGISTERFRAMESATSAMEINSTANT Take the 6 frames from the same timestamp
%and register them

num_rigid_iters = 30;
num_nonrigid_iters = 0;
lambda = 1; beta = 1;

MinZ =44.;
MaxZ = 120.;
X2 = cell(4,1);
Y2 = cell(4,1);
Z2 = cell(4,1);
j=1;
for i=0:2:6
    
depth_im_1 = imread( sprintf('~/Data/BreakdancerDepthMaps/depthcam%df%03d.bmp', [i k]) );
depth_im_2 = imread( sprintf('~/Data/BreakdancerDepthMaps/depthcam%df%03d.bmp',[(i+1) k]) );

z_one = getZImage( depth_im_1,MinZ,MaxZ );
z_two = getZImage( depth_im_2,MinZ,MaxZ );
%{    
z_1 = 1.0/((double(depth_im_1)/255.0)*(1.0/MinZ - 1.0/MaxZ) + 1.0/MaxZ);
z_2 = 1.0/((double(depth_im_2)/255.0)*(1.0/MinZ - 1.0/MaxZ) + 1.0/MaxZ);
%where z(r,c) is the z or depth value (in x,y,z coordinates, 
%the optical center of the 5th camera is the origin of the world coordinates.)  
%P(r,c) is the intensity value and MinZ is 44.0 and MaxZ is 120.0.

z_one = z_1(:,:,1);
z_two = z_2(:,:,1);
%}
[X,Y] = meshgrid( 0:size(z_one,2)-1,size(z_one,1)-1:-1:0);

silhouetteImOne = z_one > 55 & z_one < 60;
silhouetteImTwo = z_two > 55 & z_two < 60;


X_vec =  get3dPointsFromDepthMap( silhouetteImOne,X,Y,z_one );
Y_vec =  get3dPointsFromDepthMap( silhouetteImTwo,X,Y,z_two );

[Y1_registered,Y2_registered,Y3_registered,Trans] = ...
           registerToReferenceRangeScan( X_vec',Y_vec', ...
                                         num_rigid_iters,num_nonrigid_iters, ...
                                         lambda, beta )
X2{j} = [ X_vec(1,:) Y1_registered' ];
Y2{j} = [ X_vec(2,:) Y2_registered' ];
Z2{j} = [ X_vec(3,:) Y3_registered' ];
j=j+1;

end

X3 = cell(2,1);
Y3 = cell(2,1);
Z3 = cell(2,1);
j=1;
for i=1:2:3
   X = [X2{i}',Y2{i}',Z2{i}'];
   Y = [X2{i+1}',Y2{i+1}',Z2{i+1}'];
   %{
   for z=1:4
       Y_dash = R*Y' + repmat(t,size(Y,1),1)';
       Y = Y_dash';
   end
   %}
   %[X_new,Y_new,Z_new] = register_surface_subdivision_upper_bound( ...
   %                                        X,Y,num_rigid_iters,num_nonrigid_iters );
   [Y1_registered,Y2_registered,Y3_registered,Trans] = ...
           registerToReferenceRangeScan( X,Y, ...
                                          num_rigid_iters,num_nonrigid_iters, ...
                                          lambda, beta );
   
   X3{j} = [X2{i} Y1_registered'];
   Y3{j} = [Y2{i} Y2_registered'];
   Z3{j} = [Z2{i} Y3_registered'];
   j=j+1;
end

X = [X3{1}',Y3{1}',Z3{1}'];
Y = [X3{2}',Y3{2}',Z3{2}'];
[Y1_registered,Y2_registered,Y3_registered,Trans] = ...
           registerToReferenceRangeScan( X,Y, ...
                                          num_rigid_iters,num_nonrigid_iters, ...
                                          lambda, beta );
X_rigid = [X3{1} Y1_registered'];
Y_rigid = [Y3{1} Y2_registered'];
Z_rigid = [Z3{1} Y3_registered'];

end

