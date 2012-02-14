function R = quat2rmat(quaternion)
% Converts (unit) quaternion representations to (orthogonal) rotation matrices R
% 
% Input: A 4xn matrix of n quaternions
% Output: A 3x3xn matrix of corresponding rotation matrices
%
% http://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation#From_a_quaternion_to_an_orthogonal_matrix

q0(1,1,:) = quaternion(1,:);
qx(1,1,:) = quaternion(2,:);
qy(1,1,:) = quaternion(3,:);
qz(1,1,:) = quaternion(4,:);

R = [q0.^2+qx.^2-qy.^2-qz.^2 2*qx.*qy-2*q0.*qz 2*qx.*qz+2*q0.*qy;
     2*qx.*qy+2*q0.*qz q0.^2-qx.^2+qy.^2-qz.^2 2*qy.*qz-2*q0.*qx;
     2*qx.*qz-2*q0.*qy 2*qy.*qz+2*q0.*qx q0.^2-qx.^2-qy.^2+qz.^2];

% Alternative formula:
% http://en.wikipedia.org/wiki/Rotation_matrix#Quaternion
%  R = [1-2*qy^2-2*qz^2 2*qx*qy-2*q0*qz 2*qx*qz+2*q0*qy;
%      2*qx*qy+2*q0*qz 1-2*qx^2-2*qz^2 2*qy*qz-2*q0*qx;
%      2*qx*qz-2*q0*qy 2*qy*qz+2*q0*qx 1-2*qx^2-2*qy^2];