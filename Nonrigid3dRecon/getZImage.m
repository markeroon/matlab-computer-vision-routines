function [ z_one ] = getZImage( depth_im_1,MinZ,MaxZ )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

z_1 = 1.0/((double(depth_im_1)/255.0)*(1.0/MinZ - 1.0/MaxZ) + 1.0/MaxZ);
%where z(r,c) is the z or depth value (in x,y,z coordinates, 
%the optical center of the 5th camera is the origin of the world coordinates.)  
%P(r,c) is the intensity value and MinZ is 44.0 and MaxZ is 120.0.

z_one = z_1(:,:,1);


end

