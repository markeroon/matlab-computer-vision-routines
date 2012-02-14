function [h, contour_pt] = zy_plot_contours(c, varargin)
% [H, CONTOUR_PT] = ZY_PLOT_CONTOURS(C, VARARGIN)
% Plot the result from Matlab CONTOURS function. This function is often
% used to outline the zero-set of a levelset function.  
%   Inputs: 
%       C --- Data returned from the CONTOURS function. 
%       VARARGIN --- Variable input arguments used to feed into the PLOT
%           function controlling the properties of plotted curves.
%   Outputs:
%       H --- Handles for curves.
%       CONTOUR_PT --- Coordinates of the points on the contour.
%
% Example: 
%   I = imread('trees.tif'); imshow(I,[]); hold on;
%   c = contours(I,[100,100]);
%   [h, pt] = zy_plot_contours(c, 'r', 'linewidth', 2);
%   pause; delete(h); plot(pt(1,:),pt(2,:),'.'); 

idx = 1;
count = 1;
if nargout > 1, contour_pt = []; end
dim = size(c,1); 

while idx < size(c,2)
    n = c(2,idx);
    if dim == 2
        h(count) = plot(c(1,idx+1:idx+n), c(2,idx+1:idx+n), varargin{:});
    elseif dim == 3
        h(count) = plot3(c(1,idx+1:idx+n), c(2,idx+1:idx+n), ...
            c(3,idx+1:idx+n),  varargin{:});
    end
    
    if nargout > 1, 
        contour_pt = [contour_pt, c(:,idx+1:idx+n)];
    end
        
    count = count+1;
    idx = idx+n+1;
end