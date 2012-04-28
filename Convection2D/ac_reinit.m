function u = ac_reinit(u)
% FUNCTION U_SDF = AC_REINIT(U)
% Reinitialization of the levelset U. Calculate the sign distance function
% of the zero-set of the input function U.
%   Input: 
%       U --- Input levelset. 
%   Output:
%       U_SDF --- Signed distance function based on the zero-set of the
%           input levelset.
%
% Example:
%     u = (imread('coins.png') > 100)-.5; 
%     u_sdf = ac_reinit(u); 
%     imshow(u_sdf,[]); colormap(jet); 


if ndims(u) == 2
    %% Extract zero-set.
    c = contours(u,[0,0]);
    xy = zy_extract_pt_from_contours(c);
    if isempty(xy), u = []; return; end
    %% Generate sign distance function.
    u0 = zeros(size(u));
    u0(sub2ind(size(u), round(xy(2,:)),round(xy(1,:)))) = 1;
    u = bwdist(u0).*sign(u);
elseif ndims(u) == 3
%     %% Extract zero-set
     iso = isosurface(u,0);
%     %% Generate sign distance function.
     u0 = zeros(size(u));
     idx = sub2ind(size(u), round(iso.vertices(:,1)), ...
         round(iso.vertices(:,2)), round(iso.vertices(:,3)));
     u0(idx) = 1;

%    u0 = zy_binary_boundary_detection(uint8(u>0)); 
    % NOTE: bwdist for 3D is just too slow, so fast marching is applied.
     u  = bwdist(u0).*sign(u); 
%    u = ac_distance_transform_3d(u0).*sign(u); 
end
