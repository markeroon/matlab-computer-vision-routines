function phi = ac_SDF_2D(type, dims, varargin)
% FUNCTION U = AC_SDF_2D(TYPE, DIMS, VARARGIN)
% Generate some patterns of 2D sign distance functions.
%   Inputs:
%       TYPE --- Type of the pattern. Can be one of "circle", "rectangle", 
%               "circle_array" and "chess_box".
%       DIMS --- Size of the pattern.
%       VARARGIN --- For "circle", {center, radius}. For "rectangle",
%           {margin to the boundary}. For "circle_array", {radius of each
%           circle, distance between ajacent circles}. For "chess_box",
%           {number of rows, number of columns}.
%   Output:
%       U --- Pattern generated as levelset. 
%
% Example:
%     dims = [300,400];         
%     center = [100,200]; radius =  100;     
%     phi1 = ac_SDF_2D('circle', dims, center, radius); 
%     
%     margin = 100; 
%     phi2 = ac_SDF_2D('rectangle', dims, margin); 
%     
%     radius = 80; circle_distance = 100; 
%     phi3 = ac_SDF_2D('circle_array', dims, radius, circle_distance); 
%     
%     n_rows = 4; n_cols = 5; 
%     phi4 = ac_SDF_2D('chess_box', dims, n_rows, n_cols); 
%     
%     figure; 
%     subplot(221); imshow(phi1,[]); 
%     subplot(222); imshow(phi2,[]); 
%     subplot(223); imshow(phi3,[]); 
%     subplot(224); imshow(phi4,[]); 
%     colormap(jet); 

%%
if nargin < 2 || isempty(type)
    type = 'circle';
end

switch lower(type)
    case 'circle'
        fcn = @circle_SDF; 
    case 'rectangle'
        fcn = @rectangle_SDF; 
    case 'circle_array'
        fcn = @circle_array_SDF; 
    case 'chess_box'
        fcn = @chess_box_SDF; 
    otherwise
        error('Unrecognised type %s.', upper(type)); 
end
phi = feval(fcn, dims, varargin{:}); 

%%
function phi = circle_SDF(dims, center, radius)
if nargin < 2 
    center = dims(2:-1:1)/2; 
end
if nargin < 3 
    radius = 1/3*min(dims);
end
[X,Y] = meshgrid(1:dims(2),1:dims(1));
phi = radius - sqrt((X-center(1)).^2 + (Y-center(2)).^2);

%%
function phi = rectangle_SDF(dims, margin)
if nargin < 2 
    margin = 4; 
end

top = margin; 
left = margin; 
bottom= dims(1) - margin + 1; 
right = dims(2) - margin + 1; 
phi = zeros(dims); 
phi(top, left:right) = 1; 
phi(bottom, left:right) = 1; 
phi(top:bottom, left) = 1; 
phi(top:bottom, right) = 1; 

phi = -bwdist(phi); 
phi(top:bottom, left:right) = - phi(top:bottom, left:right); 

%%
function phi = circle_array_SDF(dims, radius, circle_dist)
% circle_dist - distance between two circles
phi = zeros(dims); 
phi(round(circle_dist/2):circle_dist:dims(1),...
    round(circle_dist/2):circle_dist:dims(2)) = 1; 
phi = radius - bwdist(phi); 

%%
function phi = chess_box_SDF(dims, n_row, n_col)
r = round(1:(dims(1)-1)/n_row:dims(1)); 
c = round(1:(dims(2)-1)/n_col:dims(2)); 
% build the signed matrix
s = ones(dims);
for j = 1:1:length(c)-1
    col_idx = c(j):c(j+1)-1; 
    black_or_white = mod(j+1,2); 
    for i = 1:1:length(r)-1
        black_or_white = ~black_or_white; 
        if black_or_white
            s(r(i):r(i+1)-1, col_idx) = -1;
        end
    end
end

% build the zeros set
phi = zeros(dims); 
for i = 1:length(c)
    phi(:,c(i)) = 1; 
end
for i = 1:length(r)
    phi(r(i),:) = 1; 
end

% build the SDF
phi = bwdist(phi); 
phi = phi.*s; 